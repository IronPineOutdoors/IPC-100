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

Packages 02, 03R, 04R, 05R, 06R, 07R, and 08 implement the preliminary functional capture through Sheet 07. Sheet 06 contains the independent watchdog, hardware authorization chain, and output-control stages approved by Package 07R. Sheet 07 contains the local encoder conditioning, shared-bus pull-ups, I²C UI expander, OLED and BME280 functional boundaries, low-side RGB and buzzer controls, and deterministic OLED reset behavior approved by Package 08.

Sheets 08 and 09 remain circuitry-free placeholders. No connector implementation, footprints, PCB layout, H-bridges, or integrated motor power stages are present. The Package 08 capture does not consume reserved GPIO37 or introduce any actuator, relay, motor, or watchdog interface.

Exact production parts, final RGB current-setting values, OLED and BME280 module electrical limits, bus-capacitance measurement, environmental qualification, physical test-pad placement, and native KiCad ERC remain controlled prototype or release items. Repository structural validation passes for the implemented Sheet 07 scope.

The Package 09 entry-gate review identified an unresolved optional J10 I²C boundary. ICD-001 subsequently released a restricted 3.3 V/100 kHz, 0.30 m, single-accessory, segmented I²C contract. Package 09R now implements Sheet 08 with DNP rail qualification/filtering, a fail-disabled dual-supply segment buffer, external pull-ups, local protection provisions, stuck-bus containment, and schematic DFT nodes. GPIO37, CAN, RS-485, wired RangeHub integration, and other speculative expansion remain unimplemented documentation-only reservations.

Package 10R implements Sheet 09 with the ICD-002 generic connector/harness boundaries, split STOP/UI connectors, restricted J10, factory pogo boundary, and J11/J12 documentation-only notes. ECO-004 subsequently added two independently peripheral-rail-qualified, fail-isolated J6/J7 I²C branches on Sheet 07 and replaced J13's grouped USB abstraction with all 24 Type-C contacts plus shell, independent CC Rd, provisional data/VBUS ESD, and a DNP shell coupling/bleed network. Sheet 07 still owns the sole base-bus pull-up pair; upstream USB fuse and reverse-current protection remain owned by Sheets 01/02.

All ECO-004 components remain provisional and footprint-free. Exact parts, USB SI, EMC/enclosure bonding, native ERC, quantitative release analysis, and prototype validation remain open. Package 11 and PCB layout are not authorized.

Footprint assignment and PCB layout remain separately gated.
