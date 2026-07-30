# AR-06 — Independent Watchdog Service Interface Resolution

## Resolution

**Status:** ACCEPTED  
**Date:** 2026-07-30  
**Scope:** Rev A preliminary-capture interface amendment only

Package 07 stopped because Sheet 06 was required to generate `WATCHDOG_VALID` but had no independent evidence that application firmware continued to execute. Reusing a relay or motor command would alias safety and functional ownership; a static GPIO level would not detect stalled firmware.

## Resource decision

GPIO42 is assigned to the functional output `WATCHDOG_SERVICE_MCU`. The selected ESP32-S3-WROOM-1-N8 exposes GPIO42, and the pin is output-capable, non-strapping, and independent of native USB and UART0 recovery. GPIO37 remains the sole unconnected future reserve. No other GPIO changes.

## Interface contract

| Property | Accepted contract |
| --- | --- |
| Producer | Sheet 03 ESP32 core, GPIO42 |
| Consumer | Sheet 06 independent watchdog |
| Electrical domain | 3.3 V core logic |
| Reset/open default | Low through a Sheet 06 local 100 kΩ pull-down |
| Firmware behavior | Alternate the output state; every transition is a service event |
| Nominal transition interval | 75 ms |
| Preliminary valid transition window | 40–100 ms |
| Absolute loss-of-service response | `WATCHDOG_VALID` low within 250 ms of the last valid transition |
| Initial qualification | `RESET_VALID`, `MAIN_POWER_GOOD`, and at least two valid alternating transitions |
| Fault recovery | Latched invalid until `RESET_VALID` goes low or power cycles |

Both static high and static low are invalid. Transitions faster than the lower window bound, transitions slower than the upper service bound, a missing route, and loss of processor execution must not sustain authorization. Exact watchdog/qualifier parts and tolerance closure are Package 07R implementation work.

The 75 ms target gives 25 ms of preliminary jitter margin on either side while keeping the normal service rate well above actuator-response times. The 250 ms absolute deadline permits boot and scheduler jitter without allowing a crashed controller to remain authorized indefinitely. There is no unconditional startup grace period: the watchdog remains invalid until the processor is out of reset, main power is qualified, and two valid transitions have proved the operating service path. These preliminary limits require tolerance and workload validation on prototypes.

For Rev A, “independent” means a dedicated external timing function on Sheet 06, not an ESP32 software timer or free-running source. A window-watchdog IC is preferred; a retriggerable monostable or other timing device is acceptable only if it rejects static levels and out-of-window edges, fails inactive with invalid supply, and cannot back-power Sheet 03. Package 07R owns component selection.

## Authorization contract

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

`RELAY_DRIVE = RELAY_CMD_MCU AND ACTUATOR_PERMIT`

`WATCHDOG_VALID` is generated and owned by Sheet 06. Its root export is test-only observability; it is not processor feedback and does not transfer ownership.

| MAIN_POWER_GOOD | STOP_HW_INHIBIT | RESET_VALID | WATCHDOG_VALID | ACTUATOR_PERMIT | MASTER_INHIBIT |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 0 | 1 | 1 | 1 | 0 |
| 0 | X | X | X | 0 | 1 |
| X | 1 | X | X | 0 | 1 |
| X | X | 0 | X | 0 | 1 |
| X | X | X | 0 | 0 | 1 |

## Failure-mode disposition

| Condition | Required safe result |
| --- | --- |
| Missing or unpowered Sheet 06 | Sheet 05 local biases keep permit inactive and inhibit asserted |
| Processor reset, bootloader, or firmware update | Service stops; watchdog invalid; outputs off |
| Broken harness or open hierarchy | Sheet 06 pull-down establishes static low; watchdog invalid |
| USB-only operation | Main power qualification is false; permit inactive |
| Brownout | Reset/main qualification and watchdog qualification collapse |
| Floating external driver | No external driver owns this board-local signal; local bias prevents float |
| Service stuck high or low | No transitions; watchdog times out |
| Runaway service too fast | Window violation; watchdog invalid and latched |
| Service too slow | Window/timeout violation; watchdog invalid and latched |
| Firmware crash, deadlock, or watchdog-task failure | Service stops or leaves the window; watchdog invalid |
| Sheet 03 unpowered | Sheet 06 pull-down holds the service input low; watchdog invalid |
| Sheet 06 unpowered or watchdog supply lost | Watchdog output must fail inactive; Sheet 05 defaults remain safe |
| Open PCB trace | Local pull-down makes the receiver static low; watchdog invalid |
| Noise or one ESD-induced edge | One edge cannot satisfy the two-transition startup rule; an early edge violates the window |
| Timing capacitor open/short, if used | Must fail invalid or be rejected by Package 07R fault analysis |
| Watchdog IC internal failure | Generally detected if output fails low; output-stuck-active remains residual risk |
| Watchdog output stuck active | Undetected by the watchdog channel; other STOP/reset/main qualifiers still deauthorize their faults |

A watchdog device output stuck valid is a remaining single-component fault for quantitative Package 07R review. Independent STOP, reset, and main-power qualifiers remain in series.

## Compatibility and limits

The amendment changes no signal polarity, connectors, footprints, PCB objects, motor interface, Sheet 05 circuit, or existing ADR-039 through ADR-043 ownership. Sheet 06 affects motion only through `ACTUATOR_PERMIT` and `MASTER_INHIBIT`. `RELAY_CMD_MCU` remains the generic relay request and is independently gated by authorization. It does not authorize `THROWER_TRIGGER`, PAN/TILT, speed/direction, new motor enables, or Sheet 06 circuitry.

## Validation

The repository GPIO and hierarchy validators enforce the one-producer/one-consumer route, unique GPIO42 allocation, preserved GPIO37 reserve, functional naming, and prohibited interface names. Native KiCad ERC was unavailable in the current environment and remains mandatory before schematic release. This resolution marks the interface complete, not the Sheet 06 implementation.

## Decision

AR-06 ACCEPTED.

PACKAGE 07R / SHEET 06 ARCHITECTURALLY AUTHORIZED.
