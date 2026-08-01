# PACS-01R — Power Active Component Selection Revalidation

Date: 2026-08-01

Platform: IPC-100 Rev A

Baseline: ECO-010 commit `10d7e78`

## 1. Executive Summary

ECO-010 closes both physical incompatibilities that caused PACS-01 to fail: U101 is now the orderable `TPS26631PWPR` in its correct 20-pin PWP architecture, and U801 is now `TPS3899DL01DSER` with an explicit divider, hysteresis-feedback, pull-up and delay network. Those corrections are verified and no stale active TPS26630 or TLV841 implementation remains.

PACS-01R cannot freeze the complete active set. The released evidence still labels every active row as analytically incomplete, the 17 PACS-dependent passives remain unresolved, regulator stability/thermal closure depends on manufacturer tools and exact passive curves, Q101 hot linear SOA remains uncorrelated to the final protection timing/copper model, and current complete distributor price/lead-time evidence is absent. These are prohibited uses of `CONDITIONAL` because failure can change passive value, package family, or schematic implementation.

## 2. Scope

The controlled inventory is 20 physical power-active references: Q101; U101, U102; U201–U213 excluding U214; U302; U706/U707; and U801. ECO-010 replaced the physical implementations of U101 and U801 in place, adding no active reference and retiring no reference. Q102 is a protection-class discrete routed to PPC-01 and is not a PACS active-stage row. No schematic, footprint, PCB, GPIO, hierarchy, connector, ADR or ICD change is made by PACS-01R.

## 3. Current Active Inventory

The definitive post-ECO-010 inventory is the 20-reference set recorded below and in `PACS-01R_Active_Device_Register.csv`. All 20 were retained by reference from PACS-01. ECO-010 added zero active references and retired zero active references; it replaced the physical device implementations attached to U101 and U801 in place. The obsolete TPS26630 and TLV841 concepts survive only in historical review text and are not active EBOM rows.

## 4. Original PACS-01 Finding Closure

| Prior blocker | ECO-010 evidence | Result |
| --- | --- | --- |
| Invalid TPS26630/PWP combination | TPS26631PWPR, verified pins 1–20 and PWP behavior | Physical incompatibility corrected |
| Unavailable TLV841 suffix | TPS3899DL01DSER plus deterministic external threshold/delay network | Physical incompatibility corrected |

PACS-01 remains a historical `NOT ACCEPTED` decision. ECO-010 closure does not itself prove the system-level thermal, passive, sourcing and alternate evidence required for freeze.

### Current disposition table

| Reference(s) | Function | Exact preferred MPN | Package | Prior blocker / ECO closure | Final disposition |
| --- | --- | --- | --- | --- | --- |
| Q101 | Reverse-block FET | IAUC100N08S5N034ATMA1 | PG-TDSON-8, 5×6 | Hot SOA/copper/protection timing not closed | BLOCKED |
| U101 | 60 V eFuse | TPS26631PWPR | HTSSOP-20 PWP | Invalid suffix corrected by ECO-010; support/protection closure remains | BLOCKED |
| U102 | USB eFuse | TPS259470LRPWR | VQFN-HR-10 RPW | Exact thermal/ILIM prototype evidence incomplete | BLOCKED |
| U201 | 5 V buck | LMR38020FSQDDARQ1 | HSOIC-8 DDA | ECO-007 frequency fixed; tool/passive/thermal closure absent | BLOCKED |
| U202 | source selector | TPS2121RUXR | VQFN-HR-12 RUX | Transition and thermal correlation absent | BLOCKED |
| U203 | 3.3 V buck | TPS62135RGXR | VQFN-HR-11 RGX | Effective-C, stability and thermal closure absent | BLOCKED |
| U204 | single AND | SN74LVC1G08QDCKRQ1 | SC70-5 DCK | Exact candidate retained; complete freeze record absent | BLOCKED |
| U205 | quad AND | SN74LVC08AQPWRQ1 | TSSOP-14 PW | Exact candidate retained; complete freeze record absent | BLOCKED |
| U206–U208, U210/U211 | branch load switches | TPS22918TDBVRQ1 | SOT-23-6 DBV | +105 °C ambient and layout correlation remains | BLOCKED |
| U209/U212/U213 | protected load switches | TPS2553QDBVRQ1 | SOT-23-6 DBV | QER-02 electrical window passes; sourcing/thermal/retry evidence incomplete | BLOCKED |
| U302 | core reset supervisor | TPS389030QDSERQ1 | WSON-6 DSE | ECO-009R timing passes; exact passive/source/prototype closure remains | BLOCKED |
| U706/U707 | I²C boundaries | TCA9517ADGKR | VSSOP-8 DGK | Partial-power function fits; temperature/stuck-bus prototype evidence incomplete | BLOCKED |
| U801 | expansion supervisor | TPS3899DL01DSER | WSON-6 DSE | ECO-010 architecture corrected; narrow high-corner margin/passive closure remains | BLOCKED |

There are no stale composite rows, duplicate references, retired active rows or missing active functions in the controlled register.

## 5. Prior Candidate Revalidation

The 18 candidates retained from PACS-01 remain plausible exact candidates and no ECO-010 pin, rail, hierarchy or polarity regression was found. Manufacturer records continue to identify the reviewed order codes and packages. Revalidation does not elevate them to `FROZEN`: their existing blockers include incomplete thermal/tool evidence, missing complete current sourcing evidence, and unapproved alternates. Carrier variants are not independent alternates.

## 6. U101 TPS26631PWPR

TI identifies `TPS26631PWPR` as an active 4.5–60 V, 20-pin PWP eFuse with adjustable OVP, external reverse-FET drive and pulse support. The captured map matches IN 1–3, BGATE 4, DRV 5, IN_SYS 6, UVLO 7, OVP 8, GND 9, dVdt 10, ILIM 11, MODE 12, PGOOD 13, IMON 14, PGTH 15, SHDN 16, FLT 17 and OUT 18–20. At the 55 V coordinated clamp, utilization of the 67 V absolute rating is 82.1%. The integrated 31 mΩ typical path dissipates about 48 mW at 1.25 A and 124 mW at 2 A before hot resistance.

Freeze remains blocked because Q101 SOA, PLIM/ILIM/dVdt tolerances, surge energy, retry/latch behavior, and package-specific copper temperature have not been closed as one worst-case solution. Those results hand off partly to PPC-01, but U101 cannot be frozen while its own thermal and support-passive evidence can still require implementation change. No stale `TPS26630PWPR` design assumption remains.

## 7. U801 TPS3899DL01DSER

`TPS3899DL01DSER` is an active adjustable, open-drain active-low supervisor in six-pin DSE WSON. The captured mapping is CTR 1, CTS 2, GND 3, VDD 4, SENSE 5 and RESET 6. VDD is +3V3_CORE, RESET is pulled into that domain, and the external 150 kΩ/31.6 kΩ/1.30 MΩ network yields approximately 3.11 V assertion and 2.60 V deassertion. The documented exhaustive corners are 2.934–3.283 V assertion and 2.501–2.693 V deassertion; 10 nF on CTR gives 6.2 ms typical release. Reset is low during invalid supply/startup/brownout and the downstream enable is independently pulled low, preventing backfeed authorization.

Freeze remains blocked by the 17 mV worst-case assertion margin to nominal 3.3 V, exact passive MPN/leakage/DC-bias closure, and required prototype threshold/delay/partial-power tests. These failures can require divider-value change, so `CONDITIONAL` is prohibited. No TLV841 implementation remains active.

## 8. U302 TPS3890-Q1 and C305

U302 is `TPS389030QDSERQ1`, the automotive 2.89 V typical, open-drain active-low supervisor in DSE-6. Its pin map and CT behavior remain compatible with the captured symbol. ECO-009R's C305 = 93.1 nF ±1% C0G/NP0 produces 99.642 ms nominal and 79.1–136.6 ms bounded release, passing QER-03's 75–150 ms design window and 76–149 ms guarded prototype window. Startup and brownout assert reset; release occurs only after a new valid SENSE crossing and CT delay, preserving RESET_VALID, watchdog and actuator-inhibit ordering. U302 remains BLOCKED—not because timing regressed, but because exact C305 MPN, complete sourcing/alternate evidence and prototype timing remain open. C305's electrical class remains valid and no schematic ECO is indicated.

## 9. Primary and Secondary Regulators

U201 and U203 ordering codes, packages, operating ranges, control modes and nominal load capability remain compatible. U201 retains 400 kHz forced-PWM/spread-spectrum programming; U203 retains 3–17 V input, 4 A class, 2.5 MHz control, adjustable soft start and active discharge. Neither is frozen because manufacturer-tool stability, effective capacitance, magnetics loss, transient and package-copper thermal results are still open. U202 likewise remains blocked on source-transition/inrush and thermal correlation.

## 10. TPS2553-Q1 Devices

All three branches use active-high `TPS2553QDBVRQ1`, DBV-6, with independent `141 kΩ ±1%, ≤100 ppm/°C` RILIM. QER-02/ECO-008R calculations remain 162.824–222.345 mA, satisfying the 150 mA/10 ms startup floor and 225 mA ceiling for the 100 mA continuous contract. Freeze is withheld for exact thermal/retry/reverse-current and current sourcing/alternate evidence; the accepted current-limit requirement is not reopened.

## 11. Source Selectors, Load Switches, and Supervisors

U102, U202, U302 and U801 retain compatible polarity, threshold, output and startup roles. U302 with C305 retains 99.642 ms nominal and 79.1–136.6 ms bounded release. Their final states remain BLOCKED for the evidence gaps identified above, not because a new architecture incompatibility was discovered.

## 12. Logic, Translators, Buffers, and I²C Devices

U204/U205 provide the required AND functions with automotive temperature ratings and Ioff behavior. U706/U707 support 100 kHz operation, powered-off high impedance, active-high enable and the frozen direction. No prohibited clock-stretching function is introduced. The buffers remain blocked because +85 °C device limit leaves only 10 °C air margin and stuck-bus, offset-low, leakage and partial-power behavior still require the released prototype matrix. No drop-in alternate is approved.

## 13. Dependent Passive Closure

| Passive group | Active dependency | Result |
| --- | --- | --- |
| C102/C103/C104/C109/L101 | U101 | BLOCKED: exact curves, ripple/hot loss and protection waveform remain |
| C201–C205/L201 | U201 | BLOCKED: WEBENCH/stability/effective-C/magnetic closure remains |
| C206 | U202/U203 | BLOCKED: switchover transient plus DC-bias model remains |
| C208/C209/C210/L202 | U203 | BLOCKED: stability, soft-start and hot magnetic closure remains |
| R808 | U801 | BLOCKED: exact precision/leakage corner closure remains |

These are the 17 original PACS dependencies. ECO-010 additionally introduced C805/R807/R809 as U801 support parts; they also remain blocked. C305 was independently corrected by ECO-009R but its exact MPN remains a selection task. No passive value is silently changed. The smallest corrective package is **PACS-01R-A — Active Thermal, Tool, Passive-Dependency and Commercial Evidence Closure**; any failed value/topology result requires a narrow ECO before PACS reissue.

## 14. Derating Matrix

| Class | Applied / rated basis | Present conclusion |
| --- | --- | --- |
| U101 | 55 V clamp / 67 V abs = 82.1%; 2 A peak | Voltage plausible; pulse/copper/hot path incomplete |
| Q101 | 55 V / 80 V = 68.8%; ≤2 A vs 100 A package headline | Current headline is not linear SOA proof; blocked |
| U201 | 55 V worst input / 80 V operating = 68.8%; 2 A / 2 A | Electrical boundary fits; thermal/transient evidence incomplete |
| U202/U203 | ≤5.25 V vs 22 V/17 V; ≤1.5 A system load | Voltage/current fit; transient and thermal closure incomplete |
| Branch switches | ≤5.25 V within device ranges; ≤0.18 A branch peaks | Low conduction stress; environment/source evidence incomplete |
| Supervisors/logic/buffers | 3.3/5 V domains within ratings | Functional fit; exact thermal/partial-power evidence incomplete |

## 15. Thermal Summary

No active device receives `FROZEN`. Consequently no claim is made that undefined copper, enclosure convection or junction rise is acceptable. The unresolved devices require package-specific θJA/ψJT assumptions, copper areas, +75 °C enclosure-air cases, hot resistance/loss and junction margin to the 110 °C design target. These requirements are layout inputs only and do not assign footprints.

## 16. Lifecycle and Sourcing

TI and Infineon manufacturer pages were checked on 2026-08-01. Infineon lists Q101 active/preferred and planned through at least 2037; TI lists the reviewed sampled order codes as active. This is lifecycle evidence, not guaranteed stock. A complete same-day authorized-distributor matrix with stock, lead time, SKU, MOQ and all four requested price breaks was not available in the controlled record, so the package cannot claim sourcing closure.

Primary sources include https://www.ti.com/lit/ds/symlink/tps2663.pdf, https://www.ti.com/lit/ds/symlink/tps3899.pdf, the TI product pages linked in PACS-01, and https://www.infineon.com/part/IAUC100N08S5N034.

## 17. Approved Alternates

No drop-in alternate is approved. Same-die carrier variants may be procurement variants only after ordering-code review. All named cross-family alternatives are `FUNCTIONAL ALTERNATE — ECO REQUIRED` or `CANDIDATE ONLY`. U101, U302 and U801 have `NO APPROVED ALTERNATE` for design substitution.

## 18. Cost Analysis

The PACS-01 quantity-one snapshot totals approximately USD 28 before the then-unresolved U101/U801. It is retained only as historical planning evidence. Quantity 10/100/1000 totals, current U101/U801 price breaks, MOQ and packaging assumptions are incomplete; therefore prototype and volume active-device totals cannot be responsibly released. U201 remains the largest recorded unit-cost candidate. Single-source supervisor/eFuse exposure is a greater risk than the unverified catalog price.

## 19. EBOM/AVL Reconciliation

The EBOM and AVL continue to contain exact preferred MPNs for all 20 current active rows, including ECO-010 U101/U801, and all remain `BLOCKED`. CSV/XLSX artifacts are regenerated from the canonical CSV. No obsolete active implementation or unsupported status vocabulary remains.

## 20. Conditional Items

None. Every remaining validation failure could alter a dependent passive, thermal land, package choice or schematic value, and therefore fails the conditional-device rule.

## 21. Retired Components

No retired row is present in the current EBOM or AVL, so none is counted as a current active device. The obsolete `TPS26630PWPR` and TLV841 configuration are historical implementation concepts replaced in place by U101 `TPS26631PWPR` and U801 `TPS3899DL01DSER` under ECO-010. Their historical mentions are retained for audit traceability and are not sourcing approvals. If a future historical-row import materializes them as BOM lines, those lines shall be `RETIRED`, point to the ECO-010 replacement, and carry no active procurement status.

## 22. Risk Register

| Risk | Severity | Control |
| --- | --- | --- |
| U101/Q101 surge and hot SOA not closed | Critical | PACS-01R-A plus PPC-01 handoff; no freeze |
| Regulator stability/effective-C/thermal model absent | Critical | Official design tools and exact passive curves |
| U801 assertion corner has 17 mV margin | Major | Exact passive/leakage stack and prototype sweep |
| I²C buffer temperature/stuck-bus evidence incomplete | Major | Thermal and fault-injection matrix |
| Current pricing/lead time/alternate matrix incomplete | Major | Authorized-distributor evidence capture |

## 23. Remaining Blockers

The active implementation incompatibilities are corrected. Remaining blockers are evidence closure: thermal/SOA, regulator tools, exact dependent-passive curves/MPNs, U801 corner testing, I²C partial-power/fault testing, and complete current commercial/alternate evidence.

## 24. PPC-01 Handoff

PPC-01 is not authorized. U101/Q101/transient-device coordination inputs are documented, but PPC-01 must wait until PACS-01R-A proves the active path without a schematic or package-family change.

## 25. Validation Results

Targeted validation checks the 20-reference inventory, corrected U101/U801 identities, removal of obsolete implementations, exact blocked MPN records, 17 passive dependencies, EBOM/AVL synchronization, unchanged CAD/interfaces and the single final decision. All repository validators and `git diff --check` are required at close.

## 26. Native ERC Status

`kicad-cli` is unavailable. Native ERC remains pending and is not represented as complete. No schematic changed in this package.

## 27. Final Decision

# PACS-01R NOT ACCEPTED

PPC-01 and CSR-01A-R5 are not authorized. The smallest remaining package is **PACS-01R-A — Active Thermal, Tool, Passive-Dependency and Commercial Evidence Closure**. ECO-010 resolved the active-device incompatibilities; the remaining failures are analytical, physical-validation and commercial evidence gaps. Prototype-only confirmation is distinguished from blockers that could still force a value, package-family or schematic change.
