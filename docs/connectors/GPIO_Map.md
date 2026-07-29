# IPC-100 GPIO Map

| Document control | Value |
| --- | --- |
| Document title | IPC-100 GPIO Map |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Allocation status

This is a resource-allocation worksheet, not a final pin assignment. No ESP32 GPIO number is approved. Candidate GPIO values remain `TBD` until the preferred ESP32-S3-WROOM-1 module family is reduced to an approved ordering variant and its pinout, boot behavior, memory needs, native USB architecture, radio/ADC interaction, peripheral routing, and total GPIO demand are reviewed together.

Directions are relative to the ESP32. External voltage translation or driver stages may change the electrical direction at a connector.

## 1.1 Resource-allocation summary

| Resource class | Direct-GPIO scenario | Potential reduced scenario | Notes |
| --- | ---: | ---: | --- |
| Independent digital inputs | 10 | 7 direct | Encoder inputs could move to non-safety external I/O; STOP and limits remain direct/high priority |
| Independent digital outputs | 14 | 7 direct | Illustrative external control for enables, RGB, buzzer, and OLED reset; not approved |
| Required/preferred PWM outputs | 4 required; 4 additional preferred/TBD | At least 4 direct | Motor PWM is required by the reference contract; RGB/buzzer depend on architecture |
| ADC inputs | 1 | 0 or 1 direct | `BATTERY_SENSE` may use an approved external ADC path |
| Interrupt-preferred inputs | 10 preferred | At least 5 high-priority | Exact interrupt requirements remain TBD |
| Required communications | Shared I2C plus Wi-Fi/Bluetooth/ESP-NOW and USB-C service | Same logical capabilities | Native ESP32-S3 USB Serial/JTAG preferred; implementation unresolved |
| Optional communications | Future CAN and RS485 | Future only | Resources not reserved until required allocation is proven |
| Required boot-safe outputs | 14 | 7 direct plus externally controlled outputs | Every logical output still requires a defined hardware-safe state |
| High-priority safety inputs | 5 | 5 | `STOP_IN` and four directional limits |
| Proposed expansion signals | 2 concepts plus possible controls | TBD | No capability or MCU-pin commitment |

The direct scenario is approximately 29 MCU signal resources when 10 digital inputs, 14 digital outputs, two I2C signals, one ADC input, and two service signals are counted. Boot/reset/module-management resources and optional identification or I2C-segmentation controls are additional or module-specific. An illustrative external-interface scenario could reduce the direct count to approximately 19, but no reduction architecture is approved.

**Feasibility status: Not demonstrated.** Final feasibility cannot be proven until a candidate ESP32 module, USB architecture, ADC path, boot/programming scheme, and any required resource-reduction architecture are selected and checked against exact module restrictions.

## 2. Preliminary allocation table

| Function | Signal name | Candidate GPIO | Input/output | Boot-strap concern | ADC requirement | PWM requirement | Interrupt requirement | Pull-up/pull-down requirement | Boot-safe state | Notes | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Axis 1 PWM A | `AXIS1_RPWM` | TBD | Output | Avoid unresolved strap conflicts | No | Yes | No | Hardware inactive/master inhibit required | Inactive; polarity TBD | Mutually exclusive with LPWM; master inhibit overrides | TBD |
| Axis 1 PWM B | `AXIS1_LPWM` | TBD | Output | Avoid unresolved strap conflicts | No | Yes | No | Hardware inactive/master inhibit required | Inactive; polarity TBD | Mutually exclusive with RPWM; master inhibit overrides | TBD |
| Axis 1 enable A | `AXIS1_REN` | TBD | Output | Avoid unresolved strap conflicts | No | No | No | Hardware disabled/master inhibit required | Disabled; polarity TBD | Logical independence retained; implementation may gate | TBD |
| Axis 1 enable B | `AXIS1_LEN` | TBD | Output | Avoid unresolved strap conflicts | No | No | No | Hardware disabled/master inhibit required | Disabled; polarity TBD | Logical independence retained; implementation may gate | TBD |
| Axis 2 PWM A | `AXIS2_RPWM` | TBD | Output | Avoid unresolved strap conflicts | No | Yes | No | Hardware inactive/master inhibit required | Inactive; polarity TBD | Mutually exclusive with LPWM; master inhibit overrides | TBD |
| Axis 2 PWM B | `AXIS2_LPWM` | TBD | Output | Avoid unresolved strap conflicts | No | Yes | No | Hardware inactive/master inhibit required | Inactive; polarity TBD | Mutually exclusive with RPWM; master inhibit overrides | TBD |
| Axis 2 enable A | `AXIS2_REN` | TBD | Output | Avoid unresolved strap conflicts | No | No | No | Hardware disabled/master inhibit required | Disabled; polarity TBD | Logical independence retained; implementation may gate | TBD |
| Axis 2 enable B | `AXIS2_LEN` | TBD | Output | Avoid unresolved strap conflicts | No | No | No | Hardware disabled/master inhibit required | Disabled; polarity TBD | Logical independence retained; implementation may gate | TBD |
| Left-direction limit | `LIMIT_LEFT` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Unknown/asserted/faulted inhibits leftward motion | Conditioned output of dedicated supervised NC loop; diagnostic resource impact TBD | TBD |
| Right-direction limit | `LIMIT_RIGHT` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Unknown/asserted/faulted inhibits rightward motion | Conditioned output of dedicated supervised NC loop; diagnostic resource impact TBD | TBD |
| Up-direction limit | `LIMIT_UP` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Unknown/asserted/faulted inhibits upward motion | Conditioned output of dedicated supervised NC loop; diagnostic resource impact TBD | TBD |
| Down-direction limit | `LIMIT_DOWN` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Unknown/asserted/faulted inhibits downward motion | Conditioned output of dedicated supervised NC loop; diagnostic resource impact TBD | TBD |
| OLED reset | `OLED_RESET` | TBD | Output | Review | No | No | No | Hardware reset-asserted/non-driving default required | Reset asserted until `OLED_VCC` valid | Optional display only; no unpowered backfeed | TBD |
| I2C data | `I2C_SDA` | TBD | Bidirectional | Avoid strap if possible | No | No | No | Bus pull-up required; ownership TBD | High/open-drain | Shared OLED/BME280/expansion | TBD |
| I2C clock | `I2C_SCL` | TBD | Output/open-drain | Avoid strap if possible | No | No | No | Bus pull-up required; ownership TBD | High/open-drain | Shared OLED/BME280/expansion | TBD |
| Encoder phase A | `ENCODER_A` | TBD | Input | Avoid strap if possible | No | No | Preferred where useful | Pull direction/filter TBD | Defined state TBD | Lower allocation priority than STOP and limits; debounce TBD | TBD |
| Encoder phase B | `ENCODER_B` | TBD | Input | Avoid strap if possible | No | No | Preferred where useful | Pull direction/filter TBD | Defined state TBD | Lower allocation priority than STOP and limits; debounce TBD | TBD |
| Encoder push | `ENCODER_SW` | TBD | Input | Avoid strap if possible | No | No | Preferred | Processor-side bias/filter TBD | Inactive/no event | Momentary NO, non-safety UI input | TBD |
| ARM input | `ARM_IN` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Inactive; held state invalid | Momentary NO command; protected interface required | TBD |
| FIRE input | `FIRE_IN` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Inactive; held state invalid | Momentary NO request; qualified edge after ARM required | TBD |
| STOP input | `STOP_IN` | TBD | Input | Avoid unresolved strap conflicts | No | No | Preferred where useful | Processor-side bias/filter TBD | Unknown/asserted/faulted means STOP | Highest priority; conditioned supervised NC loop plus hardware inhibit path; resource impact TBD | TBD |
| RGB red | `RGB_R` | TBD | Output | Avoid unresolved strap conflicts | No | Preferred | No | Hardware pull to inactive required; direction TBD | Inactive; polarity TBD | PWM optional pending brightness requirements; driver topology TBD | TBD |
| RGB green | `RGB_G` | TBD | Output | Avoid unresolved strap conflicts | No | Preferred | No | Hardware pull to inactive required; direction TBD | Inactive; polarity TBD | PWM optional pending brightness requirements; driver topology TBD | TBD |
| RGB blue | `RGB_B` | TBD | Output | Avoid unresolved strap conflicts | No | Preferred | No | Hardware pull to inactive required; direction TBD | Inactive; polarity TBD | PWM optional pending brightness requirements; driver topology TBD | TBD |
| Buzzer control | `BUZZER_OUT` | TBD | Output | Avoid unresolved strap conflicts | No | Preferred for passive device | No | Hardware pull to inactive required; direction TBD | Inactive; polarity TBD | PWM need depends on buzzer type; driver topology TBD | TBD |
| Battery monitor | `BATTERY_SENSE` | TBD | Input | Avoid strap | ADC1-capable input or equivalent approved ADC path | No | No | Divider/filter TBD | N/A | Do not assume ADC2 availability during Wi-Fi operation | TBD |
| Relay coil control | `RELAY_CTRL` | TBD | Output | Avoid unresolved strap conflicts | No | No | No | Hardware pull to de-energized required; direction TBD | Coil de-energized; polarity TBD | Highest output safety priority; `RELAY_NO` open | TBD |
| Spare expansion 1 | `SPARE_GPIO1` | TBD | TBD | Avoid unresolved strap conflicts | TBD | TBD | TBD | TBD | Non-driving or approved inactive | Direction and capability depend on approved allocation and interface circuitry | TBD |
| Spare expansion 2 | `SPARE_GPIO2` | TBD | TBD | Avoid unresolved strap conflicts | TBD | TBD | TBD | TBD | Non-driving or approved inactive | Direction and capability depend on approved allocation and interface circuitry | TBD |
| Future CAN transmit | `CAN_TX` | TBD | Output | Review | No | No | No | Defined recessive state TBD | Inactive | Internal transceiver-side provision | TBD |
| Future CAN receive | `CAN_RX` | TBD | Input | Avoid strap | No | No | Yes preferred | TBD | Defined | Internal transceiver-side provision | TBD |
| Future RS485 transmit | `RS485_TX` | TBD | Output | Review | No | No | No | TBD | Inactive | May share UART after review | TBD |
| Future RS485 receive | `RS485_RX` | TBD | Input | Avoid strap | No | No | Preferred | TBD | Defined | May share UART after review | TBD |
| Future RS485 driver enable | `RS485_DE` | TBD | Output | Review | No | No | No | Pull to receive/disabled | Driver disabled | Exact transceiver topology TBD | TBD |
| Programming UART transmit | `UART0_TX` | TBD | Output | Verify module default | No | No | No | Per ESP32 reference design | Defined by boot ROM | USB bridge implementation TBD | TBD |
| Programming UART receive | `UART0_RX` | TBD | Input | Verify module default | No | No | No | Per ESP32 reference design | Defined by boot ROM | USB bridge implementation TBD | TBD |
| Boot mode | `ESP_BOOT` | TBD | Input | Yes | No | No | No | Required boot pull | Normal boot | Programming circuit TBD | TBD |
| Reset | `ESP_EN` | TBD | Input | Reset function | No | No | No | Required enable pull | Reset sequence defined | Programming circuit TBD | TBD |

## 3. Non-GPIO connector signals

The following stable connector signals do not directly consume ESP32 GPIO: `VIN_RAW`, `GND`, `+5V`, `+3V3`, `OLED_VCC`, `SENSOR_VCC`, `LIMIT_LEFT_RETURN`, `LIMIT_RIGHT_RETURN`, `LIMIT_UP_RETURN`, `LIMIT_DOWN_RETURN`, `STOP_RETURN`, `RELAY_NC`, `RELAY_COM`, `RELAY_NO`, `CAN_H`, `CAN_L`, `RS485_A`, `RS485_B`, `USB_VBUS`, `USB_D+`, `USB_D-`, `USB_CC1`, `USB_CC2`, and `USB_SHIELD`.

## 4. ESP32 allocation constraints

### 4.1 Boot-strapping pins

Strapping pins are sampled during reset and can prevent boot or change boot mode. External circuits on those pins must not override the required reset state. Safety-related outputs should avoid strap pins where practical.

### 4.2 Flash-connected pins

Pins used internally for module flash or PSRAM are unavailable for general IPC-100 signals. The final review must use the exact approved module-variant documentation, not only a bare ESP32-S3 chip pinout or a module-family maximum.

### 4.3 Input-only pins

Input-only GPIO may be candidates for limits, controls, or `BATTERY_SENSE`, subject to pull-up availability and board routing. They cannot drive outputs.

### 4.4 ADC and Wi-Fi

ADC2 resources can be unavailable or constrained while Wi-Fi is active. Because Wi-Fi is locked, `BATTERY_SENSE` requires a verified ADC1-capable input or an equivalent approved ADC path. No ADC channel is assigned.

### 4.5 PWM

ESP32 LEDC PWM channels are flexible but finite. Axis PWM, RGB dimming, and buzzer tone requirements must be counted together and verified against the selected ESP32 variant and base-firmware architecture.

### 4.6 Interrupts

Planned digital inputs should use interrupt-capable GPIO where needed. Interrupt assignment does not eliminate hardware filtering, debounce, or safe-state requirements.

Input allocation priority is `STOP_IN` first, then the four motion-limit inputs, then the remaining dedicated controls and encoder inputs. External inputs require approved interface circuitry and shall not be assumed to tolerate field voltages directly. Allocation must account for reset and boot behavior, unavailable and flash-connected pins, input-only limitations, ADC constraints, programming interfaces, and hardware-safe startup.

### 4.7 USB and UART

J13 is the external USB-C service interface. Native ESP32-S3 USB Serial/JTAG is preferred over an on-board USB-to-UART bridge. Automatic boot/reset circuitry, recovery/test UART access, USB-C implementation, and consumed GPIO remain `TBD` until schematic approval.

### 4.8 I2C flexibility

ESP32 I2C signals can be routed through the GPIO matrix, but candidate pins must still satisfy boot, loading, signal-integrity, and connector-routing constraints.

`I2C_SDA` and `I2C_SCL` are shared by the reference OLED, reference environmental sensor, and optional expansion interface. Allocation review must include attached-device startup behavior, address compatibility, bus loading, pull-up ownership, supply domains, cable assumptions, and recovery behavior. I2C initialization must occur without delaying hardware-safe output establishment.

### 4.9 Safe default outputs

Motor enables, motor PWM, relay control, RGB channels, and buzzer control require hardware-defined safe states before firmware configures GPIO. Firmware initialization is not the only safe-state mechanism.

Relay control and motor enables receive the highest output-allocation safety priority, followed by motor PWM signals. Candidate pins and external circuitry shall be reviewed across reset, normal boot, programming mode, brownout, watchdog recovery, and uncontrolled rail decay. No processor internal pull or boot behavior may make an output active. Product code shall use stable logical signal names and shall not assume GPIO numbers or active polarity.

## 5. Resource-risk note

The preliminary feature set may demand more independent GPIO than the selected module can provide after unavailable, flash-connected, boot-strapping, input-only, programming, ADC1, and future-expansion constraints are considered. GPIO expanders, shared enables, multiplexing, or unpopulated future provisions may be required. No such approach is approved yet.

### 5.1 Proposed allocation priority

1. Hardware-safe and safety-relevant inputs and outputs
2. Required power and board-management functions
3. Required service and programming interface
4. Required onboard peripherals
5. Required product-neutral user interfaces
6. Optional expansion
7. Future CAN and RS485 provisions

This priority is proposed pending final processor and schematic review. Expansion shall not consume resources until required functions, USB architecture, boot-strapping constraints, unavailable and flash-connected pins, ADC needs, PWM needs, interrupt needs, and hardware-safe startup are resolved. Processor-native peripheral routing remains `TBD`. CAN and RS485 provisions may be reduced or omitted if resources are insufficient.

## 6. Allocation checklist before Sheet 02

- [ ] Confirm exact ESP32 module variant and module pinout.
- [ ] Exclude flash-connected and unavailable module pins.
- [ ] Record every strap pin and required reset level.
- [ ] Reserve an ADC1-capable input or approve an equivalent ADC path for `BATTERY_SENSE`.
- [ ] Reserve programming UART, boot, and reset resources.
- [ ] Count LEDC PWM channels and timing constraints.
- [ ] Confirm interrupt capability for limits and controls.
- [ ] Allocate `STOP_IN` first, then motion limits, without unresolved boot-strapping conflicts.
- [ ] Verify that external inputs use approved field-interface circuitry rather than direct field-voltage connection.
- [ ] Define active state, pull direction, disconnected-input behavior, and reset state for every input.
- [ ] Define external pulls and reset-time states for every output.
- [ ] Allocate relay control and motor enables before lower-priority indicator outputs.
- [ ] Verify inactive output states during reset, normal boot, programming mode, brownout, and rail decay.
- [ ] Confirm no internal pull or boot condition can assert relay, motor, RGB, or buzzer outputs.
- [ ] Confirm `STOP_IN` has a dedicated, noise-protected input.
- [ ] Decide whether motor enables are independent, shared, or hardware-gated.
- [ ] Decide whether CAN and RS485 logic is populated or provision-only.
- [ ] Confirm optional expansion remains below every required function in allocation priority.
- [ ] Define each spare signal's actual digital, analog, PWM, interrupt, open-drain, and drive capability.
- [ ] Resolve total GPIO demand and any expander/multiplexer need.
- [ ] Cross-check every signal against J1–J13.
- [ ] Review radio, ADC, UART, I2C, and boot interactions.
- [ ] Verify shared-I2C address, loading, pull-up, supply-domain, cable, startup, fault, and recovery assumptions.
- [ ] Record and approve final GPIO numbers before Sheet 02 is wired.

## 7. Related documents

- [Connector Specification](Connector_Specification.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [System Architecture](../architecture/System_Architecture.md)
- [Processor Resource Feasibility](../architecture/Processor_Resource_Feasibility.md)
