# Engineering Scripts

Future repeatable utilities for documentation checks, BOM validation, manufacturing packages, test automation, and release generation belong here. Scripts should be documented and safe by default.

- `validate_kicad_hierarchy.ps1` validates project JSON, schematic S-expression balance, child references, root/child port parity, unique sheet/label/reference/UUID identities, frozen safety and GPIO interfaces, implemented package contracts, and zero footprint assignments. Its ECO-004 checks require exactly two independently rail-qualified fail-isolated J6/J7 branches, the sole Sheet 07 base-bus pull-up pair, the complete J13 USB-C UFP contact boundary, ten explicit unused-contact markers, independent CC Rd, connector-entry data/VBUS ESD, and the DNP shield network.
- `validate_icd002.ps1` verifies the ICD-002 release decision, all 54 frozen Sheet 09 ports, all eleven Rev A connector designation groups, J11/J12 nonpopulation, staged J6/J7 nets, and preserved GPIO constraints.

Package 09R implements Sheet 08 within ICD-001. ECO-004 corrects the J6/J7 branches on Sheet 07 and the protected USB-C UFP boundary on Sheet 09. Structural validation is not native KiCad ERC; ERC remains a separate release gate.

SSR-01R uses all three validators as structural regression evidence for the post-ECO-004 Sheet 00–09 baseline. The checks cover the 54 frozen Sheet 09 ports, four ECO-003 ports, GPIO37/GPIO42 constraints, hierarchy, references, UUIDs, S-expression balance, ECO-004 interfaces, and zero footprints. They do not prove exact-device pin mapping, analog limits, timing, partial-power behavior, USB signal integrity, EMC, or native ERC.

- `generate_csr01_inventory.ps1` extracts every non-power-symbol schematic instance into the canonical EBOM and AVL sources. For CSR-01A it deterministically labels the 124 power-scope rows `BLOCKED - CSR-01A` and all 177 unrelated rows `NOT YET FROZEN`; it deliberately does not infer MPNs, packages, ratings, vendors, or prices.
- `csv_to_xlsx.py` converts a UTF-8 CSV source into a reviewable, filtered, header-frozen XLSX using Python's standard library. The CSV remains canonical.
- `normalize_references_eco005.ps1` applies and verifies the deterministic Sheet 01–09 reference ranges, preserves connector/DFT identifiers, rejects global duplicates, and generates the permanent old/new register. It is idempotent on an already-normalized ECO-005 baseline.

After ECO-005, `validate_kicad_hierarchy.ps1` also enforces project-wide reference uniqueness and owning-sheet numeric ranges. This is a structural identity check; it does not replace native KiCad annotation/ERC review.
