# IPC-100 Processor Selection Study

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Decision scope | ESP32-family processor/module recommendation |
| Date | 2026-07-29 |
| Status | Engineering recommendation; exact ordering variant and pin allocation not released |
| Owner | Iron Pine Outdoors Engineering |

## 1. Executive decision

**Preferred module family:** ESP32-S3-WROOM-1  
**Second choice:** ESP32-WROOM-32E  
**Recommendation confidence:** High for the module-family ranking; medium for final Rev A selection until pin-level feasibility, memory budgeting, antenna/mechanical review, and procurement review are complete.

ESP32-S3-WROOM-1 is **Recommended** for IPC-100 Rev A. Its 36 module GPIOs, native USB Serial/JTAG, dual-core processor, 512 KB on-chip SRAM, available flash/PSRAM configurations, Wi-Fi, Bluetooth LE, and mature Espressif ecosystem provide the best fit for the documented platform and its expansion direction. This recommendation does not select a flash/PSRAM ordering suffix and does not assign pins.

ESP32-WROOM-32E is **Acceptable** as the second choice only if the architecture adopts approved resource-reduction circuitry and an external USB-to-UART service approach. Its maximum 26 GPIOs cannot satisfy the approximately 29-signal direct scenario before all module restrictions and optional resources are considered.

ESP32-C6-WROOM-1 and ESP32-C3-WROOM-02 are **Not Recommended** for Rev A. Their newer radio or lower-cost advantages do not compensate for the GPIO pressure and reduced processing margin in this control platform.

## 2. Scope and method

This study compares ESP32-family modules only. It derives needs from the controlled IPC-100 requirements, architecture, connector, power, firmware-interface, and readiness documents. It does not invent application loads, firmware image sizes, timing rates, numeric power budgets, or product-specific features.

Counts are resource-screening values, not pin assignments. “GPIO” is the module datasheet maximum; “usable GPIO” is qualitative because strapping, flash/PSRAM connections, USB, ADC, boot safety, input-only limitations, and peripheral routing depend on the exact ordering variant and final allocation.

## 3. Derived processor requirements

### 3.1 Required interfaces and resources

| Requirement | Derived Rev A need | Basis / disposition |
| --- | --- | --- |
| Digital inputs | 10 independent inputs | Four limits, encoder A/B/push, ARM, FIRE, STOP |
| Digital outputs | 14 independent outputs in the direct scenario | Eight motor-interface signals, relay, RGB x3, buzzer, OLED reset |
| PWM | Four required motor PWM outputs; RGB and buzzer PWM preferred or device-dependent | Exact frequency/resolution remain TBD |
| ADC | One battery-monitoring path | Internal ADC or approved external path; accuracy and Wi-Fi coexistence require validation |
| Interrupts | Up to 10 interrupt-preferred inputs | Exact latency and interrupt allocation remain TBD |
| I2C | One controlled bus | OLED, environmental sensor, and controlled expansion; segmentation remains TBD |
| UART | Recovery/service UART is desirable even with native USB; future RS485 may require another UART | Exact service and RS485 architecture remain TBD |
| SPI | No locked external Rev A SPI device | Capability is valuable for future products/expansion but is not a current pin claim |
| Timers/counters | PWM generation, timeouts, watchdogs, encoder/event timing | Numeric timing demand is not yet documented |
| Wireless | Wi-Fi, Bluetooth, and ESP-NOW | Bluetooth mode is not locked; BLE satisfies the current unqualified Bluetooth requirement pending protocol approval |
| CAN | Future provision only | Native TWAI controller is advantageous; transceiver and connector are not selected |
| RS485 | Future provision only | Requires UART plus direction control and external transceiver |
| Service | USB-C external interface, programming, diagnostics, reset/boot recovery, debug | Native USB versus bridge is evaluated below |
| Memory | Sufficient executable, runtime, update, diagnostics, configuration, and reserve capacity | No defensible byte-level budget exists yet |
| Reliability | Watchdogs, brownout detection, deterministic boot, hardware-safe outputs | Exact thresholds, timeouts, and circuit mechanisms remain TBD |
| Power modes | Reset/brownout behavior is required; sleep is desirable for future battery products | No sleep-current target or duty cycle is approved |
| DMA | Desirable for scalable communications/display work | No current throughput requirement proves DMA mandatory |

The direct implementation is approximately 29 MCU signal resources, excluding module-specific reset/boot management and optional controls. An illustrative, non-approved external-interface approach reduces this to approximately 19. Neither count is a released allocation.

### 3.2 Margin criteria

A suitable module must leave credible margin after required functions, USB, boot-strapping, flash/PSRAM restrictions, antenna implementation, ADC suitability, safe-state constraints, and service/recovery are considered. Optional GPIO, CAN, RS485, daughterboards, and future products may consume only remaining validated resources.

## 4. Candidate comparison

| Attribute | ESP32-S3-WROOM-1 | ESP32-WROOM-32E | ESP32-C6-WROOM-1 | ESP32-C3-WROOM-02 |
| --- | --- | --- | --- | --- |
| CPU | Dual-core Xtensa LX7, up to 240 MHz | Dual-core Xtensa LX6, up to 240 MHz | Single-core RISC-V, up to 160 MHz | Single-core RISC-V, up to 160 MHz |
| Module GPIO maximum | 36 | Up to 26 | 23 | Up to 15 |
| GPIO pressure | **Acceptable** direct; **Comfortable** reduced | **Insufficient** direct; **Acceptable/Marginal** reduced | **Insufficient** direct; **Marginal** reduced | **Insufficient** |
| PWM/motor control | LED PWM and MCPWM | LED PWM and MCPWM | LED PWM and MCPWM | LED PWM; exact motor-peripheral fit requires validation |
| ADC | Integrated SAR ADC; exact pins/performance TBD | Integrated SAR ADC; Wi-Fi/ADC restrictions require care | Integrated SAR ADC | Integrated SAR ADC |
| Timers/watchdogs | Available | Available | Available | Available |
| UART / I2C / SPI | Multiple peripheral interfaces; exact routing TBD | Multiple peripheral interfaces; exact routing TBD | Multiple peripheral interfaces; exact routing TBD | Peripheral interfaces available, but GPIO is limiting |
| Native USB | USB Serial/JTAG and full-speed USB 2.0 OTG | No | USB Serial/JTAG | USB Serial/JTAG |
| On-chip SRAM | 512 KB plus RTC SRAM | 520 KB | 512 KB HP plus 16 KB LP SRAM | 400 KB SRAM |
| Module flash options | Up to 16 MB | 4/8/16 MB variants | Up to 8 MB | Module variant dependent |
| PSRAM | Optional, up to 16 MB on module variants | Not provided by WROOM-32E | No module PSRAM option identified | No module PSRAM option identified |
| Wi-Fi | 802.11 b/g/n | 802.11 b/g/n | Wi-Fi 6 plus b/g/n | 802.11 b/g/n |
| Bluetooth | Bluetooth 5 LE / mesh | Bluetooth 4.2 BR/EDR and LE | Bluetooth 5.3 LE | Bluetooth 5 LE |
| Additional radio | None required | None required | 802.15.4 for Thread/Zigbee | None |
| CAN path | TWAI controller; external transceiver required | TWAI controller; external transceiver required | TWAI controller; external transceiver required | TWAI controller; external transceiver required |
| Package impact | WROOM module; largest GPIO margin in compared set | Familiar WROOM module | WROOM module; lower GPIO margin | Compact module; inadequate GPIO margin |
| Ecosystem maturity | Mature and actively documented | Most mature/legacy-compatible | Newer generation; improving ecosystem | Mature for compact BLE/Wi-Fi nodes |
| Arduino / ESP-IDF / PlatformIO | Supported | Supported | Supported; verify exact framework/version features before release | Supported |
| Relative cost | Qualitatively moderate; exact sourcing TBD | Qualitatively moderate and broadly familiar | Qualitatively moderate; radio capability may add value outside Rev A | Qualitatively favorable; exact sourcing TBD |

Peripheral quantities and restrictions must be verified against the selected module/SoC datasheet during pin allocation. The table intentionally does not convert peripheral presence into guaranteed simultaneously usable IPC-100 interfaces.

## 5. Candidate assessments

### 5.1 ESP32-S3-WROOM-1 — Recommended

Strengths:

- Best GPIO margin of the evaluated modules.
- Native USB Serial/JTAG supports flashing, console, and integrated JTAG without an on-board USB-to-UART bridge.
- Dual-core processing and DMA-capable peripherals provide useful concurrency margin for control, wireless, UI, diagnostics, and future platform services.
- Optional PSRAM variants provide a migration path without changing processor family.
- Wi-Fi, Bluetooth LE, ESP-NOW, TWAI, UART, I2C, SPI, PWM, ADC, timers, watchdogs, brownout functions, and sleep modes align with the documented capability set.

Risks:

- Bluetooth Classic is absent. Current requirements do not demand Classic Bluetooth, but protocol selection must remain BLE-compatible or the recommendation must be revisited.
- USB D+/D- consume fixed GPIO resources, and USB Serial/JTAG and USB OTG share internal-PHY constraints.
- Exact flash/PSRAM configuration changes available pins and memory behavior.
- Thirty-six GPIOs do not by themselves prove 29-signal direct feasibility after strap, ADC, USB, boot-safe, and board constraints.
- Antenna keepout, module footprint, power peaks, and sourcing require final review.

### 5.2 ESP32-WROOM-32E — Acceptable second choice

Strengths:

- Deep ecosystem maturity, broad field history, dual-core processing, and Bluetooth Classic plus BLE.
- Wi-Fi/ESP-NOW and the required general-purpose peripherals are available.
- Multiple flash configurations and broad tool support reduce software migration risk.

Risks:

- Up to 26 GPIOs is below the direct 29-signal screening demand before management resources.
- No native USB; an external bridge or external service adapter is needed for USB-C programming/diagnostics.
- ADC behavior and Wi-Fi coexistence require careful path selection and validation.
- Little credible expansion margin remains even after resource reduction.
- Choosing it would preserve legacy familiarity at the cost of service integration and long-term platform headroom.

### 5.3 ESP32-C6-WROOM-1 — Not Recommended for Rev A

Strengths:

- Wi-Fi 6, Bluetooth 5.3 LE, 802.15.4, native USB Serial/JTAG, TWAI, and modern RISC-V architecture.
- Attractive for future low-power or mesh-connected Iron Pine products.

Risks:

- Twenty-three GPIOs cannot support the direct scenario and leave marginal room in the illustrative reduced scenario.
- Single-core processing provides less concurrency margin than the S3 for a universal controller.
- 802.15.4 and Wi-Fi 6 are not current IPC-100 requirements.
- Newer silicon/software integration increases qualification effort relative to the benefit for Rev A.

### 5.4 ESP32-C3-WROOM-02 — Not Recommended

Strengths:

- Compact, cost-conscious Wi-Fi/BLE module with native USB Serial/JTAG and a mature embedded ecosystem.
- Suitable for smaller peripheral nodes with modest I/O.

Risks:

- Up to 15 GPIOs is insufficient even for the illustrative reduced IPC-100 scenario.
- Single-core processing, no Bluetooth Classic, and limited resource margin constrain platform reuse.
- Making it fit would require a materially different external I/O architecture that is not approved.

## 6. USB architecture recommendation

Use ESP32-S3 native **USB Serial/JTAG** as the preferred IPC-100 programming, console, and debug architecture. Do not populate an on-board USB-to-UART bridge by default.

This approach reduces component count, avoids consuming a service UART solely for the bridge, provides integrated JTAG, and supports direct flashing through the USB-C service interface. USB OTG remains a processor capability, not a released IPC-100 product feature.

Preserve an accessible recovery path using the module’s documented boot/reset controls and UART-level service/test access. Exact connector circuitry, ESD protection, CC configuration, VBUS interaction, automatic reset behavior, and production fixture interface remain schematic decisions. A USB-to-UART bridge may be reconsidered if recovery testing, manufacturing workflow, USB application conflicts, or field service reliability demonstrate a need; no bridge IC is selected here.

## 7. Memory assessment

The repository does not yet contain a firmware image, runtime allocation model, logging-retention target, OTA partition policy, graphics framebuffer design, or product configuration envelope. A byte-level memory claim would therefore be unsupported.

The S3’s 512 KB on-chip SRAM and configurable module flash provide the strongest baseline among the candidates without requiring PSRAM. PSRAM is **not demonstrated as required** for Rev A. It remains a useful option for future richer displays, buffered logging, diagnostics, networking, or RangeHub-class coordination, but external PSRAM adds configuration, validation, power, and pin/resource considerations.

Before selecting an exact module suffix, firmware architecture shall establish:

- bootloader/application/rollback/update partition needs;
- worst-case static, heap, stack, wireless, display, and diagnostic memory;
- nonvolatile configuration and event-retention needs;
- minimum reserve policy;
- whether PSRAM may hold only noncritical data or is required for a feature.

## 8. Long-term platform fit

ESP32-S3-WROOM-1 best supports the universal-controller philosophy across CrossWind, target systems, motion platforms, RangeHub integration, remote panels, service tools, and other outdoor automation products. Its benefit is not a promise that every future product will use every interface. It provides a common high-margin baseline while hardware abstraction keeps product firmware independent of GPIO and ordering variants.

ESP32-C6 remains strategically interesting for future wireless nodes needing Wi-Fi 6 or 802.15.4. It should be treated as a related platform option, not a drop-in IPC-100 Rev A substitute. Module-family migration requires a new pin allocation, boot/service review, radio/protocol review, power validation, PCB and antenna review, firmware target validation, and regression testing.

## 9. Recommendation and remaining gates

| Candidate | Classification | Role |
| --- | --- | --- |
| ESP32-S3-WROOM-1 | **Recommended** | Preferred Rev A module family |
| ESP32-WROOM-32E | **Acceptable** | Second choice with resource reduction and USB bridge/external adapter |
| ESP32-C6-WROOM-1 | **Not Recommended** | Future specialized wireless-node consideration |
| ESP32-C3-WROOM-02 | **Not Recommended** | Insufficient IPC-100 resource margin |

The recommendation resolves the comparative module-family and preferred USB-architecture questions. It does **not** resolve:

- exact ESP32-S3-WROOM-1 ordering code, flash size, or PSRAM population;
- GPIO allocation or simultaneous peripheral feasibility;
- boot-strapping and hardware-safe output compatibility;
- ADC path and measurement performance;
- watchdog policy, power budget, antenna/mechanical constraints, or procurement approval;
- future CAN/RS485 population or pins.

Schematic readiness remains blocked until those items and the other readiness-review gates are closed.

## 10. Authoritative references

- [ESP32-S3-WROOM-1 / WROOM-1U datasheet](https://documentation.espressif.com/esp32-s3-wroom-1_wroom-1u_datasheet_en.pdf)
- [ESP32-WROOM-32E / WROOM-32UE datasheet](https://documentation.espressif.com/esp32-wroom-32e_esp32-wroom-32ue_datasheet_en.html)
- [ESP32-C6-WROOM-1 / WROOM-1U datasheet](https://documentation.espressif.com/esp32-c6-wroom-1_wroom-1u_datasheet_en.html)
- [ESP32-C3-WROOM-02 / WROOM-02U datasheet](https://documentation.espressif.com/esp32-c3-wroom-02_datasheet_en.html)
- [ESP-IDF ESP32-S3 serial connection guidance](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/get-started/establish-serial-connection.html)
- [ESP-IDF ESP32-S3 built-in JTAG guidance](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-guides/jtag-debugging/configure-builtin-jtag.html)
- [ESP-IDF ESP32-S3 USB host/PHY constraints](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-reference/peripherals/usb_host.html)
- [PlatformIO Espressif 32 platform documentation](https://docs.platformio.org/en/latest/platforms/espressif32.html)
- [Espressif product longevity commitment](https://www.espressif.com/en/content/do-your-products-have-longevity-commitment)

Datasheets and availability shall be rechecked at component release. Espressif’s general longevity commitment supports family selection but does not replace orderable-part lifecycle and distributor review.
