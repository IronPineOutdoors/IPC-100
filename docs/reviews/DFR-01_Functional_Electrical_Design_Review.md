# DFR-01 — Functional Electrical Design Review

> **Superseded for the Package 07 entry decision by [DFR-01R](DFR-01R_Functional_Electrical_Design_Review_Reissue.md).** DFR-01R verifies ECO-001, dispositions every original finding, and records the current Sheet 06 entry-gate decision. This original review remains controlled history.

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review | DFR-01 |
| Date | 2026-07-30 |
| Review type | Integrated functional electrical design review |
| Scope | Implemented Sheets 00–05 and the defined Sheet 06 boundary |
| Decision | **NOT APPROVED** |
| Owner | Iron Pine Outdoors Engineering |

## Executive Summary

The IPC-100 Rev A architecture is logically partitioned and generally directs foreseeable loss-of-power, reset, field-wiring, and invalid-command conditions toward inactive actuators. Sheet ownership, GPIO allocation, main-versus-USB power separation, supervised normally-closed field loops, independent STOP export, and opposing-PWM suppression form a credible basis for continued development.

The implemented electrical design is nevertheless **not approved** to proceed into Sheet 06 high-current output implementation. One Critical capture defect leaves the Sheet 05 `ACTUATOR_PERMIT` and `MASTER_INHIBIT` inputs electrically disconnected from the authorization qualifier. The defect prevents the existing motion interface from being shown to obey the sole hardware authorization boundary. It is recorded separately in [Engineering Defect Review](Engineering_Defect_Review.md).

In addition, the safety-input thresholds and passive STOP failure behavior, motion-interface partial-power behavior and propagation, power-path sequencing/backfeed behavior, and exact custom-symbol pin mappings remain unverified. Native KiCad ERC has not been run. Those gaps do not prove unsafe behavior, but they prevent a professional design review from declaring the integrated design electrically correct or fail-safe.

No KiCad file, ADR, schematic, footprint, or Sheet 06 circuitry was modified during DFR-01.

## Architecture Reviewed

The review followed the integrated path:

`Battery → Sheet 01 protection → Sheet 02 conversion/distribution → Sheet 03 processor/reset → Sheet 04 safety inputs → Sheet 05 motion interface → defined Sheet 06/09 destinations`

The controlling evidence included:

- ADR-039 through ADR-043;
- the Power, External Safety, and Motion Control interface contracts;
- Sheets 00–05 and their implementation records;
- the schematic hierarchy and GPIO allocation validators;
- the critical-component and electrical-quantification record;
- the open-design-item register and test plan.

Sheets 06–09 are unimplemented placeholders. DFR-01 therefore reviews their frozen interfaces and ownership but does not claim that actuator authorization, relay drive, connectors, or production protection presently exist.

## Electrical Findings

| ID | Class | Finding | Engineering basis | Required disposition |
| --- | --- | --- | --- | --- |
| DFR-01-F01 | **Critical** | Sheet 05 authorization inputs are disconnected from U3. | U3 is at `(75, 46)`. Its revised `PERMIT` and `INHIBIT` pins terminate at `(59.76, 38.38)` and `(59.76, 43.46)`, while the corresponding labels remain at `(59.76, 40.92)` and `(59.76, 46.00)`. KiCad connectivity is coordinate-based; the labels do not touch the pins. U3 outputs therefore cannot be proven to follow Sheet 06 authorization. | Correct Sheet 05 under a controlled repair package; rerun connectivity checks and native ERC; prove both authorization states before Sheet 06 entry. |
| DFR-01-F02 | **Major** | Safety-critical custom symbols and exact pin mappings have not passed native ERC or vendor-symbol audit. | Sheets 01–05 use preliminary functional symbols. Their implementation records explicitly retain exact suffix, unit mapping, pin-type, and ERC blockers. Structural S-expression validation cannot detect an electrically misplaced label, as F01 demonstrates. | Replace or audit against released vendor symbols, run native ERC, and disposition every finding before relying on the integrated safety path. |
| DFR-01-F03 | **Major** | Sheet 04 has no completed worst-case threshold, hysteresis, slow-ramp, or single-fault proof. | The 1.00 V/4.00 V window, comparator loading, clamp leakage, cable capacitance, rail tolerance, partial-power behavior, and passive fail-high STOP claim remain open in ODI-SCH-012. Nominal calculations alone do not prove the 5 ms STOP requirement over tolerance and temperature. | Complete worst-case analysis, SPICE, exact-device selection, single-fault review, and prototype timing verification. |
| DFR-01-F04 | **Major** | Sheet 05 timing, partial-power, and external-driver compatibility are not proven. | Exact translators and logic are unselected; Ioff, powered-side-first behavior, minimum pulse, propagation, backfeed, thresholds, cable loading, ESD, and disabled/coast interpretation remain open in ODI-SCH-014. | Close ODI-SCH-014 with exact orderable parts, calculations, fault analysis, and representative-driver testing. |
| DFR-01-F05 | **Major** | The complete actuator-permission function does not yet exist and has no single-fault/timing analysis. | Sheet 06 is a placeholder. `WATCHDOG_VALID`, the fail-low conjunction of main-good/reset/STOP/watchdog, complementary inhibit generation, relay command gating, and output discharge are defined but not implemented. Readiness cannot be granted until the consumer interfaces are correct and the implementation entry contract is verified. | Do not implement high-current relay circuitry first. After F01 closure, implement and review the low-energy authorization/watchdog logic before enabling relay or motor outputs. |
| DFR-01-F06 | **Major** | Power-path quantitative validation is incomplete. | Exact TVS energy, reverse-FET SOA, eFuse thermal behavior, regulator stability/thermal margin, source-mux thresholds, source transitions, branch backfeed, load-switch discharge, and `MAIN_POWER_GOOD` timing remain release blockers. These affect brownout and authorization-removal ordering. | Complete exact-part/tolerance analysis and bench verification before schematic release and before claiming deterministic brownout behavior. |
| DFR-01-F07 | **Minor** | One open-design-item description retains the superseded shared eight-channel translator. | ODI-OUT-002 names `SN74LXC8T245`, while ADR-043 prohibits a shared eight-channel translator and Sheet 05 uses two four-channel branches. This can misdirect later verification. | Update the open-item wording in a documentation-control package after DFR-01; do not alter ADR-043. |
| DFR-01-F08 | **Minor** | Connector-boundary ESD and external unpowered-drive containment are provisions, not implemented protection. | Sheet 09 is a placeholder and exact clamps, returns, connector placement, and fixture behavior remain open. The current integrated design cannot yet be assessed for real ESD-current paths or cable-induced backfeed. | Close during Sheet 09 and PCB review; retain as a prerequisite to prototype release. |
| DFR-01-F09 | **Observation** | Hierarchical ownership and functional names are internally consistent. | Automated validation confirms matched unique root/child ports, exact ADR-043 motion exports, one producer/consumer for controlled cross-sheet interfaces, no rejected fault summary, and no raw GPIO names outside Sheet 03. | Preserve these interfaces. |
| DFR-01-F10 | **Observation** | The GPIO allocation is complete without duplicate use or application loading of reserved straps. | All 36 inventory rows validate; GPIO3/45/46 remain unused straps, GPIO37/42 remain reserved, native USB and UART0 recovery are preserved, and `MAIN_POWER_GOOD` is not assigned to firmware. | Preserve the allocation through Sheet 06. |

## Power Review

### Architecture and sequencing

The power architecture correctly separates:

- protected main input and `+5V_MAIN`;
- automatically selected `CORE_SOURCE`;
- USB-capable `+3V3_CORE`;
- main-only actuator, field-sense, and optional peripheral branches.

ADR-039 prevents firmware power requests from bypassing `MAIN_POWER_GOOD`. Each request has a hardware pulldown, and USB-only operation is intended to power only the core/service domain. This is a sound ownership model.

The design cannot yet be certified for source transitions or brownout. `MAIN_POWER_GOOD` depends on two preliminary power-good paths and exact timing has not been demonstrated against the STOP and motion disable budgets. Source mux, branch blocking, and partial-power behavior require exact-part analysis and testing. Loss of battery while USB remains connected is intended to retain the processor while removing every actuator-related branch; this remains a test requirement rather than verified behavior.

### Protection and ground

The 60 V eFuse/reverse-FET topology, TVS, source fuse requirement, and external motor-current boundary are appropriate at architecture level. Common logic ground is consistently declared; supervised loops have dedicated field returns, relay contacts are isolated, and motor current is excluded from the controller logic ground path.

Transient energy, MOSFET SOA, magnetic-filter behavior, connector current returns, and ESD discharge paths are not released. “Automotive compatible” remains limited to a protected nominal 12 V product supply and does not establish automotive transient compliance.

### Power-off, phantom power, and backfeed

The intended defaults are conservative:

- request pins are pulled low;
- main-only rails are disabled in USB-only operation;
- motor translator safe outputs are pulled low;
- field-valid gating forces command inputs inactive or conservative;
- the source mux is intended to prevent USB/main backfeed.

However, backfeed is not proven for every powered-side-first state, external driver, service fixture, comparator/logic input, or connector. F01 also breaks the intended Sheet 05 authorization chain independent of power sequencing.

## Processor Review

The ESP32-S3-WROOM-1-N8 allocation preserves GPIO0 recovery, native USB GPIO19/20, UART0 GPIO43/44, unused application straps GPIO3/45/46, and reserved GPIO37/42. No duplicate GPIO is present. Functional names prevent raw processor pins from leaking into downstream ownership.

The TPS3890-class supervisor and EN network provide the correct conceptual division between supply validity and processor firmware. `RESET_VALID` is the appropriate Sheet 06 export; removing `MAIN_POWER_GOOD` from firmware avoids a redundant and resource-consuming observation.

Release evidence remains incomplete for the exact supervisor threshold/suffix, CT timing, EN waveform, effective decoupling under radio transients, USB signal integrity/ESD, UART unpowered drive, antenna layout, and exact module pin audit. Unused straps and reserves are correctly no-connect at preliminary capture.

## Safety Review

The selected field standard is conservative:

- STOP and four limit loops are normally closed with remote EOL resistors;
- open wiring, contact opening, short-to-return, field-source loss, and invalid windows produce asserted/conservative states;
- ARM and FIRE are non-authorizing firmware requests and are inactive when unpowered;
- `STOP_HW_INHIBIT` is independent of firmware;
- firmware debounce cannot delay the STOP hardware path.

The architecture appropriately distinguishes global STOP from directional limits. A broken limit switch inhibits the associated direction through firmware but does not independently remove all actuator permit; this matches the accepted functional allocation and must not be represented as a safety-rated hardware interlock.

The safety claim remains unproven because exact comparator/gate parts, hysteresis, partial-power behavior, threshold tolerance, and passive fail-high STOP behavior are open. A single short between conductors or failure inside the comparator/gate network is not universally diagnosed. These limitations must be carried into the product hazard analysis.

## Motion Review

The eight-command architecture is internally consistent with the ESP32 allocation and J2/J3 destination contract. Two independent four-channel translation branches preserve the separately protected 5 V interface supplies. The Boolean suppression:

- `R_OK = RPWM AND NOT LPWM`
- `L_OK = LPWM AND NOT RPWM`

forces both PWM outputs low for simultaneous opposing requests. MCU-side and safe-side pulldowns provide useful reset and unpowered defaults, and firmware retains the 20 ms reversal dead interval.

The Critical authorization disconnect invalidates the present gating implementation. Even after repair, translator OE behavior, exact direction control, Ioff, propagation, minimum-pulse transfer, external driver thresholds, powered-off behavior, and disabled/coast response require proof. A failed translator or conflict-suppression gate can produce arbitrary command output; the current architecture is fail-safe for loss of authorization, not intrinsically single-fault tolerant to every logic-device failure.

## Interface Review

All controlled hierarchy ports have matching names and directions. Signal ownership is coherent:

- Sheet 01 owns input validity and protected power;
- Sheet 02 owns regulated rails and main qualification;
- Sheet 03 owns processor GPIO, reset validity, USB PHY endpoint, and recovery;
- Sheet 04 owns field safety interpretation and STOP hardware inhibit;
- Sheet 05 owns motion conditioning and translation;
- Sheet 06 owns the sole positive actuator authorization and relay gating;
- Sheet 09 owns physical connectors, entry protection placement, and test access.

No duplicate owner, missing top-level producer/consumer, rejected `OUTPUT_FAULT_SUMMARY`, or raw downstream GPIO name was found. The validator confirms hierarchy syntax, not pin-level electrical attachment; F01 is the concrete example of that limitation.

Polarity is consistent in the controlling documents:

- validity/permit signals are active high and fail low;
- `STOP_HW_INHIBIT` and `MASTER_INHIBIT` are active high and intended to fail high;
- motion commands and enables are active high with low safe defaults.

## Failure Analysis

| Failure | Intended response | Review disposition |
| --- | --- | --- |
| Processor crash | Independent watchdog expires; Sheet 06 removes permit; motion/relay inactive | Architecture sound; Sheet 06 implementation and watchdog independence unproven |
| Processor held in reset | `RESET_VALID` low; power requests pulled low; permit low | Sound after Sheet 06 implementation; reset timing remains open |
| Core brownout | Supervisor asserts reset; `RESET_VALID` low; permit removed | Intended safe; ordering and waveform verification open |
| USB-only operation | Core service available; main-only field, motor, relay, and peripheral branches off | Architecturally safe; no-backfeed testing open |
| Loss of battery | Main qualification and actuator branches collapse; USB may retain core | Intended safe; discharge and no-output-pulse testing open |
| Loss of `FIELD_SENSE_VCC` | STOP/limits conservative high; ARM/FIRE low; STOP inhibit high | Intended safe; partial-power/passive fail-high proof open |
| Relay contact welded/stuck | Coil removal cannot open a welded contact | Not fail-safe by controller alone; product must not assign safety function without independent contactor/feedback architecture |
| Field input short to return | Supervised STOP/limit channel asserts fault/conservative state | Sound within released dry-contact contract |
| Field input short to field source | High-window/open-equivalent conservative state | Sound within released field-source contract |
| Open or floating field input | STOP/limit conservative; ARM/FIRE inactive | Sound, subject to threshold proof |
| Translator failure | Output may be stuck low, high, or cross-coupled | Not universally fail-safe; external driver/product hazard controls required |
| Watchdog reset/recovery | Permit remains invalid until deliberate healthy servicing resumes | Sound concept; implementation and boot/update timing open |
| ESD event | Protection should clamp without unsafe output or damage | Not assessable until exact protection and layout exist |
| Connector unplugged | Supervised protective loops assert; motion logic outputs at controller remain low-biased | Conservative for safety loops; external driver unplug behavior must be validated |
| Broken limit switch/wire | Corresponding limit asserts and firmware inhibits hazardous direction | Conservative observation; not an independent global hardware inhibit |
| Both opposing PWM requests asserted | Both qualified PWM outputs low | Correct Boolean policy; exact logic timing unproven |
| F01 authorization labels disconnected | U3 inputs float/unconnected; outputs not tied to Sheet 06 policy | **Unsafe/indeterminate; Critical blocker** |

## Design Rule Review

### Satisfactory preliminary provisions

- Local decoupling and bulk-capacitance provisions exist on implemented active blocks.
- Series damping is present on USB and motion outputs.
- Hardware pulldowns establish inactive request and command defaults.
- Safety inputs use current limiting, filtering, window comparison, and ESD provisions.
- Power and logic-domain ownership supports bounded USB service.
- Service recovery paths and production test ownership are defined.

### Unclosed design-rule evidence

- exact effective capacitance and regulator stability;
- RC/reset timing across slow ramps and rapid cycling;
- exact logic thresholds over voltage and temperature;
- translator and logic partial-power/Ioff behavior;
- ESD device selection and physical current-return placement;
- EMC cable and harness assumptions;
- device dissipation, derating, and thermal rise;
- final environmental temperature/vibration/conformal-coating requirements;
- exact connector and fixture unpowered-drive behavior;
- released symbols, footprints, DFM, and native ERC.

## Risk Assessment

| Risk | Likelihood before closure | Consequence | Rating | Control |
| --- | --- | --- | --- | --- |
| Authorization not electrically reaching Sheet 05 gating | Certain in current capture | Motion output state not governed by sole permit contract | Critical | Correct F01 before Sheet 06 |
| Incorrect custom-symbol pin mapping or hidden unconnected node | Possible | Loss of protection, qualification, or safe default | Major | Vendor-symbol audit and ERC |
| STOP threshold/timing failure at tolerance or partial power | Possible | Delayed or absent actuator inhibit | Major | ODI-SCH-012 analysis and test |
| Main/USB transition or backfeed energizes a main-only path | Possible | Unexpected field or output activation/damage | Major | Exact-part analysis and transition testing |
| Translator powered-state or driver incompatibility | Possible | Backfeed or unintended motor command | Major | ODI-SCH-014 and representative-driver test |
| Welded relay contact treated as safely de-energized | Possible under abusive load | External load remains energized | Major/product-dependent | Load contract, external fuse, hazard analysis, optional monitored redundant switching |

## Strengths

- Clear single-sheet ownership prevents duplicate safety and output logic.
- Main validity is hardware qualified and independent of firmware.
- USB-only service is bounded away from actuator-related power.
- GPIO allocation preserves boot, recovery, and future reserves without duplication.
- STOP has an independent hardware path and conservative NC supervision.
- Motion commands have hardware conflict suppression and inactive defaults.
- Open design items and release blockers are generally explicit rather than concealed.

## Weaknesses

- Preliminary abstract symbols are being used for safety-relevant circuitry without native ERC.
- The present structural validator cannot detect pin-level connectivity errors.
- Quantitative power, STOP, partial-power, and external-driver evidence is incomplete.
- Sheet 06—the common authorization point—is not yet implemented or fault analyzed.
- Connectors and physical ESD current paths are absent, limiting integrated EMC and backfeed assessment.
- Relay-contact safe behavior is only de-energized-coil behavior; a welded contact is not controlled.

## Release Blockers

Sheet 06 entry is blocked until all of the following are complete:

1. Correct and independently review DFR-01-F01.
2. Add a pin-level electrical-connectivity check capable of detecting label-to-pin separation.
3. Run native KiCad ERC on Sheets 00–05 and disposition all results.
4. Audit exact custom-symbol pin names, numbers, directions, power pins, and multi-unit mappings.
5. Close the safety-critical portions of ODI-SCH-012 needed to trust `STOP_HW_INHIBIT`.
6. Close the authorization-facing portions of ODI-SCH-014 needed to trust Sheet 05 OE and partial-power behavior.
7. Freeze the Sheet 06 low-energy logic contract, watchdog behavior, reset/startup sequence, timing budget, and single-fault review before adding relay coil or high-current output circuitry.

The remaining power, connector, ESD, thermal, and compatibility items may be sequenced with later detailed implementation, but all remain blockers to schematic release and prototype energization.

## Recommended Improvements

- Extend repository validation from hierarchy-name checks to placed-pin connectivity checks.
- Separate Sheet 06 into a reviewable low-energy authorization/watchdog section and an output-drive section within the same ownership boundary.
- Create explicit timing budgets from field opening and power-invalid events through permit removal to each physical output.
- Add power-state and single-fault truth tables to the Sheet 06 implementation record.
- Update ODI-OUT-002 to reference the ADR-043 two-device translator architecture.
- Plan prototype instrumentation for `MAIN_INPUT_VALID`, `MAIN_POWER_GOOD`, `RESET_VALID`, `STOP_HW_INHIBIT`, `WATCHDOG_VALID`, `ACTUATOR_PERMIT`, `MASTER_INHIBIT`, both translator OEs, and every physical output.

## Readiness Assessment

The architecture does not presently require structural redesign. Its ownership and safe-state philosophy are suitable foundations for IPC-100. The implemented design, however, contains a Critical authorization-connectivity defect and lacks the electrical evidence necessary to trust the complete safety chain.

**Sheet 06 shall not be implemented until the Critical defect is corrected and the seven Sheet 06 entry blockers above are closed or formally dispositioned by a follow-up review.**

## Final Decision

# NOT APPROVED

Engineering justification: the current Sheet 05 capture does not electrically connect the two controlling authorization nets to its permit/inhibit qualifier, so actuator command gating cannot be shown to follow the accepted hardware safety contract. This Critical defect, combined with absent native ERC and unresolved safety-critical threshold, partial-power, and timing evidence, prevents approval to proceed into high-current output implementation.
