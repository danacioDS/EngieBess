
---

# Semantic Systems Engineering Method

## From Product Intent to Validated and Executable Systems

**Version 4.4 — Engineering Method (methodological, project-agnostic)**

---

## Resumen de cambios respecto a 4.3

| # | Cambio | Secciones afectadas |
|---|---|---|
| 1 | La metodología se mantiene **abstracta y project-agnostic**. La referencia a ENGIE pasa a un **Application Profile** ilustrativo | §45, Executive Summary |
| 2 | La cadena se formaliza como **Engineering Baseline → HLD/LLD → Product Baseline → Execution Baseline** | §2, §25, §47 |
| 3 | Se distinguen dos ciclos: **Engineering Decision Cycle** y **Architecture Realization Cycle** | §3.5, §3.6, §13, §14 |
| 4 | La selección de técnica (LP/MILP/MISOCP/MPC/…) se decide en el proyecto, no en la metodología | §15, §18, §39, §45 |
| 5 | El stack tecnológico (Python, PySpark, SQL, Databricks, etc.) se trata como **constraint** o **decision** en Part IV, nunca como dominio de ingeniería | §25.2, §34, §45 |
| 6 | Se alinea con `ARCH-001` como documento real de arquitectura del proyecto | §45, §12 |

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

**Intent → Requirement → Concept → Model → Question → Hypothesis → Evidence → Decision → Engineering Baseline → Architecture → Product Baseline → Execution Baseline → Implementation → Validation → Acceptance**

This is **not a waterfall process**.

It is an iterative engineering system in which evidence may cause controlled revision of decisions at the appropriate abstraction level.

The method is particularly relevant to complex systems where physical behavior, market conditions, forecasting, optimization, software architecture, schedule, cost, and acceptance are interdependent.

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

The method does **not** define the engineering content of any particular project. It defines **how** that content is engineered, validated, and executed.

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
Engineering Baseline
      ↓
Architecture
      ↓
Product Baseline
      ↓
Execution Baseline
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

A prototype may therefore be used to answer a **conceptual** question before HLD/LLD are complete, or to answer an **implementation** question after LLD.

**Rule.** The transition from design to Product Baseline must pass through Prototype, Evidence, and Engineering Decision. A Product Baseline must never be issued directly from LLD.

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
              ENGINEERING BASELINE
                    │
                    ▼
                  HLD / LLD
                    │
                    ▼
              PRODUCT BASELINE
                    │
                    ▼
             EXECUTION BASELINE
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
       WBS         OBS         CBS
        │
        ▼
      TASKS
        │
        ▼
EXECUTION SPECIFICATION
        │
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
Engineering Baseline (or revision thereof)
```

**Engineering Decision** is formally defined as:

> **The controlled selection, approval, or rejection of an engineering hypothesis, formulation, architecture element, or technical approach, based on defined requirements, constraints, evidence, and residual uncertainty.**

### 3.6 Architecture Realization Cycle

Once the Engineering Baseline is sufficiently mature, it is realized through a distinct cycle:

```text
Engineering Baseline
     ↓
HLD
     ↓
Architecture Question
     ↓
Technical Prototype
     ↓
Evidence
     ↓
Architecture Decision
     ↓
Architecture Baseline
     ↓
LLD
     ↓
Product Baseline
```

The two cycles are **distinct** but interoperable:

- The **Engineering Decision Cycle** resolves what the system must represent.
- The **Architecture Realization Cycle** resolves how that representation is structurally realized.

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

For a complex system, the principal domains are identified by the project itself. They may include, for example:

- physical domain (asset behavior, states, limits);
- market or environment domain (value creation rules);
- data/input domain (information required to represent reality);
- forecasting domain (future quantities influencing decisions);
- operational domain (strategies and decisions over time);
- optimization domain (allocation of capability across opportunities);
- financial domain (economic consequences);
- validation domain (evidence and acceptance).

These domains are not necessarily independent modules.

They represent **engineering responsibilities and semantic domains** whose interactions must be understood before software architecture is finalized.

**Critical distinction:**

- Engineering domains are **not** technologies.
- The technology stack defines **how** the representation is realized.
- Mixing them inverts the method.

## 5.1 Engineering Concept vs Engineering Model

Conceptual Engineering produces two distinct but related artifacts:

- **Engineering Concept** — the qualitative representation of the system: what entities exist, what states they have, what relationships and constraints apply, what questions must be answered.
- **Engineering Model** — the quantitative representation: equations, variables, parameters, boundaries, and assumptions that operationalize the concept.

Concept and model are not interchangeable. Concept without model remains ambiguous; model without concept lacks semantic grounding.

## 5.2 Formal chain from Requirement to Specification

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
Engineering Baseline
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
| Engineering Baseline | Stable, evidence-supported state of the engineering work |

This chain is the backbone of traceability.

---

# 6–11. Dominios de ingeniería (project-defined)

Los dominios concretos de ingeniería de un proyecto (BESS, Market, Financial, Data, Forecasting, Operational, Optimization, Validation, etc.) se definen **en el proyecto**, no en la metodología.

La metodología solo establece:

- que los dominios se identifican antes de la descomposición arquitectónica;
- que cada dominio responde a una pregunta fundamental;
- que cada dominio produce Engineering Concept y Engineering Model;
- que cada dominio se valida con evidencia;
- que los dominios no se confunden con tecnologías.

Los contenidos específicos de cada dominio viven en el **Engineering Baseline del proyecto**.

---

# 12. Uncertainty Management

The method distinguishes three principal categories of uncertainty.

## 12.1 Requirement Uncertainty

Uncertainty regarding what the stakeholder actually requires.

Reduced through:

**Requirements Validation → Conceptual Engineering → Stakeholder Review**

## 12.2 Model Uncertainty

Uncertainty regarding whether the engineering representation adequately represents the real system.

Reduced through:

**Engineering Analysis → Prototype → Benchmark → Backtesting → Validation**

## 12.3 Implementation Uncertainty

Uncertainty regarding whether the selected architecture and implementation can adequately realize the engineered system.

Reduced through:

**HLD → LLD → Technical Prototype → Performance Testing**

**Note.** Requirement, model, and implementation uncertainty are distinct. A failure must first be classified before corrective action. A solver timing problem does not invalidate the physical model; a stakeholder change does not invalidate the software architecture.

---

# 13. High-Level Design — HLD

Once the **Engineering Baseline** reaches sufficient maturity, it can be transformed into a system architecture.

A representative HLD defines:

- major components;
- responsibilities;
- interfaces;
- dependencies;
- major data flows;
- architectural boundaries.

HLD should avoid unnecessary implementation detail.

**Rule.** HLD realizes the Engineering Baseline. It does not redefine the engineering semantics.

The concrete architecture of a project (for example, `ARCH-001` in the ENGIE BESS project) is a **project artifact**, not part of this methodology.

---

# 14. Low-Level Design — LLD

LLD transforms architectural components into implementable mechanisms.

LLD is the level at which implementation uncertainty becomes explicit.

A technical decision should not be promoted to a fixed implementation requirement merely because it appears in an early design document.

LLD produces the **Product Baseline** when combined with the validated engineering decisions.

---

# 15. Technique Selection Protocol

The methodology does not assume a final technique in advance.

Candidate techniques may include (depending on the problem):

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

Technique selection therefore follows engineering evidence, and is decided **in the project**, not in the methodology.

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

Its purpose is to answer:

> **Does the fundamental logic behave correctly?**

The prototype should therefore prioritize **semantic validation over sophistication**.

---

# 17. Progressive Technique Complexity

Complexity should increase only when evidence justifies it.

A possible progression is:

```text
Prototype 0
Simplified formulation
      ↓
Prototype 1
Detailed physical constraints
      ↓
Prototype 2
Discrete decisions
      ↓
Prototype 3
Rolling horizon / MPC
      ↓
Prototype 4
Scenario / Stochastic / Robust
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

A candidate technique must satisfy mandatory requirements (feasibility, runtime, scalability, numerical reliability, resolution, availability, etc.).

A technique failing a mandatory constraint is rejected regardless of its performance elsewhere.

## 18.2 Weighted Criteria

Among techniques satisfying all hard constraints, candidates may be evaluated against weighted criteria (solution quality, scalability, extensibility, robustness, interpretability, maintainability, implementation complexity, etc.).

The exact weights must be defined according to project requirements.

The general decision rule is:

$$
Score_j = \sum_i w_i s_{ij}
$$

subject to:

$$
HardConstraint_k(j)=PASS
$$

Therefore:

> **Hard constraints eliminate unacceptable techniques; weighted criteria distinguish among technically acceptable alternatives.**

---

# 19. Tie-Breaking Rule

If two candidate techniques remain materially equivalent after evaluation, use the following tie-breaking order:

1. lower computational complexity;
2. lower implementation complexity;
3. greater extensibility;
4. greater interpretability.

> **When two solutions satisfy the requirements equivalently, prefer the simpler one.**

Mathematical sophistication is not itself an engineering objective.

---

# 20. Validation and Benchmark Engineering

Validation is a continuous engineering function.

It may include:

- physical validation;
- mathematical validation;
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
Model
      ↓
Simulated Behavior
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

Required evidence: product intent, system boundary, stakeholders, major objectives, major unresolved requirements.

## Gate 2 — Engineering Baseline

Required evidence: engineering domains, interfaces, major constraints, inputs, outputs, principal assumptions.

## Gate 3 — Architecture Baseline

Required evidence: HLD coherent, interfaces defined, dependencies understood, architectural boundaries established, major implementation risks identified.

## Gate 4 — Prototype Validation

Required evidence: core behavior validated, critical assumptions tested, prototype results reproducible, known limitations documented.

## Gate 5 — Technique Selection

Required evidence: candidates considered, prototype evidence, hard constraints evaluated, weighted criteria evaluated, selected technique documented, alternatives and rationale recorded.

## Gate 6 — Product Baseline

Required evidence: requirements sufficiently stable, acceptance criteria defined, validation methods defined, interfaces documented, major residual risks identified.

## Gate 7 — Execution Baseline

Required evidence: WBS defined, required competencies identified, responsibilities established, OBS established, CBS estimated, remaining uncertainty documented, execution dependencies identified.

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
│              │              │ Decision      │
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

If the budget is exhausted without convergence, the issue becomes a **project-level decision**.

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

The Product Specification should represent a validated engineering decision, not an untested assumption.

## 25.1 Baseline model

The methodology distinguishes three baselines:

```text
ENGINEERING BASELINE
        │
        ├── BESS Engineering
        ├── Market Engineering
        ├── Data / Input Engineering
        ├── Forecasting Engineering
        ├── Operational Engineering
        ├── Optimization Engineering
        ├── Financial Engineering
        └── Validation Engineering
                │
                ▼
             HLD / LLD
                │
                ▼
        PRODUCT BASELINE
       (Product Specification)
                │
                ▼
        EXECUTION BASELINE
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
- **Product Baseline** — the stable state of the Product Specification.
- **Execution Baseline** — the stable state of the work, organizational, and cost structure.

**Baseline ≠ immutable.** A baseline is a controlled reference. It changes only through change control.

## 25.2 Product Specification structure (generic template)

```text
PRODUCT SPECIFICATION

PART I — PRODUCT DEFINITION                       [definición]
    1. Product Purpose
    2. Scope
    3. Users / Stakeholders
    4. System Boundary
    5. Product Capabilities
    6. Success Criteria

PART II — ENGINEERING SPECIFICATION               [requisitos]
    7..N. Engineering Domains
          (defined by the project)

PART III — SYSTEM ARCHITECTURE                    [derivado]
    N+1. HLD
    N+2. LLD
    N+3. Interfaces
    N+4. Data flows
    N+5. Computational architecture

PART IV — TECHNOLOGY SPECIFICATION
    N+6. Technology Constraints                   [impuesto]
    N+7. Technology Decisions                     [elegido con evidencia]
    N+8. Technology Validation

PART V — VALIDATION & ACCEPTANCE                  [requisitos]
    N+9.  Acceptance Criteria
    N+10. Test Strategy
    N+11. Engineering Validation
    N+12. Backtesting
    N+13. UAT
    N+14. Traceability
```

**Note.** The Product Specification ends at Part V. WBS, OBS, CBS, schedule, tasks, and execution specifications belong to the **Execution Baseline**, a separate document derived from the Product Specification.

## 25.3 Execution Baseline structure (generic template)

```text
EXECUTION BASELINE

PART I — PRODUCT CAPABILITY BREAKDOWN             [derivado]
PART II — WBS                                     [derivado]
PART III — COMPETENCY DECOMPOSITION               [derivado]
PART IV — OBS                                     [derivado]
PART V — CBS                                      [derivado]
PART VI — DEPENDENCIES                            [derivado]
PART VII — SCHEDULE                               [derivado]
PART VIII — TASKS                                 [derivado]
PART IX — EXECUTION SPECIFICATIONS                [derivado]
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

WBS answers:

> **What work must be performed?**

The WBS should be derived from the engineered product rather than from an arbitrary organizational structure.

---

# 27. Competency Decomposition

Before assigning people or organizational units, the required competencies should be derived from the work.

The sequence is:

**WBS Element → Required Competencies → Responsibilities → Resources → OBS**

This prevents organizational structure from driving technical decomposition.

---

# 28. OBS — Organizational Breakdown Structure

OBS maps required responsibilities to actual resources. It belongs to the **Execution Baseline**.

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

However, effort may be uncertain:

$$
Effort_i = E_{base} + E_{uncertainty}
$$

---

# 30. Progressive CBS

CBS should evolve with engineering evidence.

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

> **Technical evidence progressively increases confidence in cost estimation.**

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

---

# 32. Execution Specification

The Execution Specification is the formal bridge between engineering definition and execution.

It combines:

**Requirement + Engineering Model + LLD + Task**

An Execution Specification should define:

1. Context
2. Objective
3. Scope
4. Inputs
5. Prerequisites
6. Engineering constraints
7. Interfaces
8. Assumptions
9. Expected artifact
10. Acceptance criteria
11. Validation procedure
12. Dependencies
13. Out-of-scope items

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

> **Prompt quality is downstream evidence of upstream engineering completeness.**

---

# 34. Implementation

Implementation instantiates the validated design.

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

Testing occurs at multiple levels:

- Unit Testing
- Integration Testing
- Engineering Validation
- Benchmark Testing
- Backtesting
- Performance Testing
- User Acceptance Testing

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
Engineering Baseline
          ↓
HLD / LLD
          ↓
Product Baseline
          ↓
Execution Baseline
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

> **Fix the problem at the level where its meaning is wrong, not merely at the level where the symptom appears.**

---

# 39. Semantic Stability

A technical decision should not be considered stable merely because it has been documented.

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

- the engineering question it answers;
- the hypothesis that was tested;
- the prototype or analysis used;
- the level at which the decision applies.

---

# 41. Repository and External Implementation Review

External implementations, open-source repositories, literature, benchmarks, and reference systems may be used as **engineering evidence**.

They should not automatically determine the architecture or technical solution.

External implementation is therefore **evidence, not authority**.

---

# 42. Evidence Review Criteria

A repository or external reference should be evaluated according to at least five dimensions: Breadth, Depth, Evidence, Architecture, Traceability.

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
The integrated specification of the product. Includes Product Definition, Engineering Specification, System Architecture, Technology Specification, and Validation & Acceptance.

### Execution Baseline
The organizational, work, and cost baseline derived from the Product Specification.

### WBS — Work Breakdown Structure
Decomposition of the work required to create the system. Derived from the Product Specification.

### OBS — Organizational Breakdown Structure
Mapping of responsibilities and work to organizational resources.

### CBS — Cost Breakdown Structure
Decomposition and estimation of project cost.

### Execution Specification
A precise definition of how a task is to be executed and validated.

### Prompt
An execution interface that communicates an Execution Specification to an execution agent. Not an engineering specification.

### Semantic Stability
The state in which a decision is sufficiently supported by evidence to serve as a reliable engineering baseline within its defined scope.

### Engineering Evidence
Information, analysis, experiment, prototype result, benchmark, test, or other objective basis used to support an engineering decision.

---

# 45. Application Profile — ENGIE BESS

This section **demonstrates** how Semantic Systems Engineering can be applied to the ENGIE BESS engagement.

It is **illustrative** and does **not** constitute the engineering definition of the ENGIE system.

The project-specific engineering definition is maintained in the project's Engineering Baseline and related architecture, specification, and execution documents (for example, `ARCH-001`).

| ENGIE requirement | Method mechanism |
|---|---|
| BESS modeling | Engineering domain decomposition |
| Load forecasting | Forecasting Engineering |
| Revenue stacking | Operational & Optimization Engineering |
| Financial modeling | Financial Engineering |
| Python / Databricks / PySpark / SQL | Technology Specification (Part IV) |
| UAT | Validation & Acceptance |
| 12-week delivery | Execution Baseline |
| Optimization methodology TBD | Engineering Decision Cycle + Technique Selection Protocol |

The concrete architecture of the ENGIE BESS project is documented separately (e.g., `ARCH-001` — System Architecture). That document is the project artifact; this methodology is the method it instantiates.

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
**A Product Baseline must never be issued directly from LLD; it must pass through Prototype, Evidence, and Engineering Decision.**

### Rule 25
**The Product Specification ends at Validation & Acceptance. WBS, OBS, CBS, schedule, tasks, and execution specifications belong to the Execution Baseline, a separate document derived from the Product Specification.**

### Rule 26
**Engineering domains are not technologies. The technology stack belongs to the Technology Specification part, not to the Engineering Specification part.**

### Rule 27
**Prototypes are transversal to the level of the engineering question. They may operate at any level: conceptual, architectural, or implementational.**

### Rule 28
**Engineering Concept and Engineering Model are distinct artifacts. Concept without model is ambiguous; model without concept lacks semantic grounding.**

### Rule 29
**Every engineering decision must record the question it answers, the hypothesis tested, the evidence used, and the level at which it applies.**

### Rule 30
**A baseline is a controlled reference, not an immutable artifact. It changes only through change control.**

### Rule 31
**The method is project-agnostic. Project-specific content belongs to the project's Engineering Baseline, Architecture, Product Specification, and Execution Baseline, not to the method.**

### Rule 32
**Engineering Decision Cycle and Architecture Realization Cycle are distinct. The first resolves what the system must represent; the second resolves how that representation is structurally realized.**

---

# 47. Final Integrated Model

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
                     ENGINEERING BASELINE
                               │
                               ▼
                            HLD / LLD
                               │
                               ▼
                      PRODUCT BASELINE
                               │
                               ▼
                     EXECUTION BASELINE
                               │
                ┌──────────────┼──────────────┐
                ▼              ▼              ▼
               WBS            OBS            CBS
                │
                ▼
              TASKS
                │
                ▼
      EXECUTION SPECIFICATION
                │
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

The model is not strictly linear. Evidence may trigger controlled movement to an earlier abstraction level.

This creates **controlled iteration rather than uncontrolled rework**.

---

# 48. Guiding Principle

> **Semantic Systems Engineering is a controlled process for transforming product intent into a validated and executable system while progressively reducing requirement, model, and implementation uncertainty through engineering decomposition, evidence-based decision making, progressive prototyping, controlled change, and traceable execution.**

The essential transformation is therefore:

**Intent → Requirement → Concept → Model → Question → Hypothesis → Evidence → Decision → Engineering Baseline → Architecture → Product Baseline → Execution Baseline → Implementation → Validation → Acceptance**

Not:

**Requirements → Documents → Code**

And not:

**Prompt → Code → Hope**

The purpose of the methodology is to preserve the meaning of the product while progressively transforming it from an initial idea into a **validated, traceable, executable, and maintainable system**.

---

