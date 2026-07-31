# Engineering Scripts

Post-ECO-007 inventory contains 310 rows: 133 power-scope rows (9 frozen and 124 blocked for CSR-01A-R3) plus 177 out-of-scope rows. `validate_eco007.ps1` verifies the three corrected programming/supervisor networks, calculation evidence, fail-low behavior, reference/UUID uniqueness, balanced schematics, and zero footprints.

`validate_csr01ar3.ps1` verifies the CSR-01A-R3 final decision, complete power-row disposition, frozen-row evidence, blocker specificity, EBOM/AVL identity, ECO-007 regression, zero footprints, and unchanged schematic/PCB scope.

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet/label/reference/UUID identities, frozen safety and GPIO interfaces, implemented package contracts, and zero footprint assignments. Its ECO-004 checks require exactly two independently rail-qualified fail-isolated J6/J7 branches, the sole Sheet 07 base-bus pull-up pair, the complete J13 USB-C UFP contact boundary, ten explicit unused-contact markers, independent CC Rd, connector-entry data/VBUS ESD, and the DNP shield network.
- `validate_icd002.ps1` verifies the ICD-002 release decision, all 54 frozen Sheet 09 ports, all eleven Rev A connector designation groups, J11/J12 nonpopulation, staged J6/J7 nets, and preserved GPIO constraints.

Package 09R implements Sheet 08 within ICD-001. ECO-004 corrects the J6/J7 branches on Sheet 07 and the protected USB-C UFP boundary on Sheet 09. Structural validation is not native KiCad ERC; ERC remains a separate release gate.

SSR-01R uses all three validators as structural regression evidence for the post-ECO-004 Sheet 00–09 baseline. The checks cover the 54 frozen Sheet 09 ports, four ECO-003 ports, GPIO37/GPIO42 constraints, hierarchy, references, UUIDs, S-expression balance, ECO-004 interfaces, and zero footprints. They do not prove exact-device pin mapping, analog limits, timing, partial-power behavior, USB signal integrity, EMC, or native ERC.

- `generate_csr01_inventory.ps1` extracts every non-power-symbol schematic instance into the canonical EBOM and AVL sources. CSR-01A-R overlays only reviewed selections: nine exact 100 kΩ low-voltage bias/enable resistors are `FROZEN`, 115 power rows receive specific `BLOCKED` reasons, and all 177 unrelated rows remain `NOT YET FROZEN`. It does not infer unreviewed MPNs, packages, ratings, vendors, or prices.
- `csv_to_xlsx.py` converts a UTF-8 CSV source into a reviewable, filtered, header-frozen XLSX using Python's standard library. The CSV remains canonical.
- `normalize_references_eco005.ps1` applies and verifies the deterministic Sheet 01–09 reference ranges, preserves connector/DFT identifiers, rejects global duplicates, and generates the permanent old/new register. It is idempotent on an already-normalized ECO-005 baseline.
- `validate_csr01ar.ps1` verifies the 301-row EBOM/AVL reconciliation, 124-row power scope, nine fully populated frozen selections, 115 specifically blocked power rows, 177 out-of-scope dispositions, allowed status vocabulary, reference uniqueness, and EBOM/AVL MPN/status agreement.

After ECO-005, `validate_kicad_hierarchy.ps1` also enforces project-wide reference uniqueness and owning-sheet numeric ranges. This is a structural identity check; it does not replace native KiCad annotation/ERC review.
