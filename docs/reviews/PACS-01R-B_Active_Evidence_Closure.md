# PACS-01R-B — Active Evidence Closure

Date: 2026-08-01

Platform: IPC-100 Rev A

Baseline: PACS-01R-A commit `eb01ca7`

## Executive Summary

All 20 selected active references were reviewed against the current manufacturer identity, PPQ/QER operating envelopes, existing commercial records, and the unchanged schematics. All selected MPNs remain electrically plausible and manufacturer status is `ACTIVE`; no evidence demonstrates a replacement-device or schematic defect.

PACS-01R-B cannot claim complete evidence closure. Exact candidate thermal records are not controlled for every package/board condition, U201/U203 manufacturer design-tool outputs are absent, Q101/U101 transient SOA coordination is incomplete, several prototype-only behaviors remain unmeasured, and current distributor evidence lacks complete quantity 1/10/100/1000 prices, lead times, MOQs and independently approved alternates. The current PPQ thermal model explicitly says exact package/copper correlation remains open. These omissions prevent objective freeze approval.

## Device Inventory

| Reference(s) | Manufacturer | Exact MPN | Package | Lifecycle | Present evidence result |
| --- | --- | --- | --- | --- | --- |
| Q101 | Infineon | IAUC100N08S5N034ATMA1 | PG-TDSON-8, 5×6 | ACTIVE / preferred; planned availability ≥2037 | Electrical candidate retained; SOA/thermal open |
| U101 | Texas Instruments | TPS26631PWPR | 20-pin PWP PowerPAD | ACTIVE | Pin/rating correction verified; coordinated thermal/SOA open |
| U102 | Texas Instruments | TPS259470LRPWR | RPW-10 | ACTIVE | Functional selection retained; exact thermal/inrush open |
| U201 | Texas Instruments | LMR38020FSQDDARQ1 | DDA-8 PowerPAD | ACTIVE | 400 kHz variant retained; tool/thermal open |
| U202 | Texas Instruments | TPS2121RUXR | RUX-12 | ACTIVE | Functional selection retained; transition/thermal open |
| U203 | Texas Instruments | TPS62135RGXR | RGX-11 | ACTIVE | Functional selection retained; tool/thermal open |
| U204 | Texas Instruments | SN74LVC1G08QDCKRQ1 | DCK-5 | ACTIVE | Logic selection retained; commercial record incomplete |
| U205 | Texas Instruments | SN74LVC08AQPWRQ1 | PW-14 | ACTIVE | Logic selection retained; commercial record incomplete |
| U206–U208/U210/U211 | Texas Instruments | TPS22918TDBVRQ1 | DBV-6 | ACTIVE | Branch selection retained; enclosure/prototype open |
| U209/U212/U213 | Texas Instruments | TPS2553QDBVRQ1 | DBV-6 | ACTIVE | QER-02 passes; transient thermal/prototype open |
| U302 | Texas Instruments | TPS389030QDSERQ1 | DSE-6 | ACTIVE | ECO-009R/QER-03 pass; exact MPN/prototype evidence open |
| U706/U707 | Texas Instruments | TCA9517ADGKR | DGK-8 | ACTIVE | 100 kHz/partial-power class retained; fault/thermal open |
| U801 | Texas Instruments | TPS3899DL01DSER | DSE-6 | ACTIVE | ECO-010 threshold architecture verified; corner test open |

No current EBOM active row is NRND, LIFEBUY, OBSOLETE or UNKNOWN. Manufacturer review date is 2026-08-01. Distributor stock is a dated observation and is not lifecycle evidence.

## Manufacturer Evidence

The controlled evidence includes exact ordering codes, package families, operating ranges and behavior recorded by PACS-01/ECO-010. Primary sources are the current TI product pages and datasheets for TPS2663, TPS25947, LMR38020-Q1, TPS2121, TPS62135, SN74LVC logic, TPS22918-Q1, TPS2553-Q1, TPS3890-Q1, TCA9517A and TPS3899, plus Infineon's IAUC100N08S5N034 product page/datasheet.

Verified examples include U101 at 4.5–60 V in PWP-20, U203 at 3–17 V/4 A in RGX-11, and Q101 at 80 V/3.4 mΩ maximum with −55…175 °C rating. On 2026-08-01 DigiKey listed U101 active, 2,882 units, nine-week standard lead time, and USD 4.52/3.431/2.8573 at quantities 1/10/100. This is useful sourcing evidence but not a complete 20-device commercial matrix.

Remaining manufacturer evidence gaps are controlled datasheet revision/date entries for every MPN, exact package-board thermal tables, application-note/design-tool archives for both regulators, and transient Zθ/SOA overlays for Q101/U101. Recommended-layout guidance is recorded as a future PCB constraint only; it does not assign a footprint.

## Thermal Analysis

Boundary: +60 °C ambient, +75 °C internal air, natural convection, no airflow credit, design junction ≤110 °C and measured target ≤100 °C. `TJ = 75 °C + P × θJA` is valid only when θJA uses the eventual manufacturer board/copper definition. “Open” below means no defensible exact θJA-to-future-board correlation exists—not zero margin.

| Reference | MPN | Estimated dissipation | Exact θJA basis | Estimated TJ | Margin to 110 °C target | Risk | Required copper assumption |
| --- | --- | ---: | --- | ---: | ---: | --- | --- |
| Q101 | IAUC100N08S5N034ATMA1 | 0.039 W at 1.25 A; 0.100 W at 2 A screening | Open; SOA/Zθ dominates | Open | Open | High | Manufacturer 5×6 thermal land and pulse heat spreading |
| U101 | TPS26631PWPR | 0.048 W at 1.25 A; 0.124 W at 2 A typical path | Open for released PWP copper | Open | Open | High | Exposed pad, multilayer ground/copper and vias per TI |
| U102 | TPS259470LRPWR | ≈0.014 W at 0.5 A using 56 mΩ screening | Open | Open | Open | Medium | RPW thermal pad/copper per TI |
| U201 | LMR38020FSQDDARQ1 | ≤1.324 W PPQ ceiling | Required effective θJA ≤26.4 °C/W | ≤110 °C only if ceiling achieved | 0 °C analytical target edge | High | Four layers, DDA exposed pad and TI via pattern |
| U202 | TPS2121RUXR | ≈0.126 W at 1.5 A using 56 mΩ typical | Open | Open | Open | Medium | RUX exposed-pad copper per TI |
| U203 | TPS62135RGXR | ≤0.582 W PPQ ceiling | Required effective θJA ≤60.1 °C/W | ≤110 °C only if ceiling achieved | 0 °C analytical target edge | High | Continuous ground/copper path, no airflow credit |
| U204 | SN74LVC1G08QDCKRQ1 | <0.010 W screening | Open; low loss | Open | Expected large; unproven | Low | Standard DCK signal land with ground return |
| U205 | SN74LVC08AQPWRQ1 | <0.020 W screening | Open; low loss | Open | Expected large; unproven | Low | Standard PW land with local ground copper |
| U206 | TPS22918TDBVRQ1 | <0.002 W at 0.18 A typical | Open | Open | Expected large; unproven | Medium | TI DBV recommended land/copper |
| U207 | TPS22918TDBVRQ1 | <0.002 W | Open | Open | Expected large; unproven | Medium | Same |
| U208 | TPS22918TDBVRQ1 | <0.002 W | Open | Open | Expected large; unproven | Medium | Same |
| U209 | TPS2553QDBVRQ1 | 0.00085 W normal; ≤0.734 W fault screening | Transient Zθ open | Open | Open during fault | High | TI DBV recommended copper; fault pulse correlation |
| U210 | TPS22918TDBVRQ1 | <0.002 W | Open | Open | Expected large; unproven | Medium | TI DBV recommended land/copper |
| U211 | TPS22918TDBVRQ1 | <0.002 W | Open | Open | Expected large; unproven | Medium | Same |
| U212 | TPS2553QDBVRQ1 | 0.00085 W normal; ≤1.112 W fault screening | Transient Zθ open | Open | Open during fault | High | TI DBV recommended copper; fault pulse correlation |
| U213 | TPS2553QDBVRQ1 | 0.00085 W normal; ≤1.112 W fault screening | Transient Zθ open | Open | Open during fault | High | Same |
| U302 | TPS389030QDSERQ1 | <0.010 W screening | Open; low loss | Open | Expected large; unproven | Low | DSE exposed-pad/ground recommendation |
| U706 | TCA9517ADGKR | <0.020 W screening | Open | Open | +85 °C rating leaves only 10 °C air margin | High | DGK land with low thermal coupling to hot power stages |
| U707 | TCA9517ADGKR | <0.020 W screening | Open | Open | +85 °C rating leaves only 10 °C air margin | High | Same |
| U801 | TPS3899DL01DSER | <0.005 W screening | Open; low loss | Open | Expected large; unproven | Low | DSE exposed-pad/ground recommendation |

This matrix is sufficient to identify risk and required copper evidence, but not to freeze any device whose exact junction estimate is “Open.”

## Derating Analysis

| Device class | Applied voltage / rated voltage | Voltage utilization | Applied current / rated current | Current utilization | Transient utilization | Thermal utilization | Result |
| --- | --- | ---: | --- | ---: | --- | --- | --- |
| Q101 | 55 V / 80 V | 68.8% | 2 A / 100 A headline | 2.0% (not SOA proof) | 2 A/100 ms overlay open | Open | FAIL — evidence incomplete |
| U101 | 55 V / 67 V absolute | 82.1% | 2 A / 6 A catalog | 33.3% | 4 A/10 ms support requires correlation | Open | FAIL — evidence incomplete |
| U102 | 5.25 V / 23 V | 22.8% | 0.5 A / device class >0.5 A | <100% | Inrush open | Open | FAIL — evidence incomplete |
| U201 | 55 V stress / 80 V operating | 68.8% | 2 A peak / 2 A | 100% peak | QER pulse case bounded | At θ ceiling | FAIL — tool/thermal evidence incomplete |
| U202 | 5.25 V / 22 V | 23.9% | 1.5 A / 4.5 A | 33.3% | Source transfer open | Open | FAIL — evidence incomplete |
| U203 | 5.25 V / 17 V | 30.9% | 1.5 A peak / 4 A | 37.5% | Startup/load-step open | At θ ceiling | FAIL — tool/thermal evidence incomplete |
| U204/U205 | 3.3 V / 5.5 V | 60.0% | Logic loads / rated drive | Low | None material | Open, low loss | FAIL — controlled thermal/commercial record incomplete |
| TPS22918 branches | 5.25 V / 5.5 V | 95.5% | ≤0.18 A / 2 A | ≤9.0% | Inrush open | Open | FAIL — evidence incomplete |
| TPS2553 branches | 5.25 V / 6.5 V | 80.8% | 0.1 A / 1.3 A class | 7.7% | 162.824–222.345 mA limit passes | Fault thermal open | FAIL — evidence incomplete |
| U302 | 3.3 V / device operating range | Within | µA-class / rated | Low | QER-03 timing passes | Open, low loss | FAIL — exact thermal/commercial evidence incomplete |
| U706/U707 | 3.3 V domains / 5.5 V max | 60.0% | Bus current / rated | Low | Partial-power test open | Temperature margin open | FAIL — evidence incomplete |
| U801 | 3.3 V / device operating range | Within | µA-class / rated | Low | Threshold sweep open | Open, low loss | FAIL — evidence incomplete |

No voltage/current incompatibility was found. “FAIL” is an evidence-gate result, not proof that the selected MPN is unsuitable.

## Lifecycle Review

All preferred devices are classified `ACTIVE` from manufacturer records reviewed 2026-08-01. Q101 is additionally marked active/preferred with planned availability through at least 2037. No row is NRND, LIFEBUY, OBSOLETE or UNKNOWN. Remaining lifecycle work is to record datasheet revision/date and establish PCN/PDN monitoring in the controlled AVL for every MPN.

## Sourcing Review

DigiKey is the preferred planning distributor and Mouser the alternate planning distributor; neither is an approved alternate manufacturer. Existing PACS snapshots provide quantity-one prices for 18 preserved candidates, approximately USD 28 total before U101/U801. U101's current DigiKey snapshot is 2,882 units, nine-week standard lead time, cut-tape MOQ 1, tape/reel packaging, and USD 4.52/3.431/2.8573 at 1/10/100; 1000-unit price is not listed. TPS2553 snapshots are inconsistent over time (0 to several thousand stock), demonstrating the need for PO-date revalidation.

The required complete matrix—both distributors, current stock, lead category, MOQ, packaging, quantities 1/10/100/1000 and alternate classification for every device—is absent. All selections are single-manufacturer design dependencies; counterfeit risk is controlled only through authorized distribution. Sourcing evidence therefore fails closure.

## Alternates

No drop-in alternate is approved. Recorded alternatives remain `FUNCTIONAL ALTERNATE — ECO REQUIRED`, `CANDIDATE ONLY`, or same-die carrier variants requiring ordering review. U101, U302 and U801 have no approved design substitute. This is an explicit alternate strategy but not supply-risk closure.

## Risk Matrix

| Risk | Affected references | Severity | Closure |
| --- | --- | --- | --- |
| Exact SOA/transient thermal absent | Q101/U101, U209/U212/U213 | Critical | Manufacturer Zθ/SOA overlays and bench pulse correlation |
| Regulator tool/thermal evidence absent | U201/U203 and dependent passives | Critical | Archived TI tool solutions and exact hot-loss/copper calculation |
| Exact package-board θ correlation absent | All active rows | Major | Controlled manufacturer board definition and future-layout constraint |
| Narrow threshold margin | U801 | Major | Full leakage/tolerance calculation and temperature/rail sweep |
| +85 °C buffer rating | U706/U707 | Major | Closed-enclosure thermal and stuck-bus/partial-power tests |
| Commercial matrix incomplete | All | Major | Authorized-distributor capture at required quantities |

## Remaining Prototype Evidence

- Three closed-enclosure assemblies at 9 V and 21 V, 25/50/100% load and +60 °C chamber; measured junction-correlated target ≤100 °C.
- Q101/U101 surge, reverse, startup, 2 A/100 ms and 4 A/10 ms captures with calibrated current/voltage/temperature instrumentation.
- U201/U203 startup, brownout, load-step, ripple, efficiency and stabilized thermal measurements.
- U202 all main/USB connection orders and simultaneous-source interruption/backfeed tests.
- Branch load-switch inrush/off-discharge and TPS2553 current-limit/retry/fault thermal waveforms.
- U302 76–149 ms guarded timing matrix and brownout restart.
- U706/U707 powered/unpowered, stuck-bus, leakage/backfeed and +60 °C tests.
- U801 assertion/deassertion/delay sweeps across tolerance, temperature, startup, brownout and partial power.

These tests belong to PACS-01R-C only after analytical/manufacturer evidence closes. PACS-01R-C is not authorized by this result.

## Validation Results

The targeted validator confirms all 20 references, lifecycle classifications, thermal and derating rows, sourcing risk, exact MPNs, downstream gate, and no CAD changes. All repository validators and `git diff --check` are required. Native ERC remains pending because `kicad-cli` is unavailable; no schematic changed.

## Final Decision

# PACS-01R-B NOT ACCEPTED

PACS-01R-C and PPC-01 are not authorized. The single smallest corrective package is **PACS-01R-B1 — Exact Manufacturer Thermal, Regulator Tool and Commercial Evidence Completion**. It shall provide the missing exact θ/board records, U201/U203 tool archives, Q101/U101/TPS2553 transient thermal overlays, controlled datasheet revisions, and complete current distributor matrix. Prototype-only items remain separately identified and shall not be used to conceal analytical gaps.
