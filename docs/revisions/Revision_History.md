# IPC-100 Revision History

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Revision History |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Revision identity

IPC-100 begins at hardware Rev A. Prior CrossWind controller concepts are predecessor work only; they do not make IPC-100 Rev D or transfer any earlier product revision number to this platform.

Rev A is currently in architecture and requirements definition. No prototype build, production candidate, or released hardware is claimed.

## 2. Version types

| Version type | Meaning | Example | Controlled independently |
| --- | --- | --- | --- |
| Hardware revision | Manufactured electrical/mechanical board baseline | Rev A | Yes |
| Prototype build | Iteration within an unreleased hardware revision | A0, A1, A2 | Yes |
| Production candidate | Candidate configuration submitted for release verification | A-RC1 | Yes |
| Documentation revision | Revision/date of a controlled document | Document-specific | Yes |
| Firmware version | Software release compatible with defined hardware | Semantic/version policy TBD | Yes |

The same letter or number appearing in different version types does not imply equivalence.

## 3. Suggested Rev A progression

```text
IPC-100 Rev A
Prototype build: A0, A1, A2
Production candidate: A-RC1
Released production: Rev A
```

This is a naming format only. IPC-100 has not reached any listed build or release stage.

## 4. When hardware revision increments

A new hardware revision is normally required when an approved change alters:

- PCB copper, stack-up, drill, outline, or assembly population
- Connector pinout, mating compatibility, or electrical ratings
- Form, fit, function, safety, or regulatory behavior
- Power architecture or externally observable electrical behavior
- Component substitution that changes validated performance or layout
- Mounting interface or service compatibility
- Manufacturing or test requirements that affect the physical design

The engineering change process shall determine whether a prototype iteration or new revision is appropriate before fabrication data is released.

## 5. Documentation-only changes

The following may remain within a hardware revision when they do not alter the manufactured design:

- Typographical and formatting corrections
- Clarification consistent with the released design
- Added traceability, test evidence, or links
- Corrected diagrams that do not change connectivity
- Process guidance that does not change form, fit, function, or safety

Documentation-only changes still require document revision control and review. A documentation edit must not silently redefine a released interface.

## 6. Hardware revision record

| Hardware revision | Prototype/build | Date | Status | Summary | Approval |
| --- | --- | --- | --- | --- | --- |
| Rev A | Not assigned | TBD | Architecture and requirements definition | Initial reusable IPC-100 platform | Pending |

## 7. Documentation record

| Date | Document set | Change summary | Owner | Review status |
| --- | --- | --- | --- | --- |
| 2026-07-28 | Repository baseline | Created initial engineering repository | Iron Pine Outdoors Engineering | Historical |
| 2026-07-28 | Platform boundary | Separated IPC-100 from product-specific CrossWind development | Iron Pine Outdoors Engineering | Historical |
| 2026-07-28 | Rev A Engineering Blueprint | Defined architecture, requirements, connectors, GPIO planning, power, wiring, mechanics, revision policy, and ADRs | Iron Pine Outdoors Engineering | Pending approval |

## 8. Prototype traceability

Every physical prototype shall be marked and recorded with:

- `IPC-100`
- Hardware revision
- Prototype build identifier
- Unique serial number
- Assembly date or lot
- BOM and fabrication-package identifiers
- Installed firmware version
- Rework/deviation record
- Test disposition

Prototype build identifiers shall not be reused.

## 9. External compatibility

CrossWind is the first planned external application and remains in a separate repository. Its compatibility record should identify the IPC-100 hardware revision, prototype/release state, connector baseline, and base-firmware version it consumes.

## 10. Related documents

- [Design Decisions](../architecture/Design_Decisions.md)
- [System Architecture](../architecture/System_Architecture.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
