# STAGE-B-HLD-INDEX-001 — Stage B HLD Master Index and Scope Definition

**Document ID:** STAGE-B-HLD-INDEX-001

**Version:** 0.2 — Baseline (Frozen)

**Status:** Stage B — Baseline (Frozen)

**Project:** ENGIE — BESS Operational & Financial Modeling

**Engagement:** RFP-264144-1

**Language:** English

**Parent Documents:**
- `SYS-STR-FRM-001` — System Strategy & Delivery Framework (v0.9)
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition (v0.6)
- `A.2.1-BESS-ENG-001` — BESS Engineering (v1.3)
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering (v1.3)
- `A.2.3-OPS-ENG-001` — Operational Engineering (v1.4)
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering (v1.0)
- `A.2.5-DEG-ENG-001` — Degradation Engineering (v0.4)
- `A.2.6-FIN-ENG-001` — Financial Engineering (v0.3)
- `A.2.7-DATA-APP-ENG-001` — Data & Application Engineering (v0.3)
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register (v1.1)
- `STAGE-A-CONSOL-REPORT-001` — Stage A Consolidation Report (v1.1)

**Purpose:** Establish the master index, scope, and production status for `STAGE-B-HLD-001` (System Architecture — High-Level Design), declaring the architectural views produced, their frozen versions, the dependency chain between them, and the closure status of Stage B.

**Change log.** See §11.

---

## 0. Document Control

### 0.1 Document Identity

| Aspect | Value |
|---|---|
| **Document ID** | `STAGE-B-HLD-INDEX-001` |
| **Version** | 0.2 — Baseline (Frozen) |
| **Status** | Stage B — Baseline (Frozen) |
| **Project** | ENGIE — BESS Operational & Financial Modeling |
| **Engagement** | RFP-264144-1 |
| **Language** | English |

### 0.2 Purpose

This document establishes:

- The **master index** of `STAGE-B-HLD-001`
- The **scope** of each architectural view
- The **frozen versions** of B.0–B.6
- The **dependency chain** between views
- The **level-of-detail rule** distinguishing Stage B from Stage C
- The **closure criteria** for Stage B
- The **closure status** of Stage B

It is a **contract document** between the consultant and ENGIE: it declares what Stage B has produced and under what rules.

### 0.3 Scope

**In scope:**
- Master index of `STAGE-B-HLD-001`
- Scope definition per view
- Frozen versions of B.0–B.6
- Dependency chain
- Level-of-detail classification (Stage B / Stage C / Stage D)
- Closure criteria and status
- Change control

**Out of scope:**
- The actual content of each view (produced in B.0–B.6)
- Any Stage A content (already closed)
- Any Stage C or Stage D content

---

## 1. Purpose of This Index

### 1.1 Why an Index Document

Before producing `STAGE-B-HLD-001`, the **structure and scope** must be frozen. Producing the HLD without a frozen index risks:

- **Scope creep** — B.0 becoming B.1–B.6 by accident
- **Duplication** — the same decision appearing in multiple views
- **Premature specification** — HLD becoming Stage C
- **Inconsistency** — different views contradicting each other

The index document **constrains** the HLD before production and **certifies** it after production.

### 1.2 How This Document Is Used

| Phase | Use |
|---|---|
| **Before HLD production** | Freeze the structure and scope |
| **During HLD production** | Reference for section scope and level of detail |
| **After HLD production** | Checklist for HLD review and closure |
| **Stage C start** | Confirm handoff criteria |

### 1.3 Relationship to Stage A

Stage A answered:

> **What must the system contain, and what are the engineering responsibilities?**

Stage B answers:

> **How are those responsibilities structurally organized into an executable system?**

This index declares **how** Stage B has answered that question.

---

## 2. Stage B Scope

### 2.1 What Stage B Produces

| Product | Description | Status |
|---|---|---|
| **B.0 Integrated System Architecture** | The architectural contract: components, flows, state, feedback, boundaries, interfaces | ✅ Frozen |
| **B.1 Data Architecture** | Logical data categories, ownership, contracts, quality, lineage, isolation | ✅ Frozen |
| **B.2 Model Architecture** | Computational objects, state, temporal behavior, interfaces, lifecycle, parallelization | ✅ Frozen |
| **B.3 Optimization Architecture** | Dispatch engine, objective structure, constraints, revenue stacking, solver boundary | ✅ Frozen |
| **B.4 Financial Architecture** | Cash-flow engine, revenue attribution, realization factor, KPIs, scenario economics | ✅ Frozen |
| **B.5 Software Architecture** | Software units, service boundaries, API boundaries, execution interfaces | ✅ Frozen |
| **B.6 Databricks Architecture** | Workspace, app layer, compute, data layer, orchestration, storage, governance | ✅ Frozen |
| **Stage B → Stage C Handoff** | Formal handoff | ⏭ Pending |
| **Stage B Closure** | Formal closure of Stage B | ⏭ Pending |

### 2.2 What Stage B Does Not Produce

| Not in Stage B | Belongs to |
|---|---|
| Class structures, methods, signatures | Stage C |
| Physical data schemas, table definitions | Stage C |
| API schemas, request/response formats | Stage C |
| Optimization equations, exact formulations | Stage C |
| Cash-flow equations, tax treatment | Stage C |
| Solver configuration, tuning parameters | Stage C |
| Cluster configuration, runtime versions | Stage C |
| CI/CD pipelines, deployment scripts | Stage D |
| Code (Python, PySpark, SQL) | Stage D |

### 2.3 Relationship to Stage C

Stage B **constrains** Stage C. Stage C **details** Stage B.

```
Stage B: "There is a component called BESS Model with state SOC, SOH."
Stage C: "The BESS Model class has attributes ... and methods ..."
```

Stage B does **not** decide the class name or method signatures. It decides **that there is a BESS Model component with state**.

---

## 3. Architectural Views Overview

### 3.1 Structure

```
STAGE B — SYSTEM ARCHITECTURE (HLD)
│
├── B.0 Integrated System Architecture      ← architectural contract
│   ├── Logical Architecture
│   ├── Functional Components (7)
│   ├── Cross-Cutting Capabilities (6)
│   ├── Component Interfaces
│   ├── State and Feedback Architecture
│   ├── System Context Propagation
│   └── Architectural Sequence
│
├── B.1 Data Architecture                   ← data view
│   ├── Data Architectural Categories (3)
│   ├── Data Lifecycle
│   ├── Execution Data
│   ├── Governance Data
│   ├── Data Ownership
│   ├── Data Flows
│   ├── Data Interfaces
│   └── Data Quality, Lineage, Scenario Isolation
│
├── B.2 Model Architecture                  ← computational view
│   ├── Computational Objects (7)
│   ├── State Model
│   ├── Temporal Behavior
│   ├── Inter-Model Interfaces
│   ├── Lifecycle
│   └── Parallelization Boundaries
│
├── B.3 Optimization Architecture           ← optimization view
│   ├── Objective Structure
│   ├── Constraint Families
│   ├── Revenue Stacking
│   ├── Service Coordination
│   ├── Horizon Framework
│   ├── State Transitions
│   ├── Degradation Signal Integration
│   ├── Solver Boundary
│   └── Feasibility Handling
│
├── B.4 Financial Architecture              ← financial view
│   ├── Financial Inputs
│   ├── Value Categories
│   ├── Cost Categories
│   ├── Cash-Flow Architecture
│   ├── Financial KPIs
│   ├── Financing
│   ├── Perspective
│   └── Double-Counting Prevention
│
├── B.5 Software Architecture               ← software view
│   ├── Package Architecture
│   ├── Service Boundaries
│   ├── API / Interface Boundaries
│   ├── Execution Interfaces
│   ├── Configuration Interfaces
│   ├── Application Boundary
│   ├── Technology Placement
│   └── Testing Boundaries
│
├── B.6 Databricks Architecture             ← platform view
│   ├── Workspace, Environment, Compute
│   ├── Data Layout
│   ├── Delta Table Design
│   ├── Execution Placement
│   ├── Parallelization & Synchronization
│   ├── Application Boundary Realization
│   ├── Governance, Identity, Secrets
│   ├── Observability & Lineage
│   └── Scheduling & Orchestration
│
├── STAGE-B-TO-C-HANDOFF-001                ← formal handoff
│
└── Stage B Closure
```

### 3.2 Why B.0 First

B.0 is the **architectural contract**. It defines:

- What components exist
- How they relate
- How data flows
- How execution flows
- How state evolves
- How domains map to components

**B.1–B.6 are views** of the architecture defined in B.0. Without B.0, B.1–B.6 would be orphan views.

### 3.3 Relationship Between B.0 and B.1–B.6

| B.0 (Integrated) | B.1–B.6 (Views) |
|---|---|
| Component **exists** | Component **detailed** |
| Interfaces **declared** | Interfaces **specified** |
| Data flow **shown** | Data flow **expanded** |
| State model **declared** | State model **detailed** |
| Boundaries **defined** | Boundaries **detailed** |

### 3.4 ADRs — Transversal, Not a "View #7"

**ADRs are not an architecture.** They are the **mechanism** by which decisions across B.0–B.6 are recorded.

- **Within each view:** decisions are identified
- **In the consolidated ADR Log:** decisions are recorded formally

This avoids the impression that ADR is a parallel "Architecture #7".

---

## 4. Master Index — Frozen Views

### 4.1 Frozen Versions

| Order | View | Document ID | Version | Status |
|---|---|---|---|---|
| 1 | **B.0 Integrated System Architecture** | `B.0-INTEGRATED-SYS-ARCH-001` | **v0.3.3** | ✅ Baseline (Frozen) |
| 2 | **B.1 Data Architecture** | `B.1-DATA-ARCH-001` | **v0.3** | ✅ Baseline (Frozen) |
| 3 | **B.2 Model Architecture** | `B.2-MODEL-ARCH-001` | **v0.5.1** | ✅ Baseline (Frozen) |
| 4 | **B.3 Optimization Architecture** | `B.3-OPT-ARCH-001` | **v0.6.1** | ✅ Baseline (Frozen) |
| 5 | **B.4 Financial Architecture** | `B.4-FIN-ARCH-001` | **v0.4** | ✅ Baseline (Frozen) |
| 6 | **B.5 Software Architecture** | `B.5-SW-ARCH-001` | **v0.4** | ✅ Baseline (Frozen) |
| 7 | **B.6 Databricks Architecture** | `B.6-DBX-ARCH-001` | **v0.4** | ✅ Baseline (Frozen) |
| 8 | **Stage B → Stage C Handoff** | `STAGE-B-TO-C-HANDOFF-001` | v0.1 | ⏭ Pending |

### 4.2 View Scope Summary

Each view is scoped at **Stage B level of detail** (see §6). The detailed change logs and non-scope sections are in each view.

| View | Question Answered |
|---|---|
| B.0 | What system are we building? |
| B.1 | How is information organized? |
| B.2 | How is the model structured? |
| B.3 | How is optimization structured? |
| B.4 | How is financial valuation structured? |
| B.5 | How is the software organized? |
| B.6 | How is it realized on Databricks? |

### 4.3 Deferrals to Stage C

Each view declares its own deferrals. The consolidated list is in the **Stage B → Stage C Handoff** (`STAGE-B-TO-C-HANDOFF-001`). The deferrals fall into six categories:

| Category | Source Views |
|---|---|
| **Physical data specification** | B.1, B.6 |
| **Physical model specification** | B.2, B.3 |
| **Physical financial specification** | B.4 |
| **Physical software specification** | B.5 |
| **Physical platform specification** | B.6 |
| **Testing and validation specification** | B.5 |

---

## 5. Dependency Chain

### 5.1 Dependencies

| View | Depends on | Reason |
|---|---|---|
| **B.0** | Stage A | Contract from Stage A |
| **B.1** | B.0 | Data flows and ownership defined in B.0 |
| **B.2** | B.0, B.1 | Components and data structures from B.0, B.1 |
| **B.3** | B.0, B.2 | Dispatch engine and model interfaces |
| **B.4** | B.0, B.2, B.3 | Cash-flow engine and operational outputs |
| **B.5** | B.0–B.4 | Software units based on all views |
| **B.6** | B.0–B.5 | Platform based on all views |
| **Handoff** | B.0–B.6 | Consolidated handoff |

**Rule:** No view cites a Candidate parent. Every parent is Frozen.

### 5.2 Verified Parent Citations

| View | Cites B.0 | Cites B.1 | Cites B.2 | Cites B.3 | Cites B.4 | Cites B.5 |
|---|---|---|---|---|---|---|
| B.1 | v0.3.3 ✅ | — | — | — | — | — |
| B.2 | v0.3.3 ✅ | v0.3 ✅ | — | — | — | — |
| B.3 | v0.3.3 ✅ | v0.3 ✅ | v0.5.1 ✅ | — | — | — |
| B.4 | v0.3.3 ✅ | v0.3 ✅ | v0.5.1 ✅ | v0.6 ✅ | — | — |
| B.5 | v0.3.3 ✅ | v0.3 ✅ | v0.5.1 ✅ | v0.6 ✅ | v0.4 ✅ | — |
| B.6 | v0.3.3 ✅ | v0.3 ✅ | v0.5.1 ✅ | v0.6 ✅ | v0.4 ✅ | v0.4 ✅ |

**Result:** ✅ All parent citations are correct. No view cites a Candidate parent.

### 5.3 Production Sequence

```
STAGE A — ENGINEERING DEFINITION
   │
   │ ✅ CLOSED (tag: stage-a-closed)
   │
   ▼
STAGE B — SYSTEM ARCHITECTURE (HLD)
   │
   ├── B.0 Integrated System Architecture          ✅ v0.3.3 Frozen
   ├── B.1 Data Architecture                       ✅ v0.3 Frozen
   ├── B.2 Model Architecture                      ✅ v0.5.1 Frozen
   ├── B.3 Optimization Architecture               ✅ v0.6.1 Frozen
   ├── B.4 Financial Architecture                  ✅ v0.4 Frozen
   ├── B.5 Software Architecture                   ✅ v0.4 Frozen
   ├── B.6 Databricks Architecture                 ✅ v0.4 Frozen
   │
   ├── STAGE-B-HLD-INDEX-001 (this document)       ✅ v0.2 Frozen
   │
   ├── STAGE-B-TO-C-HANDOFF-001                    ⏭ Next
   │
   └── Stage B Closure                             ⏭ Pending
        │
        ▼
STAGE C — PRODUCT SPECIFICATION
```

### 5.4 Milestones

| Milestone | Content | Status |
|---|---|---|
| **M1** | B.0 complete | ✅ |
| **M2** | B.1 + B.2 complete | ✅ |
| **M3** | B.3 + B.4 complete | ✅ |
| **M4** | B.5 + B.6 complete | ✅ |
| **M5** | Index v0.2 complete | ✅ |
| **M6** | Stage B → Stage C Handoff | ⏭ Next |
| **M7** | Stage B Closure | ⏭ Pending |

---

## 6. Level of Detail Rule

### 6.1 The Rule

> **HLD must be sufficiently concrete to constrain Stage C, but insufficiently detailed to become Stage C.**

### 6.2 Comparison

| Stage B (HLD) | Stage C (Specification) |
|---|---|
| Components | Classes |
| Logical interfaces | API schemas |
| Logical data structures | Physical schemas |
| Data flows | Pipeline implementation |
| State model | Exact state implementation |
| Architecture decisions | Detailed algorithms |
| Solver strategy | Solver formulation |
| Execution architecture | Exact orchestration code |
| Technology selection | Configuration details |

### 6.3 Examples

| ✅ Stage B | ❌ Stage C (too detailed) |
|---|---|
| "There is a BESS Model component" | "The BESSModel class has methods X, Y, Z" |
| "Data is organized in layers: raw, validated, model-ready" | "The Delta table `bess_state_raw` has columns ..." |
| "Dispatch is formulated as LP" | "The LP has variables x[i,t], constraints ..." |
| "Cash flow includes CAPEX, OPEX, revenue, degradation events" | "Cash flow equation: NPV = Σ ..." |
| "State is persisted between iterations" | "State is stored in `state.parquet` with schema ..." |

---

## 7. Stage B Closure Criteria

### 7.1 Closure Criteria

| # | Criterion | Verification | Status |
|---|---|---|---|
| 1 | All views B.0–B.6 are present | Section presence | ✅ |
| 2 | All domains of Stage A are mapped to components | Domain-to-Component Mapping in B.0 | ✅ |
| 3 | All Stage A interfaces are declared | Component Interfaces in B.0, expanded in B.1–B.5 | ✅ |
| 4 | Data flow is complete and consistent | B.0 System Data Flow + B.1 Data Flows | ✅ |
| 5 | Execution flow is complete and consistent | B.0 System Execution Flow + B.2 Temporal Behavior + B.3 State Transitions | ✅ |
| 6 | State and feedback are correctly modeled | B.0 State Architecture + B.2 State Model + B.3 State Transitions | ✅ |
| 7 | All architectural decisions are recorded | ADRs across B.0–B.6 | ✅ |
| 8 | No premature specification (no Stage C content) | Level of detail check | ✅ |
| 9 | No missing content (no Stage B gaps) | Section completeness | ✅ |
| 10 | Traceability to Stage A is complete | Traceability across B.0–B.6 | ✅ |
| 11 | All parents are Frozen (no Candidate citations) | Parent citation verification (§5.2) | ✅ |
| 12 | All cross-view interfaces are coherent | Interface consistency check | ✅ |
| 13 | Stage B → Stage C Handoff produced | Document presence | ⏭ Pending |
| 14 | Stage B formal closure | Closure declaration | ⏭ Pending |

### 7.2 Consistency Checks

| Check | Description | Status |
|---|---|---|
| **Cross-view consistency** | No contradictions between B.0–B.6 | ✅ |
| **Interface consistency** | All declared interfaces are consistent | ✅ |
| **State consistency** | State model is consistent across views | ✅ |
| **Data flow consistency** | Data flows match interfaces | ✅ |
| **ADR consistency** | ADRs do not contradict each other | ✅ |
| **Traceability** | Every Stage A interface is addressed | ✅ |
| **Version consistency** | No view cites a Candidate parent | ✅ |
| **Ownership consistency** | Domain 2 owns External Context; annual sequencing tripartite (B.3 semantics, B.5 orchestration, B.6 realization) | ✅ |
| **Settlement chain** | Dispatch → Load & Market (settlement_adapter) → Financial | ✅ |
| **Double-counting prevention** | B.3 §10.4 and B.4 §11 consistent | ✅ |

---

## 8. Stage B Closure Status

### 8.1 Current Status

| Aspect | Status |
|---|---|
| **All 7 architectural views (B.0–B.6)** | ✅ Baseline (Frozen) |
| **Master Index (this document)** | ✅ Baseline (Frozen) |
| **Stage B → Stage C Handoff** | ⏭ Pending |
| **Stage B Closure Declaration** | ⏭ Pending |

### 8.2 What Remains

The remaining items are **administrative closure**, not architectural work:

| Item | Nature |
|---|---|
| Produce `STAGE-B-TO-C-HANDOFF-001` v0.1 | Consolidation of Stage B outputs |
| Declare Stage B closed | Formal declaration |

### 8.3 Frozen Baseline

All Stage B views are **frozen** at their current versions:

| Document | Frozen Version |
|---|---|
| `B.0-INTEGRATED-SYS-ARCH-001` | v0.3.3 |
| `B.1-DATA-ARCH-001` | v0.3 |
| `B.2-MODEL-ARCH-001` | v0.5.1 |
| `B.3-OPT-ARCH-001` | v0.6.1 |
| `B.4-FIN-ARCH-001` | v0.4 |
| `B.5-SW-ARCH-001` | v0.4 |
| `B.6-DBX-ARCH-001` | v0.4 |
| `STAGE-B-HLD-INDEX-001` | v0.2 |

Any subsequent change to a frozen view requires an explicit change request and re-baselining.

---

## 9. Change Control

### 9.1 Change Procedure

- **Adding a view:** must be justified; requires index version bump
- **Removing a view:** must be justified; requires index version bump
- **Changing scope of a view:** must be justified; requires index version bump
- **Changing level of detail:** requires review and index version bump
- **Changing a frozen view:** requires formal change request and re-baselining

### 9.2 Freeze

This index is **frozen** for the duration of Stage B. Changes require a formal index version bump.

---

## 10. Sign-Off

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

**Stage:** B — System Architecture (HLD)

**Document:** `STAGE-B-HLD-INDEX-001`

**Version:** 0.2 — Baseline (Frozen)

**Status:** Baseline (Frozen)

**Next Step:** Produce `STAGE-B-TO-C-HANDOFF-001` v0.1

**Language:** English

---

## 11. Change Log

### 11.1 Changes from v0.1 to v0.2

| # | Change | Reason |
|---|---|---|
| 1 | Header: version promoted from v0.1 Draft for Review to **v0.2 Baseline (Frozen)** | Content accepted; Stage B closure preparation |
| 2 | §2.1: added **Status** column to the product table; all B.0–B.6 marked ✅ Frozen | Reflect the frozen tree |
| 3 | §3.1: restructured the architectural views diagram to show each view's sub-sections | Improve readability; remove duplication present in v0.1 |
| 4 | §4: **new Master Index — Frozen Views** section, replacing the duplicated draft index of v0.1 | v0.1 had the index repeated in §3.1 and §4; consolidated here |
| 5 | §4.1: added the frozen version table with all 7 views + Handoff | Single source of truth for versions |
| 6 | §4.2: added view scope summary (question answered per view) | Quick reference |
| 7 | §4.3: added deferral categories summary (consolidated handoff refers here) | Avoid duplicating deferrals in the index |
| 8 | §5: **new Dependency Chain** section with dependency table, verified parent citations matrix, production sequence, and milestones | v0.1 mentioned production sequence but did not verify parent citations |
| 9 | §5.2: added **Verified Parent Citations** matrix | Certify the frozen dependency chain |
| 10 | §5.4: added **Milestones** table with status | Track Stage B closure progress |
| 11 | §6: retained Level of Detail Rule; simplified references | No content change |
| 12 | §7: **expanded Stage B Closure Criteria** from 10 to 14 criteria, adding parent-citation, cross-view-interface, handoff, and closure criteria | Complete the closure checklist |
| 13 | §7.2: added **Consistency Checks** table (cross-view, interface, state, data flow, ADR, traceability, version, ownership, settlement chain, double-counting prevention) | Certify the consistency of the frozen tree |
| 14 | §8: **new Stage B Closure Status** section, declaring what remains | Make the closure state explicit |
| 15 | §8.3: added **Frozen Baseline** table | Single source of truth for frozen versions |
| 16 | §9: retained Change Control; refined to cover frozen-view changes | Consistency with the frozen baseline |
| 17 | §10: updated Sign-Off — version, status, next step | Reflect the frozen state |
| 18 | §11: added this change log | Traceability |

### 11.2 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage B start | Initial index created (Draft for Review) | Superseded |
| 0.2 | Stage B closure | Full rewrite: frozen versions declared, dependency chain verified, closure criteria expanded, closure status added, duplicate content removed | **Baseline (Frozen)** |

---

**End of STAGE-B-HLD-INDEX-001 — Stage B HLD Master Index and Scope Definition (v0.2 — Baseline Frozen)**

**Status:** Baseline (Frozen)

**Next:** `STAGE-B-TO-C-HANDOFF-001` v0.1

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1
