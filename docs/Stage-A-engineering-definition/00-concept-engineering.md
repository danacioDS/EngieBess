# SYS-ENG-DEF-001 — Stage A.1 — System Component Definition (v0.6.1 — Errata Applied)

---

# BESS Operational & Financial Modeling System
## Stage A — Engineering Definition
### Eagle-Eye View of the Seven Engineering Domains

**Document ID:** SYS-ENG-DEF-001

**Version:** 0.6.1 — Consolidated Baseline (Errata Applied)

**Status:** Stage A — Engineering Definition (Conceptual Level) — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Language:** English

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)
- `STAGE-A-CONSOL-REPORT-001` — Stage A Consolidation Report (v1.1)

**Purpose:** Provide a system-level, eagle-eye definition of the seven engineering domains that constitute the BESS Operational & Financial Modeling System, establishing their identity, purpose, boundaries, responsibilities, inputs, outputs, and relationships — without entering into detailed conceptual engineering, architecture, or implementation.

**Change log.** See §21.

---

## 1. Purpose of This Document

This document constitutes **Stage A — Engineering Definition** of the delivery framework defined in `SYS-STR-FRM-001` v0.9.

Its purpose is to establish the **system-level decomposition** of the BESS Operational & Financial Modeling Solution into **seven major engineering domains**, operating within a **System Context**, and to define each domain at a conceptual, eagle-eye level.

This document is deliberately **not** a detailed conceptual engineering document, nor a mathematical specification, nor an architecture document, nor a product specification.

Instead, it establishes:

- What each engineering domain represents
- Why the domain exists
- What its responsibility is
- What information it consumes
- What information it produces
- How it interacts with the other domains
- **Where the System Context enters each domain**
- Where each domain's boundary begins and ends
- What must subsequently be developed during detailed conceptual engineering

The seven domains form a **coherent integrated system**. They shall not be treated as seven independent models.

### 1.1 Structure of Stage A

Stage A is delivered in two levels:

| Level | Name | Deliverable |
|---|---|---|
| **A.1** | System Component Definition | This document — eagle-eye view of the seven domains |
| **A.2** | Conceptual Engineering per Domain | Seven domain chapters (A.2.1–A.2.7) |

**This document covers Level A.1 only.**

**Status note.** As of this revision, **Stage A.2 is conceptually and formally complete**. All seven domain chapters (A.2.1–A.2.7) have been developed, consolidated, and integrated. The **Stage A Consolidation Audit** has been completed and Stage A is **CLOSED**. The next step is **Stage B — System Architecture (HLD)**, which is also complete and frozen.

**Packaging note.** Per `SYS-STR-FRM-001` §4.3, the seven A.2 chapters may be delivered as a **single consolidated document with seven chapters** rather than seven standalone files, if that better serves review velocity.

### 1.2 What This Document Does Not Repeat

This document does **not** repeat `SYS-STR-FRM-001` §3.4 (System Context definition). It **operationalizes** it: for each System Context dimension, it declares **which domains receive the impact, and through which interface**.

---

## 2. Position of Stage A Within the Delivery Framework

Stage A sits at the beginning of the four-stage delivery philosophy defined in the System Strategy. The stage names, engineering equivalents, and purposes are defined in `SYS-STR-FRM-001` §4 and are not restated here.

Stage A produces the conceptual engineering baseline. Stage B produces the architecture. Stage C produces the specification. Stage D produces the implementation, running in parallel with Stage C from week 3 onward.

**Status at this revision:**
- Stage A — **CLOSED** (tag: `stage-a-closed`)
- Stage B — **Frozen** (B.0–B.6 + Index v0.2 + Handoff v0.1)
- Stage C — **Next**

---

## 3. System-Level View

The solution operates **within a System Context** (External Context + Project Configuration) declared in `SYS-STR-FRM-001` §3.4. The System Context is not an eighth domain; it is a framing concept whose effects propagate into the seven domains through explicit interfaces.

### 3.1 Context and Domains

```
                        SYSTEM CONTEXT
     ┌──────────────────────────────────────────────┐
     │ External Context                             │
     │  Generation · Grid · Load · Market           │
     │                                              │
     │ Project Configuration                        │
     │  BESS / Topology / Coupling                  │
     └──────────────────┬───────────────────────────┘
                        │
                        │ context-derived signals
                        │ & constraints
                        ▼
        ┌───────────────────────────────────────┐
        │      SEVEN ENGINEERING DOMAINS        │
        └───────────────────────────────────────┘
```

### 3.2 System-Level Structure

```
                 SYSTEM CONTEXT
     ┌──────────────┬──────────────┐
     │ External     │ Project      │
     │ Context      │ Configuration│
     └──────┬───────┴──────┬───────┘
            │              │
            ▼              ▼
       ┌─────────────────────────┐
       │   ENGINEERING DOMAINS   │
       └────────────┬────────────┘
                    │
                    ▼
             OPERATIONAL STATE
                    │
                    ▼
              DISPATCH DECISION
                    │
                    ▼
              BESS STATE EVOLUTION
                    │
                    ▼
               DEGRADATION
                    │
              ┌─────┴─────┐
              │           │
              ▼           └──► Future Capability
        FINANCIAL VALUE
```

**System Context does not transform the BESS physical system.** It affects it only through the operation it induces. This is a central principle of the system.

---

## 4. The Seven Engineering Domains

The solution is decomposed into the following seven domains:

| # | Domain | Primary Question | Context Interface |
|---|---|---|---|
| 1 | **BESS Engineering** | What physical system are we modeling? | *(No permanent context interface — Generation is an architecture extension, activated only if PH-004 confirms co-location)* |
| 2 | **Load & Market Engineering** | What external signals, tariffs, market mechanisms and constraints affect the system? | **Owns the External Context interface** |
| 3 | **Operational Engineering** | How do those conditions translate into feasible use cases? | Consumes Context + Market signals |
| 4 | **Dispatch & Optimization** | How are physical, operational and economic objectives coordinated? | Consumes context signals from Domain 2 |
| 5 | **Degradation Engineering** | How does operation change future BESS capability? | Indirectly influenced by Generation and Market (via induced operation) |
| 6 | **Financial Engineering** | What economic value results from the modeled system? | Consumes operational results and tariff bill outputs |
| 7 | **Data & Application Engineering** | How is the integrated model executed and consumed? | Provides execution infrastructure for all domains |

These domains are **logical engineering boundaries**, not necessarily seven software modules.

**Ownership principle.** Domain 2 owns the External Context interface (`SYS-STR-FRM-001` §3.5). Project Configuration is a scenario parameter, managed by Scenario Management. No other domain owns a System Context dimension; all others consume context-derived signals.

### 4.1 Cross-Cutting Capabilities

Two capabilities span the domains:

**Scenario Management** parameterizes and orchestrates the domains, including **Project Configuration** as a scenario parameter.

**Validation** operates at four levels: domain, model, system, UAT.

---

## 5. System Context — Operationalization

The following sections declare, for each System Context dimension, **how it enters the seven domains**.

### 5.1 Generation

**Scope note.** Generation is an **architecture extension**, not part of the initial delivery scope (`SYS-STR-FRM-001` §3.1). It is activated only if Phase 1 clarification **PH-004** confirms a co-located or integrated configuration. The interfaces below describe how Generation **would** propagate when activated; they do not represent a delivery commitment.

**Context-to-domain impact:**

| Domain | How Generation affects it |
|---|---|
| **1 — BESS Engineering** | Available external charging power, coupling limits, interconnection constraints — **but not the battery's intrinsic physical capability** |
| **2 — Load & Market Engineering** | Representation of generation profiles as net-load signals *(extension)* |
| **3 — Operational Engineering** | Whether "solar surplus → charge → avoid curtailment" is a viable use case *(extension)* |
| **4 — Dispatch** | A primary input to the optimization: what generation is available at each moment *(extension)* |
| **5 — Degradation** | Indirectly — via the charging behavior it induces |
| **6 — Financial** | Energy shifted, curtailment avoided, revenue and savings *(extension)* |

**Critical distinction.** Generation affects **availability and imposed constraints**, not intrinsic physical capability. A 100 MW / 200 MWh battery remains 100 MW / 200 MWh even if only 40 MW of generation are available to charge it.

### 5.2 Grid / Network

**Context-to-domain impact:**

| Domain | How Grid / Network affects it |
|---|---|
| **1 — BESS Engineering** | AC-side power bounds via interconnection limits |
| **2 — Load & Market Engineering** | Import / export constraints, congestion, connection topology |
| **3 — Operational Engineering** | Which value streams are technically feasible |
| **4 — Dispatch** | Import / export limits → feasible power exchange |
| **5 — Degradation** | No material interface |
| **6 — Financial** | Export feasibility → market participation |

### 5.3 Load / Demand

**Context-to-domain impact:**

| Domain | How Load / Demand affects it |
|---|---|
| **1 — BESS Engineering** | No material interface |
| **2 — Load & Market Engineering** | Physical load profile → tariff engine |
| **3 — Operational Engineering** | Peak / energy windows → viable use cases |
| **4 — Dispatch** | Net load requirement → dispatch objective |
| **5 — Degradation** | No material interface |
| **6 — Financial** | Demand charge savings, energy charge savings |

### 5.4 Market

**Context-to-domain impact:**

| Domain | How Market affects it |
|---|---|
| **1 — BESS Engineering** | No material interface |
| **2 — Load & Market Engineering** | Representation of price signals, market rules, ancillary products, participation constraints |
| **3 — Operational Engineering** | Whether a market product is available as a value stream |
| **4 — Dispatch** | A primary input to the optimization: which products can be monetized |
| **5 — Degradation** | Indirectly — via induced cycling |
| **6 — Financial** | Actual service delivered × price → revenue attribution |

### 5.5 Project Configuration

**Context-to-domain impact:**

| Domain | How Project Configuration affects it |
|---|---|
| **1 — BESS Engineering** | Determines coupling type, topology |
| **2 — Load & Market Engineering** | Determines BTM vs. FTM, and which tariff and market mechanisms apply |
| **3 — Operational Engineering** | Determines which value streams are physically available |
| **4 — Dispatch** | Determines the feasible operating space |
| **5 — Degradation** | Determines thermal coupling and cycling pattern |
| **6 — Financial** | Determines applicable revenue streams |
| **7 — Data & Application** | Determines scenario parameterization |

Project Configuration is a **scenario parameter**, not a domain. It is owned by Scenario Management.

### 5.6 Summary Matrix

| System Context | BESS | Load & Market | Operational | Dispatch | Degradation | Financial | Data/App |
|---|---:|---:|---:|---:|---:|---:|---:|
| **Generation** | I | I | I | I | I* | I | I |
| **Grid / Network** | I | I | I | I | — | I | I |
| **Load / Demand** | — | I | I | I | — | I | I |
| **Market** | — | I | I | I | I* | I | I |
| **Project Configuration** | I | I | I | I | I | I | I |

**I = relevant interface / impact.**
**I\* = indirect impact** (via induced operation).
**— = no material interface.**

> **The matrix identifies impact relationships, not domain ownership.** A system-context dimension may affect multiple domains, while each domain remains responsible for a defined engineering concern.

---

## 6. Domain 1 — BESS Engineering

### 6.1 Purpose

Define the **physical and technical representation of the battery energy storage system**, establishing the physical capabilities and constraints that any operational strategy or optimization must respect.

### 6.2 Primary Responsibility

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

### 6.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Technical Parameters | Battery configuration, nominal capacity, usable capacity, power rating, inverter rating |
| **Inputs** | Efficiency Characteristics | Round-trip efficiency, conversion losses |
| **Inputs** | Operating Limits | SOC bounds, power bounds, ramp limits, C-rate limits |
| **Inputs** | Environmental | Ambient or cell temperature profile (input assumption) |
| **Inputs** | Policy | Augmentation policy, replacement policy, availability assumptions (via Scenario Management) |
| **Outputs** | State | SOC, SOH, availability condition |
| **Outputs** | Capability | Available energy, available charging power, available discharging power |
| **Outputs** | Envelope | Feasible operating envelope, physical feasibility conditions |
| **Outputs** | Losses | Conversion losses, efficiency at current operating point |
| **Outputs** | Information | Operating limits, battery state information |

### 6.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What can the physical BESS do? | What should the BESS do economically? **What external context is available?** |

BESS Engineering declares **intrinsic capability**. System Context declares **availability and imposed constraints**. These are separate.

**Reference.** Detailed conceptual engineering: `A.2.1-BESS-ENG-001` v1.3.

---

## 7. Domain 2 — Load & Market Engineering

### 7.1 Ownership of the External Context

Per `SYS-STR-FRM-001` §3.5, Domain 2 owns the External Context interface. The following dimensions are produced by this domain for consumption by the other domains:

- Generation signals *(architecture extension, per §5.1)*
- Grid / Network constraints
- Load / Demand signals
- Market signals (via adapters)

Project Configuration is **not** produced by this domain. It is a scenario parameter managed by Scenario Management.

### 7.2 Purpose

Represent the **External Context** — the electricity demand, tariffs, market prices, grid conditions, program rules, and (as architecture extension) generation signals that determine the BESS's potential value.

### 7.3 Primary Responsibility

| Sub-Area | Description |
|---|---|
| Load | Historical consumption, interval profiles, demand patterns, peak demand |
| Load forecasting | **Short-horizon forecast** for dispatch, and **multi-year projection** for contract-term scenarios |
| Generation signals *(extension)* | Representation of generation profiles as net-load signals |
| Energy Markets | Electricity price curves (TOU, LMP, ancillary, capacity) consumed as **inputs** |
| Programs | Demand-response rules, event windows, notification, performance requirements, penalties |
| Grid / Regulatory | Interconnection limits, export constraints, eligibility, operating restrictions |
| Tariff engine | Applies the customer tariff to compute the bill, invoked twice per billing period |

### 7.4 Tariff Engine — Boundary Note

The tariff engine lives in Domain 2 because **Domain 2 owns the tariff structure**. However, computing the bill *with* BESS requires the **net load**, which is a **result of dispatch** (Domain 4).

```
Domain 4 (Dispatch)  ─── battery power trajectory ───►  Domain 2 (Tariff engine)  ─── bill with BESS ───► Domain 6
```

**Note.** The net load is **composed by the Tariff Engine** from three components: base load + battery power trajectory + auxiliary consumption. Dispatch delivers the **battery power trajectory**, not the net load. This rule was resolved in Stage B (B.2 v0.5.1 §4.3).

### 7.5 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Load Data | Historical meter data, interval profiles, demand profiles, peak demand |
| **Inputs** | Generation Data *(extension)* | Renewable generation profiles, curtailment conditions |
| **Inputs** | Tariff Data | TOU structures, demand charge structures, energy charge structures, power factor penalties (**PH-021**) |
| **Inputs** | Market Data | Day-ahead LMP, real-time LMP, ancillary service prices, capacity prices |
| **Inputs** | Program Data | DR program parameters, event windows, notification rules, penalties |
| **Inputs** | Grid Data | Interconnection limits, export constraints, eligibility rules |
| **Inputs** | Regulatory Data | Applicable grid requirements, operating restrictions |
| **Inputs** | Battery power trajectory (post-dispatch) | Battery power trajectory from Domain 4; the Tariff Engine composes the net load |
| **Outputs** | Load Signals | Short-horizon forecast, multi-year projection, baseline consumption, peak projections |
| **Outputs** | Generation Signals *(extension)* | Available generation, charge opportunity, curtailment envelope |
| **Outputs** | Price Signals | Electricity price curves, ancillary price curves, capacity revenues |
| **Outputs** | Program Signals | DR event definitions, program constraints, participation rules |
| **Outputs** | Constraint Signals | Grid constraints, regulatory constraints, eligibility envelope |
| **Outputs** | Context Signals | Aggregated External Context signals consumed by other domains |
| **Outputs** | Bill Outputs | Customer bill with and without BESS, per tariff, per scenario |

**Note.** Generation-related inputs and outputs are **architecture extension** per `SYS-STR-FRM-001` §3.1. They are activated only if Phase 1 clarification **PH-004** confirms a co-located or integrated configuration.

### 7.6 Boundary

| Answers | Does Not Answer |
|---|---|
| What is happening outside the BESS, and what tariff applies? | How should the BESS respond? |

**Reference.** Detailed conceptual engineering: `A.2.2-LOAD-MKT-ENG-001` v1.3.

---

## 8. Domain 3 — Operational Engineering

### 8.1 Purpose

Define **how the BESS can be used to provide specific services or value streams**, transforming business/use-case requirements into operational behavior.

### 8.2 Primary Responsibility

| Value Stream | Description | Application |
|---|---|---|
| Peak Shaving | Reduce site demand during relevant peak periods | Behind-the-meter |
| Demand Response | Respond to externally defined DR events per program rules | Behind-the-meter and front-of-meter (program-dependent) |
| Energy Arbitrage | Charge and discharge according to price differentials | Both |
| Frequency Regulation | Provide fast-response charging/discharging around an operating point | Front-of-meter and behind-the-meter (market-dependent) |
| Voltage Regulation | Provide reactive-power support subject to inverter capability | Both; couples to Domain 1 via inverter apparent-power limit |

### 8.3 Modeling Traps

| Trap | Resolution |
|---|---|
| **Peak shaving** | Demand charges apply to the monthly maximum; the optimization horizon must account for the billing period |
| **Demand response** | Events are not known in advance; requires reserve-capacity or event-scenario treatment |
| **Frequency regulation** | A 15-min or hourly model cannot follow a regulation signal; requires capacity reservation plus statistical throughput and SOC drift |
| **Voltage regulation** | P² + Q² ≤ S² couples active and reactive power; treated as fixed envelope under **PH-041** |

### 8.4 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | BESS capabilities, feasible operating envelope |
| **Inputs** | External | Load conditions, price signals, tariff structures |
| **Inputs** | Rules | Program rules, grid constraints, operating requirements |
| **Outputs** | Requirements | Operational requirements per value stream (SOC floors, duration floors, reserve requirements, ramp requirements) |
| **Outputs** | Service Metrics | Service-level metrics, expected operational results |
| **Outputs** | Constraints | Operational constraints per mode |

### 8.5 Boundary

| Answers | Does Not Answer |
|---|---|
| How does each value stream use the BESS? | Which value stream should receive priority when several compete? |

Operational Engineering declares **operational requirements**. Dispatch selects the actual behavior.

**Terminology alignment.** This document uses **operational requirements** in place of the term *candidate actions* used in previous versions. This aligns with `A.2.3-OPS-ENG-001` v1.4 §4, which establishes that Operational Engineering defines **what behavior must occur if the service is provided**, not **what action should be scheduled**.

**Reference.** Detailed conceptual engineering: `A.2.3-OPS-ENG-001` v1.4.

---

## 9. Domain 4 — Dispatch & Optimization Engineering

### 9.1 Purpose

Act as the **coordination layer between competing operational objectives**.

### 9.2 Primary Responsibility

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

### 9.3 Conceptual Optimization Structure

```
                Value Streams
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
      Peak Shaving   DR     Arbitrage
          │          │          │
          └──────────┼──────────┘
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

### 9.4 Methodology

| Option | Characteristic |
|---|---|
| Rule-based heuristic | Deterministic and transparent |
| Linear Programming (LP) | Optimization of a linear formulation |
| Mixed-Integer Programming (MILP) | Optimization with discrete decisions |
| Hybrid | Combination of deterministic rules and optimization |

**Working default** per **PH-034** is **LP**. Other methodologies are revisable if ENGIE indicates otherwise.

### 9.5 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | Feasible operating envelope, SOC bounds, power limits, ramp limits |
| **Inputs** | External | Load forecast, price signals, program rules |
| **Inputs** | System Context | Generation signals, Grid constraints, Load signals, Market products (from Domain 2); Project Configuration (from Scenario Management) |
| **Inputs** | Operational | Operational requirements, service requirements, mode constraints |
| **Inputs** | Degradation | Current SOH, available capacity, **marginal degradation cost** |
| **Inputs** | Value Signals | Market prices, TOU tariffs, **demand charge rates**, program payments, reserve prices |
| **Outputs** | Dispatch | Charge/discharge/rest schedule (time series) |
| **Outputs** | State | SOC trajectory over optimization horizon |
| **Outputs** | Battery power trajectory | Battery power trajectory (to Domain 2 Tariff Engine) |
| **Outputs** | Attribution | Operational attribution basis per value stream |
| **Outputs** | Evidence | Constraint compliance evidence |

**Note.** Dispatch **consumes** System Context signals from Domain 2. It does **not** own the external context (`SYS-STR-FRM-001` §6.5). Dispatch produces **battery power and SOC trajectories**; **cycling metrics are derived by Domain 5** (see `A.2.4-DISPATCH-ENG-001` §4.3, §12.1, §14.4).

**Note on Tariff Engine interface.** Dispatch delivers the **battery power trajectory** to the Tariff Engine; the Tariff Engine composes the net load (base load + battery power + auxiliary consumption, per B.2 v0.5.1 §4.3). Dispatch does **not** deliver net load.

### 9.6 Boundary

| Answers | Does Not Answer |
|---|---|
| Given the available opportunities and constraints, how should the BESS be dispatched? | What is the physical battery? **What is the external context?** What is the complete financial valuation? |

**Reference.** Detailed conceptual engineering: `A.2.4-DISPATCH-ENG-001` v1.0.

---

## 10. Domain 5 — Degradation Engineering

### 10.1 Purpose

Represent the **evolution of battery capability over time as a consequence of operation and environmental conditions**.

### 10.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Calendar aging | Time-dependent capacity fade |
| Cycle aging | Throughput-dependent degradation |
| Depth of Discharge | Cycle depth influence |
| C-rate | Cycle intensity influence |
| Temperature | Thermal influence on aging |
| Equivalent full cycles | Cumulative throughput metric |
| Capacity fade | Loss of usable capacity |
| SOH | Remaining capability relative to beginning-of-life |
| Augmentation | Capacity addition events |
| Replacement thresholds | Full replacement triggers |

### 10.3 Feedback Mechanism

```
Dispatch → Battery Usage → Aging / Degradation → SOH
        → Available Capacity → Future Operating Capability → Future Dispatch
```

### 10.4 Interface to Dispatch — Marginal Degradation Cost

Degradation Engineering provides Dispatch with two distinct outputs:

- **Updated capacity** — physical capability available in future periods
- **Marginal degradation cost** — a per-MWh signal representing the economic cost of one more unit of throughput

**Marginal degradation cost is a derived operational signal** (`SYS-STR-FRM-001` §6.4). It combines a physical input (lifetime throughput, Domain 5) with a scenario input (replacement cost, financial scenario assumption).

**Annual offset.** Under annual SOH update (**PH-036**), the marginal degradation cost consumed during year *n* is computed from the state at the **beginning of year *n***. This breaks the circularity between signal, dispatch, and SOH.

### 10.5 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operating History | Battery power trajectory, SOC trajectory, throughput (from Dispatch); cycling metrics derived internally |
| **Inputs** | Environmental | Temperature conditions, average SOC |
| **Inputs** | Physical | Initial state, physical parameters |
| **Inputs** | Scenario Assumption | Replacement cost (financial scenario input) |
| **Inputs** | Policy | Augmentation policy, replacement policy, EOL threshold (via Scenario Management) |
| **Outputs** | State | Updated SOH, available capacity |
| **Outputs** | Metrics | Degradation metrics, equivalent cycles |
| **Outputs** | Dispatch Signal | **Marginal degradation cost** |
| **Outputs** | Events | Augmentation events, replacement events |
| **Outputs** | Constraints | Updated operating constraints |

### 10.6 The Three Concepts That Must Not Collapse

| Concept | Nature | Owner |
|---|---|---|
| **Physical degradation** | Physical state | Domain 5 |
| **Marginal degradation cost** | Operational signal | Domain 5 |
| **Replacement cash flow** | Monetary flow | Domain 6 |

**Rule.** These are three distinct quantities. None may be substituted for another.

### 10.7 Boundary

| Answers | Does Not Answer |
|---|---|
| How does operating the battery change the battery over time, and what does one more unit of throughput cost? | What is the total economic value of that degradation over the contract term? |

**Reference.** Detailed conceptual engineering: `A.2.5-DEG-ENG-001` v0.4.

---

## 11. Domain 6 — Financial Engineering

### 11.1 Purpose

Translate operational behavior into **project-level economic performance**.

### 11.2 Primary Responsibility

| Category | Aspects |
|---|---|
| Investment | CAPEX, installation, augmentation, replacement |
| Operating Economics | O&M, electricity costs, market costs |
| Value | Peak-shaving savings, DR revenue, arbitrage revenue, regulation revenue |
| Financial Evaluation | Cash flows, NPV, IRR, payback |
| Financing | Debt parameters for equity IRR |
| Tax & Incentives | ITC, depreciation |
| Convention | Currency, nominal vs. real |
| Perspective | Commercial perspective (ENGIE vs. client) |

### 11.3 Fundamental Relationship

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
        ├── Revenue (from D4 attribution + Load & Market settlement)
        ├── Savings (from D2 tariff engine)
        ├── Costs
        └── Degradation events (from D5)
        │
        ▼
Project Cash Flow → Financial KPIs
```

**Note.** Market revenue is settled through the Load & Market Model's market/program adapters (per A.2.2 §13.5 and B.4 §4.4). Dispatch produces the **attribution basis**; the Load & Market Model produces the **settlement basis**; Financial Engineering performs the **economic valuation**.

### 11.4 Two Sources of Truth for Value

| Value category | Source of truth |
|---|---|
| **Behind-the-meter savings** | **Domain 2 — Tariff engine** |
| **Market revenues** | **Domain 4 — Operational attribution basis**, settled through **Load & Market Model** market/program adapters |

**Peak shaving is a special case.** The economic value of peak reduction is a tariff saving, computed **only** by the tariff engine.

### 11.5 Degradation Cost — Avoiding Double Counting

| Where | What it represents | Effect |
|---|---|---|
| **Dispatch objective** | Marginal degradation cost | Signal, not a cash flow |
| **Project cash flow** | Actual augmentation and replacement flows | Real money spent |

**Rule:** The marginal degradation cost is only a dispatch signal. The cash flow contains only real flows.

### 11.6 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operational | Dispatch results, energy shifted, peak reduction, DR performance, regulation service |
| **Inputs** | Degradation | Augmentation events, replacement events, physical event information |
| **Inputs** | Tariff Bill Outputs | Bill with and without BESS (from Domain 2) |
| **Inputs** | Market Settlement | Settlement basis (from Load & Market Model adapters) |
| **Inputs** | Financial Assumptions | Discount rate, escalation rates, contract term, incentive schedules |
| **Inputs** | Financing | Debt parameters for equity IRR |
| **Inputs** | Tax | Tax and incentive parameters |
| **Inputs** | Cost Data | CAPEX, OPEX, O&M costs, replacement costs (via Scenario Management) |
| **Outputs** | Revenue | Annual revenue by stream, annual savings |
| **Outputs** | Costs | Annual costs, demand charge savings |
| **Outputs** | Cash Flow | Annual net cash flow |
| **Outputs** | KPIs | NPV, IRR (project and equity), simple payback |

### 11.7 Boundary

| Answers | Does Not Answer |
|---|---|
| What economic value results from the modeled project behavior? | How does the battery physically operate? |

**Reference.** Detailed conceptual engineering: `A.2.6-FIN-ENG-001` v0.3.

---

## 12. Domain 7 — Data & Application Engineering

### 12.1 Purpose

Convert the analytical system into an **executable and usable software product**.

### 12.2 Primary Responsibility

| Category | Aspects |
|---|---|
| Data | Ingestion, transformation, validation, processing, storage, quality, lineage |
| Execution | Model execution, scenario configuration, parameter management, workflow orchestration |
| Application | Data input, scenario configuration, visualization, dashboards, comparison, reporting, export |
| Technology | Python, Databricks, PySpark, SQL, Databricks App |

### 12.3 Inputs and Outputs

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
| **Outputs** | Execution and lineage records | Basic execution logs, data lineage |

### 12.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does the user provide information, execute models, and consume results? | The underlying BESS, operational, optimization, degradation, or financial logic |

**Reference.** Detailed conceptual engineering: `A.2.7-DATA-APP-ENG-001` v0.3.

---

## 13. Inter-Domain Contract

| From | To | Main Information |
|---|---|---|
| BESS Engineering | Operational | Physical capabilities and constraints |
| BESS Engineering | Dispatch | Feasibility constraints |
| BESS Engineering | Degradation | Initial state and physical parameters |
| Load & Market | Operational | External operating conditions |
| Load & Market | Dispatch | Prices, load, programs, grid conditions |
| **Load & Market** | **All domains** | **External Context signals (Generation, Grid, Load, Market)** |
| Load & Market | Financial | **Bill with and without BESS** — source of truth for behind-the-meter savings |
| Operational | Dispatch | Operational requirements and service-level metrics |
| Dispatch | Degradation | Battery power trajectory, SOC trajectory |
| Degradation | Dispatch | Updated SOH, available capacity, **marginal degradation cost** |
| Dispatch | Financial | Dispatch schedule, SOC trajectory, operational attribution basis |
| Dispatch | Load & Market | **Battery power trajectory** (Tariff Engine composes the net load) |
| Degradation | Financial | Augmentation events, replacement events, physical event information |
| Scenario Management | Degradation | Replacement cost (scenario input) |
| **Scenario Management** | **All domains** | **Project Configuration (standalone / co-located / BTM / FTM / AC-DC coupling)** |
| Market Adapters (Load & Market) | Financial | Settled market quantities (settlement basis) |
| Financial | Application | Financial KPIs and economic outputs |
| All domains | Data & Application | Data contracts and execution interfaces |
| Validation | All domains | Validation criteria and evidence |

**Note.** Per `SYS-STR-FRM-001` §3.5, Domain 2 owns the External Context interface. Project Configuration is a scenario parameter, managed by Scenario Management.

**Note on settlement chain.** Market revenue flows: Dispatch → operational attribution basis → Load & Market (settlement adapter) → settlement basis → Financial. This chain was resolved in Stage B (B.2 v0.5.1 §7.2, B.4 §4.4).

---

## 14. The System's Core Feedback Loop

```
                    System Context
                          │
                          ▼
              Context-Derived Signals ─────┐
                                           │
              BESS Physical Capability ────┤
                                           ▼
                             Operational Requirements
                                           │
                                           ▼
                                      DISPATCH
                                           │
                                           ▼
                                    BESS OPERATION
                                           │
                                           ▼
                                     DEGRADATION
                                     ┌─────┴─────┐
                                     ▼           ▼
                            Future Capability   Marginal
                                                Degradation Cost
                                     │           │
                                     └─────┬─────┘
                                           ▼
                                        DISPATCH
                                           │
                                           ▼
                                     FINANCIAL VALUE
```

The External Context enters this loop through Domain 2's signals (`SYS-STR-FRM-001` §6.5). It is not a fourth independent path — it propagates through the domains.

---

## 15. Domain Summary Table

| # | Domain | Purpose | Key Inputs | Key Outputs | Boundary |
|---|---|---|---|---|---|
| 1 | BESS Engineering | Physical representation | Technical parameters, efficiency, limits, temperature profile | State, capability, envelope, losses | What the BESS can do |
| 2 | Load & Market Engineering | External Context + tariff | Load, generation (ext), tariff, market, program, grid data; battery power trajectory | Load signals, generation signals (ext), price signals, constraints, bill outputs | What is outside the BESS |
| 3 | Operational Engineering | Use-case behavior | Physical, external, rules | Operational requirements, service metrics | How each value stream uses BESS |
| 4 | Dispatch & Optimization | Coordination layer | Physical, external, operational, degradation, value signals, System Context | Dispatch, SOC trajectory, battery power trajectory, attribution | How to coordinate objectives |
| 5 | Degradation Engineering | Capability evolution | Operating history, environmental, physical, replacement cost (scenario) | SOH, capacity, marginal degradation cost, events | How usage changes the battery |
| 6 | Financial Engineering | Economic translation | Operational outputs, degradation, bill outputs, settlement basis, financial assumptions | Revenue, costs, cash flow, NPV, IRR | What value results |
| 7 | Data & Application Engineering | Execution and delivery | All data and models | Dashboards, reports, exports, execution and lineage records | How users interact with the system |

---

## 16. What Is Deliberately NOT Defined Here

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

### Data Architecture
- Physical tables, schemas
- Delta tables, partitioning

### Financial Methodology
- Exact cash-flow formulation
- Tax treatment — default: pre-tax; see **PH-043**
- Financing structure — default: project IRR primary; equity IRR computed with default debt parameters, configurable by the user; see **PH-042**
- Specific financial assumptions

### UI
- Screen designs
- Dashboard layouts

### System Context
- System Context dimensions are declared in `SYS-STR-FRM-001` §3.4 and are not restated here. Their effects propagate through the seven domains via the interfaces declared in §5 and §13.

These decisions belong to subsequent engineering stages (A.2, B, C, D). At this revision, Stage B is frozen and Stage C is next.

---

## 17. Engineering Sequence

```
STEP A.1
System Component Definition (this document)
        │
        ▼
Seven Engineering Domains
+ System Context
+ Context-to-Domain Interfaces
        │
        ▼
STEP A.2
Conceptual Engineering per Domain
(seven chapters: A.2.1–A.2.7)
        │
        ▼
STAGE A CONSOLIDATION AUDIT
        │
        │ ✅ CLOSED (tag: stage-a-closed)
        │
        ▼
STEP B
System Architecture (Basic Engineering)
        │
        │ ✅ FROZEN (B.0–B.6 + Index + Handoff)
        │
        ▼
STEP C
Product Specification (Detailed Engineering)
        │
        │ ⏭ Next
        │
        ▼
STEP D
Implementation
        │
        ▼
Testing / Validation / UAT
```

The important point is that **Step A.1 does not engineer the seven domains yet**. It establishes their **identity, purpose, boundary, responsibility, inputs, outputs, and relationships** — and the interfaces through which System Context enters them.

---

## 18. System-Level Definition

> **The BESS Operational & Financial Modeling System is an integrated analytical system that represents the physical capabilities and degradation of a BESS, its System Context (external context plus project configuration), its operational value streams, and the dispatch decisions required to coordinate those value streams, and translates the resulting operational behavior into financial performance and decision-support outputs through an executable data and application platform.**

Everything built later should be traceable back to one of the seven domains or to an explicitly defined cross-domain interaction.

---

## 19. Design Principle

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

## 20. Next Steps

**Stage status at this revision:**

| Stage | Status |
|---|---|
| **Stage A — Engineering Definition** | ✅ CLOSED (tag: `stage-a-closed`) |
| **Stage B — System Architecture (HLD)** | ✅ FROZEN |
| **Stage C — Product Specification** | ⏭ Next |

**Stage B frozen baseline:**

| Order | Document ID | View | Status |
|---|---|---|---|
| 1 | B.0 | Integrated System Architecture | ✅ v0.3.3 Frozen |
| 2 | B.1 | Data Architecture | ✅ v0.3 Frozen |
| 3 | B.2 | Model Architecture | ✅ v0.5.1 Frozen |
| 4 | B.3 | Optimization Architecture | ✅ v0.6.1 Frozen |
| 5 | B.4 | Financial Architecture | ✅ v0.4 Frozen |
| 6 | B.5 | Software Architecture | ✅ v0.4.1 Frozen |
| 7 | B.6 | Databricks Architecture | ✅ v0.4 Frozen |
| 8 | STAGE-B-HLD-INDEX-001 | Master Index | ✅ v0.2 Frozen |
| 9 | STAGE-B-TO-C-HANDOFF-001 | Stage B → C Handoff | ✅ v0.1 Draft for Review |

**Immediate next step:** Produce the **Stage C Plan**.

**After Stage C Plan:** Begin Stage C specification sequence (C.1–C.7).

---

## 21. Change Log

### 21.1 Changes from v0.5 to v0.6

| # | Change | Reason |
|---|---|---|
| 1 | Terminology | Replaced "candidate actions" with "operational requirements" (aligned with A.2.3 §4) |
| 2 | Phase 1 IDs | Replaced D1, D4, D8, D9 with PH-034, PH-041, PH-042, PH-043 |
| 3 | §3.1 | Fixed PH-003 → PH-004 (project configuration) |
| 4 | §7.5 | Fixed power factor penalties reference (PH-054 → PH-021) |
| 5 | §9.5 | Added cycling metrics ownership note (aligned with A.2.4) |
| 6 | §10.4 | Added annual offset for marginal degradation cost |
| 7 | §10.6 | Added "Three Concepts That Must Not Collapse" |
| 8 | §11 | Updated to reflect two sources of truth for value |
| 9 | §12.3 | Aligned with PH-048 (execution and lineage records) |
| 10 | §17 | Added Stage A Consolidation Audit step |
| 11 | §20 | Updated Next Steps with real status of A.2.1–A.2.7 |
| 12 | Addendum | Added consolidated PH Register cross-reference |

### 21.2 Changes from v0.6 to v0.6.1

| # | Change | Reason |
|---|---|---|
| 1 | Header: version bumped from v0.6 to **v0.6.1 — Consolidated Baseline (Errata Applied)** | Errata patch; no architectural content changed |
| 2 | Header: added `STAGE-A-CONSOL-REPORT-001` v1.1 to Parent Documents | Completeness of the Stage A closure documentation |
| 3 | Header: `SYS-STR-FRM-001` cited as **v0.9** (was unpinned) | Version traceability |
| 4 | Header: `PH1-REG-001` cited as **v1.1** (was unpinned) | Version traceability |
| 5 | §1.1 Status note: added "Stage A is **CLOSED**" and "Stage B is also complete and frozen" | Reflect the real state at the time of the errata |
| 6 | §2: added explicit status table (Stage A CLOSED / Stage B FROZEN / Stage C Next) | Traceability of the stage progression |
| 7 | §5.1: replaced `PH-003` with `PH-004` in the Generation scope note | **ERRATA:** Generation is activated by PH-004 (Project configuration), not PH-003 (Data availability). This aligns with the Strategy v0.9 §12.1 (PH-004 = B6) and the Consolidation Report §6.2 |
| 8 | §7.5: replaced `PH-003` with `PH-004` in the Generation note | **ERRATA:** same correction, consistency with §5.1 |
| 9 | §7.4: updated the tariff engine diagram label from "net load" to "battery power trajectory"; added explicit note that the net load is composed by the Tariff Engine | Align with Stage B resolution (B.2 v0.5.1 §4.3) |
| 10 | §9.5: replaced the "Net Load" output row with "Battery power trajectory" and added a note on the Tariff Engine interface | Align with Stage B resolution (B.2 v0.5.1 §4.3) |
| 11 | §11.3: added note that market revenue is settled through the Load & Market Model's adapters; added "Market Settlement" input row | Align with Stage B resolution (B.4 §4.4) |
| 12 | §11.4: updated "Market revenues" source of truth from "Domain 4 — Revenue attribution" to "Domain 4 — Operational attribution basis, settled through Load & Market Model" | Align with Stage B resolution (B.4 §4.4) |
| 13 | §13: replaced "Dispatch | Load & Market | Net load (post-dispatch)" with "Dispatch | Load & Market | Battery power trajectory (Tariff Engine composes the net load)" | Align with Stage B resolution (B.2 v0.5.1 §4.3) |
| 14 | §13: replaced "Market Adapters | Financial | Settled market quantities" with "Market Adapters (Load & Market) | Financial | Settled market quantities (settlement basis)" and added note on settlement chain | Align with Stage B resolution (B.4 §4.4) |
| 15 | §15: updated Domain 2 inputs to "battery power trajectory" (was "net load"); updated Domain 4 outputs to "battery power trajectory" (was "net load"); updated Domain 6 inputs to include "settlement basis" | Consistency with §7.4, §9.5, §11.3, §13 |
| 16 | §16: updated "These decisions belong to subsequent engineering stages (A.2, B, C, D)" to "Stage B is frozen and Stage C is next" | Reflect real state |
| 17 | §17: added stage status annotations to the engineering sequence diagram (Stage A CLOSED, Stage B FROZEN, Stage C Next) | Reflect real state |
| 18 | §20: **fully rewritten Next Steps** — replaced the A.2.x status table with the Stage B frozen baseline table and declared the next step (Stage C Plan) | Reflect real state |
| 19 | §21: added this change log | Traceability |

**Nature of the change.** The v0.6.1 patch is a **combination of errata and Stage B alignment**:

- **Errata (items 7, 8):** the `PH-003` → `PH-004` correction in the Generation scope notes. This resolves the collision flagged in the Stage A Consolidation Report §6.2 and confirmed by the Stage B closure audit.
- **Stage B alignment (items 9–15):** updates to reflect decisions resolved in Stage B (net load composition by Tariff Engine; settlement chain through Load & Market adapters). These do not change Stage A content; they align the Stage A document with the downstream frozen architecture.
- **Status updates (items 5, 6, 16, 17, 18):** reflect the real state of the engagement (Stage A CLOSED, Stage B FROZEN, Stage C Next).

**No architectural content of v0.6 has been altered** in terms of the seven-domain decomposition, the System Context operationalization, or the domain responsibilities.

### 21.3 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage A start | Initial A.1 draft | Superseded |
| 0.2 | Stage A review | First consolidation | Superseded |
| 0.3 | Stage A review | Domain refinements | Superseded |
| 0.4 | Stage A review | Context operationalization | Superseded |
| 0.5 | Stage A review | Pre-consolidation baseline | Superseded |
| 0.6 | Stage A closure | 12 corrections (terminology, PH IDs, cycling metrics ownership, annual offset, three concepts, two sources of truth, execution records, consolidation audit, next steps, PH Addendum) | Superseded |
| 0.6.1 | Stage B closure | 19 corrections (errata PH-003→PH-004; Stage B alignment on net load composition and settlement chain; status updates to reflect Stage A CLOSED / Stage B FROZEN / Stage C Next) | **Consolidated Baseline (Errata Applied)** |

---

## Addendum: Phase 1 Clarification & Data Request Register

Clarification requests previously listed in this document are now consolidated in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1), the authoritative source for all Phase 1 clarifications across the seven domains and the Strategy.

### A.1 Items Formerly in This Addendum

| Former item | Register ID | Topic |
|---|---|---|
| Tariff detail (ratchets, coincident-peak, billing periods, minimum bill) | **PH-021**, **PH-022** | Tariff structure, coincident peak |
| Export and net metering | **PH-019**, **PH-049** | Export compensation, grid constraints |
| Augmentation and replacement policy | **PH-044**, **PH-045** | Augmentation, replacement |
| Operating temperature | **PH-015**, **PH-016** | Battery data, temperature |
| Availability assumption | **PH-015** | Battery data |
| Reference projects for validation | **PH-005**, **PH-046** | Benchmark data, benchmark tools |
| Presentation of value split | **PH-009**, **PH-010**, **PH-055** | Commercial perspective, reporting, BTM mapping convention |

New clarification items (if any) should be added to the Register, not to this document.

### A.2 Related Register Items Across the Seven Domains

| Register ID | Topic | Primary domain |
|---|---|---|
| **PH-001** | Target market(s) | Strategy, Domain 2 |
| **PH-002** | BTM vs. FTM scope | Strategy, Domain 2 |
| **PH-003** | Data availability | Domain 1, Domain 2 |
| **PH-004** | Project configuration | Strategy, Domain 5 |
| **PH-005** | Benchmark data and tools | Domain 6, Domain 7 |
| **PH-006** | Acceptance thresholds | Strategy, all domains |
| **PH-007** | Commercial perspective | Domain 6 |
| **PH-012** | Users and handover | Domain 7 |
| **PH-015** | Battery data | Domain 1, Domain 5 |
| **PH-016** | SOC bounds and warranty | Domain 1, Domain 5 |
| **PH-017** | SOC window behavior under degradation | Domain 1, Domain 5 |
| **PH-018** | Multi-cohort aggregation | Domain 5 |
| **PH-021** | Power factor penalties / kVAR charges | Domain 2, Domain 3 |
| **PH-026** | BESS sizing vs. evaluation | Domain 4 |
| **PH-027** | Primary model purpose / use case | Domain 4 |
| **PH-028** | Model output granularity | Domain 4 |
| **PH-032** | Financial objective inside dispatch | Domain 5 |
| **PH-033** | Perfect foresight vs. forecast-based dispatch | Domain 4 |
| **PH-034** | Dispatch methodology | Domain 4 |
| **PH-035** | Realization factor | Domain 6 |
| **PH-036** | Degradation feedback time scale | Domain 5 |
| **PH-038** | Degradation feedback time scale (confirmatory) | Domain 5 |
| **PH-040** | Representative-period scheme and ratchets | Domain 4 |
| **PH-041** | Voltage regulation coupling | Domain 3, Domain 4 |
| **PH-042** | Financing structure | Domain 6 |
| **PH-043** | Degradation model fidelity / tax treatment | Domain 5, Domain 6 |
| **PH-044** | Augmentation policy | Domain 5 |
| **PH-045** | Replacement policy | Domain 5 |
| **PH-046** | Databricks environment | Domain 7 |
| **PH-047** | Reporting requirements | Domain 7 |
| **PH-048** | Audit / lineage / traceability scope | Domain 7 |
| **PH-050** | Load forecasting method | Domain 2 |
| **PH-051** | Load forecasting home | Domain 2 |
| **PH-052** | Scenario granularity | Domain 2 |
| **PH-053** | Market adapter scope | Domain 2 |
| **PH-054** | Time resolution | Domain 2 |
| **PH-055** | Presentation of value (BTM mapping convention) | Domain 3, Domain 6 |

**Note.** Items are assigned IDs in `PH1-REG-001` v1.1. The Register is the authoritative source; this table is a consolidated view across the seven domains.

**Errata note (v0.6.1).** In v0.6, the Generation scope notes in §5.1 and §7.5 cited `PH-003` (Data availability). The correct citation is `PH-004` (Project configuration), which is the Register item that determines whether a co-located or integrated configuration is the primary reference case. This errata corrects the collision flagged in the Stage A Consolidation Report §6.2 and confirmed by the Stage B closure audit.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.1 — System Component Definition (Eagle-Eye View)
**Status:** Stage A — Engineering Definition — **Consolidated Baseline (v0.6.1 — Errata Applied)**
**Duration:** 12 Weeks
**Language:** English

---

