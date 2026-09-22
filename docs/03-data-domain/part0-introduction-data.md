# Data Engineering Model — Introduction Document (v0.4)

**Version:** 0.4 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Owner:** BESS Data Engineering
**Document ID:** DE-INTRO-001 *(stable across versions)*

| Version | Date | Status | Change |
|---|---|---|---|
| 0.1 | 2026-09-22 | Development Draft | Initial Data Engineering Introduction. |
| 0.2 | 2026-09-22 | Development Draft | Restored the cross-Part rules section; restored the version-history table; clarified the lifecycle chain as a loop plus a terminal state; changed the interface description from a linear chain to a hub; restored interface direction and semantic-boundary sentences. |
| 0.3 | 2026-09-22 | Development Draft | Fixed three consumption-path violations: acquisition-branch concept moved to Part 1 (instance in Part 3); as-of rule moved to Part 2 (revision mechanics stay in Part 4); quality-dimensions row corrected to Part 1. Replaced `RSV-` type prefix with reserved final identifiers plus a status field. Normalized "Parte" to "Part". Replaced DE-INTRO-002 with a change-request identifier. Added an open-items table. Defined vacuous/indeterminate. Replaced forward section references with topic references. Fixed rule 7 self-count. Fixed §8 Data Governance wording. Fixed the version-history gap. Moved the Spanish change notes to a cover note. |
| 0.4 | 2026-09-22 | Development Draft | Closed the last consumption-path violation: data-uncertainty classification concept moved to Part 1; Part 4 keeps quality-, lineage-, and reconciliation-specific uncertainty only. Removed the acquisition-branch parenthetical contradiction from §4. Split D1-O02 into a Part 1 concept row and a Part 3 instance row. Corrected the blocking column so Part 2 items block the Part 2 freeze first. Documented that open-item prefixes are historical, not ownership indicators. Retired the old D2-O03 (lineage/transformation) and assigned new IDs for as-of. Clarified CR-DE-001's critical path and the interim arrangement for transversal quality thresholds. Restored the optional display-prefix definition. Added Financial Engineering to §4 consumption owners. Verified Part naming against Market Engineering. Recorded the as-of rule placement rationale. |

---

## 1. Purpose and Boundary

This document establishes the engineering baseline for the **data and input domain** of the BESS operational and market simulation system. It is the parent document for the Data Engineering Parts and the owner of the rules common across them.

Data Engineering defines **what data must exist, what it must mean, what quality it must satisfy, under what as-of conditions it may be read, and how it is delivered and retained**. It does not define the physical BESS model, market rules, forecasting methods, optimization strategies, financial valuation, or software implementation.

Data Engineering interfaces with each of the following domains:

**BESS Engineering · Market Engineering · Forecasting Engineering · Operational & Optimization Engineering · Financial Engineering · Software Engineering**

Data is a hub: it interfaces with each domain independently. Data requirements may propagate upstream when they impose acquisition, quality, timing, or retention requirements on other domains, following project change control.

**Naming convention.** This model uses **"Part"** throughout, matching the convention used by BESS Engineering and Market Engineering. Where an earlier draft used "Parte" as a display label, the two forms are equivalent; this document uses "Part" in all normative text.

---

## 2. Organization

Data Engineering is divided into **five Parts**:

| Part | Engineering responsibility |
|---|---|
| **Part 1 — Data Domain and Conventions** | Domain, scope, entities, roles, concepts, evidence classification, interfaces, temporal conventions, the acquisition-branch concept, the quality-dimension concept, the data-authority axis concept, the data-uncertainty classification concept, assumptions, traceability |
| **Part 2 — Transversal Data Values** | Data-wide values on the consumption path: time-zone, resolution, null/missing-data, format, as-of conventions, transversal quality thresholds, temporal framework instance |
| **Part 3 — Data Entities and Sources** | Entity catalogue, entity-to-source mapping, source authority instances, acquisition-branch instances, entity-specific temporal requirements, entity-to-consumer mappings, reference and master data |
| **Part 4 — Data Quality, Lineage, and Transformation Rules** | Entity-specific quality rules, validation rules, lineage, transformation semantics, reconciliation, revision-versioning mechanics, quality-, lineage-, and reconciliation-specific uncertainty |
| **Part 5 — Data Delivery, Interfaces, and Acceptance** | Delivery semantics, interfaces, consumption contracts, latency and availability, access and confidentiality, retention, acceptance criteria, validation evidence, outputs |

Construction and freeze order:

**Part 1 → Part 2 → Part 3 → Part 4 → Part 5**

Part 2 exists because Part 3 requires **transversal data values** that would otherwise belong to the full quality and transformation layer. Referencing them from Part 4 before Part 4 exists would create a Part 3 → Part 4 → Part 3 loop. The quality and transformation layer is therefore split into a transversal-values layer (Part 2, drafted before Part 3 freezes) and an entity-specific layer (Part 4, drafted after Part 3 freezes).

**Acquisition-branch concept.** The three acquisition branches — authoritative source, derived source, assumed/modeled input — are **defined in Part 1** and **instantiated per entity in Part 3**. They are not owned by Part 4.

**Quality-dimension concept.** Quality dimensions — completeness, accuracy, consistency, timeliness, validity, uniqueness, lineage integrity — are **defined in Part 1**, with transversal thresholds in Part 2 and entity-specific rules in Part 4.

**Data-uncertainty classification concept.** The classification scheme for data uncertainty — entity-level, source-level, quality-level, lineage-level, reconciliation-level, delivery-level — is **defined in Part 1**. Part 4 owns only the quality-, lineage-, and reconciliation-specific uncertainty of the entities it rules over.

---

## 3. Cross-Part Rules Owned by This Introduction

These rules span more than one Part and therefore cannot be owned by any single Part.

1. **Consumption-path rule.** No entity definition in Part 3 shall depend on a *value* owned by Part 4. If an entity definition appears to require a Part 4 value, either the requirement is entity-specific (Part 3) or the value is transversal (Part 2). This rule is the sole justification for the Part 2 / Part 4 split.

2. **Forward-reference mechanism.** A frozen Part may reference **reserved identifiers** of a later, not-yet-frozen Part. A reserved identifier is the *final* identifier — for example `QR-012` — carrying a `status = reserved` field in the identifier registry. It is not a separate type. When the later Part populates the reserved identifier, the identifier itself does not change; only its `status` field changes from `reserved` to `populated`. An unpopulated reserved identifier blocks the later Part's freeze gate.

3. **Identifier-scheme owner.** The cross-Part identifier scheme is owned by **Part 1, "Identifier scheme"** (topic, not section number), consistent with the Market Engineering identifier scheme. Identifiers use the format `<type>-<sequence>` (e.g., `ENT-001`, `SRC-001`, `QR-012`). The optional namespace prefix (`DE:`) is display-only and never part of the identifier. Identifiers are **unique on the unprefixed form** and stable across versions. Ownership and lifecycle status are recorded in fields, not in the identifier. The identifier registry is separate from the master symbol registry.

4. **Definition–instance ownership rule.** Where a concept has both a domain-level definition and an application in a specific context, the **definition is owned by the defining Part** and the **application is owned by the applying Part**. They are recorded as two separate ownership rows. This is an ownership rule, not a sequencing rule.

5. **Point-in-time owner.** The as-of rule has three components, each owned separately. The **concept** of as-of — that revisable data has vintages and that reads are timestamped — is owned by **Part 1**. The **transversal conventions and values** — how vintages are represented, what the default as-of resolution is — are owned by **Part 2**. The **consumer declaration obligation** — that a consumer declares its as-of condition, and the no-look-ahead requirement for simulations — is owned by **Part 5** as part of the consumption contract. The **revision-versioning mechanics** — how a revision is recorded, retained, and traced — remain in **Part 4**. Conflicts across the four are resolved at this Introduction.

6. **Named project-wide authority.** Project-wide conventions — symbols, units, naming, state, decision, temporal conventions, and the master symbol registry — are owned by **BESS Engineering Part 1**. Part 1 of this model inherits from a specific, versioned release of that document; the pin is recorded in the Part 1 header and updated only through project change control (open item D1-O13). The pin independently blocks freeze.

7. **Ownership of the rules above.** The rules above are owned by this Introduction. Changes are made here and referenced from the Parts. No Part shall declare them unilaterally.

---

## 4. Canonical Data Lifecycle

**Requirement → Entity Definition → Source Identification → Acquisition → Validation → Transformation → Storage → Delivery → Consumption → Feedback ↺**

**Archival** is the terminal state for data that has exited active consumption.

Nodes **Transformation**, **Storage**, and **Archival** are conditional: they apply only where a semantic or structural change is required, where persistence is required by a consumer contract, or where retention is required by Part 5.

The detailed lifecycle rules are owned as follows:

- acquisition branches: concept in **Part 1**, instances in **Part 3**;
- null-transformation path: **Part 4**;
- revision versioning: **Part 4**;
- transversal timing and as-of conventions: **Part 2**;
- delivery contracts: **Part 5**.

Data Engineering owns the definition of a **data entity** and its **quality requirements**. **Operational/Optimization Engineering**, **Forecasting Engineering**, and **Financial Engineering** own **consumption**. Software Engineering owns the **implementation** of acquisition, transformation, storage, delivery, and archival.

---

## 5. Structural Engineering Rules

1. There shall be **one project-wide master symbol registry** (BESS Engineering Part 1).
2. Every data concept shall have a **single semantic owner**.
3. Entities and applicable quality requirements shall be defined before delivery contracts.
4. Data requirements shall be evaluated against the needs of consuming engineering domains.
5. Data periods shall map onto, not redefine, project temporal conventions.
6. Evidence shall be classified as: verified source; engineering interpretation; modeling assumption; unresolved requirement.
7. Entity definition, source, acquisition, validation, transformation, delivery, consumption, and archival shall not be conflated.
8. Each Part shall define its interfaces, validation method, and acceptance criteria.
9. Changes to shared foundations shall follow project change control.
10. **Reference rule:** A downstream Part references a concept by identifier and does not redefine it.
11. **Entity template reference rule:** The entity template is owned by this Introduction and applied by Part 3.

---

## 6. Data Scope

Data Engineering covers the data and input domain relevant to the project use case. The applicability of:

- market data (prices, signals, awards, settlements);
- BESS operational data (power, energy, SOC, temperature, SOH);
- BESS configuration data (nameplate, limits, efficiency curves);
- site and grid data (interconnection limits, network constraints);
- forecasting inputs (weather, load, price drivers);
- financial data (tariffs, contract prices, discount rates);
- reference and master data (nodes, asset IDs, market product codes);
- validation data (historical outcomes, benchmark results)

shall be established in **Part 1** from project requirements and authoritative evidence.

If multiple data environments are in scope, they retain distinct entity definitions, authority hierarchies, quality requirements, delivery semantics, and access/retention rules.

**Scope vs. rule authority.** Project/customer requirements select scope (this section). They rank *sixth* for rule authority (Part 1, "Rule authority"). These are different questions.

**Acquisition branch vs. data environment.** The acquisition branch (concept in Part 1, instance in Part 3) determines authority semantics; the data environment determines what reality the data represents. Separate axes.

---

## 7. Cross-Cutting Considerations

**Evidence and traceability.** Every material data requirement shall be traceable to its originating evidence. Maturity proportional to impact on eligibility, dispatch, delivery, settlement, and financial outputs. Detailed structure in Part 1.

**Uncertainty.** Each Part owns the uncertainty of the concepts it defines. The classification scheme is defined in **Part 1**. Uncertainty types shall not be conflated.

**Data-authority axis.** The axis concept — authoritative; authoritative-derived; non-authoritative; modeled; other — is **defined in Part 1**. The per-entity instance is owned by **Part 3**. Independent of the acquisition branch.

**Quality dimensions.** Defined in **Part 1**; transversal thresholds owned by **Part 2**; entity-specific rules owned by **Part 4**.

**Data Governance Engineering.** Data Governance Engineering will be defined in a separate document, requested under change request **CR-DE-001**. Until that document is issued, the interim arrangement is: the Data Source Owner role and Software Engineering jointly supply transversal quality thresholds to Part 2 and retention/confidentiality evidence to Part 5. The interim arrangement is authorized for the Part 2 freeze; CR-DE-001 formally closes when the separate document is issued and reviewed, and the Part 4 freeze gate requires it to be closed. This document states only the interface; it does not define the domain itself.

---

## 8. Engineering Interfaces

Each domain below is described in the form *the domain defines…; Data defines…*. Data is a hub and interfaces with each domain independently.

**BESS Engineering.** BESS defines the physical entity model, configuration parameters, operating limits, response characteristics, and degradation-related requirements. Data defines the entities through which BESS operational and configuration state is represented, together with their quality requirements and delivery contracts.

**Market Engineering.** Market defines what a signal means — its semantic content, publication timing, and observation conventions. Data defines how the signal is acquired, validated, and delivered to consumers.

**Forecasting Engineering.** Forecasting owns forecast data entities and defines how future quantities are predicted, including their uncertainty. Data defines what historical and input data must exist and what quality it must satisfy for those forecasts to be produced.

**Operational / Optimization Engineering.** Operational/Optimization defines how data is used in dispatch decisions and owns dispatch and trajectory entities. Data defines what data must exist and what quality it must satisfy for those decisions to be made.

**Financial Engineering.** Financial Engineering defines how settlement, price, and cost data are used in economic valuation and owns valuation entities. Data defines what settlement, price, and cost entities must exist and what quality they must satisfy.

**Software Engineering.** Data defines semantic and functional requirements. Software owns architecture and implementation.

**Data Governance Engineering.** Referenced in §7. Data Engineering states the interface; Data Governance Engineering is defined in the document requested under CR-DE-001.

---

## 9. Validation, Acceptance, and Freeze

Each Part shall define its validation method, acceptance criteria, evidence requirements, unresolved items, and dependencies.

**Terminology.** *Vacuous* means the check passes because no data falls under the condition being tested. *Indeterminate* means the check cannot be decided because a required input is missing or ambiguous; indeterminate is not a pass.

Default validation categories:

- **Source** — sources and their authority correctly represented.
- **Semantic** — concepts correspond to actual entities; definition–instance rule applied.
- **Temporal** — observation, publication, ingestion, availability, and as-of periods represented correctly; interval labeling, time zone, DST, resolution mapping applied.
- **Quality** — quality requirements correctly evaluated; vacuous and indeterminate cases handled.
- **Boundary** — every responsibility owned by exactly one domain; consumption path avoids Part 4 *value* references.
- **Delivery** — delivery availability, timing, quality, access, and retention correctly distinguished.
- **As-of** — as-of reads return the correct vintage; revisions preserved as separate vintages.
- **Historical** — historical behavior and quality outcomes reproduced without look-ahead bias.

Maturity ladder:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

---

## 10. Change Control

**Owned by this Introduction:** the cross-Part rules in §3; the canonical data lifecycle (§4) including the conditional-node rule; the structural engineering rules (§5); the data entity definition template (§11); the identifier-scheme ownership declaration (§3, rule 3).

Changes to these artifacts are made here and referenced from the Parts. Each Part owns its own content and follows its own change control.

**Pending change request:** **CR-DE-001** — define Data Governance Engineering in a separate document.

---

## 11. Data Entity Definition Template (Owned Here)

Applied to every entity in **Part 3**:

1. Definition
2. Data Purpose
3. Source Authority
4. Acquisition Branch (concept in Part 1; instance in Part 3)
5. Temporal Requirements (including as-of behavior, per the Part 2 as-of conventions)
6. Quality Requirements
7. Transformation Requirements
8. Delivery Requirements
9. Consumption Contract
10. Interaction with Other Entities
11. Lineage
12. Technical Outputs
13. Risks and Uncertainties (using the Part 1 classification scheme; quality-, lineage-, and reconciliation-specific uncertainty owned by Part 4)

**Application rule:** Part 3 defines items 1–5, 12, and 13. Items 6–11 are owned by Part 4 or Part 5 and are referenced by identifier, using reserved final identifiers with `status = reserved` where necessary (§3, rule 2).

---

## 12. Baseline Status and Next Activity

**Status:** Baseline established — Part 1 development approved — Data model not yet frozen.

Next activities, in freeze order:

1. Resolve critical-path items: **D1-O01** (data scope), **D1-O02a/b** (authority axis concept and instance mapping), **D1-O03** (data environment applicability).
2. Draft **Part 2 — Transversal Data Values** once D1-O01–O03 are resolved. The interim arrangement in §7 is authorized to supply transversal quality thresholds for the Part 2 freeze.
3. Run the **pilot Data Entity sheet (D3-O15)** in parallel with Part 2 drafting.
4. Freeze Part 2, then draft and freeze Part 3, Part 4, Part 5.
5. Close **CR-DE-001** before the Part 4 freeze gate.

---

## 13. Open Items

**Prefix convention.** Open-item prefixes (`D1-`, `D2-`, `D5-`) are historical and record the Part that first raised the item. They are **not** ownership indicators. Ownership is recorded in the *Owner* column. An item may be owned by a Part different from its prefix, and this is intentional under the identifier-stability principle (ownership lives in a field, not in the identifier).

| ID | Description | Owner | Blocks |
|---|---|---|---|
| D1-O01 | Data scope | Part 1 | Nearly all |
| D1-O02a | Authority axis concept | Part 1 | Nearly all |
| D1-O02b | Authority axis per-entity instance | Part 3 | Nearly all |
| D1-O03 | Data environment applicability | Part 1 | Nearly all |
| D1-O13 | Pinned BESS Engineering Part 1 version | Part 1 | Part 1 freeze |
| D1-O14 | Transversal quality thresholds | Part 2 | Part 2 freeze, then Part 3 and Part 4 freeze |
| D2-O01 | Time-zone and resolution conventions | Part 2 | Part 2 freeze, then Part 3 freeze |
| D2-O02 | Null/missing-data conventions | Part 2 | Part 2 freeze, then Part 3 freeze |
| D2-O03a | Lineage and transformation conventions *(retired from v0.3; superseded by D2-O04 and Part 4 rules)* | — | — |
| D2-O04 | As-of conventions *(new ID; replaces the meaning previously attached to D2-O03)* | Part 2 | Part 2 freeze, then Part 3 freeze |
| D3-O15 | Pilot Data Entity sheet | Part 3 | Validation of Part 2 |
| D5-O10 | Access, confidentiality, and retention rules | Part 5 | Acceptance |
| CR-DE-001 | Data Governance Engineering document | Separate document | Part 4 freeze (interim arrangement authorized for Part 2 freeze) |

---

## 14. Guiding Principle

> **What data must exist, what must it mean, where does it come from, what quality must it satisfy, under what as-of conditions may it be read, how is it delivered, and how is it retained?**

---

*End of Data Engineering Model — Introduction Document (v0.4)*

---

**Cover note (outside the controlled document).** Records the changes applied in v0.4 in response to the 91/100 review. Not part of the controlled body.

**Last consumption-path violation closed**

- *Data-uncertainty classification*: concept moved to **Part 1** (§2 row, §7, §11 item 13). Part 4 now owns only quality-, lineage-, and reconciliation-specific uncertainty.

**§4 contradiction removed**

- The phrase assigning acquisition branches to Part 4 is gone. §4 now lists ownership cleanly: acquisition branches (Part 1 concept, Part 3 instances), null-transformation path (Part 4), revision versioning (Part 4), transversal timing/as-of conventions (Part 2), delivery contracts (Part 5).

**Open-items table corrected**

- **D1-O02 split** into D1-O02a (Part 1 concept) and D1-O02b (Part 3 instance), per §3 rule 4.
- **Blocking column corrected**: Part 2 items now block the **Part 2** freeze first, then Part 3 / Part 4.
- **Prefix convention** documented above the table: prefixes are historical, ownership lives in the *Owner* column.
- **D2-O03 retired** and replaced by **D2-O04** for as-of conventions; the retired row is kept for traceability rather than reused with a new meaning.

**CR-DE-001 critical path clarified**

- §7 now states the interim arrangement is **authorized for the Part 2 freeze**, and CR-DE-001 closes formally when the separate document is issued. The Part 4 freeze gate requires CR-DE-001 to be closed. §13 table updated to match.

**Minor points addressed**

- **Display prefix restored**: §3 rule 3 now defines the optional `DE:` prefix as display-only and never part of the identifier. "Unique on the unprefixed form" has a referent again.
- **§4 consumption owners** now include **Financial Engineering**.
- **Part naming** in §1 verified against the convention used by BESS Engineering and Market Engineering.
- **As-of placement** refined: concept in Part 1, conventions in Part 2, consumer obligation and no-look-ahead in Part 5, revision mechanics in Part 4. §3 rule 5 and §11 item 5 updated.

**Recommendation.** Per the 91/100 review, this is the stopping point for the Introduction. Remaining gains depend on external evidence — D1-O13 (BESS Part 1 version pin), D1-O14 (transversal quality thresholds from the interim arrangement), CR-DE-001 (Data Governance Engineering document) — and on contact with real data through the pilot Data Entity sheet (D3-O15). Further iteration on the Introduction would produce diminishing returns; the pilot will test the framework harder than another review.