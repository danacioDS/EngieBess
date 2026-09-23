
---

# Dispatch & Optimization Engineering
## Stage A.2.4 — Conceptual Engineering
### Coordination Layer of the BESS Operational & Financial Modeling System

**Document ID:** A.2.4-DISPATCH-ENG-001

**Version:** 0.7 — Conceptual Engineering Baseline (Closed)

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Draft

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.6)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.4)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.1)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.2)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.2)

**Domain:** Domain 4 — Dispatch & Optimization Engineering

**Purpose:** Define, at a conceptual level, what the Dispatch & Optimization domain represents, what it consumes from upstream domains, what it produces, how it coordinates competing value streams, how it handles uncertainty and degradation feedback, and what engineering decisions must be made in later stages — **without** prescribing formulations, solvers, or implementation details.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.4 — Conceptual Engineering** of the Dispatch & Optimization domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §1.1.

Its purpose is to establish the **conceptual engineering definition** of the domain that **coordinates** the value streams declared by Operational Engineering, within the physical capability declared by BESS Engineering, and under the external conditions declared by Load & Market Engineering.

It answers, at conceptual level:

- What Dispatch & Optimization is responsible for
- What it consumes from upstream domains
- What it produces to downstream domains
- How it coordinates competing value streams
- How it handles the degradation feedback loop
- How it handles uncertainty
- How it produces the operational attribution basis for reporting
- What modeling traps it must address and how
- What the thin end-to-end slice will look like
- What is **not** decided here (and who decides it)

It deliberately does **not** define:

- Specific solver selection
- Detailed formulation (equations, variables, constraint set)
- Objective function form
- Exact time discretization
- Exact horizon design
- Software architecture
- Data schemas
- Python classes or APIs

Those belong to Stage B (architecture and optimization formulation) and Stage C (detailed formulation and implementation).

### 1.1 Decision Layers — Methodology, Architecture, Formulation

The following distinction governs what this document decides and what it defers:

| Layer | Decided in | What it fixes |
|---|---|---|
| **Methodology** | **Phase 1** | The class of approach: rule-based heuristic / LP / MILP / hybrid |
| **Architecture** | **Stage B** | Major components, responsibilities, interfaces, execution pattern |
| **Optimization formulation** | **Stage B / C** | Objective structure, constraint families, attribution mechanism, uncertainty treatment |
| **Detailed formulation** | **Stage C** | Variables, equations, linearization, solver configuration, tolerances |

This document declares **requirements and options**, not selections.

### 1.2 Working Defaults from the Strategy

The Strategy (`SYS-STR-FRM-001` §12.2) defines **defaultable** items that allow the project to proceed if ENGIE has not responded by Week 2. This document honors those defaults:

| Strategy default | Working default used in this document |
|---|---|
| **D1** | **LP** (Linear Programming) |
| **D2** | **Perfect foresight** dispatch mode (realization factor applied in Financial Engineering — see §11.1) |
| **D3** | **Annual SOH update** with representative-period simulation |
| **D4** | **Fixed envelope** — no P² + Q² ≤ S² linearization |
| **D14** | **15-minute resolution** when input data permits; hourly otherwise |

Each default is **revisable if ENGIE indicates otherwise**. Throughout this document, where a decision is covered by a Strategy default, it is marked as such and is **not** treated as blocking.

### 1.3 Position Within Stage A

This document refines **Domain 4** of `SYS-ENG-DEF-001` §8 from an eagle-eye definition into a conceptual engineering baseline.

It sits **between** A.2.1 (physical capability), A.2.2 (external environment), A.2.3 (operational requirements), and A.2.5 (degradation), A.2.6 (financial), A.2.7 (data & application).

### 1.4 The Most Important Boundary in This Document

> **Dispatch selects and coordinates. It does not redefine physical capability, does not redefine external conditions, does not redefine operational requirements, and does not compute project financial value.**

### 1.5 Relationship to Upstream Domains

| Domain | What it provides to Dispatch |
|---|---|
| **BESS Engineering (A.2.1)** | Feasible operating envelope: available power, SOC bounds, ramp limits, duration, reactive envelope, availability |
| **Load & Market Engineering (A.2.2)** | External conditions: load, price signals, tariff value signals, program rules, grid constraints, eligibility, regulation statistics, scenario variations |
| **Operational Engineering (A.2.3)** | Operational requirements per value stream: SOC floors, duration floors, reserve requirements, ramp requirements, interaction declarations |

### 1.6 Relationship to Downstream Domains

| Domain | What it receives from Dispatch |
|---|---|
| **Degradation Engineering (A.2.5)** | Battery usage: dispatch schedule, SOC trajectory, throughput, cycling behavior |
| **Load & Market Engineering (A.2.2)** | BESS power trajectory from which post-dispatch net load is derived for tariff evaluation |
| **Financial Engineering (A.2.6)** | Operational results: dispatch schedule, SOC trajectory, operational attribution basis, service-level metrics |

### 1.7 Generality Principle

This document defines **generic dispatch and optimization concepts** — parameterizable for different markets, programs, configurations, and methodologies.

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Dispatch & Optimization domain** is the conceptual representation of the **coordination layer** that:

- Consumes physical capability, external conditions, and operational requirements
- Selects which value streams to activate at each moment
- Coordinates them under shared physical constraints
- Produces a feasible, coordinated dispatch schedule
- Produces the operational attribution basis for reporting
- Provides BESS power trajectory for post-dispatch net load
- Feeds back to Degradation Engineering
- Feeds forward to Financial Engineering

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| A physical model | Physical capability belongs to Domain 1 |
| A market model | External conditions belong to Domain 2 |
| An operational mode definition | Value stream behavior belongs to Domain 3 |
| A degradation model | Degradation belongs to Domain 5 |
| A financial model | Economic valuation belongs to Domain 6 |
| A tariff engine | Tariff computation belongs to Domain 2 |
| **A revenue calculator** | Dispatch produces **attributable operational quantities** and, where required, **settlement-relevant operational quantities**; Financial Engineering converts these into revenue, cash flow, NPV, IRR |
| A software module | Software structure belongs to Stage B/C/D |

**Operational attribution vs. revenue valuation.** Dispatch produces the **operational attribution basis**. Financial Engineering converts it into revenue, cash flow, and KPIs. Attribution is a **quantity-level** responsibility; valuation is a **money-level** responsibility.

### 2.3 Primary Question

> **Given physical capability, external conditions, and operational requirements, how should the BESS be dispatched — and how should competing value streams be coordinated?**

### 2.4 Guiding Principle

> **Dispatch selects, coordinates, and produces the operational attribution basis. It never redefines what upstream domains have declared, and it never performs project financial valuation.**

---

## 3. Engineering Scope

The domain must conceptually represent the following aspects:

| # | Aspect | Description |
|---|---|---|
| 1 | Selection | Which value streams are active at each moment |
| 2 | Coordination | How competing value streams share physical resources |
| 3 | Constraint satisfaction | Physical, operational, market, program, grid constraints |
| 4 | SOC management | Maintaining SOC within bounds across the horizon |
| 5 | Reserve management | Managing reserved capacity for future services or events |
| 6 | Uncertainty handling | How the dispatch accounts for imperfect foresight |
| 7 | Consumption of the degradation signal | Updated degradation state, available capacity, degradation-related marginal signal (where produced by A.2.5) |
| 8 | Operational attribution basis | Which value stream is responsible for each attributable portion of the dispatch |
| 9 | BESS power trajectory | Provided for post-dispatch net load derivation |
| 10 | Operational result production | Producing the dispatch schedule and SOC trajectory |
| 11 | Evidence production | Producing evidence of constraint compliance |

**Note on item 7 — Dispatch ↔ Degradation coupling.**

```
Dispatch → Battery Usage → Degradation → Updated State / Degradation Signal → Dispatch
```

Dispatch owns the **operating decision**. Degradation Engineering owns the **physical consequence**.

---

## 4. Conceptual Model of Dispatch

### 4.1 High-Level Structure

Dispatch conceptually sits at the intersection of **three primary upstream input streams**, with **one additional feedback input from Degradation Engineering**:

```
   Physical Capability            External Conditions
   (from A.2.1)                   (from A.2.2)
            │                             │
            └──────────┬──────────────────┘
                       │
                       ▼
              Operational Requirements
                  (from A.2.3)
                       │  (three primary upstream inputs)
                       ▼
        ┌─────────────────────────────────┐
        │    DISPATCH & OPTIMIZATION      │
        │  • Selection                    │
        │  • Coordination                 │
        │  • Constraint satisfaction      │
        │  • SOC management               │
        │  • Reserve management           │
        │  • Operational attribution      │
        └─────────────────────────────────┘
                       │
       ┌───────────────┼─────────────────┬───────────────┐
       ▼               ▼                 ▼               ▼
   Dispatch        BESS power        Attribution     Battery Usage
   Schedule        trajectory        basis           (to Degradation)
   + SOC           (for net load)    (to Financial)
       │                                                 │
       │                                                 ▼
       │                                     ┌─────────────────────────┐
       │                                     │  DEGRADATION ENGINEERING│
       │                                     │  (A.2.5)                │
       │                                     └────────────┬────────────┘
       │                                                  │
       │                          Updated capability +    │
       │                          degradation signal      │
       └──────────────────────────────────────────────────┘
                     (feedback input)
```

### 4.2 Conceptual Sub-Areas

| Sub-Area | Conceptual Role |
|---|---|
| Value Stream Selection | Which value streams are active |
| Resource Coordination | How shared resources are coordinated |
| Constraint Satisfaction | Physical, operational, market, program, grid |
| SOC Management | SOC trajectory within bounds |
| Reserve Management | Reserved capacity for future services |
| Uncertainty Handling | Perfect foresight vs. forecast-based |
| Degradation Signal Consumption | Updated degradation state, degradation marginal signal |
| Operational Attribution Basis | Attribution of attributable behavior to streams |
| BESS Power Trajectory | For post-dispatch net load derivation |
| Operational Result Production | Dispatch schedule, SOC trajectory |
| Constraint Compliance Evidence | Evidence for validation |

### 4.3 Dispatch Boundary

| Inside the domain | Outside the domain |
|---|---|
| Selection and coordination | Physical capability definition |
| Constraint satisfaction | External environment definition |
| SOC management | Operational requirement definition |
| Reserve management | Degradation computation |
| Uncertainty handling | Project financial valuation |
| Operational attribution basis (quantity-level) | Tariff computation |
| Dispatch schedule | Degradation signal computation |
| SOC trajectory | Software implementation |
| BESS power trajectory | — |

---

## 5. Inputs to Dispatch

### 5.1 From BESS Engineering (A.2.1)

| Input | Meaning |
|---|---|
| SOC and SOC bounds | Current state and admissible range |
| Available charge / discharge power | Maximum feasible power |
| Ramp limits | Maximum rate of change |
| Duration | Energy/power ratio |
| Reactive power capability | Apparent-power envelope |
| Availability | Time-dependent capability condition |
| Physical feasibility conditions | Envelope constraints |

### 5.2 From Load & Market Engineering (A.2.2)

| Input | Meaning |
|---|---|
| Load / projected load | Demand to be served or shaved |
| Energy price signals | External economic signal for energy flows |
| Tariff value signals | Energy rates, demand charge rates as external parameters |
| Ancillary-service price signals | External economic signal for regulation / reserves |
| Capacity price signals | External economic signal for availability |
| Program compensation signals | DR payment structures |
| Voltage-support compensation signals | Where applicable |
| Power factor penalties / kVAR charges | Where applicable (pending `A.2.2` v1.3) |
| DR program rules | Event windows, notification, penalties |
| Baseline methodology | Via program adapter |
| Grid constraints | Interconnection limits, export constraints |
| Eligibility | Participation conditions |
| Frequency regulation statistics | Energy per MW, signal bias, performance score |
| Scenario variations | Multiple load and price trajectories |

### 5.3 From Operational Engineering (A.2.3)

| Input | Source in A.2.3 | Meaning |
|---|---|---|
| Operational requirements | §5.5, §6.5, §7.5, §8.5, §9.5 | SOC floors, duration floors, reserve requirements, ramp requirements |
| Service requirements | §13.1 | Duration, ramp, response time |
| Service-level metrics | §5.6, §6.6, §7.6, §8.6, §9.6 | What each service is expected to deliver |
| Interaction declarations | §10.2 | Which resources are shared, which value streams compete |
| Degradation-relevant behavior declarations | §14.1 | Which behaviors generate degradation-relevant usage |

### 5.4 From Degradation Engineering (A.2.5) — Possible Interface

| Possible content | Meaning |
|---|---|
| Updated degradation state / SOH | Updated physical degradation state at the applicable feedback point |
| Available capacity | Usable capacity resulting from the current degradation state |
| Degradation-related marginal signal | Where economically modeled, a per-MWh signal representing the economic cost of additional throughput |

Whether Degradation Engineering produces a **physical** signal only, an **economic** marginal signal only, or **both** is decided in A.2.5.

**Feedback frequency.** Under working default **D3**, the degradation state is updated **annually** with representative-period simulation within each year. See §12.2 for the representative-period constraint.

---

## 6. Value Stream Selection

### 6.1 Concept

Dispatch selects which value streams are **active** at each moment in the simulation horizon.

### 6.2 Simultaneous Participation — Conceptual Distinctions

| Form of simultaneity | Meaning |
|---|---|
| **Physical simultaneity** | Two value streams physically operate at the same time |
| **Reservation simultaneity** | Two value streams share reserved capacity |
| **Attribution simultaneity** | Two value streams are both credited for the same operational behavior |
| **Objective simultaneity** | Two value streams contribute to the same objective function |

### 6.3 Conceptual Requirements

1. **Selection** — deciding which value streams to activate
2. **Re-selection** — changing the active set over time
3. **Declared constraints** — respecting the operational requirements from A.2.3
4. **Availability** — respecting BESS availability

---

## 7. Resource Coordination

### 7.1 Shared Resources

All value streams compete for the same physical resources (`A.2.3` §10.1):

- Power · Energy · SOC headroom · Ramp capability · Availability · Inverter apparent-power envelope

### 7.2 Working Default Coordination Strategy

Under working default **D1** (LP with perfect foresight), coordination is achieved through a **single co-optimized objective** subject to physical and operational constraints.

This is the working assumption for the thin slice (§20). It is revisable if ENGIE selects a different methodology.

### 7.3 What Is Not Decided Here

- The specific objective function form (Stage B)
- Priority rules if a priority hierarchy is used (Stage B)
- How ties are broken (Stage B)

---

## 8. Constraint Satisfaction

### 8.1 Constraint Categories

| Category | Source | Examples |
|---|---|---|
| **Physical** | BESS Engineering | SOC bounds, power limits, ramp limits, inverter envelope |
| **Availability** | BESS Engineering | Unavailability, minimum rest |
| **Operational** | Operational Engineering | SOC floors per stream, duration floors, reserve requirements |
| **Market** | Load & Market | Eligibility, participation rules |
| **Program** | Load & Market | DR event windows, notification requirements |
| **Grid** | Load & Market | Interconnection limits, export constraints |

### 8.2 Economic Signals vs. Constraints

**Economic signals are not constraints.** Price signals, price differentials, and similar economic quantities are **inputs to the dispatch decision process** and may contribute to the objective, heuristic logic, ranking logic, or another decision mechanism.

The specific role each economic signal plays is decided by the selected methodology (**D1**) and Stage B.

### 8.3 Working Default Constraint Treatment

Under the working defaults, the following are **hard constraints**:
- SOC bounds
- Power limits
- Ramp limits
- Availability
- Grid interconnection limits

**DR performance** and **contractual commitments** are treated as **soft constraints** with explicit penalties, subject to Stage B formulation.

---

## 9. SOC Management

### 9.1 Concepts

| Concept | Meaning |
|---|---|
| SOC trajectory | The evolution of SOC over the horizon |
| SOC bounds | The admissible range |
| SOC floor per stream | Minimum SOC preserved for a specific stream |
| SOC headroom | Available room for charging or discharging |
| SOC drift | Unintended SOC change (e.g. from regulation) |
| SOC recovery | Deliberate SOC correction after drift |
| **Terminal SOC** | The SOC at the end of the optimization horizon |

### 9.2 Conceptual Requirements

1. **Trajectory management** — SOC within bounds across the horizon
2. **Per-stream SOC floors** — where operational requirements demand
3. **SOC drift from regulation** — represented using the statistics from A.2.2
4. **SOC recovery** — restoring SOC after drift or event-driven discharge
5. **Terminal SOC condition** — see §16.1

---

## 10. Reserve Management

### 10.1 Concept

Some value streams require **reserved capacity** that cannot be used for other services.

### 10.2 Conceptual Requirements

1. **Reserved capacity** — power reserved for a specific stream
2. **Reserved energy** — SOC headroom reserved for a specific stream
3. **Reservation duration** — how long the reservation holds
4. **Release conditions** — when the reservation is released

---

## 11. Uncertainty Handling

### 11.1 Foresight Framing

Under working default **D2**, dispatch operates in **perfect-foresight mode**. This is the primary dispatch mode for the thin slice.

**The realization factor is applied in Financial Engineering, not in Dispatch.** Dispatch produces the operational results under perfect foresight; Financial Engineering applies the realization factor when converting those results into reported project value. This preserves the domain boundary: Dispatch does not produce money (§2.2).

The realization factor is applied **per stream** in Financial Engineering. It applies naturally to arbitrage and market-based revenues, whose realized value depends on forecast accuracy. It does not apply uniformly to behind-the-meter savings, whose risk is reflected through tariff mechanisms (ratchets, coincident-peak hit rate) computed by the tariff engine.

See A.2.6 for the application of the realization factor.

**Forecast-based dispatch** is an optional extension, supporting separate reporting of the value erosion due to forecast uncertainty.

### 11.2 Scenario Handling

Under the scenario-based uncertainty representation (`A.2.2` §12), Dispatch may:

- Run a single scenario per simulation
- Run multiple scenarios and compare results
- Run a scenario grid across load × price combinations

**Scenario analysis ≠ stochastic optimization.**

### 11.3 DR Event Uncertainty

**Working default:** DR events are handled via **reserve capacity held during event windows**. Individual events are not simulated. Scenario-based event realization is an optional extension.

---

## 12. Degradation Feedback

### 12.1 The Feedback Loop

```
Dispatch → Battery Usage → Degradation → Updated State → Dispatch
```

Dispatch **consumes** the feedback. It does not define or compute the degradation model.

### 12.2 Working Default Feedback Time Scale

Under working default **D3**, the degradation state is updated **annually**, with representative-period simulation within each year.

**Representative-period constraint — consistency with the monthly horizon.** Because peak shaving and demand charges depend on the **monthly billed peak**, representative periods must respect the billing period. Two options are consistent with the thin-slice configuration (§20):

| Option | Description |
|---|---|
| **Monthly representative periods** | Each simulated representative period is a **complete billing month**. The year is represented by a set of complete months. |
| **Twelve monthly simulations** | All twelve months of each year are simulated, with no representative-period reduction. This preserves full monthly resolution at higher computational cost. |

**Working default for the thin slice:** monthly representative periods. The choice between these two options is revisable in Stage B, but **any representative-period scheme must preserve the monthly billed peak**. Day-level or week-level representative periods are **not** consistent with the peak-shaving value stream and are excluded.

This constraint is also relevant to A.2.5, since it affects how annual degradation aggregation interacts with monthly simulation.

### 12.3 Consumption of the Degradation Signal

If the selected dispatch methodology includes a degradation-related marginal signal in the objective, the signal is provided by Degradation Engineering. Whether such a signal exists is decided in A.2.5.

---

## 13. Operational Attribution Basis

### 13.1 Concept

Dispatch produces the **operational attribution basis** — which operational behavior belongs to which value stream. This is what Financial Engineering consumes to report value by stream.

### 13.2 Operational Attribution vs. Revenue Valuation

| Level | Responsibility | Owner |
|---|---|---|
| **Quantity level** | Which operational behavior belongs to which value stream | Dispatch |
| **Money level** | What that behavior is worth in revenue, cash flow, and KPIs | Financial Engineering |

### 13.3 Working Default Attribution Mechanism

Under working defaults, the thin slice uses **rule-based attribution**:

- Peak shaving discharge → attributed to peak shaving
- Arbitrage charge / discharge cycles → attributed to arbitrage
- Reserved capacity → attributed to the reserving stream
- SOC recovery → classified as "recovery"
- Idle → classified as "idle"

Other mechanisms (marginal, proportional, joint optimization) are available as extensions subject to ENGIE's confirmation.

### 13.4 Sources of Attribution

| Mechanism | What it produces | Source |
|---|---|---|
| **Dispatch attribution** | Operational quantities attributable to market value streams | This domain |
| **Tariff engine mapping** | Behind-the-meter savings by billing component, mapped to BTM value streams | `A.2.2` §9.8 and `A.2.3` §15.2 |

**Financial Engineering remains the single source of truth for project financial value.**

### 13.5 Attribution Completeness

| Classification | Meaning |
|---|---|
| **Attributed** | Behavior assigned to a value stream |
| **Idle** | BESS at rest |
| **Charging for future operation** | Charging not attributable to a specific current stream |
| **Recovery** | SOC recovery after drift or event discharge |
| **Unavoidable physical operation** | Auxiliary consumption |
| **Shared operation** | Behavior serving multiple streams without a clean split |
| **System operation** | Behavior required by the platform |

---

## 14. BESS Power Trajectory and Post-Dispatch Net Load

### 14.1 Concept

Dispatch produces the **BESS power trajectory**. From this, the **post-dispatch net load** is derived for tariff evaluation by Domain 2:

```
Post-dispatch net load =
    Site load
  + BESS charging
  − BESS discharging
  + BESS auxiliary consumption
```

This formula expresses the **conceptual composition** only. It does not fix sign conventions, power reference point, or efficiency loss treatment.

### 14.2 Where the Derivation Is Executed

The composition is a **system-level** quantity. **Where** it is executed (Dispatch, Load & Market, or Data & Application) is a Stage B architecture decision.

### 14.3 Power Reference Point — Deferred to Stage B

The **power reference point** (AC-side vs. DC-side) affects how efficiency losses are represented. This is deferred to Stage B, where the physical model's power reference point is defined consistently across domains.

---

## 15. Operational Result Production

### 15.1 Outputs

| Output | Nature |
|---|---|
| Dispatch schedule | Charge / discharge / rest per interval |
| SOC trajectory | SOC per interval |
| BESS power trajectory | Charge / discharge power per interval |
| Reserved capacity | Per stream, per interval |
| Operational attribution basis | Per stream, per interval |
| Constraint compliance evidence | For validation |

### 15.2 Downstream Consumption

| Output | Consumer |
|---|---|
| Dispatch schedule | Degradation, Financial |
| SOC trajectory | Degradation, Financial (indirect) |
| BESS power trajectory | Load & Market (net load derivation) |
| Operational attribution basis | Financial |
| Constraint compliance evidence | Validation |

---

## 16. Modeling Traps and Conceptual Approaches

This section lists the modeling traps identified across `A.2.1`, `A.2.2`, `A.2.3`, and this document — and states the **conceptual approach** for each. These are not formulations (those belong to Stage B/C), but they are the **conceptual decisions** that this document must record.

### 16.1 Trap Resolution Table

| Trap | Conceptual Approach (working default) |
|---|---|
| **Demand charge monthly maximum** | The optimization horizon must be **≥ the billing period**. The billed peak is treated as a **variable of the problem**, not a post-processing statistic |
| **Regulation charging may create the billed peak (BTM)** | The **net load during regulation reserve** enters the same peak constraint as other net load components. Charging for regulation is not exempt from the billed peak |
| **DR events not known in advance** | Handled via **reserved capacity during event windows**. Individual events are not simulated in the thin slice |
| **Coincident peak uncertainty** | Peak hours are assumed **known**, with a **configurable hit-rate factor** to represent imperfect prediction |
| **Demand ratchets** | **Evaluated in the tariff engine** (A.2.2 §9.4). Dispatch optimizes the monthly peak; the ratchet differential is reported as a diagnostic by the tariff engine |
| **P² + Q² ≤ S² nonlinear coupling** | Treated as a **fixed envelope** under working default **D4**. No linearization in the initial scope |
| **Perfect foresight may overstate achievable value** | Perfect foresight is the **primary dispatch mode** (D2). The **realization factor** is applied in **Financial Engineering**, not in Dispatch. See §11.1 and A.2.6 |
| **Efficiency losses** | Represented as part of the physical model (A.2.1). Dispatch uses the loss-aware envelope from BESS Engineering |
| **Minimum spread threshold for arbitrage** | A **decision rule** in the dispatch mechanism. Under LP + perfect foresight, it emerges endogenously from the objective and the marginal degradation signal (where applicable) |
| **Terminal SOC at the end of the horizon** | Without a terminal condition, an LP with perfect foresight empties the battery at the end of each horizon, because the remaining energy "has no value". **A terminal SOC condition is required.** Working default: **terminal SOC = initial SOC** at the end of each optimization horizon. Alternative: assign a monetary value to stored energy at the horizon's end. The choice is a Stage B decision, but the terminal condition itself is a conceptual requirement |
| **Simultaneous charge and discharge** | An LP may charge and discharge simultaneously to dissipate energy through losses (useful when prices are negative) or to circumvent constraints. With positive prices this rarely occurs. **If the target market includes negative prices** (as some markets frequently do), a binary variable (MILP) or a penalty is required to prevent simultaneous charge and discharge. Working default: **declare the trap and defer the mitigation choice to Stage B**, contingent on Phase 1 **B1** (target market). If the target market has no negative prices, the LP formulation is sufficient |

### 16.2 What This Table Establishes

- Each trap has an **agreed conceptual approach**.
- None of the approaches require Stage B/C decisions to be made earlier than planned.
- The approaches are consistent with the working defaults of §1.2.
- Any trap whose approach is later revised will be tracked as a change to this document.

---

## 17. Methodology — Working Default and Options

### 17.1 Working Default

Under working default **D1**, the dispatch methodology is **Linear Programming (LP)** with perfect foresight.

This is the methodology assumed for the thin slice (§20). It is revisable if ENGIE indicates otherwise.

### 17.2 Methodology Options

| Option | Characteristic |
|---|---|
| **Rule-based heuristic** | Deterministic and transparent |
| **Linear Programming (LP)** | Optimization of a linear formulation |
| **Mixed-Integer Programming (MILP)** | Optimization with discrete decisions |
| **Hybrid** | Combination of deterministic rules and optimization |

### 17.3 Selection Criteria (if ENGIE overrides the default)

- Problem complexity
- Computational requirements
- Transparency
- Accuracy
- Explainability
- Scenario requirements
- Data availability

---

## 18. Interfaces with Upstream and Downstream Domains

### 18.1 Upstream Interfaces

| Domain | Contract |
|---|---|
| BESS Engineering (A.2.1) | Feasible operating envelope |
| Load & Market (A.2.2) | External signals, tariff value signals, regulation statistics, scenario variations |
| Operational Engineering (A.2.3) | Operational requirements, service requirements, metrics, interaction declarations |
| Degradation (A.2.5) | Updated degradation state, available capacity, degradation-related signal (where applicable) |

### 18.2 Downstream Interfaces

| Domain | Contract |
|---|---|
| Degradation (A.2.5) | Dispatch schedule, SOC trajectory, throughput, cycling behavior |
| Load & Market (A.2.2) | BESS power trajectory (basis for post-dispatch net load derivation) |
| Financial (A.2.6) | Dispatch schedule, SOC trajectory, operational attribution basis, service-level metrics |

### 18.3 Boundary Discipline

| Domain | Declares | Dispatch |
|---|---|---|
| BESS Engineering | What is physically possible | Selects what is done within that space |
| Load & Market | The environment | Produces the operational response |
| Operational | Operational requirements | Selects the actual behavior |
| Degradation | State evolution | Produces battery usage |
| Financial | Valuation | Produces attributed operational results |

---

## 19. Validation Requirements (Conceptual)

### 19.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Physical constraint compliance | SOC bounds, power limits, ramp limits respected |
| Operational requirement compliance | SOC floors, duration floors, reserve requirements respected |
| Availability compliance | No operation during declared unavailable periods |
| Energy balance | Energy charged, discharged, and stored consistent |
| **Terminal SOC compliance** | Terminal SOC condition satisfied at the end of each horizon |
| **No simultaneous charge and discharge** | No interval with both charge and discharge active (unless the market has no negative prices and the LP formulation permits it) |
| Post-dispatch net load consistency | Net load derivable from BESS power trajectory, site load, auxiliary |

### 19.2 Attribution Validation

| Check | Nature |
|---|---|
| **Attribution completeness** | All attributable behavior assigned to a value stream or explicitly classified |
| **Attribution reconciliation** | Attributed and explicitly classified quantities reconcile to the total modeled operational behavior |
| Attribution reproducibility | Same inputs produce same attribution |

### 19.3 Interface Validation

| Check | Nature |
|---|---|
| Envelope usage | Dispatch never exceeds the feasible envelope |
| Degradation interface | Usage passed to Degradation is complete |
| Tariff engine interface | BESS power trajectory covers the full horizon |
| Attribution interface | Attribution basis is complete and consistent |

### 19.4 Validation Evidence

Validation evidence must be **produced before results are accepted**.

---

## 20. Thin Slice — Week 4 Configuration

The thin end-to-end slice (`SYS-STR-FRM-001` §4.2) demonstrates a working dispatch by Week 4. This section declares the dispatch configuration for that slice.

### 20.1 Thin Slice Dispatch Configuration

| Dimension | Configuration |
|---|---|
| **Methodology** | LP with perfect foresight (working default **D1**) |
| **Value streams included** | Peak shaving + energy arbitrage (two value streams) |
| **Horizon** | Monthly horizon, sized to cover the billing period for peak shaving |
| **Time resolution** | 15-minute when input data permits; hourly otherwise (working default **D14**) |
| **SOH update** | Held constant within each simulated year; updated between years (working default **D3**) |
| **Representative periods** | Monthly representative periods (see §12.2) |
| **Terminal SOC** | Terminal SOC = initial SOC at the end of each monthly horizon (see §16.1) |
| **Degradation signal** | Consumed if produced by A.2.5; otherwise omitted from the initial slice |
| **Attribution** | Rule-based (§13.3) |
| **Scenario handling** | Single scenario per simulation |
| **Foresight** | Perfect foresight (**D2**); realization factor applied in Financial Engineering |
| **Net load derivation** | Executed by the domain designated in Stage B (working assumption: Load & Market, for consistency with the tariff engine) |

### 20.2 What the Thin Slice Demonstrates

- The full causal chain: BESS → Dispatch → Tariff Engine → Financial
- The dispatch schedule and SOC trajectory
- The BESS power trajectory
- The operational attribution basis
- Net load for tariff evaluation
- At least one financial KPI (NPV) in the Databricks App

### 20.3 What the Thin Slice Does Not Include

- Frequency regulation
- Demand response
- Voltage regulation
- Multi-scenario dispatch
- Forecast-based dispatch
- Degradation marginal signal in the objective (unless A.2.5 produces it early)
- Advanced attribution mechanisms

These are added in subsequent weeks.

---

## 21. Assumptions and Engineering Uncertainties

### 21.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | Dispatch consumes upstream declarations without redefining them | Preserves causal backbone | Would collapse domain boundaries |
| 2 | Multiple value streams may participate simultaneously | Matches physical reality | Would require serialization of streams |
| 3 | Operational attribution basis is required for revenue-by-stream reporting | RFP requirement | Would leave revenue-by-stream undefined |
| 4 | Financial Engineering is the single source of truth for project financial value | Consistent with `SYS-ENG-DEF-001` §10.4 | Would create double counting |
| 5 | Degradation feedback is provided as a state and, where applicable, a signal | Consistent with `A.2.1` and to be formalized in A.2.5 | Would require a different coupling |
| 6 | Perfect foresight is the primary dispatch mode; realization factor applied in Financial Engineering | Working default **D2** | Would change reporting approach |
| 7 | Post-dispatch net load is a derived system quantity | Preserves composition clarity | Would place derivation responsibility ambiguously |
| 8 | Representative periods respect the monthly billing period | Preserves peak-shaving value stream | Would invalidate demand charge calculations |

### 21.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Dispatch methodology | **D1** (default: LP) — revisable |
| 2 | Attribution mechanism | **Stage B** (default: rule-based) |
| 3 | DR event uncertainty treatment | **Stage B** (default: reserve-based) |
| 4 | Whether a degradation-related marginal signal exists | **A.2.5** |
| 5 | Whether P² + Q² ≤ S² is linearized | **D4** (default: fixed envelope) |
| 6 | Multi-timescale operation | **Stage B** (default: single resolution) |
| 7 | Horizon structure (single, rolling, representative) | **Stage B** (default: monthly for thin slice) |
| 8 | Where the net load derivation is executed | **Stage B** |
| 9 | Model output granularity | Phase 1 if ENGIE has preference; otherwise Stage B |
| 10 | Primary model purpose / use case | Phase 1 if ENGIE has preference; otherwise default to evaluation |
| 11 | Terminal SOC condition (fixed equal, or assigned value) | **Stage B** (default: terminal SOC = initial SOC) |
| 12 | Simultaneous charge/discharge mitigation | **Stage B**, contingent on **B1** (target market negative prices) |
| 13 | Representative-period scheme (monthly vs. twelve months) | **Stage B** (default: monthly representative periods) |

### 21.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `SYS-STR-FRM-001` §12:

- **B1** — Target market(s)
- **B2** — Behind-the-meter vs. front-of-the-meter scope
- **B5** — Acceptance thresholds
- **D1–D4, D11, D14** — Working defaults applied; revisable

Additional clarifications from this domain are tracked in §28.

---

## 22. Conceptual Outputs of the Domain

| Output | Consumer | Nature |
|---|---|---|
| Dispatch schedule | Degradation, Financial, Data & Application | Time series |
| SOC trajectory | Degradation, Financial, Data & Application | Time series |
| BESS power trajectory | Load & Market (net load derivation), Degradation, Financial | Time series |
| Reserved capacity per stream | Financial (attribution), Data & Application | Time series |
| Operational attribution basis | Financial | Per stream, per interval |
| Constraint compliance evidence | Validation | Structured evidence |
| Operational classification | Validation, reporting | Per interval |

---

## 23. Boundaries — Explicit

### 23.1 Answers

- Which value streams are active?
- How are shared resources conceptually coordinated?
- How is SOC managed across the horizon?
- How are reserves managed?
- How does dispatch handle uncertainty?
- How does dispatch consume the degradation signal?
- What is the operational attribution basis?
- What is the dispatch schedule, SOC trajectory, and BESS power trajectory?

### 23.2 Does Not Answer

- What is physically possible?
- What is the external environment?
- What does each value stream require?
- How does the battery degrade?
- What is the project's financial value?
- How is the customer bill computed?
- How is the model implemented?

### 23.3 Inter-Domain Contract (Restated)

See §18.

---

## 24. What Is Deliberately NOT Defined Here

- Solver selection
- Objective function form
- Constraint formulation
- Linearization strategy
- Attribution mechanism (beyond working default)
- Uncertainty treatment methodology
- SOC formulation, efficiency representation, power reference point, thermal modeling
- Forecast methodology, price signal construction, program rule computation
- Degradation equations, feedback mechanism
- Cash-flow formulation, NPV, IRR computation, tax treatment, realization factor application
- Software structure, data structures, storage representation
- Numerical methods (time discretization, horizon length, interpolation, solver parameters)
- Integration details, orchestration
- Market-specific rules

These belong to Stage B, Stage C, Stage D, or to Phase 1 decisions.

---

## 25. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.6 | §4.2 Thin slice, §5 Domain 4, §6.2 Causal Backbone, §6.4 Operational signals vs. investment assumptions, §8.2 Validation, §12.2 Defaults | Yes |
| `SYS-ENG-DEF-001` v0.4 | §8 Domain 4, §10.4 Single source of truth, §12 Inter-Domain Contract | Yes |
| `A.2.1-BESS-ENG-001` v1.1 | §6.4 Reactive power split, §8 Degradation interface, §9 Dispatch interface | Yes |
| `A.2.2-LOAD-MKT-ENG-001` v1.2 | §8.3 Regulation statistics, §9 Tariff engine, §9.8 Single source of truth, §16 Dispatch interface | Yes |
| `A.2.3-OPS-ENG-001` v1.2 | §4 Requirements pattern, §10 Interactions, §13 Dispatch interface, §14 Degradation interface, §15 Attribution convention | Yes |
| RFP-264144-1 | Co-optimization, physical constraints, prioritization logic, methodology options | Yes |

**Traceability note.** When this document is promoted to a closed baseline, a document-control audit will be performed across `SYS-STR-FRM-001`, `SYS-ENG-DEF-001`, and A.2.1 through A.2.7.

---

## 26. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Working default |
|---|---|---|---|
| 1 | Dispatch methodology | **D1** | LP |
| 2 | Objective function form | Stage B / C | — |
| 3 | Constraint formulation | Stage B / C | — |
| 4 | Hard vs. soft constraint treatment | Stage B | Hard: SOC, power, ramp, availability, grid |
| 5 | Linearization strategy | Stage B / C | — |
| 6 | Solver selection | Stage C | — |
| 7 | Attribution mechanism | Stage B | Rule-based |
| 8 | Uncertainty treatment | Stage B | Perfect foresight (**D2**); realization factor in Financial (A.2.6) |
| 9 | DR event uncertainty treatment | Stage B | Reserve-based |
| 10 | Whether a degradation-related signal enters the objective | A.2.5 / **D1** | Joint decision |
| 11 | Whether P² + Q² ≤ S² is linearized | **D4** | Fixed envelope |
| 12 | Time resolution | **D14** | 15-min if data permits |
| 13 | Multi-timescale representation | Stage B | Single resolution |
| 14 | Horizon structure | Stage B | Monthly (thin slice) |
| 15 | Scenario handling in dispatch | Stage B / **D11** | Single scenario |
| 16 | Where net load derivation is executed | Stage B | Load & Market |
| 17 | Constraint compliance evidence format | Stage B / C | — |
| 18 | Validation tolerances | Stage C / **B5** | — |
| 19 | Model output granularity | Phase 1 / Stage B | All levels |
| 20 | Primary model purpose / use case | Phase 1 | Evaluation |
| 21 | Market scope | **B1** | — |
| 22 | BTM vs. FTM priority | **B2** | Both, with BTM priority for thin slice |
| 23 | BESS sizing vs. evaluation | Phase 1 | Evaluation |
| 24 | Co-optimization vs. separate dispatch + stacking | RFP | Co-optimization (per RFP) |
| 25 | Lifecycle economics influence on dispatch | Strategy §6.4 | Investment assumptions do not enter dispatch directly |
| 26 | Terminal SOC condition | Stage B | Terminal SOC = initial SOC |
| 27 | Simultaneous charge/discharge mitigation | Stage B / **B1** | Declare; mitigate if negative prices in target market |
| 28 | Representative-period scheme | Stage B | Monthly representative periods |

---

## 27. Next Steps

This document establishes the **conceptual engineering definition** for Domain 4 — Dispatch & Optimization Engineering. It remains a **Development Draft (v0.7)**, close to baseline.

**Recommended sequence:**

```
A.2.4 v0.7 (this document)
      │
      ├── ENGIE clarification requests (§28)
      │
      ▼
A.2.5 — Degradation Engineering
      │
      ├── Define degradation interface (Dispatch → Degradation → Dispatch)
      │
      ▼
Return to A.2.4
      │
      ├── Incorporate ENGIE answers
      │
      ├── Incorporate A.2.5 interface
      │
      ▼
A.2.4 v1.0 — BASELINE
```

**Sequencing note.** A.2.5 does **not** wait for ENGIE's answers. It can be developed conceptually with open decisions marked as interfaces and uncertainties. Once ENGIE responds, cross-document integration is performed and A.2.4 is promoted to v1.0.

The Stage A.2 chapters:

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.1) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.2) |
| 3 | A.2.3 | Operational Engineering | ✅ Baselined (v1.2) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | 🔄 **This document — Draft (v0.7)** |
| 5 | A.2.5 | Degradation Engineering | ⏭ Next |
| 6 | A.2.6 | Financial Engineering | ⏭ Pending |
| 7 | A.2.7 | Data & Application Engineering | ⏭ Pending |

---

## 28. ENGIE Clarification Requests Relevant to Dispatch & Optimization

This section lists the **genuine clarifications** relevant to Dispatch & Optimization — those that materially depend on ENGIE's input. Decisions already resolved by the RFP or the Strategy are **not** asked again; technical engineering decisions made by the consultant are also **not** asked.

### 28.1 Clarifications Genuinely Requiring ENGIE's Input

These are **defaultable**, with working defaults per §26. They do not block the project; they inform Phase 1 prioritization.

| # | Clarification | Working default if not confirmed | Priority |
|---|---|---|---|
| 1 | **BESS sizing vs. evaluation.** Is the BESS size a fixed input, or is it a decision variable? Is the system expected to evaluate a predefined configuration, or to support sizing, augmentation, or configuration optimization? | **Evaluation** of a predefined configuration | **High** — changes the nature of the tool |
| 2 | **Primary model purpose / use case.** Is the primary purpose project screening, detailed project development, investment decision support, operational benchmarking, or a combination? | **Evaluation** (project development support) | Medium |
| 3 | **Model output granularity.** What level of operational output does ENGIE expect: interval-level dispatch schedules, aggregated daily / monthly performance metrics, annual project KPIs, or all of these levels? | **All levels** | Medium |
| 4 | **Active versus reactive priority.** When active and reactive power compete for the inverter's apparent-power envelope, does ENGIE have a predefined priority rule? | **Project / grid-code dependent**, declared per scenario | Medium |
| 5 | **Dispatch validation benchmark.** Does ENGIE have reference dispatch cases or expected outputs against which the optimization engine can be validated? | **None available** — validation against internal consistency checks and the thin slice | Medium |
| 6 | **Revenue attribution under simultaneous services.** When multiple value streams share the same dispatch, how does ENGIE expect operational behavior and value to be attributed? | **Rule-based** attribution (§13.3) | Medium |

### 28.2 Clarifications Already Resolved by the RFP or the Strategy

These items are **not** asked again:

- Co-optimization vs. separate dispatch + stacking — resolved by the RFP
- Lifecycle economics influence on dispatch — resolved by `SYS-STR-FRM-001` §6.4
- Dispatch methodology (D1) — default is LP
- Perfect foresight vs. forecast-based (D2) — default is perfect foresight; realization factor applied in Financial Engineering
- Time resolution (D14) — default is 15-minute when data permits
- Degradation feedback time scale (D3) — default is annual
- Market scope (B1) — tracked separately in the Phase 1 Register
- BTM vs. FTM (B2) — tracked separately in the Phase 1 Register

### 28.3 Technical Decisions Made by the Consultant

These are engineering decisions, not client decisions:

- Horizon structure (monthly for thin slice; refined in Stage B)
- Constraint formulation
- Hard vs. soft constraint treatment
- Scenario handling
- Where net load derivation is executed
- Attribution mechanism (rule-based for thin slice)
- Terminal SOC condition (terminal = initial)
- Representative-period scheme (monthly)
- Simultaneous charge/discharge mitigation approach

### 28.4 Note on Prioritization

No item in §28.1 is blocking. All have working defaults consistent with §26. The only item with elevated priority is **item 1 (BESS sizing vs. evaluation)**, because it changes the nature of the tool.

**Note.** These items will be assigned IDs when the **Phase 1 Clarification & Data Request Register** is issued as a standalone document. The Register will consolidate all clarifications across the seven domains, deduplicate overlaps, and provide ID, source domain, priority (blocking / defaultable), and status for each item.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.4 — Conceptual Engineering (Dispatch & Optimization Engineering)
**Status:** Conceptual Engineering — **Development Draft (v0.7)**
**Duration:** 12 Weeks
**Language:** English