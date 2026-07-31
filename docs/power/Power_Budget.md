# IPC-100 Power Budget

> **QER-01 control notice (2026-07-31):** [QER-01 Quantitative Electrical Requirements](../specifications/QER-01_Quantitative_Electrical_Requirements.md) now controls Rev A rail allocations, load limits, simultaneous-load constraints, transients, environment, and derating for component selection. This earlier architecture-stage budget remains useful history and a measurement worksheet; its `TBD` and preliminary values do not override QER-01.

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Power Budget |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-29 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Budget rules

The preliminary numeric capture basis is now maintained in [Critical Component Selection and Electrical Quantification](../hardware/Critical_Component_Selection_and_Electrical_Quantification.md). Its load table and calculations supersede `TBD` entries in this architecture-stage inventory only for preliminary schematic capture. This budget remains the verification ledger and shall be updated with exact selected-part maxima and prototype measurements before schematic release.

The preliminary Rev A target is an input power path capable of at least 2.0 A continuous controller-side current at the minimum normal input voltage of 9 V. This is not a final approved maximum, a measured load, or a regulator rating. Final approval requires verified peak loads, conversion efficiency, startup and simultaneous-load cases, temperature derating, thermal analysis, and expansion reserve. Motor operating current and external relay-contact load current are excluded.

`TBD` values require confirmation from selected-part datasheets or prototype measurement. No table total is valid until those values are resolved.

Required onboard loads, reference or optional platform loads, external interface loads, and uncommitted expansion reserves shall be tracked separately. An unused reserve is not guaranteed available to a product, and final rail allocation requires component, connector, protection, and thermal approval.

## 2. 3.3 V loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| ESP32-family module | 1 | TBD | TBD | Application-dependent | TBD | 3.3 V | Low | ESP32-S3-WROOM-1 is the preferred module family; exact variant TBD; include Wi-Fi/Bluetooth/ESP-NOW transmit peaks |
| I2C pull-up networks | TBD | TBD | TBD | Bus-dependent | TBD | 3.3 V | Low | Depends on resistor values and bus activity |
| Logic and input networks | 1 set | TBD | TBD | Continuous | TBD | 3.3 V | Low | Include expanders/level translation if selected |
| Status LEDs, if 3.3 V powered | TBD | TBD | TBD | TBD | TBD | 3.3 V | Low | Final topology TBD |
| Expansion allowance | 1 | TBD | TBD | TBD | TBD | 3.3 V | Low | Reserve must be approved |

## 3. 5 V loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| Relay coil | 1 | TBD | TBD | Intermittent | TBD | 5 V proposed | Low | Relay not selected |
| RGB LED/driver, if 5 V powered | 1 | TBD | TBD | Brightness and indication dependent | TBD | 5 V | Low | Topology, current, and brightness TBD |
| Buzzer/driver, if 5 V powered | 1 | TBD | TBD | Device type and duty-cycle dependent | TBD | 5 V | Low | Type, current, and duty cycle TBD |
| Axis 1 external-driver logic | 1 | TBD | TBD | Enabled as required | TBD | 5 V | Low | Logic only; not motor power |
| Axis 2 external-driver logic | 1 | TBD | TBD | Enabled as required | TBD | 5 V | Low | Logic only; not motor power |
| Status LEDs/power indicators | TBD | TBD | TBD | Continuous or controlled | TBD | 5 V | Low | Final indicators TBD |
| 3.3 V regulator input | 1 | Derived | Derived | Load-dependent | Derived | 5 V | Low | Include regulator efficiency |
| 5 V expansion allowance | 1 | TBD | TBD | TBD | TBD | 5 V | Low | Reserve must be approved |

## 4. Supply-domain TBD interface loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| Reference OLED module | 1 | TBD | 150 mA allocation | Active, dimmed, sleep, and startup conditions TBD | TBD | `OLED_VCC`, switched 3.3 V | Low | Domain approved by ADR-039; exact module and measured load remain open |
| Reference environmental sensor | 1 | TBD | 50 mA allocation | Measurement mode and duty-cycled behavior TBD | TBD | `SENSOR_VCC`, switched 3.3 V | Low | Domain approved by ADR-039; exact sensor and measured load remain open |
| J8 external control/indicator supply load | Product configuration dependent | TBD | TBD | Product configuration dependent | TBD | `+3V3` and/or `+5V` | Low | Both supplies are preliminary and limited |
| J10 controlled I2C expansion reserve | Optional | TBD | TBD | Attachment dependent | TBD | Proposed `+3V3` | Low | Not guaranteed; fault containment and connector approval required |
| J11 spare-interface expansion reserve | Optional | TBD | TBD | Attachment dependent | TBD | TBD | Low | Power provision and pin count are unresolved |
| Future communications reserve | Optional future | TBD | TBD | Implementation dependent | TBD | TBD | Low | No CAN or RS485 implementation is approved |
| Daughterboard reserve | Optional future | TBD | TBD | Module dependent | TBD | TBD | Low | No daughterboard power contract is approved |
| USB core-service condition | 1 | TBD | TBD | Main only, bounded USB-only service, or simultaneous | TBD | `USB_5V_PROTECTED` / `CORE_SOURCE` | Low | USB-only powers core/service only; source-selection losses and exact load unresolved |

## 5. Raw-input loads

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| Wide-input 5 V regulator input | 1 | Derived | Derived | Load-dependent | Derived | `VIN_RAW` | Low | Depends on rail load, input voltage, and efficiency |
| Battery-voltage divider | 1 | TBD | TBD | Continuous | TBD | `VIN_RAW` | Low | Divider values TBD |
| Input power indicator, if fitted | TBD | TBD | TBD | Continuous | TBD | `VIN_RAW` | Low | Optional |
| Protection-network leakage | 1 set | TBD | TBD | Continuous | TBD | `VIN_RAW` | Low | Depends on TVS and topology |
| Regulator conversion losses | 1 set | Derived | Derived | Load-dependent | Derived | `VIN_RAW` | Low | Include both conversion stages |

## 6. External loads not powered through IPC-100

| Load | Quantity | Typical current | Peak current | Duty cycle | Estimated average current | Rail | Confidence | Notes |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| High-current 20 V-to-12 V converter | Product-defined | TBD | TBD | Product-defined | TBD | Product high-current | Product-owned | Separately fused |
| External motor-driver power stages | Product-defined | TBD | TBD | Product-defined | TBD | Product high-current | Product-owned | Logic may be powered by IPC-100 only if budgeted |
| Motors | Product-defined | TBD | TBD | Product-defined | TBD | Product high-current | Product-owned | Explicitly excluded from IPC-100 budget |
| External load connected to relay | Product-defined | TBD | TBD | Product-defined | TBD | Product-defined | Product-owned | Excluded from IPC-100 budget; relay contacts do not source power |
| Product user-interface lighting | Product-defined | TBD | TBD | Product-defined | TBD | Product-defined | Product-owned | Excluded unless explicitly budgeted |

## 7. Design margin policy

### 7.1 Architecture confidence

| Budget aspect | Confidence | Basis |
| --- | --- | --- |
| Motors, power-stage drivers, and relay-contact loads excluded | High | Locked ownership boundary |
| Main/core/USB/peripheral domain partition | High | Power Architecture Engineering Review |
| USB-only scope | High | Core programming/recovery only; external/main loads remain off |
| Known required load inventory | Medium | Functional loads are enumerated; final devices/topologies are not selected |
| Numeric typical, peak, startup, and fault loads | Low | Datasheet and schematic inputs are not yet available |
| Expansion reserve | Low | No connector receives a guaranteed numeric reserve |
| Preliminary 2.0 A input-path target | Low as a capacity basis | Study target only; not derived from closed loads |

No numeric reserve is released. Unallocated capacity is design margin until a controlled connector/interface budget assigns it.

- Verify peak current for every populated load.
- Apply component and rail derating appropriate to temperature and production tolerance.
- Reserve capacity for startup, wireless transmission, relay actuation, buzzer use, and approved expansion.
- Do not use typical current alone to size regulators, conductors, connectors, or fuses.
- Final margin percentage is `TBD` pending component selection and thermal targets.

## 8. Peak versus average loading

Average current predicts energy use and steady thermal behavior. Peak current determines transient droop, regulator stability, conductor/connector stress, and brownout risk. Both must be modeled and measured.

ESP32 wireless transmit bursts require special attention because short peaks may not appear on slow meters. Measurement must use adequate bandwidth and a representative radio workload.

## 9. Simultaneous-load cases

At minimum, analyze:

- Wireless transmit plus OLED active
- Wireless transmit plus both external-driver logic interfaces enabled
- Relay coil plus buzzer plus maximum RGB indication
- Startup with the maximum planned simultaneous controller-side output load
- Relay and buzzer switching during wireless transmit
- Both external motor-driver logic loads plus relay, RGB, and buzzer at their maximum planned simultaneous states
- Maximum approved expansion load
- USB connected while main power is present
- External expansion powered before IPC-100 and IPC-100 powered before the external module
- Maximum approved expansion load and expansion-output fault containment

## 10. Expansion reserve

Separate 3.3 V, 5 V, J10, J11, future-communications, and daughterboard reserves are `TBD`. Connector documentation shall not advertise a current capability until rail allocation, connector, protection, fault containment, and thermal limits are verified. External field-bus power may require a product-level source.

## 11. Thermal estimate

| Condition | Input voltage | Load case | Ambient/enclosure | Estimated loss | Predicted temperature rise | Status |
| --- | --- | --- | --- | --- | --- | --- |
| Worst-case buck loss | TBD | TBD | TBD | TBD | TBD | Open |
| Worst-case 3.3 V regulator loss | TBD | TBD | TBD | TBD | TBD | Open |
| Relay/buzzer simultaneous | TBD | TBD | TBD | TBD | TBD | Open |

## 12. Prototype measurement plan

1. Instrument `VIN_RAW`, `+5V_MAIN`, `USB_5V_PROTECTED`, `CORE_SOURCE`, and `+3V3_CORE` with current and voltage logging.
2. Capture ESP32 wireless peaks with an oscilloscope or suitable current probe.
3. Measure rail droop during relay, buzzer, RGB, and interface switching.
4. Exercise the simultaneous-load cases in Section 9.
5. Measure regulator and protection-device temperatures at 9 V, nominal 12 V, and 21 V.
6. Repeat at the approved minimum and maximum ambient temperatures when defined.
7. Confirm USB/main-power interaction and backfeed behavior.
8. Update this budget with measured typical, peak, duty-cycle, and thermal results.

Budget confidence remains low until the relay, both external-driver logic interfaces, RGB topology, buzzer device, rail architecture, and simultaneous-output cases are approved and measured.

## 13. Related documents

- [Power Architecture](Power_Architecture.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
