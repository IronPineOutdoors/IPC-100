# IPC-100 Power Budget

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Power Budget |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Budget rules

IPC-100 has an approximately 2 A maximum input-current capability design target. This is not a measured load or a final regulator rating. Final rail sizing shall use verified peak loads, conversion efficiency, simultaneous-load cases, temperature derating, and expansion reserve. Motors are excluded.

`TBD` values require confirmation from selected-part datasheets or prototype measurement. No table total is valid until those values are resolved.

## 2. 3.3 V loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| ESP32-WROOM-32E or compatible | 1 | TBD | TBD | Application-dependent | TBD | 3.3 V | Medium | Include Wi-Fi/Bluetooth/ESP-NOW transmit peaks |
| BME280 interface/module | 1 | TBD | TBD | TBD | TBD | 3.3 V | Low | Verify selected module and operating mode |
| I2C pull-up networks | TBD | TBD | TBD | Bus-dependent | TBD | 3.3 V | Low | Depends on resistor values and bus activity |
| Logic and input networks | 1 set | TBD | TBD | Continuous | TBD | 3.3 V | Low | Include expanders/level translation if selected |
| Status LEDs, if 3.3 V powered | TBD | TBD | TBD | TBD | TBD | 3.3 V | Low | Final topology TBD |
| Expansion allowance | 1 | TBD | TBD | TBD | TBD | 3.3 V | Low | Reserve must be approved |

## 3. 5 V loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| OLED module | 1 | TBD | TBD | Display-dependent | TBD | 5 V or TBD | Low | `OLED_VCC` awaits module verification |
| Relay coil | 1 | TBD | TBD | Intermittent | TBD | 5 V proposed | Low | Relay not selected |
| RGB LED/driver, if 5 V powered | 1 | TBD | TBD | Indication-dependent | TBD | 5 V | Low | Topology TBD |
| Buzzer/driver, if 5 V powered | 1 | TBD | TBD | Intermittent | TBD | 5 V | Low | Type and tone duty TBD |
| Axis 1 external-driver logic | 1 | TBD | TBD | Enabled as required | TBD | 5 V | Low | Logic only; not motor power |
| Axis 2 external-driver logic | 1 | TBD | TBD | Enabled as required | TBD | 5 V | Low | Logic only; not motor power |
| Status LEDs/power indicators | TBD | TBD | TBD | Continuous or controlled | TBD | 5 V | Low | Final indicators TBD |
| 3.3 V regulator input | 1 | Derived | Derived | Load-dependent | Derived | 5 V | Low | Include regulator efficiency |
| 5 V expansion allowance | 1 | TBD | TBD | TBD | TBD | 5 V | Low | Reserve must be approved |

## 4. Raw-input loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| Wide-input 5 V regulator input | 1 | Derived | Derived | Load-dependent | Derived | `VIN_RAW` | Low | Depends on rail load, input voltage, and efficiency |
| Battery-voltage divider | 1 | TBD | TBD | Continuous | TBD | `VIN_RAW` | Low | Divider values TBD |
| Input power indicator, if fitted | TBD | TBD | TBD | Continuous | TBD | `VIN_RAW` | Low | Optional |
| Protection-network leakage | 1 set | TBD | TBD | Continuous | TBD | `VIN_RAW` | Low | Depends on TVS and topology |
| Regulator conversion losses | 1 set | Derived | Derived | Load-dependent | Derived | `VIN_RAW` | Low | Include both conversion stages |

## 5. External loads not powered through IPC-100

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| High-current 20 V-to-12 V converter | Product-defined | TBD | TBD | Product-defined | TBD | Product high-current | Product-owned | Separately fused |
| External motor-driver power stages | Product-defined | TBD | TBD | Product-defined | TBD | Product high-current | Product-owned | Logic may be powered by IPC-100 only if budgeted |
| Motors | Product-defined | TBD | TBD | Product-defined | TBD | Product high-current | Product-owned | Explicitly excluded from IPC-100 budget |
| Thrower/load connected to relay | Product-defined | TBD | TBD | Product-defined | TBD | Product-defined | Product-owned | Relay contacts do not source power |
| Product user-interface lighting | Product-defined | TBD | TBD | Product-defined | TBD | Product-defined | Product-owned unless explicitly budgeted |

## 6. Design margin policy

- Verify peak current for every populated load.
- Apply component and rail derating appropriate to temperature and production tolerance.
- Reserve capacity for startup, wireless transmission, relay actuation, buzzer use, and approved expansion.
- Do not use typical current alone to size regulators, conductors, connectors, or fuses.
- Final margin percentage is `TBD` pending component selection and thermal targets.

## 7. Peak versus average loading

Average current predicts energy use and steady thermal behavior. Peak current determines transient droop, regulator stability, conductor/connector stress, and brownout risk. Both must be modeled and measured.

ESP32 wireless transmit bursts require special attention because short peaks may not appear on slow meters. Measurement must use adequate bandwidth and a representative radio workload.

## 8. Simultaneous-load cases

At minimum, analyze:

- Wireless transmit plus OLED active
- Wireless transmit plus both external-driver logic interfaces enabled
- Relay coil plus buzzer plus maximum RGB indication
- Relay and buzzer switching during wireless transmit
- Maximum approved expansion load
- USB connected while main power is present

## 9. Expansion reserve

Separate 3.3 V and 5 V reserves are `TBD`. Connector documentation shall not advertise a current capability until the rail, connector, protection, and thermal limits are verified.

## 10. Thermal estimate

| Condition | Input voltage | Load case | Ambient/enclosure | Estimated loss | Predicted temperature rise | Status |
| --- | --- | --- | --- | --- | --- | --- |
| Worst-case buck loss | TBD | TBD | TBD | TBD | TBD | Open |
| Worst-case 3.3 V regulator loss | TBD | TBD | TBD | TBD | TBD | Open |
| Relay/buzzer simultaneous | TBD | TBD | TBD | TBD | TBD | Open |

## 11. Prototype measurement plan

1. Instrument `VIN_RAW`, `+5V`, and `+3V3` with current and voltage logging.
2. Capture ESP32 wireless peaks with an oscilloscope or suitable current probe.
3. Measure rail droop during relay, buzzer, RGB, and interface switching.
4. Exercise the simultaneous-load cases in Section 8.
5. Measure regulator and protection-device temperatures at 9 V, nominal 12 V, and 21 V.
6. Repeat at the approved minimum and maximum ambient temperatures when defined.
7. Confirm USB/main-power interaction and backfeed behavior.
8. Update this budget with measured typical, peak, duty-cycle, and thermal results.

## 12. Related documents

- [Power Architecture](Power_Architecture.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
