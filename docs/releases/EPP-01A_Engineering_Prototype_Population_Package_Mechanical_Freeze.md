# EPP-01A — Engineering Prototype Population, Package, and Mechanical Datum Freeze

| Field | Value |
| --- | --- |
| Platform | IPC-100 Rev A |
| Review date | 2026-08-03 |
| Baseline | `ef85719` plus EPR-01/EPP-01 working-tree records |
| Scope | Physical-definition prerequisite to prototype footprint assignment |
| Schematic/footprint/PCB change | None |

## 1. Executive Summary

EPP-01A cannot freeze a physically implementable prototype baseline. The complete 313-row population register has been created, but 286 rows remain `BLOCKED - PHYSICAL DEFINITION REQUIRED`; only nine previously frozen passives can be marked `POPULATE - REQUIRED`. More importantly, the released schematic contains logical references that combine multiple physical devices or device-plus-support networks. A single footprint cannot truthfully implement those references, and decomposing them requires new physical references and pin-level connectivity.

The controlling examples are U401AB/U401CD/U402AB/U402CD/U403AB, each described as an LM339B-Q1 threshold implementation plus an SN74LVC14A-Q1 combine function; U403C/U403D combine comparator and gate functions; U501/U502 encode multi-gate opposing-PWM interlocks; U601 combines a window watchdog, two-edge qualifier and latch; U602 combines four-condition authorization logic; U701 combines three conditioning channels; and U703 combines four MOSFET channels and support elements. These cannot receive a package or footprint without silently inventing physical circuitry.

Additional Category A physical definitions remain open for the input fuse/protection set, exact critical magnetics/passives, relay, connectors, ESP32/module mechanics, USB-C receptacle, programming targets, and board mechanical datum. Production sourcing evidence is not the blocker.

The smallest prerequisite is **ECO-011 — Composite Physical Device Decomposition and Annotation**. It shall convert every composite placeholder into one-to-one physical references with exact logical connectivity and power units, without changing frozen external behavior. After ECO-011, the interrupted EPP-01A selection work can resume; this is not a request for another broad release review.

## 2. Scope

This package reviewed the current schematics, EBOM/AVL, ADR-039 through ADR-044, ICD-001/002, QER/PPQ/PAS/PACS evidence, ECO-006 through ECO-010, MIR-01, SSR-01R, EPR-01, EPP-01, open items, revision history, changelog and validation tooling. It records prototype population intent and identifies physical-definition gates. It does not assign footprints, create a PCB, place parts, route nets, procure parts, or authorize fabrication.

## 3. Current Baseline

| Item | Current state |
| --- | --- |
| EBOM rows | 313 unique references |
| Existing EBOM freeze state | 9 frozen / 127 blocked / 177 not yet frozen |
| EPP population state | 9 populate required / 4 DNP default / 11 DNP debug / 3 documentation only / 286 blocked |
| Schematic | Functional baseline released; composite physical blocks remain |
| Footprints | Zero assigned |
| PCB files | None |
| Architecture/GPIO/hierarchy | Frozen and structurally validated |

No production-grade two-source, quote or cost evidence was required to reach this decision. The failure is physical ambiguity, not commercial immaturity.

## 4. Prototype Population Plan

The normative register is [IPC100_RevA_Prototype_Population.csv](../bom/IPC100_RevA_Prototype_Population.csv). It disposes all 313 EBOM rows using exactly one permitted population status and records first-power, functional, safety, USB, motion, expansion and assembly-stage relevance.

| Status | Count | Disposition |
| --- | ---: | --- |
| `POPULATE - REQUIRED` | 9 | Previously frozen exact passives |
| `DNP - DEFAULT` | 4 | Explicit released DNP provisions |
| `DNP - DEBUG OPTION` | 11 | Schematic test nodes pending physical pad definition |
| `DOCUMENTATION ONLY` | 3 | DFT1 logical boundary and external module boundaries U704/U705 |
| `BLOCKED - PHYSICAL DEFINITION REQUIRED` | 286 | No stable one-to-one prototype package authority |

Assembly stages remain: A bare-board inspection; B power entry; C 3.3 V/core MCU; D USB/programming; E UI/sensors; F safety/watchdog; G relay/motion; H optional expansion. A blocked row is not permission to omit an electrically required function.

The production EBOM/AVL freeze fields are intentionally unchanged: EPP-01A did not approve any new physical row. Prototype status is carried in the separate keyed register so it can be joined by `Reference` without misrepresenting a blocked prototype choice as an approved production selection.

## 5. Composite Implementation Resolution

| Logical references/function | Minimum physical implication | Current mapping result | Required action |
| --- | --- | --- | --- |
| U401AB, U401CD, U402AB, U402CD, U403AB window functions | Comparator units plus Schmitt/combine gates and power units | Multiple device families hidden behind each logical row | ECO-011: allocate comparator/gate units and exact references |
| U403C, U403D command receivers | Comparator receiver plus `FIELD_OK` gate | More than one physical function per row | ECO-011 decomposition |
| U501, U502 motion interlocks | Inverters/AND logic for two PWM directions plus enable paths | No exact gate count, unit allocation or package | ECO-011 truth-table implementation and annotation |
| U503 authorization | `PERMIT AND NOT INHIBIT` plus disagreement-safe behavior | Generic functional block; exact gates/pins absent | ECO-011 physical logic mapping |
| U601 watchdog/qualifier/latch | Watchdog plus startup-edge qualification and retained validity | No single selected device proven to implement all functions | ECO-011 device/network decomposition |
| U602 four-condition authorization | Multi-input fail-safe logic | Generic function, no device/unit allocation | ECO-011 physical mapping |
| U701 encoder conditioner | Three channels with resistor/capacitor/gating behavior | Functional block not one physical selectable device | ECO-011 physical decomposition or explicit external rows |
| U703 status driver | Four 60 V MOSFETs plus gate networks/clamp provision | Four transistors hidden by one U reference | ECO-011 create physical Q references and reconcile support parts |

U504/U505 translators, U702 I²C expander, U706/U707 I²C buffers and U802 segment buffer may be selectable as single devices, but remain blocked until exact order codes, packages and pin maps are released. U704/U705 are external-module boundaries and remain documentation-only, not PCB footprints.

No footprint-count result can be frozen for the composite rows. The count must increase after ECO-011; concealing that increase in one EBOM row is prohibited.

## 6. Active Device Baseline

The current power-active candidate set is preserved, including Q101 `IAUC100N08S5N034ATMA1`, U101 `TPS26631PWPR`, U102 `TPS259470LRPWR`, U201 `LMR38020FSQDDARQ1`, U202 `TPS2121RUXR`, U203 `TPS62135RGXR`, U204 `SN74LVC1G08QDCKRQ1`, U205 `SN74LVC08AQPWRQ1`, U206/U207/U208/U210/U211 `TPS22918TDBVRQ1`, U209/U212/U213 `TPS2553QDBVRQ1`, U302 `TPS389030QDSERQ1`, U706/U707 `TCA9517ADGKR`, and U801 `TPS3899DL01DSER`.

Those candidates are not reopened for production commercial evidence. They remain blocked for prototype footprint authorization where official tool/passive/thermal/SOA evidence could still require a different value, package family, or implementation. Their package names in PACS records are selection inputs, not released footprints. Non-power active functions on Sheets 03–08 lack a complete exact-device register, and the composites above have no valid symbol-to-package mapping.

## 7. Passive Baseline

The nine frozen passives and the 67 PAS-01 freeze-eligible selections are preserved. C305 remains 93.1 nF ±1% C0G/NP0, and R222/R223/R224 remain 141 kΩ ±1%, ≤100 ppm/°C. No selected value is broadened.

EPP-01A does not issue `PROTOTYPE PACKAGE FROZEN` for the remaining passives because 17 power-dependent passives and the wider 177-row non-power scope are not reconciled to exact package/voltage/pulse/DC-bias/placement classes. Such a classification would be safe only after ECO-011 fixes physical unit loading and the prototype device set fixes the controlling circuits.

## 8. Magnetics

L101, L201 and L202 remain blocked: exact MPN, body, pad/drill geometry, height, shielding, hot DCR, saturation, loss and temperature-rise evidence are not frozen. FB801 retains the PAS candidate `BLM21PG221SN1D`, 0805 functional routing, but is not promoted beyond its controlled status. No magnetic footprint is authorized.

## 9. Protection Components

F101, D101–D104, Q102, D201–D210, D401–D407, D501–D508, D601, D801–D803 and D901/D902 require exact prototype parts or stable electrically bounded package classes. The current input TVS/fuse/eFuse/MOSFET hot-pulse coordination and several connector-entry clamps remain incomplete. Unknown pulse capability or polarity is a Category A blocker. PPC-01 production evidence may remain open later, but the first prototype’s actual protection parts may not.

## 10. Relay

K601 remains an Omron G5Q-1 DC5-class provisional function, not an exact relay. Exact manufacturer MPN, coil current/tolerance, SPDT pin pattern, contact rating for the 0–30 VDC/1 A resistive contract, life, height, orientation, keepout, flyback coordination and source status are absent. A generic relay footprint is prohibited.

## 11. Fuse

F101 remains “2 A time-delay (provisional)” with no exact fuse/holder, package, time-current curve, interrupt rating or service method. The selection among replaceable blade/cartridge, soldered fuse, resettable device or external inline protection is unresolved. This prevents physical freeze and safe prototype protection review.

## 12. Connector Freeze

J1–J10 and J13 retain released logical roles, but no complete board-side/mating/contact system is frozen. J1 has MIR-01 requirements but lacks order codes. J2/J3 are motion logic only; J4/J5 are returned safety loops; J6/J7 serve external OLED/sensor modules; J8A STOP must remain uniquely keyed from J8B UI; J9 is the isolated relay contact; J10 is optional/DNP; J13 is USB service. J11/J12 remain documentation-only and have no schematic rows or pads.

Exact board connector, mate, contact, pitch, orientation, current/voltage, wire range, keying, latch, height and mating/cable envelopes are Category A physical inputs. No “generic connector footprint” is accepted.

## 13. USB-C

J13’s complete electrical contact contract is released, but no exact receptacle, shell-stake pattern, board-edge position, insertion axis, height or mating envelope is selected. Therefore its duplicated D+/D−, CC, VBUS, ground, shell and unused-contact mapping cannot be verified against a manufacturer drawing. D901/D902 placement remains contingent on that selection. Repeated bench programming does not justify choosing an unverified or mechanically fragile receptacle.

## 14. Module and Programming Interface

U301 is described as ESP32-S3-WROOM-1-N8, but its exact orderable suffix, module drawing, antenna variant, castellated land, courtyard, height and antenna keepout are not released in the EBOM. DFT1 correctly remains a logical six-signal boundary. No pogo/Tag-Connect pattern, pitch, pad size, orientation, fixture keepout or enclosure-access geometry exists. EN/BOOT shall remain fixture-only and shall not become a field connector.

## 15. Board Outline

No controlled outline can be frozen until exact connector/module bodies and the physical component count after ECO-011 are known. A speculative outline would not satisfy the requirement that EPP-02 make no new mechanical decision. Board width, length, corner radius, USB edge, antenna edge, fuse access and connector coordinates remain open.

## 16. Mechanical Datum

The intended convention is top-side view, origin at the lower-left finished-board corner, +X to the right and +Y upward. It is not released because no dimensions exist. ECO-011 must precede mechanical envelope closure so component count and functional zones are real.

## 17. Mounting Holes

Four mechanically stable points remain preferred, but hole diameter, plated/non-plated state, coordinates, edge distance, M-size hardware, standoff, copper/component/screw/washer/tool keepouts and chassis-bond policy are unresolved. Layout may not improvise them.

## 18. Connector Edge Map

The qualitative separation remains valid: input power away from USB/sensitive signals; motor/relay away from UI/I²C; distinct safety connectors; accessible USB and fixture; unobstructed ESP32 antenna. Exact edge, center coordinate/range, insertion axis, mating/latch/unplug space and cable bend cannot be frozen without exact connectors and outline.

## 19. PCB Stack-Up Baseline

Four layers remain the minimum suitable prototype basis: FR-4, nominal 1.6 mm, 1 oz copper on all layers, continuous L2 ground and substantially continuous L3 power/return. This supports RF-module return control, USB, mixed currents and safety/noise segregation. Solder mask, finish, dielectric build, controlled-impedance construction, minimum drill/annular ring/trace-space, via-in-pad policy and plated-slot capability require a fabricator-specific release after exact packages. The provisional thermal Case B is retained, not promoted to a PCB release.

## 20. Electrical Design Rules

The QER current bases remain 1.25 A controller input, +5V_MAIN 1.5 A continuous/2 A for 100 ms, +3V3_CORE 1 A continuous/1.5 A for 100 ms, and protected branches up to 225 mA. USB requires a 90 Ω differential target once the actual stack-up is known. Numeric width/gap/via rules cannot be safely frozen without stack-up geometry, copper tolerances, exact pads and the relay isolation basis. Existing routing guidance remains valid but is not a design-rule release.

## 21. Placement Constraints

The EPP-01 constraints remain mandatory: entry protection in energy order at J1; compact U201/U203 power loops; quiet U302/C305 and U801 networks; connector-entry ESD; U706/U707 separated from ≥0.5 W heat sources; USB protection at J13; compact relay coil/flyback; isolated contact region; motor translators near J2/J3; quiet safety and watchdog routes; continuous reference plane; antenna keepout; accessible test points and mounting keepouts. Exact distances and orientations remain blocked by physical selections.

## 22. Test Access

TP701–TP705 and TP801–TP806 remain debug-pad candidates. Required additional access includes raw/protected input, 5 V, 3.3 V, power-good, reset, watchdog service/valid, permit/inhibit, relay command, motion pre/post gate, branch rails, J6/J7 and J10 bus sides, USB VBUS and non-loading D+/D− access, UART TX/RX, EN, BOOT and regional grounds. No pad diameter, pitch, side, fixture pattern or loading limit is frozen; DFT1 remains logical only.

## 23. Prototype Procurement List

No trustworthy board-quantity procurement list can be issued while 286 rows are physically blocked. Before footprint assignment, ECO-011 must define the real device count. Before PCB order, exact connectors, relay, fuse, module, magnetics, protection parts and footprint drawings must be obtainable. Before assembly, procure one- and three-board populations plus critical IC/magnetic/connector spares, mating housings/contacts, replacement fuses and mounting hardware. The programming fixture is required before bring-up. MOQ optimization remains deferred.

## 24. Category A Closure Matrix

| Original issue | Affected scope | Physical/package/mechanical decision | Remaining evidence | Status |
| --- | --- | --- | --- | --- |
| Exact one-to-one symbols/pin maps | Composite rows in Section 5 | No valid mapping; new references required | ECO-011 pin-level implementation | OPEN |
| Regulator/dependent-passive solution | U201/U203 and dependent L/C/R | Candidate packages only | Official equations/tool output and exact passives | OPEN |
| Input protection/hot SOA | F101, D101, Q101/Q102, U101 and support | No complete physical chain | Exact parts, curves and hot-fault coordination | OPEN |
| U801 threshold stack | U801, R806–R809, C804/C805 | Candidate device; physical stack not frozen | Exact passive/leakage corner | PARTIALLY CLOSED |
| Exact safety/watchdog implementation | Sheets 04–06 | Functional behavior released; devices composite | ECO-011 plus exact-device tolerance review | OPEN |
| Connector/module/mechanical choices | U301, U704/U705, J1–J10/J13, DFT1 | Logical contracts only | Exact systems, module drawings and envelope | OPEN |
| Relay and fuse | K601, F101 | Provisional classes only | Exact MPNs, mechanical/service and rating review | OPEN |
| Native ERC | Entire schematic | Structural validation only | Native ERC after physical ECO | PARTIALLY CLOSED |

Open Category A items prevent safe assembly or would make footprint assignment invent electrical/mechanical facts. EPP-01A acceptance is therefore prohibited.

## 25. Deferred Production Items

Two-source AVL maturity, formal quotes, volume price breaks, cost reduction, production panelization, process capability, production DFM/DFT, certification, EMC/environmental/HALT/reliability and long-term lifecycle qualification remain deferred. None caused the incomplete decision.

## 26. Risk Register

| ID | Risk | Consequence | Control |
| --- | --- | --- | --- |
| EPP01A-R01 | Several logical references hide multiple devices | Impossible or incorrect footprint/netlist | ECO-011 decomposition and annotation |
| EPP01A-R02 | 286 rows lack prototype physical definition | Layout makes uncontrolled part decisions | Resume EPP-01A only after ECO-011 |
| EPP01A-R03 | Protection/fuse/magnetics ratings and bodies open | Unsafe or invalid first power-up | Exact prototype selection and bounded analysis |
| EPP01A-R04 | Relay/connectors/USB/module mechanics open | Misfit, miswire or invalid enclosure/interface test | Exact mating systems and drawings |
| EPP01A-R05 | Outline/mounting/edge coordinates open | Placement cannot be configuration controlled | Mechanical freeze after physical device inventory |
| EPP01A-R06 | Production commercial evidence incomplete | Supply/cost exposure | Deferred; refresh for prototype obtainability only |

## 27. Validation Results

The population generator creates exactly 313 unique rows with required status and test-stage fields. The EPP-01A validator enforces the allowed status vocabulary, composite-row blocks, single incomplete decision, zero footprints and absence of PCB files. All existing repository validators and `git diff --check` are required at package close.

No schematic, footprint, PCB, GPIO, hierarchy, architecture, interface, ADR or ICD artifact is changed by EPP-01A. Native ERC is not required because no schematic changes occur; it remains required after ECO-011 and before physical release.

## 28. Final Decision

# EPP-01A INCOMPLETE

The smallest remaining prerequisite is **ECO-011 — Composite Physical Device Decomposition and Annotation**. It is a narrow schematic ECO for the references in Section 5, not a broad release review and not production-evidence work.

EPP-02 Engineering Prototype Footprint Assignment is not authorized. PCB placement, routing and fabrication remain unauthorized.

> **ECO-011 disposition (2026-08-03):** ECO-011 stopped before schematic edits because the released records do not define exact devices, Boolean/state tables, package-unit allocation or pin mapping for the composite blocks. ECO-011A — Composite Device Selection, Truth-Table, and Pin-Mapping Release is the smallest prerequisite.

> **ECO-011A1 Category A update:** The mandated LM339B-Q1/3.3 V safety-window combination cannot cover the released 2.5 V healthy and 4.0 V upper-threshold inputs within guaranteed common-mode range. QER-04 is the controlling Sheet 04 prerequisite.

> **QER-04 Category A update:** QER-04 accepted a guaranteed-range direct-input comparator and logic architecture and authorizes ECO-011A1R. The composites remain physically blocked until that ECO creates pin-level devices; EPP-01A-R and footprint assignment remain unauthorized.

> **ECO-011A1R Category A update:** Sheet 04 now contains physical devices and support passives; its seven composite rows are retired. The population register has 408 physical/logical rows. Sheet 04 footprint/passive/protection evidence remains blocked, and EPP-01A-R is still unauthorized while other composite categories remain.
