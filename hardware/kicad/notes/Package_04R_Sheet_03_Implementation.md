# Package 04R — Sheet 03 Implementation Review

## Status

**Entry-gate conflict resolved by Architecture Resolution Package AR-03 and ADR-041. Package 04R is authorized.**

AR-02 and ADR-040 resolve the four peripheral-power request outputs, the five UI functions moved behind I²C, the future two-pin reserve, USB ownership, and the meanings of the power-status signals. Package 04R correctly stopped when the retained `MAIN_POWER_GOOD` input had no GPIO or approved local consumer. AR-03 subsequently determined that firmware visibility provides no safety enforcement and is not required.

ADR-041 removes `MAIN_POWER_GOOD` from the Sheet 03 processor interface while preserving Sheet 02 branch gating and Sheet 06 actuator authorization. ADR-040's GPIO allocation and GPIO37/42 reserve remain unchanged. Sheet 03 remains circuitry-free pending the resumed Package 04R implementation.

## Confirmed implementation basis

The following Package 04R elements are authorized and ready after the narrow status-input issue is resolved:

- ESP32-S3-WROOM-1-N8;
- 22 µF effective bulk, 1 µF, and 100 nF local `+3V3_CORE` decoupling;
- no external crystal;
- EN with 10 kΩ pull-up, 1 µF timing capacitor, supervisor/reset pull-down, local RESET button, and functional fixture input;
- GPIO0 with 10 kΩ pull-up, local BOOT button, and functional fixture input;
- TPS3890-Q1 local core supervision, local `CORE_POWER_GOOD` semantic, and exported `RESET_VALID`;
- native USB on GPIO19 D- and GPIO20 D+ with preliminary 22 Ω processor-side series resistors and one coordinated TPD2EUSB30-class ESD boundary;
- UART0 recovery on GPIO43 TX and GPIO44 RX, without a connector on Sheet 03;
- GPIO35 `OLED_POWER_REQ`;
- GPIO36 `SENSOR_POWER_REQ`;
- GPIO40 `UI_POWER_REQ`;
- GPIO41 `EXPANSION_POWER_REQ`;
- GPIO37 and GPIO42 unconnected and reserved;
- all remaining conditioned-input, actuator-command, I²C, battery-sense, USB, UART, boot, and recovery assignments from ADR-040;
- no RGB, buzzer, OLED-reset, connector, peripheral, driver, footprint, or PCB implementation.

## Blocking conflict

### Frozen interface

ADR-039 and ADR-040 define:

| Signal | Sheet 03 relationship |
| --- | --- |
| `MAIN_POWER_GOOD` | Hierarchical input from Sheet 02 |
| `CORE_POWER_GOOD` | Local TPS3890-Q1 supervisor condition |
| `RESET_VALID` | Hierarchical output from Sheet 03 |
| `MAIN_INPUT_VALID` | Not routed to Sheet 03 |
| `POWER_FAULT_SUMMARY` | Not routed to Sheet 03 |

The existing Sheet 00/03 hierarchy includes `MAIN_POWER_GOOD`, consistent with those decisions.

### Frozen GPIO inventory

The ADR-040 table assigns or reserves all 36 module GPIOs:

- 26 application and power-request signals;
- GPIO19/20 native USB;
- GPIO0 boot recovery;
- GPIO43/44 UART0 recovery;
- GPIO37/42 future reserve;
- GPIO3/45/46 unused straps.

No row assigns `MAIN_POWER_GOOD`.

### Rejected implicit implementations

- **Use GPIO37 or GPIO42:** rejected because ADR-040 reserves both and Package 04R says not to consume them.
- **Duplicate an assigned GPIO:** rejected because Package 04R requires unique ADR-040 assignments.
- **Gate ESP32 EN with `MAIN_POWER_GOOD`:** rejected because USB-only power must support programming and recovery while main power is absent.
- **Alias it to `RESET_VALID` or local `CORE_POWER_GOOD`:** rejected because ADR-039 defines distinct source and core semantics.
- **Leave the port dangling:** rejected because Package 04R requires a complete processor subsystem and no unresolved exports.
- **Invent a latch, expander, ADC mux, or status gate:** rejected because none is approved for Sheet 03 and each changes resource, reset, or ownership behavior.

## Decision required

A controlled amendment must choose one disposition:

1. assign `MAIN_POWER_GOOD` to GPIO37 or GPIO42 and reduce the future reserve;
2. reallocate or offload another direct function and assign the released GPIO;
3. approve a defined non-GPIO Sheet 03 consumer with a documented functional purpose that preserves USB-only service;
4. remove `MAIN_POWER_GOOD` from Sheet 03 if the processor is not intended to observe it.

The amendment must update ADR-040, the authoritative GPIO table, the GPIO review, the hierarchy if applicable, reset/USB-only analysis, and the allocation validator.

## Reset and boot implications

The resolution shall preserve:

- USB-only native-USB and UART recovery;
- supervisor-controlled EN independent of main-source absence;
- four request outputs low during reset and bootloader;
- GPIO0, GPIO3, GPIO45, and GPIO46 strap behavior;
- unique GPIO assignments;
- GPIO37/42 reserve status unless explicitly revised; and
- Sheet 02 hardware gating of every power request with `MAIN_POWER_GOOD`.

## Validation performed

- Confirmed ADR-040 inventories all 36 brought-out GPIOs exactly once.
- Confirmed the authoritative table has no `MAIN_POWER_GOOD` assignment.
- Confirmed GPIO37 and GPIO42 are both reserved and Package 04R prohibits consuming them.
- Confirmed Sheet 00 and Sheet 03 still contain synchronized `MAIN_POWER_GOOD` ports.
- Confirmed `RESET_VALID` is an output and `CORE_POWER_GOOD` is local.
- Confirmed `MAIN_INPUT_VALID` and `POWER_FAULT_SUMMARY` are not Sheet 03 inputs.
- Confirmed Sheet 03 content was not modified.
- Did not run or claim KiCad ERC because no implementation was performed.

## Manual resolution checklist

- [ ] `MAIN_POWER_GOOD` MCU observability requirement explicitly confirmed or rejected.
- [ ] Unique electrical consumer assigned if retained.
- [ ] GPIO37/42 reserve impact approved.
- [ ] USB-only programming and recovery preserved.
- [ ] No aliasing of main-good, core-good, and reset-valid semantics.
- [ ] Authoritative 36-row GPIO table updated.
- [ ] Duplicate-allocation validator passes.
- [ ] Sheet 00/03 ports synchronized.
- [ ] Package 04R implementation authorization reissued.

## Package handoff

AR-03 closes the entry-gate blocker. Resume **IPC-100 Rev A Preliminary KiCad Capture Package 04R — Sheet 03 ESP32-S3 Core, Boot, Programming & Control Logic**. During that package, remove the obsolete Sheet 03 `MAIN_POWER_GOOD` hierarchy port while preserving Sheet 02-to-Sheet 06 routing.

Do not begin Sheet 04 or Package 05 until Sheet 03 implementation and review are complete.
