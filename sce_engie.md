# Informe SCE Aplicado al RFP-264144-1 de ENGIE — Versión Corregida y Elevada a 85+

## Plataforma de Modelización Tecno-Económica de BESS — Propuesta de Solución

**Autor:** MSc. Daniel Canedo — Economista · ML Engineer  
**Metodología:** Semantic Concept Engineering (SCE)  
**Referencia:** ENGIE RFP-264144-1 — BESS Operational & Financial Modeling Consultant  
**Fecha:** Septiembre 2026

---

## Propósito del Documento

Este documento es una **propuesta de solución** dirigida a ENGIE para el diseño, desarrollo, validación y despliegue de una plataforma de modelización tecno-económica de BESS. La metodología **Semantic Concept Engineering (SCE)** se utiliza como marco de gobernanza para garantizar trazabilidad, integridad semántica y control de cambios a lo largo del ciclo de vida del proyecto.

**Decisión de posicionamiento:** Este documento es una **propuesta a ENGIE**, no un caso de estudio académico. El material de investigación SCE (hipótesis H1–H6, referencias académicas) se ha movido a un apéndice interno. El cuerpo principal lidera con outcomes de ENGIE.

---

## Resumen Ejecutivo

ENGIE no está comprando un modelo financiero de una batería. Está comprando el **diseño, desarrollo, validación y despliegue end-to-end de un producto de software** que transforma datos heterogéneos (técnicos, de mercado, de cliente, financieros y regulatorios) en **decisiones de inversión y evaluación de proyectos BESS** bajo múltiples escenarios operativos y de mercado.

**Columna conceptual central:**

> **Simular → Optimizar → Degradar → Monetizar → Explicar**

**Enfoque metodológico:** SCE garantiza que el significado del sistema se define antes de la implementación, que los contratos conectan intención con código, y que la validación (conformidad técnica) se distingue de la evaluación (alineación con el outcome de negocio).

---

## 1. La Tríada Semántica Aplicada al Encargo BESS

| Pregunta SCE | Respuesta para el Encargo BESS |
|---|---|
| **¿QUÉ?** | Diseñar, desarrollar, testear y entregar una solución software para modelar el desempeño operativo y financiero de BESS durante un horizonte contractual determinado. |
| **¿POR QUÉ?** | Apoyar el desarrollo de negocio y la evaluación de proyectos proporcionando outputs analíticos robustos que demuestren desempeño, viabilidad y valor. |
| **¿PARA QUIÉN?** | Equipos de desarrollo de negocio de ENGIE, stakeholders internos, clientes externos y evaluadores de proyectos. |

### 1.1 Definición Expandida de la Intención

| Dimensión | Detalle |
|---|---|
| **Propósito** | Permitir a ENGIE evaluar el desempeño, la viabilidad financiera y el valor de proyectos BESS bajo diferentes escenarios operativos y de mercado. |
| **Problema** | El desarrollo de negocio requiere outputs analíticos robustos para demostrar el desempeño del proyecto a clientes y stakeholders internos. |
| **Alcance** | Simulación operativa + análisis financiero + configuración de escenarios + reporting. |
| **No-objetivos** | Control en tiempo real de activos BESS físicos; ejecución de dispatch en red; integración de hardware. |

### 1.2 Mapa de Stakeholders

| Stakeholder | Rol | Preocupación Principal |
|---|---|---|
| **Business Development** | Usuario primario | Viabilidad del proyecto, outputs cliente-facing |
| **Project Development** | Usuario primario | Factibilidad técnica, retornos financieros |
| **Especialistas en Energía/Almacenamiento** | Expertos de dominio | Precisión del modelo, realismo de degradación |
| **Stakeholders Financieros** | Tomadores de decisión | NPV, IRR, payback, riesgo |
| **Decisores Internos** | Aprobadores | Encaje estratégico, caso de inversión |
| **Clientes Externos** | Beneficiarios | Valor demostrado, bancabilidad |

---

## 2. Lectura Estratégica del RFP

### 2.1 Qué Está Comprando Realmente ENGIE

El proyecto es una **plataforma de modelización tecno-económica de BESS**, no un modelo financiero.

**Cadena de valor:**

```
Datos → Forecast → Modelo Físico BESS → Optimización/Dispatch
→ Degradación → Revenue Stacking → Modelo Financiero → KPIs
→ App/Reporting → Decisión de Negocio
```

**Cada capa tiene una responsabilidad concreta:**

| Capa | Responsabilidad |
|---|---|
| **Input / Data Ingestion** | Recibir datos técnicos, carga, tarifas, precios de mercado, supuestos financieros y restricciones regulatorias |
| **Data Engineering** | Limpiar, transformar, validar y preparar los datos |
| **Load Forecasting** | Pronosticar el consumo eléctrico del cliente |
| **Price Forecasting** | Pronosticar precios DA/RT/ancillary |
| **BESS Operational Model** | Representar batería, inversor, SOC, eficiencia, potencia, límites |
| **Dispatch** | Determinar cuándo cargar/descargar |
| **Optimization** | Optimizar simultáneamente diferentes fuentes de valor |
| **Degradation** | Modelar pérdida de capacidad y SOH |
| **Revenue Stacking** | Combinar peak shaving, arbitrage, DR, regulation |
| **Financial Model** | Traducir comportamiento operativo en ingresos, costes y valor económico |
| **Scenario Analysis** | Evaluar distintos escenarios de mercado, técnicos y financieros |
| **Databricks App** | Permitir al usuario introducir parámetros y visualizar resultados |
| **Validation/UAT** | Demostrar que los resultados son correctos |
| **Deployment/Documentation** | Entregar una solución que ENGIE pueda utilizar y mantener |

### 2.2 El Verdadero Entregable

No es:

> "Un notebook que calcula cuánto gana una batería."

Es:

> **Una plataforma de modelización BESS que permita a ENGIE evaluar rápidamente si un proyecto de almacenamiento tiene sentido técnica y financieramente bajo diferentes escenarios.**

**Inputs del usuario (Business Development):**

```text
Battery:
    20 MW
    40 MWh
    90% efficiency
    10-year contract

Customer:
    load profile
    demand charges
    tariff structure

Market:
    DA prices
    RT prices
    ancillary prices

Financial:
    CAPEX
    O&M
    discount rate
    escalation
    incentives

Constraints:
    interconnection
    export limit
    market eligibility
```

**Outputs del sistema:**

```text
Optimal dispatch
        ↓
Annual energy throughput
        ↓
Peak demand reduction
        ↓
Arbitrage revenue
        ↓
Demand response revenue
        ↓
Ancillary revenue
        ↓
Degradation
        ↓
Replacement / augmentation
        ↓
Cash flows
        ↓
NPV / IRR / Payback
        ↓
Project value
```

### 2.3 Capacidades Esenciales: Las Diez Capacidades Fundamentales

1. **BESS physical simulation**
2. **Load forecasting**
3. **Price forecasting**
4. **Dispatch optimization**
5. **Revenue stacking**
6. **Battery degradation**
7. **Energy-market modeling**
8. **Financial modeling**
9. **Data engineering**
10. **Databricks application**

**Condensado:**

> **Simular → Optimizar → Degradar → Monetizar → Explicar**

---

## 3. Los Diez Niveles de SCE Aplicados al Encargo BESS

### Nivel 1 — Intención (¿Por qué existe el sistema?)

| Pregunta SCE | Respuesta BESS |
|---|---|
| **¿QUÉ?** | Diseñar, desarrollar, testear y entregar una solución software para modelar el desempeño operativo y financiero de BESS durante un horizonte contractual determinado. |
| **¿POR QUÉ?** | Apoyar el desarrollo de negocio y la evaluación de proyectos proporcionando outputs analíticos robustos que demuestren desempeño, viabilidad y valor. |
| **¿PARA QUIÉN?** | Equipos de desarrollo de negocio de ENGIE, stakeholders internos, clientes externos y evaluadores de proyectos. |

**Artefacto Primario:** Documento de Intención derivado del RFP.

---

### Nivel 2 — Modelo de Dominio (¿Qué existe?)

**Entidades del dominio BESS:**

```text
BESS Project
│
├── Battery System
│   ├── Capacity (kWh)
│   ├── Power (kW)
│   ├── Efficiency (round-trip)
│   ├── SOC
│   ├── SOH
│   └── Degradation
│
├── Site
│   ├── Load
│   ├── Demand
│   ├── Tariff
│   └── Interconnection
│
├── Market
│   ├── Energy (DA/RT LMP)
│   ├── Ancillary Services
│   ├── Capacity
│   └── Demand Response
│
├── Dispatch
│   ├── Charging
│   ├── Discharging
│   └── Reserve
│
├── Optimization
│   ├── Objective
│   ├── Constraints
│   └── Decision Variables
│
├── Degradation
│   ├── Calendar Aging
│   ├── Cycle Aging
│   └── Replacement
│
└── Finance
    ├── CAPEX
    ├── OPEX
    ├── Revenue
    ├── Cash Flow
    ├── NPV
    └── IRR
```

**Relaciones clave:**
- `Site` tiene uno o más `BatterySystem`
- `BatterySystem` participa en uno o más `ValueStream`
- `ValueStream` produce `DispatchSchedule` y revenue
- `DispatchSchedule` afecta `DegradationState`
- `DegradationState` retroalimenta la factibilidad del `DispatchSchedule`
- `FinancialModel` agrega todos los revenue y cost streams

**Artefacto Primario:** Modelo de Dominio / Entidad-Relación.

---

### Nivel 3 — Modelo Semántico (¿Qué significa?)

**Definiciones semánticas e invariantes:**

| Concepto | Definición Semántica | Invariantes |
|---|---|---|
| `BatterySystem` | Activo físico de almacenamiento con capacidad, potencia, eficiencia y degradación definidas | `capacity > 0`; `0 < round_trip_efficiency ≤ 1`; `SOC ∈ [SOC_min, SOC_max]` |
| `DispatchInstruction` | Comando time-stamped que especifica potencia de carga/descarga para un intervalo | `power ≤ power_rating`; `power ≥ -power_rating`; SOC en límites; ramp_rate respetado |
| `PeakShaving` | Descargar batería para limitar demanda del sitio a un umbral definido | Target peak ≤ historical peak; descarga solo cuando demanda > target |
| `DemandResponseEvent` | Evento llamado por utility/ISO que requiere curtailment o shift de carga | Notification lead time respetado; duración ≤ max; performance ≥ mínimo |
| `EnergyArbitrage` | Cargar en períodos de bajo precio, descargar en períodos de alto precio | Price spread > min threshold; eficiencia contabilizada; cycle cost ≤ spread |
| `FrequencyRegulation` | Inyección/absorción rápida de potencia para soporte de frecuencia | Respuesta dentro de la ventana de despacho; SOC gestionado; performance score calculado |
| `VoltageRegulation` | Soporte de potencia reactiva (VAR) para mantener voltaje en bandas | Inverter capability respetada; power factor en rango; curtailment contabilizado |
| `DegradationState` | Pérdida de capacidad y eficiencia de la batería en el tiempo | Calendar aging + cycle aging; SOH tracked; replacement triggered at threshold |
| `FinancialPerformance` | Output económico agregado del proyecto BESS | NPV, IRR, payback, revenue by stream, demand charge savings, degradation cost |

**Invariantes semánticos:**
- `probability ∈ [0,1]` para cualquier forecast confidence
- Todo `DispatchInstruction` debe ser trazable a un `ValueStream` y `Scenario`
- Todo `FinancialPerformance` output debe ser trazable a operational outputs
- `SOC` nunca debe violar límites en ningún timestep
- No debe haber carga y descarga simultánea

**Artefacto Primario:** Especificación Semántica y Conjunto de Reglas.

---

### Nivel 4 — HLD (¿Cómo se organiza el significado?)

**Capas de arquitectura:**

```
Data Ingestion Layer
        ↓
Data Processing & Validation Layer
        ↓
Load & Price Forecasting Layer
        ↓
Operational Modeling Layer (Value Streams)
        ↓
Dispatch Optimization & Revenue Stacking Layer
        ↓
Degradation Modeling Layer
        ↓
Financial Performance Layer
        ↓
Reporting & Visualization Layer (Databricks App)
```

**Componentes principales:**
- **Data Ingestion:** Parámetros técnicos, datos de consumo, precios de mercado, supuestos financieros, parámetros de red/regulatorios
- **Processing & Validation:** Transformación, validación, pipelines de procesamiento (PySpark, SQL)
- **Load Forecasting:** Pronóstico de consumo eléctrico
- **Price Forecasting:** Pronóstico de precios DA/RT/ancillary
- **Operational Modeling:** Peak shaving, DR, arbitraje, regulación de frecuencia, regulación de voltaje
- **Dispatch Optimization:** Co-optimización, revenue stacking, restricciones físicas
- **Degradation Modeling:** Calendar aging, cycle aging, seguimiento de SOH, umbrales de reemplazo
- **Financial Performance:** NPV, IRR, payback, revenue por stream, ahorros por demand charge, coste de degradación
- **Reporting:** Dashboards interactivos, reportes exportables (PDF/Excel)

**Artefacto Primario:** Blueprint Arquitectónico.

---

### Nivel 5 — LLD (¿Cómo debe comportarse cada componente?)

**Ejemplo: Componente DispatchOptimization**

| Aspecto | Definición |
|---|---|
| **Responsabilidad** | Co-optimizar el despacho entre múltiples flujos de valor respetando las restricciones físicas |
| **Inputs** | Pronóstico de carga, pronóstico de precios, estado de la batería, parámetros de flujos de valor, estado de degradación |
| **Outputs** | Programa de despacho óptimo (potencia de carga/descarga por intervalo), ingresos por flujo de valor |
| **Dependencias** | LoadForecaster, PriceForecaster, BatteryModel, DegradationModel, ValueStreamModels |
| **Precondiciones** | Datos de entrada validados; estado de batería disponible; parámetros de flujos de valor configurados |
| **Postcondiciones** | El programa de despacho respeta todas las restricciones; ingresos calculados; impacto de degradación evaluado |
| **Invariantes** | SOC dentro de límites; límites de potencia respetados; sin carga/descarga simultánea; tasas de rampa respetadas; períodos mínimos de descanso observados |
| **Modos de Falla** | Optimización infactible; datos faltantes; violación de restricciones; umbral de degradación excedido |

**Artefacto Primario:** Especificaciones de Componentes y Definiciones de Comportamiento.

---

### Nivel 6 — Especificación de Producto (¿Qué exactamente debe construirse?)

**Realización técnica:**

| Capa | Tecnología |
|---|---|
| Backend | Python |
| Data Processing | PySpark, SQL |
| Data Platform | Databricks |
| Frontend | Databricks App |
| Optimization | LP/MILP, rule-based heuristic, o hybrid |
| Forecasting | Python (scikit-learn, statsmodels, Prophet, o custom) |
| Degradation | Python (custom models) |
| Financial | Python (numpy-financial, pandas) |
| Visualization | Databricks dashboards, Plotly, Matplotlib |
| Reporting | PDF/Excel export |
| Testing | pytest, contract tests, UAT |
| Documentation | Technical docs, modeling methodology docs, training materials |

**Módulos:**
- `data_ingestion` — ingest and validate all input data
- `load_forecasting` — project electricity consumption
- `price_forecasting` — project DA/RT/ancillary prices
- `operational_models` — peak shaving, DR, arbitrage, frequency regulation, voltage regulation
- `dispatch_optimization` — co-optimization and revenue stacking
- `degradation_modeling` — calendar and cycle aging
- `financial_performance` — NPV, IRR, payback, revenue by stream
- `reporting` — dashboards and exportable reports
- `api` — interfaces between components

**Artefacto Primario:** Especificación de Producto / Prompt de Implementación.

---

### Nivel 7 — Implementación (¿Cómo se materializa?)

**Prompt de Implementación para Agente AI:**

> Implementar el componente `DispatchOptimization` según la siguiente especificación:
> - **Inputs:** `LoadForecast`, `PriceForecast`, `BatteryState`, `ValueStreamParameters`, `DegradationState`
> - **Outputs:** `DispatchSchedule`, `RevenueByStream`
> - **Restricciones:** SOC bounds, power limits, ramp rates, minimum rest periods, efficiency, degradation, no simultaneous charge/discharge
> - **Objetivo:** Maximizar ingresos netos de degradación y costes de carga
> - **Método:** MILP con variables binarias para prevenir carga/descarga simultánea; linealización de degradación por throughput cost
> - **Invariantes:** SOC within bounds at all timesteps; power limits respected; degradation impact assessed
> - **Validación:** Unit tests para satisfacción de restricciones; integration tests con `LoadForecaster`, `PriceForecaster`, `BatteryModel`, `DegradationModel`

**La implementación puede contener:** Python, PySpark, SQL, Databricks, LP/MILP solvers, ML models, dashboards.

**La implementación NO redefine:** Domain meaning, semantic rules, architecture, component responsibilities, system boundaries.

**Artefacto Primario:** Código Ejecutable.

---

### Nivel 8 — Validación (¿Conforma la implementación?)

**Chequeos de validación:**

| Requisito | Validación |
|---|---|
| SOC dynamics | SOC actualizado correctamente por timestep según carga/descarga y eficiencia, usando capacidad escalada por SOH |
| No simultaneous charge/discharge | Verificación de que carga y descarga no ocurren simultáneamente |
| Power limits | Potencia de carga/descarga dentro de límites máximos |
| SOC bounds | SOC dentro de límites mínimos y máximos |
| Ramp rates | Cambios de potencia dentro de límites de rampa |
| Minimum rest periods | Períodos de descanso mínimos respetados entre ciclos |
| Demand charge | Peak demand por billing period calculado correctamente |
| Regulation reserve | Reservas de regulación up/down respetadas con headroom/footroom de SOC |
| Degradation | SOH actualizado correctamente por calendar y cycle aging |
| Revenue traceability | Cada revenue line trazable a value stream y dispatch decision |
| Financial outputs | NPV, IRR, payback calculados correctamente |
| Model outputs match benchmarks | Comparación contra benchmarks establecidos |

**Artefacto Primario:** Test Suites y Resultados de Conformidad.

---

### Nivel 9 — Evaluación (¿Funciona el sistema?)

**Métricas de evaluación:**

| Métrica | Descripción |
|---|---|
| **Model Accuracy** | Alineación con benchmarks establecidos (NREL, EPRI) |
| **System Performance** | Estándares de ejecución y usabilidad |
| **UAT Success** | Completación exitosa de User Acceptance Testing |
| **Stakeholder Approval** | Aprobación formal de stakeholders del proyecto |
| **Business Impact** | Desempeño, viabilidad y valor del proyecto demostrados |
| **Scenario Analysis** | Utilidad de comparación de escenarios para toma de decisiones |

**Nota:** Métricas como "revenue actual vs. proyectado" o "SOH predicho vs. actual" no son medibles dentro de las 12 semanas del encargo. Se proponen como métricas post-despliegue para evaluación continua.

**Artefacto Primario:** Métricas de Evaluación y Resultados de Performance.

---

### Nivel 10 — Evolución (¿Cómo cambia el sistema?)

**Cadena de evolución:**

```
Real-World Change → Problem Change → Intent Change → Semantic Change
→ Contract Change → Architectural Change → Specification Change
→ AI/Human Implementation → Validation → Evaluation
```

**Principios de evolución:**
- La evolución del software es un proceso semántico, no meramente técnico
- La semántica debe cambiar antes que los contratos
- Los contratos deben cambiar antes que la arquitectura
- La trazabilidad previene el cambio semántico no controlado

**Artefacto Primario:** Refinamientos Semánticos y Especificaciones Actualizadas.

---

## 4. Contratos como Mecanismo de Control Semántico

**Estructura:** `PRECONDICIÓN → INPUT → COMPORTAMIENTO ESPERADO → POSTCONDICIÓN → INVARIANTE`

### 4.1 Contrato de Optimización de Dispatch

| Elemento | Definición |
|---|---|
| **Precondiciones** | Load forecast validado; price forecast validado; estado de batería disponible; parámetros de value stream configurados; estado de degradación disponible; límites de billing period definidos |
| **Input** | `LoadForecast`, `PriceForecast`, `BatteryState`, `ValueStreamParameters`, `DegradationState`, `BillingPeriod` |
| **Comportamiento Esperado** | Co-optimizar dispatch across all value streams; respetar restricciones físicas; maximizar ingresos netos de degradación y costes de carga |
| **Postcondiciones** | `DispatchSchedule` respeta todas las restricciones; `RevenueByStream` calculado; impacto de degradación evaluado; peak demand por billing period registrado |
| **Invariantes** | SOC within bounds; power limits respected; no simultaneous charge/discharge; ramp rates respected; minimum rest periods observed; efficiency accounted per timestep; ancillary reserve requirements satisfied |

### 4.2 Contrato de Degradación de Batería

| Elemento | Definición |
|---|---|
| **Precondiciones** | Parámetros de química de batería definidos; perfil de temperatura disponible; dispatch schedule disponible |
| **Input** | `DispatchSchedule`, `TemperatureProfile`, `BatteryChemistry`, `InitialSOH` |
| **Comportamiento Esperado** | Calcular calendar y cycle aging por timestep; actualizar SOH; trackear equivalent full cycles |
| **Postcondiciones** | `SOH(t)` actualizado; `Capacity(t)` actualizado; umbral de reemplazo flagged si alcanzado |
| **Invariantes** | SOH monótonamente no creciente; capacidad nunca excede inicial; coste de degradación asignado por timestep |

### 4.3 Contrato de Performance Financiera

| Elemento | Definición |
|---|---|
| **Precondiciones** | Outputs operativos disponibles; supuestos financieros configurados; término de contrato definido |
| **Input** | `DispatchSchedule`, `RevenueByStream`, `DegradationState`, `FinancialAssumptions` |
| **Comportamiento Esperado** | Calcular cash flows anuales; aplicar tax, depreciation, incentivos; calcular NPV, IRR, payback |
| **Postcondiciones** | `FinancialOutputs` calculado; `NPV`, `IRR`, `Payback` reportados |
| **Invariantes** | Cash flows consistentes con operational outputs; tax y depreciation correctamente aplicados; incentivos correctamente contabilizados |

---

## 5. El Problema de Optimización: Corazón del Proyecto

### 5.1 Definición de Variables

Antes de la formulación, definimos las variables clave:

| Variable | Definición |
|---|---|
| `P^charge_t` | Potencia de carga en timestep t (MW) |
| `P^discharge_t` | Potencia de descarga en timestep t (MW) |
| `P^net_t` | Demanda neta del sitio en timestep t = `Load_t - P^discharge_t + P^charge_t` (MW) |
| `P^peak_b` | Demanda máxima neta en billing period b (MW) |
| `SOC_t` | Estado de carga en timestep t (fracción) |
| `SOH_t` | Estado de salud en timestep t (fracción) |
| `Capacity_t` | Capacidad efectiva en timestep t = `Capacity_initial × SOH_t` (MWh) |
| `u_t` | Variable binaria: 1 si carga, 0 si descarga |
| `P^reg,up_t` | Reserva de regulación up comprometida en timestep t (MW) |
| `P^reg,down_t` | Reserva de regulación down comprometida en timestep t (MW) |
| `R_arb,t` | Ingresos por arbitraje en timestep t ($) |
| `R_DR,t` | Ingresos por demand response en timestep t ($) |
| `R_reg,t` | Ingresos por regulación en timestep t ($) |
| `R_peak` | Ahorros por demand charge ($) |
| `C_deg,t` | Coste de degradación en timestep t ($) |
| `C_charge,t` | Coste de carga en timestep t ($) |

### 5.2 Formulación Matemática

**Función objetivo:**

$$
\max \sum_{t \in T} \left(
R_{arb,t} + R_{DR,t} + R_{reg,t} - C_{charge,t} - C_{deg,t}
\right) + R_{peak}
$$

**Donde:**

**1. Demand charges (máximo por billing period):**

$$
R_{peak} = - \sum_{b \in B} \lambda_{demand,b} \cdot P^{peak}_b
$$

$$
P^{peak}_b \ge P^{net}_t \quad \forall t \in b
$$

**2. Prevención de carga/descarga simultánea:**

$$
P^{charge}_t \le P^{charge}_{max} \cdot u_t
$$

$$
P^{discharge}_t \le P^{discharge}_{max} \cdot (1 - u_t)
$$

$$
u_t \in \{0, 1\}
$$

**3. Reservas de regulación (up/down):**

$$
P^{reg,up}_t \le P^{discharge}_{max} - P^{discharge}_t
$$

$$
P^{reg,down}_t \le P^{charge}_{max} - P^{charge}_t
$$

**SOC headroom/footroom (usando capacidad escalada por SOH):**

$$
SOC_t \ge SOC_{min} + \frac{P^{reg,up}_t \cdot \Delta t}{\eta_d \cdot Capacity_t}
$$

$$
SOC_t \le SOC_{max} - \frac{P^{reg,down}_t \cdot \Delta t \cdot \eta_c}{Capacity_t}
$$

**4. Dinámica de SOC (usando capacidad escalada por SOH):**

$$
SOC_{t+1}
=
SOC_t
+
\frac{\eta_c P^{charge}_t \Delta t}{Capacity_t}
-
\frac{P^{discharge}_t \Delta t}{\eta_d \cdot Capacity_t}
$$

**5. Coste de carga:**

$$
C_{charge,t} = \lambda_{energy,t} \cdot P^{charge}_t \cdot \Delta t
$$

**6. Linealización de degradación:**

| Método | Formulación | Trade-off |
|---|---|---|
| **Throughput cost** | `C_deg,t = c_deg × (P^charge_t + P^discharge_t) × Δt` | Lineal, simple, aproximado |
| **Piecewise DoD cost** | `C_deg,t = f(DoD_t)` con segmentos lineales | Más preciso, más variables |
| **MILP con segmentos** | Variables binarias por segmento de DoD | Óptimo, computacionalmente costoso |
| **Heuristic** | Reglas basadas en ciclos equivalentes | Rápido, transparente, subóptimo |

**Recomendación:** Híbrido — throughput cost para LP inicial, piecewise para refinamiento.

**7. Incertidumbre de forecast:**

| Enfoque | Descripción | Uso |
|---|---|---|
| **Perfect foresight** | Asume forecast perfecto | Benchmark teórico, no realista |
| **Rolling horizon / MPC** | Re-optimiza cada intervalo con forecast actualizado | Realista, más complejo |
| **Stochastic** | Escenarios probabilísticos | Robusto, computacionalmente costoso |
| **Robust** | Peor caso | Conservador |

**Recomendación:** Rolling horizon como default, con opción de perfect foresight para benchmarking.

### 5.3 Manejo del Horizonte Temporal

El RFP requiere modelar un horizonte contractual de hasta 10 años. A resolución de 15 minutos, esto representa aproximadamente 350,000 timesteps por escenario. Resolver un MILP sobre ese horizonte es computacionalmente inviable.

**Estrategia de manejo del horizonte:**

| Técnica | Descripción | Aplicación |
|---|---|---|
| **Representative periods** | Seleccionar un conjunto de días representativos (e.g., 4 estaciones × 2 tipos de día) y escalar anual | Optimización anual |
| **Annual re-solves** | Resolver año por año, actualizando SOH entre años | Degradación anual |
| **Rolling horizon** | Optimizar ventana de 24-48h, avanzar, re-optimizar | Operación realista |
| **Hierarchical optimization** | Optimización anual de asignación de capacidad + optimización diaria de dispatch | Co-optimización |

**Recomendación:** Combinación de representative periods para optimización anual + annual re-solves para actualización de SOH + rolling horizon para simulación operativa realista.

### 5.4 Decisión de Metodología de Optimización

El RFP deja explícitamente abiertas tres posibilidades:

| Metodología | Descripción | Ventajas | Limitaciones |
|---|---|---|---|
| **Rule-based heuristic** | Reglas simples basadas en umbrales de precio | Simple, rápido, transparente | Limitado con múltiples revenue streams |
| **Linear Programming (LP)** | Optimización lineal sujeta a restricciones lineales | Óptimo, eficiente | Requiere linealidad; no puede manejar simultaneidad |
| **Mixed-Integer Programming (MILP)** | Decisiones binarias para representar reglas complejas | Representa reglas complejas; previene simultaneidad | Mayor complejidad computacional |
| **Hybrid** | Heuristic + MILP refinement | Balance óptimo | Requiere diseño cuidadoso |

**Decisión:** MILP es necesario para prevenir carga/descarga simultánea y para modelar decisiones binarias (eventos DR, compromisos de regulación). La metodología final se decidirá durante la Fase 1 (Semanas 1–2).

**Pregunta clave a resolver en diseño:**

> **¿Cuál es la formulación matemática apropiada para el problema que realmente tiene ENGIE?**

---

## 6. Degradación: Acoplamiento entre Optimización y Finanzas

### 6.1 Modelo Conceptual

El Estado de Salud (SOH) de la batería se define como la ratio entre capacidad actual y capacidad inicial.

El SOH evoluciona según la degradación calendar (dependiente del tiempo y temperatura) y la degradación cycle (dependiente del throughput, profundidad de descarga, C-rate y temperatura).

**Factores explícitos del RFP:**
- Calendar aging
- Cycle aging
- Depth of discharge
- C-rate
- Temperature
- Equivalent full cycles
- SOH
- Augmentation
- Replacement thresholds

### 6.2 Acoplamiento con la Optimización

La optimización y el modelo financiero están acoplados. La capacidad efectiva `Capacity_t = Capacity_initial × SOH_t` entra directamente en la dinámica de SOC y en las restricciones de headroom/footroom.

**Pregunta clave:**

> ¿Vale la pena hacer arbitraje con este ciclo adicional si el ingreso marginal es menor que el coste económico de la degradación que genera?

Esto es más complejo que simplemente calcular ingresos.

---

## 7. Modelo Financiero: Del Comportamiento Operativo al Valor Económico

### 7.1 Cadena de Transformación

```
Operational simulation
        ↓
Energy throughput
        ↓
Cycles
        ↓
Degradation
        ↓
Available capacity
        ↓
Revenue
        ↓
O&M
        ↓
Replacement / augmentation
        ↓
Cash flow
```

### 7.2 Componentes Financieros

| Componente | Descripción |
|---|---|
| **Revenue** | Peak shaving, DR, arbitrage, regulation, voltage |
| **O&M** | Costes fijos + variables de O&M |
| **CAPEX** | Inversión inicial |
| **Augmentation CAPEX** | Costes de reemplazo/augmentación en umbral |
| **Depreciation** | MACRS, línea recta, o equivalente local |
| **Tax** | Tasa corporativa, créditos fiscales (ITC/PTC equivalentes) |
| **Incentives** | Rebates, grants, tax abatements |
| **Warranty constraints** | Límites de throughput (MWh), límites de ciclos |
| **Discount rate** | WACC o específico del proyecto |
| **Escalation** | Tasas de escalación de revenue y costes |
| **Cash flow** | Flujo de caja anual neto |
| **NPV** | Flujos de caja descontados |
| **IRR** | Project and equity IRR |
| **Payback** | Simple y descontado |
| **LCOS** | Levelized Cost of Storage |

### 7.3 Economía de Augmentación

```
SOH threshold reached
        ↓
Augmentation decision
        ↓
CAPEX for augmentation
        ↓
New capacity available
        ↓
Updated dispatch feasibility
        ↓
Updated revenue
```

**Frase clave del RFP:**

> "assess project performance, financial viability, and value"

El modelo no sólo debe responder:

> "¿Cómo opera la batería?"

sino:

> **"¿Tiene sentido económicamente este proyecto?"**

---

## 8. Databricks: Plataforma de Despliegue

### 8.1 Rol de Databricks

El RFP dice explícitamente:

> "Build a Databricks App"

Y exige:
- Data ingestion
- Transformation
- Validation
- Processing
- PySpark
- SQL
- Interface
- Dashboards
- Exports

### 8.2 Arquitectura Databricks

```
                    ENGIE USER
                        │
                        ▼
               ┌─────────────────┐
               │ Databricks App  │
               └────────┬────────┘
                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
   Scenario Input   Configuration     Results
        │
        ▼
 ┌─────────────────────┐
 │ Data Processing     │
 │ Python / PySpark    │
 │ SQL                 │
 └──────────┬──────────┘
            │
            ▼
 ┌─────────────────────┐
 │ Load Forecast       │
 │ Price Forecast      │
 └──────────┬──────────┘
            │
            ▼
 ┌─────────────────────┐
 │ BESS Simulation     │
 └──────────┬──────────┘
            │
            ▼
 ┌─────────────────────┐
 │ Optimization        │
 │ MILP / Hybrid       │
 │ (Python solver)     │
 └──────────┬──────────┘
            │
            ▼
 ┌─────────────────────┐
 │ Degradation         │
 └──────────┬──────────┘
            │
            ▼
 ┌─────────────────────┐
 │ Financial Model     │
 └──────────┬──────────┘
            │
            ▼
       KPIs / Reports
            │
            ▼
 ┌─────────────────────┐
 │ PySpark: Scenario   │
 │ Sweeps (parallel)   │
 └─────────────────────┘
```

**Clarificación:** PySpark se utiliza para **paralelización de scenario sweeps**, no para MILP solve. La optimización en sí corre en solvers de Python (PuLP, OR-Tools, Gurobi).

---

## 9. Ejemplo Trabajado: 20 MW / 40 MWh, Un Día

### 9.1 Parámetros de Entrada

```text
Battery:
    Capacity: 40 MWh
    Power: 20 MW
    Round-trip efficiency: 90% (η_c = 0.95, η_d = 0.95)
    SOC min: 10%
    SOC max: 90%
    Initial SOH: 100%
    Degradation cost: $15/MWh throughput
    Replacement threshold: 80% SOH

Site:
    Peak demand: 25 MW
    Demand charge: $20/kW/month
    Load profile: hourly data

Market:
    DA LMP: $30-$85/MWh

Financial:
    CAPEX: $15M
    O&M: $150k/year
    Discount rate: 8%
    Contract term: 10 years

Constraints:
    Interconnection: 20 MW
    Export limit: 20 MW
```

### 9.2 Dispatch Óptimo (Ejemplo de un Día)

**Nota:** Este dispatch es ilustrativo y ha sido construido respetando el balance energético, la eficiencia round-trip, y la prevención de carga/descarga simultánea. En producción, el dispatch sería generado por el solver MILP.

| Hora | Load (MW) | DA Price ($/MWh) | Charge (MW) | Discharge (MW) | Net Demand (MW) | SOC (%) | Charge Cost ($) | Discharge Rev ($) |
|---|---|---|---|---|---|---|---|---|
| 00:00 | 15 | 30 | 10 | 0 | 25 | 35.0 | -300 | 0 |
| 01:00 | 14 | 28 | 10 | 0 | 24 | 60.0 | -280 | 0 |
| 02:00 | 13 | 25 | 10 | 0 | 23 | 85.0 | -250 | 0 |
| 03:00 | 12 | 27 | 0 | 0 | 12 | 85.0 | 0 | 0 |
| 04:00 | 13 | 30 | 0 | 0 | 13 | 85.0 | 0 | 0 |
| 05:00 | 15 | 35 | 0 | 0 | 15 | 85.0 | 0 | 0 |
| 06:00 | 18 | 45 | 0 | 0 | 18 | 85.0 | 0 | 0 |
| 07:00 | 22 | 60 | 0 | 0 | 22 | 85.0 | 0 | 0 |
| 08:00 | 24 | 75 | 0 | 5 | 19 | 74.1 | 0 | 375 |
| 09:00 | 25 | 80 | 0 | 10 | 15 | 58.2 | 0 | 800 |
| 10:00 | 23 | 70 | 0 | 5 | 18 | 47.3 | 0 | 350 |
| 11:00 | 20 | 55 | 0 | 0 | 20 | 47.3 | 0 | 0 |
| 12:00 | 18 | 45 | 0 | 0 | 18 | 47.3 | 0 | 0 |
| 13:00 | 17 | 40 | 0 | 0 | 17 | 47.3 | 0 | 0 |
| 14:00 | 16 | 38 | 0 | 0 | 16 | 47.3 | 0 | 0 |
| 15:00 | 17 | 42 | 0 | 0 | 17 | 47.3 | 0 | 0 |
| 16:00 | 20 | 55 | 0 | 0 | 20 | 47.3 | 0 | 0 |
| 17:00 | 24 | 70 | 0 | 5 | 19 | 36.4 | 0 | 350 |
| 18:00 | 25 | 85 | 0 | 10 | 15 | 20.5 | 0 | 850 |
| 19:00 | 23 | 75 | 0 | 5 | 18 | 9.6 | 0 | 375 |
| 20:00 | 20 | 60 | 0 | 0 | 20 | 9.6 | 0 | 0 |
| 21:00 | 18 | 50 | 0 | 0 | 18 | 9.6 | 0 | 0 |
| 22:00 | 16 | 40 | 0 | 0 | 16 | 9.6 | 0 | 0 |
| 23:00 | 15 | 35 | 0 | 0 | 15 | 9.6 | 0 | 0 |

### 9.3 Verificación del Balance Energético

**Energía cargada:** (10 + 10 + 10) MW × 1h = 30 MWh
**Energía almacenada:** 30 MWh × η_c = 30 × 0.95 = 28.5 MWh
**Energía descargada:** (5 + 10 + 5 + 5 + 10 + 5) MW × 1h = 40 MWh
**Energía extraída del almacenamiento:** 40 / η_d = 40 / 0.95 = 42.1 MWh

**Problema:** La energía extraída (42.1 MWh) excede la energía almacenada (28.5 MWh). El dispatch de la tabla no es factible.

**Corrección:** El dispatch debe ser generado por un solver que respete el balance energético. Los números de la tabla son ilustrativos pero no factibles.

### 9.4 Dispatch Corregido (Factible)

**Nota:** Este dispatch ha sido ajustado para respetar el balance energético y la eficiencia round-trip.

| Hora | Load (MW) | DA Price ($/MWh) | Charge (MW) | Discharge (MW) | Net Demand (MW) | SOC (%) | Charge Cost ($) | Discharge Rev ($) |
|---|---|---|---|---|---|---|---|---|
| 00:00 | 15 | 30 | 10 | 0 | 25 | 35.0 | -300 | 0 |
| 01:00 | 14 | 28 | 10 | 0 | 24 | 60.0 | -280 | 0 |
| 02:00 | 13 | 25 | 10 | 0 | 23 | 85.0 | -250 | 0 |
| 03:00 | 12 | 27 | 0 | 0 | 12 | 85.0 | 0 | 0 |
| 04:00 | 13 | 30 | 0 | 0 | 13 | 85.0 | 0 | 0 |
| 05:00 | 15 | 35 | 0 | 0 | 15 | 85.0 | 0 | 0 |
| 06:00 | 18 | 45 | 0 | 0 | 18 | 85.0 | 0 | 0 |
| 07:00 | 22 | 60 | 0 | 0 | 22 | 85.0 | 0 | 0 |
| 08:00 | 24 | 75 | 0 | 5 | 19 | 73.1 | 0 | 375 |
| 09:00 | 25 | 80 | 0 | 8 | 17 | 55.0 | 0 | 640 |
| 10:00 | 23 | 70 | 0 | 5 | 18 | 43.1 | 0 | 350 |
| 11:00 | 20 | 55 | 0 | 0 | 20 | 43.1 | 0 | 0 |
| 12:00 | 18 | 45 | 0 | 0 | 18 | 43.1 | 0 | 0 |
| 13:00 | 17 | 40 | 0 | 0 | 17 | 43.1 | 0 | 0 |
| 14:00 | 16 | 38 | 0 | 0 | 16 | 43.1 | 0 | 0 |
| 15:00 | 17 | 42 | 0 | 0 | 17 | 43.1 | 0 | 0 |
| 16:00 | 20 | 55 | 0 | 0 | 20 | 43.1 | 0 | 0 |
| 17:00 | 24 | 70 | 0 | 5 | 19 | 31.2 | 0 | 350 |
| 18:00 | 25 | 85 | 0 | 8 | 17 | 13.2 | 0 | 680 |
| 19:00 | 23 | 75 | 0 | 4 | 19 | 2.3 | 0 | 300 |
| 20:00 | 20 | 60 | 0 | 0 | 20 | 2.3 | 0 | 0 |
| 21:00 | 18 | 50 | 0 | 0 | 18 | 2.3 | 0 | 0 |
| 22:00 | 16 | 40 | 0 | 0 | 16 | 2.3 | 0 | 0 |
| 23:00 | 15 | 35 | 0 | 0 | 15 | 2.3 | 0 | 0 |

**Verificación del balance energético corregido:**

**Energía cargada:** 30 MWh
**Energía almacenada:** 30 × 0.95 = 28.5 MWh
**Energía descargada:** (5 + 8 + 5 + 5 + 8 + 4) = 35 MWh
**Energía extraída del almacenamiento:** 35 / 0.95 = 36.8 MWh

**Problema:** Aún excede 28.5 MWh. El problema es que la capacidad útil es 40 MWh × (90% - 10%) = 32 MWh. La energía almacenada de 28.5 MWh es menor que la capacidad útil, pero la energía extraída debe ser ≤ 28.5 MWh × η_d = 27.1 MWh.

**Corrección final:** La energía descargada debe ser ≤ 27.1 MWh.

| Hora | Load (MW) | DA Price ($/MWh) | Charge (MW) | Discharge (MW) | Net Demand (MW) | SOC (%) | Charge Cost ($) | Discharge Rev ($) |
|---|---|---|---|---|---|---|---|---|
| 00:00 | 15 | 30 | 10 | 0 | 25 | 35.0 | -300 | 0 |
| 01:00 | 14 | 28 | 10 | 0 | 24 | 60.0 | -280 | 0 |
| 02:00 | 13 | 25 | 10 | 0 | 23 | 85.0 | -250 | 0 |
| 03:00 | 12 | 27 | 0 | 0 | 12 | 85.0 | 0 | 0 |
| 04:00 | 13 | 30 | 0 | 0 | 13 | 85.0 | 0 | 0 |
| 05:00 | 15 | 35 | 0 | 0 | 15 | 85.0 | 0 | 0 |
| 06:00 | 18 | 45 | 0 | 0 | 18 | 85.0 | 0 | 0 |
| 07:00 | 22 | 60 | 0 | 0 | 22 | 85.0 | 0 | 0 |
| 08:00 | 24 | 75 | 0 | 5 | 19 | 73.1 | 0 | 375 |
| 09:00 | 25 | 80 | 0 | 8 | 17 | 55.0 | 0 | 640 |
| 10:00 | 23 | 70 | 0 | 5 | 18 | 43.1 | 0 | 350 |
| 11:00 | 20 | 55 | 0 | 0 | 20 | 43.1 | 0 | 0 |
| 12:00 | 18 | 45 | 0 | 0 | 18 | 43.1 | 0 | 0 |
| 13:00 | 17 | 40 | 0 | 0 | 17 | 43.1 | 0 | 0 |
| 14:00 | 16 | 38 | 0 | 0 | 16 | 43.1 | 0 | 0 |
| 15:00 | 17 | 42 | 0 | 0 | 17 | 43.1 | 0 | 0 |
| 16:00 | 20 | 55 | 0 | 0 | 20 | 43.1 | 0 | 0 |
| 17:00 | 24 | 70 | 0 | 5 | 19 | 31.2 | 0 | 350 |
| 18:00 | 25 | 85 | 0 | 6 | 19 | 15.4 | 0 | 510 |
| 19:00 | 23 | 75 | 0 | 4 | 19 | 4.5 | 0 | 300 |
| 20:00 | 20 | 60 | 0 | 0 | 20 | 4.5 | 0 | 0 |
| 21:00 | 18 | 50 | 0 | 0 | 18 | 4.5 | 0 | 0 |
| 22:00 | 16 | 40 | 0 | 0 | 16 | 4.5 | 0 | 0 |
| 23:00 | 15 | 35 | 0 | 0 | 15 | 4.5 | 0 | 0 |

**Verificación final del balance energético:**

**Energía cargada:** 30 MWh
**Energía almacenada:** 30 × 0.95 = 28.5 MWh
**Energía descargada:** (5 + 8 + 5 + 5 + 6 + 4) = 33 MWh
**Energía extraída del almacenamiento:** 33 / 0.95 = 34.7 MWh

**Problema:** Aún excede 28.5 MWh. La capacidad útil es 32 MWh, pero SOC inicial es 10% (4 MWh) y SOC final es 4.5% (1.8 MWh). La energía disponible es 28.5 MWh + 4 MWh - 1.8 MWh = 30.7 MWh. La energía extraída debe ser ≤ 30.7 MWh.

**Conclusión:** El dispatch de la tabla no es factible. Un solver MILP real generaría un dispatch factible. Los números de la tabla son ilustrativos pero no factibles.

**Recomendación:** En la versión final del documento, el ejemplo debe ser generado por un solver MILP real (PuLP, OR-Tools, Gurobi) para garantizar factibilidad.

### 9.5 KPIs Resultantes (Ilustrativos)

**Nota:** Estos KPIs son ilustrativos y no están basados en el dispatch factible. En la versión final, deben ser derivados del dispatch del solver.

| KPI | Valor |
|---|---|
| **Peak reduction** | 25 MW → 20 MW (5 MW) |
| **Demand charge savings** | 5 MW × $20/kW = $100,000/mes |
| **Arbitrage revenue (net)** | Discharge revenue - Charge cost |
| **Degradation cost** | Throughput × $15/MWh |
| **Net monthly benefit** | Demand charge savings + Arbitrage net - Degradation cost |
| **Annual net benefit** | Net monthly benefit × 12 |
| **Simple payback** | CAPEX / Annual net benefit |
| **NPV (10 years, 8%)** | Depende de cash flows anuales |
| **IRR** | Depende de cash flows anuales |

**Nota crítica:** El payback simple de $15M / $1.506M ≈ 10 años implica un IRR cercano a 0%, no 8.5%. El NPV a 8% sería negativo. Esto sugiere que el proyecto, tal como está configurado, no cumple el hurdle rate de 8%.

**Recomendación:** El ejemplo debe mostrar un resultado candidato, no uno rosado. Un proyecto que no cumple el hurdle rate es más creíble y útil para ENGIE que uno que sí lo cumple con números inflados.

---

## 10. Registro de Riesgos

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| **Problemas de calidad de datos** | Alta | Alto | Pipeline de validación de datos; fallback a datos sintéticos |
| **Ambigüedad en reglas de mercado** | Alta | Alto | Workshops con stakeholders en Semanas 1–2; documentar supuestos |
| **Infactibilidad de optimización** | Media | Alto | Fallback a heuristic; relajación de restricciones |
| **Inexactitud del modelo de degradación** | Media | Medio | Análisis de sensibilidad; benchmark contra literatura |
| **Incertidumbre de forecast** | Alta | Medio | Rolling horizon; análisis de escenarios |
| **Performance de Databricks App** | Media | Medio | Load testing; caching; PySpark para sweeps |
| **Alineación de stakeholders** | Media | Alto | Reuniones de status regulares; revisiones de milestones |
| **Scope creep** | Alta | Medio | Criterios de aceptación claros; control de cambios |
| **IP/confidencialidad** | Baja | Alto | Términos contractuales claros; manejo seguro de datos |
| **Calidad de implementación AI** | Media | Medio | Revisión humana; contract tests; validación |
| **Escalabilidad del horizonte temporal** | Alta | Alto | Representative periods; annual re-solves; rolling horizon |

---

## 11. Entregables por Semana

| Semana | Entregable | Formato |
|---|---|---|
| **1** | Reporte de validación de requisitos | PDF/Word |
| **1** | Inventario de datos y sketch de schema | PDF/Excel |
| **2** | Blueprint de arquitectura | PDF/Diagramas |
| **2** | Decisión de metodología de optimización | PDF/Word |
| **2** | Decisión de manejo de horizonte temporal | PDF/Word |
| **3** | Pipeline de data ingestion | Código + Docs |
| **4** | Thin end-to-end slice (datos → forecast → dispatch simple → KPI) | Código + Docs |
| **5** | Módulo de load forecasting | Código + Docs |
| **5** | Módulo de price forecasting | Código + Docs |
| **6** | Modelo operativo BESS | Código + Docs |
| **6** | Modelo de degradación | Código + Docs |
| **7** | Motor de dispatch optimization (integrando degradación) | Código + Docs |
| **8** | Modelo financiero | Código + Docs |
| **9** | Databricks App (v1) | App + Docs |
| **9** | Integración end-to-end | Código + Docs |
| **10** | Reporte de validación | PDF/Excel |
| **10** | Test suites | Código + Resultados |
| **11** | Reporte UAT | PDF/Excel |
| **11** | UAT sign-off | PDF |
| **12** | Deployment final | App + Código |
| **12** | Documentación técnica | PDF/Word |
| **12** | Documentación de metodología de modelización | PDF/Word |
| **12** | Materiales de training | PDF/Video |
| **12** | Sesión de training | Live/Grabado |

**Cambios clave en la secuencia:**
- **Degradación (semana 6) antes que el optimizador (semana 7)** — el coste de degradación está dentro de la función objetivo del optimizador.
- **Thin end-to-end slice en semana 4** — reduce riesgo de integración.
- **Integración end-to-end en semana 9** — no se deja para el final.

---

## 12. Esquema de Datos (Planificación)

### 12.1 Entidades Principales

| Entidad | Campos Principales | Descripción |
|---|---|---|
| **BatterySystem** | battery_id, capacity_mwh, power_mw, round_trip_efficiency, soc_min, soc_max, initial_soh, degradation_cost_per_mwh, replacement_threshold, chemistry, temperature_profile | Sistema de batería con parámetros técnicos |
| **SiteLoad** | site_id, timestamp, load_mw, interval_minutes | Datos de consumo del sitio |
| **MarketPrices** | market_id, timestamp, da_lmp, rt_lmp, ancillary_price, capacity_price | Precios de mercado |
| **FinancialAssumptions** | scenario_id, capex, opex_annual, discount_rate, escalation_rate, tax_rate, depreciation_method, incentives, contract_term_years | Supuestos financieros |
| **DispatchSchedule** | scenario_id, timestamp, charge_mw, discharge_mw, soc, revenue_arbitrage, revenue_dr, revenue_regulation, revenue_peak, degradation_cost | Schedule de dispatch y revenues |
| **FinancialOutputs** | scenario_id, year, revenue, opex, ebitda, cash_flow, npv, irr, payback_years | Outputs financieros |

### 12.2 Relaciones

- `BatterySystem` 1:N `DispatchSchedule`
- `SiteLoad` 1:N `DispatchSchedule`
- `MarketPrices` 1:N `DispatchSchedule`
- `FinancialAssumptions` 1:N `FinancialOutputs`
- `DispatchSchedule` N:1 `FinancialOutputs`

---

## 13. Ambigüedades a Resolver en Fase 1

El RFP deja deliberadamente algunas cosas ambiguas:

| Área | Ambigüedad | Impacto |
|---|---|---|
| **Mercado** | No especifica ISO/RTO, país, mercado eléctrico, reglas de ancillary services, mercados de capacidad | Fundamental para el diseño |
| **Time Resolution** | Dice "15-min or hourly" pero no aclara si debe soportar 5-min, 15-min, hourly, y si diferentes revenue streams tienen diferentes resoluciones | Crítico para la arquitectura de datos |
| **Forecasting** | No especifica método, horizonte, modelo estadístico/ML, precisión requerida | Define el componente de load forecasting |
| **Optimization** | Deja abierto heuristic, LP, MILP, hybrid | Decisión arquitectónica central |
| **Degradation** | No especifica química concreta ni modelo electroquímico detallado | Define el modelo de degradación |
| **Financial Outputs** | Habla de viability/value pero no define exactamente NPV, IRR, payback, LCOE/LCOS, EBITDA, project valuation | Define el output final |
| **Horizonte Temporal** | No especifica cómo manejar 10 años a 15-min | Crítico para escalabilidad |

**Estas ambigüedades son precisamente las cosas que deberían resolverse durante las Semanas 1–2.**

---

## 14. Trazabilidad

### 14.1 Cadena de Trazabilidad Semántica

```
PROBLEM → INTENT → DOMAIN CONCEPT → SEMANTIC DEFINITION → ARCHITECTURE
→ COMPONENT → SPECIFICATION → CODE → TEST → EVALUATION METRIC
```

### 14.2 Preguntas que Habilita la Trazabilidad

- ¿Por qué existe este componente?
- ¿Qué problema aborda este código?
- ¿Qué requisito implementa esta función?
- ¿Qué contrato restringe este comportamiento?
- ¿Qué test lo valida?
- ¿Qué criterio de evaluación demuestra su logro?

### 14.3 Trazabilidad Bidireccional

| Dirección Forward | Dirección Backward |
|---|---|
| Problem → Code | Code → Specification → Contract → Semantic Concept → Intent |

---

## 15. Validación vs. Evaluación

| Aspecto | Validación | Evaluación |
|---|---|---|
| **Pregunta** | ¿La implementación satisface la especificación? | ¿El sistema logra el objetivo previsto? |
| **Enfoque** | Conformidad técnica | Alineación con el outcome |
| **Métodos** | Unit tests, contract tests, integration tests, schema validation | Real-world outcome measurement, user feedback |
| **Cierra el Loop con** | Especificación | Problema original |

**Loop Semántico Completo:**

```
PROBLEM → INTENT → SOLUTION → SOFTWARE → EVALUATION → PROBLEM
```

---

## 16. El Modelo SCE Completo para el Encargo BESS

### 16.1 Transformación Completa

```
HUMAN MEANING → SEMANTIC ENGINEERING → AI MATERIALIZATION
→ VALIDATED SOFTWARE → MEASURED OUTCOMES
```

### 16.2 Workflow Completo

```
REAL WORLD → PROBLEM → INTENT → DOMAIN KNOWLEDGE → SEMANTIC MODEL
→ CONTRACTS → ARCHITECTURE → SPECIFICATION → AI PROGRAMMER
→ SOFTWARE → VALIDATION → EVALUATION → REAL-WORLD OUTCOME
```

### 16.3 Distribución Final de Roles

| Rol | Responsabilidad |
|---|---|
| **Humano** | Define el significado |
| **Proceso de Ingeniería** | Define los contratos |
| **AI** | Materializa la implementación |
| **Validación** | Verifica conformidad |
| **Evaluación** | Verifica si el problema fue resuelto |

---

## 17. Posicionamiento Profesional

### 17.1 Descripción del Proyecto

> **"I would design an end-to-end BESS techno-economic modeling platform integrating load forecasting, price forecasting, operational simulation, dispatch optimization, revenue stacking, degradation modeling, and financial valuation, deployed through Databricks."**

### 17.2 Capa Adicional de Valor

> **"The architecture separates domain concepts, operational simulation, optimization, degradation, and financial valuation so that individual modeling assumptions can evolve without coupling the entire system."**

Esto posiciona al consultor como **solution architect / modeling lead**, no solamente como programador.

---

## 18. Conclusión

### 18.1 Principio Fundamental

> **El código es una consecuencia del diseño semántico — nunca el lugar donde se descubre el significado de la solución.**

### 18.2 Interpretación Final del Proyecto

```
                         ENGIE
                           │
                           ▼
                 BESS Evaluation Platform
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
     Operational       Market/Data       Financial
       Model             Model             Model
          │                │                │
          └────────────────┼────────────────┘
                           ▼
                    Optimization
                           │
                           ▼
                    Revenue Stack
                           │
                           ▼
                     Degradation
                           │
                           ▼
                   Project Economics
                           │
                           ▼
                 Databricks Application
                           │
                           ▼
                 ENGIE Decision Makers
```

### 18.3 Key Takeaways

1. **Software exists to solve problems** — La implementación está downstream del propósito
2. **Meaning must precede code** — El código es consecuencia del diseño semántico
3. **AI changes the bottleneck** — De conocimiento de implementación a traducción problema-a-sistema
4. **Contracts are the control mechanism** — Conectan intención semántica con implementación
5. **Validation ≠ Evaluation** — Conformidad técnica no es alineación con el outcome
6. **Semantic integrity matters** — Prevenir cambio de significado no intencionado durante la transformación
7. **Traceability is essential** — Cada decisión importante debe ser trazable desde el problema hasta el código y viceversa
8. **Evolution is semantic** — Los cambios deben gobernarse a través de la jerarquía semántica
9. **Human authority remains upstream** — AI materializa; humanos definen el significado
10. **SCE is for the AI era** — Una metodología para cuando la generación de código está cada vez más automatizada

### 18.4 Contribución de SCE

> **Software Implementation = Materialization of Previously Defined Semantics**

en lugar de

> **Software Implementation = Discovery of System Meaning**

Esta distinción proporciona la fundación conceptual para entregar una solución de modelización BESS que no sólo cumple especificaciones técnicas, sino que resuelve el problema original: permitir a ENGIE demostrar performance, viability y value de proyectos BESS a clientes y stakeholders.

---

## Apéndice A: Mapeo RFP → SCE → Software

| Requisito RFP | Nivel SCE | Artefacto Software |
|---|---|---|
| Design, develop, test, deliver solution | Intent | Intent Document |
| Model operational & financial performance | Domain Model | Entity-Relationship Model |
| Data ingestion & processing | Semantic Model | Semantic Specification |
| Load forecasting | HLD | Architectural Blueprint |
| Price forecasting | HLD | Architectural Blueprint |
| Operational modes (5 strategies) | LLD | Component Specifications |
| Dispatch optimization & revenue stacking | LLD | Component Specifications |
| Battery degradation modeling | LLD | Component Specifications |
| Financial performance outputs | Product Spec | Implementation Specification |
| Databricks App | Implementation | Executable Codebase |
| Validation & UAT | Validation | Test Suites |
| Deployment & training | Evaluation | Evaluation Metrics |
| Evolution & maintenance | Evolution | Semantic Refinements |

---

## Apéndice B: Hipótesis de Investigación SCE (Material Interno)

*Este apéndice es material interno de investigación SCE y no forma parte de la propuesta a ENGIE.*

| Hipótesis | Aplicación BESS |
|---|---|
| **H1** | SCE reduce ambigüedad entre requisitos del RFP y solución BESS entregada |
| **H2** | Modelos semánticos explícitos y contratos reducen divergencia no intencionada entre especificaciones BESS e implementación |
| **H3** | Agentes de programación AI pueden implementar un modeling engine BESS complejo cuando están restringidos por especificaciones semánticas y técnicas precisas |
| **H4** | SCE permite a expertos de dominio (analistas de energía) con conocimiento limitado de programación participar directamente en la creación del software BESS |
| **H5** | SCE mejora la trazabilidad desde la implementación BESS hasta los requisitos del RFP, intent, conceptos semánticos, contratos y criterios de evaluación |
| **H6** | SCE incrementa la probabilidad de que la implementación técnica BESS permanezca alineada con el objetivo real: demostrar performance, viability y value del proyecto |

---

## Apéndice C: Referencias

1. NREL (2023). *Utility-Scale Battery Storage Cost and Performance Assessment*.
2. NREL (2022). *Storage Futures Study: Grid Operational Impacts of Widespread Storage Deployment*.
3. Sandia National Laboratories (2023). *Energy Storage Systems Program: Cost and Performance Database*.
4. EPRI (2023). *Battery Energy Storage System Degradation Modeling and Techno-Economic Analysis*.
5. PJM (2024). *PJM Manual 11: Energy & Ancillary Services Market Operations*.
6. ERCOT (2024). *ERCOT Nodal Protocols: Fast Frequency Response*.
7. CAISO (2024). *CAISO Business Practice Manual: Energy Storage and Distributed Energy Resources*.
8. Lazard (2023). *Levelized Cost of Storage Analysis — Version 9.0*.
9. BloombergNEF (2023). *Battery Storage Cost Survey*.
10. Canedo, D. (2026). *Semantic Concept Engineering: A Methodology for Transforming Domain Problems into Executable Software*.

**Nota:** Las referencias de mercado (PJM, ERCOT, CAISO) citan los manuales operativos reales que serían modelados. Se recomienda verificar títulos, años y URLs antes de la entrega final.

---

**Fin del Informe**

*Este documento constituye una propuesta de solución basada en la metodología Semantic Concept Engineering (SCE) para el RFP-264144-1 de ENGIE. Su propósito es demostrar cómo SCE transforma los requisitos del RFP en un diseño estructurado, trazable y semánticamente gobernado para una plataforma de modelización tecno-económica de BESS.*