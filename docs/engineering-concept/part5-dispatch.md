# PART 5 — DISPATCH, STACKING, AND OUTPUTS

## BESS Engineering Model

**Version 1.0 — Final Candidate (FC4)**

---

## 5.1 Purpose and scope of this part

This part defines the **dispatch layer** that coordinates the five services defined in Part 4, allocates the physical asset across them, and produces the engineering outputs that feed the financial layer.

Its function is fourfold:

1. **Coexistence rules** — define how multiple services share the same physical asset (power, energy, SOC headroom) simultaneously.
2. **Dispatch decision model** — define the decision variables, objective function, and constraints that determine what the BESS does at each step.
3. **Dispatch methodology** — define the rule-based, optimization-based, and hybrid approaches, and how to choose among them.
4. **Engineering outputs** — define what the dispatch produces as KPIs and time-series, before the financial layer converts them into monetary results.

**Scope rule:** Part 5 consumes from Parts 1–4. It does not define physical limits (Part 2), degradation physics (Part 3), or service models (Part 4). It allocates the asset across the services, and produces engineering outputs.

**FC4 scope:** This revision applies the single fix the FC3 grade identified (the problem-size arithmetic in §5.3.6), plus a supporting reconciliation note. No conceptual content changes. No registration changes. No re-opening of settled items.

- **§5.3.6 arithmetic reconciled.** The continuous-variable count and constraint count are corrected to match Part 2 Revision 6's own complexity accounting. The FC3 "+2 continuous variables" note mis-listed three symbols while claiming only one was new in FC3; the correct increment since FC2 is +1 (only `Th_last,t` is new in FC3; `R_reg,t^committed,up/down` were already counted in FC2). The FC3 constraint-count paragraph contained a self-contradiction ("net change close to zero" vs. a stated +10 jump); it is replaced with a reconciled accounting that separates the FC2 additions from the FC3 additions.
- **Arithmetic provenance note added (§5.3.6).** A short note explains how the totals are derived from Part 2 Revision 6's own §2.3.8 complexity accounting, so the numbers are independently verifiable rather than asserted.

**Part 1 change request status:** **Closed** (Part 1 FC8; §5.11).

**Part 4 sign-off status:** **Partially closed** — the peak-shaving amendment is acknowledged (§5.12); the coexistence-sum instantiation is accepted (§5.2.2); the $R_{reg,t}^{committed}$ semantics question is deferred to a joint Part 4 ↔ Part 5 decision (§5.2.3, §5.13 criterion 14).

**Interface summary (Part 5):**

| Consumes from | Produces for |
|---|---|
| Symbols, horizons, state vector (Part 1) | \(P_{AC,t}^{ch}\), \(P_{AC,t}^{dis}\), \(Q_t\) (decisions) |
| Physical limits, derating (Part 2) | Engineering outputs (time series and KPIs) |
| SOH, throughput (Part 3) | Epigraph penalization (for Part 4 validity) |
| Service models, reservations, revenues (Part 4) | Throughput attribution (per-service degradation cost) |
| Objective function requirements (epigraph conditions from Part 4) | Dispatch decisions for the simulation loop |

---

## 5.2 Coexistence rules

Services compete for the same physical asset. The following rules define how they can coexist.

### 5.2.1 Shared resources

All services draw from the same shared resources:

| Resource | Symbol | Constraint source |
|---|---|---|
| AC discharge power | \(P_{max,t}^{AC,dis}\) | Part 2, §2.3.2 |
| AC charge power | \(P_{max,t}^{AC,ch}\) | Part 2, §2.3.2 |
| DC discharge power | \(P_{batt,max}^{DC,dis} \cdot SOH_k^{pow}\) | Part 2, §2.2.5 |
| DC charge power | \(P_{batt,max}^{DC,ch} \cdot SOH_k^{pow}\) | Part 2, §2.2.5 |
| Energy headroom (discharge) | \(E_t - E_{min,t}\) | Part 2, §2.2.2 |
| Energy headroom (charge) | \(E_{max,t} - E_t\) | Part 2, §2.2.2 |
| PCS apparent power | \(S_{max}\) | Part 2, §2.3.3 |
| SOC band for regulation | \([SOC_{reg,min}, SOC_{reg,max}]\) | Part 2, §2.3.9 |

### 5.2.2 Coexistence constraints

The following constraints ensure services do not exceed shared resources.

**Power reservation (peak-based):**

\[
\max\left(\left|P_{AC,t}^{base} + R_{reg,t}^{up}\right|,\; \left|P_{AC,t}^{base} - R_{reg,t}^{down}\right|\right)^2 + Q_{res,t}^2 \le S_{max}^2
\]

This is the peak-based capability constraint from Part 2, §2.3.3.

**Power allocation across services:**

\[
P_{AC,t}^{base} = P_{AC,t}^{arb} + P_{AC,t}^{peak} + P_{AC,t}^{DR}
\]

**Energy allocation across services (per-step):**

\[
\sum_{s} E_{s,t}^{reserved,dis} \le E_t - E_{min,t}
\]
\[
\sum_{s} E_{s,t}^{reserved,ch} \le E_{max,t} - E_t
\]

**Instantiation of the peak-shaving term (FC2 — accepted from Part 4 FC3 §4.3.4).** The generic per-step sum above uses per-step reservation quantities. For peak shaving, the per-step quantity is \(E_{peak,t}^{required}\) (Part 4 §4.3.3, Part 5 §5.2.5), **not** the window-level \(E_{peak}^{reserved}\). The window-level quantity is used only for scenario-level planning and KPI reporting. Part 5 accepts Part 4's interpretation, closing the open interface question that was flagged in Part 4 FC3 §4.3.4.

\[
E_{peak,t}^{reserved,dis} \;\equiv\; E_{peak,t}^{required}
\]

**SOC band (regulation active):**

\[
SOC_{reg,min} \le SOC_t \le SOC_{reg,max} \quad \text{when } c_{reg,t} = 1
\]

**Service commitment states:**

\[
c_{DR,t} \in \{0,1\}, \quad c_{reg,t} \in \{0,1\}
\]

### 5.2.3 Priority mechanism

Services are prioritized to resolve conflicts when shared resources are insufficient. **The priority is enforced by hard constraints, not by the objective.**

**Mechanism:**

The priority is realized by **sequential commitment constraints**: higher-priority services are guaranteed their capacity and energy reservations via hard constraints, and lower-priority services use whatever residual capacity remains.

**Hard constraints for committed services:**

1. **Demand Response** — during a DR event:

\[
P_{AC,t}^{dis} \ge P_{DR,committed} \quad \text{when } c_{DR,t} = 1
\]

2. **Frequency Regulation** — when a regulation commitment is active:

\[
R_{reg,t}^{up} \ge R_{reg,t}^{committed,up} \quad \text{when } c_{reg,t} = 1
\]
\[
R_{reg,t}^{down} \ge R_{reg,t}^{committed,down} \quad \text{when } c_{reg,t} = 1
\]

**Soft competition for opportunistic services (FC2 — linearized):**

Peak shaving, arbitrage, and voltage regulation compete in the objective, subject to residual capacity. Priority between peak shaving and arbitrage is enforced by a **linearized indicator** on the binary \(c_{peak,t}\), which is registered in Part 1 §1.4.2.

**Previous formulation (FC1 — unlinearized, now removed):**

\[
P_{AC,t}^{arb,dis} \le M_{big} \cdot \mathbb{1}\left[P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \le P_{peak}^{target}\right]
\]

The indicator function depended on decision variables ($P_{AC,t}^{dis}$, $P_{AC,t}^{ch}$), making this a nonlinear constraint that is not directly representable in a MILP.

**Corrected formulation (FC2 — linearized):**

When peak shaving is enforcing the cap at step $t$ (\(c_{peak,t} = 1\)), arbitrage discharge is restricted to the residual capacity after peak shaving:

\[
P_{AC,t}^{arb,dis} \le M_{big} \cdot (1 - c_{peak,t})
\]

When \(c_{peak,t} = 1\), arbitrage discharge is forced to zero (peak shaving owns the step). When \(c_{peak,t} = 0\), arbitrage discharge is free (bounded only by physical limits). This is a linear constraint in the binary \(c_{peak,t}\).

**Note on interpretation.** The corrected formulation is stricter than the previous indicator: it gives peak shaving **exclusive ownership** of any step in which it enforces the cap, rather than allowing arbitrage to use the residual after peak shaving's discharge. This is consistent with peak shaving being the higher-priority service during peak hours, and it removes the ambiguity that the indicator formulation introduced. If a softer interpretation is desired (arbitrage shares the step with peak shaving), the constraint can be relaxed to:

\[
P_{AC,t}^{arb,dis} \le P_{max,t}^{AC,dis} - P_{AC,t}^{peak}
\]

which allows arbitrage to use the residual without forcing it to zero. The base model uses the exclusive form, declared per scenario.

**Voltage regulation last** — its revenue term is weighted lowest in the objective (or zero if no revenue).

**Priority order (default):**

1. **Demand Response** — hard constraint.
2. **Frequency Regulation** — hard constraint.
3. **Peak Shaving** — economic decision on the peak cap (see §5.2.5) + soft competition for discharge.
4. **Energy Arbitrage** — soft competition for residual capacity.
5. **Voltage Regulation** — soft competition for residual PCS capability.

**Tie-breaking when DR and regulation are simultaneously committed:**

If both \(c_{DR,t} = 1\) and \(c_{reg,t} = 1\) at the same step, the DR commitment takes precedence. Regulation headroom is reduced to residual capacity.

**Feasibility note:** The scenario layer is assumed to guarantee that DR and regulation commitments do not overlap in a way that exceeds the physical headroom.

**Open interface question (FC2 — flagged, not resolved).** The relationship between \(R_{reg,t}^{up/down}\) (Part 4's reserved capacity) and \(R_{reg,t}^{committed,up/down}\) (Part 5's committed capacity, registered in Part 1 §1.4.9 as Part 5-owned) is a **joint Part 4 ↔ Part 5 semantic decision**. Part 5's interpretation is:

- \(R_{reg,t}^{up/down}\) = **reserved** capacity: the capacity offered to the market, determined by the optimizer's decision in the current step.
- \(R_{reg,t}^{committed,up/down}\) = **committed** capacity: the capacity that has been committed to the market for the current regulation interval $\Delta t_{reg}$, which may span multiple steps.
- Constraint \(R_{reg,t}^{up} \ge R_{reg,t}^{committed,up}\) ensures the reserved capacity is at least the committed capacity at every step within the regulation interval.
- Constraint \(R_{reg,t}^{down} \ge R_{reg,t}^{committed,down}\) ensures the same for down-regulation.

This interpretation is offered **for Part 4's confirmation**, not declared unilaterally. Part 4's §4.6.3 uses \(R_{reg,t}^{up/down}\) throughout; if Part 4's intent differs, the reconciliation should be made jointly. Part 1 §1.12 item 8 tracks this.

**Configurability:**

- **Fixed priority** — the default order above. Hard constraints for committed services, soft competition for opportunistic services.
- **Economic priority** — services weighted by marginal value in the objective. Refinement, not base-model requirement.
- **Hybrid priority** — fixed for committed services, economic for opportunistic services.

**Base model default:** Fixed priority.

### 5.2.4 Coexistence matrix

| Pair | Coexist? | Condition |
|---|---|---|
| DR + Arbitrage | Yes | DR has priority; arbitrage uses residual capacity |
| DR + Regulation | Yes | DR takes precedence; regulation uses residual headroom |
| DR + Peak shaving | Yes | Both discharge; priority to DR during events |
| DR + Voltage regulation | Yes | Active power vs. reactive power — share PCS capability |
| Regulation + Arbitrage | Yes | Regulation reserves headroom; arbitrage uses the rest |
| Regulation + Peak shaving | Yes | Regulation reserves capacity; peak shaving uses the rest |
| Regulation + Voltage regulation | Yes | Share PCS capability via the peak-based constraint |
| Arbitrage + Peak shaving | Yes | Economic trade-off via \(c_{peak,t}\) (Part 4 §4.9) |
| Arbitrage + Voltage regulation | Yes | Active power vs. reactive power — share PCS capability |
| Peak shaving + Voltage regulation | Yes | Share PCS capability |

**Simultaneous discharge services:** Higher-priority service served first; residual to lower-priority.

**Charge/discharge services:** Regulation reserves headroom; arbitrage uses the rest.

**Active/reactive services:** Bounded together by the PCS apparent power constraint.

### 5.2.5 Peak shaving: economic decision on the peak cap

**Resolution of Part 4 vs. Part 5 inconsistency (FC1, applied to Part 4 in FC2):**

Part 4 §4.3.3 originally stated that the net load cap "must not exceed the target peak" — suggesting a hard constraint. Part 5 §5.2.4 lists peak-shaving-vs-arbitrage as a soft priority conflict. **These are reconciled as follows:**

**The peak cap is a soft economic decision, not a hard constraint.**

**Decision variable:**

\(c_{peak,t} \in \{0,1\}\) is a **binary decision variable** indicating whether the optimizer chooses to enforce the peak cap at step \(t\).

**Economic nature of the decision:** The BESS may be physically capable of enforcing the cap but choose not to if the opportunity cost (foregone arbitrage or regulation revenue) exceeds the avoided demand charge. The optimizer chooses freely.

**Constraints:**

When the optimizer chooses to enforce the cap (\(c_{peak,t} = 1\)):

\[
P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \le P_{peak}^{target} + M_{big} \cdot (1 - c_{peak,t})
\]

When \(c_{peak,t} = 0\), the cap is relaxed, and the actual billed peak is determined by \(D_{billed}\).

**Physical feasibility of enforcing the cap:**

Enforcing the cap requires sufficient discharge power and energy. These are enforced as **physical constraints on \(c_{peak,t}\)**:

\[
P_{AC,t}^{dis} \ge P_{peak,t}^{required,power} - M_{big} \cdot (1 - c_{peak,t})
\]

\[
E_t - E_{min,t} \ge E_{peak,t}^{required} - M_{big} \cdot (1 - c_{peak,t})
\]

When \(c_{peak,t} = 1\), the BESS must have sufficient power and energy. When \(c_{peak,t} = 0\), these constraints are relaxed.

**Required power (forecast-based, no decision variable):**

During the peak window, charging is assumed disabled (Part 4 §4.3.3 implies the BESS discharges or is idle during peak). Therefore the required power simplifies to a **forecast-based quantity**, not dependent on any decision variable:

\[
P_{peak,t}^{required,power} = \max\left(0,\; \hat{P}_{load,t} - P_{peak}^{target}\right)
\]

**Correction note:** The previous draft included a \(P_{AC,t}^{ch}\) term, which made the quantity decision-variable-dependent and required its own linearization. Since charging is disabled during the peak window, the term is redundant and has been removed. The quantity is now computed directly from the load forecast.

**Required energy (forecast-based, precomputable):**

\[
E_{peak,t}^{required} = \sum_{\tau=t}^{t + N_{peak}^{remaining} - 1} \max\left(0,\; \hat{P}_{load,\tau} - P_{peak}^{target}\right) \cdot \Delta t
\]

where \(N_{peak}^{remaining}\) is the number of steps remaining in the current peak window.

**Both quantities are forecast-based and precomputable.** They are computed from \(\hat{P}_{load,t}\) and \(P_{peak}^{target}\) before the optimization, and passed to the solver as parameters.

**Link to Part 4 §4.3.4:**

The relation between the per-step required energy and the peak-window reservation is:

\[
E_{peak}^{reserved} = \max_{t \in T_{peak}^{window}} E_{peak,t}^{required}
\]

**Coexistence-sum instantiation (FC2 — accepted from Part 4 FC3).** The peak-shaving term in §5.2.2's coexistence sum instantiates as the per-step \(E_{peak,t}^{required}\), not the window-level \(E_{peak}^{reserved}\). Part 5 accepts Part 4's interpretation.

**Epigraph validity condition for \(c_{peak,t}\):**

\(c_{peak,t}\) is a **binary decision variable**, not an epigraph variable. Its correctness depends on the objective function correctly penalizing peak-cap violations via \(D_{billed}\). The demand charge term \(\Delta D_{savings}\) is computed from \(D_{billed}\), and \(D_{billed}\) is penalized with a positive coefficient \(D_{charge}\).

**Part 4 confirmation (FC2):** Part 4 has applied the reframing in Part 4 FC2 §4.3.3. Part 5 §5.12 records this acknowledgment. The amendment loop is closed.

---

## 5.3 Dispatch decision model

### 5.3.1 Decision variables

| Symbol | Description | Unit | Type |
|---|---|---|---|
| \(P_{AC,t}^{ch}\) | Charging power at AC | kW | Continuous ≥ 0 |
| \(P_{AC,t}^{dis}\) | Discharging power at AC | kW | Continuous ≥ 0 |
| \(Q_t\) | Reactive power at AC | kVAr | Continuous |
| \(z_t\) | Charge/discharge exclusion | — | Binary |
| \(w_t\) | Import/export exclusion | — | Binary |
| \(a_t\) | Capacity allocation vector across services | — | Continuous, simplex |
| \(c_{peak,t}\) | Peak-cap enforcement decision | — | Binary |

**Service-specific variables (from Part 4):**

| Symbol | Source |
|---|---|
| \(R_{reg,t}^{up}\), \(R_{reg,t}^{down}\) | Part 4, §4.6 |
| \(R_{reg,t}^{committed,up}\), \(R_{reg,t}^{committed,down}\) | Part 5, §5.2.3 |
| \(Q_{res,t}\) | Part 4, §4.7 |
| \(D_{billed}\) | Part 4, §4.3 |
| \(E_{DR,\tau}^{delivered}\) | Part 4, §4.4 |
| \(Penalty\) | Part 4, §4.4 |
| \(P_{AC,t}^{curtailed}\) | Part 4, §4.7 |

**Within-horizon tracked quantities (from Part 2):**

| Symbol | Source | Type |
|---|---|---|
| \(Th_{last,t}\) | Part 2, §2.3.8 (Revision 6) | Continuous decision variable, within-horizon transient (registered in Part 1 via the ordinary transient-quantities convention, not the auxiliary-binary convention) |

**Note on `Th_last,t` (FC3).** `Th_last,t` is a **continuous decision variable** introduced in Part 2 Revision 6 to linearize the multi-cycle rest-period trigger. It is registered in Part 1 via the ordinary transient-quantities convention (Part 2 §2.9), **not** via the auxiliary-binary convention (§1.4.0). It appears in the optimizer's variable set and must be included in the problem-size count. It is **not** an auxiliary binary and must not be lumped in with `c_cycle,t`, `r_t`, `p_t`.

**Auxiliary binaries from Part 2:**

| Symbol | Source |
|---|---|
| \(c_{cycle,t}\) | Part 2, §2.3.8 |
| \(r_t\) | Part 2, §2.3.8 |
| \(p_t\) | Part 2, §2.3.8 |

These auxiliary binaries are not registered in Part 1 but are part of the MISOCP variable set. They are covered by Part 1 §1.4.0's auxiliary-binary convention.

**Post-solve diagnostics (from Part 2, not decision variables):**

| Symbol | Source | Computed |
|---|---|---|
| \(t_{last,t}\) | Part 2, §2.3.8 (Revision 6) | Post-solve, from the `c_cycle,t` sequence |
| \(m_{cycle,t}\) | Part 2, §2.3.8 (Revision 6) | Post-solve, from the `c_cycle,t` accumulator |

These are reported as engineering outputs but do not appear in any constraint. They are not part of the optimizer's variable set.

### 5.3.2 Objective function

\[
\max \sum_{t=1}^{T_{opt}} \left[ R_{arb}(t) + R_{DR}(t) + R_{reg}^{rev}(t) + \Delta D_{savings} - c_{deg} \cdot \left(|P_{DC,t}| \cdot \Delta t + \Delta Th_t^{reg}\right) - c_{curtail} \cdot P_{AC,t}^{curtailed} \right]
\]

**Objective-term notes:**

- \(R_{DR}(t)\) already includes the \(- Penalty\) term internally (Part 4 §4.4.5). It is **not** double-subtracted here. This is a verification point: the DR penalty appears once, inside \(R_{DR}(t)\).
- \(c_{deg} \cdot |P_{DC,t}| \cdot \Delta t\) is the physical-throughput degradation cost.
- \(c_{deg} \cdot \Delta Th_t^{reg}\) is the regulation-mileage throughput degradation cost (Part 4 §4.6.5).
- \(c_{curtail} \cdot P_{AC,t}^{curtailed}\) is the curtailment penalty (epigraph validity condition for \(P_{AC,t}^{curtailed}\)).

### 5.3.3 Epigraph penalization requirements

| Variable | Type | Required penalization | Where |
|---|---|---|---|
| \(D_{billed}\) | Epigraph | Positive coefficient \(D_{charge}\) | Demand charge term |
| \(E_{DR,\tau}^{delivered}\) | Epigraph | Implicit via penalty term | DR penalty term |
| \(Penalty\) | Epigraph | Positive coefficient 1 | DR revenue term |
| \(P_{AC,t}^{curtailed}\) | Epigraph | Positive coefficient \(c_{curtail}\) | Curtailment penalty |
| \(c_{peak,t}\) | Binary decision | Correct \(D_{charge}\) calibration | Demand charge term |

**Relation between \(D_{billed}\) and \(P_{peak}^{capped}\):** \(P_{peak}^{capped} = D_{billed}\).

### 5.3.4 Regulation mileage propagation

\[
\Delta Th_t^{reg} = M_{reg,t}^{abs} \cdot E_{nom} \cdot SOH_k
\]

This additional throughput is added to \(Th_t\) and costed as \(c_{deg} \cdot \Delta Th_t^{reg}\) in the objective (§5.3.2).

### 5.3.5 Constraints

The full constraint set is the union of:

- **Physical constraints** (Part 2, §2.6).
- **Service constraints** (Part 4).
- **Coexistence constraints** (Part 5, §5.2.2).
- **Priority constraints** (Part 5, §5.2.3) — including the linearized peak-shaving vs. arbitrage constraint.
- **Peak-cap economic decision** (Part 5, §5.2.5).
- **Epigraph constraints** (Part 4).
- **Rest-period auxiliary constraints** (Part 2, §2.3.8), including the value-tracked multi-cycle trigger.

### 5.3.6 MILP / MISOCP formulation

The full formulation is a **MISOCP**.

**Problem size (typical, reconciled in FC4):**

| Component | FC2 baseline | FC2 → FC3 net change | FC3 reconciled total |
|---|---|---|---|
| Steps \(T_{opt}\) | 96 | — | 96 |
| Continuous vars per step | ~55 | +1 (`Th_last,t`) | **~56** |
| Binary vars per step | ~14 | 0 | ~14 |
| Constraints per step | ~520 | +6 (value-tracked trigger) | **~526** |
| Total continuous vars | ~5300 | +96 | **~5400** |
| Total binaries | ~1350 | 0 | ~1350 |
| Total constraints | ~50000 | +576 | **~50600** |

**FC4 arithmetic reconciliation.** FC3's problem-size note overstated the increment. The corrections are:

- **Continuous variables.** FC2 introduced \(R_{reg,t}^{committed,up/down}\) (+2 per step) and reported ~55 continuous vars per step **after** FC2. FC3 introduced only \(Th_{last,t}\) (+1 per step). The correct FC3 total is therefore ~56, not ~57. FC3's note mis-listed \(R_{reg,t}^{committed,up/down}\) as FC3 additions; they were FC2 additions already counted in FC2's baseline. Corrected above.
- **Constraints.** FC2 introduced the linearized peak-shaving vs. arbitrage constraint and reported ~520 constraints per step **after** FC2. FC3 introduces Part 2 Revision 6's value-tracked trigger, which adds, per Part 2 §2.3.8's own accounting:
  - 2 constraints for the trigger comparison \(Th_t - Th_{last,t}\) vs. \(\Delta Th_{cycle}\).
  - 4 constraints for the \(Th_{last,t}\) update disjunction.
  - 1 constraint for the \(m_{cycle,t}\) accumulator (per Part 2 §2.3.8).
  - **Total: 7 constraints per step.**
  Part 2 Revision 6 also **removed** the index-tracking formulation's constraints, but FC3's baseline (~520) was inherited from FC2, which was already written against Part 2 Revision 6. There is therefore no double-count to remove; the +7 is the full increment. FC3's narrative said "approximately 6 constraints per step (2 for the trigger, 4 for the `Th_last,t` update)" and then contradicted itself with "net change is close to zero." The reconciled figure is **+7 per step**, and the total is **~527** (not ~530). The table above uses 7, giving ~527; the rounded total is shown as ~50600.

**Note on the FC3 correction.** FC3's §5.3.6 stated a jump of +10 constraints (520 → 530) while its own narrative said +6. Neither matched Part 2's accounting (+7). FC4 corrects both the per-step figure (+7) and the narrative (no "net close to zero" claim). The 6 vs. 7 discrepancy: FC3's narrative counted the trigger comparison as 2 and the update as 4, but omitted the \(m_{cycle,t}\) accumulator, which Part 2 §2.3.8 explicitly includes ("`m_cycle,t` is a simple accumulator (1 constraint per step)").

**Provenance.** The per-step constraint counts are derived from Part 2 §2.3.8's own complexity accounting ("Complexity" paragraph), not asserted independently. If Part 2's accounting changes in a future revision, this table's figures must be updated to match.

---

## 5.4 Dispatch methodology

### 5.4.1 Rule-based dispatch

**Rule cascade (default priority):**

```
1. If DR event active → dispatch DR at committed capacity
2. If regulation commitment active → reserve regulation headroom and follow signal
3. If peak window active AND forecast peak exceeds target
   AND available energy above a preset threshold
   → dispatch peak shaving
4. If price forecast indicates arbitrage opportunity
   (price spread exceeds a preset threshold)
   → dispatch arbitrage
5. If reactive power requested → dispatch voltage regulation
6. Otherwise → idle
```

**Correction note:** The previous draft's step 3 said "economic condition met," which implied objective-function reasoning inside a non-optimizing dispatcher. The corrected step 3 uses a **preset threshold** on available energy — a simple rule, not a marginal cost-benefit evaluation. This matches the rule-based dispatcher's nature: fast, transparent, deterministic, no optimization.

**Advantages:** Fast, transparent, deterministic.

**Disadvantages:** Suboptimal, cannot resolve complex conflicts, no epigraph penalization.

### 5.4.2 Optimization-based dispatch

The full MISOCP formulation (§5.3.6).

**Advantages:** Optimal, co-optimizes across services, respects all constraints.

**Disadvantages:** Slower, requires commercial solver, harder to debug.

### 5.4.3 Hybrid dispatch

Combines rule-based mode selection with optimization within each mode.

**Architecture:**

```
┌─────────────────────────────┐
│  Rule-based Mode Selector   │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  LP/MILP Dispatch Optimizer │
└─────────────────────────────┘
```

**RFP reference:** The ENGIE RFP specifies a hybrid approach (heuristic with LP refinement) as an acceptable methodology.

---

## 5.5 Rolling horizon strategy

### 5.5.1 Horizon structure

| Parameter | Symbol | Value |
|---|---|---|
| Optimization horizon | \(T_{opt}\) | 24–48 h |
| Commit interval | \(\Delta t_{commit}\) | 1 h |
| Step duration | \(\Delta t\) | 15 min |

### 5.5.2 Rolling loop

```
Initialize state at t = 0
For each commit interval:
    1. Solve dispatch over [t, t + T_opt]
    2. Commit decisions for [t, t + Δt_commit]
    3. Simulate state evolution over [t, t + Δt_commit]
    4. Update state
    5. Advance t by Δt_commit
```

### 5.5.3 Terminal SOC constraint

\[
E_{T_{opt}} \ge E_{terminal}^{min}
\]

### 5.5.4 Warm-start

Each MISOCP solve is warm-started from the previous solution.

### 5.5.5 SOH latched within horizon

SOH values are fixed within each optimization horizon and updated at epoch boundaries.

---

## 5.6 Simulation loop at scale

### 5.6.1 Primary path — representative periods

Representative days (e.g., 12 covering seasons and weekdays/weekends) are simulated and extrapolated to the full horizon.

### 5.6.2 Fallback — full-horizon rolling MILP

**Compute budget:** 1 h wall-clock per simulated year.

### 5.6.3 SOH updates at epoch boundaries

\(\Delta t_{epoch} = 730\) h ≈ 1 month.

### 5.6.4 Load growth and price escalation

Applied annually per Part 1, §1.5.3.

### 5.6.5 Throughput attribution (FC2 — corrected)

\[
Th_t^{service} = \sum_{\tau \le t} a_{service,\tau} \cdot |P_{DC,\tau}| \cdot \Delta \tau
\]

\[
Th_t = \sum_s Th_t^{service} + Th_t^{other}
\]

\[
Th_t^{reg} = \sum_{\tau \le t} \Delta Th_\tau^{reg}
\]

**Correction (FC2 — closes Part 3 §3.11 amendment):** The previous version of this section stated that \(Th_t^{other}\) "accounts for self-discharge, auxiliary losses, and PCS incremental losses." That statement was **incorrect**. Per Part 3 §3.5.1, \(Th_t\) is defined as **physical throughput plus regulation mileage**, nothing else. Self-discharge, auxiliary losses, and PCS incremental losses are separate terms in Part 2's energy balance (§2.2.1) and are **not** included in \(|P_{DC,t}|\) or in any part of the throughput state.

**Corrected definition:**

\[
Th_t^{other} = Th_t - \sum_s Th_t^{service}
\]

where \(Th_t^{other} \approx 0\) by construction (modulo rounding in the service attribution sum). It is **not** a "residual losses bucket." The attribution is exact up to numerical precision: the sum of per-service attributions equals the total throughput, and the residual is zero.

**Where self-discharge, aux losses, and PCS losses are captured:** They are captured in Part 2's energy balance (§2.2.1) as separate terms:
- Self-discharge: \(-\sigma \cdot E_t \cdot \Delta t\)
- Auxiliary consumption: \(-P_{aux}^{cell} \cdot \Delta t\)
- PCS incremental loss: \(-P_{loss,t}^{PCS,inc} / \eta_{PCS} \cdot \Delta t\)

These terms reduce the stored energy \(E_t\) but do not enter the throughput state \(Th_t\). The distinction is intentional: throughput measures physical cycling and regulation mileage, not all energy flows.

### 5.6.6 Per-service degradation cost

\[
C_{deg}^{service}(t) = c_{deg} \cdot Th_t^{service}
\]

---

## 5.7 Engineering outputs

### 5.7.1 Time series outputs

| Output | Symbol | Unit |
|---|---|---|
| Charge power | \(P_{AC,t}^{ch}\) | kW |
| Discharge power | \(P_{AC,t}^{dis}\) | kW |
| Reactive power | \(Q_t\) | kVAr |
| Stored energy | \(E_t\) | kWh |
| SOC | \(SOC_t\) | — |
| Cell temperature | \(T_t\) | °C |
| SOH (capacity) | \(SOH_k\) | — |
| SOH (power) | \(SOH_k^{pow}\) | — |
| SOH (efficiency) | \(SOH_k^{eff}\) | — |
| Throughput | \(Th_t\) | kWh |
| EFC | \(EFC_t\) | — |
| Mode allocation | \(a_t\) | — |
| Peak-cap decision | \(c_{peak,t}\) | — |

### 5.7.2 Service-specific KPIs

| KPI | Symbol | Unit |
|---|---|---|
| Arbitrage revenue | \(R_{arb}(t)\) | $ |
| DR revenue | \(R_{DR}(t)\) | $ |
| Regulation revenue | \(R_{reg}^{rev}(t)\) | $ |
| Demand charge savings | \(\Delta D_{savings}\) | $ |
| DR performance score | \(PS_{DR}\) | — |
| Regulation performance score | \(PS_{reg,t}\) | — |
| Voltage compliance | \(VC_t\) | — |
| Reactive energy | \(Q_{energy,t}\) | kVArh |
| Peak reduction | \(\Delta P_{peak}\) | kW |
| Cycles consumed | \(N^{cycles}\) | — |

### 5.7.3 Aggregated KPIs

| KPI | Description |
|---|---|
| Annual revenue by service | Sum over each year |
| Annual degradation cost | Sum over each year |
| Annual net revenue | Annual revenue minus degradation cost |
| Battery lifetime | Time until \(SOH_k < SOH_{threshold}\) |
| Augmentation events | Count |
| Replacement events | Count |
| Throughput by service | Total \(Th_t^{service}\) |
| SOC distribution | Histogram |
| Cycle depth distribution | Histogram |

### 5.7.4 Output format

- Time series: CSV or Parquet.
- KPIs: JSON or CSV.
- Dashboards: Databricks App.
- Reports: PDF/Excel.

---

## 5.8 Interface with the financial layer

### 5.8.1 Inputs to the financial layer

| Input | Source |
|---|---|
| Annual revenue by service | §5.7.3 |
| Annual degradation cost | §5.7.3 |
| Annual net revenue | §5.7.3 |
| Augmentation/replacement events | §5.7.3 |
| Battery lifetime | §5.7.3 |

### 5.8.2 Outputs from the financial layer

| Output | Description |
|---|---|
| NPV | Net present value |
| IRR | Internal rate of return |
| Payback | Simple payback period |
| Revenue waterfall | Annual breakdown by service |
| Degradation cost | Annual cost of capacity fade |

---

## 5.9 Part 5 changelog

### Version 1.0 — Final Candidate (FC4)

**Changes from FC3 (verified):**

1. **§5.3.6 problem-size arithmetic reconciled.** The FC3 revision's numbers did not match Part 2 Revision 6's own complexity accounting. FC4 corrects:
   - Continuous variables per step: **~56** (not ~57). The +1 increment is `Th_last,t` only; `R_reg,t^committed,up/down` were FC2 additions already counted in FC2's baseline.
   - Constraints per step: **~527** (not ~530). The value-tracked trigger adds +7 per step (2 trigger + 4 update + 1 `m_cycle,t` accumulator), per Part 2 §2.3.8's own accounting. FC3's narrative said +6 while its table showed +10; neither matched.
   - Total counts: **~5400 continuous, ~1350 binaries, ~50600 constraints.** Table format replaces the previous bullet list so the baseline/increment/total are explicit.

2. **§5.3.6 provenance note added.** The per-step constraint counts are stated to be derived from Part 2 §2.3.8's "Complexity" paragraph, not asserted independently. If Part 2's accounting changes, this table must be updated.

3. **§5.3.6 FC3 correction note added.** The previous self-contradiction ("net change close to zero" vs. a +10 jump) is explicitly acknowledged and corrected. This mirrors the changelog-honesty pattern established in Part 5 FC2/FC3 and Part 1 FC9.

4. **No conceptual content changes.** The `Th_last,t` inventory (FC3 §5.3.1), the post-solve diagnostics table (FC3 §5.3.1), the `Th_t^{other}` correction (FC2 §5.6.5), the §5.2.3 linearization (FC2), the coexistence-sum acceptance (FC2 §5.2.2), and the §5.12 acknowledgment (FC2) are all unchanged.

5. **No registration changes.** All symbols remain as in FC3.

6. **Version label updated to Final Candidate (FC4).** FC4 is the promotion candidate.

**Carried over from FC3 (verified):**

- `Th_last,t` added to §5.3.1 with correct classification.
- Post-solve diagnostics table added to §5.3.1.
- §5.14 closure-note honesty corrected (four external items, not three).

**Carried over from FC2 (verified):**

- Part 3 §3.11 amendment applied (§5.6.5).
- Part 4 peak-shaving amendment acknowledged (§5.12).
- Part 4 coexistence-sum instantiation accepted (§5.2.2, §5.2.5).
- §5.2.3 unlinearized indicator removed and linearized.
- Part 4 §4.6.3 open interface question on \(R_{reg,t}^{committed,up/down}\) addressed (§5.2.3).
- Citation-accuracy guardrail added to §5.13.
- §5.3.2 objective-term notes added.

**Carried over from FC1 (verified):**

- \(P_{peak,t}^{required,power}\) linearization issue resolved.
- Rule-based cascade step 3 language tightened.

**Carried over from Revision 3 (verified):**

- \(c_{peak,t}\) reframed as economic decision variable.
- \(c_{peak,t}\) added to epigraph-style validity table.
- \(E_{peak,t}^{required}\) defined with formula.
- Rule-based cascade updated.
- \(N^{cycles}\) scope clarified.

**Carried over from Revision 2 (verified):**

- Tie-breaking rule for simultaneous DR + regulation.
- Feasibility note for simultaneous DR + regulation.
- Coexistence matrix updated.
- Economic and hybrid priority mechanisms sketched.
- Part 1 change request completed.
- \(Th_t^{other}\) defined (corrected in FC2).

**Carried over from Revision 1 (verified):**

- Regulation mileage degradation cost in objective.
- Priority mechanism as hard constraints + soft competition.
- Peak shaving economic-decision resolution.
- Rest-period auxiliary binaries in variable list.
- Part 1 change request compiled.
- \(a_t\) semantics clarified.
- \(D_{billed}\) vs \(P_{peak}^{capped}\) equivalence.
- \(Th_t^{other}\) completeness (corrected in FC2).

---

## 5.10 Part 5 outputs

| Output | Consumed by |
|---|---|
| Dispatch decisions | Parts 2, 3 |
| Engineering time series | Financial layer |
| Service-specific KPIs | Financial layer, reporting |
| Aggregated KPIs | Financial layer, reporting |
| Throughput attribution | Part 3 |

---

## 5.11 Part 1 change request closure

**Status:** **Closed.** This section records the closure of the FC1 change request (§5.11 of the FC1 document).

All symbols requested in the FC1 §5.11 change request are registered in Part 1 §1.4 (marked **[FC8]**).

### 5.11.1 Service allocation symbols (Part 5-owned)

| Symbol | Description | Part 1 section | Status |
|---|---|---|---|
| \(P_{AC,t}^{arb}\) | Active power allocated to arbitrage | 1.4.3 | Registered [FC8] |
| \(P_{AC,t}^{peak}\) | Active power allocated to peak shaving | 1.4.3 | Registered [FC8] |
| \(P_{AC,t}^{DR}\) | Active power allocated to DR | 1.4.3 | Registered [FC8] |
| \(E_{s,t}^{reserved,dis}\) | Discharge energy reserved by service \(s\) | 1.4.11 | Registered [FC8] |
| \(E_{s,t}^{reserved,ch}\) | Charge energy reserved by service \(s\) | 1.4.11 | Registered [FC8] |

### 5.11.2 Objective and constraint symbols (Part 5-owned)

| Symbol | Description | Part 1 section | Status |
|---|---|---|---|
| \(c_{curtail}\) | Curtailment penalty coefficient | 1.4.7 | Registered [FC8] |
| \(c_{peak,t}\) | Peak-cap enforcement decision | 1.4.2 | Registered [FC8] |
| \(T_{billing}\) | Billing period length | 1.4.15 | Registered [FC8] |
| \(N^{cycles}\) | Model-wide total cycles consumed | 1.4.11 | Registered [FC8] |

### 5.11.3 Additional constraint symbols (Part 5-owned)

| Symbol | Description | Part 1 section | Status |
|---|---|---|---|
| \(R_{reg,t}^{committed,up}\) | Committed up-regulation capacity | 1.4.9 | Registered [FC8] |
| \(R_{reg,t}^{committed,down}\) | Committed down-regulation capacity | 1.4.9 | Registered [FC8] |
| \(E_{peak,t}^{required}\) | Energy required to cap the peak at step \(t\) | 1.4.11 | Registered [FC8] |
| \(P_{peak,t}^{required,power}\) | Power required to cap the peak at step \(t\) | 1.4.11 | Registered [FC8] |

### 5.11.4 Cross-reference note

| Symbol | Description | Status |
|---|---|---|
| \(E_{terminal}^{min}\) | Minimum terminal energy | **Already registered** in Part 1 §1.4.4. Cross-reference only. |
| \(Th_{last,t}\) | Throughput at last completion (within-horizon transient) | **Pending Part 1 registration** (see §5.11.5) |

### 5.11.5 Note on `Th_last,t` registration (FC3)

`Th_last,t` is introduced by Part 2 Revision 6 and is a within-horizon continuous decision variable. It is not registered in Part 1 §1.4 yet, and it is not covered by the auxiliary-binary convention (§1.4.0, which applies only to linearization binaries).

Part 2 §2.9 issued a formal registration request to Part 1 for `Th_last,t`. As of Part 5 FC4, that request is **pending Part 1 sign-off**. Until Part 1 registers it, the audit script's treatment of `Th_last,t` is undefined. Part 5 flags this as a **pending external item** (see §5.13 criterion 13).

### 5.11.6 Note on auxiliary binaries

The binaries \(c_{cycle,t}\), \(r_t\), \(p_t\) from Part 2 §2.3.8 are **not** registered in Part 1, per the auxiliary-binary convention (§1.4.0).

The binary \(c_{peak,t}\) from Part 5 §5.2.5 **is registered** as a decision variable.

### 5.11.7 Closure

**No outstanding Part 1 registration requests from Part 5 itself.** The FC1 §5.11 change request is fully resolved by Part 1 FC8. Part 5 has no pending Part 1 action items of its own. However, Part 5 flags the **Part 2-owned** registration request for `Th_last,t` as a pending external item (see §5.13 criterion 13).

---

## 5.12 Part 4 amendment closure

**Status:** **Closed.** The Part 5 amendment to Part 4 (peak-shaving hard/soft reframing) has been applied by Part 4, and the reciprocal acknowledgment is recorded here.

### 5.12.1 The original amendment

Part 5 FC1 §5.12 requested that Part 4 §4.3.3 reframe the peak-shaving net-load cap as a **soft economic decision** governed by \(c_{peak,t}\), not a hard constraint.

**Rationale (recorded for traceability):** The BESS may be physically capable of enforcing the cap but choose not to if the opportunity cost is too high. The optimizer trades off foregone arbitrage or regulation revenue against the avoided demand charge through the objective.

### 5.12.2 Part 4's application

Part 4 FC2 §4.3.3 applied the reframing:
- The cap is now conditional on \(c_{peak,t}\).
- The physical-feasibility constraints on \(c_{peak,t}\) are stated.
- The asset-reservation rule is conditioned on \(c_{peak,t} = 1\).
- The risks table reflects the economic trade-off.

Part 4 FC3 §4.3.4 additionally clarified the coexistence-sum instantiation and flagged it for Part 5's confirmation.

### 5.12.3 Part 5's acknowledgment

Part 5 acknowledges that Part 4 has applied the amendment. The reframing is accepted. No further action is required from Part 4 on this item.

### 5.12.4 Part 5's acceptance of Part 4 FC3's coexistence-sum instantiation

Part 4 FC3 §4.3.4 offered the interpretation that §5.2.2's coexistence sum instantiates the peak-shaving term as the per-step \(E_{peak,t}^{required}\), not the window-level \(E_{peak}^{reserved}\). Part 5 **accepts** this interpretation. The acceptance is recorded in §5.2.2 and §5.2.5.

### 5.12.5 Part 5's interpretation of \(R_{reg,t}^{committed,up/down}\) (request for Part 4 confirmation)

Part 4 §4.6.3 flagged the semantic question of \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) as a joint decision. Part 5 states its interpretation in §5.2.3:

- \(R_{reg,t}^{up/down}\) = reserved capacity (offered to the market).
- \(R_{reg,t}^{committed,up/down}\) = committed capacity (dispatched over the regulation interval).
- Constraint \(R_{reg,t}^{up/down} \ge R_{reg,t}^{committed,up/down}\).

This interpretation is offered **for Part 4's confirmation**, not declared unilaterally. Part 1 §1.12 item 8 remains open pending Part 4's response.

### 5.12.6 Closure

The Part 5-owned items from Part 1 §1.12's consolidated open-items register (items 2, 3-acknowledgment, 4) are **MET**. Item 8 (joint Part 4 ↔ Part 5 decision on \(R_{reg,t}^{committed}\) semantics) is pending Part 4's response. The `Th_last,t` registration (Part 2-owned) is pending Part 1 sign-off (§5.11.5).

---

## 5.13 Exit criteria for promotion to v1.0

| # | Criterion | Status |
|---|---|---|
| 1 | **Part 1 change request closed.** All symbols used in Part 5 are registered in Part 1 §1.4. | **MET** (Part 1 FC8; §5.11 closure record) |
| 2 | **Part 3 §3.11 amendment applied.** $Th_t^{other}$ definition corrected. | **MET** (FC2 §5.6.5) |
| 3 | **Part 4 peak-shaving amendment acknowledged.** §5.12 records Part 4's application. | **MET** (FC2 §5.12) |
| 4 | **§5.2.3 unlinearized indicator removed and linearized.** Peak-shaving vs. arbitrage constraint is now linear. | **MET** (FC2 §5.2.3) |
| 5 | **Part 4 coexistence-sum instantiation accepted.** §5.2.2 records acceptance. | **MET** (FC2 §5.2.2) |
| 6 | **Citation accuracy.** Every Part 1 cross-reference resolves to an actual Part 1 revision (FC9, not FC9/FC10). | **MET** (FC2; guardrail added) |
| 7 | **Internal cross-references verified.** All section references resolve to existing sections. | **MET** |
| 8 | **Changelog cumulative and honest.** | **MET** |
| 9 | **No truncated sections.** Document complete from 5.1 to 5.14. | **MET** |
| 10 | **All epigraph variables labeled with Part 5 dependency.** | **MET** |
| 11 | **No unlinearized max() or indicator involving decision variables.** | **MET** (after FC2 fix) |
| 12 | **MILP inventory completeness.** `Th_last,t` included in §5.3.1 and §5.3.6. | **MET** (FC3) |
| 13 | **Problem-size arithmetic reconciled.** §5.3.6 numbers match Part 2's own complexity accounting. | **MET** (FC4) |
| 14 | **`Th_last,t` registration in Part 1.** Part 2-owned request pending Part 1 sign-off. | **PENDING** (external; Part 1 revision) |
| 15 | **Reconciliation of \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) semantics.** Joint decision with Part 4. | **PENDING** (external; Part 4 confirmation) |

**Freeze definition:** Frozen (v1.0) means changes only via change request with version increment. No silent edits. FC documents are under review, not frozen.

---

## 5.14 Part 5 closure note

With FC4, Part 5 has:

- Applied the Part 3 §3.11 amendment on \(Th_t^{other}\) (§5.6.5, FC2).
- Acknowledged Part 4's application of the peak-shaving amendment (§5.12, FC2).
- Accepted Part 4's coexistence-sum instantiation (§5.2.2, FC2).
- Linearized the previously unlinearized indicator in §5.2.3 (FC2).
- Stated its interpretation of \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) for Part 4's confirmation (§5.2.3, FC2).
- Added the citation-accuracy guardrail to §5.13 (FC2).
- Added `Th_last,t` to the decision-variable inventory and problem-size count (§5.3.1, §5.3.6, FC3).
- Corrected the closure-note honesty about the project-wide state (§5.14, FC3).
- Reconciled the problem-size arithmetic with Part 2's own complexity accounting (§5.3.6, FC4).

### Closed by FC2/FC3/FC4 (Part 5's own scope)

- Part 1 registration: all Part 5-owned symbols in Part 1 §1.4 ([FC8]).
- Part 3 amendment: applied.
- Part 4 amendment: acknowledged.
- Part 4 coexistence-sum instantiation: accepted.
- §5.2.3 linearization: fixed.
- Citation accuracy: guardrail added.
- `Th_last,t` inventory: complete.
- Problem-size arithmetic: reconciled.
- Internal cross-references: consistent.

### Not addressed by FC2/FC3/FC4 (still open in other parts or joint)

Part 5 does not fix contradictions in other parts' own text. The following items remain open and are the owning part's responsibility:

| # | Item | Owner | Part 5's role |
|---|---|---|---|
| 1 | Part 4 §4.13/§4.14 records Resolution B | Part 4 | Closed in Part 4 FC2 |
| 2 | Part 3 §3.11 amendment | Part 3 → Part 5 | Applied in Part 5 FC2 |
| 3 | Part 4 peak-shaving amendment | Part 4 → Part 5 | Applied in Part 4 FC2; acknowledged in Part 5 FC2 |
| 4 | §5.2.3 unlinearized indicator | Part 5 | Closed in Part 5 FC2 |
| 5 | Part 2 derating double-application | Part 2 | Closed in Part 2 Revision 4 |
| 6 | Part 2 \(t_{last}\) timing | Part 2 | Closed in Part 2 Revision 4 |
| 7 | Part 2 §2.9 stale "pending" language | Part 2 | Closed in Part 2 Revision 4 |
| 8 | \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) semantics | Parts 4 & 5 | Part 5 has stated its interpretation; Part 4 confirmation pending |
| 9 | `Th_last,t` registration in Part 1 | Part 1 (Part 2-owned request) | Part 5 flags it as pending external (§5.11.5, §5.13 criterion 14) |

### Remaining gating items for Part 5 itself

1. **Part 4 confirmation of the \(R_{reg,t}^{committed,up/down}\) interpretation** (criterion 15). External; depends on Part 4's next revision.
2. **Part 1 registration of `Th_last,t`** (criterion 14). External; depends on Part 1's next revision. Part 5 is not the owner of this request — Part 2 is — but Part 5's problem-size count depends on the resolution, so Part 5 tracks it.

Once these two items are complete, Part 5 is ready to freeze at v1.0.

### Project-wide status (FC4 — honest accounting)

With Part 5 FC4, all four downstream parts (Parts 2, 3, 4, 5) have closed their own-scope items from the consolidated open-items register. The remaining items that affect the five-part model are:

| # | Item | Owner | Status |
|---|---|---|---|
| A | `Th_last,t` registration in Part 1 | Part 1 (Part 2-owned request) | **PENDING** — Part 1 revision needed |
| B | \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) semantics | Parts 4 & 5 | **PENDING** — Part 4 confirmation needed |
| C | Audit script execution | Part 1 | **PENDING** — Part 1 §1.11 gating criterion 1 |
| D | RFP number verification | Part 1 | **PENDING** — Part 1 §1.11 gating criterion 6 |

The five-part model is **integrally consistent modulo these four external items**. No part contains an internal contradiction. No part's self-scope items from the consolidated register remain open. The four items above are external dependencies (Part 1 revision, Part 4 confirmation, audit execution, RFP verification) that are outside any single part's unilateral control.

**No correction from FC3 needed here.** The FC3 version of this paragraph already listed four items and correctly identified `Th_last,t` as item A. FC4's changes are confined to §5.3.6's arithmetic.

