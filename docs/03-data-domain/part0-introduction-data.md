# Data Scope and Requirements — BESS Integrated Model

**Edition:** Client
**Version:** 3.0
**Status:** Baseline — Data scope and Phase 1 decision list
**Date:** 2026-09-22
**Owner:** Project Engineering (cross-domain: BESS, Market, Data, Forecasting, Operational/Optimization, Financial, Validation)
**Source:** ENGIE RFP-264144-1 + SSE v4.4 methodology

---

## 1. Governing Question and Traceability

> **GQ:** *What is the optimal revenue-stacking strategy for the ENGIE BESS, accounting for physical degradation and market rules, over the contract horizon?*

Each domain answers a domain question **DQn**. Data items are **`D-NN`**; open items are **`OI-NN`**.

**ID rule.** IDs are permanent once assigned. Removed items keep their ID, marked as retired. New items are added at the end of the sequence.

Each item's "Why" column names the domain question it serves. The explicit `(DQn → GQ)` path is stated in **§§5–8**; in §§2–4 the path is implicit in the domain heading.

---

## 2. BESS Engineering (the physical asset)

**Domain question DQ1:** *What can the asset physically do, and what does it cost to do it?*

| ID | Data | Why |
|---|---|---|
| D-01 | Rated power (MW), energy capacity (MWh), duration (h) | Defines the feasible dispatch envelope. |
| D-02 | Round-trip efficiency; separate charge and discharge efficiency; efficiency vs. C-rate if available | Determines energy losses in every arbitrage decision. |
| D-03 | Self-discharge rate | Affects standing losses. |
| D-04 | Allowed DoD; SoC min/max | Bounds usable energy. |
| D-05 | Maximum charge and discharge C-rate | Bounds power. |
| D-06 | **Warranty terms:** throughput cap, cycle-count cap, permitted SoC window, permitted temperature range | Warranty is frequently the binding operational constraint. |
| D-07 | **Degradation curves:** cycle aging and calendar aging as functions of temperature, C-rate, DoD, and average SoC | Determines degradation cost and end-of-life. |
| D-08 | **Internal heterogeneity:** SOH per string or module, where applicable | Ignoring it produces infeasible schedules and material revenue loss. |
| D-09 | **Historical operational data** (if the asset exists): temperatures, SOC, C-rates, maintenance events | Validates the physical model against reality. |
| D-10 | **Auxiliary and HVAC load**; augmentation or replacement plan with schedule and cost | Auxiliary load reduces net energy; augmentation changes capacity over time. |
| D-11 | **Interconnection and POI limits:** export cap, import cap, grid-charging restrictions | Bounds dispatch; grid-charging restrictions affect eligibility. |
| D-12 | **Renewable co-location** and site layout: is there co-located solar or wind, and does the BESS share a POI | Determines which meteorological and generation data are needed (feeds D-23 and D-24). |

**Source and owner.** Answer owner: ENGIE. Driver: BESS Engineering.

---

## 3. Market Engineering (the value-creation rules)

**Domain question DQ2:** *How does BESS capacity become money, under which rules, and with what uncertainty?*

**Jurisdiction note.** Market terminology is given with parallel US and EU examples. The applicable market is set by **OI-06**. Native market resolution is a **public fact** once the market is known.

| ID | Data | Why |
|---|---|---|
| D-13 | Historical prices at the market's native resolution: Day-Ahead, Real-Time/Balancing, Intraday | The price signal arbitrage and stacking consume. |
| D-14 | **Settlement rules** and, where the asset exists, **settlement records**: energy settlement, penalties for under-delivery, make-whole / OOM payments | Defines how revenue is recognized and what non-delivery costs. |
| D-15 | Ancillary products available and, per product: historical prices, minimum duration, activation time, co-optimization rules. **US:** Regulation Up/Down, Spinning/Non-Spinning Reserve, Resource Adequacy. **EU:** FCR, aFRR, mFRR, capacity mechanisms. | Ancillary revenue is often the majority of stacked revenue. |
| D-16 | Revenue-stacking rules: simultaneous participation; capacity-reservation limits that prevent double counting | Determines the shape of the co-optimization problem. |
| D-17 | **Price-influence assumption:** price-taker or price-maker. If price-maker, system demand data and clearing prices. | Price-maker changes the objective function. |

**Source and owner.** Answer owner: ENGIE, confirmed with the market operator and regulator. Driver: Market Engineering.

---

## 4. Data / Input Engineering (the data infrastructure)

**Domain question DQ3:** *Can the model be built with the data ENGIE already has, or must new infrastructure be created?*

**Trace to GQ.** DQ3 is indirect: it makes the other items buildable.

| ID | Data | Why |
|---|---|---|
| D-18 | Existing data sources at ENGIE: data lake, SQL, Databricks, market APIs, manual CSV files | Determines what must be built vs. reused. |
| D-19 | Frequency and granularity: market data update rate, BESS data update rate, latency | Determines whether the pipeline can keep up with the model. |
| D-20 | **Quality conventions:** gaps, outliers, inconsistent timestamps, current handling rules | Determines the validation rules. |
| D-21 | Available history: years of prices, cycles of BESS operation | Determines whether backtesting is credible. |
| D-22 | **Data practicalities:** market-data licensing, timezone and DST conventions, SCADA/telemetry access, security and access approvals | Prevents Phase 2 stalls on non-technical blockers. |

**Source and owner.** Answer owner: ENGIE IT and data platform team. Driver: Data / Input Engineering.

---

## 5. Forecasting Engineering (future uncertainty)

**Domain question DQ4:** *How predictable is the environment, and with what error?*

| ID | Data | Why |
|---|---|---|
| D-23 | Historical meteorological data: ambient temperature, irradiance (if solar co-located), wind speed (if wind co-located) | Degradation depends on temperature; co-located renewable revenue depends on weather (DQ4 → GQ). |
| D-24 | Historical renewable generation profiles (if applicable): hourly capacity factors | Determines renewable-coupled operation (DQ4 → GQ). |
| D-25 | Demand / load data: behind-the-meter load, or zonal demand if applicable | Required for load forecasting and BTM modes (DQ4 → GQ). |
| D-26 | Historical price series with exogenous features (load forecast, renewable generation forecast) | Inputs to the price forecast model (DQ4 → GQ). |
| D-27 | **Forecast-error assumptions** acceptable to ENGIE | Determines the risk envelope of the schedule (DQ4 → GQ). |

**Source and owner.** Answer owner: ENGIE, meteorological service, market operator. Driver: Forecasting Engineering.

---

## 6. Operational / Optimization Engineering (the formulation)

**Domain question DQ5:** *What objective function reflects ENGIE's real intent?*

| ID | Data | Why |
|---|---|---|
| D-28 | Current or desired operating strategy: pure arbitrage, revenue stacking, capacity market with availability obligations, or a combination | Determines the objective function (DQ5 → GQ). |
| D-29 | Decision horizon: Day-ahead, intraday, rolling horizon; re-optimization frequency | Determines the optimization formulation (DQ5 → GQ). |
| D-30 | Operational constraints: max cycles/day/year, internal C-rate policy, maintenance windows, warranty constraints from D-06, POI limits from D-11 | Bounds the feasible set (DQ5 → GQ). |
| D-31 | Risk appetite: robust vs. aggressive schedule | Determines the risk posture (DQ5 → GQ). |

**Source and owner.** Answer owner: ENGIE (operating intent). Driver: Operational / Optimization Engineering.

---

## 7. Financial Engineering

**Domain question DQ6:** *Does the revenue-maximizing schedule also maximize financial value?*

| ID | Data | Why |
|---|---|---|
| D-32 | CAPEX of the BESS (or replacement value if the asset exists) | Required for NPV and IRR (DQ6 → GQ). |
| D-33 | OPEX: fixed (O&M) and variable (charging/discharging cost, if applicable) | Required for cash flow (DQ6 → GQ). |
| D-34 | Financing structure: discount rate, accounting life | Required for discounting (DQ6 → GQ). |
| D-35 | Incentives or subsidies applicable, including tax-credit implications of grid charging | Affects net cash flow (DQ6 → GQ). |
| D-36 | Existing contracts: PPAs, tolling agreements, capacity (RA) contracts that fix revenue or impose obligations | Bounds the revenue envelope (DQ6 → GQ). |

**Source and owner.** Answer owner: ENGIE project finance. Driver: Financial Engineering.

---

## 8. Validation Engineering

**Domain question DQ7:** *How do we prove the system works for ENGIE, not in the abstract?*

| ID | Data | Why |
|---|---|---|
| D-37 | Backtesting data: price history, ancillary activations, and BESS operation (if the asset exists) covering at least 1–2 years | Required to demonstrate the model reproduces history (DQ7 → GQ). |
| D-38 | **Baseline definition:** reference case against which "revenue uplift" is measured — no-BESS, historical operation, or rule-based control | Without a baseline, "uplift" is undefined (DQ7 → GQ). |
| D-39 | ENGIE acceptance metric and numeric threshold: revenue uplift vs. baseline, SOH retention, RA obligation compliance, or another | Makes acceptance falsifiable (DQ7 → GQ). |
| D-40 | Stress scenarios: extreme conditions ENGIE wants evaluated — negative prices, scarcity events, forecast failures | Tests the model outside the base case (DQ7 → GQ). |

**Source and owner.** Answer owner: ENGIE and market operator historical data. Driver: Validation Engineering.

---

## 9. What We Will Request and What We Will Not Assume

| We will request | We will not assume |
|---|---|
| Complete BESS datasheet, including warranty terms | We will validate any supplied degradation model against the functional form the operational model uses, rather than adopt it as calibrated |
| Degradation curves by temperature / C-rate / DoD / SoC | We will not use a single annual degradation number |
| Historical prices at market resolution | We will not use monthly averaged prices |
| Settlement rules and penalties | We will not assume there are no penalties |
| Ancillary products with prices and requirements | We will not assume all products can be stacked without restriction |
| Data sources, quality conventions, current handling | We will not assume data is clean and available |
| Historical meteorological data | We will not defer forecasting |
| CAPEX/OPEX and financing structure | We will not optimize revenue without financial context |
| ENGIE acceptance criteria and baseline | We will not define success unilaterally |

Where ENGIE already has a calibrated degradation model, it is still requested (D-07); the point is that it must be validated against the functional form the operational model uses, not adopted unverified.

---

## 10. How the Data Maps to Engineering Models

| Domain | Engineering Model | Validated by | Test |
|---|---|---|---|
| BESS | Physical asset model | D-01–D-12; manufacturer data; historical operation | Dispatch feasibility against D-01–D-12 on sampled schedules; degradation trajectory within the manufacturer band defined by D-07. |
| Market | Market participation model | D-13–D-17; settlement rules | Where the asset exists: simulated settlement reproduces **settlement records**. Where it does not: simulated settlement is compared against an **independent reference** — settlement statements from a comparable asset in the same market, or the operator's published worked examples. If neither is available, the test is stated as **unverified for Phase 2** and flagged as a Phase 2 risk. The Market Engineering test specification, produced by the Market Engineering driver in Phase 1, names the reference. |
| Data / Input | Data pipeline | D-18–D-22; quality reports; lineage | Every model-ready row traces to a raw source row; validation report reproducible. |
| Forecasting | Forecast models (price, load, weather) | D-23–D-27 | Out-of-sample error within the tolerance set by OI-16. |
| Operational / Optimization | Dispatch and stacking formulation | D-28–D-31; schedule feasibility | Schedule feasible against D-01–D-12 and D-30; backtest revenue within the tolerance set by OI-25. |
| Financial | Financial model (NPV, IRR, payback) | D-32–D-36 | **Arithmetic test.** NPV and IRR computed from a reference cash-flow match a hand-computed reference within a numeric tolerance stated in the Financial Engineering test specification, a Phase 1 deliverable of the Financial Engineering driver. This confirms the calculation, not correspondence to reality; model validity is addressed in Phase 2 through backtesting once OI-21 and OI-25 are answered. |
| Validation | Backtesting and acceptance framework | D-37–D-40 | Model output meets the threshold defined by OI-25 on the baseline defined by OI-26. |

---

## 11. Phase 1 Open-Item Registry

**Flag key.**

- **Gating** — blocks Phase 2 until answered.
- **Conditional** — the item may not apply at all, depending on how a gating item resolves.
- **Sequenced** — the item always applies, but must be answered after a gating item because its content depends on the gating answer.
- **Deferred** — applies in Phase 2 or later; not gating, and does not depend on a gating item.

| ID | Domain | Item | Answer owner | Driver | Flag | Depends on |
|---|---|---|---|---|---|---|
| OI-01 | BESS | Asset exists or hypothetical | ENGIE | BESS Eng. | Gating | — |
| OI-02 | BESS | Degradation curves supplied or literature-based | ENGIE | BESS Eng. | Gating | — |
| OI-03 | BESS | Subsystem-level data available | ENGIE | BESS Eng. | Conditional | OI-01 |
| OI-04 | BESS | Historical operational data available | ENGIE | BESS Eng. | Conditional | OI-01 |
| OI-05 | BESS | Augmentation plan available | ENGIE | BESS Eng. | Conditional | OI-01 |
| OI-06 | Market | Markets in scope | ENGIE | Market Eng. | Gating | — |
| OI-07 | Market | Ancillary products in scope | ENGIE | Market Eng. | Gating | OI-06 |
| OI-08 | Market | Price-taker or price-maker | ENGIE | Market Eng. | Gating | OI-06 |
| OI-09 | Market | Settlement / penalty documentation source | ENGIE | Market Eng. | Gating | OI-06 |
| OI-10 | Data | Existing sources inventory, **including quality conventions** | ENGIE IT | Data Eng. | Gating | — |
| OI-11 | Data | Access method per source | ENGIE IT | Data Eng. | Sequenced | OI-10 |
| OI-12 | Data | Databricks workspace status | ENGIE IT | Data Eng. | Sequenced | OI-10 |
| OI-13 | Data | Historical depth available | ENGIE | Data Eng. | Gating | OI-06, OI-10 |
| OI-14 | Data | Data practicalities: licensing, timezone/DST, SCADA access, security approvals | ENGIE IT | Data Eng. | Sequenced | OI-10 |
| OI-15 | Forecasting | BTM or front-of-meter | ENGIE | Forecasting Eng. | Gating | OI-01 |
| OI-16 | Forecasting | Forecast-error assumptions acceptable | ENGIE | Forecasting Eng. | Sequenced | OI-17, OI-25 |
| OI-17 | Operational | Base-case strategy | ENGIE | Ops/Opt. Eng. | Gating | OI-06 |
| OI-18 | Operational | Decision horizon | ENGIE | Ops/Opt. Eng. | Sequenced | OI-17 |
| OI-19 | Operational | Binding operational constraints | ENGIE | Ops/Opt. Eng. | Sequenced | OI-01, OI-17 |
| OI-20 | Operational | Risk posture | ENGIE | Ops/Opt. Eng. | Sequenced | OI-17 |
| OI-21 | Financial | CAPEX / OPEX base case | ENGIE | Financial Eng. | Gating | OI-01 |
| OI-22 | Financial | Discount rate and accounting life | ENGIE | Financial Eng. | Deferred | — |
| OI-23 | Financial | Incentives / subsidies applicable | ENGIE | Financial Eng. | Conditional | OI-21 |
| OI-24 | Financial | Binding contracts (PPA, tolling, RA) | ENGIE | Financial Eng. | Conditional | OI-06 |
| OI-25 | Validation | Acceptance metric and numeric threshold | ENGIE | Validation Eng. | Gating | OI-17 |
| OI-26 | Validation | Baseline definition | ENGIE | Validation Eng. | Gating | OI-17 |
| OI-27 | Validation | Required stress scenarios | ENGIE | Validation Eng. | Sequenced | OI-06, OI-25 |
| OI-28 | BESS | Renewable co-location confirmed | ENGIE | BESS Eng. | Conditional | OI-01 |
| OI-29 | BESS | Interconnection and POI limits provided | ENGIE | BESS Eng. | Gating | OI-01 |

**Totals.** 29 open items. **Gating: 14**. **Sequenced: 8**. **Conditional: 6**. **Deferred: 1**.

**Notes.**

- Quality conventions are covered by **OI-10**, whose wording includes them.
- Native market resolution is **not** an open item — it is a public fact once OI-06 is known.
- Discount rate (OI-22) is **Deferred**: a placeholder is standard practice.

---

## 12. Phase 1 Decisions Log

The registry is §11; this is the log of the answers.

| ID | Decision | Answer | Answer owner | Driver | Flag | Due | Date closed |
|---|---|---|---|---|---|---|---|
| OI-01 | Asset exists or hypothetical | | ENGIE | BESS Eng. | Gating | | |
| OI-02 | Degradation curves supplied or literature-based | | ENGIE | BESS Eng. | Gating | | |
| OI-03 | Subsystem-level data available | | ENGIE | BESS Eng. | Conditional | | |
| OI-04 | Historical operational data available | | ENGIE | BESS Eng. | Conditional | | |
| OI-05 | Augmentation plan available | | ENGIE | BESS Eng. | Conditional | | |
| OI-06 | Markets in scope | | ENGIE | Market Eng. | Gating | | |
| OI-07 | Ancillary products in scope | | ENGIE | Market Eng. | Gating | | |
| OI-08 | Price-taker or price-maker | | ENGIE | Market Eng. | Gating | | |
| OI-09 | Settlement / penalty documentation source | | ENGIE | Market Eng. | Gating | | |
| OI-10 | Existing sources inventory, including quality conventions | | ENGIE IT | Data Eng. | Gating | | |
| OI-11 | Access method per source | | ENGIE IT | Data Eng. | Sequenced | | |
| OI-12 | Databricks workspace status | | ENGIE IT | Data Eng. | Sequenced | | |
| OI-13 | Historical depth available | | ENGIE | Data Eng. | Gating | | |
| OI-14 | Data practicalities | | ENGIE IT | Data Eng. | Sequenced | | |
| OI-15 | BTM or front-of-meter | | ENGIE | Forecasting Eng. | Gating | | |
| OI-16 | Forecast-error assumptions | | ENGIE | Forecasting Eng. | Sequenced | | |
| OI-17 | Base-case strategy | | ENGIE | Ops/Opt. Eng. | Gating | | |
| OI-18 | Decision horizon | | ENGIE | Ops/Opt. Eng. | Sequenced | | |
| OI-19 | Binding operational constraints | | ENGIE | Ops/Opt. Eng. | Sequenced | | |
| OI-20 | Risk posture | | ENGIE | Ops/Opt. Eng. | Sequenced | | |
| OI-21 | CAPEX / OPEX base case | | ENGIE | Financial Eng. | Gating | | |
| OI-22 | Discount rate and accounting life | | ENGIE | Financial Eng. | Deferred | | |
| OI-23 | Incentives / subsidies applicable | | ENGIE | Financial Eng. | Conditional | | |
| OI-24 | Binding contracts (PPA, tolling, RA) | | ENGIE | Financial Eng. | Conditional | | |
| OI-25 | Acceptance metric and numeric threshold | | ENGIE | Validation Eng. | Gating | | |
| OI-26 | Baseline definition | | ENGIE | Validation Eng. | Gating | | |
| OI-27 | Required stress scenarios | | ENGIE | Validation Eng. | Sequenced | | |
| OI-28 | Renewable co-location confirmed | | ENGIE | BESS Eng. | Conditional | | |
| OI-29 | Interconnection and POI limits provided | | ENGIE | BESS Eng. | Gating | | |

When every **gating** row is filled, Phase 2 can start. Sequenced, Conditional, and Deferred rows close during Phase 2.

---

*End of Data Scope and Requirements — BESS Integrated Model, Client edition, v3.0*