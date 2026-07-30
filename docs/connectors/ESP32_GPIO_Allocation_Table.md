# IPC-100 Rev A ESP32-S3 GPIO Allocation Table

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Processor | ESP32-S3-WROOM-1-N8 |
| Authority | ADR-040 / AR-02, amended by ADR-044 / AR-06 |
| Status | Accepted for preliminary Sheet 03 capture |
| Date | 2026-07-29 |

ADR-041 confirms that firmware does not consume `MAIN_POWER_GOOD`. ADR-042 and ADR-043 preserve the safety and motion allocations. ADR-044 assigns GPIO42 to the independent-watchdog service interface and leaves GPIO37 as the sole future reserve. This 36-row inventory is authoritative.

## Capability conventions

- GPIO0–21 are RTC-capable digital GPIO. GPIO1–10 provide ADC1; GPIO11–20 provide ADC2.
- Digital GPIO generally supports interrupts and GPIO-matrix PWM, I²C, SPI, and UART routing. A “Yes” entry means silicon capability, not permission to change the controlled assignment.
- GPIO19/20 are fixed to native USB for IPC-100.
- GPIO0, GPIO3, GPIO45, and GPIO46 are strapping pins. GPIO46 is retained unused and shall not be treated as a normal output.
- ESP32-S3-WROOM-1-N8 exposes GPIO35–37 because it has no octal PSRAM and retains ordinary 3.3 V behavior on GPIO47/48.
- “Boot safe” describes the IPC-100 external contract. Outputs still require external defaults because processor GPIO is high-impedance during reset.

## Complete inventory

| GPIO | Functional assignment | Sheet owner | Dir. | Strap | RTC | Analog | IRQ | PWM | I²C | SPI | UART | USB | Boot-safe disposition | Reserve / expansion |
| ---: | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | `ESP_BOOT` / download strap | 03 | In | Yes | Yes | No | Yes | No | No | No | No | No | 10 kΩ up; momentary low only | Programming reserved |
| 1 | `BATTERY_SENSE` | 03 | In | No | Yes | ADC1_CH0 | Yes | No | No | No | No | No | High-Z analog | No |
| 2 | `STOP_IN_COND` | 03/04 | In | No | Yes | ADC1_CH1 unused | Yes | No | No | No | No | No | External conservative state | Safety allocated |
| 3 | Unused strap | 03 | In | Yes | Yes | ADC1_CH2 unused | Yes | No | No | No | No | No | No external loading | Prohibited |
| 4 | `LIMIT_LEFT_COND` | 03/04 | In | No | Yes | ADC1_CH3 unused | Yes | No | No | No | No | No | External conservative state | Safety allocated |
| 5 | `LIMIT_RIGHT_COND` | 03/04 | In | No | Yes | ADC1_CH4 unused | Yes | No | No | No | No | No | External conservative state | Safety allocated |
| 6 | `LIMIT_UP_COND` | 03/04 | In | No | Yes | ADC1_CH5 unused | Yes | No | No | No | No | No | External conservative state | Safety allocated |
| 7 | `LIMIT_DOWN_COND` | 03/04 | In | No | Yes | ADC1_CH6 unused | Yes | No | No | No | No | No | External conservative state | Safety allocated |
| 8 | `ARM_IN_COND` | 03/04 | In | No | Yes | ADC1_CH7 unused | Yes | No | No | No | No | No | External inactive/invalid | Allocated |
| 9 | `FIRE_IN_COND` | 03/04 | In | No | Yes | ADC1_CH8 unused | Yes | No | No | No | No | No | External inactive/invalid | Allocated |
| 10 | `ENCODER_A_COND` | 03/07 | In | No | Yes | ADC1_CH9 unused | Yes | No | No | No | No | No | External inactive | Allocated |
| 11 | `ENCODER_B_COND` | 03/07 | In | No | Yes | ADC2_CH0 unused | Yes | No | No | No | No | No | External inactive | Allocated |
| 12 | `ENCODER_SW_COND` | 03/07 | In | No | Yes | ADC2_CH1 unused | Yes | No | No | No | No | No | External inactive | Allocated |
| 13 | `AXIS1_RPWM_MCU` | 03 | Out | No | Yes | ADC2_CH2 unused | Yes | MCPWM | Yes | Yes | Yes | No | External inactive plus inhibit | Motion allocated |
| 14 | `AXIS1_LPWM_MCU` | 03 | Out | No | Yes | ADC2_CH3 unused | Yes | MCPWM | Yes | Yes | Yes | No | External inactive plus inhibit | Motion allocated |
| 15 | `AXIS2_RPWM_MCU` | 03 | Out | No | Yes | ADC2_CH4 unused | Yes | MCPWM | Yes | Yes | Yes | No | External inactive plus inhibit | Motion allocated |
| 16 | `AXIS2_LPWM_MCU` | 03 | Out | No | Yes | ADC2_CH5 unused | Yes | MCPWM | Yes | Yes | Yes | No | External inactive plus inhibit | Motion allocated |
| 17 | `AXIS1_REN_MCU` | 03 | Out | No | Yes | ADC2_CH6 unused | Yes | Yes | Yes | Yes | Yes | No | External disabled plus inhibit | Motion allocated |
| 18 | `AXIS1_LEN_MCU` | 03 | Out | No | Yes | ADC2_CH7 unused | Yes | Yes | Yes | Yes | Yes | No | External disabled plus inhibit | Motion allocated |
| 19 | `USB_D-` | 03 | I/O | No | Yes | ADC2_CH8 unused | Yes | No | No | No | No | D- | USB-defined; no actuator effect | USB reserved |
| 20 | `USB_D+` | 03 | I/O | No | Yes | ADC2_CH9 unused | Yes | No | No | No | No | D+ | USB-defined; no actuator effect | USB reserved |
| 21 | `AXIS2_REN_MCU` | 03 | Out | No | Yes | No | Yes | Yes | Yes | Yes | Yes | No | External disabled plus inhibit | Motion allocated |
| 35 | `OLED_POWER_REQ` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | Sheet 02 100 kΩ pull-down | ADR-039 request |
| 36 | `SENSOR_POWER_REQ` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | Sheet 02 100 kΩ pull-down | ADR-039 request |
| 37 | `FUTURE_COMM_GPIO_A` | 03 | I/O | No | No | No | Yes | Yes | Yes | Yes | Yes | No | Unconnected in Rev A | Reserved pool |
| 38 | `AXIS2_LEN_MCU` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | External disabled plus inhibit | Motion allocated |
| 39 | `RELAY_CMD_MCU` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | External de-energized plus inhibit | Actuator allocated |
| 40 | `UI_POWER_REQ` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | Sheet 02 100 kΩ pull-down | ADR-039 request |
| 41 | `EXPANSION_POWER_REQ` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | Sheet 02 100 kΩ pull-down | ADR-039 request |
| 42 | `WATCHDOG_SERVICE_MCU` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | Yes | No | Sheet 06 local pull-down; static levels invalid | ADR-044 safety service |
| 43 | `UART0_TX` | 03 | Out | No | No | No | Yes | Yes | Yes | Yes | UART0 TX | No | ROM traffic allowed; fixture tolerant | Manufacturing/recovery |
| 44 | `UART0_RX` | 03 | In | No | No | No | Yes | No | Yes | Yes | UART0 RX | No | Fixture shall not drive unpowered MCU | Manufacturing/recovery |
| 45 | Unused VDD_SPI strap | 03 | In | Yes | No | No | Yes | No | No | No | No | No | No external loading | Prohibited |
| 46 | Unused boot strap | 03 | In | Yes | No | No | Yes | No | No | No | No | No | No external loading | Prohibited |
| 47 | `I2C_SDA` | 03 | I/O | No | No | No | Yes | No | I2C0 SDA | Yes | Yes | No | External bus benign/unpowered | Shared bus |
| 48 | `I2C_SCL` | 03 | I/O | No | No | No | Yes | No | I2C0 SCL | Yes | Yes | No | External bus benign/unpowered | Shared bus |

EN is a module control pin rather than a GPIO. Sheet 03 owns its supervisor, 10 kΩ pull-up, 1 µF timing capacitor, reset switch interface, and fixture handoff.

## Functions moved behind the Sheet 07 I²C boundary

| Functional signal | Previous direct GPIO | New owner | Required safe default |
| --- | ---: | --- | --- |
| `RGB_B` | 35 | Sheet 07 I²C expander | Off |
| `BUZZER_OUT` | 36 | Sheet 07 I²C expander | Silent |
| `RGB_R` | 40 | Sheet 07 I²C expander | Off |
| `RGB_G` | 41 | Sheet 07 I²C expander | Off |
| `OLED_RESET` | 42 | Sheet 07 I²C expander | Asserted or electrically non-driving |

The expander is not selected or implemented by AR-02. It shall be core-powered, have a controlled address and reset behavior, and shall not backfeed an unpowered UI or OLED branch.

## Utilization summary

| Resource class | GPIOs | Count |
| --- | --- | ---: |
| Application and power-request allocation | 1, 2, 4–18, 21, 35, 36, 38–42, 47, 48 | 27 |
| Safety inputs within application allocation | 2, 4, 5, 6, 7 | 5 |
| Native USB | 19, 20 | 2 |
| Boot/programming | 0 | 1 |
| UART0 manufacturing/recovery | 43, 44 | 2 |
| Future communications/diagnostic pool | 37 | 1 |
| Boot-restricted and unused | 3, 45, 46 | 3 |
| Unused and unreserved | None | 0 |
| Total module GPIO | GPIO0–21, GPIO35–48 | 36 |

Every brought-out GPIO has exactly one allocation or reservation. The Rev A baseline is feasible. Direct expansion is limited to GPIO37; future UI/sensor expansion uses I²C. Future CAN or RS-485 requires a later controlled allocation and is not a Rev A interface.

## Cross-sheet export rules

- Sheet 03 is the only schematic sheet that may show raw ESP32 GPIO numbers.
- Sheets 04–09 export or consume functional names only.
- A raw pin assignment shall never be encoded in a connector name, harness name, or external interface contract.
- Changing this table requires an architecture decision, hierarchy review, firmware mapping update, and regression review of strap, reset, USB, recovery, safety, and future reserves.

## Validation checklist

- [x] All 36 brought-out GPIOs inventoried.
- [x] No GPIO assigned more than once.
- [x] Four ADR-039 power requests assigned.
- [x] GPIO0/3/45/46 strap restrictions preserved.
- [x] Native USB GPIO19/20 preserved.
- [x] UART0 GPIO43/44 preserved.
- [x] Safety and motion assignments unchanged.
- [x] Two future direct pins reserved.
- [x] Raw-GPIO ownership restricted to Sheet 03.
- [ ] Exact module pins and capabilities rechecked during Package 04R symbol review.
- [ ] Reset/bootloader low behavior verified in hardware and firmware.
- [ ] Sheet 07 expander selected and electrically reviewed before Sheet 07 implementation.

## Authoritative references

- [ESP32-S3-WROOM-1/WROOM-1U datasheet](https://documentation.espressif.com/esp32-s3-wroom-1_wroom-1u_datasheet_en.pdf)
- [ESP32-S3 hardware design guidelines](https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32s3/)
- [ADR-039](../decisions/ADR-039_Regulated_Rail_Enable_Ownership_and_Main_Source_Qualification.md)
- [ADR-040](../decisions/ADR-040_ESP32_GPIO_Allocation_and_Interface_Ownership.md)
