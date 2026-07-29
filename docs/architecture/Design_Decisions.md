# IPC-100 Design Decisions

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Design Decisions |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. ADR conventions

Statuses are `Accepted`, `Proposed`, `Superseded`, or `Rejected`. Accepted decisions govern Rev A until superseded through review.

## 2. Decision records

### ADR-001: IPC-100 is a reusable platform

- **Decision ID:** ADR-001
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Multiple Iron Pine products need common controller capabilities.
- **Decision:** IPC-100 is a reusable controller platform, not the CrossWind product.
- **Consequences:** Platform documents and base firmware remain product-neutral.
- **Alternatives considered:** A CrossWind-specific motherboard; separate controllers for every product.
- **Follow-up actions:** Maintain explicit platform/product boundaries in reviews.

### ADR-002: Revision numbering starts at Rev A

- **Decision ID:** ADR-002
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Predecessor controller concepts used unrelated revision histories.
- **Decision:** IPC-100 hardware revision numbering begins at Rev A.
- **Consequences:** Predecessor work is reference history and does not make IPC-100 Rev D.
- **Alternatives considered:** Continue a predecessor revision sequence.
- **Follow-up actions:** Apply the revision policy in [Revision History](../revisions/Revision_History.md).

### ADR-003: Motor drivers remain external

- **Decision ID:** ADR-003
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Products may require different motors and driver ratings.
- **Decision:** Motor-driver modules remain external to the IPC-100 motherboard.
- **Consequences:** IPC-100 provides low-current logic interfaces only.
- **Alternatives considered:** Integrated H-bridges; product-specific motherboard variants.
- **Follow-up actions:** Verify interface voltage, protection, and boot-safe behavior.

### ADR-004: Motor power bypasses IPC-100

- **Decision ID:** ADR-004
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Motor current creates thermal, fault-energy, and noise risks.
- **Decision:** High-current motor power must not pass through IPC-100.
- **Consequences:** Products require separately fused high-current distribution.
- **Alternatives considered:** Board-level motor-power buses.
- **Follow-up actions:** Enforce the boundary in schematics, connectors, and tests.

### ADR-005: Battery hardware is product-level

- **Decision ID:** ADR-005
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Battery mounting and distribution depend on product mechanics and loads.
- **Decision:** Battery mounts and main power distribution are product-level hardware.
- **Consequences:** IPC-100 defines only its allowable electrical input.
- **Alternatives considered:** A universal on-board battery adapter.
- **Follow-up actions:** Define J1 limits and upstream protection assumptions.

### ADR-006: Normal input range is 9–21 V DC

- **Decision ID:** ADR-006
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** The primary Rev A integration case is an external nominal 18 V lithium-ion tool-battery system, with DeWalt 20V MAX as the initial reference implementation; standalone nominal 12 V systems are also intended.
- **Decision:** IPC-100 accepts 9–21 V DC during normal operation without depending on a specific battery brand.
- **Consequences:** The transient-survival profile and associated protection and derating remain TBD. Direct vehicle charging-system and automotive load-dump qualification are outside the approved baseline.
- **Alternatives considered:** 12 V-only input; product-specific regulators.
- **Follow-up actions:** Select and verify the input power components.

### ADR-007: Physical controls remain available

- **Decision ID:** ADR-007
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Wireless control alone is insufficient for safe field equipment operation.
- **Decision:** Product designs retain accessible physical controls; IPC-100 provides ARM, FIRE, and STOP inputs.
- **Consequences:** The system is not app-only.
- **Alternatives considered:** Wireless-only user control.
- **Follow-up actions:** Define input protection and product-level control behavior.

### ADR-008: Product-neutral relay interface uses dry contacts

- **Decision ID:** ADR-008
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** External trigger circuits require electrical separation and product flexibility.
- **Decision:** The product-neutral relay interface uses isolated `RELAY_NC`, `RELAY_COM`, and `RELAY_NO` contacts.
- **Consequences:** IPC-100 does not source operating power to the switched external circuit; contact and isolation ratings remain TBD.
- **Alternatives considered:** Powered output; open-drain output.
- **Follow-up actions:** Select a relay and verify isolation, ratings, environmental derating, and hardware-safe de-energized behavior.

### ADR-009: Separate dirty and clean power

- **Decision ID:** ADR-009
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** External motors create conducted and radiated noise.
- **Decision:** Product high-current power and IPC-100 clean logic power use separate branches and controlled grounding.
- **Consequences:** Wiring, filtering, and return paths must preserve segregation.
- **Alternatives considered:** A shared daisy-chained motor/logic branch.
- **Follow-up actions:** Validate noise immunity during product integration.

### ADR-010: Blueprint precedes schematic work

- **Decision ID:** ADR-010
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Uncontrolled schematic work risks contradictory interfaces.
- **Decision:** The Engineering Blueprint must be reviewed before additional schematic blocks are added.
- **Consequences:** Requirements and interfaces act as schematic-entry gates.
- **Alternatives considered:** Document after schematic capture.
- **Follow-up actions:** Resolve critical TBD items and approve the blueprint.

### ADR-011: CrossWind remains separate

- **Decision ID:** ADR-011
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** CrossWind contains product-specific mechanics, wiring, behavior, and verification.
- **Decision:** CrossWind remains a separate external repository that consumes IPC-100.
- **Consequences:** CrossWind-specific artifacts are excluded here.
- **Alternatives considered:** A monorepository.
- **Follow-up actions:** Version the interface consumed by CrossWind.

### ADR-012: IPC numbering is for controller platforms

- **Decision ID:** ADR-012
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Product and controller identifiers require an unambiguous namespace.
- **Decision:** IPC numbering is reserved for Iron Pine controller platforms.
- **Consequences:** Product identifiers use their own naming systems.
- **Alternatives considered:** Use IPC numbers for products and boards interchangeably.
- **Follow-up actions:** Apply this convention to future platform planning.

### ADR-013: Expansion is optional and nonessential to safe startup

- **Decision ID:** ADR-013
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** External expansion may be absent, miswired, independently powered, unsupported, or faulty.
- **Decision:** Optional expansion is subordinate to hardware-safe outputs, safety-relevant local inputs, and core diagnostics.
- **Consequences:** Expansion initialization occurs later and failures remain diagnostic and nonfatal to safe operation.
- **Alternatives considered:** Required expansion for base safety behavior.
- **Follow-up actions:** Verify absent, faulted, and externally powered configurations.

### ADR-014: I2C expansion is a controlled local interface

- **Decision ID:** ADR-014
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** A shared onboard bus may be exposed to less-controlled external modules and wiring.
- **Decision:** J10 provides controlled optional I2C expansion and does not imply arbitrary device, breakout-board, hot-plug, or field-bus compatibility.
- **Consequences:** Loading, pull-ups, addresses, wiring, segmentation, power, timeout, and recovery require approval.
- **Alternatives considered:** Advertise unrestricted external I2C.
- **Follow-up actions:** Resolve the I2C electrical contract before schematic release.

### ADR-015: CAN and RS485 are future provisions

- **Decision ID:** ADR-015
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** Reserved concepts do not provide validated differential interfaces.
- **Decision:** CAN and RS485 remain future provisions, not released Rev A features.
- **Consequences:** Products and firmware may not claim support without validated hardware, firmware, connector, and protocol contracts.
- **Alternatives considered:** Treat reserved pins as supported buses.
- **Follow-up actions:** Preserve provisions only where required resources remain available.

### ADR-016: Connector allocation remains preliminary

- **Decision ID:** ADR-016
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Electrical contracts, harness grouping, keying, retention, and environmental requirements remain unresolved.
- **Decision:** Keep current identifiers and pin reservations as review inputs until connector and harness architecture is approved.
- **Consequences:** J4/J5 physical connector implementation, J8 partitioning, J11 pin count, and J12 architecture remain open. The later safety-input review requires individual J4/J5 returns.
- **Alternatives considered:** Release current reservations as production pinouts.
- **Follow-up actions:** Resolve `CONN-TBD-001` through `CONN-TBD-003` and complete cross-connector review.

### ADR-017: Peripheral supply names remain voltage-neutral

- **Decision ID:** ADR-017
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** Final OLED and environmental-sensor supply domains are not approved.
- **Decision:** Preserve `OLED_VCC` and `SENSOR_VCC` as stable connector signals while their voltages remain `TBD`.
- **Consequences:** Final modules must be compatible with approved supply and logic architectures.
- **Alternatives considered:** Encode an unapproved voltage in each signal name.
- **Follow-up actions:** Approve exact modules and supply domains before schematic release.

### ADR-018: Motor-driver signaling is a reference contract

- **Decision ID:** ADR-018
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** The current six-signal contract follows a BTS7960-style interface but electrical compatibility is unresolved.
- **Decision:** Preserve the stable Axis 1 and Axis 2 signals as a reference contract without making BTS7960 a permanent dependency or promising universal compatibility.
- **Consequences:** Logic levels, polarity, drive, enable, PWM, braking, protection, and backfeed behavior require approval.
- **Alternatives considered:** Lock one external motor-driver module.
- **Follow-up actions:** Complete schematic-level interface validation.

### ADR-019: Rev A architecture freeze is a formal schematic-entry gate

- **Decision ID:** ADR-019
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** The architecture is substantially documented, but processor, power, safety-interface, I2C, connector, and mechanical decisions still block controlled schematic capture.
- **Decision:** Rev A architecture will be frozen only after the schematic-entry criteria in the Rev A readiness review are satisfied and processor-resource feasibility is demonstrated.
- **Consequences:** Rev A is not currently frozen and controlled schematic capture is not authorized.
- **Alternatives considered:** Begin schematic capture while blocking architecture decisions remain unresolved.
- **Follow-up actions:** Close Gate 1 blockers and repeat the readiness review.

### ADR-020: Requirements traceability is required for release gates

- **Decision ID:** ADR-020
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** Requirements, design decisions, verification concepts, and open dependencies must remain connected as Rev A progresses.
- **Decision:** Architecture, schematic, prototype, and validation gates shall maintain controlled requirement traceability.
- **Consequences:** Prototype release requires traceable verification coverage and disposition of blocking open items.
- **Alternatives considered:** Reconstruct traceability after prototype fabrication.
- **Follow-up actions:** Expand grouped architecture traceability into procedure-level evidence as designs and tests are released.

### ADR-021: ESP32-S3-WROOM-1 is the preferred Rev A module family

- **Decision ID:** ADR-021
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Rev A has approximately 29 direct MCU signals before module-specific management resources, while long-term IPC-100 reuse benefits from native USB, processing margin, memory options, and expansion headroom.
- **Decision:** Use ESP32-S3-WROOM-1 as the preferred Rev A module family and native USB Serial/JTAG as the preferred service architecture. ESP32-WROOM-32E remains the acceptable second choice if approved resource reduction and a USB-to-UART service path are adopted.
- **Consequences:** Bluetooth services must remain compatible with Bluetooth LE unless the decision is revisited. The exact flash/PSRAM suffix, GPIO map, ADC path, boot allocation, power implementation, antenna constraints, and recovery/test access remain unresolved.
- **Alternatives considered:** ESP32-WROOM-32E, ESP32-C6-WROOM-1, and ESP32-C3-WROOM-02.
- **Follow-up actions:** Complete an ESP32-S3 pin-level feasibility study, memory budget, mechanical/RF review, and procurement/lifecycle approval before schematic release.

### ADR-022: USB-only power is a bounded core service state

- **Decision ID:** ADR-022
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** IPC-100 needs native USB programming and recovery without allowing a host port to energize external controller loads or product power.
- **Decision:** Main power creates `+5V_MAIN`; main power or protected USB VBUS may feed a non-backfeeding `CORE_SOURCE` and `+3V3_CORE`. USB-only operation powers the ESP32-S3 core/service domain only. Relay, motor-driver logic power, OLED, sensor, UI-accessory, and expansion-power domains remain off.
- **Consequences:** Source selection, USB protection, and main/USB transition behavior require schematic implementation and validation. IPC-100 does not charge the product battery, source VBUS, or provide USB Power Delivery.
- **Alternatives considered:** Require main power for all USB service; allow USB to power the complete controller and external interfaces.
- **Follow-up actions:** Close load envelopes, transition criteria, USB/current contracts, and component-level source-selection design.

### ADR-023: External power outputs are main-only and fault-contained

- **Decision ID:** ADR-023
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Motor-driver logic, UI, I2C expansion, and future accessories can be absent, shorted, miswired, or independently powered.
- **Decision:** Every IPC-100 external power output is a limited main-power-only branch with a released voltage/current contract, appropriate fault containment, and backfeed blocking. Optional expansion power defaults off and is not required for safe startup.
- **Consequences:** No Rev A connector receives an implied general-purpose power budget. Hot plug is unsupported unless separately validated.
- **Alternatives considered:** Connect external power pins directly to unrestricted core or main rails.
- **Follow-up actions:** Approve per-connector load envelopes and protection implementation before connector/schematic release.

### ADR-024: STOP and limits use supervised de-energize-to-safe loops

- **Decision ID:** ADR-024
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Open wiring, reset, brownout, and loss of input conditioning must not make safety-related inputs permissive.
- **Decision:** `STOP_IN` and all four directional limits use individually returned, normally-closed supervised dry-contact loops. Open, invalid, faulted, or unknown states receive the conservative STOP or direction-inhibit interpretation.
- **Consequences:** J4/J5 shared returns are rejected. Each loop needs field supervision termination and quantitative healthy/asserted/fault windows. IPC-100 still is not a certified emergency-stop controller.
- **Alternatives considered:** Normally-open unsupervised contacts; shared-return NC contacts; direct GPIO wiring.
- **Follow-up actions:** Close field voltage, termination, cable, protection, response, and hardware-inhibit implementation.

### ADR-025: ARM and FIRE are sequenced momentary commands

- **Decision ID:** ADR-025
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** ARM and FIRE must not create output action from reset, held contacts, wiring faults, or illegal ordering.
- **Decision:** ARM and FIRE use momentary normally-open dry contacts. FIRE requires a new qualified transition after a valid ARM event and all applicable safety checks. STOP cancels authorization; reset/power loss requires release and a new sequence.
- **Consequences:** Product firmware owns workflow/timeouts, while base firmware owns qualified events and fault reporting. Neither input directly energizes an output.
- **Alternatives considered:** Maintained ARM state; level-sensitive FIRE; direct hardware triggering.
- **Follow-up actions:** Define quantitative debounce/response and product integration rules before firmware release.

### ADR-026: Encoder inputs are non-safety UI

- **Decision ID:** ADR-026
- **Date:** 2026-07-29
- **Status:** Accepted
- **Context:** Encoder faults and bounce are foreseeable and must not affect safe initialization.
- **Decision:** Encoder A, B, and push are optional non-safety UI inputs. Invalid transitions, disconnection, or stuck states cannot directly authorize motor or relay outputs.
- **Consequences:** Encoder implementation may be changed behind the platform abstraction in a future revision.
- **Alternatives considered:** Use encoder push as a safety or ARM/FIRE input.
- **Follow-up actions:** Validate the selected encoder/harness and decoding behavior during prototype testing.

### ADR-027: Motor and relay authorization share a hardware master inhibit

- **Decision ID:** ADR-027
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Firmware configuration or failure cannot be the sole mechanism preventing motion or relay actuation during unsafe power/input states.
- **Decision:** A common hardware master inhibit overrides all motor commands/enables and relay-coil authorization during STOP, invalid main power, reset, brownout, watchdog recovery, USB-only service, and uninitialized operation.
- **Consequences:** Product-mapped directional limits remain prioritized firmware inhibitions unless a product adds a mapped hardware path. The inhibit logic, coverage, diagnostic feedback, and single-fault performance require schematic review.
- **Alternatives considered:** Firmware-only disable; unrelated motor and relay gates; processor internal pulls alone.
- **Follow-up actions:** Complete hardware-inhibit logic, power/reset interaction, and fault analysis before schematic release.

### ADR-028: Motor safe state is disabled/coast with an inhibited reversal transition

- **Decision ID:** ADR-028
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** External drivers interpret opposing PWM, enables, braking, and reversal differently.
- **Decision:** The Rev A platform safe state makes both PWM commands inactive and both enables disabled. Opposing commands are illegal. Direction reversal passes through this disabled/coast state for an approved interval before the opposite direction is commanded.
- **Consequences:** Active braking, hold torque, or regeneration is not a baseline feature and requires a selected external-driver/product contract. Numeric PWM and transition timing remain open.
- **Alternatives considered:** Active braking as the universal safe state; direct direction reversal; leave enables active while stopped.
- **Follow-up actions:** Approve external-driver electrical/timing contract and validate behavior before firmware release.

### ADR-029: Preserve native USB and an independent UART0 recovery reservation

- **Decision ID:** ADR-029
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Native USB is the preferred service path, but application misconfiguration can make USB Serial/JTAG unavailable.
- **Decision:** Reserve GPIO19/20 exclusively for native USB Serial/JTAG, keep GPIO0 and EN accessible for manual download recovery, and reserve GPIO43/44 for UART0 production/service access.
- **Consequences:** Recovery remains practical without an on-board USB-to-UART bridge, but two common GPIOs cannot serve application or expansion functions. J11 cannot be guaranteed by the direct allocation.
- **Alternatives considered:** Native USB only with no UART reserve; on-board bridge; share UART0 pins with application outputs.
- **Follow-up actions:** Define physical fixture access and validate USB/manual/UART recovery before schematic release.

### ADR-030: Use MCPWM for Rev A motor command generation

- **Decision ID:** ADR-030
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Rev A requires four independent motor PWM commands with safe reversal and potential synchronization while RGB and buzzer may also need modulation.
- **Decision:** Allocate MCPWM0 operators 0 and 1, generators A/B, to the four motor PWM commands. Reserve LEDC primarily for non-safety status modulation.
- **Consequences:** The motor service gains paired motor-oriented timing resources without consuming LEDC status capacity. Hardware master inhibit remains independent and final PWM timing remains open.
- **Alternatives considered:** LEDC for all PWM; software PWM; split motor commands across unrelated peripherals.
- **Follow-up actions:** Validate simultaneous MCPWM allocation in the selected framework and approve the quantitative motor timing contract.

### ADR-031: Rev A uses a ten-sheet functional schematic hierarchy

- **Decision ID:** ADR-031
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Preliminary capture needs stable boundaries that keep unresolved electrical contracts visible.
- **Decision:** Partition Rev A into Sheets 00–09 for top level, power entry, power conversion, MCU/service, safety inputs, motor interfaces, relay/master inhibit, UI/peripherals, expansion, and connectors/test access.
- **Consequences:** Each functional circuit has one owner and crosses sheets only through controlled ports. The hierarchy adds review discipline but does not authorize complete electrical capture.
- **Alternatives considered:** Flat schematic; power/MCU/output-only hierarchy; product-specific sheets.
- **Follow-up actions:** Approve Gate 1 before creating the KiCad hierarchy.

### ADR-032: Sheet 06 solely owns master-inhibit decision logic

- **Decision ID:** ADR-032
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Splitting actuator authorization among power, input, motor, and relay sheets risks inconsistent safe-state behavior.
- **Decision:** Sheet 06 owns the complete master-inhibit decision and watchdog interaction. Power and input sheets provide qualified status; motor and relay blocks consume the resulting inhibit.
- **Consequences:** No other sheet may create an authorization bypass. The inhibit implementation, feedback, timing, and fault analysis remain open.
- **Alternatives considered:** Power-sheet ownership; separate motor/relay inhibits; distributed gating without a single owner.
- **Follow-up actions:** Quantify and capture the inhibit implementation before output-sheet release.

### ADR-033: Sheet 09 solely owns connector and production-access symbols

- **Decision ID:** ADR-033
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Physical connectors and fixture access affect multiple functional sheets and are prone to duplicate or inconsistent symbols.
- **Decision:** Sheet 09 is the sole schematic owner of J1–J13 symbols and all production/test-access symbols. Functional sheets own circuitry and export staged interface nets.
- **Consequences:** Connector pinout review is centralized while functional ownership remains separate. No connector symbol may be duplicated elsewhere.
- **Alternatives considered:** Place each connector on its functional sheet; duplicate connectors at both functional and physical views.
- **Follow-up actions:** Validate all J1–J13 ports during the cross-sheet interface review.

### ADR-034: J11 remains documentation-only for Rev A

- **Decision ID:** ADR-034
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** The proposed direct GPIO allocation cannot guarantee two spare processor GPIOs while preserving required functions, USB, and UART recovery.
- **Decision:** Do not create a released J11 connector symbol, pinout, or fabricated pad promise in Rev A. Retain the spare-GPIO concept as a future requirement pending resource reduction or revision.
- **Consequences:** Rev A avoids a false expansion claim. GPIO37 remains a conditional internal reserve only.
- **Alternatives considered:** One conditional spare; sacrifice UART recovery; use strapping pins; add unapproved resource-reduction circuitry.
- **Follow-up actions:** Approve this disposition before Sheet 08/09 completion and update external compatibility claims.

### ADR-035: Rev A uses common logic ground with explicit isolated-contact and dedicated-return boundaries

- **Decision ID:** ADR-035
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** “Clean” and “dirty” terminology can accidentally imply galvanic isolation that does not exist.
- **Decision:** Regulated controller, USB, interface, and battery-reference returns use a controlled common logic-ground architecture. Supervised inputs retain dedicated sense returns, motor power/return stays external, and relay contacts remain galvanically isolated.
- **Consequences:** Noise/current segregation is enforced by ownership and later layout rather than invented ground domains. Shield/chassis coupling remains a separate mechanical/electrical decision.
- **Alternatives considered:** Multiple loosely defined grounds; isolated motor-logic interfaces by default; tie relay contacts to logic return.
- **Follow-up actions:** Validate return-current and shield strategy during component and PCB reviews.

### ADR-036: Rev A preliminary capture uses ESP32-S3-WROOM-1-N8

- **Decision ID:** ADR-036
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** The GPIO plan requires GPIO35/36 and ordinary 3.3 V behavior on GPIO47/48; no PSRAM requirement has been demonstrated.
- **Decision:** Use ESP32-S3-WROOM-1-N8, with 8 MB Quad-SPI flash and no PSRAM, for Rev A preliminary schematic capture.
- **Consequences:** Octal-PSRAM variants are excluded without a GPIO redesign. N8 still requires memory-budget, RF, mechanical, lifecycle, and procurement approval before schematic release.
- **Alternatives considered:** N4; Quad-SPI PSRAM variants; octal-PSRAM R8/R16V variants.
- **Follow-up actions:** Close the firmware memory budget and orderable-part release review.

### ADR-037: Rev A supervised loops use a 5 V midpoint EOL contract

- **Decision ID:** ADR-037
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** STOP and four limits require deterministic healthy, open, and short states without direct field wiring to the processor.
- **Decision:** Use a 5 V field-sense source with 2.20 kΩ controller and remote 2.20 kΩ EOL resistors. Healthy is nominally 2.5 V; below 1.0 V is short/fault and above 4.0 V is open/asserted. Invalid states receive the conservative inhibit interpretation.
- **Consequences:** Every loop needs a dedicated return and remote EOL installation. Threshold tolerance, cable, leakage, EMC, and fault behavior require schematic and prototype validation.
- **Alternatives considered:** Unsupervised contacts; resistor coding read only by MCU ADC; optically isolated industrial inputs.
- **Follow-up actions:** Complete worst-case analysis and validate all five loops.

### ADR-038: Actuator authorization is an active-high fail-low hardware permit

- **Decision ID:** ADR-038
- **Date:** 2026-07-29
- **Status:** Proposed
- **Context:** Ambiguous inhibit polarity and floating enables can create startup or partial-power hazards.
- **Decision:** Implement `ACTUATOR_PERMIT` as active high and default low. It requires valid main power, hardware-qualified STOP, released reset, and a valid independent watchdog; it gates both motor-interface output enable and relay-coil authorization.
- **Consequences:** Loss, absence, or indeterminate state of any qualifier disables actuators. Rev A provides fixture access but no MCU permit-feedback GPIO.
- **Alternatives considered:** Active-high inhibit distributed among output blocks; firmware-only authorization; separate unrelated relay and motor permits.
- **Follow-up actions:** Complete timing, power-sequence, and single-fault review before schematic release.
