# IPC-100 Rev A Motion Control Interface Control Document

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Authority | ADR-043 / AR-05 |
| Status | Accepted architecture contract for preliminary capture |
| Controlled sheets | 03, 05, 06, and 09 |
| Date | 2026-07-30 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose and precedence

This interface control document (ICD) freezes the actual IPC-100 Rev A two-axis, external motor-driver logic interface. It is the controlling implementation reference for Sheet 05 and the related Sheet 03, Sheet 06, and Sheet 09 boundaries. ADR-043 and this ICD supersede older `TBD`, optional-feedback, or polarity-open statements on subjects controlled here.

IPC-100 provides low-voltage commands and limited driver-logic power. External motor drivers, motor supply, power switching, braking behavior, motors, stopping mechanics, and motor current remain product-owned and off-board.

## 2. Exact Rev A processor command inventory

All processor outputs are active high. During reset the ESP32 pins are high impedance and external 47 kΩ pulldowns establish inactive states.

| Functional net | GPIO | Axis | Type / meaning | Source | Destination | Reset, USB-only, or main loss | Sheet 05 conditioning |
| --- | ---: | --- | --- | --- | --- | --- | --- |
| `AXIS1_RPWM_MCU` | 13 | 1 | Right/forward direction PWM or static request | Sheet 03 | Sheet 05 | Inactive low | Conflict suppression, authorization gate, 3.3-to-5 V translation |
| `AXIS1_LPWM_MCU` | 14 | 1 | Left/reverse direction PWM or static request | Sheet 03 | Sheet 05 | Inactive low | Same |
| `AXIS1_REN_MCU` | 17 | 1 | Right-side driver enable request | Sheet 03 | Sheet 05 | Disabled low | Authorization gate and translation |
| `AXIS1_LEN_MCU` | 18 | 1 | Left-side driver enable request | Sheet 03 | Sheet 05 | Disabled low | Same |
| `AXIS2_RPWM_MCU` | 15 | 2 | Right/forward direction PWM or static request | Sheet 03 | Sheet 05 | Inactive low | Conflict suppression, authorization gate, 3.3-to-5 V translation |
| `AXIS2_LPWM_MCU` | 16 | 2 | Left/reverse direction PWM or static request | Sheet 03 | Sheet 05 | Inactive low | Same |
| `AXIS2_REN_MCU` | 21 | 2 | Right-side driver enable request | Sheet 03 | Sheet 05 | Disabled low | Authorization gate and translation |
| `AXIS2_LEN_MCU` | 38 | 2 | Left-side driver enable request | Sheet 03 | Sheet 05 | Disabled low | Same |

“Axis 1” and “Axis 2” are the only electrical identities. A product may describe them as pan, tilt, pitch, elevation, travel, or another mechanism in product documentation, but those descriptions are not IPC-100 net aliases.

There is no shared `PWM_SPEED`, `MOTOR_ENABLE`, direction bit, or brake command.

ADR-043 originally made no GPIO changes. ADR-044 subsequently allocates GPIO42 to `WATCHDOG_SERVICE_MCU`; GPIO37 remains the sole reserve. Neither is available to motion or fault feedback in Rev A.

## 3. Axis command topology

Each axis uses dual mutually exclusive direction-PWM commands plus two independent external-driver enable requests. No command combination authorizes motor energy by itself.

| RPWM | LPWM | REN | LEN | Electrical interpretation |
| --- | --- | --- | --- | --- |
| 0 | 0 | 0 | 0 | Required neutral/safe state |
| PWM or 1 | 0 | 1 | 1 | Legal R/forward request |
| 0 | PWM or 1 | 1 | 1 | Legal L/reverse request |
| 0 | 0 | Any | Any | No motion command; firmware normally drives enables low |
| Any | Any | 0 | Any | No released motion guarantee; incomplete enable state |
| Any | Any | Any | 0 | No released motion guarantee; incomplete enable state |
| Active | Active | Any | Any | Illegal conflict; Sheet 05 hardware forces both safe-side PWM outputs low |

Firmware owns command intent, valid enable combinations, duty control, and the reversal state machine. Sheet 05 independently suppresses simultaneous opposing PWM requests using combinational logic before translation. The external driver shall tolerate all static input combinations without damage; it shall not be relied on as the sole mutual-exclusion mechanism.

Direction reversal requires RPWM, LPWM, REN, and LEN low for at least 20 ms before the opposite direction is enabled. No automatic resume follows inhibit, reset, timeout, limit release, or power restoration.

The reference BTS7960-style interface normally uses both enables high during a valid motion request. Independent REN/LEN nets are retained for compatibility and controlled testing; they are not permission to drive one half-bridge outside an approved external-driver contract.

## 4. Sheet ownership

| Sheet | Owns | Does not own |
| --- | --- | --- |
| 03 | Eight ADR-040 commands, PWM generation, mutual-exclusion intent, direction/reversal sequence, command freshness | Voltage translation, field protection, actuator authorization |
| 04 | STOP and four supervised limits; conditioned observations to Sheet 03 | Motion output gating or retransmission |
| 05 | MCU-side pulldowns, opposing-PWM hardware suppression, deterministic output defaults, authorization-controlled OE, 3.3-to-5 V translation, 33 Ω damping, safe-side pulldowns, ESD provision, test-node sources, eight safe exports | Limit sensing, position feedback, master authorization generation, relay/motor power switching, connectors |
| 06 | Consume STOP/main/reset/watchdog qualifications; generate `ACTUATOR_PERMIT` and `MASTER_INHIBIT`; gate relay; provide hardware authorization to Sheet 05 | Motor command generation, translation, connectors, motor current |
| 09 | J2/J3 symbols and pinout, connector-entry protection placement, shield/chassis disposition, physical test points | Command generation or authorization |
| Product/external driver | Accept logic contract, contain motor-power faults, implement power stage, braking/coast behavior, motor and mechanics | Backfeeding IPC-100 or treating logic power as motor power |

## 5. Sheet 06 authorization boundary

The sole positive authorization remains:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

Sheet 05 consumes both complementary signals. Translator/output enable requires `ACTUATOR_PERMIT = 1` and `MASTER_INHIBIT = 0`; any disagreement forces outputs inactive. A 100 kΩ hardware default holds OE disabled.

Sheet 06 does not export `DRIVER_ENABLE`, `MOTOR_LOGIC_ENABLE`, or motor commands. It does not switch J2/J3 logic power. Sheet 02 provides separate main-qualified `MOTOR_LOGIC_5V_A/B` branches; loss of either branch makes its associated external interface unavailable. Sheet 06 affects the external motor-driver system only through the Sheet 05 authorization gate and its independent relay function.

`STOP_HW_INHIBIT` routes only to Sheet 06. Sheet 05 never consumes or reinterprets STOP directly.

## 6. Sheet 05-to-09 destination contract

| Safe net | Direction | Domain / polarity | Series and default | Destination |
| --- | --- | --- | --- | --- |
| `AXIS1_RPWM_SAFE` | Out | 5 V main-only; high/PWM active | 33 Ω source; 10 kΩ pulldown | Sheet 09 J2 |
| `AXIS1_LPWM_SAFE` | Out | Same | Same | Sheet 09 J2 |
| `AXIS1_REN_SAFE` | Out | 5 V main-only; high enabled | Same | Sheet 09 J2 |
| `AXIS1_LEN_SAFE` | Out | Same | Same | Sheet 09 J2 |
| `AXIS2_RPWM_SAFE` | Out | 5 V main-only; high/PWM active | Same | Sheet 09 J3 |
| `AXIS2_LPWM_SAFE` | Out | Same | Same | Sheet 09 J3 |
| `AXIS2_REN_SAFE` | Out | 5 V main-only; high enabled | Same | Sheet 09 J3 |
| `AXIS2_LEN_SAFE` | Out | Same | Same | Sheet 09 J3 |

Use two independent four-channel SN74LXC4T245-class translators, one per axis. Both A-sides use `+3V3_CORE`; Axis 1 B-side uses `MOTOR_LOGIC_5V_A`; Axis 2 B-side uses `MOTOR_LOGIC_5V_B`. Direction is fixed A-to-B and each device requires Ioff/partial-power behavior plus authorization-controlled OE. Exact orderable/Q1 suffix remains a component-release item, but an eight-channel device shared across the two separately protected B-side rails is prohibited.

Connector-side low shall be ≤0.4 V and high shall be compatible with 5 V logic at ≤2 mA per signal. Each J2/J3 protected logic-power branch is limited to 100 mA preliminary. External equipment shall share IPC-100 logic ground and present no signal or supply voltage when IPC-100 is off.

J2/J3 are Micro-Fit 3.0-class, six-circuit, internal-board harness connections. The released logic harness is ≤1 m, ≤500 pF per signal, 18–26 AWG stranded copper, routed away from motor leads and switching nodes. Longer or externally exposed wiring requires a new EMC/interface review. Baseline wiring is unshielded; any required shield terminates to chassis/enclosure at Sheet 09 and never carries logic or motor return.

Sheet 05 owns per-channel ESD-array provision and damping; Sheet 09 owns physical placement at connector entry. Final PCB capture shall coordinate one protection device per path, not duplicate it.

## 7. Reset and failure states

| Condition | Required Sheet 05 result |
| --- | --- |
| Power-up/reset/boot ROM | MCU-side and safe-side pulldowns low; OE disabled |
| USB-only core power | `MOTOR_LOGIC_5V_A/B` absent; OE disabled; safe outputs low/unpowered |
| Main brownout or loss | Sheet 06 removes permit and Sheet 02 removes interface power; safe outputs become low before or during collapse |
| STOP asserted/faulted | Sheet 06 removes permit; Sheet 05 outputs inactive within 1 ms |
| Watchdog/reset invalid | Same |
| Permit/inhibit disagreement | OE disabled |
| Translator A-side only powered | No B-side drive or backfeed |
| Translator B-side/external side powered first | Ioff prevents core backfeed; outputs do not become active |
| Both PWM inputs active | Hardware forces both safe PWM outputs low |
| Command timeout | Firmware clears all eight MCU requests before watchdog timeout; hardware watchdog remains independent |
| Authorization restored | Outputs remain neutral until firmware validates state and issues a new command |

## 8. Timing contract

| Attribute | Rev A contract |
| --- | --- |
| PWM operating range | 10–25 kHz; 20 kHz nominal |
| Firmware PWM resolution | At least 10-bit command resolution at 20 kHz where the ESP32 clock configuration supports it |
| Guaranteed passed pulse width | ≥1 µs; shorter pulses are not a released external-driver command |
| Logic edge target | Approximately 100 ns after 33 Ω damping; verify with final load/cable |
| Sheet 05 command propagation | ≤500 ns for a stable authorized path, excluding external driver |
| Authorization removal | All safe outputs inactive within 1 ms of permit loss/inhibit assertion |
| Authorization assertion | Hold MCU commands neutral; wait at least 1 ms after stable permit and interface power before enabling commands |
| Direction reversal | All four axis requests low for ≥20 ms |
| Firmware command freshness | Clear motion request if no valid refresh within 200 ms |
| Watchdog | Independent 250 ms nominal timeout; serviced from supervised task at 50–100 ms |
| Brownout/USB-only | Asynchronous hardware disable; no firmware timing dependency |

These are interface requirements, not a motor stopping-distance claim. Product mechanics and external-driver delays require separate validation.

## 9. Limit, position, and feedback exclusions

STOP and the four limits remain Sheet 04-to-03 observations. Firmware applies direction-aware limit policy; Sheet 05 neither consumes nor retransmits them.

Rev A has no allocated:

- home/reference input;
- motor position encoder;
- driver-ready input;
- overcurrent or thermal-fault input;
- individual or aggregated motor-driver fault input;
- brake-state feedback; or
- command/readback GPIO.

These are future-revision features requiring an ADR, GPIO/resource allocation, hierarchy update, and connector contract.

## 10. `OUTPUT_FAULT_SUMMARY` disposition

### Options considered

| Option | Producer / consumer | Polarity, latch, reset | Safety and resource impact | Disposition |
| --- | --- | --- | --- | --- |
| A — processor input | Sheet 05 to new/aliased GPIO | Would require active/fault definition and firmware latch | No free GPIO; aliasing would corrupt semantics | Rejected |
| B — hardware inhibit | Sheet 05 to Sheet 06 | Would require fail-safe polarity and independent fault sources | No approved driver feedback; could create false safety claim | Rejected |
| C — local test signal | Sheet 05 only | Could be active high, non-latched | No actual Rev A fault producer exists | Rejected as misleading |
| D — remove from Rev A | None | Not applicable | No GPIO or hardware impact | **Selected** |
| E — future revision | Future reviewed producer/consumer | Defined by future ADR | Preserves expansion without orphan net | Accepted only as a future concept |

`OUTPUT_FAULT_SUMMARY` is removed from Sheet 00, Sheet 05, interface tables, and Rev A validation expectations. No replacement net is created. Commanded state and test nodes do not prove driver or motor action.

## 11. Package 06R authorization

The Sheet 05 architecture entry gate is closed by ADR-043. Package 06R is authorized to implement:

- only the eight ADR-040 `AXIS1/2_*_MCU` commands;
- opposing-PWM hardware suppression;
- deterministic MCU-side and safe-side defaults;
- authorization-controlled buffering and voltage translation;
- 33 Ω series damping and approved protection provisions;
- eight `AXIS1/2_*_SAFE` exports to Sheet 09; and
- schematic-only command test-node sources.

Package 06R shall not add limits, position feedback, fault inputs, motor drivers, relay circuitry, connectors, footprints, GPIOs, or authorization generation. No additional architecture package is expected before Sheet 05 preliminary capture.
