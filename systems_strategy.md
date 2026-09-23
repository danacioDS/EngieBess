Aquí tienes **SYS-STR-FRM-001 v0.5 — Development Draft**, con los cinco puntos integrados. Los cambios son quirúrgicos: §9.3 corregida técnicamente, §6.4 reconoce la fuga de investment assumptions, §4 eleva el thin slice a demo con ENGIE, §12 reestructurada con bloqueantes y defaults, y el principio rector reformulado.

---

# BESS Operational & Financial Modeling Platform

## System Strategy & Delivery Framework

**Document ID:** SYS-STR-FRM-001

**Version:** 0.5 — Baseline for Review

**Status:** System Strategy — Delivery Framework

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** BESS Operational & Financial Modeling Consultant — 12 Weeks

**Language:** English

---

## 1. Executive Summary

ENGIE is commissioning a **BESS Operational & Financial Modeling Platform** — an analytical software solution for evaluating the operational and financial performance of Battery Energy Storage System projects across multiple value streams, market scenarios, and contract conditions.

The platform is intended to support business development and project evaluation by producing robust, auditable analytical outputs that demonstrate project performance, viability, and value to both external clients and internal stakeholders.

The solution is not a single model. It is a **system of interconnected engineering domains** — physical, market, operational, dispatch, degradation, financial, and technological — connected through a **causal backbone** that runs from the physical system through operational behavior to financial value. The system is delivered through a Databricks application layer.

This document defines the **System Strategy** for that platform. It establishes:

- What the system is
- What engineering domains it contains
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
| **Engineering** | Domains 1–6 | Stage A (Conceptual) → Stage B (Architecture) → Stage C (Specification) |
| **Software** | Domain 7 | Stage C (Specification) → Stage D (Implementation) |
| **Delivery** | Cross-cutting (Phase 4) | Stage D (Deployment, Documentation, Training) |

The seven-domain model is the **ENGINEERING** column. It does not replace the other two columns; it depends on them and is delivered through them.

Treating ENGINEERING as the whole engagement is the most common underestimation in analytical software contracts. Documentation, training, and deployment are real work, named in the RFP, and must be tracked with the same discipline as the modeling engine itself.

---

## 2. Product Intent

The product is a **software platform for operational and financial evaluation of BESS projects**.

Its purpose is to answer a single class of questions:

> Given a BESS configuration, a client load profile, a set of market rules, and a set of financial assumptions, what is the operational and financial performance of the project under different scenarios?

To answer that question, the platform must connect, in a coherent and auditable chain:

```
Data → Forecast → Physical BESS Model → Operational Modes
     → Dispatch (with Revenue Stacking) → Degradation
     → Financial Model → Scenarios → Results
```

This chain is the backbone of the entire solution. Every engineering domain, interface, and deliverable must serve it. Revenue stacking is part of **Dispatch**, not a separate stage after Degradation.

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

### 3.2 Out of Scope (to be confirmed in Phase 1)

- Real-time operational control of physical assets
- SCADA or EMS integration
- Trading execution or market bidding submission
- Procurement or hardware selection
- Grid interconnection studies

### 3.3 Market Scope Ambiguity — Phase 1 Clarification Required

The RFP references multiple market constructs — day-ahead and real-time LMP, PJM RegD, ERCOT Fast Frequency Response, capacity markets, ancillary services, demand response programs, TOU tariffs — without specifying a single target market.

This is a material ambiguity. Market rules drive eligibility, dispatch logic, settlement, and revenue calculation. The architecture must therefore separate:

- A **generic BESS engine** (physics, degradation, dispatch)
- **Market-specific adapter modules** (rules, settlement, revenue mechanisms, program eligibility)

This separation is a core architectural principle of the platform and is reinforced by the RFP's explicit mention of heterogeneous market products.

---

## 4. Delivery Philosophy — Design-Led, Iteratively Delivered

The engagement follows a **four-stage engineering progression**, moving from conceptual definition through to implementation.

| Stage | Name | Engineering Equivalent | Purpose |
|---|---|---|---|
| **A** | Engineering Definition | Conceptual Engineering | Define what the system must calculate and under what rules |
| **B** | System Architecture | Basic Engineering | Define how the engineering model is represented computationally |
| **C** | Product Specification | Detailed Engineering | Consolidate requirements, models, architecture, interfaces, validation |
| **D** | Implementation | Construction & Commissioning | Build, test, validate, deploy |

The sequence is deliberate, but **the gates between stages are lightweight**, and Stage D begins in **parallel** with Stage C, not after it. The goal is to preserve engineering rigor while ensuring that a working end-to-end artifact exists early enough to de-risk data, runtime, and usability.

### 4.1 Stage Progression with a Thin Vertical Slice

```
SYSTEM STRATEGY
       │
       ▼
STAGE A — ENGINEERING DEFINITION
(Conceptual Engineering)
       │
       ├── A.1  System Component Definition
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
(Basic Engineering)
       │
       ├── High-Level Design (HLD)
       └── Basic Architecture Definition
       │
       ▼
STAGE C — PRODUCT SPECIFICATION  ────┐
(Detailed Engineering)              │
       │                            │  Stage C and Stage D run in parallel
       ├── Low-Level Design (LLD)   │  from week 3
       ├── Product Specification    │
       └── Engineering Specs        │
                                    │
                                    ▼
                          STAGE D — IMPLEMENTATION
                          (Construction & Commissioning)
                                    │
                                    ├── Thin slice demo to ENGIE (~week 4)
                                    ├── Progressive domain deepening
                                    ├── Python / PySpark / SQL
                                    ├── Databricks App
                                    ├── Tests
                                    ├── UAT
                                    └── Deployment & Training
```

### 4.2 Thin End-to-End Slice — Internal and Demo

By approximately **week 4**, the platform must demonstrate a **thin end-to-end slice**:

- **Peak shaving** + **energy arbitrage** (two value streams)
- A **simple degradation update** applied between periods
- **NPV** displayed on a basic Databricks App page
- Data flowing through ingestion → dispatch → degradation → financial → app

The slice serves **two purposes**:

1. **Internal de-risking** — proving that data ingestion, dispatch runtime, the degradation feedback loop, and the Databricks App render work end-to-end
2. **Client demo** — validating scope, expectations, and usability with ENGIE's business development users **before** the full platform is built

The demo is not a formal deliverable, but it is a **strategic checkpoint**. ENGIE's users accept the platform against what they see; showing them something concrete at week 4 prevents surprises at week 12.

### 4.3 Consolidated Stage A.2

The seven A.2 documents **may be delivered as one consolidated document with seven chapters** rather than seven standalone files, if that better serves review velocity. The content requirements are identical; only the packaging differs.

### 4.4 Lightweight Gates

Formal sign-offs at Stage A, B, C, D remain in place, but:

- Stage A.2 review is **per-chapter**, not per-document
- Stage B review is a **single consolidated review**, not per-layer
- Stage C review is a **single review**, not per-specification
- Stage D acceptance is **continuous**, culminating in UAT

This preserves rigor without imposing sequencing that would push the first working model to week 6 or beyond.

---

## 5. The Seven Engineering Domains

The system is organized into seven engineering domains. Each domain represents a distinct domain of modeling responsibility. Together they form the complete operational and financial evaluation platform.

### Domain 1 — BESS Engineering

Represents the physical system.

Covers conceptually:

- Battery
- Energy capacity (nominal and usable)
- Power capacity
- State of Charge (SOC)
- State of Health (SOH)
- Efficiency (round-trip and conversion)
- C-rate
- Ramp constraints
- Operating limits
- Thermal effects
- Degradation (as interface to Domain 5)
- Augmentation and replacement

This domain is the **physical foundation** of the platform.

### Domain 2 — Load & Market Engineering

Represents the economic and energetic environment in which the BESS operates.

Covers conceptually:

- **Load**: historical meter data (15-min or hourly), demand profiles, peak demand
- **Load projection / forecasting**: short-horizon forecast and multi-year projection/scenario capability
- **Energy markets**: TOU tariffs, day-ahead LMP, real-time LMP, ancillary service clearing prices, capacity market revenues
- **Programs**: demand response program rules, event windows, notification lead time, performance measurement methodology, penalties, eligibility
- **Grid / regulatory**: interconnection limits, export constraints, participation eligibility by market/program

This domain provides the **external signals** the operational model requires. It is explicitly structured to support **market/program adapters** that plug into the generic BESS engine.

### Domain 3 — Operational Engineering

Represents how the BESS can operate.

The RFP explicitly requires modeling of:

- Peak Shaving
- Demand Response
- Energy Arbitrage
- Frequency Regulation
- Voltage Regulation

Each **operating mode / value stream** is a distinct operational behavior with its own logic, key parameters, and output metrics, later formalized during conceptual engineering (A.2.3). Modeling traps — demand-charge billing periods, DR event uncertainty, regulation signal infeasibility at coarse time steps, reactive/active power coupling — are addressed in A.2.3 and A.2.4.

### Domain 4 — Dispatch & Optimization Engineering

This domain is distinct from operational modeling and must be treated separately.

The RFP requires not only simulation of individual operating modes, but also:

> Co-optimization across multiple value streams simultaneously.

Conceptually:

```
Operating Modes
       │
       ▼
Dispatch & Optimization
       │
       ├── Physical constraints
       ├── Market constraints
       ├── Program constraints
       ├── SOC constraints
       └── Economic objectives
       │
       ▼
Optimal / feasible dispatch
```

**Inputs to Dispatch** are *value signals* — prices, program payments, and marginal degradation cost — not revenue attribution.

**Outputs from Dispatch** include dispatch schedule, SOC trajectory, and revenue attribution per value stream.

Methodology options remain open per the RFP:

- Rule-based heuristic
- Linear Programming (LP)
- Mixed-Integer Programming (MILP)
- Hybrid approach

The choice is a **Phase 1 decision**, not a Phase 2 assumption.

### Domain 5 — Degradation Engineering

Although physically part of the BESS, degradation is treated as a **transversal subsystem** because it affects the system dynamically over time.

```
Dispatch
   ↓
Battery Throughput
   ↓
Cycle Aging
   +
Calendar Aging
   ↓
SOH
   ↓
Available Capacity
   ↓
Future Dispatch Feasibility
```

The RFP explicitly requires a **feedback loop**: degradation impacts available energy in future periods, dynamically adjusting dispatch feasibility.

This makes degradation a **dynamic state of the system**, not a post-processing cost.

**Time scale of the feedback loop is an explicit Phase 1 decision.** Options range from inside-optimization updates to annual SOH updates with representative-period simulation. The choice drives runtime, fidelity, and defensibility.

### Domain 6 — Financial Engineering

Consumes operational outputs and produces financial performance.

Covers conceptually:

- CAPEX
- OPEX
- Revenue by stream (peak shaving, DR, arbitrage, regulation)
- Savings (demand charge reduction, energy cost reduction)
- Degradation cost
- Augmentation
- Replacement
- Incentives (e.g. ITC, where applicable)
- Tax and depreciation treatment (where applicable)
- Discount rate
- Escalation
- Contract term
- NPV (project)
- IRR (project and equity)
- Payback

Critical separation:

```
Operational Model
       │
       │ operational outputs
       ▼
Financial Model
       │
       ├── Revenue
       ├── Savings
       ├── Costs
       └── Investment
       │
       ▼
Financial KPIs
```

The financial model **consumes** operational results. It must not become a second operational model.

### Domain 7 — Data & Application Engineering

The technological layer that delivers the platform.

Covers:

```
Data Sources
     ↓
Data Ingestion
     ↓
Data Transformation
     ↓
Data Validation
     ↓
Data Processing
     ↓
Modeling Engine
     ↓
Results
     ↓
Databricks App
```

Includes:

- Python
- PySpark
- SQL
- Databricks
- Databricks App
- Data pipelines
- Scenario configuration
- Visualization
- Export (PDF / Excel)
- Audit, lineage, execution logs

This domain is **implementation**, not business modeling.

---

## 6. System Architecture

### 6.1 Architecture Layers

| Layer | Description | Primary Engineering Domains |
|---|---|---|
| **Data Architecture** | Ingestion, validation, transformation, schemas, data quality, historical data, market data, financial assumptions | Domain 7 |
| **Model Architecture** | Representation of BESS physics, load, degradation as computational objects and state | Domains 1, 2, 5 |
| **Optimization Architecture** | Dispatch logic, revenue stacking, constraint handling, co-optimization | Domains 3, 4 |
| **Financial Architecture** | Cash flow, NPV, IRR, scenario valuation, revenue attribution | Domain 6 |
| **Software Architecture** | Python engine, Databricks App, PySpark, SQL, APIs, interfaces | Domain 7 |
| **Databricks Architecture** | App layer, processing layer, storage layer, orchestration, deployment | Domain 7 |

### 6.2 Causal Backbone

```
                   EXTERNAL WORLD
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
          LOAD / MARKET           BESS
              │                     │
              └──────────┬──────────┘
                         ▼
                  OPERATIONAL
                    MODELS
                         │
                         ▼
                  DISPATCH /
                 OPTIMIZATION
                         │
                         ▼
                  BESS STATE
                         │
                         ▼
                  DEGRADATION
                         │
                         ▼
                UPDATED CAPABILITY
                         │
                         └──────► future dispatch
                         │
                         ▼
                OPERATIONAL RESULTS
                         │
                         ▼
                  FINANCIAL ENGINE
                         │
                         ▼
                 FINANCIAL RESULTS
                         │
                         ▼
                 SCENARIO ANALYSIS
                         │
                         ▼
                 DECISION SUPPORT
                         │
                         ▼
                   DATABRICKS APP
```

Dispatch is **central to co-optimization**, but the system's identity is defined by the causal chain, not by a single hub.

### 6.3 Architectural Principles

- The architecture must preserve the causal chain: **Physical → Operational → Financial**
- The generic BESS engine must be separable from market/program-specific adapters
- Degradation must be modeled as a dynamic state, not a post-processing cost
- The financial model must consume operational outputs, never replace them
- Validation must be defined before results are produced
- Scenario Management and Validation are **cross-cutting capabilities**, not additional domains

### 6.4 Operational Signals vs. Investment Assumptions

The principle "financial must not drive operational" requires precise formulation:

| Category | Examples | May influence dispatch? |
|---|---|---|
| **Operational signals** | Market prices, TOU tariffs, DR program payments, marginal degradation cost, reserve prices | **Yes** — these are inputs to economic dispatch |
| **Investment assumptions** | Discount rate, CAPEX, financing structure, tax treatment, contract term | **No** — these belong to the financial evaluation layer only |

**Investment assumptions may enter dispatch only through explicitly derived, documented operational signals.** The clearest example is **marginal degradation cost**: it is typically derived as replacement cost ÷ lifetime throughput. Replacement cost is an investment assumption, but once transformed into a per-MWh marginal cost, it becomes an operational signal and legitimately enters the dispatch objective.

The distinction is not "investment assumptions never touch dispatch." It is: **investment assumptions never enter dispatch directly; they may enter only via documented, derived operational signals.**

**Contract term** defines the simulation horizon (how many years are modeled), not the dispatch decisions within those years. It sets the frame; it does not set the decisions.

---

## 7. Two Simultaneous Cycles

### 7.1 Physical-Operational Cycle

Represents the **real-world behavior of the battery system over time**.

```
Inputs (load, market signals, tariffs, BESS parameters)
        ↓
Load / Market Conditions
        ↓
Dispatch Decision
        ↓
Battery Behavior (charge, discharge, rest)
        ↓
Degradation (calendar + cycle aging)
        ↓
Updated Battery State (SOC, SOH, available capacity)
        ↓
Operational Outputs (energy shifted, peak reduced, regulation provided)
        ↓
[Feedback into next period's dispatch feasibility]
```

**Key characteristics:** time-dependent, stateful, constraint-driven, subject to a degradation feedback loop.

**Domains involved:** Domain 1, 2, 3, 4, 5.

### 7.2 Economic-Financial Cycle

Represents the **economic consequence of the physical-operational cycle**.

```
Operational Outputs (from the physical-operational cycle)
        ↓
Revenue by Value Stream
        ↓
Savings
        ↓
Costs (CAPEX, OPEX, degradation, augmentation, replacement)
        ↓
Cash Flow (annual, discounted)
        ↓
Financial KPIs (NPV, IRR, payback)
        ↓
[Feeds into scenario comparison and business decision]
```

**Key characteristics:** derived from operational outputs, aggregated over the contract term, discounted and escalated, comparative across scenarios.

**Domains involved:** Domain 6, supported by outputs from Domains 1–5.

### 7.3 Coupling Between Cycles

The two cycles are **coupled**:

- The physical-operational cycle runs first within each simulation period
- The economic-financial cycle consumes the operational outputs of that period
- Degradation from the physical cycle feeds back into future operational feasibility
- Financial results inform scenario comparison, which may re-run the physical cycle under different assumptions

### 7.4 Why This Separation Matters

Collapsing the two cycles into a single model leads to:

- Investment assumptions driving operational behavior
- Inability to isolate operational from financial performance
- Difficulty validating against benchmarks
- Loss of auditability in revenue attribution

Preserving the two-cycle structure ensures that:

- Operational results are always traceable to physical and market inputs
- Financial results are always traceable to operational results
- Scenario comparison is meaningful because it varies well-defined inputs
- Validation can be performed independently at each cycle

**Note on operational signals.** Market prices, tariffs, and marginal degradation cost are operational signals and may legitimately influence dispatch. The separation prohibits **investment-level assumptions** from entering dispatch directly — see §6.4.

---

## 8. Cross-Cutting Capabilities

### 8.1 Scenario Management

Parameterizes and orchestrates the other domains:

```
                 SCENARIO MANAGEMENT
                        │
       ┌────────────────┼────────────────┐
       ▼                ▼                ▼
     BESS           Market           Financial
   parameters       scenario         assumptions
       │                │                │
       └────────────────┼────────────────┘
                        ▼
                 Operational /
                   Dispatch
                        │
                        ▼
                  Degradation
                        │
                        ▼
                 Financial Results
                        │
                        ▼
                 Scenario Comparison
```

### 8.2 Validation

Operates at four levels:

```
DOMAIN VALIDATION
       │
       ▼
MODEL VALIDATION
       │
       ▼
SYSTEM VALIDATION
       │
       ▼
UAT
```

- **Domain validation** — e.g. energy balance and SOC consistency (Domain 1), SOH evolution and EFC (Domain 5), cash-flow consistency and NPV/IRR (Domain 6)
- **Integrated validation** — Dispatch → SOC → Degradation → Available Capacity → Financial Result
- **System validation** — end-to-end chain integrity
- **UAT** — user scenario → configuration → execution → results → acceptance

Validation must be defined **before** results are produced.

### 8.3 Output Mock — Anchoring Acceptance

Because ENGIE's business development users will accept the platform against what they see, an **early mock of the outputs** is part of the strategy:

- **KPI list** — the full set of outputs the platform will produce (NPV, IRR, payback, annual revenue by stream, demand charge savings, degradation cost, SOC profiles, dispatch profiles, scenario comparison)
- **Dashboard wireframe** — the initial layout of the Databricks App, showing how a user configures a scenario, runs it, and inspects results

This mock is prepared during Phase 1 and refined continuously. It anchors the RFP's acceptance criteria in something tangible.

---

## 9. System Strategy — Scope Definition

### 9.1 What This Strategy Defines

- System boundary
- System purpose
- The three natures of the RFP (Engineering, Software, Delivery)
- Major engineering domains
- Cross-cutting capabilities (Scenario Management, Validation)
- Operational signals vs. investment assumptions distinction
- Delivery philosophy (design-led, iteratively delivered)
- Validation philosophy
- **Technology strategy** (see §9.3)
- **Evolution strategy** (see §9.4)

### 9.2 What This Strategy Does Not Define

- Python classes
- Concrete data tables
- APIs
- Detailed mathematical algorithms
- Equations
- Schemas
- Notebooks
- Functions
- SQL
- PySpark implementation
- MILP formulations
- Databricks deployment details

Those belong to Stages B, C, and D.

### 9.3 Technology Strategy

The RFP requires Python, Databricks, PySpark, and SQL. Where each earns its place:

| Technology | Role | Where it does **not** belong |
|---|---|---|
| **Python** | Modeling engine; BESS physics, dispatch, degradation, financial calculation | — |
| **PySpark** | Parallelization **across scenarios**, **across representative periods within a year**, and **across sensitivity analyses**; large-scale data transformation | Sequential state evolution (see below) |
| **SQL** | Data ingestion, validation, transformation, querying, result storage | Modeling logic |
| **Databricks** | Execution environment, orchestration, storage, app hosting | Model definition |
| **Databricks App** | User interface — scenario configuration, dashboards, exports | Modeling logic |

**PySpark scope — explicit, and constrained by statefulness.**

Two things in this system are **sequential by construction** and therefore **cannot** be parallelized across their natural axis:

- **Project years** — SOH carries forward from one year to the next
- **Rolling-horizon windows** — SOC carries forward from one window to the next

Parallelizing either axis would violate the feedback loop the platform is built to preserve.

PySpark therefore parallelizes:

- **Scenarios** — the primary axis. A scenario grid of N scenarios runs as N parallel units of work.
- **Representative periods within a year** — valid only when SOH is held fixed during that year. Under annual-SOH-update designs, the representative periods of one year are independent and parallelizable.
- **Sensitivity analyses** — each sensitivity case is an independent scenario.

A single dispatch optimization for one scenario and one representative period is a **single-node Python computation**. PySpark does not parallelize within an optimization.

This is the architectural commitment the RFP's PySpark requirement implies. Stated this way, it has clear boundaries and does not contradict the feedback loop.

### 9.4 Evolution Strategy

The platform is designed to evolve along three axes:

1. **Market coverage** — new markets are added by developing new adapters, not by altering the generic engine
2. **Value stream coverage** — new value streams are added as new operational modes, dispatched through the existing optimization layer
3. **Analytical depth** — degradation fidelity, uncertainty modeling, and forecast methodology can be deepened in later phases without restructuring the domains

This means the deliverable at week 12 is a **platform**, not a fixed study: ENGIE can extend it without re-architecting it.

---

## 10. Engagement Timeline

| Phase | Weeks | Delivery Stage | Focus |
|---|---|---|---|
| 1 — Design | 1–2 | Stage A + B | Requirements validation, conceptual engineering, high-level architecture, output mock |
| 2 — Development | 3–9 | Stage C + D (parallel) | Thin end-to-end slice by ~week 4 (demo to ENGIE), then progressive domain deepening |
| 3 — Testing | 10–11 | Stage D | Model validation, UAT |
| 4 — Deployment | 12 | Stage D | Final delivery, deployment, documentation, training |

---

## 11. Governance & Communication

- Regular status meetings with stakeholders
- Periodic progress reporting
- Review sessions at key milestones
- Structured issue tracking and resolution
- Formal sign-off at end of Stage A, Stage B, Stage C, and Stage D (with the lightweight-gate framing of §4.4)

---

## 12. Phase 1 Clarification Items

Clarification items are organized into **blocking** and **defaultable**. Blocking items must be resolved in Weeks 1–2; defaultable items will proceed under an explicit working assumption if not confirmed by Week 2, and the assumption will be documented and revisited if contradicted.

### 12.1 Blocking Items (must be resolved in Weeks 1–2)

| # | Item | Why Blocking |
|---|---|---|
| B1 | **Target market(s)** | Market rules drive eligibility, dispatch logic, settlement, revenue calculation |
| B2 | **Behind-the-meter vs. front-of-the-meter scope** | Determines which value streams and constraints apply |
| B3 | **Data availability** | Determines what can actually be modeled; drives ingestion design |
| B4 | **Benchmark data** | Required to define acceptance; validation is defined before results |
| B5 | **Acceptance thresholds (accuracy + quantified runtime + usability)** | The RFP's "execution standards" must be made concrete before the thin slice is built |

### 12.2 Defaultable Items (proceed under stated assumption if not confirmed by Week 2)

| # | Item | Default assumption if not confirmed |
|---|---|---|
| D1 | Dispatch methodology | **Hybrid** — rule-based heuristic with LP refinement for peak shaving + arbitrage; revisit after thin slice |
| D2 | Perfect foresight vs. forecast-based dispatch | **Forecast-based** with perfect-foresight benchmark available for comparison |
| D3 | Degradation feedback loop time scale | **Annual SOH update** with representative-period simulation within each year |
| D4 | Voltage regulation coupling | **Fixed envelope** (no P² + Q² ≤ S² linearization in initial scope); flag as extension |
| D5 | Load forecasting method | **ENGIE-provided** if available; otherwise statistical baseline (seasonal + TOU pattern) |
| D6 | Short-horizon forecast vs. multi-year projection | Both are modeled; short-horizon for dispatch, multi-year for contract-term scenarios |
| D7 | Load forecasting home | **Conceptual ownership: Domain 2**; implementation via Domain 7 |
| D8 | Financing structure | **Project IRR as primary KPI**; equity IRR deferred pending financing details |
| D9 | Tax and incentives treatment | **Pre-tax** initially; ITC/depreciation flagged as extension if US market confirmed |
| D10 | Reporting format | **Both PDF and Excel** — Excel for analysts, PDF for business development |
| D11 | Scenario granularity | **3–5 core scenarios** initially, expandable |
| D12 | Audit / lineage / traceability scope | **Basic execution logs + data lineage**; full audit framework deferred |
| D13 | Market adapter scope | **One adapter at delivery** (target market), architecture supports more |
| D14 | Time resolution and simulation horizon | **Hourly resolution, 15-year contract term** — revisited if 15-min required |
| D15 | Databricks workspace access and environment ownership | **ENGIE-owned workspace**; consultant granted developer access |

### 12.3 Rationale

This two-tier structure exists because **the project must be able to proceed even if ENGIE is slow to answer**. Blocking items genuinely prevent design from starting. Defaultable items have defensible working assumptions that can be revisited — and if the assumption is later contradicted, the cost of adjustment is contained by the architecture (adapters, scenario parameters, cross-cutting capabilities).

Every default assumption is documented in the Phase 1 report and flagged for review at the Stage B review session.

---

## 13. Conclusion

This System Strategy establishes a disciplined, domain-driven approach to the ENGIE BESS Operational & Financial Modeling Platform engagement.

The system is organized into **seven engineering domains**, connected through a **causal backbone** that runs from physical behavior to financial value, and supported by two **cross-cutting capabilities** — Scenario Management and Validation. Two simultaneous cycles — physical-operational and economic-financial — are preserved as distinct but coupled, ensuring traceability, auditability, and meaningful scenario comparison.

The engagement itself is understood as **three parallel natures** — Engineering, Software, and Delivery — with the seven-domain model constituting the Engineering column, Domain 7 delivering the Software column, and Phase 4 carrying the Delivery column.

Delivery is **design-led and iteratively delivered**: a thin end-to-end slice (peak shaving + arbitrage + simple degradation + NPV in the app) exists by approximately week 4 and is demoed to ENGIE as a scope-validation checkpoint. Stage C and Stage D run in parallel from week 3. Stage gates are lightweight, preserving rigor without imposing sequencing that would delay the first working artifact.

The platform will connect data, forecast, physics, dispatch, degradation, revenue, and finance into a single auditable chain, delivering the analytical robustness ENGIE requires for business development and project evaluation — and it will be extensible to new markets and value streams without re-architecture.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Duration:** 12 Weeks
**Language:** English

---


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








