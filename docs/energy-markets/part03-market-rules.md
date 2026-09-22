# M3b — Market Rules, Signals, Commitments and Constraints

**Version:** 1.3 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Parent Document:** Market Engineering Model — Introduction Document (v1.2)
**Upstream Dependencies:**
- M1 — Market Domain and Conventions (v1.2), specifically §8, §9, §11, §12, §13, §14, §16, §19
- M3a — Transversal Market Values (frozen before M2; scope limited to the eligibility path)
- M2 — Market Products and Participation (v1.2), specifically §5 (Product-Mechanism), §6 (product sheet), §8–§11 (eligibility, qualification, mapping, temporal)
- BESS Engineering Part 1 — Fundamentals and Conventions (pinned per M1-O13)

**Scope note:** This document is **M3b — Full Rules, Signals, Commitments and Constraints**. The **M3a — Transversal Market Values** early baseline is a separate, earlier-frozen deliverable established by Introduction v1.2. **M3a is limited to values M2 needs to evaluate eligibility before it freezes.** Signals, signal timing, publication timing, settlement prices, and market-wide publications are **not** in M3a; they are in M3b.

**Document ID:** ME-M3b-001 *(stable across versions)*

---

## Revision History

| Version | Date | Status | Change |
| --- | --- | --- | --- |
| 1.0 | 2026-09-22 | Development Draft | Initial M3b baseline. |
| 1.1 | 2026-09-22 | Development Draft | Resolved the M2/M3b threshold ownership overlap; separated commitment definitions from instances; added bids, nominations, and awards; separated stacking constraints from allocation decisions; classified network limits; marked settlement rules as reference-only; defined Network Engineering provisionally; corrected title and renumbering. |
| 1.2 | 2026-09-22 | Development Draft | Corrected threshold routing; moved all signals to M3b; reclassified interconnection caps as site/interconnection capability; simplified the Commitment Instance record to formation data only; defined branch 2 instance rules; moved Network Engineering to Introduction v1.3; fixed uncertainty references. |
| 1.3 | 2026-09-22 | Development Draft | **Branch 2 continuous commitments now create one long-lived instance per enrollment.** **Site/interconnection value ownership made explicit in M1-O14.** **Added M3b-O17 (Award simulation rule).** **Corrected the rule record Owner field.** **Kept Cancelled as an M3b state and corrected §8.2.** **Assigned market-wide signal publication timing to M3b (removed from M3a).** **Corrected the §6.4 example to use Product-Mechanism naming.** |

**Change control note:** The M3 split into M3a (Transversal Market Values) and M3b (Full Rules) is owned by **Introduction v1.2**. The canonical lifecycle, the optional-node rule, the null-commitment path rule, and the M2 template reference rule are owned by **Introduction v1.2**. **Network Engineering as an engineering domain is owned by Introduction v1.3.** M3b applies them. Where M3b and the Introduction differ, the Introduction governs.

**Pending change requests:**

- **Introduction v1.3** — Add Network Engineering as an engineering domain.
- **M1-O14** — Define the entity that owns site/interconnection capability **and its value owner**.

---

## 1. Purpose and Scope

M3b establishes the **operational market layer** for Market Engineering.

Its purpose is to define, per **Product-Mechanism**:

- **market rules** that govern participation, operation, and delivery (settlement rules are referenced from M4, not defined here);
- **bids, nominations, and awards** — the submission, evaluation, and recognition of participation for bid-based mechanisms;
- **market signals** published by the market and their semantics, timing, and observation relationships — **all signals, including market-wide signals, are defined here, including their publication timing**;
- **commitment definitions and commitment instances** — what a commitment is, how it arises, what it obliges, and what quantity it carries;
- **operational obligations** arising from participation, with threshold ownership assigned by kind;
- **stacking and coexistence constraints** — what is permitted, forbidden, or constrained across Product-Mechanisms; allocation decisions are not made here;
- **grid and network constraints** that affect market participation or operational obligations, except **site/interconnection capability**, which is consumed by M2's capability mapping (pending M1-O14);
- **rule-specific uncertainty** owned by M3b.

M3b does **not** define:

- product definitions, eligibility, qualification, capability mappings, or product-specific temporal requirements (M2);
- transversal market values on the eligibility path (M3a);
- settlement rules, delivery definition, performance measurement, scoring thresholds, or baselines (M4);
- the Asset Dispatch Decision, operating trajectories, or delivered quantities (Operational/Optimization Engineering);
- capacity, energy, or reserve allocation decisions across Product-Mechanisms (Operational/Optimization Engineering);
- the physical BESS model (BESS Engineering);
- site/interconnection capability or its value (M1 definition; value owner pending M1-O14; consumed by M2);
- the forecast methodology for market variables (Forecasting Engineering);
- the economic valuation of market outcomes (Financial Engineering).

M3b defines **what the market requires, signals, and obliges** — and references M4 for how delivery is measured, scored, and settled.

The primary question of M3b is:

> **What rules govern participation in each Product-Mechanism, how are bids and awards handled, what signals does the market publish, how are commitments formed and satisfied, and what constraints apply?**

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
(eligibility path only,
frozen before M2)
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

**Freeze order:** M1 → M3a → M2 → **M3b** → M4.

M3b is drafted **after M2 freezes**. M4 is drafted after M3b.

**Sequencing note:** If M3a does not yet exist, M3b is out of sequence by its own rules. M3a is the document that blocks the M2 freeze and should be drafted first. M3b is held until M3a exists.

### 2.2 Consumes and Provides

**M3b consumes from M1:** market semantic model (three branches); temporal framework; evidence model; semantic ownership; uncertainty ownership; the **site/interconnection capability** definition and value ownership (pending M1-O14).

**M3b consumes from M3a:** market-wide gate closure conventions; registration requirements; **timing conventions other than signal publication timing**; data formats; transversal minimum sizes; transversal aggregation rules; **eligibility-relevant transversal limits**. **M3a does not provide signals or signal publication timing.**

**M3b consumes from M2:** product identifiers; Product-Mechanism records; eligibility and qualification references; capability mappings; Product-Mechanism temporal requirements; product-level risks.

**M3b provides to M4:** commitment definitions; delivery-obligation definitions; signal definitions and timing; operational obligations; constraint definitions relevant to delivery; baseline/counterfactual trigger conditions where market-defined.

**M3b provides to Operational/Optimization Engineering:** market rules; commitments and commitment instances (formation data); operational obligations; stacking constraints; delivery requirements (obligation side); relevant grid/network constraints; signal semantics.

**M3b provides to Forecasting Engineering:** signal definitions; price and signal semantics; publication and observation timing; market-data requirements; relevant uncertainty definitions.

**M3b does not create an independent symbol registry.** Market-specific **symbols** are registered in the BESS Engineering Part 1 master symbol registry (M1 §20). **Identifiers** are governed by M1's identifier scheme.

### 2.3 Ownership Boundary by Kind of Rule

The ownership boundary is defined **by kind of rule**, not by the product-specific/transversal distinction:

| Kind of rule | Owner | Examples |
| --- | --- | --- |
| **Eligibility rules** | M2 | Registration for a Product-Mechanism; minimum power; SOC window |
| **Qualification rules** | M2 | Tests; evidence submissions; ongoing compliance; re-qualification |
| **Temporal values** (product-specific) | M2 | Bid window duration; delivery block length |
| **Temporal values** (transversal, non-signal) | M3a | Market-wide gate closure; market-wide registration timing |
| **Eligibility-relevant transversal limits** | M3a | Transversal minimum participation sizes |
| **Site/interconnection capability** | M1 (definition and value ownership, pending M1-O14); M2 (consumption) | Interconnection export cap |
| **Participation rules** (bid submission, gate closure mechanics, award) | M3b | Bid structure; award publication; partial award |
| **Operational rules** | M3b | Response; ramp; telemetry reporting; availability during participation |
| **Ongoing obligation thresholds** | M3b | Monthly availability; outage notification lead time; reporting frequency |
| **Commitment rules** | M3b | Formation; obligation; satisfaction |
| **Signal definitions** | M3b | DA price; activation signal; imbalance price; system price |
| **Signal publication timing** | M3b | When a signal is published |
| **Stacking constraints** | M3b | No double-counting; minimum headroom |
| **Grid/network constraints** (non-eligibility-relevant) | M3b | Operational export limits during participation |
| **Delivery scoring thresholds** | M4 | Regulation accuracy score |
| **Settlement rules** | M4 | DA price × awarded; imbalance settlement |

**Threshold routing rule (normative):**

> **Where M2 or M3a owns a threshold, M3b references it by ID. Where a threshold is an ongoing obligation not owned by M2 or M3a, M3b owns it. Where a threshold is used to score delivery, M4 owns it, and M3b references it.**

M3b shall not require an M2 amendment for thresholds that are not eligibility or qualification conditions.

**Publication timing rule (normative):**

> **Signal publication timing is owned by M3b.** M3a owns transversal market timing conventions that are not signal-specific (e.g., registration windows, market-wide gate closure). Where a timing is signal-specific — including market-wide signal publication — M3b owns it.

**Reference rule:** Where a rule's threshold is already owned by M2, M3a, or M4, M3b **references** it by ID. M3b does not restate it.

### 2.4 What M3b Does Not Inherit from M3a

Where M3b finds a value that is transversal and on the **eligibility path** but was not in M3a, M3b shall **propose an M3a amendment** through change control. Where the value is not on the eligibility path, M3b owns it.

---

## 3. Intent

### 3.1 WHAT

M3b represents the operational market layer as a structured set of:

- **Market rules** — participation, operational, commitment, delivery, stacking, constraint;
- **Bids, nominations, and awards** — submission, evaluation, recognition;
- **Market signals** — price signals, requirement signals, activation signals, availability signals, operator dispatch instructions, tariff signals, publication signals;
- **Commitment definitions** — the template for what any award in a Product-Mechanism obliges;
- **Commitment instances** — runtime commitments with quantities, directions, prices, and periods, carrying **formation data only**;
- **Operational obligations** — telemetry, availability, response, standing obligations, with threshold ownership assigned by kind;
- **Stacking constraints** — what is permitted, forbidden, or constrained across Product-Mechanisms;
- **Grid and network constraints** — non-eligibility-relevant constraints;
- **Rule-specific uncertainty** — market-rule, signal, market-data, commitment, and operational-constraint uncertainty.

### 3.2 WHY

The purpose is to prevent downstream engineering from treating the market's operational layer as an undifferentiated set of prices and instructions, and to prevent the same threshold from being owned twice.

A market must be represented as a system in which:

- **rules** are distinct from **products** and from **eligibility** (M1 §9);
- **signals** have defined semantics, timing, and observation relationships (M1 §13);
- **signals are defined in one place**, regardless of how many Product-Mechanisms they serve;
- **commitments** are distinct from **opportunities** and from **Asset Dispatch Decisions** (M1 §10);
- **commitment definitions** are distinct from **commitment instances**;
- **commitment instances** carry formation data; assessment data is owned by M4;
- **continuous enrollments and standing obligations** create one long-lived instance that carries quantity and period;
- **stacking constraints** are distinct from **allocation decisions**;
- **grid/network constraints** are distinguished from market rules (M1 §14);
- **site/interconnection capability** is distinguished from both market rules and BESS physical constraints, and has an explicit value owner.

### 3.3 FOR WHOM

M3b provides the operational market foundation for M4, Operational/Optimization Engineering, Forecasting Engineering, Financial Engineering, and Software Engineering.

---

## 4. Market Rules

### 4.1 Rule Definition

A **market rule** is an externally defined condition governing participation, operation, or delivery. Settlement rules are referenced from M4, not defined here.

### 4.2 Rule Categories

| Category | Description | Owner |
| --- | --- | --- |
| **Participation rules** | Bid submission, nomination, enrollment, gate closure mechanics, award | M3b |
| **Operational rules** | Response, ramp, telemetry reporting, availability during participation | M3b |
| **Commitment rules** | Formation, obligation, satisfaction | M3b |
| **Delivery rules** | Delivery obligation definition (referenced by M4 for measurement) | M3b |
| **Stacking constraints** | What is permitted, forbidden, or constrained across Product-Mechanisms | M3b |
| **Grid/network constraints** | Non-eligibility-relevant constraints | M3b |
| **Settlement rules** | **Reference-only** — defined by M4 | M4 |

### 4.3 Rule Record Structure

| Field | Description |
| --- | --- |
| **Rule ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism to which the rule applies |
| **Category** | Participation / Operational / Commitment / Delivery / Stacking / Constraint |
| **Rule statement** | The rule, in normative form |
| **Condition** | When the rule applies |
| **Obligation** | What the rule requires |
| **Threshold reference** | Reference to the M2, M3a, or M4 record that owns the threshold, where applicable. Where M3b owns the threshold, state the value here. |
| **Consequence of breach** | What happens if the rule is breached |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | **M3b; M2, M3a, and M4 thresholds referenced** |
| **Settlement reference** | Link to M4 settlement rule, where applicable |
| **Uncertainty reference** | Link to **§13** if the rule is uncertain |

### 4.4 Rule Ownership

- **Eligibility, qualification, and temporal values** → **M2** (referenced by M3b).
- **Eligibility-path transversal values** → **M3a** (referenced by M3b).
- **Participation, operational, commitment, delivery, stacking, and non-eligibility-relevant constraint rules** → **M3b**.
- **Ongoing obligation thresholds** → **M3b**.
- **Delivery scoring thresholds** → **M4** (referenced by M3b).
- **Settlement rules** → **M4** (referenced by M3b).

### 4.5 Rule Conflicts

Where two rules conflict:

1. Regulatory requirements override market rules.
2. Market-operator rules override contractual arrangements.
3. Product-Mechanism-specific rules override general rules where they are more specific and do not contradict a higher-authority rule.
4. Conflicts shall be recorded as **unresolved requirements** (M1 §16.1) and escalated through change control.

---

## 5. Bids, Nominations, and Awards

### 5.1 Purpose

This section defines the submission, evaluation, and recognition of participation for **branch 1 (bid-based)** mechanisms. For branch 2 (non-bid commitment) and branch 3 (null commitment), participation arises without a bid; the formation trigger is defined in §7 and §8.

### 5.2 Bid

A **bid** is a participant-submitted representation of intended participation.

| Field | Description |
| --- | --- |
| **Bid ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Submission window** | Start and end of the submission window (references M2 temporal requirements and M3a transversal values) |
| **Bid structure** | Quantity, price, direction, block, portfolio |
| **Quantity** | The quantity offered |
| **Unit** | The unit of the quantity |
| **Price** | The price offered (where applicable) |
| **Direction** | Up / Down / Symmetric |
| **Validity** | The period the bid applies to |
| **Constraints** | Any constraints on the bid (minimum size, maximum size) |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M3b |

### 5.3 Nomination

A **nomination** is a participant-submitted declaration of intended participation where the market uses nomination instead of, or in addition to, bidding.

Same fields as a bid, with:

- **Nomination ID** instead of Bid ID;
- **Declaration** instead of Price, where the mechanism is quantity-only.

### 5.4 Award

An **award** is a market-recognized allocation resulting from a bid, nomination, or other participation mechanism.

| Field | Description |
| --- | --- |
| **Award ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Source** | Bid ID / Nomination ID / Enrollment ID / Instruction ID |
| **Awarded quantity** | The quantity awarded |
| **Unit** | The unit of the awarded quantity |
| **Awarded price** | The price at which the award is made (where applicable) |
| **Direction** | Up / Down / Symmetric |
| **Award period** | The period the award applies to |
| **Publication time** | When the award is published |
| **Acceptance required** | Yes / No |
| **Acceptance window** | The window during which acceptance is required, if applicable |
| **Partial award** | Whether partial awards are permitted, and the rule |
| **Commitment created** | **Reference to Product-Mechanism record** — the record states whether the mechanism creates a commitment |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M3b |

### 5.5 Award → Commitment

Where the Product-Mechanism record has **Commitment created = Yes** and the commitment trigger is **Award**, an award creates a **Commitment Instance** (§8). The Commitment Definition (§7) defines the obligation; the Commitment Instance carries the awarded quantity and period.

### 5.6 Partial Awards and Rejections

Where the market permits partial awards, the award record shall carry the **Partial award** field. Where the market rejects a bid or nomination, the rejection shall be recorded as an **award outcome** with zero awarded quantity and a **rejection reason**.

### 5.7 Branch 2 Source Records

For branch 2 mechanisms that create a **discrete instruction**, the instruction record shall be defined in M3b with the same structure as an award. For branch 2 mechanisms that are **continuous** (standing obligation, continuous enrollment), an **Enrollment Record** shall be defined in M3b carrying the enrollment quantity and period. The enrollment creates one long-lived Commitment Instance (§8.4).

---

## 6. Market Signals

### 6.1 Signal Definition

A **market signal** is an externally defined quantity, instruction, status, or condition whose meaning is established by the market environment.

M1 establishes the generic signal concept (M1 §13). **M3b defines all market signals, including market-wide signals, and their publication timing.** Signals and signal publication timing are not defined in M3a.

### 6.2 Signal Categories

| Category | Description | Examples |
| --- | --- | --- |
| **Price signals** | Prices published by the market | Day-ahead price, real-time price, imbalance price, system price |
| **Requirement signals** | Quantities the market requires | Reserve requirement |
| **Activation signals** | Instructions to activate a service | Regulation up/down, frequency response activation |
| **Availability signals** | Status of market availability | Available, unavailable, derated |
| **Dispatch instructions** | Operator-issued instructions (**Operator Dispatch Instruction**) | Manual dispatch, emergency dispatch |
| **Tariff signals** | Tariff-based price signals | Energy tariff, demand tariff, export tariff |
| **Publication signals** | Market data publications | Settlement data, system status |

### 6.3 Signal Record Structure

| Field | Description |
| --- | --- |
| **Signal ID** | Unique identifier |
| **Product-Mechanism IDs** | The Product-Mechanisms the signal serves (many-to-many, see §6.4). May be empty for market-wide signals that are not yet linked. |
| **Category** | Price / Requirement / Activation / Availability / Dispatch instruction / Tariff / Publication |
| **Semantic meaning** | What the signal means |
| **Direction** | Up / Down / Symmetric / Not applicable |
| **Unit** | The unit of the signal |
| **Publication time** | When the signal is published (**M3b-owned**) |
| **Observation time** | The time the signal refers to |
| **Valid window** | The period during which the signal applies |
| **Resolution** | The temporal resolution of the signal |
| **Publication channel** | Where the signal is published |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | **M3b** (all signals, including publication timing) |
| **Uncertainty reference** | Link to **§13** |

### 6.4 Signal Scope

**Signals are many-to-many with Product-Mechanisms.**

- A signal that serves **multiple Product-Mechanisms** is recorded **once** in M3b with multiple Product-Mechanism references.
- A **market-wide signal** (imbalance price, system price, settlement-data publication) is recorded **once** in M3b with the full set of Product-Mechanism references, or with an empty set if not yet linked.
- **Signals are not in M3a. Signal publication timing is not in M3a.**

**Example (many-to-many):** The day-ahead price serves `Energy/DA`, `Reserve/DA`, and `Capacity/DA`. It is recorded once, with three Product-Mechanism references.

**Example (Product-Mechanism-specific):** The activation signal for `Regulation/FRR` is recorded with a single Product-Mechanism reference.

**Naming note:** Product-Mechanisms are named as `<Product>/<Mechanism>`, not as separate products. "Day-Ahead Energy" is `Energy/DA`; "Day-Ahead Reserve" is `Reserve/DA`; "Day-Ahead Capacity" is `Capacity/DA`.

### 6.5 Operator Dispatch Instruction

The **Operator Dispatch Instruction** is the market signal issued by the market or system operator that instructs the asset to operate. It is distinct from the **Asset Dispatch Decision**, which is the asset's response (owned by Operational/Optimization Engineering, M1 §13.1).

### 6.6 Signal Timing

Signals have **observation time**, **publication time**, and **valid window**. These are distinct from **market periods** (M1 §11).

The semantic boundary (M1 §13.2) is:

> **Market defines what a signal means; Forecasting defines how it is predicted.**

### 6.7 Signal Ownership

- **Signal semantics, timing, and publication timing** → **M3b** (all signals).
- **Signal prediction** → Forecasting Engineering.
- **Signal observation and use in delivery assessment** → M4.

---

## 7. Commitment Definitions

### 7.1 Definition vs. Instance

A **Commitment Definition** is the template for what any award, enrollment, or instruction in a Product-Mechanism obliges.

A **Commitment Instance** (§8) is a runtime commitment created by a specific award, enrollment, or instruction, carrying the quantity, direction, price, and period of that specific participation.

Commitment Definitions are **static** (per Product-Mechanism). Commitment Instances are **runtime data** (per participation event).

### 7.2 Commitment Formation

A commitment may arise from:

- an awarded bid (branch 1);
- an accepted nomination (branch 1);
- a mandatory-provision or enrollment-based mechanism (branch 2);
- an operator dispatch instruction (branch 2);
- a standing obligation (branch 2);
- another market-defined mechanism.

The **formation trigger** is defined per Product-Mechanism in the **Commitment Definition**.

### 7.3 Commitment Types

| Type | Description |
| --- | --- |
| **Energy commitment** | Obligation to deliver (or consume) a quantity of energy in a defined period |
| **Capacity commitment** | Obligation to be available to provide a service |
| **Reserve commitment** | Obligation to hold a quantity of reserve |
| **Regulation commitment** | Obligation to follow a regulation signal |
| **Activation commitment** | Obligation to respond to an activation instruction |
| **Availability commitment** | Obligation to be available within a defined window |
| **Standing obligation** | Obligation to be available or to respond on an ongoing basis |
| **Null commitment** | No obligation; the asset may respond to price or signal without a commitment |

**Commitment type is stored, not derived.** The trigger (award, enrollment, instruction) does not determine whether the obligation is energy, capacity, reserve, or regulation.

**"Standing obligation"** is a **commitment type**, not a formation trigger. The formation trigger for a standing obligation is **standing obligation** (the participation mechanism). This distinction shall be preserved.

### 7.4 Commitment Definition Record

For each Product-Mechanism, M3b shall define a **Commitment Definition**:

| Field | Description |
| --- | --- |
| **Commitment Definition ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Commitment type** | See §7.3 |
| **Formation trigger** | What creates the commitment (award, enrollment, instruction, standing obligation) |
| **Formation time** | When the commitment forms |
| **Obligation** | What the commitment obliges the asset to do |
| **Obligation window** | The period during which the obligation applies |
| **Satisfaction condition** | What satisfies the commitment (referenced to M4 for assessment) |
| **Partial satisfaction rule** | What happens if the commitment is partially satisfied (referenced to M4 for assessment) |
| **Non-satisfaction consequence** | What happens if the commitment is not satisfied (referenced to M4 settlement) |
| **Reversibility** | Whether the commitment can be withdrawn or adjusted, and under what conditions |
| **Instance lifetime** | Short-lived (per award or instruction) / Long-lived (per enrollment or standing obligation) |
| **M4 delivery reference** | Link to the M4 delivery definition for this commitment |
| **M4 settlement reference** | Link to the M4 settlement mechanism for this commitment |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M3b |
| **Uncertainty reference** | Link to **§13** |

### 7.5 Commitment vs. Dispatch

The distinction (M1 §10) shall be preserved:

- **Commitment Definition / Instance** — market-recognized obligation. Owned by M3b (definition and formation data).
- **Asset Dispatch Decision** — the operational decision. Owned by Operational/Optimization Engineering.
- **Delivery assessment and satisfaction status** — owned by M4.

The **delivery obligation** is part of the commitment. The **delivery definition and measurement** is owned by M4.

### 7.6 Null Commitment

Where the Product-Mechanism record has **Commitment created = No**, the Commitment Definition shall be a **null-commitment definition**, stating explicitly:

- no obligation is created;
- the asset may respond to price or signal;
- the applicable settlement is at the market price or tariff (referenced to M4);
- performance measurement may or may not apply (referenced to M4).

---

## 8. Commitment Instances

### 8.1 Definition

A **Commitment Instance** is a runtime commitment created by a specific participation event — an award, enrollment, or instruction — carrying the **formation data** of that event: quantity, direction, price, period, and source.

**Commitment Instances carry formation data only.** Assessment data (delivered quantity, satisfaction status) is owned by **M4** and held in a **linked M4 record**.

**Instance lifetime** is a property of the Commitment Definition:

- **Short-lived** — per award or per discrete instruction. The instance covers one award period or one instruction window.
- **Long-lived** — per enrollment or per standing obligation. One instance covers the whole enrollment or obligation period.

### 8.2 Instance Record Structure

| Field | Description |
| --- | --- |
| **Commitment Instance ID** | Unique identifier |
| **Commitment Definition ID** | The template the instance follows |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Source event** | Award ID / Enrollment ID / Instruction ID |
| **Quantity** | The committed quantity |
| **Unit** | The unit of the quantity |
| **Direction** | Up / Down / Symmetric |
| **Price** | The committed price (where applicable) |
| **Period** | The period the commitment applies to |
| **Created at** | When the instance was created |
| **State** | **Pending** / **Active** / **Cancelled** (three M3b-owned states; see §8.3) |
| **M4 assessment reference** | Link to the M4 assessment record for this instance |
| **Owner** | M3b (structure and formation data) |

**Removed from the instance record (owned by M4):** Delivered quantity; Satisfaction status; **Satisfied** and **Breached** states.

### 8.3 State Transitions

M3b owns **three** states: Pending, Active, Cancelled. M4 owns Satisfied and Breached.

| State | Entered by | Owner |
| --- | --- | --- |
| **Pending** | Commitment Instance creation | M3b |
| **Active** | Obligation window start | M3b |
| **Cancelled** | Market-defined cancellation rule | **M3b** |
| **Satisfied** | M4 assessment | **M4** |
| **Breached** | M4 assessment | **M4** |

Satisfied and Breached are **M4 decisions**. Cancelled is a market-defined rule owned by M3b. The state machine for the M4-owned states is defined in M4.

### 8.4 Branch 2 Instance Rules

**Discrete instruction.** Where a branch 2 mechanism creates a **discrete instruction** (operator dispatch instruction), a **short-lived Commitment Instance** is created with the instruction as its source.

**Continuous enrollment or standing obligation.** Where a branch 2 mechanism is **continuous** (standing obligation, continuous enrollment), **one long-lived Commitment Instance** is created with the enrollment as its source. The instance carries the **enrollment quantity** and the **enrollment period**. The Commitment Definition applies throughout the enrollment period; the instance is the runtime record that carries the quantity.

**Enrollment Record.** The enrollment itself is recorded in an **Enrollment Record** (§5.7), carrying the enrollment quantity, unit, and period. The long-lived Commitment Instance references the Enrollment Record as its source.

### 8.5 Instance Consumers

Commitment Instances are consumed by:

- **Operational/Optimization Engineering** — to determine the Asset Dispatch Decision;
- **M4** — to assess delivery and determine settlement quantities, via the M4 assessment record linked to the instance;
- **Financial Engineering** (via M4) — to value market outcomes.

### 8.6 Instances Are Runtime Data

Commitment Instances are **not** part of the frozen M3b specification. The **structure** of the instance record is part of M3b. The **instances themselves** are runtime data.

**Producer:** Commitment Instances are produced by the market participation process. In a real market, the award comes from the market operator; the participant records the instance. In a simulated environment, the instance is produced by the simulation, governed by the **Award Simulation Rule** (M3b-O17).

---

## 9. Operational Obligations

### 9.1 Obligation Definition

An **operational obligation** is a requirement the asset must satisfy while participating in a Product-Mechanism.

Operational obligations are distinct from commitments: a commitment is the market-recognized obligation; an operational obligation is what the asset must do to satisfy it.

### 9.2 Obligation Categories and Threshold Ownership

| Category | Description | Threshold owner |
| --- | --- | --- |
| **Response obligation** (response time, ramp rate) | Pre-participation requirement | **M2** (technical eligibility and capability mapping) — M3b references |
| **Telemetry obligation** (format) | Data format | **M3a** (transversal formats) — M3b references |
| **Telemetry obligation** (frequency during participation) | Ongoing reporting frequency | **M3b** — ongoing obligation |
| **Availability obligation** (eligibility to participate) | Pre-participation availability | **M2** — M3b references |
| **Availability obligation** (availability during participation) | Ongoing availability | **M3b** — ongoing obligation |
| **Operational window obligation** | When the asset must be available | **M2** (temporal requirement) — M3b references |
| **Testing obligation** (qualification maintenance) | Re-qualification | **M2** (re-qualification) — M3b references |
| **Reporting obligation** (performance reporting, compliance) | Ongoing reporting | **M3b** — ongoing obligation |
| **Outage notification obligation** (lead time) | Notification lead time | **M3b** — ongoing obligation |
| **Delivery accuracy (scoring)** | Scoring of delivered accuracy | **M4** (performance measurement) — M3b references |

**Ownership rule:** Where M2 or M3a owns a threshold, M3b references it by ID. Where the threshold is an **ongoing obligation** not owned by M2 or M3a, **M3b owns it**. Where the threshold is used to **score delivery**, **M4 owns it**, and M3b references it.

### 9.3 Obligation Record Structure

| Field | Description |
| --- | --- |
| **Obligation ID** | Unique identifier |
| **Product-Mechanism ID** | The Product-Mechanism |
| **Category** | See §9.2 |
| **Obligation statement** | The obligation |
| **Condition** | When the obligation applies |
| **Threshold** | The threshold value, **where M3b owns it** |
| **Threshold reference** | Reference to the M2, M3a, or M4 record that owns the threshold, **where M3b references it** |
| **Verification method** | How compliance is verified |
| **Consequence of breach** | What happens if the obligation is breached |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M3b (obligation statement and threshold, where M3b owns it); reference for M2/M3a/M4-owned thresholds |
| **Uncertainty reference** | Link to **§13** |

### 9.4 Obligation vs. Eligibility

Operational obligations are **ongoing**. Eligibility conditions (M2 §8) are **assessed before participation**. A resource may be eligible and still breach an operational obligation during participation.

### 9.5 Threshold Routing

Where M2 or M3a owns a threshold, M3b references it by ID. Where a threshold is an **ongoing obligation** not owned by M2 or M3a, **M3b owns it**. Where a threshold is used to **score delivery**, **M4 owns it**, and M3b references it.

**M3b shall not require an M2 amendment for thresholds that are not eligibility or qualification conditions.**

---

## 10. Stacking and Coexistence

### 10.1 Definition

**Stacking** is the simultaneous or sequential participation of a BESS in multiple Product-Mechanisms.

**Coexistence** is the condition under which multiple Product-Mechanisms can be active at the same time.

### 10.2 Stacking Constraints (M3b) vs. Allocation Decisions (Operational/Optimization)

The market defines **what is permitted, forbidden, or constrained**. The market does **not** make allocation decisions.

| Concept | Owner |
| --- | --- |
| **Permitted / forbidden combinations** | M3b |
| **Constraints on allocation** (no double-counting, minimum headroom) | M3b |
| **Priority rules** where obligations conflict | M3b |
| **Capacity allocation across Product-Mechanisms** | Operational/Optimization Engineering |
| **Energy allocation across Product-Mechanisms** | Operational/Optimization Engineering |
| **Reserve allocation across Product-Mechanisms** | Operational/Optimization Engineering |

### 10.3 Stacking Constraint Record

For each relevant pair (or set) of Product-Mechanisms, M3b shall define:

| Field | Description |
| --- | --- |
| **Stacking ID** | Unique identifier |
| **Product-Mechanism IDs** | The Product-Mechanisms involved |
| **Stacking type** | Simultaneous / Sequential / Capacity / Energy / Reserve / Telemetry |
| **Permitted** | Yes / No / Conditional |
| **Conditions** | The conditions under which stacking is permitted |
| **Constraint on allocation** | No double-counting; minimum headroom; other constraints |
| **Priority rule** | Which Product-Mechanism takes priority if obligations conflict |
| **Conflict resolution** | How conflicts are resolved |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3) |
| **Owner** | M3b |
| **Uncertainty reference** | Link to **§13** |

### 10.4 Stacking and Constraints

Stacking rules interact with grid/network constraints (§11). Where a constraint limits stacking, the constraint takes precedence.

---

## 11. Grid and Network Constraints

### 11.1 Constraint Classification

Grid and network constraints are classified by **whether they affect eligibility**:

| Classification | Owner | Example |
| --- | --- | --- |
| **Site/interconnection capability** (eligibility-relevant) | **M1** (definition and **value ownership**, pending M1-O14); **M2** (consumption via capability mapping) | Interconnection export cap used in eligibility |
| **Operational network constraints** (non-eligibility-relevant) | **M3b** | Operational export limits during participation; ramping constraints |

**Site/interconnection capability** is **not** a BESS physical constraint and is **not** owned by BESS Engineering. It is a **network or contractual limit at the point of interconnection**. Its **value owner** is defined by M1-O14 — most likely **Network Engineering** or a **site/interconnection record in BESS Engineering Part 1**. Its evidence comes from the network side.

**Eligibility-path rule (M2 §2.3):** No eligibility condition shall depend on M3b. Where an interconnection export cap is used in eligibility, it is consumed by M2's capability mapping from the **site/interconnection capability** entity (pending M1-O14).

### 11.2 Operational Constraint Record

| Field | Description |
| --- | --- |
| **Constraint ID** | Unique identifier |
| **Product-Mechanism IDs** | The Product-Mechanism(s) to which the constraint applies |
| **Constraint type** | Interconnection / Grid-connection / Network-operator / Site-specific |
| **Constraint statement** | The constraint |
| **Limit** | Quantitative limit |
| **Unit** | The unit of the limit |
| **Condition** | When the constraint applies |
| **Consequence of breach** | What happens if the constraint is breached |
| **Evidence reference** | Linked Evidence Statement ID (M1 §16.3), with source type = network requirement |
| **Owner** | M3b |
| **Uncertainty reference** | Link to **§13** |

### 11.3 Constraint Sources

- interconnection agreements (technical obligations — network requirement source type);
- grid-connection requirements;
- network-operator requirements;
- site-specific network limitations.

Interconnection agreements are classified per M1 §17: **network requirement** for technical obligations, **contract** for commercial obligations. M3b records only the **technical** obligations that are **not eligibility-relevant** and **not site/interconnection capability**.

### 11.4 Constraint vs. Market Rule

The distinction (M1 §14) is preserved:

- **Market rules** originate from the market.
- **Grid/network constraints** originate from the network.
- A constraint is not a market rule merely because it limits market participation.

### 11.5 Constraint vs. Physical Constraint vs. Site Capability

Three distinct concepts:

- **Physical BESS constraints** (power, energy, SOC) — owned by **BESS Engineering**.
- **Site/interconnection capability** (interconnection export cap) — **M1** owns the definition and the value ownership decision (pending M1-O14); consumed by **M2**; evidence from the **network side**.
- **Operational network constraints** (operational export limits during participation) — owned by **M3b**.

M3b records only the **operational network constraints**.

---

## 12. Interfaces

### 12.1 M1 — Market Domain and Conventions

**Consumes:** market semantic model; temporal framework; evidence model; ownership table; uncertainty ownership; site/interconnection capability definition **and value ownership** (pending M1-O14).

**Provides:** rule- and signal-specific feedback; proposed changes via change control.

### 12.2 M3a — Transversal Market Values

**Consumes:** market-wide gate closure conventions; registration requirements; **timing conventions other than signal publication timing**; data formats; transversal minimum sizes; transversal aggregation rules; eligibility-relevant transversal limits. **M3a does not provide signals or signal publication timing.**

**Provides:** feedback on transversal values encountered during rule definition; proposed amendments via change control.

### 12.3 M2 — Market Products and Participation

**Consumes:** product identifiers; Product-Mechanism records; eligibility and qualification references; capability mappings; temporal requirements; product-level risks.

**Provides:** M3b rule references for the Product-Mechanism record; commitment and signal references for the Product-Mechanism sheet; bid, nomination, and award structures.

### 12.4 M4 — Delivery, Performance and Settlement

**Provides to M4:** commitment definitions (formation and obligation); delivery-obligation definitions; signal definitions and timing; operational obligations; constraint definitions relevant to delivery; baseline/counterfactual trigger conditions where market-defined.

**Consumes from M4:** delivery assessment records linked to Commitment Instances; satisfaction status; settlement definitions referenced from commitment definitions; delivery measurement; **delivery scoring thresholds**.

**Direct reference:** M4 takes **delivery obligation** identifiers directly from **M3b**, not relayed through M2.

**Instance assessment:** M4 holds the assessment record linked to each Commitment Instance. The instance itself carries formation data only.

### 12.5 Operational / Optimization Engineering

**Provides:** market rules; eligibility constraints (by reference to M2); commitments and commitment instances (formation data); operational obligations; stacking constraints; delivery requirements (obligation side); relevant grid/network constraints; signal semantics.

**Consumes:** Asset Dispatch Decisions; operating trajectories; delivered quantities; capacity, energy, and reserve allocation decisions.

**Semantic boundary:** *Market defines the commitment and its requirements; Operational/Optimization defines the Asset Dispatch Decision, whether or not a commitment exists. Market defines stacking constraints; Operational/Optimization makes allocation decisions.*

### 12.6 Forecasting Engineering

**Provides:** signal definitions; price and signal semantics; publication and observation timing; market-data requirements; relevant uncertainty definitions.

**Consumes:** forecasts of market variables.

**Semantic boundary:** *Market defines what a signal means; Forecasting defines how it is predicted.*

### 12.7 Financial Engineering

**Provides:** rule-based settlement triggers (via M4); penalties and adjustments (via M4); commitment definitions relevant to valuation.

### 12.8 Software Engineering

**Provides:** rule record structure; bid, nomination, and award structures; enrollment record structure; signal record structure; commitment definition and instance structures; operational obligation structure; stacking constraint structure; constraint record structure; **award simulation interface (M3b-O17)**.

### 12.9 Network Engineering

**Network Engineering** is the engineering domain responsible for the network-side analysis and evidence that support grid and network constraints and site/interconnection capability. It is distinct from:

- **Network Operator** (a role in M1 §5, performed by an external party);
- **BESS Engineering** (which owns the physical BESS model).

**Network Engineering is defined in the Introduction (v1.3).** M3b references it.

Network Engineering provides:

- network constraint identification and analysis;
- interconnection agreement technical obligations;
- grid-connection requirement evidence;
- network-operator requirement evidence;
- site-specific network limitation evidence;
- **site/interconnection capability evidence and value** (pending M1-O14).

Network Engineering does **not** own the constraints in M3b; M3b records them. Network Engineering provides the evidence.

**Pending Introduction v1.3:** Until Introduction v1.3 is issued, this section is a **provisional definition**. If the project does not have a distinct Network Engineering function, the **Network Operator role** and **BESS Engineering** jointly perform these functions.

---

## 13. Uncertainty Ownership

Per M1 §18, M3b owns:

- **market-rule uncertainty**;
- **signal uncertainty**;
- **market-data uncertainty**;
- **commitment uncertainty**;
- **operational-constraint uncertainty**.

Uncertainty types shall not be conflated.

### 13.1 Uncertainty Record Structure

| Field | Description |
| --- | --- |
| **Uncertainty ID** | Unique identifier |
| **Type** | Market-rule / Signal / Market-data / Commitment / Operational-constraint |
| **Description** | The uncertainty |
| **Affected records** | Which rules, signals, commitments, or constraints are affected |
| **Source** | Linked Evidence Statement ID (M1 §16.3) |
| **Impact** | Qualitative scale (Low / Medium / High) |
| **Likelihood** | Qualitative scale (Low / Medium / High) |
| **Mitigation** | How the uncertainty is mitigated |
| **Owning Part** | M3b |

### 13.2 Long-Horizon Uncertainty

Regulatory and market-rule changes over the asset life are **long-horizon uncertainty** (M1 §18). M3b shall record such changes with effective dates on the evidence records (M1 §16.2).

---

## 14. M3b Open Items

| ID | Open item | Required outcome | Owner | Priority | Blocking dependency | Target date |
| --- | --- | --- | --- | --- | --- | --- |
| M3b-O01 | Rules per Product-Mechanism | Rules defined per Product-Mechanism | M3 Lead | Critical | Depends on M2 freeze | TBD |
| M3b-O02 | Signals per Product-Mechanism | Signals defined per Product-Mechanism, many-to-many scope, all in M3b, with publication timing | M3 Lead | High | Depends on M3b-O01 | TBD |
| M3b-O03 | Commitment definitions | Commitment definitions defined per Product-Mechanism, with instance lifetime | M3 Lead | Critical | Depends on M3b-O01 | TBD |
| M3b-O04 | Commitment instance structure | Commitment instance structure defined; formation data only; M4 assessment linked; three M3b states | M3 Lead | High | Depends on M3b-O03 | TBD |
| M3b-O05 | Bid/nomination/award structures | Bid, nomination, and award structures defined per branch-1 Product-Mechanism | M3 Lead | High | Depends on M3b-O01 | TBD |
| M3b-O06 | Branch 2 records | Enrollment Records and instruction records defined; long-lived and short-lived instances per §8.4 | M3 Lead | Medium | Depends on M3b-O03 | TBD |
| M3b-O07 | Operational obligations | Operational obligations defined; thresholds owned by M3b or referenced from M2/M3a/M4 | M3 Lead | High | Depends on M3b-O01 | TBD |
| M3b-O08 | Stacking constraints | Stacking constraints defined for relevant Product-Mechanism pairs | M3 Lead | High | Depends on M3b-O01 | TBD |
| M3b-O09 | Grid/network constraints | Non-eligibility-relevant grid/network constraints identified and recorded | M3 Lead + Network Engineering | High | Depends on M3b-O01 | TBD |
| M3b-O10 | Constraint evidence sources | Constraint evidence sources identified (distinct from market-rule evidence) | M3 Lead | High | Depends on M3b-O09 | TBD |
| M3b-O11 | Uncertainty records | Uncertainty records defined per rule, signal, commitment, and constraint | M3 Lead | Medium | Depends on M3b-O01–M3b-O09 | TBD |
| M3b-O12 | M4 references | M4 references established | M3 Lead | Medium | Depends on M4 draft | TBD |
| M3b-O13 | Rule conflicts | Rule conflicts identified and escalated | M3 Lead | Medium | Depends on M3b-O01 | TBD |
| M3b-O14 | M3a amendments | M3a amendments proposed where eligibility-path transversal values are missing | M3 Lead | Medium | Depends on M3a freeze | TBD |
| M3b-O15 | Site/interconnection capability | M1-O14 resolved: entity **and value owner** defined; M2 capability mapping consumes the entity | M1 Lead + M2 Lead | High | Depends on M1-O14 | TBD |
| M3b-O16 | Network Engineering in Introduction | Introduction v1.3 issued; Network Engineering defined | Introduction Lead | Medium | Blocks M3b freeze; independent | TBD |
| **M3b-O17** | **Award simulation rule** | **Rule defining when a simulated bid clears, under the price-taker assumption. Owner: M3b (clearing rule) + Operational/Optimization (bid).** | **M3 Lead + Op/Opt Lead** | **Critical** | **Blocks energy pilot; independent of M3b-O01** | **TBD** |

**Critical path:** M3b-O01 (rules per Product-Mechanism) blocks most items. M3b-O03 (commitment definitions) is critical for M4. M3b-O17 (award simulation rule) is critical for the energy pilot and independent of M3b-O01. M3b-O15 and M3b-O16 block M3b freeze independently.

---

## 15. M3b Validation Criteria

### Rule Validation

- **Method:** Comparison of each rule against authoritative market documentation.
- **Reference case:** Market documentation for the applicable jurisdiction.
- **Reviewer:** M3 Lead + independent reviewer.
- **Pass condition:** Each rule is correctly categorized, has an evidence source, and has a defined condition, obligation, and consequence of breach. Threshold ownership is correctly assigned: M3b owns ongoing obligations; M2/M3a/M4-owned thresholds are referenced. No threshold is owned twice.

### Bid/Nomination/Award Validation

- **Method:** Review of bid, nomination, and award structures against market documentation.
- **Reference case:** Market documentation.
- **Reviewer:** M3 Lead.
- **Pass condition:** Each branch-1 Product-Mechanism has bid and award structures; partial awards and rejections are handled; award-to-commitment linkage is correct; branch 2 source records (Enrollment Records, instruction records) defined.

### Signal Validation

- **Method:** Comparison of each signal against market documentation.
- **Reference case:** Market documentation.
- **Reviewer:** M3 Lead + Forecasting Engineering.
- **Pass condition:** Each signal has a semantic meaning, direction, unit, **publication time**, observation time, and valid window. Signal scope (many-to-many) is correct. Market-wide signals and their **publication timing** are in M3b, not M3a. **No signal and no signal publication timing is in M3a.**

### Commitment Validation

- **Method:** Review of each commitment definition against market rules.
- **Reference case:** Market documentation and M2 Product-Mechanism records.
- **Reviewer:** M3 Lead.
- **Pass condition:** Each commitment definition has a formation trigger, obligation, obligation window, satisfaction condition (referenced to M4), instance lifetime, and M4 reference. Commitment type is stored. Null-commitment definitions are correctly identified. Instance structure carries formation data only; M4 assessment is linked; three M3b states (Pending, Active, Cancelled) are defined. Branch 2 instance rules are applied, including the **long-lived instance for continuous enrollments**.

### Operational Obligation Validation

- **Method:** Review of each operational obligation against market rules.
- **Reference case:** Market documentation.
- **Reviewer:** M3 Lead + Operational/Optimization Engineering.
- **Pass condition:** Each obligation has a condition, threshold (owned or referenced), verification method, and consequence of breach. M3b owns ongoing obligation thresholds; M2/M3a/M4-owned thresholds are referenced. No threshold is owned twice.

### Stacking Validation

- **Method:** Review of stacking constraints for relevant Product-Mechanism pairs.
- **Reference case:** Market documentation.
- **Reviewer:** M3 Lead + Operational/Optimization Engineering.
- **Pass condition:** Each stacking constraint has a permitted status, conditions, constraint on allocation, and priority rule. Allocation decisions are not made in M3b.

### Constraint Validation

- **Method:** Review of grid/network constraints against network documentation.
- **Reference case:** Network documentation.
- **Reviewer:** M3 Lead + Network Engineering.
- **Pass condition:** Each constraint has a source (distinct from market-rule evidence), a limit, an applicable scope, and a consequence of breach. Site/interconnection capability and its value are consumed by M2, not recorded in M3b. Eligibility-relevant limits are not in M3b.

### Boundary Validation

- **Method:** Interface review with M1, M3a, M2, M4, BESS, Forecasting, Operational/Optimization, Financial, Software, Network Engineering.
- **Reference case:** Interface definitions in §12.
- **Reviewer:** Cross-domain review board.
- **Pass condition:** No responsibility is claimed by two domains; no responsibility is unowned; M3b does not absorb transversal values that belong to M3a; **no signal and no signal publication timing is in M3a**; M4 takes delivery references directly from M3b; no threshold is owned twice.

### Evidence Validation

- **Method:** Traceability audit (M1 §16.4).
- **Reference case:** Critical-path evidence set.
- **Reviewer:** Independent evidence reviewer.
- **Pass condition:** Every material rule, signal, commitment, obligation, stacking constraint, and constraint has a complete Statement Record and at least one complete Source Record. Tier-1 statements have at least one Verified Rule source.

### Consistency Validation

- **Method:** Symbol, identifier, and convention audit. **Verify all internal cross-references resolve to the correct section.**
- **Reference case:** BESS Engineering Part 1 (pinned version), M1 v1.2, M3a, M2 v1.2, Introduction v1.2 (and v1.3 once issued).
- **Reviewer:** BESS Engineering + M3 Lead.
- **Pass condition:** No conflicting symbols, identifiers, units, state conventions, or temporal conventions; no M3a, M2, or M4 concept is redefined in M3b; no threshold is owned twice; all uncertainty references point to §13.

---

## 16. M3b Acceptance Criteria

M3b is ready for engineering freeze when:

- rules are defined per Product-Mechanism, categorized, sourced, and have consequences of breach;
- bid, nomination, and award structures are defined for branch-1 Product-Mechanisms;
- branch 2 source records (Enrollment Records, instruction records) and instance rules are defined, including the **long-lived instance for continuous enrollments**;
- signals are defined in M3b with many-to-many scope, semantics, timing, and **publication timing**;
- **no signal and no signal publication timing is in M3a**;
- commitment definitions are defined per Product-Mechanism, with formation triggers, obligations, satisfaction conditions (referenced to M4), **instance lifetime**, and M4 references;
- commitment instance structures are defined, carry formation data only, link to M4 assessment records, and define **three M3b states** (Pending, Active, Cancelled);
- null-commitment definitions are correctly identified;
- operational obligations are defined per Product-Mechanism, with conditions, threshold ownership or references, verification, and consequences;
- **threshold ownership is correctly assigned: M3b owns ongoing obligations; M2/M3a/M4-owned thresholds are referenced; no threshold is owned twice**;
- stacking constraints are defined for relevant Product-Mechanism pairs, with allocation constraints and priority rules;
- allocation decisions are not made in M3b;
- non-eligibility-relevant grid/network constraints are recorded with sources distinct from market-rule evidence;
- **site/interconnection capability and its value owner are consumed by M2, not recorded in M3b** (M1-O14 resolved);
- uncertainty records are defined per rule, signal, commitment, obligation, stacking constraint, and constraint;
- rule conflicts are identified and escalated;
- M3a amendments are proposed where eligibility-path transversal values are missing;
- M4 references are established or explicitly deferred where M4 does not yet exist;
- **M3b-O17 (award simulation rule) is resolved**;
- all required market symbols are registered through BESS Engineering Part 1;
- no independent market symbol authority exists;
- interfaces with M1, M3a, M2, M4, BESS, Forecasting, Operational/Optimization, Financial, Software, and Network Engineering are defined;
- **Network Engineering is defined in Introduction v1.3**;
- open items have been resolved or explicitly accepted as controlled assumptions, with owners, priorities, dependencies, and dispositions recorded;
- validation criteria have been satisfied with documented method, reference case, reviewer, and pass/fail result.

---

## 17. M3b Maturity

M3b follows the project-wide maturity ladder:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

Current status:

- **Semantic Definition — established (framework)**
- **Internal Consistency — ready for validation** *(revised from v1.1; the M2/M3b boundary, the M3a/M3b boundary, the signal placement, and the instance state ownership are now explicit)*
- **External Evidence — pending M2 freeze and market documentation**
- **Engineering Validation — pending**
- **Frozen — No**

**Status note on sequencing.** M3b is out of sequence by its own rules: it should be drafted after M2 freezes, which requires M3a to exist, which requires M1-O01–O03 (jurisdiction, operator, wholesale/BTM). **The next engineering activity is M3a, not M3b.** M3b is held until M3a exists.

**Status note on structural gaps.** Three structural items are pending:

- **M1-O14** — site/interconnection capability, **including its value owner**. Required before M2 freezes, because M2's capability mapping consumes it.
- **Introduction v1.3** — Network Engineering as an engineering domain. Required before M3b freezes; independent of M3a.
- **M3b-O17** — award simulation rule. Required before the energy pilot; independent of M3a.

**Status note on diminishing returns.** The M3b framework is complete as of v1.3. The remaining work is populating rules, signals, commitments, bids, obligations, stacking constraints, and constraints from authoritative market documentation, and resolving the award simulation rule. Further abstract iteration on the framework will add little. The next real gain is **External Evidence**, which is blocked on M3a.

---

## 18. Output of M3b

The final output of M3b shall be a controlled **Market Rules, Signals, Commitments and Constraints Specification** containing:

1. rules per Product-Mechanism;
2. bid, nomination, and award structures;
3. Enrollment Records and instruction records for branch 2;
4. signals per Product-Mechanism and market-wide, with many-to-many scope, **including publication timing**, all in M3b;
5. commitment definitions per Product-Mechanism, with instance lifetime;
6. commitment instance structure (formation data only, three M3b states) and M4 assessment linkage;
7. branch 2 instance rules (long-lived for continuous enrollments; short-lived for discrete instructions);
8. operational obligations per Product-Mechanism, with threshold ownership or references;
9. stacking constraints for relevant Product-Mechanism pairs;
10. non-eligibility-relevant grid/network constraints;
11. uncertainty records per rule, signal, commitment, obligation, stacking constraint, and constraint;
12. M4 references (populated or explicitly deferred);
13. award simulation rule (M3b-O17);
14. registered market symbols through BESS Part 1;
15. resolved assumptions and open-item disposition.

This output becomes the formal operational market foundation for:

**M4 — Delivery, Performance and Settlement**

which will then answer the next engineering question:

> **How is delivery measured, how is performance assessed and scored, and how is settlement determined?**