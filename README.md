# README.md

**BESS Operational & Financial Modeling**

**ENGIE — RFP-264144-1 · 12-Week Engagement**

An analytical platform for evaluating the operational and financial performance of Battery Energy Storage System (BESS) projects across multiple value streams, market scenarios, and contract conditions.

---

## What this repository contains

This repository holds the complete engineering baseline and concept prototype for the BESS Operational & Financial Modeling engagement.

| Component | Description | Location |
|---|---|---|
| **System Strategy** | Four-stage delivery framework, seven domains, System Context | `systems_strategy.md` |
| **Stage A — Engineering Definition** | Conceptual engineering per domain, Phase 1 clarification register | `docs/Stage-A-engineering-definition/` |
| **Stage B — System Architecture (HLD)** | Integrated architecture, data, model, optimization, financial, software, platform | `docs/Stage-B-system-architecture/` |
| **Stage C — Product Specification Plan** | Master plan for the detailed specification stage | `docs/Stage-C-product-specification/` |
| **Concept Prototype** | Interactive web application demonstrating the causal chain end-to-end | `docs/mockup/` |
| **Proposal** | Submission proposal to ENGIE (RFP-264144-1) | `Proposal-Engie-Bess.md` |

---

## Concept Prototype

The concept prototype is a **standalone web application** that demonstrates the causal chain of the BESS model end-to-end.

**Live at:**

> https://danaciods.github.io/EngieBess/mockup/

**What it demonstrates:**

- Scenario configuration and live recalculation
- Data ingestion and validation
- Market value streams (peak shaving, TOU arbitrage, 5CP capacity, RegD)
- Dispatch optimization with a priority heuristic
- Degradation feedback loop and augmentation events
- Tariff engine as the single source of truth for bill savings
- PJM settlement adapter as a separate step from financial valuation
- Financial valuation (NPV, IRR, equity IRR, payback)
- Traceability from RFP to results, including working assumptions

**What it does not demonstrate:**

- LP co-optimization (the delivered engine uses LP, per PH-034)
- 15-minute time resolution (the prototype uses hourly, per PH-054)
- Market-specific adapter depth (the prototype uses PJM as illustrative)
- Production-scale execution (the prototype runs in the browser)

**Reference market:** PJM / BGE zone, behind-the-meter configuration, with synthetic data.

**How to access:** Open the URL in any modern browser. No installation, no credentials, no data upload required.

---

## Engineering Baseline

The engagement follows a **four-stage engineering progression**:

```
Stage A — Engineering Definition
        ↓
Stage B — System Architecture (HLD)
        ↓
Stage C — Product Specification
        ↓
Stage D — Implementation
```

| Stage | Name | Purpose | Status |
|---|---|---|---|
| **A** | Engineering Definition | Define what the system must contain and what the engineering responsibilities are | ✅ CLOSED |
| **B** | System Architecture (HLD) | Define how those responsibilities are structurally organized into an executable system | ✅ CLOSED |
| **C** | Product Specification | Specify what exactly must be built, at a level precise enough to be implementable and verifiable | 🔄 ACTIVE |
| **D** | Implementation | Implement, test, validate, and deploy against baselined Stage C specifications | ⏭ PENDING |

### The Seven Engineering Domains

| # | Domain | Primary Question |
|---|---|---|
| 1 | BESS Engineering | What physical system are we modeling? |
| 2 | Load & Market Engineering | What external signals, tariffs, market mechanisms and constraints affect the system? |
| 3 | Operational Engineering | How do those conditions translate into feasible use cases? |
| 4 | Dispatch & Optimization | How are physical, operational and economic objectives coordinated? |
| 5 | Degradation Engineering | How does operation change future BESS capability? |
| 6 | Financial Engineering | What economic value results from the modeled system? |
| 7 | Data & Application Engineering | How is the integrated model executed and consumed? |

---

## Market Engineering Model

A parallel documentation chain for the market engineering discipline:

| # | Document | Version | Document ID |
|---|---|---|---|
| 1 | Parte 1 — Market Domain and Conventions | v1.3 | ME-P1-001 |
| 2 | Parte 2 — Transversal Market Values | v1.0 | ME-P2-001 |
| 3 | Parte 3 — Market Products and Participation | v1.3 | ME-P3-001 |
| 4 | Parte 4 — Market Rules, Signals, Commitments and Constraints | v1.4 | ME-P4-001 |
| 5 | Parte 5 — Delivery, Performance and Settlement | v1.2 | ME-P5-001 |

**Governing document:** Introduction Document v1.2 (v1.3 pending for Network Engineering).

**Blocking decision:** P1-O01 to P1-O03 (jurisdiction, operator, wholesale/BTM).

**Pending items:**

- P1-O14 — site / interconnection capability
- Introduction v1.3 — Network Engineering
- P4-O17 — award simulation rule
- P5-O17 — null-path linkage confirmation
- P5-O18 — settlement statement ownership

---

## Author

**Daniel Ignacio Canedo Donoso**
MSc | AI Engineer

- ML Engineer — Anyone AI
- MSc. Economics — Yokohama National University
- Economist — Universidad Católica Boliviana

Role in this engagement: design, development, and delivery of the BESS Operational & Financial Modeling Platform (RFP-264144-1, 12-week engagement).

---

## Delivered by

**Blue Trail Software · BessEngie**

Concept prototype for ENGIE

---

## Copyright and License

© 2026 Daniel Ignacio Canedo Donoso. All rights reserved.

This repository and its contents — including the System Strategy, the engineering baseline (Stages A, B, C), the concept prototype, the proposal, and all associated documentation — are the intellectual property of the author and are provided for the ENGIE BESS Operational & Financial Modeling engagement (RFP-264144-1).

No part of this repository may be reproduced, distributed, or transmitted in any form or by any means without the prior written permission of the author, except as required for the evaluation of the proposal by ENGIE and its authorized representatives.

The concept prototype uses **synthetic data and illustrative market prices**. It does not contain ENGIE confidential information and does not represent a production system.

---

## Reference

**Engagement:** RFP-264144-1
**Client:** ENGIE
**Duration:** 12 weeks
**Language:** English

---

*Blue Trail Software · BessEngie · © 2026 | MSc. Daniel Canedo*

*Architecture: BESS · Load & Market · Operational · Dispatch · Degradation · Financial · Data & Application*
