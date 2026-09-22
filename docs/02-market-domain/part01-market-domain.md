# Parte 1 — Market Domain and Conventions

**Version:** 1.3 — Development Draft
**Status:** Under Engineering Development — Not Frozen
**Date:** 2026-09-22
**Parent Document:** Market Engineering Model — Introduction Document (v1.2)
**Upstream Dependency:** BESS Engineering Part 1 — Fundamentals and Conventions (version pinned per P1-O13)
**Document ID:** ME-P1-001 *(stable across versions)*

---

## Revision History

| Version | Date | Status | Change |
| --- | --- | --- | --- |
| 1.0 | 2026-09-22 | Development Draft | Initial M1 baseline. |
| 1.1 | 2026-09-22 | Development Draft | Closed null-commitment path; corrected commitment-presupposing text; split evidence into source and statement records; resolved three split ownerships; separated price-influence axis from price-responsive participation mode; reclassified contracts in the evidence hierarchy; made validation criteria testable; added M1-O13; renamed entity/role overlap; removed duplicated text. |
| 1.2 | 2026-09-22 | Development Draft | Fixed three-branch lifecycle diagram; corrected definition–instance rule and its examples; qualified every use of "dispatch"; relaxed null-path absolutes; cited Introduction v1.1 rather than restating its rules; stabilized Document ID; corrected open-items critical path; added materiality tiers; extended evidence record fields; resolved minor ownership and categorization gaps. |
| 1.3 | 2026-09-22 | Development Draft | **Renamed from "M1" to "Parte 1" per project nomenclature.** **Updated Parent Document citation from Introduction v1.1 to v1.2.** **Updated all internal references to Introduction v1.2.** **Added the M3a/M3b split reference owned by Introduction v1.2.** **Renamed the M3a/M3b references to Parte 2/Parte 4.** **Renamed all M2 references to Parte 3.** **Renamed all M4 references to Parte 5.** **Updated Document ID from ME-M1-001 to ME-P1-001.** **Updated open item IDs from M1-Oxx to P1-Oxx.** **Added note that M3a/M3b split is owned by Introduction v1.2, not by Parte 1.** **Added P1-O14 (site/interconnection capability).** **Added Network Engineering reference.** **Added identifier scheme reference.** **Corrected all cross-references to the new nomenclature.** |

**Change control note:** The canonical lifecycle, the optional-node rule, the null-commitment path rule, the product template reference rule, and the split into Parte 2 (Transversal Market Values) and Parte 4 (Full Rules) are owned by the **Introduction Document v1.2**. Parte 1 cites them and treats the corresponding text in §8, §10, and §27 as **informative**, not normative. Where Parte 1 and the Introduction differ, the Introduction governs.

---

## 1. Purpose and Scope

Parte 1 establishes the **domain-level semantic foundation** for Market Engineering.

Its purpose is to define **what constitutes the market environment**, which entities participate in it, which concepts are required to represent market participation, how market-specific temporal structures relate to the project-wide temporal conventions, and how market requirements and evidence are organized.

Parte 1 does **not** define individual market products in detail, product-specific eligibility rules, bidding algorithms, dispatch optimization, or settlement calculations. Those responsibilities belong to Parte 3, Parte 4, and Parte 5.

Parte 1 establishes the foundation required for those Parts to be developed consistently.

The primary question of Parte 1 is:

> **What market environment is being represented, who participates in it, what objects and relationships exist within it, and what conventions are required to represent those interactions consistently?**

---

## 2. Engineering Boundary

Parte 1 operates between the project-wide BESS foundation and the detailed Market Engineering Parts.

```text
BESS Engineering Part 1
        │
        │ Project-wide conventions
        ▼
     PARTE 1
Market Domain & Conventions
        │
        ├──────────► PARTE 2 — Transversal Market Values
        │
        ├──────────► PARTE 3 — Products & Participation
        │
        ├──────────► PARTE 4 — Rules, Signals,
        │              Commitments & Constraints
        │
        └──────────► PARTE 5 — Delivery,
                       Performance & Settlement
```

Parte 1 consumes the project-wide conventions defined by BESS Engineering Part 1 and adds only the **market-domain semantics** required by Market Engineering.

Parte 1 therefore does not redefine:

- project-wide units;
- project-wide naming conventions;
- BESS states;
- BESS decision conventions;
- project-wide temporal resolution;
- project-wide scenario conventions;
- the master symbol registry.

Market-specific symbols required by Parte 1–Parte 5 shall be registered in the **existing BESS Engineering Part 1 master symbol registry**.

**Pinned dependency:** Parte 1 inherits from a specific, versioned release of BESS Engineering Part 1. The pin is recorded in the document header and updated only through project change control. The pin is an open item (P1-O13).

---

## 3. Intent

### 3.1 WHAT

Parte 1 represents the market environment as a structured engineering domain containing:

- market participants;
- market operators and authorities;
- market products;
- market rules;
- market signals;
- participation mechanisms;
- eligibility conditions;
- opportunities;
- commitments;
- delivery obligations;
- settlement mechanisms;
- market-specific temporal structures;
- market and network constraints;
- evidence and requirements.

### 3.2 WHY

The purpose is to prevent downstream engineering from treating the market as an undifferentiated collection of prices, signals, or revenue streams.

A market must instead be represented as a system in which:

```text
Market Environment
        │
        ├── Products
        ├── Rules
        ├── Eligibility
        ├── Opportunities
        ├── Commitments
        ├── Operational Requirements
        ├── Delivery
        └── Settlement
```

This allows Operational/Optimization Engineering and Financial Engineering to consume market information without independently reconstructing market semantics.

### 3.3 FOR WHOM

Parte 1 provides the domain foundation for:

- Market Engineering Parts 3–5;
- BESS Engineering;
- Forecasting Engineering;
- Operational & Optimization Engineering;
- Financial Engineering;
- Software Engineering.

The primary downstream consumers are the engineering domains responsible for forecasting market variables, determining operational decisions, and valuing market outcomes.

---

## 4. Domain Model

The Market Engineering domain is composed of the following principal entities.

| Entity | Definition |
| --- | --- |
| **Market Environment** | The externally defined market context in which participation occurs |
| **Market Party** | A legal, commercial, or operational entity involved in market participation (an entity, not a role) |
| **Market Operator Party** | The party that operates the relevant market mechanism |
| **Network Operator Party** | The party responsible for applicable grid/network requirements |
| **Market Product** | A standardized market service or commodity recognized by the market |
| **Participation Mechanism** | The mechanism through which a participant accesses or provides a product |
| **Market Rule** | An externally defined condition governing participation, operation, delivery, or settlement |
| **Eligibility Requirement** | A condition that must be satisfied to participate in a product |
| **Market Signal** | An externally generated market quantity or instruction with defined semantic meaning |
| **Market Opportunity** | A potential event in which participation may be available or economically relevant |
| **Bid / Nomination** | A participant-submitted representation of intended participation |
| **Award** | A market-recognized allocation resulting from a bid, nomination, or other participation mechanism |
| **Commitment** | A market-recognized obligation resulting from participation |
| **Asset Dispatch Decision** | The operational decision made by the asset, whether or not a commitment exists |
| **Delivery** | The physical or market-recognized quantity/state associated with a commitment, or — on the null-commitment path — the metered quantity |
| **Performance Measurement** | The method used to determine whether delivery satisfies applicable requirements; may or may not apply on the null-commitment path, depending on the mechanism |
| **Baseline / Counterfactual** | The reference quantity against which delivery or performance is assessed where applicable |
| **Settlement** | The market mechanism that determines recognized quantities and financial settlement inputs |
| **Constraint** | A limit that restricts participation or operation, originating from market rules, external grid/network requirements, or physical BESS limits |
| **Evidence Source** | A document, publication, or authority carrying versioned content |
| **Evidence Statement** | A market statement supported by one or more Evidence Sources, with an assigned evidence category |

**Physical constraints:** Physical BESS constraints (power, energy, SOC, degradation) are **not** owned by Market Engineering. They are consumed from BESS Engineering and represented in Parte 4 only where they affect market participation or operational obligations.

**Entity vs. role:** §4 defines **entities** (things). §5 defines **roles** (functions performed by entities). A Market Party may hold one or more roles; a role may be held by one or more Market Parties.

---

## 5. Participant Roles

Parte 1 owns the definition of participant roles.

The exact entities applicable to the target market shall be identified from authoritative market documentation.

The generic participant-role model is:

| Role | Responsibility within the domain |
| --- | --- |
| **Asset Owner** | Owns or economically controls the BESS asset |
| **Market Participant** | Represents the BESS or its commercial participation in the market |
| **Market Operator** | Administers market processes, awards, operator dispatch instructions, or settlement as applicable |
| **System / Network Operator** | Defines or enforces applicable network and interconnection requirements |
| **Balance-Responsible Party / Scheduling Coordinator** | Holds balance responsibility and/or performs scheduling coordination where required by the market |
| **Load / Offtaker** | Represents demand or the receiving entity where applicable |
| **Aggregator** | Aggregates multiple assets or loads where the market permits aggregation |
| **Retail / Utility Entity** | Participates between the BESS/site and market where applicable |
| **Regulator / Authority** | Establishes or supervises applicable market or regulatory requirements |
| **Settlement Entity** | Performs or administers settlement where distinct from the market operator |

These are **roles**, not necessarily distinct organizations.

One Market Party may perform multiple roles. One role may be performed by multiple Market Parties.

Parte 1 shall distinguish:

**role → party → responsibility**

rather than assuming that each role corresponds to a unique organization.

---

## 6. Market Environment Scope

The market environment shall be explicitly bounded before Parte 3–5 are frozen.

Parte 1 shall establish:

- jurisdiction;
- market operator;
- applicable market structure;
- geographic scope;
- market participation mechanism;
- wholesale versus BTM applicability;
- applicable tariff environment where relevant;
- applicable ancillary-service mechanisms;
- applicable network/interconnection environment;
- relevant regulatory framework.

The model shall not assume a particular market merely because a market mechanism is common for BESS projects.

The applicable environment must be established from:

1. project requirements;
2. RFP/customer requirements where applicable;
3. authoritative market documentation;
4. applicable regulatory or network documentation.

**Scope vs. rule authority:** Project/customer requirements are used *first* to select scope (this section). They rank *sixth* for rule authority (§17). These are different questions and shall not be conflated. The ordering is stated once here and cross-referenced from §17.

---

## 7. Wholesale and Behind-the-Meter Scope

Parte 1 shall explicitly determine whether the model represents:

- **wholesale market participation**;
- **behind-the-meter participation**;
- **both**.

If both are represented, they shall remain separate market environments where their semantics differ.

The model shall not assume that a wholesale market product and a BTM/tariff mechanism are equivalent merely because both produce an economic opportunity.

Differences shall be preserved for:

- eligibility;
- baseline/counterfactual;
- obligation (whether a commitment exists, and if so what it requires);
- performance measurement;
- settlement;
- applicable constraints.

**Environment vs. branch:** The market environment (wholesale or BTM) is a separate axis from the participation branch (1, 2, or 3, per §8). The environment determines whether delivery is assessed against a baseline. The branch determines commitment semantics. The two shall not be conflated.

---

## 8. Market Semantic Model

The principal semantic relationships are:

```text
Market Environment
        │
        ├── contains → Market Parties
        │
        ├── defines → Products
        │
        ├── establishes → Rules
        │
        ├── publishes → Signals
        │
        └── establishes → Participation Mechanisms
                              │
                              ▼
                         Eligibility
                              │
                              ▼
                         Opportunity
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   [Bid / Nomination]   [No Bid, but          [No Bid, no
        │                commitment arises     commitment arises
        ▼                from another          (price-responsive
     Award               mechanism]            participation)]
        │                     │                     │
        └──────────┬──────────┘                     │
                   ▼                                ▼
              Commitment                     null commitment
                   │                                │
                   ▼                                ▼
        Asset Dispatch Decision         Asset Dispatch Decision
                   │                                │
                   ▼                                ▼
              Delivery                    Metered Delivery
                   │                                │
                   ▼                                │
        Performance Measurement                     │
          (may or may not apply)                    │
                   │                                │
                   ▼                                ▼
              Settlement                       Settlement
        (against commitment,             (at applicable price
         baseline, or deviation           or tariff; baseline
         as applicable)                   and deviation may
                                          still apply)
```

**Normative status:** The canonical chain in **Introduction v1.2** — *Product → Rules → Eligibility → Opportunity → Commitment → Dispatch → Delivery → Settlement* — is the normative semantic dependency. This diagram is an **expanded, informative view** that makes explicit the *optional* nodes and the three participation branches:

1. **Bid → Award → Commitment** — where the market requires a bid and awards participation.
2. **No Bid → Commitment** — where a commitment arises from another market-defined mechanism (mandatory provision, enrollment-based program, operator instruction, standing obligation).
3. **No Bid → null commitment** — price-responsive participation where no obligation is created.

**Optional-node rule (Introduction v1.2):** Bid/Nomination and Award are **conditional**. They are present only where the applicable market mechanism requires them.

**Null-commitment path rule (Introduction v1.2; informative here):** On the null-commitment path:

- **Asset Dispatch Decision** applies (the asset still responds).
- **Delivery** is defined as the **metered quantity**, not performance against a commitment.
- **Performance Measurement** **may or may not apply**. Where a balance-responsible party is settled on deviation from a self-declared position, or where a BTM/tariff mechanism assesses performance against a baseline, performance measurement does apply — against that position or baseline rather than against a commitment.
- **Settlement** applies **at the applicable price or tariff**, which may be a market price, a tariff, or another mechanism-defined value. Baseline and deviation measurement may apply depending on the mechanism.
- **Ownership:** Parte 4 owns the null-path operational obligations (if any); Parte 5 owns the null-path settlement definition.

This semantic structure is the basis for Parte 3–5.

---

## 9. Market Product, Rule, and Eligibility Semantics

Parte 1 establishes the distinction between three concepts that shall not be conflated.

### Market Product

Defines **what service or commodity the market recognizes**.

### Market Rule

Defines **how participation and operation are governed**.

### Eligibility

Defines **whether a particular resource satisfies the requirements necessary to participate**.

Therefore:

```text
Product
   │
   ▼
Applicable Rules
   │
   ▼
Eligibility Requirements
   │
   ├── Market Requirements
   │
   └── BESS Physical Capabilities
```

Parte 3 owns the detailed product and eligibility representation.

Parte 4 owns detailed operational rules and commitments.

**Boundary rule (Parte 3/Parte 4):** A rule is owned by **Parte 3** if it is *specific to a product's participation or qualification* (e.g., minimum duration for a specific ancillary product). A rule is owned by **Parte 4** if it applies *transversally to participation, operation, commitment, or constraints* (e.g., gate closure, stacking rules, operational obligations).

---

## 10. Opportunity and Commitment Semantics

Parte 1 establishes the domain distinction between an **opportunity** and a **commitment**.

### Opportunity

A market opportunity represents a potential participation event.

An opportunity does not imply an obligation.

### Commitment

A commitment represents a market-recognized obligation resulting from participation.

A commitment may arise from:

- an awarded bid;
- an accepted nomination;
- an operator dispatch instruction;
- a mandatory-provision or enrollment-based mechanism;
- another market-defined mechanism.

The exact mechanism is market-specific and shall be defined in Parte 3/Parte 4.

The relationship is therefore:

**Opportunity ≠ Commitment**

and:

**Commitment ≠ Asset Dispatch Decision**

Market Engineering defines the commitment semantics.

Operational/Optimization Engineering determines the Asset Dispatch Decision, whether or not a commitment exists.

**Null commitment:** Where a market mechanism creates no obligation, the model represents a **null commitment**. This is a valid state for price-responsive and uncommitted participation. The downstream consequences are defined in the **Introduction v1.2** and summarized informatively in §8.

---

## 11. Market Temporal Structure

Parte 1 does not create a new project-wide temporal convention.

Instead, it defines how market-specific periods map onto the temporal framework established by BESS Engineering Part 1.

Potential market periods include:

- market interval;
- bid submission window;
- gate closure period;
- award period;
- commitment period;
- delivery period;
- settlement period;
- publication interval;
- observation interval.

These periods may have different durations, boundaries, and publication times.

Parte 1 shall represent their relationships without changing the project-wide temporal conventions.

A market period shall therefore be defined by:

- semantic meaning;
- start/end relationship;
- duration;
- relation to the project time axis;
- source/evidence;
- applicability.

**Ownership:** Parte 1 owns the **temporal mapping framework** — how market periods relate to the project time axis and to each other. Parte 4 owns the **actual rule values** — gate closure time, delivery period duration, settlement period duration, and their market-specific timings.

### 11.1 Interval Labeling Convention

Market intervals shall be explicitly labeled as either **interval-beginning** or **interval-ending**, consistent with the applicable market's convention. The labeling convention shall be recorded as a market-specific attribute and shall not be inferred from the project-wide temporal convention unless the market explicitly matches it.

### 11.2 Time Zone and DST Handling

All market timestamps shall be represented with:

- an explicit time zone identifier;
- an explicit DST rule (including how 23-hour and 25-hour days are handled where DST applies);
- a mapping to the project time axis that preserves the market's local-time semantics.

Market timestamps shall not be silently converted to a project-wide time zone without recording the conversion rule.

### 11.3 Resolution Mapping

Where market data resolution differs from the project model resolution (e.g., 5-minute settlement data against a 15-minute model), Parte 1 shall define:

- the aggregation rule (for coarsening);
- the disaggregation rule (for refining);
- the requirement that an authoritative quantity be declared.

**Ownership:** Parte 1 owns the **mapping method**. Parte 5 **declares** the authoritative settlement quantity per product. Parte 5 owns the declared value; Parte 1 owns the requirement that it be declared and the method by which it is derived.

**Temporal framework instance:** The market-specific temporal framework instance — time zone, interval labeling, DST handling, and resolution — is owned by **Parte 2** (Transversal Market Values). Parte 1 owns the framework; Parte 2 instantiates it for the applicable market. This resolves the ownership gap identified during Parte 3 review.

---

## 12. Market Time Relationships

The following concepts shall remain distinct:

```text
Observation Time
      │
      ▼
Signal Publication
      │
      ▼
Bid / Nomination Window
      │
      ▼
Gate Closure
      │
      ▼
Award / Commitment
      │
      ▼
Delivery Period
      │
      ▼
Settlement Period
```

This is a **temporal relationship**, not a universal market lifecycle.

Actual ordering and timing shall be determined from the applicable market rules.

**Note:** The Bid/Nomination Window and Award stages are present only where the market mechanism requires them. For tariff, BTM, mandatory-provision, and uncommitted merchant participation, these stages may be absent.

**Environment vs. branch:** The market environment (wholesale or BTM) determines whether delivery is assessed against a baseline. The participation branch (1, 2, or 3) determines commitment semantics. These are separate axes and shall not be conflated.

---

## 13. Market Signals

Parte 1 establishes the generic semantic category of a market signal.

A market signal is an externally defined quantity, instruction, status, or condition whose meaning is established by the market environment.

Examples may include:

- energy price;
- reserve requirement;
- regulation signal;
- demand signal;
- tariff signal;
- market availability;
- **Operator Dispatch Instruction**;
- ancillary-service activation.

Parte 1 defines the generic signal concept.

Parte 4 shall define the detailed signals relevant to the applicable market.

### 13.1 Terminology Rules

**Dispatch.** The term "dispatch" is reserved for two distinct concepts, which shall not be conflated:

- **Operator Dispatch Instruction** — a market signal issued by the market/system operator, owned by Parte 4.
- **Asset Dispatch Decision** — the operational decision made by the asset, owned by Operational/Optimization Engineering.

The term "dispatch" shall be **qualified wherever its meaning is ambiguous**, and in every case where it refers to one of the two concepts above. Bare uses such as "dispatch obligation" or "dispatch instruction" shall be qualified unless the context unambiguously refers to one of the two terms.

**Price-responsive.** The term "price-responsive" is reserved for the §8 participation mode — participating in response to price without a commitment. It shall not be used as a synonym for price-taking, for price-influence behavior, or for any other concept.

### 13.2 Forecasting Boundary

Forecasting Engineering owns the methodology used to predict uncertain market variables.

The semantic boundary is:

> **Market defines what a signal means; Forecasting defines how it is predicted.**

---

## 14. Market Constraints

Parte 1 distinguishes three principal sources of constraints.

### 14.1 Market Constraints

Constraints originating from:

- market rules;
- product requirements;
- participation requirements;
- qualification rules;
- commitment rules;
- performance requirements.

**Ownership:** Product-specific participation and qualification constraints are owned by **Parte 3** (per the §9 boundary rule). Transversal market constraints — those applying across products — are owned by **Parte 4**.

### 14.2 Grid / Network Constraints

Constraints originating from:

- interconnection agreements;
- grid-connection requirements;
- network operator requirements;
- site-specific network limitations.

These are not market rules.

Where they affect market participation or operational obligations, they are represented in Parte 4 with their evidence source explicitly identified.

**Site/interconnection capability** is a distinct entity from operational network constraints. Its definition and value ownership are pending **P1-O14**. Once resolved, it is consumed by Parte 3's capability mapping. It is not a market rule and not a BESS physical constraint.

### 14.3 Physical Constraints

Physical BESS constraints (power, energy, SOC, degradation) are **not owned by Market Engineering**. They are consumed from BESS Engineering and represented in Parte 4 only where they affect market participation or operational obligations.

**Ownership of the Constraint entity:** §19 assigns ownership by *type* — product-specific market constraints to Parte 3, transversal market constraints to Parte 4, grid/network constraints to Parte 4 (with source evidence distinct), physical constraints to BESS Engineering.

---

## 15. Price-Influence and Market-Behavior Assumptions

Parte 1 shall establish the market-behavior assumption applicable to the model.

The assumption shall be stated on the **price-influence axis**:

- **price taker** — the BESS does not materially alter market price through its own participation;
- **price maker** — the BESS can materially alter market price through its own participation;
- **strategic participant** — the BESS models the reaction of other participants to its own participation;
- **other** — as explicitly specified.

This is a **modeling assumption**, not a universal market fact.

The assumption shall be recorded as a Parte 1 domain-level assumption and inherited by downstream Parts unless explicitly changed through project change control.

**Independence from participation mode:** The price-influence assumption is independent of the §8 participation mode. A BESS may be:

- a price taker *and* participating with a commitment;
- a price taker *and* participating on the null-commitment (price-responsive) path;
- a price maker *and* participating with a commitment;
- a price maker *and* participating on the null-commitment path (rare, but conceptually distinct).

The two axes shall not be conflated. "Price-responsive" (§8, §13.1) describes the participation mode, not the price-influence assumption.

---

## 16. Evidence Model

Parte 1 establishes the common evidence model used throughout Market Engineering.

Every material market statement shall be represented as an **Evidence Statement** linked to one or more **Evidence Sources**, and assigned one of four categories.

### 16.1 Evidence Categories

**Verified Rule** — directly supported by authoritative market, regulatory, contractual, or network documentation applicable to the model.

**Engineering Interpretation** — a technically reasoned interpretation of available evidence where the source does not directly express the engineering representation.

**Modeling Assumption** — a deliberate assumption required to construct or execute the model.

**Unresolved Requirement** — a requirement whose meaning, applicability, or source remains insufficiently established.

The category belongs to the **statement**, not to the source. One source may support statements in different categories.

**Project-requirement-only statements:** A statement supported only by project or customer requirements is categorized as a **Verified Rule** only if the requirement is contractually or regulatorily binding; otherwise it is categorized as an **Engineering Interpretation** or a **Modeling Assumption**, as appropriate. The distinction shall be recorded explicitly.

### 16.2 Evidence Source Record

Each Evidence Source shall carry, at minimum:

| Field | Description |
| --- | --- |
| **Source ID** | Unique identifier |
| **Source Type** | Regulatory / market rule / market manual / settlement doc / network requirement / project requirement / contract / technical doc / historical data |
| **Issuing Authority** | Entity that issued the source |
| **Version** | Document or rule version. For historical data, the coverage period is recorded instead. |
| **Effective From** | Date from which the source applies. For historical data, the start of the coverage period. |
| **Effective To** | Date until which the source applies (or "open"). For historical data, the end of the coverage period. |
| **Location / URI** | Where the source can be retrieved or cited |
| **Supersedes** | Source ID this record supersedes, if any |

### 16.3 Evidence Statement Record

Each Evidence Statement shall carry, at minimum:

| Field | Description |
| --- | --- |
| **Statement ID** | Unique identifier |
| **Claim** | The market statement being made |
| **Category** | Verified Rule / Engineering Interpretation / Modeling Assumption / Unresolved Requirement |
| **Owner** | Engineering domain responsible for the statement |
| **Linked Source IDs** | One or more Evidence Source IDs |
| **Applicable Part** | Parte 1 / Parte 2 / Parte 3 / Parte 4 / Parte 5 |
| **Review Status** | Draft / Under Review / Approved / Superseded |
| **Review Date** | Date of last review |

**Cardinality:** one statement → many sources; one source → many statements.

### 16.4 Materiality

A statement is **material** if it affects eligibility, dispatch, delivery, settlement, or financial outputs. Evidence depth and validation rigor shall be proportional to materiality.

Materiality is assessed in **tiers**:

| Tier | Criterion | Required evidence depth |
| --- | --- | --- |
| **Tier 1 — Outcome-changing** | The statement can change an eligibility outcome, or move settlement by more than a defined threshold, or alter the existence or scope of a commitment. | At least one Verified Rule source; independent review required. |
| **Tier 2 — Quantity-affecting** | The statement affects modeling quantities but not the outcome or commitment existence. | At least one authoritative source; internal review required. |
| **Tier 3 — Contextual** | The statement provides context, definition, or framing without directly affecting outcomes or quantities. | Source reference required; review optional. |

The threshold for Tier 1 settlement impact shall be defined per project and recorded in the evidence register.

Without effective dates, the model cannot represent rule changes over the asset life, and historical validation cannot be performed for periods spanning a rule change.

---

## 17. Evidence Hierarchy

Where multiple sources exist, evidence shall be evaluated according to authority and applicability.

The preferred hierarchy **for rule authority** is:

1. applicable regulatory requirements;
2. official market rules and manuals;
3. official market participation and settlement documentation;
4. official network/interconnection requirements;
5. **binding contractual documentation imposing market-relevant obligations**;
6. project/customer requirements;
7. authoritative technical documentation;
8. historical market data;
9. engineering interpretation;
10. modeling assumption.

**Scope vs. authority:** For *scope selection* (§6), project/customer requirements are used first. For *rule authority* (this section), they rank sixth. The two orderings answer different questions and shall not be conflated. The ordering is stated once in §6 and cross-referenced here.

**Contracts:** Contractual documentation is a valid source of Verified Rule evidence where the contract imposes **market-relevant obligations** — for example, a binding aggregator agreement, an offtake agreement with market-relevant terms, or the commercial terms of an interconnection agreement. Contracts do **not** extend Market Engineering into commercial/contractual modeling, which remains out of scope per the Introduction and P1-O12. Contracts rank at position 5 because a binding obligation may override a project preference but may not override a regulatory or market-operator rule.

**Interconnection agreements:** An interconnection agreement is classified as a **network requirement** (position 4) for its technical obligations and as a **contract** (position 5) for its commercial obligations. The same document may therefore appear under two source records with different source types and different applicable obligations.

Historical data may validate observed behavior but does not automatically override an explicit market rule.

An assumption shall never be represented as a verified market rule.

---

## 18. Uncertainty Ownership

Uncertainty is cross-cutting.

Parte 1 establishes the ownership principle:

> **Each Part owns the uncertainty associated with the rules and concepts it defines.**

Additionally:

- Parte 1 owns domain-scope, role, structural, and foundational assumption uncertainty;
- Parte 2 owns transversal value and eligibility-path transversal value uncertainty;
- Parte 3 owns product, qualification, and eligibility-rule uncertainty;
- Parte 4 owns market-rule, signal, market-data, commitment, and operational-constraint uncertainty;
- Parte 5 owns delivery, performance, and settlement uncertainty.

Regulatory and market-rule changes over the asset life shall be treated as **long-horizon uncertainty**.

An uncertain forecast shall not be used to conceal an uncertain market rule.

An uncertain market rule shall not be converted silently into a modeling assumption.

---

## 19. Single Semantic Ownership

Every market concept shall have one authoritative semantic owner.

The principal ownership structure is:

| Concept | Owner |
| --- | --- |
| Physical BESS capability | BESS Engineering |
| Physical constraint | BESS Engineering |
| Market environment | Parte 1 |
| Participant role | Parte 1 |
| Market party (entity model) | Parte 1 |
| Market behavior assumption (price-influence axis) | Parte 1 |
| Temporal mapping framework | Parte 1 |
| Resolution mapping method | Parte 1 |
| Opportunity (definition) | Parte 1 |
| Signal (generic concept) | Parte 1 |
| Market product (definition) | Parte 3 |
| Eligibility | Parte 3 |
| Product-specific participation / qualification rules | Parte 3 |
| Product-specific market constraints | Parte 3 |
| Participation mechanism | Parte 3 |
| Opportunity (application) | Parte 4 |
| Market rule (transversal) | Parte 4 |
| Market signal (specific) | Parte 4 |
| Signal (application) | Parte 4 |
| Operator Dispatch Instruction | Parte 4 |
| Market commitment | Parte 4 |
| Bid / Nomination | Parte 4 |
| Award | Parte 4 |
| Delivery obligation (part of the commitment) | Parte 4 |
| Stacking / coexistence | Parte 4 |
| Transversal market constraints | Parte 4 |
| Grid / network constraints (market-relevant) | Parte 4 |
| Site/interconnection capability (definition and value ownership) | Parte 1 (definition); Network Engineering (value ownership, pending P1-O14) |
| Site/interconnection capability (consumption) | Parte 3 (capability mapping) |
| Temporal rule values (gate closure, delivery timing, settlement timing) | Parte 4 |
| Temporal framework instance (time zone, interval labeling, resolution) | Parte 2 |
| Transversal market values (eligibility path) | Parte 2 |
| Asset Dispatch Decision | Operational/Optimization Engineering |
| Delivery definition and measurement | Parte 5 |
| Performance measurement | Parte 5 |
| Baseline / Counterfactual | Parte 5 |
| Settlement | Parte 5 |
| Authoritative settlement quantity (declared per product) | Parte 5 |
| Financial consequence | Financial Engineering |
| Forecast methodology | Forecasting Engineering |
| Network Engineering | Introduction v1.3 (pending) |
| Evidence Source | Owning Part (per record) |
| Evidence Statement | Owning Part (per record) |
| Network-side constraint evidence | Network Engineering (defined in Introduction v1.3; pending) |

### 19.1 Definition–Instance Rule

Where a concept has both a domain-level definition and a market-specific application, the **definition is owned by the Part that defines the concept**, and the **application is owned by the Part that applies it**. Ownership shall be recorded as two separate rows in the §19 table — one for the definition, one for the application — rather than as a split within a single row.

This rule is applied consistently to:

- **Opportunity** — Parte 1 owns the definition; Parte 4 owns the application.
- **Signal** — Parte 1 owns the generic concept; Parte 4 owns specific signals and the application.
- **Product** — Parte 3 owns the definition; Parte 4 owns the application in market rules.
- **Commitment** — Parte 4 owns the definition (Commitment Definition) and the application (Commitment Instance). Parte 5 owns the assessment of the instance.

The rule does **not** transfer eligibility ownership: eligibility remains with Parte 3, because eligibility is defined at the product level, not at the application level.

### 19.2 Reference Rule

Where a downstream Part needs a concept owned by another Part, it **references the concept by identifier** and does not redefine it.

This ownership model prevents circular semantic dependencies.

---

## 20. Market Symbol and Convention Control

Parte 1 shall use the project-wide master symbol registry established by BESS Engineering Part 1.

Parte 1 may identify required market-specific symbols, but shall not establish an independent registry.

For each required market symbol, the engineering process shall ensure:

- unique symbol;
- semantic definition;
- unit;
- dimensional consistency;
- source;
- owner;
- applicable Part;
- lifecycle status.

The symbol itself is registered in the project-wide registry.

Any change to a registered market symbol shall follow project change control.

**Identifier scheme:** Market-specific **identifiers** (distinct from mathematical symbols) are governed by the cross-Part identifier scheme defined in **Parte 3 §4.5**. Identifiers use the format `<type>-<sequence>` (e.g., `PROD-001`, `PM-001`), are unique on the unprefixed form, and are stable across versions. The namespace prefix is optional and display-only. Ownership is recorded in a field, not in the identifier. The identifier registry is separate from the BESS Engineering Part 1 master symbol registry.

---

## 21. Interfaces

### 21.1 BESS Engineering

**Consumes from BESS:**

- physical capability;
- operating limits;
- power and energy capability;
- SOC/SOH-related capabilities;
- response characteristics;
- physical constraints;
- the degradation curve used for eligibility assessment.

**Provides back to BESS:**

- market-driven capability requirements;
- response-time requirements;
- duration requirements;
- qualification requirements;
- other market requirements that may affect asset specification.

### 21.2 Parte 2–Parte 5

Parte 1 provides the common domain semantics and conventions required by:

- Parte 2 — Transversal Market Values;
- Parte 3 — Products and Participation;
- Parte 4 — Rules, Signals, Commitments and Constraints;
- Parte 5 — Delivery, Performance and Settlement.

### 21.3 Forecasting Engineering

Parte 1/Parte 4 define:

- market-variable semantics;
- signal meaning;
- timing;
- publication/observation relationships;
- uncertainty categories.

Forecasting Engineering defines:

- forecasting methodology;
- prediction models;
- forecast generation.

### 21.4 Operational / Optimization Engineering

Market Engineering provides:

- eligibility conditions;
- commitments;
- operational obligations;
- market constraints;
- delivery requirements;
- relevant signals.

Operational/Optimization Engineering provides:

- Asset Dispatch Decisions;
- operating trajectories;
- raw delivered quantities (metered or simulated).

The semantic boundary is:

> **Market defines any commitment and its requirements; Operational/Optimization defines the Asset Dispatch Decision, whether or not a commitment exists.**

### 21.5 Financial Engineering

Market Engineering provides:

- market settlement quantities;
- settlement prices;
- settlement amounts;
- delivery quantities;
- penalties;
- adjustments;
- other settlement outputs.

Financial Engineering transforms these into economic consequences (discounting, tax, NPV, IRR).

### 21.6 Software Engineering

Parte 1 defines the semantic and structural requirements that software must represent.

Software Engineering determines implementation architecture and technology.

### 21.7 Network Engineering

**Network Engineering** is the engineering domain responsible for network-side analysis and evidence that support grid and network constraints and site/interconnection capability. It is distinct from:
- **Network Operator** (a role in §5, performed by an external party);
- **BESS Engineering** (which owns the physical BESS model).

**Network Engineering is defined in the Introduction (v1.3).** Parte 1 references it. Until Introduction v1.3 is issued, the Network Operator role and BESS Engineering jointly perform these functions.

Network Engineering provides:
- network constraint identification and analysis;
- interconnection agreement technical obligations;
- grid-connection requirement evidence;
- network-operator requirement evidence;
- site-specific network limitation evidence;
- **site/interconnection capability evidence and value** (pending P1-O14).

---

## 22. Change Control

Market requirements can modify assumptions about the physical asset.

Examples include:

- minimum duration requirements;
- minimum power requirements;
- response-time requirements;
- telemetry requirements;
- availability requirements;
- minimum bid size;
- state-of-charge requirements;
- qualification tests.

When such requirements affect BESS physical specifications or engineering assumptions, the requirement shall propagate:

**Market Requirement → Change Control → BESS Engineering Review → Updated Physical Model**

No Market Engineering Part shall silently modify the BESS physical model.

**Change control for shared artifacts:** Changes to the canonical lifecycle, the optional-node rule, the null-commitment path rule, the product template reference rule, or the split into Parte 2 and Parte 4 are owned by the **Introduction Document**. Such changes shall be made in the Introduction and referenced from Parte 1–Parte 5. Parte 1 does not declare them unilaterally.

---

## 23. Parte 1 Open Items

The following items must be resolved before Parte 1 can be frozen.

| ID | Open item | Required outcome | Owner | Priority | Blocking dependency | Target date |
| --- | --- | --- | --- | --- | --- | --- |
| P1-O01 | Jurisdiction | Applicable market jurisdiction identified | Market Engineering Lead | Critical | Blocks P1-O02–P1-O12 | TBD |
| P1-O02 | Market operator | Responsible market/system operator identified | Market Engineering Lead | Critical | Depends on P1-O01 | TBD |
| P1-O03 | Wholesale / BTM | Applicable participation environment established | Market Engineering Lead | Critical | Depends on P1-O01, P1-O02 | TBD |
| P1-O04 | Participant roles | Actual roles mapped to domain entities | Market Engineering Lead | High | Depends on P1-O01, P1-O02 | TBD |
| P1-O05 | Products | Candidate product universe identified for Parte 3 | Market Engineering Lead | High | Depends on P1-O03 | TBD |
| P1-O06 | Market periods | Applicable bid, commitment, delivery, and settlement periods identified | Market Engineering Lead | High | Depends on P1-O03 | TBD |
| P1-O07 | Network environment | Applicable grid/interconnection constraints identified | Market Engineering Lead | Medium | Depends on P1-O01 | TBD |
| P1-O08 | Market behavior | Price-influence assumption established | Market Engineering Lead | High | Depends on P1-O03 | TBD |
| P1-O09 | Evidence sources | Authoritative source set established | Market Engineering Lead | High | Depends on P1-O01, P1-O02 | TBD |
| P1-O10 | Data boundary | Required external market-data categories identified | Market Engineering Lead | Medium | Depends on P1-O03, P1-O06 | TBD |
| P1-O11 | Regulatory horizon | Relevant long-horizon rule changes identified | Market Engineering Lead | Medium | Depends on P1-O09 | TBD |
| P1-O12 | Commercial boundary | Any required separation from contractual/commercial modeling confirmed | Market Engineering Lead | Medium | Depends on P1-O03 | TBD |
| P1-O13 | Pinned dependency | BESS Engineering Part 1 version pinned in Parte 1 header | BESS Engineering + Market Engineering Lead | Critical | Blocks freeze; independent of P1-O01–P1-O03 | TBD |
| **P1-O14** | **Site/interconnection capability** | **Entity definition and value ownership established; consumed by Parte 3's capability mapping** | **Parte 1 Lead + Network Engineering** | **High** | **Depends on Introduction v1.3; blocks Parte 3 and Parte 4 freeze** | **TBD** |

These are **engineering open items**, not assumptions to be silently resolved by the model.

**Critical path:** P1-O01 → P1-O02 → P1-O03 block nearly all other items and shall be resolved first. P1-O13 blocks freeze independently of the P1-O01–P1-O03 chain. P1-O14 blocks Parte 3 and Parte 4 freeze independently.

---

## 24. Parte 1 Validation Criteria

Parte 1 shall be validated before proceeding to a frozen Parte 2 baseline.

Each validation category shall specify **method**, **reference case**, **reviewer**, and **pass/fail condition**.

### Domain Validation

- **Method:** Comparison against authoritative market documentation and project requirements.
- **Reference case:** Defined jurisdiction and market environment.
- **Reviewer:** Market Engineering Lead + independent reviewer.
- **Pass condition:** Modeled environment matches the intended market context, and all scope items are either resolved or explicitly accepted as controlled assumptions per §23.

### Role Validation

- **Method:** Mapping of actual market roles to the generic role model, and mapping of Market Parties to roles.
- **Reference case:** Market rules and participant agreements.
- **Reviewer:** Market Engineering Lead.
- **Pass condition:** Every applicable role is mapped; no role is assumed without evidence; no Market Party is assigned a role without evidence.

### Semantic Validation

- **Method:** Concept-by-concept review against the ownership table (§19), the definition–instance rule (§19.1), the reference rule (§19.2), and the terminology rules (§13.1).
- **Reference case:** Introduction v1.2 rules plus the downstream Parts' drafts (Parte 2–Parte 5). This document alone is not a sufficient reference case.
- **Reviewer:** Independent semantic reviewer.
- **Pass condition:** Each concept has one owner; no concept is defined twice; no text uses "dispatch" or "price-responsive" in an unqualified or ambiguous way.

### Temporal Validation

- **Method:** Test cases covering interval labeling, time-zone boundaries, and resolution mismatch.
- **Reference case:** At least one time-zone-boundary case (a market interval that straddles a UTC offset change, whether or not DST applies) and one resolution-mismatch case (market data at a finer resolution than the project model). A DST transition case is included **only if the target jurisdiction observes DST**.
- **Reviewer:** Market Engineering Lead + BESS Engineering.
- **Pass condition:** All applicable test cases produce the expected mapping.

### Boundary Validation

- **Method:** Interface review with BESS, Forecasting, Operational/Optimization, Financial, Software, and Network Engineering.
- **Reference case:** Interface definitions in §21.
- **Reviewer:** Cross-domain review board.
- **Pass condition:** No responsibility is claimed by two domains; no responsibility is unowned.

### Evidence Validation

- **Method:** Traceability audit. For every **material** statement (per §16.4), verify that a Statement Record exists with a category, an owner, a review status, and at least one linked Source Record with version, effective dates, and location.
- **Reference case:** At least the critical-path evidence set.
- **Reviewer:** Independent evidence reviewer.
- **Pass condition:** Every material statement has a complete Statement Record and at least one complete Source Record. No material statement is unsupported. Tier-1 statements have at least one Verified Rule source.

### Consistency Validation

- **Method:** Symbol and convention audit against BESS Engineering Part 1 (pinned version).
- **Reference case:** BESS Engineering Part 1 (pinned version, per P1-O13).
- **Reviewer:** BESS Engineering.
- **Pass condition:** No conflicting symbols, units, state conventions, or temporal conventions.

### Network Engineering Boundary Validation

- **Method:** Interface review with Network Engineering (or, until Introduction v1.3, the Network Operator role and BESS Engineering).
- **Reference case:** Interface definition in §21.7.
- **Reviewer:** Cross-domain review board.
- **Pass condition:** Site/interconnection capability evidence and value ownership are correctly assigned; no network-side constraint is recorded as a market rule.

---

## 25. Parte 1 Acceptance Criteria

Parte 1 is ready for engineering freeze when:

- the applicable market environment is identified;
- market scope is explicit;
- wholesale/BTM applicability is resolved;
- participant roles are defined and mapped to Market Parties;
- core market entities are defined, with entity/role distinction preserved;
- the market semantic model is internally consistent and supports all three participation branches (bid → commitment; no-bid → commitment; no-bid → null commitment);
- market-specific periods are mapped to project temporal conventions, including interval labeling, DST handling where applicable, and resolution mapping;
- the temporal framework instance ownership is assigned to Parte 2;
- price-influence assumption is explicit and separated from participation mode;
- grid/network constraints have an identified source and interface;
- site/interconnection capability (P1-O14) is resolved or explicitly deferred with rationale;
- site/interconnection capability definition and value ownership are established (P1-O14);
- Network Engineering is defined in Introduction v1.3, or the provisional arrangement (Network Operator role + BESS Engineering) is documented;
- evidence classification is applied through linked Source and Statement records;
- materiality tiers are defined and applied;
- uncertainty ownership is assigned;
- semantic ownership is unambiguous and complete, including the definition–instance rule and its separate rows for definition and application;
- interfaces with BESS, Parte 2–Parte 5, Forecasting, Operational/Optimization, Financial, Software, and Network Engineering are defined;
- market-derived requirements can propagate upstream through change control;
- changes to Introduction-owned artifacts are made in the Introduction and referenced from Parte 1;
- all required market symbols are registered through BESS Engineering Part 1;
- no independent market symbol authority exists;
- open items have been resolved or explicitly accepted as controlled assumptions, with owners, priorities, dependencies, and dispositions recorded;
- P1-O13 (pinned BESS Part 1 version) is resolved;
- validation criteria have been satisfied with documented method, reference case, reviewer, and pass/fail result.

---

## 26. Parte 1 Maturity

Parte 1 follows the project-wide maturity ladder:

**Semantic Definition → Internal Consistency → External Evidence → Engineering Validation → Frozen**

Current status:

- **Semantic Definition — established**
- **Internal Consistency — ready for validation**
- **External Evidence — pending market/jurisdiction identification (P1-O01–P1-O03)**
- **Engineering Validation — pending**
- **Frozen — No**

Parte 1 should not proceed to **Frozen** until the applicable market environment and authoritative evidence base are established.

**Note on diminishing returns:** The remaining consistency issues are minor. Further abstract iteration on Parte 1 will add little. The next real gain is **External Evidence**, which is blocked on P1-O01 through P1-O03. Once those are resolved, instantiating the framework against real market documents will test it more effectively than another review round.

**Roadmap note:** P1-O01–P1-O03 are the **single blocking decision** for the entire Market Engineering sequence. Everything downstream — Parte 2, Parte 3, Parte 4, Parte 5, and the pilot — depends on knowing which market the BESS will operate in.

---

## 27. Output of Parte 1

The final output of Parte 1 shall be a controlled **Market Domain Specification** containing:

1. market scope;
2. market environment definition;
3. participant-role model;
4. market entity model (with entity/role distinction preserved);
5. market semantic model (with optional paths, three participation branches, and null-commitment representation);
6. market-specific temporal mapping framework (including interval labeling, DST handling, and resolution mapping);
7. market-domain assumptions (including price-influence axis);
8. evidence model (linked Source and Statement records; categories; materiality tiers);
9. uncertainty ownership;
10. semantic ownership (complete, including definition–instance rule with separate rows);
11. interface definitions;
12. grid/network boundary;
13. change-control relationships;
14. registered market symbols through BESS Part 1;
15. resolved assumptions and open-item disposition;
16. Network Engineering interface (or provisional arrangement);
17. Identifier scheme reference (Parte 3 §4.5).

This output becomes the formal semantic foundation for:

**Parte 2 — Transversal Market Values**

which will then answer the next engineering question:

> **Which transversal market values — gate closure conventions, registration requirements, timing conventions, data formats, transversal minimum sizes, and eligibility-relevant limits — apply across all products in the defined market environment?**

---

### Parte 3 Product Definition Template (Referenced, Not Owned)

The Parte 3 product template and the "reference, do not redefine" rule are **owned by the Introduction Document v1.2**. Parte 3 shall apply them. The list below is **informative** and shall be kept in sync with the Introduction.

**Parte 3 references, but does not redefine, concepts owned by Parte 4 and Parte 5.** Specifically:

- Market Signal → reference Parte 4 identifier
- Operator Dispatch Instruction → reference Parte 4 identifier
- Commitment → reference Parte 4 identifier
- Delivery Obligation → reference Parte 4 identifier
- Delivery Definition and Measurement → reference Parte 5 identifier
- Performance Measurement → reference Parte 5 identifier
- Settlement Mechanism → reference Parte 5 identifier
- Interaction with Other Products (stacking/coexistence) → reference Parte 4 identifier

Parte 3 defines only what is product-specific: definition, market purpose, eligibility, required BESS capability, participation mechanism, temporal requirements specific to the product, and product-specific risks and uncertainties.

---

### Parte 2 Temporal Framework Instance (Referenced, Not Owned)

The **temporal framework instance** — time zone, interval labeling, DST handling, and resolution for the applicable market — is owned by **Parte 2** (Transversal Market Values). Parte 1 owns the framework; Parte 2 instantiates it. This resolves the ownership gap identified during Parte 3 review.

Parte 1 references the Parte 2 temporal framework instance from §11.3 without redefining it.

---

### Parte 4 Award Simulation Rule (Referenced, Not Owned)

The **Award Simulation Rule** (P4-O17) — defining when a simulated bid clears under the price-taker assumption — is owned by **Parte 4** (clearing rule) and **Operational/Optimization Engineering** (bid). It is required before the energy pilot. Parte 1 references it without defining it.

---

*End of Parte 1 — Market Domain and Conventions (v1.3)*