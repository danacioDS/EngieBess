# Parte 2 — Transversal Market Values

**Version:** 1.0 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Parent Document:** Market Engineering Model — Introduction Document (v1.2)
**Upstream Dependencies:**
- Parte 1 — Market Domain and Conventions (v1.3), specifically §6, §7, §11, §14, §16, §19
- BESS Engineering Part 1 — Fundamentals and Conventions (pinned per P1-O13)
**Downstream Consumers:**
- Parte 3 — Market Products and Participation (requires Parte 2 frozen before it can freeze)
- Parte 4 — Market Rules, Signals, Commitments and Constraints (references transversal values)
- Parte 5 — Delivery, Performance and Settlement (references transversal timing values)

**Document ID:** ME-P2-001 *(stable across versions)*

---

## Revision History

| Version | Date | Status | Change |
| --- | --- | --- | --- |
| 1.0 | 2026-09-22 | Development Draft | Initial Parte 2 baseline. Created from the M3a specification owned by Introduction v1.2. Establishes the transversal market values early baseline: gate closure conventions, registration requirements, timing conventions (non-signal), data formats and telemetry requirements, transversal minimum participation sizes, transversal aggregation rules, eligibility-relevant transversal limits, and the temporal framework instance. |

**Change control note:** The M3 split into M3a (Transversal Market Values) and M3b (Full Rules) is owned by **Introduction v1.2**. Parte 2 is the M3a deliverable. The canonical lifecycle, the optional-node rule, the null-commitment path rule, and the M2 template reference rule are owned by **Introduction v1.2**. Where Parte 2 and the Introduction differ, the Introduction governs.

**Scope restriction (normative):** Parte 2 is limited to values that Parte 3 needs to evaluate eligibility and participation **before Parte 3 freezes**. Values that are not on the eligibility path belong to Parte 4, even if they are transversal.

---

## 1. Purpose and Scope

Parte 2 establishes the **transversal market values early baseline** for Market Engineering.

Its purpose is to define the market-wide values that apply across all products in the defined market environment, so that Parte 3 can evaluate eligibility and participation without referencing the full rules layer (Parte 4).

Parte 2 defines:

- **gate closure conventions** — market-wide gate closure rules;
- **registration requirements** — market-wide registration and participation-agreement requirements;
- **timing conventions** — market-wide timing conventions that are **not** signal-specific;
- **data formats and telemetry requirements** — market-wide data format and telemetry standards;
- **transversal minimum participation sizes** — market-wide minimum participation sizes;
- **transversal aggregation rules** — market-wide rules for aggregating multiple assets or loads;
- **eligibility-relevant transversal limits** — market-wide limits that affect eligibility assessment;
- **the temporal framework instance** — time zone, interval labeling, DST handling, and resolution for the applicable market.

Parte 2 does **not** define:

- product-specific eligibility thresholds (Parte 3);
- product-specific qualification requirements (Parte 3);
- product-specific temporal values (Parte 3);
- market signals or signal publication timing (Parte 4);
- product-specific rules, commitments, or operational obligations (Parte 4);
- product-specific stacking constraints (Parte 4);
- grid/network constraints (Parte 4);
- delivery, performance, or settlement definitions (Parte 5);
- the physical BESS model (BESS Engineering);
- site/interconnection capability (Parte 1 definition; P1-O14 pending; consumed by Parte 3).

The primary question of Parte 2 is:

> **Which transversal market values — gate closure conventions, registration requirements, timing conventions, data formats, transversal minimum sizes, aggregation rules, and eligibility-relevant limits — apply across all products in the defined market environment?**

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
(eligibility path only,
frozen before Parte 3)
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

**Freeze order:** Parte 1 → **Parte 2** → Parte 3 → Parte 4 → Parte 5.

Parte 2 is frozen **before Parte 3** because Parte 3 references transversal market values that it cannot own. Parte 4 is frozen after Parte 3 because it consumes Parte 3's product catalogue and Product-Mechanism relations.

This is a **document-construction dependency**, not the market lifecycle.

### 2.2 Consumes and Provides

**Parte 2 consumes from Parte 1:**

- market environment definition and scope (Parte 1 §6, §7);
- participant-role model and Market Party model (Parte 1 §5);
- market semantic model, three participation branches (Parte 1 §8);
- market temporal mapping framework (Parte 1 §11);
- evidence model (Parte 1 §16);
- semantic ownership table (Parte 1 §19);
- price-influence assumption (Parte 1 §15);
- grid/network constraint classification (Parte 1 §14).

**Parte 2 consumes from BESS Engineering Part 1:**

- project-wide temporal conventions;
- project-wide units;
- master symbol registry.

**Parte 2 provides to Parte 3:**

- market-wide gate closure conventions;
- market-wide registration requirements;
- market-wide timing conventions (non-signal);
- market-wide data formats and telemetry requirements;
- market-wide minimum participation sizes, where transversal;
- market-wide aggregation rules, where transversal;
- eligibility-relevant transversal limits;
- the temporal framework instance (time zone, interval labeling, DST handling, resolution).

**Parte 2 provides to Parte 4:**

- transversal values referenced by Parte 4 rules;
- transversal limits referenced by Parte 4 constraints.

**Parte 2 provides to Parte 5:**

- transversal timing values referenced by delivery and settlement definitions.

**Parte 2 does not create an independent symbol registry.** Market-specific **symbols** are registered in the **BESS Engineering Part 1 master symbol registry** (Parte 1 §20). **Identifiers** are governed by Parte 3 §4.5.

### 2.3 Cycle-Breaking: Why Parte 2 Exists

Parte 3 requires **transversal market values** that Parte 4 owns. Referencing them from the full Parte 4 would create a Parte 3 → Parte 4 → Parte 3 loop.

To break the loop, **Introduction v1.2** splits the rules layer into two:

| Layer | Contents | Drafted | Owner |
| --- | --- | --- | --- |
| **Parte 2 — Transversal Market Values** | Market-wide values Parte 3 needs to evaluate eligibility and participation. No product-specific content. No signals. | **Before Parte 3 freeze.** | Parte 2 Lead |
| **Parte 4 — Full Rules, Signals, Commitments and Constraints** | Product-specific rules, signals, commitments, operational constraints, stacking. | **After Parte 3 freeze.** | Parte 4 Lead |

**What belongs in Parte 2:** market-wide gate closure conventions; market-wide registration requirements; market-wide timing conventions (non-signal); market-wide data formats and telemetry requirements; market-wide minimum participation sizes and aggregation rules, where transversal; eligibility-relevant transversal limits; the temporal framework instance.

**What belongs in Parte 4:** product-specific signals, commitments, operational constraints, stacking/coexistence rules, and any rule value that depends on a product or a Product-Mechanism.

**What belongs in neither (it belongs to Parte 3):** product-specific eligibility thresholds, qualification test parameters, product-specific temporal values, capability mappings.

**The residual full-Parte-4 dependency is removed.** Parte 3's eligibility path references **Parte 1 + Parte 2 + Parte 3 itself + BESS Engineering**. It does not reference Parte 4. This is stated as a normative property of the boundary:

> **Eligibility-path rule.** No eligibility condition shall depend on a value owned by Parte 4. If an eligibility condition appears to require a Parte 4 value, either the condition is product-specific and belongs to Parte 3, or the value is transversal and belongs to Parte 2. The "transversal product-specific" case does not exist: a value is either specific to one Product-Mechanism (Parte 3) or shared across products (Parte 2).

### 2.4 Scope Restriction (Normative)

> **Parte 2 is limited to values on the eligibility path.** A value belongs in Parte 2 only if Parte 3 needs it to evaluate eligibility or qualification before Parte 3 freezes. Values that are transversal but not on the eligibility path belong in Parte 4.

**Examples of eligibility-path transversal values (Parte 2):**

- Market-wide registration requirements;
- Market-wide gate closure conventions;
- Market-wide data format and telemetry standards;
- Market-wide minimum participation sizes;
- Market-wide aggregation rules;
- Eligibility-relevant transversal limits;
- Temporal framework instance (time zone, interval labeling, resolution).

**Examples of non-eligibility-path transversal values (Parte 4):**

- Market-wide signal publication timing;
- Market-wide settlement timing;
- Market-wide operational obligations;
- Market-wide stacking constraints;
- Market-wide penalties.

**Publication timing rule (normative):**

> **Signal publication timing is owned by Parte 4.** Parte 2 owns transversal market timing conventions that are **not** signal-specific (e.g., registration windows, market-wide gate closure). Where a timing is signal-specific — including market-wide signal publication — Parte 4 owns it.

---

## 3. Intent

### 3.1 WHAT

Parte 2 represents the transversal market values layer as a structured set of:

- **Gate closure conventions** — market-wide rules for when participation windows close;
- **Registration requirements** — market-wide registration and participation-agreement requirements;
- **Timing conventions** — market-wide timing conventions that are not signal-specific;
- **Data formats and telemetry requirements** — market-wide data format and telemetry standards;
- **Transversal minimum participation sizes** — market-wide minimum sizes;
- **Transversal aggregation rules** — market-wide aggregation rules;
- **Eligibility-relevant transversal limits** — market-wide limits that affect eligibility;
- **Temporal framework instance** — time zone, interval labeling, DST handling, resolution;
- **Transversal value uncertainty** — uncertainty owned by Parte 2.

### 3.2 WHY

The purpose is to prevent a circular dependency between Parte 3 and Parte 4, and to ensure that transversal values are defined once, in one place, with a single owner.

Without Parte 2:

- Parte 3 would have to define transversal values it does not own, or
- Parte 3 would have to reference Parte 4 before Parte 4 exists, creating a loop.

Parte 2 provides the **early baseline** that breaks the loop.

### 3.3 FOR WHOM

Parte 2 provides the transversal values foundation for:

- Parte 3 — to evaluate eligibility and participation;
- Parte 4 — to reference transversal values in rules and constraints;
- Parte 5 — to reference transversal timing values in delivery and settlement;
- Software Engineering — to implement market-wide value lookups.

---

## 4. Transversal Value Categories

### 4.1 Category Overview

| Category | Description | Used by |
| --- | --- | --- |
| **Gate closure conventions** | Market-wide rules for when participation windows close | Parte 3 (eligibility), Parte 4 (rules) |
| **Registration requirements** | Market-wide registration and participation-agreement requirements | Parte 3 (market eligibility) |
| **Timing conventions (non-signal)** | Market-wide timing conventions that are not signal-specific | Parte 3 (temporal), Parte 4 (rules), Parte 5 (settlement) |
| **Data formats and telemetry** | Market-wide data format and telemetry standards | Parte 3 (technical eligibility), Parte 4 (obligations) |
| **Transversal minimum sizes** | Market-wide minimum participation sizes | Parte 3 (eligibility) |
| **Transversal aggregation rules** | Market-wide rules for aggregating assets/loads | Parte 3 (eligibility) |
| **Eligibility-relevant transversal limits** | Market-wide limits affecting eligibility | Parte 3 (eligibility) |
| **Temporal framework instance** | Time zone, interval labeling, DST handling, resolution | Parte 3 (temporal), Parte 4 (rules), Parte 5 (settlement) |

### 4.2 Ownership Boundary

| Value | Owner | Rationale |
| --- | --- | --- |
| Gate closure conventions (market-wide) | **Parte 2** | Transversal; on eligibility path |
| Registration requirements (market-wide) | **Parte 2** | Transversal; on eligibility path |
| Timing conventions (non-signal) | **Parte 2** | Transversal; on eligibility path |
| Data formats and telemetry | **Parte 2** | Transversal; on eligibility path |
| Transversal minimum sizes | **Parte 2** | Transversal; on eligibility path |
| Transversal aggregation rules | **Parte 2** | Transversal; on eligibility path |
| Eligibility-relevant transversal limits | **Parte 2** | Transversal; on eligibility path |
| Temporal framework instance | **Parte 2** | Transversal; on eligibility path |
| Signal definitions and publication timing | **Parte 4** | Signal-specific; not on eligibility path |
| Product-specific thresholds | **Parte 3** | Product-specific |
| Settlement timing values | **Parte 5** | Settlement-specific |

**Threshold routing rule (normative):**

> **Where Parte 3 owns a threshold, Parte 2 does not define it. Where a threshold is transversal and on the eligibility path, Parte 2 owns it. Where a threshold is transversal but not on the eligibility path, Parte 4 owns it. Where a threshold is used to score delivery, Parte 5 owns it.**

---

## 5. Gate Closure Conventions

### 5.1 Purpose

**Gate closure** is the market-wide deadline after which participation for a given period can no longer be submitted or modified.

Gate closure conventions are transversal: they apply across products within the same market. A product may have a product-specific gate closure value (owned by Parte 3), but the **convention** — how gate closure is expressed, how it relates to delivery periods, how modifications are handled — is transversal.

### 5.2 Gate Closure Convention Record

| Field | Description |
| --- | --- |
| **Gate Closure Convention ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Convention statement** | The gate closure convention, in normative form |
| **Relation to delivery period** | How gate closure relates to the delivery period (e.g., day-ahead gate closure at 12:00 for next-day delivery) |
| **Modification rule** | Whether and how participation can be modified after gate closure |
| **Late-submission rule** | Whether late submissions are accepted, and under what conditions |
| **Time zone reference** | Reference to the temporal framework instance (§11) |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 5.3 Gate Closure vs. Product-Specific Gate Closure

| Concept | Owner | Example |
| --- | --- | --- |
| **Gate closure convention** | Parte 2 | "Day-ahead participation closes at 12:00 local time for next-day delivery" |
| **Product-specific gate closure value** | Parte 3 | "The energy product's bid window closes at 12:00" |

Parte 2 defines the **convention**; Parte 3 applies it to specific products.

---

## 6. Registration Requirements

### 6.1 Purpose

**Registration requirements** are the market-wide conditions that a market party must satisfy to participate in the market at all, before product-specific eligibility is assessed.

Registration is assigned to **market eligibility** (Parte 3 §7.2), not to qualification (Parte 3 §8.2).

### 6.2 Registration Requirement Record

| Field | Description |
| --- | --- |
| **Registration Requirement ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Requirement type** | Market party registration / Participation agreement / Balance responsibility / Financial security / Other |
| **Requirement statement** | The requirement, in normative form |
| **Condition** | When the requirement applies |
| **Authority** | The entity that administers the requirement |
| **Assessment method** | How the requirement is assessed |
| **Assessment frequency** | One-time / Periodic / Continuous |
| **Consequence of failure** | What happens if the requirement is not satisfied |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 6.3 Registration vs. Product-Specific Eligibility

| Concept | Owner | Example |
| --- | --- | --- |
| **Registration requirement** | Parte 2 | "All market participants must register with the market operator" |
| **Product-specific eligibility condition** | Parte 3 | "The energy product requires a minimum power of 1 MW" |

Parte 2 defines the **market-wide registration requirements**; Parte 3 applies them and adds product-specific conditions.

### 6.4 Registration Categories

| Category | Description |
| --- | --- |
| **Market party registration** | Registration of the legal/commercial entity |
| **Participation agreement** | Agreement governing participation terms |
| **Balance responsibility** | Designation of a balance-responsible party |
| **Financial security** | Financial guarantees required for participation |
| **Technical registration** | Registration of the asset or portfolio |
| **Other** | As specified by the market |

---

## 7. Timing Conventions (Non-Signal)

### 7.1 Purpose

**Timing conventions** are market-wide rules for how time is structured, expressed, and related to delivery and settlement periods — excluding signal publication timing, which is owned by Parte 4.

### 7.2 Timing Convention Record

| Field | Description |
| --- | --- |
| **Timing Convention ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Convention type** | Bid window / Gate closure / Award / Commitment / Delivery / Settlement / Publication / Observation / Other |
| **Convention statement** | The timing convention, in normative form |
| **Relation to project time axis** | How the convention relates to the project time axis |
| **Duration rule** | How the duration is determined |
| **Boundary rule** | How period boundaries are determined |
| **Time zone reference** | Reference to the temporal framework instance (§11) |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 (non-signal conventions only) |
| **Uncertainty reference** | Link to §12 |

### 7.3 Timing Convention Categories

| Category | Description | Owner |
| --- | --- | --- |
| **Bid window convention** | How bid windows are structured | Parte 2 |
| **Gate closure convention** | How gate closure relates to delivery | Parte 2 |
| **Award timing convention** | When awards are published | Parte 2 |
| **Commitment timing convention** | When commitments form and expire | Parte 2 |
| **Delivery timing convention** | How delivery periods are structured | Parte 2 |
| **Settlement timing convention** | When settlement occurs | Parte 2 |
| **Publication timing convention (non-signal)** | When non-signal publications occur | Parte 2 |
| **Observation timing convention** | How observation times are defined | Parte 2 |
| **Signal publication timing** | When signals are published | **Parte 4** |

### 7.4 Timing vs. Temporal Framework Instance

| Concept | Owner | Example |
| --- | --- | --- |
| **Timing convention** | Parte 2 | "The delivery period is 15 minutes" |
| **Temporal framework instance** | Parte 2 | "The market's time zone is Europe/Madrid; intervals are interval-beginning; resolution is 15 minutes" |
| **Product-specific temporal value** | Parte 3 | "The energy product's delivery block is 1 hour" |

Parte 2 defines the **conventions and the framework instance**; Parte 3 applies them to specific products.

---

## 8. Data Formats and Telemetry Requirements

### 8.1 Purpose

**Data formats and telemetry requirements** are market-wide standards for how data is structured, transmitted, and received.

### 8.2 Data Format Requirement Record

| Field | Description |
| --- | --- |
| **Data Format Requirement ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Requirement type** | Data format / Telemetry standard / Communication protocol / Reporting format / Other |
| **Requirement statement** | The requirement, in normative form |
| **Standard reference** | The standard or specification referenced |
| **Applicability** | Which data streams or signals the requirement applies to |
| **Compliance method** | How compliance is demonstrated |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 8.3 Telemetry Requirement Categories

| Category | Description |
| --- | --- |
| **Data format** | Structure and encoding of market data |
| **Telemetry standard** | Real-time telemetry requirements (protocol, frequency, accuracy) |
| **Communication protocol** | How data is transmitted |
| **Reporting format** | Format for periodic reports |
| **Other** | As specified by the market |

### 8.4 Data Format vs. Telemetry Frequency

| Concept | Owner | Example |
| --- | --- | --- |
| **Data format standard** | Parte 2 | "Telemetry must use IEC 60870-5-104" |
| **Telemetry frequency during participation** | Parte 4 | "Telemetry must be reported every 4 seconds during participation" |

Parte 2 defines the **format standard**; Parte 4 defines the **ongoing frequency obligation**.

---

## 9. Transversal Minimum Participation Sizes

### 9.1 Purpose

**Transversal minimum participation sizes** are market-wide minimum sizes that apply across products.

### 9.2 Minimum Size Record

| Field | Description |
| --- | --- |
| **Minimum Size ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Participation unit** | MW, MWh, MVar, block, portfolio, etc. |
| **Minimum size** | The minimum size |
| **Unit** | The unit of the minimum size |
| **Applicability** | Which products the minimum applies to |
| **Condition** | When the minimum applies |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 9.3 Transversal vs. Product-Specific Minimum Sizes

| Concept | Owner | Example |
| --- | --- | --- |
| **Transversal minimum size** | Parte 2 | "All market participation requires a minimum of 100 kW" |
| **Product-specific minimum size** | Parte 3 | "The frequency containment reserve product requires a minimum of 1 MW" |

Parte 2 defines the **market-wide minimum**; Parte 3 defines **product-specific minimums**.

---

## 10. Transversal Aggregation Rules

### 10.1 Purpose

**Transversal aggregation rules** are market-wide rules for aggregating multiple assets or loads into a single participation unit.

### 10.2 Aggregation Rule Record

| Field | Description |
| --- | --- |
| **Aggregation Rule ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Rule statement** | The aggregation rule, in normative form |
| **Aggregation type** | Asset aggregation / Load aggregation / Portfolio aggregation / Other |
| **Permitted** | Yes / No / Conditional |
| **Conditions** | The conditions under which aggregation is permitted |
| **Geographic constraints** | Any geographic constraints on aggregation |
| **Technical constraints** | Any technical constraints on aggregation |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 10.3 Transversal vs. Product-Specific Aggregation

| Concept | Owner | Example |
| --- | --- | --- |
| **Transversal aggregation rule** | Parte 2 | "Aggregation is permitted across assets within the same bidding zone" |
| **Product-specific aggregation rule** | Parte 3 | "The frequency response product permits aggregation of up to 5 assets" |

Parte 2 defines the **market-wide aggregation rules**; Parte 3 defines **product-specific aggregation conditions**.

### 10.4 Aggregation vs. Allocation

| Concept | Owner |
| --- | --- |
| **Aggregation rules** (what is permitted) | Parte 2 (transversal) / Parte 3 (product-specific) |
| **Allocation decisions** (how capacity is allocated across products) | Operational/Optimization Engineering |

Parte 2 defines aggregation permissions; it does not make allocation decisions.

---

## 11. Temporal Framework Instance

### 11.1 Purpose

The **temporal framework instance** is the market-specific instantiation of the temporal framework owned by Parte 1 (Parte 1 §11). It carries the market-level temporal attributes that apply to all products in the market.

This resolves the ownership gap identified during Parte 3 review: the temporal framework instance (time zone, interval labeling, resolution) was previously unowned.

### 11.2 Temporal Framework Instance Record

| Field | Description |
| --- | --- |
| **Temporal Framework Instance ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Time zone identifier** | The market's time zone (e.g., Europe/Madrid) |
| **DST rule** | How DST is handled, including 23-hour and 25-hour days |
| **Interval labeling convention** | Interval-beginning / Interval-ending |
| **Resolution** | The market's temporal resolution (e.g., 15 minutes, 5 minutes) |
| **Relation to project time axis** | How the market time axis relates to the project time axis |
| **Conversion rule** | How market timestamps are converted to the project time axis, if at all |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 11.3 Temporal Framework Instance vs. Product-Specific Temporal Values

| Concept | Owner | Example |
| --- | --- | --- |
| **Temporal framework instance** | Parte 2 | "Europe/Madrid; interval-beginning; 15-minute resolution" |
| **Product-specific temporal value** | Parte 3 | "The energy product's bid window closes at 12:00" |

Parte 2 defines the **framework instance**; Parte 3 applies it to specific products.

### 11.4 Resolution Mapping

Where market data resolution differs from the project model resolution (e.g., 5-minute settlement data against a 15-minute model), Parte 2 shall define:

- the aggregation rule (for coarsening);
- the disaggregation rule (for refining);
- the requirement that an authoritative quantity be declared.

**Ownership:** Parte 2 owns the **mapping method**. Parte 5 **declares** the authoritative settlement quantity per product. Parte 5 owns the declared value; Parte 2 owns the requirement that it be declared and the method by which it is derived.

---

## 12. Eligibility-Relevant Transversal Limits

### 12.1 Purpose

**Eligibility-relevant transversal limits** are market-wide limits that affect eligibility assessment across products.

### 12.2 Transversal Limit Record

| Field | Description |
| --- | --- |
| **Transversal Limit ID** | Unique identifier |
| **Market environment** | Wholesale / BTM / Both |
| **Limit type** | Power / Energy / Duration / Response time / Other |
| **Limit statement** | The limit, in normative form |
| **Limit value** | The quantitative limit |
| **Unit** | The unit of the limit |
| **Applicability** | Which products the limit applies to |
| **Condition** | When the limit applies |
| **Evidence reference** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Owner** | Parte 2 |
| **Uncertainty reference** | Link to §12 |

### 12.3 Eligibility-Relevant vs. Non-Eligibility-Relevant Limits

| Concept | Owner | Example |
| --- | --- | --- |
| **Eligibility-relevant transversal limit** | Parte 2 | "All resources must have a minimum response time of 1 second" |
| **Operational network constraint** | Parte 4 | "Export is limited to 10 MW during participation" |
| **Site/interconnection capability** | Parte 1 (definition); P1-O14 pending; consumed by Parte 3 | "Interconnection export cap is 20 MW" |

Parte 2 defines **eligibility-relevant transversal limits**; Parte 4 defines **operational constraints**.

---

## 13. Transversal Value Uncertainty

### 13.1 Uncertainty Ownership

Per Parte 1 §18, Parte 2 owns:

- **transversal value uncertainty**;
- **eligibility-path transversal value uncertainty**;
- **temporal framework instance uncertainty**;
- **registration requirement uncertainty** (transversal portion).

### 13.2 Uncertainty Record Structure

| Field | Description |
| --- | --- |
| **Uncertainty ID** | Unique identifier |
| **Type** | Gate closure / Registration / Timing / Data format / Minimum size / Aggregation / Transversal limit / Temporal framework |
| **Description** | The uncertainty |
| **Affected records** | Which transversal values are affected |
| **Source** | Linked Evidence Statement ID (Parte 1 §16.3) |
| **Impact** | Qualitative scale (Low / Medium / High) |
| **Likelihood** | Qualitative scale (Low / Medium / High) |
| **Mitigation** | How the uncertainty is mitigated |
| **Owning Part** | Parte 2 |

### 13.3 Long-Horizon Uncertainty

Regulatory and market-rule changes over the asset life are **long-horizon uncertainty** (Parte 1 §18). Parte 2 shall record such changes with effective dates on the evidence records (Parte 1 §16.2).

---

## 14. Interfaces

### 14.1 Parte 1 — Market Domain and Conventions

**Consumes:** market environment and scope; participant-role model; semantic model; temporal framework; evidence model; ownership table; price-influence assumption; grid/network constraint classification.

**Provides:** transversal value feedback; proposed changes via change control.

### 14.2 Parte 3 — Market Products and Participation

**Provides to Parte 3:**

- market-wide gate closure conventions;
- market-wide registration requirements;
- market-wide timing conventions (non-signal);
- market-wide data formats and telemetry requirements;
- market-wide minimum participation sizes, where transversal;
- market-wide aggregation rules, where transversal;
- eligibility-relevant transversal limits;
- the temporal framework instance.

**Consumes from Parte 3:** feedback on transversal values encountered during product population; proposed additions via change control.

### 14.3 Parte 4 — Market Rules, Signals, Commitments and Constraints

**Provides to Parte 4:**

- transversal values referenced by Parte 4 rules;
- transversal limits referenced by Parte 4 constraints.

**Consumes from Parte 4:** feedback on transversal values encountered during rule definition; proposed amendments via change control.

**Boundary rule:** Signal publication timing and signal-specific timing are owned by Parte 4, not Parte 2. Where Parte 4 finds a transversal value on the eligibility path that Parte 2 missed, Parte 4 proposes a Parte 2 amendment via change control.

### 14.4 Parte 5 — Delivery, Performance and Settlement

**Provides to Parte 5:**

- transversal timing values referenced by delivery and settlement definitions;
- the temporal framework instance for settlement timing.

**Consumes from Parte 5:** feedback on transversal timing values encountered during settlement definition.

### 14.5 BESS Engineering

**Consumes from BESS:** project-wide temporal conventions; project-wide units; master symbol registry.

**Provides to BESS:** feedback on temporal conventions encountered during transversal value definition.

### 14.6 Software Engineering

**Provides:** transversal value structures; gate closure convention structure; registration requirement structure; timing convention structure; data format structure; minimum size structure; aggregation rule structure; transversal limit structure; temporal framework instance structure.

### 14.7 Network Engineering

**Network Engineering** is defined in the **Introduction (v1.3)**. Parte 2 references it where transversal limits depend on network-side evidence. Until Introduction v1.3 is issued, the Network Operator role and BESS Engineering jointly perform these functions.

---

## 15. Parte 2 Open Items

| ID | Open item | Required outcome | Owner | Priority | Blocking dependency | Target date |
| --- | --- | --- | --- | --- | --- | --- |
| P2-O01 | Gate closure conventions | Gate closure conventions defined for the applicable market | Parte 2 Lead | Critical | Depends on P1-O01–P1-O03 | TBD |
| P2-O02 | Registration requirements | Registration requirements defined for the applicable market | Parte 2 Lead | Critical | Depends on P1-O01–P1-O03 | TBD |
| P2-O03 | Timing conventions (non-signal) | Timing conventions defined for the applicable market | Parte 2 Lead | High | Depends on P1-O01–P1-O03 | TBD |
| P2-O04 | Data formats and telemetry | Data format and telemetry requirements defined | Parte 2 Lead | High | Depends on P1-O01–P1-O03 | TBD |
| P2-O05 | Transversal minimum sizes | Transversal minimum participation sizes defined | Parte 2 Lead | High | Depends on P1-O01–P1-O03 | TBD |
| P2-O06 | Transversal aggregation rules | Transversal aggregation rules defined | Parte 2 Lead | High | Depends on P1-O01–P1-O03 | TBD |
| P2-O07 | Eligibility-relevant transversal limits | Eligibility-relevant transversal limits defined | Parte 2 Lead | High | Depends on P1-O01–P1-O03 | TBD |
| P2-O08 | Temporal framework instance | Temporal framework instance defined (time zone, interval labeling, DST, resolution) | Parte 2 Lead | Critical | Depends on P1-O01–P1-O03 | TBD |
| P2-O09 | Evidence sources | Authoritative source set for transversal values established | Parte 2 Lead | High | Depends on P1-O09 | TBD |
| P2-O10 | Uncertainty records | Uncertainty records defined per transversal value | Parte 2 Lead | Medium | Depends on P2-O01–P2-O08 | TBD |
| P2-O11 | Parte 1 feedback | Feedback on transversal values encountered during Parte 1 population | Parte 2 Lead | Medium | Depends on P2-O01–P2-O08 | TBD |
| P2-O12 | BESS temporal conventions | BESS Engineering Part 1 temporal conventions confirmed | BESS Engineering + Parte 2 Lead | High | Depends on P1-O13 | TBD |

**Critical path:** P2-O01–P2-O03 (gate closure, registration, timing) block most items. P2-O08 (temporal framework instance) is critical for Parte 3 temporal requirements. P2-O12 (BESS temporal conventions) blocks the temporal framework instance.

**Blocking note:** Parte 2 cannot be written until P1-O01–P1-O03 (jurisdiction, operator, wholesale/BTM) are resolved. These are the **single blocking decision** for the entire Market Engineering sequence.

---

## 16. Parte 2 Validation Criteria

Each validation category specifies **method**, **reference case**, **reviewer**, and **pass/fail condition**.

### Gate Closure Validation

- **Method:** Comparison against authoritative market documentation.
- **Reference case:** Market documentation for the applicable jurisdiction.
- **Reviewer:** Parte 2 Lead + independent reviewer.
- **Pass condition:** Each gate closure convention has an evidence source, a relation to the delivery period, a modification rule, and a late-submission rule. Product-specific gate closure values are not defined in Parte 2.

### Registration Validation

- **Method:** Comparison against market documentation and participation agreements.
- **Reference case:** Market documentation.
- **Reviewer:** Parte 2 Lead.
- **Pass condition:** Each registration requirement has an authority, an assessment method, an assessment frequency, and a consequence of failure. Registration is correctly assigned to market eligibility, not qualification.

### Timing Validation

- **Method:** Comparison against market documentation and BESS Engineering Part 1 temporal conventions.
- **Reference case:** Market documentation; BESS Engineering Part 1 (pinned version).
- **Reviewer:** Parte 2 Lead + BESS Engineering.
- **Pass condition:** Each timing convention has a relation to the project time axis, a duration rule, and a boundary rule. Signal publication timing is **not** in Parte 2.

### Data Format Validation

- **Method:** Comparison against market documentation and technical standards.
- **Reference case:** Market documentation; technical standards.
- **Reviewer:** Parte 2 Lead + Software Engineering.
- **Pass condition:** Each data format requirement has a standard reference, an applicability, and a compliance method. Ongoing telemetry frequency is **not** in Parte 2 (it is in Parte 4).

### Minimum Size Validation

- **Method:** Comparison against market documentation.
- **Reference case:** Market documentation.
- **Reviewer:** Parte 2 Lead.
- **Pass condition:** Each minimum size has a participation unit, a value, and an applicability. Product-specific minimum sizes are not defined in Parte 2.

### Aggregation Validation

- **Method:** Comparison against market documentation.
- **Reference case:** Market documentation.
- **Reviewer:** Parte 2 Lead.
- **Pass condition:** Each aggregation rule has a permitted status, conditions, and constraints. Allocation decisions are not made in Parte 2.

### Transversal Limit Validation

- **Method:** Comparison against market documentation and network documentation.
- **Reference case:** Market documentation; network documentation.
- **Reviewer:** Parte 2 Lead + Network Engineering.
- **Pass condition:** Each transversal limit has a limit type, a value, an applicability, and a condition. Eligibility-relevant limits are in Parte 2; operational constraints are in Parte 4.

### Temporal Framework Instance Validation

- **Method:** Test cases covering time-zone boundaries, interval labeling, DST handling, and resolution mismatch.
- **Reference case:** Market documentation; BESS Engineering Part 1 temporal conventions.
- **Reviewer:** Parte 2 Lead + BESS Engineering.
- **Pass condition:** The temporal framework instance correctly specifies time zone, interval labeling, DST handling, and resolution. All applicable test cases produce the expected mapping.

### Boundary Validation

- **Method:** Interface review with Parte 1, Parte 3, Parte 4, Parte 5, BESS, Software, Network Engineering.
- **Reference case:** Interface definitions in §14.
- **Reviewer:** Cross-domain review board.
- **Pass condition:** No responsibility is claimed by two domains; no responsibility is unowned; no signal and no signal publication timing is in Parte 2; no product-specific value is in Parte 2.

### Evidence Validation

- **Method:** Traceability audit (Parte 1 §16.4).
- **Reference case:** Critical-path evidence set.
- **Reviewer:** Independent evidence reviewer.
- **Pass condition:** Every material transversal value has a complete Statement Record and at least one complete Source Record. Tier-1 statements have at least one Verified Rule source.

### Consistency Validation

- **Method:** Symbol, identifier, and convention audit.
- **Reference case:** BESS Engineering Part 1 (pinned version), Parte 1 v1.3, Introduction v1.2.
- **Reviewer:** BESS Engineering + Parte 2 Lead.
- **Pass condition:** No conflicting symbols, identifiers, units, or temporal conventions; no Parte 1, Parte 3, Parte 4, or Parte 5 concept is redefined in Parte 2; all uncertainty references resolve to §13.

---

## 17. Parte 2 Acceptance Criteria

Parte 2 is ready for engineering freeze when:

- gate closure conventions are defined for the applicable market;
- registration requirements are defined, with authorities, assessment methods, and consequences;
- timing conventions (non-signal) are defined;
- data format and telemetry requirements are defined;
- transversal minimum participation sizes are defined;
- transversal aggregation rules are defined;
- eligibility-relevant transversal limits are defined;
- the temporal framework instance (time zone, interval labeling, DST handling, resolution) is defined;
- no signal and no signal publication timing is in Parte 2;
- no product-specific value is in Parte 2;
- no operational constraint is in Parte 2 (they are in Parte 4);
- uncertainty records are defined per transversal value;
- interfaces with Parte 1, Parte 3, Parte 4, Parte 5, BESS, Software, and Network Engineering are defined;
- all required market symbols are registered through BESS Engineering Part 1;
- no independent market symbol authority exists;
- open items have been resolved or explicitly accepted as controlled assumptions, with owners, priorities, dependencies, and dispositions recorded;
- validation criteria have been satisfied with documented method, reference case, reviewer, and pass/fail result.

---

## 18. Parte 2 Maturity

Parte 2 follows the project-wide maturity ladder:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

Current status:

- **Semantic Definition — established (framework)**
- **Internal Consistency — ready for validation**
- **External Evidence — pending P1-O01–P1-O03 (jurisdiction, operator, wholesale/BTM)**
- **Engineering Validation — pending**
- **Frozen — No**

**Status note on sequencing.** Parte 2 is the **next engineering activity** after Parte 1. It cannot be written until P1-O01–P1-O03 are resolved. Once those are resolved, Parte 2 can be populated from authoritative market documentation, and Parte 3 can proceed.

**Status note on diminishing returns.** The Parte 2 framework is complete as of v1.0. The remaining work is populating transversal values from authoritative market documentation. Further abstract iteration on the framework will add little. The next real gain is **External Evidence**, which is blocked on P1-O01–P1-O03.

---

## 19. Output of Parte 2

The final output of Parte 2 shall be a controlled **Transversal Market Values Specification** containing:

1. gate closure conventions;
2. registration requirements;
3. timing conventions (non-signal);
4. data formats and telemetry requirements;
5. transversal minimum participation sizes;
6. transversal aggregation rules;
7. eligibility-relevant transversal limits;
8. temporal framework instance (time zone, interval labeling, DST handling, resolution);
9. uncertainty records per transversal value;
10. registered market symbols through BESS Part 1;
11. resolved assumptions and open-item disposition.

This output becomes the formal transversal values foundation for:

**Parte 3 — Market Products and Participation**

which will then answer the next engineering question:

> **Which specific products and participation mechanisms exist within the defined market environment, and under what eligibility and qualification conditions can the BESS participate?**

---

*End of Parte 2 — Transversal Market Values (v1.0)*