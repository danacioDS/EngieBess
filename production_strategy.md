# Estrategia de Producción

**BESS Operational & Financial Modeling Solution**
**ENGIE — RFP-264144-1**

---

## 1. Principio Rector

> **El código es una consecuencia del diseño semántico — nunca el lugar donde se descubre el significado del sistema.**

La producción del sistema sigue una cadena de derivación estricta donde cada artefacto es consecuencia formal del anterior:

```
BUSINESS OBJECTIVE
       ↓
INTENT REQUIREMENT
       ↓
DOMAIN CONCEPT
       ↓
SEMANTIC RULE
       ↓
HLD
       ↓
LLD
       ↓
PRODUCT SPECIFICATION
       │
       ├── WBS
       ├── OBS
       └── CBS
       ↓
IMPLEMENTATION STRATEGY
       ↓
VALIDATION STRATEGY
       ↓
EVALUATION STRATEGY
```

**Ningún artefacto se define sin que su predecesor esté suficientemente maduro.** Esto no es waterfall rígido: es **autoridad semántica primero, implementación iterativa después**.

---

## 2. Domain Concept

### 2.1 Business Objective → Intent Requirement → Domain Concept → Semantic Rule

| Business Objective | Intent Requirement | Domain Concept | Semantic Rule |
|---|---|---|---|
| BO1: Evaluar viabilidad de proyectos BESS | IR1: Simular comportamiento operativo | DC1: BESSProject | Project invariants |
| BO2: Determinar estrategia operativa óptima | IR7: Optimizar dispatch | DC13: Dispatch | SOC bounds, exclusividad carga/descarga, conservación de energía |
| BO3: Cuantificar valor de revenue streams | IR2–IR6: Modelar value streams | DC11: ValueStream, DC21: ValueStreamResult | Revenue, Savings, Costs, Penalties, NetValue |
| BO4: Incorporar degradación | IR8: Modelar degradación | DC16: DegradationModel, DC17: DegradationState | SOH monótonamente decreciente |
| BO5: Evaluar desempeño financiero | IR9: Calcular NPV, IRR, payback | DC25: FinancialMetric | Trazabilidad a operational results |
| BO6: Comparar escenarios | IR10: Comparación de escenarios | DC18: Scenario | Reproducibilidad, versionado |

### 2.2 Entidades del Dominio

| Área | Entidades |
|---|---|
| **Project** | BESSProject, Site, Contract, ProjectConfiguration |
| **Asset** | BESSAsset, Battery, Inverter, PCS, Transformer, GridConnection |
| **Demand & Market** | LoadProfile, LoadForecast, Tariff, EnergyPrice, AncillaryServicePrice, DemandCharge, Market, MarketRule, GridConstraint |
| **Value Streams** | ValueStream, PeakShaving, DemandResponse, EnergyArbitrage, FrequencyRegulation, VoltageRegulation |
| **Operational** | OperatingStrategy, Dispatch, BatteryState, OperationalResult |
| **Optimization** | OptimizationProblem, OptimizationObjective, OptimizationConstraint, OptimizationSolution |
| **Degradation** | DegradationModel, DegradationState, DegradationEvent |
| **Financial** | Revenue, Cost, CashFlow, FinancialModel, FinancialMetric, ValueStreamResult |
| **Scenario & Simulation** | Scenario, Simulation, SimulationResult |

### 2.3 Reglas Semánticas Críticas

**Dispatch:**

Para cada intervalo \(t\):

\[
P_{charge,t} \geq 0
\]
\[
P_{discharge,t} \geq 0
\]
\[
SOC_{min} \leq SOC_t \leq SOC_{max}
\]

Exclusividad carga/descarga:

\[
P_{charge,t} \cdot P_{discharge,t} = 0
\]

Conservación de energía:

\[
SOC_{t+1} = SOC_t + \frac{\eta_c P_{charge,t} \Delta t - \frac{P_{discharge,t} \Delta t}{\eta_d}}{E_{nom} \cdot SOH_t}
\]

**ValueStreamResult:**

```
Revenue
Savings
Costs
Penalties
NetValue
```

> La contribución financiera se calcula según las reglas semánticas del value stream aplicable. El revenue no se asume no-negativo.

**OptimizationProblem:**

> El objetivo de optimización debe ser definido explícitamente por el escenario y la estrategia operativa.

**BatteryState:**

```
Degradation Model → SOH → Available Capacity → Available Power
```

---

## 3. HLD — High-Level Design

### 3.1 Derivación desde el Domain Model

| Domain Concept | HLD Component |
|---|---|
| DC1–DC2 (Project, Asset) | Configuration Layer |
| DC3–DC4 (Battery, BatteryState) | Asset Model |
| DC5–DC6 (Load, Forecast) | Demand Layer |
| DC7–DC10 (Market, Prices, Tariff) | Market Layer |
| DC11 (ValueStream) | Value Stream Layer |
| DC12–DC13 (Strategy, Dispatch) | Operational Layer |
| DC14–DC15 (Optimization) | Optimization Layer |
| DC16–DC17 (Degradation) | Degradation Layer |
| DC18–DC20 (Scenario, Simulation) | Scenario Layer |
| DC21–DC25 (Financial) | Financial Layer |
| DC26 (GridConstraint) | Grid Layer |

### 3.2 Arquitectura Conceptual

```
                    ┌──────────────────────┐
                    │    User / Business   │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │    Application / UI  │
                    └──────────┬───────────┘
                               │
          ┌────────────────────┼────────────────────┐
          ▼                    ▼                    ▼
    Scenario Engine      Modeling Engine       Reporting
          │                    │
          │          ┌─────────┼──────────┐
          │          ▼         ▼          ▼
          │       Forecast  Dispatch  Degradation
          │                    │
          │              Optimization
          │                    │
          └──────────────┬─────┘
                         ▼
                 Financial Engine
                         │
                         ▼
                  Results / Metrics
                         │
                         ▼
                 Data / Persistence
```

### 3.3 Flujo de Datos Conceptual

```
Configuration → Scenario → Simulation
                              │
                    ┌─────────┼──────────┐
                    ▼         ▼          ▼
                 Demand    Market    Asset
                    │         │          │
                    └─────────┼──────────┘
                              ▼
                      Operating Conditions
                              │
                              ▼
                      Operating Strategy
                              │
                              ▼
                     Optimization Problem
                              │
                              ▼
                     Optimization Solution
                              │
                              ▼
                          Dispatch
                              │
                              ▼
                       Battery State
                              │
                    ┌─────────┴──────────┐
                    ▼                    ▼
              Operational          Degradation
                Results               State
                    │                    │
                    └─────────┬──────────┘
                              ▼
                      ValueStreamResult
                              │
                              ▼
                         CashFlow
                              │
                              ▼
                    FinancialMetrics
```

---

## 4. LLD — Low-Level Design

### 4.1 Derivación desde el HLD

| HLD Component | LLD Components |
|---|---|
| Configuration Layer | ProjectConfigService, AssetConfigService |
| Demand Layer | LoadIngestionService, LoadForecastService |
| Market Layer | MarketIngestionService, PriceForecastService, TariffService |
| Value Stream Layer | PeakShavingService, ArbitrageService, DemandResponseService, FrequencyRegulationService, VoltageRegulationService |
| Operational Layer | StrategyService, DispatchService |
| Optimization Layer | OptimizationFormulator, OptimizationSolver |
| Degradation Layer | CalendarAgingModel, CycleAgingModel, SOHService |
| Scenario Layer | ScenarioService, SimulationService, ScenarioComparisonService |
| Financial Layer | RevenueService, CostService, CashFlowService, FinancialMetricService |
| Grid Layer | GridConstraintService |
| Application Layer | InputUI, ScenarioUI, VisualizationUI, ResultsUI |
| Reporting Layer | ReportService, ExportService |

### 4.2 Componentes Críticos

**DispatchService**
- Responsabilidad: Generar schedule de potencia que respete invariantes de DC13
- Inputs: Scenario, OperatingStrategy, OptimizationSolution, BatteryState
- Outputs: Dispatch
- Precondiciones: Scenario validado, SOH > 0, Solution factible
- Postcondiciones: SOC bounds, exclusividad, conservación de energía

**OptimizationSolver**
- Responsabilidad: Resolver problema respetando objetivo y restricciones definidas
- Inputs: OptimizationProblem, ObjectiveFunction, Constraints
- Outputs: OptimizationSolution
- Precondiciones: Problema bien formulado, objetivo explícito
- Postcondiciones: Solution factible, óptima, respeta restricciones

**DegradationService**
- Responsabilidad: Calcular evolución de SOH y capacidad disponible
- Inputs: Battery, Dispatch, Temperature, Time
- Outputs: DegradationState, SOH trajectory
- Precondiciones: Parámetros de degradación definidos
- Postcondiciones: SOH decreciente, AvailableCapacity = nominal × SOH

**FinancialMetricService**
- Responsabilidad: Calcular NPV, IRR, payback desde cash flows
- Inputs: CashFlow, FinancialAssumptions
- Outputs: FinancialMetric
- Precondiciones: CashFlow completo, assumptions definidos
- Postcondiciones: NPV = Σ discounted cash flows, IRR hace NPV = 0

### 4.3 Contratos entre Componentes

| Origen | Destino | Contrato |
|---|---|---|
| ScenarioService | SimulationService | Scenario → Simulation |
| SimulationService | OptimizationSolver | OptimizationProblem → OptimizationSolution |
| OptimizationSolver | DispatchService | OptimizationSolution → Dispatch |
| DispatchService | DegradationService | Dispatch → DegradationState |
| DegradationService | BatteryState | DegradationState → BatteryState |
| DispatchService | ValueStreamService | Dispatch → ValueStreamResult |
| ValueStreamService | FinancialService | ValueStreamResult → CashFlow |
| FinancialService | FinancialMetricService | CashFlow → FinancialMetric |

---

## 5. Product Specification

### 5.1 WBS — Work Breakdown Structure

**Distinción: Product Scope vs. 12-Week MVP**

```
Target Product Capability
        │
        ├── Required for 12-week delivery (MVP)
        ├── Optional / Phase-dependent
        └── Future extension
```

**MVP (12 semanas):**
- Data ingestion (técnico, carga, mercado, financiero)
- Load forecasting básico
- BESS operational model (peak shaving + arbitrage)
- Degradation model (calendar + cycle aging básico)
- Financial model (NPV, IRR, payback)
- Scenario engine (definición, ejecución, comparación)
- Databricks App (input, configuración, visualización básica)
- Reporting (PDF/Excel básico)
- Validation (schema, invariants, benchmarks)
- Documentation & training

**Optional / Phase-dependent:**
- Demand response, frequency regulation, voltage regulation
- Monte Carlo, stochastic price scenarios
- Advanced visualization
- Tax incentives, financing structure

**WBS Detallado:**

```
1. Project Foundation
   1.1 Requirements validation
   1.2 Intent validation
   1.3 Domain modeling
   1.4 Semantic specification
   1.5 Architecture definition
   1.6 Vertical slice (peak shaving + financial)

2. Data Platform
   2.1 Data ingestion
   2.2 Data validation
   2.3 Data transformation
   2.4 Data quality controls

3. Load Forecasting
   3.1 Historical load analysis
   3.2 Forecasting methodology
   3.3 Forecast engine
   3.4 Forecast validation

4. BESS Operational Model
   4.1 Battery model
   4.2 SOC model
   4.3 Efficiency model
   4.4 Power constraints
   4.5 Grid constraints

5. Value Stream Models
   5.1 Peak shaving (MVP)
   5.2 Energy arbitrage (MVP)
   5.3 Demand response (optional)
   5.4 Frequency regulation (optional)
   5.5 Voltage regulation (optional)

6. Optimization
   6.1 Optimization formulation
   6.2 Objective functions
   6.3 Constraints
   6.4 Revenue stacking
   6.5 Solver implementation
   6.6 Optimization validation

7. Degradation
   7.1 Calendar aging
   7.2 Cycle aging
   7.3 SOH model
   7.4 EFC tracking
   7.5 Augmentation/replacement logic

8. Financial Model
   8.1 Revenue model
   8.2 Cost model
   8.3 Cash-flow model
   8.4 NPV
   8.5 IRR
   8.6 Payback
   8.7 Tax, financing, depreciation (optional)

9. Scenario Engine
   9.1 Scenario definition
   9.2 Scenario versioning
   9.3 Scenario execution
   9.4 Scenario comparison

10. Application
    10.1 Input interface
    10.2 Scenario configuration
    10.3 Simulation execution
    10.4 Visualization
    10.5 Results exploration

11. Reporting
    11.1 Operational reports
    11.2 Financial reports
    11.3 Scenario comparison
    11.4 Export functionality

12. Validation
    12.1 Unit validation
    12.2 Model validation
    12.3 Benchmark validation
    12.4 Integration testing
    12.5 UAT

13. Deployment
    13.1 Production configuration
    13.2 Deployment
    13.3 Documentation
    13.4 Training
```

### 5.2 OBS — Organizational Breakdown Structure

```
Project / Technical Lead
│
├── Data Engineering
│   ├── Ingestion
│   ├── Transformation
│   └── Data Quality
│
├── Energy Modeling
│   ├── Load Forecasting
│   ├── BESS Modeling
│   └── Value Streams
│
├── Optimization
│   ├── Dispatch
│   ├── Revenue Stacking
│   └── Solver
│
├── Degradation Modeling
│
├── Financial Modeling
│
├── Application Engineering
│   ├── Databricks App
│   ├── Visualization
│   └── Reporting
│
└── Validation / QA
```

### 5.3 CBS — Cost Breakdown Structure

```
Labor
├── Project / Technical Leadership
├── Data Engineering
├── Energy Modeling
├── Optimization
├── Financial Modeling
├── Application Engineering
└── QA / Validation

Technology
├── Databricks
├── Cloud Infrastructure
├── Storage
├── Compute
├── Solver licenses (HiGHS / Gurobi)
└── Supporting Software

Data
├── Market Data
├── Forecast Data
└── External Data Sources

Delivery
├── Testing
├── Deployment
├── Documentation
└── Training

Contingency (15–20%)
```

### 5.4 Equipo y Esfuerzo Estimado

| Rol | Esfuerzo (semanas-persona) |
|---|---|
| Project / Technical Lead | 12 |
| Data Engineer | 8 |
| Energy Modeler | 10 |
| Optimization Engineer | 10 |
| Financial Modeler | 8 |
| Application Engineer | 10 |
| QA / Validation | 6 |
| **Total MVP** | **~64 semanas-persona** |

### 5.5 Criterios de Aceptación Cuantitativos

| Criterio | Umbral |
|---|---|
| Desviación de NPV vs. benchmark | < 5% |
| Desviación de IRR vs. benchmark | < 0.5 pp |
| Error de forecast de carga (MAPE) | < 5% |
| Error de forecast de precios (MAPE) | < 10% |
| Tiempo de ejecución por escenario anual | < 30 min |
| Cobertura de trazabilidad | 100% de outputs mayores |
| UAT | Aprobación formal de stakeholders |

---

## 6. Implementation Strategy

### 6.1 Principios

1. Semantic authority first, iterative implementation thereafter
2. Vertical slices: funcionalidad end-to-end temprano
3. Contract-driven development
4. Continuous validation desde el primer día
5. Traceability by design

### 6.2 Fases

| Fase | Semanas | Foco | Vertical Slice |
|---|---|---|---|
| **Phase 1 — Design** | 1–2 | Intent, Domain, Semantic, HLD, LLD | Peak shaving + financial |
| **Phase 2 — Development** | 3–9 | Modeling engine, optimization, degradation, financial, pipelines, application | Extender slice a MVP |
| **Phase 3 — Testing** | 10–11 | Validation, benchmarks, integration, UAT | Validar MVP |
| **Phase 4 — Deployment** | 12 | Deployment, documentation, training | Deploy MVP |

### 6.3 Vertical Slices

| Slice | Semanas | Contenido |
|---|---|---|
| **Slice 1** | 1–2 | Data ingestion mínimo, battery model básico, peak shaving, dispatch simple, financial básico |
| **Slice 2** | 3–5 | Load forecasting, energy arbitrage, optimización LP/MILP, revenue stacking |
| **Slice 3** | 6–7 | Calendar aging, cycle aging, SOH feedback loop |
| **Slice 4** | 8–9 | Scenario engine, Databricks App, reporting |

### 6.4 Stack Tecnológico

| Capa | Tecnología |
|---|---|
| Data Ingestion | PySpark, Databricks |
| Data Storage | Delta Lake, PostgreSQL |
| Modeling Engine | Python, NumPy, Pandas |
| Optimization | HiGHS, Gurobi |
| Financial Model | Python, NumPy, Pandas |
| Application | Databricks App |
| Visualization | Plotly, Dash |
| Reporting | ReportLab, OpenPyXL |
| Testing | PyTest, Great Expectations |
| Orchestration | Databricks Workflows |

### 6.5 Gestión de Riesgos

| Riesgo | Prob. | Impacto | Mitigación |
|---|---|---|---|
| Datos de ENGIE no disponibles | Media | Alto | Fuentes alternativas; datos sintéticos |
| Calidad de datos de carga | Media | Alto | Validación robusta; flag anomalies |
| Complejidad de optimización | Alta | Medio | Prototipar MILP temprano; heuristic fallback |
| Acoplamiento degradación-optimización | Alta | Medio | Rolling horizon con linealización |
| Scope creep | Media | Alto | Congelar scope post-Fase 1 |
| Timeline 12 semanas | Alta | Alto | Vertical slices; priorizar MVP |
| Benchmark validation | Media | Alto | Identificar benchmarks en Fase 1 |
| UAT delays | Media | Medio | Involucrar stakeholders durante desarrollo |

---

## 7. Validation Strategy

> **Was the system implemented according to its specification?**

### 7.1 Niveles

| Nivel | Método |
|---|---|
| Unit Validation | PyTest, assertions |
| Contract Validation | Contract tests |
| Invariant Validation | Property-based testing |
| Integration Validation | Integration tests |
| Data Validation | Great Expectations |
| Model Validation | Benchmark comparison |
| Schema Validation | Pydantic, JSON Schema |

### 7.2 Invariantes Críticas

| Invariante | Componente |
|---|---|
| SOC_min ≤ SOC ≤ SOC_max | DispatchService |
| P_charge × P_discharge = 0 | DispatchService |
| SOH monótonamente decreciente | DegradationService |
| AvailableCapacity = nominal × SOH | BatteryState |
| NPV = Σ discounted cash flows | FinancialMetricService |
| IRR hace NPV = 0 | FinancialMetricService |
| Escenario reproducible | ScenarioService |

### 7.3 Criterios de Aceptación

- 100% de invariantes críticas validadas
- 100% de contratos entre componentes validados
- Desviación < 5% vs. benchmarks en NPV
- Desviación < 0.5 pp vs. benchmarks en IRR
- MAPE < 5% en load forecasting
- MAPE < 10% en price forecasting
- 100% de cobertura de trazabilidad
- UAT aprobado por stakeholders

---

## 8. Evaluation Strategy

> **Does the resulting model provide sufficiently accurate and useful results for the intended business purpose?**

### 8.1 Niveles

| Nivel | Método |
|---|---|
| Model Accuracy | Benchmark comparison |
| Operational Validity | Expert review |
| Financial Validity | Stakeholder review |
| Scenario Validity | Stakeholder review |
| Business Value | Stakeholder acceptance |

### 8.2 Métricas

| Métrica | Umbral |
|---|---|
| Desviación de NPV | < 5% |
| Desviación de IRR | < 0.5 pp |
| MAPE de load forecast | < 5% |
| MAPE de price forecast | < 10% |
| Tiempo de ejecución | < 30 min/escenario |
| Cobertura de trazabilidad | 100% |

### 8.3 Criterios de Éxito

1. El sistema representa el dominio BESS acordado consistentemente
2. Produce resultados reproducibles desde escenarios definidos
3. Respeta restricciones físicas y operativas
4. Modela correctamente los value streams aplicables
5. Considera la degradación de la batería
6. Produce outputs financieros trazables
7. Cumple con benchmarks establecidos
8. Completa UAT exitosamente
9. Proporciona interfaz comprensible
10. Puede ser operado, mantenido y extendido por ENGIE

---

## 9. Traceability Framework

```
Business Objective
       ↓
Intent Requirement
       ↓
Domain Concept
       ↓
Semantic Rule
       ↓
HLD Component
       ↓
LLD Specification
       ↓
WBS Work Package
       ↓
Implementation
       ↓
Validation Test
       ↓
Evaluation Result
```

**Preguntas que responde:**
- Why does this component exist?
- Which requirement does it satisfy?
- Which domain concept does it implement?
- Which semantic rule governs it?
- How is it validated?
- What business objective does it support?

---

## 10. Governance of Semantic Change

```
Business Requirement Change
          ↓
Intent / Scope
          ↓
Domain Model
          ↓
Semantic Rules
          ↓
HLD
          ↓
LLD
          ↓
WBS
          ↓
Implementation
          ↓
Tests
```

> **Los cambios de implementación no deben redefinir silenciosamente la semántica de negocio.**

---

## 11. Principio de Arquitectura Final

> **The software implementation should be a consequence of the domain semantics, not a substitute for them.**

```
WHY
│
├── Business purpose
├── Business problem
├── Users
└── Boundaries
       │
       ▼
WHAT EXISTS
│
├── Projects
├── Assets
├── Markets
├── Value Streams
├── Operations
├── Optimization
├── Degradation
├── Finance
└── Scenarios
       │
       ▼
WHAT DOES IT MEAN
│
├── Definitions
├── Properties
├── Invariants
├── Constraints
└── Semantic Rules
       │
       ▼
HOW IS IT STRUCTURED
│
└── HLD
       │
       ▼
HOW DOES IT BEHAVE
│
└── LLD
       │
       ▼
WHAT MUST BE BUILT
│
└── Product Specification
       │
       ├── WBS
       ├── OBS
       └── CBS
       │
       ▼
IMPLEMENTATION
       │
       ▼
VALIDATION
       │
       ▼
EVALUATION
       │
       ▼
DELIVERY & EVOLUTION
```

---

**Documento preparado para ENGIE — RFP-264144-1**
**Estrategia de Producción v1.0**
**Septiembre 2026**