# BESS Operational & Financial Modeling Platform
## System Strategy & Delivery Framework

**Document ID:** SYS-STR-FRM-001

**Version:** 0.9 — Consolidated Baseline

**Status:** System Strategy — Delivery Framework — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** BESS Operational & Financial Modeling Consultant — 12 Weeks

**Language:** English

**Parent Documents:**
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.2)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.3)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v0.9)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.3)
- `A.2.6-FIN-ENG-001` — Financial Engineering (v0.2)
- `A.2.7-DATA-APP-ENG-001` — Data & Application Engineering (v0.2)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)

---

## 1. Executive Summary

ENGIE is commissioning a **BESS Operational & Financial Modeling Platform** — an analytical software solution for evaluating the operational and financial performance of Battery Energy Storage System projects across multiple value streams, market scenarios, and contract conditions.

The platform is intended to support business development and project evaluation by producing robust, auditable analytical outputs that demonstrate project performance, viability, and value to both external clients and internal stakeholders.

The solution is not a single model. It is a **system of interconnected engineering domains** — physical, market, operational, dispatch, degradation, financial, and technological — operating **within a System Context** and connected through a **causal backbone** that runs from the physical system through operational behavior to financial value. The system is delivered through a Databricks application layer.

This document defines the **System Strategy** for that platform. It establishes:

- What the system is
- What engineering domains it contains
- What **System Context** surrounds the BESS
- How those domains relate
- What the system must produce
- What principles govern its design
- What cross-cutting concerns span the domains
- How it will be delivered across the 12-week engagement

It deliberately does **not** define equations, algorithms, schemas, class structures, or implementation details. Those belong to subsequent stages.

The guiding principle of this strategy is:

> **Define before you build; build in thin, validated increments.**

### 1.1 The Three Natures of the RFP

The RFP is not a single-dimensional request. It simultaneously asks for three things, and each carries its own scope, risk, and delivery obligations:

```
                    ENGIE RFP
                       │
       ┌───────────────┼────────────────┐
       │               │                │
       ▼               ▼                ▼
   ENGINEERING      SOFTWARE          DELIVERY
       │               │                │
       │               │                ├── Documentation
       │               │                ├── Training
       │               │                └── Deployment
       │               │
       │               ├── Python
       │               ├── Databricks
       │               ├── PySpark
       │               ├── SQL
       │               └── Databricks App
       │
       ├── System Context
       ├── BESS Physics
       ├── Load Forecasting
       ├── Market Modeling
       ├── Operating Modes
       ├── Dispatch Optimization
       ├── Revenue Stacking
       ├── Degradation
       └── Financial Modeling
```

Three parallel workstreams, one contract:

| Workstream | Owner in this strategy | Where it is defined |
|---|---|---|
| **Engineering** | System Context + Domains 1–6 | Stage A (Conceptual) → Stage B (Architecture) → Stage C (Specification) |
| **Software** | Domain 7 | Stage C (Specification) → Stage D (Implementation) |
| **Delivery** | Cross-cutting (Phase 4) | Stage D (Deployment, Documentation, Training) |

Treating ENGINEERING as the whole engagement is the most common underestimation in analytical software contracts.

### 1.2 Stage A.2 Complete

As of this revision, **Stage A.2 is conceptually and formally complete**. All seven domain chapters (A.2.1–A.2.7) have been developed, consolidated, and integrated. The next step is the **Stage A Consolidation Audit**, followed by **Stage B — System Architecture (HLD)**.

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.2) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.3) |
| 3 | A.2.3 | Operational Engineering | ✅ Baselined (v1.3) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | 🔄 Development Draft (v0.9) |
| 5 | A.2.5 | Degradation Engineering | 🔄 Development Baseline (v0.3) |
| 6 | A.2.6 | Financial Engineering | 🔄 Development Draft (v0.2) |
| 7 | A.2.7 | Data & Application Engineering | 🔄 Development Draft (v0.2) |

---

## 2. Product Intent

The product is a **software platform for operational and financial evaluation of BESS projects**, contextualized by the energy system configuration of each project.

Its purpose is to answer a single class of questions:

> Given a BESS configuration, an energy system context, a client load profile, a set of market rules, and a set of financial assumptions, what is the operational and financial performance of the project under different scenarios?

To answer that question, the platform must connect, in a coherent and auditable chain:

```
System Context → Data → Forecast → Physical BESS Model
  → Operational Modes → Dispatch (with Revenue Stacking)
  → Degradation → Financial Model → Scenarios → Results
```

This chain is the backbone of the entire solution. Revenue stacking is part of **Dispatch**, not a separate stage after Degradation.

---

## 3. System Boundary

### 3.1 In Scope

- BESS technical and operational modeling
- Load ingestion **and load forecasting / projection**
- Market and revenue stream modeling
- Dispatch optimization and revenue stacking
- Battery degradation modeling (calendar + cycle aging, feedback loop)
- Financial performance calculation (NPV, IRR, payback, revenue by stream)
- Scenario configuration, comparison, and evaluation
- Interactive dashboards and exportable reporting
- Data ingestion, validation, transformation, and processing
- Validation against established benchmarks (domain, model, system, UAT)
- Documentation, training, and handover

**Note on co-located configurations.** The architecture does **not preclude** co-located configurations (BESS with renewable generation, AC- or DC-coupled). However, **co-location is an architecture extension, not part of the initial delivery scope**. Delivery scope is standalone unless Phase 1 clarification **PH-004** confirms a co-located or integrated configuration as the primary reference case.

### 3.2 Out of Scope (to be confirmed in Phase 1)

- Real-time operational control of physical assets
- SCADA or EMS integration
- Trading execution or market bidding submission
- Procurement or hardware selection
- Grid interconnection studies

### 3.3 Market Scope Ambiguity — Phase 1 Clarification Required

The RFP references multiple market constructs without specifying a single target market. Market rules drive eligibility, dispatch logic, settlement, and revenue calculation. The architecture must therefore separate:

- A **generic BESS engine** (physics, degradation, dispatch)
- **Market-specific adapter modules**

### 3.4 System Context

The BESS does not operate in isolation. It operates within a **System Context** that determines what the BESS can do and what it is worth.

The System Context has **two components**:

**External Context** — what surrounds the BESS:

| Dimension | What it declares |
|---|---|
| **Generation** | Renewable generation profiles, curtailment, intermittency *(architecture extension — see §3.1)* |
| **Grid / Network** | Connection topology, import/export limits, interconnection capacity, congestion |
| **Load / Demand** | Physical demand profiles, seasonality, growth, electrification |
| **Market** | Which markets exist, which products are available, participation rules |

**Project Configuration** — the project's own topology and coupling:

| Aspect | What it declares |
|---|---|
| **BESS Configuration** | Standalone, co-located, BTM, FTM, integrated with renewables |
| **Topology** | Electrical and thermal coupling between BESS, generation, load, and grid |
| **Coupling** | AC-coupled, DC-coupled, hybrid |

The separation matters:

- **External Context** is what exists around the project.
- **Project Configuration** is what the project is.

### 3.5 Ownership of the System Context

> **The External Context is owned by Domain 2 (Load & Market Engineering), as the domain that represents external signals, tariffs, market mechanisms and constraints as consumable inputs. Project Configuration is a scenario parameter, owned by Scenario Management.**

This means:

- **Domain 2** remains the owner of the External Context interface — Generation, Grid, Load, and Market signals are produced by Domain 2 for consumption by the other domains.
- **Project Configuration** is not owned by any domain. It is a **scenario parameter** that determines which External Context dimensions are active and which interfaces are relevant. It is managed by Scenario Management (§8.1).

The System Context is a **framing concept**, not an eighth domain, and it does not change the ownership of any existing domain.

### 3.6 System Context Dimensions Are Not Engineering Domains

> **System-context dimensions are not engineering domains. They are external and configurational dimensions whose effects are propagated into the relevant engineering domains through explicit interfaces.**

This distinction matters:

- The **System Context** declares what exists around the BESS.
- The **seven engineering domains** declare how those external factors affect different aspects of the system.
- A single system-context dimension (e.g. Generation) affects **multiple domains** — not just one.

**Example — Generation affects:**

| Domain | How Generation affects it |
|---|---|
| **1 — BESS Engineering** | Available external charging power, coupling limits, interconnection constraints — **but not the battery's intrinsic physical capability** |
| **2 — Load & Market Engineering** | Representation of generation profiles as net-load signals |
| **3 — Operational Engineering** | Whether "solar surplus → charge → avoid curtailment" is a viable use case |
| **4 — Dispatch** | A primary input to the optimization: what generation is available at each moment |
| **5 — Degradation** | Indirectly — via the charging behavior it induces |
| **6 — Financial** | Energy shifted, curtailment avoided, revenue and savings |

**Critical distinction.** System Context affects **availability and constraints imposed by the environment**, not the **intrinsic physical capability** of the BESS. A 100 MW / 200 MWh battery remains 100 MW / 200 MWh even if only 40 MW of generation are available to charge it at a given moment.

---

## 4. Delivery Philosophy — Design-Led, Iteratively Delivered

The engagement follows a **four-stage engineering progression**.

| Stage | Name | Engineering Equivalent | Purpose |
|---|---|---|---|
| **A** | Engineering Definition | Conceptual Engineering | Define what the system must calculate and under what rules |
| **B** | System Architecture | Basic Engineering | Define how the engineering model is represented computationally |
| **C** | Product Specification | Detailed Engineering | Consolidate requirements, models, architecture, interfaces, validation |
| **D** | Implementation | Construction & Commissioning | Build, test, validate, deploy |

The sequence is deliberate, but **the gates between stages are lightweight**, and Stage D begins in **parallel** with Stage C.

### 4.1 Stage Progression with a Thin Vertical Slice

```
SYSTEM STRATEGY
       │
       ▼
STAGE A — ENGINEERING DEFINITION
(Conceptual Engineering)
       │
       ├── A.1  System Component Definition
       │         └── Seven Engineering Domains
       │
       └── A.2  Conceptual Engineering per Domain
                ├── A.2.1  BESS Engineering
                ├── A.2.2  Load & Market Engineering
                ├── A.2.3  Operational Engineering
                ├── A.2.4  Dispatch & Optimization Engineering
                ├── A.2.5  Degradation Engineering
                ├── A.2.6  Financial Engineering
                └── A.2.7  Data & Application Engineering
       │
       ▼
STAGE A CONSOLIDATION AUDIT
       │
       ▼
STAGE B — SYSTEM ARCHITECTURE
       │
       ├── High-Level Design (HLD)
       └── Basic Architecture Definition
       │
       ▼
STAGE C — PRODUCT SPECIFICATION  ────┐
       │                            │  Stage C and Stage D run in parallel
       │                            │  from week 3
       ▼                            │
STAGE D — IMPLEMENTATION            │
       │                            │
       ├── Thin slice demo (~week 4)│
       ├── Progressive deepening    │
       ├── Python / PySpark / SQL   │
       ├── Databricks App           │
       ├── Tests                    │
       ├── UAT                      │
       └── Deployment & Training    │
```

### 4.2 Thin End-to-End Slice — Internal and Demo

By approximately **week 4**, the platform must demonstrate a **thin end-to-end slice**:

- **Peak shaving** + **energy arbitrage** (two value streams)
- A **simple degradation update** applied between periods
- **NPV** displayed on a basic Databricks App page
- Data flowing through ingestion → dispatch → degradation → financial → app

The slice serves **two purposes**:

1. **Internal de-risking** — proving that data ingestion, dispatch runtime, the degradation feedback loop, and the Databricks App render work end-to-end
2. **Client demo** — validating scope, expectations, and usability with ENGIE's business development users

### 4.3 Consolidated Stage A.2

The seven A.2 documents **may be delivered as one consolidated document with seven chapters** rather than seven standalone files.

### 4.4 Lightweight Gates

- Stage A.2 review is **per-chapter**, not per-document
- Stage B review is a **single consolidated review**
- Stage C review is a **single review**
- Stage D acceptance is **continuous**, culminating in UAT

---

## 5. The Seven Engineering Domains

The seven domains operate **within the System Context** declared in §3.4.

| # | Domain | Primary Question |
|---|---|---|
| 1 | **BESS Engineering** | What physical system are we modeling? |
| 2 | **Load & Market Engineering** | What external signals, tariffs, market mechanisms and constraints affect the system? |
| 3 | **Operational Engineering** | How do those conditions translate into feasible use cases? |
| 4 | **Dispatch & Optimization** | How are physical, operational and economic objectives coordinated? |
| 5 | **Degradation Engineering** | How does operation change future BESS capability? |
| 6 | **Financial Engineering** | What economic value results from the modeled system? |
| 7 | **Data & Application Engineering** | How is the integrated model executed and consumed? |

**Note on Domain 2.** Domain 2 **is** the owner of the External Context interface. It represents external signals, tariffs, market mechanisms and constraints as consumable inputs. Other domains consume those signals.

### Domain 1 — BESS Engineering

Physical system: battery, capacity, power, SOC, SOH, efficiency, C-rate, ramp, limits, thermal, degradation interface, augmentation, replacement.

**Boundary:** BESS Engineering declares **intrinsic capability**. System Context declares **availability and imposed constraints**. These are separate.

**Reference:** `A.2.1-BESS-ENG-001` v1.2.

### Domain 2 — Load & Market Engineering

Representation of external signals: load, load projection / forecasting, energy markets, programs, grid / regulatory, tariff engine, market adapters, and (as architecture extension) generation signals.

**Owns:** the External Context interface.

**Reference:** `A.2.2-LOAD-MKT-ENG-001` v1.3.

### Domain 3 — Operational Engineering

Value streams: peak shaving, DR, arbitrage, frequency regulation, voltage regulation. **Operational requirements** (per `A.2.3` §4), service metrics, interaction declarations.

**Note.** Operational Engineering defines **operational requirements** — what behavior must occur if the service is provided. Dispatch decides which value streams to activate, when, and how.

**Reference:** `A.2.3-OPS-ENG-001` v1.3.

### Domain 4 — Dispatch & Optimization Engineering

Coordination layer. Consumes physical capability, external signals, operational requirements, **System Context signals** (generation availability, grid limits, demand, market products), and degradation feedback.

**Does not own:** the external context. Consumes context-derived signals from Domain 2. Produces **battery power and SOC trajectories**; **cycling metrics are derived by Domain 5**.

**Reference:** `A.2.4-DISPATCH-ENG-001` v0.9.

### Domain 5 — Degradation Engineering

Dynamic state evolution: calendar aging, cycle aging, SOH, capacity fade, augmentation, replacement. Provides the feedback loop to Dispatch.

**The three concepts that must not collapse:**
- **Physical degradation** — state (Domain 5)
- **Marginal degradation cost** — operational signal (Domain 5)
- **Replacement cash flow** — monetary flow (Domain 6)

**Reference:** `A.2.5-DEG-ENG-001` v0.3.

### Domain 6 — Financial Engineering

Economic translation: CAPEX, OPEX, revenue by stream, savings, costs, degradation events, incentives, tax, discount rate, escalation, contract term, NPV, IRR, payback. Applies the realization factor to operational results.

**Two sources of truth for value:**
- **Behind-the-meter savings** — Domain 2 (tariff engine)
- **Market revenues** — Domain 4 (attribution) + market adapters (settlement)

**Reference:** `A.2.6-FIN-ENG-001` v0.2.

### Domain 7 — Data & Application Engineering

Technological layer: Python, PySpark, SQL, Databricks, Databricks App, data pipelines, scenario configuration, visualization, export, execution and lineage records.

**Reference:** `A.2.7-DATA-APP-ENG-001` v0.2.

---

## 6. System Architecture

### 6.1 Architecture Layers

| Layer | Description | Primary Engineering Domains |
|---|---|---|
| **Context** | System Context: external context + project configuration | Domain 2 (external) + Scenario Management (configuration) |
| **Data Architecture** | Ingestion, validation, transformation, schemas, data quality | Domain 7 |
| **Model Architecture** | BESS physics, load, degradation as computational objects and state | Domains 1, 2, 5 |
| **Optimization Architecture** | Dispatch logic, revenue stacking, constraint handling | Domains 3, 4 |
| **Financial Architecture** | Cash flow, NPV, IRR, scenario valuation, realization factor | Domain 6 |
| **Software Architecture** | Python engine, Databricks App, PySpark, SQL, APIs | Domain 7 |
| **Databricks Architecture** | App layer, processing layer, storage layer, orchestration | Domain 7 |

### 6.2 Causal Backbone with Context Propagation

```
                        SYSTEM CONTEXT
     ┌──────────┬──────────┬──────────┬──────────────┐
     │Generation│   Grid   │   Load   │    Market    │
     └────┬─────┴────┬─────┴────┬─────┴──────┬───────┘
          │          │          │            │
          └──────────┴──────────┴────────────┘
                              │
                              ▼
                    ENGINEERING DOMAINS
                              │
             ┌────────────────┼────────────────┐
             ▼                ▼                ▼
        Physical         Operational       Economic
         System            Behavior         Signals
             │                │                │
             └────────────────┼────────────────┘
                              ▼
                       DISPATCH DECISION
                              │
                              ▼
                         BESS STATE
                              │
                              ▼
                         DEGRADATION
                              │
                              ├──────────► future capability
                              │
                              ▼
                         FINANCIAL VALUE
```

The diagram shows the System Context propagating into the three functional groupings of the seven domains (physical, operational, economic), converging at Dispatch.

### 6.3 Architectural Principles

**Causal chain.** The architecture must preserve the causal chain, which is **not** a simple linear sequence. System Context and the BESS physical system are **parallel inputs** to operational behavior:

```
System Context
(Generation / Grid / Load / Market)
                    │
                    ▼
       External Signals (via Domain 2)
                    │
                    ├──────────────┐
                    │              │
                    ▼              ▼
             Operational      BESS Physical
              Conditions        Capability
                    │              │
                    └──────┬───────┘
                           ▼
                    Dispatch Decision
                           │
                           ▼
                    BESS Operation
                           │
                           ▼
                      Degradation
                           │
                    ┌──────┴──────┐
                    ▼             ▼
             Future Capability   Financial Value
```

**Context → Impact → Domain → Decision → Value.** Every system-context dimension must be traceable through this chain:

```
        System Context
              │
              ▼
        Impact analysis
              │
              ▼
        Relevant domain
              │
              ▼
        Dispatch decision
              │
              ▼
        Project value
```

**Other principles:**

- The generic BESS engine must be separable from market/program-specific adapters
- Degradation must be modeled as a dynamic state, not a post-processing cost
- The financial model must consume operational outputs, never replace them
- Validation must be defined before results are produced
- Scenario Management and Validation are **cross-cutting capabilities**
- **System-context dimensions are not engineering domains** — they propagate into the domains through explicit interfaces
- **Operational requirements** (per `A.2.3` §4) are what Operational Engineering declares; Dispatch selects the actual behavior
- **Cycling metrics** are derived by Degradation from Dispatch's power and SOC trajectories; Dispatch does not produce them

### 6.4 Operational Signals vs. Investment Assumptions

| Category | Examples | May influence dispatch? |
|---|---|---|
| **Operational signals** | Market prices, TOU tariffs, DR program payments, marginal degradation cost, reserve prices | **Yes** |
| **Investment assumptions** | Discount rate, CAPEX, financing structure, tax treatment, contract term | **No** |

**Investment assumptions may enter dispatch only through explicitly derived, documented operational signals.**

The **realization factor** is applied in **Financial Engineering**, not in Dispatch.

### 6.5 Dispatch Consumes System Context but Does Not Own It

**Dispatch does not own Generation, Grid, Load, or Market.** It consumes **context-derived signals and constraints** produced by Domain 2:

| System Context dimension | Dispatch receives | Produced by |
|---|---|---|
| **Generation** | Available generation signals, charge opportunity, curtailment conditions | Domain 2 (context interface) |
| **Grid / Network** | Import / export limits, interconnection capacity | Domain 2 (context interface) |
| **Load / Demand** | Net load profile, peak / energy requirements | Domain 2 (context interface) |
| **Market** | Eligible products, market prices, participation rules | Domain 2 (via adapters) |

**Project Configuration** is provided by Scenario Management, not by a domain.

**Rule:** Dispatch consumes context through explicit interfaces. It is not the owner of the external context. Domain 2 remains the owner of the External Context interface.

---

## 7. Two Simultaneous Cycles

### 7.1 Physical-Operational Cycle

Represents the **real-world behavior of the battery system over time**. Time-dependent, stateful, constraint-driven, subject to the degradation feedback loop. Domains involved: 1, 2, 3, 4, 5.

### 7.2 Economic-Financial Cycle

Represents the **economic consequence of the physical-operational cycle**. Derived from operational outputs, aggregated over the contract term, discounted and escalated. Domain 6, supported by outputs from Domains 1–5.

### 7.3 Coupling Between Cycles

The two cycles are **coupled**: physical-operational runs first within each period; economic-financial consumes the outputs; degradation feeds back; financial results inform scenario comparison.

### 7.4 Why This Separation Matters

Collapsing the two cycles leads to investment assumptions driving operational behavior, loss of auditability, and difficulty validating against benchmarks. The separation preserves traceability.

---

## 8. Cross-Cutting Capabilities

### 8.1 Scenario Management

Parameterizes and orchestrates the domains. **Project Configuration is a scenario parameter** — it determines which External Context dimensions are active and which interfaces are relevant.

### 8.2 Validation

Four levels: domain, model, system, UAT. Validation must be defined **before** results are produced.

### 8.3 Output Mock — Anchoring Acceptance

KPI list + dashboard wireframe, prepared during Phase 1 and refined continuously.

---

## 9. System Strategy — Scope Definition

### 9.1 What This Strategy Defines

- System boundary
- System purpose
- The three natures of the RFP
- **System Context (§3.4–3.6)**
- Major engineering domains
- Cross-cutting capabilities
- Operational signals vs. investment assumptions
- **Dispatch boundary with respect to System Context (§6.5)**
- Delivery philosophy
- Validation philosophy
- Technology strategy (§9.3)
- Evolution strategy (§9.4)

### 9.2 What This Strategy Does Not Define

- Python classes, concrete data tables, APIs
- Detailed mathematical algorithms, equations, schemas
- Notebooks, functions, SQL
- PySpark implementation, MILP formulations
- Databricks deployment details

### 9.3 Technology Strategy

| Technology | Role | Where it does **not** belong |
|---|---|---|
| **Python** | Modeling engine | — |
| **PySpark** | Parallelization across **scenarios**, **representative periods within a year**, **sensitivity analyses**; large-scale data transformation | Sequential state evolution |
| **SQL** | Data ingestion, validation, transformation, querying, result storage | Modeling logic |
| **Databricks** | Execution environment, orchestration, storage, app hosting | Model definition |
| **Databricks App** | User interface | Modeling logic |

**PySpark scope.** Project years and rolling-horizon windows are sequential by construction. PySpark parallelizes scenarios, representative periods within a year (when SOH is fixed), and sensitivity analyses. A single dispatch optimization is single-node Python.

### 9.4 Evolution Strategy

1. **Market coverage** — new markets via new adapters
2. **Value stream coverage** — new streams via new operational modes
3. **System-context coverage** — new generation, grid, or load configurations via configuration extensions, not via new domains
4. **Co-located configurations** — architecture extension, not initial delivery scope (§3.1)
5. **Analytical depth** — deeper fidelity without restructuring

---

## 10. Engagement Timeline

| Phase | Weeks | Delivery Stage | Focus |
|---|---|---|---|
| 1 — Design | 1–2 | Stage A + B | Requirements validation, conceptual engineering, high-level architecture, output mock. **Stage A.2 complete by end of Week 2** |
| 2 — Development | 3–9 | Stage C + D (parallel) | Thin end-to-end slice by ~week 4, then progressive deepening |
| 3 — Testing | 10–11 | Stage D | Model validation, UAT |
| 4 — Deployment | 12 | Stage D | Final delivery, deployment, documentation, training |

---

## 11. Governance & Communication

- Regular status meetings
- Periodic progress reporting
- Review sessions at key milestones
- Structured issue tracking and resolution
- Formal sign-off at end of each stage (with lightweight-gate framing)

---

## 12. Phase 1 Clarification Items

The Phase 1 clarification items are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1), the authoritative consolidated source. The items formerly listed as B1–B6 (blocking) and D1–D20 (defaultable) in this Strategy are mapped to their Register IDs below.

### 12.1 Blocking Items (must be resolved in Weeks 1–2)

| Register ID | Former ID | Item | Why Blocking |
|---|---|---|---|
| **PH-001** | B1 | **Target market(s)** | Market rules drive eligibility, dispatch logic, settlement, revenue |
| **PH-002** | B2 | **Behind-the-meter vs. front-of-the-meter scope** | Determines which value streams and constraints apply |
| **PH-003** | B3 | **Data availability** | Determines what can be modeled; drives ingestion design |
| **PH-005** | B4 | **Benchmark data** | Required to define acceptance |
| **PH-006** | B5 | **Acceptance thresholds (accuracy + runtime + usability)** | Must be concrete before the thin slice is built |
| **PH-004** | B6 | **Project configuration** | Standalone vs. co-located, generation type, grid constraints. Determines which System Context dimensions are relevant |

### 12.2 Defaultable Items (proceed under stated assumption if not confirmed)

| Register ID | Former ID | Item | Default assumption |
|---|---|---|---|
| **PH-034** | D1 | Dispatch methodology | **LP** — Linear Programming |
| **PH-033** | D2 | Perfect foresight vs. forecast-based | **Perfect foresight**; realization factor applied in Financial Engineering |
| **PH-036** | D3 | Degradation feedback time scale | **Annual SOH update** with representative-period simulation |
| **PH-041** | D4 | Voltage regulation coupling | **Fixed envelope** — no P² + Q² ≤ S² linearization initially |
| **PH-050** | D5 | Load forecasting method | **ENGIE-provided** if available; otherwise statistical baseline |
| **PH-051** | D6 | Short-horizon forecast vs. multi-year projection | Both modeled |
| **PH-052** | D7 | Load forecasting home | **Domain 2 owns it conceptually**; implementation via Domain 7 |
| **PH-042** | D8 | Financing structure | **Project IRR primary; equity IRR computed with default debt parameters, configurable by the user** |
| **PH-043** | D9 | Tax and incentives treatment | **Pre-tax** initially; ITC / depreciation flagged as extension |
| **PH-047** | D10 | Reporting format | **Both PDF and Excel** |
| **PH-053** | D11 | Scenario granularity | **3–5 core scenarios** initially, expandable |
| **PH-048** | D12 | Audit / lineage / traceability scope | **Basic execution logs + data lineage** |
| **PH-054** | D13 | Market adapter scope | **One adapter at delivery**, architecture supports more |
| **PH-055** | D14 | Time resolution and simulation horizon | **15-minute when input data permits; hourly otherwise**. 15-year contract term |
| **PH-046** | D15 | Databricks workspace access and environment ownership | **ENGIE-owned workspace**; consultant granted developer access |
| **PH-026** | D16 | BESS sizing vs. evaluation | **Evaluation** of a predefined configuration |
| **PH-027** | D17 | Primary model purpose / use case | **Evaluation** (project development support) |
| **PH-028** | D18 | Model output granularity | **All levels** (interval schedules, daily / monthly metrics, annual KPIs) |
| **PH-040** | D19 | Representative-period scheme | **Monthly representative periods, respecting the billing period.** If demand ratchets apply, all 12 months of the year are simulated — representative-period reduction is not permitted where ratchets are present |
| **PH-004** | D20 | Initial implementation configuration assumption | **Standalone BESS** unless **PH-004** confirms a co-located or integrated configuration as the primary reference case. This is an **implementation assumption**, not a conceptual limitation — the architecture does not preclude co-located configurations |

### 12.3 Rationale

The two-tier structure allows the project to proceed even if ENGIE is slow to answer. Blocking items genuinely prevent design. Defaultable items have defensible working assumptions revisable at Stage B.

**PH-004** determines which System Context dimensions are relevant. Without knowing whether the first project is standalone or co-located, the platform cannot determine which interfaces must be developed first.

**PH-040** is retained in the Strategy because the ratchet exception depends on the client tariff, and it is material for ENGIE's acceptance review.

**PH-004** (as D20) is an implementation assumption, not a conceptual limitation.

**Note.** The former reference to `A.2.4 §28.3` has been resolved. A.2.4 v0.9 §28.3 no longer includes D19; the representative-period scheme is now declared as a technical consultant decision in `A.2.4` §26 and §28.3.

---

## 13. Conclusion

This System Strategy establishes a disciplined, domain-driven approach to the ENGIE BESS Operational & Financial Modeling Platform engagement.

The system is organized into **seven engineering domains**, operating **within a System Context** — composed of **External Context** (generation, grid, load, market) and **Project Configuration** (BESS configuration, topology, coupling).

**Ownership is explicit:**
- **Domain 2** owns the External Context interface.
- **Project Configuration** is a scenario parameter, managed by Scenario Management.

The **context → impact → domain → decision → value** chain is the central principle that connects the System Context to the causal backbone.

**Dispatch consumes System Context but does not own it** (§6.5). It receives context-derived signals from Domain 2.

Two simultaneous cycles — physical-operational and economic-financial — are preserved as distinct but coupled. Two **cross-cutting capabilities** — Scenario Management and Validation — span the domains.

The engagement is understood as **three parallel natures** — Engineering, Software, and Delivery. Delivery is **design-led and iteratively delivered**: a thin end-to-end slice exists by approximately week 4. Stage C and Stage D run in parallel from week 3. Stage gates are lightweight.

**Stage A.2 is conceptually and formally complete.** All seven domain chapters (A.2.1–A.2.7) have been developed, consolidated, and integrated. The next step is the **Stage A Consolidation Audit**, followed by **Stage B — System Architecture (HLD)**.

The platform will connect system context, data, forecast, physics, dispatch, degradation, revenue, and finance into a single auditable chain, delivering the analytical robustness ENGIE requires for business development and project evaluation — and it will be extensible to new markets, value streams, and system configurations without re-architecture.

---

## 14. ENGIE Clarification Requests Relevant to System Strategy

The following clarification items are relevant to the System Strategy. They are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1), which is the authoritative consolidated list. This section lists only the items relevant to the Strategy, by their **Register ID**.

| Register ID | Clarification / Data Request | Why Required |
|---|---|---|
| **PH-001** | **Target market(s).** Which electricity markets, tariff structures, and ancillary-service products are within the initial delivery scope? Are PJM RegD, ERCOT FFR, DA/RT LMP, capacity, and DR intended as mandatory use cases or illustrative examples? | Determines market rules, eligibility, dispatch logic, and settlement |
| **PH-002** | **BTM vs. FTM scope.** Is the initial delivery expected to support both behind-the-meter (BTM) and front-of-the-meter (FTM) configurations, or is one the priority? | Determines which value streams and constraints apply |
| **PH-004** | **Project configuration.** What is the primary reference configuration: standalone BESS, co-located with renewables, BTM, FTM, AC- or DC-coupled? | Determines which System Context dimensions are relevant and which interfaces are developed first |
| **PH-003** | **Data availability.** What historical data will ENGIE provide — meter data, market prices, ancillary prices, regulation signals, customer bills — and at what resolution and horizon? | Determines what can be modeled and how ingestion is designed |
| **PH-005** | **Benchmark data.** What established benchmarks will be used to validate the model? Can ENGIE provide reference cases with expected results? | Defines acceptance and validation |
| **PH-006** | **Acceptance thresholds.** What quantified accuracy, runtime, and usability criteria define acceptance? | Must be concrete before the thin slice is built |
| **PH-007** | **Commercial perspective.** Should results be shown from ENGIE's perspective as owner or operator, from the client's perspective (savings), or both? | Affects value attribution and reporting conventions |
| **PH-042** | **Financing structure.** What debt parameters (gearing, interest rate, tenor) should be used for equity IRR? Are default values acceptable, configurable by the user? | Determines the equity IRR calculation |
| **PH-043** | **Tax, incentives, and conventions.** Should the model include tax, depreciation, and incentives such as the ITC? What currency? Nominal or real? Inflation and escalation conventions? | Determines the financial methodology |
| **PH-046** | **Databricks environment.** Please confirm workspace ownership, access provisioning, Databricks Apps availability, Unity Catalog usage, and compute policies. | Determines the delivery environment |
| **PH-012** | **Users and handover.** Who are the users and roles, how many, and who will maintain the tool after week 12? | Defines training audience and documentation level |
| **PH-047** | **Reporting requirements.** Are there ENGIE templates or branding requirements for PDF and Excel exports? | Determines reporting design |
| **PH-006** | **Point of contact and decision timing.** A single point of contact and access to subject-matter experts. Decisions on blocking items (PH-001 to PH-006) by end of Week 2. | Governance |
| **PH-033** | **Interim demo.** Is a working end-to-end demo around Week 4 acceptable as a scope-validation checkpoint? | Aligns with §4.2 |

**Note.** Items are assigned IDs in `PH1-REG-001` v1.1. The Register is the authoritative source; this section is a filtered view.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Duration:** 12 Weeks
**Language:** English

---

## Addendum A: Consolidated Register Cross-Reference

The following table consolidates all Phase 1 clarification items across the seven domains and the Strategy, by Register ID. The authoritative source is `PH1-REG-001` v1.1.

| Register ID | Topic | Primary domain | Strategy mapping |
|---|---|---|---|
| **PH-001** | Target market(s) | Strategy, Domain 2 | B1 |
| **PH-002** | BTM vs. FTM scope | Strategy, Domain 2 | B2 |
| **PH-003** | Data availability | Domain 1, Domain 2 | B3 |
| **PH-004** | Project configuration | Strategy, Domain 5 | B6 / D20 |
| **PH-005** | Benchmark data | Domain 6, Domain 7 | B4 |
| **PH-006** | Acceptance thresholds | Strategy, all domains | B5 |
| **PH-007** | Commercial perspective | Domain 6 | — |
| **PH-012** | Users and handover | Domain 7 | — |
| **PH-015** | Battery data | Domain 1, Domain 5 | — |
| **PH-016** | SOC bounds and warranty | Domain 1, Domain 5 | — |
| **PH-017** | SOC window behavior under degradation | Domain 1, Domain 5 | — |
| **PH-018** | Multi-cohort aggregation | Domain 5 | — |
| **PH-021** | Power factor penalties / kVAR charges | Domain 2, Domain 3 | — |
| **PH-026** | BESS sizing vs. evaluation | Domain 4 | D16 |
| **PH-027** | Primary model purpose | Domain 4 | D17 |
| **PH-028** | Model output granularity | Domain 4 | D18 |
| **PH-032** | Financial objective inside dispatch | Domain 5 | — |
| **PH-033** | Perfect foresight vs. forecast-based dispatch | Domain 4 | D2 |
| **PH-034** | Dispatch methodology | Domain 4 | D1 |
| **PH-035** | Realization factor | Domain 6 | — |
| **PH-036** | Degradation feedback time scale | Domain 5 | D3 |
| **PH-038** | Degradation feedback time scale (confirmatory) | Domain 5 | — |
| **PH-040** | Representative-period scheme and ratchets | Domain 4 | D19 |
| **PH-041** | Voltage regulation coupling | Domain 3, Domain 4 | D4 |
| **PH-042** | Financing structure | Domain 6 | D8 |
| **PH-043** | Degradation model fidelity / tax treatment | Domain 5, Domain 6 | D9 |
| **PH-044** | Augmentation policy | Domain 5 | — |
| **PH-045** | Replacement policy | Domain 5 | — |
| **PH-046** | Databricks environment | Domain 7 | D15 |
| **PH-047** | Reporting requirements | Domain 7 | D10 |
| **PH-048** | Audit / lineage / traceability scope | Domain 7 | D12 |
| **PH-050** | Load forecasting method | Domain 2 | D5 |
| **PH-051** | Load forecasting home | Domain 2 | D7 |
| **PH-052** | Scenario granularity | Domain 2 | D11 |
| **PH-053** | Market adapter scope | Domain 2 | D13 |
| **PH-054** | Time resolution | Domain 2 | D14 |
| **PH-055** | Presentation of value (BTM mapping convention) | Domain 3, Domain 6 | — |

**Note.** The mapping "Former ID → Register ID" is the authoritative cross-reference for the transition from the Strategy's B/D numbering to the Register's PH numbering. Where a former ID does not appear, the Register item was introduced after the Strategy's B/D list was frozen.

---

## Addendum B: Stage A Consolidation Status

Stage A.2 is conceptually and formally complete. The Stage A Consolidation Audit will verify:

- All PH IDs across the seven A.2.x documents are consistent
- All cross-references between documents are correct
- All interfaces are coherent
- All versions are aligned
- All parent document citations are correct

**Audit output:** `Stage A Consolidation Report` (to be produced).

**After audit:** Stage B — System Architecture (HLD).

---








