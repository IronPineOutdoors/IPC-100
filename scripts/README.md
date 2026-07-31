# Engineering Scripts

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet/label/reference/UUID identities, frozen safety and GPIO interfaces, implemented package contracts, and zero footprint assignments. Its ECO-004 checks require exactly two independently rail-qualified fail-isolated J6/J7 branches, the sole Sheet 07 base-bus pull-up pair, the complete J13 USB-C UFP contact boundary, ten explicit unused-contact markers, independent CC Rd, connector-entry data/VBUS ESD, and the DNP shield network.
- `validate_icd002.ps1` verifies the ICD-002 release decision, all 54 frozen Sheet 09 ports, all eleven Rev A connector designation groups, J11/J12 nonpopulation, staged J6/J7 nets, and preserved GPIO constraints.

Package 09R implements Sheet 08 within ICD-001. ECO-004 corrects the J6/J7 branches on Sheet 07 and the protected USB-C UFP boundary on Sheet 09. Structural validation is not native KiCad ERC; ERC remains a separate release gate.
