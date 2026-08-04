# EPR-01 — Engineering Prototype Release Strategy

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Release class | Engineering Prototype Baseline |
| Review date | 2026-08-03 |
| Repository baseline reviewed | `ef85719` (`Control external active evidence acquisition`) |
| Intended quantity | Limited, serialized engineering units only |
| Production authorization | None |

## Executive Summary

IPC-100 Rev A is approved as a controlled **Engineering Prototype Baseline**. The system architecture, hierarchy, interfaces, GPIO allocation, safety ownership, power requirements, and functional schematic are sufficiently mature to start the physical-design work whose purpose is to produce limited engineering prototypes. The repository contains no known unresolved polarity, interface-voltage, power-sequencing, authorization, watchdog, GPIO, hierarchy, or schematic-topology incompatibility.

This decision does **not** authorize a board order today. Three pre-fabrication gates remain: (1) exact prototype component and manufacturer pin-map disposition, including the power networks whose values depend on official regulator evidence; (2) reviewed land patterns and PCB constraints followed by native KiCad ERC/DRC; and (3) executable bring-up and safety acceptance limits. These are part of the Engineering Prototype implementation package, not reasons to require production AVL, pricing, alternates, certification, HALT, or long-term reliability evidence before learning from hardware.

The active-device evidence record contains no demonstrated selected-device failure. Missing WEBENCH exports, hot-board correlation, quotes, and prototype measurements are evidence gaps. They shall not be represented as complete, but commercial and production-qualification gaps do not make a carefully controlled prototype unsafe. Safety-related analytical gaps remain hard gates before fabrication or before the affected circuit is energized.

## Release Boundary

The released baseline is intended to validate electrical design, firmware, motion-control interfaces, hardware safety logic, watchdog behavior, user interface, communications, power architecture, thermal performance, enclosure integration, and the connector system.

It is not intended or authorized for production, field deployment, unattended operation, customer use, sale, pilot manufacturing, a Production PCB Release, or a Production Release. Prototype units shall be visibly marked **ENGINEERING PROTOTYPE — NOT FOR FIELD USE**, serialized, configuration controlled, and operated by qualified personnel under current-limited and fault-contained bench procedures.

## Current Design Maturity

| Area | Maturity | Engineering-prototype disposition |
| --- | --- | --- |
| Architecture and boundaries | Frozen | Released; changes require an ECO |
| Hierarchy and sheet ownership | Frozen and structurally validated | Released |
| GPIO and peripheral allocation | Frozen and regression checked | Released |
| Safety and authorization architecture | Hardware-priority, deterministic safe defaults captured | Released subject to ERC, exact-device review, and bench fault injection |
| Functional schematics | SSR-01R approved with Major observations | Released as the logical prototype baseline |
| Quantitative power requirements | QER-01/02/03 and PPQ-01/02 complete | Adequate for prototype part/layout closure |
| Exact components | Candidates exist for the current power-active set; most project rows are not fully frozen | Must be dispositioned for the assembled prototype variant |
| Footprints and PCB | Zero footprints; no PCB exists | Not yet released; this EPR authorizes a bounded prototype physical-design package |
| Firmware | Interface scaffolding/plans only | Prototype development and validation required |
| Mechanical/environment | Preliminary requirements; board/enclosure/access details open | Must constrain layout; qualification deferred |
| Manufacturing | Readiness structure exists; production package absent | Prototype assembly instructions required; production MFG release deferred |

## Completed Engineering Work

- Frozen product boundaries, architecture, sheet hierarchy, signal ownership, GPIO allocation, connector roles, and ADR/ICD interfaces.
- Completed ten-sheet functional schematic capture and SSR-01R revalidation.
- Corrected authorization connectivity and defaults, watchdog service routing, power-programming conflicts, branch-current limits, reset timing, J6/J7 isolation, USB-C boundary capture, and U101/U801 physical compatibility through controlled ECOs.
- Established deterministic safe defaults: loss of valid power, reset, watchdog, permit, or assertion of inhibit/STOP removes motion and relay authorization.
- Released QER-01, QER-02, and QER-03 quantitative envelopes; completed PEB-01, PPQ-01, and PPQ-02 package-independent analyses.
- Established a 9–21 V input envelope, bounded branch loads, thermal targets, timing windows, protection objectives, and provisional PCB thermal constraints.
- Normalized reference designators and synchronized controlled EBOM/AVL evidence records.
- Defined connector and harness interfaces, including separate STOP/UI boundaries, restricted DNP expansion, factory-only service access, and USB service ownership.
- Added repeatable hierarchy, GPIO, interface, ECO, BOM, and evidence validators.

## Mandatory Before an Engineering Prototype

The following requirements are mandatory before a fabrication package is released, because failure could make assembly unsafe, damage hardware, obscure the design under test, or invalidate a core result:

1. Freeze the exact **prototype-fit** population and DNP list. Each populated device needs an orderable code, verified symbol/pin map/polarity, electrical-rating check, and an approved manufacturer land pattern. Production alternates and volume pricing are not required.
2. Close the part-dependent power design: U201/U203 regulator operating solution and dependent passives; U101/Q101 protection and hot-pulse coordination; U202 transition assumptions; U801 threshold/leakage stack; C305 exact selection; and critical effective-capacitance, ripple, saturation, and hot-loss checks. An official tool export is preferred; a controlled manufacturer-equation calculation or documented engineering waiver with conservative bench limits is acceptable for the first prototype.
3. Carry the provisional Case-B thermal constraints into layout: four layers, 1 oz copper, continuous L2 ground, compatible L3 spreading, exposed-pad/via requirements, source separation, and the specified copper-spreading assumptions. Thermal performance remains a prototype measurement objective.
4. Resolve prototype connector, ESP32 module, peripheral-module, DFT target, board-envelope, mounting, antenna-keepout, and service-access choices sufficiently to place and assemble the board.
5. Run native KiCad ERC after exact symbols are installed; classify every result. Run PCB DRC and review netlist-to-layout, polarity, pin 1, high-current paths, creepage/clearance, RF, USB, and thermal constraints before fabrication.
6. Issue numeric prototype bring-up limits for rail resistance, current-limited energization, rail voltage/ripple, reset/watchdog timing, safe output state, STOP/inhibit behavior, and staged connection of external drivers. General production verification limits may remain open.
7. Complete an independent pre-fabrication peer review and release a revision-locked fabrication/assembly package for the serialized prototype build.

## Requirements Mandatory Only Before Production Release

These items remain required engineering work, but they do not gate a limited, controlled prototype unless a prototype-specific procurement or safety issue is discovered:

- complete AVL maturity, cross-manufacturer alternates, lifecycle strategy, approved substitution rules, volume pricing, contractual quotes, lead-time plans, and production procurement controls;
- production DFM/DFT, panelization, fiducials, paste/stencil optimization, automated inspection criteria, production test fixtures, programming flow, work instructions, process qualification, yield criteria, and supplier qualification;
- finalized conformal-coating, enclosure-production, harness-production, labeling, packaging, service, and repair processes;
- formal EMC, radio, ESD/immunity, environmental, vibration, shock, humidity, ingress, corrosion, UV, connector-cycle, HALT, operating-life, reliability, regulatory, and certification evidence;
- production statistical limits, traceability, calibration system, pilot build, process capability, change-control and quality records.

## Remaining Blockers and Risk Classification

The detailed EBOM, AVL, PAS, PACS, PPC/JCS routing, open-design-item, and qualification registers remain the row-level source of truth. This classification consolidates every remaining blocker by the consequence relevant to EPR-01; it does not silently promote any `BLOCKED` BOM row to production-approved.

### Category A — Prototype Safety Critical

| Blocker | Why it matters | Required disposition |
| --- | --- | --- |
| Native ERC not run | Hidden pin-type, unconnected, or library errors could make the fabricated circuit unsafe or nonrepresentative | Run and classify before fabrication |
| Exact prototype symbols, pin maps, polarity, footprints, and one-to-one physical decomposition incomplete across the design | A wrong package or composite abstraction can miswire hardware | Verify each populated row before its footprint is accepted |
| U201/U203 stability and dependent-passive solution lacks controlled tool/equation output | An unstable or incorrectly compensated supply can damage hardware and invalidate all testing | Close before fabrication; verify startup/load step before full load |
| Q101/U101 input-protection hot SOA and fault coordination incomplete | A surge/reverse/fault event could overheat or fail uncontrolled | Close analytically or constrain first article to protected bench sources; do not perform surge tests until reviewed |
| Critical capacitors/magnetics and transition reservoir are not exactly qualified | Effective capacitance, saturation, ripple, or transition failure can cause brownout or thermal damage | Select and calculate before footprint acceptance/fabrication |
| U801 high-corner margin and exact passive/leakage stack open | A marginal validity threshold can enable/disable the optional expansion rail incorrectly | Close stack before population; J10 remains DNP until verified |
| Exact safety-input, watchdog, reset, permit/inhibit, relay, and motion-interface device mapping plus numeric pre-test limits incomplete | Failure can defeat or obscure safe-state behavior | Review before fabrication; verify with no actuators/load connected first |
| Prototype connector/module and mechanical choices unresolved | Mis-keying, underrated contacts, inaccessible STOP/service points, or antenna/thermal conflict can invalidate the unit | Release prototype-specific choices and constraints before layout sign-off |

No Category A item identifies a known architectural incompatibility. Each is a controlled implementation or evidence gate. EPR approval permits the work needed to close it; it does not waive it.

### Category B — Prototype Functional

| Blocker | Prototype treatment |
| --- | --- |
| Regulator efficiency, load transient, startup, brownout, and source-transition behavior unmeasured | Instrumented bench validation objective |
| Enclosure thermal rise and package-to-board correlation unmeasured | Thermocouple/thermal-camera characterization over staged load and temperature |
| TPS2553 short/retry thermal behavior unmeasured | Current-limited fault test after normal-operation validation |
| U302 timing, U801 thresholds, I²C partial-power/stuck-bus behavior unmeasured | Bench sweep and fault-injection objective |
| Firmware drivers, recovery, command freshness, reversal interlock, diagnostics, and regression suite incomplete | Develop against serialized prototypes; retain hardware inhibit independent of firmware |
| Wi-Fi, Bluetooth, ESP-NOW, USB, UI, BME280, battery sensing, encoder, relay, and external-driver behavior unvalidated | Functional prototype test matrix |
| Mechanical fit, connector retention, service access, and antenna performance unknown | Fit-check and engineering enclosure trials |
| Broad Test Plan acceptance criteria remain `TBD` | Freeze critical bring-up/safety limits before energization; complete performance limits as measurements establish realistic margins |

These are the reason to build engineering prototypes. They are not production evidence and do not invalidate prototype testing when the unit configuration, equipment, conditions, and deviations are recorded.

### Category C — Production Readiness

- Full-project component freeze and canonical production EBOM/AVL approval.
- Authenticated two-distributor records, formal quotes, MOQ/lead-time/price breaks, alternates, lifecycle, counterfeit controls, and procurement refresh.
- Production connector/contact/tool order codes and harness process release.
- Final footprints/3D models for production, DFM/DFT, panelization, assembly drawings, stencil/paste rules, inspection criteria, test fixture, programming process, traceability, yield, and supplier controls.
- Final enclosure, coating, service, maintenance, repair, labeling, packaging, and manufacturing documentation.

### Category D — Production Validation

- EMC/radio/USB compliance, ESD/immunity, regulatory and certification testing.
- Formal temperature, humidity, vibration, shock, ingress, corrosion, UV, connector-cycle, HALT, operating-life, and reliability qualification.
- Pilot-production capability, process validation, statistical acceptance limits, field configuration, and long-term compatibility evidence.

## Fabrication Safety and Test Validity Assessment

Fabrication is not yet safe from the present files because no footprints or PCB exist and Category A implementation gates remain. Once those gates are closed, none of the remaining Category B–D items inherently prevents safe fabrication of a limited prototype.

Prototype testing remains valid if each unit has a controlled BOM/layout/firmware identity; bring-up begins without actuators or external loads; a current-limited and protected source is used; optional J10 is DNP; high-energy surge, short, relay-load, motion, and environmental tests are staged behind their specific hazard reviews; and failures are treated as design evidence rather than waived acceptance. Production qualification claims may not be inferred from prototype results.

## Prototype Objectives

1. Confirm rail startup, steady-state regulation, ripple, efficiency, source selection, brownout, recovery, inrush, and protection behavior.
2. Confirm reset, watchdog qualification, STOP, limit, permit/inhibit, relay, and motion-command safe-state priority independently of firmware commands.
3. Bring up ESP32 boot/recovery, native USB, UART fixture access, radio interfaces, I²C, UI, sensor, battery measurement, encoders, and external-driver logic.
4. Measure closed-enclosure component and board temperatures and correlate the provisional thermal model.
5. Validate connector pinout, keying, harness usability, test access, enclosure fit, antenna keepout, and service access.
6. Discover layout, component, firmware, mechanical, and test-limit changes for Rev B.

## Prototype Acceptance Criteria

A prototype unit is accepted for continued engineering use only when:

- assembly inspection, BOM identity, polarity, pin-1, shorts, and resistance-to-ground checks pass;
- every rail starts and remains within its released QER limit under the staged load, with no uncontrolled reset, oscillation, excessive ripple, or thermal runaway;
- reset release meets the QER-03 guarded 76–149 ms prototype window and brownout causes a fresh qualified restart;
- outputs remain inactive during power-off, reset, boot, invalid main power, watchdog loss, missing permit, asserted inhibit/STOP, and bounded USB-only service;
- opposing PWM commands cannot appear at the external interface, relay de-energized state is confirmed, and firmware cannot override hardware authorization;
- current-limit, source-transition, I²C isolation, partial-power, backfeed, and recovery tests meet the numeric limits released before execution;
- staged thermal testing shows no component exceeds the design target of 110 °C junction (100 °C measured target where correlation permits) at the defined prototype operating point;
- all deviations are logged, safety-significant failures quarantine the unit, and required schematic/layout changes are processed by ECO.

Passing these criteria qualifies the unit for engineering evaluation only; it does not constitute product verification or production acceptance.

## Prototype Test Matrix

| Stage | Coverage | Required evidence | Gate to continue |
| --- | --- | --- | --- |
| 0 — Design release | Exact prototype BOM, symbols/pin maps, footprints, ERC/DRC, constraints | Peer-reviewed release checklist and reports | Fabrication package approved |
| 1 — Unpowered inspection | Assembly, polarity, joints, isolation, net resistance | Photos, inspection record, resistance log | No unexplained short/open |
| 2 — Limited-power bring-up | Input path and rails, current draw, reset, default outputs | Oscilloscope/current logs | Stable rails; safe outputs; no abnormal heating |
| 3 — Core/function | Boot/recovery, USB/UART, radio, I²C, UI, sensor, ADC, encoders | Firmware revision and functional logs | Repeatable operation/recovery |
| 4 — Safety logic | STOP/limits, watchdog loss, reset/brownout, permit/inhibit, conflicting commands | Timing waveforms and fault log | Hardware priority and inactive outputs proven |
| 5 — Power performance | Min/nominal/max input, loads, ripple, efficiency, source transition, inrush | Calibrated waveforms/tables | QER limits met or deviation/ECO raised |
| 6 — Controlled faults | Reverse polarity, branch short/retry, disconnect, backfeed, stuck bus, external-interface faults | Hazard review, waveforms, temperatures | Containment without unsafe energization |
| 7 — Thermal/mechanical | Closed-enclosure staged load/temperature, fit, retention, access, antenna trial | Thermal map and fit report | Rev B constraints established |
| 8 — Regression | Re-run critical power/safety/interfaces after firmware or ECO changes | Versioned regression report | No unresolved safety regression |

## Recommended Next Packages

The smallest package required to begin footprint assignment is:

### EPP-01 — Engineering Prototype Physical-Design Entry Package

EPP-01 shall select the prototype-fit population, verify manufacturer pin maps and exact order codes, bind each populated row to a reviewed land pattern, carry the Case-B thermal and mechanical constraints into a footprint/constraint register, define DNPs, and close only the Category A calculations needed before those footprints are accepted. It may use the existing candidate MPNs and may defer production alternates, full price matrices, formal qualification, and production work instructions. Any functional, polarity, safety, value, or interface change requires an ECO.

Recommended sequence after EPP-01:

1. **EPR-PCB-01 — Prototype PCB Layout:** placement/routing, RF/USB/power/thermal constraints, test access, native ERC and DRC closure.
2. **EPR-ASM-01 — Prototype Assembly Release:** fabrication outputs, prototype BOM, controlled substitutions, assembly notes, inspection and bring-up limits.
3. **EPR-BV-01 — Bench Validation:** staged unpowered and limited-power bring-up.
4. **EPR-EV-01 — Electrical and Safety Validation:** QER performance, watchdog, authorization, fault injection, interfaces, and motion/relay safe states.
5. **EPR-FV-01 — Firmware Validation:** drivers, recovery, diagnostics, command freshness, regression.
6. **EPR-ENV-01 — Engineering Environmental Validation:** thermal/mechanical/enclosure characterization, not certification.
7. **Rev B ECO Package:** disposition prototype findings and repeat affected validation.
8. **Production Release Program:** complete Category C and D evidence under separate authorization.

Engineering roadmap:

`Engineering Prototype Baseline → Prototype PCB Layout → Prototype Assembly → Bench Validation → Electrical Validation → Firmware Validation → Environmental Validation → Rev B Updates → Production Release`

## Risk Register

| ID | Category | Risk | Present evidence | Control / exit | Prototype release effect |
| --- | --- | --- | --- | --- | --- |
| EPR-R01 | A | Hidden schematic/library error | Structural validators pass; native ERC absent | Native ERC and classified review | Blocks fabrication, not EPP-01 |
| EPR-R02 | A | Wrong physical mapping or provisional composite implementation | Zero footprints prevent accidental release | Exact symbol/pin/land-pattern review per populated row | Blocks affected footprint/fabrication |
| EPR-R03 | A | Regulator instability or incorrect dependent passives | QER/PPQ envelopes exist; tool exports absent | Controlled tool/equation solution and bench limits | Blocks fabrication until closed |
| EPR-R04 | A | Input protection or hot fault overstress | No selected-device failure; hot SOA correlation absent | Analytical constraint plus staged protected testing | Blocks high-energy testing; close for fabrication basis |
| EPR-R05 | A | Marginal supervisor/authorization behavior | Topology corrected; U801 has narrow worst-case margin | Exact stack and sweep; keep optional branch DNP initially | Blocks affected population |
| EPR-R06 | B | Thermal model differs from real board/enclosure | Conservative provisional Case B exists | Layout constraints and instrumented thermal test | Primary prototype objective |
| EPR-R07 | B | Firmware or interface behavior incomplete | Contracts are frozen; implementation evidence limited | Hardware-first bring-up and regression | Primary prototype objective |
| EPR-R08 | B | Mechanical/connector incompatibility | Logical contracts mature; physical choices incomplete | Prototype-specific mechanical/connector release | Blocks layout sign-off where affected |
| EPR-R09 | C | Single-source, unavailable, or expensive parts | Commercial matrix incomplete | Refresh procurement evidence for prototype; full AVL before production | Does not block baseline approval |
| EPR-R10 | C | Assembly/test process not repeatable at scale | Manufacturing package not released | Production DFM/DFT and pilot process | Deferred |
| EPR-R11 | D | EMC/environment/reliability failure | No formal qualification evidence | Rev B correction and formal qualification | Deferred; no field use |
| EPR-R12 | B/C | Prototype evidence misrepresented as production evidence | Release boundary explicit | Serialized units, controlled reports, separate Production Release | Controlled by configuration management |

## Validation Summary

Repository validation for EPR-01 shall include all existing `validate_*.ps1` scripts, `git diff --check`, and a scope check of the EPR change. Structural validation is valuable but is not native KiCad ERC or PCB DRC. Native ERC remains a Category A pre-fabrication gate.

EPR-01 changes documentation only. It makes no schematic modification, assigns no footprint, creates no PCB, changes no architecture or GPIO allocation, and changes no hierarchy. The repository remains in the intentional zero-footprint/no-PCB state after this decision.

## Deferred Production Activities

All Category C and Category D work is deferred to Rev B and the Production Release program. Prototype measurements may inform those activities but do not close them automatically. Production procurement, production PCB release, pilot build, field deployment, and customer use remain explicitly unauthorized.

## Final Recommendation

The absence of production sourcing, manufacturer-tool exports, final thermal correlation, full AVL maturity, and formal qualification does not by itself justify withholding a controlled engineering prototype baseline. The logical design has no known unresolved electrical incompatibility, while the remaining safety-relevant physical implementation work is explicit, bounded, and enforceable before fabrication. Limited prototypes are the appropriate means to obtain the waveform, fault, firmware, thermal, mechanical, and connector evidence that cannot exist beforehand.

# ENGINEERING PROTOTYPE RELEASE APPROVED

Authorize **EPP-01 — Engineering Prototype Physical-Design Entry Package** as the smallest next package for prototype-only component/footprint assignment. Do not fabricate until EPP-01 and EPR-PCB-01 pre-fabrication gates pass.

**PRODUCTION RELEASE NOT AUTHORIZED.**

**PRODUCTION PCB RELEASE NOT AUTHORIZED.**

> **EPP-01A Category A update (2026-08-03):** Composite functional references on Sheets 04–07 require ECO-011 one-to-one physical decomposition before footprint assignment. This is an open pre-fabrication Category A gate and does not revoke the bounded Engineering Prototype Baseline approval.

> **ECO-011 update:** The physical decomposition could not begin safely because exact device, truth/state-table, package-unit and pin-mapping inputs are absent. ECO-011A is now the controlling Category A prerequisite.
