
---

# B.6 Databricks Architecture v0.4 — Baseline (Frozen)

---

## STAGE-B-HLD-001 — System Architecture (HLD)

## §9 — B.6 Databricks Architecture

**Document ID:** B.6-DBX-ARCH-001

**Version:** 0.4 — Baseline (Frozen)

**Section:** §9 — B.6 Databricks Architecture

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
- B.3-OPT-ARCH-001 — B.3 Optimization Architecture (v0.6 Baseline Frozen)
- B.4-FIN-ARCH-001 — B.4 Financial Architecture (v0.4 Baseline Frozen)
- B.5-SW-ARCH-001 — B.5 Software Architecture (v0.4 Baseline Frozen)

**Note on versions.** Parent document versions are not restated here; they are as declared in each document.

**Change log.** See §17 for detailed changes across versions.

---

## 1. Purpose and Boundary

### 1.1 Purpose of B.6

B.6 defines the **Databricks realization architecture** of the system. It establishes:

- The **environment classes** and **execution modes**
- The **compute realization** model
- How **data is laid out** at the platform level (Unity Catalog, Delta, Volumes)
- How **Delta table families** are organized per data family (B.1)
- How **execution** is placed on Jobs and Tasks
- How **parallel fan-out** is realized on the platform
- How **synchronization points (fan-in)** are realized
- How the **application boundary** is realized
- How **governance and identity** are realized
- How **secrets** are managed
- How **observability** is realized
- How **scheduling and orchestration** are configured
- How **logical runtime units (B.5)** are mapped to physical constructs
- What **logical platform types** are recognized
- What is **deferred to Stage C / Stage D**

### 1.2 What B.6 Does Not Define

B.6 does not define:

- Column types and physical schemas (Stage C)
- Partitioning keys and Z-ordering (Stage C)
- Cluster instance types, sizing, and autoscaling parameters (Stage C / Stage D)
- CI/CD pipeline definitions (Stage D)
- Job, notebook, App, and API code (Stage D)
- Workflow definitions (Stage D)
- Exact algorithms or solver configuration (Stage C)
- Class structures and function signatures (Stage C)
- Detailed cost model, SLOs, and platform NFR parameters (Stage C)

### 1.3 Boundary Rule

**Rule:** B.6 defines the **physical realization on Databricks**. It does not redefine the software units (B.5), the model objects (B.2), the optimization semantics (B.3), the financial rules (B.4), or the data architecture (B.1). It places them.

**Rule:** B.6 freezes the **platform architecture, not the implementation topology**. The exact Job / Task topology, partitioning strategy, and physical realization details are Stage C decisions.

### 1.4 Question Answered

B.6 answers: *How is the software architecture (B.5) realized physically on Databricks?*

---

## 2. Position Within Stage B

### 2.1 Position

B.6 sits **after B.5** (Software Architecture) and is the **last architectural view of Stage B**.

| View | Depends on | Detail Level |
|------|------------|--------------|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| B.2 Model Architecture | B.0, B.1 | Component details |
| B.3 Optimization Architecture | B.0, B.2 | Dispatch details |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| B.5 Software Architecture | B.0–B.4 | Software details |
| **B.6 Databricks Architecture** | **B.0–B.5** | **Platform details** |

### 2.2 Constraints

**Rule:** B.6 constrains Stage C and Stage D on platform aspects. No Stage C or Stage D decision can contradict B.6's platform architecture without an explicit B.6 revision.

**Rule:** B.6 does not redefine software units, interfaces, model objects, optimization semantics, financial rules, or data families.

### 2.3 Separation of Concerns

| Document | Question answered |
|----------|-------------------|
| B.0 | What system are we building? |
| B.1 | How is information organized? |
| B.2 | How is the model structured? |
| B.3 | How is optimization structured? |
| B.4 | How is financial valuation structured? |
| B.5 | How is the software organized? |
| **B.6** | **How is it realized on Databricks?** |
| Stage C | What exactly must be built? |
| Stage D | How is it implemented? |

---

## 3. Platform Architecture View

### 3.1 Overview

The platform architecture realizes the software architecture (B.5) on Databricks. It places:

- **Software units** on Databricks execution constructs
- **Data families** in Unity Catalog
- **Execution** on Jobs and Tasks
- **Parallel fan-out** on distributed execution
- **Synchronization points** on task boundaries
- **Application boundary** on Databricks App and API boundary
- **Governance** on Unity Catalog, identity, access control, and secrets
- **Observability** on logs, metrics, and alerts

### 3.2 Platform Architecture Diagram (conceptual)

```
                    B.6 DATABRICKS ARCHITECTURE
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   ENVIRONMENT             DATA               APPLICATION
        │                     │                     │
 Dev / UAT / Prod      Unity Catalog          Databricks App
        │                     │                API boundary
        │                Delta / Volumes       Exports
        │                     │
        └───────────────┬─────┘
                        │
                  EXECUTION
                        │
              Jobs coordinating Tasks
                        │
                 Execution Control
                        │
             Distributed execution
             (intra-task fan-out;
              initial realization expected
              to use Spark grouped execution)
                        │
                  B.5 Software Units

Cross-cutting:
   Governance / Identity
   Observability
   Lineage
   Secrets
```

### 3.3 Key Distinctions

| Concept | Definition |
|---------|------------|
| **Environment class** | A logical lifecycle and governance boundary (Development, Validation / UAT, Production) |
| **Workspace** | A Databricks workspace that provides a platform boundary for solution resources and users |
| **Execution mode** | How the system is invoked (automated, interactive, application serving) |
| **Compute realization** | The resource model (serverless compute, classic / provisioned compute, serverless application infrastructure) |
| **Catalog / schema** | Governed namespace containers |
| **Delta table** | Persisted dataset |
| **Volume** | Governed non-tabular storage |
| **Job** | A Databricks workload and orchestration resource composed of one or more tasks |
| **Task** | A specific unit of work within a Job |
| **App** | User-facing Databricks application |
| **API boundary** | Programmatic access to the application |
| **Secret scope (or approved equivalent)** | A container for secrets |
| **Unity Catalog** | The governance layer |

**Rule:** These are **platform concepts**. They are not software units (B.5), not data families (B.1), and not architectural components (B.0).

---

## 4. Workspace, Environment, and Compute Topology

### 4.1 Environment Classes

The architecture defines **three environment classes**:

| Environment class | Purpose |
|-------------------|---------|
| **Development** | Development, experimentation, unit testing |
| **Validation / UAT** | Validation against UAT scenarios, integration testing |
| **Production** | Production execution: jobs, Delta tables, Apps |

**Rule:** Each environment class may be realized by **one or more Databricks workspaces**. The exact workspace topology (number of workspaces, cross-workspace sharing) is a **Stage C** decision.

**Rule:** Environments are isolated. Production data is not written to Development or Validation environments. Cross-environment data movement, if required, is mediated through governed mechanisms declared in Stage C.

### 4.2 Execution Modes

The platform distinguishes **three execution modes**:

| Execution mode | Purpose |
|----------------|---------|
| **Automated execution** | Scheduled or triggered workflows and jobs |
| **Interactive execution** | Interactive notebooks for analysis |
| **Application serving** | User-facing Databricks Apps and API boundary |

**Rule:** Execution modes are **orthogonal** to compute realization and to environment classes.

### 4.3 Compute Realization

Compute is realized as:

| Compute realization | Description |
|---------------------|-------------|
| **Serverless compute** | Databricks-managed compute for supported notebook and workflow / job workloads |
| **Classic / provisioned compute** | Provisioned compute used where required by workload, platform constraints, or approved enterprise requirements |
| **Serverless application infrastructure** | Databricks-managed hosting for Databricks Apps |

**Rule:** Serverless compute is the **preferred** realization for automated and interactive execution.

**Rule:** Classic compute may be used where serverless does not meet an identified workload, platform, licensing, or enterprise requirement. The concrete requirement and placement are determined in **Stage C**.

**Rule:** Databricks Apps use **serverless application infrastructure**, which is distinct from serverless compute for notebooks and workflows.

**Rule:** Compute realization is chosen per execution mode and per environment class.

### 4.4 Compute Placement Rules

| Execution mode | Typical realization |
|----------------|---------------------|
| Automated execution | Serverless compute by default; classic where required by workload, platform, licensing, or enterprise requirements |
| Interactive execution | Serverless compute by default; classic where required by workload, platform, licensing, or enterprise requirements |
| Application serving | Databricks App serverless application infrastructure |

**Rule:** All production workflows run on managed compute. Interactive notebooks are for analysis and reporting and do not write production Delta tables.

**Rule:** Detailed cost model, SLOs, and platform NFR parameters are **deferred to Stage C**.

**Note:** Cluster sizing, autoscaling, and instance types are **Stage C / Stage D** decisions.

---

## 5. Data Layout

### 5.1 Governed Namespace

Data is organized through **Unity Catalog**, which provides:

- Governed namespace (`catalog.schema.object`)
- Fine-grained access control
- Lineage
- Audit
- Governance across tables, volumes, and external assets

**Rule:** The system shall use **Unity Catalog as the governed data namespace**. The catalog structure shall provide logical isolation by **environment, governance boundary, or data domain** as required. The initial implementation may use a single catalog where appropriate.

**Rule:** The exact number and naming of catalogs are **Stage C** decisions.

### 5.2 Initial Schema Layout

The initial schema layout follows the **data families** of B.1:

| Logical schema group | Purpose |
|----------------------|---------|
| `raw` | Source data (B.1 Source stage) |
| `ingested` | Ingested data (B.1 Ingested stage) |
| `validated` | Validated data (B.1 Validated stage) |
| `model_ready` | Model-ready data (B.1 Model-ready stage) |
| `execution_state` | Execution state persistence |
| `state_history` | State history persistence |
| `results` | Results (dispatch, bill, savings, events, KPIs) |
| `governance` | Governance data (lineage, validation evidence, version metadata, scenario / run identity) |

**Rule:** The names above are **logical schema groups** that describe the intended data families. The exact physical schema names, catalog placement, and materialization are **Stage C** decisions.

### 5.3 Volumes

Volumes are used for **governed non-tabular artifacts**, including raw files and generated reports.

| Volume (candidate) | Purpose |
|--------------------|---------|
| `reports` volume | PDF and Excel exports |
| `raw_files` volume | Raw input files |

**Rule:** Volumes are used only for **non-tabular** artifacts. Structured data lives in Delta tables.

**Note:** The volumes above are **logical candidates**. The final volume set is a **Stage C** decision.

### 5.4 External Data

External data sources may be accessed through **governed integration mechanisms**, including governed ingestion, external locations, federation, or other approved integration mechanisms. The specific mechanism is deferred to **Stage C**.

**Rule:** External data shall be accessed through **governed integration mechanisms**. Data **materialized or persisted** within the Databricks solution shall be governed through **Unity Catalog**.

**Note:** Access to an external source does not require immediate materialization of the full dataset into a local Delta table. The integration strategy (materialization vs federated access vs external location) is a **Stage C** decision.

---

## 6. Delta Table Design (Logical)

### 6.1 Delta Table Families

The Delta table design follows the **data families** of B.1:

| Data family (B.1) | Delta table family |
|--------------------|--------------------|
| Data Lifecycle — Source | `raw.*` |
| Data Lifecycle — Ingested | `ingested.*` |
| Data Lifecycle — Validated | `validated.*` |
| Data Lifecycle — Model-ready | `model_ready.*` |
| Execution State | `execution_state.*` |
| State History | `state_history.*` |
| Results | `results.*` |
| Governance Data | `governance.*` |

### 6.2 Delta Table Design Principles

| Principle | Description |
|-----------|-------------|
| **Family-based realization** | Each data family member shall be realized through **one or more governed Delta objects** as required by the Stage C physical specification |
| **Controlled schema evolution** | Schema evolution is controlled and governed. Compatibility rules and permitted evolution mechanisms are defined in **Stage C** |
| **Reproducibility via Delta versioning** | Delta versioning and time travel support **reproducibility and historical reconstruction** |
| **Governed** | All Delta tables are governed by Unity Catalog |
| **Lineage** | Unity Catalog captures table-level and workload-level lineage automatically |
| **Partitioning** | Partitioning is a **Stage C** decision |
| **Z-ordering / liquid clustering** | Z-ordering and liquid clustering are **Stage C / Stage D** decisions |
| **Change Data Feed** | CDC is used where the producing unit requires it |

**Rule:** B.6 declares the **families** and the **principles**. B.6 does **not** declare column types, partitioning keys, or Z-order keys.

**Note on lineage vs reproducibility.** Unity Catalog provides the primary **lineage** capability. Delta versioning and time travel provide **reproducibility and historical reconstruction**. These are distinct capabilities with distinct responsibilities.

### 6.3 Scenario and Run Identity

Scenario and run identity shall be **persisted wherever required** to maintain:

- Execution isolation (B.1 §13)
- Reproducibility
- Lineage
- Result traceability

**Rule:** The exact persistence mechanism and column representation are **Stage C** decisions.

**Note:** Not every table requires both identifiers. Source datasets and reference datasets may not belong to a run.

---

## 7. Execution Placement

### 7.1 Placement Principle

Each **software unit** (B.5) is placed on a **Databricks construct**:

| Software unit (B.5) | Databricks placement |
|----------------------|----------------------|
| `bess_model` | Python library, invoked by Tasks |
| `load_market.signal_provider` | Python library, invoked by Tasks |
| `load_market.settlement_adapter` | Python library, invoked by Tasks |
| `tariff` | Python library, invoked by Tasks |
| `operational` | Python library, invoked by Tasks |
| `dispatch` | Python library + solver, invoked by Tasks |
| `degradation` | Python library, invoked by Tasks |
| `financial` | Python library, invoked by Tasks |
| `scenario_mgmt` | Python library + Job orchestration |
| `configuration` | Python library |
| `validation` | Python library + Task |
| `execution_control` | Job orchestration (fan-out and synchronization owner) |
| `lineage` | Python library + Delta writes |
| `observability` | Python library + log / metric sinks |
| `data_lifecycle` | Distributed workloads + Delta writes |
| `execution_state` | Delta tables |
| `state_history` | Delta tables |
| `governance_data` | Delta tables |
| `application` | Databricks App + API boundary + exports |
| `kernel` | Python library |

### 7.2 Execution Model

The execution model realizes B.5's execution interfaces:

- **Initialize** — task setup
- **Execute** — task run
- **State transition** — persistence writes
- **Terminate** — task cleanup

**Rule:** Execution Control is realized through **Databricks workflow / job orchestration**, with **Jobs** coordinating **Tasks**. The exact Job / Task topology is deferred to **Stage C**.

### 7.3 Execution Order

**Rule:** The execution order is not prescribed by B.6. It is derived from the **dependency contracts** of B.2–B.4 and orchestrated by Execution Control (B.5).

### 7.4 Annual Sequencing Realization

**Rule:** The annual sequencing (B.3 §8.4, §9.5) is realized as a **loop within the scenario-batch job**, not as separate workflow runs per year. B.6 **realizes** this orchestration; it does not redefine the semantics owned by B.3.

**Rationale.** Realizing the annual sequence as separate workflow runs per year would multiply workflow executions by project years (e.g., 15) and by scenario count, quickly reaching platform job concurrency limits. A loop within the scenario-batch job keeps the annual sequence inside a single orchestration unit.

---

## 8. Parallelization and Synchronization Realization

### 8.1 Parallelization Principle

B.5 declares that `execution_control` is the **sole owner** of execution-level parallel fan-out. B.6 realizes this on Databricks through **intra-task distributed fan-out**:

| Parallel axis (B.2) | Platform realization |
|---------------------|-----------------------|
| Scenarios | Intra-task fan-out within the scenario-batch task (grouped execution across scenarios in the batch) |
| Representative periods | Intra-task fan-out within a Task (grouped execution across monthly representative periods within a year) |
| Sensitivities | Intra-task fan-out within a Task (grouped execution across cases) |
| Within scenario | Sequential loop within the task (annual sequence) |
| Within optimization | Solver execution within the optimization task |

**Rule — Parallelization mechanism.** Intra-year fan-out (scenarios × representative periods, and sensitivities) is realized **within a task** through **intra-task distributed fan-out**. The initial platform realization is expected to use **Spark-based grouped execution where appropriate**; the exact execution and partitioning strategy are defined in **Stage C**.

**Rule — Annual sequence.** The annual sequence is realized as a **loop within the scenario-batch job**, not as separate workflow runs per year.

**Rule — Scenario batching.** The coherent model for scenario fan-out is **scenario batches that advance year by year in unison**:

> A scenario-batch job runs one task that loops over project years. In each year, it fans out over (scenario × representative period) through intra-task distributed fan-out; at the end-of-year barrier it performs the annual update for all scenarios in the batch; after the last year it runs Tariff and Settlement, then Financial. Workflow-level fan-out, if needed, splits scenarios into batches.

**Rule — Partitioning strategy.** The exact partitioning strategy (e.g., number of partitions, partition keys, repartitioning) is a **Stage C / Stage D** decision. B.6 declares the mechanism class (intra-task distributed fan-out), not the partitioning details.

### 8.2 Parallelization Constraints

**Rule:** Parallelization is bounded by:

- Compute capacity
- Persistence write contention
- Solver licensing
- Scenario independence (per B.1 §13)

**Rule:** Implementation-level parallelism within a software unit (vectorization, multiprocessing, solver parallelism) is a **Stage C / Stage D** decision.

### 8.3 State Handling under Parallelization

Per B.5 §5.4 (State Externalization):

**Rule:** All software units are **stateless at runtime**. Model state is passed explicitly through execution interfaces and persisted by the **persistence layer**. Parallel tasks do not share in-memory state.

**Rule:** When a unit runs on different workers for different scenarios or periods, state is provided through the **execution interface**, not by direct worker-to-worker memory sharing. The persistence mechanism is owned by the data layer, not by the individual worker.

### 8.4 Synchronization Points

Parallelization requires explicit **fan-in barriers**. B.6 declares two architectural barriers:

**Barrier 1 — End of year.**
All **12 monthly representative periods** of a year must complete before the **annual state update, including degradation state update**, proceeds. This barrier is realized inside the scenario-batch task loop: the annual update step waits for the fan-out of the year's periods.

**Barrier 2 — End of scenario.**
The Tariff Engine and Settlement must run **after** the dispatch of **all years of the scenario**, because the Tariff Engine may require the **full 12-month net-load history** across years (ratchets). Dispatch does not depend on the bill (ratchets are evaluated by the Tariff Engine, not by Dispatch — B.3 §5.1). The Financial Engine consumes the settlement basis (B.4 §4.4), so it must run **after** both Tariff and Settlement.

The clean realization is therefore:

```
Scenario-batch job
    │
    ├── Loop over years:
    │     ├── Fan-out over (scenario × representative period) — dispatch
    │     └── End-of-year barrier:
    │           annual state update for all scenarios in the batch,
    │           including degradation state update
    │
    └── After all years (end-of-scenario barrier):
          ├── Tariff Engine (full net-load history, ratchets)   ┐ independent
          ├── Settlement (Load & Market adapters)                ┘ (may run in parallel)
          └── Financial Engine (after both)
```

**Rule:** Without these barriers, a naive implementation could run the Tariff Engine per month and compute ratchets incorrectly. The barriers ensure correct semantics.

**Rule — Write-at-barrier.** Grouped execution results should be written **once per barrier** (the resulting DataFrame of the year), not from each worker. This avoids the persistence write contention mentioned in §8.2 and keeps the write pattern aligned with the barrier structure.

---

## 9. Application Boundary Realization

### 9.1 Application Constructs

The application boundary (B.5 §9) is realized through:

| Application type (B.5) | Databricks realization |
|------------------------|------------------------|
| **CLI** | Job task invocation |
| **API** | Application / API boundary, realized through Databricks App services and/or platform API mechanisms as required by the Stage C specification |
| **Notebook** | Interactive notebook |
| **Reporting** | Notebook + export |
| **Web UI (Databricks App)** | Databricks App |
| **Exports** | Report files written to a Volume |
| **Scheduled execution** | Job trigger |

### 9.2 Databricks App

The Databricks App provides:

- Scenario configuration UI
- Run submission
- Dashboards
- Scenario comparison

**Rule:** The Databricks App is the **primary user-facing application**. It is realized on serverless application infrastructure.

### 9.3 Exports

PDF and Excel exports are:

- Produced by the application unit
- Written to the `reports` Volume
- Available for download through the App or API boundary

### 9.4 API Boundary

The API boundary provides programmatic access to:

- Scenario submission
- Run status
- Result retrieval

**Rule:** The API boundary does not expose internal software units directly. It exposes the **application boundary** only.

**Note:** The specific mechanism (App services, platform API, or a combination) is a **Stage C** decision.

---

## 10. Governance, Identity, Secrets

### 10.1 Unity Catalog

Unity Catalog provides:

- **Catalog / schema / table / volume governance**
- **Fine-grained access control**
- **Lineage** (table-level and workload-level)
- **Audit logs**
- **Governance over external assets** where integration is configured

**Rule:** All Delta tables and Volumes live in Unity Catalog. No structured data lives outside Unity Catalog.

### 10.2 Identity and Access Control

Identity and access control are structured around **identity classes**, not around software units.

| Principal class | Access principle |
|-----------------|-------------------|
| Business users | Application-mediated access |
| Application identity | Least-privilege access to required data, including permission to trigger execution jobs |
| Execution workloads | Least-privilege access to required data and state |
| Platform administrators | Controlled operational access |
| Data / governance administrators | Governance and metadata administration |

**Rule:** Business users **shall not** directly modify production data. All user interaction with production data goes through the application boundary.

**Rule:** The authorization model follows the chain: identity → role / group → environment → data domain / object → permissions.

**Note:** The concrete identity provider, group structure, and permission matrix are **Stage C** decisions.

### 10.3 Secrets Management

Secrets shall be managed through an **approved secret-management mechanism integrated with Databricks**. Databricks secret scopes may be used where appropriate.

| Secret category | Purpose |
|------------------|---------|
| Market data credentials | Access external market data |
| Program credentials | Access DR program APIs |
| Solver licensing | Solver license keys (if applicable) |
| Report credentials | Report signing keys (if applicable) |

**Rule:** Secrets are **never** stored in code or notebooks. They are accessed at runtime through the approved mechanism.

### 10.4 Governance Data

Governance data (lineage, validation evidence, version metadata, scenario / run identity) is persisted in the `governance` schema.

**Rule:** Governance data is written by the relevant cross-cutting units (`lineage`, `validation`, `scenario_mgmt`) and stored in `governance_data`.

---

## 11. Observability and Lineage Realization

### 11.1 Observability

Observability is realized through:

| Observability aspect | Platform realization |
|----------------------|-----------------------|
| Logs | Job logs, task logs, cluster logs, driver logs |
| Metrics | Compute metrics, job metrics, custom metrics |
| Alerts | Platform alerts and notifications |
| Optional tracing / experimentation | Where required |

**Rule:** Observability is placed in the Observability Plane (§3.2). It does not alter execution semantics.

### 11.2 Lineage

Lineage is realized through:

| Lineage aspect | Platform realization |
|-----------------|-----------------------|
| Table-level lineage | Unity Catalog lineage |
| Workload-level lineage | Platform workload lineage |
| Row-level lineage | Custom metadata (via `lineage` unit) |
| Version metadata | Delta time travel + `governance_data` |

**Rule:** **Unity Catalog provides the primary platform lineage capability.** Custom lineage is added only where the platform does not cover the case.

**Rule on separation.** Lineage (who produced what, from what) is realized through Unity Catalog and `lineage`. Reproducibility (the ability to reconstruct a historical execution) is realized through Delta versioning, time travel, and `governance_data`. These are distinct capabilities.

### 11.3 Optional Experimentation and Tracing

MLflow may be used where experimentation, model tracking, or supported tracing capabilities are required.

**Rule:** MLflow is **not** a mandatory architectural dependency. It is used where it adds value.

---

## 12. Scheduling and Orchestration

### 12.1 Orchestration Model

**Rule:** Databricks workflow / job orchestration provides the platform realization of **Execution Control**. **Jobs** coordinate **Tasks**, while the exact Job / Task topology is deferred to **Stage C**.

| Orchestration construct | Purpose |
|-------------------------|---------|
| Scenario-batch job | Runs one task that loops over project years, fans out over (scenario × representative period), and applies the synchronization barriers; a job handles one batch of scenarios |
| Sensitivity job | Runs sensitivity analyses |
| Reporting job | Generates reports |

**Rule:** The annual sequence is realized **inside** the scenario-batch job, not as separate jobs per year (see §7.4 and §8.4).

### 12.2 Triggers

Triggers include:

| Trigger | Description |
|---------|-------------|
| Scheduled trigger | Time-based scheduling |
| Manual trigger | User-initiated from the App or API boundary |
| Event-based trigger | Triggered by upstream completion |

### 12.3 Orchestration Ownership

**Rule:** Orchestration is owned by **Execution Control** (B.5). Databricks Jobs realize the orchestration; they do not redefine it.

**Rule:** The annual sequencing (B.3) is realized through a loop within the scenario-batch job. B.6 realizes this orchestration; it does not redefine the semantics owned by B.3.

---

## 13. Runtime Boundaries Realization

### 13.1 Mapping of Logical Runtime Units (B.5 §14)

| Logical runtime unit (B.5) | Platform realization |
|------------------------------|-----------------------|
| Application unit | Databricks App + API boundary + exports |
| Execution unit | Job + managed compute + engineering units |
| Data unit | Delta tables + data lifecycle workloads |
| Governance unit | Unity Catalog + governance schema + lineage |

**Rule:** The mapping above is the **initial realization**. It is not a 1:1 physical mapping. A logical runtime unit may span multiple physical constructs.

### 13.2 Boundary Realization

**Rule:** Logical runtime / execution boundaries (B.5 §14) are realized within one or more **application, job, task, or module boundaries**. The exact physical realization is defined in **Stage C**.

**Rule:** Whether a logical boundary is realized as a function, task, job, or network boundary is a **Stage C / Stage D** decision. B.6 declares only that logical boundaries are realized within physical constructs; it does not prescribe which construct realizes which boundary.

---

## 14. Logical Platform Types

### 14.1 Recognized Types

B.6 recognizes the following **logical platform types**:

| Logical Type | Description | Example |
|--------------|-------------|---------|
| Job | A Databricks workload and orchestration resource composed of one or more tasks | Scenario-batch job |
| Task | A specific unit of work within a Job | Year-looping task |
| Delta table | A governed persisted dataset | Ingested meter data |
| Volume | Governed non-tabular storage | Reports volume |
| App | A user-facing Databricks application | Scenario configuration App |
| API boundary | Programmatic access to the application | Result retrieval API |
| Secret scope (or approved equivalent) | A container for secrets | Market data credentials |
| Catalog / schema | Governed namespace containers | Main catalog, `raw` schema |

**Rule:** Logical platform types are **platform-level**. They do not replace software units (B.5), data families (B.1), or model objects (B.2).

### 14.2 Deferred to Stage C

| Deferred to Stage C |
|---------------------|
| Column types and physical schemas |
| Partitioning and Z-ordering |
| Cluster instance types and sizing |
| Autoscaling parameters |
| Job timeouts and retries |
| Catalog number and naming |
| Scenario / run identity representation |
| External data integration mechanism |
| API boundary realization mechanism |
| Secret-management mechanism (concrete) |
| Identity provider and permission matrix |
| Detailed cost model, SLOs, and platform NFR parameters |
| Exact Job / Task topology |
| Physical realization of logical service boundaries |
| Spark partitioning strategy |

### 14.3 Deferred to Stage D

| Deferred to Stage D |
|---------------------|
| Job code and configuration |
| Task code |
| Notebook code |
| App code |
| API boundary code |
| CI/CD pipeline definitions |

---

## 15. Stage C / Stage D Handoff

### 15.1 Handoff Sequence

```
B.0 Integrated System Architecture
        │
        ├── B.1 Data Architecture
        ├── B.2 Model Architecture
        ├── B.3 Optimization Architecture
        ├── B.4 Financial Architecture
        ├── B.5 Software Architecture
        │
        └── B.6 Databricks Architecture
                 │
                 ▼
              Stage C
                 │
                 ▼
              Stage D
```

### 15.2 What Stage C Receives from B.6

| Stage C receives | Description |
|-------------------|-------------|
| Environment classes | Development / Validation-UAT / Production |
| Execution modes | Automated, interactive, application serving |
| Compute realization | Serverless compute, classic / provisioned compute, serverless application infrastructure |
| Governed namespace | Unity Catalog as governed namespace |
| Initial schema layout | Logical schema groups |
| Delta table families | Delta table family design principles |
| External data boundary | Governed integration mechanisms |
| Execution placement | Software unit placement on Databricks constructs |
| Parallelization realization | Intra-task distributed fan-out and synchronization barriers |
| Application boundary realization | App, API boundary, exports |
| Governance | Unity Catalog, identity, access control, lineage, audit |
| Secrets management | Approved secret-management mechanism |
| Observability | Logs, metrics, alerts, optional tracing |
| Scheduling and orchestration | Job-based orchestration for scenario execution, including the annual sequence, intra-task fan-out, and synchronization barriers |
| Runtime boundaries realization | Realization within physical constructs |
| Logical platform types | Job, task, Delta table, volume, app, API boundary, secret scope, catalog, schema |

### 15.3 What Stage D Receives from B.6

Stage D implements:

- Job code and configuration
- Task code
- Notebook code
- App code
- API boundary code
- CI/CD pipelines

### 15.4 What B.6 Does Not Hand Off

B.6 does not hand off:

- Column types and schemas (Stage C)
- Partitioning and Z-ordering (Stage C)
- Cluster instance types and sizing (Stage C / Stage D)
- CI/CD pipeline definitions (Stage D)
- Code (Stage D)

---

## 16. What Is Deliberately NOT Defined Here

| Not defined in B.6 | Belongs to |
|---------------------|------------|
| Column types and schemas | Stage C |
| Partitioning and Z-ordering | Stage C |
| Cluster instance types and sizing | Stage C / Stage D |
| Autoscaling parameters | Stage C / Stage D |
| Job timeouts and retries | Stage C / Stage D |
| Catalog number and naming | Stage C |
| Scenario / run identity representation | Stage C |
| External data integration mechanism | Stage C |
| API boundary realization mechanism | Stage C |
| Secret-management mechanism (concrete) | Stage C |
| Identity provider and permission matrix | Stage C |
| Detailed cost model, SLOs, platform NFR parameters | Stage C |
| Exact Job / Task topology | Stage C |
| Physical realization of logical service boundaries | Stage C |
| Spark partitioning strategy | Stage C / Stage D |
| CI/CD pipeline definitions | Stage D |
| Job code and configuration | Stage D |
| Task code | Stage D |
| Notebook code | Stage D |
| App code | Stage D |
| API boundary code | Stage D |
| Class structures | Stage C |
| Method signatures | Stage C |
| Function signatures | Stage C |
| Exact algorithms | Stage C |
| Solver configuration | Stage C |

---

## 17. Change Log

### 17.1 Changes from v0.1 to v0.2

| # | Change | Reason |
|---|--------|--------|
| 1 | §4.2 and §4.3: split "compute classes" into **Execution modes** and **Compute realization** | Avoid mixing execution mode with infrastructure model |
| 2 | §4.4: added compute placement rules | Make the orthogonal model explicit |
| 3 | §5.1: reframed catalog strategy | Avoid committing to one catalog in Stage B |
| 4 | §5.2: renamed to "Initial Schema Layout" | Distinguish logical family from physical schema |
| 5 | §5.3: reframed Volumes as "governed non-tabular artifacts" | Align with Unity Catalog Volumes semantics |
| 6 | §5.4: added "External Data" section | Recognize external data boundary |
| 7 | §6.3: reframed scenario / run identity | Avoid over-tagging |
| 8 | §8.1: reframed parallelization realization | Avoid implementing partitioning in Stage B |
| 9 | §8.3: reframed state handling | Align with B.5 state externalization |
| 10 | §9.1: reframed API realization | Avoid committing to a serving endpoint |
| 11 | §9.4: added "API Boundary" section | Consistency with §9.1 |
| 12 | §10.3: reframed secrets management | Allow enterprise-approved mechanisms |
| 13 | §11.3: reframed MLflow as optional | Avoid forcing MLflow as dependency |
| 14 | §14.1: added "API boundary" and "Secret scope (or approved equivalent)" | Consistency with §9 and §10 |
| 15 | §14.2: expanded "Deferred to Stage C" list | Traceability of deferrals |
| 16 | §17: new §17.1 | Traceability |
| 17 | Header: version updated to v0.2 | Reflects the review pass |

### 17.2 Changes from v0.2 to v0.3

| # | Change | Reason |
|---|--------|--------|
| 1 | §4.1: replaced "primary workspace + optional development workspace" with **environment classes** | Avoid committing to a specific number of workspaces |
| 2 | §5.4: refined external data rule | Avoid requiring immediate materialization |
| 3 | §6.2: "one or more governed Delta objects per family member"; "schema evolution controlled and governed" | Avoid over-rigid physical realization |
| 4 | §6.2 and §11.2: separated **lineage** (Unity Catalog) from **reproducibility** (Delta versioning) | Give each capability a clear responsibility |
| 5 | §10.2: replaced "Principal = software unit" with **identity classes** | Align with enterprise identity model |
| 6 | §13.2: reframed service boundary realization | Avoid downgrading B.5's logical service boundaries |
| 7 | §14.1: clarified **Job** definition | Align with Databricks semantics |
| 8 | §1.2 and §14.2: replaced "out of scope" with "deferred to Stage C" | Recognize the relationship without specifying yet |
| 9 | §14.2: expanded deferrals | Traceability |
| 10 | §15.2: added environment classes | Consistency with §4 |
| 11 | §17.2: new section | Traceability |
| 12 | Header: version updated to v0.3 | Reflects the review pass |

### 17.3 Changes from v0.3 to v0.4

| # | Change | Reason |
|---|--------|--------|
| 1 | §3.3 and §14.1: refined definitions of **Job** ("workload and orchestration resource composed of one or more tasks"), **Task** ("specific unit of work within a Job"), **Workspace** ("platform boundary for solution resources and users"), **Environment class** ("logical lifecycle and governance boundary") | Align with current Databricks semantics |
| 2 | §4.3: separated **serverless compute**, **classic / provisioned compute**, and **serverless application infrastructure** | Avoid making "serverless" a single product covering everything |
| 3 | §4.3: reframed classic compute as "where required by workload, platform constraints, or approved enterprise requirements"; concrete requirement to Stage C | Avoid freezing that only commercial solvers justify classic compute |
| 4 | §4.4: refined compute placement rules accordingly | Consistency with §4.3 |
| 5 | §7.1 and §7.2: replaced "invoked by jobs" with "invoked by Tasks"; "Jobs coordinating Tasks" | Align with corrected Job/Task model |
| 6 | §7.4 and §12.1: **annual sequence realized as a loop within the scenario-batch job**, not as separate workflow runs per year | Prevent multiplying workflow executions by project years and scenarios |
| 7 | §8.1: declared **parallelization mechanism** — intra-task distributed fan-out; initial realization expected to use Spark grouped execution; partitioning to Stage C | Preserve architectural decision without freezing Spark implementation details |
| 8 | §8.1: added **scenario-batching rule** — a scenario-batch job loops over years, fans out over (scenario × representative period), applies end-of-year barrier, runs Tariff and Settlement after the last year, then Financial; workflow-level fan-out reserved for scenario batches | Resolve contradiction across §8.1, §8.1, and §15.2 |
| 9 | §8.4: new **Synchronization points** subsection — end-of-year barrier and end-of-scenario barrier; **Tariff and Settlement may run in parallel, Financial after both** | Correct the order per B.4 §4.4 (settlement basis consumed by Financial) |
| 10 | §8.4: **write-at-barrier rule** — grouped execution results written once per barrier, not from each worker | Avoid persistence write contention |
| 11 | §8.4: refined "all 12 monthly representative periods of a year"; "annual state update, including degradation state update" | Precise terminology |
| 12 | §10.2: "Application identity" now includes **permission to trigger execution jobs** | Reflect the App's "Run submission" capability |
| 13 | §12.1: reformulated orchestration construct as **scenario-batch job** | Consistency with scenario batching |
| 14 | §14.2: added "Exact Job / Task topology" and "Spark partitioning strategy" to deferrals | Traceability of new deferrals |
| 15 | §15.2: updated parallelization to "intra-task distributed fan-out and synchronization barriers"; orchestration to "job-based orchestration for scenario execution, including the annual sequence, intra-task fan-out, and synchronization barriers" | Consistency with new model; no frozen "single job per scenario execution" |
| 16 | §16: added "Exact Job / Task topology", "Physical realization of logical service boundaries", "Spark partitioning strategy" | Consistency with §14.2 |
| 17 | §1.3: added explicit rule "B.6 freezes the platform architecture, not the implementation topology" | Preserve HLD boundary |
| 18 | §17.3: new section with the change list | Traceability |
| 19 | Header: version updated to v0.4 — Baseline (Frozen) | Freeze |

### 17.4 Version History

| Version | Date | Changes | Status |
|---------|------|---------|--------|
| 0.1 | Stage B start | Initial B.6 draft | Superseded |
| 0.2 | Stage B review | 17 corrections | Superseded |
| 0.3 | Stage B review | 12 corrections | Superseded |
| 0.4 | Stage B freeze audit | 19 corrections (Job/Task definitions, compute realization split, parallelization mechanism, scenario batching, synchronization barriers, application identity, annual sequence loop, deferrals expanded, HLD boundary rule) | **Baseline (Frozen)** |

---

**End of §9 — B.6 Databricks Architecture (v0.4 — Baseline Frozen)**

**Status:** Baseline (Frozen)

**Next:** Stage B → Stage C Handoff

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

---

## 📋 Resumen de los cambios finales aplicados

### 4 ajustes editoriales (de la primera revisión)

| # | Ajuste | Sección |
|---|--------|---------|
| 1 | Classic compute como "workload, platform constraints, or approved enterprise requirements"; requerimiento concreto a Stage C | §4.3, §4.4 |
| 2 | "Spark grouped execution" → "intra-task distributed fan-out"; Spark como realización esperada, no congelada | §8.1 |
| 3 | "All 12 monthly representative periods"; "annual state update, including degradation state update" | §8.4 |
| 4 | "Single job per scenario execution" → "Job-based orchestration for scenario execution, including the annual sequence, intra-task fan-out, and synchronization barriers" | §15.2 |

### 2 ajustes de coherencia (de la segunda revisión)

| # | Ajuste | Sección |
|---|--------|---------|
| 5 | **Barrera 2 corregida**: Tariff y Settlement independientes (pueden correr en paralelo), Financial después de ambos | §8.4 |
| 6 | **Contradicción de escenarios resuelta**: modelo de scenario batches que avanzan año a año al unísono | §8.1, §8.4, §12.1, §15.2 |

### Nota opcional aplicada

| # | Ajuste | Sección |
|---|--------|---------|
| 7 | **Write-at-barrier**: resultados de grouped execution escritos una vez por barrera, no desde cada worker | §8.4 |

### Regla adicional

| # | Regla | Sección |
|---|-------|---------|
| 8 | "B.6 freezes the platform architecture, not the implementation topology" | §1.3 |

---

## 🚦 Estado de Stage B

| Documento | Versión | Estado |
|-----------|---------|--------|
| B.0 Integrated System Architecture | v0.3.3 | ✅ Baseline Frozen |
| B.1 Data Architecture | v0.3 | ✅ Baseline Frozen |
| B.2 Model Architecture | v0.5.1 | ✅ Baseline Frozen |
| B.3 Optimization Architecture | v0.6 | ✅ Baseline Frozen |
| B.4 Financial Architecture | v0.4 | ✅ Baseline Frozen |
| B.5 Software Architecture | v0.4 | ✅ Baseline Frozen |
| **B.6 Databricks Architecture** | **v0.4** | **✅ Baseline Frozen** |
| STAGE-B-HLD-INDEX-001 | v0.1 Draft | ⚠️ Pendiente actualizar |
| Stage B → Stage C Handoff | — | ⏭ Next |

---

