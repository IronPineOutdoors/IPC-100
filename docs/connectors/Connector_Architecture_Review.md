# IPC-100 Connector Architecture Review

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Purpose | Review preliminary connector allocation, safety partitioning, harness risks, and unresolved contracts |
| Status | Architecture review |
| Owner | Iron Pine Outdoors Engineering |

## 1. Review basis

Connector identifiers and pin counts remain preliminary unless explicitly locked in the [Connector Specification](Connector_Specification.md). This review does not select connector families, change pin counts, approve environmental suitability, or release a harness architecture.

## 2. Connector summary

| ID | Current purpose | Current pin count | Required signals | Safety relevance | Power carried | External / disconnect expectation | Required or optional | Major unresolved electrical decisions | Major unresolved mechanical and harness decisions | Preliminary status |
| --- | --- | ---: | --- | --- | --- | --- | --- | --- | --- | --- |
| J1 | Controller power input | 2 | `VIN_RAW`, `GND` | High | Controller input power | External; service disconnect expected | Required | Protection, current rating, transient contract | Family, keying, retention, sealing, routing from product fuse | Proposed |
| J2 | Axis 1 motor-driver logic | 6 | `+5V`, `GND`, `AXIS1_RPWM`, `AXIS1_LPWM`, `AXIS1_REN`, `AXIS1_LEN` | High | Limited logic/interface power only | External; product/service dependent | Required interface | Logic levels, polarity, drive, protection, backfeed, and inhibit implementation | Family, retention, motor-noise separation, harness grouping | Output behavior defined; quantitative contract open |
| J3 | Axis 2 motor-driver logic | 6 | `+5V`, `GND`, `AXIS2_RPWM`, `AXIS2_LPWM`, `AXIS2_REN`, `AXIS2_LEN` | High | Limited logic/interface power only | External; product/service dependent | Required interface | Same unresolved quantitative contract as J2 | Same unresolved concerns as J2 | Output behavior defined; quantitative contract open |
| J4 | Directional limits 1 | 4 logical | Individually returned `LIMIT_LEFT` / `LIMIT_RIGHT` supervised NC loops | High | Dedicated field-sense loops | External; product/service dependent | Required interface | Field voltage, supervision windows/termination, cable, protection | Family, keying, routing, partitioning | Architecture revised; implementation open |
| J5 | Directional limits 2 | 4 logical | Individually returned `LIMIT_UP` / `LIMIT_DOWN` supervised NC loops | High | Dedicated field-sense loops | External; product/service dependent | Required interface | Same quantitative contract as J4 | Same implementation concerns as J4 | Architecture revised; implementation open |
| J6 | OLED | 5 | `OLED_VCC`, `GND`, `I2C_SDA`, `I2C_SCL`, `OLED_RESET` | Low | Limited display supply | External module; service frequency TBD | Optional population / platform interface | `OLED_VCC`, logic levels, bus contract, protection | Module pinout, mounting, retention, cable routing | Proposed |
| J7 | Environmental sensor | 4 | `SENSOR_VCC`, `GND`, `I2C_SDA`, `I2C_SCL` | Low | Limited sensor supply | External module; service frequency TBD | Optional population / platform interface | `SENSOR_VCC`, logic levels, address, bus contract | Sensor placement, airflow, retention, cable routing | Proposed |
| J8 | User controls and indicators | 14 logical if combined | Dedicated STOP pair; ARM/FIRE; encoder; RGB; buzzer; `+3V3`; `+5V`; command return | Mixed; includes STOP | Preliminary limited supplies plus dedicated field-sense loop | External; likely product/service disconnect | Required capabilities; population varies | STOP physical partition, field voltage, output load/drive contracts, supply limits | Partitioning, location mismatch, harness complexity, keying | Input/output behavior defined; partition and quantitative contracts open |
| J9 | Isolated relay contacts | 3 | `RELAY_NC`, `RELAY_COM`, `RELAY_NO` | High | Externally supplied switched circuit | External; product/service dependent | Required interface | Ratings, isolation, load contract, protection, and inhibit implementation | Family, spacing, keying, separation from logic harnesses | Safe behavior defined; quantitative contract open |
| J10 | Controlled I2C expansion | 4 | `+3V3`, `GND`, `I2C_SDA`, `I2C_SCL` | Optional but fault-relevant | Proposed limited expansion supply | External optional; disconnect frequency TBD | Optional | Pull-ups, loading, segmentation, protection, hot-plug, backfeed | Family, exposure, cable and harness grouping | Proposed |
| J11 | Spare GPIO expansion | TBD | Candidate power, return, `SPARE_GPIO1`, `SPARE_GPIO2` | Non-safety-critical | Availability TBD | External optional | Optional | Signal count, function, voltage, protection, drive, backfeed | Pin count, family, keying, retention, exposure | TBD |
| J12 | Future communications reservation | TBD | CAN and RS485 concepts only | Future fault-relevant | Power provision TBD | Not yet defined | Future provision | Separate electrical contracts, transceivers, protection, isolation, termination, biasing | Shared/separate/footprint/daughterboard architecture | Proposed reservation |
| J13 | USB-C service interface | USB-C groups | USB power, data, CC, shield | Service and power-state relevant | USB VBUS | Externally accessible; frequent service use possible | Required service connector | Native ESP32-S3 USB Serial/JTAG preferred; role, protection, recovery access, backfeed, USB-only behavior | Receptacle, retention, enclosure access, shield coupling | Locked external type; implementation TBD |

## 3. Partitioning and architecture findings

### 3.1 J4 and J5 independent-loop requirement

The safety-input review rejects the three-pin shared-return allocations. J4 and J5 each require four logical conductors so every NC supervised loop has an individual return. Physical connector selection, field termination, cable/shield needs, and quantitative fault coverage remain open.

### 3.2 J8 mixed-interface risk

J8 combines safety-relevant controls, navigation, indicators, two preliminary supply domains, and driven outputs. These functions may occupy different product locations and harness routes. A single connector reduces connector count but may reduce product flexibility and complicate unused-signal handling; partitioning may improve separation but increases cost, penetrations, and assembly complexity. `CONN-TBD-001` remains open.

### 3.3 J11 unresolved capability

J11 does not yet have an approved signal count or pin count. Stable spare-signal names do not guarantee analog, PWM, interrupt, bidirectional, current-drive, direct-GPIO, or voltage-tolerance capability. `CONN-TBD-002` remains open.

### 3.4 J12 interface conflation

CAN and RS485 have different transceiver, direction-control, termination, biasing, protection, isolation, protocol, and wiring needs. They must not be represented as interchangeable. `CONN-TBD-003` remains open.

## 4. Cross-connector review actions

- Perform misconnection and partial-insertion analysis after connector families and keying are proposed.
- Separate safety-relevant, noisy, isolated-contact, and low-level bus wiring where practical.
- Define external accessibility, disconnect frequency, retention, sealing, labeling, and unsupported-connector handling for each product configuration.
- Verify power-domain backfeed and fault containment for every independently powered attachment.
- Review all pin counts after electrical contracts, GPIO allocation, power budget, and harness partitioning are approved.

## 5. Preliminary schematic readiness

| ID | Readiness | Blocking definition or condition |
| --- | --- | --- |
| J1 | Conditionally ready | Purpose and range are defined, but protection objectives, transient/undervoltage behavior, current envelope, USB interaction, and block-level rail architecture must be approved |
| J2 | Architecture defined; quantitative contract blocking | Common master inhibit, disabled/coast safe state, command mutual exclusion, and inhibited reversal are selected; logic levels, polarity, drive, protection, timing, and backfeed limits remain open |
| J3 | Architecture defined; quantitative contract blocking | Same as J2 |
| J4 | Architecture defined; quantitative contract blocking | Individually returned supervised NC dry-contact loops selected; field voltage, supervision termination/windows, cable, and protection remain open |
| J5 | Architecture defined; quantitative contract blocking | Same as J4 |
| J6 | Architecture defined; quantitative contract blocking | Reset remains asserted or non-driving until display power is valid; `OLED_VCC`, exact module pinout/logic compatibility, electrical reset implementation, timing, and I2C contract remain open |
| J7 | Blocking definition missing | `SENSOR_VCC`, exact module pinout/address/logic compatibility, and I2C contract |
| J8 | Architecture defined; quantitative contracts blocking | Input behavior and main-only RGB-off/buzzer-silent defaults are selected; dedicated STOP partition, output loads/drives, supply limits, and `CONN-TBD-001` block released pinout capture |
| J9 | Architecture defined; quantitative contract blocking | Main-only master-inhibited actuation and de-energized/`RELAY_NO`-open safe behavior are selected; contact/isolation ratings, external load contract, actuation implementation, and fault containment remain open |
| J10 | Blocking definition missing | Supply, pull-up ownership, loading, hot-plug policy, protection, and segmentation decision |
| J11 | Blocking definition missing | Pin count, function, power, protection, and processor allocation unresolved; current evidence supports reservation only, not a connector schematic |
| J12 | Future provision only | Shared/separate/footprint/daughterboard disposition remains open; no pinout is authorized |
| J13 | Architecture defined; implementation blocking | Native ESP32-S3 USB Serial/JTAG and bounded USB-only core service are selected; CC, protection, source selection, recovery access, shield, backfeed ratings, and transition criteria remain open |

No connector is ready for a released component-level schematic. The selected J2/J3/J6/J8/J9 behavior can inform preliminary block diagrams, but their quantitative electrical contracts and implementations remain blocking.
