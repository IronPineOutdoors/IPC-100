# ECO-011A1R — Safety Input Physical Decomposition

| Field | Value |
| --- | --- |
| Platform | IPC-100 Rev A engineering prototype path |
| Date | 2026-08-04 |
| Scope | Sheet 04 physical decomposition only |
| Authority | QER-04, commit `ba35b9e` |
| Footprints / PCB | None |

## 1. Scope

ECO-011A1R replaces U401AB, U401CD, U402AB, U402CD, U403AB, U403C and U403D with physical comparator, logic and passive circuitry. It preserves all Sheet 04 hierarchy ports, GPIO ownership, ADR-042 thresholds/polarities, field wiring and Sheet 06 STOP ownership. No other sheet was functionally changed.

## 2. QER-04 Handoff

The implementation uses direct comparison on the existing `FIELD_SENSE_VCC`, field-tracking 0.20/0.50/0.80 references, 50–100 mV total hysteresis, open-drain window proof, explicit `FIELD_OK` qualification, and active-high conditioned/fault outputs. LM339B-Q1 is absent. The exact comparator order code is **TLV7044QPWRQ1**, not a family placeholder.

## 3. Current Sheet Audit

The starting commit was `ba35b9e`. All seven composites were present and no partial decomposition existed. The input inventory was five 2.20 kΩ supervised excitations with 1 kΩ/100 nF filters plus two 10 kΩ wetting inputs with 1 kΩ/100 nF filters and 100 kΩ field-off pull-downs. Root/child ports and the seven processor-visible outputs plus `STOP_HW_INHIBIT` matched QER-04. The prior stale LM339 text existed only inside the seven composites and C410–C412 descriptions; it is removed.

## 4. Selected Comparator Architecture

U406–U408 are TLV7044QPWRQ1, active-production TI automotive quad open-drain comparators in 14-pin PW/TSSOP. Guaranteed supply is 1.6–6.5 V; recommended input range is `VEE−0.1 V` through `VCC+0.1 V`; absolute input maximum is 7 V; offset is ±8 mV maximum; bias is 2 pA maximum; typical delay is 3 µs; quad POR time is 400 µs; temperature is –40 to +125 °C. POR makes open-drain outputs high impedance, and inputs remain high impedance with VCC off. Exact pins are A: 1/2/3, B: 7/6/5, C: 8/9/10, D: 14/13/12, VCC 4 and VEE 11.

The maximum normal input is the same field rail that powers the comparators, so 0–5.25 V stays inside the guaranteed common-mode range. The accepted 4.743 V minimum-open and 2.324–2.679 V healthy envelopes retain QER-04 margins.

## 5. Package Allocation

| Package/unit | Function | Pins OUT/IN−/IN+ |
| --- | --- | --- |
| U406A/B/C/D | STOP low / LEFT low / UP low / DOWN high | 1/2/3; 7/6/5; 8/9/10; 14/13/12 |
| U407A/B/C/D | STOP high / RIGHT low / UP high / ARM | same unit pin pattern |
| U408A/B/C/D | LEFT high / RIGHT high / DOWN low / FIRE | same unit pin pattern |
| U409A–D | STOP / LEFT / RIGHT / UP `WINDOW_OK AND FIELD_OK` | 1,2→3; 4,5→6; 9,10→8; 12,13→11 |
| U410A/B/C/D | DOWN / ARM / FIRE qualification / unused tied low | same AND pin pattern |
| U411A–E/F/G | five window inversions / unused tied low / power | 1→2; 3→4; 5→6; 9→8; 11→10; 13→12; 14/7 power |

All units and power units share one physical reference per package. No comparator spare exists; one AND and one inverter unit are explicitly unused.

## 6. Threshold Networks

R401–R405 remain the 50 kΩ equal-section 0.80/0.20 field ladder. R425/R426 add a separate equal 0.50 field-tracking midpoint because an equal five-section ladder has no 0.50 tap. C401/C402/C414 filter the shared taps. Each comparator gets a 10.0 kΩ ±0.1% isolated local threshold (R427–R438), 10 nF filter (C415–C426), and 499 kΩ ±1% output feedback (R439–R450).

The nominal references are 1.0, 2.5 and 4.0 V at 5 V field. The 10 kΩ/499 kΩ feedback produces about 65 mV state-dependent movement before source-loading correction; with the TLV7044 internal 3–25 mV range the design target remains 50–100 mV. QER-04 switching bands remain 0.90–1.10 V, 2.35–2.65 V and 3.80–4.20 V. Exact selected-passive Monte Carlo/SPICE and bench confirmation remain required before schematic release.

Shared-ladder failure is a common cause. Per-channel isolation prevents comparator outputs from directly joining the shared taps. Local reference and comparator outputs are exposed for boundary/fault-injection tests.

## 7. Input Scaling and Protection

There is no sense divider. D401–D407, R409/R411/R413/R415/R417/R420/R423 and C403–C409 retain connector clamp, 1 kΩ current limiting and 100 nF filtering. TLV7044 inputs tolerate the complete accepted range with the comparator powered or unpowered. Battery/VIN injection remains outside the harness contract. Exact D401–D407 leakage/ESD energy remains a later protection-selection gate.

## 8. Five Window Implementations

Each loop has two comparator units whose collectors share one `*_WINDOW_OK` node and one 10 kΩ 3.3 V pull-up R451–R455. The low unit uses `SENSE` on IN+ and local 1 V on IN−; it sinks below low. The high unit uses local 4 V on IN+ and `SENSE` on IN−; it sinks above high. Both released means healthy. U409/U410 AND this proof with `FIELD_OK`; U411 inverts the result. `*_ASSERTED`, conditioned output and local fault are therefore physically the same conservative active-high state.

## 9. Combine Logic

U409/U410 are exact active-production SN74LVC08AQPWRQ1 14-pin PW/TSSOP quad AND gates. U411 is exact active-production SN74LVC14AQPWRQ1 14-pin PW/TSSOP hex Schmitt inverter. They operate on `+3V3_CORE`. R458–R464 pull every qualification/ACTIVE output low if its driving gate is high impedance. Open-drain pull-up ownership is R451–R457. Comparator release plus `FIELD_OK=1` is the only window-inactive condition.

## 10. ARM/FIRE Receivers

U407D and U408D compare protected ARM/FIRE sense directly against independently isolated 2.5 V references. R456/R457 pull up `ARM_REQUEST_OK`/`FIRE_REQUEST_OK`; U410B/U410C AND each request with `FIELD_OK`; R463/R464 default ACTIVE low. Open, field loss, startup and logic loss are inactive. Closed/short-high is active and remains firmware-qualified under ADR-042.

## 11. STOP Inhibit Regression

STOP low and high comparators are deliberately split between U406A and U407A. U409A qualifies their wired proof; U411A produces active-high `STOP_ASSERTED`/`STOP_IN_COND`. U405 is now an exact-pin SN74LVC1G17QDBVRQ1 buffer and R418 remains the fail-high `STOP_HW_INHIBIT` bias. Sheet 06 still consumes the sole hierarchical inhibit and firmware is absent from this route.

TLV7044 POR is high impedance. To guarantee field qualification falls before comparator POR on brownout, R406/R407 are now a 1:1 field detector rather than the preliminary 1:2 network. At 1.6 V field, `FIELD_DIV=0.8 V`, the guaranteed LVC low-input bound; at valid 4.75 V field it is 2.375 V, above the guaranteed high-input bound. This is internal power-valid ordering, not an ADR threshold change.

## 12. Output Regression

The unchanged hierarchical outputs are `STOP_IN_COND`, `LIMIT_LEFT_COND`, `LIMIT_RIGHT_COND`, `LIMIT_UP_COND`, `LIMIT_DOWN_COND`, `ARM_IN_COND`, `FIRE_IN_COND`, and `STOP_HW_INHIBIT`. All remain 3.3 V active high with their original producers/consumers. Local fault names remain local. No GPIO, root hierarchy or cross-sheet net changed.

## 13. Failure-Mode Review

| Failure | Windows / STOP | ARM/FIRE | Residual/test |
| --- | --- | --- | --- |
| Field/comparator supply absent or brownout | `FIELD_OK=0`, qualifier low, asserted/fault high; STOP inhibit high | inactive | ramp both directions and interrupt rail |
| One comparator output stuck low | conservative asserted/fault | inactive if request unit | boundary injection |
| One comparator output open/stuck high | can mask that boundary | can falsely request with high sense | QER-04 residual; manufacturing boundary test |
| Shared/local reference open/short | threshold moves; not credited healthy | threshold moves | inject every resistor fault |
| Hysteresis open | internal hysteresis remains but below target | same | noise/boundary test fails release |
| Hysteresis short | output/reference corruption, generally conservative but channel-dependent | may misclassify | fault injection |
| AND output/input open or package off | R458–R464 force qualifier/ACTIVE low; windows assert through powered inverter | command inactive | power-sequence test |
| Inverter package off | processor state unavailable; STOP downstream R418 remains fail high | not used for command | remove logic power |
| Pull-up open | collector proof cannot rise; window asserts / request inactive | inactive | continuity test |
| Pull-up short to 3.3 V | comparator must sink; shorted resistor itself can mask | request may stick high | manufacturing test |
| Decoupling open | functional until noise sensitivity demonstrated | same | injected-noise test |
| 3.3 V absent | processor and logic unavailable; Sheet 06 reset/watchdog authorization removes permit | inactive/unavailable | no field-to-core backfeed |

No single loss-of-power condition is credited as healthy. Arbitrary stuck-open semiconductor faults remain the non-certified prototype residual explicitly accepted by QER-04.

## 14. Reference Allocation

The seven composite references are retired and never reused. Active physical packages are U406–U411; U404/U405 are retained but corrected to exact five-pin devices. New support allocations are R425–R464, C414–C431, and TP401–TP438. Existing input/protection references remain. The Reference Designator Register records the retirement mapping and new ranges.

## 15. Pin-Mapping Verification

Embedded project symbols expose exact manufacturer pin numbers, names and electrical types. TLV7044 outputs are open collector/drain; comparator and logic supply pins are visible in explicit power units. SN74LVC08A uses 1,2→3; 4,5→6; 9,10→8; 12,13→11; VCC 14/GND 7. SN74LVC14A uses 1→2, 3→4, 5→6, 9→8, 11→10, 13→12; VCC 14/GND 7. SN74LVC1G17 DBV uses NC1, A2, GND3, Y4, VCC5. No footprint property is populated.

## 16. Decoupling and Unused Units

C410–C412 bypass U406–U408 on the field rail. C427–C429 bypass U409–U411; C430/C431 bypass U404/U405; C413 is local 1 µF logic bulk. U410D and U411F inputs are tied to ground and their outputs intentionally no-connect. TLV7044 has no unused channel. PW packages have no exposed thermal pad.

## 17. DFT Nodes

TP401–TP438 cover every raw and filtered input, window/request collector, asserted/fault state, STOP inhibit, 1 V/2.5 V/4 V references and `FIELD_OK`. These are schematic test nodes with blank footprints.

## 18. Population Register Changes

The deterministic population register grew from 313 to **408 rows**: seven composite rows retired and 102 physical rows added, for a net +95. It now has 343 physical-definition-blocked, 49 debug-DNP, 4 default-DNP, 3 documentation-only and 9 required rows. Sheet 04 rows remain blocked from build population until passive/DFT/package footprints and the later physical-release package are authorized.

## 19. EBOM/AVL Reconciliation

EBOM CSV/XLSX and AVL CSV/XLSX contain one row per physical reference, not per multi-unit drawing. U406–U408 carry TLV7044QPWRQ1; U409/U410 carry SN74LVC08AQPWRQ1; U411 carries SN74LVC14AQPWRQ1; U404/U405 carry SN74LVC1G17QDBVRQ1. New passives retain generic electrical requirements. `NOT YET FROZEN` continues to prohibit footprint/physical release.

## 20. Validation Results

Targeted validation checks composite absence, all units/power units, exact order codes/pins, channel allocation, references, thresholds, pull-ups, defaults, decoupling, DFT, unchanged ports/GPIO, synchronized 408-row records, zero footprints and zero PCB files. Repository structural validation confirms balanced S-expressions, unique UUIDs and globally unique physical references while allowing unique units of one package. `git diff --check` is a close gate.

## 21. Native ERC Status

`kicad-cli` was not available in the execution environment. Native ERC remains pending and mandatory before schematic release. Repository S-expression and contract checks do not substitute for ERC.

## 22. Remaining ECO-011 Work

ECO-011A2 motion-control decomposition is the next authorized category only after this package closes. EPP-01A-R, footprint assignment, placement, routing and PCB/fabrication remain unauthorized. Sheet 04 still requires later exact passive/clamp selection, SPICE/Monte Carlo, native ERC and prototype fault-injection evidence before release.

## 23. Manual Review Checklist

- [x] Seven obsolete composites removed and retired.
- [x] Twelve comparator channels and all package power units explicit.
- [x] Five physical windows and two physical command receivers.
- [x] Low/mid/high references, isolation, filtering and hysteresis explicit.
- [x] Open-drain pull-ups, FIELD_OK logic, inversion and fail defaults explicit.
- [x] STOP independent route preserved.
- [x] U404/U405 exact five-pin mappings corrected.
- [x] Unused logic units and all local bypass capacitors explicit.
- [x] DFT, EBOM, AVL, population and reference records synchronized.
- [x] No hierarchy, GPIO, ADR, ICD, footprint or PCB change.
- [ ] Native ERC, SPICE and prototype validation complete.

## Final Decision

# ECO-011A1R COMPLETE — ECO-011A2 AUTHORIZED

EPP-01A-R and footprint assignment remain unauthorized.
