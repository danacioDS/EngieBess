# B.5-SW-ARCH-001 — Software Architecture (v0.4.1 — Baseline Frozen)

---

## STAGE-B-HLD-001 — System Architecture (HLD)

## §8 — B.5 Software Architecture

**Document ID:** B.5-SW-ARCH-001

**Version:** 0.4.1 — Baseline (Frozen)

**Section:** §8 — B.5 Software Architecture

**Status:** Stage B — Baseline (Frozen)

**Parent Documents:**

- SYS-STR-FRM-001 — System Strategy & Delivery Framework
- SYS-ENG-DEF-001 — Stage A.1 — System Component Definition
- A.2.1-BESS-ENG-001 — BESS Engineering
- A.2.2-LOAD-MKT-ENG-001 — Load & Market Engineering
- A.2.3-OPS-ENG-001 — Operational Engineering
- A.2.4-DISPATCH-ENG-001 — Dispatch & Optimization Engineering
- A.2.5-DEG-ENG-001 — Degradation Engineering
- A.2.6-FIN-ENG-001 — Financial Engineering
- A.2.7-DATA-APP-ENG-001 — Data & Application Engineering
- PH1-REG-001 — Phase 1 Clarification & Data Request Register
- STAGE-B-HLD-INDEX-001 — Stage B HLD Master Index and Scope Definition
- B.0-INTEGRATED-SYS-ARCH-001 — B.0 Integrated System Architecture (v0.3.3 Baseline Frozen)
- B.1-DATA-ARCH-001 — B.1 Data Architecture (v0.3 Baseline Frozen)
- B.2-MODEL-ARCH-001 — B.2 Model Architecture (v0.5.1 Baseline Frozen)
- B.3-OPT-ARCH-001 — B.3 Optimization Architecture (v0.6.1 Baseline Frozen)
- B.4-FIN-ARCH-001 — B.4 Financial Architecture (v0.4 Baseline Frozen)
- B.6-DBX-ARCH-001 — B.6 Databricks Architecture (v0.4 Baseline Frozen)

**Note on versions.** Parent document versions are not restated here; they are as declared in each document.

**Change log.** See §19 for detailed changes across versions.

---

## 1. Purpose and Boundary

### 1.1 Purpose of B.5

B.5 defines the **software architecture** of the system. It establishes:

- What **software units** exist
- What **service boundaries** exist
- What **API / interface boundaries** exist
- What **execution interfaces** exist
- What **configuration interfaces** exist
- Where the **application boundary** is
- What **architectural placement principles** apply for technology (Python, PySpark, SQL)
- How **architectural components map to software realizations**
- How **cross-cutting capabilities** are placed
- What **logical software types** are recognized
- What **testing boundaries** exist
- What **logical runtime / execution boundaries** exist

### 1.2 What B.5 Does Not Define

B.5 does not define:

- Class structures
- Method signatures
- Function signatures
- Module internal structure
- Exact algorithms
- Solver configuration
- Delta table schemas
- PySpark job definitions
- Databricks cluster configuration
- Deployment topology
- Notebook definitions
- CI/CD configuration
- Code

Those belong to Stage C (specification) and Stage D (implementation), with the physical deployment topology in B.6.

### 1.3 Boundary Rule

**Rule:** B.5 defines the **logical software architecture**. Stage C defines the **physical software specification**. Stage D implements it. B.6 determines the **physical deployment topology**.

### 1.4 Question Answered

B.5 answers: *How is the architecture (B.0–B.4) organized into software units that can be built, tested, and executed?*

---

## 2. Position Within Stage B

### 2.1 Position

B.5 sits **after B.4** (Financial Architecture) and **before B.6** (Databricks Architecture). It translates the architectural contracts defined in B.0–B.4 into software units.

| View | Depends on | Detail Level |
|------|------------|--------------|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| B.2 Model Architecture | B.0, B.1 | Component details |
| B.3 Optimization Architecture | B.0, B.2 | Dispatch details |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| **B.5 Software Architecture** | **B.0–B.4** | **Software details** |
| B.6 Databricks Architecture | B.0–B.5 | Platform details |

### 2.2 Constraints

**Rule:** B.5 constrains B.6 on software aspects. No view can contradict B.5's software architecture.

**Rule:** B.5 does not redefine components, responsibilities, interfaces, data families, model objects, optimization aspects, or financial rules already declared in B.0–B.4.

**Rule:** B.5 treats B.0–B.4 as **input contracts** and concentrates on translating those contracts into software architecture. It does not revise the engineering, optimization, or financial content of B.0–B.4.

### 2.3 Separation of Concerns

| Document | Question answered |
|----------|-------------------|
| B.0 | What system are we building? |
| B.1 | How is information organized? |
| B.2 | How is the model structured? |
| B.3 | How is optimization structured? |
| B.4 | How is financial valuation structured? |
| **B.5** | **How is the software organized?** |
| **B.6** | **How is it realized on Databricks?** |
| Stage C | What exactly must be built? |
| Stage D | How is it implemented? |

---

## 3. Software Architecture View

### 3.1 Overview

The software architecture organizes the **7 functional components**, the **6 cross-cutting capabilities**, and the **data architecture** into **software units** that can be built, tested, and executed.

```
                    APPLICATION BOUNDARY
                           │
                           ▼
                ┌───────────────────────┐
                │   APPLICATION LAYER   │
                │   (entry points,      │
                │    reporting, API)    │
                └───────────┬───────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │  EXECUTION CONTROL    │
                │  (orchestration)      │
                └───────────┬───────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
   ENGINEERING         DATA LAYER          GOVERNANCE
   PACKAGES            PACKAGES            PACKAGES
        │                   │                   │
        ▼                   ▼                   ▼
   bess_model          data_lifecycle       lineage
   load_market         execution_state      validation
   tariff              state_history        governance_data
   operational
   dispatch
   degradation
   financial
        │                   │                   │
        └───────────────────┼───────────────────┘
                            ▼
                ┌───────────────────────┐
                │   SHARED KERNEL       │
                │   (contracts, types,  │
                │    errors)            │
                └───────────────────────┘
```

**Key distinction:** Software units are **not** the same as architectural components. A component (B.0) may be realized by one or more software units; a cross-cutting capability (B.0) may be realized by one or more software units or shared libraries.

**Note:** The shared kernel diagram contains only `contracts`, `types`, and `errors`. It does **not** contain `config`. Configuration is handled by the `configuration` software unit (see §4.3 and §8).

### 3.2 Software Layers

| Layer | Description |
|-------|-------------|
| **Application Layer** | Entry points, reporting, external API |
| **Execution Control** | Orchestration of execution across units |
| **Engineering Packages** | Software realization of functional components |
| **Data Layer Packages** | Data lifecycle, execution state, state history |
| **Governance Packages** | Lineage, validation, governance_data |
| **Shared Kernel** | Cross-cutting contracts, types, errors |

**Rule:** These are **different software layers**. They are not the architectural layers defined in B.0, and they are not deployment topology (B.6).

### 3.3 Key Distinctions

| Concept | Definition |
|---------|------------|
| **Software unit** | A buildable, testable unit of software (package, library, service) |
| **Service boundary** | A boundary across which a service is exposed |
| **API boundary** | A boundary across which a function/interface is exposed |
| **Execution interface** | An interface used during execution orchestration |
| **Configuration interface** | An interface for injecting parameters |
| **Application boundary** | The boundary between the system and its users |
| **Architectural placement** | Which technology (Python, PySpark, SQL) implements a unit |

**Rule:** These are **different software concepts**. They are not components, not data families, and not architectural layers.

---

## 4. Package Architecture

### 4.1 Package Principle

**Rule:** B.5 defines the **initial logical software realization** of each architectural component of B.0. Each functional component shall have an explicit software realization boundary in B.5. A component may be realized by one or more software units.

**Rule:** Stage C may refine the **internal structure** of that realization without changing its architectural responsibility or interface contract. Any change to the **logical realization boundary** requires an explicit B.5 revision.

**Rule:** Software units communicate through **declared interfaces** (contracts). They do not rely on implicit shared state.

**Rule:** Software units are **stateless at runtime**. Model state is passed explicitly through execution interfaces (see §5.4).

**Conceptual chain:**

```
B.0
Component
   │
   ▼
B.5
Logical software realization
   │
   ▼
Stage C
Internal software specification
   │
   ▼
Stage D
Implementation
```

If Stage C discovers that a component needs to be split into three independent units, this is resolved by an explicit B.5 revision, not silently in Stage C.

### 4.2 Engineering Software Units

| Architectural component (B.0) | Initial software realization |
|-------------------------------|------------------------------|
| BESS Model | `bess_model` |
| Load & Market Model | `load_market` (with two internal sub-boundaries, see §4.6) |
| Tariff Engine | `tariff` |
| Operational Model | `operational` |
| Dispatch Engine | `dispatch` |
| Degradation Engine | `degradation` |
| Financial Engine | `financial` |

**Note on realization.** The mapping above is the **initial software realization** chosen by B.5. It is not an architectural rule that the mapping must be 1:1. Any change to it requires an explicit B.5 revision.

### 4.3 Cross-Cutting Software Units

| Capability (B.0) | Software realization |
|------------------|----------------------|
| Scenario Management | `scenario_mgmt` |
| Configuration | `configuration` |
| Validation | `validation` |
| Execution Control | `execution_control` |
| Lineage | `lineage` + `governance_data` (persistence) |
| Observability | `observability` |

### 4.4 Data Software Units

| Data category (B.1) | Software realization |
|---------------------|----------------------|
| Data Lifecycle | `data_lifecycle` |
| Execution State | `execution_state` |
| State History | `state_history` |
| Results | `state_history` + `governance_data` |
| Governance Data | `governance_data` |

**Note on naming.** `governance_data` is the **persistence** of governance data (lineage metadata, validation evidence, version metadata, scenario/run identity). It stores governance metadata and evidence produced by the relevant cross-cutting capabilities.

### 4.5 Application Software Unit

| Software realization | Responsibility |
|----------------------|----------------|
| `application` | Entry points (CLI, API), reporting, result presentation, Databricks App, exports (see §9.2) |

### 4.6 `load_market` — Dual Responsibility

Per B.4 §4.4 and B.2 v0.5.1 §7.2, the Load & Market Model executes the market/program adapters. In B.5, this is represented as **two internal sub-boundaries within `load_market`**:

```
load_market
├── signal_provider        (upstream of Dispatch)
└── settlement_adapter     (downstream of Dispatch)
```

| Sub-boundary | Responsibility | Source of truth |
|--------------|----------------|-----------------|
| `signal_provider` | Provides external conditions, prices, load, context-derived signals | A.2.2, B.2 §4.2 |
| `settlement_adapter` | Applies external rule sets (market / program) to internal data; produces settlement basis | A.2.2 §13.5, B.2 v0.5.1 §7.2, B.4 §4.4 |

**Rule:** The two sub-boundaries are **within the same software unit** because they share the same semantic domain (Domain 2), as declared in B.2 and B.4.

**Rule:** Whether the two sub-boundaries are physically separate **modules** is a **Stage C** decision. Whether they are physically separate **services or deployment units** is a **B.6** decision. B.5 declares only the logical sub-boundary.

### 4.7 Shared Kernel

| Software realization | Responsibility |
|----------------------|----------------|
| `kernel` | Shared contracts, shared types, error hierarchy, interfaces |

**Rule:** The shared kernel is **extremely small**. It contains:

- Shared types
- Contracts
- Errors
- Interfaces

**Rule:** The shared kernel contains **no business logic**. It does not contain BESS logic, dispatch logic, financial logic, utility logic, domain rules, or configuration.

**Rule:** Engineering units shall not depend on kernel implementations beyond the contracts and shared types required by their declared interfaces.

**Rule:** Configuration is handled by the `configuration` software unit, not by the kernel.

---

## 5. Service Boundaries

### 5.1 Service Principle

**Rule:** A **service boundary** is a boundary across which a software unit exposes functionality to another software unit, potentially across process or network boundaries.

**Rule:** Service boundaries are declared at the architectural level. Whether they are in-process function calls, inter-process calls, or network calls is a **B.6 (Databricks)** decision.

### 5.2 Service Classification

| Service class | Description | Example |
|---------------|-------------|---------|
| **Pure service** | Stateless, deterministic function | Tariff Engine bill computation |
| **State-carrying service** | Operates on model state that is passed explicitly as input and returned as output; holds no state in memory between calls | BESS Model, Degradation Engine |
| **Coordinating service** | Coordinates other services | Dispatch Engine |
| **Aggregating service** | Aggregates results | Financial Engine |
| **Infrastructure service** | Provides infrastructure | Execution Control, persistence |

### 5.3 Service Boundaries Declared in B.5

| Service | Software realization | Service class |
|---------|----------------------|---------------|
| BESS state service | `bess_model` | State-carrying |
| Load & Market signal service | `load_market.signal_provider` | Pure |
| Market / program settlement service | `load_market.settlement_adapter` | Pure |
| Tariff service | `tariff` | Pure |
| Operational requirements service | `operational` | Pure |
| Dispatch service | `dispatch` | Coordinating |
| Degradation service | `degradation` | State-carrying |
| Financial service | `financial` | Aggregating |
| Scenario service | `scenario_mgmt` | Infrastructure |
| Execution control service | `execution_control` | Infrastructure |

**Rule:** Service boundaries do not redefine interfaces declared in B.0–B.4. They expose those interfaces in a software unit.

### 5.4 Rule — State Externalization

**Rule:** All software units are **stateless at runtime**. Model state (SOC, SOH, cohorts, histories) is passed explicitly as input and output of each execution call and persisted through `execution_state`.

"Stateful" in B.2 describes the **model object**, not the **runtime service**. This is required for parallel execution (§10.3), where a unit may run on different workers for different scenarios or periods.

---

## 6. API / Interface Boundaries

### 6.1 Interface Principles

| Principle | Description |
|-----------|-------------|
| **Explicit** | Every interface is declared |
| **Contract-based** | Interfaces have defined contracts |
| **Directional** | Producer → Consumer |
| **Declared exchange** | Interfaces exchange declared inputs, outputs, state, and control information; implementation algorithms remain internal to the consuming software unit |
| **Versioned** | Interfaces are subject to controlled versioning |

### 6.2 Interface Categories

| Category | Description |
|----------|-------------|
| **Unit interface** | Public API of a software unit |
| **Service interface** | Interface exposed by a service |
| **Execution interface** | Interface used by execution orchestration |
| **Configuration interface** | Interface for injecting configuration |
| **Data interface** | Interface for reading/writing data |

### 6.3 Interface Ownership

**Rule:** Interfaces declared in B.0–B.4 are owned by the architecture. B.5 exposes them as software-unit interfaces. B.5 does not redefine their semantics.

**Rule:** Interfaces introduced in B.5 are **software interfaces** — they describe how software units expose the architectural interfaces, not new architectural semantics.

---

## 7. Execution Interfaces

### 7.1 Execution Model

Execution is coordinated by the **Execution Control** capability. Execution interfaces are the interfaces used by Execution Control to invoke components.

**Rule:** Execution Control **orchestrates** execution according to the execution lifecycle and dependency contracts defined by B.2–B.4.

**Rule on annual sequencing ownership.** B.3 owns the **semantic rule** for the annual SOH carry-forward (the state-update cycle chains the years together through the SOH evolution law). B.5 owns the **execution-level orchestration** of that dependency, i.e., `execution_control` ensures that the annual sequence is respected across years. Temporal sequencing and state carry-forward **semantics** remain governed by B.2 and B.3. B.5 does not redefine the semantics; it orchestrates the dependency.

**Rule:** B.5 does **not** prescribe a fixed component execution sequence.

**Conceptual coordination view (not a sequence):**

```
             Scenario
                │
                ▼
         Execution Control
                │
       ┌────────┼─────────┐
       ▼        ▼         ▼
     Inputs   State    Configuration
       │
       ▼
    Engineering
       │
       ▼
    Optimization
       │
       ▼
    State update
       │
       ├──────► Settlement
       │
       └──────► Financial
```

**Note.** The diagram shows **which responsibilities Execution Control coordinates**. It does **not** prescribe the order in which components are invoked. The actual dependency order is defined by B.2 (model temporal behavior), B.3 (optimization horizon and state carry-forward), and B.4 (financial translation).

### 7.2 Execution Interface Principle

| Principle | Description |
|-----------|-------------|
| **Uniform** | All components expose a uniform execution interface |
| **Lifecycle-aware** | Execution interfaces respect lifecycle (init / execute / state transition / terminate) |
| **State-explicit** | Execution interfaces declare what state they read and what state they emit |
| **Side-effect-declared** | Execution interfaces declare whether they produce side effects |

### 7.3 Execution Interface Categories

| Interface | Purpose |
|-----------|---------|
| **Initialize** | Load parameters, initial state, scenario config |
| **Execute** | Perform the component's computation |
| **State transition** | Update state based on execution results |
| **Terminate** | Persist final state, release resources |

**Rule:** These mirror the lifecycle phases declared in B.2 §8.

---

## 8. Configuration Interfaces

### 8.1 Configuration Principle

**Rule:** All configuration is injected through **configuration interfaces**. No component reads configuration from a global context.

**Rule:** Configuration is **layered**:

```
Scenario configuration
      │
      ▼
Component configuration
      │
      ▼
Default configuration
```

**Rule:** Configuration is **explicit** — components declare what configuration they need.

### 8.2 Configuration Interface Categories

| Interface | Purpose |
|-----------|---------|
| **Scenario configuration interface** | Scenario-level parameters |
| **Component configuration interface** | Component-level parameters |
| **Execution configuration interface** | Execution-level parameters (e.g., horizon) |
| **Infrastructure configuration interface** | Infrastructure parameters (e.g., persistence) |

### 8.3 Configuration Ownership

**Rule:** Configuration ownership mirrors architectural ownership (B.1 §7). Scenario Management owns scenario configuration. Components own their component configuration. Execution Control owns execution configuration.

---

## 9. Application Boundary

### 9.1 Application Principle

**Rule:** External actors interact with the system through **declared application or execution entry points**. Internal software units are **not directly exposed** as external interfaces.

**Rule:** The application boundary is one of the ways the system is invoked. Execution entry points (e.g., scheduled jobs, workflows) may be additional invocation mechanisms, declared in B.6.

### 9.2 Application Boundary Types

| Type | Description |
|------|-------------|
| **CLI** | Command-line interface |
| **API** | Programmatic interface |
| **Notebook** | Interactive execution (for analysis) |
| **Reporting** | Output presentation |
| **Web UI (Databricks App)** | Scenario configuration, run submission, dashboards and scenario comparison (RFP deliverable; physical realization in B.6) |
| **Exports** | PDF and Excel summary reports (RFP deliverable) |
| **Scheduled execution** | Declared in B.6 |

### 9.3 What Crosses the Application Boundary

| Crosses | Does not cross |
|---------|----------------|
| Scenario definitions | Internal state |
| Run requests | Component internals |
| Result queries | Execution internals |
| Configuration | Business logic |

---

## 10. Technology Placement

### 10.1 Technology Palette

The system uses **three primary technologies**:

| Technology | Use |
|------------|-----|
| **Python** | Core computation, engineering units, orchestration |
| **PySpark** | Parallelizable axes (scenarios, representative periods, sensitivities) |
| **SQL** | Data storage and query (executed on the platform, see B.6) |

### 10.2 Architectural Placement Principles

| Principle | Description |
|-----------|-------------|
| **Python for logic** | Business logic is expressed in Python |
| **PySpark for parallel axes** | Parallelizable axes use PySpark |
| **SQL for data** | Data storage, retrieval, and aggregation use SQL |
| **No business logic in SQL** | SQL does not encode business logic |
| **Single parallel owner** | Parallel fan-out has a single owning unit (`execution_control`) |
| **Parallel execution at boundaries** | Parallel execution is architecturally controlled at declared execution boundaries |

### 10.3 Parallelism Rule

**Rule:** Parallel execution is architecturally controlled at **declared execution boundaries** (scenarios, representative periods, sensitivities, per B.2 §9 and B.3 §8.4).

**Rule:** **`execution_control` is the sole owner** of execution-level parallel fan-out. Temporal sequencing and state carry-forward remain governed by the execution contracts defined in **B.2 and B.3**. No other unit performs parallel fan-out.

**Rule:** Implementation-level parallelism **within** a component (e.g., vectorization, multiprocessing, solver-level parallelism) is **deferred to Stage C / Stage D**, unless constrained by B.3.

### 10.4 Initial Placement

| Software realization | Primary technology | Reason |
|----------------------|-------------------|--------|
| `bess_model` | Python | Core computation |
| `load_market.signal_provider` | Python | Signal generation |
| `load_market.settlement_adapter` | Python | Adapter execution |
| `tariff` | Python | Bill computation |
| `operational` | Python | Requirements derivation |
| `dispatch` | Python | Optimization |
| `degradation` | Python | State evolution |
| `financial` | Python | Cash flow, KPIs |
| `scenario_mgmt` | Python | Scenario definition, identity and configuration |
| `configuration` | Python | Configuration loading |
| `validation` | Python | Validation logic |
| `execution_control` | Python + PySpark | **Sole owner** of execution-level parallel fan-out (scenarios, representative periods, sensitivities); orchestrates the annual sequence owned semantically by B.3 |
| `lineage` | Python + SQL | Lineage metadata |
| `observability` | Python | Logs, metrics, traces |
| `data_lifecycle` | PySpark + SQL | Data transformation at scale |
| `execution_state` / `state_history` / `governance_data` | Delta tables (written via Python / PySpark; queried via SQL) | Persistence |
| `application` | Python | Entry points |
| `kernel` | Python | Shared contracts |

**Rule:** This placement is the **initial realization**. It may be revised in Stage C or B.6 without violating B.5, as long as the principles in §10.2 and §10.3 are respected.

**Note:** `scenario_mgmt` is Python only. Parallel fan-out across scenarios is owned by `execution_control`, not by `scenario_mgmt`.

---

## 11. Component → Software Realization Mapping

### 11.1 Mapping Table

| Architectural component (B.0) | Software realization |
|-------------------------------|----------------------|
| BESS Model | `bess_model` |
| Load & Market Model | `load_market` (signal_provider + settlement_adapter) |
| Tariff Engine | `tariff` |
| Operational Model | `operational` |
| Dispatch Engine | `dispatch` |
| Degradation Engine | `degradation` |
| Financial Engine | `financial` |

### 11.2 Cross-Cutting Capability Mapping

| Capability (B.0) | Software realization |
|------------------|----------------------|
| Scenario Management | `scenario_mgmt` |
| Configuration | `configuration` |
| Validation | `validation` |
| Execution Control | `execution_control` |
| Lineage | `lineage` + `governance_data` |
| Observability | `observability` |

### 11.3 Data Category Mapping

| Data category (B.1) | Software realization |
|---------------------|----------------------|
| Data Lifecycle | `data_lifecycle` |
| Execution State | `execution_state` |
| State History | `state_history` |
| Results | `state_history` + `governance_data` |
| Governance Data | `governance_data` |

---

## 12. Cross-Cutting Capability Placement

### 12.1 Placement Principle

**Rule:** Cross-cutting capabilities are **not** a layer. They are **software units** and **libraries** placed across the software architecture.

| Capability | Placement |
|------------|-----------|
| Scenario Management | Unit + service (`scenario_mgmt`) |
| Configuration | Library (`configuration`) |
| Validation | Library + service (`validation`) |
| Execution Control | Service (`execution_control`) |
| Lineage | Library + persistence (`lineage` + `governance_data`) |
| Observability | Library (`observability`) |

### 12.2 Interaction with Engineering Units

**Rule:** Cross-cutting capabilities interact with engineering units through **explicit interfaces**. They do not reach into unit internals.

| Capability | Interaction |
|------------|-------------|
| Scenario Management | Injects scenario configuration into units |
| Configuration | Injects component configuration into units |
| Validation | Invokes validation hooks on units |
| Execution Control | Invokes execution lifecycle on units; owns parallel fan-out; orchestrates the annual sequence owned semantically by B.3 |
| Lineage | Receives lineage events from units |
| Observability | Receives observability events from units |

---

## 13. Testing Boundaries

### 13.1 Testing Principle

**Rule:** Each software unit is **independently testable**. A unit's tests do not require internals of other units.

**Rule:** Each unit exposes **test interfaces** — hooks for injecting test doubles.

### 13.2 Testing Levels

| Level | Scope | Boundary |
|-------|-------|----------|
| **Unit** | Single software unit | Unit interface |
| **Integration** | Two or more units | Service interfaces |
| **System** | Full system | Application boundary |
| **System invariants** | Cross-unit rules | Energy balance, attribution reconciliation, no double counting (B.4 §11), identical net-load composition on every path |
| **UAT** | Full system, user scenarios | Application boundary |

### 13.3 Relationship to Validation

**Rule:** Testing boundaries **support** the validation levels defined in B.0 and B.1. They are not equivalent to validation.

```
B.0 / B.1 validation requirements
              │
              ▼
        B.5 test boundaries
              │
              ▼
       Stage C test specifications
              │
              ▼
       Stage D test implementation
```

### 13.4 Testing Boundaries per Software Unit

| Unit | Test boundary |
|------|---------------|
| `bess_model` | Envelope, state transitions |
| `load_market.signal_provider` | Signal generation |
| `load_market.settlement_adapter` | Settlement basis production |
| `tariff` | Bill computation |
| `operational` | Requirements derivation |
| `dispatch` | Solution feasibility |
| `degradation` | SOH update |
| `financial` | Cash flow, KPIs |
| Cross-cutting | Behavior under configuration |
| Data units | Data transformation correctness |

---

## 14. Logical Runtime / Execution Boundaries

### 14.1 Boundary Principle

**Rule:** B.5 declares **logical runtime / execution boundaries**. B.6 determines the **physical deployment topology**.

**Rule:** A logical runtime boundary does not imply a 1:1 relationship with a physical deployment unit. In particular, a software unit may be realized across multiple physical deployment constructs (e.g., notebooks, Python packages, jobs, workflows, SQL, Delta tables, serving endpoints, Databricks Apps), and conversely.

### 14.2 Logical Runtime / Execution Units

| Logical unit | Description |
|--------------|-------------|
| **Application unit** | Entry point + reporting |
| **Execution unit** | Execution Control + engineering units |
| **Data unit** | Data lifecycle + persistence units |
| **Governance unit** | Lineage, validation, governance_data |

### 14.3 Boundary Principle

**Rule:** Logical runtime / execution boundaries follow the **logical grouping** declared in §14.2. The physical mapping is B.6's responsibility.

**Rule:** Logical runtime / execution units communicate through **service interfaces**, not through shared state.

---

## 15. Logical Software Types

### 15.1 Recognized Types

B.5 recognizes the following **logical software types**:

| Logical Type | Description | Example |
|--------------|-------------|---------|
| **Pure module** | Stateless, deterministic | `tariff` |
| **State-carrying service** | Operates on model state that is passed explicitly as input and returned as output; holds no state in memory between calls | `bess_model`, `degradation` |
| **Coordinating service** | Coordinates others | `dispatch` |
| **Aggregating service** | Aggregates results | `financial` |
| **Infrastructure service** | Provides infrastructure | `execution_control` |
| **Library** | Reusable code | `kernel`, `configuration` |
| **Adapter** | Applies external rule sets (market / program) to internal data | `load_market.settlement_adapter` |
| **Entry point** | Application boundary | `application` |

**Rule:** Logical software types are **software-level**. They do not replace architectural classification (B.0), model classification (B.2), or optimization types (B.3).

### 15.2 Deferred to Stage C

| Deferred to Stage C |
|---------------------|
| Class structures |
| Method signatures |
| Function signatures |
| Module internal structure |
| Exact algorithms |
| Solver configuration |

---

## 16. Explicit Non-Scope

| Not defined in B.5 | Belongs to |
|---------------------|------------|
| Class structures | Stage C |
| Method signatures | Stage C |
| Function signatures | Stage C |
| Module internal structure | Stage C |
| Exact algorithms | Stage C |
| Solver configuration | Stage C |
| Delta table schemas | Stage C |
| PySpark job definitions | Stage D |
| Databricks cluster configuration | B.6 |
| Deployment topology | B.6 |
| Notebook definitions | Stage D |
| CI/CD configuration | Stage D |
| Code | Stage D |

---

## 17. Interface Traceability

### 17.1 Interface Traceability Principle

**Rule:** B.5 does not redefine the interfaces declared in B.0–B.4. It exposes them at the software level.

### 17.2 Settlement Interfaces

The settlement interfaces declared in **B.2 v0.5.1 §7.2** and referenced in **B.4 §4.4** are exposed in B.5 through:

| Architectural interface | B.5 exposure |
|-------------------------|--------------|
| Dispatch Engine → Load & Market Model (attribution basis, for settlement) | `dispatch` → `load_market.settlement_adapter` |
| Load & Market Model → Financial Engine (settlement basis) | `load_market.settlement_adapter` → `financial` |

### 17.3 Double-Counting Prevention

**Rule:** The double-counting prevention rules declared in **B.4 §11** are enforced at the software boundary through the interface design — no unit may bypass the declared interfaces.

### 17.4 Interface Traceability Matrix

| Architectural interface | Source | B.5 exposure |
|-------------------------|--------|--------------|
| BESS → Dispatch | B.2 v0.5.1 §7.2 | `bess_model` → `dispatch` |
| BESS → Degradation | B.2 v0.5.1 §7.2 | `bess_model` → `degradation` |
| BESS → Tariff (auxiliary consumption) | B.2 v0.5.1 §7.2 | `bess_model` → `tariff` |
| Load & Market → Dispatch | B.2 v0.5.1 §7.2 | `load_market.signal_provider` → `dispatch` |
| Load & Market → Tariff (reference load) | B.2 v0.5.1 §7.2 | `load_market.signal_provider` → `tariff` |
| Operational → Dispatch | B.2 v0.5.1 §7.2 | `operational` → `dispatch` |
| Operational → Degradation | B.2 v0.5.1 §7.2 | `operational` → `degradation` |
| Dispatch → BESS | B.2 v0.5.1 §7.2 | `dispatch` → `bess_model` |
| Dispatch → Degradation | B.2 v0.5.1 §7.2 | `dispatch` → `degradation` |
| Dispatch → Tariff (battery power trajectory) | B.2 v0.5.1 §7.2 | `dispatch` → `tariff` |
| Dispatch → Financial (attribution basis) | B.2 v0.5.1 §7.2 | `dispatch` → `financial` |
| Dispatch → Load & Market (attribution basis, for settlement) | B.2 v0.5.1 §7.2 | `dispatch` → `load_market.settlement_adapter` |
| Load & Market → Financial (settlement basis) | B.2 v0.5.1 §7.2 | `load_market.settlement_adapter` → `financial` |
| Degradation → BESS | B.2 v0.5.1 §7.2 | `degradation` → `bess_model` |
| Degradation → Dispatch (marginal signal) | B.2 v0.5.1 §7.2 | `degradation` → `dispatch` |
| Degradation → Financial (physical events) | B.2 v0.5.1 §7.2 | `degradation` → `financial` |
| Tariff → Financial (bill and savings) | B.2 v0.5.1 §7.2 | `tariff` → `financial` |

---

## 18. Stage C / B.6 Handoff

### 18.1 Handoff Sequence

```
B.0 Integrated System Architecture
        │
        ├── B.1 Data Architecture
        ├── B.2 Model Architecture
        ├── B.3 Optimization Architecture
        ├── B.4 Financial Architecture
        │
        └── B.5 Software Architecture
                 │
                 ▼
        B.6 Databricks Architecture
                 │
                 ▼
              Stage C
                 │
                 ▼
              Stage D
```

### 18.2 What B.6 Receives from B.5

| B.6 receives | Description |
|--------------|-------------|
| Software units | The set of software units declared in §4 |
| Service boundaries | The service boundaries declared in §5 |
| Interface boundaries | The interface boundaries declared in §6 |
| Execution interfaces | The execution interface categories declared in §7 |
| Configuration interfaces | The configuration interface categories declared in §8 |
| Application boundary | The application boundary declared in §9 |
| Technology placement | The architectural placement principles of §10 |
| Logical runtime / execution boundaries | The logical runtime units of §14 |

### 18.3 What Stage C Receives from B.5

| Stage C receives | Description |
|------------------|-------------|
| Software units | The set of software units declared in §4 |
| Interface contracts | The interfaces exposed by each unit |
| Test boundaries | The test boundaries declared in §13 |
| Deferred decisions | The list of decisions deferred from §15.2 |

### 18.4 What B.5 Does Not Hand Off

B.5 does not hand off:

- Physical schemas
- Exact algorithms
- Class structures
- Function signatures
- Deployment topology
- Cluster configuration
- Code

Those are Stage C and Stage D responsibilities, with physical topology in B.6.

---

## 19. Change Log

### 19.1 Changes from v0.1 to v0.2

| # | Change | Reason |
|---|--------|--------|
| 1 | §4.1: replaced "One engineering package per functional component" with "Each functional component shall have an explicit software realization boundary" | Avoid rigid 1:1 rule; preserve Stage C freedom |
| 2 | §4.2: table re-labeled from "Mapping table" to "Initial software realization" | Clarify it is a decision, not an architectural rule |
| 3 | §4.6: added explicit `signal_provider` / `settlement_adapter` sub-boundaries within `load_market` | Preserve B.2/B.4 domain decision without prematurely fixing code structure |
| 4 | §4.4 / §11.2 / §12.1: renamed `governance` package to `governance_data` and clarified it is persistence of governance metadata | Avoid confusion with a capability |
| 5 | §4.7: strengthened kernel rule — no business logic, no utility logic, no domain rules | Prevent kernel from becoming a "common" dumping ground |
| 6 | §10.2 / §10.3: reframed technology placement as principles; softened "no parallelization inside components" to "parallel execution controlled at declared execution boundaries" | Avoid implementation-level overreach; preserve Stage C/D freedom |
| 7 | §14: reframed "package = deployment unit" as "logical deployment boundary"; removed "A package is deployed as a whole" | Physical topology is B.6's responsibility |
| 8 | §13.3: reframed testing levels as **supporting** validation levels, not mirroring them | Validation and testing are different concerns |
| 9 | §17 / §18: added explicit interface traceability matrix and Stage C / B.6 handoff | Make handoff explicit and traceable |
| 10 | Parent Documents: B.3 cited as **v0.5 Baseline Candidate**, with explicit note that B.5 does not depend on B.3 optimization semantics | Coherence with the version available at the time of writing |
| 11 | §10.4: table re-labeled "Initial placement" | Clarify it is a decision, not an architectural rule |

### 19.2 Changes from v0.2 to v0.3

| # | Change | Reason |
|---|--------|--------|
| 1 | Header note on B.3: replaced "B.5 does not depend on B.3 optimization semantics" with "B.5 does not redefine B.3 optimization semantics. Where B.5 references optimization-related execution, interfaces, or technology placement, those references are derived from the currently available B.3 baseline candidate and shall be reconciled if B.3 is subsequently revised or frozen." | B.5 does depend on some B.3 decisions; the correct claim is about not redefining |
| 2 | §4.1: added explicit conceptual chain B.0 → B.5 → Stage C → Stage D and clarified that changing the logical realization boundary requires an explicit B.5 revision | Resolve contradiction between §4.1 and §4.2; make the boundary rule explicit |
| 3 | §14: renamed "Logical Deployment Boundaries" to "Logical Runtime / Execution Boundaries" and "Logical Deployment Units" to "Logical Runtime / Execution Units" | Deployment topology is B.6's responsibility; B.5 defines logical runtime boundaries |
| 4 | §7.1: removed the prescriptive execution sequence; replaced with a conceptual coordination view and an explicit statement that B.5 does not prescribe a fixed component execution sequence | Avoid contradicting B.2/B.3 dependency order |
| 5 | §6.1: replaced "Versioned (see §19)" with "Versioned — interfaces are subject to controlled versioning" | §19 is Change Log, not interface versioning |
| 6 | §6.1: refined "Data, not logic" to "Interfaces exchange declared inputs, outputs, state, and control information; implementation algorithms remain internal to the consuming software unit" | More architecturally precise |
| 7 | §9.1: replaced "The application boundary is the only boundary through which the system is invoked" with "External actors interact with the system through declared application or execution entry points. Internal software units are not directly exposed as external interfaces." | Avoid over-constraining B.6 (jobs, workflows, apps) |
| 8 | §4.4 / §4.6: simplified `governance_data` definition to "stores governance metadata and evidence produced by the relevant cross-cutting capabilities" | Avoid expanding governance beyond what is needed |
| 9 | §3.1: removed `scenario_identity` from the governance packages diagram; §4.6: split "Stage C / B.6" decision into separate Stage C (modules) and B.6 (services / deployment units) decisions | Consistency of software units; separation of Stage C and B.6 responsibilities |

### 19.3 Changes from v0.3 to v0.4

| # | Change | Reason |
|---|--------|--------|
| 1 | §5.2, §5.3, §15.1: replaced "Stateful service" with "State-carrying service" (state passed explicitly as input/output; no in-memory state between calls); added §5.4 "Rule — State externalization" | Required for parallel execution (§10.3); "Stateful" in B.2 describes the model object, not the runtime service |
| 2 | §9.2: added "Web UI (Databricks App)" and "Exports (PDF / Excel)" as application boundary types | RFP deliverables; physical realization in B.6 |
| 3 | §10.2 / §10.3 / §10.4: declared `execution_control` as **sole owner** of execution-level parallel fan-out; `scenario_mgmt` changed to Python only; persistence units changed to "Delta tables (written via Python / PySpark; queried via SQL)" | Single owner of parallel fan-out; avoid two units both claiming Python + PySpark |
| 4 | §13.2: added "System invariants" testing level (energy balance, attribution reconciliation, no double counting (B.4 §11), identical net-load composition on every path) | Cross-unit invariant tests belong at the system level |
| 5 | §3.1: removed `config` from the shared kernel diagram; kernel now contains only contracts, types, errors | Configuration is handled by `configuration`, not the kernel |
| 6 | §15.1: changed "Adapter" description from "bridges two technologies" to "applies external rule sets (market / program) to internal data" | More accurate software description |
| 7 | §4.6: `settlement_adapter` description updated to "Applies external rule sets (market / program) to internal data" | Consistency with §15.1 |
| 8 | §10.4: persistence units changed from "SQL" to "Delta tables (written via Python / PySpark; queried via SQL)" | Reflect actual persistence technology; avoid implying raw SQL writes |
| 9 | §13.2 / §10.4: added "System invariants" and "Single parallel owner" to principles | Traceability of the invariant tests and parallel ownership |
| 10 | Header: B.3 cited as **v0.6 Baseline Frozen** (was v0.5 Baseline Candidate in earlier versions); removed the "reconciliation if B.3 revised" note | B.3 v0.6 is now frozen; no reconciliation clause needed |
| 11 | §7.1: added explicit "Rule on annual sequencing ownership" — B.3 owns semantics, B.5 orchestrates, B.6 realizes; §10.3 and §10.4 and §12.2 aligned with this rule | Prevent B.5 from re-appropriating B.3's annual-sequence semantics |
| 12 | §10.3: replaced "and of the annual sequence" with "Temporal sequencing and state carry-forward remain governed by the execution contracts defined in B.2 and B.3" | Align with B.3 v0.6 §8.4 and §9.5 |

### 19.4 Changes from v0.4 to v0.4.1

| # | Change | Reason |
|---|--------|--------|
| 1 | Header: version bumped from v0.4 to **v0.4.1 — Baseline (Frozen)** | Editorial patch; no architectural content changed |
| 2 | Header: B.3 cited as **v0.6.1 Baseline Frozen** (was v0.6) | Align with the frozen B.3 version |
| 3 | Header: B.6 added to Parent Documents with **v0.4 Baseline Frozen** | Completeness of the frozen Stage B tree |
| 4 | §17.4 (Interface Traceability Matrix): all 17 rows updated from `B.2 §7.2` to `B.2 v0.5.1 §7.2` | Consistency with §17.2, which already cited v0.5.1; complete the version traceability |
| 5 | §19.4: this change log entry added | Traceability of the editorial patch |
| 6 | §19.5: version history updated to include v0.4.1 | Traceability |

**Nature of the change.** Exclusively editorial. **No architectural content of v0.4 has been altered.** The software unit decomposition of §4, the service boundaries of §5, the state externalization rule of §5.4, the parallelization rule of §10.3, the testing levels of §13.2, and the interface traceability matrix of §17.4 (structural content) remain identical to v0.4. Only the version citations in §17.4 and the parent document list were updated.

### 19.5 Version History

| Version | Date | Changes | Status |
|---------|------|---------|--------|
| 0.1 | Stage B start | Initial B.5 draft | Superseded |
| 0.2 | Stage B review | 11 corrections | Superseded |
| 0.3 | Stage B review | 9 corrections (consolidation) | Superseded |
| 0.4 | Stage B review | 12 corrections (state externalization, app boundary, parallel owner, invariant tests, kernel cleanup, adapter description, persistence, B.3 v0.6 citation, annual sequencing ownership) | Superseded |
| 0.4.1 | Stage B closure | 6 editorial corrections (parent list completed, B.3 v0.6.1 citation, B.6 v0.4 citation, §17.4 version citations) | **Baseline (Frozen)** |

---

**End of §8 — B.5 Software Architecture (v0.4.1 — Baseline Frozen)**

**Status:** Baseline (Frozen)

**Next:** Stage B → Stage C Handoff

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

---


