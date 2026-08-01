# IPC-100 Revision History

## 2026-08-01 — PACS-01R

Revalidated the complete 20-reference power-active inventory following ECO-010. The U101 TPS26631PWPR and U801 TPS3899DL01DSER implementation incompatibilities are closed, but no active device is frozen because package-specific thermal/tool evidence, 17 dependent passive closures, U801 corner testing, complete alternate strategy, and current commercial evidence remain incomplete. PACS-01R is not accepted; PACS-01R-A is the smallest corrective evidence package. PPC-01 and CSR-01A-R5 remain unauthorized.

## 2026-07-31 — ECO-010

Remediated the two PACS-01 schematic-to-market incompatibilities. U101 now uses the orderable TPS26631PWPR with its verified 20-pin PWP map; U801 now uses TPS3899DL01DSER with explicit threshold, feedback, pull-up and delay support. No architecture, interface, footprint or PCB change. PACS-01R authorized.

## 2026-07-31 — PACS-01

Audited 20 power-active references against current manufacturer and distributor evidence. Recorded 18 exact production candidates but froze none: U101 has a non-orderable captured TPS26630/PWP combination and U801's required TLV841S 2.7 V/10 ms/push-pull-high combination is not listed as a production OPN. Synchronized blocked candidate traceability in EBOM/AVL without CAD or footprint changes. PACS-01 is not accepted; PPC-01 and CSR-01A-R5 remain unauthorized.

## 2026-07-31 — ECO-009R

Verified the existing C305 93.1 nF ±1% C0G/NP0 implementation against QER-03. Recalculation confirmed 99.642 ms nominal and 79.1–136.6 ms endpoints, with 4.1/13.4 ms design margins and 3.1/12.4 ms guarded margins. Synchronized generic EBOM/AVL requirements without changing the schematic or selecting parts. ECO-009R is complete and PACS-01 is authorized; CSR-01A-R5 remains unauthorized.

## 2026-07-31 — QER-03

Released the U302/C305 reset-release timing contract: positive SENSE crossing is the reference event, 100 ms is the exact nominal target, 75–150 ms are design limits, and 76–149 ms is the guarded prototype window. Accepted ECO-009's 79.1–136.6 ms estimate and authorized ECO-009R without changing hardware or selecting parts.

## 2026-07-31 — ECO-009

Corrected Sheet 03 C305 from 10 nF to a package-independent 93.1 nF ±1% C0G/NP0 timing class for 99.642 ms nominal TPS3890-Q1 reset release. Calculated a 79.1–136.6 ms device/capacitor envelope and retained an incomplete decision because no accepted timing window exists. No topology, footprint or PCB change was made.

## 2026-07-31 — PAS-01R / Package 11A-P-R

Dispositioned all 18 residual passives: 17 require named PACS-01 active selections and C305 requires a timing ECO because TI's TPS3890-Q1 equation yields approximately 10.7 ms from the captured 10 nF rather than the released 100 ms target. Synchronized EBOM/AVL blockers without changing schematics or footprints. PAS-01R remains incomplete.

## 2026-07-31 — PAS-01 / Package 11A-P

Audited the corrected 85-reference blocked passive scope. Recorded 67 exact preferred MPNs as freeze eligible and retained 18 evidence-bound rows as blocked. Corrected PPQ-02 routing to 18 PPC-01, 85 PAS-01, 20 PACS-01 and one JCS-01 row. PAS-01 remains incomplete; no footprint or CAD artifact changed.

## 2026-07-31 — PPQ-02

Completed operating-state, regulator, thermal, magnetics, capacitor, switch, protection-energy, threshold/timing, shared-rail, PCB-constraint and single-fault models. The PAS-01 class audit corrected routing to 18 PPC-01, 85 passive PAS-01, 20 active PACS-01 and one JCS-01 row; the earlier 19/104/1 aggregation is superseded.

## 2026-07-31 — CSR-01A-R4

Reconciled all 133 power rows after ECO-008R. Preserved nine frozen resistors, retained 124 evidence-specific blockers, verified the three 141 kΩ TPS2553 networks, and did not accept the power freeze. Defined PPQ-02, JCS-01, PPC-01, and PAS-01 as the remaining targeted evidence packages; CSR-01B remains unauthorized.

## 2026-07-31 — ECO-008R

Implemented QER-02 on the three independent TPS2553-Q1 channels using generic 141 kΩ ±1%, ≤100 ppm/°C RILIM values. Worst-case 162.82–222.35 mA satisfies the 160–225 mA threshold band. Updated controlled BOM/AVL data without freezing MPNs or assigning footprints and authorized CSR-01A-R4.

## 2026-07-31 — QER-02

Accepted a controlled amendment for the three TPS2553-Q1 branches. Preserved 100 mA continuous and 150 mA/10 ms loads, defined repetition, established a 160–225 mA worst-case fault-threshold band, proved a positive tolerance-aware feasibility window, and authorized ECO-008R only. No hardware or component-selection artifact changed.

## 2026-07-31 — ECO-008

Evaluated the three TPS2553-Q1 branch-limit networks. The legal RILIM window is empty: ±1% nominal resistance must be ≥213.358 kΩ to guarantee the ceiling yet ≤153.622 kΩ to guarantee the required peak. No schematic change was made; ECO-008 is incomplete pending QER-02.

## 2026-07-31 — PPQ-01

Released analytical power-performance qualification and four supporting models plus a 124-row evidence register. Fifty references are forecast freeze-eligible; six TPS2553/RILIM rows failed the QER branch-limit screen and require ECO-008. No design or component-selection change was made.

## 2026-07-31 — PEB-01

Created the package-independent power evidence baseline and five controlled appendices. Quantified load, loss, thermal, magnetic, capacitor, MOSFET, protection and derating envelopes; mapped all 124 blocked references to generated and remaining evidence; and deferred CSR-01A-R4 until PPQ-01 and JCS-01 close the remaining selection prerequisites.

## 2026-07-31 — DRA-01

Diagnosed the CSR-01A-R3 failure without changing the design. Collapsed 124 blocked power rows into four mutually exclusive root causes, documented the dependency graph and maturity matrix, and recommended PEB-01 as the next corrective evidence package.

## 2026-07-31 — CSR-01A-R3

Reviewed the post-ECO-007 final power freeze. All 133 power rows were dispositioned (9 frozen, 124 blocked); the package was not accepted because exact electrical, thermal, transient, connector, lifecycle, sourcing, alternate, and cost evidence remains incomplete. CSR-01B remains unauthorized.

## 2026-07-31 — ECO-007

Corrected U201/R201 frequency programming, all TPS2553-Q1 current-limit programming networks, and U801's physical threshold/hysteresis implementation. Added C804, R806, and R808, retained zero footprints, and authorized CSR-01A-R3 only.

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Revision History |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-30 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Revision identity

IPC-100 begins at hardware Rev A. Prior CrossWind controller concepts are predecessor work only; they do not make IPC-100 Rev D or transfer any earlier product revision number to this platform.

Rev A is currently in architecture and requirements definition. No prototype build, production candidate, or released hardware is claimed.

ECO-004 corrected the two SSR-01 interface findings by adding independently rail-qualified, fail-isolated J6/J7 I²C branches and completing the protected J13 USB-C UFP boundary. Exact components, native ERC, footprints, SI/EMC, quantitative release analysis, and prototype verification remain open; Package 11 is not authorized.

SSR-01R revalidated the complete post-ECO-004 Sheet 00–09 baseline and approved schematic release with Major observations. Package 11 Component Selection & Footprint Assignment is authorized under per-part pin/rating/land-pattern controls. Native ERC, exact-component, quantitative, connector, SI/EMC, DFM/DFT, and prototype gates remain open; PCB placement and routing are not authorized.

CSR-01 / Package 11A inventoried 301 physical/logical schematic items but did not accept the component freeze. Composite functional blocks, 63 repeated local reference names, open quantitative/load/environment contracts, and unresolved modules/connectors prevent a complete MPN, AVL, derating, and cost release. Package 11B is not authorized.

ECO-005 normalized all non-connector component references into deterministic Sheet 01–09 ranges, preserved the frozen connector/DFT designations, and reduced the global duplicate count from 63 repeated names to zero without changing UUIDs, nets, hierarchy, GPIOs, symbols, values, footprints, or PCB data. CSR-01A Power Component Selection is authorized; footprint assignment remains unauthorized.

CSR-01A reviewed 124 power-related rows across Sheets 01, 02, 03, 07, 08, and 09 and marked the remaining 177 rows `NOT YET FROZEN`. No power MPN was frozen because source transient/fault limits, exact rail loads, simultaneous loading, thermal constraints, regulator passives/stability, source-transition timing, J1 requirements, and exact-order-code sourcing evidence remain incomplete. CSR-01A was not accepted and CSR-01B is not authorized.

QER-01 released a controlling quantitative envelope for the Rev A operating environment, input and rail limits, complete load allocations, transient/protection performance, passive and connector capability, signal integrity, thermal/voltage/current derating, and measurable design targets. Remaining entries are implementation-verification tasks rather than undefined electrical requirements. QER-01 was accepted and CSR-01A-R Power Component Selection (Reattempt) is authorized; no MPN, footprint, schematic, or PCB change was made.

CSR-01A-R reconciled all 124 power-scope rows against QER-01. Nine Sheet 02/08 low-voltage 100 kΩ bias/enable resistors were frozen to Panasonic `ERJ-3EKF1003V` with an electrically approved Vishay alternate, derating, lifecycle, sourcing, and price evidence. The other 115 rows remain blocked; four 50 V capacitors and one 60 V MOSFET conflict with QER derating, three entries remain composite physical functions, and J1 requires a mechanical-interface release. CSR-01A-R was not accepted; CSR-01B remains unauthorized pending ECO-006 and J1 release.

ECO-006 corrected the four input-capacitor voltage classes and Q101 transient margin, narrowed U706/U707 to one physical enabled dual-supply I2C buffer each, narrowed U801 to the physical supervisor function separate from U802, added R704/R705 deterministic enable bias, and documented regulator/passive/transient calculations sufficient for CSR-01A-R2 candidate selection. CSR-01A-R remains not accepted, J1 mechanics and native ERC remain open, and CSR-01B/footprints/PCB work remain unauthorized.

MIR-01 released J1 as an enclosure-protected, board-mounted, right-angle, positively latched two-contact P1 interface with a replaceable 18 AWG H01 crimp harness. It froze electrical/mechanical ratings, physical envelope, keying, retention, mating life, environmental qualification, strain relief, labeling, manufacturing inspection, failure controls, and future-footprint constraints without selecting a family or footprint. CSR-01A-R2 Power Component Selection Final Pass is authorized; CSR-01B and PCB work remain unauthorized.

CSR-01A-R2 dispositioned all 130 power-scope rows: nine previously frozen 100 kΩ bias resistors remain frozen and 121 rows remain blocked. Exact manufacturer review found that R201 does not implement U201's released 400 kHz target, R222/R223/R224 exceed TPS2553-Q1's supported RILIM range, and no reviewed U801 implementation satisfies the complete frozen threshold/hysteresis/delay contract without added circuitry. CSR-01A-R2 was not accepted; CSR-01B remains unauthorized pending a narrow corrective ECO and final re-review.

## 2. Version types

| Version type | Meaning | Example | Controlled independently |
| --- | --- | --- | --- |
| Hardware revision | Manufactured electrical/mechanical board baseline | Rev A | Yes |
| Prototype build | Iteration within an unreleased hardware revision | A0, A1, A2 | Yes |
| Production candidate | Candidate configuration submitted for release verification | A-RC1 | Yes |
| Documentation revision | Revision/date of a controlled document | Document-specific | Yes |
| Firmware version | Software release compatible with defined hardware | Semantic/version policy TBD | Yes |

The same letter or number appearing in different version types does not imply equivalence.

## 3. Suggested Rev A progression

```text
IPC-100 Rev A
Prototype build: A0, A1, A2
Production candidate: A-RC1
Released production: Rev A
```

This is a naming format only. IPC-100 has not reached any listed build or release stage.

## 4. When hardware revision increments

A new hardware revision is normally required when an approved change alters:

- PCB copper, stack-up, drill, outline, or assembly population
- Connector pinout, mating compatibility, or electrical ratings
- Form, fit, function, safety, or regulatory behavior
- Power architecture or externally observable electrical behavior
- Component substitution that changes validated performance or layout
- Mounting interface or service compatibility
- Manufacturing or test requirements that affect the physical design

The engineering change process shall determine whether a prototype iteration or new revision is appropriate before fabrication data is released.

## 5. Documentation-only changes

The following may remain within a hardware revision when they do not alter the manufactured design:

- Typographical and formatting corrections
- Clarification consistent with the released design
- Added traceability, test evidence, or links
- Corrected diagrams that do not change connectivity
- Process guidance that does not change form, fit, function, or safety

Documentation-only changes still require document revision control and review. A documentation edit must not silently redefine a released interface.

## 6. Hardware revision record

| Hardware revision | Prototype/build | Date | Status | Summary | Approval |
| --- | --- | --- | --- | --- | --- |
| Rev A | Not assigned | TBD | Architecture and requirements definition | Initial reusable IPC-100 platform | Pending |

## 7. Documentation record

| Date | Document set | Change summary | Owner | Review status |
| --- | --- | --- | --- | --- |
| 2026-07-28 | Repository baseline | Created initial engineering repository | Iron Pine Outdoors Engineering | Historical |
| 2026-07-28 | Platform boundary | Separated IPC-100 from product-specific CrossWind development | Iron Pine Outdoors Engineering | Historical |
| 2026-07-28 | Rev A Engineering Blueprint | Defined architecture, requirements, connectors, GPIO planning, power, wiring, mechanics, revision policy, and ADRs | Iron Pine Outdoors Engineering | Pending approval |
| 2026-07-29 | Expansion and connector architecture review | Defined controlled expansion requirements, connector risks, accumulated consistency corrections, ADRs, and the open-design-items register | Iron Pine Outdoors Engineering | Pending approval |
| 2026-07-30 | Package 05 Sheet 04 entry-gate review | Paused before capture because authoritative voltage/cable/timing contracts conflict, ARM/FIRE power ownership is unsynchronized, and diagnostic fault-net consumers remain open; recorded ODI-SCH-011 and required AR-04 | Iron Pine Outdoors Engineering | Blocked pending architecture resolution |
| 2026-07-30 | AR-04 External Safety Interface Contract | Accepted ADR-042 and the controlling Sheets 04–06 ICD; froze field/contact standards, ownership, polarity, diagnostics, timing, and permit behavior; closed ODI-SCH-011 and authorized Package 05R | Iron Pine Outdoors Engineering | Accepted |
| 2026-07-30 | Package 05R Sheet 04 preliminary capture | Implemented the ADR-042 supervised STOP/limit subsystem, protected ARM/FIRE conditioning, local diagnostics, and STOP hardware-inhibit export without connectors or footprints | Iron Pine Outdoors Engineering | Pending peer review and ERC |
| 2026-07-30 | Package 06 Sheet 05 entry-gate review | Paused before capture because requested PAN/TILT, position/feedback, direct STOP, and Sheet 06 motor-command boundaries conflict with the frozen eight-channel Sheet 03-to-05-to-09 contract; recorded ODI-SCH-013 and required AR-05 | Iron Pine Outdoors Engineering | Blocked pending contract alignment |
| 2026-07-30 | AR-05 Rev A motion-interface alignment | Accepted ADR-043 and the Motion Control ICD; preserved eight GPIO commands, froze Sheet 03/05/06/09 ownership, selected opposing-PWM hardware suppression, removed `OUTPUT_FAULT_SUMMARY`, closed ODI-SCH-013, and authorized Package 06R | Iron Pine Outdoors Engineering | Accepted |
| 2026-07-29 | Rev A schematic-readiness gate | Audited requirements and resources, created architecture traceability, classified schematic blockers, and recorded that Rev A is not ready for controlled schematic capture | Iron Pine Outdoors Engineering | Gate review complete |
| 2026-07-29 | Processor selection study | Compared ESP32 module candidates, recommended ESP32-S3-WROOM-1 and native USB Serial/JTAG, and retained exact-variant, GPIO, memory, ADC, boot, RF, and procurement gates | Iron Pine Outdoors Engineering | Engineering recommendation |
| 2026-07-29 | GPIO and peripheral allocation review | Assigned all 27 required non-USB signals, allocated MCPWM/ADC1/I2C/native USB/UART recovery, documented module restrictions and J11 conflict, and retained exact-variant release gate | Iron Pine Outdoors Engineering | Allocation review complete; release blocked |
| 2026-07-29 | Schematic hierarchy and block interfaces | Defined ten-sheet KiCad hierarchy, block/rail/signal/connector ownership, master-inhibit partition, test strategy, capture sequence, and review gates without selecting components | Iron Pine Outdoors Engineering | Implementation plan complete; hierarchy approval pending |
| 2026-07-29 | Power architecture engineering review | Defined power ownership, domains, states, source interaction, sequencing, protection/failure philosophy, bounded USB-only service, expansion policy, and remaining quantitative schematic blockers | Iron Pine Outdoors Engineering | Architecture review complete |
| 2026-07-29 | Safety input electrical architecture review | Classified all inputs; selected supervised NC STOP/limit loops, sequenced NO ARM/FIRE commands, non-safety encoder behavior, dedicated safety-loop returns, and remaining quantitative/connector gates | Iron Pine Outdoors Engineering | Architecture review complete |
| 2026-07-29 | Output electrical architecture review | Classified all outputs; selected common hardware master inhibit, disabled/coast motor safe state, relay de-energized state, status/peripheral defaults, sequencing, fault ownership, and remaining quantitative gates | Iron Pine Outdoors Engineering | Architecture review complete |
| 2026-07-29 | Critical component selection and electrical quantification | Selected preliminary-capture circuit topologies, preferred components, values, calculations, margins, test access, and retained schematic-release blockers | Iron Pine Outdoors Engineering | Preliminary capture basis; engineering review required |
| 2026-07-29 | Preliminary KiCad Capture Package 01 | Created the KiCad project, Sheet 00 root hierarchy, named cross-sheet interfaces, and empty Sheets 01–09 without circuitry or footprints | Iron Pine Outdoors Engineering | CAD hierarchy implemented; validation and Gate 1 review required |

| 2026-07-29 | Preliminary KiCad Capture Package 02 | Implemented Sheet 01 battery and USB protected-power paths, input protection and filtering, battery sensing, and power status without footprints or downstream regulation | Iron Pine Outdoors Engineering | Preliminary functional capture; detailed release blockers retained |

| 2026-07-29 | Preliminary KiCad Capture Package 03 entry-gate review | Stopped before Sheet 02 modification because the frozen hierarchy lacks required controlled-branch enable requests and an upstream main-valid qualifier | Iron Pine Outdoors Engineering | Blocked pending architecture/interface decision |

| 2026-07-29 | Power-Control Interface Resolution AR-01 | Accepted ADR-039; defined rail states, main-source qualification, branch requests, voltage domains, and synchronized Sheets 00–03 | Iron Pine Outdoors Engineering | ODI-SCH-007 closed; Package 03R authorized |

| 2026-07-29 | Preliminary KiCad Capture Package 03R | Implemented Sheet 02 main/core regulators, source mux, power-good logic, request qualification, and main-only/protected branches | Iron Pine Outdoors Engineering | Preliminary functional capture; peer review and release blockers retained |

| 2026-07-29 | Preliminary KiCad Capture Package 04 entry-gate review | Stopped before Sheet 03 modification because four ADR-039 request outputs lack approved GPIOs and requested power-status/USB ownership conflicts with the frozen hierarchy | Iron Pine Outdoors Engineering | Blocked pending GPIO and cross-sheet interface amendment |

| 2026-07-29 | Architecture Resolution Package AR-02 | Accepted ADR-040; moved five low-risk UI functions behind Sheet 07 I²C, assigned four power-request GPIOs, fixed status/USB ownership, and reserved GPIO37/42 for mutually exclusive future communications | Iron Pine Outdoors Engineering | ODI-SCH-008 closed; Package 04R authorized |

| 2026-07-29 | Preliminary KiCad Capture Package 04R implementation review | Stopped before Sheet 03 modification because retained `MAIN_POWER_GOOD` has no GPIO or approved local consumer in the fully allocated ADR-040 map | Iron Pine Outdoors Engineering | Blocked pending narrow status-input disposition |

| 2026-07-29 | Architecture Resolution Package AR-03 | Accepted ADR-041; removed `MAIN_POWER_GOOD` from the processor interface while preserving Sheet 02 hardware gating, Sheet 06 authorization, GPIO reserves, and USB-only recovery | Iron Pine Outdoors Engineering | ODI-SCH-010 closed; Package 04R authorized |

| 2026-07-29 | Preliminary KiCad Capture Package 04R | Implemented Sheet 03 ESP32-S3-WROOM-1-N8 core, reset supervision, boot controls, MCU-side USB, UART0 recovery, and ADR-040 GPIO fanout | Iron Pine Outdoors Engineering | Preliminary functional capture; native ERC, peer review, and release blockers retained |

| 2026-07-30 | Preliminary KiCad Capture Package 06R | Implemented Sheet 05 dual-axis command conditioning, hardware opposing-PWM suppression, fail-low authorization, independent logic translation, safe defaults, damping, and ESD provisions | Iron Pine Outdoors Engineering | Preliminary functional capture; ODI-SCH-014 and native ERC remain open |

| 2026-07-30 | DFR-01 Functional Electrical Design Review | Reviewed implemented Sheets 00–05 as an integrated system; identified a Critical Sheet 05 authorization-input connectivity defect and unresolved safety-critical evidence gaps | Iron Pine Outdoors Engineering | NOT APPROVED; Sheet 06 entry blocked pending defect correction and review closure |

| 2026-07-30 | ECO-001 Authorization Connectivity Correction | Attached Sheet 05 `ACTUATOR_PERMIT` and `MASTER_INHIBIT` labels to the intended U3 pins and added pin-level regression checks without changing architecture | Iron Pine Outdoors Engineering | Corrected; pending native ERC confirmation and DFR-01 reissue |

| 2026-07-30 | DFR-01R Functional Electrical Design Review Reissue | Verified ECO-001 and dispositioned DFR-01-F01 closed pending native ERC; identified missing deterministic local defaults on U3 authorization inputs | Iron Pine Outdoors Engineering | NOT APPROVED; Package 07 remains blocked by DFR-01R-F11 |

| 2026-07-30 | ECO-002 Deterministic Authorization Input Bias | Added 100 kΩ fail-low `ACTUATOR_PERMIT` and fail-high `MASTER_INHIBIT` local biases on Sheet 05 without changing architecture or ownership | Iron Pine Outdoors Engineering | Major finding corrected; pending verification and DFR reissue |

| 2026-07-30 | ECV-001 ECO-002 Verification | Verified deterministic authorization input states, failure defaults, architecture preservation, and repository regressions | Iron Pine Outdoors Engineering | VERIFIED; Package 07 / Sheet 06 authorized for preliminary capture |

| 2026-07-30 | Package 07 Sheet 06 entry-gate review | Stopped before Sheet 06 modification because the frozen hierarchy and GPIO allocation contain no firmware watchdog-service route required to generate `WATCHDOG_VALID` | Iron Pine Outdoors Engineering | Blocked pending narrow architecture/interface resolution |
| 2026-07-30 | AR-06 / ADR-044 | Assigned GPIO42 to `WATCHDOG_SERVICE_MCU`; froze transition timing, startup, timeout, recovery, ownership, and authorization behavior; synchronized Sheet 03/00/06 interfaces | Iron Pine Outdoors Engineering | Accepted; ODI-SCH-017 closed; Package 07R authorized |
| 2026-07-30 | Package 07R Sheet 06 preliminary capture | Implemented the independent watchdog/qualifier, hardware authorization, deterministic defaults, relay gate, low-side MOSFET driver, flyback clamp, and provisional relay | Iron Pine Outdoors Engineering | Preliminary capture complete; native ERC and exact-part/tolerance release checks pending |
| 2026-07-30 | MFG-01 Manufacturing Readiness Review | Reviewed manufacturability, DFT, serviceability, connectors, layout implications, assembly, sourcing, and Rev A residual risks through Package 07R | Iron Pine Outdoors Engineering | Ready with major manufacturing observations; Package 08 / Sheet 07 authorized; PCB placement remains unauthorized |
| 2026-07-30 | Package 08 Sheet 07 preliminary capture | Implemented encoder conditioning, core-powered I²C expander, RGB/buzzer output drivers, fail-asserted OLED reset, OLED/sensor functional boundaries, pull-up ownership, and schematic DFT nodes | Iron Pine Outdoors Engineering | Preliminary capture complete; exact modules/loads, connector ESD, native ERC, and prototype validation pending |
| 2026-07-30 | Package 09 Sheet 08 entry-gate review | Confirmed Sheet 08 is limited to an unresolved optional J10 I²C boundary; retained GPIO37 and future wired communications as documentation-only reservations | Iron Pine Outdoors Engineering | PACKAGE 09 / SHEET 08 REMAINS BLOCKED pending a narrow J10 electrical, cable, power, protection, address, and connector contract |
| 2026-07-30 | ICD-001 J10 Expansion Interface | Released a restricted optional 3.3 V/100 kHz segmented I²C contract with bounded power, cable, address, protection, partial-power, recovery, DFM/DFT, and sheet ownership requirements | Iron Pine Outdoors Engineering | ICD-001 accepted; Package 09R Sheet 08 preliminary capture authorized within the ICD scope |
| 2026-07-30 | Package 09R Sheet 08 preliminary capture | Implemented the ICD-001 DNP expansion-power qualification, fail-disabled dual-supply I²C segment, external pull-ups, filtering, protection provisions, series damping, fault containment, and six DFT nodes | Iron Pine Outdoors Engineering | Preliminary capture complete; exact parts, connector release, native ERC, and prototype validation pending |
| 2026-07-30 | Package 10 Sheet 09 implementation gate | Stopped before Sheet 09 modification after identifying missing J6/J7 I2C routing plus unresolved J8, J9, J13, fixture, and quantitative harness contracts | Iron Pine Outdoors Engineering | PACKAGE 10 / SHEET 09 REMAINS BLOCKED pending narrow connector/interface resolution |
| 2026-07-30 | ICD-002 External Connector, Harness and Service Interface Release | Released the Rev A connector inventory, harness classes, split STOP/UI boundary, SELV relay-contact envelope, USB-C device/UFP role, factory fixture, and staged J6/J7 isolation contract | Iron Pine Outdoors Engineering | ICD-002 accepted; Package 10R authorized after mandatory ECO-003 verification |
| 2026-07-30 | ECO-003 Sheet 09 Hierarchy Exposure | Exposed the four approved J6/J7 I2C interface names from Sheet 07 through Sheet 00 to the Sheet 09 placeholder without adding electrical functionality | Iron Pine Outdoors Engineering | ECO-003 complete; Package 10R authorized; native ERC pending |
| 2026-07-30 | Package 10R Sheet 09 preliminary capture | Implemented ICD-002 generic connector/harness boundaries, USB-C UFP CC terminations, factory pogo access, and documentation-only J11/J12 treatment | Iron Pine Outdoors Engineering | Complete; ready for SSR-01; native ERC and exact-part release gates pending |
| 2026-07-30 | SSR-01 System Schematic Release Review | Reviewed the integrated Rev A architecture, power, safety, signal ownership, connectors, manufacturing, DFM/DFT, and serviceability | Iron Pine Outdoors Engineering | SCHEMATIC RELEASE NOT APPROVED; Package 11 blocked by J6/J7 isolation, USB boundary/protection, exact-part, quantitative, and ERC findings |

## 8. Prototype traceability

Every physical prototype shall be marked and recorded with:

- `IPC-100`
- Hardware revision
- Prototype build identifier
- Unique serial number
- Assembly date or lot
- BOM and fabrication-package identifiers
- Installed firmware version
- Rework/deviation record
- Test disposition

Prototype build identifiers shall not be reused.

## 9. External compatibility

CrossWind is the first planned external application and remains in a separate repository. Its compatibility record should identify the IPC-100 hardware revision, prototype/release state, connector baseline, and base-firmware version it consumes.

## 10. Related documents

- [Design Decisions](../architecture/Design_Decisions.md)
- [System Architecture](../architecture/System_Architecture.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
