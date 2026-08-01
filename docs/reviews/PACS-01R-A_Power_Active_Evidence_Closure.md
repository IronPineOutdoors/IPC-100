# PACS-01R-A — Power Active Evidence Closure

Date: 2026-08-01

Platform: IPC-100 Rev A

Baseline: PACS-01R commit `7a07596`

## Executive Summary

PACS-01R-A converts every remaining power-active freeze blocker into a bounded evidence task. The current 20-reference selection is retained: no evidence presently invalidates a selected MPN, pin map, package family, architecture, schematic value, or interface. This package does not freeze devices; it defines the evidence required to make the next freeze decision.

All blockers can initially be investigated without schematic, footprint-family, PCB, architecture, or requirements changes. A failed test or analysis may require a later narrow ECO, but no such defect is currently demonstrated. The smallest next package is **PACS-01R-B — Power Active Analytical, Manufacturer and Thermal Evidence Closure**. It shall close datasheet/orderable-code records, exact pin/function records, device calculations, derating, SOA, thermal/copper assumptions, regulator tool outputs, and explicit prototype acceptance criteria before commercial and bench evidence is executed.

## Evidence Classification

- **Documentation only:** controlled manufacturer data, pin/function, package and QER/PPQ trace records.
- **Analytical:** tolerance, timing, startup, shutdown, reverse-current, fault and stability calculations.
- **Prototype validation:** measured waveforms, thresholds, transitions, partial-power and fault injection.
- **Sourcing:** authorized distributor SKU, stock snapshot, lead time, MOQ, price breaks and alternate disposition.
- **Lifecycle:** manufacturer status, PCN/PDN monitoring and expected availability.
- **Thermal:** dissipation, hot parameters, package model, copper assumptions, enclosure case and junction margin.
- **Qualification:** automotive/environmental applicability and released test evidence.

No current blocker is solely regulatory. Counterfeit control and authorized-channel procurement remain sourcing/qualification controls.

## Device Evidence Matrix

| Reference(s) | Current MPN | Current blocker | Evidence needed | Class | Can close without schematic / footprint family / PCB / architecture change? | Estimated closure package | Expected disposition |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q101 | IAUC100N08S5N034ATMA1 | Hot linear SOA and copper/protection timing correlation absent | Manufacturer SOA curves at hot corner; gate-drive point; 2 A/100 ms and surge pulse overlay; transient thermal impedance; copper/JT model; bench pulse temperature | Analytical, Thermal, Prototype, Qualification, Sourcing, Lifecycle | Yes / Yes / Yes / Yes for evidence collection | PACS-01R-B analysis, then PACS-01R-C bench/commercial | FROZEN if SOA margin passes; otherwise narrow ECO |
| U101 | TPS26631PWPR | Full eFuse/pass-FET/support network worst-case solution incomplete | Current datasheet/revision; PLIM/ILIM/UVLO/OVP/dVdt tolerance; shutdown/Iq; latch/retry truth; surge energy; integrated-FET hot loss; PWP pad/copper requirement; startup/fault waveforms; alternate and price matrix | Documentation, Analytical, Thermal, Prototype, Sourcing, Lifecycle, Qualification | Yes / Yes / Yes / Yes initially | PACS-01R-B then PACS-01R-C | FROZEN if coordinated margins pass |
| U102 | TPS259470LRPWR | ILIM, inrush and RPW thermal evidence incomplete | Exact suffix mode/pin proof; 500 mA limit stack; output-C/inrush; reverse blocking and latch test; hot dissipation/copper; lifecycle, stock, prices, alternate | Documentation, Analytical, Thermal, Prototype, Sourcing, Lifecycle | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN |
| U201 | LMR38020FSQDDARQ1 | Vendor-tool stability, magnetics, effective capacitance and hot thermal closure absent | TI design-tool report at all QER corners; 64.9 kΩ/400 kHz proof; minimum on/off-time; ripple; loop/stability; efficiency/loss; DDA copper/JT; startup/brownout/load-step; sourcing and alternate record | Analytical, Thermal, Prototype, Sourcing, Lifecycle, Documentation | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN if tool and bench margins pass |
| U202 | TPS2121RUXR | Source-transition, inrush, reverse-current and thermal correlation absent | Exact priority/mode settings; switchover interruption; reverse blocking; simultaneous-source fault cases; hot RON loss; RUX copper; connect-order bench matrix; sourcing/alternate | Analytical, Thermal, Prototype, Sourcing, Lifecycle | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN |
| U203 | TPS62135RGXR | Stability/effective-C/soft-start and thermal closure absent | Exact mode/discharge proof; inductor/capacitor design-tool solution; ripple/current-limit/minimum-time checks; efficiency/loss; RGX copper/JT; startup/brownout/load-step; sourcing/alternate | Analytical, Thermal, Prototype, Sourcing, Lifecycle, Documentation | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN if dependent passives pass |
| U204 | SN74LVC1G08QDCKRQ1 | Controlled pin/Ioff/thermal and commercial record incomplete | Official pin/function and Ioff table; 3.3 V VIH/VIL/leakage corners; propagation/default-state check; junction estimate; lifecycle, authorized SKUs, prices, alternate class | Documentation, Analytical, Thermal, Sourcing, Lifecycle | Yes / Yes / Yes / Yes | PACS-01R-B | FROZEN |
| U205 | SN74LVC08AQPWRQ1 | Controlled quad-gate evidence and commercial record incomplete | Pin/unit mapping; unused-input treatment; Ioff/threshold/drive/leakage; propagation/default-state; package thermal; lifecycle, SKUs, prices, alternate | Documentation, Analytical, Thermal, Sourcing, Lifecycle | Yes / Yes / Yes / Yes | PACS-01R-B | FROZEN |
| U206/U207/U208/U210/U211 | TPS22918TDBVRQ1 | +75 °C enclosure margin, rise/QOD and sourcing evidence incomplete | Per-branch load/Cout/inrush; CT rise; QOD/default state; reverse-current/power-off; hot RON loss and +105 °C ambient basis; bench branch start/stop; lifecycle, SKUs, prices, alternate | Analytical, Thermal, Prototype, Sourcing, Lifecycle, Documentation | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN |
| U209/U212/U213 | TPS2553QDBVRQ1 | QER-02 passes, but retry/fault, hot loss, output-C and commercial proof incomplete | Exact active-high suffix/pins; 141 kΩ coefficient confirmation; 162.824–222.345 mA audit; fault retry waveform; reverse-current; 150 mA/10 ms startup; hot RON/copper; lifecycle, stock, prices, alternate | Documentation, Analytical, Thermal, Prototype, Sourcing, Lifecycle | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN |
| U302 | TPS389030QDSERQ1 | Exact C305 MPN, full controlled pin/timing record and sourcing/alternate evidence incomplete | DSE pin map; 2.89 V threshold corners; open-drain/power-off; CT current/threshold stack; confirm 93.1 nF yields 99.642 ms and 79.1–136.6 ms; 76–149 ms bench test; lifecycle, SKUs, alternate | Documentation, Analytical, Prototype, Sourcing, Lifecycle, Qualification | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN with C305 if timing passes |
| U706/U707 | TCA9517ADGKR | Temperature margin, offset-low, stuck-bus and partial-power evidence incomplete | Exact DGK mapping; A/B direction; 100 kHz timing/capacitance; offset-low cascade proof; EN-low isolation; Ioff/leakage/backfeed; +75 °C enclosure junction; powered/unpowered stuck-bus injection; lifecycle, prices, alternate | Documentation, Analytical, Thermal, Prototype, Sourcing, Lifecycle, Qualification | Yes / Yes / Yes / Yes | PACS-01R-B then PACS-01R-C | FROZEN if fault containment passes |
| U801 | TPS3899DL01DSER | 17 mV high-corner assertion margin and exact passive/leakage/prototype evidence incomplete | DSE pin record; ±2.5% threshold, hysteresis, SENSE leakage and divider drift stack; verify 2.934–3.283 V/2.501–2.693 V; 10 nF delay; RESET pull-up/backfeed; startup/brownout/partial-power sweep; lifecycle, prices, alternate | Documentation, Analytical, Prototype, Sourcing, Lifecycle, Qualification | Yes / Yes / Yes / Yes initially | PACS-01R-B then PACS-01R-C | FROZEN if threshold sweep passes; otherwise narrow ECO |

## Dependent Passive Evidence

The 17 original PACS-dependent rows and ECO-010 support rows now name exact active MPNs. They are not blocked by active selection. PACS-01R-B shall close:

- U101: C102/C103/C104/C109/L101 manufacturer curves, ripple, lifetime and hot magnetic behavior.
- U201: C201–C205/L201 design-tool, effective-capacitance, ripple, stability and hot magnetic evidence.
- U202/U203: C206 source-transition/effective-capacitance evidence.
- U203: C208/C209/C210/L202 stability, soft-start and hot magnetic evidence.
- U801: C805/R807/R808/R809 tolerance, leakage, delay and threshold evidence.
- U302: C305 exact MPN plus prototype timing; its ECO-009R electrical class remains valid.

## Package Boundaries

### PACS-01R-B — Power Active Analytical, Manufacturer and Thermal Evidence Closure

Produce the controlled datasheet/pin records, manufacturer design-tool files, corner calculations, derating tables, SOA overlays, thermal/copper assumptions, dependent-passive evidence and explicit bench acceptance criteria. It may recommend a narrow ECO but may not change hardware.

### PACS-01R-C — Power Active Prototype, Sourcing and Lifecycle Evidence Closure

Only after PACS-01R-B passes, execute the released bench matrix and capture current authorized-distributor SKUs, stock date, lead time, MOQ, quantity pricing, lifecycle evidence and alternate dispositions. This package is not yet authorized by PACS-01R-A; PACS-01R-B must first prove that the selected hardware is analytically viable.

## Validation

The targeted validator checks all 20 current active references, exact MPNs, a nonempty blocker and evidence route for every row, the absence of obsolete active implementations, zero generic active-selection passive blockers, no CAD/interface changes and the single package decision. All repository validators and `git diff --check` must pass. Native ERC remains pending because `kicad-cli` is unavailable; no schematic changed.

## Final Decision

# PACS-01R-A ACCEPTED

**PACS-01R-B — Power Active Analytical, Manufacturer and Thermal Evidence Closure is authorized.**

PPC-01, PACS-01R-C, JCS-01, CSR-01A-R5, footprint assignment and PCB work remain unauthorized. No power-active device is represented as freeze eligible by this evidence-definition package.
