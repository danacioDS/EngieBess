# STAGE-B-TO-C-HANDOFF-001 — Stage B → Stage C Handoff

**Document ID:** STAGE-B-TO-C-HANDOFF-001

**Version:** 0.1 — Draft for Review

**Status:** Stage B — Handoff (Draft for Review)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Language:** English

**Parent Documents:**

- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.3)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.4)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v1.0)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.4)
- `A.2.6-FIN-ENG-001` — Financial Engineering (v0.3)
- `A.2.7-DATA-APP-ENG-001` — Data & Application Engineering (v0.3)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)
- `STAGE-A-CONSOL-REPORT-001` — Stage A Consolidation Report (v1.1)
- `STAGE-B-HLD-INDEX-001` — Stage B HLD Master Index and Scope Definition (v0.2)
- `B.0-INTEGRATED-SYS-ARCH-001` — B.0 Integrated System Architecture (v0.3.3)
- `B.1-DATA-ARCH-001` — B.1 Data Architecture (v0.3)
- `B.2-MODEL-ARCH-001` — B.2 Model Architecture (v0.5.1)
- `B.3-OPT-ARCH-001` — B.3 Optimization Architecture (v0.6.1)
- `B.4-FIN-ARCH-001` — B.4 Financial Architecture (v0.4)
- `B.5-SW-ARCH-001` — B.5 Software Architecture (v0.4)
- `B.6-DBX-ARCH-001` — B.6 Databricks Architecture (v0.4)

**Purpose:** Formally hand off Stage B (System Architecture — HLD) to Stage C (Product Specification — Detailed Engineering). Declares what Stage B has frozen, what Stage C receives, what Stage C must produce, what Stage C must not redecide, and what remains open for Stage C to specify.

---

## 1. Stage B Closure Declaration

### 1.1 Declaration

> **Stage B — System Architecture (HLD)** of the ENGIE BESS Operational & Financial Modeling engagement is hereby declared **CLOSED**.

All seven architectural views have been produced, reviewed, and frozen:

| View | Document ID | Frozen Version |
|---|---|---|
| **B.0 Integrated System Architecture** | `B.0-INTEGRATED-SYS-ARCH-001` | v0.3.3 |
| **B.1 Data Architecture** | `B.1-DATA-ARCH-001` | v0.3 |
| **B.2 Model Architecture** | `B.2-MODEL-ARCH-001` | v0.5.1 |
| **B.3 Optimization Architecture** | `B.3-OPT-ARCH-001` | v0.6.1 |
| **B.4 Financial Architecture** | `B.4-FIN-ARCH-001` | v0.4 |
| **B.5 Software Architecture** | `B.5-SW-ARCH-001` | v0.4 |
| **B.6 Databricks Architecture** | `B.6-DBX-ARCH-001` | v0.4 |

The Stage B master index (`STAGE-B-HLD-INDEX-001` v0.2) is frozen and certifies the closure criteria.

### 1.2 What Has Been Frozen

Stage B has frozen the following architectural decisions:

| Domain | What is frozen |
|---|---|
| **Components** | The 7 functional components and their boundaries |
| **Cross-cutting capabilities** | The 6 capabilities that span the components |
| **Interfaces** | All inter-component interfaces, including the settlement chain |
| **Data categories** | The 3 architectural data categories |
| **State ownership** | Who owns state representation, evolution, and persistence |
| **Temporal behavior** | How each object evolves over time |
| **Optimization semantics** | Objective structure, constraint families, horizon framework, state transitions |
| **Degradation boundary** | What Dispatch consumes; what Degradation owns |
| **Financial rules** | Value sources, cash-flow structure, double-counting prevention |
| **Software units** | The package/service/interface decomposition |
| **Platform realization** | Environment classes, compute, data layout, orchestration, synchronization barriers |
| **Parallelization realization** | Intra-task distributed fan-out + synchronization barriers |

### 1.3 What Has NOT Been Frozen

The following remain **open** and are Stage C's responsibility:

- Physical data schemas, table definitions, column types
- Class structures, method signatures, function signatures
- Exact objective function form and constraint formulations
- Solver software selection and configuration
- Cash-flow equations, tax treatment, depreciation methodology
- API schemas, request/response formats
- Cluster sizing, autoscaling, instance types
- Exact Job / Task topology, Spark partitioning strategy
- Identity provider, permission matrix, secret management specifics
- CI/CD pipelines, deployment scripts (Stage D)
- Code (Stage D)

---

## 2. What Stage C Receives from Stage B

### 2.1 From B.0 — Integrated System Architecture

| Stage C receives | Source |
|---|---|
| The 7 functional components and their boundaries | B.0 §4 |
| The 6 cross-cutting capabilities | B.0 §5 |
| The conceptual architecture and layer separation | B.0 §3 |
| The inter-component interface declarations | B.0 §13 |
| The state and feedback architecture | B.0 §14 |
| The System Context propagation rules | B.0 §14.2 |
| The component summary table | B.0 §15 |
| The architectural definition and design principle | B.0 §18, §19 |

### 2.2 From B.1 — Data Architecture

| Stage C receives | Source |
|---|---|
| The 3 data architectural categories (Lifecycle, Execution, Governance) | B.1 §3 |
| The data lifecycle stages (Source → Ingested → Validated → Model-ready) | B.1 §4 |
| The Execution Data sub-categories (State, Runtime, History, Metadata, Results) | B.1 §5 |
| The Governance Data sub-categories (Lineage, Validation Evidence, Version Metadata, Scenario/Run Identity) | B.1 §6 |
| The dual ownership model (architectural vs semantic) | B.1 §7 |
| The data flows and interfaces | B.1 §8, §9 |
| The data quality dimensions and enforcement | B.1 §10 |
| The lineage, versioning, reproducibility requirements | B.1 §11 |
| The logical data types | B.1 §12 |
| The scenario isolation requirements | B.1 §13 |

### 2.3 From B.2 — Model Architecture

| Stage C receives | Source |
|---|---|
| The 7 computational objects and their classification | B.2 §4 |
| The state variables per object | B.2 §5 |
| The state ownership, evolution ownership, and persistence ownership | B.2 §5.2, §5.3 |
| The temporal behavior per object | B.2 §6 |
| The inter-model interface matrix and timing | B.2 §7 |
| The lifecycle phases per object | B.2 §8 |
| The parallelization boundaries and axes | B.2 §9 |
| The logical model types | B.2 §10 |

### 2.4 From B.3 — Optimization Architecture

| Stage C receives | Source |
|---|---|
| The objective structure and categories | B.3 §4 |
| The constraint families and default treatments | B.3 §5 |
| The revenue stacking and coordination rules | B.3 §6, §7 |
| The horizon framework (project, simulation, optimization, resolution) | B.3 §8.1 |
| The state-update cycle | B.3 §8.2 |
| The mapping rule between project horizon and representative periods | B.3 §8.1, §8.3 |
| The state carry-forward rules | B.3 §8.4 |
| The terminal SOC working default | B.3 §8.5 |
| The initial SOC per independent optimization rule | B.3 §8.5, §9.1 |
| The state transition rules | B.3 §9.5 |
| The degradation signal integration boundary | B.3 §10 |
| The solver boundary | B.3 §11 |
| The feasibility and infeasibility handling requirements | B.3 §12 |
| The logical optimization formulation types | B.3 §13 |

### 2.5 From B.4 — Financial Architecture

| Stage C receives | Source |
|---|---|
| The financial inputs (from Dispatch, Tariff, Degradation, Load & Market, Scenario Management) | B.4 §4 |
| The two primary value sources | B.4 §5.1 |
| The revenue categories and their sources | B.4 §5.2 |
| The realization factor treatment per stream | B.4 §5.3 |
| The cost categories and their sources | B.4 §6 |
| The charging energy cost treatment (not a separate line) | B.4 §6.3 |
| The cash-flow architecture | B.4 §7 |
| The terminal value requirement | B.4 §7.5 |
| The representative-period aggregation rule | B.4 §7.6 |
| The KPI definitions (NPV, project IRR, equity IRR, payback) | B.4 §8 |
| The financing parameters required for equity IRR | B.4 §9 |
| The commercial perspective support | B.4 §10 |
| The double-counting prevention rules (13 traps) | B.4 §11 |
| The logical financial types | B.4 §12 |

### 2.6 From B.5 — Software Architecture

| Stage C receives | Source |
|---|---|
| The software units and their initial realization | B.5 §4 |
| The `load_market` dual sub-boundary (`signal_provider` / `settlement_adapter`) | B.5 §4.6 |
| The service classification and boundaries | B.5 §5 |
| The state externalization rule | B.5 §5.4 |
| The API / interface boundaries | B.5 §6 |
| The execution interfaces and lifecycle | B.5 §7 |
| The configuration interfaces and layering | B.5 §8 |
| The application boundary types | B.5 §9 |
| The technology placement principles | B.5 §10 |
| The parallelization rule and single parallel owner | B.5 §10.3 |
| The component → software realization mapping | B.5 §11 |
| The cross-cutting capability placement | B.5 §12 |
| The testing boundaries and levels | B.5 §13 |
| The logical runtime / execution boundaries | B.5 §14 |
| The logical software types | B.5 §15 |
| The interface traceability matrix | B.5 §17 |

### 2.7 From B.6 — Databricks Architecture

| Stage C receives | Source |
|---|---|
| The environment classes (Development, Validation/UAT, Production) | B.6 §4.1 |
| The execution modes (Automated, Interactive, Application Serving) | B.6 §4.2 |
| The compute realization model (serverless compute, classic compute, serverless application infrastructure) | B.6 §4.3 |
| The governed namespace (Unity Catalog) | B.6 §5.1 |
| The initial schema layout | B.6 §5.2 |
| The Delta table families | B.6 §6.1 |
| The Delta table design principles | B.6 §6.2 |
| The scenario and run identity persistence requirement | B.6 §6.3 |
| The software-unit → Databricks placement mapping | B.6 §7.1 |
| The execution model realization (Initialize / Execute / State Transition / Terminate) | B.6 §7.2 |
| The parallelization realization (intra-task distributed fan-out) | B.6 §8.1 |
| The scenario-batching rule | B.6 §8.1 |
| The synchronization barriers (end-of-year, end-of-scenario) | B.6 §8.4 |
| The write-at-barrier rule | B.6 §8.4 |
| The application boundary realization | B.6 §9 |
| The governance, identity, secrets model | B.6 §10 |
| The observability and lineage realization | B.6 §11 |
| The scheduling and orchestration model | B.6 §12 |
| The runtime boundaries realization | B.6 §13 |
| The logical platform types | B.6 §14 |

---

## 3. What Stage C Must Produce

Stage C produces the **product specification** — the detailed engineering that turns the frozen architecture into an implementable system.

### 3.1 Specification Categories

| Category | What Stage C must specify | Source view |
|---|---|---|
| **Physical Data Specification** | Tables, schemas, column types, partitioning, Z-ordering, Delta properties, change data feed usage, physical lineage representation, external data integration mechanism | B.1, B.6 |
| **Physical Model Specification** | Class structures, state representations, model interfaces, exact numerical schemes, lifecycle implementation, model-level tests | B.2 |
| **Physical Optimization Specification** | Exact objective function, exact constraint formulations, linearization strategies, solver software selection, solver configuration, numerical tolerances, horizon implementation, initial SOC mechanism | B.3 |
| **Physical Financial Specification** | Cash-flow equations, discounting conventions, tax and depreciation methodology, ITC treatment, debt service calculation, distribution waterfall, terminal value computation, multiple-IRR handling | B.4 |
| **Physical Software Specification** | Class structures, method signatures, function signatures, module internal structure, configuration schema, API schemas, test specifications, CI/CD interface contracts | B.5 |
| **Physical Platform Specification** | Cluster sizing, instance types, autoscaling, Job / Task topology, Spark partitioning strategy, catalog naming, identity provider and permission matrix, concrete secret-management mechanism, API boundary realization mechanism, cost model, SLOs, platform NFRs | B.6 |
| **Testing and Validation Specification** | Unit tests, integration tests, system invariant tests, UAT scenarios, validation evidence format | B.5 |

### 3.2 Stage C Sequence (Indicative)

Stage C is expected to proceed in a sequence aligned with the dependency chain:

```
Stage C Plan
    │
    ▼
C.1 Physical Data Specification          (from B.1, B.6)
    │
    ▼
C.2 Physical Model Specification         (from B.2)
    │
    ▼
C.3 Physical Optimization Specification  (from B.3)
    │
    ▼
C.4 Physical Financial Specification     (from B.4)
    │
    ▼
C.5 Physical Software Specification      (from B.5)
    │
    ▼
C.6 Physical Platform Specification      (from B.6)
    │
    ▼
C.7 Testing and Validation Specification (from B.5)
    │
    ▼
Stage C → Stage D Handoff
```

**Note.** The sequence above is **indicative**. The actual Stage C sequence is declared in the **Stage C Plan** (entry point of Stage C).

---

## 4. What Stage C Must Not Redecide

The following are **frozen architectural decisions** from Stage B. Stage C **must not redefine** them. Any change requires an explicit **Stage B change request** and re-baselining.

### 4.1 Frozen Component and Boundary Decisions

| Frozen decision | Source |
|---|---|
| The 7 functional components and their boundaries | B.0 §4 |
| The 6 cross-cutting capabilities | B.0 §5 |
| The distinction between components, cross-cutting capabilities, and technical layers | B.0 §3.3 |
| The `load_market` dual sub-boundary (`signal_provider` / `settlement_adapter`) | B.5 §4.6 |

### 4.2 Frozen Interface Decisions

| Frozen decision | Source |
|---|---|
| The inter-component interfaces | B.0 §13 |
| The settlement chain (Dispatch → Load & Market → Financial) | B.2 §7.2, B.4 §4.4, B.5 §17.2 |
| The interface principle (data, not logic) | B.0 §13.2, B.1 §9.1, B.2 §7.1 |
| The execution interface categories | B.5 §7.3 |
| The configuration interface categories | B.5 §8.2 |

### 4.3 Frozen Data Decisions

| Frozen decision | Source |
|---|---|
| The 3 data architectural categories | B.1 §3 |
| The data lifecycle stages | B.1 §4 |
| The dual ownership model (architectural vs semantic) | B.1 §7 |
| The scenario isolation requirement | B.1 §13 |
| The data quality dimensions | B.1 §10 |
| The logical data types | B.1 §12 |

### 4.4 Frozen State and Temporal Decisions

| Frozen decision | Source |
|---|---|
| The state ownership model (BESS Model owns state; Degradation owns evolution; Dispatch owns trajectory) | B.0 §14.1, B.1 §5, B.2 §5.2 |
| The SOC trajectory authority (solver's SOC is authoritative; BESS Model adopts and validates) | B.2 §4.1 |
| The state externalization rule (all software units stateless at runtime) | B.5 §5.4 |
| The annual sequencing tripartite ownership (B.3 semantics / B.5 orchestration / B.6 realization) | B.3 §8.4, §9.5; B.5 §7.1; B.6 §7.4, §12.3 |
| The state carry-forward rules (nothing within year; SOH between years) | B.3 §8.4 |
| The terminal SOC working default | B.3 §8.5 |
| The initial SOC per independent optimization rule | B.3 §8.5, §9.1 |

### 4.5 Frozen Optimization Decisions

| Frozen decision | Source |
|---|---|
| The objective structure (market revenue + BTM savings signal + degradation cost) | B.3 §4 |
| The constraint families and default treatments | B.3 §5 |
| The revenue stacking concept and co-optimization default | B.3 §6 |
| The single-objective coordination default | B.3 §7 |
| The horizon framework (project, simulation, optimization, resolution) | B.3 §8.1 |
| The state-update cycle (annual SOH update) | B.3 §8.2 |
| The mapping requirement between project horizon and representative periods | B.3 §8.1, §8.3 |
| The degradation signal integration boundary | B.3 §10 |
| The solver boundary (solver produces solution; does not write state) | B.3 §11.4 |
| The LP working default | B.3 §11.3 |

### 4.6 Frozen Financial Decisions

| Frozen decision | Source |
|---|---|
| The two primary value sources (BTM savings from Tariff Engine; market revenues from Dispatch + Load & Market) | B.4 §5.1 |
| The Tariff Engine as single source of truth for BTM savings | B.4 §5.1 |
| The charging energy cost treatment (never a separate line) | B.4 §6.3 |
| The marginal degradation cost as signal, not cash flow | B.4 §6.5 |
| The KPI definitions (NPV, project IRR, equity IRR, payback) | B.4 §8 |
| The realization factor treatment per stream | B.4 §5.3 |
| The double-counting prevention rules (13 traps) | B.4 §11 |
| The nominal cash flow convention | B.4 §7.4 |
| The pre-tax working default (PH-043) | B.4 §6.4 |
| The project IRR primary / equity IRR configurable default (PH-042) | B.4 §8.2, §9.1 |

### 4.7 Frozen Software Decisions

| Frozen decision | Source |
|---|---|
| The software unit decomposition | B.5 §4 |
| The service classification and boundaries | B.5 §5 |
| The `execution_control` as sole owner of parallel fan-out | B.5 §10.3 |
| The technology placement principles (Python for logic, PySpark for parallel axes, SQL for data) | B.5 §10.2 |
| The application boundary types | B.5 §9.2 |
| The testing levels and their relationship to validation | B.5 §13 |
| The logical runtime / execution boundaries | B.5 §14 |

### 4.8 Frozen Platform Decisions

| Frozen decision | Source |
|---|---|
| The environment classes | B.6 §4.1 |
| The execution modes | B.6 §4.2 |
| The compute realization model | B.6 §4.3 |
| Unity Catalog as the governed namespace | B.6 §5.1 |
| The Delta table families | B.6 §6.1 |
| The parallelization realization (intra-task distributed fan-out) | B.6 §8.1 |
| The scenario-batching rule | B.6 §8.1 |
| The synchronization barriers (end-of-year, end-of-scenario) | B.6 §8.4 |
| The write-at-barrier rule | B.6 §8.4 |
| The Job / Task model (Jobs coordinating Tasks) | B.6 §7.2 |
| The annual sequence realized as a loop within the scenario-batch job | B.6 §7.4, §12.3 |
| The identity classes model | B.6 §10.2 |
| The observability and lineage separation | B.6 §11.2 |
| The logical platform types | B.6 §14.1 |

### 4.9 The Three Invariants That Must Not Collapse

| Invariant | Source |
|---|---|
| **Domain 2 owns the External Context interface** | B.0 §7.4, B.1 §7.3, B.2 §4.2, B.3 §5, B.4 §5.1, B.5 §4.6, B.6 §7.1 |
| **The three degradation concepts must not collapse** (physical degradation / marginal degradation cost / replacement cash flow) | B.0 §11.5, B.1 §5.1, B.2 §4.6, B.3 §10.4, B.4 §6.5 |
| **The two sources of truth for value** (BTM savings from Tariff Engine / market revenues from Dispatch + Load & Market) | B.0 §11.4, B.4 §5.1 |

---

## 5. What Remains Open for Stage C

The following are **deferrals** from Stage B. They are Stage C's responsibility to specify. The consolidated list is organized by category.

### 5.1 Physical Data Specification (from B.1, B.6)

| # | Deferred item | Source |
|---|---|---|
| D-01 | Physical schemas | B.1 §14 |
| D-02 | Delta tables and column definitions | B.1 §14 |
| D-03 | SQL DDL | B.1 §14 |
| D-04 | Physical data types | B.1 §12.2, §14 |
| D-05 | Partitioning and Z-ordering | B.1 §14, B.6 §14.2 |
| D-06 | Exact validation rules | B.1 §14 |
| D-07 | Exact transformation logic | B.1 §14 |
| D-08 | Remediation strategies | B.1 §14 |
| D-09 | Catalog number and naming | B.6 §5.1, §14.2 |
| D-10 | Scenario / run identity representation | B.6 §6.3, §14.2 |
| D-11 | External data integration mechanism | B.6 §5.4, §14.2 |

### 5.2 Physical Model Specification (from B.2)

| # | Deferred item | Source |
|---|---|---|
| D-12 | Class structures | B.2 §11 |
| D-13 | Method signatures | B.2 §11 |
| D-14 | Exact algorithms | B.2 §11 |
| D-15 | Solver configuration | B.2 §11 |
| D-16 | Numerical schemes | B.2 §11 |

### 5.3 Physical Optimization Specification (from B.3)

| # | Deferred item | Source |
|---|---|---|
| D-17 | Exact objective function | B.3 §14 |
| D-18 | Exact constraint formulations | B.3 §14 |
| D-19 | Linearization strategies | B.3 §14 |
| D-20 | Solver software selection | B.3 §14 |
| D-21 | Solver configuration | B.3 §14 |
| D-22 | Numerical tolerances | B.3 §14 |
| D-23 | Representative-period mapping mechanism | B.3 §8.1, §14 |
| D-24 | Initial SOC value and mechanism | B.3 §8.5, §14 |

### 5.4 Physical Financial Specification (from B.4)

| # | Deferred item | Source |
|---|---|---|
| D-25 | Exact cash-flow equations | B.4 §13 |
| D-26 | Tax treatment | B.4 §13 |
| D-27 | Depreciation methodology | B.4 §13 |
| D-28 | ITC treatment | B.4 §13 |
| D-29 | Debt service calculation | B.4 §13 |
| D-30 | Coverage ratios | B.4 §13 |
| D-31 | Distribution waterfall | B.4 §13 |
| D-32 | Discounting conventions | B.4 §13 |
| D-33 | Terminal value computation | B.4 §13 |
| D-34 | Multiple-IRR handling | B.4 §13 |

### 5.5 Physical Software Specification (from B.5)

| # | Deferred item | Source |
|---|---|---|
| D-35 | Class structures | B.5 §16 |
| D-36 | Method signatures | B.5 §16 |
| D-37 | Function signatures | B.5 §16 |
| D-38 | Module internal structure | B.5 §16 |
| D-39 | Exact algorithms | B.5 §16 |
| D-40 | Solver configuration | B.5 §16 |
| D-41 | API schemas | B.5 §16 |
| D-42 | Configuration schema | B.5 §16 |

### 5.6 Physical Platform Specification (from B.6)

| # | Deferred item | Source |
|---|---|---|
| D-43 | Cluster instance types and sizing | B.6 §14.2 |
| D-44 | Autoscaling parameters | B.6 §14.2 |
| D-45 | Job timeouts and retries | B.6 §14.2 |
| D-46 | API boundary realization mechanism | B.6 §9.4, §14.2 |
| D-47 | Secret-management mechanism (concrete) | B.6 §10.3, §14.2 |
| D-48 | Identity provider and permission matrix | B.6 §10.2, §14.2 |
| D-49 | Detailed cost model, SLOs, platform NFR parameters | B.6 §14.2 |
| D-50 | Exact Job / Task topology | B.6 §14.2 |
| D-51 | Physical realization of logical service boundaries | B.6 §14.2 |
| D-52 | Spark partitioning strategy | B.6 §8.1, §14.2 |

### 5.7 Testing and Validation Specification (from B.5)

| # | Deferred item | Source |
|---|---|---|
| D-53 | Unit test specifications | B.5 §13.3 |
| D-54 | Integration test specifications | B.5 §13.3 |
| D-55 | System invariant test specifications | B.5 §13.2 |
| D-56 | UAT scenario specifications | B.5 §13.3 |
| D-57 | Validation evidence format | B.5 §13.3 |

### 5.8 Deferred to Stage D

| # | Deferred item | Source |
|---|---|---|
| D-58 | PySpark job definitions | B.5 §16 |
| D-59 | Notebook definitions | B.5 §16 |
| D-60 | CI/CD configuration | B.5 §16 |
| D-61 | Code | B.5 §16 |
| D-62 | Job code and configuration | B.6 §14.3 |
| D-63 | Task code | B.6 §14.3 |
| D-64 | App code | B.6 §14.3 |
| D-65 | API boundary code | B.6 §14.3 |

---

## 6. Interface to Stage C

### 6.1 Entry Point

The entry point of Stage C is the **Stage C Plan**. The Stage C Plan declares:

- The Stage C deliverables
- The Stage C specification sequence
- The Stage C review and freeze process
- The Stage C → Stage D Handoff criteria

### 6.2 What Stage C Consumes

Stage C consumes the **frozen Stage B baseline**:

| Consumes | From |
|---|---|
| The architectural contract | B.0 |
| The data architecture | B.1 |
| The model architecture | B.2 |
| The optimization architecture | B.3 |
| The financial architecture | B.4 |
| The software architecture | B.5 |
| The Databricks architecture | B.6 |
| The frozen versions table | `STAGE-B-HLD-INDEX-001` v0.2 |
| The consolidated deferrals | This document §5 |

### 6.3 What Stage C Does Not Consume

Stage C does **not** consume:

- Any superseded draft of B.0–B.6
- Any document outside the frozen Stage B baseline
- Any PH item that has not been resolved

**Note on unresolved PH items.** The blocking PH items (PH-001 to PH-006) may not be resolved at the time Stage C begins. Stage C must proceed with the working defaults declared in the frozen Stage B baseline, and adjust if and when the PH items are resolved. Any adjustment that affects a frozen Stage B decision requires a Stage B change request.

### 6.4 Handoff Sequence

```
STAGE A — ENGINEERING DEFINITION
   │
   │ ✅ CLOSED (tag: stage-a-closed)
   │
   ▼
STAGE B — SYSTEM ARCHITECTURE (HLD)
   │
   ├── B.0 Integrated System Architecture          ✅ v0.3.3 Frozen
   ├── B.1 Data Architecture                       ✅ v0.3 Frozen
   ├── B.2 Model Architecture                      ✅ v0.5.1 Frozen
   ├── B.3 Optimization Architecture               ✅ v0.6.1 Frozen
   ├── B.4 Financial Architecture                  ✅ v0.4 Frozen
   ├── B.5 Software Architecture                   ✅ v0.4 Frozen
   ├── B.6 Databricks Architecture                 ✅ v0.4 Frozen
   │
   ├── STAGE-B-HLD-INDEX-001                       ✅ v0.2 Frozen
   │
   ├── STAGE-B-TO-C-HANDOFF-001 (this document)    ✅ v0.1 Draft for Review
   │
   └── Stage B Closure                             ✅ Declared (§1.1)
        │
        ▼
STAGE C — PRODUCT SPECIFICATION
   │
   ├── Stage C Plan                                ⏭ Entry point
   ├── C.1 Physical Data Specification             ⏭ Pending
   ├── C.2 Physical Model Specification            ⏭ Pending
   ├── C.3 Physical Optimization Specification     ⏭ Pending
   ├── C.4 Physical Financial Specification        ⏭ Pending
   ├── C.5 Physical Software Specification         ⏭ Pending
   ├── C.6 Physical Platform Specification         ⏭ Pending
   ├── C.7 Testing and Validation Specification    ⏭ Pending
   │
   └── Stage C → Stage D Handoff                   ⏭ Pending
        │
        ▼
STAGE D — IMPLEMENTATION
```

---

## 7. Review and Acceptance

### 7.1 Handoff Review Criteria

| # | Criterion | Status |
|---|---|---|
| 1 | All 7 Stage B views are cited with their frozen versions | ✅ |
| 2 | All parent citations in the handoff are correct | ✅ |
| 3 | What Stage C receives is complete | ✅ |
| 4 | What Stage C must produce is declared | ✅ |
| 5 | What Stage C must not redecide is declared | ✅ |
| 6 | What remains open for Stage C is consolidated | ✅ |
| 7 | The three invariants are explicitly declared | ✅ |
| 8 | The handoff sequence is declared | ✅ |
| 9 | The entry point of Stage C is declared | ✅ |
| 10 | The unresolved PH items are noted | ✅ |

### 7.2 Handoff Status

| Aspect | Status |
|---|---|
| **Stage B closure declaration** | ✅ Declared |
| **Stage B frozen baseline** | ✅ Certified |
| **Stage C entry point** | ✅ Declared |
| **Consolidated deferrals** | ✅ Declared |
| **Frozen decisions** | ✅ Declared |
| **Handoff review** | ⏭ Pending |

### 7.3 Acceptance

This handoff is **accepted** when:

- The Stage B closure declaration is confirmed
- The frozen Stage B baseline is confirmed
- The Stage C Plan is produced

---

## 8. Change Log

### 8.1 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage B closure | Initial handoff produced | **Draft for Review** |

### 8.2 Change Procedure

- **Adding a frozen decision:** must be justified; requires handoff version bump
- **Adding a deferral:** must be justified; requires handoff version bump
- **Changing the handoff scope:** requires review and version bump
- **Changing a frozen Stage B decision:** requires Stage B change request and re-baselining

---

## 9. Sign-Off

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

**Stage:** B — System Architecture (HLD)

**Document:** `STAGE-B-TO-C-HANDOFF-001`

**Version:** 0.1 — Draft for Review

**Status:** Draft for Review

**Stage B Status:** CLOSED

**Next Stage:** Stage C — Product Specification

**Next Step:** Produce Stage C Plan

**Language:** English

---

**End of STAGE-B-TO-C-HANDOFF-001 — Stage B → Stage C Handoff (v0.1 — Draft for Review)**

**Status:** Draft for Review

**Next:** Stage C Plan

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1