# ECO-005 — Global Reference Designator Normalization

## Purpose

ECO-005 assigns globally unique, deterministic reference designators to the IPC-100 Rev A schematic without changing electrical behavior. The change removes the component-identity ambiguity identified by CSR-01 before exact-part selection, footprint assignment, PCB annotation, manufacturing documentation, test, service, or later ECO traceability.

## Original Duplicate Count

CSR-01 inventoried 301 physical/logical schematic rows and found 63 reference names repeated across child sheets. Those references were locally unique but not globally unique. The normalization map contains 307 rows when the six nonphysical `#PWR` symbols are included.

## Numbering Strategy

Each non-connector reference uses `sheet number × 100 + original local number`. Existing multi-unit suffixes are retained, for example `U1AB` on Sheet 04 becomes `U401AB`. This gives every sheet a stable 99-position range per prefix while preserving the original relative numbering.

| Sheet | Function | Allocated examples |
| --- | --- | --- |
| 01 | Power Entry | `R101–R199`, `C101–C199`, `D101–D199`, `F101–F199`, `L101–L199`, `Q101–Q199`, `U101–U199` |
| 02 | Power Conversion | `R201–R299`, `C201–C299`, `D201–D299`, `L201–L299`, `U201–U299` |
| 03 | ESP32 Core | `R301–R399`, `C301–C399`, `SW301–SW399`, `U301–U399` |
| 04 | Safety Inputs | `R401–R499`, `C401–C499`, `D401–D499`, `U401–U499` |
| 05 | Motor Interfaces | `R501–R599`, `C501–C599`, `D501–D599`, `U501–U599` |
| 06 | Relay/Master Inhibit | `R601–R699`, `C601–C699`, `D601–D699`, `Q601–Q699`, `K601–K699`, `U601–U699` |
| 07 | UI/Peripherals | `R701–R799`, `C701–C799`, `Q701–Q799`, `U701–U799`, `TP701–TP799` |
| 08 | Expansion | `R801–R899`, `C801–C899`, `D801–D899`, `FB801–FB899`, `U801–U899`, `TP801–TP899` |
| 09 | Connectors/Test | Connector designations preserved; non-connectors use `R901–R999`, `C901–C999`, `D901–D999` |

The narrower example subranges in the mission are treated as planning guidance. Using the complete two-digit suffix space consistently preserves separation and does not consume another sheet's range.

## Reference Allocation

- 301 physical/logical component rows reviewed.
- 288 non-connector physical/logical references normalized.
- 12 `J` connector designations and `DFT1` preserved.
- Six `#PWR` references preserved; they were already sheet-qualified and are not BOM items.
- Final global duplicate count: zero.

The permanent old-to-new mapping is maintained in `docs/reference/Reference_Designator_Register.md`.

## Affected Sheets

Sheets 01 through 09 were mechanically updated. Sheet 00 contains no physical component instance requiring normalization and was not modified. The only changed schematic fields are instantiated `Reference` properties and matching project-instance `reference` values.

Frozen connector designations `J1` through `J10` and `J13` remain unchanged. Documentation-only `J11` and `J12` names remain unchanged. The split `J8A`/`J8B` identifiers, all ICD interface names, sheet numbers, hierarchy labels, signal labels, net labels, GPIO allocation, and test-node prefix convention are preserved.

## Validation

- Every physical/logical component has exactly one global reference.
- Global duplicate count is zero.
- All non-connector references fall in their deterministic sheet range.
- The 301-row EBOM regenerates with zero repeated reference names.
- A zero-context schematic diff audit reports that changed content is confined to component `Reference` properties, matching instance `reference` values, and four documentation/value cross-references updated to the new names.
- Therefore symbol UUIDs, symbol identities, electrical values, pins, wires, junctions, no-connects, nets, hierarchy, GPIOs, and electrical logic are byte-for-byte unchanged outside reference and reference-documentation fields.
- Connector and DFT functional designations are preserved.
- Repository hierarchy, GPIO, ICD-002, S-expression, UUID, reference, and zero-footprint checks pass.
- No PCB file exists in the ECO diff.
- Native KiCad ERC remains pending because `kicad-cli` is unavailable; reference-only structural validation is not represented as native ERC.

## Risk Assessment

| Risk | Control | Residual status |
| --- | --- | --- |
| Net or logic changed during bulk edit | Diff permits only the two reference field forms | Closed |
| UUID regenerated | UUID validation plus reference-only diff | Closed |
| Connector contract broken | All `J` references explicitly exempt and validator checks ICD-002 | Closed |
| Old documentation loses traceability | Permanent 307-row old/new register | Closed |
| Future duplicate introduced | Global uniqueness and sheet-range checks added to repository validator | Controlled |
| Historical package records use old references | Register provides translation; historical records are not rewritten | Observation |

## Future Numbering Policy

1. New components use the owning sheet's prefix and `x01–x99` numeric range.
2. Existing references are never compacted or reused merely because a component is removed.
3. Multi-unit suffixes remain attached to the common base number until exact physical decomposition is approved.
4. Connector functional designations remain controlled by ICD-002 and are not automatically renumbered.
5. A component moved between sheets requires an ECO and a new owning-sheet reference; the old number is retired.
6. Every schematic change must run global uniqueness, sheet-range, hierarchy, GPIO, UUID, zero-footprint, and diff checks.

## Final Decision

# ECO-005 COMPLETE

CSR-01A Power Component Selection is authorized.
