# B.1 Data Architecture — §4 de STAGE-B-HLD-001

Aquí está B.1 completo, con el nivel correcto (arquitectura, no especificación).

---

# STAGE-B-HLD-001 — System Architecture (HLD)

## §4 — B.1 Data Architecture

**Document ID:** STAGE-B-HLD-001

**Version:** 0.1 — Draft

**Section:** §4 — B.1 Data Architecture

**Status:** Stage B — Draft for Review

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

**Note on versions.** Parent document versions are not restated here; they are as declared in each document.

---

### 1. Purpose of B.1

B.1 defines the **data architecture** of the system. It establishes:

- What **logical data entities** exist
- How data is organized into **families**
- Who **owns** each data family
- How data **flows** between families
- What **transformation states** exist
- What **data interfaces** exist between components
- What **data quality** requirements apply
- How **lineage and versioning** are conceptually handled
- How **scenario isolation** is conceptually achieved

B.1 **does not** define:

- Physical schemas
- Delta tables
- SQL DDL
- PySpark code
- Databricks configuration
- Storage technology
- Physical partitioning
- Validation rules (exact)
- Pipeline implementation

Those belong to Stage C (specification) and Stage D (implementation).

**Rule:** *B.1 defines the logical data architecture; Stage C defines the physical data specification.*

B.1 answers:

> **How is data logically organized and managed across the system?**

---

### 2. Position Within Stage B

B.1 sits **after B.0** (Integrated System Architecture) and **before B.2** (Model Architecture). It details the data dimension of the architecture defined in B.0.

| View | Depends on B.0 | Detail Level |
|---|---|---|
| B.0 | — | Architectural contract |
| **B.1 Data Architecture** | **B.0** | **Data details** |
| B.2 Model Architecture | B.0, B.1 | Component details |
| B.3 Optimization Architecture | B.0, B.2 | Dispatch details |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| B.5 Software Architecture | B.0–B.4 | Software details |
| B.6 Databricks Architecture | B.0–B.5 | Platform details |

**Rule:** B.1 constrains B.2–B.6 on data aspects. No view can contradict B.1's data model.

**Rule:** B.1 does not redefine components, responsibilities, or interfaces already declared in B.0. It represents their data dimension.

---

### 3. Data Architecture View

#### 3.1 Data Flow Overview

```
        EXTERNAL DATA SOURCES
                │
                ▼
        ┌───────────────┐
        │   INGESTION   │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │     RAW       │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │  VALIDATED    │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │ MODEL-READY   │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │   EXECUTION   │
        │     STATE     │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │    RESULTS    │
        └───────┬───────┘
                │
                ▼
        APPLICATION / REPORTING
```

**Note:** This flow is **logical**, not physical. The physical implementation (storage, format, technology) is defined in B.6.

#### 3.2 Data Families

The system has **6 logical data families**:

| # | Family | Description |
|---|---|---|
| F1 | **Sources** | External data as received (raw, unprocessed) |
| F2 | **Ingested** | Data loaded into the system (structured, timestamped) |
| F3 | **Validated** | Data that has passed quality checks |
| F4 | **Model-ready** | Data structured and aligned for the engineering components |
| F5 | **Execution State** | State that persists across iterations (SOC, SOH, cash flow) |
| F6 | **Results** | Operational and financial outputs |

Each family is **owned** by a data owner (see §5) and has **defined contracts** with adjacent families (see §7).

#### 3.3 Key Distinctions

| Concept | Definition |
|---|---|
| **Data family** | A logical grouping of data with a defined purpose |
| **Data entity** | A specific type of data within a family |
| **Data owner** | The domain responsible for the data family |
| **Data flow** | Movement of data between families |
| **Data interface** | Contract between adjacent families |
| **Data quality** | Requirements applied at validation |

**Rule:** These are **different data concepts**. They are not layers, not components, and not domains.

---

### 4. Data Families

#### 4.1 Family F1 — Sources

**Purpose:** Represent external data as received, before any processing.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **Meter data** | Historical site consumption | Domain 2 |
| **Market prices** | DA/RT LMP, ancillary, capacity | Domain 2 |
| **Program rules** | DR program parameters | Domain 2 |
| **Grid constraints** | Interconnection limits | Domain 2 |
| **Battery vendor data** | Degradation curves, warranty terms | Domain 1 |
| **Benchmark data** | Reference cases | Domain 6 |
| **Financial assumptions** | Discount rate, escalation, tax | Domain 6 |
| **Scenario definitions** | Scenario parameters | Scenario Management |

**Boundary:**

| In scope | Out of scope |
|---|---|
| Raw external data | Processing or validation |
| Source metadata (origin, timestamp) | Transformation |
| Coverage of the simulation horizon | Physical storage format |

**Note:** The exact list of sources depends on **PH-003 (Data availability)** — what ENGIE provides.

#### 4.2 Family F2 — Ingested

**Purpose:** Represent data loaded into the system, structured and timestamped.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **Ingested meter data** | Structured meter readings | Domain 2 |
| **Ingested market prices** | Structured price curves | Domain 2 |
| **Ingested program rules** | Structured DR rules | Domain 2 |
| **Ingested grid constraints** | Structured constraints | Domain 2 |
| **Ingested battery data** | Structured vendor data | Domain 1 |
| **Ingested financial assumptions** | Structured assumptions | Domain 6 |

**Boundary:**

| In scope | Out of scope |
|---|---|
| Structuring raw data | Validation |
| Timestamping | Transformation |
| Basic format normalization | Physical schema design |

#### 4.3 Family F3 — Validated

**Purpose:** Represent data that has passed quality checks and is ready for transformation.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **Validated meter data** | Meter data passing quality checks | Domain 2 |
| **Validated market prices** | Prices passing quality checks | Domain 2 |
| **Validated program rules** | Program rules passing quality checks | Domain 2 |
| **Validated grid constraints** | Constraints passing quality checks | Domain 2 |
| **Validated battery data** | Battery data passing quality checks | Domain 1 |
| **Validated financial assumptions** | Assumptions passing quality checks | Domain 6 |

**Boundary:**

| In scope | Out of scope |
|---|---|
| Quality checks (completeness, type, range) | Exact validation rules (Stage C) |
| Structural consistency | Physical storage |
| Cross-signal alignment | Remediation strategies |

#### 4.4 Family F4 — Model-ready

**Purpose:** Represent data structured and aligned for the engineering components.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **BESS envelope** | Feasible operating envelope | Domain 1 |
| **Load signals** | Short-horizon and multi-year load | Domain 2 |
| **Price signals** | DA, RT, ancillary, capacity | Domain 2 |
| **Program signals** | DR events, rules | Domain 2 |
| **Context-derived signals** | Aggregated context | Domain 2 |
| **Operational requirements** | Per value stream | Domain 3 |
| **Dispatch inputs** | All inputs needed by Dispatch | Domain 4 |
| **Degradation inputs** | Initial state, parameters | Domain 5 |
| **Financial assumptions** | Structured financial inputs | Domain 6 |

**Boundary:**

| In scope | Out of scope |
|---|---|
| Structuring data for components | Component logic |
| Aligning data in time | Physical representation |
| Ensuring completeness | Exact algorithms |

#### 4.5 Family F5 — Execution State

**Purpose:** Represent state that persists across iterations.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **SOC trajectory** | SOC over time | BESS Model |
| **SOH state** | Current state of health | BESS Model |
| **Available capacity** | Derived from SOH | BESS Model |
| **EFC / degradation history** | Cumulative throughput | Degradation Engine |
| **Augmentation history** | Capacity addition events | Degradation Engine |
| **Replacement history** | Full replacement events | Degradation Engine |
| **Cash flow accumulator** | Annual cash flow | Financial Engine |
| **Reserve capacity** | Reserved capacity per stream | Dispatch Engine |

**Boundary:**

| In scope | Out of scope |
|---|---|
| State representation | State evolution law |
| Persistence requirements | Physical storage |
| Cross-iteration continuity | Orchestration |

#### 4.6 Family F6 — Results

**Purpose:** Represent operational and financial outputs.

**Primary entities:**

| Entity | Description | Owner |
|---|---|---|
| **Dispatch schedule** | Charge/discharge/rest per interval | Domain 4 |
| **Operational attribution basis** | Which stream owns which behavior | Domain 4 |
| **Bill with/without BESS** | Customer bill by component | Domain 2 |
| **Savings by component** | Demand, energy, export | Domain 2 |
| **Augmentation events** | Physical events | Domain 5 |
| **Replacement events** | Physical events | Domain 5 |
| **Revenue by stream** | Annual revenue per stream | Domain 6 |
| **Cash flow** | Annual net cash flow | Domain 6 |
| **KPIs** | NPV, IRR, payback | Domain 6 |
| **Validation evidence** | Validation results | Validation |
| **Lineage records** | Data and decision traceability | Lineage |

**Boundary:**

| In scope | Out of scope |
|---|---|
| Result representation | Result computation |
| Aggregation levels | Presentation |
| Traceability | Physical storage |

---

### 5. Data Ownership

#### 5.1 Ownership Principle

**Rule:** Every data family has **exactly one owner**. The owner is responsible for:

- Data correctness
- Data availability
- Data quality
- Data lifecycle

**Rule:** Other components **consume** data; they do not own it.

#### 5.2 Ownership Matrix

| Data Family | Primary Owner | Contributors |
|---|---|---|
| **F1 — Sources** | Domain 2 (external) + Domain 1 (battery) + Domain 6 (financial) | Scenario Management |
| **F2 — Ingested** | Domain 7 (Data Layer) | Domains 1, 2, 6 |
| **F3 — Validated** | Domain 7 (Data Layer) | Domains 1, 2, 6 |
| **F4 — Model-ready** | Each domain (their own model-ready data) | Domain 7 (orchestration) |
| **F5 — Execution State** | Component owners (BESS, Degradation, Dispatch, Financial) | Domain 7 (persistence) |
| **F6 — Results** | Component owners (Dispatch, Degradation, Financial, Validation) | Domain 7 (storage) |

#### 5.3 Domain 2 Ownership Note

Per `SYS-ENG-DEF-001` and B.0, **Domain 2 owns the External Context interface**. This means:

- Domain 2 owns external context data (Sources, Ingested, Validated, Model-ready)
- Domain 2 produces **context-derived signals** consumed by other components
- No other component receives raw external context

---

### 6. Data Flows

#### 6.1 Primary Data Flows

| From | To | Data |
|---|---|---|
| External Sources | F1 (Sources) | Raw external data |
| F1 (Sources) | F2 (Ingested) | Structuring + timestamping |
| F2 (Ingested) | F3 (Validated) | Quality checks |
| F3 (Validated) | F4 (Model-ready) | Alignment + structuring |
| F4 (Model-ready) | Components | Inputs for execution |
| Components | F5 (Execution State) | State updates |
| F5 (Execution State) | Components | State for next iteration |
| Components | F6 (Results) | Outputs |
| F6 (Results) | Application | Presentation |

#### 6.2 Cross-Family Flows

| Flow | Description |
|---|---|
| **F1 → F6** | Source metadata flows to results for lineage |
| **F2 → F6** | Ingestion metadata flows to results for lineage |
| **F3 → F6** | Validation evidence flows to results |
| **F5 → F6** | Execution state snapshots flow to results for traceability |

#### 6.3 Feedback Data Flows

| Flow | Description |
|---|---|
| **Components → F5 → Components** | State persistence across iterations |
| **Degradation → F5 → Dispatch** | SOH state feeds back to Dispatch |
| **Dispatch → F5 → Degradation** | SOC trajectory feeds forward to Degradation |

**Reference:** B.0 §14.3 (Physical-Operational Feedback Loop).

---

### 7. Data Interfaces

#### 7.1 Interface Principles

| Principle | Description |
|---|---|
| **Explicit** | Every data interface is declared |
| **Contract-based** | Interfaces have defined contracts |
| **Directional** | Producer → Consumer |
| **Idempotent** | Same inputs produce same outputs |
| **Data, not logic** | Interfaces exchange data, not algorithms |

#### 7.2 Data Interface Matrix

| Producer Family | Consumer Family | Interface |
|---|---|---|
| F1 (Sources) | F2 (Ingested) | Ingestion contract |
| F2 (Ingested) | F3 (Validated) | Validation contract |
| F3 (Validated) | F4 (Model-ready) | Transformation contract |
| F4 (Model-ready) | Components | Input contract |
| Components | F5 (Execution State) | State update contract |
| F5 (Execution State) | Components | State read contract |
| Components | F6 (Results) | Output contract |
| F6 (Results) | Application | Presentation contract |

#### 7.3 Inter-Component Data Interfaces

| From Component | To Component | Data |
|---|---|---|
| BESS Model | Operational Model | Physical capabilities |
| BESS Model | Dispatch Engine | Feasible envelope |
| BESS Model | Degradation Engine | Physical state |
| Load & Market Model | Operational Model | External conditions |
| Load & Market Model | Dispatch Engine | Signals, prices, load |
| Operational Model | Dispatch Engine | Requirements |
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

**Note:** These interfaces correspond to the B.0 §13.1 inter-component interfaces, expressed as **data**.

---

### 8. Data Quality Requirements

#### 8.1 Quality Dimensions

| Dimension | Description |
|---|---|
| **Completeness** | All required data is present |
| **Timeliness** | Data is available when needed |
| **Consistency** | Data is internally consistent |
| **Accuracy** | Data reflects reality within tolerance |
| **Validity** | Data conforms to expected format and range |
| **Uniqueness** | No unintended duplicates |

#### 8.2 Quality Requirements per Family

| Family | Primary Quality Requirements |
|---|---|
| **F1 — Sources** | Completeness, timeliness (as received) |
| **F2 — Ingested** | Completeness, consistency, validity |
| **F3 — Validated** | Accuracy, cross-signal alignment, structural consistency |
| **F4 — Model-ready** | Completeness, alignment, coverage of horizon |
| **F5 — Execution State** | Consistency, reproducibility |
| **F6 — Results** | Accuracy, traceability, reproducibility |

#### 8.3 Quality Enforcement

| Level | Responsibility |
|---|---|
| **Ingestion** | Domain 7 (Data Layer) |
| **Validation** | Domain 7 (Data Layer) + Validation capability |
| **Transformation** | Domain 7 (Data Layer) |
| **Component consumption** | Each domain |

**Rule:** Quality is enforced **before** data is consumed. Validation evidence is produced **before** results are accepted.

**Reference:** `SYS-STR-FRM-001` §8.2 (Validation).

---

### 9. Lineage and Versioning (Conceptual)

#### 9.1 Lineage

**Purpose:** Trace data from source through transformation to result.

**Conceptual requirements:**

- Track which source data contributed to which input
- Track which transformation produced which output
- Track which input produced which result
- Support retrieval of lineage for audit

**Working default (PH-048):** Basic data lineage.

#### 9.2 Versioning

**Purpose:** Track versions of data, parameters, and code.

**Conceptual requirements:**

- Version inputs
- Version parameters
- Version code
- Support reproducibility
- Support replay of historical runs

#### 9.3 Reproducibility

**Purpose:** Ensure that the same inputs produce the same outputs.

**Conceptual requirements:**

- Same inputs → same outputs
- Same parameters → same behavior
- Same code version → same results
- Support comparison across runs

---

### 10. Scenario Isolation (Conceptual)

#### 10.1 Purpose

Ensure that scenarios do not contaminate each other.

#### 10.2 Conceptual Requirements

| Requirement | Description |
|---|---|
| **Parameter isolation** | Each scenario has its own parameters |
| **Data isolation** | Each scenario has its own data |
| **State isolation** | Each scenario has its own state |
| **Result isolation** | Each scenario has its own results |
| **No shared mutable state** | Scenarios do not share mutable state |

#### 10.3 Isolation Mechanisms

| Mechanism | Description |
|---|---|
| **Scenario identity** | Every data item is tagged with its scenario |
| **Separate execution** | Scenarios are executed independently |
| **Separate persistence** | Scenarios persist in separate logical spaces |
| **Comparison support** | Scenarios can be compared without interference |

**Reference:** `SYS-STR-FRM-001` §8.1, ADR-005.

---

### 11. What Is Deliberately NOT Defined Here

| Not defined in B.1 | Belongs to |
|---|---|
| Physical schemas | Stage C |
| Delta tables | Stage C |
| SQL DDL | Stage C |
| Column definitions | Stage C |
| Data types | Stage C |
| Partitioning strategy | Stage C / B.6 |
| Storage technology | B.6 |
| Databricks configuration | B.6 |
| PySpark code | Stage D |
| Exact validation rules | Stage C |
| Exact transformation logic | Stage C |
| Pipeline implementation | Stage C / D |
| Remediation strategies | Stage C |
| Code | Stage D |

---

### 12. Next Steps

**B.1 status:**

| Aspect | Status |
|---|---|
| B.1 Data Architecture | ✅ Draft for Review (v0.1) |
| B.2 Model Architecture | ⏭ Next |
| B.3 Optimization Architecture | ⏭ Pending |
| B.4 Financial Architecture | ⏭ Pending |
| B.5 Software Architecture | ⏭ Pending |
| B.6 Databricks Architecture | ⏭ Pending |
| Stage B → Stage C Handoff | ⏭ Pending |

---

**End of §4 — B.1 Data Architecture (v0.1)**

**Status:** Draft for Review

**Next:** B.2 Model Architecture

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1