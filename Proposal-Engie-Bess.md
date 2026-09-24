# Proposal — ENGIE BESS Operational & Financial Modeling

**RFP-264144-1 · 12-Week Engagement · Remote · English**

**Version 4 — Final for Submission**

---

## 1. Executive Summary

ENGIE requires a **BESS Operational & Financial Modeling Platform** — a software solution that evaluates the operational and financial performance of Battery Energy Storage System projects across multiple value streams, market scenarios, and contract conditions.

We propose a **12-week engagement** delivered through a **four-stage engineering progression (A → B → C → D)** that:

- Establishes **engineering definition** before building.
- Produces a **frozen architectural baseline** before writing implementation code.
- Delivers a **thin end-to-end slice by week 4** to validate scope and de-risk delivery.
- Runs Stage C (Specification) and Stage D (Implementation) in **controlled parallel** from week 3.
- Closes with **deployment, documentation, and training** in week 12.

The proposed solution is a **Python-based modeling engine** operating on **Databricks**, with **PySpark** for parallelization and **SQL** for data storage and query, surfaced to users via a **Databricks App**.

The engagement is not a single model. It is a **system of interconnected engineering domains** — physical, market, operational, dispatch, degradation, financial, and technological — operating within a **System Context**, connected through a **causal backbone** that runs from the physical system through operational behavior to financial value, and delivered through a Databricks application layer.

---

## 2. What ENGIE Will Receive

At the end of the 12-week engagement, ENGIE receives:

| Outcome | End-of-engagement deliverable |
|---|---|
| **Operational model** | Validated BESS operational and dispatch model |
| **Market participation** | Configurable market / value-stream representation |
| **Degradation** | Dynamic degradation model with operational feedback |
| **Financial valuation** | NPV, IRR, payback and value-stream outputs |
| **Data** | Validated, governed model-ready data layer |
| **Application** | Databricks App for scenario execution and results |
| **Validation** | Benchmark, system, and UAT evidence |
| **Documentation** | Technical and methodology documentation |
| **Training** | User / developer knowledge transfer |
| **Deployment** | Databricks deployment and handover |

**Supporting engineering control system.** The solution is accompanied by a controlled engineering baseline (Stages A–C) that ensures the solution is **constructible, auditable, and transferable**. The baseline is not the product; it is the system that guarantees the product.

---

## 3. Understanding of the Engagement

ENGIE is commissioning an analytical solution that supports **business development and project evaluation** by producing robust, auditable analytical outputs that demonstrate project performance, viability, and value to both external clients and internal stakeholders.

The RFP simultaneously asks for three deliverables:

```
                        ENGIE RFP
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
    ENGINEERING         SOFTWARE            DELIVERY
        │                   │                   │
        ├── System Context  ├── Python          ├── Documentation
        ├── BESS Physics    ├── Databricks      ├── Training
        ├── Load Forecast   ├── PySpark         └── Deployment
        ├── Market          ├── SQL
        ├── Operations      └── Databricks App
        ├── Dispatch
        ├── Degradation
        └── Financial
```

**Three natures, one contract.** ENGINEERING, SOFTWARE, and DELIVERY are parallel workstreams with distinct risks. **Treating ENGINEERING as the whole engagement would understate the software and delivery responsibilities of this contract.**

**Key insights driving our approach:**

1. **Market scope requires architectural separation.** The RFP references multiple market constructs without specifying a single target market. The architecture separates a **generic BESS engine** from **market-specific adapter modules**.

2. **Co-located configurations are an extension, not an assumption.** The architecture does not preclude BESS co-located with renewables, but initial delivery is standalone unless confirmed otherwise in Phase 1.

3. **Degradation must be modeled as a dynamic state, not a post-processing cost.** The feedback loop between dispatch and degradation is a core architectural requirement.

4. **Two simultaneous cycles must be preserved as distinct but coupled.** The physical-operational cycle and the economic-financial cycle are coupled but not collapsed. Collapsing them loses auditability and makes benchmark validation difficult.

---

## 4. Proposed Solution

### 4.1 System Strategy — the foundation

We propose a **System Strategy & Delivery Framework** that establishes:

- What the system is
- What engineering workstreams it contains
- What **System Context** surrounds the BESS
- How those workstreams relate
- What the system must produce
- What principles govern its design
- What cross-cutting concerns span the workstreams
- How it will be delivered across the 12-week engagement

**Guiding principle:**

> **Define before you build; build in thin, validated increments.**

### 4.2 Engineering Workstreams

The solution is organized into the following engineering workstreams, operating within a System Context:

| # | Workstream | Primary Question |
|---|---|---|
| 1 | **BESS Engineering** | What physical system are we modeling? |
| 2 | **Load, Data & Market Engineering** | What external signals, tariffs, market mechanisms and constraints affect the system? |
| 3 | **Operational Engineering** | How do those conditions translate into feasible use cases? |
| 4 | **Dispatch & Optimization** | How are physical, operational and economic objectives coordinated? |
| 5 | **Degradation Engineering** | How does operation change future BESS capability? |
| 6 | **Financial Engineering** | What economic value results from the modeled system? |
| 7 | **Technology & Application** | How is the integrated model executed and consumed? |

**Note on Workstream 2.** This workstream is presented as a combined proposal-level workstream. Internally, the responsibilities of **Load**, **Data**, and **Market** are separated and governed by distinct engineering domains. The combination is a proposal presentation choice, not a collapse of responsibilities.

**Ownership is explicit:**

- **Market Engineering owns the semantic definition** of the External Context interface (Generation, Grid, Load, Market), while **Data Engineering owns its ingestion and data realization**.
- **Project Configuration** is a scenario parameter, managed by Scenario Management.
- **Market revenue ownership chain:** Dispatch (attribution) → Market (settlement) → Financial (valuation).

### 4.3 System Context

The BESS does not operate in isolation. It operates within a System Context that determines what the BESS can do and what it is worth.

**External Context** — what surrounds the BESS:

| Dimension | What it declares |
|---|---|
| **Generation** | Renewable generation profiles, curtailment, intermittency |
| **Grid / Network** | Connection topology, import/export limits, interconnection capacity, congestion |
| **Load / Demand** | Physical demand profiles, seasonality, growth, electrification |
| **Market** | Which markets exist, which products are available, participation rules |

**Project Configuration** — the project's own topology and coupling:

| Aspect | What it declares |
|---|---|
| **BESS Configuration** | Standalone, co-located, BTM, FTM, integrated with renewables |
| **Topology** | Electrical and thermal coupling between BESS, generation, load, and grid |
| **Coupling** | AC-coupled, DC-coupled, hybrid |

**Critical distinction:** System Context affects **availability and constraints imposed by the environment**, not the **intrinsic physical capability** of the BESS.

### 4.4 Causal Backbone

```
                        SYSTEM CONTEXT
     ┌──────────┬──────────┬──────────┬──────────────┐
     │Generation│   Grid   │   Load   │    Market    │
     └────┬─────┴────┬─────┴────┬─────┴──────┬───────┘
          │          │          │            │
          └──────────┴──────────┴────────────┘
                              │
                              ▼
              External Signals & Constraints
              (interpreted by Market Engineering)
                              │
                              ▼
              Feasible Commitments & Signals
                              │
                              ▼
                     DISPATCH DECISION
                              │
                              ▼
                         BESS OPERATION
                              │
                              ▼
                         DEGRADATION
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
              Future Capability    Service Delivery
                                          │
                                          ▼
                                     SETTLEMENT
                                          │
                                          ▼
                                 FINANCIAL VALUATION
```

**Context → Impact → Domain → Decision → Value.** Every system-context dimension is traceable through this chain.

**Note on the Market → Settlement → Financial chain.** Market participation produces service delivery, which is settled through market-specific adapters, and only then valued by the Financial layer. **Settlement and Financial Valuation are distinct steps.** Financial does not redefine settlement rules.

---

## 5. Four-Stage Delivery Model

We propose a **four-stage engineering progression**:

| Stage | Name | Engineering Equivalent | Purpose |
|---|---|---|---|
| **A** | Engineering Definition | Conceptual Engineering | Define what the system must contain, and what the engineering responsibilities are |
| **B** | System Architecture (HLD) | Basic Engineering | Define how those responsibilities are structurally organized into an executable system |
| **C** | Product Specification | Detailed Engineering | Specify what exactly must be built, at a level precise enough to be implementable and verifiable |
| **D** | Implementation | Construction & Commissioning | Implement, test, validate, and deploy against baselined Stage C specifications |

**Verb progression:**

```
Stage A — defines requirements and engineering responsibilities
Stage B — establishes architectural decisions
Stage C — specifies detailed technical decisions within the frozen architecture
Stage D — implements within the frozen specification
```

**Controlled parallel execution.** Stage C and Stage D may execute in controlled parallel. Stage D cannot implement a specification domain until the corresponding Stage C deliverable is sufficiently baselined. Implementation is subject to Stage C → Stage D handoff controls.

---

## 6. Engagement Timeline (12 Weeks)

| Phase | Weeks | Delivery Stage | Focus |
|---|---|---|---|
| **1 — Design** | 1–2 | Stage A + B | Requirements validation, conceptual engineering, high-level architecture, output mock |
| **2 — Development** | 3–9 | Stage C + D (controlled parallel) | Thin end-to-end slice by ~week 4, then progressive deepening |
| **3 — Testing** | 10–11 | Stage D | Model validation, UAT |
| **4 — Deployment** | 12 | Stage D | Final delivery, deployment, documentation, training |

### 6.1 Delivery Timeline (Gantt)

```
                     W1 W2 W3 W4 W5 W6 W7 W8 W9 W10 W11 W12
Requirements          ██ ██
Engineering (A-B)     ██ ██
C Specifications            ██ ██ ██ ██ ██ ██
Implementation               ██ ██ ██ ██ ██ ██ ██
Thin Slice                      ◆
Model Validation                                        ██ ██
UAT                                                       ██ ██
Deployment                                                      ██
Documentation           ─────────────────────────────────────►
Training                                                          ██
```

**Thin slice — week 4:** Peak shaving + energy arbitrage, simple degradation update, NPV displayed on a basic Databricks App page, data flowing end-to-end, **subject to availability of representative data and confirmation of the applicable tariff / market assumptions during Phase 1.**

The slice serves two purposes:

1. **Internal de-risking** — proving data ingestion, dispatch runtime, degradation feedback loop, and Databricks App render work end-to-end.
2. **Client demo** — validating scope, expectations, and usability with ENGIE's business development users.

---

## 7. Technical Approach

### 7.1 Technology Stack

| Technology | Role | Where it does **not** belong |
|---|---|---|
| **Python** | Modeling engine | — |
| **PySpark** | Parallelization across scenarios, representative periods, sensitivity analyses; large-scale data transformation | Sequential state evolution |
| **SQL** | Data ingestion, validation, transformation, querying, result storage | Modeling logic |
| **Databricks** | Execution environment, orchestration, storage, app hosting | Model definition |
| **Databricks App** | User interface | Modeling logic |

### 7.2 Data Architecture

**Three architectural categories:**

- **Data Lifecycle** — Source → Ingested → Validated → Model-ready
- **Execution Data** — Execution State, Runtime State, State History, Run Metadata, Results
- **Governance Data** — Lineage, Validation Evidence, Version Metadata, Scenario/Run Identity

**Dual ownership model:**

- **Architectural owner** — the Technology & Application workstream provides the data infrastructure
- **Semantic owner** — the producing workstream defines what the data means

### 7.3 Computational Components

The seven engineering workstreams declared in §4.2 are **not the same as software components**. A single workstream may be realized by one or more computational objects; a computational object may serve more than one workstream.

The solution is realized through **seven computational objects**:

| Object | Classification |
|---|---|
| BESS Model | Stateful |
| Load & Market Model | Stateless |
| Tariff Engine | Stateless |
| Operational Model | Stateless |
| Dispatch Engine | Coordinating |
| Degradation Engine | Stateful |
| Financial Engine | Aggregating |

**Rule.** Engineering workstreams define responsibilities. Computational objects realize those responsibilities. The mapping is not 1:1.

### 7.4 Optimization Architecture

**Objective structure:**

- Market revenue
- BTM savings signal (derived from the customer tariff)
- Degradation cost (marginal degradation cost — signal, not cash flow)

**Constraint families:**

- Physical (SOC, power, ramp, inverter envelope)
- Availability (unavailability, minimum rest)
- Operational (SOC floors, duration floors, reserve requirements)
- Market (eligibility, participation rules)
- Program (DR event windows, notification)
- Grid (interconnection limits, export constraints)
- Warranty (annual throughput limits)
- Tariff / billing coupling

**Proposed working assumption (subject to Phase 1 validation):** Linear Programming.

**Solver constraint:** The selected solver shall implement the optimization formulations and logical optimization types defined by the frozen architecture. Solver selection shall not redefine optimization semantics.

### 7.5 Degradation — Three Concepts That Must Not Collapse

| Concept | Nature | Owner |
|---|---|---|
| **Physical degradation** | Physical state | Degradation Engineering |
| **Marginal degradation cost** | Operational signal | Degradation Engineering |
| **Replacement cash flow** | Monetary flow | Financial Engineering |

### 7.6 Software Architecture

**Software units:**

- Engineering units: `bess_model`, `load_market` (with `signal_provider` + `settlement_adapter`), `tariff`, `operational`, `dispatch`, `degradation`, `financial`
- Cross-cutting: `scenario_mgmt`, `configuration`, `validation`, `execution_control`, `lineage`, `observability`
- Data: `data_lifecycle`, `execution_state`, `state_history`, `governance_data`
- Application: `application`
- Shared kernel: `kernel`

**Rule.** Software units do not own persistent business state at runtime. Model state is passed explicitly through execution interfaces and persisted through the execution and data architecture where required. This makes parallel execution across scenarios, representative periods, and sensitivities possible.

### 7.7 Databricks Architecture

**Environment classes:** Development / Validation-UAT / Production

**Compute realization:** Serverless by default; classic where required by workload, platform, or enterprise requirements; serverless application infrastructure for the Databricks App.

**Parallelization:** Intra-task distributed fan-out for scenarios and representative periods.

**Synchronization barriers:** End-of-year barrier (annual state update); End-of-scenario barrier (Tariff + Settlement in parallel, Financial after both).

---

## 8. Operational Modes

The proposed modeling architecture supports the following BESS operating strategies, with **implementation depth and market-specific realization confirmed during Phase 1**:

### 8.1 Peak Shaving

Reduce site peak demand (kW) to lower demand charges. Discharge battery to cap facility demand at a defined threshold.

**Output metrics:** Peak reduction (kW), demand charge savings ($/month), number of discharge cycles consumed.

### 8.2 Demand Response (DR)

Curtail or shift load during utility/ISO-called DR events. Model event dispatch based on program rules — notification lead time, event duration, max number of calls per season, performance measurement methodology.

**Output metrics:** Committed capacity (kW), event energy delivered (kWh), DR revenue ($), performance score.

### 8.3 Energy Arbitrage

Exploit time-of-use or wholesale price differentials. Optimize charge/discharge schedule against a price signal (TOU tariff or LMP forecast) subject to battery constraints.

**Output metrics:** Energy shifted (kWh), gross arbitrage revenue ($), net revenue after efficiency losses.

### 8.4 Frequency Regulation

Provide fast-response power injection/absorption to support grid frequency stability.

**Output metrics:** Regulation capacity offered, regulation revenue, SOC deviation, impact on degradation.

**Note.** Market-specific implementation (e.g., PJM RegD, ERCOT FFR) is confirmed during Phase 1.

### 8.5 Voltage Regulation (Reactive Power Support)

Provide reactive power (VAR) support to maintain local voltage within acceptable bands.

**Output metrics:** Reactive energy provided (kVARh), voltage compliance (%), active power curtailment due to reactive priority (if any).

**Note.** Implementation depth is confirmed during Phase 1.

---

## 9. Dispatch Optimization & Revenue Stacking

The engine implements a dispatch optimization layer capable of:

- **Co-optimizing across multiple value streams simultaneously** (e.g., peak shaving + arbitrage + frequency regulation)
- **Respecting physical constraints:** SOC bounds, power limits, ramp rates, minimum rest periods
- **Prioritization logic:** configurable hierarchy or economic optimization to resolve conflicts between competing use cases
- **Methodology options (to be confirmed in Phase 1):** rule-based heuristic, LP/MILP, or hybrid

---

## 10. Degradation Modeling

The software models battery capacity and efficiency degradation over the project lifetime:

- **Calendar aging:** time-dependent capacity fade as a function of temperature and average SOC
- **Cycle aging:** throughput-dependent degradation as a function of depth of discharge, C-rate, and temperature
- **Cumulative effect:** track equivalent full cycles, remaining capacity (SOH%), and trigger augmentation/replacement when capacity falls below contractual threshold
- **Feedback loop:** degradation impacts available energy in future periods, dynamically adjusting dispatch feasibility

**Proposed working assumption (subject to Phase 1 validation):** annual SOH update with representative-period simulation.

---

## 11. Financial Performance Outputs

The Financial Engine produces:

- **Net Present Value (NPV):** discounted net cash flows over contract term
- **Internal Rate of Return (IRR):** project and equity IRR
- **Simple Payback Period:** years to recover initial investment
- **Annual Revenue by Stream:** breakdown across peak shaving, DR, arbitrage, regulation
- **Demand Charge Savings:** monthly/annual reduction in billed demand
- **Degradation Cost:** estimated cost of capacity fade / augmentation

**Two sources of truth for value:**

| Value category | Source of truth |
|---|---|
| Behind-the-meter savings | Tariff Engine |
| Market revenues | Dispatch (attribution) → Market (settlement) → Financial (valuation) |

**Proposed working assumptions (subject to Phase 1 validation):** pre-tax initially; project IRR primary, equity IRR with configurable debt parameters.

---

## 12. Output & Reporting

- **Interactive dashboards (Databricks App):** time-series dispatch profiles, SOC heatmaps, revenue waterfall charts, scenario comparison
- **Exportable summary reports:** PDF and Excel

**Output mock** (KPI list + dashboard wireframe) prepared during Phase 1 and refined continuously. This anchors acceptance for the thin slice.

---

## 13. Deliverables

### 13.1 Final deliverables

A **production-oriented BESS operational and financial modeling solution**, including:

- Python modeling engine
- Databricks App
- Data pipelines (ingestion, validation, transformation)
- Validation framework
- Documentation (technical + methodology)
- Training materials and sessions
- Databricks deployment and handover

### 13.2 Supporting engineering baseline

The solution is delivered with a controlled engineering baseline:

```
Stage A — Engineering Definition
Stage B — System Architecture (HLD)
Stage C — Product Specification
Stage C → Stage D Handoff
Stage D — Implementation
```

The baseline ensures the solution is constructible, auditable, and transferable. It is not the product; it is the system that guarantees the product.

---

## 14. Phase 1 Clarification Items

The engagement proceeds under defensible working assumptions when ENGIE is slow to respond. Clarification items are organized in two tiers:

### 14.1 Blocking Items (Weeks 1–2)

| ID | Topic | Why Blocking |
|---|---|---|
| PH-001 | Target market(s) | Market rules drive eligibility, dispatch logic, settlement, revenue |
| PH-002 | BTM vs FTM scope | Determines which value streams and constraints apply |
| PH-003 | Data availability | Determines what can be modeled; drives ingestion design |
| PH-004 | Project configuration | Standalone vs co-located, generation type, grid constraints |
| PH-005 | Benchmark data | Required to define acceptance |
| PH-006 | Acceptance thresholds | Must be concrete before the thin slice is built |

### 14.2 Defaultable Items

Additional items with defensible working assumptions, including:

- Dispatch methodology: LP (proposed working assumption)
- Perfect foresight vs forecast-based: perfect foresight (proposed working assumption)
- Degradation feedback time scale: annual SOH update (proposed working assumption)
- Time resolution: 15-minute when input data permits; hourly otherwise (proposed working assumption)
- Representative-period scheme: monthly, respecting the billing period (proposed working assumption)
- Market adapter scope: one adapter at delivery (proposed working assumption)
- Scenario granularity: 3–5 core scenarios (proposed working assumption)

**The full clarification and assumptions register is included in the submission package as Appendix D.** Proposed working assumptions will be validated during Phase 1 and incorporated into the controlled engineering baseline before implementation.

---

## 15. Validation & Acceptance

### 15.1 Four validation levels

| Level | Scope |
|---|---|
| **Domain validation** | Validate each domain's inputs, outputs, and behavior against benchmarks |
| **Model validation** | Validate the integrated model against established benchmarks |
| **System validation** | Validate the full system at the application boundary |
| **UAT** | Validate the system against user scenarios |

**Validation must be defined before results are produced.**

### 15.2 Acceptance criteria

The solution is considered accepted upon:

1. Modeling results demonstrate **accuracy and alignment with established benchmarks**
2. System performance meets **expected execution and usability standards**
3. **Successful completion of UAT**
4. **Formal approval from project stakeholders**

### 15.3 Traceability chain

Every specification requirement is traceable to its origin:

```
ENGIE RFP
      ↓
Stage A — Requirements / Engineering Definition
      ↓
Stage B — Architecture
      ↓
Approved Clarifications / Derived Engineering Requirements
      ↓
Stage C — Product Specification
      ↓
Stage D — Implementation
      ↓
Verification & Testing
      ↓
UAT Evidence
```

---

## 16. Governance & Communication

Project execution includes:

- **Regular status meetings** with stakeholders
- **Periodic progress reporting**
- **Review sessions** at key project milestones
- **Structured communication channels** for issue tracking and resolution
- **Formal sign-off** at end of each stage (with lightweight-gate framing)

---

## 17. Team & Competencies

| Competency | Level |
|---|---|
| **SQL** | Advanced |
| **Financial Modeling** | Confirmed |
| **Databricks** | Advanced |
| **Python** | Confirmed |
| **PySpark** | Advanced |
| **Languages** | English |

**Role:** BESS Operational & Financial Modeling Consultant — 12-week contract, remote, English required.

---

## 18. Delivery Principles & Differentiators

### 18.1 Engineering discipline

- **Define before you build.** Stage A defines the engineering, Stage B defines the architecture, Stage C specifies the details, Stage D implements.
- **Thin vertical slice.** By week 4, an end-to-end demonstration exists. This de-risks delivery and validates scope with ENGIE.
- **Controlled parallel execution.** Stage C and Stage D progress together, with Stage D implementing only against baselined Stage C deliverables.

### 18.2 Architectural rigor

- **Ownership is explicit.** Market Engineering owns the semantic definition of the External Context; Data Engineering owns its ingestion and realization. Project Configuration is a scenario parameter.
- **Three invariants preserved.** Market owns External Context semantics; three degradation concepts do not collapse; two sources of truth for value.
- **Two cycles coupled, not collapsed.** Physical-operational and economic-financial remain distinct.
- **Settlement ≠ Financial Valuation.** Market settlement and financial valuation are separate steps in the chain.

### 18.3 Delivery robustness

- **Traceability chain** from RFP to UAT.
- **Meaning of "frozen"** declared: the controlled baseline against which implementation, verification, and change requests are evaluated.
- **Open items handling** — every unresolved item has an explicit disposition, owner, impact, and resolution path.

### 18.4 Extensibility

- New markets via new adapters
- New value streams via new operational modes
- New System Context configurations via configuration extensions
- Co-located configurations as architecture extension
- Deeper analytical fidelity without restructuring

**The platform is designed to accommodate new markets, value streams, and system configurations through modular extensions rather than fundamental re-architecture.**

---

## 19. Risk Management

| Risk | Impact | Mitigation |
|---|---|---|
| Unresolved clarification items | Medium | Proceed with working defaults; handle per open-items policy |
| Solver selection | Medium | Evaluate candidate solvers against required formulations |
| Databricks platform constraints | Medium | Early platform validation; controlled feedback |
| UAT data availability | Medium | Synthetic/approved substitute scenarios |
| Cross-deliverable interface drift | Medium | Change control; interface freeze after specification phase |
| Implementation shortcuts into specification | High | Enforce level-of-detail rule |

---

## 20. Closing Statement

ENGIE requires a **disciplined, domain-driven approach** to a complex analytical software problem. The RFP asks for three parallel deliverables — ENGINEERING, SOFTWARE, and DELIVERY — each carrying its own scope, risk, and delivery obligations.

Our proposed approach:

- **Establishes engineering definition** before building.
- **Produces a frozen architectural baseline** before writing code.
- **Delivers a thin end-to-end slice by week 4** to de-risk delivery and validate scope.
- **Runs Stage C and Stage D in controlled parallel** from week 3.
- **Closes with deployment, documentation, and training** in week 12.

The result is a **Python-based modeling engine** on **Databricks**, with **PySpark** parallelization and **SQL** data infrastructure, surfaced through a **Databricks App**, producing robust, auditable analytical outputs that demonstrate project performance, viability, and value to both external clients and internal stakeholders.

The system connects **system context, data, forecast, physics, dispatch, degradation, revenue, and finance** into a single auditable chain — and it is **designed to accommodate new markets, value streams, and system configurations through modular extensions rather than fundamental re-architecture**.

We look forward to collaborating with ENGIE on this engagement.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Duration:** 12 Weeks
**Language:** English

---

## Appendix A — Engineering Definition (Baseline)

**Included in the submission package.** Contains the System Component Definition and the seven engineering domain chapters established in the Engineering Definition stage.

---

## Appendix B — System Architecture (Baseline)

**Included in the submission package.** Contains the Integrated System Architecture, Data Architecture, Model Architecture, Optimization Architecture, Financial Architecture, Software Architecture, and Databricks Architecture established in the System Architecture stage.

---

## Appendix C — Technical Evidence / Prototype

**Included in the submission package.** Contains the Concept Prototype derived from the architecture baseline, demonstrating:

```
Scenario → Data → Market / Value Streams → Dispatch → Results → Financial → Traceability
```

The prototype is presented as **technical evidence**, not as a finished product. It demonstrates the architectural claims of this proposal in a runnable form.

---

## Appendix D — Clarification & Assumptions Register

**Included in the submission package.** Contains the consolidated clarification items, their priority (blocking / defaultable), working assumptions, status, and resolution path.

---

**Ready to send.**