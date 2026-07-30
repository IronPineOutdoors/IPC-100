# Engineering Scripts

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates the Package 01 project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet and label names, required deferral notes, and absence of component symbols or footprint assignments.

Sheets 08 and 09 remain unimplemented placeholders. ICD-001 now authorizes a restricted Package 09R Sheet 08 implementation, but the hierarchy validator shall continue rejecting Sheet 08 component symbols until that package deliberately updates the implemented-sheet validation scope.
