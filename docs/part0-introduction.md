# BESS Engineering Model — Introduction Document

## Purpose of this document

This document defines the **BESS engineering model** that will serve as the technical specification baseline for the subsequent development of the operational and financial simulation software requested by ENGIE. Its goal is not to write code or to model finances, but to **technically represent the physical and operational system** of a Battery Energy Storage System with sufficient rigor that:

- The asset's behavior can be simulated under multiple operating strategies.
- Results are traceable, verifiable, and comparable against benchmarks.
- The later software (Python, Databricks, PySpark, SQL) implements **a model that is already defined**, not one invented during coding.
- The financial layer (NPV, IRR, payback) is built on a correct physical foundation, not on assumptions.

The scope of this document is **strictly engineering**: asset physics, degradation, operating modes, dispatch, and technical outputs. The financial layer and the software layer are addressed in separate documents.

---

## Organization principle: dependency layers

The model is organized into **five parts**, defined by **dependency layers**. Each part only uses elements defined in earlier parts. This allows:

- Developing and validating each part relatively independently.
- Modifying one part without breaking the ones above it.
- Maintaining a single source of truth for symbols, conventions, and units.
- Separating what changes slowly (physics, conventions) from what changes quickly (strategy, dispatch).

The structure is as follows:

| Part | Content | Sections of the original draft |
|---|---|---|
| **1. Fundamentals and conventions** | System definition, AC/DC nodes, master table of symbols and units, sign convention, state vector, temporal resolutions, scenarios, interfaces between parts, traceability matrix | 0, 1, 5, 19, 20 |
| **2. Physical asset model** | Battery, PCS/inverter, grid and site, load model, energy balance, derating, thermal model, hard constraints | 2, 3, 4, 6, 7, 8 |
| **3. Degradation and useful life** | Calendar aging, cycle aging, SOH (capacity, power, efficiency), augmentation/replacement thresholds, calibration, marginal degradation cost | 15, 16, 17 |
| **4. Services (operating modes)** | Peak shaving, demand response, energy arbitrage, frequency regulation, voltage regulation — each with the same template (objective, inputs, constraints, asset reservation, outputs/KPIs, risks) | 9–13 |
| **5. Dispatch, stacking, and outputs** | Coexistence rules between services, rule-based dispatch, MILP/MISOCP, hybrid approach, rolling horizon, engineering outputs | 14, 18, 21 |

---

## Structural rules of the document

For the layer separation to work, five rules apply:

1. **Part 1 is the only authorized source of symbols.** No other part introduces a new symbol without first registering it in the master table. This eliminates collisions and notation drift.

2. **Every service in Part 4 uses the same template.** Objective, inputs, constraints, what it reserves from the asset (power and energy), outputs/KPIs, and risks. This allows comparing modes and detecting overlaps.

3. **Every part declares its interface** in half a page: what it consumes and what it produces. For example, Part 3 delivers only $SOH_t\) (capacity, power, efficiency) and \(c_{deg}$, and Part 5 consumes them as parameters. This makes it possible to change the degradation model without touching dispatch.

4. **Every part carries its own changelog.** Equations are numbered by part (e.g., 2.6) to avoid ambiguous cross-references.

5. **A RFP–Model traceability matrix exists** linking each ENGIE RFP requirement to the model section that covers it. This resolves the problem of unverifiable citations and allows auditing coverage.

---

## Recommended writing order

The order is not arbitrary: it follows dependencies.

1. **Part 1 — Fundamentals and conventions.** Frozen first. It is the foundation of everything.
2. **Part 2 — Physical asset model.** Corrects the energy balance, the site balance, and derating.
3. **Part 4 — Services (operating modes).** The four modes still missing, with a uniform template.
4. **Part 5 — Dispatch, stacking, and outputs.** Consumes everything above.
5. **Part 3 — Degradation and useful life.** Can proceed in parallel because its interface with the other parts is narrow: it only delivers $SOH\) and \(c_{deg}$.

If Part 4 becomes too extensive, it can be split into:

- **4A — Energy services:** peak shaving, arbitrage, demand response.
- **4B — Ancillary services:** frequency regulation, voltage regulation.

The reason is that ancillary services have **sub-minute temporal resolution** and a **signal model**, whereas energy services operate at 15 min–1 h.

---

## What this document does NOT cover

To avoid scope ambiguity, what is explicitly out of scope is declared:

- Implementation in Python, Databricks, PySpark, or SQL.
- Dashboard or user interface design.
- Financial modeling (NPV, IRR, payback, revenue waterfall).
- Data ingestion strategy or ETL pipelines.
- Contracts, commercial agreements, or regulatory matters.

These elements are addressed in later documents, once the engineering model is closed.

---

## Success criteria

The document will be considered complete when:

- Every ENGIE RFP requirement is traced to a model section.
- Every operating mode has objective, inputs, constraints, asset reservation, outputs, and risks defined.
- The degradation model is **incremental and simulable**, not a closed-form for constant conditions.
- There is a clear boundary between linear and nonlinear, and between the optimization horizon and the simulation loop.
- Dispatch has a decision variable, an objective function, and explicit constraints.
- No symbol is used without being registered in Part 1.

---

