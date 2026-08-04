# Package 07R — Sheet 06 Implementation Record

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Package | 07R |
| Sheet | 06 — Safety Authorization, Independent Watchdog & Output Control |
| Date | 2026-07-30 |
| Status | Preliminary capture complete; component release and native ERC pending |
| Authority | ADR-039 through ADR-044; AR-06 |

> **ECO-011A3 implementation status (2026-08-04):** physical decomposition is blocked before capture. The accepted 40 ms boundary simultaneously requires rejection below 40 ms and acceptance at 40 ms, leaving no realizable tolerance band. Exact watchdog, startup qualifier, latch, authorization, and relay-gate selection remain unreleased; Sheet 06 is unchanged.

## Scope

Package 07R implements the low-energy safety/output-control core on Sheet 06. The already accepted GPIO42 `WATCHDOG_SERVICE_MCU` route on Sheets 03 and 00 is retained. Sheet 06 now contains the independent watchdog/qualifier, authorization logic, relay request gate, low-side MOSFET driver, flyback clamp, relay, and deterministic local biases.

No connector, footprint, PCB object, motor driver, H-bridge, Sheet 07, Sheet 08, or Sheet 09 implementation is included.

## Watchdog implementation

U1 represents the independently powered window-watchdog plus startup qualifier/fault latch required by ADR-044. It is a functional preliminary-capture block; the exact watchdog, edge qualifier, and latch devices remain component-release items.

| Parameter | Preliminary value |
| --- | ---: |
| Firmware transition period | 75 ms nominal |
| Valid transition interval | 40–100 ms |
| Initial qualification | Two valid alternating transitions |
| Absolute loss-of-service response | 250 ms maximum |
| Static high or low | Invalid |
| Too-fast or too-slow transitions | Invalid and latched |
| Recovery | `RESET_VALID` low or power cycle |

The nominal 75 ms interval provides 25 ms margin to each accepted boundary. A two-transition start therefore requires at least 80 ms and normally about 150 ms after application servicing begins. There is no unconditional startup grace: `WATCHDOG_VALID` remains low until `RESET_VALID`, `MAIN_POWER_GOOD`, and two valid transitions are present.

R1 is a 100 kΩ Sheet 06 receiver pull-down. With 3.3 V applied, the producer sources only:

`I = 3.3 V / 100 kΩ = 33 µA`

This dominates CMOS input leakage while negligibly loading GPIO42. During reset, bootloader, an open route, or an unpowered Sheet 03, WDI is static low and cannot qualify.

C1 is the timing-component placeholder. Its released value shall be calculated from the selected watchdog equation so worst-case component and IC tolerances keep the early boundary at or below 40 ms, the normal window at or above 100 ms, and deauthorization at or below 250 ms. An open or short timing component must fail invalid or be mitigated by the selected topology.

## Authorization logic

U2 implements:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

U3 separately implements:

`RELAY_GATE_AUTH = RELAY_CMD_MCU AND ACTUATOR_PERMIT`

Firmware therefore cannot bypass the watchdog, STOP, reset, or main-power qualification. Sheet 06 affects Sheet 05 only through `ACTUATOR_PERMIT` and `MASTER_INHIBIT`.

| MAIN_POWER_GOOD | STOP_HW_INHIBIT | RESET_VALID | WATCHDOG_VALID | ACTUATOR_PERMIT | MASTER_INHIBIT |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 0 | 1 | 1 | 1 | 0 |
| 0 | X | X | X | 0 | 1 |
| X | 1 | X | X | 0 | 1 |
| X | X | 0 | X | 0 | 1 |
| X | X | X | 0 | 0 | 1 |

The relay energizes only when `RELAY_CMD_MCU = 1` and the first row is satisfied.

## Deterministic defaults

All safety-relevant CMOS inputs and outputs have local 100 kΩ bias:

| Net | Bias | Safe result |
| --- | --- | --- |
| `WATCHDOG_SERVICE_MCU` | Down | No service |
| `MAIN_POWER_GOOD` | Down | Not authorized |
| `RESET_VALID` | Down | Not authorized |
| `STOP_HW_INHIBIT` | Up | Inhibit asserted |
| `RELAY_CMD_MCU` | Down | Relay request inactive |
| `WATCHDOG_VALID` | Down | Not authorized |
| `ACTUATOR_PERMIT` | Down | Permit inactive |
| `MASTER_INHIBIT` | Up | Inhibit asserted |
| `RELAY_GATE` | Down | MOSFET off |

At 3.3 V each asserted 100 kΩ bias consumes 33 µA and is readily overcome by a valid CMOS driver. Exact logic thresholds, leakage over temperature, partial-power current, and back-power behavior require validation with released devices.

## Relay and MOSFET calculations

The provisional relay basis is a 5 V, 80 mA SPDT coil:

`Rcoil = 5 V / 0.080 A = 62.5 Ω`

`Pcoil = 5 V × 0.080 A = 0.40 W`

Q1 is a provisional 2N7002P-class 60 V logic-level N-MOSFET. Using a conservative 2 Ω on-resistance:

`VDS(on) = 0.080 A × 2 Ω = 0.16 V`

`Pmosfet = (0.080 A)² × 2 Ω = 12.8 mW`

This is low steady-state dissipation, but release still requires guaranteed `RDS(on)` at the actual 3.3 V gate drive, hot-coil current, pulsed current, thermal derating, and clamp transient margin.

R2 is 100 Ω. For a provisional 1 nF effective gate capacitance:

`τgate = 100 Ω × 1 nF = 0.1 µs`

The resistor limits peak gate-drive current to approximately 33 mA while retaining switching speed far beyond relay requirements. R3 is the 100 kΩ default-OFF bias; with 1 nF effective capacitance its nominal discharge time constant is 100 µs.

## Flyback analysis

D1 represents the series Schottky plus 12 V zener flyback clamp. For coil inductance `L`:

`Ecoil = ½ × L × (0.080 A)²`

For an illustrative 100 mH coil, `Ecoil = 0.32 mJ`. Exact inductance is not yet controlled, so this is not a release value.

With 5 V coil supply, 12 V zener, approximately 0.5 V diode drop, and wiring overshoot, expected MOSFET drain stress is approximately 17.5 V plus overshoot, below 75% of a 60 V rating provided overshoot remains below 27.5 V. Prototype capture must verify peak `VDS`, zener pulse energy, repetitive power, relay release time, and EMI. A diode-only clamp is not used because its slower current decay can delay contact release.

## Startup and shutdown sequence

1. All local biases establish watchdog invalid, permit low, inhibit high, request low, and MOSFET gate low.
2. `+3V3_CORE` powers logic; no authorization occurs from power alone.
3. `RESET_VALID` may rise only after core supervision releases reset.
4. `MAIN_POWER_GOOD` must be valid; USB-only operation cannot satisfy it.
5. Firmware enters the intended application state and produces two in-window transitions.
6. U1 asserts `WATCHDOG_VALID`; U2 may then authorize outputs if STOP remains healthy.
7. Any qualifier loss immediately removes permit. Service loss removes watchdog validity within 250 ms.
8. A timing violation remains latched until reset assertion or power cycle; merely resuming transitions cannot restart outputs.

## Failure-mode review

| Failure/state | Detection and result | Further work |
| --- | --- | --- |
| Service stuck low/high | No valid transitions; watchdog invalid; outputs off | Prototype timeout test |
| Service too fast/slow | Window violation latches invalid | Tolerance test |
| Firmware crash/deadlock/task failure | Service stops or violates window; invalid within 250 ms | Workload fault injection |
| Processor reset/bootloader/update | `RESET_VALID` and service invalid; outputs off | Boot-mode test |
| USB-only | `MAIN_POWER_GOOD` low; outputs off | Partial-power test |
| Sheet 03 absent/open trace | R1 holds WDI low | Continuity fault test |
| Sheet 06 supply lost/brownout | Outputs and local permit collapse; Sheet 05 biases safe | Sequencing test |
| STOP route opens | R6 asserts inhibit | Open-net test |
| Main/reset route opens | R4/R5 deauthorize | Open-net test |
| Relay request stuck high | U3 still requires permit | Logic test |
| MOSFET gate drive opens | R3 holds gate off | Fault injection |
| Flyback clamp opens | Q1 overvoltage risk | Exact-part and transient review |
| Timing component open/short | Must fail invalid | Exact topology FMEA |
| Watchdog output stuck active | Watchdog-channel single-point residual; STOP/main/reset remain effective | Explicit Rev A residual risk |
| Relay contact weld | Coil removal cannot open the contact | Product-level hazard control |

## Validation

- GPIO42 remains uniquely assigned to `WATCHDOG_SERVICE_MCU`.
- Sheet 03 produces and Sheet 06 consumes the signal exactly once.
- Sheet 00 contains exactly two route endpoints.
- `WATCHDOG_VALID` is generated only by Sheet 06.
- Authorization equations and all safe-state biases are present.
- References and UUIDs are checked for uniqueness within each schematic.
- No footprint assignments exist.
- No unauthorized Sheet 07–09 circuitry, connectors, motor drivers, H-bridges, `THROWER_TRIGGER`, or additional motor/driver enable outputs were introduced.

Native KiCad ERC is unavailable in the current environment and remains pending. ERC, exact-device selection, tolerance analysis, SPICE where appropriate, and prototype fault injection are required before schematic release.

## Remaining prototype and release items

- Select exact watchdog, window/edge qualifier, and latch topology.
- Calculate C1 and all timing tolerances from released device equations.
- Verify output fail-low behavior during watchdog undervoltage and partial power.
- Select exact authorization/gate logic with defined power-off behavior.
- Select relay suffix, MOSFET, Schottky diode, and zener.
- Measure coil current, inductance, release time, drain overshoot, and EMI.
- Confirm contact ratings against later product loads.
- Complete native ERC and independent peer review.
