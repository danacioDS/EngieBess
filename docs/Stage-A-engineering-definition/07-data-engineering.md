# Data & Application Engineering
## Stage A.2.7 — Conceptual Engineering
### Execution and Delivery Layer of the BESS Operational & Financial Modeling System

**Document ID:** A.2.7-DATA-APP-ENG-001

**Version:** 0.3 — Development Baseline

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Development Baseline

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.3)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.4)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v1.0)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.4)
- `A.2.6-FIN-ENG-001` — Financial Engineering (v0.3)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)

**Domain:** Domain 7 — Data & Application Engineering

**Purpose:** Define, at a conceptual level, what the Data & Application Engineering domain represents, what it consumes from Domains 1–6 and cross-cutting capabilities, what it produces, how it executes and delivers the analytical system, and what engineering decisions must be made in later stages — **without** prescribing software architecture, schemas, or implementation.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.7 — Conceptual Engineering** of the Data & Application Engineering domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §4.

Its purpose is to establish the **conceptual engineering definition** of the domain that converts the analytical system into an **executable and usable software product** — the bridge between data, models, results, and users.

It answers, at conceptual level:

- What Data & Application Engineering is responsible for
- What it consumes from Domains 1–6 and cross-cutting capabilities
- What it produces to users
- How it handles data ingestion, transformation, validation, and processing
- How it executes the modeling engine
- How it exposes results to users
- How it manages scenarios and configuration
- What cross-cutting capabilities it supports
- What modeling traps it must address
- What is **not** decided here (and who decides it)

It deliberately does **not** define:

- Software architecture
- Databricks workspace structure
- Delta table schemas
- PySpark implementation
- SQL queries
- API specifications
- Class structures
- Notebook designs
- Dashboard layouts
- Deployment procedures

Those belong to Stage B (architecture), Stage C (specification), and Stage D (implementation).

### 1.1 Decision Layers — Methodology, Architecture, Formulation

| Layer | Decided in | What it fixes |
|---|---|---|
| **Methodology** | **Phase 1** | Platform choices, workspace ownership, deployment model |
| **Architecture** | **Stage B** | Data architecture, software architecture, Databricks architecture |
| **Formulation** | **Stage B / C** | Schemas, pipelines, APIs, orchestration |
| **Detailed formulation** | **Stage C** | Table definitions, query optimization, app layouts, deployment scripts |

### 1.2 Working Defaults

| Default | Source | Value |
|---|---|---|
| Reporting format | **PH-047** | **Both PDF and Excel** |
| Audit scope | **PH-048** | **Basic execution logs + data lineage**; full audit framework deferred |
| Market adapter scope | **PH-053** | **One adapter at delivery**; architecture supports more |
| Databricks workspace | **PH-046** | **ENGIE-owned workspace**; consultant granted developer access |
| Solver licensing | **PH-004** | **TBD — open-source solver preferred unless ENGIE provides commercial license** |

Each default is revisable if ENGIE indicates otherwise.

### 1.3 Position Within Stage A

This document sits **after** Domains 1–6. It is the **execution and delivery layer** — the bridge between the analytical system and the user.

Unlike the other six domains, Data & Application Engineering is **implementation-oriented**: it does not add analytical logic, but it makes the analytical system executable and usable.

### 1.4 The Most Important Boundary in This Document

> **Data & Application Engineering provides execution and delivery. It does not define BESS physics, operational requirements, dispatch logic, degradation models, or financial methodology.**

Data & Application Engineering is a **technology layer**, not a domain of modeling responsibility. It executes the models defined by Domains 1–6 and delivers results to users.

### 1.5 Relationship to Domains and Cross-Cutting Capabilities

| Source | What it provides to Data & Application |
|---|---|
| **BESS Engineering (A.2.1)** | Physical capability model to be executed |
| **Load & Market Engineering (A.2.2)** | External signal models to be executed |
| **Operational Engineering (A.2.3)** | Value stream behaviors to be executed |
| **Dispatch (A.2.4)** | Dispatch logic to be executed |
| **Degradation (A.2.5)** | Degradation logic to be executed |
| **Financial (A.2.6)** | Financial logic to be executed |
| **Scenario Management** *(cross-cutting)* | Scenario parameterization and orchestration |
| **Validation** *(cross-cutting)* | Validation criteria and evidence requirements |

### 1.6 Cross-Cutting Capabilities

**Scenario Management and Validation are cross-cutting system capabilities, not additional engineering domains.**

Data & Application Engineering provides the **execution, configuration, storage, and presentation mechanisms** through which these capabilities are operationalized:

| Capability | Data & Application provides |
|---|---|
| **Scenario Management** | Scenario configuration interface, parameter management, scenario orchestration, scenario comparison views |
| **Validation** | Validation execution, evidence storage, validation reporting, cross-domain validation orchestration |

The seven engineering domains remain seven. Scenario Management and Validation are **not** an eighth and ninth domain.

### 1.7 Generality Principle

This document defines **generic execution and delivery concepts** — parameterizable for different platforms, workspaces, and deployments. It does not hard-code a specific Databricks configuration, workspace structure, or deployment model.

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Data & Application Engineering domain** is the conceptual representation of the **execution and delivery layer** that:

- Ingests, transforms, validates, and processes data
- Executes the modeling engine
- Stores intermediate and final results
- Manages scenarios and configuration
- Exposes results to users through an application
- Produces reports and exports
- Provides audit and lineage

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| A physical model | Physical capability belongs to Domain 1 |
| A market model | External signals belong to Domain 2 |
| An operational model | Value stream behavior belongs to Domain 3 |
| A dispatch model | Dispatch belongs to Domain 4 |
| A degradation model | Degradation belongs to Domain 5 |
| A financial model | Economic valuation belongs to Domain 6 |
| A decision-making domain | Data & Application executes; it does not decide |
| A business logic domain | Business logic belongs to Domains 1–6 |
| A scenario management domain | Scenario Management is cross-cutting |
| A validation domain | Validation is cross-cutting |

### 2.3 Primary Question

> **How does the user provide information, execute models, and consume results?**

### 2.4 Guiding Principle

> **Data & Application Engineering provides execution and delivery. It executes the models defined by Domains 1–6 and delivers results to users. It does not add analytical logic.**

---

## 3. Engineering Scope

| # | Aspect | Description |
|---|---|---|
| 1 | Data ingestion | Acquiring data from sources |
| 2 | Data transformation | Converting raw data to model-ready inputs |
| 3 | Data validation | Ensuring data quality and consistency |
| 4 | Data processing | Preparing data for model execution |
| 5 | Data storage | Persisting inputs, intermediate results, and outputs |
| 6 | Model execution | Running the analytical system |
| 7 | Scenario configuration | Defining and parameterizing scenarios |
| 8 | Parameter management | Handling input parameters across scenarios |
| 9 | Workflow orchestration | Coordinating execution steps |
| 10 | Visualization | Displaying results interactively |
| 11 | Reporting | Generating exportable reports |
| 12 | Scenario comparison | Presenting comparative views |
| 13 | Execution and lineage records | Tracing data and execution |
| 14 | Deployment and training | Delivering the platform to users |

The domain does **not**:
- Define the analytical models (Domains 1–6)
- Decide dispatch (Domain 4)
- Compute degradation (Domain 5)
- Compute financial value (Domain 6)
- Own Scenario Management or Validation (cross-cutting)

---

## 4. Conceptual Model of Data & Application Engineering

### 4.1 High-Level Structure

```
    Inputs from Domains 1–6    Scenario Configuration    Validation Criteria
              │                        │                        │
              └──────────┬─────────────┴────────────────────────┘
                         ▼
        ┌──────────────────────────────────┐
        │   DATA & APPLICATION ENGINEERING │
        │                                  │
        │  • Data ingestion                │
        │  • Data transformation           │
        │  • Data validation               │
        │  • Data processing               │
        │  • Data storage                  │
        │                                  │
        │  • Model execution               │
        │  • Scenario configuration        │
        │  • Parameter management          │
        │  • Workflow orchestration        │
        │                                  │
        │  • Visualization                 │
        │  • Reporting                     │
        │  • Scenario comparison           │
        │  • Execution and lineage records │
        └──────────────────────────────────┘
                         │
                         ▼
                    Users
                    (Databricks App)
```

### 4.2 Conceptual Sub-Areas

| Sub-Area | Conceptual Role |
|---|---|
| Data ingestion | Acquiring raw data from sources |
| Data transformation | Converting raw data to model-ready form |
| Data validation | Ensuring data quality |
| Data processing | Preparing data for execution |
| Data storage | Persisting inputs, intermediate, outputs |
| Model execution | Running the analytical system |
| Scenario configuration | Defining scenarios and parameters |
| Parameter management | Handling parameter overrides |
| Workflow orchestration | Coordinating execution |
| Visualization | Interactive display |
| Reporting | Exportable reports |
| Scenario comparison | Comparative views |
| Execution and lineage records | Traceability |
| Deployment and training | Delivery to users |

### 4.3 Data & Application Boundary

| Inside the domain | Outside the domain |
|---|---|
| Data ingestion | Data definition (Domain 2) |
| Data transformation | Analytical models (Domains 1–6) |
| Data validation | Model logic |
| Data processing | Dispatch decisions (Domain 4) |
| Data storage | Financial methodology (Domain 6) |
| Model execution | Scenario parameterization (Scenario Management) |
| Visualization | Model design |
| Reporting | Business rules |
| Scenario comparison | — |
| Execution and lineage records | — |

---

## 5. Inputs to Data & Application Engineering

### 5.1 From Domains 1–6 and Cross-Cutting Capabilities

Data & Application Engineering executes the models defined by Domains 1–6 and consumes their **model inputs and model interfaces** — the data and parameters each domain declares. It does not consume every internal quantity, only the declared interfaces.

| Input type | Source |
|---|---|
| BESS technical parameters | BESS Engineering (A.2.1) |
| Load data, market data, program data, grid data | Load & Market Engineering (A.2.2) |
| Operational requirements and value stream definitions | Operational Engineering (A.2.3) |
| Dispatch inputs (prices, load, program rules, scenario variations) | Dispatch (A.2.4) |
| Degradation inputs (operating history, environmental, physical) | Degradation (A.2.5) |
| Financial assumptions and cost data | Financial (A.2.6) |
| Scenario parameters | Scenario Management *(cross-cutting)* |
| Validation criteria | Validation *(cross-cutting)* |

**Note.** Data & Application Engineering does **not** consume its own outputs as if it were another upstream domain.

### 5.2 From Users

| Input | Meaning |
|---|---|
| Scenario definitions | Which scenarios to run |
| Parameter overrides | Scenario-specific parameter values |
| Run requests | When to execute |
| Review requests | Which results to inspect |
| Export requests | Which reports to generate |

### 5.3 From External Sources

| Input | Meaning |
|---|---|
| Market data feeds | Price curves, ancillary prices (where ENGIE provides) |
| Meter data | Historical load data (where ENGIE provides) |
| Benchmark data | Reference cases and expected results (where ENGIE provides) |
| Environmental data | Temperature profiles (where ENGIE provides) |

### 5.4 What Data & Application Engineering Does Not Consume

- Model logic (executed, not consumed)
- Business decisions (only parameters)
- Analytical assumptions (scenario parameters)

---

## 6. Data Management

### 6.1 Data Ingestion

**Concept.** Acquiring raw data from sources and making it available to the analytical system.

**Conceptual requirements:**

- Ingest data from multiple source types (files, databases, APIs, streaming — where applicable)
- Handle different formats (CSV, Excel, JSON, Parquet, etc.)
- Handle different time resolutions (15-minute, hourly, daily, monthly, annual)
- Track ingestion metadata (source, timestamp, version)
- Support incremental and full-refresh ingestion

**What is not decided here:** the specific ingestion mechanism (batch, streaming, hybrid), the specific source connectors, the specific formats supported. Those belong to Stage B/C.

### 6.2 Data Transformation

**Concept.** Converting raw data into model-ready inputs.

**Conceptual requirements:**

- Align data to a common time reference (per `A.2.2` §11.2)
- Handle missing values, outliers, and anomalies
- Compute derived quantities (e.g. peak demand, billing determinants)
- Apply unit conversions
- Preserve lineage (which transformation produced which output)

**What is not decided here:** the specific transformation logic, the specific time-alignment strategy, the missing-data handling method. Those belong to Stage B/C.

### 6.3 Data Validation

**Concept.** Ensuring data quality and consistency before execution.

**Conceptual requirements:**

- Validate data completeness (all required fields present)
- Validate data types and ranges
- Validate structural consistency (e.g. tariff periods contiguous)
- Validate cross-signal alignment (e.g. load and price series aligned in time)
- Produce validation evidence (per the Validation cross-cutting capability)

**What is not decided here:** the specific validation rules, thresholds, and remediation strategies. Those belong to Stage B/C.

### 6.4 Data Processing

**Concept.** Preparing data for the modeling engine — combining, aligning, and structuring it into the inputs each domain requires.

**Conceptual requirements:**

- Assemble domain-specific inputs from ingested and transformed data
- Ensure each domain receives the inputs it declares
- Support scenario-parameterized inputs (different values per scenario)
- Preserve provenance (which source data contributed to which input)

### 6.5 Data Storage

**Concept.** Persisting inputs, intermediate results, and outputs.

**Conceptual requirements:**

- Persist input data (raw, transformed, processed)
- Persist intermediate results (dispatch schedules, SOC trajectories, degradation states)
- Persist final results (operational outputs, financial KPIs, attribution)
- Support query and retrieval by scenario, by run, by time period
- Support versioning (which run used which inputs)
- Support reproducibility (same inputs produce same outputs)

**What is not decided here:** the specific storage technology, the specific table design, the specific partitioning strategy. Those belong to Stage B/C.

### 6.6 What Data & Application Engineering Does Not Do With Data

- It does not define what data means (Domains 1–6 define that)
- It does not decide which data to collect (Domains 1–6 declare requirements)
- It does not decide how data is used analytically (Domains 1–6 decide that)

---

## 7. Model Execution

### 7.1 Execution Concept

**Concept.** Running the analytical system defined by Domains 1–6.

**Conceptual requirements:**

- Execute the full causal chain: BESS → Operational → Dispatch → Degradation → Financial
- Execute per scenario
- Respect the declared dependencies between domains
- Execute the feedback loop (Dispatch ↔ Degradation)
- Support parallelization across scenarios and representative periods (per `SYS-STR-FRM-001` §9.3)
- Produce intermediate and final results

### 7.2 Conceptual Execution Dependencies

The following is a **conceptual view of execution dependencies**, not a defined workflow. The precise execution graph and orchestration pattern are **Stage B decisions**.

```
Scenario
  │
  ▼
Input preparation
  │
  ▼
Domain model execution according to declared dependencies
  │
  ├── BESS capability
  ├── Operational model
  ├── Dispatch ↔ Degradation feedback
  │
  ▼
Tariff and financial evaluation
  │
  ▼
Validation
  │
  ▼
Results persistence
  │
  ▼
Application / Reporting
```

**Note.** The tariff engine may need to be evaluated in coordination with the representative-period loop for demand charges, billing periods, and ratchets. The exact coupling between tariff evaluation and the dispatch/degradation loop is a **Stage B decision**.

### 7.3 Parallelization

Per `SYS-STR-FRM-001` §9.3, parallelization is valid across:

- **Scenarios** — the primary axis
- **Representative periods within a year** — valid when SOH is held fixed within the year
- **Sensitivity analyses** — each case is an independent scenario

Parallelization is **not** valid across:

- **Project years** — SOH carries forward
- **Rolling-horizon windows** — SOC carries forward
- **Within a single dispatch optimization** — single-node computation

### 7.4 What Data & Application Engineering Does Not Do With Execution

- It does not define execution logic (Domains 1–6)
- It does not decide which value streams are active (Domain 4)
- It does not compute degradation (Domain 5)
- It does not compute financial value (Domain 6)
- It does not define the execution graph (Stage B)

---

## 8. Scenario Configuration and Parameter Management

### 8.1 Scenario Configuration

**Concept.** Defining and parameterizing scenarios for execution.

**Conceptual requirements:**

- Define scenario identity (name, description, version)
- Configure parameters per scenario (BESS config, market scenario, financial assumptions, project configuration)
- Support scenario inheritance (base scenario + variations)
- Support scenario comparison (which scenarios to compare)
- Support parameter validation

**Project Configuration as scenario parameter.** Per `SYS-STR-FRM-001` §3.4 and `SYS-ENG-DEF-001` §4, Project Configuration (standalone / co-located / BTM / FTM / AC-DC coupling) is a scenario parameter. Data & Application Engineering provides the mechanism to configure it, but does not own it.

### 8.2 Parameter Management

**Concept.** Handling input parameters across scenarios.

**Conceptual requirements:**

- Support parameter override per scenario
- Support default values (per Strategy defaults)
- Support parameter documentation (what each parameter means)
- Support parameter validation (within acceptable ranges)
- Support parameter versioning (which parameters were used in which run)

### 8.3 What Data & Application Engineering Does Not Do With Configuration

- It does not define what parameters exist (Domains 1–6)
- It does not decide default values (Strategy and Phase 1 decisions)
- It does not decide scenario content (Users decide)

---

## 9. Visualization and Reporting

### 9.1 Visualization

**Concept.** Presenting results interactively through an application.

**Conceptual requirements:**

- Present dispatch profiles (power, SOC over time)
- Present operational results (energy shifted, peak reduced, regulation provided)
- Present financial results (revenue by stream, cash flows, KPIs)
- Present degradation evolution (SOH over project life)
- Present scenario comparison views
- Support drill-down (from aggregate to detail)
- Support filtering and selection (by scenario, by time period, by value stream)

### 9.2 Reporting

**Concept:** Generating exportable reports.

**Conceptual requirements:**

- Generate PDF reports (business development audience)
- Generate Excel reports (analyst audience)
- Include standard KPI sections
- Include scenario comparison sections
- Support ENGIE branding (where required)

**Working default (PH-047):** Both PDF and Excel.

### 9.3 Scenario Comparison

**Concept.** Presenting comparative views across scenarios.

**Conceptual requirements:**

- Compare NPV, IRR, payback across scenarios
- Compare revenue composition across scenarios
- Compare cash flow timing across scenarios
- Highlight key differences

### 9.4 What Data & Application Engineering Does Not Do With Visualization

- It does not compute what is displayed (Domains 1–6 compute that)
- It does not decide what matters (Users decide)
- It does not define the KPIs (Domains 6 and Strategy define them)

---

## 10. Execution and Lineage Records

### 10.1 Execution Logs

**Concept.** Recording what was executed, when, with what inputs, and with what outcomes.

**Conceptual requirements:**

- Log each execution (scenario, timestamp, user, parameters)
- Log intermediate steps (which domain executed, how long)
- Log errors and warnings
- Support retrieval of logs for debugging

**Working default (PH-048):** Basic execution logs.

### 10.2 Data Lineage

**Concept.** Tracing data from source through transformation to result.

**Conceptual requirements:**

- Track which source data contributed to which input
- Track which transformation produced which output
- Track which input produced which result
- Support retrieval of lineage for audit

**Working default (PH-048):** Basic data lineage.

### 10.3 Reproducibility

**Concept.** Ensuring that the same inputs produce the same outputs.

**Conceptual requirements:**

- Version inputs, parameters, and code
- Support re-execution with identical conditions
- Support replay of historical runs

### 10.4 Audit Scope

**Working default (PH-048):** **Basic execution logs + data lineage**. Full audit framework (compliance-grade audit, retention policies, access controls) is deferred.

### 10.5 What Data & Application Engineering Does Not Do With Audit

- It does not decide what to audit (Strategy and ENGIE decide)
- It does not define compliance requirements (ENGIE decides)
- It does not interpret audit results (Users decide)

---

## 11. Deployment and Training

### 11.1 Deployment

**Concept.** Delivering the platform to users.

**Conceptual requirements:**

- Deploy to the ENGIE-owned Databricks workspace (per **PH-046**)
- Configure access and permissions
- Configure compute resources
- Configure storage locations
- Support updates and versioning
- Support rollback where applicable

**Working default (PH-046):** ENGIE-owned workspace; consultant granted developer access.

### 11.2 Training

**Concept.** Training ENGIE's users to operate the platform.

**Conceptual requirements:**

- Document the modeling methodology
- Document the user workflows
- Train business development users on scenario configuration and results interpretation
- Train technical users on parameter management and maintenance
- Provide supporting materials

**Working default (PH-012):** Training covers both business development users and technical maintainers.

### 11.3 Documentation

**Concept.** Providing comprehensive documentation.

**Conceptual requirements:**

- Technical documentation covering architecture, interfaces, data contracts, and operational procedures as defined in later stages
- Modeling methodology documentation
- User documentation (workflows, screens, parameters)
- Maintenance documentation (how to update, extend, debug)

### 11.4 What Data & Application Engineering Does Not Do With Deployment

- It does not decide the deployment model (ENGIE and Phase 1 decide)
- It does not decide training content (depends on user roles — **PH-012**)
- It does not define the modeling methodology (Domains 1–6 define it)

---

## 12. Technology Stack

### 12.1 Technology Requirements and Interpretations

The RFP specifies Python, Databricks, PySpark, SQL, and Databricks App. This section distinguishes:

- **RFP requirement** — what ENGIE specified
- **Engineering interpretation** — how the requirement is interpreted at the conceptual level
- **Proposed architecture** — the actual architecture, decided in Stage B

| Technology | RFP requirement | Engineering interpretation | Architecture decision |
|---|---|---|---|
| **Python** | Required | Primary modeling engine | Stage B |
| **PySpark** | Required | Parallelization across scenarios, representative periods, sensitivities; large-scale data transformation | Stage B |
| **SQL** | Required | Data access, transformation, validation, querying | Stage B |
| **Databricks** | Required | Execution / orchestration / platform | Stage B |
| **Databricks App** | Required | User interaction and presentation | Stage B |

**Note.** The engineering interpretation above constrains the **boundary** of each technology — what it is and is not responsible for. The concrete architecture is decided in Stage B.

### 12.2 Technology Boundaries

| Technology | Boundary |
|---|---|
| **Python** | Primary modeling engine; sequential stateful logic remains in Python |
| **PySpark** | Parallel scenario / representative-period execution and large-scale transformations; not the owner of sequential state evolution |
| **SQL** | Data access, transformation, validation, and querying; not modeling logic |
| **Databricks** | Execution / orchestration / platform; not model definition |
| **Databricks App** | User interaction and presentation; not modeling logic |

### 12.3 What Is Not Decided Here

- Specific Databricks configuration (cluster sizes, runtime versions)
- Specific workspace structure (folders, catalogs, schemas)
- Specific PySpark implementation (RDDs vs DataFrames vs SQL)
- Specific App framework
- Specific deployment automation
- Solver licensing (see **PH-004**)

Those belong to Stage B/C.

---

## 13. Modeling Traps

| Trap | Why It Matters | Conceptual Approach |
|---|---|---|
| **Data quality issues propagating to results** | Missing or anomalous data in inputs produces unreliable results | Data validation is a first-class step (§6.3) |
| **Time misalignment across signals** | Load, price, and program data must share a common time reference | Align to a common time reference (`A.2.2` §11.2) |
| **Silent failures** | Missing data or unhandled conditions may pass silently and produce wrong results | Validation evidence produced before results are accepted |
| **Versioning drift** | If parameters, data, or code change without versioning, runs cannot be reproduced | Version inputs, parameters, code (§10.3) |
| **Scenario leakage** | Parameter overrides in one scenario accidentally affecting another | Scenario isolation in configuration |
| **Over-parallelization of sequential computations** | Parallelizing across project years or rolling horizons breaks the feedback loop | Parallelization only across scenarios, representative periods (SOH fixed), sensitivities (`SYS-STR-FRM-001` §9.3) |
| **Reporting format ambiguity** | Different audiences need different formats | Both PDF and Excel (PH-047) |
| **Audit scope creep** | Full audit framework is out of initial scope | Basic execution logs + data lineage (PH-048) |
| **Environment mismatch** | Development, staging, production environments behaving differently | Environment parity as a deployment requirement |
| **User workflow complexity** | The App must be usable by business development users, not only analysts | Output mock prepared during Phase 1 (`SYS-STR-FRM-001` §8.3) |
| **Premature execution graph definition** | Fixing the execution order in Stage A may constrain Stage B architecture prematurely | §7.2 declares conceptual dependencies only |

---

## 14. Interface with BESS Engineering (Conceptual)

### 14.1 What Data & Application Engineering Provides

Data & Application Engineering provides **execution and delivery** for the BESS Engineering model:

- Ingest BESS parameters
- Execute BESS capability model
- Store BESS state (SOC, SOH, availability)
- Provide BESS state to downstream domains

### 14.2 Boundary Discipline

BESS Engineering defines **what the BESS can do**. Data & Application Engineering **executes** that model and stores its outputs.

---

## 15. Interface with Load & Market Engineering (Conceptual)

### 15.1 What Data & Application Engineering Provides

- Ingest load data, market data, program data, grid data
- Transform, validate, process external signals
- Execute tariff engine
- Store external signals and bill outputs
- Provide signals to downstream domains

### 15.2 Boundary Discipline

Load & Market Engineering defines **what external signals are**. Data & Application Engineering **ingests, transforms, executes, and stores** them.

---

## 16. Interface with Operational Engineering (Conceptual)

### 16.1 What Data & Application Engineering Provides

- Execute operational value stream definitions
- Store operational requirements and service metrics
- Provide operational requirements to Dispatch

### 16.2 Boundary Discipline

Operational Engineering defines **how each value stream uses the BESS**. Data & Application Engineering **executes and stores** that definition.

---

## 17. Interface with Dispatch & Optimization (Conceptual)

### 17.1 What Data & Application Engineering Provides

- Execute dispatch optimization
- Store dispatch schedule, SOC trajectory, battery power trajectory
- Store operational attribution basis
- Provide dispatch results to Degradation and Financial
- Provide battery power trajectory to Load & Market (net load derivation)

### 17.2 Boundary Discipline

Dispatch defines **what should be done**. Data & Application Engineering **executes and stores** the dispatch results.

---

## 18. Interface with Degradation Engineering (Conceptual)

### 18.1 What Data & Application Engineering Provides

- Execute degradation model
- Derive cycling metrics from power and SOC trajectories
- Store SOH, available capacity, marginal degradation cost
- Store augmentation and replacement events
- Provide degradation outputs to Dispatch and Financial

### 18.2 Boundary Discipline

Degradation defines **how the battery changes over time**. Data & Application Engineering **executes and stores** the degradation model.

---

## 19. Interface with Financial Engineering (Conceptual)

### 19.1 What Data & Application Engineering Provides

- Execute financial model
- Store financial KPIs, cash flows, revenue by stream
- Store scenario comparison outputs
- Provide financial results for visualization and reporting

### 19.2 Boundary Discipline

Financial defines **what value results**. Data & Application Engineering **executes and stores** the financial model and exposes it to users.

---

## 20. Interface with Scenario Management (Conceptual)

### 20.1 What Data & Application Engineering Provides

- Scenario configuration interface
- Parameter management
- Scenario orchestration
- Scenario comparison views

### 20.2 Boundary Discipline

Scenario Management defines **what scenarios are and how they are compared**. Data & Application Engineering **provides the interface and orchestration**.

---

## 21. Interface with Validation (Conceptual)

### 21.1 What Data & Application Engineering Provides

- Validation evidence storage
- Validation execution
- Validation reporting
- Cross-domain validation orchestration

### 21.2 Boundary Discipline

Validation defines **what to validate and how**. Data & Application Engineering **executes and stores** validation evidence.

---

## 22. Assumptions and Engineering Uncertainties

### 22.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | Data & Application Engineering executes, does not define | Preserves domain boundaries | Would blur analytical and technology layers |
| 2 | Working stack is Python, PySpark, SQL, Databricks, Databricks App | Per RFP | Would require alternative stack |
| 3 | PySpark parallelizes across scenarios, representative periods, sensitivities | Consistent with `SYS-STR-FRM-001` §9.3 | Would break feedback loop |
| 4 | Reporting format is both PDF and Excel | Working default **PH-047** | Would change reporting design |
| 5 | Audit scope is basic execution logs + data lineage | Working default **PH-048** | Would change audit design |
| 6 | ENGIE owns the workspace; consultant has developer access | Working default **PH-046** | Would change deployment model |
| 7 | One market adapter at delivery | Working default **PH-053** | Would change adapter architecture |
| 8 | Users include business development and technical maintainers | Working default **PH-012** | Would change training content |
| 9 | Execution graph is defined in Stage B | Preserves Stage A scope | Would prematurely constrain architecture |
| 10 | Scenario Management and Validation are cross-cutting, not domains | Consistent with `SYS-ENG-DEF-001` §4.1 | Would inflate the domain count |

### 22.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Databricks environment configuration | **PH-046** |
| 2 | Workspace ownership and access | **PH-046** |
| 3 | Reporting requirements and branding | **PH-047** |
| 4 | Audit scope | **PH-048** |
| 5 | Users and roles | **PH-012** |
| 6 | Solver licensing | **PH-004** |
| 7 | Deployment model | **Stage B** |
| 8 | Data ingestion mechanisms | **Stage B** |
| 9 | Storage design | **Stage B** |
| 10 | App framework | **Stage B / C** |
| 11 | Environment parity requirements | **Stage B** |
| 12 | Execution graph and orchestration | **Stage B** |
| 13 | Training content and audience | **PH-012** / Phase 4 |

### 22.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `PH1-REG-001` v1.1:

- **PH-004** — Solver licensing
- **PH-012** — Users and handover
- **PH-046** — Databricks environment
- **PH-047** — Reporting requirements
- **PH-048** — Audit / lineage / traceability scope

**Note.** PH IDs are assigned in `PH1-REG-001` v1.1, the authoritative consolidated Register.

---

## 23. Conceptual Outputs of the Domain

| Output | Consumer | Nature |
|---|---|---|
| Interactive dashboards | Users | Application views |
| Exportable reports (PDF) | Users | Documents |
| Exportable reports (Excel) | Users | Spreadsheets |
| Scenario comparison views | Users | Application views |
| Execution logs | Users, validation | Structured records |
| Data lineage | Users, validation | Structured records |
| Execution and lineage records | Users | Structured records |
| Validation evidence | Users, validation | Structured records |
| Training materials | Users | Documents |
| Technical documentation | Users | Documents |

**Note on audit.** "Execution and lineage records" reflects the working default of **PH-048** (basic execution logs + data lineage). A full audit framework is not committed in the initial scope.

---

## 24. Validation Requirements (Conceptual)

### 24.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Data validation | Inputs pass completeness, type, range, structural, and alignment checks |
| Execution validation | All declared execution dependencies are respected |
| Storage validation | Results are persisted and retrievable |
| Visualization validation | What is displayed matches what was computed |
| Reporting validation | Reports contain the declared content |
| Reproducibility | Same inputs and parameters produce same outputs |

### 24.2 Interface Validation

| Check | Nature |
|---|---|
| Input completeness | All declared inputs are ingested |
| Output completeness | All declared outputs are produced |
| Interface consistency | Interfaces between domains match declarations |
| Orchestration correctness | Execution dependencies are respected |

### 24.3 Validation Evidence

Validation evidence must be **produced before results are accepted**.

---

## 25. Boundaries — Explicit

### 25.1 Answers

- How does the user provide information?
- How are scenarios configured?
- How is the model executed?
- How are results stored and retrieved?
- How are results visualized and reported?
- How are data lineage and execution logs maintained?
- How is the platform deployed and maintained?
- How are users trained?

### 25.2 Does Not Answer

- What can the BESS physically do? (Domain 1)
- What is the external environment? (Domain 2)
- How does each value stream use the BESS? (Domain 3)
- How should the BESS be dispatched? (Domain 4)
- How does the battery degrade? (Domain 5)
- What economic value results? (Domain 6)
- What should be decided? (Users)
- What is the execution graph? (Stage B)

### 25.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| Domains 1–6 | Data & Application | Data contracts, execution interfaces |
| Scenario Management | Data & Application | Scenario configuration, parameter management |
| Validation | Data & Application | Validation criteria, evidence requirements |
| Data & Application | Users | Dashboards, reports, comparison views |
| Data & Application | Domains 1–6 | Execution infrastructure |

---

## 26. What Is Deliberately NOT Defined Here

### Software Architecture
- Python package structure
- Classes, functions, APIs
- Databricks workspace structure
- Notebooks, services
- App framework

### Data Architecture
- Physical tables, schemas
- Delta tables, partitioning
- Data pipeline implementation
- Ingestion mechanisms

### Numerical Methods
- Integration scheme
- Time step selection
- Numerical tolerance
- Solver configuration

### Execution Graph
- Precise execution order
- Orchestration pattern
- Coupling between tariff evaluation and the dispatch/degradation loop

### Deployment Details
- Cluster sizes, runtime versions
- CI/CD pipelines
- Environment configuration
- Monitoring and alerting

### UI Details
- Screen designs
- Dashboard layouts
- Interaction patterns
- Color schemes

### Security
- Access controls
- Encryption
- Compliance

These belong to Stage B, Stage C, Stage D, or to Phase 1 decisions.

---

## 27. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.9 | §5 Domain 7, §6.2 Causal Backbone, §8.2 Validation, §8.3 Output Mock, §9.3 Technology Strategy, §10 Engagement Timeline, §12.2 defaults | Yes |
| `SYS-ENG-DEF-001` v0.6 | §4.1 Cross-Cutting Capabilities, §12 Domain 7, §13 Inter-Domain Contract | Yes |
| `A.2.1`–`A.2.6` | Data contracts and execution interfaces | Yes |
| RFP-264144-1 | Python, Databricks, PySpark, SQL, Databricks App, dashboards, exportable reporting, documentation, training | Yes |
| `PH1-REG-001` v1.1 | PH-004, PH-012, PH-046, PH-047, PH-048 | Yes |

**Traceability note.** PH IDs referenced in this document will be verified against `PH1-REG-001` v1.1 during the Stage A consolidation audit.

---

## 28. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Working default |
|---|---|---|---|
| 1 | Databricks configuration | Stage B / **PH-046** | ENGIE-owned workspace |
| 2 | Workspace structure | Stage B | — |
| 3 | Data ingestion mechanisms | Stage B | — |
| 4 | Data storage design | Stage B | — |
| 5 | Data transformation logic | Stage B / C | — |
| 6 | Data validation rules | Stage B / C | — |
| 7 | Execution graph and orchestration | Stage B | — |
| 8 | Parallelization strategy | Stage B | Scenarios, periods, sensitivities |
| 9 | App framework | Stage B / C | Databricks App |
| 10 | Dashboard layouts | Stage C | — |
| 11 | Report templates | Stage C / **PH-047** | Both PDF and Excel |
| 12 | Audit scope | **PH-048** | Basic logs + lineage |
| 13 | Solver licensing | **PH-004** / Stage B | **TBD — open-source solver preferred unless ENGIE provides commercial license** |
| 14 | Deployment automation | Stage D | — |
| 15 | Training content | **PH-012** / Phase 4 | — |
| 16 | Environment parity | Stage B | — |
| 17 | Security and access | Stage B | — |
| 18 | Validation tolerances | Stage C / **PH-006** | — |

---

## 29. Next Steps

This document establishes the **conceptual engineering baseline** for Domain 7 — Data & Application Engineering. It completes Stage A.2.

**Stage A.2 status:**

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.3) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.3) |
| 3 | A.2.3 | Operational Engineering | ✅ Baselined (v1.4) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | ✅ Baselined (v1.0) |
| 5 | A.2.5 | Degradation Engineering | ✅ Development Baseline (v0.4) |
| 6 | A.2.6 | Financial Engineering | ✅ Development Baseline (v0.3) |
| 7 | A.2.7 | Data & Application Engineering | ✅ **This document** — Development Baseline (v0.3) |

**Note on status.** "Stage A.2 is conceptually complete" means all seven domains have been defined at the conceptual engineering level. A.2.1, A.2.2, A.2.3, and A.2.4 are **Baselined**. A.2.5, A.2.6, and A.2.7 are **Development Baselines** pending ENGIE clarifications.

**Stage A is now conceptually complete.** All seven domains have been defined at the conceptual engineering level.

**Next:** Stage A consolidation and audit before Stage B (HLD). The audit verifies that all PH IDs, cross-references, and interfaces are consistent across the seven domains.

The next stages are:

```
STAGE A (COMPLETE — pending consolidation audit)
      │
      ▼
STAGE B — SYSTEM ARCHITECTURE (HLD)
      │
      ├── Data Architecture
      ├── Model Architecture
      ├── Optimization Architecture
      ├── Financial Architecture
      ├── Software Architecture
      └── Databricks Architecture
      │
      ▼
STAGE C — PRODUCT SPECIFICATION
      │
      ▼
STAGE D — IMPLEMENTATION
```

---

## 30. ENGIE Clarification Requests Relevant to Data & Application Engineering

The following clarification items are relevant to this domain. They are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1). This section lists only the items relevant to Data & Application Engineering, by their **Register ID**.

| Register ID | Clarification / Data Request | Why Required |
|---|---|---|
| **PH-004** | **Solver licensing.** Open-source solver (HiGHS) to avoid licensing dependencies, or does ENGIE hold commercial licenses (Gurobi, CPLEX)? | Determines the solver to use |
| **PH-012** | **Users and handover.** Who are the users and roles, how many, and who will maintain the tool after week 12? | Defines training audience and documentation level |
| **PH-046** | **Databricks environment.** Please confirm workspace ownership, access provisioning, Databricks Apps availability, Unity Catalog usage, and compute policies. | Determines the delivery environment |
| **PH-047** | **Reporting requirements.** Are there ENGIE templates or branding requirements for PDF and Excel exports? | Determines reporting design |
| **PH-048** | **Audit / lineage / traceability scope.** Are execution logs, data lineage, and audit outputs required deliverables, or optional engineering practices? | Determines audit scope |

**Note.** Items are assigned IDs in `PH1-REG-001`. The Register is the authoritative source; this section is a filtered view. PH IDs will be verified during the Stage A consolidation audit.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.7 — Conceptual Engineering (Data & Application Engineering)
**Status:** Conceptual Engineering — **Development Baseline (v0.3)**
**Duration:** 12 Weeks
**Language:** English

---