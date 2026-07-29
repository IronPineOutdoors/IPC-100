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

Rev A uses the ESP32 processor family with Wi-Fi, Bluetooth, and ESP-NOW. ESP32-S3-WROOM-1-N8 is selected for preliminary Rev A capture. A complete proposed direct GPIO allocation maps all 27 required non-USB application signals, preserves native USB and UART0 recovery, and remains blocked from release by module verification, framework validation, and implementation decisions. IPC-100 accepts 9–21 V DC during normal operation, creates 5 V and 3.3 V logic rails, and provides a USB-C service interface, battery monitoring, protected inputs, a local monochrome graphical OLED interface, temperature/humidity/pressure sensing, two low-current external motor-driver interfaces, isolated relay contacts, RGB and buzzer outputs, controlled I2C expansion, proposed spare GPIO, and future CAN/RS485 provisions. The 2.42-inch SSD1309 OLED and BME280 are reference implementations rather than permanent dependencies. The primary integration case is an external nominal 18 V lithium-ion tool-battery system; DeWalt 20V MAX is the initial reference implementation rather than a platform dependency.

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
| [Connector Architecture Review](docs/connectors/Connector_Architecture_Review.md) | Cross-connector partitioning, harness, safety, and unresolved architecture review |
| [GPIO Map](docs/connectors/GPIO_Map.md) | ESP32 resource plan and allocation gate |
| [GPIO and Peripheral Allocation Review](docs/connectors/GPIO_and_Peripheral_Allocation_Review.md) | Proposed ESP32-S3 pin map, peripheral assignments, restrictions, conflicts, reserves, and readiness gate |
| [Schematic Hierarchy and Block Interface Definition](docs/hardware/Schematic_Hierarchy_and_Block_Interface_Definition.md) | Rev A KiCad sheet structure, block/net/connector ownership, capture sequence, and review gates |
| [Critical Component Selection and Electrical Quantification](docs/hardware/Critical_Component_Selection_and_Electrical_Quantification.md) | Rev A circuit topologies, preferred components, values, calculations, margins, and preliminary-capture gate |
| [Safety Input Architecture Review](docs/interfaces/Safety_Input_Architecture_Review.md) | Input classifications, supervised safety loops, electrical contracts, fault behavior, and input schematic-entry gate |
| [Output Electrical Architecture Review](docs/interfaces/Output_Electrical_Architecture_Review.md) | Motor, relay, status, reset, safe-state, sequencing, fault, and output schematic-entry contracts |
| [Power Architecture](docs/power/Power_Architecture.md) | Source boundary, power tree, protection, and rail behavior |
| [Power Architecture Engineering Review](docs/power/Power_Architecture_Engineering_Review.md) | Power ownership, domains, operating states, sequencing, faults, USB service, and schematic-entry gate |
| [Power Budget](docs/power/Power_Budget.md) | Preliminary loads, margins, and prototype measurement plan |
| [Open Design Items](docs/revisions/Open_Design_Items.md) | Consolidated unresolved decisions and required engineering review gates |
| [Rev A Schematic Readiness Review](docs/revisions/Schematic_Readiness_Review_Rev_A.md) | Architecture-freeze recommendation, blockers, and schematic-entry criteria |
| [Requirements Traceability Matrix](docs/revisions/Requirements_Traceability_Matrix.md) | Architecture-level mapping from requirements to interfaces, verification, and open decisions |
| [Processor Resource Feasibility](docs/architecture/Processor_Resource_Feasibility.md) | Resource demand and proposed ESP32-S3 allocation feasibility |
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
| `docs/interfaces/` | Controlled electrical-interface architecture and reviews |
| `docs/hardware/` | Schematic implementation planning, ownership, and capture gates |
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

1. Capture the preliminary Rev A KiCad hierarchy and Sheets 00–09
2. Close the blockers retained in the electrical quantification
3. Review every sheet through its controlled gate
4. Complete cross-sheet review and ERC
5. Release exact orderable parts and connector implementations
6. Authorize PCB layout only after schematic release

## 9. Licensing

Copyright © Iron Pine Outdoors. Licensing terms are not yet finalized. See [LICENSE](LICENSE).
