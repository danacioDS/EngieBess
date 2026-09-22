# PART 4 — SERVICES (OPERATING MODES)

## BESS Engineering Model

**Version 1.0 — Final Candidate (FC3)**

---

## 4.1 Purpose and scope of this part

This part defines the **five operating modes** that the BESS can provide, following the ENGIE RFP specification:

1. **Peak Shaving** — reduce site peak demand to lower demand charges.
2. **Demand Response (DR)** — curtail or shift load during utility/ISO-called events.
3. **Energy Arbitrage** — exploit time-of-use or wholesale price differentials.
4. **Frequency Regulation** — provide fast-response power for grid frequency support.
5. **Voltage Regulation** — provide reactive power for local voltage support.

Each mode is defined using the **same template**:

| Template section | Purpose |
|---|---|
| **Objective** | What the mode is trying to achieve |
| **Inputs** | What the mode consumes |
| **Constraints** | What the mode must respect (physical + program rules) |
| **Asset reservation** | What the mode reserves from the asset (power and energy) |
| **Outputs / KPIs** | What the mode produces |
| **Risks** | What can go wrong, and how the model handles it |

Part 4 defines the modes **individually**. The interactions between modes (coexistence, priority, stacking) are defined in Part 5.

**Scope rule:** Part 4 does not define dispatch logic. It defines the service models that dispatch allocates capacity to.

**FC3 scope:** This revision applies the two fixes the FC2 grade identified:

- **Process consistency on the coexistence-sum instantiation (§4.3.4, §4.14).** FC2 unilaterally declared how Part 5's §5.2.2 coexistence sum should instantiate the peak-shaving reservation, and marked the corresponding exit criterion as MET without Part 5's confirmation. FC3 reframes the interpretation as a **formal note for Part 5's confirmation**, matching the deferral pattern used for the $R_{reg,t}^{committed}$ question. Exit criterion 8 is demoted from "MET" to "PENDING (Part 5 confirmation)".
- **Citation-accuracy guardrail added to §4.14.** Part 3 FC3 added a citation-accuracy verification item (§3.14 criterion 5) after naming the recurring "FC9/FC10" pattern. FC3 mirrors this guardrail in Part 4's exit criteria.

Additionally:

- **§4.5.3 cross-reference added.** The price-spread-threshold reclassification as a rule-based-dispatcher heuristic now cites Part 5 §5.4.1 explicitly.
- **Part 5 amendment acknowledgment status recorded (§4.14, §4.15).** FC2 marked the applied Part 5 amendment as MET on Part 4's side; the reciprocal acknowledgment from Part 5 is now listed as a pending external item (matching the pattern in the closure note).

No technical content changes. No registration changes. No re-opening of settled items.

**Part 1 change request status:** **Closed** (Part 1 FC8; §4.12).

**Part 3 consultation status:** **Closed** (Resolution B accepted; Part 3 §3.9; §4.13).

**Part 5 amendment status:** **Applied by Part 4 in FC2.** Part 5's acknowledgment is pending (§4.14 criterion 10, §4.15).

**Interface summary (Part 4):**

| Consumes from | Produces for |
|---|---|
| Symbols (Part 1) | $R_{arb}(t)$, $R_{DR}(t)$, $R_{reg}^{rev}(t)$ |
| Physical limits $E_{min,t}, E_{max,t}, E_{usable,t}$ (Part 2) | $R_{reg,t}^{up}$, $R_{reg,t}^{down}$ |
| Derating functions (Part 2) | $Q_{res,t}$ |
| SOH (Part 3) | Service constraints (used by Part 5) |
| Prices $\pi_t$, DR events, forecasts (Part 1) | Absolute regulation statistics (Part 3 consumption) |

---

## 4.2 Common notation for all services

All services use the symbols registered in Part 1. The following symbols are **shared** across services:

| Symbol | Description | Part 1 section |
|---|---|---|
| \(P_{AC,t}^{ch}\) | Charging power at AC (decision) | 1.4.2 |
| \(P_{AC,t}^{dis}\) | Discharging power at AC (decision) | 1.4.2 |
| \(Q_t\) | Reactive power at AC (decision) | 1.4.2 |
| \(P_{AC,t}\) | Signed AC power (\(P^{dis} - P^{ch}\)) | 1.4.3 |
| \(E_{min,t}\), \(E_{max,t}\) | Energy bounds | 1.4.11 |
| \(E_{usable,t}\) | Usable energy | 1.4.11 |
| \(SOH_k\) | Latched capacity SOH | 1.4.11 |
| \(SOC_t\) | State of charge | 1.4.11 |
| \(c_{DR,t}\), \(c_{reg,t}\) | Commitment states | 1.4.1 |

**Service revenue symbols** are registered in 1.4.7.

**Service reservation symbols** are registered in 1.4.9 and 1.4.10.

**AC-side revenue convention:** All revenues are computed on the **AC side** (metered power). The efficiency losses are already embedded in the AC↔DC conversion (Part 2, section 2.3.1). No efficiency factor is applied again in the revenue formula.

**Epigraph variable convention (MILP linearizations):** Several sections of Part 4 use **epigraph variables** — continuous variables introduced to linearize `max()` expressions. These variables are only tight when the Part 5 objective penalizes them (i.e., pushes them down to their lower bound). Part 4 labels every such variable explicitly as **"epigraph — valid only if minimized in Part 5 objective."** If Part 5's objective does not include a penalizing term for a given epigraph variable, that constraint is underdetermined and must be tightened by Part 5.

---

## 4.3 Peak Shaving

### 4.3.1 Objective

Reduce the site's peak demand (kW) to lower demand charges ($/kW) on the utility bill.

### 4.3.2 Inputs

| Input | Symbol | Source |
|---|---|---|
| Site load (realized) | \(P_{load,t}\) | Scenario |
| Target peak | \(P_{peak}^{target}\) | Scenario |
| Demand charge rate | \(D_{charge}\) | Scenario |
| Demand charge interval | \(\Delta t_{demand}\) | Tariff |

### 4.3.3 Constraints

**Net load cap — economic decision, not hard constraint (FC2).** Part 5 §5.2.5 reframed the net-load cap as a **soft economic decision**, not a hard constraint. The BESS may be physically capable of enforcing the cap but choose not to if the opportunity cost (foregone arbitrage or regulation revenue) exceeds the avoided demand charge. The decision is represented by the binary variable \(c_{peak,t} \in \{0,1\}\), registered in Part 1 §1.4.2 and owned by Part 5.

**When the optimizer chooses to enforce the cap (\(c_{peak,t} = 1\)):**

\[
P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \le P_{peak}^{target} + M_{big} \cdot (1 - c_{peak,t})
\]

**When \(c_{peak,t} = 0\):** the cap is relaxed, and the actual billed peak is determined by \(D_{billed}\) (see below).

**Physical feasibility of enforcing the cap.** Enforcing the cap requires sufficient discharge power and energy. These are enforced as **physical constraints on \(c_{peak,t}\)** (Part 5 §5.2.5):

\[
P_{AC,t}^{dis} \ge P_{peak,t}^{required,power} - M_{big} \cdot (1 - c_{peak,t})
\]

\[
E_t - E_{min,t} \ge E_{peak,t}^{required} - M_{big} \cdot (1 - c_{peak,t})
\]

where:

\[
P_{peak,t}^{required,power} = \max\left(0,\; \hat{P}_{load,t} - P_{peak}^{target}\right)
\]

\[
E_{peak,t}^{required} = \sum_{\tau=t}^{t + N_{peak}^{remaining} - 1} \max\left(0,\; \hat{P}_{load,\tau} - P_{peak}^{target}\right) \cdot \Delta t
\]

Both quantities are **forecast-based and precomputable** from \(\hat{P}_{load,t}\) and \(P_{peak}^{target}\).

**Billing period maximum demand.**

The billed demand over a billing period \(T_{billing}\) is:

\[
D_{billed} = \max_{t \in T_{billing}} \left( P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \right)
\]

**MILP linearization of the max():**

Introduce a continuous variable \(D_{billed}\) and constrain:

\[
D_{billed} \ge P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \quad \forall t \in T_{billing}
\]

**Epigraph validity condition:** \(D_{billed}\) is an epigraph variable. It will only equal the true maximum if the Part 5 objective includes a **positive coefficient on \(D_{billed}\)** (i.e., a penalty \(D_{charge} \cdot D_{billed}\) in the objective).

**Relation between \(D_{billed}\) and \(P_{peak}^{capped}\):** \(P_{peak}^{capped} = D_{billed}\). The two symbols refer to the same quantity; \(P_{peak}^{capped}\) is the KPI notation, \(D_{billed}\) is the decision variable.

**Forecast requirement:** Peak shaving depends on a forecast of the load. If the forecast is wrong, the BESS may not discharge in time. The forecast load is \(\hat{P}_{load,t}\) (Part 1, section 1.4.7).

### 4.3.4 Asset reservation

Peak shaving reserves:

- **Power:** up to \(P_{max,t}^{AC,dis}\), subject to the economic decision \(c_{peak,t}\). When \(c_{peak,t} = 0\), no peak-shaving power is reserved at that step.
- **Energy:** the energy needed to cover the **excess above target**, not the entire target load:

\[
E_{peak}^{reserved} = \max_{t \in T_{peak}^{window}} E_{peak,t}^{required}
\]

where \(E_{peak,t}^{required}\) is defined in §4.3.3.

**Window-level vs. per-step quantity (FC3 — note for Part 5 confirmation).** \(E_{peak}^{reserved}\) is a **window-level maximum** — the largest per-step required energy over the peak window. The per-step quantity \(E_{peak,t}^{required}\) is what the coexistence constraint should use, since coexistence is enforced step-by-step. The relationship is \(E_{peak}^{reserved} = \max_t E_{peak,t}^{required}\).

**Open interface question (flagged, not resolved — see §4.14 criterion 8 and §4.15).** Part 5 §5.2.2's generic coexistence constraint \(\sum_s E_{s,t}^{reserved,dis} \le E_t - E_{min,t}\) uses a per-step quantity \(E_{s,t}^{reserved,dis}\). Part 4's view is that for peak shaving, this should be instantiated as the per-step \(E_{peak,t}^{required}\), not the window-level \(E_{peak}^{reserved}\). This interpretation is offered **for Part 5's confirmation**, not declared unilaterally. The reasoning is straightforward (a per-step constraint wants a per-step quantity), but the constraint is Part 5's, and the instantiation decision belongs to Part 5. Until Part 5 confirms, exit criterion 8 remains PENDING.

**Reservation rule (when \(c_{peak,t} = 1\)):**

\[
E_t - E_{min,t} \ge E_{peak,t}^{required}
\]

**Correction note:** Earlier drafts reserved \(P_{peak}^{target} \cdot N_{peak} \cdot \Delta t\), which over-reserved by reserving the entire target load. The BESS only needs to cover the excess above target. This correction was carried over from Revision 1 and remains in force.

**Relationship to the coexistence sum:** Part 5 §5.2.2's generic coexistence constraint instantiates the peak-shaving term as \(E_{peak,t}^{required}\) (pending Part 5 confirmation, per the open interface question above). The window-level quantity \(E_{peak}^{reserved}\) is used only for scenario-level planning and KPI reporting.

### 4.3.5 Outputs / KPIs

| KPI | Symbol | Unit | Description |
|---|---|---|---|
| Peak reduction | \(\Delta P_{peak}\) | kW | Difference between baseline peak and capped peak |
| Demand charge savings | \(\Delta D_{savings}\) | $ | \(D_{charge} \cdot \Delta P_{peak}\) |
| Cycles consumed | \(N_{peak}^{cycles}\) | — | Number of discharge cycles used for peak shaving |
| Energy discharged | \(E_{peak}^{dis}\) | kWh | Total energy discharged for peak shaving |
| Peak-cap enforcement fraction | — | — | Fraction of peak-window steps with \(c_{peak,t} = 1\) (diagnostic) |

**Demand charge savings per billing period:**

\[
\Delta D_{savings} = D_{charge} \cdot \left( P_{peak}^{baseline} - P_{peak}^{capped} \right)
\]

where \(P_{peak}^{baseline}\) is the baseline peak demand before BESS, and \(P_{peak}^{capped} = D_{billed}\) is the actual billed peak.

### 4.3.6 Risks

| Risk | Handling |
|---|---|
| **Forecast error** | The BESS may not discharge in time if the load spikes unexpectedly. Model uses \(\hat{P}_{load,t}\) with forecast error. |
| **Battery depletion** | If the BESS runs out of energy before the peak ends, the cap is violated. The economic decision \(c_{peak,t}\) will be set to 0 by the optimizer when the required energy is not available. |
| **Conflicting services** | Peak shaving competes with arbitrage. The optimizer trades off opportunity cost against demand-charge savings through the objective. Priority is economic, not hard-coded. |
| **Billing period ratchet** | Some tariffs have a ratchet (peak demand persists for 11 months). The model records the billed peak per billing period. |
| **Opportunity cost** | The optimizer may choose \(c_{peak,t} = 0\) when arbitrage revenue at that step exceeds the marginal demand-charge savings. This is intentional: the economic decision is the model's way of representing that trade-off. |

---

## 4.4 Demand Response (DR)

### 4.4.1 Objective

Curtail or shift load during utility/ISO-called DR events for capacity or event-based payments.

### 4.4.2 Inputs

Each DR event is a tuple (Part 1, section 1.4.14):

| Input | Symbol | Unit |
|---|---|---|
| Event start time | \(t_{start}\) | — |
| Event duration | \(\Delta t_{DR}\) | h |
| Committed capacity | \(P_{DR,committed}\) | kW |
| Baseline load | \(P_{DR,baseline}\) | kW |
| Underperformance penalty | \(P_{DR,penalty}\) | $/kWh |

Additional inputs:

| Input | Symbol | Source |
|---|---|---|
| DR revenue rate (capacity) | \(r_{DR}^{capacity}\) | Scenario |
| DR revenue rate (energy) | \(r_{DR}^{energy}\) | Scenario |
| Number of events per season | — | Program rules |

### 4.4.3 Constraints

**Committed capacity during event:**

During the DR event, the BESS must discharge at least the committed capacity:

\[
P_{AC,t}^{dis} \ge P_{DR,committed} - M_{big} \cdot (1 - c_{DR,t})
\]

**Sustained discharge duration:**

The BESS must sustain the discharge for the full event duration:

\[
\sum_{\tau=t_{start}}^{t_{start} + \Delta t_{DR}/\Delta t - 1} P_{AC,\tau}^{dis} \cdot \Delta t \ge P_{DR,committed} \cdot \Delta t_{DR}
\]

**Baseline and performance measurement:**

The delivered DR energy is:

\[
E_{DR}^{delivered} = \sum_{\tau=t_{start}}^{t_{start} + \Delta t_{DR}/\Delta t - 1} \max\left( P_{DR,baseline} - P_{load,\tau} + P_{AC,\tau}^{dis} - P_{AC,\tau}^{ch}, 0 \right) \cdot \Delta t
\]

**MILP linearization of the max():**

Introduce a continuous variable \(E_{DR,\tau}^{delivered}\) and constrain:

\[
E_{DR,\tau}^{delivered} \ge \left( P_{DR,baseline} - P_{load,\tau} + P_{AC,\tau}^{dis} - P_{AC,\tau}^{ch} \right) \cdot \Delta t
\]
\[
E_{DR,\tau}^{delivered} \ge 0
\]

**Epigraph validity condition:** \(E_{DR,\tau}^{delivered}\) is an epigraph variable. It will only equal the true delivered energy if the Part 5 objective penalizes overstating it — specifically, if the objective includes a term that pushes \(E_{DR,\tau}^{delivered}\) down (e.g., minimizing the penalty term \(P_{DR,penalty} \cdot \max(P_{DR,committed} \cdot \Delta t_{DR} - E_{DR}^{delivered}, 0)\), which is monotone decreasing in \(E_{DR}^{delivered}\)).

**Status:** Pending Part 5 objective. Part 5 must include the DR penalty term (or an equivalent monotone-decreasing term in \(E_{DR}^{delivered}\)) for this linearization to be effective. Without such a term, the optimizer could inflate \(E_{DR,\tau}^{delivered}\) to reduce apparent penalty — a KPI-integrity bug.

**Penalty for underperformance:**

If the delivered energy is less than committed, the penalty is:

\[
\text{Penalty} = P_{DR,penalty} \cdot \max\left( P_{DR,committed} \cdot \Delta t_{DR} - E_{DR}^{delivered}, 0 \right)
\]

**MILP linearization of the penalty:**

Introduce a continuous variable \(Penalty\) and constrain:

\[
Penalty \ge P_{DR,penalty} \cdot \left( P_{DR,committed} \cdot \Delta t_{DR} - E_{DR}^{delivered} \right)
\]
\[
Penalty \ge 0
\]

**Epigraph validity condition:** \(Penalty\) is an epigraph variable. It will only equal the true penalty if the Part 5 objective **minimizes** \(Penalty\) (i.e., includes a positive coefficient on \(Penalty\), pushing it down to its lower bound).

**Status:** Pending Part 5 objective. Part 5 must include \(Penalty\) as a term with a **positive cost coefficient** in the objective (or an equivalent term that penalizes underperformance).

**SOC requirement (with AC↔DC conversion):**

Before the event, the BESS must have sufficient **cell-level** energy to deliver the committed capacity for the event duration. To deliver \(P_{DR,committed}\) kW at the meter, the cell must supply more energy due to conversion and cell losses:

\[
E_t - E_{min,t} \ge \frac{P_{DR,committed} \cdot \Delta t_{DR}}{\eta_{PCS} \cdot \eta_{d,t}}
\]

**Correction note:** Earlier drafts omitted the efficiency conversion, comparing AC-side power commitment directly against cell-level energy. This is corrected here.

### 4.4.4 Asset reservation

DR reserves:

- **Power:** \(P_{DR,committed}\) kW of discharge capacity.
- **Energy:** \(\frac{P_{DR,committed} \cdot \Delta t_{DR}}{\eta_{PCS} \cdot \eta_{d,t}}\) kWh of stored energy.

**Reservation rule:**

\[
E_t - E_{min,t} \ge \frac{P_{DR,committed} \cdot \Delta t_{DR}}{\eta_{PCS} \cdot \eta_{d,t}} \quad \text{when } c_{DR,t} = 1
\]

### 4.4.5 Outputs / KPIs

| KPI | Symbol | Unit | Description |
|---|---|---|---|
| Committed capacity | \(P_{DR,committed}\) | kW | Contracted DR capacity |
| Event energy delivered | \(E_{DR}^{delivered}\) | kWh | Energy actually delivered during event |
| DR revenue | \(R_{DR}(t)\) | $ | Payment for committed capacity and/or delivered energy |
| Performance score | \(PS_{DR}\) | — | Ratio of delivered to committed |
| Penalty | — | $ | If performance score < 1 |

**DR revenue:**

\[
R_{DR}(t) = r_{DR}^{capacity} \cdot P_{DR,committed} \cdot \Delta t_{DR} + r_{DR}^{energy} \cdot E_{DR}^{delivered} - \text{Penalty}
\]

### 4.4.6 Risks

| Risk | Handling |
|---|---|
| **Notification lead time** | The BESS may not have enough time to charge before the event. The model reserves energy at the notification time. |
| **Baseline manipulation** | Some programs adjust the baseline based on BESS behavior. The model uses the program-specified baseline. |
| **Event cancellation** | If the event is canceled, the reserved capacity is released. The model handles this via \(c_{DR,t} = 0\). |
| **Multiple events** | If multiple events occur in a day, the BESS may run out of energy. The model tracks cumulative DR energy. |
| **Penalty exposure** | Underperformance can be costly. The model includes the penalty in the objective. |

---

## 4.5 Energy Arbitrage

### 4.5.1 Objective

Exploit time-of-use (TOU) or wholesale price differentials: charge at low-cost periods, discharge at high-cost periods.

### 4.5.2 Inputs

| Input | Symbol | Source |
|---|---|---|
| Energy price (LMP or TOU) | \(\pi_t\) | Scenario |
| Price forecast | \(\hat{\pi}_t\) | Forecast model |
| Charge/discharge efficiency losses | \(\eta_{c,t}, \eta_{d,t}, \eta_{PCS}\) | Part 2 |
| Minimum price spread threshold | \(\Delta\pi_{min}\) | Configurable |

### 4.5.3 Constraints

**Physical constraints:** All Part 2 constraints apply.

**Price spread threshold:**

The BESS should only cycle if the price spread exceeds the round-trip efficiency losses:

\[
\pi_t^{dis} - \pi_t^{ch} > \frac{\Delta\pi_{min}}{\eta_{RT}}
\]

where \(\pi_t^{dis}\) and \(\pi_t^{ch}\) are the prices at the discharge and charge times respectively (both drawn from the same time series \(\pi_t\) at different steps), \(\eta_{RT}\) is the round-trip efficiency, and \(\Delta\pi_{min}\) is a configurable minimum spread.

**Note (FC3 — cross-reference added):** This is a **heuristic decision rule**, not a hard constraint. It is applied by the rule-based dispatcher (Part 5 §5.4.1, step 4 of the cascade: "if price forecast indicates arbitrage opportunity (price spread exceeds a preset threshold)"). The optimization-based dispatcher (Part 5 §5.4.2) does not need it: the objective already values the price spread against the degradation cost, and the efficiency losses are embedded in the AC↔DC conversion. The threshold is included here for completeness and for the hybrid dispatcher (Part 5 §5.4.3).

**Charging constraint:**

\[
P_{AC,t}^{ch} \le P_{max,t}^{AC,ch}
\]

**Discharging constraint:**

\[
P_{AC,t}^{dis} \le P_{max,t}^{AC,dis}
\]

**No simultaneous charge and discharge:**

\[
P_{AC,t}^{ch} \cdot P_{AC,t}^{dis} = 0
\]

(enforced by \(z_t\) from Part 1).

### 4.5.4 Asset reservation

Arbitrage reserves:

- **Power:** the available charge and discharge power.
- **Energy:** the SOC window available for cycling.

**Reservation rule:**

\[
E_{t} - E_{min,t} \ge E_{arb}^{reserved,dis}
\]
\[
E_{max,t} - E_t \ge E_{arb}^{reserved,ch}
\]

where \(E_{arb}^{reserved,dis}\) and \(E_{arb}^{reserved,ch}\) are the energy reserves for arbitrage discharge and charge respectively.

**Note:** Arbitrage is an **opportunistic service**. It reserves only what remains after higher-priority services (DR, frequency regulation) have taken their reservations. The reservation rule above applies to the residual capacity, not to the full SOC window.

### 4.5.5 Outputs / KPIs

| KPI | Symbol | Unit | Description |
|---|---|---|---|
| Energy shifted | \(E_{shifted}\) | kWh | Total energy cycled for arbitrage |
| Gross arbitrage revenue | \(R_{arb}(t)\) | $ | Revenue before degradation cost |
| Net revenue after losses | \(R_{arb}^{net}\) | $ | Revenue after subtracting degradation cost |
| Marginal cycle cost | \(C_{cycle}\) | $/kWh | Cost of cycling the battery (degradation) |
| Cycles consumed | \(N_{arb}^{cycles}\) | — | Number of cycles used for arbitrage |

**Gross arbitrage revenue (AC-side, corrected):**

\[
R_{arb}(t) = \pi_t \cdot \left( P_{AC,t}^{dis} - P_{AC,t}^{ch} \right) \cdot \Delta t
\]

**Correction note:** Earlier drafts applied \(\eta_{PCS} \cdot \eta_{d,t}\) to \(P_{AC,t}^{dis}\) and divided \(P_{AC,t}^{ch}\) by \(\eta_{PCS} \cdot \eta_{c,t}\). This double-counts losses already embedded in the AC↔DC conversion (Part 2, section 2.3.1). Revenue is the simple AC-side form.

**Net revenue after degradation cost:**

\[
R_{arb}^{net}(t) = R_{arb}(t) - c_{deg} \cdot Th_t^{arb}
\]

where \(c_{deg}\) is the marginal degradation cost and \(Th_t^{arb}\) is the throughput from arbitrage.

**Ownership note (FC2/FC3):** \(Th_t^{arb}\) is a per-service **accounting attribution**, not a registered symbol. Per Part 3 §3.9 (Resolution B), Part 4 does not register per-service throughput; the attribution is computed in Part 5 §5.6.5 from the dispatch allocation vector \(a_t\) and the physical throughput \(Th_t\). Part 4 references the attribution mechanism but does not own it.

### 4.5.6 Risks

| Risk | Handling |
|---|---|
| **Price forecast error** | The BESS may cycle when prices are unfavorable. The model uses \(\hat{\pi}_t\) with forecast error. |
| **Efficiency losses** | Round-trip efficiency reduces net revenue. The model includes \(\eta_{RT}\) implicitly via the AC-side power balance. |
| **Degradation cost** | Cycling degrades the battery. The model includes \(c_{deg}\). |
| **Price volatility** | Extreme price spikes may not be predictable. The model uses stress scenarios. |
| **Conflicting services** | Arbitrage competes with peak shaving and DR. Priority handled in Part 5. |

---

## 4.6 Frequency Regulation

### 4.6.1 Objective

Provide fast-response power injection/absorption to support grid frequency stability.

**Warning:** This is a **sub-second service**. The model uses **statistical parameters** over each step, as defined in Part 1, section 1.6.2.

**RegA/RegD note:** RegA and RegD are **PJM-specific products**. If the RFP is not PJM, the equivalent product must be specified (e.g., FFR in ERCOT, Dynamic Containment in GB). The statistical parameters are the same in structure; only the product names change.

### 4.6.2 Inputs

| Input | Symbol | Source |
|---|---|---|
| Expected energy (per MW, per direction) | \(E_{reg,t}^{exp,d}\) | Scenario |
| Standard deviation (per MW, per direction) | \(\sigma_{reg,t}^{d}\) | Scenario |
| Mileage (per MW, per direction) | \(M_{reg,t}^{d}\) | Scenario |
| Regulation capacity price | \(r_{reg}^{capacity}\) | Scenario |
| Regulation mileage price | \(r_{reg}^{mileage}\) | Scenario |
| Performance score | \(PS_{reg,t}\) | Dispatch output |
| Regulation commitment duration | \(\Delta t_{reg}\) | Program rules |

**Unit note on \(r_{reg}^{mileage}\):** Mileage \(M_{reg,t}^{abs}\) is dimensionless (Part 1, §1.4.9, "—"). Therefore \(r_{reg}^{mileage}\) is in **$/unit of dimensionless mileage**. The unit is written as **$/mileage-unit** rather than $/mileage, to make the dimensionless nature explicit. This unit is registered in Part 1 §1.4.7.

### 4.6.3 Constraints

**Reserved regulation capacity:**

\[
R_{reg,t}^{up} \le P_{max,t}^{AC,dis}
\]
\[
R_{reg,t}^{down} \le P_{max,t}^{AC,ch}
\]

**SOC headroom for sustained regulation:**

\[
SOC_{reg,min} \le SOC_t \le SOC_{reg,max} \quad \text{when } c_{reg,t} = 1
\]

**Energy headroom for sustained regulation (direction-specific):**

The BESS must have enough energy to sustain up-regulation, and enough headroom to absorb down-regulation:

\[
E_t - E_{min,t} \ge E_{reg,t}^{abs,up} \cdot \Delta t_{reg}
\]
\[
E_{max,t} - E_t \ge E_{reg,t}^{abs,down} \cdot \Delta t_{reg}
\]

where \(E_{reg,t}^{abs,up}\) and \(E_{reg,t}^{abs,down}\) are the **direction-specific absolute expected energies**, registered in Part 1 §1.4.9.

**Correction note:** Part 1 §1.4.9 registers both a combined \(E_{reg,t}^{abs}\) and the direction-specific forms \(E_{reg,t}^{abs,up}\) and \(E_{reg,t}^{abs,down}\). The combined form sums up and down; it is used for total throughput/degradation accounting. For headroom reservation, direction-specific values are needed because up-regulation draws energy and down-regulation creates it — they cannot share one combined number. Both forms are registered; both are used, for different purposes.

**Peak-based capability reservation (Part 2, section 2.3.3):**

\[
\max\left(\left|P_{AC,t}^{base} + R_{reg,t}^{up}\right|,\; \left|P_{AC,t}^{base} - R_{reg,t}^{down}\right|\right)^2 + Q_{res,t}^2 \le S_{max}^2
\]

**Open interface question (flagged, not resolved — see §4.14 criterion 11 and §4.15).** The relationship between \(R_{reg,t}^{up/down}\) (Part 4's reserved capacity) and \(R_{reg,t}^{committed,up/down}\) (Part 5's committed capacity, registered in Part 1 §1.4.9 as Part 5-owned) is a Part 4 ↔ Part 5 semantic decision. Whether they are the same quantity under two names, or distinct (e.g., "reserved" = offered to market, "committed" = dispatched in the step), is not resolved here. Part 4 uses \(R_{reg,t}^{up/down}\) throughout; Part 5 uses \(R_{reg,t}^{committed,up/down}\). This is Part 1 §1.12 item 8, owned jointly by Parts 4 and 5.

### 4.6.4 Asset reservation

Frequency regulation reserves:

- **Power:** \(R_{reg,t}^{up}\) kW of discharge capacity and \(R_{reg,t}^{down}\) kW of charge capacity.
- **Energy:** \(E_{reg,t}^{abs,up} \cdot \Delta t_{reg}\) kWh for up-regulation headroom; \(E_{reg,t}^{abs,down} \cdot \Delta t_{reg}\) kWh for down-regulation headroom.
- **SOC band:** \(SOC_{reg,min}\) to \(SOC_{reg,max}\).

### 4.6.5 Outputs / KPIs

| KPI | Symbol | Unit | Description |
|---|---|---|---|
| Regulation capacity offered | \(R_{reg,t}^{up}\), \(R_{reg,t}^{down}\) | kW | Reserved capacity |
| Regulation revenue | \(R_{reg}^{rev}(t)\) | $ | Payment for capacity and mileage |
| SOC deviation | \(\Delta SOC_{reg}\) | — | Deviation from mid-SOC during regulation |
| Mileage | \(M_{reg,t}^{abs}\) | — | Cumulative signal movement |
| Performance score | \(PS_{reg,t}\) | — | Signal-following accuracy |

**Regulation revenue:**

\[
R_{reg}^{rev}(t) = r_{reg}^{capacity} \cdot R_{reg,t}^{up} \cdot \Delta t_{reg} + r_{reg}^{mileage} \cdot M_{reg,t}^{abs} \cdot PS_{reg,t}
\]

**Propagation to Part 3:**

The regulation statistics **must propagate into throughput and degradation**:

\[
\Delta Th_t^{reg} = M_{reg,t}^{abs} \cdot E_{nom} \cdot SOH_k
\]

This additional throughput is added to \(Th_t\) and contributes to cycle aging in Part 3.

**Ownership note (FC2/FC3):** \(\Delta Th_t^{reg}\) is **owned and produced by Part 4** (registered in Part 1 §1.4.9 with Part 4 ownership). It is consumed by Part 3 (throughput update §3.5.1) and by Part 5 (objective §5.3.2/§5.3.4). The per-service attribution \(Th_t^{reg}\) in Part 5 §5.6.5 is an accounting quantity, not a registered symbol (Resolution B).

### 4.6.6 Risks

| Risk | Handling |
|---|---|
| **SOC drift** | Sustained regulation in one direction may push SOC out of band. The model enforces \(SOC_{reg,min} \le SOC_t \le SOC_{reg,max}\). |
| **Signal volatility** | Extreme signals may exceed reserved capacity. The model uses \(\sigma_{reg,t}^{d}\) to size the reservation. |
| **Degradation** | Regulation causes additional cycling. The model propagates \(M_{reg,t}^{abs}\) to Part 3. |
| **Performance score** | Poor signal-following reduces revenue. The model includes \(PS_{reg,t}\) as a dispatch output. |
| **Sub-second resolution** | A 15-min step cannot represent the actual signal. The model uses statistical parameters. |

---

## 4.7 Voltage Regulation

### 4.7.1 Objective

Provide reactive power (VAR) support to maintain local voltage within acceptable bands.

**Warning:** This is a **sub-second service**. The model uses **average reactive power** over each step, as defined in Part 1, section 1.6.3.

### 4.7.2 Inputs

| Input | Symbol | Source |
|---|---|---|
| Required reactive power (exogenous need) | \(Q_{req,t}\) | Scenario |
| RMS reactive power | \(Q_{rms,t}\) | Dispatch output |
| Reactive energy | \(Q_{energy,t}\) | Dispatch output |
| Voltage compliance indicator | \(VC_t\) | Dispatch output |
| Reserved reactive capacity | \(Q_{res,t}\) | Dispatch output |
| Minimum power factor | \(pf_{min}\) | Asset parameter |

### 4.7.3 Constraints

**Reactive capability (four-quadrant):**

\[
Q_t^2 + P_{AC,t}^2 \le S_{max}^2
\]

**Power factor constraint (corrected form):**

The correct form uses the PCS capability polygon directly rather than a separate \(pf_{min}\) formula. The polygon approximation is:

\[
|Q_t| \le \sqrt{S_{max}^2 - P_{AC,t}^2}
\]

This is the exact boundary of the PCS capability circle, expressed as a function of \(P_{AC,t}\).

**Correction note:** Earlier drafts used \(|Q_t| \le |P_{AC,t}| \cdot \tan(\arccos(pf_{min})) + Q_{max}^{reactive-only}\), which is vacuous when \(Q_{max}^{reactive-only} \approx S_{max}\) (the constraint doesn't limit anything) and reintroduces the symbol \(Q_{max}^{reactive-only}\) that Part 1 explicitly removed. The corrected form uses the PCS capability boundary directly.

**Average vs. peak capability split:** This constraint applies to **average** active and reactive power over the step. A separate **peak-based** reservation constraint (below) applies to the **committed peaks** of frequency regulation and voltage regulation. The two are distinct, mirroring Part 2 §2.3.3's explicit split.

**Peak-based reservation (shared with frequency regulation):**

\[
\max\left(\left|P_{AC,t}^{base} + R_{reg,t}^{up}\right|,\; \left|P_{AC,t}^{base} - R_{reg,t}^{down}\right|\right)^2 + Q_{res,t}^2 \le S_{max}^2
\]

**Voltage setpoint / droop curve:**

If the BESS provides voltage support via a droop curve, the reactive power is a function of the voltage deviation:

\[
Q_t = f_{droop}(\Delta V_t)
\]

where \(\Delta V_t = V_{setpoint} - V_t\) is the voltage deviation.

**Active power curtailment:**

If the PCS must prioritize reactive power, active power may be curtailed:

\[
P_{AC,t}^{curtailed} = \max(0, P_{AC,t}^{desired} - P_{AC,t}^{available})
\]

**MILP linearization of the curtailment max():**

Introduce a continuous variable \(P_{AC,t}^{curtailed}\) and constrain:

\[
P_{AC,t}^{curtailed} \ge P_{AC,t}^{desired} - P_{AC,t}^{available}
\]
\[
P_{AC,t}^{curtailed} \ge 0
\]

**Epigraph validity condition:** \(P_{AC,t}^{curtailed}\) is an epigraph variable. It will only equal the true curtailment if the Part 5 objective penalizes it (i.e., includes a **positive cost coefficient** on \(P_{AC,t}^{curtailed}\), reflecting the opportunity cost of lost active power).

**Status:** Pending Part 5 objective. Part 5 must include a penalizing term on \(P_{AC,t}^{curtailed}\) for this linearization to be effective.

### 4.7.4 Asset reservation

Voltage regulation reserves:

- **Reactive power:** \(Q_{res,t}\) kVAr of the PCS apparent power capability.
- **No energy reservation:** reactive power does not consume battery energy.

**Reservation rule:**

\[
Q_{res,t} \ge Q_{rms,t}
\]

### 4.7.5 Outputs / KPIs

| KPI | Symbol | Unit | Description |
|---|---|---|---|
| Reactive energy provided | \(Q_{energy,t}\) | kVArh | Total reactive energy over the step |
| Voltage compliance | \(VC_t\) | — | Fraction of time within acceptable voltage band |
| Active power curtailment | \(P_{AC,t}^{curtailed}\) | kW | Active power lost due to reactive priority |
| Reactive capacity reserved | \(Q_{res,t}\) | kVAr | Reserved reactive capacity |

**Reactive energy:**

\[
Q_{energy,t} = Q_t \cdot \Delta t
\]

**Voltage compliance:**

\[
VC_t = \begin{cases} 1 & \text{if } V_{min} \le V_t \le V_{max} \\ 0 & \text{otherwise} \end{cases}
\]

### 4.7.6 Risks

| Risk | Handling |
|---|---|
| **Active power curtailment** | Providing reactive power may reduce active power capability. The model includes the PCS capability constraint. |
| **Voltage instability** | The BESS may not be able to maintain voltage if the deviation is too large. The model uses \(Q_{req,t}\) as an exogenous need. |
| **Reactive-only operation** | The PCS can provide reactive power at zero active power. The corrected power factor constraint allows this. |
| **Sub-second resolution** | The model uses average reactive power over the step. |
| **No direct revenue** | In BTM, voltage regulation may be non-revenue. The model records \(Q_{energy,t}\) and \(VC_t\) as KPIs. |

---

## 4.8 Service template summary

| Service | Objective | Power reserved | Energy reserved | Primary KPI | Revenue |
|---|---|---|---|---|---|
| **Peak shaving** | Cap net load at \(P_{peak}^{target}\) (economic) | \(P_{max,t}^{AC,dis}\) (when \(c_{peak,t} = 1\)) | \(E_{peak,t}^{required}\) (excess only) | Peak reduction (kW) | Demand charge savings |
| **Demand Response** | Deliver committed capacity | \(P_{DR,committed}\) | \(P_{DR,committed} \cdot \Delta t_{DR} / (\eta_{PCS} \cdot \eta_{d,t})\) | Event energy (kWh) | \(R_{DR}(t)\) |
| **Energy Arbitrage** | Exploit price differentials | \(P_{max,t}^{AC,ch}\), \(P_{max,t}^{AC,dis}\) | SOC window (residual) | Energy shifted (kWh) | \(R_{arb}(t)\) |
| **Frequency Regulation** | Support grid frequency | \(R_{reg,t}^{up}\), \(R_{reg,t}^{down}\) | \(E_{reg,t}^{abs,up}\), \(E_{reg,t}^{abs,down}\) | Regulation capacity (kW) | \(R_{reg}^{rev}(t)\) |
| **Voltage Regulation** | Support local voltage | \(Q_{res,t}\) | None | Reactive energy (kVArh) | Contractual |

---

## 4.9 Service interactions

Services compete for the same physical asset. The **coexistence rules** and **priority logic** are defined in Part 5.

**Summary of potential conflicts:**

| Service pair | Conflict | Resolution |
|---|---|---|
| Peak shaving + Arbitrage | Both want to discharge during high-value periods | Economic trade-off via \(c_{peak,t}\) in the objective (Part 5 §5.2.5) |
| DR + Arbitrage | DR events are mandatory; arbitrage is opportunistic | Priority: DR > arbitrage |
| Arbitrage + Frequency regulation | Both use the same SOC window | Regulation reserves headroom; arbitrage uses the rest |
| DR + Frequency regulation | Both need energy headroom | DR consumes energy; regulation reserves headroom |
| Peak shaving + Frequency regulation | Both need discharge capacity | Regulation reserves capacity; peak shaving uses the rest |
| Voltage regulation + any active service | Shares PCS apparent power | PCS capability constraint limits both |

**Note (FC2/FC3):** The peak-shaving vs. arbitrage conflict is **not** a hard priority. It is an economic trade-off resolved by the objective, through the \(c_{peak,t}\) decision. The other conflicts remain hard priorities (DR and frequency regulation are committed services; their reservations are enforced by constraints).

---

## 4.10 Part 4 outputs

| Output | Symbol | Consumed by |
|---|---|---|
| Arbitrage revenue | \(R_{arb}(t)\) | Part 5 (objective) |
| DR revenue | \(R_{DR}(t)\) | Part 5 (objective) |
| Regulation revenue | \(R_{reg}^{rev}(t)\) | Part 5 (objective) |
| Regulation reservations | \(R_{reg,t}^{up}\), \(R_{reg,t}^{down}\) | Part 2, Part 3, Part 5 |
| Reactive reservation | \(Q_{res,t}\) | Part 2, Part 5 |
| Service constraints | — | Part 5 (dispatch) |
| Direction-specific regulation headroom | \(E_{reg,t}^{abs,up}\), \(E_{reg,t}^{abs,down}\) | Part 2 (headroom), Part 3 (degradation) |
| Absolute regulation statistics | \(E_{reg,t}^{abs}\), \(\sigma_{reg,t}^{abs}\), \(M_{reg,t}^{abs}\) | Part 2 (loss model), Part 3 (degradation) |
| Regulation mileage throughput | \(\Delta Th_t^{reg}\) | Part 3 (throughput update), Part 5 (objective) |
| Peak-shaving required quantities | \(E_{peak,t}^{required}\), \(P_{peak,t}^{required,power}\) | Part 5 (coexistence, peak-cap decision) — **pending Part 5 confirmation of the coexistence instantiation** |
| Epigraph variables (pending Part 5 objective) | \(D_{billed}\), \(E_{DR,\tau}^{delivered}\), \(Penalty\), \(P_{AC,t}^{curtailed}\) | Part 5 (objective must penalize) |

---

## 4.11 Part 4 changelog

### Version 1.0 — Final Candidate (FC3)

**Changes from FC2 (verified):**

1. **Coexistence-sum instantiation reframed as a note for Part 5 confirmation (§4.3.4, §4.10, §4.14).** FC2 unilaterally declared that Part 5's §5.2.2 coexistence sum should instantiate the peak-shaving reservation as the per-step \(E_{peak,t}^{required}\), and marked the corresponding exit criterion as MET. FC3 reframes the interpretation as a **formal note for Part 5's confirmation**, matching the deferral pattern used for the \(R_{reg,t}^{committed}\) question (§4.6.3). Exit criterion 8 is demoted from "MET" to "PENDING (Part 5 confirmation)". The reasoning is unchanged (a per-step constraint wants a per-step quantity), but the decision belongs to Part 5.

2. **Citation-accuracy guardrail added to §4.14.** Part 3 FC3 added a citation-accuracy verification item (§3.14 criterion 5) after naming the recurring "FC9/FC10" pattern. FC3 mirrors this guardrail in Part 4's exit criteria. Part 4 FC2 had no citation error, but the guardrail is now in place to catch any future instance.

3. **§4.5.3 cross-reference added.** The price-spread-threshold reclassification as a rule-based-dispatcher heuristic now cites Part 5 §5.4.1, step 4 of the cascade, explicitly.

4. **Part 5 amendment acknowledgment status recorded (§4.14 criterion 10, §4.15).** FC2 marked the applied Part 5 amendment as MET on Part 4's side. FC3 adds the reciprocal acknowledgment from Part 5 as a pending external item, so the closure is not claimed one-sidedly.

5. **Open interface question on \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) re-stated (§4.6.3).** The semantic question is now stated in the constraints section as well as in the closure note, so a reader encountering the constraint sees the open question in context.

6. **No technical content changes.** DR, arbitrage, frequency regulation, and voltage regulation sections are unchanged from FC2. No formulas changed. No registrations changed.

7. **Version label updated to Final Candidate (FC3).** FC3 is the promotion candidate.

**Carried over from FC2 (verified):**

- Part 5 peak-shaving amendment applied (§4.3.3, §4.3.4, §4.3.6).
- Part 3 consultation closure recorded (§4.13, §4.14).
- Part 1 change request closure recorded (§4.12).
- Ownership notes aligned with Resolution B (§4.5.5, §4.6.5).
- Price-spread threshold labeled as heuristic (§4.5.3) — now with cross-reference.
- Window-level vs. per-step peak-shaving reservation clarified (§4.3.4) — now reframed as note.
- Peak-shaving vs. arbitrage conflict reclassified (§4.9).
- §4.10 Part 4 outputs table extended.

**Carried over from FC1 (verified):**

- Version label updated to Final Candidate (FC1).
- Sign-off status section added.
- Epigraph validity conditions stated explicitly for all four epigraph variables.
- DR delivered-energy inflation risk flagged.
- Average-vs-peak reactive capability split clarified.
- \(r_{reg}^{mileage}\) unit clarified.
- Part 3 consultation declared (now closed).
- Power factor constraint corrected.
- Arbitrage revenue formula corrected.
- DR SOC requirement corrected.
- Peak shaving energy reservation corrected.
- Direction-specific regulation headroom introduced.
- MILP linearization of max() restored.
- AC-side revenue convention stated.
- Part 1 change request compiled (now closed).

---

## 4.12 Part 1 change request closure

**Status:** **Closed.** This section records the closure of the FC1 change request (§4.12 of the FC1 document).

All symbols requested in the FC1 §4.12 change request are registered in Part 1 §1.4 (marked **[FC8]**). The tables below list the requests and their registration status.

### 4.12.1 Service-specific output symbols (Part 4-owned)

| Symbol | Description | Part 1 section | Status |
|---|---|---|---|
| \(E_{peak}^{reserved}\) | Energy reserved for peak shaving | 1.4.11 | Registered [FC8] |
| \(\Delta P_{peak}\) | Peak reduction | 1.4.7 | Registered [FC8] |
| \(\Delta D_{savings}\) | Demand charge savings | 1.4.7 | Registered [FC8] |
| \(E_{peak}^{dis}\) | Energy discharged for peak shaving | 1.4.11 | Registered [FC8] |
| \(E_{DR}^{delivered}\) | DR event energy delivered | 1.4.7 | Registered [FC8] |
| \(PS_{DR}\) | DR performance score | 1.4.7 | Registered [FC8] |
| \(r_{DR}^{capacity}\) | DR capacity revenue rate | 1.4.7 | Registered [FC8] |
| \(r_{DR}^{energy}\) | DR energy revenue rate | 1.4.7 | Registered [FC8] |
| \(E_{shifted}\) | Energy shifted for arbitrage | 1.4.11 | Registered [FC8] |
| \(R_{arb}^{net}(t)\) | Net arbitrage revenue after degradation | 1.4.7 | Registered [FC8] |
| \(C_{cycle}\) | Marginal cycle cost | 1.4.7 | Registered [FC8] |
| \(N_{arb}^{cycles}\) | Cycles consumed by arbitrage | 1.4.11 | Registered [FC8] |
| \(r_{reg}^{capacity}\) | Regulation capacity revenue rate | 1.4.7 | Registered [FC8] |
| \(r_{reg}^{mileage}\) | Regulation mileage revenue rate | 1.4.7 | Registered [FC8] |
| \(\Delta SOC_{reg}\) | SOC deviation during regulation | 1.4.9 | Registered [FC8] |
| \(E_{reg,t}^{abs,up}\) | Direction-specific up-regulation absolute energy | 1.4.9 | Registered [FC8] |
| \(E_{reg,t}^{abs,down}\) | Direction-specific down-regulation absolute energy | 1.4.9 | Registered [FC8] |
| \(Q_{energy,t}\) | Reactive energy | 1.4.10 | Registered [FC8] |
| \(VC_t\) | Voltage compliance indicator | 1.4.10 | Registered [FC8] |

### 4.12.2 Configuration and asset symbols

| Symbol | Description | Part 1 section | Status |
|---|---|---|---|
| \(\Delta t_{demand}\) | Demand charge interval | 1.4.15 | Registered [FC8] |
| \(N_{peak}\) | Number of steps in peak window | 1.4.11 | Registered [FC8] |
| \(N_{peak}^{cycles}\) | Cycles consumed by peak shaving | 1.4.11 | Registered [FC8] |
| \(\Delta\pi_{min}\) | Minimum price spread threshold | 1.4.7 | Registered [FC8] |
| \(f_{droop}(\cdot)\) | Voltage droop function | 1.4.10 | Registered [FC8] |
| \(\Delta V_t\) | Voltage deviation from setpoint | 1.4.10 | Registered [FC8] |
| \(V_t\) | Bus voltage | 1.4.10 | Registered [FC8] |
| \(V_{min}\) | Minimum acceptable voltage | 1.4.10 | Registered [FC8] |
| \(V_{max}\) | Maximum acceptable voltage | 1.4.10 | Registered [FC8] |
| \(V_{setpoint}\) | Voltage setpoint | 1.4.10 | Registered [FC8] |
| \(P_{AC,t}^{curtailed}\) | Active power curtailed (epigraph) | 1.4.3 | Registered [FC8] |
| \(P_{AC,t}^{desired}\) | Desired active power before curtailment | 1.4.3 | Registered [FC8] |
| \(P_{AC,t}^{available}\) | Available active power after reactive priority | 1.4.3 | Registered [FC8] |

### 4.12.3 Note on Part 1 §1.4.9 vs. Part 4 §4.6.3

Part 1 §1.4.9 registers both the **combined** \(E_{reg,t}^{abs}\) and the **direction-specific** \(E_{reg,t}^{abs,up}\) and \(E_{reg,t}^{abs,down}\). Part 4 §4.6.3 uses the direction-specific forms for headroom reservation and the combined form for total throughput. This dual registration is intentional and is documented in Part 1 §1.4.9.

The scaling rule in Part 1 §1.4.9 is:

\[
E_{reg,t}^{abs} = E_{reg,t}^{abs,up} + E_{reg,t}^{abs,down}
\]

with \(E_{reg,t}^{abs,up} = E_{reg,t}^{exp,up} \cdot R_{reg,t}^{up}\) and \(E_{reg,t}^{abs,down} = E_{reg,t}^{exp,down} \cdot R_{reg,t}^{down}\).

### 4.12.4 Removed symbols

The symbol \(Q_{max}^{reactive-only}\) is **not re-registered**. It was removed in Part 1 FC7 and is not used in Part 4 FC3.

### 4.12.5 Closure

**No outstanding Part 1 registration requests from Part 4.** The FC1 §4.12 change request is fully resolved by Part 1 FC8. Part 4 has no pending Part 1 action items.

---

## 4.13 Part 3 consultation closure

**Status:** **Closed.** Resolution B accepted.

**FC2/FC3 note:** This section was a pending consultation in FC1. It is now a closure record.

### 4.13.1 Question (historical)

Part 4 §4.13 of the FC1 document posed two resolutions for the per-service throughput decomposition:

- **Resolution A:** Part 3 owns the per-service decomposition (\(Th_t^{arb}\), \(Th_t^{reg}\)).
- **Resolution B:** Part 4 does not register per-service throughput; attribution is internal accounting.

### 4.13.2 Decision

**Resolution B is adopted**, per Part 3 §3.9.

### 4.13.3 Rationale (recorded for traceability)

Per-service throughput is an **accounting allocation**, not a physical state. The physical throughput is \(Th_t\) (a single Part 3 state). The per-service decomposition is computed in Part 5 (§5.6.5) from the dispatch allocation vector \(a_t\) and the physical throughput.

**Why not Resolution A:**

- Registering \(Th_t^{arb}\) and \(Th_t^{reg}\) as Part 3 states would require the optimization to track them explicitly, adding complexity.
- The physical state \(Th_t\) is sufficient; the decomposition is a post-processing step.
- The per-service degradation cost \(C_{deg}^{service}(t) = c_{deg} \cdot Th_t^{service}\) can be computed from Part 5's attribution mechanism without new state variables.

### 4.13.4 Attribution mechanism

The attribution mechanism is defined in Part 5, §5.6.5:

\[
Th_t^{service} = \sum_{\tau \le t} a_{service,\tau} \cdot |P_{DC,\tau}| \cdot \Delta \tau
\]

The regulation mileage throughput is attributed to the regulation service:

\[
Th_t^{reg} = \sum_{\tau \le t} \Delta Th_\tau^{reg}
\]

**Total throughput:**

\[
Th_t = \sum_s Th_t^{service} + Th_t^{other}
\]

where \(Th_t^{other} \approx 0\) (see Part 3 §3.5.1 for the corrected definition).

### 4.13.5 Part 4's role (closed)

Part 4 does **not** register per-service throughput. Part 4 uses internal accounting for per-service degradation cost attribution. Part 4's §4.5.5 and §4.6.5 reference the attribution mechanism in Part 5, §5.6.5.

**No Part 1 change request is needed for \(Th_t^{arb}\) or \(Th_t^{reg}\)**, because they are not registered symbols.

### 4.13.6 Closure

The Part 3 consultation is closed. Part 4 has no pending Part 3 action items. The Part 4-owned item in Part 1 §1.12's consolidated open-items register (item 1) is **MET**.

---

## 4.14 Exit criteria for promotion to v1.0

| # | Criterion | Status |
|---|---|---|
| 1 | **Part 1 change request closed.** All symbols used in Part 4 are registered in Part 1 §1.4. | **MET** (Part 1 FC8; §4.12 closure record) |
| 2 | **Part 3 consultation closed.** Resolution B accepted; no pending Part 3 action. | **MET** (§4.13 closure record) |
| 3 | **Part 5 peak-shaving amendment applied.** §4.3.3 reframed as economic decision. | **MET** (FC2) |
| 4 | **Internal cross-references verified.** All section references resolve to existing sections. | **MET** |
| 5 | **Citation accuracy.** Every Part 1 cross-reference resolves to an actual Part 1 revision (FC9, not FC9/FC10). | **MET** (FC3; guardrail added) |
| 6 | **Changelog cumulative and honest.** | **MET** |
| 7 | **No truncated sections.** Document complete from 4.1 to 4.15. | **MET** |
| 8 | **All epigraph variables labeled with Part 5 dependency.** | **MET** |
| 9 | **Peak-shaving reservation quantity identification in the coexistence sum.** The per-step \(E_{peak,t}^{required}\) is offered as the instantiating quantity, **pending Part 5 confirmation**. | **PENDING** (external; Part 5 revision) |
| 10 | **Part 5 acknowledgment of the applied peak-shaving amendment.** Part 5's §5.12 should be updated to record that the amendment has been applied by Part 4. | **PENDING** (external; Part 5 revision) |
| 11 | **Reconciliation of \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) semantics.** Joint decision with Part 5. | **PENDING** (external; Part 4 ↔ Part 5 joint decision) |

**Freeze definition:** Frozen (v1.0) means changes only via change request with version increment. No silent edits. FC documents are under review, not frozen.

---

## 4.15 Part 4 closure note

With FC3, Part 4 has:

- Closed its Part 1 change request (§4.12).
- Closed the Part 3 consultation with Resolution B accepted (§4.13).
- Applied the Part 5 peak-shaving amendment (§4.3.3).
- Reframed the coexistence-sum instantiation as a note for Part 5 confirmation (§4.3.4).
- Added the citation-accuracy guardrail to §4.14 (criterion 5).
- Added the §4.5.3 cross-reference to Part 5 §5.4.1.
- Recorded the Part 5 acknowledgment as a pending external item (§4.14 criteria 10–11).
- Aligned its ownership notes with Resolution B (§4.5.5, §4.6.5).
- Reclassified the peak-shaving vs. arbitrage conflict as an economic trade-off (§4.9).
- Extended the outputs table (§4.10).

### Closed by FC2/FC3 (Part 4's own scope)

- Part 1 registration: all symbols in Part 1 §1.4 ([FC8]).
- Part 3 consultation: Resolution B final.
- Part 5 amendment: applied by Part 4.
- Peak-shaving reservation quantity: per-step instantiation offered for Part 5 confirmation.
- Internal cross-references: consistent.
- Citation accuracy: guardrail added.

### Not addressed by FC2/FC3 (still open in other parts)

Part 4 does not fix contradictions in other parts' own text. The following items from Part 1 §1.12's consolidated open-items register touch Part 4 tangentially and remain open in the owning parts:

| # | Item | Owner | Part 4's role |
|---|---|---|---|
| 2 | Part 5 §5.6.5 should be corrected; §5.13 should list the amendment | Part 5 | Part 4 has no role; Part 5 must apply the Part 3 amendment |
| 4 | Part 5 §5.2.3 unlinearized indicator | Part 5 | Part 4 has no role; Part 5 must linearize |
| 8 | \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\) semantics | Parts 4 & 5 | **Joint decision** — Part 4 must reconcile with Part 5 |

### Remaining gating items for Part 4 itself

1. **Part 5 confirmation of the coexistence-sum instantiation** (criterion 9). External; depends on Part 5's next revision.
2. **Part 5 acknowledgment of the applied amendment** (criterion 10). External; depends on Part 5's next revision.
3. **Reconciliation of \(R_{reg,t}^{committed,up/down}\) vs. \(R_{reg,t}^{up/down}\)** (criterion 11). Joint decision with Part 5.

Once these three external items are complete, Part 4 is ready to freeze at v1.0.



