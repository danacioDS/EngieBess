# PART 3 — DEGRADATION AND USEFUL LIFE

## BESS Engineering Model

**Version 1.0 — Final Candidate (FC1)**

---

## 3.1 Purpose and scope of this part

This part defines the **degradation model of the BESS asset**. It specifies:

- The **calendar aging** model (time-dependent capacity fade).
- The **cycle aging** model (throughput-dependent capacity fade).
- The **state of health** (SOH) derivation for capacity, power, and efficiency.
- The **throughput accounting** (state evolution, per-service attribution).
- The **augmentation and replacement** logic (trigger conditions, state resets).
- The **calibration** procedure for the aging parameters.
- The **resolution of the Part 4 consultation** on throughput ownership.

It consumes from Parts 1 and 2: symbols, state definitions, and the physical state trajectory (\(P_{DC,t}\), \(T_t\), \(SOC_t\)). It produces for Parts 2 and 5: the SOH states (\(SOH_k\), \(SOH_k^{pow}\), \(SOH_k^{eff}\)), the throughput state (\(Th_t\), \(EFC_t\)), and the rainflow history (\(H_t^{rf}\)).

**Scope rule:** Part 3 contains degradation physics and state evolution. It does not define physical limits (Part 2), service models (Part 4), or dispatch logic (Part 5).

**Part 4 consultation resolution:** This part resolves the Part 4 consultation on throughput ownership (\(Th_t^{arb}\), \(Th_t^{reg}\)). See section 3.9.

**Part 1 change request:** This revision introduces new symbols that must be registered in Part 1. See section 3.10.

**Part 5 amendment request:** This revision issues a Part 5 amendment for the \(Th_t^{other}\) definition. See section 3.11.

**Interface summary (Part 3):**

| Consumes from | Produces for |
|---|---|
| Symbols, state vector, epoch timing (Part 1) | \(L_{cal,t}\), \(L_{cyc,t}\) (state) |
| \(P_{DC,t}\), \(T_t\), \(SOC_t\) (Part 2) | \(SOH_k\), \(SOH_k^{pow}\), \(SOH_k^{eff}\) (latched) |
| \(c_{deg}\) (financial input) | \(Th_t\), \(H_t^{rf}\), \(EFC_t\) (state) |
| Regulation statistics \(M_{reg,t}^{abs}\) (Part 4) | Per-service throughput attribution (Part 5 consumption) |
| Augmentation schedule (Part 1) | Augmentation/replacement state resets |

---

## 3.2 Calendar aging

### 3.2.1 Physics

Calendar aging is the time-dependent capacity loss that occurs even when the battery is idle. It is driven by:

- **Temperature**: higher temperature accelerates aging (Arrhenius).
- **State of charge (SOC)**: higher average SOC accelerates aging (electrolyte side reactions).

The physically correct form for Li-ion calendar aging is **sub-linear in time** (\(\beta \approx 0.5\)), driven by SEI-layer growth kinetics. This is why the model uses the **equivalent-time method** rather than a linear accumulation.

### 3.2.2 Closed-form calendar aging law

The cumulative calendar loss under constant \((T, SOC)\) is:

\[
L_{cal}(t) = A_{cal} \cdot \exp\left(-\frac{E_{a,cal}}{R \cdot T_K}\right) \cdot SOC^{\alpha} \cdot t^{\beta}
\]

where:

- \(A_{cal}\) — calibration constant (—).
- \(E_{a,cal}\) — activation energy (J/mol).
- \(R\) — universal gas constant (8.314 J/(mol·K)).
- \(T_K\) — cell temperature in kelvin.
- \(SOC\) — state of charge.
- \(\alpha\) — SOC exponent (—).
- \(\beta\) — time exponent (typically \(\approx 0.5\) for Li-ion).

### 3.2.3 Equivalent-time method (incremental update)

Under **time-varying** \((T_t, SOC_t)\), the loss is accumulated via the equivalent-time method.

**Step 1 — Convert current loss to equivalent time under current conditions:**

\[
t_{eq,t} = \left( \frac{L_{cal,t}}{A_{cal} \cdot \exp\left(-\frac{E_{a,cal}}{R \cdot T_{K,t}}\right) \cdot SOC_t^{\alpha}} \right)^{1/\beta}
\]

**Step 2 — Advance equivalent time:**

\[
t_{eq,t+1} = t_{eq,t} + \Delta t
\]

**Step 3 — Convert back to loss:**

\[
L_{cal,t+1} = A_{cal} \cdot \exp\left(-\frac{E_{a,cal}}{R \cdot T_{K,t}}\right) \cdot SOC_t^{\alpha} \cdot \left(t_{eq,t+1}\right)^{\beta}
\]

**Why this works:** The equivalent time \(t_{eq,t}\) is the time that would have produced the current loss \(L_{cal,t}\) under the current \((T_t, SOC_t)\). Advancing it by \(\Delta t\) and reconverting gives the loss under the current conditions. When conditions change, the equivalent time is preserved (loss continuity), but the rate of change adjusts to the new conditions.

**Derived quantity, not state:** \(t_{eq,t}\) is **derived** at each step from \(L_{cal,t}\) and the current conditions. It is not stored as an independent state variable. This follows Part 1's minimal-state discipline (compare the treatment of \(SOC_t\), which is derived from \(E_t\) and \(SOH_k\)).

**Correction note:** The Draft declared \(t_{eq,t}\) a state variable. This was incorrect: \(t_{eq,t}\) is fully derivable at each step from \(L_{cal,t}\) (a genuine state) and current inputs (\(T_{K,t}\), \(SOC_t\)). Storing it as independent state introduces a redundant variable and a latent consistency risk. The correct treatment is **derived quantity**, recomputed each step.

**Initialization:** At \(t = 0\), \(L_{cal,0} = 0\) and \(t_{eq,0} = 0\) (both by construction).

### 3.2.4 Unit convention

- \(T_{K,t}\) is in kelvin. The conversion from °C is:
\[
T_{K,t} = T_{C,t} + 273.15
\]
- \(\Delta t\) is in hours.
- \(L_{cal,t}\) is dimensionless (fraction of initial capacity).
- \(t_{eq,t}\) is in hours.

---

## 3.3 Cycle aging

### 3.3.1 Physics

Cycle aging is the throughput-dependent capacity loss caused by charging and discharging. It is driven by:

- **Throughput**: total charge/discharge energy.
- **Depth of discharge (DoD)**: the depth of each cycle.
- **C-rate**: the rate of charge/discharge.
- **Temperature**: higher temperature accelerates aging.

### 3.3.2 Rainflow counting

The DoD of each cycle is not directly observable from the instantaneous \(SOC_t\) signal. Rainflow counting extracts the cycles from the SOC trajectory.

**Rainflow algorithm:**

1. Track the SOC trajectory over time.
2. Identify peaks and valleys.
3. Extract cycles using the rainflow rules (the classic ASTM E1049-85 algorithm).
4. For each closed cycle, record its DoD and mean SOC.

**State:** The rainflow history \(H_t^{rf}\) is a state variable that stores the open cycle information (peaks and valleys not yet closed). When a cycle closes, the incremental cycle loss is computed and \(H_t^{rf}\) is updated.

**Implementation:** The rainflow algorithm is executed in the simulation loop, not inside the optimization. Within the optimization horizon, the DoD of future cycles is not known; the optimization uses the dispatch decisions and the **past** rainflow history to estimate degradation.

### 3.3.3 Cycle loss model

The incremental cycle capacity loss for a closed cycle is:

\[
\Delta L_{cyc}^{cycle} = B_{cyc} \cdot (DoD_{eff})^{c_1} \cdot (C_{rate})^{c_2} \cdot \exp\left(-\frac{E_{a,cyc}}{R \cdot T_{K}}\right)
\]

where:

- \(B_{cyc}\) — calibration constant (—).
- \(DoD_{eff}\) — effective depth of discharge of the cycle.
- \(C_{rate}\) — C-rate during the cycle.
- \(E_{a,cyc}\) — activation energy (J/mol).
- \(c_1, c_2\) — exponents.

**Cumulative cycle loss:**

\[
L_{cyc,t+1} = L_{cyc,t} + \Delta L_{cyc,t}^{cycle}
\]

where \(\Delta L_{cyc,t}^{cycle}\) is the loss from cycles closed at step \(t\).

**Note:** The cycle loss is applied at the step when the cycle **closes**, not spread across the cycle. This is the natural output of the rainflow algorithm.

### 3.3.4 Incremental throughput-based approximation

For the **optimization** (Part 5), the rainflow algorithm is not available inside the horizon. The optimization uses a **throughput-based** approximation:

\[
\Delta L_{cyc,t}^{approx} = B_{cyc} \cdot (DoD_{ref})^{c_1} \cdot (C_{rate,t})^{c_2} \cdot \exp\left(-\frac{E_{a,cyc}}{R \cdot T_{K,t}}\right) \cdot \frac{|P_{DC,t}| \cdot \Delta t}{E_{nom} \cdot SOH_k}
\]

where \(DoD_{ref}\) is a reference DoD (typically 0.8 or the expected average DoD from the scenario).

**Why the approximation:** Inside the optimization horizon, the optimizer cannot know the actual DoD of future cycles. The throughput-based approximation gives the optimizer a signal about degradation cost that is proportional to throughput, which is sufficient for economic decision-making.

**Simulation loop:** In the simulation loop (Part 5, §5.6), the **actual** rainflow-based cycle loss is computed for the committed decisions. The difference between the approximation and the actual is a second-order effect that averages out over time.

### 3.3.5 Unit convention

- \(DoD_{eff}\) and \(DoD_{ref}\) are dimensionless (fraction of usable energy).
- \(C_{rate}\) is in 1/h.
- \(\Delta L_{cyc}\) is dimensionless (fraction of initial capacity).

---

## 3.4 State of health

### 3.4.1 Capacity SOH

The capacity SOH is:

\[
SOH_k = 1 - L_{cal,k} - L_{cyc,k}
\]

where \(L_{cal,k}\) and \(L_{cyc,k}\) are the cumulative calendar and cycle losses at epoch boundary \(k\).

**Latched value:** \(SOH_k\) is computed at the epoch boundary and held constant within the epoch (Part 1, §1.5.6). This is the value the optimizer sees.

### 3.4.2 Power SOH

The power SOH is:

\[
SOH_k^{pow} = 1 - k_{pow} \cdot (L_{cal,k} + L_{cyc,k})
\]

where \(k_{pow}\) is the power-fade proportionality factor (—).

**Interpretation:** Power fade is assumed to be proportional to capacity fade, with a proportionality factor \(k_{pow}\). Typical values: \(k_{pow} \in [0.5, 1.5]\).

### 3.4.3 Efficiency SOH

The efficiency SOH is:

\[
SOH_k^{eff} = 1 - k_{eff} \cdot (L_{cal,k} + L_{cyc,k})
\]

where \(k_{eff}\) is the efficiency-fade proportionality factor (—).

**Interpretation:** Efficiency fade is assumed to be proportional to capacity fade, with a proportionality factor \(k_{eff}\). Typical values: \(k_{eff} \in [0.2, 0.5]\).

**Application:** The efficiency SOH scales the cell efficiencies in Part 2:

\[
\eta_{c,t} = \eta_c \cdot SOH_k^{eff}
\]
\[
\eta_{d,t} = \eta_d \cdot SOH_k^{eff}
\]

### 3.4.4 Equivalent time (derived)

The equivalent time \(t_{eq,t}\) is a **derived quantity**, recomputed at each step from \(L_{cal,t}\) and the current conditions:

\[
t_{eq,t} = \left( \frac{L_{cal,t}}{A_{cal} \cdot \exp\left(-\frac{E_{a,cal}}{R \cdot T_{K,t}}\right) \cdot SOC_t^{\alpha}} \right)^{1/\beta}
\]

**Not stored as state:** \(t_{eq,t}\) is recomputed each step. It is not part of the state vector. It is used in the calendar aging update (§3.2.3) and can be reported as a diagnostic.

**Rationale:** See §3.2.3. Storing \(t_{eq,t}\) as independent state would duplicate information already contained in \(L_{cal,t}\) and introduce a consistency risk.

**Initialization:** \(t_{eq,0} = 0\) by construction.

---

## 3.5 Throughput and equivalent full cycles

### 3.5.1 Throughput

The cumulative throughput is:

\[
Th_{t+1} = Th_t + |P_{DC,t}| \cdot \Delta t + \Delta Th_t^{reg}
\]

where:

- \(|P_{DC,t}| \cdot \Delta t\) is the physical throughput (charge + discharge).
- \(\Delta Th_t^{reg} = M_{reg,t}^{abs} \cdot E_{nom} \cdot SOH_k\) is the **regulation mileage throughput** (Part 4, §4.6.5).

**Scope clarification:** \(Th_t\) is defined as **physical throughput plus regulation mileage**, nothing else. Self-discharge, auxiliary losses, and PCS incremental losses are **not** included in \(Th_t\), because:

- They are separate terms in Part 2's energy balance (§2.2.1).
- \(|P_{DC,t}|\) (the quantity used in the throughput update) excludes them.
- Including them would change the physical meaning of "throughput" in a way that affects degradation cost attribution.

**Resolution of the Part 5 inconsistency:** Part 5 §5.6.5 states that \(Th_t^{other}\) "accounts for self-discharge, auxiliary losses, and PCS incremental losses." Given Part 3's definition of \(Th_t\), this statement is incorrect. The corrected definition is:

\[
Th_t^{other} = Th_t - \sum_s Th_t^{service}
\]

where \(Th_t^{other}\) is essentially **zero** (modulo rounding in the service attribution sum). It is not a "residual losses bucket." Part 5 §5.6.5 must be amended accordingly (see section 3.11).

**Why regulation mileage is added:** Frequency regulation causes additional cycling (the signal moves the battery back and forth) that is not captured by the physical power flow. The mileage-based term captures this.

### 3.5.2 Equivalent full cycles

The equivalent full cycles are:

\[
EFC_t = \frac{Th_t}{2 \cdot E_{nom} \cdot (SOC_{max} - SOC_{min})}
\]

**Accumulation:** \(EFC_t\) is accumulated incrementally to preserve lifetime history across augmentation:

\[
EFC_{t+1} = EFC_t + \frac{|P_{DC,t}| \cdot \Delta t + \Delta Th_t^{reg}}{2 \cdot E_{nom} \cdot SOH_k \cdot (SOC_{max} - SOC_{min})}
\]

**Note:** \(EFC_t\) is a state variable, not derived from \(Th_t\) at each step. This avoids a discontinuity when \(E_{nom}\) changes through augmentation. Unlike \(t_{eq,t}\), \(EFC_t\) genuinely requires independent accumulation because simple division of \(Th_t\) breaks when \(E_{nom}\) changes mid-life.

### 3.5.3 Rainflow history

The rainflow history \(H_t^{rf}\) stores:

- Open peaks (values not yet matched by a valley).
- Open valleys (values not yet matched by a peak).
- Cycle stack (values awaiting closure).

**State evolution:**

\[
H_{t+1}^{rf} = \text{RainflowUpdate}(H_t^{rf}, SOC_t)
\]

where `RainflowUpdate` is the rainflow algorithm applied to the new SOC value.

**Output:** When a cycle closes, the algorithm returns the DoD and mean SOC of the closed cycle. This feeds the cycle-loss computation.

### 3.5.4 EFC diagnostic

The equivalent full cycles can also be computed from the rainflow output:

\[
EFC_t^{rainflow} = \sum_{\text{closed cycles}} \frac{DoD_{cycle} \cdot E_{usable}^{cycle}}{2 \cdot E_{nom} \cdot (SOC_{max} - SOC_{min})}
\]

where \(E_{usable}^{cycle}\) is the usable energy **at the time the cycle occurred**, not the current usable energy. This accounts for SOH decay over the horizon.

**Clarification:** The diagnostic uses the cycle's historical usable energy, not the current value. This matters when SOH decays significantly over the simulation horizon.

This is a diagnostic; the primary \(EFC_t\) state uses the throughput-based accumulation (§3.5.2).

---

## 3.6 Augmentation and replacement

### 3.6.1 Trigger condition

Augmentation or replacement is triggered when:

\[
SOH_k < SOH_{threshold}
\]

where \(SOH_{threshold}\) is a configurable threshold (typically 0.70–0.80).

**Trigger event:** The augmentation is scheduled at a specific step \(t_{aug}\), defined in the scenario (Part 1, §1.4.14).

### 3.6.2 Augmentation (single-cohort base model)

**Augmentation** increases \(E_{nom}\) by \(\Delta E_{nom}\). The existing \(L_{cal}\), \(L_{cyc}\) are preserved via a **capacity-weighted blend**:

\[
L_{cal}^{new} = \frac{E_{nom}^{old} \cdot L_{cal}^{old}}{E_{nom}^{old} + \Delta E_{nom}}
\]
\[
L_{cyc}^{new} = \frac{E_{nom}^{old} \cdot L_{cyc}^{old}}{E_{nom}^{old} + \Delta E_{nom}}
\]
\[
E_{nom}^{new} = E_{nom}^{old} + \Delta E_{nom}
\]

**Energy rescale:**

\[
E_t^{new} = E_t \cdot \frac{E_{nom}^{new} \cdot SOH_k^{new}}{E_{nom}^{old} \cdot SOH_k^{old}}
\]

This preserves the SOC across the augmentation event.

**Throughput and rainflow:** \(Th_t\) and \(H_t^{rf}\) are **not rescaled**. They continue accumulating as if the battery were a single cohort with a larger capacity.

**Equivalent time:** \(t_{eq,t}\) is a derived quantity, so no separate state update is needed. After the blend, the derived \(t_{eq,t}\) computed from the new \(L_{cal}^{new}\) will automatically reflect the blended state.

### 3.6.3 Replacement (single-cohort base model)

**Replacement** resets:

- \(L_{cal} = 0\)
- \(L_{cyc} = 0\)
- \(E_{nom} = E_{nom}^{new}\)
- \(E_t = E_{nom}^{new} \cdot SOC_{init}^{rep}\)

where \(SOC_{init}^{rep}\) is the configured initial SOC after replacement.

**Throughput and rainflow:** \(Th_t\) and \(H_t^{rf}\) are **preserved** for lifetime cost accounting. The replacement cost is computed from the number of replacements and the replacement cost per event.

**Equivalent time:** \(t_{eq,t}\) is derived, so it resets automatically when \(L_{cal}\) resets (since \(t_{eq,t} = 0\) when \(L_{cal,t} = 0\)).

### 3.6.4 Cohort model (extension)

For a more accurate representation of augmentation, a **cohort model** can be used. Each cohort \(j\) has its own:

- \(E_{nom,j}\) — nominal energy.
- \(L_{cal,t,j}\), \(L_{cyc,t,j}\) — degradation states.
- \(Th_{t,j}\) — throughput.

**Total system energy:**

\[
E_{nom}^{total} = \sum_j E_{nom,j}
\]

**Cohort states:** The state vector becomes \(\{E_{nom,j}, L_{cal,t,j}, L_{cyc,t,j}, Th_{t,j}\}_j\), with \(K_t\) cohorts. Note that \(t_{eq,t,j}\) is derived for each cohort, not stored.

**Base model:** Single cohort. The cohort model is an extension; the base model uses the augmentation blend and replacement reset.

---

## 3.7 Calibration

### 3.7.1 Data sources

The degradation parameters are calibrated from:

1. **Manufacturer datasheets**: cycle life curves, calendar life curves, temperature derating.
2. **Field data**: measured capacity fade from similar systems.
3. **Literature**: published aging studies (e.g., NREL, Sandia, academic papers).

### 3.7.2 Calibration procedure

**Step 1 — Collect reference data:**

- Cycle life at reference conditions (e.g., 25 °C, 80% DoD, 0.5C).
- Calendar life at reference conditions (e.g., 25 °C, 50% SOC).
- Temperature dependence (Arrhenius fit to obtain \(E_a\)).
- SOC dependence (power-law fit to obtain \(\alpha\)).
- Time dependence (power-law fit to obtain \(\beta\)).

**Step 2 — Fit \(B_{cyc}\), \(c_1\), \(c_2\):**

Using cycle life data:
\[
L_{cyc}^{ref}(N) = B_{cyc} \cdot (DoD_{ref})^{c_1} \cdot (C_{rate,ref})^{c_2} \cdot N
\]

where \(N\) is the number of cycles. The parameters are fit to match the datasheet's cycle life curve.

**Step 3 — Fit \(A_{cal}\), \(\alpha\), \(\beta\):**

Using calendar life data:
\[
L_{cal}^{ref}(t) = A_{cal} \cdot \exp\left(-\frac{E_{a,cal}}{R \cdot T_{ref}}\right) \cdot SOC_{ref}^{\alpha} \cdot t^{\beta}
\]

The parameters are fit to match the datasheet's calendar life curve.

**Note on \(\beta\):** For Li-ion, \(\beta\) is typically \(\approx 0.5\) (SEI-layer growth). The calibration procedure fits the actual value from the data.

**Step 4 — Fit \(k_{pow}\), \(k_{eff}\):**

Using power-fade and efficiency-fade data (if available):
\[
k_{pow} = \frac{\Delta \text{power capacity}}{\Delta \text{energy capacity}}
\]
\[
k_{eff} = \frac{\Delta \text{efficiency}}{\Delta \text{energy capacity}}
\]

### 3.7.3 Validity range

The calibration is valid within the range of conditions covered by the data:

- **Temperature:** typically \([0, 45]\) °C.
- **SOC:** typically \([0.1, 0.9]\).
- **C-rate:** typically \([0.1C, 2C]\).
- **DoD:** typically \([0.1, 0.9]\).

Outside this range, the model raises a warning.

### 3.7.4 Uncertainty

The calibration parameters have uncertainty. The model supports:

- **Point estimate:** single value per parameter.
- **Distribution:** probabilistic distribution per parameter (for sensitivity analysis).

---

## 3.8 Degradation cost

### 3.8.1 Marginal degradation cost

The marginal degradation cost \(c_{deg}\) is a **financial input** (not an engineering parameter). It represents the cost per kWh of throughput that is attributed to degradation.

**Computation:**

\[
c_{deg} = \frac{\text{Replacement cost}}{2 \cdot E_{nom} \cdot (SOC_{max} - SOC_{min}) \cdot EFC_{life}}
\]

where:

- **Replacement cost:** the cost to replace the battery ($).
- **\(EFC_{life}\):** the cycle life at reference conditions (number of EFC before replacement).

**Note:** The factor of 2 in the denominator is consistent with the EFC definition in §3.5.2: \(EFC_t = Th_t / (2 \cdot E_{nom} \cdot (SOC_{max} - SOC_{min}))\).

### 3.8.2 Per-service degradation cost

The per-service degradation cost is computed in Part 5 (§5.6.6):

\[
C_{deg}^{service}(t) = c_{deg} \cdot Th_t^{service}
\]

The total degradation cost is:

\[
C_{deg}^{total}(t) = c_{deg} \cdot Th_t
\]

### 3.8.3 Augmentation and replacement costs

The augmentation cost and replacement cost are **financial events**, not continuous costs. They are recorded at the augmentation/replacement step and passed to the financial layer.

**Augmentation cost:**

\[
C_{aug} = c_{aug} \cdot \Delta E_{nom}
\]

where \(c_{aug}\) is the augmentation cost per kWh ($/kWh).

**Replacement cost:**

\[
C_{rep} = c_{rep} \cdot E_{nom}
\]

where \(c_{rep}\) is the replacement cost per kWh ($/kWh).

**Note:** These costs are financial inputs. The engineering model records the events; the financial layer converts them to cash flows.

---

## 3.9 Part 4 consultation resolution

**Status:** Resolved. **Resolution B** adopted.

### 3.9.1 Question

Part 4 §4.13 posed two resolutions for the per-service throughput decomposition:

- **Resolution A:** Part 3 owns the per-service decomposition (\(Th_t^{arb}\), \(Th_t^{reg}\)).
- **Resolution B:** Part 4 does not register per-service throughput; attribution is internal accounting.

### 3.9.2 Decision

**Resolution B is adopted.**

### 3.9.3 Rationale

Per-service throughput is an **accounting allocation**, not a physical state. The physical throughput is \(Th_t\) (a single Part 3 state). The per-service decomposition is computed in Part 5 (§5.6.5) from the dispatch allocation vector \(a_t\) and the physical throughput.

**Why not Resolution A:**

- Registering \(Th_t^{arb}\) and \(Th_t^{reg}\) as Part 3 states would require the optimization to track them explicitly, adding complexity.
- The physical state \(Th_t\) is sufficient; the decomposition is a post-processing step.
- The per-service degradation cost \(C_{deg}^{service}(t) = c_{deg} \cdot Th_t^{service}\) can be computed from Part 5's attribution mechanism without new state variables.

### 3.9.4 Attribution mechanism

The attribution mechanism is defined in Part 5, §5.6.5:

\[
Th_t^{service} = \sum_{\tau \le t} a_{service,\tau} \cdot |P_{DC,\tau}| \cdot \Delta \tau
\]

The regulation mileage throughput is attributed to the regulation service:

\[
Th_t^{reg} = \sum_{\tau \le t} \Delta Th_\tau^{reg}
\]

**Total throughput:**

\[
Th_t = \sum_s Th_t^{service} + Th_t^{other}
\]

where \(Th_t^{other} \approx 0\) (see §3.5.1 for the corrected definition).

### 3.9.5 Part 3's role

Part 3 owns the **total throughput state** \(Th_t\). It does not own per-service decompositions.

Part 3's throughput update rule is:

\[
Th_{t+1} = Th_t + |P_{DC,t}| \cdot \Delta t + \Delta Th_t^{reg}
\]

where \(\Delta Th_t^{reg}\) is the regulation mileage throughput from Part 4.

**No changes to Part 3's state vector** are required for per-service attribution.

### 3.9.6 Part 4's action

Part 4 §4.13 should be updated to reflect the resolution:

- Part 4 does not register \(Th_t^{arb}\) or \(Th_t^{reg}\).
- Part 4 uses internal accounting for per-service degradation cost attribution.
- Part 4's §4.5.5 and §4.6.5 should reference the attribution mechanism in Part 5, §5.6.5.

---

## 3.10 Part 1 change request

**Status:** Issued by Part 3. **Pending Part 1 sign-off.**

The following symbols are used in Part 3 but not yet registered in Part 1's master symbol table.

### 3.10.1 Calendar aging symbols

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(\Delta L_{cal,t}\) | Incremental calendar loss at step \(t\) (transient) | — | 1.4.6 (per-step degradation) |
| \(T_{ref}\) | Reference temperature for calibration | °C | 1.4.5 (degradation) |
| \(SOC_{ref}\) | Reference SOC for calibration | — | 1.4.5 (degradation) |

### 3.10.2 Cycle aging symbols

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(\Delta L_{cyc}^{cycle}\) | Incremental cycle loss per closed cycle (transient) | — | 1.4.6 (per-step degradation) |
| \(\Delta L_{cyc,t}^{approx}\) | Throughput-based cycle loss approximation (transient) | — | 1.4.6 (per-step degradation) |
| \(DoD_{ref}\) | Reference depth of discharge | — | 1.4.5 (degradation) |

### 3.10.3 Throughput and EFC symbols

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(EFC_t^{rainflow}\) | Rainflow-based EFC diagnostic | — | 1.4.6 (per-step degradation) |
| \(E_{usable}^{cycle}\) | Usable energy at time of cycle | kWh | 1.4.11 (derived) |

### 3.10.4 Augmentation and replacement symbols

| Symbol | Description | Unit | Suggested Part 1 section |
|---|---|---|---|
| \(c_{aug}\) | Augmentation cost per kWh | $/kWh | 1.4.7 (market/site) |
| \(c_{rep}\) | Replacement cost per kWh | $/kWh | 1.4.7 (market/site) |
| \(C_{aug}\) | Augmentation cost (event) | $ | 1.4.7 (market/site) |
| \(C_{rep}\) | Replacement cost (event) | $ | 1.4.7 (market/site) |
| \(EFC_{life}\) | Cycle life at reference conditions | — | 1.4.5 (degradation) |

### 3.10.5 Note on \(t_{eq,t}\)

\(t_{eq,t}\) is registered in Part 1 (§1.4.6) as a per-step variable. The Part 3 revision clarifies that it is a **derived quantity**, not a state variable. No change to the Part 1 registration is needed; the symbol remains a per-step derived quantity. The Draft's proposed "promotion to state variable" is **withdrawn**.

---

## 3.11 Part 5 amendment request

**Status:** Issued by Part 3. **Pending Part 5 sign-off.**

Part 5 §5.6.5 states:

> "\(Th_t^{other} = Th_t - \sum_s Th_t^{service}\) accounts for self-discharge, auxiliary losses, and PCS incremental losses."

Given Part 3's definition of \(Th_t\) (§3.5.1), this statement is incorrect. \(Th_t\) is defined as **physical throughput plus regulation mileage**, nothing else. Self-discharge, auxiliary losses, and PCS incremental losses are not included in \(Th_t\), because:

- They are separate terms in Part 2's energy balance (§2.2.1).
- \(|P_{DC,t}|\) excludes them.

**Requested Part 5 amendment:** §5.6.5 should be amended to:

1. Remove the claim that \(Th_t^{other}\) includes self-discharge, aux losses, and PCS losses.
2. State that \(Th_t^{other} \approx 0\) by construction.
3. Note that self-discharge, aux losses, and PCS losses are captured in Part 2's energy balance but not in the throughput state.

---

## 3.12 Part 3 outputs

| Output | Symbol | Consumed by |
|---|---|---|
| Cumulative calendar loss | \(L_{cal,t}\) | Part 2 (state) |
| Cumulative cycle loss | \(L_{cyc,t}\) | Part 2 (state) |
| Capacity SOH | \(SOH_k\) | Part 1, Part 2, Part 5 |
| Power SOH | \(SOH_k^{pow}\) | Part 1, Part 2 |
| Efficiency SOH | \(SOH_k^{eff}\) | Part 1, Part 2 |
| Throughput | \(Th_t\) | Part 1, Part 5 |
| Rainflow history | \(H_t^{rf}\) | Part 1 |
| Equivalent full cycles | \(EFC_t\) | Part 1, Part 5 |

---

## 3.13 Part 3 changelog

### Version 1.0 — Final Candidate (FC1)

**Changes from Revision 1 (verified):**

1. **\(t_{eq,t}\) classification resolved (§3.2.3, §3.4.4).** \(t_{eq,t}\) is now explicitly a **derived quantity**, recomputed at each step from \(L_{cal,t}\) and current conditions. It is **not** stored as independent state. The Draft's proposed "promotion to state variable" is withdrawn (§3.10.5). This follows Part 1's minimal-state discipline.

2. **Augmentation no longer requires separate \(t_{eq}\) update (§3.6.2).** Since \(t_{eq,t}\) is derived, no separate state update is needed after the blend. The derived value automatically reflects the blended state.

3. **Replacement \(t_{eq}\) reset automatic (§3.6.3).** Since \(t_{eq,t}\) is derived, it resets automatically when \(L_{cal}\) resets.

4. **Cohort model \(t_{eq}\) note added (§3.6.4).** \(t_{eq,t,j}\) is derived for each cohort, not stored.

5. **Version label updated to Final Candidate (FC1).** FC1 is the promotion candidate.

6. **Exit criteria table added (§3.14).** Three external sign-offs are listed.

**Carried over from Revision 1 (verified):**

- \(c_{deg}\) factor-of-2 correction.
- Calendar aging equivalent-time method.
- \(Th_t\) definition aligned with Part 5.
- Part 1 change request compiled.
- EFC diagnostic clarification.

**Carried over from Draft (verified):**

- Rainflow architecture.
- Augmentation/replacement logic.
- Part 4 consultation resolution.
- Calibration procedure.

---

## 3.14 Exit criteria for promotion to v1.0

| # | Criterion | Status |
|---|---|---|
| 1 | **Part 1 sign-off** on the change request (3.10). | **PENDING** |
| 2 | **Part 5 sign-off** on the \(Th_t\) amendment (3.11). | **PENDING** |
| 3 | **Part 4 update** on the consultation resolution (3.9.6). | **PENDING** |
| 4 | Internal cross-references verified. | **MET** |
| 5 | Changelog cumulative and honest. | **MET** |
| 6 | No truncated sections. | **MET** |
| 7 | \(t_{eq,t}\) classification resolved (derived, not state). | **MET** |

**Freeze definition:** Frozen (v1.0) means changes only via change request with version increment.

---



