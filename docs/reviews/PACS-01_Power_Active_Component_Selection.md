# PACS-01 — Power Active Component Selection

Date: 2026-07-31
Platform: IPC-100 Rev A
Scope baseline: commit `1a6c11c`

## Executive Summary

PACS-01 audited all 20 PPQ-02 power-active references against QER-01/02/03, PPQ-01/02, the accepted ECO chain, current schematics, and current manufacturer production data. Eighteen references have electrically credible exact production candidates. None is frozen because two references prevent package acceptance:

1. U101 is captured as `TPS26630PWPR` in a 20-pin PWP topology. TI does not offer that ordering code: TPS26630 is the 24-pin RGE option, while the 20-pin PWP production variants have different TPS2663 suffixes and fault/power-limit behavior. Selecting TPS26633PWPR would be a controlled device-variant decision, not suffix completion.
2. U801 requires the decoded combination `TLV841SCPH27YBHR` (SENSE, 10 ms, push-pull active-high, 2.7 V, YBH). TI's current production ordering table does not list that exact orderable part. No architecture-compatible production alternate has been demonstrated.

These are implementation/availability blockers, not reasons to relax QER-01 or QER-03. PACS-01 records reviewed candidates in EBOM/AVL but leaves all 20 rows `BLOCKED`; it does not authorize procurement, footprint assignment, PPC-01, or CSR-01A-R5.

## Definitive Inventory

| Reference(s) | Function/current generic device | Required behavior / package family | Exact preferred candidate | Current blocker / status |
|---|---|---|---|---|
| Q101 | TPS2663 external reverse-block N-FET | ≥80 V, ±20 V VGS, ≤25 mΩ, hot 2 A and 100 ms linear SOA; 5×6 power package | Infineon `IAUC100N08S5N034ATMA1` | Candidate; SOA must be correlated with exact U101 variant and PCB thermal land. |
| U101 | Main input eFuse, captured `TPS26630PWPR` | 4.5–60 V, external B-FET drive, latch behavior, 20-pin PWP topology | None frozen; `TPS26633PWPR` is a possible controlled replacement | **Blocked:** captured ordering code does not exist and TPS26630 pin/package differs. |
| U102 | USB eFuse | 2.7–23 V, latch-off, reverse blocking, 500 mA programming, RPW-10 | TI `TPS259470LRPWR` | Candidate; exact thermal/ILIM prototype verification remains. |
| U201 | 5 V/2 A main buck | 4.2–80 V, FPWM/spread spectrum, RT/SYNC 400 kHz, PGOOD, DDA-8 | TI `LMR38020FSQDDARQ1` | Candidate; vendor-tool loop/thermal correlation remains. |
| U202 | Main/USB priority mux | Seamless reverse-blocking 2:1 mux, ≥1 A, RUX-12 | TI `TPS2121RUXR` | Candidate; source-transition prototype correlation remains. |
| U203 | 3.3 V/1.5 A core buck | 3–17 V input, 4 A class, 2.5 MHz, adjustable soft start, PGOOD, active discharge | TI `TPS62135RGXR` | Candidate; vendor-tool stability/effective-C closure remains. |
| U204 | Main qualification AND | Automotive 1-gate AND, 3.3 V, Ioff, SC70-5 | TI `SN74LVC1G08QDCKRQ1` | Candidate. |
| U205 | Four request qualification gates | Automotive quad AND, 3.3 V, Ioff, TSSOP-14 | TI `SN74LVC08AQPWRQ1` | Candidate. |
| U206/U207/U208/U210/U211 | Five switched branches | Active-high load switch, 1–5.5 V, 2 A, QOD/rise control, SOT-23-6 | TI `TPS22918TDBVRQ1` | Candidate; +105 °C ambient grade is acceptable only with QER thermal correlation at +75 °C enclosure air. |
| U209/U212/U213 | Three QER-02 current-limited branches | Active-high, reverse blocking, adjustable 75 mA–1.3 A, SOT-23-6 | TI `TPS2553QDBVRQ1` | Candidate; exact QER-02 calculation passes. |
| U302 | Core reset supervisor | Automotive 2.89 V typical threshold, CT delay, open-drain active-low reset, DSE-6 | TI `TPS389030QDSERQ1` | Candidate; exact suffix preserves ECO-009R calculation; prototype matrix remains. |
| U706/U707 | Two independent I²C boundaries | Dual-supply 400 kHz buffer, powered-off high-Z, active-high EN, DGK-8 | TI `TCA9517ADGKR` | Candidate; -40…+85 °C rating and offset-low/stuck-bus behavior require system-temperature and prototype confirmation. |
| U801 | Expansion valid supervisor | SENSE, 2.7 V, 10 ms, push-pull active-high, 4-pin YBH | Required decoded OPN `TLV841SCPH27YBHR` | **Blocked:** exact combination is not listed as active production/orderable. |

The machine-readable companion register is `PACS-01_Active_Device_Register.csv` and contains exactly 20 unique references.

## Device-by-Device Review

### Input protection: Q101, U101 and U102

Q101's preferred candidate is automotive qualified, 80 V, 3.4 mΩ maximum at 10 V, -55…+175 °C, and planned by Infineon through at least 2037. Its low conduction loss is ample; its exact hot linear SOA still depends on the eFuse drive/fault interval and copper model. The Nexperia `BUK7J2R4-80M` is a functional automotive alternate, not an approved drop-in until land pattern and SOA are compared.

U102 is active/production, -40…+125 °C, 2.7–23 V, 28.3 mΩ typical, and provides true reverse-current blocking and latch-off in the selected `0L` variant. It matches the captured RPW-10 pin family. DigiKey's snapshot showed 11,374 units and USD 1.53 at quantity one; availability and price require PO-date revalidation.

U101 cannot be frozen. TI's production data lists TPS26630 in 24-pin RGE, not the captured 20-pin PWP. The available TPS26633PWPR provides the needed external B-FET and surge/power-limit features, but its suffix changes controlled behavior. PACS-01 may not silently make that decision or edit the schematic.

### Regulators and source selector: U201, U202 and U203

`LMR38020FSQDDARQ1` is the forced-PWM/spread-spectrum, adjustable-frequency automotive variant. It is active, 4.2–80 V, 2 A, -40…+150 °C junction rated, and uses the captured DDA-8 family. TI's table maps 64.9 kΩ to 400 kHz, preserving ECO-007. Budgetary quantity-one pricing was USD 4.56.

`TPS2121RUXR` is active, -40…+125 °C, 2.7–22 V, 4.5 A, 56 mΩ typical and 5 µs typical switchover, with reverse blocking. DigiKey showed 33,966 units and USD 2.44 at quantity one.

`TPS62135RGXR` is active, -40…+125 °C, 3–17 V, 4 A, adjustable output/soft start, 2.5 MHz forced PWM, PGOOD and active discharge. It covers the 4.4–5.25 V input and 3.3 V/1.5 A allocation with current/thermal margin. DigiKey showed 8,104 units and USD 2.32 at quantity one. Exact effective capacitance, loop response and thermal-land validation remain downstream evidence, not a reason to alter requirements.

### Logic: U204 and U205

Both TI candidates are active automotive production parts with Ioff partial-power protection and -40…+125 °C ratings. U204 supports 1.65–5.5 V and uses SC70-5. U205 supports the captured four AND channels at 3.3 V in TSSOP-14. Functional-package alternates are not drop-in and remain unapproved until footprint work is authorized.

### Load switches: U206/U207/U208/U210/U211

`TPS22918TDBVRQ1` is active automotive production, 1–5.5 V, 2 A, 52 mΩ typical at 5 V, with controlled rise and configurable QOD. At the ≤180 mA branch peaks, conduction dissipation is below 2 mW typical; junction rise is dominated by board/environment rather than switch loss. Its -40…+105 °C ambient specification covers the +75 °C enclosure requirement with 30 °C ambient headroom, subject to prototype correlation. DigiKey showed 6,744 units and USD 0.75 at quantity one.

### TPS2553 review: U209/U212/U213

`TPS2553QDBVRQ1` is the active-high automotive DBV-6 part, active/production, -40…+125 °C, 2.5–6.5 V, 85 mΩ typical, reverse blocking and adjustable current limit. It preserves QER-02 and ECO-008R:

- `RILIM = 141 kΩ ±1%`, ≤100 ppm/°C;
- calculated worst-case current limit = 162.824–222.345 mA;
- `162.824 mA ≥ 150 mA` startup requirement;
- `222.345 mA ≤ 225 mA` protection ceiling.

No family coefficient, polarity or package assumption changes. The commercial snapshot showed approximately USD 1.60 at quantity one, but one DigiKey result showed zero stock; lead time and alternate supply remain procurement risks. `TPS2551QDBVRQ1` is only a functional alternate pending a complete coefficient/pin/fault review and is not approved as drop-in.

### Supervisor review: U302

`TPS389030QDSERQ1` is TI's active/production automotive 2.89 V-typical, open-drain active-low, programmable-delay WSON-6 order code. It preserves the exact TPS389030 timing-current and CT-threshold family used by ECO-009R. With C305 = 93.1 nF ±1% C0G/NP0, the result remains 99.642 ms nominal and 79.1–136.6 ms bounded; QER-03 is not reopened. No alternate is approved because threshold, CT behavior, polarity and pin map must all match.

### I²C buffers: U706/U707

`TCA9517ADGKR` is active, powered-off high impedance, 0.9–5.5 V A-side, 2.7–5.5 V B-side, active-high EN and 400 kHz capable in VSSOP-8. It supports 100 kHz and the required partial-power isolation. Its buffered-low offset prevents arbitrary series chaining; the captured architecture uses one boundary per branch. The catalog temperature limit is +85 °C, so enclosure thermal verification has only 10 °C ambient margin. `PCA9517ADGKR` is functional only and not approved without offset/partial-power comparison.

### U801 supervisor

TI nomenclature decodes the required device as `TLV841SCPH27YBHR`: SENSE option (`S`), 10 ms (`C`), push-pull active-high (`PH`), 2.7 V (`27`), DSBGA-4 (`YBH`), reel (`R`). TI instructs designers to contact the company for variant availability, and the current production package table does not list this OPN. Existing listed TLV841S orderable variants do not satisfy the complete threshold/delay/polarity combination. Freezing a different suffix would change the accepted external threshold/timing behavior.

## Lifecycle and Availability

All 18 named candidates are shown by their manufacturers as active/production as of the review date. Most are single-manufacturer functional selections; carrier variants from the same manufacturer are not independent second sources. U101 and U801 have no freezeable OPN. Distributor stock and unit prices are volatile commercial observations, not electrical evidence; every PO requires AVL revalidation.

## Alternate Strategy

- A **drop-in alternate** must preserve manufacturer pin map, package, polarity, thresholds, timing, fault response and every QER limit. None is approved in this package.
- A **functional alternate** is recorded where a plausible family exists, but it requires schematic/footprint and evidence review before approval.
- Single-source safety/timing devices U101, U302 and U801 require controlled lifecycle monitoring and last-time-buy/change-notification planning.
- No alternate may be substituted merely because a distributor labels it “similar” or “parametric equivalent.”

## Cost Summary

The reviewed quantity-one budgetary sum for one instance of each populated candidate is approximately USD 28 before U101 and U801, distributor fees, freight and optional DNP U209. This is an incomplete planning figure. The EBOM records dated web-snapshot prices where observed and leaves missing prices blank rather than inventing quotes.

## EBOM and AVL Reconciliation

The EBOM and AVL now record all 20 PACS-01 reviews. Eighteen rows contain exact reviewed candidate MPNs, package families, lifecycle state, candidate alternates and budgetary pricing. U101 and U801 explicitly state why no exact orderable MPN can be assigned. Every row remains `BLOCKED`; no MPN is frozen, no footprint is assigned, and no procurement approval is implied. CSV files remain canonical and their XLSX counterparts are regenerated from them.

## Validation

Targeted validation shall enforce exactly 20 unique references, 18 exact candidates, two blockers, TPS2553 polarity/current limits, TPS389030/C305 compatibility, candidate/AVL agreement, unchanged Reference Designator Register, zero CAD/interface changes and one final decision. All repository validators and `git diff --check` are run at package close.

Native ERC status: `kicad-cli` is not available on PATH. ERC remains pending; no schematic was changed in this package.

Primary evidence reviewed:

- TI TPS2663: https://www.ti.com/lit/ds/symlink/tps2663.pdf
- Infineon IAUC100N08S5N034: https://www.infineon.com/part/IAUC100N08S5N034
- TI TPS25947: https://www.ti.com/product/TPS25947/part-details/TPS259470LRPWR
- TI LMR38020-Q1: https://www.ti.com/product/LMR38020-Q1/part-details/LMR38020FSQDDARQ1
- TI TPS2121: https://www.ti.com/product/TPS2121/part-details/TPS2121RUXR
- TI TPS62135: https://www.ti.com/product/TPS62135/part-details/TPS62135RGXR
- TI SN74LVC1G08-Q1 and SN74LVC08A-Q1 product records
- TI TPS22918-Q1: https://www.ti.com/product/TPS22918-Q1/part-details/TPS22918TDBVRQ1
- TI TPS2553-Q1: https://www.ti.com/product/TPS2553-Q1/part-details/TPS2553QDBVRQ1
- TI TPS3890-Q1: https://www.ti.com/product/TPS3890-Q1/part-details/TPS389030QDSERQ1
- TI TCA9517A: https://www.ti.com/product/TCA9517A/part-details/TCA9517ADGKR
- TI TLV841 Rev. E: https://www.ti.com/lit/ds/symlink/tlv841.pdf
- DigiKey availability/pricing snapshots reviewed 2026-07-31.

## Remaining Blockers

1. Issue an ECO or controlled device-variant decision reconciling U101's 20-pin PWP topology with an actual production TPS2663 order code and revalidate Q101/PLIM/MODE/fault behavior.
2. Obtain written TI availability for `TLV841SCPH27YBHR` or select an architecture-compatible production supervisor through a controlled change.
3. Re-run PACS-01 after those two blockers close; then verify exact distributor SKUs, lead times and PO-date pricing for all candidates.
4. Complete vendor-tool and prototype correlation called out by PPQ/PAS before dependent passive and physical release.

## Final Decision

# PACS-01 NOT ACCEPTED

> **ECO-010 disposition:** ECO-010 replaces the two incompatible implementations with TPS26631PWPR and TPS3899DL01DSER physical architectures. PACS-01 remains the historical decision; PACS-01R is authorized to revalidate all 20 active functions. PPC-01 and CSR-01A-R5 remain unauthorized.

PPC-01, CSR-01A-R5, JCS-01, footprint assignment and PCB work remain unauthorized.

> **PACS-01R disposition:** PACS-01R verified ECO-010's corrected U101/U801 identities but did not accept the complete active freeze. Thermal/tool, dependent-passive, prototype, alternate and commercial evidence remain blocked under PACS-01R-A. The historical PACS-01 decision is unchanged.
