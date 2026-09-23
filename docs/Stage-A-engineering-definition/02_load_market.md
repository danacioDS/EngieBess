
---

# Load & Market Engineering
## Stage A.2.2 — Conceptual Engineering
### External Operating Environment of the BESS Operational & Financial Modeling System

**Document ID:** A.2.2-LOAD-MKT-ENG-001

**Version:** 1.0 — Conceptual Engineering Baseline (Closed)

**Status:** Stage A.2 — Conceptual Engineering (Domain Level) — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.3)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.3)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.0)

**Domain:** Domain 2 — Load & Market Engineering

**Purpose:** Define, at a conceptual level, what the Load & Market Engineering domain represents, what external conditions it must produce, what it consumes, how it interacts with the other six domains, and what engineering decisions must be made in later stages — **without** entering into equations, data schemas, class structures, or software architecture.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.2 — Conceptual Engineering** of the Load & Market Engineering domain, the second of seven domain documents defined in `SYS-ENG-DEF-001` §1.1.

Its purpose is to establish the **conceptual engineering definition** of the **external operating environment** in which the BESS operates — the electricity demand, the load forecast, the market products, the price signals, the program rules, and the grid/regulatory constraints that determine the BESS's potential value.

It answers, at conceptual level:

- What is being modeled externally
- What external signals must be representable
- What forecast must be produced
- What market products and program rules must be representable
- What uncertainty must be carried
- What it exposes to other domains
- What it does **not** decide (and who decides it)

It deliberately does **not** define:

- Forecasting algorithms
- Market settlement equations
- Market simulation
- Revenue calculation
- Data schemas
- Ingestion pipelines
- Market-specific numerical rules
- Software architecture
- Python classes or APIs

Those belong to Stages B, C, and D.

### 1.1 Position Within Stage A

Stage A is delivered in two levels:

| Level | Name | Deliverable |
|---|---|---|
| A.1 | System Component Definition | `SYS-ENG-DEF-001` — eagle-eye view of the seven domains |
| A.2 | Conceptual Engineering per Domain | Seven domain documents; this is the second |

This document refines **Domain 2** of `SYS-ENG-DEF-001` §6 from an eagle-eye definition into a conceptual engineering baseline.

### 1.2 Relationship to A.2.1

A.2.1 established **what the BESS can physically do**.

A.2.2 establishes **under what external conditions the BESS operates**.

Both are **inputs** to Operational Engineering (A.2.3), which will define *how* the BESS can be used; and to Dispatch & Optimization (A.2.4), which will define *what should be done* given physical capability plus external conditions.

### 1.3 Generality Principle

This document defines a **generic external environment model** — one that can be parameterized for different markets, jurisdictions, programs, and client load profiles.

It does **not** hard-code:

- A specific ISO/RTO (PJM, ERCOT, CAISO, MISO, etc.)
- A specific market product (RegD, FFR, LMP-DA, etc.)
- A specific tariff structure
- A specific DR program
- A specific forecasting methodology

The RFP explicitly references multiple market constructs (PJM RegD, ERCOT FFR, day-ahead LMP, real-time LMP, ancillary services, capacity markets, DR programs, TOU tariffs). This document treats them as **instances of a generic market/program representation**, with market-specific rules handled by **adapters** (see §12).

This is the correct architectural posture: the platform should be a **reusable modeling engine**, not a model hard-coded for one market.

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Load & Market Engineering domain** is the conceptual representation of the **external operating environment** of the BESS — the electricity demand it serves, the load forecast it must plan against, the market products it can monetize, the price signals it responds to, the program rules it must comply with, and the grid/regulatory constraints it must respect.

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
| A revenue calculator | Revenue attribution belongs to Operational, Dispatch, and Financial Engineering |
| A forecasting algorithm specification | Algorithms belong to Stage B/C |
| A data pipeline | Ingestion belongs to Domain 7 |

### 2.3 Primary Question

> **Under what external conditions does the BESS operate?**

### 2.4 Guiding Principle

> **This domain defines the external environment — never the BESS response, never the dispatch decision, never the economic valuation.**

Any responsibility that would answer *"what should the BESS do?"*, *"how should the BESS be dispatched?"*, or *"what is this worth?"* belongs to another domain.

### 2.5 Boundary Warning — This Is Not a Market Engine

This domain represents **external conditions, signals, rules, and constraints**.

It does **not** become a *market simulation engine*, a *settlement engine*, or a *revenue calculator*.

| This domain does | This domain does not |
|---|---|
| Declare what the market environment is | Simulate market behavior |
| Represent price signals as inputs | Compute prices from market dynamics |
| Represent program rules | Compute program outcomes |
| Represent eligibility | Compute revenue |
| Represent constraints | Compute settlement |

This warning is stated explicitly because market modeling domains have a natural tendency to absorb responsibilities that properly belong to adapters, Operational Engineering, Dispatch, or Financial Engineering.

---

## 3. Engineering Scope

The domain must conceptually represent the following aspects of the external environment:

| # | Aspect | Description |
|---|---|---|
| 1 | Load | Historical and current electricity consumption of the site |
| 2 | Load forecast | Projection of future consumption over the relevant horizons |
| 3 | Tariffs | Energy charges, demand charges, TOU structures, billing determinants |
| 4 | Energy markets | Day-ahead and real-time energy prices (LMP or equivalent) |
| 5 | Ancillary markets | Frequency regulation, reserves, and related products |
| 6 | Capacity markets | Capacity revenues and obligations |
| 7 | Demand response programs | Event rules, notification, performance measurement, penalties |
| 8 | Grid constraints | Interconnection limits, export constraints, curtailment |
| 9 | Regulatory constraints | Participation eligibility, jurisdictional rules |
| 10 | Forecast uncertainty | Uncertainty attached to load and price forecasts |
| 11 | Market / program adapters | Mechanism to specialize the generic model per market |
| 12 | External signals | The collected external signals consumed downstream |

The domain does **not** compute BESS behavior, dispatch, or financial results — it produces the **external signals** consumed by those domains.

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
   Forecast          Capacity, DR       export constraints
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
                 EXTERNAL CONDITIONS
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
    Operational       Dispatch          Financial
```

Each stream is conceptually independent (its own inputs, its own uncertainty) but all three feed the same downstream domains.

### 4.2 Conceptual Sub-Areas

| Sub-Area | Conceptual Role |
|---|---|
| Load Engineering | Represents electricity demand at the site |
| Load Forecasting | Produces forecast demand over relevant horizons |
| Market Engineering | Represents market products and price signals |
| Market Products / Value Signals | Represents specific monetizable products |
| Grid & Program Constraints | Represents the rules that gate or shape participation |
| External Signals | External signals available for downstream consumption |
| Forecast Uncertainty | Uncertainty attached to load and price forecasts |
| Market / Program Adapters | Specialization layer for market-specific rules |

Each sub-area is treated in the following sections.

### 4.3 External Boundary

| Inside the domain | Outside the domain |
|---|---|
| Load, forecast load | BESS physics |
| Tariffs, prices, market products | Operational behavior |
| DR program rules | Dispatch decisions |
| Grid constraints | Financial valuation |
| Forecast uncertainty | Settlement computation |
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
| Billing determinants | Quantities used in tariff calculation (kWh, kW, etc.) |

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

### 5.4 What Is Not Decided Here

- Time resolution beyond what the RFP requires
- Data quality treatment (belongs to A.2.7)
- Baseline calculation methodology details (belongs to Stage B/C, and may be program-specific)
- Handling of missing or anomalous intervals

These belong to Stage B/C and A.2.7.

---

## 6. Load Forecasting (Conceptual)

### 6.1 Why Forecasting Exists

The RFP explicitly requires:

> "The software shall include a load forecasting capability to project client electricity consumption over the relevant time horizons, serving as a primary input to dispatch optimization and financial modeling."

Forecasting is therefore a **first-class conceptual capability**, not merely a data-handling step.

### 6.2 Conceptual Pipeline

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
Forecasting
       │
       ▼
Forecast Load
       │
       ├──────────────► Dispatch
       │
       └──────────────► Financial
```

### 6.3 Conceptual Requirements

The domain must be able to represent:

1. **A forecast horizon** appropriate to the dispatch and financial timescales
2. **A forecast output** — a projected load profile
3. **A forecast method** — still deferred, but the domain must be capable of representing whichever method is chosen
4. **Forecast uncertainty** as a first-class attribute (see §11)

### 6.4 Conceptual Ownership

**Load forecasting belongs conceptually to Load & Market Engineering.**

Its **computational implementation** may use capabilities from Data & Application Engineering (A.2.7). This distinction matters:

> **Conceptual ownership ≠ software implementation location.**

The forecasting capability is *owned* by this domain because it produces an external signal consumed by Dispatch and Financial. It may be *implemented* using data pipelines and tools that belong to Domain 7.

This is the correct reading of Phase 1 clarification item 12 (load forecasting home), and it should be confirmed during Phase 1, but the conceptual answer is: **Domain 2 owns it**.

### 6.5 What Is Not Decided Here

- Statistical vs. ML-based vs. hybrid methodology
- Whether ENGIE provides forecasts directly
- Forecast horizon granularity
- Forecast update frequency
- How uncertainty is quantified

These belong to Stage B/C and depend on Phase 1 clarification.

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
- **Market-specific adapters** that specialize the generic representation (§12)

This is the correct architectural response to the RFP's reference to multiple markets (PJM RegD, ERCOT FFR, etc.) without a single target market.

### 7.4 Market-Specific Rules Belong to Adapters

Market-specific rules — settlement logic, participation rules, performance measurement — are **not** defined by this domain. They are **declared conceptually** here as inputs that adapters will provide, and their actual computation belongs to **market adapters**.

This separation ensures that A.2.2 does not absorb responsibilities that properly belong to adapter modules, and that the generic representation stays clean.

### 7.5 No Market Simulation

This domain does **not** simulate market behavior. Prices, clearing outcomes, and market dynamics are **inputs** — supplied by ENGIE, by historical data, by projections, or by market adapters — never **computed** by this domain.

| This domain does | This domain does not |
|---|---|
| Represent price signals | Generate price signals from market dynamics |
| Represent product rules | Simulate market clearing |
| Represent eligibility | Compute participation outcomes |

### 7.6 What Is Not Decided Here

- Which markets are in scope (Phase 1 item 1)
- Exact settlement rules per market
- Adapter implementation details
- Price signal validation rules

These belong to Stage B/C and Phase 1 clarification.

---

## 8. Market Products / Value Signals (Conceptual)

### 8.1 Concept

A **market product** (or **value signal**) is a specific monetizable or compensable product the BESS can participate in. Each product has its own:

- Price signal (or revenue mechanism)
- Eligibility rules
- Performance requirements
- Signal representation required for downstream consumption

Settlement logic and revenue computation are **not** part of this domain — they belong to the market adapters that specialize the generic representation (§12) and to Operational, Dispatch, and Financial Engineering.

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

### 8.3 Conceptual Requirements

The domain must be able to represent:

1. The **identity** of each product in scope
2. The **price or revenue mechanism** associated with each
3. The **eligibility conditions** for the BESS to participate
4. The **performance requirements** (e.g., minimum duration, ramp rate)
5. The **signal representation** required for downstream consumption

### 8.4 Relationship to Operational Engineering

Market products define **what is monetizable**. Operational Engineering defines **how the BESS provides the service**. The two must not be conflated.

### 8.5 No Revenue Calculation

This domain does **not** calculate revenue. It represents the **mechanism by which revenue can arise** — not the amount, not the attribution, not the timing of cash flow.

| This domain does | This domain does not |
|---|---|
| Declare that a DR event pays $X/kW-month | Compute DR revenue |
| Declare that regulation pays per mileage | Compute regulation revenue |
| Declare that demand charges are $Y/kW | Compute demand charge savings |

Revenue calculation belongs to **Financial Engineering (A.2.6)**, supported by **Operational Engineering (A.2.3)** and **Dispatch (A.2.4)**.

---

## 9. Grid & Program Constraints (Conceptual)

### 9.1 Concepts

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

### 9.2 Conceptual Requirements

The domain must be able to represent:

1. **Grid constraints** that limit BESS operation (as external conditions)
2. **Program rules** that shape DR participation
3. **Event definitions** — windows, duration, notification, frequency
4. **Performance measurement concepts** — how DR delivery will be assessed
5. **Penalty structures** conceptually (not their numerical computation)

### 9.3 Boundary Discipline

Grid constraints are **declared** by this domain and **respected** by Dispatch. The domain does not decide how the BESS responds — it declares the environment in which the response must occur.

---

## 10. External Signals (Conceptual)

### 10.1 Concept

All external signals — load, forecast load, prices, program events, grid conditions — are conceptually represented as **external signals available for downstream consumption**.

### 10.2 Conceptual Requirements

The domain must be able to represent:

1. **Alignment** of all signals to a common external time reference
2. **Resolution** appropriate to downstream consumption
3. **Coverage** of the simulation horizon
4. **Provenance** of each signal (historical, forecast, assumed)
5. **Versioning** of signals (which forecast was used when)

### 10.3 What Is Not Decided Here

- Physical storage format
- Time zone handling
- Interpolation strategy
- Missing data treatment
- Whether signals are persisted or passed in-memory

These belong to A.2.7 and Stage B.

---

## 11. Forecast Uncertainty (Conceptual)

### 11.1 Why Uncertainty Matters

Load and price forecasts are **not deterministic**. The domain must be able to represent **that uncertainty exists**, so that Dispatch and Financial Engineering can, in principle, account for it.

### 11.2 Conceptual Requirements

The domain must be able to represent:

1. **Uncertainty attached to load forecasts**
2. **Uncertainty attached to price forecasts** (where applicable)
3. **Scenario-based uncertainty** (multiple forecast realizations)
4. **Confidence or range** information conceptually

### 11.3 Boundary

Uncertainty is **declared** by this domain and **available to** Dispatch and Financial. Whether and how it is used is decided in those domains.

### 11.4 What Is Not Decided Here

- Probabilistic vs. scenario-based representation
- How uncertainty is quantified
- Whether Dispatch is uncertainty-aware
- Whether Financial performs sensitivity analysis

These belong to A.2.4 and A.2.6.

---

## 12. Market / Program Adapters (Conceptual)

### 12.1 Concept

Because the RFP references multiple markets (PJM RegD, ERCOT FFR, LMP, capacity, DR, TOU), and because no single market is the target, the domain must conceptually support a **generic representation + market-specific adapters** structure.

### 12.2 Conceptual Structure

```
            Generic Market / Program Representation
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
    PJM Adapter       ERCOT Adapter     Generic TOU Adapter
    (RegD, etc.)      (FFR, etc.)       (tariff structures)
                          │
                          ▼
            Specialized Market / Program Signals
```

### 12.3 Conceptual Requirements

The domain must be able to represent:

1. A **generic market/product model** that is market-agnostic
2. A **specialization mechanism** (adapter) for market-specific rules
3. Multiple adapters coexisting in the platform
4. A conceptual distinction between generic signals and adapter-specific signals

### 12.4 Adapter Selection — Conceptual Posture

**Adapter selection is conceptually a configuration matter** — that is, the choice of which market adapter to apply is an input to a scenario, not a hard-coded property of the platform.

This is stated here as a **conceptual requirement**, not as an architectural decision. The specific mechanism by which adapter selection is realized (configuration files, scenario parameters, application settings, etc.) belongs to Stage B.

### 12.5 Adapters Are the Home of Market-Specific Rules

Market-specific rules — settlement logic, participation rules, performance measurement methodology — **belong to adapters**, not to this domain.

This ensures:

- The generic representation stays clean and market-agnostic
- Market-specific behavior is isolated and replaceable
- New markets can be added without altering the generic model

### 12.6 What Is Not Decided Here

- Which adapters must be delivered at handover (Phase 1 item 9)
- Adapter interface details (Stage B)
- Adapter implementation (Stage C/D)
- Adapter selection mechanism (Stage B)

---

## 13. Interface with BESS Engineering (Conceptual)

### 13.1 Relationship

A.2.1 defines **BESS physical capability**. A.2.2 defines **external conditions**. They are independent inputs.

BESS Engineering does not consume signals from Load & Market. Load & Market does not consume BESS state. Both feed Operational and Dispatch.

### 13.2 Conceptual Contract

| Direction | Content |
|---|---|
| **Load & Market → Operational** | Load conditions, price signals, program rules, grid constraints |
| **Load & Market → Dispatch** | Forecast load, price signals, program rules, grid conditions, eligibility |
| **Load & Market → Financial** | Tariff structures, market price signals, product definitions relevant to revenue attribution |
| **BESS → Load & Market** | None |

The specific list of signals consumed by Dispatch and Financial is a **conceptual expectation** of what those domains will require. It will be **refined and confirmed in A.2.4 and A.2.6** respectively, where each downstream domain declares its own input requirements.

### 13.3 Boundary Discipline

Load & Market declares **what the environment is**. It never declares what the BESS should do within that environment.

---

## 14. Interface with Operational Engineering (Conceptual)

Operational Engineering (A.2.3) will define **how the BESS can provide each value stream**. That domain consumes:

- Load conditions (for peak shaving and DR)
- Price signals (for arbitrage and regulation)
- Program rules (for DR)
- Grid constraints (for all value streams)

This domain does not prescribe how those value streams are modeled — it provides the environment in which they are evaluated.

---

## 15. Interface with Dispatch & Optimization (Conceptual)

Dispatch (A.2.4) will require the external environment as input. Conceptually, this includes:

| Signal Category | Conceptual Role in Dispatch |
|---|---|
| Forecast load | Determines demand to be served or shaved |
| Price signals | Determine economic value of energy flows |
| Ancillary price signals | Determine economic value of regulation/reserves |
| Capacity prices | Determine value of availability |
| DR program rules | Determine DR feasibility and value |
| Grid constraints | Constrain feasible BESS operation |
| Eligibility | Gate participation |
| Forecast uncertainty | Optional input to robust or scenario-based dispatch |

The **precise list and format** of signals consumed by Dispatch is declared by Dispatch in A.2.4, not by this domain. A.2.2 declares only that these external signals exist and are available.

---

## 16. Interface with Financial Engineering (Conceptual)

Financial Engineering (A.2.6) will require:

- Tariff structures (for demand charge and energy charge savings)
- Market price signals (for revenue attribution)
- Market product definitions (to attribute revenue by stream)
- DR program rules (to value DR participation)

As with Dispatch, the **precise list and format** of signals consumed by Financial is declared by Financial in A.2.6, not by this domain. A.2.2 declares only that these external signals exist and are available.

---

## 17. Required External Input Information (Conceptual)

This section lists the **categories of information** the domain conceptually requires. It is **not** a data schema, **not** a parameter list, and **not** a data model.

### 17.1 Information Categories

| # | Category | Examples of What It Describes (conceptual) |
|---|---|---|
| 1 | Historical load | Interval meter data (15-min or hourly), demand profiles |
| 2 | Peak demand history | Historical peak demand per billing period |
| 3 | Tariff structure | TOU periods, demand charges, energy charges |
| 4 | Energy price forecasts | Day-ahead and real-time price projections |
| 5 | Ancillary price data | Regulation and reserve price signals |
| 6 | Capacity price data | Capacity market revenue signals |
| 7 | DR program parameters | Event windows, notification, duration, penalties |
| 8 | Grid constraints | Interconnection limits, export constraints |
| 9 | Eligibility rules | Participation eligibility per market/program |
| 10 | Forecast configuration | Horizon, resolution, methodology selection |
| 11 | Uncertainty configuration | Whether and how forecast uncertainty is represented |

### 17.2 Why This List Exists

This list connects A.2.2 directly to:

- **Data & Application Engineering (A.2.7)** — which will define how this information is ingested, validated, and stored
- **Stage B (System Architecture)** — which will define how this information is represented computationally
- **Phase 1 clarification items** — particularly items 1, 4, 8, and 12

It is a **bridge**, not a specification.

### 17.3 What Is Not Defined Here

- Data types, units, or formats
- Validation rules
- Default values or fallbacks
- Source of each input

These belong to A.2.7 and Stage B.

---

## 18. Assumptions and Engineering Uncertainties

### 18.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | External signals are conceptually alignable to a common external time reference | Enables coherent downstream consumption | Multi-base alignment would need explicit representation |
| 2 | Load and market data are available at the resolution required by the RFP | Matches RFP expectation | Resolution assumptions would need revision |
| 3 | Market products are representable via a generic model with adapters | Enables reusability | Hard-coded per-market representation would be required |
| 4 | Forecast uncertainty is representable but not necessarily used downstream | Keeps interface clean at Stage A.2 | Downstream domains would need to declare use of uncertainty |
| 5 | DR program rules are declarable as input, not computed internally | Keeps domain boundary clean | Rule computation would blur domain responsibility |

### 18.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Target market(s) | Phase 1 item 1 |
| 2 | Load forecasting methodology | Phase 1 item 4 |
| 3 | Market adapter scope at delivery | Phase 1 item 9 |
| 4 | Uncertainty representation (probabilistic vs. scenario) | Stage B |
| 5 | Data availability from ENGIE | Phase 1 item 8 |
| 6 | Whether forecasting is ENGIE-provided or platform-computed | Phase 1 item 4 / item 12 |

### 18.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `SYS-STR-FRM-001` §12:

- **Item 1** — Target market(s)
- **Item 4** — Load forecasting method
- **Item 8** — Data availability
- **Item 9** — Market adapter scope
- **Item 12** — Load forecasting home (conceptually resolved here: **Domain 2 owns it**; implementation may use Domain 7 capabilities)

---

## 19. Conceptual Outputs of the Domain

The domain exposes the following **conceptual outputs** to the rest of the system:

| Output | Nature |
|---|---|
| Forecast load profile | Time series with uncertainty |
| Historical load profile | Time series |
| Peak demand | Scalar per billing period |
| Energy price signals (DA, RT) | Time series |
| TOU tariff structure | Period definitions + rates |
| Ancillary service signals | Time series + product definitions |
| Capacity market signals | Time series + product definitions |
| DR program rules | Event rules, windows, penalties |
| Grid constraints | Limits and eligibility |
| Eligibility envelope | Participation conditions |
| Forecast uncertainty | Range or scenario set |

**Consumer mapping** — which downstream domain consumes which output — is declared by each downstream domain in its own document (A.2.3, A.2.4, A.2.6).

---

## 20. Validation Requirements (Conceptual)

Following the Validation cross-cutting capability in `SYS-ENG-DEF-001` §13.2.

### 20.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Load consistency | Historical load is internally consistent over time |
| Forecast plausibility | Forecast load respects historical patterns |
| Price signal consistency | Prices are non-negative where required and aligned in time |
| Tariff structural validity | TOU periods are contiguous and cover the horizon |
| Program rule completeness | Each DR program has all required parameters |
| Grid constraint completeness | All declared constraints are representable |

### 20.2 Interface Validation

| Check | Nature |
|---|---|
| Time alignment | All signals share a common external time reference |
| Horizon coverage | All signals cover the required simulation horizon |
| Downstream completeness | Downstream domains receive a complete external environment |
| Adapter consistency | Market adapters produce signals compatible with the generic representation |

### 20.3 Validation Evidence

Validation evidence must be **produced before results are accepted**, not reconstructed afterward. This follows the principle in `SYS-STR-FRM-001` §8.2.

---

## 21. Boundaries — Explicit

### 21.1 Answers

- What is happening outside the BESS?
- What load must be served?
- What forecast must be planned against?
- What market products are monetizable?
- What price signals exist?
- What program rules govern participation?
- What grid and regulatory constraints apply?
- What uncertainty surrounds the external signals?

### 21.2 Does Not Answer

- What should the BESS do?
- How should the BESS be dispatched?
- How much does the BESS degrade?
- What is the economic value of the operation?
- How is revenue computed?
- How is settlement computed?
- How are market prices generated?
- How is data ingested, transformed, or displayed?

Each of these belongs to another domain, as declared in `SYS-ENG-DEF-001` §12.

### 21.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| Load & Market | Operational | External operating conditions |
| Load & Market | Dispatch | External signals available for dispatch |
| Load & Market | Financial | External signals available for financial valuation |
| BESS | Load & Market | None |

---

## 22. What Is Deliberately NOT Defined Here

This document intentionally does **not** freeze:

### Mathematical Formulation
- Forecasting equations
- Price signal models
- Uncertainty distributions
- Baseline calculation formulas

### Software Structure
- Classes, functions, APIs
- Data structures
- Storage representation
- Adapter interface

### Numerical Methods
- Forecasting algorithm choice
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
- How uncertainty is propagated
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

These belong to Stages B, C, and D, or to market adapters.

---

## 23. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.3 | §1.1, §3.3 Market Scope, §5 Domain 2, §6.2 Causal Backbone, §8.2 Validation | Yes |
| `SYS-ENG-DEF-001` v0.3 | §6 Domain 2, §12 Inter-Domain Contract, §13.2 Validation | Yes |
| `A.2.1-BESS-ENG-001` v1.0 | §2.2, §4.3, boundary discipline pattern | Yes |
| RFP-264144-1 | Load data + forecasting, LMP, TOU, ancillary, capacity, DR, grid constraints, eligibility | Yes |
| RFP-264144-1 | "Load forecasting capability... primary input to dispatch optimization and financial modeling" | Yes — §6 |

---

## 24. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Rationale |
|---|---|---|---|
| 1 | Forecasting methodology | B / Phase 1 item 4 | Depends on data availability and ENGIE preference |
| 2 | Uncertainty representation | B | Depends on downstream requirements |
| 3 | Market adapter interface | B | Architecture decision |
| 4 | Which adapters to deliver | Phase 1 item 9 | Scope decision |
| 5 | Signal storage and time-indexing conventions | B | Architecture decision |
| 6 | Validation tolerances for load and price signals | C | Detailed engineering |
| 7 | Baseline calculation methodology | B / C | Program-specific |
| 8 | Market-specific settlement rules | C / D | Adapter implementation |
| 9 | Adapter selection mechanism | B | Architecture decision |

---

## 25. Next Steps

This document establishes the **conceptual engineering baseline** for Domain 2 — Load & Market Engineering.

The next documents in Stage A.2, in dependency order, are:

| Order | Document ID | Domain | Rationale |
|---|---|---|---|
| ✅ | A.2.1 | BESS Engineering | Physical foundation — **Baselined** |
| ✅ | A.2.2 | Load & Market Engineering | **This document** — external environment — **Baselined** |
| ⏭ | A.2.3 | Operational Engineering | Value stream behavior |
| ⏭ | A.2.4 | Dispatch & Optimization Engineering | Coordination logic |
| ⏭ | A.2.5 | Degradation Engineering | Dynamic state evolution |
| ⏭ | A.2.6 | Financial Engineering | Economic translation |
| ⏭ | A.2.7 | Data & Application Engineering | Execution and delivery |

Phase 1 clarification items **11 (audit / lineage / traceability scope)** and **12 (load forecasting home)**:

- **Item 12** — Conceptually resolved here: **Domain 2 owns load forecasting**; implementation may use Domain 7 capabilities. Formal confirmation remains a Phase 1 decision.
- **Item 11** — Will be addressed organically within A.2.7, since audit/lineage/traceability is primarily a Data & Application Engineering concern.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.2 — Conceptual Engineering (Load & Market Engineering)
**Status:** Conceptual Engineering Baseline — **CLOSED**
**Duration:** 12 Weeks
**Language:** English

---

### Cambios finales respecto a la versión anterior

| # | Sección | Cambio | Razón |
|---|---|---|---|
| 1 | §2.2 | Añadidas filas *"A market simulator"* y *"A revenue calculator"* | Explicitar lo que el dominio no es |
| 2 | **§2.5 nueva** | *"Boundary Warning — This Is Not a Market Engine"* con tabla explícita do/don't | Formaliza la observación final del revisor |
| 3 | §1 Purpose | Añadidos *"Market simulation"* y *"Revenue calculation"* a la lista de lo que el documento no define | Coherencia con §2.5 |
| 4 | §7.4 | Reformulado para reforzar que las reglas específicas pertenecen a **adapters**, no a este dominio | Claridad de frontera |
| 5 | **§7.5 nueva** | *"No Market Simulation"* con tabla explícita | Refuerza §2.5 |
| 6 | §7.6 renumerada | Consecuencia del punto anterior | — |
| 7 | §8.1 | Eliminada mención a *"settlement logic (conceptually, not computationally)"* | Settlement pertenece a adapters, no a este dominio |
| 8 | **§8.5 nueva** | *"No Revenue Calculation"* con tabla explícita | Refuerza §2.5 |
| 9 | **§12.5 nueva** | *"Adapters Are the Home of Market-Specific Rules"* | Explicita dónde viven las reglas específicas |
| 10 | §12.6 renumerada | Consecuencia del punto anterior | — |
| 11 | §21.2 | Añadidas *"How is revenue computed?"*, *"How is settlement computed?"*, *"How are market prices generated?"* | Coherencia con §2.5 y §7.5 |
| 12 | §22 | Añadida sección *"Market Simulation"* en lo no definido | Coherencia |

---


