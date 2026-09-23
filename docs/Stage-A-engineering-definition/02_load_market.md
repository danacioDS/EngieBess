
---

# Load & Market Engineering
## Stage A.2.2 — Conceptual Engineering
### External Operating Environment of the BESS Operational & Financial Modeling System

**Document ID:** A.2.2-LOAD-MKT-ENG-001

**Version:** 1.2 — Conceptual Engineering Baseline (Closed)

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.6)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.4)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.1)

**Domain:** Domain 2 — Load & Market Engineering

**Purpose:** Define, at a conceptual level, what the Load & Market Engineering domain represents, what external conditions it must produce, what it consumes, how it interacts with the other six domains, and what engineering decisions must be made in later stages — **without** entering into equations, data schemas, class structures, or software architecture.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.2 — Conceptual Engineering** of the Load & Market Engineering domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §1.1.

Its purpose is to establish the **conceptual engineering definition** of the **external operating environment** in which the BESS operates — the electricity demand, the load forecast, the market products, the price signals, the program rules, the tariff structure, and the grid/regulatory constraints that determine the BESS's potential value.

It answers, at conceptual level:

- What is being modeled externally
- What external signals must be representable
- What forecast must be produced
- What market products and program rules must be representable
- What the tariff engine computes and what it does not
- What uncertainty must be carried
- What it exposes to other domains
- What it does **not** decide (and who decides it)

It deliberately does **not** define:

- Forecasting algorithms
- Market settlement equations
- Market simulation
- Market revenue calculation
- Data schemas
- Ingestion pipelines
- Market-specific numerical rules
- Software architecture
- Python classes or APIs

Those belong to Stages B, C, and D, or to market adapters.

### 1.1 Position Within Stage A

Stage A is delivered in two levels:

| Level | Name | Deliverable |
|---|---|---|
| A.1 | System Component Definition | `SYS-ENG-DEF-001` — eagle-eye view of the seven domains |
| A.2 | Conceptual Engineering per Domain | Seven domain chapters |

Per `SYS-STR-FRM-001` §4.3, the A.2 chapters may be consolidated into a single document. This chapter refines **Domain 2** of `SYS-ENG-DEF-001` §6 into a conceptual engineering baseline.

### 1.2 Relationship to A.2.1

A.2.1 established **what the BESS can physically do**.

A.2.2 establishes **under what external conditions the BESS operates**.

Both are **inputs** to Operational Engineering (A.2.3), which will define *how* the BESS can be used; and to Dispatch & Optimization (A.2.4), which will define *what should be done* given physical capability plus external conditions.

### 1.3 Generality Principle

This document defines a **generic external environment model** — one that can be parameterized for different markets, jurisdictions, programs, tariffs, and client load profiles.

It does **not** hard-code:

- A specific ISO/RTO (PJM, ERCOT, CAISO, MISO, etc.)
- A specific market product (RegD, FFR, LMP-DA, etc.)
- A specific tariff structure
- A specific DR program
- A specific forecasting methodology

The RFP explicitly references multiple market constructs. This document treats them as **instances of a generic market/program representation**, with market-specific rules handled by **adapters** (see §13).

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Load & Market Engineering domain** is the conceptual representation of the **external operating environment** of the BESS — the electricity demand it serves, the load projection it must plan against, the market products it can monetize, the price signals it responds to, the program rules it must comply with, the tariff structure that defines customer savings, and the grid/regulatory constraints it must respect.

It provides the **external signals** that Operational Engineering, Dispatch, and Financial Engineering consume.

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| A BESS model | BESS physics belongs to Domain 1 |
| An operational model | Operational behavior belongs to Domain 3 |
| A dispatch model | Dispatch belongs to Domain 4 |
| A financial model | Financial valuation belongs to Domain 6 |
| A market settlement engine | Settlement is a market-adapter concern, not this domain |
| A market simulator | Market prices are inputs, not outputs of this domain |
| A market revenue calculator | Market revenue attribution belongs to Dispatch and Financial Engineering |
| A forecasting algorithm specification | Algorithms belong to Stage B/C |
| A data pipeline | Ingestion belongs to Domain 7 |

### 2.3 Primary Question

> **Under what external conditions does the BESS operate, and what does the customer tariff imply for the resulting bill?**

### 2.4 Guiding Principle

> **This domain defines the external environment — never the BESS response, never the dispatch decision, never the market economic valuation.**

Any responsibility that would answer *"what should the BESS do?"*, *"how should the BESS be dispatched?"*, or *"what is the market value?"* belongs to another domain.

### 2.5 Boundary Warning — This Is Not a Market Engine

This domain represents **external conditions, signals, rules, and constraints**.

It does **not** become a *market simulation engine*, a *market settlement engine*, or a *market revenue calculator*.

| This domain does | This domain does not |
|---|---|
| Declare what the market environment is | Simulate market behavior |
| Represent price signals as inputs | Compute prices from market dynamics |
| Represent program rules | Compute program outcomes |
| Represent market eligibility | Compute market revenue |
| Represent market constraints | Compute market settlement |
| Apply a known customer tariff to a load profile | Simulate market clearing |

**Exception: the tariff engine.** Applying a known customer tariff to a load profile to compute a bill is **in scope** of this domain (§9). It is deterministic rule application, not market simulation or settlement. Market settlement remains the responsibility of market adapters.

---

## 3. Engineering Scope

The domain must conceptually represent the following aspects of the external environment:

| # | Aspect | Description |
|---|---|---|
| 1 | Load | Historical and current electricity consumption of the site |
| 2 | Load projection / forecasting | Short-horizon forecast and multi-year projection over the relevant horizons |
| 3 | Tariffs | Energy charges, demand charges, TOU structures, billing determinants, ratchets, coincident-peak charges |
| 4 | Tariff engine | Applies the tariff to a load profile to compute the customer bill with and without BESS |
| 5 | Energy markets | Day-ahead and real-time energy prices (LMP or equivalent) |
| 6 | Ancillary markets | Frequency regulation, reserves, and related products |
| 7 | Capacity markets | Capacity revenues and obligations |
| 8 | Demand response programs | Event rules, notification, performance measurement, penalties |
| 9 | Grid constraints | Interconnection limits, export constraints, curtailment |
| 10 | Regulatory constraints | Participation eligibility, jurisdictional rules |
| 11 | Forecast uncertainty | Uncertainty attached to load and price forecasts (scenario-based) |
| 12 | Market / program adapters | Mechanism to specialize the generic model per market |
| 13 | External signals | The collected external signals consumed downstream |

The domain does **not** compute BESS behavior, dispatch, or market revenue — it produces the **external signals** consumed by those domains, plus the **customer bill** produced by the tariff engine.

---

## 4. Conceptual Model of the External Environment

### 4.1 High-Level Structure

The external environment is conceptually represented in three coupled streams:

```
                  EXTERNAL ENVIRONMENT
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
      LOAD             MARKET            GRID / REGULATORY
        │                 │                 │
   Historical        Prices, TOU        Limits, eligibility,
   consumption       Ancillary,         interconnection,
   Projection        Capacity, DR       export constraints
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
                 EXTERNAL CONDITIONS
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
    Operational       Dispatch          Financial
                          │                 ▲
                          │ net load        │ bill with/without BESS
                          ▼                 │
                    Tariff Engine ──────────┘
```

Each stream is conceptually independent (its own inputs, its own uncertainty) but all three feed the downstream domains. The tariff engine consumes the **net load** — supplied by Dispatch, and already including BESS charge/discharge and auxiliary consumption — and produces the customer bill, which is the source of truth for behind-the-meter savings.

### 4.2 Conceptual Sub-Areas

| Sub-Area | Conceptual Role |
|---|---|
| Load Engineering | Represents electricity demand at the site |
| Load Projection / Forecasting | Produces projected demand over relevant horizons |
| Market Engineering | Represents market products and price signals |
| Market Products / Value Signals | Represents specific monetizable products |
| Grid & Program Constraints | Represents the rules that gate or shape participation |
| Tariff Engine | Applies the customer tariff to compute the bill with and without BESS |
| External Signals | External signals available for downstream consumption |
| Forecast Uncertainty | Scenario-based uncertainty attached to load and price forecasts |
| Market / Program Adapters | Specialization layer for market-specific rules |

### 4.3 External Boundary

| Inside the domain | Outside the domain |
|---|---|
| Load, projected load | BESS physics |
| Tariffs, prices, market products | Operational behavior |
| DR program rules | Dispatch decisions |
| Grid constraints | Market settlement computation |
| Forecast uncertainty (scenario-based) | Market revenue attribution |
| Customer bill computation (tariff engine) | Financial valuation |
| Market adapters | Software implementation |

---

## 5. Load Engineering (Conceptual)

### 5.1 Concepts

| Concept | Meaning |
|---|---|
| Site load | Electricity consumption of the client site over time |
| Interval data | Metered consumption at a defined time resolution |
| Demand profile | Load expressed as power (kW) over time |
| Peak demand | Maximum load over a defined period |
| Baseline | Reference consumption used for DR performance |
| Billing determinants | Quantities used in tariff calculation (kWh, kW, coincident peak, etc.) |

### 5.2 Conceptual Requirements

The domain must be able to represent:

1. **Historical load** at the required time resolution (15-min or hourly per the RFP)
2. **Peak demand** as a derived quantity per billing period
3. **Baseline consumption** as required by DR programs
4. **Load variability** across time-of-day, day-of-week, and season
5. **Behind-the-meter vs. front-of-the-meter** configurations (both are conceptually supported)

### 5.3 Load — Domain Responsibility

**Load & Market Engineering defines the load environment.**

It does not decide how the BESS responds to load, nor how much load is shifted or reduced. That is Operational and Dispatch responsibility.

### 5.4 Baseline Methodology Belongs to the Program Adapter

The DR baseline methodology is a **program-specific rule**. Following §13.5, it belongs to the **DR program adapter**, not to the generic load representation.

This domain declares the **concept** of a baseline. The **methodology** (e.g. average of prior days, day-of adjustment, regression-based) is provided by the adapter.

### 5.5 DR Baseline — Interface

The domain exposes:

- The concept of baseline consumption (a reference profile)
- The interface through which the adapter supplies the methodology

The baseline's actual computation for a given event is a program-adapter concern.

---

## 6. Load Projection and Forecasting (Conceptual)

### 6.1 Two Distinct Capabilities

The A.1 v0.4 (§5, §6.2) separates **short-horizon forecasting** from **multi-year projection** as distinct capabilities. **The multi-year projection is the load forecasting capability required by the RFP**; under perfect foresight it is the primary load input to dispatch. The **short-horizon forecast extends this capability** for forecast-based dispatch, if ENGIE selects that mode.

Both capabilities are treated below.

| Capability | Purpose | Primary consumer |
|---|---|---|
| **Multi-year projection** | Provides load growth and load scenarios over the contract term — the RFP-required load forecasting capability | Dispatch (under perfect foresight), Financial, Scenarios |
| **Short-horizon forecast** | Extends the capability for dispatch over short horizons under forecast-based dispatch | Dispatch (A.2.4) if forecast-based dispatch is selected |

### 6.2 Multi-Year Projection — Conceptual Pipeline

```
Historical Load
       │
       ▼
Data Quality
       │
       ▼
Load Characterization
       │
       ▼
Projection (growth + scenario variations)
       │
       ▼
Projected Load Scenarios
       │
       ├──────────────► Dispatch
       │
       ├──────────────► Financial (contract-term revenues and savings)
       │
       └──────────────► Scenarios (what-if comparison)
```

### 6.3 Short-Horizon Forecast — Extension

Under perfect foresight, the short-horizon forecast is not consumed by default dispatch. It becomes relevant if ENGIE chooses forecast-based dispatch (`SYS-STR-FRM-001` §12.2 D2).

The domain declares the capability. Its consumption is decided in A.2.4.

### 6.4 Conceptual Requirements

The domain must be able to represent:

1. **A projection horizon** covering the contract term
2. **Load growth** across years
3. **Scenario variations** of projected load
4. **A short-horizon forecast capability** (extension)
5. **Uncertainty** as scenario variations (see §12)

### 6.5 Conceptual Ownership

**Load projection and forecasting belong conceptually to Load & Market Engineering.**

Their **computational implementation** may use capabilities from Data & Application Engineering (A.2.7). This distinction matters:

> **Conceptual ownership ≠ software implementation location.**

This is the conceptual resolution of Phase 1 clarification **D7** (load forecasting home). Formal confirmation remains a Phase 1 decision, but the conceptual answer is: **Domain 2 owns it**.

---

## 7. Market Engineering (Conceptual)

### 7.1 Concepts

| Concept | Meaning |
|---|---|
| Energy market | Market for electrical energy, typically day-ahead and real-time |
| Price signal | Time series of prices the BESS can respond to |
| TOU tariff | Time-of-use pricing structure |
| LMP | Locational marginal price (or equivalent) |
| Ancillary market | Market for grid support services (frequency, reserves, etc.) |
| Capacity market | Market for capacity availability |
| Market product | A specific monetizable or compensable product |
| Market rules | Eligibility, participation, performance requirements |

### 7.2 Conceptual Requirements

The domain must be able to represent:

1. **Energy price signals** (day-ahead and real-time)
2. **TOU tariff structures** with demand and energy charges
3. **Ancillary service products** with their price signals
4. **Capacity products** with their price signals
5. **Market rules** that gate eligibility and shape participation
6. **Settlement-relevant quantities** conceptually (not settlement computation itself)

### 7.3 Generality

The domain must not be hard-coded to one market. It must support **multiple market constructs** through:

- A **generic market representation** (product identity, time alignment, price signal, eligibility)
- **Market-specific adapters** that specialize the generic representation (§13)

### 7.4 Market-Specific Rules Belong to Adapters

Market-specific rules — settlement logic, participation rules, performance measurement — **belong to adapters**, not to this domain.

### 7.5 No Market Simulation

This domain does **not** simulate market behavior. Prices, clearing outcomes, and market dynamics are **inputs** — supplied by ENGIE, by historical data, by projections, or by market adapters — never **computed** by this domain.

### 7.6 Price-Taker Assumption

**The BESS is modeled as a price-taker.** Its participation does not alter market clearing prices.

This is a standard modeling assumption, but it must be stated because for large batteries in small ancillary-service markets it may not hold. Where it does not hold, market prices would need to be supplied as scenario inputs that already reflect the BESS's impact — but the model itself does not compute that impact.

---

## 8. Market Products / Value Signals (Conceptual)

### 8.1 Concept

A **market product** (or **value signal**) is a specific monetizable or compensable product the BESS can participate in. Each product has its own:

- Price signal (or revenue mechanism)
- Eligibility rules
- Performance requirements
- Signal representation required for downstream consumption

Settlement logic and market revenue computation are **not** part of this domain — they belong to the market adapters that specialize the generic representation (§13) and to Dispatch and Financial Engineering.

### 8.2 Conceptual Product Categories

| Category | Examples (conceptual) | Nature of Signal |
|---|---|---|
| Energy (day-ahead) | DA LMP | Price per MWh |
| Energy (real-time) | RT LMP | Price per MWh |
| TOU tariff | Peak / off-peak energy charge | Price per kWh (tariff) |
| Demand charge | $/kW billing determinant | Rate × peak reduction |
| Frequency regulation | RegD, FFR, or equivalent | Capacity and/or mileage |
| Reserves | Spinning, non-spinning | Capacity payment |
| Capacity market | Capacity availability | $/MW-period |
| Demand response | Event-based or capacity-based | Event payment or capacity payment |

### 8.3 Frequency Regulation — Statistical Signal Characteristics

`SYS-ENG-DEF-001` v0.4 §7.3 establishes that frequency regulation is represented as **capacity reservation plus a statistical energy-throughput and SOC-drift estimate**.

Those statistical characteristics are **external signals**. This domain must provide them:

| Signal | Meaning |
|---|---|
| Energy per MW of regulation capacity | Expected energy throughput per unit of reserved capacity |
| Signal bias | Net directional bias of the regulation signal (charge vs. discharge) |
| Expected performance score | Anticipated performance score for the reserved capacity (mileage-based or equivalent) |

Without these signals, Dispatch cannot represent regulation in a coarse time-resolution model.

### 8.4 Conceptual Requirements

The domain must be able to represent:

1. The **identity** of each product in scope
2. The **price or revenue mechanism** associated with each
3. The **eligibility conditions** for the BESS to participate
4. The **performance requirements** (e.g., minimum duration, ramp rate)
5. The **signal representation** required for downstream consumption
6. For frequency regulation: the **statistical signal characteristics** of §8.3

### 8.5 Relationship to Operational Engineering

Market products define **what is monetizable**. Operational Engineering defines **how the BESS provides the service**. The two must not be conflated.

### 8.6 No Market Revenue Calculation

This domain does **not** calculate market revenue. It represents the **mechanism by which market revenue can arise** — not the amount, not the attribution, not the timing of cash flow.

| This domain does | This domain does not |
|---|---|
| Declare that a DR event pays $X/kW-month | Compute DR revenue |
| Declare that regulation pays per mileage | Compute regulation revenue |
| Declare market price signals | Compute revenue from market participation |
| Declare demand charge rates **and compute the customer bill with and without BESS** (tariff engine, §9) | Compute market revenues or settlement |

Market revenue calculation belongs to **Dispatch attribution (A.2.4)**, supported by **Financial Engineering (A.2.6)**.

---

## 9. Tariff Engine (Conceptual)

### 9.1 Purpose

The **tariff engine** applies the customer's electricity tariff to a load profile and produces the resulting bill.

It is the **single source of truth for behind-the-meter savings** (`SYS-ENG-DEF-001` §10.4). These are the demand charge reduction, energy charge reduction, and export credits that arise from BESS operation at a customer site.

### 9.2 Why It Lives in This Domain

The tariff engine belongs to Load & Market Engineering because **this domain owns the tariff structure**. Computing a bill applies that structure to a load profile.

This does not contradict §2.5. The distinction is:

| In scope of this domain | Out of scope of this domain |
|---|---|
| Applying a published tariff to a load profile to compute a customer bill | Market settlement: computing payments from ISO/RTO market participation |
| Deterministic bill computation from known tariff rules | Market simulation, price formation, clearing |
| Customer-side billing determinants (monthly peak, TOU energy) | Revenue from market products (belongs to Dispatch attribution and adapters) |

Computing a bill is **not** simulating a market. The tariff engine is a rule-application capability over a known structure.

### 9.3 Two Invocations

The tariff engine is invoked **twice per simulated billing period**:

```
Reference load (projected site load, no BESS)
        │
        ▼
  Tariff engine ──────► Bill WITHOUT BESS
                                            ├──► Savings (difference, by component)
Net load (after dispatch)                   │
        │                                   │
        ▼                                   │
  Tariff engine ──────► Bill WITH BESS ─────┘
```

The **net load** is composed of:

- Site load (from this domain)
- BESS charging and discharging (from Dispatch, Domain 4)
- BESS auxiliary consumption (from BESS Engineering, Domain 1, per `A.2.1-BESS-ENG-001` §7.3)

The tariff engine does **not** compute dispatch. It receives the net load after dispatch has been determined.

### 9.4 Tariff Elements to Be Representable

The tariff engine must be able to represent, conceptually:

| # | Element | Description |
|---|---|---|
| 1 | Energy charges | Flat, tiered, or time-of-use energy rates |
| 2 | Non-coincident demand charges | Charge on the customer's maximum demand in the billing period |
| 3 | Time-of-use demand charges | Charges on maximum demand within specific TOU windows |
| 4 | Coincident-peak charges | Charges based on the customer's demand at system or utility peak times |
| 5 | Demand ratchets | Billed demand floored at a fraction of a prior peak (e.g. the highest of the last 12 months) |
| 6 | Demand measurement interval | The averaging interval used to measure billed demand (e.g. 15-minute) |
| 7 | Billing period definition | Billing cycle boundaries, which may not align with calendar months |
| 8 | Seasonal structures | Different rates or TOU windows by season |
| 9 | Fixed and minimum charges | Customer charges and minimum-bill provisions |
| 10 | Export compensation | Net metering, export tariff, or no compensation for exported energy |

**Demand ratchets matter.** A ratchet can carry the cost of a single missed peak across many months. That makes the value of peak shaving highly sensitive to reliability.

**Demand measurement interval matters.** If billed demand is measured over 15-minute intervals, computing the bill from hourly data understates the true peak and therefore the savings (see `SYS-STR-FRM-001` §12.2 D14).

### 9.5 Relationship to Dispatch

The same tariff definition serves two purposes:

| Consumer | Use | Nature |
|---|---|---|
| **Dispatch (Domain 4)** | Energy rates and demand charge rates as **value signals** in the dispatch objective | May be a simplified representation of the tariff |
| **Tariff engine (this domain)** | Full bill computation on the resulting net load | **Authoritative** |

Where the two differ, **the tariff engine result is the one reported**. The size of the difference is itself a useful diagnostic of how well dispatch captures the tariff.

### 9.6 Tariff Escalation Over the Contract Term

Tariff rates change over a multi-year contract term. To avoid double escalation:

- **This domain** computes each year's bills using the tariff rates applicable to that year, as supplied by the scenario.
- **Financial Engineering (Domain 6)** consumes those savings as they are and does **not** re-escalate them.

Tariff escalation assumptions are scenario inputs. They are applied **once, here**.

### 9.7 Outputs

| Output | Nature |
|---|---|
| Bill without BESS | Per billing period, broken down by component (energy, demand, coincident peak, fixed, export credit) |
| Bill with BESS | Same structure |
| Savings by component | Difference between the two bills, per component and per billing period |
| Billing determinants | Billed peak demand, ratcheted demand, TOU energy per period, with and without BESS |

Component-level outputs let Financial Engineering and the application report **demand charge savings** and **energy charge savings** separately, as the RFP requires.

### 9.8 Boundary: Single Source of Truth

| Value | Source |
|---|---|
| Demand charge savings | Tariff engine (this domain) |
| Energy charge savings from TOU shifting behind the meter | Tariff engine (this domain) |
| Export credits | Tariff engine (this domain) |
| Wholesale market revenues (LMP arbitrage, regulation, reserves, capacity) | Dispatch attribution (Domain 4) via market adapters |
| DR program payments | Dispatch attribution (Domain 4) via program adapters, **even if paid as a bill credit** |

**DR payments are excluded from the tariff engine** even when the utility pays them as a credit on the bill. Including them in both places would double count.

### 9.9 Validation

| Check | Nature |
|---|---|
| **Historical bill reconciliation** | Applied to historical load, the tariff engine reproduces the customer's actual historical bills within an agreed tolerance |
| Zero-dispatch identity | With no BESS dispatch, the bill with BESS equals the bill without BESS, apart from the effect of auxiliary consumption |
| Determinant consistency | Billed demand equals the maximum of the correct measurement intervals within the billing period, including ratchet logic |
| Component completeness | The component breakdown sums to the total bill |

Historical bill reconciliation is the **strongest available validation** for behind-the-meter value. It requires ENGIE to provide actual customer bills alongside the corresponding interval meter data.

### 9.10 Deferred Decisions

| # | Decision | Stage |
|---|---|---|
| 1 | Tariff representation format | B |
| 2 | Which tariff elements are required for the target market's customers | Phase 1 (**B1**, **B2**) |
| 3 | Treatment of coincident-peak uncertainty (known vs. forecast peak hours) | A.2.4 |
| 4 | Reconciliation tolerance for historical bills | C (depends on **B5**) |
| 5 | Handling of taxes, riders, and pass-through charges | B |

---

## 10. Grid & Program Constraints (Conceptual)

### 10.1 Concepts

| Concept | Meaning |
|---|---|
| Interconnection limit | Maximum import/export capability at the site |
| Export constraint | Limit or prohibition on export |
| Program rules | Rules governing DR participation |
| Event window | Period during which a DR event can be called |
| Notification lead time | Minimum advance notice for a DR event |
| Performance measurement | Method to assess DR delivery (baseline vs. actual) |
| Penalty | Consequence of underperformance |
| Eligibility | Whether the BESS can participate in a given program |

### 10.2 Conceptual Requirements

The domain must be able to represent:

1. **Grid constraints** that limit BESS operation (as external conditions)
2. **Program rules** that shape DR participation
3. **Event definitions** — windows, duration, notification, frequency
4. **Performance measurement concepts** — how DR delivery will be assessed
5. **Penalty structures** conceptually (not their numerical computation)

### 10.3 Boundary Discipline

Grid constraints are **declared** by this domain and **respected** by Dispatch. The domain does not decide how the BESS responds — it declares the environment in which the response must occur.

---

## 11. External Signals (Conceptual)

### 11.1 Concept

All external signals — load, projected load, prices, program events, grid conditions, tariff structure, regulation statistics — are conceptually represented as **external signals available for downstream consumption**.

### 11.2 Conceptual Requirements

The domain must be able to represent:

1. **Alignment** of all signals to a common external time reference
2. **Resolution** appropriate to downstream consumption
3. **Coverage** of the simulation horizon
4. **Provenance** of each signal (historical, projected, assumed)
5. **Versioning** of signals (which projection was used when)

### 11.3 What Is Not Decided Here

- Physical storage format
- Time zone handling
- Interpolation strategy
- Missing data treatment
- Whether signals are persisted or passed in-memory

These belong to A.2.7 and Stage B.

---

## 12. Uncertainty — Scenario-Based (Conceptual)

### 12.1 Why Uncertainty Is Scenario-Based Here

Under the **perfect-foresight default** (`SYS-STR-FRM-001` §12.2 D2), dispatch consumes a single load and price trajectory per scenario. There is no stochastic dispatch in the initial scope.

Uncertainty is therefore represented **as scenarios**: multiple load and price trajectories, each internally deterministic.

This is a deliberate scoping decision. It preserves the ability to reason about uncertainty while keeping dispatch tractable within the engagement.

### 12.2 Conceptual Requirements

The domain must be able to represent:

1. **Multiple load scenarios** (growth variations, weather variations, operating variations)
2. **Multiple price scenarios** (price trajectories vary by scenario)
3. **Multiple combined scenarios** (load × price combinations)
4. **Scenario identity** (which scenario is which, for comparison)

### 12.3 Boundary

Scenarios are **declared** by this domain and **available to** Dispatch and Financial. Whether and how they are used is decided in those domains.

### 12.4 What Is Not Decided Here

- Number of scenarios
- Scenario construction methodology
- Whether Dispatch runs a single scenario or multiple
- Whether Financial performs sensitivity analysis beyond scenarios

These belong to A.2.4, A.2.6, and Phase 1 clarification **D11** (scenario granularity).

---

## 13. Market / Program Adapters (Conceptual)

### 13.1 Concept

Because the RFP references multiple markets and no single market is the target, the domain must conceptually support a **generic representation + market-specific adapters** structure.

### 13.2 Conceptual Structure

```
            Generic Market / Program Representation
                          │
                          ▼
                  Market Adapter (one at delivery)
                          │
                          ▼
            Specialized Market / Program Signals
```

The diagram shows **one adapter at delivery** — the target market's adapter (default **D13**). The architecture supports multiple adapters, and adding a second one is a later exercise, not an initial delivery commitment.

### 13.3 Conceptual Requirements

The domain must be able to represent:

1. A **generic market/product model** that is market-agnostic
2. A **specialization mechanism** (adapter) for market-specific rules
3. **Adapter extensibility** — the ability to add adapters without altering the generic model

### 13.4 Adapter Selection — Conceptual Posture

**Adapter selection is conceptually a configuration matter** — the choice of which market adapter to apply is an input to a scenario, not a hard-coded property of the platform.

The specific mechanism by which adapter selection is realized belongs to Stage B.

### 13.5 Adapters Are the Home of Market-Specific Rules

Market-specific rules — settlement logic, participation rules, performance measurement methodology, DR baseline methodology — **belong to adapters**, not to this domain.

This ensures:

- The generic representation stays clean and market-agnostic
- Market-specific behavior is isolated and replaceable
- New markets can be added without altering the generic model

### 13.6 What Is Not Decided Here

- Which specific adapters must be delivered at handover beyond the target market (default **D13**)
- Adapter interface details (Stage B)
- Adapter implementation (Stage C/D)
- Adapter selection mechanism (Stage B)

---

## 14. Interface with BESS Engineering (Conceptual)

### 14.1 Relationship

A.2.1 defines **BESS physical capability**. A.2.2 defines **external conditions**. They are independent inputs to downstream domains.

### 14.2 Conceptual Contract

| Direction | Content |
|---|---|
| **Load & Market → Operational** | Load conditions, price signals, program rules, grid constraints |
| **Load & Market → Dispatch** | Load, price signals, program rules, grid conditions, eligibility, tariff value signals, regulation statistics |
| **Load & Market → Financial** | Tariff bill outputs (with and without BESS), price signals, product definitions, DR rules |
| **BESS → Load & Market** | **Auxiliary consumption** (component of net load) |
| **Dispatch → Load & Market** | **Net load (post-dispatch)** for tariff engine |

### 14.3 Boundary Discipline

Load & Market declares **what the environment is** and **what the customer bill is**. It never declares what the BESS should do within that environment.

---

## 15. Interface with Operational Engineering (Conceptual)

Operational Engineering (A.2.3) will define **how the BESS can provide each value stream**. That domain consumes:

- Load conditions (for peak shaving and DR)
- Price signals (for arbitrage and regulation)
- Program rules (for DR)
- Grid constraints (for all value streams)

This domain does not prescribe how those value streams are modeled — it provides the environment in which they are evaluated.

---

## 16. Interface with Dispatch & Optimization (Conceptual)

Dispatch (A.2.4) will require the external environment as input. Conceptually, this includes:

| Signal Category | Conceptual Role in Dispatch |
|---|---|
| Load / projected load | Determines demand to be served or shaved |
| Energy price signals | Determine economic value of energy flows |
| Tariff value signals (energy rates, demand charge rates) | Determine economic value of behind-the-meter savings during dispatch |
| Ancillary price signals | Determine economic value of regulation/reserves |
| Capacity prices | Determine value of availability |
| DR program rules | Determine DR feasibility and value |
| Grid constraints | Constrain feasible BESS operation |
| Eligibility | Gate participation |
| Frequency regulation statistics | Enable coarse-resolution regulation modeling |
| Scenario variations | Available if multi-scenario dispatch is used |

The **precise list and format** of signals consumed by Dispatch is declared by Dispatch in A.2.4, not by this domain.

---

## 17. Interface with Financial Engineering (Conceptual)

Financial Engineering (A.2.6) will require:

- **Bill with and without BESS** (tariff engine output) — source of truth for behind-the-meter savings
- **Savings by component** (demand charge, energy charge, export credit)
- Market price signals (for market revenue attribution)
- Market product definitions (to attribute revenue by stream)
- DR program rules (to value DR participation)
- Load and price scenarios (for sensitivity)

As with Dispatch, the **precise list and format** of inputs consumed by Financial is declared by Financial in A.2.6.

---

## 18. Required External Input Information (Conceptual)

This section lists the **categories of information** the domain conceptually requires. It is **not** a data schema.

### 18.1 Information Categories

| # | Category | Examples of What It Describes (conceptual) |
|---|---|---|
| 1 | Historical load | Interval meter data (15-min or hourly), demand profiles |
| 2 | Peak demand history | Historical peak demand per billing period |
| 3 | Tariff structure | TOU periods, demand charges, energy charges, ratchets, coincident peak, export compensation |
| 4 | Historical customer bills | Bills corresponding to historical load (for tariff engine validation) |
| 5 | Energy price data | Day-ahead and real-time price projections |
| 6 | Ancillary price data | Regulation and reserve price signals |
| 7 | Ancillary statistical data | Energy per MW, signal bias, expected performance score |
| 8 | Capacity price data | Capacity market revenue signals |
| 9 | DR program parameters | Event windows, notification, duration, penalties, baseline methodology |
| 10 | Grid constraints | Interconnection limits, export constraints |
| 11 | Eligibility rules | Participation eligibility per market/program |
| 12 | Load projection configuration | Horizon, growth assumptions, scenario definitions |
| 13 | Tariff escalation assumptions | How tariff rates evolve over contract term |
| 14 | Scenario definitions | Load scenarios, price scenarios, combined scenarios |

### 18.2 Why This List Exists

This list connects A.2.2 directly to:

- **Data & Application Engineering (A.2.7)** — ingestion, validation, storage
- **Stage B (System Architecture)** — computational representation
- **Phase 1 clarification items** — particularly **B1, B2, B3**

It is a **bridge**, not a specification.

### 18.3 What Is Not Defined Here

- Data types, units, or formats
- Validation rules
- Default values or fallbacks
- Source of each input

These belong to A.2.7 and Stage B.

---

## 19. Assumptions and Engineering Uncertainties

### 19.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | External signals are conceptually alignable to a common external time reference | Enables coherent downstream consumption | Multi-base alignment would need explicit representation |
| 2 | Load and market data are available at the resolution required by the RFP | Matches RFP expectation | Resolution assumptions would need revision |
| 3 | Market products are representable via a generic model with adapters | Enables reusability | Hard-coded per-market representation would be required |
| 4 | Uncertainty is representable as scenarios, not as stochastic processes | Consistent with perfect-foresight default | Stochastic dispatch would be required |
| 5 | DR program rules are declarable as input, not computed internally | Keeps domain boundary clean | Rule computation would blur domain responsibility |
| 6 | **The BESS is modeled as a price-taker** | Standard assumption for planning-grade tools | For large batteries in small ancillary markets, prices would need to be supplied as scenarios reflecting the BESS's impact |
| 7 | The tariff engine is deterministic given tariff and load | Standard for planning-grade tools | Would need stochastic tariff treatment otherwise |

### 19.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Target market(s) | **B1** |
| 2 | Load projection methodology | **D5** |
| 3 | Market adapter scope at delivery | **D13** |
| 4 | Scenario construction | Stage B / **D11** |
| 5 | Data availability from ENGIE | **B3** |
| 6 | Whether projection is ENGIE-provided or platform-computed | **D5** / **D7** |
| 7 | Short-horizon forecast: needed or not (depends on foresight default) | **D2** |
| 8 | Tariff engine: which elements are required for the target market | **B1** / **B2** |
| 9 | Availability of historical customer bills for reconciliation | **B3** |
| 10 | Reconciliation tolerance for historical bills | **B5** |

### 19.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `SYS-STR-FRM-001` §12:

- **B1** — Target market(s)
- **B2** — Behind-the-meter vs. front-of-the-meter scope
- **B3** — Data availability
- **B5** — Acceptance thresholds (affects tariff reconciliation tolerance)
- **D2** — Perfect foresight vs. forecast-based dispatch
- **D5** — Load forecasting method
- **D7** — Load forecasting home (conceptually resolved here: **Domain 2 owns it**)
- **D11** — Scenario granularity
- **D13** — Market adapter scope
- **D14** — Time resolution (affects demand measurement interval)
- **New question to ENGIE** — Historical customer bills available for tariff engine reconciliation?

---

## 20. Conceptual Outputs of the Domain

The domain exposes the following **conceptual outputs** to the rest of the system:

| Output | Nature |
|---|---|
| Historical load profile | Time series |
| Projected load scenarios | Time series, per scenario |
| Peak demand | Scalar per billing period |
| Energy price signals (DA, RT) | Time series |
| TOU tariff structure | Period definitions + rates |
| Ancillary service signals | Time series + product definitions |
| Ancillary statistical characteristics | Energy per MW, signal bias, expected performance score |
| Capacity market signals | Time series + product definitions |
| DR program rules | Event rules, windows, penalties, baseline methodology (via adapter) |
| Grid constraints | Limits and eligibility |
| Eligibility envelope | Participation conditions |
| **Bill without BESS** | Per billing period, by component |
| **Bill with BESS** | Per billing period, by component |
| **Savings by component** | Demand charge, energy charge, export credit |
| **Billing determinants** | Billed demand, ratcheted demand, TOU energy |

**Consumer mapping** — which downstream domain consumes which output — is declared by each downstream domain in its own document (A.2.3, A.2.4, A.2.6).

---

## 21. Validation Requirements (Conceptual)

Following the Validation cross-cutting capability in `SYS-ENG-DEF-001` §4.1.

### 21.1 Domain-Level Validation

| Check | Nature |
|---|---|
| **Historical bill reconciliation** | Applied to historical load, the tariff engine reproduces the customer's actual historical bills within an agreed tolerance |
| Load consistency | Historical load is internally consistent over time |
| Projection plausibility | Projected load respects historical patterns and growth assumptions |
| Price signal consistency | Prices are non-negative where required and aligned in time |
| Tariff structural validity | TOU periods are contiguous and cover the horizon |
| Program rule completeness | Each DR program has all required parameters |
| Grid constraint completeness | All declared constraints are representable |
| Regulation statistics consistency | Energy per MW, bias, and performance score are mutually consistent |

### 21.2 Interface Validation

| Check | Nature |
|---|---|
| Time alignment | All signals share a common external time reference |
| Horizon coverage | All signals cover the required simulation horizon |
| Downstream completeness | Downstream domains receive a complete external environment |
| Adapter consistency | Market adapters produce signals compatible with the generic representation |
| Net load composition | Net load received from Dispatch includes BESS charge/discharge and auxiliary consumption |
| Zero-dispatch identity | Without BESS dispatch, bill with BESS equals bill without BESS, apart from auxiliary consumption |

### 21.3 Validation Evidence

Validation evidence must be **produced before results are accepted**, not reconstructed afterward. This follows the principle in `SYS-STR-FRM-001` §8.2.

---

## 22. Boundaries — Explicit

### 22.1 Answers

- What is happening outside the BESS?
- What load must be served?
- What projection must be planned against?
- What market products are monetizable?
- What price signals exist?
- What program rules govern participation?
- What grid and regulatory constraints apply?
- What tariff structure defines customer savings?
- **What is the customer bill with and without BESS?**
- What uncertainty surrounds the external signals?

### 22.2 Does Not Answer

- What should the BESS do?
- How should the BESS be dispatched?
- How much does the BESS degrade?
- How is market revenue computed?
- How is market settlement computed?
- How are market prices generated?
- What is the total project financial value?
- How is data ingested, transformed, or displayed?

Each of these belongs to another domain, as declared in `SYS-ENG-DEF-001` §12.

### 22.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| Load & Market | Operational | External operating conditions |
| Load & Market | Dispatch | External signals available for dispatch, including tariff value signals and regulation statistics |
| Load & Market | Financial | **Bill with and without BESS; savings by component** — source of truth for behind-the-meter savings |
| BESS Engineering | Load & Market | **Auxiliary consumption** (component of net load) |
| Dispatch | Load & Market | **Net load (post-dispatch)** for tariff engine |

---

## 23. What Is Deliberately NOT Defined Here

This document intentionally does **not** freeze:

### Mathematical Formulation
- Projection equations
- Price signal models
- Tariff rate structures (beyond categories)
- Baseline methodology equations

### Software Structure
- Classes, functions, APIs
- Data structures
- Storage representation
- Adapter interface

### Numerical Methods
- Projection algorithm choice
- Time series modeling
- Interpolation strategy
- Missing data treatment

### Data Contracts
- Signal schemas
- Units convention
- Time zone handling
- Versioning mechanism

### Integration Details
- How signals are passed to Dispatch
- How scenarios are propagated
- How adapters are selected

### Market-Specific Rules
- PJM RegD settlement details
- ERCOT FFR settlement details
- LMP computation
- Capacity market auction rules

### Market Simulation
- Price formation
- Clearing algorithms
- Market dynamics

### Tariff Engine Implementation
- Tariff representation format
- Reconciliation tolerance
- Handling of taxes, riders, and pass-through charges

These belong to Stages B, C, and D, or to market adapters.

---

## 24. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.6 | §1.1, §3.3 Market Scope, §5 Domain 2, §6.2 Causal Backbone, §8.2 Validation, §12.1/12.2 Phase 1 items | Yes |
| `SYS-ENG-DEF-001` v0.4 | §6 Domain 2 (including tariff engine), §4.1 Cross-cutting capabilities, §10.4 Single source of truth, §12 Inter-Domain Contract | Yes |
| `A.2.1-BESS-ENG-001` v1.1 | §7.3 Auxiliary consumption, boundary discipline pattern | Yes |
| RFP-264144-1 | Load data + forecasting, LMP, TOU, ancillary, capacity, DR, grid constraints, eligibility, tariff-based savings | Yes |
| RFP-264144-1 | "Load forecasting capability... primary input to dispatch optimization and financial modeling" | Yes — §6 |

---

## 25. Engineering Decisions Deferred to Later Stages

This section consolidates all decisions that are **deliberately not made** in this document.

| # | Decision | Stage | Rationale |
|---|---|---|---|
| 1 | Projection methodology | B / **D5** | Depends on data availability and ENGIE preference |
| 2 | Scenario construction | B / **D11** | Depends on downstream requirements |
| 3 | Market adapter interface | B | Architecture decision |
| 4 | Which adapters to deliver beyond target market | **D13** | Scope decision |
| 5 | Signal storage and time-indexing conventions | B | Architecture decision |
| 6 | Validation tolerances for load and price signals | C | Detailed engineering |
| 7 | Baseline methodology | Adapter / B | Program-specific |
| 8 | Market-specific settlement rules | C / D | Adapter implementation |
| 9 | Adapter selection mechanism | B | Architecture decision |
| 10 | Tariff representation format | B | Architecture decision |
| 11 | Which tariff elements are in scope | **B1** / **B2** | Scope decision |
| 12 | Coincident-peak uncertainty treatment | A.2.4 | Dispatch decision |
| 13 | Reconciliation tolerance for historical bills | C / **B5** | Depends on acceptance thresholds |
| 14 | Handling of taxes, riders, pass-through charges | B | Architecture decision |
| 15 | Short-horizon forecast: needed or not | **D2** | Depends on foresight default |

---

## 26. Next Steps

This document establishes the **conceptual engineering baseline** for Domain 2 — Load & Market Engineering.

The Stage A.2 chapters are developed in the priority order defined in `SYS-ENG-DEF-001` §19, prioritizing thin-slice blockers:

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.4 | Dispatch & Optimization Engineering | ⏭ Next |
| 2 | A.2.5 | Degradation Engineering | ⏭ Next |
| 3 | A.2.1 | BESS Engineering | ✅ Baselined (v1.1) |
| 4 | A.2.2 | Load & Market Engineering | ✅ **This document** — Baselined |
| 5 | A.2.3 | Operational Engineering | ⏭ Pending |
| 6 | A.2.6 | Financial Engineering | ⏭ Pending |
| 7 | A.2.7 | Data & Application Engineering | ⏭ Pending |

Phase 1 clarification items are organized as **blocking (B1–B5)** and **defaultable (D1–D15)** in `SYS-STR-FRM-001` §12. This domain's dependencies are listed in §19.3.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.2 — Conceptual Engineering (Load & Market Engineering)
**Status:** Conceptual Engineering Baseline — **CLOSED**
**Duration:** 12 Weeks
**Language:** English

---

**BESS Operational & Financial Modeling (RFP-264144-1): Observations and Clarification Requests**


1. Historical bills for tariff validation. Can ENGIE provide actual customer bills, together with the matching interval meter data, for at least one reference site? Reproducing historical bills is the strongest validation of behind-the-meter savings. Proposal: reconciliation within ±2–3% of the actual billed amount.
2. Load projection over the contract term. What load growth assumptions should apply? Are site changes expected, such as expansions, electrification or EV charging? These can shift both peaks and savings materially over 10–15 years.
3. Tariff evolution and tariff switching. How should tariff escalation be projected? Should the tool also evaluate tariff switching? A battery can make a customer eligible for a more favorable rate, and that is sometimes the largest source of value.
4. Coincident-peak charges. Where tariffs or markets include coincident-peak charges (e.g. ERCOT 4CP, PJM 5CP), does ENGIE have a peak-prediction approach? If not, the proposal is to assume the peak hours are known, applying a configurable hit-rate factor.
5. DR payments paid as bill credits. Which DR programs in scope are utility tariff riders paid as bill credits? The tool counts DR value in one place only, as program revenue, and needs to know which programs to exclude from the bill calculation.
6. Price-taker assumption and ancillary saturation. The tool assumes the battery does not affect market prices. For large projects in small ancillary-service markets, prices tend to fall as storage capacity grows. Does ENGIE have ancillary price projections that already reflect this saturation, and should they be used as price scenarios?
7. Regulation assumptions. If historical regulation signal data is unavailable (see item 7), does ENGIE have internal assumptions it would like to use for energy throughput per MW of regulation capacity, signal bias and expected performance score?