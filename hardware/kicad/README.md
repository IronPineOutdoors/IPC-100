# IPC-100 KiCad CAD Source

> **ECO-011 status (2026-08-03):** Composite physical decomposition is incomplete. ECO-011A must release exact devices, Boolean/state tables, package-unit allocation and pin mappings before Sheets 04–07 can be converted to one physical reference per component. No schematic or footprint changed.

> **ECO-011A1 status:** Sheet 04 remains unchanged. LM339B-Q1 common-mode limits conflict with the captured 3.3 V supply and released 2.5 V/4.0 V levels; QER-04 must resolve the electrical implementation before physical symbols can replace the composites.

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

ECO-008R implements QER-02 on U209/U212/U213 using independent generic 141 kΩ RILIM networks. Their calculated 162.82–222.35 mA worst-case limits satisfy the 160–225 mA band. CSR-01A-R4 is authorized; exact MPNs, footprints, PCB work, and prototype closure remain pending.

ECO-007 corrected the three CSR-01A-R2 implementation conflicts with a valid LMR38020F-Q1 400 kHz RT network, independent in-range TPS2553-Q1 ILIM networks, and a physical fixed 2.7 V TLV841S supervisor with external hysteresis. CSR-01A-R3 is authorized. CSR-01A-R2 remains not accepted; CSR-01B, footprints, and PCB work remain unauthorized.

Packages 02, 03R, 04R, 05R, 06R, 07R, and 08 implement the preliminary functional capture through Sheet 07. Sheet 06 contains the independent watchdog, hardware authorization chain, and output-control stages approved by Package 07R. Sheet 07 contains the local encoder conditioning, shared-bus pull-ups, I²C UI expander, OLED and BME280 functional boundaries, low-side RGB and buzzer controls, and deterministic OLED reset behavior approved by Package 08.

Sheets 08 and 09 remain circuitry-free placeholders. No connector implementation, footprints, PCB layout, H-bridges, or integrated motor power stages are present. The Package 08 capture does not consume reserved GPIO37 or introduce any actuator, relay, motor, or watchdog interface.

Exact production parts, final RGB current-setting values, OLED and BME280 module electrical limits, bus-capacitance measurement, environmental qualification, physical test-pad placement, and native KiCad ERC remain controlled prototype or release items. Repository structural validation passes for the implemented Sheet 07 scope.

The Package 09 entry-gate review identified an unresolved optional J10 I²C boundary. ICD-001 subsequently released a restricted 3.3 V/100 kHz, 0.30 m, single-accessory, segmented I²C contract. Package 09R now implements Sheet 08 with DNP rail qualification/filtering, a fail-disabled dual-supply segment buffer, external pull-ups, local protection provisions, stuck-bus containment, and schematic DFT nodes. GPIO37, CAN, RS-485, wired RangeHub integration, and other speculative expansion remain unimplemented documentation-only reservations.

Package 10R implements Sheet 09 with the ICD-002 generic connector/harness boundaries, split STOP/UI connectors, restricted J10, factory pogo boundary, and J11/J12 documentation-only notes. ECO-004 subsequently added two independently peripheral-rail-qualified, fail-isolated J6/J7 I²C branches on Sheet 07 and replaced J13's grouped USB abstraction with all 24 Type-C contacts plus shell, independent CC Rd, provisional data/VBUS ESD, and a DNP shell coupling/bleed network. Sheet 07 still owns the sole base-bus pull-up pair; upstream USB fuse and reverse-current protection remain owned by Sheets 01/02.

All ECO-004 components remain provisional and footprint-free. SSR-01R subsequently approved the stable functional schematic baseline with Major observations and authorized Package 11 Component Selection & Footprint Assignment. Exact parts, manufacturer pin maps, ratings, reviewed land patterns, USB SI, EMC/enclosure bonding, native ERC, quantitative release analysis, DFM/DFT, and prototype validation remain controlled Package 11 or downstream gates.

Package 11 work must review each exact device before accepting its footprint. PCB placement, routing, fabrication, and procurement remain separately gated and unauthorized.

CSR-01 / Package 11A subsequently completed the as-captured inventory but did not accept the component freeze. The baseline contains composite functional blocks, repeated local reference names across sheets, and unresolved quantitative/module/connector prerequisites that prevent complete one-to-one MPN selection. No schematic or footprint was changed; Package 11B remains unauthorized pending controlled component-resolution and CSR reissue.

ECO-005 closed the reference-identity portion of CSR-01 by placing every non-connector component in a deterministic Sheet 01–09 range. All connector functional designations and `DFT1` remain unchanged. The repository validator now enforces global reference uniqueness and sheet ranges, and the permanent old/new mapping is in `docs/reference/Reference_Designator_Register.md`. This reference-only change authorizes CSR-01A Power Component Selection; it does not authorize footprints or PCB work.

CSR-01A reviewed the power subsystem after ECO-005 and did not accept the power-component freeze. The 124 power-scope rows remain blocked pending quantitative transient, load, thermal, stability, timing, connector, exact-order-code, and sourcing evidence; all 177 unrelated rows are marked `NOT YET FROZEN`. CSR-01B, footprint assignment, and PCB work remain unauthorized.

ECO-009 corrected Sheet 03 C305 to a generic 93.1 nF ±1% C0G/NP0 timing class. QER-03 subsequently released a 75–150 ms design window, and ECO-009R verified the unchanged implementation at 99.642 ms nominal and 79.1–136.6 ms endpoints. No topology or footprint changed. PACS-01 is authorized for exact U302/C305 selection and prototype confirmation.

QER-04 resolves ECO-011A1's Sheet 04 comparator input-range blocker with a direct-input, field-powered TLV7044-Q1-class architecture, field-tracking threshold ratios, explicit fail-safe logic and a preliminary package allocation. Sheet 04 remains unchanged; ECO-011A1R alone is authorized to implement the decomposition.

QER-01 subsequently released the quantitative envelope, and CSR-01A-R reattempted the freeze. Nine independent 100 kΩ Sheet 02/08 bias/enable resistors are frozen. ECO-006 removed the capacitor/MOSFET rating conflicts and MIR-01 released J1/H01 mechanics. CSR-01A-R2 then found exact-device conflicts in U201/R201 frequency programming, three TPS2553 branch-limit networks, and U801 threshold/hysteresis implementation. The final power freeze was not accepted; CSR-01B, footprints, and PCB work remain unauthorized pending corrective ECO and re-review.
