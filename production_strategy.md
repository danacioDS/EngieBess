# Formal Methodological Approach
## Production Strategy for the BESS Operational & Financial Modeling Project — ENGIE

---

## 1. Guiding Principle

> **The software implements a model that is already defined, not one invented during coding.**

This principle, derived from the BESS engineering model introduction document, is the backbone of the entire strategy. It enforces a strict separation between:

- **WHAT** — what the system must calculate (asset physics)
- **VALUE** — what that behavior is economically worth
- **INPUTS** — what data is required to calculate it
- **HOW** — how it is implemented technologically

Each of these questions is answered in a distinct stage, in an order that respects the project's natural dependencies. No stage introduces elements that were not defined in previous stages.

---

## 2. Component Structure

The project is organized into **four components** executed in sequence. The first three constitute **Conceptual Engineering**; the fourth corresponds to **Basic and Detailed Engineering**.

| # | Component | Question it answers | Nature |
|---|---|---|---|
| 1 | BESS Engineering | What can the system physically do? | Technical-physical |
| 2 | Financial Model | What is that behavior economically worth? | Economic-financial |
| 3 | Data Requirements | What data is needed to calculate it? | Informational |
| 4 | Technology Architecture | How is the solution implemented? | Technological |

---

## 3. General Flow Diagram

```
                        ┌─────────────────────┐
                        │     ENGIE RFP       │
                        │  (baseline reqs)    │
                        └──────────┬──────────┘
                                   │
                                   ▼
              ┌────────────────────────────────────────┐
              │      CONCEPTUAL ENGINEERING            │
              │                                        │
              │  ┌──────────────────────────────┐      │
              │  │  1. BESS ENGINEERING         │      │
              │  │  Physics + Operation         │      │
              │  │  + Degradation + Dispatch    │      │
              │  └──────────────┬───────────────┘      │
              │                 │                      │
              │                 ▼                      │
              │  ┌──────────────────────────────┐      │
              │  │  2. FINANCIAL MODEL          │      │
              │  │  NPV / IRR / Payback         │      │
              │  │  Revenue by Stream           │      │
              │  └──────────────┬───────────────┘      │
              │                 │                      │
              │                 ▼                      │
              │  ┌──────────────────────────────┐      │
              │  │  3. DATA REQUIREMENTS        │      │
              │  │  Sources + Inputs            │      │
              │  │  Quality + Frequency         │      │
              │  └──────────────┬───────────────┘      │
              │                 │                      │
              └─────────────────┼──────────────────────┘
                                │
                                ▼
              ┌────────────────────────────────────────┐
              │      BASIC & DETAILED ENGINEERING      │
              │                                        │
              │  ┌──────────────────────────────┐      │
              │  │  4. TECHNOLOGY ARCHITECTURE  │      │
              │  │  Python / Databricks         │      │
              │  │  PySpark / SQL / App         │      │
              │  └──────────────────────────────┘      │
              │                                        │
              └────────────────────────────────────────┘
```

---

## 4. Formal Description of Each Component

### 4.1 Component 1 — BESS Engineering

**Purpose:** Define the technical specification of the asset, its physical and operational behavior, with sufficient rigor to be simulable, verifiable, and comparable against benchmarks.

**Scope:**

| Block | Content |
|---|---|
| Fundamentals and conventions | Symbols, units, sign convention, state vector, temporal resolutions, scenarios |
| Physical model | Battery, PCS/inverter, grid, site, load, energy balance, derating, hard constraints |
| Temporal model | State evolution over the simulation horizon |
| Degradation | Calendar aging, cycle aging, SOH, augmentation thresholds, marginal cost |
| Operating modes | Peak shaving, demand response, arbitrage, frequency regulation, voltage regulation |
| Dispatch and stacking | Multi-service co-optimization, physical constraints, prioritization |

**Closure criterion:** Every ENGIE RFP requirement is traced to a model section, and every operating mode has objective, inputs, constraints, asset reservation, outputs, and risks defined.

**Output boundary:** Delivers to Component 2 the time series of power, SOC, SOH, equivalent cycles, and degradation cost.

---

### 4.2 Component 2 — Financial Model

**Purpose:** Translate the asset's physical behavior into economic value, under different market and operational scenarios.

**Scope:**

| Block | Content |
|---|---|
| Financial inputs | Discount rate, O&M, escalation, incentives, contract term, tariff structure |
| Value outputs | NPV, IRR (project and equity), simple payback |
| Revenue by stream | Peak shaving, demand response, arbitrage, frequency regulation, voltage regulation |
| Costs | Degradation, augmentation, replacement, O&M |
| Reports | Revenue waterfall, sensitivity analysis, scenario comparison |

**Closure criterion:** The financial model consumes only outputs from Component 1, without introducing parallel physical assumptions.

**Input boundary:** Receives from Component 1 the physical quantities needed to calculate revenues and costs.

---

### 4.3 Component 3 — Data Requirements

**Purpose:** Define precisely what data is required to feed Components 1 and 2, its sources, formats, frequencies, and validation rules.

**Scope:**

| Category | Feeds | Examples |
|---|---|---|
| Technical system parameters | Component 1 | Capacity kWh, power kW, RTE |
| Client consumption and billing data | Components 1 and 2 | 15-min interval, historical peaks, tariff structure |
| Market price projections | Components 1 and 2 | Day-ahead LMP, real-time LMP, ancillary prices |
| Financial assumptions | Component 2 | Discount rate, O&M, escalation, incentives |
| Grid and regulatory parameters | Component 1 | Interconnection limits, export constraints |

**Closure criterion:** Every data item has origin, format, frequency, validation rule, and the model block it feeds.

**Output boundary:** Delivers to Component 4 the complete input specification.

---

### 4.4 Component 4 — Technology Architecture

**Purpose:** Design and implement the technological solution that materializes the models defined in Components 1, 2, and 3, using ENGIE's required stack.

**Scope:**

| Block | Content |
|---|---|
| Python backend | Operational and financial simulation engine |
| Databricks App | Data input, scenario configuration, results visualization |
| Pipelines | Ingestion, transformation, validation, processing (PySpark + SQL) |
| Dashboards | Dispatch profiles, SOC heatmaps, revenue waterfall, scenario comparison |
| Reports | PDF/Excel exports |
| Documentation | Technical and methodological |
| Training | Sessions and materials for internal stakeholders |

**Closure criterion:** UAT approved, deployment in ENGIE environment, documentation delivered.

---

## 5. Component Dependency Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   COMPONENT 1: BESS ENGINEERING                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Fundamentals → Physics → Temporal → Degradation    │   │
│   │  → Operating Modes → Dispatch/Stacking              │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │  Delivers: power series,
                            │  SOC, SOH, cycles, degradation cost
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   COMPONENT 2: FINANCIAL MODEL                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Inputs → Value calculation → Revenue by stream     │   │
│   │  → Costs → Reports                                  │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │  Defines: what data is
                            │  needed to calculate
                            │  all of the above
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   COMPONENT 3: DATA REQUIREMENTS                            │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Technical parameters → Consumption → Market prices │   │
│   │  → Financial assumptions → Grid parameters          │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │  Delivers: complete
                            │  input specification
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   COMPONENT 4: TECHNOLOGY ARCHITECTURE                      │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Python → Databricks → PySpark → SQL → App          │   │
│   │  → Dashboards → Reports → Documentation → Training  │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Interface Diagram (Critical Boundaries)

```
┌──────────────────┐         ┌──────────────────┐
│                  │         │                  │
│  COMPONENT 1     │────────▶│  COMPONENT 2     │
│  BESS            │         │  FINANCIAL       │
│                  │         │                  │
└──────────────────┘         └──────────────────┘
         │                            │
         │                            │
         │    ┌──────────────────┐    │
         │    │                  │    │
         └───▶│  COMPONENT 3     │◀───┘
              │  DATA            │
              │  REQUIREMENTS    │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │                  │
              │  COMPONENT 4     │
              │  TECHNOLOGY      │
              │                  │
              └──────────────────┘
```

**Critical boundary 1 — BESS → Financial:**
Defines what physical quantities the BESS model delivers to the financial model. Must be locked before advancing to Component 3.

**Critical boundary 2 — BESS + Financial → Data Requirements:**
Defines what data is needed. Cannot be closed until Components 1 and 2 are complete.

**Critical boundary 3 — Data Requirements → Technology:**
Defines the input specification that the technological solution must ingest.

---

## 7. Production Sequence

```
┌─────────────────────────────────────────────────────────────┐
│  PHASE 1: CONCEPTUAL ENGINEERING                            │
│                                                             │
│  Stage 1.1 ──▶ BESS Engineering                             │
│  Stage 1.2 ──▶ Financial Model                              │
│  Stage 1.3 ──▶ Data Requirements                            │
│                                                             │
│  Each stage closes before the next begins.                  │
│  Interfaces between stages are explicitly declared.         │
│                                                             │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 2: BASIC ENGINEERING                                 │
│                                                             │
│  Stage 2.1 ──▶ Technology Architecture                      │
│  Stage 2.2 ──▶ Technical specifications                     │
│                                                             │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 3: DETAILED ENGINEERING                              │
│                                                             │
│  Stage 3.1 ──▶ Equations, parameters, algorithms            │
│  Stage 3.2 ──▶ Executable specifications                    │
│                                                             │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 4: IMPLEMENTATION                                    │
│                                                             │
│  Stage 4.1 ──▶ WBS                                          │
│  Stage 4.2 ──▶ OBS                                          │
│  Stage 4.3 ──▶ Cost Breakdown Structure                     │
│  Stage 4.4 ──▶ Execution                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Alignment with the ENGIE RFP

| RFP Requirement | Component | Section |
|---|---|---|
| Python-based modeling engine | 4 | Python backend |
| Databricks App | 4 | Interface |
| Data ingestion pipelines | 3 | Data Requirements |
| Load forecasting | 1 | Physical / temporal model |
| Operational models (5 modes) | 1 | Operating modes |
| Dispatch optimization & revenue stacking | 1 | Dispatch and stacking |
| Battery degradation models | 1 | Degradation |
| Financial performance (NPV, IRR, payback) | 2 | Financial Model |
| Interactive dashboards | 4 | Dashboards |
| Exportable reports | 4 | Reports |
| Technical documentation | 4 | Documentation |
| Training | 4 | Training |

---

## 9. Conceptual Engineering Success Criteria

Phase 1 is considered complete when:

1. Every ENGIE RFP requirement is traced to a model section.
2. Every operating mode has objective, inputs, constraints, asset reservation, outputs, and risks defined.
3. The degradation model is incremental and simulable, not closed-form.
4. There is a clear boundary between linear and nonlinear, and between the optimization horizon and the simulation loop.
5. Dispatch has a decision variable, an objective function, and explicit constraints.
6. No symbol is used without being registered in the fundamentals.
7. The BESS → Financial boundary is declared and validated.
8. Data Requirements are specified with origin, format, frequency, and validation.

---

## 10. Executive Summary

| Aspect | Definition |
|---|---|
| **Principle** | The software implements a model already defined, not one invented during coding |
| **Structure** | 4 components: BESS → Financial → Data → Technology |
| **Sequence** | Conceptual Engineering (1-3) → Basic Engineering (4) → Detailed → Implementation |
| **Critical boundary** | BESS → Financial |
| **Closure criterion** | Full traceability RFP → Model |
| **Differentiating value** | Strict separation between WHAT, VALUE, INPUTS, and HOW |

---

This document constitutes the formal basis of the methodological approach. It can be presented as a **Methodological Annex** to the ENGIE proposal or as an **internal planning document** for the production team.