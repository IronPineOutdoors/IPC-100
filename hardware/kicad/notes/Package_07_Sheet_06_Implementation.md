# Package 07 — Sheet 06 Implementation Record

> **Historical entry-gate record:** AR-06 / ADR-044 closed the missing-service-route blocker by assigning GPIO42 to `WATCHDOG_SERVICE_MCU` and authorizing Package 07R. This file records why Package 07 stopped; it does not implement Sheet 06.

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Package | 07 |
| Sheet | 06 — Relay Output and Master Inhibit |
| Date | 2026-07-30 |
| Status | **Stopped at entry gate; no schematic modification** |
| Blocker | Missing approved watchdog-service source and route |

## Entry-gate result

Package 07 cannot implement the frozen authorization equation without inventing a processor signal, reusing an unrelated GPIO, or weakening the accepted independent-watchdog requirement.

The required equation is:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

Sheet 06 has approved inputs for:

- `+3V3_CORE`;
- `RELAY_VCC`;
- `STOP_HW_INHIBIT`;
- `MAIN_POWER_GOOD`;
- `RESET_VALID`;
- `RELAY_CMD_MCU`.

It has no input that can service or challenge the watchdog. Sheet 00 has no watchdog-service route, Sheet 03 exports no such functional signal, and the ADR-040 GPIO table allocates every application GPIO without a watchdog-service output.

The architecture requires a TPS3431-Q1-class independent watchdog with a 250 ms nominal timeout, serviced at 50–100 ms by a supervised firmware control task. It explicitly prohibits satisfying the watchdog with a static GPIO, boot-ROM activity, or a free-running peripheral detached from healthy control flow. Therefore:

- `RELAY_CMD_MCU` cannot be reused as watchdog service;
- `RESET_VALID` cannot prove continuing control flow;
- a local oscillator cannot prove processor health;
- tying WDI to a static level cannot implement the contract;
- `WATCHDOG_VALID` cannot be assumed high or omitted from the permit equation.

## Frozen ownership conflicts in the package request

ADR-043 states that Sheet 06 does not export `DRIVER_ENABLE`, `MOTOR_LOGIC_ENABLE`, motor commands, or additional motor-enable outputs. Axis `REN`/`LEN` commands originate on Sheet 03, are conditioned by Sheet 05, and terminate at Sheet 09. Sheet 06 affects motor interfaces only through `ACTUATOR_PERMIT` and `MASTER_INHIBIT`.

The generic Rev A relay path is `RELAY_CMD_MCU` gated by `ACTUATOR_PERMIT`. There is no separate `THROWER_TRIGGER` signal or GPIO; adding a CrossWind-specific trigger name would violate the product-neutral IPC-100 boundary. The approved generic relay may serve a product-specific trigger only through product firmware and integration documentation.

No extra enable, thrower, or driver-control signal was added.

## Authorization chain intended after resolution

The frozen low-energy chain is otherwise complete:

1. Sheet 02 supplies fail-low `MAIN_POWER_GOOD`.
2. Sheet 04 supplies active-high `STOP_HW_INHIBIT`.
3. Sheet 03 supplies fail-low `RESET_VALID`.
4. The missing approved processor service signal drives a Sheet 06 independent watchdog.
5. Sheet 06 creates local `WATCHDOG_VALID`.
6. Fail-low logic creates `ACTUATOR_PERMIT`.
7. Complementary logic creates fail-high `MASTER_INHIBIT`.
8. Sheet 05 consumes both signals and defaults safe through ECO-001/ECO-002.
9. Sheet 06 gates `RELAY_CMD_MCU` with permit before the relay MOSFET.

The implementation must prove no power-up or shutdown pulse can assert permit.

## Relay calculation basis

The controlled preliminary basis remains:

- Omron G5Q-1 DC5-class SPDT relay;
- 5 V, 80 mA provisional coil;
- 2N7002P-class 60 V N-channel low-side MOSFET;
- 100 Ω gate resistor;
- 100 kΩ gate pulldown;
- series Schottky plus 12 V, 500 mW zener turn-off clamp;
- relay coil supplied only by `RELAY_VCC`;
- relay command ANDed with `ACTUATOR_PERMIT`;
- coil de-energized and `RELAY_NO` open as the platform safe state.

Nominal coil power:

`Pcoil = 5 V × 0.08 A = 0.40 W`

At the deliberately conservative 2 Ω MOSFET on-resistance bound:

`PMOSFET = I²R = 0.08² × 2 = 12.8 mW`

The exact relay suffix, coil resistance over temperature, MOSFET RDS(on) at the released gate voltage, pulsed avalanche/clamp stress, and thermal environment remain component-release work.

## Transistor sizing basis

An 80 mA coil is within the current capability of a reviewed 2N7002P-class device, subject to:

- guaranteed RDS(on) at the actual logic-gate voltage;
- at least 60 V VDS rating;
- drain current and pulsed-current margin;
- package thermal resistance and ambient derating;
- clamp peak voltage below 75% of rated VDS;
- gate pulldown holding the MOSFET off through reset, open drive, and power sequencing.

The 100 Ω gate resistor limits edge current and ringing. The 100 kΩ gate pulldown prevents a floating MOSFET gate. No exact orderable MOSFET or footprint is released by this stopped package.

## Flyback analysis basis

A diode-only clamp would minimize voltage but extend relay release. The selected series Schottky/12 V zener concept raises the turn-off clamp voltage to shorten release while limiting MOSFET drain stress.

Required detailed verification after exact relay selection:

- coil inductance and stored energy, `E = ½LI²`;
- zener pulse energy and repetitive power;
- Schottky forward current and reverse voltage;
- MOSFET peak VDS including wiring/PCB overshoot;
- relay release time across voltage and temperature;
- no coupling-induced false permit or processor reset.

Without exact coil inductance, the energy and release time cannot be closed numerically.

## Failure-mode review

| Failure or state | Required result | Entry-gate disposition |
| --- | --- | --- |
| STOP asserted/open/fault | Permit low, inhibit high, relay off, Sheet 05 disabled | Contract defined |
| Main power invalid | Same; `RELAY_VCC` absent | Contract defined |
| Processor reset | `RESET_VALID` low; permit low | Contract defined |
| Processor crash after reset | Watchdog times out; permit low | **Cannot implement without watchdog-service route** |
| Watchdog input open | Watchdog invalid; permit low | Requires exact watchdog circuit |
| USB-only | Core may run; main-good low, relay and motor branches off | Contract defined |
| Brownout | Permit removed before logic becomes indeterminate | Timing analysis required |
| Relay command stuck high | Permit gate prevents actuation unless all qualifiers valid | Contract defined |
| MOSFET gate open | 100 kΩ pulldown keeps relay off | Planned |
| Clamp open | MOSFET overvoltage risk | Exact-part/layout fault review required |
| Relay contact welded | Coil removal cannot open contact | Product hazard control; no platform safety claim |

## Required resolution package

A narrow architecture/interface resolution is required before Sheet 06 capture:

1. Select an approved processor-originated watchdog-service functional signal.
2. Assign it a unique GPIO without aliasing `RELAY_CMD_MCU`, reserved pins, straps, USB, UART, or motion commands.
3. Add the signal from Sheet 03 through Sheet 00 to Sheet 06.
4. Define name, polarity, reset state, pulse timing, driver type, local pulldown, and partial-power behavior.
5. Confirm `WATCHDOG_VALID` remains local/test-only or add its approved Sheet 09 test-access consumer; do not leave an ambiguous orphan export.
6. Revalidate the GPIO inventory and all affected sheet ports.
7. Issue an accepted ADR or controlled amendment authorizing Package 07R.

The smallest resource options are a reviewed reduction/reallocation or use of one future-reserve GPIO. Either changes the frozen ADR-040 allocation and therefore requires explicit approval.

## Validation

- Confirmed Sheet 06 has no watchdog-service input.
- Confirmed Sheet 03 and ADR-040 allocate no watchdog-service GPIO.
- Confirmed `WATCHDOG_VALID` is a Sheet 06 output but has no implemented Sheet 09 test-access consumer.
- Confirmed ADR-043 prohibits additional Sheet 06 motor/driver enable outputs.
- Confirmed no generic `THROWER_TRIGGER` signal exists in Rev A.
- Confirmed the repository was clean at entry.
- Ran hierarchy and GPIO validation after documentation-only changes.
- Confirmed Sheet 06 remains the circuitry-free placeholder.

Native KiCad ERC is unavailable. No Sheet 06 circuitry exists to run through ERC, and no ERC completion is claimed.

## Stop condition

No KiCad schematic, Sheet 06 circuit, footprint, connector, motor driver, PCB object, or ADR was modified. Package 07 is blocked pending the narrow watchdog-service interface resolution.
