
---

# Phase 1 Clarification & Data Request Register

**Document ID:** PH1-REG-001

**Version:** 1.1 — Consolidated

**Status:** Stage A — Phase 1 Register — Baselined

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.3)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.4)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v1.0)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.4)
- `A.2.6-FIN-ENG-001` — Financial Engineering (v0.3)
- `A.2.7-DATA-APP-ENG-001` — Data & Application Engineering (v0.3)

**Purpose:** Provide the **authoritative consolidated list** of Phase 1 clarification items across the seven engineering domains and the System Strategy, enabling consistent reference, tracking, and resolution throughout the engagement.

---

## 1. Purpose of This Document

This document constitutes the **Phase 1 Clarification & Data Request Register** for the ENGIE BESS Operational & Financial Modeling engagement.

Its purpose is to establish the **single source of truth** for all Phase 1 clarification items, including:

- What needs to be clarified with ENGIE
- Why each item is required
- Which domain(s) the item affects
- Which document(s) cite the item
- What the working default is (for defaultable items)
- What the current status is

It deliberately does **not** define:

- The technical content of the clarifications (those are in the domain chapters)
- The resolution of the items (those are tracked here, but resolved elsewhere)
- The implementation of any decision (that belongs to later stages)

### 1.1 Structure

The Register is organized as follows:

| Section | Content |
|---|---|
| §2 | Register structure and conventions |
| §3 | Blocking items (must be resolved in Weeks 1–2) |
| §4 | Defaultable items (proceed under stated assumption if not confirmed) |
| §5 | Cross-reference table (item → domain → document) |
| §6 | Status tracking |
| §7 | Usage notes |
| §8 | Change control |

### 1.2 What This Document Does Not Repeat

This document does **not** repeat the technical content of the clarifications. Those are declared in the domain chapters (A.2.1–A.2.7) and the System Strategy (`SYS-STR-FRM-001`). The Register **consolidates**, **unifies IDs**, and **provides traceability**.

---

## 2. Register Structure and Conventions

### 2.1 Register ID Format

All Phase 1 clarification items are identified by a **Register ID** in the format:

```
PH-XXX
```

where `XXX` is a zero-padded three-digit number (e.g. `PH-001`, `PH-042`, `PH-055`).

### 2.2 Priority Classification

| Priority | Meaning | Timing |
|---|---|---|
| **Blocking** | Genuinely prevents design; must be resolved before the affected work can proceed | Weeks 1–2 |
| **Defaultable** | Has a defensible working assumption; proceeds under that assumption if not confirmed | Anytime, revisable |

### 2.3 Status Classification

| Status | Meaning |
|---|---|
| **Open** | Not yet resolved |
| **Pending ENGIE** | Awaiting ENGIE response |
| **Resolved** | Confirmed by ENGIE |
| **Defaulted** | Proceeding under the working assumption (no ENGIE response) |

### 2.4 Source Domain Classification

| Abbreviation | Domain |
|---|---|
| **Strategy** | System Strategy & Delivery Framework |
| **D1** | BESS Engineering |
| **D2** | Load & Market Engineering |
| **D3** | Operational Engineering |
| **D4** | Dispatch & Optimization Engineering |
| **D5** | Degradation Engineering |
| **D6** | Financial Engineering |
| **D7** | Data & Application Engineering |

### 2.5 Cited-In Classification

The "Cited in" column lists the **document(s)** that reference the item, with their current version.

---

## 3. Blocking Items (Weeks 1–2)

Blocking items **genuinely prevent design**. They must be resolved before the affected work can proceed.

| Register ID | Topic | Why Blocking | Source Domain | Cited In | Status |
|---|---|---|---|---|---|
| **PH-001** | **Target market(s).** Which electricity markets, tariff structures, and ancillary-service products are within the initial delivery scope? | Market rules drive eligibility, dispatch logic, settlement, revenue | Strategy, D2, D3, D4 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3, A.2.3 v1.4, A.2.4 v1.0 | Open |
| **PH-002** | **Behind-the-meter vs. front-of-the-meter scope.** Is the initial delivery expected to support both BTM and FTM configurations, or is one the priority? | Determines which value streams and constraints apply | Strategy, D2, D3, D4 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3, A.2.3 v1.4, A.2.4 v1.0 | Open |
| **PH-003** | **Data availability.** What historical data will ENGIE provide — meter data, market prices, ancillary prices, regulation signals, customer bills — and at what resolution and horizon? | Determines what can be modeled; drives ingestion design | D1, D2 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.2 v1.3 | Open |
| **PH-004** | **Project configuration.** What is the primary reference configuration: standalone BESS, co-located with renewables, BTM, FTM, AC- or DC-coupled? | Determines which System Context dimensions are relevant and which interfaces are developed first | Strategy, D7 | SYS-STR-FRM-001 v0.9, A.2.7 v0.3 | Open |
| **PH-005** | **Benchmark data.** What established benchmarks will be used to validate the model? Can ENGIE provide reference cases with expected results? | Defines acceptance and validation | Strategy, D1, D4, D6 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.4 v1.0, A.2.6 v0.3 | Open |
| **PH-006** | **Acceptance thresholds.** What quantified accuracy, runtime, and usability criteria define acceptance? | Must be concrete before the thin slice is built | All domains | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.2 v1.3, A.2.4 v1.0 | Open |

**Total blocking items:** 6

---

## 4. Defaultable Items

Defaultable items have **defensible working assumptions**. The project proceeds under those assumptions if ENGIE does not confirm otherwise.

| Register ID | Topic | Working Default | Source Domain | Cited In | Status |
|---|---|---|---|---|---|
| **PH-007** | **Commercial perspective.** Should results be shown from ENGIE's perspective as owner or operator, from the client's perspective, or both? | Both supported; owner perspective primary | D6 | SYS-STR-FRM-001 v0.9, A.2.6 v0.3 | Open |
| **PH-008** | **Co-located configurations.** Does the first project require co-located BESS with renewable generation? | Standalone BESS (per PH-004 default) | Strategy | SYS-STR-FRM-001 v0.9 | Open |
| **PH-009** | **Presentation of value (strategy level).** Does ENGIE accept the split between tariff-based savings and market-based revenue? | Accepted (see also PH-055) | Strategy, D6 | SYS-STR-FRM-001 v0.9, A.2.6 v0.3 | Open |
| **PH-010** | **Reporting conventions (strategy level).** Are there ENGIE templates or branding requirements for outputs? | Both PDF and Excel; no branding (see also PH-047) | Strategy, D7 | SYS-STR-FRM-001 v0.9, A.2.7 v0.3 | Open |
| **PH-012** | **Users and handover.** Who are the users and roles, how many, and who will maintain the tool after week 12? | Both business development and technical maintainers | D7 | SYS-STR-FRM-001 v0.9, A.2.7 v0.3 | Open |
| **PH-015** | **Battery data.** Are vendor degradation curves or warranty terms available for the reference technologies? | Vendor data if available; otherwise literature | D1, D5 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.5 v0.4 | Open |
| **PH-016** | **SOC bounds and warranty.** Are SOC bounds driven by warranty terms, operating policy, or both? | Warranty-driven initially; policy-configurable | D1, D5 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.5 v0.4 | Open |
| **PH-017** | **SOC window behavior under degradation.** Proportional narrowing or preserved kWh reserves? | Proportional narrowing | D1, D5 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.5 v0.4 | Open |
| **PH-018** | **Multi-cohort aggregation after augmentation.** How should SOH be aggregated when multiple cohorts coexist? | Capacity-weighted SOH | D5 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.5 v0.4 | Open |
| **PH-019** | **Export and net metering.** How is exported energy compensated? | Net metering if applicable; otherwise no compensation | D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-020** | **Minimum bill and fixed charges.** Are there minimum-bill provisions or fixed charges? | Represented if applicable | D2 | SYS-STR-FRM-001 v0.9 | Open |
| **PH-021** | **Power factor penalties / kVAR charges.** Do the customer tariffs in scope include power factor penalties or kVAR charges? | Represented if applicable | D2, D3, D4 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3, A.2.3 v1.4, A.2.4 v1.0 | Open |
| **PH-022** | **Coincident-peak charges.** Where tariffs include coincident-peak charges (e.g. ERCOT 4CP, PJM 5CP), does ENGIE have a peak-prediction approach? | Peak hours assumed known, with configurable hit-rate factor | D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-023** | **Tariff structure detail.** How are ratchets, coincident-peak, and billing periods defined? | Represented per tariff rules | D2 | SYS-STR-FRM-001 v0.9 | Open |
| **PH-024** | **Tariff escalation.** How should tariff escalation be projected? Should the tool also evaluate tariff switching? | Configurable escalation; tariff switching as optional extension | D2, D6 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-025** | **Load projection growth.** What load growth assumptions should apply? Are site changes expected? | ENGIE-provided if available; otherwise statistical baseline | D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-026** | **BESS sizing vs. evaluation.** Is the model intended for sizing or evaluation? | Evaluation of a predefined configuration | D4 | SYS-STR-FRM-001 v0.9, A.2.4 v1.0 | Open |
| **PH-027** | **Primary model purpose / use case.** Project development support or other? | Evaluation (project development support) | D4 | SYS-STR-FRM-001 v0.9, A.2.4 v1.0 | Open |
| **PH-028** | **Model output granularity.** What level of detail is expected? | All levels (interval schedules, daily/monthly metrics, annual KPIs) | D4 | SYS-STR-FRM-001 v0.9, A.2.4 v1.0 | Open |
| **PH-029** | **Active vs. reactive priority.** When the inverter's apparent-power limit binds, is there a priority rule? | Project / grid-code dependent | D4 | A.2.4 v1.0 | Open |
| **PH-030** | **Dispatch validation benchmark.** What benchmark should be used for dispatch validation? | Internal consistency checks | D4 | A.2.4 v1.0 | Open |
| **PH-031** | **Revenue attribution under simultaneous services.** How should revenue be attributed when services overlap? | Rule-based attribution | D4 | A.2.4 v1.0 | Open |
| **PH-032** | **Financial objective inside dispatch.** Should degradation cost enter the dispatch objective? | Depends on dispatch methodology (see PH-034) | D5 | A.2.5 v0.4 | Open |
| **PH-033** | **Perfect foresight vs. forecast-based dispatch.** Which dispatch mode should be the default? | Perfect foresight; realization factor applied in Financial Engineering | Strategy, D2, D3, D4 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3, A.2.3 v1.4, A.2.4 v1.0 | Open |
| **PH-034** | **Dispatch methodology.** Rule-based heuristic, LP, MILP, or hybrid? | LP | Strategy, D3, D4 | SYS-STR-FRM-001 v0.9, A.2.3 v1.4, A.2.4 v1.0 | Open |
| **PH-035** | **Realization factor.** What magnitude should apply to market-based revenues? Is it configurable per scenario? | Configurable per scenario; default range to be agreed | Strategy, D6 | SYS-STR-FRM-001 v0.9, A.2.6 v0.3 | Open |
| **PH-036** | **Degradation feedback time scale.** Frequency of SOH update during operational simulation? | Annual SOH update with representative-period simulation | Strategy, D1, D4, D5 | SYS-STR-FRM-001 v0.9, A.2.1 v1.3, A.2.4 v1.0, A.2.5 v0.4 | Open |
| **PH-037** | **Degradation model calibration.** How should the model be calibrated if vendor data is unavailable? | Literature-based; validated against benchmarks | D5 | SYS-STR-FRM-001 v0.9 | Open |
| **PH-038** | **Degradation feedback time scale (confirmatory).** Confirmation of annual SOH update with representative-period aggregation. | Confirms PH-036 | D5 | A.2.5 v0.4 | Open |
| **PH-039** | **Financial objective inside dispatch (confirmatory).** Confirmation of PH-032. | Confirms PH-032 | D5 | A.2.5 v0.4 | Open |
| **PH-040** | **Representative-period scheme and ratchets.** Monthly representative periods respecting the billing period; where ratchets apply, all 12 months simulated. | Monthly representative periods; 12 months if ratchets apply | Strategy, D4 | SYS-STR-FRM-001 v0.9, A.2.4 v1.0 | Open |
| **PH-041** | **Voltage regulation coupling.** Should the P² + Q² ≤ S² coupling be linearized, or represented as a fixed envelope? | Fixed envelope — no linearization initially | Strategy, D3, D4 | SYS-STR-FRM-001 v0.9, A.2.3 v1.4, A.2.4 v1.0 | Open |
| **PH-042** | **Financing structure.** What debt parameters (gearing, interest rate, tenor) should be used for equity IRR? | Default debt parameters provided; configurable by the user | Strategy, D6 | SYS-STR-FRM-001 v0.9, A.2.6 v0.3 | Open |
| **PH-043** | **Tax, incentives, and conventions.** Should the model include tax, depreciation, and incentives such as the ITC? What currency? Nominal or real? | Pre-tax initially; ITC / depreciation flagged as extension. Nominal cash flows. | Strategy, D5, D6 | SYS-STR-FRM-001 v0.9, A.2.5 v0.4, A.2.6 v0.3 | Open |
| **PH-044** | **Augmentation policy.** Scheduled, SOH-threshold-triggered, or both? | SOH-threshold-triggered | Strategy, D5 | SYS-STR-FRM-001 v0.9, A.2.5 v0.4 | Open |
| **PH-045** | **Replacement policy.** Does replacement reset capacity to BOL? | Reset to BOL | Strategy, D5 | SYS-STR-FRM-001 v0.9, A.2.5 v0.4 | Open |
| **PH-046** | **Databricks environment.** Please confirm workspace ownership, access provisioning, Databricks Apps availability, Unity Catalog usage, and compute policies. | ENGIE-owned workspace; consultant granted developer access | Strategy, D7 | SYS-STR-FRM-001 v0.9, A.2.7 v0.3 | Open |
| **PH-047** | **Reporting requirements.** Are there ENGIE templates or branding requirements for PDF and Excel exports? | Both PDF and Excel; no branding | Strategy, D6, D7 | SYS-STR-FRM-001 v0.9, A.2.6 v0.3, A.2.7 v0.3 | Open |
| **PH-048** | **Audit / lineage / traceability scope.** Are execution logs, data lineage, and audit outputs required deliverables, or optional engineering practices? | Basic execution logs + data lineage | Strategy, D7 | SYS-STR-FRM-001 v0.9, A.2.7 v0.3 | Open |
| **PH-049** | **Grid constraints.** What are the interconnection limits and export constraints at the site? | Represented if provided | Strategy, D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-050** | **Load forecasting method.** What method should be used for load projection over the contract term? | ENGIE-provided if available; otherwise statistical baseline | Strategy, D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-051** | **Load forecasting home.** Does load forecasting belong to Domain 2 conceptually, with implementation via Domain 7? | Yes — Domain 2 owns it conceptually | Strategy, D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-052** | **Scenario granularity.** How many core scenarios should be delivered initially? | 3–5 core scenarios initially, expandable | Strategy, D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-053** | **Market adapter scope.** How many market adapters should be delivered at handover? | One adapter at delivery; architecture supports more | Strategy, D2 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3 | Open |
| **PH-054** | **Time resolution.** What time resolution should the model use — 15-minute, hourly, or a mix? | 15-minute when input data permits; hourly otherwise | Strategy, D2, D4 | SYS-STR-FRM-001 v0.9, A.2.2 v1.3, A.2.4 v1.0 | Open |
| **PH-055** | **Presentation of value (BTM mapping convention).** Does ENGIE accept the mapping convention proposed in `A.2.3` §15.2 for attributing behind-the-meter savings to value streams? | Accepted | Strategy, D3, D6 | SYS-STR-FRM-001 v0.9, A.2.3 v1.4, A.2.6 v0.3 | Open |

**Total defaultable items:** 49

---

## 5. Cross-Reference Table

### 5.1 By Register ID

| Register ID | Topic | Priority | Primary Domain | Cited In |
|---|---|---|---|---|
| PH-001 | Target market(s) | Blocking | Strategy, D2, D3, D4 | SYS-STR-FRM-001, A.2.2, A.2.3, A.2.4 |
| PH-002 | BTM vs. FTM scope | Blocking | Strategy, D2, D3, D4 | SYS-STR-FRM-001, A.2.2, A.2.3, A.2.4 |
| PH-003 | Data availability | Blocking | D1, D2 | SYS-STR-FRM-001, A.2.1, A.2.2 |
| PH-004 | Project configuration | Blocking | Strategy, D7 | SYS-STR-FRM-001, A.2.7 |
| PH-005 | Benchmark data | Blocking | Strategy, D1, D4, D6 | SYS-STR-FRM-001, A.2.1, A.2.4, A.2.6 |
| PH-006 | Acceptance thresholds | Blocking | All domains | SYS-STR-FRM-001, A.2.1, A.2.2, A.2.4 |
| PH-007 | Commercial perspective | Defaultable | D6 | SYS-STR-FRM-001, A.2.6 |
| PH-008 | Co-located configurations | Defaultable | Strategy | SYS-STR-FRM-001 |
| PH-009 | Presentation of value (strategy) | Defaultable | Strategy, D6 | SYS-STR-FRM-001, A.2.6 |
| PH-010 | Reporting conventions (strategy) | Defaultable | Strategy, D7 | SYS-STR-FRM-001, A.2.7 |
| PH-012 | Users and handover | Defaultable | D7 | SYS-STR-FRM-001, A.2.7 |
| PH-015 | Battery data | Defaultable | D1, D5 | SYS-STR-FRM-001, A.2.1, A.2.5 |
| PH-016 | SOC bounds and warranty | Defaultable | D1, D5 | SYS-STR-FRM-001, A.2.1, A.2.5 |
| PH-017 | SOC window behavior | Defaultable | D1, D5 | SYS-STR-FRM-001, A.2.1, A.2.5 |
| PH-018 | Multi-cohort aggregation | Defaultable | D5 | SYS-STR-FRM-001, A.2.1, A.2.5 |
| PH-019 | Export and net metering | Defaultable | D2 | SYS-STR-FRM-001, A.2.2 |
| PH-020 | Minimum bill and fixed charges | Defaultable | D2 | SYS-STR-FRM-001 |
| PH-021 | Power factor penalties | Defaultable | D2, D3, D4 | SYS-STR-FRM-001, A.2.2, A.2.3, A.2.4 |
| PH-022 | Coincident-peak charges | Defaultable | D2 | SYS-STR-FRM-001, A.2.2 |
| PH-023 | Tariff structure detail | Defaultable | D2 | SYS-STR-FRM-001 |
| PH-024 | Tariff escalation | Defaultable | D2, D6 | SYS-STR-FRM-001, A.2.2 |
| PH-025 | Load projection growth | Defaultable | D2 | SYS-STR-FRM-001, A.2.2 |
| PH-026 | BESS sizing vs. evaluation | Defaultable | D4 | SYS-STR-FRM-001, A.2.4 |
| PH-027 | Primary model purpose | Defaultable | D4 | SYS-STR-FRM-001, A.2.4 |
| PH-028 | Model output granularity | Defaultable | D4 | SYS-STR-FRM-001, A.2.4 |
| PH-029 | Active vs. reactive priority | Defaultable | D4 | A.2.4 |
| PH-030 | Dispatch validation benchmark | Defaultable | D4 | A.2.4 |
| PH-031 | Revenue attribution | Defaultable | D4 | A.2.4 |
| PH-032 | Financial objective inside dispatch | Defaultable | D5 | A.2.5 |
| PH-033 | Perfect foresight vs. forecast-based | Defaultable | Strategy, D2, D3, D4 | SYS-STR-FRM-001, A.2.2, A.2.3, A.2.4 |
| PH-034 | Dispatch methodology | Defaultable | Strategy, D3, D4 | SYS-STR-FRM-001, A.2.3, A.2.4 |
| PH-035 | Realization factor | Defaultable | Strategy, D6 | SYS-STR-FRM-001, A.2.6 |
| PH-036 | Degradation feedback time scale | Defaultable | Strategy, D1, D4, D5 | SYS-STR-FRM-001, A.2.1, A.2.4, A.2.5 |
| PH-037 | Degradation model calibration | Defaultable | D5 | SYS-STR-FRM-001 |
| PH-038 | Degradation feedback (confirmatory) | Defaultable | D5 | A.2.5 |
| PH-039 | Financial objective (confirmatory) | Defaultable | D5 | A.2.5 |
| PH-040 | Representative-period scheme | Defaultable | Strategy, D4 | SYS-STR-FRM-001, A.2.4 |
| PH-041 | Voltage regulation coupling | Defaultable | Strategy, D3, D4 | SYS-STR-FRM-001, A.2.3, A.2.4 |
| PH-042 | Financing structure | Defaultable | Strategy, D6 | SYS-STR-FRM-001, A.2.6 |
| PH-043 | Tax, incentives, and conventions | Defaultable | Strategy, D5, D6 | SYS-STR-FRM-001, A.2.5, A.2.6 |
| PH-044 | Augmentation policy | Defaultable | Strategy, D5 | SYS-STR-FRM-001, A.2.5 |
| PH-045 | Replacement policy | Defaultable | Strategy, D5 | SYS-STR-FRM-001, A.2.5 |
| PH-046 | Databricks environment | Defaultable | Strategy, D7 | SYS-STR-FRM-001, A.2.7 |
| PH-047 | Reporting requirements | Defaultable | Strategy, D6, D7 | SYS-STR-FRM-001, A.2.6, A.2.7 |
| PH-048 | Audit / lineage scope | Defaultable | Strategy, D7 | SYS-STR-FRM-001, A.2.7 |
| PH-049 | Grid constraints | Defaultable | Strategy, D2 | SYS-STR-FRM-001, A.2.2 |
| PH-050 | Load forecasting method | Defaultable | Strategy, D2 | SYS-STR-FRM-001, A.2.2 |
| PH-051 | Load forecasting home | Defaultable | Strategy, D2 | SYS-STR-FRM-001, A.2.2 |
| PH-052 | Scenario granularity | Defaultable | Strategy, D2 | SYS-STR-FRM-001, A.2.2 |
| PH-053 | Market adapter scope | Defaultable | Strategy, D2 | SYS-STR-FRM-001, A.2.2 |
| PH-054 | Time resolution | Defaultable | Strategy, D2, D4 | SYS-STR-FRM-001, A.2.2, A.2.4 |
| PH-055 | Presentation of value (BTM mapping) | Defaultable | Strategy, D3, D6 | SYS-STR-FRM-001, A.2.3, A.2.6 |

### 5.2 By Domain

#### Strategy (`SYS-STR-FRM-001`)

| Register ID | Topic |
|---|---|
| PH-001 to PH-055 | All items (Strategy references the full Register) |

#### D1 — BESS Engineering (`A.2.1`)

| Register ID | Topic |
|---|---|
| PH-003 | Data availability |
| PH-005 | Benchmark data |
| PH-006 | Acceptance thresholds |
| PH-015 | Battery data |
| PH-016 | SOC bounds and warranty |
| PH-017 | SOC window behavior |
| PH-018 | Multi-cohort aggregation |
| PH-036 | Degradation feedback time scale |

#### D2 — Load & Market Engineering (`A.2.2`)

| Register ID | Topic |
|---|---|
| PH-001 | Target market(s) |
| PH-002 | BTM vs. FTM scope |
| PH-003 | Data availability |
| PH-006 | Acceptance thresholds |
| PH-019 | Export and net metering |
| PH-021 | Power factor penalties |
| PH-022 | Coincident-peak charges |
| PH-024 | Tariff escalation |
| PH-025 | Load projection growth |
| PH-033 | Perfect foresight vs. forecast-based |
| PH-049 | Grid constraints |
| PH-050 | Load forecasting method |
| PH-051 | Load forecasting home |
| PH-052 | Scenario granularity |
| PH-053 | Market adapter scope |
| PH-054 | Time resolution |

#### D3 — Operational Engineering (`A.2.3`)

| Register ID | Topic |
|---|---|
| PH-001 | Target market(s) |
| PH-002 | BTM vs. FTM scope |
| PH-021 | Power factor penalties |
| PH-033 | Perfect foresight vs. forecast-based |
| PH-034 | Dispatch methodology |
| PH-041 | Voltage regulation coupling |
| PH-055 | Presentation of value (BTM mapping) |

#### D4 — Dispatch & Optimization (`A.2.4`)

| Register ID | Topic |
|---|---|
| PH-001 | Target market(s) |
| PH-002 | BTM vs. FTM scope |
| PH-005 | Benchmark data |
| PH-006 | Acceptance thresholds |
| PH-021 | Power factor penalties |
| PH-026 | BESS sizing vs. evaluation |
| PH-027 | Primary model purpose |
| PH-028 | Model output granularity |
| PH-029 | Active vs. reactive priority |
| PH-030 | Dispatch validation benchmark |
| PH-031 | Revenue attribution |
| PH-033 | Perfect foresight vs. forecast-based |
| PH-034 | Dispatch methodology |
| PH-036 | Degradation feedback time scale |
| PH-040 | Representative-period scheme |
| PH-041 | Voltage regulation coupling |
| PH-054 | Time resolution |

#### D5 — Degradation Engineering (`A.2.5`)

| Register ID | Topic |
|---|---|
| PH-015 | Battery data |
| PH-016 | SOC bounds and warranty |
| PH-017 | SOC window behavior |
| PH-018 | Multi-cohort aggregation |
| PH-032 | Financial objective inside dispatch |
| PH-036 | Degradation feedback time scale |
| PH-037 | Degradation model calibration |
| PH-038 | Degradation feedback (confirmatory) |
| PH-039 | Financial objective (confirmatory) |
| PH-043 | Tax, incentives, and conventions |
| PH-044 | Augmentation policy |
| PH-045 | Replacement policy |

#### D6 — Financial Engineering (`A.2.6`)

| Register ID | Topic |
|---|---|
| PH-005 | Benchmark data |
| PH-007 | Commercial perspective |
| PH-009 | Presentation of value (strategy) |
| PH-024 | Tariff escalation |
| PH-035 | Realization factor |
| PH-042 | Financing structure |
| PH-043 | Tax, incentives, and conventions |
| PH-047 | Reporting requirements |
| PH-055 | Presentation of value (BTM mapping) |

#### D7 — Data & Application Engineering (`A.2.7`)

| Register ID | Topic |
|---|---|
| PH-004 | Project configuration |
| PH-010 | Reporting conventions (strategy) |
| PH-012 | Users and handover |
| PH-046 | Databricks environment |
| PH-047 | Reporting requirements |
| PH-048 | Audit / lineage scope |

---

## 6. Status Tracking

### 6.1 Summary

| Category | Count |
|---|---|
| **Total register items** | 55 |
| **Blocking** | 6 |
| **Defaultable** | 49 |
| **Open** | 55 |
| **Resolved** | 0 |
| **Defaulted** | 0 |

### 6.2 Blocking Items Status

| Register ID | Topic | Status | Owner |
|---|---|---|---|
| PH-001 | Target market(s) | Open | ENGIE |
| PH-002 | BTM vs. FTM scope | Open | ENGIE |
| PH-003 | Data availability | Open | ENGIE |
| PH-004 | Project configuration | Open | ENGIE |
| PH-005 | Benchmark data | Open | ENGIE |
| PH-006 | Acceptance thresholds | Open | ENGIE |

### 6.3 Resolution Log

| Date | Register ID | Action | Notes |
|---|---|---|---|
| — | — | Register created | Initial consolidation during Stage A closure |

---

## 7. Usage Notes

### 7.1 How to Use This Register

- **All Stage A documents** cite this Register for Phase 1 clarifications.
- **Stage B and subsequent stages** reference this Register for assumptions, decisions, and traceability.
- **New clarification items** must be added here, not to individual documents.
- **All clarifications to ENGIE** must reference this Register by ID.

### 7.2 Priority Handling

- **Blocking items** must be resolved by end of Week 2.
- **Defaultable items** proceed under their working default if not confirmed.
- Items not confirmed by end of Week 2 are marked **Defaulted** and documented as assumptions.

### 7.3 Status Updates

Status updates are the responsibility of the **consultant**. ENGIE responses are logged in the **Resolution Log** (§6.3).

### 7.4 Traceability

Every Register ID is traceable to:
- The **domain(s)** it affects
- The **document(s)** that cite it
- The **priority** (blocking / defaultable)
- The **working default** (for defaultable items)
- The **status** (open / resolved / defaulted)

---

## 8. Change Control

### 8.1 Version History

| Version | Date | Changes | Author |
|---|---|---|---|
| 1.0 | Stage A start | Initial Register created | Consultant |
| 1.1 | Stage A closure | Consolidated after Stage A.2 completion; unified IDs to PH-XXX; added cross-reference table | Consultant |

### 8.2 Change Procedure

- **Adding a new item:** assign the next available PH-ID; update §3 or §4; update §5 cross-reference.
- **Changing an item's status:** update §6.1, §6.2, §6.3.
- **Resolving an item:** update §6.3 and §3/§4 status.
- **Removing an item:** only if superseded; document the supersession.

### 8.3 Traceability to Stage A Documents

This Register is the **authoritative source** for all PH IDs cited in:
- `SYS-STR-FRM-001` v0.9
- `SYS-ENG-DEF-001` v0.6
- `A.2.1-BESS-ENG-001` v1.3
- `A.2.2-LOAD-MKT-ENG-001` v1.3
- `A.2.3-OPS-ENG-001` v1.4
- `A.2.4-DISPATCH-ENG-001` v1.0
- `A.2.5-DEG-ENG-001` v0.4
- `A.2.6-FIN-ENG-001` v0.3
- `A.2.7-DATA-APP-ENG-001` v0.3

---

## 9. Appendices

### Appendix A — Register ID Range

| Range | Items |
|---|---|
| PH-001 to PH-006 | Blocking items |
| PH-007 to PH-055 | Defaultable items |
| — | Total: 55 items |

### Appendix B — PH IDs Referenced in Stage A

The following PH IDs are referenced in the Stage A documents:

```
PH-001, PH-002, PH-003, PH-004, PH-005, PH-006, PH-007, PH-009, PH-010,
PH-012, PH-015, PH-016, PH-017, PH-018, PH-019, PH-021, PH-022, PH-026,
PH-027, PH-028, PH-029, PH-030, PH-031, PH-032, PH-033, PH-034, PH-035,
PH-036, PH-038, PH-040, PH-041, PH-042, PH-043, PH-044, PH-045, PH-046,
PH-047, PH-048, PH-049, PH-050, PH-051, PH-052, PH-053, PH-054, PH-055
```

**Total unique IDs referenced:** 46

**Total register items:** 55 (includes 9 items not explicitly cited in Stage A but assigned to keep the register complete)

### Appendix C — Items Not Explicitly Cited in Stage A

The following 9 items are in the Register but not explicitly cited in Stage A documents:

| Register ID | Topic | Assigned to |
|---|---|---|
| PH-008 | Co-located configurations | Strategy (implicit in PH-004) |
| PH-011 | (reserved) | — |
| PH-013 | (reserved) | — |
| PH-014 | (reserved) | — |
| PH-020 | Minimum bill and fixed charges | D2 (implicit in PH-023) |
| PH-023 | Tariff structure detail | D2 (implicit in PH-021/022) |
| PH-025 | Load projection growth | D2 (implicit in PH-050) |
| PH-037 | Degradation model calibration | D5 (implicit in PH-043) |
| PH-039 | Financial objective (confirmatory) | D5 (confirms PH-032) |

**Note.** These items are assigned IDs to keep the Register complete and to avoid gaps. They may become explicit in Stage B if needed.

---

## 10. Formal Sign-Off

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

**Stage:** A — Engineering Definition

**Register Version:** 1.1 — Consolidated

**Status:** Baselined

**Authorization:** This Register is the authoritative source for all Phase 1 clarifications in Stage A and subsequent stages.

**Duration:** 12 Weeks

**Language:** English

---

*End of Phase 1 Clarification & Data Request Register*

---



