# ADR-040 — ESP32 GPIO Allocation and Interface Ownership

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Date | 2026-07-29 |
| Status | Accepted |
| Decision owner | Iron Pine Outdoors Engineering |
| Resolution package | AR-02 |
| Supersedes | Direct-GPIO portions of the original GPIO allocation that assigned GPIO35/36/40/41/42 to UI functions |

> **ADR-041 amendment:** Sheet 03 and firmware do not consume `MAIN_POWER_GOOD`. ADR-040's GPIO assignments and reserves remain unchanged.

## Context

ADR-039 added four firmware-controlled peripheral-power requests after the original 27-signal ESP32-S3 allocation was prepared. That direct allocation had only one conditional unused GPIO and could not implement the four requests without a duplicate assignment, strapping-pin use, removal of recovery access, or resource-reduction decision. Package 04 therefore stopped before Sheet 03 modification.

The same entry-gate review found that the Package 04 request incorrectly treated `MAIN_INPUT_VALID`, `POWER_FAULT_SUMMARY`, and `CORE_POWER_GOOD` as Sheet 03 hierarchical inputs and placed USB connector ownership on Sheet 03. Those requests conflict with ADR-039 and the accepted sheet boundaries.

## Decision

### Processor and direct GPIO allocation

IPC-100 Rev A retains ESP32-S3-WROOM-1-N8 for preliminary capture. GPIO3, GPIO45, and GPIO46 remain unused application strapping pins. GPIO0 remains dedicated to boot recovery. GPIO19/20 remain native USB. GPIO43/44 remain UART0 manufacturing and recovery access.

Five low-rate, non-safety UI functions move from direct ESP32 GPIO to a future core-powered I²C GPIO-expander block owned by Sheet 07:

- `RGB_R`
- `RGB_G`
- `RGB_B`
- `BUZZER_OUT`
- `OLED_RESET`

This is an ownership/allocation decision, not authorization to select or place the expander in AR-02. Sheet 07 implementation must provide external safe defaults, tolerate absent main-only peripheral power, and prevent backfeed. RGB shall remain off, the buzzer silent, and OLED reset asserted or electrically non-driving until the appropriate branch is valid.

The released direct assignments for the ADR-039 requests are:

| Functional signal | GPIO | Reason |
| --- | ---: | --- |
| `OLED_POWER_REQ` | 35 | Non-strapping 3.3 V output on N8; released by moving low-risk RGB blue to Sheet 07 |
| `SENSOR_POWER_REQ` | 36 | Non-strapping 3.3 V output on N8; released by moving the buzzer to Sheet 07 |
| `UI_POWER_REQ` | 40 | Non-strapping 3.3 V output; released by moving RGB red to Sheet 07 |
| `EXPANSION_POWER_REQ` | 41 | Non-strapping 3.3 V output; released by moving RGB green to Sheet 07 |

All four pins are direct processor outputs on Sheet 03. Each output:

- is high-impedance during reset and boot ROM operation;
- has the existing 100 kΩ hardware pull-down on Sheet 02;
- shall not receive a pull-up or boot-time peripheral function;
- shall be explicitly configured low at the first firmware GPIO-initialization stage;
- shall remain low through bootloader and recovery operation;
- may assert only after firmware validates initialization and the applicable operating state; and
- remains overridden by Sheet 02 hardware qualification with `MAIN_POWER_GOOD`.

### Future reserve

GPIO37 and GPIO42 form `FUTURE_COMM_GPIO_A/B`, a reserved two-pin pool. They are not exported in the Rev A hierarchy and are not connected to a Rev A external connector.

The pool may support one later approved option:

- TWAI/CAN TX and RX;
- half-duplex RS-485 TX/RX using an approved automatic-direction transceiver;
- two future diagnostic or sensor signals; or
- another reviewed two-wire function.

CAN and RS-485 are mutually exclusive uses of this pool unless a later revision adds resources. Conventional RS-485 with a separate direction GPIO is not supported by the two-pin reserve. Future UI and sensor growth shall first use the controlled I²C boundary and remaining expander capacity. UART0 GPIO43/44 remains the manufacturing/recovery resource. Wi-Fi, Bluetooth LE, and ESP-NOW require no external GPIO.

This reserve is architectural capacity only. It does not authorize CAN, RS-485, a transceiver, connector, or PCB circuitry in Rev A.

### Raw GPIO naming rule

Raw `GPIO<n>` names and processor pin numbers may appear only on Sheet 03 and its controlled allocation documentation. Every other schematic sheet shall use functional net names. A functional name has one owner even when its implementation later uses a bus expander rather than a direct processor pin.

## Status and reset ownership

| Signal or condition | Electrical owner | Functional owner | Route |
| --- | --- | --- | --- |
| `MAIN_INPUT_VALID` | Sheet 01 eFuse PGOOD; pull-up/qualification on Sheet 02 | Power-entry validity | Sheet 01 to Sheet 02 only |
| `MAIN_POWER_GOOD` | Sheet 02 | Qualified main-power state | Sheet 02 internal branch gating and Sheet 06 |
| `CORE_POWER_GOOD` | Sheet 03 TPS3890-Q1 supervisor | Local core-supervisor condition | Local to Sheet 03; not a hierarchical net |
| `RESET_VALID` | Sheet 03 supervisor/reset implementation | Timed core readiness | Sheet 03 to Sheet 06 |
| `POWER_FAULT_SUMMARY` | Sheet 01 eFuse diagnostic | Input-path fault diagnostic | Existing diagnostic/test route; not a Sheet 03 input |

Sheet 03 shall not recreate `MAIN_INPUT_VALID`, infer a substitute `POWER_FAULT_SUMMARY`, export `CORE_POWER_GOOD`, or consume `MAIN_POWER_GOOD`. Package 04R creates the local core-good condition and exports `RESET_VALID`.

## USB and recovery ownership

| Responsibility | Owner |
| --- | --- |
| ESP32 native USB PHY and GPIO19/20 | Sheet 03 |
| Processor-side 22 Ω tuning resistors | Sheet 03 |
| Processor-side ESD interface boundary | Sheet 03 |
| USB-C receptacle and external pinout | Sheet 09 |
| CC1/CC2 sink resistors | Sheet 09 |
| Connector-entry ESD and shield/chassis option | Sheet 09 |
| VBUS entry and protected-power handoff | Sheet 09 to Sheet 01 |
| GPIO0/EN local boot/reset support | Sheet 03 |
| External service controls and fixture contacts | Sheet 09 |
| UART0 GPIO43/44 processor connection | Sheet 03 |
| UART0 fixture access | Sheet 09 |

The final implementation shall contain one coordinated USB ESD strategy. “Processor-side ESD interface” defines the protected Sheet 03 data boundary; “connector-entry ESD” defines placement and surge-current ownership at Sheet 09. It does not authorize two redundant protectors on the same pair.

## Cross-sheet ownership

| Sheet | Exclusive ownership relevant to AR-02 |
| --- | --- |
| 01 | Raw/protected input power, USB protected-power entry, battery sense, `MAIN_INPUT_VALID`, `POWER_FAULT_SUMMARY` |
| 02 | Regulated rails, source selection, branch switches, request pull-downs and main-power qualification |
| 03 | ESP32 module, raw GPIO mapping, core supervisor/reset, native USB device pins, direct power requests, UART0 endpoint |
| 04 | Conditioned safety, command, encoder, and external-sense inputs; no raw GPIO names |
| 05 | Motor command electrical interfaces; no raw GPIO names |
| 06 | Master inhibit, watchdog, actuator authorization, relay control; no raw GPIO names |
| 07 | UI/peripheral implementation and the future I²C GPIO-expander block; no raw GPIO names |
| 08 | Expansion and future communications interface circuitry; no raw GPIO names |
| 09 | All connector symbols, connector-side USB/CC/shield, and fixture/test access; no raw GPIO names |

Detailed producer/consumer directions remain controlled by the hierarchy document and Sheet 00.

## Resource result

| Category | Count | Notes |
| --- | ---: | --- |
| Module GPIO brought out | 36 | GPIO0–21 and GPIO35–48 |
| Direct Rev A application signals | 26 | 22 original direct functions after five UI moves, plus four power requests |
| Native USB | 2 | GPIO19/20 |
| Boot recovery | 1 | GPIO0 |
| UART0 recovery/manufacturing | 2 | GPIO43/44 |
| Future communications pool | 2 | GPIO37/42 |
| Avoided application straps | 3 | GPIO3/45/46 |
| Unallocated and unreserved | 0 | Every brought-out GPIO has an explicit disposition |

The architecture is feasible for the Rev A baseline. Expansion margin is deliberately bounded: two direct pins are reserved as a mutually exclusive future pool, while UI/sensor growth uses I²C. Any requirement for simultaneous CAN and conventional three-wire RS-485, more direct expansion GPIO, or octal PSRAM requires resource reduction or a later hardware revision.

## Consequences

- Sheet 03 can implement all ADR-039 request outputs without duplicate pins or strap conflicts.
- The request outputs remain hardware-off through reset because Sheet 02 owns pull-downs and main qualification.
- Sheet 07 gains a future core-powered I²C GPIO-expander responsibility and must implement safe defaults.
- The root hierarchy must eventually remove the five direct Sheet 03 UI outputs and keep functional ownership local to Sheet 07 when that block is captured.
- Package 04R does not place the Sheet 09 USB-C connector or expose future communication pins.
- Exact expander selection, address, reset behavior, power budget, and bus-fault containment remain Sheet 07 release items.

## Verification

Before Sheet 03 peer-review completion:

- prove each direct GPIO appears once in the authoritative allocation;
- verify ESP32-S3-WROOM-1-N8 exposes GPIO35/36/37 and uses 3.3 V GPIO47/48;
- verify all four requests are low during power-up, reset, ROM bootloader, UART recovery, and native-USB recovery;
- verify Sheet 02 pull-downs and `MAIN_POWER_GOOD` gates override an unpowered or undefined processor;
- verify no raw GPIO name appears on Sheets 00–02 or 04–09;
- verify USB D+/D- polarity and one coordinated ESD boundary;
- verify local `CORE_POWER_GOOD` and exported `RESET_VALID` are not aliased; and
- rerun hierarchy and duplicate-allocation checks.

## Authorization

AR-02 closes the Package 04 architecture entry gate and authorizes:

**IPC-100 Rev A Preliminary KiCad Capture — Package 04R — Sheet 03 ESP32-S3 Core & Programming**

This authorization does not include Sheet 04, Sheet 07 circuitry, connectors, footprints, PCB layout, firmware, CAN, or RS-485 implementation.
