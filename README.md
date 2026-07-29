# Iron Pine IPC-100

Reusable ESP32-based outdoor controller platform for Iron Pine Outdoors.

| Project identity | Value |
| --- | --- |
| Product platform | Iron Pine IPC-100 |
| Current hardware revision | Rev A |
| Status | Architecture and requirements definition |
| Repository purpose | Reusable controller platform |
| First planned application | CrossWind |
| CrossWind repository | Separate external product repository |

## 1. Scope

This repository controls the reusable IPC-100 hardware platform, base-firmware interfaces, electrical design, controller mechanics, manufacturing definition, and controller-level verification.

Product repositories consume released IPC-100 electrical and firmware interfaces. They own battery mounts, high-current distribution, converters, motor drivers, motors, product harnesses, enclosures, application behavior, assembly, and product verification. CrossWind is maintained separately.

## 2. Architecture summary

Rev A uses the ESP32 processor family with Wi-Fi, Bluetooth, and ESP-NOW. ESP32-WROOM-32E is the current reference candidate, not the locked production module. IPC-100 accepts 9–21 V DC during normal operation, creates 5 V and 3.3 V logic rails, and provides a USB-C service interface, battery monitoring, protected inputs, OLED and BME280 interfaces, two low-current external motor-driver interfaces, isolated relay contacts, RGB and buzzer outputs, I2C expansion, spare GPIO, and future CAN/RS485 provisions. The primary integration case is an external nominal 18 V lithium-ion tool-battery system; DeWalt 20V MAX is the initial reference implementation rather than a platform dependency.

Motor drivers, motors, thrower power, and all high-current distribution are external. Motor current must not pass through IPC-100.

## 3. Rev A Engineering Blueprint

| Document | Purpose |
| --- | --- |
| [Executive Summary](docs/architecture/Executive_Summary.md) | Blueprint purpose, scope, audience, and current baseline |
| [Platform Vision](docs/architecture/Platform_Vision.md) | Long-term platform and product-ecosystem strategy |
| [System Architecture](docs/architecture/System_Architecture.md) | Platform boundaries, block diagram, responsibilities, and fault containment |
| [Product Boundaries](docs/architecture/Product_Boundaries.md) | Ownership between IPC-100 and consuming products |
| [Design Philosophy](docs/architecture/Design_Philosophy.md) | Engineering principles for platform decisions |
| [Non-Goals](docs/architecture/Non_Goals.md) | Explicit Rev A scope exclusions |
| [Design Decisions](docs/architecture/Design_Decisions.md) | Architecture decision records |
| [Functional Requirements](docs/requirements/Functional_Requirements.md) | Observable controller capabilities and behavior |
| [Non-Functional Requirements](docs/requirements/Non_Functional_Requirements.md) | Reliability, environmental, service, and quality constraints |
| [Hardware Requirements](docs/requirements/Hardware_Requirements.md) | Uniquely identified locked, proposed, and TBD requirements |
| [Wiring Standard](docs/requirements/Wiring_Standard.md) | Platform wiring, labeling, termination, and inspection practices |
| [Mechanical Interface](docs/requirements/Mechanical_Interface.md) | PCB mounting, access, enclosure, service, and marking requirements |
| [Connector Specification](docs/connectors/Connector_Specification.md) | Preliminary J1–J13 interface reservations and stable signal names |
| [GPIO Map](docs/connectors/GPIO_Map.md) | ESP32 resource plan and allocation gate |
| [Power Architecture](docs/power/Power_Architecture.md) | Source boundary, power tree, protection, and rail behavior |
| [Power Budget](docs/power/Power_Budget.md) | Preliminary loads, margins, and prototype measurement plan |
| [Revision History](docs/revisions/Revision_History.md) | Rev A, prototype-build, document, and firmware version policy |

Supporting verification: [Rev A Test Plan](docs/testing/Test_Plan.md).

## 4. Development gate

> No additional schematic blocks should be added until their requirements and interfaces are documented.

The Engineering Blueprint must be reviewed before schematic development continues. Any unresolved selection shall remain `TBD`; unverified parts shall not be represented as final.

## 5. Repository map

| Path | Contents |
| --- | --- |
| `docs/architecture/` | System architecture and design decisions |
| `docs/requirements/` | Hardware, wiring, and mechanical requirements |
| `docs/connectors/` | Connector contract and GPIO allocation |
| `docs/power/` | Power architecture and budget |
| `docs/testing/` | Controller verification planning |
| `docs/revisions/` | Revision and configuration-control history |
| `docs/images/` | Controlled diagram sources and exports |
| `electrical/` | Future electrical design sources and controlled outputs |
| `mechanical/` | Controller enclosure, PCB mounting, and connector interfaces |
| `firmware/` | Future base firmware, reusable drivers, and tests |
| `manufacturing/` | Future controller assembly, fixture, and inspection definition |
| `reference/` | Platform-level technical references |
| `scripts/` | Future engineering automation |

## 6. Development workflow

1. Trace a proposed change to requirements and interfaces.
2. Resolve or explicitly record affected `TBD` decisions.
3. Update architecture, connector, GPIO, power, mechanical, and test documents together.
4. Review safety states and product compatibility.
5. Implement only after the applicable documentation gate is satisfied.
6. Validate in proportion to risk and retain objective evidence.
7. Record significant changes in the changelog and revision history.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 7. Required software

- Git and GitHub
- Visual Studio Code
- PlatformIO for future base-firmware development
- EasyEDA or the electrical CAD tool approved for Rev A
- A compatible mechanical CAD package
- Python 3 for future engineering utilities

Tool versions will be pinned when design sources are introduced.

## 8. Next milestones

1. Approve Engineering Blueprint
2. Finalize power-component selection
3. Complete Sheet 01
4. Allocate ESP32 GPIO
5. Complete remaining schematic sheets
6. Run ERC
7. Begin PCB layout

## 9. Licensing

Copyright © Iron Pine Outdoors. Licensing terms are not yet finalized. See [LICENSE](LICENSE).
