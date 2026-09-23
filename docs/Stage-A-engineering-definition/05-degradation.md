Aplico los seis patches. Aquí tienes **A.2.5 v0.2 — Degradation Engineering**, con los cambios integrados en el cuerpo del documento.

---

# Degradation Engineering
## Stage A.2.5 — Conceptual Engineering
### Capability Evolution of the BESS Operational & Financial Modeling System

**Document ID:** A.2.5-DEG-ENG-001

**Version:** 0.2 — Development Draft

**Status:** Stage A.2 — Conceptual Engineering (Domain Level)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.8)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.5)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.2)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.3)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v0.7)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.0)

**Domain:** Domain 5 — Degradation Engineering

**Purpose:** Define, at a conceptual level, what the Degradation Engineering domain represents, what it consumes from Dispatch, BESS Engineering, and Scenario Management, what it produces, how it evolves battery capability over time, how it produces the marginal degradation signal, and what engineering decisions must be made in later stages — **without** prescribing equations, algorithms, or implementation.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.5 — Conceptual Engineering** of the Degradation Engineering domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §4.

Its purpose is to establish the **conceptual engineering definition** of the domain that represents how BESS operation changes the battery's future capability, and how that change is communicated back to Dispatch and forward to Financial Engineering.

It answers, at conceptual level:

- What degradation is, at a conceptual level
- What it consumes from Dispatch, BESS Engineering, Operational Engineering, and Scenario Management
- What it produces to Dispatch, BESS Engineering, and Financial Engineering
- How the feedback loop between Dispatch and Degradation operates
- What the marginal degradation cost is, and what it is not
- What modeling traps it must address
- What is **not** decided here (and who decides it)

It deliberately does **not** define:

- Degradation equations
- Calendar aging models
- Cycle aging models
- Rainflow counting algorithms
- Augmentation algorithms
- Numerical integration schemes
- Software architecture
- Data schemas
- Python classes or APIs

Those belong to Stage B (architecture and formulation) and Stage C (detailed formulation and implementation).

### 1.1 Decision Layers — Methodology, Architecture, Formulation

| Layer | Decided in | What it fixes |
|---|---|---|
| **Methodology** | **Phase 1** | The class of approach: empirical / semi-empirical / vendor-data-driven |
| **Architecture** | **Stage B** | Components, interfaces, execution pattern, feedback frequency |
| **Formulation** | **Stage B / C** | Aging model structure, augmentation logic, marginal signal derivation |
| **Detailed formulation** | **Stage C** | Equations, coefficients, integration scheme, calibration |

### 1.2 Working Defaults from the Strategy

| Strategy default | Working default used in this document |
|---|---|
| **D3** | **Annual SOH update** with representative-period simulation within each year |
| **PH-043** | **Semi-empirical** degradation model |
| **PH-044** | **SOH-threshold-triggered** augmentation policy |
| **PH-045** | **Reset to BOL** on replacement |

Each default is revisable if ENGIE indicates otherwise.

### 1.3 Position Within Stage A

This document sits **between** A.2.4 (Dispatch & Optimization) and A.2.6 (Financial Engineering). It **establishes the conceptual contract for the physical-operational cycle closure** before entering the economic valuation layer.

### 1.4 The Most Important Boundary in This Document

> **Degradation Engineering determines how operation changes future physical capability, and derives the marginal degradation signal used by Dispatch. Financial Engineering determines the resulting economic consequences.**

This boundary prevents the single most dangerous collapse in BESS modeling: conflating **physical degradation**, **marginal degradation cost**, and **replacement cash flow** into a single quantity.

### 1.5 Relationship to Upstream Domains

| Domain | What it provides to Degradation |
|---|---|
| **BESS Engineering (A.2.1)** | Initial state (SOH, capacity, efficiency), physical parameters, temperature profile |
| **Dispatch (A.2.4)** | Battery usage: dispatch schedule, SOC trajectory, throughput, cycling behavior |
| **Operational Engineering (A.2.3)** | Declarations of which operational behaviors are degradation-relevant |
| **Scenario Management** | Augmentation policy, replacement policy, EOL threshold, replacement cost assumption |

### 1.6 Relationship to Downstream Domains

| Domain | What it receives from Degradation |
|---|---|
| **Dispatch (A.2.4)** | Updated SOH, available capacity, marginal degradation cost (where applicable), updated operating constraints |
| **BESS Engineering (A.2.1)** | Updated physical state (SOH, available capacity, efficiency characteristics) |
| **Financial Engineering (A.2.6)** | Augmentation events, replacement events, physical event information required for financial valuation |

### 1.7 Generality Principle

This document defines **generic degradation concepts** — parameterizable for different battery chemistries, vendors, configurations, and use patterns. It does not hard-code a specific chemistry or vendor.

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Degradation Engineering domain** is the conceptual representation of the **evolution of battery capability over time** as a consequence of operation and environmental conditions. It transforms the battery usage produced by Dispatch into an updated physical state, and it produces the marginal degradation signal that Dispatch may consume.

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| A physical capability model | Physical capability belongs to Domain 1 |
| A dispatch model | Dispatch belongs to Domain 4 |
| A financial model | Economic valuation belongs to Domain 6 |
| A cash flow model | Augmentation and replacement cash flows belong to Domain 6 |
| **A financial degradation-cost calculator** | The economic *valuation* of degradation belongs to Domain 6. Domain 5 produces a **marginal operational signal** derived from physical and scenario inputs; Domain 6 produces the **economic valuation** |
| A warranty model | Warranty terms are inputs, not a domain |
| A software module | Software structure belongs to Stage B/C/D |

### 2.3 The Three Concepts That Must Not Collapse

The most consequential discipline in this domain is distinguishing three concepts that are easy to conflate:

| Concept | What it is | Nature | Owned by | Consumed by |
|---|---|---|---|---|
| **Physical degradation** | The loss of battery capability over time (SOH decline, capacity fade, efficiency fade) | **Physical state** | **Domain 5** | Domain 1 (state update), Domain 4 (feasibility), Domain 6 (indirectly, via reduced revenue) |
| **Marginal degradation cost** | A derived per-MWh signal representing the economic cost of one more unit of throughput | **Operational signal** | **Domain 5** (owner of the derived signal) | Domain 4 (dispatch objective, where the methodology includes it) |
| **Replacement cash flow** | The actual money spent on augmentation or replacement events | **Monetary flow** | **Domain 6** | Financial KPIs only |

**Rule.** These are three distinct quantities. None of them may be substituted for another.

- Physical degradation is a **state**, not a cost.
- Marginal degradation cost is a **signal**, not a cash flow.
- Replacement cash flow is **money**, not a state or a signal.

### 2.4 Primary Question

> **How does operating the battery change the battery over time, and what does one more unit of throughput cost?**

### 2.5 Guiding Principle

> **Degradation Engineering owns the physical consequence of operation, and the derived marginal signal. It does not own the economic valuation of that consequence.**

---

## 3. Engineering Scope

| # | Aspect | Description |
|---|---|---|
| 1 | Calendar aging | Time-dependent capacity fade |
| 2 | Cycle aging | Throughput-dependent degradation |
| 3 | Depth of Discharge | Cycle depth influence |
| 4 | C-rate | Cycle intensity influence |
| 5 | Temperature | Thermal influence on aging |
| 6 | Equivalent full cycles | Cumulative throughput metric |
| 7 | Capacity fade | Loss of usable capacity |
| 8 | SOH | Remaining capability relative to beginning-of-life |
| 9 | Efficiency degradation | Loss of round-trip efficiency over time |
| 10 | Augmentation evaluation | Detection of augmentation trigger per declared policy |
| 11 | Replacement evaluation | Detection of replacement trigger per declared policy |
| 12 | Marginal degradation signal | Derived per-MWh signal for Dispatch (where applicable) |
| 13 | Interface with Dispatch | Updated state and signal |
| 14 | Interface with Financial | Physical events and physical event information required for financial valuation |

The domain does **not**:
- Define the physical capability of the BESS (Domain 1)
- Select the dispatch (Domain 4)
- Compute financial KPIs (Domain 6)
- Compute replacement cash flows (Domain 6)
- Define the augmentation or replacement **policy** (Scenario Management)

---

## 4. Conceptual Model of Degradation

### 4.1 High-Level Structure

```
   Dispatch  ──── Battery Usage ────►  Degradation Engineering
                                              │
                                              ├── Physical state evolution
                                              │   (SOH, capacity, efficiency)
                                              │
                                              ├── Policy evaluation
                                              │   (augmentation / replacement trigger)
                                              │
                                              └── Derived marginal signal
                                                  (where applicable)
                                              │
                    ┌─────────────────────────┴─────────────────────────┐
                    ▼                                                   ▼
              Dispatch (A.2.4)                                   BESS Engineering (A.2.1)
              • Updated SOH                                      • Updated physical state
              • Available capacity                               • Updated efficiency
              • Marginal degradation cost                        • Updated capability
              • Updated operating constraints
                                                                       │
                                                                       ▼
                                                              Financial Engineering (A.2.6)
                                                              • Augmentation events
                                                              • Replacement events
                                                              • Physical event information

                                              ▲
                                              │
                                    Scenario Management
                                    • Augmentation policy
                                    • Replacement policy
                                    • EOL threshold
                                    • Replacement cost assumption
```

### 4.2 Conceptual Sub-Areas

| Sub-Area | Conceptual Role |
|---|---|
| Calendar aging | Time-dependent fade from storage conditions |
| Cycle aging | Throughput-dependent fade from operation |
| State evolution | SOH, capacity, efficiency as functions of aging |
| Policy evaluation | Detection of augmentation and replacement triggers |
| Marginal signal derivation | Derived per-MWh signal for dispatch |
| Feedback to Dispatch | Updated state, available capacity, marginal signal |
| Feedback to BESS Engineering | Updated physical state |
| Feedback to Financial | Augmentation and replacement events, physical event information |

### 4.3 Degradation Boundary

| Inside the domain | Outside the domain |
|---|---|
| Calendar aging | Physical capability definition |
| Cycle aging | Dispatch selection |
| SOH evolution | Economic valuation |
| Capacity fade | Cash flow computation |
| Efficiency fade | **Augmentation policy definition** |
| **Policy evaluation** (trigger detection) | **Replacement policy definition** |
| Marginal signal derivation | **EOL threshold definition** |
| Physical event production | **Replacement cost assumption** |
| Physical event information | Software implementation |

---

## 5. Inputs to Degradation

### 5.1 From Dispatch (A.2.4)

| Input | Meaning |
|---|---|
| Dispatch schedule | Charge / discharge / rest per interval |
| SOC trajectory | SOC per interval |
| Charge throughput | Cumulative energy charged |
| Discharge throughput | Cumulative energy discharged |
| Cycling behavior | Number of cycles, depth of discharge per cycle, C-rate per cycle |
| Reserved capacity | Time spent in reservation states (does not consume throughput) |

**Feedback frequency.** Per working default **D3**, this input is consumed **annually** with representative-period simulation within each year. The annual SOH update means:

- SOH is held constant **within** each simulated year
- SOH is updated **between** years based on the year's aggregated usage
- Representative periods are simulated with SOH held constant within the year; their **degradation-relevant usage is subsequently aggregated** to determine the annual state update

Representative periods may be dispatched independently (with SOH fixed within the year), but the **annual degradation update is not independent across representative periods** — it aggregates all of them. This is the working assumption for the thin slice. It is revisable per **PH-038**.

### 5.2 From BESS Engineering (A.2.1)

| Input | Meaning |
|---|---|
| Initial SOH | Beginning-of-life state of health |
| Initial capacity | Nominal and usable capacity |
| Initial efficiency | Round-trip and conversion efficiency |
| Physical parameters | Battery configuration, chemistry class, C-rate limits |
| SOC bounds | Minimum and maximum admissible SOC |
| Temperature profile | Ambient or cell temperature as input assumption |

**Note.** Augmentation and replacement policies are **not** provided by BESS Engineering. They are provided by Scenario Management (§5.4). BESS Engineering provides physical parameters and initial state only.

### 5.3 From Operational Engineering (A.2.3)

| Input | Meaning |
|---|---|
| Degradation-relevant behavior declarations | Which operational behaviors generate degradation-relevant usage |

Operational Engineering declares **which behaviors** generate degradation-relevant usage. Degradation Engineering computes **the resulting degradation**.

### 5.4 From Scenario Management

| Input | Meaning |
|---|---|
| Augmentation policy | Scenario-level policy (e.g. SOH threshold) |
| Replacement policy | Scenario-level policy (e.g. SOH threshold, EOL criterion) |
| End-of-life threshold | EOL criterion (e.g. 70% or 80% SOH) |
| Replacement cost assumption | Financial scenario input, used in marginal signal derivation |

**Note on ownership.** The augmentation policy, replacement policy, and EOL threshold are **scenario parameters**. Degradation Engineering **evaluates** them — it detects when the physical state reaches the trigger — but does **not define** them.

**Note on replacement cost.** The replacement cost is a **financial scenario assumption**, not a computed result of Domain 6. It is provided by Scenario Management, and Degradation Engineering uses it (in combination with physical assumptions) to derive a per-MWh marginal signal (where applicable). This is the mechanism by which an investment assumption enters dispatch via a derived operational signal (`SYS-STR-FRM-001` §6.4).

---

## 6. Conceptual Aging Model

### 6.1 Calendar Aging

Calendar aging represents capacity fade that occurs **independently of cycling**, driven by time and storage conditions.

**Conceptual requirements:**

- Time-dependent capacity fade
- Dependence on average SOC
- Dependence on temperature
- Independence from throughput

### 6.2 Cycle Aging

Cycle aging represents capacity fade caused by **charge/discharge cycling**.

**Conceptual requirements:**

- Throughput-dependent capacity fade
- Dependence on depth of discharge (DOD)
- Dependence on C-rate
- Dependence on temperature
- Cumulative over the battery's life

### 6.3 Total Aging

The total degradation is the **combined effect** of calendar and cycle aging. The combination is not simply additive; it depends on the aging model structure, which is deferred to Stage B/C.

**Conceptual requirement:** The domain must be able to represent the combined effect of calendar and cycle aging on SOH, capacity, and efficiency.

### 6.4 Model Fidelity

Per working default **PH-043**, the degradation model fidelity is **semi-empirical**. This means:

- The model combines physical understanding with empirical coefficients
- Coefficients are calibrated from vendor data, literature, or both
- The model is parameterizable for different chemistries and vendors

**What is not decided here:** the specific model structure, the specific coefficients, the specific calibration data. Those belong to Stage B/C.

---

## 7. State Evolution

### 7.1 State Variables

| State Variable | Nature | Updated by |
|---|---|---|
| SOH | **Evolves according to degradation, and may change discontinuously when system configuration changes through augmentation or replacement** | Degradation |
| Available capacity | Derived from nominal capacity and current SOH, per the aggregation rule applicable to the current system configuration | Degradation |
| **Usable energy capability** | Derived from available capacity and applicable operating SOC limits | Degradation |
| Efficiency | May degrade over time | Degradation |
| Equivalent full cycles | Cumulative throughput metric | Degradation |
| Augmentation history | Sequence of capacity addition events | Degradation |
| Replacement history | Sequence of full replacement events | Degradation |

**Note on SOH nature.** The SOH of the system is not assumed to be monotonically non-increasing across the full project life. Augmentation adds new capacity at a different SOH, and the aggregate system SOH may evolve non-monotonically. The aggregation rule for mixed-cohort systems is a Stage B decision (see **PH-018**).

### 7.2 What This Domain Provides to BESS Engineering

Degradation Engineering updates the **physical state** that BESS Engineering holds:

- Updated SOH
- Updated available capacity
- Updated efficiency characteristics

BESS Engineering stores and exposes these values; Degradation Engineering computes their evolution.

**Note.** Per `A.2.1-BESS-ENG-001` §8.4, **SOH is a BESS state variable whose evolution is determined by Degradation Engineering**. This document does not contradict that; it confirms it.

### 7.3 What This Domain Provides to Dispatch

| Output | Meaning |
|---|---|
| Updated SOH | State of health at the applicable feedback point |
| Available capacity | Usable capacity given current SOH |
| Marginal degradation cost | Derived per-MWh signal (where applicable) |
| Updated operating constraints | Constraints that change with SOH |

### 7.4 What This Domain Provides to Financial Engineering

| Output | Meaning |
|---|---|
| Augmentation events | When capacity is added, and how much |
| Replacement events | When the battery is replaced |
| **Physical event information** | Physical quantities and timing required for financial valuation |

**Important.** Degradation Engineering does **not** provide monetary cash flows to Financial Engineering. It provides **physical events** and **physical event information**. Financial Engineering converts these into cash flows using financial assumptions (replacement cost, timing, discounting).

---

## 8. Augmentation and Replacement

### 8.1 Ownership of the Policy

The augmentation and replacement **policies** are **scenario parameters**, owned by Scenario Management:

| Policy element | Owner |
|---|---|
| Augmentation trigger (e.g. SOH threshold) | Scenario Management |
| Replacement trigger (e.g. SOH threshold, EOL criterion) | Scenario Management |
| End-of-life threshold | Scenario Management |
| Replacement cost assumption | Scenario Management (financial assumption) |

Degradation Engineering **evaluates** these policies — it detects when the physical state reaches the trigger — and generates the corresponding physical event.

### 8.2 Augmentation

**Concept.** Augmentation is the **addition of capacity** to a battery system, typically to compensate for degradation and restore system-level capacity.

**Conceptual requirements:**

- Augmentation events are triggered by a policy declared in Scenario Management
- When an augmentation event occurs, capacity is added
- The added capacity starts at its own state of health (typically BOL or close to it)
- After augmentation, the system operates with **mixed-cohort** capacity

**Working default (PH-044):** SOH-threshold-triggered augmentation.

**Note on mixed cohorts.** After augmentation, the system contains multiple cohorts with different SOH. The aggregation rule for the aggregate system SOH is a Stage B decision (see **PH-018**). This document does not impose a particular aggregation rule.

### 8.3 Replacement

**Concept.** Replacement is the **full replacement** of the battery system, typically at end-of-life.

**Conceptual requirements:**

- Replacement events are triggered by a policy declared in Scenario Management
- When a replacement event occurs, the battery is replaced with a new system
- The new system starts at BOL
- Replacement may or may not include residual value of the replaced system

**Working default (PH-045):** Replacement resets capacity to beginning-of-life.

### 8.4 End-of-Life Threshold

The **end-of-life threshold** is the SOH level at which the battery is considered to have reached its end of useful life.

**Conceptual requirement:** The domain must be able to evaluate a configurable EOL threshold.

**Working default:** Not fixed in this document. Evaluated during Phase 1 as a candidate working assumption, informed by **PH-016** (SOC bounds and warranty) and **PH-044** (augmentation policy).

---

## 9. Marginal Degradation Signal

### 9.1 What It Is

The **marginal degradation cost** is a **derived per-MWh signal** representing the economic cost of consuming one more unit of battery throughput.

**Working conceptual basis:** The signal is derived from **replacement/augmentation economics combined with degradation throughput/capability assumptions**.

The precise formulation is deferred to Stage B/C. Depending on the model, the signal may be derived from:

- Replacement cost
- Augmentation cost
- Lost future capacity
- Opportunity cost of degradation
- Lifetime throughput
- State-dependent degradation
- A combination of the above

### 9.2 Why It Exists

In dispatch optimization, using the battery incurs a cost — not because energy is lost, but because the battery's useful life is consumed. Without a signal representing this cost, the dispatch would over-cycle the battery, consuming throughput that could be used more valuably later.

The marginal degradation cost is the mechanism by which **long-term battery health** enters the **short-term dispatch decision**, via a documented operational signal.

### 9.3 Ownership

Degradation Engineering is the **owner of the derived marginal signal**. It is not:

- A physical state (that is SOH)
- A cash flow (that is Financial Engineering's replacement flow)
- A financial KPI (that is Financial Engineering's NPV/IRR)

It is a **derived operational signal** (`SYS-STR-FRM-001` §6.4).

### 9.4 Interface with Dispatch

Dispatch may consume the marginal degradation cost **if the selected methodology supports it**. Whether it enters the dispatch objective is a Phase 1 / Stage B decision.

| Scenario | Behavior |
|---|---|
| Signal provided, methodology includes it in objective | Dispatch minimizes the combined cost of operation plus degradation |
| Signal provided, methodology does not include it | Signal is available but not used; dispatch may over-cycle |
| Signal not provided | Dispatch operates without degradation signal; over-cycling risk unless mitigated by other constraints |

**Working default:** The signal is produced. Whether it enters the dispatch objective depends on the selected methodology (**PH-032**).

### 9.5 Interface with Financial Engineering

**The marginal degradation cost is not a cash flow.** It does not appear as a line item in the financial model. Financial Engineering consumes **only**:

- Augmentation events (physical)
- Replacement events (physical)
- Physical event information (quantities, timing)

Financial Engineering converts these into **actual cash flows** using financial assumptions. The marginal degradation cost is **not** among them.

This is the mechanism that prevents double counting (`SYS-ENG-DEF-001` §11.5).

### 9.6 What Is Not Decided Here

- The exact formulation of the marginal signal (Stage B/C)
- Whether the signal is produced as a single scalar or a time-varying quantity
- Whether the signal is consumed by Dispatch (Phase 1 / Stage B)
- Whether the signal varies by value stream

---

## 10. Modeling Traps

| Trap | Why It Matters | Conceptual Approach |
|---|---|---|
| **Double counting degradation** | Physical degradation reduces future revenue; a cash-flow degradation cost on top of that would double-count | Marginal degradation cost is a dispatch signal only; cash flow contains real augmentation/replacement flows only (`SYS-ENG-DEF-001` §11.5) |
| **Conflating three concepts** | Physical degradation, marginal degradation cost, and replacement cash flow are distinct | Each is separately owned (§2.3) |
| **Feedback frequency inconsistency** | If SOH is updated at the wrong frequency relative to dispatch, the loop is either unstable or inefficient | Working default D3: annual SOH update; revisable per PH-038 |
| **Mixed cohorts after augmentation** | Multiple cohorts with different SOH coexist after augmentation | Aggregation rule deferred to Stage B; working default is capacity-weighted SOH (per PH-018) |
| **SOC window behavior** | Whether the SOC window narrows proportionally or is preserved in kWh affects usable energy in later years | Deferred per PH-017 |
| **Temperature representation** | Temperature affects aging rate; whether it is a fixed assumption or a time-varying input matters | Temperature is an **input assumption** per A.2.1 §13.2 |
| **C-rate effects on aging** | High C-rate accelerates aging; not all models capture this | Model fidelity per PH-043 (semi-empirical) |
| **Depth of discharge effects** | Deeper cycles typically age the battery faster per unit of throughput | Model structure must represent this |
| **Reserved capacity does not consume throughput** | Reservations hold capacity but do not cycle it; degradation should reflect actual cycling | Input from Dispatch distinguishes reservation from actual operation |
| **Representative-period aggregation** | Representative periods are simulated independently for dispatch, but degradation must aggregate their usage annually | Annual update aggregates all representative periods within the year |

---

## 11. Interface with BESS Engineering (Conceptual)

### 11.1 What Degradation Provides to BESS Engineering

| Output | Purpose |
|---|---|
| Updated SOH | State variable update |
| Updated available capacity | Capability update |
| Updated efficiency characteristics | Capability update |
| Augmentation events | Physical state change |
| Replacement events | Physical state reset |

### 11.2 What Degradation Consumes from BESS Engineering

| Input | Purpose |
|---|---|
| Initial state | Starting point for aging |
| Physical parameters | Aging model parameters |
| SOC bounds | Aging behavior context |
| Temperature profile | Aging rate modifier |

**Note.** Augmentation and replacement policies are **not** consumed from BESS Engineering. They come from Scenario Management (§5.4).

### 11.3 Boundary Discipline

BESS Engineering **owns the physical state** (including SOH as a state variable). Degradation Engineering **computes the evolution** of that state. Neither subsumes the other.

**Confirmed by** `A.2.1-BESS-ENG-001` §8.4.

---

## 12. Interface with Dispatch & Optimization (Conceptual)

### 12.1 What Dispatch Provides to Degradation

| Input | Meaning |
|---|---|
| Dispatch schedule | Charge / discharge / rest per interval |
| SOC trajectory | SOC per interval |
| Throughput | Cumulative charge and discharge |
| Cycling behavior | Cycle count, DoD, C-rate |
| Reserved capacity | Reservation states |

### 12.2 What Degradation Provides to Dispatch

| Output | Meaning |
|---|---|
| Updated SOH | At the applicable feedback point |
| Available capacity | Usable capacity given current SOH |
| Marginal degradation cost | Where applicable |
| Updated operating constraints | Constraints that change with SOH |

### 12.3 The Feedback Loop

```
Dispatch
   │
   │ Battery Usage
   ▼
Degradation Engineering
   │
   │ Updated State + Marginal Signal
   ▼
Dispatch (next step)
```

**Feedback time scale** is a Phase 1 decision (**D3** / **PH-038**). Working default is annual SOH update with representative-period simulation within each year.

### 12.4 Boundary Discipline

Dispatch **owns the operating decision**. Degradation Engineering **owns the physical consequence and the derived signal**. The two domains exchange **state and usage**, not algorithms.

---

## 13. Interface with Financial Engineering (Conceptual)

### 13.1 What Degradation Provides to Financial Engineering

| Output | Meaning |
|---|---|
| Augmentation events | Physical events with timing and capacity added |
| Replacement events | Physical events with timing and capacity replaced |
| Physical event information | Physical quantities and timing required for financial valuation |

### 13.2 What Financial Engineering Provides to Degradation

| Input | Meaning |
|---|---|
| Replacement cost assumption | Financial scenario input used in marginal signal derivation |

**Note.** The replacement cost assumption is provided **via Scenario Management**, not directly by Financial Engineering.

### 13.3 What Degradation Does NOT Provide to Financial Engineering

- Monetary cash flows
- Discounted values
- NPV, IRR, payback
- Marginal degradation cost as a cash flow item

**Financial Engineering converts physical events into cash flows.** Degradation Engineering provides the physical events and physical event information.

### 13.4 Boundary Discipline

Degradation Engineering owns the **physical consequence** and the **derived signal**. Financial Engineering owns the **economic valuation** of that consequence.

This boundary is the mechanism that prevents double counting (`SYS-ENG-DEF-001` §11.5).

---

## 14. Interface with Operational Engineering (Conceptual)

### 14.1 What Operational Engineering Provides

Per `A.2.3-OPS-ENG-001` §14.1, Operational Engineering declares which behaviors generate degradation-relevant usage.

| Value Stream | Degradation-Relevant Behavior |
|---|---|
| Peak Shaving | Moderate throughput; potentially high-rate discharge |
| Demand Response | Event-driven cycling; may impose deep discharges |
| Energy Arbitrage | Cycling behavior; throughput and cycle depth |
| Frequency Regulation | Potentially high-frequency cycling and throughput, depending on the regulation product and signal characteristics |
| Voltage Regulation | Low throughput; primarily reactive — minimal cycling |

### 14.2 Boundary Discipline

Operational Engineering declares **what behavior occurs**. Degradation Engineering computes **degradation resulting from those behaviors**.

Operational Engineering does **not** declare the magnitude of degradation, the marginal degradation cost, or whether degradation consequences are included in dispatch. Those belong to A.2.5, A.2.4, and A.2.6.

---

## 15. Assumptions and Engineering Uncertainties

### 15.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | Degradation model fidelity is semi-empirical | Working default **PH-043** | Would require different calibration approach |
| 2 | SOH update frequency is annual with representative-period simulation | Working default **D3** / **PH-038** | Would change feedback loop architecture |
| 3 | Augmentation is SOH-threshold-triggered | Working default **PH-044** | Would change augmentation logic |
| 4 | Replacement resets capacity to BOL | Working default **PH-045** | Would change long-term capacity model |
| 5 | Physical degradation, marginal degradation cost, and replacement cash flow are distinct | Core boundary principle | Would collapse the model |
| 6 | Marginal degradation cost is a derived signal, not a cash flow | Core boundary principle | Would cause double counting |
| 7 | Temperature is an input assumption, not a modeled state | Per A.2.1 §13.2 | Would change aging model |
| 8 | Augmentation and replacement policies are scenario parameters, not BESS Engineering parameters | Ownership principle (§8.1) | Would blur ownership |

### 15.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Degradation model structure | **Stage B** |
| 2 | Calibration data source | **PH-015** / **PH-043** |
| 3 | Feedback frequency | **PH-038** |
| 4 | Augmentation policy details | **PH-044** |
| 5 | Replacement policy details | **PH-045** |
| 6 | SOC window behavior under degradation | **PH-017** |
| 7 | Multi-cohort aggregation rule | **PH-018** |
| 8 | Whether marginal signal enters dispatch objective | **PH-032** / **PH-039** |
| 9 | End-of-life threshold | **PH-016** / **PH-044** |
| 10 | Efficiency degradation representation | **Stage B** |
| 11 | Marginal signal formulation | **Stage B / C** |
| 12 | Rainflow counting (if used) | **Stage C** |
| 13 | Numerical integration scheme | **Stage C** |

### 15.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `PH1-REG-001`:

- **PH-015** — Battery data
- **PH-016** — SOC bounds and warranty
- **PH-017** — SOC window behavior under degradation
- **PH-018** — Multi-cohort aggregation after augmentation
- **PH-038** — Degradation feedback time scale
- **PH-039** — Financial objective inside dispatch
- **PH-043** — Degradation model fidelity
- **PH-044** — Augmentation policy
- **PH-045** — Replacement policy

---

## 16. Conceptual Outputs of the Domain

| Output | Consumer | Nature |
|---|---|---|
| Updated SOH | BESS Engineering, Dispatch | Time series |
| Available capacity | BESS Engineering, Dispatch | Time series |
| Updated efficiency characteristics | BESS Engineering | Time series |
| Equivalent full cycles | Dispatch, Financial (indirectly) | Cumulative metric |
| Marginal degradation cost | Dispatch (where applicable) | Per-MWh signal |
| Augmentation events | Financial Engineering, BESS Engineering | Discrete events |
| Replacement events | Financial Engineering, BESS Engineering | Discrete events |
| Physical event information | Financial Engineering | Quantities and timing |
| Updated operating constraints | Dispatch | Time series |

---

## 17. Validation Requirements (Conceptual)

### 17.1 Domain-Level Validation

| Check | Nature |
|---|---|
| SOH evolution integrity | SOH evolves consistently with degradation inputs; discontinuities are only at augmentation/replacement events |
| Capacity consistency | Available capacity is consistent with nominal capacity and current SOH, per the applicable aggregation rule |
| EFC consistency | Equivalent full cycles accumulate consistently with throughput |
| Augmentation integrity | Augmentation events add capacity at the declared state |
| Replacement integrity | Replacement events reset capacity per policy |
| **Mass/energy consistency across augmentation and replacement** | Physical quantities are conserved or explicitly accounted for at each event |
| Temperature dependence | Aging rate varies consistently with temperature input |
| Calendar vs. cycle separation | The two aging mechanisms are distinguishable in the model |

### 17.2 Interface Validation

| Check | Nature |
|---|---|
| Dispatch input completeness | All battery usage relevant to aging is received from Dispatch |
| **Dispatch–degradation reconciliation** | Degradation inputs must reconcile to the actual dispatch history used by the operational simulation |
| Dispatch output consistency | Updated SOH and available capacity are consistent with the usage history |
| Financial output completeness | Augmentation and replacement events are complete and traceable |
| BESS state consistency | Updated state is consistent with BESS Engineering's state representation |
| Marginal signal integrity | Marginal signal is consistent with the physical basis and scenario inputs |

### 17.3 Validation Evidence

Validation evidence must be **produced before results are accepted**.

---

## 18. Boundaries — Explicit

### 18.1 Answers

- How does operating the battery change the battery over time?
- What is the state of health (SOH) at any point in the project lifecycle?
- What is the available capacity at any point?
- What does one more unit of throughput cost (marginal signal)?
- When do augmentation and replacement events occur?
- What physical event information is available for financial valuation?

### 18.2 Does Not Answer

- What can the physical BESS do at a given moment? (Domain 1)
- What should the BESS do economically? (Domain 4)
- What does augmentation or replacement cost in money? (Domain 6)
- What is the project's NPV, IRR, or payback? (Domain 6)
- What is the external context? (Domain 2)
- How is the model implemented? (Stage B/C/D)

### 18.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| Degradation | BESS Engineering | Updated SOH, available capacity, efficiency characteristics |
| Degradation | Dispatch | Updated SOH, available capacity, marginal degradation cost (where applicable), updated constraints |
| Degradation | Financial | Augmentation events, replacement events, physical event information |
| BESS Engineering | Degradation | Initial state, physical parameters, temperature profile |
| Dispatch | Degradation | Battery usage |
| Operational Engineering | Degradation | Degradation-relevant behavior declarations |
| Scenario Management | Degradation | Augmentation policy, replacement policy, EOL threshold, replacement cost assumption |

---

## 19. What Is Deliberately NOT Defined Here

### Mathematical Formulation
- Calendar aging equations
- Cycle aging equations
- Combined aging model
- Rainflow counting
- Numerical integration scheme
- Augmentation trigger equations
- Replacement trigger equations
- Marginal signal derivation equations

### Software Structure
- Classes, functions, APIs
- Data structures
- Storage representation
- Time indexing convention
- Interpolation strategy

### Numerical Methods
- Integration scheme
- Time step selection
- Numerical tolerance

### Data Contracts
- Parameter schemas
- Units convention
- Missing data handling

### Integration Details
- How usage is passed from Dispatch
- How state is passed to BESS Engineering
- How events are passed to Financial Engineering

### Financial Treatment
- Replacement cash flow computation
- Discounting
- NPV, IRR, payback

### Policy Definition
- Augmentation trigger definition
- Replacement trigger definition
- EOL threshold definition

These belong to Stage B, Stage C, Stage D, or to Scenario Management / Domain 6.

---

## 20. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.8 | §5 Domain 5, §6.2 Causal Backbone, §6.4 Operational signals vs. investment assumptions, §12.2 D3 | Yes |
| `SYS-ENG-DEF-001` v0.5 | §10 Domain 5, §11.5 Degradation cost double-counting rule, §13 Inter-Domain Contract | Yes |
| `A.2.1-BESS-ENG-001` v1.2 | §8 Interface with Degradation, §11 State Variables | Yes |
| `A.2.3-OPS-ENG-001` v1.3 | §14 Interface with Degradation | Yes |
| `A.2.4-DISPATCH-ENG-001` v0.7 | §5.4, §12 Degradation Feedback, §16 Modeling Traps | Yes |
| `PH1-REG-001` v1.0 | PH-015, PH-016, PH-017, PH-018, PH-038, PH-039, PH-043, PH-044, PH-045 | Yes |

---

## 21. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Working default |
|---|---|---|---|
| 1 | Degradation model structure | Stage B | Semi-empirical (PH-043) |
| 2 | Calibration data source | PH-015 / PH-043 | Vendor data if available; otherwise literature |
| 3 | Feedback frequency | PH-038 | Annual with representative-period simulation |
| 4 | Augmentation policy details | PH-044 | SOH-threshold-triggered |
| 5 | Replacement policy details | PH-045 | Reset to BOL |
| 6 | SOC window behavior under degradation | PH-017 | Proportional narrowing |
| 7 | Multi-cohort aggregation rule | PH-018 | Capacity-weighted SOH |
| 8 | Whether marginal signal enters dispatch objective | PH-032 / PH-039 | Depends on methodology |
| 9 | **Marginal signal formulation** | **Stage B / C** | **Derived from replacement/augmentation economics combined with degradation throughput/capability assumptions** |
| 10 | End-of-life threshold | PH-016 / PH-044 | Configurable; default TBD |
| 11 | Efficiency degradation representation | Stage B | Loss of round-trip efficiency over time |
| 12 | Rainflow counting | Stage C | Only if cycle aging requires it |
| 13 | Numerical integration scheme | Stage C | — |
| 14 | Validation tolerances | Stage C / PH-006 | — |

---

## 22. Next Steps

This document establishes the **conceptual engineering baseline** for Domain 5 — Degradation Engineering. It establishes the **conceptual contract for the Dispatch ↔ Degradation interface** and defines the three distinct concepts (physical degradation, marginal degradation cost, replacement cash flow) that must not collapse. The contract will be validated as the project advances to Stage B/C.

The Stage A.2 chapters:

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.2) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.3) |
| 3 | A.2.3 | Operational Engineering | ✅ Baselined (v1.3) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | ✅ Development Baseline (v0.7) |
| 5 | A.2.5 | Degradation Engineering | ✅ **This document — Development Baseline** |
| 6 | A.2.6 | Financial Engineering | ⏭ Next |
| 7 | A.2.7 | Data & Application Engineering | ⏭ Pending |

**Immediate next document:** `A.2.6 — Financial Engineering`, which consumes operational outputs, degradation events, and tariff bill outputs, and produces project-level economic performance.

---

## 23. ENGIE Clarification Requests Relevant to Degradation Engineering

The following clarification items are relevant to this domain. They are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001`), which is the authoritative consolidated list. This section lists only the items relevant to Degradation Engineering, by their **Register ID**.

| Register ID | Clarification / Data Request | Why Required |
|---|---|---|
| **PH-015** | **Battery data.** Are vendor degradation curves or warranty terms available for the reference technologies? | Anchors the degradation model |
| **PH-016** | **SOC bounds and warranty.** Are SOC bounds driven by warranty terms, operating policy, or both? | Affects available capacity and EOL threshold |
| **PH-017** | **SOC window behavior under degradation.** Proportional narrowing or preserved kWh reserves? | Affects usable energy in later years |
| **PH-018** | **Multi-cohort aggregation after augmentation.** How should SOH be aggregated when multiple cohorts coexist? | Affects post-augmentation representation |
| **PH-038** | **Degradation feedback time scale.** Frequency of SOH update during operational simulation? | Determines feedback loop architecture |
| **PH-039** | **Financial objective inside dispatch.** Should degradation cost enter the dispatch objective? | Determines whether the marginal signal is consumed |
| **PH-043** | **Degradation model fidelity.** Empirical, semi-empirical, or vendor-data-driven? | Determines model class |
| **PH-044** | **Augmentation policy.** Scheduled, SOH-threshold-triggered, or both? | Determines augmentation logic |
| **PH-045** | **Replacement policy.** Does replacement reset capacity to BOL? | Determines long-term capacity model |

**Note.** Items are assigned IDs in `PH1-REG-001`. The Register is the authoritative source; this section is a filtered view.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.5 — Conceptual Engineering (Degradation Engineering)
**Status:** Conceptual Engineering — **Development Baseline**
**Duration:** 12 Weeks
**Language:** English

---
