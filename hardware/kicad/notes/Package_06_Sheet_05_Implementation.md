# Package 06 — Sheet 05 Entry-Gate Review

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Package | 06 |
| Sheet | 05 — Motor Driver Interfaces |
| Date | 2026-07-30 |
| Status | Historical entry-gate stop; resolved by AR-05 / ADR-043 |

## Decision

Package 06 could not be implemented as requested without violating the frozen ADR-040/ADR-042 allocation and the accepted Sheets 03–06/09 ownership boundary. In accordance with the instruction to treat the authoritative interfaces as frozen, `sheets/05_Motor_Interfaces.kicad_sch` remained the Package 01 circuitry-free placeholder. AR-05 subsequently accepted ADR-043 and the Motion Control Interface Control Document, resolving the conflicts without populating Sheet 05.

No Sheet 05 symbol, net, port, UUID, reference, or footprint was changed.

## Frozen Rev A motion contract

The authoritative documents currently define this implementation:

| Function | Producer | Sheet 05 role | Consumer |
| --- | --- | --- | --- |
| `AXIS1_RPWM_MCU` | Sheet 03 / GPIO13 | Gate and translate 3.3 V to main-only 5 V | `AXIS1_RPWM_SAFE` to Sheet 09 / J2 |
| `AXIS1_LPWM_MCU` | Sheet 03 / GPIO14 | Same | `AXIS1_LPWM_SAFE` to Sheet 09 / J2 |
| `AXIS1_REN_MCU` | Sheet 03 / GPIO17 | Same | `AXIS1_REN_SAFE` to Sheet 09 / J2 |
| `AXIS1_LEN_MCU` | Sheet 03 / GPIO18 | Same | `AXIS1_LEN_SAFE` to Sheet 09 / J2 |
| `AXIS2_RPWM_MCU` | Sheet 03 / GPIO15 | Same | `AXIS2_RPWM_SAFE` to Sheet 09 / J3 |
| `AXIS2_LPWM_MCU` | Sheet 03 / GPIO16 | Same | `AXIS2_LPWM_SAFE` to Sheet 09 / J3 |
| `AXIS2_REN_MCU` | Sheet 03 / GPIO21 | Same | `AXIS2_REN_SAFE` to Sheet 09 / J3 |
| `AXIS2_LEN_MCU` | Sheet 03 / GPIO38 | Same | `AXIS2_LEN_SAFE` to Sheet 09 / J3 |
| `ACTUATOR_PERMIT` | Sheet 06 | Enable translator only while active high | Sheet 05 hardware |
| `MASTER_INHIBIT` | Sheet 06 | Complementary active-high forced-safe qualification | Sheet 05 hardware |

AR-05 resolves the preliminary implementation to two independent four-channel SN74LXC4T245-class translators: both A-sides use `+3V3_CORE`, while the B-sides separately use `MOTOR_LOGIC_5V_A` and `MOTOR_LOGIC_5V_B`. Direction is A-to-B and output enable is controlled by authorization. Each channel uses a 47 kΩ MCU-side pulldown, 10 kΩ safe-side pulldown, 33 Ω output series resistor, and low-capacitance ESD provision. PWM is nominally 20 kHz with no RC capacitor.

## Conflicts in the Package 06 request

### Command names and resources

The request names:

- `PAN_LEFT_CMD`
- `PAN_RIGHT_CMD`
- `TILT_UP_CMD`
- `TILT_DOWN_CMD`
- `MOTOR_ENABLE`
- `PWM_SPEED`

None exists in ADR-040, the GPIO allocation, Sheet 03, Sheet 05, or Sheet 00. The approved interface instead has eight independent `AXIS1/2_*_MCU` commands. Implementing the requested names would invent aliases, collapse independent enables/PWM channels, or require new GPIOs.

### Position and limit ownership

ADR-042 routes the four conditioned limits from Sheet 04 directly to Sheet 03. Sheet 05 has no limit input ports and does not own direction-aware firmware policy. Home/reference and future position-encoder signals are explicitly absent from Rev A. Adding them would require allocation and hierarchy changes.

### Sheet 06 versus Sheet 09 consumer

The request describes Sheet 05 as feeding high-current actuator circuitry on Sheet 06 and directs its outputs to Sheet 06. The frozen hierarchy assigns:

- Sheet 06: watchdog, `ACTUATOR_PERMIT`, `MASTER_INHIBIT`, and relay authorization/drive;
- Sheet 05: motor-logic gating and translation; and
- Sheet 09: J2/J3 motor-driver logic connectors.

External drivers and all motor-current paths are product-owned and off-board. Sheet 06 has no motor-command input ports. Routing motor commands there would duplicate or expand Sheet 06 ownership.

### Fault and feedback inventory

No Rev A GPIO or approved wire is allocated for driver fault, overcurrent, thermal, ready, position, or command readback. The Output Electrical Architecture Review states that driver status/readback is not locked and must not be implied.

The Package 01 hierarchy still includes `OUTPUT_FAULT_SUMMARY` as a Sheet 05 output, but no accepted processor GPIO or other consumer exists. Its adoption, polarity, producer, and consumer are unresolved. Preliminary capture must remove it or explicitly adopt it through a controlled decision; it cannot be left as an unexplained export.

### Gating source

The frozen design does not route `STOP_HW_INHIBIT` to Sheet 05. Sheet 06 consumes STOP and generates the sole authorization:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

Sheet 05 consumes these Sheet 06 results. Adding a direct STOP path would duplicate safety qualification and violate ownership.

## Validation performed

- Confirmed the working tree was clean at Package 06 entry.
- Compared the Package 06 request with ADR-040, ADR-042, the External Safety ICD, hierarchy definition, GPIO allocation, quantitative component selection, and Sheets 00/03/04/05/06/09 boundaries.
- Confirmed all 36 processor GPIOs remain allocated or reserved.
- Confirmed Sheet 06 has no motor-command consumer ports.
- Confirmed Sheet 05 remains unchanged.
- KiCad ERC was not run because no circuit was implemented and native `kicad-cli` is unavailable.

## Smallest resolution package

Create **Architecture Resolution Package AR-05 — Rev A Motion Interface Contract Alignment**. It should not redesign the established motor interface. It should:

1. affirm the eight `AXIS1/2_*_MCU` to `AXIS1/2_*_SAFE` channels as the only Rev A motion-command inventory;
2. affirm Sheet 09/external drivers, not Sheet 06, as their consumers;
3. affirm that limits remain Sheet 04-to-03 and that Sheet 05 has no position-feedback ownership;
4. affirm that STOP reaches Sheet 05 only through Sheet 06 authorization outputs;
5. reject or explicitly allocate every requested PAN/TILT/shared-enable/shared-speed/feedback signal;
6. remove `OUTPUT_FAULT_SUMMARY` from the Rev A hierarchy unless a producer, consumer, polarity, and resource are approved; and
7. issue a corrected Package 06R mission using the frozen SN74LXC8T245 quantitative contract.

No GPIO change is recommended. The smallest disposition is to reject the unallocated signals and remove the orphan summary port.

## Manual review checklist

- [x] Processor motion-command names checked against ADR-040.
- [x] Sheet 05 input/output ports checked against Sheet 00.
- [x] Sheet 06 and Sheet 09 consumers checked.
- [x] Limit and position-feedback ownership checked.
- [x] Diagnostic resources checked.
- [x] Sheet 05 confirmed unchanged.
- [x] AR-05 accepted.
- [x] Corrected Package 06R authorized.

## Handoff

Package 07 is not ready because Sheet 05 has not been implemented. After AR-05 acceptance, the next package should be **IPC-100 Rev A Preliminary KiCad Capture Package 06R — Sheet 05 Motor-Driver Logic Gating, Translation & External Interface Protection**.
