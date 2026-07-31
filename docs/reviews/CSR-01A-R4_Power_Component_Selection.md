# CSR-01A-R4 — Power Component Selection and Freeze Reattempt

| Field | Result |
|---|---|
| Platform | IPC-100 Rev A |
| Package | Package 11A-R4 |
| Review date | 2026-07-31 |
| Baseline | ECO-008R commit `f0d6c47` |
| Power-scope rows | 133 |
| Frozen / conditional / blocked / not applicable | 9 / 0 / 124 / 0 |
| Out-of-scope rows | 177 `NOT YET FROZEN` |
| Footprints assigned | 0 |
| PCB or schematic change | None |

## 1. Executive Summary

ECO-008R closes the TPS2553 requirements-to-schematic incompatibility: R222/R223/R224 are 141 kΩ ±1%, ≤100 ppm/°C and U209/U212/U213 calculate 162.82–222.35 mA against QER-02's 160–225 mA band. That closure makes the six rows eligible for exact-part evaluation; it does not supply exact MPN, package, thermal/retry, lifecycle, sourcing, alternate, price, or prototype evidence.

The controlled inventory remains 133 power rows: nine previously frozen 100 kΩ bias resistors and 124 specifically blocked rows. PPQ-02 is still required for 67 dependent passives and JCS-01 for J1. The other 56 rows have package-independent analytical evidence but not complete exact-part evidence. Because electrically critical input protection, regulators, switches, magnetics, capacitors, supervisor, and connector system remain blocked, CSR-01A-R4 is not accepted and CSR-01B is not authorized.

## 2. Scope

This is a selection-readiness review, not an implementation package. It reconciles every current power row through the canonical EBOM/AVL and reviews QER-01/QER-02, DRA-01, PEB-01, PPQ-01, ECO-006/007/008/008R, MIR-01, ADR-039–044, ICD-001/002, and the current schematics. No architecture, circuit, connector contract, GPIO, hierarchy, footprint, or PCB change is made.

Current official manufacturer pages were checked for candidate-family status and specifications: [TPS2553-Q1](https://www.ti.com/product/TPS2553-Q1), [LMR38020-Q1](https://www.ti.com/product/LMR38020-Q1), [TPS2121](https://www.ti.com/product/TPS2121), and [TLV841](https://www.ti.com/product/TLV841). Family availability does not prove an exact order code, land-pattern decision, commercial alternate, or circuit qualification.

## 3. Prior Blocker Closure

| Prior blocker | Status | Current evidence / remaining dependency |
|---|---|---|
| Capacitor voltage-class conflicts | PARTIALLY CLOSED | ECO-006 corrected classes; 30 critical capacitor rows still lack exact DC-bias, ripple, ESR, aging, life, stability, commercial, and alternate evidence; PPQ-02 |
| Q101 reverse-protection voltage margin | PARTIALLY CLOSED | ≥80 V class corrected; exact hot RDS(on), SOA, avalanche, leakage, thermal/copper, MPN, and alternate open |
| Regulator programming | CLOSED at schematic level | ECO-007 corrected U201/R201 to 400 kHz; exact suffix and dependent converter proof open |
| TPS2553 RILIM feasibility | CLOSED | QER-02 establishes a positive band |
| TPS2553 startup/ceiling compliance | CLOSED analytically | ECO-008R proves 162.82–222.35 mA; exact suffix, thermal/retry and prototype tests open |
| U706/U707 physical implementation | PARTIALLY CLOSED | Physical single-device class captured; exact suffix, partial-power, offset, package and commercial evidence open |
| U801 physical implementation | CLOSED at schematic level | Physical TLV841S-class circuit exists; exact order code/package and assembly decision open |
| U801 threshold/hysteresis | PARTIALLY CLOSED | Nominal network corrected; exact threshold/leakage/divider full-corner proof and PPQ-02 passives open |
| Transient coordination | OPEN | 19 rows need exact fuse/TVS/eFuse/MOSFET clamp, energy, timing, SOA and downstream-absolute-maximum proof |
| Thermal evidence | OPEN | Dissipative devices need package/copper-dependent junction estimates and prototype correlation |
| Regulator evidence | OPEN | Vendor-tool loop/stability, efficiency/loss, current limit, transient and minimum-copper evidence incomplete |
| Dependent passive calculations | OPEN | 67 rows require PPQ-02 exact manufacturer-curve qualification |
| J1 mechanical interface | PARTIALLY CLOSED | MIR-01 controls requirements; exact header/mate/contact/seal/strain-relief/tool chain requires JCS-01 |
| Connector requirements | PARTIALLY CLOSED | Electrical/mechanical class released; exact J1 family/geometry remains open |
| Lifecycle / sourcing / alternates / price | OPEN except nine frozen rows | Candidate-family `ACTIVE` status is insufficient; row-level order-code and commercial evidence missing |
| Native ERC | OPEN | `kicad-cli` unavailable; native ERC pending |

No prior blocker is dropped. ECO-008R changes the six TPS rows from requirements-incompatible to exact-selection/prototype blocked.

## 4. Power Inventory

The canonical [IPC100 Rev A EBOM](../bom/IPC100_RevA_EBOM.csv) records, for every row, reference, sheet, schematic value/function, prior blocker, closure trace, and final disposition. It is the row-level inventory required by this review.

| Sheet | Power rows |
|---|---:|
| 01 Power Entry | 35 |
| 02 Power Conversion | 77 |
| 03 ESP32 Core | 3 |
| 07 UI Peripherals | 8 |
| 08 Expansion | 8 |
| 09 Connectors/Test | 2 |
| **Total** | **133** |

Validation finds 310 total rows, 133 power rows, 177 out of scope, no missing/duplicate reference, and no obsolete composite power entry. Previously frozen rows are preserved.

## 5. Eligibility Summary

| Disposition | Count | Basis |
|---|---:|---|
| `FROZEN` | 9 | Exact MPN plus electrical, derating, lifecycle, sourcing, alternate and price evidence |
| `CONDITIONAL` | 0 | No open row meets the narrow prototype-only rule |
| `BLOCKED` | 124 | Mandatory exact-part or supporting evidence absent |
| `NOT APPLICABLE` | 0 | No power row removed |

PEB-01/PPQ-01 make 56 RC-A/RC-B rows analytically eligible for selection review, not automatically frozen. ECO-008R removes the special six-row QER conflict within that set. Sixty-seven RC-C rows remain gated by PPQ-02 and one RC-D row by JCS-01.

## 6. Requirement Traceability

Every power row carries QER/ECO/MIR trace and a specific blocker in EBOM and AVL. The nine frozen rows trace to QER resistor voltage, power, tolerance, temperature and environment limits. QER-02 and ECO-008R are added evidence for U209/U212/U213 and R222/R223/R224, but exact-part gates remain.

## 7. Selected Components

Only R204, R212, R214, R216, R218, R219, R220, R221, and R801 remain frozen as Panasonic `ERJ-3EKF1003V`, 100 kΩ ±1%, 0.1 W. Vishay `RCG0603100KFKEA` remains `ELECTRICALLY APPROVED — FOOTPRINT MAY DIFFER`. No new part is frozen in R4.

## 8. Input Protection

F101, D101–D104, Q101/Q102, U101/U102, L101, C101–C109, and associated passives remain blocked. PPQ supplies stress equations, but exact fuse hot-carry/I²t, TVS tolerance/dynamic clamp and energy, eFuse current-limit/SOA/timing, reverse-FET SOA/leakage, downstream clamp compatibility, and package/copper thermal evidence are not complete. A TVS is not frozen from standoff voltage alone.

## 9. Primary Regulator

ECO-007's U201 400 kHz network is family-compatible. TI lists the automotive LMR38020-Q1 family active and an exact candidate `LMR38020FSQDDARQ1`, but freezing it would also select the DDA package/thermal-land family and requires completed vendor-tool stability, current-limit, minimum on/off time, efficiency/loss, soft-start, transient, biased-capacitor, magnetic and minimum-copper analysis. Those dependencies remain open, so U201 and its dependent components remain blocked.

## 10. Secondary Regulators

U202/U203, source selection, supervisors, load switches, branch qualifiers, and their passives remain blocked pending exact suffix/pin mapping, input/output range, dropout, reverse current, quiescent/shutdown current, stability, start/fail behavior, thermal, package, sourcing and alternate evidence. TPS2121 family data supports candidacy but not a freeze.

## 11. TPS2553 Branches

| Device / RILIM | Rail / load | Contract | RILIM | I min / nominal / max | Startup / ceiling margin | Disposition |
|---|---|---|---:|---:|---:|---|
| U209 / R222 | 3.3 V expansion, optional/DNP | 100 mA; 150 mA/10 ms | 141 kΩ ±1%, ≤100 ppm/°C | 162.82 / 190.33 / 222.35 mA | +12.82 / +2.65 mA | BLOCKED |
| U212 / R223 | 5 V motor logic A | Same | Same | Same | Same | BLOCKED |
| U213 / R224 | 5 V motor logic B | Same | Same | Same | Same | BLOCKED |

The family provides active-high enable, controlled rise, constant-current limiting, reverse-voltage protection and active-low fault behavior. Remaining exact-selection evidence includes preferred order code, SOT-23 package-family authorization, full thermal/retry behavior at the low programmed limit, output-capacitance/start tests, reverse-current corner, lifecycle, distributor/SKU/prices and alternate strategy. The six rows cannot be conditional because an alternate or thermal failure could change the device/package family.

## 12. U801 Supervisor

TLV841 is currently active and supports a separate-SENSE `S` variant, fixed delay choices, multiple output polarities/types and a DSBGA package. Those variants make a bare family name insufficient. Exact threshold code, 10 ms delay code, output type, order code, DSBGA assembly/land-pattern authorization, divider/leakage corners, fail-disabled brownout behavior, decoupling, source and alternate evidence remain open. U801/R806/R808/C804 remain blocked.

## 13. MOSFETs and Switches

No additional MOSFET or switch is frozen. Exact VDS/VGS, actual gate drive, hot RDS(on), conduction/switching loss, SOA, avalanche/body diode, leakage, pulse/continuous current, package θ metrics, copper and enclosure junction estimate remain mandatory. Headline current ratings are rejected.

## 14. Magnetics

L101/L201/L202 and FB801 remain blocked pending exact inductance/impedance tolerance, RMS and saturation current, DCR, copper/core loss, temperature rise, frequency/bias behavior, surge, lifecycle, source and alternate evidence.

## 15. Capacitors

Thirty critical capacitor rows remain blocked. PPQ-01 defines applied stresses and minimum effective values but explicitly hands exact dielectric, DC-bias, ripple/ESR, aging, lifetime and regulator-stability qualification to PPQ-02. Nominal capacitance and voltage rating alone are insufficient.

## 16. Resistors

Nine identical low-voltage 100 kΩ bias functions remain frozen because their requirements are equivalent. Thirty-seven other resistor rows remain blocked pending exact tolerance/tempco, working/overload voltage, power/pulse, threshold/setpoint error, failure effect, lifecycle, source and alternate evidence. This includes the three electrically corrected 141 kΩ RILIM resistors.

## 17. J1 and Power Connectors

MIR-01 releases a right-angle, latched, keyed, two-contact, ≥3 A/contact, ≥30 V system and 18 AWG H01 requirements. It does not provide exact PCB header, mating housing, contacts, seals/strain relief, wire acceptance, crimp tooling, lifecycle, sources or alternate. J1 remains blocked under JCS-01; enclosure geometry may still determine connector/package family. No footprint is assigned.

## 18. USB VBUS Components

Power-side USB protection, current/reverse blocking, VBUS ESD, CC resistors in power scope, and energy-storage parts remain blocked where exact clamp, capacitance, USB-only, inrush and dual-source behavior is incomplete. USB data-path ESD may be reviewed later, but that does not close VBUS power parts.

## 19. Derating Matrix

For each frozen resistor: 5.25 V applied / 75 V rated = 7.0% voltage utilization; 0.276 mW / 100 mW = 0.28% power utilization; −55 to +155 °C rating exceeds the QER environment. Blocked items have no complete exact-part matrix and therefore receive no implied pass.

## 20. Thermal Matrix

Frozen resistors dissipate <0.3 mW. U201 must demonstrate effective θJA ≤26.4 °C/W at the PPQ 1.324 W loss screen; the core regulator ≤60.1 °C/W at 0.582 W. Protection devices, TPS2553 switches, MOSFETs and magnetics need exact package/copper/enclosure calculations. These are selection gates, not merely post-freeze tests.

## 21. Lifecycle and Sourcing

The nine frozen rows retain manufacturer, lifecycle, two distributor paths, date, and sourcing-risk records. TI currently lists TPS2553-Q1, TPS2121, TLV841 and LMR38020-Q1 families active, but family status and an order button do not establish the required exact order-code stock, lead time, package continuity, distributor SKU, counterfeit control or alternate for the blocked rows. Stock snapshots are not future guarantees.

## 22. Approved Alternates

Only the Vishay alternate for the nine frozen resistors is approved, classified `ELECTRICALLY APPROVED — FOOTPRINT MAY DIFFER`. All other rows are `CANDIDATE ONLY` or `NO APPROVED ALTERNATE`; exact alternate review can require a topology or footprint-family decision and therefore blocks freeze.

## 23. Cost Analysis

Retained planning cost for nine frozen resistors is $0.900 / $0.351 / $0.1755 / $0.10179 at quantities 1/10/100/1000. A complete power-subsystem total, top-ten list, and protection/connector shares cannot be calculated without inventing prices for 124 blocked rows. MOQ and packaging remain recorded only for frozen rows.

## 24. EBOM/AVL Reconciliation

Canonical EBOM CSV/XLSX and AVL CSV/XLSX contain 310 matching rows. All 133 power rows use allowed final states and all blocked rows have named dependencies. Frozen rows contain exact MPN, QER trace, derating, lifecycle, sourcing, alternate and pricing fields. The files are synchronized but not a complete power freeze.

## 25. Conditional Items

None. Missing exact-device, passive-curve, thermal-land, connector-family and alternate evidence can change topology, package family or footprint family. `CONDITIONAL` would conceal selection work and is prohibited.

## 26. Remaining Blockers

| Group | Rows | Required closure |
|---|---:|---|
| RC-A protection/transient coordination | 19 | **PPC-01 — Exact Input and Branch Protection Coordination**: exact fuse/TVS/eFuse/MOSFET candidates, tolerance/energy/SOA/thermal/commercial proof |
| RC-B active-stage selection | 37 | **PAS-01 — Power Active-Stage Exact Selection**: exact regulator/switch/supervisor/order-code, vendor-tool, package/copper, lifecycle/source/alternate/cost proof |
| RC-C dependent passives | 67 | **PPQ-02 — Exact Power Passive Qualification** |
| RC-D J1 system | 1 | **JCS-01 — J1 Connector System Definition** |

Run PPQ-02 and JCS-01 in parallel; PPC-01 and PAS-01 may also proceed in parallel where dependencies permit. If any exact candidate requires a circuit change, stop that branch for a narrow ECO. Do not run another broad CSR until these registers show closure.

## 27. PPQ-02 Handoff

PPQ-02 shall qualify the 67 references listed in the PPQ evidence register using exact manufacturer curves/order codes, effective capacitance, ripple/ESR, aging/life, tolerance/tempco, working/pulse stress, lifecycle, sources, alternates and prices. It shall not assign footprints.

## 28. JCS-01 Handoff

JCS-01 shall turn MIR-01 into a complete header/mate/contact/seal/strain-relief/wire/tool order-code chain with rating, environment, mating life, lifecycle, source, alternate, cost and geometry evidence. It shall recommend a footprint family constraint without assigning a footprint.

## 29. Validation Results

- 310 total rows; 133 power and 177 out of scope; references unique.
- Power dispositions are exactly 9 `FROZEN`, 0 `CONDITIONAL`, 124 `BLOCKED`, 0 `NOT APPLICABLE`.
- Every frozen row has exact MPN, QER/evidence trace, derating, lifecycle, sourcing, alternate and price evidence.
- Every blocked row has a specific blocker and named closure package.
- R222/R223/R224 remain 141 kΩ; TPS2553 limits recompute to 162.82–222.35 mA.
- U201/R201 and U801 remain aligned with ECO-007; no obsolete RILIM value remains in current schematic/BOM annotations.
- EBOM/AVL CSV identities/statuses agree; XLSX artifacts are synchronized.
- References/UUIDs/hierarchy/GPIOs/connectors remain unchanged and globally unique.
- Zero footprints; no PCB, ADR, ICD, architecture or schematic logic changes.
- Repository validators and `git diff --check` pass.

## 30. Native ERC Status

`kicad-cli` is unavailable in this review environment. Native ERC remains **PENDING** and is not represented as complete.

## 31. Final Decision

# CSR-01A-R4 NOT ACCEPTED

CSR-01B — MCU & Support Component Selection is **not authorized**. Required next evidence packages are PPQ-02, JCS-01, PPC-01, and PAS-01; no further broad CSR pass is authorized until their row-level exit criteria close.

> **PPQ-02 handoff:** PPQ-02 subsequently completed shared analytical evidence and routed the 124 rows as 19 PPC-01, 104 PAS-01, and one JCS-01. R4 remains not accepted; CSR-01A-R5 remains unauthorized until all three selection packages complete.
