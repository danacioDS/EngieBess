# Operational Engineering
## Stage A.2.3 — Conceptual Engineering
### Value Stream Behavior of the BESS Operational & Financial Modeling System

**Document ID:** A.2.3-OPS-ENG-001

**Version:** 1.3 — Conceptual Engineering Baseline (Closed)

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.8)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.5)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.2)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)

**Domain:** Domain 3 — Operational Engineering

**Purpose:** Define, at a conceptual level, what the Operational Engineering domain represents, what value streams it defines, how each value stream uses the BESS, what it consumes from upstream domains, what it delivers to Dispatch, and what engineering decisions must be made in later stages — **without** deciding priorities, co-optimization, algorithms, or economic valuation.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.3 — Conceptual Engineering** of the Operational Engineering domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §1.1.

Its purpose is to establish the **conceptual engineering definition** of the **value streams** the BESS can serve — how the BESS can be used to provide specific services, given the physical capability declared by Domain 1 and the external environment declared by Domain 2.

It answers, at conceptual level:

- What value streams exist
- What each value stream is intended to achieve operationally
- How each value stream uses the BESS physically
- What each value stream requires from BESS Engineering and Load & Market Engineering
- What operational requirements each value stream imposes
- What service-level metrics each value stream produces
- How value streams interact
- What modeling traps each value stream contains
- What is **not** decided here (and who decides it)

It deliberately does **not** define:

- Priority among value streams
- Co-optimization logic
- Revenue stacking
- Optimization algorithms
- Dispatch decisions
- Economic valuation
- Software architecture
- Data schemas
- Python classes or APIs

Those belong to A.2.4 (Dispatch & Optimization), A.2.5 (Degradation), A.2.6 (Financial Engineering), and Stages B, C, D.

### 1.1 Position Within Stage A

This document refines **Domain 3** of `SYS-ENG-DEF-001` §7 from an eagle-eye definition into a conceptual engineering baseline.

It sits **between** A.2.1 (BESS physical capability), A.2.2 (external environment), and A.2.4 (dispatch and optimization).

### 1.2 The Most Important Boundary in This Document

> **Operational Engineering defines the operational requirements of each value stream. Dispatch decides which value streams to activate, when, and how to coordinate them.**

This boundary is the single most consequential discipline in Domain 3. Getting it right preserves the causal backbone and keeps A.2.4 tractable.

### 1.3 Relationship to Upstream Domains

| Domain | What it provides to Operational Engineering |
|---|---|
| **BESS Engineering (A.2.1)** | Physical capability: available power, available capacity, SOC, SOH, ramp, duration, reactive envelope |
| **Load & Market Engineering (A.2.2)** | External environment: load, price signals, program rules, tariff structure, regulation statistics, grid constraints |

Both are inputs. Operational Engineering combines them into **service behaviors and operational requirements**.

### 1.4 Generality Principle

This document defines **generic value streams** — parameterizable for different markets, programs, and configurations.

It does **not** hard-code:

- A specific market product (RegD, FFR, LMP, etc.)
- A specific DR program
- A specific tariff structure
- A specific configuration (standalone vs. co-located, BTM vs. FTM)
- A specific project size

Market-specific rules are handled by **market adapters** (`A.2.2-LOAD-MKT-ENG-001` §13).

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Operational Engineering domain** is the conceptual representation of the **value streams** the BESS can serve — the operational behaviors through which the BESS transforms its physical capability into services.

Each value stream is a distinct operational behavior with:

- A purpose
- An operational objective
- A physical requirement on the BESS
- A set of external conditions it responds to
- A set of operational requirements it imposes
- A set of service-level metrics it produces
- A declared interaction with other value streams

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| A dispatch model | Dispatch belongs to Domain 4 |
| A co-optimization model | Co-optimization belongs to Domain 4 |
| A revenue attribution model | Attribution belongs to Dispatch and Financial Engineering |
| A market product model | Market products belong to Domain 2 |
| A physical capability model | Physical capability belongs to Domain 1 |
| An economic valuation model | Valuation belongs to Domain 6 |
| A degradation model | Degradation belongs to Domain 5 |
| A software module | Software structure belongs to Stage B/C/D |

### 2.3 Primary Question

> **How can the BESS be used to provide each service — and what operational requirements does each service impose?**

### 2.4 Guiding Principle

> **This domain defines operational behavior — never priority, never coordination, never dispatch, never valuation.**

Any responsibility that would answer *"which value stream should be activated?"*, *"how should they be combined?"*, or *"what is each worth financially?"* belongs to another domain.

---

## 3. The Value Streams in Scope

The RFP explicitly requires modeling of the following value streams:

| # | Value Stream | Primary Application | Market / Program Dependency |
|---|---|---|---|
| 1 | **Peak Shaving** | Behind-the-meter | Primarily tariff-dependent |
| 2 | **Demand Response** | Behind-the-meter and front-of-meter | Program-dependent |
| 3 | **Energy Arbitrage** | Both | Market / tariff-dependent |
| 4 | **Frequency Regulation** | Front-of-meter and behind-the-meter | Market-dependent |
| 5 | **Voltage Regulation** | Both | Configuration / contract-dependent |

Additional value streams may be added later without restructuring this domain, provided they follow the same pattern: **purpose → operational objective → physical requirement → external condition → operational requirement → service metric → interaction**.

**Note on Market / Program Dependency.** The conceptual existence of a value stream does not depend on the market; its **implementation and value** do. Peak shaving, for example, always conceptually exists, but its economic realization depends on the tariff structure in force. This column declares that dependency rather than implying that a value stream is market-independent.

---

## 4. Common Conceptual Pattern for All Value Streams

Every value stream is defined conceptually through the same pattern:

```
      Value Stream
           │
           ├── Purpose
           │
           ├── Operational Objective
           │
           ├── Physical Requirements on BESS
           │
           ├── External Conditions Required
           │
           ├── Operational Requirements
           │
           ├── Service-Level Metrics
           │
           └── Interaction with Other Value Streams
```

This uniformity is deliberate. It ensures:

- Each value stream is treated consistently
- Dispatch can consume operational requirements uniformly
- New value streams can be added without ad-hoc structure
- Financial Engineering can attribute value per stream consistently

**Terminology refinement relative to `SYS-ENG-DEF-001` v0.5.** This document uses **operational requirements** in place of the term *candidate actions*, which appears in `SYS-ENG-DEF-001` v0.5 §7.4 and §12. Operational Engineering defines **what behavior must occur if the service is provided**, not **what action should be scheduled**. Scheduling is a Dispatch decision. The `SYS-ENG-DEF-001` terminology will be aligned in v0.6.

---

## 5. Value Stream 1 — Peak Shaving

### 5.1 Purpose

**Reduce the site's billed peak demand during the billing period.**

The economic value arises from demand charge reduction (`A.2.2-LOAD-MKT-ENG-001` §9), computed by the tariff engine. **This value stream does not compute that value** — it declares the operational requirements that enable it.

### 5.2 Operational Objective

Cap the site's net demand at or below a target threshold during the periods that determine the billed peak.

### 5.3 Physical Requirements on BESS

| Requirement | Meaning |
|---|---|
| Sustained discharge capability | Sufficient duration to cover the peak window |
| Sufficient power | Ability to reduce peak by the required magnitude |
| Sufficient energy | Ability to sustain discharge for the required duration |
| SOC headroom | Enough stored energy at the start of the peak period |

### 5.4 External Conditions Required

| Condition | Meaning |
|---|---|
| Load profile | Site demand as a function of time |
| Billing period definition | How peak demand is measured and billed (`A.2.2` §9.4) |
| Demand measurement interval | 15-min or hourly |
| **External tariff signal** | Demand charge rate structure ($/kW), provided to Dispatch as an external parameter |
| Peak windows | Time-of-day, day-of-week, seasonal patterns that shape the peak |
| Ratchet structure | If applicable — prior peaks that floor the billed demand |

### 5.5 Operational Requirements

| Requirement | Meaning |
|---|---|
| SOC floor | Discharge must not go below the minimum permitted SOC |
| Duration limit | Discharge duration constrained by available energy / power |
| Ramp limit | Discharge ramp constrained by BESS ramp capability |
| Rest requirement | Minimum rest periods after sustained discharge, if applicable |
| Availability | Only operable when declared available |

### 5.6 Service-Level Metrics

- Peak reduction achieved (kW)
- Duration of peak reduction (min)
- Energy discharged for peak shaving (kWh)
- Number of peak-shaving events per billing period
- Compliance with the target threshold

### 5.7 Modeling Traps

| Trap | Why It Matters |
|---|---|
| **Demand charges apply to the monthly maximum** | Value is not separable hour by hour; the billing-period dependency must be preserved in the dispatch formulation |
| **Ratchet effects** | A single missed peak can carry cost across many months; the reliability of peak reduction matters as much as its magnitude |
| **Coincident-peak charges** | Where tariffs or markets charge on system-wide peaks (4CP, 5CP), the peak hour may not be predictable; uncertainty treatment matters |
| **Demand measurement interval** | If billed demand is measured at 15-min intervals but dispatch runs hourly, the true peak may be understated |
| **Auxiliary consumption** | BESS auxiliary load adds to site load; it must be included in the net load seen by the tariff engine |

### 5.8 Boundary — What This Value Stream Does Not Decide

- When to discharge (Dispatch decides)
- How much to discharge (Dispatch decides)
- Whether to prioritize peak shaving over other value streams (Dispatch decides)
- What the savings are worth (Financial Engineering + tariff engine decide)
- How the billed peak is computed (tariff engine decides, `A.2.2` §9)

---

## 6. Value Stream 2 — Demand Response

### 6.1 Purpose

**Participate in demand response programs** by reducing site load or discharging the BESS during called events, in exchange for capacity or event-based payments.

### 6.2 Operational Objective

Deliver the committed demand reduction during a DR event, in compliance with the program's performance measurement rules.

### 6.3 Physical Requirements on BESS

| Requirement | Meaning |
|---|---|
| Minimum sustained discharge duration | Must cover the event duration (per program rules) |
| Sufficient power | Must deliver the committed capacity reduction |
| Sufficient energy | Must sustain discharge for the full event duration |
| SOC headroom | Enough stored energy at event start |
| Fast enough response | Must meet notification and ramp requirements |

### 6.4 External Conditions Required

| Condition | Meaning |
|---|---|
| DR program rules | Event windows, notification lead time, event duration, max calls per season |
| Baseline methodology | Provided by the program adapter (`A.2.2` §5.4) |
| Performance measurement method | Baseline vs. actual, per program rules |
| Penalty structure | Consequence of underperformance |
| **Program compensation signal** | Capacity or event-based payment structure, provided to Dispatch as an external parameter |

### 6.5 Operational Requirements

| Requirement | Meaning |
|---|---|
| Event duration floor | Discharge must be sustainable for the full event |
| Notification readiness | BESS must be ready to respond within the notification window |
| SOC reserve | Energy must be preserved for possible events |
| Rest requirements | Between successive events, if program rules require |
| Compliance constraints | Performance measurement may impose minimum delivery thresholds |

### 6.6 Service-Level Metrics

- Committed capacity (kW)
- Event energy delivered (kWh)
- Performance compliance (measured against program rules)
- Number of events participated per season

**Note.** DR revenue attribution is **not produced here**. It belongs to Dispatch (attribution by stream) and Financial Engineering (economic valuation).

### 6.7 Modeling Traps

| Trap | Why It Matters |
|---|---|
| **Events are not known in advance** | Perfect foresight is not available for DR; the dispatch model must account for event uncertainty through reserve-capacity or event-scenario treatment |
| **Performance measurement methodology** | Baseline vs. actual determines measured delivery; the adapter owns this |
| **Penalty for underperformance** | Underperformance may be penalized; the dispatch model must account for this |
| **Max calls per season** | The number of events may be capped; the dispatch model must account for this |
| **Notification lead time** | Short lead times constrain how the BESS can be committed elsewhere |
| **Baseline sensitivity** | The measured delivery depends on the baseline methodology, which is program-specific |

### 6.8 Boundary — What This Value Stream Does Not Decide

- When to reserve capacity for a possible event (Dispatch decides)
- Whether to commit to the event if called (Dispatch decides)
- How to prioritize DR against other value streams (Dispatch decides)
- What the DR payment is worth (Financial Engineering decides, using DR rules from Domain 2)
- Baseline methodology (adapter decides, `A.2.2` §5.4)

---

## 7. Value Stream 3 — Energy Arbitrage

### 7.1 Purpose

**Enable temporal shifting of electrical energy** between charging and discharging periods in response to price differentials.

### 7.2 Operational Objective

Charge when prices are low and discharge when prices are high, subject to BESS operating constraints. The economic objective — what to maximize, how to trade off degradation, how to handle competing value streams — is a **Dispatch decision**.

### 7.3 Physical Requirements on BESS

| Requirement | Meaning |
|---|---|
| Full-cycle capability | Ability to charge and discharge within SOC bounds |
| Round-trip efficiency | Determines net energy delivered per cycle |
| C-rate capability | Determines how fast the cycle can be executed |
| Sufficient energy | Determines how much can be shifted per cycle |

### 7.4 External Conditions Required

| Condition | Meaning |
|---|---|
| Energy price signal | Hourly or sub-hourly price curve (LMP or TOU) |
| **Price differential** | The external economic signal that may motivate charging or discharging behavior |

### 7.5 Operational Requirements

| Requirement | Meaning |
|---|---|
| SOC bounds | Enforced throughout the cycle |
| **Energy conversion losses must be represented** | Round-trip efficiency is a physical reality; the operational behavior must account for it |
| Ramp limits | Constrain the speed of transition |
| Degradation-relevant behavior | Cycling behavior that generates degradation-relevant usage (see §14) |

### 7.6 Service-Level Metrics

- Energy shifted (kWh)
- Gross charge energy (kWh)
- Gross discharge energy (kWh)
- Net energy after efficiency losses (kWh)
- Number of equivalent full cycles executed

### 7.7 Modeling Traps

| Trap | Why It Matters |
|---|---|
| **Perfect foresight vs. forecast-based dispatch** | The two modes produce different results and should be explicitly distinguished. Perfect foresight may produce higher apparent value than a forecast-based approach |
| **Efficiency losses** | Round-trip efficiency reduces net energy; must be represented |
| **Marginal degradation cost** | If arbitrage is optimized without accounting for degradation, the battery may be over-cycled. Whether and how this enters the objective is a Dispatch decision |
| **Price signal resolution** | Coarse price resolution may miss short-duration spreads |

### 7.8 Boundary — What This Value Stream Does Not Decide

- Which hours to charge or discharge (Dispatch decides)
- How much to cycle (Dispatch decides)
- Whether to prioritize arbitrage over other value streams (Dispatch decides)
- What the arbitrage revenue is worth (Financial Engineering decides)
- Whether perfect foresight or forecast-based dispatch applies (Phase 1 **PH-033**)
- Whether to introduce a minimum spread threshold (Dispatch decides)
- Whether to include marginal degradation cost in the objective (Dispatch decides)

---

## 8. Value Stream 4 — Frequency Regulation

### 8.1 Purpose

**Provide fast-response power injection and absorption** to support grid frequency stability, in exchange for capacity and/or mileage-based compensation.

### 8.2 Operational Objective

Reserve capacity for regulation service, deliver the required response when dispatched, and **account for** SOC drift resulting from the regulation signal.

### 8.3 Physical Requirements on BESS

| Requirement | Meaning |
|---|---|
| Fast ramp capability | Ability to respond quickly to regulation signal |
| Symmetric or asymmetric response | Depending on the market product |
| SOC headroom | Enough energy in both directions |
| Availability | Must be available for the service window |

### 8.4 External Conditions Required

| Condition | Meaning |
|---|---|
| **Ancillary-service price signal** | Capacity and/or mileage-based price |
| Product type | RegD, FFR, RegA, or equivalent |
| **Statistical signal characteristics** | Energy per MW, signal bias, expected performance score (see `A.2.2` §8.3) |
| Performance measurement rules | Mileage-based or equivalent |

### 8.5 Operational Requirements

| Requirement | Meaning |
|---|---|
| Capacity reservation | Power reserved for regulation is not available for other services |
| SOC drift representation | Regulation signal is not perfectly symmetric; SOC drift must be representable |
| Response time | Must meet market response requirements |
| Performance scoring | Actual delivery affects compensation |
| Degradation-relevant behavior | Regulation causes cycling that generates degradation-relevant usage (see §14) |

### 8.6 Service-Level Metrics

- Regulation capacity offered (MW)
- Regulation capacity reserved (MW)
- **Energy throughput associated with regulation service**, using the methodology defined in later engineering stages
- SOC drift associated with regulation service
- Expected performance score
- Number of equivalent full cycles attributable to regulation

### 8.7 Modeling Traps

| Trap | Why It Matters |
|---|---|
| **A 15-min or hourly model cannot follow a regulation signal** | The signal is sub-second; the platform must account for the operational consequences of high-frequency regulation even when the main simulation operates at a coarser temporal resolution |
| **Signal bias** | The signal is not symmetric; it causes net SOC drift |
| **Performance scoring** | Actual delivery affects compensation; must be represented |
| **Degradation impact** | Regulation may accelerate cycling; the marginal degradation cost from Domain 5 may be considered by Dispatch |
| **Opportunity cost of reservation** | Reserved capacity is not available for other value streams |
| **Regulation charging may create or worsen the billed peak** | In behind-the-meter configurations, charging the battery to follow the regulation signal adds to site load and may set a new monthly peak or trigger a ratchet. See §10.2 |

**Methodological note.** The specific aggregation, statistical representation, and SOC-impact methodology for frequency regulation are **deferred to Stage B/C** and depend on target-market requirements. This document declares the requirement — that the operational consequences of high-frequency regulation must be representable — not the method by which they are represented.

### 8.8 Boundary — What This Value Stream Does Not Decide

- How much capacity to reserve (Dispatch decides)
- When to reserve (Dispatch decides)
- Whether regulation is prioritized over other services (Dispatch decides)
- What regulation revenue is worth (Dispatch attribution + Financial Engineering decide)
- How the regulation signal is statistically characterized (Domain 2 provides the statistics; the adapter supplies them per `A.2.2` §8.3)
- The aggregation methodology (Stage B/C)

---

## 9. Value Stream 5 — Voltage Regulation

### 9.1 Purpose

**Provide reactive power support** to maintain local voltage within acceptable bands.

### 9.2 Operational Objective

Deliver reactive power (VAR) support within the inverter's capability, respecting the coupling between active and reactive power.

### 9.3 Physical Requirements on BESS

| Requirement | Meaning |
|---|---|
| Inverter reactive capability | The apparent-power envelope (from Domain 1, `A.2.1` §6.4) |
| Four-quadrant operation | Ability to inject or absorb reactive power |
| Power factor range | Defined by inverter specification |

### 9.4 External Conditions Required

| Condition | Meaning |
|---|---|
| Voltage setpoint or droop curve | Where the service is required |
| Power factor requirements | If mandated by contract or grid code |
| **Power factor penalties / kVAR charges** | Where BTM tariffs include penalties for poor power factor or charges per kVAR — often the main monetizable value of voltage regulation in BTM applications. See `A.2.2` §9.4 element 11 |
| **Voltage-support compensation signal** | Where the service is compensated (often not in BTM applications) |

### 9.5 Operational Requirements

| Requirement | Meaning |
|---|---|
| **Apparent-power coupling** | Active and reactive power share the inverter apparent-power envelope: P² + Q² ≤ S² |
| Voltage compliance | Must maintain voltage within bands |
| **Reactive range** | The range of reactive power support the BESS is required to deliver |

**Note on P² + Q² ≤ S².** Under default **D4** (`SYS-STR-FRM-001` §12.2 / **PH-041**), the initial scope represents the inverter envelope as a **fixed envelope**, without linearization of the nonlinear coupling. Linearizing the coupling is a **possible extension** if the target market and project configuration require it. This document declares the coupling as a physical fact; the choice of treatment is a Phase 1 / Stage B decision.

**Note on priority.** The **coupling** between active and reactive power is a physical fact and is declared here. The **priority** — whether reactive curtails active or vice versa when the envelope binds — is a **Dispatch decision** and is not declared in this document.

### 9.6 Service-Level Metrics

- Reactive energy provided (kVARh)
- Voltage compliance (%)
- **Active power curtailment associated with voltage-support operation**, if applicable
- **Power factor compliance** (where penalties or charges apply)
- Number of voltage-support events

### 9.7 Modeling Traps

| Trap | Why It Matters |
|---|---|
| **P² + Q² ≤ S² is nonlinear** | If the optimization uses LP/MILP, the constraint must be linearized — this is an **extension under PH-041**, not in the initial scope |
| **Reactive vs. active priority** | Whether reactive curtails active determines whether the BESS can serve other value streams simultaneously — this is a Dispatch decision |
| **Often uncompensated in BTM applications** | Value may be compliance-based or penalty-avoidance-based rather than revenue-based |
| **Coupling with the inverter envelope from Domain 1** | Reactive power capability is not independent of active power |

### 9.8 Boundary — What This Value Stream Does Not Decide

- How much reactive power to provide (Dispatch decides)
- Whether reactive takes priority over active (Dispatch decides)
- Whether to curtail active power (Dispatch decides)
- What the service is worth (Financial Engineering decides, where compensated or where it avoids penalties)
- Whether to linearize the P² + Q² ≤ S² coupling (Phase 1 / Stage B, **PH-041**)

---

## 10. Interaction Between Value Streams

Value streams **interact**, and Operational Engineering must declare the **nature** of those interactions without resolving them.

### 10.1 Shared Physical Resources

All value streams compete for the same physical resources:

- **Power** — reserved capacity is not available elsewhere
- **Energy** — discharged energy must be recharged
- **SOC headroom** — headroom for one stream reduces headroom for another
- **Ramp capability** — fast transitions consume ramp budget
- **Availability and operating capability** — may constrain simultaneous service provision
- **Inverter apparent-power envelope** — active and reactive power share the same envelope

### 10.2 Conceptual Interactions

| Value Stream Pair | Nature of Interaction |
|---|---|
| Peak Shaving × Arbitrage | Both discharge; they may coincide or conflict |
| Peak Shaving × Frequency Regulation | Reserved regulation capacity reduces available peak-shaving power. **Additionally, in behind-the-meter configurations, charging the battery to follow the regulation signal adds to site load and may set a new monthly peak or trigger a ratchet, potentially destroying the peak-shaving value for the month** |
| Demand Response × Arbitrage | DR event discharge may conflict with optimal arbitrage cycles |
| Demand Response × Frequency Regulation | Both reserve capacity; they compete for the same SOC headroom |
| Arbitrage × Frequency Regulation | Regulation cycling and arbitrage cycling both consume throughput and generate degradation-relevant usage |
| Voltage Regulation × All Others | Reactive support uses the inverter envelope; when it binds, active power may be curtailed |
| All Streams × Peak Shaving (BTM) | **Any charging operation — from arbitrage, regulation, or SOC recovery — raises the net site load and may create or worsen the billed peak in behind-the-meter configurations** |

**Note on the peak-shaving interaction.** Peak shaving is uniquely sensitive to the operations of every other value stream, because the billed peak depends on the **maximum** net site load over the billing period, not on the average. Any charging action by any other stream — including SOC recovery after regulation or DR events — can raise the peak. This is the most consequential cross-stream interaction in behind-the-meter applications and must be handled by Dispatch.

### 10.3 What Operational Engineering Declares

- **That** interactions exist
- **Which** resources are shared
- **What** each value stream requires and produces

### 10.4 What Operational Engineering Does Not Declare

- Which value stream wins
- How conflicts are resolved
- How resources are allocated
- How value streams are combined

Those are **Dispatch decisions**, formalized in A.2.4.

---

## 11. Interface with BESS Engineering (Conceptual)

### 11.1 What This Domain Consumes from BESS Engineering

| From BESS Engineering | Used For |
|---|---|
| Available charge/discharge power | Feasibility of discharge/charge requirements |
| Available capacity | Energy budget per value stream |
| SOC and SOC bounds | Constraint on all operational requirements |
| Ramp limits | Constraint on response speed |
| Duration | Feasibility of minimum-duration requirements (DR) |
| Reactive power capability | Feasibility of voltage regulation |
| Availability | Whether a value stream can be served at all |

### 11.2 What This Domain Does Not Consume from BESS Engineering

- Dispatch decisions (those come from Domain 4)
- SOH evolution (that belongs to Degradation Engineering)

### 11.3 Boundary Discipline

BESS Engineering declares **what is physically possible**. Operational Engineering declares **what each value stream requires**. Dispatch **reconciles them**.

---

## 12. Interface with Load & Market Engineering (Conceptual)

### 12.1 What This Domain Consumes from Load & Market Engineering

| From Load & Market | Used For |
|---|---|
| Load / projected load | Peak shaving and DR |
| **Energy price signals** | Arbitrage |
| **Ancillary-service price signals** | Frequency regulation |
| **Program compensation signals** | Demand response |
| **Voltage-support compensation signals** | Voltage regulation (where applicable) |
| **Power factor penalty / kVAR charge structure** | Voltage regulation (BTM) |
| TOU tariff structure | Peak shaving and arbitrage |
| DR program rules | DR feasibility |
| Baseline methodology (via adapter) | DR performance |
| Grid constraints | Feasibility of all value streams |
| Eligibility | Whether a value stream is available |
| Frequency regulation statistics | Coarse-resolution regulation modeling |

### 12.2 Boundary Discipline

Load & Market declares **what the environment is**. Operational Engineering declares **how each value stream uses the BESS within that environment**. Dispatch **selects and coordinates**.

---

## 13. Interface with Dispatch & Optimization (Conceptual)

### 13.1 What This Domain Delivers to Dispatch

For each value stream, Operational Engineering delivers:

| Delivered to Dispatch | Nature |
|---|---|
| Operational requirements | SOC floors, duration floors, reserve requirements, ramp requirements |
| Service requirements | Minimum duration, ramp, response time |
| Service-level metrics | What each service is expected to deliver |
| Interaction declarations | Which resources are shared, which value streams compete |
| Degradation-relevant behavior declarations | Which behaviors generate degradation-relevant usage |

**Note.** Operational Engineering does not deliver "actions" — it delivers the **requirements** that any dispatch decision must satisfy if the service is provided. Dispatch decides which services to provide and how.

### 13.2 What Dispatch Delivers Back

Dispatch returns:

- Which value streams are active and how capacity is allocated among them
- The resulting dispatch schedule
- Attribution of operational behavior to value streams

### 13.3 Boundary Discipline

Operational Engineering declares **operational requirements**. Dispatch selects **the actual behavior**.

This is the single most important boundary in the domain.

---

## 14. Interface with Degradation Engineering (Conceptual)

### 14.1 What This Domain Declares

Operational Engineering **does not consume degradation cost**. It declares **which operational behaviors generate degradation-relevant usage**.

| Value Stream | Degradation-Relevant Behavior |
|---|---|
| Peak Shaving | Moderate throughput; potentially high-rate discharge |
| Demand Response | Event-driven cycling; may impose deep discharges |
| Energy Arbitrage | Cycling behavior; throughput and cycle depth |
| Frequency Regulation | Potentially high-frequency cycling and throughput, depending on the regulation product and signal characteristics |
| Voltage Regulation | Low throughput; primarily reactive — minimal cycling |

### 14.2 What This Declaration Enables

Degradation Engineering can compute **degradation resulting from these behaviors** (throughput, depth of discharge, C-rate, cycling). It does not receive the degradation cost from Operational Engineering.

The relationship is:

```
Operational Engineering
    │ declares: what behavior occurs
    ▼
BESS Engineering
    │ provides: physical state and usage
    ▼
Degradation Engineering
    │ computes: degradation consequences
    ▼
Dispatch
    │ decides: whether to incorporate degradation consequences into dispatch
```

### 14.3 What This Domain Does Not Declare

- The **magnitude** of degradation caused by a behavior
- The **marginal degradation cost** of a behavior
- Whether degradation consequences are included in dispatch
- How degradation is valued

Those belong to A.2.5, A.2.4, and A.2.6 respectively.

---

## 15. Interface with Financial Engineering (Conceptual)

### 15.1 Attribution Across Two Sources of Truth

Attribution of value to value streams draws on **two sources of truth**, per `SYS-ENG-DEF-001` §10.4:

| Source of truth | What it produces | What it is attributed to |
|---|---|---|
| **Dispatch attribution** (Domain 4) | Market revenues: LMP arbitrage, frequency regulation, DR payments, capacity payments | Market value streams, per Dispatch attribution |
| **Tariff engine** (Domain 2, `A.2.2` §9.8) | Behind-the-meter savings by **component of the bill**: demand charge savings, energy charge savings, export credits, power factor / kVAR savings | Behind-the-meter value streams, per mapping convention below |

### 15.2 Mapping Convention for Behind-the-Meter Savings

The RFP requires revenue by stream. The tariff engine produces savings **by billing component**, not by value stream. A mapping convention is therefore required:

| Billing component | Attributed to value stream |
|---|---|
| Demand charge savings | **Peak Shaving** |
| Energy charge savings (BTM TOU shifting) | **Energy Arbitrage (BTM)** |
| Export credits | **Energy Arbitrage (BTM)** |
| Power factor penalty avoidance / kVAR charge savings | **Voltage Regulation (BTM)** |

**This is a reporting convention, not an exact physical mapping.** Discharging during peak periods both reduces demand charges and reduces energy charges; the tariff engine computes both components, and they are attributed to different streams. The convention is declared explicitly so that reporting is consistent and auditable. Alternative conventions can be configured if ENGIE prefers.

### 15.3 Boundary Discipline

Financial Engineering consumes:

- **Dispatch results attributed by stream** — for market value streams
- **Tariff engine bill outputs, mapped by convention** — for behind-the-meter value streams

Operational Engineering does not perform attribution. It provides the **definitions** (value stream identity, service-level metrics) that make attribution possible.

---

## 16. Assumptions and Engineering Uncertainties

### 16.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | Value streams are independent in definition but interactive in execution | Enables modular definition while preserving interaction awareness | Would require joint modeling of value streams |
| 2 | Operational requirements are declared uniformly across value streams | Enables uniform consumption by Dispatch | Would require per-stream dispatch interfaces |
| 3 | Value streams share physical resources | Matches physical reality | Would require explicit resource partitioning |
| 4 | **Frequency regulation must be representable within the platform even when the main simulation operates at a coarser time resolution; the specific representation method is deferred** | Preserves option to select method in Stage B/C | Would prematurely commit to a methodology |
| 5 | **The economic treatment of voltage regulation depends on project configuration, contractual arrangements, and market scope** | Matches diversity of BESS deployments | Would require per-configuration assumptions |
| 6 | Operational Engineering does not consume or declare degradation cost | Preserves separation with A.2.5 and A.2.4 | Would blur domain responsibility |
| 7 | **Behind-the-meter savings are attributed to value streams by the mapping convention of §15.2** | Provides a consistent reporting basis | Alternative conventions may be preferred by ENGIE |

### 16.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Reactive power priority vs. active power | **A.2.4** |
| 2 | Whether value streams are co-optimized or run independently | **A.2.4** |
| 3 | Treatment of DR event uncertainty (reserve vs. scenario) | **A.2.4** |
| 4 | Frequency regulation statistical characteristics | **A.2.2** §8.3 (adapter supplies) |
| 5 | Frequency regulation aggregation methodology | **Stage B/C** |
| 6 | Whether voltage regulation is compensated | **PH-001** / **PH-002** |
| 7 | Whether the P² + Q² ≤ S² coupling is linearized | Phase 1 / **PH-041** |
| 8 | Whether behind-the-meter savings mapping convention is accepted by ENGIE | Phase 1 (**PH-055**) |

### 16.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `PH1-REG-001` v1.1:

- **PH-001** — Target market(s)
- **PH-002** — Behind-the-meter vs. front-of-the-meter scope
- **PH-033** — Perfect foresight vs. forecast-based dispatch
- **PH-034** — Dispatch methodology (affects how operational requirements are consumed)
- **PH-041** — Voltage regulation coupling
- **PH-055** — Presentation of value (mapping convention)

**Note.** PH IDs are assigned in `PH1-REG-001` v1.1, the authoritative consolidated Register.

---

## 17. Conceptual Outputs of the Domain

The domain exposes the following **conceptual outputs** to Dispatch:

| Output | Nature |
|---|---|
| Operational requirements per value stream | SOC floors, duration floors, reserve requirements, ramp requirements |
| Service requirements per value stream | Duration, ramp, response time |
| Service-level metrics per value stream | What each service is expected to deliver |
| Interaction declarations | Which resources are shared across streams |
| Degradation-relevant behavior declarations | Which behaviors generate degradation-relevant usage |

---

## 18. Validation Requirements (Conceptual)

### 18.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Value stream completeness | All in-scope value streams are defined |
| Physical feasibility | Each value stream's requirements are satisfiable given BESS capability |
| External dependency completeness | Each value stream declares all external signals it requires |
| Requirement consistency | Declared requirements are mutually consistent per value stream |
| Interaction declaration completeness | All shared-resource interactions are declared |

### 18.2 Interface Validation

| Check | Nature |
|---|---|
| Uniform requirement proposal | Dispatch can consume operational requirements uniformly |
| Attribution eligibility | Every value stream is attributable — either via Dispatch attribution or via the tariff engine mapping convention |
| Regulation statistical consistency | Declared regulation characteristics match what Dispatch consumes |

### 18.3 Validation Evidence

Validation evidence must be **produced before results are accepted**.

---

## 19. Boundaries — Explicit

### 19.1 Answers

- What value streams exist?
- What is each value stream's purpose and operational objective?
- How does each value stream use the BESS physically?
- What does each value stream require from BESS Engineering?
- What does each value stream require from Load & Market Engineering?
- What operational requirements does each value stream impose?
- What service-level metrics does each value stream produce?
- What modeling traps does each value stream contain?
- How do value streams interact?

### 19.2 Does Not Answer

- Which value stream should be activated?
- How should value streams be prioritized?
- How should conflicts between value streams be resolved?
- How should resources be allocated across value streams?
- What optimization method should be used?
- How much degradation does each value stream cause?
- What is the marginal degradation cost of a behavior?
- What is the revenue per value stream?
- What is the project's financial value?

Each of these belongs to A.2.4, A.2.5, A.2.6, or Stage B/C/D.

### 19.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| Operational Engineering | Dispatch | Operational requirements, service requirements, metrics, interaction declarations |
| BESS Engineering | Operational Engineering | Physical capabilities and constraints |
| Load & Market | Operational Engineering | External conditions, price signals, program rules, eligibility |

---

## 20. What Is Deliberately NOT Defined Here

### Dispatch and Optimization
- Priority among value streams
- Co-optimization logic
- Revenue stacking
- Optimization formulation
- Solver selection
- Minimum spread threshold for arbitrage
- Reactive vs. active power priority

### Economic Valuation
- Revenue per value stream
- Marginal degradation cost
- Financial KPIs
- Mapping convention approval

### Degradation
- Magnitude of degradation per behavior
- Degradation model
- Marginal degradation cost

### Software Structure
- Classes, functions, APIs
- Data structures
- Storage representation

### Numerical Methods
- Time resolution
- Interpolation
- Statistical characterization of regulation
- Linearization of P² + Q² ≤ S²

### Integration Details
- How operational requirements are passed to Dispatch
- How attribution is computed

### Market-Specific Rules
- RegD settlement
- FFR settlement
- DR program rules

These belong to Stages A.2.4, A.2.5, A.2.6, B, C, D, or to market adapters.

---

## 21. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.8 | §5 Domain 3, §6.2 Causal Backbone, §8.2 Validation, §12.1/12.2 Phase 1 items | Yes |
| `SYS-ENG-DEF-001` v0.5 | §7 Domain 3, §4.1 Cross-cutting capabilities, §10.4 Single source of truth, §12 Inter-Domain Contract | Yes |
| `A.2.1-BESS-ENG-001` v1.2 | Physical capability interface, reactive power responsibility split | Yes |
| `A.2.2-LOAD-MKT-ENG-001` v1.3 | External environment, regulation statistics, tariff engine, tariff element 11 (power factor penalties) | Yes |
| `PH1-REG-001` v1.1 | PH-001, PH-002, PH-033, PH-034, PH-041, PH-055 | Yes |
| RFP-264144-1 | Peak Shaving, Demand Response, Energy Arbitrage, Frequency Regulation, Voltage Regulation | Yes |

---

## 22. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Rationale |
|---|---|---|---|
| 1 | Priority among value streams | A.2.4 | Dispatch decision |
| 2 | Co-optimization logic | A.2.4 | Dispatch decision |
| 3 | Revenue stacking | A.2.4 | Dispatch decision |
| 4 | Optimization formulation | A.2.4 / B | Architecture decision |
| 5 | Solver selection | B / C | Detailed engineering |
| 6 | Reactive power priority vs. active power | A.2.4 | Dispatch decision |
| 7 | DR event uncertainty treatment | A.2.4 | Dispatch decision |
| 8 | Minimum spread threshold for arbitrage | A.2.4 | Dispatch decision |
| 9 | Frequency regulation statistical characteristics | A.2.2 / adapter | External signal |
| 10 | Frequency regulation aggregation methodology | B / C | Methodological decision |
| 11 | Time resolution for each value stream | B / **PH-054** | Architecture decision |
| 12 | Whether voltage regulation is compensated | **PH-001** / **PH-002** | Scope decision |
| 13 | Attribution mechanism | A.2.4 | Dispatch decision |
| 14 | Whether degradation consequences enter dispatch | A.2.4 | Dispatch decision |
| 15 | Validation tolerances | C / **PH-006** | Detailed engineering |
| 16 | Whether P² + Q² ≤ S² is linearized | Phase 1 / **PH-041** | Scope decision |
| 17 | Behind-the-meter savings mapping convention approval | Phase 1 (**PH-055**) | Reporting convention |

---

## 23. Next Steps

This document establishes the **conceptual engineering baseline** for Domain 3 — Operational Engineering.

**Stage A.2 status:**

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.2) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.3) |
| 3 | A.2.3 | Operational Engineering | ✅ **This document** — Baselined (v1.3) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | 🔄 Development Draft (v0.8) |
| 5 | A.2.5 | Degradation Engineering | 🔄 Development Baseline (v0.2) |
| 6 | A.2.6 | Financial Engineering | 🔄 Development Draft (v0.2) |
| 7 | A.2.7 | Data & Application Engineering | 🔄 Development Draft (v0.2) |

**Development strategy note.** To unblock the week-4 thin slice, A.2.4 is developed next even though A.2.5 is logically downstream. A.2.5 follows immediately after, since the thin slice also requires the degradation feedback loop. This is a development sequencing choice, not a change to the domain dependency order.

**Next:** Stage A consolidation and audit before Stage B (HLD).

Phase 1 clarification items are organized in `PH1-REG-001` v1.1, the authoritative consolidated Register. This domain's dependencies are listed in §16.3.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.3 — Conceptual Engineering (Operational Engineering)
**Status:** Conceptual Engineering Baseline — **CLOSED**
**Duration:** 12 Weeks
**Language:** English

---

## Addendum: ENGIE Clarification Requests Relevant to Operational Engineering

The following clarification items are relevant to this domain. They are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1), which is the authoritative consolidated list. This section lists only the items relevant to Operational Engineering, by their **Register ID**.

| Register ID | Clarification / Data Request | Why Required |
|---|---|---|
| **PH-001** | **Target market(s).** Which markets and geographies must the first version consider? | Determines which market adapters and rules are developed |
| **PH-002** | **BTM vs. FTM scope.** Is the initial delivery expected to support both behind-the-meter (BTM) and front-of-the-meter (FTM) configurations, or is one the priority? | Determines which value streams and constraints apply |
| **PH-033** | **Perfect foresight vs. forecast-based dispatch.** Which dispatch mode should be the default? | Affects how arbitrage and regulation are modeled |
| **PH-034** | **Dispatch methodology.** Rule-based heuristic, LP, MILP, or hybrid? | Affects how operational requirements are consumed |
| **PH-041** | **Voltage regulation coupling.** Should the P² + Q² ≤ S² coupling be linearized, or represented as a fixed envelope? | Determines the dispatch formulation for voltage regulation |
| **PH-055** | **Presentation of value.** Does ENGIE accept the mapping convention proposed in §15.2 for attributing behind-the-meter savings to value streams? | Determines the reporting convention for "revenue by stream" |

### Additional clarification items from the domain

| Topic | Clarification | Why Required |
|---|---|---|
| DR settlement | Which DR programs in scope are settled as bill credits, and which as independent payments? | Avoids double counting between bill savings and DR revenue |
| DR baseline | Should the DR baseline be computed by the platform or supplied as an input by the program/market adapter? | Determines where the baseline methodology is implemented |
| DR event uncertainty | Should DR events be modeled as known events within a scenario, as probabilistic events, or via a configurable operational reserve? | Determines the dispatch representation of DR |
| DA/RT price data | Will ENGIE provide historical/forecast day-ahead and real-time price data, or should the platform generate price scenarios? | Determines the source of price signals |
| Price-taker assumption | Should the price-taker assumption be maintained for all study cases, or should ENGIE scenarios reflect the impact of higher BESS penetration on prices? | Affects the validity of the price-taker assumption |
| Ancillary-service saturation | Does ENGIE have ancillary price projections that already reflect storage growth and possible market saturation? | Affects the realism of ancillary revenue estimates |
| Regulation signal data | Does ENGIE have historical regulation signals for the target markets? | Enables data-driven statistical characterization |
| Regulation assumptions (if signals unavailable) | Does ENGIE have internal assumptions for throughput per MW of regulation capacity, signal bias, mileage, performance score, and SOC drift? | Provides the external statistics required by `A.2.2` §8.3 |
| Regulation temporal resolution | What is the minimum temporal resolution ENGIE expects for representing frequency regulation? | Affects the modeling approach in Stage B/C |
| Voltage regulation scope | Should voltage regulation be modeled primarily as a compensated service, as a grid-compliance requirement, or as both depending on the project? | Determines the economic treatment of voltage regulation |
| P/Q priority rule | When the inverter's apparent-power limit binds simultaneously for active and reactive power, is there a priority rule defined by ENGIE, by the market, or by the grid code? | Determines the dispatch priority rule |
| Reference projects / benchmark cases | Can ENGIE provide one or more reference cases with expected results to validate load forecasting, dispatch, revenue stacking, degradation, and financial outputs? | Enables validation against ground truth |
| Acceptance tolerances | What tolerances does ENGIE consider acceptable for validating the main model outputs (energy balance, SOC, dispatch, revenue, degradation, NPV/IRR)? | Defines the acceptance thresholds |
| Historical backtesting | Does ENGIE expect the model to be validated by backtesting against known projects or historical periods? | Determines the validation approach |
| Power factor and reactive charges | Do the customer tariffs in scope include power factor penalties or kVAR charges? | Determines the monetizable value of voltage regulation in BTM projects |
| BTM savings mapping convention | Does ENGIE accept the mapping convention proposed in §15.2 for attributing behind-the-meter savings to value streams? | Determines the reporting convention for "revenue by stream" |

**Note.** Items are assigned IDs in `PH1-REG-001`. The Register is the authoritative source; this section is a filtered view.

---