# IPC-100 GPIO Map

Status: Placeholder — no ESP32 pins are assigned or approved.

## Assigned GPIO

| Function | ESP32 GPIO | Direction | Active level | Pull | Boot/strap concern | Interface/protection | Notes |
| --- | ---: | --- | --- | --- | --- | --- | --- |
| Isolated dry-contact relay control | TBD | Output | TBD | TBD | TBD | TBD | Safe default required |
| External motor-driver control 1 | TBD | Output | TBD | TBD | TBD | TBD | Low-current interface |
| External motor-driver control 2 | TBD | Output | TBD | TBD | TBD | TBD | Low-current interface |
| RGB LED red | TBD | Output | TBD | TBD | TBD | TBD |  |
| RGB LED green | TBD | Output | TBD | TBD | TBD | TBD |  |
| RGB LED blue | TBD | Output | TBD | TBD | TBD | TBD |  |
| Buzzer | TBD | Output | TBD | TBD | TBD | TBD | PWM capability TBD |
| Limit switch 1 | TBD | Input | TBD | TBD | TBD | TBD |  |
| Limit switch 2 | TBD | Input | TBD | TBD | TBD | TBD |  |
| Limit switch 3 | TBD | Input | TBD | TBD | TBD | TBD |  |
| Limit switch 4 | TBD | Input | TBD | TBD | TBD | TBD |  |
| Encoder A | TBD | Input | TBD | TBD | TBD | TBD |  |
| Encoder B | TBD | Input | TBD | TBD | TBD | TBD |  |
| Encoder push | TBD | Input | TBD | TBD | TBD | TBD |  |
| ARM button | TBD | Input | TBD | TBD | TBD | TBD |  |
| FIRE button | TBD | Input | TBD | TBD | TBD | TBD |  |
| STOP button | TBD | Input | TBD | TBD | TBD | TBD | Safe-state behavior required |
| Battery monitor ADC | TBD | Analog input | N/A | N/A | TBD | TBD | Divider/filter TBD |
| I²C SDA | TBD | Bidirectional | TBD | TBD | TBD | TBD | OLED/BME280/expansion |
| I²C SCL | TBD | Output | TBD | TBD | TBD | TBD | OLED/BME280/expansion |

## Reserved and spare GPIO

| ESP32 GPIO | Intended use | Restrictions | Connector | Status |
| ---: | --- | --- | --- | --- |
| TBD | Spare GPIO | Review boot, ADC, radio, and input-only constraints | TBD | Unassigned |

## Review checklist

- Confirm ESP32 boot-strapping behavior.
- Confirm input-only and ADC channel limitations.
- Confirm wireless coexistence limitations for ADC use.
- Define reset-time and firmware-fault safe states.
- Confirm every external GPIO has suitable protection.
- Cross-check connector specification and schematic net names.
