
---

# BESS Engineering
## Stage A.2.1 — Conceptual Engineering
### Physical Foundation of the BESS Operational & Financial Modeling System

**Document ID:** A.2.1-BESS-ENG-001

**Version:** 1.1 — Conceptual Engineering Baseline (Closed)

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.6)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.4)

**Domain:** Domain 1 — BESS Engineering

**Purpose:** Define, at a conceptual level, what the BESS Engineering domain represents, what it must produce, what it consumes, how it interacts with the other six domains, and what engineering decisions must be made in later stages — **without** entering into equations, data schemas, class structures, or software architecture.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.1 — Conceptual Engineering** of the BESS Engineering domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §1.1.

Its purpose is to establish the **conceptual engineering definition** of the physical BESS representation that underpins the entire BESS Operational & Financial Modeling System.

It answers, at conceptual level:

- What is being modeled physically
- What physical behaviors must be representable
- What physical constraints must be enforceable
- What state the domain maintains over time
- What it exposes to other domains
- What it does **not** decide (and who decides it)

It deliberately does **not** define:

- Equations of state
- Degradation equations
- Dispatch logic
- Optimization formulation
- Software architecture
- Data schemas
- Python classes or APIs

Those belong to Stages B, C, and D.

### 1.1 Position Within Stage A

Stage A is delivered in two levels:

| Level | Name | Deliverable |
|---|---|---|
| A.1 | System Component Definition | `SYS-ENG-DEF-001` — eagle-eye view of the seven domains |
| A.2 | Conceptual Engineering per Domain | Seven domain chapters |

Per `SYS-STR-FRM-001` §4.3, the A.2 chapters may be consolidated into a single document. This chapter refines **Domain 1** of `SYS-ENG-DEF-001` §5 into a conceptual engineering baseline.

### 1.2 Scope Boundary of A.2.1

This document defines **what BESS Engineering must be able to represent**.

It does **not** define how BESS Engineering will be implemented, nor how its outputs will be consumed algorithmically by Dispatch, Degradation, or Financial Engineering. Those interfaces are declared conceptually here and formalized in Stage B.

### 1.3 Generality Principle

This document defines a **generic BESS physical model** — one that can be parameterized for different BESS projects, configurations, vendors, and markets.

It does **not** hard-code:

- A specific vendor
- A specific market or jurisdiction
- A specific configuration (standalone vs. co-located, behind-the-meter vs. front-of-the-meter)
- A specific project size

This generality is a deliberate design choice consistent with the System Strategy and with the diversity of the BESS portfolio the platform is intended to evaluate.

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **BESS Engineering domain** is the conceptual representation of the **physical battery energy storage system** — its energy capacity, power capability, efficiency, internal state, physical limits, and physical availability.

It is the **physical foundation** of the entire modeling system. Every other domain either constrains, exploits, degrades, values, or delivers what this domain represents.

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| An economic model | Economic decisions belong to Operational, Dispatch, and Financial Engineering |
| A dispatch model | Dispatch belongs to Domain 4 |
| A degradation model | Degradation belongs to Domain 5 (though it consumes BESS state) |
| A market model | Market belongs to Domain 2 |
| A software component | Software structure belongs to Stage B/C/D |
| A datasheet | It is a conceptual capability model, not a vendor specification |

### 2.3 Primary Question

> **What physical system are we modeling, and what can it physically do?**

### 2.4 Guiding Principle

> **The BESS domain defines capability and constraint — never decision and never value.**

Any responsibility that would answer *"what should the battery do?"* or *"what is that worth?"* belongs to another domain.

---

## 3. Engineering Scope

The domain must conceptually represent the following physical aspects of a BESS:

| # | Aspect | Description |
|---|---|---|
| 1 | Energy capacity | Nominal, available, and usable energy |
| 2 | Power capability | Charge and discharge power rating, and available power at a given moment |
| 3 | State of Charge (SOC) | Current stored energy as a fraction of available capacity |
| 4 | State of Health (SOH) | Remaining capability relative to beginning-of-life |
| 5 | Round-trip efficiency | Energy losses across a full charge/discharge cycle |
| 6 | Conversion efficiency | AC↔DC and internal conversion losses |
| 7 | C-rate | Charge/discharge rate relative to energy capacity |
| 8 | Ramp rate | Maximum rate of change of power |
| 9 | Operating limits | SOC bounds, power bounds, ramp bounds, C-rate bounds |
| 10 | Inverter capability | AC/DC conversion, apparent power rating, reactive power envelope |
| 11 | Thermal environment | Temperature treated as an input assumption (see §13) |
| 12 | Availability | Physical availability and required rest/idle periods |
| 13 | Augmentation | Addition of capacity over lifetime (as a capability interface) |
| 14 | Replacement | Full replacement events (as a capability interface) |
| 15 | Interface to degradation | Explicit boundary where capability degradation is applied |
| 16 | Duration | Energy/power ratio — derived characteristic that determines whether the BESS can satisfy minimum-duration requirements (e.g. DR event duration) |

The domain does **not** compute degradation itself — it defines the physical surface on which degradation acts (see §8).

---

## 4. Conceptual Model of the Physical System

### 4.1 High-Level Physical Chain

The physical system is conceptually represented as a chain from stored energy through conversion to grid-side power:

```
   Stored Energy (Battery)
            │
            ▼
   DC Bus / Internal Losses
            │
            ▼
   Power Conversion System (PCS / Inverter)
            │
            ▼
   AC Side (Grid / Site)
```

Each stage imposes efficiency losses and physical limits. The BESS domain must be capable of representing all three stages conceptually.

### 4.2 Physical Elements

| Element | Conceptual Role |
|---|---|
| Battery stack | Stores energy; has capacity, SOC, SOH, C-rate limits |
| DC bus | Internal coupling; introduces conversion losses |
| PCS / Inverter | Converts DC↔AC; has apparent power rating, reactive capability, efficiency curve |
| AC interface | Couples to site/grid; subject to site or grid limits (declared, enforced elsewhere) |
| Thermal system | Represents temperature environment affecting capability |
| Auxiliary systems | Parasitic consumption and availability considerations; contributes to site load in behind-the-meter configurations |

The domain is defined by **capability and constraint per element**, not by hardware selection.

### 4.3 Physical Boundary

| Inside the domain | Outside the domain |
|---|---|
| Energy, power, SOC, SOH | Load and market conditions |
| Efficiency and losses | Dispatch decisions |
| Operating limits | Revenue attribution |
| Inverter capability | Financial valuation |
| Availability | Market rules |
| Interface to degradation | Degradation computation itself |

---

## 5. Energy Model (Conceptual)

### 5.1 Concepts

| Concept | Meaning |
|---|---|
| Nominal capacity | Nameplate energy capacity of the battery (beginning-of-life) |
| Available capacity | Nominal capacity × current SOH — the energy accessible within SOC limits at the current state of health |
| SOC | Fraction of available capacity currently stored |
| SOC bounds | Minimum and maximum SOC (as fraction of available capacity) |
| Usable capacity | Available capacity × (SOC_max − SOC_min) — the energy that can actually be cycled |
| Energy balance | Conservation of energy across charge/discharge/rest |

The definition order is: **nominal → SOH → available → SOC → usable**. SOC is defined on available capacity; usable capacity is a derived quantity.

### 5.2 Conceptual Requirements

The domain must be able to represent:

1. A distinction between **nominal**, **available**, and **usable** capacity
2. An **SOC state** that evolves over time under dispatch
3. **SOC bounds** that constrain feasible operation
4. The effect of **SOH** on available capacity (as an input from Degradation)

### 5.3 SOC Bounds — Domain Responsibility

**BESS Engineering defines the physically admissible SOC range.**

This range is a **physical constraint of the system** — determined by battery chemistry, warranty terms, and operating policy. It is not a dispatch decision.

**Dispatch must respect that range**, but does not redefine it. Dispatch selects an operating point **within** the feasible SOC envelope defined here.

**SOC window behavior under degradation.** Whether the SOC window narrows proportionally as SOH declines (bounds as percentage of available capacity) or is preserved in absolute kWh (bounds as fixed energy reserves) is an explicit engineering uncertainty — see §15.2. The two options yield materially different usable energy in later project years.

### 5.4 Duration — Derived Characteristic

**Duration** (energy/power ratio) is a derived characteristic exposed by this domain.

It determines whether the BESS can satisfy minimum-duration requirements such as DR event duration, and it changes over the project lifetime as SOH declines.

---

## 6. Power Model (Conceptual)

### 6.1 Concepts

| Concept | Meaning |
|---|---|
| Charge power | Power drawn to charge the battery |
| Discharge power | Power delivered to the site/grid |
| Available charge power | Maximum charge power feasible at the current state |
| Available discharge power | Maximum discharge power feasible at the current state |
| C-rate | Power normalized by energy capacity |
| Ramp rate | Maximum rate of change of power between consecutive intervals |
| Inverter limits | Apparent power rating and reactive power capability |

### 6.2 Conceptual Requirements

The domain must be able to represent:

1. Separate **charge** and **discharge** power capabilities
2. **Available power** as a function of SOC, SOH, and thermal assumption
3. **C-rate limits** that constrain sustained operation
4. **Ramp limits** that constrain transient operation
5. **Inverter envelope** including reactive power capability (as an interface to Operational Engineering)

### 6.3 Interaction with SOC

Charge and discharge capability are **not constant**. They depend on:

- Current SOC (limits near SOC bounds)
- Current SOH (available capacity)
- Thermal conditions
- Inverter state

The domain must expose these dependencies as a **capability surface**, not as a fixed constant.

### 6.4 Reactive Power — Responsibility Split

Reactive power capability is **distributed across three domains**, and this split must be respected:

| Domain | Responsibility |
|---|---|
| **BESS Engineering** | Defines the inverter's **apparent-power and reactive-power capability envelope** (what is physically possible) |
| **Operational Engineering** | Defines the **requirements of the Voltage Regulation value stream** (what the use case needs) |
| **Dispatch & Optimization** | Determines the **actual operating point** (how much reactive vs. active power is used at each moment) |

BESS Engineering **never** decides how reactive power is prioritized against active power. That is an operational and dispatch decision.

---

## 7. Efficiency Model (Conceptual)

### 7.1 Concepts

| Concept | Meaning |
|---|---|
| Round-trip efficiency | Fraction of energy recovered across a full cycle |
| Charge efficiency | Losses incurred while charging |
| Discharge efficiency | Losses incurred while discharging |
| Conversion losses | DC↔AC and internal losses |
| Auxiliary consumption | Parasitic load (HVAC, control systems, standby) |

### 7.2 Conceptual Requirements

The domain must be able to represent:

1. **Asymmetric** charge/discharge efficiency (they need not be equal)
2. **SOC-dependent** or **power-dependent** efficiency (as a conceptual option)
3. **Auxiliary consumption** as a separate conceptual category
4. Efficiency as a **function** of operating point, not a single constant

### 7.3 Auxiliary Consumption — Interface to the Tariff Engine

Auxiliary consumption (HVAC, control systems, standby) adds load to the site.

In **behind-the-meter configurations**, this auxiliary load is **billed**, and therefore contributes to the customer's bill. The BESS domain must expose auxiliary consumption so that it can be included in the **net load** delivered to the tariff engine (Domain 2, per `SYS-ENG-DEF-001` §6.3).

This interface is declared conceptually here and formalized in Stage B.

---

## 8. Interface with Degradation (Conceptual)

### 8.1 Why This Interface Matters

Degradation is **not computed in this domain**, but it **acts on this domain**. The BESS domain must expose the physical surface that Degradation Engineering uses and consumes the updated state that Degradation Engineering returns.

### 8.2 The Interface

```
BESS Engineering                    Degradation Engineering
─────────────────                   ────────────────────────
Physical state:
  - SOC trajectory
  - Power trajectory
  - Throughput
  - Thermal conditions (input assumption)
        │
        └────────────────────────────► Consumes as input
                                        │
                                        ▼
                                     Computes:
                                       - Calendar aging
                                       - Cycle aging
                                       - SOH evolution
                                       - Capacity fade
                                       - Efficiency fade
                                        │
        ┌───────────────────────────────┘
        │
        ▼
Receives:
  - Updated SOH
  - Updated available capacity
  - Updated efficiency characteristics
  - Augmentation events
  - Replacement events
```

### 8.3 Conceptual Contract

| Direction | Content |
|---|---|
| **To Degradation** | Physical operating history, throughput, thermal conditions |
| **From Degradation** | SOH, available capacity, efficiency degradation, augmentation/replacement events |

### 8.4 SOH Ownership — Precise Formulation

**SOH is a BESS state variable whose evolution is determined by Degradation Engineering.**

This distinction matters:

- **BESS Engineering owns the physical state**, including SOH as a state variable.
- **Degradation Engineering owns the evolution law** that determines how SOH changes over time given operating history.

BESS Engineering **stores and exposes** SOH. Degradation Engineering **computes** its evolution. Neither domain subsumes the other.

### 8.5 Boundary Discipline

- BESS Engineering does **not** model degradation.
- Degradation Engineering does **not** redefine the physical system.
- The two domains exchange **state**, not logic.

This discipline preserves the causal backbone (`SYS-ENG-DEF-001` §3) and avoids the classic error of collapsing physics and aging into a single model.

---

## 9. Interface with Dispatch (Conceptual)

### 9.1 What Dispatch Needs From This Domain

Dispatch requires a **feasible operating envelope** at each point in time, consisting conceptually of:

| Envelope Component | Meaning |
|---|---|
| SOC bounds | Minimum and maximum SOC permitted by the physical system |
| Available charge power | Maximum feasible charge power |
| Available discharge power | Maximum feasible discharge power |
| Ramp limits | Maximum rate of change |
| Minimum rest requirements | Idle time constraints |
| Availability | Whether the system is available at all |
| Duration | Energy/power ratio, for minimum-duration service requirements |
| Reactive power capability | For voltage regulation value streams |

### 9.2 What This Domain Needs From Dispatch

Dispatch returns:

- Charge / discharge / rest decisions (time series)
- Resulting SOC trajectory
- Resulting power trajectory
- Resulting thermal exposure (as declared)

### 9.3 Conceptual Contract

| Direction | Content |
|---|---|
| **To Dispatch** | Feasible operating envelope, state at each interval |
| **From Dispatch** | Charge/discharge/rest schedule, SOC trajectory |

### 9.4 Boundary Discipline

- BESS Engineering defines **what is physically possible**.
- Dispatch defines **what is selected within that feasible space**.
- BESS Engineering never selects an operating point.

---

## 10. Interface with Operational Engineering (Conceptual)

Operational Engineering defines the **value streams** the BESS may serve. Each value stream imposes different requirements on the physical system.

| Value Stream | Physical Requirement on BESS |
|---|---|
| Peak Shaving | Sustained discharge capability during peak windows |
| Demand Response | Minimum sustained discharge duration per event (uses duration characteristic, §5.4) |
| Energy Arbitrage | Full cycle capability within SOC bounds |
| Frequency Regulation | Fast symmetric charge/discharge around a setpoint; ramp-sensitive |
| Voltage Regulation | Reactive power capability from inverter envelope |

The BESS domain must expose **capability sufficient to evaluate each value stream**, without encoding the value stream logic itself.

---

## 11. State Variables (Conceptual)

The domain maintains, conceptually, the following state over time:

| State Variable | Nature | Ownership |
|---|---|---|
| SOC | Continuous, bounded | BESS owns state; evolves under Dispatch |
| SOH | Continuous, non-increasing between augmentation/replacement events | BESS owns state; **evolution determined by Degradation** |
| Available capacity | Derived from nominal capacity × SOH | BESS exposes; consumed by Dispatch |
| Usable capacity | Derived from available capacity × (SOC_max − SOC_min) | BESS exposes; consumed by Dispatch |
| Available charge power | Function of SOC, SOH, thermal assumption | BESS exposes; consumed by Dispatch |
| Available discharge power | Function of SOC, SOH, thermal assumption | BESS exposes; consumed by Dispatch |
| Duration | Derived energy/power ratio | BESS exposes; consumed by Operational (min-duration requirements) |
| Availability | Time-dependent capability condition | BESS declares; consumed by Dispatch |

**Note on thermal state.** Temperature is an **input assumption**, not a dynamic state — see §13 and `SYS-ENG-DEF-001` §5.2.

---

## 12. Availability (Conceptual)

### 12.1 Concepts

| Concept | Meaning |
|---|---|
| Physical availability | Whether the system can operate at a given time |
| Scheduled unavailability | Planned outages or maintenance |
| Minimum rest | Required idle time between high-power events |
| Derating | Reduced capability due to thermal or other conditions |

### 12.2 Conceptual Representation

**Availability is conceptually represented as a time-dependent capability condition.**

It describes, for each moment in the simulation horizon, whether and to what extent the BESS can be operated by Dispatch.

The **specific treatment** of availability — deterministic (available / not available / derated) versus probabilistic (availability as a stochastic process) — is deferred to Stage B, where it will be decided based on the RFP's reliability requirements and data availability.

### 12.3 Conceptual Requirements

The domain must be able to represent:

1. Periods during which the BESS is **unavailable** to Dispatch
2. **Minimum rest** constraints that constrain rapid successive cycling
3. **Derating** as a time-varying capability reduction

### 12.4 Boundary

Availability is **declared** by this domain and **respected** by Dispatch. Dispatch does not decide availability; it consumes it.

---

## 13. Thermal Considerations (Conceptual)

### 13.1 Role

Thermal conditions affect:

- Available power
- Available capacity
- Efficiency
- (Indirectly, through Degradation) aging rate

### 13.2 Temperature as an Input Assumption

Per `SYS-ENG-DEF-001` §5.2, **temperature is treated as an input assumption**, not as a dynamic state variable.

The domain receives a **temperature profile** (ambient or cell) as an input and exposes its effect on capability. It does **not** model thermal dynamics internally.

Internal thermal modeling (cell-level thermal dynamics, cooling system behavior) is a **possible future extension**, but it is out of scope for this engagement and not required by the RFP for a planning-grade tool.

### 13.3 Interface

The domain exposes:

- The temperature profile it consumed (for traceability)
- Effect of temperature on available power, available capacity, and efficiency
- Temperature conditions passed to Degradation Engineering as part of the operating history

---

## 14. Required BESS Input Information (Conceptual)

This section lists the **categories of information** the domain conceptually requires to represent a BESS. It is **not** a data schema, **not** a parameter list, and **not** a data model — those belong to Data & Application Engineering (A.2.7) and Stage B.

The purpose here is to make explicit **what must be knowable about a BESS** before the physical model can operate.

### 14.1 Information Categories

| # | Category | Examples of What It Describes (conceptual) |
|---|---|---|
| 1 | Rated energy capacity | Nameplate energy storage capability |
| 2 | Rated charge/discharge power | Nameplate power capability |
| 3 | SOC operating limits | Minimum and maximum admissible SOC, and their behavior under degradation |
| 4 | Efficiency characteristics | Round-trip, charge, discharge efficiency representation |
| 5 | C-rate limits | Sustained and peak C-rate bounds |
| 6 | Ramp limits | Maximum rate of change of power |
| 7 | PCS / inverter characteristics | Apparent power rating, reactive capability, conversion envelope |
| 8 | Thermal operating limits | Permitted operating temperature range |
| 9 | Temperature profile | Ambient or cell temperature time series (input assumption) |
| 10 | Availability assumptions | Expected availability and derating conditions |
| 11 | Auxiliary consumption | Parasitic load and standby consumption |
| 12 | Warranty / operating restrictions | Contractual constraints on cycling, SOC, temperature; SOC window behavior under degradation |
| 13 | Augmentation / replacement assumptions | Policy for capacity addition or replacement; multi-cohort aggregation rule |

### 14.2 Why This List Exists

This list connects A.2.1 directly to:

- **Data & Application Engineering (A.2.7)** — which will define how this information is ingested, validated, and stored
- **Stage B (System Architecture)** — which will define how this information is represented computationally
- **Phase 1 clarification items** — particularly **B3 (Data availability)**, which determines what ENGIE can actually provide

It is a **bridge**, not a specification.

### 14.3 What Is Not Defined Here

- Data types, units, or formats
- Validation rules
- Default values or fallbacks
- Source of each parameter (ENGIE, vendor datasheet, benchmark)

These belong to A.2.7 and Stage B.

---

## 15. Assumptions and Engineering Uncertainties

### 15.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | Battery is a single aggregate unit | Simplifies conceptual modeling | Multi-stack or mixed-cohort configurations (e.g. after augmentation) would need explicit representation; aggregation rule must be defined (see §15.2) |
| 2 | Efficiency is representable at a single conceptual level | Keeps interface simple at Stage A.2 | Sub-level losses (cell, module, string) would be lost |
| 3 | Temperature is an input assumption, not a modeled state | Consistent with A.1 v0.4; matches planning-tool scope | Accuracy of available power in extreme climates may be limited |
| 4 | Reactive capability is part of the inverter envelope | Supports Voltage Regulation value stream | Requires inverter-level detail |
| 5 | Availability is represented as a declared time-dependent capability condition rather than derived from maintenance or reliability models | Avoids premature commitment to a reliability framework | Availability realism may be limited |
| 6 | SOC is defined on available capacity (nominal × SOH) | Avoids circular definition; standard formulation | Requires explicit SOC-window behavior decision (see §15.2) |

### 15.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Thermal modeling fidelity | Stage B (extension only; not in initial scope) |
| 2 | Reactive power priority vs. active power | Operational Engineering (A.2.3) |
| 3 | Whether augmentation is a state event or a capability curve | Interface with Degradation (A.2.5) |
| 4 | Whether SOC bounds are warranty-driven or policy-driven | Phase 1 clarification |
| 5 | Whether efficiency is scalar, curve, or table | Stage B/C |
| 6 | Deterministic vs. probabilistic availability treatment | Stage B |
| 7 | **SOC window behavior under degradation** — proportional narrowing (bounds as %) or preserved kWh reserves | Phase 1 clarification (B4-related) and A.2.5 |
| 8 | **Multi-cohort aggregation rule** after augmentation — weighted SOH, per-cohort tracking, or simplified aggregate | A.2.5 |

### 15.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `SYS-STR-FRM-001` §12:

- **B3** — Data availability (affects parameter sourcing in §14)
- **B4** — Benchmark data (affects validation scope in §17)
- **B5** — Acceptance thresholds (affects validation tolerances)
- **D3** — Degradation feedback loop time scale (affects interface in §8)
- **New question to ENGIE** — SOC window behavior under degradation (see §15.2 #7)

---

## 16. Conceptual Outputs of the Domain

The domain exposes the following **conceptual outputs** to the rest of the system:

| Output | Consumer | Nature |
|---|---|---|
| SOC trajectory | Dispatch, Degradation, Financial (indirect) | Time series |
| SOH state | Dispatch, Degradation, Financial | Time series |
| Available capacity | Dispatch, Financial | Time series |
| Usable capacity | Dispatch, Financial | Time series |
| Available charge/discharge power | Dispatch | Time series (envelope) |
| Ramp limits | Dispatch | Scalar or time series |
| Duration | Operational, Dispatch | Derived scalar or time series |
| Reactive power capability | Operational (Voltage Regulation) | Envelope |
| Auxiliary consumption | **Load & Market (tariff engine)** via net load | Time series |
| Availability | Dispatch | Time-dependent capability condition |
| Physical feasibility conditions | Dispatch | Constraints |
| Temperature effect on capability | Degradation | Derived from input profile |

---

## 17. Validation Requirements (Conceptual)

Following the Validation cross-cutting capability in `SYS-ENG-DEF-001` §4.1, this domain must define validation at the **domain level** and provide evidence to **model** and **system** validation.

### 17.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Energy balance | Charged energy minus losses equals stored energy change |
| SOC consistency | SOC stays within bounds; evolves consistently with dispatch |
| Power limits | Charge/discharge never exceeds declared capability |
| Ramp limits | Rate of change respects declared limits |
| Efficiency consistency | Round-trip efficiency matches declared assumptions |
| Availability consistency | No operation during declared unavailable periods |
| Duration consistency | Exposed duration matches available energy / available power |

### 17.2 Interface Validation

| Check | Nature |
|---|---|
| Envelope completeness | Dispatch never receives an incomplete envelope |
| SOH evolution integrity | SOH is monotonically non-increasing **between augmentation/replacement events**; capability restoration events are represented explicitly |
| Availability propagation | Unavailability is respected by Dispatch |
| Auxiliary consumption propagation | Auxiliary consumption reaches the tariff engine via net load |

### 17.3 Validation Evidence

Validation evidence must be **produced before results are accepted**, not reconstructed afterward. This follows the principle in `SYS-STR-FRM-001` §8.2.

---

## 18. Boundaries — Explicit

### 18.1 Answers

- What physical system is being modeled?
- What can the system physically do at any given state?
- What constraints must any operational decision respect?
- What state must evolve over time as the battery operates?

### 18.2 Does Not Answer

- Which operating strategy should be used?
- How should competing value streams be coordinated?
- How much does the battery degrade?
- What is the economic value of the operation?
- How is data ingested, transformed, or displayed?

Each of these belongs to another domain, as declared in `SYS-ENG-DEF-001` §12.

### 18.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| BESS Engineering | Operational | Physical capabilities and constraints; duration |
| BESS Engineering | Dispatch | Feasible operating envelope; duration |
| BESS Engineering | Degradation | Physical state and operating history; temperature conditions |
| BESS Engineering | Load & Market | **Auxiliary consumption** (via net load, for tariff engine) |
| Degradation | BESS Engineering | Updated SOH, available capacity, efficiency characteristics |

---

## 19. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.6 | §1.1, §5 Domain 1, §6.2 Causal Backbone, §6.4 Operational signals vs. investment assumptions, §8.2 Validation, §12.1/12.2 Phase 1 items | Yes |
| `SYS-ENG-DEF-001` v0.4 | §5 Domain 1, §4.1 Cross-cutting capabilities, §12 Inter-Domain Contract | Yes |
| RFP-264144-1 | Technical system parameters, SOC/SOH, efficiency, power, C-rate, ramp, thermal, augmentation/replacement | Yes |
| RFP-264144-1 | "Feedback loop: degradation impacts available energy in future periods" | Yes — §8 |

---

## 20. Engineering Decisions Deferred to Later Stages

This section consolidates all decisions that are **deliberately not made** in this document. Where earlier sections mention deferred items, they refer here.

| # | Decision | Stage | Rationale |
|---|---|---|---|
| 1 | SOC formulation (absolute energy vs. normalized fraction) | B | Requires architectural context |
| 2 | Efficiency representation (scalar / curve / table) | B | Requires data availability clarity |
| 3 | Thermal modeling fidelity (internal dynamics) | B | Extension only; not in initial scope |
| 4 | Reactive power priority model | A.2.3 / B | Belongs conceptually to Operational Engineering |
| 5 | Augmentation interface details and multi-cohort aggregation | A.2.5 / B | Belongs conceptually to Degradation Engineering |
| 6 | Storage and time-indexing conventions | B | Architecture decision |
| 7 | Interpolation strategy between intervals | B | Architecture decision |
| 8 | Numerical integration scheme | C | Detailed engineering |
| 9 | Validation tolerances | C | Depends on **B5** |
| 10 | Deterministic vs. probabilistic availability treatment | B | Depends on RFP reliability scope and data |
| 11 | SOC window behavior under degradation | Phase 1 + A.2.5 | Affects usable energy in later years |
| 12 | Multi-cohort aggregation rule after augmentation | A.2.5 / B | Affects SOH representation |
| 13 | Auxiliary consumption thermal dependency | B | Affects accuracy in extreme climates |
| 14 | Parameter schemas, units, missing-data handling | B / A.2.7 | Data contracts |

---

## 21. Next Steps

This document establishes the **conceptual engineering baseline** for Domain 1 — BESS Engineering.

The Stage A.2 chapters are developed in the priority order defined in `SYS-ENG-DEF-001` §19, prioritizing thin-slice blockers:

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.4 | Dispatch & Optimization Engineering | ⏭ Next |
| 2 | A.2.5 | Degradation Engineering | ⏭ Next |
| 3 | A.2.1 | BESS Engineering | ✅ **This document** — Baselined |
| 4 | A.2.2 | Load & Market Engineering | ⏭ Pending |
| 5 | A.2.3 | Operational Engineering | ⏭ Pending |
| 6 | A.2.6 | Financial Engineering | ⏭ Pending |
| 7 | A.2.7 | Data & Application Engineering | ⏭ Pending |

Phase 1 clarification items are organized as **blocking (B1–B5)** and **defaultable (D1–D15)** in `SYS-STR-FRM-001` §12. This domain's dependencies are listed in §15.3.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.1 — Conceptual Engineering (BESS Engineering)
**Status:** Conceptual Engineering Baseline — **CLOSED**
**Duration:** 12 Weeks
**Language:** English
---

**BESS Operational & Financial Modeling (RFP-264144-1): Observations and Clarification Requests**

1. SOC window under degradation. As the battery ages, does the operating SOC window scale proportionally with remaining capacity, or does the integrator preserve fixed energy reserves in kWh? The two approaches produce materially different usable energy in later project years. Vendor warranty terms usually define this.