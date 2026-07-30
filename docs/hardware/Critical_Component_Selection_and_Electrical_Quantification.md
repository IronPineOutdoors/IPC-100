# IPC-100 Rev A Critical Component Selection and Electrical Quantification

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Status | Preliminary schematic-capture engineering basis |
| Date | 2026-07-29 |
| Owner | Iron Pine Outdoors Engineering |
| Next package | IPC-100 Rev A Preliminary KiCad Schematic Capture (Sheets 00–09) |

## 1. Purpose, authority, and limits

This package converts the approved IPC-100 architecture into quantitative circuit requirements and a production-oriented component shortlist. An experienced hardware engineer may use it to begin preliminary hierarchical schematic capture. It is not a complete schematic, footprint selection, PCB layout authorization, safety certification, or production release.

The words **selected**, **provisional**, and **open** are deliberate:

- **Selected** values and topologies are the Rev A capture basis and may be changed only through review.
- **Provisional** parts may be placed in preliminary capture but require orderable-part, tolerance, package, lifecycle, and procurement verification before schematic release.
- **Open** items shall remain marked `TBD` and shall not be silently inferred by the schematic author.

Manufacturer lifecycle statements and web availability are a 2026-07-29 snapshot, not a lifetime-buy guarantee. Authorized-distributor stock, counterfeit risk, package choice, and second-source compatibility require procurement review at release.

## 2. Governing architecture

This package preserves these controlled decisions:

- normal input is 9–21 V DC; the product owns battery packs, battery disconnects, high-current power, motors, and motor drivers;
- USB-only power supports core programming and recovery, not relay, motor-logic, UI, OLED, sensor, or expansion loads;
- ESP32-S3-WROOM-1, native USB, manual GPIO0/EN recovery, and independent UART0 access remain the service architecture;
- STOP and four limits are individually returned, supervised, normally-closed, de-energize-to-safe loops;
- a hardware master inhibit overrides all motor commands and relay authorization;
- J11 and J12 are documentation-only reservations in Rev A;
- all regulated logic shares a controlled common ground; J9 contacts alone are galvanically isolated.

## 3. Electrical operating envelope

| Parameter | Rev A capture value | Release condition |
| --- | ---: | --- |
| Normal J1 input | 9.0–21.0 V DC | Selected |
| Main start threshold | 8.8 V rising nominal | Verify tolerance over temperature |
| Main shutdown threshold | 8.0 V falling nominal | Verify hysteresis and battery behavior |
| Input overvoltage cutoff | 24.0 V nominal | Verify divider tolerance |
| Protected-path survival goal | 60 V, energy limited | Not automotive load-dump qualification |
| Reverse input | –21 V indefinitely at J1, no damage | Product fuse fitted |
| Controller input-path target | 2.0 A continuous at 9 V | Thermal and prototype verification |
| PCB ambient design range | –40 to +85 °C | Enclosure thermal test required |
| Design ambient for estimates | +50 °C enclosed | Measure actual enclosure |

IPC-100 is compatible with a nominal 18 V tool-battery system within the 9–21 V operating range. “Automotive compatible” means usable from a suitably protected nominal 12 V product supply. It does **not** claim ISO 7637, ISO 16750, SAE load-dump, cranking, jump-start, or 24 V vehicle compliance. A product requiring those profiles must define and verify them separately.

The product shall provide a battery-rated disconnect and a branch fuse close to the source. The reference assumption is a 2 A time-delay branch fuse with interrupt rating appropriate to the battery pack. The PCB protection circuit is not a substitute for the source fuse.

## 4. Power entry — Sheet 01

### 4.1 Compared implementations

| Option | Advantages | Disadvantages | Disposition |
| --- | --- | --- | --- |
| Series Schottky diode, fuse, TVS | Simple and inexpensive | Approximately 0.6–1.0 W loss at 2 A; no controlled UV/OV/inrush | Reject |
| Discrete ideal-diode controller, MOSFET, fuse, TVS | Low loss and flexible | Separate current limiting, UV/OV, timer, and power-good functions increase parts and fault-analysis burden | Acceptable alternate |
| Integrated 60 V eFuse plus external reverse-polarity MOSFET | Low loss; adjustable UV, OV, current, inrush, fault timing, and power-good | Single-source IC and design-validation burden | **Preferred** |

### 4.2 Selected topology

Use a **TPS2663-family** 60 V eFuse in series with its datasheet-supported external reverse-polarity N-channel MOSFET arrangement. Use the latch-off/auto-retry variant chosen during detailed capture to produce the required fault behavior; auto-retry shall not create relay chatter or repeated unsafe startup. The preliminary preference is a latch-off response to sustained OV/current faults, cleared only by valid power removal or controlled enable.

Capture the following chain:

`J1 -> source fuse assumption -> reverse MOSFET/eFuse -> TVS return -> damped input filter -> VIN_PROTECTED -> 5 V buck`

Required settings:

- current limit: 2.0 A nominal; tolerance shall not exceed the J1, MOSFET, filter, or PCB thermal envelope;
- UVLO: 8.8 V rising nominal and 8.0 V falling nominal;
- OVLO: 24.0 V nominal;
- inrush: limit `VIN_PROTECTED` rise to 10–50 ms;
- fault output/power-good: open-drain, fail-low, used by main-valid logic;
- reverse MOSFET: 60 V minimum `VDS`, avalanche characterized, logic-level gate not assumed, `RDS(on)` target ≤20 mΩ at the controller operating point;
- local protection: Littelfuse SMBJ33A-class unidirectional TVS is the preliminary clamp, subject to pulse-profile validation.

TPS2663 is rated for 4.5–60 V operation, integrates a 31 mΩ path, supports adjustable 0.6–6 A current limit, UVLO/OVLO, soft start, surge handling, power good, and an external reverse-polarity FET. A discrete **LM74700-Q1** ideal-diode stage plus a separate hot-swap/eFuse is the acceptable alternate if TPS2663 procurement or fault behavior is unacceptable.

### 4.3 Filter and energy assumptions

Start capture with:

- 100 nF, 50 V X7R directly behind the protected entry;
- 2 × 22 µF, 50 V X7R effective capacitance target ≥20 µF after DC bias;
- 10 µH shielded inductor, saturation current ≥3 A, DCR ≤100 mΩ;
- a second 22 µF, 50 V bank at the buck input;
- an optional series `1 Ω + 1 µF` damping branch, initially populated for prototype tuning.

At 2 A, a 20 mΩ reverse FET plus 31 mΩ eFuse dissipates approximately:

`P = I²R = 2² × (0.020 + 0.031) = 0.204 W`.

A 100 mΩ inductor adds 0.40 W at 2 A, so lower DCR is strongly preferred. The LC corner for 10 µH and 22 µF is approximately 10.7 kHz. The filter shall be simulated with the selected buck input impedance and verified for conducted-noise attenuation and startup stability; more capacitance is not automatically safer.

Place the TVS and high-frequency capacitor at the entry-current return, before filtered current crosses logic ground. Do not route TVS surge current through the ESP32 or ADC return.

## 5. Power conversion and distribution — Sheet 02

### 5.1 Rail architecture and preferred parts

| Rail/block | Preferred implementation | Rating/capture target | Alternate |
| --- | --- | --- | --- |
| `VIN_PROTECTED` to `+5V_MAIN` | TI LMR38020-Q1 synchronous buck | 4.2–80 V, 2 A; 5.0 V ±3%; 1.5 A continuous design load | LM5164-Q1 if a 1 A closed load proves sufficient |
| Main/USB core source mux | TI TPS2121 | 2.7–22 V, 4.5 A, reverse blocking; main priority | TPS2116 with revalidated current envelope |
| `CORE_SOURCE` to `+3V3_CORE` | TI TPS62130 adjustable synchronous buck | Set to 3.3 V; 1.0 A continuous design load, ≥1.5 A transient capability | TPS62903 after design migration review |
| OLED branch | TPS22918-Q1 load switch | 3.3 V, 150 mA limit by upstream branch/fuse resistor | TPS22918 |
| Sensor branch | TPS22918-Q1 load switch | 3.3 V, 50 mA allocation | TPS22918 |
| J10 expansion power | dedicated TPS25947 or equivalent eFuse | 3.3 V, 100 mA released maximum | Omit population |
| J2/J3 logic supply | one protected branch per connector | 5 V, 100 mA each preliminary | Omit connector power if external drivers self-power logic |
| `RELAY_VCC` | direct main-only 5 V branch with local filtering | 100 mA allocation | Relay selection may change value |

The 3.3 V converter rather than an LDO is selected because USB-only service and wireless peaks require thermal efficiency. At 0.8 A, an LDO from 5 V would dissipate `(5 – 3.3) × 0.8 = 1.36 W`; a 90% buck loses approximately 0.29 W.

### 5.2 Preliminary simultaneous-load budget

| Load | Typical | Design peak | Rail |
| --- | ---: | ---: | --- |
| ESP32-S3 module/radio | 120 mA | 700 mA | 3.3 V |
| Core logic, supervisor, watchdog | 25 mA | 50 mA | 3.3 V |
| I2C pull-ups and onboard devices | 15 mA | 40 mA | 3.3 V/main-only branches |
| 3.3 V design total | 160 mA | 790 mA | `+3V3_CORE` |
| Two motor-logic supplies | 100 mA | 200 mA | 5 V |
| Relay coil | 80 mA | 100 mA | 5 V |
| RGB, buzzer, UI | 50 mA | 120 mA | 5 V |
| OLED, sensor, J10 | 60 mA | 250 mA | 3.3 V/main-only branches |

Assuming 0.79 A at 3.3 V and 90% conversion, the 5 V input to the 3.3 V rail is:

`I5 = (3.3 × 0.79) / (5 × 0.90) = 0.579 A`.

Adding 0.67 A of worst-case direct 5 V loads gives 1.25 A. A 1.5 A continuous/2 A peak 5 V design envelope therefore provides 20% continuous headroom before tolerance. At 9 V input, 5 V × 1.5 A and 88% efficiency requires approximately 0.95 A from J1. The 2 A entry target retains fault, startup, and future measured-load margin; it is not an external-load allowance.

At 21 V, 7.5 W output and 90% efficiency imply about 0.83 W converter loss. With a target effective `θJA ≤ 45 °C/W`, estimated rise is 37 °C, or 87 °C junction at 50 °C ambient. Detailed layout thermal impedance and enclosure measurement remain mandatory.

### 5.3 Sequencing

1. `VIN_PROTECTED` becomes valid.
2. `+5V_MAIN` rises and asserts `MAIN_POWER_GOOD` only after it is within ±5%.
3. TPS2121 selects main over `USB_5V_PROTECTED`; it shall never backfeed either source.
4. `+3V3_CORE` rises; the supervisor holds reset and actuator authorization invalid.
5. Main-only load switches remain off through reset.
6. Firmware initializes safe GPIO states and begins watchdog service.
7. Hardware permits main-only peripheral power.
8. Actuator authorization becomes possible only after STOP, rail, reset, and watchdog qualification.

Loss of any required condition removes actuator authorization before the corresponding rail leaves valid logic range. Core switchover may reset the processor; no-glitch operation is desirable but not safety-significant. A reset is acceptable if all outputs remain safe.

### 5.4 AR-01 interface and domain closure

ADR-039 fixes the preliminary-capture branch domains and enable contract:

| Branch | Domain | Control |
| --- | --- | --- |
| `RELAY_VCC` | 5 V main-only | Hardware-enabled with qualified main |
| `MOTOR_LOGIC_5V_A/B` | 5 V main-only | Hardware-enabled with qualified main; separate current-limited branches |
| `FIELD_SENSE_VCC` | 5 V main-only | Hardware-enabled with qualified main |
| `OLED_VCC` | 3.3 V main-only | `OLED_POWER_REQ`, active high, hardware pull-down and main qualification |
| `SENSOR_VCC` | 3.3 V main-only | `SENSOR_POWER_REQ`, active high, hardware pull-down and main qualification |
| `UI_VCC` | 5 V main-only | `UI_POWER_REQ`, active high, hardware pull-down and main qualification |
| `EXPANSION_VCC` | 3.3 V main-only, optional/DNP | `EXPANSION_POWER_REQ`, active high, hardware pull-down and main qualification |

Sheet 01 exports released-valid open-drain `MAIN_INPUT_VALID` from its eFuse PGOOD node. Sheet 02 combines the qualified result with LMR38020-Q1 PGOOD to create `MAIN_POWER_GOOD`. These interface decisions close ODI-SCH-007 but do not close exact passives, branch protection parts, thermal calculations, or source-transition validation.

## 6. USB-C service — Sheets 02, 03, and 09

Use J13 as a USB 2.0 **sink/device only** connector. Do not implement USB Power Delivery, source VBUS, battery charging, or USB host mode.

| Function | Capture requirement |
| --- | --- |
| Receptacle | USB-C receptacle exposing USB 2.0 pins only; GCT USB4105 family is a provisional mechanical candidate |
| CC1/CC2 | Independent 5.1 kΩ ±1% `Rd` to ground |
| D+/D– | Tie the duplicated Type-C USB 2.0 pins at the receptacle; 22 Ω series resistors near ESP32, value tuned during SI review |
| Data ESD | TI TPD2EUSB30 or equivalent low-capacitance two-line protector at J13 |
| VBUS protection | TPS25947 eFuse, 500 mA nominal limit, reverse blocking, controlled rise |
| Source mux | TPS2121; main source priority |
| Shield | Direct chassis connection if a chassis node exists; otherwise DNP `1 MΩ || 4.7 nF` coupling option to logic ground |

The 500 mA USB limit is conservative for an unenumerated/default-current service source. USB-only firmware shall minimize radio duty and hold all main-only branches off. If measured boot/programming peaks cause VBUS collapse, raise the limit only after the Type-C current contract is verified; do not assume every host grants 1.5 A or 3 A.

Manual recovery sequence:

1. hold GPIO0 low;
2. pulse EN low then release;
3. release GPIO0 after download mode is entered;
4. program through native USB or the isolated production UART fixture;
5. verify normal boot after EN reset.

USB-only, main-only, USB-first, main-first, source removal, brownout, and faulted-VBUS cases are mandatory prototype tests.

## 7. ESP32-S3 support — Sheet 03

Select **ESP32-S3-WROOM-1-N8** as the Rev A capture module: PCB antenna, 8 MB Quad-SPI flash, no PSRAM, –40 to +85 °C. It preserves GPIO35/36 and normal 3.3 V GPIO47/48 assumptions. N4 is the pin-compatible cost alternate if the firmware memory budget approves it; N8R8 and R16V variants are not alternates because octal PSRAM consumes or changes required GPIO behavior.

| Function | Quantitative implementation |
| --- | --- |
| Module supply | 3.3 V ±5%; 700 mA transient allocation |
| Local bulk | 22 µF effective low-ESR plus 1 µF and 100 nF adjacent to module supply |
| EN | 10 kΩ pull-up to 3.3 V, 1 µF to ground, manual normally-open reset switch to ground, fixture pad |
| GPIO0 | 10 kΩ pull-up, manual normally-open boot switch to ground, fixture pad; no application loading |
| Crystal | None external; module contains the required RF/CPU crystal |
| USB | GPIO20 D+, GPIO19 D–, native USB Serial/JTAG |
| UART0 | GPIO43 TX, GPIO44 RX on production fixture pads; 3.3 V logic only |
| Straps | Do not use GPIO3, GPIO45, or GPIO46; retain external defaults on every output |
| RF | Preserve module datasheet antenna keepout; final enclosure and PCB review required |

The 1 µF EN capacitor is a capture starting value, not a substitute for the external supervisor. Verify reset timing against Espressif's current hardware design guidance. The fixture shall never drive an unpowered module and shall tolerate ROM boot messages on UART0 TX.

## 8. Input conditioning — Sheet 04

### 8.1 Supervised STOP and limit loops

Use a 5.0 V field-sense source and a 2.20 kΩ ±1% controller source resistor per loop. The remote normally-closed contact connects a 2.20 kΩ ±1% end-of-line resistor to its dedicated return. The EOL resistor shall be at the field contact, not on the controller PCB.

| Field state | Nominal sense voltage | Required hardware interpretation |
| --- | ---: | --- |
| Short to return | 0 V | Fault; inhibit affected function, STOP loop inhibits all |
| Healthy NC + 2.20 kΩ EOL | 2.50 V | Healthy |
| Contact open / wire open | 5.00 V | Asserted/open; conservative inhibit |
| Out of window or rail invalid | Indeterminate | Fault; conservative inhibit |

Use two comparator thresholds per loop:

- low threshold: 1.00 V nominal;
- high threshold: 4.00 V nominal;
- healthy only when `1.00 V < VSENSE < 4.00 V`;
- short/fault when `VSENSE < 1.00 V`;
- open/asserted when `VSENSE > 4.00 V`.

Generate the thresholds from a buffered or adequately loaded precision 5 V resistor ladder, not independent high-tolerance dividers. Three LM339B-Q1 quad open-collector comparators provide ten required channels plus two spares. Add 100 kΩ positive-feedback resistors where simulation shows at least 50 mV hysteresis without moving state boundaries outside their tolerance limits.

Per field input use a 1 kΩ series resistor after the connector clamp, 100 nF C0G/X7R to the dedicated clean reference, and a low-capacitance ESD clamp such as TPD4E05U06 arranged by connector. The nominal hardware time constant is 100 µs. Firmware adds:

- STOP assertion qualification ≤2 ms; release qualification 20 ms;
- limit assertion qualification ≤5 ms; release qualification 20 ms;
- ARM/FIRE 10 ms stable qualification and release-before-retrigger;
- encoder 1 ms hardware/firmware qualification appropriate to measured contact speed.

Hardware response, including comparator and gate propagation, shall remove actuator permit within 5 ms of STOP opening. Firmware debounce never delays the hardware STOP inhibit.

Loop calculations:

- healthy current: `5 V / (2.2 kΩ + 2.2 kΩ) = 1.136 mA`;
- short current: `5 V / 2.2 kΩ = 2.273 mA`;
- each EOL resistor dissipates `2.5² / 2.2 kΩ = 2.84 mW`;
- 100 m round-trip AWG 24 resistance near 8.4 Ω shifts 2.50 V by less than 0.1%, far inside the 1–4 V window.

The released Rev A harness assumption is **10 m maximum per loop**, routed away from motor leads, with total cable capacitance ≤2 nF. Longer/noisier routes require product-level validation or isolated industrial input circuitry.

### 8.2 ARM, FIRE, and encoder

ARM and FIRE are normally-open dry contacts biased from main-only `FIELD_SENSE_VCC` through 10.0 kΩ ±1% per ADR-042. Use 1 kΩ connector series resistance, 100 nF filtering, and a protected comparator/receiver that translates to `+3V3_CORE`; the conditioned nets are active high when the contact is closed. Encoder A/B/push remain non-safety 3.3 V dry contacts on Sheet 07 and may use 10 kΩ pull-ups and an SN74LVC14A stage. No ARM/FIRE field excitation may remain powered in USB-only service.

No field input may drive an ESP32 pin directly. External voltage injection is not supported. A ±8 kV IEC 61000-4-2 contact-discharge design objective applies at accessible enclosure connectors, but compliance depends on the final connector, enclosure, grounding, and PCB layout.

## 9. Hardware master inhibit — Sheet 06

Implement an active-high internal net named `ACTUATOR_PERMIT`. It shall default low. `MASTER_INHIBIT` is the logical complement used in documentation; no circuit may depend on a floating active-high authorization.

Required Boolean qualification:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND STOP_HEALTHY_HW AND RESET_RELEASED AND WATCHDOG_VALID`

Use fail-low open-drain sources with 10 kΩ pull-ups, followed by SN74LVC1G11/SN74LVC1G08-Q1 gates powered from the main-valid 3.3 V logic domain. Cascade gates only if static and dynamic analysis proves that no power-up pulse can appear. Add 100 kΩ pulldown at every active-high permit input or downstream enable that could float while a supply is absent.

Preferred supervision:

- **TPS3890-Q1** monitors `+3V3_CORE`; 3.0 V nominal falling threshold, 100 ms reset-release delay;
- **TPS3431-Q1** external watchdog; 250 ms nominal watchdog window/timeout and fail-low output;
- main-valid derives from the 5 V buck PGOOD qualified by `VIN_PROTECTED` eFuse PGOOD;
- STOP healthy comes directly from the analog window logic, independent of the MCU.

The watchdog shall remain invalid during reset and until firmware deliberately begins service. It must not be satisfied by a static GPIO, a free-running peripheral detached from healthy control flow, or boot ROM activity. Firmware shall pulse it from a supervised control task at 50–100 ms intervals.

`ACTUATOR_PERMIT` drives:

1. the active-low output-enable gating both motor translators; and
2. a relay authorization AND gate ahead of the relay MOSFET.

No Rev A GPIO is allocated for permit feedback. Provide a labeled production test point and include the state in fixture tests. The absence of MCU feedback is accepted as a diagnostic limitation, not proof of the inhibit state.

## 10. Motor-driver logic interfaces — Sheet 05

ADR-043 supersedes the single shared SN74LXC8T245 selection. Use two independent four-channel SN74LXC4T245-class dual-supply translators, one for each J2/J3 command group. Set both A-sides to 3.3 V; set the Axis 1 B-side to `MOTOR_LOGIC_5V_A` and Axis 2 B-side to `MOTOR_LOGIC_5V_B`; fix direction A-to-B; and gate each output-enable from the common authorization contract. The selected orderable devices require partial-power-down/Ioff behavior so either external interface cannot backfeed the core or the other axis.

Per channel:

- 47 kΩ pulldown at the ESP32-side command;
- 10 kΩ pulldown at the connector-side output;
- 33 Ω series resistor between translator output and ESD/connector node;
- TPD4E05U06 or equivalent low-capacitance ESD array per four signals;
- no RC capacitor on PWM lines until edge/noise measurement justifies one;
- translator OE defaults disabled with 100 kΩ and is enabled only by `ACTUATOR_PERMIT`.

ADR-043 adds combinational suppression ahead of the translator: for each axis, simultaneous active RPWM and LPWM requests force both qualified PWM channels low. Use Q1 logic with defined partial-power behavior and ≤500 ns total authorized-path propagation. Firmware still owns legal command generation and the 20 ms all-off reversal sequence. Translator OE requires `ACTUATOR_PERMIT` high and `MASTER_INHIBIT` low; disagreement disables all outputs.

J2/J3 logic-high is 5 V nominal; logic-low ≤0.4 V at the connector under the released load. Design source/sink load is ≤2 mA per signal. Preliminary PWM is 20 kHz, 0–100% command range, at least 10-bit firmware resolution, and 100 ns-class electrical edges after series damping. External-driver modules must accept these levels, share IPC-100 logic ground, draw ≤100 mA from each protected 5 V branch, and present no voltage when IPC-100 is off.

Opposing PWM commands are forbidden. Direction reversal shall disable both enables and both PWM outputs for at least 20 ms before the opposite direction is enabled. This timing is provisional until the selected external driver and motor are tested.

## 11. Relay driver and contacts — Sheet 06

The provisional relay is **Omron G5Q-1 DC5** (SPDT/Form C family; exact high-capacity suffix to follow the released contact load). It is in production, supports a 5 V coil option, and provides an established power-relay family. Do not select a high-capacity or high-temperature suffix merely because its headline current is larger; the actual DC/AC, inductive/resistive, minimum-load, ambient, cycle-life, and safety-standard contract controls the orderable part.

Driver:

- 60 V N-channel MOSFET, 2N7002P-class, low-side coil switch;
- 100 Ω gate resistor and 100 kΩ gate pulldown;
- relay command ANDed with `ACTUATOR_PERMIT`;
- coil supplied only from `RELAY_VCC`;
- 1 A Schottky diode in series with a 12 V, 500 mW zener clamp across the coil, oriented to conduct only on turn-off;
- optional drain test point; no processor feedback in Rev A.

For an 80 mA coil, steady coil power is `5 V × 0.08 A = 0.40 W`. Even 2 Ω MOSFET on-resistance would dissipate only 12.8 mW, but 60 V rating provides clamp and transient margin. The zener-assisted clamp releases faster than a diode-only clamp and shall be verified to keep the MOSFET drain below 75% of rated `VDS`.

Until the product relay load is closed, J9 is limited to a **provisional 30 V DC or 120 V AC, 2 A resistive maximum**, fused externally, with no inductive, capacitive, lamp, motor, or safety-rated load claim. PCB creepage/clearance and connector selection remain blocked by that contract. Coil de-energized and `RELAY_NO` open is always the platform safe state.

## 12. Battery monitor — Sheets 01 and 03

Use GPIO1/ADC1_CH0. Divide `VIN_PROTECTED` with two series 49.9 kΩ ±0.1%, 25 ppm/°C top resistors and one 10.0 kΩ ±0.1%, 25 ppm/°C bottom resistor. Add 100 nF from the divider node to analog ground and 1 kΩ between the node and ADC pin. Add rail clamps only if their leakage error is included.

`VADC = VIN × 10.0 / (49.9 + 49.9 + 10.0) = VIN / 10.98`

| VIN | Nominal ADC voltage |
| ---: | ---: |
| 9.0 V | 0.820 V |
| 18.0 V | 1.639 V |
| 21.0 V | 1.913 V |
| 24.0 V | 2.186 V |
| 30.0 V abnormal | 2.732 V |

Divider current at 21 V is 191 µA and total dissipation is 4.02 mW. The Thevenin resistance is 9.09 kΩ; the 100 nF capacitor gives approximately 0.91 ms filtering and supplies the ADC sampling impulse.

A 12-bit nominal conversion over a calibrated 0–2.5 V usable range represents approximately 6.7 mV of battery voltage per count after the divider. Actual ESP32 ADC gain, reference, and nonlinearity dominate resistor error. Use Espressif eFuse calibration through the framework calibration API, average at least 32 samples after settling, and perform two-point production calibration near 10 V and 20 V. Target reported accuracy is ±2% from 9–21 V after calibration; uncalibrated voltage is diagnostic only.

## 13. I2C, OLED, sensor, and expansion — Sheets 07 and 08

Use a 3.3 V, 100 kHz I2C bus. IPC-100 owns one 4.70 kΩ ±1% pull-up on SDA and SCL. Display, sensor, and expansion modules shall not populate additional pull-ups unless the combined equivalent resistance is reviewed.

With 200 pF maximum bus capacitance, the approximate 30–70% rise time is:

`tr ≈ 0.8473 × R × C = 0.8473 × 4.7 kΩ × 200 pF = 0.80 µs`.

This fits 100 kHz standard-mode intent but not a blanket 400 kHz claim. Released limits:

- total measured bus capacitance ≤200 pF;
- J10 cable ≤0.5 m and onboard/product-local only;
- no hot-plug baseline;
- J10 power ≤100 mA from a fault-contained 3.3 V branch;
- 33 Ω series resistors at the MCU-side bus source;
- low-capacitance ESD at J6/J7/J10.

Buffer J10 through a **TCA4307** hot-swap/stuck-bus recovery buffer. Its bus-ready output may remain fixture-only because no MCU GPIO is available. The onboard OLED and sensor remain on the MCU side so a stuck external bus is isolated. Firmware performs nine SCL recovery pulses and peripheral power cycling only after hardware isolation; recovery must not affect actuator authorization.

`OLED_VCC` and `SENSOR_VCC` are selected as controlled 3.3 V branches. The bare BME280 is 3.3 V compatible; breakout modules with onboard regulators or fixed pull-ups require separate approval. The exact 2.42-inch SSD1309 OLED module, connector pin order, reset polarity, startup current, and onboard charge-pump implementation remain blockers.

## 14. RGB and buzzer — Sheet 07

The J8 reference output is an external **common-anode 5 V RGB LED** with three low-side 2N7002P MOSFETs. Use 100 Ω gate resistors, 100 kΩ gate pulldowns, and initial current resistors:

| Channel | Assumed forward voltage | Resistor | Calculated current |
| --- | ---: | ---: | ---: |
| Red | 2.0 V | 330 Ω | 9.1 mA |
| Green | 3.0 V | 220 Ω | 9.1 mA |
| Blue | 3.0 V | 220 Ω | 9.1 mA |

Release brightness is ≤10 mA/channel and ≤30 mA total. LEDC PWM may run at 1 kHz or higher with 8-bit minimum resolution. Populate higher resistance after actual indicator brightness is evaluated; these values are maximum-brightness starting points.

Use a 5 V active magnetic buzzer provision, 30 mA maximum, driven by a 2N7002P low-side MOSFET with the same default-off network. A CUI CMT-1203-SMT-TR-class active buzzer is a provisional onboard alternate; J8 may instead drive a product panel buzzer. Add a flyback diode if the selected transducer is magnetic and its datasheet requires one. The buzzer shall be silent without valid main power and shall not be treated as a safety alarm.

## 15. Connector families — Sheet 09

The PCB connectors live inside a sealed product enclosure; they are not intrinsically weatherproof field connectors. Exposed product harnesses shall use product-owned sealed connectors such as Deutsch DTM/DT or equivalent. Exact PCB headers, keying, plating, latch orientation, wire gauge, mating cycles, and footprints remain a mechanical/procurement release gate.

| ID | Function | Rev A family recommendation | Electrical rationale/status |
| --- | --- | --- | --- |
| J1 | Power input | Molex Micro-Fit 3.0, 2 circuit | Locking; ample margin above 2 A and 21 V |
| J2 | Axis 1 logic | Micro-Fit 3.0, 6 circuit | Robust harness; 100 mA supply only |
| J3 | Axis 2 logic | Micro-Fit 3.0, 6 circuit | Key differently from J2 by housing/color/blanking |
| J4 | Two supervised limits | Micro-Fit 3.0, 4 circuit | Four individually returned conductors |
| J5 | Two supervised limits | Micro-Fit 3.0, 4 circuit | Key differently from J4 |
| J6 | OLED | JST GH, 5 circuit | Compact locking low-current display harness |
| J7 | Sensor | JST GH, 4 circuit | Compact locking low-current sensor harness |
| J8 | UI/STOP/status | **Open: partition required** | One 14-circuit mixed-function connector is not released |
| J9 | Relay contacts | Molex Mini-Fit Jr., 3 circuit provisional | Separation and serviceability; final voltage/load rating open |
| J10 | Local I2C | JST GH, 4 circuit | Compact controlled local expansion |
| J11 | Spare GPIO | No connector in Rev A | Documentation-only per ADR-034 |
| J12 | Future CAN/RS485 | No connector in Rev A | Reservation only; interfaces are not implemented |
| J13 | USB service | USB-C USB 2.0 receptacle | Sink/device only; exact mechanical part open |

Micro-Fit, Mini-Fit, and JST GH current ratings depend on exact terminal, wire gauge, circuit count, temperature, and contact resistance. Released connector current shall be the lower of the manufacturer derated value, branch protection, conductor limit, and interface allocation.

J8 shall be partitioned before Sheet 09 release. Preferred partition is a dedicated two-circuit STOP connector, a controls/encoder connector, and an indicator/buzzer connector. Stable signal names remain unchanged; identifier suffixes and final circuit counts require connector-control review.

## 16. Prototype, production, and service access

### 16.1 Required labeled test nets

Provide fixture-accessible pads for:

- `VIN_RAW`, `VIN_PROTECTED`, `+5V_MAIN`, `USB_5V_PROTECTED`, `CORE_SOURCE`, `+3V3_CORE`;
- power ground at each rail group and one entry/surge return;
- eFuse PGOOD, 5 V PGOOD, supervisor reset, watchdog output, `ACTUATOR_PERMIT`;
- all five raw supervised sense nodes and all five conditioned outputs;
- GPIO0, EN, UART0 TX/RX, USB D+/D– observation pads;
- `BATTERY_SENSE`;
- I2C SDA/SCL on both sides of TCA4307;
- translator OE and one representative signal at both voltage domains;
- relay gate/drain and each main-only load-switch enable/output.

Production access shall use spring probes or an approved no-connector fixture interface. A Tag-Connect family may be evaluated, but this document does not select its footprint. USB D+/D– pads shall be stubs short enough not to compromise signal integrity and normally remain unprobed.

### 16.2 Manufacturing test minimum

The fixture shall verify source current limits, absence of backfeed, rail voltages, reset timing, boot modes, UART recovery, all input windows, STOP-to-permit latency, watchdog removal of permit, all disabled output defaults, relay release, ADC calibration, I2C isolation, and USB enumeration. Field service access is limited to J13, visible diagnostics, and replaceable harness connectors; field probes shall not be required for ordinary recovery.

## 17. Passive and capture rules

- Place one 100 nF X7R at every IC supply pin group, plus 1 µF per local logic cluster.
- Specify effective capacitance after DC bias, tolerance, aging, and temperature; nominal label value alone is insufficient.
- Use 50 V minimum capacitors on protected input, 10 V minimum on 5 V, and 6.3 V minimum on 3.3 V; prefer 10 V on 3.3 V bulk.
- Use 1% resistors for ordinary biasing, 0.1%/25 ppm for ADC and thresholds, and document all DNP tuning parts.
- External output defaults use 10–100 kΩ resistors; never depend on MCU internal pulls.
- RC filtering must have a stated noise target and response-time budget.
- Put TVS devices at connector entry with the shortest possible surge loop and no shared sensitive return path.
- Do not use ferrite beads as unexplained “noise fixes”; state impedance/current/DC-resistance requirements.
- Separate entry, buck-switch, relay-coil, external-interface, analog, and RF current loops while retaining one controlled common ground.
- Stitch ground around connector protection and board edges only after return-current analysis; never stitch across required RF antenna keepout.
- Use net classes and schematic notes to distinguish relay-contact isolation, surge paths, USB differential signals, analog sense, and ordinary logic.

## 18. Calculations and quantitative checks

| Check | Calculation | Result/requirement |
| --- | --- | --- |
| Entry-path loss | `2² × 51 mΩ` | 0.204 W before inductor |
| 5 V input at rated design load | `7.5 W / (9 V × 0.88)` | 0.95 A at 9 V |
| 3.3 V buck input | `(3.3 × 0.79)/(5 × 0.90)` | 0.579 A |
| 3.3 V LDO avoided loss | `(5 – 3.3) × 0.8` | 1.36 W |
| Supervised healthy current | `5/(2.2k + 2.2k)` | 1.136 mA/loop |
| Five loop maximum short current | `5 × 5/2.2k` | 11.4 mA |
| I2C rise time | `0.8473 × 4.7k × 200pF` | 0.80 µs |
| Battery divider at 21 V | `21/10.98` | 1.913 V |
| Battery-divider dissipation | `21²/109.8k` | 4.02 mW |
| Motor translator dynamic load | `8 × CLOAD × 5² × 20k` | 40 µW at 10 pF/channel, excluding translator internal loss |
| RGB maximum | `3 × 10 mA × 5 V` | 150 mW supply envelope |
| Relay coil provisional | `5 V × 80 mA` | 0.40 W |
| 5 V converter estimated rise | `0.83 W × 45 °C/W` | 37 °C; validate layout/enclosure |

The schematic review shall repeat every calculation with selected orderable-part minimum/maximum parameters, not nominal marketing values.

## 19. Design margins

| Attribute | Minimum Rev A rule |
| --- | --- |
| Steady voltage | Semiconductor operating rating ≥1.25× maximum normal voltage |
| Transient voltage | Absolute maximum ≥1.2× verified clamp maximum; never design to abs max continuously |
| Capacitor voltage | Input ≥50 V; 5 V rail ≥10 V; 3.3 V rail ≥6.3 V |
| Current | Continuous operating point ≤75% of thermally derated component/connector limit |
| Resistor power | Calculated worst-case ≤50% rated power at design ambient |
| Temperature | Rated for –40 to +85 °C ambient; predicted junction ≤105 °C normal |
| Regulator | ≥20% rail-current headroom after tolerance and thermal derating |
| ADC | Abnormal maximum input ≤85% calibrated ADC range; ±2% system target after calibration |
| PWM | Logic timing margin ≥5× propagation/skew uncertainty; driver compatibility measured |
| Relay contacts | Use ≤50% headline resistive rating until load-specific life data approves more |
| Connector | Use ≤50% catalog current unless exact terminal/wire/temperature derating supports more |
| ESD/TVS | Clamp below protected absolute maximum with lead/trace inductance included |

## 20. Major-component shortlist

| Subsystem | Preferred | Acceptable alternate | Manufacturer | Reason | Principal risk | 2026-07 lifecycle/availability |
| --- | --- | --- | --- | --- | --- | --- |
| Input eFuse | TPS2663 family | LM74700-Q1 + separate eFuse | Texas Instruments | 60 V integrated protection/control | Exact behavior variant and TVS energy | TI lists TPS2663 active |
| 5 V buck | LMR38020-Q1 | LM5164-Q1 after load reduction | TI | 80 V, 2 A, PGOOD, automotive grade | Magnetics/layout/thermal | TI lists active |
| Source mux | TPS2121 | TPS2116 after current review | TI | Priority mux and reverse blocking | Switchover validation | TI lists active |
| USB eFuse | TPS25947 | TPS2595 family | TI | Adjustable limit and true reverse blocking | USB default-current contract | TI lists active |
| 3.3 V buck | TPS62130 | TPS62903 after migration review | TI | Adjustable 3.3 V output and wireless transient margin | Layout and exact feedback network | TI lists both active |
| Load switch | TPS22918-Q1 | TPS22918 | TI | Controlled rise and discharge | Does not replace branch current limit | TI family listed active |
| MCU module | ESP32-S3-WROOM-1-N8 | N4 after memory approval | Espressif | GPIO-compatible 8 MB baseline | RF/mechanical/procurement | Current datasheet orderable family |
| USB ESD | TPD2EUSB30 | USBLC6-2SC6 | TI / ST | Low-capacitance USB protection | Layout dominates performance | Manufacturer lifecycle check at release |
| Supervisor | TPS3890-Q1 | MAX16052-class | TI / ADI | Precise threshold, programmable delay | Exact threshold suffix | TI lists active |
| Watchdog | TPS3431-Q1 | TPS3430-Q1 | TI | Independent fail-low watchdog | Timeout/network validation | TI lists active |
| Window comparators | 3 × LM339B-Q1 | LM2901B-Q1 | TI | Wide supply, open collector, available channels | Threshold/reference tolerance | TI current documentation |
| Logic gates | SN74LVC1G11/1G08-Q1 | NC7SZ family after qualification | TI / onsemi | Defined fail-low permit logic | Partial-power sequencing | Active-family verification required |
| Input Schmitt | SN74LVC14A-Q1 | 74HC14-Q1 after threshold review | TI / Nexperia | 3.3 V conditioning/hysteresis | Input thresholds under slow edges | Active-family verification required |
| Motor translator | 2 × SN74LXC4T245-class | Two independently powered four-channel Ioff translators after review | TI / qualified alternate | Preserves separate Axis A/B 5 V domains, Ioff, OE | Exact Q1/orderable suffix and propagation validation | Lifecycle check at release |
| Relay | Omron G5Q-1 DC5 family | Panasonic ALQ/HE family after load review | Omron / Panasonic | Established SPDT power family | Contact load is not closed | Omron lists G5Q in production |
| Relay/status MOSFET | 2N7002P, 60 V | BSS138P with rating check | Nexperia / Infineon | Default-off low-side drive | Coil clamp and ESD | Multi-vendor generic family |
| I2C isolation | TCA4307 | TCA9511A | TI | Hot-swap and stuck-bus recovery | External-bus behavior/test | TI lifecycle check at release |
| Environmental sensor | BME280 bare device | BMP390 + humidity device | Bosch | Existing reference and 3.3 V I2C | Placement and module variation | Exact order code/open |
| OLED | Exact SSD1309 module TBD | Approved monochrome I2C OLED | TBD | Reference interface retained | Mechanical/current/pinout/lifecycle | **Open; blocks release** |
| Power connectors | Micro-Fit 3.0 / Mini-Fit Jr. | Qualified equivalent | Molex | Locking service harness ecosystem | Exact terminal derating/availability | Mature families; order codes open |
| Low-current connectors | JST GH | Molex Pico-Lock equivalent | JST / Molex | Compact positive latch | Tooling and field repair | Mature families; order codes open |
| USB receptacle | GCT USB4105 family | Amphenol USB2 Type-C equivalent | GCT / Amphenol | USB2-only sink implementation | Mechanical retention/footprint | Exact part open |

Sources used for capture-basis verification include the current manufacturer pages and datasheets for [TPS2663](https://www.ti.com/product/TPS2663), [LMR38020-Q1](https://www.ti.com/product/LMR38020-Q1), [TPS2121](https://www.ti.com/product/TPS2121), [TPS25947](https://www.ti.com/product/TPS25947), [TPS62130](https://www.ti.com/product/TPS62130), [TPS3890-Q1](https://www.ti.com/product/TPS3890-Q1), [TPS3431-Q1](https://www.ti.com/product/TPS3431-Q1), [SN74LXC8T245](https://www.ti.com/product/SN74LXC8T245), [LM339](https://www.ti.com/product/LM339), [ESP32-S3-WROOM-1](https://documentation.espressif.com/esp32-s3-wroom-1_wroom-1u_datasheet_en.pdf), and [Omron G5Q](https://components.omron.com/eu-en/products/relays/G5Q). Schematic release shall archive the exact datasheet revisions used for every orderable part.

## 21. Remaining open items and readiness

### 21.1 Items that block complete schematic release

1. Approve the abnormal-input pulse energy/profile and exact TPS2663 behavior suffix, TVS, reverse MOSFET, and magnetics.
2. Replace preliminary current estimates with selected-device maxima and a measured/defensible external motor-logic load.
3. Approve exact regulator compensation/passives and orderable suffixes using manufacturer design tools.
4. Select the exact OLED and environmental-sensor implementations, including connector pin order and pull-up population.
5. Close the J9 contact load type, voltage, current, switching life, and regulatory/creepage contract.
6. Partition J8 and select exact connector order codes, terminals, wire gauges, keying, and enclosure exposure.
7. Validate the five-loop threshold network by worst-case analysis and SPICE, including cable, leakage, ESD clamps, and rail tolerance.
8. Complete master-inhibit timing and single-fault analysis; confirm watchdog timeout against firmware startup/update behavior.
9. Validate BTS7960-style and intended alternate motor-driver modules for 5 V logic, powered-off behavior, PWM, enable polarity, and safe coast.
10. Verify USB signal integrity, source current behavior, ESD layout, and all main/USB transition cases.
11. Complete memory-budget approval for N8 and procurement/lifecycle review for every preferred/alternate part.
12. Define enclosure/chassis/shield coupling and the actual environmental, vibration, ingress, and EMC test profiles.

### 21.2 Gate decision

| Gate | Decision |
| --- | --- |
| Preliminary KiCad hierarchy and Sheets 00–09 capture | **Conditionally ready** |
| Complete schematic/ERC release | **Blocked by Section 21.1** |
| PCB layout | **Not authorized** |
| Prototype procurement | **Not authorized** |
| Production release | **Not authorized** |

Preliminary capture shall preserve all `TBD`, provisional, DNP, and validation notes. It shall not select footprints, delete test options, collapse safety returns, expose J11/J12, or convert reference modules into permanent platform dependencies.

## 22. Final engineering report

This package selects a 60 V TPS2663 eFuse power entry, 80 V/2 A LMR38020-Q1 5 V buck, TPS2121 main/USB source mux, efficient 3.3 V core buck, ESP32-S3-WROOM-1-N8, native USB-C device service, 5 V supervised EOL loops, comparator-based hardware STOP qualification, an independent supervisor/watchdog master permit, SN74LXC8T245 motor translation, a fail-off low-side relay driver, calibrated ADC battery sensing, and segmented 100 kHz I2C.

It resolves enough electrical uncertainty to begin preliminary schematic capture. It deliberately leaves product-dependent contact loads, exact external modules, connector mechanics, transient energy, final thermal behavior, and detailed orderable/passive selections open. Those items block schematic release and all PCB activity.

The required next engineering package is **IPC-100 Rev A Preliminary KiCad Schematic Capture (Sheets 00–09)**.
