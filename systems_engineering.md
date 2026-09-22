
---

# Semantic Systems Engineering Method

## From Product Intent to Validated and Executable Systems

**Version 4.3 — Engineering Method**

---

## Resumen de cambios respecto a 4.2

| # | Cambio | Secciones afectadas |
|---|---|---|
| 1 | Se elimina la contradicción §25 vs Rule 25: el Product Specification termina en Part V (Validation & Acceptance); el Execution Baseline se estructura como documento independiente | §25, §25.1, §25.2, §25.3, §26–§31, Rule 25 |
| 2 | Se aclara que Prototype es **transversal al nivel de la pregunta**, no un paso posterior a LLD | §2, §3, §16, §47 |
| 3 | Se formaliza la cadena **Requirement → Concept → Model → Question → Hypothesis → Evidence → Decision → Specification** | §5, §12, §25, §36, §47 |
| 4 | Se precisa el concepto de **Baseline** con tres niveles (Engineering / Product / Execution) y se aclara que no es inmutable | §25.1, §25.3, §44 |

Además se refuerzan:
- Rules 25 y 30 (nuevas)
- Glosario ampliado
- Modelo final integrado

---

# Executive Summary

Semantic Systems Engineering is a systematic method for transforming an initial product intent, RFP, business requirement, or stakeholder need into a validated and executable system while progressively reducing uncertainty.

The method is designed to be applied **at the beginning of a project and throughout its execution**. It defines how engineering decisions are made, how technical work is decomposed, how uncertainty is reduced, how evidence is generated, and how implementation is controlled.

It is therefore a **methodological framework**, not a project-status document and not a specification of any particular implementation.

The method is based on seven principles:

1. **Meaning precedes implementation.**
2. **Engineering precedes architecture.**
3. **Uncertain technical decisions are validated through evidence rather than assumed.**
4. **Complexity is introduced progressively.**
5. **Work, responsibility, and cost are derived from the engineering definition.**
6. **Traceability, validation, uncertainty management, and change control operate across the entire lifecycle.**
7. **Implementation instantiates an engineered system rather than redefining it implicitly.**

The fundamental transformation is:

**Intent → Requirement → Concept → Model → Question → Hypothesis → Evidence → Decision → Baseline → Architecture → Execution → Implementation → Validation → Acceptance**

This is **not a waterfall process**.

It is an iterative engineering system in which evidence may cause controlled revision of decisions at the appropriate abstraction level.

The method is particularly relevant to complex systems such as BESS operational and financial modeling, where physical behavior, market conditions, forecasting, optimization, software architecture, schedule, cost, and acceptance are interdependent.

The central idea is therefore:

> **Engineering is the progressive reduction of uncertainty while preserving the semantic integrity of the system.**

---

# 1. Purpose

This document defines a systematic method for transforming a product concept, RFP, business requirement, or stakeholder need into a validated and executable technical system.

The method is intended for systems where:

- requirements may initially be incomplete or evolving;
- multiple engineering domains interact;
- mathematical or computational models are required;
- technical implementation choices are uncertain;
- prototypes are required to validate assumptions;
- implementation effort depends on unresolved technical decisions;
- acceptance requires objective evidence;
- changes must be controlled without losing traceability.

The method is intentionally defined independently of any particular project artifact.

A project applies this method to produce its own:

- engineering models;
- architecture;
- prototypes;
- specifications;
- work breakdown structures;
- organizational structures;
- cost baselines;
- execution specifications;
- implementations;
- validation evidence.

For the ENGIE BESS context, the method provides the process by which the BESS engineering and software solution can be progressively developed and validated.

---

# 2. Fundamental Principle

A complex system should not be developed by moving directly from requirements to code.

Instead:

> **The product's meaning must progressively become more precise until implementation becomes an instantiation of an already-engineered system.**

The fundamental transformation is:

```text
Product Intent
      ↓
Product Requirements
      ↓
Conceptual Engineering
   ├── Engineering Concept
   ├── Engineering Model
   └── Engineering Questions
      ↓
HLD / LLD
      ↓
Prototype(s) / Analysis
      ↓
Evidence
      ↓
Engineering Decision
      ↓
Baseline
   ├── Product Specification
   └── Execution Baseline
      ↓
Tasks
      ↓
Execution Specification
      ↓
Prompt
      ↓
Implementation
      ↓
Testing / Validation
      ↓
Acceptance
```

This chain represents increasing implementation specificity.

It does **not** imply that information flows only downward.

Evidence may propagate upward when a problem is discovered.

For example:

```text
Implementation Failure
       ↓
LLD Problem?
       ↓
Architecture Problem?
       ↓
Engineering Model Problem?
       ↓
Requirement Problem?
```

The correction must be applied at the level where the underlying meaning is incorrect.

**Note on Prototype placement.**

Prototypes are **transversal to the level of the engineering question**. They are not a fixed step in the chain; they are evidence-generating mechanisms that may operate wherever an engineering question arises.

```text
                 CONCEPTUAL ENGINEERING
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
       Engineering Model     Engineering
                            Questions
              │                     │
              └──────────┬──────────┘
                         ▼
                  Prototype / Analysis
                         │
                      Evidence
                         │
                         ▼
                 Engineering Decision
                         │
                         ▼
                    HLD / LLD
                         │
                         ▼
              Technical Prototype
                         │
                      Evidence
                         │
                         ▼
                  Architecture /
                  Design Decision
```

A prototype may therefore be used to answer a **conceptual** question (e.g., "is LP sufficient to represent basic dispatch?") before HLD/LLD are complete, or to answer an **implementation** question (e.g., "does the solver scale to the required horizon?") after LLD.

**Rule.** The transition from design to Product Specification must pass through Prototype, Evidence, and Engineering Decision. A Product Specification must never be issued directly from LLD.

---

# 3. The Engineering Lifecycle

The lifecycle consists of progressive engineering levels supported by transversal control mechanisms.

The principal lifecycle is:

```text
                    PRODUCT INTENT
                          │
                          ▼
                 PRODUCT REQUIREMENTS
                          │
                          ▼
                 CONCEPTUAL ENGINEERING
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
        ENGINEERING  ENGINEERING  ENGINEERING
          CONCEPT       MODEL      QUESTIONS
              │           │           │
              └───────────┼───────────┘
                          ▼
                  PROTOTYPE / ANALYSIS
                          │
                          ▼
                      EVIDENCE
                          │
                    ┌─────┴─────┐
                    │           │
                  PASS         FAIL
                    │           │
                    ▼           ▼
              ENGINEERING    ROOT CAUSE
               DECISION          │
                    │            ▼
                    │      CORRECTIVE ACTION
                    │            │
                    └─────◄──────┘
                    │
                    ▼
                 BASELINE
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
PRODUCT SPECIFICATION   EXECUTION BASELINE
        │                       │
        │              ┌────────┼────────┐
        │              ▼        ▼        ▼
        │             WBS      OBS      CBS
        │              │
        │              ▼
        │            TASKS
        │              │
        │              ▼
        │    EXECUTION SPECIFICATION
        │              │
        └──────────────┤
                       ▼
                     PROMPT
                       │
                       ▼
                 IMPLEMENTATION
                       │
                       ▼
                TEST / VALIDATION
                       │
                       ▼
                   ACCEPTANCE
```

Note that this figure shows a **default progression**. In practice, prototype/evidence/decision cycles may occur at multiple levels (conceptual, architectural, technical) before a baseline is declared.

Four mechanisms operate across every stage:

### 3.1 Traceability

Every important artifact and decision must have an identifiable origin and purpose.

### 3.2 Validation

Engineering claims must progressively be supported by evidence.

### 3.3 Uncertainty Management

Requirement, model, and implementation uncertainty must be identified and reduced explicitly.

### 3.4 Change and Feedback Control

Changes and failures must propagate through the appropriate abstraction level without uncontrolled redesign.

### 3.5 Engineering Decision Cycle

Every significant engineering decision follows this cycle:

```text
Requirement
     ↓
Engineering Question
     ↓
Hypothesis
     ↓
Experiment / Prototype / Analysis
     ↓
Evidence
     ↓
Engineering Decision
     ↓
Baseline
```

**Engineering Decision** is formally defined as:

> **The controlled selection, approval, or rejection of an engineering hypothesis, formulation, architecture element, or technical approach, based on defined requirements, constraints, evidence, and residual uncertainty.**

These mechanisms are not sequential phases. They are **continuous controls over the lifecycle**.

---

# 4. Level 1 — Product Intent

Product Intent defines why the system exists.

It answers three fundamental questions.

### WHAT?

What capability or product must exist?

### WHY?

What problem or opportunity does it address?

### FOR WHOM?

Who uses, evaluates, owns, or receives value from it?

For the ENGIE BESS context:

### WHAT

A system capable of modeling the operational and financial performance of BESS projects.

### WHY

To support project evaluation, business development, scenario analysis, operational assessment, and financial viability analysis.

### FOR WHOM

Stakeholders evaluating BESS projects and their operational and economic performance.

At this level:

- implementation technologies remain open;
- architectural details remain open;
- optimization techniques remain open;
- unresolved requirements are explicitly recorded.

Product Intent establishes the direction of the system without prematurely determining its implementation.

---

# 5. Level 2 — Conceptual Engineering

Conceptual Engineering transforms Product Intent into a coherent representation of the system.

It answers:

> **What must be represented, modeled, constrained, optimized, measured, and validated for the intended product to exist?**

For a BESS modeling system, the principal domains may include:

1. BESS Engineering
2. Market Engineering
3. Data/Input Engineering
4. Forecasting Engineering
5. Operational & Optimization Engineering
6. Financial Engineering
7. Validation & Benchmark Engineering

These domains are not necessarily independent modules.

They represent **engineering responsibilities and semantic domains** whose interactions must be understood before software architecture is finalized.

**Critical distinction:**

- BESS Engineering ≠ Python
- Market Engineering ≠ Databricks
- Financial Engineering ≠ SQL

The engineering domains define **what the system must represent**. The technology stack defines **how that representation is realized**. Mixing them inverts the method.

## 5.1 Engineering Concept vs Engineering Model

Conceptual Engineering produces two distinct but related artifacts:

- **Engineering Concept** — the qualitative representation of the system: what entities exist, what states they have, what relationships and constraints apply, what questions must be answered.
- **Engineering Model** — the quantitative representation: equations, variables, parameters, boundaries, and assumptions that operationalize the concept.

Example (BESS):

| Artifact | Content |
|---|---|
| Product Requirement | Model BESS operational performance. |
| Engineering Requirement | The model shall represent energy state evolution subject to physical power, energy, and efficiency constraints. |
| Engineering Concept | Represent the battery as a constrained energy-storage state system with SOC, power limits, and efficiency. |
| Engineering Model | \(SOC_{t+\Delta t} = SOC_t + \frac{\eta_c P_c \Delta t}{E_{max}} - \frac{P_d \Delta t}{\eta_d E_{max}}\) |
| Engineering Question | Is this state formulation sufficient for the intended operating envelope? |
| Engineering Decision | Use this formulation within the defined operating envelope. |

Concept and model are not interchangeable. Concept without model remains ambiguous; model without concept lacks semantic grounding.

## 5.2 Formal chain from Requirement to Specification

The methodology establishes the following formal chain:

```text
Stakeholder Requirement
        ↓
Product Requirement
        ↓
Engineering Requirement
        ↓
Engineering Concept
        ↓
Engineering Model
        ↓
Engineering Question
        ↓
Hypothesis
        ↓
Prototype / Analysis
        ↓
Evidence
        ↓
Engineering Decision
        ↓
Specification
```

Each step introduces a **different type of statement**:

| Step | Nature |
|---|---|
| Stakeholder Requirement | Needs, expectations, constraints |
| Product Requirement | What the product must do |
| Engineering Requirement | What the model must represent |
| Engineering Concept | Qualitative representation |
| Engineering Model | Quantitative formulation |
| Engineering Question | Precise, answerable uncertainty |
| Hypothesis | Proposed answer |
| Prototype / Analysis | Evidence-generating mechanism |
| Evidence | Objective result |
| Engineering Decision | Controlled selection |
| Specification | Validated, stable statement |

This chain is the backbone of traceability.

---

# 6. BESS Engineering

BESS Engineering defines the physical capabilities, states, limitations, and behavior of the energy storage asset.

It may include:

- battery cells, modules, racks, and strings;
- DC system;
- PCS/inverter;
- AC system;
- grid interface;
- site load;
- energy capacity;
- power capacity;
- SOC;
- SOH;
- charging and discharging efficiency;
- ramp limitations;
- thermal behavior;
- degradation;
- operating limits;
- availability and derating.

The fundamental question is:

> **What can the physical BESS actually do under the applicable operating conditions?**

The physical model establishes the constraints within which all subsequent operational decisions must remain feasible.

---

# 7. Market Engineering

Market Engineering defines the environment in which the BESS can create or preserve economic value.

It may include:

- energy markets;
- day-ahead prices;
- real-time prices;
- ancillary services;
- frequency regulation;
- capacity markets;
- demand response;
- tariffs;
- demand charges;
- eligibility requirements;
- participation rules;
- settlement rules;
- market constraints;
- market timing and sequencing.

The fundamental question is:

> **Under what market conditions and rules can the BESS create value?**

Market Engineering must remain distinct from BESS Engineering because physical capability and market opportunity are different concepts.

A physically feasible action is not necessarily a market-eligible action.

---

# 8. Data/Input Engineering

Data/Input Engineering defines the information required by the engineering system to represent reality.

For each input, the model should establish:

- semantic meaning;
- source;
- unit;
- temporal resolution;
- timestamp convention;
- historical or forecast status;
- quality requirements;
- validation rules;
- missing-data behavior;
- uncertainty characteristics.

This is not yet an ETL or data-platform architecture.

Its purpose is to define:

> **What information does the engineering system require, what does that information mean, and what quality must it satisfy?**

Implementation of ingestion, transformation, storage, and processing belongs to subsequent architectural and software stages.

---

# 9. Forecasting Engineering

Forecasting is explicitly separated from general Data Engineering because forecasts influence operational decisions.

Potential forecasts include:

- load;
- market prices;
- PV production;
- ancillary-service prices;
- market availability;
- other operational variables.

A basic representation is:

$$
X_t = \hat{X}_t + \epsilon_t
$$

where:

- \(X_t\) is the realized value;
- \(\hat{X}_t\) is the forecast;
- \(\epsilon_t\) is the forecast error.

The engineering model must determine whether forecast uncertainty requires:

- deterministic forecasts;
- sensitivity analysis;
- scenario-based forecasts;
- stochastic optimization;
- robust optimization;
- probabilistic modeling.

The forecasting algorithm itself should not be frozen until project requirements and evidence justify the choice.

---

# 10. Operational and Optimization Engineering

Operational Engineering is the principal convergence domain of the physical, market, forecasting, service, and degradation models.

```text
BESS Physics ─────────────┐
                          │
Market Conditions ────────┤
                          │
Load / Forecasts ─────────┤
                          ▼
                   DISPATCH ENGINE
                          ▲
                          │
Service Requirements ─────┤
                          │
Operating Strategy ────────┤
                          │
Degradation ──────────────┘
```

The Dispatch Engine determines how available BESS capability should be allocated across competing operational opportunities.

Dispatch is therefore a **convergence point**, not merely a downstream module.

The dispatch problem may involve:

- energy arbitrage;
- peak shaving;
- demand response;
- frequency regulation;
- voltage/reactive power services;
- reserve allocation;
- operational constraints;
- degradation;
- market opportunities.

The operational model must define the decision problem before an optimization technique is selected.

---

# 11. Financial Engineering

Financial Engineering translates validated operational behavior into economic consequences.

Operational outputs may include:

- charging energy;
- discharging energy;
- peak reduction;
- demand-response performance;
- ancillary-service participation;
- market settlements;
- degradation;
- replacement requirements.

Financial outputs may include:

- revenue by stream;
- savings;
- O&M;
- degradation cost;
- replacement cost;
- NPV;
- IRR;
- payback.

The fundamental boundary is:

> **Operational Engineering determines what the asset does; Financial Engineering determines the economic consequence of what it does.**

Financial assumptions must not silently alter the physical behavior of the BESS.

---

# 12. Uncertainty Management

The method distinguishes three principal categories of uncertainty.

## 12.1 Requirement Uncertainty

Uncertainty regarding what the stakeholder actually requires.

Reduced through:

**Requirements Validation → Conceptual Engineering → Stakeholder Review**

Examples include:

- ambiguous requirements;
- missing acceptance criteria;
- conflicting stakeholder expectations;
- unclear scope.

## 12.2 Model Uncertainty

Uncertainty regarding whether the engineering representation adequately represents the real system.

Reduced through:

**Engineering Analysis → Prototype → Benchmark → Backtesting → Validation**

Examples include:

- uncertain degradation behavior;
- uncertain service constraints;
- uncertain market representation;
- uncertain mathematical formulation.

## 12.3 Implementation Uncertainty

Uncertainty regarding whether the selected architecture and implementation can adequately realize the engineered system.

Reduced through:

**HLD → LLD → Technical Prototype → Performance Testing**

Examples include:

- computational scalability;
- solver performance;
- data-processing limitations;
- architectural bottlenecks.

**Note.** Requirement, model, and implementation uncertainty are distinct. A failure must first be classified before corrective action. A solver timing problem does not invalidate the physical model; a stakeholder change does not invalidate the software architecture.

---

# 13. High-Level Design — HLD

Once conceptual engineering reaches sufficient maturity, it can be transformed into a system architecture.

A representative architecture for a BESS modeling platform may be:

```text
                INPUT / DATA LAYER
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
        BESS          MARKET       FORECASTING
       ENGINE         ENGINE         ENGINE
          │             │             │
          └─────────────┼─────────────┘
                        ▼
                SCENARIO / STATE
                    MANAGEMENT
                        │
                        ▼
              DISPATCH / OPTIMIZATION
                        │
                        ▼
                REVENUE / SETTLEMENT
                        │
                        ▼
                  FINANCIAL ENGINE
                        │
                        ▼
              REPORTING / APPLICATION
```

Validation and benchmarking operate across the architecture.

HLD defines:

- major components;
- responsibilities;
- interfaces;
- dependencies;
- major data flows;
- architectural boundaries.

HLD should avoid unnecessary implementation detail.

---

# 14. Low-Level Design — LLD

LLD transforms architectural components into implementable mechanisms.

For an optimization engine, LLD may include:

- state management;
- SOC state;
- SOH state;
- available-energy calculation;
- available-power calculation;
- constraint construction;
- market opportunity construction;
- service allocation;
- reserve/headroom calculation;
- objective function;
- degradation cost;
- optimization formulation;
- solver interface;
- rolling-horizon controller;
- infeasibility handling;
- result validation.

LLD is the level at which implementation uncertainty becomes explicit.

A technical decision should not be promoted to a fixed implementation requirement merely because it appears in an early design document.

---

# 15. Technique Selection Protocol

The methodology does not assume a final optimization technique in advance.

Candidate techniques may include:

- heuristic methods;
- LP;
- MILP;
- MISOCP;
- nonlinear optimization;
- MPC;
- stochastic optimization;
- robust optimization;
- hybrid methods.

The correct question is not:

> "Which technique is normally used for this type of problem?"

It is:

> **What is the simplest technique that satisfies the validated engineering requirements?**

Technique selection therefore follows engineering evidence.

---

# 16. Prototypes — Evidence-Generating Mechanisms

Prototypes are **transversal to the level of the engineering question**. They are deliberately limited implementations, formulations, or analyses used to answer a specific engineering question.

## 16.1 Prototype classes

| Class | Purpose | Typical level |
|---|---|---|
| Engineering Prototype | Validate a concept, model, or formulation | Conceptual Engineering |
| Technical Prototype | Validate an architecture or mechanism | HLD / LLD |
| Performance Prototype | Validate scalability, runtime, resources | LLD / Implementation |

A prototype may be used at **any level** where an engineering question arises. The class of the prototype should match the class of the question.

## 16.2 Prototype 0 — Minimum Viable Formulation

The first prototype should minimize unnecessary complexity.

For many BESS dispatch problems, a suitable initial formulation may be:

### Simplified Deterministic LP

with:

- short horizon;
- continuous charge/discharge variables;
- SOC constraints;
- energy limits;
- power limits;
- basic efficiency;
- simplified revenue representation;
- deterministic inputs;
- no unnecessary binary variables.

Prototype 0 is not intended to be production software.

Its purpose is to answer:

> **Does the fundamental physical and operational logic behave correctly?**

The prototype should therefore prioritize **semantic validation over optimization sophistication**.

---

# 17. Progressive Technique Complexity

Complexity should increase only when evidence justifies it.

A possible progression is:

```text
Prototype 0
Simplified LP
      ↓
Prototype 1
Detailed physical constraints
      ↓
Prototype 2
MILP for genuinely discrete decisions
      ↓
Prototype 3
Rolling Horizon / MPC
      ↓
Prototype 4
Scenario / Stochastic / Robust formulation
      ↓
Prototype 5
Production-scale formulation
```

This sequence is a default strategy rather than a mandatory path.

A project may skip, reorder, or combine stages when evidence demonstrates that doing so is appropriate.

The governing principle is:

> **Complexity must be introduced to solve an identified engineering problem, not to demonstrate mathematical sophistication.**

---

# 18. Technique Evaluation Matrix

Technique selection must distinguish between **hard constraints** and **weighted criteria**.

## 18.1 Hard Constraints

A candidate technique must satisfy mandatory requirements.

Examples include:

- physical feasibility;
- numerical reliability;
- maximum acceptable runtime;
- required solution availability;
- required temporal resolution;
- required scalability.

A technique failing a mandatory constraint is rejected regardless of its performance elsewhere.

## 18.2 Weighted Criteria

Among techniques satisfying all hard constraints, candidates may be evaluated against weighted criteria.

Example:

| Criterion                 | Example Weight |
| ------------------------- | -------------: |
| Solution quality          |            20% |
| Scalability               |            20% |
| Extensibility             |            15% |
| Robustness                |            15% |
| Interpretability          |            10% |
| Maintainability           |            10% |
| Implementation complexity |            10% |

The exact weights must be defined according to project requirements.

The general decision rule is:

$$
Score_j = \sum_i w_i s_{ij}
$$

where:

- \(w_i\) = weight of criterion \(i\);
- \(s_{ij}\) = score of technique \(j\) against criterion \(i\).

Subject to:

$$
HardConstraint_k(j)=PASS
$$

for every mandatory constraint \(k\).

Therefore:

> **Hard constraints eliminate unacceptable techniques; weighted criteria distinguish among technically acceptable alternatives.**

---

# 19. Tie-Breaking Rule

If two candidate techniques remain materially equivalent after evaluation, use the following tie-breaking order:

1. lower computational complexity;
2. lower implementation complexity;
3. greater extensibility;
4. greater interpretability.

The principle is:

> **When two solutions satisfy the requirements equivalently, prefer the simpler one.**

Mathematical sophistication is not itself an engineering objective.

---

# 20. Validation and Benchmark Engineering

Validation is a continuous engineering function.

It may include:

- physical validation;
- mathematical validation;
- market validation;
- benchmark testing;
- historical backtesting;
- performance testing;
- regression testing;
- integration testing;
- UAT;
- acceptance testing.

Validation answers the question:

> **Does the implemented or proposed system behave consistently with the intended engineering model and requirements?**

Validation is therefore not merely a final QA activity.

---

# 21. Historical Backtesting

Market-facing systems should use historical validation when appropriate historical data and settlement rules are available.

The general loop is:

```text
Historical Data
      ↓
Historical / Reconstructed Inputs
      ↓
Forecast / Scenario Representation
      ↓
Dispatch Model
      ↓
Simulated Dispatch
      ↓
Historical Settlement Logic
      ↓
Performance Metrics
      ↓
Benchmark Comparison
```

Backtesting should evaluate more than historical revenue maximization.

It should also examine:

- physical feasibility;
- constraint compliance;
- operational behavior;
- service performance;
- sensitivity to forecast error;
- stability;
- degradation implications;
- computational behavior.

---

# 22. Decision Gates

The project progresses through explicit decision gates.

## Gate 1 — Concept Freeze

Required evidence:

- product intent defined;
- system boundary defined;
- stakeholders identified;
- major objectives identified;
- major unresolved requirements recorded.

## Gate 2 — Engineering Baseline

Required evidence:

- engineering domains defined;
- interfaces identified;
- major constraints identified;
- inputs identified;
- outputs identified;
- principal assumptions documented.

## Gate 3 — Architecture Baseline

Required evidence:

- HLD coherent;
- interfaces defined;
- dependencies understood;
- architectural boundaries established;
- major implementation risks identified.

## Gate 4 — Prototype Validation

Required evidence:

- core physical behavior validated;
- core operational behavior validated;
- critical assumptions tested;
- prototype results reproducible;
- known limitations documented.

Gate 4 may be fed by prototypes at any level: conceptual, architectural, or performance.

## Gate 5 — Technique Selection

Required evidence:

- relevant candidate techniques considered;
- sufficient prototype evidence generated;
- hard constraints evaluated;
- weighted criteria evaluated where applicable;
- selected technique documented;
- alternatives and rationale recorded.

## Gate 6 — Product Baseline

Required evidence:

- requirements sufficiently stable;
- acceptance criteria defined;
- validation methods defined;
- interfaces documented;
- major residual risks identified.

## Gate 7 — Execution Baseline

Required evidence:

- WBS defined;
- required competencies identified;
- responsibilities established;
- OBS established;
- CBS estimated;
- remaining uncertainty documented;
- execution dependencies identified.

A gate does not imply that the system is permanently frozen.

It means that the system has reached **sufficient evidence-based maturity to proceed to the next level**.

---

# 23. Gate Failure and Escalation Protocol

A failed gate must not automatically trigger unlimited iteration.

The process is:

```text
Gate Failure
     ↓
Observed Failure
     ↓
Root Cause
     ↓
Affected Abstraction
     ↓
Impact Assessment
     ↓
Response Classification
     ↓
┌──────────────┬──────────────┬───────────────┐
│ Re-engineer  │ Reduce Scope │ Escalate      │
│              │              │ Decision       │
└──────────────┴──────────────┴───────────────┘
     ↓
Re-plan
     ↓
Re-test
     ↓
Gate Re-evaluation
```

### Re-engineer

Used when the required capability remains feasible but the current engineering solution is inadequate.

### Reduce Scope

Used when the capability cannot reasonably be achieved within available project constraints without unacceptable risk.

### Escalate Decision

Used when the issue requires a stakeholder or project-level trade-off.

The objective is controlled convergence rather than indefinite experimentation.

---

# 24. Iteration Budget

Every uncertain engineering activity should have an explicit iteration budget.

The budget may define:

- maximum number of prototype iterations;
- maximum investigation time;
- maximum computational experimentation;
- maximum engineering effort;
- decision deadline.

For example:

```text
Technical Question
      ↓
Investigation Budget
      ↓
Prototype / Experiment
      ↓
Evidence
      ↓
Decision
```

If the budget is exhausted without convergence, the issue becomes a **project-level decision**.

This is particularly important for fixed-duration engagements.

The governing principle is:

> **Engineering iteration must be bounded by project constraints.**

---

# 25. Product Specification

Once engineering decisions are sufficiently stable, they are transformed into Product Specifications.

Each requirement should contain:

1. Requirement
2. Rationale
3. Inputs
4. Expected behavior
5. Outputs
6. Acceptance criterion
7. Validation method
8. Traceability reference

Example:

### Requirement

The system shall calculate BESS SOC over the simulation horizon.

### Rationale

SOC determines available energy and operational feasibility.

### Inputs

- initial SOC;
- charging power;
- discharging power;
- timestep;
- charging efficiency;
- discharging efficiency.

### Behavior

SOC shall evolve according to the approved energy-balance model.

### Output

SOC time series.

### Acceptance Criterion

SOC shall remain within defined operational limits for all valid test scenarios.

### Validation

Engineering benchmark and automated test cases.

The Product Specification should represent a validated engineering decision, not an untested assumption.

## 25.1 Baseline model

The methodology distinguishes three baselines, each with its own scope:

```text
ENGINEERING BASELINE
        │
        ├── Product Baseline
        │       └── Product Specification
        │
        └── Execution Baseline
                ├── WBS
                ├── Competency Decomposition
                ├── OBS
                ├── CBS
                ├── Schedule
                ├── Tasks
                └── Execution Specifications
```

Definitions:

- **Engineering Baseline** — the overall stable, evidence-supported state of the engineering work.
- **Product Baseline** — the stable state of the product specification.
- **Execution Baseline** — the stable state of the work, organizational, and cost structure.

**Baseline ≠ immutable.** A baseline is a controlled reference. It changes only through change control.

## 25.2 Product Specification structure (integrated)

```text
PRODUCT SPECIFICATION
ENGIE BESS OPERATIONAL & FINANCIAL MODELING PLATFORM

PART I — PRODUCT DEFINITION                       [definición]
    1. Product Purpose
    2. Scope
    3. Users / Stakeholders
    4. System Boundary
    5. Product Capabilities
    6. Success Criteria

PART II — ENGINEERING SPECIFICATION               [requisitos]
    7. BESS Engineering
    8. Market Engineering
    9. Data / Input Engineering
   10. Forecasting Engineering
   11. Operational Engineering
   12. Optimization Engineering
   13. Financial Engineering
   14. Validation & Benchmark Engineering

PART III — SYSTEM ARCHITECTURE                    [derivado]
   15. HLD
   16. LLD
   17. Interfaces
   18. Data flows
   19. Computational architecture

PART IV — TECHNOLOGY SPECIFICATION
   20. Technology Constraints                     [impuesto]
   21. Technology Decisions                       [elegido con evidencia]
   22. Technology Validation

PART V — VALIDATION & ACCEPTANCE                  [requisitos]
   23. Acceptance Criteria
   24. Test Strategy
   25. Engineering Validation
   26. Backtesting
   27. UAT
   28. Traceability
```

**Note.** The Product Specification ends at Part V. WBS, OBS, CBS, schedule, tasks, and execution specifications belong to the **Execution Baseline**, defined below as a separate document.

## 25.3 Execution Baseline structure

```text
EXECUTION BASELINE
ENGIE BESS OPERATIONAL & FINANCIAL MODELING PLATFORM

PART I — PRODUCT CAPABILITY BREAKDOWN             [derivado]
    1. Capability map
    2. Capability-to-requirement traceability

PART II — WBS                                     [derivado]
    3. Work breakdown structure

PART III — COMPETENCY DECOMPOSITION               [derivado]
    4. Required competencies by WBS element

PART IV — OBS                                     [derivado]
    5. Organizational breakdown structure

PART V — CBS                                      [derivado]
    6. Cost breakdown structure

PART VI — DEPENDENCIES                            [derivado]
    7. Task and resource dependencies

PART VII — SCHEDULE                               [derivado]
    8. Timeline and milestones

PART VIII — TASKS                                 [derivado]
    9. Task specifications

PART IX — EXECUTION SPECIFICATIONS                [derivado]
   10. Execution specifications
```

**Nature of the Execution Baseline:**

- It is **derived** from the Product Specification.
- It may change for management reasons without changing the product.
- It is **traceable** to the Product Specification, not the other way around.

## 25.4 Relationship between Product Specification and Execution Baseline

```text
PRODUCT SPECIFICATION
        │
        ▼
Engineering Definition  [Part II]
        │
        ▼
EXECUTION BASELINE
        │
        ├── WBS            "What work?"
        ├── Competencies   "What expertise?"
        ├── OBS            "Who is responsible?"
        ├── CBS            "What does it cost?"
        └── Schedule
```

The WBS is **derived from the engineered product**, not from an arbitrary organizational structure.

The OBS is **derived from the competencies required by the WBS**, not from predefined titles.

The CBS is **derived from work and resources**, progressively refined by technical evidence.

---

# 26. WBS — Work Breakdown Structure

The WBS decomposes the product into the work required to create and validate it. It belongs to the **Execution Baseline**.

For example:

```text
BESS Modeling Product
│
├── Engineering
│   ├── BESS Model
│   ├── Market Model
│   ├── Forecast Model
│   ├── Dispatch Model
│   ├── Degradation Model
│   └── Financial Model
│
├── Data
│   ├── Input Specification
│   ├── Validation
│   └── Transformation
│
├── Software
│   ├── Modeling Engine
│   ├── Optimization Engine
│   ├── Application
│   └── Reporting
│
└── Validation
    ├── Benchmarks
    ├── Backtesting
    ├── Integration Testing
    └── UAT
```

WBS answers:

> **What work must be performed?**

The WBS should be derived from the engineered product rather than from an arbitrary organizational structure.

---

# 27. Competency Decomposition

Before assigning people or organizational units, the required competencies should be derived from the work.

The sequence is:

**WBS Element → Required Competencies → Responsibilities → Resources → OBS**

Example:

### WBS Element

**Dispatch Optimization Engine**

### Required Competencies

- BESS operational modeling;
- mathematical optimization;
- energy-market modeling;
- Python;
- numerical methods;
- testing and validation.

### Responsibilities

- formulate dispatch problem;
- define objective function;
- define constraints;
- prototype candidate techniques;
- validate dispatch behavior;
- document optimization decisions.

### Resource Type

BESS / optimization engineering specialist.

This prevents organizational structure from driving technical decomposition.

---

# 28. OBS — Organizational Breakdown Structure

OBS maps required responsibilities to actual resources. It belongs to the **Execution Baseline**.

For example:

```text
Dispatch Optimization
│
├── BESS Engineering Responsibility
├── Optimization Responsibility
├── Market Engineering Responsibility
├── Software Implementation Responsibility
└── Validation Responsibility
```

These responsibilities may belong to:

- one individual;
- multiple specialists;
- one multidisciplinary team.

The OBS should therefore emerge from engineering responsibilities rather than predefined organizational titles.

---

# 29. CBS — Cost Breakdown Structure

CBS translates work and resource requirements into cost. It belongs to the **Execution Baseline**.

Conceptually:

$$
Cost_i = Effort_i \times Rate_i + Contingency_i
$$

However, effort may be uncertain.

Therefore:

$$
Effort_i = E_{base} + E_{uncertainty}
$$

For example, before prototyping a dispatch engine:

- formulation complexity may be uncertain;
- solver selection may be uncertain;
- scalability may be uncertain;
- integration effort may be uncertain.

After prototype evidence:

- formulation complexity becomes better understood;
- technique selection becomes evidence-based;
- scalability uncertainty decreases;
- effort estimates become more reliable.

---

# 30. Progressive CBS

CBS should therefore evolve with engineering evidence.

```text
Initial Engineering Estimate
             ↓
       Initial WBS / CBS
             ↓
          Prototype
             ↓
      Technical Evidence
             ↓
     Uncertainty Reduction
             ↓
      Revised Estimate
             ↓
       Cost Baseline
```

This establishes the principle:

> **Technical evidence progressively increases confidence in cost estimation.**

CBS may therefore be refined rather than treated as a single irreversible estimate.

---

# 31. Tasks

Each WBS element is decomposed into executable tasks.

A task should define:

- objective;
- scope;
- inputs;
- prerequisites;
- engineering references;
- expected output;
- acceptance criterion;
- validation method;
- dependencies;
- required competency;
- estimated effort;
- applicable constraints.

A task should **not require the executor to rediscover the engineering model**.

A well-defined task transforms an already-engineered requirement into a bounded unit of work.

---

# 32. Execution Specification

The Execution Specification is the formal bridge between engineering definition and execution.

It combines:

**Requirement + Engineering Model + LLD + Task**

into a precise execution instruction.

An Execution Specification should define:

1. **Context**
2. **Objective**
3. **Scope**
4. **Inputs**
5. **Prerequisites**
6. **Engineering constraints**
7. **Interfaces**
8. **Assumptions**
9. **Expected artifact**
10. **Acceptance criteria**
11. **Validation procedure**
12. **Dependencies**
13. **Out-of-scope items**

The Execution Specification should be sufficiently precise that the executor can perform the task without inventing missing architecture or requirements.

---

# 33. Prompt as Execution Interface

A prompt is an execution interface.

It is **not** the engineering specification.

The relationship is:

```text
Engineering Definition
        ↓
       Task
        ↓
Execution Specification
        ↓
      Prompt
        ↓
Execution Agent
        ↓
     Artifact
        ↓
      Test
        ↓
   Validation
```

The prompt should communicate the already-defined execution specification to the execution agent.

A prompt may specify:

- required context;
- referenced artifacts;
- exact task;
- constraints;
- expected output;
- acceptance criteria;
- validation requirements;
- prohibited scope expansion.

The agent should not be expected to determine fundamental architecture unless that task is explicitly assigned as an engineering activity.

If an execution agent repeatedly needs to invent:

- requirements;
- interfaces;
- data structures;
- architecture;
- engineering assumptions;

this is evidence that the upstream definition is incomplete.

Therefore:

> **Prompt quality is downstream evidence of upstream engineering completeness.**

---

# 34. Implementation

Implementation instantiates the validated design.

Possible implementation technologies include:

- Python;
- PySpark;
- SQL;
- optimization models;
- Databricks;
- APIs;
- dashboards;
- reporting systems.

Implementation should not silently redefine:

- physical assumptions;
- engineering constraints;
- interfaces;
- requirements;
- optimization objectives.

If implementation reveals a fundamental design problem, the issue must be returned to the appropriate engineering abstraction level.

**The technology stack is a constraint or a decision, not an engineering domain.** It belongs in Part IV of the Product Specification, not in Part II.

---

# 35. Testing and Validation

Testing occurs at multiple levels.

## Unit Testing

Tests individual software components.

## Integration Testing

Tests interactions between components.

## Engineering Validation

Tests implementation against approved engineering equations, constraints, and behaviors.

## Benchmark Testing

Tests against defined reference cases.

## Backtesting

Tests behavior against historical conditions where appropriate.

## Performance Testing

Tests runtime, scalability, resource consumption, and stability.

## User Acceptance Testing

Tests whether stakeholder requirements have been satisfied.

These activities answer different questions and should not be collapsed into a generic "testing" stage.

---

# 36. Integrated Traceability

A single integrated traceability chain should connect intent to implementation and acceptance.

```text
RFP / Stakeholder Intent
          ↓
Stakeholder Requirement
          ↓
Product Requirement
          ↓
Engineering Requirement
          ↓
Engineering Concept
          ↓
Engineering Model
          ↓
Engineering Question
          ↓
Hypothesis
          ↓
Prototype / Analysis
          ↓
Evidence
          ↓
Engineering Decision
          ↓
Baseline
   ├── Product Specification
   └── Execution Baseline
          ↓
WBS / Task
          ↓
Execution Specification
          ↓
Prompt
          ↓
Implementation
          ↓
Test Case
          ↓
Validation Evidence
          ↓
Acceptance
```

Traceability must operate in both directions.

Forward:

> **Why was this artifact created?**

Backward:

> **What implementation artifacts demonstrate that this requirement has been satisfied?**

Given an implementation artifact, the team should be able to trace it back to its originating requirement.

Given a requirement, the team should be able to identify the evidence demonstrating satisfaction.

---

# 37. Change Control

Requirements and engineering assumptions may change during the project.

A change must therefore be treated as an engineering event rather than an informal edit.

The change process is:

```text
Change Request
      ↓
Change Classification
      ↓
Affected Requirements
      ↓
Affected Engineering Model
      ↓
Affected Architecture
      ↓
Affected Tasks / Cost / Schedule
      ↓
Impact Assessment
      ↓
Decision
      ↓
Controlled Revision
      ↓
Re-validation
      ↓
Traceability Update
```

A change should be classified according to its affected abstraction level.

Examples include:

- requirement change;
- scope change;
- engineering-model change;
- architecture change;
- implementation change.

The change assessment should consider:

- technical impact;
- validation impact;
- schedule impact;
- cost impact;
- dependencies;
- residual risk.

No significant requirement or engineering change should be incorporated without determining its downstream impact.

**Note.** A change in the Execution Baseline (WBS, OBS, CBS, schedule) does not necessarily imply a change in the Product Specification.

---

# 38. Feedback and Root-Cause Analysis

When validation fails:

```text
Failure
  ↓
Observed Behavior
  ↓
Root Cause
  ↓
Affected Abstraction
  ↓
Corrective Action
  ↓
Re-validation
```

Potential affected levels include:

- Product Intent;
- Requirement;
- Conceptual Engineering;
- HLD;
- LLD;
- Product Specification;
- Task;
- Execution Specification;
- Implementation.

The governing principle is:

> **Fix the problem at the level where its meaning is wrong, not merely at the level where the symptom appears.**

This creates nested feedback loops rather than one generic feedback loop.

---

# 39. Semantic Stability

A technical decision should not be considered stable merely because it has been documented.

For example:

### Hypothesis

> MILP will be used for dispatch.

This is an assumption.

After sufficient evidence:

> MILP satisfies the defined feasibility, solution-quality, runtime, scalability, and extensibility requirements for the required dispatch use cases.

This is an engineering decision.

Therefore:

> **A decision becomes semantically stable when sufficient evidence supports its validity within the defined scope and assumptions.**

Semantic stability does not mean permanent immutability.

A previously stable decision may be revised when requirements or evidence change.

---

# 40. Decision Evidence

Major technical decisions should have a minimal decision record containing:

- decision;
- alternatives considered;
- evaluation criteria;
- evidence;
- assumptions;
- constraints;
- rationale;
- selected option;
- residual risks;
- validation status;
- date/version.

Additionally, a decision record should state:

- the **engineering question** it answers;
- the **hypothesis** that was tested;
- the **prototype or analysis** used;
- the **level** at which the decision applies (concept, model, architecture, mechanism, implementation).

This prevents the project from losing the reasoning behind architectural and technical choices.

Decision records should preserve **why** a decision was made, not merely **what** was selected.

---

# 41. Repository and External Implementation Review

External implementations, open-source repositories, literature, benchmarks, and reference systems may be used as **engineering evidence**.

They should not automatically determine the architecture or technical solution.

For example, in a BESS project, existing repositories may provide evidence regarding:

- physical modeling;
- degradation;
- dispatch;
- revenue stacking;
- forecasting;
- market sequencing;
- optimization techniques;
- testing;
- backtesting.

The correct process is:

```text
Engineering Question
        ↓
Reference / External Evidence
        ↓
Comparison with Current Model
        ↓
Gap Identification
        ↓
Engineering Assessment
        ↓
Decision
        ↓
Prototype / Validation
```

External implementation is therefore **evidence, not authority**.

The fact that a particular repository uses MILP, MPC, Pyomo, or another technique does not establish that the same technique is correct for the target system.

---

# 42. Evidence Review Criteria

A repository or external reference should be evaluated according to at least five dimensions:

### Breadth

How many relevant engineering domains are covered?

### Depth

How deeply is each domain modeled?

### Evidence

What has actually been implemented, tested, benchmarked, or validated?

### Architecture

How are the components and domains related?

### Traceability

Can assumptions, decisions, and implementation choices be connected to identifiable requirements or engineering objectives?

Additional criteria may include:

- reproducibility;
- documentation quality;
- test coverage;
- model transparency;
- applicability to the target system;
- known limitations.

External references should be used to reduce **model or implementation uncertainty**, not to bypass engineering decisions.

---

# 43. Engineering Review Sufficiency

External-reference review must have a defined stopping condition.

A review is sufficient when:

1. the relevant engineering domains have been examined;
2. major alternative formulations have been identified;
3. important gaps and contradictions have been recorded;
4. relevant implementation evidence has been assessed;
5. unresolved questions have been converted into explicit engineering questions;
6. decisions required for the next prototype or design stage have sufficient evidence.

The review should also have an explicit investigation budget, such as:

- maximum number of references;
- maximum investigation time;
- maximum experimentation effort;
- predefined decision deadline.

The objective is not to find every existing implementation.

It is to obtain **sufficient evidence for the next engineering decision**.

---

# 44. Glossary

### Product Intent

The initial definition of what the product must accomplish, why it exists, and for whom.

### Conceptual Engineering

The process of determining what must be represented and how the system behaves conceptually before implementation architecture is fixed.

### Engineering Concept

The qualitative representation of the system: entities, states, relationships, and constraints, prior to their quantitative formulation.

### Engineering Model

The quantitative representation of the system: variables, parameters, equations, boundaries, and assumptions that operationalize the engineering concept.

### Engineering Question

A precise, answerable question derived from a requirement or from conceptual engineering, whose resolution reduces uncertainty.

### Engineering Decision

The controlled selection, approval, or rejection of an engineering hypothesis, formulation, architecture element, or technical approach, based on defined requirements, constraints, evidence, and residual uncertainty.

### Baseline

A stable, evidence-supported state of an engineering artifact that serves as a controlled reference for subsequent work. A baseline changes only through change control. Three baselines are distinguished:

- **Engineering Baseline** — the overall stable state of the engineering work.
- **Product Baseline** — the stable state of the Product Specification.
- **Execution Baseline** — the stable state of the work, organizational, and cost structure.

### HLD — High-Level Design

The architectural representation of major system components, responsibilities, interfaces, and dependencies.

### LLD — Low-Level Design

The detailed design of implementable mechanisms within architectural components.

### Prototype

A deliberately limited implementation or formulation used to answer a specific engineering question. May operate at conceptual, architectural, or implementational level.

### Validation

Evidence-based evaluation that the model or implementation satisfies its intended behavior and requirements.

### Benchmark

A defined reference case used to compare model or implementation behavior.

### Backtesting

Evaluation of a model against historical conditions.

### Product Specification

The integrated specification of the product. Includes:

- Part I — Product Definition
- Part II — Engineering Specification
- Part III — System Architecture
- Part IV — Technology Specification
- Part V — Validation & Acceptance

### Execution Baseline

The organizational, work, and cost baseline derived from the Product Specification. Includes:

- Part I — Product Capability Breakdown
- Part II — WBS
- Part III — Competency Decomposition
- Part IV — OBS
- Part V — CBS
- Part VI — Dependencies
- Part VII — Schedule
- Part VIII — Tasks
- Part IX — Execution Specifications

### WBS — Work Breakdown Structure

Decomposition of the work required to create the system. Derived from the Product Specification.

### OBS — Organizational Breakdown Structure

Mapping of responsibilities and work to organizational resources. Derived from the competencies required by the WBS.

### CBS — Cost Breakdown Structure

Decomposition and estimation of project cost. Derived from work and resources, progressively refined by technical evidence.

### Execution Specification

A precise definition of how a task is to be executed and validated.

### Prompt

An execution interface that communicates an Execution Specification to an execution agent. Not an engineering specification.

### Semantic Stability

The state in which a decision is sufficiently supported by evidence to serve as a reliable engineering baseline within its defined scope.

### Engineering Evidence

Information, analysis, experiment, prototype result, benchmark, test, or other objective basis used to support an engineering decision.

---

# 45. Application to the ENGIE BESS System

When applied to the ENGIE BESS context, the methodology becomes:

```text
ENGIE RFP
   ↓
Product Intent
   ↓
Product Requirements
   ↓
Conceptual Engineering
   ├── BESS Engineering
   ├── Market Engineering
   ├── Data/Input Engineering
   ├── Forecasting Engineering
   ├── Operational & Optimization Engineering
   ├── Financial Engineering
   └── Validation / Benchmark Engineering
   ↓
Engineering Concept
   ↓
Engineering Model
   ↓
Engineering Questions
   ↓
HLD
   ↓
LLD
   ↓
External Evidence / Repository Review
   ↓
Prototype / Analysis
   ↓
Benchmark / Backtest
   ↓
Evidence
   ↓
Engineering Decision
   ↓
Baseline
   ├── Product Specification
   │      ├── Part I   Product Definition
   │      ├── Part II  Engineering Specification
   │      ├── Part III System Architecture
   │      ├── Part IV  Technology Specification
   │      └── Part V   Validation & Acceptance
   │
   └── Execution Baseline
          ├── Part I    Product Capability Breakdown
          ├── Part II   WBS
          ├── Part III  Competency Decomposition
          ├── Part IV   OBS
          ├── Part V    CBS
          ├── Part VI   Dependencies
          ├── Part VII  Schedule
          ├── Part VIII Tasks
          └── Part IX   Execution Specifications
   ↓
Prompts
   ↓
Implementation
   ↓
Testing / UAT
   ↓
Acceptance
```

The optimization engine is deliberately treated as an **engineering decision point** rather than a predetermined implementation detail.

Likewise, external repositories are treated as **evidence sources**, not architecture templates.

The engineering model determines what the system must represent.

Evidence helps determine how that representation should be implemented.

The technology stack (Python, PySpark, SQL, Databricks, etc.) is treated as a **constraint or decision**, not as an engineering domain, and is placed in Part IV of the Product Specification.

---

# 46. Core Engineering Rules

### Rule 1

**Define meaning before implementation.**

### Rule 2

**Engineering precedes architecture.**

### Rule 3

**Architecture precedes detailed implementation.**

### Rule 4

**Do not freeze uncertain techniques prematurely.**

### Rule 5

**Prototype the minimum necessary formulation.**

### Rule 6

**Increase complexity only when evidence justifies it.**

### Rule 7

**Use hard constraints before weighted optimization criteria.**

### Rule 8

**Prefer simpler solutions when alternatives satisfy requirements equivalently.**

### Rule 9

**Validation is an engineering activity, not merely final QA.**

### Rule 10

**Backtest market-facing models where appropriate.**

### Rule 11

**Distinguish requirement, model, and implementation uncertainty.**

### Rule 12

**Derive OBS from competencies and responsibilities required by the WBS.**

### Rule 13

**Use progressive CBS when technical uncertainty affects effort estimation.**

### Rule 14

**Bound engineering iteration by explicit time or effort budgets.**

### Rule 15

**When a gate fails, re-engineer, reduce scope, or escalate; do not iterate indefinitely.**

### Rule 16

**Prompts are execution interfaces, not substitutes for engineering.**

### Rule 17

**Every implementation artifact must be traceable to a requirement.**

### Rule 18

**Every significant technical decision must have evidence.**

### Rule 19

**Every failure must have a path back to the appropriate abstraction level.**

### Rule 20

**Requirements and engineering changes must be assessed for downstream impact before implementation.**

### Rule 21

**External implementations are evidence, not authority.**

### Rule 22

**Engineering reviews must have explicit sufficiency criteria and investigation budgets.**

### Rule 23

**A decision is stable only to the extent that its assumptions and evidence remain valid.**

### Rule 24

**A Product Specification must never be issued directly from LLD; it must pass through Prototype, Evidence, and Engineering Decision.**

### Rule 25

**The Product Specification ends at Validation & Acceptance. WBS, OBS, CBS, schedule, tasks, and execution specifications belong to the Execution Baseline, a separate document derived from the Product Specification.**

### Rule 26

**Engineering domains (BESS, Market, Financial, etc.) are not technologies. The technology stack belongs to the Technology Specification part, not to the Engineering Specification part.**

### Rule 27

**Prototypes are transversal to the level of the engineering question. They may operate at any level: conceptual, architectural, or implementational.**

### Rule 28

**Engineering Concept and Engineering Model are distinct artifacts. Concept without model is ambiguous; model without concept lacks semantic grounding.**

### Rule 29

**Every engineering decision must record the question it answers, the hypothesis tested, the evidence used, and the level at which it applies.**

### Rule 30

**A baseline is a controlled reference, not an immutable artifact. It changes only through change control.**

---

# 47. Final Integrated Model

The complete method can be summarized as:

```text
                         PRODUCT INTENT
                               │
                               ▼
                    PRODUCT REQUIREMENTS
                               │
                               ▼
                    CONCEPTUAL ENGINEERING
                               │
                ┌──────────────┼──────────────┐
                │              │              │
                ▼              ▼              ▼
           ENGINEERING     ENGINEERING    ENGINEERING
             CONCEPT         MODEL          QUESTIONS
                │              │              │
                └──────────────┼──────────────┘
                               ▼
                     PROTOTYPE / ANALYSIS
                               │
                            EVIDENCE
                               │
                               ▼
                     ENGINEERING DECISION
                               │
                               ▼
                            BASELINE
                               │
                ┌──────────────┴──────────────┐
                ▼                             ▼
       PRODUCT SPECIFICATION          EXECUTION BASELINE
                │                             │
                │                    ┌────────┼────────┐
                │                    ▼        ▼        ▼
                │                   WBS      OBS      CBS
                │                    │
                │                    ▼
                │                  TASKS
                │                    │
                │                    ▼
                │          EXECUTION SPECIFICATION
                │                    │
                └────────────────────┤
                                     ▼
                                   PROMPT
                                     │
                                     ▼
                              IMPLEMENTATION
                                     │
                                     ▼
                              TEST / VALIDATE
                                     │
                                     ▼
                                ACCEPTANCE


        ┌─────────────────────────────────────────────┐
        │                 TRANSVERSAL                 │
        │                                             │
        │  TRACEABILITY                               │
        │  VALIDATION                                 │
        │  UNCERTAINTY MANAGEMENT                     │
        │  CHANGE CONTROL                             │
        │  FEEDBACK                                   │
        │  DECISION EVIDENCE                          │
        │  EXTERNAL EVIDENCE REVIEW                   │
        │  ITERATION BUDGET                           │
        └─────────────────────────────────────────────┘
```

The model is not strictly linear. Evidence may trigger controlled movement to an earlier abstraction level:

```text
                         ┌─────────────────┐
                         │   REQUIREMENT   │
                         └────────┬────────┘
                                  │
                                  ▼
                           ENGINEERING MODEL
                                  │
                                  ▼
                              ARCHITECTURE
                                  │
                                  ▼
                               DESIGN
                                  │
                                  ▼
                              PROTOTYPE
                                  │
                                  ▼
                              EVIDENCE
                                  │
                         ┌────────┴────────┐
                         │                 │
                       VALID             INVALID
                         │                 │
                         ▼                 ▼
                      PROCEED        ROOT-CAUSE ANALYSIS
                                           │
                                           ▼
                                  APPROPRIATE LEVEL
                                           │
                                           └──────► REVISE
```

This creates **controlled iteration rather than uncontrolled rework**.

---

# 48. Guiding Principle

The methodology can ultimately be reduced to one statement:

> **Semantic Systems Engineering is a controlled process for transforming product intent into a validated and executable system while progressively reducing requirement, model, and implementation uncertainty through engineering decomposition, evidence-based decision making, progressive prototyping, controlled change, and traceable execution.**

For the ENGIE BESS project:

> **First define what the BESS system means from an engineering perspective. Then define how physical behavior, markets, data, forecasting, operations, and finance interact. Then design the architecture. Use external evidence and targeted prototypes to reduce uncertainty. Select computational techniques based on evidence rather than assumption. Only then progressively establish the product specification, execution baseline, and implementation.**

The essential transformation is therefore:

**Intent → Requirement → Concept → Model → Question → Hypothesis → Evidence → Decision → Baseline → Architecture → Execution → Implementation → Validation → Acceptance**

Not:

**Requirements → Documents → Code**

And not:

**Prompt → Code → Hope**

The purpose of the methodology is to preserve the meaning of the product while progressively transforming it from an initial idea into a **validated, traceable, executable, and maintainable system**.

---

Este es el documento completo en versión 4.3. Con esto quedan resueltas las 4 correcciones que señalaste:

1. Contradicción §25 / Rule 25 eliminada → Product Specification termina en Part V; Execution Baseline es documento separado con su propia estructura.
2. Prototype formalmente transversal al nivel de la pregunta → §2, §3, §16, §47.
3. Cadena Requirement → Concept → Model → Question → Hypothesis → Evidence → Decision → Specification formalizada → §5.2, §36, §47.
4. Baseline precisado en tres niveles y declarado no inmutable → §25.1, §44, Rule 30.

¿Quieres que a continuación empecemos a construir **§7 BESS Engineering** sobre esta base 4.3, con la estructura de 20 subsecciones que propusiste (Domain Purpose, System Boundary, Physical Entities, States, Parameters, Inputs, Outputs, Physical Relationships, Operating Constraints, Performance Characteristics, Degradation, Availability/Derating, Operating Modes, Engineering Questions, Engineering Models, Assumptions, Uncertainties, Validation Requirements, Evidence Requirements, Engineering Decisions)?

