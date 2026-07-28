# IPC-100 Mechanical Interface

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Mechanical Interface |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Scope

This document defines the platform-level mechanical requirements for mounting, enclosing, servicing, and replacing IPC-100. Final product mechanics remain in product repositories.

## 2. PCB mounting philosophy

- Use defined mounting holes and supported board regions.
- Avoid PCB bending during installation and connector mating.
- Keep conductive hardware clear of exposed circuitry.
- Define mounting-hole plating, grounding intent, fastener stack, and torque before layout release.
- Maximum board dimensions are `TBD`.
- Final board outline and mounting-hole coordinates are `TBD`.

## 3. Connector and board-edge access

Connectors should be placed for visible keying, direct mating, latch access, and tool clearance. Enclosures must provide service clearance without pulling on wiring. Board-edge connectors shall have documented mating envelopes and keep-outs.

## 4. Service access

- USB-C shall be accessible in the defined service configuration.
- Status indicators shall be visible directly or through a documented light path.
- Programming and diagnostic access shall not require removing unrelated product mechanisms where practical.
- Test points shall remain probe-accessible during controller bring-up and service.
- The controller should be replaceable as an assembly without disturbing high-current product wiring where practical.

## 5. Enclosure compatibility

IPC-100 will be installed within a product-level enclosure targeting IP65. The controller mechanical design shall define clearances, mounting, connector access, and anticipated conformal coating. The product repository owns enclosure seams, glands, vents, drain paths, impact protection, and IP validation.

## 6. Thermal and environmental considerations

- Provide airflow or conductive paths appropriate to verified regulator and relay dissipation.
- Keep temperature-sensitive devices away from local heat sources where practical.
- Define conformal-coating keep-outs for connectors, USB contacts, switches, test points, labels, and other non-coatable areas.
- Select connector retention and mounting suitable for the verified vibration profile.
- Respect cable and connector manufacturer bend-radius requirements.
- Product routing should use drip loops and condensation controls where appropriate.

## 7. Required silkscreen and markings

The PCB shall include:

```text
IRON PINE OUTDOORS
IPC-100
REV A
```

It shall also include, where space and manufacturing rules permit:

- Connector reference designators
- Pin-1 markings
- Input and output polarity markings
- Voltage-domain markings
- `RELAY_NC`, `RELAY_COM`, and `RELAY_NO` labels
- Test-point labels
- Board serial or traceability marking area

## 8. Exclusions

The IPC-100 mechanical definition excludes:

- Product-level battery mount or battery adapter
- Product-level high-current converter mounting
- Product-level motor-driver mounting
- Motors, throwers, actuator mounts, and moving junction hardware
- Product enclosure, panel, and user-interface enclosure
- Product harness routing and dimensions

## 9. Open mechanical items

| ID | Item | Status |
| --- | --- | --- |
| MEC-TBD-001 | Maximum PCB dimensions | TBD |
| MEC-TBD-002 | Board outline and mounting-hole coordinates | TBD |
| MEC-TBD-003 | Mounting-hole plating and chassis-ground strategy | TBD |
| MEC-TBD-004 | Connector mating and service envelopes | TBD |
| MEC-TBD-005 | Vibration and shock profile | TBD |
| MEC-TBD-006 | Thermal dissipation and enclosure interface | TBD |
| MEC-TBD-007 | Conformal-coating material and keep-out process | TBD |

## 10. Related documents

- [System Architecture](../architecture/System_Architecture.md)
- [Hardware Requirements](Hardware_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
- [Wiring Standard](Wiring_Standard.md)
