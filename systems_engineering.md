# Engineering Method for the Project
## BESS Operational & Financial Modeling — ENGIE

---

## 0. Guiding Principle

This project builds a traceable engineering system that is **partly phased and partly iterative**:

```
REQUIREMENT → ENGINEERING → SPECIFICATION → IMPLEMENTATION → VALIDATION
```

Each stage produces the inputs for the next, but stages overlap where the work is empirical (forecasting, optimization).

**Prototype/spike work is exploratory.** It is performed before the production specification solely to resolve uncertainty. Prototypes are not production code and are not delivered as part of the solution.

---

## 1. Methodological Sequence

```
ENGIE REQUIREMENTS
       │
       ▼
STAGE 0 — METHODOLOGY & PROJECT MANAGEMENT SETUP
       │
       ▼
STAGE 0.5 — REQUIREMENTS & SCOPE DEFINITION
       │
       ▼
CONCEPTUAL ENGINEERING
       │
       ├── BESS / Physical Engineering
       ├── Market Engineering
       ├── Data & Forecasting Engineering
       └── Financial Engineering
       │
       ▼
BASIC ENGINEERING
       │
       ▼
DETAILED ENGINEERING
       │
       ▼
PRODUCT SPECIFICATION
       │
       ├── Engineering Specification
       ├── Functional Requirements
       ├── Technical Requirements
       ├── Interfaces
       ├── Validation / Acceptance
       │
       └── Implementation & Work Breakdown
           ├── WBS
           ├── OBS
           └── CBS
       │
       ▼
IMPLEMENTATION PLANNING
       │
       ▼
IMPLEMENTATION
       │
       ├── AI-assisted implementation with human review
       ├── Code
       ├── Tests
       └── Deployment
       │
       ▼
CONTINUOUS VALIDATION
       │
       ▼
UAT / DEPLOYMENT
```

**Parallel tracks:**
- **Prototype / Spike Track (Weeks 1–4):** Data and solver feasibility, forecasting baseline. Feeds Basic and Detailed Engineering.
- **Requirements Traceability, Assumptions, Decisions, Change Control:** Active across all stages.
- **Validation / Testing:** Runs continuously throughout the project.

**Execution model:** The methodology is stage-gated at the baseline level, but execution is iterative within and across domains. Domains (BESS, Market, Data, Financial) progress through the stages on their own timelines, not in a single sequential pass.

---

## 2. Method Stages

### STAGE 0 — Methodology & Project Management Setup

**Objective:** Establish the working framework and project controls.

**Actions:**
- Define the engineering flow (Section 1).
- Define the deliverables per stage.
- Define the transition criteria between stages (time-boxed gate reviews).
- Capture the initial scope baseline from the ENGIE PDF.
- Set up on Day 1:
  - Baseline WBS (project work breakdown; refined in Stage 4)
  - Risk register
  - Change control process
  - Assumptions register
  - Decision log
  - Requirements Traceability Matrix (RTM)
- Agree with ENGIE the gate review turnaround and auto-proceed rule (Section 4).

**Deliverable:** Project Methodology & Project Management Plan.

**Exit criterion:** Approved by ENGIE at the **Scope Gate (end of Week 1)**, merged with Stage 0.5.

---

### STAGE 0.5 — Requirements & Scope Definition

**Objective:** Frame the biggest open questions before engineering begins. Establish the scope baseline.

**Key questions to resolve:**

| Question | Why it matters |
|----------|----------------|
| Who uses the tool? | Investment analyst, asset operator, or trader. Drives UI, outputs, validation. |
| Planning/investment tool or operational support? | Determines whether dispatch is advisory or real-time. |
| Which market or jurisdiction? | ERCOT, CAISO, a European TSO, Chile's SEN — each has different rules, products, and prices. |
| Which value streams are in scope? | Peak shaving and demand response are typically behind-the-meter; energy arbitrage and frequency regulation are typically front-of-meter; voltage regulation is often not a paid market. |
| What data exists and can it be accessed? | A data availability check is a prerequisite for forecasting and optimization. |

**Deliverable:** Requirements & Scope Definition Document, including:
- Users and use cases
- Jurisdiction and market scope
- Value streams in scope / out of scope
- Data availability and access assessment (what exists, who provides it, in what format, by when)
- High-level acceptance criteria
- Validation benchmarks, for example:
  - Perfect-foresight revenue upper bound
  - Historical backtest
  - Reconciliation against ENGIE's existing tool or spreadsheet
  - Cross-check against physical limits (SOC bounds, cycle counts)

**Exit criterion:** Approved by ENGIE at the **Scope Gate (end of Week 1)**, merged with Stage 0. **Scope baseline established.** Changes after this point are managed through change control.

---

### STAGE 1 — Conceptual Engineering

**Question it answers:** What is the product and what must it represent?

**Objective:** Build the complete conceptual model of the product across the four domains and their relationships. Architecture constraints (Databricks, Python) are captured here.

**Document structure:**

```
1. Product Engineering Scope
2. BESS / Physical Engineering
   2.1 Concepts
   2.2 Entities
   2.3 States
   2.4 Parameters
   2.5 Constraints
   2.6 Behaviors
3. Market Engineering
   3.1 Markets
   3.2 Market Products
   3.3 Market Rules
   3.4 Prices & Signals
   3.5 Revenue Streams
   3.6 Revenue Stacking
4. Data & Forecasting Engineering
   4.1 Data Sources
   4.2 Time Series
   4.3 Forecasts
   4.4 Scenarios
   4.5 Data Quality
   4.6 Uncertainty
5. Financial Engineering
   5.1 CAPEX
   5.2 OPEX
   5.3 Revenues
   5.4 Degradation Cost
   5.5 Cash Flow
   5.6 Investment Metrics
   5.7 Sensitivity / Scenarios
6. Cross-Domain Relationships
7. Engineering Inputs / Outputs
8. Architecture Constraints (Databricks, Python, solver implications)
9. Engineering Questions
```

**Domains to cover:**

**A. BESS / Physical Engineering**
- What must the model represent for it to be physically valid as a BESS?
- Entities: Battery, PCS, Energy Capacity, Power Capacity, SOC, SOH, Efficiency, Degradation, Availability, Operating Limits, Operating States, Constraints.

**B. Market Engineering**
- In which markets can the BESS operate, under what rules and economic opportunities?
- Value streams: Peak Shaving, Demand Response, Energy Arbitrage, Frequency Regulation, Voltage Regulation.
- The specific market or jurisdiction defined in Stage 0.5 is named here.

**C. Data & Forecasting Engineering**
- What information does the model need, and how does it represent data, forecasts, and scenarios?
- Includes load forecasting, price forecasting, data quality, missing data, uncertainty.

**D. Financial Engineering**
- How is the operational behavior of the BESS transformed into financial results?
- Includes CAPEX, OPEX, revenues, degradation cost, cash flow, financing, investment metrics (NPV, IRR, payback), sensitivity.

**Cross-domain relationships:**

```
                 DATA
              /    │    \
             ▼     ▼     ▼
          BESS   MARKET FINANCIAL
             │     │     │
             └─────┼─────┘
                   ▼
          INVESTMENT ANALYSIS
```

```
BESS PHYSICAL
      │ physical constraints
      ▼
MARKET
      │ dispatch / prices / revenues
      ▼
FINANCIAL
      │ economic result
      ▼
INVESTMENT ANALYSIS
```

**Deliverable:** Document **BESS Operational & Financial Modeling — Conceptual Engineering**.

**Exit criterion:** The four domains are conceptually defined, their relationships are mapped, architecture constraints are captured, and no fundamental questions remain unresolved.

---

### STAGE 2 — Basic Engineering

**Question it answers:** How must it work?

**Objective:** Transform the concepts from Conceptual Engineering into functional models (without equations or code).

**Transformation example:**

Conceptual:
```
SOC
```

Basic Engineering:
```
SOC Model
├── Inputs
├── State
├── Calculation
├── Constraints
├── Outputs
└── Operating Behavior
```

Conceptual:
```
Revenue Stacking
```

Basic Engineering:
```
Revenue Stack Model
├── Market A
├── Market B
├── Market C
├── Priority Rules
├── Dispatch Allocation
├── Conflicts
└── Revenue Calculation
```

**Models to define:**

```
BESS → Models
Market → Models
Data → Models
Financial → Models
```

**Interactions between models:**
- How the dispatch model consumes the market model
- How the degradation model affects the financial model
- How forecasting feeds the optimizer

**Deliverable:** Document **Basic Engineering — Functional Models**.

**Exit criterion:** Each model has defined inputs, outputs, behavior, and relationships.

---

### STAGE 3 — Detailed Engineering

**Question it answers:** How is it built exactly?

**Objective:** Reach the construction level. The design is complete enough to hand off with the instruction: "Build exactly this."

**Structure per model:**

```
SOC MODEL
   │
   ├── Equations
   ├── Parameters
   ├── State Variables
   ├── Boundary Conditions
   ├── Constraints
   ├── Algorithm
   ├── Inputs
   ├── Outputs
   └── Validation Tests
```

**Apply to:**
- BESS models (SOC, SOH, degradation, efficiency, limits)
- Market models (prices, dispatch, revenue stacking)
- Forecasting models (load, price, renewables)
- Financial models (cash flow, NPV, IRR)
- Optimization (LP, MILP, heuristic, hybrid)
- Interfaces between models

**Deliverable:** Document **Detailed Engineering — Model Specifications**.

**Exit criterion:** Each model has equations, parameters, algorithms, interfaces, and validation tests defined.

---

### STAGE 4 — Product Specification

**Question it answers:** What exactly is the product that will be built?

**Objective:** Consolidate the results of Detailed Engineering into an integrated product baseline.

**Detailed Engineering → technical truth.**
**Product Specification → integrated product baseline.**

**Structure:**

```
PRODUCT SPECIFICATION
│
├── 1. Product Definition
├── 2. System Scope & Boundaries
├── 3. BESS Engineering Specification
├── 4. Market Engineering Specification
├── 5. Data & Forecasting Specification
├── 6. Financial Engineering Specification
├── 7. Model Specifications
├── 8. Functional Requirements
├── 9. Technical Requirements
├── 10. Data Requirements
├── 11. Interfaces
├── 12. Validation Requirements
├── 13. Acceptance Criteria
├── 14. Architecture
└── 15. Implementation & Work Breakdown
    15.1 WBS
    15.2 OBS
    15.3 CBS
```

**WBS — Work Breakdown Structure**
Baselined in Stage 0; refined in Stage 4.

```
BESS Modeling Project
├── Project Management
│   ├── Risk Management
│   ├── Change Control
│   └── Stakeholder Communication
├── Requirements & Scope
├── BESS Engine
├── Market Engine
├── Data Engine
├── Forecasting
├── Financial Engine
├── Optimization
├── Integration
└── Validation
```

**OBS — Organization Breakdown Structure**
```
Project
├── BESS Engineering
├── Market Engineering
├── Data Engineering
├── Financial Engineering
├── Software Engineering
└── Validation
```

**CBS — Cost Breakdown Structure**
The CBS tracks actual cost against the contract budget.

```
Project Cost
├── Engineering
├── Development
├── Infrastructure
├── Testing
├── Deployment
└── Support
```

**Deliverable:** Complete **Product Specification** document.

**Exit criterion:** Specification approved by ENGIE. Refined WBS, OBS, and CBS defined.

---

### STAGE 5 — Implementation Planning

**Question it answers:** How is construction executed?

**Objective:** Transform the Product Specification into executable implementation units with full traceability.

**Sequence:**

```
PRODUCT SPECIFICATION
        ↓
WBS
        ↓
WORK PACKAGE
        ↓
ENGINEERING REQUIREMENT
        ↓
TECHNICAL DESIGN
        ↓
IMPLEMENTATION UNIT
        ↓
AI PROMPT (with human review)
        ↓
CODE
        ↓
TEST
```

**Traceability example:**

```
WBS
└── BESS Engine
     └── SOC Model
          └── SOC Calculation
               ├── Requirements
               ├── Equations
               ├── Inputs
               ├── Outputs
               ├── Constraints
               └── Tests
                        ↓
                  AI PROMPT
                        ↓
                     CODE
                        ↓
                     TEST
```

**Deliverable:** Implementation Plan with Work Packages, Implementation Units, and Prompts.

**Exit criterion:** Each implementation unit is traceable back to an ENGIE requirement through the RTM.

---

### STAGE 6 — Implementation & Continuous Validation

**Objective:** Build, test, deploy, and validate the product.

**Activities:**
- Development of the Python engine
- Construction of the Databricks App
- Data pipelines (ingestion, transformation, validation)
- Forecasting models
- Multi-value-stream operational models
- Dispatch optimization and revenue stacking
- Degradation models
- Integration with financial calculations
- Interactive dashboards
- Technical and methodological documentation
- Training for stakeholders

**Validation:**
- Model validation against the benchmarks defined in Stage 0.5
- Continuous validation: automated tests plus benchmark regression runs on each build
- User Acceptance Testing (UAT)
- Final deployment

**Deliverable:** Complete solution, documentation, training, deployment.

**Exit criterion:** UAT approved by ENGIE. Solution in production.

---

### PROTOTYPE / SPIKE TRACK (Weeks 1–4)

**Objective:** Resolve uncertainty before the affected models are specified.

**Activities:**
- Data quality and modeling-suitability assessment (following the Stage 0.5 data availability and access check)
- Forecasting baseline prototype
- Optimization / solver feasibility test
- Architecture constraint validation (Databricks, Python)

**Deliverable:** Prototype Findings Report, including:
- Data quality and modeling-suitability assessment
- Solver feasibility result (LP, MILP, heuristic, or hybrid)
- Forecasting baseline results
- Confirmed or revised architecture constraints

**Interim checkpoint (end of Week 2):** Early data and solver findings are delivered to the Basic Engineering team before the affected models are drafted.

**Exit criterion:** Findings are documented and fed back into Basic Engineering (Stage 2) and Detailed Engineering (Stage 3).

---

## 3. Complete Method Map

```
                 ENGIE REQUIREMENTS
                         │
                         ▼
              REQUIREMENTS & SCOPE BASELINE
                         │
                         ▼
                CONCEPTUAL ENGINEERING
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
      BESS             MARKET            DATA
        │                │                │
        └────────────────┼────────────────┘
                         ▼
                     FINANCIAL
                         │
                         ▼
                  BASIC ENGINEERING
                         │
                         ▼
                 DETAILED ENGINEERING
                         │
                         ▼
               PRODUCT SPECIFICATION
                         │
                         ▼
              IMPLEMENTATION PLANNING
                         │
                         ▼
                    IMPLEMENTATION
                         │
                         ▼
                 CONTINUOUS VALIDATION
                         │
                         ▼
                   UAT / DEPLOYMENT
```

**Parallel tracks across all stages:**

```
       ┌─────────────────────────────────┐
       │ PROTOTYPE / SPIKE TRACK         │
       │ Weeks 1–4                       │
       └─────────────────────────────────┘

       ┌─────────────────────────────────┐
       │ REQUIREMENTS TRACEABILITY       │
       │ + ASSUMPTIONS + DECISIONS       │
       │ + CHANGE CONTROL                │
       └─────────────────────────────────┘

       ┌─────────────────────────────────┐
       │ VALIDATION / TESTING            │
       │ continuous throughout project   │
       └─────────────────────────────────┘
```

**Note on the four domains:** BESS, Market, and Data feed Financial. Financial is a peer domain that consumes outputs from the other three, not a downstream step beneath them.

---

## 4. Alignment with ENGIE Contract Phases

| ENGIE Phase | Weeks | Method Stage | Notes |
|-------------|-------|--------------|-------|
| Phase 1 – Design | 1–2 | Stage 0, Stage 0.5, Conceptual Engineering, start of Basic Engineering | Prototype track starts. WBS, risk register, change control set up Day 1. Scope Gate at end of Week 1. |
| Phase 2 – Development | 3–9 | Basic Engineering (cont.), Detailed Engineering, Product Specification, Implementation Planning, Implementation | **Domains progress on their own timelines.** BESS engine leads; Market and Forecasting follow using spike findings. Implementation begins on a rolling basis as each domain passes its Detailed Gate. |
| Phase 3 – Testing | 10–11 | Validation + UAT | Continuous validation during development reduces end-stage risk. |
| Phase 4 – Deployment | 12 | Deployment + Documentation + Training | — |

### Gate Table (Rolling Baselines by Domain)

Gates are organized in two waves. Wave 1 covers the BESS engine (fewest unknowns). Wave 2 covers Market, Data/Forecasting, and Financial, informed by the spike findings.

| Gate | Week | Scope | What is approved |
|------|------|-------|------------------|
| **Scope Gate** | End of W1 | Project-wide | Stage 0 (methodology & PM setup) + Stage 0.5 (requirements, scope, data availability, acceptance criteria, validation benchmarks). Scope baseline established. |
| **BESS Conceptual + Basic Gate** | End of W3 | BESS domain | Conceptual and Basic Engineering for the BESS engine. |
| **BESS Detailed Gate** | End of W4 | BESS domain | Detailed Engineering for the BESS engine. **BESS implementation begins in W5.** |
| **Market / Data / Financial Conceptual + Basic Gate** | End of W5 | Market, Data, Financial | Conceptual and Basic Engineering for the remaining domains, informed by spike findings. |
| **Market / Data / Financial Detailed Gate** | End of W6 | Market, Data, Financial | Detailed Engineering for the remaining domains. |
| **Integrated Specification Gate** | End of W6 | Project-wide | Consolidated Product Specification (integrated baseline, refined WBS/OBS/CBS, acceptance criteria). |
| **Implementation Planning Gate** | End of W6 | Project-wide | Implementation Plan (work packages, implementation units, prompts, RTM linkage). Implementation proceeds on a rolling basis from W5 onward. |
| **UAT Gate** | End of W11 | Project-wide | User Acceptance Testing results and benchmark validation. |
| **Deployment Gate** | Start of W12 | Project-wide | Final delivery, deployment, documentation, training. Held at the start of W12 to allow the 3-business-day turnaround to complete within the contract. |

**Rolling baselines:** An approved domain may begin implementation before the integrated Specification Gate closes. The Specification Gate consolidates the domains; it does not gate each domain's start.

**Gate review turnaround:** Maximum 3 business days for ENGIE sign-off at each gate. If exceeded, the project proceeds on the current baseline with a documented assumption, subject to later revision. This rule is agreed with ENGIE in the contract or kickoff minutes.

**Named approvers:** Each gate has a named ENGIE approver, confirmed at kickoff. The 3-day turnaround applies to that approver.

---

## 5. Execution Principles

1. **Traceability at the function/unit level.** The Requirements Traceability Matrix (RTM) links requirements to functions, units, and tests.
2. **Stages are gated at the baseline level; execution is iterative within and across domains.** Domains progress through the stages on their own timelines, with rolling baselines.
3. **Prototypes are exploratory.** They resolve uncertainty before the production specification. Prototypes are not production code and are not delivered as part of the solution.
4. **Time-boxed gate reviews.** Each transition requires review and approval within a defined maximum turnaround, agreed with ENGIE.
5. **AI-assisted implementation with human review.** Prompts are derived from the technical specification, and every implementation unit is traceable back to an ENGIE requirement.
6. **Integrated and continuous validation.** Acceptance criteria and validation benchmarks are written alongside requirements. Each model has its own validation tests defined in Detailed Engineering. Continuous validation means automated tests plus benchmark regression runs on each build.
7. **Project management from Day 1.** WBS, risk register, change control, assumptions register, and decision log are established in Stage 0. The WBS is baselined in Stage 0 and refined in Stage 4. The CBS tracks actual cost against the contract budget.
8. **Living documentation.** Each stage produces documentation that feeds the next.

---

## 6. Open Items for the ENGIE Kickoff

These items require ENGIE input and are confirmed at kickoff:

1. **Gate review turnaround and auto-proceed rule:** Confirmation of the maximum 3 business days for sign-off, and the contractual basis for proceeding on the current baseline if the turnaround is exceeded.
2. **Named approvers per gate:** Identification of the ENGIE approver for each gate.
3. **Data access:** Which datasets ENGIE provides, in what format, and by when.
4. **Validation benchmarks:** Confirmation of the specific benchmarks (perfect-foresight upper bound, historical backtest, reconciliation against existing tools, physical limits cross-check).
5. **Market/jurisdiction scope:** Confirmation of the specific market(s) and value streams in scope.
6. **Users and use cases:** Confirmation of who uses the tool and whether it is a planning/investment tool or operational support.

---




