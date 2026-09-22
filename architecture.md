# System Architecture
## BESS Operational & Financial Modeling Platform — ENGIE

**Version:** 1.0 — Draft Baseline
**Status:** Under Architecture Review — Not Frozen
**Date:** 2026-09-22
**Parent Method:** Semantic Systems Engineering (systems_engineering.md, v4.3)
**Parent Strategy:** Production Strategy (production_strategy.md)
**Derived from:** BESS Engineering Model Parts 1–5 (FC11/FC4/FC5) and Market Engineering M1–M4
**Document ID:** ARCH-001 *(stable across versions)*

---

## 1. Purpose and Scope

This document defines the **system architecture** of the BESS operational and financial modeling platform at **High-Level Design (HLD)** level — the level at which major components, responsibilities, interfaces, dependencies, and data flows are established, per the engineering method §13 and the Product Specification Part III.

It answers the question:

> **How is the already-defined engineering model realized as a software system, and how do its components cooperate to produce validated engineering and financial results?**

Scope:

- architectural principles;
- layered component model;
- component responsibilities;
- interfaces and critical boundaries;
- computational architecture (rolling horizon, solver, scale-out);
- technology constraints and decisions;
- cross-cutting validation, benchmarking, backtesting, and traceability.

**Scope rule.** This document is HLD, not LLD and not implementation. It does **not** define:
- individual equations, parameter tables, or solver formulations (those belong to the Engineering Model Parts);
- function-level designs, module contracts, class/function inventories, or data schemas (LLD);
- work, organizational, or cost structures (Execution Baseline).

Per the engineering method (Rule 2 — *Engineering precedes architecture*), the architecture is **derived** from the validated engineering model. It does not redefine physical, market, or financial semantics.

---

## 2. Position in the Engineering Method

The architecture sits between the engineering baseline and execution:

```text
Intent → Requirement → Concept → Model → Question → Hypothesis
        → Evidence → Decision → Baseline → [ ARCHITECTURE ]
        → Execution → Implementation → Validation → Acceptance
```

It is the **Part III — System Architecture** layer of the Product Specification (§25.2). It instantiates:

- the engineering domains (BESS, Market, Forecasting, Operational, Financial, Data, Validation);
- the interfaces declared by Parts 1–5 and M1–M4;
- the technique selection protocol (§15) — dispatch is an **engineering decision point**, not a predetermined implementation;
- the technology constraints of the ENGIE RFP (Part IV — Technology Specification).

**Derivation rule.** Every architectural component, interface, or data flow in this document must trace to an element of the engineering model or a stated technology constraint. Components that cannot be traced are out of the HLD until evidence justifies them.

---

## 3. Architecture Principles

1. **The software implements a model that is already defined, not one invented during coding.** Components mirror engineering domains; they do not create new semantics.

2. **Layers follow dependency order.** Each layer consumes only artifacts produced by earlier layers. This mirrors the part structure: Part 1 → 2 → 3 → 4 → 5, then market (M1–M4), then settlement and finance.

3. **Critical boundaries are explicit and locked.** The BESS → Financial boundary (what physical quantity leaves the dispatch layer) is the primary interface and must be stable before downstream layers are built.

4. **Optimization is isolated behind an interface.** The dispatch engine exposes a solver abstraction so the technique (rule-based, LP/MILP, MISOCP, MPC) can evolve with evidence without ripple effects (§15 technique selection protocol).

5. **Validation and benchmarking operate across the architecture**, not as a final stage.

6. **Traceability is preserved end-to-end.** Every stored artifact references its engineering origin (symbol registry, part, section, RFP requirement).

7. **Technology is a constraint or a decision, not an engineering domain** (Rule 26). Python, Databricks, PySpark, and SQL realize the architecture; they do not define it.

---

## 4. Architectural Drivers and Constraints

| Driver | Source | Effect on architecture |
|---|---|---|
| RFP: Python-based modeling engine | ENGIE RFP-264144-1 | Core simulation and optimization in Python |
| RFP: Databricks App | ENGIE RFP-264144-1 | Input, scenario configuration, visualization environment |
| RFP: ingestion pipelines (PySpark + SQL) | ENGIE RFP-264144-1 | Data layer and scale-out processing |
| Dispatch problem size | Part 5 §5.3.6: ~5 400 continuous vars, ~1 350 binaries, ~50 700 constraints per horizon | Solver must be a commercial-grade MILP/MISOCP inside an isolated interface |
| Rolling horizon | Part 5 §5.5: 24–48 h horizon, 15-min steps, 1-h commit | Controller/loop component with warm-start and state update |
| Simulation at scale | Part 5 §5.6: representative periods primary path; 1 h wall-clock per simulated year fallback | Parallel scenario execution; state latches at epoch boundaries |
| Temporal conventions | Part 1: project-wide resolution, DST, interval labeling; M1 §11 mapping framework | Common time model in the data/state layer |
| Degradation & physical state latches | Part 2, Part 3: SOH latched per epoch (~730 h) | Epoch-state latches between dispatch runs |

**Performance budget (tentative, to be validated):** full-horizon rolling simulation ≤ 1 h wall-clock per simulated year; per-scenario solve within commit interval headroom. These figures are prototype targets, not settled commitments (§11 open items).

---

## 5. Layered Architecture Overview

```text
                    ┌──────────────────────────────┐
                    │  APPLICATION / REPORTING     │
                    │  Databricks App · Dashboards │
                    │  Reports (PDF/Excel)         │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  FINANCIAL ENGINE            │
                    │  NPV · IRR · Payback         │
                    │  Revenue waterfall · Costs   │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  SETTLEMENT / REVENUE        │
                    │  Settlement logic (M4)       │
                    │  Revenue by stream           │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  DISPATCH / OPTIMIZATION     │
                    │  Rolling-horizon controller  │
                    │  Solver interface            │
                    │  Rule-based · Hybrid path    │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  STATE & SCENARIO MANAGEMENT │
                    │  Scenario state · Epoch      │
                    │  latches (SOC/SOH/Th)        │
                    └──────────────┬───────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
 ┌──────▼──────┐          ┌────────▼────────┐      ┌──────────▼─────┐
 │ BESS ENGINE │          │ MARKET ENGINE   │      │ FORECAST ENGINE│
 │ Physics     │          │ M1–M4 semantics │      │ Prices · Load  │
 │ Degradation │          │ Products, rules │      │ Regulation sig.│
 │ Services    │          │ Commitments     │      │ Forecast error │
 └──────┬──────┘          └────────┬────────┘      └──────────┬─────┘
        │                          │                          │
        └──────────────────────────┼──────────────────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  DATA / INPUT LAYER          │
                    │  Catalog · Validation        │
                    │  (PySpark + SQL pipelines)   │
                    └──────────────┬───────────────┘
                                   ▼
                    ┌──────────────────────────────┐
                    │  EXTERNAL DATA SOURCES       │
                    │  Market data · Load/tariffs  │
                    │  Asset parameters · Weather  │
                    └──────────────────────────────┘

        ┌─────────────────────────────────────────────────────────┐
        │  CROSS-CUTTING: Validation · Benchmark · Backtest       │
        │  Traceability & symbol registry · Audit · Testing       │
        └─────────────────────────────────────────────────────────┘
```

**Reading rule.** Arrows show the main data direction. Validation and benchmarking may reach any layer (they are transversal, per the engineering method §3.1–§3.4, §20).

---

## 6. Component Responsibilities

### 6.1 Data / Input Layer

**Responsibility:** acquire, validate, and stage every input consumed by the model layers. Maps to Data/Input Engineering (§8). Implements M1's temporal mapping framework, interval labeling, and DST handling (§11.1–§11.2), and resolution mapping (§11.3).

**Input categories:**

| Category | Consumed by | Examples |
|---|---|---|
| Technical system parameters | BESS Engine | Capacity kWh, power kW, RTE, efficiency curves |
| Client consumption and billing | BESS + Financial | 15-min load, historical peaks, tariff structure |
| Market price projections | BESS + Financial | Day-ahead LMP, real-time LMP, ancillary prices |
| Market rules/policy data | Market Engine | Products, eligibility, signals, settlement rules (M2/M3/M4) |
| Forecast series | Forecast Engine, Dispatch | Load, prices, regulation signal, weather |
| Financial assumptions | Financial Engine | Discount rate, O&M, escalation, incentives, term |

**Output contract:** a validated input catalog in which every item has semantic meaning, source, unit, temporal resolution, timestamp convention, quality rules, and the model block it feeds (§8 of the method).

### 6.2 Forecasting Layer

**Responsibility:** produce the forecast series the dispatch layer consumes as parameters (§9). Keeps forecast methodology separable from data ingestion (a forecast is not data). Provides forecast-error representation to support sensitivity/scenario evaluation.

**Output contract:** forecast series keyed by scenario and time step, conforming to Part 1 temporal conventions, with the forecasting method documented per series (deterministic, scenario, or probabilistic as selected by evidence).

### 6.3 BESS Engine

**Responsibility:** instantiate the physical asset model, degradation model, and service models — Parts 2, 3, and 4. Produces physical limits, energy balance, SOH/throughput states, and per-service objectives, constraints, and revenue terms.

**Consumes:** asset parameters and states from the Data layer; degradation interface ($SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$, $c_{deg}$) per the narrow Part 3 interface.

**Produces for dispatch:** power/energy limits, SOC band, SOH-latched capabilities, service reservations and revenues, degradation costs.

### 6.4 Market Engine

**Responsibility:** instantiate market semantics — M1 domain/conventions, M2 products and eligibility, M3 signals/commitments/constraints, M4 delivery and settlement.

**Consumes:** market policy data (validated via M1 evidence model) and, from Operational Engineering, the **raw delivered quantity** (while **recognized delivery quantity** is M4-owned).

**Produces:** market signals, commitments (branch bid→commitment, no-bid→commitment, null commitment), operational obligations, stacking rules, settlement quantities and settlement amounts, for dispatch and finance.

**Boundary rule:** Market Engineering defines commitments and obligations; Operational/Optimization Engineering defines the Asset Dispatch Decision, whether or not a commitment exists (M1 §19, §21.4).

### 6.5 State & Scenario Management

**Responsibility:** own the simulation state across dispatch solves — SOC, energy, temperature, SOH (capacity/power/efficiency), cumulative throughput, rainflow history, and latched epoch values (§5.5.5, §5.6.3 of Part 5).

Holds the **scenario envelope**: hierarchy of scenario → period → horizon → step, with scenario-level parameters (price paths, load growth, escalation, availability, degradation assumptions — Part 1 §1.5).

**Output contract:** per-step state is serialized so that a horizon solve resumes from the previous epoch latch; state is reproducible and auditable.

### 6.6 Dispatch / Optimization Engine

**Responsibility:** allocate the physical asset across competing services per step. Implements Part 5's coexistence rules (§5.2), priority mechanism (§5.2.3), peak-cap economic decision (§5.2.5), objective function (§5.3.2), and rolling-horizon loop (§5.5).

Supports the three dispatch methodologies of Part 5 §5.4:

| Methodology | Mechanism | Use |
|---|---|---|
| Rule-based | Deterministic cascade, no solver | Fast sanity path, transparent audit |
| Optimization-based | Full MISOCP rolling horizon via solver interface | Primary commercial path |
| Hybrid | Rule-based mode selection + LP/MILP refinement within mode | RFP-acceptable alternative |

**Solver interface (required abstraction):** the formulation is presented to a solver-agnostic interface with result parsing, infeasibility decoding, warm start (Part 5 §5.5.4), and solver-feature documentation. The technique (LP/MILP/MISOCP/MPC) is selectable per scenario without changing the layer boundary (§15 technique selection protocol).

**Output contract (Critical Boundary 1):** time series of $P_{AC,t}^{ch}$, $P_{AC,t}^{dis}$, $Q_t$, SOC/energy, SOH, throughput, mode allocation, service-specific KPIs, and degradation cost — exactly the engineering outputs of Part 5 §5.7. **Nothing physics-derived enters finance except through this boundary.**

### 6.7 Settlement / Revenue

**Responsibility:** convert dispatch decisions and market outputs into recognized settlement quantities and revenue by stream, per M4 settlement definitions and Part 4 revenue equations.

**Consumes:** Asset Dispatch Decisions (raw delivered quantity, Op/Opt) and market settlement rules. Applies settlement on committed and null-commitment paths; performance assessment and penalties per M4.

**Produces for financial:** annual revenue by service, demand-charge savings, penalties, adjustments, settlement amounts.

### 6.8 Financial Engine

**Responsibility:** translate validated operational and settlement behavior into economic consequences (NPV, IRR project and equity, simple payback, revenue waterfall, cost streams). Maps to Financial Engineering (§11).

**Consumes only:** outputs of Settlement/Revenue plus financial assumptions from the Data layer. Per Rule/principle 1, the financial layer does not introduce parallel physical assumptions.

**Output contract:** financial KPIs per scenario, with sensitivity analysis and scenario comparison.

### 6.9 Application / Reporting

**Responsibility:** Databricks App for input staging, scenario configuration, and results; dashboards for dispatch profiles, SOC heatmaps, revenue waterfall, scenario comparison; PDF/Excel report export; documentation and training materials.

**Validation role:** surfaces benchmark and backtest results, not only commercial results.

---

## 7. Interfaces and Critical Boundaries

### 7.1 Critical boundaries (production_strategy.md §6)

| # | Boundary | Declared contract | Locked by |
|---|---|---|---|
| 1 | BESS → Financial | Engineering outputs of Part 5 §5.7 (power, SOC, SOH, throughput, KPIs, degradation cost) | Part 5 FC5 + Part 1 FC11 |
| 2 | BESS + Financial → Data | Complete input specification with origin, format, frequency, validation | Data layer catalog |
| 3 | Data → Technology | Input catalog that the pipelines must ingest | Component 4 build |

### 7.2 Layer interface contracts (from the model parts)

| Layer | Consumes | Produces |
|---|---|---|
| Data / Input | external sources | validated inputs, market policy data |
| Forecast | validated historical + policy data | forecast series + error representation |
| BESS Engine | asset parameters, states (SOC/T/SOH per Part 2/3) | limits, energy balance, degradation state, service terms |
| Market Engine | market policy data; raw delivered quantity from dispatch | signals, commitments, obligation/stacking rules, settlement terms |
| Dispatch | limits (Part 2), SOH/throughput (Part 3), service terms (Part 4), market signals (M3) | dispatch decisions, engineering outputs |
| Settlement | dispatch decisions + M4 settlement rules | recognized quantities, revenue by stream, penalties |
| Financial | settlement outputs + financial assumptions | NPV, IRR, payback, waterfall, sensitivities |

**Interface rule.** Each interface is defined by the *producing* engineering domain and referenced (not redefined) by consumers (M1 §19.2 Reference Rule). Interface changes follow project change control (method §37).

---

## 8. Computational Architecture

### 8.1 Rolling-horizon loop (Part 5 §5.5)

```text
Initialize state at t = 0
For each commit interval:
    1. Build formulation from limits, SOH latch, service terms, market signals, forecasts
    2. Solve dispatch over [t, t + T_opt]   (MISOCP; warm-started)
    3. Commit decisions for [t, t + Δt_commit]
    4. Simulate state evolution over [t, t + Δt_commit]
    5. Update state; advance t by Δt_commit
```

Terminal SOC constraint ($E_{T_opt} \ge E_{terminal}^{min}$) closes each horizon (Part 5 §5.5.3). SOH and other slow states are latched at epoch boundaries (§5.6.3).

### 8.2 Simulation at scale (Part 5 §5.6)

1. **Primary path — representative periods.** Representative days (e.g., 12 covering seasons + weekday/weekend) are simulated and extrapolated to the full horizon.
2. **Fallback — full-horizon rolling MILP.** Budget ≤ 1 h wall-clock per simulated year (target to be validated, not a settled contract).

Both paths share the same dispatch core; only the scheduling driver differs. This keeps extrapolation arithmetic explicit and auditable.

### 8.3 Parallelism and scale-out

- Scenarios are **embarrassingly parallel** — each scenario/period may run independently of others.
- Where volume demands it, batch execution uses PySpark/SQL pipelines on Databricks; the Python modeling core runs per-scenario workers.
- Aggregate KPI reduction (revenue waterfall, SOC histograms, lifetime statistics, Part 5 §5.7.3) is performed as a distributed aggregation over per-scenario results.

### 8.4 Solver deployment

- Commercial MILP/MISOCP solver behind the solver interface; warm-start reused across horizons (§5.5.4).
- Infeasibility handler separates physical, service, and market infeasibility to route failures to the correct abstraction level (method §38).
- Problem-size accounting per Part 5 §5.3.6 (≈5 400 continuous / ≈1 350 binary / ≈50 700 constraints) is the sizing reference for solver licensing and cluster sizing.

---

## 9. Technology Constraints and Decisions

Per Rule 26, technology is **Part IV** content — constraints imposed by the RFP or decisions taken with evidence — not an engineering domain.

| Stack element | Status | Rationale / validation |
|---|---|---|
| Python modeling core | **Constraint** (RFP) | Engineering model implemented in Python: physics, degradation, dispatch, financial |
| Databricks App | **Constraint** (RFP) | Input, scenario configuration, visualization |
| Pipelines (PySpark + SQL) | **Constraint** (RFP) | Ingestion, transformation, validation, scale-out aggregation |
| Optimization solver (MILP/MISOCP) | **Decision (pending prototype)** | §15 protocol; Prototype 0–2 evidence; hard constraints: feasibility, runtime, scalability |
| Report generation (PDF/Excel) | **Decision** | From Databricks output layer; format per RFP deliverables |

**Decision records (method §40).** Technology decisions must carry: engineering question, hypothesis, prototype/analysis, evidence, alternatives, residual risks. Technique selection (LP/MILP/MISOCP/MPC) is explicitly **not settled here**; it follows the technique selection protocol (§15) and is documented in the decision register.

---

## 10. Cross-Cutting Engineering Functions

### 10.1 Validation and Benchmarking

Validation operates across all layers (method §20, §35):

| Level | Answers | Means |
|---|---|---|
| Unit | component correctness | automated tests per component |
| Integration | layer interactions | interface-contract tests |
| Engineering validation | implementation matches approved equations | symbol/equation/benchmark checks against Parts 1–5 |
| Benchmark | defined reference cases | shared benchmark corpus, reproducible |
| Backtest | behavior under historical conditions | historical inputs + historical settlement (method §21) |
| Performance | runtime, scalability | representative-period and full-horizon timing |
| UAT / acceptance | stakeholder needs satisfied | acceptance criteria traceable to RFP |

### 10.2 Traceability and symbol registry

- Single master symbol registry (Part 1) is the authority; the audit script (`scripts/symbol-audit.py`) validates every stored artifact's symbols against it.
- RFP → Model traceability matrix covers requirement coverage; architecture artifacts reference their model origin.
- Every scenario result records its engineering inputs, versions, and model revision for reproducibility.

### 10.3 Backtesting harness

```text
Historical Data → Reconstructed Inputs → Forecast/Scenario
      → Dispatch Model → Simulated Dispatch → Historical Settlement
      → Performance Metrics → Benchmark Comparison
```

Backtest evaluates physical feasibility, constraint compliance, service performance, sensitivity to forecast error, degradation implications, and computational behavior — not only revenue (method §21).

---

## 11. Open Architecture Items

These items must be resolved before this architecture can be frozen (method §22 Decision Gates — Gate 3 Architecture Baseline):

| # | Item | Owner | Required evidence | Gate |
|---|---|---|---|---|
| 1 | Solver/technique selection (MILP vs MISOCP vs MPC vs hybrid) | Optimization Engineering | Prototype 0–2 results against runtime/quality hard constraints | Gate 5 |
| 2 | Performance budget validation (≤1 h / simulated year) | Performance Engineering | Full-horizon benchmark on representative scenario | Gate 5 |
| 3 | Solver licensing and cluster sizing | Engineering / Delivery | Problem-size accounting (Part 5 §5.3.6) + benchmark | Gate 5 |
| 4 | Market jurisdiction / environment identification (M1-O01–O03) | Market Engineering | Authoritative market documentation | M1 freeze |
| 5 | Data catalog closure (Critical Boundary 3) | Data Engineering | Complete input specification from Parts 1–5 + M1–M4 | Component 3 closure |
| 6 | Infeasibility taxonomy across layers | Optimization Engineering | Prototype diagnostics | Gate 5 |
| 7 | Representative-period selection (12-day extrapolation validity) | Engineering Validation | Sensitivity study | Gate 4 |
| 8 | Rule-based ↔ optimization-based parity checks | Engineering Validation | Comparative runs on benchmarks | Gate 4 |

**Status rule.** This architecture is a **draft baseline under review**, not a frozen baseline. Changes to components, interfaces, or technology follow change control (method §37). No item above is silently resolved during implementation.

---

## 12. Relationship to Other Documents

| Document | Relationship |
|---|---|
| systems_engineering.md | Defines the method this architecture instantiates (§13 HLD, §25.2 Part III) |
| production_strategy.md | Component 4 (Technology Architecture); critical boundaries 1–3 |
| docs/engineering-concept/part0..part5 | Engineering model the architecture realizes; interfaces and problem size |
| docs/energy-markets/part0..part4 | Market semantics and settlement that the Market and Settlement layers instantiate |
| docs/financial/financial-approach.md | Financial valuation layer definition (placeholder — to be produced) |

**Consistency rule.** Where this document and the engineering model conflict, the engineering model governs (meaning precedes representation). Where this document and the RFP conflict on technology constraints, the RFP governs and the difference is escalated through change control.

---

## 13. Document Changelog

### Version 1.0 — Draft Baseline

- Initial architecture baseline derived from the engineering method, the five-part BESS model (FC11 / FC4 / FC5), and Market Engineering (M1–M4).
- Layered HLD with component responsibilities, critical boundaries, computational architecture, technology constraints/decisions, cross-cutting validation, and open items.