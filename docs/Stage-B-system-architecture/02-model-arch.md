
---

# STAGE-B-HLD-001 — System Architecture (HLD)

## §5 — B.2 Model Architecture

**Document ID:** B.2-MODEL-ARCH-001

**Version:** 0.5.1 — Baseline (Frozen)

**Section:** §5 — B.2 Model Architecture

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
- `B.3-OPT-ARCH-001` — B.3 Optimization Architecture (v0.6 Baseline Frozen)

**Note on versions.** Parent document versions are not restated here; they are as declared in each document.

**Change log.** See §13 for detailed changes across versions.

---

### 1. Purpose of B.2

B.2 defines the **model architecture** of the system. It establishes:

- What **computational objects** exist (per component)
- What **state** each object maintains
- How state **evolves** over time
- What **temporal behavior** each object has
- What **inter-model interfaces** exist
- What **lifecycle** each object has
- How state is **persisted**
- What **parallelization boundaries** exist
- What **logical model types** are recognized

B.2 **does not** define:

- Class structures
- Method signatures
- Exact algorithms
- Solver configuration
- Numerical schemes
- Physical schemas
- Code

Those belong to Stage C (specification) and Stage D (implementation).

**Rule:** *B.2 defines the logical model architecture; Stage C defines the physical model specification.*

B.2 answers:

> **How are the engineering components represented computationally, and how do they behave over time?**

---

### 2. Position Within Stage B

B.2 sits **after B.1** (Data Architecture) and **before B.3** (Optimization Architecture). It details the computational dimension of the architecture defined in B.0.

| View | Depends on | Detail Level |
|---|---|---|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| **B.2 Model Architecture** | **B.0, B.1** | **Component details** |
| B.3 Optimization Architecture | B.0, B.2 | Dispatch details |
| B.4 Financial Architecture | B.0, B.2, B.3 | Financial details |
| B.5 Software Architecture | B.0–B.4 | Software details |
| B.6 Databricks Architecture | B.0–B.5 | Platform details |

**Rule:** B.2 constrains B.3–B.6 on model aspects. No view can contradict B.2's model architecture.

**Rule:** B.2 does not redefine components, responsibilities, interfaces, data families, or model objects already declared in B.0 or B.1.

---

### 3. Model Architecture View

#### 3.1 Overview

The system's **model architecture** is organized around **7 computational objects**, corresponding to the 7 functional components of B.0:

```
                    MODEL ARCHITECTURE
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
  STATEFUL           STATELESS          COORDINATING /
  OBJECTS            OBJECTS            AGGREGATING
        │                  │                  │
        ▼                  ▼                  ▼
  BESS Model         Load & Market       Dispatch
  Degradation        Tariff Engine       Financial
                     Operational
```

Each object has:

- A **purpose**
- A **state** (stateful) or **no state** (stateless)
- A **temporal behavior** (how it evolves over time)
- **Interfaces** (inputs, outputs)
- A **lifecycle** (initialization → execution → termination)
- A **parallelization profile**

#### 3.2 Object Classification

| Object | Classification | State? | Temporal? |
|---|---|---|---|
| **BESS Model** | Stateful | ✅ Yes | ✅ Interval-level |
| **Load & Market Model** | Stateless | ❌ No | ⚠️ Scenario-level |
| **Tariff Engine** | Stateless | ❌ No | ✅ Billing-period level |
| **Operational Model** | Stateless | ❌ No | ⚠️ Scenario-level |
| **Dispatch Engine** | Coordinating | ✅ Yes | ✅ Horizon-level |
| **Degradation Engine** | Stateful | ✅ Yes | ✅ Annual |
| **Financial Engine** | Aggregating | ⚠️ Partially | ✅ Annual |

#### 3.3 Key Distinctions

| Concept | Definition |
|---|---|
| **Computational object** | A model component with defined behavior |
| **State** | Data that persists across iterations |
| **Temporal behavior** | How the object evolves over time |
| **Lifecycle** | Initialization, execution, termination |
| **Parallelization profile** | How the object can be parallelized |

**Rule:** These are **different model concepts**. They are not layers, not components, and not domains.

---

### 4. Computational Objects

#### 4.1 Object 1 — BESS Model

**Purpose:** Represent the physical and technical state of the battery energy storage system computationally.

**State:**

| State variable | Type | State owner | Evolution determined by |
|---|---|---|---|
| **SOC** | State (continuous) | BESS Model | Dispatch (operational trajectory) |
| **SOH** | State (continuous, non-monotonic) | BESS Model | Degradation |
| **Available capacity** | Derived state | BESS Model | Degradation |
| **Usable capacity** | Derived state | BESS Model | Degradation |
| **Technical availability** | State (time-dependent) | BESS Model | BESS Model |

**Note on SOC ownership.** BESS Model **owns the state representation** of SOC. Dispatch determines the **operational trajectory** that causes SOC to evolve. BESS Model adopts the SOC trajectory produced by the solver as the **authoritative SOC trajectory** and **validates the energy balance** (`A.2.1` §17.1). BESS Model does **not recompute** the SOC trajectory.

**Note on the two SOC calculations.** The solver produces an SOC trajectory (B.3 §9.2). The BESS Model represents and updates the physical state resulting from the dispatch trajectory. To avoid divergence (e.g., rounding, efficiency application), the **SOC trajectory from the solver's solution is authoritative**; the BESS Model adopts it and validates energy balance, without recomputing SOC.

**Note on technical availability.** "Technical availability" refers to the **intrinsic asset availability** (asset health, maintenance, derating). It is distinct from **contextual availability** (e.g., availability of generation to charge), which belongs to the System Context / Load & Market Model.

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Interval-level (15-min or 1-h, per PH-054) |
| **Evolution** | SOC evolves per interval; SOH evolves at the annual state-update cycle |
| **Stateful** | Yes — state persists across intervals and years |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Output** | Operational Model | Physical capabilities |
| **Output** | Dispatch Engine | Feasible operating envelope |
| **Output** | Degradation Engine | Physical state, operating history |
| **Output** | Tariff Engine | **Auxiliary consumption** (component of net load composition) |
| **Input** | Dispatch Engine | Charge/discharge trajectory (adopted as authoritative SOC trajectory) |
| **Input** | Degradation Engine | Updated SOH, available capacity, **augmentation events**, **replacement events** |

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load physical parameters, initial state |
| **Execution** | Adopt the authoritative SOC trajectory from the dispatch solution; validate energy balance |
| **Annual update** | Receive updated SOH and augmentation/replacement events from Degradation |
| **Termination** | Persist final state |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario** | ❌ Sequential across years (SOH carries forward) |
| **Within a year** | ✅ Parallelizable across representative periods (terminal SOC = initial SOC decouples periods, per B.3 §8.4) |

#### 4.2 Object 2 — Load & Market Model

**Purpose:** Represent the external operating environment computationally.

**State:** None (stateless).

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Interval-level (for signals) |
| **Evolution** | Signals are derived or provided for the active scenario; no internal state is carried across execution intervals |
| **Stateful** | No — pure function of inputs |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Output** | Operational Model | External conditions |
| **Output** | Dispatch Engine | Context-derived signals, prices, load |
| **Output** | Tariff Engine | **Reference / baseline load** (for bill-without-BESS calculation) |
| **Input** | Dispatch Engine | Attribution basis (for market / program settlement) |
| **Output** | Financial Engine | Settlement basis |

**Note on dual role.** The Load & Market Model has two roles: (1) **signal provider** upstream of Dispatch, and (2) **settlement executor** downstream of Dispatch, where it executes the market/program adapters (A.2.2 §13.5) on the attribution basis. Both roles are stateless; settlement is a pure function of attribution basis + adapter rules + prices. Where program rules depend on cumulative quantities within a season (e.g., maximum number of DR events), the full season's attribution basis is required, and settlement is parallelizable across scenarios only.

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load signals for scenario |
| **Execution** | Provide signals on demand; execute market/program adapters on attribution basis |
| **Termination** | No state to persist |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario** | ✅ Parallelizable (stateless) |

**Note:** Domain 2 owns the External Context interface. The Load & Market Model produces **context-derived signals**, not raw context.

**Note on Reference / baseline load.** The Load & Market Model provides the **reference / baseline load** to the Tariff Engine for the **bill-without-BESS calculation**. The **net load is composed by the Tariff Engine**; Dispatch provides the **battery power trajectory** (see §4.3).

#### 4.3 Object 3 — Tariff Engine

**Purpose:** Apply the customer tariff to a load profile to compute the customer bill with and without BESS.

**State:** None (stateless).

**Net Load Composition (Architectural Rule).**

The Tariff Engine **composes** the net load from three components:

```
Net load =
    Base load (from Load & Market Model)
  + Battery power trajectory (from Dispatch Engine)
  + Auxiliary consumption (from BESS Model)
```

**Sign convention:** charging is positive, discharging is negative, as seen from the site meter. The **power reference point** (AC-side vs. DC-side) is deferred to Stage C.

**Rule:** Dispatch delivers the **battery power trajectory**, not the net load. The Tariff Engine composes the net load and avoids double counting.

This resolves the architectural question left open by `A.2.4` §14.2.

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Billing-period level |
| **Evolution** | Bills are computed per billing period |
| **Stateful** | No — pure function of tariff + load |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Input** | Dispatch Engine | Battery power trajectory |
| **Input** | Load & Market Model | Reference / baseline load |
| **Input** | BESS Model | Auxiliary consumption |
| **Output** | Financial Engine | Bill and savings outputs (BTM) |

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load tariff structure |
| **Execution** | Compose net load; compute bill with/without BESS |
| **Termination** | No state to persist |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario (without ratchets)** | ✅ Parallelizable across billing periods |
| **Within a scenario (with ratchets)** | ❌ Not parallelizable across billing periods — bill computation requires the full 12-month net-load history |

**Rule:** Without ratchets, the Tariff Engine is parallelizable within a scenario across billing periods. **With ratchets**, bill computation requires the full 12-month net-load history, and is **parallelizable across scenarios only**.

**Applicability:** The Tariff Engine is applicable to configurations where customer tariff economics are relevant, particularly BTM. For FTM-only configurations, market revenues flow directly to Financial Engine.

#### 4.4 Object 4 — Operational Model

**Purpose:** Define how the BESS can be used to provide specific services — the operational requirements each value stream imposes.

**State:** None (stateless).

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Per value stream |
| **Evolution** | Requirements are derived per scenario |
| **Stateful** | No — pure function of physical + external inputs |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Input** | BESS Model | Physical capabilities |
| **Input** | Load & Market Model | External conditions |
| **Output** | Dispatch Engine | Operational requirements |
| **Output** | Degradation Engine | Behavior declarations |

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load value stream definitions |
| **Execution** | Derive requirements per stream |
| **Termination** | No state to persist |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario** | ✅ Parallelizable (stateless) |

#### 4.5 Object 5 — Dispatch Engine

**Purpose:** Coordinate competing operational objectives under shared physical constraints.

**Model outputs / execution state:**

| Output | Role |
|---|---|
| **SOC trajectory** | Operational state history (authoritative) |
| **Battery power trajectory** | Optimization output (delivered to Tariff Engine and Degradation Engine) |
| **Reserve capacity trajectory** | Optimization output |
| **Operational attribution basis** | Attribution output |

**Note on Dispatch state.** Dispatch is a **stateful operational coordinator**. It maintains operational coordination state (e.g., reserve capacity decisions) within the optimization horizon. But its outputs are not all "state": SOC trajectory is **state history**, reserve capacity is **optimization output**, attribution basis is **attribution output**. This distinction aligns with B.1 §5.

**Note on SOC trajectory authority.** The SOC trajectory produced by the solver is **authoritative**. The BESS Model adopts it and validates energy balance (per §4.1). This prevents divergence between the solver's SOC and the BESS Model's SOC.

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Interval-level |
| **Horizon** | Optimization horizon defined by the Dispatch and Optimization Architecture (B.3) |
| **Evolution** | State evolves within the optimization horizon; state carry-forward rules are defined by B.3 |
| **Stateful** | Yes — operational coordination state |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Input** | BESS Model | Feasible envelope |
| **Input** | BESS Model | **SOH** (state owner) |
| **Input** | Load & Market Model | Context-derived signals, prices, load |
| **Input** | Operational Model | Operational requirements |
| **Input** | Degradation Engine | **Marginal degradation signal** (signal only; SOH comes from BESS Model) |
| **Output** | BESS Model | Charge/discharge trajectory (adopted as authoritative SOC trajectory) |
| **Output** | Degradation Engine | Trajectories (power and SOC) |
| **Output** | Tariff Engine | **Battery power trajectory** |
| **Output** | Load & Market Model | Attribution basis (for settlement) |
| **Output** | Financial Engine | Attribution basis (streams not requiring market settlement, if any) |

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load inputs for the optimization horizon |
| **Execution** | Optimize dispatch per the optimization horizon |
| **State transition** | Update operational coordination state per B.3 state-transition rules |
| **Termination** | Persist state history |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario** | ❌ Sequential across years (SOH carries forward) |
| **Within a year** | ✅ Parallelizable across representative periods (terminal SOC = initial SOC decouples periods, per B.3 §8.4) |
| **Within an optimization horizon** | ❌ Single-node computation |

**Note on horizon.** The optimization horizon is defined by **B.3 Optimization Architecture**. B.2 declares that Dispatch operates within an optimization horizon; the specific horizon (monthly, rolling, etc.) is a B.3 decision.

**Note on SOH source.** Dispatch reads SOH from the **BESS Model** (state owner). From the Degradation Engine, Dispatch receives only the **marginal degradation signal** (derived operational signal). This aligns with B.3 §9.1 and B.0 §14.1.

#### 4.6 Object 6 — Degradation Engine

**Purpose:** Represent the evolution of battery capability over time as a consequence of operation.

**State:**

| State variable | Type | State owner | Evolution owner |
|---|---|---|---|
| **SOH** | State (continuous) | BESS Model (state) / Degradation Engine (evolution) | Degradation Engine |
| **EFC / degradation history** | History | Degradation Engine | Degradation Engine |
| **Augmentation history** | History | Degradation Engine | Degradation Engine |
| **Replacement history** | History | Degradation Engine | Degradation Engine |

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Annual |
| **Evolution** | SOH updated per year based on annual usage |
| **Stateful** | Yes — state persists across years |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Input** | Dispatch Engine | Trajectories (power and SOC) |
| **Input** | Operational Model | Behavior declarations |
| **Input** | BESS Model | Physical state |
| **Output** | BESS Model | Updated SOH, available capacity, **augmentation events**, **replacement events** |
| **Output** | Dispatch Engine | **Marginal degradation signal** (signal only) |
| **Output** | Financial Engine | Physical events (augmentation, replacement) |

**Note on augmentation/replacement events.** Degradation Engine sends **augmentation and replacement events to the BESS Model**, because these events change the capacity and the cohorts (per `A.2.5` §11.1), not just the SOH. The BESS Model needs these events to correctly represent the physical state.

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load initial state, physical parameters |
| **Annual update** | Aggregate usage, update SOH |
| **Policy evaluation** | Detect augmentation/replacement triggers; emit events to BESS Model |
| **Termination** | Persist final state |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario** | ❌ Sequential across years (SOH carries forward) |
| **Within a year** | ✅ Parallelizable across representative periods (SOH fixed) |

#### 4.7 Object 7 — Financial Engine

**Purpose:** Translate operational behavior into project-level economic performance.

**State:**

| State variable | Type | State owner | Evolution owner |
|---|---|---|---|
| **Cash flow accumulator** | State | Financial Engine | Financial Engine |
| **Revenue by stream** | Aggregate state | Financial Engine | Financial Engine |
| **KPIs** | Derived aggregate | Financial Engine | Financial Engine |

**Note on Financial state.** Financial state is **economic aggregation state**. It does **not** participate in the physical-operational state feedback loop. It is not an operational state.

**Temporal behavior:**

| Aspect | Description |
|---|---|
| **Time resolution** | Annual |
| **Evolution** | Cash flow accumulates per year |
| **Stateful** | Partially — accumulates across years |

**Interfaces:**

| Direction | To | Data |
|---|---|---|
| **Input** | Dispatch Engine | Attribution basis (streams not requiring market settlement, if any) |
| **Input** | Load & Market Model | Settlement basis |
| **Input** | Degradation Engine | Physical events |
| **Input** | Tariff Engine | Bill and savings outputs (BTM) |
| **Input** | Scenario Management | Financial assumptions |
| **Output** | Application | Revenue, cash flow, KPIs |

**Lifecycle:**

| Phase | Description |
|---|---|
| **Initialization** | Load financial assumptions |
| **Execution** | Aggregate operational results into cash flow |
| **KPI computation** | Compute NPV, IRR, payback |
| **Termination** | Persist final KPIs |

**Parallelization:**

| Aspect | Profile |
|---|---|
| **Across scenarios** | ✅ Parallelizable |
| **Within a scenario** | ⚠️ Sequential across years (cash flow accumulates) |

---

### 5. State Model

#### 5.1 Stateful vs Stateless Classification

| Object | Stateful? | Reason |
|---|---|---|
| **BESS Model** | ✅ Yes | SOC, SOH |
| **Load & Market Model** | ❌ No | Signals are inputs; settlement is a pure function |
| **Tariff Engine** | ❌ No | Pure function |
| **Operational Model** | ❌ No | Pure function |
| **Dispatch Engine** | ✅ Yes (coordinating) | Operational coordination state |
| **Degradation Engine** | ✅ Yes | SOH, history |
| **Financial Engine** | ⚠️ Partially (aggregating) | Cash flow accumulator |

#### 5.2 State Ownership

| State | State owner | Evolution owner |
|---|---|---|
| **SOC** | BESS Model | Dispatch (operational trajectory) |
| **SOH** | BESS Model | Degradation |
| **Available capacity** | BESS Model | Degradation |
| **EFC / degradation history** | Degradation Engine | Degradation Engine |
| **Cash flow** | Financial Engine | Financial Engine |
| **Reserve capacity** | Dispatch Engine | Dispatch Engine |

**Rule:** BESS owns the state representation; Degradation owns the evolution law; Dispatch owns the operational trajectory.

**Rule:** Financial state is economic aggregation state and does not participate in the physical-operational state feedback loop.

#### 5.3 State Persistence

| State | Persistence | Frequency |
|---|---|---|
| **SOC** | Per interval | Continuous |
| **SOH** | Per year | Annual |
| **Available capacity** | Per year | Annual |
| **EFC / history** | Per year | Annual |
| **Cash flow** | Per year | Annual |
| **Reserve capacity** | Per interval | Continuous |

**Persistence owner:** Domain 7 (persistence infrastructure)

**Rule:** **Persistence by Domain 7 does not transfer semantic or state ownership from the producing computational object.**

---

### 6. Temporal Behavior and Execution Dimension

#### 6.1 Temporal Scales

The system operates at **three temporal scales**:

| Temporal scale | Used by | Purpose |
|---|---|---|
| **Interval** (15-min or 1-h) | BESS, Dispatch | Physical operation, dispatch |
| **Billing period** | Tariff Engine | Bill computation |
| **Year** | Degradation, Financial | SOH update, cash flow |

**Rule:** Scenario is **not** a temporal scale. It is an execution dimension (see §6.2).

#### 6.2 Execution Dimension

| Execution dimension | Purpose |
|---|---|
| **Scenario** | Independent configuration, execution and result isolation |

**Rule:** Scenario is orthogonal to the temporal scales. It determines **which configuration is executed**, not **how long the execution runs**.

**Reference:** B.1 §13, B.3 §8.

#### 6.3 Conceptual Time Evolution

```
Scenario
  │
  ▼
FOR each year:
    │
    ├── FOR each representative period (parallelizable):
    │   │
    │   ├── FOR each interval:
    │   │   ├── BESS Model → envelope
    │   │   ├── Dispatch → trajectory
    │   │   └── Net load → tariff
    │   │
    │   └── Aggregate period results
    │
    └── Annual update:
        ├── Degradation: aggregate year → SOH update
        └── Financial: aggregate year → cash flow
```

This representation describes **temporal dependencies among model states and outputs**. It is **not** a frozen execution workflow or orchestration sequence. Execution orchestration is defined by the Stage B execution architecture (B.5 / B.6).

#### 6.4 Temporal Coupling

| Coupling | Description |
|---|---|
| **Interval → Interval** | SOC carries forward within horizon (per B.3) |
| **Period → Period** | With terminal SOC = initial SOC, periods within a year are **decoupled** (per B.3 §8.4) |
| **Year → Year** | SOH carries forward |
| **Scenario → Scenario** | No coupling (isolated) |

---

### 7. Inter-Model Interfaces

#### 7.1 Interface Principles

| Principle | Description |
|---|---|
| **Explicit** | Every interface is declared |
| **Contract-based** | Interfaces have defined contracts |
| **Directional** | Producer → Consumer |
| **Data, not logic** | Interfaces exchange data and state, not algorithms |

#### 7.2 Interface Matrix

| From Object | To Object | Data |
|---|---|---|
| BESS Model | Operational Model | Physical capabilities |
| BESS Model | Dispatch Engine | Feasible envelope |
| BESS Model | Degradation Engine | Physical state, history |
| BESS Model | Tariff Engine | **Auxiliary consumption** (component of net load composition) |
| Load & Market Model | Operational Model | External conditions |
| Load & Market Model | Dispatch Engine | Context-derived signals, prices, load |
| Load & Market Model | Tariff Engine | Reference / baseline load |
| Load & Market Model | Financial Engine | Settlement basis |
| Operational Model | Dispatch Engine | Operational requirements |
| Operational Model | Degradation Engine | Behavior declarations |
| Dispatch Engine | BESS Model | Charge/discharge trajectory (adopted as authoritative SOC trajectory) |
| Dispatch Engine | Degradation Engine | Trajectories (power and SOC) |
| Dispatch Engine | Tariff Engine | **Battery power trajectory** |
| Dispatch Engine | Load & Market Model | Attribution basis (for settlement) |
| Dispatch Engine | Financial Engine | Attribution basis (streams not requiring market settlement, if any) |
| Degradation Engine | BESS Model | Updated SOH, available capacity, **augmentation events**, **replacement events** |
| Degradation Engine | Dispatch Engine | **Marginal degradation signal** |
| Degradation Engine | Financial Engine | Physical events |
| Tariff Engine | Financial Engine | Bill and savings outputs (BTM) |

#### 7.3 Interface Timing

| Interface | Timing | Frequency |
|---|---|---|
| BESS → Dispatch | Envelope | Per interval |
| BESS → Degradation | State | Per state-update cycle |
| BESS → Tariff | Auxiliary consumption | Per interval |
| Load & Market → Dispatch | Signals | Per scenario |
| Load & Market → Tariff | Reference load | Per billing period |
| Load & Market → Financial | Settlement basis | Per settlement period |
| Operational → Dispatch | Requirements | Per scenario |
| Dispatch → BESS | Charge/discharge trajectory (authoritative SOC) | Per interval |
| Dispatch → Degradation | Trajectories (power and SOC) | Per state-update cycle |
| Dispatch → Tariff | Battery power trajectory | Per interval |
| Dispatch → Load & Market (settlement) | Attribution basis | Per settlement period |
| Degradation → BESS | Updated SOH, augmentation/replacement events | Per state-update cycle |
| Degradation → Dispatch | Marginal signal | Per state-update cycle |
| Tariff → Financial | Savings | Per billing period |

---

### 8. Lifecycle

#### 8.1 Lifecycle Phases

Each computational object has a lifecycle:

```
Initialization → Execution → State Transition → Termination
```

| Phase | Description |
|---|---|
| **Initialization** | Load parameters, initial state, scenario configuration |
| **Execution** | Perform computation per the object's responsibility |
| **State Transition** | Update state based on execution results |
| **Termination** | Persist final state, release resources |

#### 8.2 Lifecycle per Object

| Object | Initialization | Execution | State Transition | Termination |
|---|---|---|---|---|
| **BESS Model** | Load physical params, initial state | Adopt authoritative SOC trajectory; validate energy balance | Receive updated SOH and augmentation/replacement events | Persist final state |
| **Load & Market Model** | Load signals | Provide signals; execute market/program adapters | None | None |
| **Tariff Engine** | Load tariff | Compose net load; compute bill | None | None |
| **Operational Model** | Load value streams | Derive requirements | None | None |
| **Dispatch Engine** | Load inputs | Optimize dispatch | Update operational coordination state | Persist state history |
| **Degradation Engine** | Load initial state | Aggregate usage | Update SOH; emit events | Persist final state |
| **Financial Engine** | Load financial assumptions | Aggregate results | Update cash flow | Persist KPIs |

#### 8.3 Lifecycle Coordination

The **Execution Control** capability coordinates lifecycle across objects:

- Orchestrates initialization
- Sequences execution
- Coordinates state transitions
- Manages termination

---

### 9. Parallelization Boundaries

#### 9.1 Parallelization Profile

| Object | Across scenarios | Within scenario | Within year | Within horizon |
|---|---|---|---|---|
| **BESS Model** | ✅ Yes | ❌ Sequential (years) | ✅ Parallelizable (terminal SOC decouples periods) | ❌ Sequential (intervals) |
| **Load & Market Model** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| **Tariff Engine (without ratchets)** | ✅ Yes | ✅ Yes | ✅ Yes | — |
| **Tariff Engine (with ratchets)** | ✅ Yes | ❌ Sequential (12-month history) | — | — |
| **Operational Model** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| **Dispatch Engine** | ✅ Yes | ❌ Sequential (years) | ✅ Parallelizable (terminal SOC decouples periods) | ❌ Single-node |
| **Degradation Engine** | ✅ Yes | ❌ Sequential (years) | ✅ Parallelizable (representative periods, SOH fixed) | — |
| **Financial Engine** | ✅ Yes | ⚠️ Sequential (years) | — | — |

#### 9.2 Parallelization Axes

| Axis | Parallelizable? | Reason |
|---|---|---|
| **Scenarios** | ✅ Yes | Independent |
| **Representative periods (within year)** | ✅ Yes | **Terminal SOC = initial SOC decouples periods** (B.3 §8.4) **and** SOH is fixed within the year |
| **Sensitivity analyses** | ✅ Yes | Independent |
| **Project years** | ❌ No | SOH carries forward |
| **Intervals within horizon** | ❌ No | SOC carries forward |
| **Within a dispatch optimization** | ❌ No | Single-node computation |
| **Tariff Engine with ratchets** | ⚠️ Across scenarios only | Full 12-month net-load history required |

**Reference:** `SYS-STR-FRM-001` §9.3, B.0 §3.5.3, B.3 §8.4.

#### 9.3 Parallelization Technology

| Axis | Technology |
|---|---|
| **Scenarios** | PySpark (parallel across scenarios) |
| **Representative periods** | PySpark (parallel within year) |
| **Sensitivities** | PySpark (parallel across cases) |
| **Within scenario** | Python (sequential) |
| **Within dispatch** | Python (single-node) |

**Reference:** `SYS-STR-FRM-001` §9.3.

---

### 10. Logical Model Types

#### 10.1 Recognized Types

B.2 recognizes the following **logical model types**:

| Logical Type | Description | Example |
|---|---|---|
| **State machine** | Object with discrete states and transitions | Dispatch Engine |
| **Pure function** | Stateless object with deterministic output | Tariff Engine |
| **Accumulator** | Object that aggregates over time | Financial Engine |
| **Envelope provider** | Object that provides feasible region | BESS Model |
| **Signal provider** | Object that provides time series | Load & Market Model |
| **Optimizer** | Object that selects optimal decisions | Dispatch Engine |
| **Policy evaluator** | Object that evaluates policy triggers | Degradation Engine |

**Rule:** Classification (§3.2) ≠ Logical model type (§10.1). For example, Dispatch is a **Coordinating object** (classification) and a **State machine + Optimizer** (logical type).

#### 10.2 Deferred to Stage C

| Deferred to Stage C |
|---|
| Class structures |
| Method signatures |
| Exact algorithms |
| Solver configuration |
| Numerical schemes |

---

### 11. What Is Deliberately NOT Defined Here

| Not defined in B.2 | Belongs to |
|---|---|
| Class structures | Stage C |
| Method signatures | Stage C |
| Exact algorithms | Stage C |
| Solver configuration | Stage C |
| Numerical schemes | Stage C |
| Physical schemas | Stage C |
| Delta tables | Stage C |
| PySpark code | Stage D |
| Code | Stage D |

---

### 12. Next Steps

**B.2 status:**

| Aspect | Status |
|---|---|
| B.2 Model Architecture | ✅ Baseline (Frozen) (v0.5.1) |
| B.3 Optimization Architecture | ✅ Baseline (Frozen) (v0.6) |
| B.4 Financial Architecture | ✅ Baseline (Frozen) (v0.4) |
| B.5 Software Architecture | ✅ Baseline (Frozen) (v0.4) |
| B.6 Databricks Architecture | ⏭ Next |
| Stage B → Stage C Handoff | ⏭ Pending |

**Immediate next action.** Proceed to B.6 Databricks Architecture.

---

### 13. Change Log

#### 13.1 Changes from v0.4 to v0.5

| # | Change | Reason |
|---|---|---|
| 1 | §4.2: "The net load (after dispatch) is provided by Dispatch" → "The net load is composed by the Tariff Engine; Dispatch provides the battery power trajectory" | Align with §4.3 |
| 2 | §4.3: added sign convention (charging positive, discharging negative, as seen from the site meter); power reference point deferred to Stage C | Prevent implementation sign errors |
| 3 | §12: B.3 status updated to **Baseline (Frozen) (v0.6)** | Consistency |
| 4 | §9.1: BESS Model "Within horizon" column changed from "—" to "❌ Sequential (intervals)" | Align with §9.2 |

#### 13.2 Changes from v0.5 to v0.5.1

| # | Change | Reason |
|---|---|---|
| 1 | §4.2: added Input row "Dispatch Engine → Attribution basis (for market / program settlement)" and Output row "Financial Engine → Settlement basis"; added "Note on dual role" | Required by B.4 §4.4 (adapter ownership and settlement flow) |
| 2 | §4.2 Lifecycle: "Execution" now includes "execute market/program adapters on attribution basis"; Parallelization note on seasonal program rules | Consistency with dual role |
| 3 | §4.5: added Output row "Load & Market Model → Attribution basis (for settlement)"; reformulated existing Financial row to "Attribution basis (streams not requiring market settlement, if any)" | Declare the new settlement interface |
| 4 | §4.7: added Input row "Load & Market Model → Settlement basis" | Complete the settlement interface chain |
| 5 | §7.2 Interface Matrix: added two rows — Dispatch Engine → Load & Market Model (Attribution basis, for settlement) and Load & Market Model → Financial Engine (Settlement basis) | Declare the new settlement interfaces |
| 6 | §7.3 Interface Timing: added two rows — Dispatch → Load & Market (settlement), Load & Market → Financial | Declare timing of the new settlement interfaces |
| 7 | §5.1: Load & Market Model reason updated to "Signals are inputs; settlement is a pure function" | Consistency with dual role |
| 8 | §8.2 Lifecycle per Object: Load & Market Model Execution now includes "execute market/program adapters" | Consistency with dual role |
| 9 | §12: B.4 and B.5 statuses updated to Baseline (Frozen) | Consistency with the frozen tree |
| 10 | Header: version updated from v0.5 to v0.5.1 | Traceable interface patch |

#### 13.3 Version History

| Version | Date | Changes | Status |
|---|---|---|---|
| 0.1 | Stage B start | Initial B.2 draft | Superseded |
| 0.2 | Stage B correction | Document ID + clarifications | Superseded |
| 0.3 | Stage B correction | 9 corrections | Superseded |
| 0.4 | Stage B closure | 6 corrections | Superseded |
| 0.5 | Stage B closure | 11 corrections + 4 retoques | Superseded |
| 0.5.1 | Stage B closure | 10 corrections (settlement interface patch) | **Baseline (Frozen)** |

---

**End of §5 — B.2 Model Architecture (v0.5.1 — Baseline Frozen)**

**Status:** Baseline (Frozen)

**Next:** B.6 Databricks Architecture

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

---

