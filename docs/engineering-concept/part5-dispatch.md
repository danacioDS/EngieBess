# PART 5 — DISPATCH, STACKING, AND OUTPUTS

## BESS Engineering Model

**Version 1.0 — Final Candidate (FC1)**

---

## 5.1 Purpose and scope of this part

This part defines the **dispatch layer** that coordinates the five services defined in Part 4, allocates the physical asset across them, and produces the engineering outputs that feed the financial layer.

Its function is fourfold:

1. **Coexistence rules** — define how multiple services share the same physical asset (power, energy, SOC headroom) simultaneously.
2. **Dispatch decision model** — define the decision variables, objective function, and constraints that determine what the BESS does at each step.
3. **Dispatch methodology** — define the rule-based, optimization-based, and hybrid approaches, and how to choose among them.
4. **Engineering outputs** — define what the dispatch produces as KPIs and time-series, before the financial layer converts them into monetary results.

**Scope rule:** Part 5 consumes from Parts 1–4. It does not define physical limits (Part 2), degradation physics (Part 3), or service models (Part 4). It allocates the asset across the services, and produces engineering outputs.

**Sign-off status:** FC1 is functionally complete. Two external sign-offs are pending:

- **Part 1 sign-off** on the change request (section 5.11).
- **Part 4 sign-off** on the peak-shaving clarification (section 5.12).

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

**Energy allocation across services:**

\[
\sum_{s} E_{s,t}^{reserved,dis} \le E_t - E_{min,t}
\]
\[
\sum_{s} E_{s,t}^{reserved,ch} \le E_{max,t} - E_t
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

**Soft competition for opportunistic services:**

Peak shaving, arbitrage, and voltage regulation compete in the objective, subject to residual capacity. Priority is enforced by:

- **Peak shaving before arbitrage** during peak hours:

\[
P_{AC,t}^{arb,dis} \le M_{big} \cdot \mathbb{1}\left[P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \le P_{peak}^{target}\right]
\]

- **Voltage regulation last** — its revenue term is weighted lowest in the objective (or zero if no revenue).

**Priority order (default):**

1. **Demand Response** — hard constraint.
2. **Frequency Regulation** — hard constraint.
3. **Peak Shaving** — economic decision on the peak cap (see §5.2.5) + soft competition for discharge.
4. **Energy Arbitrage** — soft competition for residual capacity.
5. **Voltage Regulation** — soft competition for residual PCS capability.

**Tie-breaking when DR and regulation are simultaneously committed:**

If both \(c_{DR,t} = 1\) and \(c_{reg,t} = 1\) at the same step, the DR commitment takes precedence. Regulation headroom is reduced to residual capacity.

**Feasibility note:** The scenario layer is assumed to guarantee that DR and regulation commitments do not overlap in a way that exceeds the physical headroom.

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
| Arbitrage + Peak shaving | Yes | Both discharge; priority to peak shaving during peak hours |
| Arbitrage + Voltage regulation | Yes | Active power vs. reactive power — share PCS capability |
| Peak shaving + Voltage regulation | Yes | Share PCS capability |

**Simultaneous discharge services:** Higher-priority service served first; residual to lower-priority.

**Charge/discharge services:** Regulation reserves headroom; arbitrage uses the rest.

**Active/reactive services:** Bounded together by the PCS apparent power constraint.

### 5.2.5 Peak shaving: economic decision on the peak cap

**Resolution of Part 4 vs. Part 5 inconsistency:**

Part 4 §4.3.3 states that the net load cap "must not exceed the target peak" — suggesting a hard constraint. Part 5 §5.2.4 lists peak-shaving-vs-arbitrage as a soft priority conflict. **These are reconciled as follows:**

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

**Epigraph validity condition for \(c_{peak,t}\):**

\(c_{peak,t}\) is a **binary decision variable**, not an epigraph variable. Its correctness depends on the objective function correctly penalizing peak-cap violations via \(D_{billed}\). The demand charge term \(\Delta D_{savings}\) is computed from \(D_{billed}\), and \(D_{billed}\) is penalized with a positive coefficient \(D_{charge}\).

**Part 4 confirmation required:** Part 4 §4.3.3 should be amended to clarify that the net load cap is an **economic decision**, not a hard constraint. This is a Part 4 change request (section 5.12).

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
| \(Q_{res,t}\) | Part 4, §4.7 |
| \(D_{billed}\) | Part 4, §4.3 |
| \(E_{DR,\tau}^{delivered}\) | Part 4, §4.4 |
| \(Penalty\) | Part 4, §4.4 |
| \(P_{AC,t}^{curtailed}\) | Part 4, §4.7 |

**Auxiliary binaries from Part 2:**

| Symbol | Source |
|---|---|
| \(c_{cycle,t}\) | Part 2, §2.3.8 |
| \(r_t\) | Part 2, §2.3.8 |
| \(p_t\) | Part 2, §2.3.8 |

These auxiliary binaries are not registered in Part 1 but are part of the MISOCP variable set.

### 5.3.2 Objective function

\[
\max \sum_{t=1}^{T_{opt}} \left[ R_{arb}(t) + R_{DR}(t) + R_{reg}^{rev}(t) + \Delta D_{savings} - c_{deg} \cdot \left(|P_{DC,t}| \cdot \Delta t + \Delta Th_t^{reg}\right) - c_{curtail} \cdot P_{AC,t}^{curtailed} \right]
\]

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

This additional throughput is added to \(Th_t\) and costed as \(c_{deg} \cdot \Delta Th_t^{reg}\).

### 5.3.5 Constraints

The full constraint set is the union of:

- **Physical constraints** (Part 2, §2.6).
- **Service constraints** (Part 4).
- **Coexistence constraints** (Part 5, §5.2.2).
- **Priority constraints** (Part 5, §5.2.3).
- **Peak-cap economic decision** (Part 5, §5.2.5).
- **Epigraph constraints** (Part 4).
- **Rest-period auxiliary constraints** (Part 2, §2.3.8).

### 5.3.6 MILP / MISOCP formulation

The full formulation is a **MISOCP**.

**Problem size (typical):**

- \(T_{opt} = 96\) steps (24 h at 15 min).
- ~50 continuous variables per step.
- ~14 binary variables per step.
- ~500 constraints per step.
- Total: ~5000 continuous vars, ~1350 binaries, ~50000 constraints.

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

### 5.6.5 Throughput attribution

\[
Th_t^{service} = \sum_{\tau \le t} a_{service,\tau} \cdot |P_{DC,\tau}| \cdot \Delta \tau
\]

\[
Th_t = \sum_s Th_t^{service} + Th_t^{other}
\]

\[
Th_t^{reg} = \sum_{\tau \le t} \Delta Th_\tau^{reg}
\]

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

### Version 1.0 — Final Candidate (FC1)

**Changes from Revision 3 (verified):**

1. **\(P_{peak,t}^{required,power}\) linearization issue resolved by removing the decision-variable term (§5.2.5).** The formula now reads \(P_{peak,t}^{required,power} = \max(0, \hat{P}_{load,t} - P_{peak}^{target})\), dropping the \(P_{AC,t}^{ch}\) term. Since charging is disabled during the peak window, the term was redundant. The quantity is now **forecast-based** and precomputable, with no MILP linearization needed.

2. **Rule-based cascade step 3 language tightened (§5.4.1).** The previous "economic condition met" wording was replaced with a concrete **preset threshold** on available energy. This matches the rule-based dispatcher's nature (no objective function).

3. **Version label updated to Final Candidate (FC1).** FC1 is the promotion candidate.

4. **Sign-off status section added (5.1).** The two pending external sign-offs are listed.

5. **No other substantive changes.** FC1 is a final polish and status update.

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
- \(Th_t^{other}\) defined.

**Carried over from Revision 1 (verified):**

- Regulation mileage degradation cost in objective.
- Priority mechanism as hard constraints + soft competition.
- Peak shaving economic-decision resolution.
- Rest-period auxiliary binaries in variable list.
- Part 1 change request compiled.
- \(a_t\) semantics clarified.
- \(D_{billed}\) vs \(P_{peak}^{capped}\) equivalence.
- \(Th_t^{other}\) completeness.

**Dropped from changelog (unverified or recycled):**

- None in this revision.

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

## 5.11 Part 1 change request

**Status:** Issued by Part 5. **Pending Part 1 sign-off.**

### 5.11.1 Service allocation symbols (Part 5-owned)

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(P_{AC,t}^{arb}\) | Active power allocated to arbitrage | kW | 1.4.3 (derived) |
| \(P_{AC,t}^{peak}\) | Active power allocated to peak shaving | kW | 1.4.3 (derived) |
| \(P_{AC,t}^{DR}\) | Active power allocated to DR | kW | 1.4.3 (derived) |
| \(E_{s,t}^{reserved,dis}\) | Discharge energy reserved by service \(s\) | kWh | 1.4.11 (derived) |
| \(E_{s,t}^{reserved,ch}\) | Charge energy reserved by service \(s\) | kWh | 1.4.11 (derived) |

### 5.11.2 Objective and constraint symbols (Part 5-owned)

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(c_{curtail}\) | Curtailment penalty coefficient | $/kWh | 1.4.7 (market/site) |
| \(c_{peak,t}\) | Peak-cap enforcement decision | — | 1.4.2 (decision) |
| \(T_{billing}\) | Billing period length | h | 1.4.15 (temporal) |
| \(N^{cycles}\) | Model-wide total cycles consumed | — | 1.4.11 (derived) |

### 5.11.3 Additional constraint symbols (Part 5-owned)

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(R_{reg,t}^{committed,up}\) | Committed up-regulation capacity | kW | 1.4.9 (regulation) |
| \(R_{reg,t}^{committed,down}\) | Committed down-regulation capacity | kW | 1.4.9 (regulation) |
| \(E_{peak,t}^{required}\) | Energy required to cap the peak at step \(t\) | kWh | 1.4.11 (derived) |
| \(P_{peak,t}^{required,power}\) | Power required to cap the peak at step \(t\) | kW | 1.4.11 (derived) |

### 5.11.4 Cross-reference note

| Symbol | Description | Status |
|---|---|---|
| \(E_{terminal}^{min}\) | Minimum terminal energy | **Already registered** in Part 1 §1.4.4. Cross-reference only. |

### 5.11.5 Note on auxiliary binaries

The binaries \(c_{cycle,t}\), \(r_t\), \(p_t\) from Part 2 §2.3.8 are **not** registered in Part 1, per the auxiliary-binary convention.

The binary \(c_{peak,t}\) from Part 5 §5.2.5 **is registered** as a decision variable.

---

## 5.12 Part 4 change request

**Status:** Issued by Part 5. **Pending Part 4 sign-off.**

Part 4 §4.3.3 states the net load cap "must not exceed the target peak." Part 5 interprets this as an **economic decision**, not a hard constraint.

**Requested Part 4 amendment:**

1. The net load cap is an economic decision (\(c_{peak,t} = 1\) or \(0\)).
2. When enforced (\(c_{peak,t} = 1\)), the cap is enforced subject to physical feasibility.
3. When not enforced (\(c_{peak,t} = 0\)), the cap may be violated; the actual billed peak is \(D_{billed}\).
4. \(\Delta D_{savings}\) is computed on the actual billed peak.

**Rationale:** The BESS may be physically capable of enforcing the cap but choose not to if the opportunity cost is too high.

---

## 5.13 Exit criteria for promotion to v1.0

| # | Criterion | Status |
|---|---|---|
| 1 | **Part 1 sign-off** on the change request (5.11). | **PENDING** |
| 2 | **Part 4 sign-off** on the peak-shaving clarification (5.12). | **PENDING** |
| 3 | Internal cross-references verified. | **MET** |
| 4 | Changelog cumulative and honest. | **MET** |
| 5 | No truncated sections. | **MET** |
| 6 | All epigraph variables labeled with Part 5 dependency. | **MET** |
| 7 | No unlinearized max() involving decision variables. | **MET** (after FC1 fix) |

**Freeze definition:** Frozen (v1.0) means changes only via change request with version increment.

---

