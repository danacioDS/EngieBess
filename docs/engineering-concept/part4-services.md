# PART 4 — SERVICES (OPERATING MODES)

## BESS Engineering Model

**Version 1.0 — Final Candidate (FC1)**

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

**Sign-off status:** FC1 is functionally complete. Two external sign-offs are pending:

- **Part 1 sign-off** on the change request (section 4.12). Register the new symbols.
- **Part 3 consultation** on the throughput ownership question (section 4.13). Resolve to Resolution A or B.

**Interface summary (Part 4):**

| Consumes from | Produces for |
|---|---|
| Symbols (Part 1) | \(R_{arb}(t)\), \(R_{DR}(t)\), \(R_{reg}^{rev}(t)\) |
| Physical limits \(E_{min,t}, E_{max,t}, E_{usable,t}\) (Part 2) | \(R_{reg,t}^{up}\), \(R_{reg,t}^{down}\) |
| Derating functions (Part 2) | \(Q_{res,t}\) |
| SOH (Part 3) | Service constraints (used by Part 5) |
| Prices \(\pi_t\), DR events, forecasts (Part 1) | Absolute regulation statistics (Part 3 consumption) |

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

**Net load cap during discharge:**

\[
P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \le P_{peak}^{target}
\]

This is the primary constraint. It says the net load at the PCC must not exceed the target peak.

**Billing period maximum demand:**

The billed demand over a billing period \(T_{billing}\) is:

\[
D_{billed} = \max_{t \in T_{billing}} \left( P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \right)
\]

**MILP linearization of the max():**

Introduce a continuous variable \(D_{billed}\) and constrain:

\[
D_{billed} \ge P_{load,t} - P_{AC,t}^{dis} + P_{AC,t}^{ch} \quad \forall t \in T_{billing}
\]

**Epigraph validity condition:** \(D_{billed}\) is an epigraph variable. It will only equal the true maximum if the Part 5 objective includes a **positive coefficient on \(D_{billed}\)** (i.e., a penalty \(D_{charge} \cdot D_{billed}\) in the objective). If Part 5 does not penalize \(D_{billed}\), the optimizer will leave it at its lower bound and the max() will not bind.

**Status:** Pending Part 5 objective. This constraint is valid only when the Part 5 objective penalizes \(D_{billed}\). Part 5 must include the demand-charge term in its objective for this linearization to be effective.

**Forecast requirement:** Peak shaving depends on a forecast of the load. If the forecast is wrong, the BESS may not discharge in time. The forecast load is \(\hat{P}_{load,t}\) (Part 1, section 1.4.7).

### 4.3.4 Asset reservation

Peak shaving reserves:

- **Power:** up to \(P_{max,t}^{AC,dis}\).
- **Energy:** the energy needed to cover the **excess above target**, not the entire target load:

\[
E_{peak}^{reserved} = \max_{t \in T_{peak}^{window}} \left( \hat{P}_{load,t} - P_{peak}^{target} \right) \cdot N_{peak} \cdot \Delta t
\]

where \(N_{peak}\) is the number of steps in the expected peak window.

**Correction note:** Earlier drafts reserved \(P_{peak}^{target} \cdot N_{peak} \cdot \Delta t\), which over-reserved by reserving the entire target load. The BESS only needs to cover the excess above target.

**Reservation rule:**

\[
E_t - E_{min,t} \ge E_{peak}^{reserved}
\]

### 4.3.5 Outputs / KPIs

| KPI | Symbol | Unit | Description |
|---|---|---|---|
| Peak reduction | \(\Delta P_{peak}\) | kW | Difference between baseline peak and capped peak |
| Demand charge savings | \(\Delta D_{savings}\) | $ | \(D_{charge} \cdot \Delta P_{peak}\) |
| Cycles consumed | \(N_{peak}^{cycles}\) | — | Number of discharge cycles used for peak shaving |
| Energy discharged | \(E_{peak}^{dis}\) | kWh | Total energy discharged for peak shaving |

**Demand charge savings per billing period:**

\[
\Delta D_{savings} = D_{charge} \cdot \left( P_{peak}^{baseline} - P_{peak}^{capped} \right)
\]

### 4.3.6 Risks

| Risk | Handling |
|---|---|
| **Forecast error** | The BESS may not discharge in time if the load spikes unexpectedly. Model uses \(\hat{P}_{load,t}\) with forecast error. |
| **Battery depletion** | If the BESS runs out of energy before the peak ends, the cap is violated. The energy reservation rule mitigates this. |
| **Conflicting services** | Peak shaving competes with arbitrage. Priority handled in Part 5. |
| **Billing period ratchet** | Some tariffs have a ratchet (peak demand persists for 11 months). The model records the billed peak per billing period. |

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

**Ownership note:** \(Th_t^{arb}\) is a per-service decomposition of Part 3's throughput state \(Th_t\). See section 4.13 for the Part 3 consultation.

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

**Unit note on \(r_{reg}^{mileage}\):** Mileage \(M_{reg,t}^{abs}\) is dimensionless (Part 1, §1.4.9, "—"). Therefore \(r_{reg}^{mileage}\) is in **$/unit of dimensionless mileage**. The unit is written as **$/mileage-unit** rather than $/mileage, to make the dimensionless nature explicit. The registered unit in Part 1 should be updated accordingly (see section 4.12).

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

where \(E_{reg,t}^{abs,up}\) and \(E_{reg,t}^{abs,down}\) are the **direction-specific absolute expected energies**. These are new symbols (see section 4.12).

**Correction note:** Part 1 §1.4.9 registers a combined \(E_{reg,t}^{abs}\) that sums up and down. For headroom reservation, direction-specific values are needed because up-regulation draws energy and down-regulation creates it — they cannot share one combined number.

**Peak-based capability reservation (Part 2, section 2.3.3):**

\[
\max\left(\left|P_{AC,t}^{base} + R_{reg,t}^{up}\right|,\; \left|P_{AC,t}^{base} - R_{reg,t}^{down}\right|\right)^2 + Q_{res,t}^2 \le S_{max}^2
\]

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

**Ownership note:** \(Th_t^{reg}\) is a per-service decomposition of Part 3's throughput state \(Th_t\). See section 4.13 for the Part 3 consultation.

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

**Average vs. peak capability split:** This constraint applies to **average** active and reactive power over the step. A separate **peak-based** reservation constraint (below) applies to the **committed peaks** of frequency regulation and voltage regulation. The two are distinct, mirroring Part 2 §2.3.3's explicit split of \(S_t\) (average) vs. the peak-based reservation constraint.

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
| **Peak shaving** | Cap net load at \(P_{peak}^{target}\) | \(P_{max,t}^{AC,dis}\) | \(E_{peak}^{reserved}\) (excess only) | Peak reduction (kW) | Demand charge savings |
| **Demand Response** | Deliver committed capacity | \(P_{DR,committed}\) | \(P_{DR,committed} \cdot \Delta t_{DR} / (\eta_{PCS} \cdot \eta_{d,t})\) | Event energy (kWh) | \(R_{DR}(t)\) |
| **Energy Arbitrage** | Exploit price differentials | \(P_{max,t}^{AC,ch}\), \(P_{max,t}^{AC,dis}\) | SOC window | Energy shifted (kWh) | \(R_{arb}(t)\) |
| **Frequency Regulation** | Support grid frequency | \(R_{reg,t}^{up}\), \(R_{reg,t}^{down}\) | \(E_{reg,t}^{abs,up}\), \(E_{reg,t}^{abs,down}\) | Regulation capacity (kW) | \(R_{reg}^{rev}(t)\) |
| **Voltage Regulation** | Support local voltage | \(Q_{res,t}\) | None | Reactive energy (kVArh) | Contractual |

---

## 4.9 Service interactions

Services compete for the same physical asset. The **coexistence rules** and **priority logic** are defined in Part 5.

**Summary of potential conflicts:**

| Service pair | Conflict | Resolution |
|---|---|---|
| Peak shaving + Arbitrage | Both want to discharge during high-value periods | Priority: peak shaving > arbitrage |
| DR + Arbitrage | DR events are mandatory; arbitrage is opportunistic | Priority: DR > arbitrage |
| Arbitrage + Frequency regulation | Both use the same SOC window | Regulation reserves headroom; arbitrage uses the rest |
| DR + Frequency regulation | Both need energy headroom | DR consumes energy; regulation reserves headroom |
| Peak shaving + Frequency regulation | Both need discharge capacity | Regulation reserves capacity; peak shaving uses the rest |
| Voltage regulation + any active service | Shares PCS apparent power | PCS capability constraint limits both |

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
| Epigraph variables (pending Part 5 objective) | \(D_{billed}\), \(E_{DR,\tau}^{delivered}\), \(Penalty\), \(P_{AC,t}^{curtailed}\) | Part 5 (objective must penalize) |

---

## 4.11 Part 4 changelog

### Version 1.0 — Final Candidate (FC1)

**Changes from Revision 2 (verified):**

1. **Version label updated to Final Candidate (FC1).** Revision 2 was the last substantive revision. FC1 is the promotion candidate.

2. **Sign-off status section added (4.1).** The document now explicitly lists the two pending external sign-offs:
   - Part 1 sign-off on the change request (4.12).
   - Part 3 consultation on throughput ownership (4.13).

3. **No other substantive changes.** FC1 is a status update only.

**Carried over from Revision 2 (verified):**

- Epigraph validity conditions stated explicitly for all four epigraph variables.
- DR delivered-energy inflation risk flagged.
- Average-vs-peak reactive capability split clarified.
- \(r_{reg}^{mileage}\) unit clarified.
- Part 3 consultation declared.

**Carried over from Revision 1 (verified):**

- Power factor constraint corrected.
- Arbitrage revenue formula corrected.
- DR SOC requirement corrected.
- Peak shaving energy reservation corrected.
- Direction-specific regulation headroom introduced.
- MILP linearization of max() restored.
- AC-side revenue convention stated.
- Part 1 change request compiled.

**Dropped from changelog (unverified or recycled):**

- None in this revision.

---

## 4.12 Part 1 change request

**Status:** Issued by Part 4. **Pending Part 1 sign-off.**

The following symbols are used in Part 4 but not yet registered in Part 1's master symbol table.

### 4.12.1 Service-specific output symbols (Part 4-owned)

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(E_{peak}^{reserved}\) | Energy reserved for peak shaving | kWh | 1.4.11 (derived) |
| \(\Delta P_{peak}\) | Peak reduction | kW | 1.4.7 (market/site) |
| \(\Delta D_{savings}\) | Demand charge savings | $ | 1.4.7 (market/site) |
| \(E_{peak}^{dis}\) | Energy discharged for peak shaving | kWh | 1.4.11 (derived) |
| \(E_{DR}^{delivered}\) | DR event energy delivered | kWh | 1.4.7 (market/site) |
| \(PS_{DR}\) | DR performance score | — | 1.4.7 (market/site) |
| \(r_{DR}^{capacity}\) | DR capacity revenue rate | $/kW | 1.4.7 (market/site) |
| \(r_{DR}^{energy}\) | DR energy revenue rate | $/kWh | 1.4.7 (market/site) |
| \(E_{shifted}\) | Energy shifted for arbitrage | kWh | 1.4.11 (derived) |
| \(R_{arb}^{net}(t)\) | Net arbitrage revenue after degradation | $ | 1.4.7 (market/site) |
| \(C_{cycle}\) | Marginal cycle cost | $/kWh | 1.4.7 (market/site) |
| \(N_{arb}^{cycles}\) | Cycles consumed by arbitrage | — | 1.4.11 (derived) |
| \(r_{reg}^{capacity}\) | Regulation capacity revenue rate | $/kW/h | 1.4.7 (market/site) |
| \(r_{reg}^{mileage}\) | Regulation mileage revenue rate | **$/mileage-unit** | 1.4.7 (market/site) |
| \(\Delta SOC_{reg}\) | SOC deviation during regulation | — | 1.4.9 (regulation) |
| \(E_{reg,t}^{abs,up}\) | Direction-specific up-regulation absolute energy | kWh | 1.4.9 (regulation) |
| \(E_{reg,t}^{abs,down}\) | Direction-specific down-regulation absolute energy | kWh | 1.4.9 (regulation) |
| \(Q_{energy,t}\) | Reactive energy | kVArh | 1.4.10 (voltage) |
| \(VC_t\) | Voltage compliance indicator | — | 1.4.10 (voltage) |

### 4.12.2 Configuration and asset symbols

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(\Delta t_{demand}\) | Demand charge interval | h | 1.4.15 (temporal) |
| \(N_{peak}\) | Number of steps in peak window | — | 1.4.11 (derived) |
| \(N_{peak}^{cycles}\) | Cycles consumed by peak shaving | — | 1.4.11 (derived) |
| \(\Delta\pi_{min}\) | Minimum price spread threshold | $/kWh | 1.4.7 (market/site) |
| \(f_{droop}(\cdot)\) | Voltage droop function | — | 1.4.10 (voltage) |
| \(\Delta V_t\) | Voltage deviation from setpoint | V | 1.4.10 (voltage) |
| \(V_t\) | Bus voltage | V | 1.4.10 (voltage) |
| \(V_{min}\) | Minimum acceptable voltage | V | 1.4.10 (voltage) |
| \(V_{max}\) | Maximum acceptable voltage | V | 1.4.10 (voltage) |
| \(V_{setpoint}\) | Voltage setpoint | V | 1.4.10 (voltage) |
| \(P_{AC,t}^{curtailed}\) | Active power curtailed (epigraph) | kW | 1.4.3 (derived) |
| \(P_{AC,t}^{desired}\) | Desired active power before curtailment | kW | 1.4.3 (derived) |
| \(P_{AC,t}^{available}\) | Available active power after reactive priority | kW | 1.4.3 (derived) |

### 4.12.3 Note on Part 1 §1.4.9 vs Part 4 §4.6.3

Part 1 §1.4.9 registers a **combined** \(E_{reg,t}^{abs}\) that sums up and down contributions. Part 4 §4.6.3 requires **direction-specific** \(E_{reg,t}^{abs,up}\) and \(E_{reg,t}^{abs,down}\) because up-regulation draws energy and down-regulation creates it — they cannot share one combined number for headroom reservation.

**Recommendation:** Part 1 should register both the combined form (for total throughput/degradation accounting) and the direction-specific forms (for headroom reservation). The scaling rule in §1.4.9 should be extended:

\[
E_{reg,t}^{abs} = E_{reg,t}^{abs,up} + E_{reg,t}^{abs,down}
\]

with \(E_{reg,t}^{abs,up} = E_{reg,t}^{exp,up} \cdot R_{reg,t}^{up}\) and \(E_{reg,t}^{abs,down} = E_{reg,t}^{exp,down} \cdot R_{reg,t}^{down}\).

### 4.12.4 Removed symbols

The symbol \(Q_{max}^{reactive-only}\) is **not to be re-registered**. It was removed in Part 1 FC7 and is not used in Part 4 FC1.

---

## 4.13 Part 3 consultation

**Status:** Issued by Part 4. **Pending Part 3 sign-off.**

Two symbols in Part 4 touch Part 3's throughput accounting:

| Symbol | Description | Unit | Current status |
|---|---|---|---|
| \(Th_t^{arb}\) | Throughput from arbitrage | kWh | Used in §4.5.5 |
| \(Th_t^{reg}\) | Throughput from regulation | kWh | Used in §4.6.5 |

**Ownership question:** Part 1's ownership convention states that the **Part column identifies the part that owns and produces the symbol**. Throughput \(Th_t\) is a **Part 3-owned state** (registered in Part 1 §1.4.1 as Part 3). Splitting it into per-service sub-components (\(Th_t^{arb}\), \(Th_t^{reg}\)) raises the same kind of ownership question that Part 2's \(\Delta Th_{cycle}\) raised.

**Two possible resolutions:**

**Resolution A — Part 3 owns the per-service decomposition.**
Part 3's throughput update rule currently is \(Th_{t+1} = Th_t + |P_{DC,t}| \cdot \Delta t\). It could be extended to track per-service throughput:

\[
Th_t^{arb} = \sum_{\tau \le t, \text{arbitrage active}} |P_{DC,\tau}| \cdot \Delta \tau
\]
\[
Th_t^{reg} = \sum_{\tau \le t} \Delta Th_\tau^{reg}
\]

with \(Th_t = Th_t^{arb} + Th_t^{reg} + Th_t^{other}\). This makes Part 3 the owner of the decomposition.

**Resolution B — Part 4 does not register per-service throughput (recommended).**
Part 4 uses \(Th_t\) (the single Part 3 state) as a proxy for degradation cost attribution. The per-service decomposition is internal accounting, not a registered symbol. Per-service degradation cost is computed as \(c_{deg} \cdot Th_t^{service}\), where \(Th_t^{service}\) is attributed using the allocation vector \(a_t\) from Part 1 §1.4.2.

**Part 4's recommendation:** Resolution B. Part 4 does not need per-service throughput as a registered symbol; it needs per-service **degradation cost attribution**, which can be computed from the existing \(Th_t\) state and the dispatch allocation decisions. Registering two new Part 3-owned symbols adds complexity without clear benefit.

**Attribution mechanism (Resolution B):** Part 5's dispatch allocation vector \(a_t\) records the fraction of the step's throughput allocated to each service. Per-service throughput is then:

\[
Th_t^{service} = \sum_{\tau \le t} a_{service,\tau} \cdot |P_{DC,\tau}| \cdot \Delta \tau
\]

where \(a_{service,\tau}\) is the service's share of the step's throughput. This attribution is computed in Part 5, not stored as a Part 3 state.

**Note:** When multiple services are simultaneously active in the same step (e.g., regulation headroom reserved and arbitrage cycling in the same interval), the allocation vector \(a_t\) splits the incremental throughput between them. The exact split rule is a Part 5 decision, to be specified when Part 5 defines the objective.

**If Part 3 prefers Resolution A**, the Part 1 change request (section 4.12) must be extended to include \(Th_t^{arb}\) and \(Th_t^{reg}\) as Part 3-owned symbols, and Part 3's throughput update rule must be amended accordingly.

**If Part 3 prefers Resolution B** (recommended), no Part 1 change is needed for \(Th_t^{arb}\) and \(Th_t^{reg}\), and Part 4's §4.5.5 and §4.6.5 use internal accounting rather than registered symbols.

**Pending:** Part 3 sign-off on the resolution.

---

## 4.14 Exit criteria for promotion to v1.0

| # | Criterion | Status |
|---|---|---|
| 1 | **Part 1 sign-off** on the change request (4.12). Register the new symbols. | **PENDING** |
| 2 | **Part 3 sign-off** on the throughput ownership resolution (4.13). Resolve to A or B. | **PENDING** |
| 3 | Internal cross-references verified (Part 2, Part 5 references are consistent). | **MET** |
| 4 | Changelog cumulative and honest. | **MET** |
| 5 | No truncated sections. | **MET** |
| 6 | All epigraph variables labeled with Part 5 dependency. | **MET** |

**Freeze definition:** Frozen (v1.0) means changes only via change request with version increment. No silent edits. FC documents are under review, not frozen.

---

## 4.15 Next steps

Part 4 is **at FC1, pending two external sign-offs**:

1. **Part 1 FC8** — process the Part 4 change request (section 4.12). Register ~30 new symbols.
2. **Part 3 consultation** — resolve the throughput ownership question (section 4.13). Part 4 recommends Resolution B.

Once both are resolved, Part 4 can be promoted to v1.0.

**Recommended writing order:**

1. **Part 1** — FC8: absorb Part 2 and Part 4 change requests in one pass.
2. **Part 3** — Address the Part 4 consultation as one of its first design decisions.
3. **Part 2** — Revision 3, pending Part 1 sign-off (satisfied by FC7).
4. **Part 4** — FC1, pending Part 1 sign-off and Part 3 consultation.
5. **Part 5** — Dispatch, stacking, outputs.

