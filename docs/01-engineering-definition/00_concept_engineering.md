# BESS Operational & Financial Modeling System
## Stage A — Engineering Definition
### Eagle-Eye View of the Seven Engineering Domains

**Document ID:** SYS-ENG-DEF-001
**Version:** 0.2 — Development Draft
**Status:** Stage A — Engineering Definition (Conceptual Level)
**Project:** ENGIE — BESS Operational & Financial Modeling
**Purpose:** Provide a system-level, eagle-eye definition of the seven engineering domains that constitute the BESS Operational & Financial Modeling System, establishing their identity, purpose, boundaries, responsibilities, inputs, outputs, and relationships — without entering into detailed conceptual engineering, architecture, or implementation.

---

## 1. Purpose of This Document

This document constitutes **Stage A — Engineering Definition** of the delivery framework defined in the System Strategy.

Its purpose is to establish the **system-level decomposition** of the BESS Operational & Financial Modeling Solution into **seven major engineering domains**, and to define each domain at a conceptual, eagle-eye level.

This document is deliberately **not** a detailed conceptual engineering document, nor a mathematical specification, nor an architecture document, nor a product specification.

Instead, it establishes:

- What each engineering domain represents
- Why the domain exists
- What its responsibility is
- What information it consumes
- What information it produces
- How it interacts with the other domains
- Where its boundary begins and ends
- What must subsequently be developed during detailed conceptual engineering

The seven domains form a **coherent integrated system**. They shall not be treated as seven independent models.

### 1.1 Structure of Stage A

Stage A is delivered in two levels:

| Level | Name | Deliverable |
|---|---|---|
| **A.1** | System Component Definition | This document — eagle-eye view of the seven domains |
| **A.2** | Conceptual Engineering per Domain | Seven independent domain documents, developed one at a time |

**This document covers Level A.1 only.** Each domain will subsequently receive its own Conceptual Engineering document at Level A.2.

---

## 2. Position of Stage A Within the Delivery Framework

Stage A sits at the beginning of the four-stage delivery philosophy defined in the System Strategy:

| Stage | Name | Engineering Equivalent | Purpose |
|---|---|---|---|
| **A** | Engineering Definition | Conceptual Engineering | Define what the system must calculate and under what rules |
| **B** | System Architecture | Basic Engineering | Define how the engineering model is represented computationally |
| **C** | Product Specification | Detailed Engineering | Consolidate requirements, models, architecture, interfaces, validation |
| **D** | Implementation | Construction & Commissioning | Build, test, validate, deploy |

---

## 3. System-Level View

The solution shall be understood as an integrated analytical system representing a BESS project from **physical behavior through operational decisions to financial value**.

At the highest level:

```
                         BESS MODELING SYSTEM
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        │                         │                         │
        ▼                         ▼                         ▼
 BESS Engineering         Load & Market             Financial
                         Engineering                 Engineering
        │                         │                         ▲
        │                         │                         │
        └──────────────┬──────────┘                         │
                       ▼                                    │
              Operational Engineering                      │
                       │                                    │
                       ▼                                    │
              Dispatch & Optimization                       │
                       │                                    │
                       ▼                                    │
                Degradation Model ──────────────────────────┘
                       │
                       ▼
                Operational Results
                       │
                       ▼
                 Financial Results
                       │
                       ▼
                Scenario Analysis
                       │
                       ▼
             Data & Application Platform
```

The system follows a fundamental causal chain:

```
Physical System
      ↓
External Environment
      ↓
Operational Behavior
      ↓
Dispatch Decision
      ↓
Battery State Evolution
      ↓
Degradation
      ↓
Operational Performance
      ↓
Economic Value
      ↓
Financial Performance
      ↓
Decision Support
```

This causal structure is fundamental to the system and must be preserved in all subsequent stages.

---

## 4. The Seven Engineering Domains

The solution is decomposed into the following seven domains:

| # | Engineering Domain | Primary Question |
|---|---|---|
| 1 | **BESS Engineering** | What physical system are we modeling? |
| 2 | **Load & Market Engineering** | What external conditions does the BESS operate within? |
| 3 | **Operational Engineering** | How can the BESS operate under different use cases? |
| 4 | **Dispatch & Optimization Engineering** | How should competing operational objectives be coordinated? |
| 5 | **Degradation Engineering** | How does battery usage affect future capability and value? |
| 6 | **Financial Engineering** | What economic value results from the modeled operation? |
| 7 | **Data & Application Engineering** | How is the model supplied with data and exposed as a usable product? |

These domains are **logical engineering boundaries**, not necessarily seven software modules. A future implementation may combine, split, or distribute them differently.

---

## 5. Domain 1 — BESS Engineering

### 5.1 Purpose

Define the **physical and technical representation of the battery energy storage system**, establishing the physical capabilities and constraints that any operational strategy or optimization must respect.

### 5.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Energy capacity | Nominal and usable energy storage |
| Power capacity | Charge and discharge power rating |
| SOC | State of Charge dynamics |
| SOH | State of Health over lifetime |
| Efficiency | Round-trip and conversion losses |
| Operating limits | SOC bounds, power bounds, ramp limits |
| Inverter | AC/DC conversion, reactive capability |
| Thermal | Temperature effects on performance |
| Availability | Physical availability and rest periods |

### 5.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Technical Parameters | Battery configuration, nominal capacity, usable capacity, power rating, inverter rating |
| **Inputs** | Efficiency Characteristics | Round-trip efficiency, conversion losses |
| **Inputs** | Operating Limits | SOC bounds, power bounds, ramp limits, C-rate limits |
| **Inputs** | Environmental | Operating temperature, thermal environment assumptions |
| **Inputs** | Policy | Augmentation policy, replacement policy, availability constraints |
| **Outputs** | State | SOC, SOH, thermal state, availability state |
| **Outputs** | Capability | Available energy, available charging power, available discharging power |
| **Outputs** | Envelope | Feasible operating envelope, physical feasibility conditions |
| **Outputs** | Losses | Conversion losses, efficiency at current operating point |
| **Outputs** | Information | Operating limits, battery state information |

### 5.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What can the physical BESS do? | What should the BESS do economically? |

The economic decision belongs to Operational and Dispatch & Optimization Engineering.

---

## 6. Domain 2 — Load & Market Engineering

### 6.1 Purpose

Represent the **external environment in which the BESS operates** — the electricity demand, tariffs, market prices, grid conditions, and program rules that determine its potential value.

### 6.2 Primary Responsibility

| Sub-Area | Description |
|---|---|
| Load | Historical consumption, interval profiles, demand patterns, peak demand, load forecasts |
| Energy Markets | Electricity prices, TOU tariffs, LMP, ancillary-service prices, capacity revenues |
| Programs | Demand-response rules, event windows, notification, performance requirements, penalties |
| Grid / Regulatory | Interconnection limits, export constraints, eligibility, operating restrictions |

### 6.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Load Data | Historical meter data, interval profiles, demand profiles, peak demand |
| **Inputs** | Tariff Data | TOU structures, demand charge structures, energy charge structures |
| **Inputs** | Market Data | Day-ahead LMP, real-time LMP, ancillary service prices, capacity prices |
| **Inputs** | Program Data | DR program parameters, event windows, notification rules, penalties |
| **Inputs** | Grid Data | Interconnection limits, export constraints, eligibility rules |
| **Inputs** | Regulatory Data | Applicable grid requirements, operating restrictions |
| **Outputs** | Load Signals | Forecast load profile, baseline consumption, peak projections |
| **Outputs** | Price Signals | Electricity price curves, ancillary price curves, capacity revenues |
| **Outputs** | Program Signals | DR event definitions, program constraints, participation rules |
| **Outputs** | Constraint Signals | Grid constraints, regulatory constraints, eligibility envelope |

### 6.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What is happening outside the BESS? | How should the BESS respond? |

---

## 7. Domain 3 — Operational Engineering

### 7.1 Purpose

Define **how the BESS can be used to provide specific services or value streams**, transforming business/use-case requirements into operational behavior.

### 7.2 Primary Responsibility

| Value Stream | Description |
|---|---|
| Peak Shaving | Reduce site demand during relevant peak periods |
| Demand Response | Respond to externally defined DR events per program rules |
| Energy Arbitrage | Charge and discharge according to price differentials |
| Frequency Regulation | Provide fast-response charging/discharging around an operating point |
| Voltage Regulation | Provide reactive-power support subject to inverter capability |

### 7.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | BESS capabilities, feasible operating envelope |
| **Inputs** | External | Load conditions, price signals, tariff structures |
| **Inputs** | Rules | Program rules, grid constraints, operating requirements |
| **Outputs** | Actions | Candidate operational actions per value stream |
| **Outputs** | Requirements | Service requirements, dispatch requirements |
| **Outputs** | Constraints | Operational constraints per mode |
| **Outputs** | Metrics | Service-level metrics, expected operational results |

### 7.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does each value stream use the BESS? | Which value stream should receive priority when several compete? |

Priority resolution belongs to Dispatch & Optimization Engineering.

---

## 8. Domain 4 — Dispatch & Optimization Engineering

### 8.1 Purpose

Act as the **coordination layer between competing operational objectives**. A BESS may be capable of providing multiple services but has finite energy, power, SOC, and operational capability.

### 8.2 Primary Responsibility

| Aspect | Description |
|---|---|
| SOC limits | Enforce minimum and maximum SOC |
| Charge/discharge limits | Enforce power bounds |
| Ramp limits | Enforce rate of change limits |
| Efficiency | Account for conversion losses |
| Minimum rest periods | Enforce idle time requirements |
| Availability | Respect physical availability |
| Market constraints | Respect market rules |
| Program constraints | Respect DR and ancillary rules |
| Degradation effects | Account for SOH feedback |
| Competing revenue streams | Co-optimize across value streams |

### 8.3 Conceptual Optimization Structure

```
                Candidate Value Streams
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
      Peak Shaving       DR        Arbitrage
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                Dispatch Engine
                         │
              Physical Constraints
                         │
              Economic Constraints
                         │
                  SOC Dynamics
                         │
                         ▼
                 Feasible Dispatch
```

### 8.4 Methodology

The implementation method remains intentionally open at this stage:

| Option | Characteristic |
|---|---|
| Rule-based heuristic | Faster, more transparent |
| Linear Programming (LP) | Optimal, moderate complexity |
| Mixed-Integer Programming (MILP) | Optimal, higher complexity |
| Hybrid | Heuristic with LP refinement |

Selection occurs during detailed engineering based on problem complexity, computational requirements, transparency, accuracy, explainability, scenario requirements, and data availability.

### 8.5 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | Feasible operating envelope, SOC bounds, power limits, ramp limits |
| **Inputs** | External | Load forecast, price signals, program rules |
| **Inputs** | Operational | Candidate actions, service requirements, mode constraints |
| **Inputs** | Degradation | Current SOH, available capacity |
| **Inputs** | Economic | Revenue attribution per value stream |
| **Outputs** | Dispatch | Charge/discharge/rest schedule (time series) |
| **Outputs** | State | SOC trajectory over optimization horizon |
| **Outputs** | Attribution | Revenue attribution per value stream |
| **Outputs** | Evidence | Constraint compliance evidence |

### 8.6 Boundary

| Answers | Does Not Answer |
|---|---|
| Given the available opportunities and constraints, how should the BESS be dispatched? | What is the physical battery? What is the complete financial valuation? |

---

## 9. Domain 5 — Degradation Engineering

### 9.1 Purpose

Represent the **evolution of battery capability over time as a consequence of operation and environmental conditions**, preventing the model from treating battery capacity as indefinitely constant.

### 9.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Calendar aging | Time-dependent capacity fade |
| Cycle aging | Throughput-dependent degradation |
| Depth of Discharge | Cycle depth influence |
| C-rate | Cycle intensity influence |
| Temperature | Thermal influence on aging |
| Equivalent full cycles | Cumulative throughput metric |
| Capacity fade | Loss of usable capacity |
| SOH | Remaining capacity |
| Efficiency degradation | Loss of round-trip efficiency |
| Augmentation | Capacity addition events |
| Replacement thresholds | Full replacement triggers |

### 9.3 Feedback Mechanism

```
Dispatch
   ↓
Battery Usage
   ↓
Aging / Degradation
   ↓
SOH
   ↓
Available Capacity
   ↓
Future Operating Capability
   ↓
Future Dispatch
```

Degradation is not merely a final reporting calculation. It influences future operational feasibility and financial performance.

### 9.4 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operating History | Dispatch decisions, battery throughput, cycle counts |
| **Inputs** | Environmental | Thermal conditions, average SOC |
| **Inputs** | Physical | Initial state, physical parameters |
| **Inputs** | Policy | Augmentation policy, replacement thresholds |
| **Outputs** | State | Updated SOH, remaining capacity |
| **Outputs** | Metrics | Degradation metrics, equivalent cycles |
| **Outputs** | Cost Basis | Degradation cost inputs, replacement implications |
| **Outputs** | Events | Augmentation events, replacement events |
| **Outputs** | Constraints | Updated operating constraints |

### 9.5 Boundary

| Answers | Does Not Answer |
|---|---|
| How does operating the battery change the battery over time? | What is the economic value of that degradation? |

Economic valuation belongs to Financial Engineering.

---

## 10. Domain 6 — Financial Engineering

### 10.1 Purpose

Translate operational behavior into **project-level economic performance**, representing the economic consequences of investment, operation, revenue, savings, costs, degradation, augmentation, replacement, and incentives.

### 10.2 Primary Responsibility

| Category | Aspects |
|---|---|
| Investment | CAPEX, installation, augmentation, replacement |
| Operating Economics | O&M, electricity costs, market costs, degradation costs |
| Value | Peak-shaving savings, DR revenue, arbitrage revenue, regulation revenue |
| Financial Evaluation | Cash flows, NPV, IRR, payback, annual revenue, annual savings |

### 10.3 Fundamental Relationship

```
Operational Simulation
        │
        ├── Energy dispatched
        ├── Peak reduction
        ├── DR performance
        ├── Regulation service
        └── Market activity
        │
        ▼
Economic Translation
        │
        ├── Revenue
        ├── Savings
        ├── Costs
        └── Degradation impact
        │
        ▼
Project Cash Flow
        │
        ▼
Financial KPIs
```

Operational results and financial valuation are related but are **not the same model**.

### 10.4 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operational | Dispatch results, energy shifted, peak reduction, DR performance, regulation service |
| **Inputs** | Degradation | Degradation cost basis, augmentation events, replacement events |
| **Inputs** | Financial Assumptions | Discount rate, escalation rates, contract term, incentive schedules |
| **Inputs** | Cost Data | CAPEX, OPEX, O&M costs, replacement costs |
| **Outputs** | Revenue | Annual revenue by stream, annual savings |
| **Outputs** | Costs | Annual costs, degradation cost, demand charge savings |
| **Outputs** | Cash Flow | Annual net cash flow |
| **Outputs** | KPIs | NPV, IRR (project and equity), simple payback |

### 10.5 Boundary

| Answers | Does Not Answer |
|---|---|
| What economic value results from the modeled project behavior? | How does the battery physically operate? |

---

## 11. Domain 7 — Data & Application Engineering

### 11.1 Purpose

Convert the analytical system into an **executable and usable software product** — the bridge between data, models, results, and users.

### 11.2 Primary Responsibility

| Category | Aspects |
|---|---|
| Data | Ingestion, transformation, validation, processing, storage, quality, lineage |
| Execution | Model execution, scenario configuration, parameter management, workflow orchestration |
| Application | Data input, scenario configuration, visualization, dashboards, comparison, reporting, export |
| Technology | Python, Databricks, PySpark, SQL, Databricks App |

### 11.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Technical | BESS parameters, inverter specifications |
| **Inputs** | Load | Meter data, demand profiles, billing data |
| **Inputs** | Market | Price projections, ancillary prices, capacity revenues |
| **Inputs** | Financial | Discount rate, escalation, contract term, incentives |
| **Inputs** | Regulatory | Grid constraints, eligibility rules |
| **Inputs** | User | Scenario definitions, parameter overrides |
| **Outputs** | Operational Results | Dispatch profiles, SOC profiles, operational metrics |
| **Outputs** | Financial Results | Revenue breakdowns, cash flows, NPV, IRR, payback |
| **Outputs** | Comparison | Scenario comparison views |
| **Outputs** | Reporting | Dashboards, exportable reports (PDF/Excel) |
| **Outputs** | Audit | Data lineage, execution logs, traceability |

### 11.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does the user provide information, execute models, and consume results? | The underlying BESS, operational, optimization, degradation, or financial logic |

---

## 12. Inter-Domain Contract

The seven domains must not be developed as isolated documents. Their relationships are governed by explicit conceptual contracts.

| From | To | Main Information |
|---|---|---|
| BESS Engineering | Operational | Physical capabilities and constraints |
| BESS Engineering | Optimization | Feasibility constraints |
| BESS Engineering | Degradation | Initial state and physical parameters |
| Load & Market | Operational | External operating conditions |
| Load & Market | Optimization | Prices, load, programs, grid conditions |
| Operational | Optimization | Service requirements and candidate strategies |
| Optimization | Degradation | Actual/forecast battery usage |
| Degradation | Optimization | Updated battery capability |
| Optimization | Financial | Dispatch and operational performance |
| Degradation | Financial | Degradation and replacement implications |
| Financial | Application | Financial KPIs and economic outputs |
| All domains | Data & Application | Data contracts and execution interfaces |

---

## 13. The System's Core Feedback Loop

The most important relationship in the entire model is not linear. It is a feedback system:

```
        ┌───────────────────────┐
        │    Load & Market      │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │     Operational       │
        │       Models          │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │       Dispatch        │
        │     Optimization      │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │   BESS State / Usage  │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │      Degradation      │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │ Updated BESS Capability│
        └───────────┬───────────┘
                    │
                    └──────────────► Dispatch
                                     
                    │
                    ▼
        ┌───────────────────────┐
        │   Financial Model     │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │   Project Value       │
        └───────────────────────┘
```

This feedback loop should become one of the **central architectural principles** of the future solution.

---

## 14. Domain Summary Table

| # | Domain | Purpose | Key Inputs | Key Outputs | Boundary |
|---|---|---|---|---|---|
| 1 | BESS Engineering | Physical representation | Technical parameters, efficiency, limits | State, capability, envelope, losses | What the BESS can do |
| 2 | Load & Market Engineering | External environment | Load, tariff, market, program, grid data | Load signals, price signals, constraints | What is outside the BESS |
| 3 | Operational Engineering | Use-case behavior | Physical, external, rules | Candidate actions, requirements, metrics | How each value stream uses BESS |
| 4 | Dispatch & Optimization | Coordination layer | Physical, external, operational, degradation | Dispatch, SOC trajectory, attribution | How to coordinate objectives |
| 5 | Degradation Engineering | Capability evolution | Operating history, environmental, physical | SOH, capacity, degradation cost basis | How usage changes the battery |
| 6 | Financial Engineering | Economic translation | Operational outputs, degradation, financial assumptions | Revenue, costs, cash flow, NPV, IRR | What value results |
| 7 | Data & Application Engineering | Execution and delivery | All data and models | Dashboards, reports, exports, audit | How users interact with the system |

---

## 15. What Is Deliberately NOT Defined Here

This document intentionally does **not** freeze:

### Mathematical Methods
- Exact degradation equations
- Exact forecasting methodology
- Optimization formulation
- Objective functions
- Solver selection

### Software Architecture
- Python package structure
- Classes, functions, APIs
- Databricks workspace structure
- Notebooks, services

### Data Architecture
- Physical tables, schemas
- Delta tables, partitioning
- Data pipeline implementation

### Financial Methodology
- Exact cash-flow formulation
- Tax treatment
- Financing structure
- Accounting treatment
- Specific financial assumptions

### UI
- Screen designs
- Dashboard layouts
- Interaction patterns

These decisions belong to subsequent engineering stages (A.2, B, C, D).

---

## 16. Engineering Sequence

This document establishes the **seven domains at eagle-eye level**.

The next engineering stage develops each domain independently while preserving the interfaces between them.

```
STEP A.1
System Component Definition (this document)
        │
        ▼
Seven Engineering Domains
        │
        ├── 1. BESS Engineering
        ├── 2. Load & Market Engineering
        ├── 3. Operational Engineering
        ├── 4. Dispatch & Optimization
        ├── 5. Degradation Engineering
        ├── 6. Financial Engineering
        └── 7. Data & Application Engineering
        │
        ▼
STEP A.2
Conceptual Engineering per Domain
(each domain receives its own document)
        │
        ├── A.2.1  BESS Engineering
        ├── A.2.2  Load & Market Engineering
        ├── A.2.3  Operational Engineering
        ├── A.2.4  Dispatch & Optimization Engineering
        ├── A.2.5  Degradation Engineering
        ├── A.2.6  Financial Engineering
        └── A.2.7  Data & Application Engineering
        │
        ▼
STEP B
System Architecture (Basic Engineering)
        │
        ▼
STEP C
Product Specification (Detailed Engineering)
        │
        ▼
STEP D
Implementation
        │
        ▼
Testing / Validation / UAT
```

The important point is that **Step A.1 does not engineer the seven domains yet**. It establishes their **identity, purpose, boundary, responsibility, inputs, outputs, and relationships**.

---

## 17. System-Level Definition

The resulting system can be stated as:

> **The BESS Operational & Financial Modeling System is an integrated analytical system that represents the physical capabilities and degradation of a BESS, its load and market environment, its operational value streams, and the dispatch decisions required to coordinate those value streams, and translates the resulting operational behavior into financial performance and decision-support outputs through an executable data and application platform.**

This is the **umbrella definition**. Everything built later should be traceable back to one of the seven domains or to an explicitly defined cross-domain interaction.

---

## 18. Design Principle

The seven domains should be treated as:

> **Separate in responsibility, integrated in behavior.**

```
                  SEPARATION
                     │
       ┌─────────────┼─────────────┐
       ▼             ▼             ▼
   Engineering   Engineering   Engineering
      Domain        Domain        Domain
       │             │             │
       └─────────────┼─────────────┘
                     ▼
                  INTEGRATION
                     │
                     ▼
              SYSTEM BEHAVIOR
                     │
                     ▼
              BUSINESS VALUE
```

This provides the correct **eagle-eye baseline** before entering the detailed conceptual engineering of each area.

---

## 19. Next Steps

The immediate next step is **Step A.2 — Conceptual Engineering per Domain**, developed one domain at a time, each with its own document.

The recommended sequence:

| Order | Document ID | Domain | Rationale |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | Physical foundation |
| 2 | A.2.2 | Load & Market Engineering | External environment |
| 3 | A.2.3 | Operational Engineering | Value stream behavior |
| 4 | A.2.4 | Dispatch & Optimization Engineering | Coordination logic |
| 5 | A.2.5 | Degradation Engineering | Dynamic state evolution |
| 6 | A.2.6 | Financial Engineering | Economic translation |
| 7 | A.2.7 | Data & Application Engineering | Execution and delivery |

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.1 — System Component Definition (Eagle-Eye View)
**Duration:** 12 Weeks
**Language:** English

---

