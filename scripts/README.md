# Engineering Scripts

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates the Package 01 project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet and label names, required deferral notes, and absence of component symbols or footprint assignments.
