# IPC-100 Engineering BOM

This directory contains controlled IPC-100 Rev A component-selection artifacts.

CSR-01 produced a complete 301-row as-captured schematic inventory, but did not freeze components. Every EBOM/AVL row is marked blocked because exact topology, order codes, quantitative limits, lifecycle, sourcing, or physical-interface information remains unresolved. These files must not be used for procurement or footprint assignment.

ECO-005 subsequently normalized all schematic references and regenerated these artifacts. CSR-01A then classified 124 power-scope rows as `BLOCKED - CSR-01A` and the 177 unrelated rows as `NOT YET FROZEN`. No manufacturer part number or vendor is approved: unresolved quantitative, thermal, timing, connector, sourcing, and derating inputs prevent a defensible power freeze.

- `IPC100_RevA_EBOM.csv` — canonical machine-readable inventory.
- `IPC100_RevA_EBOM.xlsx` — review workbook generated from the canonical CSV.
- `Approved_Vendor_List.xlsx` — scope-aware blocked AVL workbook; no vendor is approved yet.
- `Approved_Vendor_List.csv` — canonical machine-readable AVL source.
- `CSR-01_Inventory_Summary.csv` — inventory/freeze summary.

Regenerate the CSV sources with `scripts/generate_csr01_inventory.ps1` and the workbooks with `scripts/csv_to_xlsx.py`. CSR-01B remains unauthorized. Acceptance requires a reissued power review after every power MPN, rating, lifecycle, alternate, vendor, calculation, derating, and cost field is verified.
