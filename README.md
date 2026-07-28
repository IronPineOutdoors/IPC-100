# IPC-100

Universal ESP32-based outdoor control platform for Iron Pine Outdoors.

## Project overview

IPC-100 is a reusable controller platform for rugged outdoor automation. This repository contains only the IPC-100 controller hardware, base firmware interfaces, reusable drivers, electrical and mechanical controller design, manufacturing data, and controller-level verification.

Product-specific repositories consume the stable hardware and firmware interfaces defined here. They own their actuators, high-current power distribution, battery mounting, product wiring, mechanics, behavior, assembly, and product documentation.

**Current hardware revision:** Rev A

## Project goals

- Provide a dependable controller that can be reused across multiple Iron Pine products.
- Accept a defined 9–21 V DC input suitable for integration with product-level power systems, including systems based on DeWalt 20V MAX batteries.
- Keep safety-critical controls predictable and testable.
- Keep external high-current loads isolated from controller logic and communications.
- Maintain stable interfaces for separately developed product implementations.
- Maintain traceable hardware revisions and manufacturing outputs.

## Hardware architecture overview

Rev A is centered on an ESP32-WROOM-32E with Wi-Fi, Bluetooth, and ESP-NOW. The controller provides a 2.42-inch SSD1309 OLED interface, BME280 interface, battery-voltage monitoring, physical control inputs, four limit-switch inputs, an isolated dry-contact relay output, two low-current external motor-driver interfaces, an RGB status output, and a buzzer output. Expansion provisions include I²C and spare GPIO, with CAN and RS485 reserved for future revisions.

Motor drivers, motors, and other high-current loads are external to the IPC-100 PCB. IPC-100 defines its allowable input power and protected low-current interfaces; product repositories define battery mounting and product-level power distribution. See [Architecture](docs/architecture/Architecture.md), [Requirements](docs/requirements/Requirements.md), and [Power Architecture](docs/power/Power_Architecture.md).

## Repository layout

| Path | Purpose |
| --- | --- |
| `docs/` | Architecture, requirements, interface, power, test, and revision documents |
| `electrical/` | Electrical design sources and controlled manufacturing outputs |
| `mechanical/` | Controller enclosure, PCB mounting, and universal connector interface requirements |
| `firmware/` | Reserved PlatformIO-compatible source, libraries, headers, and tests |
| `manufacturing/` | Assembly, fixture, and inspection documentation |
| `reference/` | Controlled platform-level technical references |
| `scripts/` | Engineering automation and validation utilities |

## Development workflow

1. Create a focused branch from the current integration branch.
2. Update requirements and interface documents before or with design changes.
3. Keep generated outputs separate from editable design sources.
4. Validate affected hardware, firmware, and documentation.
5. Submit a pull request with scope, evidence, risks, and revision impact.
6. Record user-visible or engineering-significant changes in `CHANGELOG.md`.

See [CONTRIBUTING.md](CONTRIBUTING.md) for conventions and revision policy.

## Required software

- Git and a GitHub account
- Visual Studio Code
- PlatformIO (reserved for future firmware development)
- EasyEDA or the electrical CAD tool selected for the active revision
- A mechanical CAD package compatible with the project source files
- Python 3 for future engineering utilities

Tool versions will be pinned when design sources are introduced.

## Current status

Rev A repository initialized. Architecture, requirements, connector, GPIO, power, test, revision, and BOM templates are present. Firmware, PCB files, and schematics have not yet been generated.

## Planned milestones

1. Freeze Rev A system requirements and safety assumptions.
2. Define connectors, GPIO assignments, power budgets, and protection strategy.
3. Capture and review the Rev A schematic.
4. Complete PCB layout and design-rule review.
5. Build and inspect Rev A prototypes.
6. Develop board-support firmware and automated tests.
7. Perform controller-level bench and environmental validation.
8. Release a controlled manufacturing package.

## External product implementations

CrossWind is the first planned external product implementation and is maintained in a separate repository. Its mechanics, harnesses, power distribution, firmware behavior, assembly, and product documentation do not belong here.

Future product repositories may include RangeHub, Deadfall, Timberline, and other Iron Pine products. Each may depend on a released IPC-100 hardware and firmware interface without becoming part of this repository.

## Licensing

Copyright © Iron Pine Outdoors. Licensing terms are not yet finalized. See [LICENSE](LICENSE).
