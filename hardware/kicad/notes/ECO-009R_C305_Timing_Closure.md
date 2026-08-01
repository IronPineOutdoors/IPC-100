# ECO-009R — C305 Reset-Release Timing Closure

Date: 2026-07-31
Platform: IPC-100 Rev A

## 1. Scope

ECO-009R verifies the existing C305 implementation against released QER-03. It changes no schematic, topology, ownership, GPIO, hierarchy, connector, ADR, ICD, footprint, or PCB artifact. C305 remains a generic component requirement; exact active and passive MPN selection is deferred to PACS-01.

## 2. QER-03 Requirements

Timing starts when monitored `+3V3_CORE` crosses U302's positive SENSE threshold with MR inactive. QER-RST-02 sets 100 ms as the exact nominal target; QER-RST-03/04 require 75–150 ms at analytical endpoints; QER-RST-05 requires a guarded 76–149 ms measured prototype window. A qualifying falling-threshold crossing cancels timing and requires a complete new interval.

## 3. Current Implementation Audit

Objective inspection of `03_ESP32_Core.kicad_sch` establishes:

| Audit item | Evidence and disposition |
|---|---|
| Functional role | U302 is the TPS389030-Q1-class `+3V3_CORE` supervisor; it holds ESP32-S3 EN/CHIP_PU and `RESET_VALID` inactive until rail qualification and CT delay complete. |
| Timing element | C305, UUID `60000000-0000-4000-8000-000000000136`, is the only component on named net `CORE_RESET_CT`; it connects U302 pin 5 CT to GND. |
| Captured requirement | `93.1 nF ±1% C0G/NP0 ≥10 V; CT; 99.642 ms nominal; leakage ≤10 nA; -40..125 C`. |
| Alternate paths | No timing resistor, parallel capacitor, external discharge path, or second CT element is captured. U302's internal nominal 200 Ω CT pull-down owns discharge. |
| Stale value | C305 has one reference and no captured 10 nF value. Historical discussion remains only where explicitly labeled superseded. |
| Reset polarity | U302 open-drain active-low reset is pulled up by R301, 10 kΩ, on `CORE_POWER_GOOD`; release is active high. |
| Downstream connection | The released node drives U301 EN/CHIP_PU, C304 and SW301, and is exported as active-high `RESET_VALID`. |
| USB-only | Core reset may release; Sheet 06 still sees `MAIN_POWER_GOOD` false, so actuator authorization remains inhibited. |
| Brownout | Falling SENSE asserts reset without intentional CT delay and invokes internal CT discharge; recovery restarts the full interval. |

The shared EN capacitor C304 is downstream of the supervisor output and is not in parallel with CT. It may affect the output-edge waveform and remains a prototype measurement item, but it does not create an alternate CT timing path.

## 4. Timing Recalculation

TI SBVS303B defines:

`tPD(r) = CCT × VCT / ICT + tPD(r)(open)`

and the nominal convenience relation:

`tPD(r)(s) = CCT(µF) × 1.07 + 25 µs`.

For C305 = 0.0931 µF, nominal delay is `0.0931 × 1.07 + 0.000025 = 0.099642 s = 99.642 ms`.

The bounded capacitor stack is ±1% initial tolerance plus ±0.1% temperature behavior and ±0.1% aging/process allowance, combined arithmetically as ±1.2%. The CT current range is 0.90–1.35 µA, CT threshold range is 1.17–1.29 V, and selected-capacitor leakage is bounded at 10 nA in the adverse direction.

- Minimum: `93.1 nF × 0.988 × 1.17 V / (1.35 µA + 0.01 µA) + 25 µs = 79.1 ms`.
- Maximum: `93.1 nF × 1.012 × 1.29 V / (0.90 µA - 0.01 µA) + 25 µs = 136.6 ms`.

TI's current and threshold endpoints include active-device temperature and supply effects. C0G/NP0 makes voltage coefficient negligible at a CT voltage no greater than 1.29 V. Rail ramp precedes the released threshold-crossing reference event. The nominal open-CT 25 µs propagation term is included; because TI publishes no separate production endpoints for that term, its residual uncertainty is a prototype correlation item and is negligible relative to the available millisecond margins. Pin and board leakage are not assumed to cancel capacitor leakage.

These results reproduce ECO-009; no material deviation was found.

## 5. Design-Window Compliance

`75 ms ≤ 79.1 ms` and `136.6 ms ≤ 150 ms`.

Minimum-side margin is 4.1 ms. Maximum-side margin is 13.4 ms. Compliance uses endpoint analysis, not nominal timing alone.

## 6. Guarded Prototype-Window Compliance

`76 ms ≤ 79.1 ms` and `136.6 ms ≤ 149 ms`.

Guarded minimum-side margin is 3.1 ms. Guarded maximum-side margin is 12.4 ms. Prototype measurements must still satisfy 76–149 ms across the QER-03 matrix; analytical compliance does not waive physical qualification.

## 7. Startup Sequence Verification

The captured signal ownership preserves the released order:

1. `+3V3_CORE` becomes valid and crosses U302's positive threshold.
2. C305 charging begins; reset, EN/CHIP_PU and `RESET_VALID` remain asserted low.
3. U302 releases after the qualified 79.1–136.6 ms interval.
4. ESP32-S3 boot and firmware initialization occur afterward.
5. Firmware begins `WATCHDOG_SERVICE_MCU` only from initialized control flow.
6. Sheet 06 keeps `WATCHDOG_VALID` inactive until `RESET_VALID`, `MAIN_POWER_GOOD`, and two valid service transitions exist.
7. `ACTUATOR_PERMIT` and relay/motion authorization remain inactive until every independent hardware qualifier is true.

No path from C305 or `RESET_VALID` alone can authorize an actuator. USB-only boot deliberately cannot satisfy `MAIN_POWER_GOOD`.

## 8. Brownout and Restart Verification

TPS3890-Q1 assertion is independent of the programmable release delay. Crossing the guaranteed negative SENSE threshold asserts reset, disables processor service, invalidates the Sheet 06 watchdog, and inhibits authorization. U302's internal nominal 200 Ω CT pull-down discharges C305 while reset is asserted. A subsequent valid positive crossing starts a complete new delay.

Brief interruptions that remain above the negative threshold need not restart the timer and must not glitch reset. Sustained interruptions, repeated crossings, slow recoveries, fast recoveries, and USB/main transitions that cross the negative threshold follow the full-restart rule. Retained-charge and CT-node contamination are explicitly included in QER-03 prototype testing. The present evidence does not justify adding an external discharge component or changing topology.

## 9. Failure-Mode Review

| Failure | Reset / processor state | `RESET_VALID`, watchdog, authorization | Consequence, diagnostic and residual risk |
|---|---|---|---|
| C305 open or timer pin open | Near open-CT release; processor may start early | Reset validity may rise, but watchdog/main/STOP gates remain required | No direct motion authorization; detect by release-timing test; single-fault readiness coverage remains limited. |
| C305 short or timer pin short | Reset held; processor unavailable | Low / invalid / inhibited | Safe unavailable state; startup timeout diagnostic. |
| C305 low | Early release | Independent gates retained | Reject if below 75 ms analytical or 76 ms measured. |
| C305 high | Late release | Inhibited until release | Safe availability loss; reject above 150/149 ms limits. |
| Excessive leakage | Early or late depending direction | Independent gates retained | Timing test and cleanliness/process control required. |
| U302 unpowered | Reset held through fail-low behavior | Low / invalid / inhibited | Safe unavailable state. |
| U302 output stuck asserted | Processor held reset | Low / invalid / inhibited | Safe unavailable state. |
| U302 output stuck released | Processor supervision lost | May indicate released; watchdog/main/STOP still required | No direct authorization, but reduced diagnostic coverage is residual risk. |
| Unstable monitored rail | Repeated reset and timer restart | Watchdog cannot qualify; authorization inhibited | Safe unavailable/chattering-reset state; verify threshold waveforms. |

No C305 failure directly energizes a relay or authorizes motion.

## 10. Final C305 Electrical Requirement

| Attribute | Selectable requirement |
|---|---|
| Nominal capacitance | 93.1 nF |
| Initial tolerance | ±1% maximum |
| Dielectric | C0G/NP0 only |
| Voltage rating | ≥10 V |
| Temperature | Rated and characterized from -40 °C through +125 °C minimum |
| Leakage | ≤10 nA across the released voltage/temperature range |
| Aging/drift | C0G/NP0; combined temperature plus aging/process allowance ≤±0.2% beyond initial tolerance |
| Classification | Timing critical; do not substitute |
| Lifecycle | Active/preferred, production-supported part required at selection |
| Sourcing | Preferred source plus electrically equivalent alternate required where feasible |
| Alternate | Must independently meet every electrical limit and reproduce the complete 75–150 ms endpoint calculation |

Exact package and MPN remain PACS-01 decisions coordinated with the exact U302 ordering code. No candidate is inferred here.

## 11. Schematic Disposition

The current schematic already contains the correct generic C305 requirement, reference, UUID, CT-to-ground topology and blank footprint. ECO-009R makes no redundant schematic edit. No stale implementation annotation conflicts with QER-03; historical 10 nF statements remain only as traceable superseded history.

## 12. EBOM/AVL Reconciliation

The C305 CSV and XLSX rows are synchronized to the final generic electrical requirement, timing-critical classification, QER-03/ECO-009R trace and `BLOCKED - PACS-01` status. The AVL carries the same trace, status and risk. No manufacturer, MPN, alternate, package or footprint is guessed. All other rows are preserved.

## 13. Validation Results

Targeted validation checks value, tolerance, dielectric, timing calculations and margins, CT topology, UUID/reference uniqueness, reset/watchdog/authorization semantics, CSV/XLSX/AVL synchronization, unchanged architecture interfaces, zero footprints and no PCB changes. The complete repository validator suite and `git diff --check` are required at package close.

## 14. Native ERC Status

`kicad-cli` is not available on PATH in the current environment. Native ERC remains pending and must be run before schematic/PCB release. Repository structural validation is not a substitute for native ERC.

## 15. Remaining U302/PACS-01 Dependency

PACS-01 must select the exact U302 order code and exact C305 MPN, verify suffix-specific threshold/timing guarantees, lifecycle, sourcing, package, leakage and manufacturer evidence, then execute QER-03 prototype confirmation. This dependency no longer represents an undefined timing requirement or incorrect schematic value. ECO-009R does not authorize CSR-01A-R5.

## 16. Manual Review Checklist

- [x] C305 reference, UUID, value, tolerance, dielectric and CT connection audited.
- [x] Nominal and bounded timing recalculated from TI SBVS303B.
- [x] QER-03 design and guarded analytical envelopes pass.
- [x] Startup, USB-only, brownout and repeated-crossing behavior reviewed.
- [x] Failure modes preserve independent authorization gates.
- [x] EBOM/AVL generic requirements synchronized without MPN or footprint.
- [x] No schematic topology change required.
- [ ] Select exact U302/C305 order codes in PACS-01.
- [ ] Complete QER-03 prototype timing matrix.
- [ ] Run and disposition native ERC when KiCad CLI is available.

## Final Decision

# ECO-009R COMPLETE — PACS-01 AUTHORIZED

The existing 93.1 nF implementation satisfies both released analytical windows, retains deterministic startup/brownout behavior, and requires no topology correction. PACS-01 alone is authorized next. CSR-01A-R5, PPC-01, JCS-01, footprints and PCB work remain unauthorized.
