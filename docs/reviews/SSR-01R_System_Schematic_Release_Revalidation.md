# SSR-01R — IPC-100 Rev A System Schematic Release Revalidation

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review date | 2026-07-30 |
| Baseline | ECO-004 commit `7f387bf` |
| Scope | Complete Sheet 00–09 electrical design |
| Review type | Post-ECO verification and Package 11 entry decision |
| Owner | Iron Pine Outdoors Engineering |

## 1. Executive Summary

SSR-01R reviewed all ten schematic sheets and the frozen ADR/ICD, ECO, package, manufacturing, revision, and validation records. ECO-004 directly corrects the two concrete interface defects that made the previous schematic topology incomplete:

- J6 and J7 now have separate, peripheral-rail-qualified, fail-isolated I²C paths.
- J13 now has a complete USB-C USB 2.0 UFP contact boundary, two independent CC Rd terminations, connector-entry data/VBUS protection provisions, and configurable shell treatment.

No architecture drift was found. The hierarchy, 54 frozen Sheet 09 ports, four ECO-003 ports, GPIO allocation, watchdog and authorization chains, connector ownership, and zero-footprint state are preserved.

The electrical architecture and functional schematic baseline are stable enough to enter controlled component selection and footprint assignment. This is not an unconditional fabrication release. Major observations remain for exact orderable devices and vendor pin maps, worst-case electrical analyses, native ERC, connector/mechanical definition, BOM/AVL, USB SI/EMC, thermal work, single-fault analysis, and prototype validation. Package 11 shall close these items incrementally; no footprint may be accepted before its exact device, pin mapping, ratings, and land pattern are reviewed.

## 2. SSR-01 Finding Closure Matrix

| ID | Original issue / sheets | Corrective action and direct evidence | Remaining risk | Status |
| --- | --- | --- | --- | --- |
| F01 | J6/J7 directly exposed base I²C; Sheets 07/09/00 | ECO-004 U6/U7 provide exactly two paths, qualified by `OLED_VCC` and `SENSOR_VCC`; values specify fail-disable, Ioff ≤10 µA, and isolated stuck-low/backfeed containment. Hierarchy validator checks count, contracts, base pull-ups, and ECO-003 routes. | Exact device, enable thresholds, partial-power, capacitance, and fault-injection tests | CLOSED |
| F02 | Incomplete J13 USB-C boundary and missing protection/shell capture; Sheets 09/01/03 | J13 now exposes A1–A12, B1–B12, S1; A6/B6 and A7/B7 are correctly grouped; ten SS/SBU contacts are explicit NC; R1/R2 are independent 5.1 kΩ ±1% Rd; D1/D2 and DNP C1/R3 provisions are present. | Exact receptacle/protection parts, footprint, SI/EMC and enclosure bond | CLOSED |
| F03 | Provisional component classes, pin maps, ratings, tolerances, and footprints; Sheets 01–09 | Functional classes and preliminary requirements are captured sufficiently to begin controlled selection. Zero footprints prevent accidental physical release. Package 11 is the corrective workflow. | A wrong device or land pattern can invalidate behavior; per-part review remains mandatory | PARTIALLY CLOSED |
| F04 | Native ERC unavailable/unclassified; Sheets 00–09 | Structural validation passes; PATH and KiCad 6.0–9.0 standard locations were searched again. No CLI was found. | Electrical-type and library issues may remain until native ERC | OPEN |
| F05 | Quantitative power, transition, thermal, safety timing, partial-power, and single-fault work open; Sheets 01/02/04–08 | Architecture and deterministic defaults remain coherent; package records identify preliminary constraints and test needs. No new contradictory topology was found. | Calculations or selected parts may require controlled ECOs | PARTIALLY CLOSED |
| F06 | Obsolete Package 01 placeholder text on Sheet 09 | Text remains a document-control inconsistency and does not alter connectivity. | Reader ambiguity until a later documentation-only schematic cleanup | OPEN |
| F07 | DFT1 uses a connector-shaped logical symbol | DFT1 remains explicitly non-BOM, non-board, nonpopulated and fixture-only; ECO-004 avoids extra USB/I²C loading and documents connector/fixture access. | Physical pogo geometry and access matrix remain PCB/DFT work | PARTIALLY CLOSED |
| F08 | Frozen hierarchy/GPIO/watchdog/defaults pass | Post-ECO validators pass and ECO-004 changed only Sheets 07/09 plus records/tooling. | Preserve regressions during Package 11 | CLOSED |

F03–F07 are controlled release observations rather than evidence of a remaining architecture or functional-topology defect. F04 is explicitly not classified as a schematic defect solely because the CLI is unavailable.

## 3. Architecture Review

| Area | Ownership and review result |
| --- | --- |
| Sheet 00 | Hierarchy only; all root/child ports match and are unique |
| Sheet 01 | Battery/USB entry protection ownership preserved |
| Sheet 02 | Conversion, source selection, main qualification, and switched-rail ownership preserved |
| Sheet 03 | ESP32-S3, reset/boot, native USB/UART, GPIO names, and watchdog-service producer preserved |
| Sheet 04 | Supervised STOP/limits and ARM/FIRE conditioning; conservative processor indications |
| Sheet 05 | Eight motion commands, opposing-PWM suppression, translation, authorization defaults |
| Sheet 06 | Independent watchdog, authorization logic, relay gate/driver, safe de-energized default |
| Sheet 07 | UI expander, sole base-I²C pull-up pair, UI loads, and now two isolated peripheral branches |
| Sheet 08 | Restricted DNP J10 segmented expansion; no GPIO37/CAN/RS-485 implementation |
| Sheet 09 | Sole physical connector/test boundary; full J13 UFP implementation |

ADR-039 through ADR-044 and ICD-001/ICD-002 remain consistent. ECO-004 did not modify Sheets 00–06 or 08, the ADRs, ICDs, GPIO inventory, or hierarchy. Future changes after this release baseline require controlled engineering change.

## 4. Signal Ownership Audit

Repository validation confirms root/child parity, unique hierarchy ports, one producer and intended consumers for the ADR-039 requests, `MAIN_POWER_GOOD`, safety authorization, eight motion commands/outputs, `WATCHDOG_SERVICE_MCU`, the four ECO-003 branch nets, and the 54 frozen Sheet 09 ports.

| Signal group | Voltage/default/loss behavior | Result |
| --- | --- | --- |
| Power requests | 3.3 V MCU outputs; deterministic boot/reset defaults; Sheet 02 is sole consumer | Pass |
| `MAIN_POWER_GOOD` | Hardware-owned, fail-low; Sheet 02 to Sheet 06; absent from MCU | Pass |
| STOP/limits | Supervised field inputs; conservative conditioned/fault behavior | Pass, quantitative tolerance open |
| `ACTUATOR_PERMIT` / `MASTER_INHIBIT` | Hardware-owned; local fail-low permit and fail-high inhibit bias | Pass |
| Watchdog | GPIO42 producer on Sheet 03; independent qualifier on Sheet 06 | Pass, exact timing open |
| Motion | Eight unique commands; hardware suppression and authorization; safe defaults | Pass |
| Base I²C | Sheet 07 sole 4.70 kΩ pull-up pair | Pass |
| J6/J7 I²C | One isolated path each; branch-rail qualified | Pass, exact partial-power verification open |
| USB | MCU data ownership on Sheet 03; connector/protection on Sheet 09; power handoff on Sheets 01/02 | Pass |
| J10 expansion | DNP, segmented, fail-disabled, Sheet 08 to Sheet 09 | Pass |

No duplicate producer or orphan consumer was reported. Named-label and structural checks do not replace exact-device electrical verification.

## 5. Power Review

The 9–21 V battery entry, protected source, conversion stages, main-priority source selection, USB-only core recovery, branch gating, and `MAIN_POWER_GOOD` authorization remain coherent. USB VBUS is not connected to field or actuator rails. J13 connector-entry D2 does not duplicate the upstream fuse/current-limit/reverse-current functions owned by Sheets 01/02.

U6/U7 introduce no uncontrolled source: their base side uses `+3V3_CORE`, while their branch side and qualification derive from the already controlled `OLED_VCC` or `SENSOR_VCC`. Power-off high impedance and fail-disable are explicit selection requirements. J10 remains independently qualified and DNP.

Open Package 11/release evidence includes total and simultaneous current budgets, input/transient energy, converter suffixes and passives, inrush/source transition, reverse leakage, rail ramp/brownout timing, watchdog rail behavior, sealed-enclosure thermal margins, and exact partial-power/Ioff performance.

## 6. Safety Review

The hardware-priority chain remains:

`STOP_HW_INHIBIT + MAIN_POWER_GOOD + reset validity + WATCHDOG_VALID + ACTUATOR_PERMIT + MASTER_INHIBIT → motion authorization and relay request gate`

ECO-001 restored connectivity and ECO-002 restored deterministic authorization bias. Firmware commands remain subordinate to hardware authorization. Loss of power, reset, watchdog timeout, missing authorization, asserted STOP, or broken authorization interface defaults outputs inactive. Opposing PWM cannot intentionally be asserted through the accepted Sheet 05 logic, and relay de-energized is the safe state.

No J1–J13 connector signal directly authorizes motion. Connector faults can remove power, communication, sensing, or commands but cannot independently satisfy the full authorization chain. Quantitative safety-loop thresholds, watchdog timing, partial-power logic behavior, relay stress/contact life, and complete single-fault analysis remain Major Package 11/prototype observations.

## 7. Connector Review

| Connector | Released role | Review |
| --- | --- | --- |
| J1 | Protected controller power input | Logical mapping retained; exact current/keying/sealing open |
| J2/J3 | Axis 1/2 external driver logic | Eight safe outputs distributed per ICD-002; motor power excluded |
| J4/J5 | Supervised limit harnesses | Logical mapping retained; harness tolerance/environment open |
| J6 | OLED branch | `OLED_VCC`-qualified isolated I²C plus reset; compliant topology |
| J7 | BME280 branch | `SENSOR_VCC`-qualified isolated I²C; compliant topology |
| J8A | Dedicated STOP | Kept separate and incompatible with ordinary UI |
| J8B | Ordinary UI | No STOP ownership; logical mapping retained |
| J9 | SELV relay dry contact | Restricted 0–30 VDC, 1 A resistive envelope; load validation open |
| J10 | Optional restricted I²C expansion | DNP by default; ICD-001 segmentation preserved |
| J11/J12 | Documentation-only future concepts | No symbol, pads, harness, or connectivity |
| J13 | USB 2.0 UFP service | Complete post-ECO boundary; exact connector/footprint open |
| DFT1 | Factory-only logical access | Nonpopulated/non-board; physical target plan open |

All eleven Rev A connector designation groups comply structurally with ICD-002. Connector families, vendor pin numbering, contact derating, keying, retention, sealing, mating cycles, wire gauge, ingress boundary, and mechanical access remain Package 11/mechanical gates.

## 8. USB Review

J13 explicitly accounts for every Type-C receptacle contact and shell. Four VBUS and four ground contacts are grouped appropriately. A6/B6 form `USB_D+`; A7/B7 form `USB_D-`. CC1 and CC2 each terminate independently through 5.1 kΩ ±1% Rd to signal ground. The eight SuperSpeed and two SBU contacts are explicit no-connects.

D1 provides a provisional low-capacitance two-channel data ESD function with direct ground return. D2 provides the connector-entry 5 V VBUS transient function. The service role has no host/source, Rp/DRP, PD, alternate-mode, or SuperSpeed implementation. USB-only and dual-power source behavior remain owned upstream. `USB_SHIELD` is distinct from signal ground, with DNP 1 nF/≥1 kV coupling and DNP 1 MΩ bleed options; normal return does not depend on the shell and no unauthorized chassis net exists.

Exact protection/receptacle selection, ESD targets, routing, impedance, return discontinuities, common-mode behavior, shield/enclosure bond, EMC, and USB compliance are not closed by schematic approval.

## 9. I²C Branch Review

U6 and U7 are independent dual-supply functional boundaries. U6 is qualified by `OLED_VCC`; U7 by `SENSOR_VCC`. Each is required to fail disabled, remain high impedance if either domain is absent, prevent back-powering, and contain an isolated branch-side stuck-low fault. They introduce no new GPIO or parallel bypass.

Sheet 07 retains exactly one 4.70 kΩ base SDA/SCL pull-up pair. Branch pull-up behavior remains part of the accepted powered module boundary; Sheet 09 adds none. Reset and brownout remove branch validity through the existing rail controls. Exact isolator selection must prove thresholds, Ioff ≤10 µA, 100 kHz compatibility, clock behavior, bus capacitance, partial-power sequencing, and stuck-bus recovery.

## 10. Manufacturing Assessment

The baseline is suitable for component/footprint engineering but not procurement, PCB release, or fabrication. Blank footprints and provisional symbols correctly prevent premature physical implementation. MFG-01 observations remain active for exact components, connector families, preferred passive sizes, derating, assembly process, coating, RF/mechanical constraints, test access, and environmental qualification.

## 11. DFM

Positive controls are single-owner interfaces, modular harness boundaries, isolated relay contacts, J8 safety/UI separation, DNP expansion, documentation-only J11/J12, and an explicit USB service boundary. Package 11 must establish:

- exact symbols and verified manufacturer pin maps;
- land-pattern sources, courtyard/assembly models, polarity and pin-1 controls;
- connector access/keying and enclosure interfaces;
- creepage, clearance, current-density, thermal and RF constraints;
- component availability/second-source policy and controlled DNP variants.

PCB placement and routing require a later gate.

## 12. DFT

Native USB and UART0 recovery are preserved. DFT1 exposes UART0 TX/RX, EN, BOOT, ground, and sense-only 3.3 V under a ground-first, fixture-never-sources-3V3 contract. Existing sheet-level logical test nodes cover important rail and functional states. ECO-004 intentionally avoids high-capacitance data-line test stubs.

Before placement release, issue a controlled test-access matrix for protected/input rails, safety thresholds, watchdog service/validity, permit/inhibit, pre/post-gate motion signals, relay drive, I²C qualification, USB VBUS/CC, and connector continuity. Target geometry, fixture limits, test limits, sequencing, and physical accessibility remain open.

## 13. Remaining Release Gates

The following are not unresolved topology defects, but remain hard gates at the appropriate Package 11, PCB, prototype, or manufacturing stage:

- native KiCad ERC and classified report;
- exact orderable devices, manufacturer symbols, vendor pin mapping and tolerances;
- reviewed footprints, BOM, AVL, lifecycle and substitution policy;
- connector families, contact ratings, keying, sealing, retention and harness release;
- power budget, transient/transition, brownout, timing, thermal and derating analyses;
- quantitative safety timing, partial-power and single-fault analysis;
- USB routing/SI, ESD, EMC and enclosure shield strategy;
- PCB placement/routing, RF keepout, creepage/clearance and DFM review;
- prototype fault injection, environmental qualification, factory-test development and production validation.

Native ERC status: `Get-Command kicad-cli` returned no executable. Standard Windows locations under `C:\Program Files\KiCad\6.0`, `7.0`, `8.0`, and `9.0` were absent. The intended command remains `kicad-cli sch erc --exit-code-violations -o <report> hardware/kicad/IPC-100.kicad_sch`. ERC is pending, but CLI absence is not itself a schematic defect.

## 14. Risk Register

| Class | Description and reason | Recommended next package | Blocking status |
| --- | --- | --- | --- |
| Critical | None identified | — | None |
| Major | Exact devices/pin maps/ratings are provisional and can change electrical or physical behavior | Package 11 component selection | Blocks accepting each affected footprint and later PCB release; does not block Package 11 entry |
| Major | Native ERC is unrun, so electrical-type/library findings are unknown | Package 11 validation environment | Blocks final Package 11/PCB release; not Package 11 entry |
| Major | Power, timing, thermal, partial-power and single-fault calculations remain incomplete | Package 11 quantitative closure | Blocks physical-design release where it affects part/land-pattern/copper choice |
| Major | Connector families and mechanical/environmental interfaces are unresolved | Package 11 plus mechanical interface package | Blocks connector footprint acceptance and placement |
| Major | USB SI/EMC and final shell/enclosure bond are unverified | USB/EMC PCB constraint package | Blocks USB physical-interface release, not schematic topology approval |
| Minor | Sheet 09 retains obsolete Package 01 placeholder wording | Next schematic documentation ECO | Nonblocking |
| Minor | DFT1 remains a generic logical connector form | Package 11 DFT/footprint convention | Nonblocking until physical test-access release |
| Observation | ECO-004 provisional branch/ESD symbols intentionally have blank footprints | Package 11 | Positive scope control |

## 15. Readiness Assessment

All ten sheets form a stable, internally consistent functional electrical baseline. The previous direct interface omissions are corrected, and no architecture, signal-ownership, GPIO, power-ownership, or authorization regression was found. The design is ready to transition from open-ended architecture capture to controlled exact-component and physical-library work.

Approval is bounded: Package 11 may begin component selection and footprint assignment as an engineering activity, but a footprint is not considered released until its exact device, pin map, ratings, calculations, and land pattern pass review. PCB placement, routing, fabrication, and procurement remain unauthorized.

## 16. Recommended Next Packages

1. Package 11A: exact component selection, manufacturer symbol/pin-map audit, BOM/AVL and lifecycle review by sheet.
2. Package 11B: quantitative power, timing, partial-power, relay, safety and thermal closure tied to selected devices.
3. Package 11C: native ERC installation/run, finding classification, footprint library audit, and footprint-assignment verification.
4. PCB entry review: connector/mechanical constraints, DFM/DFT matrix, USB SI/EMC, RF, creepage/clearance and placement authorization.

Any selected part that changes accepted function, polarity, ownership, interface, or safety behavior requires an ECO rather than silent Package 11 substitution.

## 17. Final Decision

# SCHEMATIC RELEASE APPROVED WITH MAJOR OBSERVATIONS

PACKAGE 11

Component Selection & Footprint Assignment

AUTHORIZED

This decision does not authorize PCB placement, routing, fabrication, procurement, or prototype release.
