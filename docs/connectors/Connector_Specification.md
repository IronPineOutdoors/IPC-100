# IPC-100 Connector Specification

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Connector Specification |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
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
| J4 | Horizontal Limit Inputs | 3 | Proposed |
| J5 | Vertical Limit Inputs | 3 | Proposed |
| J6 | OLED | 5 | Proposed |
| J7 | BME280 | 4 | Proposed |
| J8 | User Controls and Indicators | 13 | Proposed |
| J9 | Thrower Relay Contacts | 3 | Proposed |
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

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+5V` | Power out | 5 V | N/A | Limited external-driver logic supply provision | Current limit/filter TBD | Not motor power | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Logic reference | TBD | Not motor return | Locked |
| 3 | `AXIS1_RPWM` | Output | TBD logic | High/PWM | Axis 1 right/forward PWM command | Series/ESD TBD | Level compatibility TBD | Locked |
| 4 | `AXIS1_LPWM` | Output | TBD logic | High/PWM | Axis 1 left/reverse PWM command | Series/ESD TBD | Level compatibility TBD | Locked |
| 5 | `AXIS1_REN` | Output | TBD logic | High enables | Axis 1 right enable provision | Pull to disabled state; ESD TBD | Exact enable implementation may change | Locked |
| 6 | `AXIS1_LEN` | Output | TBD logic | High enables | Axis 1 left enable provision | Pull to disabled state; ESD TBD | Exact enable implementation may change | Locked |

## 5. J3 — Axis 2 Motor Driver Logic

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+5V` | Power out | 5 V | N/A | Limited external-driver logic supply provision | Current limit/filter TBD | Not motor power | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Logic reference | TBD | Not motor return | Locked |
| 3 | `AXIS2_RPWM` | Output | TBD logic | High/PWM | Axis 2 right/up PWM command | Series/ESD TBD | Level compatibility TBD | Locked |
| 4 | `AXIS2_LPWM` | Output | TBD logic | High/PWM | Axis 2 left/down PWM command | Series/ESD TBD | Level compatibility TBD | Locked |
| 5 | `AXIS2_REN` | Output | TBD logic | High enables | Axis 2 right enable provision | Pull to disabled state; ESD TBD | Exact enable implementation may change | Locked |
| 6 | `AXIS2_LEN` | Output | TBD logic | High enables | Axis 2 left enable provision | Pull to disabled state; ESD TBD | Exact enable implementation may change | Locked |

## 6. J4 — Horizontal Limit Inputs

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `GND` | Power return | 0 V | N/A | Switch reference | TBD | Topology TBD | Proposed |
| 2 | `LIMIT_LEFT` | Input | 3.3 V logic | TBD | Horizontal left limit | ESD, filtering, and external pull provision | Contact convention TBD | Locked |
| 3 | `LIMIT_RIGHT` | Input | 3.3 V logic | TBD | Horizontal right limit | ESD, filtering, and external pull provision | Contact convention TBD | Locked |

## 7. J5 — Vertical Limit Inputs

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `GND` | Power return | 0 V | N/A | Switch reference | TBD | Topology TBD | Proposed |
| 2 | `LIMIT_UP` | Input | 3.3 V logic | TBD | Vertical upper limit | ESD, filtering, and external pull provision | Contact convention TBD | Locked |
| 3 | `LIMIT_DOWN` | Input | 3.3 V logic | TBD | Vertical lower limit | ESD, filtering, and external pull provision | Contact convention TBD | Locked |

## 8. J6 — OLED

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `OLED_VCC` | Power out | TBD | N/A | OLED module supply | Decoupling/current protection TBD | Verify module compatibility | TBD |
| 2 | `GND` | Power return | 0 V | N/A | OLED return | TBD |  | Locked |
| 3 | `I2C_SDA` | Bidirectional | 3.3 V logic | N/A | Shared I2C data | ESD/series resistor TBD | Pull-up ownership TBD | Locked |
| 4 | `I2C_SCL` | Output | 3.3 V logic | N/A | Shared I2C clock | ESD/series resistor TBD | Pull-up ownership TBD | Locked |
| 5 | `OLED_RESET` | Output | 3.3 V logic | Low resets | Dedicated OLED reset | Series/pull TBD | Boot behavior TBD | Locked |

## 9. J7 — BME280

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+3V3` | Power out | 3.3 V | N/A | Sensor supply | Decoupling/current limit TBD | Module current TBD | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Sensor return | TBD |  | Locked |
| 3 | `I2C_SDA` | Bidirectional | 3.3 V logic | N/A | Shared I2C data | ESD/series resistor TBD | Address/pull-ups TBD | Locked |
| 4 | `I2C_SCL` | Output | 3.3 V logic | N/A | Shared I2C clock | ESD/series resistor TBD |  | Locked |

## 10. J8 — User Controls and Indicators

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `GND` | Power return | 0 V | N/A | Control reference | TBD | Product panel wiring external | Locked |
| 2 | `+3V3` | Power out | 3.3 V | N/A | Limited control supply | Current protection TBD | Budget TBD | Proposed |
| 3 | `ENCODER_A` | Input | 3.3 V logic | TBD | Encoder phase A | ESD/filter/pull TBD | Interrupt preferred | Locked |
| 4 | `ENCODER_B` | Input | 3.3 V logic | TBD | Encoder phase B | ESD/filter/pull TBD | Interrupt preferred | Locked |
| 5 | `ENCODER_SW` | Input | 3.3 V logic | TBD | Encoder push button | ESD/filter/pull TBD |  | Locked |
| 6 | `ARM_IN` | Input | 3.3 V logic | TBD | ARM physical input | ESD/filter/pull TBD | Product behavior external | Locked |
| 7 | `FIRE_IN` | Input | 3.3 V logic | TBD | FIRE physical input | ESD/filter/pull TBD | Product behavior external | Locked |
| 8 | `STOP_IN` | Input | 3.3 V logic | TBD | Dedicated STOP input | ESD/filter/pull TBD | Safety-relevant | Locked |
| 9 | `RGB_R` | Output | TBD | TBD | Red status channel | Driver/current limit TBD | LED topology TBD | Locked |
| 10 | `RGB_G` | Output | TBD | TBD | Green status channel | Driver/current limit TBD | LED topology TBD | Locked |
| 11 | `RGB_B` | Output | TBD | TBD | Blue status channel | Driver/current limit TBD | LED topology TBD | Locked |
| 12 | `BUZZER_OUT` | Output | TBD | TBD/PWM | Buzzer control | Driver/flyback TBD | Buzzer type TBD | Locked |
| 13 | `+5V` | Power out | 5 V | N/A | Optional indicator/buzzer supply provision | Current protection TBD | Use depends on final loads | Proposed |

## 11. J9 — Thrower Relay Contacts

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `RELAY_NC` | Passive contact | Isolated/TBD rating | Closed when de-energized | Normally closed contact | Contact protection external/TBD | No controller-sourced load power | Locked |
| 2 | `RELAY_COM` | Passive contact | Isolated/TBD rating | Common | Relay contact common | Contact protection external/TBD |  | Locked |
| 3 | `RELAY_NO` | Passive contact | Isolated/TBD rating | Open when de-energized | Normally open contact | Contact protection external/TBD | Fail-open trigger path | Locked |

## 12. J10 — I2C Expansion

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+3V3` | Power out | 3.3 V | N/A | Limited expansion supply | Current protection TBD | Reserve defined by power budget | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Expansion return | TBD |  | Locked |
| 3 | `I2C_SDA` | Bidirectional | 3.3 V logic | N/A | Shared I2C data | ESD/series resistor TBD | Bus length and pull-ups TBD | Locked |
| 4 | `I2C_SCL` | Output | 3.3 V logic | N/A | Shared I2C clock | ESD/series resistor TBD |  | Locked |

## 13. J11 — Spare GPIO Expansion

Final pin count and GPIO allocation are `TBD`.

| Pin | Signal name | Direction | Voltage domain | Active state | Description | Protection | Notes | Status |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `+3V3` | Power out | 3.3 V | N/A | Limited expansion supply | Current protection TBD | Optional pending budget | Proposed |
| 2 | `GND` | Power return | 0 V | N/A | Expansion return | TBD |  | Proposed |
| 3 | `SPARE_GPIO1` | Bidirectional | 3.3 V logic | TBD | Spare GPIO provision | ESD/series resistor TBD | Final capability TBD | TBD |
| 4 | `SPARE_GPIO2` | Bidirectional | 3.3 V logic | TBD | Spare GPIO provision | ESD/series resistor TBD | Final capability TBD | TBD |

## 14. J12 — Future Communications

J12 is an identifier reserved for future communications expansion; it is not a defined production connector. No pin count, pin numbering, connector family, transceiver population, termination, biasing, isolation, bus voltage, or protocol is approved.

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
| A4, A9, B4, B9 | `USB_VBUS` | Power in | 5 V nominal | N/A | USB host power detection/source | ESD, fuse/current limit, backfeed block TBD | Power interaction TBD | Locked |
| A1, A12, B1, B12 | `GND` | Power return | 0 V | N/A | USB return | TBD |  | Locked |
| A6, B6 | `USB_D+` | Bidirectional | USB 2.0 | Differential | USB data positive | Low-capacitance ESD TBD | Route as differential pair | Locked |
| A7, B7 | `USB_D-` | Bidirectional | USB 2.0 | Differential | USB data negative | Low-capacitance ESD TBD | Route as differential pair | Locked |
| A5 | `USB_CC1` | Bidirectional | USB Type-C CC | N/A | Configuration channel 1 | Resistor/ESD TBD | Device role TBD | TBD |
| B5 | `USB_CC2` | Bidirectional | USB Type-C CC | N/A | Configuration channel 2 | Resistor/ESD TBD | Device role TBD | TBD |
| Shield | `USB_SHIELD` | Chassis/shield | N/A | N/A | Cable shield | Chassis/ground coupling TBD | Mechanical tabs per receptacle | TBD |

## 16. Internal stable signals

`BATTERY_SENSE` is an internal protected analog signal derived from `VIN_RAW`; it is not exposed on an external connector. Relay-coil control, USB programming UART signals, and future transceiver-side logic signals are also internal and will be assigned in the GPIO map.

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
- [Wiring Standard](../requirements/Wiring_Standard.md)
- [Power Budget](../power/Power_Budget.md)
