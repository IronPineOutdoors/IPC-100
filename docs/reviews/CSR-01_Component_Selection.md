# CSR-01 — Component Selection & Engineering BOM Freeze

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review date | 2026-07-30 |
| Input baseline | SSR-01R commit `5dbe317` |
| Package | 11A |
| Scope | Component inventory, exact-part freeze readiness, EBOM/AVL |
| Schematic/PCB changes | None |

## Executive Summary

CSR-01 extracted every populated or DNP physical/logical symbol from Sheets 01–09 and produced a 301-row as-captured inventory. It did not freeze any manufacturer part number because the present baseline cannot support an honest, complete part freeze without additional electrical design decisions.

The blocking evidence is direct:

- 55 rows explicitly contain a provisional, class, TBD, provision, qualifier, composite-boundary, or “verify” description.
- Composite symbols represent multiple physical devices or unresolved topologies, including the Sheet 04 comparator/logic windows, Sheet 05 interlock/authorization functions, Sheet 06 watchdog/qualifier/latch and authorization logic, Sheet 07 UI conditioner/status driver/peripheral boundaries/branch isolators, and Sheet 08 rail qualifier/bus buffer.
- Relay load/life, connector family/environment/current, power budget, transient energy, timing, thermal, partial-power, and several passive values remain open in the controlled records.
- The child sheets reuse local reference names. Sixty-three reference names occur on more than one sheet (for example, `C1`, `R1`, `U1`). Stable project-wide annotation is required before a production EBOM can identify components unambiguously.
- Exact OLED and sensor modules, USB-C receptacle, most protection devices, branch isolators, connectors, test targets, buzzer/RGB loads, and several power passives remain undefined.

The generated EBOM and AVL are therefore controlled gap-analysis artifacts. Every row is marked `BLOCKED`, uses no procurement-approved MPN, contains no fabricated price, and carries a do-not-source/do-not-substitute warning. Package 11B is not authorized.

## Master Component Inventory

Power symbols such as `#PWR` are excluded because they are not physical BOM items. No separate mechanical fastener/enclosure item exists in the electrical schematics.

| Category | Rows |
| --- | ---: |
| Connectors | 12 |
| Displays | 3 |
| ESP32 | 1 |
| I²C | 4 |
| Logic | 12 |
| MOSFETs | 4 |
| Passives | 190 |
| Power | 10 |
| Protection | 36 |
| Relays | 1 |
| Safety | 9 |
| Sensors | 3 |
| Test | 12 |
| USB | 1 |
| User interface | 2 |
| Watchdog | 1 |
| **Total** | **301** |

| Sheet | Rows | Inventory result |
| --- | ---: | --- |
| 01 Power Entry | 35 | Complete as captured; exact input/protection parts incomplete |
| 02 Power Conversion | 77 | Complete as captured; regulator suffixes, passives and branch protection incomplete |
| 03 ESP32 Core | 16 | Complete as captured; exact module/supervisor/order codes require release audit |
| 04 Safety Inputs | 53 | Complete as captured; composite comparator/logic mapping unresolved |
| 05 Motor Interfaces | 47 | Complete as captured; composite logic and translator order codes unresolved |
| 06 Relay/Master Inhibit | 17 | Complete as captured; watchdog/logic topology and relay load selection unresolved |
| 07 UI/Peripherals | 17 | Complete as captured; composite blocks and exact modules unresolved |
| 08 Expansion | 20 | Complete as captured; qualifier, buffer and protection parts unresolved |
| 09 Connectors/Test | 19 | Complete as captured; all physical connector/test families unresolved |

The EBOM uses `sheet/reference` as a temporary unique item key. This is not a substitute for project-wide KiCad annotation.

## Component Selection

No row meets all required freeze criteria: exact orderable manufacturer code, verified vendor pin mapping, voltage/current/temperature/tolerance/package, lifecycle/RoHS, availability, approved source, alternate, derating evidence, and selection rationale.

Several schematic values name credible candidate families, but a family or class is not an MPN. Examples include TPS2663, LMR38020-Q1, TPS2121, TPS62130, TPS3890-Q1, TPS3431-Q1, LM339B-Q1, SN74LXC4T245-class, TCA9535-class, Omron G5Q-1 DC5-class, SSD1309, and BME280. Selecting suffixes without closing their equations, pin mappings, load contracts, and physical constraints would violate Package 11A scope.

Limited lifecycle evidence confirms that continued selection work is reasonable, not that parts are frozen:

- TI currently marks TPS3890-Q1 active and specifies its automotive –40 °C to 125 °C range and WSON package: <https://www.ti.com/product/TPS3890-Q1>.
- TI's current watchdog selector still lists TPS3431-Q1: <https://www.ti.com/product-category/power-management/supervisor-reset-ics/reset-watchdog/products.html>.
- TI identifies TCA9535 as an active related device on its PCA9535 product page: <https://www.ti.com/product/PCA9535>.
- Omron currently marks G5Q-1 in production, but the exact contact/coil variant still depends on the released load contract: <https://components.omron.com/us-en/products/relays/G5Q>.

These sources do not resolve distributor stock, pricing, second sources, or system suitability for the 301 rows.

## Connector Selection

Exact connector selection is blocked for all physical boundaries:

| Group | Connectors | Missing prerequisite |
| --- | --- | --- |
| Battery | J1 | Continuous/peak/fault current, wire gauge, ingress boundary, touch safety and enclosure interface |
| Motion | J2/J3 | Exact external-driver module, logic-current envelope, keying and harness/environment |
| Safety | J4/J5/J8A | Safety harness construction, sealing, retention, mis-mate prevention and qualification level |
| UI | J6/J7/J8B | Exact OLED/sensor/UI loads, module pin order, branch capacitance and enclosure routing |
| Thrower | J9 | Released load type, voltage/current/life and inductive-load policy |
| Expansion | J10 | DNP population strategy and physical accessory contract |
| USB-C | J13 | Exact receptacle mechanics, mid-mount/top-mount choice, shell stakes, cycle/retention and enclosure access |
| Factory | DFT1 | Pogo target geometry, fixture stack-up, current limits and access matrix |

Choosing a family now would silently freeze mechanical and environmental decisions that remain outside the released electrical contract. No footprint or connector MPN was assigned.

## Passive Selection

The inventory contains 190 passive rows. Values and some tolerances are captured, but a complete passive freeze is blocked by:

- regulator vendor-tool and stability calculations;
- inductor saturation/RMS/thermal and DCR selection;
- capacitor DC-bias/effective-capacitance and ripple-current requirements;
- transient-energy and pulse-power requirements;
- safety threshold tolerance/temperature analysis;
- RC timing equations tied to unresolved exact devices;
- SI-dependent USB/I²C/motion series values;
- voltage, package, pulse, sulfur/environment and derating policy;
- DNP population and assembly-size policy.

No generic “one resistor series/one capacitor series” assignment is permitted until these groups are separated by actual electrical stress.

## Semiconductor Selection

The following semiconductor groups remain incomplete:

| Group | Blocking issue |
| --- | --- |
| Entry protection/regulators | Exact suffixes, passives, SOA, transition, thermal, and pulse-energy closure |
| Supervisors/watchdog | Threshold/timing equations and the composite qualifier/latch topology |
| Safety comparators/logic | Physical unit mapping, threshold/hysteresis tolerance, partial-power behavior |
| Motion logic/translators | Exact gates needed to realize composite equations; exact four-channel Ioff translator |
| I²C branch/expansion buffers | Enable thresholds, Ioff, false-pulse/stuck-low behavior and exact topology |
| USB/protection | Exact ESD arrays and VBUS device coordinated with receptacle/layout |
| UI drivers | Actual RGB/buzzer/load definition and physical transistor/clamp implementation |
| Display/sensor | Exact orderable modules, pinouts, pull-ups, addresses, mechanics and lifecycle |
| Relay driver/clamp | Exact relay coil/contact contract, MOSFET stress and flyback energy |

No known errata review can be completed until the orderable devices are known.

## Derating Review

A component-level derating review was not claimable. System limits needed to calculate stress remain open:

- input surge profile and source impedance;
- continuous/peak/simultaneous rail currents;
- sealed-enclosure ambient and solar rise;
- relay load type, inrush, breaking current and cycle life;
- connector contact current and bundled-wire temperature;
- TVS pulse waveform, repetition and clamp coordination;
- USB ESD target and physical return path;
- safety thresholds/timing over tolerance and temperature;
- partial-power and backfeed cases.

Every EBOM row therefore retains `Requires exact-part review` or equivalent status. No row is represented as passing derating.

## Approved Vendor List

`Approved_Vendor_List.xlsx` and its source CSV contain one row per inventory item. All entries are deliberately marked unresolved. Mouser, DigiKey, Arrow, and LCSC are candidate distribution channels, not approved sources for an undefined MPN.

Stock status and pricing are time-sensitive and cannot be meaningfully queried until an exact order code and acceptable packaging quantity exist. No vendor or second source is approved by CSR-01.

## Engineering BOM

The generated files are:

- `docs/bom/IPC100_RevA_EBOM.csv`
- `docs/bom/IPC100_RevA_EBOM.xlsx`
- `docs/bom/Approved_Vendor_List.xlsx`
- `docs/bom/Approved_Vendor_List.csv` (machine-readable workbook source)
- `docs/bom/CSR-01_Inventory_Summary.csv`

Each of the 301 EBOM rows includes its sheet/reference identity, category, captured function/value, quantity, required selection fields, criticality, cost columns, freeze status, and notes. All MPN and cost fields remain unresolved rather than containing guessed procurement data.

## Cost Analysis

A defensible prototype, 10-unit, 100-unit, or 1000-unit cost cannot be produced from an EBOM with zero frozen MPNs and undefined connector, relay, display, sensor, protection, and composite-logic implementations.

| Requested estimate | Result |
| --- | --- |
| Prototype electronics | Not estimable from released data |
| 10-unit electronics | Not estimable from released data |
| 100-unit electronics | Not estimable from released data |
| 1000-unit electronics | Not estimable from released data |
| Connector percentage | Not estimable; connector families unresolved |
| PCB percentage | Out of scope and no board definition |
| Highest-cost components | Likely MCU/module, connectors, relay, power magnetics/protection and OLED, but ranking is not released |

Publishing numeric estimates would create false sourcing confidence and is rejected.

## Lifecycle and Obsolescence Assessment

No obsolete or NRND part was knowingly frozen because no part was frozen. The dominant risks are:

- single-source functional blocks and modules;
- exact OLED-module availability;
- automotive suffix/package availability;
- specialized USB-C and connector mechanics;
- relay suffix dependence on load class;
- allocation risk for ESP32 and power-management devices;
- alternate incompatibility where pinout, threshold, timing, capacitance or partial-power behavior differs.

Lifecycle, RoHS, stock, and second-source status remain `NOT REVIEWED` at row level. Candidate-family status evidence does not qualify an exact order code.

## Risk Register

| ID | Class | Finding | Consequence | Required correction |
| --- | --- | --- | --- | --- |
| CSR-01-F01 | Critical | Composite functional symbols do not map one-to-one to selectable physical devices | A complete MPN/quantity/pin map cannot be produced | Decompose and review exact topology through a bounded component-resolution ECO |
| CSR-01-F02 | Major | 63 local reference names repeat across sheets | EBOM and footprint identities are ambiguous project-wide | Perform project-wide annotation and validate uniqueness without changing nets |
| CSR-01-F03 | Critical | Power, relay, connector, timing, thermal and safety quantitative contracts remain open | Part selection could violate electrical/safety margins | Close calculations and load/environment contracts before freezing affected MPNs |
| CSR-01-F04 | Major | 55 captured rows explicitly remain provisional/class/TBD/composite | Zero rows meet complete freeze evidence | Resolve each row with datasheet/pin/rating/alternate review |
| CSR-01-F05 | Major | Exact connector/module/mechanical interfaces are undefined | Connector and module MPNs/footprints cannot be selected | Release connector/mechanical/module contract |
| CSR-01-F06 | Major | Native ERC remains unavailable | Exact vendor-symbol mapping cannot be electrically classified | Run ERC after exact symbols are introduced |
| CSR-01-F07 | Major | AVL and cost cannot be sourced without exact order codes | Procurement and cost claims would be fictional | Perform distributor checks after candidate approval |
| CSR-01-F08 | Observation | Zero footprints and no PCB changes are preserved | Package stop condition maintained | Preserve until an accepted CSR authorizes Package 11B |

## Remaining Release Gates

1. Resolve composite functional symbols into exact physical topology and quantities.
2. Close power budget, transient, timing, thermal, relay-load, connector and safety calculations.
3. Release exact OLED/BME280 modules, UI loads, connectors and DFT target contract.
4. Perform project-wide schematic annotation and audit every reference.
5. Select exact order codes and verify manufacturer symbols/pin maps/datasheet revisions.
6. Complete row-level lifecycle, RoHS, distributor stock, alternates, derating and cost.
7. Run native ERC on the exact-symbol baseline.
8. Reissue CSR-01 as a verification package before authorizing footprint work.

## Validation

- All nine populated child sheets and 301 physical/logical items inventoried.
- Zero frozen MPNs reported; no placeholder is represented as approved.
- EBOM CSV and both XLSX containers generated and ZIP integrity-tested.
- No footprints assigned.
- No schematic logic, GPIO, ADR, ICD, or PCB file changed.
- Repository hierarchy, GPIO and ICD-002 validators remain required at package close.

## Final Decision

# CSR-01 NOT ACCEPTED

PACKAGE 11B Footprint Assignment & Library Freeze is not authorized.
