# IPC-100 Rev A Proposed GPIO Map

> **ADR-040/ADR-044 amendment:** The authoritative Rev A preliminary-capture allocation is [ESP32 GPIO Allocation Table](ESP32_GPIO_Allocation_Table.md). GPIO35/36/40/41 produce the four ADR-039 power requests; GPIO42 produces `WATCHDOG_SERVICE_MCU`; GPIO37 is the sole future reserve; five low-risk UI functions remain behind the Sheet 07 I²C boundary.

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Processor basis | ESP32-S3-WROOM-1 module family |
| Status | Allocation Review Complete; Release Blocked |
| Last updated | 2026-07-29 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Authority and release status

This is the controlled proposed Rev A allocation. The complete evidence, restrictions, risk review, and peripheral analysis are in the [GPIO and Peripheral Allocation Review](GPIO_and_Peripheral_Allocation_Review.md).

All 27 required non-USB application signals have proposed GPIOs. GPIO19/20 remain fixed for native USB. ESP32-S3-WROOM-1-N8 is selected for preliminary capture and is compatible with the GPIO35/36 and GPIO47/48 assumptions. Release remains blocked by memory/RF/mechanical/procurement verification, framework-level validation, and implementation review.

## 2. Proposed assignments

| Logical signal | GPIO | Peripheral/capability | Connector | Release note |
| --- | ---: | --- | --- | --- |
| `BATTERY_SENSE` | 1 | ADC1_CH0 | Internal/J1-derived | Analog contract TBD |
| `STOP_IN` | 2 | GPIO interrupt | J8 / partition TBD | Conditioned supervised input |
| `LIMIT_LEFT` | 4 | GPIO interrupt | J4 | Conditioned supervised input |
| `LIMIT_RIGHT` | 5 | GPIO interrupt | J4 | Conditioned supervised input |
| `LIMIT_UP` | 6 | GPIO interrupt | J5 | Conditioned supervised input |
| `LIMIT_DOWN` | 7 | GPIO interrupt | J5 | Conditioned supervised input |
| `ARM_IN` | 8 | GPIO interrupt preferred | J8 | Conditioned input |
| `FIRE_IN` | 9 | GPIO interrupt preferred | J8 | Conditioned input |
| `ENCODER_A` | 10 | PCNT0/GPIO interrupt candidate | J8 | Non-safety UI |
| `ENCODER_B` | 11 | PCNT0/GPIO interrupt candidate | J8 | Non-safety UI |
| `ENCODER_SW` | 12 | GPIO interrupt preferred | J8 | Non-safety UI |
| `AXIS1_RPWM` | 13 | MCPWM0 OP0A | J2 | Hardware-inhibited |
| `AXIS1_LPWM` | 14 | MCPWM0 OP0B | J2 | Hardware-inhibited |
| `AXIS2_RPWM` | 15 | MCPWM0 OP1A | J3 | Hardware-inhibited |
| `AXIS2_LPWM` | 16 | MCPWM0 OP1B | J3 | Hardware-inhibited |
| `AXIS1_REN` | 17 | GPIO output | J2 | Hardware-inhibited/disabled default |
| `AXIS1_LEN` | 18 | GPIO output | J2 | Hardware-inhibited/disabled default |
| `USB_D-` | 19 | Native USB Serial/JTAG | J13 | Fixed/reserved |
| `USB_D+` | 20 | Native USB Serial/JTAG | J13 | Fixed/reserved |
| `AXIS2_REN` | 21 | GPIO output | J3 | Hardware-inhibited/disabled default |
| `RGB_B` | 35 | GPIO/LEDC candidate | J8 | Requires compatible non-octal-PSRAM variant |
| `BUZZER_OUT` | 36 | GPIO/LEDC candidate | J8 | Requires compatible non-octal-PSRAM variant |
| `AXIS2_LEN` | 38 | GPIO output | J3 | Hardware-inhibited/disabled default |
| `RELAY_CTRL` | 39 | GPIO output | Internal/J9 contacts | Hardware-inhibited/de-energized default |
| `RGB_R` | 40 | GPIO/LEDC candidate | J8 | Main-only/off default |
| `RGB_G` | 41 | GPIO/LEDC candidate | J8 | Main-only/off default |
| `OLED_RESET` | 42 | GPIO output | J6 | Asserted/non-driving until display power valid |
| `I2C_SDA` | 47 | I2C0 SDA | J6/J7/J10 | Variant voltage compatibility required |
| `I2C_SCL` | 48 | I2C0 SCL | J6/J7/J10 | Variant voltage compatibility required |

## 3. Reserved, conditional, and avoided resources

| Resource | Disposition | Reason |
| --- | --- | --- |
| EN | Reserved management | Reset/recovery |
| GPIO0 | Reserved management | Manual download boot |
| GPIO43/44 | Reserved physical UART0 TX/RX | Recovery and production test |
| GPIO37 | Conditional reserve only | Unavailable with octal PSRAM |
| GPIO3/45/46 | Avoided | Strapping pins |
| GPIO19/20 | Prohibited for application GPIO | Native USB |
| GPIO26–34 | Unavailable | Not brought out as user GPIO on WROOM-1 |
| `SPARE_GPIO1/2` | Unresolved | Direct plan cannot guarantee two clean physical spares |
| CAN/TWAI | Peripheral capacity only | No physical GPIO pair reserved |
| RS485 | Peripheral capacity only | No TX/RX/direction GPIO set reserved |

## 4. Peripheral allocation summary

| Function | Proposed resource |
| --- | --- |
| Four motor PWM commands | MCPWM0 operators 0 and 1, generators A/B |
| Four motor enables | Independent GPIO outputs |
| RGB/buzzer optional modulation | LEDC channels as required |
| STOP/limits/ARM/FIRE | GPIO interrupts |
| Encoder | PCNT0 candidate; GPIO interrupt fallback |
| Battery monitor | ADC1_CH0 |
| Shared I2C | I2C0 |
| Primary programming/debug | Native USB Serial/JTAG |
| Recovery/test | UART0 on GPIO43/44 plus GPIO0/EN |
| Future CAN/RS485 | Unallocated peripheral capacity only |

## 5. Unresolved dependencies

- ESP32-S3-WROOM-1-N8 memory, RF, mechanical, lifecycle, and procurement verification.
- No master-inhibit feedback GPIO is allocated; validate fixture-only feedback and confirm no power-good, source-detect, or revision-ID GPIO becomes mandatory.
- Confirm the documentation-only J11 disposition at release.
- I2C, ADC, input-conditioning, and output-drive electrical contracts.
- Physical boot/reset/UART production-test access.
- Framework-level simultaneous peripheral validation.
- Connector grouping and pin-count release.

No GPIO assignment is **Released** until these dependencies are dispositioned through engineering review.
