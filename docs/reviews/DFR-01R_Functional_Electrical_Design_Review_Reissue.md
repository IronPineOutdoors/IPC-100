# DFR-01R — Functional Electrical Design Review Reissue

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review | DFR-01R |
| Date | 2026-07-30 |
| Scope | ECO-001 verification and Package 07 / Sheet 06 entry gate |
| Final decision | **NOT APPROVED** |
| Package 07 status | **PACKAGE 07 / SHEET 06 REMAINS BLOCKED** |
| Owner | Iron Pine Outdoors Engineering |

## 1. Executive Summary

ECO-001 correctly moved the `ACTUATOR_PERMIT` and `MASTER_INHIBIT` labels onto the intended U3 input-pin endpoints. The original Critical coordinate/connectivity defect, DFR-01-F01, is dispositioned **CLOSED PENDING NATIVE ERC**. Architecture, polarity, ownership, GPIO allocation, translator topology, and opposing-PWM suppression remain unchanged.

The controlled reissue nevertheless does not authorize Package 07. The required power-state and floating-input audit identified a separate Major implementation defect: U3’s `PERMIT` and `INHIBIT` CMOS inputs have no local deterministic bias. If Sheet 06 is absent or unpowered, or either authorization interconnect opens, those powered U3 inputs can float. The two existing 100 kΩ resistors pull down U3’s output-enable nets, not its inputs, and cannot guarantee the state of an actively driven U3 output. This contradicts the frozen requirement that authorization never depend on a floating active-high input and prevents proof that missing or invalid authorization always disables motion.

The smallest correction is a narrow Sheet 05 ECO adding a local inactive default at `ACTUATOR_PERMIT` and a local asserted-safe default at `MASTER_INHIBIT`, followed by pin-level review and native ERC when available. This is an implementation correction, not an architecture change.

## 2. Scope

DFR-01R:

- verifies ECO-001 at pin, net, hierarchy, and polarity level;
- reassesses every DFR-01 finding;
- rechecks the integrated safety and power-domain behavior;
- evaluates whether the frozen contract is sufficient for Sheet 06 preliminary capture;
- runs all available repository validation.

DFR-01R does not modify KiCad, Sheet 06, ADRs, interfaces, footprints, PCB layout, or hardware architecture.

## 3. Documents Reviewed

- [DFR-01 Functional Electrical Design Review](DFR-01_Functional_Electrical_Design_Review.md)
- [Engineering Defect Review](Engineering_Defect_Review.md)
- [ECO-001 Correction Record](../../hardware/kicad/notes/ECO-001_Authorization_Connectivity_Correction.md)
- [Package 06R Sheet 05 Implementation](../../hardware/kicad/notes/Package_06R_Sheet_05_Implementation.md)
- ADR-039, ADR-040, ADR-041, ADR-042, and ADR-043
- External Safety Interface Control Document
- Motion Control Interface Control Document
- Sheet 00 and implemented Sheets 01–05
- Sheet 06 placeholder and root-sheet interface definition
- Open Design Items, Revision History, CHANGELOG, and repository validators

Accepted ADRs and interface-control documents were treated as frozen.

## 4. ECO-001 Verification

| Verification | Objective evidence | Result |
| --- | --- | --- |
| `ACTUATOR_PERMIT` reaches U3 `PERMIT` | U3 at `(75,46)` plus pin 1 relative `(-15.24,-7.62)` gives endpoint `(59.76,38.38)`; the only local `ACTUATOR_PERMIT` label is at that coordinate | Pass |
| `MASTER_INHIBIT` reaches U3 `INHIBIT` | U3 pin 2 relative `(-15.24,-2.54)` gives endpoint `(59.76,43.46)`; the only local `MASTER_INHIBIT` label is at that coordinate | Pass |
| Labels are attached, not adjacent | Exact coordinate regression checks pass for both endpoints | Pass |
| U3 input numbers/functions | Pin 1 is named `PERMIT`; pin 2 is named `INHIBIT`; U3 value declares `EN = PERMIT AND NOT INHIBIT` | Pass at preliminary-symbol level; Pending Native ERC/vendor-symbol audit |
| Alternate/duplicate labels | Sheet 05 contains exactly one hierarchical and one local label for each authorization net | Pass |
| No authorization pin electrically orphaned | Both pins have a named-net attachment | Pass |
| Deterministic pull state | No resistor or other local bias is attached to either U3 input; R1/R2 bias `AXIS1_XLAT_EN`/`AXIS2_XLAT_EN` instead | **Fail — new DFR-01R-F11** |
| Polarity | `ACTUATOR_PERMIT` high permits; `MASTER_INHIBIT` high disables; this matches ADR-042/043 | Pass |
| Producer/consumer directions | Sheet 06 outputs both signals; Sheet 05 inputs both signals; root has one producer and consumer for each | Pass |
| Opposing-PWM suppression unchanged | Both `R_OK = RPWM AND NOT LPWM` and `L_OK = LPWM AND NOT RPWM` blocks remain present | Pass |
| No direct STOP path | `STOP_HW_INHIBIT` is absent from Sheet 05 and remains Sheet 04-to-06 | Pass |
| Sheet 05 authority | Sheet 05 consumes authorization and conditions requests; it does not create permit | Pass |

ECO-001 fully corrects the defect it was authorized to repair. DFR-01R-F11 is a separate default-state defect revealed by the broader reissue criteria.

## 5. Critical Finding Disposition

| Original finding | Classification | Disposition | Basis |
| --- | --- | --- | --- |
| DFR-01-F01 — authorization labels disconnected from U3 | Critical | **CLOSED PENDING NATIVE ERC** | Both labels now coincide with the intended U3 pin endpoints, exact attachment regression checks pass, hierarchy ownership is correct, and no duplicate label exists. Native KiCad ERC remains unavailable and therefore prevents unconditional closure. |

## 6. Remaining Finding Dispositions

| Finding | Original class | Current status | Evidence reviewed | ECO-001 effect | Blocks Sheet 06? | Required closure / responsible package |
| --- | --- | --- | --- | --- | --- | --- |
| DFR-01-F02 — preliminary custom symbols and no native ERC | Major | Pending Native ERC | Implementation records, custom symbols, validator output, tool availability | Added targeted connectivity regression but did not audit vendor pin mapping | No; blocks later schematic release, not preliminary capture by itself | Native ERC and vendor-symbol audit in Package 07 review and complete schematic release |
| DFR-01-F03 — Sheet 04 quantitative safety proof incomplete | Major | Pending Prototype Validation | ODI-SCH-012, safety ICD, nominal threshold/timing record | None | No; ADR-042 provides a complete input contract for preliminary capture | Exact parts, tolerance/SPICE, single-fault and prototype timing; Sheet 04 release work |
| DFR-01-F04 — Sheet 05 timing/partial-power/driver proof incomplete | Major | Pending Prototype Validation | ODI-SCH-014, motion ICD, Package 06R record | Corrected only input attachment | No by itself; blocks release/energization | Exact devices, Ioff/timing/driver/ESD tests; Sheet 05 release and prototype packages |
| DFR-01-F05 — Sheet 06 authorization not implemented | Major | OPEN — NONBLOCKING | Sheet 06 ports, Boolean contract, watchdog and relay topology requirements | Corrected downstream attachment | The absence itself is Package 07 scope; F11 separately blocks entry | Implement and fault-analyze low-energy authorization before relay drive; Package 07 |
| DFR-01-F06 — power-path quantitative validation incomplete | Major | Pending Prototype Validation | Sheets 01/02 records, ADR-039, open power items | None | No for preliminary Sheet 06 capture | Exact-part, transition, backfeed, thermal and timing verification; power release/prototype |
| DFR-01-F07 — stale shared eight-channel translator wording | Minor | Closed | ADR-043 and ODI-OUT-002 | None | No | ODI-OUT-002 corrected by DFR-01R documentation update |
| DFR-01-F08 — physical ESD/backfeed containment absent | Minor | Pending PCB Review | Sheet 09 placeholder, interface ICDs | None | No | Exact connector/protection placement and return paths; Sheets 09/PCB |
| DFR-01-F09 — hierarchy ownership consistent | Observation | Accepted for Rev A | Hierarchy validator and manual ownership audit | Added authorization contracts | No | Preserve through Package 07 |
| DFR-01-F10 — GPIO allocation complete | Observation | Accepted for Rev A | GPIO validator and ADR-040 | None | No | Preserve through Package 07 |

### New reissue finding

| Finding | Class | Release status | Concrete basis | Required action |
| --- | --- | --- | --- | --- |
| DFR-01R-F11 — U3 authorization inputs lack deterministic local defaults | **Major** | **Blocking** | Sheet 05 contains direct labels from the authorization nets to U3 pins 1/2 but no pulldown on `PERMIT` and no asserted-safe pullup on `INHIBIT`. R1/R2 are connected to U3 outputs. With Sheet 06 absent/unpowered or an open interconnect, powered CMOS inputs can float and U3 can actively oppose the downstream pulldowns. | Narrow ECO: add local `ACTUATOR_PERMIT` inactive bias and `MASTER_INHIBIT` asserted-safe bias consistent with voltage/power domains; verify open-net, power-up/down, and partial-power truth table; run ERC when available. |

## 7. Safety-Chain Reassessment

### Implemented

- Five supervised NC loops produce conservative conditioned states.
- Sheet 04 exports independent active-high `STOP_HW_INHIBIT`.
- Sheet 02 produces fail-low `MAIN_POWER_GOOD`.
- Sheet 03 produces fail-low `RESET_VALID`.
- Sheet 05 implements opposing-PWM suppression, two translator branches, safe-side pulldowns, and corrected U3 pin attachment.
- Sheet 05 does not consume STOP directly or generate authorization.

### Planned on Sheet 06

Sheet 06 must implement:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

It must own watchdog qualification, startup behavior, relay command gating, and fail-safe generation of both authorization exports.

### Safety conclusions

- With valid driven authorization, Sheet 05 requires permit high and inhibit low before either translator OE can assert.
- Asserted `MASTER_INHIBIT` produces an inactive result through U3’s Boolean function.
- Processor reset drives command GPIOs high-impedance/low-biased and makes future `RESET_VALID` false.
- USB-only removes both motor-logic branches and future main-qualified authorization.
- Opposing PWM is suppressed independently of firmware.
- No direct STOP bypass or new firmware-only safety path exists.

The chain is not yet complete: Sheet 06 is intentionally unimplemented, and Sheet 05 does not locally force U3’s authorization inputs to safe states when their producer is missing or disconnected. Therefore the statement “no actuator request can propagate without an intended permit state” is not proven for every required failure state.

## 8. Power-Domain Reassessment

| State | Expected behavior | Review result |
| --- | --- | --- |
| Normal main power | Sheet 06 drives complementary authorization; U3 gates translator enables | Contract complete; implementation pending |
| USB only | `+3V3_CORE` may power U3 while motor 5 V branches and Sheet 06 main authorization are absent | Translator B sides are unpowered and safe outputs pulled low, but U3 inputs can float; F11 |
| Main brownout | `MAIN_POWER_GOOD` falls and motor branches collapse | Intended safe; timing remains prototype evidence |
| `+3V3_CORE` startup | U3 powers before/independently of a valid authorization producer | Input defaults are not locally deterministic; F11 |
| Translator branch startup | OE must remain low until stable permit | Output pulldowns help, but U3 input float prevents complete proof; F11 |
| Loss of actuator-logic power | Safe-side pulldowns force inactive connector nodes | Pass at preliminary topology level |
| Sheet 06 absent | U3 remains present and can be core-powered while both authorization nets have no driver | **Fail; F11** |
| Processor held reset | Commands low-biased; future Sheet 06 must keep permit invalid | Pass contractually; Sheet 06 pending |
| External driver powered first | Selected translator must provide Ioff and external equipment must not drive IPC-100 | Pending exact-device/prototype validation; ECO-001 introduced no new path |

ECO-001 only moved two labels and introduced no phantom-power coupling. The remaining concern is undefined logic state, not a new conductive backfeed path.

## 9. Interface and Hierarchy Reassessment

Validation and manual review confirm:

- every Sheet 05 port matches Sheet 00;
- Sheet 06 is the sole producer and Sheet 05 the sole consumer of both authorization nets;
- Sheet 09 remains the sole destination owner for eight conditioned motion commands;
- raw GPIO identifiers remain confined to Sheet 03;
- no orphan or duplicate motion net exists;
- rejected PAN/TILT/shared-speed names remain absent;
- `OUTPUT_FAULT_SUMMARY` remains removed;
- limits remain Sheet 04-to-03 observations;
- no home, position encoder, ready, or driver-fault interface was added.

The Sheet 06 interface contract is otherwise sufficient. It defines authorization inputs, polarity, watchdog behavior, relay command ownership, relay power, output ownership, startup defaults, and failure behavior without requiring a new signal or architecture decision.

## 10. Validation Results

| Check | Result |
| --- | --- |
| Hierarchy and port synchronization | Pass; 9 child sheets, matched unique ports |
| Sheet 06 producer / Sheet 05 consumer | Pass for `ACTUATOR_PERMIT` and `MASTER_INHIBIT` |
| Authorization endpoint regression | Pass; exact U3 endpoints reported |
| GPIO allocation | Pass; 36 rows, no duplicate or missing GPIO |
| Motion rejected-signal checks | Pass; no PAN/TILT, raw GPIO, home, ready, driver-fault, or fault-summary interface |
| S-expression balance | Pass for all schematics |
| UUID uniqueness | Pass; 2,565 project UUIDs |
| Reference uniqueness | Pass within implemented-sheet placement audits |
| Footprint scope | Pass; zero schematic footprints |
| Authorization label counts | Exactly one hierarchical and one local label per authorization net on Sheet 05 |
| Deterministic U3 input bias | **Fail; no local input bias found** |

No validation tool reported an architecture regression from ECO-001. Existing validators do not model floating CMOS inputs, so DFR-01R-F11 results from electrical review rather than syntax failure.

## 11. Native ERC Status

`kicad-cli` is unavailable. Native KiCad ERC was not run, and no ERC completion is claimed.

DFR-01-F01 remains **CLOSED PENDING NATIVE ERC**. DFR-01-F02 remains **Pending Native ERC**. ERC absence alone would not block Sheet 06 preliminary capture, because preliminary custom-symbol capture has consistently retained ERC as a later release gate. DFR-01R-F11 independently blocks entry because it is visible in the schematic topology and required failure-state analysis.

## 12. Residual Risks

- Exact Sheet 04 thresholds and passive STOP failure behavior remain unverified.
- Exact Sheet 05 logic and translator partial-power behavior remain unverified.
- U3 authorization inputs lack safe local defaults.
- Sheet 06 watchdog and permit circuit do not yet exist.
- Source-transition and authorization-removal timing remain unmeasured.
- External driver, ESD, connector, and PCB return-path behavior remain deferred.
- A welded relay contact cannot be made safe by coil de-energization alone.

## 13. Sheet 06 Entry-Gate Assessment

The frozen Sheet 06 contract is sufficiently defined; no new authorization signal, polarity, power owner, relay command, thrower trigger, motor enable, watchdog policy, startup default, fault signal, or connector behavior needs to be invented.

Entry remains blocked solely because the existing Sheet 05 consumer does not meet the frozen missing-authorization default requirement. Implementing Sheet 06 while leaving F11 unresolved could hide the problem during normal operation but would not correct open-interconnect, producer-unpowered, or partial-power behavior.

The smallest corrective package is a Sheet 05 implementation ECO. It shall add deterministic local bias at both U3 authorization inputs without changing names, polarity, logic, ownership, GPIOs, translators, or Sheet 06.

## 14. Final Decision

# NOT APPROVED

## PACKAGE 07 / SHEET 06 REMAINS BLOCKED

This decision applies only to preliminary schematic capture. It does not reopen architecture and does not convert ERC, PCB, component-selection, or prototype items into entry blockers. The concrete blocker is DFR-01R-F11: missing deterministic local defaults on the powered Sheet 05 U3 authorization inputs.

## 15. Closure Criteria

1. Issue a narrow Sheet 05 ECO for DFR-01R-F11.
2. Add an inactive local bias to `ACTUATOR_PERMIT`.
3. Add an asserted-safe local bias to `MASTER_INHIBIT`.
4. Verify the bias domains do not create USB-only or partial-power backfeed.
5. Verify U3 input and output truth tables for normal, open, producer-unpowered, core-only, main-brownout, and power sequencing.
6. Extend regression validation to require both input biases and their correct nets.
7. Reissue or formally supplement DFR-01R.
8. Retain native ERC as mandatory before schematic release; do not claim it complete until run.
