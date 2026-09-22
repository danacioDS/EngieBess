Aquí tienes la **Parte 1 — Fundamentals and Conventions** en inglés, extraída del documento que proporcionaste:

---

# PART 1 — FUNDAMENTALS AND CONVENTIONS

## BESS Engineering Model

**Version 1.0 — Final Candidate (FC11)**

---

## 1.1 Purpose and scope of this part

This part establishes the **conceptual, notational, and structural foundations** on which Parts 2–5 are built. Its function is threefold:

1. **Define the physical system** being modeled (the BESS as a system, not as an isolated cell).
2. **Fix a single, consistent notation** that eliminates ambiguity and symbol collisions.
3. **Declare the interfaces** of each subsequent part, so they can be developed, validated, and modified relatively independently.

**Fundamental rule:** Part 1 is the **only authorized source of symbols**. No other part may introduce a new symbol without first registering it here.

**Scope rule:** Part 1 contains **no component modeling** (efficiency chains, loss models, EFC, augmentation and replacement formulas belong to Parts 2 and 3). Part 1 fixes the symbols, state, timing, horizons, scenarios, and interfaces that those parts consume.

**Exception noted:** Section 1.5.6 states a feasibility constraint on $E_t$ as a **cross-part timing protocol**. It is not component modeling; it is the rule that keeps the energy audit consistent across epoch boundaries. This is explicitly labeled as a protocol, not a physical law.

**Symbol audit rule:** Before promoting this document to v1.0, a **scripted** audit must confirm that every symbol used in Parts 2–5 appears in Section 1.4. The audit script extracts LaTeX symbols from the text and diffs them against the 1.4 tables. The script and its output are attached to the promotion request. **The script itself is maintained in `scripts/symbol-audit.py` and is part of the deliverable of this project.**

**FC11 scope:** FC11 is the **symbol-registration and audit-execution revision** that closes the two remaining mechanical gates identified in FC10 §1.12 and §1.13. Specifically:

- **(a) Registers `Th_last,t`.** Part 2 Revision 6 §2.9 issued a formal registration request for `Th_last,t` (within-horizon throughput-value-tracking variable). Part 5 FC4 §5.11.5 flagged this as a pending external item. FC11 registers it in §1.4.6 under the existing **transient-quantities convention**, with Part 2 as the owning part. This closes Part 2 exit criterion 10 and Part 5 exit criterion 14.
- **(b) Executes the symbol audit.** FC11 adds the audit-execution record to §1.11, including the script revision used and the pass/fail result. As of FC11, the audit **passes** on the current Partes 2–5 text, modulo the RFP-number verification (criterion 6), which remains an external dependency.
- **(c) Updates the consolidated register (§1.13).** Items A (Th_last,t registration) and C (audit execution) are marked closed. Items B (R_reg semantics) and D (RFP verification) remain open.
- **(d) Adds an audit-execution criterion to §1.11.** The gating criterion 1 is updated from "NOT YET EXECUTED" to "MET (FC11)" with the audit report attached.

No physical or component modeling. No new registered symbols other than `Th_last,t` (which was already in use; FC11 formalizes it). No changes to the auxiliary-binary convention. No changes to any part's technical content.

---

## 1.2 Definition of the physical system

### 1.2.1 The BESS as an energy conversion system

A BESS is not a battery. It is an **energy conversion system** composed of coupled subsystems.

```text
┌─────────────────────────────────────────────────────────────────┐
│                         BESS SYSTEM                              │
│                                                                  │
│   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐    │
│   │   GRID /    │      │    PCS /    │      │   BATTERY   │    │
│   │    PCC      │◄────►│  INVERTER   │◄────►│   SYSTEM    │    │
│   │  (AC bus)   │      │ (AC↔DC)     │      │  (DC bus)   │    │
│   └─────────────┘      └─────────────┘      └─────────────┘    │
│         │                    │                    │            │
│         │ P_AC               │ P_DC               │ P_cell     │
│         ▼                    ▼                    ▼            │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │              MANAGEMENT SYSTEM (EMS/BMS)                 │  │
│   │         (Decides dispatch — object of the model)         │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2.2 Topology by point of connection

**Front-of-the-meter (FTM):**

```text
GRID ──► PCC ──► BESS
```

**Behind-the-meter (BTM):**

```text
GRID ──► PCC ──┬──► LOAD
               │
               └──► BESS
```

**Note:** ENGIE specifies operating modes (peak shaving, DR) that **only make sense in BTM configuration**. Part 2 must model both cases, with topology selectable as a configuration parameter.

### 1.2.3 Subsystems and their role in the model

| Subsystem | Physical role | Role in the model |
|---|---|---|
| **Battery System** | Stores energy electrochemically | Models $E_t$, $SOC_t$, degradation |
| **PCS / Inverter** | Converts AC↔DC, provides $P$ and $Q$ | Models limits $S_{max}$, $\eta_{PCS}$, four-quadrant |
| **Grid / PCC** | Point of interconnection | Models $P_{import}$, $P_{export}$, connection limits |
| **Site Load** (BTM) | Site consumption | Models $P_{load,t}$, net load, demand charges |
| **EMS** | Decides dispatch | Object of the model — Part 5 |

### 1.2.4 Node neglect statement

**$P_{AC}$ is defined at the PCS AC terminal.** Transformer and cable losses between the PCS terminal and the PCC are **neglected** in this model. If the RFP specifies MWh at the PCC, the conversion defined in Part 2 applies. This neglect statement is binding for all parts.

---

## 1.3 Power nodes and sign convention

### 1.3.1 Definition of nodes

| Node | Power symbol | Where it is measured | What it includes |
|---|---|---|---|
| **AC (PCS terminal)** | $P_{AC,t}$ | PCS AC terminal | Signed active power (positive = discharge/injection) |
| **DC (bus)** | $P_{DC,t}$ | PCS DC terminal | Signed active power (positive = discharge/injection) |
| **Cell** | $P_{cell,t}$ | Cell electrode | Net electrochemical power (conceptual reference) |

**Signed power convention (generator convention, consistent for P and Q):**

- $P_{AC,t} > 0$: BESS injects active power into the AC bus (discharging).
- $P_{AC,t} < 0$: BESS absorbs active power from the AC bus (charging).
- $Q_t > 0$: BESS injects reactive power into the AC bus (capacitive).
- $Q_t < 0$: BESS absorbs reactive power from the AC bus (inductive).

**Directional variables:** For optimization, directional variables $P_{AC,t}^{ch} \ge 0$ and $P_{AC,t}^{dis} \ge 0$ are used:

$$P_{AC,t} = P_{AC,t}^{dis} - P_{AC,t}^{ch}$$

**Relation between base and directional variables:**

$$P_{AC,t}^{base} = P_{AC,t}^{dis} - P_{AC,t}^{ch}$$

**Modeling rule:** All operational constraints, capacity reservations, and market commitments are expressed in **$P_{AC}$**. Internal battery equations are expressed in **$P_{DC}$**. Conversion between nodes is defined in Part 2.

### 1.3.2 Sign convention summary

| Flow | Sign | Interpretation |
|---|---|---|
| Battery charging | $P_{AC}^{ch} > 0$ | BESS **consumes** from PCC |
| Battery discharging | $P_{AC}^{dis} > 0$ | BESS **injects** into PCC |
| Net export to grid | $P_{export} > 0$ | Flow from site to grid |
| Net import from grid | $P_{import} > 0$ | Flow from grid to site |
| Capacitive reactive power | $Q > 0$ | BESS **injects** reactive power |
| Inductive reactive power | $Q < 0$ | BESS **absorbs** reactive power |

**Mutual exclusion:**

$$P_{AC,t}^{ch} \le M_{big} \cdot z_t, \quad P_{AC,t}^{dis} \le M_{big} \cdot (1 - z_t), \quad z_t \in \{0,1\}$$

### 1.3.3 Site balance (BTM only)

$$P_{PCC,t} = P_{load,t} + P_{AC,t}^{ch} - P_{AC,t}^{dis} + P_{aux}$$

**Import/export decomposition with exclusivity:** Because $\max(\cdot)$ is not LP-friendly, import and export are modeled with a binary $w_t \in \{0,1\}$:

$$P_{import,t} \le P_{import,max} \cdot w_t$$
$$P_{export,t} \le P_{export,max} \cdot (1 - w_t)$$
$$P_{PCC,t} = P_{import,t} - P_{export,t}$$

**Note:** $P_{aux}$ is an auxiliary load on the **AC side of the site**. It does **not** discharge the battery cell directly.

### 1.3.4 Capability constraints (delegated to Part 2)

The **average** capability constraint and the **peak-based** reservation constraint are defined in Part 2, where the loss model and the reservation logic live. Part 1 fixes only the symbols and the interface.

**Symbols reserved for Part 2 use:** $S_{max}$, $P_{AC,t}$, $Q_t$, $P_{AC,t}^{base}$, $R_{reg,t}^{up}$, $R_{reg,t}^{down}$, $Q_{res,t}$, $\sigma_{reg,t}^{d}$.

---

## 1.4 Master symbol table

This table is **binding**. No part may use a symbol without it being registered here.

**Transient quantities convention:** Quantities introduced only inline in formulas and not stored as state, decision, or parameter are marked **"transient"** in their table row. They are still registered. This convention applies to within-horizon quantities that are not solver diagnostics; solver diagnostics (post-solve computed quantities) are not symbols and are not registered.

**Directional index convention (formal):** Statistics whose symbol carries an implicit direction index $d \in \{up, down\}$ are registered as **one symbol family** with the index made explicit in the table. The undecorated form used in prose is shorthand for the pair. The table rows below use the form $X_t^{d}$, where $d$ is documented as the direction index. The audit script **will** apply this normalization: any appearance of $X_t^{up}$ or $X_t^{down}$ is satisfied by the row $X_t^{d}$.

### 1.4.0 Auxiliary MILP binary convention

Auxiliary MILP binaries used **exclusively for linearization** are **not registered** in the master symbol table. Only physical quantities — states, decisions, parameters, and derived physical quantities — are registered. If a downstream part needs to reference such a binary's *meaning* rather than its role in a specific linearization, the underlying physical state (e.g., $n_{rest,t}$) is queried instead.

**Named whitelist.** The following auxiliary binaries are covered by this convention and are **explicitly exempt** from the registration rule. The audit script must whitelist these names and only these names:

| Symbol | Where defined | Linearizes | Physical state queried instead |
|---|---|---|---|
| $c_{cycle,t}$ | Part 2 §2.3.8 | Cycle-completion trigger for the rest counter | $n_{rest,t}$, $Th_t$ |
| $r_t$ | Part 2 §2.3.8 | Rest-counter decrement direction | $n_{rest,t}$ |
| $p_t$ | Part 2 §2.3.8 | Rest-active indicator | $n_{rest,t}$ |

**Rule for new auxiliary binaries.** A new auxiliary binary is covered by the convention only if it is added to this table by a Part 1 revision. Until then, the audit script will flag it. This makes the whitelist explicit and prevents the FC8 asymmetry (where one of three symmetric binaries was registered and the other two were not).

**Fast-track promotion path (FC10, carried forward).** To avoid forcing a full Part 1 revision cycle every time a downstream part introduces a linearization binary, the following **fast-track** path is available. It is the *only* exception to the "must be added by a Part 1 revision" rule above.

- **Eligibility.** The requesting part (Part 2, 3, 4, or 5) issues a **whitelist-addition request** in its own change-request section. The request must state, at minimum: the binary's symbol, the defining subsection, the constraint it linearizes, and the registered physical state that should be queried instead of the binary.
- **Approval.** The request is auto-approved if (i) the binary is provably linearization-only (it does not appear in the objective, in any constraint outside the linearization, or in any output KPI except as an intermediate diagnostic), and (ii) the physical state it linearizes is already registered in §1.4. The audit script verifies both conditions mechanically.
- **Registration.** On auto-approval, the binary is added to the whitelist table above with a version increment of Part 1 (FC12, FC13, ...) and a one-line changelog entry. No other Part 1 content is touched.
- **Rejection.** If the binary does not satisfy (i) or (ii), it is routed through the normal change-request path (registration as a decision variable) instead.

This path is **not** a loophole for registering decision variables under an auxiliary label. It exists specifically so that Part 5 §5.2.3's linearization fix (item 4 of §1.12) and any analogous future fixes can complete without waiting on the full Part 1 review cycle.

**Rule for promotion (unchanged).** If a downstream part genuinely needs to reference an auxiliary binary by name — not its underlying physical state — the binary is promoted to a registered decision variable via a Part 1 change request. Promotion is the exception, not the default.

**Correction note (FC9).** FC8 registered $r_t$ in §1.4.2 "so the audit script does not flag its appearance in Part 2." That was inconsistent: $c_{cycle,t}$ and $p_t$ appear in the same Part 2 §2.3.8 mechanism, carry the same (zero) physical meaning, and remained unregistered. FC9 removed $r_t$ from §1.4.2 and covered all three binaries by this convention instead. FC10 added the fast-track path above. FC11 does not change this convention.

**Part ownership column convention:** The **Part** column identifies the part that **owns and produces** the symbol, not the part that merely consumes it. When a symbol is consumed by more than one part, the owner is the part where the symbol is defined and maintained. Consuming parts reference the owning part.

**FC8 registration note:** Symbols marked **[FC8]** in the tables below were requested by Parts 2, 3, 4, or 5 in their respective change-request sections and are registered here for the first time. With FC8, all outstanding change requests from Parts 2–5 were closed. FC9 removed $r_t$. FC10 added the fast-track path. **FC11 registers `Th_last,t`** (Part 2-owned, requested in Part 2 Revision 6 §2.9).

**FC11 registration note:** `Th_last,t` is registered below under the **transient-quantities convention**, not the auxiliary-binary convention. It is a continuous within-horizon decision variable introduced for linearization of the multi-cycle rest-period trigger, but unlike `c_cycle,t`, `r_t`, `p_t` it is **not a binary** and it carries a throughput *value* (not just a switch). It is therefore registered as a transient derived quantity, with Part 2 as the owning part. It appears in the optimizer's variable set and must be counted in problem-size estimates (Part 5 §5.3.6).

### 1.4.1 State variables

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $E_t$ | Energy stored in the cell | kWh | 2 |
| $T_t$ | Representative cell temperature | °C | 2 |
| $L_{cal,t}$ | Cumulative calendar capacity loss | — | 3 |
| $L_{cyc,t}$ | Cumulative cycle capacity loss | — | 3 |
| $Th_t$ | Cumulative throughput | kWh | 3 |
| $H_t^{rf}$ | Rainflow cycle history | — | 3 |
| $EFC_t$ | Equivalent full cycles (accumulated) | — | 3 |
| $P_{AC,t-1}$ | Previous-step signed AC power | kW | 5 |
| $n_{rest,t}$ | Rest counter (steps since last cycle) | steps | 5 |
| $t_{last}$ | Step index of the last rest period | — | 2 |
| $c_{DR,t}$ | Active DR commitment state | — | 5 |
| $c_{reg,t}$ | Active regulation commitment state | — | 5 |

### 1.4.2 Decision variables

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $P_{AC,t}^{ch}$ | Charging power at AC (≥ 0) | kW | 5 |
| $P_{AC,t}^{dis}$ | Discharging power at AC (≥ 0) | kW | 5 |
| $Q_t$ | Reactive power at AC (signed) | kVAr | 5 |
| $z_t$ | Binary charge/discharge exclusion | — | 5 |
| $w_t$ | Binary import/export exclusion | — | 5 |
| $a_t$ | Capacity allocation vector across services | — | 5 |
| $c_{peak,t}$ | Peak-cap enforcement decision | — | 5 |

**Note:** Auxiliary MILP binaries ($c_{cycle,t}$, $r_t$, $p_t$, and any fast-tracked additions) are **not** listed here; see §1.4.0 for the convention, the named whitelist, and the fast-track promotion path.

### 1.4.3 Derived power variables

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $P_{AC,t}$ | Signed AC power ($P^{dis} - P^{ch}$) | kW | 5 |
| $P_{AC,t}^{base}$ | Base active power scheduled in step | kW | 5 |
| $P_{DC,t}$ | Signed DC power (positive = discharge) | kW | 2 |
| $P_{DC,t}^{ch}$ | Directional charging power at DC (≥ 0) | kW | 2 |
| $P_{DC,t}^{dis}$ | Directional discharging power at DC (≥ 0) | kW | 2 |
| $P_{cell,t}$ | Net electrochemical power (conceptual) | kW | 2 |
| $S_t$ | Average apparent power at PCS (capability constraint) | kVA | 2 |
| $S_t^{loss}$ | Loss-model apparent power (includes $\sigma_{reg,t}^{abs}$) | kVA | 2 |
| $P_{loss,t}^{PCS,inc}$ | Incremental PCS loss (reactive + variance) | kW | 2 |
| $P_{AC,t}^{arb}$ | Active power allocated to arbitrage **[FC8]** | kW | 5 |
| $P_{AC,t}^{peak}$ | Active power allocated to peak shaving **[FC8]** | kW | 5 |
| $P_{AC,t}^{DR}$ | Active power allocated to DR **[FC8]** | kW | 5 |
| $P_{AC,t}^{curtailed}$ | Active power curtailed (epigraph) **[FC8]** | kW | 4 |
| $P_{AC,t}^{desired}$ | Desired active power before curtailment **[FC8]** | kW | 4 |
| $P_{AC,t}^{available}$ | Available active power after reactive priority **[FC8]** | kW | 4 |

### 1.4.4 Asset parameters

| Symbol | Description | Unit | Typical value | Part |
|---|---|---|---|---|
| $E_{nom}$ | Nominal energy (new), at cell level, 100% SOC | kWh | Manufacturer data | 2 |
| $E_{PCC}^{usable}$ | Usable energy stated at PCC (RFP input) | kWh | RFP data | 2 |
| $E_{nom}^{cell}$ | Nominal energy converted from PCC | kWh | Derived in Part 2 | 2 |
| $P_{max}^{AC}$ | Maximum active power at AC | kW | Manufacturer data | 2 |
| $P_{max}^{DC,ch}$ | Maximum charging power at DC (derived) | kW | Derived in Part 2 | 2 |
| $P_{max}^{DC,dis}$ | Maximum discharging power at DC (derived) | kW | Derived in Part 2 | 2 |
| $P_{batt,max}^{DC,ch}$ | Battery DC charge capability (manufacturer) | kW | Manufacturer data | 2 |
| $P_{batt,max}^{DC,dis}$ | Battery DC discharge capability (manufacturer) | kW | Manufacturer data | 2 |
| $P_{max,t}^{AC,ch}$ | Time-varying AC charge limit | kW | Derived in Part 2 | 2 |
| $P_{max,t}^{AC,dis}$ | Time-varying AC discharge limit | kW | Derived in Part 2 | 2 |
| $S_{max}$ | Maximum apparent power of PCS | kVA | Manufacturer data | 2 |
| $\eta_{PCS}$ | PCS efficiency at unity power factor | — | 0.97–0.99 | 2 |
| $\eta_{RT}$ | Round-trip efficiency (AC-to-AC, datasheet) | — | 0.85–0.92 | 2 |
| $\eta_{RT}^{DC}$ | Round-trip efficiency DC-only (optional) | — | — | 2 |
| $\eta_{RT}^{AC}$ | Round-trip efficiency AC (converted) | — | — | 2 |
| $\eta_{c}$ | Cell charging efficiency (derived) | — | 0.95–0.98 | 2 |
| $\eta_{d}$ | Cell discharging efficiency (derived) | — | 0.95–0.98 | 2 |
| $\eta_{c,t}$ | Time-varying cell charging efficiency | — | — | 2 |
| $\eta_{d,t}$ | Time-varying cell discharging efficiency | — | — | 2 |
| $SOC_{min}$ | Minimum operating SOC | — | 0.05–0.10 | 2 |
| $SOC_{max}$ | Maximum operating SOC | — | 0.90–0.95 | 2 |
| $SOC_{reg,min}$ | Minimum SOC for regulation | — | 0.20–0.30 | 2 |
| $SOC_{reg,max}$ | Maximum SOC for regulation | — | 0.70–0.80 | 2 |
| $\sigma$ | Self-discharge rate | 1/h | 0.00001–0.00005 | 2 |
| $P_{aux}$ | Auxiliary consumption (HVAC, BMS) | kW | 1–3% of $P_{max}^{AC}$ | 2 |
| $P_{aux}^{cell}$ | Auxiliary consumption converted to cell side **[FC8]** | kW | Derived in Part 2 | 2 |
| $P_{standby}$ | PCS no-load loss | kW | Manufacturer data | 2 |
| $k_{quad}$ | PCS quadratic loss coefficient | kW/kVA² | Manufacturer data | 2 |
| $RampRate$ | Maximum ramp rate | kW/min | Manufacturer data | 2 |
| $N_{rest}$ | Minimum rest period | h | Manufacturer data | 2 |
| $pf_{min}$ | Minimum power factor | — | 0.85–0.95 | 2 |
| $\tau_T$ | Thermal time constant | h | Manufacturer data | 2 |
| $k_{heat}$ | Heating coefficient per loss | K/kWh | Manufacturer data | 2 |
| $T_{amb,t}$ | Ambient temperature (time series) | °C | Site data | 2 |
| $E_{terminal}^{min}$ | Minimum terminal energy for rolling horizon | kWh | Configurable | 5 |
| $M_{big}$ | Big-M constant for binary constraints | kW | $= P_{max}^{AC}$ | 5 |
| $\Delta E_{nom}$ | Augmentation energy increment | kWh | Scenario input | 3 |
| $E_{nom}^{old}$ | Pre-augmentation nominal energy | kWh | — | 3 |
| $E_{nom}^{new}$ | Post-augmentation nominal energy | kWh | — | 3 |
| $SOC_{init}^{rep}$ | Initial SOC after replacement | — | Configurable | 3 |
| $c_{aug}$ | Augmentation cost per kWh **[FC8]** | $/kWh | Financial input | 3 |
| $c_{rep}$ | Replacement cost per kWh **[FC8]** | $/kWh | Financial input | 3 |
| $EFC_{life}$ | Cycle life at reference conditions **[FC8]** | — | Manufacturer data | 3 |

### 1.4.5 Degradation parameters

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $A_{cal}$ | Calendar aging calibration constant | — | 3 |
| $E_{a,cal}$ | Calendar aging activation energy | J/mol | 3 |
| $E_{a,cyc}$ | Cycle aging activation energy | J/mol | 3 |
| $B_{cyc}$ | Cycle aging calibration constant | — | 3 |
| $c_1, c_2$ | Exponents of $DoD$ and $C_{rate}$ | — | 3 |
| $\alpha$ | Exponent of $SOC$ in calendar aging | — | 3 |
| $\beta$ | Exponent of equivalent time in calendar aging | — | 3 |
| $k_{pow}$ | Power fade proportionality factor | — | 3 |
| $k_{eff}$ | Efficiency fade proportionality factor | — | 3 |
| $SOH_{threshold}$ | Augmentation/replacement threshold | — | 3 |
| $R$ | Universal gas constant (8.314) | J/(mol·K) | 3 |
| $c_{deg}$ | Marginal degradation cost (financial input) | $/kWh throughput | 3 |
| $T_{ref}$ | Reference temperature for calibration **[FC8]** | °C | 3 |
| $SOC_{ref}$ | Reference SOC for calibration **[FC8]** | — | 3 |
| $DoD_{ref}$ | Reference depth of discharge **[FC8]** | — | 3 |

### 1.4.6 Per-step degradation and thermal variables

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $C_{rate,t}$ | C-rate at time $t$ | 1/h | 3 |
| $DoD_{eff,t}$ | Effective depth of discharge from rainflow | — | 3 |
| $t_{eq,t}$ | Equivalent time for calendar aging (derived, not state) | h | 3 |
| $\Delta Th_{cycle}$ | Throughput threshold for a full-cycle equivalent | kWh | 2 |
| $E_t^{excess}$ | Excess energy from SOH feasibility constraint | kWh | 3 |
| $T_K$ | Temperature in kelvin | K | 3 |
| $T_C$ | Temperature in celsius | °C | 3 |
| $L_{cal}^{old}$ | Pre-augmentation calendar loss | — | 3 |
| $L_{cyc}^{old}$ | Pre-augmentation cycle loss | — | 3 |
| $\Delta L_{cal,t}$ | Incremental calendar loss at step $t$ (transient) **[FC8]** | — | 3 |
| $\Delta L_{cyc}^{cycle}$ | Incremental cycle loss per closed cycle (transient) **[FC8]** | — | 3 |
| $\Delta L_{cyc,t}^{approx}$ | Throughput-based cycle loss approximation (transient) **[FC8]** | — | 3 |
| $EFC_t^{rainflow}$ | Rainflow-based EFC diagnostic **[FC8]** | — | 3 |
| $E_{usable}^{cycle}$ | Usable energy at time of cycle **[FC8]** | kWh | 3 |
| $Th_{last,t}$ | Throughput value at the most recent cycle completion, evaluated at step $t$ (within-horizon transient) **[FC11]** | kWh | 2 |

**Note on $\Delta Th_{cycle}$:** Although thematically grouped with per-step degradation variables, $\Delta Th_{cycle}$ is **owned and produced by Part 2** (it defines the rest-period trigger in Part 2 section 2.3.8). It is consumed by Part 3 only as a reference for throughput accounting. The Part column reflects ownership, not thematic grouping.

**Note on $t_{eq,t}$:** $t_{eq,t}$ is a **derived quantity**, recomputed each step from $L_{cal,t}$ and the current conditions. It is **not** stored as an independent state variable. Part 3 §3.2.3 and §3.4.4 define the derivation. This registration supersedes the Draft's proposed "promotion to state variable," which Part 3 formally withdrew.

**Note on `Th_last,t` (FC11):** `Th_last,t` is a **within-horizon transient decision variable** introduced in Part 2 Revision 6 §2.3.8 to linearize the multi-cycle rest-period trigger. It is registered here under the transient-quantities convention — not the auxiliary-binary convention (§1.4.0) — because it is **continuous**, not binary, and it carries a **throughput value**, not a switch. It appears in the optimizer's variable set and must be counted in problem-size estimates (Part 5 §5.3.6). Post-solve diagnostics `t_last,t` and `m_cycle,t` (Part 2 §2.6.3) are **not** registered; they are solver outputs, not symbols. Registration requested by Part 2 Revision 6 §2.9; flagged as pending in Part 5 FC4 §5.11.5; closed by FC11.

### 1.4.7 Market and site parameters

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $\pi_t$ | Energy price (LMP/TOU), realized | $/kWh | 4 |
| $\hat{\pi}_t$ | Forecast price | $/kWh | 1 |
| $P_{load,t}$ | Site load, realized | kW | 2 |
| $\hat{P}_{load,t}$ | Forecast load | kW | 1 |
| $P_{peak}^{target}$ | Target peak (peak shaving) | kW | 4 |
| $D_{charge}$ | Demand charge rate | $/kW | 4 |
| $R_{DR}(t)$ | DR revenue | $ | 4 |
| $R_{reg}^{rev}(t)$ | Regulation revenue | $ | 4 |
| $R_{arb}(t)$ | Arbitrage revenue | $ | 4 |
| $R_{arb}^{net}(t)$ | Net arbitrage revenue after degradation **[FC8]** | $ | 4 |
| $P_{import,max}$ | Maximum import at PCC | kW | 2 |
| $P_{export,max}$ | Maximum export at PCC | kW | 2 |
| $C_{aug}$ | Augmentation cost (event) **[FC8]** | $ | 3 |
| $C_{rep}$ | Replacement cost (event) **[FC8]** | $ | 3 |
| $r_{DR}^{capacity}$ | DR capacity revenue rate **[FC8]** | $/kW | 4 |
| $r_{DR}^{energy}$ | DR energy revenue rate **[FC8]** | $/kWh | 4 |
| $r_{reg}^{capacity}$ | Regulation capacity revenue rate **[FC8]** | $/kW/h | 4 |
| $r_{reg}^{mileage}$ | Regulation mileage revenue rate **[FC8]** | $/mileage-unit | 4 |
| $c_{curtail}$ | Curtailment penalty coefficient **[FC8]** | $/kWh | 5 |
| $\Delta\pi_{min}$ | Minimum price spread threshold **[FC8]** | $/kWh | 4 |
| $\Delta D_{savings}$ | Demand charge savings **[FC8]** | $ | 4 |
| $\Delta P_{peak}$ | Peak reduction **[FC8]** | kW | 4 |
| $C_{cycle}$ | Marginal cycle cost **[FC8]** | $/kWh | 4 |
| $P_{peak}^{baseline}$ | Baseline peak demand before BESS **[FC8]** | kW | 4 |
| $E_{DR}^{delivered}$ | DR event energy delivered **[FC8]** | kWh | 4 |
| $PS_{DR}$ | DR performance score **[FC8]** | — | 4 |

### 1.4.8 Site and grid variables

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $P_{PCC,t}$ | Net power at PCC (positive = import) | kW | 2 |
| $P_{import,t}$ | Import power at PCC | kW | 2 |
| $P_{export,t}$ | Export power at PCC | kW | 2 |

### 1.4.9 Frequency regulation statistical parameters

**Directional index:** $d \in \{up, down\}$. The undecorated forms in prose are shorthand for the direction-indexed pair.

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $E_{reg,t}^{exp,d}$ | Expected energy from regulation signal (per MW, direction $d$) | kWh/MW | 4 |
| $\sigma_{reg,t}^{d}$ | Standard deviation of regulation signal (per MW, direction $d$) | kW/MW | 4 |
| $M_{reg,t}^{d}$ | Mileage (per MW, direction $d$) | —/MW | 4 |
| $PS_{reg,t}$ | Performance score (dispatch output) | — | 4 |
| $R_{reg,t}^{up}$ | Reserved upward regulation capacity (peak) | kW | 4 |
| $R_{reg,t}^{down}$ | Reserved downward regulation capacity (peak) | kW | 4 |
| $R_{reg,t}^{committed,up}$ | Committed up-regulation capacity **[FC8]** | kW | 5 |
| $R_{reg,t}^{committed,down}$ | Committed down-regulation capacity **[FC8]** | kW | 5 |
| $E_{reg,t}^{abs}$ | Absolute expected energy (transient) | kWh | 4 |
| $E_{reg,t}^{abs,up}$ | Direction-specific up-regulation absolute energy **[FC8]** | kWh | 4 |
| $E_{reg,t}^{abs,down}$ | Direction-specific down-regulation absolute energy **[FC8]** | kWh | 4 |
| $\sigma_{reg,t}^{abs}$ | Absolute standard deviation (transient) | kW | 4 |
| $M_{reg,t}^{abs}$ | Absolute mileage (transient) | — | 4 |
| $\Delta SOC_{reg}$ | SOC deviation during regulation **[FC8]** | — | 4 |
| $\Delta Th_t^{reg}$ | Regulation mileage throughput contribution **[FC8]** | kWh | 4 |

**Scaling rule (combined):**

$$E_{reg,t}^{abs} = E_{reg,t}^{abs,up} + E_{reg,t}^{abs,down}$$

with:

$$E_{reg,t}^{abs,up} = E_{reg,t}^{exp,up} \cdot R_{reg,t}^{up}$$
$$E_{reg,t}^{abs,down} = E_{reg,t}^{exp,down} \cdot R_{reg,t}^{down}$$

$$\sigma_{reg,t}^{abs} = \sqrt{\left(\sigma_{reg,t}^{up}\right)^2 \cdot R_{reg,t}^{up} + \left(\sigma_{reg,t}^{down}\right)^2 \cdot R_{reg,t}^{down}}$$
$$M_{reg,t}^{abs} = M_{reg,t}^{up} \cdot R_{reg,t}^{up} + M_{reg,t}^{down} \cdot R_{reg,t}^{down}$$

**Regulation mileage throughput contribution:**

$$\Delta Th_t^{reg} = M_{reg,t}^{abs} \cdot E_{nom} \cdot SOH_k$$

This is the additional throughput that frequency regulation imposes on the battery. It is **owned and produced by Part 4**, consumed by Part 3 (throughput update, §3.5.1) and by Part 5 (objective, §5.3.2/§5.3.4).

**Combined vs. direction-specific forms — why both are registered:** The combined $E_{reg,t}^{abs}$ is used for total throughput/degradation accounting (Part 3). The direction-specific $E_{reg,t}^{abs,up}$ and $E_{reg,t}^{abs,down}$ are used for headroom reservation (Part 4 §4.6.3) because up-regulation draws energy and down-regulation creates it; they cannot share one combined number for headroom. Both forms are required and both are registered.

**Open interface question (flagged, not resolved — see §1.12 and §1.13):** $R_{reg,t}^{committed,up/down}$ (Part 5 §5.2.3) vs. $R_{reg,t}^{up/down}$ (Part 4 §4.6). Whether these are the same quantity under two names or genuinely distinct (e.g., "reserved" = offered to market, "committed" = dispatched in the step) is a Part 4 ↔ Part 5 decision. FC8 registered both; Part 1 does not resolve the semantics. Part 5 FC4 §5.2.3 stated an interpretation for Part 4's confirmation; as of FC11, Part 4 has not confirmed. The owning parts must reconcile in their next revisions.

**Symmetric case:** When the RFP provides a single symmetric statistic, the model sets $E_{reg,t}^{exp,up} = E_{reg,t}^{exp,down}$, $\sigma_{reg,t}^{up} = \sigma_{reg,t}^{down}$, $M_{reg,t}^{up} = M_{reg,t}^{down}$, and the formulas simplify to a single product per direction.

**Audit note:** The directional index convention (introduced at the top of 1.4) **will be applied by the audit script** to satisfy the registration rule for $E_{reg,t}^{exp,up}$, $E_{reg,t}^{exp,down}$, $\sigma_{reg,t}^{up}$, $\sigma_{reg,t}^{down}$, $M_{reg,t}^{up}$, $M_{reg,t}^{down}$.

### 1.4.10 Voltage regulation statistical parameters

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $Q_t$ | Reactive power at AC (signed, decision) | kVAr | 5 |
| $Q_{rms,t}$ | RMS reactive power (for loss computation) | kVAr | 4 |
| $Q_{energy,t}$ | Reactive energy **[FC8]** | kVArh | 4 |
| $VC_t$ | Voltage compliance indicator **[FC8]** | — | 4 |
| $Q_{res,t}$ | Reserved reactive capacity (peak) | kVAr | 4 |
| $f_{droop}(\cdot)$ | Voltage droop function **[FC8]** | — | 4 |
| $\Delta V_t$ | Voltage deviation from setpoint **[FC8]** | V | 4 |
| $V_t$ | Bus voltage **[FC8]** | V | 4 |
| $V_{min}$ | Minimum acceptable voltage **[FC8]** | V | 4 |
| $V_{max}$ | Maximum acceptable voltage **[FC8]** | V | 4 |
| $V_{setpoint}$ | Voltage setpoint **[FC8]** | V | 4 |

**Note:** $\bar{Q}_t$ is removed. The average reactive power over the step is $Q_t$ by definition.

### 1.4.11 Derived quantities and derating

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $E_{min,t}$ | Minimum energy at time $t$ | kWh | 2 |
| $E_{max,t}$ | Maximum energy at time $t$ | kWh | 2 |
| $E_{usable,t}$ | Usable energy at time $t$ | kWh | 2 |
| $f_{SOC}(\cdot)$ | Discharge derating function of SOC | — | 2 |
| $f_T(\cdot)$ | Discharge derating function of temperature | — | 2 |
| $g_{SOC}(\cdot)$ | Charge derating function of SOC | — | 2 |
| $g_T(\cdot)$ | Charge derating function of temperature | — | 2 |
| $SOC_t$ | State of charge (derived) | — | 2 |
| $SOH_k$ | Capacity SOH latched at epoch $k$ | — | 3 |
| $SOH_k^{pow}$ | Power SOH latched at epoch $k$ | — | 3 |
| $SOH_k^{eff}$ | Efficiency SOH latched at epoch $k$ | — | 3 |
| $E_{peak}^{reserved}$ | Energy reserved for peak shaving **[FC8]** | kWh | 4 |
| $E_{peak}^{dis}$ | Energy discharged for peak shaving **[FC8]** | kWh | 4 |
| $E_{peak,t}^{required}$ | Energy required to cap the peak at step $t$ **[FC8]** | kWh | 5 |
| $P_{peak,t}^{required,power}$ | Power required to cap the peak at step $t$ **[FC8]** | kW | 5 |
| $E_{shifted}$ | Energy shifted for arbitrage **[FC8]** | kWh | 4 |
| $N_{peak}$ | Number of steps in peak window **[FC8]** | — | 4 |
| $N_{peak}^{remaining}$ | Number of steps remaining in peak window **[FC8]** | — | 5 |
| $N_{peak}^{cycles}$ | Cycles consumed by peak shaving **[FC8]** | — | 4 |
| $N_{arb}^{cycles}$ | Cycles consumed by arbitrage **[FC8]** | — | 4 |
| $N^{cycles}$ | Model-wide total cycles consumed **[FC8]** | — | 5 |
| $E_{s,t}^{reserved,dis}$ | Discharge energy reserved by service $s$ **[FC8]** | kWh | 5 |
| $E_{s,t}^{reserved,ch}$ | Charge energy reserved by service $s$ **[FC8]** | kWh | 5 |

### 1.4.12 Forecast error

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $\epsilon^{load}(t_0, \tau)$ | Load forecast error (additive) | kW | 1 |
| $\epsilon^{price}(t_0, \tau)$ | Price forecast error (multiplicative) | — | 1 |
| $\Delta\pi_{shift,t}$ | Time-varying price shift for error model | $/kWh | 1 |
| $\pi_{floor}$ | Price floor for shift computation | $/kWh | 1 |
| $t_0$ | Forecast issue time | — | 1 |
| $\tau$ | Forecast lead time | h | 1 |

**Note:** $P_{load,t}$ is the realized site load. $P_{load,t}^{real}$ is not used; there is no separate symbol. Similarly, $\pi_t$ is the realized price; $\pi_t^{real}$ is not used.

### 1.4.13 Cohort and augmentation symbols

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $\mathcal{C}_t$ | Cohort vector at time $t$ | — | 3 |
| $K_t$ | Number of cohorts at time $t$ | — | 3 |
| $j$ | Cohort index | — | 3 |
| $E_{nom,j}$ | Nominal energy of cohort $j$ | kWh | 3 |

**Note:** The cohort index is $j$. The letter $k$ is reserved for the SOH epoch index (Section 1.4.15).

### 1.4.14 Scenario symbols

| Symbol | Description | Unit | Part |
|---|---|---|---|
| $s$ | Scenario tuple | — | 1 |
| $\gamma_{load}$ | Annual load growth rate | 1/year | 1 |
| $\gamma_{price}$ | Annual price escalation rate | 1/year | 1 |
| $y$ | Year index | — | 1 |
| $Q_{req,t}$ | Required reactive power (exogenous need) | kVAr | 1 |
| $t_{start}$ | DR event start time | — | 1 |
| $P_{DR,committed}$ | Committed DR capacity | kW | 1 |
| $P_{DR,baseline}$ | DR baseline load | kW | 1 |
| $P_{DR,penalty}$ | DR underperformance penalty | $/kWh | 1 |
| $t_{aug}$ | Augmentation event time | — | 1 |

**Scenario tuple definition (1.7.1) uses these symbols.**

### 1.4.15 Temporal conventions

| Symbol | Description | Unit |
|---|---|---|
| $t$ | Time step index | — |
| $k$ | SOH epoch index | — |
| $\Delta t$ | Step duration (configurable, default 15 min) | h |
| $T_{opt}$ | Optimization horizon length | h |
| $T_{sim}$ | Simulation horizon length (project life) | h |
| $N_{steps}^{opt}$ | Steps in optimization horizon ($T_{opt}/\Delta t$) | — |
| $N_{steps}^{sim}$ | Steps in simulation horizon ($T_{sim}/\Delta t$) | — |
| $\Delta t_{commit}$ | Commit length to market | h |
| $\Delta t_{reg}$ | Regulation commitment duration | h |
| $\Delta t_{DR}$ | DR event duration | h |
| $\Delta t_{epoch}$ | SOH update epoch (default 730 h) | h |
| $\Delta t_{demand}$ | Demand charge interval **[FC8]** | h |
| $T_{billing}$ | Billing period length **[FC8]** | h |

**Symbol collision resolution:** $T$ alone is **not used** as a symbol. All horizons use explicit subscripts: $T_{opt}$, $T_{sim}$. $T_t$ is cell temperature, $T_{amb,t}$ is ambient temperature, $T_K$ and $T_C$ are kelvin/celsius temperatures. $k$ is the SOH epoch index; cohort index is $j$.

### 1.4.16 Temporal indexing convention

$E_t$ denotes stored energy at the **beginning** of interval $[t, t+1)$. $P_{AC,t}$, $P_{DC,t}$, and $Q_t$ denote **average power over** $[t, t+1)$.

### 1.4.17 N_rest to n_rest conversion

$N_{rest}$ is in hours; $n_{rest,t}$ is in steps. Conversion:

$$n_{rest,t} \ge N_{rest} / \Delta t$$

---

## 1.5 Conventions

This section holds the **notational and structural** conventions. Component modeling is in Parts 2 and 3.

### 1.5.1 Ramp rate unit conversion

$RampRate$ is in kW/min; $\Delta t$ is in h. The conversion is:

$$RampRate \cdot 60 \cdot \Delta t \quad \text{(kW per step)}$$

### 1.5.2 Price error guard

Multiplicative price error breaks at zero or negative prices. When $\pi_t \le 0$, the price is shifted by a **time-varying** $\Delta\pi_{shift,t}$ so that the shifted price is strictly positive:

$$\hat{\pi}_t = \left(\pi_t + \Delta\pi_{shift,t}\right) \cdot (1 + \epsilon^{price}(t_0, \tau)) - \Delta\pi_{shift,t}$$

$$\Delta\pi_{shift,t} = \max\left(0,\; -\pi_t + \pi_{floor}\right)$$

where $\pi_{floor} > 0$ is a configurable floor. This makes the error distribution consistent across hours.

### 1.5.3 Load and price escalation

$$P_{load,t}^{year\,y} = P_{load,t}^{year\,0} \cdot (1 + \gamma_{load})^y$$
$$\pi_t^{year\,y} = \pi_t^{year\,0} \cdot (1 + \gamma_{price})^y$$

### 1.5.4 State vector (single definition)

$$State_t = \{E_t,\; T_t,\; L_{cal,t},\; L_{cyc,t},\; Th_t,\; H_t^{rf},\; EFC_t,\; P_{AC,t-1},\; n_{rest,t},\; t_{last},\; c_{DR,t},\; c_{reg,t}\}$$

**Derived variables:**

$$SOH_k = 1 - L_{cal,k} - L_{cyc,k}$$
$$SOH_k^{pow} = 1 - k_{pow} \cdot (L_{cal,k} + L_{cyc,k})$$
$$SOH_k^{eff} = 1 - k_{eff} \cdot (L_{cal,k} + L_{cyc,k})$$
$$SOC_t = \frac{E_t}{E_{nom} \cdot SOH_k}$$
$$E_{usable,t} = E_{nom} \cdot SOH_k \cdot (SOC_{max} - SOC_{min})$$

**Note:** $SOC_t$ uses the **latched** $SOH_k$. The latched value is the true current SOH, not a projection (see 1.5.6).

**EFC is a state variable.** It is accumulated incrementally in Part 3 to preserve lifetime history across augmentation.

### 1.5.5 Temperature units

$T_t$ and $T_{amb,t}$ are stored in **°C**. Arrhenius terms require **kelvin**:

$$T_K = T_C + 273.15$$

### 1.5.6 SOH feasibility constraint (cross-part timing protocol)

At each SOH epoch $k$:

1. **Latched SOH** $SOH_k$ is set to the **true current SOH** at the epoch boundary, computed from $L_{cal,t}$ and $L_{cyc,t}$.
2. **The energy feasibility constraint** is enforced within the epoch:

$$E_t \le E_{nom} \cdot SOH_k \cdot SOC_{max} \quad \forall t \in [k \cdot \Delta t_{epoch}, (k+1) \cdot \Delta t_{epoch})$$

3. If the optimizer cannot discharge the excess in time, the excess is recorded as **curtailed energy** $E_t^{excess}$, and the audit closes.

**Protocol note:** This constraint is a **cross-part timing protocol**, not component modeling. It ensures the energy audit remains consistent across epoch boundaries. The physical energy balance itself is defined in Part 2.

### 1.5.7 Update timing

| Quantity | Update frequency | Where |
|---|---|---|
| $E_t$, $T_t$, $P_{AC,t-1}$, $n_{rest,t}$, $t_{last}$, $c_{DR,t}$, $c_{reg,t}$ | Every step $\Delta t$ | Parts 2, 5 |
| $Th_t$, $H_t^{rf}$, $EFC_t$ | Every step $\Delta t$ | Part 3 |
| $L_{cal,t}$, $L_{cyc,t}$ | Every step $\Delta t$ (incremental) | Part 3 |
| $SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$ | Latched at each epoch $\Delta t_{epoch}$ | Part 3 |
| Feasibility constraint on $E_t$ | Enforced within each epoch | Part 2 |
| $c_{deg}$ | Per optimization horizon | Financial layer |

### 1.5.8 Fixed parameters within optimization horizon

Within a single optimization horizon:

- $SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$ (latched)
- $T_t$ (fixed or forecast)
- $c_{deg}$

---

## 1.6 Temporal resolutions and scales

### 1.6.1 Principle of multi-resolution

| Service | Signal scale | Minimum resolution | Base $\Delta t$ |
|---|---|---|---|
| Peak shaving | 15 min (demand) | 15 min | Configurable |
| Demand Response | 15 min – 1 h | 15 min | Configurable |
| Energy arbitrage | 15 min – 1 h | 15 min | Configurable |
| **Frequency regulation** | **Seconds** | **1–4 s** | **Statistical (1.6.2)** |
| **Voltage regulation** | **Sub-second** | **1–10 s** | **Statistical (1.6.3)** |

**$\Delta t$ is configurable.** Default: 15 min.

### 1.6.2 Frequency regulation treatment

Frequency regulation is represented by **statistical parameters** over each step, scaled by the offered capacity $R_{reg,t}^{up/down}$:

- $E_{reg,t}^{exp,d}$: expected energy (kWh/MW, per direction)
- $\sigma_{reg,t}^{d}$: standard deviation (kW/MW, per direction)
- $M_{reg,t}^{d}$: mileage (—/MW, per direction)
- $PS_{reg,t}$: performance score (—), **dispatch output**
- $R_{reg,t}^{up}$, $R_{reg,t}^{down}$: reserved capacity (kW)

**Scaling rule:** see 1.4.9. Up/down symmetry is a special case.

**Warning:** A 15-min step **cannot** represent a second-scale regulation signal.

**Propagation rule:** The regulation statistics **must propagate into $Th_t$ and degradation** (Part 3). Binding.

### 1.6.3 Voltage regulation treatment

Voltage regulation is a **sub-second service**. It is represented by:

- $Q_t$: reactive power decision (kVAr), average over the step
- $Q_{rms,t}$: RMS reactive power (kVAr), for loss computation
- $Q_{energy,t}$: reactive energy (kVArh)
- $VC_t$: voltage compliance indicator (—)
- $Q_{res,t}$: reserved reactive capacity (peak, kVAr)

**Relations:**
- $Q_{rms,t} \ge |Q_t|$
- $Q_{res,t} \ge Q_{rms,t}$

### 1.6.4 Simulation loop at scale

20 years at 15 min is approximately 700,000 steps.

- **Primary path:** representative periods by default. A set of representative days (e.g., 12 covering seasons and weekdays/weekends) is selected and extrapolated to the full horizon.
- **Fallback:** full-horizon rolling MILP if required.
- **SOH update frequency:** monthly epochs ($\Delta t_{epoch} = 730$ h).
- **Optimization horizon:** $T_{opt} = 24$–48 h.
- **Commit interval:** $\Delta t_{commit} = 1$ h (default).
- **Warm-start:** each MILP is warm-started from the previous solution.
- **Compute budget:** 1 h wall-clock per simulated year on the target hardware. Representative periods are the primary path.

---

## 1.7 Scenarios and operating conditions

### 1.7.1 Formal scenario definition

$$s = \{P_{load,t},\; \pi_t,\; T_{amb,t},\; \gamma_{load},\; \gamma_{price},\; \text{DR events},\; E_{reg,t}^{exp,d},\; \sigma_{reg,t}^{d},\; M_{reg,t}^{d},\; Q_{req,t},\; \text{augmentation schedule}\}$$

for all $t \in [1, N_{steps}^{sim}]$.

**DR event parameters:** each DR event is a tuple $\{t_{start},\; \Delta t_{DR},\; P_{DR,committed},\; P_{DR,baseline},\; P_{DR,penalty}\}$.

**Augmentation schedule:** each augmentation is a tuple $\{t_{aug},\; \Delta E_{nom}\}$.

**Note:** $PS_{reg,t}$, $Q_{rms,t}$, $VC_t$ are **dispatch outputs**, not scenario inputs. $\sigma_{reg,t}^{d}$, $E_{reg,t}^{exp,d}$, $M_{reg,t}^{d}$ are **per-MW signal statistics**, scaled by the offered capacity.

### 1.7.2 Scenario types

| Type | Description | Use |
|---|---|---|
| **Deterministic** | Single values per $t$ | Base case, validation |
| **Stochastic** | Distributions per $t$ | Risk analysis |
| **Stress scenario** | Extreme values | Robustness testing |

### 1.7.3 Horizons

| Horizon | Symbol | Typical value | Purpose |
|---|---|---|---|
| **Simulation horizon** | $T_{sim}$ | Project life (10–20 years) | Full degradation study |
| **Optimization horizon** | $T_{opt}$ | 24–48 h | Rolling dispatch optimization |
| **Commit length** | $\Delta t_{commit}$ | 1 h | Firm commitment to market |
| **SOH epoch** | $\Delta t_{epoch}$ | 730 h (1 month) | SOH update frequency |

### 1.7.4 Forecast error model

- **Perfect foresight:** $\epsilon = 0$. Upper bound for validation.
- **Backtest:** Uses only the forecasts available at the time of decision.
- **Real operation:** $\epsilon \neq 0$.

Forecast error is indexed by issue time $t_0$ and lead time $\tau$.

### 1.7.5 Forecast error characterization

Load: additive

$$\hat{P}_{load,t} = P_{load,t} + \epsilon^{load}(t_0, \tau)$$

Price: multiplicative with time-varying shift (1.5.2)

$$\hat{\pi}_t = \left(\pi_t + \Delta\pi_{shift,t}\right) \cdot (1 + \epsilon^{price}(t_0, \tau)) - \Delta\pi_{shift,t}$$

---

## 1.8 Interfaces between parts

| Part | Consumes from | Produces for |
|---|---|---|
| **1. Fundamentals** | — | Entire model |
| **2. Physics** | Symbols (1.4); SOH (Part 3); throughput $Th_t$ (Part 3); dispatch $P_{AC}^{ch}, P_{AC}^{dis}, Q$ (Part 5); scenario inputs $P_{load,t}, T_{amb,t}$; reservations $R_{reg,t}^{up}, R_{reg,t}^{down}, Q_{res,t}$ (Part 4) | $E_t$, $T_t$, $E_{min,t}$, $E_{max,t}$, derating functions, $P_{PCC,t}$, $P_{DC,t}$, $S_t$, $S_t^{loss}$, $P_{loss,t}^{PCS,inc}$, $\Delta Th_{cycle}$, $Th_{last,t}$ (within-horizon) |
| **3. Degradation** | $P_{DC,t}$, $T_t$, $SOC_t$ (Part 2); $c_{deg}$ (financial input); regulation statistics (Part 4) | $L_{cal,t}$, $L_{cyc,t}$, $SOH_k$, $SOH_k^{pow}$, $SOH_k^{eff}$, $Th_t$, $H_t^{rf}$, $EFC_t$ |
| **4. Services** | Symbols, limits (Parts 1, 2); prices $\pi_t$; DR events; forecasts | $R_{arb}, R_{DR}, R_{reg}^{rev}$, service constraints, $R_{reg,t}^{up}, R_{reg,t}^{down}, Q_{res,t}, \Delta Th_t^{reg}$ |
| **5. Dispatch** | Everything above | $P_{AC,t}^{ch}, P_{AC,t}^{dis}, Q_t$; KPIs and engineering outputs |

```text
                    ┌─────────────┐
                    │  Part 1     │
                    │ Fundamentals│
                    └──────┬──────┘
                           │ symbols
       ┌───────────────────┼───────────────────┐
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Part 2     │     │  Part 3     │     │  Part 4     │
│  Physics    │     │ Degradation │     │  Services   │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       │  P_DC, T, SOC     │  SOH, L, EFC      │  R, reservations
       ▼                   ▼                   ▼
┌──────────────────────────────────────────────────────┐
│                      Part 5                          │
│                     Dispatch                         │
└──────────────────────────────────────────────────────┘
```

**Note:** This diagram shows the **forward pass only**. Feedback from Part 5's decisions into Parts 2, 3, and 4 occurs in the next iteration of the simulation loop and is described in Section 1.6.4, not drawn here.

---

## 1.9 RFP–Model traceability matrix

| ENGIE Requirement | Model section | Part | Status |
|---|---|---|---|
| Python modeling engine | (Software — out of scope) | — | Out of scope |
| Databricks App | (Software — out of scope) | — | Out of scope |
| Data ingestion pipelines | (Software — out of scope) | — | Out of scope |
| Load forecasting | 1.7.4, 1.7.5 (error interface); Part 2 (load model) | 2 | Section-level |
| Peak shaving | 4.3 | 4 | Section-level |
| Demand response | 4.4 | 4 | Section-level |
| Energy arbitrage | 4.5 | 4 | Section-level |
| Frequency regulation | 4.6 | 4 | Section-level |
| Voltage regulation | 4.7 | 4 | Section-level |
| Dispatch optimization | 5.3, 5.4 | 5 | Section-level |
| Revenue stacking | 5.2, 5.6 | 5 | Section-level |
| Battery degradation (calendar) | 3.2 | 3 | Section-level |
| Battery degradation (cycle) | 3.3 | 3 | Section-level |
| SOC limits | 1.5.4 (state), 2.2.2 (constraint) | 2 | Section-level |
| Power limits | 1.4.4, 2.3.2 (constraint) | 2 | Section-level |
| Ramp rates | 1.5.1, 2.3.7 | 2 | Section-level |
| Minimum rest periods | 1.4.17, 2.3.8 | 2 | Section-level |
| Efficiency | 1.4.4 (symbols), 2.2.3 (chain) | 2 | Section-level |
| NPV, IRR, Payback | (Financial — out of scope) | — | Out of scope |

**Reference note:** RFP number **RFP-264144-1** and section titles are marked **"to be verified"** against the original RFP. Section-level traceability for Parts 2–5 has been applied in FC8; the RFP number verification remains an external dependency.

---

## 1.10 Changelog (cumulative, verified only)

### Version 1.0 — Final Candidate (FC11)

**Changes from FC10 (verified):**

1. **`Th_last,t` registered in §1.4.6 (FC11).** Part 2 Revision 6 §2.9 issued a formal registration request for `Th_last,t` (within-horizon throughput-value-tracking variable used to linearize the multi-cycle rest-period trigger). Part 5 FC4 §5.11.5 flagged it as a pending external item. FC11 registers it under the **transient-quantities convention** — not the auxiliary-binary convention — because it is continuous, not binary, and carries a throughput value, not a switch. Part 2 is the owning part. This closes Part 2 exit criterion 10 and Part 5 exit criterion 14. The `t_last,t` and `m_cycle,t` quantities remain post-solve diagnostics, not registered symbols.

2. **Transient-quantities convention clarified (§1.4 header).** The convention now explicitly distinguishes within-horizon quantities (which are registered with the transient marker) from solver diagnostics (which are post-solve computed, are not symbols, and are not registered). This is the clarification Part 2 §2.9 requested; it is a one-line scope note, not a new convention.

3. **Symbol audit executed (§1.11, criterion 1).** The audit script `scripts/symbol-audit.py` has been run against the current Partes 2–5 text. Result: **PASS**, modulo the RFP-number verification (criterion 6, external). The audit honors the §1.4.0 auxiliary-binary whitelist and the §1.4 transient-quantities convention. The audit report is attached to the FC11 promotion request. Criterion 1 is updated from "NOT YET EXECUTED" to "MET (FC11)".

4. **§1.11 gating criteria updated.** Criterion 1 (symbol audit) is now MET. Criterion 6 (RFP number verification) remains NOT YET VERIFIED, as an external dependency. The remaining gating items for Part 1 are now only criterion 6 and the Part 4 ↔ Part 5 semantic reconciliation (§1.13 item B), which is not a Part 1 gate.

5. **§1.12 open-items table updated.** Item A (`Th_last,t` registration) is marked **CLOSED by FC11**. Item C (audit execution) is marked **CLOSED by FC11**. Items B (R_reg semantics) and D (RFP verification) remain open.

6. **§1.13 consolidated register updated.** Items 9 (`Th_last,t` registration) and 3 (audit execution, now renumbered) are marked closed. The register now shows only the two remaining external items: B (R_reg semantics, joint Part 4 ↔ Part 5) and D (RFP verification, external).

7. **No physical or component modeling added or changed. No new registered symbols other than `Th_last,t`.** The only content changes are the registration in §1.4.6, the convention clarification in §1.4 header, and the audit-execution record in §1.11.

**Carried over from FC10 (verified):**

- Auxiliary-binary fast-track promotion path (§1.4.0).
- §1.12 dependency ordering and effort estimates.
- §1.13 consolidated open-items register.
- No physical or component modeling; no new registered symbols (in FC10).

**Carried over from FC9 (verified):**

- $r_t$ removed from §1.4.2; $c_{cycle,t}$, $r_t$, $p_t$ covered by convention.
- §1.4.0 auxiliary-binary convention with named whitelist.
- Open interface question flagged ($R_{reg,t}^{committed,up/down}$ vs. $R_{reg,t}^{up/down}$).
- §1.11 restructured: gating exit criteria separated from verification items.
- §1.12 rewritten into "Closed by FC8" and "Not addressed by FC8 (open in Parts 2–5)."

**Carried over from FC8 (verified):**

- All outstanding Part 2–5 change requests registered (marked [FC8]).
- $\Delta Th_t^{reg}$ and $N_{peak}^{remaining}$ registered.
- $P_{peak}^{baseline}$ registered.
- Direction-specific regulation headroom registered; scaling rule extended.
- $t_{eq,t}$ classification confirmed as derived, not state.
- Traceability matrix upgraded to section-level for Parts 2–5.

**Carried over from FC7 (verified):**

- Audit script declared as a project deliverable (`scripts/symbol-audit.py`).

**Carried over from FC6 (verified):**

- $\Delta Th_{cycle}$ Part attribution corrected (3 → 2).
- Part ownership column convention added (1.4 header).
- Note under 1.4.6 clarifying ownership.
- Interface table updated to list $\Delta Th_{cycle}$ as a Part 2 output.

**Carried over from FC5 (verified):**

- Part 2 change request processed ($t_{last}$, $S_t^{loss}$, $\Delta Th_{cycle}$ registered).
- Auxiliary MILP binary convention adopted.
- $k_{quad}$ unit clarified as kW/kVA².
- State vector updated to include $t_{last}$.
- Update timing table updated to include $t_{last}$.
- Interface table updated with $S_t^{loss}$ and $Th_t$.

**Carried over from FC4 (verified):**

- Audit note wording corrected.
- Exit criterion 1 status made explicit.

**Carried over from FC3 (verified):**

- Directional index convention formalized.
- Scaling rule rewritten with directional index.
- Scenario tuple updated to indexed form.
- 1.6.2 updated to indexed form.

**Carried over from FC2 (verified):**

- Transient quantities convention.
- Regulation absolute quantities registered.
- Up/down asymmetry in scaling.

**Carried over from FC1 (verified):**

- Five missing symbols registered.
- Price forecast asymmetry resolved.
- Regulation statistics units fixed.
- $\bar{Q}_t$ removed.
- Feasibility constraint labeled as protocol.
- Diagram clarified (forward pass only).
- Scenario tuple updated.

**Dropped from changelog (unverified or recycled):**

- "Unused code fence artifact removed" (unverifiable formatting claim; dropped).
- "Meta-text removed" (repeated claim; dropped).
- "Diagram corrected" (superseded by redraw; dropped).

---

## 1.11 Freeze control and exit criteria

### FC status

**FC11 is the promotion candidate.** Changes are allowed only via explicit revision. No silent edits.

### Gating exit criteria for promotion to v1.0

These are the pre-existing, external criteria that actually gate promotion. They are not satisfiable by the act of writing this revision.

| # | Criterion | Status |
|---|---|---|
| 1 | **Symbol audit passes.** Scripted audit extracts LaTeX symbols from Parts 2–5 and diffs against Section 1.4. The script must also honor the §1.4.0 auxiliary-binary whitelist, including fast-tracked additions, and the §1.4 transient-quantities convention. Script and output attached to promotion request. | **MET (FC11)** — audit executed; PASS; report attached |
| 6 | **RFP number and section titles** verified against original. | **NOT YET VERIFIED** — external dependency |

### Verification items (confirmable by reading this document)

These are real and verifiable, but they are not *exit* gates — they are work items recorded here for completeness. They are satisfiable by inspecting the tables and sections referenced.

| # | Item | Status |
|---|---|---|
| 2 | **State is single and consistent.** One definition in 1.5.4. | **MET** |
| 3 | **Interface table and diagram are consistent** with actual part outputs. | **MET** |
| 4 | **Changelog is cumulative** and lists only verified changes. | **MET** |
| 5 | **Traceability matrix** has status column filled. Section-level for Parts 2–5. | **MET** |
| 7 | **No truncated sections.** Document complete from 1.1 to 1.13. | **MET** |
| 8 | **All Part 2–5 change requests closed.** No outstanding symbol registration requests from any part. | **MET** (FC8; `Th_last,t` added FC11) |
| 9 | **Two audit-found symbols registered.** $\Delta Th_t^{reg}$ and $N_{peak}^{remaining}$. | **MET** (FC8) |
| 10 | **Auxiliary-binary convention applied consistently.** $c_{cycle,t}$, $r_t$, $p_t$ all covered by §1.4.0; none registered as decision variables. Fast-track path available for future additions. | **MET** (FC9/FC10) |
| 11 | **Consolidated open-items register present.** §1.13 lists every remaining cross-part item with owner, dependency, effort, and closure criterion. | **MET** (FC10; updated FC11) |
| 12 | **`Th_last,t` registered.** Part 2-owned request from Revision 6 §2.9 closed. | **MET (FC11)** |
| 13 | **Transient-quantities convention clarified.** Distinguishes within-horizon quantities from solver diagnostics. | **MET (FC11)** |
| 14 | **Audit execution recorded.** §1.11 criterion 1 documents the run and the result. | **MET (FC11)** |

### Freeze definition

**Frozen (v1.0)** means: changes can only be introduced through a change request with a version increment. No silent edits. FC documents are not frozen; they are under review.

---

## 1.12 Part 1 closure note

With FC11, Part 1 has:

- Absorbed every symbol registration request issued by Parts 2, 3, 4, and 5 (FC8), and the residual `Th_last,t` request (FC11).
- Closed the two gaps found in the cross-part integrity audit ($\Delta Th_t^{reg}$, $N_{peak}^{remaining}$) (FC8).
- Made the auxiliary-binary convention explicit and consistent, removing the FC8 misregistration of $r_t$ (FC9).
- Added a fast-track promotion path for future auxiliary binaries (FC10).
- Registered `Th_last,t` and clarified the transient-quantities convention (FC11).
- Executed the symbol audit and recorded the result (FC11).
- Flagged an open Part 4 ↔ Part 5 interface question ($R_{reg,t}^{committed,up/down}$ vs. $R_{reg,t}^{up/down}$) that FC8 registered without resolving (FC9). Part 5 FC4 §5.2.3 stated an interpretation for Part 4's confirmation; as of FC11, Part 4 has not confirmed.
- Consolidated the remaining cross-part work into a single, sequenced register (§1.13, FC10; updated FC11).

### Closed by FC8/FC9/FC10/FC11 (Part 1's own scope)

- Symbol registration: all Part 2–5 change requests, including `Th_last,t`.
- Auxiliary-binary convention: explicit whitelist, consistent treatment, fast-track promotion path.
- Transient-quantities convention: clarified to distinguish within-horizon quantities from solver diagnostics.
- Traceability matrix: section-level for Parts 2–5.
- State vector, interface table, diagram: consistent.
- Open-items tracking: consolidated in §1.13.
- Symbol audit: executed and passed.

### Not addressed by FC8/FC9/FC10/FC11 (still open in Parts 2–5 or external)

FC8, FC9, FC10, and FC11 are Part 1 revisions. They do **not** fix substantive contradictions in Parts 2–5's own text, and they do not resolve external dependencies. The following items remain open and are the owning part's responsibility. They are **sequenced** below.

| # | Item | Owner | Depends on | Effort | Closure criterion |
|---|---|---|---|---|---|
| 1 | Part 3 §3.9 declares the throughput-ownership consultation "Resolved (Resolution B)" but Part 4 §4.13 still presents it as open/pending. | Part 4 | — | 1 edit (status line + drop open-question framing) | Part 4 §4.13 and §4.14 updated to record Resolution B as accepted |
| 2 | Part 3 §3.11 issues an amendment to Part 5 for the $Th_t^{other}$ definition; Part 5 §5.6.5 still contains the old (incorrect) language, and Part 5 §5.13 omits an exit criterion for this amendment. | Part 5 | — | 2 edits (§5.6.5 text; §5.13 criterion) | Part 5 §5.6.5 corrected; §5.13 lists the amendment as a closed item |
| 3 | Part 4 §4.3.3 states the peak-shaving net-load cap as a hard constraint; Part 5 §5.2.5 treats it as a soft economic decision governed by $c_{peak,t}$. Part 5 §5.12 formally requests the reframing; Part 4 has not applied it. | Part 4 | — | 1 edit (§4.3.3 reframing) | Part 4 §4.3.3 reframed as economic decision; $c_{peak,t}$ referenced |
| 4 | Part 5 §5.2.3 contains an unlinearized indicator $\mathbb{1}[\cdot]$ depending on decision variables in the priority constraint. MILP formulation gap. | Part 5 | Item 3 (uses $c_{peak,t}$) | 1 edit (replace indicator with $c_{peak,t}$ + big-M) | Part 5 §5.2.3 linearized; any new auxiliary binary fast-tracked into §1.4.0 |
| 5 | Part 2 §2.2.5 and §2.3.2 apply derating to both DC and AC limits without stating which is binding. Potential double-application of derating. | Part 2 | — | 1 edit (state binding limit) | Part 2 §2.2.5/§2.3.2 state that the AC limit is binding, or the DC limit is derived |
| 6 | Part 2 §2.3.8's $t_{last}$ update rule (at epoch boundary) is inconsistent with the per-step cycle-completion trigger. | Part 2 | — | 1 edit (clarify timing) | Part 2 §2.3.8 states unambiguously when $t_{last}$ updates |

**Sequencing summary:** Items 1, 2, 3, 5, and 6 have no dependencies and can proceed in parallel. Item 4 depends on item 3 because both use $c_{peak,t}$; Part 5 §5.2.3's linearization should be written after Part 4 §4.3.3's reframing lands, so the binary's semantics are fixed first. Total effort across all six items: roughly 8 targeted edits across three documents (Part 2, Part 4, Part 5). No Part 1 work is needed to unblock any of them.

**Note (FC11):** Items 1–6 above were already closed by Parts 2, 4, and 5 in their respective FC2/FC3/FC4/Revision 4/Revision 6 revisions. They are retained in this table only as historical traceability. The **currently open** items are the two external ones listed in §1.13: B ($R_{reg,t}^{committed}$ semantics) and D (RFP verification).

### Remaining gating items for Part 1 itself

1. ~~**Audit script execution** (criterion 1).~~ **CLOSED by FC11.** The script has been executed; the audit passes.
2. **RFP number verification** (criterion 6). External dependency. Still open.

Once (2) is confirmed, Part 1 is ready to freeze at v1.0. Parts 2–5 can then drop their "pending Part 1 sign-off" language in their next revisions, since the requests they issued are now satisfied.

---

## 1.13 Consolidated open-items register

This register merges the actionable findings from both cross-part integrity audits into one table. It is the single place a reader can see the full remaining work on the five-part model. Each row states the item, its owner, its dependencies, its effort, its closure criterion, and the source audit(s) that found it.

**Sources:** "Audit A" = the first cross-part integrity audit. "Audit B" = the second cross-part integrity audit ("Cross-Part Integrity Audit — Parts 1–5 (Current State)").

### 1.13.1 Closed items (retained for traceability)

| # | Item | Owner | Closed by | Source |
|---|---|---|---|---|
| 1 | Part 3 §3.9 "Resolved" vs. Part 4 §4.13 "Pending" (throughput ownership consultation) | Part 4 | Part 4 FC2/FC3 §4.13 | Audit A B1; Audit B §2c |
| 2 | Part 3 §3.11 amendment vs. Part 5 §5.6.5 stale $Th_t^{other}$ definition; §5.13 missing criterion | Part 5 | Part 5 FC2 §5.6.5 | Audit A B2; Audit B §2b |
| 3 | Part 4 §4.3.3 hard constraint vs. Part 5 §5.2.5 soft economic decision (peak shaving) | Part 4 | Part 4 FC2 §4.3.3 | Audit A §B (implicit); Audit B §2a |
| 4 | Part 5 §5.2.3 unlinearized indicator in priority constraint | Part 5 | Part 5 FC2 §5.2.3 | Audit A D13 |
| 5 | Part 2 §2.2.5 vs. §2.3.2 derating double-application risk | Part 2 | Part 2 Revision 4 §2.2.5/§2.3.2 | Audit A D9 |
| 6 | Part 2 §2.3.8 $t_{last}$ update timing inconsistency | Part 2 | Part 2 Revision 4/6 §2.3.8 | Audit A D10 |
| 7 | Part 2 §2.9 stale "pending Part 1 sign-off" language (all four symbols already handled) | Part 2 | Part 2 Revision 4 §2.9 | Audit A A1; Audit B §1 |
| 8 | `Th_last,t` registration in Part 1 | Part 1 (Part 2-owned request) | Part 1 FC11 §1.4.6 | Part 2 Rev 6 §2.9; Part 5 FC4 §5.11.5 |
| 9 | Symbol audit execution | Part 1 | Part 1 FC11 §1.11 criterion 1 | Part 1 §1.11 gating criterion 1 |
| 10 | Auxiliary-binary fast-track path for future additions | Part 1 | Part 1 FC10 §1.4.0 | FC9 grade observation #1 |
| 11 | §1.12 sequencing and effort estimates | Part 1 | Part 1 FC10 §1.12 | FC9 grade observation #2 |

### 1.13.2 Currently open items

| # | Item | Owner | Depends on | Effort | Closure criterion | Source |
|---|---|---|---|---|---|---|
| B | $R_{reg,t}^{committed,up/down}$ vs. $R_{reg,t}^{up/down}$ semantics (reserved vs. committed) | Parts 4 & 5 | — | Joint decision + 1 edit each | Both parts use the same symbol or state the distinction | Audit A D16; Audit B §1; Part 5 FC4 §5.2.3 |
| D | RFP number and section titles verification | Part 1 (external) | — | 1 verification pass | RFP-264144-1 confirmed against original | Part 1 §1.11 criterion 6 |

**Notes on scope:**

- Item B is a **semantic ambiguity**, not a contradiction. Part 5 FC4 §5.2.3 stated an interpretation (reserved = offered to market; committed = dispatched in the interval) for Part 4's confirmation. As of FC11, Part 4 has not confirmed. The decision is joint; neither part can close it unilaterally.
- Item D is an **external dependency**. It is not a model-integrity issue; it is a traceability-accuracy issue. It does not block the technical integration of Parts 2–5, but it does block Part 1's freeze at v1.0.
- **No item in this register is owned by Part 2 or Part 3.** Parts 2 and 3 have closed all their own-scope items.
- **Part 5 has closed all its own-scope items.** Its only open item (B) is joint with Part 4.
- **Part 4 has closed all its own-scope items.** Its only open item (B) is joint with Part 5.

**Items explicitly excluded from this register** (found by the audits but judged non-actionable or lower priority):

- Audit A D11 (unit-convention ambiguity in $M_{reg,t}^{abs}$) — resolves consistently when the "per MW" scaling is read as documented; no edit needed.
- Audit A D15 ($Th_t^{reg}$ not in the service sum) — a clarification request, not a contradiction; folded into item 2's Part 5 revision.
- Audit A D7 ($E_{nom}$ vs. $E_{nom}^{cell}$ relationship) — Part 2 §2.2.4 already states the conversion; the relationship is derivable from the existing text.
- Audit A C3 (Part 5 consumes Part 2 symbols) — expected consumption, not a contradiction.

**Register maintenance:** This register is updated only when an item is closed (removed or marked closed) or when a new audit adds an item. It is not a substitute for the owning parts' own changelogs; it is an index to them.

---

## 1.14 FC11 promotion summary

**What FC11 changed:** Registered `Th_last,t`; clarified the transient-quantities convention; executed the symbol audit; updated §1.11, §1.12, and §1.13.

**What FC11 did not change:** No physical or component modeling. No new registered symbols other than `Th_last,t`. No changes to Parts 2–5's technical content. No re-opening of closed items.

**Model integration status after FC11:**

| Dimension | Status |
|---|---|
| Symbol registration | **COMPLETE** — all symbols in Parts 2–5 are registered in §1.4 (including `Th_last,t`). |
| Auxiliary-binary convention | **COMPLETE** — whitelist explicit, fast-track path available. |
| Transient-quantities convention | **COMPLETE** — clarified. |
| Symbol audit | **COMPLETE** — executed; PASS. |
| Cross-part contradictions | **NONE OPEN** — items 1–7 of §1.13.1 closed by Parts 2/4/5. |
| Remaining external items | **TWO** — B ($R_{reg,t}^{committed}$ semantics, joint Part 4 ↔ Part 5) and D (RFP verification, external). |

**Freeze recommendation:** Part 1 is ready to freeze at v1.0 **once item D (RFP verification) is confirmed**. Item B is a Part 4 ↔ Part 5 joint decision and does not block Part 1's freeze; it blocks Parts 4 and 5's freeze. Part 1's own scope is complete.

**Downstream impact:** With FC11, Parts 2, 3, 4, and 5 can drop their "pending Part 1 sign-off" language in their next revisions. Part 2's `Th_last,t` registration request (§2.9) is satisfied. Part 5's problem-size count (§5.3.6) is confirmed — `Th_last,t` is registered and counted. Part 4's and Part 5's only remaining joint item is B, which is outside Part 1's scope.





