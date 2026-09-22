
# Market Engineering Model — Introduction Document

**Version:** 1.0 — Baseline
**Status:** Approved for M1 development — Not Frozen
**Date:** 2026-09-22
**Owner:** BESS Operational & Market Engineering

| Version | Date       | Status   | Change                                                           |
| ------- | ---------- | -------- | ---------------------------------------------------------------- |
| 1.0     | 2026-09-22 | Baseline | Initial Market Engineering baseline; approved for M1 development |

---

## 1. Purpose, Scope, and Boundary

This document establishes the engineering baseline for representing the electricity-market environment in which the BESS participates and operates.

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

Market Engineering is divided into four Parts:

| Part                                                        | Engineering responsibility                                                                                                                                      |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **M1 — Market Domain and Conventions**                      | Market domain, scope, participant roles, market entities, concepts, evidence classification, interfaces, market-specific periods, assumptions, and traceability |
| **M2 — Market Products and Participation**                  | Products, participation mechanisms, qualification requirements, eligibility, and product-to-BESS capability mappings                                            |
| **M3 — Market Rules, Signals, Commitments and Constraints** | Bids, nominations, awards, commitments, market signals, timing, stacking/coexistence rules, operational obligations, and applicable grid/network constraints    |
| **M4 — Delivery, Performance and Settlement**               | Delivery, baselines/counterfactuals, performance measurement, deviations, compliance, settlement quantities, adjustments, penalties, and market outputs         |

The Parts are constructed in the order:

**M1 → M2 → M3 → M4**

This is the **document-construction dependency**, not the market lifecycle.

---

## 3. M1 Boundary with BESS Engineering Part 1

M1 does not create an independent fundamentals layer.

**BESS Engineering Part 1** remains the authoritative owner of:

* project-wide symbols;
* units;
* naming conventions;
* state conventions;
* decision conventions;
* temporal conventions;
* the project-wide master symbol registry.

M1 defines market-specific concepts and maps market periods—such as bid, commitment, delivery, and settlement periods—onto the project-wide temporal conventions established by BESS Engineering Part 1.

Market-owned symbols are registered in the existing project-wide master symbol registry. **M1 is not a second symbol authority.**

Any change to a market-owned symbol or convention registered in BESS Engineering Part 1 shall follow project change control and remain traceable to the originating market requirement or evidence.

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
* **dispatch** is the operational decision used to satisfy a commitment;
* **delivery** represents physical/market performance against the commitment;
* **settlement** determines recognized market quantities and adjustments.

Market Engineering owns the definition of a **market commitment**.

Operational/Optimization Engineering owns the **dispatch decision** used to satisfy that commitment.

M4 owns the definition and measurement of **delivery performance**, while Operational/Optimization Engineering provides the resulting operational trajectory and delivered quantities.

Settlement is distinct from financial valuation.

---

## 5. Structural Engineering Rules

1. There shall be **one project-wide master symbol registry**.
2. Every concept shall have a **single semantic owner**.
3. Products and applicable rules shall be defined before eligibility is evaluated.
4. Market participation requirements shall be evaluated against the physical capabilities defined by BESS Engineering.
5. Market periods shall map onto, not redefine, project temporal conventions.
6. Evidence shall be classified as:

   * verified rule;
   * engineering interpretation;
   * modeling assumption;
   * unresolved requirement.
7. Opportunity, commitment, dispatch, delivery, and settlement shall not be conflated.
8. Each Part shall define its interfaces, validation method, and acceptance criteria.
9. Changes to shared foundations shall follow project change control.
10. Market-derived physical or operational requirements shall be propagated back to BESS Engineering through controlled change management.

---

## 6. Market Scope

Market Engineering represents the market participation mechanisms relevant to the project use case.

The applicability of:

* wholesale markets;
* behind-the-meter (BTM) participation;
* tariff-based mechanisms;
* ancillary-service participation;
* other market-access mechanisms

shall be established in M1 from project requirements and authoritative evidence.

If wholesale and BTM mechanisms are both in scope, they shall retain distinct:

* eligibility semantics;
* baseline/counterfactual definitions;
* performance requirements;
* settlement semantics.

---

## 7. Cross-Cutting Considerations

### 7.1 Evidence and Traceability

Every material market requirement shall be traceable to its originating evidence.

Evidence maturity shall be proportional to the impact of the requirement on eligibility, dispatch, delivery, settlement, and financial outputs.

### 7.2 Uncertainty

Each Part owns the uncertainty associated with the rules it defines.

Additionally:

* **M3** owns market-signal and market-data uncertainty;
* **M4** owns delivery, performance, and settlement uncertainty;
* unresolved market-rule uncertainty shall remain explicitly identified wherever it occurs;
* regulatory and market-rule changes over the asset life shall be treated as long-horizon uncertainty.

Uncertainty types shall not be conflated.

For example:

> An uncertain price forecast does not imply that the market settlement rule is uncertain.

Similarly:

> An ambiguous market rule shall not be hidden inside a forecasting assumption.

### 7.3 Price-Taker Assumption

Where relevant, **M1 shall explicitly define whether the model assumes price-taking behavior or another market-participation assumption**.

This assumption shall be inherited by downstream Parts unless changed through controlled change management.

### 7.4 Grid and Network Constraints

Grid and network constraints shall be represented in **M3** where they affect market participation or operational obligations.

Their evidence source shall remain distinct from market-rule evidence.

Such constraints may originate from:

* interconnection agreements;
* grid-connection requirements;
* network-operator requirements;
* site-specific grid limitations.

They shall not be treated as market rules merely because they constrain market participation.

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
* eligibility constraints;
* commitments;
* operational obligations;
* stacking/coexistence constraints;
* delivery requirements;
* relevant grid/network constraints.

**Operational/Optimization provides:**

* dispatch decisions;
* operating trajectories;
* actual or simulated delivered quantities required for delivery and performance assessment.

The semantic boundary is:

**Market defines the commitment and its requirements; Operational/Optimization defines the dispatch used to satisfy it.**

M4 defines how delivery is measured and recognized.

### Financial Engineering

Market Engineering provides:

* settlement quantities;
* delivery quantities;
* market prices or price definitions where applicable;
* penalties and adjustments;
* other market outputs required for economic valuation.

Financial Engineering determines their economic valuation.

### Software Engineering

Market Engineering defines the semantic and functional requirements that software must implement but does not define the software architecture or implementation.

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

Do the model concepts correspond to actual market concepts?

### Temporal Validation

Are market intervals, commitment periods, delivery periods, and settlement periods represented correctly?

### Eligibility Validation

Does the model correctly determine whether the BESS can participate in a product?

### Settlement Validation

Does simulated delivery produce the expected settlement result under defined reference cases?

### Historical Validation

Where appropriate data are available, does the model reproduce relevant historical market behavior and settlement outcomes?

Not every validation category must apply identically to every Part; the applicable criteria shall be defined according to the Part's engineering responsibility.

The unified maturity ladder is:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

The required evidence and validation depth shall be proportional to the impact on eligibility, dispatch, delivery, settlement, and financial outputs.

---

## 10. Baseline Status and Next Activity

Market Engineering is established as an engineering domain connected to, but not replacing, BESS Engineering.

The current status is:

**Baseline established — M1 development approved — Market model not yet frozen.**

Before the Market Engineering Parts are frozen, the following shall be established from project requirements and authoritative evidence:

1. applicable market and jurisdictional scope;
2. wholesale versus BTM applicability;
3. participant and market roles;
4. relevant products;
5. eligibility and qualification requirements;
6. participation and market rules;
7. market signals and temporal mappings;
8. opportunity and commitment semantics;
9. stacking and coexistence rules;
10. grid/network constraints and evidence sources;
11. delivery and performance measurement;
12. settlement mechanisms;
13. price-taking or other market-behavior assumptions;
14. evidence and traceability requirements.

The next engineering activity is:

**Market Domain Model → Market Semantic Model → Product Identification → Rule Identification → Evidence Mapping → Engineering Specification**

---

## 11. Guiding Principle

> **What does the market allow, require, signal, recognize, and settle—and how does that interact with what the BESS can physically do?**

The objective is a market representation that is:

* semantically correct;
* evidence-traceable;
* physically consistent with BESS Engineering;
* operationally usable;
* suitable for downstream Forecasting, Operational/Optimization, and Financial Engineering.

---

### M2 Product Definition Template

The following template shall be applied consistently to every market product defined in **M2 — Market Products and Participation**:

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

---


