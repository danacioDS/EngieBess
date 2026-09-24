# Mapping (English) — `SYS-STR-FRM-001` vs `PH1-REG-001` v1.1

Authoritative mapping, verified item by item against the Register. This is the mapping that must be used in `§12.1`, `§12.2`, `§14`, and `Addendum A`.

---

## Authoritative mapping — `SYS-STR-FRM-001` ↔ `PH1-REG-001` v1.1

### §12.1 Blocking Items (6 items)

| Register ID | Former ID | Item | Why Blocking |
|---|---|---|---|
| **PH-001** | B1 | Target market(s) | Market rules drive eligibility, dispatch logic, settlement, revenue |
| **PH-002** | B2 | Behind-the-meter vs. front-of-the-meter scope | Determines which value streams and constraints apply |
| **PH-003** | B3 | Data availability | Determines what can be modeled; drives ingestion design |
| **PH-004** | B6 | Project configuration | Standalone vs. co-located, generation type, grid constraints. Determines which System Context dimensions are relevant |
| **PH-005** | B4 | Benchmark data | Required to define acceptance |
| **PH-006** | B5 | Acceptance thresholds (accuracy + runtime + usability) | Must be concrete before the thin slice is built |

---

### §12.2 Defaultable Items (former D IDs → Register IDs)

Mapping D1–D20 → PH IDs according to `PH1-REG-001` v1.1:

| Register ID | Former ID | Item | Default assumption |
|---|---|---|---|
| **PH-034** | D1 | Dispatch methodology | **LP** — Linear Programming |
| **PH-033** | D2 | Perfect foresight vs. forecast-based | **Perfect foresight**; realization factor applied in Financial Engineering |
| **PH-036** | D3 | Degradation feedback time scale | **Annual SOH update** with representative-period simulation |
| **PH-041** | D4 | Voltage regulation coupling | **Fixed envelope** — no P² + Q² ≤ S² linearization initially |
| **PH-050** | D5 | Load forecasting method | **ENGIE-provided** if available; otherwise statistical baseline |
| **PH-051** | D6 | Load forecasting home | **Domain 2 owns it conceptually**; implementation via Domain 7 |
| **PH-052** | D7 | Scenario granularity | **3–5 core scenarios** initially, expandable |
| **PH-042** | D8 | Financing structure | **Project IRR primary; equity IRR computed with default debt parameters, configurable by the user** |
| **PH-043** | D9 | Tax and incentives treatment | **Pre-tax** initially; ITC / depreciation flagged as extension |
| **PH-047** | D10 | Reporting format | **Both PDF and Excel** |
| **PH-053** | D11 | Market adapter scope | **One adapter at delivery**, architecture supports more |
| **PH-048** | D12 | Audit / lineage / traceability scope | **Basic execution logs + data lineage** |
| **PH-054** | D13 | Time resolution and simulation horizon | **15-minute when input data permits; hourly otherwise**. 15-year contract term |
| **PH-055** | D14 | Presentation of value (BTM mapping convention) | **Accepted** (see also PH-009) |
| **PH-046** | D15 | Databricks workspace access and environment ownership | **ENGIE-owned workspace**; consultant granted developer access |
| **PH-026** | D16 | BESS sizing vs. evaluation | **Evaluation** of a predefined configuration |
| **PH-027** | D17 | Primary model purpose / use case | **Evaluation** (project development support) |
| **PH-028** | D18 | Model output granularity | **All levels** (interval schedules, daily / monthly metrics, annual KPIs) |
| **PH-040** | D19 | Representative-period scheme | **Monthly representative periods, respecting the billing period.** If demand ratchets apply, all 12 months of the year are simulated |
| **PH-004** | D20 | Initial implementation configuration assumption | **Standalone BESS** unless **PH-004** confirms a co-located or integrated configuration as the primary reference case |

---

### §14 ENGIE Clarification Requests (filtered view)

Items relevant to the Strategy, by Register ID:

| Register ID | Topic |
|---|---|
| **PH-001** | Target market(s) |
| **PH-002** | BTM vs. FTM scope |
| **PH-003** | Data availability |
| **PH-004** | Project configuration |
| **PH-005** | Benchmark data |
| **PH-006** | Acceptance thresholds |
| **PH-007** | Commercial perspective |
| **PH-012** | Users and handover |
| **PH-033** | Interim demo |
| **PH-042** | Financing structure |
| **PH-043** | Tax, incentives, and conventions |
| **PH-046** | Databricks environment |
| **PH-047** | Reporting requirements |

**Note:** PH-013 is not used — it is reserved in the Register (Appendix C).

---

### Addendum A — Consolidated Register Cross-Reference (55 items)

Complete mapping `Historical Strategy mapping → Register ID`:

| Register ID | Topic | Primary domain | Historical mapping |
|---|---|---|---|
| PH-001 | Target market(s) | Strategy, D2 | B1 |
| PH-002 | BTM vs. FTM scope | Strategy, D2 | B2 |
| PH-003 | Data availability | D1, D2 | B3 |
| PH-004 | Project configuration | Strategy, D5 | B6 / D20 |
| PH-005 | Benchmark data | D6, D7 | B4 |
| PH-006 | Acceptance thresholds | Strategy, all | B5 |
| PH-007 | Commercial perspective | D6 | — |
| PH-008 | Co-located configurations | Strategy | — |
| PH-009 | Presentation of value (strategy) | Strategy, D6 | — |
| PH-010 | Reporting conventions (strategy) | Strategy, D7 | — |
| PH-011 | (reserved) | — | — |
| PH-012 | Users and handover | D7 | — |
| PH-013 | (reserved) | — | — |
| PH-014 | (reserved) | — | — |
| PH-015 | Battery data | D1, D5 | — |
| PH-016 | SOC bounds and warranty | D1, D5 | — |
| PH-017 | SOC window behavior under degradation | D1, D5 | — |
| PH-018 | Multi-cohort aggregation | D5 | — |
| PH-019 | Export and net metering | D2 | — |
| PH-020 | Minimum bill and fixed charges | D2 | — |
| PH-021 | Power factor penalties / kVAR charges | D2, D3, D4 | — |
| PH-022 | Coincident-peak charges | D2 | — |
| PH-023 | Tariff structure detail | D2 | — |
| PH-024 | Tariff escalation | D2, D6 | — |
| PH-025 | Load projection growth | D2 | — |
| PH-026 | BESS sizing vs. evaluation | D4 | D16 |
| PH-027 | Primary model purpose | D4 | D17 |
| PH-028 | Model output granularity | D4 | D18 |
| PH-029 | Active vs. reactive priority | D4 | — |
| PH-030 | Dispatch validation benchmark | D4 | — |
| PH-031 | Revenue attribution under simultaneous services | D4 | — |
| PH-032 | Financial objective inside dispatch | D5 | — |
| PH-033 | Perfect foresight vs. forecast-based dispatch | Strategy, D2, D3, D4 | D2 |
| PH-034 | Dispatch methodology | Strategy, D3, D4 | D1 |
| PH-035 | Realization factor | Strategy, D6 | — |
| PH-036 | Degradation feedback time scale | Strategy, D1, D4, D5 | D3 |
| PH-037 | Degradation model calibration | D5 | — |
| PH-038 | Degradation feedback time scale (confirmatory) | D5 | — |
| PH-039 | Financial objective inside dispatch (confirmatory) | D5 | — |
| PH-040 | Representative-period scheme and ratchets | Strategy, D4 | D19 |
| PH-041 | Voltage regulation coupling | Strategy, D3, D4 | D4 |
| PH-042 | Financing structure | Strategy, D6 | D8 |
| PH-043 | Degradation model fidelity / tax treatment | Strategy, D5, D6 | D9 |
| PH-044 | Augmentation policy | Strategy, D5 | — |
| PH-045 | Replacement policy | Strategy, D5 | — |
| PH-046 | Databricks environment | Strategy, D7 | D15 |
| PH-047 | Reporting requirements | Strategy, D6, D7 | D10 |
| PH-048 | Audit / lineage / traceability scope | Strategy, D7 | D12 |
| PH-049 | Grid constraints | Strategy, D2 | — |
| PH-050 | Load forecasting method | Strategy, D2 | D5 |
| PH-051 | Load forecasting home | Strategy, D2 | D6 |
| PH-052 | Scenario granularity | Strategy, D2 | D7 |
| PH-053 | Market adapter scope | Strategy, D2 | D11 |
| PH-054 | Time resolution | Strategy, D2, D4 | D13 |
| PH-055 | Presentation of value (BTM mapping convention) | Strategy, D3, D6 | D14 |

**Note:** PH-011, PH-013, PH-014 are reserved (not assigned). The Register has 55 items (PH-001 to PH-055), with 3 reserved IDs and 52 active items according to Appendix C of the Register.

---

## Corrections to apply to the document

### Correction 1 — §12.2 (defaultable)

**Before (v1.0, incorrect):**

| Register ID | Former ID | Item |
|---|---|---|
| PH-050 | D5 | Load forecasting method |
| PH-051 | D6 | Short-horizon forecast vs. multi-year projection ❌ |
| PH-052 | D7 | Load forecasting home ❌ |
| PH-053 | D11 | Scenario granularity ❌ |
| PH-054 | D13 | Market adapter scope ❌ |
| PH-055 | D14 | Time resolution ❌ |

**After (v1.0.2, correct):**

| Register ID | Former ID | Item |
|---|---|---|
| PH-050 | D5 | Load forecasting method |
| PH-051 | D6 | Load forecasting home ✅ |
| PH-052 | D7 | Scenario granularity ✅ |
| PH-053 | D11 | Market adapter scope ✅ |
| PH-054 | D13 | Time resolution ✅ |
| PH-055 | D14 | Presentation of value (BTM mapping convention) ✅ |

### Correction 2 — §14

Remove the `PH-013 Point of contact and decision timing` row. The Register has PH-013 as reserved.

### Correction 3 — Addendum A

Already correct in the version I generated. Only confirm that the "Historical mapping" column reflects D14 → PH-055 (Presentation of value), not "Time resolution".

---

## Summary of the final mapping

| Dimension | Result |
|---|---|
| Items in the Register | 55 (PH-001 to PH-055) |
| Reserved IDs | 3 (PH-011, PH-013, PH-014) |
| Active items | 52 |
| Items referenced from the Strategy | 52 |
| Mapping discrepancies corrected | 6 |
| Reserved IDs used in error | 1 (PH-013) |
| Mapping completeness | ✅ 100% aligned with `PH1-REG-001` v1.1 |

---




