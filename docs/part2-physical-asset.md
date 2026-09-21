# PART 2 — PHYSICAL ASSET MODEL

## BESS Engineering Model

**Version 1.0 — Revision 3**

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

**Part 1 change request status:** This revision carries the Part 1 change request forward from Revision 2. **Part 2 is technically blocked on Part 1's sign-off** for the four new symbols ($\Delta Th_{cycle}$, $t_{last}$, $r_t$, $S_t^{loss}$) and the auxiliary-binary convention. See section 2.9.

**Interface summary (Part 2):**

| Consumes from | Produces for |
|---|---|
| Symbols (Part 1) | $E_t$, $T_t$ (state) |
| SOH (Part 3) | $E_{min,t}$, $E_{max,t}$, $E_{usable,t}$ |
| Throughput $Th_t$ (Part 3) | Derating functions $f_{SOC}, f_T, g_{SOC}, g_T$ |
| Dispatch $P_{AC}^{ch}, P_{AC}^{dis}, Q_t$ (Part 5) | $P_{PCC,t}$, $P_{import,t}$, $P_{export,t}$ |
| Scenario inputs $P_{load,t}, T_{amb,t}$ | $P_{DC,t}$, $P_{DC,t}^{ch}$, $P_{DC,t}^{dis}$ |
| Reservations $R_{reg,t}^{up}, R_{reg,t}^{down}, Q_{res,t}$ (Part 4) | $S_t$, $S_t^{loss}$, $P_{loss,t}^{PCS,inc}$ |
| Absolute regulation statistics $\sigma_{reg,t}^{abs}$ (Part 4) | |

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

### 2.2.5 Power limits at the cell (DC side)

The cell DC power limits are:

\[
0 \le P_{DC,t}^{ch} \le P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC}$SOC_t$ \cdot g_T$T_t$
\]

\[
0 \le P_{DC,t}^{dis} \le P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC}$SOC_t$ \cdot f_T$T_t$
\]

**Where:**

- $P_{batt,max}^{DC,ch}$, $P_{batt,max}^{DC,dis}$: battery DC capability from manufacturer.
- $SOH_k^{pow}$: power state of health (Part 3).
- $f_{SOC}, f_T, g_{SOC}, g_T$: derating functions (section 2.2.6).

### 2.2.6 Derating functions

The derating functions capture the reduction of available power as a function of SOC and temperature. They are dimensionless factors in $[0, 1]$:

| Function | Range | Meaning |
|---|---|---|
| $f_{SOC}$SOC_t$$ | $[0, 1]$ | Discharge derating at low SOC |
| $f_T$T_t$$ | $[0, 1]$ | Discharge derating at low/high temperature |
| $g_{SOC}$SOC_t$$ | $[0, 1]$ | Charge derating at high SOC |
| $g_T$T_t$$ | $[0, 1]$ | Charge derating at low/high temperature |

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
P_{max,t}^{AC,ch} = \min\left(P_{max}^{AC},\; \frac{P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC}$SOC_t$ \cdot g_T$T_t$}{\eta_{PCS}}\right)
\]

\[
P_{max,t}^{AC,dis} = \min\left(P_{max}^{AC},\; P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC}$SOC_t$ \cdot f_T$T_t$ \cdot \eta_{PCS}\right)
\]

**Explanation:** The PCS hardware rating $P_{max}^{AC}$ is a physical limit that does not depend on battery SOC or temperature. The derating functions apply only to the battery DC capability, which is converted to the AC side and then composed with the PCS rating via $\min(\cdot)$.

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

**Note:** $S_t^{loss} \ge S_t$ because it includes the regulation variance term $\sigma_{reg,t}^{abs}$. It is used exclusively in the PCS loss model (section 2.3.4). The symbol $S_t^{loss}$ is registered in Part 1 (section 2.9 change request).

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

**Alternative (full loss curve):** If the manufacturer provides a full efficiency curve $\eta_{PCS}$S_t$$, the incremental model is replaced by the curve. The choice is declared per scenario.

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

### 2.3.8 Minimum rest period (partial linearization)

**Status:** The rest-period constraint is **partially linearized**. The trigger, the counter reset, the decrement, and the rest enforcement are fully specified. The constraint couples Parts 2 and 3 through the throughput state $Th_t$. It cannot be validated until Part 3 is written.

**Cycle completion threshold:**

\[
\Delta Th_{cycle} = 2 \cdot E_{nom} \cdot SOH_k \cdot (SOC_{max} - SOC_{min})
\]

**SOH epoch-boundary edge case:** $\Delta Th_{cycle}$ depends on $SOH_k$, which is latched per epoch (Part 1, section 1.5.6). If a rest cycle spans an epoch boundary, the threshold shifts mid-cycle. The model uses the threshold **at the step of the current evaluation**, not at the start of the cycle. Given that monthly epochs (730 h) are much longer than typical full-cycle timescales (hours), the edge case has low impact. The convention is stated to avoid ambiguity.

**Trigger condition:** The rest counter $n_{rest,t}$ is set to $n_{rest}^{min}$ at the step when a cycle completes:

\[
\text{If } Th_t - Th_{t_{last}} \ge \Delta Th_{cycle} \text{ then } n_{rest,t} \leftarrow n_{rest}^{min}
\]

where $t_{last}$ is the step index of the last rest, and:

\[
n_{rest}^{min} = \lceil N_{rest} / \Delta t \rceil
\]

**Update rule for $t_{last}$:** When a cycle completes at step $t$ ($c_{cycle,t} = 1$), the last-rest index is updated:

\[
t_{last} \leftarrow t
\]

This update is applied at the epoch boundary when the state is latched, consistent with the Part 1 timing rules. Between updates, $t_{last}$ is held constant.

**MILP formulation of the trigger and reset:**

Introduce a binary $c_{cycle,t} \in \{0,1\}$ that is 1 when a cycle completes at step $t$:

\[
Th_t - Th_{t_{last}} \ge \Delta Th_{cycle} - M_{big} \cdot (1 - c_{cycle,t})
\]
\[
Th_t - Th_{t_{last}} \le \Delta Th_{cycle} - 1 + M_{big} \cdot c_{cycle,t}
\]
\[
c_{cycle,t} \in \{0,1\}
\]

When $c_{cycle,t} = 1$, the first constraint forces the throughput difference to exceed the threshold, and the second is loose. When $c_{cycle,t} = 0$, the first is loose and the second forces the throughput difference to be strictly below the threshold.

**Counter evolution with reset:**

Introduce a binary $r_t \in \{0,1\}$ for the decrement direction:

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

**Rest enforcement (linearized):**

Introduce a binary $p_t \in \{0,1\}$ that is 1 when $n_{rest,t} > 0$:

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

**Coupling with Part 3:** The trigger depends on $Th_t$, which is a Part 3 state. This constraint is therefore a **Part 2–Part 3 coupled constraint**. It is not fully implementable until Part 3 defines the throughput evolution.

**Status label:** Partially linearized, pending Part 3.

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

The following constraints must hold at every step $t$:

| Constraint | Equation | Reference |
|---|---|---|
| Energy bounds | $E_{min,t} \le E_t \le E_{max,t}$ | 2.2.2 |
| Charge/discharge exclusion | $P_{AC,t}^{ch} \cdot P_{AC,t}^{dis} = 0$ | Part 1, 1.3.2 |
| AC power limits | $0 \le P_{AC,t}^{ch} \le P_{max,t}^{AC,ch}$, $0 \le P_{AC,t}^{dis} \le P_{max,t}^{AC,dis}$ | 2.3.2 |
| DC power limits | $0 \le P_{DC,t}^{ch} \le P_{batt,max}^{DC,ch} \cdot SOH_k^{pow} \cdot g_{SOC} \cdot g_T$, $0 \le P_{DC,t}^{dis} \le P_{batt,max}^{DC,dis} \cdot SOH_k^{pow} \cdot f_{SOC} \cdot f_T$ | 2.2.5 |
| Apparent power (average) | $P_{AC,t}^2 + Q_t^2 \le S_{max}^2$ | 2.3.3 |
| Apparent power (peak) | $\max(\|P^{base} + R^{up}\|, \|P^{base} - R^{down}\|)^2 + Q_{res}^2 \le S_{max}^2$ | 2.3.3 |
| Ramp rate | $\|P_{AC,t} - P_{AC,t-1}\| \le RampRate \cdot 60 \cdot \Delta t$ | 2.3.7 |
| Minimum rest | $P_{AC,t}^{ch} + P_{AC,t}^{dis} = 0$ when $n_{rest,t} > 0$ | 2.3.8 |
| SOC for regulation | $SOC_{reg,min} \le SOC_t \le SOC_{reg,max}$ when $c_{reg,t} = 1$ | 2.3.9 |
| Grid import | $P_{import,t} \le P_{import,max}$ | 2.4.3 |
| Grid export | $P_{export,t} \le P_{export,max}$ | 2.4.3 |
| SOC feasibility | $E_t \le E_{nom} \cdot SOH_k \cdot SOC_{max}$ | Part 1, 1.5.6 |

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

---

## 2.8 Part 2 changelog

### Version 1.0 — Revision 3

**Changes from Revision 2:**

1. **$t_{last}$ update rule added (2.3.8).** When a cycle completes ($c_{cycle,t} = 1$), $t_{last} \leftarrow t$. The update is applied at the epoch boundary, consistent with Part 1 timing rules. Between updates, $t_{last}$ is held constant.

2. **SOH epoch-boundary edge case noted (2.3.8).** The threshold $\Delta Th_{cycle}$ depends on $SOH_k$, which is latched per epoch. If a rest cycle spans an epoch boundary, the threshold shifts mid-cycle. The model uses the threshold at the step of the current evaluation. Impact is low given monthly epochs (730 h) versus typical cycle timescales (hours).

3. **Interface table (2.1) formatted consistently.** The trailing $\sigma_{reg,t}^{abs}$ row is now aligned with the "Produces for" column as a consumed input.

4. **Auxiliary-binary convention pressure-tested (2.9).** The note clarifies that $r_t$ is an auxiliary binary with no physical meaning; $c_{cycle,t}$ and $p_t$ are also auxiliary. If a downstream part (Part 3 or Part 5) needs to query the rest state, it queries $n_{rest,t}$ (registered state), not the auxiliary binaries.

**Carried over from Revision 2 (verified):**

- $S_t$ collision resolved (two distinct symbols).
- $k_{quad}$ unit "conversion" removed.
- Minimum rest period MILP completed.
- $\eta_d \to \eta_{d,t}$ in aux formula.
- Loss-term division stated as modeling choice.
- Part 1 change request notice.

**Carried over from Revision 1 (verified):**

- Loss term in energy balance (2.2.1).
- Derating applied only to battery-derived term (2.3.2).
- $P_{aux}^{cell}$ substituted in balance.
- $E_{nom}^{cell}$ derivation added (2.2.4).
- $SOC_{reg,min}, SOC_{reg,max}$ constraint added (2.3.9).
- Aux-load architecture assumption stated (2.2.8).
- $\sigma_{reg,t}^{abs}$ in interface table.
- Site balance conditional on configuration.

**Pending:**

- Numerical verification of typical parameter values against manufacturer data.
- Verification of derating function shapes against manufacturer curves.
- Verification of PCS loss curve against manufacturer data.
- Cross-check with Part 3 on SOH consumption and throughput evolution.
- Cross-check with Part 5 on dispatch variable usage and rest constraint implementation.
- **Part 1 sign-off** on the change request (section 2.9).

---

## 2.9 Part 1 change request (carried forward)

**Status:** Issued by Part 2. **Pending Part 1 sign-off.**

The following symbols are used in Part 2 but not yet registered in Part 1's master symbol table. They must be added to Part 1 before the promotion of either part.

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| $\Delta Th_{cycle}$ | Throughput threshold for a full-cycle equivalent | kWh | 1.4.6 (per-step degradation variables) |
| $t_{last}$ | Step index of the last rest period | — | 1.4.1 (state variables) |
| $r_t$ | Binary for rest-counter decrement direction | — | 1.4.2 (decision variables, if registered) |
| $S_t^{loss}$ | Loss-model apparent power (distinct from $S_t$) | kVA | 1.4.3 (derived power variables) |

**Auxiliary-binary convention:** The binaries $c_{cycle,t}$, $p_t$, and $r_t$ are auxiliary MILP variables used for linearization only. They carry **no physical meaning** and are **not registered** in Part 1's master symbol table. If a downstream part needs to query the rest state, it queries $n_{rest,t}$ (registered state), not the auxiliary binaries.

**Recommendation:** Adopt this convention in Part 1 so that Parts 3–5 do not have to re-litigate it. The convention is:

> Auxiliary MILP binaries used exclusively for linearization are **not registered** in the master symbol table. Physical symbols (states, decisions, parameters, derived physical quantities) **are** registered.

**Pressure test:** If a downstream part (Parts 3–5) genuinely needs to reference an auxiliary binary by name, the binary is promoted to a registered decision variable. This promotion requires a Part 1 change request.

**Part 2 is technically blocked on this sign-off.** The parts can proceed in parallel, but neither can be frozen until Part 1 registers the four new symbols and adopts (or rejects) the auxiliary-binary convention.

---

## 2.10 Next steps

Part 2 is **at Revision 3, pending Part 1 sign-off** on the change request. The document is otherwise stable and ready for Parts 3, 4, and 5 to build on.

**Recommended writing order:**

1. **Part 1** — FC5 (or v1.0): process the Part 2 change request. Register the four new symbols and adopt the auxiliary-binary convention.
2. **Part 2** — Revision 3, pending sign-off. Once signed off, promote to v1.0.
3. **Part 4** — Services.
4. **Part 5** — Dispatch, stacking, outputs.
5. **Part 3** — Degradation.

Shall I continue with **Part 1 FC5** (processing the change request), or with **Part 4 — Services**?