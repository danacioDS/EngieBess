# STAGE-C-PLAN-001 — Stage C Product Specification Plan (v1.0.2 — Baseline, Errata Applied)

**Document ID:** STAGE-C-PLAN-001

**Version:** 1.0.2 — Baseline (Errata Applied)

**Status:** Stage C — Plan (Baseline)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Language:** English

**Parent Documents:**

- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6.1)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.3)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.4)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v1.0)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.4)
- `A.2.6-FIN-ENG-001` — Financial Engineering (v0.3)
- `A.2.7-DATA-APP-ENG-001` — Data & Application Engineering (v0.3)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)
- `STAGE-A-CONSOL-REPORT-001` — Stage A Consolidation Report (v1.1)
- `STAGE-B-HLD-INDEX-001` — Stage B HLD Master Index and Scope Definition (v0.2)
- `STAGE-B-TO-C-HANDOFF-001` — Stage B → Stage C Handoff (v0.2 Baseline Frozen)
- `B.0-INTEGRATED-SYS-ARCH-001` — B.0 Integrated System Architecture (v0.3.3)
- `B.1-DATA-ARCH-001` — B.1 Data Architecture (v0.3)
- `B.2-MODEL-ARCH-001` — B.2 Model Architecture (v0.5.1)
- `B.3-OPT-ARCH-001` — B.3 Optimization Architecture (v0.6.1)
- `B.4-FIN-ARCH-001` — B.4 Financial Architecture (v0.4)
- `B.5-SW-ARCH-001` — B.5 Software Architecture (v0.4.1)
- `B.6-DBX-ARCH-001` — B.6 Databricks Architecture (v0.4)

**Purpose:** Establish the master plan for Stage C (Product Specification — Detailed Engineering), declaring the deliverables, their scope, the production sequence, the level-of-detail rule distinguishing Stage C from Stage D, the review and freeze process, the closure criteria, the Stage C → Stage D Handoff criteria, and the traceability chain that connects the RFP to the implementation.

**Change log.** See §16.

---

## 0. Document Control

### 0.1 Document Identity

| Aspect | Value |
|---|---|
| **Document ID** | `STAGE-C-PLAN-001` |
| **Version** | 1.0.2 — Baseline (Errata Applied) |
| **Status** | Stage C — Plan (Baseline) |
| **Project** | ENGIE — BESS Operational & Financial Modeling |
| **Engagement** | RFP-264144-1 |
| **Language** | English |

### 0.2 Definition of "Product Specification"

> **For this engagement, "Product Specification" refers to the complete system-level technical specification of the BESS operational and financial modeling solution — including data, computational models, optimization, financial valuation, software, platform realization, and validation. It does not refer to a commercial product specification, marketing collateral, or a packaged software product definition.**

The term **Product Specification** is the official term for Stage C. Where other documents or sections use "system specification", it is to be read as synonymous with "Product Specification" within this engagement.

Stage C is the **system-level detailed specification** that turns the frozen Stage B architecture into an implementable and verifiable system.

### 0.3 Purpose

This document establishes:

- The **master plan** of Stage C
- The **scope** of each Stage C deliverable
- The **production sequence** of C.1–C.7
- The **dependency chain** between deliverables, including permitted iteration
- The **level-of-detail rule** distinguishing Stage C from Stage D
- The **review and freeze process** for Stage C
- The **closure criteria** for Stage C
- The **Stage C → Stage D Handoff** criteria
- The **Stage C Traceability Chain** connecting RFP → A → B → C → D → Test → UAT
- The **meaning of "frozen"** for a Stage C deliverable
- The **handling of unresolved and open items**

It is a **contract document** between the consultant and ENGIE: it defines what Stage C will produce before production begins.

### 0.4 Scope

**In scope:**

- Master plan of Stage C
- Scope definition per deliverable
- Production sequence
- Level-of-detail classification (Stage C / Stage D)
- Ownership rules between adjacent deliverables
- Review and freeze process
- Closure criteria
- Stage C → Stage D Handoff criteria
- Traceability chain
- Meaning of freeze
- Handling of unresolved items

**Out of scope:**

- The actual content of Stage C deliverables (produced in C.1–C.7)
- Any Stage A or Stage B content (already closed and frozen)
- Any Stage D content (implementation)

---

## 1. Purpose of This Plan

### 1.1 Why a Plan Document

Before producing the Stage C deliverables, the **structure, scope, ownership, and production sequence** must be defined. Producing Stage C without a plan risks:

- **Scope creep** — C.1 becoming C.1–C.7 by accident
- **Duplication** — the same specification appearing in multiple deliverables
- **Ownership ambiguity** — overlapping boundaries between adjacent deliverables
- **Premature implementation** — Stage C becoming Stage D
- **Inconsistency** — different deliverables contradicting each other
- **Lost traceability** — requirements not carried from RFP to validation

The plan document **constrains** Stage C before production and **provides the criteria used to verify Stage C closure**.

### 1.2 How This Document Is Used

| Phase | Use |
|---|---|
| **Before Stage C production** | Define the structure, scope, ownership, and sequence |
| **During Stage C production** | Reference for deliverable scope, ownership, and level of detail |
| **After Stage C production** | Checklist for Stage C review and closure |
| **Stage D start** | Confirm handoff criteria |

### 1.3 Relationship to Stage B

Stage B answered:

> **How are the engineering responsibilities structurally organized into an executable system?**

Stage C answers:

> **What exactly must be built to implement the frozen architecture?**

This plan declares **how** Stage C will answer that question.

---

## 2. Stage C Scope

### 2.1 What Stage C Produces

Stage C produces the **Product Specification** — the detailed engineering that turns the frozen Stage B architecture into an implementable and verifiable system.

| # | Deliverable | Description |
|---|---|---|
| **C.1** | **Data Specification** | Data domains, logical entities, physical schemas, column definitions, keys, constraints, time semantics, scenario/run identity, partitioning, Z-ordering, Delta behavior, data-level lineage requirements, ingestion requirements and logical ingestion behavior, validation rules, acceptance criteria |
| **C.2** | **Computational Model Specification** | Logical class/service identity, inputs, outputs, state, preconditions, postconditions, invariants, domain-level interface contracts, data and type requirements, error behavior, numerical schemes, lifecycle |
| **C.3** | **Optimization Specification** | Objective structure, constraint formulations, decision variables, solver selection constraints and evaluation criteria, solver configuration requirements, numerical tolerances, horizon implementation, initial SOC mechanism, feasibility handling |
| **C.4** | **Financial Specification** | Cash-flow structure, revenue attribution, discounting conventions, tax and depreciation methodology, ITC treatment, debt structure, distribution waterfall, terminal value, multiple-IRR handling |
| **C.5** | **Software Specification** | Software unit structure, software-unit interfaces, service interfaces, application-facing API contracts, request/response schemas, service boundaries, authentication requirements, interface behavior, error contracts, configuration schema, test specifications |
| **C.6** | **Platform Specification** | API hosting mechanism, Databricks App realization, networking, identity integration, secrets, compute, Jobs/Tasks topology, catalogs, permissions, platform NFRs, cost model, SLOs, platform-level realization of data and lineage requirements |
| **C.7** | **Testing and Validation Specification** | Consolidated test strategy, UAT scenarios, validation evidence format — consolidating the acceptance criteria, invariants, and validation requirements defined within each Stage C deliverable |

### 2.2 What Stage C Does Not Produce

| Not in Stage C | Belongs to |
|---|---|
| Code (Python, PySpark, SQL) | Stage D |
| CI/CD pipelines | Stage D |
| Notebooks | Stage D |
| Job / Task code | Stage D |
| App code | Stage D |
| API handler code | Stage D |
| Deployment execution | Stage D |
| UAT execution | Stage D |

### 2.3 Relationship to Stage D

Stage C **specifies**. Stage D **implements**.

**Stage C specifies:**

- Logical class / service identity
- Inputs, outputs, state
- Preconditions, postconditions, invariants
- Interface contracts (domain-level)
- Data and type requirements
- Error behavior
- Numerical schemes and semantics
- Table schemas, keys, constraints
- Objective and constraint formulations
- Cash-flow structure
- API contracts, request/response schemas
- Job / Task topology (contractual, not configuration)
- Test specifications

**Stage D implements:**

- Python class bodies
- Internal data structures
- Algorithm implementation
- Package / module code
- Job / Task code
- App code
- API handler code

**Rule.** Stage C defines the **technical decisions required to make the system implementable and verifiable**. It does not define the internal implementation mechanics used to realize those decisions.

Where the target language is already fixed by the RFP (Python for the modeling engine), Stage C may use language-specific notation — but Stage C does not impose implementation decisions beyond what the contract requires.

---

## 3. Stage C Deliverables Overview

### 3.1 Structure

```
STAGE C — PRODUCT SPECIFICATION
│
├── C.1 Data Specification
├── C.2 Computational Model Specification
├── C.3 Optimization Specification
├── C.4 Financial Specification
├── C.5 Software Specification
├── C.6 Platform Specification
├── C.7 Testing & Validation Specification
│
└── Stage C → Stage D Handoff
```

### 3.2 Production Order and Controlled Iteration

**Nominal production order:**

```
B.0–B.6
    │
    ▼
   C.1
    │
    ▼
   C.2
    │
    ▼
   C.3
    │
    ▼
   C.4
    │
    ▼
   C.5
    │
    ▼
   C.6
    │
    ▼
   C.7
    │
    ▼
 C → D Handoff
```

**Rule.** The sequence above is the **nominal production order**. Cross-deliverable iteration is permitted where a downstream specification reveals a dependency, inconsistency, or missing requirement affecting an upstream specification. Such iteration is controlled through change control and does not constitute unrestricted redesign.

**Examples of permitted iteration:**

- C.2 may reveal a data requirement not fully determined in C.1
- C.3 may reveal a variable or constraint needed by C.2
- C.5 is produced after the upstream computational and optimization semantics are sufficiently defined, but controlled feedback from C.5 to C.2/C.3 is permitted where software realization exposes an unresolved contract issue

**Rule.** Such feedback shall not redefine frozen domain or optimization semantics without formal change control.

**Rule.** Iteration is **feedback**, not circular dependency. It is managed through change control.

### 3.3 Relationship Between Deliverables

| Deliverable | Produces | Consumed by |
|---|---|---|
| **C.1** | Data specification | C.2, C.3, C.4, C.5, C.6, C.7 |
| **C.2** | Computational model specification | C.3, C.4, C.5, C.7 |
| **C.3** | Optimization specification | C.4, C.5, C.7 |
| **C.4** | Financial specification | C.5, C.7 |
| **C.5** | Software specification | C.6, C.7 |
| **C.6** | Platform specification | C.7 |
| **C.7** | Consolidated testing & validation specification | Stage D |

**Rule.** No deliverable is frozen before its dependencies are sufficiently defined. Iteration is managed through change control.

### 3.4 Ownership Rules Between Adjacent Deliverables

The following rules fix ownership between adjacent deliverables and prevent overlap.

**Rule — C.2 vs C.5.**

> **C.2 owns the computational and domain-level contracts of model objects. C.5 owns software realization boundaries, software-unit interfaces, service interfaces, and application-facing contracts. C.2 shall not define package or module structure. C.5 shall not redefine domain or computational semantics.**

**Rule — C.1 vs C.6.**

> **C.1 specifies data semantics, schemas, validation rules, and data-level lineage requirements. C.6 specifies the platform realization of those requirements, including Databricks storage, catalogs, permissions, compute, and operational mechanisms.**

**Rule — C.4 vs Market / Settlement.**

> **C.4 consumes market and settlement outputs defined by the applicable market and settlement interfaces. C.4 shall not redefine market product rules, eligibility, dispatch commitments, delivery rules, or settlement semantics.**

**Rule — C.6 vs C.5.**

> **C.5 defines what the software interface means (contract, semantics, error behavior, request/response schema). C.6 defines where and how that interface is physically hosted (Databricks App realization, networking, identity, secrets, compute).**

**Rule — C.7 as consolidator.**

> **C.7 consolidates the validation requirements, invariants, and acceptance criteria defined within C.1–C.6. C.7 shall not redefine upstream technical or domain semantics, but may identify and formally document validation coverage gaps required to demonstrate compliance with the frozen specifications.**

**Rule — Job / Task topology vs Job configuration.**

> **C.6 specifies the contractual Job / Task topology, dependencies, execution semantics, and barriers. Stage D implements the actual Databricks Job definitions, task configuration, parameters, runtime configuration, and deployment code.**

---

## 4. Master Index — Stage C Deliverables

### 4.1 Planned Deliverables

| Order | Deliverable | Document ID | Version | Status |
|---|---|---|---|---|
| 1 | **C.1 Data Specification** | `C.1-DATA-SPEC-001` | — | ⏭ Next |
| 2 | **C.2 Computational Model Specification** | `C.2-MODEL-SPEC-001` | — | ⏭ Pending |
| 3 | **C.3 Optimization Specification** | `C.3-OPT-SPEC-001` | — | ⏭ Pending |
| 4 | **C.4 Financial Specification** | `C.4-FIN-SPEC-001` | — | ⏭ Pending |
| 5 | **C.5 Software Specification** | `C.5-SW-SPEC-001` | — | ⏭ Pending |
| 6 | **C.6 Platform Specification** | `C.6-PLATFORM-SPEC-001` | — | ⏭ Pending |
| 7 | **C.7 Testing and Validation Specification** | `C.7-TEST-SPEC-001` | — | ⏭ Pending |
| 8 | **Stage C → Stage D Handoff** | `STAGE-C-TO-D-HANDOFF-001` | — | ⏭ Pending |

### 4.2 Deliverable Scope Summary

| Deliverable | Question Answered |
|---|---|
| C.1 | What data structures exist, with what schemas, semantics, and validation? |
| C.2 | How is each model specified as a computational contract? |
| C.3 | How is the optimization specified, and under what solver constraints? |
| C.4 | How is financial valuation specified, consuming market and settlement outputs? |
| C.5 | What are the software interfaces, contracts, and boundaries? |
| C.6 | Where and how is the software physically hosted? |
| C.7 | How is the system tested and validated, and what evidence is required? |

### 4.3 Stage B Deferrals — Reconciled

> **Stage B deferrals are reconciled against `STAGE-B-TO-C-HANDOFF-001` v0.2 (Baseline Frozen).**

The Stage B → Stage C Handoff v0.2 declares the **formal reconciled list of 65 deferrals** (D-01 to D-65). The Plan consumes that list directly.

### 4.4 Formal Deferral Mapping

The following mapping is the authoritative allocation of the 65 deferrals to Stage C deliverables.

| Deferrals | Count | Destination |
|---|---|---|
| D-01 to D-11 | 11 | C.1 — Data Specification |
| D-12 to D-16 | 5 | C.2 — Computational Model Specification |
| D-17 to D-24 | 8 | C.3 — Optimization Specification |
| D-25 to D-34 | 10 | C.4 — Financial Specification |
| D-35 to D-42 | 8 | C.5 — Software Specification |
| D-43 to D-52 | 10 | C.6 — Platform Specification |
| D-53 to D-57 | 5 | C.7 — Testing and Validation Specification |
| D-58 to D-65 | 8 | Stage D |
| **Total** | **65** | |

**Note.** The full deferral list (with descriptions, sources, and Stage D flags) is declared in `STAGE-B-TO-C-HANDOFF-001` v0.2 §5.1. This section declares the allocation.

---

## 5. Dependency Chain

### 5.1 Dependencies with Controlled Iteration

| Deliverable | Depends on | Reason |
|---|---|---|
| **C.1** | B.1, B.6 | Data architecture and platform data layout |
| **C.2** | B.2, C.1 | Model architecture and data specification |
| **C.3** | B.3, C.1, C.2 | Optimization architecture, data specification, model specification |
| **C.4** | B.4, C.1, C.2, C.3 | Financial architecture and upstream specifications |
| **C.5** | B.5, C.1–C.4 | Software architecture and upstream specifications |
| **C.6** | B.6, C.1–C.5 | Platform architecture and upstream specifications |
| **C.7** | B.5, C.1–C.6, including their validation requirements, invariants, and acceptance criteria | Testing boundaries and all upstream specifications |
| **Handoff** | C.1–C.7 | Consolidated handoff |

**Rule.** Each deliverable is produced after its required architectural inputs and prerequisite specifications are **sufficiently defined**. Cross-deliverable iteration is **permitted under change control**.

**Rule.** No deliverable is frozen before its dependencies are sufficiently defined.

### 5.2 Verified Parent Citations

Each Stage C deliverable cites its parent Stage B views and its Stage C predecessors. The citations are verified at freeze time.

### 5.3 Production Sequence

```
STAGE B — SYSTEM ARCHITECTURE (HLD)
   │
   │ Baseline Frozen
   │ Handoff v0.2 Baseline Frozen
   │
   ▼
STAGE C — PRODUCT SPECIFICATION
   │
   ├── STAGE-C-PLAN-001 (this document)            ✅ v1.0.2 Baseline
   │
   ├── C.1 Data Specification                      ⏭ Next
   ├── C.2 Computational Model Specification       ⏭ Pending
   ├── C.3 Optimization Specification              ⏭ Pending
   ├── C.4 Financial Specification                 ⏭ Pending
   ├── C.5 Software Specification                  ⏭ Pending
   ├── C.6 Platform Specification                  ⏭ Pending
   ├── C.7 Testing and Validation Specification    ⏭ Pending
   │
   ├── STAGE-C-TO-D-HANDOFF-001                    ⏭ Pending
   │
   └── Stage C Closure                             ⏭ Pending
        │
        ▼
STAGE D — IMPLEMENTATION
```

### 5.4 Milestones

| Milestone | Content | Status |
|---|---|---|
| **M0** | Stage B → C Handoff v0.2 Frozen | ✅ Done |
| **M1** | Stage C Plan v1.0.2 Baseline | ✅ Done |
| **M2** | C.1 Data Specification frozen | ⏭ Next |
| **M3** | C.2 Computational Model Specification frozen | ⏭ Pending |
| **M4** | C.3 Optimization Specification frozen | ⏭ Pending |
| **M5** | C.4 Financial Specification frozen | ⏭ Pending |
| **M6** | C.5 Software Specification frozen | ⏭ Pending |
| **M7** | C.6 Platform Specification frozen | ⏭ Pending |
| **M8** | C.7 Testing & Validation Specification frozen | ⏭ Pending |
| **M9** | Stage C → Stage D Handoff | ⏭ Pending |
| **M10** | Stage C Closure | ⏭ Pending |

---

## 6. Level of Detail Rule

### 6.1 The Rule

> **Stage C shall be sufficiently precise to be implementable and verifiable in Stage D, while remaining distinct from the implementation itself.**

### 6.2 Comparison

| Stage C (Specification) | Stage D (Implementation) |
|---|---|
| Logical class / service identity | Python class bodies |
| Inputs, outputs, state | Internal data structures |
| Preconditions, postconditions, invariants | Algorithm implementation |
| Interface contracts (domain-level) | Handler code |
| **Data and type requirements** | **Language-specific type declarations and implementation** |
| Error behavior | Exception handling code |
| Table schemas with columns and types | DDL execution |
| Objective and constraint formulations | Solver problem assembly |
| Cash-flow structure and equations | Computation code |
| API request/response schemas | API handlers |
| Job / Task topology (contractual) | Job configuration files and deployment |
| Test specifications | Test code |

### 6.3 Examples

| ✅ Stage C | ❌ Stage D (too detailed) |
|---|---|
| "BESS Model is a state-carrying service with state {SOC, SOH, availability}. It produces the feasible operating envelope given the current state and physical parameters." | "class BESSModel: def __init__(self, ...): ..." |
| "Table `validated.meter_data`: columns `timestamp` (timestamp, PK), `site_id` (string, PK), `consumption_kwh` (float, ≥0)" | "CREATE TABLE validated.meter_data (...) USING DELTA PARTITIONED BY (date(timestamp))" |
| "Objective: maximize expected operational value over the horizon, composed of market revenue signals, BTM savings signal, and marginal degradation cost signal." | "prob += lpSum([price[t] * (discharge[t] - charge[t]) - mdc * throughput[t] for t in T])" |
| "Solver: LP class. Must implement the formulations defined in B.3. Solver selection shall not redefine optimization semantics." | "from pulp import LpProblem, LpMaximize; prob = LpProblem(...)" |
| "Job `scenario_batch`: coordinates year loop, dispatch fan-out over (scenario × representative period), and annual update barrier." | "job_config.json with tasks and dependencies" |
| "Unit test: BESS envelope returns power bounds consistent with SOC bounds for all valid SOC values." | "def test_bess_envelope(): assert bess.envelope(0.5) == ..." |

### 6.4 Meaning of "Frozen"

> **A frozen Stage C deliverable is the controlled baseline against which implementation, verification, and change requests are evaluated. Implementation shall conform to the frozen specification unless an approved change request establishes a new baseline.**

A frozen deliverable is not a document that cannot be changed. It is a document that can only be changed through the applicable change-control process.

---

## 7. Review and Freeze Process

### 7.1 Review Process

Each Stage C deliverable goes through:

| Phase | Description |
|---|---|
| **Draft** | Deliverable produced by the consultant |
| **Internal Review** | Cross-check against Stage B views and previous Stage C deliverables |
| **Client Review** | Review by ENGIE (where applicable) |
| **Revision** | Corrections applied based on review feedback |
| **Freeze** | Deliverable baselined |

### 7.2 Freeze Criteria

A Stage C deliverable is **frozen** when:

| # | Criterion |
|---|---|
| 1 | All parent citations are correct |
| 2 | All Stage B deferrals assigned to it are addressed |
| 3 | Cross-references to sibling deliverables are coherent |
| 4 | No Stage D content (no code, no execution) |
| 5 | No Stage B content redecided (frozen Stage B decisions respected) |
| 6 | Internal consistency verified |
| 7 | Traceability to Stage A / Stage B / approved clarifications is complete |
| 8 | Level of detail matches Stage C |
| 9 | **Testing and validation requirements are defined within the deliverable** |
| 10 | **All unresolved assumptions and open items have an explicit disposition, owner, impact assessment, temporary working assumption, and defined resolution path** |

### 7.3 Solver Constraint (applies to C.3)

> **The selected solver shall implement the optimization formulations and logical optimization types defined by B.3 and C.3. Solver selection shall not redefine optimization semantics, objective meaning, constraint ownership, or state-transition semantics.**

Any solver limitation that would require changing the optimization formulation must be escalated as a change request against B.3, not silently accommodated in C.3.

### 7.4 Freeze Sequence

Each deliverable is frozen **individually**. Once frozen, it becomes a stable input for the next deliverables.

The overall Stage C is frozen when all 7 deliverables + Handoff are frozen.

---

## 8. Stage C Closure Criteria

### 8.1 Closure Criteria

| # | Criterion | Verification | Status |
|---|---|---|---|
| 1 | All deliverables C.1–C.7 are present | Section presence | ⏭ Pending |
| 2 | All 65 Stage B deferrals are dispositioned: 57 are addressed through Stage C specifications and 8 are formally deferred to Stage D | Reconciliation table | ⏭ Pending |
| 3 | All frozen Stage B decisions are respected | Cross-check against Handoff v0.2 §4 | ⏭ Pending |
| 4 | All cross-deliverable interfaces are coherent | Interface consistency check | ⏭ Pending |
| 5 | No Stage D content (no code, no execution) | Level of detail check | ⏭ Pending |
| 6 | Traceability to RFP / Stage A / Stage B / approved clarifications is complete | Traceability matrix | ⏭ Pending |
| 7 | All deliverables are frozen | Freeze verification | ⏭ Pending |
| 8 | Stage C → Stage D Handoff produced | Document presence | ⏭ Pending |
| 9 | Stage C formal closure | Closure declaration | ⏭ Pending |
| 10 | **Testing and validation requirements defined within each deliverable and consolidated in C.7** | Cross-check | ⏭ Pending |

### 8.2 Stage C Traceability Chain

> **Every Stage C requirement and specification item shall be traceable to one or more of the following:**
>
> - **an applicable Stage A requirement;**
> - **a frozen Stage B architectural decision;**
> - **an approved clarification; or**
> - **a formally derived engineering requirement.**
>
> **Each derived engineering requirement shall identify its parent requirement or architectural decision and shall define the validation evidence required to demonstrate compliance.**

The traceability chain is:

```
ENGIE RFP
      ↓
Stage A — Requirements / Engineering Definition
      ↓
Stage B — Architecture
      ↓
Approved Clarifications / Derived Engineering Requirements
      ↓
Stage C — Product Specification
      ↓
Stage D — Implementation
      ↓
Verification & Testing
      ↓
UAT Evidence
```

This chain provides the traceability basis for verification and acceptance.

### 8.3 Consistency Checks

| Check | Description | Status |
|---|---|---|
| **Cross-deliverable consistency** | No contradictions between C.1–C.7 | ⏭ Pending |
| **Interface consistency** | All declared interfaces are consistent | ⏭ Pending |
| **Data consistency** | Data schemas are consistent across deliverables | ⏭ Pending |
| **Model consistency** | Model specifications are consistent | ⏭ Pending |
| **Optimization consistency** | Optimization specification is consistent with model | ⏭ Pending |
| **Financial consistency** | Financial specification is consistent with optimization and market/settlement outputs | ⏭ Pending |
| **Software consistency** | Software specification is consistent with all upstream | ⏭ Pending |
| **Platform consistency** | Platform specification is consistent with software | ⏭ Pending |
| **Testing consistency** | Testing specification covers all invariants and acceptance criteria | ⏭ Pending |
| **Traceability** | Every requirement is traceable | ⏭ Pending |
| **Level of detail** | No deliverable crosses into Stage D | ⏭ Pending |
| **Ownership** | Adjacent deliverable ownership rules (§3.4) are respected | ⏭ Pending |

---

## 9. Stage C → Stage D Handoff

### 9.1 What the Handoff Will Produce

The **Stage C → Stage D Handoff** will declare:

- Stage C closure declaration
- Frozen Stage C baseline
- What Stage D receives (the complete specification set)
- What Stage D must produce (implementation)
- What Stage D must not redecide (frozen Stage C decisions)
- What remains open for Stage D
- Stage D entry point (Stage D Plan)
- Stage D closure criteria

### 9.2 What Stage D Receives

Stage D receives the **complete Stage C specification set**:

| Stage C deliverable | Stage D uses it to |
|---|---|
| C.1 | Create tables, ingest data, transform data |
| C.2 | Implement model classes |
| C.3 | Implement optimization |
| C.4 | Implement financial computation |
| C.5 | Implement software structure |
| C.6 | Configure platform |
| C.7 | Implement tests |

### 9.3 What Stage D Does Not Redecide

Stage D shall **not change frozen Stage C specifications unilaterally**. Where implementation constraints require a change, the issue shall be raised through the applicable change-control process before the implementation diverges from the baseline.

Specifically, Stage D shall not unilaterally redefine:

- Class / service identities
- Table schemas
- Interface contracts
- Objective function structure
- Constraint formulations
- Cash-flow structure
- API contracts
- Job / Task topology
- Test specifications

Any change requires a Stage C change request and re-baselining.

---

## 10. Change Control

### 10.1 Change Procedure

- **Adding a deliverable:** must be justified; requires plan version bump
- **Removing a deliverable:** must be justified; requires plan version bump
- **Changing scope of a deliverable:** must be justified; requires plan version bump
- **Changing level of detail:** requires review and plan version bump
- **Changing ownership between adjacent deliverables:** requires review and plan version bump
- **Changing a frozen Stage C deliverable:** requires formal change request and re-baselining
- **Changing a frozen Stage B decision:** requires Stage B change request and re-baselining
- **Cross-deliverable iteration:** permitted under explicit change control

### 10.2 Handling of Unresolved and Open Items

> **A Stage C deliverable shall not be frozen with an unresolved item unless the item has an explicit disposition, owner, impact assessment, temporary working assumption, and defined resolution path.**

Open items include, but are not limited to:

- Unresolved PH items (PH-001 to PH-006)
- Pending client clarifications
- Provisional working assumptions
- Deferred decisions with an assigned future stage

Each open item shall be recorded in a dedicated section of the deliverable, with:

| Field | Content |
|---|---|
| **ID** | Unique identifier |
| **Description** | What is unresolved |
| **Owner** | Who is responsible for resolution |
| **Impact if unresolved** | What would be blocked or degraded |
| **Temporary working assumption** | What is being assumed until resolution |
| **Resolution path** | How and when the item will be resolved |
| **Target resolution** | Date or stage |

### 10.3 Freeze

This plan is **frozen** at v1.0.2 Baseline. Changes require a formal plan version bump.

---

## 11. Risk Register

The following risks are tracked for Stage C.

| # | Risk | Impact | Mitigation |
|---|---|---|---|
| R-01 | Unresolved PH items (PH-001 to PH-006) may require mid-Stage-C revisions | Medium | Proceed with working defaults; apply §10.2 for each open item |
| R-02 | Solver software selection (C.3) may be constrained by licensing or capability | Medium | **Evaluate candidate solvers in C.3 against the required formulations, logical optimization types, numerical requirements, platform compatibility, licensing constraints, and performance requirements.** No solver preference is fixed at Plan level. |
| R-03 | Databricks platform constraints (C.6) may limit certain realizations | Medium | Early platform validation in C.6; **controlled feedback to affected upstream deliverables under §3.2 and §3.4** |
| R-04 | UAT scenarios (C.7) may require data not available | Medium | **Define synthetic or otherwise approved substitute scenarios, subject to ENGIE acceptance.** |
| R-05 | Cross-deliverable interface drift | Medium | Iteration under change control; interface freeze after C.5 |
| R-06 | Stage D time pressure may tempt Stage C shortcuts | High | Enforce level-of-detail rule (§6) |
| R-07 | Overlap between adjacent deliverables (C.2 vs C.5, C.1 vs C.6, C.4 vs market/settlement) | Medium | Enforce the ownership rules declared in §3.4 |

**Note on PH-001 to PH-006.** These blocking items are tracked in `PH1-REG-001` v1.1. Stage C proceeds with the working defaults declared in Stage B; if the items are resolved and require adjustment, the adjustment goes through Stage C change control. Any adjustment that affects a frozen Stage B decision requires a Stage B change request. Each unresolved item must be recorded per §10.2 in the deliverable that owns it.

---

## 12. Sign-Off

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

**Stage:** C — Product Specification

**Document:** `STAGE-C-PLAN-001`

**Version:** 1.0.2 — Baseline (Errata Applied)

**Status:** Baseline

**Next Step:** Begin C.1 — Data Specification

**Language:** English

---

## 13. Specification Language Rule

**Rule.** Throughout Stage C, use **"Stage C specifies"** rather than **"Stage C decides."**

Rationale: **Stage C specifies technical decisions within the constraints established by Stage A, Stage B, and approved clarifications.** The distinction preserves the architectural integrity of the frozen Stage A/B baseline.

```
Stage A
Engineering definition

Stage B
Architectural decisions

Stage C
Detailed specifications and approved technical decisions within the frozen architecture

Stage D
Implementation within the frozen specification
```

---

## 14. Document Conventions

### 14.1 Term — "Product Specification"

The official term for Stage C is **Product Specification**, as defined in §0.2. Where other documents or sections use "system specification" or "Product / System Specification", it is to be read as synonymous with "Product Specification".

### 14.2 Term — "Frozen"

A frozen deliverable is the controlled baseline against which implementation, verification, and change requests are evaluated. See §6.4.

### 14.3 Term — "Open Item"

An unresolved assumption, pending clarification, or deferred decision that has not been resolved at the time of freeze. See §10.2.

### 14.4 Term — "Derived Engineering Requirement"

A technical requirement formally derived during Stage C from a Stage A requirement, a Stage B architectural decision, or an approved clarification. See §8.2.

### 14.5 Term — "Ownership"

The assignment of a specification concern to a single Stage C deliverable. Adjacent ownership rules are declared in §3.4.

### 14.6 Term — "Dispositioned"

A deferral is **dispositioned** when it has an explicit destination: either addressed through a Stage C specification (C.1–C.7) or formally deferred to Stage D. Dispositioned deferrals are tracked through the Stage B → Stage C Handoff v0.2 deferral list. See §8.1.

### 14.7 Git Tags and Document References

Stage C documents reference each other through **document IDs and versions**, not through Git tags. Git tags are repository metadata and are not used as evidence of document state.

---

## 15. Next Steps

**Stage C status:**

| Aspect | Status |
|---|---|
| STAGE-C-PLAN-001 | ✅ Baseline (v1.0.2) |
| Stage B → C Handoff v0.2 Frozen | ✅ Done |
| Plan freeze to v1.0.2 Baseline | ✅ Done |
| C.1 Data Specification | ⏭ Next |
| C.2 Computational Model Specification | ⏭ Pending |
| C.3 Optimization Specification | ⏭ Pending |
| C.4 Financial Specification | ⏭ Pending |
| C.5 Software Specification | ⏭ Pending |
| C.6 Platform Specification | ⏭ Pending |
| C.7 Testing and Validation Specification | ⏭ Pending |
| STAGE-C-TO-D-HANDOFF-001 | ⏭ Pending |
| Stage C Closure | ⏭ Pending |

**Immediate next action.**

Begin **C.1 — Data Specification**.

---

## 16. Change Log

### 16.1 Changes from v0.2 to v1.0

Consolidated Stage C Plan baseline. The v1.0 consolidated the v0.2 correction pass and incorporated the governance, ownership, traceability, freeze, and change-control refinements identified during review.

### 16.2 Changes from v1.0 to v1.0.1 (Errata)

| # | Change | Reason |
|---|--------|--------|
| 1 | §5.3: removed Git tags from the production sequence diagram | Documents reference each other through document IDs and versions |
| 2 | §8.1: criterion 2 — deferrals are now **dispositioned**, not "addressed" | 8 deferrals are dispositioned to Stage D |
| 3 | §3.4: C.7 rule — now permits identifying validation coverage gaps | C.7 must be able to flag gaps without inventing domain requirements |
| 4 | §3.4: added "Job / Task topology vs Job configuration" rule | Make the boundary explicit |
| 5 | §5.4: milestones split per individual freeze | Align with §7.4 |
| 6 | §10: removed duplicated "Meaning of Freeze" subsection | Freeze meaning is §6.4 |
| 7 | §13: "Stage D — Implementation decisions within the frozen specification" → "Implementation within the frozen specification" | Stronger wording |
| 8 | §14.6: added definition of "Dispositioned" | Traceable terminology |
| 9 | §14.7: added rule — documents reference each other through IDs and versions | Prevent configuration drift |
| 10 | §16.1: simplified v0.2 → v1.0 narrative | Avoid double-counting |

### 16.3 Changes from v1.0.1 to v1.0.2 (Errata)

| # | Change | Reason |
|---|--------|--------|
| 1 | Removed all postscript content after the "End of" marker | The "End of" marker must be the literal end of the document; a controlled baseline cannot contain editorial memos addressed to the reader |
| 2 | §13: "Stage C does not decide arbitrarily. It specifies within the constraints..." → **"Stage C specifies technical decisions within the constraints established by Stage A, Stage B, and approved clarifications."** | Avoid defensive/conversational phrasing; state the rule directly |
| 3 | §11 R-04: "Fallback to synthetic scenarios" → **"Define synthetic or otherwise approved substitute scenarios, subject to ENGIE acceptance."** | Synthetic scenarios must not be treated as automatic equivalents to real data |
| 4 | §2.1 C.1: "ingestion mechanism" → **"ingestion requirements and logical ingestion behavior"** | C.1 specifies *what* ingestion must do; C.6 specifies *how* it is realized on Databricks |
| 5 | §2.1 C.3: "solver configuration" → **"solver configuration requirements"** | C.3 specifies requirements; Stage D implements the concrete configuration |
| 6 | §11 R-03: "controlled feedback to C.2/C.3/C.5" → **"controlled feedback to affected upstream deliverables under §3.2 and §3.4"** | Platform constraints may also affect C.1 (schemas, partitioning, retention, lineage) |
| 7 | §8.2: "This chain is the backbone of the acceptance argument to ENGIE" → **"This chain provides the traceability basis for verification and acceptance."** | More neutral and technical |
| 8 | §16.3: added this changelog entry | Traceability |

**Nature of the change.** The v1.0.2 is an **errata patch** over the v1.0.1. No structural change. The changes address the 5 review points (postscript removal, §13 wording, R-04 synthetic data governance, C.1 ingestion wording, C.3 solver configuration wording) plus 3 traceability refinements (R-03 scope, §8.2 wording, §16.3 changelog entry).

### 16.4 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage C start | Initial Stage C Plan produced | Superseded |
| 0.2 | Stage C review | 19 corrections | Superseded |
| 0.3 (candidate) | Stage C review pass 2 | 11 editorial corrections | Superseded |
| 1.0 | Stage C freeze | Full baseline consolidation | Superseded |
| 1.0.1 | Stage C errata | 10 errata corrections | Superseded |
| 1.0.2 | Stage C errata | 8 errata corrections (postscript removal, §13 wording, R-04 governance, C.1/C.3 wording, R-03 scope, §8.2 wording) | **Baseline** |

---

**End of STAGE-C-PLAN-001 — Stage C Product Specification Plan (v1.0.2 — Baseline, Errata Applied)**
