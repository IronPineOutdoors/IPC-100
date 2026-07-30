# Package 09 — Sheet 08 Entry-Gate Review

## 1. Executive Summary

Package 09 reviewed the frozen IPC-100 Rev A architecture and hierarchy for Sheet 08, Expansion and Future Interfaces. No conflict exists in implemented Sheets 00–07, GPIO allocation, or safety ownership. The review did not find a complete electrical contract from which Sheet 08 circuitry can be captured.

The current boundary represents one proposed optional J10 I²C path. It provides the internal core bus, core logic power, optional main-qualified expansion power, and two J10-side bus nets. It does not authorize CAN, RS-485, UART, SPI, discrete expansion, RangeHub wiring, a daughterboard, accessory identification, or GPIO37 use.

J10 remains blocked by unresolved cable, protection/segmentation, hot-plug, backfeed, address, power, and connector contracts. Selecting a buffer, switch, isolator, ESD network, or direct connection now would invent behavior. No schematic was modified.

## 2. Sheet 08 Intended Role

Frozen documents limit Sheet 08 to:

- possible internal conditioning, isolation, or protection for J10 I²C;
- `+3V3_CORE` consumption for released internal logic;
- optional `EXPANSION_VCC` consumption at an approved accessory boundary;
- translation between internal I²C and J10-side nets after contract release; and
- documentation-only reservation of future communications concepts.

Sheet 08 does not own connectors, pin numbering, harness labels, shields, power switching, processor pins, actuator authorization, safety inputs, motor/relay control, or watchdog behavior.

## 3. Current Interface Inventory

| Signal | Direction | Producer / consumer | Domain | State contract | Optional / processor / safety | Sheet 09 |
| --- | --- | --- | --- | --- | --- | --- |
| `+3V3_CORE` | Input | Sheet 02 / possible internal Sheet 08 logic | 3.3 V core | Available from valid main or USB; no Sheet 08 load authorized | Required provision / no / no | No |
| `EXPANSION_VCC` | Input | Sheet 02 / possible J10 boundary | 3.3 V main-qualified switched, 100 mA max | Off at startup, reset, USB-only, brownout, invalid main, inactive request, or DNP switch | Optional / indirect request / no | Yes only if J10 released |
| `I2C_SDA` | Bidirectional | Sheet 03 controller and addressed devices / Sheets 07–08 | 3.3 V open-drain | Sheet 07 4.70 kΩ pull-up; controller high-Z during reset | Required bus / GPIO47 / no | No |
| `I2C_SCL` | Bidirectional | Sheet 03 controller and possible clock-stretching devices / Sheets 07–08 | 3.3 V open-drain | Sheet 07 4.70 kΩ pull-up; controller high-Z during reset | Required bus / GPIO48 / no | No |
| `J10_I2C_SDA` | Bidirectional | Undefined Sheet 08 stage and J10 accessory | Undefined | Voltage, bias, power-off, and disconnected state undefined | Optional placeholder / indirect / no | Yes |
| `J10_I2C_SCL` | Output | Undefined Sheet 08 stage / J10 accessory | Undefined | Voltage, bias, power-off, and clock-stretch policy undefined | Optional placeholder / indirect / no | Yes |

There are no duplicate producers and root/child directions match. The J10-side nets have no implemented source or conditioning circuit. Their voltage, pull-up ownership, power-off behavior, and SCL direction are undocumented. No Sheet 08 port exists for GPIO37, CAN, RS-485, UART, SPI, RangeHub, accessory identity, faults, or transceiver control. `+3V3_CORE` is an internal-logic provision, not authorization to expose core power.

## 4. GPIO Capacity Review

- GPIO37 remains the sole future reserve and is unconnected in Rev A.
- GPIO42 remains exclusively `WATCHDOG_SERVICE_MCU`.
- GPIO47/48 own I²C; GPIO35/36/40/41 own the four power requests.
- GPIO19/20 remain USB, GPIO43/44 UART0 recovery, GPIO0 boot recovery, and GPIO3/45/46 unused application straps.
- No allocation is duplicated and no raw GPIO appears on Sheet 08.

A released I²C boundary needs no new GPIO. Conventional CAN, direction-controlled RS-485, spare UART, and separate enable/fault signals are unsupported. GPIO37 shall not be consumed.

## 5. Shared-Bus Ownership

| Property | Released internal contract | External status |
| --- | --- | --- |
| Controller | ESP32-S3 Sheet 03, GPIO47/48 | No additional controller |
| Electrical owner | Sheet 07 base bus | Sheet 08 must not duplicate base pull-ups |
| Pull-ups | 4.70 kΩ ±1% to `+3V3_CORE` | External-side bias undefined |
| Speed / capacitance | Preliminary 100 kHz / ≤200 pF total | Cable/accessory allocation unreleased |
| Series/ESD | No Sheet 08 network released | Requires cable and exposure contract |
| Existing addresses | UI expander preliminary `0x20`; OLED and BME280 addresses require module release | No external reserved range |

Address-space availability alone does not prove compatibility. Direct external I²C is not approved: an outdoor cable adds capacitance, ESD/surge, common-ground dependence, stuck-bus risk, hot-plug transients, and unpowered-device leakage. Selecting a buffer, switch, isolator, or alternate physical layer requires cable length, data rate, ground-offset, power, and recovery requirements.

No accepted Sheet 08 SPI, UART, USB, diagnostic serial, CAN, or RS-485 bus exists.

## 6. Expansion Power Review

Sheet 02 exclusively owns `EXPANSION_VCC` switching/protection:

- 3.3 V from `+3V3_CORE`, 100 mA maximum, optional/DNP;
- active-high `EXPANSION_POWER_REQ` from Sheet 03;
- 100 kΩ request pull-down and `MAIN_POWER_GOOD` qualification;
- off during startup, reset, bootloader, USB-only, brownout, invalid main, or inactive request.

Sheet 08 may not create a parallel switch. Accessory inrush, cable drop, short energy, reverse injection, discharge, external powering, and total load are not closed. The 100 mA allocation is not proof that a proposed accessory is supported.

## 7. Communications Suitability

| Candidate | Rev A disposition |
| --- | --- |
| Wi-Fi, Bluetooth LE, ESP-NOW | Existing processor-native capability; no Sheet 08 circuit |
| J10 I²C | Proposed but blocked by external electrical contract |
| Raw UART / SPI | Not authorized; unsuitable over undefined outdoor cable |
| CAN / RS-485 | Documentation-only future concepts; no allocation or transceiver contract |
| Discrete trigger/status | Not authorized; no ownership, polarity, default, or GPIO |
| Daughterboard/accessory controller | Deferred; electrical, mechanical, power, identity, and service contracts absent |

Any future field bus needs a proper physical layer with released common-mode, termination, bias, surge/ESD, cable, shielding, unpowered-node, and data-rate requirements.

## 8. RangeHub/Future Integration Assessment

No accepted document creates a wired RangeHub interface in Rev A. Product-family integration may use existing Wi-Fi, Bluetooth LE, or ESP-NOW subject to later firmware/product requirements. RangeHub wiring, CAN, RS-485, wired accessory control, and daughterboards remain documentation-only concepts.

## 9. Safety Boundary Review

Sheet 08 has no path to `ACTUATOR_PERMIT`, `MASTER_INHIBIT`, `STOP_HW_INHIBIT`, `WATCHDOG_VALID`, relay authorization, motor enables, or safe motor commands. Expansion data can only become a firmware request and cannot bypass hardware authorization. A disconnected, shorted, stuck, corrupt, or noisy interface must not energize an actuator. A stuck I²C bus may impair UI/sensors but cannot alter hardware STOP, watchdog, main-power, or authorization.

## 10. Sheet 09 Boundary

Sheet 08 may eventually own internal buffers/transceivers, conditioning, circuit-local protection, and internal schematic test nodes. Sheet 09 exclusively owns connectors, pin numbering, harness labels, connector family/keying/retention, shield/chassis bonding, service exposure, and physical test contacts.

The only candidate Sheet 08 exports are `J10_I2C_SDA` and `J10_I2C_SCL`. `EXPANSION_VCC` is independently routed from Sheet 02 to the Sheet 09 placeholder and may be exposed only by a released J10 contract. Ground must be explicit in that connector contract.

## 11. DFM/DFT Requirements

If J10 is authorized, test coverage must include expansion-rail voltage/current/rise/discharge/fault response, internal and external SDA/SCL, buffer enable/fault, isolation supplies, bus bias/termination, accessory detection, and external power-good where adopted. Sheet 08 may define internal schematic nodes; Sheet 09 owns physical pads and fixture contacts. Manufacturing tests must cover backfeed, current limit, short recovery, bus isolation/recovery, address configuration, unpowered accessories, and optional population. No footprint is authorized.

## 12. Failure-Mode Review

| Condition | Effect and back-power risk | Authorization effect | Disposition |
| --- | --- | --- | --- |
| Reset / firmware crash | Request low; controller high-Z; bus may remain stuck | Watchdog independently deauthorizes crash | Architecture safe; bus recovery open |
| USB-only | Core may be powered; expansion rail off | `MAIN_POWER_GOOD` false | Prevent core-to-external backfeed |
| Brownout / rail off | Expansion rail collapses | Main loss deauthorizes | Sequencing/discharge open |
| Accessory powered, IPC-100 off | SDA/SCL injection may phantom-power core | Must not authorize | Blocking |
| IPC-100 powered, accessory off | Pull-ups may inject accessory clamps | No direct authorization | Blocking |
| Cable open | Internal bus must remain usable | No direct authorization | Segmentation proof required |
| Cable short / line stuck low | Direct path can disable all internal I²C | Hardware authorization unchanged | Blocking |
| Signal short to power/ground | Overvoltage, backfeed, or bus loss | No direct authorization | Protection contract required |
| Line stuck high / noise traffic | Communication failure or false messages | Firmware-only request | Timeout/recovery required |
| Buffer failure | Undefined before topology selection | Must remain nonauthorizing | Analyze after selection |
| ESD/surge | Core upset/damage possible | Must not defeat hardware safety | Exposure profile required |
| Reversed connector | Power/signal cross-coupling | Must remain nonauthorizing | Keying/miswire contract required |
| Address conflict | Contention/wrong-device access | No direct authorization | Address policy required |
| Missing field-bus bias/termination | Applies only to future bus | No direct authorization | Future contract |
| Ground offset | I²C failure/overstress | No direct authorization | Common-mode contract required |

## 13. Open Questions

1. Is J10 required in Rev A or documentation-only?
2. What cable length, topology, capacitance, speed, and outdoor EMC profile apply?
3. Is hot-plug prohibited, supported, or allowed only while off?
4. Can the accessory be independently powered, and what ground offset is allowed?
5. Must J10 faults leave the internal UI/sensor bus operational?
6. Is clock stretching supported, requiring bidirectional J10 SCL?
7. Who owns external pull-ups, and to which rail?
8. What addresses are released for OLED, BME280, expander, and accessories?
9. Does the 100 mA budget support load, inrush, and cable drop?
10. What connector, shield, keying, reversal, and harness contract will Sheet 09 release?

## 14. Blocking Findings

| ID | Class | Finding / exact missing contract | Disposition |
| --- | --- | --- | --- |
| P09-F01 | Major | J10 lacks cable, topology, capacitance, speed, voltage, ground-offset, clock-stretching, pull-up, segmentation, and recovery requirements | Blocking |
| P09-F02 | Major | Independently powered/unpowered nodes, hot-plug, backfeed, stuck-bus isolation, ESD/surge/miswire, and protection coordination are undefined | Blocking |
| P09-F03 | Major | Accessory load/inrush/short/discharge, pinout, ground/shield, keying, connector family, and population are unreleased | Pending Connector Release |
| P09-F04 | Minor | Device addresses, external reserved range, conflict detection, and recovery are unreleased | Blocking |
| P09-F05 | Observation | Future wired communications lack GPIO, physical-layer, power, connector, and firmware contracts | Deferred to Rev B |
| P09-F06 | Observation | Native KiCad ERC is unavailable; no schematic changed | Pending Native ERC |

## 15. Authorized Implementation Scope

No Sheet 08 circuit implementation is authorized.

The narrowest resolution is a J10 interface-control decision that:

1. decides whether J10 is populated in Rev A;
2. releases its cable, electrical, hot-plug, power, address, and recovery contract;
3. selects direct, buffered, switched, isolated, or alternate transport from that contract;
4. defines Sheet 08 versus Sheet 09 protection/test ownership;
5. confirms no GPIO37 use and no safety role; and
6. changes hierarchy only if the released physical layer requires it.

If J10 is removed from Rev A, Package 09 may intentionally leave Sheet 08 documentation-only. CAN, RS-485, RangeHub wiring, UART, SPI, daughterboards, accessory identity, and discrete expansion remain outside this resolution.

## 16. Final Decision

**PACKAGE 09 / SHEET 08 REMAINS BLOCKED**

This applies only to preliminary capture. It does not change ADR-039 through ADR-044 or authorize connectors, footprints, PCB layout, manufacturing, field testing, MFG-01 closure, GPIO37 consumption, or unspecified expansion.
