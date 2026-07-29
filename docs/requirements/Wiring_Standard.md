# IPC-100 Wiring Standard

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Wiring Standard |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Scope

This document defines platform-level wiring practices at the IPC-100 boundary. Product harness lengths, routing, enclosure feedthroughs, and product-specific wire lists belong in product repositories.

## 2. Signal naming

Harness drawings, labels, test fixtures, firmware, and schematics shall use the stable signal names in the [Connector Specification](../connectors/Connector_Specification.md). Do not substitute informal names for safety-relevant signals.

## 3. Recommended wire colors

This is a recommendation, not a locked production standard. Every released harness must define its actual colors.

| Function | Recommended color |
| --- | --- |
| Positive raw power | Red |
| Ground/return | Black |
| Switched or protected positive power | Orange |
| 5 V | Yellow |
| 3.3 V | Brown |
| Communications | Blue/white pairs |
| Other signals | Assigned consistently per harness |

## 4. Ground conventions

- Identify logic ground as `GND`.
- Do not route external motor return current through IPC-100 ground conductors.
- Do not use connector shells or shields as the sole logic return.
- Document any chassis or shield termination at both schematic and harness level.
- Avoid undocumented ground splices.

## 5. Power wiring

- Size conductors, contacts, fuses, and splices for verified continuous and peak current with margin.
- Place the product main fuse near the energy source.
- Independently fuse the IPC-100 control branch and each high-current branch.
- Keep raw power polarity and voltage markings visible.
- Do not route motor power through an IPC-100 connector.

## 6. Logic and communication wiring

- Keep logic wiring separated from motor leads and switching nodes.
- Route each external control or motion-limit signal with its documented common or return conductor where practical.
- Use twisted signal/return pairs for noise-sensitive or longer digital runs where practical.
- Use twisted differential pairs for future CAN and RS485.
- Maintain pair integrity through connectors and junctions.
- Document I2C cable-length limits after prototype validation.

Shielding requirements, mandatory twisted-pair use, conductor gauge, maximum cable length, and grounding method for external inputs remain `TBD`. Product harnesses own strain relief, abrasion protection, connector retention, and service-loop implementation.

## 7. Shielding guidance

Shielding is application-dependent and remains TBD until EMC testing. Where used, document shield material, termination point, drain wire, and whether one-end or both-end termination is required. Do not leave shields floating without an explicit reason.

## 8. Mechanical practices

- Provide strain relief independent of electrical contacts.
- Respect manufacturer bend-radius limits.
- Provide service loops where they improve access without permitting abrasion or entanglement.
- Prevent cables from contacting sharp edges, moving parts, heat sources, and standing water.
- Product designs should use drip loops where cable routing may conduct water toward an enclosure entry.

## 9. Identification

- Label connectors with their reference designator and function.
- Label harnesses with a unique part number, revision, and end identification.
- Identify pin 1 and polarity at assembly and service points.
- Use durable labels compatible with the expected temperature, moisture, and abrasion.

## 10. Termination and splices

- Use tooling and process controls approved for the selected terminal system.
- Record crimp tool, locator, die, wire range, strip length, and pull-test criteria.
- Production splices require an approved drawing and environmental sealing appropriate to their location.
- Avoid field splices where a replaceable harness section is practical.
- Solder-only wire splices are not an assumed production method and require specific approval.

## 11. Field repair

Service procedures should favor keyed replacement assemblies over pin-level repair. Any permitted field repair must define compatible parts, tools, sealing restoration, polarity checks, and post-repair tests.

## 12. Prototype versus production

Prototype connectors and wire colors may differ from production when clearly documented and labeled. Prototype deviations must not be copied into production drawings without review. Production designs should use locking, polarized, vibration-suitable connectors where practical.

## 13. Documentation requirements

Each released harness drawing shall include:

- Harness part number and revision
- Connector manufacturer and part numbers
- Terminal, seal, plug, and accessory part numbers
- Wire type, gauge, color, and length
- Pin-to-pin wire list using stable signal names
- Splice and shield details
- Branch dimensions and tolerances
- Labels and orientation
- Applicable assembly and inspection standards
- Continuity and hipot/insulation tests where applicable

For every external control and motion-limit input, product wiring documentation shall also identify the contact type, active state, common or return, fault interpretation, and connector pinout.

## 14. Continuity-test expectations

Test every production harness for correct pin-to-pin continuity, absence of unintended shorts, polarity, and required shield continuity. Record acceptance limits for contact resistance and insulation when those limits are approved.

## 15. Harness inspection checklist

- [ ] Part number and revision match the work order.
- [ ] Connector bodies, keys, seals, and terminals are correct.
- [ ] Wire gauge, type, and color match the drawing.
- [ ] Crimps meet visual and pull-test criteria.
- [ ] Splices and shields match the drawing.
- [ ] Branch dimensions and labels are correct.
- [ ] Strain relief and bend radius are acceptable.
- [ ] No exposed conductor, damaged insulation, or loose hardware is present.
- [ ] Continuity, short, polarity, and shield tests pass.
- [ ] Product-specific sealing requirements are restored.
