## STAGE-B-HLD-001 — System Architecture (HLD)

## §7 — B.4 Financial Architecture

**Document ID:** B.4-FIN-ARCH-001

**Version:** 0.4 — Baseline (Frozen)

**Section:** §7 — B.4 Financial Architecture

**Status:** Stage B — Baseline (Frozen)

**Parent Documents:**

- SYS-STR-FRM-001 — System Strategy & Delivery Framework
- SYS-ENG-DEF-001 — Stage A.1 — System Component Definition
- A.2.1-BESS-ENG-001 — BESS Engineering
- A.2.2-LOAD-MKT-ENG-001 — Load & Market Engineering
- A.2.3-OPS-ENG-001 — Operational Engineering
- A.2.4-DISPATCH-ENG-001 — Dispatch & Optimization Engineering
- A.2.5-DEG-ENG-001 — Degradation Engineering
- A.2.6-FIN-ENG-001 — Financial Engineering
- A.2.7-DATA-APP-ENG-001 — Data & Application Engineering
- PH1-REG-001 — Phase 1 Clarification & Data Request Register
- STAGE-B-HLD-INDEX-001 — Stage B HLD Master Index and Scope Definition
- B.0-INTEGRATED-SYS-ARCH-001 — B.0 Integrated System Architecture (v0.3.3 Baseline Frozen)
- B.1-DATA-ARCH-001 — B.1 Data Architecture (v0.3 Baseline Frozen)
- B.2-MODEL-ARCH-001 — B.2 Model Architecture (v0.5.1 Baseline Frozen)
- B.3-OPT-ARCH-001 — B.3 Optimization Architecture (v0.6 Baseline Frozen)

**Note on versions.** Parent document versions are not restated here; they are as declared in each document.

**Change log.** See §14 for detailed changes across versions.

**PH verification.** PH IDs cited: PH-007, PH-035, PH-040, PH-042, PH-043. Verified against PH1-REG-001 v1.1.

---

## 1. Purpose of B.4

B.4 defines the financial architecture of the system. It establishes:

- What financial inputs the Financial Engine consumes
- What value categories exist
- What cost categories exist
- How cash flow is constructed
- How revenue and savings are attributed
- How realization factor is applied
- How financial KPIs are defined and architecturally derived (NPV, project IRR, equity IRR, payback)
- How representative-period results are annualized
- How project vs equity perspective is distinguished
- How terminal value is treated
- How double counting is prevented
- What logical financial types are recognized

B.4 does not define:

- Exact cash-flow equations
- Tax treatment details
- Financing structure details (debt service calculation, coverage ratios, distribution waterfall)
- Discounting conventions
- Depreciation methodology
- ITC treatment details
- Accounting treatment
- Class structures
- Code

Those belong to Stage C (specification) and Stage D (implementation).

**Rule:** B.4 defines the logical financial architecture; Stage C defines the physical financial specification.

B.4 answers: *How is operational behavior translated into project-level economic performance?*

---

## 2. Position Within Stage B

B.4 sits after B.3 (Optimization Architecture). It closes the causal chain defined in B.0: the economic consequence of the physical-operational cycle.

| View | Depends on | Detail Level |
|------|------------|--------------|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| B.2 Model Architecture | B.0, B.1 | Component details |
| B.3 Optimization Architecture | B.0, B.2 | Dispatch details |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| B.5 Software Architecture | B.0–B.4 | Software details |
| B.6 Databricks Architecture | B.0–B.5 | Platform details |

**Rule:** B.4 constrains B.5–B.6 on financial aspects. No view can contradict B.4's financial architecture.

**Rule:** B.4 does not redefine components, responsibilities, interfaces, data families, model objects, or optimization aspects already declared in B.0, B.1, B.2, or B.3.

---

## 3. Financial Architecture View

### 3.1 Overview

The financial architecture is centered on the Financial Engine, which translates operational and physical results into project-level economic performance.

```
              OPERATIONAL SYSTEM
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
     Dispatch      Tariff     Degradation
   Attribution     Engine       Events
        │            │            │
        ▼            ▼            ▼
   Settlement       BTM        Physical
     Basis         Savings      Events
        │            │            │
        └────────────┼────────────┘
                     ▼
           FINANCIAL TRANSLATION
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
      Value         Costs      Financing /
      Items                      Tax
        └────────────┼────────────┘
                     ▼
                 CASH FLOWS
                     │
            ┌────────┴────────┐
            ▼                 ▼
         PROJECT           EQUITY
         ECONOMICS         ECONOMICS
            │                 │
            └────────┬────────┘
                     ▼
                    KPIs
```

**Key distinction:** Operational / settlement results → Financial Value → Cash Flow → Economics → KPIs. Financial does not simply receive "revenues" and sum them.

### 3.2 Financial Layers

| Layer | Description |
|-------|-------------|
| Revenue Layer | Market revenue + BTM savings |
| Cost Layer | CAPEX, OPEX, degradation events, market participation costs |
| Realization Layer | Realization factor applied per stream |
| Cash-Flow Layer | Aggregation, escalation, discounting |
| KPI Layer | NPV, project IRR, equity IRR, payback |
| Terminal Layer | Terminal value (positive or negative) |
| Perspective Layer | Project vs equity |

### 3.3 Key Distinctions

| Concept | Definition |
|---------|------------|
| Revenue | Inflow from market participation (settled via adapters) |
| Savings | Avoided customer expenditure resulting from BESS operation, as calculated by the Tariff Engine |
| Cost | Outflow (CAPEX, OPEX, replacement, market costs) |
| Realization factor | Adjustment applied per stream to reflect forecast accuracy |
| Cash flow | Aggregated inflow minus outflow per period |
| Terminal value | Economic value at end of contract term |
| Perspective | Whose economics are being measured (project vs equity) |

**Rule:** These are different financial concepts. They are not layers, not components, and not domains.

---

## 4. Financial Inputs

### 4.1 From Dispatch Engine (B.3)

| Input | Meaning |
|-------|---------|
| Attribution basis | Which operational behavior belongs to which value stream |
| Service-level metrics | What each service delivered |
| Dispatch schedule | Operational result |
| SOC trajectory | Operational result (indirect) |

**Note:** Dispatch produces the attribution basis. Financial Engineering does not perform attribution.

### 4.2 From Tariff Engine (B.2 / A.2.2 §9)

| Input | Meaning |
|-------|---------|
| Bill without BESS | Customer bill on reference load |
| Bill with BESS | Customer bill on net load |
| Savings by component | Demand charge, energy charge, export credit, power factor / kVAR |
| Billing determinants | Billed peak, ratcheted demand, TOU energy |

**Note:** The Tariff Engine is the single source of truth for BTM savings. Financial Engineering consumes the bill outputs; it does not recompute the bill.

### 4.3 From Degradation Engine (B.2 / A.2.5)

| Input | Meaning |
|-------|---------|
| Augmentation events | When capacity is added, and how much |
| Replacement events | When the battery is replaced |
| Physical event information | Physical quantities and timing |

**Important:** Degradation Engineering provides physical events, not monetary cash flows. Financial Engineering converts them into cash flows using cost assumptions from Scenario Management.

### 4.4 From Load & Market Model — Market / Program Settlement (A.2.2 §13.5)

| Input | Meaning |
|-------|---------|
| Settlement basis / settlement outputs | Market- or program-specific quantities, adjustments, and settlement determinants required to determine realized financial value |

**Rule:** Market revenue is not the product of attributed quantity × market price. The market/program adapter applies the market's settlement rules (mileage, performance score, baseline, penalties, etc.) to the attributed quantities and produces the settlement basis. Financial Engineering consumes the settlement basis and performs the economic valuation.

**Architectural clarification — adapter ownership.**

The market/program adapter is executed **within the Load & Market Model**, consistent with A.2.2 §13.5, where the adapters are part of Domain 2. The Load & Market Model receives the attribution basis from Dispatch and produces the settlement basis as its output. This is declared in B.2 v0.5.1 §7.2 (Interface Matrix) through the two interfaces:

- **Dispatch Engine → Load & Market Model:** attribution basis (for settlement)
- **Load & Market Model → Financial Engine:** settlement basis

For streams that do not require market settlement (if any), the attribution basis flows directly from Dispatch Engine → Financial Engine, as declared in B.2 §7.2.

**Flow:**

```
Dispatch Engine
     │
     │ attribution basis
     ▼
Load & Market Model
     │ (executes Market / Program Adapter, per A.2.2 §13.5)
     │ settlement basis
     ▼
Financial Engine
     │
     │ economic valuation
     ▼
Revenue
```

**Note on interface ownership.** B.4 does not declare new interfaces; it references the interfaces declared in B.2 v0.5.1 §7.2. This respects the rule in §2: *B.4 does not redefine components, responsibilities, interfaces, data families, model objects, or optimization aspects already declared in B.0, B.1, B.2, or B.3.*

### 4.5 From Scenario Management

All cost assumptions are scenario parameters. Financial Engineering does not consume cost data from BESS Engineering.

| Input | Meaning |
|-------|---------|
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
| Realization factor | Per stream (PH-035) |
| Perspective | ENGIE vs. client (PH-007) |
| Terminal value assumption | Residual value, decommissioning, recycling |

**Note:** BESS Engineering provides equipment specifications (technical parameters) on which cost assumptions are applied, but not the costs themselves. This preserves the A.2.1 principle: *capability and constraint — never value*.

---

## 5. Value Categories

### 5.1 Two Primary Value Sources

Per B.0 §11.4 and B.1, there are two primary value sources:

| Value category | Source |
|----------------|--------|
| Behind-the-meter savings | Domain 2 — Tariff engine |
| Market revenues | Domain 4 — Dispatch attribution, settled through the Load & Market Model's market/program adapters (per §4.4) |

**Rule:** Financial Engineering does not recompute either. It consumes both, applies financial assumptions, and produces consolidated project performance.

### 5.2 Revenue Categories

| Category | Description | Source |
|----------|-------------|--------|
| Peak shaving savings | Demand charge reduction | Tariff engine (BTM) |
| Energy arbitrage savings (BTM) | Energy charge reduction from TOU shifting | Tariff engine (BTM) |
| Export credits | Compensation for exported energy | Tariff engine (BTM) |
| Power factor / kVAR savings | Avoided power factor penalties | Tariff engine (BTM) |
| Wholesale arbitrage revenue (FTM) | LMP arbitrage | Dispatch attribution + Load & Market settlement |
| Frequency regulation revenue | Capacity and/or mileage | Dispatch attribution + Load & Market settlement |
| Demand response revenue | Event-based or capacity-based | Dispatch attribution + Load & Market settlement |
| Capacity market revenue | Availability payment | Dispatch attribution + Load & Market settlement |

**Note on source composition.** "Dispatch attribution + Load & Market settlement" means: Dispatch produces the attribution basis; the Load & Market Model executes the market/program adapter and produces the settlement basis; Financial Engineering consumes the settlement basis and performs the economic valuation (per §4.4).

### 5.3 Realization Factor

The realization factor is applied per stream, in Financial Engineering.

| Stream type | Realization factor treatment |
|-------------|------------------------------|
| Arbitrage and market revenues | Applied — realized value depends on forecast accuracy |
| Behind-the-meter savings | Not applied uniformly. Ratchets, coincident peaks, and other tariff mechanisms are tariff computation mechanics, not a realization factor. If a financial realization adjustment for BTM is required, it must be an explicit scenario / Financial Engineering assumption |

**Reference:** B.3 §11, A.2.6 §8.3, PH-035.

**Note on the distinction between tariff mechanics and realization factor.**

- *Tariff mechanics* (ratchets, coincident-peak charges, etc.) are the rules by which the tariff engine computes the BTM savings. They are not a realization adjustment.
- *Realization factor* is a financial adjustment reflecting forecast accuracy. If the BTM savings require such an adjustment, it is a scenario parameter, not an implicit assumption derived from tariff mechanics.

---

## 6. Cost Categories

### 6.1 Investment

| Cost | Description | Source of event | Source of cost |
|------|-------------|-----------------|----------------|
| CAPEX | Initial investment | Project start (scenario) | Scenario Management |
| Augmentation | Capacity addition | Degradation Engine | Scenario Management |
| Replacement | Full replacement | Degradation Engine | Scenario Management |
| Decommissioning | Removal / recycling | End of project | Scenario Management |

### 6.2 Operating

| Cost | Description | Source |
|------|-------------|--------|
| O&M | Ongoing operating and maintenance | Scenario Management (escalated) |
| Market participation costs | Bidding fees, imbalance charges | Load & Market settlement (where applicable) |

### 6.3 Charging Energy Cost — Not a Separate Line

Charging energy cost is **never** a separate cash-flow line. It is handled as follows:

| Configuration | Treatment |
|---------------|-----------|
| Behind-the-meter | Charging energy is already embedded in the customer bill with BESS computed by the tariff engine. It is not subtracted separately |
| Front-of-meter | Charging energy costs are represented through the applicable market settlement/revenue formulation and must not be deducted again when already embedded in the settlement basis |

**Rule:** Adding it as a separate line would double count the cost in both configurations.

### 6.4 Tax and Incentives

| Category | Treatment |
|----------|-----------|
| Corporate income tax | Where applicable (Stage C) |
| Depreciation | Where applicable (Stage C) |
| Tax credits (ITC, PTC, etc.) | Where applicable (Stage C) |

**Working default (PH-043):** Pre-tax initially; ITC / depreciation flagged as extension.

### 6.5 Degradation Cost — Avoiding Double Counting

| Where | What it represents | Effect |
|-------|-------------------|--------|
| Dispatch objective | Marginal degradation cost | Signal, not a cash flow |
| Project cash flow | Actual augmentation and replacement flows | Real money spent |

**Rule:** The marginal degradation cost is only a dispatch signal. The cash flow contains only real flows.

**Reference:** B.0 §11.5, B.1 §5, B.2 §4.6, B.3 §10.4.

---

## 7. Cash Flow Architecture

### 7.1 Conceptual Structure

The project cash flow aggregates:

| Inflow | Outflow |
|--------|---------|
| Behind-the-meter savings (from the Tariff Engine / Domain 2) | CAPEX (initial, from scenario) |
| Market revenues (from Dispatch attribution / Domain 4 + Load & Market settlement) | Augmentation (event from Degradation Engineering / Domain 5; cost from scenario) |
| Terminal / residual value (see §7.5) | Replacement (event from Degradation Engineering / Domain 5; cost from scenario) |
| | Decommissioning (from scenario) |
| | O&M (from scenario) |
| | Market participation costs (where applicable) |
| | Tax (where applicable) |

**Note:** Charging energy cost is not a separate line (§6.3).

### 7.2 Timing

Cash flows are aligned to periods defined by the scenario (typically annual).

### 7.3 Escalation

Cost and revenue escalation applied per scenario assumptions.

**Note:** Tariff escalation is applied once, in the tariff engine (B.2 §4.3). Financial Engineering does not re-escalate tariff-based savings.

### 7.4 Discounting

Cash flows are discounted at the scenario's discount rate to compute NPV.

**Working architectural convention:** nominal cash flows with explicit inflation and a nominal discount rate. Exact timing, compounding, and discounting formulation are defined in Stage C.

### 7.5 Terminal Value

At the end of the contract term, the cash flow may include:

| Element | Nature |
|---------|--------|
| Residual value | The remaining economic value of the battery asset at end of contract |
| Decommissioning cost | Cost of removing or recycling the asset |
| Recycling / salvage value | Where applicable |

**Conceptual requirement.** Financial Engineering must be able to represent a terminal value at the end of the project, positive or negative.

### 7.6 Representative-Period Aggregation

Under representative-period simulation (PH-040), savings and revenues from representative months must be weighted when annualized. Calendar-year savings reflect the full 12 months, not only the simulated ones.

**Note:** Under ratchets, all 12 months are simulated (no representative-period reduction), and annualization is straightforward.

---

## 8. Financial KPIs

### 8.1 NPV

Net Present Value — sum of discounted net cash flows over the contract term, including terminal value where applicable.

**Type:** Project NPV (primary), possibly equity NPV.

### 8.2 IRR

| IRR type | Treatment |
|----------|-----------|
| Project IRR | Computed on total project cash flows — primary KPI (PH-042) |
| Equity IRR | Computed on equity cash flows — requires debt structure, computed with default debt parameters, configurable (PH-042) |

**Note on multiple IRRs.** When replacements occur mid-life, cash flows may change sign multiple times, potentially producing multiple IRRs. The KPI must acknowledge this risk.

### 8.3 Payback

Simple Payback — years to recover initial investment from undiscounted net cash flows.

### 8.4 Revenue by Stream

Annual revenue and savings broken down by value stream, per the attribution and settlement conventions.

**Source composition:**

| Stream | Source |
|--------|--------|
| Peak Shaving | Tariff engine savings (demand charge component) |
| Energy Arbitrage (BTM) | Tariff engine savings (energy charge component) |
| Export Credits | Tariff engine savings (export component) |
| Voltage Regulation (BTM) | Tariff engine savings (power factor / kVAR component, where applicable) |
| Frequency Regulation | Dispatch attribution, settled by Load & Market Model |
| Demand Response | Dispatch attribution, settled by Load & Market Model |
| Energy Arbitrage (FTM) | Dispatch attribution, settled by Load & Market Model |
| Capacity | Dispatch attribution, settled by Load & Market Model |

---

## 9. Financing

### 9.1 Debt Parameters

For equity IRR, Financial Engineering requires:

- Gearing ratio
- Interest rate
- Loan tenor
- Repayment schedule
- Grace period (if applicable)

**Working default (PH-042):** Default debt parameters provided, configurable by the user.

### 9.2 What B.4 Defines

- That equity IRR requires a debt structure
- What debt parameters are required
- That default values are provided and configurable

### 9.3 What B.4 Does Not Define

- Debt service calculation
- Coverage ratios
- Distribution waterfall
- Accounting treatment

Those belong to Stage C.

---

## 10. Perspective

### 10.1 Commercial Perspective

Financial Engineering must support the commercial perspective requested by the scenario:

| Perspective | What it represents |
|-------------|-------------------|
| ENGIE's perspective | Owner / operator economics |
| Client's perspective | Savings, service fee, net benefit |
| Both | Where the commercial arrangement requires both views |

**Working default:** The architecture supports multiple commercial perspectives. The initial implementation uses the owner/operator perspective as the primary reference case, subject to Phase 1 commercial clarification (PH-007).

### 10.2 What B.4 Defines

- That perspective is a scenario parameter
- That multiple perspectives are supported
- That the owner perspective is the initial reference case

### 10.3 What B.4 Does Not Define

- The exact split formula for shared-savings contracts
- The exact service-fee formula for storage-as-a-service
- Accounting treatment

Those belong to Stage C.

---

## 11. Double Counting — Prevention Rules

The financial architecture must prevent the following double-counting traps:

| Trap | Rule |
|------|------|
| Double counting degradation | Marginal degradation cost is a dispatch signal only; cash flow contains real augmentation/replacement flows only |
| Double counting savings | Peak shaving value comes only from the tariff engine (Domain 2) |
| Double counting charging energy cost | Charging energy is never a separate line (§6.3) |
| Double escalation of tariff savings | Tariff escalation applied once, in the tariff engine |
| Realization factor misapplication | Applied per stream (§5.3) |
| Project IRR vs. equity IRR confusion | Both computed, distinguished clearly |
| Pre-tax vs. post-tax confusion | Working default is pre-tax (PH-043) |
| Nominal vs. real confusion | Working architectural convention: nominal cash flows, nominal discount rate |
| Perspective confusion | Multiple perspectives supported; owner primary |
| Escalation of one-time events | Augmentation and replacement are one-time events, at their year |
| Missing terminal value | Terminal value must be representable (positive or negative) |
| Charging cost from net load already in the bill | BTM charging energy is inside the "bill with BESS"; not a separate line |
| DR payments as bill credits | DR value counted once, as program revenue; excluded from the tariff bill |

**Rule:** These rules are architectural invariants. Any deviation is a Stage C decision with explicit justification.

---

## 12. Logical Financial Types

### 12.1 Recognized Types

B.4 recognizes the following logical financial types:

| Logical Type | Description | Example |
|--------------|-------------|---------|
| Revenue stream | Inflow from market participation | LMP arbitrage |
| Savings stream | Avoided customer expenditure from BESS operation | Demand charge savings |
| Investment flow | One-time outflow | CAPEX, replacement |
| Operating flow | Recurring outflow | O&M |
| Derived KPI | Aggregated performance metric | NPV, IRR, payback |
| Terminal value | End-of-project economic value | Residual value |
| Perspective view | Economics from a specific perspective | Owner / client |

### 12.2 Deferred to Stage C

**Deferred to Stage C**

- Exact cash-flow equations
- Tax treatment
- Depreciation methodology
- ITC treatment
- Debt service calculation
- Coverage ratios
- Distribution waterfall
- Discounting conventions
- Terminal value computation
- Multiple-IRR handling

---

## 13. What Is Deliberately NOT Defined Here

| Not defined in B.4 | Belongs to |
|--------------------|------------|
| Exact cash-flow formulation | Stage C |
| Tax treatment equations | Stage C |
| Depreciation methodology | Stage C |
| ITC treatment | Stage C |
| Debt service calculation | Stage C |
| Coverage ratios | Stage C |
| Distribution waterfall | Stage C |
| Discounting conventions | Stage C |
| Terminal value computation | Stage C |
| Multiple-IRR handling | Stage C |
| Class structures | Stage C |
| Method signatures | Stage C |
| Code | Stage D |

---

## 14. Change Log

### 14.1 Changes from v0.1 to v0.2

| # | Change | Reason |
|---|--------|--------|
| 1 | Parent Documents: B.2 v0.4 Frozen, B.3 v0.3 Baseline Candidate | Correct versions |
| 2 | §4.4: "settled quantities" → "Settlement basis / settlement outputs" | Broader, precise definition |
| 3 | §3.3 and §12.1: "Savings" → "Avoided customer expenditure resulting from BESS operation" | Avoid assuming it is an inflow without perspective consideration |
| 4 | §5.3: clarified that tariff mechanics (ratchets, coincident peaks) are NOT a realization factor; any BTM realization adjustment must be an explicit scenario assumption | Critical conceptual correction |
| 5 | §6.3: FTM charging energy reframed as "represented through the applicable market settlement/revenue formulation" | More robust for non-arbitrage services |
| 6 | §7.4: discounting reframed as "working architectural convention"; exact formulation deferred to Stage C | Preserve HLD boundary |
| 7 | §10.1: "Both supported; owner primary" → "Multiple perspectives supported; owner primary as initial reference case, subject to PH-007" | Softer, recognizes pending clarification |
| 8 | §3.1: added "Operational / Settlement Results → Financial Value → Cash Flow → Economics → KPIs" diagram | Clarify the financial translation flow |
| 9 | Cross-reference audit: B.0 §11.5 referenced for double counting (was §11.4) | Correct internal references |

### 14.2 Changes from v0.2 to v0.3

| # | Change | Reason |
|---|--------|--------|
| 1 | §1: "How financial KPIs are computed" → "How financial KPIs are defined and architecturally derived" | Align with Stage B boundary (exact formulations belong to Stage C) |
| 2 | §7.1: replaced D2/D4/D5 abbreviations with full domain names (Tariff Engine / Domain 2, Dispatch attribution / Domain 4, Degradation Engineering / Domain 5) | Avoid ambiguous abbreviations |
| 3 | §5.1: "Two Sources of Truth" → "Two Primary Value Sources" | Reflect that market settlement is distributed between Dispatch attribution + adapter settlement logic |

### 14.3 Changes from v0.3 to v0.4

| # | Change | Reason |
|---|--------|--------|
| 1 | §4.4: added architectural clarification that the market/program adapter is executed **within the Load & Market Model** (Domain 2), with reference to B.2 v0.5.1 §7.2 interfaces (Dispatch → Load & Market Model: attribution basis; Load & Market Model → Financial Engine: settlement basis) | Resolve coherence gap: the adapter is not a standalone computational object; it is executed by the Load & Market Model. Interfaces are declared in B.2 v0.5.1 |
| 2 | §4.4: added flow diagram and note on interface ownership (B.4 references B.2 v0.5.1 interfaces; does not declare new ones) | Preserve the rule in §2 and avoid interface redefinition |
| 3 | §5.1: clarified market revenues source — settled through the Load & Market Model's market/program adapters | Consistency with §4.4 |
| 4 | §5.2: source column aligned with §4.4 — "Dispatch attribution + Load & Market settlement" (was "Dispatch attribution + market adapter" / "+ program adapter") | Eliminate duplicate representation of adapter ownership; single consistent phrasing |
| 5 | §6.2: "Market adapters (where applicable)" → "Load & Market settlement (where applicable)" | Consistency with §4.4 |
| 6 | §7.1: inflow wording aligned — "Domain 4 + Load & Market settlement" (was "Domain 4 + adapters") | Consistency with §4.4 |
| 7 | §8.4: "settled by adapter" → "settled by Load & Market Model" | Consistency with §4.4 |
| 8 | Parent Documents: B.2 updated to v0.5.1 Baseline Frozen; B.3 updated to v0.6 Baseline Frozen | A frozen document cannot rely on a "Candidate" parent. Both parents are now frozen. B.2 v0.5.1 includes the settlement interface patch required by §4.4 |
| 9 | PH verification header: added PH-040 (used in §7.6 for representative periods) | PH ID completeness |

**Note on versioning.** The v0.3 was reopened because §4.4 required an interface coherence fix with B.2 (settlement interfaces and adapter ownership). The content change is material (new settlement flow, new parent version, new ownership clarification), so the version was incremented to v0.4. The v0.3 is superseded.

**Prerequisite.** This v0.4 requires B.2 v0.5.1 to be frozen and to declare the settlement interfaces referenced in §4.4.

### 14.4 Version History

| Version | Date | Changes | Status |
|---------|------|---------|--------|
| 0.1 | Stage B start | Initial B.4 draft | Superseded |
| 0.2 | Stage B closure | 9 corrections | Superseded |
| 0.3 | Stage B closure | 3 corrections | Superseded (reopened) |
| 0.4 | Stage B closure | 9 corrections (adapter ownership + interface coherence + parent versions + PH-040) | Baseline (Frozen) |

---

## 15. Next Steps

**B.4 status:**

| Aspect | Status |
|--------|--------|
| B.4 Financial Architecture | ✅ Baseline (Frozen) (v0.4) |
| B.5 Software Architecture | ⏭ Next |
| B.6 Databricks Architecture | ⏭ Pending |
| Stage B → Stage C Handoff | ⏭ Pending |

**Immediate next action.** Proceed to B.5 Software Architecture.

---

**End of §7 — B.4 Financial Architecture (v0.4 — Baseline Frozen)**

**Status:** Baseline (Frozen)

**Next:** B.5 Software Architecture

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1