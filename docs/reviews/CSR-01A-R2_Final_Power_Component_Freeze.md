# CSR-01A-R2 — Final Power Component Selection and Freeze

| Field | Result |
|---|---|
| Platform | IPC-100 Rev A |
| Package | Package 11A-R2 |
| Review date | 2026-07-31 |
| Power-scope EBOM rows | 130 |
| Frozen | 9 |
| Blocked | 121 |
| Power rows without disposition | 0 |
| Footprints assigned | 0 |
| PCB work | None |
| Decision | Not accepted |

> **Post-review disposition (ECO-007, 2026-07-31):** The three implementation defects below are corrected in the released schematic. This historical decision remains **CSR-01A-R2 NOT ACCEPTED**. ECO-007 authorizes a new CSR-01A-R3 review; it does not accept R2 or authorize CSR-01B.

> **Subsequent review:** CSR-01A-R3 confirmed the ECO-007 corrections but was not accepted because 124 exact-part evidence blockers remain. CSR-01B remains unauthorized.

## Executive Summary

CSR-01A-R2 cannot complete the IPC-100 Rev A power freeze. The review reconciled every one of the 130 power-scope EBOM rows and retained the nine previously frozen 100 kΩ bias resistors. The other 121 rows remain explicitly `BLOCKED`; no power row is `NOT YET FROZEN`.

Exact manufacturer review found three released-network incompatibilities that cannot be corrected inside this component-selection package:

1. U201's reviewed LMR38020-Q1 regulator requires 64.9 kΩ nominal on RT for 400 kHz, while released R201 is 40.2 kΩ. TI's own table therefore conflicts with the schematic's simultaneous U201/R201/400 kHz claim.
2. U209/U212/U213's reviewed TPS2553-Q1 switch permits 15–232 kΩ on RILIM. Released R222/R223/R224 are 287 kΩ and cannot defensibly establish the captured 100 mA target.
3. U801 requires a four-pin device with separate core supply and expansion-rail sense, valid assertion only at or above 2.9 V, invalid deassertion at or below 2.7 V, 5–10 ms validation, push-pull output, and power-off fail-low behavior. The closest reviewed single-device class (TLV841S) has fixed-delay/separate-sense options, but its standard 5% hysteresis cannot span the released 200 mV window at these thresholds without additional threshold circuitry or a requirement change.

These are electrical implementation conflicts, not procurement shortages or footprint preferences. Freezing dependent regulators, passives, switches, supervisor, and protection tree while the released values are contradictory would create false traceability. The required next action is a narrow corrective ECO followed by another final power freeze review.

## 1. Review Basis

- QER-01 Quantitative Electrical Requirements
- ECO-006 Power-Subsystem Electrical Compatibility Remediation
- MIR-01 J1 Mechanical Interface Release
- CSR-01A-R Power Component Selection Reattempt
- released Rev A schematic and 307-row EBOM/AVL
- Texas Instruments LMR38020-Q1 datasheet SNVSBS6B
- Texas Instruments TPS2553-Q1 datasheet SLVSBD0B
- Texas Instruments TLV841 datasheet SLVSFO5E
- Texas Instruments TCA9517A datasheet SCPS245E
- distributor availability and pricing checked 2026-07-31

## 2. Power Tree

`J1/H01 9–21 VDC` → `F101/D101/Q101/U101/U102` → `VIN_PROTECTED` → `U201 5 V buck` → `+5V_MAIN`

From `+5V_MAIN`:

- `U202` selects main/USB core source → `U203` → `+3V3_CORE`.
- U206/U207/U208/U210/U211 create OLED, sensor, UI, relay, and field-sense branches.
- U209/U212/U213 create expansion and motor-logic current-limited branches.
- U204/U205 and associated bias networks qualify main power and branch requests.
- U302 supervises the core rail.
- U706/U707 isolate optional I²C peripheral branches.
- U801 qualifies expansion power for the separate U802 bus buffer.

The R201/U201 conflict affects the primary 5 V source and therefore every downstream main-powered function. The TPS2553 network conflict directly affects three protected external branches. U801 prevents exact expansion qualification selection.

## 3. Component Disposition Matrix

The generated EBOM is the controlled row-by-row disposition record. Every power-scope row has one of the following statuses:

| Status | Count | Meaning |
|---|---:|---|
| `FROZEN` | 9 | Exact MPN, datasheet, calculations, sourcing, alternate, cost, lifecycle, and QER trace retained |
| `BLOCKED` | 121 | Exact freeze is not permitted; the EBOM `Risk` field records the component-specific reason |
| `NOT APPLICABLE` | 0 | No power-scope row was removed from the released design |
| `NOT YET FROZEN` | 0 | Prohibited for power scope in this final pass |

### 3.1 Critical blocker mapping

| Finding | Direct references | Dependent scope | Required correction |
|---|---|---|---|
| CSR-01A-R2-F01 — switching-frequency resistor conflict | U201, R201 | L201, C201–C205, R202/R203 and downstream power-tree selections | Narrow ECO selects the intended frequency and compatible RT value; rerun loss, ripple, stability, soft-start, EMI, and thermal work |
| CSR-01A-R2-F02 — current-limit resistor outside datasheet range | U209/U212/U213, R222/R223/R224 | Expansion and both motor-logic protected branches | Narrow ECO selects a supported limit implementation/value and verifies min/nom/max current |
| CSR-01A-R2-F03 — U801 threshold/hysteresis implementation unresolved | U801 | R801, C802, D803, FB801 and expansion qualification | Narrow ECO introduces a selectable threshold/hysteresis implementation or revises the physical circuit while preserving ICD-001 behavior |
| CSR-01A-R2-F04 — final freeze cannot proceed piecemeal | Remaining 112 blocked rows | Complete protection/conversion/branch tree | Reissue final review after F01–F03; finish exact curves, tolerance, thermal, lifecycle, AVL, cost, and alternate evidence |

ECO-006 and MIR-01 remain valid. This review does not reopen their architecture, voltage, interface, or mechanical decisions.

## 4. Frozen Component Traceability Matrix

All nine accepted rows use the same qualified part but retain individual reference-level traceability.

| Reference | Electrical function | QER/calculated requirement | Manufacturer / MPN | Compliance and margins | Lifecycle / vendors / cost / risk |
|---|---|---|---|---|---|
| R204 | Core-source control bias | 100 kΩ ±1%; ≤100 ppm/°C; 5.25 V max; power ≤50% | Panasonic Industry / `ERJ-3EKF1003V` | 75 V rating: 7.0% utilization, 93% voltage margin; 0.276 mW/100 mW: 0.28% utilization, 99.72% power margin; −55…155 °C gives 80 °C upper margin | Active; DigiKey primary, Mouser alternate; $0.100/$0.039/$0.0195/$0.01131 at 1/10/100/1000; low risk; Vishay `RCG0603100KFKEA` approved electrical alternate |
| R212 | U203 enable bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same voltage, power, temperature, tolerance, and derating margins | Same |
| R214 | Main-power fail-low bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |
| R216 | Main-power bias feed | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |
| R218 | OLED request fail-low bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |
| R219 | Sensor request fail-low bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |
| R220 | UI request fail-low bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |
| R221 | Expansion request fail-low bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |
| R801 | Expansion segment-enable fail-low bias | Same | Panasonic Industry / `ERJ-3EKF1003V` | Same | Same |

Datasheet: `https://industrial.panasonic.com/ww/products/pt/general-purpose-chip-resistors/models/ERJ3EKF1003V` (AOA0000C304, 29-May-2025). DigiKey listed the part active with 943,271 units in stock on 2026-07-31. The approved Vishay electrical alternate was also stocked. Stock and prices are planning snapshots, not guarantees.

## 5. Engineering Justification

### 5.1 U201/R201 frequency conflict

The LMR38020-Q1 is electrically attractive: 4.2–80 V operating input, 85 V absolute maximum, 2 A output, −40 to 150 °C junction range, PGOOD, and adjustable 200 kHz–2.2 MHz switching. It satisfies the high-level U201 class.

However, TI's RT table gives 64.9 kΩ for 400 kHz and 52.3 kΩ for 500 kHz. Released R201 is 40.2 kΩ, which is not the documented 400 kHz setting. Because frequency changes inductor ripple, switching loss, compensation/stability envelope, EMI, and thermal results, neither U201 nor its dependent network can be frozen by assuming one of the conflicting values.

### 5.2 TPS2553 branch-limit conflict

TPS2553-Q1 operates from 2.5–6.5 V, provides reverse-voltage blocking, fault reporting, and an adjustable current limit. TI specifies `15 kΩ ≤ RILIM ≤ 232 kΩ` for stable programming. The captured 287 kΩ values on R222/R223/R224 exceed that limit. TI identifies tying ILIM directly to IN as the separate approximately 75 mA configuration; the released topology instead shows a resistor and labels a 100 mA target. Exact switches and limit resistors therefore remain blocked.

### 5.3 U801 selection conflict

TLV841S confirms that a four-pin, separate-VDD/sense, push-pull, fixed-delay supervisor is physically plausible. Available delay classes include 2 ms and 10 ms, and fixed thresholds can be factory set in 100 mV steps. Its typical 5% hysteresis nevertheless cannot simultaneously implement a valid release no earlier than 2.9 V and invalid assertion no later than 2.7 V: a 2.9 V falling threshold releases near 3.045 V, while a 2.7 V falling threshold releases near 2.835 V. The former misses the required 2.7 V deassertion and the latter asserts valid below 2.9 V. An adjustable-divider or external-hysteresis solution requires components absent from the released circuit.

### 5.4 Candidate observations that do not constitute freezes

- TCA9517A supports 0.9–5.5 V A-side, 2.7–5.5 V B-side, active-high enable, 400 kHz, and powered-off high-impedance I²C pins, making it a credible U706/U707 candidate. Offset-low compatibility and exact logical-to-physical pin mapping still require closure.
- TPS22918-Q1 is active, 1–5.5 V, 2 A, and approximately 52 mΩ with configurable rise and quick-output discharge. Exact suffix, CT/QOD network, branch fault model, and thermal evidence remain incomplete.
- The accepted ECO-006 capacitor/MOSFET classes remain selectable, but no exact MPN is frozen until the primary regulator/protection network is internally consistent.

No “appears suitable” acceptance is made. Candidate observations are explicitly non-frozen.

## 6. QER Compliance Matrix

| Requirement area | Result | Evidence / gap |
|---|---|---|
| 9–21 V normal input | Partial | U201 candidate supports range; complete tree not frozen |
| 55 V transient coordination | Partial | ECO-006 classes corrected; exact TVS/FET/eFuse overlay remains blocked |
| 5 V setpoint/load/ripple | Fail for freeze | U201 frequency-setting inconsistency invalidates exact ripple/loss/stability closure |
| 3.3 V core | Blocked | Dependent on accepted 5 V implementation and exact U203 network |
| Protected 100 mA branches | Fail for freeze | RILIM values outside TPS2553-Q1 supported range |
| Expansion rail qualification | Fail for freeze | No exact U801 implementation meets the complete frozen window |
| Connector J1/H01 mechanics | Requirements complete | MIR-01 accepted; exact family still awaits final freeze |
| Passive derating | Complete only for nine frozen resistors | Other exact dielectric/voltage/ripple/pulse data pending |
| Thermal/efficiency | Blocked | Exact devices and frequency required before vendor/board model is meaningful |
| Lifecycle/sourcing/cost | Complete only for nine frozen resistors | No unsupported data invented for blocked rows |

## 7. AVL Summary

The AVL contains 307 total rows and one row for every EBOM item. In power scope:

- 9 rows contain exact manufacturer, MPN, lifecycle, primary/alternate distributor, approved alternate, sourcing risk, and QER trace.
- 121 rows remain `BLOCKED`; placeholder procurement fields are intentionally not presented as approved parts.
- DigiKey is the refreshed primary source for `ERJ-3EKF1003V`; Mouser is the alternate distributor.
- No blocked candidate may be purchased as a production-approved IPC-100 Rev A part.

## 8. EBOM Summary

| Metric | Count |
|---|---:|
| Complete schematic EBOM | 307 |
| Power scope | 130 |
| Power `FROZEN` | 9 |
| Power `BLOCKED` | 121 |
| Power `NOT YET FROZEN` | 0 |
| Outside power scope | 177 |
| Duplicate references | 0 |

The EBOM `Risk`, `Selection Rationale`, `Requirement Trace Reference`, and `Notes` fields contain the controlled per-reference disposition.

## 9. Cost Summary

Only frozen parts may contribute to an approved cost subtotal.

| Quantity basis | Unit price per resistor | Nine-reference subtotal |
|---:|---:|---:|
| 1 | $0.10000 | $0.90000 |
| 10 | $0.03900 | $0.35100 |
| 100 | $0.01950 | $0.17550 |
| 1,000 | $0.01131 | $0.10179 |

These are DigiKey cut-tape prices checked 2026-07-31. The blocked power subsystem has no approved total cost; summing provisional or placeholder parts would be misleading.

## 10. Risk Register

| Risk | Severity | Consequence | Control |
|---|---|---|---|
| Incorrect U201 frequency | Critical | Wrong ripple, EMI, stability, thermal, and transient assumptions | Correct through narrow ECO; rerun regulator analysis |
| Unsupported TPS2553 RILIM | Critical | Current limit may be inaccurate/unstable and violate branch allocation | Correct through narrow ECO using supported implementation |
| U801 window not physically selectable | Critical | Expansion segment may enable/deassert outside the frozen safe window | Define exact supervisor/hysteresis circuit in narrow ECO |
| Remaining exact-part evidence absent | Major | No auditable production BOM, alternates, or cost | Reissue final power freeze after corrective ECO |
| Frozen resistor supply snapshot ages | Low | Stock/price changes | Refresh at purchase; retain two distributor paths and approved alternate |
| Footprints intentionally absent | Controlled | Cannot procure for placement yet | Later CSR-01B/footprint package only after power freeze acceptance |

## 11. Remaining Blockers

1. Correct U201/R201 switching-frequency inconsistency without changing the released 5 V architecture.
2. Correct U209/U212/U213 and R222/R223/R224 current-limit implementation using the manufacturer's supported range.
3. Resolve U801 threshold/hysteresis/delay implementation without changing ICD-001 behavior.
4. Re-run exact power component selection, tolerance, SOA, thermal, lifecycle, AVL, alternates, and cost after those corrections.
5. Run native KiCad ERC after exact physical symbols are introduced; `kicad-cli` remains unavailable in this environment.

Prototype deferral cannot cure F01–F03 because each could require a schematic value or circuit change. They therefore do not qualify as approved prototype strategies under the acceptance rule.

## 12. Final Validation

- [x] All 130 power rows have a disposition.
- [x] Every frozen row has MPN, datasheet, QER mapping, engineering rationale, margins, lifecycle, AVL entry, alternate strategy, cost, and risk.
- [x] No power row remains `NOT YET FROZEN`.
- [x] Blocked rows retain explicit reasons; no candidate is misrepresented as accepted.
- [x] Repository structural, hierarchy, GPIO, ICD, ECO-006, MIR-01, EBOM/AVL, and targeted CSR-01A-R2 checks pass.
- [x] Zero footprints remain assigned.
- [x] No schematic logic, PCB, GPIO, ADR, or ICD change was made.
- [x] `git diff --check` passes.
- [ ] Native KiCad ERC remains pending because KiCad CLI is unavailable.
- [ ] Corrective ECO and final exact power freeze remain required.

## Final Decision

# CSR-01A-R2 NOT ACCEPTED

CSR-01B MCU & Support Component Selection is not authorized.
