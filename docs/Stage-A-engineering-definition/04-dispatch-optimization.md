
---

# Dispatch & Optimization Engineering
## Stage A.2.4 — Conceptual Engineering
### Coordination Layer of the BESS Operational & Financial Modeling System

**Document ID:** A.2.4-DISPATCH-ENG-001

**Version:** 0.8 — Development Draft

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Draft

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.8)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.5)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.2)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.3)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.2)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)

**Domain:** Domain 4 — Dispatch & Optimization Engineering

**Purpose:** Define, at a conceptual level, what the Dispatch & Optimization domain represents, what it consumes from upstream domains and the System Context, what it produces, how it coordinates competing value streams, how it handles uncertainty and degradation feedback, and what engineering decisions must be made in later stages — **without** prescribing formulations, solvers, or implementation details.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.4 — Conceptual Engineering** of the Dispatch & Optimization domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §4.

Its purpose is to establish the **conceptual engineering definition** of the domain that **coordinates** the value streams declared by Operational Engineering, within the physical capability declared by BESS Engineering, and under the external signals declared by Load & Market Engineering and the System Context.

It answers, at conceptual level:

- What Dispatch & Optimization is responsible for
- What it consumes from upstream domains and the System Context
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

| Layer | Decided in | What it fixes |
|---|---|---|
| **Methodology** | **Phase 1** | The class of approach: rule-based heuristic / LP / MILP / hybrid |
| **Architecture** | **Stage B** | Major components, responsibilities, interfaces, execution pattern |
| **Optimization formulation** | **Stage B / C** | Objective structure, constraint families, attribution mechanism, uncertainty treatment |
| **Detailed formulation** | **Stage C** | Variables, equations, linearization, solver configuration, tolerances |

### 1.2 Working Defaults

| Default | Source | Value |
|---|---|---|
| Dispatch methodology | Strategy D1 | **LP** |
| Perfect foresight vs. forecast-based | Strategy D2 | **Perfect foresight**; realization factor applied in Financial Engineering |
| Degradation feedback time scale | Strategy D3 | **Annual SOH update** with representative-period simulation |
| Voltage regulation coupling | Strategy D4 | **Fixed envelope** — no P² + Q² ≤ S² linearization |
| Time resolution | Strategy D14 | **15-minute when input data permits; hourly otherwise** |

### 1.3 The Most Important Boundary in This Document

> **Dispatch consumes context-derived signals and constraints produced by the relevant engineering domains. It does not own the external context.**

Dispatch selects and coordinates. It does not redefine physical capability, does not redefine external conditions, does not redefine operational requirements, and does not compute project financial value.

### 1.4 Relationship to Upstream Domains and System Context

| Source | What it provides to Dispatch |
|---|---|
| **BESS Engineering (A.2.1)** | Feasible operating envelope |
| **Load & Market Engineering (A.2.2)** | External signals: load, price signals, tariff value signals, program rules, grid constraints, eligibility, regulation statistics, scenario variations |
| **Operational Engineering (A.2.3)** | Operational requirements per value stream |
| **System Context** | External Context (generation, grid, load, market) and Project Configuration |
| **Degradation Engineering (A.2.5)** | Updated SOH, available capacity, marginal degradation cost (where produced) |

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Dispatch & Optimization domain** is the conceptual representation of the **coordination layer** that:

- Consumes physical capability, external signals, operational requirements, System Context, and degradation feedback
- Selects which value streams to activate at each moment
- Coordinates them under shared physical constraints
- Produces a feasible, coordinated dispatch schedule
- Produces the operational attribution basis for reporting
- Provides BESS power and SOC trajectories for post-dispatch net load and for Degradation Engineering
- Feeds forward to Financial Engineering

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| A physical model | Physical capability belongs to Domain 1 |
| A market model | External signals belong to Domain 2 |
| A generation or grid model | System Context, represented via Domain 2 |
| An operational mode definition | Value stream behavior belongs to Domain 3 |
| A degradation model | Degradation belongs to Domain 5 |
| A financial model | Economic valuation belongs to Domain 6 |
| A tariff engine | Tariff computation belongs to Domain 2 |
| A revenue calculator | Dispatch produces attributable operational quantities |
| A cycle-counting engine | Cycle counting (rainflow or equivalent) belongs to **Degradation Engineering (A.2.5)** |
| A software module | Software structure belongs to Stage B/C/D |

**Dispatch consumes context-derived signals. It does not own the external context. Dispatch provides battery power and SOC trajectories; it does not derive cycling metrics from them.**

### 2.3 Primary Question

> **Given the physical capabilities of the BESS, the applicable System Context, operational requirements, degradation state, and economic signals, how should the BESS be dispatched over time to satisfy constraints and coordinate competing value streams?**

### 2.4 Guiding Principle

> **Dispatch selects, coordinates, and produces the operational attribution basis. It never redefines what upstream domains have declared, and it never performs project financial valuation.**

---

## 3. Engineering Scope

| # | Aspect | Description |
|---|---|---|
| 1 | Selection | Which value streams are active at each moment |
| 2 | Coordination | How competing value streams share physical resources |
| 3 | Constraint satisfaction | Physical, operational, market, program, grid, System Context constraints |
| 4 | SOC management | Maintaining SOC within bounds across the horizon |
| 5 | Reserve management | Managing reserved capacity for future services or events |
| 6 | Uncertainty handling | How the dispatch accounts for imperfect foresight |
| 7 | Consumption of the degradation signal | Updated degradation state and, where applicable, marginal degradation cost |
| 8 | Operational attribution basis | Which value stream is responsible for each attributable portion of the dispatch |
| 9 | Battery power and SOC trajectory production | Provided for post-dispatch net load derivation and for Degradation Engineering |
| 10 | Operational result production | Producing the dispatch schedule, SOC trajectory, and context-related outputs |
| 11 | Evidence production | Producing evidence of constraint compliance |

**Dispatch does not redefine physical capability, external conditions, operational requirements, degradation, or project financial value.**

---

## 4. Conceptual Model of Dispatch

### 4.1 Input Structure

```
                    SYSTEM CONTEXT
                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
   Generation          Load            Market
        │               │                │
        └───────┬───────┼────────────────┘
                ▼
        Load & Market Engineering
                │
                │ context-derived
                │ signals / constraints
                ▼
 BESS Engineering ───────────────┐
                                 │
 Operational Engineering ────────┤
                                 ▼
                       DISPATCH & OPTIMIZATION
                                 │
                                 ▼
                           BESS Operation
```

**Project Configuration** acts transversally: determines which external dimensions are active and which constraints apply.

### 4.2 Dispatch Inputs Table

| Input | Origin | Role in Dispatch |
|---|---|---|
| BESS capability | A.2.1 | Physical feasibility |
| Generation | System Context via A.2.2 interface | Charging opportunity / constraint |
| Grid / Network | System Context via A.2.2 interface | Import / export constraint |
| Load / Demand | System Context via A.2.2 interface | Net-load objective |
| Market | System Context via A.2.2 interface | Price / product opportunity |
| Operational use cases | A.2.3 | Candidate services / objectives |
| SOH / available capacity | A.2.5 | Current physical capability |
| Marginal degradation cost | A.2.5 (where produced) | Economic dispatch signal |
| Project configuration | System Context | Applicable topology and constraints |

### 4.3 Dispatch Outputs

```
Dispatch Decision
       │
       ├── Charge / Discharge Power trajectory
       ├── SOC trajectory
       ├── Service allocation
       ├── Net load after dispatch
       ├── Grid exchange
       ├── Generation utilization / curtailment
       ├── Market participation
       ├── Revenue attribution
       └── Reserved capacity
                         │
                         ▼
                    A.2.5 Degradation
                    (derives cycling metrics)
```

**Note on cycling metrics.** Dispatch does **not** produce cycle counts, depth-of-discharge, or C-rate per cycle. It provides the **power and SOC trajectories**. Deriving cycling metrics from those trajectories (via rainflow or equivalent) is a responsibility of **Degradation Engineering** (`A.2.5-DEG-ENG-001` §5.1). This preserves the domain boundary: Dispatch decides what the battery does; Degradation interprets what that means for aging.

### 4.4 Dispatch Boundary

| Inside the domain | Outside the domain |
|---|---|
| Selection and coordination | Physical capability definition |
| Constraint satisfaction | External signal representation |
| SOC management | Operational requirement definition |
| Reserve management | Degradation computation |
| Uncertainty handling | Cycling metric derivation |
| Operational attribution basis | Project financial valuation |
| Dispatch schedule | Tariff computation |
| SOC trajectory | System Context definition |
| Battery power trajectory | Software implementation |

---

## 5. Inputs to Dispatch

### 5.1 From BESS Engineering (A.2.1)

| Input | Meaning |
|---|---|
| SOC and SOC bounds | Current state and admissible range |
| Available charge / discharge power | Maximum feasible power |
| Ramp limits | Maximum rate of change |
| Duration | Energy / power ratio |
| Reactive power capability | Apparent-power envelope |
| Availability | Time-dependent capability condition |
| Physical feasibility conditions | Envelope constraints |

### 5.2 From Load & Market Engineering (A.2.2)

| Input | Meaning |
|---|---|
| Load / projected load | Demand to be served or shaved |
| Energy price signals | External economic signal for energy flows |
| Tariff value signals | Energy rates, demand charge rates |
| Ancillary-service price signals | External economic signal for regulation / reserves |
| Capacity price signals | External economic signal for availability |
| Program compensation signals | DR payment structures |
| Voltage-support compensation signals | Where applicable |
| Power factor penalties / kVAR charges | Where applicable (`A.2.2` §9.4 element 11, added per **PH-021**) |
| DR program rules | Event windows, notification, penalties |
| Baseline methodology | Via program adapter |
| Grid constraints | Interconnection limits, export constraints |
| Eligibility | Participation conditions |
| Frequency regulation statistics | Energy per MW, signal bias, performance score |
| Scenario variations | Multiple load and price trajectories |

**Note.** The `Power factor penalties / kVAR charges` input is provided by Domain 2 only where the target tariff includes them (see **PH-021**). If the tariff does not include power factor penalties or kVAR charges, this input is inactive.

### 5.3 From Operational Engineering (A.2.3)

| Input | Source in A.2.3 | Meaning |
|---|---|---|
| Operational requirements | §5.5, §6.5, §7.5, §8.5, §9.5 | SOC floors, duration floors, reserve requirements, ramp requirements |
| Service requirements | §13.1 | Duration, ramp, response time |
| Service-level metrics | §5.6, §6.6, §7.6, §8.6, §9.6 | What each service is expected to deliver |
| Interaction declarations | §10.2 | Which resources are shared, which value streams compete |
| Degradation-relevant behavior declarations | §14.1 | Which behaviors generate degradation-relevant usage |

### 5.4 From System Context

| Context dimension | Signal / constraint received | Source domain |
|---|---|---|
| **Generation** | Available generation profile, charge opportunity, curtailment conditions | A.2.2 (context interface) — *architecture extension* |
| **Grid / Network** | Import / export limits, interconnection capacity | A.2.2 (context interface) |
| **Load / Demand** | Net load profile, peak / energy requirements | A.2.2 (context interface) |
| **Market** | Eligible products, market prices, participation rules | A.2.2 (via adapters) |
| **Project Configuration** | Applicable topology, coupling type, active external dimensions | Scenario Management |

### 5.5 From Degradation Engineering (A.2.5)

| Input | Meaning |
|---|---|
| Updated SOH | State of health at the applicable feedback point |
| Available capacity | Usable capacity given current SOH |
| Marginal degradation cost | Derived per-MWh signal (where produced by A.2.5) |
| Updated operating constraints | Constraints that change with SOH |

**Note on marginal degradation cost — annual offset.** The marginal degradation cost depends on SOH and lifetime throughput, which depend on the dispatch, which depends on the cost. This creates a **potential circularity**.

Under the working default of **annual SOH update** (Strategy D3), the circularity is broken by applying an **annual offset**: the marginal degradation cost consumed during year *n* is computed from the state at the **beginning of year *n***, using the SOH and lifetime throughput known at that point. This avoids fixed-point iteration and is the working assumption for the thin slice.

The precise derivation is defined in `A.2.5-DEG-ENG-001` §9. Dispatch consumes whatever signal A.2.5 produces.

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
| **Warranty-related** | BESS Engineering (operating restrictions) | Annual throughput limits (e.g. 365 EFC/year) where declared by warranty |

**Note on warranty throughput limits.** Many warranties constrain annual cycling (e.g. a maximum number of equivalent full cycles per year). Where declared by BESS Engineering as an operating restriction, this constraint binds Dispatch and must be represented. It originates from `A.2.1-BESS-ENG-001` §14, which lists "Warranty / operating restrictions" among the required BESS inputs.

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
- Warranty throughput limits (where declared)

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

**The realization factor is applied in Financial Engineering, not in Dispatch.** Dispatch produces the operational results under perfect foresight; Financial Engineering applies the realization factor when converting those results into reported project value.

The realization factor is applied **per stream** in Financial Engineering. It applies naturally to arbitrage and market-based revenues, whose realized value depends on forecast accuracy. It does not apply uniformly to behind-the-meter savings, whose risk is reflected through tariff mechanisms (ratchets, coincident-peak hit rate).

See A.2.6 for the application of the realization factor.

**Forecast-based dispatch** is an optional extension.

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
Dispatch
   │
   │ Battery power trajectory + SOC trajectory
   ▼
Degradation Engineering
   │
   │ derives cycling metrics from trajectories
   │ updates SOH, available capacity
   │ derives marginal degradation signal
   ▼
Dispatch (next year)
```

**Note on cycling metrics.** Dispatch provides **power and SOC trajectories**. Degradation Engineering derives cycling metrics — cycle counts, depth of discharge per cycle, C-rate per cycle — from those trajectories. Dispatch does **not** produce cycling metrics.

### 12.2 Working Default Feedback Time Scale

Under working default **D3**, the degradation state is updated **annually**, with representative-period simulation within each year.

- SOH is held constant **within** each simulated year
- SOH is updated **between** years based on the year's aggregated usage
- Representative periods are simulated with SOH held constant within the year; their degradation-relevant usage is subsequently aggregated to determine the annual state update

**Representative-period constraint — consistency with the monthly horizon.** Because peak shaving and demand charges depend on the **monthly billed peak**, representative periods must respect the billing period. Two options are consistent with the thin-slice configuration (§20):

| Option | Description |
|---|---|
| **Monthly representative periods** | Each simulated representative period is a **complete billing month**. The year is represented by a set of complete months. |
| **Twelve monthly simulations** | All twelve months of each year are simulated. This preserves full monthly resolution at higher computational cost. |

**Working default for the thin slice:** monthly representative periods. The choice between these two options is revisable in Stage B. **Where demand ratchets apply, representative-period reduction is not permitted** — all 12 months must be simulated (see Strategy D19 / **PH-040**).

**Annual weighting and calendar aging.** Under representative-period simulation, the annual degradation update must:

- **Weight** each representative period by the number of months it represents
- Compute **calendar aging on the full calendar year**, not only on the simulated periods

This avoids underestimating calendar aging and correctly handles the year's full time span.

### 12.3 Marginal Degradation Signal

If the selected dispatch methodology includes a degradation-related marginal signal in the objective, the signal is provided by Degradation Engineering. Whether such a signal exists is decided in A.2.5.

**Annual offset.** Under annual SOH update, the marginal degradation cost consumed during year *n* is computed from the state at the **beginning of year *n***. This breaks the circularity between signal, dispatch, and SOH. See §5.5.

### 12.4 What Is Not Decided Here

- The feedback time scale (Phase 1, **D3** / **PH-036**)
- Whether a marginal degradation signal exists (A.2.5)
- Whether that signal enters the objective (dispatch methodology decision)
- How the feedback is represented numerically

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

## 14. Battery Power and SOC Trajectory

### 14.1 Concept

Dispatch produces the **battery power trajectory** and the **SOC trajectory** over the horizon. From these trajectories:

- The **post-dispatch net load** is derived for tariff evaluation by Domain 2
- The **degradation-relevant battery usage** is derived by Degradation Engineering

```
Post-dispatch net load =
    Site load
  + BESS charging
  − BESS discharging
  + BESS auxiliary consumption
```

This formula expresses the **conceptual composition** only. It does not fix sign conventions, power reference point, or efficiency loss treatment.

### 14.2 Where the Net Load Derivation Is Executed

The composition is a **system-level** quantity. **Where** it is executed (Dispatch, Load & Market, or Data & Application) is a Stage B architecture decision.

### 14.3 Power Reference Point — Deferred to Stage B

The **power reference point** (AC-side vs. DC-side) affects how efficiency losses are represented. This is deferred to Stage B.

### 14.4 Degradation-Relevant Usage

Dispatch provides the battery power trajectory and SOC trajectory. **Degradation Engineering** derives from them the cycling metrics it needs (cycle counts, depth of discharge, C-rate per cycle).

Dispatch does **not** produce:
- Cycle counts
- Depth of discharge per cycle
- C-rate per cycle
- Equivalent full cycles

These are derivative quantities computed by Degradation Engineering from the trajectories.

---

## 15. Operational Result Production

### 15.1 Outputs

| Output | Nature |
|---|---|
| Dispatch schedule | Charge / discharge / rest per interval |
| SOC trajectory | SOC per interval |
| Battery power trajectory | Charge / discharge power per interval |
| Reserved capacity | Per stream, per interval |
| Operational attribution basis | Per stream, per interval |
| Constraint compliance evidence | For validation |

### 15.2 Downstream Consumption

| Output | Consumer |
|---|---|
| Dispatch schedule | Financial (attribution), Data & Application |
| SOC trajectory | Degradation (usage), Financial (indirect) |
| Battery power trajectory | Load & Market (net load derivation), Degradation (usage) |
| Operational attribution basis | Financial |
| Constraint compliance evidence | Validation |

---

## 16. Modeling Traps and Conceptual Approaches

| Trap | Conceptual Approach (working default) |
|---|---|
| **Demand charge monthly maximum** | The optimization horizon must be **≥ the billing period**. The billed peak is treated as a **variable of the problem** |
| **Regulation charging may create the billed peak (BTM)** | The **net load during regulation reserve** enters the same peak constraint as other net load components |
| **DR events not known in advance** | Handled via **reserved capacity during event windows** |
| **Coincident peak uncertainty** | Peak hours assumed **known**, with a **configurable hit-rate factor** |
| **Demand ratchets** | **Evaluated in the tariff engine**. Where ratchets apply, all 12 months are simulated (Strategy D19 / **PH-040**) |
| **P² + Q² ≤ S² nonlinear coupling** | **Fixed envelope** under working default **D4** |
| **Perfect foresight may overstate achievable value** | Perfect foresight is the **primary dispatch mode** (D2). The **realization factor** is applied in **Financial Engineering** |
| **Efficiency losses** | Represented as part of the physical model (A.2.1) |
| **Minimum spread threshold for arbitrage** | A **decision rule**. Under LP + perfect foresight, it emerges endogenously from the objective and the marginal degradation signal (where applicable) |
| **Terminal SOC at the end of the horizon** | **A terminal SOC condition is required.** Working default: **terminal SOC = initial SOC** at the end of each optimization horizon |
| **Simultaneous charge and discharge** | **Declare the trap and defer the mitigation choice to Stage B**, contingent on **PH-001** (target market). If the target market has no negative prices, the LP formulation is sufficient |
| **Marginal degradation signal circularity** | Signal depends on SOH and throughput, which depend on dispatch, which depends on the signal. **Annual offset**: the signal consumed during year *n* is computed from the state at the **beginning of year *n***. This breaks the circularity without requiring fixed-point iteration |
| **Cycle-counting is not Dispatch's job** | Dispatch provides power and SOC trajectories; Degradation derives cycling metrics |
| **Warranty throughput limits** | Where declared by BESS Engineering, annual throughput limits (e.g. EFC/year) bind Dispatch as operating constraints |

---

## 17. Methodology Options — Phase 1 Decision

### 17.1 Options

| Option | Characteristic |
|---|---|
| **Rule-based heuristic** | Deterministic and transparent |
| **Linear Programming (LP)** | Optimization of a linear formulation |
| **Mixed-Integer Programming (MILP)** | Optimization with discrete decisions |
| **Hybrid** | Combination of deterministic rules and optimization |

### 17.2 Selection Criteria (if ENGIE overrides the default)

- Problem complexity
- Computational requirements
- Transparency
- Accuracy
- Explainability
- Scenario requirements
- Data availability

### 17.3 What Is Not Decided Here

Methodology selection is a **Phase 1 decision** (**PH-034**). Working default is LP.

---

## 18. Interfaces with Upstream and Downstream Domains

### 18.1 Upstream Interfaces

| Domain | Contract |
|---|---|
| BESS Engineering (A.2.1) | Feasible operating envelope |
| Load & Market (A.2.2) | External signals, tariff value signals, regulation statistics, scenario variations |
| Operational Engineering (A.2.3) | Operational requirements, service requirements, metrics, interaction declarations |
| Degradation (A.2.5) | Updated SOH, available capacity, marginal degradation cost (where produced) |
| System Context | Generation signals, Grid constraints, Load signals, Market products (from Domain 2); Project Configuration (from Scenario Management) |

### 18.2 Downstream Interfaces

| Domain | Contract |
|---|---|
| Degradation (A.2.5) | Battery power trajectory, SOC trajectory (from which Degradation derives cycling metrics) |
| Load & Market (A.2.2) | Battery power trajectory (basis for post-dispatch net load derivation) |
| Financial (A.2.6) | Dispatch schedule, SOC trajectory, operational attribution basis, service-level metrics |

### 18.3 Boundary Discipline

| Domain | Declares | Dispatch |
|---|---|---|
| BESS Engineering | What is physically possible | Selects what is done within that space |
| Load & Market | The environment | Produces the operational response |
| Operational | Operational requirements | Selects the actual behavior |
| Degradation | State evolution and cycling metric derivation | Produces battery power and SOC trajectories |
| Financial | Valuation | Produces attributed operational results |

---

## 19. Validation Requirements (Conceptual)

### 19.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Physical constraint compliance | SOC bounds, power limits, ramp limits respected |
| Operational requirement compliance | SOC floors, duration floors, reserve requirements respected |
| Availability compliance | No operation during declared unavailable periods |
| **Warranty throughput compliance** | Annual throughput does not exceed declared limits (where applicable) |
| Energy balance | Energy charged, discharged, and stored consistent |
| Terminal SOC compliance | Terminal SOC condition satisfied at the end of each horizon |
| No simultaneous charge and discharge | No interval with both active (unless permitted by the target market's price regime) |
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
| Degradation interface | Battery power and SOC trajectories are complete and pass-through |
| Tariff engine interface | Battery power trajectory covers the full horizon |
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
| **Time resolution** | 15-minute when input data permits; hourly otherwise (**D14**) |
| **SOH update** | Held constant within each simulated year; updated between years (**D3**) |
| **Representative periods** | Monthly representative periods (see §12.2) |
| **Terminal SOC** | Terminal SOC = initial SOC at the end of each monthly horizon (see §16) |
| **Degradation signal** | Consumed if produced by A.2.5; otherwise omitted from the initial slice |
| **Attribution** | Rule-based (§13.3) |
| **Scenario handling** | Single scenario per simulation |
| **Foresight** | Perfect foresight (**D2**); realization factor applied in Financial Engineering |
| **Net load derivation** | Executed by the domain designated in Stage B (working assumption: Load & Market) |

### 20.2 Thin Slice Degradation Configuration

Per `A.2.5-DEG-ENG-001` §20, the thin slice uses the following degradation configuration:

| Dimension | Configuration |
|---|---|
| **Cycle fade** | Proportional to equivalent full cycles (EFC) |
| **Calendar fade** | Linear in time |
| **Update frequency** | Annual |
| **Augmentation** | None in the thin slice |
| **Marginal signal** | Constant = replacement cost ÷ lifetime throughput to EOL |

The semi-empirical model is introduced after the slice. This simple, defensible configuration supports the end-to-end demonstration.

### 20.3 What the Thin Slice Demonstrates

- The full causal chain: BESS → Dispatch → Tariff Engine → Financial
- The dispatch schedule, SOC trajectory, and battery power trajectory
- The operational attribution basis
- Net load for tariff evaluation
- At least one financial KPI (NPV) in the Databricks App

### 20.4 What the Thin Slice Does Not Include

- Frequency regulation
- Demand response
- Voltage regulation
- Multi-scenario dispatch
- Forecast-based dispatch
- Semi-empirical degradation model
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
| 5 | Degradation feedback is provided as a state and, where applicable, a signal | Consistent with `A.2.1` and `A.2.5` | Would require a different coupling |
| 6 | Perfect foresight is the primary dispatch mode; realization factor applied in Financial Engineering | Working default **D2** | Would change reporting approach |
| 7 | Post-dispatch net load is a derived system quantity | Preserves composition clarity | Would place derivation responsibility ambiguously |
| 8 | Representative periods respect the monthly billing period | Preserves peak-shaving value stream | Would invalidate demand charge calculations |
| 9 | **Cycling metrics are derived by Degradation Engineering, not by Dispatch** | Preserves domain boundary | Would blur Dispatch and Degradation |
| 10 | **Marginal degradation signal is applied with annual offset** | Breaks circularity under annual SOH update | Would require fixed-point iteration |

### 21.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Dispatch methodology | **PH-034** (default: LP) |
| 2 | Attribution mechanism | **Stage B** (default: rule-based) |
| 3 | DR event uncertainty treatment | **Stage B** (default: reserve-based) |
| 4 | Whether a degradation-related marginal signal exists | **A.2.5** |
| 5 | Whether P² + Q² ≤ S² is linearized | **D4** (default: fixed envelope) |
| 6 | Multi-timescale operation | **Stage B** (default: single resolution) |
| 7 | Horizon structure | **Stage B** (default: monthly for thin slice) |
| 8 | Where net load derivation is executed | **Stage B** |
| 9 | Model output granularity | **PH-028** |
| 10 | Primary model purpose / use case | **PH-027** |
| 11 | Terminal SOC condition | **Stage B** (default: terminal = initial) |
| 12 | Simultaneous charge/discharge mitigation | **Stage B** / **PH-001** |
| 13 | Representative-period scheme | **Stage B** / **PH-040** |

### 21.3 Phase 1 Clarification Dependencies

- **PH-001** — Target market(s)
- **PH-002** — BTM vs. FTM scope
- **PH-005** — Benchmark data
- **PH-006** — Acceptance thresholds
- **PH-034** — Dispatch methodology
- **PH-036** — Degradation feedback time scale
- **PH-040** — Representative-period scheme and ratchets

---

## 22. Conceptual Outputs of the Domain

| Output | Consumer | Nature |
|---|---|---|
| Dispatch schedule | Financial, Data & Application | Time series |
| SOC trajectory | Degradation, Financial, Data & Application | Time series |
| Battery power trajectory | Load & Market (net load derivation), Degradation | Time series |
| Reserved capacity per stream | Financial (attribution), Data & Application | Time series |
| Operational attribution basis | Financial | Per stream, per interval |
| Constraint compliance evidence | Validation | Structured evidence |
| Operational classification | Validation, reporting | Per interval |

**Note.** Dispatch does **not** output cycling metrics. Those are derived by Degradation Engineering from the power and SOC trajectories.

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
- What is the dispatch schedule, SOC trajectory, and battery power trajectory?

### 23.2 Does Not Answer

- What is physically possible?
- What is the external environment?
- What does each value stream require?
- How does the battery degrade?
- What are the cycling metrics? (Degradation derives them)
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
- Degradation equations, cycling metric derivation, marginal signal formulation
- Cash-flow formulation, NPV, IRR computation, tax treatment, realization factor application
- Software structure, data structures, storage representation
- Numerical methods (time discretization, horizon length, interpolation, solver parameters)
- Integration details, orchestration
- Market-specific rules

---

## 25. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.8 | §4.2 Thin slice, §5 Domain 4, §6.2 Causal Backbone, §6.4 Operational signals vs. investment assumptions, §8.2 Validation, §12.2 Defaults | Yes |
| `SYS-ENG-DEF-001` v0.5 | §9 Domain 4, §10.4 Single source of truth, §12 Inter-Domain Contract | Yes |
| `A.2.1-BESS-ENG-001` v1.2 | §6.4 Reactive power split, §8 Degradation interface, §9 Dispatch interface, §14 Required BESS input information | Yes |
| `A.2.2-LOAD-MKT-ENG-001` v1.3 | §8.3 Regulation statistics, §9 Tariff engine, §9.8 Single source of truth, §16 Dispatch interface | Yes |
| `A.2.3-OPS-ENG-001` v1.3 | §4 Requirements pattern, §10 Interactions, §13 Dispatch interface, §14 Degradation interface, §15 Attribution convention | Yes |
| `A.2.5-DEG-ENG-001` v0.2 | §2.3 Three concepts, §5.1 Cycling metrics derivation, §9 Marginal degradation signal | Yes |
| `PH1-REG-001` v1.1 | Register IDs | Yes |

---

## 26. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Working default |
|---|---|---|---|
| 1 | Dispatch methodology | **PH-034** | LP |
| 2 | Objective function form | Stage B / C | — |
| 3 | Constraint formulation | Stage B / C | — |
| 4 | Hard vs. soft constraint treatment | Stage B | Hard: SOC, power, ramp, availability, grid, warranty throughput |
| 5 | Linearization strategy | Stage B / C | — |
| 6 | Solver selection | Stage C | — |
| 7 | Attribution mechanism | Stage B | Rule-based |
| 8 | Uncertainty treatment | Stage B | Perfect foresight (**D2**) |
| 9 | DR event uncertainty treatment | Stage B | Reserve-based |
| 10 | Whether a degradation-related signal enters the objective | A.2.5 / **PH-034** | Joint decision |
| 11 | Whether P² + Q² ≤ S² is linearized | **D4** | Fixed envelope |
| 12 | Time resolution | **D14** | 15-min if data permits |
| 13 | Multi-timescale representation | Stage B | Single resolution |
| 14 | Horizon structure | Stage B | Monthly (thin slice) |
| 15 | Scenario handling in dispatch | Stage B | Single scenario |
| 16 | Where net load derivation is executed | Stage B | Load & Market |
| 17 | Constraint compliance evidence format | Stage B / C | — |
| 18 | Validation tolerances | Stage C / **PH-006** | — |
| 19 | Model output granularity | **PH-028** | All levels |
| 20 | Primary model purpose / use case | **PH-027** | Evaluation |
| 21 | Market scope | **PH-001** | — |
| 22 | BTM vs. FTM priority | **PH-002** | Both, with BTM priority for thin slice |
| 23 | BESS sizing vs. evaluation | **PH-026** | Evaluation |
| 24 | Co-optimization vs. separate dispatch + stacking | RFP | Co-optimization |
| 25 | Lifecycle economics influence on dispatch | Strategy §6.4 | Investment assumptions do not enter dispatch directly |
| 26 | Terminal SOC condition | Stage B | Terminal SOC = initial SOC |
| 27 | Simultaneous charge/discharge mitigation | Stage B / **PH-001** | Declare; mitigate if negative prices |
| 28 | Representative-period scheme | Stage B / **PH-040** | Monthly representative periods |
| 29 | **Marginal degradation signal annual offset** | Confirmed in this document | Applied |

---

## 27. Next Steps

This document establishes the **conceptual engineering definition** for Domain 4 — Dispatch & Optimization Engineering. It remains a **Development Draft (v0.8)** until the blocking items in `PH1-REG-001` are resolved.

**Recommended sequence:**

```
A.2.4 v0.8 (this document)
      │
      ├── ENGIE clarification responses (PH-001, PH-002, PH-034, PH-036, PH-040)
      │
      ▼
A.2.4 v1.0 — BASELINE
```

**Note.** A.2.4 v0.8 incorporates the A.2.5 interface. No further interface changes are expected before A.2.6 and A.2.7.

The Stage A.2 chapters:

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.2) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.3) |
| 3 | A.2.3 | Operational Engineering | ✅ Baselined (v1.3) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | 🔄 **This document — Draft (v0.8)** |
| 5 | A.2.5 | Degradation Engineering | ✅ Development Baseline (v0.2) |
| 6 | A.2.6 | Financial Engineering | ⏭ Next |
| 7 | A.2.7 | Data & Application Engineering | ⏭ Pending |

---

## 28. ENGIE Clarification Requests Relevant to Dispatch & Optimization

The following clarification items are relevant to this domain. They are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1), which is the authoritative consolidated list. This section lists only the items relevant to Dispatch & Optimization, by their **Register ID**.

### 28.1 Items requiring ENGIE input

| Register ID | Clarification | Working default |
|---|---|---|
| **PH-026** | BESS sizing vs. evaluation | Evaluation of a predefined configuration |
| **PH-027** | Primary model purpose | Evaluation |
| **PH-028** | Model output granularity | All levels |
| **PH-029** | Active vs. reactive priority | Project / grid-code dependent |
| **PH-030** | Dispatch validation benchmark | Internal consistency checks |
| **PH-031** | Revenue attribution under simultaneous services | Rule-based |

### 28.2 Items already resolved by RFP or Strategy

- Co-optimization vs. stacking (RFP)
- Lifecycle economics in dispatch (`SYS-STR-FRM-001` §6.4)
- Dispatch methodology — **PH-034** (default: LP)
- Perfect foresight vs. forecast-based — Strategy D2
- Time resolution — Strategy D14
- Degradation feedback time scale — **PH-036**
- Market scope — **PH-001**
- BTM vs. FTM — **PH-002**

### 28.3 Technical decisions made by the consultant

- Horizon structure
- Constraint formulation
- Hard vs. soft constraint treatment
- Scenario handling
- Where net load derivation is executed
- Attribution mechanism
- Terminal SOC condition
- Representative-period scheme
- **Marginal degradation signal annual offset**
- **Cycling metrics derivation belongs to Degradation, not Dispatch**

### 28.4 Note on prioritization

No item in §28.1 is blocking. All have working defaults consistent with `SYS-STR-FRM-001` §12.2. The only item with elevated priority is **PH-026** (BESS sizing vs. evaluation).

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.4 — Conceptual Engineering (Dispatch & Optimization Engineering)
**Status:** Conceptual Engineering — **Development Draft (v0.8)**
**Duration:** 12 Weeks
**Language:** English

---

