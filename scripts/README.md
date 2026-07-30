# Engineering Scripts

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates the Package 01 project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet and label names, required deferral notes, and absence of component symbols or footprint assignments.

Following the Package 09 entry-gate review, Sheets 08 and 09 remain unimplemented placeholders. The hierarchy validator rejects component symbols outside implemented Sheets 01–07, preventing Sheet 08 capture until the J10 interface contract is released.
