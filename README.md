# IPC-100

Universal ESP32-based outdoor control platform for Iron Pine Outdoors.

## Project overview

IPC-100 is a reusable controller for rugged outdoor automation products. The platform combines battery power management, wireless communications, human-machine controls, environmental sensing, and interfaces for relays and motors on a common hardware foundation.

**Current hardware revision:** Rev A

## Project goals

- Provide a dependable controller that can be reused across multiple Iron Pine products.
- Support 9–21 V field power, including DeWalt 20V MAX battery packs.
- Keep safety-critical controls predictable and testable.
- Isolate high-current loads from low-voltage logic and communications.
- Make product-specific behavior modular in hardware, firmware, and documentation.
- Maintain traceable hardware revisions and manufacturing outputs.

## Hardware architecture overview

Rev A is centered on an ESP32-WROOM-32E with Wi-Fi, Bluetooth, and ESP-NOW. The controller provides an SSD1309 OLED interface, BME280 environmental sensing, battery monitoring, physical controls, limit-switch inputs, a thrower relay, two motor interfaces, an RGB status LED, and a buzzer. Expansion provisions include I²C and spare GPIO, with CAN and RS485 reserved for future revisions.

High-current power paths and motor/relay loads are treated separately from the logic domain. See [Architecture](docs/architecture/Architecture.md), [Requirements](docs/requirements/Requirements.md), and [Power Architecture](docs/power/Power_Architecture.md).

## Repository layout

| Path | Purpose |
| --- | --- |
| `docs/` | Architecture, requirements, interface, power, test, and revision documents |
| `electrical/` | Electrical design sources and controlled manufacturing outputs |
| `mechanical/` | CAD, enclosure, battery mount, and harness design |
| `firmware/` | Reserved PlatformIO-compatible source, libraries, headers, and tests |
| `manufacturing/` | Assembly, fixture, and inspection documentation |
| `reference/` | Product references and controlled external technical references |
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
7. Perform bench, environmental, and product-integration validation.
8. Release a controlled manufacturing package.

## Shared product platform

The IPC-100 is intended to support:

- CrossWind automated trap thrower
- Future target systems
- Motion platforms
- Remote outdoor actuators
- Other Iron Pine Outdoors automation products

## Licensing

Copyright © Iron Pine Outdoors. Licensing terms are not yet finalized. See [LICENSE](LICENSE).

