# ADR-043 — Rev A Motion Control Interface and Output-Fault Ownership

> **ADR-044 amendment:** GPIO42 is now `WATCHDOG_SERVICE_MCU`; GPIO37 remains reserved. The eight-channel motion interface, fault ownership, and Sheet 05 topology remain unchanged.

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Date | 2026-07-30 |
| Status | Accepted |
| Decision owner | Iron Pine Outdoors Engineering |
| Resolution package | AR-05 |

## Context

Package 06 stopped because its generic PAN/TILT, shared enable/speed, feedback, direct STOP, and Sheet 06 destination requests contradicted the frozen Rev A allocation. The hierarchy also retained an orphan `OUTPUT_FAULT_SUMMARY` without a producer, consumer, or GPIO.

## Decision

The [Motion Control Interface Control Document](../interfaces/Motion_Control_Interface_Control_Document.md) is the controlling Rev A implementation reference for Sheets 03, 05, 06, and 09.

Rev A preserves all eight ADR-040 commands and no aliases:

- Axis 1: `AXIS1_RPWM_MCU`, `AXIS1_LPWM_MCU`, `AXIS1_REN_MCU`, `AXIS1_LEN_MCU`;
- Axis 2: `AXIS2_RPWM_MCU`, `AXIS2_LPWM_MCU`, `AXIS2_REN_MCU`, `AXIS2_LEN_MCU`.

Each axis uses mutually exclusive dual PWM direction requests plus two independent enable requests. Firmware owns legal command generation and a 20 ms all-off reversal interval. Sheet 05 additionally suppresses simultaneous opposing PWM requests in hardware, then applies deterministic defaults, authorization-controlled output enable, 3.3-to-5 V translation, damping, and interface protection.

Two independent four-channel partial-power translators preserve the separately protected Axis 1 and Axis 2 5 V logic domains. The earlier single shared eight-channel translator selection is superseded because it would require tying or ambiguously selecting the two B-side rails.

Sheet 06 remains the sole owner of `ACTUATOR_PERMIT` and `MASTER_INHIBIT` and the sole consumer of `STOP_HW_INHIBIT`. Sheet 05 consumes authorization but does not generate or reinterpret it. Sheet 09 owns J2/J3, and the eight safe outputs terminate there for external motor-driver modules.

Limits remain Sheet 04-to-03. Rev A adds no home, encoder, ready, thermal, overcurrent, individual-driver-fault, or readback input.

`OUTPUT_FAULT_SUMMARY` is removed from Rev A. No producer exists and no GPIO is allocated. A future output-fault interface requires a new ADR and resource allocation.

## Consequences

- The ADR-040 GPIO allocation and GPIO37/GPIO42 reserve remain unchanged.
- Sheet 05 can be implemented from one exact signal inventory.
- Simultaneous opposing PWM cannot propagate through a single firmware error alone.
- Hardware authorization remains independent of firmware and motor commands.
- External-driver or motor action is not inferred from commanded state.
- Product repositories map Axis 1/2 to mechanisms without renaming electrical nets.

## Authorization

AR-05 closes ODI-SCH-013 and authorizes **IPC-100 Rev A Preliminary KiCad Capture Package 06R — Sheet 05 Rev A Axis Command Conditioning and External Driver Logic Interface**. AR-05 itself authorizes only documentation and the removal of the orphan hierarchy port; it does not populate Sheet 05, change GPIOs, add connectors, or assign footprints.
