# IPC-100 Rev A GPIO and Peripheral Allocation Review

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Processor basis | ESP32-S3-WROOM-1 module family |
| Status | Allocation review complete; pin-map release blocked |
| Date | 2026-07-29 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose

This review maps the controlled IPC-100 logical interfaces to a proposed ESP32-S3 pin and peripheral plan. It proves a feasible direct allocation under stated module assumptions without authorizing component selection, schematic capture, firmware implementation, or PCB layout.

## 2. Scope

The review covers every required processor-connected Rev A signal, fixed native USB, boot/reset/recovery access, proposed peripheral instances, pin restrictions, optional resources, and remaining pin-level risks. Connector electrical conditioning, output drive circuits, component values, module memory capacity, RF layout, and product behavior remain outside this allocation.

## 3. Governing architecture

The allocation preserves these controlled decisions:

- ESP32-S3-WROOM-1 is the preferred module family.
- USB-C uses native USB Serial/JTAG for service, programming, console, and debug.
- USB-only operation powers only the bounded core/service domain.
- STOP and four limits are conditioned, supervised, de-energize-to-safe inputs; they are not direct field-to-GPIO connections.
- Motor and relay authorization share a hardware master inhibit that is independent of normal firmware command state.
- All motor commands default inactive, all enables default disabled, and relay control defaults de-energized.
- One controlled I2C bus serves the OLED, environmental sensor, and optional local expansion.
- CAN and RS485 are future provisions, not released Rev A interfaces.

## 4. Selected processor/module basis

The basis is the **ESP32-S3-WROOM-1 family**, not an exact ordering code.

| Conclusion | Applicability |
| --- | --- |
| GPIO0–21 and GPIO35–48 are the GPIOs brought out by this module family | Family-common module pinout |
| GPIO19/20 are fixed to native USB D-/D+ for IPC-100 | Current architecture decision |
| GPIO0, GPIO3, GPIO45, and GPIO46 are strapping pins | Chip capability/restriction |
| GPIO35–37 are unavailable on module variants using octal SPI PSRAM | Exact module/memory dependent |
| GPIO47/48 operate at a different voltage on ESP32-S3R16V-based variants | Exact chip/module variant dependent |
| GPIO26–34 are not module user pins on ESP32-S3-WROOM-1 | Module/package availability restriction |
| GPIO43/44 are the default UART0 TX/RX functions | Chip capability; reserved here for recovery |

The exact flash/PSRAM ordering variant **must be selected before pin-map release**. This proposed map uses GPIO35 and GPIO36 and therefore excludes variants that connect them to octal PSRAM. GPIO37 remains a conditional reserve only. The plan does not establish how much flash or PSRAM IPC-100 needs.

## 5. Allocation principles

- Preserve GPIO19/20 exclusively for native USB.
- Preserve physical access to EN, GPIO0 boot mode, and UART0 GPIO43/44.
- Do not place required application signals on strapping pins.
- Use external conditioning and hardware defaults; never rely on processor internal pulls for safe states.
- Keep STOP and limits on ordinary interrupt-capable GPIOs.
- Keep `BATTERY_SENSE` on ADC1 to avoid ADC2/wireless contention.
- Use MCPWM for the four motor PWM commands; keep all four enable commands independently controllable.
- Keep the master-inhibit path independent of output GPIO initialization.
- Keep I2C on ordinary routable pins and tolerate absent or unpowered main-only peripherals.
- Prefer low-numbered RTC-capable GPIOs for inputs where useful, without creating an unapproved wake requirement.
- Reserve UART0 recovery even though native USB is primary.
- Do not claim CAN, RS485, spare GPIO, or octal-memory compatibility that the direct plan cannot physically guarantee.

## 6. Signal inventory

### 6.1 Required application signals

| Group | Signals | Count | Capability |
| --- | --- | ---: | --- |
| Safety/command inputs | `STOP_IN`, `ARM_IN`, `FIRE_IN`, four limits | 7 | Conditioned digital input; interrupt preferred |
| User inputs | `ENCODER_A`, `ENCODER_B`, `ENCODER_SW` | 3 | Digital input; PCNT/interrupt optional |
| Motor PWM | `AXIS1_RPWM`, `AXIS1_LPWM`, `AXIS2_RPWM`, `AXIS2_LPWM` | 4 | MCPWM output |
| Motor enables | `AXIS1_REN`, `AXIS1_LEN`, `AXIS2_REN`, `AXIS2_LEN` | 4 | Independent digital output |
| Other outputs | `RELAY_CTRL`, three RGB, `BUZZER_OUT`, `OLED_RESET` | 6 | Digital output; status PWM optional |
| I2C | `I2C_SDA`, `I2C_SCL` | 2 | Open-drain I2C |
| Analog | `BATTERY_SENSE` | 1 | ADC1 input |
| Required application total |  | **27** | Excludes fixed USB and module management |

Native USB adds GPIO19/20, yielding the previously documented **29 direct processor signal resources**. EN and GPIO0 are management pins rather than application GPIO assignments.

### 6.2 Optional or unresolved processor-facing signals

| Concept | Status | Allocation disposition |
| --- | --- | --- |
| Master-inhibit command | Not required by approved architecture; inhibit may derive from hardware-valid conditions | No GPIO allocated |
| Master-inhibit state feedback | Desirable diagnostic, not approved as required | Blocked; no GPIO available in direct plan |
| Power-good/source detect | Hardware architecture not resolved to processor signal | Blocked; no GPIO allocated |
| Rail monitoring beyond battery sense | Not approved | No allocation |
| `SPARE_GPIO1`, `SPARE_GPIO2` | Proposed connector capabilities | Unresolved; cannot both be guaranteed by direct plan |
| Future CAN/TWAI | Future provision | Peripheral capacity only; no physical pair reserved |
| Future RS485 | Future provision | UART capacity only; no physical TX/RX/direction set reserved |
| I2C segmentation control | Implementation dependent | No GPIO allocated |
| Hardware revision ID | Implementation dependent | No GPIO allocated |

## 7. Peripheral inventory

| Peripheral | Rev A use | Capacity disposition |
| --- | --- | --- |
| MCPWM0 | Four motor PWM signals using two operators and four generators | One operator pair remains in the group; second controller remains uncommitted |
| GPIO output | Four enables, relay, RGB, buzzer, OLED reset | Feasible through GPIO matrix |
| GPIO interrupt | STOP, limits, ARM/FIRE, encoder switch | All proposed pins support digital interrupts |
| PCNT | Encoder A/B candidate | One unit/channel set proposed; GPIO interrupts remain fallback |
| ADC1 | `BATTERY_SENSE` | ADC1 channel 0 proposed |
| I2C0 | Shared OLED/sensor/J10 bus | One controller used; second controller remains peripheral capacity only |
| USB Serial/JTAG | Primary service/program/debug | Fixed GPIO19/20 |
| UART0 | Recovery/test access | GPIO43/44 physically reserved |
| UART1/2 | Unassigned | Future peripheral capacity; pins not reserved |
| TWAI | Unassigned | Future peripheral capacity; pins not reserved |
| LEDC | Status PWM if required | Up to four proposed status channels; do not consume motor PWM allocation |
| Timers/watchdogs | Timeouts, sequencing, watchdogs | Capacity concept only; exact firmware resource plan remains open |

## 8. Pin restrictions

| Pins/resource | Restriction or behavior | IPC-100 disposition |
| --- | --- | --- |
| GPIO0 | Boot strap; low during reset selects download mode with GPIO46 condition | Dedicated boot/recovery access; no application signal |
| GPIO3 | Strapping pin controlling JTAG signal source behavior | Avoided |
| GPIO45 | Strapping pin affecting VDD_SPI voltage | Avoided |
| GPIO46 | Strapping/input behavior and boot-mode participation | Avoided |
| GPIO19/20 | Native USB D-/D+; power-up glitches are documented | USB only; never safety output |
| GPIO35–37 | Used internally by octal-PSRAM variants | GPIO35/36 conditional required outputs; GPIO37 conditional reserve |
| GPIO47/48 | 1.8 V on ESP32-S3R16V-based variants | Proposed I2C only after exact variant excludes incompatible voltage behavior or translation is approved |
| GPIO43/44 | Default UART0 TX/RX; boot messages may appear on UART0 | Recovery/test only |
| GPIO39–42 | Traditional external JTAG signal functions through IO matrix | Available because native USB JTAG is selected; production fixture must not assume both mappings |
| GPIO1–10 | ADC1-capable; GPIO1–21 are RTC-capable | GPIO1 reserved for battery ADC; selected inputs use ordinary digital function |
| GPIO11–20 | ADC2-capable | No Rev A analog allocation; avoids wireless coexistence risk |
| All application outputs | High impedance until configured and may not hold a firmware-selected state through reset | External hardware defaults and master inhibit required |
| Internal pulls | Weak, tolerance-dependent, and unavailable as a safety guarantee | Convenience only after external electrical contract; never sole safe-state mechanism |
| Input-only pins | ESP32-S3 module exposes no analogous mandatory input-only GPIO set in this plan | Direction is assigned by design, not pin limitation |
| GPIO matrix | Flexible peripheral routing | Does not override strap, USB, memory, ADC, voltage, boot, or safety constraints |

All pins must be rechecked against the exact module datasheet and current silicon errata at component release.

## 9. Proposed pin map

Directions are relative to the processor. “Conditioned” means the connector signal reaches the GPIO only through the still-unreleased electrical interface.

No Rev A deep-sleep or GPIO wake requirement is approved for any signal in this table. For every listed input, the wake requirement is therefore **none for Rev A**; RTC capability on selected low-numbered pins is retained only as an uncommitted future option. Every input and output electrical architecture is selected at the behavioral level but remains dependent on the controlled conditioning or drive contract identified in the safety-input and output-electrical reviews.

| Logical signal | Connector | Class | Dir. | Required capability | Proposed GPIO | Peripheral | Reset/boot behavior | Hardware-safe default | Domain notes | Conflict | Confidence | Rationale |
| --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- | --- | --- | --- |
| `BATTERY_SENSE` | Internal/J1-derived | Analog monitor | In | ADC1 | 1 | ADC1_CH0 | High-Z analog | N/A | Conditioned core-domain ADC | None known | High | Keeps measurement off ADC2 |
| `STOP_IN` | J8/dedicated partition TBD | Safety input | In | Interrupt | 2 | GPIO interrupt | High-Z | External unknown/fault = STOP | Conditioned core input | None known | High | RTC/interrupt capable; no strap |
| `LIMIT_LEFT` | J4 | Safety input | In | Interrupt | 4 | GPIO interrupt | High-Z | External unknown/fault inhibits | Conditioned core input | None known | High | Ordinary RTC/interrupt pin |
| `LIMIT_RIGHT` | J4 | Safety input | In | Interrupt | 5 | GPIO interrupt | High-Z | Same | Same | None known | High | Same |
| `LIMIT_UP` | J5 | Safety input | In | Interrupt | 6 | GPIO interrupt | High-Z | Same | Same | None known | High | Same |
| `LIMIT_DOWN` | J5 | Safety input | In | Interrupt | 7 | GPIO interrupt | High-Z | Same | Same | None known | High | Same |
| `ARM_IN` | J8 | Command input | In | Interrupt preferred | 8 | GPIO interrupt | High-Z | External inactive/invalid | Conditioned core input | None known | High | No strap/peripheral conflict |
| `FIRE_IN` | J8 | Command input | In | Interrupt preferred | 9 | GPIO interrupt | High-Z | External inactive/invalid | Conditioned core input | None known | High | No strap/peripheral conflict |
| `ENCODER_A` | J8 | UI input | In | PCNT/interrupt | 10 | PCNT0 candidate | High-Z | External defined inactive | Conditioned core input | None known | High | Adjacent encoder pair |
| `ENCODER_B` | J8 | UI input | In | PCNT/interrupt | 11 | PCNT0 candidate | High-Z | External defined inactive | Conditioned core input | None known | High | Adjacent encoder pair |
| `ENCODER_SW` | J8 | UI input | In | Interrupt preferred | 12 | GPIO interrupt | High-Z | Inactive/no event | Conditioned core input | None known | High | Non-safety ordinary pin |
| `AXIS1_RPWM` | J2 | Motion output | Out | PWM | 13 | MCPWM0 OP0A | High-Z | External inactive + master inhibit | Main-only conditioned output | None known | High | MCPWM generator |
| `AXIS1_LPWM` | J2 | Motion output | Out | PWM | 14 | MCPWM0 OP0B | High-Z | Same | Same | None known | High | Paired axis operator |
| `AXIS2_RPWM` | J3 | Motion output | Out | PWM | 15 | MCPWM0 OP1A | High-Z | Same | Same | None known | High | MCPWM generator |
| `AXIS2_LPWM` | J3 | Motion output | Out | PWM | 16 | MCPWM0 OP1B | High-Z | Same | Same | None known | High | Paired axis operator |
| `AXIS1_REN` | J2 | Motion output | Out | GPIO | 17 | GPIO | High-Z | Disabled by hardware/master inhibit | Main-only conditioned output | None known | High | Independent enable |
| `AXIS1_LEN` | J2 | Motion output | Out | GPIO | 18 | GPIO | High-Z | Same | Same | None known | High | Independent enable |
| `USB_D-` | J13 | Service | I/O | Native USB | 19 | USB Serial/JTAG | USB-defined/glitches documented | No actuator effect | Core service | Fixed | High | Native USB fixed function |
| `USB_D+` | J13 | Service | I/O | Native USB | 20 | USB Serial/JTAG | USB-defined/glitches documented | No actuator effect | Core service | Fixed | High | Native USB fixed function |
| `AXIS2_REN` | J3 | Motion output | Out | GPIO | 21 | GPIO | High-Z | Disabled by hardware/master inhibit | Main-only conditioned output | None known | High | Independent enable |
| `RGB_B` | J8 | Status output | Out | GPIO/LEDC optional | 35 | LEDC candidate | High-Z | Off in hardware | Main-only UI output | Octal PSRAM | Medium | Low-risk signal on variant-dependent pin |
| `BUZZER_OUT` | J8 | Status output | Out | GPIO/LEDC optional | 36 | LEDC candidate | High-Z | Silent in hardware | Main-only UI output | Octal PSRAM | Medium | Low-risk signal on variant-dependent pin |
| `AXIS2_LEN` | J3 | Motion output | Out | GPIO | 38 | GPIO | High-Z | Disabled by hardware/master inhibit | Main-only conditioned output | None known | High | Common-family ordinary GPIO |
| `RELAY_CTRL` | Internal/J9 contacts | Safety output | Out | GPIO | 39 | GPIO | May expose JTAG function before configuration only as documented | Coil de-energized/master-inhibited | Main-only internal control | Test access | High | Native USB JTAG avoids external JTAG need |
| `RGB_R` | J8 | Status output | Out | GPIO/LEDC optional | 40 | LEDC candidate | High-Z | Off | Main-only UI output | Test access | High | Ordinary output |
| `RGB_G` | J8 | Status output | Out | GPIO/LEDC optional | 41 | LEDC candidate | High-Z | Off | Main-only UI output | Test access | High | Ordinary output |
| `OLED_RESET` | J6 | Peripheral control | Out | GPIO | 42 | GPIO | High-Z | Reset asserted or non-driving | Main-only display interface | Test access | High | Close to I2C grouping is secondary |
| `I2C_SDA` | J6/J7/J10 | Shared bus | I/O | I2C open drain | 47 | I2C0 SDA | High-Z | External bus remains benign/unpowered | Main-only peripherals, core controller | Variant voltage | Medium | Ordinary matrix-routed I2C |
| `I2C_SCL` | J6/J7/J10 | Shared bus | Out/I/O | I2C open drain | 48 | I2C0 SCL | High-Z | Same | Same | Variant voltage | Medium | Ordinary matrix-routed I2C |

**Required application signals:** 27

**Required application signals with proposed GPIO:** 27

**Unassigned required application signals:** 0

**Fixed native USB signals:** 2

## 10. Peripheral assignment

| Function | Proposed assignment | Used | Remaining / fallback |
| --- | --- | ---: | --- |
| Motor PWM | MCPWM0 operators 0 and 1, generators A/B | 4 generators | Operator 2 in MCPWM0 and MCPWM1 remain; LEDC fallback is technically possible but not preferred |
| Motor enables | Four GPIO outputs | 4 | No sharing authorized |
| RGB/buzzer PWM | LEDC channels only if required by final loads | Up to 4 of 8 | Static GPIO fallback where loads permit |
| Safety/command inputs | GPIO interrupts | 7 inputs | Polling may supplement, not replace safety priority |
| Encoder | PCNT0 candidate for A/B; GPIO interrupt for switch | 1 counter concept | GPIO interrupt/software decoding fallback |
| Battery ADC | ADC1 channel 0 | 1 channel | Other ADC1 channels physically consumed by digital allocation; external ADC remains future option |
| I2C | I2C0 on GPIO47/48 | 1 controller | I2C1 controller capacity remains, no pins reserved |
| Service/debug | USB Serial/JTAG on GPIO19/20 | Fixed | UART0 recovery reserved |
| Recovery UART | UART0 default GPIO43/44 | 1 UART | Access method remains schematic/test decision |
| Future TWAI/RS485 | Controller capacity only | 0 physical pins | Requires reassignment/resource reduction or later revision |

## 11. Boot and recovery analysis

- GPIO0 and EN require accessible manual recovery/test control. GPIO0 is not an application signal.
- GPIO3, GPIO45, and GPIO46 are left unused to prevent external interfaces from changing strap sampling.
- Native USB remains wired only to GPIO19/20. Application firmware must not reconfigure these pins.
- USB Serial/JTAG can normally flash and debug the device. Manual GPIO0-low plus EN reset remains the recovery path if firmware disables or reconfigures USB.
- GPIO43/44 remain unallocated application pins and should be accessible to production/service fixtures as UART0 TX/RX. This is a recovery reservation, not authorization for an on-board bridge or user connector.
- EN/reset behavior, boot-control access, automatic-reset behavior, test-pad form, and secure-boot/flash-encryption manufacturing policy remain schematic/manufacturing decisions.
- USB-only service must keep all main-only peripheral and actuator domains off; GPIO states cannot be used to source them.

## 12. Safety-signal analysis

All seven safety/command inputs use ordinary digital GPIOs with interrupt capability and no strap, USB, or memory conflict. ESP32-S3 GPIO interrupts are not the safety mechanism: external supervision and conditioning define healthy/asserted/fault states, while STOP separately reaches the hardware master inhibit. Internal pulls may support diagnostics only after the external contract is approved.

No deep-sleep wake requirement is approved. The selected low-numbered pins are RTC-capable if a later power-mode review needs wake, but that capability is not guaranteed to every interface until sleep behavior is verified. During reset, brownout, USB-only service, or unavailable conditioning power, hardware must provide the conservative state independently of firmware.

## 13. Output-signal analysis

The four motor PWM pins and four enable pins remain independent. MCPWM assignment supports paired axis waveforms, future frequency adjustment, synchronized timing if required, and peripheral-level fault response as an optional implementation aid. It does not replace the external hardware master inhibit or authorize direct driver wiring.

`RELAY_CTRL` uses an ordinary non-strap GPIO but still requires hardware de-energized behavior. RGB, buzzer, and OLED reset are lower-risk main-only outputs. GPIO35/36 are assigned only to RGB blue and buzzer so an exact-module change creates loss of status capability rather than a silent safety-path reassignment.

## 14. ADC analysis

`BATTERY_SENSE` is proposed on GPIO1 / ADC1 channel 0.

- ADC1 avoids the ADC2/Wi-Fi interaction documented by Espressif.
- The measurement is low-rate monitoring; no continuous-mode requirement is established.
- Approved input range, attenuation, calibration method, sampling cadence, filtering, source impedance, grounding, and accuracy budget remain schematic/verification dependencies.
- Radio, motor-command edges, I2C activity, and power conversion may inject noise; sampling and layout must be validated.
- ADC calibration data/API support must be incorporated in the later firmware package.
- An external ADC remains a future option if accuracy or isolation from processor noise proves inadequate.

## 15. PWM analysis

MCPWM is recommended over LEDC for motor commands because it is intended for motor-control waveforms and provides paired generators, synchronization, and fault/brake mechanisms. Two operators in MCPWM0 provide the four independent command outputs. The architecture still requires firmware mutual exclusion and the external hardware master inhibit; MCPWM fault input integration is optional pending inhibit-circuit definition.

No PWM frequency or resolution is selected. The later motor-interface quantitative package must prove the selected frequency, resolution, minimum/maximum duty behavior, startup level, command timeout, disabled interval, and compatibility with external drivers. LEDC remains available for RGB and buzzer control and as a non-preferred motor fallback if a later resource analysis justifies it.

## 16. Communications allocation

- **I2C0:** GPIO47 SDA and GPIO48 SCL for OLED, environmental sensor, and controlled J10 expansion.
- **Native USB Serial/JTAG:** GPIO19 D- and GPIO20 D+.
- **UART0 recovery:** GPIO43 TX and GPIO44 RX reserved for fixture/service access.
- **Wireless:** internal Wi-Fi, Bluetooth LE, and ESP-NOW require no external GPIO.
- **TWAI:** controller capability retained; no Rev A physical pins guaranteed.
- **RS485:** UART capacity retained; no Rev A physical pins or direction-control GPIO guaranteed.

One I2C bus is sufficient for the documented Rev A devices if the pending address, pull-up, loading, segmentation, cable, fault-isolation, recovery, and main-only power contracts are satisfied. USB-only mode may run the controller but shall not power the bus peripherals; firmware must tolerate the bus being unpowered.

## 17. Expansion reserve

| Reserve | Classification | Rev A disposition |
| --- | --- | --- |
| GPIO37 | Physically reserved GPIO, conditional | Available only on compatible non-octal-PSRAM module variant; not connector-released |
| GPIO3/45/46 | Prohibited/avoided | Strapping pins, not expansion |
| UART1/2 | Shared peripheral capacity only | No pins guaranteed |
| I2C1 | Shared peripheral capacity only | No pins guaranteed |
| MCPWM/LEDC capacity | Shared peripheral capacity only | Available subject to GPIO reassignment |
| TWAI | Shared peripheral capacity only | Future interface requires GPIO and transceiver review |
| RS485 | Shared peripheral capacity only | Future interface requires UART pins plus direction control |
| Additional analog | Future revision/schematic option | No clean ADC pin physically reserved |
| Daughterboard interrupt/enable | Not guaranteed | Requires resource reduction or reassignment |
| `SPARE_GPIO1/2` | Not guaranteed | Current connector promise remains blocked |

The direct plan intentionally prioritizes complete Rev A interfaces and recovery over speculative expansion. A guaranteed two-GPIO J11 interface requires approved resource reduction, acceptance of carefully controlled strap-pin use, removal of the UART reservation, or a later platform revision.

## 18. Conflict analysis

| Risk | Severity | Likelihood | Affected signals | Mitigation | Decision stage |
| --- | --- | --- | --- | --- | --- |
| Exact module uses octal PSRAM | High | Medium | GPIO35/36/37 | Select compatible exact ordering variant or remap/reduce resources | Before MCU schematic |
| Variant makes GPIO47/48 1.8 V | High | Low/Medium | I2C | Exclude incompatible variant or approve electrical adaptation | Before MCU schematic |
| Strap loading changes boot | High | Low | GPIO0/3/45/46 | Keep application interfaces off straps; validate fixture pulls | Schematic/test review |
| Firmware disables native USB | Medium | Medium | GPIO19/20 | Manual GPIO0/EN recovery and UART0 fixture access | Schematic/manufacturing |
| UART0 boot output affects fixture | Low | Medium | GPIO43 | Treat as service-only; fixture tolerates ROM traffic | Production test |
| Output GPIO floats during reset | High | Certain | All outputs | External defaults and common hardware master inhibit | Output schematic |
| STOP GPIO fails or firmware stalls | High | Low/Medium | STOP/output authorization | Independent STOP-to-master-inhibit path | Safety schematic |
| ADC noise or range error | Medium | Medium | `BATTERY_SENSE` | Complete analog budget, calibration, layout, and test | Analog schematic/prototype |
| I2C powered-domain backfeed | Medium | Medium | GPIO47/48 | Main-only bus electrical contract and isolation/recovery review | I2C schematic |
| GPIO35/36 late variant conflict | Medium | Medium | RGB_B/buzzer | Keep only non-safety outputs there; configuration control | Component release |
| No two clean spare GPIOs | Medium | High | J11/future products | Resource reduction or future revision; do not release J11 claim | Architecture/schematic |
| No physical CAN/RS485 reservation | Low for Rev A | High for future feature | J12 | Keep future-only status; allocate in consuming revision | Future architecture |
| J8 grouping drives poor routing | Medium | Medium | STOP/UI/status | Connector partitioning review overrides grouping convenience | Connector/schematic |
| Traditional JTAG/test conflict | Low | Medium | GPIO39–42 | Use native USB JTAG; define fixture ownership | Manufacturing |
| MCPWM/API capacity assumption changes | Medium | Low | Motor PWM | Pin-independent firmware feasibility spike before release | Firmware planning |

## 19. Open decisions

1. Select an exact ESP32-S3-WROOM-1 ordering variant compatible with GPIO35/36 and GPIO47/48 assumptions.
2. Approve memory, OTA, and PSRAM requirements; the current allocation effectively rejects octal-PSRAM variants.
3. Define the master-inhibit circuit boundary and whether feedback is mandatory.
4. Decide whether UART0 needs permanent physical test access and define the manufacturing workflow.
5. Resolve J11: resource reduction, conditional single spare, or removal from released Rev A.
6. Confirm no required power-good, source-detect, revision-ID, or I2C-isolation GPIO has been omitted.
7. Validate MCPWM, PCNT, LEDC, I2C, ADC, USB, and interrupt allocation in the chosen ESP-IDF/PlatformIO baseline without implementing product firmware.
8. Complete connector partitioning and electrical-domain contracts before routing these logical signals.

## 20. Schematic readiness

| Area | Assessment | Basis / blocker |
| --- | --- | --- |
| Processor family | Satisfied | ESP32-S3-WROOM-1 preferred |
| Exact module variant | Not Satisfied | Memory/order code and pin availability open |
| Required GPIO count | Satisfied conditionally | 27/27 application signals assigned under variant assumptions |
| Safety-input allocation | Satisfied at pin level | Seven direct conditioned inputs; electrical implementation open |
| Motor-output allocation | Satisfied at pin level | Eight independent GPIOs assigned |
| PWM resources | Satisfied | Four MCPWM generators proposed |
| ADC resources | Satisfied at allocation level | GPIO1/ADC1_CH0 proposed; analog design open |
| I2C allocation | Satisfied conditionally | GPIO47/48 variant voltage must be closed |
| USB allocation | Satisfied | GPIO19/20 preserved |
| Boot and recovery | Satisfied conditionally | GPIO0/EN and UART0 access implementation open |
| Master-inhibit resources | Partially Satisfied | No command GPIO required; feedback/resource need unresolved |
| Expansion reserve | Not Satisfied for promised J11 | One conditional pin only; peripheral capacity otherwise retained |
| Test access | Partially Satisfied | Signals reserved; physical fixture interface open |
| Connector compatibility | Partially Satisfied | Logical map fits; J8/J11 and electrical contracts open |
| Firmware peripheral feasibility | Partially Satisfied | Static capacity shown; framework-level validation pending |

**MCU-sheet preliminary schematic capture:** May begin only after selecting a compatible exact module variant and explicitly dispositioning J11 and inhibit feedback.

**Component selection:** Not authorized by this review.

**Released schematic:** Not ready.

**PCB layout:** Not authorized.

GPIO allocation maturity is **Allocation Review Complete; Release Blocked**.

## 21. Recommended next actions

1. Select the exact module ordering variant and freeze its memory/pin constraints.
2. Resolve the master-inhibit processor interface and J11 spare-GPIO promise.
3. Run a framework-level peripheral allocation compile/proof without changing production firmware behavior.
4. Define recovery and production-test access.
5. Proceed to **IPC-100 Rev A Schematic Hierarchy and Block Interface Definition** to establish KiCad sheet structure, net ownership, and cross-sheet interfaces without selecting all final components.

## 22. Authoritative Espressif references

- [ESP32-S3-WROOM-1 / WROOM-1U Datasheet](https://documentation.espressif.com/esp32-s3-wroom-1_wroom-1u_datasheet_en.pdf)
- [ESP32-S3 Series Datasheet](https://documentation.espressif.com/esp32-s3_datasheet_en.pdf)
- [ESP32-S3 Hardware Design Guidelines](https://documentation.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32s3/schematic-checklist.html)
- [ESP-IDF ESP32-S3 GPIO documentation](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-reference/peripherals/gpio.html)
- [ESP-IDF native USB connection guidance](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/get-started/establish-serial-connection.html)
- [ESP-IDF USB Serial/JTAG console](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-guides/usb-serial-jtag-console.html)
- [ESP-IDF MCPWM documentation](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-reference/peripherals/mcpwm.html)
- [ESP-IDF LEDC documentation](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-reference/peripherals/ledc.html)
- [ESP-IDF ADC documentation](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-reference/peripherals/adc_oneshot.html)
- [ESP-IDF sleep/wakeup documentation](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-reference/system/sleep_modes.html)

Processor facts must be reverified against the current controlled Espressif documents and the selected exact ordering code at component release.
