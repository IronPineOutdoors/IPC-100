# MFG-01 — Rev A Schematic Manufacturing & Testability Review

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review | MFG-01 |
| Date | 2026-07-30 |
| Review type | Manufacturing readiness, DFM, DFT, serviceability, and PCB-entry assessment |
| Architecture baseline | ADR-039 through ADR-044 |
| Schematic baseline | Package 01 through Package 07R |
| Decision | **READY WITH MAJOR MANUFACTURING OBSERVATIONS** |

## Executive Summary

The IPC-100 Rev A functional core through Sheet 06 is sufficiently coherent to continue PCB-oriented schematic development. Power ownership, processor allocation, supervised safety inputs, motion-command conditioning, independent watchdog servicing, hardware authorization, and relay actuation have controlled interfaces and fail-safe intent. ECO-001 and ECO-002 corrected the known authorization defects, DFR-01R verified the connectivity correction, and ECV-001 verified deterministic Sheet 05 authorization defaults.

No new Critical architecture or functional defect was found. The design is **not** ready for footprint assignment, placement, routing, fabrication, energized prototype test, or manufacturing release. Major work remains:

- exact orderable component and footprint selection;
- native KiCad ERC;
- complete quantitative power budget and thermal analysis;
- exact watchdog/logic/relay/clamp implementation validation;
- safety-loop tolerance and transient closure;
- external-driver compatibility;
- connector partitioning, families, ratings, and pinout release;
- test-access architecture on Sheet 09;
- mechanical envelope, keepouts, ingress boundary, and harness rules.

These are major manufacturing observations and release gates, not reasons to reopen ADR-039 through ADR-044. Package 08 may proceed with Sheet 07 User Interface & Local Controls. PCB placement and routing remain unauthorized.

## Review Basis and Frozen-Boundary Check

| Controlled record | Manufacturing relevance | Review result |
| --- | --- | --- |
| ADR-039 | Main/USB rail ownership, request-controlled branches, main qualification | Preserved |
| ADR-040 | ESP32 allocation and interface ownership | Preserved |
| ADR-041 | `MAIN_POWER_GOOD` excluded from firmware | Preserved |
| ADR-042 | Field safety-input and authorization contract | Preserved |
| ADR-043 | Eight-channel motion boundary and fault ownership | Preserved |
| ADR-044 / AR-06 | Dedicated GPIO42 watchdog-service route and timing contract | Preserved |
| Package 01 | Hierarchy and sheet ownership | Suitable foundation; Sheets 07–09 remain incomplete |
| Packages 02/03R | Power entry and conversion | Functional capture complete; exact-part/thermal release open |
| Package 04R | ESP32 core, recovery, USB/UART handoff | Functional capture complete; RF/mechanical/fixture release open |
| Package 05R | Supervised safety inputs | Functional capture complete; tolerance/transient release open |
| Package 06R | Motion translation and hardware suppression | Functional capture complete; external-driver validation open |
| Package 07R | Watchdog, authorization, and relay control | Functional capture complete; exact-device/timing/stress release open |
| DFR-01 / DFR-01R | Integrated electrical defects and ECO-001 verification | Known Critical connectivity defect corrected |
| ECO-001 / ECO-002 / ECV-001 | Authorization connectivity and deterministic defaults | Corrections preserved; native ERC still required |

Recommendations below do not change signal ownership, polarity, hierarchy, GPIO allocation, authorization equations, or motion boundaries.

## Power Review

### Distribution and service entry

The protected 9–21 V input architecture and bounded USB-only service path are appropriate for an outdoor controller. Before physical design:

- Establish the controller continuous, peak, startup, and fault-current budget. J1, fuse, protection FET/eFuse, copper, vias, and connector contacts must all use the same released current envelope.
- Keep the product fuse or replaceable fuse accessible without removing the PCB. If the PCB contains a secondary fuse, orient it for tool access and mark rating, voltage, interrupt rating, and replacement type on silkscreen.
- Do not route battery current through narrow connector-neck or thermal-relief geometry. Use short, wide entry paths with parallel vias where layers change.
- Route protected high-current returns directly to the entry return region. Relay-coil and regulator switching currents must not share narrow return paths with ADC, safety thresholds, reset, or watchdog timing.
- Provide current-limited bench-power entry and measurement access that does not bypass reverse, overvoltage, or fuse protection.

### Placement implications

- Place input fuse/protection, TVS, reverse protection, and input bulk capacitance immediately behind J1 in energy-flow order.
- Keep the high-di/dt buck input loop and switch-node copper compact. Do not place the ESP32 antenna, battery-sense divider, safety comparators, USB data, I²C, or watchdog timing node beneath or adjacent to switch nodes.
- Place source-selection and reverse-current-blocking devices so their thermal paths and current paths remain direct.
- Place each regulator’s input/output ceramics at the pins specified by its released data sheet; layout-sensitive feedback components belong inside the regulator quiet zone.
- Place local 100 nF bypass capacitors at every logic, comparator, translator, supervisor, watchdog, and expander supply pin. Bulk capacitors do not replace local bypass.
- Keep the battery-sense divider/filter away from relay, buck switch, and motor-command edge paths; guard it with ground and provide a quiet ADC return.

### Sequencing and transient robustness

The architecture properly prevents USB-only service from energizing main-only outputs. Production validation must cover every main/USB connection order, brownout, fast interruption, slow ramp, reverse connection, and main-source chatter case.

The abnormal-input profile remains incomplete. Before layout release, define source impedance and energy for:

- reverse battery;
- jump/adapter overvoltage;
- inductive cable disconnect;
- ESD/EFT at external interfaces;
- 60 V energy-limited survival claim;
- repeated surge duty and TVS thermal recovery.

Protection parts must be selected by pulse energy and clamping voltage, not nominal standoff voltage alone.

### Thermal risks

Major thermal contributors are the input protector, 5 V converter, 3.3 V converter, source selector, relay coil, and externally supplied interface power. Required work:

- worst-case loss calculations at 9 V and 21 V, hot ambient, minimum airflow, and enclosure solar loading;
- copper-area and thermal-via requirements from vendor tools;
- simultaneous-load analysis including radio bursts, relay coil, OLED/UI, sensors, and both external-driver logic interfaces;
- temperature measurement points on prototypes;
- derating to the intended sealed-enclosure ambient.

### Power finding

**Major:** the functional topology is suitable, but current budget, exact magnetics/passives, transient energy, copper sizing, and enclosed thermal performance remain open. These block placement release.

## Connector Review

Connector choice shall separate the PCB connector, enclosure feedthrough, and field harness connector. A board connector inside a sealed enclosure need not itself provide IP67; an externally exposed board connector must.

### Recommended provisional families

| Interface | PCB-side recommendation | Field/enclosure recommendation | Key manufacturing notes |
| --- | --- | --- | --- |
| J1 battery input | Molex Micro-Fit 3.0 or Mini-Fit Jr only after current/temperature derating | Deutsch DT/DTM, TE AMPSEAL, or sealed equivalent | Two-pole keyed, positive latch, first-mate/last-break not assumed; 16–18 AWG provisional pending current |
| J2/J3 driver logic | Keyed 6-circuit Micro-Fit 3.0 | Sealed DTM or product harness transition if externally exposed | 20–24 AWG; separate from motor power; unique keys/colors for axes |
| J4/J5 supervised limits | Keyed 4-circuit Micro-Fit 3.0 | Sealed DTM 4-way or equivalent | 22–24 AWG; preserve individual returns; distinct keying from powered outputs |
| J6 OLED | JST-GH 1.25 mm locking or Molex Pico-Lock | Product-local protected harness | 26–28 AWG; short cable; pin 1 visible; not a field bus |
| J7 sensor | JST-GH/Pico-Lock, keyed differently from J6 | Product-local protected harness | Avoid accidental swap with OLED; airflow/condensation placement owned by product |
| J8 mixed UI | **Partition before release** | Separate sealed STOP/control and non-safety UI harnesses | Do not retain one 14-way mixed connector without a formal harness and mis-mate justification |
| J9 relay contacts | Pluggable 5.08 or 7.62 mm terminal block, pitch set by released rating | Rated sealed panel connector where required | Finger-safe, touch-safe as needed; maintain creepage/clearance and isolation slot options |
| J10 local I²C | JST-GH/Pico-Lock only if retained | Internal/local only | Short, controlled cable; no hot-plug claim until protected |
| J11 spare GPIO | Omit from released Rev A unless GPIO37 contract is approved | None | Do not fabricate an ambiguous universal-GPIO promise |
| J12 CAN/RS485 | No production connector in Rev A without transceiver decision | Interface-specific sealed connector later | CAN and RS485 must not share an undefined pinout |
| J13 USB-C | USB-C receptacle with through-hole shell stakes and documented mating cycles | Gasketed service opening or internal service access | USB 2.0 device, CC resistors, low-capacitance ESD, shield strategy, strain relief |
| Factory test | Pogo-pad field plus Tag-Connect-compatible recovery pattern | Not field exposed | Keyed fixture, no loose friction header required in production |

These are family recommendations, not selections or footprint authority.

### Pin numbering and keying rules

- Make pin 1 mechanically and visually unambiguous on PCB, mating housing, drawing, and harness.
- Put return adjacent to each high-speed, noisy, or supervised signal where conductor count permits.
- Do not use identical keyed housings for J1, J9, safety loops, and powered logic interfaces.
- Avoid placing supply on a pin that can contact before return during partial insertion unless fault analysis proves it safe.
- Reserve cavities rather than renumbering released connectors if modest future growth is credible.
- Publish mating face, wire-side, and PCB-view drawings; never rely on one ambiguous view.

### Harness and field service

- Provide strain relief outside solder joints and board headers.
- Maintain service loops without allowing conductors to enter the ESP32 antenna keepout or regulator/relay hot zones.
- Use crimp terminals and controlled applicators for production; hand-soldered wire-to-board connections are prototype-only.
- Apply cavity seals, backshells, boots, glands, or enclosure feedthroughs according to the actual ingress boundary.
- Define wire gauge, insulation temperature, flex class, color code, shield/drain termination, maximum length, and routing class per interface.
- Make replaceable harness modules for battery input, paired limit loops, front-panel controls, external motor-driver logic, and relay contacts.

### Connector finding

**Major:** connector families, J8 partitioning, J9 contact rating, J13 implementation, J10/J11/J12 disposition, and harness specifications are not released. Sheet 09 and mechanical definition must close these before PCB connector placement.

## Testability Review

Production test can cover the functional core if dedicated access is designed into Sheet 09 and the PCB. The present functional sheets do not by themselves establish production access.

### Required test nodes

| Function | Required probe nodes | Test purpose |
| --- | --- | --- |
| Input power | `VIN_RAW`, protected VIN, `GND` | Current limit, reverse/OV protection, drop |
| Rails | `+5V_MAIN`, `+3V3_CORE`, each switched branch, USB VBUS/protected USB | Regulation, ripple, sequencing, leakage |
| Status | `MAIN_INPUT_VALID`, `MAIN_POWER_GOOD`, `RESET_VALID` | Threshold and sequencing verification |
| Programming | USB D+/D−, UART0 TX/RX, ESP_EN, ESP_BOOT, GND, 3V3 | Recovery, flashing, fixture control |
| Watchdog | `WATCHDOG_SERVICE_MCU`, `WATCHDOG_VALID`, timing node | Window, timeout, startup, latch recovery |
| Authorization | `STOP_HW_INHIBIT`, `ACTUATOR_PERMIT`, `MASTER_INHIBIT` | Truth table and fault response |
| Relay drive | `RELAY_CMD_MCU`, authorized gate, Q1 gate, coil-low, `RELAY_VCC` | Gate behavior, coil current, flyback waveform |
| Relay contacts | NC, COM, NO isolated fixture terminals | Contact state/resistance and isolation |
| Safety loops | Each raw, sense, conditioned, and local fault node | Healthy/open/short/wrong-resistance windows |
| Motion | Eight MCU commands and eight safe-side outputs | Direction suppression, inhibit, translation |
| I²C/UI | SDA, SCL, expander reset/power, OLED/sensor branch power | Bus, address, stuck-line, branch switching |

Use round or rectangular bare copper pads sized for the selected pogo probes. Provide nearby ground pads for oscilloscope spring grounds at switch nodes, watchdog timing, USB, PWM outputs, and flyback measurements.

### Indicators

Production indicators should not create new safety dependencies. Recommended assembly/debug indications, preferably driven from already approved diagnostic ownership:

- core 3.3 V present;
- main 5 V qualified;
- fault/inhibit status;
- fixture-controlled test mode.

Do not add an LED directly to high-impedance safety, watchdog timing, USB, ADC, or oscillator nodes. LED states are aids, not acceptance evidence.

### Testability finding

**Major:** test access is not yet captured because Sheet 09 is incomplete. A fixture can be designed, but pad geometry, probe clearance, bed-of-nails datum features, and test-only net disposition must be frozen before placement.

## Serviceability Review

### Field troubleshooting

Provide a service flow based on externally observable symptoms and safe measurements:

1. Verify fuse and protected input.
2. Verify core/main rail status.
3. Confirm reset and watchdog state.
4. Confirm STOP and supervised-loop state.
5. Confirm permit/inhibit state.
6. Confirm relay or motion command at MCU and safe sides.
7. Replace the smallest harness/module consistent with the fault.

Avoid requiring energized probing near relay contacts or battery entry for ordinary diagnosis.

### Replacement policy

- The fuse is the primary field-replaceable electrical item and must be accessible, labeled, and mechanically retained.
- Treat the PCB as a replaceable module unless a business case supports socketed or field-replaceable relay service.
- A socketed relay increases height, mass, contact count, vibration risk, and cost. Prefer a soldered relay plus board replacement for sealed outdoor products unless relay duty predicts frequent wear.
- OLED, sensor, front-panel controls, limit harnesses, external motor drivers, and battery adapters should remain harness-removable modules.
- Firmware update must remain possible through USB-C and the independent recovery fixture path.

### Likely field failures

Highest-probability field/service items are:

- fuse and battery adapter contacts;
- external harness crimps, seals, and connector latches;
- limit switches and EOL terminations;
- STOP switch/harness;
- relay contacts under unsuitable loads;
- USB receptacle mechanical damage;
- OLED/sensor moisture exposure;
- external motor-driver modules;
- surge-protection parts after severe electrical events.

### Labeling and silkscreen

Required markings include board name, `IPC-100`, Rev A, serial/lot field, assembly revision, pin 1, connector function, voltage domain, polarity, fuse rating, relay contact NC/COM/NO, USB, test-point names, high-voltage/isolated boundary, antenna keepout, and “no motor power” at J2/J3 if ambiguity is possible.

Use durable assembly labels or laser marking for data that solder-mask silkscreen cannot carry. Provide QR/data-matrix linkage to controlled test and configuration records if production volume supports it.

### Serviceability finding

**Minor:** the modular architecture supports board-level replacement, but physical access, enclosure placement, labeling, connector retention, and fuse/USB tool clearances must be incorporated into the mechanical design.

## PCB Layout Recommendations

### Functional zoning

Use explicit board zones:

1. battery entry and surge protection;
2. switching power and source selection;
3. ESP32 core/RF;
4. safety input conditioning;
5. watchdog and authorization;
6. motion translators and external-driver interface;
7. relay coil/contacts;
8. low-speed UI/sensors;
9. connectors and test access.

### Critical placement

- Place the watchdog, timing component, authorization logic, and their bypass capacitors together, away from relay flyback, switch nodes, USB, antenna, and long connector traces.
- Keep `WATCHDOG_SERVICE_MCU` away from PWM and relay-drive edges; do not route it parallel over long distances without ground reference.
- Place Sheet 05 translators near the external-driver connector boundary while retaining a quiet logic-side return.
- Place input clamps and ESD parts at connector entry before traces enter the logic region.
- Put the relay at the isolation boundary with contact copper separated from coil/logic copper. Apply creepage/clearance from the released contact rating, pollution degree, coating policy, and applicable standard; do not assume low-voltage spacing.
- Keep relay contact routing out of inner logic areas. Consider slots only after fab capability and creepage requirements are controlled.

### Ground strategy

A continuous logic ground plane is preferred over arbitrary analog/digital plane splits. Control current paths by placement and routing:

- keep switch/relay high-current loops compact;
- return ADC divider and safety thresholds to quiet local ground;
- do not cut reference planes under USB or other fast signals;
- prevent contact-domain copper from referencing logic ground;
- define shield/chassis coupling at the enclosure entry rather than scattering shield connections.

Separate “power island” placement is appropriate for noisy conversion and relay sections, but the low-voltage logic ground should remain a deliberate continuous reference unless analysis proves a split is required.

### EMI and ESD

- Preserve the module antenna manufacturer keepout on every copper and mechanical layer; keep harnesses, battery, enclosure metal, and service loops clear.
- Route USB as a controlled differential pair with minimal stubs and protection close to J13.
- Treat all field connectors as ESD entry points.
- Keep clamp return paths short and direct to the intended return plane.
- Provide optional stuffing positions only when each population is documented and validated; avoid “just in case” capacitors on safety or high-speed nodes.

### PCB finding

**Major:** zoning guidance is clear, but board envelope, layer stack, copper weight, current limits, connector positions, isolation rating, antenna environment, thermal model, and test-fixture datums are not frozen. Placement may not begin until these inputs exist.

## Assembly Review

### Assembly risks

- Avoid unnecessary mixing of very small passives with large through-hole connectors and relay parts. Use a preferred passive size appropriate for the assembler and outdoor rework policy; 0603 is a reasonable production baseline, with 0805/1206 for high-voltage, pulse, power, or hand-rework needs.
- Keep polarized components consistently oriented where routing allows. Mark diode cathodes, electrolytic polarity, IC pin 1, relay orientation, and connector pin 1.
- Provide sufficient courtyard and nozzle clearance around the ESP32 module, inductors, relay, terminal blocks, USB shell tabs, and protection parts.
- Separate reflow SMT and selective/wave-solder through-hole processes in the assembly plan.
- Avoid hand-solder-only production features.
- Keep tall parts clear of enclosure ribs and fixture clamps.
- Provide access for terminal-block screws, connector latches, fuse pullers, and USB insertion.

### Inspection and rework

- Make solder joints visible where possible.
- Provide solder-mask dams and thermal balance for fine-pitch or exposed-pad devices.
- Add fiducials appropriate to panel and board size.
- Define x-ray inspection for hidden thermal pads or bottom-terminated packages.
- Keep test pads out of paste unless explicitly used as solderable lands.
- Do not place critical parts under the ESP32 module antenna or beneath non-removable connectors.

### Assembly finding

**Minor:** no intrinsic assembly showstopper is visible at functional-capture level. Risk depends heavily on later footprint selection and mechanical placement.

## DFT Recommendations

### Manufacturing test flow

1. **Incoming/visual inspection:** revision, polarity, population, solder quality, contamination, connector keying.
2. **Unpowered tests:** input-to-ground resistance, rail shorts, relay contact passive state, isolation resistance where applicable.
3. **Current-limited power entry:** ramp main input at a nominal midrange voltage; enforce maximum inrush and quiescent-current limits.
4. **Rail test:** measure protected input, 5 V, 3.3 V, switched branches, ripple, and power-good states.
5. **USB-only test:** connect USB with main absent; verify programming access and that relay/motion/main-only rails remain off.
6. **Program fixture firmware:** use USB or controlled UART0/EN/BOOT recovery; record silicon identity, board revision, and firmware checksum.
7. **Safety input test:** fixture each supervised loop through healthy, open, short, and invalid resistance states; verify conditioned and hardware-inhibit behavior.
8. **Watchdog test:** generate valid transitions, static levels, early/late transitions, and service loss; verify two-edge startup, timeout, latch, and reset recovery.
9. **Authorization truth table:** exercise main-good, STOP, reset, and watchdog qualifiers; verify permit/inhibit and no bypass.
10. **Relay test:** command off/on with and without permit; measure coil current, contact state/resistance, release time, and clamp waveform on engineering samples.
11. **Motion interface test:** verify all eight channels, opposing-PWM suppression, translator isolation, defaults, and authorization loss.
12. **Peripheral/I²C test:** enumerate UI/sensors, verify switched-power requests, stuck-bus recovery, and safe defaults.
13. **Communications/RF sample test:** USB integrity on every unit; Wi-Fi/Bluetooth production test strategy and RF sample/lot coverage before production.
14. **Final acceptance:** restore production firmware/configuration, clear test states, record results, label serial/lot, and perform final visual inspection.

### Expected nominal measurements

These are planning targets, not released limits:

- `+3V3_CORE`: nominal 3.3 V;
- main logic rail: nominal 5 V;
- WDI pull-down load at high: approximately 33 µA;
- watchdog service: 75 ms nominal transition interval;
- watchdog loss response: no more than 250 ms;
- relay coil: approximately 80 mA and 0.40 W on the provisional basis;
- relay MOSFET conduction loss: approximately 12.8 mW at the provisional 2 Ω bound.

Released min/max limits must come from exact devices, tolerance analysis, and prototype data.

### Fixture requirements

- Keyed pogo fixture with mechanical datums independent of connector tolerances.
- Replaceable probe blocks for high-cycle pads.
- Kelvin or four-wire contact-resistance measurement where relay limits require it.
- Programmable loop-resistance matrix for supervised inputs.
- Independently controllable main and USB sources with current measurement.
- Capture channels for watchdog, permit/inhibit, relay gate, and flyback.
- Galvanically appropriate relay-contact test circuitry; do not connect isolated contacts casually to fixture logic ground.
- Fixture self-test, calibration interval, software revision control, and golden-board correlation.

## DFM Recommendations

### Component availability and sourcing

Before footprint creation, every active, relay, magnetics, connector, fuse, and protection device needs:

- exact manufacturer part number and approved alternates;
- lifecycle and lead-time review;
- distributor availability;
- temperature and moisture sensitivity rating;
- automotive qualification only where the requirement genuinely calls for it;
- package/footprint drawing verification;
- counterfeit-risk and incoming-inspection strategy for constrained parts.

Single-source risks are currently highest for the exact ESP32 module, power ICs, watchdog/qualifier implementation, relay, sealed connectors, and custom harness terminals.

### Footprint policy

- Use IPC land-pattern methodology and manufacturer recommendations, reconciled with the actual assembly process.
- Maintain one controlled library source with courtyard, pin-1, assembly, paste, thermal-pad, and 3D checks.
- Do not release generic “class” symbols to layout. Every fitted item requires an orderable part.
- Prefer common passive sizes and voltage ratings; do not over-consolidate when pulse, creepage, noise, or rework needs differ.
- Verify relay and connector drill tolerances against the selected fabricator.

### Cost and automation

Potential later cost reductions include consolidating passive values, reducing connector families, using resistor arrays for noncritical biases, and depopulating optional interfaces. None should be applied before tolerance, fault-containment, fixture, and service impacts are reviewed.

For prototypes, larger passives, accessible test pads, pluggable connectors, and configurable links are acceptable when documented. Production should eliminate hand-installed wires, ad hoc bodges, and ambiguous optional populations.

### DFM finding

**Major:** the design contains functional component classes rather than a released AVL/BOM/footprint set. Procurement and assembly readiness cannot be claimed until exact parts and alternates are qualified.

## Remaining Risks

### Critical

No new Critical finding was identified in this manufacturing review. A later exact-part, ERC, tolerance, or prototype review may still reveal a Critical defect.

### Major

| ID | Category | Risk | Required disposition |
| --- | --- | --- | --- |
| MFG-01-M01 | Schematic | Native ERC has not run on the completed functional core | Run and disposition native KiCad ERC before schematic release |
| MFG-01-M02 | Schematic | Power, watchdog, safety, translator, relay, and clamp blocks retain provisional/exact-part work | Select parts and complete worst-case/tolerance/fault review |
| MFG-01-M03 | PCB | Power budget, thermal model, copper current, layer stack, and transient-energy profile are open | Close before placement |
| MFG-01-M04 | PCB | Connector positions, families, pinouts, ratings, J8 partition, and mechanical envelope are open | Complete Sheets 07–09 and mechanical/harness reviews |
| MFG-01-M05 | PCB/DFT | Production test pads, fixture datums, probe clearance, and isolated-contact test method are not captured | Freeze DFT architecture before placement |
| MFG-01-M06 | Prototype | Safety-loop thresholds, watchdog window, brownout, partial power, relay flyback, and external-driver behavior lack hardware evidence | Execute quantitative prototype validation and fault injection |
| MFG-01-M07 | Manufacturing | No released BOM, AVL, alternate strategy, or controlled footprints exist | Complete sourcing and library release before fabrication |
| MFG-01-M08 | Service/PCB | RF antenna environment, enclosure ingress boundary, harness routing, and service access are not defined | Complete mechanical integration before placement |

### Minor

| ID | Risk | Recommendation |
| --- | --- | --- |
| MFG-01-m01 | Silkscreen, labeling, and serialized traceability are not specified | Create assembly and service marking standard |
| MFG-01-m02 | Fuse, USB, terminal, and latch tool access is not proven | Include access envelopes in mechanical CAD |
| MFG-01-m03 | Preferred passive size and through-hole assembly process are not selected | Align with contract manufacturer before library release |
| MFG-01-m04 | Field-replacement level for relay versus board is not formally chosen | Default to board replacement unless relay-life analysis justifies a socket |

### Observations

- The separation between reusable IPC-100 logic and product-owned motor power/load hardware materially improves manufacturing modularity.
- Deterministic local biasing on authorization and watchdog interfaces supports fixture testing and partial-assembly safety.
- Keeping raw GPIO names local to Sheet 03 improves test-document stability.
- The generic relay interface avoids CrossWind-specific manufacturing assumptions.

## Recommended Design Improvements

The following are recommendations within the frozen architecture:

1. Split J8 into a dedicated safety/control connector and one or more low-risk UI/indicator connectors.
2. Omit J11 and J12 from the released Rev A assembly unless their electrical contracts are completed.
3. Add a Sheet 09 pogo-test field covering rails, recovery, watchdog, authorization, safety loops, motion pre/post-inhibit nodes, and relay drive.
4. Provide paired signal/ground measurement pads at fast or noisy nodes.
5. Define one replaceable-fuse access path and label it clearly.
6. Create board zones and keepouts before footprint placement, including ESP32 RF, relay contact isolation, switch nodes, and safety analog.
7. Require exact-part, AVL, and footprint review as a formal PCB-entry gate.
8. Establish a manufacturing test-limit file separate from nominal engineering calculations.
9. Design product harnesses as replaceable modules with controlled crimp, seal, strain-relief, and inspection requirements.
10. Create a prototype instrumentation plan before the first board so thermal, transient, and timing measurements are not blocked by inaccessible nodes.

## Readiness Assessment

The Rev A functional schematic core is stable enough to continue the remaining schematic packages and PCB-oriented definition work. It is not ready for physical PCB implementation or manufacturing release.

### Final Decision

**READY WITH MAJOR MANUFACTURING OBSERVATIONS**

**PACKAGE 08 / SHEET 07 — USER INTERFACE & LOCAL CONTROLS AUTHORIZED**

This authorization permits Sheet 07 preliminary schematic capture within ADR-039 through ADR-044. It does not authorize footprints, placement, routing, PCB release, fabrication, procurement, manufacturing, or energized testing.
