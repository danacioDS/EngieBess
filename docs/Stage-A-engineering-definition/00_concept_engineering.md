
---

# BESS Operational & Financial Modeling System
## Stage A — Engineering Definition
### Eagle-Eye View of the Seven Engineering Domains

**Document ID:** SYS-ENG-DEF-001

**Version:** 0.4 — Baseline for Review

**Status:** Stage A — Engineering Definition (Conceptual Level)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.6)

**Purpose:** Provide a system-level, eagle-eye definition of the seven engineering domains that constitute the BESS Operational & Financial Modeling System, establishing their identity, purpose, boundaries, responsibilities, inputs, outputs, and relationships — without entering into detailed conceptual engineering, architecture, or implementation.

---

## 1. Purpose of This Document

This document constitutes **Stage A — Engineering Definition** of the delivery framework defined in `SYS-STR-FRM-001` v0.6.

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
| **A.2** | Conceptual Engineering per Domain | Seven domain chapters, developed one at a time |

**This document covers Level A.1 only.** Each domain will subsequently receive its own Conceptual Engineering chapter at Level A.2.

**Packaging note.** Per `SYS-STR-FRM-001` §4.3, the seven A.2 chapters may be delivered as a **single consolidated document with seven chapters** rather than seven standalone files, if that better serves review velocity. The content requirements are identical; only the packaging differs.

---

## 2. Position of Stage A Within the Delivery Framework

Stage A sits at the beginning of the four-stage delivery philosophy defined in the System Strategy. The stage names, engineering equivalents, and purposes are defined in `SYS-STR-FRM-001` §4 and are not restated here, to avoid divergence between the two documents.

Stage A produces the conceptual engineering baseline. Stage B produces the architecture. Stage C produces the specification. Stage D produces the implementation, running in parallel with Stage C from week 3 onward.

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
              Dispatch & Optimization ─────────────────────┤
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

Two clarifications on the diagram:

- **Dispatch → Financial** is shown explicitly. Operational revenue arises from the dispatch schedule, not from degradation alone.
- **BESS and Load & Market are parallel inputs** to Operational Engineering, not sequential stages.

The system follows a fundamental causal backbone:

```
        Physical System ────┐
                            ├──► Operational Behavior
        External Environment┘         │
                                      ▼
                               Dispatch Decision
                                      │
                                      ▼
                             Battery State Evolution
                                      │
                                      ▼
                                  Degradation
                                      │
                                      ▼
                            Operational Performance
                                      │
                                      ▼
                                Economic Value
                                      │
                                      ▼
                             Financial Performance
                                      │
                                      ▼
                               Decision Support
```

Physical System and External Environment are **parallel inputs**, not a chain. This causal structure must be preserved in all subsequent stages.

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

### 4.1 Cross-Cutting Capabilities

Two capabilities span multiple domains. They are **not additional domains**.

**Scenario Management** (`SYS-STR-FRM-001` §8.1) parameterizes and orchestrates the domains. Its effect per domain:

| Domain | What Scenario Management varies |
|---|---|
| 1 — BESS | BESS configuration, capacity, power rating |
| 2 — Load & Market | Market scenario, price curves, program assumptions, forecast method |
| 3 — Operational | Which value streams are enabled |
| 4 — Dispatch | Methodology, prioritization, horizon |
| 5 — Degradation | Aging model fidelity, augmentation policy |
| 6 — Financial | Discount rate, escalation, contract term, financing, tax |
| 7 — Data & Application | Which scenario is loaded, which results are compared |

**Validation** (`SYS-STR-FRM-001` §8.2) operates at four levels and includes domain-specific checks:

| Domain | Representative domain-level validation |
|---|---|
| 1 — BESS | Energy balance; SOC consistency; power and ramp limits |
| 2 — Load & Market | Signal alignment; forecast plausibility; tariff structural validity |
| 3 — Operational | Mode-specific service requirements are satisfiable |
| 4 — Dispatch | Constraint compliance; SOC trajectory within bounds |
| 5 — Degradation | SOH monotonically non-increasing **between augmentation/replacement events**; EFC accumulation consistent |
| 6 — Financial | Cash-flow consistency; NPV/IRR internal consistency |
| 7 — Data & Application | Data lineage; execution reproducibility |

Validation must be defined **before** results are produced.

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
| SOH | State of Health as a state variable whose evolution is determined by Domain 5 |
| Efficiency | Round-trip and conversion losses |
| Operating limits | SOC bounds, power bounds, ramp limits |
| Inverter | AC/DC conversion, reactive capability |
| Thermal | Temperature as an input assumption, not a dynamic state |
| Availability | Physical availability, expressed as an availability factor and rest requirements |

### 5.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Technical Parameters | Battery configuration, nominal capacity, usable capacity, power rating, inverter rating |
| **Inputs** | Efficiency Characteristics | Round-trip efficiency, conversion losses |
| **Inputs** | Operating Limits | SOC bounds, power bounds, ramp limits, C-rate limits |
| **Inputs** | Environmental | Ambient or cell temperature profile (input assumption) |
| **Inputs** | Policy | Augmentation policy, replacement policy, availability assumptions |
| **Outputs** | State | SOC, SOH, availability condition |
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
| Load | Historical consumption, interval profiles, demand patterns, peak demand |
| Load forecasting | **Short-horizon forecast** for dispatch, and **multi-year projection** for contract-term scenarios — treated as distinct capabilities with different methods |
| Energy Markets | Electricity price curves (TOU, LMP, ancillary, capacity) consumed as **inputs**; prices do not emerge from the model |
| Programs | Demand-response rules, event windows, notification, performance requirements, penalties |
| Grid / Regulatory | Interconnection limits, export constraints, eligibility, operating restrictions |
| Tariff engine | Applies the customer tariff to compute the bill. Invoked **twice**: once on the historical/reference load to establish the bill **without** BESS, and once on the **net load** (after dispatch) to establish the bill **with** BESS. The difference is the tariff-based savings. |

### 6.3 Tariff Engine — Boundary Note

The tariff engine lives in Domain 2 because **Domain 2 owns the tariff structure**. However, computing the bill *with* BESS requires the **net load**, which is a **result of dispatch** (Domain 4).

The dependency is therefore:

```
Domain 4 (Dispatch)  ─── net load ───►  Domain 2 (Tariff engine)  ─── bill with BESS ───► Domain 6
```

Domain 2 does not perform dispatch. It receives the net load **after** dispatch and applies the tariff to it. This preserves the boundary: Domain 2 owns the tariff logic, Domain 4 owns the dispatch decision, and Domain 6 owns the economic evaluation.

### 6.4 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Load Data | Historical meter data, interval profiles, demand profiles, peak demand |
| **Inputs** | Tariff Data | TOU structures, demand charge structures, energy charge structures |
| **Inputs** | Market Data | Day-ahead LMP, real-time LMP, ancillary service prices, capacity prices |
| **Inputs** | Program Data | DR program parameters, event windows, notification rules, penalties |
| **Inputs** | Grid Data | Interconnection limits, export constraints, eligibility rules |
| **Inputs** | Regulatory Data | Applicable grid requirements, operating restrictions |
| **Inputs** | Net Load (post-dispatch) | Net load after BESS dispatch, from Domain 4 |
| **Outputs** | Load Signals | Short-horizon forecast, multi-year projection, baseline consumption, peak projections |
| **Outputs** | Price Signals | Electricity price curves, ancillary price curves, capacity revenues |
| **Outputs** | Program Signals | DR event definitions, program constraints, participation rules |
| **Outputs** | Constraint Signals | Grid constraints, regulatory constraints, eligibility envelope |
| **Outputs** | Bill Outputs | Customer bill with and without BESS, per tariff, per scenario |

### 6.5 Boundary

| Answers | Does Not Answer |
|---|---|
| What is happening outside the BESS, and what tariff applies? | How should the BESS respond? |

---

## 7. Domain 3 — Operational Engineering

### 7.1 Purpose

Define **how the BESS can be used to provide specific services or value streams**, transforming business/use-case requirements into operational behavior.

### 7.2 Primary Responsibility

| Value Stream | Description | Application |
|---|---|---|
| Peak Shaving | Reduce site demand during relevant peak periods | Behind-the-meter |
| Demand Response | Respond to externally defined DR events per program rules | Behind-the-meter and front-of-meter (program-dependent) |
| Energy Arbitrage | Charge and discharge according to price differentials | Both |
| Frequency Regulation | Provide fast-response charging/discharging around an operating point | Front-of-meter and behind-the-meter (market-dependent) |
| Voltage Regulation | Provide reactive-power support subject to inverter capability | Both; couples to Domain 1 via inverter apparent-power limit |

### 7.3 Modeling Traps

The following traps are **named here** and resolved in A.2.3 and A.2.4:

- **Peak shaving** — demand charges apply to the monthly maximum, so value is not separable hour by hour; the optimization horizon or rolling-window design must account for the billing period.
- **Demand response** — events are not known in advance; requires reserve-capacity or event-scenario treatment, not perfect foresight.
- **Frequency regulation** — a 15-minute or hourly model cannot follow a regulation signal; requires capacity reservation plus a statistical energy-throughput and SOC-drift representation.
- **Voltage regulation** — the inverter's apparent-power limit couples active and reactive power (P² + Q² ≤ S²); this is nonlinear and requires linearization under LP/MILP.

### 7.4 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | BESS capabilities, feasible operating envelope |
| **Inputs** | External | Load conditions, price signals, tariff structures |
| **Inputs** | Rules | Program rules, grid constraints, operating requirements |
| **Outputs** | Actions | Candidate operational actions per value stream |
| **Outputs** | Requirements | Service requirements, dispatch requirements |
| **Outputs** | Constraints | Operational constraints per mode |
| **Outputs** | Metrics | Service-level metrics, expected operational results |

### 7.5 Boundary

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
| Competing value streams | Co-optimize across value streams |

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
| **Inputs** | Degradation | Current SOH, available capacity, **marginal degradation cost** |
| **Inputs** | Value Signals | Market prices, TOU tariffs, **demand charge rates**, program payments, reserve prices |
| **Outputs** | Dispatch | Charge/discharge/rest schedule (time series) |
| **Outputs** | State | SOC trajectory over optimization horizon |
| **Outputs** | Net Load | Net load profile after BESS dispatch (to Domain 2 tariff engine) |
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
| Temperature | Thermal influence on aging (temperature as input, per Domain 1) |
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

### 9.4 Interface to Dispatch — Marginal Degradation Cost

Degradation Engineering provides Dispatch with two distinct outputs:

- **Updated capacity** — the physical capability available in future periods
- **Marginal degradation cost** — a per-MWh signal representing the economic cost of consuming one more unit of battery throughput

**Marginal degradation cost is a derived operational signal** (per `SYS-STR-FRM-001` §6.4). It combines:

- a **physical input** — lifetime throughput, owned by Domain 5
- a **scenario input** — replacement cost, provided as a **financial scenario assumption**

Degradation Engineering is the **owner of this derived signal**. The replacement cost is a **financial scenario input** (like discount rate, CAPEX, or escalation) — not a computed result of Domain 6. Domain 5 transforms it into a per-MWh signal. Domain 4 consumes it as an operational input.

This is the mechanism by which an investment assumption (replacement cost) legitimately enters dispatch: **only via a documented, derived operational signal**.

### 9.5 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operating History | Dispatch decisions, battery throughput, cycle counts |
| **Inputs** | Environmental | Temperature conditions, average SOC |
| **Inputs** | Physical | Initial state, physical parameters |
| **Inputs** | Scenario Assumption | **Replacement cost** (financial scenario input) |
| **Inputs** | Policy | Augmentation policy, replacement thresholds |
| **Outputs** | State | Updated SOH, remaining capacity |
| **Outputs** | Metrics | Degradation metrics, equivalent cycles |
| **Outputs** | Dispatch Signal | **Marginal degradation cost** |
| **Outputs** | Cost Basis | Physical cost basis (throughput), replacement implications |
| **Outputs** | Events | Augmentation events, replacement events |
| **Outputs** | Constraints | Updated operating constraints |

### 9.6 Boundary

| Answers | Does Not Answer |
|---|---|
| How does operating the battery change the battery over time, and what does one more unit of throughput cost? | What is the total economic value of that degradation over the contract term? |

Full economic valuation belongs to Financial Engineering.

---

## 10. Domain 6 — Financial Engineering

### 10.1 Purpose

Translate operational behavior into **project-level economic performance**, representing the economic consequences of investment, operation, revenue, savings, costs, degradation, augmentation, replacement, and incentives.

### 10.2 Primary Responsibility

| Category | Aspects |
|---|---|
| Investment | CAPEX, installation, augmentation, replacement |
| Operating Economics | O&M, electricity costs, market costs |
| Value | Peak-shaving savings, DR revenue, arbitrage revenue, regulation revenue |
| Financial Evaluation | Cash flows, NPV, IRR, payback, annual revenue, annual savings |
| Financing | Debt parameters for equity IRR |
| Tax & Incentives | ITC, depreciation, tax treatment (market-dependent) |
| Convention | Currency, nominal vs. real |
| Perspective | Commercial perspective (ENGIE vs. client) |

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
        ├── Revenue (from D4 attribution)
        ├── Savings (from D2 tariff engine)
        ├── Costs
        └── Degradation impact (see §10.5)
        │
        ▼
Project Cash Flow
        │
        ▼
Financial KPIs
```

Operational results and financial valuation are related but are **not the same model**.

### 10.4 Single Source of Truth for Value

Two value categories arise in this system, and each has **exactly one source of truth**. Double counting is prohibited.

| Value category | Source of truth | Rationale |
|---|---|---|
| **Behind-the-meter savings** — demand charge reduction, energy charge reduction | **Domain 2 — Tariff engine** | Only the tariff engine knows the tariff structure and can compute the bill with and without BESS |
| **Market revenues** — LMP arbitrage, frequency regulation, DR payments, capacity payments | **Domain 4 — Revenue attribution per value stream** | Only Dispatch knows how much of each service was actually delivered |

**Peak shaving is a special case.** The *physical* peak reduction is a dispatch outcome. The *economic* value of that peak reduction is a tariff saving, and it is computed **only** by the tariff engine (Domain 2). Domain 4's revenue attribution must therefore **not** create a separate "peak shaving revenue" line — it must defer to the tariff engine's output.

This rule eliminates the peak-shaving double-counting risk identified during review.

### 10.5 Degradation Cost — Avoiding Double Counting

Degradation enters the model in **two different places**, and they must not be double-counted:

| Where | What it represents | Effect |
|---|---|---|
| **Dispatch objective** | Marginal degradation cost (from Domain 5) | Shapes the dispatch decision; a **signal**, not a cash flow |
| **Project cash flow** | Actual augmentation and replacement cash flows | Real money spent; enters the cash flow |

**Rule:**

- The marginal degradation cost is **only a dispatch signal**. It never appears as a line item in the cash flow.
- The cash flow contains **only real flows**: CAPEX, OPEX, augmentation, replacement, revenue, savings.
- The economic consequence of degradation is captured by reduced future capability (which reduces future revenue) and by the actual augmentation/replacement flows.

### 10.6 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operational | Dispatch results, energy shifted, peak reduction, DR performance, regulation service |
| **Inputs** | Degradation | Augmentation events, replacement events, physical cost basis |
| **Inputs** | Tariff Bill Outputs | Bill with and without BESS, per tariff (from Domain 2) |
| **Inputs** | Financial Assumptions | Discount rate, escalation rates, contract term, incentive schedules |
| **Inputs** | Financing | Debt parameters for equity IRR |
| **Inputs** | Tax | Tax and incentive parameters |
| **Inputs** | Cost Data | CAPEX, OPEX, O&M costs, replacement costs |
| **Outputs** | Revenue | Annual revenue by stream, annual savings |
| **Outputs** | Costs | Annual costs, demand charge savings |
| **Outputs** | Cash Flow | Annual net cash flow |
| **Outputs** | KPIs | NPV, IRR (project and equity), simple payback |

### 10.7 Boundary

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
| BESS Engineering | Dispatch | Feasibility constraints |
| BESS Engineering | Degradation | Initial state and physical parameters |
| Load & Market | Operational | External operating conditions |
| Load & Market | Dispatch | Prices, load, programs, grid conditions |
| Operational | Dispatch | Service requirements and candidate strategies |
| Dispatch | Degradation | Actual/forecast battery usage |
| Degradation | Dispatch | Updated capacity, **marginal degradation cost** |
| Dispatch | Financial | Dispatch results and operational performance; **market revenue attribution** |
| Dispatch | Load & Market | **Net load (post-dispatch)** for tariff engine |
| Load & Market | Financial | **Bill with and without BESS (tariff engine output)** — source of truth for behind-the-meter savings |
| Degradation | Financial | Augmentation and replacement events; physical cost basis |
| **Scenario / Financial assumptions** | **Degradation** | **Replacement cost** (financial scenario input) |
| Financial | Application | Financial KPIs and economic outputs |
| All domains | Data & Application | Data contracts and execution interfaces |
| Scenario Management | All domains | Scenario parameterization and orchestration |
| Validation | All domains | Validation criteria and evidence |

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
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
Updated BESS Capability   Marginal Degradation Cost
        │                       │
        └──────────► Dispatch ◄─┘
                    │
                    │ Operational Outputs
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

The feedback to Dispatch is shown as **two paths**: updated capability (physical) and marginal degradation cost (economic). The output to the Financial Model is a separate downstream path, not a branch of the feedback loop.

This feedback loop is one of the **central architectural principles** of the future solution.

---

## 14. Domain Summary Table

| # | Domain | Purpose | Key Inputs | Key Outputs | Boundary |
|---|---|---|---|---|---|
| 1 | BESS Engineering | Physical representation | Technical parameters, efficiency, limits, temperature profile | State, capability, envelope, losses | What the BESS can do |
| 2 | Load & Market Engineering | External environment + tariff | Load, tariff, market, program, grid data; net load (post-dispatch) | Load signals, price signals, constraints, **bill outputs** | What is outside the BESS |
| 3 | Operational Engineering | Use-case behavior | Physical, external, rules | Candidate actions, requirements, metrics | How each value stream uses BESS |
| 4 | Dispatch & Optimization | Coordination layer | Physical, external, operational, degradation, value signals | Dispatch, SOC trajectory, net load, attribution | How to coordinate objectives |
| 5 | Degradation Engineering | Capability evolution | Operating history, environmental, physical, replacement cost (scenario) | SOH, capacity, **marginal degradation cost**, events | How usage changes the battery |
| 6 | Financial Engineering | Economic translation | Operational outputs, degradation, bill outputs, financial assumptions | Revenue, costs, cash flow, NPV, IRR | What value results |
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
- Tax treatment — **default: pre-tax**; see `SYS-STR-FRM-001` §12.2 D9
- Financing structure — **default: project IRR primary; equity IRR computed with default debt parameters, configurable by the user**; see `SYS-STR-FRM-001` §12.2 D8
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
(seven chapters, consolidated or standalone)
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

The immediate next step is **Step A.2 — Conceptual Engineering per Domain**, developed one domain at a time.

**Recommended sequence, prioritizing the thin-slice blockers:**

| Order | Document ID | Domain | Rationale |
|---|---|---|---|
| 1 | A.2.4 | Dispatch & Optimization Engineering | Blocks the week-4 thin slice; highest technical risk |
| 2 | A.2.5 | Degradation Engineering | Blocks the week-4 thin slice; feedback loop is architecturally critical |
| 3 | A.2.1 | BESS Engineering | Physical foundation; can be written in parallel |
| 4 | A.2.2 | Load & Market Engineering | External environment; feeds Dispatch and Financial |
| 5 | A.2.3 | Operational Engineering | Value stream behavior; depends on A.2.1 and A.2.2 |
| 6 | A.2.6 | Financial Engineering | Economic translation; depends on all upstream |
| 7 | A.2.7 | Data & Application Engineering | Execution and delivery; last |

This ordering differs from the earlier 1→7 sequence. The reason is that **A.2.4 and A.2.5 are the domains whose design decisions determine whether the thin end-to-end slice can be delivered on time**. A.2.1 and A.2.2 can proceed in parallel without blocking it.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.1 — System Component Definition (Eagle-Eye View)
**Duration:** 12 Weeks
**Language:** English

----
**Addendum:** Additional Clarification Requests (from Stage A.1)

1. Tariff detail. Savings are calculated by applying the customer's full tariff to the load with and without the battery. We need the complete tariff structures, including:
demand ratchets,
coincident-peak charges,
billing-period definitions,
any minimum-bill or fixed components.
2. Simplified tariffs can materially over- or understate peak-shaving value.
3. Export and net metering. Can the battery export to the grid in behind-the-meter configurations? If so, under what compensation rules (net metering, export tariff, or none)?
4. Augmentation and replacement policy. What are ENGIE's standard assumptions? Specifically:
the end-of-life threshold (e.g., 70% or 80% state of health),
whether capacity is maintained by initial overbuild or by periodic augmentation,
the replacement and augmentation cost trajectory over time.
These assumptions also set the per-MWh degradation cost used in dispatch decisions.
5. Operating temperature. Is site ambient temperature data available, or should we assume a climate-controlled enclosure with a fixed temperature? Temperature is an input to both efficiency and aging.
6. Availability. What availability factor should be assumed? Proposal: 97–98%, configurable.
Reference projects for validation. Could ENGIE provide two or three existing or proposed projects, with their data and internal valuations, to use as reference cases? This complements the public benchmarks in item 17 and makes acceptance more meaningful for business development users.
7. Presentation of value. The tool will report customer bill savings (from the tariff calculation) separately from market revenues (from dispatch), so that value is never double-counted. Please confirm this split matches how ENGIE presents value to clients and to internal investment committees.