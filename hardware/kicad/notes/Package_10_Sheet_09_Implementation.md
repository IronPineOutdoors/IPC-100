# Package 10 — Sheet 09 External Connectors and Harness Interface

## 1. Status

Package 10 stopped before Sheet 09 modification because the frozen hierarchy and controlled connector documents do not contain a complete, non-conflicting connector contract.

The repository remains at the validated Package 09R baseline. Sheet 09 is still a component-free placeholder with 54 frozen hierarchical ports and zero footprint assignments.

This is a controlled implementation pause, not a connector release. No connector symbol, footprint, local net, hierarchy port, or schematic circuit was added.

## 2. Blocking Findings

### P10-F01 — J6/J7 shared-I²C route is absent

The accepted connector specification requires:

- J6 OLED: `OLED_VCC`, `GND`, `I2C_SDA`, `I2C_SCL`, `OLED_RESET`;
- J7 environmental sensor: `SENSOR_VCC`, `GND`, `I2C_SDA`, `I2C_SCL`.

Sheet 09 receives `OLED_VCC`, `SENSOR_VCC`, and `OLED_RESET`, but it does not receive the base-bus `I2C_SDA` or `I2C_SCL` nets. Those nets currently connect Sheet 03 to Sheets 07 and 08 only.

The only I²C pair reaching Sheet 09 is `J10_I2C_SDA` / `J10_I2C_SCL`. ICD-001 restricts that isolated segment to one approved J10 accessory in address range `0x30–0x37`. Reusing it for J6 or J7 would violate address, power, isolation, and ownership contracts.

Sheet 09 cannot create an unproduced local I²C net or add the missing hierarchy ports under Package 10.

**Classification:** Major / Blocking.

### P10-F02 — J8 physical safety partition is unresolved

J8 combines:

- the dedicated supervised NC STOP pair;
- ARM and FIRE commands;
- encoder inputs;
- RGB and buzzer outputs;
- 3.3 V and 5 V/UI power; and
- logic/UI return.

The connector architecture and ODI-CONN-001 leave the combined-versus-split decision open. Package 10 asks for an Emergency STOP group and a user-interface-panel group, but does not authorize a partition decision or new connector designation. Assigning a released pin order before deciding whether STOP is physically separate would freeze an unsupported harness architecture.

**Classification:** Major / Blocking.

### P10-F03 — J9 load and conductor contract is unresolved

J9 exposes isolated `RELAY_NC`, `RELAY_COM`, and `RELAY_NO`, but the switched voltage, continuous and inrush current, load type, fault energy, required isolation, life, applicable standard, and contact protection remain open. Without those values, Package 10 cannot truthfully define:

- current class;
- conductor gauge;
- insulation rating;
- connector spacing;
- touch safety;
- shield need; or
- field-replacement precautions.

J9 may serve a future thrower-trigger dry-contact function only after the consuming product validates the released relay contract. No net named `THROWER_TRIGGER` is authorized.

**Classification:** Major / Blocking.

### P10-F04 — J13 USB-C connector-entry contract is incomplete

The hierarchy provides `USB_VBUS_RAW`, `USB_D+`, and `USB_D-`, while Sheet 09 owns:

- the USB-C receptacle;
- CC1/CC2 sink resistors;
- connector-entry ESD;
- shield/shell treatment;
- chassis/enclosure coupling; and
- physical service access.

The exact CC implementation, single coordinated ESD topology, VBUS handoff details, shield coupling, enclosure exposure, and service retention contract remain unreleased. Package 10 prohibits introducing local nets or choosing a connector family, so a complete USB-C connector symbol and its required support cannot be captured without additional controlled detail.

**Classification:** Major / Blocking.

### P10-F05 — production fixture boundary is not released

Sheet 09 receives or produces the required recovery/test signals:

- `UART0_TX`, `UART0_RX`;
- `ESP_EN`, `ESP_BOOT`;
- `+3V3_CORE`, `GND`;
- `MAIN_POWER_GOOD`;
- protected source and core-source nodes;
- battery sense; and
- optional representative command/safety observations.

The hierarchy requires fixture access but does not release a fixture connector designation, contact count, voltage/back-drive limits, pin order, protection, or whether access is pads, pogo targets, a DNP header, or a service connector. Inventing J14 or folding these signals into J13 would alter the controlled connector scheme.

**Classification:** Major / Blocking.

### P10-F06 — connector and harness quantitative release remains incomplete

The connector family must remain unselected in this package, but several required pin-table fields still depend on missing electrical contracts. In particular:

- J1 current, fuse coordination, wire gauge, and source connector environment;
- J2/J3 external-driver module and protected 5 V branch compatibility;
- J6/J7 exact module pinouts and duplicate-pull-up policy;
- J8 RGB/buzzer load and physical partition;
- J9 contact load;
- J13 shell/shield implementation; and
- production fixture drive/backfeed limits.

Logical pin numbering can be preliminary, but it cannot be called a complete Rev A harness release while these values remain open.

**Classification:** Major / Blocking.

## 3. Connector Inventory

The controlled architecture reserves J1–J13. J11 and J12 are documentation-only reservations and shall have no Rev A connector symbol or pads.

| Designation | Function | Logical contacts/groups | Current hierarchy coverage | Protection owner | Package 10 disposition |
| --- | --- | ---: | --- | --- | --- |
| J1 | Battery/controller input | 2 | `VIN_RAW`; ground implicit | Sheet 01 | Capture possible after input-current/harness recommendation is released |
| J2 | Axis 1 external driver logic | 6 | Complete: supply plus four `_SAFE` commands; ground implicit | Sheets 02/05; connector entry coordinated on 09 | Logical contract available; exact module/harness validation open |
| J3 | Axis 2 external driver logic | 6 | Same as J2 | Sheets 02/05; 09 boundary | Same |
| J4 | Left/right supervised limits | 4 | Complete individual raw/return pairs | Sheet 04 | Logical contract available; physical family open |
| J5 | Up/down supervised limits | 4 | Complete individual raw/return pairs | Sheet 04 | Logical contract available; physical family open |
| J6 | OLED | 5 | Missing SDA/SCL route | Sheet 07; 09 connector entry | Blocked by P10-F01 and exact module |
| J7 | BME280/environment sensor | 4 | Missing SDA/SCL route | Sheet 07; 09 connector entry | Blocked by P10-F01 and exact module |
| J8 | STOP, controls, encoder, RGB, buzzer | 14 logical if combined | Electrical signals present | Sheets 04/07 | Blocked by P10-F02 and load/partition release |
| J9 | Isolated relay contacts / possible product trigger | 3 | Complete passive contacts | Sheet 06; load protection external/product | Blocked by P10-F03 |
| J10 | Restricted local expansion | 4 | Complete ICD-001 signals; ground implicit | Sheets 02/08; 09 connector entry | Electrical contract complete; connector family still pending |
| J11 | Spare GPIO concept | None released | No ports, GPIO37 reserved | None | No Rev A connector |
| J12 | Future CAN/RS-485 concept | None released | No ports | None | No Rev A connector |
| J13 | USB-C service | USB 2.0 groups | VBUS and D+/D− present; local CC/shield detail open | Sheets 01/03/09 | Blocked by P10-F04 |
| Fixture | UART/reset/boot/diagnostics | TBD | Signals present; access medium absent | Sheets 03/09 | Blocked by P10-F05 |

Planned physical connector symbols if all blockers are resolved: J1–J10 and J13, for **11 populated-or-DNP connector designations**. J11/J12 remain documentation-only. The fixture may use test pads rather than an additional connector and is not included in the connector count until its access contract is approved.

## 4. Frozen Sheet 09 Signal Inventory

Sheet 09 has 54 hierarchy ports.

### Connector-facing power and signals

| Destination | Frozen nets |
| --- | --- |
| J1 | `VIN_RAW` |
| J2 | `MOTOR_LOGIC_5V_A`, `AXIS1_RPWM_SAFE`, `AXIS1_LPWM_SAFE`, `AXIS1_REN_SAFE`, `AXIS1_LEN_SAFE` |
| J3 | `MOTOR_LOGIC_5V_B`, `AXIS2_RPWM_SAFE`, `AXIS2_LPWM_SAFE`, `AXIS2_REN_SAFE`, `AXIS2_LEN_SAFE` |
| J4 | `LIMIT_LEFT_RAW`, `LIMIT_LEFT_RETURN`, `LIMIT_RIGHT_RAW`, `LIMIT_RIGHT_RETURN` |
| J5 | `LIMIT_UP_RAW`, `LIMIT_UP_RETURN`, `LIMIT_DOWN_RAW`, `LIMIT_DOWN_RETURN` |
| J6 | `OLED_VCC`, `OLED_RESET`; missing base SDA/SCL |
| J7 | `SENSOR_VCC`; missing base SDA/SCL |
| J8 | `+3V3_CORE`, `UI_VCC`, `STOP_IN_RAW`, `STOP_RETURN`, `ARM_IN_RAW`, `FIRE_IN_RAW`, `ENCODER_A_RAW`, `ENCODER_B_RAW`, `ENCODER_SW_RAW`, `RGB_R`, `RGB_G`, `RGB_B`, `BUZZER_OUT` |
| J9 | `RELAY_NC`, `RELAY_COM`, `RELAY_NO` |
| J10 | `EXPANSION_VCC`, `J10_I2C_SDA`, `J10_I2C_SCL` |
| J13 | `USB_VBUS_RAW`, `USB_D+`, `USB_D-` |

Ground/return contacts that are global or internal to the connector boundary do not appear as Sheet 00 hierarchy ports.

### Test-only or production-access candidates

`+5V_MAIN`, `VIN_PROTECTED`, `USB_5V_PROTECTED`, `CORE_SOURCE`, `BATTERY_SENSE`, `MAIN_POWER_GOOD`, `UART0_TX`, `UART0_RX`, `ESP_EN`, and `ESP_BOOT` are not new field connectors. They require a controlled test-access plan.

## 5. Preliminary Pin Tables

These tables record the existing logical contracts and are not released physical pinouts.

### J1 — battery/controller input

| Logical pin | Signal | Direction | Domain/current | Default | Protection owner |
| ---: | --- | --- | --- | --- | --- |
| 1 | `VIN_RAW` | Power in | 9–21 V; controller input current TBD | Source absent = off | Sheet 01 |
| 2 | `GND` | Return | Power return; no motor current | N/A | Ground architecture / Sheet 01 |

### J2/J3 — motion driver logic

Each connector contains protected 5 V logic power, logic ground, RPWM, LPWM, REN, and LEN. Commands are 5 V active-high, ≤2 mA loads, 10–25 kHz for PWM, and default inactive/disabled. Sheet 05 owns damping, defaults, translation, and hardware authorization. Motor power and motor return are prohibited on these connectors.

### J4/J5 — supervised limit harnesses

Each four-contact group contains two individually returned, normally-closed, 2.20 kΩ EOL-supervised dry-contact loops. Opening or invalid supervision is conservative. Sheet 04 owns excitation, thresholds, filtering, ESD/transient handling, diagnostics, and safe interpretation. Maximum harness is 10 m / 2 nF under ADR-042.

### J6/J7 — peripheral modules

J6 logically requires `OLED_VCC`, `GND`, base SDA, base SCL, and `OLED_RESET`. J7 logically requires `SENSOR_VCC`, `GND`, base SDA, and base SCL. Physical pin numbering is blocked because the base-bus nets are absent from Sheet 09 and exact modules are not released.

### J8 — panel and STOP

The 14-contact combined concept is:

1. logic/UI ground;
2. `+3V3_CORE`;
3–5. encoder A, B, and switch raw contacts;
6–7. ARM and FIRE raw commands;
8–9. dedicated STOP return and STOP raw loop;
10–13. RGB R/G/B and buzzer outputs;
14. `UI_VCC`.

This ordering is not released. The STOP pair must remain dedicated and must not share a return with UI functions. A split STOP/UI implementation requires controlled connector designations and hierarchy documentation.

### J9 — relay contacts

The existing logical order is NC, COM, NO. The de-energized platform-safe contact state is NO open; it is not a product-level safety claim. Gauge/current/voltage/shield guidance remains blocked by P10-F03.

### J10 — ICD-001 expansion

The logical contract is `EXPANSION_VCC`, `GND`, `J10_I2C_SDA`, `J10_I2C_SCL`: 3.3 V, 100 mA maximum, 100 kHz, one accessory, 0.30 m maximum, no clock stretching, no intentional hot plug. Sheet 08 owns segment protection; Sheet 09 owns the connector and harness.

### J13 — USB-C service

USB-C USB 2.0 device mode carries protected VBUS handoff, D+/D−, ground, CC sink termination, and shell/shield. Native USB is the normal programming/service path. Complete physical capture remains blocked by P10-F04.

## 6. Harness Philosophy

Planned harness identifiers are `H01` through `H10` matching J1–J10, plus `H13` for USB/service. J11/J12 have no Rev A harness.

When released, every harness record shall include:

- IPC-100 revision and mating connector designation;
- end-A/end-B labels and orientation;
- conductor count and unused-contact disposition;
- conductor gauge, insulation temperature/voltage, flex class, and color;
- maximum length and routing class;
- twisted-pair and shield requirements;
- strain relief at board/enclosure and remote end;
- minimum bend radius from the selected cable datasheet, never less than 6× cable outside diameter unless explicitly rated;
- 50–100 mm service loop where enclosure space and safety permit;
- keying/polarization and latch inspection;
- ingress/sealing owner;
- continuity, insulation, hipot where applicable, and pin-to-pin test record; and
- field-replacement part number and compatibility record.

Preliminary color recommendations:

- red: positive low-voltage power;
- black: power/logic ground;
- white with unique tracers: safety loop outbound conductors;
- white/black tracers: dedicated safety returns;
- yellow: PWM/command outputs;
- blue/green: I²C SDA/SCL;
- orange: relay common/load circuit only after rating release;
- drain/bare: shield drain, never a signal return.

Colors are recommendations, not released manufacturing requirements.

Twisted-pair recommendations:

- each supervised safety outbound/return pair: required;
- J10 SDA/GND and SCL/power-or-ground geometry: required by ICD-001 where cable construction permits;
- USB D+/D−: controlled USB differential pair;
- each motor PWM/logic return pairing: recommended in noisy harnesses;
- encoder A/B with ground reference: recommended;
- relay contacts: based on released load; segregate from logic.

## 7. Grounding Notes

- `GND` is common logic/interface return and is not chassis or protective earth.
- J1 power return shall not carry product motor current.
- J2/J3 returns carry only driver-interface logic current, never motor current.
- STOP and limit returns are individually routed supervised-loop conductors, not generic panel ground.
- Relay contacts are galvanically isolated from logic ground unless the external product intentionally connects them.
- Cable shields are not signal returns.
- For short in-enclosure J10 wiring, no shield is required. If used, ICD-001 requires IPC-100-side chassis/enclosure bond only.
- USB shell/shield coupling must be released with the enclosure/chassis strategy.
- Connector shells remain floating unless a specific chassis-bond network is approved.

Package 10 does not redesign or create a chassis domain.

## 8. Protection Ownership

| Interface | Functional protection owner | Sheet 09 responsibility |
| --- | --- | --- |
| J1 input | Sheet 01 reverse polarity, fuse/eFuse, TVS, filter, battery sense | Connector-entry geometry, pinout, harness/source coordination |
| J2/J3 motion logic | Sheet 02 current-limited logic rail; Sheet 05 translation/defaults/damping/ESD provisions | Connector placement and coordinated entry protection; no duplicates |
| J4/J5/STOP/ARM/FIRE | Sheet 04 | Connector/harness only; preserve dedicated returns |
| Encoder/RGB/buzzer/OLED reset | Sheet 07 | Connector/harness entry and final ESD placement coordination |
| J6/J7 I²C | Sheet 07 base bus, but external segmentation/protection contract unresolved | Cannot capture until P10-F01 resolved |
| J9 contacts | Sheet 06 coil/authorization; switched-load protection belongs to consuming product unless later assigned | Isolation spacing and connector rating after load release |
| J10 | Sheet 02 power and Sheet 08 isolation/filtering/TVS provisions | Connector, harness, and protection placement per ICD-001 |
| J13 VBUS/data | Sheets 01/03 plus coordinated Sheet 09 connector-entry strategy | CC, receptacle entry ESD, shell/shield, service opening |
| Fixture | Owning functional sheet for each node | Access medium, back-drive limits, and fixture protection after release |

No protection circuit shall be duplicated merely because the signal reaches Sheet 09.

## 9. Service Strategy

- J13 native USB is the primary field/service programming interface.
- UART0 plus EN/BOOT is the independent factory/recovery path.
- Factory fixtures must not energize main-only rails or back-power an unpowered IPC-100 through UART, EN, BOOT, or test nodes.
- Main-power, core-power, reset, STOP/inhibit, one representative motor path, relay command/drive, and expansion isolation require prototype or production access as defined by MFG-01.
- Field-replaceable harnesses require keyed connectors, labels at both ends, compatibility part numbers, and power-off mating instructions.
- J10 intentional live mating is prohibited.
- Relay-load service requires an external energy-isolation procedure after its load class is released.
- USB service must not authorize main-powered outputs.

## 10. Manufacturing Considerations

Before connector footprint assignment:

1. select connector families and compatible wire-side components;
2. release contact ratings and derating;
3. verify keying prevents hazardous cross-mating;
4. complete J8 partition and J6/J7 routing decisions;
5. release harness wire/cable constructions;
6. define shield/chassis termination and enclosure penetrations;
7. complete mating-cycle, retention, vibration, and ingress requirements;
8. define crimp tooling, pull-test, inspection, and continuity-test requirements;
9. release service and production fixture access;
10. perform creepage/clearance analysis for J9 from the actual load contract.

No specific connector family or footprint is selected by this record.

## 11. Narrow Resolution Required

Package 10R should be authorized only after an interface-resolution package:

1. decides whether J6/J7 are external modules or on-board populations;
2. if external, defines protected/segmented J6/J7 bus paths and adds exact Sheet 07-to-09 hierarchy ports without reusing J10;
3. resolves combined versus split J8 and assigns stable designations/pin counts;
4. releases the J9 contact voltage/current/load/isolation contract;
5. releases J13 CC, ESD, VBUS, shield, and service-access implementation;
6. releases the UART/EN/BOOT manufacturing-access medium and back-drive limits; and
7. establishes quantitative harness recommendations sufficient for the required pin tables.

This should be a narrow connector/interface resolution, not a change to GPIO, safety, watchdog, motion, expansion, or power architecture.

## 12. Validation

Repository validation at the pause point shall confirm:

- the 54-port Sheet 09 hierarchy remains unchanged;
- Sheet 09 contains no component symbols or footprints;
- GPIO allocation is unchanged;
- GPIO37 remains reserved;
- GPIO42 remains exclusively `WATCHDOG_SERVICE_MCU`;
- ICD-001 and Package 09R remain intact;
- references and UUIDs remain unique;
- Sheets 00–08 are unchanged by Package 10; and
- repository structural validation passes.

Native ERC remains pending because `kicad-cli` is unavailable. No new Sheet 09 circuitry exists to check.

## 13. Remaining Release Gates

- Resolve P10-F01 through P10-F06.
- Complete Package 10R Sheet 09 capture.
- Select exact connector families and footprints in a separately authorized package.
- Complete exact module, load, current, gauge, cable, environmental, and service contracts.
- Run native ERC and full schematic design review.
- Close MFG-01 connector, fixture, assembly, and PCB-entry findings.
- Release mechanical envelope, connector access, and antenna constraints.
- Do not begin footprint assignment, PCB placement, or routing before those gates.

## 14. Manual Review Checklist

- [x] Existing 54 ports inventoried.
- [x] J1–J13 controlled designations reviewed.
- [x] J11/J12 retained as documentation-only with no connector claim.
- [x] J10 remains restricted by ICD-001.
- [x] GPIO37 remains unconsumed.
- [x] GPIO42 remains watchdog-only.
- [x] No new logic, bus, power rail, safety role, or signal owner proposed.
- [x] Protection owners mapped.
- [x] Ground, shield, service, and harness principles documented.
- [x] Exact blockers and narrow resolution identified.
- [x] Sheet 09 left unmodified.
- [x] No connectors, footprints, placement, or routing added.
- [ ] J6/J7 bus route released.
- [ ] J8 partition released.
- [ ] J9 load contract released.
- [ ] J13 connector-entry contract released.
- [ ] Factory fixture contract released.
- [ ] Package 10R authorized and implemented.

## 15. Readiness Decision

**PACKAGE 10 / SHEET 09 REMAINS BLOCKED**

IPC-100 is not yet ready for complete schematic review because the final connector sheet cannot be captured from the frozen hierarchy without the narrow interface resolutions above.
