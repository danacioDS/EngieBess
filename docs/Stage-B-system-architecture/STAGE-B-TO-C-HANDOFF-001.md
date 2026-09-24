
---

# STAGE-B-TO-C-HANDOFF-001 — Stage B → Stage C Handoff (v0.2 — Baseline Frozen)

**Document ID:** STAGE-B-TO-C-HANDOFF-001

**Version:** 0.2 — Baseline Frozen

**Status:** Stage B — Handoff (Baseline Frozen)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Language:** English

**Parent Documents:**

- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6.1)
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
- `B.5-SW-ARCH-001` — B.5 Software Architecture (v0.4.1)
- `B.6-DBX-ARCH-001` — B.6 Databricks Architecture (v0.4)

**Purpose:** Formally hand off Stage B (System Architecture — HLD) to Stage C (Product Specification — Detailed Engineering). Declares what Stage B has frozen, what Stage C receives, what Stage C must produce, what Stage C must not redecide, and the **formal reconciled list of deferrals** (D-01 to D-65) that Stage C must address.

**Change log.** See §10.

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
| **B.5 Software Architecture** | `B.5-SW-ARCH-001` | v0.4.1 |
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
| **Data Specification** | Data domains, logical entities, physical schemas, column definitions, keys, constraints, time semantics, scenario/run identity, partitioning, Z-ordering, Delta behavior, lineage, ingestion mechanism, validation, acceptance criteria | B.1, B.6 |
| **Computational Model Specification** | Logical class/service identity, inputs, outputs, state, preconditions, postconditions, invariants, interface contracts, data and type requirements, error behavior, numerical schemes, lifecycle | B.2 |
| **Optimization Specification** | Objective structure, constraint formulations, decision variables, solver selection constraints, solver configuration, numerical tolerances, horizon implementation, initial SOC mechanism, feasibility handling | B.3 |
| **Financial Specification** | Cash-flow structure, revenue attribution, discounting conventions, tax and depreciation methodology, ITC treatment, debt structure, distribution waterfall, terminal value, multiple-IRR handling | B.4 |
| **Software Specification** | Software unit structure, API contracts, request/response schemas, service boundaries, authentication requirements, interface behavior, error contracts, configuration schema, test specifications | B.5 |
| **Platform Specification** | API hosting mechanism, Databricks App realization, networking, identity integration, secrets, compute, Jobs/Tasks topology, catalogs, permissions, platform NFRs, cost model, SLOs | B.6 |
| **Testing and Validation Specification** | Consolidated test strategy, UAT scenarios, validation evidence format — consolidating the acceptance criteria defined within each Stage C deliverable | B.5 |

### 3.2 Stage C Sequence (Indicative)

Stage C is expected to proceed in a sequence aligned with the dependency chain:

```
Stage C Plan
    │
    ▼
C.1 Data Specification                  (from B.1, B.6)
    │
    ▼
C.2 Computational Model Specification   (from B.2)
    │
    ▼
C.3 Optimization Specification          (from B.3)
    │
    ▼
C.4 Financial Specification             (from B.4)
    │
    ▼
C.5 Software Specification              (from B.5)
    │
    ▼
C.6 Platform Specification              (from B.6)
    │
    ▼
C.7 Testing and Validation Specification (from B.5)
    │
    ▼
Stage C → Stage D Handoff
```

**Note.** The sequence above is **indicative** (nominal production order). Cross-deliverable iteration is permitted where a downstream specification reveals a dependency, inconsistency, or missing requirement affecting an upstream specification. Such iteration is controlled through change control and does not constitute unrestricted redesign. The actual Stage C sequence is declared in the **Stage C Plan** (entry point of Stage C).

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

## 5. What Remains Open for Stage C — Reconciled Deferral List

### 5.1 Formal Deferral List (D-01 to D-65)

The following is the **formal reconciled list** of deferrals from Stage B. Each deferral is assigned:

- A **Deferral ID** (continuous numbering D-01 to D-65)
- A **description**
- A **source** (which Stage B view and section declares it)
- A **Stage C deliverable** (C.1 to C.7) where it is addressed
- A **Stage D flag** (yes/no) if the deferral itself is further deferred to Stage D

| ID | Deferral | Source | Stage C deliverable | Stage D? |
|---|---|---|---|---|
| **D-01** | Physical schemas | B.1 §14 | C.1 | No |
| **D-02** | Delta tables and column definitions | B.1 §14 | C.1 | No |
| **D-03** | SQL DDL | B.1 §14 | C.1 | No |
| **D-04** | Physical data types | B.1 §12.2, §14 | C.1 | No |
| **D-05** | Partitioning and Z-ordering | B.1 §14, B.6 §14.2 | C.1 | No |
| **D-06** | Exact validation rules | B.1 §14 | C.1 | No |
| **D-07** | Exact transformation logic | B.1 §14 | C.1 | No |
| **D-08** | Remediation strategies | B.1 §14 | C.1 | No |
| **D-09** | Catalog number and naming | B.6 §5.1, §14.2 | C.1 | No |
| **D-10** | Scenario / run identity representation | B.6 §6.3, §14.2 | C.1 | No |
| **D-11** | External data integration mechanism | B.6 §5.4, §14.2 | C.1 | No |
| **D-12** | Class structures | B.2 §11 | C.2 | No |
| **D-13** | Method signatures | B.2 §11 | C.2 | No |
| **D-14** | Exact algorithms | B.2 §11 | C.2 | No |
| **D-15** | Solver configuration (model-side) | B.2 §11 | C.2 | No |
| **D-16** | Numerical schemes | B.2 §11 | C.2 | No |
| **D-17** | Exact objective function | B.3 §14 | C.3 | No |
| **D-18** | Exact constraint formulations | B.3 §14 | C.3 | No |
| **D-19** | Linearization strategies | B.3 §14 | C.3 | No |
| **D-20** | Solver software selection | B.3 §14 | C.3 | No |
| **D-21** | Solver configuration | B.3 §14 | C.3 | No |
| **D-22** | Numerical tolerances | B.3 §14 | C.3 | No |
| **D-23** | Representative-period mapping mechanism | B.3 §8.1, §14 | C.3 | No |
| **D-24** | Initial SOC value and mechanism | B.3 §8.5, §14 | C.3 | No |
| **D-25** | Exact cash-flow equations | B.4 §13 | C.4 | No |
| **D-26** | Tax treatment | B.4 §13 | C.4 | No |
| **D-27** | Depreciation methodology | B.4 §13 | C.4 | No |
| **D-28** | ITC treatment | B.4 §13 | C.4 | No |
| **D-29** | Debt service calculation | B.4 §13 | C.4 | No |
| **D-30** | Coverage ratios | B.4 §13 | C.4 | No |
| **D-31** | Distribution waterfall | B.4 §13 | C.4 | No |
| **D-32** | Discounting conventions | B.4 §13 | C.4 | No |
| **D-33** | Terminal value computation | B.4 §13 | C.4 | No |
| **D-34** | Multiple-IRR handling | B.4 §13 | C.4 | No |
| **D-35** | Class structures | B.5 §16 | C.5 | No |
| **D-36** | Method signatures | B.5 §16 | C.5 | No |
| **D-37** | Function signatures | B.5 §16 | C.5 | No |
| **D-38** | Module internal structure | B.5 §16 | C.5 | No |
| **D-39** | Exact algorithms | B.5 §16 | C.5 | No |
| **D-40** | Solver configuration (software-side) | B.5 §16 | C.5 | No |
| **D-41** | API schemas | B.5 §16 | C.5 | No |
| **D-42** | Configuration schema | B.5 §16 | C.5 | No |
| **D-43** | Cluster instance types and sizing | B.6 §14.2 | C.6 | No |
| **D-44** | Autoscaling parameters | B.6 §14.2 | C.6 | No |
| **D-45** | Job timeouts and retries | B.6 §14.2 | C.6 | No |
| **D-46** | API boundary realization mechanism | B.6 §9.4, §14.2 | C.6 | No |
| **D-47** | Secret-management mechanism (concrete) | B.6 §10.3, §14.2 | C.6 | No |
| **D-48** | Identity provider and permission matrix | B.6 §10.2, §14.2 | C.6 | No |
| **D-49** | Detailed cost model, SLOs, platform NFR parameters | B.6 §14.2 | C.6 | No |
| **D-50** | Exact Job / Task topology | B.6 §14.2 | C.6 | No |
| **D-51** | Physical realization of logical service boundaries | B.6 §14.2 | C.6 | No |
| **D-52** | Spark partitioning strategy | B.6 §8.1, §14.2 | C.6 | No |
| **D-53** | Unit test specifications | B.5 §13.3 | C.7 | No |
| **D-54** | Integration test specifications | B.5 §13.3 | C.7 | No |
| **D-55** | System invariant test specifications | B.5 §13.2 | C.7 | No |
| **D-56** | UAT scenario specifications | B.5 §13.3 | C.7 | No |
| **D-57** | Validation evidence format | B.5 §13.3 | C.7 | No |
| **D-58** | PySpark job definitions | B.5 §16 | — | Yes |
| **D-59** | Notebook definitions | B.5 §16 | — | Yes |
| **D-60** | CI/CD configuration | B.5 §16 | — | Yes |
| **D-61** | Code | B.5 §16 | — | Yes |
| **D-62** | Job code and configuration | B.6 §14.3 | — | Yes |
| **D-63** | Task code | B.6 §14.3 | — | Yes |
| **D-64** | App code | B.6 §14.3 | — | Yes |
| **D-65** | API boundary code | B.6 §14.3 | — | Yes |

**Total:** 65 deferrals (D-01 to D-65). 57 addressed in Stage C (C.1–C.7), 8 deferred to Stage D (D-58 to D-65).

### 5.2 Consolidated Summary by Stage C Deliverable

| Stage C deliverable | Deferrals | Count |
|---|---|---|
| **C.1 Data Specification** | D-01 to D-11 | 11 |
| **C.2 Computational Model Specification** | D-12 to D-16 | 5 |
| **C.3 Optimization Specification** | D-17 to D-24 | 8 |
| **C.4 Financial Specification** | D-25 to D-34 | 10 |
| **C.5 Software Specification** | D-35 to D-42 | 8 |
| **C.6 Platform Specification** | D-43 to D-52 | 10 |
| **C.7 Testing and Validation Specification** | D-53 to D-57 | 5 |
| **Deferred to Stage D** | D-58 to D-65 | 8 |
| **Total** | | **65** |

### 5.3 Deferral Handling Rules

| Rule | Description |
|---|---|
| **Traceability** | Every Stage C deliverable must explicitly address its assigned deferrals |
| **Closure** | A deferral is closed when the Stage C deliverable that owns it specifies the item at Stage C level of detail |
| **Escalation** | If a Stage C deliverable cannot address a deferral (e.g., blocked by an unresolved PH item), the deferral must be escalated via change control |
| **Stage D handoff** | Deferrals D-58 to D-65 remain open at Stage C closure and are formally handed to Stage D |
| **New deferrals** | Any new deferral identified during Stage C is added to this list via change control, with a new ID |

---

## 6. Interface to Stage C

### 6.1 Entry Point

The entry point of Stage C is the **Stage C Plan** (`STAGE-C-PLAN-001`). The Stage C Plan declares:

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
| The reconciled deferral list | This document §5 |

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
   ├── B.5 Software Architecture                   ✅ v0.4.1 Frozen
   ├── B.6 Databricks Architecture                 ✅ v0.4 Frozen
   │
   ├── STAGE-B-HLD-INDEX-001                       ✅ v0.2 Frozen
   │
   ├── STAGE-B-TO-C-HANDOFF-001 (this document)    ✅ v0.2 Frozen
   │
   └── Stage B Closure                             ✅ Declared (§1.1)
        │
        ▼
STAGE C — PRODUCT SPECIFICATION
   │
   ├── Stage C Plan                                ⏭ Entry point
   ├── C.1 Data Specification                      ⏭ Pending
   ├── C.2 Computational Model Specification       ⏭ Pending
   ├── C.3 Optimization Specification              ⏭ Pending
   ├── C.4 Financial Specification                 ⏭ Pending
   ├── C.5 Software Specification                  ⏭ Pending
   ├── C.6 Platform Specification                  ⏭ Pending
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
| 6 | The formal reconciled deferral list (D-01 to D-65) is declared | ✅ |
| 7 | The three invariants are explicitly declared | ✅ |
| 8 | The handoff sequence is declared | ✅ |
| 9 | The entry point of Stage C is declared | ✅ |
| 10 | The unresolved PH items are noted | ✅ |

### 7.2 Handoff Status

| Aspect | Status |
|---|---|
| **Stage B closure declaration** | ✅ Declared |
| **Stage B frozen baseline** | ✅ Certified |
| **Formal deferral list** | ✅ Reconciled (D-01 to D-65) |
| **Stage C entry point** | ✅ Declared |
| **Handoff review** | ✅ Complete |

---

## 8. Sign-Off

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

**Stage:** B — System Architecture (HLD)

**Document:** `STAGE-B-TO-C-HANDOFF-001`

**Version:** 0.2 — Baseline Frozen

**Status:** Baseline Frozen

**Stage B Status:** CLOSED

**Next Stage:** Stage C — Product Specification

**Next Step:** Produce Stage C Plan

**Language:** English

---

## 9. Change Log

### 9.1 Changes from v0.1 to v0.2

| # | Change | Reason |
|---|--------|--------|
| 1 | Header: version promoted from v0.1 Draft for Review to **v0.2 Baseline Frozen** | Handoff is now a formal frozen baseline |
| 2 | §5: replaced provisional "deferral categories" with the **formal reconciled deferral list D-01 to D-65** | The 65 deferrals are now formally enumerated, each with source, Stage C deliverable, and Stage D flag |
| 3 | §5.2: added **Consolidated Summary by Stage C Deliverable** | Gives the Plan a clean mapping to consume |
| 4 | §5.3: added **Deferral Handling Rules** (traceability, closure, escalation, Stage D handoff, new deferrals) | Defines how deferrals are managed through Stage C |
| 5 | §3.1: renamed Stage C specification categories to align with Plan v0.2 ("Data Specification", "Computational Model Specification", etc.) | Consistency with the Stage C Plan v0.2 |
| 6 | §3.2: replaced strict linear sequence with **nominal production order** + **controlled iteration rule** | Align with Plan v0.2 §3.2 |
| 7 | §6.2: added "The reconciled deferral list" to what Stage C consumes | Traceability |
| 8 | §6.4: Handoff sequence updated — this document is now v0.2 Frozen | Reflect the freeze |
| 9 | §7: Handoff review criteria and status updated to reflect the reconciliation | Closure |
| 10 | §9: added this change log | Traceability |

### 9.2 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage B closure | Initial handoff produced | Superseded |
| 0.2 | Stage C plan review | Formal deferral reconciliation (D-01 to D-65); Stage C category naming aligned; controlled iteration rule; deferral handling rules | **Baseline Frozen** |

---

**End of STAGE-B-TO-C-HANDOFF-001 — Stage B → Stage C Handoff (v0.2 — Baseline Frozen)**

**Status:** Baseline Frozen

**Next:** Stage C Plan v1.0 Baseline

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

---

## 📋 Secuencia Git para el Handoff v0.2

```bash
cd ~/repo_lab/EngieBess

# 1. Reemplazar el archivo del Handoff con la v0.2
cat > docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md << 'HANDOFF_V02_EOF'
[PEGA AQUÍ EL CONTENIDO COMPLETO DEL HANDOFF v0.2]
HANDOFF_V02_EOF

# 2. Verificar
head -5 docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md
grep -E "^\*\*Version:|^\*\*Status:" docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md | head -2
wc -l docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md
grep -c "D-65" docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md

# 3. Commit
git add docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md

git commit -m "docs(stage-b): freeze STAGE-B-TO-C-HANDOFF-001 to v0.2 (Baseline Frozen)

Promotes the Stage B → Stage C Handoff from v0.1 Draft to v0.2 Baseline Frozen.

Key change: formal reconciliation of the 65 deferrals (D-01 to D-65).

Contents of v0.2:
- §5.1: formal deferral list D-01 to D-65 with source, Stage C deliverable, and Stage D flag
- §5.2: consolidated summary by Stage C deliverable
- §5.3: deferral handling rules (traceability, closure, escalation, Stage D handoff, new deferrals)
- §3.1: Stage C category names aligned with Stage C Plan v0.2
- §3.2: nominal production order + controlled iteration rule
- §6.2: reconciled deferral list added to Stage C consumption
- §6.4: handoff sequence updated

Reconciliation summary:
- C.1 Data Specification: D-01 to D-11 (11)
- C.2 Computational Model Specification: D-12 to D-16 (5)
- C.3 Optimization Specification: D-17 to D-24 (8)
- C.4 Financial Specification: D-25 to D-34 (10)
- C.5 Software Specification: D-35 to D-42 (8)
- C.6 Platform Specification: D-43 to D-52 (10)
- C.7 Testing and Validation Specification: D-53 to D-57 (5)
- Deferred to Stage D: D-58 to D-65 (8)
- Total: 65

Refs: STAGE-B-TO-C-HANDOFF-001
Next: STAGE-C-PLAN-001 v0.3 (with Handoff v0.2 cited)"

git push origin main

# 4. Borrar el tag viejo del Handoff si existe (era v0.1)
# Nota: el tag 'stage-b-closed' apunta al commit del Handoff v0.1.
# No lo borramos — stage-b-closed sigue siendo válido como cierre de Stage B.
# Este commit añade una v0.2 Frozen del Handoff sin tocar el tag de cierre.

# 5. Crear tag específico para el Handoff v0.2
git tag -a stage-b-handoff-v02 -m "Stage B — Stage B → Stage C Handoff v0.2 (Baseline Frozen)"
git push origin stage-b-handoff-v02
```

---

## Y ahora el Documento 2 — Plan v0.3

Aquí va completo con las 5 correcciones aplicadas.

---

# STAGE-C-PLAN-001 — Stage C Product Specification Plan (v0.3 — Freeze Candidate)

**Document ID:** STAGE-C-PLAN-001

**Version:** 0.3 — Freeze Candidate

**Status:** Stage C — Plan (Freeze Candidate)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Language:** English

**Parent Documents:**

- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6.1)
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
- `STAGE-B-TO-C-HANDOFF-001` — Stage B → Stage C Handoff (v0.2 Baseline Frozen)
- `B.0-INTEGRATED-SYS-ARCH-001` — B.0 Integrated System Architecture (v0.3.3)
- `B.1-DATA-ARCH-001` — B.1 Data Architecture (v0.3)
- `B.2-MODEL-ARCH-001` — B.2 Model Architecture (v0.5.1)
- `B.3-OPT-ARCH-001` — B.3 Optimization Architecture (v0.6.1)
- `B.4-FIN-ARCH-001` — B.4 Financial Architecture (v0.4)
- `B.5-SW-ARCH-001` — B.5 Software Architecture (v0.4.1)
- `B.6-DBX-ARCH-001` — B.6 Databricks Architecture (v0.4)

**Purpose:** Establish the master plan for Stage C (Product Specification — Detailed Engineering), declaring the deliverables, their scope, the production sequence, the level-of-detail rule distinguishing Stage C from Stage D, the review and freeze process, the closure criteria, the Stage C → Stage D Handoff criteria, and the traceability chain that connects the RFP to the implementation.

**Change log.** See §14.

---

## 0. Document Control

### 0.1 Document Identity

| Aspect | Value |
|---|---|
| **Document ID** | `STAGE-C-PLAN-001` |
| **Version** | 0.3 — Freeze Candidate |
| **Status** | Stage C — Plan (Freeze Candidate) |
| **Project** | ENGIE — BESS Operational & Financial Modeling |
| **Engagement** | RFP-264144-1 |
| **Language** | English |

### 0.2 Definition of "Product Specification"

> **For this engagement, "Product Specification" refers to the complete technical specification of the BESS operational and financial modeling solution — including data, computational models, optimization, financial valuation, software, platform realization, and validation. It does not refer to a commercial product specification, marketing collateral, or a packaged software product definition.**

Stage C is therefore the **system-level detailed specification** that turns the frozen Stage B architecture into an implementable system.

### 0.3 Purpose

This document establishes:

- The **master plan** of Stage C
- The **scope** of each Stage C deliverable
- The **production sequence** of C.1–C.7
- The **dependency chain** between deliverables, including permitted iteration
- The **level-of-detail rule** distinguishing Stage C from Stage D
- The **review and freeze process** for Stage C
- The **closure criteria** for Stage C
- The **Stage C → Stage D Handoff** criteria
- The **Stage C Traceability Chain** connecting RFP → A → B → C → D → Test → UAT

It is a **contract document** between the consultant and ENGIE: it defines what Stage C will produce before production begins.

### 0.4 Scope

**In scope:**

- Master plan of Stage C
- Scope definition per deliverable
- Production sequence
- Level-of-detail classification (Stage C / Stage D)
- Review and freeze process
- Closure criteria
- Stage C → Stage D Handoff criteria
- Traceability chain

**Out of scope:**

- The actual content of Stage C deliverables (produced in C.1–C.7)
- Any Stage A or Stage B content (already closed and frozen)
- Any Stage D content (implementation)

---

## 1. Purpose of This Plan

### 1.1 Why a Plan Document

Before producing the Stage C deliverables, the **structure, scope, and production sequence** must be defined. Producing Stage C without a plan risks:

- **Scope creep** — C.1 becoming C.1–C.7 by accident
- **Duplication** — the same specification appearing in multiple deliverables
- **Premature implementation** — Stage C becoming Stage D
- **Inconsistency** — different deliverables contradicting each other
- **Lost traceability** — requirements not carried from RFP to validation

The plan document **constrains** Stage C before production and **certifies** it after production.

### 1.2 How This Document Is Used

| Phase | Use |
|---|---|
| **Before Stage C production** | Define the structure, scope, and sequence |
| **During Stage C production** | Reference for deliverable scope and level of detail |
| **After Stage C production** | Checklist for Stage C review and closure |
| **Stage D start** | Confirm handoff criteria |

### 1.3 Relationship to Stage B

Stage B answered:

> **How are the engineering responsibilities structurally organized into an executable system?**

Stage C answers:

> **What exactly must be built to implement the frozen architecture?**

This plan declares **how** Stage C will answer that question.

---

## 2. Stage C Scope

### 2.1 What Stage C Produces

Stage C produces the **system specification** — the detailed engineering that turns the frozen Stage B architecture into an implementable system.

| # | Deliverable | Description |
|---|---|---|
| **C.1** | **Data Specification** | Data domains, logical entities, physical schemas, column definitions, keys, constraints, time semantics, scenario/run identity, partitioning, Z-ordering, Delta behavior, lineage, ingestion mechanism, validation, acceptance criteria |
| **C.2** | **Computational Model Specification** | Logical class/service identity, inputs, outputs, state, preconditions, postconditions, invariants, interface contracts, data and type requirements, error behavior, numerical schemes, lifecycle |
| **C.3** | **Optimization Specification** | Objective structure, constraint formulations, decision variables, solver selection constraints, solver configuration, numerical tolerances, horizon implementation, initial SOC mechanism, feasibility handling |
| **C.4** | **Financial Specification** | Cash-flow structure, revenue attribution, discounting conventions, tax and depreciation methodology, ITC treatment, debt structure, distribution waterfall, terminal value, multiple-IRR handling |
| **C.5** | **Software Specification** | Software unit structure, API contracts, request/response schemas, service boundaries, authentication requirements, interface behavior, error contracts, configuration schema, test specifications |
| **C.6** | **Platform Specification** | API hosting mechanism, Databricks App realization, networking, identity integration, secrets, compute, Jobs/Tasks topology, catalogs, permissions, platform NFRs, cost model, SLOs |
| **C.7** | **Testing and Validation Specification** | Consolidated test strategy, UAT scenarios, validation evidence format — consolidating the acceptance criteria defined within each Stage C deliverable |

### 2.2 What Stage C Does Not Produce

| Not in Stage C | Belongs to |
|---|---|
| Code (Python, PySpark, SQL) | Stage D |
| CI/CD pipelines | Stage D |
| Notebooks | Stage D |
| Job / Task code | Stage D |
| App code | Stage D |
| API handler code | Stage D |
| Deployment execution | Stage D |
| UAT execution | Stage D |

### 2.3 Relationship to Stage D

Stage C **specifies**. Stage D **implements**.

**Stage C specifies:**

- Logical class / service identity
- Inputs, outputs, state
- Preconditions, postconditions, invariants
- Interface contracts
- Data and type requirements
- Error behavior
- Numerical schemes and semantics

**Stage D implements:**

- Python class bodies
- Internal data structures
- Algorithm implementation
- Package / module code
- Job / Task code
- App code
- API handler code

**Rule.** Stage C specifies **contract, semantics, and invariants**. Stage D implements **within** the frozen Stage C specification. Where the target language is already fixed by the RFP (Python for the modeling engine), Stage C may use language-specific notation — but Stage C does not impose implementation decisions beyond what the contract requires.

---

## 3. Stage C Deliverables Overview

### 3.1 Structure

```
STAGE C — PRODUCT / SYSTEM SPECIFICATION
│
├── C.1 Data Specification
├── C.2 Computational Model Specification
├── C.3 Optimization Specification
├── C.4 Financial Specification
├── C.5 Software Specification
├── C.6 Platform Specification
├── C.7 Testing & Validation Specification
│
└── Stage C → Stage D Handoff
```

### 3.2 Production Order and Controlled Iteration

**Nominal production order:**

```
B.0–B.6
    │
    ▼
   C.1
    │
    ▼
   C.2
    │
    ▼
   C.3
    │
    ▼
   C.4
    │
    ▼
   C.5
    │
    ▼
   C.6
    │
    ▼
   C.7
    │
    ▼
 C → D Handoff
```

**Rule.** The sequence above is the **nominal production order**. Cross-deliverable iteration is permitted where a downstream specification reveals a dependency, inconsistency, or missing requirement affecting an upstream specification. Such iteration is controlled through change control and does not constitute unrestricted redesign.

**Examples of permitted iteration:**

- C.2 may reveal a data requirement not fully determined in C.1
- C.3 may reveal a variable or constraint needed by C.2
- C.5 may identify an implementation-boundary issue that requires clarification or controlled revision of C.2 or C.3

**Rule.** Iteration is **feedback**, not circular dependency. It is managed through change control.

### 3.3 Relationship Between Deliverables

| Deliverable | Produces | Consumed by |
|---|---|---|
| **C.1** | Data specification | C.2, C.3, C.4, C.5, C.6, C.7 |
| **C.2** | Computational model specification | C.3, C.4, C.5, C.7 |
| **C.3** | Optimization specification | C.4, C.5, C.7 |
| **C.4** | Financial specification | C.5, C.7 |
| **C.5** | Software specification | C.6, C.7 |
| **C.6** | Platform specification | C.7 |
| **C.7** | Consolidated testing & validation specification | Stage D |

**Rule.** No deliverable is frozen before its dependencies are sufficiently defined. Iteration is managed through change control.

---

## 4. Master Index — Stage C Deliverables

### 4.1 Planned Deliverables

| Order | Deliverable | Document ID | Version | Status |
|---|---|---|---|---|
| 1 | **C.1 Data Specification** | `C.1-DATA-SPEC-001` | — | ⏭ Next |
| 2 | **C.2 Computational Model Specification** | `C.2-MODEL-SPEC-001` | — | ⏭ Pending |
| 3 | **C.3 Optimization Specification** | `C.3-OPT-SPEC-001` | — | ⏭ Pending |
| 4 | **C.4 Financial Specification** | `C.4-FIN-SPEC-001` | — | ⏭ Pending |
| 5 | **C.5 Software Specification** | `C.5-SW-SPEC-001` | — | ⏭ Pending |
| 6 | **C.6 Platform Specification** | `C.6-PLATFORM-SPEC-001` | — | ⏭ Pending |
| 7 | **C.7 Testing and Validation Specification** | `C.7-TEST-SPEC-001` | — | ⏭ Pending |
| 8 | **Stage C → Stage D Handoff** | `STAGE-C-TO-D-HANDOFF-001` | — | ⏭ Pending |

### 4.2 Deliverable Scope Summary

| Deliverable | Question Answered |
|---|---|
| C.1 | What data structures exist, with what schemas, semantics, and validation? |
| C.2 | How is each model specified as a computational contract? |
| C.3 | How is the optimization specified, and under what solver constraints? |
| C.4 | How is financial valuation specified? |
| C.5 | What are the software interfaces, contracts, and boundaries? |
| C.6 | Where and how is the software physically hosted? |
| C.7 | How is the system tested and validated, and what evidence is required? |

### 4.3 Stage B Deferrals — Reconciled

> **Stage B deferrals are reconciled against `STAGE-B-TO-C-HANDOFF-001` v0.2 (Baseline Frozen).**

The Stage B → Stage C Handoff v0.2 declares the **formal reconciled list of 65 deferrals** (D-01 to D-65). The Plan consumes that list directly.

### 4.4 Formal Deferral Mapping

The following mapping is the authoritative allocation of the 65 deferrals to Stage C deliverables.

| Stage C deliverable | Deferrals | Count |
|---|---|---|
| **C.1 Data Specification** | D-01 to D-11 | 11 |
| **C.2 Computational Model Specification** | D-12 to D-16 | 5 |
| **C.3 Optimization Specification** | D-17 to D-24 | 8 |
| **C.4 Financial Specification** | D-25 to D-34 | 10 |
| **C.5 Software Specification** | D-35 to D-42 | 8 |
| **C.6 Platform Specification** | D-43 to D-52 | 10 |
| **C.7 Testing and Validation Specification** | D-53 to D-57 | 5 |
| **Deferred to Stage D** | D-58 to D-65 | 8 |
| **Total** | | **65** |

**Note.** The full deferral list (with descriptions, sources, and Stage D flags) is declared in `STAGE-B-TO-C-HANDOFF-001` v0.2 §5.1. This section only declares the allocation.

---

## 5. Dependency Chain

### 5.1 Dependencies with Controlled Iteration

| Deliverable | Depends on | Reason |
|---|---|---|
| **C.1** | B.1, B.6 | Data architecture and platform data layout |
| **C.2** | B.2, C.1 | Model architecture and data specification |
| **C.3** | B.3, C.1, C.2 | Optimization architecture, data specification, model specification |
| **C.4** | B.4, C.1, C.2, C.3 | Financial architecture and upstream specifications |
| **C.5** | B.5, C.1–C.4 | Software architecture and upstream specifications |
| **C.6** | B.6, C.1–C.5 | Platform architecture and upstream specifications |
| **C.7** | B.5, C.1–C.6 | Testing boundaries and all upstream specifications |
| **Handoff** | C.1–C.7 | Consolidated handoff |

**Rule.** Each deliverable is produced after its required architectural inputs and prerequisite specifications are **sufficiently defined**. Cross-deliverable iteration is **permitted under change control**.

**Rule.** No deliverable is frozen before its dependencies are sufficiently defined.

### 5.2 Verified Parent Citations

Each Stage C deliverable cites its parent Stage B views and its Stage C predecessors. The citations are verified at freeze time.

### 5.3 Production Sequence

```
STAGE B — SYSTEM ARCHITECTURE (HLD)
   │
   │ ✅ CLOSED (tag: stage-b-closed)
   │ ✅ Handoff v0.2 Frozen (tag: stage-b-handoff-v02)
   │
   ▼
STAGE C — PRODUCT / SYSTEM SPECIFICATION
   │
   ├── STAGE-C-PLAN-001 (this document)            ⏭ Freeze Candidate
   │
   ├── C.1 Data Specification                      ⏭ Next
   ├── C.2 Computational Model Specification       ⏭ Pending
   ├── C.3 Optimization Specification              ⏭ Pending
   ├── C.4 Financial Specification                 ⏭ Pending
   ├── C.5 Software Specification                  ⏭ Pending
   ├── C.6 Platform Specification                  ⏭ Pending
   ├── C.7 Testing and Validation Specification    ⏭ Pending
   │
   ├── STAGE-C-TO-D-HANDOFF-001                    ⏭ Pending
   │
   └── Stage C Closure                             ⏭ Pending
        │
        ▼
STAGE D — IMPLEMENTATION
```

### 5.4 Milestones

| Milestone | Content | Status |
|---|---|---|
| **M0** | Stage B → C Handoff promoted to v0.2 Frozen | ✅ Done |
| **M1** | Stage C Plan frozen to v1.0 | ⏭ Next |
| **M2** | C.1 + C.2 complete | ⏭ Pending |
| **M3** | C.3 + C.4 complete | ⏭ Pending |
| **M4** | C.5 + C.6 complete | ⏭ Pending |
| **M5** | C.7 complete | ⏭ Pending |
| **M6** | Stage C → Stage D Handoff | ⏭ Pending |
| **M7** | Stage C Closure | ⏭ Pending |

---

## 6. Level of Detail Rule

### 6.1 The Rule

> **Stage C must be sufficiently concrete to be directly implementable in Stage D, but insufficiently detailed to be the implementation itself.**

### 6.2 Comparison

| Stage C (Specification) | Stage D (Implementation) |
|---|---|
| Logical class / service identity | Python class bodies |
| Inputs, outputs, state | Internal data structures |
| Preconditions, postconditions, invariants | Algorithm implementation |
| Interface contracts | Handler code |
| **Data and type requirements** | **Language-specific type declarations and implementation** |
| Error behavior | Exception handling code |
| Table schemas with columns and types | DDL execution |
| Objective and constraint formulations | Solver problem assembly |
| Cash-flow structure and equations | Computation code |
| API request/response schemas | API handlers |
| Job / Task topology | Job configuration files |
| Test specifications | Test code |

### 6.3 Examples

| ✅ Stage C | ❌ Stage D (too detailed) |
|---|---|
| "BESS Model is a state-carrying service with state {SOC, SOH, availability}. It produces the feasible operating envelope given the current state and physical parameters." | "class BESSModel: def __init__(self, ...): ..." |
| "Table `validated.meter_data`: columns `timestamp` (timestamp, PK), `site_id` (string, PK), `consumption_kwh` (float, ≥0)" | "CREATE TABLE validated.meter_data (...) USING DELTA PARTITIONED BY (date(timestamp))" |
| "Objective: maximize expected operational value over the horizon, composed of market revenue signals, BTM savings signal, and marginal degradation cost signal." | "prob += lpSum([price[t] * (discharge[t] - charge[t]) - mdc * throughput[t] for t in T])" |
| "Solver: LP class. Must implement the formulations defined in B.3. Solver selection shall not redefine optimization semantics." | "from pulp import LpProblem, LpMaximize; prob = LpProblem(...)" |
| "Job `scenario_batch`: coordinates year loop, dispatch fan-out over (scenario × representative period), and annual update barrier." | "job_config.json with tasks and dependencies" |
| "Unit test: BESS envelope returns power bounds consistent with SOC bounds for all valid SOC values." | "def test_bess_envelope(): assert bess.envelope(0.5) == ..." |

---

## 7. Review and Freeze Process

### 7.1 Review Process

Each Stage C deliverable goes through:

| Phase | Description |
|---|---|
| **Draft** | Deliverable produced by the consultant |
| **Internal Review** | Cross-check against Stage B views and previous Stage C deliverables |
| **Client Review** | Review by ENGIE (where applicable) |
| **Revision** | Corrections applied based on review feedback |
| **Freeze** | Deliverable baselined |

### 7.2 Freeze Criteria

A Stage C deliverable is **frozen** when:

| # | Criterion |
|---|---|
| 1 | All parent citations are correct |
| 2 | All Stage B deferrals assigned to it are addressed |
| 3 | Cross-references to sibling deliverables are coherent |
| 4 | No Stage D content (no code, no execution) |
| 5 | No Stage B content redecided (frozen Stage B decisions respected) |
| 6 | Internal consistency verified |
| 7 | Traceability to Stage A / Stage B is complete |
| 8 | Level of detail matches Stage C |
| 9 | **Testing and validation requirements are defined within the deliverable** |

### 7.3 Solver Constraint (applies to C.3)

> **The selected solver shall implement the optimization formulations and logical optimization types defined by B.3 and C.3. Solver selection shall not redefine optimization semantics, objective meaning, constraint ownership, or state-transition semantics.**

Any solver limitation that would require changing the optimization formulation must be escalated as a change request against B.3, not silently accommodated in C.3.

### 7.4 Change Control

- **Adding a section:** must be justified; requires version bump
- **Removing a section:** must be justified; requires version bump
- **Changing scope:** requires review and version bump
- **Changing level of detail:** requires review and version bump
- **Changing a frozen Stage B decision:** requires Stage B change request and re-baselining
- **Cross-deliverable iteration:** permitted under explicit change control

### 7.5 Freeze Sequence

Each deliverable is frozen **individually**. Once frozen, it becomes a stable input for the next deliverables.

The overall Stage C is frozen when all 7 deliverables + Handoff are frozen.

---

## 8. Stage C Closure Criteria

### 8.1 Closure Criteria

| # | Criterion | Verification | Status |
|---|---|---|---|
| 1 | All deliverables C.1–C.7 are present | Section presence | ⏭ Pending |
| 2 | All 65 Stage B deferrals are addressed (57 in C, 8 to D) | Reconciliation table | ⏭ Pending |
| 3 | All frozen Stage B decisions are respected | Cross-check against Handoff | ⏭ Pending |
| 4 | All cross-deliverable interfaces are coherent | Interface consistency check | ⏭ Pending |
| 5 | No Stage D content (no code, no execution) | Level of detail check | ⏭ Pending |
| 6 | Traceability to RFP / Stage A / Stage B is complete | Traceability matrix | ⏭ Pending |
| 7 | All deliverables are frozen | Freeze verification | ⏭ Pending |
| 8 | Stage C → Stage D Handoff produced | Document presence | ⏭ Pending |
| 9 | Stage C formal closure | Closure declaration | ⏭ Pending |
| 10 | **Testing and validation requirements defined within each deliverable and consolidated in C.7** | Cross-check | ⏭ Pending |

### 8.2 Stage C Traceability Chain

> **Every Stage C requirement and specification item shall be traceable to its originating Stage A requirement, Stage B architectural decision, or approved clarification. Each Stage C specification shall define the validation evidence required to demonstrate compliance.**

The traceability chain is:

```
ENGIE RFP
    ↓
Stage A requirement
    ↓
Stage B architectural decision
    ↓
Stage C specification
    ↓
Stage D implementation
    ↓
Test
    ↓
UAT evidence
```

This chain is the backbone of the acceptance argument to ENGIE: it demonstrates that every requirement has been engineered, specified, implemented, and validated.

### 8.3 Consistency Checks

| Check | Description | Status |
|---|---|---|
| **Cross-deliverable consistency** | No contradictions between C.1–C.7 | ⏭ Pending |
| **Interface consistency** | All declared interfaces are consistent | ⏭ Pending |
| **Data consistency** | Data schemas are consistent across deliverables | ⏭ Pending |
| **Model consistency** | Model specifications are consistent | ⏭ Pending |
| **Optimization consistency** | Optimization specification is consistent with model | ⏭ Pending |
| **Financial consistency** | Financial specification is consistent with optimization | ⏭ Pending |
| **Software consistency** | Software specification is consistent with all upstream | ⏭ Pending |
| **Platform consistency** | Platform specification is consistent with software | ⏭ Pending |
| **Testing consistency** | Testing specification covers all invariants | ⏭ Pending |
| **Traceability** | Every requirement is traceable | ⏭ Pending |
| **Level of detail** | No deliverable crosses into Stage D | ⏭ Pending |

---

## 9. Stage C → Stage D Handoff

### 9.1 What the Handoff Will Produce

The **Stage C → Stage D Handoff** will declare:

- Stage C closure declaration
- Frozen Stage C baseline
- What Stage D receives (the complete specification set)
- What Stage D must produce (implementation)
- What Stage D must not redecide (frozen Stage C decisions)
- What remains open for Stage D
- Stage D entry point (Stage D Plan)
- Stage D closure criteria

### 9.2 What Stage D Receives

Stage D receives the **complete Stage C specification set**:

| Stage C deliverable | Stage D uses it to |
|---|---|
| C.1 | Create tables, ingest data, transform data |
| C.2 | Implement model classes |
| C.3 | Implement optimization |
| C.4 | Implement financial computation |
| C.5 | Implement software structure |
| C.6 | Configure platform |
| C.7 | Implement tests |

### 9.3 What Stage D Does Not Redecide

Stage D does not redefine:

- Class / service identities
- Table schemas
- Interface contracts
- Objective function structure
- Constraint formulations
- Cash-flow structure
- API contracts
- Job / Task topology
- Test specifications

Any change requires a Stage C change request and re-baselining.

---

## 10. Change Control

### 10.1 Change Procedure

- **Adding a deliverable:** must be justified; requires plan version bump
- **Removing a deliverable:** must be justified; requires plan version bump
- **Changing scope of a deliverable:** must be justified; requires plan version bump
- **Changing level of detail:** requires review and plan version bump
- **Changing a frozen Stage C deliverable:** requires formal change request and re-baselining
- **Cross-deliverable iteration:** permitted under explicit change control

### 10.2 Freeze

This plan is **frozen** once accepted at v1.0 Baseline. Changes require a formal plan version bump.

---

## 11. Risk Register

The following risks are tracked for Stage C.

| # | Risk | Impact | Mitigation |
|---|---|---|---|
| R-01 | Unresolved PH items (PH-001 to PH-006) may require mid-Stage-C revisions | Medium | Proceed with working defaults; reconcile when resolved |
| R-02 | Solver software selection (C.3) may be constrained by licensing or capability | Medium | Open-source LP solver as working preference; solver constraint per §7.3 |
| R-03 | Databricks platform constraints (C.6) may limit certain realizations | Medium | Early platform validation in C.6 |
| R-04 | UAT scenarios (C.7) may require data not available | Medium | Fallback to synthetic scenarios |
| R-05 | Cross-deliverable interface drift | Medium | Iteration under change control; interface freeze after C.5 |
| R-06 | Stage D time pressure may tempt Stage C shortcuts | High | Enforce level-of-detail rule |

**Note on PH-001 to PH-006.** These blocking items are tracked in `PH1-REG-001` v1.1. Stage C proceeds with the working defaults declared in Stage B; if the items are resolved and require adjustment, the adjustment goes through Stage C change control. Any adjustment that affects a frozen Stage B decision requires a Stage B change request.

**Note on R-07 (removed).** The risk "Stage B deferrals not reconciled before Plan freeze" was resolved by promoting the Handoff to v0.2 Frozen (M0, §5.4). It is no longer an active risk.

---

## 12. Sign-Off

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

**Stage:** C — Product Specification

**Document:** `STAGE-C-PLAN-001`

**Version:** 0.3 — Freeze Candidate

**Status:** Freeze Candidate

**Next Step:** Freeze this Plan to v1.0 Baseline → begin C.1

**Language:** English

---

## 13. Verbo y Lenguaje

**Rule.** Throughout Stage C, use **"Stage C specifies"** — not "Stage C decides".

Rationale: Stage C does not decide arbitrarily. It **specifies within the constraints established by Stage A, Stage B, and approved clarifications**. The distinction matters because it preserves the architectural integrity of the frozen Stage A/B baseline.

```
Stage A
Engineering definition

Stage B
Architectural decisions

Stage C
Detailed specifications and approved technical decisions within the frozen architecture

Stage D
Implementation decisions within the frozen specification
```

---

## 14. Change Log

### 14.1 Changes from v0.2 to v0.3

| # | Change | Reason |
|---|--------|--------|
| 1 | §3.2: replaced complex dependency graph with **nominal production order** + explicit **controlled iteration rule** | The complex graph did not visually represent the "C.5 may constrain C.2/C.3" claim |
| 2 | §3.2: reframed C.5 → C.2/C.3 interaction as **"may identify an implementation-boundary issue that requires clarification or controlled revision"** | "Constrains" implied circular dependency; "identifies" reflects feedback |
| 3 | §6.2: `Type requirements` → **`Data and type requirements`**; `Type annotations in code` → **`Language-specific type declarations and implementation`** | More precise: Stage C specifies data and type requirements semantically; Stage D declares language-specific types |
| 4 | §4.3: replaced "Stage B deferrals are to be reconciled against the final Handoff baseline" with **"Stage B deferrals are reconciled against `STAGE-B-TO-C-HANDOFF-001` v0.2 (Baseline Frozen)"** | Handoff is now frozen |
| 5 | §4.4: replaced provisional deferral mapping with the **formal reconciled mapping** (D-01 to D-65 allocated to C.1–C.7 + Stage D) | Consistency with Handoff v0.2 §5.2 |
| 6 | Header: Handoff cited as **v0.2 Baseline Frozen** | Reflect the freeze |
| 7 | §5.3: added Handoff v0.2 Frozen to the production sequence diagram | Traceability |
| 8 | §5.4: **M0 marked as Done** | Handoff v0.2 Frozen complete |
| 9 | §8.1: criterion 2 updated — "All 65 Stage B deferrals are addressed (57 in C, 8 to D)" | Reflect the formal reconciliation |
| 10 | §11: **R-07 removed** (resolved by M0) | No longer an active risk |
| 11 | §14: added this change log | Traceability |

**Nature of the change.** The v0.3 is an **editorial correction** over the v0.2. No structural change. The changes address the five points identified in review: §3.2 graph, §3.2 C.5 wording, §6.2 type requirements, §4.3/§4.4 Handoff citation, and the corresponding downstream updates.

### 14.2 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage C start | Initial Stage C Plan produced | Superseded |
| 0.2 | Stage C review | 19 corrections (naming, dependency model, solver constraint, transversal testing, traceability chain, API/platform separation, deferral reconciliation, language) | Superseded |
| 0.3 | Stage C review pass 2 | 11 editorial corrections (graph, C.5 wording, type requirements, Handoff v0.2 citation, formal deferral mapping, M0 Done, R-07 removal) | **Freeze Candidate** |

---

## 15. Next Steps

**Stage C status:**

| Aspect | Status |
|---|---|
| STAGE-C-PLAN-001 | ⏭ Freeze Candidate (this document) |
| Stage B → C Handoff v0.2 Frozen | ✅ Done |
| Plan freeze to v1.0 Baseline | ⏭ Next |
| C.1 Data Specification | ⏭ Next after Plan freeze |
| C.2 Computational Model Specification | ⏭ Pending |
| C.3 Optimization Specification | ⏭ Pending |
| C.4 Financial Specification | ⏭ Pending |
| C.5 Software Specification | ⏭ Pending |
| C.6 Platform Specification | ⏭ Pending |
| C.7 Testing and Validation Specification | ⏭ Pending |
| STAGE-C-TO-D-HANDOFF-001 | ⏭ Pending |
| Stage C Closure | ⏭ Pending |

**Immediate next actions.**

1. Freeze `STAGE-C-PLAN-001` to **v1.0 Baseline**.
2. Begin **C.1 — Data Specification**.

---

**End of STAGE-C-PLAN-001 — Stage C Product Specification Plan (v0.3 — Freeze Candidate)**

**Status:** Freeze Candidate

**Next:** Plan v1.0 → C.1

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

---

