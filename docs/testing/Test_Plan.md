# IPC-100 Rev A Test Plan

Status: Initial framework — acceptance limits must be completed before formal verification.

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
| UI-001 | UI | OLED, RGB LED, buzzer | Test | TBD | Photos/log | Planned |
| SNS-001 | Sensors | BME280 | Test | TBD | Comparison data | Planned |
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

## Environmental and durability testing

Define temperature, humidity, vibration, shock, ingress, corrosion, UV, connector-cycle, and operating-life profiles based on the final product environment.

## Regression testing

Create a repeatable regression suite as firmware and test fixtures become available. Safety behavior, GPIO defaults, power recovery, and released platform-interface compatibility are mandatory regression areas.

## Exit criteria

Formal Rev A verification is complete only when all approved requirements have passing evidence, deviations are dispositioned, and the released design and test records are configuration-controlled.
