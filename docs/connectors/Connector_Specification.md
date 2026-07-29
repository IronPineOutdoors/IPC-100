# IPC-100 Connector Specification

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Connector Specification |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-29 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose

This document reserves preliminary PCB connector identifiers and stable signal names. Pin reservations are proposed architecture inputs, not released connector pinouts. Physical connector families remain `TBD`, except that J13 is a USB-C interface.

Directions are relative to IPC-100. `Power out` entries are limited logic/interface power only.

## 2. Connector numbering

| Reference | Function | Preliminary pin count | Status |
| --- | --- | ---: | --- |
| J1 | Power Input | 2 | Proposed |
| J2 | Axis 1 Motor Driver Logic | 6 | Proposed |
| J3 | Axis 2 Motor Driver Logic | 6 | Proposed |
| J4 | Directional Limit Inputs 1 | 4 logical | Architecture revised; physical connector TBD |
| J5 | Directional Limit Inputs 2 | 4 logical | Architecture revised; physical connector TBD |
| J6 | OLED | 5 | Proposed |
| J7 | Environmental Sensor | 4 | Proposed |
| J8 | User Controls and Indicators | 14 logical if combined | Partition TBD |
| J9 | Isolated Relay Contacts | 3 | Proposed |
| J10 | I2C Expansion | 4 | Proposed |
| J11 | Spare GPIO Expansion | TBD | TBD |
| J12 | Future Communications Reservation | TBD | Proposed |
| J13 | USB-C Service Interface | USB-C USB 2.0 pin groups | Locked |

## 3. J1 — Power Input

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `VIN_RAW` | Power in | 9–21 V DC | N/A | Controller power input and source for `BATTERY_SENSE` divider | Reverse polarity, fuse, TVS, and filter TBD | No motor current | Locked |
| 2 | `GND` | Power return | 0 V | N/A | Controller input return | TBD | Must not carry motor return current | Locked |

## 4. J2 — Axis 1 Motor Driver Logic

J2 preserves the six-pin BTS7960-style reference contract without promising universal compatibility. The hardware-safe state is both PWM commands inactive and both enables disabled. A hardware master inhibit overrides all four signals during STOP, invalid main power, reset, brownout, watchdog recovery, USB-only service, and uninitialized operation. Direction commands are mutually exclusive and reversal passes through disabled/coast. Logic levels, active polarity, PWM timing, drive capability, grounding, cable, protection, and backfeed implementation remain `TBD`. `+5V` is limited main-only logic power; neither it nor `GND` carries motor current.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+5V` | Power out | 5 V | N/A | Limited external-driver logic supply provision | Current limit/filter TBD | Not motor power | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Logic reference | TBD | Not motor return | Locked |
| 3 | `AXIS1_RPWM` | Output | TBD logic | Approved PWM/static command | Axis 1 direction-A command | Hardware inactive/master inhibit; drive/protection TBD | Mutually exclusive with LPWM | Locked |
| 4 | `AXIS1_LPWM` | Output | TBD logic | Approved PWM/static command | Axis 1 direction-B command | Hardware inactive/master inhibit; drive/protection TBD | Mutually exclusive with RPWM | Locked |
| 5 | `AXIS1_REN` | Output | TBD logic | Approved enabled state | Axis 1 direction-A enable provision | Hardware disabled/master inhibit; drive/protection TBD | Exact mapping may change; safe state fixed | Locked |
| 6 | `AXIS1_LEN` | Output | TBD logic | Approved enabled state | Axis 1 direction-B enable provision | Hardware disabled/master inhibit; drive/protection TBD | Exact mapping may change; safe state fixed | Locked |

## 5. J3 — Axis 2 Motor Driver Logic

J3 uses the same output contract, master inhibit, mutually exclusive direction policy, disabled reversal transition, power boundary, and unresolved quantitative electrical items as J2.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+5V` | Power out | 5 V | N/A | Limited external-driver logic supply provision | Current limit/filter TBD | Not motor power | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Logic reference | TBD | Not motor return | Locked |
| 3 | `AXIS2_RPWM` | Output | TBD logic | Approved PWM/static command | Axis 2 direction-A command | Hardware inactive/master inhibit; drive/protection TBD | Mutually exclusive with LPWM | Locked |
| 4 | `AXIS2_LPWM` | Output | TBD logic | Approved PWM/static command | Axis 2 direction-B command | Hardware inactive/master inhibit; drive/protection TBD | Mutually exclusive with RPWM | Locked |
| 5 | `AXIS2_REN` | Output | TBD logic | Approved enabled state | Axis 2 direction-A enable provision | Hardware disabled/master inhibit; drive/protection TBD | Exact mapping may change; safe state fixed | Locked |
| 6 | `AXIS2_LEN` | Output | TBD logic | Approved enabled state | Axis 2 direction-B enable provision | Hardware disabled/master inhibit; drive/protection TBD | Exact mapping may change; safe state fixed | Locked |

## 6. J4 — Directional Limit Inputs 1

J4 reserves two individually returned, normally-closed, de-energize-to-safe supervised dry-contact loops. Opening a loop asserts/faults its limit; an invalid or shorted supervision state shall be distinguishable from healthy where required by the approved field termination. These signals do not connect directly to processor GPIO. The four logical conductors below replace the earlier shared-return three-conductor concept; physical connector, field-sense voltage, supervision termination, protection, filtering, and numeric cable limit remain `TBD`.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `LIMIT_LEFT_RETURN` | Field-sense return | TBD | N/A | Dedicated left-loop return | Fault containment/protection TBD | Not motor or power return | Proposed |
| 2 | `LIMIT_LEFT` | Input | TBD field sense | Open loop asserted/faulted | Product-neutral left-direction supervised NC limit loop | ESD, transient, supervision, filtering, and biasing TBD | Unknown/fault inhibits leftward motion | Locked |
| 3 | `LIMIT_RIGHT_RETURN` | Field-sense return | TBD | N/A | Dedicated right-loop return | Fault containment/protection TBD | Not motor or power return | Proposed |
| 4 | `LIMIT_RIGHT` | Input | TBD field sense | Open loop asserted/faulted | Product-neutral right-direction supervised NC limit loop | ESD, transient, supervision, filtering, and biasing TBD | Unknown/fault inhibits rightward motion | Locked |

## 7. J5 — Directional Limit Inputs 2

J5 reserves two individually returned, normally-closed, de-energize-to-safe supervised dry-contact loops under the same contract as J4. The four logical conductors replace the earlier shared-return concept. Physical connector, field-sense voltage, supervision termination, protection, filtering, and numeric cable limit remain `TBD`.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `LIMIT_UP_RETURN` | Field-sense return | TBD | N/A | Dedicated up-loop return | Fault containment/protection TBD | Not motor or power return | Proposed |
| 2 | `LIMIT_UP` | Input | TBD field sense | Open loop asserted/faulted | Product-neutral up-direction supervised NC limit loop | ESD, transient, supervision, filtering, and biasing TBD | Unknown/fault inhibits upward motion | Locked |
| 3 | `LIMIT_DOWN_RETURN` | Field-sense return | TBD | N/A | Dedicated down-loop return | Fault containment/protection TBD | Not motor or power return | Proposed |
| 4 | `LIMIT_DOWN` | Input | TBD field sense | Open loop asserted/faulted | Product-neutral down-direction supervised NC limit loop | ESD, transient, supervision, filtering, and biasing TBD | Unknown/fault inhibits downward motion | Locked |

## 8. J6 — OLED

The exact display module and physical connector remain `TBD`. The 2.42-inch SSD1309 OLED is the current reference implementation only.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `OLED_VCC` | Power out | 3.3 V nominal | N/A | Main-qualified switched OLED supply | 150 mA allocation; controlled rise/discharge; exact containment TBD | Verify exact module compatibility | ADR-039 |
| 2 | `GND` | Power return | 0 V | N/A | OLED return | TBD |  | Locked |
| 3 | `I2C_SDA` | Bidirectional | TBD logic | N/A | Shared I2C data | ESD/series resistor TBD | Pull-up ownership and level compatibility TBD | Locked |
| 4 | `I2C_SCL` | Output | TBD logic | N/A | Shared I2C clock | ESD/series resistor TBD | Pull-up ownership and level compatibility TBD | Locked |
| 5 | `OLED_RESET` | Output | TBD logic | Logical reset asserted; reference active low | Dedicated OLED reset | Hardware default asserted/non-driving; interface protection TBD | Release only after valid `OLED_VCC`; no USB-only backfeed | Locked |

## 9. J7 — Environmental Sensor

The exact sensor population and physical connector remain `TBD`. BME280 is the current reference implementation only.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `SENSOR_VCC` | Power out | 3.3 V nominal | N/A | Main-qualified switched environmental-sensor supply | 50 mA allocation; controlled rise/discharge; exact containment TBD | Exact module current/compatibility TBD | ADR-039 |
| 2 | `GND` | Power return | 0 V | N/A | Sensor return | TBD |  | Locked |
| 3 | `I2C_SDA` | Bidirectional | TBD logic | N/A | Shared I2C data | ESD/series resistor TBD | Address, pull-ups, and level compatibility TBD | Locked |
| 4 | `I2C_SCL` | Output | TBD logic | N/A | Shared I2C clock | ESD/series resistor TBD | Level compatibility TBD | Locked |

## 10. J8 — User Controls and Indicators

J8 command and encoder voltage domains, pull/bias implementation, filtering, and protection remain `TBD`; no input connects directly to processor GPIO. ARM and FIRE are momentary normally-open dry-contact commands. Encoder A/B and push are non-safety dry-contact UI inputs. `STOP_IN` is a normally-closed supervised loop with a dedicated return and remains independent of encoder, ARM, FIRE, display, wireless, and optional expansion functions.

The RGB channels and buzzer are reusable outputs. RGB LED topology, polarity, current, brightness control, and protection, plus buzzer device type, drive domain, acoustic behavior, and onboard versus external population remain `TBD`. Driver stages may be required; direct processor-GPIO drive is not assumed.

The combined J8 allocation remains a logical reservation, not a released physical connector. Adding a dedicated `STOP_RETURN` makes the combined concept 14 conductors. STOP may require a distinct connector or harness route; encoder wiring may terminate at a handheld or panel controller; and RGB or buzzer wiring may terminate elsewhere. Final partitioning requires explicit connector, safety, harness, and product-family review.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `GND` | Power return | 0 V | N/A | Control reference | TBD | Product panel wiring external | Locked |
| 2 | `+3V3` | Power out | 3.3 V | N/A | Limited control supply | Current protection TBD | Budget TBD | Proposed |
| 3 | `ENCODER_A` | Input | TBD | TBD | Encoder phase A | ESD/transient/filter/bias TBD | Interrupt capability preferred; decoding behavior TBD | Locked |
| 4 | `ENCODER_B` | Input | TBD | TBD | Encoder phase B | ESD/transient/filter/bias TBD | Interrupt capability preferred; decoding behavior TBD | Locked |
| 5 | `ENCODER_SW` | Input | TBD | TBD | Encoder push button | ESD/transient/filter/bias TBD | Interaction behavior TBD | Locked |
| 6 | `ARM_IN` | Input | TBD field sense | Contact closed | Momentary normally-open ARM command | ESD/transient/filter/bias TBD | Held at startup is invalid; never directly energizes outputs | Locked |
| 7 | `FIRE_IN` | Input | TBD field sense | Contact closed/new qualified edge | Momentary normally-open FIRE request | ESD/transient/filter/bias TBD | Requires valid ARM sequence and release-before-retrigger | Locked |
| 8 | `STOP_RETURN` | Field-sense return | TBD | N/A | Dedicated STOP-loop return | Fault containment/protection TBD | Not shared with command/encoder return | Proposed |
| 9 | `STOP_IN` | Input | TBD field sense | Open loop asserted/faulted | Dedicated supervised NC STOP loop | ESD, transient, supervision, filtering, and biasing TBD | Unknown/fault forces STOP-safe interpretation | Locked |
| 10 | `RGB_R` | Output | TBD main-only UI | Logical active TBD | Red status channel | Hardware default off; drive/protection TBD | Off in reset/brownout/USB-only | Locked |
| 11 | `RGB_G` | Output | TBD main-only UI | Logical active TBD | Green status channel | Hardware default off; drive/protection TBD | Off in reset/brownout/USB-only | Locked |
| 12 | `RGB_B` | Output | TBD main-only UI | Logical active TBD | Blue status channel | Hardware default off; drive/protection TBD | Off in reset/brownout/USB-only | Locked |
| 13 | `BUZZER_OUT` | Output | TBD main-only UI | Static/waveform TBD | Buzzer control | Hardware default silent; transient/drive protection TBD | Silent in reset/brownout/USB-only | Locked |
| 14 | `+5V` | Power out | 5 V | N/A | Optional indicator/buzzer supply provision | Current protection TBD | Use depends on final loads | Proposed |

## 11. J9 — Isolated Relay Contacts

J9 exposes an isolated, externally powered dry-contact set and is not a power source. The coil is main-only and hardware-inhibited during STOP, invalid main power, reset, brownout, watchdog recovery, USB-only service, and uninitialized operation. The platform safe state is coil de-energized with `RELAY_NO` open; no product safety meaning is assigned to `RELAY_NC`. Contact voltage, current, load type, minimum-load behavior, switching frequency, isolation rating, creepage, clearance, fusing, environmental derating, and relay selection remain `TBD`.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `RELAY_NC` | Passive contact | Isolated/TBD rating | Closed when de-energized | Normally closed contact | Contact protection external/TBD | No controller-sourced load power | Locked |
| 2 | `RELAY_COM` | Passive contact | Isolated/TBD rating | Common | Relay contact common | Contact protection external/TBD |  | Locked |
| 3 | `RELAY_NO` | Passive contact | Isolated/TBD rating | Open when de-energized | Normally open contact | Contact protection external/TBD | Platform safe-state contact; product validates load | Locked |

## 12. J10 — I2C Expansion

J10 is an optional controlled local shared-bus expansion provision, not a general-purpose field bus, and does not promise compatibility with arbitrary peripherals or wiring. Pull-up ownership, available power, supply domains, address compatibility, cable assumptions, supported loading, hot-plug policy, physical segmentation, fault behavior, and recovery remain `TBD`.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+3V3` | Power out | 3.3 V | N/A | Proposed limited expansion supply | Current protection TBD | Availability and reserve defined by approved power budget | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Expansion return | TBD |  | Locked |
| 3 | `I2C_SDA` | Bidirectional | TBD logic | N/A | Shared I2C data | ESD/series resistor TBD | Bus loading, cable, address, and pull-ups TBD | Locked |
| 4 | `I2C_SCL` | Output | TBD logic | N/A | Shared I2C clock | ESD/series resistor TBD | Bus loading, cable, and pull-ups TBD | Locked |

## 13. J11 — Spare GPIO Expansion

Final pin count, signal count, electrical function, protection, voltage domain, and power availability are `TBD`. The proposed direct processor allocation leaves only one conditional GPIO reserve and cannot guarantee both concepts below. They are not a four-pin pinout and do not guarantee bidirectional, analog, PWM, interrupt, open-drain, current-drive, direct-processor, or universal-voltage capability.

| Concept | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Power provision | `+3V3` | Power out | 3.3 V | N/A | Candidate limited expansion supply | Current protection TBD | Inclusion and availability pending approved budget and connector architecture | Proposed |
| Return provision | `GND` | Power return | 0 V | N/A | Candidate expansion return | TBD | Inclusion pending connector architecture | Proposed |
| Expansion signal | `SPARE_GPIO1` | TBD | TBD | TBD | Stable spare-interface concept | TBD | Final capability and interface circuitry TBD | TBD |
| Expansion signal | `SPARE_GPIO2` | TBD | TBD | TBD | Stable spare-interface concept | TBD | Final capability and interface circuitry TBD | TBD |

## 14. J12 — Future Communications

J12 is an identifier reserved for future communications expansion; it is not a defined production connector. CAN and RS485 are electrically different interfaces and are not interchangeable without approved circuitry. No pin count, pin numbering, connector family, shared-versus-separate architecture, transceiver population, termination, biasing, isolation, bus voltage, power provision, or protocol is approved.

| Reserved concept | Direction | Voltage domain | Description | Implementation | Status |
| --- | --- | --- | --- | --- | --- |
| `CAN_H` | Bidirectional | TBD | Future CAN differential high concept | Transceiver, connector, termination, isolation, and protocol TBD | Proposed |
| `CAN_L` | Bidirectional | TBD | Future CAN differential low concept | Transceiver, connector, termination, isolation, and protocol TBD | Proposed |
| `RS485_A` | Bidirectional | TBD | Future RS485 differential A concept | Transceiver, connector, termination, biasing, isolation, and protocol TBD | Proposed |
| `RS485_B` | Bidirectional | TBD | Future RS485 differential B concept | Transceiver, connector, termination, biasing, isolation, and protocol TBD | Proposed |

## 15. J13 — USB-C

J13 is the USB-C USB 2.0 service interface for programming and diagnostics. Exact receptacle and native USB versus external USB-to-UART implementation are `TBD`.

| USB-C pins | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A4, A9, B4, B9 | `USB_VBUS` | Power in | 5 V nominal | N/A | Protected source for bounded ESP32-S3 core service only | ESD, current bounding, and reverse-current block TBD | No charging, VBUS sourcing, or external-load power | Locked |
| A1, A12, B1, B12 | `GND` | Power return | 0 V | N/A | USB return | TBD |  | Locked |
| A6, B6 | `USB_D+` | Bidirectional | USB 2.0 | Differential | USB data positive | Low-capacitance ESD TBD | Route as differential pair | Locked |
| A7, B7 | `USB_D-` | Bidirectional | USB 2.0 | Differential | USB data negative | Low-capacitance ESD TBD | Route as differential pair | Locked |
| A5 | `USB_CC1` | Bidirectional | USB Type-C CC | N/A | Configuration channel 1 | Resistor/ESD TBD | Device role TBD | TBD |
| B5 | `USB_CC2` | Bidirectional | USB Type-C CC | N/A | Configuration channel 2 | Resistor/ESD TBD | Device role TBD | TBD |
| Shield | `USB_SHIELD` | Chassis/shield | N/A | N/A | Cable shield | Chassis/ground coupling TBD | Mechanical tabs per receptacle | TBD |

## 16. Formal open connector-design items

| ID | Open decision | Required stage | Status |
| --- | --- | --- | --- |
| CONN-TBD-001 | Determine whether J8 remains one combined connector or is partitioned into dedicated safety-control, navigation, and indicator connectors. | Before schematic release | TBD |
| CONN-TBD-002 | Resolve J11 through resource reduction, a conditional single spare, removal from released Rev A, or another reviewed architecture; then define function, protection, voltage, power, and pin count. | Before schematic release | Proposed direct GPIO plan cannot guarantee two spares |
| CONN-TBD-003 | Determine whether future CAN and RS485 provisions share one configurable connector, use separate connectors, remain unpopulated footprints, or move to daughterboard expansion. | Before schematic release | TBD |

See [Connector Architecture Review](Connector_Architecture_Review.md) for cross-connector risks, partitioning concerns, and unresolved mechanical decisions.

## 16. Internal stable signals

`BATTERY_SENSE` is an internal protected analog signal derived from `VIN_RAW`; it is not exposed on an external connector. Relay-coil control and native USB are assigned in the proposed GPIO map. UART0 is reserved for recovery/test access; future transceiver-side logic signals have no physical Rev A pin guarantee.

## 17. Connector-selection requirements

- Locking where practical
- Polarized and keyed
- Field-serviceable with controlled tooling
- Rated for the verified voltage and continuous/peak current
- Suitable for the defined vibration environment
- Suitable for enclosed outdoor equipment
- Available with appropriate wire, terminal, seal, and accessory ecosystems
- Generic prototype connectors may differ from production connectors when documented

Physical connector families, plating, pitch, current rating, ingress accessories, and approved alternates remain `TBD`.

## 18. Interface-layer distinction

| Layer | Definition | Controlled by |
| --- | --- | --- |
| PCB connector | Component mounted to IPC-100 and defined by this design | IPC-100 repository |
| Enclosure feedthrough | Bulkhead, gland, or panel interface through the product enclosure | Product repository |
| External harness connector | Mated field connector and product harness termination | Product repository, constrained by IPC-100 interface |

## 19. Related documents

- [System Architecture](../architecture/System_Architecture.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [GPIO Map](GPIO_Map.md)
- [GPIO and Peripheral Allocation Review](GPIO_and_Peripheral_Allocation_Review.md)
- [Wiring Standard](../requirements/Wiring_Standard.md)
- [Power Budget](../power/Power_Budget.md)
