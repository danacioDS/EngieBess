# B.3-OPT-ARCH-001 — Optimization Architecture (v0.6.1 — Baseline Frozen)

---

## STAGE-B-HLD-001 — System Architecture (HLD)

## §6 — B.3 Optimization Architecture

**Document ID:** B.3-OPT-ARCH-001

**Version:** 0.6.1 — Baseline (Frozen)

**Section:** §6 — B.3 Optimization Architecture

**Status:** Stage B — Baseline (Frozen)

**Parent Documents:**

- `SYS-STR-FRM-001` — System Strategy & Delivery Framework
- `SYS-ENG-DEF-001` — Stage A.1 — System Component Definition
- `A.2.1-BESS-ENG-001` — BESS Engineering
- `A.2.2-LOAD-MKT-ENG-001` — Load & Market Engineering
- `A.2.3-OPS-ENG-001` — Operational Engineering
- `A.2.4-DISPATCH-ENG-001` — Dispatch & Optimization Engineering
- `A.2.5-DEG-ENG-001` — Degradation Engineering
- `A.2.6-FIN-ENG-001` — Financial Engineering
- `A.2.7-DATA-APP-ENG-001` — Data & Application Engineering
- `PH1-REG-001` — Phase 1 Clarification & Data Request Register
- `STAGE-B-HLD-INDEX-001` — Stage B HLD Master Index and Scope Definition
- `B.0-INTEGRATED-SYS-ARCH-001` — B.0 Integrated System Architecture (v0.3.3 Baseline Frozen)
- `B.1-DATA-ARCH-001` — B.1 Data Architecture (v0.3 Baseline Frozen)
- `B.2-MODEL-ARCH-001` — B.2 Model Architecture (v0.5.1 Baseline Frozen)
- `B.4-FIN-ARCH-001` — B.4 Financial Architecture (v0.4 Baseline Frozen)
- `B.5-SW-ARCH-001` — B.5 Software Architecture (v0.4 Baseline Frozen)
- `B.6-DBX-ARCH-001` — B.6 Databricks Architecture (v0.4 Baseline Frozen)

**Note on versions.** Parent document versions are not restated here; they are as declared in each document.

**Change log.** See §15 for detailed changes across versions.

**PH verification.** PH IDs cited: PH-033, PH-034, PH-036, PH-040, PH-054. Verified against `PH1-REG-001` v1.1. No PH IDs are created or reinterpreted in B.3.

---

### 1. Purpose of B.3

B.3 defines the **optimization architecture** of the system. It establishes:

- What the **Dispatch Engine** optimizes
- What the **objective structure** is
- What **constraint families** exist
- How **revenue stacking** works
- How **services are coordinated**
- What the **horizon framework** is (project, simulation, optimization, resolution)
- What the **state-update cycle** is (distinct from horizons)
- How **state transitions** occur during optimization
- How the **degradation signal** is integrated
- What the **solver boundary** is
- How **feasibility / infeasibility** is handled
- What **logical optimization types** are recognized

B.3 **does not** define:

- Exact objective function equations
- Exact constraint formulations
- Linearization strategies
- Solver selection
- Solver configuration
- Numerical tolerances
- Class structures
- Code

Those belong to Stage C (specification) and Stage D (implementation).

**Rule:** *B.3 defines the logical optimization architecture; Stage C defines the physical optimization specification.*

B.3 answers:

> **How is the coordination of competing operational objectives structured computationally?**

---

### 2. Position Within Stage B

B.3 sits **after B.2** (Model Architecture) and **before B.4** (Financial Architecture). It details the optimization dimension of the architecture defined in B.0.

| View | Depends on | Detail Level |
|---|---|---|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| B.2 Model Architecture | B.0, B.1 | Component details |
| **B.3 Optimization Architecture** | **B.0, B.2** | **Dispatch details** |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| B.5 Software Architecture | B.0–B.4 | Software details |
| B.6 Databricks Architecture | B.0–B.5 | Platform details |

**Rule:** B.3 constrains B.4–B.6 on optimization aspects. No view can contradict B.3's optimization architecture.

**Rule:** B.3 does not redefine components, responsibilities, interfaces, data families, or model objects already declared in B.0, B.1, or B.2.

---

### 3. Optimization Architecture View

#### 3.1 Overview

The **optimization architecture** is centered on the **Dispatch Engine**, which coordinates competing operational objectives under shared physical constraints.

```
                OPERATIONAL REQUIREMENTS
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   Peak Shaving      Demand Response   Arbitrage
        │                │                │
        └────────────────┼────────────────┘
                         ▼
              ┌──────────────────────┐
              │   DISPATCH ENGINE    │
              │                      │
              │  Objective Structure │
              │  Constraints         │
              │  Revenue Stacking    │
              │  Service Coord.      │
              │  Horizon Mgmt.       │
              │  Feasibility         │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │  OPTIMIZATION        │
              │     SOLUTION         │
              └──────────┬───────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   Post-processing   State Update   Battery power
   / Attribution                     / Results
```

**Key distinction:** The solver produces an **optimization solution**. The system then **applies** that solution to update state, produce battery power trajectory, and generate results. Net load is composed by the Tariff Engine, not by Dispatch (B.2 §4.3).

#### 3.2 Optimization Layers

| Layer | Description |
|---|---|
| **Objective Layer** | What the optimization seeks to maximize/minimize |
| **Constraint Layer** | What limits apply (physical, operational, market, grid, tariff coupling) |
| **Coordination Layer** | How competing value streams are coordinated |
| **Horizon Layer** | What time horizon the optimization covers |
| **Feasibility Layer** | How feasible/infeasible problems are handled |
| **Solution Layer** | What the solver produces |
| **Post-processing Layer** | How the solution becomes state/results |

#### 3.3 Key Distinctions

| Concept | Definition |
|---|---|
| **Objective** | What is being optimized |
| **Constraint** | What limits the optimization |
| **Value stream** | A service the BESS can provide |
| **Coordination** | How value streams share resources |
| **Revenue stacking** | Accumulating value across streams |
| **Attribution** | Which stream owns which behavior |
| **Feasibility** | Whether the problem can be solved |
| **Solution** | What the solver produces |

**Rule:** These are **different optimization concepts**. They are not layers, not components, and not domains.

---

### 4. Objective Structure

#### 4.1 Objective Categories

The Dispatch Engine optimizes across **multiple objective categories**:

| Category | Description |
|---|---|
| **Market revenue** | Revenue from market participation (arbitrage, regulation, capacity) |
| **BTM savings signal** | Operational value signal derived from the customer tariff |
| **Degradation cost** | Marginal degradation cost (signal, not cash flow) |

**Note on BTM savings.** BTM savings may provide an **operational value signal** to Dispatch through the Tariff Engine, while **realized bill savings** remain owned by the Tariff Engine and are consumed by the Financial Engine.

```
Tariff Engine
     │
     │ economic signal
     ▼
Dispatch Engine
     │
     │ battery power trajectory
     ▼
Tariff Engine
     │
     │ actual bill / savings
     ▼
Financial Engine
```

This preserves the **single source of truth** established in B.0/B.1. The Tariff Engine composes the net load (base load + battery power + auxiliary consumption, per B.2 §4.3).

**Note on energy losses.** Physical efficiency losses are **implicitly valued** by the optimization: the LP charges energy at the charging price and discharges at the discharging price, so the round-trip loss is reflected in the objective without an additional penalty term. B.3 does **not** add a separate "energy losses" category, to avoid double counting.

#### 4.2 Objective Composition

The optimization objective **combines applicable value signals and operational cost signals**, subject to the declared constraints.

**Value signals** come from market prices, tariff rates, program payments.

**Cost signals** come from marginal degradation cost.

**Note:** The exact objective function form is a **Stage C** decision. B.3 declares **what contributes** to the objective, not **how it is weighted**.

#### 4.3 Objective Scenarios

Under working default **PH-033** (perfect foresight), the objective is computed under a **single scenario** per simulation.

Under **scenario-based dispatch** (extension), the objective may be computed across **multiple scenarios**.

---

### 5. Constraint Families

#### 5.1 Constraint Categories

| Category | Source | Examples |
|---|---|---|
| **Physical** | BESS Model | SOC bounds, power limits, ramp limits, inverter envelope |
| **Availability** | BESS Model | Unavailability, minimum rest |
| **Operational** | Operational Model | SOC floors per stream, duration floors, reserve requirements |
| **Market** | Load & Market Model | Eligibility, participation rules |
| **Program** | Load & Market Model | DR event windows, notification requirements |
| **Grid** | Load & Market Model | Interconnection limits, export constraints |
| **Warranty** | BESS Model | Annual throughput limits (where declared) |
| **Tariff / billing coupling** | Load & Market Model (tariff structure) | Billed peak as a coupled variable over the whole billing period; coincident-peak hours (treated as known) |
| **Simultaneous charge/discharge** | BESS Model + Market Model | Not enforced under LP default; mitigation if negative prices (Stage C) |

**Note on Tariff / billing coupling.** This family captures the constraint that the billed peak is a **coupled variable** across the entire billing period, not a per-interval quantity. This is what makes the problem **not separable** interval-by-interval. Included in this family:

- Monthly billed peak (non-coincident demand charge).
- Coincident-peak hours, treated as known.
- **Net load during regulation reserve** — regulation charging enters the same peak constraint as any other load, and may create or worsen the billed peak (BTM).

**Net-load composition rule within optimization.** Within the optimization, the net load used in the billing-peak constraint shall follow the **same composition rule as the Tariff Engine** (base load + battery power + auxiliary consumption, per B.2 §4.3), so that the dispatch peak and the billed peak are computed on the **same basis**. Without this rule, Dispatch could optimize a peak without auxiliary consumption while the bill charges it with auxiliary consumption.

**Note on ratchets.** Ratchets are **evaluated by the Tariff Engine, not by Dispatch** (A.2.4 §16.1). This preserves **month decoupling** within a year: with ratchets removed from the dispatch constraints, the terminal SOC condition is sufficient to make months independent for optimization purposes. Where ratchets apply, all 12 months are still simulated (PH-040), but each month remains an **independent optimization**.

**Note on coincident peak.** Coincident-peak hours are **treated as known** for dispatch purposes. The configurable **hit-rate factor** is a valuation adjustment applied **downstream** (Tariff Engine / Financial Engine), not a dispatch constraint.

**Note on simultaneous charge/discharge.** An LP formulation does not naturally forbid simultaneous charge and discharge; forbidding it requires a binary variable (MILP). Under the **LP default**, the constraint is **not enforced**, because with positive prices the optimum does not produce simultaneous charge and discharge. If the target market has negative prices (per PH-001), mitigation is deferred to **Stage C** (e.g., binary variable, penalty term, or MILP extension).

#### 5.2 Constraint Treatment

| Treatment | Architectural meaning |
|---|---|
| **Hard** | Must be satisfied; infeasibility is not allowed |
| **Soft** | May be violated subject to an explicit penalty or relaxation mechanism |

**Default treatment (per A.2.4 §8.3):**

| Constraint | Default treatment |
|---|---|
| SOC bounds | Hard |
| Power limits | Hard |
| Ramp limits | Hard |
| Availability | Hard |
| Grid interconnection limits | Hard |
| Warranty throughput limits (where declared) | Hard |
| DR performance | Soft (with penalty) |
| Contractual commitments | Soft (with penalty) |
| Tariff / billing coupling | Hard (billed peak is a coupled variable) |
| Simultaneous charge/discharge | Not enforced under LP default; mitigation if negative prices (Stage C) |

**Rule:** Additional constraints follow their declared treatment. Any constraint whose treatment is not declared here is determined in **Stage C**.

#### 5.3 Constraint Sources

| Source | Constraint Families |
|---|---|
| **BESS Model** | Physical, Availability, Warranty, Simultaneous charge/discharge |
| **Operational Model** | Operational |
| **Load & Market Model** | Market, Program, Grid, Tariff / billing coupling |

---

### 6. Revenue Stacking

#### 6.1 Concept

**Revenue stacking** is the accumulation of value across multiple value streams by a single BESS.

#### 6.2 Stacking Dimensions

| Dimension | Description |
|---|---|
| **Physical simultaneity** | Two value streams physically operate at the same time |
| **Reservation simultaneity** | Two value streams share reserved capacity |
| **Attribution simultaneity** | Two value streams are both credited for the same behavior |
| **Objective simultaneity** | Two value streams contribute to the same objective |

#### 6.3 Stacking vs Attribution

**Stacking** and **attribution** are **different concepts**:

```
Physical feasibility
        ↓
Operational stacking
        ↓
Optimization / allocation
        ↓
Dispatch
        ↓
Attribution
        ↓
Financial valuation
```

**Rule:** Two value streams being credited for the same behavior (attribution simultaneity) does not necessarily mean that a physical double-utilization exists. This distinction prevents double counting in the financial layer.

#### 6.4 Stacking Approaches

| Approach | Description |
|---|---|
| **Co-optimization** | All streams optimized jointly (single objective) |
| **Sequential** | Streams optimized in sequence (one at a time) |
| **Rule-based** | Streams prioritized by rules |
| **Hybrid** | Combination |

**Working default (RFP):** **Co-optimization**.

#### 6.5 Stacking Constraints

When value streams are stacked, they share:

- Power
- Energy
- SOC headroom
- Ramp capability
- Availability
- Inverter apparent-power envelope

The optimization must respect shared resource constraints.

---

### 7. Service Coordination

#### 7.1 Coordination Challenge

Multiple value streams may compete for the same physical resources. The optimization must coordinate them.

#### 7.2 Coordination Mechanisms

| Mechanism | Description |
|---|---|
| **Single objective** | All streams contribute to one objective |
| **Priority hierarchy** | Streams prioritized by rules |
| **Weighted objective** | Streams weighted by importance |
| **Lexicographic** | Streams optimized in order of priority |

**Working default:** **Single objective** (co-optimization under LP).

**Note on "single objective".** A single objective does not imply **equal weighting** of value streams. The objective is a single aggregate function; the relative weighting, normalization, and any internal structure of that aggregate are **Stage C** decisions. B.3 declares only that the streams are co-optimized into one aggregate objective.

#### 7.3 Coordination Scenarios

| Scenario | Description |
|---|---|
| **Simultaneous** | All streams active at the same time |
| **Sequential** | Streams active in sequence |
| **Conditional** | Streams activated based on conditions |

---

### 8. Horizon Framework and Simulation Structure

#### 8.1 Horizon Framework Concepts

The system distinguishes **four concepts**:

| Concept | Description | Working default |
|---|---|---|
| **Project horizon** | Full project / modeling horizon | 15 years (Strategy D13, PH-054) |
| **Simulation / representative-period framework** | How the project horizon is represented computationally | Monthly representative periods (PH-040) |
| **Optimization horizon** | Horizon covered by a single optimization run | See §8.4 |
| **Time resolution** | Interval-level temporal resolution | 15-min or 1-h (PH-054) |

**Rule:** These are **different concepts**. B.3 does not collapse them. The simulation / representative-period framework is a **simulation structure**, not a horizon.

**Note on the 15-year project horizon.** The 15-year horizon is part of `SYS-STR-FRM-001` §12.2 D13, recorded in the Register as PH-054 (time resolution and simulation horizon).

**Mapping between project years and representative periods.** The simulation framework shall define the **mapping between the project horizon (15 years) and the representative periods** so that annual state transitions, degradation updates, and financial aggregation remain **traceable across the project horizon**. The exact representative-period weighting, replication, and calendar mapping (e.g., whether a representative period is a specific month of a specific year, or a statistical representative repeated across years) are **deferred to Stage C**. B.3 declares that the mapping must exist and be traceable; it does not prescribe the mapping mechanism.

#### 8.2 State-Update Cycle

The **state-update cycle** is **not a horizon**. It is a **frequency of state update**:

| Cycle | Description | Working default |
|---|---|---|
| **State-update cycle** | Frequency at which state is updated | Annual SOH update (PH-036) |

**Rule:** The state-update cycle is orthogonal to the horizon framework. It determines **when state is updated**, not **how long the optimization runs**.

#### 8.3 Relationship Between Framework Components

```
Project horizon (15 years)
    │
    ├── Simulation / Representative-period framework (monthly representative periods)
    │       │
    │       └── Optimization horizon (per run)
    │               │
    │               └── Time resolution (15-min / 1-h)
    │
    └── State-update cycle (annual) — orthogonal to the horizon framework
```

**Rule:** The optimization horizon operates within the selected simulation and representative-period framework.

**Rule:** The simulation framework shall define a **traceable mapping** between project years and representative periods, so that annual state transitions (SOH), degradation updates, and financial aggregation can be reconstructed across the project horizon. The exact mapping is a **Stage C** decision.

#### 8.4 Optimization Horizon and State Carry-Forward

| Aspect | Description |
|---|---|
| **Coverage** | Must cover the relevant billing period for peak shaving |
| **Aligned with billing period** | Required for peak shaving (monthly billed peak) |
| **Ratchet handling** | Where ratchets apply, all 12 months are simulated (PH-040); ratchets are evaluated by the Tariff Engine, not by Dispatch (see §5.1) |
| **Terminal condition** | Terminal SOC condition required (see §8.5) |
| **State carry-forward** | See below |

**State carry-forward — precise formulation.**

| Scope | What carries forward | What does **not** carry forward |
|---|---|---|
| **Within a year** | Nothing — months are **decoupled** by the terminal SOC condition | SOC does **not** carry forward between months |
| **Between years** | SOH carries forward | SOC does **not** carry forward between years |

**Annual sequencing ownership.** B.3 defines the **semantics** of the annual SOH carry-forward: the state-update cycle chains the years together through the SOH evolution law. B.5 **orchestrates** the dependency (i.e., `execution_control` ensures that the annual sequence is respected), and B.6 **realizes** the orchestration on the platform. B.3 owns the semantic rule; B.5 and B.6 own the realization.

**Consequence for parallelization.** Because terminal SOC = initial SOC decouples the months within a year, the months of a given year are **independently parallelizable** with PySpark (per `SYS-STR-FRM-001` §9.3). Only the annual SOH update chains the years together.

**Working implementation assumption for the initial thin slice:** monthly optimization aligned with the billing period for peak-shaving use cases. This is an **implementation assumption for the thin slice**, not a final architectural decision.

#### 8.5 Terminal SOC

**Working default:** Terminal SOC is constrained to the initial SOC for the **initial thin-slice implementation**.

**Consequences of this working default:**

- Months within a year are **decoupled** (no SOC carry-forward between months).
- Months within a year are **independently parallelizable**.
- SOH still carries forward between years.

**Initial SOC per independent optimization.** Each independently optimized representative period shall receive an **explicit initial SOC state** from the BESS Model or from the declared scenario/state-initialization mechanism. The terminal SOC condition applies **within** that optimization horizon and does **not** create SOC carry-forward between representative periods. The value and mechanism of the initial SOC (e.g., default, configurable, or derived) are **Stage C** decisions; B.3 declares only that an explicit initial SOC is required per independent optimization.

**Note:** Terminal SOC treatment is a **working assumption for the thin slice**, subject to validation against applicable use cases. In general, terminal SOC treatment may be:

- Equal terminal SOC
- Minimum terminal SOC
- Terminal SOC target
- Terminal SOC value
- No terminal constraint under some circumstances

**Rule:** B.3 declares the **working default** for the thin slice; the final treatment is a **Stage C** decision.

---

### 9. State Transitions

#### 9.1 Optimization Inputs

Before optimization, the Dispatch Engine reads:

| State | Source |
|---|---|
| **SOC** | BESS Model (state owner) |
| **SOH** | BESS Model (state owner) |
| **Available capacity** | BESS Model (state owner) |
| **Marginal degradation cost** | Degradation Engine (signal) |

**Note on initial SOC per independent optimization.** Where representative periods are optimized independently (per §8.4 / §8.5), the **initial SOC of each optimization horizon** is an explicit input. The Dispatch Engine does not infer or carry it across horizons. The specific mechanism (default, configurable, or derived) is a Stage C decision.

#### 9.2 Optimization Solution

The solver produces an **optimization solution**:

| Output | Description |
|---|---|
| **Dispatch schedule** | Charge / discharge / rest per interval |
| **SOC trajectory** | SOC per interval |
| **Battery power trajectory** | Charge / discharge power per interval |
| **Reserved capacity** | Per stream, per interval |

**Rule:** The solver produces a **solution**. It does **not** write state.

#### 9.3 Post-Processing

The system applies the solution to produce:

| Output | Destination |
|---|---|
| **SOC trajectory** | Degradation Engine (cycle extraction is performed there) **and** State History (persisted by Domain 7) |
| **Battery power trajectory** | Degradation Engine (cycle extraction is performed there) **and** State History (persisted by Domain 7) |
| **Battery power trajectory** | Tariff Engine (net load composed there, per B.2 §4.3) |
| **Operational attribution basis** | Financial Engine |
| **Reserved capacity** | Dispatch Engine (state) |

**Rule:** The **state update** is a separate step from the **optimization** step.

**Note on Degradation Engine.** The battery power and SOC trajectories are the **primary inputs** to the annual degradation update (see §9.5). Cycle extraction is performed inside the Degradation Engine. Without this interface, the annual state-update cycle has no input.

**Note on Tariff Engine.** Dispatch delivers the **battery power trajectory** to the Tariff Engine; the Tariff Engine composes the net load (base load + battery power + auxiliary consumption, per B.2 §4.3). Dispatch does not deliver net load.

**Note on Financial Engine.** The operational attribution basis is routed to the Financial Engine for valuation. The Dispatch Engine produces the **basis**, not the valuation.

#### 9.4 State Ownership Consistency

Per B.0 §14.1 and B.1 §5:

- **BESS Model owns** the state representation (SOC, SOH).
- **Dispatch Engine owns** the operational trajectory during optimization.
- **Domain 7 owns** the persistence of state and state history.

**Rule:** B.3 respects the ownership model established in B.0 and B.1. Dispatch does not "write" SOC to BESS Model as if it were the owner of state.

#### 9.5 State Transitions

| Transition | Description |
|---|---|
| **Interval transition** | SOC updated per interval within horizon |
| **Horizon transition** | With terminal SOC = initial SOC, months within a year are decoupled; nothing carries forward |
| **Year transition** | SOH updated at the end of each state-update cycle (via Degradation Engine) |

**Rule on annual sequencing.** The year-to-year carry-forward is a **semantic rule owned by B.3**: the SOH evolution law chains the years together. B.3 does not prescribe the orchestration mechanism; orchestration is a **B.5** concern (via `execution_control`) and realization is a **B.6** concern.

---

### 10. Degradation Signal Integration

#### 10.1 Marginal Degradation Cost

The **marginal degradation cost** is a per-MWh signal representing the economic cost of one more unit of throughput.

**Source:** Degradation Engine.

**Consumer:** Dispatch Engine (objective).

**Boundary rule.** B.3 **consumes** the degradation signal and the updated SOH; B.3 **does not define** degradation mechanics. Degradation mechanics (calendar aging, cycle aging, throughput aggregation, depth-of-discharge effects, cohort behavior, augmentation/replacement policy evaluation) are owned by `A.2.5` and represented by the Degradation Engine in B.2 §4.6.

#### 10.2 Signal Characteristics

| Aspect | Description |
|---|---|
| **Nature** | Derived operational signal |
| **Basis** | Replacement/augmentation economics + degradation throughput |
| **Frequency** | Annual (under working default PH-036) |
| **Annual offset** | Signal computed from beginning-of-year state |

#### 10.3 Signal Integration

The signal enters the optimization through the **objective**.

**Note:** The exact integration is a **Stage C** decision. B.3 declares **that the signal enters the objective**.

#### 10.4 Avoiding Double Counting

**Rule:** The marginal degradation cost is a **signal**, not a cash flow. It enters the **objective** but not the **cash flow**.

**Reference:** B.0 §14.4, B.1 §5.1.

---

### 11. Solver Boundary

#### 11.1 What B.3 Defines

B.3 defines:

- **That** the Dispatch Engine uses a solver
- **Which logical optimization formulation types** the architecture supports (LP, MILP, heuristic, hybrid)
- **What the boundary** between the optimization architecture and the solver is
- **What inputs/outputs** cross the solver boundary

**Note on terminology.** B.3 declares **logical optimization formulation types**, not a concrete solver software choice. Solver software selection, configuration, and numerical tolerances are **Stage C** decisions.

#### 11.2 What B.3 Does Not Define

B.3 does **not** define:

- **Which** solver software is used
- **How** the solver is configured
- **What** numerical tolerances are used
- **What** solver-specific parameters are used

Those belong to Stage C.

#### 11.3 Working Default

**Working default (PH-034):** **LP** (Linear Programming).

**Working technology preference:** Open-source LP solver.

**Note on solver licensing.** The Register (`PH1-REG-001` v1.1) does not currently carry a solver-licensing item. Solver licensing is treated as an **implementation preference** (open-source preferred) and is not a Phase 1 clarification item.

#### 11.4 Optimization Boundary

| Inside the optimization boundary | Outside the optimization boundary |
|---|---|
| Optimization problem formulation | Solver configuration |
| Objective structure | Solver parameters |
| Constraint families | Numerical tolerances |
| Decision-variable domains | Solver-specific settings |
| Optimization inputs and state references | State persistence and post-processing |

**Rule:** The solver **reads** the values needed to build the problem. It is **not** the owner of state write. State update and persistence happen **outside** the optimization boundary (see §9.3).

---

### 12. Feasibility and Infeasibility Handling

#### 12.1 Optimization Outcomes

Optimization can produce:

| Outcome | Description |
|---|---|
| **Feasible solution** | Solver produces a valid solution |
| **Infeasible problem** | No solution satisfies all hard constraints |
| **Solver failure** | Solver fails to produce a solution (time limit, numerical issue, interruption) |
| **Incomplete input** | Required inputs are missing |
| **Validation failure** | Solution fails validation |

#### 12.2 Feasibility Flow

```
Inputs
  ↓
Constraint Assembly
  ↓
Optimization Problem
  ↓
Solver / Feasibility Evaluation
  ├── Feasible → Solution
  └── Infeasible / Failure → Controlled Handling
```

**Note:** In an LP/MILP formulation, infeasibility may be discovered **during** the resolution, not necessarily through a separate pre-check stage. B.3 declares that **feasibility assessment is part of optimization execution**, not a separate pre-optimization stage.

#### 12.3 Controlled Handling

B.3 declares that the system must conceptually support:

- **Feasibility evaluation** — as part of optimization execution
- **Controlled handling** — when the problem is infeasible
- **Solver failure handling** — when the solver fails
- **Incomplete input handling** — when inputs are missing
- **Validation failure handling** — when validation fails

**Rule:** The specific mechanism (relaxation, error reporting, fallback) is deferred to Stage C.

---

### 13. Logical Optimization Types

#### 13.1 Recognized Types

B.3 recognizes the following **logical optimization formulation types**:

| Logical Type | Description | Working default |
|---|---|---|
| **Linear Programming (LP)** | Linear objective + linear constraints | ✅ Default |
| **Mixed-Integer LP (MILP)** | LP + discrete decisions | Extension |
| **Rule-based** | Deterministic rules | Extension |
| **Hybrid** | Combination | Extension |

**Note.** B.3 declares the logical formulation types the architecture supports. Solver software selection is Stage C.

#### 13.2 Deferred to Stage C

| Deferred to Stage C |
|---|
| Exact objective function form |
| Exact constraint formulations |
| Linearization strategies |
| Solver software selection |
| Solver configuration |
| Numerical tolerances |

---

### 14. What Is Deliberately NOT Defined Here

| Not defined in B.3 | Belongs to |
|---|---|
| Exact objective function | Stage C |
| Exact constraint formulations | Stage C |
| Linearization strategies | Stage C |
| Solver software selection | Stage C |
| Solver configuration | Stage C |
| Numerical tolerances | Stage C |
| Degradation mechanics | A.2.5 / B.2 |
| Representative-period mapping mechanism | Stage C |
| Initial SOC value and mechanism | Stage C |
| Class structures | Stage C |
| Method signatures | Stage C |
| Code | Stage D |

---

### 15. Change Log

#### 15.1 Changes from v0.1 to v0.2

| # | Change | Reason |
|---|---|---|
| 1 | Clarified state ownership and state write separation | Align with B.0/B.1 ownership model |
| 2 | Distinguished horizon levels | Align with Strategy (PH-036, PH-040, PH-054) |
| 3 | Terminal SOC reframed as working assumption | Avoid universal rule |
| 4 | Solver: separated solver class from solver selection | Resolve internal contradiction |
| 5 | Hard/soft constraints reframed as architectural capability | Avoid premature Stage C decisions |
| 6 | Added §12 Feasibility and Infeasibility Handling | Complete optimization lifecycle |
| 7 | Clarified stacking vs attribution | Avoid double counting |
| 8 | Reframed "operational efficiency" as "economic consequence of energy losses" | Distinguish physical from economic |

#### 15.2 Changes from v0.2 to v0.3

| # | Change | Reason |
|---|---|---|
| 1 | §8: title "Horizon Framework and Simulation Structure" | Clarify simulation structure ≠ horizon |
| 2 | §8.2: "State-update horizon" → "State-update cycle" | Orthogonal to horizon framework |
| 3 | §11.4: "State read/write" → "Optimization inputs and state references" | Align with "solver produces solution, does not write state" |
| 4 | §12.2: feasibility flow includes feasibility evaluation during solver execution | Infeasibility may be discovered during resolution |
| 5 | §4.1: added "BTM savings signal" clarification | Preserve single source of truth (Tariff Engine owns realized savings) |
| 6 | §4.3: added PH verification note | Traceability cross-check required |

#### 15.3 Changes from v0.3 to v0.4

| # | Change | Reason |
|---|---|---|
| 1 | Header: removed "Frozen"; status set to **Baseline Candidate (pending B.2 freeze)** | B.2 is still a Draft; B.3 cannot be frozen before B.2 |
| 2 | §8.1: 15-year project term cites **Strategy D13**, not PH-054 | PH-054 is time resolution, not project term |
| 3 | §11.3: removed "HiGHS pending verification against PH1-REG-001"; added note that solver licensing is not a Phase 1 clarification item | No PH item for solver licensing exists |
| 4 | §5.1: added **Tariff / billing coupling** constraint family | Preserves A.2.4 §16.1 (peak as coupled variable, coincident peak, ratchet, regulation charging into peak) |
| 5 | §5.1: added **Simultaneous charge/discharge** constraint family | Preserves A.2.4 §16.1 trap (negative prices) |
| 6 | §4.1: removed "Energy losses" category | Avoid double counting (LP implicitly prices losses) |
| 7 | §8.4 and §8.5: clarified state carry-forward — within-year months are decoupled by terminal SOC; only SOH carries between years | Align with parallelization strategy (`SYS-STR-FRM-001` §9.3) |
| 8 | §9.3: added **Degradation Engine** as destination of power + SOC trajectories; moved **attribution basis** to **Financial Engine** | Complete the state-update cycle input; correct attribution destination |
| 9 | §5.2: hard/soft constraint defaults declared per A.2.4 §8.3 | Do not defer decisions already made upstream |
| 10 | §12.1: "Solver fails to converge" → "Solver fails to produce a solution (time limit, numerical issue, interruption)" | More precise outcome description |

#### 15.4 Changes from v0.4 to v0.5

| # | Change | Reason |
|---|---|---|
| 1 | §5.1: removed ratchet-floored billed demand from Tariff/billing coupling; added note that ratchets are evaluated by Tariff Engine (A.2.4 §16.1) | Preserve month decoupling (§8.4) |
| 2 | §5.1: coincident-peak reframed as "hours treated as known"; hit-rate factor moved to downstream valuation | Hit-rate factor is not a dispatch constraint |
| 3 | §5.2: simultaneous charge/discharge reframed as "Not enforced under LP default; mitigation if negative prices (Stage C)" | LP cannot forbid simultaneity; MILP required |
| 4 | §9.3: SOC trajectory added as destination to Degradation Engine | SOC is the primary input for cycle extraction |

#### 15.5 Changes from v0.5 to v0.6

| # | Change | Reason |
|---|---|---|
| 1 | §8.1: added mapping rule between project horizon (15 years) and representative periods; deferred weighting/replication/calendar mapping to Stage C | Close blocker: traceable mapping across the project horizon |
| 2 | §8.3: added traceable mapping rule consistent with §8.1 | Consistency |
| 3 | §8.4: added "Annual sequencing ownership" note — B.3 owns the semantic rule, B.5 orchestrates, B.6 realizes | Prevent B.5 from appropriating B.3's annual-sequence semantics |
| 4 | §8.5: added "Initial SOC per independent optimization" rule — explicit initial SOC per horizon; value/mechanism deferred to Stage C | Close blocker: parallelizable months require explicit initial SOC |
| 5 | §9.1: added "Note on initial SOC per independent optimization" | Consistency with §8.5 |
| 6 | §9.5: added "Rule on annual sequencing" — B.3 owns semantics, B.5 orchestrates, B.6 realizes | Consistency with §8.4 |
| 7 | §10.1: added "Boundary rule" — B.3 consumes the degradation signal and SOH; B.3 does not define degradation mechanics | Clarify boundary with A.2.5 / B.2 |
| 8 | §7.2: added "Note on single objective" — single objective does not imply equal weighting; weighting/normalization are Stage C | Avoid misinterpretation |
| 9 | §11.1: "what class of solver" reframed as "logical optimization formulation types" | Avoid confusion with concrete solver software |
| 10 | §13.1: title and content reframed as "logical optimization formulation types"; solver software selection deferred to Stage C | Consistency with §11.1 |
| 11 | §14: added degradation mechanics, representative-period mapping mechanism, initial SOC value/mechanism to "not defined here" | Explicit non-scope |
| 12 | Header: B.2 cited as **v0.5.1 Baseline Frozen** (was v0.1 Draft in earlier versions) | Correct parent version |
| 13 | Header: status set to **Freeze Candidate**; freeze dependency note updated | Freeze preparation |
| 14 | §8.1: 15-year project term cites **Strategy D14** | Consistency with v0.4 |
| 15 | §3.1: diagram label "Net Load / Results" → "Battery power / Results" | Align with B.2 v0.5.1 §4.3 (net load composed by Tariff Engine) |
| 16 | §4.1: BTM diagram label "dispatch / net load" → "battery power trajectory" | Align with B.2 v0.5.1 §4.3 |
| 17 | §5.1: added "Net-load composition rule within optimization" — same composition rule as Tariff Engine (base load + battery power + auxiliary consumption, B.2 §4.3) | Ensure dispatch peak and billed peak are computed on the same basis |
| 18 | §9.3: changed "Net load → Tariff Engine" to "Battery power trajectory → Tariff Engine (net load composed there, per B.2 §4.3)" | Align with B.2 v0.5.1 §4.3 |
| 19 | §8.1: "Full contract term" → "Full project / modeling horizon" | Avoid contractual ambiguity (contract is 12 weeks, project is 15 years) |

#### 15.6 Changes from v0.6 to v0.6.1

| # | Change | Reason |
|---|---|---|
| 1 | Header: added `B.4`, `B.5`, `B.6` to Parent Documents with their frozen versions | Completeness of the frozen Stage B tree |
| 2 | §16 Next Steps: **B.5 status corrected** — from "🔄 Baseline Candidate (v0.4) — pending update to cite B.3 Frozen" to "✅ Baseline (Frozen) (v0.4)" | Editorial correction: B.5 v0.4 already cites B.3 v0.6 Frozen. No architectural content changed |
| 3 | §16 Next Steps: **B.4 status confirmed** as "✅ Baseline (Frozen) (v0.4)" | Consistency with the frozen tree |
| 4 | §16 Next Steps: **B.6 status corrected** — from "⏭ Next" to "✅ Baseline (Frozen) (v0.4)" | B.6 was frozen in the same closure pass |
| 5 | §16 Next Steps: **Stage B → Stage C Handoff** status corrected to "⏭ Pending" (unchanged), immediate action updated to "Proceed to Stage B → Stage C Handoff" | Reflect real closure state |
| 6 | Header: version bumped to **v0.6.1 — Baseline (Frozen)** | Editorial patch; the architecture content of v0.6 remains frozen |


#### Errata applied after freeze

| # | Change | Reason |
|---|---|---|
| 1 | §8.1 and §15.7: the 15-year horizon is cited as Strategy D13 / PH-054 (previously "Strategy D14", with a note stating PH-054 did not cover the horizon) | `SYS-STR-FRM-001` v1.0.2 corrected the PH-050 to PH-055 mapping: D13 = PH-054 (time resolution and simulation horizon), D14 = PH-055 (presentation of value) |

Historical change-log rows that mention "Strategy D14" are kept as originally written.

#### 15.7 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage B start | Initial B.3 draft | Superseded |
| 0.2 | Stage B correction | 8 corrections | Superseded |
| 0.3 | Stage B final | 6 corrections | Superseded |
| 0.4 | Stage B closure | 10 corrections | Superseded |
| 0.5 | Stage B closure | 4 corrections | Superseded |
| 0.6 | Stage B freeze audit | 19 corrections (mapping, annual sequencing ownership, initial SOC, degradation boundary, single objective, solver terminology, parent version, net-load composition) | Superseded |
| 0.6.1 | Stage B closure | 6 editorial corrections (parent list completed; B.4/B.5/B.6 statuses corrected to Frozen) | **Baseline (Frozen)** |

#### 15.8 PH Traceability

**PH IDs cited in B.3:** PH-033, PH-034, PH-036, PH-040, PH-054.

**Verified against `PH1-REG-001` v1.1:**

| PH ID | Use in B.3 | Register topic | Status |
|---|---|---|---|
| PH-033 | Perfect foresight | Perfect foresight vs forecast-based | ✅ Match |
| PH-034 | LP default | Dispatch methodology | ✅ Match |
| PH-036 | Annual SOH update | Degradation feedback time scale | ✅ Match |
| PH-040 | Representative periods / ratchets | Representative-period scheme and ratchets | ✅ Match |
| PH-054 | Time resolution | Time resolution | ✅ Match |

**Note on project horizon.** The 15-year horizon is declared in `SYS-STR-FRM-001` §12.2 D13 and recorded in the Register as PH-054 (time resolution and simulation horizon).

**No PH IDs are created or reinterpreted in B.3.**

---

### 16. Next Steps

**B.3 status:**

| Aspect | Status |
|---|---|
| B.0 Integrated System Architecture | ✅ Baseline (Frozen) (v0.3.3) |
| B.1 Data Architecture | ✅ Baseline (Frozen) (v0.3) |
| B.2 Model Architecture | ✅ Baseline (Frozen) (v0.5.1) |
| **B.3 Optimization Architecture** | **✅ Baseline (Frozen) (v0.6.1)** |
| B.4 Financial Architecture | ✅ Baseline (Frozen) (v0.4) |
| B.5 Software Architecture | ✅ Baseline (Frozen) (v0.4) |
| B.6 Databricks Architecture | ✅ Baseline (Frozen) (v0.4) |
| STAGE-B-HLD-INDEX-001 | ⏭ Pending (v0.2 production) |
| Stage B → Stage C Handoff | ⏭ Pending |

**Immediate next action.**

1. Produce `STAGE-B-HLD-INDEX-001` v0.2 (Baseline Frozen).
2. Produce `STAGE-B-TO-C-HANDOFF-001` v0.1.
3. Execute the Stage B closure sequence.

---




