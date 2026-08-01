# Package 04R — Sheet 03 Implementation Record

> **ADR-044 amendment (2026-07-30):** GPIO42 now produces `WATCHDOG_SERVICE_MCU` to Sheet 06. GPIO37 remains the sole no-connect future reserve. No other Sheet 03 allocation changed.

## Status

Sheet 03 ESP32-S3 Core, Boot, Programming & Recovery is implemented for preliminary capture under ADR-039, ADR-040, and ADR-041. This is a peer-review baseline, not a released schematic or PCB-layout authorization.

No Sheet 04 circuitry, application hardware, external connector, footprint, or PCB object is included.

## ESP32 module

| Item | Preliminary implementation |
| --- | --- |
| Module | ESP32-S3-WROOM-1-N8 |
| Flash | 8 MB Quad-SPI |
| PSRAM | None |
| Temperature basis | –40 °C to +85 °C module family |
| Core supply | `+3V3_CORE`, 3.3 V ±5% target |
| Peak allocation | 700 mA preliminary transient allocation |
| Clock | Module-integrated oscillator; no external crystal |
| RF | PCB antenna module; datasheet antenna keepout mandatory |

All module ground pins and exposed pad are assigned to logic ground. GPIO3, GPIO45, and GPIO46 are intentionally unconnected strapping pins. GPIO37 and GPIO42 are intentionally unconnected future reserves. No raw GPIO name crosses the Sheet 03 boundary.

The preliminary symbol uses the current ESP32-S3-WROOM-1 pin numbering and functional names. Exact library-symbol provenance, module order code, footprint, antenna geometry, courtyard, and keepout remain release items.

## Power and decoupling

- C1: 22 µF effective low-ESR bulk.
- C2: 1 µF X7R local bypass.
- C3: 100 nF X7R high-frequency bypass.
- C6: 100 nF TPS3890-Q1 local bypass.
- Every capacitor returns directly to the local logic-ground structure.
- The 22 µF value is an effective-capacitance requirement after bias, temperature, aging, and tolerance.
- The module exposes one 3V3 supply pin; no external analog rail, oscillator supply, or invented regulator is added.

Place the high-frequency bypass nearest the module 3V3/GND pins, then the 1 µF capacitor, with bulk nearby. Keep the return loop short and prevent switching-current return from sharing the RF/module bypass path.

## Core supervision and reset

U2 is represented as TPS389030-Q1:

- VDD and SENSE monitor `+3V3_CORE`.
- MR is held inactive high.
- The fixed threshold is approximately 2.89 V falling for the 3.0 V family suffix.
- C305 is corrected by ECO-009 to 93.1 nF ±1% C0G/NP0 for 99.642 ms nominal by the TPS3890-Q1 equation. The exact U302 suffix and an accepted minimum/maximum release window remain open.
- Open-drain reset is pulled up by R1, 10 kΩ.
- C4, 1 µF, is the Espressif EN RC starting value.
- SW1 is a normally-open RESET pushbutton to ground.
- The external functional `ESP_EN` fixture input may also pull the node low.

The active-high released node drives module EN/CHIP_PU and exports `RESET_VALID`.

`RESET_VALID` means the core rail is supervisor-qualified and hardware reset is released, so the processor may begin instruction execution. It does not prove application firmware initialization, watchdog service, peripheral initialization, or actuator authorization.

`CORE_POWER_GOOD` remains the local supervisor condition represented by this release state. It is not a hierarchical port. `MAIN_POWER_GOOD`, `MAIN_INPUT_VALID`, and `POWER_FAULT_SUMMARY` are not consumed by Sheet 03.

The 1 µF EN capacitor and supervisor output share the reset node. Release timing, reset assertion time, manual-reset discharge, power cycling, brownout behavior, and source-transition waveforms require prototype validation.

## Boot implementation

- GPIO0 uses R2, 10 kΩ, to `+3V3_CORE`.
- SW2 is a normally-open BOOT pushbutton to ground.
- The external functional `ESP_BOOT` fixture input terminates on the same strap node.
- No high-value GPIO0 capacitor is fitted.
- GPIO3, GPIO45, and GPIO46 remain unloaded.

Normal boot occurs with GPIO0 released high. Manual joint-download recovery:

1. hold BOOT/GPIO0 low;
2. pulse RESET/EN low;
3. release RESET/EN;
4. release BOOT after download mode is entered;
5. program through native USB or UART0;
6. reset with GPIO0 released to verify normal boot.

The fixture shall meet the ESP32-S3 strap setup/hold requirements and shall not drive an unpowered module.

## USB implementation

Sheet 03 implements only the MCU-side USB 2.0 Serial/JTAG boundary:

- GPIO19 is native USB D-.
- GPIO20 is native USB D+.
- R3 and R4 start at 22 Ω series tuning values.
- U3 is a TPD2EUSB30-class low-capacitance two-line ESD boundary.
- Protection ground returns directly to the low-inductance logic ground.
- D+/D- retain their functional hierarchical names toward Sheet 09.

Sheet 09 retains the USB-C receptacle, duplicated Type-C USB2 pin joining, CC resistors, connector mechanical support, shield/chassis option, VBUS pinout, connector-entry placement, and fixture access. The final design shall use one coordinated ESD implementation rather than two redundant devices.

USB D+/D- shall be routed as a controlled differential pair during PCB design. Series resistors belong close to the module; ESD placement belongs at the agreed protected boundary. Trace impedance, skew, stubs, protection capacitance, and return discontinuities remain PCB-review items.

Native USB Serial/JTAG is the approved JTAG/debug path. Traditional external JTAG pins and an on-board debugger connector are not implemented.

## UART0 recovery

- GPIO43 is UART0 TX.
- R5, 499 Ω, is the preliminary Espressif-recommended TX harmonic/EMC series resistor.
- GPIO44 is UART0 RX and terminates directly at the functional interface.
- No UART connector or USB-to-UART bridge is placed on Sheet 03.
- Sheet 09 owns fixture contacts.

The fixture must tolerate ROM boot messages on TX and must never drive RX while IPC-100 is unpowered. Both signals are 3.3 V logic only.

## GPIO implementation

Every direct assignment follows the ADR-040 authoritative table:

| Group | Functional signals | GPIO |
| --- | --- | --- |
| Battery ADC | `BATTERY_SENSE` | 1 |
| Safety/command inputs | `STOP_IN_COND`, four limits, `ARM_IN_COND`, `FIRE_IN_COND` | 2, 4–9 |
| Encoder inputs | `ENCODER_A_COND`, `ENCODER_B_COND`, `ENCODER_SW_COND` | 10–12 |
| Axis 1 PWM | `AXIS1_RPWM_MCU`, `AXIS1_LPWM_MCU` | 13, 14 |
| Axis 2 PWM | `AXIS2_RPWM_MCU`, `AXIS2_LPWM_MCU` | 15, 16 |
| Axis 1 enable | `AXIS1_REN_MCU`, `AXIS1_LEN_MCU` | 17, 18 |
| Native USB | `USB_D-`, `USB_D+` | 19, 20 |
| Axis 2 enable | `AXIS2_REN_MCU`, `AXIS2_LEN_MCU` | 21, 38 |
| Relay command | `RELAY_CMD_MCU` | 39 |
| Power requests | OLED, sensor, UI, expansion | 35, 36, 40, 41 |
| UART0 | RX, TX | 44, 43 |
| Shared I²C | `I2C_SDA`, `I2C_SCL` | 47, 48 |

GPIO37 and GPIO42 remain no-connect future reserves. GPIO3, GPIO45, and GPIO46 remain no-connect straps.

The four power requests are high-impedance during reset. Sheet 02 provides 100 kΩ hardware pull-downs and qualifies every request with `MAIN_POWER_GOOD`; therefore reset, bootloader, unpowered MCU, and USB-only states cannot energize the branches. Firmware must configure all four pins low during its earliest GPIO initialization and assert them only after safe initialization.

Application output safe states are completed on their owning downstream sheets. Sheet 03 does not implement a driver, translator, load switch, relay, motor interface, RGB LED, buzzer, OLED reset, sensor, I²C peripheral, CAN, or RS-485 circuit.

## Exported functional interfaces

Inputs:

- `+3V3_CORE`
- `BATTERY_SENSE`
- conditioned STOP, limit, ARM, FIRE, and encoder signals
- `ESP_EN`
- `ESP_BOOT`
- `UART0_RX`

Outputs:

- `RESET_VALID`
- `UART0_TX`
- eight motor command/enable functional signals
- `RELAY_CMD_MCU`
- four peripheral-power requests

Bidirectional:

- `USB_D+`
- `USB_D-`
- `I2C_SDA`
- `I2C_SCL`

Obsolete direct RGB, buzzer, OLED-reset, and Sheet 03 `MAIN_POWER_GOOD` ports were removed from Sheet 00 and the affected child boundaries. The Sheet 02-to-Sheet 06 `MAIN_POWER_GOOD` route remains intact.

## Remaining release blockers

- Exact released ESP32-S3-WROOM-1-N8 order code, lifecycle, procurement, memory budget, and RF review.
- Released KiCad library symbol and exact pin-type audit.
- TPS3890-Q1 exact suffix, threshold, CT equation, tolerance, and reset timing.
- EN RC behavior across source transitions, ramp rates, manual reset, and brownout.
- USB SI, ESD boundary ownership, protection capacitance, and PCB return path.
- UART fixture voltage, series resistance, access, and unpowered-drive protection validation.
- Effective capacitance and 700 mA transient rail verification with active Wi-Fi/Bluetooth/ESP-NOW.
- Antenna keepout, enclosure clearance, ground-plane boundary, and coexistence testing.
- Framework-level simultaneous USB, UART, I²C, ADC, MCPWM, PCNT, LEDC, interrupt, and wireless feasibility.
- Downstream safe defaults, electrical conditioning, master inhibit, and Sheet 07 I²C expander implementation.
- Native KiCad ERC and formal peer-review disposition.
- All footprints and PCB layout, intentionally deferred.

## ERC expectations

Native KiCad ERC was not run because KiCad is unavailable in this environment. Repository structural validation passes.

Expected review points include:

- open-drain supervisor reset with a single pull-up;
- intentional no-connect strap and reserve pins;
- power-pin drive recognition for `+3V3_CORE`;
- bidirectional USB and I²C ports;
- fixture-originated EN, BOOT, and UART RX;
- high-impedance reset-state processor outputs;
- custom preliminary symbol pin types and pin numbers.

Do not waive an ERC item merely because it appears on this list. Install released symbols and disposition each result before schematic release.

## Manual review checklist

- [ ] Verify ESP32-S3-WROOM-1-N8 pin numbers against the controlled datasheet.
- [ ] Verify all module power/ground pins and exposed pad.
- [ ] Verify effective 22 µF, 1 µF, and 100 nF decoupling placement.
- [ ] Verify TPS389030-Q1 threshold and exact orderable suffix.
- [ ] Verify CT value and release delay.
- [ ] Verify EN RC and supervisor interaction.
- [ ] Verify RESET button and fixture reset behavior.
- [ ] Verify GPIO0 pull-up, BOOT button, and download sequence.
- [ ] Verify GPIO3/45/46 remain unloaded.
- [ ] Verify USB D-/D+ polarity and GPIO19/20 assignment.
- [ ] Verify 22 Ω tuning resistors and one coordinated ESD boundary.
- [ ] Verify native USB Serial/JTAG programming and recovery.
- [ ] Verify UART0 GPIO43/44 direction, ROM output, and unpowered fixture behavior.
- [ ] Verify all ADR-040 direct assignments once and only once.
- [ ] Verify GPIO37 remains no-connect and GPIO42 drives only `WATCHDOG_SERVICE_MCU` per ADR-044.
- [ ] Verify no raw GPIO name crosses the sheet boundary.
- [ ] Verify four request outputs remain low through reset and bootloader.
- [ ] Verify `MAIN_POWER_GOOD` is absent from Sheet 03 and retained on Sheet 02-to-06.
- [ ] Verify USB-only programming, bootloader, debug, and UART recovery.
- [ ] Verify antenna keepout and enclosure clearance before PCB entry.
- [ ] Run native KiCad ERC and disposition every result.

## Package handoff

Sheet 03 is ready for formal peer review. After review disposition, the recommended next capture package is:

**IPC-100 Rev A Preliminary KiCad Capture — Package 05 — Sheet 04 Safety Inputs, Interlocks & External Sense Interfaces**
