# IPC-100 Revision History

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Revision History |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Revision identity

IPC-100 begins at hardware Rev A. Prior CrossWind controller concepts are predecessor work only; they do not make IPC-100 Rev D or transfer any earlier product revision number to this platform.

Rev A is currently in architecture and requirements definition. No prototype build, production candidate, or released hardware is claimed.

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
