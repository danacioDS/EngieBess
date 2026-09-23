# STAGE-B-HLD-001 — System Architecture (HLD)

## §4 — B.1 Data Architecture

**Document ID:** STAGE-B-HLD-001

**Version:** 0.3 — Baseline Candidate

**Section:** §4 — B.1 Data Architecture

**Status:** Stage B — Baseline Candidate

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition
- A.2.1-BESS-ENG-001 — BESS Engineering
- A.2.2-LOAD-MKT-ENG-001 — Load & Market Engineering
- A.2.3-OPS-ENG-001 — Operational Engineering
- A.2.4-DISPATCH-ENG-001 — Dispatch & Optimization Engineering
- A.2.5-DEG-ENG-001 — Degradation Engineering
- A.2.6-FIN-ENG-001 — Financial Engineering
- A.2.7-DATA-APP-ENG-001 — Data & Application Engineering
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register
- `STAGE-B-HLD-INDEX-001` — Stage B HLD Master Index and Scope Definition
- `STAGE-B-HLD-001 §3` — B.0 Integrated System Architecture (v0.3.3 Baseline Frozen)

**Changes from v0.1:** 6 major corrections (see §13 Change Log).

---

### 1. Purpose of B.1

B.1 defines the **data architecture** of the system. It establishes:

- How data is organized into **three architectural categories**
- What **data entities** exist within each category
- Who **owns** each data category (architectural vs semantic ownership)
- How data **flows** between categories
- What **transformation states** exist
- What **data interfaces** exist
- What **data quality** requirements apply
- How **lineage and versioning** are conceptually handled
- How **scenario isolation** is conceptually achieved
- What **logical data types** are recognized

B.1 **does not** define:

- Physical schemas
- Delta tables
- SQL DDL
- PySpark code
- Databricks configuration
- Storage technology
- Physical partitioning
- Exact validation rules
- Pipeline implementation
- Physical data types

Those belong to Stage C (specification) and Stage D (implementation).

**Rule:** *B.1 defines the logical data architecture; Stage C defines the physical data specification.*

B.1 answers:

> **How is data logically organized and managed across the system?**

---

### 2. Position Within Stage B

B.1 sits **after B.0** (Integrated System Architecture) and **before B.2** (Model Architecture). It details the data dimension of the architecture defined in B.0.

| View | Depends on | Detail Level |
|---|---|---|
| B.0 | — | Architectural contract |
| **B.1 Data Architecture** | **B.0** | **Data details** |
| B.2 Model Architecture | B.0, B.1 | Component details |
| B.3 Optimization Architecture | B.0, B.2 | Dispatch details |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| B.5 Software Architecture | B.0–B.4 | Software details |
| B.6 Databricks Architecture | B.0–B.5 | Platform details |

**Rule:** B.1 constrains B.2–B.6 on data aspects. No view can contradict B.1's data model.

**Rule:** B.1 does not redefine components, responsibilities, or interfaces already declared in B.0.

---

### 3. Data Architecture View

#### 3.1 Three Architectural Categories

Data in the system is organized into **three architectural categories**:

```
                    DATA ARCHITECTURE
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
 DATA LIFECYCLE      EXECUTION DATA     GOVERNANCE DATA
        │                  │                  │
        ▼                  ▼                  ▼
 Source              Execution State     Lineage
   ↓                 Runtime State       Validation Evidence
 Ingested            State History       Version Metadata
   ↓                 Run Metadata        Scenario/Run Identity
 Validated           Results
   ↓
 Model-ready
```

These three categories are **parallel and orthogonal**. They are not a single taxonomy.

| Category | What it represents | Nature |
|---|---|---|
| **Data Lifecycle** | How data is progressively processed | Sequential transformation |
| **Execution Data** | What the system produces and maintains during execution | Runtime state + outputs |
| **Governance Data** | How the system tracks and audits | Cross-cutting metadata |

#### 3.2 Data Lifecycle

The **Data Lifecycle** represents the progressive processing of input data:

```
Source → Ingested → Validated → Model-ready
```

| Stage | Description |
|---|---|
| **Source** | External data as received (raw, unprocessed) |
| **Ingested** | Data loaded into the system (structured, timestamped) |
| **Validated** | Data that has passed quality checks |
| **Model-ready** | Data structured and aligned for the engineering components |

**Key distinction:** Each stage transforms the **same data entity** (e.g., meter data). A validated meter reading is the same entity as the source meter reading, just processed.

#### 3.3 Execution Data

The **Execution Data** represents what the system produces and maintains during execution:

| Sub-category | Description |
|---|---|
| **Execution State** | State that persists across iterations |
| **Runtime State** | State within a single execution |
| **State History** | Historical record of state evolution |
| **Run Metadata** | Information about each execution |
| **Results** | Operational and financial outputs |

**Key distinction:** Execution Data is **not** the next stage of the Data Lifecycle. It represents a different kind of data — the state and outputs of the system itself.

#### 3.4 Governance Data

The **Governance Data** represents cross-cutting metadata:

| Sub-category | Description |
|---|---|
| **Lineage** | Data and decision traceability |
| **Validation Evidence** | Validation results and evidence |
| **Version Metadata** | Versions of data, parameters, code |
| **Scenario/Run Identity** | Identity of scenarios and runs |

**Key distinction:** Governance Data is **metadata about the system**, not part of the data transformation or execution itself.

#### 3.5 Key Distinctions

| Concept | Definition |
|---|---|
| **Architectural category** | One of the three parallel categories |
| **Data lifecycle stage** | A stage in the sequential transformation |
| **Execution data type** | A category of runtime/output data |
| **Governance data type** | A category of metadata |
| **Data entity** | A specific type of data |

**Rule:** These are **different data concepts**. They are not layers, not components, and not domains.

---

### 4. Data Lifecycle

#### 4.1 Stage 1 — Source

**Purpose:** Represent external data as received, before any processing.

**Primary entities:**

| Entity | Description | Semantic owner |
|---|---|---|
| **Meter data** | Historical site consumption | Domain 2 |
| **Market prices** | DA/RT LMP, ancillary, capacity | Domain 2 |
| **Program rules** | DR program parameters | Domain 2 |
| **Grid constraints** | Interconnection limits | Domain 2 |
| **Battery vendor data** | Degradation curves, warranty terms | Domain 1 |
| **Benchmark data** | Reference cases | Domain 6 |
| **Financial assumptions** | Discount rate, escalation, tax | Domain 6 |
| **Scenario definitions** | Scenario parameters | Scenario Management |

**Architectural owner:** Domain 7 (data infrastructure)

**Semantic owner:** The domain that defines what the data means.

**Note:** The exact list of sources depends on **PH-003 (Data availability)** — what ENGIE provides.

#### 4.2 Stage 2 — Ingested

**Purpose:** Represent data loaded into the system, structured and timestamped.

**Primary entities:**

| Entity | Description | Semantic owner |
|---|---|---|
| **Ingested meter data** | Structured meter readings | Domain 2 |
| **Ingested market prices** | Structured price curves | Domain 2 |
| **Ingested program rules** | Structured DR rules | Domain 2 |
| **Ingested grid constraints** | Structured constraints | Domain 2 |
| **Ingested battery data** | Structured vendor data | Domain 1 |
| **Ingested financial assumptions** | Structured assumptions | Domain 6 |

**Architectural owner:** Domain 7

**Semantic owner:** The domain that defines the data.

#### 4.3 Stage 3 — Validated

**Purpose:** Represent data that has passed quality checks and is ready for transformation.

**Primary entities:**

| Entity | Description | Semantic owner |
|---|---|---|
| **Validated meter data** | Meter data passing quality checks | Domain 2 |
| **Validated market prices** | Prices passing quality checks | Domain 2 |
| **Validated program rules** | Program rules passing quality checks | Domain 2 |
| **Validated grid constraints** | Constraints passing quality checks | Domain 2 |
| **Validated battery data** | Battery data passing quality checks | Domain 1 |
| **Validated financial assumptions** | Assumptions passing quality checks | Domain 6 |

**Architectural owner:** Domain 7

**Semantic owner:** The domain that defines the data.

#### 4.4 Stage 4 — Model-ready

**Purpose:** Represent data structured and aligned for the engineering components.

**Primary entities:**

| Entity | Description | Semantic owner |
|---|---|---|
| **BESS envelope** | Feasible operating envelope | Domain 1 |
| **Load signals** | Short-horizon and multi-year load | Domain 2 |
| **Price signals** | DA, RT, ancillary, capacity | Domain 2 |
| **Program signals** | DR events, rules | Domain 2 |
| **Context-derived signals** | Aggregated context | Domain 2 |
| **Operational requirements** | Per value stream | Domain 3 |
| **Physical capability inputs** | For Dispatch | Domain 1 |
| **Degradation inputs** | Initial state, parameters | Domain 5 |
| **Financial inputs** | Structured financial assumptions | Domain 6 |

**Data product owner:** The producing domain

**Persistence / infrastructure owner:** Domain 7

**Note on Dispatch inputs.** In B.1, "Dispatch inputs" is not a single container. Dispatch consumes distinct inputs (physical capability, external/context signals, operational requirements, degradation state, financial inputs). B.2 and B.3 define how these inputs are composed.

**Boundary:**

| In scope | Out of scope |
|---|---|
| Structuring data for components | Component logic |
| Aligning data in time | Physical representation |
| Ensuring completeness | Exact algorithms |

---

### 5. Execution Data

#### 5.1 Execution State

**Purpose:** Represent state that persists across iterations.

**Primary entities:**

| Entity | Description | State owner | Evolution owner | Nature |
|---|---|---|---|---|
| **SOC state** | Current state of charge | BESS Model | Dispatch | State |
| **SOH state** | Current state of health | BESS Model | Degradation | State |
| **Available capacity** | Derived from SOH | BESS Model | Degradation | Derived state |
| **EFC / degradation history** | Cumulative throughput | Degradation Engine | Degradation Engine | History |
| **Augmentation history** | Capacity addition events | Degradation Engine | Degradation Engine | History |
| **Replacement history** | Full replacement events | Degradation Engine | Degradation Engine | History |
| **Cash flow accumulator** | Annual cash flow | Financial Engine | Financial Engine | State |
| **Reserve capacity** | Reserved capacity per stream | Dispatch Engine | Dispatch Engine | State |

**Persistence owner:** Domain 7 (persistence infrastructure)

**State owner:** The component that owns the operational state.

**Evolution owner:** The component that updates the state according to its governing model.

#### 5.2 Runtime State

**Purpose:** Represent state within a single execution.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **Current iteration state** | State of the current execution step | Execution Control |
| **Current scenario parameters** | Parameters in use | Scenario Management |
| **Current execution context** | Execution metadata | Execution Control |

#### 5.3 State History

**Purpose:** Represent historical record of state evolution.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **SOC trajectory** | SOC over time | Dispatch Engine |
| **SOH evolution** | SOH over time | Degradation Engine |
| **Cash flow history** | Annual cash flows | Financial Engine |

**Note:** State History is the **output** of execution over time, not runtime state. It is produced by components and persisted for analysis.

#### 5.4 Run Metadata

**Purpose:** Information about each execution.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **Run identity** | Unique identifier for the run | Execution Control |
| **Run timestamp** | When the run occurred | Execution Control |
| **Run parameters** | Parameters used | Scenario Management |
| **Run status** | Success/failure, warnings | Execution Control |

#### 5.5 Results

**Purpose:** Represent operational and financial outputs.

**Primary entities:**

| Entity | Description | Producing component |
|---|---|---|
| **Dispatch schedule** | Charge/discharge/rest per interval | Dispatch Engine |
| **Operational attribution basis** | Which stream owns which behavior | Dispatch Engine |
| **Bill with/without BESS** | Customer bill by component (BTM) | Tariff Engine |
| **Savings by component** | Demand, energy, export (BTM) | Tariff Engine |
| **Augmentation events** | Physical events | Degradation Engine |
| **Replacement events** | Physical events | Degradation Engine |
| **Revenue by stream** | Annual revenue per stream | Financial Engine |
| **Cash flow** | Annual net cash flow | Financial Engine |
| **KPIs** | NPV, IRR, payback | Financial Engine |

**Architectural owner:** Domain 7 (storage infrastructure)

**Producing owner:** The component that produces the results.

---

### 6. Governance Data

#### 6.1 Lineage

**Purpose:** Trace data from source through transformation to result.

**Conceptual requirements:**

- Track which source data contributed to which input
- Track which transformation produced which output
- Track which input produced which result
- Support retrieval of lineage for audit

**Owner:** Lineage capability.

**Working default (PH-048):** Basic data lineage.

#### 6.2 Validation Evidence

**Purpose:** Represent validation results and evidence.

**Conceptual requirements:**

- Validation results per domain
- Validation results per model
- Validation results per system
- Validation results per UAT

**Owner:** Validation capability.

#### 6.3 Version Metadata

**Purpose:** Track versions of data, parameters, and code.

**Conceptual requirements:**

- Data versions
- Parameter versions
- Code versions
- Support reproducibility

**Owner:** Configuration capability + Lineage capability.

#### 6.4 Scenario / Run Identity

**Purpose:** Identity of scenarios and runs.

**Conceptual requirements:**

- Scenario identity
- Run identity
- Parent scenario (for inheritance)
- Related runs

**Owner:** Scenario Management capability.

---

### 7. Data Ownership

#### 7.1 Ownership Principle

**Rule:** Data ownership has **two dimensions**:

| Dimension | Definition | Owner |
|---|---|---|
| **Architectural ownership** | Who provides the data infrastructure | Domain 7 (Data & Application Engineering) |
| **Semantic ownership** | Who defines what the data means | The producing domain |

**Rule:** These are **not the same thing**. Architectural ownership is about infrastructure; semantic ownership is about meaning.

**Rule:** No data family has multiple architectural owners. Multiple domains may have semantic ownership over different entities within the same family.

#### 7.2 Ownership Matrix

| Category | Sub-category | Architectural owner | Semantic owner |
|---|---|---|---|
| **Data Lifecycle** | Source | Domain 7 | Producing domain |
| **Data Lifecycle** | Ingested | Domain 7 | Producing domain |
| **Data Lifecycle** | Validated | Domain 7 | Producing domain |
| **Data Lifecycle** | Model-ready | Producing domain | Producing domain |
| **Execution Data** | Execution State | Domain 7 (persistence) | State owner (component) |
| **Execution Data** | Runtime State | Execution Control | Execution Control |
| **Execution Data** | State History | Domain 7 (persistence) | Producing component |
| **Execution Data** | Run Metadata | Execution Control | Execution Control |
| **Execution Data** | Results | Domain 7 (storage) | Producing component |
| **Governance Data** | Lineage | Lineage capability | Lineage capability |
| **Governance Data** | Validation Evidence | Validation capability | Validation capability |
| **Governance Data** | Version Metadata | Configuration capability | Configuration capability |
| **Governance Data** | Scenario/Run Identity | Scenario Management | Scenario Management |

#### 7.3 Domain 2 Ownership Note

Per `SYS-ENG-DEF-001` and B.0, **Domain 2 owns the External Context interface**.

This means:

- Domain 2 owns the **semantic definition** of external-context data
- Domain 2 produces **context-derived signals** consumed by other components
- No other component receives raw external context

**Architectural clarification:**

- Domain 7 manages the **common data lifecycle** (Source → Ingested → Validated) for all data
- Domain 2 retains **semantic ownership** of external context data
- Other domains retain semantic ownership of their domain-specific inputs (battery data → Domain 1, financial assumptions → Domain 6, etc.)

This resolves the tension between **domain ownership** (semantic) and **data/application ownership** (architectural).

---

### 8. Data Flows

#### 8.1 Data Lifecycle Flows

| From | To | Data |
|---|---|---|
| External Sources | Source | Raw external data |
| Source | Ingested | Structuring + timestamping |
| Ingested | Validated | Quality checks |
| Validated | Model-ready | Alignment + structuring |

#### 8.2 Execution Data Flows

| From | To | Data |
|---|---|---|
| Model-ready | Components | Inputs for execution |
| Components | Execution State | State updates |
| Execution State | Components | State for next iteration |
| Components | State History | State snapshots |
| Components | Results | Outputs |
| Results | Application | Presentation |

#### 8.3 Governance Data Flows

**Note:** Governance Data is **metadata linked to other data**, not a separate data flow.

| Link | Description |
|---|---|
| **Lineage metadata** | Links Results to upstream Source → Ingested → Validated → Model-ready records |
| **Validation Evidence** | Attached to Validated data and Results |
| **Version Metadata** | Attached to all data |
| **Scenario/Run Identity** | Attached to all execution data |

**Rule:** Governance Data is **linked** to the data it governs. It is not a data flow in the traditional sense.

#### 8.4 Feedback Data Flows

| Flow | Description |
|---|---|
| **Components → Execution State → Components** | State persistence across iterations |
| **Degradation → Execution State → Dispatch** | SOH state feeds back to Dispatch |
| **Dispatch → Execution State → Degradation** | SOC trajectory feeds forward to Degradation |

**Reference:** B.0 §14.3 (Physical-Operational Feedback Loop).

---

### 9. Data Interfaces

#### 9.1 Interface Principles

| Principle | Description |
|---|---|
| **Explicit** | Every data interface is declared |
| **Contract-based** | Interfaces have defined contracts |
| **Directional** | Producer → Consumer |
| **Deterministic where applicable** | Same declared inputs and configuration produce reproducible outputs |
| **Data, not logic** | Interfaces exchange data and state, not algorithms |

**Note on "idempotent" vs "deterministic".** The principle is **determinism** (same inputs → same outputs given same configuration), not strict idempotency. Some operations (e.g., ingestion) may be idempotent; others (e.g., dispatch execution) are deterministic but not necessarily idempotent.

#### 9.2 Data Interface Matrix

| Producer | Consumer | Interface |
|---|---|---|
| Source | Ingested | Ingestion contract |
| Ingested | Validated | Validation contract |
| Validated | Model-ready | Transformation contract |
| Model-ready | Components | Input contract |
| Components | Execution State | State update contract |
| Execution State | Components | State read contract |
| Components | State History | History contract |
| Components | Results | Output contract |
| Results | Application | Presentation contract |

#### 9.3 Inter-Component Data Interfaces

| From Component | To Component | Data |
|---|---|---|
| BESS Model | Operational Model | Physical capabilities |
| BESS Model | Dispatch Engine | Feasible envelope |
| BESS Model | Degradation Engine | Physical state |
| Load & Market Model | Operational Model | External conditions |
| Load & Market Model | Dispatch Engine | Context-derived signals, prices, load |
| Operational Model | Dispatch Engine | Operational requirements |
| Operational Model | Degradation Engine | Behavior declarations |
| Dispatch Engine | Degradation Engine | Trajectories |
| Dispatch Engine | Tariff Engine | Net load |
| Dispatch Engine | Financial Engine | Attribution basis |
| Degradation Engine | BESS Model | Updated SOH |
| Degradation Engine | Dispatch Engine | Marginal signal |
| Degradation Engine | Financial Engine | Physical events |
| Tariff Engine | Financial Engine | Bill and savings outputs (BTM) |
| Scenario Management | All Components | Configuration |
| Validation | All Components | Validation criteria |

---

### 10. Data Quality Requirements

#### 10.1 Quality Dimensions

| Dimension | Description |
|---|---|
| **Completeness** | All required data is present |
| **Timeliness** | Data is available when needed |
| **Consistency** | Data is internally consistent |
| **Accuracy** | Data reflects reality within tolerance |
| **Validity** | Data conforms to expected format and range |
| **Uniqueness** | No unintended duplicates |

#### 10.2 Quality Requirements per Category

| Category | Primary Quality Requirements |
|---|---|
| **Data Lifecycle — Source** | Completeness, timeliness (as received) |
| **Data Lifecycle — Ingested** | Completeness, consistency, validity |
| **Data Lifecycle — Validated** | Accuracy, cross-signal alignment, structural consistency |
| **Data Lifecycle — Model-ready** | Completeness, alignment, coverage of horizon |
| **Execution Data — State** | Consistency, reproducibility |
| **Execution Data — Results** | Accuracy, traceability, reproducibility |
| **Governance Data** | Completeness, traceability |

#### 10.3 Quality Enforcement

| Level | Responsibility |
|---|---|
| **Ingestion** | Domain 7 (Data Layer) |
| **Validation** | Domain 7 (Data Layer) + Validation capability |
| **Transformation** | Domain 7 (Data Layer) |
| **Component consumption** | Each domain |

**Rule:** Quality is enforced **before** data is consumed. Validation evidence is produced **before** results are accepted.

**Reference:** `SYS-STR-FRM-001` §8.2 (Validation).

---

### 11. Lineage and Versioning (Conceptual)

#### 11.1 Lineage

**Purpose:** Trace data from source through transformation to result.

**Conceptual requirements:**

- Track which source data contributed to which input
- Track which transformation produced which output
- Track which input produced which result
- Support retrieval of lineage for audit

**Working default (PH-048):** Basic data lineage.

#### 11.2 Versioning

**Purpose:** Track versions of data, parameters, and code.

**Conceptual requirements:**

- Version inputs
- Version parameters
- Version code
- Support reproducibility
- Support replay of historical runs

#### 11.3 Reproducibility

**Purpose:** Ensure reproducibility of results given equivalent execution conditions.

**Conceptual requirements:**

- Same declared inputs, configuration, state initialization, and execution version → reproducible results
- Same parameters → same behavior
- Same code version → same results
- Support comparison across runs

---

### 12. Logical Data Types

#### 12.1 Recognized Logical Types

B.1 recognizes the following **logical data types** (not physical types):

| Logical Type | Description | Example |
|---|---|---|
| **Time series** | Data indexed by time | Meter data, prices, SOC trajectory |
| **Scalar parameter** | Single value | Nominal capacity, discount rate |
| **State vector** | Multi-dimensional state | BESS state (SOC, SOH) |
| **Event** | Discrete occurrence with timestamp | Augmentation, replacement |
| **Curve** | Function of a variable | Efficiency curve, degradation curve |
| **Scenario parameter** | Parameter with scenario variants | Load growth rate, market prices |
| **Financial assumption** | Financial input | CAPEX, OPEX, discount rate |
| **Aggregate metric** | Summary quantity | NPV, IRR, peak reduction |

**Rule:** Logical types are architectural. Physical types (integer, float, string, timestamp, etc.) are deferred to Stage C.

#### 12.2 Deferred to Stage C

| Deferred to Stage C |
|---|
| Physical data types |
| Column definitions |
| Data schemas |
| Storage formats |
| Serialization details |

---

### 13. Scenario Isolation (Conceptual)

#### 13.1 Purpose

Ensure that scenarios do not contaminate each other.

#### 13.2 Conceptual Requirements

| Requirement | Description |
|---|---|
| **Parameter isolation** | Each scenario has its own parameters |
| **Data isolation** | Each scenario has its own data |
| **State isolation** | Each scenario has its own state |
| **Result isolation** | Each scenario has its own results |
| **No shared mutable state** | Scenarios do not share mutable state |

#### 13.3 Isolation Mechanisms

| Mechanism | Description |
|---|---|
| **Scenario identity** | Every data item is tagged with its scenario |
| **Separate execution** | Scenarios are executed independently |
| **Separate persistence** | Scenarios persist in separate logical spaces |
| **Comparison support** | Scenarios can be compared without interference |

**Reference:** `SYS-STR-FRM-001` §8.1, ADR-005.

---

### 14. What Is Deliberately NOT Defined Here

| Not defined in B.1 | Belongs to |
|---|---|
| Physical schemas | Stage C |
| Delta tables | Stage C |
| SQL DDL | Stage C |
| Column definitions | Stage C |
| Physical data types | Stage C |
| Partitioning strategy | Stage C / B.6 |
| Storage technology | B.6 |
| Databricks configuration | B.6 |
| PySpark code | Stage D |
| Exact validation rules | Stage C |
| Exact transformation logic | Stage C |
| Pipeline implementation | Stage C / D |
| Remediation strategies | Stage C |
| Code | Stage D |

**Note:** Logical data types are defined in §12 where required to establish architectural contracts. Physical data types are deferred to Stage C.

---

### 15. Next Steps

**B.1 status:**

| Aspect | Status |
|---|---|
| B.1 Data Architecture | ✅ Baseline Candidate (v0.3) |
| B.2 Model Architecture | ⏭ Next |
| B.3 Optimization Architecture | ⏭ Pending |
| B.4 Financial Architecture | ⏭ Pending |
| B.5 Software Architecture | ⏭ Pending |
| B.6 Databricks Architecture | ⏭ Pending |
| Stage B → Stage C Handoff | ⏭ Pending |

---

