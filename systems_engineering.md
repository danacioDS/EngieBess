
# Semantic Systems Engineering Method

## From Product Intent to Validated and Executable Systems

**Version 3.0 — Engineering Method**

---

# Executive Summary

Semantic Systems Engineering is a method for transforming an initial product intent into a validated, executable system while progressively reducing uncertainty.

The method is based on five principles:

1. **Meaning precedes implementation.**
2. **Engineering precedes architecture.**
3. **Uncertain technical decisions are validated through prototypes rather than assumed.**
4. **Work, responsibility, and cost are progressively derived from the engineering definition.**
5. **Validation, traceability, uncertainty management, and feedback operate across the entire lifecycle.**

The fundamental transformation is:

**Intent → Concept → Engineering Model → Architecture → Design → Prototype → Evidence → Decision → Specification → Execution → Implementation → Acceptance**

This is not a waterfall.

It is an iterative engineering system in which evidence can cause controlled revision of earlier decisions.

For complex systems such as the ENGIE BESS modeling platform, this is particularly important because requirements, physical models, market behavior, forecasting, optimization techniques, software architecture, schedule, and cost are interdependent.

The method therefore treats engineering as a process of **progressive uncertainty reduction**.

---

# 1. Purpose

This document defines a systematic method for transforming a product concept, RFP, business requirement, or stakeholder need into a validated and executable technical system.

The method is intended for systems where:

* requirements may initially be incomplete;
* multiple engineering domains interact;
* mathematical models are required;
* computational techniques may be uncertain;
* prototypes are needed to validate architecture;
* implementation effort depends on unresolved technical decisions;
* acceptance requires objective evidence.

The method is applicable to the ENGIE BESS Operational & Financial Modeling context, but is intentionally defined at a level that allows application to other complex engineering systems.

---

# 2. Fundamental Principle

The system should not be developed by moving directly from requirements to code.

Instead:

> **The product's meaning must progressively become more precise until implementation becomes an instantiation of an already-engineered system.**

The fundamental chain is:

```text
Product Intent
      ↓
Conceptual Engineering
      ↓
HLD
      ↓
LLD
      ↓
Prototype
      ↓
Validation
      ↓
Engineering Decision
      ↓
Product Specification
      ↓
WBS / OBS / CBS
      ↓
Tasks
      ↓
Execution Specification
      ↓
Implementation
      ↓
Testing
      ↓
Acceptance
```

This chain represents **increasing implementation specificity**.

It does not imply that information only flows downward.

Validation can trigger controlled movement upward.

---

# 3. The Engineering Lifecycle

The complete lifecycle is organized around four transversal mechanisms:

* **Traceability**
* **Validation**
* **Uncertainty Management**
* **Feedback / Change Control**

These are not sequential stages.

They operate across all stages of the lifecycle.

```text
                    PRODUCT INTENT
                          │
                          ▼
                 CONCEPTUAL ENGINEERING
                          │
                          ▼
                         HLD
                          │
                          ▼
                         LLD
                          │
                          ▼
                      PROTOTYPE
                          │
                          ▼
               VALIDATION / BENCHMARK
                          │
                    ┌─────┴─────┐
                    │           │
                  PASS         FAIL
                    │           │
                    ▼           ▼
                 DECISION    ROOT CAUSE
                    │           │
                    │           ▼
                    │      RE-ENGINEER
                    │           │
                    └─────◄─────┘
                    │
                    ▼
             PRODUCT SPECIFICATION
                    │
                    ▼
              WBS / OBS / CBS
                    │
                    ▼
                  TASKS
                    │
                    ▼
          EXECUTION SPECIFICATION
                    │
                    ▼
              IMPLEMENTATION
                    │
                    ▼
             TEST / ACCEPTANCE
```

---

# 4. Level 1 — Product Intent

Product Intent defines why the system exists.

It answers three fundamental questions:

### WHAT?

What capability or product must exist?

### WHY?

What problem or opportunity does it address?

### FOR WHOM?

Who uses, evaluates, owns, or receives value from it?

For the ENGIE BESS case:

**WHAT**

A system capable of modeling the operational and financial performance of BESS projects.

**WHY**

To support project evaluation, business development, scenario analysis, and financial viability assessment.

**FOR WHOM**

Stakeholders evaluating BESS projects and their operational and economic performance.

At this stage, implementation choices should remain open.

---

# 5. Level 2 — Conceptual Engineering

Conceptual Engineering converts Product Intent into a coherent engineering representation.

It determines:

> **What must be represented, modeled, constrained, optimized, and measured for the intended product to exist?**

For a BESS system, the major engineering domains are:

1. BESS Engineering
2. Market Engineering
3. Data/Input Engineering
4. Forecasting Engineering
5. Operational & Optimization Engineering
6. Financial Engineering
7. Validation/Benchmark Engineering

---

# 6. BESS Engineering

BESS Engineering defines the physical capabilities and limitations of the asset.

It includes:

* battery cells/modules/racks;
* DC system;
* PCS/inverter;
* AC system;
* grid interface;
* site load;
* SOC;
* SOH;
* energy capacity;
* power capacity;
* efficiency;
* ramp limitations;
* thermal constraints;
* degradation;
* operating limits.

The fundamental question is:

> **What can the physical BESS actually do?**

---

# 7. Market Engineering

Market Engineering defines the environment in which the BESS can create value.

It includes:

* energy markets;
* day-ahead prices;
* real-time prices;
* ancillary services;
* frequency regulation;
* capacity markets;
* demand response;
* tariffs;
* demand charges;
* eligibility;
* participation rules;
* settlement;
* market constraints.

The fundamental question is:

> **Under what market conditions and rules can the BESS create value?**

Market Engineering is therefore distinct from BESS Engineering.

---

# 8. Data/Input Engineering

Data/Input Engineering defines the information required to represent reality.

For each input, the model should establish:

* semantic meaning;
* source;
* unit;
* temporal resolution;
* timestamp convention;
* historical vs. forecast status;
* quality requirements;
* validation rules;
* missing-data behavior;
* uncertainty.

This is not yet an ETL architecture.

It defines **what information the engineering system requires**, leaving implementation of ingestion and transformation to later stages.

---

# 9. Forecasting Engineering

Forecasting is explicitly separated from general Data Engineering because forecasts influence optimization decisions.

Possible forecasts include:

* load;
* market prices;
* PV production;
* ancillary-service prices;
* market availability.

A basic representation is:

$$
X_t = \hat{X}_t + \epsilon_t
$$

where:

* \(X_t\) is the realized value;
* \(\hat{X}_t\) is the forecast;
* \(\epsilon_t\) is the forecast error.

The conceptual architecture must determine whether the system requires:

* deterministic forecasting;
* scenario-based forecasting;
* stochastic optimization;
* robust optimization;
* sensitivity analysis.

The exact forecasting algorithm can remain open until evidence justifies its selection.

---

# 10. Operational and Optimization Engineering

Operational Engineering is where the major domains converge.

```text
BESS Physics ─────────────┐
                         │
Market Conditions ───────┤
                         │
Load / Forecasts ────────┤
                         ▼
                  DISPATCH ENGINE
                         ▲
                         │
Service Requirements ────┤
                         │
Operating Strategy ──────┤
                         │
Degradation ─────────────┘
```

The Dispatch Engine determines how the available physical capability should be allocated across competing operational opportunities.

This makes dispatch the **convergence point**, not simply another downstream module.

---

# 11. Financial Engineering

Financial Engineering translates operational behavior into economic value.

Operational outputs may include:

* charging energy;
* discharging energy;
* peak reduction;
* demand-response performance;
* ancillary-service participation;
* market settlements;
* degradation;
* replacement requirements.

Financial outputs may include:

* revenue by stream;
* savings;
* O&M;
* degradation cost;
* replacement cost;
* NPV;
* IRR;
* payback.

The boundary is:

> **Operational Engineering determines what the asset does; Financial Engineering determines the economic consequence of what it does.**

---

# 12. Uncertainty Management

The method distinguishes three fundamental uncertainties.

## 12.1 Requirement Uncertainty

Uncertainty about what the stakeholder requires.

Reduced through:

**Requirements Validation → Conceptual Engineering → Stakeholder Review**

---

## 12.2 Model Uncertainty

Uncertainty about whether the engineering representation adequately represents reality.

Reduced through:

**Prototype → Benchmark → Backtesting → Validation**

---

## 12.3 Implementation Uncertainty

Uncertainty about whether the selected technical architecture can implement the model adequately.

Reduced through:

**LLD → Technical Prototype → Performance Testing**

These uncertainties must not be conflated.

A solver timing problem does not automatically invalidate the physical model.

A stakeholder changing a requirement does not automatically invalidate the software architecture.

---

# 13. High-Level Design — HLD

Once the conceptual engineering model reaches sufficient maturity, it can be transformed into a system architecture.

A representative architecture is:

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

* components;
* responsibilities;
* interfaces;
* dependencies;
* major data flows.

It should not yet specify implementation-level details unnecessarily.

---

# 14. Low-Level Design — LLD

LLD transforms architectural components into implementable mechanisms.

For the optimization engine, this may include:

* state manager;
* SOC state;
* SOH state;
* available-energy calculation;
* available-power calculation;
* constraint builder;
* market opportunity builder;
* service allocation;
* reserve/headroom calculation;
* objective function;
* degradation cost;
* optimization formulation;
* solver interface;
* rolling-horizon controller;
* infeasibility handling;
* result validation.

LLD is where implementation uncertainty becomes explicit.

---

# 15. Technique Selection Protocol

The methodology does not assume the final optimization technique.

Candidate techniques may include:

* heuristic;
* LP;
* MILP;
* MISOCP;
* nonlinear optimization;
* MPC;
* stochastic optimization;
* robust optimization;
* hybrid methods.

The correct question is not:

> "Which solver do we normally use?"

It is:

> **"What is the simplest technique that satisfies the validated engineering requirements?"**

---

# 16. Prototype 0 — Minimum Viable Formulation

The first optimization prototype should deliberately minimize unnecessary complexity.

A suitable starting point for many BESS dispatch problems is:

### Simplified deterministic LP

with:

* short horizon;
* continuous charge/discharge;
* SOC constraints;
* energy limits;
* power limits;
* basic efficiency;
* simplified revenue streams;
* deterministic forecasts;
* no unnecessary binary variables.

Its purpose is not production deployment.

Its purpose is to answer:

> **Does the fundamental physical and economic logic work?**

---

# 17. Progressive Technique Complexity

Complexity should increase only when engineering evidence justifies it.

A possible progression is:

**Prototype 0**

Simplified LP

↓

**Prototype 1**

Detailed physical constraints

↓

**Prototype 2**

MILP for genuinely discrete decisions

↓

**Prototype 3**

Rolling Horizon / MPC

↓

**Prototype 4**

Scenario / stochastic / robust formulation

↓

**Prototype 5**

Production-scale formulation

This sequence is not mandatory.

It is a default engineering strategy.

The actual sequence should depend on the questions being investigated.

---

# 18. Technique Evaluation Matrix

A major improvement over an unweighted criteria list is to distinguish between **hard constraints** and **optimization criteria**.

## 18.1 Hard Constraints

A candidate technique must satisfy these conditions.

Examples:

* physical feasibility;
* numerical reliability;
* maximum acceptable runtime;
* required solution availability;
* required temporal resolution.

A technique failing a hard constraint is rejected regardless of its score elsewhere.

---

## 18.2 Weighted Criteria

Among techniques satisfying the hard constraints, evaluate:

| Criterion                 | Example Weight |
| ------------------------- | -------------: |
| Solution quality          |            20% |
| Scalability               |            20% |
| Extensibility             |            15% |
| Robustness                |            15% |
| Interpretability          |            10% |
| Maintainability           |            10% |
| Implementation complexity |            10% |

The exact weights should be defined according to project priorities.

The general decision rule is:

$$
Score_j = \sum_i w_i s_{ij}
$$

where:

* \(w_i\) = weight of criterion \(i\);
* \(s_{ij}\) = score of technique \(j\) against criterion \(i\).

Subject to:

$$
HardConstraint_k(j)=PASS
$$

for every mandatory constraint \(k\).

Therefore:

> **Hard constraints eliminate unacceptable techniques; weighted criteria distinguish among technically acceptable alternatives.**

This prevents committee indecision when techniques trade off different strengths.

---

# 19. Tie-Breaking Rule

If two candidate techniques remain materially equivalent after evaluation, the preferred tie-breaker is:

1. lower computational complexity;
2. lower implementation complexity;
3. greater extensibility;
4. greater interpretability.

This expresses a general engineering principle:

> **When two solutions satisfy the requirements equivalently, prefer the simpler one.**

The rule prevents unnecessary mathematical sophistication from becoming an architectural objective in itself.

---

# 20. Validation and Benchmark Engineering

Validation operates continuously throughout the lifecycle.

It includes:

* physical validation;
* mathematical validation;
* market validation;
* benchmark testing;
* historical backtesting;
* performance testing;
* regression testing;
* UAT;
* acceptance testing.

Validation is therefore a **technical engineering function**, not merely QA.

---

# 21. Historical Backtesting

Market-facing systems require historical validation whenever appropriate data and settlement rules are available.

The loop is:

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

Backtesting evaluates whether the combined model produces plausible historical behavior.

It should not be reduced to simply asking whether the optimizer maximizes historical revenue.

---

# 22. Decision Gates

The project progresses through explicit decision gates.

### Gate 1 — Concept Freeze

Required evidence:

* product intent defined;
* system boundary defined;
* stakeholders identified;
* major objectives identified.

### Gate 2 — Engineering Baseline

Required evidence:

* engineering domains defined;
* interfaces identified;
* major constraints identified;
* inputs identified;
* outputs identified.

### Gate 3 — Architecture Baseline

Required evidence:

* HLD coherent;
* interfaces defined;
* dependencies understood.

### Gate 4 — Prototype Validation

Required evidence:

* core physical behavior validated;
* core economic behavior validated;
* critical assumptions tested.

### Gate 5 — Technique Selection

Required evidence:

* candidate techniques prototyped sufficiently;
* hard constraints evaluated;
* weighted criteria evaluated;
* selected technique documented;
* rationale recorded.

### Gate 6 — Product Baseline

Required evidence:

* requirements sufficiently stable;
* acceptance criteria defined;
* validation methods defined;
* interfaces documented.

### Gate 7 — Execution Baseline

Required evidence:

* WBS defined;
* competencies identified;
* OBS established;
* CBS estimated;
* remaining uncertainty documented.

---

# 23. Gate Failure and Escalation Protocol

A critical addition is that failure cannot result in indefinite iteration.

When a gate fails, the process is:

```text
Gate Failure
     ↓
Root Cause
     ↓
Estimate Impact
     ↓
Classify Response
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

The response depends on the failure.

### Re-engineer

Used when the required capability remains feasible but the current design is inadequate.

### Reduce Scope

Used when the capability is not achievable within the available time/resources without unacceptable risk.

### Escalate Decision

Used when the issue requires stakeholder or project-level trade-offs.

---

# 24. Iteration Budget

Each uncertain engineering activity should have a predefined iteration budget.

For example:

* number of prototype iterations;
* maximum investigation time;
* maximum computational experimentation effort.

If the budget is exhausted without convergence, the issue becomes a **management decision**, not an implicit invitation to continue engineering indefinitely.

This is particularly important in a fixed-duration engagement.

The principle is:

> **Engineering iteration must be bounded by project constraints.**

---

# 25. Product Specification

Once the engineering baseline is sufficiently validated, requirements are transformed into Product Specifications.

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

* initial SOC;
* charging power;
* discharging power;
* timestep;
* charging efficiency;
* discharging efficiency.

### Behavior

SOC shall evolve according to the approved energy-balance model.

### Output

SOC time series.

### Acceptance Criterion

SOC shall remain within defined operational limits for all valid test scenarios.

### Validation

Engineering benchmark and automated test cases.

---

# 26. WBS — Work Breakdown Structure

The WBS decomposes the product into the work necessary to create it.

Example:

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

---

# 27. Competency Decomposition

OBS should be derived from WBS.

The sequence is:

**WBS Element → Required Competencies → Responsibilities → Resources → OBS**

For example:

### WBS Element

**Dispatch Optimization Engine**

### Required Competencies

* BESS operational modeling;
* mathematical optimization;
* energy-market modeling;
* Python;
* numerical methods;
* testing/validation.

### Responsibilities

* formulate dispatch problem;
* define objective function;
* define constraints;
* prototype candidate techniques;
* validate dispatch behavior;
* document optimization decisions.

### Resource Type

Optimization/BESS engineering specialist.

Only after this analysis should the organizational assignment be made.

---

# 28. OBS — Organizational Breakdown Structure

OBS maps required responsibilities to actual resources.

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

* one person;
* multiple specialists;
* one multidisciplinary team.

The OBS should therefore emerge from actual engineering needs rather than from predefined organizational titles.

---

# 29. CBS — Cost Breakdown Structure

CBS converts the work and resource requirements into cost.

Conceptually:

$$
Cost_i = Effort_i \times Rate_i + Contingency_i
$$

The problem is that effort may be uncertain.

Therefore:

$$
Effort_i = E_{base} + E_{uncertainty}
$$

The dispatch engine is a representative example.

Before prototyping:

* formulation complexity is uncertain;
* solver choice is uncertain;
* scaling behavior is uncertain.

After prototyping:

* complexity becomes better understood;
* technique selection becomes evidence-based;
* effort uncertainty decreases.

---

# 30. Progressive CBS

CBS should therefore evolve with engineering evidence.

```text
Initial Engineering Estimate
             ↓
       Initial WBS/CBS
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

This establishes:

> **Technical evidence progressively increases cost-estimation confidence.**

CBS is therefore not necessarily a one-time activity.

It can be progressively refined until an appropriate baseline is established.

---

# 31. Tasks

Each WBS element is decomposed into executable tasks.

A task should define:

* objective;
* inputs;
* prerequisites;
* expected output;
* acceptance criterion;
* validation method;
* dependencies;
* required competency;
* estimated effort.

The task should not require the executor to rediscover the engineering model.

---

# 32. Execution Specification

The Execution Specification is the bridge between engineering definition and execution.

It combines:

**Requirement + Engineering Model + LLD + Task**

into a precise execution instruction.

It should define:

* context;
* objective;
* constraints;
* interfaces;
* assumptions;
* expected artifact;
* acceptance criteria;
* validation procedure.

---

# 33. Prompt as Execution Interface

The prompt is an execution interface.

It is not the engineering specification itself.

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

If the agent repeatedly needs to invent missing architecture or requirements, this is evidence that the upstream engineering definition is incomplete.

---

# 34. Implementation

Implementation instantiates the validated design.

Examples include:

* Python;
* PySpark;
* SQL;
* optimization models;
* Databricks components;
* APIs;
* dashboards;
* reports.

Implementation should not silently redefine the engineering model.

If implementation reveals a fundamental design problem, the problem should be returned to the appropriate engineering level.

---

# 35. Testing

Testing occurs at multiple levels:

### Unit Testing

Individual components.

### Integration Testing

Component interactions.

### Engineering Validation

Implementation against engineering equations and constraints.

### Benchmark Testing

Comparison against reference cases.

### Backtesting

Historical behavior.

### Performance Testing

Runtime and scalability.

### User Acceptance Testing

Stakeholder requirements.

These activities answer different questions and should not be collapsed into one generic "testing" phase.

---

# 36. Integrated Traceability

A single traceability chain should replace multiple overlapping diagrams.

```text
RFP / Stakeholder Intent
          ↓
Product Requirement
          ↓
Engineering Requirement
          ↓
Conceptual Model
          ↓
HLD
          ↓
LLD
          ↓
Product Specification
          ↓
WBS / Task
          ↓
Execution Specification
          ↓
Implementation
          ↓
Test Case
          ↓
Validation Evidence
          ↓
Acceptance
```

The reverse direction must also be possible.

Given an implementation artifact, the team should be able to answer:

> **Why does this artifact exist?**

And trace it back to the original product requirement.

---

# 37. Feedback and Root-Cause Analysis

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

Possible affected levels include:

* Product Intent;
* Conceptual Engineering;
* HLD;
* LLD;
* Product Specification;
* Task;
* Implementation.

The key principle is:

> **Fix the problem at the level where its meaning is wrong, not merely at the level where the symptom appears.**

---

# 38. Semantic Stability

A technical decision should not be considered stable merely because it has been written down.

For example:

### Hypothesis

> MILP will be used for dispatch.

This is an assumption.

After validation:

> MILP satisfies the defined feasibility, solution-quality, runtime, scalability, and extensibility criteria for the required dispatch use cases.

This is an engineering decision.

Therefore:

> **A decision becomes semantically stable when it is supported by sufficient evidence.**

---

# 39. Decision Evidence

Major technical decisions should have a minimal decision record containing:

* decision;
* alternatives considered;
* evaluation criteria;
* evidence;
* assumptions;
* constraints;
* selected option;
* rationale;
* residual risks.

This prevents the project from losing the reasoning behind architectural choices.

---

# 40. Application to the ENGIE BESS System

The method applied to the BESS project becomes:

```text
ENGIE RFP
   ↓
Product Intent
   ↓
Conceptual Engineering
   ├── BESS Engineering
   ├── Market Engineering
   ├── Data Engineering
   ├── Forecasting Engineering
   ├── Operational Engineering
   └── Financial Engineering
   ↓
HLD
   ↓
LLD
   ↓
Optimization Prototype
   ↓
Benchmark / Backtest
   ↓
Technique Selection
   ↓
Product Specification
   ↓
WBS
   ↓
Competencies
   ↓
OBS
   ↓
Progressive CBS
   ↓
Tasks
   ↓
Execution Specification
   ↓
Prompts
   ↓
Implementation
   ↓
Testing / UAT
   ↓
Acceptance
```

The optimization engine is deliberately treated as an engineering decision point rather than a predetermined implementation detail.

---

# 41. Core Engineering Rules

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

---

# 42. Final Integrated Model

The complete method can be summarized as:

```text
                         PRODUCT INTENT
                               │
                               ▼
                    CONCEPTUAL ENGINEERING
                               │
                               ▼
                              HLD
                               │
                               ▼
                              LLD
                               │
                               ▼
                           PROTOTYPE
                               │
                               ▼
                    VALIDATION / EVIDENCE
                               │
                               ▼
                     ENGINEERING DECISION
                               │
                               ▼
                   PRODUCT SPECIFICATION
                               │
                               ▼
                       WBS / OBS / CBS
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


        ┌──────────────────────────────────────────┐
        │             TRANSVERSAL                  │
        │                                          │
        │  TRACEABILITY                            │
        │  VALIDATION                              │
        │  UNCERTAINTY MANAGEMENT                  │
        │  CHANGE / FEEDBACK                       │
        │  DECISION EVIDENCE                       │
        └──────────────────────────────────────────┘
```

---

# 43. Guiding Principle

The method can ultimately be reduced to one statement:

> **Semantic Systems Engineering is a controlled process for transforming product intent into a validated and executable system while progressively reducing requirement, model, and implementation uncertainty through engineering decomposition, prototyping, evidence-based decision making, and controlled feedback.**

For the ENGIE BESS project:

> **First define what the BESS system means from an engineering perspective. Then define how physical behavior, markets, data, forecasting, operations, and finance interact. Then design the architecture. Then prototype the uncertain technical assumptions. Use evidence to select the appropriate computational techniques. Only then progressively establish the product specification, work structure, organizational responsibilities, cost baseline, and implementation.**

The essential transformation is therefore:

**Meaning → Model → Architecture → Prototype → Evidence → Decision → Specification → Execution → Validation**

Not:

**Requirements → Documents → Code**

And not:

**Prompt → Code → Hope**

The purpose of the methodology is to preserve the meaning of the product while progressively transforming it from an idea into a **validated, traceable, executable system**.

