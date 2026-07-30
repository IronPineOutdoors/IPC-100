# ADR-044 — Independent Watchdog Service Interface

## Status

Accepted — 2026-07-30

## Context

The Rev A authorization equation requires an independently generated `WATCHDOG_VALID`. Before AR-06, Sheet 03 exported no watchdog-service signal and Sheet 06 could not distinguish executing application firmware from reset, bootloader operation, a crash, or a stuck output.

## Decision

1. Allocate ESP32-S3 GPIO42 to the Sheet 03 output `WATCHDOG_SERVICE_MCU`.
2. Route that functional net through Sheet 00 to one Sheet 06 input. Raw GPIO names remain local to Sheet 03.
3. Preserve GPIO37 as the only future communications/diagnostic reserve.
4. Require alternating transitions: nominal 75 ms, preliminary accepted interval 40–100 ms. Static high, static low, too-fast, and too-slow behavior are invalid.
5. Sheet 06 shall provide deterministic low bias, independent window/timing qualification, startup qualification, and invalid-state latching. Loss of valid service shall force `WATCHDOG_VALID` low within 250 ms.
6. Qualification requires `RESET_VALID`, `MAIN_POWER_GOOD`, and at least two valid transitions. Recovery after a timing fault requires reset assertion or power cycle.
7. Sheet 06 owns and generates `WATCHDOG_VALID`. Its hierarchy export is test-only observability and is not MCU feedback.
8. Preserve the authorization equation and relay gating defined in AR-06.

## Consequences

GPIO42 is no longer available to the former two-pin future pool. No connector claim is created. Sheet 06 implementation must select and tolerance a dedicated watchdog/qualifier topology and verify startup, reset, brownout, USB-only, open-route, stuck-level, and timing-window behavior.

This decision amends only the GPIO42 reserve disposition in ADR-040 and the corresponding reserve references in ADR-041 and ADR-043. All other decisions remain in force.

## Prohibited interpretations

`RELAY_CMD_MCU` is not watchdog service. No thrower-specific trigger, extra motor enable, firmware-generated `WATCHDOG_VALID`, Sheet 05 modification, connector, footprint, PCB, or layout work is authorized by this ADR.
