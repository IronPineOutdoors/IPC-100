# Engineering Scripts

`apply_eco010_bom_overlay.ps1` synchronizes the ECO-010 U101/U801 implementation and new support references into EBOM/AVL CSV/XLSX artifacts while retaining PACS-01R blockers. `validate_eco010.ps1` checks the corrected physical architectures, threshold network, change-control scope, reference integrity and BOM/AVL reconciliation.

`apply_pacs01r_bom_overlay.ps1` records the 20-reference PACS-01R blocked disposition and regenerates BOM/AVL workbooks. `validate_pacs01r.ps1` verifies the reconciled inventory, corrected U101/U801 implementations, passive-dependency evidence, BOM/AVL agreement, single NOT ACCEPTED decision and zero-CAD scope.

`validate_pacs01ra.ps1` verifies the complete PACS-01R-A evidence matrix, blocker classifications, no-change closure assessment, PACS-01R-B authorization, downstream prohibitions and zero-CAD review scope.

`validate_pacs01rb.ps1` verifies PACS-01R-B coverage of all 20 active references, thermal/derating/lifecycle/sourcing evidence, the exact remaining evidence gaps, downstream prohibitions and zero-CAD scope.

Post-ECO-007 inventory contains 310 rows: 133 power-scope rows (9 frozen and 124 blocked for CSR-01A-R3) plus 177 out-of-scope rows. `validate_eco007.ps1` verifies the three corrected programming/supervisor networks, calculation evidence, fail-low behavior, reference/UUID uniqueness, balanced schematics, and zero footprints.

`validate_csr01ar3.ps1` verifies the CSR-01A-R3 final decision, complete power-row disposition, frozen-row evidence, blocker specificity, EBOM/AVL identity, ECO-007 regression, zero footprints, and unchanged schematic/PCB scope.

`validate_dra01.ps1` independently classifies every blocked power row into exactly one DRA-01 root cause, checks the 19/37/67/1 population, verifies the maturity and package recommendations, and enforces the single COMPLETE decision.

`generate_peb01_register.ps1` regenerates the 124-row power evidence register from the canonical EBOM without changing any component disposition. `validate_peb01.ps1` verifies coverage, key calculations, assumption classifications, the 56-row forecast, prohibited-scope preservation, and the single COMPLETE decision.

`generate_ppq01_register.ps1` regenerates the 124-row qualification register. `validate_ppq01.ps1` independently verifies corner/load/thermal/stress calculations, 50 eligible and 74 ineligible rows, the TPS2553/QER conflict, evidence coverage, prohibited-scope preservation, and the single COMPLETE decision.

`validate_eco008.ps1` verifies the three-device/three-resistor inventory, independently proves the original empty RILIM legal window, confirms the six rows remain blocked and unchanged, enforces the historical INCOMPLETE decision, and reruns PPQ/ECO/hierarchy regressions.

`validate_qer02.ps1` verifies the QER-02 inventory, peak waveforms, protected-element evidence, 160–225 mA positive windows, TPS2553 equations, controlled QER-01 amendment, preserved design artifacts, and single ACCEPTED decision. It runs all existing repository validators.

`validate_eco008r.ps1` verifies all three 141 kΩ RILIM networks, recomputes 162.824–222.345 mA with tolerance and temperature drift, checks EBOM/AVL synchronization and blocked MPN status, and enforces hierarchy, GPIO, zero-footprint, and scope invariants.

`validate_csr01ar4.ps1` reconciles all 133 power rows, enforces the 9/0/124/0 disposition, exact evidence on frozen rows, named closure packages on blocked rows, TPS2553/QER-02 regression, CSV/XLSX synchronization, no obsolete RILIM annotation, and review-only scope.

`generate_ppq02_register.ps1` maps all 124 blocked rows into the PPQ-02 evidence register. `validate_ppq02.ps1` checks unique 18 PPC / 85 PAS / 20 PACS / 1 JCS coverage, appendices, calculation invariants, TPS2553 regression, and evidence-only scope. `generate_pas01_register.ps1` creates the controlled 85-row passive selection register without assigning footprints.

`generate_pas01r_register.ps1` creates the 18-row dependent-passive disposition register. `apply_pas01r_bom_overlay.ps1` updates only those 18 controlled EBOM/AVL rows. `validate_pas01r.ps1` enforces 17 named PACS dependencies, the C305 timing ECO, preservation of the 67 PAS candidates and nine earlier frozen passives, BOM/AVL agreement, and zero-CAD scope.

`apply_eco009_bom_overlay.ps1` synchronizes the corrected generic C305 timing class into the EBOM/AVL. `validate_eco009.ps1` checks the 93.1 nF value, 99.642 ms nominal result, 79.1–136.6 ms endpoint stack, unchanged C305 reference/UUID/connection, reference-register and BOM/AVL synchronization, and narrow schematic scope.

`validate_qer03.ps1` verifies the released U302/C305 timing start event, 100 ms nominal interpretation, 75–150 ms design limits, 76–149 ms guarded prototype limits, brownout restart, startup/authorization semantics, ECO-009R authorization, and requirements-only scope.

`apply_eco009r_bom_overlay.ps1` synchronizes only the C305 generic electrical requirement across EBOM/AVL CSV and XLSX artifacts. `validate_eco009r.ps1` verifies QER-03 margins, unchanged CT/reset topology, failure-safe startup ordering, synchronized records, zero footprints and the narrow ECO-009R scope.

`apply_pacs01_bom_overlay.ps1` records the 20-reference active-device audit while keeping every row blocked and regenerates the EBOM/AVL workbooks from canonical CSV. `validate_pacs01.ps1` enforces the 18-candidate/two-blocker disposition, TPS2553 and TPS389030 compatibility, BOM/AVL agreement, a single non-accepted decision and zero-CAD scope.

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
