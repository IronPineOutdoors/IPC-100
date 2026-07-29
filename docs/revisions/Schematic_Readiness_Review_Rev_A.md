# IPC-100 Rev A Schematic Readiness Review

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Review | Architecture freeze and schematic readiness |
| Date | 2026-07-29 |
| Status | Gate review complete; architecture not frozen |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose and scope

This review audits architecture definition, requirements, traceability, processor resources, connectors, power, safety, firmware interfaces, verification, and open decisions. It does not authorize schematic capture, PCB layout, component selection, GPIO assignment, firmware implementation, or product-specific design.

## 2. Documents reviewed

The review covered the repository README; hardware, functional, wiring, mechanical, and nonfunctional requirements; system architecture, product boundaries, design philosophy, and ADRs; connector specification, connector review, and GPIO map; power architecture and budget; test plan; revision history and open items; firmware documentation; and all other repository Markdown found by consistency search.

## 3. Rev A platform summary

IPC-100 is a product-neutral ESP32-family outdoor controller with protected 9–21 V controller input, wireless communications, USB-C service, local inputs, safe low-current outputs, display and environmental-sensor interfaces, battery monitoring, controlled optional I2C/spare expansion, and future CAN/RS485 provisions. Motor power, motor current, external relay load power, product mechanics, harnesses, and application behavior remain external.

## 4. Architecture decision status

### Locked or accepted

- Platform/product boundary and external high-current boundary
- ESP32 processor family and Wi-Fi/Bluetooth/ESP-NOW capabilities
- USB-C external service connector
- Stable logical signal names
- Hardware-safe relay and motor-output behavior
- STOP independence and local limit availability
- Optional expansion subordinate to safe startup
- Controlled local I2C philosophy
- CAN/RS485 as future provisions only
- Voltage-neutral `OLED_VCC` and `SENSOR_VCC`
- Requirements, revision, and verification control process

### Proposed

- Exact processor candidate for schematic study
- Input-path capability and rail architecture
- Display and sensor implementations
- Motor enable/resource-reduction architecture
- Spare GPIO and daughterboard provisions
- Connector allocations and partitioning
- Intended Rev A architecture-freeze gate

## 5. Blocking unresolved decisions

| Area | Blocking decision |
| --- | --- |
| Processor | Candidate module, exact usable resources, memory, USB path, ADC path, boot/programming/debug, antenna constraints |
| Power | Block-level 5 V/3.3 V architecture, USB-only/main interaction, load envelopes, transient/undervoltage objectives, backfeed boundaries |
| Inputs | Field voltage/contact contract, polarity, bias, NO/NC philosophy, STOP/limit fault detection, protection objectives |
| Outputs | Relay electrical/driver contract, motor-driver logic compatibility, enable and safe-disable architecture, RGB/buzzer load assumptions |
| I2C | `OLED_VCC`, `SENSOR_VCC`, exact approved modules, pull-up ownership, addresses, external segmentation and power contract |
| Connectors | Provisional pin-count approval; J8, J11, J12 dispositions; required interface electrical definitions |
| Mechanical | Preliminary PCB envelope, mounting concept, connector-access assumptions, antenna keepout |
| Verification | Traceability exists at architecture level, but acceptance criteria and component-dependent tests remain TBD |

## 6. Nonblocking unresolved decisions

Final component part numbers and passive values, connector manufacturer, final enclosure, production cable lengths, production test limits, product application behavior, future CAN/RS485 implementation, daughterboard implementation, and product-specific sensor interpretation may remain unresolved during preliminary architecture work. They become stage-gated later.

## 7. Requirements completeness audit

| Category | Completeness | Blocking gaps | Nonblocking gaps | Contradictions | Recommended action |
| --- | --- | --- | --- | --- | --- |
| Platform scope/product boundary | Complete for architecture | None | Product compatibility records later | None found | Freeze after gate approval |
| Power | Partial | Rail blocks, USB behavior, protection objectives, load envelope | Exact components/values | No current contradiction | Resolve block architecture |
| Processor | Partial | Module/resources/USB/ADC/boot/memory | Lifecycle evidence later | No false selection found | Complete processor gate |
| Communications | Complete for architecture | USB implementation only | Protocol details | None | Preserve wireless baseline |
| Display/sensor | Partial | Supply domains, modules, shared-bus contract | Calibration details | None | Approve interface population |
| Battery monitoring | Substantially complete | ADC path | Accuracy/calibration | ADC1-only wording corrected previously | Select ADC path |
| Inputs | Partial | Electrical contract and safety topology | Debounce values | None | Resolve before schematic |
| Outputs | Partial | Relay/motor electrical and safe-disable circuits | UI meanings/patterns | None | Resolve before schematic |
| Expansion | Complete for architecture | J10/J11 impact if populated | Future provisions | None | Keep optional/stage-gated |
| Safety | Substantially complete | Electrical mechanisms/polarity | Numeric timing | No certified E-stop claim | Complete hardware mechanism review |
| Wiring | Substantially complete | Connector/harness grouping | Product wire details | None | Continue at product stage |
| Mechanical | Partial | Envelope, mounting, access, antenna keepout | Final enclosure | None | Define preliminary constraints |
| Diagnostics/firmware abstraction | Substantially complete | Watchdog/timeouts/population mechanism | Product semantics | None | Interface scaffolding only |
| Testing | Substantially complete | Acceptance criteria and hardware-dependent procedures | Environmental/product validation | Test IDs overlap requirement-style namespaces | Establish traceable procedure IDs later |
| Revision control | Complete for architecture | Freeze approval absent | Production workflow later | None | Use formal gates |

### Requirement quality findings

All authoritative requirements have IDs, verification methods, and statuses. Several `where practical`, `appropriate`, `sufficient`, and multi-obligation requirements remain. These are lower-priority wording issues unless they gate processor capacity, protection objectives, mechanical access, or safe-state behavior. No bulk stylistic rewrite is justified. Test-plan identifiers overlap hardware-style IDs but are clearly test concepts; a separate verification namespace remains a traceability improvement.

## 8. Traceability results

The [Requirements Traceability Matrix](Requirements_Traceability_Matrix.md) maps every hardware requirement range and material functional behavior to architecture, interfaces, verification concepts, design stage, and open dependencies. Architecture coverage is present for every category. Major gaps are acceptance criteria, component-dependent evidence, product-owned validation, and final test procedure identifiers.

## 9. Processor resource feasibility

The [Processor Resource Feasibility](../architecture/Processor_Resource_Feasibility.md) derives 10 independent digital inputs, 14 independent outputs, two I2C signals, one ADC path, and two possible service signals: approximately 29 MCU signal resources before boot/reset and optional controls. An illustrative, non-approved external-interface scenario could reduce direct demand to approximately 19. Exact module capacity is not established, so feasibility is **Not demonstrated**.

### Processor-selection gate

Selection requires sufficient usable GPIO, PWM, ADC, communications, memory, boot-safe compatibility, wireless support, service-interface compatibility, lifecycle/availability review, approved footprint, antenna/enclosure compatibility, programming/recovery method, and applicable module regulatory status.

## 10. Connector readiness

The [Connector Architecture Review](../connectors/Connector_Architecture_Review.md) classifies J1–J13. J1 and J8 are conditionally useful for block-level work. J2–J7, J9–J11, and J13 have blocking electrical definitions. J12 is future provision only. No released connector pinout is ready for component-level capture.

## 11. Power readiness

| Power decision | Current status | Blocks schematic? | Why | Required evidence or decision |
| --- | --- | --- | --- | --- |
| 9–21 V input | Locked | No | Normal range defined | Preserve |
| Reverse polarity/transients/fuse boundary | Objectives partial | Yes | Component ratings and topology depend on approved environment | Define profiles and block objectives |
| Undervoltage/overvoltage behavior | TBD | Yes | Safe rail decay and recovery depend on it | Define required behavior |
| Controller input-path concept | Proposed | Yes | Not a closed load budget or 5 V rating | Close approximate envelopes |
| 5 V and 3.3 V rails | Required; architecture TBD | Yes | Sources and sequencing unknown | Approve block-level rail tree |
| USB-only/main/simultaneous states | TBD | Yes | Affects source selection and backfeed | Select supported states |
| `OLED_VCC` / `SENSOR_VCC` | TBD | Yes for J6/J7 | Module compatibility unknown | Approve modules/domains |
| Relay/indicator/buzzer/driver logic loads | TBD | Yes | Rail and driver sizing need envelopes | Establish load assumptions |
| Expansion reserves | TBD | Conditional | Can be omitted/reserved from first schematic | Approve disposition |
| External motor/relay load power | External/locked | No | Boundary is clear | Preserve |

Power is not ready for component-level design. Parameterized block diagrams may proceed after rail-tree and supported-power-state approval.

## 12. Safety readiness

| Safety function | Hardware mechanism required | Firmware role | Product role | Current definition | Blocking issue |
| --- | --- | --- | --- | --- | --- |
| STOP | Defined field state, fault interpretation, protected independent path | Prioritized detection and disable request | Complete hazard mitigation/E-stop | Logical independence locked | Polarity, NO/NC, fault method |
| Directional limits | Protected defined states and detectable faults where approved | Directional inhibition/diagnostics | Map signals to mechanics | Logical behavior locked | Polarity, topology, shared returns |
| Motor disable | Hardware inactive commands/enables | Validate commands and checks | Motion safety | Safe state locked | Enable/gating architecture |
| Relay disable | Hardware de-energized control | Validated activation | Switched load safety | `RELAY_NO` open locked | Driver/isolation architecture |
| Boot/reset/brownout | Pulls/gating and controlled rails | Safe initialization/recovery | Product response | Required | Electrical mechanisms/timing |
| Watchdog/communications | Hardware-safe defaults | Timeout, arbitration, recovery | Application policy | Behavior intent defined | Watchdog and timeout strategy |
| Expansion/backfeed | Protection/segmentation | Bounded handling/diagnostics | Installed hardware validation | Fault containment locked | Circuit architecture |

IPC-100 is not a certified emergency-stop device. Product-level emergency-stop and hazard mitigation remain product responsibilities. Firmware is not the sole motion or relay safeguard. STOP and limit polarity/topology, motor-disable architecture, and relay-disable architecture block schematic entry.

## 13. Firmware-interface readiness

| Service / abstraction | Stable interface? | Hardware dependency | Blocking decision | Firmware stage |
| --- | --- | --- | --- | --- |
| Logical GPIO abstraction | Yes | Final mapping/polarity | Hardware revision definition | Can begin interface scaffolding |
| Safe output initialization | Behavior yes | Pulls/gating/rails | Schematic mechanisms | Requires schematic definition |
| Inputs and diagnostics | Names yes | Polarity/fault circuits | Input contract | Requires schematic definition |
| Motor/relay services | Names/behavior yes | Driver/gating | Electrical contracts | Requires schematic definition |
| Display/sensor drivers | Generic capability yes | Exact modules/domains | Population approval | Requires schematic definition |
| Optional-device handling | Architecture yes | Identification/segmentation | Detection mechanism | Requires schematic definition |
| Command validity/timeouts/watchdog | Partial | Hardware recovery interaction | Timing/strategy | Requires schematic definition |
| Calibration/validation | Partial | Prototype measurements | Hardware evidence | Requires prototype hardware |
| Product application | Outside platform | Product repository | Product decisions | Requires product repository |
| CAN/RS485 | No released feature | Future hardware | Future decision | Future only |

Interface scaffolding may begin conceptually, but hardware-dependent implementation is not authorized.

## 14. Test readiness

Architecture-level concepts cover safe startup, reset, brownout, watchdog recovery, STOP/limit priority, relay de-energized state, motor disable, opposing commands, USB/main interactions, backfeed, I2C faults, absent/unsupported devices, expansion overload, and connector faults. Numeric criteria, component-dependent analysis, prototype procedures, environmental profiles, and product-level validation remain open.

## 15. Schematic-entry criteria

| Area | Criterion | Classification |
| --- | --- | --- |
| Processor | Candidate module selected for schematic study | Not satisfied |
| Processor | Usable resource feasibility demonstrated | Not satisfied |
| Processor | USB architecture selected | Not satisfied |
| Processor | ADC path selected | Not satisfied |
| Processor | Boot/programming and antenna constraints defined | Partially satisfied |
| Power | Block-level rail architecture approved | Not satisfied |
| Power | USB/main behavior defined | Not satisfied |
| Power | Approximate load envelopes available | Partially satisfied |
| Power | Backfeed boundaries and power states documented | Partially satisfied |
| Inputs | Field-input contract and active states selected | Not satisfied |
| Inputs | Bias and STOP/limit fault philosophy defined | Not satisfied |
| Inputs | Protection objectives defined | Partially satisfied |
| Outputs | Relay electrical contract defined | Not satisfied |
| Outputs | Motor-driver electrical contract defined | Not satisfied |
| Outputs | Safe-disable architecture defined | Not satisfied |
| Outputs | RGB/buzzer load assumptions defined | Not satisfied |
| I2C | Supply domains and pull-up ownership defined | Not satisfied |
| I2C | Address compatibility confirmed | Not satisfied |
| I2C | External segmentation decision made | Not satisfied |
| Connectors | Provisional pin counts approved | Partially satisfied |
| Connectors | J8 disposition approved | Not satisfied |
| Connectors | J11 disposition approved | Not satisfied |
| Connectors | J12 disposition approved | Not satisfied |
| Connectors | Selection criteria documented | Partially satisfied |
| Mechanical | Preliminary PCB envelope and mounting concept | Not satisfied |
| Mechanical | Connector access and antenna assumptions | Partially satisfied |
| Verification | Traceability matrix complete at architecture level | Satisfied |
| Verification | Blocking requirements have verification concepts | Satisfied |
| Verification | Major fault cases documented | Satisfied |

## 16. Required engineering gates

1. **Gate 1 — Architecture Freeze:** close all schematic-entry blockers and approve the baseline.
2. **Gate 2 — Preliminary Schematic Review:** processor, programming, power tree, safe states, interface blocks, provisional connector pinouts, and protection concepts.
3. **Gate 3 — Detailed Schematic Review:** parts, values, tolerances, derating, integrity, protection, current limits, fault paths, and design-rule checks.
4. **Gate 4 — PCB Layout Entry:** approved schematic, envelope, mounting, connector families, stackup assumptions, creepage/clearance, antenna keepout, and power/current paths.
5. **Gate 5 — PCB Layout Review:** placement, routing, return paths, RF, thermal, mechanical, and DFM checks.
6. **Gate 6 — Prototype Release:** controlled fabrication/assembly package, BOM, deviations, and test readiness.
7. **Gate 7 — Bring-up Release:** approved safe bring-up plan, fixtures, instrumentation, and firmware image.
8. **Gate 8 — Validation Release:** controlled procedures, criteria, configuration, evidence, and deviation process.

## 17. Rev A architecture-freeze boundary

Freeze requires approval of platform purpose and boundaries, required functions/interfaces and signal names, power and motor boundaries, operating and hardware-safe states, processor capability criteria, communications, connector purpose/grouping, firmware abstraction, diagnostics, expansion philosophy, revision control, and verification strategy.

Freeze does not require final part numbers, passive values, PCB layout, connector manufacturer, final enclosure, cable length, firmware implementation, product behavior, or production test limits. It does require explicit closure or approved stage deferral of every electrical choice that blocks schematic capture.

## 18. Recommendation and classification

**Architecture-freeze recommendation: Do not freeze Rev A.**

**Final readiness classification: Not ready for schematic.**

The architecture is substantially documented, but multiple mandatory Gate 1 criteria are not satisfied. Block-level studies may continue, but controlled schematic capture is not authorized.

## 19. Required next actions

1. Select a candidate ESP32 module for study and close the direct-versus-reduced resource architecture.
2. Select USB and ADC architectural paths.
3. Approve block-level rails, supported power states, protection objectives, and load envelopes.
4. Approve field-input polarity/contact/fault/protection contracts.
5. Approve relay and motor-driver electrical and safe-disable contracts.
6. Approve display/sensor modules, supply domains, and shared-I2C architecture.
7. Resolve J8, J11, and J12 dispositions and provisional connector pin counts.
8. Define preliminary PCB envelope, mounting, connector access, and antenna constraints.
9. Re-run Gate 1 and approve or reject the proposed freeze ADR.

