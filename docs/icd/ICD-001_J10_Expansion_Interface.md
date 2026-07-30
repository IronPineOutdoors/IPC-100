# ICD-001 — J10 Expansion Interface

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Revision | Rev A |
| Interface | J10 Expansion Port |
| Status | Accepted |
| Date | 2026-07-30 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose

J10 is an optional, main-powered, low-speed I²C accessory and engineering-service port for short wiring contained within the product enclosure. Its Rev A purpose is to support a deliberately approved low-power sensor, identification device, or service accessory without consuming another ESP32 GPIO.

J10 is not:

- an actuator command or safety interface;
- a RangeHub wired interface;
- a general outdoor field bus;
- a wireless-module interface;
- a production-programming or manufacturing-test port;
- a raw UART, SPI, USB, CAN, or RS-485 port; or
- a promise of compatibility with an unspecified daughterboard.

Wi-Fi, Bluetooth LE, and ESP-NOW remain processor-native functions and require no J10 circuitry. Future RangeHub, CAN, RS-485, long-cable, isolated, and outdoor-accessory concepts require a later controlled interface and are not Rev A J10 uses.

J10 is optional in Rev A. Sheet 08 interface circuitry may be captured as an unpopulated option. Population requires an approved accessory, power-budget allocation, Sheet 09 connector release, and verification against this ICD.

## 2. Signal Table

The released connector-level signal order is logical, not physical pin numbering. Sheet 09 shall assign physical pins after connector selection.

| Signal | Direction at IPC-100 | Voltage / levels | Producer | Consumer | Owner | Default, startup, and reset state | Maximum frequency | Termination / bias | Protection | Cable | Optional / Rev A population |
| --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- |
| `EXPANSION_VCC` | Power output | 3.3 V nominal; 3.0–3.45 V allowed at board boundary; 100 mA released maximum | Sheet 02 protected switch | Approved J10 accessory and Sheet 08 external-side bias | Sheet 02 power; Sheet 09 exposure | Off until `EXPANSION_POWER_REQ` and `MAIN_POWER_GOOD`; off in reset, bootloader, USB-only, brownout, invalid main, and inactive request | N/A | No remote regulation assumption | Sheet 02 current limiting; Sheet 08/09 coordinated ESD and reverse-injection containment | 0.30 m maximum | Optional; DNP unless accessory released |
| `GND` | Power/signal return | Logic ground; no protective-earth claim | IPC-100 ground system | Accessory | Sheet 09 connector/harness | Present whenever physically connected; shall mate before or with other contacts if a sequenced connector is selected | N/A | Low-impedance return paired with bus/power | Shield/chassis strategy below; no current through shield | 0.30 m maximum | Required whenever J10 populated |
| `J10_I2C_SDA` | Bidirectional open drain | External segment pulled to `EXPANSION_VCC`; VIL ≤0.3 VDD, VIH ≥0.7 VDD at released endpoints | Controller or addressed accessory through Sheet 08 segment buffer | Controller or accessory | Sheet 08 electrical boundary | High when released and powered; high impedance when expansion rail invalid, buffer disabled, IPC-100 off, or option DNP | 100 kHz standard mode | One 4.70 kΩ ±1% external-side pull-up owned by Sheet 08; no accessory pull-up permitted unless total equivalent remains 3.9–5.6 kΩ by review | Low-capacitance TVS, series damping/current limiting, segmented buffer | 0.30 m maximum, one accessory, no branch/stub >50 mm | Optional; DNP by default |
| `J10_I2C_SCL` | Output, open drain | Same as SDA | ESP32 controller through Sheet 08 segment buffer | J10 accessory | Sheet 08 electrical boundary | Same as SDA | 100 kHz standard mode | Same as SDA | Same as SDA | Same as SDA | Optional; DNP by default |

Clock stretching by a J10 accessory is prohibited in Rev A. This preserves the frozen `J10_I2C_SCL` output direction. The selected segment device may be electrically bidirectional, but no accessory may assert SCL.

GPIO37 is not assigned, routed, or reserved for J10. GPIO42 remains exclusively `WATCHDOG_SERVICE_MCU`.

## 3. Power

### 3.1 Source and budget

`EXPANSION_VCC` is the only J10 power source. It is the optional protected 3.3 V, main-qualified Sheet 02 branch defined by ADR-039:

- 100 mA maximum continuous current at the board boundary;
- 150 mA maximum startup current for no more than 10 ms;
- accessory input capacitance no greater than 22 µF;
- normal accessory load no greater than 75 mA, reserving 25 mA for tolerance, Sheet 08 bias/protection, and cable loss;
- minimum accessory operating voltage of 3.0 V;
- no operation from USB-only power; and
- no parallel feed from `+3V3_CORE`, another connector, battery, or an independently powered accessory.

The Sheet 02 switch remains sole owner of enable, current limit, and short-circuit recovery. Sheet 08 shall not add a parallel power switch. The exact Sheet 02 optional switch must be verified to support the limits above before J10 population.

### 3.2 Inrush and short behavior

The accessory shall meet the 150 mA/10 ms inrush envelope. Sheet 02 shall current-limit a short without collapsing `+3V3_CORE` or creating a main-power-valid false assertion. A persistent short may latch off or retry only according to the released Sheet 02 device behavior. Firmware shall not use automatic rapid cycling as a recovery mechanism.

### 3.3 Backfeed prevention

The accessory shall not source voltage or current onto `EXPANSION_VCC`, SDA, SCL, or GND. An independently powered accessory is prohibited in Rev A. Sheet 08 shall isolate both bus lines whenever `EXPANSION_VCC` is invalid and shall limit injection into `+3V3_CORE` to 10 µA maximum per signal in steady state. External-side pull-ups shall connect only to `EXPANSION_VCC`.

### 3.4 Grounding and shield

J10 uses IPC-100 logic ground and is non-isolated. Maximum steady ground offset is ±0.10 V; the cable shall not connect separate structures, batteries, or earth references. The preferred cable is four-conductor, with SDA paired with GND and SCL paired with `EXPANSION_VCC` or GND where geometry permits.

No shield is required inside a single enclosure at 0.30 m maximum. If a shielded cable is selected, Sheet 09 shall bond the shield at the IPC-100 enclosure/chassis entry only; the accessory end remains unconnected. Shield current shall not use logic ground. Use outside the enclosure requires a new ICD.

### 3.5 Sequencing

1. Main power becomes valid.
2. Firmware initializes the internal bus and keeps `EXPANSION_POWER_REQ` low.
3. Firmware asserts the request only for an approved accessory.
4. Sheet 02 establishes `EXPANSION_VCC`.
5. Sheet 08 waits until the external rail is at least 2.9 V for at least 5 ms, then enables the segment.
6. Firmware waits at least 10 ms after segment enable before the first transaction.
7. For shutdown, firmware stops transactions, disables the segment, waits at least 1 ms, then clears the power request.

Hardware shall force the segment disabled when the rail falls below 2.7 V, regardless of firmware.

## 4. Protection

Sheet 08 owns circuit-local protection between the internal and J10-side buses:

- a two-channel I²C-compatible hot-swap/segment buffer;
- fail-disabled enable bias;
- external-rail-valid enable qualification with 2.9 V minimum assertion and 2.7 V maximum deassertion thresholds;
- no false low pulse on connection or power sequencing;
- high impedance to both sides when disabled or unpowered;
- powered-off leakage meeting the 10 µA per-line backfeed limit;
- 4.70 kΩ ±1% external-side pull-ups to `EXPANSION_VCC`;
- 33–100 Ω series resistance per external line, selected by signal-integrity verification;
- low-capacitance TVS protection on the connector-facing side; and
- recovery or isolation so an external stuck-low line does not permanently hold the Sheet 07 internal bus low after the segment is disabled.

Sheet 07 retains the only base-bus pull-ups. Sheet 08 shall not add pull-ups to the internal side.

The connector-facing network shall meet IEC 61000-4-2 ±8 kV contact and ±15 kV air discharge at the enclosure-accessible connector in the released assembly. Because J10 is restricted to one enclosure and 0.30 m, IEC 61000-4-5 surge exposure is not claimed. Any routed outdoor or inter-enclosure use requires a new physical layer and surge contract.

TVS clamping, capacitance, series resistance, and buffer absolute-maximum ratings shall be coordinated. Protection current shall return locally toward the connector entry and shall not traverse the ESP32 or Sheet 07 bus area.

## 5. Physical Layer

Rev A J10 uses segmented 3.3 V, 100 kHz I²C only.

| Parameter | Requirement |
| --- | --- |
| Topology | One controller, one J10 accessory, point-to-point cable |
| Cable | 0.30 m maximum inside one enclosure |
| Branching | No daisy chain; no external branch; accessory stub ≤50 mm |
| Data rate | 100 kHz maximum |
| External segment capacitance | 100 pF maximum including connector, cable, protection, and accessory |
| Internal plus external interaction | Segment buffer prevents the external capacitance from consuming Sheet 07's internal 200 pF budget |
| Common mode | Logic ground, ±0.10 V maximum steady offset |
| Isolation | None; prohibited between separately powered structures |
| Pull-ups | Sheet 07 internal; Sheet 08 external; no duplicates |
| Connector | Four contacts minimum, polarized/keyed, locking, mis-mate resistant, signal/current/ESD capable; exact family and pin numbers owned by Sheet 09 |
| Cable routing | At least 50 mm from motor leads, relay wiring, and unshielded switching nodes where practical; no shared bundle with actuator power |

UART, CAN, RS-485, SPI, USB, and raw discrete GPIO are not present. A future long-cable interface shall use an appropriate differential transceiver and a new connector/ICD.

## 6. Hot Plug

Intentional live insertion or removal is prohibited in Rev A. The operator shall disable expansion power or remove main power before mating or unmating J10. Firmware shall provide an expansion-off service state.

The buffer and protection shall nevertheless tolerate accidental partial insertion without damage or back-power:

- ground should mate first and break last if the selected connector supports contact sequencing;
- no behavior depends on power mating before signals;
- signal-first or power-first partial insertion shall not connect the internal bus until rail qualification completes;
- the power contact shall tolerate accessory capacitance within the inrush envelope;
- a contact bounce or brownout shall disable the segment before the external rail becomes invalid;
- an unpowered accessory shall not be driven by the internal bus;
- an externally powered accessory is prohibited; and
- removal during traffic may create a failed transaction but shall not hold the internal bus after segment disable.

These protections are damage-containment measures, not authorization for routine hot-plug use.

## 7. I²C Contract

### 7.1 Ownership

- Sheet 03 owns the controller and GPIO47/48.
- Sheet 07 owns base-bus pull-ups and the internal 100 kHz/200 pF budget.
- Sheet 08 owns segmentation, rail qualification, external pull-ups, local protection, and external stuck-bus containment.
- Sheet 09 owns the connector, pin numbering, harness, shield termination, and field labels.

### 7.2 Address allocation

| Address | Allocation |
| --- | --- |
| `0x20` | Sheet 07 UI expander, preliminary fixed allocation |
| `0x3C`–`0x3D` | Reserved for OLED variants |
| `0x76`–`0x77` | Reserved for BME280 variants |
| `0x30`–`0x37` | J10 accessory allocation pool |
| All others | Unallocated; require controlled update |

An approved J10 accessory shall expose exactly one address from `0x30`–`0x37`. It shall not respond to any other address. Multiple J10 accessories and address multiplexing are prohibited in Rev A.

### 7.3 Recovery

Firmware shall:

1. time out a transaction within 25 ms;
2. attempt up to nine SCL recovery pulses while SDA is released;
3. issue STOP if SDA releases;
4. if recovery fails, disable the Sheet 08 segment;
5. verify the internal bus has recovered;
6. remove expansion power for at least 100 ms before one controlled retry; and
7. latch the accessory unavailable after two failed recovery cycles until an explicit service action or full power cycle.

Expansion failure is nonfatal to hardware safety. Firmware shall never block STOP handling, watchdog service, or hardware authorization while waiting for J10.

### 7.4 Clock stretching and loading

Clock stretching is prohibited. The accessory shall meet standard-mode I²C timing at 100 kHz with the released pull-up and 100 pF external capacitance limit without asserting SCL. Sheet 08 verification shall demonstrate compliant rise/fall times over resistor, voltage, temperature, TVS, buffer, connector, and cable tolerances.

## 8. Failure Modes

| Failure | Required behavior |
| --- | --- |
| SDA/SCL open or cable absent | Internal bus remains operational; accessory reports unavailable |
| SDA/SCL short to ground | Segment is disabled after timeout; internal bus recovers |
| SDA/SCL short to `EXPANSION_VCC` | No damage; accessory unavailable; internal bus remains isolated after disable |
| SDA/SCL short to adjacent contact | Current/protection limits prevent core damage; power fault may remove expansion rail |
| `EXPANSION_VCC` short | Sheet 02 limits/latches/retries per released part; core and actuator authorization remain unaffected |
| ESD | No unsafe output authorization; no permanent damage at stated IEC level after released assembly validation |
| Surge beyond ICD environment | Unsupported use; no compliance claim |
| Reverse or independent power | Prohibited; protection limits injection to specified leakage |
| Wrong/reversed connector | Keying prevents normal mis-mate; electrical fault shall not authorize outputs |
| Noise / false traffic | Address validation and firmware protocol reject unrecognized data; expansion remains non-safety |
| Stuck bus | Recovery sequence isolates and power-cycles accessory once, then latches unavailable |
| Water ingress | Enclosure/connector release must prevent conductive contamination; detected bus/power faults isolate expansion |
| Broken shield | No functional effect because shield is optional and not a signal return |
| Brownout | Segment disables below 2.7 V before undefined accessory drive can reach internal bus |
| Accessory crash | Timeout and segment recovery; no actuator authorization effect |
| Processor crash | Independent watchdog deauthorizes outputs; expansion rail request hardware remains main-qualified |

No J10 state, command, or failure can directly create `ACTUATOR_PERMIT`, suppress `MASTER_INHIBIT`, override `STOP_HW_INHIBIT`, spoof `WATCHDOG_VALID`, or energize relay/motor outputs.

## 9. Sheet Boundary

### Sheet 08 owns

- I²C segment/hot-swap buffer;
- hardware rail-valid and fail-disabled enable;
- external-side pull-ups;
- circuit-local TVS and series protection;
- internal logic conditioning;
- external stuck-bus containment;
- functional test-node definitions; and
- verification of power-off leakage and timing.

### Sheet 09 owns

- J10 connector symbol and physical pin numbering;
- connector family, keying, polarization, latch, and lifecycle;
- harness, conductor colors, length, routing, and field labels;
- connector-entry placement of coordinated protection;
- optional shield/chassis termination;
- enclosure exposure; and
- physical production-test pads or fixture access.

Sheet 02 retains expansion power switching/current limiting. Sheet 07 retains internal pull-ups. Sheet 03 retains controller ownership.

## 10. DFM

- Sheet 08 circuitry and J10 connector remain an explicit option code and DNP by default.
- Buffer, qualifier, TVS, and passives require orderable parts with automotive/industrial temperature ratings appropriate to the released environment.
- No unreviewed alternate buffer may be substituted; powered-off behavior and I²C offset compatibility are critical characteristics.
- External and internal bus sides require unambiguous net names and inspection access.
- Protection components shall be placed at the Sheet 09 connector boundary in final PCB planning while retaining Sheet 08 electrical ownership.
- Assembly documentation shall identify the supported J10 accessory address and option population.
- Connector selection must prevent reversal and cross-mating with higher-voltage IPC-100 connectors.

## 11. DFT

Preliminary capture shall define test nodes for:

- internal `I2C_SDA` and `I2C_SCL`;
- `J10_I2C_SDA` and `J10_I2C_SCL`;
- `EXPANSION_VCC`;
- segment enable/rail-valid; and
- buffer fault or isolation status if the selected device provides it.

Sheet 09 owns physical pads. Prototype and production tests shall verify:

- branch voltage/current limit and DNP state;
- enable/disable thresholds and timing;
- no USB-only expansion power;
- powered-off leakage/backfeed;
- internal-bus survival for external opens and shorts;
- address acceptance/rejection;
- 100 kHz timing at 100 pF external loading;
- recovery and one-cycle power retry;
- ESD at the released assembly level; and
- no effect on actuator authorization during every injected fault.

## 12. Future Compatibility

J10 preserves a bounded low-speed accessory option, not a universal expansion promise. A future revision may replace it with CAN, RS-485, an isolated bus, or a product-specific RangeHub interface only through a new allocation, ICD, connector contract, and safety review. GPIO37 remains available but uncommitted. Rev A accessories shall not depend on future GPIO or field-bus capability.

## 13. Rev A Scope

ICD-001 authorizes Package 09R preliminary Sheet 08 capture only for:

- the optional segmented 3.3 V/100 kHz J10 I²C interface;
- external-side pull-ups;
- rail-valid, fail-disabled segment control;
- circuit-local ESD and series protection;
- stuck-bus containment;
- schematic DFT nodes; and
- documentation of the DNP option.

It does not authorize Sheet 09 connector implementation, footprints, PCB layout, manufacturing, J10 population, an accessory, field testing, GPIO37, RangeHub wiring, CAN, RS-485, UART, SPI, USB, discrete GPIO, actuator/safety behavior, or ADR changes.

## 14. Final Decision

**ICD-001 ACCEPTED**

Package09R / Sheet08 / Expansion Interface is authorized only within the Rev A scope above.
