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
| J2 | Axis 1 motor-driver logic | 6 | `+5V`, `GND`, `AXIS1_RPWM`, `AXIS1_LPWM`, `AXIS1_REN`, `AXIS1_LEN` | High | Limited logic/interface power only | External; product/service dependent | Required interface | Logic levels, polarity, drive, protection, backfeed, enable contract | Family, retention, motor-noise separation, harness grouping | Proposed |
| J3 | Axis 2 motor-driver logic | 6 | `+5V`, `GND`, `AXIS2_RPWM`, `AXIS2_LPWM`, `AXIS2_REN`, `AXIS2_LEN` | High | Limited logic/interface power only | External; product/service dependent | Required interface | Same unresolved contract as J2 | Same unresolved concerns as J2 | Proposed |
| J4 | Directional limits 1 | 3 | `GND`, `LIMIT_LEFT`, `LIMIT_RIGHT` | High | Reference only under current concept | External; product/service dependent | Required interface | Active states, field domain, contact type, fault detection, protection | Shared-return suitability, keying, routing, partitioning | Proposed / risk |
| J5 | Directional limits 2 | 3 | `GND`, `LIMIT_UP`, `LIMIT_DOWN` | High | Reference only under current concept | External; product/service dependent | Required interface | Same unresolved contract as J4 | Same unresolved concerns as J4 | Proposed / risk |
| J6 | OLED | 5 | `OLED_VCC`, `GND`, `I2C_SDA`, `I2C_SCL`, `OLED_RESET` | Low | Limited display supply | External module; service frequency TBD | Optional population / platform interface | `OLED_VCC`, logic levels, bus contract, protection | Module pinout, mounting, retention, cable routing | Proposed |
| J7 | Environmental sensor | 4 | `SENSOR_VCC`, `GND`, `I2C_SDA`, `I2C_SCL` | Low | Limited sensor supply | External module; service frequency TBD | Optional population / platform interface | `SENSOR_VCC`, logic levels, address, bus contract | Sensor placement, airflow, retention, cable routing | Proposed |
| J8 | User controls and indicators | 13 | Controls, encoder, RGB, buzzer, `+3V3`, `+5V`, `GND` | Mixed; includes STOP | Preliminary limited supplies | External; likely product/service disconnect | Required capabilities; population varies | Input contract, output drivers, supply limits, safe states | Partitioning, location mismatch, harness complexity, keying | Proposed / open partition |
| J9 | Isolated relay contacts | 3 | `RELAY_NC`, `RELAY_COM`, `RELAY_NO` | High | Externally supplied switched circuit | External; product/service dependent | Required interface | Ratings, isolation, load contract, protection | Family, spacing, keying, separation from logic harnesses | Proposed |
| J10 | Controlled I2C expansion | 4 | `+3V3`, `GND`, `I2C_SDA`, `I2C_SCL` | Optional but fault-relevant | Proposed limited expansion supply | External optional; disconnect frequency TBD | Optional | Pull-ups, loading, segmentation, protection, hot-plug, backfeed | Family, exposure, cable and harness grouping | Proposed |
| J11 | Spare GPIO expansion | TBD | Candidate power, return, `SPARE_GPIO1`, `SPARE_GPIO2` | Non-safety-critical | Availability TBD | External optional | Optional | Signal count, function, voltage, protection, drive, backfeed | Pin count, family, keying, retention, exposure | TBD |
| J12 | Future communications reservation | TBD | CAN and RS485 concepts only | Future fault-relevant | Power provision TBD | Not yet defined | Future provision | Separate electrical contracts, transceivers, protection, isolation, termination, biasing | Shared/separate/footprint/daughterboard architecture | Proposed reservation |
| J13 | USB-C service interface | USB-C groups | USB power, data, CC, shield | Service and power-state relevant | USB VBUS | Externally accessible; frequent service use possible | Required service connector | Native ESP32-S3 USB Serial/JTAG preferred; role, protection, recovery access, backfeed, USB-only behavior | Receptacle, retention, enclosure access, shield coupling | Locked external type; implementation TBD |

## 3. Partitioning and architecture findings

### 3.1 J4 and J5 shared-return risk

The three-pin allocations are subject to revision if the approved field-input contract requires individual returns, shield or drain conductors, wet-contact sensing, powered sensors, fault-detection resistors, separate commons, differential signaling, improved fault isolation, additional keying, or different product harness partitioning. Shared-return fault implications require analysis. This is an architecture risk, not a defect.

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
| J2 | Blocking definition missing | Logic voltage, polarity, drive capability, enable architecture, safe-state circuitry, and proof that four signals per axis are supportable |
| J3 | Blocking definition missing | Same as J2 |
| J4 | Blocking definition missing | Active polarity, NO/NC and wet/dry contract, field voltage, fault detection, protection, and shared-return disposition |
| J5 | Blocking definition missing | Same as J4 |
| J6 | Blocking definition missing | `OLED_VCC`, exact module pinout/logic compatibility, reset behavior, and I2C contract |
| J7 | Blocking definition missing | `SENSOR_VCC`, exact module pinout/address/logic compatibility, and I2C contract |
| J8 | Conditionally ready | May remain a provisional logical reservation, but `CONN-TBD-001`, input/output electrical contracts, safe states, and limited supply assumptions block released pinout capture |
| J9 | Blocking definition missing | Relay contact/isolation ratings, load contract, coil supply, driver, and hardware de-energized architecture |
| J10 | Blocking definition missing | Supply, pull-up ownership, loading, hot-plug policy, protection, and segmentation decision |
| J11 | Blocking definition missing | Pin count, function, power, protection, and processor allocation unresolved; current evidence supports reservation only, not a connector schematic |
| J12 | Future provision only | Shared/separate/footprint/daughterboard disposition remains open; no pinout is authorized |
| J13 | Blocking definition missing | USB-C external type is locked, but native USB versus USB-to-UART, device role, backfeed, USB-only behavior, and processor resources must be selected |

No connector is ready for a released component-level schematic. J1 and the J8 logical grouping can inform preliminary block diagrams; all other required interfaces have blocking electrical definitions.
