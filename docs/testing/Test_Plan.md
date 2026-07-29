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

Relay coverage shall include reset and boot, brownout, watchdog recovery, loss of main power, USB-only power if supported, simultaneous USB and main power, floating or disconnected control, repeated trigger commands, contact-state verification, isolation and backfeed concepts, absent external load, and external-load fault.

Motor-interface coverage shall include reset and boot; both enables inactive; both PWM commands inactive; conflicting direction commands; asserted STOP and applicable limits; disconnected, independently powered, and unpowered drivers; cable disconnect; backfeed; brownout; watchdog recovery; communication loss; and malformed or stale commands.

RGB and buzzer coverage shall include reset, brownout, and power-loss states; output-short and disconnect concepts; maximum planned simultaneous loading; and nonfatal failure behavior. Exact voltages, currents, timing, repetitions, environmental conditions, and pass/fail thresholds for all output tests remain `TBD`.

## Environmental and durability testing

Define temperature, humidity, vibration, shock, ingress, corrosion, UV, connector-cycle, and operating-life profiles based on the final product environment.

## Regression testing

Create a repeatable regression suite as firmware and test fixtures become available. Safety behavior, GPIO defaults, power recovery, and released platform-interface compatibility are mandatory regression areas.

## Exit criteria

Formal Rev A verification is complete only when all approved requirements have passing evidence, deviations are dispositioned, and the released design and test records are configuration-controlled.

Requirement identifiers and status are controlled in [Hardware Requirements](../requirements/Hardware_Requirements.md).
