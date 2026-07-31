# ECO-004 — SSR-01 Interface Remediation

## 1. Scope

ECO-004 corrects only SSR-01 findings F01 and F02: the J6/J7 I²C branches and the J13 USB-C service boundary. It changes Sheets 07 and 09, assigns no footprints, and does not authorize Package 11 or PCB work.

## 2. SSR-01 Findings Addressed

- F01: direct exposure of the base I²C bus did not provide independent power qualification, partial-power isolation, or branch-fault containment.
- F02: J13 used an incomplete grouped connector abstraction and omitted assigned connector-entry protection and shell provisions.

The broader exact-part, quantitative, single-fault, ERC, SI, EMC, thermal, BOM/AVL, footprint, and prototype gates remain open.

## 3. Authoritative Requirements

The correction was checked against SSR-01, ICD-002, ICD-001, ECO-003, Packages 08/09R/10R, MFG-01, ADR-039 through ADR-044, Sheets 00/02/03/07/08/09, the ODI register, revision history, changelog, and repository validators. Signal ownership, hierarchy, GPIO allocation, safety behavior, and connector roles remain frozen.

## 4. J6 Current-State Audit

Before ECO-004, J6 received `OLED_VCC`, ground, `OLED_RESET_N`, and direct aliases of base `I2C_SDA`/`I2C_SCL`. Sheet 07 owned the only 4.70 kΩ base pull-ups. No local branch qualification, Ioff guarantee, backfeed block, or isolated stuck-low containment was represented. Connector pin mapping, ESD ownership, and Sheet 09 physical-boundary ownership were unchanged.

## 5. J7 Current-State Audit

Before ECO-004, J7 received `SENSOR_VCC`, ground, and direct aliases of base `I2C_SDA`/`I2C_SCL`. Pull-up and hierarchy ownership matched J6, but the BME280 branch likewise lacked power-qualified isolation and partial-power behavior.

## 6. Corrected J6/J7 Architecture

Sheet 07 now contains exactly two provisional dual-supply, open-drain-compatible branch functions:

| Branch | Base side | Qualification/branch supply | Connector nets |
| --- | --- | --- | --- |
| U6 / J6 | `+3V3_CORE`, base SDA/SCL | `OLED_VCC` | `J6_I2C_SDA`, `J6_I2C_SCL` |
| U7 / J7 | `+3V3_CORE`, base SDA/SCL | `SENSOR_VCC` | `J7_I2C_SDA`, `J7_I2C_SCL` |

There is one path per branch. Sheet 09 remains the passive physical connector boundary; ECO-003 hierarchy is unchanged.

## 7. Branch Qualification and Isolation

Each branch is enabled only when its own peripheral rail is valid, is fail-disabled when that rail is absent or browning out, supports bidirectional open-drain SDA and clock-compatible SCL at 100 kHz, and requires Ioff behavior on both sides. Preliminary selection requirements are: 3.3 V operation on both domains, power-off high impedance, Ioff ≤10 µA, no back-power path, no isolated stuck-low propagation, and deterministic disable without a separate MCU GPIO.

## 8. Pull-Up and Protection Ownership

Sheet 07 retains the sole base-bus 4.70 kΩ pull-up pair. No base-bus or Sheet 09 duplicates were added. Branch pull-ups remain provided by the accepted powered OLED/BME280 module boundary; the isolators must present high impedance before branch power is invalid. Connector-side ESD remains an exact-part/PCB placement release item under ICD-002.

## 9. J13 Current-State Audit

Before ECO-004, J13 was a 12-pin abstraction. Independent 5.1 kΩ ±1% CC1 and CC2 Rd resistors existed, but the schematic did not explicitly account for all 24 Type-C contacts, shell, unused SuperSpeed/SBU contacts, D+/D− ESD, VBUS connector-entry protection, or configurable shield treatment.

## 10. Complete USB-C Boundary

J13 now represents A1–A12, B1–B12, and shell S1. A6/B6 share `USB_D+`; A7/B7 share `USB_D-`; A4/A9/B4/B9 share `USB_VBUS_RAW`; A1/A12/B1/B12 use signal ground; A5 and B5 remain independent CC nets. The eight SuperSpeed and two SBU contacts have explicit no-connect markers. The role remains USB 2.0 UFP/service only: no host, source, PD, alternate mode, or SuperSpeed implementation.

## 11. CC Terminations

R1 connects CC1 to signal ground and R2 connects CC2 to signal ground. Each is provisionally 5.1 kΩ ±1%. They are not shared; no Rp, DRP, current advertisement, or PD controller is present. Vendor, package, voltage coefficient, and footprint remain deferred.

## 12. USB Data Protection

D1 is a provisional two-channel connector-entry D+/D− ESD array returning directly to ground, without clamping to an unpowered logic rail. Requirements: ≥5.5 V working voltage, IEC 61000-4-2 target to be finalized, ≤1 pF/channel, ≤100 nA leakage, two matched channels, and flow-through layout preference. Exact device, footprint, routing, and signal-integrity closure remain open.

## 13. VBUS Protection

D2 represents the connector-entry 5 V VBUS ESD/transient shunt. J13 VBUS is not tied to field or actuator rails. Fuse/current limiting, source selection, reverse-current blocking, `USB_5V_PROTECTED`, USB-only startup, and dual-supply behavior remain owned by Sheets 01/02; they were not duplicated. No PD voltage is assumed.

## 14. Shield and Shell Treatment

`USB_SHIELD` is distinct from signal ground. C1 provides a DNP 1 nF, ≥1 kV capacitive option and R3 a parallel DNP 1 MΩ bleed option to signal ground. Neither is populated by default. A direct chassis landing or DNP zero-ohm chassis bond is a later PCB/enclosure decision; no unauthorized chassis net was created. Normal USB return current does not depend on the shell, and EMC closure is not claimed.

## 15. Electrical Requirements for Provisional Components

| Function | Preliminary requirement | Final status |
| --- | --- | --- |
| U6/U7 branch function | 3.3 V dual-supply, 100 kHz open drain, power-off high-Z, Ioff ≤10 µA, fail-disabled | Exact part and timing verification open |
| D1 data ESD | ≥5.5 V, two channels, ≤1 pF/channel, ≤100 nA, IEC target, flow-through preferred | Exact part open |
| D2 VBUS ESD | 5 V working, no PD assumption, IEC target and surge energy to be verified | Exact part open |
| R1/R2 | 5.1 kΩ ±1% | Vendor/package open |
| C1/R3 | DNP 1 nF ≥1 kV / DNP 1 MΩ | EMC validation and package open |

## 16. DFT Provisions

J6/J7 power, qualification, and isolated bus states are accessible at the connector boundary; J13 exposes VBUS, data, CC, ground, and shield for a later fixture. No additional data-line test symbols were added because their capacitance and stubs could compromise USB or I²C. Physical pogo geometry remains a PCB-stage DFT item.

## 17. Default-State Table

| Condition | J6 | J7 | USB boundary | Actuator effect |
| --- | --- | --- | --- | --- |
| Reset/brownout | Disabled unless `OLED_VCC` valid | Disabled unless `SENSOR_VCC` valid | Passive UFP; Rd present | None; cannot authorize |
| Branch rail off | Isolated/high-Z | Isolated/high-Z | Unchanged | None |
| Base rail off | Ioff/high-Z required | Ioff/high-Z required | USB recovery remains power-sheet controlled | None |
| USB absent | Unchanged | Unchanged | No VBUS; CC Rd passive | None |
| USB only | Branches follow accepted rails | Branches follow accepted rails | Protected 5 V handoff to Sheets 01/02 | Field/actuator rails not powered |

## 18. Failure-Mode Review

For either I²C branch, rail-off, external powering, brownout, reset, unplugging, or an unpowered isolator requires high impedance and no base backfeed. A branch SDA/SCL short low or to branch power is contained while isolated; while enabled it may impair that bus and requires prototype fault testing. A floating enable is excluded by rail-derived qualification/fail-disable behavior. Address conflict or a failed pull-up affects communication only. An isolator short or failed-on remains a single-fault/prototype gate and cannot directly authorize motion or relay operation.

For J13, USB insertion with either system-power state follows the existing protected-source architecture. D1/D2 shunt connector-entry ESD; a shorted protection device disables/loads USB and an open device removes protection but cannot authorize actuators. CC open/wrong-value/partial insertion prevents or degrades attachment. A VBUS short is handled by upstream current-limit/fuse ownership. A shell open reduces EMC performance; an accidental shell-ground short selects a non-default bond and requires EMC review. Moisture, swapped data, or unapproved PD source results in loss/risk to the service interface, not authorization. Exact transient, contamination, partial-mate, and single-fault testing remain open.

## 19. Validation Results

Repository checks pass for hierarchy, 54 frozen Sheet 09 signals plus four ECO-003 exposures, GPIO allocation, reference/UUID uniqueness, S-expression balance, branch count/qualification, complete USB contacts, ten explicit no-connects, independent Rd, zero footprints, and `git diff --check`. GPIO37 remains reserved; GPIO42 remains only `WATCHDOG_SERVICE_MCU`; no raw GPIO route, PCB file, ADR, or ICD changed.

## 20. Native ERC Status

`Get-Command kicad-cli` and these paths were checked:

- `C:\Program Files\KiCad\9.0\bin\kicad-cli.exe`
- `C:\Program Files\KiCad\8.0\bin\kicad-cli.exe`
- `C:\Program Files\KiCad\7.0\bin\kicad-cli.exe`
- `C:\Program Files\KiCad\6.0\bin\kicad-cli.exe`

No executable was found. The intended command is `kicad-cli sch erc --exit-code-violations -o <report> hardware/kicad/IPC-100.kicad_sch`. Native ERC remains pending and blocking for schematic release.

## 21. Remaining Release Gates

Exact/orderable components and vendor pin mappings; all footprints; BOM/AVL; branch enable thresholds, timing and partial-power bench tests; ESD ratings; USB routing/SI; power/thermal/safety timing calculations; complete single-fault analysis; EMC/enclosure bond selection; native ERC; prototype validation; and PCB/DFM review remain open. SSR-01 is not reissued by this ECO, and Package 11 remains unauthorized.

## 22. Manual Review Checklist

- [x] Exactly one qualified isolated path to J6 and one to J7
- [x] Independent `OLED_VCC` / `SENSOR_VCC` qualification; no new GPIO
- [x] Sole Sheet 07 base pull-up pair; no direct bypass
- [x] Full J13 contact/shell accounting and ten explicit no-connects
- [x] Independent CC1/CC2 5.1 kΩ Rd
- [x] D+/D− and VBUS connector-entry protection provisions
- [x] Non-default configurable shell network; signal-ground return preserved
- [x] Frozen hierarchy, GPIO, safety, and power ownership preserved
- [x] Zero footprints and no PCB/ADR/ICD changes
- [ ] Exact-part review, native ERC, SI/EMC, single-fault, and prototype verification

ECO-004 COMPLETE — SSR-01 INTERFACE FINDINGS CLOSED

Completion of ECO-004 does not authorize Package 11.
