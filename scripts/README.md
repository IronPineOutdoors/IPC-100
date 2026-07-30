# Engineering Scripts

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates the Package 01 project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet and label names, required deferral notes, and absence of component symbols or footprint assignments.
- `validate_icd002.ps1` verifies the ICD-002 release decision, all 54 frozen Sheet 09 ports, all eleven Rev A connector designation groups, J11/J12 nonpopulation, staged J6/J7 nets, and preserved GPIO constraints.

Package 09R implements Sheet 08 within ICD-001. The hierarchy validator enforces the required rail qualification, fail-disabled segment buffer, two external pull-ups, filtering, protection, DFT nodes, frozen ports, prohibited-interface boundary, and zero-footprint scope. Sheet 09 remains an unimplemented placeholder.
