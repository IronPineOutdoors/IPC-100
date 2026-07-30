# ICD-002 — External Connector, Harness and Service Interface Release

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Status | Accepted with mandatory pre-implementation ECO |
| Date | 2026-07-30 |
| Owner | Iron Pine Outdoors Engineering |
| Controlled sheet | Sheet 09 |

## 1. Executive Summary

ICD-002 releases a bounded physical-interface contract for the required IPC-100 Rev A connectors and factory access. It resolves the six Package 10 blockers without changing GPIO allocation, safety behavior, power ownership, watchdog ownership, motion control, or ICD-001.

GPIO37 remains reserved and unconsumed. GPIO42 remains assigned only to `WATCHDOG_SERVICE_MCU`; this release neither exposes nor reinterprets it.

The selected resolutions are:

- J6 and J7 remain separate optional internal-module connectors. Their I²C branches route through Sheet 07 using independently power-qualified, fail-isolated staged nets. ECO-003 must add four hierarchy routes and the Sheet 07 isolation implementation before Package 10R.
- J8 is physically split into J8A supervised STOP and J8B ordinary UI. No electrical signal is added.
- J9 is a low-energy SELV dry-contact interface limited to 0–30 VDC, 1 A continuous resistive, and 2 A for 100 ms. Unsuppressed inductive switching is prohibited.
- J13 is a USB 2.0 device/UFP service-power-and-data receptacle. Input draw is capped at 500 mA; USB PD, host, source, charging, alternate modes, and field-rail power are prohibited.
- Factory recovery uses dedicated pogo/fixture test pads for UART0, EN, BOOT, ground, and a sense-only 3.3 V reference. The fixture shall not source the controller.
- J11 and J12 remain documentation-only and unpopulated.

No connector manufacturer part number or footprint is selected. Package 10R may begin only after ECO-003 is verified.

## 2. Connector Inventory

The controlled J1–J13 scheme contains eleven Rev A connector designation groups: J1–J10 and J13. J8 has two required physical subconnectors under its existing designation. J11/J12 remain documentary concepts.

| Designation | Functional name and purpose | Signals / contacts | Power / ground / shell | Location and exposure | Mating / service | Harness | Implementation and release |
| --- | --- | --- | --- | --- | --- | --- | --- |
| J1 | Controller battery/input power | `VIN_RAW`, `GND`; 2 | Power + return; no shell required | Enclosure power entry; external/product harness | Power-off mate; service disconnect required upstream | H01 | Package 10R authorized |
| J2 | Axis 1 external-driver logic | `MOTOR_LOGIC_5V_A`, GND, four Axis 1 `_SAFE`; 6 | 5 V logic + return | Internal protected harness | Power-off mate; service replaceable | H02 | Authorized |
| J3 | Axis 2 external-driver logic | `MOTOR_LOGIC_5V_B`, GND, four Axis 2 `_SAFE`; 6 | 5 V logic + return | Internal protected harness | Same as J2 | H03 | Authorized |
| J4 | Left/right supervised limits | Two raw/individual-return pairs; 4 | Field-sense loops, no generic ground | External field harness | Power-off service; field replaceable | H04 | Authorized |
| J5 | Up/down supervised limits | Two raw/individual-return pairs; 4 | Same as J4 | External field harness | Same as J4 | H05 | Authorized |
| J6 | OLED module | `OLED_VCC`, GND, `J6_I2C_SDA`, `J6_I2C_SCL`, `OLED_RESET`; 5 | 3.3 V switched + return | Internal panel/module | Power-off mate; optional/removable | H06 | Authorized after ECO-003 |
| J7 | BME280 environmental module | `SENSOR_VCC`, GND, `J7_I2C_SDA`, `J7_I2C_SCL`; 4 | 3.3 V switched + return | Internal enclosure sensor | Power-off mate; optional/removable | H07 | Authorized after ECO-003 |
| J8A | Supervised Emergency STOP loop | `STOP_IN_RAW`, `STOP_RETURN`; 2 | Dedicated loop, no UI ground | External/operator safety control | Power-off service; field replaceable; distinct keying | H08A | Split required; authorized |
| J8B | Ordinary UI panel | `+3V3_CORE`, `UI_VCC`, GND, ARM, FIRE, encoder A/B/SW, RGB R/G/B, buzzer; 12 | 3.3 V, 5 V/UI, logic return | Operator panel | Power-off mate; field replaceable; cannot mate J8A | H08B | Split required; authorized |
| J9 | Isolated relay dry contacts | NC, COM, NO; 3 | Externally powered SELV circuit; no logic ground | Product/load boundary | Power-off service preferred; load isolation labeling required | H09 | Authorized within Section 5 envelope |
| J10 | Restricted expansion | `EXPANSION_VCC`, GND, J10 SDA/SCL; 4 | 3.3 V/100 mA + return | Internal enclosure accessory | Intentional hot plug prohibited | H10 | Optional/DNP; ICD-001 |
| J11 | Spare GPIO concept | None | None | None | None | None | Documentation-only; no Rev A symbol/pads |
| J12 | CAN/RS-485 concept | None | None | None | None | None | Documentation-only; no Rev A symbol/pads |
| J13 | USB-C service | VBUS, GND, D+/D−, CC1/CC2, shield | USB 5 V input, USB ground, shell | Service opening or internal service access | USB live mating allowed | Standard USB cable | Authorized |
| DFT1 | Factory recovery targets, not a connector designation | UART TX/RX, EN, BOOT, GND, 3V3 sense | Sense-only reference; no shell | Factory-only PCB access | Ground-first fixture | Pogo fixture | Authorized; no populated header |

Physical connector count when all base/optional interfaces are populated is twelve: J1–J7, J8A, J8B, J9, J10, and J13. J10 is DNP by default. DFT1 is a pad group, not a connector.

## 3. J6/J7 Base-Bus Resolution

### 3.1 Selected disposition

**Disposition B — route the required signals through the already accepted Sheet 07 peripheral boundary.**

J6 serves the optional SSD1309 OLED reference module. J7 serves the optional BME280 reference module. They are separate internal connectors because display placement and sensor airflow placement differ. They are not field buses.

Sheet 07 shall create four staged connector-side nets:

- `J6_I2C_SDA` — bidirectional;
- `J6_I2C_SCL` — output, no clock stretching;
- `J7_I2C_SDA` — bidirectional;
- `J7_I2C_SCL` — output, no clock stretching.

Each pair shall pass through an independently enabled, power-off-safe I²C branch switch/buffer on Sheet 07. J6 enable derives from valid `OLED_VCC`; J7 enable derives from valid `SENSOR_VCC`. Both default disconnected and isolate before their peripheral rail becomes invalid. No new processor GPIO is used.

### 3.2 Electrical contract

| Attribute | J6 | J7 |
| --- | --- | --- |
| Device | One SSD1309 OLED module | One BME280 module |
| Address | Fixed `0x3C`; `0x3D` prohibited in Rev A assembly | Fixed `0x76`; `0x77` prohibited |
| Cable | 0.20 m maximum, one point-to-point branch | 0.20 m maximum, one point-to-point branch |
| Branch capacitance | 50 pF maximum including switch, ESD, connector, cable, module | 50 pF maximum |
| Speed | 100 kHz | 100 kHz |
| Clock stretching | Prohibited | Prohibited |
| Pull-ups | Sheet 07 base pair only, 4.70 kΩ; module pull-ups prohibited/DNP | Same |
| Series damping | Sheet 07, 33–100 Ω preliminary, exact value by SI | Same |
| ESD | Sheet 07 electrical owner; Sheet 09 connector-entry placement | Same |
| Power-off leakage | ≤10 µA per bus line into either unpowered module | Same |
| Backfeed | No module rail rise above 0.2 V from bus signals | Same |
| Disconnect | Optional and independently disconnectable | Optional and independently disconnectable |
| Hot plug | Prohibited; power off branch before service | Prohibited |

The existing 200 pF base-bus limit allocates 100 pF to core/on-board circuitry, 50 pF to J6, and 50 pF to J7. J10 is segmented and does not consume this budget. Only one pull-up pair remains on the base bus.

### 3.3 Required process

ECO-003, Peripheral I²C Branch Isolation and Hierarchy Completion, is mandatory before Package 10R. It shall modify only Sheets 00, 07, and 09:

- add the four staged functional nets;
- implement the two fail-isolated Sheet 07 branches;
- route them through Sheet 00;
- add matching Sheet 09 inputs; and
- extend hierarchy regression validation.

This is an ECO and implementation-only hierarchy correction within already accepted Sheet 07/09 ownership. No ADR is required.

## 4. J8 STOP/UI Partition Decision

**SPLIT SAFETY AND UI CONNECTORS REQUIRED**

J8A contains only the supervised NC STOP loop:

| Pin | Signal | Classification | Return |
| ---: | --- | --- | --- |
| 1 | `STOP_IN_RAW` | Supervised safety-loop conductor; open/invalid is conservative | Dedicated |
| 2 | `STOP_RETURN` | Dedicated safety return | Never shared with UI ground |

J8B contains ordinary panel functions:

| Pin | Signal | Classification |
| ---: | --- | --- |
| 1 | `GND` | UI logic/power return |
| 2 | `+3V3_CORE` | Limited UI/encoder reference |
| 3 | `UI_VCC` | Main-only 5 V UI supply |
| 4 | `ENCODER_A_RAW` | Ordinary UI input |
| 5 | `ENCODER_B_RAW` | Ordinary UI input |
| 6 | `ENCODER_SW_RAW` | Ordinary UI input |
| 7 | `ARM_IN_RAW` | Firmware-command input; not safety authorization |
| 8 | `FIRE_IN_RAW` | Firmware-command input; not direct actuation |
| 9 | `RGB_R` | Indicator output |
| 10 | `RGB_G` | Indicator output |
| 11 | `RGB_B` | Indicator output |
| 12 | `BUZZER_OUT` | Indicator output |

J8A and J8B shall use physically incompatible keying. They shall have distinct labels, colors, harness identifiers, enclosure legends, and service instructions. No adapter may combine their returns. J8A routes separately from output, motor, relay, and UI power conductors. An ordinary firmware STOP message or UI input never substitutes for the supervised J8A loop.

Splitting improves fault containment, misconnection resistance, field diagnosis, and certification traceability. It requires no new electrical signal or GPIO.

## 5. J9 Load Contract

### 5.1 Released function

J9 is a product-neutral isolated SELV dry-contact control output. It may serve a CrossWind thrower-trigger input only when that product demonstrates compliance with this envelope. IPC-100 does not name or source the external load.

| Parameter | Released limit |
| --- | --- |
| Load type | Resistive or externally suppressed low-energy control load |
| Operating voltage | 0–30 VDC SELV; no AC mains |
| Normal current | 0–1.0 A continuous |
| Startup/pulse current | 2.0 A maximum for 100 ms |
| Duty | 50% maximum at 1 A; lower current may be continuous |
| Repetition | 1 operation/s maximum sustained; 5 operations/s for no more than 10 s |
| Inductive load | Prohibited unless suppression at load limits contact stress to the released relay curve |
| Cable | 3.0 m maximum |
| Permitted harness drop | 0.25 V maximum at 1 A for the complete COM/load-return loop |
| Return path | External source and return; no IPC-100 ground |
| Polarity | Contacts nonpolar; any external suppression may impose polarity |
| Reverse polarity | No contact consequence within ratings; product protection remains required |
| Disconnect | Open circuit is inactive/no trigger |
| Open under load | Allowed for released resistive/suppressed envelope; prohibited for unsuppressed inductive load |
| Environment | SELV product enclosure/field harness; ingress protection owned by product connector/enclosure |

### 5.2 Rating and conductor calculations

For 20 AWG copper at approximately 33.3 mΩ/m and a 3 m one-way run:

`Vdrop = 2 × 3 m × 0.0333 Ω/m × 1 A ≈ 0.20 V`

This is below the 0.25 V limit. Therefore:

- 20 AWG stranded copper is the preliminary full-envelope recommendation;
- 22 AWG is allowed only for ≤0.5 A validated product loads;
- connector contacts require ≥2 A continuous and ≥5 A/100 ms pulse rating;
- relay contacts require a manufacturer rating of at least 2 A at 30 VDC resistive so the 1 A interface uses no more than 50% of nameplate;
- insulation requires ≥60 VDC rating and 105 °C minimum temperature class;
- cable and connector current shall be derated to 70% or less at maximum enclosure temperature;
- a product fuse or current limiter shall not exceed 1 A continuous/2 A short pulse without requalification; and
- mating-cycle target is ≥100 field-service cycles.

The exact relay, connector, ambient derating, and CrossWind input remain open release items under a new ODI. Package 10R may capture the class and notes but cannot assign a footprint.

## 6. J13 USB-C Service Contract

### 6.1 Exact role

**J13 ROLE — USB 2.0 DEVICE/UFP, SERVICE POWER AND DATA**

J13 supports factory and field-service programming, logs, and recovery. It may power only the core service domain when main power is absent. It is not the sole factory recovery path.

| Attribute | Requirement |
| --- | --- |
| USB role | USB 2.0 device / Type-C UFP only |
| Data | Native ESP32-S3 USB D+/D− |
| CC | Separate 5.1 kΩ ±1% Rd from CC1 and CC2 to logic ground |
| Current before configuration | ≤100 mA |
| Maximum input current | Hardware-capped at 500 mA; source advertisements above default USB current are ignored |
| PD / charging | USB PD, BC1.2 charging, host/source role, DRP, alternate modes, and VCONN prohibited |
| VBUS | Input only; never sourced |
| Reverse current | ≤10 µA from IPC-100 toward VBUS with cable unpowered |
| USB-only | May power `CORE_SOURCE`, `+3V3_CORE`, ESP32, USB, and recovery only |
| Main + USB | Sheet 02 source selector gives main priority and prevents cross-feed |
| Field rails | OLED, sensor, UI, expansion, field sense, relay, and motor logic remain off from USB-only |
| Live mating | Allowed under USB requirements |
| Cable | Standards-compliant USB 2.0 Type-C cable, 2 m maximum |

### 6.2 Ownership

| Function | Owner |
| --- | --- |
| Receptacle symbol, Type-C pin grouping, CC resistors | Sheet 09 |
| Connector-entry low-capacitance D+/D− ESD | Sheet 09 |
| VBUS connector-entry ESD and handoff | Sheet 09 to Sheet 01 |
| VBUS fuse/current bounding/reverse blocking | Sheet 01 |
| Source priority/non-backfeed core mux | Sheet 02 |
| Processor-side 22 Ω tuning and native USB pins | Sheet 03 |
| Common-mode choke | Sheet 09 DNP option only; populate only after USB SI/EMC validation |
| Shield/shell | Sheet 09 and PCB/enclosure interface |

Only one D+/D− ESD array is populated at the connector entry. The Sheet 03 “processor-side ESD boundary” is satisfied by this coordinated strategy and shall not create a duplicate array.

### 6.3 Shield and enclosure

J13 shell uses local `USB_SHIELD`. Provide:

- a direct low-inductance landing to conductive chassis/enclosure when present;
- DNP 0 Ω bond option from shield to chassis;
- DNP 1 nF, ≥1 kV capacitor in parallel with 1 MΩ bleed from shield to logic ground for nonconductive-enclosure EMC evaluation; and
- no default DC shell-to-logic-ground bond until enclosure EMC testing selects the option.

The receptacle must be internal or behind a gasketed/service-sealed opening. Service labeling shall state “USB SERVICE — 5 V INPUT, DEVICE ONLY — NO PD/CHARGING.” Moisture-contaminated mating is prohibited.

No completed-sheet hierarchy change is required for J13.

## 7. Manufacturing Fixture Contract

Rev A uses **dedicated factory pogo-pin test pads plus J13 USB**. No populated header and no field-exposed EN/BOOT/UART connector are authorized.

| DFT target | Direction at IPC-100 | Domain/default | Fixture rule |
| --- | --- | --- | --- |
| `UART0_TX` | Output | 3.3 V; ROM/application driven | Fixture input only; ≥100 kΩ load |
| `UART0_RX` | Input | 3.3 V; Sheet 03 default | Fixture drives through 1 kΩ minimum; never while fixture ground absent |
| `ESP_EN` | Input | 3.3 V pulled high | Open-drain fixture pull-low only; no driven high |
| `ESP_BOOT` | Input | 3.3 V recovery strap | Open-drain fixture pull-low only; release before normal boot |
| `GND` | Reference | Logic ground | First-mate/last-break; two redundant fixture contacts recommended |
| `+3V3_CORE` | Sense output | 3.0–3.45 V | Sense only, ≥100 kΩ; fixture shall not source current |

Optional USB access uses J13, not duplicate fixture pads.

The fixture is factory-only and need not remain accessible after enclosure assembly if J13 remains service-accessible. Sheet 09 owns schematic test symbols; PCB DFT owns pad geometry and placement. Sheet 03 owns electrical defaults and processor-side protection.

Sequence:

1. fixture ground mates;
2. fixture senses 3.3 V and confirms valid range;
3. for UART recovery, assert BOOT low, pulse EN low for 10–100 ms, release EN, then release BOOT after ROM sampling;
4. communicate at a released UART rate, initially 115200 baud;
5. return fixture outputs high impedance;
6. remove signal contacts, then ground.

Fixture driven-current limit is 2 mA per signal and 10 mA total fault current. Incorrect fixture orientation shall be prevented mechanically and verified by target-map recognition.

## 8. Quantitative Harness Envelopes

All gauges are preliminary design recommendations, not procurement releases. Copper conductors are stranded, 105 °C minimum, and rated above the carried voltage.

| Harness | Source/destination | Conductors | Max length | Voltage / continuous / peak | Max drop | Gauge | Pairing/shield | Mechanical/environment |
| --- | --- | ---: | ---: | --- | ---: | --- | --- | --- |
| H01 | Product fused supply to J1 | 2 | 1.0 m | 9–21 V; 2 A continuous design target; 3 A/1 s provisional | 0.5 V | 18 AWG | Power/return pair; no shield normally | External/product enclosure; abrasion sleeve; ≥6× OD bend; strain relief; 50–100 mm service loop |
| H02 | J2 to Axis 1 driver | 6 | 1.0 m | 5 V logic; 100 mA branch; 150 mA/10 ms | 0.25 V | 24–26 AWG | Pair command groups with logic return where practical; unshielded baseline | Internal; separate ≥50 mm from motor leads; low-flex |
| H03 | J3 to Axis 2 driver | 6 | 1.0 m | Same as H02 | 0.25 V | 24–26 AWG | Same | Same |
| H04 | J4 to left/right limits | 4 | 10 m | 5 V supervised, ≈2.3 mA/loop | 0.25 V | 24–26 AWG | Each outbound/return pair twisted; shield in severe EMI only, IPC end | External field; flex as product requires; abrasion/ingress protection |
| H05 | J5 to up/down limits | 4 | 10 m | Same as H04 | 0.25 V | 24–26 AWG | Same | Same |
| H06 | J6 to OLED | 5 | 0.20 m | 3.3 V; 150 mA allocation; 200 mA/10 ms provisional | 0.15 V | 26–28 AWG | SDA/GND and SCL/power geometry; no shield | Internal panel; ≤50 pF branch; low-flex |
| H07 | J7 to BME280 | 4 | 0.20 m | 3.3 V; 50 mA; 75 mA/10 ms | 0.10 V | 26–28 AWG | Same as H06 | Internal sensor; airflow/condensation controlled; ≤50 pF |
| H08A | J8A to STOP | 2 | 10 m | 5 V supervised, ≈2.3 mA | 0.25 V | 24–26 AWG | Dedicated twisted pair; shield if required, IPC end only | External/operator; high-flex where moving; separate safety route |
| H08B | J8B to UI panel | 12 | 1.0 m | 3.3/5 V; 120 mA total UI allocation; 180 mA/10 ms provisional | 0.25 V | 24–26 AWG power, 26–28 AWG signals | Encoder/reference grouping; optional overall shield at IPC end | Operator panel; abrasion/strain relief; cannot mate J8A |
| H09 | J9 to SELV control load | 3 | 3.0 m | 0–30 VDC; 1 A continuous; 2 A/100 ms | 0.25 V | 20 AWG full envelope; 22 AWG only ≤0.5 A | No shield for resistive trigger; segregate from logic | Product/field; 105 °C; load isolation labeling |
| H10 | J10 to approved accessory | 4 | 0.30 m | 3.3 V; 75 mA normal, 100 mA max, 150 mA/10 ms | 0.15 V | 26–28 AWG | ICD-001 geometry; no shield in one enclosure | Internal; no live mate; ≥6× OD bend |
| H13 | USB host to J13 | USB cable | 2.0 m | USB 5 V; 500 mA max | USB-compliant | Standards-compliant cable | Controlled D+/D− and shield | Service; live mate; sealed access |

Minimum bend radius is six times finished cable outside diameter unless the cable manufacturer requires more. Strain relief is required at board/enclosure and remote moving panel. Service loops are allowed only where they cannot contact moving mechanisms or obstruct airflow. Motor power shall not share these harnesses.

## 9. Ground and Shield Matrix

| Domain | Source / purpose | Termination | DC/AC treatment | Fault/service rule |
| --- | --- | --- | --- | --- |
| Power ground | J1/controller supply return | Sheet 01/board ground | Direct DC | Never carry product motor current |
| Logic ground | J2/J3/J6/J7/J8B/J10 interfaces | IPC-100 logic ground and accessory logic reference | Direct DC | Current limited by branch; not chassis |
| Safety return | J4/J5/J8A individual loops | Sheet 04 supervision only | Dedicated conductors; no shared harness return | Open/invalid is conservative; never bridge to UI return in harness |
| Relay circuit | J9 external COM/load loop | External source/return only | Galvanically isolated from logic | Product fuse/suppression owns load fault |
| Shield drain | Optional noisy field harness | IPC-100 enclosure/chassis entry, single-ended | No signal current; accessory end isolated | Inspect continuity; broken shield is diagnostic/EMC issue, not return failure |
| Connector shell | Shielded connector mechanical shell | Chassis/enclosure where conductive | Direct low-inductance chassis bond where released; otherwise DNP network | Never substitute for ground contact |
| USB shield | J13 cable shield | `USB_SHIELD` landing | Chassis 0 Ω option DNP; 1 nF/1 MΩ logic-ground option DNP | Select after enclosure EMC; no uncontrolled pigtail |
| J6/J7 panel shield | Normally none | If needed, IPC-100 end only | Chassis/enclosure, not logic ground | Re-review capacitance |
| Motion logic shield | Normally none | IPC end chassis if later required | Single-ended | Motor power shield remains product-owned |
| J10 shield | None for released in-enclosure cable | IPC enclosure only if optionally used | Single-ended per ICD-001 | No logic return current |

No new board ground domain is created. A chassis landing is an interface/PCB provision whose population follows enclosure selection.

## 10. Connector Performance Classes

| Class | Minimum electrical/mechanical performance |
| --- | --- |
| P1 — controller power | 5 A contact, 30 VDC, ≤10 mΩ initial contact resistance, locking/polarized/keyed, −40 to +85 °C, vibration-retained, ≥50 service cycles, product ingress protection, 18 AWG support, strain relief |
| P2 — protected switched power/control | 2 A contact, 30 VDC, ≤20 mΩ, locking/polarized, −40 to +85 °C, ≥50 cycles, 24–28 AWG support, internal/enclosure protected |
| S1 — supervised safety loop | 1 A contact minimum despite milliamp service, 30 VDC, ≤20 mΩ, positive lock, unique key/color, −40 to +85 °C, vibration resistant, ≥100 field cycles, sealed to product exposure, 24–26 AWG |
| M1 — external-driver logic | 2 A contact, 30 VDC, ≤20 mΩ, locking/keyed per axis, −40 to +85 °C, vibration resistant, ≥50 cycles, 24–26 AWG, no motor-power compatibility |
| L1 — ordinary low-current UI | 1 A contact, 30 VDC, ≤30 mΩ, locking/keyed, −40 to +85 °C, ≥100 field cycles, 24–28 AWG |
| R1 — isolated SELV dry contact | 2 A continuous and 5 A/100 ms contact, 50 VDC, ≤20 mΩ, locking/polarized, touch-safe for released SELV use, −40 to +85 °C, ≥100 cycles, 20 AWG support |
| D1 — local digital bus | 1 A contact, 30 VDC, ≤30 mΩ, locking/keyed, −40 to +85 °C, ≥50 cycles, low parasitic capacitance, 26–28 AWG |
| U1 — USB service | USB 2.0 Type-C compliant signal/power performance, reinforced shell stakes, ≥10,000 mating cycles preferred, service-opening moisture strategy, controlled impedance |
| T1 — manufacturing fixture | Gold-compatible PCB targets, ≥10,000 fixture cycles, keyed fixture map, redundant ground, no populated field connector, factory-only |

Mapping:

- J1 → P1
- J2/J3 → M1
- J4/J5/J8A → S1
- J6/J7/J10 → D1
- J8B → L1
- J9 → R1
- J13 → U1
- DFT1 → T1
- J11/J12 → documentation-only, no performance class because no connector exists.

## 11. Protection Ownership Matrix

| External interface/signals | Current/reverse/backfeed | ESD/surge/filtering | Isolation/buffering/default | Shield/contact sequencing |
| --- | --- | --- | --- | --- |
| J1 `VIN_RAW`, GND | Product fuse + Sheet 01 eFuse/reverse protection | Sheet 01 TVS/filter | Sheet 01 | Sheet 09/cable; power-off service |
| J2 Axis 1 supply/commands | Sheet 02 branch limit; Sheet 05 Ioff | Sheet 05 33 Ω/ESD electrical ownership; PCB places near J2 | Sheet 05 translation, pulldowns, inhibit | Sheet 09/cable |
| J3 Axis 2 supply/commands | Same | Same | Same | Same |
| J4/J5 raw/returns | Sheet 04 excitation/current limits | Sheet 04 ESD/transient/RC | Sheet 04 supervision and defaults | Sheet 09 connector; cable twisted/shield option |
| J8A STOP raw/return | Sheet 04 | Sheet 04 | Sheet 04 supervision and hardware inhibit | Sheet 09 unique key; H08A |
| J8B ARM/FIRE/encoder | Sheets 04/07 | Owning Sheet 04/07 provisions; one connector-entry placement | Sheets 04/07 conditioning/defaults | Sheet 09/cable |
| J8B RGB/buzzer/power | Sheet 02 UI branch; Sheet 07 drivers | Sheet 07 clamp/ESD provisions | Sheet 07 off/silent defaults | Sheet 09 |
| J6 OLED power/reset/SDA/SCL | Sheet 02 OLED branch | Sheet 07 series/ESD; PCB connector placement | Sheet 07 power-qualified branch isolation/reset | Sheet 09; power-off mate |
| J7 sensor power/SDA/SCL | Sheet 02 sensor branch | Sheet 07 series/ESD | Sheet 07 power-qualified branch isolation | Sheet 09 |
| J9 NC/COM/NO | External 1 A fuse/current limit | External load suppression; Sheet 06 coil flyback is unrelated | Sheet 06 relay isolation/authorization | Sheet 09 spacing; H09 |
| J10 power/SDA/SCL | Sheet 02 expansion limit; Sheet 08 backfeed containment | Sheet 08 TVS/series/filter | Sheet 08 segmented buffer/fail-disable | Sheet 09 and ICD-001 |
| J13 VBUS | Sheet 01 500 mA cap/reverse block | Sheet 01 VBUS TVS | Sheet 02 source mux | Sheet 09 receptacle |
| J13 D+/D− | N/A | Sheet 09 single low-C ESD; Sheet 03 22 Ω tuning; choke DNP on 09 | Native USB Sheet 03 | Sheet 09 shell/PCB routing |
| J13 CC1/CC2 | 5.1 kΩ Rd on Sheet 09 | Sheet 09 ESD if selected device requires | Sheet 09 fixed UFP role | Sheet 09 |
| DFT1 UART/EN/BOOT | Fixture 1 kΩ/current limits; no 3V3 source | Sheet 03 local protection/defaults | Fixture open-drain EN/BOOT | PCB DFT/Sheet 09 ground-first |

There are no duplicate intended suppressors. Connector-entry placement does not transfer electrical ownership from the named functional sheet.

## 12. Required Hierarchy Changes

| Affected sheet | Exact label | Producer | Consumer | Direction/type | Existing electrically | Change character | Process |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 07 / 00 / 09 | `J6_I2C_SDA` | Sheet 07 isolated branch | Sheet 09 J6 | Bidirectional open drain | Base SDA exists; staged branch does not | Exposes accepted J6 function with power isolation | ECO-003 |
| 07 / 00 / 09 | `J6_I2C_SCL` | Sheet 07 isolated branch | Sheet 09 J6 | Output open drain | Base SCL exists | Same | ECO-003 |
| 07 / 00 / 09 | `J7_I2C_SDA` | Sheet 07 isolated branch | Sheet 09 J7 | Bidirectional open drain | Base SDA exists | Exposes accepted J7 function with power isolation | ECO-003 |
| 07 / 00 / 09 | `J7_I2C_SCL` | Sheet 07 isolated branch | Sheet 09 J7 | Output open drain | Base SCL exists | Same | ECO-003 |

No hierarchy change is required for J8 splitting, J9, J10, J13, or DFT1. J8A/J8B are physical subdivisions of existing Sheet 09 signals. J13 CC/shield are Sheet 09-local connector functions. DFT1 uses existing Sheet 09 ports and global ground.

ECO-003 does not alter the base I²C controller, addresses, GPIO47/48, pull-up ownership, or architecture. It must complete before Package 10R and be verified by repository hierarchy validation.

## 13. Rev A Connector Release Table

| Designation | Purpose | Class | Signals | Current / voltage | Harness | Live mating | Shield | Status | ODI | Sheet 09 authorization |
| --- | --- | --- | ---: | --- | --- | --- | --- | --- | --- | --- |
| J1 | Controller input | P1 | 2 | 2 A target, 3 A peak; 9–21 V | H01 | No | None normally | Authorized | Power exact-device gates | AUTHORIZED FOR PACKAGE 10R |
| J2 | Axis 1 logic | M1 | 6 | 100 mA; 5 V | H02 | No | None baseline | Authorized | ODI-OUT-002 | AUTHORIZED FOR PACKAGE 10R |
| J3 | Axis 2 logic | M1 | 6 | Same | H03 | No | Same | Authorized | ODI-OUT-002 | AUTHORIZED FOR PACKAGE 10R |
| J4 | Limits 1 | S1 | 4 | ≈2.3 mA/loop; 5 V sense | H04 | No | Optional single-end | Authorized | Input prototype gates | AUTHORIZED FOR PACKAGE 10R |
| J5 | Limits 2 | S1 | 4 | Same | H05 | No | Same | Authorized | Same | AUTHORIZED FOR PACKAGE 10R |
| J6 | OLED | D1 | 5 | 150 mA allocation; 3.3 V | H06 | No | None | ECO pending | ODI-DS-003, ECO-003 | AUTHORIZED AFTER ECO-003 |
| J7 | Sensor | D1 | 4 | 50 mA; 3.3 V | H07 | No | None | ECO pending | ODI-DS-004, ECO-003 | AUTHORIZED AFTER ECO-003 |
| J8A | STOP | S1 | 2 | ≈2.3 mA; 5 V sense | H08A | No | Optional single-end | Authorized split | ODI-CONN-001 closed by ICD-002 | AUTHORIZED FOR PACKAGE 10R |
| J8B | UI | L1 | 12 | 120 mA; 3.3/5 V | H08B | No | Optional IPC-end | Authorized split | RGB/buzzer exact load | AUTHORIZED FOR PACKAGE 10R |
| J9 | SELV dry contact | R1 | 3 | 1 A/30 VDC, 2 A/100 ms | H09 | Power-off preferred | Load-dependent | Restricted authorized | New J9 validation ODI | AUTHORIZED FOR PACKAGE 10R |
| J10 | Expansion | D1 | 4 | 100 mA/3.3 V | H10 | No | None | Optional/DNP | ODI-SCH-020 | AUTHORIZED FOR PACKAGE 10R |
| J11 | Spare concept | N/A | 0 | None | None | N/A | N/A | Documentation-only | ODI-CONN-003 | AUTHORIZED AS DOCUMENTATION-ONLY |
| J12 | Future field bus | N/A | 0 | None | None | N/A | N/A | Documentation-only | ODI-CONN-004 | AUTHORIZED AS DOCUMENTATION-ONLY |
| J13 | USB service | U1 | USB groups | 500 mA/5 V max | USB | Yes | USB shell contract | Authorized | USB SI/EMC validation | AUTHORIZED FOR PACKAGE 10R |
| DFT1 | Factory recovery | T1 | 6 targets | Sense/2 mA signals | Fixture | Controlled | None | Factory-only | Fixture design | AUTHORIZED FOR PACKAGE 10R |

Every required Rev A connector is authorized or documentation-only, subject to mandatory ECO-003 before schematic implementation.

## 14. Failure-Mode Review

| Failure | System response / safety consequence | Protection and required control | Blocking after ICD-002 |
| --- | --- | --- | --- |
| Connector unplugged | Interface unavailable; outputs default safe; J9 open state depends contact selected | Hardware defaults, firmware timeout, labeling | No |
| Partial insertion | No unsafe authorization; possible communication fault | Keying, staggered ground where available, power-off rules, branch isolation | Verify with selected family |
| Wrong connector attempted | Must not mate | Unique key/color/class, layout separation | No |
| Reversed connection | Prevent mechanically | Polarization/keying and harness test | No |
| Open conductor | Safety loops assert/fault; commands/peripherals unavailable | Supervision/defaults/timeout | No |
| Shorted conductor | Branch protection or input supervision contains; no authorization bypass | Named protection owner and current limits | Prototype required |
| Adjacent-pin short | Conservative safety response; powered outputs may current-limit | Pin-order review, keying, protection | Review with Package 10R |
| Water ingress | Leakage/short may disable interface | Sealed enclosure/connector class, service inspection | Product environmental gate |
| Corroded contact | Increased drop/intermittence | Contact class, plating selection later, continuity/service test | No |
| Shield disconnected | EMC degradation only; shield never return | Inspection and single-ended rule | No |
| Ground disconnected | Logic communication fails; safety loops use dedicated returns | Ground-first contacts and conservative defaults | Prototype |
| USB inserted while main powered | Main remains priority; no cross-feed | Sheets 01/02 reverse blocking | No |
| USB inserted unpowered | Core-only service starts; field/actuator rails off | ADR-039 power path | No |
| Fixture connected incorrectly | No external 3V3 source; current limited; no high drive | Keyed pogo map, 1 kΩ drives, ground-first | Fixture validation |
| J8A/J8B swap attempted | Must not mate | Incompatible keying/color/labels | No |
| Motion/load connector opened under load | Logic commands disappear; motor power remains product-owned; J9 resistive load may open | Power-off service label; product controls motor energy; J9 load envelope | No |
| Accessory externally powered | Prohibited; isolated branches limit injection | Sheet 07/08 Ioff and labeling | Verify |
| Controller externally unpowered | No accessory may backfeed | Branch isolation/reverse blocking | Verify |
| Excessive harness length | Timing, noise, voltage-drop failures | Maximum-length labels and harness part control | No |
| Undersized conductor | Heating/drop | Gauge table, crimp inspection, product part control | No |
| Failed strain relief | Intermittent/open/short | Clamp/pull test/service inspection | Mechanical validation |
| J9 inductive load without suppression | Contact arcing/weld risk | Explicit prohibition, external suppression/fuse label | Blocks that product configuration |

No connector fault directly creates `ACTUATOR_PERMIT`, suppresses `MASTER_INHIBIT`, overrides STOP, or spoofs the watchdog.

## 15. Open Design Items

- ECO-003 implementation and verification.
- Exact OLED and BME280 module ordering codes, pinouts, branch switches, ESD, and effective bus capacitance.
- Exact J9 relay and product load validation against the restricted envelope.
- Final connector families, footprints, contact plating, and derating.
- Exact J1 input current/thermal verification above the preliminary 2 A target.
- RGB/buzzer load and J8B simultaneous-current validation.
- USB signal-integrity, ESD, shield-option, enclosure, and moisture validation.
- Factory fixture drawing, pogo map, target geometry, and programming procedure.
- Harness insulation, color, flex, abrasion, sealing, crimp-tool, pull-test, and production part release.
- Native ERC, full schematic review, DFM, prototype fault injection, EMC, vibration, ingress, and service-cycle tests.

## 16. Package 10R Authorized Scope

After ECO-003 is completed and verified, Package 10R may:

- implement abstract, family-neutral connector symbols for J1–J10 and J13;
- split J8 into J8A and J8B using only existing signals;
- implement J13 CC1/CC2 Rd, one coordinated D+/D− ESD provision, VBUS handoff, DNP common-mode choke option, and shield-coupling options;
- implement DFT1 schematic test nodes for UART0, EN, BOOT, ground, and sense-only 3.3 V;
- add connector/harness/class/protection/service notes and logical pin numbering;
- expose the four ECO-003 J6/J7 staged I²C nets;
- retain J10 DNP and J11/J12 documentation-only;
- add no logic beyond connector-local USB passive/protection and physical-access provisions; and
- assign no footprints or final manufacturer parts.

Package 10R shall not alter GPIOs, consume GPIO37, reinterpret GPIO42, create a bus, add actuator/safety commands, modify Sheets 01–08 beyond the completed ECO-003, assign footprints, or begin PCB work.

## 17. Final Decision

**ICD-002 ACCEPTED — PACKAGE 10R AUTHORIZED**

Authorization is conditional on completing and verifying ECO-003 before Sheet 09 implementation.

## Appendix A — 54-Port Sheet 09 Trace

Every frozen Sheet 09 port is accounted for:

| Port | Disposition |
| --- | --- |
| `+5V_MAIN` | DFT/prototype observation only |
| `+3V3_CORE` | J8B and DFT1 sense |
| `MOTOR_LOGIC_5V_A` | J2 |
| `MOTOR_LOGIC_5V_B` | J3 |
| `OLED_VCC` | J6 |
| `SENSOR_VCC` | J7 |
| `UI_VCC` | J8B |
| `EXPANSION_VCC` | J10 |
| `VIN_PROTECTED` | DFT/prototype observation |
| `USB_5V_PROTECTED` | DFT/prototype observation |
| `CORE_SOURCE` | DFT/prototype observation |
| `BATTERY_SENSE` | DFT/prototype observation |
| `MAIN_POWER_GOOD` | DFT/prototype observation |
| `AXIS1_RPWM_SAFE` | J2 |
| `AXIS1_LPWM_SAFE` | J2 |
| `AXIS1_REN_SAFE` | J2 |
| `AXIS1_LEN_SAFE` | J2 |
| `AXIS2_RPWM_SAFE` | J3 |
| `AXIS2_LPWM_SAFE` | J3 |
| `AXIS2_REN_SAFE` | J3 |
| `AXIS2_LEN_SAFE` | J3 |
| `RELAY_NC` | J9 |
| `RELAY_COM` | J9 |
| `RELAY_NO` | J9 |
| `RGB_R` | J8B |
| `RGB_G` | J8B |
| `RGB_B` | J8B |
| `BUZZER_OUT` | J8B |
| `OLED_RESET` | J6 |
| `J10_I2C_SCL` | J10 |
| `UART0_TX` | DFT1 |
| `VIN_RAW` | J1 |
| `USB_VBUS_RAW` | J13 |
| `UART0_RX` | DFT1 |
| `ESP_EN` | DFT1 |
| `ESP_BOOT` | DFT1 |
| `STOP_IN_RAW` | J8A |
| `STOP_RETURN` | J8A |
| `LIMIT_LEFT_RAW` | J4 |
| `LIMIT_LEFT_RETURN` | J4 |
| `LIMIT_RIGHT_RAW` | J4 |
| `LIMIT_RIGHT_RETURN` | J4 |
| `LIMIT_UP_RAW` | J5 |
| `LIMIT_UP_RETURN` | J5 |
| `LIMIT_DOWN_RAW` | J5 |
| `LIMIT_DOWN_RETURN` | J5 |
| `ARM_IN_RAW` | J8B |
| `FIRE_IN_RAW` | J8B |
| `ENCODER_A_RAW` | J8B |
| `ENCODER_B_RAW` | J8B |
| `ENCODER_SW_RAW` | J8B |
| `J10_I2C_SDA` | J10 |
| `USB_D+` | J13 |
| `USB_D-` | J13 |

ECO-003 will add four staged J6/J7 ports after this frozen baseline; they are not counted among the existing 54.
