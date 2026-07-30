# IPC-100 KiCad CAD Source

This directory contains the controlled KiCad source for IPC-100 Rev A.

## Project structure

- `IPC-100.kicad_pro` — KiCad project configuration.
- `IPC-100.kicad_sch` — Sheet 00 root system architecture.
- `sheets/` — Sheets 01–09, one file per approved functional boundary.
- `notes/` — Package-specific implementation assumptions and expected review findings.

Sheet 00 contains only hierarchical sheet symbols, matching ports, and named top-level interconnect. Physical connectors and manufacturing test symbols belong exclusively to Sheet 09 when that implementation package is authorized.

## Hierarchy

| Sheet | Function |
| --- | --- |
| 00 | Top-Level System Architecture |
| 01 | Power Entry and Protection |
| 02 | Power Conversion and Rail Control |
| 03 | ESP32-S3 Core, Boot, Reset, USB, and Recovery |
| 04 | Safety and Command Inputs |
| 05 | Motor-Driver Logic Interfaces |
| 06 | Relay Output and Master Inhibit |
| 07 | User Interface, OLED, and Sensor |
| 08 | Expansion and Future Interfaces |
| 09 | Connectors, Test Points, and Production Access |

J11 and J12 remain documentation-only concepts in Rev A and have no released connector symbols or pinouts.

## Implementing future sheets

1. Start only after the package-specific entry gate is approved.
2. Preserve the root port names and the ownership defined by the authoritative hierarchy document.
3. Replace only the deferral note and add circuitry within the authorized child sheet.
4. Do not move connector symbols out of Sheet 09 or create alternate paths around the master inhibit.
5. Do not assign footprints or start PCB layout until their separate release gates are approved.
6. Run hierarchy checks and ERC after each package, then record the review result.

## Review gates

The controlled gates map to CAD progress as follows:

- Gate 1: hierarchy and root interfaces approved.
- Gate 2: preliminary functional capture reviewed.
- Gate 3: detailed parts, values, tolerances, derating, and ERC reviewed.
- Gate 4: PCB-layout entry authorized only from a released schematic.

See [Schematic Hierarchy and Block Interface Definition](../../docs/hardware/Schematic_Hierarchy_and_Block_Interface_Definition.md) and [Critical Component Selection and Electrical Quantification](../../docs/hardware/Critical_Component_Selection_and_Electrical_Quantification.md).

## Current status

Package 02 implements Sheet 01 Power Entry and Protection. Package 03R implements Sheet 02 Power Conversion and Rail Control. Package 04R implements Sheet 03 ESP32-S3 Core, Boot, Programming & Recovery. AR-04/ADR-042 resolved the Package 05 entry gate, and Package 05R implements Sheet 04 supervised safety and command inputs. Sheets 05–09 remain circuitry-free placeholders. No footprints, PCB layout, actuator drivers, application peripherals, or connector implementation are present.

Subject to Package 05R peer review, the next package is **Package 06 — Sheet 05 Motor Driver Interfaces, Position Feedback & Motion-Control Signals**.
