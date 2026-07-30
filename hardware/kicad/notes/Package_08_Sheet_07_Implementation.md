# Package 08 — Sheet 07 Implementation Record

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Package | 08 |
| Sheet | 07 — User Interface & Local Controls |
| Date | 2026-07-30 |
| Status | Preliminary capture complete; exact parts, connectors, footprints, native ERC, and prototype validation pending |
| Authority | ADR-039 through ADR-044; MFG-01 |

## 1. Scope

Sheet 07 implements only the frozen local-interface functions:

- three ordinary rotary-encoder inputs;
- the core-powered I²C GPIO expander required by ADR-040;
- RGB and buzzer low-side drive boundaries;
- fail-asserted open-drain OLED reset;
- OLED and environmental-sensor I²C functional boundaries;
- base-bus I²C pull-ups;
- schematic DFT nodes.

Sheet 07 does not contain STOP, ARM, FIRE, analog speed, mode, motion, relay, watchdog, actuator authorization, connector, or raw GPIO circuitry. UI inputs are requests interpreted by firmware and have no independent authority.

## 2. Authoritative Interfaces

| Signal | Producer | Consumer | Direction at Sheet 07 | Domain | Polarity/default | Classification |
| --- | --- | --- | --- | --- | --- | --- |
| `+3V3_CORE` | Sheet 02 | Sheet 07 | Input | 3.3 V core | Available from valid main or USB | Core logic power |
| `UI_VCC` | Sheet 02 | Sheet 07 | Input | 5 V main-only | Off until `UI_POWER_REQ` and main qualification | Panel-interface power |
| `OLED_VCC` | Sheet 02 | Sheet 07 | Input | 3.3 V switched/main-qualified | Off until `OLED_POWER_REQ` | Display power |
| `SENSOR_VCC` | Sheet 02 | Sheet 07 | Input | 3.3 V switched/main-qualified | Off until `SENSOR_POWER_REQ` | Sensor power |
| `ENCODER_A_RAW` | Sheet 09/panel | Sheet 07 | Input | UI field domain | Open/disconnected inactive | Ordinary UI input |
| `ENCODER_B_RAW` | Sheet 09/panel | Sheet 07 | Input | UI field domain | Open/disconnected inactive | Ordinary UI input |
| `ENCODER_SW_RAW` | Sheet 09/panel | Sheet 07 | Input | UI field domain | Open/disconnected inactive | Ordinary UI input |
| `ENCODER_A_COND` | Sheet 07 | Sheet 03 GPIO10 | Output | 3.3 V logic | Active high; default low | Firmware request |
| `ENCODER_B_COND` | Sheet 07 | Sheet 03 GPIO11 | Output | 3.3 V logic | Active high; default low | Firmware request |
| `ENCODER_SW_COND` | Sheet 07 | Sheet 03 GPIO12 | Output | 3.3 V logic | Active high; default low | Firmware request |
| `I2C_SDA` | Sheet 03 GPIO47/shared bus | Sheet 07 devices | Bidirectional | 3.3 V core | Open-drain; core pull-up | Non-safety bus |
| `I2C_SCL` | Sheet 03 GPIO48 | Sheet 07 devices | Bidirectional | 3.3 V core | Open-drain; core pull-up | Non-safety bus |
| `RGB_R/G/B` | Sheet 07 expander/driver | Sheet 09 load boundary | Output | Main-only open drain | Active sink; default off | Supplemental status |
| `BUZZER_OUT` | Sheet 07 expander/driver | Sheet 09 load boundary | Output | Main-only open drain | Active sink; default silent | Audible status |
| `OLED_RESET` | Sheet 07 | Sheet 09/OLED | Output | Open drain | Active low; default asserted | Peripheral control |

GPIO37 remains reserved. GPIO42 remains exclusively `WATCHDOG_SERVICE_MCU`. The former GPIO numbers shown for moved UI functions are historical only; all five outputs are produced by U2 over I²C.

## 3. UI Function Inventory

| Function | Implementation | Safety relationship | Release status |
| --- | --- | --- | --- |
| Rotary phase A/B | U1 conditioned active-high observations | Firmware request only | Preliminary |
| Encoder push | U1 conditioned active-high observation | Firmware request only; not STOP | Preliminary |
| RGB status | U2 controls U3 low-side sinks | Supplemental indication only | Load contract open |
| Buzzer | U2 controls U3 low-side sink | Supplemental indication only | Transducer/load contract open |
| OLED reset | U2 release command through Q1 fail-asserted open drain | No actuator role | Preliminary |
| OLED bus/power boundary | U4, I²C plus switched `OLED_VCC` | Optional peripheral | Exact module open |
| Sensor bus/power boundary | U5, I²C plus switched `SENSOR_VCC` | Optional peripheral | Exact module open |

ARM, FIRE, and supervised STOP remain Sheet 04 functions. No separate local start, manual-axis, relay/fire, maintained-mode, or speed-adjustment interface exists on the frozen Sheet 07 boundary, so none was added.

## 4. Input Conditioning

U1 is the preliminary three-channel panel-interface conditioner. Each channel includes the controlled functional equivalent of:

- 10.0 kΩ UI-domain pull-up;
- 1.0 kΩ series current limiting/damping;
- 10 nF X7R filter;
- 3.3 V Schmitt receiver with UI-power-valid gating;
- low-capacitance ESD provision at the later connector boundary.

The contact is active low at the panel. U1 inverts it to an active-high `_COND` observation. An open contact, open harness, disconnected panel, absent `UI_VCC`, reset, USB-only operation, or unpowered conditioner produces a low/inactive conditioned output.

For 10 kΩ and 10 nF:

`τ = R × C = 10,000 Ω × 10 nF = 100 µs`

`fc = 1 / (2πRC) ≈ 1.59 kHz`

This suppresses fast edge noise without masking manual quadrature transitions. It does not eliminate mechanical bounce; firmware shall debounce the push switch and apply a quadrature state-machine/no-illegal-transition filter. A provisional 5–20 ms firmware switch debounce is appropriate and must be validated against the selected encoder.

With the contact closed from 5 V through 10 kΩ:

`Icontact = 5 V / 10 kΩ = 0.50 mA`

This is compatible with gold-contact mechanical encoders but requires verification against the selected contact’s minimum wetting current and cable environment.

## 5. Display Interface

U4 records the 2.42-inch SSD1309 OLED as a reference implementation, not a released component or connector. The frozen interface is:

- `OLED_VCC` from the Sheet 02 switched 3.3 V branch;
- `I2C_SDA`;
- `I2C_SCL`;
- active-low open-drain `OLED_RESET`;
- ground.

Q1 keeps reset asserted by default from the core domain. The expander must intentionally command release only after firmware has requested `OLED_VCC`, allowed rail settling, and confirmed bus readiness. An open Q1 control path, expander reset, firmware reset, or bus failure leaves reset asserted. The drain cannot source current into an unpowered display.

Because I²C pull-ups remain powered during USB-only service while OLED and sensor rails are off, released modules must tolerate unpowered bus pins without backfeed. Otherwise their final interface shall add series isolation or bus switching without changing the frozen logical signals.

## 6. Indicator Drivers

U2 is a provisional TCA9535-class 16-bit I²C GPIO expander:

- powered from `+3V3_CORE`;
- preliminary address `0x20` with address straps low;
- power-up ports input/high-impedance;
- 100 kΩ/100 nF reset network;
- five used outputs and remaining channels reserved locally, not exported.

U3 represents four independent 60 V logic-level N-MOSFET sinks. Each control has a 100 Ω gate resistor and 100 kΩ gate pull-down. RGB and buzzer loads receive power only from the main-only `UI_VCC` domain, so USB-only operation cannot energize them even if the core and expander are powered.

The `RGB_R/G/B` outputs are open-drain sink boundaries. Final LED current resistors depend on the Sheet 09/load contract. For a provisional 5 mA common-anode RGB load from 5 V:

- red, `VF = 2.0 V`: `R = (5 − 2.0) / 5 mA = 600 Ω`; use 620 Ω preliminary;
- green/blue, `VF = 3.0 V`: `R = (5 − 3.0) / 5 mA = 400 Ω`; use 402 Ω preliminary.

These resistors belong with the released indicator/load implementation and are not assigned on Sheet 07 before J8 partitioning.

At 20 mA and a conservative 2 Ω MOSFET on-resistance:

`P = I²R = (0.020 A)² × 2 Ω = 0.8 mW`

At a provisional 80 mA buzzer current:

`P = (0.080 A)² × 2 Ω = 12.8 mW`

U3 includes a flyback-clamp provision to `UI_VCC` for a magnetic transducer. The final active buzzer, passive piezo, or magnetic device determines whether a clamp is fitted and its energy rating. A piezo must not be treated as an inductive load.

## 7. UI Power Behavior

Sheet 03 owns `UI_POWER_REQ`, `OLED_POWER_REQ`, and `SENSOR_POWER_REQ`; Sheet 02 owns all switches, request pull-downs, main qualification, controlled rise, and discharge. Sheet 07 adds no parallel power path.

| State | `+3V3_CORE` | `UI_VCC` | `OLED_VCC` / `SENSOR_VCC` | Required Sheet 07 behavior |
| --- | --- | --- | --- | --- |
| No power | Off | Off | Off | All outputs electrically inactive |
| USB only | On | Off | Off | Expander may enumerate; RGB/buzzer off, OLED reset asserted, encoder unavailable |
| Main before initialization | On | Off | Off | Same safe defaults |
| Main after approved requests | On | On as requested | On as requested | Firmware may use UI/peripherals |
| Processor reset | May remain on | Hardware request gates off | Off | Expander high-Z; sinks off; OLED reset asserted |
| Brownout/main loss | Core may transfer to USB | Off | Off | No backfeed; commands inactive |
| Panel disconnected | As above | As above | As above | Encoder outputs inactive; other core functions unaffected |

## 8. Electrical Calculations

### I²C base pull-ups

R2/R3 are 4.70 kΩ ±1% to `+3V3_CORE`. Static low current per line is:

`IOL = 3.3 V / 4.70 kΩ = 0.702 mA`

For a controlled base-bus capacitance of 200 pF:

`tr ≈ 0.8473 × R × C = 0.8473 × 4.70 kΩ × 200 pF = 0.796 µs`

This supports 100 kHz standard-mode I²C with the preliminary 1 µs rise-time limit. Operation at 400 kHz requires a lower capacitance, lower pull-up resistance, or segmented bus and is not released by Package 08. OLED, sensor, and expansion populations shall not add parallel pull-ups without recalculation.

### Expander reset

R1 = 100 kΩ and C1 = 100 nF:

`τreset = 10 ms`

The actual reset-release time depends on the selected expander input threshold. The network ensures output stages remain high-impedance during the early core ramp, but exact POR/reset timing and discharge behavior remain release tests.

### Default loads

A 100 kΩ gate bias at 3.3 V loads an active expander output by 33 µA. Five simultaneously active biases are less than 0.17 mA. The 100 Ω gate resistors limit instantaneous current and edge ringing without affecting human-interface timing.

## 9. Default-State Table

| Function/net | Passive/default mechanism | Disconnected/unpowered state |
| --- | --- | --- |
| Encoder A/B/SW | UI-domain bias plus U1 UI-valid gate | `_COND` low/inactive |
| U2 expander outputs | POR/reset makes ports input/high-Z | No drive |
| RGB gates | 100 kΩ pull-downs in U3 | Off |
| Buzzer gate | 100 kΩ pull-down in U3 | Silent |
| RGB/buzzer power | Main-qualified `UI_VCC` from Sheet 02 | Off |
| OLED reset | Core pull-up drives open-drain assert stage | Asserted low or non-driving at unpowered OLED |
| OLED/sensor power | Sheet 02 main-qualified request switches | Off |
| I²C bus | Core pull-ups | High when core powered; module isolation required when branches off |

## 10. Failure-Mode Review

| Failure/state | Result | Safety disposition / follow-up |
| --- | --- | --- |
| Processor reset/crash | Expander not intentionally driven; outputs default off/reset | Cannot authorize actuator |
| USB-only | UI/OLED/sensor branches off | No indicator/buzzer activation or panel command |
| Brownout | Main-only rails collapse; passive defaults dominate | No actuator authority |
| UI power loss | U1 forces encoder conditioned outputs inactive | Firmware sees no command |
| Panel disconnected/open contact | Encoder inactive | Benign |
| Button/encoder contact short | One command may remain asserted | Firmware debounce/stuck-input diagnostic; still only a request |
| Encoder phases shorted together | Invalid quadrature or common transition | Firmware illegal-state rejection |
| I²C line stuck | UI expander/display/sensor unavailable | Nonfatal; no hardware authorization dependency |
| Expander output stuck active | One status/buzzer/reset command may remain active if its load rail exists | Branch fault containment; no Sheet 06 bypass |
| Display unpowered | Q1 remains asserted/open drain; module must not backfeed from bus | Exact module test |
| Sensor unpowered | Module must not backfeed from bus | Exact module test |
| OLED reset driver open | Display-only fault | Nonfatal |
| RGB driver short | One indicator may remain on; UI branch must contain fault | Final current limit/load contract |
| Buzzer driver short | Buzzer may remain on; UI branch must contain fault | Final load/clamp/current-limit review |
| ESD at panel | U1 series/filter/ESD boundary contains transient | Exact IEC profile and Sheet 09 placement open |
| Connector unplugged | Encoder inactive; output loads open | Other controller functions unaffected |

No Sheet 07 failure creates `ACTUATOR_PERMIT`, clears `MASTER_INHIBIT`, drives a motor command, or energizes the relay.

## 11. DFM/DFT Provisions

Schematic DFT nodes TP1–TP5 identify:

- `UI_VCC`;
- `OLED_VCC`;
- `I2C_SDA`;
- `I2C_SCL`;
- representative `ENCODER_A_COND`.

Additional encoder and status-control nodes are net-labeled for later fixture access. Physical test pads, probe sizes, datums, and footprints remain Sheet 09/PCB DFT work.

Recommended manufacturing checks:

1. Verify all encoder raw open/closed states and conditioned polarity.
2. Sweep phase A/B transitions and reject illegal quadrature.
3. Confirm loss of `UI_VCC` forces all `_COND` outputs low.
4. Measure I²C idle voltage, low-level current, rise time, and expander address.
5. Cycle expander reset and verify every output is high-impedance.
6. Command RGB and buzzer channels individually and together with bounded fixture loads.
7. Verify OLED reset remains asserted until the release sequence.
8. Cycle OLED/sensor rails and measure signal-pin backfeed current.
9. Test USB-only and main brownout behavior.
10. Exercise open/short load faults without disturbing core, safety, motion, or authorization.

Panel-connected encoder, RGB, buzzer, OLED, and sensor signals require connector-entry ESD treatment on Sheet 09. DFT probing must not add material capacitance to I²C during normal operation.

## 12. Validation Results

- Sheet 07 ports match Sheet 00 exactly.
- All GPIO-backed functions match ADR-040/ADR-044.
- GPIO37 remains reserved.
- GPIO42 remains exclusively `WATCHDOG_SERVICE_MCU`.
- No raw GPIO label exists outside Sheet 03.
- Encoder inputs have deterministic inactive defaults.
- RGB/buzzer default off and OLED reset defaults asserted.
- No Sheet 07 path enters Sheet 06 authorization.
- No new safety, motor, relay, thrower, or watchdog interface exists.
- No connector symbol or footprint was added.
- References and UUIDs are unique.
- KiCad S-expressions and hierarchy pass repository validation.

## 13. Remaining Open Design Items

- ODI-DS-001 through ODI-DS-007: exact OLED/sensor compatibility, selection, bus, and placement.
- ODI-OUT-006/007/011: RGB/buzzer loads, drivers, and external protection.
- ODI-CONN-001 and ODI-CONN-009: J8 partition and harness grouping.
- ODI-SCH-009: preliminary expander implementation captured; exact device, POR, backfeed, and bus-fault validation remain.
- MFG-01 major observations: exact parts, AVL/BOM, footprints, power/thermal/transient/mechanical/RF closure, and prototype validation remain open.

## 14. Native ERC Status

`kicad-cli` is unavailable in the current environment. Native ERC was not run and remains mandatory before schematic release. Repository structural validation is not represented as ERC completion.

## 15. Manual Review Checklist

- [x] Frozen Sheet 07 ports used without additions.
- [x] No GPIO37 consumption or GPIO42 change.
- [x] Encoder inputs are request-only and deterministic.
- [x] No ordinary UI input is represented as emergency STOP.
- [x] I²C pull-up ownership and preliminary speed/capacitance are documented.
- [x] Expander starts high-impedance.
- [x] RGB/buzzer outputs are main-only and default off.
- [x] OLED reset is fail-asserted and open drain.
- [x] Sheet 02 retains all switched-rail ownership.
- [x] Unpowered-peripheral backfeed remains an explicit release test.
- [x] DFT nodes are identified without footprints.
- [x] No connectors, footprints, PCB objects, or Sheet 08/09 circuits were added.
- [ ] Run native ERC.
- [ ] Select exact devices and validate tolerance/partial-power behavior.
- [ ] Complete Sheet 09 connector/ESD implementation.
- [ ] Complete prototype electrical, EMC, and fault testing.
