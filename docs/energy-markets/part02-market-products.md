# M2 — Market Products and Participation

**Version:** 1.2 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Parent Document:** Market Engineering Model — Introduction Document (v1.2)
**Upstream Dependencies:**
- M1 — Market Domain and Conventions (v1.2), specifically §8, §9, §11, §16, §19
- BESS Engineering Part 1 — Fundamentals and Conventions (pinned per M1-O13)
- M3a — Transversal Market Values (early baseline; see §2.3)
- M3b — Full Rules, Signals, Commitments and Constraints

**Document ID:** ME-M2-001 *(stable across versions)*

---

## Revision History

| Version | Date | Status | Change |
| --- | --- | --- | --- |
| 1.0 | 2026-09-22 | Development Draft | Initial M2 baseline. |
| 1.1 | 2026-09-22 | Development Draft | Introduced the Transversal Market Values early baseline; made the Product ↔ Mechanism relation many-to-many; removed strategies from the candidate list; added the static-vs-instantaneous rule; moved the eligibility time dimension to the assessment result; defined the identifier scheme; closed eligibility and qualification gaps. |
| 1.2 | 2026-09-22 | Development Draft | Removed the "transversal product-specific" owner category and the residual full-M3 dependency from the eligibility path. Rekeyed path-dependent records to Product-Mechanism. Defined qualification states, aggregation, and validity. Moved the M3 split into Introduction v1.2 and stated the revised freeze order. Consolidated degradation to a single reference. Added the aggregate-validity rule. Moved market-level temporal attributes to the framework reference. Clarified ID uniqueness. Retied the pilot to a single in-scope product. Aligned §5.1 examples with the candidate list. |

**Change control note:** The product definition template and the "reference, do not redefine" rule are owned by the **Introduction Document v1.2**. The **M3 split into M3a (Transversal Market Values) and M3b (Full Rules)** is established by **Introduction v1.2**, not by M2. M2 references it. Where M2 and the Introduction differ, the Introduction governs.

---

## 1. Purpose and Scope

M2 establishes the **product-level and participation-level semantic foundation** for Market Engineering.

Its purpose is to define:

- **which market products** the BESS may participate in;
- **the participation mechanisms** through which each product is accessed;
- **the eligibility conditions** a resource must satisfy to participate;
- **the qualification requirements** that must be demonstrated before or during participation;
- **the mapping** from each product's requirements to the physical capabilities of the BESS;
- **the product-specific temporal requirements** that constrain participation.

M2 does **not** define:

- the detailed operational rules governing participation (M3b);
- the detailed market signals and their timing (M3b);
- the commitment semantics and operational obligations (M3b);
- the delivery definition and performance measurement (M4);
- the settlement mechanism and settlement quantities (M4);
- the physical BESS model itself (BESS Engineering).

M2 defines **what the BESS can participate in, under what conditions, and with what physical requirements** — and references M3b and M4 for how participation is governed and settled.

The primary question of M2 is:

> **Which specific products and participation mechanisms exist within the defined market environment, and under what eligibility and qualification conditions can the BESS participate?**

---

## 2. Engineering Boundary

### 2.1 Position in the Part Chain

```text
       M1
Market Domain & Conventions
        │
        ▼
      M3a
Transversal Market Values
(early baseline)
        │
        ▼
       M2
Market Products & Participation
        │
        ▼
      M3b
Full Rules, Signals,
Commitments & Constraints
        │
        ▼
       M4
Delivery, Performance & Settlement
```

**Freeze order (revised):** **M1 → M3a → M2 → M3b → M4.**

M3a is frozen before M2 because M2 references transversal market values (gate closure conventions, market-wide registration, market-wide timing) that it cannot own. M3b is frozen after M2 because it consumes M2's product catalogue and Product-Mechanism relations.

This is a **document-construction dependency**, not the market lifecycle.

### 2.2 Consumes and Provides

**M2 consumes from M1:**

- market environment definition and scope (M1 §6, §7);
- participant-role model and Market Party model (M1 §5);
- market semantic model, three participation branches (M1 §8);
- market temporal mapping framework (M1 §11);
- evidence model (M1 §16);
- semantic ownership table (M1 §19);
- price-influence assumption (M1 §15).

**M2 consumes from M3a:**

- market-wide gate closure conventions;
- market-wide registration requirements;
- market-wide timing conventions;
- market-wide data formats and telemetry requirements;
- market-wide minimum participation sizes, where transversal;
- market-wide aggregation rules, where transversal.

**M2 provides to M3b:**

- the product catalogue with product identifiers;
- the Product-Mechanism records;
- the eligibility conditions per Product-Mechanism;
- the qualification requirements per Product-Mechanism;
- the product-specific temporal requirements;
- the product-to-BESS capability mappings;
- the product-specific risks and uncertainties.

**M2 does not create an independent symbol registry.** Market-specific **symbols** are registered in the **BESS Engineering Part 1 master symbol registry** (M1 §20). **Identifiers** are governed by §4.5.

### 2.3 Cycle-Breaking: Transversal Market Values Early Baseline

M2 requires **transversal market values** that M3 owns. Referencing them from the full M3 would create an M2 → M3 → M2 loop.

To break the loop, **Introduction v1.2** splits M3 into two layers:

| Layer | Contents | Drafted | Owner |
| --- | --- | --- | --- |
| **M3a — Transversal Market Values** | Market-wide values M2 needs to evaluate eligibility and participation. No product-specific content. | **Before M2 freeze.** | M3 Lead (role defined in Introduction v1.2) |
| **M3b — Full Rules, Signals, Commitments and Constraints** | Product-specific rules, signals, commitments, operational constraints, stacking. | **After M2 freeze.** | M3 Lead |

**What belongs in M3a:** market-wide gate closure conventions; market-wide registration requirements; market-wide timing conventions; market-wide data formats and telemetry requirements; market-wide minimum participation sizes and aggregation rules, where transversal.

**What belongs in M3b:** product-specific signals, commitments, operational constraints, stacking/coexistence rules, and any rule value that depends on a product or a Product-Mechanism.

**What belongs in neither (it belongs to M2):** product-specific eligibility thresholds, qualification test parameters, product-specific temporal values, capability mappings.

**The residual full-M3 dependency is removed.** M2's eligibility path references **M1 + M3a + M2 itself + BESS Engineering**. It does not reference M3b. This is stated as a normative property of the boundary:

> **Eligibility-path rule.** No eligibility condition shall depend on a value owned by M3b. If an eligibility condition appears to require an M3b value, either the condition is product-specific and belongs to M2, or the value is transversal and belongs to M3a. The "transversal product-specific" case does not exist: a value is either specific to one Product-Mechanism (M2) or shared across products (M3a).

---

## 3. Intent

### 3.1 WHAT

M2 represents the product and participation layer as a structured catalogue containing:

- **Market products** — standardized services or commodities;
- **Participation mechanisms** — the ways a participant accesses a product, modelled via **Product-Mechanism records**;
- **Eligibility conditions** — requirements a resource must satisfy;
- **Qualification requirements** — demonstrations required before or during participation;
- **Capability mappings** — correspondence between product requirements and BESS physical capabilities;
- **Product-specific temporal requirements** — periods specific to each Product-Mechanism;
- **Product-specific risks and uncertainties**.

### 3.2 WHY

The purpose is to prevent downstream engineering from treating market participation as a single undifferentiated activity, and from conflating **products** with **strategies**.

**Product ≠ Strategy.** Arbitrage, peak shaving, and demand charge management are **dispatch strategies** owned by Operational/Optimization Engineering. They are represented as applications of one or more products, not as catalogue entries.

**Product ≠ Access Path.** A product may be accessed through more than one mechanism. The access path determines gate closure, temporal structure, often eligibility, and settlement. The **Product-Mechanism record** is the unit that carries these path-dependent properties.

### 3.3 FOR WHOM

M2 provides the product and participation foundation for M3a (references), M3b (consumes the catalogue), M4 (delivery and settlement per Product-Mechanism), BESS Engineering (capability requirements), Forecasting Engineering (signal semantics via M3b), Operational/Optimization Engineering (eligibility, mechanisms, temporal requirements), Financial Engineering (asset-life valuation via the eligibility time dimension), and Software Engineering (catalogue, relation, eligibility logic).

---

## 4. Product Taxonomy and Catalogue

### 4.1 Taxonomy Axes

| Axis | Values | Source |
| --- | --- | --- |
| **Market environment** | Wholesale / Behind-the-meter / Both | M1 §7 |
| **Product class** | Energy / Capacity / Ancillary service / Flexibility / Tariff-based / Other | M1 §6, §7 |
| **Direction** | Upward / Downward / Symmetric | Market-specific |
| **Time scale** | Seconds / Minutes / Hours / Days / Months / Years | Market-specific |
| **Settlement basis** | **Reference** to M4 settlement identifier | M4 |

Participation mechanism and commitment type are **not** taxonomy axes. They belong to the **Product-Mechanism record** (§5), because they vary by access path.

### 4.2 Product Catalogue Structure

Each product shall have:

| Field | Description |
| --- | --- |
| **Product ID** | Unique identifier, per §4.5 |
| **Product name** | Market-recognized name |
| **Taxonomy classification** | Values along each axis in §4.1 |
| **Market environment** | Wholesale / BTM / Both |
| **Status** | Candidate / In scope / Out of scope / Deferred / Retired (§4.4) |
| **Product definition** | Short definition (§6) |
| **Market purpose** | Why the market defines the product (§6) |
| **Mechanisms** | Links to Product-Mechanism records (§5) |
| **Evidence reference** | Linked Evidence Statement IDs (M1 §16.3) |
| **Risk and uncertainty reference** | Links to §12 |

**Path-dependent fields are not on the product.** Eligibility, qualification, capability mapping, temporal requirements, settlement references, and mechanism attributes live on the **Product-Mechanism record** (§5.3).

### 4.3 Candidate Product Universe

Established from **M1-O05**. Until resolved, candidates carry status **Candidate**.

**Wholesale candidates:** Energy, Wholesale capacity, Frequency containment reserve, Frequency restoration reserve (up and down), Replacement reserve (up and down), Fast frequency response, Voltage support / reactive power, Black start, Congestion management / flexibility.

**BTM candidates:** Tariff energy charge, Tariff demand charge, Export tariff, BTM demand response program.

**Not products:** arbitrage, peak shaving, time-of-use optimization, demand charge management, ancillary service aggregation. These are **strategies** (Operational/Optimization) or **mechanism attributes** (aggregation).

### 4.4 Catalogue Lifecycle

| Status | Meaning |
| --- | --- |
| **Candidate** | Identified but not yet in scope |
| **In scope** | Product sheet complete |
| **Out of scope** | Explicitly excluded; rationale recorded |
| **Deferred** | Postponed; rationale and conditions recorded |
| **Retired** | No longer applicable |

### 4.5 Identifier Scheme

| Property | Rule |
| --- | --- |
| **Format** | `<type>-<sequence>` — e.g., `PROD-001`, `PM-001`, `ELIG-001` |
| **Namespace prefix** | Optional and **display-only**. May be used for readability (e.g., `M2-PROD-001`). |
| **Uniqueness** | Defined on the **unprefixed ID**. The prefix is ignored for uniqueness. |
| **Owner** | Recorded in a **field**, not in the identifier. Ownership may move under change control without changing the identifier. |
| **Stability** | Identifiers are stable across versions. An identifier never changes. |
| **Registry** | Cross-Part identifier registry, separate from the BESS Part 1 master symbol registry. |
| **Symbols** | Mathematical quantities with units remain in the BESS Part 1 master symbol registry (M1 §20). |

---

## 5. Participation Mechanisms

### 5.1 Product-Mechanism Model

Participation is modelled as **Product-Mechanism records**. A **Product-Mechanism record** is the unit of participation. It carries the mechanism attributes and the path-dependent requirements.

**Naming clarification:** This is a **Product → Mechanism-instance** structure (one-to-many from product to mechanism instance), not a general many-to-many between two independently-managed entities. A separate **Mechanism entity** is not defined at this time. If a future need arises to share mechanism definitions across products, a Mechanism entity shall be introduced through change control.

The practical effect is the same as many-to-many for the cases that matter: a product may have several mechanism instances, and path-dependent properties attach to the instance, not the product.

**Examples:**

| Product | Product-Mechanism record 1 | Product-Mechanism record 2 |
| --- | --- | --- |
| Energy | Bid-based (day-ahead) | Price-responsive (real-time, uncommitted) |
| Frequency restoration reserve | Bid-based | Mandatory provision |
| Capacity | Bid-based | Enrollment-based |

### 5.2 Mechanism Categories

| Branch | Mechanism category | Description |
| --- | --- | --- |
| **1** | **Bid-based** | Bid/nomination → award → commitment |
| **2** | **Non-bid commitment** | Commitment arises without a bid — mandatory provision, enrollment, operator instruction, standing obligation |
| **3** | **Null-commitment / price-responsive** | Response to price or signal without creating a commitment |

### 5.3 Product-Mechanism Record

| Field | Description |
| --- | --- |
| **Product-Mechanism ID** | Unique identifier, per §4.5 |
| **Product ID** | The product |
| **Mechanism category** | Branch 1, 2, or 3 |
| **Bid / nomination required** | Yes / No / Conditional |
| **Award required** | Yes / No / Conditional |
| **Commitment created** | Yes / No |
| **Commitment trigger** | Award, enrollment, instruction, standing obligation, etc. |
| **Participation unit** | MW, MWh, MVar, block, portfolio, etc. |
| **Minimum / maximum size** | Minimum and maximum participation size, if applicable |
| **Aggregation permitted** | Yes / No / Conditional |
| **Aggregation rules reference** | Reference to M3a (transversal) or M2 (product-specific) |
| **Reversibility** | Whether the commitment can be withdrawn or adjusted, and under what conditions |
| **Eligibility reference** | Links to eligibility conditions for this Product-Mechanism (§8) |
| **Qualification reference** | Links to qualification requirements for this Product-Mechanism (§9) |
| **Capability mapping reference** | Links to capability mappings for this Product-Mechanism (§10) |
| **Temporal requirements reference** | Links to temporal requirements for this Product-Mechanism (§11) |
| **M4 settlement reference** | Links to the M4 settlement identifier for this Product-Mechanism |
| **M3b rule reference** | Link to M3b rules for this Product-Mechanism (to be populated) |

**Commitment type is not stored** — it is derived from **Commitment created** and **Commitment trigger**.

### 5.4 Mechanism Distinctions

Preserved:

- **Bid-based vs. non-bid commitment** — the presence or absence of a bid does not determine the presence or absence of a commitment.
- **Commitment vs. null commitment** — a null-commitment mechanism creates no market obligation.
- **Aggregated vs. direct participation** — aggregation rules are owned by M3a (transversal) or M2 (product-specific); eligibility of the aggregation unit is owned by M2.

---

## 6. Product Definition

M2 applies the **product definition template** owned by **Introduction v1.2** to every in-scope **Product-Mechanism**.

### 6.1 Template Application Rule

**Reference rule:** M2 references, but does not redefine, concepts owned by M3a, M3b, and M4.

| Template item | Owner | M2 action |
| --- | --- | --- |
| 1. Definition | M2 | Define (at product level) |
| 2. Market Purpose | M2 | Define (at product level) |
| 3. Eligibility | M2 | Define (per Product-Mechanism) |
| 4. Required BESS Capability | M2 (mapping); BESS Engineering (physical model) | Map, referencing BESS symbols |
| 5. Market Signal | M3b | Reference M3b identifier |
| 6. Participation Mechanism | M2 | Define (via Product-Mechanism record) |
| 7. Commitment | M3b | Reference M3b identifier |
| 8. Delivery Requirement | M3b (obligation); M4 (definition and measurement) | Reference M3b and M4 identifiers directly |
| 9. Temporal Requirements | M2 (Product-Mechanism-specific); M1 (framework); M3a (transversal values) | Define Product-Mechanism-specific; reference M1 framework and M3a values |
| 10. Operational Constraints | M3b | Reference M3b identifier |
| 11. Interaction with Other Products | M3b (stacking/coexistence) | Reference M3b identifier |
| 12. Settlement Mechanism | M4 | Reference M4 identifier |
| 13. Technical Outputs | M2 (Product-Mechanism outputs); downstream Parts | Define; reference downstream |
| 14. Risks and Uncertainties | M2 (Product-Mechanism); owning Part (M1 §18) | Define; reference owning Part |

### 6.2 Product Sheet

For each in-scope **Product-Mechanism**, M2 produces a **Product-Mechanism sheet** covering all fourteen template items. The sheet is the authoritative participation-level record. It references but does not redefine M3a, M3b, and M4 content.

---

## 7. Eligibility Semantics

### 7.1 Eligibility Definition

An **eligibility condition** is a requirement that must be satisfied for a resource to participate in a **Product-Mechanism**. Eligibility is assessed **before** participation, against **static or life-dependent capability**, never against instantaneous state (§7.7).

### 7.2 Eligibility Categories

| Category | Description | Owner of the condition | Source of the condition |
| --- | --- | --- | --- |
| **Market eligibility** | Registration, participation agreement, market party status, balance responsibility | M2 (Product-Mechanism-specific); M3a (transversal) | M3a, market documentation |
| **Technical eligibility** | Response time, ramp rate, duration, accuracy, availability, telemetry | M2 | Market documentation |
| **Physical eligibility** | Power, energy, SOC window, SOH, cycle limits | M2 (mapping); BESS Engineering (physical model) | BESS Engineering |
| **Regulatory eligibility** | Jurisdictional authorization, environmental compliance, grid code compliance | M1 (scope); M2 (application) | Regulatory documentation |
| **Contractual eligibility** | Binding contracts (e.g., aggregator agreement) | M2 (condition); owning Part (evidence) | Contractual documentation |

**No "M3b" eligibility category exists.** If a condition is specific to a Product-Mechanism, it is M2's. If it is transversal, it is M3a's. The "transversal product-specific" case does not exist.

### 7.3 Eligibility Assessment

Per condition:

| State | Meaning |
| --- | --- |
| **Satisfied** | The condition is met |
| **Not satisfied** | The condition is not met |
| **Indeterminate** | Cannot be assessed due to missing or unresolved evidence or asset data |
| **Not applicable** | Does not apply to this resource or Product-Mechanism |

**Aggregate eligibility:**

| Aggregate state | Condition |
| --- | --- |
| **Eligible** | At least one applicable condition is Satisfied, and no condition is Not satisfied or Indeterminate |
| **Ineligible** | At least one condition is Not satisfied |
| **Indeterminate** | No condition is Not satisfied, and at least one is Indeterminate |
| **Indeterminate (vacuous)** | **Every** condition is Not applicable |

The vacuous case is explicitly Indeterminate, not Eligible.

### 7.4 Eligibility vs. Qualification

**Eligibility** — whether the resource satisfies the conditions to participate.

**Qualification** — whether the resource has demonstrated, through evidence or tests, that it meets the requirements. States defined in §9.3.

**Participation-ready** — the combined state:

> **Participation-ready = Eligible AND Qualified.** Neither alone is sufficient.

### 7.5 Eligibility Time Dimension

Each **eligibility assessment result** shall carry:

| Field | Description |
| --- | --- |
| **Assessment ID** | Unique identifier, per §4.5 |
| **Eligibility ID** | The eligibility condition assessed |
| **Product-Mechanism ID** | The Product-Mechanism to which the condition applies |
| **Result** | Satisfied / Not satisfied / Indeterminate / Not applicable |
| **Evaluation basis** | BOL / Given SOH / EOL / Year-N / Other |
| **Valid from** | Start of the validity window |
| **Valid to** | End of the validity window (or "asset life") |
| **Degradation reference** | Reference to the **BESS Engineering degradation curve** used |
| **Assessment date** | When the assessment was performed |
| **Assessment blocker** | If Indeterminate, the blocker record (§7.6) |

**Aggregate validity rule.** The validity window of the **aggregate eligibility result** is the **intersection** of the validity windows of its constituent conditions. If any constituent condition has expired, the aggregate is no longer valid at that time. Financial Engineering relies on this rule.

**Degradation is referenced once.** The degradation curve reference lives on the **assessment result** only. The **capability mapping** (§10) does not carry a degradation reference; it is timeless.

### 7.6 Assessment Blocker

For **Indeterminate** eligibility:

| Field | Description |
| --- | --- |
| **Blocker ID** | Unique identifier, per §4.5 |
| **Assessment ID** | The assessment that is blocked |
| **Category** | Missing market evidence / Missing asset data / Missing regulatory clarification / Other |
| **Description** | The specific gap |
| **Owning Part** | Responsible Part |
| **Reference** | If a market-evidence gap, the linked Unresolved Requirement statement ID (M1 §16.3) |

### 7.7 Static vs. Instantaneous Rule

> **Eligibility shall be assessed against static or life-dependent capability** — the capability the asset can provide under defined conditions (e.g., SOC window, power capability at a given SOH). Eligibility shall **not** be assessed against instantaneous operational state (e.g., current SOC). Instantaneous state is an operational constraint owned by M3b and applied by Operational/Optimization Engineering.

---

## 8. Eligibility Requirements per Product-Mechanism

### 8.1 Eligibility Requirement Structure

| Field | Description |
| --- | --- |
| **Eligibility ID** | Unique identifier, per §4.5 |
| **Product-Mechanism ID** | The Product-Mechanism to which the requirement applies |
| **Category** | Market / Technical / Physical / Regulatory / Contractual (§7.2) |
| **Condition** | The condition that must be satisfied |
| **Threshold** | Quantitative threshold, if Product-Mechanism-specific. **Owned by M2.** |
| **Unit** | The unit of the threshold |
| **Source** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M2 for Product-Mechanism-specific conditions. Reference M3a for transversal conditions. |
| **Assessment method** | How the condition is assessed |
| **Assessment frequency** | One-time / Per participation / Periodic |
| **Consequence of failure** | What happens if the condition is not satisfied |

### 8.2 Eligibility Requirement Categories

| Category | Typical requirements |
| --- | --- |
| **Market** | Registration (per M3a), participation agreement, market party status, balance responsibility |
| **Technical** | Response time, ramp rate, duration, accuracy, availability, telemetry |
| **Physical** | Power capability, energy capability, SOC window (static), SOH, cycle limits |
| **Regulatory** | Jurisdictional authorization, environmental compliance, grid code compliance |
| **Contractual** | Aggregator agreement, offtake agreement, interconnection agreement terms |

**Registration** is assigned to **market eligibility**, not qualification.

### 8.3 Eligibility Aggregation

Determined by combining conditions per §7.3. The aggregation rule is recorded per Product-Mechanism.

---

## 9. Qualification Requirements per Product-Mechanism

### 9.1 Qualification Definition

A **qualification requirement** is a demonstration, test, or ongoing compliance obligation. Qualification is distinct from eligibility.

### 9.2 Qualification Requirement Structure

| Field | Description |
| --- | --- |
| **Qualification ID** | Unique identifier, per §4.5 |
| **Product-Mechanism ID** | The Product-Mechanism to which the requirement applies |
| **Type** | Test / Evidence submission / Ongoing compliance / Re-qualification |
| **Requirement** | What must be demonstrated |
| **Method** | How it is demonstrated |
| **Frequency** | One-time / Periodic / Continuous |
| **Threshold** | Quantitative threshold, if Product-Mechanism-specific. **Owned by M2.** |
| **Unit** | The unit of the threshold |
| **Source** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M2 for Product-Mechanism-specific requirements. Reference M3a for transversal requirements. |
| **Consequence of failure** | What happens if qualification is not maintained |

### 9.3 Qualification States

A qualification requirement is assessed with the following states:

| State | Meaning |
| --- | --- |
| **Qualified** | The requirement is demonstrated and currently valid |
| **Not qualified** | The requirement is not demonstrated, or has lapsed |
| **Pending** | Demonstration is in progress; not yet qualified |
| **Not required** | The requirement does not apply to this resource or Product-Mechanism |

**Aggregate qualification state:**

| Aggregate state | Condition |
| --- | --- |
| **Qualified** | At least one applicable requirement is Qualified, and no requirement is Not qualified or Pending |
| **Not qualified** | At least one requirement is Not qualified |
| **Pending** | No requirement is Not qualified, and at least one is Pending |
| **Not qualified (vacuous)** | **Every** requirement is Not required. Qualification requires at least one applicable requirement. |

### 9.4 Qualification Time Dimension

Each **qualification assessment result** shall carry:

| Field | Description |
| --- | --- |
| **Assessment ID** | Unique identifier, per §4.5 |
| **Qualification ID** | The qualification requirement assessed |
| **Product-Mechanism ID** | The Product-Mechanism to which the requirement applies |
| **Result** | Qualified / Not qualified / Pending / Not required |
| **Valid from** | Start of the validity window |
| **Valid to** | End of the validity window (or "asset life") |
| **Assessment date** | When the assessment was performed |

**Aggregate validity rule.** The validity window of the **aggregate qualification result** is the **intersection** of the validity windows of its constituent requirements.

### 9.5 Qualification Categories

| Category | Typical requirements |
| --- | --- |
| **Initial qualification** | Pre-participation tests, evidence submissions. *(Registration excluded — see §8.2.)* |
| **Ongoing compliance** | Telemetry, availability reporting, performance monitoring |
| **Re-qualification** | Periodic re-testing, re-certification |
| **Failure handling** | What happens when qualification lapses |

### 9.6 Qualification vs. Capability

Qualification requirements reference **capabilities** (§10). The requirement is the *demonstration*; the capability is defined by BESS Engineering and mapped in §10.

---

## 10. Product-to-BESS Capability Mapping

### 10.1 Mapping Definition

A **capability mapping** is the correspondence between a Product-Mechanism requirement (eligibility or qualification) and a physical capability of the BESS.

**The mapping is timeless.** It states the rule by which a capability satisfies a requirement. It carries **no validity window** and **no degradation reference**. The validity window belongs to the assessment result (§7.5); the degradation curve reference belongs to the assessment result (§7.5).

### 10.2 Capability Mapping Structure

| Field | Description |
| --- | --- |
| **Mapping ID** | Unique identifier, per §4.5 |
| **Product-Mechanism ID** | The Product-Mechanism to which the mapping applies |
| **Requirement ID** | The eligibility or qualification requirement being mapped |
| **BESS capability** | The physical capability referenced (symbol from the BESS Part 1 master symbol registry) |
| **Mapping type** | Direct / Derived / Conditional / Composite |
| **Mapping rule** | The rule by which the capability satisfies the requirement |
| **Margin** | Any required margin (e.g., degradation reserve). **May not be applied in addition to a degradation-curve evaluation at a specific SOH** — the choice shall be stated per mapping. |
| **Source** | Linked Evidence Statement ID (M1 §16.3) |

**No degradation reference.** Degradation is referenced once, on the assessment result (§7.5).

**No validity window.** The mapping is timeless; the assessment result carries the window.

### 10.3 Mapping Types

| Type | Description |
| --- | --- |
| **Direct** | The capability directly satisfies the requirement (e.g., power capability ≥ minimum power) |
| **Derived** | The capability satisfies the requirement through a derived quantity (e.g., duration = energy / power) |
| **Conditional** | The capability satisfies the requirement under specified conditions (e.g., at a given SOC window) |
| **Composite** | The requirement is satisfied by a combination of capabilities |

### 10.4 Upstream Propagation

Where a Product-Mechanism requirement cannot be satisfied by the current BESS physical model, it propagates upstream to BESS Engineering per M1 §22. M2 records the propagation status for each such requirement.

---

## 11. Product-Mechanism Temporal Requirements

### 11.1 Temporal Requirement Structure

| Field | Description |
| --- | --- |
| **Temporal ID** | Unique identifier, per §4.5 |
| **Product-Mechanism ID** | The Product-Mechanism to which the requirement applies |
| **Period type** | Bid window / Gate closure / Commitment period / Delivery period / Settlement period / Publication interval / Observation interval |
| **Requirement** | The Product-Mechanism-specific temporal requirement |
| **Rule value reference** | For transversal rule values (e.g., market-wide gate closure time), reference **M3a**. Not owned by M2. |
| **Product-Mechanism-specific value** | For Product-Mechanism-specific temporal values (e.g., a product's fixed delivery block length), the value. **Owned by M2.** |
| **Framework reference** | Reference to the **M1 temporal framework instance** that carries the market-level attributes: interval labeling, time zone, DST handling, resolution (M1 §11). |
| **Source** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M2 for Product-Mechanism-specific values. Reference M3a for transversal values. |

**Market-level attributes are not duplicated on each temporal record.** Interval labeling, time zone, DST handling, and resolution are properties of the **market or its settlement system**. They are carried by the **M1 temporal framework instance** for the market, and referenced from each temporal record. This avoids the inconsistency that arises when the same attributes are recorded on every record.

### 11.2 Temporal Requirement Categories

| Category | Typical requirements |
| --- | --- |
| **Bid / nomination** | Bid window opening and closing, gate closure |
| **Award** | Award publication, award acceptance |
| **Commitment** | Commitment period start and end, duration |
| **Delivery** | Delivery period start and end, duration, resolution |
| **Settlement** | Settlement period start and end, resolution, lag |
| **Publication** | Signal publication time, frequency |
| **Observation** | Observation time, frequency |

### 11.3 Temporal Mapping

Product-Mechanism temporal requirements map onto the M1 temporal framework without redefining it. Each period is expressed as a relation to the project time axis, and references the framework instance for interval labeling, time zone, DST, and resolution.

---

## 12. Product-Mechanism Risks and Uncertainties

### 12.1 Risk and Uncertainty Structure

| Field | Description |
| --- | --- |
| **Risk ID** | Unique identifier, per §4.5 |
| **Product-Mechanism ID** | The Product-Mechanism to which the risk applies |
| **Type** | Eligibility-rule uncertainty / Qualification-rule uncertainty / Product-definition uncertainty / Capability-mapping uncertainty / Temporal-requirement uncertainty / Other |
| **Description** | The risk or uncertainty |
| **Owning Part** | M2 (Product-Mechanism-level); other Parts (M1 §18) |
| **Impact** | Qualitative scale (Low / Medium / High) |
| **Likelihood** | Qualitative scale (Low / Medium / High) |
| **Mitigation** | How the risk is mitigated |
| **Source** | Linked Evidence Statement ID (M1 §16.3) |

### 12.2 Uncertainty Ownership

- **M1** — domain-scope, role, structural, foundational assumption uncertainty
- **M2** — product, qualification, eligibility-rule uncertainty
- **M3a/M3b** — market-rule, signal, market-data, commitment, operational-constraint uncertainty
- **M4** — delivery, performance, settlement uncertainty

M2 records the owning Part for each uncertainty.

---

## 13. Catalogue Governance

### 13.1 Ownership

The product catalogue and the Product-Mechanism records are owned by M2.

### 13.2 Change Control

Changes follow project change control. Changes affecting M3a, M3b, or M4 propagate through controlled interfaces. Changes affecting BESS physical requirements propagate to BESS Engineering per M1 §22.

### 13.3 Traceability

Every catalogue entry and Product-Mechanism record traces to: originating evidence; eligibility requirements; qualification requirements; capability mappings; temporal requirements; risks; M3a references; M3b references (to be populated); M4 references (to be populated).

---

## 14. Interfaces

### 14.1 M1 — Market Domain and Conventions

**Consumes:** market environment and scope; participant-role model; semantic model with three branches; temporal framework; evidence model; ownership table; price-influence assumption.

**Provides:** product-specific feedback; proposed changes via change control.

### 14.2 M3a — Transversal Market Values (Early Baseline)

**Consumes from M3a:** market-wide gate closure conventions; market-wide registration requirements; market-wide timing conventions; market-wide data formats and telemetry; market-wide minimum participation sizes and aggregation rules, where transversal.

**Provides to M3a:** feedback on transversal values encountered during product population; proposed additions via change control.

### 14.3 M3b — Full Rules, Signals, Commitments and Constraints

**Provides to M3b:** product identifiers; Product-Mechanism records; eligibility conditions per Product-Mechanism; qualification requirements per Product-Mechanism; temporal requirements; capability mappings; risks.

**Consumes from M3b:** product-specific rules; signal definitions; commitment definitions; operational constraints; stacking/coexistence rules.

**Boundary rule:** A rule is owned by **M2** if it is specific to a Product-Mechanism. A rule is owned by **M3a** if it is transversal and needed before M2 freeze. A rule is owned by **M3b** if it is transversal or product-specific and **not** needed to evaluate eligibility.

### 14.4 M4 — Delivery, Performance and Settlement

**Provides to M4:** product identifiers; Product-Mechanism records.

**Consumes from M4:** delivery definition and measurement; performance measurement; settlement mechanism; baseline/counterfactual; the authoritative settlement quantity per Product-Mechanism.

**Direct reference:** M4 takes **delivery obligation** identifiers directly from **M3b**, not relayed through M2.

### 14.5 BESS Engineering

**Consumes from BESS:** physical capability symbols; operating limits; power and energy capability; SOC/SOH capabilities; response characteristics; physical constraints; the **degradation curve** used for eligibility assessment (§7.5).

**Provides to BESS:** market-derived capability requirements; response-time, duration, and qualification constraints; other requirements that may affect specification.

Unmappable requirements propagate upstream per M1 §22.

### 14.6 Forecasting Engineering

**Provides:** product identifiers; Product-Mechanism records; signal references (via M3b); temporal requirements; uncertainties relevant to forecasting.

### 14.7 Operational / Optimization Engineering

**Provides:** eligibility conditions per Product-Mechanism; Product-Mechanism records; temporal requirements; capability mappings; the static-vs-instantaneous rule (§7.7).

### 14.8 Financial Engineering

**Provides:** product identifiers; Product-Mechanism records; settlement references (via M4); the eligibility time dimension (§7.5) — validity windows, evaluation basis, and the aggregate-validity intersection rule — required for asset-life valuation.

### 14.9 Software Engineering

**Provides:** catalogue structure; Product-Mechanism records; eligibility and qualification assessment logic; capability mapping structure; temporal requirement structure; identifier scheme.

---

## 15. M2 Open Items

| ID | Open item | Required outcome | Owner | Priority | Blocking dependency | Target date |
| --- | --- | --- | --- | --- | --- | --- |
| M2-O01 | Product universe | Candidate product universe established | Market Engineering Lead | Critical | Depends on M1-O05 | TBD |
| M2-O02 | Product taxonomy | Taxonomy axes finalized | Market Engineering Lead | High | Depends on M2-O01 | TBD |
| M2-O03 | Eligibility conditions | Eligibility conditions defined per Product-Mechanism | Market Engineering Lead | High | Depends on M2-O01 | TBD |
| M2-O04 | Qualification requirements | Qualification requirements defined per Product-Mechanism | Market Engineering Lead | High | Depends on M2-O01 | TBD |
| M2-O05 | Capability mappings | Capability mappings completed per Product-Mechanism | Market Engineering Lead + BESS Engineering | High | Depends on M2-O01, M2-O03 | TBD |
| M2-O06 | Temporal requirements | Product-Mechanism temporal requirements defined | Market Engineering Lead | High | Depends on M2-O01, M1-O06 | TBD |
| M2-O07 | Product-Mechanism records | Product-Mechanism records defined for every product | Market Engineering Lead | High | Depends on M2-O01 | TBD |
| M2-O08 | Product-Mechanism sheets | Sheets completed per in-scope Product-Mechanism | Market Engineering Lead | High | Depends on M2-O03–M2-O07 | TBD |
| M2-O09 | Risks | Product-Mechanism risks identified | Market Engineering Lead | Medium | Depends on M2-O01 | TBD |
| M2-O10 | M3a references | References to M3a established | Market Engineering Lead | High | Depends on M2-O13 | TBD |
| M2-O11 | M4 settlement references | M4 settlement references established | Market Engineering Lead | Medium | Depends on M4 draft | TBD |
| M2-O12 | BESS capability symbols | All required BESS capability symbols registered | BESS Engineering + Market Engineering Lead | High | Depends on M2-O05 | TBD |
| M2-O13 | M3a frozen | M3a — Transversal Market Values frozen | M3 Lead (Introduction v1.2) | Critical | Blocks M2 freeze; independent of M2-O01 | TBD |
| M2-O14 | Identifier scheme adopted | Cross-Part identifier scheme adopted by M1 | M1 Lead + Market Engineering Lead | Medium | Blocks M2 freeze; independent | TBD |
| M2-O15 | Pilot Product-Mechanism sheet | One complete Product-Mechanism sheet piloted (energy, day-ahead or real-time) | Market Engineering Lead | High | Depends on M1-O01–O03 and **energy confirmed in scope** (a subset of M2-O01) | TBD |

**Critical path:** M2-O01 blocks most items. M2-O13 (M3a frozen) and M2-O14 (identifier scheme) block M2 freeze independently. M2-O15 (pilot) is the recommended next step and depends only on **energy being confirmed in scope**, not on the full product universe.

---

## 16. M2 Validation Criteria

### Product Validation

- **Method:** Comparison against authoritative market documentation and project requirements.
- **Reference case:** The market environment and product universe established per M1-O05.
- **Reviewer:** Market Engineering Lead + independent reviewer.
- **Pass condition:** Every in-scope product has a complete set of Product-Mechanism sheets; no product is defined without an authoritative source; no strategy is listed as a product.

### Participation Validation

- **Method:** Review of each Product-Mechanism record against the market's actual participation rules.
- **Reference case:** Market documentation and participation agreements.
- **Reviewer:** Market Engineering Lead.
- **Pass condition:** Each record is correctly classified (branch 1, 2, or 3); no mechanism is assumed without evidence; every product with multiple access paths has multiple Product-Mechanism records; path-dependent properties attach to the Product-Mechanism, not the product.

### Eligibility Validation

- **Method:** Review of eligibility conditions per Product-Mechanism. Test the vacuous case, the indeterminate case, the participation-ready state, and the aggregate-validity intersection.
- **Reference case:** Market documentation, M3a, and BESS Engineering Part 1.
- **Reviewer:** Market Engineering Lead + BESS Engineering.
- **Pass condition:** Each condition is correctly categorized, has a source, has an assessment method, and has an owner that is M2 (Product-Mechanism-specific) or M3a (transversal). No eligibility condition depends on M3b. Aggregate eligibility, vacuous and indeterminate cases, participation-ready, and aggregate validity are correctly computed.

### Qualification Validation

- **Method:** Review of qualification requirements per Product-Mechanism. Test the qualification states and the aggregate validity.
- **Reference case:** Market documentation.
- **Reviewer:** Market Engineering Lead.
- **Pass condition:** Each requirement has a method, frequency, and consequence of failure. Qualification states and aggregation are correctly computed. Registration is assigned to market eligibility, not qualification.

### Capability Mapping Validation

- **Method:** Review of each capability mapping against BESS physical capabilities.
- **Reference case:** BESS Engineering Part 1 (pinned version).
- **Reviewer:** BESS Engineering + Market Engineering Lead.
- **Pass condition:** Each mapping is correctly typed, references a registered BESS symbol, has a source, is timeless (no validity window, no degradation reference), and states whether margin is applied instead of, or in addition to, a degradation-curve evaluation. Unmappable requirements are propagated upstream.

### Temporal Validation

- **Method:** Test cases covering interval labeling, time-zone boundaries, and resolution mismatch, applied to **at least one temporal requirement from each in-scope Product-Mechanism**, plus at least one that exercises the M1 temporal framework reference.
- **Reference case:** M1 temporal framework and M3a.
- **Reviewer:** Market Engineering Lead + BESS Engineering.
- **Pass condition:** All applicable test cases produce the expected mapping; market-level attributes are referenced from the framework instance, not duplicated; Product-Mechanism-specific and transversal values are correctly distinguished.

### Boundary Validation

- **Method:** Interface review with M1, M3a, M3b, M4, BESS, Forecasting, Operational/Optimization, Financial, Software.
- **Reference case:** Interface definitions in §14.
- **Reviewer:** Cross-domain review board.
- **Pass condition:** No responsibility is claimed by two domains; no responsibility is unowned; the eligibility path does not reference M3b; M4 takes delivery references directly from M3b.

### Evidence Validation

- **Method:** Traceability audit (M1 §16.4).
- **Reference case:** Critical-path evidence set.
- **Reviewer:** Independent evidence reviewer.
- **Pass condition:** Every material statement has a complete Statement Record and at least one complete Source Record. Tier-1 statements have at least one Verified Rule source.

### Consistency Validation

- **Method:** Symbol, identifier, and convention audit.
- **Reference case:** BESS Engineering Part 1 (pinned version), M1 v1.2, M3a, Introduction v1.2.
- **Reviewer:** BESS Engineering + Market Engineering Lead.
- **Pass condition:** No conflicting symbols, identifiers, units, state conventions, or temporal conventions; no M3a, M3b, or M4 concept is redefined in M2; identifiers are stable, unique on the unprefixed form, and owner is recorded separately.

---

## 17. M2 Acceptance Criteria

M2 is ready for engineering freeze when:

- the product universe is established and traceable to authoritative evidence;
- the product taxonomy is finalized and applied consistently;
- every in-scope product has a complete set of Product-Mechanism sheets;
- Product-Mechanism records are defined for every product, and path-dependent records key on Product-Mechanism ID;
- eligibility conditions are defined per Product-Mechanism, categorized, sourced, assessed, and **do not depend on M3b**;
- the vacuous, indeterminate, and participation-ready cases are computed correctly;
- qualification states, aggregation, validity, and the time dimension are defined and computed correctly;
- registration is assigned to market eligibility, not qualification;
- capability mappings are complete per Product-Mechanism, reference registered BESS symbols, are typed correctly, and are **timeless**;
- degradation is referenced **once**, on the assessment result;
- margin application is stated per mapping;
- aggregate validity (intersection rule) is defined for both eligibility and qualification;
- Product-Mechanism temporal requirements are defined and map correctly onto the M1 temporal framework; market-level attributes are referenced from the framework instance, not duplicated;
- product-level risks and uncertainties are identified, with owning Parts recorded;
- **M3a is frozen** (M2-O13);
- **the cross-Part identifier scheme is adopted** (M2-O14);
- M4 settlement references are established or explicitly deferred;
- all required BESS capability symbols are registered through BESS Engineering Part 1;
- no independent market symbol authority exists;
- interfaces with M1, M3a, M3b, M4, BESS, Forecasting, Operational/Optimization, Financial, and Software Engineering are defined;
- the **Introduction v1.2 change** establishing the M3 split and the revised freeze order is issued;
- open items have been resolved or explicitly accepted as controlled assumptions, with owners, priorities, dependencies, and dispositions recorded;
- validation criteria have been satisfied with documented method, reference case, reviewer, and pass/fail result.

---

## 18. M2 Maturity

M2 follows the project-wide maturity ladder:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

Current status:

- **Semantic Definition — established (framework)**
- **Internal Consistency — ready for validation** *(revised from "established" in v1.1, pending independent review)*
- **External Evidence — pending product universe identification (M2-O01)**
- **Engineering Validation — pending**
- **Frozen — No**

**Status note.** The M2 framework is complete as of v1.2. The remaining work is populating the catalogue with real products and Product-Mechanism records from authoritative market documentation. Further abstract iteration on the framework will add little. The next real gain is **External Evidence**, blocked on M1-O01 through M1-O05. The recommended next step is the **pilot Product-Mechanism sheet** (M2-O15) once M1-O01–O03 are resolved and energy is confirmed in scope.

---

## 19. Output of M2

The final output of M2 shall be a controlled **Market Product Specification** containing:

1. product taxonomy;
2. product catalogue with lifecycle status;
3. Product-Mechanism records;
4. Product-Mechanism sheets per in-scope Product-Mechanism;
5. eligibility requirements per Product-Mechanism, with assessment results carrying validity windows and evaluation basis, and the aggregate-validity intersection rule;
6. qualification requirements per Product-Mechanism, with states, aggregation, validity windows, and the aggregate-validity intersection rule;
7. product-to-BESS capability mappings, timeless, with no degradation reference (degradation referenced once, on the assessment result);
8. Product-Mechanism temporal requirements, referencing the M1 temporal framework instance for market-level attributes;
9. product-level risks and uncertainties;
10. M3a references (populated);
11. M3b references (to be populated);
12. M4 settlement references (to be populated);
13. registered BESS capability symbols through BESS Part 1;
14. identifier scheme (adopted by M1);
15. resolved assumptions and open-item disposition.

This output becomes the formal product foundation for:

**M3b — Full Rules, Signals, Commitments and Constraints**

which will then answer the next engineering question:

> **What rules govern participation in each Product-Mechanism, what signals does the market publish, how are commitments formed and satisfied, and what constraints apply?**