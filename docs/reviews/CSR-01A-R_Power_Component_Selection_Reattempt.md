# CSR-01A-R — Power Component Selection Reattempt

| Field | Value |
|---|---|
| Package | 11A-R |
| Platform | IPC-100 Rev A |
| Review date | 2026-07-31 |
| Quantitative baseline | QER-01, commit `244afb7` |
| Schematic baseline | Released Rev A after ECO-005 |

## 1. Executive Summary

CSR-01A-R reconciled all 124 power-scope rows against QER-01 and the normalized schematic. Nine independent low-voltage bias/enable resistors are frozen as one exact orderable component group. The other 115 rows are blocked with specific dispositions; the remaining 177 EBOM rows stay `NOT YET FROZEN`.

The package cannot be accepted. Five captured values directly conflict with QER-01 voltage derating, three entries are composite functions with no selectable physical implementation, and the regulator/protection/passive networks still require device-specific calculations that may change schematic values. J1 also lacks a released physical enclosure and harness interface.

No schematic, value, connector contract, reference, footprint, or PCB file is changed by this review.

## 2. Review Scope

| Sheet | Rows | Result |
|---|---:|---|
| 01 — Power Entry | 35 | 35 blocked |
| 02 — Power Conversion | 77 | 8 frozen, 69 blocked |
| 03 — ESP32 Core | 3 | 3 blocked |
| 07 — UI & Peripherals | 2 | 2 blocked |
| 08 — Expansion | 5 | 1 frozen, 4 blocked |
| 09 — Connectors & Test | 2 | 2 blocked |
| **Power scope** | **124** | **9 frozen, 115 blocked** |
| Outside package | 177 | `NOT YET FROZEN` |

Power-domain test points were checked; none of the current 124-row power scope is a physical power test-point part. Existing test symbols remain outside this selection package.

## 3. Prior Failure Closure

QER-01 closes the former absence of system limits. It now supplies the 9–21 V normal range, 40 V/100 ms surge, 55 V clamp ceiling, rail/load allocations, startup and fault envelopes, −20 to +75 °C operating environment, and component derating policy.

That closure allows objective pass/fail analysis. It does not automatically validate preliminary values or supply missing physical topologies. CSR-01A findings F01–F06 are closed as requirements-definition questions, but their implementation evidence must be produced per component.

## 4. Power Inventory

The canonical row-level inventory is `docs/bom/IPC100_RevA_EBOM.csv`. Every row records reference, sheet, captured value, class, electrical role, criticality, prior blocked state, current status, trace reference, and blocker or selection evidence.

| Current disposition | Count | Meaning |
|---|---:|---|
| `FROZEN` | 9 | Exact electrical component selection accepted |
| `CONDITIONAL` | 0 | No mandatory criterion was left conditional |
| `BLOCKED` | 115 | One or more mandatory criteria failed or lack evidence |
| `NOT YET FROZEN` | 177 | Unrelated rows outside CSR-01A-R |

All 301 references remain unique. The Reference Designator Register is unchanged.

## 5. QER Traceability Matrix

Identifiers below are local stable trace keys into the unchanged QER-01 text.

| Trace ID | QER-01 section | Requirement |
|---|---:|---|
| QER-ENV-01 | 2 | −20 to +75 °C powered environment; −40 to +85 °C storage |
| QER-IN-01 | 2, 3 | 9–21 V normal input; 1.25 A continuous and 2 A/100 ms peak |
| QER-TR-01 | 5 | +40 V/100 ms/2 Ω surge; downstream clamp ≤55 V |
| QER-TR-02 | 5 | −24 V/60 s reverse polarity |
| QER-RAIL-05 | 3 | 5 V rails 4.75–5.25 V |
| QER-RAIL-33 | 3 | 3.3 V rails within the released range |
| QER-DER-V | 10 | Semiconductor voltage ≤80% steady and ≤90% specified transient |
| QER-DER-P | 10 | Continuous passive dissipation ≤50% rated |
| QER-R-01 | 7, 10 | Resistor tolerance/TCR appropriate to function |
| QER-R-02 | 7, 10 | Resistor continuous power ≤50% rated at hot condition |
| QER-R-03 | 7, 10 | Resistor applied voltage ≤70% working rating |
| QER-R-04 | 7 | Resistor working/pulse voltage ≥1.5× applied stress where required |
| QER-C-01 | 7, 10 | Ceramic voltage/effective-capacitance, dielectric, ripple and aging limits |
| QER-L-01 | 7, 10 | Inductor hot RMS, saturation, DCR and rise margins |
| QER-CONN-01 | 8 | J1 ≥30 V, ≥3 A/contact, ≤20 mΩ, ≤20 °C rise and released retention/environment |

| Reference/group | Trace | Required | Candidate characteristic | Margin | Evidence | Result |
|---|---|---|---|---|---|---|
| R204, R212, R214, R216, R218–R221, R801 | QER-R-01–04, QER-ENV-01 | ±1%; power ≤50%; voltage ≤70%; +75 °C | 100 kΩ ±1%, 100 ppm/°C, 0.1 W, 75 V, −55 to +155 °C | 7.0% voltage; 0.28% power; 80 °C upper margin | Panasonic product page/datasheet; QER rail limits | PASS / FROZEN |
| C102/C103/C104/C109 | QER-TR-01, QER-C-01 | Rating above 55 V clamp | Captured 50 V | −5 V; rating exceeded by requirement | Schematic value and QER-01 | FAIL |
| Q101 | QER-TR-01, QER-DER-V | ≥61.1 V for 55 V at ≤90% | Captured 60 V | 91.7% utilization | Schematic value and QER-01 | FAIL |
| U706/U707/U801 | all applicable | One physical orderable implementation | Composite behavioral symbol | No physical rating/pin evidence | Schematic inventory | INSUFFICIENT EVIDENCE |
| J1 | QER-CONN-01 | Electrical plus physical mating system | Functional connector only | Enclosure/mating/terminal definition absent | ICD-002/Open Design Items | INSUFFICIENT EVIDENCE |
| Remaining regulator/protection/passive rows | class traces above | Complete worst-case device analysis | Preliminary values/families | Calculations incomplete | EBOM row blockers | INSUFFICIENT EVIDENCE |

## 6. Power Tree

| Path/branch | Source | Range | Continuous / peak | Ripple | Sequence and brownout | Protection owner | Loads |
|---|---|---:|---:|---:|---|---|---|
| `VIN_RAW` | J1 | 9–21 V normal | 1.25 A / 2 A, 100 ms | N/A | Reject below threshold; safe off | Sheet 01 | Input protection |
| `VIN_PROTECTED` | Sheet 01 | Input less loss | 2 A path / 4 A, 10 ms | N/A | Collapses on rejected input | Sheet 01 | Main buck |
| `+5V_MAIN` | Main buck | 4.75–5.25 V | 1.5 A / 2 A, 100 ms | ≤50 mVpp | Main-valid only; off on brownout | Sheet 02 | Direct branches and core source |
| `USB_5V_PROTECTED` | J13 VBUS | 4.40–5.25 V | 0.5 A maximum | USB contract | Hot-plug capable; no main-only rails | Sheets 09/01 | Core source only |
| `CORE_SOURCE` | Priority mux | 4.40–5.25 V | Main sized for core; USB 0.5 A | Must preserve core input | Main preferred; no cross-current | Sheet 02 | Core buck |
| `+3V3_CORE` | Core buck | 3.20–3.40 V | 1 A / 1.5 A, 100 ms | ≤40 mVpp | Reset before invalid operation | Sheets 02/03 | MCU/core and 3.3 V branches |
| Main 5 V branches | `+5V_MAIN` | 4.75–5.25 V | Per QER allocations | Parent rail limit | Main-qualified; safe outputs | Sheet 02 | Relay, motor logic, field, UI |
| Switched 3.3 V branches | `+3V3_CORE` | Per QER/ICD | OLED 150 mA, sensor 50 mA, expansion 100 mA | Parent rail limit | Request plus main qualification | Sheet 02 | Optional peripherals |

## 7. Operating-Corner Analysis

| Corner | Required outcome | CSR-01A-R impact |
|---|---|---|
| 9 V, maximum continuous load | Main regulation and thermal compliance | U201/L201/capacitors require vendor-tool and board thermal analysis |
| 18 V nominal | Efficiency/cost planning point | No additional selection relief |
| 21 V continuous | Normal voltage derating | Input divider, FET, eFuse and capacitors require hot/tolerance checks |
| 40 V/100 ms surge | Clamp ≤55 V and safe state | D101 coordination incomplete; four 50 V capacitors fail captured rating |
| +75 °C enclosure | Junction and hot-passive derating | Semiconductor/copper and magnetics models incomplete |
| Startup/inrush | ≤4 A/10 ms input; branch limits | Fuse/eFuse/soft-start/capacitor stack incomplete |
| Brownout/interruption | No unsafe pulse; qualifiers deassert in time | Exact supervisor/mux/PG timing incomplete |
| −24 V reverse | No rail energization/damage | Q101 and U101 gate/SOA/body-diode evidence incomplete |
| Output short | Limit without core collapse | Exact U209/U212/U213 limits and thermal retry incomplete |
| USB hot plug | ≤500 mA, no backfeed | U102/D104/D902 and capacitance/clamp coordination incomplete |

## 8. Selected Components

| References | Preferred manufacturer / MPN | Description | Package | Qualification | Lifecycle | Review status |
|---|---|---|---|---|---|---|
| R204, R212, R214, R216, R218, R219, R220, R221, R801 | Panasonic Industry `ERJ-3EKF1003V` | 100 kΩ ±1%, 0.1 W, ±100 ppm/°C thick-film resistor | 0603 / 1608 metric, SMD | AEC-Q200; −55 to +155 °C | Current manufacturer listing; active at distributors, checked 2026-07-31 | FROZEN |

Manufacturer evidence: [Panasonic ERJ3EKF1003V product page](https://industrial.panasonic.com/ww/products/pt/general-purpose-chip-resistors/models/ERJ3EKF1003V) and datasheet `AOA0000C304`, dated 29-May-2025. Panasonic provides linked RoHS and REACH declarations. No footprint field has been assigned.

## 9. Fuse and Protection Analysis

- F101 remains blocked. The captured 2 A time-delay class matches the nominal rating concept, but no exact curve has yet proven 1.25 A hot carry, ≤4 A/10 ms inrush immunity, ≥100 A DC interrupt capability, and 10 A/5 s conductor clearing together.
- D101 remains blocked. An SMBJ33A-class device nominally offers suitable standoff and a published clamp near the 55 V ceiling, but its standard pulse rating is not yet reconciled to QER-01's 100 ms rectangular source, tolerance, temperature, repetition, fuse, U101, Q101, and capacitor stresses.
- Q101 fails as captured: 55 V / 60 V = 91.7%, above the QER 90% transient-utilization ceiling.
- C102/C103/C104/C109 fail because a 50 V rating is below the permitted 55 V protected-node clamp.
- U101, D102/D103, Q102 and their dividers remain blocked pending exact gate, leakage, fault, SOA and threshold calculations.

## 10. Regulator Analysis

U201 and U203 candidate families span the required input/current range, but neither is frozen. Exact suffix, switching tolerance, input/output effective capacitance, soft start, current limit, load-step response, ripple, EMI, hot loss, shutdown behavior and minimum copper remain incomplete.

At 400 kHz, the captured 15 µH main inductor gives an estimated 0.37 A ripple at 9 V and 0.64 A at 21 V for 5 V output. At 2 A load the peak is approximately 2.32 A; QER requires at least 2.90 A hot saturation capability. The captured ≥3.2 A class is plausible but not an exact hot rating. U201 thermal compliance may require manufacturer-specified exposed-pad copper; the corrective package must state that minimum as a future layout constraint.

The core 2.2 µH path similarly requires the selected U203 frequency/tolerance and hot current-limit model before L202 or its capacitors can freeze. The captured TPS62130 family also has a newer manufacturer-recommended family, so lifecycle strategy remains unresolved.

## 11. MOSFET and Switch Analysis

- Q101: FAIL as captured on transient voltage derating; SOA, avalanche and gate clamp remain open.
- Q102: exact manufacturer 2N7002 not selected; gate stress, powered-off leakage and transient role remain open.
- U101/U102/U202/U206–U213: family-level voltage/current envelopes appear plausible, but exact suffix equations, RDS(on) loss, current-limit tolerance, startup, reverse behavior, retry mode, thermal impedance and partial-power behavior remain incomplete.
- No headline package-current rating is accepted as thermal evidence.

## 12. Magnetics Analysis

L101, L201, L202 and FB801 are blocked. Required evidence is hot Isat, RMS rating, DCR tolerance, copper loss, core loss, temperature rise, frequency behavior and surge response. L201's preliminary ripple calculation is recorded above; it is not a substitute for manufacturer hot curves. FB801 cannot freeze until D803 and the external segment's DC current and ESD return strategy are exact.

## 13. Capacitor Analysis

Twenty-nine capacitor rows remain blocked. Four raw-input rows have a direct voltage-rating conflict. The remainder lack one or more exact X7R/C0G dielectric choice, DC-bias curve, effective minimum, ESR/ESL, ripple, aging, tolerance, stability or lifetime result. The 47 µF mux capacitor also cannot be treated as satisfying QER core hold-up without a source-transition analysis; 47 µF alone is far below the capacitance needed for 1 A over 2 ms with only 0.3 V droop.

## 14. Resistor Analysis

The nine frozen resistors operate from no more than 5.25 V:

- voltage utilization: 5.25 V / 75 V = **7.0%**;
- current: 5.25 V / 100 kΩ = **52.5 µA**;
- dissipation: 5.25² / 100 kΩ = **0.276 mW**;
- power utilization: 0.276 mW / 100 mW = **0.28%**;
- upper-temperature margin: 155 − 75 = **80 °C**.

These pass QER-R-01 through QER-R-04 with ample margin. The other 39 resistor rows remain blocked because their device equations, feedback/current-limit targets, precision stacks, pulse/working voltage, temperature drift or failure effects are not all closed. Their captured values are not silently promoted to exact parts.

## 15. Power Connector Selection

J1 is `BLOCKED — MECHANICAL INTERFACE REQUIRED`. QER-01 defines ≥30 V, ≥3 A/contact, contact resistance, rise, retention and environmental capability, but the PCB/enclosure entry geometry, mounting orientation, exact cable, terminal family, service tooling and mating-interface ownership remain unresolved. No mating pair or terminal is guessed.

## 16. USB VBUS Protection

U102, D104 and D902 remain blocked. The complete chain must demonstrate 4.40–5.25 V delivery, 500 mA hardware cap, connector inrush, ≤10 µA host backfeed, connector ESD, TVS clamp below downstream absolute limits, and coordinated VBUS capacitance. D902's functional value does not identify an orderable VBUS device, and data-path ESD remains outside this power-only selection.

## 17. Derating Matrix

| Group | Voltage | Current/power | Temperature | Pulse/energy | Result |
|---|---|---|---|---|---|
| Nine frozen 100 kΩ resistors | 7.0% of working rating | 0.28% of power rating | 80 °C upper margin | No material pulse stress in reviewed bias functions | PASS |
| Four 50 V raw capacitors | 110% at allowed 55 V clamp | Not reached | Not reached | Rating below required clamp | FAIL |
| 60 V Q101 | 91.7% transient utilization | SOA incomplete | Incomplete | QER maximum is 90% | FAIL |
| All other power rows | Candidate dependent | Candidate dependent | Candidate dependent | Candidate dependent | INSUFFICIENT EVIDENCE |

No derating exception is approved.

## 18. Lifecycle and Sourcing

The frozen Panasonic resistor is supported by a current manufacturer product page and environmental declarations. On 2026-07-31:

- Mouser listed 505,209 units, 15-week estimated factory lead time, and cut-tape pricing;
- DigiKey listed more than 1,000,000 units of the preferred part;
- both observations are snapshots, not guarantees.

Supply risk is LOW because the electrical function is commodity, the preferred part is widely stocked, and an independently checked second-source candidate exists. Counterfeit exposure is controlled by authorized distribution.

## 19. Approved Alternates

`Vishay Dale RCG0603100KFKEA` is **ELECTRICALLY APPROVED — FOOTPRINT MAY DIFFER** for the nine frozen rows. It is an active 100 kΩ ±1%, 0.1 W, ±100 ppm/°C, −55 to +155 °C 0603 part. DigiKey listed 45,542 units and 17-week standard lead time on 2026-07-31. Final land-pattern equivalence remains part of the later footprint package.

No alternate is approved for any blocked row.

## 20. Cost Analysis

Preferred-part Mouser cut-tape snapshot: $0.100 at quantity 1, $0.024 at 10, $0.020 at 100, $0.012 at 1,000, and $0.007 at a 5,000-piece reel. Currency is USD; tariffs, freight, tax and reeling fees are excluded.

| Build quantity | Frozen resistor quantity | Estimated extended cost | Cost per controller |
|---:|---:|---:|---:|
| 1 | 9 | $0.90 | $0.90 |
| 10 | 90 | $2.16 | $0.216 |
| 100 | 900 | $18.00 using conservative per-reference 100-piece tier | $0.18 |
| 1,000 | 9,000 | approximately $63.00 using reel-tier planning | approximately $0.063 |

The complete power-subsystem cost and ten highest-cost power items cannot be ranked because 115 parts have no accepted MPN. Publishing a partial ranking as a subsystem total would be misleading.

## 21. EBOM/AVL Reconciliation

- EBOM rows: 301.
- Power-scope rows: 124.
- Frozen power rows: 9, all with exact MPN, rating, lifecycle, sourcing, alternate disposition, pricing and trace reference.
- Blocked power rows: 115, all with a specific blocker category.
- Outside scope: 177, all `NOT YET FROZEN`.
- EBOM CSV is canonical; XLSX and AVL workbooks are regenerated from controlled CSV data.

## 22. Risk Register

| ID | Severity | Finding | Impact | Required closure |
|---|---|---|---|---|
| CSR-01A-R-F01 | Critical | C102/C103/C104/C109 captured at 50 V conflict with 55 V clamp requirement | Cannot select compliant capacitors without value-rating correction | ECO updates rating to ≥63 V after capacitance/technology review |
| CSR-01A-R-F02 | Critical | Q101 captured at 60 V violates 90% transient derating | Reverse path cannot freeze | ECO updates requirement to ≥80 V and rechecks loss/SOA/gate clamp |
| CSR-01A-R-F03 | Critical | U706/U707/U801 are composite functions | No physical MPN/pin/quantity exists | Decompose into exact physical topology without architectural change |
| CSR-01A-R-F04 | Critical | Regulator/protection networks lack complete vendor calculations | Values/parts may change | Complete stability, thermal, transient and tolerance analyses |
| CSR-01A-R-F05 | Major | J1 mechanical interface is unreleased | Power connector cannot freeze | Release enclosure/harness boundary and exact mating system |
| CSR-01A-R-F06 | Major | 115 rows lack full lifecycle/sourcing/cost evidence because electrical selection is blocked | AVL and subsystem cost incomplete | Perform live checks after electrical pass |
| CSR-01A-R-F07 | Observation | Nine low-risk resistor rows are fully frozen | Partial procurement progress | Preserve exact evidence through later footprint review |

## 23. Remaining Blockers

| Blocker category | Affected references | Future package | Required evidence/decision | Acceptance blocked |
|---|---|---|---|---|
| Schematic value inconsistent | C102/C103/C104/C109/Q101 | ECO-006 | Correct voltage ratings and re-run coordination/SOA | Yes |
| Composite physical topology absent | U706/U707/U801 | ECO-006 | One-to-one physical devices, quantities, pins, defaults and timing | Yes |
| Thermal/stability analysis incomplete | U201/U203/L201/L202 and dependent passives | ECO-006 engineering analysis | Vendor-tool, effective-C, ripple, loss, copper minimum and transient proof | Yes |
| Transient coordination unresolved | Fuse/TVS/clamps/diodes/protection devices | ECO-006 engineering analysis | Exact curves, clamp, leakage, energy, interrupt and fault coordination | Yes |
| Mechanical interface missing | J1 | Mechanical Interface Release | Enclosure, mating pair, terminal, wire, tooling and service contract | Yes |
| Prototype/qualification tests | Ultimately all selected power parts | DVT | Validate calculations after selection | No by itself; validates rather than chooses parts |

The smallest corrective engineering package is **ECO-006 — Power Quantitative Alignment and Physical Function Decomposition**. It shall be limited to the five QER-inconsistent ratings, physical decomposition of U706/U707/U801, and device-dependent regulator/protection/passive values proven by calculations. Architecture, rail voltages, ownership, GPIO, hierarchy, connectors, footprints and PCB layout remain frozen.

## 24. Validation Results

- Every power-scope row has one allowed status.
- Every `FROZEN` row has an exact MPN and QER trace.
- Frozen rows contain electrical, derating, lifecycle, sourcing, alternate and cost evidence.
- EBOM/AVL row counts and statuses are machine checked.
- References remain globally unique; Reference Designator Register unchanged.
- No footprint, PCB, GPIO, hierarchy, connector contract, ADR, ICD or schematic electrical file is changed.
- Repository structural validators pass.
- Native KiCad ERC is unavailable because `kicad-cli` is not installed; this is retained as an existing release item, not a new CSR-01A-R failure.

## 25. Final Decision

# CSR-01A-R NOT ACCEPTED

CSR-01B is not authorized. Complete ECO-006 and the J1 Mechanical Interface Release, then reissue the power selection review.
