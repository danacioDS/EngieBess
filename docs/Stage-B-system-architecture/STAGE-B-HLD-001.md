# B.0 v0.3.1 — Informe Completo (Texto Normal)

Guarda este contenido como `docs/Stage-B-system-architecture/STAGE-B-HLD-001.md`.

---

# STAGE-B-HLD-001 — System Architecture (HLD)

**Document ID:** STAGE-B-HLD-001

**Version:** 0.3.1 — Draft for Baseline

**Status:** Stage B — Draft for Baseline

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

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

**Note on versions.** Parent document versions are not restated here; they are as declared in each document. Version reconciliation is a Stage A consolidation concern, not a Stage B concern.

---

## §3 — B.0 Integrated System Architecture

### 1. Purpose of B.0

B.0 is the **architectural contract** of the system. It defines **how the engineering model of Stage A is represented computationally**.

It establishes:

- What architectural **components** exist
- What **cross-cutting capabilities** span them
- How **data flows** through the system
- How **execution flows** through the system
- How **state evolves** and is owned
- How **components interact**
- How the **System Context propagates**
- What decisions are **inherited** from Stage A
- What decisions belong to **B.1–B.6**

B.0 **does not** define:

- Class structures
- Physical schemas
- API schemas
- Optimization equations
- Cash-flow equations
- Storage technology
- Databricks execution topology
- Application/service decomposition
- Code

**Rule:** *B.0 defines the architectural structure and contracts; B.1–B.6 define the architecture of each concern.*

B.0 answers:

> **How is the engineering model of Stage A represented computationally?**

---

### 2. Position Within Stage B

B.0 sits at the beginning of Stage B. It is the **architectural contract** that B.1–B.6 will detail.

| View | Depends on B.0 | Detail Level |
|---|---|---|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| B.2 Model Architecture | B.0 | Component details |
| B.3 Optimization Architecture | B.0 | Dispatch details |
| B.4 Financial Architecture | B.0 | Financial details |
| B.5 Software Architecture | B.0 | Software details |
| B.6 Databricks Architecture | B.0 | Platform details |

**Rule:** B.0 constrains B.1–B.6. No view can contradict B.0.

**Rule:** B.0 does not redefine components, responsibilities, or interfaces already declared in Stage A. It represents them computationally.

---

### 3. Architectural View

#### 3.1 Two Orthogonal Dimensions

The architecture has **two orthogonal dimensions**:

**Dimension 1 — Functional components** (the computational engines):

```
BESS Model · Load & Market Model · Tariff Engine
Operational Model · Dispatch Engine · Degradation Engine · Financial Engine
```

**Dimension 2 — Cross-cutting capabilities** (span the functional components):

```
Scenario Management · Configuration · Validation
Execution Control · Lineage · Observability
```

These two dimensions are **different architectural concepts**. They are not layers, not domains, and not technical infrastructure.

#### 3.2 Conceptual Architecture

```
                    USER / APPLICATION
                           │
                           ▼
              APPLICATION & REPORTING
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
  ┌───────────┐      ┌───────────┐      ┌───────────┐
  │ SCENARIO  │      │VALIDATION │      │EXECUTION  │
  │   MGMT    │      │           │      │  CONTROL  │
  └─────┬─────┘      └─────┬─────┘      └─────┬─────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                           ▼
              ENGINEERING COMPONENTS
        ┌──────────────────────────────────────┐
        │  BESS Model                          │
        │  Load & Market Model                 │
        │  Tariff Engine                       │
        │  Operational Model                   │
        │  Dispatch Engine                     │
        │  Degradation Engine                  │
        │  Financial Engine                    │
        └──────────────────┬───────────────────┘
                           │
                           ▼
                DATA & EXECUTION STATE
                           │
                           ▼
                EXTERNAL DATA SOURCES
```

**Note:** Cross-cutting capabilities **span** the engineering components. They are not a "layer".

#### 3.3 Key Distinctions

| Concept | Definition |
|---|---|
| **Functional components** | Computational engines (7) |
| **Cross-cutting capabilities** | Capabilities that span components (6) |
| **Stage A domains** | Engineering domains (7) |
| **Technical architecture layers** | Defined in B.5/B.6, not in B.0 |

**Rule:** These are **different architectural concepts**. B.0 does not define technical layers; those belong to B.5 (Software Architecture) and B.6 (Databricks Architecture).

---

### 4. The Functional Components

The system has **7 functional components**:

| # | Component | Primary Question |
|---|---|---|
| 1 | **BESS Model** | What can the physical BESS do? |
| 2 | **Load & Market Model** | What external conditions exist? |
| 3 | **Tariff Engine** | What is the customer bill with/without BESS? |
| 4 | **Operational Model** | How can each value stream use the BESS? |
| 5 | **Dispatch Engine** | How should the BESS be dispatched? |
| 6 | **Degradation Engine** | How does operation change the battery? |
| 7 | **Financial Engine** | What economic value results? |

**Note on Tariff Engine.** The Tariff Engine is **applicable to configurations where customer tariff economics are relevant**, particularly behind-the-meter (BTM) configurations. For front-of-the-meter (FTM) configurations, market revenues flow directly to the Financial Engine.

---

### 5. Cross-Cutting Capabilities

The system has **6 cross-cutting capabilities**:

| # | Capability | Purpose |
|---|---|---|
| C1 | **Scenario Management** | Parameterize and orchestrate scenarios |
| C2 | **Configuration** | Manage parameters, defaults, overrides |
| C3 | **Validation** | Ensure correctness at 4 levels |
| C4 | **Execution Control** | Coordinate execution flow |
| C5 | **Lineage** | Track data and decisions |
| C6 | **Observability** | Logs, metrics, traces |

Cross-cutting capabilities are **not** a layer. They span the functional components and interact with them through explicit interfaces.

---

### 6. Component 1 — BESS Model

#### 6.1 Purpose

Represent the **physical and technical state of the battery energy storage system** computationally, establishing the physical capabilities and constraints that any operational strategy or optimization must respect.

#### 6.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Physical state | SOC, SOH, availability |
| Physical envelope | Power, ramp, SOC bounds |
| Efficiency | Round-trip and conversion losses |
| Auxiliary consumption | Parasitic load |
| Interface to Degradation | State exchange |
| Interface to Dispatch | Envelope exchange |

#### 6.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Technical parameters | Battery config, nominal capacity, power rating |
| **Inputs** | Operating limits | SOC bounds, power bounds, ramp limits |
| **Inputs** | Environmental | Temperature profile (input assumption) |
| **Inputs** | Policy | Augmentation/replacement policy (via Scenario Mgmt) |
| **Outputs** | State | SOC, SOH, availability |
| **Outputs** | Capability | Available energy, charge/discharge power |
| **Outputs** | Envelope | Feasible operating envelope |

#### 6.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What can the physical BESS do? | What should the BESS do economically? |

**Reference:** Detailed in `A.2.1-BESS-ENG-001`.

---

### 7. Component 2 — Load & Market Model

#### 7.1 Purpose

Represent the **external operating environment** computationally — the electricity demand, tariffs, market prices, grid conditions, program rules, and (as extension) generation signals that determine the BESS's potential value.

#### 7.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Load | Historical, projected |
| Market | Prices, products |
| Programs | DR rules |
| Grid | Constraints |
| External context | All context signals |

#### 7.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Load data | Historical meter data, projections |
| **Inputs** | Market data | Prices, products |
| **Inputs** | Program data | DR rules |
| **Inputs** | Grid data | Constraints |
| **Outputs** | Load signals | Short-horizon, multi-year |
| **Outputs** | Price signals | DA, RT, ancillary, capacity |
| **Outputs** | Program signals | DR events, rules |
| **Outputs** | Context signals | Aggregated external context |

#### 7.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What is happening outside the BESS? | How should the BESS respond? |

**Ownership note.** Domain 2 owns the External Context interface. Other components consume context-derived signals produced by Domain 2.

**Reference:** Detailed in `A.2.2-LOAD-MKT-ENG-001`.

---

### 8. Component 3 — Tariff Engine

#### 8.1 Purpose

Apply the customer tariff to a load profile to compute the **customer bill with and without BESS**, providing the source of truth for behind-the-meter savings.

#### 8.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Tariff structure | TOU, demand charges, ratchets |
| Bill computation | With and without BESS |
| Savings by component | Demand, energy, export |

#### 8.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Tariff structure | TOU, demand, energy charges |
| **Inputs** | Net load | From Dispatch |
| **Outputs** | Bill without BESS | By component |
| **Outputs** | Bill with BESS | By component |
| **Outputs** | Savings by component | Demand, energy, export |

#### 8.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What is the customer bill with/without BESS? | How should the BESS be dispatched? |

**Applicability.** The Tariff Engine is applicable to configurations where customer tariff economics are relevant, particularly BTM configurations. For FTM-only configurations, market revenues flow directly to the Financial Engine.

**Reference:** Detailed in `A.2.2-LOAD-MKT-ENG-001` §9.

---

### 9. Component 4 — Operational Model

#### 9.1 Purpose

Define **how the BESS can be used to provide specific services** — the operational requirements each value stream imposes.

#### 9.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Value streams | Peak shaving, DR, arbitrage, regulation, voltage |
| Requirements | SOC floors, duration floors, reserve requirements |
| Service metrics | What each service delivers |
| Interactions | Shared resources |

#### 9.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | BESS capabilities |
| **Inputs** | External | Load, prices, programs |
| **Outputs** | Requirements | Per value stream |
| **Outputs** | Service metrics | Per value stream |
| **Outputs** | Interaction declarations | Shared resources |

#### 9.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does each value stream use the BESS? | Which stream gets priority? |

**Reference:** Detailed in `A.2.3-OPS-ENG-001`.

---

### 10. Component 5 — Dispatch Engine

#### 10.1 Purpose

Coordinate competing operational objectives under shared physical constraints.

#### 10.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Selection | Which streams are active |
| Coordination | How streams share resources |
| Constraints | Physical, operational, market |
| SOC management | Maintain SOC within bounds |
| Attribution | Operational attribution basis |

#### 10.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | Envelope, SOC bounds |
| **Inputs** | External | Load, prices, programs |
| **Inputs** | Operational | Requirements |
| **Inputs** | Degradation | SOH, marginal signal |
| **Outputs** | Dispatch | Charge/discharge schedule |
| **Outputs** | State | SOC trajectory |
| **Outputs** | Net load | Post-dispatch |
| **Outputs** | Attribution | Operational attribution basis |

#### 10.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How should the BESS be dispatched? | What is the physical battery? |

**Reference:** Detailed in `A.2.4-DISPATCH-ENG-001`.

---

### 11. Component 6 — Degradation Engine

#### 11.1 Purpose

Represent the **evolution of battery capability over time** as a consequence of operation.

#### 11.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Calendar aging | Time-dependent fade |
| Cycle aging | Throughput-dependent fade |
| State evolution | SOH, capacity, efficiency |
| Policy evaluation | Augmentation, replacement triggers |
| Marginal signal | Per-MWh degradation cost |

#### 11.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operating history | Trajectories, throughput |
| **Inputs** | Environmental | Temperature, SOC |
| **Inputs** | Physical | Initial state |
| **Inputs** | Scenario | Replacement cost |
| **Outputs** | State | Updated SOH |
| **Outputs** | Signal | Marginal degradation cost |
| **Outputs** | Events | Augmentation, replacement |

#### 11.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does operation change the battery? | What is the economic value of degradation? |

**Reference:** Detailed in `A.2.5-DEG-ENG-001`.

---

### 12. Component 7 — Financial Engine

#### 12.1 Purpose

Translate operational behavior into **project-level economic performance**.

#### 12.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Investment | CAPEX, augmentation, replacement |
| Operating economics | O&M, costs |
| Revenue | Market + BTM savings |
| Cash flow | Annual net cash flow |
| KPIs | NPV, IRR, payback |

#### 12.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operational | Dispatch results, attribution |
| **Inputs** | Degradation | Augmentation, replacement events |
| **Inputs** | Tariff | Bill outputs (BTM) |
| **Inputs** | Financial | Assumptions, financing, tax |
| **Outputs** | Revenue | Annual revenue by stream |
| **Outputs** | Cash flow | Annual net cash flow |
| **Outputs** | KPIs | NPV, IRR, payback |

#### 12.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What economic value results? | How does the battery operate? |

**Reference:** Detailed in `A.2.6-FIN-ENG-001`.

---

### 13. Component Interfaces

#### 13.1 Inter-Component Interfaces

| From | To | Main Information |
|---|---|---|
| BESS Model | Operational | Physical capabilities |
| BESS Model | Dispatch | Feasible envelope |
| BESS Model | Degradation | Physical state |
| Load & Market | Operational | External conditions |
| Load & Market | Dispatch | Signals, prices, load |
| Load & Market | Financial | Bill outputs (BTM) |
| Operational | Dispatch | Requirements |
| Operational | Degradation | Behavior declarations |
| Dispatch | Degradation | Trajectories |
| Dispatch | Tariff Engine | Net load |
| Dispatch | Financial | Attribution basis |
| Degradation | BESS | Updated SOH |
| Degradation | Dispatch | Marginal signal |
| Degradation | Financial | Physical events |
| Tariff Engine | Financial | Savings (BTM) |
| Scenario Management | All | Configuration |
| Validation | All | Validation criteria |

**Note on Dispatch → Load & Market.** Dispatch produces the operational net-load outcome used by the tariff calculation. That outcome is routed to the **Tariff Engine**, not to Load & Market.

#### 13.2 Interface Principles

| Principle | Description |
|---|---|
| **Explicit** | Every interface is declared |
| **Contract-based** | Interfaces have defined contracts |
| **Directional** | Push vs pull is explicit |
| **State, not logic** | Components exchange state, not algorithms |

---

### 14. State and Feedback Architecture

#### 14.1 State Ownership

| State | State owner | Evolution owner |
|---|---|---|
| SOC | BESS Model | Dispatch |
| SOH | BESS Model | Degradation |
| Available capacity | BESS Model | Degradation |
| Cash flow | Financial | Financial |
| Augmentation history | Degradation | Degradation |

**Rule:** BESS owns the state representation; Degradation owns the evolution law; Dispatch owns the operational trajectory.

#### 14.2 System Context Propagation

```
System Context
      │
      ▼
Load & Market Model
      │
      ▼
Context-derived signals
      │
      ▼
BESS Model · Operational Model · Dispatch Engine · Financial Engine
```

**Rule:** Domain 2 owns the External Context interface. All other components consume **context-derived signals** produced by Domain 2, not raw external context.

#### 14.3 Physical-Operational Feedback Loop

```
Dispatch
    │
    ▼
BESS Operation
    │
    ▼
Degradation
    │
    ├──► Future BESS Capability
    │
    └──► Marginal Degradation Signal
              │
              ▼
           Dispatch
```

**Rule:** The architecture preserves the declared degradation-state update frequency defined by Stage A. Current working assumption: annual SOH update.

#### 14.4 Economic Translation

```
Dispatch
    │
    ├──► Market / Service Attribution ──► Financial Engine
    │
    └──► Net Load ──► Tariff Engine ──► BTM Savings ──► Financial Engine  [BTM]
```

**Rule:** The Tariff Engine is activated for configurations where customer tariff economics are relevant. For FTM-only configurations, market revenues flow directly to the Financial Engine.

---

### 15. Component Summary Table

| # | Component | Purpose | Key Inputs | Key Outputs | Boundary |
|---|---|---|---|---|---|
| 1 | BESS Model | Physical representation | Technical params, limits, temperature | State, envelope | What the BESS can do |
| 2 | Load & Market Model | External context | Load, market, program, grid data | Context signals | What is outside the BESS |
| 3 | Tariff Engine | Bill computation | Tariff, net load | Bill with/without BESS | What the bill is |
| 4 | Operational Model | Use-case behavior | Physical, external, rules | Requirements, metrics | How each stream uses BESS |
| 5 | Dispatch Engine | Coordination | Physical, external, operational, degradation | Dispatch, attribution | How to coordinate |
| 6 | Degradation Engine | Capability evolution | Operating history, environment | SOH, marginal signal, events | How usage changes battery |
| 7 | Financial Engine | Economic translation | Operational, degradation, tariff | Revenue, cash flow, KPIs | What value results |

---

### 16. What Is Deliberately NOT Defined Here

| Not defined in B.0 | Belongs to |
|---|---|
| Class structures | Stage C |
| Physical schemas | Stage C |
| API schemas | Stage C |
| Optimization equations | Stage C |
| Cash-flow equations | Stage C |
| Storage technology | B.1, B.6 |
| Databricks execution topology | B.6 |
| Application/service decomposition | B.5 |
| Technical architecture layers | B.5, B.6 |
| Code | Stage D |

---

### 17. Architectural Sequence

```
STAGE A — ENGINEERING DEFINITION
        │
        ▼
B.0 Integrated System Architecture (this document)
        │
        ▼
B.1 Data Architecture
        │
        ▼
B.2 Model Architecture
        │
        ▼
B.3 Optimization Architecture
        │
        ▼
B.4 Financial Architecture
        │
        ▼
B.5 Software Architecture
        │
        ▼
B.6 Databricks Architecture
        │
        ▼
Stage B → Stage C Handoff
```

---

### 18. Architectural Definition

> **The BESS Operational & Financial Modeling System is an integrated computational system organized into 7 functional components (BESS Model, Load & Market Model, Tariff Engine, Operational Model, Dispatch Engine, Degradation Engine, Financial Engine) and 6 cross-cutting capabilities (Scenario Management, Configuration, Validation, Execution Control, Lineage, Observability), operating within a System Context, connected through explicit interfaces, and executing through a causal chain that preserves the physical-operational feedback loop and the economic translation to project value.**

---

### 19. Design Principle

> **Separate in responsibility, integrated in behavior.**

---

### 20. Next Steps

**B.0 status:**

| Aspect | Status |
|---|---|
| B.0 Integrated System Architecture | ✅ Draft for Baseline (v0.3.1) |
| B.1 Data Architecture | ⏭ Next |
| B.2 Model Architecture | ⏭ Pending |
| B.3 Optimization Architecture | ⏭ Pending |
| B.4 Financial Architecture | ⏭ Pending |
| B.5 Software Architecture | ⏭ Pending |
| B.6 Databricks Architecture | ⏭ Pending |
| Stage B → Stage C Handoff | ⏭ Pending |

---

**End of §3 — B.0 Integrated System Architecture (v0.3.1)**

**Status:** Draft for Baseline

**Next:** B.1 Data Architecture

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1