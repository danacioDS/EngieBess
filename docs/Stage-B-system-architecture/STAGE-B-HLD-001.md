# Sí — B.0 debe tener un nivel de abstracción similar a `SYS-ENG-DEF-001`

Tienes toda la razón. Mirando `SYS-ENG-DEF-001` v0.6 como referencia, veo el nivel correcto:

| Aspecto | `SYS-ENG-DEF-001` v0.6 | Mi B.0 v0.2 | Nivel correcto |
|---|---|---|---|
| **¿Qué es?** | Eagle-eye view de los dominios | Demasiado detallado en algunas secciones | **Similar a `SYS-ENG-DEF-001`** |
| **Abstracción** | Alta, conceptual | Media, con pseudocódigo | **Alta** |
| **Longitud** | ~800 líneas | ~1200 líneas | **Más conciso** |
| **Detalle** | Boundaries, responsabilidades, interfaces | Demasiado específico | **Conceptual** |

**Conclusión:** Mi B.0 v0.2 tiene **exceso de detalle** en algunas secciones. Debe tener un nivel similar a `SYS-ENG-DEF-001`: alto nivel, conceptual, claro, sin pseudocódigo.

---

## 1. Lo que B.0 debe tomar de `SYS-ENG-DEF-001`

### 1.1 Estructura

`SYS-ENG-DEF-001` tiene esta estructura:

| Sección | Contenido | Nivel |
|---|---|---|
| §1 | Purpose | Meta |
| §2 | Position in framework | Contexto |
| §3 | System-level view | Diagrama alto nivel |
| §4 | The seven domains | Tabla de dominios |
| §5 | System Context operationalization | Cómo entra el contexto |
| §6–12 | Domain-by-domain | 1 sección por dominio |
| §13 | Inter-Domain Contract | Tabla de contratos |
| §14 | Core Feedback Loop | Diagrama del loop |
| §15 | Domain Summary Table | Tabla resumen |
| §16 | What is NOT defined | Boundaries |
| §17 | Engineering Sequence | Diagrama de secuencia |
| §18 | System-Level Definition | Definición corta |
| §19 | Design Principle | Principio |
| §20 | Next Steps | Status |

**B.0 debe tener una estructura similar:**

| Sección | Contenido | Nivel |
|---|---|---|
| §1 | Purpose of B.0 | Meta |
| §2 | Position in Stage B | Contexto |
| §3 | Architectural View | Diagrama alto nivel |
| §4 | The Functional Components | Tabla de componentes |
| §5 | Cross-Cutting Capabilities | Tabla de capabilities |
| §6–12 | Component-by-component | 1 sección por componente |
| §13 | Component Interfaces | Tabla de interfaces |
| §14 | State and Feedback | Modelo de estado |
| §15 | Component Summary Table | Tabla resumen |
| §16 | What is NOT defined | Boundaries |
| §17 | Architectural Sequence | Diagrama de secuencia |
| §18 | Architectural Definition | Definición corta |
| §19 | Architectural Principle | Principio |
| §20 | Next Steps | Status |

### 1.2 Nivel de detalle

`SYS-ENG-DEF-001` define cada dominio con:

- **Purpose** (1 párrafo)
- **Primary Responsibility** (tabla)
- **Inputs and Outputs** (tabla)
- **Boundary** (tabla)

**No incluye:**
- Pseudocódigo
- Diagramas de flujo detallados
- Ejemplos específicos
- Implementación

**B.0 debe hacer lo mismo para cada componente:**

- **Purpose** (1 párrafo)
- **Primary Responsibility** (tabla)
- **Inputs and Outputs** (tabla)
- **Boundary** (tabla)

### 1.3 Diagramas

`SYS-ENG-DEF-001` usa diagramas ASCII simples:

- Diagrama de System Context
- Diagrama de dominios
- Diagrama de feedback loop

**B.0 debe usar diagramas similares:**

- Diagrama de arquitectura integrada
- Diagrama de componentes
- Diagrama de feedback loop

**NO diagramas de flujo detallados.**

---

## 2. Lo que mi B.0 v0.2 tiene en exceso

| Sección | Problema | Corrección |
|---|---|---|
| §3.1 Integrated Architecture | Diagrama complejo | Simplificar |
| §3.4 System Data Flow | Demasiado detallado | Suavizar |
| §3.4.2 BTM/FTM branches | Específico | Conceptualizar |
| §3.5.4 Execution Order | Pseudocódigo | Eliminar |
| §3.6.4 Logical Persistence | Menciona "logical persistence requirements" | Simplificar |
| §3.7.3 Dependency Rules | Demasiado específico | Simplificar |
| §3.10 ADR Log | 5+ ADRs detallados | Reducir |

---

## 3. B.0 v0.3 — Nivel correcto

Voy a reescribir B.0 con el nivel correcto, similar a `SYS-ENG-DEF-001`. La estructura sería:

---

# STAGE-B-HLD-001 — System Architecture (HLD)

## §3 — B.0 Integrated System Architecture (v0.3)

**Document ID:** STAGE-B-HLD-001

**Version:** 0.3 — Draft (Corrected to `SYS-ENG-DEF-001` level)

**Section:** §3 — B.0 Integrated System Architecture

**Status:** Stage B — Draft for Review

**Parent Documents:**
- `SYS-STR-FRM-001` v0.9
- `SYS-ENG-DEF-001` v0.6
- A.2.1 v1.3, A.2.2 v1.3, A.2.3 v1.4, A.2.4 v1.0
- A.2.5 v0.4, A.2.6 v0.3, A.2.7 v0.3
- `PH1-REG-001` v1.1
- `STAGE-B-HLD-INDEX-001` v0.1

---

## 1. Purpose of B.0

B.0 is the **architectural contract** of the system. It defines **how the engineering model of Stage A is represented computationally**.

It establishes:

- What architectural **components** exist
- What **cross-cutting capabilities** span them
- How **data flows** through the system
- How **execution flows** through the system
- How **state evolves** and is owned
- How **components interact**
- How the **System Context propagates**
- What decisions are **inherited** from Stage A
- What decisions belong to **B.1–B.6**

B.0 **does not** define:

- Class structures
- Physical schemas
- API schemas
- Optimization equations
- Cash-flow equations
- Storage technology
- Databricks execution topology
- Code

B.0 answers:

> **How is the engineering model of Stage A represented computationally?**

---

## 2. Position Within Stage B

B.0 sits at the beginning of Stage B. It is the **architectural contract** that B.1–B.6 will detail.

| View | Depends on B.0 | Detail Level |
|---|---|---|
| B.0 | — | Architectural contract |
| B.1 Data Architecture | B.0 | Data details |
| B.2 Model Architecture | B.0 | Component details |
| B.3 Optimization Architecture | B.0 | Dispatch details |
| B.4 Financial Architecture | B.0 | Financial details |
| B.5 Software Architecture | B.0 | Software details |
| B.6 Databricks Architecture | B.0 | Platform details |

**Rule:** B.0 constrains B.1–B.6. No view can contradict B.0.

---

## 3. Architectural View

### 3.1 Two Orthogonal Dimensions

The architecture has **two orthogonal dimensions**:

**Dimension 1 — Functional components** (the computational engines):

```
BESS Model · Load & Market Model · Tariff Engine
Operational Model · Dispatch Engine · Degradation Engine · Financial Engine
```

**Dimension 2 — Cross-cutting capabilities** (span the functional components):

```
Scenario Management · Configuration · Validation
Execution Control · Lineage · Observability
```

### 3.2 Conceptual Architecture

```
                    USER / APPLICATION
                           │
                           ▼
              APPLICATION & REPORTING
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
  ┌───────────┐      ┌───────────┐      ┌───────────┐
  │ SCENARIO  │      │VALIDATION │      │EXECUTION  │
  │   MGMT    │      │           │      │  CONTROL  │
  └─────┬─────┘      └─────┬─────┘      └─────┬─────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                           ▼
              ENGINEERING COMPONENTS
        ┌──────────────────────────────────────┐
        │  BESS Model                          │
        │  Load & Market Model                 │
        │  Tariff Engine                       │
        │  Operational Model                   │
        │  Dispatch Engine                     │
        │  Degradation Engine                  │
        │  Financial Engine                    │
        └──────────────────┬───────────────────┘
                           │
                           ▼
                DATA & EXECUTION STATE
                           │
                           ▼
                EXTERNAL DATA SOURCES
```

**Note:** Cross-cutting capabilities **span** the engineering components. They are not a "layer".

### 3.3 Key Distinctions

| Concept | Definition | Count |
|---|---|---|
| **Functional components** | Computational engines | 7 |
| **Cross-cutting capabilities** | Capabilities that span components | 6 |
| **Stage A domains** | Engineering domains | 7 |
| **Technical layers** | Infrastructure | 3 |

**Rule:** These are **not** the same thing.

---

## 4. The Functional Components

The system has **7 functional components**:

| # | Component | Primary Question |
|---|---|---|
| 1 | **BESS Model** | What can the physical BESS do? |
| 2 | **Load & Market Model** | What external conditions exist? |
| 3 | **Tariff Engine** | What is the customer bill with/without BESS? |
| 4 | **Operational Model** | How can each value stream use the BESS? |
| 5 | **Dispatch Engine** | How should the BESS be dispatched? |
| 6 | **Degradation Engine** | How does operation change the battery? |
| 7 | **Financial Engine** | What economic value results? |

---

## 5. Cross-Cutting Capabilities

The system has **6 cross-cutting capabilities**:

| # | Capability | Purpose |
|---|---|---|
| C1 | **Scenario Management** | Parameterize and orchestrate scenarios |
| C2 | **Configuration** | Manage parameters, defaults, overrides |
| C3 | **Validation** | Ensure correctness at 4 levels |
| C4 | **Execution Control** | Coordinate execution flow |
| C5 | **Lineage** | Track data and decisions |
| C6 | **Observability** | Logs, metrics, traces |

---

## 6. Component 1 — BESS Model

### 6.1 Purpose

Represent the **physical and technical state of the battery energy storage system** computationally, establishing the physical capabilities and constraints that any operational strategy or optimization must respect.

### 6.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Physical state | SOC, SOH, availability |
| Physical envelope | Power, ramp, SOC bounds |
| Efficiency | Round-trip and conversion losses |
| Auxiliary consumption | Parasitic load |
| Interface to Degradation | State exchange |
| Interface to Dispatch | Envelope exchange |

### 6.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Technical parameters | Battery config, nominal capacity, power rating |
| **Inputs** | Operating limits | SOC bounds, power bounds, ramp limits |
| **Inputs** | Environmental | Temperature profile (input assumption) |
| **Inputs** | Policy | Augmentation/replacement policy (via Scenario Mgmt) |
| **Outputs** | State | SOC, SOH, availability |
| **Outputs** | Capability | Available energy, charge/discharge power |
| **Outputs** | Envelope | Feasible operating envelope |

### 6.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What can the physical BESS do? | What should the BESS do economically? |

**Reference:** Detailed in `A.2.1-BESS-ENG-001` v1.3.

---

## 7. Component 2 — Load & Market Model

### 7.1 Purpose

Represent the **external operating environment** computationally — the electricity demand, tariffs, market prices, grid conditions, program rules, and (as extension) generation signals that determine the BESS's potential value.

### 7.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Load | Historical, projected |
| Market | Prices, products |
| Programs | DR rules |
| Grid | Constraints |
| External context | All context signals |

### 7.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Load data | Historical meter data, projections |
| **Inputs** | Market data | Prices, products |
| **Inputs** | Program data | DR rules |
| **Inputs** | Grid data | Constraints |
| **Outputs** | Load signals | Short-horizon, multi-year |
| **Outputs** | Price signals | DA, RT, ancillary, capacity |
| **Outputs** | Program signals | DR events, rules |
| **Outputs** | Context signals | Aggregated external context |

### 7.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What is happening outside the BESS? | How should the BESS respond? |

**Reference:** Detailed in `A.2.2-LOAD-MKT-ENG-001` v1.3.

---

## 8. Component 3 — Tariff Engine

### 8.1 Purpose

Apply the customer tariff to a load profile to compute the **customer bill with and without BESS**, providing the source of truth for behind-the-meter savings.

### 8.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Tariff structure | TOU, demand charges, ratchets |
| Bill computation | With and without BESS |
| Savings by component | Demand, energy, export |

### 8.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Tariff structure | TOU, demand, energy charges |
| **Inputs** | Net load | From Dispatch |
| **Outputs** | Bill without BESS | By component |
| **Outputs** | Bill with BESS | By component |
| **Outputs** | Savings by component | Demand, energy, export |

### 8.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What is the customer bill with/without BESS? | How should the BESS be dispatched? |

**Note:** The Tariff Engine is activated only for BTM configurations. For FTM-only, market revenues flow directly to Financial Engine.

**Reference:** Detailed in `A.2.2-LOAD-MKT-ENG-001` §9.

---

## 9. Component 4 — Operational Model

### 9.1 Purpose

Define **how the BESS can be used to provide specific services** — the operational requirements each value stream imposes.

### 9.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Value streams | Peak shaving, DR, arbitrage, regulation, voltage |
| Requirements | SOC floors, duration floors, reserve requirements |
| Service metrics | What each service delivers |
| Interactions | Shared resources |

### 9.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | BESS capabilities |
| **Inputs** | External | Load, prices, programs |
| **Outputs** | Requirements | Per value stream |
| **Outputs** | Service metrics | Per value stream |
| **Outputs** | Interaction declarations | Shared resources |

### 9.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does each value stream use the BESS? | Which stream gets priority? |

**Reference:** Detailed in `A.2.3-OPS-ENG-001` v1.4.

---

## 10. Component 5 — Dispatch Engine

### 10.1 Purpose

Coordinate competing operational objectives under shared physical constraints.

### 10.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Selection | Which streams are active |
| Coordination | How streams share resources |
| Constraints | Physical, operational, market |
| SOC management | Maintain SOC within bounds |
| Attribution | Operational attribution basis |

### 10.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Physical | Envelope, SOC bounds |
| **Inputs** | External | Load, prices, programs |
| **Inputs** | Operational | Requirements |
| **Inputs** | Degradation | SOH, marginal signal |
| **Outputs** | Dispatch | Charge/discharge schedule |
| **Outputs** | State | SOC trajectory |
| **Outputs** | Net load | Post-dispatch |
| **Outputs** | Attribution | Operational attribution basis |

### 10.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How should the BESS be dispatched? | What is the physical battery? |

**Reference:** Detailed in `A.2.4-DISPATCH-ENG-001` v1.0.

---

## 11. Component 6 — Degradation Engine

### 11.1 Purpose

Represent the **evolution of battery capability over time** as a consequence of operation.

### 11.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Calendar aging | Time-dependent fade |
| Cycle aging | Throughput-dependent fade |
| State evolution | SOH, capacity, efficiency |
| Policy evaluation | Augmentation, replacement triggers |
| Marginal signal | Per-MWh degradation cost |

### 11.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operating history | Trajectories, throughput |
| **Inputs** | Environmental | Temperature, SOC |
| **Inputs** | Physical | Initial state |
| **Inputs** | Scenario | Replacement cost |
| **Outputs** | State | Updated SOH |
| **Outputs** | Signal | Marginal degradation cost |
| **Outputs** | Events | Augmentation, replacement |

### 11.4 Boundary

| Answers | Does Not Answer |
|---|---|
| How does operation change the battery? | What is the economic value of degradation? |

**Reference:** Detailed in `A.2.5-DEG-ENG-001` v0.4.

---

## 12. Component 7 — Financial Engine

### 12.1 Purpose

Translate operational behavior into **project-level economic performance**.

### 12.2 Primary Responsibility

| Aspect | Description |
|---|---|
| Investment | CAPEX, augmentation, replacement |
| Operating economics | O&M, costs |
| Revenue | Market + BTM savings |
| Cash flow | Annual net cash flow |
| KPIs | NPV, IRR, payback |

### 12.3 Inputs and Outputs

| Direction | Category | Items |
|---|---|---|
| **Inputs** | Operational | Dispatch results, attribution |
| **Inputs** | Degradation | Augmentation, replacement events |
| **Inputs** | Tariff | Bill outputs (BTM) |
| **Inputs** | Financial | Assumptions, financing, tax |
| **Outputs** | Revenue | Annual revenue by stream |
| **Outputs** | Cash flow | Annual net cash flow |
| **Outputs** | KPIs | NPV, IRR, payback |

### 12.4 Boundary

| Answers | Does Not Answer |
|---|---|
| What economic value results? | How does the battery operate? |

**Reference:** Detailed in `A.2.6-FIN-ENG-001` v0.3.

---

## 13. Component Interfaces

| From | To | Main Information |
|---|---|---|
| BESS Model | Operational | Physical capabilities |
| BESS Model | Dispatch | Feasible envelope |
| BESS Model | Degradation | Physical state |
| Load & Market | Operational | External conditions |
| Load & Market | Dispatch | Signals, prices, load |
| Load & Market | Financial | Bill outputs (BTM) |
| Operational | Dispatch | Requirements |
| Operational | Degradation | Behavior declarations |
| Dispatch | Degradation | Trajectories |
| Dispatch | Load & Market | Net load |
| Dispatch | Financial | Attribution basis |
| Degradation | BESS | Updated SOH |
| Degradation | Dispatch | Marginal signal |
| Degradation | Financial | Physical events |
| Tariff Engine | Financial | Savings (BTM) |
| Scenario Management | All | Configuration |
| Validation | All | Validation criteria |

---

## 14. State and Feedback

### 14.1 State Ownership

| State | State owner | Evolution owner |
|---|---|---|
| SOC | BESS Model | Dispatch |
| SOH | BESS Model | Degradation |
| Available capacity | BESS Model | Degradation |
| Cash flow | Financial | Financial |
| Augmentation history | Degradation | Degradation |

**Rule:** BESS owns the state representation; Degradation owns the evolution law; Dispatch owns the operational trajectory.

### 14.2 Core Feedback Loop

```
                    System Context
                          │
                          ▼
              Context-Derived Signals ─────┐
                                           │
              BESS Physical Capability ────┤
                                           ▼
                             Operational Requirements
                                           │
                                           ▼
                                      DISPATCH
                                           │
                                           ▼
                                    BESS OPERATION
                                           │
                                           ▼
                                     DEGRADATION
                                     ┌─────┴─────┐
                                     ▼           ▼
                            Future Capability   Marginal
                                                Degradation Cost
                                     │           │
                                     └─────┬─────┘
                                           ▼
                                        DISPATCH
                                           │
                                           ▼
                                     FINANCIAL VALUE
```

**Frequency:** Annual SOH update (PH-036).

---

## 15. Component Summary Table

| # | Component | Purpose | Key Inputs | Key Outputs | Boundary |
|---|---|---|---|---|---|
| 1 | BESS Model | Physical representation | Technical params, limits, temperature | State, envelope | What the BESS can do |
| 2 | Load & Market Model | External context | Load, market, program, grid data | Context signals | What is outside the BESS |
| 3 | Tariff Engine | Bill computation | Tariff, net load | Bill with/without BESS | What the bill is |
| 4 | Operational Model | Use-case behavior | Physical, external, rules | Requirements, metrics | How each stream uses BESS |
| 5 | Dispatch Engine | Coordination | Physical, external, operational, degradation | Dispatch, attribution | How to coordinate |
| 6 | Degradation Engine | Capability evolution | Operating history, environment | SOH, marginal signal, events | How usage changes battery |
| 7 | Financial Engine | Economic translation | Operational, degradation, tariff | Revenue, cash flow, KPIs | What value results |

---

## 16. What Is Deliberately NOT Defined Here

- Class structures
- Physical schemas
- API schemas
- Optimization equations
- Cash-flow equations
- Storage technology
- Databricks execution topology
- Application/service decomposition
- Code

---

## 17. Architectural Sequence

```
STAGE A — ENGINEERING DEFINITION
        │
        ▼
B.0 Integrated System Architecture (this document)
        │
        ▼
B.1 Data Architecture
        │
        ▼
B.2 Model Architecture
        │
        ▼
B.3 Optimization Architecture
        │
        ▼
B.4 Financial Architecture
        │
        ▼
B.5 Software Architecture
        │
        ▼
B.6 Databricks Architecture
        │
        ▼
Stage B → Stage C Handoff
```

---

## 18. Architectural Definition

> **The BESS Operational & Financial Modeling System is an integrated computational system organized into 7 functional components (BESS Model, Load & Market Model, Tariff Engine, Operational Model, Dispatch Engine, Degradation Engine, Financial Engine) and 6 cross-cutting capabilities (Scenario Management, Configuration, Validation, Execution Control, Lineage, Observability), operating within a System Context, connected through explicit interfaces, and executing through a causal chain that preserves the Dispatch ↔ Degradation feedback loop.**

---

## 19. Design Principle

> **Separate in responsibility, integrated in behavior.**

This is the same principle as Stage A, now applied to the architectural level.

---

## 20. Next Steps

**B.0 status:**

| Aspect | Status |
|---|---|
| B.0 Integrated System Architecture | ✅ Draft for Review (v0.3) |
| B.1 Data Architecture | ⏭ Next |
| B.2 Model Architecture | ⏭ Pending |
| B.3 Optimization Architecture | ⏭ Pending |
| B.4 Financial Architecture | ⏭ Pending |
| B.5 Software Architecture | ⏭ Pending |
| B.6 Databricks Architecture | ⏭ Pending |
| Stage B → Stage C Handoff | ⏭ Pending |

---

**End of §3 — B.0 Integrated System Architecture (v0.3)**

**Status:** Draft for Review

**Next:** B.1 Data Architecture

**Prepared by:** BESS Operational & Financial Modeling Consultant

**Engagement:** RFP-264144-1

---

