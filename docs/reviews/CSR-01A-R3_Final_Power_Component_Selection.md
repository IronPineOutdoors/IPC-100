# CSR-01A-R3 — Final Power Component Selection and Freeze

| Field | Result |
|---|---|
| Platform | IPC-100 Rev A |
| Package | Package 11A-R3 |
| Review date | 2026-07-31 |
| Baseline | ECO-007 commit `113d089` |
| Power-scope rows | 133 |
| Frozen | 9 |
| Conditional | 0 |
| Blocked | 124 |
| Not applicable | 0 |
| Footprints assigned | 0 |
| PCB work | None |
| Decision | Not accepted |

## 1. Executive Summary

ECO-007 successfully closed the three schematic-to-datasheet incompatibilities that stopped CSR-01A-R2. It did not perform the exact component freeze. The current controlled EBOM contains 133 power-scope rows: nine previously qualified 100 kΩ resistors are `FROZEN`, while 124 rows retain explicit electrical, thermal, transient, mechanical, lifecycle, sourcing, cost, or alternate-evidence blockers.

The acceptance standard requires every electrically critical power component to be frozen and forbids guessing. U201, the input protection chain, every active secondary power device, all critical magnetics and capacitors, J1 order codes, the three TPS2553-Q1 devices and their RILIM resistors, and U801 plus its dependent passives are not frozen. No blocked row qualifies as `CONDITIONAL`, because the missing work can change an exact part, package family, thermal land requirement, protection coordination, or component value.

The package is therefore not accepted. CSR-01B remains unauthorized.

## 2. Scope

This review reconciles the post-ECO-007 power inventory and tests it against QER-01 and the CSR freeze rules. It does not change schematics, architecture, GPIO, hierarchy, ADRs, ICDs, footprints, or PCB data. Official TI documentation current on 2026-07-31 was checked for LMR38020-Q1, TPS2553-Q1, and TLV841 behavior; the corrected networks remain credible candidates, but candidate compatibility is not a complete exact-part freeze.

## 3. Prior Blocker Closure

| Prior blocker | Status | Evidence / remaining work |
|---|---|---|
| Capacitor voltage-rating conflicts | PARTIALLY CLOSED | ECO-006 corrected schematic classes; 30 capacitor rows still lack exact MPN DC-bias, ripple, ESR, aging, and stability evidence |
| Reverse-protection MOSFET voltage margin | PARTIALLY CLOSED | Q101 class is now ≥80 V, but exact SOA, hot RDS(on), leakage, avalanche, thermal, sourcing, and alternate remain absent |
| U706/U707 physical implementation | PARTIALLY CLOSED | Physical TCA9517A-class topology exists; exact suffix, offset-low, partial-power, thermal, lifecycle, sourcing, and cost remain open |
| U801 physical implementation | CLOSED at schematic level | ECO-007 created a physical selectable supervisor circuit; exact ordering code and full tolerance/thermal/commercial evidence remain open for freeze |
| U201/R201 frequency programming | CLOSED at schematic level | ECO-007 restored the valid 400 kHz programming method; exact U201 suffix and complete converter analysis remain open |
| TPS2553-Q1 RILIM programming | CLOSED at schematic level | Three independent legal 150 kΩ networks exist; exact devices/resistors and thermal/reverse-current evidence remain open |
| U801 threshold/hysteresis | CLOSED at schematic level | ECO-007 documents the accepted threshold network; exact tolerance stack and leakage verification remain open |
| J1 mechanical interface | PARTIALLY CLOSED | MIR-01 freezes the interface contract, not the housing, mate, terminals, seals, strain relief, tooling, or order codes |
| Regulator calculations | OPEN | Vendor-tool/loop, loss, current-limit, tolerance, effective-capacitance, and minimum-copper evidence incomplete |
| Transient coordination | OPEN | 19 rows lack worst-case clamp, source impedance, energy, fuse/eFuse coordination, and downstream abs-max proof |
| Dependent passive calculations | OPEN | 37 resistor and 30 capacitor rows lack complete tolerance/working-voltage/pulse/bias evidence |
| Thermal requirements | OPEN | Dissipative devices lack package-specific copper, θ metrics, enclosure estimate, and junction margins |
| Connector requirements | OPEN | Exact J1 system and other applicable power-interface order codes are not selected |
| Sourcing/lifecycle/alternates | OPEN | Only the nine frozen resistor rows contain complete reviewed evidence |

No earlier blocker was silently dropped.

## 4. Power Inventory

| Disposition | Count | Meaning |
|---|---:|---|
| `FROZEN` | 9 | Exact MPN and reviewed evidence retained |
| `CONDITIONAL` | 0 | No item meets the narrow conditional rule |
| `BLOCKED` | 124 | Exact selection or mandatory evidence incomplete |
| `NOT APPLICABLE` | 0 | No power row removed |

Blocked categories are: 85 passives, 17 protection, 9 power ICs, 4 I²C, 4 logic, 2 MOSFETs, 1 connector, 1 display boundary, and 1 sensor boundary. The current inventory has 310 total rows, 177 outside CSR-01A, no repeated reference, and no obsolete composite row identified by validation.

## 5. Requirement Traceability

The nine frozen rows trace to the QER resistor voltage, power, tolerance, and environment requirements. All blocked rows retain QER-01/ECO/MIR review trace and a row-specific blocker in the EBOM. A generic schematic value is not accepted as QER compliance evidence.

## 6. Power Tree

`J1 → F101/D101/Q101/U101/U102 → VIN_PROTECTED → U201 → +5V_MAIN → source selection/U203 → +3V3_CORE`, with controlled OLED, sensor, UI, relay, field-sense, expansion, and motor-logic branches. This architecture is unchanged. The inability to freeze the input/protection and primary-converter chain blocks every dependent branch from a production-ready electrical freeze.

## 7. Selected Components

Only R204, R212, R214, R216, R218, R219, R220, R221, and R801 are frozen. All use Panasonic `ERJ-3EKF1003V`, 100 kΩ ±1%, 0603, 0.1 W, with Vishay `RCG0603100KFKEA` electrically approved as a footprint-may-differ alternate. No other exact part is accepted by this review.

## 8. Input Protection

F101, D101–D104, Q101/Q102, U101/U102, L101, C101–C109, and supporting resistors remain blocked. The repository lacks a complete worst-case source/transient model, TVS tolerance and dynamic-resistance clamp result, fuse clearing/I²t coordination, MOSFET SOA at the required pulse, and package-specific thermal proof. Selecting an SMBJ33A-class TVS or provisional eFuse alone does not establish downstream protection.

## 9. U201 Regulator

TI lists LMR38020-Q1 active with 4.2–80 V input, 2 A output, 200 kHz–2.2 MHz adjustable frequency, and an HSOIC PowerPAD package. ECO-007's 64.9 kΩ/400 kHz method is consistent with the family. Freeze still requires the exact orderable suffix, full oscillator/current-limit tolerances, vendor design-tool/loop results, loss and junction estimates, biased input/output capacitor evidence, inductor loss/saturation, and the required four-layer copper/via implementation. U201, R201, L201/L202, and dependent capacitors remain blocked.

## 10. Secondary Regulators

U202–U208, U210/U211, U302, U706/U707, and associated passives lack complete exact-suffix pin mapping, dropout/headroom, reverse-current, partial-power, enable, stability, thermal, lifecycle, sourcing, and alternate evidence. None is frozen.

## 11. TPS2553-Q1 Branches

TI documents TPS2553-Q1 as an active-high 2.5–6.5 V current-limited switch and specifies an independent 15–232 kΩ RILIM. ECO-007's 150 kΩ networks and 154–209 mA bounds close the prior schematic defect. U209/U212/U213 and R222/R223/R224 remain blocked pending exact order code/package, worst-case thermal/retry analysis, reverse-current behavior, capacitor/inrush tolerance, lifecycle, distributor, pricing, and alternate review.

## 12. U801 Supervisor

TI lists TLV841 active with separate VDD/SENSE options, ±0.5% threshold-class capability, output/delay variants, and a WCSP implementation. The released circuit is physical and fail-disabled, but the EBOM still lacks a frozen exact order code, package decision, full threshold/leakage/output tolerance stack over temperature, thermal/assembly feasibility, sourcing, pricing, and alternate. U801, R806, R808, and C804 remain blocked.

## 13. MOSFETs and Switches

Q101 and Q102 lack exact hot RDS(on), SOA, leakage, avalanche/body-diode, pulse, θ, copper, and junction proof. Integrated switches remain blocked as described above. Headline voltage/current ratings are not used as freeze evidence.

## 14. Magnetics

L101, L201, L202, and FB801 lack exact saturation/RMS current, DCR, hot copper/core loss, impedance-frequency, surge, temperature, lifecycle, sourcing, and alternate evidence. They remain blocked.

## 15. Capacitors

Thirty capacitor rows lack exact manufacturer DC-bias curves, minimum effective capacitance, ripple/ESR, temperature/aging, lifetime, and regulator-stability evidence. Corrected nominal/rating classes from ECO-006 are necessary but not sufficient.

## 16. Resistors

The nine 100 kΩ bias resistors remain frozen. Thirty-seven other resistor rows lack one or more of exact MPN, tolerance/temperature stack, working or overload voltage, pulse rating, power, threshold/error calculation, failure effect, lifecycle, source, price, or alternate evidence. R201, the three RILIM resistors, and the U801 network are therefore not frozen despite valid nominal values.

## 17. J1 and Power Connectors

MIR-01 releases J1's mechanical/electrical interface. It does not identify the complete board/cable connector system, mate, contacts, seals, strain relief, wire range, tooling, lifecycle, or replacement strategy. J1 remains blocked. No connector footprint is assigned.

## 18. USB VBUS Components

The USB power path retains unresolved exact VBUS protection, current/reverse-current devices, ESD clamp coordination, capacitance/inrush, and dual-supply verification. USB data ESD remains separable, but that does not close the VBUS power rows.

## 19. Derating Matrix

For each frozen resistor, maximum applied voltage is 5.25 V versus 75 V rating (7.0% utilization), applied power is about 0.276 mW versus 100 mW (0.28% utilization), and the −55°C to +155°C rating exceeds the QER environment. Blocked rows do not have a complete derating matrix and cannot be treated as passing.

## 20. Thermal Summary

The frozen resistors dissipate less than 0.3 mW each and have ample body-temperature margin. U201, eFuses/surge devices, TPS2553 branches, Q101, magnetics, and protection devices lack package-specific worst-case dissipation, enclosure ambient, θ metrics, copper area/vias, airflow assumption, junction estimate, and margin. Those omissions are freeze blockers, not prototype-only observations.

## 21. Lifecycle and Sourcing

The frozen Panasonic resistor was previously reviewed active with two distributor paths on 2026-07-31. TI's current pages identify LMR38020-Q1 and TLV841 as active; this supports candidate viability but does not close order-code, stock, cost, alternates, or the other 124 rows. No current commercial claim is inferred where the EBOM has no evidence.

## 22. Approved Alternates

The only approved alternate is Vishay `RCG0603100KFKEA`, classified `ELECTRICALLY APPROVED — FOOTPRINT MAY DIFFER`, for the nine frozen resistors. Every other power row has no approved alternate or only an unreviewed candidate. This alone prevents footprint-ready selection.

## 23. Cost Analysis

The nine frozen resistors total $0.900 at quantity 1, $0.351 at 10, $0.1755 at 100, and $0.10179 at 1,000 using the retained 2026-07-31 planning prices. A power-subsystem total, ten highest-cost list, connector/protection share, and sourcing-risk exposure cannot be calculated without fabricating prices for 124 blocked rows.

## 24. EBOM/AVL Reconciliation

EBOM CSV/XLSX and AVL contain the same 310 references and dispositions generated after ECO-007. All 133 power rows have an allowed final disposition; all 124 blocked rows carry a specific reason. The artifacts are structurally synchronized but are not a complete production AVL.

## 25. Conditional Items

None. Every open item can influence exact part, component/package family, thermal land/copper requirement, protection coordination, or electrical value. Those are prohibited uses of `CONDITIONAL`.

## 26. Risk Register

| Risk | Severity | Consequence | Control |
|---|---|---|---|
| Input transient chain uncoordinated | Critical | Downstream overstress or nuisance isolation | Dedicated input-protection selection/coordination package |
| Primary converter not fully selected | Critical | Stability, thermal, EMI, or current-limit failure | Complete vendor-tool and exact-passive selection |
| Critical passives not characterized | Major | Effective capacitance, heating, or threshold failure | Manufacturer-curve and tolerance audit |
| J1 order codes absent | Major | Cannot procure or define termination/tooling | Complete connector-system selection from MIR-01 |
| Active power parts lack alternates/cost | Major | Procurement and footprint risk | Exact suffix, lifecycle, sourcing, and alternate review |
| Native ERC pending | Major release gate | CAD electrical conflicts could remain | Run native KiCad ERC when CLI is available |

## 27. Remaining Blockers

The smallest corrective work is **CSR-01A-R3A — Exact Power Selection Evidence Completion**, not a schematic ECO unless that review exposes a new incompatibility. It must close the 124 row-level blockers in dependency order: source/transient model and input protection; U201/vendor-tool/thermal; secondary devices; critical magnetics/capacitors; dividers/programming resistors; J1 order codes; lifecycle/sourcing/alternates/cost; then a new final freeze review. Any discovered topology conflict requires a narrow ECO and another re-review.

## 28. Validation Results

- All power references have `FROZEN` or `BLOCKED`; none are silently deferred.
- Every frozen row has MPN, QER trace, derating, lifecycle, sourcing, alternate, and pricing fields.
- ECO-007 U201/R201, TPS2553/RILIM, and U801 regression checks pass.
- EBOM/AVL row identity and status agree; CSV/XLSX were regenerated from canonical CSV.
- References and UUIDs remain unique; S-expressions are balanced.
- Root hierarchy, GPIO, ADR/ICD interfaces, and connector contracts are unchanged.
- Zero footprints remain assigned; no PCB or schematic file is modified by this review.
- `git diff --check` passes.

## 29. Native ERC Status

`kicad-cli` is unavailable in the review environment. Native ERC remains **PENDING** and is not claimed as complete.

## 30. Final Decision

# CSR-01A-R3 NOT ACCEPTED

CSR-01B MCU & Support Component Selection is not authorized.
