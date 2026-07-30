# Package 04 — Sheet 03 Implementation Entry-Gate Review

## Status

**Entry-gate conflict resolved by Architecture Resolution Package AR-02 and ADR-040. Package 04R is authorized.**

Package 04 correctly stopped before assigning processor pins or changing frozen cross-sheet interfaces beyond the authority of the accepted design. AR-02 subsequently approved the required GPIO and ownership amendment. Sheet 03 remains a circuitry-free placeholder pending Package 04R. No component, net, port, footprint, PCB object, or application circuit was added by the entry-gate package.

This stop preserves ADR-039, the approved GPIO review, and the single-owner schematic hierarchy. It is an interface and resource-allocation conflict, not a component-selection detail.

## Confirmed implementation basis

The following portions of the requested design are already approved and can be captured after the entry gate is resolved:

- ESP32-S3-WROOM-1-N8 preliminary-capture module;
- `+3V3_CORE` supply with 22 µF effective bulk, 1 µF, and 100 nF local decoupling;
- no external processor or RF crystal;
- EN with 10 kΩ pull-up, 1 µF to ground, manual reset control, and fixture access;
- GPIO0 with 10 kΩ pull-up, manual boot control, and fixture access;
- native USB Serial/JTAG on GPIO19 D- and GPIO20 D+;
- 22 Ω preliminary USB series resistors and TPD2EUSB30-class data ESD protection;
- UART0 recovery access on GPIO43 TX and GPIO44 RX;
- TPS3890-Q1 supervision of `+3V3_CORE`, producing the local `CORE_POWER_GOOD` condition and exported `RESET_VALID`;
- avoidance of GPIO3, GPIO45, and GPIO46 for application functions;
- the existing 27-signal proposed application allocation.

These selections remain preliminary and do not authorize footprints or PCB layout.

## Blocking conflict 1 — four request outputs have no approved GPIO allocation

ADR-039 adds these required active-high outputs:

- `OLED_POWER_REQ`
- `SENSOR_POWER_REQ`
- `UI_POWER_REQ`
- `EXPANSION_POWER_REQ`

ADR-039 explicitly requires the GPIO allocation to reserve four suitable non-strapping outputs before Sheet 03 release and explicitly does not assign those pins itself.

The controlled GPIO review assigns all 27 original application signals, plus fixed native USB, while preserving GPIO0, EN, and UART0 recovery. It identifies only GPIO37 as a conditional reserve. GPIO3, GPIO45, and GPIO46 are avoided strapping pins. GPIO19/20 are fixed USB pins. GPIO43/44 are reserved for recovery. No controlled amendment assigns the four new request signals.

Consequently, implementation would require at least one unapproved action:

1. duplicate an existing GPIO assignment;
2. remove or combine an approved application function;
3. consume recovery access;
4. use avoided strapping pins;
5. add an I/O expander or other architecture;
6. change the processor/module strategy.

Package 04 authorizes none of these decisions. The four request outputs therefore cannot be connected to the ESP32-S3 without violating the instruction to use the approved GPIO allocation and not assign new pins.

## Blocking conflict 2 — requested power-status inputs do not match the frozen hierarchy

The Package 04 request names `MAIN_INPUT_VALID`, `MAIN_POWER_GOOD`, `CORE_POWER_GOOD`, and `POWER_FAULT_SUMMARY` as Sheet 03 inputs. The accepted architecture and synchronized Sheet 00/03 contract provide a different boundary:

| Signal | Accepted owner and route | Sheet 03 disposition |
| --- | --- | --- |
| `MAIN_INPUT_VALID` | Sheet 01 to Sheet 02 only | Not a Sheet 03 port |
| `MAIN_POWER_GOOD` | Sheet 02 to Sheets 03 and 06 | Existing Sheet 03 input |
| `CORE_POWER_GOOD` | Local Sheet 03 supervisor semantic | Not a hierarchical port; feeds reset validity |
| `RESET_VALID` | Sheet 03 output | Existing exported timed core-readiness signal |
| `POWER_FAULT_SUMMARY` | Sheet 01 diagnostic output | Not routed to Sheet 03 by the frozen hierarchy |

Adding the absent ports would reinterpret ADR-039 and change Sheet 00. Generating substitute signals would also violate the accepted semantic ownership. Implementation must therefore retain local `CORE_POWER_GOOD`, export `RESET_VALID`, and consume only approved hierarchical inputs after the interface list is formally reconciled.

## Blocking conflict 3 — USB connector ownership

The accepted hierarchy makes Sheet 09 the sole owner of connector symbols and test access. Sheet 03 currently exchanges `USB_D+` and `USB_D-` with that sheet. Placing the USB-C receptacle on Sheet 03 would duplicate connector ownership and violate ODI-SCH-003.

The resolution must confirm that:

- Sheet 09 retains the USB-C receptacle, CC resistors, shield treatment, VBUS entry, and connector-side protection;
- Sheet 03 owns the ESP32 native-USB pins, processor-side series components, and any explicitly assigned local protection; and
- protection is not duplicated and the USB differential boundary is unambiguous.

## Decision required

Before Package 04R may begin, architecture review must approve one coherent amendment that:

1. assigns unique, module-compatible GPIOs to all four ADR-039 request outputs;
2. updates the complete allocation table and conflict analysis, not only Sheet 03;
3. demonstrates reset and bootloader low defaults for all four requests;
4. resolves any displaced application, recovery, or expansion functions;
5. confirms that `MAIN_INPUT_VALID` remains Sheet 01-to-02 only or formally changes its consumers;
6. confirms whether `POWER_FAULT_SUMMARY` is required at the processor and, if so, allocates both a hierarchy port and GPIO;
7. retains local `CORE_POWER_GOOD` and exported `RESET_VALID`, or formally supersedes ADR-039;
8. confirms the Sheet 03/09 USB and recovery ownership boundary.

Because these choices affect platform GPIO resources, boot safety, cross-sheet interfaces, and future product compatibility, they require a controlled allocation amendment and an accepted ADR or equivalent architecture-resolution package.

## Validation performed

- Confirmed the working tree was clean at Package 04 entry.
- Confirmed the accepted Sheet 00 and Sheet 03 ports remain synchronized.
- Confirmed no controlled document assigns GPIOs to the four ADR-039 request outputs.
- Confirmed the existing allocation consumes all common non-strapping application pins and preserves only conditional GPIO37.
- Confirmed `MAIN_INPUT_VALID` is contractually Sheet 01-to-02 only.
- Confirmed `CORE_POWER_GOOD` is a local Sheet 03 semantic and `RESET_VALID` is its exported readiness result.
- Confirmed Sheet 09 is the sole connector-symbol owner.
- Did not claim KiCad ERC because no schematic implementation was performed and KiCad ERC was not run.

## Manual resolution checklist

- [ ] Four unique request-output GPIOs approved.
- [ ] No duplicate GPIO assignments.
- [ ] Exact ESP32-S3-WROOM-1-N8 pin availability reverified.
- [ ] GPIO3, GPIO45, and GPIO46 strap policy preserved or formally revised.
- [ ] Native USB GPIO19/20 preserved.
- [ ] GPIO0/EN manual recovery preserved.
- [ ] UART0 GPIO43/44 recovery disposition approved.
- [ ] Every displaced application function explicitly dispositioned.
- [ ] Request outputs proven low through reset and bootloader.
- [ ] Power-status input list reconciled with ADR-039.
- [ ] Sheet 03 local supervisor and `RESET_VALID` semantics confirmed.
- [ ] Sheet 03/09 USB ownership confirmed.
- [ ] Sheet 00 and Sheet 03 ports synchronized after any approved amendment.
- [ ] Package 04R authorization recorded.

## AR-02 resolution

ADR-040 moves `RGB_R`, `RGB_G`, `RGB_B`, `BUZZER_OUT`, and `OLED_RESET` behind the Sheet 07 I²C functional boundary. It assigns GPIO35, GPIO36, GPIO40, and GPIO41 to `OLED_POWER_REQ`, `SENSOR_POWER_REQ`, `UI_POWER_REQ`, and `EXPANSION_POWER_REQ`, respectively. GPIO37/GPIO42 form a non-exported two-pin future pool.

It also confirms the ADR-039 status boundary: Sheet 03 consumes `MAIN_POWER_GOOD`, creates local `CORE_POWER_GOOD`, and exports `RESET_VALID`; neither `MAIN_INPUT_VALID` nor `POWER_FAULT_SUMMARY` becomes a Sheet 03 input. Sheet 09 retains all connector symbols, including USB-C and fixture access.

## Package handoff

Package 04R is authorized as **IPC-100 Rev A Preliminary KiCad Capture Package 04R — Sheet 03 ESP32-S3 Core, Programming, Recovery, and System Control**.

Do not begin Package 05 until Sheet 03 is implemented and reviewed.
