# EPP-01 — Engineering Prototype Preparation

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review date | 2026-08-03 |
| Baseline reviewed | `ef85719` plus EPR-01 working-tree release record |
| Review purpose | Determine readiness to begin Engineering Prototype footprint assignment and PCB preparation |
| Design changes | Documentation only |

## Executive Summary

IPC-100 Rev A is **not yet ready to begin footprint assignment**. The functional schematic, architecture, interfaces, GPIO allocation, safety ownership, and quantitative requirement framework are mature enough to support a focused physical-definition package, and no new electrical defect was found. The blocker is physical identity: the 313-row EBOM contains only 9 `FROZEN` rows, while 127 rows remain `BLOCKED` and 177 remain `NOT YET FROZEN`. Exact prototype parts, one-to-one physical decompositions, connector systems, module envelopes, and mechanical datums are not complete enough to bind symbols to land patterns without risking rework or an invalid prototype.

Footprint assignment must follow, not precede, a prototype-specific population and package freeze. Production-grade AVL depth, second sources, price optimization, formal DFM, certification, and reliability evidence remain deferrable to Rev B.

The smallest required next package is **EPP-01A — Engineering Prototype Population, Package, and Mechanical Datum Freeze**. It shall produce exact fitted/DNP decisions, physical device and package identities, connector/module choices, board-envelope and mounting datums, and a footprint-input constraint register. It shall not assign footprints or create a PCB.

## Engineering Prototype Scope

The future Engineering Prototype PCB is limited to serialized engineering units operated by qualified personnel for electrical, firmware, thermal, safety, communications, connector, mechanical, and functional validation. It is not a production, manufacturing, commercial, customer, or field release. The prototype may retain documented single-source parts, larger serviceable passives, additional test access, configurable DNP provisions, and conservative copper where these improve learning and safety.

This review does not authorize footprint assignment, PCB creation, placement, routing, fabrication, procurement, or energized testing.

## Current Design Status

| Design area | Status | EPP disposition |
| --- | --- | --- |
| Architecture, hierarchy, GPIO, ADRs and ICDs | Frozen; validators pass | Ready; preserve under ECO control |
| Functional schematic | SSR-01R approved with Major observations; no known incompatibility | Logically ready; native ERC still required before PCB release |
| Power requirements and models | QER-01/02/03, PEB-01, PPQ-01/02 complete | Sufficient input framework; exact part-dependent closure remains |
| Safety architecture | Hardware-priority safe defaults and authorization chain captured | Ready as architecture; exact physical devices and bench limits remain |
| EBOM | 313 rows: 9 frozen, 127 blocked, 177 not yet frozen | Not ready for footprint binding |
| Power-active selections | 20 candidate references/13 unique MPNs; no demonstrated selected-device failure | Packages are candidates, not released physical identities |
| Passive selections | 67 PAS candidates are freeze-eligible; dependent and other rows remain open | Candidate inputs only; not canonical footprint authority |
| Connectors/modules | Logical contracts defined; most exact systems/envelopes open | Blocks connector/module footprints |
| Test access | Eleven explicit TP rows plus logical DFT1 boundary | Physical target geometry and coverage matrix open |
| Mechanics | Maximum outline, mounting coordinates, plating/grounding, mating envelopes are TBD | Blocks PCB datum and connector footprint release |
| Thermal | Provisional four-layer Case-B baseline exists | Useful constraint input; exact pad/copper correlation remains |
| PCB | No PCB files; zero assigned footprints | Correctly not begun |

## Ready Components

Only the nine low-voltage 100 kΩ bias/enable resistors already marked `FROZEN` in the controlled EBOM/AVL are ready at the exact-part level. The 67 PAS-01 preferred passives are **freeze-eligible**, not frozen; they require prototype-population approval before footprint work. The 20 power-active references have plausible exact candidate MPNs and package families, but PACS-01R and its evidence packages retain them as blocked because thermal/tool, dependent-passive, transient, prototype, or commercial evidence remains open.

For EPP purposes, “ready” means an exact orderable prototype part, package, pin map, polarity, temperature/rating check, population state, and footprint-source requirement are all controlled. A generic package string or candidate MPN alone is not ready.

## Complete Footprint Population Inventory

The canonical row-level inventory is `docs/bom/IPC100_RevA_EBOM.csv`. Every fitted PCB item below needs a reviewed footprint; every DNP item still needs either a footprint or an explicit no-board disposition. `DFT1` is a logical fixture boundary and shall not receive a connector footprint. The inventory is grouped here without inventing land-pattern names:

- **Sheet 01 — Power Entry (35):** C101–C109; D101–D104; F101; L101; Q101–Q102; R101–R116; U101–U102.
- **Sheet 02 — Power Conversion (77):** C201–C221; D201–D210; L201–L202; R201–R231; U201–U213.
- **Sheet 03 — ESP32 Core (16):** C301–C306; R301–R305; SW301–SW302; U301–U303.
- **Sheet 04 — Safety Inputs (53):** C401–C413; D401–D407; R401–R424; U401AB/U401CD, U402AB/U402CD, U403AB/U403C/U403D, U404–U405.
- **Sheet 05 — Motor Interfaces (47):** C501–C506; D501–D508; R501–R528; U501–U505.
- **Sheet 06 — Relay/Master Inhibit (17):** C601; D601; K601; Q601; R601–R610; U601–U603.
- **Sheet 07 — UI/Peripherals (23):** C701–C705; Q701; R701–R705; TP701–TP705; U701–U707.
- **Sheet 08 — Expansion (26):** C801–C805; D801–D803; FB801; R801–R809; TP801–TP806; U801–U802.
- **Sheet 09 — Connectors/Test (19):** C901; D901–D902; J1–J7, J8A/J8B, J9, J10 and J13; R901–R903; plus logical non-board DFT1.

The ranges above are shorthand for the exact references in the EBOM and intentionally preserve split-unit references. No footprint is implied by this list.

## Custom-Symbol and Module Review

The `IPC100:` library prefix marks project-local symbols, not permission to create a matching generic footprint. Standard discrete abstractions may use controlled standard land patterns only after an exact part is released. The following need special physical review:

- **Composite/custom functional symbols:** U401AB/U401CD, U402AB/U402CD, U403AB/U403C/U403D, U404–U405, U501–U505, U601–U603, U701–U705, and U802. Each must map to a real one-to-one device/unit implementation; a composite functional block cannot receive a footprint as drawn unless all units are proven to be one physical package with a correct pin map.
- **Project-specific exact-device symbols:** U101, U102, U201–U213, U302, U303, U706–U707 and U801 require manufacturer pin/pad drawing verification; exposed-pad and bottom-terminated packages need paste, mask and thermal-via review.
- **ESP32 module U301:** exact module order code, antenna type, module courtyard, antenna keepout on all copper/mechanical layers, edge placement, height, shielding, programming/strap access, and enclosure clearance are mandatory.
- **Peripheral boundaries U704/U705:** the OLED and BME280 are external modules rather than generic board ICs; exact mating module, mounting, cable exit, dimensions, voltage/pull-up behavior and connector envelope must be released. They shall not receive fictional on-board module footprints if they remain harness devices.
- **Relay K601, fuse F101, switches SW301/SW302, magnetics L101/L201/L202 and protection devices:** body, lead, drill, height, keepout, current, thermal and assembly-process dimensions must be checked from exact order codes.
- **USB-C J13:** shell stakes, pad geometry, paste/mask, edge position, insertion envelope and mechanical retention must follow one exact receptacle.
- **DFT1 and TP701–TP705/TP801–TP806:** DFT1 remains non-BOM/non-board; its signals must map to individual pogo/test pads with probe, ground-return, fixture-clearance and no-paste rules.

## Outstanding Prototype Tasks

### Category 1 — Mandatory Before Footprints

1. Freeze the exact Engineering Prototype fitted/DNP population for all 313 rows; explicitly retire DFT1 as a physical connector and retain J10/J11/J12 policy consistent with the ICDs.
2. Resolve the 127 `BLOCKED` and 177 `NOT YET FROZEN` rows to an EPP status: `PROTOTYPE FIT`, `PROTOTYPE DNP`, `LOGICAL ONLY`, or `BLOCKED — NO FOOTPRINT`.
3. Release exact physical implementations for every composite/custom functional block on Sheets 04–08, including pin/unit mapping and unused-unit treatment.
4. Close prototype-critical power choices: U101/Q101 protection coordination, U201/U203 regulator and dependent-passive solution, U202 transition assumptions, U801 divider/leakage margin, critical capacitors and magnetics, and exact C305 selection.
5. Select exact U301 module, U704/U705 external modules, K601 relay, F101 fuse, SW301/SW302, magnetics, protection parts, USB receptacle, J1–J10 connector systems, contacts and mating housings.
6. Define package drawing revision, land-pattern source, mounting style, body height, polarity/pin-1, exposed pad, paste/mask, courtyard and assembly inspection needs for each exact part.
7. Define the prototype passive-size policy; retain 0603 where already justified and choose 0805/1206 or larger where voltage, pulse, effective capacitance, thermal, hand rework or creepage requires it.
8. Release prototype test-pad diameter/shape, pitch, mask/paste rules, paired ground pads and DFT net coverage.
9. Define maximum PCB envelope, board-edge datum, mounting-hole count/coordinates/diameters, plated versus non-plated policy, fastener stack, chassis/logic-ground intent and keepouts.
10. Define connector edge/height/orientation, latch/tool/mating/cable-bend envelopes and enclosure/service access sufficiently to verify connector footprints and courtyards.

### Category 2 — Mandatory Before PCB Layout

1. Release the board outline, mounting holes, mechanical origin, enclosure height map, edge restrictions, connector locations, USB opening, antenna edge/keepout and fixture datums.
2. Release a fabricator-capable four-layer stack-up based on 1.6 mm FR-4 and 1 oz copper, including dielectric thicknesses, material, finished thickness/tolerance, copper tolerances and controlled-impedance capability.
3. Establish net classes and design rules: minimum trace/space/drill/annular ring, mask sliver, copper-to-edge/hole, courtyard, via types, thermal relief policy and soldering constraints.
4. Calculate trace widths and via arrays for the 9–21 V entry, 1.25 A controller input, 5 V/1.5 A continuous and 2 A/100 ms paths, 3.3 V/1 A paths, 225 mA limited branches, relay coil and 0–30 VDC/1 A isolated contacts.
5. Release creepage/clearance rules for normal low-voltage domains, protected input, USB, and isolated relay contacts based on actual voltage, pollution degree, coating decision, altitude and applicable safety standard. Do not infer production isolation from the word “relay.”
6. Translate Case-B thermal assumptions into device-level copper/via constraints and placement separation; define any enhanced Case-C contingency regions.
7. Complete native KiCad ERC with exact symbols and classify all findings; complete schematic-to-BOM and pin-map peer review before PCB import.
8. Define PCB DRC, differential-pair rules, length/skew limits, return-plane rules, antenna/radio keepouts, switch-node keepouts, quiet-node zones and test-access constraints.
9. Release the prototype assembly process assumptions needed by footprints: board house limits, SMT/through-hole sequence, paste process, exposed-pad voiding target, x-ray needs and hand-rework allowances.

### Category 3 — Prototype PCB Guidance

- Zone the board in energy-flow order: battery/protection, power conversion, ESP32/RF, safety input conditioning, watchdog/authorization, motion translators, relay isolation, UI/sensors, then connectors/test access.
- Use a continuous L2 logic-ground plane and substantially continuous L3 power/return plane. Control noise by placement and current paths, not arbitrary digital/analog plane splits.
- Place connector-entry clamps directly at connectors with short, wide return paths. Keep high-energy current away from ADC, safety thresholds, reset and watchdog timing returns.
- Minimize buck input, switch and output current loops. Keep switch-node copper small and free of sensitive traces or planes as the selected regulator requires.
- Place every decoupling capacitor at its associated supply/ground pins with the smallest practical loop; place feedback, bootstrap, compensation, timing and threshold networks inside their device quiet zones.
- Keep `WATCHDOG_SERVICE_MCU`, reset, permit/inhibit and supervised-loop sense nodes away from PWM, relay, USB and switching-power edges. Avoid long parallel runs; maintain a continuous reference plane.
- Place motion translators near J2/J3 while keeping MCU-side and connector-side returns controlled. Keep opposing-channel routes distinguishable and testable.
- Place K601 at the isolated boundary. Keep contact copper outside logic regions, maintain released creepage/clearance, route coil/flyback as a compact loop, and do not reference contact copper to logic ground.
- Place Q101/U101/F101/D101 and bulk capacitors immediately behind J1 in energy order; avoid neck-downs and thermal relief in high-current paths.
- Keep temperature-sensitive U706/U707 at least 10 mm from ≥0.5 W sources unless thermal superposition is demonstrated.
- Preserve probe access for rails, safety-loop states, watchdog, reset, permit/inhibit, motion pre/post gate, relay gate/flyback, I²C, USB VBUS/CC and grounds.

### Category 4 — Deferred to Rev B

- Cross-manufacturer alternates, mature production AVL, volume pricing, cost reduction and supply-chain optimization.
- Production footprint consolidation, smallest-passive optimization, automated placement optimization and production panelization.
- Production DFM/DFT, bed-of-nails fixture release, AOI/x-ray process limits, stencil optimization, yield/capability studies and pilot manufacturing.
- Formal conformal-coating process, production enclosure/harness release, service documentation, work instructions, labels and packaging.
- EMC/radio/USB certification, ESD/immunity, HALT, reliability, environmental, ingress, vibration/shock, corrosion, UV and long-life qualification.

## Prototype PCB Constraints

The current planning baseline is four-layer, 1.6 mm FR-4 with 1 oz external and internal copper, continuous L2 ground and a compatible L3 power/return plane. This is not yet a released stack-up. The PCB shall reserve distinct zones and keepouts for the ESP32 antenna, switch nodes, connector ESD entry, isolated relay contacts, thermal spreading, mounting hardware, enclosure features and fixture access.

No placement may begin until the Category 2 rules are numeric and imported into the PCB tool. Optional provisions require controlled population notes; unreviewed “just in case” loading is prohibited on USB, safety, reset, watchdog or high-impedance analog nodes.

## Mechanical Constraints

Maximum board dimensions, outline, mounting-hole coordinates, plating and ground strategy remain TBD and are blocking. EPP-01A must define a board coordinate system and a controlled mechanical drawing containing:

- maximum X/Y/Z envelope and component-height map;
- mounting holes, fasteners, washers/standoffs, torque and conductive keepouts;
- connector position/orientation, latch/tool clearance, mating and unmating envelope, cable bend radius and strain relief;
- USB-C panel/access alignment and insertion load support;
- ESP32 antenna-to-edge/enclosure/battery/harness keepout;
- fuse and switch access, indicator sight lines, test-probe access and fixture datum/clamp zones;
- enclosure ribs, glands, condensation/drip considerations and prototype coating keepouts.

Product-level IP65 qualification is deferred, but the prototype must not make enclosure, connector or antenna testing meaningless.

## Thermal Constraints

Use provisional Case B as the prototype planning basis: four-layer 1.6 mm FR-4, 1 oz copper, continuous L2, compatible L3, approximately 900 mm² combined spreading for exposed-pad power devices, nine 0.20–0.30 mm finished thermal vias at 0.8–1.0 mm pitch, +75 °C enclosure air, natural convection, no airflow credit, board hot-spot target ≤90 °C and calculated junction target ≤110 °C.

Exposed pads require solid connections without thermal relief. U101/U201/U202/U203/U302/U801 require manufacturer pad and thermal treatment; Q101 requires the manufacturer 5 × 6 land, direct drain spreading and hot-pulse review. TPS2553 devices require recommended copper, separation from hot sources and prototype fault-temperature validation. The exact pad geometry and via-in-pad mask/fill decision belong to footprint review; thermal performance remains a prototype validation objective.

## Power Routing Constraints

- Preserve energy order from J1 through fuse, clamp, reverse/eFuse protection and bulk storage to conversion stages.
- Size entry copper and transitions for 1.25 A continuous and controlled fault/inrush cases; size +5V_MAIN for 1.5 A continuous/2 A for 100 ms and +3V3_CORE for 1 A continuous/1.5 A for 100 ms.
- Avoid thermal-relief spokes and narrow pad necks in high-current and exposed-pad power paths unless validated.
- Use parallel vias where current changes layers; calculate quantity from finished drill, copper plating, temperature rise and fabricator capability rather than a generic via-current rule.
- Keep regulator switch-node copper compact; keep input/output ceramic loops direct; Kelvin-route feedback/threshold sensing where recommended.
- Keep relay coil/flyback and connector fault currents out of logic, ADC, safety, reset and watchdog returns.
- Do not expose the first article to surge, sustained branch shorts or full relay load until the relevant protection/SOA review and staged test procedure are approved.

## Grounding Strategy

Use one deliberate continuous low-voltage logic reference plane. Separate noisy and quiet behavior through functional zoning, compact high-di/dt loops and controlled return paths. Do not cut the reference plane under USB, clocks, watchdog service, PWM, I²C or safety signals.

Return connector ESD clamps directly to the intended entry/ground region with minimal inductance. Return battery sensing and safety thresholds to quiet local ground. Keep isolated relay contact copper independent of logic ground. Maintain `USB_SHIELD` as a distinct enclosure-entry net with only the released DNP coupling/bleed options; EPP-01A must define the prototype enclosure/shield disposition.

## Signal Integrity Constraints

- Route fast signals over a continuous plane with minimal stubs and layer changes.
- Keep USB, reset, watchdog, threshold/timing, ADC and I²C routes outside switch-node, inductor, relay-contact and antenna coupling regions.
- Keep I²C branch routes short, preserve one base-bus pull-up pair, avoid uncontrolled test-pad capacitance, and place branch isolation devices at the ownership boundary.
- Route encoder and safety inputs as quiet connector-entry networks after their protection/conditioning devices; avoid long parallel runs with PWM or relay switching.
- Route PWM/motion channels with stable reference and spacing; preserve hardware interlock and authorization paths physically and provide pre/post-gate testability.
- Numeric crosstalk, impedance and length rules remain Category 2 inputs and must be defined before layout.

## USB Constraints

Select one exact J13 receptacle and D901 protection device before footprints. Place D901 immediately behind J13 with an extremely short return. Route D+/D− as a controlled 90 Ω differential pair using the released fabricator stack-up; match within the numeric skew limit established before layout, minimize vias, avoid stubs, and maintain a continuous reference plane. Keep pair geometry consistent through protection and connector break-out. Do not route under the antenna, through plane splits, adjacent to switch nodes or alongside relay/PWM edges.

Place independent CC resistors near J13. Keep VBUS protection at the entry and preserve upstream fuse/reverse-current ownership. Define shell tabs, edge position, panel clearance and `USB_SHIELD` coupling from the exact receptacle and enclosure concept. USB compliance testing is deferred, but a knowingly uncontrolled route is not acceptable for the prototype.

## Safety Constraints

The STOP/limit supervised loops, `RESET_VALID`, watchdog, `ACTUATOR_PERMIT`, `MASTER_INHIBIT`, motion gates and relay request path require physically quiet, reviewable routing. Their exact devices must preserve released polarity, thresholds, power-off behavior and deterministic defaults.

Keep safety sense/timing nodes short and away from connector transients, switch nodes, PWM, USB and relay flyback. Place protection at connector entries and conditioning close to its local reference. Avoid shared narrow returns with loads. Provide test access without materially loading high-impedance thresholds. Layout review shall trace the entire hardware authorization chain and confirm that no connector or firmware signal bypasses it.

## Connector Strategy

EPP-01A must select complete prototype connector systems—not headers alone—including board header/receptacle, mating housing, contacts, keying, latch, pitch, current/voltage/temperature rating, wire gauge, insertion cycles, retention, height, assembly process and cable exit.

- J1 must implement MIR-01 input requirements and protected-current envelope.
- J2/J3 remain external motor-driver **logic only**; motor power is prohibited.
- J4/J5 carry individually returned supervised limit loops.
- J6/J7 serve exact OLED/BME280 module harnesses with isolated branch behavior.
- J8A STOP must be uniquely keyed and incompatible with ordinary J8B UI.
- J9 carries isolated 0–30 VDC, 1 A resistive relay contacts; its spacing and labeling follow the released contact design.
- J10 remains optional/DNP unless its prototype need is explicitly approved.
- J11/J12 remain documentation-only with no pads.
- J13 is USB 2.0 UFP service only.

Connector edge positions and mating envelopes must be frozen before their footprints can be accepted.

## Programming Strategy

Primary firmware loading and service use J13 native USB. Recovery must also remain available through fixture access to UART0 TX/RX, EN, BOOT and ground; fixture access is sense/control only and shall never source the board’s 3.3 V rail. Strap GPIO behavior must be checked with fixture and board circuitry attached. Provide ground-first, keyed fixture operation and current-limited main/USB sources. Record board serial, hardware revision, firmware/test-image hash and programmed configuration.

DFT1 is a logical signal contract, not a connector footprint. EPP-01A shall map it to controlled pogo targets and mechanical datums.

## Test Strategy

Prototype test access shall cover protected input, +5V_MAIN, +3V3_CORE, switched branches, ground, reset, watchdog service/valid, permit/inhibit, safety-loop conditioned/fault states, motion commands before and after authorization, relay gate/flyback, I²C base/branches, USB VBUS/CC and connector continuity. Fast/noisy measurements need nearby ground pads.

Test pads require released probe type, pad geometry, mask opening, no-paste policy, pitch, keepout, expected loading and fixture access. Isolated relay contacts shall not be casually tied to fixture logic ground. Critical tests shall have numeric limits before execution; broader production test limits are deferred.

## Prototype Bring-up Plan

1. Verify assembly identity, DNP population, polarity, pin 1, soldering, isolation and resistance to ground.
2. Energize from a protected, current-limited bench source at nominal input with external drivers, relay load, J10 and field harnesses disconnected.
3. Confirm protected input, main/core rails, current draw, reset timing and inactive output defaults; stop for unexplained current or heating.
4. Load diagnostic firmware through USB or the independent recovery fixture and record configuration.
5. Validate reset, brownout, watchdog loss, STOP, limits, permit/inhibit and all motion/relay safe states before connecting actuators or loads.
6. Add UI, sensor, I²C, encoder and communications functions one at a time, including partial-power and stuck-bus cases.
7. Stage min/max input, load transient, source transition, branch current limit, reverse polarity and fault tests behind approved procedures.
8. Add external drivers and relay loads only after logic-level and isolation behavior passes.
9. Execute thermal/enclosure characterization from light to maximum intended prototype load.
10. Quarantine safety-significant failures and route required changes through an ECO/Rev B disposition.

## Deferred Production Activities

Production AVL maturity, approved alternates, formal quotes, price breaks, lifecycle depth, cost reduction, panelization, volume DFM, production fixtures, process validation, yield targets, formal coating/enclosure/harness release, certifications, EMC, environmental qualification, HALT and reliability remain deferred. Prototype evidence may inform but cannot automatically close those activities.

## Risk Register

| ID | Category | Risk | Required control | Entry effect |
| --- | --- | --- | --- | --- |
| EPP-R01 | Before footprints | 304 of 313 rows are not frozen | EPP-01A prototype population/package freeze | Blocks footprint assignment |
| EPP-R02 | Before footprints | Composite functional symbols may not represent one physical package | One-to-one physical decomposition and pin-map review | Blocks affected footprint |
| EPP-R03 | Before footprints | Connector/module/fuse/relay/magnetics identities and envelopes open | Exact prototype selection and drawings | Blocks affected footprint |
| EPP-R04 | Before footprints | Critical power passives and thermal/SOA dependencies remain | Close minimum prototype calculations or explicit safe constraint | Blocks affected footprint/fabrication |
| EPP-R05 | Before layout | Board outline and mounting datums are TBD | Controlled mechanical datum drawing | Blocks PCB creation/placement |
| EPP-R06 | Before layout | Stack-up/design rules/creepage/current rules are not numeric | Fabricator-aware PCB constraint specification | Blocks layout |
| EPP-R07 | Before layout | Native ERC remains unavailable/unrun | Run with exact symbols and classify findings | Blocks PCB release |
| EPP-R08 | Prototype | Provisional thermal model may not correlate | Case-B layout plus staged thermal measurement | Prototype validation objective |
| EPP-R09 | Prototype | USB/RF/mechanical integration may underperform | Exact constraints, test access and engineering validation | Prototype validation objective |
| EPP-R10 | Rev B | Single-source/commercial/production-process exposure | Production AVL, DFM/DFT and qualification program | Deferred; no production claim |

## Validation Results

EPP-01 requires execution of every repository `validate_*.ps1` script and `git diff --check`. The validators cover hierarchy, GPIO, interface contracts, ECO corrections, component evidence, BOM/AVL consistency and the intentional zero-footprint state. They do not replace native ERC, manufacturer pin-map review, footprint review or PCB DRC.

The EPP-01 change is documentation-only. It modifies no schematic, assigns no footprint, creates no PCB, and changes no GPIO, hierarchy or architecture artifact. Existing EPR-01 documentation is preserved.

## Prototype PCB Entry Criteria

### Gate A — Entry to EPP-02 Footprint Assignment

All of the following must be complete:

- EPP-01A approves one prototype population state for every EBOM row;
- every `PROTOTYPE FIT` item has exact manufacturer, order code, package and verified pin map;
- every composite function is mapped to real physical devices/units;
- exact connector/module systems and their mechanical envelopes are released;
- critical power-dependent values/packages and thermal-pad inputs are closed sufficiently for land-pattern selection;
- board envelope, mounting-hole datums and connector-edge datum requirements are released;
- the footprint-input register defines source drawing, revision, courtyard, height, polarity, pad/paste/mask, thermal and inspection requirements;
- no known electrical incompatibility remains.

### Gate B — Entry to PCB Layout

After EPP-02, require reviewed footprint assignment, native ERC closure, schematic/BOM/footprint reconciliation, mechanical datum import, released stack-up and numeric PCB design rules, net classes, thermal/current/via constraints, creepage/clearance, RF/USB/noise keepouts and prototype DFT strategy. Only a separate PCB-entry review may authorize placement and routing.

## Final Decision

# EPP-01 INCOMPLETE

The single smallest package required before footprint assignment is **EPP-01A — Engineering Prototype Population, Package, and Mechanical Datum Freeze**.

EPP-02 Engineering Prototype Footprint Assignment is not authorized. No PCB work is authorized.

> **EPP-01A disposition (2026-08-03):** EPP-01A is incomplete because composite logical references cannot map one-to-one to physical devices. ECO-011 — Composite Physical Device Decomposition and Annotation is the smallest prerequisite before EPP-01A can resume.

> **ECO-011 update:** Physical decomposition remains incomplete; ECO-011A must first release the exact device, truth/state-table, unit-allocation and pin-mapping inputs. Footprint assignment remains unauthorized.
