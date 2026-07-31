# IPC-100 Engineering BOM

This directory contains controlled IPC-100 Rev A component-selection artifacts.

CSR-01 produced a complete 301-row as-captured schematic inventory, but did not freeze components. Every EBOM/AVL row is marked blocked because exact topology, order codes, quantitative limits, lifecycle, sourcing, or physical-interface information remains unresolved. These files must not be used for procurement or footprint assignment.

- `IPC100_RevA_EBOM.csv` — canonical machine-readable inventory.
- `IPC100_RevA_EBOM.xlsx` — review workbook generated from the canonical CSV.
- `Approved_Vendor_List.xlsx` — blocked AVL workbook; no vendor is approved yet.
- `Approved_Vendor_List.csv` — canonical machine-readable AVL source.
- `CSR-01_Inventory_Summary.csv` — inventory/freeze summary.

Regenerate the CSV sources with `scripts/generate_csr01_inventory.ps1` and the workbooks with `scripts/csv_to_xlsx.py`. Acceptance requires a follow-up CSR after all MPN, rating, lifecycle, alternate, vendor, derating, and cost fields are verified.
