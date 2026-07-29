# IPC-100 Requirements Traceability Matrix

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Purpose | Trace requirements to architecture, interfaces, verification concepts, and open decisions |
| Status | Architecture-level traceability |
| Owner | Iron Pine Outdoors Engineering |

## 1. Hardware requirements

Every current hardware requirement ID is included below. Grouped rows share architecture and verification artifacts; individual evidence and final procedure identifiers remain `TBD`.

| Requirement ID | Requirement summary | Architecture area | Interface / signal | Owning document | Verification method | Planned test reference | Design stage | Status | Open item dependency |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PLT-001, PLT-002, PLT-003 | Reusable product-neutral platform and repository boundary | Platform/product boundary | All | Hardware Requirements; Product Boundaries | Inspection | Architecture review | Architecture | Locked | None blocking |
| PWR-001–PWR-005 | Input range, sources, external motor power and distribution | Power boundary | `VIN_RAW`, `GND` | Hardware Requirements; Power Architecture | Inspection/test | Power concepts | Architecture/schematic | Locked | ODI-PWR-001 |
| PWR-006–PWR-010 | Input-path capability, derating, protection, and rail selection | Power architecture | `VIN_RAW`, `+5V`, `+3V3` | Hardware Requirements; Power Budget | Analysis/test | Power and thermal concepts | Before/during schematic | Proposed/TBD | ODI-PWR-001, ODI-PWR-002 |
| PWR-011–PWR-013 | USB interaction and battery measurement | Power/service/ADC | USB, `BATTERY_SENSE` | Power Architecture; GPIO Map | Analysis/test | USB/backfeed and calibration concepts | Before schematic/prototype | Locked/TBD | ODI-CPU-004, ODI-PWR-004, ODI-PWR-005 |
| CPU-001–CPU-006 | Processor family, service, resources, memory, boot, antenna | Processor | ESP32 family, USB, boot/reset | Hardware Requirements; Processor Feasibility | Inspection/analysis/test | Processor gate | Before schematic/firmware | Proposed/Locked/TBD | ODI-CPU-001–ODI-CPU-006 |
| COM-001–COM-005 | Wi-Fi, Bluetooth, ESP-NOW, safe independence, reusable services | Communications | Radio services | System Architecture; firmware docs | Inspection/demonstration/test | Communications and loss concepts | Firmware/prototype | Locked | ODI-CPU-001, ODI-CPU-003 |
| DSP-001–DSP-006 | Generic OLED interface, I2C/reset, supply and fault behavior | Display | `OLED_VCC`, `I2C_SDA`, `I2C_SCL`, `OLED_RESET` | Hardware Requirements; Connector Specification | Inspection/analysis/demonstration/test | UI/I2C concepts | Before schematic/prototype | Proposed/Locked/TBD | ODI-DS-001, ODI-DS-003, ODI-DS-005, ODI-DS-006 |
| SNS-001–SNS-008 | Environmental and battery sensing, shared bus and faults | Sensors/ADC/I2C | `SENSOR_VCC`, `BATTERY_SENSE`, I2C | Hardware Requirements; Power/GPIO docs | Inspection/analysis/demonstration/test | Sensor, calibration, I2C fault concepts | Before schematic/prototype | Proposed/Locked/TBD | ODI-DS-002, ODI-DS-004–ODI-DS-007 |
| INP-001–INP-004 | Stable limit, encoder, ARM/FIRE/STOP interfaces | Inputs | All stable input names | Hardware Requirements; Connector Specification | Inspection/test | Input concepts | Architecture/schematic | Locked | ODI-INP-001–ODI-INP-003 |
| INP-005–INP-009 | Protection, filtering, states, independence, diagnostics | Safety-relevant inputs | Limits | Hardware Requirements; Wiring; Test Plan | Inspection/analysis/demonstration/test | Input fault concepts | Before schematic/prototype | Locked/Proposed/TBD | ODI-INP-001–ODI-INP-005, ODI-INP-007 |
| INP-010–INP-016 | Encoder and ARM/FIRE/STOP behavior and faults | Input abstraction/safety | Encoder, ARM/FIRE/STOP | Hardware/Functional Requirements | Inspection/analysis/demonstration/test | Control and safety concepts | Schematic/firmware | Locked/TBD | ODI-INP-001, ODI-INP-005, ODI-INP-006 |
| INP-017–INP-022 | GPIO protection, backfeed, field contract, bias, priority | Input electrical architecture | External inputs | Hardware Requirements; GPIO Map | Inspection/analysis/test | Fault and startup concepts | Before schematic | Locked/TBD | ODI-INP-001–ODI-INP-006 |
| OUT-001–OUT-003 | Isolated externally powered relay interface | Relay | `RELAY_NC`, `RELAY_COM`, `RELAY_NO` | Hardware Requirements; J9 | Inspection/analysis/test | Relay concepts | Before schematic | Locked | ODI-OUT-001 |
| OUT-004–OUT-008 | Two motor logic channels, RGB, buzzer | Outputs/UI | Axis, RGB, buzzer signals | Hardware Requirements; J2/J3/J8 | Inspection/analysis/test | Output concepts | Architecture/schematic | Locked/Proposed | ODI-OUT-002–ODI-OUT-007 |
| OUT-009–OUT-012 | Relay safe state, command gate, final contract | Relay safety | `RELAY_CTRL`, contacts | Hardware/Functional Requirements | Inspection/analysis/test | Relay safe-state/fault concepts | Before schematic/prototype | Locked/TBD | ODI-OUT-001 |
| OUT-013–OUT-020 | Motor safe states, command conflict, STOP/limit, backfeed, contract | Motor safety/interface | Axis signals | Hardware Requirements; Processor Feasibility | Inspection/analysis/test | Motor fault and priority concepts | Before schematic/prototype | Locked/TBD | ODI-OUT-002–ODI-OUT-005 |
| OUT-021–OUT-028 | RGB/buzzer safe states and unresolved load contracts | Indicators | RGB/buzzer | Hardware Requirements; Power Budget | Inspection/analysis/demonstration/test | UI output concepts | Schematic/prototype | Locked/TBD | ODI-OUT-006, ODI-OUT-007 |
| OUT-029–OUT-034 | General safe outputs, command faults, diagnostics, power states/backfeed | Output safety | All outputs | Hardware Requirements; Power Architecture | Inspection/analysis/demonstration/test | Safe-start/backfeed concepts | Before schematic/prototype | Locked/TBD | ODI-OUT-008, ODI-PWR-004, ODI-PWR-005 |
| EXP-001–EXP-010 | Controlled optional expansion, safety, power, populations | Expansion | J10/J11/future | Hardware Requirements; System Architecture | Inspection/analysis/test | Expansion concepts | Architecture/schematic | Locked/Proposed/TBD | ODI-EXP-001, ODI-EXP-002 |
| EXP-011–EXP-016 | Shared-I2C pull-ups, addresses, faults, loading, hot-plug, segmentation | I2C expansion | J10/I2C | Hardware Requirements; J10 | Inspection/analysis/test | I2C fault concepts | Before schematic/prototype | Locked/TBD | ODI-DS-005, ODI-DS-006, ODI-EXP-001, ODI-EXP-007 |
| EXP-017–EXP-021 | Spare GPIO safety, state, capability and protection | Spare expansion | J11 | Hardware Requirements; GPIO Map | Inspection/analysis/test | Spare-GPIO concepts | Before schematic/prototype | Locked/TBD | ODI-EXP-002 |
| EXP-022–EXP-027 | Future CAN/RS485 provisions and claims | Future communications | J12 concepts | Hardware Requirements; ADR-015 | Inspection/analysis | Future-provision review | Future/PCB planning | Locked/Proposed/TBD | ODI-EXP-003, ODI-EXP-004 |
| EXP-028–EXP-031 | Daughterboards, access, mechanics, identification | Future modules | TBD | Hardware Requirements; Connector Review | Architecture review/inspection/test | Future-module concepts | Future/before firmware if adopted | Locked/Proposed/TBD | ODI-EXP-005, ODI-EXP-006 |
| ENV-001–ENV-006 | Outdoor intent, enclosure, connectors, coating, temperature, environment ownership | Environmental/mechanical | Board/enclosure boundary | Hardware Requirements; Mechanical Interface | Inspection/analysis/test | Environmental concepts | PCB/prototype/production | Locked/Proposed/TBD | ODI-CONN-007, ODI-CONN-008; mechanical TBDs |
| MEC-001, MEC-002 | Mounting and connector access | Mechanical | PCB/enclosure | Hardware Requirements; Mechanical Interface | Inspection | Mechanical review | Before PCB layout | Locked/Proposed | MEC-TBD-001–MEC-TBD-004 |
| SAF-001–SAF-006 | Physical STOP, safe outputs, fusing, wireless independence, controls | Safety | STOP, motor, relay, power | Hardware Requirements; Safety review | Inspection/analysis/test | Safety and fault concepts | Before schematic/product integration | Locked | ODI-INP-006, ODI-OUT-001–ODI-OUT-003 |
| DOC-001, DOC-002 | Controlled naming and revision records | Configuration control | All | Hardware Requirements; Revision History | Inspection | Documentation audit | All stages | Locked | None |
| TEST-001, TEST-002 | Controller verification plan and product validation boundary | Verification | All | Hardware Requirements; Test Plan | Inspection | Test-readiness matrix | Before prototype/production | Locked | Acceptance criteria TBD |

## 2. Material functional requirements

| Requirement ID | Behavior covered | Architecture / verification mapping | Status / dependency |
| --- | --- | --- | --- |
| FUNC-SYS-001–FUNC-SYS-005 | Platform boundary and revision compatibility | System Architecture; Product Boundaries; inspection/demonstration | Architecture complete |
| FUNC-PWR-001–FUNC-PWR-008 | Power, rails, battery, backfeed, high-current boundary | Power docs; power/fault concepts | Rail/USB/ADC dependencies |
| FUNC-CPU-001–FUNC-CPU-006 | Processor, service, recovery, resources | Processor Feasibility; processor gate | Module/memory/USB TBD |
| FUNC-IO-001–FUNC-IO-030 | Input/output abstraction, safety, faults, backfeed | GPIO, connectors, safety review, test concepts | Electrical contracts TBD |
| FUNC-UI-001–FUNC-UI-011 | Display, RGB, buzzer behavior | J6/J8, power, UI concepts | Modules/topologies TBD |
| FUNC-SNS-001–FUNC-SNS-008 | Environmental/battery/I2C behavior | Sensor, power, I2C tests | Bus/module/calibration TBD |
| FUNC-COM-001–FUNC-COM-006 | Wireless and future wired provisions | Communications architecture/tests | CAN/RS485 future |
| FUNC-EXP-001–FUNC-EXP-012 | Optional-device handling and expansion faults | Expansion architecture/tests | J10/J11/identification TBD |
| FUNC-SAFE-001–FUNC-SAFE-005 | Safe outputs, STOP, wireless independence, diagnostics | Safety table and fault tests | Hardware mechanisms TBD |
| FUNC-FW-001–FUNC-FW-006 | Boot sequence, abstraction, drivers, diagnostics, versioning, watchdog | Firmware readiness | Schematic/watchdog dependencies |

## 3. Traceability gaps and overlaps

- No authoritative requirement lacks an owning architecture area or stated verification method.
- Many requirements have concept-level tests but no controlled procedure or numeric acceptance criterion.
- Component-dependent requirements cannot close until schematic selection and prototype evidence exist.
- Environmental and product hazard validation remain correctly product-owned where applicable.
- Hardware and functional requirements intentionally overlap at architecture-versus-behavior level.
- Test Plan identifiers overlap requirement-style namespaces; a future verification-ID policy should separate requirement and procedure identities.
- Requirements using qualitative words require measurable criteria at later gates; they are not all schematic blockers.

## 4. Explicit hardware-ID coverage index

- Platform: PLT-001, PLT-002, PLT-003
- Power: PWR-001, PWR-002, PWR-003, PWR-004, PWR-005, PWR-006, PWR-007, PWR-008, PWR-009, PWR-010, PWR-011, PWR-012, PWR-013
- Processor: CPU-001, CPU-002, CPU-003, CPU-004, CPU-005, CPU-006
- Communications: COM-001, COM-002, COM-003, COM-004, COM-005
- Display: DSP-001, DSP-002, DSP-003, DSP-004, DSP-005, DSP-006
- Sensors: SNS-001, SNS-002, SNS-003, SNS-004, SNS-005, SNS-006, SNS-007, SNS-008
- Inputs: INP-001, INP-002, INP-003, INP-004, INP-005, INP-006, INP-007, INP-008, INP-009, INP-010, INP-011, INP-012, INP-013, INP-014, INP-015, INP-016, INP-017, INP-018, INP-019, INP-020, INP-021, INP-022
- Outputs: OUT-001, OUT-002, OUT-003, OUT-004, OUT-005, OUT-006, OUT-007, OUT-008, OUT-009, OUT-010, OUT-011, OUT-012, OUT-013, OUT-014, OUT-015, OUT-016, OUT-017, OUT-018, OUT-019, OUT-020, OUT-021, OUT-022, OUT-023, OUT-024, OUT-025, OUT-026, OUT-027, OUT-028, OUT-029, OUT-030, OUT-031, OUT-032, OUT-033, OUT-034
- Expansion: EXP-001, EXP-002, EXP-003, EXP-004, EXP-005, EXP-006, EXP-007, EXP-008, EXP-009, EXP-010, EXP-011, EXP-012, EXP-013, EXP-014, EXP-015, EXP-016, EXP-017, EXP-018, EXP-019, EXP-020, EXP-021, EXP-022, EXP-023, EXP-024, EXP-025, EXP-026, EXP-027, EXP-028, EXP-029, EXP-030, EXP-031
- Environmental: ENV-001, ENV-002, ENV-003, ENV-004, ENV-005, ENV-006
- Mechanical: MEC-001, MEC-002
- Safety: SAF-001, SAF-002, SAF-003, SAF-004, SAF-005, SAF-006
- Documentation: DOC-001, DOC-002
- Testing: TEST-001, TEST-002
