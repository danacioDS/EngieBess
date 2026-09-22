# PART 2 — PHYSICAL ASSET MODEL

## BESS Engineering Model

**Version 1.0 — Revision 6 (FC4)**

---

## 2.1 Purpose and scope of this part

This part defines the **physical model of the BESS asset**. It specifies:

- The battery energy balance and its state evolution.
- The PCS (inverter) model, including conversion losses and four-quadrant operation.
- The grid and site model, including the PCC balance.
- The load model as an input to dispatch.
- The hard constraints that bound operation at every step.

It consumes from Part 1: symbols, state definitions, sign conventions, temporal conventions, and interface contracts. It produces for Parts 3, 4, and 5: the state trajectory, the power flows, the PCS loss term, and the physical limits used by services and dispatch.

**Scope rule:** Part 2 contains component modeling. It does not define services, dispatch logic, or degradation. Those belong to Parts 3, 4, and 5.

**Revision 6 (FC4) scope:** This revision applies the three fixes the Revision 5 grade identified:

- **Trigger redesign.** Revision 5's trigger referenced `Th` at a solver-determined index (`Th_{t_last,t}`), which is **not a linear operation** and is not implementable in a MILP. Revision 6 redesigns the trigger to track `Th_last,t` — the throughput **value** at the last cycle completion — as an ordinary decision variable updated by the same big-M pattern already proven correct in Revision 5. `t_last,t` is retained only as a post-solve diagnostic, derived from the solution; it does **not** appear in any live constraint. The multi-cycle gap is now genuinely closed, including the single-cycle case that Revision 5's "backward compatibility" claim overstated.
- **Citation fix completed.** The residual "FC9/FC10" reference in §2.1 is corrected to "FC9." The changelog's claim of full citation closure is now accurate.
- **Terminology collision resolved.** Revision 5's §2.9 proposed a new unregistered category under the name "transient," which Part 1's §1.4 header already uses for a registered-but-inline category. Revision 6 **renames** the new category to **"within-horizon auxiliary quantities"** (distinct name, distinct rule) and, more importantly, **actually registers** `Th_last,t` in Part 1 via the existing transient convention (it *is* an inline, non-state, non-decision quantity in the sense Part 1 already accommodates). `t_last,t` and `m_cycle,t` are diagnostics, not symbols at all; they are not registered and are not "transient" — they are simply solver outputs.

**Item 5 status:** Closed in Revision 4, unchanged.

**Item 6 status:** Closed in Revision 4, refined in Revision 6 (the within-horizon value-tracking, not index-tracking, formulation).

**Part 1 action requested (Revision 6):** Register `Th_last,t` in Part 1 §1.4.6 (per-step degradation variables) as a within-horizon derived quantity with the transient marker. Add a one-line note in Part 1 §1.4 header clarifying that the existing "transient" convention applies to within-horizon quantities that are not solver diagnostics. No new convention is proposed; Revision 6 fits inside the existing one.

**Interface summary (Part 2):**

| Consumes from | Produces for |
|---|---|
| Symbols (Part 1) | $E_t$, $T_t$ (state) |
| SOH (Part 3) | $E_{min,t}$, $E_{max,t}$, $E_{usable,t}$ |
| Throughput $Th_t$ (Part 3) | Derating functions $f_{SOC}, f_T, g_{SOC}, g_T$ |
| Dispatch $P_{AC}^{ch}, P_{AC}^{dis}, Q_t$ (Part 5) | $P_{PCC,t}$, $P_{import,t}$, $P_{export,t}$ |
| Scenario inputs $P_{load,t}, T_{amb,t}$ | $P_{DC,t}$, $P_{DC,t}^{ch}$, $P_{DC,t}^{dis}$ |
| Reservations $R_{reg,t}^{up}, R_{reg,t}^{down}, Q_{res,t}$ (Part 4) | $S_t$, $S_t^{loss}$, $P_{loss,t}^{PCS,inc}$ |
| Absolute regulation statistics $\sigma_{reg,t}^{abs}$ (Part 4) | $\Delta Th_{cycle}$ |

---

## 2.2 Battery model

### 2.2.1 Energy balance

The stored energy evolves according to the balance at the **cell level**. The cell energy $E_t$ is defined at the beginning of interval $[t, t+1)$.

**Combined form:**

\[
E_{t+1} = E_t + \left( \eta_{c,t} \cdot P_{DC,t}^{ch} - \frac{P_{DC,t}^{dis}}{\eta_{d,t}} - \frac{P_{loss,t}^{PCS,inc}}{\eta_{PCS}} \right) \cdot \Delta t - \sigma \cdot E_t \cdot \Delta t - P_{aux}^{cell} \cdot \Delta t
\]

**Where:**

- $\eta_{c,t}, \eta_{d,t}$: time-varying cell efficiencies (section 2.2.3).
- $P_{DC,t}^{ch}, P_{DC,t}^{dis}$: directional DC power (non-negative).
- $P_{loss,t}^{PCS,inc}$: PCS incremental loss (section 2.3.4), booked on the DC side as an additional draw on the battery. See section 2.3.4 for the modeling choice justification.
- $\sigma$: self-discharge rate (1/h).
- $P_{aux}^{cell}$: auxiliary consumption converted to the cell side (section 2.2.8).
- $P_{DC,t}^{ch} \cdot P_{DC,t}^{dis} = 0$ (mutual exclusion, enforced by $z_t$ from Part 1).

### 2.2.2 Energy limits

The stored energy must satisfy:

\[
E_{min,t} \le E_t \le E_{max,t}
\]

where:

\[
E_{min,t} = E_{nom} \cdot SOH_k \cdot SOC_{min}
\]
\[
E_{max,t} = E_{nom} \cdot SOH_k \cdot SOC_{max}
\]

**Note:** $SOH_k$ is the latched SOH from Part 3, at the current epoch $k$. It is fixed within the optimization horizon (Part 1, section 1.5.8).

The usable energy is:

\[
E_{usable,t} = E_{max,t} - E_{min,t} = E_{nom} \cdot SOH_k \cdot (SOC_{max} - SOC_{min})
\]

The state of charge is derived:

\[
SOC_t = \frac{E_t}{E_{nom} \cdot SOH_k}
\]

### 2.2.3 Efficiency chain

The **authoritative inputs** are $\eta_{PCS}$ (at unity power factor) and $\eta_{RT}$ (AC-to-AC, datasheet). Cell efficiencies are derived:

\[
\eta_c = \eta_d = \sqrt{\frac{\eta_{RT}}{\eta_{PCS}^2}}
\]

**Validity check:** If $\eta_c > 1$ or $\eta_d > 1$, the input data is inconsistent. The model raises an error.

**DC-only RTE conversion:** If the datasheet gives a DC-only RTE, it must be converted first:

\[
\eta_{RT}^{AC} = \eta_{RT}^{DC} \cdot \eta_{PCS}^2
\]

**Time-varying efficiencies:** The efficiency state of health $SOH_k^{eff}$ (Part 3) scales the cell efficiencies:

\[
\eta_{c,t} = \eta_c \cdot SOH_k^{eff}
\]
\[
\eta_{d,t} = \eta_d \cdot SOH_k^{eff}
\]

The energy balance uses $\eta_{c,t}$ and $\eta_{d,t}$, not the nominal $\eta_c$ and $\eta_d$.

### 2.2.4 Nominal energy conversion from PCC-stated MWh

If the RFP states usable energy at the PCC (AC side), the conversion to cell level is:

\[
E_{nom}^{cell} = \frac{E_{PCC}^{usable}}{\eta_{PCS} \cdot \eta_d \cdot (SOC_{max} - SOC_{min})}
\]

**Explanation:** Delivering energy at AC takes more energy from the cell (divide by $\eta_{PCS}$ and $\eta_d$), and only the usable SOC window contributes (divide by the SOC window width).

**Rule:** The source of $E_{nom}$ (cell level, DC usable, or AC usable) must be stated explicitly in every scenario. The model raises an error if the source is ambiguous.

**Relation between $E_{nom}$ and $E_{nom}^{cell}$:** $E_{nom}$ is the nominal cell-level energy used throughout Part 2. When the RFP states energy at the PCC, $E_{nom}^{cell}$ is the converted value that replaces $E_{nom}$ in every downstream formula for that scenario. The two symbols are not used simultaneously: a scenario uses **either** $E_{nom}$ (when the source is already at cell level) **or** $E_{nom}^{cell}$ (when the source is at the PCC). The rule above ("the source must be stated explicitly") is what determines which one is in force.

### 2.2.5 Power limits at the cell (DC side)

The cell DC power limits are:

\[
0 \le P_{DC,t}^{ch} \le P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC}(SOC_t) \cdot g_T(T_t)
\]

\[
0 \le P_{DC,t}^{dis} \le P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC}(SOC_t) \cdot f_T(T_t)
\]

**Where:**

- $P_{batt,max}^{DC,ch}$, $P_{batt,max}^{DC,dis}$: battery DC capability from manufacturer.
- $SOH_k^{pow}$: power state of health (Part 3).
- $f_{SOC}, f_T, g_{SOC}, g_T$: derating functions (section 2.2.6).

**Binding-limit rule (Revision 4 — resolves consolidated open-item 5).** The DC limits above are **not independent constraints** on the optimizer. They are **derived consistency checks** on the AC limits in §2.3.2. The binding constraint for all operational decisions is the AC limit $P_{max,t}^{AC,ch/dis}$, which already incorporates the same derating factors (converted to the AC side) inside its $\min(\cdot)$. The optimizer sets $P_{AC,t}^{ch}$ and $P_{AC,t}^{dis}$; $P_{DC,t}^{ch}$ and $P_{DC,t}^{dis}$ are then **determined** by the AC↔DC conversion in §2.3.1.

The DC limits therefore serve two purposes:

1. **Physical sanity check.** They verify that the AC-derived DC power does not exceed the manufacturer's cell capability. If it does, the model raises an error (a scenario is mis-parameterized).
2. **Documentation of the underlying physics.** They state the cell-level capability that the AC limit is derived from.

They do **not** tighten the feasible set beyond what the AC limits already impose. If they did, derating would be applied twice — once at the cell and once at the AC side — which would understate the available power. The Revision 4 rule is that **the AC limit governs**.

**Formal statement:** For every step $t$, at every feasible point of the optimizer's constraint set, the DC power implied by the AC decisions must satisfy §2.2.5's inequalities. If it does not, the scenario's parameters are inconsistent, and the model raises an error. This is a post-solve consistency check, not a pre-solve constraint.

### 2.2.6 Derating functions

The derating functions capture the reduction of available power as a function of SOC and temperature. They are dimensionless factors in $[0, 1]$:

| Function | Range | Meaning |
|---|---|---|
| $f_{SOC}(SOC_t)$ | $[0, 1]$ | Discharge derating at low SOC |
| $f_T(T_t)$ | $[0, 1]$ | Discharge derating at low/high temperature |
| $g_{SOC}(SOC_t)$ | $[0, 1]$ | Charge derating at high SOC |
| $g_T(T_t)$ | $[0, 1]$ | Charge derating at low/high temperature |

**Typical shapes:**

- $f_{SOC}$: 1.0 above 0.20 SOC, drops linearly to 0.0 at $SOC_{min}$.
- $g_{SOC}$: 1.0 below 0.80 SOC, drops linearly to 0.0 at $SOC_{max}$.
- $f_T, g_T$: 1.0 in $[15, 35]$ °C, drops below 0 °C and above 45 °C.

**Piecewise-linear approximation:** For MILP/MISOCP compatibility, each function is approximated by $N$ linear segments (typically $N = 4$–$8$). The approximation is declared per scenario.

### 2.2.7 Self-discharge

Self-discharge is modeled as a linear loss proportional to stored energy:

\[
\Delta E_t^{self} = \sigma \cdot E_t \cdot \Delta t
\]

Typical values: $\sigma \in [10^{-5}, 5 \times 10^{-5}]$ h$^{-1}$ for Li-ion.

### 2.2.8 Auxiliary consumption

Auxiliary consumption $P_{aux}$ includes HVAC, BMS, and communications. The architecture assumption is stated explicitly:

- **Configuration A (aux through PCS):** The auxiliary load is drawn from the DC bus through the PCS. The cell-side consumption is:

\[
P_{aux}^{cell} = \frac{P_{aux}}{\eta_{PCS} \cdot \eta_{d,t}}
\]

**Note:** The time-varying $\eta_{d,t}$ is used, consistent with the main energy balance. If $SOH_k^{eff}$ degrades efficiency, aux losses degrade proportionally.

- **Configuration B (aux direct from site AC):** The auxiliary load is fed directly from the site's AC connection, independent of the PCS and battery. The cell-side consumption is:

\[
P_{aux}^{cell} = 0
\]

and $P_{aux}$ appears only in the site balance (section 2.4.1), not in the battery energy balance.

**Default assumption:** Configuration A, unless the RFP's architecture specifies otherwise.

**Rationale:** The two configurations have different implications for throughput, degradation (Part 3), and site demand charges (Part 4). The choice is a scenario-level parameter, not an implicit fact.

**Typical values:** $P_{aux} \in [1\%, 3\%]$ of $P_{max}^{AC}$.

---

## 2.3 PCS model

### 2.3.1 AC↔DC conversion

The PCS converts between the AC bus (PCC side) and the DC bus (battery side). The conversion is defined by $\eta_{PCS}$ at unity power factor.

**Charging (AC → DC):**

\[
P_{DC,t}^{ch} = P_{AC,t}^{ch} \cdot \eta_{PCS}
\]

**Discharging (DC → AC):**

\[
P_{DC,t}^{dis} = \frac{P_{AC,t}^{dis}}{\eta_{PCS}}
\]

**Sign convention:** Both $P_{AC,t}^{ch}$ and $P_{AC,t}^{dis}$ are non-negative.

**Binding direction (Revision 4).** The conversion above is deterministic in both directions. The AC decisions $P_{AC,t}^{ch}$ and $P_{AC,t}^{dis}$ are the optimizer's free variables; the DC powers are derived. This is what makes the AC limits in §2.3.2 binding and the DC limits in §2.2.5 consistency checks (see §2.2.5, "Binding-limit rule").

### 2.3.2 Power limits at the PCS (AC side)

The AC active power limits are:

\[
0 \le P_{AC,t}^{ch} \le P_{max,t}^{AC,ch}
\]
\[
0 \le P_{AC,t}^{dis} \le P_{max,t}^{AC,dis}
\]

**Where the derating is applied only to the battery-derived term, inside the $\min(\cdot)$:**

\[
P_{max,t}^{AC,ch} = \min\left(P_{max}^{AC},\; \frac{P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC}(SOC_t) \cdot g_T(T_t)}{\eta_{PCS}}\right)
\]

\[
P_{max,t}^{AC,dis} = \min\left(P_{max}^{AC},\; P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC}(SOC_t) \cdot f_T(T_t) \cdot \eta_{PCS}\right)
\]

**Explanation:** The PCS hardware rating $P_{max}^{AC}$ is a physical limit that does not depend on battery SOC or temperature. The derating functions apply only to the battery DC capability, which is converted to the AC side and then composed with the PCS rating via $\min(\cdot)$.

**Binding-limit rule (Revision 4).** These AC limits are the **binding** power constraints for the optimizer. The DC limits in §2.2.5 are consistency checks derived from the same physics. The derivation is:

- Charging: $P_{DC,t}^{ch} = P_{AC,t}^{ch} \cdot \eta_{PCS} \le P_{max,t}^{AC,ch} \cdot \eta_{PCS} = \min\left(P_{max}^{AC} \cdot \eta_{PCS},\; P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC} \cdot g_T\right)$. The first term of the $\min$ is the PCS hardware limit converted to DC; the second is the cell limit. So §2.2.5's charge inequality holds automatically whenever §2.3.2's charge inequality holds.
- Discharging: $P_{DC,t}^{dis} = P_{AC,t}^{dis} / \eta_{PCS} \le P_{max,t}^{AC,dis} / \eta_{PCS} = \min\left(P_{max}^{AC} / \eta_{PCS},\; P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC} \cdot f_T\right)$. The second term of the $\min$ is the cell limit, so §2.2.5's discharge inequality holds automatically whenever §2.3.2's discharge inequality holds.

**Consequence:** Applying §2.2.5 as an additional optimizer constraint would be redundant at best and would tighten the feasible set incorrectly if the two were ever numerically inconsistent (e.g., due to rounding in the piecewise-linear approximation of the derating functions). Revision 4 removes §2.2.5 from the optimizer's constraint set and treats it as a post-solve check. The hard constraints table (§2.6) reflects this.

### 2.3.3 Apparent power and reactive capability

**Two distinct apparent power quantities are defined.** They must not be conflated.

**Average capability apparent power $S_t$:**

\[
S_t = \sqrt{P_{AC,t}^2 + Q_{rms,t}^2}
\]

where $P_{AC,t} = P_{AC,t}^{dis} - P_{AC,t}^{ch}$ (signed) and $Q_{rms,t}$ is the RMS reactive power.

The **average capability constraint** (step averages):

\[
P_{AC,t}^2 + Q_t^2 \le S_{max}^2
\]

The **peak-based reservation constraint** (for services with within-step variation):

\[
\max\left(\left|P_{AC,t}^{base} + R_{reg,t}^{up}\right|,\; \left|P_{AC,t}^{base} - R_{reg,t}^{down}\right|\right)^2 + Q_{res,t}^2 \le S_{max}^2
\]

where:

- $P_{AC,t}^{base} = P_{AC,t}^{dis} - P_{AC,t}^{ch}$
- $R_{reg,t}^{up}, R_{reg,t}^{down}$: reserved regulation capacity (Part 4)
- $Q_{res,t}$: reserved reactive capacity (Part 4)

**Loss-model apparent power $S_t^{loss}$:**

\[
S_t^{loss} = \sqrt{P_{AC,t}^2 + \left(\sigma_{reg,t}^{abs}\right)^2 + Q_{rms,t}^2}
\]

**Note:** $S_t^{loss} \ge S_t$ because it includes the regulation variance term $\sigma_{reg,t}^{abs}$. It is used exclusively in the PCS loss model (section 2.3.4). The symbol $S_t^{loss}$ is registered in Part 1 (§1.4.3).

### 2.3.4 PCS loss model (incremental)

**Modeling choice stated explicitly:** The PCS incremental loss is booked on the DC side as an additional draw on the battery. This is a modeling choice, not a physical law. The loss is dissipated inside the PCS, not cleanly on either side. Treating it as a DC-side draw is defensible because the PCS losses reduce the effective power that reaches the cell, and the cell must compensate. An alternative convention (booking the loss on the AC side as reduced delivered power) would change the numerical results slightly and is a scenario-level choice.

**Chosen convention:** DC-side draw, with the loss divided by $\eta_{PCS}$:

\[
P_{DC,t}^{loss} = \frac{P_{loss,t}^{PCS,inc}}{\eta_{PCS}}
\]

where:

\[
P_{loss,t}^{PCS,inc} = P_{standby} + k_{quad} \cdot \left(\left(S_t^{loss}\right)^2 - P_{AC,t}^2\right)
\]

**Unit of $k_{quad}$:** The coefficient is specified by the manufacturer in **kW/kVA²** so that $k_{quad} \cdot (S_t^{loss})^2$ has units of kW. The registered unit in Part 1 (`1/kVA`) is shorthand for this. The authoritative specification is the manufacturer's datasheet; if the datasheet gives a different unit, the model converts it explicitly. No conversion is asserted in this document.

**Simplification:** When regulation is not active in the step, $\sigma_{reg,t}^{abs} = 0$, $S_t^{loss} = S_t$, and the loss term reduces to $P_{standby} + k_{quad} \cdot Q_{rms,t}^2$.

**Path into the energy balance:** The incremental loss appears explicitly in the energy balance (section 2.2.1) as $-P_{loss,t}^{PCS,inc} / \eta_{PCS} \cdot \Delta t$.

**Alternative (full loss curve):** If the manufacturer provides a full efficiency curve $\eta_{PCS}(S_t)$, the incremental model is replaced by the curve. The choice is declared per scenario.

### 2.3.5 PCS loss convexity and MILP treatment

The term $k_{quad} \cdot (S_t^{loss})^2$ is **convex** in $S_t^{loss}$. It feeds an equality energy balance, so the model is **not MILP-ready** without treatment. Two options:

**Option A — Piecewise-linear outer approximation:** Approximate $(S_t^{loss})^2$ by $N$ tangent lines. Each tangent is a linear constraint:

\[
(S_t^{loss})^2 \ge 2 S_k^{loss} \cdot S_t^{loss} - \left(S_k^{loss}\right)^2 \quad \forall k = 1, \ldots, N
\]

The optimizer chooses the maximum, which is the outer approximation.

**Option B — Full loss curve:** Replace $k_{quad} \cdot (S_t^{loss})^2$ by a piecewise-linear loss curve from the manufacturer.

**Choice:** Declared per scenario. Default is Option A with $N = 8$ tangents.

### 2.3.6 Four-quadrant operation

The PCS operates in four quadrants:

| Quadrant | $P_{AC,t}$ | $Q_t$ | Mode |
|---|---|---|---|
| Q1 | > 0 (discharge) | > 0 (capacitive) | Discharge + inject Q |
| Q2 | < 0 (charge) | > 0 (capacitive) | Charge + inject Q |
| Q3 | < 0 (charge) | < 0 (inductive) | Charge + absorb Q |
| Q4 | > 0 (discharge) | < 0 (inductive) | Discharge + absorb Q |

The capability constraint $P_{AC,t}^2 + Q_t^2 \le S_{max}^2$ bounds all four quadrants.

**Reactive-only operation:** When $P_{AC,t} = 0$, the PCS can still provide $Q_t \in [-S_{max}, S_{max}]$. This is captured by the capability constraint.

### 2.3.7 Ramp rate

The ramp rate limits the change in signed AC power between consecutive steps:

\[
|P_{AC,t} - P_{AC,t-1}| \le RampRate \cdot 60 \cdot \Delta t
\]

where $RampRate$ is in kW/min and $\Delta t$ is in hours (Part 1, section 1.5.1). The state $P_{AC,t-1}$ is registered in Part 1 (section 1.4.1).

### 2.3.8 Minimum rest period (multi-cycle, value-tracked formulation)

**Status:** The rest-period constraint is now **fully linearized** and **implementable as a MILP** (Revision 6). The trigger tracks the throughput **value** at the last completion (`Th_last,t`), not the **index** of that completion (`t_last,t`). Indexing a variable array by a decision variable is not a linear operation and was the defect in Revision 5's formulation. The value-tracked formulation is linear and closed under the same big-M pattern already proven for the counter update.

**Cycle completion threshold:**

\[
\Delta Th_{cycle} = 2 \cdot E_{nom} \cdot SOH_k \cdot (SOC_{max} - SOC_{min})
\]

**SOH epoch-boundary edge case:** $\Delta Th_{cycle}$ depends on $SOH_k$, which is latched per epoch (Part 1, section 1.5.6). If a rest cycle spans an epoch boundary, the threshold shifts mid-cycle. The model uses the threshold **at the step of the current evaluation**, not at the start of the cycle. Given that monthly epochs (730 h) are much longer than typical full-cycle timescales (hours), the edge case has low impact. The convention is stated to avoid ambiguity.

**Multi-cycle-per-horizon edge case.** Within a single optimization horizon of length $T_{opt}$ (24–48 h), the throughput can cross $\Delta Th_{cycle}$ more than once. For a grid-scale BESS with a typical full-cycle time of a few hours, two or three cycle completions per horizon are plausible under aggressive dispatch. Revision 4's frozen-parameter formulation could not represent this; Revision 5's index-tracking formulation was not implementable; Revision 6's value-tracking formulation closes both issues.

**Design choice: track the value, not the index.** The MILP-coupled quantity is:

\[
Th_{last,t} \;=\; \text{throughput at the step of the most recent cycle completion, evaluated at step } t.
\]

- At the horizon start, $Th_{last,t=0}$ is a **parameter** equal to the throughput at the physical `t_last` carried in from the previous horizon: $Th_{last,t=0} = Th_{t_{last}^{physical}}$.
- For $t > 0$, $Th_{last,t}$ is updated by the trigger logic below.
- `Th_last,t` is an **ordinary decision variable** — its value is a throughput quantity, not an index. The trigger `Th_t - Th_last,t ≥ ΔTh_cycle` is therefore **linear** (a difference of two variables).

The step index of the last completion, `t_last,t`, is **not** a decision variable and **does not appear in any constraint**. It is computed **post-solve** as a diagnostic: once the solver has returned the solution, the step at which the most recent `c_cycle,τ = 1` occurred (for τ ≤ t) is read directly from the binary sequence. This is a trivial lookup, not a MILP operation.

**Trigger condition (value-tracked form):**

\[
\text{If } Th_t - Th_{last,t} \ge \Delta Th_{cycle} \text{ then } Th_{last,t+1} \leftarrow Th_t \text{ and } m_{cycle,t+1} \leftarrow m_{cycle,t} + 1
\]

Otherwise $Th_{last,t+1} \leftarrow Th_{last,t}$ and $m_{cycle,t+1} \leftarrow m_{cycle,t}$.

**Physical update rule (preserved from Revision 4).** The physical state `t_last` is updated at the step the cycle completes. Between horizons, the physical value is advanced by the total count of cycle completions recorded in `m_cycle,t` over the horizon. Within a horizon, the value-tracked `Th_last,t` is what the trigger logic uses; the physical index `t_last` is recovered post-solve.

**MILP formulation of the trigger and reset.** Introduce a binary $c_{cycle,t} \in \{0,1\}$ that is 1 when a cycle completes at step $t$:

\[
Th_t - Th_{last,t} \ge \Delta Th_{cycle} - M_{big} \cdot (1 - c_{cycle,t})
\]
\[
Th_t - Th_{last,t} \le \Delta Th_{cycle} - 1 + M_{big} \cdot c_{cycle,t}
\]
\[
c_{cycle,t} \in \{0,1\}
\]

This is linear: both $Th_t$ and $Th_{last,t}$ are ordinary decision variables; the difference is a linear expression; the big-M terms are linear. The constraint is implementable in any MILP solver.

**Value-tracked $Th_{last}$ update (linearized).** The update "if $c_{cycle,t} = 1$, set to $Th_t$; else hold" is encoded with the standard big-M pattern:

\[
Th_{last,t+1} \le Th_{last,t} + M_{big} \cdot c_{cycle,t}
\]
\[
Th_{last,t+1} \ge Th_{last,t} - M_{big} \cdot c_{cycle,t}
\]
\[
Th_{last,t+1} \le Th_t + M_{big} \cdot (1 - c_{cycle,t})
\]
\[
Th_{last,t+1} \ge Th_t - M_{big} \cdot (1 - c_{cycle,t})
\]

When $c_{cycle,t} = 1$: the first pair is loose (the $M_{big} \cdot c_{cycle,t}$ terms allow drift), and the second pair forces $Th_{last,t+1} = Th_t$. When $c_{cycle,t} = 0$: the first pair forces $Th_{last,t+1} = Th_{last,t}$, and the second pair is loose. This is the exact big-M encoding of the piecewise update, and it is **linear in all variables**.

**Within-horizon cycle counter (linearized):**

\[
m_{cycle,t+1} = m_{cycle,t} + c_{cycle,t}
\]

A simple accumulator. No binary beyond $c_{cycle,t}$ is needed.

**Counter evolution with reset.** Introduce a binary $r_t \in \{0,1\}$ for the decrement direction:

\[
n_{rest,t+1} \le n_{rest,t} - 1 + M_{big} \cdot r_t + M_{big} \cdot c_{cycle,t}
\]
\[
n_{rest,t+1} \ge n_{rest,t} - 1
\]
\[
n_{rest,t+1} \ge 0
\]
\[
n_{rest,t+1} \le n_{rest}^{min} + M_{big} \cdot (1 - c_{cycle,t})
\]

The first and last constraints together implement the reset: when $c_{cycle,t} = 1$, $n_{rest,t+1} \le n_{rest}^{min}$ and the counter is set to $n_{rest}^{min}$. When $c_{cycle,t} = 0$, the counter decrements normally.

**Rest enforcement (linearized).** Introduce a binary $p_t \in \{0,1\}$ that is 1 when $n_{rest,t} > 0$:

\[
n_{rest,t} \le M_{big} \cdot p_t
\]
\[
n_{rest,t} \ge 1 - M_{big} \cdot (1 - p_t)
\]
\[
P_{AC,t}^{ch} + P_{AC,t}^{dis} \le M_{big} \cdot (1 - p_t)
\]

When $p_t = 1$ (rest active), the power is forced to zero. When $p_t = 0$ (rest inactive), the power is free.

**Coupling with Part 3.** The trigger depends on $Th_t$, which is a Part 3 state. This constraint is a **Part 2–Part 3 coupled constraint**. It is fully implementable given Part 3's throughput evolution.

**Auxiliary binaries.** $c_{cycle,t}$, $r_t$, $p_t$ are auxiliary MILP binaries used exclusively for linearization. They are covered by Part 1 §1.4.0's auxiliary-binary convention and are **not registered** as decision variables. Downstream parts query the underlying physical state $n_{rest,t}$ (and $Th_t$) instead. See Part 1 §1.4.0 for the named whitelist.

**Within-horizon tracked quantity.** `Th_last,t` is a within-horizon derived quantity, an ordinary decision variable inside the optimizer, and it **is registered** in Part 1 via the existing transient convention (see §2.9). It is not a state, not a decision variable in the persistent sense, and not an auxiliary binary — it is an inline quantity that participates in the trigger linearization.

**Post-solve diagnostics.** `t_last,t` and `m_cycle,t` are computed **after** the solve, from the returned `c_cycle,t` sequence and the returned `Th_t` sequence. They are not decision variables and do not appear in any constraint. They are reported as engineering outputs (the number of cycles completed per horizon, and the step index of the most recent completion) but are not registered symbols and are not "transient" in Part 1's sense — they are simply solver outputs, like any other reported KPI.

**Backward compatibility, restated honestly.** Revision 5's claim that "under horizons with zero or one cycle completion, Revision 5 reduces exactly to Revision 4" was **not accurate**, because once `c_cycle,t` fires once, Revision 5's trigger referenced `Th` at a solver-determined index, which was unimplementable even in the single-cycle case. Revision 6's formulation *is* backward-compatible in the correct sense: when the horizon contains zero cycle completions, `Th_last,t` stays at its initial parameter value throughout and the trigger reduces to the frozen-parameter form of Revision 4; when the horizon contains exactly one completion, `Th_last,t` updates once and then holds, which is exactly the correct single-cycle behavior; and when the horizon contains multiple completions, `Th_last,t` updates at each, which is the multi-cycle behavior Revision 5 was aiming for. All three cases are now linear and implementable.

**Complexity.** The value-tracked formulation adds:
- One continuous decision variable per step: `Th_last,t` (T_opt variables).
- One continuous decision variable per step for the trigger comparison (absorbed into the difference).
- 4 big-M constraints per step for the `Th_last,t` update.
- 2 big-M constraints per step for the `c_cycle,t` trigger.
- `m_cycle,t` is a simple accumulator (1 constraint per step).

This is **O(T_opt)** additional variables and constraints, comparable to Revision 5's index-tracking formulation but now linear. No one-hot selection is needed. No extra binaries beyond `c_cycle,t` and `r_t`.

### 2.3.9 SOC constraints for regulation

When a regulation commitment is active ($c_{reg,t} = 1$, Part 1 section 1.4.1), the SOC must remain within a band that preserves headroom for both up and down regulation:

\[
SOC_{reg,min} \le SOC_t \le SOC_{reg,max}
\]

where $SOC_{reg,min} > SOC_{min}$ and $SOC_{reg,max} < SOC_{max}$.

**Linearization with the commitment binary:**

\[
SOC_t \ge SOC_{reg,min} - M_{big} \cdot (1 - c_{reg,t})
\]
\[
SOC_t \le SOC_{reg,max} + M_{big} \cdot (1 - c_{reg,t})
\]

When $c_{reg,t} = 0$, the constraints are inactive.

---

## 2.4 Grid and site model

### 2.4.1 Site balance (BTM only)

For behind-the-meter configurations, the net power at the PCC is:

\[
P_{PCC,t} = P_{load,t} + P_{AC,t}^{ch} - P_{AC,t}^{dis} + P_{aux} \cdot \mathbb{1}[\text{Configuration B}]
\]

**Note:** The $P_{aux}$ term appears in the site balance only under **Configuration B** (aux direct from site AC). Under Configuration A (aux through PCS), $P_{aux}$ is already accounted for in the battery energy balance and does not appear here.

**Sign convention:** $P_{PCC,t} > 0$ means import from grid, $P_{PCC,t} < 0$ means export to grid.

### 2.4.2 Import and export decomposition

Because $\max(\cdot)$ is not LP-friendly, import and export are modeled with a binary $w_t \in \{0,1\}$:

\[
P_{import,t} \le P_{import,max} \cdot w_t
\]
\[
P_{export,t} \le P_{export,max} \cdot (1 - w_t)
\]
\[
P_{PCC,t} = P_{import,t} - P_{export,t}
\]

### 2.4.3 Grid constraints

\[
P_{import,t} \le P_{import,max}
\]
\[
P_{export,t} \le P_{export,max}
\]

### 2.4.4 Front-of-the-meter configuration

For FTM configurations, there is no site load. The balance simplifies to:

\[
P_{PCC,t} = P_{AC,t}^{dis} - P_{AC,t}^{ch}
\]

**Note:** $P_{load,t} = 0$ in FTM. This is a configuration parameter, not a state.

### 2.4.5 Thermal model

The cell temperature evolves according to a first-order thermal model:

\[
T_{t+1} = T_t + \frac{\Delta t}{\tau_T} \left( T_{amb,t} - T_t \right) + k_{heat} \cdot |P_{cell,t}| \cdot \Delta t
\]

where:

- $T_t$: cell temperature (°C).
- $T_{amb,t}$: ambient temperature (°C), scenario input.
- $\tau_T$: thermal time constant (h).
- $k_{heat}$: heating coefficient per unit loss (K/kWh).
- $P_{cell,t}$: net electrochemical power (kW), approximated as $P_{DC,t}^{ch} - P_{DC,t}^{dis}$.

**Note:** The thermal model is a state update. Within the optimization horizon, $T_t$ is fixed or forecast (Part 1, section 1.5.8). The thermal model is used in the simulation loop, not inside the MILP.

---

## 2.5 Load model

### 2.5.1 Load as scenario input

The site load $P_{load,t}$ is a **scenario input**. It is the realized load, not a forecast. Forecast load is $\hat{P}_{load,t}$ (Part 1, section 1.4.7).

### 2.5.2 Load forecast error

Forecast load is modeled as additive error:

\[
\hat{P}_{load,t} = P_{load,t} + \epsilon^{load}(t_0, \tau)
\]

where $\epsilon^{load}(t_0, \tau)$ is indexed by issue time $t_0$ and lead time $\tau$ (Part 1, section 1.4.12).

### 2.5.3 Load growth

Annual load growth is applied as:

\[
P_{load,t}^{year\,y} = P_{load,t}^{year\,0} \cdot (1 + \gamma_{load})^y
\]

where $\gamma_{load}$ is the annual growth rate and $y$ is the year index (Part 1, section 1.4.14).

### 2.5.4 Load profile requirements

The load profile must be provided at the base resolution $\Delta t$. If the RFP provides 15-min interval data, $\Delta t = 15$ min. If it provides hourly data, $\Delta t = 1$ h.

**Interpolation rule:** If the load data is at finer resolution than $\Delta t$, it is averaged over each step. If coarser, it is held constant (no interpolation).

---

## 2.6 Hard constraints summary

The following constraints must hold at every step $t$. The **binding** constraints are those the optimizer enforces. The **consistency checks** are verified post-solve; a violation indicates a scenario-parameter inconsistency, not an infeasible optimization.

### 2.6.1 Binding constraints (optimizer enforces)

| Constraint | Equation | Reference |
|---|---|---|
| Energy bounds | $E_{min,t} \le E_t \le E_{max,t}$ | 2.2.2 |
| Charge/discharge exclusion | $P_{AC,t}^{ch} \cdot P_{AC,t}^{dis} = 0$ | Part 1, 1.3.2 |
| AC power limits | $0 \le P_{AC,t}^{ch} \le P_{max,t}^{AC,ch}$, $0 \le P_{AC,t}^{dis} \le P_{max,t}^{AC,dis}$ | 2.3.2 |
| Apparent power (average) | $P_{AC,t}^2 + Q_t^2 \le S_{max}^2$ | 2.3.3 |
| Apparent power (peak) | $\max(\|P^{base} + R^{up}\|, \|P^{base} - R^{down}\|)^2 + Q_{res}^2 \le S_{max}^2$ | 2.3.3 |
| Ramp rate | $\|P_{AC,t} - P_{AC,t-1}\| \le RampRate \cdot 60 \cdot \Delta t$ | 2.3.7 |
| Minimum rest | $P_{AC,t}^{ch} + P_{AC,t}^{dis} = 0$ when $n_{rest,t} > 0$ | 2.3.8 |
| SOC for regulation | $SOC_{reg,min} \le SOC_t \le SOC_{reg,max}$ when $c_{reg,t} = 1$ | 2.3.9 |
| Grid import | $P_{import,t} \le P_{import,max}$ | 2.4.3 |
| Grid export | $P_{export,t} \le P_{export,max}$ | 2.4.3 |
| SOC feasibility | $E_t \le E_{nom} \cdot SOH_k \cdot SOC_{max}$ | Part 1, 1.5.6 |
| Cycle trigger (value-tracked) | $Th_t - Th_{last,t} \ge \Delta Th_{cycle} - M_{big} \cdot (1 - c_{cycle,t})$, $Th_t - Th_{last,t} \le \Delta Th_{cycle} - 1 + M_{big} \cdot c_{cycle,t}$ | 2.3.8 |
| $Th_{last}$ update | $Th_{last,t+1} = Th_t$ if $c_{cycle,t} = 1$, else $Th_{last,t+1} = Th_{last,t}$ | 2.3.8 |
| $m_{cycle}$ counter | $m_{cycle,t+1} = m_{cycle,t} + c_{cycle,t}$ | 2.3.8 |
| Rest counter | see §2.3.8 | 2.3.8 |

### 2.6.2 Post-solve consistency checks (not optimizer constraints)

| Check | Equation | Reference | On violation |
|---|---|---|---|
| DC charge limit | $0 \le P_{DC,t}^{ch} \le P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC} \cdot g_T$ | 2.2.5 | Raise error: scenario parameters inconsistent |
| DC discharge limit | $0 \le P_{DC,t}^{dis} \le P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC} \cdot f_T$ | 2.2.5 | Raise error: scenario parameters inconsistent |

**Note:** By the binding-limit rule in §2.2.5 and §2.3.2, these checks are algebraically implied by the AC limits in §2.6.1. They are listed separately so that an implementation that assembles the constraints programmatically does not accidentally add them to the optimizer's feasible set. The checks are executed once per step in the simulation loop, after the optimizer returns.

### 2.6.3 Post-solve diagnostics (reported, not constrained)

| Diagnostic | Definition | Reference |
|---|---|---|
| Last-completion step index | $t_{last,t} = \max\{\tau \le t : c_{cycle,\tau} = 1\}$ (or the horizon-start value if none) | 2.3.8 |
| Within-horizon cycle count | $m_{cycle,t}$ (returned by the accumulator) | 2.3.8 |

**Note:** These are computed **after** the solve from the returned `c_cycle,t` sequence. They do not appear in any constraint. They are reported as engineering outputs.

---

## 2.7 Part 2 outputs

Part 2 produces the following quantities for use by Parts 3, 4, and 5:

| Output | Symbol | Consumed by |
|---|---|---|
| Stored energy | $E_t$ | Part 3 (SOC), Part 5 (state) |
| Cell temperature | $T_t$ | Part 3 (Arrhenius) |
| Minimum energy | $E_{min,t}$ | Part 5 (constraints) |
| Maximum energy | $E_{max,t}$ | Part 5 (constraints) |
| Usable energy | $E_{usable,t}$ | Part 4 (reservations) |
| Derating functions | $f_{SOC}, f_T, g_{SOC}, g_T$ | Part 5 (limits) |
| Net PCC power | $P_{PCC,t}$ | Part 4 (demand charges) |
| Import power | $P_{import,t}$ | Part 4 (demand charges) |
| Export power | $P_{export,t}$ | Part 4 (export constraints) |
| DC power | $P_{DC,t}$, $P_{DC,t}^{ch}$, $P_{DC,t}^{dis}$ | Part 3 (throughput) |
| Average apparent power | $S_t$ | Part 3 (loss propagation) |
| Loss-model apparent power | $S_t^{loss}$ | Part 3 (loss propagation) |
| PCS incremental loss | $P_{loss,t}^{PCS,inc}$ | Part 3 (loss propagation) |
| Cycle threshold | $\Delta Th_{cycle}$ | Part 3 (throughput reference) |
| Cycles completed per horizon | $m_{cycle,t}$ (diagnostic) | Part 5 (diagnostics) |

---

## 2.8 Part 2 changelog

### Version 1.0 — Revision 6 (FC4)

**Changes from Revision 5 (verified):**

1. **Trigger redesigned to track the throughput value, not the index (§2.3.8).** Revision 5's trigger referenced `Th` at a solver-determined index (`Th_{t_last,t}`), which is not a linear operation and is not implementable in a MILP. Revision 6 replaces the index-tracking quantity `t_last,t` with a value-tracking quantity `Th_last,t` — the throughput **value** at the last completion — updated by the same big-M pattern already proven correct in Revision 5. The trigger `Th_t - Th_last,t ≥ ΔTh_cycle` is now linear. The multi-cycle gap is genuinely closed, including the single-cycle case that Revision 5's "backward compatibility" claim overstated.

2. **`t_last,t` demoted to a post-solve diagnostic (§2.3.8, §2.6.3).** `t_last,t` no longer appears in any constraint. It is computed after the solve from the returned `c_cycle,t` sequence and reported as an engineering output. This removes the unimplementable reference entirely.

3. **Backward-compatibility claim corrected and made accurate (§2.3.8).** Revision 5 claimed that the formulation "reduces exactly to Revision 4" for zero- or one-cycle horizons. That was not accurate: once `c_cycle,t` fires, Revision 5's trigger referenced `Th` at a solver-determined index, which was unimplementable even in the single-cycle case. Revision 6 states the correct backward-compatibility property: zero completions → frozen parameter; one completion → single update then hold; multiple completions → per-completion updates. All three cases are now linear.

4. **Citation fix completed (§2.1).** The residual "FC9/FC10" reference in §2.1 is corrected to "FC9." The changelog's claim of full citation closure is now accurate.

5. **Terminology collision resolved (§2.1, §2.9).** Revision 5's §2.9 proposed an unregistered category under the name "transient," which collides with Part 1 §1.4 header's existing "transient quantities convention" (registered-but-inline). Revision 6 **renames** the new category to **"within-horizon auxiliary quantities"** and **registers** `Th_last,t` in Part 1 via the existing transient convention. `t_last,t` and `m_cycle,t` are declared as post-solve diagnostics, not symbols, and are not "transient" in any sense — they are solver outputs.

6. **§2.6.3 added — post-solve diagnostics table.** Separates the diagnostics (`t_last,t`, `m_cycle,t`) from both the binding constraints (§2.6.1) and the consistency checks (§2.6.2). Makes it clear that the diagnostics do not participate in the feasible set.

7. **§2.9 rewritten.** The previous §2.9 proposed a new convention. Revision 6's §2.9 (below) instead requests that `Th_last,t` be registered in Part 1 §1.4.6 under the existing transient convention, and clarifies the diagnostic-vs-symbol distinction.

8. **Version label updated to Revision 6 (FC4).** FC4 is the promotion candidate.

**Carried over from Revision 5 (verified):**

- Citation fixes for Part 1 FC8/FC9 references (partially applied in Revision 5; fully applied in Revision 6).
- Multi-cycle-per-horizon gap identified (the diagnosis was correct; the fix in Revision 5 was not).

**Carried over from Revision 4 (verified):**

- Derating binding-limit rule (§2.2.5, §2.3.2, §2.6) — with algebraic proof.
- $t_{last}$ three-tier rule (physical / optimizer's view / epoch latching).
- Binding-limit derivation.
- $E_{nom}$ vs. $E_{nom}^{cell}$ relationship clarified.
- Auxiliary-binary reference updated.

**Carried over from Revision 3 (verified):**

- SOH epoch-boundary edge case noted.
- Interface table formatted consistently.
- Auxiliary-binary convention pressure-tested.

**Carried over from Revision 2 (verified):**

- $S_t$ collision resolved.
- $k_{quad}$ unit "conversion" removed.
- Minimum rest period MILP completed.
- $\eta_d \to \eta_{d,t}$ in aux formula.
- Loss-term division stated as modeling choice.

**Carried over from Revision 1 (verified):**

- Loss term in energy balance.
- Derating applied only to battery-derived term.
- $P_{aux}^{cell}$ substituted in balance.
- $E_{nom}^{cell}$ derivation added.
- $SOC_{reg,min}, SOC_{reg,max}$ constraint added.
- Aux-load architecture assumption stated.
- $\sigma_{reg,t}^{abs}$ in interface table.
- Site balance conditional on configuration.

**Pending:**

- Numerical verification of typical parameter values against manufacturer data.
- Verification of derating function shapes against manufacturer curves.
- Verification of PCS loss curve against manufacturer data.
- Cross-check with Part 3 on SOH consumption and throughput evolution.
- Cross-check with Part 5 on dispatch variable usage and rest constraint implementation.
- **Part 1 registration of `Th_last,t`** (see §2.9).

**No longer pending (closed in Revisions 4, 5, and 6):**

- ~~Part 1 sign-off on the change request~~ — closed by Part 1 FC8/FC9.
- ~~Derating double-application (open-item 5)~~ — closed by Revision 4.
- ~~$t_{last}$ update timing (open-item 6)~~ — closed by Revision 4.
- ~~Multi-cycle-per-horizon gap — diagnosis~~ — closed by Revision 5.
- ~~Multi-cycle-per-horizon gap — fix~~ — closed by Revision 6 (value-tracked formulation).
- ~~Part 1 citation errors~~ — closed by Revision 6.
- ~~Terminology collision with Part 1's "transient" convention~~ — closed by Revision 6 (renamed to "within-horizon auxiliary quantities").

---

## 2.9 Part 1 registration request

**Status:** Issued by Part 2. **Pending Part 1 sign-off.**

Revision 6 introduces one within-horizon quantity that is a decision variable inside the optimizer and should be registered in Part 1:

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| $Th_{last,t}$ | Throughput value at the most recent cycle completion, evaluated at step $t$ (within-horizon, inline) | kWh | 1.4.6 (per-step degradation variables) |

**Registration rationale.** `Th_last,t` is:
- **Not a state** — it is reset at each horizon to the physical value implied by the persistent `t_last` and `Th_t` states.
- **Not a decision variable in the persistent sense** — it is solver-determined within a horizon, but it does not carry information across horizons.
- **Not an auxiliary binary** — it is continuous.
- **An inline quantity in the sense of Part 1 §1.4 header's existing transient convention** — it is introduced in formulas (the trigger and its update), it is not stored as state/decision/parameter in the persistent model, and it should be marked "transient" in its table row.

The existing Part 1 transient convention already accommodates this. Revision 6 requests that `Th_last,t` be added to §1.4.6 with the transient marker, with Part 2 as the owning part.

**Diagnostics.** `t_last,t` and `m_cycle,t` are **not** registered. They are post-solve diagnostics (see §2.6.3), computed from the returned solution, and they do not appear in any constraint. They are reported as engineering outputs (cycles per horizon, step index of last completion) but are not symbols.

**No new convention proposed.** Revision 6 fits inside Part 1's existing rules. The "within-horizon auxiliary quantities" name is used in Revision 6's prose to distinguish them from registered auxiliary binaries, but no new registration category is requested.

---

## 2.10 Exit criteria for promotion to v1.0

| # | Criterion | Status |
|---|---|---|
| 1 | **Part 1 change requests closed (Revision 4/5 items).** All symbols used in Part 2 are registered in Part 1 §1.4 (FC8) or covered by the auxiliary-binary convention (§1.4.0, FC9). | **MET** |
| 2 | **Derating binding rule stated.** Open-item 5 closed. | **MET** (Revision 4) |
| 3 | **$t_{last}$ update timing stated unambiguously.** Open-item 6 closed. | **MET** (Revision 4) |
| 4 | **Multi-cycle-per-horizon gap closed with a linear, implementable formulation.** Value-tracked trigger; index-tracking removed from constraints. | **MET** (Revision 6) |
| 5 | **Citation accuracy.** All Part 1 cross-references resolve to actual documents and sections. | **MET** (Revision 6) |
| 6 | **Terminology consistency with Part 1.** No collision with Part 1's existing "transient" convention. | **MET** (Revision 6) |
| 7 | **Internal cross-references verified.** All section references resolve to existing sections. | **MET** |
| 8 | **Changelog cumulative and honest.** | **MET** |
| 9 | **No truncated sections.** Document complete from 2.1 to 2.10. | **MET** |
| 10 | **Part 1 registration of $Th_{last,t}$.** | **PENDING** (external; Part 1 revision) |
| 11 | **Cross-check with Part 3 on SOH consumption and throughput evolution.** | **PENDING** (external; Part 3 revision) |
| 12 | **Cross-check with Part 5 on dispatch variable usage and rest constraint implementation.** | **PENDING** (external; Part 5 revision) |
| 13 | **Numerical verification of typical parameter values** against manufacturer data. | **PENDING** (external; scenario data) |
| 14 | **Verification of derating function shapes** against manufacturer curves. | **PENDING** (external; scenario data) |
| 15 | **Verification of PCS loss curve** against manufacturer data. | **PENDING** (external; scenario data) |

**Freeze definition:** Frozen (v1.0) means changes only via change request with version increment. FC documents are under review, not frozen.

