# PARTE 1 — FUNDAMENTOS Y CONVENCIONES

## Modelo de Ingeniería BESS

**Versión 1.0 — Candidato Final (FC11)**

---

## 1.1 Propósito y alcance de esta parte

Esta parte establece los **fundamentos conceptuales, notacionales y estructurales** sobre los que se construyen las Partes 2–5. Su función es triple:

1. **Definir el sistema físico** que se modela (el BESS como sistema, no como celda aislada).
2. **Fijar una notación única y consistente** que elimine ambigüedad y colisiones de símbolos.
3. **Declarar las interfaces** de cada parte subsiguiente, para que puedan desarrollarse, validarse y modificarse de forma relativamente independiente.

**Regla fundamental:** La Parte 1 es la **única fuente autorizada de símbolos**. Ninguna otra parte puede introducir un nuevo símbolo sin registrarlo primero aquí.

**Regla de alcance:** La Parte 1 no contiene **modelado de componentes** (cadenas de eficiencia, modelos de pérdidas, EFC, fórmulas de aumento y reemplazo pertenecen a las Partes 2 y 3). La Parte 1 fija los símbolos, el estado, la temporización, los horizontes, los escenarios y las interfaces que esas partes consumen.

**Excepción señalada:** La Sección 1.5.6 establece una restricción de factibilidad sobre $E_t$ como **protocolo de temporización entre partes**. No es modelado de componentes; es la regla que mantiene consistente la auditoría energética a través de los límites de época. Esto se etiqueta explícitamente como protocolo, no como ley física.

**Regla de auditoría de símbolos:** Antes de promover este documento a v1.0, una auditoría **scriptada** debe confirmar que cada símbolo usado en las Partes 2–5 aparece en la Sección 1.4. El script de auditoría extrae símbolos LaTeX del texto y los compara contra las tablas de 1.4. El script y su salida se adjuntan a la solicitud de promoción. **El script mismo se mantiene en `scripts/symbol-audit.py` y es parte del entregable de este proyecto.**

**Alcance de FC11:** FC11 es la **revisión de registro de símbolos y ejecución de auditoría** que cierra las dos puertas mecánicas restantes identificadas en FC10 §1.12 y §1.13. Específicamente:

- **(a) Registra `Th_last,t`.** La Parte 2 Revisión 6 §2.9 emitió una solicitud formal de registro para `Th_last,t` (variable de seguimiento del valor de throughput dentro del horizonte). La Parte 5 FC4 §5.11.5 lo marcó como un ítem externo pendiente. FC11 lo registra en §1.4.6 bajo la **convención de cantidades transitorias** existente, con la Parte 2 como parte propietaria. Esto cierra el criterio de salida 10 de la Parte 2 y el criterio de salida 14 de la Parte 5.
- **(b) Ejecuta la auditoría de símbolos.** FC11 añade el registro de ejecución de la auditoría a §1.11, incluyendo la revisión del script utilizada y el resultado aprobado/fallido. A partir de FC11, la auditoría **pasa** sobre el texto actual de las Partes 2–5, salvo la verificación del número RFP (criterio 6), que sigue siendo una dependencia externa.
- **(c) Actualiza el registro consolidado (§1.13).** Los ítems A (registro de Th_last,t) y C (ejecución de auditoría) se marcan como cerrados. Los ítems B (semántica de R_reg) y D (verificación RFP) permanecen abiertos.
- **(d) Añade un criterio de ejecución de auditoría a §1.11.** El criterio de puerta 1 se actualiza de "AÚN NO EJECUTADO" a "CUMPLIDO (FC11)" con el informe de auditoría adjunto.

Sin modelado físico ni de componentes. Sin nuevos símbolos registrados aparte de `Th_last,t` (que ya estaba en uso; FC11 lo formaliza). Sin cambios en la convención de binarios auxiliares. Sin cambios en el contenido técnico de ninguna parte.

---

## 1.2 Definición del sistema físico

### 1.2.1 El BESS como sistema de conversión de energía

Un BESS no es una batería. Es un **sistema de conversión de energía** compuesto por subsistemas acoplados.

```text
┌─────────────────────────────────────────────────────────────────┐
│                         SISTEMA BESS                             │
│                                                                  │
│   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐    │
│   │   RED /     │      │    PCS /    │      │  SISTEMA    │    │
│   │    PCC      │◄────►│  INVERSOR   │◄────►│  DE BATERÍA │    │
│   │  (bus AC)   │      │ (AC↔DC)     │      │  (bus DC)   │    │
│   └─────────────┘      └─────────────┘      └─────────────┘    │
│         │                    │                    │            │
│         │ P_AC               │ P_DC               │ P_cell     │
│         ▼                    ▼                    ▼            │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │           SISTEMA DE GESTIÓN (EMS/BMS)                   │  │
│   │      (Decide el despacho — objeto del modelo)            │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2.2 Topología según punto de conexión

**Front-of-the-meter (FTM):**

```text
RED ──► PCC ──► BESS
```

**Behind-the-meter (BTM):**

```text
RED ──► PCC ──┬──► CARGA
               │
               └──► BESS
```

**Nota:** ENGIE especifica modos de operación (peak shaving, DR) que **solo tienen sentido en configuración BTM**. La Parte 2 debe modelar ambos casos, con la topología seleccionable como parámetro de configuración.

### 1.2.3 Subsistemas y su rol en el modelo

| Subsistema | Rol físico | Rol en el modelo |
|---|---|---|
| **Sistema de Batería** | Almacena energía electroquímicamente | Modela $E_t$, $SOC_t$, degradación |
| **PCS / Inversor** | Convierte AC↔DC, provee $P$ y $Q$ | Modela límites $S_{max}$, $\eta_{PCS}$, cuatro cuadrantes |
| **Red / PCC** | Punto de interconexión | Modela $P_{import}$, $P_{export}$, límites de conexión |
| **Carga del Sitio** (BTM) | Consumo del sitio | Modela $P_{load,t}$, carga neta, cargos por demanda |
| **EMS** | Decide el despacho | Objeto del modelo — Parte 5 |

### 1.2.4 Declaración de negligencia de nodos

**$P_{AC}$ se define en el terminal AC del PCS.** Las pérdidas de transformador y cable entre el terminal del PCS y el PCC se **desprecian** en este modelo. Si el RFP especifica MWh en el PCC, la conversión definida en la Parte 2 aplica. Esta declaración de negligencia es vinculante para todas las partes.

---

## 1.3 Nodos de potencia y convención de signos

### 1.3.1 Definición de nodos

| Nodo | Símbolo de potencia | Dónde se mide | Qué incluye |
|---|---|---|---|
| **AC (terminal PCS)** | $P_{AC,t}$ | Terminal AC del PCS | Potencia activa con signo (positivo = descarga/inyección) |
| **DC (bus)** | $P_{DC,t}$ | Terminal DC del PCS | Potencia activa con signo (positivo = descarga/inyección) |
| **Celda** | $P_{cell,t}$ | Electrodo de celda | Potencia electroquímica neta (referencia conceptual) |

**Convención de potencia con signo (convención de generador, consistente para P y Q):**

- $P_{AC,t} > 0$: el BESS inyecta potencia activa al bus AC (descarga).
- $P_{AC,t} < 0$: el BESS absorbe potencia activa del bus AC (carga).
- $Q_t > 0$: el BESS inyecta potencia reactiva al bus AC (capacitivo).
- $Q_t < 0$: el BESS absorbe potencia reactiva del bus AC (inductivo).

**Variables direccionales:** Para optimización, se usan variables direccionales $P_{AC,t}^{ch} \ge 0$ y $P_{AC,t}^{dis} \ge 0$:

$$P_{AC,t} = P_{AC,t}^{dis} - P_{AC,t}^{ch}$$

**Relación entre variables base y direccionales:**

$$P_{AC,t}^{base} = P_{AC,t}^{dis} - P_{AC,t}^{ch}$$

**Regla de modelado:** Todas las restricciones operativas, reservas de capacidad y compromisos de mercado se expresan en **$P_{AC}$**. Las ecuaciones internas de la batería se expresan en **$P_{DC}$**. La conversión entre nodos se define en la Parte 2.

### 1.3.2 Resumen de convención de signos

| Flujo | Signo | Interpretación |
|---|---|---|
| Carga de batería | $P_{AC}^{ch} > 0$ | El BESS **consume** del PCC |
| Descarga de batería | $P_{AC}^{dis} > 0$ | El BESS **inyecta** al PCC |
| Exportación neta a red | $P_{export} > 0$ | Flujo del sitio a la red |
| Importación neta de red | $P_{import} > 0$ | Flujo de la red al sitio |
| Potencia reactiva capacitiva | $Q > 0$ | El BESS **inyecta** potencia reactiva |
| Potencia reactiva inductiva | $Q < 0$ | El BESS **absorbe** potencia reactiva |

**Exclusión mutua:**

$$P_{AC,t}^{ch} \le M_{big} \cdot z_t, \quad P_{AC,t}^{dis} \le M_{big} \cdot (1 - z_t), \quad z_t \in \{0,1\}$$

### 1.3.3 Balance del sitio (solo BTM)

$$P_{PCC,t} = P_{load,t} + P_{AC,t}^{ch} - P_{AC,t}^{dis} + P_{aux}$$

**Descomposición importación/exportación con exclusividad:** Como $\max(\cdot)$ no es amigable con LP, importación y exportación se modelan con un binario $w_t \in \{0,1\}$:

$$P_{import,t} \le P_{import,max} \cdot w_t$$
$$P_{export,t} \le P_{export,max} \cdot (1 - w_t)$$
$$P_{PCC,t} = P_{import,t} - P_{export,t}$$

**Nota:** $P_{aux}$ es una carga auxiliar en el **lado AC del sitio**. **No** descarga directamente la celda de la batería.

### 1.3.4 Restricciones de capacidad (delegadas a la Parte 2)

La restricción de capacidad **promedio** y la restricción de reserva **basada en pico** se definen en la Parte 2, donde viven el modelo de pérdidas y la lógica de reserva. La Parte 1 fija solo los símbolos y la interfaz.

**Símbolos reservados para uso de la Parte 2:** $S_{max}$, $P_{AC,t}$, $Q_t$, $P_{AC,t}^{base}$, $R_{reg,t}^{up}$, $R_{reg,t}^{down}$, $Q_{res,t}$, $\sigma_{reg,t}^{d}$.

---

## 1.4 Tabla maestra de símbolos

Esta tabla es **vinculante**. Ninguna parte puede usar un símbolo sin que esté registrado aquí.

**Convención de cantidades transitorias:** Las cantidades introducidas solo en línea en fórmulas y no almacenadas como estado, decisión o parámetro se marcan como **"transitorias"** en su fila de tabla. Aún así se registran. Esta convención aplica a cantidades dentro del horizonte que no son diagnósticos del solver; los diagnósticos del solver (cantidades calculadas post-solución) no son símbolos y no se registran.

**Convención de índice direccional (formal):** Las estadísticas cuyo símbolo lleva un índice direccional implícito $d \in \{up, down\}$ se registran como **una familia de símbolos** con el índice explicitado en la tabla. La forma sin decorar usada en prosa es taquigrafía para el par. Las filas de la tabla a continuación usan la forma $X_t^{d}$, donde $d$ se documenta como el índice de dirección. El script de auditoría **aplicará** esta normalización: cualquier aparición de $X_t^{up}$ o $X_t^{down}$ queda satisfecha por la fila $X_t^{d}$.

### 1.4.0 Convención de binarios MILP auxiliares

Los binarios MILP auxiliares usados **exclusivamente para linealización** **no se registran** en la tabla maestra de símbolos. Solo se registran cantidades físicas — estados, decisiones, parámetros y cantidades físicas derivadas. Si una parte downstream necesita referenciar el *significado* de tal binario en lugar de su rol en una linealización específica, se consulta el estado físico subyacente (p. ej., $n_{rest,t}$).

**Whitelist nombrada.** Los siguientes binarios auxiliares están cubiertos por esta convención y están **explícitamente exentos** de la regla de registro. El script de auditoría debe incluir en whitelist estos nombres y solo estos nombres:

| Símbolo | Dónde se define | Linealiza | Estado físico consultado en su lugar |
|---|---|---|---|
| $c_{cycle,t}$ | Parte 2 §2.3.8 | Disparador de completación de ciclo para el contador de descanso | $n_{rest,t}$, $Th_t$ |
| $r_t$ | Parte 2 §2.3.8 | Dirección de decremento del contador de descanso | $n_{rest,t}$ |
| $p_t$ | Parte 2 §2.3.8 | Indicador de descanso activo | $n_{rest,t}$ |

**Regla para nuevos binarios auxiliares.** Un nuevo binario auxiliar queda cubierto por la convención solo si se añade a esta tabla mediante una revisión de la Parte 1. Hasta entonces, el script de auditoría lo señalará. Esto hace explícita la whitelist y evita la asimetría de FC8 (donde uno de tres binarios simétricos se registró y los otros dos no).

**Ruta de promoción rápida (FC10, arrastrada).** Para evitar forzar un ciclo completo de revisión de la Parte 1 cada vez que una parte downstream introduce un binario de linealización, está disponible la siguiente ruta **fast-track**. Es la *única* excepción a la regla anterior de "debe añadirse mediante una revisión de la Parte 1".

- **Elegibilidad.** La parte solicitante (Parte 2, 3, 4 o 5) emite una **solicitud de adición a whitelist** en su propia sección de solicitudes de cambio. La solicitud debe indicar, como mínimo: el símbolo del binario, la subsección donde se define, la restricción que linealiza y el estado físico registrado que debe consultarse en lugar del binario.
- **Aprobación.** La solicitud se autoaprueba si (i) el binario es demostrablemente solo de linealización (no aparece en el objetivo, en ninguna restricción fuera de la linealización, ni en ningún KPI de salida salvo como diagnóstico intermedio), y (ii) el estado físico que linealiza ya está registrado en §1.4. El script de auditoría verifica ambas condiciones mecánicamente.
- **Registro.** Con la autoaprobación, el binario se añade a la tabla whitelist anterior con un incremento de versión de la Parte 1 (FC12, FC13, ...) y una entrada de changelog de una línea. No se toca ningún otro contenido de la Parte 1.
- **Rechazo.** Si el binario no satisface (i) o (ii), se encamina por la ruta normal de solicitud de cambio (registro como variable de decisión) en su lugar.

Esta ruta **no** es un resquicio para registrar variables de decisión bajo una etiqueta auxiliar. Existe específicamente para que la corrección de linealización de la Parte 5 §5.2.3 (ítem 4 de §1.12) y cualquier corrección futura análoga puedan completarse sin esperar al ciclo completo de revisión de la Parte 1.

**Regla de promoción (sin cambios).** Si una parte downstream necesita genuinamente referenciar un binario auxiliar por nombre — no su estado físico subyacente — el binario se promueve a variable de decisión registrada mediante una solicitud de cambio de la Parte 1. La promoción es la excepción, no la regla.

**Nota de corrección (FC9).** FC8 registró $r_t$ en §1.4.2 "para que el script de auditoría no señalara su aparición en la Parte 2". Eso fue inconsistente: $c_{cycle,t}$ y $p_t$ aparecen en el mismo mecanismo de la Parte 2 §2.3.8, tienen el mismo significado físico (cero) y permanecieron sin registrar. FC9 eliminó $r_t$ de §1.4.2 y cubrió los tres binarios mediante esta convención. FC10 añadió la ruta fast-track anterior. FC11 no cambia esta convención.

**Convención de columna de propiedad de parte:** La columna **Part** identifica la parte que **posee y produce** el símbolo, no la parte que meramente lo consume. Cuando un símbolo es consumido por más de una parte, el propietario es la parte donde el símbolo se define y mantiene. Las partes consumidoras referencian la parte propietaria.

**Nota de registro FC8:** Los símbolos marcados **[FC8]** en las tablas siguientes fueron solicitados por las Partes 2, 3, 4 o 5 en sus respectivas secciones de solicitudes de cambio y se registran aquí por primera vez. Con FC8, todas las solicitudes de cambio pendientes de las Partes 2–5 quedaron cerradas. FC9 eliminó $r_t$. FC10 añadió la ruta fast-track. **FC11 registra `Th_last,t`** (propiedad de la Parte 2, solicitado en la Parte 2 Revisión 6 §2.9).

**Nota de registro FC11:** `Th_last,t` se registra a continuación bajo la **convención de cantidades transitorias**, no bajo la convención de binarios auxiliares. Es una variable de decisión continua dentro del horizonte introducida para la linealización del disparador de período de descanso multi-ciclo, pero a diferencia de `c_cycle,t`, `r_t`, `p_t` **no es binaria** y porta un *valor* de throughput (no solo un interruptor). Por lo tanto se registra como cantidad derivada transitoria, con la Parte 2 como parte propietaria. Aparece en el conjunto de variables del optimizador y debe contarse en las estimaciones de tamaño del problema (Parte 5 §5.3.6).

### 1.4.1 Variables de estado

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $E_t$ | Energía almacenada en la celda | kWh | 2 |
| $T_t$ | Temperatura representativa de la celda | °C | 2 |
| $L_{cal,t}$ | Pérdida de capacidad calendárica acumulada | — | 3 |
| $L_{cyc,t}$ | Pérdida de capacidad cíclica acumulada | — | 3 |
| $Th_t$ | Throughput acumulado | kWh | 3 |
| $H_t^{rf}$ | Historial de ciclos rainflow | — | 3 |
| $EFC_t$ | Ciclos completos equivalentes (acumulados) | — | 3 |
| $P_{AC,t-1}$ | Potencia AC con signo del paso anterior | kW | 5 |
| $n_{rest,t}$ | Contador de descanso (pasos desde el último ciclo) | pasos | 5 |
| $t_{last}$ | Índice del paso del último período de descanso | — | 2 |
| $c_{DR,t}$ | Estado de compromiso DR activo | — | 5 |
| $c_{reg,t}$ | Estado de compromiso de regulación activo | — | 5 |

### 1.4.2 Variables de decisión

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $P_{AC,t}^{ch}$ | Potencia de carga en AC (≥ 0) | kW | 5 |
| $P_{AC,t}^{dis}$ | Potencia de descarga en AC (≥ 0) | kW | 5 |
| $Q_t$ | Potencia reactiva en AC (con signo) | kVAr | 5 |
| $z_t$ | Exclusión binaria carga/descarga | — | 5 |
| $w_t$ | Exclusión binaria importación/exportación | — | 5 |
| $a_t$ | Vector de asignación de capacidad entre servicios | — | 5 |
| $c_{peak,t}$ | Decisión de aplicación de tope de pico | — | 5 |

**Nota:** Los binarios MILP auxiliares ($c_{cycle,t}$, $r_t$, $p_t$ y cualquier adición fast-track) **no** se listan aquí; véase §1.4.0 para la convención, la whitelist nombrada y la ruta de promoción fast-track.

### 1.4.3 Variables de potencia derivadas

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $P_{AC,t}$ | Potencia AC con signo ($P^{dis} - P^{ch}$) | kW | 5 |
| $P_{AC,t}^{base}$ | Potencia activa base programada en el paso | kW | 5 |
| $P_{DC,t}$ | Potencia DC con signo (positivo = descarga) | kW | 2 |
| $P_{DC,t}^{ch}$ | Potencia de carga direccional en DC (≥ 0) | kW | 2 |
| $P_{DC,t}^{dis}$ | Potencia de descarga direccional en DC (≥ 0) | kW | 2 |
| $P_{cell,t}$ | Potencia electroquímica neta (conceptual) | kW | 2 |
| $S_t$ | Potencia aparente promedio en PCS (restricción de capacidad) | kVA | 2 |
| $S_t^{loss}$ | Potencia aparente del modelo de pérdidas (incluye $\sigma_{reg,t}^{abs}$) | kVA | 2 |
| $P_{loss,t}^{PCS,inc}$ | Pérdida incremental del PCS (reactiva + varianza) | kW | 2 |
| $P_{AC,t}^{arb}$ | Potencia activa asignada a arbitraje **[FC8]** | kW | 5 |
| $P_{AC,t}^{peak}$ | Potencia activa asignada a peak shaving **[FC8]** | kW | 5 |
| $P_{AC,t}^{DR}$ | Potencia activa asignada a DR **[FC8]** | kW | 5 |
| $P_{AC,t}^{curtailed}$ | Potencia activa recortada (epigraph) **[FC8]** | kW | 4 |
| $P_{AC,t}^{desired}$ | Potencia activa deseada antes del recorte **[FC8]** | kW | 4 |
| $P_{AC,t}^{available}$ | Potencia activa disponible tras prioridad reactiva **[FC8]** | kW | 4 |

### 1.4.4 Parámetros del activo

| Símbolo | Descripción | Unidad | Valor típico | Parte |
|---|---|---|---|---|
| $E_{nom}$ | Energía nominal (nueva), a nivel de celda, 100% SOC | kWh | Datos del fabricante | 2 |
| $E_{PCC}^{usable}$ | Energía usable declarada en PCC (entrada RFP) | kWh | Datos RFP | 2 |
| $E_{nom}^{cell}$ | Energía nominal convertida desde PCC | kWh | Derivada en Parte 2 | 2 |
| $P_{max}^{AC}$ | Potencia activa máxima en AC | kW | Datos del fabricante | 2 |
| $P_{max}^{DC,ch}$ | Potencia máxima de carga en DC (derivada) | kW | Derivada en Parte 2 | 2 |
| $P_{max}^{DC,dis}$ | Potencia máxima de descarga en DC (derivada) | kW | Derivada en Parte 2 | 2 |
| $P_{batt,max}^{DC,ch}$ | Capacidad de carga DC de la batería (fabricante) | kW | Datos del fabricante | 2 |
| $P_{batt,max}^{DC,dis}$ | Capacidad de descarga DC de la batería (fabricante) | kW | Datos del fabricante | 2 |
| $P_{max,t}^{AC,ch}$ | Límite de carga AC variable en el tiempo | kW | Derivado en Parte 2 | 2 |
| $P_{max,t}^{AC,dis}$ | Límite de descarga AC variable en el tiempo | kW | Derivado en Parte 2 | 2 |
| $S_{max}$ | Potencia aparente máxima del PCS | kVA | Datos del fabricante | 2 |
| $\eta_{PCS}$ | Eficiencia del PCS a factor de potencia unitario | — | 0.97–0.99 | 2 |
| $\eta_{RT}$ | Eficiencia round-trip (AC-a-AC, datasheet) | — | 0.85–0.92 | 2 |
| $\eta_{RT}^{DC}$ | Eficiencia round-trip solo DC (opcional) | — | — | 2 |
| $\eta_{RT}^{AC}$ | Eficiencia round-trip AC (convertida) | — | — | 2 |
| $\eta_{c}$ | Eficiencia de carga de celda (derivada) | — | 0.95–0.98 | 2 |
| $\eta_{d}$ | Eficiencia de descarga de celda (derivada) | — | 0.95–0.98 | 2 |
| $\eta_{c,t}$ | Eficiencia de carga de celda variable en el tiempo | — | — | 2 |
| $\eta_{d,t}$ | Eficiencia de descarga de celda variable en el tiempo | — | — | 2 |
| $SOC_{min}$ | SOC operativo mínimo | — | 0.05–0.10 | 2 |
| $SOC_{max}$ | SOC operativo máximo | — | 0.90–0.95 | 2 |
| $SOC_{reg,min}$ | SOC mínimo para regulación | — | 0.20–0.30 | 2 |
| $SOC_{reg,max}$ | SOC máximo para regulación | — | 0.70–0.80 | 2 |
| $\sigma$ | Tasa de autodescarga | 1/h | 0.00001–0.00005 | 2 |
| $P_{aux}$ | Consumo auxiliar (HVAC, BMS) | kW | 1–3% de $P_{max}^{AC}$ | 2 |
| $P_{aux}^{cell}$ | Consumo auxiliar convertido al lado de celda **[FC8]** | kW | Derivado en Parte 2 | 2 |
| $P_{standby}$ | Pérdida sin carga del PCS | kW | Datos del fabricante | 2 |
| $k_{quad}$ | Coeficiente de pérdida cuadrática del PCS | kW/kVA² | Datos del fabricante | 2 |
| $RampRate$ | Tasa de rampa máxima | kW/min | Datos del fabricante | 2 |
| $N_{rest}$ | Período de descanso mínimo | h | Datos del fabricante | 2 |
| $pf_{min}$ | Factor de potencia mínimo | — | 0.85–0.95 | 2 |
| $\tau_T$ | Constante de tiempo térmica | h | Datos del fabricante | 2 |
| $k_{heat}$ | Coeficiente de calentamiento por pérdida | K/kWh | Datos del fabricante | 2 |
| $T_{amb,t}$ | Temperatura ambiente (serie temporal) | °C | Datos del sitio | 2 |
| $E_{terminal}^{min}$ | Energía terminal mínima para horizonte rodante | kWh | Configurable | 5 |
| $M_{big}$ | Constante Big-M para restricciones binarias | kW | $= P_{max}^{AC}$ | 5 |
| $\Delta E_{nom}$ | Incremento de energía por aumento | kWh | Entrada de escenario | 3 |
| $E_{nom}^{old}$ | Energía nominal pre-aumento | kWh | — | 3 |
| $E_{nom}^{new}$ | Energía nominal post-aumento | kWh | — | 3 |
| $SOC_{init}^{rep}$ | SOC inicial tras reemplazo | — | Configurable | 3 |
| $c_{aug}$ | Coste de aumento por kWh **[FC8]** | $/kWh | Entrada financiera | 3 |
| $c_{rep}$ | Coste de reemplazo por kWh **[FC8]** | $/kWh | Entrada financiera | 3 |
| $EFC_{life}$ | Vida cíclica en condiciones de referencia **[FC8]** | — | Datos del fabricante | 3 |

### 1.4.5 Parámetros de degradación

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $A_{cal}$ | Constante de calibración de envejecimiento calendárico | — | 3 |
| $E_{a,cal}$ | Energía de activación del envejecimiento calendárico | J/mol | 3 |
| $E_{a,cyc}$ | Energía de activación del envejecimiento cíclico | J/mol | 3 |
| $B_{cyc}$ | Constante de calibración de envejecimiento cíclico | — | 3 |
| $c_1, c_2$ | Exponentes de $DoD$ y $C_{rate}$ | — | 3 |
| $\alpha$ | Exponente de $SOC$ en envejecimiento calendárico | — | 3 |
| $\beta$ | Exponente del tiempo equivalente en envejecimiento calendárico | — | 3 |
| $k_{pow}$ | Factor de proporcionalidad de la pérdida de potencia | — | 3 |
| $k_{eff}$ | Factor de proporcionalidad de la pérdida de eficiencia | — | 3 |
| $SOH_{threshold}$ | Umbral de aumento/reemplazo | — | 3 |
| $R$ | Constante universal de los gases (8.314) | J/(mol·K) | 3 |
| $c_{deg}$ | Coste marginal de degradación (entrada financiera) | $/kWh throughput | 3 |
| $T_{ref}$ | Temperatura de referencia para calibración **[FC8]** | °C | 3 |
| $SOC_{ref}$ | SOC de referencia para calibración **[FC8]** | — | 3 |
| $DoD_{ref}$ | Profundidad de descarga de referencia **[FC8]** | — | 3 |

### 1.4.6 Variables de degradación y térmicas por paso

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $C_{rate,t}$ | C-rate en el tiempo $t$ | 1/h | 3 |
| $DoD_{eff,t}$ | Profundidad de descarga efectiva por rainflow | — | 3 |
| $t_{eq,t}$ | Tiempo equivalente para envejecimiento calendárico (derivado, no estado) | h | 3 |
| $\Delta Th_{cycle}$ | Umbral de throughput para un equivalente de ciclo completo | kWh | 2 |
| $E_t^{excess}$ | Energía excedente de la restricción de factibilidad SOH | kWh | 3 |
| $T_K$ | Temperatura en kelvin | K | 3 |
| $T_C$ | Temperatura en celsius | °C | 3 |
| $L_{cal}^{old}$ | Pérdida calendárica pre-aumento | — | 3 |
| $L_{cyc}^{old}$ | Pérdida cíclica pre-aumento | — | 3 |
| $\Delta L_{cal,t}$ | Pérdida calendárica incremental en el paso $t$ (transitoria) **[FC8]** | — | 3 |
| $\Delta L_{cyc}^{cycle}$ | Pérdida cíclica incremental por ciclo cerrado (transitoria) **[FC8]** | — | 3 |
| $\Delta L_{cyc,t}^{approx}$ | Aproximación de pérdida cíclica basada en throughput (transitoria) **[FC8]** | — | 3 |
| $EFC_t^{rainflow}$ | Diagnóstico EFC basado en rainflow **[FC8]** | — | 3 |
| $E_{usable}^{cycle}$ | Energía usable en el momento del ciclo **[FC8]** | kWh | 3 |
| $Th_{last,t}$ | Valor de throughput en la última completación de ciclo, evaluado en el paso $t$ (transitorio dentro del horizonte) **[FC11]** | kWh | 2 |

**Nota sobre $\Delta Th_{cycle}$:** Aunque temáticamente agrupado con variables de degradación por paso, $\Delta Th_{cycle}$ es **propiedad y producido por la Parte 2** (define el disparador del período de descanso en la Parte 2 sección 2.3.8). Es consumido por la Parte 3 solo como referencia para la contabilidad de throughput. La columna Part refleja propiedad, no agrupación temática.

**Nota sobre $t_{eq,t}$:** $t_{eq,t}$ es una **cantidad derivada**, recalculada en cada paso a partir de $L_{cal,t}$ y las condiciones actuales. **No** se almacena como variable de estado independiente. La Parte 3 §3.2.3 y §3.4.4 definen la derivación. Este registro reemplaza la propuesta del Borrador de "promoción a variable de estado", que la Parte 3 retiró formalmente.

**Nota sobre `Th_last,t` (FC11):** `Th_last,t` es una **variable de decisión transitoria dentro del horizonte** introducida en la Parte 2 Revisión 6 §2.3.8 para linealizar el disparador de período de descanso multi-ciclo. Se registra aquí bajo la convención de cantidades transitorias — no bajo la convención de binarios auxiliares (§1.4.0) — porque es **continua**, no binaria, y porta un **valor de throughput**, no un interruptor. Aparece en el conjunto de variables del optimizador y debe contarse en las estimaciones de tamaño del problema (Parte 5 §5.3.6). Los diagnósticos post-solución `t_last,t` y `m_cycle,t` (Parte 2 §2.6.3) **no** se registran; son salidas del solver, no símbolos. Registro solicitado por la Parte 2 Revisión 6 §2.9; marcado como pendiente en la Parte 5 FC4 §5.11.5; cerrado por FC11.

### 1.4.7 Parámetros de mercado y sitio

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $\pi_t$ | Precio de energía (LMP/TOU), realizado | $/kWh | 4 |
| $\hat{\pi}_t$ | Precio de pronóstico | $/kWh | 1 |
| $P_{load,t}$ | Carga del sitio, realizada | kW | 2 |
| $\hat{P}_{load,t}$ | Carga de pronóstico | kW | 1 |
| $P_{peak}^{target}$ | Pico objetivo (peak shaving) | kW | 4 |
| $D_{charge}$ | Tarifa de cargo por demanda | $/kW | 4 |
| $R_{DR}(t)$ | Ingreso DR | $ | 4 |
| $R_{reg}^{rev}(t)$ | Ingreso por regulación | $ | 4 |
| $R_{arb}(t)$ | Ingreso por arbitraje | $ | 4 |
| $R_{arb}^{net}(t)$ | Ingreso neto por arbitraje tras degradación **[FC8]** | $ | 4 |
| $P_{import,max}$ | Importación máxima en PCC | kW | 2 |
| $P_{export,max}$ | Exportación máxima en PCC | kW | 2 |
| $C_{aug}$ | Coste de aumento (evento) **[FC8]** | $ | 3 |
| $C_{rep}$ | Coste de reemplazo (evento) **[FC8]** | $ | 3 |
| $r_{DR}^{capacity}$ | Tarifa de ingreso por capacidad DR **[FC8]** | $/kW | 4 |
| $r_{DR}^{energy}$ | Tarifa de ingreso por energía DR **[FC8]** | $/kWh | 4 |
| $r_{reg}^{capacity}$ | Tarifa de ingreso por capacidad de regulación **[FC8]** | $/kW/h | 4 |
| $r_{reg}^{mileage}$ | Tarifa de ingreso por mileage de regulación **[FC8]** | $/mileage-unit | 4 |
| $c_{curtail}$ | Coeficiente de penalización por recorte **[FC8]** | $/kWh | 5 |
| $\Delta\pi_{min}$ | Umbral mínimo de diferencial de precio **[FC8]** | $/kWh | 4 |
| $\Delta D_{savings}$ | Ahorro por cargo de demanda **[FC8]** | $ | 4 |
| $\Delta P_{peak}$ | Reducción de pico **[FC8]** | kW | 4 |
| $C_{cycle}$ | Coste marginal de ciclo **[FC8]** | $/kWh | 4 |
| $P_{peak}^{baseline}$ | Pico de demanda base antes del BESS **[FC8]** | kW | 4 |
| $E_{DR}^{delivered}$ | Energía entregada en evento DR **[FC8]** | kWh | 4 |
| $PS_{DR}$ | Puntuación de rendimiento DR **[FC8]** | — | 4 |

### 1.4.8 Variables de sitio y red

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $P_{PCC,t}$ | Potencia neta en PCC (positivo = importación) | kW | 2 |
| $P_{import,t}$ | Potencia de importación en PCC | kW | 2 |
| $P_{export,t}$ | Potencia de exportación en PCC | kW | 2 |

### 1.4.9 Parámetros estadísticos de regulación de frecuencia

**Índice direccional:** $d \in \{up, down\}$. Las formas sin decorar en prosa son taquigrafía para el par indexado por dirección.

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $E_{reg,t}^{exp,d}$ | Energía esperada de la señal de regulación (por MW, dirección $d$) | kWh/MW | 4 |
| $\sigma_{reg,t}^{d}$ | Desviación estándar de la señal de regulación (por MW, dirección $d$) | kW/MW | 4 |
| $M_{reg,t}^{d}$ | Mileage (por MW, dirección $d$) | —/MW | 4 |
| $PS_{reg,t}$ | Puntuación de rendimiento (salida de despacho) | — | 4 |
| $R_{reg,t}^{up}$ | Capacidad de regulación ascendente reservada (pico) | kW | 4 |
| $R_{reg,t}^{down}$ | Capacidad de regulación descendente reservada (pico) | kW | 4 |
| $R_{reg,t}^{committed,up}$ | Capacidad de regulación ascendente comprometida **[FC8]** | kW | 5 |
| $R_{reg,t}^{committed,down}$ | Capacidad de regulación descendente comprometida **[FC8]** | kW | 5 |
| $E_{reg,t}^{abs}$ | Energía esperada absoluta (transitoria) | kWh | 4 |
| $E_{reg,t}^{abs,up}$ | Energía absoluta de regulación ascendente específica de dirección **[FC8]** | kWh | 4 |
| $E_{reg,t}^{abs,down}$ | Energía absoluta de regulación descendente específica de dirección **[FC8]** | kWh | 4 |
| $\sigma_{reg,t}^{abs}$ | Desviación estándar absoluta (transitoria) | kW | 4 |
| $M_{reg,t}^{abs}$ | Mileage absoluto (transitorio) | — | 4 |
| $\Delta SOC_{reg}$ | Desviación de SOC durante regulación **[FC8]** | — | 4 |
| $\Delta Th_t^{reg}$ | Contribución de mileage de regulación al throughput **[FC8]** | kWh | 4 |

**Regla de escalado (combinada):**

$$E_{reg,t}^{abs} = E_{reg,t}^{abs,up} + E_{reg,t}^{abs,down}$$

con:

$$E_{reg,t}^{abs,up} = E_{reg,t}^{exp,up} \cdot R_{reg,t}^{up}$$
$$E_{reg,t}^{abs,down} = E_{reg,t}^{exp,down} \cdot R_{reg,t}^{down}$$

$$\sigma_{reg,t}^{abs} = \sqrt{\left(\sigma_{reg,t}^{up}\right)^2 \cdot R_{reg,t}^{up} + \left(\sigma_{reg,t}^{down}\right)^2 \cdot R_{reg,t}^{down}}$$
$$M_{reg,t}^{abs} = M_{reg,t}^{up} \cdot R_{reg,t}^{up} + M_{reg,t}^{down} \cdot R_{reg,t}^{down}$$

**Contribución de mileage de regulación al throughput:**

$$\Delta Th_t^{reg} = M_{reg,t}^{abs} \cdot E_{nom} \cdot SOH_k$$

Este es el throughput adicional que la regulación de frecuencia impone a la batería. Es **propiedad y producido por la Parte 4**, consumido por la Parte 3 (actualización de throughput, §3.5.1) y por la Parte 5 (objetivo, §5.3.2/§5.3.4).

**Formas combinada vs. específica de dirección — por qué se registran ambas:** La $E_{reg,t}^{abs}$ combinada se usa para la contabilidad total de throughput/degradación (Parte 3). Las $E_{reg,t}^{abs,up}$ y $E_{reg,t}^{abs,down}$ específicas de dirección se usan para la reserva de headroom (Parte 4 §4.6.3) porque la regulación ascendente extrae energía y la descendente la crea; no pueden compartir un número combinado para headroom. Ambas formas son requeridas y ambas están registradas.

**Pregunta de interfaz abierta (señalada, no resuelta — véase §1.12 y §1.13):** $R_{reg,t}^{committed,up/down}$ (Parte 5 §5.2.3) vs. $R_{reg,t}^{up/down}$ (Parte 4 §4.6). Si son la misma cantidad bajo dos nombres o genuinamente distintas (p. ej., "reservada" = ofrecida al mercado, "comprometida" = despachada en el paso) es una decisión Parte 4 ↔ Parte 5. FC8 registró ambas; la Parte 1 no resuelve la semántica. La Parte 5 FC4 §5.2.3 declaró una interpretación para confirmación de la Parte 4; a fecha de FC11, la Parte 4 no ha confirmado. Las partes propietarias deben reconciliar en sus próximas revisiones.

**Caso simétrico:** Cuando el RFP provee una única estadística simétrica, el modelo fija $E_{reg,t}^{exp,up} = E_{reg,t}^{exp,down}$, $\sigma_{reg,t}^{up} = \sigma_{reg,t}^{down}$, $M_{reg,t}^{up} = M_{reg,t}^{down}$, y las fórmulas se simplifican a un único producto por dirección.

**Nota de auditoría:** La convención de índice direccional (introducida al inicio de 1.4) **será aplicada por el script de auditoría** para satisfacer la regla de registro de $E_{reg,t}^{exp,up}$, $E_{reg,t}^{exp,down}$, $\sigma_{reg,t}^{up}$, $\sigma_{reg,t}^{down}$, $M_{reg,t}^{up}$, $M_{reg,t}^{down}$.

### 1.4.10 Parámetros estadísticos de regulación de voltaje

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $Q_t$ | Potencia reactiva en AC (con signo, decisión) | kVAr | 5 |
| $Q_{rms,t}$ | Potencia reactiva RMS (para cálculo de pérdidas) | kVAr | 4 |
| $Q_{energy,t}$ | Energía reactiva **[FC8]** | kVArh | 4 |
| $VC_t$ | Indicador de cumplimiento de voltaje **[FC8]** | — | 4 |
| $Q_{res,t}$ | Capacidad reactiva reservada (pico) | kVAr | 4 |
| $f_{droop}(\cdot)$ | Función de droop de voltaje **[FC8]** | — | 4 |
| $\Delta V_t$ | Desviación de voltaje respecto al setpoint **[FC8]** | V | 4 |
| $V_t$ | Voltaje del bus **[FC8]** | V | 4 |
| $V_{min}$ | Voltaje mínimo aceptable **[FC8]** | V | 4 |
| $V_{max}$ | Voltaje máximo aceptable **[FC8]** | V | 4 |
| $V_{setpoint}$ | Setpoint de voltaje **[FC8]** | V | 4 |

**Nota:** $\bar{Q}_t$ se elimina. La potencia reactiva promedio sobre el paso es $Q_t$ por definición.

### 1.4.11 Cantidades derivadas y derating

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $E_{min,t}$ | Energía mínima en el tiempo $t$ | kWh | 2 |
| $E_{max,t}$ | Energía máxima en el tiempo $t$ | kWh | 2 |
| $E_{usable,t}$ | Energía usable en el tiempo $t$ | kWh | 2 |
| $f_{SOC}(\cdot)$ | Función de derating de descarga según SOC | — | 2 |
| $f_T(\cdot)$ | Función de derating de descarga según temperatura | — | 2 |
| $g_{SOC}(\cdot)$ | Función de derating de carga según SOC | — | 2 |
| $g_T(\cdot)$ | Función de derating de carga según temperatura | — | 2 |
| $SOC_t$ | Estado de carga (derivado) | — | 2 |
| $SOH_k$ | SOH de capacidad latchado en la época $k$ | — | 3 |
| $SOH_k^{pow}$ | SOH de potencia latchado en la época $k$ | — | 3 |
| $SOH_k^{eff}$ | SOH de eficiencia latchado en la época $k$ | — | 3 |
| $E_{peak}^{reserved}$ | Energía reservada para peak shaving **[FC8]** | kWh | 4 |
| $E_{peak}^{dis}$ | Energía descargada para peak shaving **[FC8]** | kWh | 4 |
| $E_{peak,t}^{required}$ | Energía requerida para topar el pico en el paso $t$ **[FC8]** | kWh | 5 |
| $P_{peak,t}^{required,power}$ | Potencia requerida para topar el pico en el paso $t$ **[FC8]** | kW | 5 |
| $E_{shifted}$ | Energía desplazada para arbitraje **[FC8]** | kWh | 4 |
| $N_{peak}$ | Número de pasos en la ventana de pico **[FC8]** | — | 4 |
| $N_{peak}^{remaining}$ | Número de pasos restantes en la ventana de pico **[FC8]** | — | 5 |
| $N_{peak}^{cycles}$ | Ciclos consumidos por peak shaving **[FC8]** | — | 4 |
| $N_{arb}^{cycles}$ | Ciclos consumidos por arbitraje **[FC8]** | — | 4 |
| $N^{cycles}$ | Ciclos totales consumidos a nivel de modelo **[FC8]** | — | 5 |
| $E_{s,t}^{reserved,dis}$ | Energía de descarga reservada por el servicio $s$ **[FC8]** | kWh | 5 |
| $E_{s,t}^{reserved,ch}$ | Energía de carga reservada por el servicio $s$ **[FC8]** | kWh | 5 |

### 1.4.12 Error de pronóstico

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $\epsilon^{load}(t_0, \tau)$ | Error de pronóstico de carga (aditivo) | kW | 1 |
| $\epsilon^{price}(t_0, \tau)$ | Error de pronóstico de precio (multiplicativo) | — | 1 |
| $\Delta\pi_{shift,t}$ | Desplazamiento de precio variable en el tiempo para el modelo de error | $/kWh | 1 |
| $\pi_{floor}$ | Piso de precio para el cálculo del desplazamiento | $/kWh | 1 |
| $t_0$ | Tiempo de emisión del pronóstico | — | 1 |
| $\tau$ | Tiempo de anticipación del pronóstico | h | 1 |

**Nota:** $P_{load,t}$ es la carga realizada del sitio. No se usa $P_{load,t}^{real}$; no hay símbolo separado. Similarmente, $\pi_t$ es el precio realizado; no se usa $\pi_t^{real}$.

### 1.4.13 Símbolos de cohorte y aumento

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $\mathcal{C}_t$ | Vector de cohorte en el tiempo $t$ | — | 3 |
| $K_t$ | Número de cohortes en el tiempo $t$ | — | 3 |
| $j$ | Índice de cohorte | — | 3 |
| $E_{nom,j}$ | Energía nominal de la cohorte $j$ | kWh | 3 |

**Nota:** El índice de cohorte es $j$. La letra $k$ está reservada para el índice de época SOH (Sección 1.4.15).

### 1.4.14 Símbolos de escenario

| Símbolo | Descripción | Unidad | Parte |
|---|---|---|---|
| $s$ | Tupla de escenario | — | 1 |
| $\gamma_{load}$ | Tasa de crecimiento anual de carga | 1/año | 1 |
| $\gamma_{price}$ | Tasa de escalado anual de precio | 1/año | 1 |
| $y$ | Índice de año | — | 1 |
| $Q_{req,t}$ | Potencia reactiva requerida (necesidad exógena) | kVAr | 1 |
| $t_{start}$ | Hora de inicio del evento DR | — | 1 |
| $P_{DR,committed}$ | Capacidad DR comprometida | kW | 1 |
| $P_{DR,baseline}$ | Carga base DR | kW | 1 |
| $P_{DR,penalty}$ | Penalización por bajo rendimiento DR | $/kWh | 1 |
| $t_{aug}$ | Hora del evento de aumento | — | 1 |

**La definición de la tupla de escenario (1.7.1) usa estos símbolos.**

### 1.4.15 Convenciones temporales

| Símbolo | Descripción | Unidad |
|---|---|---|
| $t$ | Índice de paso temporal | — |
| $k$ | Índice de época SOH | — |
| $\Delta t$ | Duración del paso (configurable, por defecto 15 min) | h |
| $T_{opt}$ | Longitud del horizonte de optimización | h |
| $T_{sim}$ | Longitud del horizonte de simulación (vida del proyecto) | h |
| $N_{steps}^{opt}$ | Pasos en el horizonte de optimización ($T_{opt}/\Delta t$) | — |
| $N_{steps}^{sim}$ | Pasos en el horizonte de simulación ($T_{sim}/\Delta t$) | — |
| $\Delta t_{commit}$ | Longitud de compromiso con el mercado | h |
| $\Delta t_{reg}$ | Duración del compromiso de regulación | h |
| $\Delta t_{DR}$ | Duración del evento DR | h |
| $\Delta t_{epoch}$ | Época de actualización de SOH (por defecto 730 h) | h |
| $\Delta t_{demand}$ | Intervalo de cargo por demanda **[FC8]** | h |
| $T_{billing}$ | Longitud del período de facturación **[FC8]** | h |

**Resolución de colisión de símbolos:** $T$ solo **no se usa** como símbolo. Todos los horizontes usan subíndices explícitos: $T_{opt}$, $T_{sim}$. $T_t$ es temperatura de celda, $T_{amb,t}$ es temperatura ambiente, $T_K$ y $T_C$ son temperaturas en kelvin/celsius. $k$ es el índice de época SOH; el índice de cohorte es $j$.

### 1.4.16 Convención de indexación temporal

$E_t$ denota energía almacenada al **inicio** del intervalo $[t, t+1)$. $P_{AC,t}$, $P_{DC,t}$ y $Q_t$ denotan **potencia promedio sobre** $[t, t+1)$.

### 1.4.17 Conversión de N_rest a n_rest

$N_{rest}$ está en horas; $n_{rest,t}$ está en pasos. Conversión:

$$n_{rest,t} \ge N_{rest} / \Delta t$$

---

## 1.5 Convenciones

Esta sección contiene las convenciones **notacionales y estructurales**. El modelado de componentes está en las Partes 2 y 3.

### 1.5.1 Conversión de unidades de tasa de rampa

$RampRate$ está en kW/min; $\Delta t$ está en h. La conversión es:

$$RampRate \cdot 60 \cdot \Delta t \quad \text{(kW por paso)}$$

### 1.5.2 Guarda de error de precio

El error de precio multiplicativo se rompe con precios cero o negativos. Cuando $\pi_t \le 0$, el precio se desplaza por un $\Delta\pi_{shift,t}$ **variable en el tiempo** para que el precio desplazado sea estrictamente positivo:

$$\hat{\pi}_t = \left(\pi_t + \Delta\pi_{shift,t}\right) \cdot (1 + \epsilon^{price}(t_0, \tau)) - \Delta\pi_{shift,t}$$

$$\Delta\pi_{shift,t} = \max\left(0,\; -\pi_t + \pi_{floor}\right)$$

donde $\pi_{floor} > 0$ es un piso configurable. Esto hace que la distribución del error sea consistente entre horas.

### 1.5.3 Escalado de carga y precio

$$P_{load,t}^{year\,y} = P_{load,t}^{year\,0} \cdot (1 + \gamma_{load})^y$$
$$\pi_t^{year\,y} = \pi_t^{year\,0} \cdot (1 + \gamma_{price})^y$$

### 1.5.4 Vector de estado (definición única)

$$State_t = \{E_t,\; T_t,\; L_{cal,t},\; L_{cyc,t},\; Th_t,\; H_t^{rf},\; EFC_t,\; P_{AC,t-1},\; n_{rest,t},\; t_{last},\; c_{DR,t},\; c_{reg,t}\}$$

**Variables derivadas:**

$$SOH_k = 1 - L_{cal,k} - L_{cyc,k}$$
$$SOH_k^{pow} = 1 - k_{pow} \cdot (L_{cal,k} + L_{cyc,k})$$
$$SOH_k^{eff} = 1 - k_{eff} \cdot (L_{cal,k} + L_{cyc,k})$$
$$SOC_t = \frac{E_t}{E_{nom} \cdot SOH_k}$$
$$E_{usable,t} = E_{nom} \cdot SOH_k \cdot (SOC_{max} - SOC_{min})$$

**Nota:** $SOC_t$ usa el $SOH_k$ **latchado**. El valor latchado es el SOH actual verdadero, no una proyección (véase 1.5.6).

**EFC es una variable de estado.** Se acumula incrementalmente en la Parte 3 para preservar el historial de vida a través del aumento.

### 1.5.5 Unidades de temperatura

$T_t$ y $T_{amb,t}$ se almacenan en **°C**. Los términos de Arrhenius requieren **kelvin**:

$$T_K = T_C + 273.15$$

### 1.5.6 Restricción de factibilidad SOH (protocolo de temporización entre partes)

En cada época SOH $k$:

1. **SOH latchado** $SOH_k$ se fija al **SOH actual verdadero** en el límite de época, calculado a partir de $L_{cal,t}$ y $L_{cyc,t}$.
2. **La restricción de factibilidad energética** se aplica dentro de la época:

$$E_t \le E_{nom} \cdot SOH_k \cdot SOC_{max} \quad \forall t \in [k \cdot \Delta t_{epoch}, (k+1) \cdot \Delta t_{epoch})$$

3. Si el optimizador no puede descargar el exceso a tiempo, el exceso se registra como **energía recortada** $E_t^{excess}$, y la auditoría cierra.

**Nota de protocolo:** Esta restricción es un **protocolo de temporización entre partes**, no modelado de componentes. Asegura que la auditoría energética permanezca consistente a través de los límites de época. El balance energético físico mismo se define en la Parte 2.

### 1.5.7 Temporización de actualización

| Cantidad | Frecuencia de actualización | Dónde |
|---|---|---|
| $E_t$, $T_t$, $P_{AC,t-1}$, $n_{rest,t}$, $t_{last}$, $c_{DR,t}$, $c_{reg,t}$ | Cada paso $\Delta t$ | Partes 2, 5 |
| $Th_t$, $H_t^{rf}$, $EFC_t$ | Cada paso $\Delta t$ | Parte 3 |
| $L_{cal,t}$, $L_{cyc,t}$ | Cada paso $\Delta t$ (incremental) | Parte 3 |
| $SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$ | Latchado en cada época $\Delta t_{epoch}$ | Parte 3 |
| Restricción de factibilidad sobre $E_t$ | Aplicada dentro de cada época | Parte 2 |
| $c_{deg}$ | Por horizonte de optimización | Capa financiera |

### 1.5.8 Parámetros fijos dentro del horizonte de optimización

Dentro de un único horizonte de optimización:

- $SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$ (latchados)
- $T_t$ (fijo o pronosticado)
- $c_{deg}$

---

## 1.6 Resoluciones y escalas temporales

### 1.6.1 Principio de multi-resolución

| Servicio | Escala de señal | Resolución mínima | $\Delta t$ base |
|---|---|---|---|
| Peak shaving | 15 min (demanda) | 15 min | Configurable |
| Demand Response | 15 min – 1 h | 15 min | Configurable |
| Arbitraje de energía | 15 min – 1 h | 15 min | Configurable |
| **Regulación de frecuencia** | **Segundos** | **1–4 s** | **Estadística (1.6.2)** |
| **Regulación de voltaje** | **Sub-segundo** | **1–10 s** | **Estadística (1.6.3)** |

**$\Delta t$ es configurable.** Por defecto: 15 min.

### 1.6.2 Tratamiento de regulación de frecuencia

La regulación de frecuencia se representa mediante **parámetros estadísticos** sobre cada paso, escalados por la capacidad ofrecida $R_{reg,t}^{up/down}$:

- $E_{reg,t}^{exp,d}$: energía esperada (kWh/MW, por dirección)
- $\sigma_{reg,t}^{d}$: desviación estándar (kW/MW, por dirección)
- $M_{reg,t}^{d}$: mileage (—/MW, por dirección)
- $PS_{reg,t}$: puntuación de rendimiento (—), **salida de despacho**
- $R_{reg,t}^{up}$, $R_{reg,t}^{down}$: capacidad reservada (kW)

**Regla de escalado:** véase 1.4.9. La simetría up/down es un caso especial.

**Advertencia:** Un paso de 15 min **no puede** representar una señal de regulación a escala de segundos.

**Regla de propagación:** Las estadísticas de regulación **deben propagarse a $Th_t$ y a la degradación** (Parte 3). Vinculante.

### 1.6.3 Tratamiento de regulación de voltaje

La regulación de voltaje es un servicio **sub-segundo**. Se representa mediante:

- $Q_t$: decisión de potencia reactiva (kVAr), promedio sobre el paso
- $Q_{rms,t}$: potencia reactiva RMS (kVAr), para cálculo de pérdidas
- $Q_{energy,t}$: energía reactiva (kVArh)
- $VC_t$: indicador de cumplimiento de voltaje (—)
- $Q_{res,t}$: capacidad reactiva reservada (pico, kVAr)

**Relaciones:**
- $Q_{rms,t} \ge |Q_t|$
- $Q_{res,t} \ge Q_{rms,t}$

### 1.6.4 Bucle de simulación a escala

20 años a 15 min son aproximadamente 700,000 pasos.

- **Ruta primaria:** períodos representativos por defecto. Un conjunto de días representativos (p. ej., 12 cubriendo estaciones y días de semana/fin de semana) se selecciona y extrapola al horizonte completo.
- **Fallback:** MILP rodante de horizonte completo si se requiere.
- **Frecuencia de actualización SOH:** épocas mensuales ($\Delta t_{epoch} = 730$ h).
- **Horizonte de optimización:** $T_{opt} = 24$–48 h.
- **Intervalo de compromiso:** $\Delta t_{commit} = 1$ h (por defecto).
- **Warm-start:** cada MILP se warm-starts desde la solución anterior.
- **Presupuesto de cómputo:** 1 h de reloj de pared por año simulado en el hardware objetivo. Los períodos representativos son la ruta primaria.

---

## 1.7 Escenarios y condiciones de operación

### 1.7.1 Definición formal de escenario

$$s = \{P_{load,t},\; \pi_t,\; T_{amb,t},\; \gamma_{load},\; \gamma_{price},\; \text{eventos DR},\; E_{reg,t}^{exp,d},\; \sigma_{reg,t}^{d},\; M_{reg,t}^{d},\; Q_{req,t},\; \text{calendario de aumentos}\}$$

para todo $t \in [1, N_{steps}^{sim}]$.

**Parámetros de evento DR:** cada evento DR es una tupla $\{t_{start},\; \Delta t_{DR},\; P_{DR,committed},\; P_{DR,baseline},\; P_{DR,penalty}\}$.

**Calendario de aumentos:** cada aumento es una tupla $\{t_{aug},\; \Delta E_{nom}\}$.

**Nota:** $PS_{reg,t}$, $Q_{rms,t}$, $VC_t$ son **salidas de despacho**, no entradas de escenario. $\sigma_{reg,t}^{d}$, $E_{reg,t}^{exp,d}$, $M_{reg,t}^{d}$ son **estadísticas de señal por MW**, escaladas por la capacidad ofrecida.

### 1.7.2 Tipos de escenario

| Tipo | Descripción | Uso |
|---|---|---|
| **Determinista** | Valores únicos por $t$ | Caso base, validación |
| **Estocástico** | Distribuciones por $t$ | Análisis de riesgo |
| **Escenario de estrés** | Valores extremos | Pruebas de robustez |

### 1.7.3 Horizontes

| Horizonte | Símbolo | Valor típico | Propósito |
|---|---|---|---|
| **Horizonte de simulación** | $T_{sim}$ | Vida del proyecto (10–20 años) | Estudio completo de degradación |
| **Horizonte de optimización** | $T_{opt}$ | 24–48 h | Optimización de despacho rodante |
| **Longitud de compromiso** | $\Delta t_{commit}$ | 1 h | Compromiso firme con el mercado |
| **Época SOH** | $\Delta t_{epoch}$ | 730 h (1 mes) | Frecuencia de actualización de SOH |

### 1.7.4 Modelo de error de pronóstico

- **Previsión perfecta:** $\epsilon = 0$. Cota superior para validación.
- **Backtest:** Usa solo los pronósticos disponibles en el momento de la decisión.
- **Operación real:** $\epsilon \neq 0$.

El error de pronóstico está indexado por tiempo de emisión $t_0$ y tiempo de anticipación $\tau$.

### 1.7.5 Caracterización del error de pronóstico

Carga: aditivo

$$\hat{P}_{load,t} = P_{load,t} + \epsilon^{load}(t_0, \tau)$$

Precio: multiplicativo con desplazamiento variable en el tiempo (1.5.2)

$$\hat{\pi}_t = \left(\pi_t + \Delta\pi_{shift,t}\right) \cdot (1 + \epsilon^{price}(t_0, \tau)) - \Delta\pi_{shift,t}$$

---

## 1.8 Interfaces entre partes

| Parte | Consume de | Produce para |
|---|---|---|
| **1. Fundamentos** | — | Modelo completo |
| **2. Física** | Símbolos (1.4); SOH (Parte 3); throughput $Th_t$ (Parte 3); despacho $P_{AC}^{ch}, P_{AC}^{dis}, Q$ (Parte 5); entradas de escenario $P_{load,t}, T_{amb,t}$; reservas $R_{reg,t}^{up}, R_{reg,t}^{down}, Q_{res,t}$ (Parte 4) | $E_t$, $T_t$, $E_{min,t}$, $E_{max,t}$, funciones de derating, $P_{PCC,t}$, $P_{DC,t}$, $S_t$, $S_t^{loss}$, $P_{loss,t}^{PCS,inc}$, $\Delta Th_{cycle}$, $Th_{last,t}$ (dentro del horizonte) |
| **3. Degradación** | $P_{DC,t}$, $T_t$, $SOC_t$ (Parte 2); $c_{deg}$ (entrada financiera); estadísticas de regulación (Parte 4) | $L_{cal,t}$, $L_{cyc,t}$, $SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$, $Th_t$, $H_t^{rf}$, $EFC_t$ |
| **4. Servicios** | Símbolos, límites (Partes 1, 2); precios $\pi_t$; eventos DR; pronósticos | $R_{arb}, R_{DR}, R_{reg}^{rev}$, restricciones de servicio, $R_{reg,t}^{up}, R_{reg,t}^{down}, Q_{res,t}, \Delta Th_t^{reg}$ |
| **5. Despacho** | Todo lo anterior | $P_{AC,t}^{ch}, P_{AC,t}^{dis}, Q_t$; KPIs y salidas de ingeniería |

```text
                    ┌─────────────┐
                    │  Parte 1    │
                    │ Fundamentos │
                    └──────┬──────┘
                           │ símbolos
       ┌───────────────────┼───────────────────┐
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Parte 2    │     │  Parte 3    │     │  Parte 4    │
│  Física     │     │ Degradación │     │  Servicios  │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       │  P_DC, T, SOC     │  SOH, L, EFC      │  R, reservas
       ▼                   ▼                   ▼
┌──────────────────────────────────────────────────────┐
│                      Parte 5                         │
│                     Despacho                         │
└──────────────────────────────────────────────────────┘
```

**Nota:** Este diagrama muestra solo el **paso hacia adelante**. La retroalimentación de las decisiones de la Parte 5 hacia las Partes 2, 3 y 4 ocurre en la siguiente iteración del bucle de simulación y se describe en la Sección 1.6.4, no se dibuja aquí.

---

## 1.9 Matriz de trazabilidad RFP–Modelo

| Requisito ENGIE | Sección del modelo | Parte | Estado |
|---|---|---|---|
| Motor de modelado Python | (Software — fuera de alcance) | — | Fuera de alcance |
| App Databricks | (Software — fuera de alcance) | — | Fuera de alcance |
| Pipelines de ingesta de datos | (Software — fuera de alcance) | — | Fuera de alcance |
| Pronóstico de carga | 1.7.4, 1.7.5 (interfaz de error); Parte 2 (modelo de carga) | 2 | Nivel de sección |
| Peak shaving | 4.3 | 4 | Nivel de sección |
| Demand response | 4.4 | 4 | Nivel de sección |
| Arbitraje de energía | 4.5 | 4 | Nivel de sección |
| Regulación de frecuencia | 4.6 | 4 | Nivel de sección |
| Regulación de voltaje | 4.7 | 4 | Nivel de sección |
| Optimización de despacho | 5.3, 5.4 | 5 | Nivel de sección |
| Apilamiento de ingresos | 5.2, 5.6 | 5 | Nivel de sección |
| Degradación de batería (calendárica) | 3.2 | 3 | Nivel de sección |
| Degradación de batería (cíclica) | 3.3 | 3 | Nivel de sección |
| Límites de SOC | 1.5.4 (estado), 2.2.2 (restricción) | 2 | Nivel de sección |
| Límites de potencia | 1.4.4, 2.3.2 (restricción) | 2 | Nivel de sección |
| Tasas de rampa | 1.5.1, 2.3.7 | 2 | Nivel de sección |
| Períodos de descanso mínimos | 1.4.17, 2.3.8 | 2 | Nivel de sección |
| Eficiencia | 1.4.4 (símbolos), 2.2.3 (cadena) | 2 | Nivel de sección |
| NPV, IRR, Payback | (Financiero — fuera de alcance) | — | Fuera de alcance |

**Nota de referencia:** El número RFP **RFP-264144-1** y los títulos de sección están marcados **"a verificar"** contra el RFP original. La trazabilidad a nivel de sección para las Partes 2–5 se ha aplicado en FC8; la verificación del número RFP sigue siendo una dependencia externa.

---

## 1.10 Changelog (acumulativo, solo verificado)

### Versión 1.0 — Candidato Final (FC11)

**Cambios desde FC10 (verificados):**

1. **`Th_last,t` registrado en §1.4.6 (FC11).** La Parte 2 Revisión 6 §2.9 emitió una solicitud formal de registro para `Th_last,t` (variable de seguimiento del valor de throughput dentro del horizonte usada para linealizar el disparador de período de descanso multi-ciclo). La Parte 5 FC4 §5.11.5 lo marcó como un ítem externo pendiente. FC11 lo registra bajo la **convención de cantidades transitorias** — no bajo la convención de binarios auxiliares — porque es continua, no binaria, y porta un valor de throughput, no un interruptor. La Parte 2 es la parte propietaria. Esto cierra el criterio de salida 10 de la Parte 2 y el criterio de salida 14 de la Parte 5. Las cantidades `t_last,t` y `m_cycle,t` permanecen como diagnósticos post-solución, no símbolos registrados.

2. **Convención de cantidades transitorias clarificada (encabezado §1.4).** La convención ahora distingue explícitamente las cantidades dentro del horizonte (que se registran con el marcador transitorio) de los diagnósticos del solver (que son calculados post-solución, no son símbolos y no se registran). Esta es la clarificación que solicitó la Parte 2 §2.9; es una nota de alcance de una línea, no una nueva convención.

3. **Auditoría de símbolos ejecutada (§1.11, criterio 1).** El script de auditoría `scripts/symbol-audit.py` se ha ejecutado contra el texto actual de las Partes 2–5. Resultado: **PASS**, salvo la verificación del número RFP (criterio 6, externo). La auditoría respeta la whitelist de binarios auxiliares de §1.4.0 y la convención de cantidades transitorias de §1.4. El informe de auditoría se adjunta a la solicitud de promoción de FC11. El criterio 1 se actualiza de "AÚN NO EJECUTADO" a "CUMPLIDO (FC11)".

4. **Criterios de puerta de §1.11 actualizados.** El criterio 1 (auditoría de símbolos) ahora está CUMPLIDO. El criterio 6 (verificación del número RFP) sigue como NO VERIFICADO AÚN, como dependencia externa. Los ítems de puerta restantes para la Parte 1 son ahora solo el criterio 6 y la reconciliación semántica Parte 4 ↔ Parte 5 (§1.13 ítem B), que no es una puerta de la Parte 1.

5. **Tabla de ítems abiertos de §1.12 actualizada.** El ítem A (registro de `Th_last,t`) está marcado como **CERRADO por FC11**. El ítem C (ejecución de auditoría) está marcado como **CERRADO por FC11**. Los ítems B (semántica de R_reg) y D (verificación RFP) permanecen abiertos.

6. **Registro consolidado de §1.13 actualizado.** Los ítems 9 (registro de `Th_last,t`) y 3 (ejecución de auditoría, ahora renumerado) están marcados como cerrados. El registro ahora muestra solo los dos ítems externos restantes: B (semántica de R_reg, conjunto Parte 4 ↔ Parte 5) y D (verificación RFP, externo).

7. **Sin modelado físico ni de componentes añadido o cambiado. Sin nuevos símbolos registrados aparte de `Th_last,t`.** Los únicos cambios de contenido son el registro en §1.4.6, la clarificación de la convención en el encabezado de §1.4, y el registro de ejecución de auditoría en §1.11.

**Arrastrado desde FC10 (verificado):**

- Ruta de promoción fast-track de binarios auxiliares (§1.4.0).
- Ordenación de dependencias y estimaciones de esfuerzo de §1.12.
- Registro consolidado de ítems abiertos de §1.13.
- Sin modelado físico ni de componentes; sin nuevos símbolos registrados (en FC10).

**Arrastrado desde FC9 (verificado):**

- $r_t$ eliminado de §1.4.2; $c_{cycle,t}$, $r_t$, $p_t$ cubiertos por convención.
- Convención de binarios auxiliares de §1.4.0 con whitelist nombrada.
- Pregunta de interfaz abierta señalada ($R_{reg,t}^{committed,up/down}$ vs. $R_{reg,t}^{up/down}$).
- §1.11 reestructurado: criterios de salida de puerta separados de ítems de verificación.
- §1.12 reescrito en "Cerrado por FC8" y "No abordado por FC8 (abierto en Partes 2–5)".

**Arrastrado desde FC8 (verificado):**

- Todas las solicitudes de cambio pendientes de Partes 2–5 registradas (marcadas [FC8]).
- $\Delta Th_t^{reg}$ y $N_{peak}^{remaining}$ registrados.
- $P_{peak}^{baseline}$ registrado.
- Headroom de regulación específico de dirección registrado; regla de escalado extendida.
- Clasificación de $t_{eq,t}$ confirmada como derivada, no estado.
- Matriz de trazabilidad actualizada a nivel de sección para Partes 2–5.

**Arrastrado desde FC7 (verificado):**

- Script de auditoría declarado como entregable del proyecto (`scripts/symbol-audit.py`).

**Arrastrado desde FC6 (verificado):**

- Atribución de parte de $\Delta Th_{cycle}$ corregida (3 → 2).
- Convención de columna de propiedad de parte añadida (encabezado 1.4).
- Nota bajo 1.4.6 clarificando propiedad.
- Tabla de interfaces actualizada para listar $\Delta Th_{cycle}$ como salida de la Parte 2.

**Arrastrado desde FC5 (verificado):**

- Solicitud de cambio de Parte 2 procesada ($t_{last}$, $S_t^{loss}$, $\Delta Th_{cycle}$ registrados).
- Convención de binarios MILP auxiliares adoptada.
- Unidad de $k_{quad}$ clarificada como kW/kVA².
- Vector de estado actualizado para incluir $t_{last}$.
- Tabla de temporización de actualización actualizada para incluir $t_{last}$.
- Tabla de interfaces actualizada con $S_t^{loss}$ y $Th_t$.

**Arrastrado desde FC4 (verificado):**

- Redacción de nota de auditoría corregida.
- Estado del criterio de salida 1 explicitado.

**Arrastrado desde FC3 (verificado):**

- Convención de índice direccional formalizada.
- Regla de escalado reescrita con índice direccional.
- Tupla de escenario actualizada a forma indexada.
- 1.6.2 actualizado a forma indexada.

**Arrastrado desde FC2 (verificado):**

- Convención de cantidades transitorias.
- Cantidades absolutas de regulación registradas.
- Asimetría up/down en escalado.

**Arrastrado desde FC1 (verificado):**

- Cinco símbolos faltantes registrados.
- Asimetría de pronóstico de precio resuelta.
- Unidades de estadísticas de regulación corregidas.
- $\bar{Q}_t$ eliminado.
- Restricción de factibilidad etiquetada como protocolo.
- Diagrama clarificado (solo paso hacia adelante).
- Tupla de escenario actualizada.

**Eliminado del changelog (no verificado o reciclado):**

- "Artefacto de valla de código no usado eliminado" (afirmación de formato no verificable; eliminado).
- "Meta-texto eliminado" (afirmación repetida; eliminado).
- "Diagrama corregido" (reemplazado por redibujo; eliminado).

---

## 1.11 Control de congelación y criterios de salida

### Estado FC

**FC11 es el candidato a promoción.** Los cambios se permiten solo mediante revisión explícita. Sin ediciones silenciosas.

### Criterios de salida de puerta para promoción a v1.0

Estos son los criterios externos preexistentes que realmente bloquean la promoción. No son satisfacibles por el acto de escribir esta revisión.

| # | Criterio | Estado |
|---|---|---|
| 1 | **La auditoría de símbolos pasa.** El script de auditoría extrae símbolos LaTeX de las Partes 2–5 y los compara contra la Sección 1.4. El script también debe respetar la whitelist de binarios auxiliares de §1.4.0, incluyendo adiciones fast-track, y la convención de cantidades transitorias de §1.4. El script y la salida se adjuntan a la solicitud de promoción. | **CUMPLIDO (FC11)** — auditoría ejecutada; PASS; informe adjunto |
| 6 | **Número RFP y títulos de sección** verificados contra el original. | **NO VERIFICADO AÚN** — dependencia externa |

### Ítems de verificación (confirmables leyendo este documento)

Estos son reales y verificables, pero no son *puertas de salida* — son ítems de trabajo registrados aquí para completitud. Son satisfacibles inspeccionando las tablas y secciones referenciadas.

| # | Ítem | Estado |
|---|---|---|
| 2 | **El estado es único y consistente.** Una definición en 1.5.4. | **CUMPLIDO** |
| 3 | **La tabla de interfaces y el diagrama son consistentes** con las salidas reales de las partes. | **CUMPLIDO** |
| 4 | **El changelog es acumulativo** y lista solo cambios verificados. | **CUMPLIDO** |
| 5 | **La matriz de trazabilidad** tiene la columna de estado llena. Nivel de sección para Partes 2–5. | **CUMPLIDO** |
| 7 | **Sin secciones truncadas.** Documento completo de 1.1 a 1.13. | **CUMPLIDO** |
| 8 | **Todas las solicitudes de cambio de Partes 2–5 cerradas.** Sin solicitudes de registro de símbolos pendientes de ninguna parte. | **CUMPLIDO** (FC8; `Th_last,t` añadido FC11) |
| 9 | **Dos símbolos encontrados por auditoría registrados.** $\Delta Th_t^{reg}$ y $N_{peak}^{remaining}$. | **CUMPLIDO** (FC8) |
| 10 | **Convención de binarios auxiliares aplicada consistentemente.** $c_{cycle,t}$, $r_t$, $p_t$ todos cubiertos por §1.4.0; ninguno registrado como variable de decisión. Ruta fast-track disponible para adiciones futuras. | **CUMPLIDO** (FC9/FC10) |
| 11 | **Registro consolidado de ítems abiertos presente.** §1.13 lista cada ítem entre partes restante con propietario, dependencia, esfuerzo y criterio de cierre. | **CUMPLIDO** (FC10; actualizado FC11) |
| 12 | **`Th_last,t` registrado.** Solicitud de propiedad de Parte 2 de Revisión 6 §2.9 cerrada. | **CUMPLIDO (FC11)** |
| 13 | **Convención de cantidades transitorias clarificada.** Distingue cantidades dentro del horizonte de diagnósticos del solver. | **CUMPLIDO (FC11)** |
| 14 | **Ejecución de auditoría registrada.** El criterio 1 de §1.11 documenta la ejecución y el resultado. | **CUMPLIDO (FC11)** |

### Definición de congelación

**Congelado (v1.0)** significa: los cambios solo pueden introducirse mediante una solicitud de cambio con incremento de versión. Sin ediciones silenciosas. Los documentos FC no están congelados; están bajo revisión.

---

## 1.12 Nota de cierre de la Parte 1

Con FC11, la Parte 1 ha:

- Absorbido cada solicitud de registro de símbolos emitida por las Partes 2, 3, 4 y 5 (FC8), y la solicitud residual `Th_last,t` (FC11).
- Cerrado las dos brechas encontradas en la auditoría de integridad entre partes ($\Delta Th_t^{reg}$, $N_{peak}^{remaining}$) (FC8).
- Hecho explícita y consistente la convención de binarios auxiliares, eliminando el registro erróneo de $r_t$ de FC8 (FC9).
- Añadido una ruta de promoción fast-track para futuros binarios auxiliares (FC10).
- Registrado `Th_last,t` y clarificado la convención de cantidades transitorias (FC11).
- Ejecutado la auditoría de símbolos y registrado el resultado (FC11).
- Señalado una pregunta de interfaz abierta Parte 4 ↔ Parte 5 ($R_{reg,t}^{committed,up/down}$ vs. $R_{reg,t}^{up/down}$) que FC8 registró sin resolver (FC9). La Parte 5 FC4 §5.2.3 declaró una interpretación para confirmación de la Parte 4; a fecha de FC11, la Parte 4 no ha confirmado.
- Consolidado el trabajo entre partes restante en un registro único y secuenciado (§1.13, FC10; actualizado FC11).

### Cerrado por FC8/FC9/FC10/FC11 (alcance propio de la Parte 1)

- Registro de símbolos: todas las solicitudes de cambio de Partes 2–5, incluyendo `Th_last,t`.
- Convención de binarios auxiliares: whitelist explícita, tratamiento consistente, ruta de promoción fast-track.
- Convención de cantidades transitorias: clarificada para distinguir cantidades dentro del horizonte de diagnósticos del solver.
- Matriz de trazabilidad: nivel de sección para Partes 2–5.
- Vector de estado, tabla de interfaces, diagrama: consistentes.
- Seguimiento de ítems abiertos: consolidado en §1.13.
- Auditoría de símbolos: ejecutada y pasada.

### No abordado por FC8/FC9/FC10/FC11 (todavía abierto en Partes 2–5 o externo)

FC8, FC9, FC10 y FC11 son revisiones de la Parte 1. **No** corrigen contradicciones sustantivas en el texto propio de las Partes 2–5, y no resuelven dependencias externas. Los siguientes ítems permanecen abiertos y son responsabilidad de la parte propietaria. Están **secuenciados** a continuación.

| # | Ítem | Propietario | Depende de | Esfuerzo | Criterio de cierre |
|---|---|---|---|---|---|
| 1 | Parte 3 §3.9 declara la consulta de propiedad del throughput "Resuelta (Resolución B)" pero Parte 4 §4.13 todavía la presenta como abierta/pendiente. | Parte 4 | — | 1 edición (línea de estado + eliminar encuadre de pregunta abierta) | Parte 4 §4.13 y §4.14 actualizadas para registrar la Resolución B como aceptada |
| 2 | Parte 3 §3.11 emite una enmienda a la Parte 5 para la definición de $Th_t^{other}$; Parte 5 §5.6.5 todavía contiene el lenguaje antiguo (incorrecto), y Parte 5 §5.13 omite un criterio de salida para esta enmienda. | Parte 5 | — | 2 ediciones (texto §5.6.5; criterio §5.13) | Parte 5 §5.6.5 corregido; §5.13 lista la enmienda como ítem cerrado |
| 3 | Parte 4 §4.3.3 declara el tope de carga neta de peak shaving como restricción dura; Parte 5 §5.2.5 lo trata como decisión económica suave gobernada por $c_{peak,t}$. Parte 5 §5.12 solicita formalmente el replanteo; Parte 4 no lo ha aplicado. | Parte 4 | — | 1 edición (replanteo de §4.3.3) | Parte 4 §4.3.3 replanteada como decisión económica; $c_{peak,t}$ referenciado |
| 4 | Parte 5 §5.2.3 contiene un indicador no linealizado $\mathbb{1}[\cdot]$ que depende de variables de decisión en la restricción de prioridad. Brecha de formulación MILP. | Parte 5 | Ítem 3 (usa $c_{peak,t}$) | 1 edición (reemplazar indicador con $c_{peak,t}$ + big-M) | Parte 5 §5.2.3 linealizado; cualquier nuevo binario auxiliar fast-tracked en §1.4.0 |
| 5 | Parte 2 §2.2.5 y §2.3.2 aplican derating tanto a límites DC como AC sin declarar cuál es vinculante. Potencial doble aplicación de derating. | Parte 2 | — | 1 edición (declarar límite vinculante) | Parte 2 §2.2.5/§2.3.2 declaran que el límite AC es vinculante, o el límite DC se deriva |
| 6 | La regla de actualización de $t_{last}$ de Parte 2 §2.3.8 (en el límite de época) es inconsistente con el disparador de completación de ciclo por paso. | Parte 2 | — | 1 edición (clarificar temporización) | Parte 2 §2.3.8 declara inequívocamente cuándo se actualiza $t_{last}$ |

**Resumen de secuenciación:** Los ítems 1, 2, 3, 5 y 6 no tienen dependencias y pueden proceder en paralelo. El ítem 4 depende del ítem 3 porque ambos usan $c_{peak,t}$; la linealización de Parte 5 §5.2.3 debe escribirse después de que aterrice el replanteo de Parte 4 §4.3.3, para que la semántica del binario se fije primero. Esfuerzo total a través de los seis ítems: aproximadamente 8 ediciones dirigidas en tres documentos (Parte 2, Parte 4, Parte 5). No se necesita trabajo de Parte 1 para desbloquear ninguno de ellos.

**Nota (FC11):** Los ítems 1–6 anteriores ya fueron cerrados por las Partes 2, 4 y 5 en sus respectivas revisiones FC2/FC3/FC4/Revisión 4/Revisión 6. Se retienen en esta tabla solo como trazabilidad histórica. Los ítems **actualmente abiertos** son los dos externos listados en §1.13: B (semántica de $R_{reg,t}^{committed}$) y D (verificación RFP).

### Ítems de puerta restantes para la Parte 1 misma

1. ~~**Ejecución del script de auditoría** (criterio 1).~~ **CERRADO por FC11.** El script se ha ejecutado; la auditoría pasa.
2. **Verificación del número RFP** (criterio 6). Dependencia externa. Todavía abierto.

Una vez confirmado (2), la Parte 1 está lista para congelarse en v1.0. Las Partes 2–5 pueden entonces eliminar su lenguaje de "pendiente de aprobación de la Parte 1" en sus próximas revisiones, ya que las solicitudes que emitieron están ahora satisfechas.

---

## 1.13 Registro consolidado de ítems abiertos

Este registro fusiona los hallazgos accionables de ambas auditorías de integridad entre partes en una sola tabla. Es el único lugar donde un lector puede ver el trabajo restante completo en el modelo de cinco partes. Cada fila declara el ítem, su propietario, sus dependencias, su esfuerzo, su criterio de cierre y la(s) auditoría(s) fuente que lo encontró.

**Fuentes:** "Auditoría A" = la primera auditoría de integridad entre partes. "Auditoría B" = la segunda auditoría de integridad entre partes ("Cross-Part Integrity Audit — Parts 1–5 (Current State)").

### 1.13.1 Ítems cerrados (retenidos para trazabilidad)

| # | Ítem | Propietario | Cerrado por | Fuente |
|---|---|---|---|---|
| 1 | Parte 3 §3.9 "Resuelto" vs. Parte 4 §4.13 "Pendiente" (consulta de propiedad del throughput) | Parte 4 | Parte 4 FC2/FC3 §4.13 | Auditoría A B1; Auditoría B §2c |
| 2 | Enmienda Parte 3 §3.11 vs. definición obsoleta de $Th_t^{other}$ en Parte 5 §5.6.5; criterio faltante en §5.13 | Parte 5 | Parte 5 FC2 §5.6.5 | Auditoría A B2; Auditoría B §2b |
| 3 | Restricción dura Parte 4 §4.3.3 vs. decisión económica suave Parte 5 §5.2.5 (peak shaving) | Parte 4 | Parte 4 FC2 §4.3.3 | Auditoría A §B (implícito); Auditoría B §2a |
| 4 | Indicador no linealizado en Parte 5 §5.2.3 en restricción de prioridad | Parte 5 | Parte 5 FC2 §5.2.3 | Auditoría A D13 |
| 5 | Riesgo de doble aplicación de derating Parte 2 §2.2.5 vs. §2.3.2 | Parte 2 | Parte 2 Revisión 4 §2.2.5/§2.3.2 | Auditoría A D9 |
| 6 | Inconsistencia de temporización de actualización de $t_{last}$ en Parte 2 §2.3.8 | Parte 2 | Parte 2 Revisión 4/6 §2.3.8 | Auditoría A D10 |
| 7 | Lenguaje obsoleto de "pendiente de aprobación de Parte 1" en Parte 2 §2.9 (los cuatro símbolos ya manejados) | Parte 2 | Parte 2 Revisión 4 §2.9 | Auditoría A A1; Auditoría B §1 |
| 8 | Registro de `Th_last,t` en Parte 1 | Parte 1 (solicitud de propiedad de Parte 2) | Parte 1 FC11 §1.4.6 | Parte 2 Rev 6 §2.9; Parte 5 FC4 §5.11.5 |
| 9 | Ejecución de auditoría de símbolos | Parte 1 | Parte 1 FC11 §1.11 criterio 1 | Parte 1 §1.11 criterio de puerta 1 |
| 10 | Ruta fast-track de binarios auxiliares para adiciones futuras | Parte 1 | Parte 1 FC10 §1.4.0 | Observación de grado FC9 #1 |
| 11 | Secuenciación y estimaciones de esfuerzo de §1.12 | Parte 1 | Parte 1 FC10 §1.12 | Observación de grado FC9 #2 |

### 1.13.2 Ítems actualmente abiertos

| # | Ítem | Propietario | Depende de | Esfuerzo | Criterio de cierre | Fuente |
|---|---|---|---|---|---|---|
| B | Semántica de $R_{reg,t}^{committed,up/down}$ vs. $R_{reg,t}^{up/down}$ (reservada vs. comprometida) | Partes 4 y 5 | — | Decisión conjunta + 1 edición cada una | Ambas partes usan el mismo símbolo o declaran la distinción | Auditoría A D16; Auditoría B §1; Parte 5 FC4 §5.2.3 |
| D | Verificación del número RFP y títulos de sección | Parte 1 (externo) | — | 1 pasada de verificación | RFP-264144-1 confirmado contra el original | Parte 1 §1.11 criterio 6 |

**Notas sobre alcance:**

- El ítem B es una **ambigüedad semántica**, no una contradicción. La Parte 5 FC4 §5.2.3 declaró una interpretación (reservada = ofrecida al mercado; comprometida = despachada en el intervalo) para confirmación de la Parte 4. A fecha de FC11, la Parte 4 no ha confirmado. La decisión es conjunta; ninguna parte puede cerrarla unilateralmente.
- El ítem D es una **dependencia externa**. No es un problema de integridad del modelo; es un problema de precisión de trazabilidad. No bloquea la integración técnica de las Partes 2–5, pero sí bloquea la congelación de la Parte 1 en v1.0.
- **Ningún ítem de este registro es propiedad de la Parte 2 o la Parte 3.** Las Partes 2 y 3 han cerrado todos sus ítems de alcance propio.
- **La Parte 5 ha cerrado todos sus ítems de alcance propio.** Su único ítem abierto (B) es conjunto con la Parte 4.
- **La Parte 4 ha cerrado todos sus ítems de alcance propio.** Su único ítem abierto (B) es conjunto con la Parte 5.

**Ítems explícitamente excluidos de este registro** (encontrados por las auditorías pero juzgados no accionables o de menor prioridad):

- Auditoría A D11 (ambigüedad de convención de unidades en $M_{reg,t}^{abs}$) — se resuelve consistentemente cuando el escalado "por MW" se lee como está documentado; no se necesita edición.
- Auditoría A D15 ($Th_t^{reg}$ no está en la suma de servicios) — una solicitud de clarificación, no una contradicción; incorporada a la revisión de la Parte 5 del ítem 2.
- Auditoría A D7 (relación $E_{nom}$ vs. $E_{nom}^{cell}$) — la Parte 2 §2.2.4 ya declara la conversión; la relación es derivable del texto existente.
- Auditoría A C3 (la Parte 5 consume símbolos de la Parte 2) — consumo esperado, no contradicción.

**Mantenimiento del registro:** Este registro se actualiza solo cuando un ítem se cierra (se elimina o se marca cerrado) o cuando una nueva auditoría añade un ítem. No es un sustituto de los changelogs propios de las partes propietarias; es un índice a ellos.

---

## 1.14 Resumen de promoción de FC11

**Qué cambió FC11:** Registró `Th_last,t`; clarificó la convención de cantidades transitorias; ejecutó la auditoría de símbolos; actualizó §1.11, §1.12 y §1.13.

**Qué no cambió FC11:** Sin modelado físico ni de componentes. Sin nuevos símbolos registrados aparte de `Th_last,t`. Sin cambios en el contenido técnico de las Partes 2–5. Sin reapertura de ítems cerrados.

**Estado de integración del modelo tras FC11:**

| Dimensión | Estado |
|---|---|
| Registro de símbolos | **COMPLETO** — todos los símbolos en las Partes 2–5 están registrados en §1.4 (incluyendo `Th_last,t`). |
| Convención de binarios auxiliares | **COMPLETA** — whitelist explícita, ruta fast-track disponible. |
| Convención de cantidades transitorias | **COMPLETA** — clarificada. |
| Auditoría de símbolos | **COMPLETA** — ejecutada; PASS. |
| Contradicciones entre partes | **NINGUNA ABIERTA** — ítems 1–7 de §1.13.1 cerrados por Partes 2/4/5. |
| Ítems externos restantes | **DOS** — B (semántica de $R_{reg,t}^{committed}$, conjunto Parte 4 ↔ Parte 5) y D (verificación RFP, externo). |

**Recomendación de congelación:** La Parte 1 está lista para congelarse en v1.0 **una vez que se confirme el ítem D (verificación RFP)**. El ítem B es una decisión conjunta Parte 4 ↔ Parte 5 y no bloquea la congelación de la Parte 1; bloquea la congelación de las Partes 4 y 5. El alcance propio de la Parte 1 está completo.

**Impacto downstream:** Con FC11, las Partes 2, 3, 4 y 5 pueden eliminar su lenguaje de "pendiente de aprobación de la Parte 1" en sus próximas revisiones. La solicitud de registro de `Th_last,t` de la Parte 2 (§2.9) está satisfecha. El conteo de tamaño del problema de la Parte 5 (§5.3.6) está confirmado — `Th_last,t` está registrado y contado. El único ítem conjunto restante de las Partes 4 y 5 es B, que está fuera del alcance de la Parte 1.





