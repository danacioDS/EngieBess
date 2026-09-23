
---

# BESS Operational & Financial Modeling Platform

## System Strategy & Delivery Framework

**Document ID:** SYS-STR-FRM-001

**Version:** 0.8 — Baseline for Review

**Status:** System Strategy — Delivery Framework

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** BESS Operational & Financial Modeling Consultant — 12 Weeks

**Language:** English

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

**Note on co-located configurations.** The architecture does **not preclude** co-located configurations (BESS with renewable generation, AC- or DC-coupled). However, **co-location is an architecture extension, not part of the initial delivery scope**. Delivery scope is standalone unless Phase 1 clarification **B6** confirms a co-located or integrated configuration as the primary reference case.

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

### Domain 2 — Load & Market Engineering

Representation of external signals: load, load projection / forecasting, energy markets, programs, grid / regulatory, tariff engine, market adapters, and (as architecture extension) generation signals.

**Owns:** the External Context interface.

### Domain 3 — Operational Engineering

Value streams: peak shaving, DR, arbitrage, frequency regulation, voltage regulation. Operational requirements, service metrics, interaction declarations.

### Domain 4 — Dispatch & Optimization Engineering

Coordination layer. Consumes physical capability, external signals, operational requirements, **System Context signals** (generation availability, grid limits, demand, market products), and degradation feedback.

**Does not own:** the external context. Consumes context-derived signals from Domain 2.

### Domain 5 — Degradation Engineering

Dynamic state evolution: calendar aging, cycle aging, SOH, capacity fade, augmentation, replacement. Provides the feedback loop to Dispatch.

### Domain 6 — Financial Engineering

Economic translation: CAPEX, OPEX, revenue by stream, savings, costs, degradation cost, incentives, tax, discount rate, escalation, contract term, NPV, IRR, payback. Applies the realization factor to operational results.

### Domain 7 — Data & Application Engineering

Technological layer: Python, PySpark, SQL, Databricks, Databricks App, data pipelines, scenario configuration, visualization, export, audit.

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
| 1 — Design | 1–2 | Stage A + B | Requirements validation, conceptual engineering, high-level architecture, output mock |
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

### 12.1 Blocking Items (must be resolved in Weeks 1–2)

| # | Item | Why Blocking |
|---|---|---|
| B1 | **Target market(s)** | Market rules drive eligibility, dispatch logic, settlement, revenue |
| B2 | **Behind-the-meter vs. front-of-the-meter scope** | Determines which value streams and constraints apply |
| B3 | **Data availability** | Determines what can be modeled; drives ingestion design |
| B4 | **Benchmark data** | Required to define acceptance |
| B5 | **Acceptance thresholds (accuracy + runtime + usability)** | Must be concrete before the thin slice is built |
| **B6** | **Project configuration** | Standalone vs. co-located, generation type, grid constraints. Determines which System Context dimensions are relevant |

### 12.2 Defaultable Items (proceed under stated assumption if not confirmed)

| # | Item | Default assumption |
|---|---|---|
| D1 | Dispatch methodology | **LP** — Linear Programming |
| D2 | Perfect foresight vs. forecast-based | **Perfect foresight**; realization factor applied in Financial Engineering |
| D3 | Degradation feedback time scale | **Annual SOH update** with representative-period simulation |
| D4 | Voltage regulation coupling | **Fixed envelope** — no P² + Q² ≤ S² linearization initially |
| D5 | Load forecasting method | **ENGIE-provided** if available; otherwise statistical baseline |
| D6 | Short-horizon forecast vs. multi-year projection | Both modeled |
| D7 | Load forecasting home | **Domain 2 owns it conceptually**; implementation via Domain 7 |
| D8 | Financing structure | **Project IRR primary; equity IRR computed with default debt parameters, configurable by the user** |
| D9 | Tax and incentives treatment | **Pre-tax** initially; ITC / depreciation flagged as extension |
| D10 | Reporting format | **Both PDF and Excel** |
| D11 | Scenario granularity | **3–5 core scenarios** initially, expandable |
| D12 | Audit / lineage / traceability scope | **Basic execution logs + data lineage** |
| D13 | Market adapter scope | **One adapter at delivery**, architecture supports more |
| D14 | Time resolution and simulation horizon | **15-minute when input data permits; hourly otherwise**. 15-year contract term |
| D15 | Databricks workspace access and environment ownership | **ENGIE-owned workspace**; consultant granted developer access |
| D16 | BESS sizing vs. evaluation | **Evaluation** of a predefined configuration |
| D17 | Primary model purpose / use case | **Evaluation** (project development support) |
| D18 | Model output granularity | **All levels** (interval schedules, daily / monthly metrics, annual KPIs) |
| D19 | Representative-period scheme | **Monthly representative periods, respecting the billing period.** If demand ratchets apply, all 12 months of the year are simulated — representative-period reduction is not permitted where ratchets are present |
| D20 | Initial implementation configuration assumption | **Standalone BESS** unless Phase 1 (B6) confirms a co-located or integrated configuration as the primary reference case. This is an **implementation assumption**, not a conceptual limitation — the architecture does not preclude co-located configurations |

### 12.3 Rationale

The two-tier structure allows the project to proceed even if ENGIE is slow to answer. Blocking items genuinely prevent design. Defaultable items have defensible working assumptions revisable at Stage B.

**B6** determines which System Context dimensions are relevant. Without knowing whether the first project is standalone or co-located, the platform cannot determine which interfaces must be developed first.

**D19** is retained in the Strategy because the ratchet exception depends on the client tariff, and it is material for ENGIE's acceptance review. It will be removed from `A.2.4 §28.3` when that document is updated, since it is a technical consultant decision, not a client clarification.

**D20** is an implementation assumption, not a conceptual limitation.

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

The platform will connect system context, data, forecast, physics, dispatch, degradation, revenue, and finance into a single auditable chain, delivering the analytical robustness ENGIE requires for business development and project evaluation — and it will be extensible to new markets, value streams, and system configurations without re-architecture.

---

## 14. ENGIE Clarification Requests Relevant to System Strategy

The following clarification items are relevant to the System Strategy. They are tracked in the **Phase 1 Clarification & Data Request Register**, which is the authoritative consolidated list. This section lists only the items relevant to the Strategy, by their **Register ID**.

| Register ID | Clarification / Data Request | Why Required |
|---|---|---|
| [TBD] | **Target market(s).** Which electricity markets, tariff structures, and ancillary-service products are within the initial delivery scope? Are PJM RegD, ERCOT FFR, DA/RT LMP, capacity, and DR intended as mandatory use cases or illustrative examples? | Determines market rules, eligibility, dispatch logic, and settlement (B1) |
| [TBD] | **BTM vs. FTM scope.** Is the initial delivery expected to support both behind-the-meter (BTM) and front-of-the-meter (FTM) configurations, or is one the priority? | Determines which value streams and constraints apply (B2) |
| [TBD] | **Project configuration.** What is the primary reference configuration: standalone BESS, co-located with renewables, BTM, FTM, AC- or DC-coupled? | Determines which System Context dimensions are relevant and which interfaces are developed first (B6) |
| [TBD] | **Data availability.** What historical data will ENGIE provide — meter data, market prices, ancillary prices, regulation signals, customer bills — and at what resolution and horizon? | Determines what can be modeled and how ingestion is designed (B3) |
| [TBD] | **Benchmark data.** What established benchmarks will be used to validate the model? Can ENGIE provide reference cases with expected results? | Defines acceptance and validation (B4) |
| [TBD] | **Acceptance thresholds.** What quantified accuracy, runtime, and usability criteria define acceptance? | Must be concrete before the thin slice is built (B5) |
| [TBD] | **Commercial perspective.** Should results be shown from ENGIE's perspective as owner or operator, from the client's perspective (savings), or both? | Affects value attribution and reporting conventions |
| [TBD] | **Co-located configurations.** Does the first project require co-located BESS with renewable generation, or is standalone BESS the primary reference case? | Determines whether the co-location architecture extension is activated in the initial delivery |
| [TBD] | **Financing structure.** What debt parameters (gearing, interest rate, tenor) should be used for equity IRR? Are default values acceptable, configurable by the user? | Determines the equity IRR calculation (D8) |
| [TBD] | **Tax, incentives, and conventions.** Should the model include tax, depreciation, and incentives such as the ITC? What currency? Nominal or real? Inflation and escalation conventions? | Determines the financial methodology (D9) |
| [TBD] | **Databricks environment.** Please confirm workspace ownership, access provisioning, Databricks Apps availability, Unity Catalog usage, and compute policies. | Determines the delivery environment (D15) |
| [TBD] | **Users and handover.** Who are the users and roles, how many, and who will maintain the tool after week 12? | Defines training audience and documentation level |
| [TBD] | **Reporting requirements.** Are there ENGIE templates or branding requirements for PDF and Excel exports? | Determines reporting design (D10) |
| [TBD] | **Point of contact and decision timing.** A single point of contact and access to subject-matter experts. Decisions on blocking items (B1–B6) by end of Week 2. | Governance |
| [TBD] | **Interim demo.** Is a working end-to-end demo around Week 4 acceptable as a scope-validation checkpoint? | Aligns with §4.2 |

**Note.** Items marked **[TBD]** will be assigned IDs when the **Phase 1 Clarification & Data Request Register** is issued as a standalone document. The Register will consolidate all clarifications across the seven domains and the Strategy, deduplicate overlaps, and provide ID, source, priority (blocking / defaultable), and status for each item.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Duration:** 12 Weeks
**Language:** English


---

**BESS Operational & Financial Modeling (RFP-264144-1): Observations and Clarification Requests**

**Scope and market**

1. **Target market.** The RFP references several market constructs (PJM RegD, ERCOT FFR, day-ahead and real-time LMP, capacity markets, TOU tariffs). *Proposal:* deliver one fully implemented market at week 12, with an architecture that allows further markets to be added without redesign. Which market should be first?
2. **Behind-the-meter vs. front-of-meter.** Peak shaving and demand response are mainly behind-the-meter use cases. Frequency and voltage regulation are mostly front-of-meter or compensated contractually. Which configurations must the tool support?
3. **Commercial perspective.** Should results be shown from ENGIE's perspective as owner or operator, from the client's perspective (savings), or both? Examples include shared-savings contracts or storage-as-a-service fees. This affects how value is split and reported.
4. **Out of scope.** We assume real-time asset control, market bidding and EMS/SCADA integration are out of scope. Please confirm.

**Data**

5. **Price projections.** Long-term price curves (LMP, ancillary services, capacity) are the largest driver of project value. We assume the tool consumes these as inputs rather than generating them. Will ENGIE provide internal price curves, or should we use a public source?
6. **Meter data and time resolution.** *Proposal:* 15-minute resolution wherever meter data and demand-charge billing are 15-minute, and hourly elsewhere. Hourly resolution understates peaks and therefore peak-shaving savings.
7. **Frequency regulation signal.** At 15-minute or hourly resolution, regulation is modeled as capacity reservation plus a statistical estimate of energy throughput and SOC impact. Is this acceptable, or can ENGIE provide historical regulation signal data?
8. **Battery data.** Are vendor degradation curves or warranty terms available for the reference technologies? These would anchor the degradation model.
9. **Load forecasting.** A short-term forecast for dispatch and a multi-year projection for the contract term need different methods. Does ENGIE already have load projections or growth assumptions we should use?

**Methodology**

10. **Dispatch method.** *Proposal:* linear programming, with mixed-integer formulations only where strictly required. This gives a good balance of optimality, transparency and runtime.
11. **Foresight assumption.** *Proposal:* perfect-foresight optimization with a configurable realization factor, for example 80–90% of theoretical arbitrage value, which is standard practice for business development valuation. Forecast-based dispatch would be an optional extension. Does this fit ENGIE's intended use?
12. **Degradation feedback.** *Proposal:* state of health is updated annually, with representative periods simulated within each year. Augmentation or replacement is triggered at a configurable threshold.
13. **Demand response.** DR events are not known in advance. *Proposal:* model them through capacity reserved for events plus event scenarios, applying the rules of the specific program. Which programs are in scope?
14. **Voltage regulation.** *Proposal:* model it as an inverter capability constraint, shown as the active-power curtailment it causes. Revenue is included only where a compensation mechanism exists.

**Financial**

15. **Equity IRR.** This requires a financing structure. *Proposal:* debt parameters (gearing, interest rate, tenor) that ENGIE can configure, with default values provided.
16. **Tax, incentives and conventions.** Should the model include tax, depreciation and incentives such as the ITC if the market is in the US? Please also confirm the currency, whether figures are nominal or real, and the inflation and escalation conventions.

**Validation and acceptance**

17. **Benchmarks.** *Proposal:* validate against NREL REopt and/or SAM for reference cases, plus ENGIE's internal models or actual project results if available.
18. **Acceptance thresholds.** *Proposal:* NPV within ±X% of the benchmark on agreed reference cases, energy balance and SOC consistency at 100%, and a full contract-term scenario run in under N minutes. The values to be agreed in week 2.

**Platform and delivery**

19. **Databricks environment.** Please confirm:
    - workspace ownership and access provisioning,
    - that Databricks Apps is enabled in the workspace and region,
    - Unity Catalog usage and compute policies.
20. **Solver licensing.** *Proposal:* an open-source solver (HiGHS) to avoid licensing dependencies. Does ENGIE hold commercial licenses (Gurobi, CPLEX) it would prefer to use?
21. **Users and handover.** Who are the users and roles, and how many? Who will maintain the tool after week 12? This defines the training audience and the level of documentation.
22. **Reporting.** Are there ENGIE templates or branding requirements for the PDF and Excel exports?

**Governance**

23. **Point of contact and decision timing.** We need a single point of contact and access to subject-matter experts. We also need decisions on the blocking items (points 1, 2, 5, 17 and 18) by the end of week 2. Items not confirmed by then will proceed under the stated proposal, documented as an assumption.
24. **Interim demo.** *Proposal:* a working end-to-end demo around week 4 (peak shaving + arbitrage + degradation + NPV in the app) to validate direction with business development users early.

---








