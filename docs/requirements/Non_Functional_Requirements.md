# IPC-100 Non-Functional Requirements

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Non-Functional Requirements |
| Purpose | Define platform quality attributes and engineering constraints |
| Revision | Blueprint v1.0 |
| Status | Draft |
| Last updated | TBD |
| Author | TBD |

## 1. Scope and conventions

These requirements define qualities rather than features. IDs use the globally distinct `NFR-<category>-<number>` format. Unknown acceptance limits remain `TBD`.

Status values are `Locked`, `Proposed`, and `TBD`. Verification methods are inspection, analysis, demonstration, or test.

## 2. Environmental requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-ENV-001 | IPC-100 shall be designed for installation in outdoor equipment. | Defines the intended operating context. | Analysis and test | Locked |
| NFR-ENV-002 | The PCB operating-temperature range shall be approved before design release. | Component and test limits are unresolved. | Analysis | TBD |
| NFR-ENV-003 | Production use of conformal coating shall be evaluated and the selected process documented. | Supports moisture resilience and manufacturability. | Inspection and test | Proposed |
| NFR-ENV-004 | Vibration and shock acceptance profiles shall be defined before qualification. | Product installations can impose mechanical stress. | Analysis and test | TBD |
| NFR-ENV-005 | Condensation management shall remain a product-enclosure responsibility. | It depends on installation and enclosure design. | Inspection | Locked |

## 3. Power quality requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-PWR-001 | Regulated rails shall remain within selected component limits over the approved input, load, and temperature ranges. | Prevents unstable operation and damage. | Analysis and test | Locked |
| NFR-PWR-002 | Final rail sizing shall include verified peak loads, conversion losses, derating, and expansion reserve. | Typical current alone is insufficient. | Analysis | Locked |
| NFR-PWR-003 | Wireless transmit, relay, buzzer, RGB, and expansion simultaneous-load cases shall not cause an uncontrolled reset. | Captures expected peak loading. | Test | Proposed |
| NFR-PWR-004 | USB/main-power interaction shall not backfeed an unpowered source under any approved operating or service condition. | Protects the host computer, USB interface, controller power paths, and service personnel. | Analysis and test | Locked |
| NFR-PWR-005 | Brownout thresholds and shutdown behavior shall be documented and verified. | Ensures predictable rail collapse. | Analysis and test | TBD |

## 4. Reliability and boot requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-REL-001 | IPC-100 shall reach a deterministic hardware-safe state on every reset path. | Prevents unintended activation. | Test | Locked |
| NFR-REL-002 | External interface faults should be contained so a noncritical peripheral fault does not defeat core diagnostics where practical. | Improves fault isolation. | Analysis and test | Proposed |
| NFR-REL-003 | Critical output safe states shall be established by hardware and not only firmware. | Covers boot and firmware faults. | Inspection and test | Locked |
| NFR-REL-004 | Power cycling, brownout recovery, and repeated reset behavior shall be included in regression testing. | Captures intermittent startup failures. | Test | Locked |
| NFR-REL-005 | Quantitative reliability targets and expected service life shall be established before production release. | No supported lifetime has been approved. | Analysis | TBD |
| NFR-REL-006 | Approved components shall be reviewed for lifecycle status and supported alternates. | Reduces supply and obsolescence risk. | Inspection | Proposed |

## 5. Maintainability requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-MNT-001 | Stable signal names shall be used across hardware, firmware, harness, and test documentation. | Prevents interface ambiguity. | Inspection | Locked |
| NFR-MNT-002 | The controller shall provide labeled programming and diagnostic access. | Supports bring-up and service. | Inspection and demonstration | Locked |
| NFR-MNT-003 | A controller assembly should be replaceable without disturbing product high-current wiring where practical. | Reduces service risk. | Inspection and demonstration | Proposed |
| NFR-MNT-004 | Design decisions and unresolved items shall be recorded in controlled documentation. | Preserves design intent. | Inspection | Locked |
| NFR-MNT-005 | Product-neutral modules shall be preferred over duplicated product-specific implementations. | Supports long-term reuse. | Inspection | Locked |

## 6. Manufacturability requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-MFG-001 | Released manufacturing data shall identify hardware revision and approved source baseline. | Provides configuration control. | Inspection | Locked |
| NFR-MFG-002 | PCB silkscreen shall identify Iron Pine Outdoors, IPC-100, and Rev A as specified. | Supports traceability and service. | Inspection | Locked |
| NFR-MFG-003 | Connectors, polarity, pin 1, relay contacts, and test points shall be labeled where practical. | Reduces assembly and service errors. | Inspection | Locked |
| NFR-MFG-004 | Assembly and inspection criteria shall be defined before production release. | Enables repeatable workmanship. | Inspection | Locked |
| NFR-MFG-005 | Production test-fixture and programming requirements shall be defined before pilot manufacturing. | Supports repeatable acceptance testing. | Inspection and demonstration | Proposed |

## 7. Expandability requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-EXP-001 | Expansion shall remain within verified power, GPIO, thermal, bandwidth, and boot constraints. | Prevents invalid interface promises. | Analysis and test | Locked |
| NFR-EXP-002 | Released interfaces should remain backward compatible where safe and practical. | Protects product investment. | Inspection and regression test | Proposed |
| NFR-EXP-003 | Breaking interface changes shall receive a hardware/interface revision and compatibility review. | Makes incompatibility explicit. | Inspection | Locked |
| NFR-EXP-004 | Daughterboard support may be provided when mechanical and electrical limits are documented. | Preserves flexible evolution. | Analysis | Proposed |

## 8. Documentation requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-DOC-001 | Requirements shall have unique IDs, rationale, verification method, and status. | Enables traceability. | Inspection | Locked |
| NFR-DOC-002 | Unknown specifications and unapproved components shall be marked `TBD`. | Prevents assumptions from appearing final. | Inspection | Locked |
| NFR-DOC-003 | Architecture, requirements, connector, GPIO, power, mechanical, firmware, and test documents shall be cross-linked and consistent. | Supports controlled change. | Inspection | Locked |
| NFR-DOC-004 | Significant changes shall be recorded in the changelog and revision history. | Preserves project history. | Inspection | Locked |
| NFR-DOC-005 | Product-specific documentation shall remain in product repositories. | Protects platform scope. | Inspection | Locked |

## 9. Diagnostics requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-DIA-001 | Principal power rails shall have labeled test access. | Supports bring-up and failure analysis. | Inspection | Locked |
| NFR-DIA-002 | Base firmware should expose hardware revision, firmware version, reset cause, and available health data. | Supports service and traceability. | Demonstration | Proposed |
| NFR-DIA-003 | Diagnostic behavior shall not activate motors or the relay trigger path. | Keeps service operations safe. | Test | Locked |
| NFR-DIA-004 | Diagnostic protocol, retention, and access-control requirements shall be defined before firmware release. | Implementation is unresolved. | Inspection and test | TBD |

## 10. Firmware quality requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-FW-001 | Base firmware shall separate board support, drivers, platform services, and product application layers. | Improves reuse and testability. | Inspection | Locked |
| NFR-FW-002 | Hardware-dependent values shall be centralized and revision-controlled. | Simplifies revision support. | Inspection | Locked |
| NFR-FW-003 | Reusable drivers shall support automated unit or integration testing where practical. | Reduces regression risk. | Inspection and test | Proposed |
| NFR-FW-004 | Compiler, framework, library, and tool versions shall be pinned for controlled releases. | Improves reproducibility. | Inspection | Proposed |
| NFR-FW-005 | Watchdog, update, configuration-recovery, and fault-logging policies shall be approved before firmware release. | Core resilience policies are unresolved. | Inspection and test | TBD |

## 11. Electrical robustness requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-ERB-001 | Field-connected digital inputs shall include protection appropriate to the approved ESD and wiring-noise environment. | Supports robust external wiring. | Analysis and test | Locked |
| NFR-ERB-002 | Motor and other high-current return paths shall remain outside IPC-100. | Prevents conducted noise and PCB stress. | Inspection | Locked |
| NFR-ERB-003 | Sensitive analog and radio circuits shall be segregated from switching nodes and noisy cable entries. | Protects measurement and communication performance. | Inspection and test | Proposed |
| NFR-ERB-004 | Reverse polarity, surge, EFT, ESD, and conducted-immunity profiles shall be approved before qualification. | Test severity is not yet defined. | Analysis | TBD |
| NFR-ERB-005 | Components exposed to `VIN_RAW` shall have margin above the approved normal and transient limits. | Avoids operating at absolute maximum ratings. | Analysis | Locked |

## 12. Weather-resistance requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| NFR-WTH-001 | IPC-100 shall not claim an ingress-protection rating as a bare PCB. | Ingress protection belongs to the assembled product enclosure. | Inspection | Locked |
| NFR-WTH-002 | The consuming product enclosure should target IP65. | Establishes the current product integration target. | Product-level test | Proposed |
| NFR-WTH-003 | Connector, coating, labeling, and material choices shall be compatible with the approved enclosed outdoor environment. | Supports durability. | Analysis and test | TBD |

## 13. Related documents

- [Design Philosophy](../architecture/Design_Philosophy.md)
- [Non-Goals](../architecture/Non_Goals.md)
- [Functional Requirements](Functional_Requirements.md)
- [Hardware Requirements](Hardware_Requirements.md)
- [Mechanical Interface](Mechanical_Interface.md)
- [Test Plan](../testing/Test_Plan.md)
