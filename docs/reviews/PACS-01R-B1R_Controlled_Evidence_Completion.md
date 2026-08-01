# PACS-01R-B1R — Controlled Evidence Completion

Date: 2026-08-01

Baseline: `0b4b201`

## 1. Executive Summary

PACS-01R-B1R establishes a reproducible provisional thermal-board baseline, package constraints, hot-event inputs, SOA dispositions, tool manifests and a refreshable commercial register. No selected MPN is invalidated and no design change is indicated. The package is not accepted because U201/U203 tool exports do not exist, exact board-to-package thermal translation remains bounded rather than manufacturer-simulated, Q101/U101 hot SOA lacks sufficient manufacturer/board data, and twelve of thirteen unique MPNs lack authenticated two-distributor commercial records.

## 2. Scope

Evidence only. No schematic, requirement, architecture, GPIO, hierarchy, interface, footprint or PCB file is modified. No prototype test is performed.

## 3. Current Active Inventory

The current set remains 20 references and 13 unique MPNs: Q101; U101/U102; U201–U213 as controlled by PACS; U302; U706/U707; U801. The definitive per-reference function/package/blocker matrix remains `PACS-01R_Active_Device_Register.csv`. No active TPS26630 or TLV841 row exists.

## 4. Thermal-Board Baseline

The controlled [provisional thermal-board baseline](../evidence/thermal/IPC100_RevA_Provisional_Thermal_Board_Baseline.md) defines three quantitative cases. Case B is the qualification planning case: four-layer 1.6 mm FR-4, 1 oz copper, continuous L2 ground, compatible L3 plane, 900 mm² combined spreading, nine 0.20–0.30 mm finished vias at 0.8–1.0 mm pitch, +75 °C internal air, natural convection and TJ ≤110 °C. It is an assumption, not layout authorization.

## 5. Package-to-Board Thermal Correlation

| Group | Manufacturer evidence | Case A | Case B | Case C | Confidence |
| --- | --- | --- | --- | --- | --- |
| Q101/U101 | SOA/ZθJC or package metrics; no exact board model | Insufficient | Bounded, hot pulse still open | Bounded, hot pulse still open | LOW |
| U201 | PPQ loss 1.324 W requires effective θJA ≤26.4 °C/W | Fail/unproved | Unproved | Plausible, unproved | LOW |
| U203 | PPQ loss 0.582 W requires effective θJA ≤60.1 °C/W | Marginal/unproved | Plausible, unproved | Plausible, unproved | MEDIUM |
| TPS2553 | θJA 182.6 °C/W JEDEC; transient fault controls | Not acceptable for sustained fault | Conditional on fault duration | Conditional on fault duration | MEDIUM |
| Low-loss logic/supervisors/load switches | Low self-heating; published metrics board-dependent | Plausible | Plausible | Plausible | MEDIUM |
| U706/U707 | Low self-heating but +85 °C ambient rating | Marginal | Conditional on separation/measurement | Conditional | MEDIUM |

No θJA value is treated as portable without its manufacturer board condition. Exact junction values remain unavailable until tool/board simulation and prototype correlation.

## 6. Thermal Constraint Register

| References | Constraint | Classification |
| --- | --- | --- |
| U101/U201/U202/U203/U302/U801 | Solid exposed-pad connection; no thermal relief | MANDATORY FOR FOOTPRINT |
| U101/U201/U203 | Case B minimum: 900 mm² spreading and nine vias; ≤1.0 mm pitch | MANDATORY FOR PLACEMENT / ROUTING |
| Q101 | Manufacturer 5×6 land, solid drain copper and Case B spreading | MANDATORY FOR FOOTPRINT / ROUTING |
| TPS2553 branches | Case B copper, separation from ≥0.5 W sources, short-fault thermal validation | MANDATORY FOR PLACEMENT / PROTOTYPE VALIDATION |
| U706/U707 | ≥10 mm from U201/U203 unless thermal superposition is proven | MANDATORY FOR PLACEMENT |
| All thermal devices | ≥1 oz copper, continuous L2 coupling, no airflow credit | MANDATORY FOR ROUTING |
| All | Closed-enclosure +60 °C chamber correlation | PROTOTYPE VALIDATION |

## 7. U201 Manufacturer Tool Export

[U201 manifest](../evidence/manufacturer-tools/U201/Tool_Evidence_Manifest.md) records all controlled inputs and reproduction steps. The interactive TI tool was unavailable; no PDF, BOM, graph, operating table, timestamp or checksum exists. Closure is not claimed.

## 8. U203 Manufacturer Tool Export

[U203 manifest](../evidence/manufacturer-tools/U203/Tool_Evidence_Manifest.md) records all controlled inputs and reproduction steps. The interactive TI tool was unavailable; no numerical export exists. Closure is not claimed.

## 9. Tool Export Control Register

| Reference | Tool | Access date | Artifact | Hash | Confidence |
| --- | --- | --- | --- | --- | --- |
| U201 | TI WEBENCH Power Designer | 2026-08-01 | None — environment cannot access interactive export | N/A | BLOCKED |
| U203 | TI WEBENCH/equivalent | 2026-08-01 | None — environment cannot access interactive export | N/A | BLOCKED |

## 10. Hot Transient Operating Conditions

Starting boundary is +75 °C internal board air with initial junction determined by stabilized normal load. Q101/U101 use 21 V normal input, coordinated 55 V clamp review, 2 A/100 ms and 4 A/10 ms startup events, energy-limited abnormal pulse, and no repeat credit until cooldown is defined. TPS2553 uses 3.3 V (U209) or 5 V (U212/U213), 100 mA continuous, 150 mA/10 ms startup, 162.824–222.345 mA limit, shorted output, released branch capacitance, and fault duration controlled by thermal/retry behavior. Source impedance, repetition interval and clearing time remain prototype/test-plan inputs.

## 11. Q101 SOA Analysis

`IAUC100N08S5N034ATMA1`, PG-TDSON-8, is 80 V rated. The 55 V stress uses 68.8% of VDS rating. Screening conduction is 39 mW at 1.25 A and 100 mW at 2 A using the conservative 25 mΩ system limit. Infineon Rev. 1.1 publishes 25 °C-case SOA and ZθJC curves, but no defensible conversion proves the 2 A/100 ms linear point from a +75 °C board initial state. Avalanche is not credited; ±20 V gate protection and body-diode/reverse events remain controlled requirements.

Disposition: **BLOCKED — MANUFACTURER DATA/BOARD CORRELATION INSUFFICIENT**. This is not a demonstrated device failure.

## 12. U101 SOA Analysis

`TPS26631PWPR` uses the integrated FET plus Q101 reverse path. Screening internal-FET loss is 48 mW at 1.25 A and 124 mW at 2 A before hot resistance. The device documents 4.5–60 V operation, 67 V absolute, pulse behavior, thermal shutdown and external reverse-FET drive. Exact ILIM/PLIM/dVdt values, timer/retry state and repeated hot pulse energy are not available as a complete manufacturer-tool solution.

Disposition: **BLOCKED — TOOL/THERMAL CORRELATION INSUFFICIENT**.

## 13. TPS2553 SOA Analysis

All three `TPS2553QDBVRQ1` branches retain 141 kΩ ±1%, ≤100 ppm/°C and the accepted 162.824–222.345 mA range. QER-02's 100 mA continuous and 150 mA/10 ms startup contracts pass. Normal conduction is about 0.85 mW at 85 mΩ typical. Fault screens are 0.734 W on U209 and 1.112 W on U212/U213. TI publishes θJA 182.6, θJC(top) 122.2 and θJB 29.4 °C/W, plus 2 µs short response and thermal protection; no applicable transient Zθ/retry curve proves the +75 °C repeated-short junction history.

Disposition for U209/U212/U213: **CONDITIONAL — PCB THERMAL CONSTRAINT AND PROTOTYPE CONFIRMATION REQUIRED**. A sustained fault is not qualified.

## 14. SOA Dispositions

The controlled [SOA register](../evidence/soa/PACS-01R-B1R_SOA_Register.csv) contains five explicit dispositions. No selected device is marked `FAIL — SELECTED DEVICE INVALID`; two functions remain blocked by missing evidence and three branches are conditional on Case B and a released hot-fault test.

## 15. Commercial Evidence

The [commercial quote register](../evidence/commercial/PACS-01R-B1R_Commercial_Quote_Register.csv) covers all 13 unique MPNs and 20 references. It records DigiKey/Mouser columns, SKU, stock observation, date, MOQ, packaging, prices, lead time, alternate class, confidence and refresh rule. Only U101 has a current detailed DigiKey observation. Missing fields are explicitly `UNVERIFIED`; no future stock is guaranteed.

## 16. Alternate-Part Evidence

No cross-manufacturer drop-in alternate is approved. Logic package variants are `ELECTRICALLY APPROVED — FOOTPRINT MAY DIFFER`; most alternatives are `FUNCTIONAL ALTERNATE — ECO REQUIRED` or `CANDIDATE ONLY`; U101/U302/U801 are `NO APPROVED ALTERNATE`. This is conservative because pin, timing, threshold and thermal equivalence has not been demonstrated.

## 17. Commercial Quote Register

Planning evidence expires before prototype procurement and must be refreshed again before pilot production and every purchase order. A quote is not contractual pricing. Twelve unique MPNs lack authenticated second-distributor records or full quantity breaks, so commercial acceptance fails.

## 18. EBOM/AVL Reconciliation

The EBOM and AVL already contain the selected manufacturers, exact MPNs, packages, lifecycle and blocked sourcing status. They remain synchronized and blocked. This package does not add unsupported commercial values or mark devices frozen; the evidence registers carry the new provisional data until authenticated quotes/tool outputs exist.

## 19. Prototype Evidence Handoff

Remaining tests include enclosure thermography, regulator efficiency/load transient/startup/brownout, Q101/U101 pulse temperature, TPS2553 short/retry/current limit, U202 source transition, load-switch inrush, U302 timing, I²C partial-power/stuck-bus and U801 threshold sweeps. These are capable of invalidating an MPN only if a released limit fails. None is executed here, and PACS-01R-C is not authorized.

## 20. Risk Register

| Risk | Status |
| --- | --- |
| Tool outputs absent | Blocking, external access required |
| Thermal baseline not manufacturer-correlated | Blocking, simulation/export required |
| Q101/U101 hot SOA incomplete | Blocking, manufacturer/board evidence required |
| TPS2553 hot repeated fault | Conditional, Case B plus prototype test |
| Commercial matrix incomplete | Blocking, authenticated distributor capture required |

## 21. Validation Results

Targeted validation checks the 20-reference inventory, three thermal cases, both manifests, five SOA rows, thirteen commercial MPN rows, alternate classes, downstream prohibitions and zero-CAD scope. All repository validators and `git diff --check` are required.

## 22. Native ERC Status

Not required because no schematic change is authorized. `kicad-cli` remains unavailable; no ERC completion is claimed.

## 23. Remaining Evidence Gaps

Unavailable tool access is the controlling blocker, not an actual selected-device failure. Authenticated U201/U203 exports, manufacturer/board thermal correlation, hot Q101/U101 evidence and twelve complete two-distributor records remain absent.

Smallest unresolved package: **PACS-01R-B1R-X — External Tool and Authorized Quote Acquisition**. It requires user-accessible manufacturer tools and authenticated distributor/manufacturer quote capture; it may not change hardware.

## 24. Final Decision

# PACS-01R-B1R NOT ACCEPTED

PACS-01R-C and PPC-01 are not authorized. No selected active-device failure is demonstrated.
