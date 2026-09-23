
---

# Financial Engineering
## Stage A.2.6 — Conceptual Engineering
### Economic Translation of the BESS Operational & Financial Modeling System

**Document ID:** A.2.6-FIN-ENG-001

**Version:** 0.2 — Development Draft

**Status:** Stage A.2 — Conceptual Engineering (Domain Level)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.8)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.5)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.2)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.3)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v0.8)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.2)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)

**Domain:** Domain 6 — Financial Engineering

**Purpose:** Define, at a conceptual level, what the Financial Engineering domain represents, what it consumes from the operational and degradation domains, what it produces, how it translates operational results into project-level economic performance, and what engineering decisions must be made in later stages — **without** prescribing cash-flow formulations, tax treatments, or implementation.

---

## 1. Purpose of This Document

This document constitutes **Stage A.2.6 — Conceptual Engineering** of the Financial Engineering domain, one of seven domain chapters defined in `SYS-ENG-DEF-001` §4.

Its purpose is to establish the **conceptual engineering definition** of the domain that translates operational and degradation results into **project-level economic performance** — the final economic layer of the causal chain.

It answers, at conceptual level:

- What Financial Engineering is responsible for
- What it consumes from upstream domains and Scenario Management
- What it produces as economic outputs
- How it distinguishes behind-the-meter savings from market revenues
- How it handles market settlement via adapters
- How it handles degradation events without double counting
- How it applies the realization factor
- How it distinguishes project IRR from equity IRR
- How it treats end-of-project value and residual asset value
- What modeling traps it must address
- What is **not** decided here (and who decides it)

It deliberately does **not** define:

- Exact cash-flow formulation
- Tax treatment details
- Financing structure details
- Accounting treatment
- Discounting conventions
- Depreciation methodology
- ITC treatment details
- Software architecture
- Data schemas
- Python classes or APIs

Those belong to Stage B (architecture and formulation) and Stage C (detailed formulation and implementation).

### 1.1 Decision Layers — Methodology, Architecture, Formulation

| Layer | Decided in | What it fixes |
|---|---|---|
| **Methodology** | **Phase 1** | Class of approach: pre-tax vs. post-tax, project IRR vs. equity IRR, nominal vs. real |
| **Architecture** | **Stage B** | Components, interfaces, cash-flow structure, escalation logic |
| **Formulation** | **Stage B / C** | Cash-flow equations, tax treatment, financing structure, depreciation |
| **Detailed formulation** | **Stage C** | Coefficients, tables, conventions, currency handling |

### 1.2 Working Defaults

| Default | Source | Value |
|---|---|---|
| Financing structure | Strategy D8 | Project IRR primary; equity IRR computed with default debt parameters, configurable |
| Tax treatment | Strategy D9 | Pre-tax initially; ITC / depreciation flagged as extension |
| Nominal vs. real | This document | **Nominal cash flows with explicit inflation, discounted at a nominal rate** |
| Representative-period effect | Strategy D19 | Savings from representative months are **weighted** when annualized |
| Realization factor | **PH-035** | Applied per stream; magnitude configurable per scenario |

### 1.3 Position Within Stage A

This document sits **after** A.2.5 (Degradation Engineering) and **before** A.2.7 (Data & Application Engineering). It is the **final engineering domain** in the causal chain — it translates the physical-operational cycle into economic performance.

### 1.4 The Most Important Boundary in This Document

> **Financial Engineering consumes operational and physical outputs and produces project-level economic performance. It does not compute dispatch decisions, does not model degradation, and does not compute the customer bill.**

Financial Engineering converts **physical events**, **operational results**, and **settled market quantities** into **cash flows** and **KPIs**. It does not decide what the battery does; it evaluates what the battery did.

### 1.5 Relationship to Upstream Domains

| Source | What it provides to Financial Engineering |
|---|---|
| **Load & Market Engineering (A.2.2)** | Tariff bill outputs (with and without BESS), market price signals, market settlement outputs via adapters |
| **Dispatch (A.2.4)** | Dispatch schedule, SOC trajectory, operational attribution basis, service-level metrics |
| **Degradation (A.2.5)** | Augmentation events, replacement events, physical event information |
| **BESS Engineering (A.2.1)** | Equipment specifications (not costs) |
| **Scenario Management** | Discount rate, escalation, contract term, financing, tax, incentives, convention, realization factor, perspective, cost assumptions |

### 1.6 Relationship to Downstream Domains

| Domain | What it receives from Financial Engineering |
|---|---|
| **Data & Application Engineering (A.2.7)** | Financial KPIs, cash flows, revenue by stream, scenario comparison inputs |
| **Scenario Management** | Financial results for scenario comparison |

### 1.7 Generality Principle

This document defines **generic financial concepts** — parameterizable for different markets, jurisdictions, contract structures, and financing arrangements. It does not hard-code a specific tax regime, currency, or financing structure.

---

## 2. Domain Identity

### 2.1 What This Domain Is

The **Financial Engineering domain** is the conceptual representation of the **economic consequence** of the physical-operational cycle. It transforms operational results, market settlement outputs, physical events, and financial assumptions into project-level economic performance.

### 2.2 What This Domain Is Not

| This domain is NOT | Because |
|---|---|
| An operational model | Operation belongs to Domain 4 |
| A degradation model | Degradation belongs to Domain 5 |
| A tariff engine | Tariff computation belongs to Domain 2 |
| A dispatch model | Dispatch belongs to Domain 4 |
| A market model | Market belongs to Domain 2 |
| A market settlement engine | Settlement belongs to market adapters (`A.2.2` §13.5) |
| A revenue attribution model | Attribution belongs to Domain 4 |
| A cost model | Cost assumptions belong to Scenario Management |
| A cash-flow calculator (in this document) | The exact formulation belongs to Stage B/C |
| A tax model | Tax details belong to Stage B/C |

### 2.3 The Two Sources of Truth for Value

Per `SYS-ENG-DEF-001` §11.4, there are **two sources of truth** for value in this system, and Financial Engineering consumes from both:

| Value category | Source of truth | What Financial Engineering does |
|---|---|---|
| **Behind-the-meter savings** — demand charge reduction, energy charge reduction, export credits | **Domain 2 — Tariff engine** | Consumes the bill with and without BESS; converts to savings |
| **Market revenues** — LMP arbitrage, frequency regulation, DR payments, capacity payments | **Domain 4 — Revenue attribution per value stream**, settled through market adapters | Consumes **settled market quantities**; aggregates into revenue |

**Financial Engineering does not recompute either.** It consumes both, applies financial assumptions, and produces consolidated project performance.

### 2.4 The Three Economic Concepts That Must Not Collapse

| Concept | What it is | Where it appears | Ownership |
|---|---|---|---|
| **Revenue / savings** | Value generated by operation, as attributed and settled | Cash-flow inflow | Consumed from D2 and D4+adapters |
| **Investment** | CAPEX, augmentation, replacement | Cash-flow outflow | Consumed from Scenario Management (cost assumptions) and Degradation (events) |
| **Marginal degradation cost** | A dispatch signal | **Not** a cash flow | Produced by D5; consumed only by D4 |

**Rule.** The marginal degradation cost is **not** a cash flow. It does not appear as a line item in the project cash flow.

This is the mechanism that prevents double counting (`SYS-ENG-DEF-001` §11.5, `A.2.5` §2.3).

### 2.5 Primary Question

> **What economic value results from the modeled project behavior?**

### 2.6 Guiding Principle

> **Financial Engineering consumes operational and physical outputs and produces project-level economic performance. It never recomputes operation, never recomputes degradation, never recomputes the customer bill, and never recomputes market settlement.**

---

## 3. Engineering Scope

| # | Aspect | Description |
|---|---|---|
| 1 | Investment economics | CAPEX, augmentation, replacement |
| 2 | Operating economics | O&M, market participation costs |
| 3 | Revenue | Peak-shaving savings, DR revenue, arbitrage revenue, regulation revenue |
| 4 | Savings | Demand charge reduction, energy charge reduction, export credits |
| 5 | Cash flow | Aggregation, escalation, discounting |
| 6 | Financial KPIs | NPV, IRR (project and equity), simple payback |
| 7 | Realization factor | Applied to operational results per stream |
| 8 | Financing | Debt parameters for equity IRR |
| 9 | Tax and incentives | ITC, depreciation, tax treatment |
| 10 | Convention | Currency, nominal vs. real |
| 11 | Perspective | Commercial perspective (ENGIE vs. client) |
| 12 | End-of-project value | Residual value, decommissioning |
| 13 | Scenario comparison | Cross-scenario economic comparison |

The domain does **not**:
- Compute dispatch decisions (Domain 4)
- Compute degradation (Domain 5)
- Compute the customer bill (Domain 2)
- Attribute revenue to value streams (Domain 4)
- Settle market revenues (adapters)
- Derive the marginal degradation cost (Domain 5)
- Assume costs (Scenario Management)

---

## 4. Conceptual Model of Financial Engineering

### 4.1 High-Level Structure

```
    Dispatch (A.2.4)          Tariff Engine (A.2.2)
    • Dispatch schedule       • Bill with BESS
    • SOC trajectory          • Bill without BESS
    • Attribution basis       • Savings by component
    • Service-level metrics
            │                          │
            │                          │
            ▼                          │
    Market Adapters                    │
    • Apply settlement rules           │
    • Produce settled quantities       │
            │                          │
            └──────────┬───────────────┘
                       ▼
        ┌──────────────────────────────────┐
        │      FINANCIAL ENGINEERING       │
        │                                  │
        │  • Revenue aggregation           │
        │  • Savings aggregation           │
        │  • Investment flows              │
        │  • Operating costs               │
        │  • Cash-flow construction        │
        │  • Discounting                   │
        │  • KPI computation               │
        └──────────────────────────────────┘
                       │
                       ├── Financial KPIs (NPV, IRR, payback)
                       ├── Revenue by stream
                       ├── Annual cash flows
                       └── Scenario comparison inputs
                       │
                       ▼
            Data & Application (A.2.7)
```

**Degradation events** (from A.2.5) enter as **investment flows** at specific timestamps. **Cost assumptions** come from Scenario Management, not from BESS Engineering.

### 4.2 Conceptual Sub-Areas

| Sub-Area | Conceptual Role |
|---|---|
| Investment economics | CAPEX, augmentation, replacement |
| Operating economics | O&M, market participation costs |
| Revenue aggregation | Consume settled market quantities → revenue |
| Savings aggregation | Consume tariff bill outputs → savings |
| Realization factor | Applied per stream |
| Cash-flow construction | Aggregation, timing, escalation |
| Discounting | NPV, IRR |
| Financing | Debt structure for equity IRR |
| Tax and incentives | ITC, depreciation, tax |
| Convention | Currency, nominal vs. real |
| Perspective | Commercial perspective |
| End-of-project value | Residual value, decommissioning |
| Scenario comparison | Cross-scenario economic comparison |

### 4.3 Financial Boundary

| Inside the domain | Outside the domain |
|---|---|
| Revenue aggregation | Revenue attribution (Domain 4) |
| Savings aggregation | Bill computation (Domain 2) |
| Cash-flow construction | Market settlement (adapters) |
| Discounting | Dispatch decisions (Domain 4) |
| KPI computation | Degradation modeling (Domain 5) |
| Realization factor application | Marginal signal derivation (Domain 5) |
| Tax and incentives | Cost assumptions (Scenario Management) |
| Financing | Equipment specifications (Domain 1) |

---

## 5. Inputs to Financial Engineering

### 5.1 From Dispatch (A.2.4)

| Input | Meaning |
|---|---|
| Dispatch schedule | Charge / discharge / rest per interval |
| SOC trajectory | SOC per interval |
| Operational attribution basis | Which value stream is responsible for each attributable portion |
| Service-level metrics | What each service delivered |
| Market revenue attribution | Attributed quantities per value stream |

**Note.** Financial Engineering consumes **attributed quantities**. It does not perform attribution.

### 5.2 From Load & Market Engineering (A.2.2)

| Input | Meaning |
|---|---|
| Bill with BESS | Customer bill computed on net load (post-dispatch) |
| Bill without BESS | Customer bill computed on reference load |
| Savings by component | Demand charge, energy charge, export credit — by billing period |
| Billing determinants | Billed peak demand, ratcheted demand, TOU energy |
| Market price signals | For reference and reporting |
| **Settled market quantities** | From market adapters, applying market-specific settlement rules to D4 attributed quantities |

**Note.** The tariff engine (`A.2.2` §9) is the **single source of truth for behind-the-meter savings**. Market adapters (`A.2.2` §13.5) are the **single source of truth for market settlement**.

### 5.3 From Degradation Engineering (A.2.5)

| Input | Meaning |
|---|---|
| Augmentation events | When capacity is added, and how much |
| Replacement events | When the battery is replaced |
| Physical event information | Physical quantities and timing required for financial valuation |

### 5.4 From Scenario Management (Assumptions)

**All cost assumptions are scenario parameters.** Financial Engineering does **not** consume cost data from BESS Engineering.

| Input | Meaning |
|---|---|
| CAPEX assumption | Initial investment cost |
| O&M cost assumption | Annual operating cost |
| Replacement cost assumption | Cost per replacement event |
| Augmentation cost assumption | Cost per augmentation event |
| Decommissioning cost assumption | Cost at end of project life |
| Discount rate | Rate for NPV computation |
| Escalation rates | Cost and revenue escalation |
| Inflation rate | For nominal cash flows |
| Contract term | Length of the analysis period |
| Financing assumptions | Debt parameters |
| Tax assumptions | Tax rate, depreciation schedule |
| Incentive schedules | ITC, other incentives |
| Convention | Currency, nominal vs. real |
| Realization factor | Per stream (**PH-035**) |
| Perspective | ENGIE vs. client (**PH-007**) |

**Note.** BESS Engineering provides **equipment specifications** (technical parameters) on which cost assumptions are applied, but not the costs themselves. This preserves the A.2.1 principle: *capability and constraint — never value*.

### 5.5 What Financial Engineering Does Not Consume

- Marginal degradation cost (used only by Dispatch)
- Dispatch decisions (only operational results)
- Degradation model internals (only events)
- Market rule details (only settled quantities)
- Tariff structure details (only bill outputs)
- Cost data directly from BESS Engineering (only specifications)

---

## 6. Investment Economics

### 6.1 CAPEX

Initial capital expenditure, consumed as a **scenario assumption**.

**Assumed by:** Scenario Management.

**Represents:** Initial cash outflow at project start.

### 6.2 Augmentation

Capacity addition events produced by Degradation Engineering (`A.2.5` §8.2), converted into cash outflows at the event timestamps using the **augmentation cost assumption** from Scenario Management.

**Event from:** Degradation Engineering.

**Cost from:** Scenario Management.

### 6.3 Replacement

Full replacement events produced by Degradation Engineering (`A.2.5` §8.3), converted into cash outflows using the **replacement cost assumption** from Scenario Management.

**Event from:** Degradation Engineering.

**Cost from:** Scenario Management.

### 6.4 Decommissioning

Cost at end of project life, consumed as a **scenario assumption**.

**Assumed by:** Scenario Management.

### 6.5 What Financial Engineering Does Not Do With Investment

- It does not decide when augmentation or replacement occur (Degradation)
- It does not assume the costs (Scenario Management)
- It does not use the marginal degradation cost as an investment flow

### 6.6 Boundary Discipline

Degradation Engineering produces **physical events**. Scenario Management provides **cost assumptions**. Financial Engineering converts both into **cash flows**.

---

## 7. Operating Economics

### 7.1 O&M

Ongoing operating and maintenance costs, consumed as a **scenario assumption**, escalated per scenario.

**Represents:** Annual cash outflow.

### 7.2 Charging Energy Cost — Not a Separate Line

**Charging energy cost is never a separate cash-flow line.** It is handled as follows:

| Configuration | Treatment |
|---|---|
| **Behind-the-meter** | Charging energy is **already embedded in the customer bill with BESS** computed by the tariff engine. It is not subtracted separately |
| **Front-of-meter** | Charging energy is the **negative leg of arbitrage** and is **netted within market revenue**. It is not subtracted separately |

Adding it as a separate line would double count the cost in both configurations.

### 7.3 Market Participation Costs

Costs associated with market participation (bidding fees, imbalance charges — market-dependent), consumed where applicable from market adapters.

**Represents:** Annual cash outflow where applicable.

### 7.4 What Financial Engineering Does Not Do With Operating Costs

- It does not recompute electricity consumption (Dispatch)
- It does not recompute degradation costs (physical events handled separately)
- It does not recompute tariff-based savings (tariff engine)
- It does not add a separate charging energy cost line (§7.2)

---

## 8. Revenue and Savings

### 8.1 Behind-the-Meter Savings

Savings from demand charge reduction, energy charge reduction, and export credits, computed by the tariff engine (`A.2.2` §9).

**Consumed from:** Load & Market Engineering.

**Represents:** Annual cash inflow (as bill reduction).

**Source of truth:** **Domain 2 — Tariff engine.**

**Annualization.** Under representative-period simulation (Strategy D19), savings computed for representative months must be **weighted by the number of months they represent** when annualized. Calendar-year savings reflect the full 12 months, not only the simulated ones.

### 8.2 Market Revenues

Revenues from LMP arbitrage, frequency regulation, DR payments, capacity payments.

**Flow:**

```
Dispatch (A.2.4)
    │  attributed quantities per value stream
    ▼
Market Adapters (A.2.2 §13.5)
    │  apply market settlement rules
    │  (mileage, performance score, baseline, penalties, etc.)
    ▼
Settled market quantities
    │
    ▼
Financial Engineering
    │  aggregates settled quantities into revenue
    ▼
Revenue by stream
```

**Important.** Market revenue is **not** the product of attributed quantity × market price. The market adapter applies the market's **settlement rules** — which may involve mileage, performance score, baseline methodology, penalties, and other market-specific factors — to the attributed quantities. Financial Engineering consumes the **settled quantities**.

**Source of truth:** **Domain 4 — Revenue attribution per value stream**, settled through market adapters.

### 8.3 Realization Factor

The **realization factor** is applied in Financial Engineering, **per stream** (`A.2.4` §11.1). Its magnitude is configurable per scenario (**PH-035**).

| Stream type | Realization factor treatment |
|---|---|
| **Arbitrage and market revenues** | Applied — realized value depends on forecast accuracy |
| **Behind-the-meter savings** | **Not** applied uniformly — risk is reflected through tariff mechanisms (ratchets, coincident-peak hit rate) computed by the tariff engine |

### 8.4 What Financial Engineering Does Not Do With Revenue

- It does not compute the customer bill (tariff engine)
- It does not attribute revenue to value streams (Dispatch)
- It does not settle market quantities (adapters)
- It does not decide what the BESS does (Dispatch)
- It does not decide when degradation occurs (Degradation)

---

## 9. Cash Flow

### 9.1 Conceptual Structure

The project cash flow aggregates:

| Inflow | Outflow |
|---|---|
| Behind-the-meter savings (from D2) | CAPEX (initial, from scenario) |
| Market revenues (from D4 + adapters) | Augmentation (event from D5, cost from scenario) |
| Terminal / residual value (see §9.5) | Replacement (event from D5, cost from scenario) |
| | Decommissioning (from scenario) |
| | O&M (from scenario) |
| | Market participation costs (where applicable) |
| | Tax (where applicable) |

**Note.** Charging energy cost is **not** a separate line (§7.2).

### 9.2 Timing

Cash flows are aligned to periods defined by the scenario (typically annual).

### 9.3 Escalation

Cost and revenue escalation applied per scenario assumptions.

**Note.** Tariff escalation is applied **once, in the tariff engine** (`A.2.2` §9.6). Financial Engineering does **not** re-escalate tariff-based savings.

### 9.4 Discounting

Cash flows are discounted at the scenario's discount rate to compute NPV.

**Nominal vs. real.** Working default: **nominal cash flows with explicit inflation, discounted at a nominal rate**. The real trap is the mismatch between rate and flows; the nominal convention keeps rate and flows consistent.

### 9.5 End-of-Project Value

At the end of the contract term, the cash flow may include:

| Element | Nature |
|---|---|
| **Residual value** | The remaining economic value of the battery asset at end of contract |
| **Decommissioning cost** | Cost of removing or recycling the asset |
| **Recycling / salvage value** | Where applicable |

**Conceptual requirement.** Financial Engineering must be able to represent a **terminal value** at the end of the project, positive or negative.

**Note on augmentation near end-of-life.** Augmentation in the final year of a contract rarely pays back. The augmentation policy (owned by Scenario Management per `A.2.5` §8.1) should consider the remaining contract term. This is declared here as a trap (§16).

### 9.6 What Financial Engineering Does Not Do With Cash Flow

- It does not decide when events occur (Degradation)
- It does not decide the amount of savings (Tariff engine)
- It does not settle market revenue (adapters)
- It does not compute physical degradation
- It does not add a separate charging energy cost line

---

## 10. Financial KPIs

### 10.1 NPV

**Net Present Value** — sum of discounted net cash flows over the contract term, including terminal value where applicable.

**Type:** Project NPV (primary), possibly equity NPV.

### 10.2 IRR

| IRR type | Treatment |
|---|---|
| **Project IRR** | Computed on total project cash flows — **primary KPI** (D8) |
| **Equity IRR** | Computed on equity cash flows — requires debt structure, **computed with default debt parameters, configurable** (D8) |

**Note on multiple IRRs.** When replacements occur mid-life, cash flows may change sign multiple times, potentially producing **multiple IRRs**. The KPI must acknowledge this risk. Where multiple IRRs exist, the appropriate return is reported, and the ambiguity is flagged.

### 10.3 Payback

**Simple Payback** — years to recover initial investment from undiscounted net cash flows.

### 10.4 Revenue by Stream

Annual revenue and savings broken down by value stream, per the attribution and settlement conventions.

**Source composition:**

| Stream | Source |
|---|---|
| Peak Shaving | Tariff engine savings (demand charge component) |
| Energy Arbitrage (BTM) | Tariff engine savings (energy charge component) |
| Export Credits | Tariff engine savings (export component) |
| Voltage Regulation (BTM) | Tariff engine savings (power factor / kVAR component, where applicable) |
| Frequency Regulation | Dispatch attribution, **settled by adapter** |
| Demand Response | Dispatch attribution, **settled by adapter** |
| Energy Arbitrage (FTM) | Dispatch attribution, **settled by adapter** |
| Capacity | Dispatch attribution, **settled by adapter** |

**Annualization.** Under representative-period simulation, revenues from representative months are **weighted** when annualized.

### 10.5 Annual Revenue and Savings

Total annual revenue and savings, aggregated across streams.

---

## 11. Financing

### 11.1 Debt Parameters

For equity IRR, Financial Engineering requires:

- Gearing ratio
- Interest rate
- Loan tenor
- Repayment schedule
- Grace period (if applicable)

**Working default (D8):** Default debt parameters provided, configurable by the user.

### 11.2 What Financial Engineering Does Not Do With Financing

- It does not decide the financing structure (scenario)
- It does not decide the gearing (scenario)
- It does not decide the interest rate (scenario)

### 11.3 Deferred to Stage B/C

The exact financing structure (debt service calculation, coverage ratios, distribution waterfall) is deferred to Stage B/C.

---

## 12. Tax and Incentives

### 12.1 Tax Treatment

**Working default (D9):** **Pre-tax** initially. ITC / depreciation flagged as extension if US market confirmed (**PH-043**).

| Tax element | Treatment |
|---|---|
| Corporate income tax | Where applicable (Stage B/C) |
| Depreciation | Where applicable (Stage B/C) |
| Tax credits (ITC, PTC, etc.) | Where applicable (Stage B/C) |

### 12.2 Incentives

Incentive schedules are scenario parameters. Their treatment in the cash flow is deferred to Stage B/C.

### 12.3 What Financial Engineering Does Not Do With Tax

- It does not decide the tax regime (scenario)
- It does not decide the depreciation schedule (scenario)
- It does not decide the incentive treatment (scenario)

---

## 13. Convention

### 13.1 Currency

Currency handling is a scenario parameter. All cash flows are in the scenario's currency.

### 13.2 Nominal vs. Real

**Working default:** **Nominal cash flows with explicit inflation, discounted at a nominal rate.**

The real risk is a mismatch between the rate and the flows (e.g. real flows discounted at a nominal rate). The nominal convention keeps rate and flows consistent.

**Revisable** if ENGIE indicates otherwise (**PH-043**).

### 13.3 What Financial Engineering Does Not Do With Convention

- It does not decide the currency (scenario)
- It does not decide nominal vs. real (scenario)

---

## 14. Perspective

### 14.1 Commercial Perspective

Financial Engineering must support the **commercial perspective** requested by the scenario:

| Perspective | What it represents |
|---|---|
| **ENGIE's perspective** | Owner / operator economics |
| **Client's perspective** | Savings, service fee, net benefit |
| **Both** | Where the commercial arrangement requires both views |

**Working default:** Both supported; owner perspective primary (**PH-007**).

### 14.2 What Financial Engineering Does Not Do With Perspective

- It does not decide which perspective applies (scenario)
- It does not decide the commercial arrangement (scenario)

---

## 15. Scenario Comparison

### 15.1 Conceptual Role

Financial Engineering produces the **economic outputs that scenario comparison consumes**. It does not perform scenario comparison itself — that is a cross-cutting capability (`SYS-STR-FRM-001` §8.1).

### 15.2 Outputs for Scenario Comparison

| Output | Purpose |
|---|---|
| NPV per scenario | Comparative valuation |
| IRR per scenario | Comparative return |
| Payback per scenario | Comparative recovery |
| Revenue by stream per scenario | Comparative composition |
| Annual cash flows per scenario | Comparative timing |

### 15.3 Boundary Discipline

Financial Engineering produces **per-scenario outputs**. Scenario Management produces the **comparison**.

---

## 16. Modeling Traps

| Trap | Why It Matters | Conceptual Approach |
|---|---|---|
| **Double counting degradation** | Physical degradation reduces future revenue; a cash-flow degradation cost on top of that would double-count | Marginal degradation cost is a dispatch signal only; cash flow contains real augmentation/replacement flows only |
| **Double counting savings** | If Dispatch attributes a peak shaving revenue AND the tariff engine computes demand charge savings, peak shaving value is counted twice | Peak shaving's economic value comes only from the tariff engine (D2) |
| **Double counting charging energy cost** | Charging energy appears in the tariff bill (BTM) or is embedded in arbitrage (FTM); subtracting it separately double counts | Charging energy is **never** a separate line (§7.2) |
| **Double escalation of tariff savings** | Tariff escalation applied by the tariff engine, then again by Financial Engineering | Tariff escalation applied once, in the tariff engine |
| **Realization factor misapplication** | Applying the realization factor uniformly to all streams conflates forecast-risk streams with tariff-risk streams | Realization factor applied per stream (§8.3) |
| **Project IRR vs. equity IRR confusion** | Project IRR uses total project cash flows; equity IRR uses equity cash flows after debt service | Both computed, distinguished clearly |
| **Multiple IRRs** | Mid-life replacements change cash-flow sign multiple times | Acknowledge the risk; report the appropriate return; flag the ambiguity |
| **Pre-tax vs. post-tax confusion** | Pre-tax and post-tax KPIs differ materially | Working default is pre-tax (D9) |
| **Nominal vs. real confusion** | Nominal and real values differ when inflation is non-trivial; the real trap is a rate/flows mismatch | Working default: nominal cash flows with explicit inflation, nominal discount rate |
| **Perspective confusion** | Owner and client perspectives differ when shared-savings or service-fee contracts are in scope | Both supported; owner primary |
| **Escalation of one-time events** | Augmentation and replacement are one-time events, not recurring | Events escalated to their year, not annually |
| **Augmentation near end-of-life** | Augmentation in the final years rarely pays back | Augmentation policy (Scenario Management) should consider remaining contract term |
| **Missing terminal value** | A battery at 85% SOH at end of contract still has economic value | Terminal value must be representable (positive or negative) |
| **Charging cost from net load already in the bill** | BTM charging energy is inside the "bill with BESS"; subtracting it again double counts | Embedded in the tariff bill; not a separate line |

---

## 17. Interface with Dispatch & Optimization (Conceptual)

### 17.1 What Financial Engineering Consumes from Dispatch

| Input | Meaning |
|---|---|
| Dispatch schedule | Operational result |
| SOC trajectory | Operational result |
| Operational attribution basis | Which value stream is responsible for each attributable portion |
| Service-level metrics | What each service delivered |
| Market revenue attribution | Attributed quantities per market value stream |

### 17.2 What Financial Engineering Does Not Consume from Dispatch

- Dispatch methodology
- Dispatch objective function
- Marginal degradation cost
- Dispatch internal states

### 17.3 Boundary Discipline

Dispatch produces **operational results and attributed quantities**. Adapters settle market quantities. Financial Engineering converts them into **revenue**.

---

## 18. Interface with Degradation Engineering (Conceptual)

### 18.1 What Financial Engineering Consumes from Degradation

| Input | Meaning |
|---|---|
| Augmentation events | When capacity is added, and how much |
| Replacement events | When the battery is replaced |
| Physical event information | Physical quantities and timing |

### 18.2 What Financial Engineering Does Not Consume from Degradation

- SOH evolution
- Marginal degradation cost
- Aging model internals

### 18.3 Boundary Discipline

Degradation Engineering produces **physical events**. Scenario Management provides **cost assumptions**. Financial Engineering converts both into **cash flows**.

---

## 19. Interface with Load & Market Engineering (Conceptual)

### 19.1 What Financial Engineering Consumes from Load & Market

| Input | Meaning |
|---|---|
| Bill with BESS | Customer bill computed on net load |
| Bill without BESS | Customer bill computed on reference load |
| Savings by component | Demand charge, energy charge, export credit |
| Billing determinants | Billed peak demand, TOU energy |
| Market price signals | For reference |
| **Settled market quantities** | From market adapters |

### 19.2 What Financial Engineering Does Not Consume from Load & Market

- Tariff structure details
- Market rule details

### 19.3 Boundary Discipline

Load & Market produces **bill outputs, market signals, and settled quantities**. Financial Engineering aggregates them with other flows.

---

## 20. Interface with BESS Engineering (Conceptual)

### 20.1 What Financial Engineering Consumes from BESS Engineering

| Input | Meaning |
|---|---|
| Equipment specifications | Technical parameters on which cost assumptions are applied |

### 20.2 What Financial Engineering Does NOT Consume from BESS Engineering

- CAPEX
- O&M costs
- Replacement costs

**These are scenario assumptions, not BESS Engineering outputs.**

### 20.3 Boundary Discipline

BESS Engineering produces **capability and constraint — never value** (`A.2.1`). Cost assumptions belong to Scenario Management.

---

## 21. Interface with Data & Application Engineering (Conceptual)

### 21.1 What Financial Engineering Produces to Data & Application

| Output | Purpose |
|---|---|
| Financial KPIs | Display and reporting |
| Revenue by stream | Display and reporting |
| Annual cash flows | Display and reporting |
| Scenario comparison inputs | Cross-scenario comparison |

### 21.2 Boundary Discipline

Financial Engineering produces **economic results**. Data & Application Engineering handles **execution, storage, and presentation**.

---

## 22. Interface with Scenario Management (Conceptual)

### 22.1 What Scenario Management Provides to Financial Engineering

See §5.4.

### 22.2 What Financial Engineering Provides to Scenario Management

| Output | Purpose |
|---|---|
| NPV per scenario | Comparative valuation |
| IRR per scenario | Comparative return |
| Payback per scenario | Comparative recovery |
| Revenue by stream per scenario | Comparative composition |
| Annual cash flows per scenario | Comparative timing |

### 22.3 Boundary Discipline

Scenario Management provides **assumptions and comparison infrastructure**. Financial Engineering provides **per-scenario economic outputs**.

---

## 23. Assumptions and Engineering Uncertainties

### 23.1 Documented Assumptions

| # | Assumption | Rationale | Impact if Wrong |
|---|---|---|---|
| 1 | Two sources of truth for value (D2 tariff, D4+adapters settlement) | Consistent with `SYS-ENG-DEF-001` §11.4 | Would create double counting |
| 2 | Degradation events enter as investment flows | Consistent with `SYS-ENG-DEF-001` §11.5 | Would double-count degradation |
| 3 | Marginal degradation cost is not a cash flow | Consistent with `A.2.5` §2.3 | Would double-count degradation |
| 4 | Charging energy cost is not a separate line | Prevents double counting in both BTM and FTM | Would double-count charging cost |
| 5 | Realization factor applied per stream | Consistent with `A.2.4` §11.1 | Would conflate risk types |
| 6 | Tariff escalation applied once, in the tariff engine | Consistent with `A.2.2` §9.6 | Would double-escalate savings |
| 7 | Market revenue is settled by adapters, not by quantity × price | Consistent with `A.2.2` §13.5 | Would misstate market revenue |
| 8 | Project IRR is primary; equity IRR computed with default debt parameters | Working default **D8** | Would change KPI set |
| 9 | Pre-tax initially; ITC / depreciation flagged as extension | Working default **D9** | Would change tax treatment |
| 10 | Nominal cash flows with explicit inflation, nominal discount rate | Consistent rate/flows | Would risk rate/flows mismatch |
| 11 | Cost assumptions come from Scenario Management, not BESS Engineering | Consistent with A.2.1 principle | Would blur ownership |
| 12 | Terminal value is representable | A battery at 85% SOH has value | Would understate project value |

### 23.2 Engineering Uncertainties

| # | Uncertainty | Where It Must Be Resolved |
|---|---|---|
| 1 | Discount rate | Scenario |
| 2 | Escalation rates | Scenario |
| 3 | Contract term | Scenario |
| 4 | Financing structure details | Scenario / **PH-042** |
| 5 | Tax treatment details | **Stage B / C** / **PH-043** |
| 6 | Nominal vs. real (default fixed, revisable) | **PH-043** |
| 7 | ITC / depreciation | **PH-043** |
| 8 | Perspective (ENGIE vs. client) | **PH-007** |
| 9 | Realization factor magnitude | **PH-035** / Scenario |
| 10 | Reporting requirements | **PH-047** |
| 11 | Terminal value treatment | **Stage B / C** |
| 12 | Multiple-IRR handling | **Stage B / C** |
| 13 | Benchmark tools | **PH-005** |

### 23.3 Phase 1 Clarification Dependencies

This domain depends on the following Phase 1 items from `PH1-REG-001`:

- **PH-005** — Benchmark data and tools
- **PH-007** — Commercial perspective
- **PH-035** — Realization factor
- **PH-042** — Financing structure
- **PH-043** — Tax, incentives, and conventions
- **PH-047** — Reporting requirements
- **PH-055** — Presentation of value

---

## 24. Conceptual Outputs of the Domain

| Output | Consumer | Nature |
|---|---|---|
| NPV (project) | Data & Application, Scenario Management | Scalar |
| IRR (project) | Data & Application, Scenario Management | Scalar |
| IRR (equity) | Data & Application, Scenario Management | Scalar |
| Simple payback | Data & Application, Scenario Management | Scalar |
| Annual revenue by stream | Data & Application | Time series |
| Annual savings | Data & Application | Time series |
| Annual costs | Data & Application | Time series |
| Annual net cash flow | Data & Application | Time series |
| Terminal value | Data & Application | Scalar |
| Scenario comparison inputs | Scenario Management | Structured |

---

## 25. Validation Requirements (Conceptual)

### 25.1 Domain-Level Validation

| Check | Nature |
|---|---|
| Cash-flow consistency | Annual net cash flow equals inflows minus outflows |
| NPV consistency | NPV equals sum of discounted cash flows |
| IRR existence and uniqueness | IRR computed; multiple-IRR risk flagged where applicable |
| Payback consistency | Simple payback computed per convention |
| **Revenue by stream sum** | Sum of revenue by stream equals total annual revenue |
| **Savings by component sum** | Sum of savings by component equals total annual savings |
| **Single source of truth** | No value counted in both a savings line and a revenue line |
| **Charging energy not double counted** | Charging energy appears only inside the tariff bill (BTM) or netted in arbitrage (FTM) |
| **No double escalation** | Tariff savings not re-escalated |

### 25.2 Interface Validation

| Check | Nature |
|---|---|
| Dispatch input completeness | All operational results and attributed quantities received |
| Degradation input completeness | All augmentation and replacement events received |
| Tariff engine input completeness | All bill outputs and savings received |
| **Settled quantities completeness** | All settled market quantities received from adapters |
| **No double counting of degradation** | Marginal degradation cost does not appear as a cash flow |
| **No double counting of savings** | Peak shaving value comes only from the tariff engine |
| **No double counting of charging cost** | Charging energy is not a separate line |

### 25.3 Validation Evidence

Validation evidence must be **produced before results are accepted**.

---

## 26. Boundaries — Explicit

### 26.1 Answers

- What economic value results from the modeled project behavior?
- What is the project NPV, IRR, payback?
- What is the annual revenue by stream?
- What are the annual cash flows?
- What is the terminal value at end of contract?
- How do scenarios compare economically?

### 26.2 Does Not Answer

- What should the BESS do? (Domain 4)
- How does the battery degrade? (Domain 5)
- How is the customer bill computed? (Domain 2)
- How is revenue attributed? (Domain 4)
- How is market revenue settled? (Adapters)
- What is the physical capability of the BESS? (Domain 1)
- What is the external context? (System Context)
- How is the model implemented? (Stage B/C/D)

### 26.3 Inter-Domain Contract (Restated)

| From | To | Main Information |
|---|---|---|
| Financial | Data & Application | Financial KPIs, revenue by stream, cash flows, terminal value, scenario comparison inputs |
| Financial | Scenario Management | Per-scenario economic outputs |
| Dispatch | Financial | Dispatch schedule, SOC trajectory, operational attribution basis, service-level metrics, market revenue attribution |
| Market Adapters | Financial | Settled market quantities |
| Degradation | Financial | Augmentation events, replacement events, physical event information |
| Load & Market | Financial | Bill with and without BESS, savings by component, market price signals, settled quantities |
| Scenario Management | Financial | Discount rate, escalation, contract term, financing, tax, convention, realization factor, perspective, cost assumptions |

---

## 27. What Is Deliberately NOT Defined Here

### Mathematical Formulation
- Exact cash-flow formulation
- Tax treatment equations
- Depreciation methodology
- ITC treatment
- Debt service calculation
- Coverage ratios
- Distribution waterfall
- Discounting conventions
- Terminal value computation
- Multiple-IRR handling

### Software Structure
- Classes, functions, APIs
- Data structures
- Storage representation

### Data Contracts
- Parameter schemas
- Units convention
- Currency handling

### Integration Details
- How inputs are passed to Financial Engineering
- How outputs are passed downstream
- Orchestration

### Accounting
- Accounting treatment
- Financial statement preparation

### Reporting
- Report templates
- Dashboard designs

These belong to Stage B, Stage C, Stage D, or to Scenario Management.

---

## 28. Traceability to Upstream Documents

| Source | Section | Covered Here |
|---|---|---|
| `SYS-STR-FRM-001` v0.8 | §5 Domain 6, §6.2 Causal Backbone, §6.4 Operational signals vs. investment assumptions, §12.2 D8, D9 | Yes |
| `SYS-ENG-DEF-001` v0.5 | §11 Domain 6, §11.4 Single source of truth, §11.5 Degradation cost double-counting rule, §13 Inter-Domain Contract | Yes |
| `A.2.1-BESS-ENG-001` v1.2 | §2.4 Guiding Principle (capability and constraint, never value) | Yes |
| `A.2.2-LOAD-MKT-ENG-001` v1.3 | §9 Tariff engine, §9.8 Single source of truth, §13.5 Adapters own settlement | Yes |
| `A.2.3-OPS-ENG-001` v1.3 | §15 Interface with Financial Engineering, §15.2 Mapping convention | Yes |
| `A.2.4-DISPATCH-ENG-001` v0.8 | §13 Operational Attribution Basis, §22 Interface with Financial | Yes |
| `A.2.5-DEG-ENG-001` v0.2 | §2.3 Three concepts, §13 Interface with Financial | Yes |
| `PH1-REG-001` v1.1 | Register IDs | Yes |

---

## 29. Engineering Decisions Deferred to Later Stages

| # | Decision | Stage | Working default |
|---|---|---|---|
| 1 | Cash-flow formulation | Stage B / C | — |
| 2 | Tax treatment | **PH-043** | Pre-tax |
| 3 | Depreciation methodology | Stage B / C / **PH-043** | — |
| 4 | ITC treatment | **PH-043** | — |
| 5 | Debt service calculation | Stage B / C / **PH-042** | Default debt parameters |
| 6 | Coverage ratios | Stage B / C | — |
| 7 | Distribution waterfall | Stage B / C | — |
| 8 | Discounting conventions | Stage B / C | Nominal rate, nominal flows |
| 9 | Nominal vs. real | **PH-043** | Nominal |
| 10 | Currency handling | **PH-043** | Not fixed |
| 11 | Perspective handling | **PH-007** | Both; owner primary |
| 12 | Realization factor magnitude | **PH-035** / Scenario | Configurable |
| 13 | Escalation of one-time events | Stage B / C | Events at their year |
| 14 | Terminal value treatment | Stage B / C | Representable |
| 15 | Multiple-IRR handling | Stage B / C | Flag risk; report appropriate return |
| 16 | Validation tolerances | Stage C / **PH-006** | — |

---

## 30. Next Steps

This document establishes the **conceptual engineering definition** for Domain 6 — Financial Engineering. It closes the economic translation layer.

The Stage A.2 chapters:

| Order | Document ID | Domain | Status |
|---|---|---|---|
| 1 | A.2.1 | BESS Engineering | ✅ Baselined (v1.2) |
| 2 | A.2.2 | Load & Market Engineering | ✅ Baselined (v1.3) |
| 3 | A.2.3 | Operational Engineering | ✅ Baselined (v1.3) |
| 4 | A.2.4 | Dispatch & Optimization Engineering | ✅ Development Draft (v0.8) |
| 5 | A.2.5 | Degradation Engineering | ✅ Development Baseline (v0.2) |
| 6 | A.2.6 | Financial Engineering | ✅ **This document — Development Draft** |
| 7 | A.2.7 | Data & Application Engineering | ⏭ Next |

**Immediate next document:** `A.2.7 — Data & Application Engineering`, the final domain chapter.

---

## 31. ENGIE Clarification Requests Relevant to Financial Engineering

The following clarification items are relevant to this domain. They are tracked in the **Phase 1 Clarification & Data Request Register** (`PH1-REG-001` v1.1). This section lists only the items relevant to Financial Engineering, by their **Register ID**.

| Register ID | Clarification / Data Request | Why Required |
|---|---|---|
| **PH-005** | **Benchmark data and tools.** What established benchmarks will be used to validate the model? Can ENGIE provide reference cases with expected results? | Defines acceptance and validation |
| **PH-007** | **Commercial perspective.** Should results be shown from ENGIE's perspective as owner or operator, from the client's perspective, or both? | Affects value attribution and reporting conventions |
| **PH-035** | **Realization factor.** What magnitude should apply to market-based revenues? Is it configurable per scenario? | Affects reported market value |
| **PH-042** | **Financing structure.** What debt parameters (gearing, interest rate, tenor) should be used for equity IRR? Are default values acceptable, configurable by the user? | Determines the equity IRR calculation |
| **PH-043** | **Tax, incentives, and conventions.** Should the model include tax, depreciation, and incentives such as the ITC? What currency? Nominal or real? Inflation and escalation conventions? | Determines the financial methodology |
| **PH-047** | **Reporting requirements.** Are there ENGIE templates or branding requirements for PDF and Excel exports? | Determines reporting design |
| **PH-055** | **Presentation of value.** Does ENGIE accept the split between tariff-based savings and market-based revenue, with no double counting? | Determines reporting convention |

**Note.** Items are assigned IDs in `PH1-REG-001`. The Register is the authoritative source; this section is a filtered view.

---

**Prepared by:** BESS Operational & Financial Modeling Consultant
**Engagement:** RFP-264144-1
**Stage:** A.2.6 — Conceptual Engineering (Financial Engineering)
**Status:** Conceptual Engineering — Development Draft
**Duration:** 12 Weeks
**Language:** English

---





