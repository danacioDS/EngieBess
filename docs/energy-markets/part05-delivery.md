# Parte 5 — Delivery, Performance and Settlement

**Version:** 1.2 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Parent Document:** Market Engineering Model — Introduction Document (v1.2)
**Upstream Dependencies:**
- Parte 1 — Market Domain and Conventions (v1.3), specifically §7, §8, §10, §11, §12, §16, §18, §19
- Parte 2 — Transversal Market Values (v1.0), specifically §5–§11 (temporal framework instance, resolution mapping)
- Parte 3 — Market Products and Participation (v1.3), specifically §5 (Product-Mechanism), §7 (eligibility time dimension), §11 (temporal)
- Parte 4 — Market Rules, Signals, Commitments and Constraints (v1.4), specifically §6 (signals), §7 (commitment definitions), §8 (commitment instances), §9 (obligations), §12.4 (Parte 5 interface)
- BESS Engineering Part 1 — Fundamentals and Conventions (pinned per P1-O13)

**Scope note:** This document is **Parte 5 — Delivery, Performance and Settlement**. It is drafted after Parte 4 freezes. It consumes Parte 4's commitment definitions and delivery-obligation definitions and defines how delivery is measured, how performance is assessed and scored, how baselines and counterfactuals are established, how settlement quantities and **settlement amounts** are determined, and how market outputs are provided to downstream engineering.

**Document ID:** ME-P5-001 *(stable across versions)*

---

## Revision History

| Version | Date | Status | Change |
| --- | --- | --- | --- |
| 1.0 | 2026-09-22 | Development Draft | Initial M4 baseline. |
| 1.1 | 2026-09-22 | Development Draft | **Added null-path linkage rule:** assessment, deviation, and penalty records key on `Product-Mechanism + settlement window` when no Commitment Instance exists. **Added settlement amount** as an M4-owned market output; Financial Engineering values it. **Added compliance-to-instance state mapping** and disambiguated compliance states. **Removed "delivery scoring thresholds" from M4's consumes-from-M3b list;** tolerance is M4-owned or referenced. **Restated BTM as a market environment, not a participation branch;** rewrote Appendix A as a two-dimensional table. **Distinguished raw delivered quantity (Op/Opt) from recognized delivery quantity (M4).** **Replaced M4-O13** with a confirmation that settlement rules apply unchanged to simulated inputs. **Fixed cross-reference errors** (§14 uncertainty; M1 §16.4 materiality; §12.9 Network Engineering; §5.4 M1-O14). **Removed M2 capability mappings from the consumes list.** **Clarified that real settlement uses actual prices.** |
| 1.2 | 2026-09-22 | Development Draft | **Renamed from "M4" to "Parte 5" per project nomenclature.** **Updated all references from M1 → Parte 1, M2 → Parte 3, M3a → Parte 2, M3b → Parte 4.** **Updated Document ID from ME-M4-001 to ME-P5-001.** **Updated open item IDs from M4-Oxx to P5-Oxx.** **Updated Parent Document citation from Introduction v1.2 (already correct).** **Corrected all cross-references to the new nomenclature.** |

**Change control note:** The canonical lifecycle, the optional-node rule, the null-commitment path rule, the M2 template reference rule, and the M3 split are owned by **Introduction v1.2**. Parte 4 owns commitment definitions, delivery obligations, signals, and constraints. Parte 5 applies them and defines delivery, performance, and settlement. Where Parte 5 and the Introduction differ, the Introduction governs.

**Pending change requests:**
- **Introduction v1.3** — Add Network Engineering as an engineering domain (owned by Introduction; referenced by Parte 5 §12.9).
- **P1-O14** — Site/interconnection capability definition and value ownership (referenced by Parte 5 §5.4 for baselines on the BTM path).
- **P4-O17** — Award simulation rule (referenced by Parte 5 §10.6 for simulated settlement).

---

## 1. Purpose and Scope

Parte 5 establishes the **delivery, performance, and settlement layer** for Market Engineering.

Its purpose is to define, per **Commitment Instance** and per **Product-Mechanism**:

- **delivery semantics** — what counts as delivery, how it is observed, and what quantity is recognized;
- **delivery recognition** — the distinction between raw delivered quantities and recognized delivery quantities;
- **performance measurement** — how delivery is compared to the commitment or the baseline, and how performance is assessed;
- **delivery scoring** — thresholds and scoring rules used by the market to assess performance;
- **baselines and counterfactuals** — the reference quantities used to assess delivery where applicable;
- **deviation** — how deviation from the commitment or baseline is measured;
- **compliance** — how compliance with the commitment is determined;
- **settlement quantities** — the recognized quantities used as settlement inputs;
- **settlement price semantics** — how settlement prices are applied (without financial valuation);
- **settlement amounts** — the currency amounts produced by applying settlement price semantics to settlement quantities;
- **adjustments and penalties** — market-defined adjustments and penalties;
- **market outputs** — the quantities, prices, amounts, and statuses provided to downstream engineering;
- **Parte 5 assessment records** — the assessment records linked to Parte 4 Commitment Instances **or, on the null-commitment path, to a Product-Mechanism plus settlement window**;
- **settlement uncertainty** — the uncertainty owned by Parte 5.

Parte 5 does **not** define:

- product definitions, eligibility, qualification, capability mappings, or product-specific temporal requirements (Parte 3);
- transversal market values on the eligibility path (Parte 2);
- market rules, signals, commitment definitions, commitment instance formation data, operational obligations, or stacking constraints (Parte 4);
- **raw delivered quantities** — Parte 5 receives them from Operational/Optimization Engineering or from the meter and applies measurement rules to produce **recognized delivery quantities**;
- the Asset Dispatch Decision or operating trajectories (Operational/Optimization Engineering);
- the physical BESS model, physical constraints, or the degradation curve (BESS Engineering);
- the forecast methodology for market variables (Forecasting Engineering);
- the **economic valuation** of market outcomes — discounting, tax, NPV, IRR (Financial Engineering);
- the software implementation of settlement (Software Engineering);
- site/interconnection capability (Parte 1 definition; pending P1-O14).

Parte 5 defines **how delivery is measured, how performance is assessed and scored, how settlement quantities and settlement amounts are determined** — and provides the settlement amounts and supporting quantities and prices that Financial Engineering uses for economic valuation.

The primary question of Parte 5 is:

> **How is delivery measured and recognized, how is performance assessed and scored, how are baselines and counterfactuals defined, how are settlement quantities and settlement amounts determined, and how are market outputs provided to downstream engineering?**

---

## 2. Engineering Boundary

### 2.1 Position in the Part Chain

```text
       PARTE 1
Market Domain & Conventions
        │
        ▼
      PARTE 2
Transversal Market Values
        │
        ▼
      PARTE 3
Market Products & Participation
        │
        ▼
      PARTE 4
Full Rules, Signals,
Commitments & Constraints
        │
        ▼
      PARTE 5
Delivery, Performance & Settlement
```

**Freeze order:** Parte 1 → Parte 2 → Parte 3 → Parte 4 → **Parte 5**.

Parte 5 is drafted **after Parte 4 freezes**. Parte 5 consumes Parte 4's commitment definitions and delivery-obligation definitions.

### 2.2 Consumes and Provides

**Parte 5 consumes from Parte 1:**

- market semantic model, three participation branches (Parte 1 §8);
- **market environment (wholesale or BTM) as a separate axis from the participation branch (Parte 1 §7)**;
- commitment vs. dispatch vs. delivery distinction (Parte 1 §10);
- temporal framework (Parte 1 §11);
- time relationships (Parte 1 §12);
- evidence model (Parte 1 §16);
- uncertainty ownership (Parte 1 §18);
- semantic ownership (Parte 1 §19).

**Parte 5 consumes from Parte 2:**

- temporal framework instance (time zone, interval labeling, DST handling, resolution);
- resolution mapping method.

**Parte 5 consumes from Parte 3:**

- product identifiers and Product-Mechanism records (Parte 3 §4, §5);
- eligibility time dimension — validity windows, evaluation basis (Parte 3 §7.5);
- Product-Mechanism temporal requirements (Parte 3 §11).

**Parte 5 consumes from Parte 4:**

- commitment definitions (Parte 4 §7.4);
- commitment instances, formation data only (Parte 4 §8.2);
- delivery-obligation definitions (Parte 4 §7.4, §4.2);
- signal definitions and timing (Parte 4 §6);
- operational obligations (Parte 4 §9);
- constraint definitions relevant to delivery (Parte 4 §11);
- baseline/counterfactual trigger conditions, where market-defined (Parte 4 §7.4).

**Parte 5 consumes from Operational/Optimization Engineering:**

- **raw delivered quantities** (metered or simulated);
- operating trajectories;
- Asset Dispatch Decisions.

**Parte 5 provides to Operational/Optimization Engineering:**

- delivery requirements (obligation side, by reference to Parte 4);
- performance feedback where the operational model simulates delivery.

**Parte 5 provides to Financial Engineering:**

- settlement quantities;
- settlement prices;
- **settlement amounts**;
- delivery quantities (recognized);
- penalties;
- adjustments;
- other settlement outputs.

**Parte 5 provides to Forecasting Engineering:**

- delivery and settlement uncertainty definitions, where they affect forecasting.

**Parte 5 provides to Software Engineering:**

- assessment record structure;
- settlement quantity, price, and amount structures;
- baseline record structure;
- deviation and compliance record structures;
- market output structure.

**Parte 5 provides to BESS Engineering (via change control):**

- delivery-derived physical requirements, where delivery assessment reveals a physical gap.

**Parte 5 does not create an independent symbol registry.** Market-specific **symbols** are registered in the BESS Engineering Part 1 master symbol registry (Parte 1 §20). **Identifiers** are governed by Parte 3's identifier scheme.

### 2.3 Ownership Boundary by Kind of Record

| Kind of record | Owner |
| --- | --- |
| Commitment definitions (formation, obligation, satisfaction condition, instance lifetime) | Parte 4 |
| Commitment instance formation data (quantity, direction, price, period, source) | Parte 4 |
| Commitment instance Parte 4 states (Pending, Active, Cancelled) | Parte 4 |
| Delivery obligation definitions (what the commitment obliges) | Parte 4 |
| Signal definitions and timing (including publication timing) | Parte 4 |
| Operational obligations (ongoing) | Parte 4 |
| Raw delivered quantity | Operational/Optimization Engineering (or the meter) |
| Delivery definition and measurement | Parte 5 |
| Recognized delivery quantity | Parte 5 |
| Performance measurement and assessment | Parte 5 |
| Delivery scoring thresholds and scoring rules | Parte 5 |
| Baselines and counterfactuals | Parte 5 |
| Deviation measurement | Parte 5 |
| Compliance determination | Parte 5 |
| Settlement quantities | Parte 5 |
| Settlement price semantics | Parte 5 |
| **Settlement amounts** | **Parte 5** |
| Settlement adjustments and penalties | Parte 5 |
| Authoritative settlement quantity | Parte 5 |
| Market outputs | Parte 5 |
| Parte 5 assessment records (linked to Parte 4 instances, or to `Product-Mechanism + settlement window` on the null-commitment path) | Parte 5 |
| Commitment instance Parte 5 states (Satisfied, Breached) | Parte 5 |
| Settlement uncertainty | Parte 5 |
| **Economic valuation** (discounting, tax, NPV, IRR) | **Financial Engineering** |

**Reference rule:** Where a record's threshold or definition is owned by Parte 4 (or Parte 3, Parte 2, or Parte 1), Parte 5 **references** it by ID. Parte 5 does not restate it.

---

## 3. Intent

### 3.1 WHAT

Parte 5 represents the delivery, performance, and settlement layer as a structured set of:

- **Delivery definitions** — what counts as delivery per commitment or per Product-Mechanism on the null-commitment path;
- **Recognized delivery quantities** — the delivery quantity after measurement rules are applied;
- **Performance measurements** — how delivery is compared to the commitment or baseline;
- **Delivery scoring** — thresholds and scoring rules;
- **Baselines and counterfactuals** — reference quantities for delivery assessment;
- **Deviation records** — how deviation from commitment or baseline is measured;
- **Compliance records** — how compliance is determined;
- **Settlement quantities** — recognized quantities;
- **Settlement price semantics** — how prices are applied;
- **Settlement amounts** — the currency amounts produced by applying settlement price semantics to settlement quantities;
- **Adjustments and penalties** — market-defined adjustments and penalties;
- **Market outputs** — quantities, prices, amounts, and statuses provided to downstream engineering;
- **Parte 5 assessment records** — the assessment linked to each Parte 4 Commitment Instance **or, on the null-commitment path, to a Product-Mechanism plus settlement window**;
- **Settlement uncertainty** — the uncertainty owned by Parte 5.

### 3.2 WHY

The purpose is to prevent downstream engineering from treating delivery and settlement as a single undifferentiated calculation, and to preserve the distinctions that Parte 1 established:

- **Delivery** is not the same as **performance against the commitment**.
- **Delivery** is not the same as **settlement quantity**.
- **Settlement quantity** is not the same as **settlement amount**.
- **Settlement amount** is not the same as **financial valuation**.
- **Baseline** is not the same as **commitment**.
- **Deviation** is not the same as **penalty**.
- **Null commitment** does not mean **no delivery** and does not mean **no settlement**.
- **Settlement is distinct from financial valuation** (Parte 1 §4).

### 3.3 FOR WHOM

Parte 5 provides the delivery, performance, and settlement foundation for Financial Engineering, Operational/Optimization Engineering, Forecasting Engineering, Software Engineering, and BESS Engineering (via change control for delivery-derived physical requirements).

---

## 4. Delivery Semantics

### 4.1 Delivery Definition

**Delivery** is the physical or market-recognized quantity/state associated with a commitment — or, on the null-commitment path, the metered quantity.

Delivery is distinct from:

- **commitment** — the obligation (Parte 4);
- **Asset Dispatch Decision** — the operational decision (Operational/Optimization);
- **performance** — the comparison of delivery to the commitment or baseline (Parte 5 §6);
- **settlement quantity** — the recognized quantity used for settlement (Parte 5 §9);
- **settlement amount** — the currency amount produced by applying settlement price semantics (Parte 5 §9).

### 4.2 Raw vs. Recognized Delivery Quantity

Parte 5 distinguishes two quantities:

| Concept | Owner | Definition |
| --- | --- | --- |
| **Raw delivered quantity** | Operational/Optimization Engineering (or the meter) | The delivered quantity as produced by the operational model or the meter, before measurement rules are applied. |
| **Recognized delivery quantity** | Parte 5 | The delivered quantity after measurement rules (authoritative source, interval labeling, resolution mapping, correction) are applied. |

Parte 5 receives the **raw delivered quantity** as an input and produces the **recognized delivery quantity** as the delivery record's primary field.

### 4.3 Delivery Record Structure

Each delivery record shall carry:

| Field | Description |
| --- | --- |
| **Delivery ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` (commitment path) **or** `Product-Mechanism ID + settlement window` (null-commitment path) |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Delivery window** | The period the delivery applies to |
| **Raw delivered quantity reference** | Reference to the raw delivered quantity input |
| **Recognized delivery quantity** | The delivered quantity after measurement rules are applied |
| **Unit** | The unit of the recognized delivery quantity |
| **Direction** | Up / Down / Symmetric |
| **Measurement source** | Metered / Simulated / Telemetry-derived / Settlement-system |
| **Measurement resolution** | The resolution of the measurement |
| **Interval labeling** | Interval-beginning / Interval-ending (references Parte 1 §11.1 and Parte 2 §11) |
| **Time zone reference** | Reference to the Parte 2 temporal framework instance |
| **Authoritative flag** | Whether this record is the authoritative delivery record for the window |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 4.4 Delivery on the Commitment Path

On the commitment path, delivery is the **recognized delivery quantity** associated with the commitment.

- For **energy commitments**, delivery is the energy delivered in the delivery window.
- For **capacity commitments**, delivery is the availability provided during the commitment window.
- For **reserve commitments**, delivery is the reserve held during the commitment window.
- For **regulation commitments**, delivery is the response to the regulation signal.
- For **activation commitments**, delivery is the response to the activation instruction.
- For **availability commitments**, delivery is the availability within the commitment window.
- For **standing obligations**, delivery is the availability or response across the enrollment period.

### 4.5 Delivery on the Null-Commitment Path

On the null-commitment path (Parte 1 §8, Parte 4 §7.6):

- **Delivery** is defined as the **recognized delivery quantity** — the metered quantity after measurement rules are applied, not performance against a commitment.
- **No Commitment Instance exists** on this path. The Parte 5 assessment record, deviation record, and penalty record link to the **Product-Mechanism and settlement window** directly.
- **Performance Measurement** applies **only where the applicable mechanism measures performance against a baseline, schedule, or self-declared position** (e.g., balance-responsible deviation settlement; BTM/tariff baseline assessment). Where no such measurement exists, Performance Measurement does not apply.
- **Settlement** applies at the **applicable price or tariff**, which may be a market price, a tariff, or a baseline-based settlement.

**Null-path linkage rule (normative):**

> **On the null-commitment path, the Parte 5 assessment record, deviation record, and penalty record link to the `Product-Mechanism ID + settlement window` directly. No Commitment Instance exists on this path.**

### 4.6 Delivery vs. Commitment

The distinction (Parte 1 §10, Parte 1 §4) shall be preserved:

- **Commitment** — the obligation, owned by Parte 4.
- **Delivery** — the physical or market-recognized quantity/state associated with the commitment, owned by Parte 5.
- **Delivery obligation** — part of the commitment, owned by Parte 4.
- **Delivery definition and measurement** — owned by Parte 5.

### 4.7 Authoritative Delivery Quantity

Where multiple measurement sources exist (metered, telemetry, settlement-system), Parte 5 shall declare which is the **authoritative delivery quantity**. The authoritative quantity is used for performance assessment and settlement quantity determination.

The authoritative quantity is **declared per Product-Mechanism** and shall be recorded explicitly.

---

## 5. Baselines and Counterfactuals

### 5.1 Purpose

A **baseline** or **counterfactual** is the reference quantity against which delivery or performance is assessed where the market requires such a reference.

Baselines are used primarily for:

- **BTM participation**, where the counterfactual is what the site would have consumed or produced without the BESS response;
- **Demand response**, where the baseline is the customer's expected load;
- **Balance-responsible deviation settlement**, where the baseline is the self-declared schedule;
- **Tariff-based mechanisms**, where the baseline is the expected consumption profile.

### 5.2 Baseline Record Structure

Each baseline record shall carry:

| Field | Description |
| --- | --- |
| **Baseline ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Baseline type** | Counterfactual (BTM) / Expected load / Self-declared schedule / Tariff baseline / Other |
| **Baseline window** | The period the baseline applies to |
| **Baseline quantity** | The reference quantity |
| **Unit** | The unit of the baseline |
| **Calculation method** | How the baseline is calculated |
| **Data source** | The data used to calculate the baseline |
| **Authoritative flag** | Whether this baseline is the authoritative reference for the window |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 5.3 Baseline vs. Commitment

The baseline is **not** the commitment:

- **Commitment** — what the asset is obliged to do (Parte 4).
- **Baseline** — what the reference scenario would have been (Parte 5).

On the commitment path, delivery is assessed against the commitment. On the BTM path, delivery is assessed against the commitment **and** the baseline (see §6.5). On the null-commitment path with a self-declared position, delivery is assessed against the baseline.

### 5.4 Baseline Ownership

Parte 5 owns the baseline definition and measurement. Where the baseline depends on site/interconnection capability or a site-specific reference, Parte 5 references **P1-O14** (pending).

### 5.5 Baseline Uncertainty

Baseline uncertainty (measurement uncertainty, counterfactual estimation uncertainty, data gaps) is owned by **Parte 5** (Parte 1 §18).

---

## 6. Performance Measurement

### 6.1 Purpose

**Performance measurement** is the method used to determine whether delivery satisfies applicable requirements.

Performance measurement is distinct from:

- **delivery** — the delivered quantity (Parte 5 §4);
- **settlement quantity** — the recognized quantity used for settlement (Parte 5 §9);
- **compliance** — the determination of whether the commitment was satisfied (Parte 5 §8).

### 6.2 Performance Measurement on the Commitment Path

On the commitment path, performance measurement compares **recognized delivery** to the **commitment**:

| Field | Description |
| --- | --- |
| **Performance ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` **or** `Product-Mechanism ID + settlement window` (null-commitment path) |
| **Delivery ID** | The delivery record |
| **Committed quantity** | The committed quantity (from Parte 4) |
| **Recognized delivered quantity** | The delivered quantity (from Parte 5 §4) |
| **Deviation** | Recognized delivered − Committed |
| **Deviation unit** | The unit of the deviation |
| **Deviation direction** | Over-delivery / Under-delivery / On-target |
| **Performance window** | The period the performance applies to |
| **Tolerance** | The tolerance band, **owned by Parte 5** (see §7). Where the tolerance is an obligation threshold owned by Parte 4, reference the Parte 4 obligation by ID. |
| **Performance result** | Satisfied / Partially satisfied / Not satisfied / Exceeded (or scored) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

**Tolerance ownership rule:** Tolerance is owned by **Parte 5** unless the market defines it as an operational obligation, in which case **Parte 4** owns it and Parte 5 references it by ID.

### 6.3 Performance Measurement on the Null-Commitment Path

On the null-commitment path, performance measurement applies **only where the applicable mechanism measures performance against a baseline, schedule, or self-declared position**.

Where it applies, the performance measurement compares **recognized delivery** to the **baseline** (Parte 5 §5) rather than to a commitment.

Where no such measurement exists (e.g., uncommitted merchant participation without a declared position), performance measurement **does not apply**.

### 6.4 Performance Measurement on the BTM Path

On the BTM path, performance measurement compares **recognized delivery** to the **baseline** (Parte 5 §5.2). The baseline is the counterfactual consumption or production.

### 6.5 Environment vs. Branch

The **participation branch** (1, 2, or 3, per Parte 1 §8) determines the **commitment semantics**. The **market environment** (wholesale or BTM, per Parte 1 §7) determines **whether delivery is assessed against a baseline**.

These are separate axes. A BTM mechanism can host branch 1, 2, or 3 participation:

- A BTM demand-response program that creates a commitment is **branch 2**, with **baseline-based delivery**.
- A BTM tariff-based mechanism without a commitment is **branch 3**, with **baseline-based delivery** where the tariff requires it.
- A wholesale uncommitted merchant participation is **branch 3**, with **no baseline** (settlement at market price).

### 6.6 Performance Measurement vs. Delivery Scoring

**Performance measurement** determines whether delivery satisfies the requirement.

**Delivery scoring** (Parte 5 §7) assigns a score or penalty based on the degree of satisfaction.

The two are distinct: performance measurement produces the assessment; delivery scoring produces the consequence.

---

## 7. Delivery Scoring

### 7.1 Purpose

**Delivery scoring** applies a threshold or scoring rule to the performance measurement, producing a score or penalty input.

Delivery scoring thresholds are owned by **Parte 5** (Parte 4 §9.2, §2.3).

### 7.2 Delivery Scoring Record Structure

| Field | Description |
| --- | --- |
| **Scoring ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Scoring type** | Accuracy / Availability / Response / Delivery / Composite |
| **Scoring rule** | The rule that maps performance to score |
| **Threshold** | The threshold used |
| **Unit** | The unit of the threshold |
| **Score range** | The range of scores produced |
| **Consequence** | How the score affects settlement (referenced to §9) |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 7.3 Scoring vs. Settlement

A score is an **input** to settlement. It is not settlement itself. The mapping from score to settlement quantity or penalty is defined in §9 and §10.

---

## 8. Deviation and Compliance

### 8.1 Deviation

**Deviation** is the difference between delivery and the commitment (on the commitment path) or the baseline (on the BTM or null-commitment path with a self-declared position).

Deviation is recorded in the performance measurement (§6.2) and used by settlement (§9).

### 8.2 Deviation Record

Where deviation is material (per **Parte 1 §16.4** materiality), a deviation record shall be created:

| Field | Description |
| --- | --- |
| **Deviation ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` **or** `Product-Mechanism ID + settlement window` |
| **Delivery ID** | The delivery record |
| **Baseline ID** | The baseline record, where applicable |
| **Deviation quantity** | The deviation |
| **Unit** | The unit of the deviation |
| **Deviation direction** | Over / Under |
| **Deviation cause** | Operational / Market / Measurement / Other (where identifiable) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 8.3 Compliance

**Compliance** is the determination of whether the commitment was satisfied.

Compliance states:

| State | Meaning |
| --- | --- |
| **Satisfied** | Delivery met the commitment within tolerance. |
| **Partially satisfied** | Delivery met the commitment partially, within a defined band. |
| **Not satisfied** | Delivery did not meet the commitment. |
| **Exceeded** | Delivery exceeded the commitment materially (above the tolerance band). |

### 8.4 Compliance Record

| Field | Description |
| --- | --- |
| **Compliance ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` **or** `Product-Mechanism ID + settlement window` |
| **Performance ID** | The performance measurement |
| **Compliance state** | See §8.3 |
| **Compliance determination date** | When the determination was made |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 8.5 Compliance-to-Instance State Mapping

Parte 5 owns the **Satisfied** and **Breached** states of the Parte 4 Commitment Instance (Parte 4 §8.3). The compliance record is the Parte 5-side record that determines those states.

**Mapping (normative):**

| Parte 5 compliance state | Parte 4 instance state | Notes |
| --- | --- | --- |
| **Satisfied** | Satisfied | Delivery met the commitment within tolerance. |
| **Exceeded** | Satisfied | Delivery exceeded the commitment. Whether this is penalized depends on the market rule (see §10.4). |
| **Partially satisfied** | Breached | Delivery met the commitment partially. Treated as Breached unless the market rule specifies otherwise. |
| **Not satisfied** | Breached | Delivery did not meet the commitment. |

**Over-delivery rule (normative):**

> **Whether over-delivery (Exceeded) is penalized is a market-defined rule, referenced from Parte 4 §9 or defined as a Parte 5 penalty rule. Where the market penalizes over-delivery, the penalty is recorded in the penalty record (§10.4).**

---

## 9. Settlement

### 9.1 Purpose

**Settlement** is the market mechanism that determines recognized quantities, settlement price semantics, and settlement amounts.

Settlement is **distinct from financial valuation** (Parte 1 §4). Parte 5 determines the settlement quantities, settlement price semantics, and **settlement amounts**. Financial Engineering determines the economic valuation of those amounts.

### 9.2 Settlement Quantity

A **settlement quantity** is the recognized quantity used as a settlement input.

Settlement quantities are determined per Product-Mechanism and per Commitment Instance (or per null-commitment linkage) from:

- the commitment quantity (Parte 4);
- the recognized delivery quantity (Parte 5 §4);
- the deviation (Parte 5 §8);
- the score (Parte 5 §7), where applicable;
- the applicable settlement rule.

### 9.3 Authoritative Settlement Quantity

Where multiple quantities are available (committed, delivered, metered, telemetry-derived), Parte 5 shall declare which is the **authoritative settlement quantity**.

**The authoritative settlement quantity is declared per Product-Mechanism** and shall be recorded explicitly.

The declaration is **owned by Parte 5** (Parte 3 §11.3, Parte 1 §11.3).

### 9.4 Settlement Price Semantics

Parte 5 defines **how settlement prices are applied**. It does **not** define the prices themselves where they are market signals (Parte 4 §6).

Settlement price semantics include:

- which signal (Parte 4 §6) is applied;
- the observation time and valid window of the price;
- the application rule (e.g., price × quantity, price × deviation);
- the direction (up/down);
- any adjustment or cap.

**Real vs. simulated prices.** Real settlement uses **actual prices** as observed. In simulation, prices come from Forecasting or from historical data, and this shall be stated explicitly per simulated Product-Mechanism.

### 9.5 Settlement Quantity Record

| Field | Description |
| --- | --- |
| **Settlement Quantity ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` **or** `Product-Mechanism ID + settlement window` |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Settlement window** | The period the settlement applies to |
| **Settlement quantity** | The recognized quantity |
| **Unit** | The unit of the settlement quantity |
| **Authoritative flag** | Whether this is the authoritative settlement quantity |
| **Derivation** | How the quantity was derived (from commitment, delivery, deviation, score, or other) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 9.6 Settlement Price Record

| Field | Description |
| --- | --- |
| **Settlement Price ID** | Unique identifier |
| **Signal ID** | The Parte 4 signal used |
| **Application rule** | How the price is applied |
| **Observation time** | The observation time of the price |
| **Valid window** | The valid window of the price |
| **Direction** | Up / Down / Symmetric |
| **Adjustment** | Any adjustment or cap |
| **Price source** | Actual / Forecast / Historical (for simulated settlement) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 9.7 Settlement Amount

Parte 5 computes the **settlement amount** by applying the settlement price semantics to the settlement quantity.

The settlement amount is the **currency amount** that would appear on a settlement statement. Financial Engineering performs the **economic valuation** of that amount (discounting, tax, NPV, IRR).

**Settlement Amount Record:**

| Field | Description |
| --- | --- |
| **Settlement Amount ID** | Unique identifier |
| **Settlement Quantity ID** | The settlement quantity |
| **Settlement Price ID** | The settlement price |
| **Application rule** | The rule that produced the amount |
| **Amount** | The settlement amount |
| **Currency** | The currency |
| **Sign** | Positive (revenue to participant) / Negative (cost to participant) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 9.8 Settlement on the Commitment Path

On the commitment path, settlement quantities are determined from the commitment quantity and the recognized delivery, with deviation settled per the applicable rule. The settlement amount is computed per §9.7.

### 9.9 Settlement on the Null-Commitment Path

On the null-commitment path, settlement quantities are determined from the **recognized delivery quantity** and the **applicable price or tariff**.

- Where the mechanism is a market price (e.g., real-time energy), the recognized delivery quantity is settled at the market price.
- Where the mechanism is a tariff (e.g., BTM tariff), the recognized delivery quantity is settled at the tariff, sometimes against a baseline.
- Where the mechanism is baseline-based (e.g., demand response), the settlement quantity is the deviation from the baseline, settled at the applicable price.

The settlement amount is computed per §9.7.

### 9.10 Settlement on the BTM Path

On the BTM path, settlement quantities are determined from the **recognized delivery quantity** and the **baseline** (Parte 5 §5.2), settled at the applicable tariff or price. The settlement amount is computed per §9.7.

---

## 10. Adjustments and Penalties

### 10.1 Adjustment

An **adjustment** is a market-defined modification to a settlement quantity, settlement price, or settlement amount after the initial determination.

Adjustments include:

- re-settlement following measurement corrections;
- adjustments for curtailment or network constraints;
- adjustments for market-operator directives;
- adjustments for market-wide events.

### 10.2 Adjustment Record Structure

| Field | Description |
| --- | --- |
| **Adjustment ID** | Unique identifier |
| **Settlement Quantity ID** | The settlement quantity affected |
| **Settlement Amount ID** | The settlement amount affected, where applicable |
| **Adjustment type** | Re-settlement / Curtailment / Directive / Market event / Other |
| **Adjustment quantity** | The adjustment quantity |
| **Adjustment amount** | The adjustment amount, where applicable |
| **Unit** | The unit |
| **Adjustment reason** | The reason |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 10.3 Penalty

A **penalty** is a market-defined consequence of non-compliance or under-performance.

Penalties are **settlement inputs** owned by Parte 5. Their economic valuation is Financial Engineering's.

### 10.4 Penalty Record Structure

| Field | Description |
| --- | --- |
| **Penalty ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` **or** `Product-Mechanism ID + settlement window` |
| **Compliance ID** | The compliance determination |
| **Penalty type** | Availability / Accuracy / Delivery / Response / Over-delivery / Other |
| **Penalty rule** | The rule that determines the penalty |
| **Penalty quantity** | The penalty quantity (where quantity-based) |
| **Penalty amount** | The penalty amount, where applicable |
| **Unit** | The unit |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 10.5 Penalty vs. Deviation

**Deviation** is the measured difference between delivery and commitment (or baseline).

**Penalty** is the market-defined consequence of the deviation or non-compliance.

Deviation does not automatically produce a penalty. The penalty rule is market-defined and owned by Parte 5.

### 10.6 Simulated Settlement

Where the project simulates participation (the energy pilot, simulated market participation), the settlement quantities **and settlement amounts** are produced by the simulation.

**Simulation rule (normative):** The simulation uses the **same settlement rules** as the real settlement, applied to **simulated inputs**:

- simulated awards and commitments (governed by P4-O17, the Award Simulation Rule);
- simulated delivery (produced by Operational/Optimization);
- simulated prices (from Forecasting or historical data, per §9.6).

**No separate settlement logic is defined for simulation.** The settlement quantity, settlement price, and settlement amount records are produced identically, with simulated inputs marked in the `Price source` field (§9.6) and the delivery record's `Measurement source` field (§4.3).

Where the simulation requires a deviation from the real settlement rules (e.g., simplified imbalance, no re-settlement), the deviation shall be justified and recorded as an explicit simulation parameter.

---

## 11. Parte 5 Assessment Record

### 11.1 Purpose

The **Parte 5 Assessment Record** is the record linked to each Parte 4 Commitment Instance — **or, on the null-commitment path, to a Product-Mechanism plus settlement window** — that holds the Parte 5-owned assessment data: recognized delivery quantity, satisfaction status, compliance state, settlement quantities, settlement prices, and settlement amounts.

### 11.2 Assessment Record Structure

| Field | Description |
| --- | --- |
| **Assessment ID** | Unique identifier |
| **Linkage** | **Either** `Commitment Instance ID` (commitment path) **or** `Product-Mechanism ID + settlement window` (null-commitment path) |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Delivery ID** | The delivery record |
| **Performance ID** | The performance measurement |
| **Compliance ID** | The compliance determination |
| **Settlement Quantity IDs** | The settlement quantities |
| **Settlement Price IDs** | The settlement prices |
| **Settlement Amount IDs** | The settlement amounts |
| **Adjustment IDs** | The adjustments |
| **Penalty IDs** | The penalties |
| **Parte 5 state** | Satisfied / Breached (Parte 5-owned states of the Parte 4 instance; empty on the null-commitment path) |
| **Assessment date** | When the assessment was performed |
| **Owner** | Parte 5 |
| **Uncertainty reference** | Link to **§14** |

### 11.3 Parte 5 State Ownership

Parte 5 owns the **Satisfied** and **Breached** states of the Parte 4 Commitment Instance (Parte 4 §8.3). Parte 4 owns **Pending**, **Active**, and **Cancelled**.

On the **null-commitment path**, no Parte 4 instance exists, so the Parte 5 state field is empty; the assessment record links to the `Product-Mechanism ID + settlement window` directly.

### 11.4 Assessment Record Consumers

The Parte 5 Assessment Record is consumed by:

- **Financial Engineering** — for economic valuation;
- **Operational/Optimization Engineering** — for feedback on delivery performance;
- **Forecasting Engineering** — for delivery and settlement uncertainty;
- **Software Engineering** — for implementation.

---

## 12. Interfaces

### 12.1 Parte 1 — Market Domain and Conventions

**Consumes:** market semantic model; market environment vs. participation branch; commitment vs. dispatch vs. delivery distinction; temporal framework; time relationships; evidence model; uncertainty ownership; semantic ownership.

**Provides:** delivery- and settlement-specific feedback; proposed changes via change control.

### 12.2 Parte 2 — Transversal Market Values

**Consumes:** temporal framework instance; resolution mapping method.

**Provides:** feedback on transversal timing values encountered during delivery and settlement definition.

### 12.3 Parte 3 — Market Products and Participation

**Consumes:** product identifiers; Product-Mechanism records; eligibility time dimension; temporal requirements.

**Provides:** delivery- and settlement-specific references for the Product-Mechanism sheet.

### 12.4 Parte 4 — Market Rules, Signals, Commitments and Constraints

**Consumes:** commitment definitions; commitment instances (formation data); delivery-obligation definitions; signal definitions and timing; operational obligations; constraint definitions relevant to delivery; baseline/counterfactual trigger conditions.

**Provides:** Parte 5 assessment records linked to Commitment Instances **or to `Product-Mechanism + settlement window` on the null-commitment path**; satisfaction status; settlement definitions referenced from commitment definitions; delivery measurement; delivery scoring.

**Direct reference:** Parte 5 takes **delivery obligation** identifiers directly from **Parte 4**, not relayed through Parte 3.

### 12.5 Operational / Optimization Engineering

**Consumes:** delivery requirements (obligation side, by reference to Parte 4); performance feedback.

**Provides:** **raw delivered quantities** (metered or simulated); operating trajectories; Asset Dispatch Decisions.

**Semantic boundary:** *Market defines the commitment and its requirements; Operational/Optimization defines the Asset Dispatch Decision and the raw delivered quantities. Parte 5 defines how delivery is recognized and settled.*

### 12.6 Forecasting Engineering

**Provides:** delivery and settlement uncertainty definitions, where they affect forecasting.

**Consumes:** forecasts of market variables.

**Semantic boundary:** *Real settlement uses actual prices as observed. In simulation, prices come from Forecasting or from historical data.*

### 12.7 Financial Engineering

**Provides:** settlement quantities; settlement prices; **settlement amounts**; recognized delivery quantities; penalties; adjustments; other settlement outputs.

**Consumes:** — *(Financial Engineering determines the economic valuation independently.)*

**Semantic boundary:** *Parte 5 determines settlement quantities, settlement price semantics, and settlement amounts. Financial Engineering determines the economic valuation of those amounts (discounting, tax, NPV, IRR).*

### 12.8 Software Engineering

**Provides:** delivery record structure; baseline record structure; performance measurement structure; delivery scoring structure; deviation and compliance record structures; settlement quantity, price, and amount structures; adjustment and penalty structures; Parte 5 assessment record structure; market output structure.

### 12.9 Network Engineering

**Network Engineering** is defined in the Introduction (v1.3). Parte 5 references it where delivery assessment depends on network-side evidence (e.g., curtailment events, interconnection constraints affecting delivery).

**Pending Introduction v1.3:** Until Introduction v1.3 is issued, Parte 5 refers to the Network Operator role and BESS Engineering for network-side delivery evidence.

---

## 13. Market Outputs

### 13.1 Market Output Definition

A **market output** is a quantity, price, amount, or status provided by Parte 5 to downstream engineering.

Market outputs are the **contract** between Market Engineering and Financial Engineering, Forecasting Engineering, and Software Engineering.

### 13.2 Market Output Categories

| Category | Description | Consumer |
| --- | --- | --- |
| **Settlement quantities** | Recognized quantities used as settlement inputs | Financial Engineering |
| **Settlement prices** | Prices applied, with source (actual / forecast / historical) | Financial Engineering |
| **Settlement amounts** | Currency amounts produced by applying settlement price semantics to settlement quantities | Financial Engineering |
| **Recognized delivery quantities** | Delivered quantities after measurement rules | Financial Engineering, Operational/Optimization |
| **Penalties** | Penalty quantities and amounts | Financial Engineering |
| **Adjustments** | Adjustment quantities and amounts | Financial Engineering |
| **Compliance states** | Satisfied / Partially satisfied / Not satisfied / Exceeded | Operational/Optimization, Financial Engineering |
| **Performance scores** | Delivery scores | Operational/Optimization, Financial Engineering |
| **Deviation** | Measured deviation | Operational/Optimization, Financial Engineering |
| **Baselines** | Reference quantities | Financial Engineering, Forecasting Engineering |
| **Assessment records** | Parte 5 assessment records | Financial Engineering, Software Engineering |

### 13.3 Market Output Record Structure

| Field | Description |
| --- | --- |
| **Output ID** | Unique identifier |
| **Output type** | Settlement quantity / Settlement price / Settlement amount / Recognized delivery quantity / Penalty / Adjustment / Compliance state / Performance score / Deviation / Baseline / Assessment |
| **Source record** | The Parte 5 record that produced the output |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Linkage** | **Either** `Commitment Instance ID` **or** `Product-Mechanism ID + settlement window` |
| **Period** | The period the output applies to |
| **Quantity / Price / Amount / State** | The value |
| **Unit / Currency** | The unit or currency |
| **Owner** | Parte 5 |

### 13.4 Market Output vs. Financial Consequence

Market outputs include **quantities, prices, and settlement amounts**. **Financial consequences** — revenue, cost, NPV, IRR — are determined by **Financial Engineering** from these outputs.

Parte 5 does not perform financial valuation.

---

## 14. Uncertainty Ownership

Per Parte 1 §18, Parte 5 owns:

- **delivery uncertainty**;
- **performance measurement uncertainty**;
- **baseline and counterfactual uncertainty**;
- **settlement uncertainty**;
- **adjustment and penalty uncertainty**.

Uncertainty types shall not be conflated (Parte 1 §18).

### 14.1 Uncertainty Record Structure

| Field | Description |
| --- | --- |
| **Uncertainty ID** | Unique identifier |
| **Type** | Delivery / Performance / Baseline / Settlement / Adjustment / Penalty |
| **Description** | The uncertainty |
| **Affected records** | Which delivery, performance, baseline, or settlement records are affected |
| **Source** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Impact** | Qualitative scale (Low / Medium / High) |
| **Likelihood** | Qualitative scale (Low / Medium / High) |
| **Mitigation** | How the uncertainty is mitigated |
| **Owning Part** | Parte 5 |

### 14.2 Long-Horizon Uncertainty

Regulatory and market-rule changes over the asset life are **long-horizon uncertainty** (Parte 1 §18). Parte 5 shall record such changes with effective dates on the evidence records (Parte 1 §16.2).

### 14.3 Uncertainty vs. Forecast Uncertainty

Settlement-rule uncertainty (Parte 5) is **distinct from** forecast uncertainty (Forecasting Engineering). An uncertain forecast does not imply an uncertain settlement rule (Parte 1 §18).

---

## 15. Parte 5 Open Items

| ID | Open item | Required outcome | Owner | Priority | Blocking dependency | Target date |
| --- | --- | --- | --- | --- | --- | --- |
| P5-O01 | Delivery definitions | Delivery defined per Product-Mechanism | Parte 5 Lead | Critical | Depends on Parte 4 freeze | TBD |
| P5-O02 | Authoritative delivery quantity | Authoritative delivery quantity declared per Product-Mechanism | Parte 5 Lead | High | Depends on P5-O01 | TBD |
| P5-O03 | Baselines | Baselines defined per applicable Product-Mechanism | Parte 5 Lead | High | Depends on P5-O01 | TBD |
| P5-O04 | Performance measurement | Performance measurement defined per Product-Mechanism | Parte 5 Lead | High | Depends on P5-O01 | TBD |
| P5-O05 | Delivery scoring | Delivery scoring rules and thresholds defined | Parte 5 Lead | High | Depends on P5-O04 | TBD |
| P5-O06 | Deviation and compliance | Deviation and compliance determination defined; compliance-to-instance mapping applied | Parte 5 Lead | High | Depends on P5-O04 | TBD |
| P5-O07 | Settlement quantities | Settlement quantities defined per Product-Mechanism | Parte 5 Lead | Critical | Depends on P5-O01, P5-O04 | TBD |
| P5-O08 | Authoritative settlement quantity | Authoritative settlement quantity declared per Product-Mechanism | Parte 5 Lead | Critical | Depends on P5-O07 | TBD |
| P5-O09 | Settlement price semantics | Settlement price semantics defined per Product-Mechanism, including real vs. simulated sources | Parte 5 Lead | High | Depends on P5-O07 | TBD |
| P5-O10 | Settlement amounts | Settlement amount rule defined per Product-Mechanism; currency handling defined | Parte 5 Lead | Critical | Depends on P5-O07, P5-O09 | TBD |
| P5-O11 | Adjustments and penalties | Adjustment and penalty rules defined per Product-Mechanism | Parte 5 Lead | High | Depends on P5-O06 | TBD |
| P5-O12 | Parte 5 assessment records | Assessment record structure defined and integrated with Parte 4 instances and null-path linkages | Parte 5 Lead | High | Depends on P5-O07 | TBD |
| P5-O13 | Market outputs | Market output structure defined | Parte 5 Lead | High | Depends on P5-O07, P5-O09, P5-O10, P5-O11 | TBD |
| **P5-O14** | **Simulation confirmation** | **Confirm settlement rules apply unchanged to simulated inputs. Justify any deviation.** | **Parte 5 Lead + Op/Opt Lead** | **Critical** | **Depends on P4-O17; blocks energy pilot** | **TBD** |
| P5-O15 | Uncertainty records | Uncertainty records defined per delivery, performance, baseline, and settlement | Parte 5 Lead | Medium | Depends on P5-O01–P5-O11 | TBD |
| P5-O16 | Network-side delivery evidence | Network-side delivery evidence interface established (pending Introduction v1.3) | Parte 5 Lead + Network Engineering | Medium | Depends on Introduction v1.3 | TBD |
| P5-O17 | Null-path linkage confirmation | Confirm Parte 4 does not define null instances; Parte 5 keys on `Product-Mechanism + settlement window` on the null-commitment path | Parte 5 Lead + Parte 4 Lead | High | Depends on Parte 4 freeze | TBD |
| **P5-O18** | **Settlement statement ownership** | **Confirm Parte 5 computes the settlement amount. Define currency handling and the settlement amount record.** | **Parte 5 Lead + Financial Engineering** | **Critical** | **Blocks energy pilot** | **TBD** |

**Critical path:** P5-O01 (delivery definitions) blocks most items. P5-O07 (settlement quantities), P5-O08 (authoritative settlement quantity), and P5-O10 (settlement amounts) are critical for Financial Engineering. **P5-O14 (simulation confirmation) and P5-O18 (settlement statement ownership) are critical for the energy pilot.**

---

## 16. Parte 5 Validation Criteria

Each validation category specifies **method**, **reference case**, **reviewer**, and **pass/fail condition**.

### Delivery Validation

- **Method:** Comparison of each delivery definition against authoritative market documentation.
- **Reference case:** Market documentation for the applicable jurisdiction; Parte 4 commitment definitions.
- **Reviewer:** Parte 5 Lead + independent reviewer.
- **Pass condition:** Each delivery is correctly defined per Product-Mechanism; the commitment path and null-commitment path are distinguished; the authoritative delivery quantity is declared; **the raw vs. recognized distinction is preserved**.

### Baseline Validation

- **Method:** Comparison of each baseline definition against market documentation and site data.
- **Reference case:** Market documentation; site/interconnection capability (pending P1-O14).
- **Reviewer:** Parte 5 Lead + Network Engineering (where network-side data is used).
- **Pass condition:** Each baseline is correctly typed, calculated, and sourced; the baseline is distinguished from the commitment.

### Performance Validation

- **Method:** Review of each performance measurement against the commitment or baseline.
- **Reference case:** Parte 4 commitment definitions; Parte 5 baseline definitions.
- **Reviewer:** Parte 5 Lead + Operational/Optimization Engineering.
- **Pass condition:** Each performance measurement correctly compares recognized delivery to the commitment or baseline; the null-commitment path and BTM path are correctly handled; performance measurement does not apply where no baseline or commitment exists; **the environment-vs-branch rule is preserved**.

### Delivery Scoring Validation

- **Method:** Review of each delivery scoring rule and threshold.
- **Reference case:** Market documentation.
- **Reviewer:** Parte 5 Lead.
- **Pass condition:** Each scoring rule is correctly defined; thresholds are owned by Parte 5; scores are correctly mapped to settlement inputs.

### Deviation and Compliance Validation

- **Method:** Review of deviation and compliance determination.
- **Reference case:** Market documentation.
- **Reviewer:** Parte 5 Lead.
- **Pass condition:** Deviation is correctly measured; compliance states are correctly determined; **the compliance-to-instance mapping is correct**; the Parte 5-owned Satisfied and Breached states are correctly linked to Parte 4 instances; the over-delivery rule is applied.

### Settlement Validation

- **Method:** Review of each settlement quantity, settlement price semantics, settlement amount, and the authoritative settlement quantity.
- **Reference case:** Market documentation; Parte 4 commitment definitions; Parte 5 delivery and performance definitions.
- **Reviewer:** Parte 5 Lead + independent reviewer + Financial Engineering.
- **Pass condition:** Each settlement quantity is correctly derived; the settlement price semantics are correctly defined, including real vs. simulated price sources; **the settlement amount is correctly computed**; the authoritative settlement quantity is declared per Product-Mechanism; settlement is correctly distinguished from financial valuation.

### Adjustment and Penalty Validation

- **Method:** Review of adjustment and penalty rules.
- **Reference case:** Market documentation.
- **Reviewer:** Parte 5 Lead.
- **Pass condition:** Each adjustment and penalty rule is correctly defined; the distinction between deviation and penalty is preserved; over-delivery penalties are correctly handled.

### Market Output Validation

- **Method:** Review of the market output structure against Financial Engineering requirements.
- **Reference case:** Financial Engineering interface definition.
- **Reviewer:** Parte 5 Lead + Financial Engineering.
- **Pass condition:** Market outputs include all quantities, prices, **amounts**, penalties, and adjustments required by Financial Engineering; outputs are distinct from financial consequences.

### Assessment Record Validation

- **Method:** Review of the Parte 5 assessment record structure and its integration with Parte 4 instances **and null-path linkages**.
- **Reference case:** Parte 4 commitment instance structure; Parte 5 §4.5 null-path linkage rule.
- **Reviewer:** Parte 5 Lead + Parte 4 Lead.
- **Pass condition:** Each assessment record links correctly to its Parte 4 instance **or to a `Product-Mechanism + settlement window` on the null-commitment path**; Parte 5-owned states are correctly determined; Parte 4-owned states are not redefined.

### Boundary Validation

- **Method:** Interface review with Parte 1, Parte 2, Parte 3, Parte 4, Operational/Optimization, Forecasting, Financial, Software, and Network Engineering.
- **Reference case:** Interface definitions in §12.
- **Reviewer:** Cross-domain review board.
- **Pass condition:** No responsibility is claimed by two domains; no responsibility is unowned; Parte 5 does not restate Parte 4 definitions; Parte 5 does not perform financial valuation; **raw vs. recognized delivery is preserved**; **the environment-vs-branch distinction is preserved**.

### Evidence Validation

- **Method:** Traceability audit (Parte 1 §16.4).
- **Reference case:** Critical-path evidence set.
- **Reviewer:** Independent evidence reviewer.
- **Pass condition:** Every material delivery, baseline, performance, scoring, deviation, compliance, settlement, adjustment, and penalty record has a complete Statement Record and at least one complete Source Record. Tier-1 statements have at least one Verified Rule source.

### Consistency Validation

- **Method:** Symbol, identifier, and convention audit. **Verify all internal cross-references resolve to the correct section.**
- **Reference case:** BESS Engineering Part 1 (pinned version), Parte 1 v1.3, Parte 2 v1.0, Parte 3 v1.3, Parte 4 v1.4, Introduction v1.2 (and v1.3 once issued).
- **Reviewer:** BESS Engineering + Parte 5 Lead.
- **Pass condition:** No conflicting symbols, identifiers, units, state conventions, or temporal conventions; no Parte 4, Parte 3, or Parte 1 concept is redefined in Parte 5; **all uncertainty references resolve to §14**; **all internal cross-references resolve correctly**; no Parte 3 capability mapping is consumed by Parte 5.

---

## 17. Parte 5 Acceptance Criteria

Parte 5 is ready for engineering freeze when:

- delivery is defined per Product-Mechanism, with commitment-path and null-commitment-path semantics distinguished;
- the **raw vs. recognized delivery quantity** distinction is preserved;
- the authoritative delivery quantity is declared per Product-Mechanism;
- baselines are defined per applicable Product-Mechanism, with baseline types, calculation methods, and data sources;
- baselines are distinguished from commitments;
- performance measurement is defined per Product-Mechanism, with commitment-path, null-commitment-path, and BTM-path semantics;
- performance measurement applies only where a commitment or baseline exists;
- the **environment-vs-branch** distinction is preserved: environment determines baseline assessment; branch determines commitment semantics;
- delivery scoring rules and thresholds are defined, with thresholds owned by Parte 5;
- deviation is measured and recorded;
- compliance is determined, with states defined;
- **the compliance-to-instance state mapping is defined**;
- Parte 5-owned Satisfied and Breached states are correctly linked to Parte 4 instances; **null-commitment path assessments link to `Product-Mechanism + settlement window`**;
- settlement quantities are defined per Product-Mechanism;
- the authoritative settlement quantity is declared per Product-Mechanism;
- settlement price semantics are defined per Product-Mechanism, including real vs. simulated price sources;
- **settlement amounts are computed per Product-Mechanism; currency handling is defined**;
- settlement is correctly distinguished from financial valuation;
- adjustments and penalties are defined per Product-Mechanism;
- the distinction between deviation and penalty is preserved;
- over-delivery penalties are correctly handled;
- Parte 5 assessment records are defined and integrated with Parte 4 instances and null-path linkages;
- market outputs are defined and include all quantities, prices, **amounts**, penalties, and adjustments required by Financial Engineering;
- market outputs are distinct from financial consequences;
- uncertainty records are defined per delivery, performance, baseline, and settlement;
- **P5-O14 (simulation confirmation) is resolved**;
- **P5-O18 (settlement statement ownership) is resolved**;
- P1-O14 is resolved, where baselines depend on site/interconnection capability;
- Introduction v1.3 is issued, where network-side delivery evidence is required;
- all required market symbols are registered through BESS Engineering Part 1;
- no independent market symbol authority exists;
- interfaces with Parte 1, Parte 2, Parte 3, Parte 4, Operational/Optimization, Forecasting, Financial, Software, and Network Engineering are defined;
- open items have been resolved or explicitly accepted as controlled assumptions, with owners, priorities, dependencies, and dispositions recorded;
- validation criteria have been satisfied with documented method, reference case, reviewer, and pass/fail result.

---

## 18. Parte 5 Maturity

Parte 5 follows the project-wide maturity ladder:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

Current status:

- **Semantic Definition — established (framework)**
- **Internal Consistency — ready for validation** *(revised from v1.1; the null-path linkage, the compliance mapping, the settlement amount, and the environment-vs-branch distinction are now explicit)*
- **External Evidence — pending Parte 4 freeze and market documentation**
- **Engineering Validation — pending**
- **Frozen — No**

**Status note on sequencing.** Parte 5 is drafted after Parte 4 freezes. Parte 4 is out of sequence by its own rules (Parte 4 should be drafted after Parte 3 freezes, which requires Parte 2). **The next engineering activity is Parte 2, not Parte 5.**

**Status note on structural gaps.** Five structural items are pending:

- **P1-O14** — site/interconnection capability, including value ownership.
- **Introduction v1.3** — Network Engineering as an engineering domain.
- **P4-O17** — award simulation rule. Required before the energy pilot.
- **P5-O17** — null-path linkage confirmation with Parte 4.
- **P5-O18** — settlement statement ownership.

**Status note on diminishing returns.** The Parte 5 framework is complete as of v1.2. The remaining work is populating delivery, baseline, performance, scoring, deviation, compliance, settlement, adjustment, and penalty definitions from authoritative market documentation. Further abstract iteration on the framework will add little. The next real gain is **External Evidence**, which is blocked on Parte 2 and Parte 4 freeze.

---

## 19. Output of Parte 5

The final output of Parte 5 shall be a controlled **Market Delivery, Performance and Settlement Specification** containing:

1. delivery definitions per Product-Mechanism, with commitment-path and null-commitment-path semantics;
2. raw vs. recognized delivery quantity distinction;
3. authoritative delivery quantity per Product-Mechanism;
4. baselines and counterfactuals per applicable Product-Mechanism;
5. performance measurement per Product-Mechanism;
6. delivery scoring rules and thresholds;
7. deviation measurement;
8. compliance determination, with the compliance-to-instance state mapping;
9. settlement quantities per Product-Mechanism;
10. authoritative settlement quantity per Product-Mechanism;
11. settlement price semantics per Product-Mechanism, including real vs. simulated price sources;
12. **settlement amounts per Product-Mechanism, with currency handling**;
13. adjustments and penalties per Product-Mechanism, including over-delivery penalties;
14. Parte 5 assessment record structure and integration with Parte 4 instances and null-path linkages;
15. market outputs and their structure;
16. uncertainty records per delivery, performance, baseline, and settlement;
17. simulation confirmation (P5-O14);
18. settlement statement ownership confirmation (P5-O18);
19. null-path linkage confirmation (P5-O17);
20. registered market symbols through BESS Part 1;
21. resolved assumptions and open-item disposition.

This output becomes the formal delivery, performance, and settlement foundation for:

**Financial Engineering, Operational/Optimization Engineering, Forecasting Engineering, Software Engineering, and BESS Engineering (via change control)**

which will then answer the next engineering questions in their respective domains:

> **Financial Engineering:** What is the economic value of the market outcomes determined by Parte 5?
>
> **Operational/Optimization:** How should the Asset Dispatch Decision be determined to satisfy commitments and maximize performance?
>
> **Forecasting:** How should market variables be predicted to support participation and settlement?
>
> **Software:** How should the market model be implemented?
>
> **BESS Engineering:** What physical requirements does delivery assessment reveal?

---

## Appendix A — Settlement Path Summary

The settlement path depends on **two independent axes**:

- **Participation branch** (Parte 1 §8) — determines **commitment semantics**;
- **Market environment** (Parte 1 §7) — determines **whether delivery is assessed against a baseline**.

| | **Branch 1** (bid-based) | **Branch 2** (non-bid commitment) | **Branch 3** (null commitment / price-responsive) |
| --- | --- | --- | --- |
| **Wholesale environment** | Commitment Instance by award. Recognized delivery vs. commitment. Settlement from commitment, delivery, deviation. Settlement amount = quantity × price. | Commitment Instance by enrollment (long-lived) or instruction (short-lived). Recognized delivery vs. commitment. Settlement from commitment, delivery, deviation. Settlement amount = quantity × price. | No commitment. Recognized (metered) delivery. Performance measurement only if a self-declared position exists. Settlement at market price. Settlement amount = quantity × price. |
| **BTM environment** | Commitment Instance by award. Recognized delivery vs. commitment **and** vs. baseline. Settlement at tariff, often against baseline. Settlement amount = quantity × tariff. | Commitment Instance by enrollment. Recognized delivery vs. commitment **and** vs. baseline. Settlement at tariff, often against baseline. Settlement amount = quantity × tariff. | No commitment. Recognized (metered) delivery. Performance measurement vs. baseline. Settlement at tariff, against baseline. Settlement amount = (quantity − baseline) × tariff. |

**On the null-commitment path**, the Parte 5 assessment record, deviation record, and penalty record link to `Product-Mechanism ID + settlement window` directly, because no Commitment Instance exists.

This appendix is **informative**. The normative definitions are in §4–§10.

---

*End of Parte 5 — Delivery, Performance and Settlement (v1.2)*