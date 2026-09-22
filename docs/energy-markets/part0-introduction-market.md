# Market Engineering Model — Introduction Document (v1.2)

**Version:** 1.2 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Owner:** BESS Operational & Market Engineering

| Version | Date       | Status            | Change                                                                                                                                                                                                                                                                                                                                                     |
| ------- | ---------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.0     | 2026-09-22 | Baseline          | Initial Market Engineering baseline; approved for M1 development.                                                                                                                                                                                                                                                                                          |
| 1.1     | 2026-09-22 | Development Draft | Closed null-commitment path; corrected commitment-presupposing text; split evidence into source and statement records; resolved three split ownerships; separated price-influence axis from price-responsive participation mode; reclassified contracts in the evidence hierarchy; made validation criteria testable; added M1-O13; renamed entity/role overlap; removed duplicated text. |
| 1.2     | 2026-09-22 | Development Draft | Renamed Parts from M1–M4 to Parte 1–5 per project nomenclature. Split the rules layer into **Parte 2 — Transversal Market Values** (early baseline, eligibility path only) and **Parte 4 — Full Rules, Signals, Commitments and Constraints** (post-Parte 3). Established the revised freeze order Parte 1 → Parte 2 → Parte 3 → Parte 4 → Parte 5. Introduced the eligibility-path rule (no eligibility condition depends on a Parte 4 value). Added the identifier-scheme ownership rule (Parte 3 §4.5, adopted project-wide). Moved M2 template reference rule to this document as a canonical rule. Added the "reference, do not redefine" rule for the product template. Defined the publication-timing rule (signal publication timing owned by Parte 4; non-signal transversal timing by Parte 2). Added Network Engineering as a pending engineering domain (to be defined in Introduction v1.3). Confirmed contracts as position 5 in the evidence hierarchy only where market-relevant obligations exist. |

**Document ID:** ME-INTRO-001 *(stable across versions)*

---

## 1. Purpose, Scope, and Boundary

This document establishes the engineering baseline for representing the electricity-market environment in which the BESS participates and operates. It is the parent document for the Market Engineering Parts and the owner of the rules that are common across them.

Market Engineering defines:

* market products and participation mechanisms;
* participant roles and market entities;
* participation, qualification, and eligibility requirements;
* market rules and operational obligations;
* market signals and their temporal meaning;
* opportunities, bids, awards, and commitments;
* delivery and performance requirements;
* baselines and counterfactuals where applicable;
* deviations, compliance, and settlement quantities;
* market-specific outputs and interfaces to downstream engineering domains.

Market Engineering does not define the physical BESS, forecasting methods, operational optimization, financial valuation, or software implementation. It defines the market semantics and requirements consumed by those domains.

The principal engineering relationship is:

**BESS Engineering ↔ Market Engineering ↔ Forecasting Engineering / Operational & Optimization Engineering / Financial Engineering / Software Engineering**

Market requirements may propagate upstream when they impose physical or operational requirements on the BESS. Such changes shall follow controlled interfaces and project change control.

Non-market commercial structures—including tolling arrangements, bilateral contracts, PPAs, hedges, and other contractual structures—are outside Market Engineering unless explicitly required. If required, they shall be modeled as a **separate commercial/contractual layer**.

---

## 2. Organization

Market Engineering is divided into **five Parts**:

| Parte                                                          | Engineering responsibility                                                                                                                                      |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Parte 1 — Market Domain and Conventions**                    | Market domain, scope, participant roles, market entities, concepts, evidence classification, interfaces, market-specific periods, assumptions, and traceability |
| **Parte 2 — Transversal Market Values**                        | Market-wide values on the eligibility path: gate closure conventions, registration requirements, timing conventions (non-signal), data formats and telemetry, transversal minimum sizes, aggregation rules, eligibility-relevant transversal limits, and the temporal framework instance |
| **Parte 3 — Market Products and Participation**                | Products, Product-Mechanism records, qualification requirements, eligibility, product-to-BESS capability mappings, product-specific temporal requirements |
| **Parte 4 — Full Rules, Signals, Commitments and Constraints** | Bids, nominations, awards, signals (including market-wide signals and publication timing), commitments (definitions and instances), operational obligations, stacking/coexistence rules, grid/network constraints (non-eligibility-relevant) |
| **Parte 5 — Delivery, Performance and Settlement**             | Delivery, baselines/counterfactuals, performance measurement, deviations, compliance, settlement quantities and settlement amounts, adjustments, penalties, market outputs |

The Parts are constructed in the order:

**Parte 1 → Parte 2 → Parte 3 → Parte 4 → Parte 5**

This is the **document-construction dependency**, not the market lifecycle.

### 2.1 Freeze order

| Freeze order | Part | Reason |
| ------------ | ---- | ------ |
| 1 | **Parte 1** | Domain foundation. |
| 2 | **Parte 2** | Breaks the Parte 3 → Parte 4 cycle. Carries transversal values that Parte 3 needs on the eligibility path. |
| 3 | **Parte 3** | Products, mechanisms, eligibility, qualification, capability mappings. Depends on Parte 1 + Parte 2 + BESS Engineering. Does **not** depend on Parte 4 on the eligibility path. |
| 4 | **Parte 4** | Full rules, signals, commitments, constraints. Depends on Parte 3's product catalogue and Product-Mechanism records. |
| 5 | **Parte 5** | Delivery, performance, settlement. Depends on Parte 4's commitment definitions and delivery-obligation definitions. |

### 2.2 Cycle-breaking: why Parte 2 exists

Parte 3 requires **transversal market values** that would otherwise belong to the full rules layer. Referencing them from Parte 4 before Parte 4 exists would create a Parte 3 → Parte 4 → Parte 3 loop.

To break the loop, the rules layer is split into two:

| Layer | Contents | Drafted |
| ----- | -------- | ------- |
| **Parte 2 — Transversal Market Values** | Market-wide values on the eligibility path. No product-specific content. No signals. | **Before Parte 3 freeze.** |
| **Parte 4 — Full Rules, Signals, Commitments and Constraints** | Product-specific rules, signals (including market-wide signals), commitments, operational constraints, stacking. | **After Parte 3 freeze.** |

**Eligibility-path rule (normative):**

> **No eligibility condition shall depend on a value owned by Parte 4.** If an eligibility condition appears to require a Parte 4 value, either the condition is product-specific and belongs to Parte 3, or the value is transversal and belongs to Parte 2. The "transversal product-specific" case does not exist: a value is either specific to one Product-Mechanism (Parte 3) or shared across products (Parte 2).

### 2.3 Publication-timing rule (normative)

> **Signal publication timing is owned by Parte 4.** Parte 2 owns transversal market timing conventions that are **not** signal-specific (e.g., registration windows, market-wide gate closure). Where a timing is signal-specific — including market-wide signal publication — Parte 4 owns it.

---

## 3. Parte 1 Boundary with BESS Engineering Part 1

Parte 1 does not create an independent fundamentals layer.

**BESS Engineering Part 1** remains the authoritative owner of:

* project-wide symbols;
* units;
* naming conventions;
* state conventions;
* decision conventions;
* temporal conventions;
* the project-wide master symbol registry.

Parte 1 defines market-specific concepts and maps market periods—such as bid, commitment, delivery, and settlement periods—onto the project-wide temporal conventions established by BESS Engineering Part 1.

Market-owned symbols are registered in the existing project-wide master symbol registry. **Parte 1 is not a second symbol authority.**

**Identifier scheme (normative):** Market-specific **identifiers** (distinct from mathematical symbols) are governed by the cross-Part identifier scheme defined in **Parte 3 §4.5**. Identifiers use the format `<type>-<sequence>` (e.g., `PROD-001`, `PM-001`), are unique on the unprefixed form, and are stable across versions. The namespace prefix is optional and display-only. Ownership is recorded in a field, not in the identifier. The identifier registry is separate from the BESS Engineering Part 1 master symbol registry.

Any change to a market-owned symbol or convention registered in BESS Engineering Part 1 shall follow project change control and remain traceable to the originating market requirement or evidence.

**Pinned dependency:** Parte 1 inherits from a specific, versioned release of BESS Engineering Part 1. The pin is recorded in the Parte 1 header and updated only through project change control. The pin is an open item (P1-O13).

---

## 4. Canonical Market Lifecycle

The canonical market lifecycle is:

**Product → Rules → Eligibility → Opportunity → Commitment → Dispatch → Delivery → Settlement**

These concepts shall remain semantically distinct:

* a **product** defines what the market recognizes;
* **rules** define how participation operates;
* **eligibility** determines whether a resource can participate;
* an **opportunity** represents a potential participation event;
* a **commitment** represents an obligation resulting from participation;
* **dispatch** is the operational decision used to satisfy a commitment — where "dispatch" refers to the asset-side decision, this is the **Asset Dispatch Decision**; where it refers to an operator-issued instruction, this is the **Operator Dispatch Instruction**;
* **delivery** represents physical/market performance against the commitment — or, on the null-commitment path, the metered quantity;
* **settlement** determines recognized market quantities, prices, and amounts.

Market Engineering owns the definition of a **market commitment**.

Operational/Optimization Engineering owns the **Asset Dispatch Decision** used to satisfy that commitment, whether or not a commitment exists.

Parte 5 owns the definition and measurement of **delivery performance**, while Operational/Optimization Engineering provides the resulting operational trajectory and raw delivered quantities.

Settlement is distinct from financial valuation. Parte 5 determines settlement quantities, settlement price semantics, and settlement amounts. Financial Engineering determines the economic valuation of those amounts.

### 4.1 Optional-node rule (normative)

The lifecycle nodes **Bid/Nomination** and **Award** are **conditional**. They are present only where the applicable market mechanism requires them.

### 4.2 Null-commitment path rule (normative)

On the null-commitment path:

* **Asset Dispatch Decision** applies (the asset still responds).
* **Delivery** is defined as the **metered quantity**, not performance against a commitment.
* **Performance Measurement** **may or may not apply**. Where a balance-responsible party is settled on deviation from a self-declared position, or where a BTM/tariff mechanism assesses performance against a baseline, performance measurement does apply — against that position or baseline rather than against a commitment.
* **Settlement** applies at the applicable price or tariff. Baseline and deviation measurement may apply depending on the mechanism.
* **Ownership:** Parte 4 owns the null-path operational obligations (if any); Parte 5 owns the null-path settlement definition.

### 4.3 Three participation branches

| Branch | Description |
| ------ | ----------- |
| **1 — Bid-based** | Bid/nomination → award → commitment. |
| **2 — Non-bid commitment** | Commitment arises without a bid — mandatory provision, enrollment, operator instruction, standing obligation. |
| **3 — Null commitment / price-responsive** | Response to price or signal without creating a commitment. |

---

## 5. Structural Engineering Rules

1. There shall be **one project-wide master symbol registry** (BESS Engineering Part 1).
2. Every concept shall have a **single semantic owner**.
3. Products and applicable rules shall be defined before eligibility is evaluated.
4. Market participation requirements shall be evaluated against the physical capabilities defined by BESS Engineering.
5. Market periods shall map onto, not redefine, project temporal conventions.
6. Evidence shall be classified as:
   * verified rule;
   * engineering interpretation;
   * modeling assumption;
   * unresolved requirement.
7. Opportunity, commitment, dispatch (Asset Dispatch Decision and Operator Dispatch Instruction), delivery, and settlement shall not be conflated.
8. Each Part shall define its interfaces, validation method, and acceptance criteria.
9. Changes to shared foundations shall follow project change control.
10. Market-derived physical or operational requirements shall be propagated back to BESS Engineering through controlled change management.
11. **Definition–instance rule:** Where a concept has both a domain-level definition and a market-specific application, the **definition is owned by the Part that defines the concept**, and the **application is owned by the Part that applies it**. Ownership shall be recorded as two separate rows in the ownership table — one for the definition, one for the application — rather than as a split within a single row.
12. **Reference rule:** Where a downstream Part needs a concept owned by another Part, it **references the concept by identifier** and does not redefine it.
13. **Product template reference rule:** The product definition template in §12 is owned by this document. Parte 3 applies it. Changes to the template are made here and referenced from the Parts.

---

## 6. Market Scope

Market Engineering represents the market participation mechanisms relevant to the project use case.

The applicability of:

* wholesale markets;
* behind-the-meter (BTM) participation;
* tariff-based mechanisms;
* ancillary-service participation;
* other market-access mechanisms

shall be established in **Parte 1** from project requirements and authoritative evidence.

If wholesale and BTM mechanisms are both in scope, they shall retain distinct:

* eligibility semantics;
* baseline/counterfactual definitions;
* performance requirements;
* settlement semantics.

**Scope vs. rule authority:** Project/customer requirements are used *first* to select scope (this section). They rank *sixth* for rule authority (Parte 1 §17). These are different questions and shall not be conflated.

**Wholesale vs. BTM as separate axes:** The **participation branch** (1, 2, or 3, per §4.3) determines the **commitment semantics**. The **market environment** (wholesale or BTM, per this section) determines **whether delivery is assessed against a baseline**. These are separate axes and shall not be conflated.

---

## 7. Cross-Cutting Considerations

### 7.1 Evidence and Traceability

Every material market requirement shall be traceable to its originating evidence.

Evidence maturity shall be proportional to the impact of the requirement on eligibility, dispatch, delivery, settlement, and financial outputs.

Evidence is represented through two linked records: **Evidence Source** (the document, publication, or authority) and **Evidence Statement** (the market statement supported by one or more sources). The category belongs to the statement, not to the source. The detailed structure is defined in Parte 1 §16.

### 7.2 Uncertainty

Each Part owns the uncertainty associated with the rules and concepts it defines.

Additionally:

* **Parte 1** owns domain-scope, role, structural, and foundational-assumption uncertainty;
* **Parte 2** owns transversal value and eligibility-path transversal value uncertainty;
* **Parte 3** owns product, qualification, and eligibility-rule uncertainty;
* **Parte 4** owns market-rule, signal, market-data, commitment, and operational-constraint uncertainty;
* **Parte 5** owns delivery, performance, baseline, and settlement uncertainty;
* unresolved market-rule uncertainty shall remain explicitly identified wherever it occurs;
* regulatory and market-rule changes over the asset life shall be treated as **long-horizon uncertainty**.

Uncertainty types shall not be conflated.

For example:

> An uncertain price forecast does not imply that the market settlement rule is uncertain.

Similarly:

> An ambiguous market rule shall not be hidden inside a forecasting assumption.

### 7.3 Price-Influence Assumption

Where relevant, **Parte 1 shall explicitly define whether the model assumes price-taking behavior or another market-participation assumption**.

The assumption shall be stated on the **price-influence axis**:

* **price taker** — the BESS does not materially alter market price through its own participation;
* **price maker** — the BESS can materially alter market price through its own participation;
* **strategic participant** — the BESS models the reaction of other participants to its own participation;
* **other** — as explicitly specified.

This is a **modeling assumption**, not a universal market fact. It shall be inherited by downstream Parts unless changed through controlled change management.

**Independence from participation mode:** The price-influence assumption is independent of the participation branch (§4.3). A BESS may be a price taker *and* participating with a commitment, or a price taker *and* participating on the null-commitment (price-responsive) path. The two axes shall not be conflated. "Price-responsive" describes the participation mode, not the price-influence assumption.

### 7.4 Grid and Network Constraints

Grid and network constraints shall be represented in **Parte 4** where they affect market participation or operational obligations, except for **site/interconnection capability**, which is consumed by Parte 3's capability mapping (pending P1-O14).

Their evidence source shall remain distinct from market-rule evidence.

Such constraints may originate from:

* interconnection agreements;
* grid-connection requirements;
* network-operator requirements;
* site-specific grid limitations.

They shall not be treated as market rules merely because they constrain market participation.

**Three distinct concepts:**

* **Physical BESS constraints** (power, energy, SOC) — owned by **BESS Engineering**.
* **Site/interconnection capability** (interconnection export cap, used in eligibility) — **Parte 1** owns the definition and the value ownership decision (pending P1-O14); consumed by **Parte 3**; evidence from the **network side**.
* **Operational network constraints** (operational export limits during participation) — owned by **Parte 4**.

### 7.5 Network Engineering

**Network Engineering** is the engineering domain responsible for the network-side analysis and evidence that support grid and network constraints and site/interconnection capability. It is distinct from:

* **Network Operator** (a role in Parte 1 §5, performed by an external party);
* **BESS Engineering** (which owns the physical BESS model).

**Network Engineering is defined in Introduction v1.3.** Until Introduction v1.3 is issued, the Network Operator role and BESS Engineering jointly perform these functions.

Network Engineering provides:

* network constraint identification and analysis;
* interconnection agreement technical obligations;
* grid-connection requirement evidence;
* network-operator requirement evidence;
* site-specific network limitation evidence;
* **site/interconnection capability evidence and value** (pending P1-O14).

---

## 8. Engineering Interfaces

### BESS Engineering

**Market consumes:**

* physical capabilities;
* operating limits;
* power and energy constraints;
* response characteristics;
* degradation-related limitations;
* other physical constraints relevant to eligibility and delivery.

**Market provides:**

* market-driven capability requirements;
* response-time requirements;
* duration requirements;
* qualification constraints;
* other requirements that may affect BESS specification or operating assumptions.

### Forecasting Engineering

**Market provides:**

* market signal definitions;
* price and signal semantics;
* publication and observation timing;
* market-data requirements;
* relevant uncertainty definitions.

**Forecasting provides:**

* forecasts of market variables required by downstream market participation or operational models.

The semantic boundary is:

**Market defines what a signal means; Forecasting defines how it is predicted.**

### Operational / Optimization Engineering

**Market provides:**

* market rules;
* eligibility constraints (by reference to Parte 3);
* commitments and commitment instances (formation data);
* operational obligations;
* stacking constraints;
* delivery requirements (obligation side);
* relevant grid/network constraints;
* signal semantics.

**Operational/Optimization provides:**

* Asset Dispatch Decisions;
* operating trajectories;
* raw delivered quantities required for delivery and performance assessment;
* capacity, energy, and reserve allocation decisions.

The semantic boundary is:

**Market defines the commitment and its requirements; Operational/Optimization defines the Asset Dispatch Decision, whether or not a commitment exists.**

Parte 5 defines how delivery is measured and recognized. Market defines stacking constraints; Operational/Optimization makes allocation decisions.

### Financial Engineering

Market Engineering provides:

* settlement quantities;
* settlement prices;
* **settlement amounts**;
* recognized delivery quantities;
* market prices or price definitions where applicable;
* penalties and adjustments;
* other market outputs required for economic valuation.

Financial Engineering determines their economic valuation (discounting, tax, NPV, IRR).

The semantic boundary is:

**Parte 5 determines settlement quantities, settlement price semantics, and settlement amounts. Financial Engineering determines the economic valuation of those amounts.**

### Software Engineering

Market Engineering defines the semantic and functional requirements that software must implement but does not define the software architecture or implementation.

### Network Engineering

**Network Engineering** is defined in **Introduction v1.3**. Market Engineering references it where network-side evidence is required. Until Introduction v1.3 is issued, the Network Operator role and BESS Engineering jointly perform these functions.

Network Engineering provides:

* network constraint identification and analysis;
* interconnection agreement technical obligations;
* grid-connection requirement evidence;
* network-operator requirement evidence;
* site-specific network limitation evidence;
* site/interconnection capability evidence and value (pending P1-O14).

---

## 9. Validation, Acceptance, and Freeze

Each Market Engineering Part shall define its own:

* validation method;
* acceptance criteria;
* evidence requirements;
* unresolved items;
* dependencies on other Parts.

The following validation categories provide the default acceptance-criteria framework:

### Rule Validation

Does the model correctly represent the applicable market rules?

### Semantic Validation

Do the model concepts correspond to actual market concepts? Is the **definition–instance rule** applied consistently? Are the **terminology rules** respected — in particular, is "dispatch" qualified wherever it is ambiguous, and is "price-responsive" reserved for the null-commitment participation mode?

### Temporal Validation

Are market intervals, commitment periods, delivery periods, and settlement periods represented correctly? Are interval labeling, time zone, DST handling, and resolution mapping correctly applied?

### Eligibility Validation

Does the model correctly determine whether the BESS can participate in a product? Are the **vacuous** and **indeterminate** cases handled correctly? Is the **aggregate-validity intersection rule** applied?

### Boundary Validation

Is every responsibility owned by exactly one domain? Is every responsibility owned? Does the eligibility path avoid Parte 4 references?

### Settlement Validation

Does simulated delivery produce the expected settlement result under defined reference cases? Are settlement quantities, settlement prices, and settlement amounts correctly distinguished?

### Historical Validation

Where appropriate data are available, does the model reproduce relevant historical market behavior and settlement outcomes?

Not every validation category must apply identically to every Part; the applicable criteria shall be defined according to the Part's engineering responsibility.

The unified maturity ladder is:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

The required evidence and validation depth shall be proportional to the impact on eligibility, dispatch, delivery, settlement, and financial outputs.

---

## 10. Change Control

Changes to shared foundations shall follow project change control.

**Shared artifacts owned by this Introduction Document:**

* the canonical market lifecycle (§4);
* the optional-node rule (§4.1);
* the null-commitment path rule (§4.2);
* the three participation branches (§4.3);
* the eligibility-path rule (§2.2);
* the publication-timing rule (§2.3);
* the definition–instance rule (§5, rule 11);
* the reference rule (§5, rule 12);
* the product template reference rule (§5, rule 13);
* the product definition template (§12);
* the identifier-scheme ownership rule (§3).

Changes to these artifacts shall be made **in this Introduction** and referenced from the Parts. No Part shall declare them unilaterally.

**Parts owned by their respective leads:**

* Parte 1 — Market Domain and Conventions;
* Parte 2 — Transversal Market Values;
* Parte 3 — Market Products and Participation;
* Parte 4 — Full Rules, Signals, Commitments and Constraints;
* Parte 5 — Delivery, Performance and Settlement.

Changes to a Part's own content follow that Part's change control and propagate through the controlled interfaces defined in that Part.

**Pending change requests:**

* **Introduction v1.3** — Add Network Engineering as an engineering domain (currently referenced as pending in §7.5 and §8).

---

## 11. Baseline Status and Next Activity

Market Engineering is established as an engineering domain connected to, but not replacing, BESS Engineering.

The current status is:

**Baseline established — Parte 1 development approved — Market model not yet frozen.**

Before the Market Engineering Parts are frozen, the following shall be established from project requirements and authoritative evidence:

1. applicable market and jurisdictional scope (P1-O01);
2. market operator (P1-O02);
3. wholesale versus BTM applicability (P1-O03);
4. participant and market roles (P1-O04);
5. relevant products (P3-O01);
6. eligibility and qualification requirements (P3-O03, P3-O04);
7. participation and market rules (P4-O01);
8. market signals and temporal mappings (P4-O02, P2-O03);
9. opportunity and commitment semantics (P4-O03);
10. stacking and coexistence rules (P4-O08);
11. grid/network constraints and evidence sources (P4-O09, P4-O10);
12. delivery and performance measurement (P5-O01, P5-O04);
13. settlement mechanisms (P5-O07, P5-O09, P5-O10);
14. price-influence assumption (P1-O08);
15. evidence and traceability requirements (P1-O09, P2-O09);
16. gate closure conventions (P2-O01);
17. registration requirements (P2-O02);
18. temporal framework instance (P2-O08);
19. site/interconnection capability (P1-O14);
20. Network Engineering domain (Introduction v1.3).

**Critical path:** P1-O01 (jurisdiction) → P1-O02 (market operator) → P1-O03 (wholesale/BTM) block nearly all other items and shall be resolved first. P1-O13 (pinned BESS Part 1 version) blocks freeze independently. P1-O14 (site/interconnection capability) blocks Parte 3 and Parte 4 freeze. Introduction v1.3 (Network Engineering) blocks Parte 4 freeze.

The next engineering activity is:

**Parte 2 — Transversal Market Values**, populated from authoritative market documentation once P1-O01 through P1-O03 are resolved.

The recommended first substantive step is the **pilot Product-Mechanism sheet** in Parte 3 (P3-O15), once P1-O01–O03 are resolved and energy is confirmed in scope. This instantiates the framework against real market documents more effectively than further abstract iteration.

---

## 12. Product Definition Template (Owned Here)

The following template shall be applied consistently to every market product defined in **Parte 3 — Market Products and Participation**:

1. **Definition**
2. **Market Purpose**
3. **Eligibility**
4. **Required BESS Capability**
5. **Market Signal**
6. **Participation Mechanism**
7. **Commitment**
8. **Delivery Requirement**
9. **Temporal Requirements**
10. **Operational Constraints**
11. **Interaction with Other Products**
12. **Settlement Mechanism**
13. **Technical Outputs**
14. **Risks and Uncertainties**

This template defines the **required semantic coverage** of each product. It does not imply that every product will use identical equations, data sources, or implementation methods.

### 12.1 Template Application Rule (Normative)

**Reference rule:** Parte 3 references, but does not redefine, concepts owned by Parte 2, Parte 4, and Parte 5.

| Template item | Owner | Parte 3 action |
| ------------- | ----- | -------------- |
| 1. Definition | Parte 3 | Define (at product level) |
| 2. Market Purpose | Parte 3 | Define (at product level) |
| 3. Eligibility | Parte 3 | Define (per Product-Mechanism) |
| 4. Required BESS Capability | Parte 3 (mapping); BESS Engineering (physical model) | Map, referencing BESS symbols |
| 5. Market Signal | Parte 4 | Reference Parte 4 identifier |
| 6. Participation Mechanism | Parte 3 | Define (via Product-Mechanism record) |
| 7. Commitment | Parte 4 | Reference Parte 4 identifier |
| 8. Delivery Requirement | Parte 4 (obligation); Parte 5 (definition and measurement) | Reference Parte 4 and Parte 5 identifiers directly |
| 9. Temporal Requirements | Parte 3 (Product-Mechanism-specific); Parte 1 (framework); Parte 2 (transversal values and temporal framework instance) | Define Product-Mechanism-specific; reference Parte 1 framework and Parte 2 values |
| 10. Operational Constraints | Parte 4 | Reference Parte 4 identifier |
| 11. Interaction with Other Products | Parte 4 (stacking/coexistence) | Reference Parte 4 identifier |
| 12. Settlement Mechanism | Parte 5 | Reference Parte 5 identifier |
| 13. Technical Outputs | Parte 3 (Product-Mechanism outputs); downstream Parts | Define; reference downstream |
| 14. Risks and Uncertainties | Parte 3 (Product-Mechanism); owning Part (Parte 1 §18) | Define; reference owning Part |

**M2 references, but does not redefine, concepts owned by Parte 4 and Parte 5.** Specifically:

* Market Signal → reference Parte 4 identifier
* Operator Dispatch Instruction → reference Parte 4 identifier
* Commitment → reference Parte 4 identifier
* Delivery Obligation → reference Parte 4 identifier
* Delivery Definition and Measurement → reference Parte 5 identifier
* Performance Measurement → reference Parte 5 identifier
* Settlement Mechanism → reference Parte 5 identifier
* Interaction with Other Products (stacking/coexistence) → reference Parte 4 identifier

Parte 3 defines only what is product-specific: definition, market purpose, eligibility, required BESS capability, participation mechanism, temporal requirements specific to the product, and product-specific risks and uncertainties.

---

## 13. Guiding Principle

> **What does the market allow, require, signal, recognize, and settle—and how does that interact with what the BESS can physically do?**

The objective is a market representation that is:

* semantically correct;
* evidence-traceable;
* physically consistent with BESS Engineering;
* operationally usable;
* suitable for downstream Forecasting, Operational/Optimization, and Financial Engineering.

---

*End of Market Engineering Model — Introduction Document (v1.2)*

---


