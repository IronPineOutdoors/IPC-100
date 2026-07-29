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

This is a resource-allocation worksheet, not a final pin assignment. No ESP32 GPIO number is approved. Candidate GPIO values remain `TBD` until the final ESP32-family module is approved and its pinout, boot behavior, memory needs, USB architecture, radio/ADC interaction, peripheral routing, and total GPIO demand are reviewed together. ESP32-WROOM-32E is the current reference candidate only.

Directions are relative to the ESP32. External voltage translation or driver stages may change the electrical direction at a connector.

## 2. Preliminary allocation table

| Function | Signal name | Candidate GPIO | Input/output | Boot-strap concern | ADC requirement | PWM requirement | Interrupt requirement | Pull-up/pull-down requirement | Boot-safe state | Notes | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Axis 1 PWM A | `AXIS1_RPWM` | TBD | Output | Review | No | Yes | No | Hardware pull to inactive TBD | Low/inactive | External driver logic | TBD |
| Axis 1 PWM B | `AXIS1_LPWM` | TBD | Output | Review | No | Yes | No | Hardware pull to inactive TBD | Low/inactive | External driver logic | TBD |
| Axis 1 enable A | `AXIS1_REN` | TBD | Output | Review | No | No | No | Hardware pull-down required | Low/disabled | Exact gating may change | TBD |
| Axis 1 enable B | `AXIS1_LEN` | TBD | Output | Review | No | No | No | Hardware pull-down required | Low/disabled | Exact gating may change | TBD |
| Axis 2 PWM A | `AXIS2_RPWM` | TBD | Output | Review | No | Yes | No | Hardware pull to inactive TBD | Low/inactive | External driver logic | TBD |
| Axis 2 PWM B | `AXIS2_LPWM` | TBD | Output | Review | No | Yes | No | Hardware pull to inactive TBD | Low/inactive | External driver logic | TBD |
| Axis 2 enable A | `AXIS2_REN` | TBD | Output | Review | No | No | No | Hardware pull-down required | Low/disabled | Exact gating may change | TBD |
| Axis 2 enable B | `AXIS2_LEN` | TBD | Output | Review | No | No | No | Hardware pull-down required | Low/disabled | Exact gating may change | TBD |
| Horizontal left limit | `LIMIT_LEFT` | TBD | Input | Avoid strap if possible | No | No | Yes preferred | External pull and filter required | Defined inactive | Field input protection required | TBD |
| Horizontal right limit | `LIMIT_RIGHT` | TBD | Input | Avoid strap if possible | No | No | Yes preferred | External pull and filter required | Defined inactive | Field input protection required | TBD |
| Vertical upper limit | `LIMIT_UP` | TBD | Input | Avoid strap if possible | No | No | Yes preferred | External pull and filter required | Defined inactive | Field input protection required | TBD |
| Vertical lower limit | `LIMIT_DOWN` | TBD | Input | Avoid strap if possible | No | No | Yes preferred | External pull and filter required | Defined inactive | Field input protection required | TBD |
| OLED reset | `OLED_RESET` | TBD | Output | Review | No | No | No | Pull for reset state TBD | Reset asserted or defined safe | Dedicated signal | TBD |
| I2C data | `I2C_SDA` | TBD | Bidirectional | Avoid strap if possible | No | No | No | Bus pull-up required; ownership TBD | High/open-drain | Shared OLED/BME280/expansion | TBD |
| I2C clock | `I2C_SCL` | TBD | Output/open-drain | Avoid strap if possible | No | No | No | Bus pull-up required; ownership TBD | High/open-drain | Shared OLED/BME280/expansion | TBD |
| Encoder phase A | `ENCODER_A` | TBD | Input | Avoid strap if possible | No | No | Yes | Pull/filter TBD | Defined inactive | Debounce in hardware/firmware TBD | TBD |
| Encoder phase B | `ENCODER_B` | TBD | Input | Avoid strap if possible | No | No | Yes | Pull/filter TBD | Defined inactive | Debounce in hardware/firmware TBD | TBD |
| Encoder push | `ENCODER_SW` | TBD | Input | Avoid strap if possible | No | No | Preferred | Pull/filter TBD | Defined inactive |  | TBD |
| ARM input | `ARM_IN` | TBD | Input | Avoid strap | No | No | Preferred | External pull/filter required | Disarmed | Dedicated physical input | TBD |
| FIRE input | `FIRE_IN` | TBD | Input | Avoid strap | No | No | Preferred | External pull/filter required | Inactive | Dedicated physical input | TBD |
| STOP input | `STOP_IN` | TBD | Input | Avoid strap | No | No | Yes | External pull/filter required | Stop/inactive convention TBD | Dedicated safety-relevant input | TBD |
| RGB red | `RGB_R` | TBD | Output | Review | No | Yes preferred | No | Pull to off TBD | Off | Driver topology TBD | TBD |
| RGB green | `RGB_G` | TBD | Output | Review | No | Yes preferred | No | Pull to off TBD | Off | Driver topology TBD | TBD |
| RGB blue | `RGB_B` | TBD | Output | Review | No | Yes preferred | No | Pull to off TBD | Off | Driver topology TBD | TBD |
| Buzzer control | `BUZZER_OUT` | TBD | Output | Review | No | Yes preferred | No | Pull to off required | Off | Buzzer/driver topology TBD | TBD |
| Battery monitor | `BATTERY_SENSE` | TBD | Input | Avoid strap | ADC1 required | No | No | Divider/filter TBD | N/A | Do not use ADC2 because Wi-Fi is required | TBD |
| Relay coil control | `RELAY_CTRL` | TBD | Output | Review | No | No | No | Pull to off required | Off; contacts de-energized | `RELAY_NO` must remain open | TBD |
| Spare expansion 1 | `SPARE_GPIO1` | TBD | Bidirectional | Review | TBD | TBD | TBD | TBD | High impedance | Capability depends on assigned pin | TBD |
| Spare expansion 2 | `SPARE_GPIO2` | TBD | Bidirectional | Review | TBD | TBD | TBD | TBD | High impedance | Capability depends on assigned pin | TBD |
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

The following stable connector signals do not directly consume ESP32 GPIO: `VIN_RAW`, `GND`, `+5V`, `+3V3`, `OLED_VCC`, `RELAY_NC`, `RELAY_COM`, `RELAY_NO`, `CAN_H`, `CAN_L`, `RS485_A`, `RS485_B`, `USB_VBUS`, `USB_D+`, `USB_D-`, `USB_CC1`, `USB_CC2`, and `USB_SHIELD`.

## 4. ESP32 allocation constraints

### 4.1 Boot-strapping pins

Strapping pins are sampled during reset and can prevent boot or change boot mode. External circuits on those pins must not override the required reset state. Safety-related outputs should avoid strap pins where practical.

### 4.2 Flash-connected pins

Pins used internally for module flash are unavailable for general IPC-100 signals. The final review must use the approved module documentation, not only a bare ESP32 chip pinout or the current reference candidate.

### 4.3 Input-only pins

Input-only GPIO may be candidates for limits, controls, or `BATTERY_SENSE`, subject to pull-up availability and board routing. They cannot drive outputs.

### 4.4 ADC and Wi-Fi

ADC2 resources can be unavailable or constrained while Wi-Fi is active. Because Wi-Fi is locked, `BATTERY_SENSE` requires a verified ADC1-capable pin.

### 4.5 PWM

ESP32 LEDC PWM channels are flexible but finite. Axis PWM, RGB dimming, and buzzer tone requirements must be counted together and verified against the selected ESP32 variant and base-firmware architecture.

### 4.6 Interrupts

Planned digital inputs should use interrupt-capable GPIO where needed. Interrupt assignment does not eliminate hardware filtering, debounce, or safe-state requirements.

### 4.7 USB and UART

J13 is the external USB-C service interface. Native USB versus an external USB-to-UART implementation, automatic boot/reset circuitry, and consumed GPIO remain `TBD` until processor and schematic approval.

### 4.8 I2C flexibility

ESP32 I2C signals can be routed through the GPIO matrix, but candidate pins must still satisfy boot, loading, signal-integrity, and connector-routing constraints.

### 4.9 Safe default outputs

Motor enables, motor PWM, relay control, RGB channels, and buzzer control require hardware-defined safe states before firmware configures GPIO. Firmware initialization is not the only safe-state mechanism.

## 5. Resource-risk note

The preliminary feature set may demand more independent GPIO than the selected module can provide after unavailable, flash-connected, boot-strapping, input-only, programming, ADC1, and future-expansion constraints are considered. GPIO expanders, shared enables, multiplexing, or unpopulated future provisions may be required. No such approach is approved yet.

## 6. Allocation checklist before Sheet 02

- [ ] Confirm exact ESP32 module variant and module pinout.
- [ ] Exclude flash-connected and unavailable module pins.
- [ ] Record every strap pin and required reset level.
- [ ] Reserve ADC1 for `BATTERY_SENSE`.
- [ ] Reserve programming UART, boot, and reset resources.
- [ ] Count LEDC PWM channels and timing constraints.
- [ ] Confirm interrupt capability for limits and controls.
- [ ] Define external pulls and reset-time states for every output.
- [ ] Confirm `STOP_IN` has a dedicated, noise-protected input.
- [ ] Decide whether motor enables are independent, shared, or hardware-gated.
- [ ] Decide whether CAN and RS485 logic is populated or provision-only.
- [ ] Resolve total GPIO demand and any expander/multiplexer need.
- [ ] Cross-check every signal against J1–J13.
- [ ] Review radio, ADC, UART, I2C, and boot interactions.
- [ ] Record and approve final GPIO numbers before Sheet 02 is wired.

## 7. Related documents

- [Connector Specification](Connector_Specification.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [System Architecture](../architecture/System_Architecture.md)
