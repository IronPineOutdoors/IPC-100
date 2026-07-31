# IPC-100 Engineering BOM

This directory contains controlled IPC-100 Rev A component-selection artifacts.

CSR-01 produced a complete 301-row as-captured schematic inventory, but did not freeze components. Every EBOM/AVL row is marked blocked because exact topology, order codes, quantitative limits, lifecycle, sourcing, or physical-interface information remains unresolved. These files must not be used for procurement or footprint assignment.

ECO-005 subsequently normalized all schematic references. CSR-01A-R now classifies the 124 power-scope rows as nine `FROZEN` low-voltage 100 kΩ bias/enable resistors and 115 specifically `BLOCKED` rows; the 177 unrelated rows remain `NOT YET FROZEN`. The partial freeze does not authorize footprints, procurement of blocked rows, or PCB work.

- `IPC100_RevA_EBOM.csv` — canonical machine-readable inventory.
- `IPC100_RevA_EBOM.xlsx` — review workbook generated from the canonical CSV.
- `Approved_Vendor_List.xlsx` — scope-aware blocked AVL workbook; no vendor is approved yet.
- `Approved_Vendor_List.csv` — canonical machine-readable AVL source.
- `CSR-01_Inventory_Summary.csv` — inventory/freeze summary.

Regenerate the CSV sources with `scripts/generate_csr01_inventory.ps1` and the workbooks with `scripts/csv_to_xlsx.py`. CSR-01B remains unauthorized. Acceptance requires ECO-006, J1 mechanical-interface release, and a reissued power review after every remaining power MPN, calculation, derating, sourcing, alternate, and cost field is verified.
