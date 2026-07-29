# IPC-100 Rev A Test Plan

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Rev A Test Plan |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

Acceptance limits must be completed before formal verification.

## Purpose

Verify that IPC-100 Rev A meets approved requirements and behaves safely across expected power, load, environmental, interface, and fault conditions.

## Test controls

Record for every execution:

- Unit serial number and hardware revision
- Firmware version or test image
- Test procedure revision
- Equipment identification and calibration status
- Operator, date, location, and ambient conditions
- Measured results, evidence, deviations, and disposition

## Test matrix

| ID | Area | Test | Method | Acceptance criteria | Evidence | Status |
| --- | --- | --- | --- | --- | --- | --- |
| PWR-001 | Power | 9–21 V operation | Test | TBD | Data log | Planned |
| PWR-002 | Power | Reverse polarity | Test | TBD | Photos/data | Planned |
| PWR-003 | Power | Brownout and recovery | Test | TBD | Waveforms | Planned |
| PWR-004 | Power | Input transients | Test | TBD | Waveforms | Planned |
| COM-001 | Radio | Wi-Fi operation | Test | TBD | Test log | Planned |
| COM-002 | Radio | Bluetooth operation | Test | TBD | Test log | Planned |
| COM-003 | Radio | ESP-NOW operation | Test | TBD | Test log | Planned |
| IO-001 | Inputs | Limit switches | Test | TBD | Test log | Planned |
| IO-002 | Inputs | Operator controls | Test | TBD | Test log | Planned |
| IO-003 | Outputs | Isolated dry-contact relay | Test | TBD | Waveforms/log | Planned |
| IO-004 | Outputs | External motor-driver control interfaces | Test | TBD | Waveforms/log | Planned |
| IO-005 | Inputs | Field-input electrical states, conditioning, faults, and diagnostics | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| IO-006 | Inputs | Safety-relevant input priority and service independence | Analysis and test | TBD | Timing data/test log | Planned |
| IO-007 | Outputs | Relay safe states, isolation, external-load faults, and backfeed | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| IO-008 | Outputs | Motor-interface safe states, command conflicts, local inhibition, and backfeed | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| IO-009 | Outputs | RGB and buzzer safe states, faults, and simultaneous loading | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| IO-010 | Outputs | OLED reset power sequencing, inactive-display behavior, and backfeed | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| EXP-001 | Expansion | Shared-I2C populations, faults, timeout, recovery, and safe startup | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| EXP-002 | Expansion | Spare-GPIO states, faults, unsupported requests, and revision mismatch | Inspection, analysis, and test | TBD | Waveforms/test log | Planned |
| EXP-003 | Expansion | Future communications provisions and unsupported-feature reporting | Inspection and test | TBD | Review/test log | Planned |
| CONN-001 | Connectors | Architecture, misconnection, partitioning, and safety-path fault review | Inspection and analysis | TBD | Review/test log | Planned |
| UI-001 | UI | OLED interface (SSD1309 reference), RGB LED, buzzer | Test | TBD | Photos/log | Planned |
| SNS-001 | Sensors | Environmental sensor (BME280 reference) | Test | TBD | Comparison data | Planned |
| SNS-002 | Sensors | Battery monitoring | Test | TBD | Calibration data | Planned |
| SAF-001 | Safety | STOP behavior | Test | TBD | Timing data | Planned |
| ENV-001 | Environment | Temperature exposure | Test | TBD | Chamber data | Planned |
| MEC-001 | Mechanical | Connector retention | Test | TBD | Inspection log | Planned |

## Bring-up testing

Inspect assembly before applying power. Use a current-limited supply, verify resistance to ground, bring up each rail independently where possible, confirm clocks and reset behavior, and validate safe output states before connecting actuators.

## Functional testing

Exercise all communications, display, sensors, inputs, outputs, and expansion interfaces over their specified operating ranges.

## Power and load testing

Test minimum and maximum controller input voltage, relay interface switching, external-interface disturbances, controller peak loads, regulation, ripple, efficiency, and thermal rise. Product motor start/stall and battery-system tests belong in the consuming product repository.

## Fault-injection testing

Evaluate open and shorted inputs, disconnected peripherals, output-interface faults where safely supported, external-driver fault indications, communication loss, processor reset, brownout, and STOP activation.

Input-interface coverage shall include inactive and asserted states; disconnection; short to ground; short to each approved supply domain; contact bounce; induced noise; reset, boot, brownout, and recovery; simultaneous states; conflicting opposite limits; stuck limit, ARM, FIRE, and STOP inputs; unavailable wireless and display services; an I2C bus fault; USB connected during product power; safe-state output response; and diagnostic reporting. Exact electrical levels, timing, repetition counts, and pass/fail thresholds remain `TBD`.

STOP and limit testing shall exercise healthy, open/asserted, wire-break, shorted, invalid-supervision, cross-loop, unknown-startup, and recovery states for every individually returned NC loop. ARM/FIRE testing shall prove held-at-boot rejection, FIRE-before-ARM rejection, STOP cancellation, release-before-retrigger, reset/power-loss authorization clearing, and absence of direct output action. Encoder faults shall remain non-safety and nonblocking to safe initialization.

Relay coverage shall prove that the common hardware master inhibit overrides relay requests during STOP, invalid main power, reset, boot, brownout, watchdog recovery, bounded USB-only core service, and uninitialized operation. It shall also cover simultaneous USB and main power, floating or disconnected control, repeated and stale trigger commands, de-energized `RELAY_NO`-open contact-state verification, isolation and backfeed concepts, absent external load, and external-load fault. `RELAY_NC` continuity shall be characterized but shall not be treated as a platform safe-state claim.

Motor-interface coverage shall prove the common hardware master inhibit across all eight motion signals during STOP, invalid main power, reset, boot, brownout, watchdog recovery, bounded USB-only service, and uninitialized operation. It shall verify all PWM commands inactive and all enables disabled as the safe state; mutual exclusion of opposing PWM commands; the disabled/coast transition and approved interlock interval before reversal; prioritized firmware inhibition toward each product-mapped asserted limit; disconnected, independently powered, and unpowered drivers; cable disconnect; backfeed; communication loss; and malformed, repeated, conflicting, or stale commands.

RGB and buzzer coverage shall prove off/silent defaults during reset, brownout, power loss, invalid main power, and bounded USB-only service; it shall include output-short and disconnect concepts, maximum planned simultaneous loading, and nonfatal failure behavior. OLED-reset coverage shall prove reset asserted or electrically non-driving until `OLED_VCC` is valid, controlled release after the approved interval, return to reset before or during display-power collapse as required by the implementation, no backfeed into an unpowered display, and safe behavior during USB-only and simultaneous-source transitions. Exact voltages, currents, timing, repetitions, environmental conditions, and pass/fail thresholds for all output tests remain `TBD`.

Shared-I2C coverage shall include no optional device; OLED only; environmental sensor only; both reference devices; approved external expansion; duplicate addresses; excessive parallel pull-up concept; SDA or SCL stuck low; absent, reset, unsupported, unpowered, or independently powered devices; operational disconnect; bounded timeout; recovery; and safe startup with a failed bus.

Spare-GPIO coverage shall include unconnected state; input short to ground or an approved supply; output open and short concepts; external voltage while IPC-100 is off; reset and boot states; unsupported function request; and hardware-revision mismatch.

Future-communications coverage shall confirm that unpopulated provisions do not affect required operation, firmware does not advertise unsupported CAN or RS485, reserved-pin conflicts are reviewed, backfeed is considered, and absent external transceivers are nonfatal.

Connector-architecture coverage shall include misconnection, partial insertion, reversed insertion where mechanically possible, missing individual loop returns, incorrect product harness, unused connector exposure, STOP-path faults, J8 partition review, and J4/J5 cross-loop faults.

Expansion-power coverage shall include maximum approved expansion load, rail overload and short concepts, simultaneous loads, startup peak, main-only operation, confirmation that expansion remains unpowered during bounded USB-only service, simultaneous USB and main power, and both external-module-first and IPC-100-first sequencing. Exact timing, voltage, current, fault duration, cable length, repetition count, environmental condition, and pass/fail thresholds remain `TBD`.

## Environmental and durability testing

Define temperature, humidity, vibration, shock, ingress, corrosion, UV, connector-cycle, and operating-life profiles based on the final product environment.

## Regression testing

Create a repeatable regression suite as firmware and test fixtures become available. Safety behavior, GPIO defaults, power recovery, and released platform-interface compatibility are mandatory regression areas.

## Exit criteria

Formal Rev A verification is complete only when all approved requirements have passing evidence, deviations are dispositioned, and the released design and test records are configuration-controlled.

Requirement identifiers and status are controlled in [Hardware Requirements](../requirements/Hardware_Requirements.md).

## Test-readiness matrix

| Requirement area | Inspection | Analysis | Bench test | Fault injection | Environmental test | Product-level test | Current readiness |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Platform and boundaries | Planned | Planned | N/A | N/A | N/A | Compatibility record | Ready at architecture level |
| Processor/resources | Planned | Required | Prototype required | Recovery faults | Radio/environment later | Enclosure/radio integration | Blocked by module selection |
| Power and USB | Planned | Required | Prototype required | Required | Thermal/environment later | Source-system validation | Blocked by rail and USB architecture |
| Inputs and STOP/limits | Planned | Required | Prototype required | Required | Wiring/environment later | Product hazard response | Blocked by electrical contract |
| Relay, motor, and status outputs | Planned | Required | Prototype required | Required | Load/environment later | Product motion/load safety | Behavior defined; blocked by quantitative contracts and implementation |
| Display/sensor/battery | Planned | Required | Prototype required | Required | Sensor/environment later | Ambient interpretation | Blocked by module and supply choices |
| Shared I2C/expansion | Planned | Required | Prototype required | Required | Cable/environment later | Installed-device validation | Blocked by bus contract |
| Connectors and wiring | Planned | Required | Mating prototypes required | Misconnection concepts | Retention/environment later | Harness validation | Blocked by connector architecture |
| Firmware abstraction | Planned | Planned | Hardware required for drivers | Timeout/recovery required | N/A | Product application separate | Interface scaffolding only |
| Mechanical/environment | Planned | Required | Mechanical prototype required | Service/access concepts | Required | Product enclosure validation | Blocked by envelope/environment |

Architecture-level coverage exists for safe startup, reset, brownout, watchdog recovery, common hardware output inhibit, STOP and limit priority, relay de-energized state, disabled/coast motor state, opposing-command rejection, inhibited reversal, RGB-off/buzzer-silent defaults, OLED reset sequencing, USB/main-power interactions, external-module backfeed, I2C faults, absent optional devices, unsupported hardware, expansion overload, and connector faults. Numeric acceptance criteria remain `TBD`.
