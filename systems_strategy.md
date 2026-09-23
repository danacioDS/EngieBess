
---

# BESS Operational & Financial Modeling Platform

## System Strategy & Delivery Framework

**Document ID:** SYS-STR-FRM-001

**Version:** 0.3 — Development Draft

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

> **Define the system first. Engineer the model second. Architect the solution third. Implement the software fourth.**

### 1.1 What the Engagement Actually Delivers

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
Data → Forecast → Physical BESS Model → Dispatch → Degradation
     → Revenue Stacking → Financial Model → Scenarios → Results
```

This chain is the backbone of the entire solution. Every engineering domain, interface, and deliverable must serve it.

---

## 3. System Boundary

### 3.1 In Scope

- BESS technical and operational modeling
- Load ingestion **and load forecasting**
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

### 3.4 The Three Natures of the RFP

The RFP is not a single-dimensional request. It is simultaneously an **engineering**, a **software**, and a **delivery** obligation, and each nature carries its own scope, risk, and acceptance criteria.

- **ENGINEERING** — modeled by the seven domains (Stage A)
- **SOFTWARE** — delivered by Domain 7 (Data & Application) and realized in Stages C–D
- **DELIVERY** — the contractual wrapper: documentation, training, deployment, tracked separately in Phase 4

These three natures run in parallel for the full 12 weeks. They are not sequential phases of the same work; they are three simultaneous workstreams.

---

## 4. Delivery Philosophy

The engagement follows a **four-stage engineering progression**, moving from conceptual definition through to implementation. This progression mirrors established engineering practice: conceptual engineering, basic engineering, detailed engineering, and implementation.

| Stage | Name | Engineering Equivalent | Purpose |
|---|---|---|---|
| **A** | Engineering Definition | Conceptual Engineering | Define what the system must calculate and under what rules |
| **B** | System Architecture | Basic Engineering | Define how the engineering model is represented computationally |
| **C** | Product Specification | Detailed Engineering | Consolidate requirements, models, architecture, interfaces, validation |
| **D** | Implementation | Construction & Commissioning | Build, test, validate, deploy |

This sequence is deliberate. It ensures that:

- The physical and operational model is correct before software is written
- The architecture reflects the engineering reality, not the other way around
- The specification is complete before implementation begins
- Validation is defined before results are produced

### 4.1 Stage Progression

```
SYSTEM STRATEGY
       │
       ▼
STAGE A — ENGINEERING DEFINITION
(Conceptual Engineering)
       │
       ├── A.1  System Component Definition
       │        (Eagle-Eye View of the Seven Domains)
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
STAGE C — PRODUCT SPECIFICATION
(Detailed Engineering)
       │
       ├── Low-Level Design (LLD)
       ├── Product Specification
       └── Engineering Specifications
       │
       ▼
STAGE D — IMPLEMENTATION
(Construction & Commissioning)
       │
       ├── Prompts / Task Definitions
       ├── Python / PySpark / SQL
       ├── Databricks App
       ├── Tests
       ├── UAT
       └── Deployment & Training
```

Each stage produces the foundation required by the next. No stage begins before the previous stage has been reviewed and accepted.

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

- **Load**: historical meter data (15-min or hourly), demand profiles, peak demand, **load forecasting capability**
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

Each **operating mode / value stream** is a distinct operational behavior with its own logic, key parameters, and output metrics, later formalized during conceptual engineering (A.2.3).

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
- Incentives
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

The System Architecture translates the seven engineering domains into a computational structure. It defines how the engineering model is represented, how data flows through the system, and how the components interact.

### 6.1 Architecture Layers (Table)

| Layer | Description | Primary Engineering Domains |
|---|---|---|
| **Data Architecture** | Ingestion, validation, transformation, schemas, data quality, historical data, market data, financial assumptions | Domain 7 |
| **Model Architecture** | Representation of BESS physics, load, degradation as computational objects and state | Domains 1, 2, 5 |
| **Optimization Architecture** | Dispatch logic, revenue stacking, constraint handling, co-optimization | Domains 3, 4 |
| **Financial Architecture** | Cash flow, NPV, IRR, scenario valuation, revenue attribution | Domain 6 |
| **Software Architecture** | Python engine, Databricks App, PySpark, SQL, APIs, interfaces | Domain 7 |
| **Databricks Architecture** | App layer, processing layer, storage layer, orchestration, deployment | Domain 7 |

### 6.2 Causal Backbone

The system is not organized "around" Dispatch. It is organized along a **causal backbone** that runs from the physical system to decision support:

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

---

## 7. Two Simultaneous Cycles

The platform contains **two simultaneous cycles** that operate at different logical levels but remain tightly coupled. Understanding this dual-cycle structure is essential to designing a correct architecture.

### 7.1 Physical-Operational Cycle

This cycle represents the **real-world behavior of the battery system over time**. It answers the question:

> What does the battery actually do, hour by hour, day by day, under a given dispatch strategy?

The cycle proceeds as follows:

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

**Key characteristics:**

- Time-dependent and sequential
- Stateful (SOC and SOH carry forward)
- Constraint-driven (physical, market, program rules)
- Subject to a feedback loop via degradation

**Domains involved:** Domain 1 (BESS), Domain 2 (Load & Market), Domain 3 (Operational), Domain 4 (Dispatch), Domain 5 (Degradation)

### 7.2 Economic-Financial Cycle

This cycle represents the **economic consequence of the physical-operational cycle**. It answers the question:

> What is the financial value of what the battery did, over the contract term?

The cycle proceeds as follows:

```
Operational Outputs (from the physical-operational cycle)
        ↓
Revenue by Value Stream (peak shaving, DR, arbitrage, regulation)
        ↓
Savings (demand charge reduction, energy cost reduction)
        ↓
Costs (CAPEX, OPEX, degradation, augmentation, replacement)
        ↓
Cash Flow (annual, discounted)
        ↓
Financial KPIs (NPV, IRR, payback)
        ↓
[Feeds into scenario comparison and business decision]
```

**Key characteristics:**

- Derived from operational outputs, not independent of them
- Aggregated over the contract term
- Discounted and escalated
- Comparative across scenarios

**Domains involved:** Domain 6 (Financial), supported by outputs from Domains 1–5

### 7.3 Coupling Between Cycles

The two cycles are not sequential in the sense that one finishes before the other begins. They are **coupled**:

- The physical-operational cycle runs first within each simulation period
- The economic-financial cycle consumes the operational outputs of that period
- Degradation from the physical cycle feeds back into future operational feasibility
- Financial results from the economic cycle inform scenario comparison, which may re-run the physical cycle under different assumptions

```
┌─────────────────────────────────────────────┐
│         PHYSICAL-OPERATIONAL CYCLE          │
│  Inputs → Dispatch → Battery → Degradation  │
│         ↓                                   │
│  Operational Outputs                        │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│         ECONOMIC-FINANCIAL CYCLE            │
│  Operational Outputs → Revenue → Costs      │
│         ↓                                   │
│  Cash Flow → NPV / IRR / Payback            │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
         Scenario Comparison
                  │
                  ▼
          Business Decision
```

### 7.4 Why This Separation Matters

Collapsing the two cycles into a single model is the most common architectural error in BESS evaluation platforms. It leads to:

- Financial assumptions driving operational behavior (backwards causality)
- Inability to isolate operational performance from financial performance
- Difficulty validating results against benchmarks
- Loss of auditability in the revenue attribution chain

Preserving the two-cycle structure ensures that:

- Operational results are always traceable to physical and market inputs
- Financial results are always traceable to operational results
- Scenario comparison is meaningful because it varies well-defined inputs
- Validation can be performed independently at each cycle

### 7.5 Combined View

```
                    BESS SYSTEM MODEL
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
    Physical           External           Economic
    System             Environment        Model
        │                  │                  │
        └──────────┬───────┴──────────┬───────┘
                   │                  │
                   ▼                  │
              Operational             │
               Simulation             │
                   │                  │
                   ▼                  │
               Dispatch               │
              Optimization            │
                   │                  │
                   └────────┬─────────┘
                            ▼
                     Scenario Engine
                            │
                   ┌────────┴────────┐
                   ▼                 ▼
              Operational        Financial
                Results            Results
                   │                 │
                   └────────┬────────┘
                            ▼
                     Decision Outputs
                            │
                            ▼
                      Databricks App
```

Both cycles terminate in the Scenario Engine, which produces the Decision Outputs delivered through the Databricks App.

---

## 8. Cross-Cutting Capabilities

Two capabilities appear repeatedly in the RFP and cut across multiple domains. They are **not additional domains**; they are transversal concerns that must be designed once and applied consistently.

### 8.1 Scenario Management

The RFP refers to operational scenarios, market scenarios, scenario configuration, scenario comparison, financial assumptions, and different contract conditions.

Scenario Management is a **cross-domain capability** that parameterizes and orchestrates the other domains:

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

Treating Scenario Management as a domain would artificially inflate the system. Treating it as a cross-cutting capability keeps the seven-domain decomposition clean while preserving the RFP's scenario requirements.

### 8.2 Validation

The RFP requires validation against established benchmarks and successful UAT completion. Validation is therefore a **cross-cutting engineering concern** operating at four levels:

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

Validation must be defined **before** results are produced, not after.

---

## 9. System Strategy — Scope Definition

This document is a **System Strategy**, not a specification or implementation plan.

### 9.1 What This Strategy Defines

- System boundary
- System purpose
- The three natures of the RFP (Engineering, Software, Delivery)
- Major engineering domains
- Cross-cutting capabilities (Scenario Management, Validation)
- Major capabilities
- System interactions
- Inputs and outputs
- Architectural principles
- Validation philosophy
- Technology strategy
- Evolution strategy

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

---

## 10. Engagement Timeline

The 12-week engagement follows ENGIE's defined phases, mapped to the four delivery stages:

| Phase | Weeks | Delivery Stage | Focus |
|---|---|---|---|
| 1 — Design | 1–2 | Stage A + B | Requirements validation, conceptual engineering, high-level architecture |
| 2 — Development | 3–9 | Stage C + D | Detailed engineering, product specification, implementation |
| 3 — Testing | 10–11 | Stage D | Model validation, UAT |
| 4 — Deployment | 12 | Stage D | Final delivery, deployment, documentation, training |

---

## 11. Governance & Communication

- Regular status meetings with stakeholders
- Periodic progress reporting
- Review sessions at key milestones
- Structured issue tracking and resolution
- Formal sign-off at end of Stage A, Stage B, Stage C, and Stage D

---

## 12. Phase 1 Clarification Items

The following items require explicit confirmation during Weeks 1–2:

1. **Target market(s)** — Which ISO/RTO or jurisdiction defines the market rules?
2. **Dispatch methodology** — Heuristic, LP, MILP, or hybrid?
3. **Degradation model fidelity** — Empirical, semi-empirical, or vendor-data-driven?
4. **Load forecasting method** — Statistical, ML-based, hybrid, or provided by ENGIE?
5. **Reporting format** — PDF, Excel, or both?
6. **Scenario granularity** — How many scenarios, what dimensions?
7. **Benchmark data** — What established benchmarks will be used for validation?
8. **Data availability** — What historical data will ENGIE provide?
9. **Market adapter scope** — Which markets must be supported at delivery?
10. **Acceptance thresholds** — What accuracy and performance criteria define acceptance?
11. **Audit / lineage / traceability scope** — Are execution logs, data lineage, and audit outputs required deliverables, or are they optional engineering practices?
12. **Load forecasting home** — Is forecasting owned by Domain 2 (Load & Market), treated as a transversal capability, or delivered as part of Domain 7 (Data & Application)?

---

## 13. Conclusion

This System Strategy establishes a disciplined, domain-driven approach to the ENGIE BESS Operational & Financial Modeling Platform engagement.

The system is organized into **seven engineering domains**, connected through a **causal backbone** that runs from physical behavior to financial value, and supported by two **cross-cutting capabilities** — Scenario Management and Validation. Two simultaneous cycles — physical-operational and economic-financial — are preserved as distinct but coupled, ensuring traceability, auditability, and meaningful scenario comparison.

The engagement itself is understood as **three parallel natures** — Engineering, Software, and Delivery — with the seven-domain model constituting the Engineering column, Domain 7 delivering the Software column, and Phase 4 carrying the Delivery column.

The delivery sequence — **Stage A: Engineering Definition (Conceptual Engineering) → Stage B: System Architecture (Basic Engineering) → Stage C: Product Specification (Detailed Engineering) → Stage D: Implementation (Construction & Commissioning)** — ensures that the software built in Weeks 3–12 is correct by construction, because the model it implements has been fully defined, validated, and agreed before a single line of production code is written.

The platform will connect data, forecast, physics, dispatch, degradation, revenue, and finance into a single auditable chain, delivering the analytical robustness ENGIE requires for business development and project evaluation.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Duration:** 12 Weeks
**Language:** English

---







