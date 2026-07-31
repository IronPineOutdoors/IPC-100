# QER-02 — Branch Peak and Protection Ceiling Reconciliation

| Field | Value |
|---|---|
| Platform | IPC-100 Rev A |
| Baseline | ECO-008 commit `7b746a2` |
| Date | 2026-07-31 |
| Package type | Requirements reconciliation only |
| Hardware changes | None |

## 1. Executive Summary

QER-02 resolves the zero-width current-limit requirement affecting U209/R222, U212/R223, and U213/R224. The existing 100 mA continuous and 150 mA/10 ms non-fault load allocations remain unchanged. The former generic 150 mA protection ceiling incorrectly treated a load contract and a fault-containment threshold as the same quantity.

For these three branches, the current limiter is now specified as a **160–225 mA worst-case fault-threshold band**. The 160 mA lower bound provides 10 mA (6.7%) separation above the provisional 150 mA peak. The 225 mA upper bound remains below the derated downstream interconnect ceiling and well below the 1.0 A/1.5 A source-rail allocations. This is a requirements band, not a component value or permission for a load to exceed its interface contract.

Using the TPS2553-Q1 manufacturer equations and a ±1% RILIM tolerance, the allowable nominal programming-resistance interval is 138.604–144.167 kΩ, a positive 5.562 kΩ window. QER-02 does not select a resistor. ECO-008R shall perform selection, exact-part thermal/retry analysis, and implementation verification.

## 2. Background

PPQ-01 found that the released 150 kΩ networks produce approximately 154–209 mA. ECO-008 proved that simultaneously requiring a worst-case minimum and maximum of 150 mA admits no tolerance. QER-01 §3.1 supplied the 150 mA/10 ms load allocation; its generic §6 rule supplied the conflicting 150% ceiling. Neither value was measured load evidence.

This amendment preserves architecture, branch ownership, rail budgets, GPIO, hierarchy, ADRs, ICDs, and the optional/DNP status of J10.

## 3. Affected Branch Inventory

| TPS2553 / RILIM | Branch / load | Source | Idle / typical | Steady max | Peak/startup | Capacitance | Former ceiling | Downstream / upstream boundary | Load absolute maximum | PPQ confidence |
|---|---|---|---:|---:|---:|---:|---:|---|---|---|
| U209 / R222 | `EXPANSION_VCC`; optional J10 accessory | `+3V3_CORE`, 3.3 V | 0 / 75 mA | 100 mA | 150 mA/10 ms | 4.7 µF local; total measured with accessory | 150 mA | D1 ≥1 A; H10 26–28 AWG; 1.0 A rail | Accessory-specific/unreleased; must obey ICD-001 | Medium; allocation |
| U212 / R223 | `MOTOR_LOGIC_5V_A`; Axis 1 logic | `+5V_MAIN`, 5 V | 0 / 50 mA | 100 mA | 150 mA/10 ms | 4.7 µF plus driver input | 150 mA | P2/M1 ≥2 A; H02 24–26 AWG; 1.5 A rail | Driver-specific/unreleased; excludes motor current | Medium; allocation |
| U213 / R224 | `MOTOR_LOGIC_5V_B`; Axis 2 logic | `+5V_MAIN`, 5 V | 0 / 50 mA | 100 mA | 150 mA/10 ms | 4.7 µF plus driver input | 150 mA | P2/M1 ≥2 A; H03 24–26 AWG; 1.5 A rail | Same as Axis 1 | Medium; allocation |

The affected population is exactly six references: three switches and three independent RILIM resistors. Switch thermal limits remain exact-part evidence.

## 4. Peak Requirement Audit

| Branch | Origin / classification | Meaning | Completed waveform | Evidence |
|---|---|---|---|---|
| Expansion | Inherited design allowance | Accessory boot, capacitor charge, and fault-free transient; not continuous or absolute maximum | ≤150 mA rectangular-equivalent, ≤10 ms, one event per enable, ≤1 Hz, duty ≤1% | Provisional; test required |
| Motor logic A | Inherited design allowance | External logic startup/boot plus capacitor charging; no motor power | Same | Provisional; exact-driver test required |
| Motor logic B | Inherited design allowance | Same as A | Same | Provisional; exact-driver test required |

No branch has a measured or manufacturer-guaranteed 150 mA peak. Longer or repetitive demand counts toward the 100 mA continuous allocation. A load exceeding this envelope requires controlled review; the protection ceiling shall not be raised informally.

## 5. Protection Ceiling Audit

The former ceiling came from QER-01's generic “150% of continuous allocation” rule, not a 150 mA physical rating. The 100 mA values protect the load contracts and shared budget. Branch limiting contains interconnect shorts and isolates the source rail. It does not protect an unknown accessory's internal semiconductor absolute maximum; approved loads must independently meet their contracts.

The weakest documented physical boundary is the D1 J10 connector at 1 A. Applying QER's 1.5× interconnect derating gives a 667 mA branch basis. H10 26–28 AWG, H02/H03 24–26 AWG, P2/M1 contacts, PCB copper required to carry the protected branch, and the 1.0/1.5 A rails are no weaker. A 225 mA ceiling uses 33.7% of that derated D1 basis. Exact connector temperature rise and copper validation remain required.

## 6. Load Current Envelopes

| Region | Expansion | Motor A | Motor B |
|---|---:|---:|---:|
| Typical | 75 mA | 50 mA | 50 mA |
| Normal continuous | 0–100 mA | 0–100 mA | 0–100 mA |
| Expected transient | >100–150 mA, ≤10 ms, ≤1 Hz | Same | Same |
| No-limit margin | >150–160 mA | Same | Same |
| Protection tolerance | 160–225 mA | Same | Same |
| Fault | >225 mA demanded; contain | Same | Same |
| Rise/droop | 0.2–10 ms; J10 ≥3.0 V | 0.2–10 ms; ≥4.75 V | Same |

At 160 mA minimum limit and 100 mA load, 60 mA remains for charging. Ideal 4.7 µF charge time is 0.26 ms at 3.3 V and 0.39 ms at 5 V; 22 µF at J10 is 1.21 ms. Testing must confirm the real waveform.

## 7. Required Margins

- Peak-to-limit: ≥10 mA (6.7% of peak).
- Continuous-to-limit: ≥60 mA (60% of continuous allocation).
- Limit-to-protected element: ≥442 mA against the 667 mA derated D1 basis.
- Single ceiling-to-source: 22.5% of `+3V3_CORE`, 15% of `+5V_MAIN`.

The preliminary 10 mA operating margin covers allocation rounding, load/supply/temperature variation, capacitance tolerance, aging, measurement uncertainty, and prototype spread. TPS2553 and RILIM tolerances are applied separately. Prototype demand above 150 mA reopens the requirement.

## 8. Legal Current-Limit Windows

For all three branches: `150 mA + 10 mA ≤ I_LIMIT_WORST_CASE_MIN` and `I_LIMIT_WORST_CASE_MAX ≤ 225 mA`. The legal threshold window is **160–225 mA**, width **65 mA**.

TPS2553-Q1 equations (R in kΩ, I in mA), including ±1% RILIM endpoints:

- `Imax = 22980 / R^0.94`; ≤225 mA requires nominal R ≥138.604 kΩ.
- `Imin = 25230 / R^1.016`; ≥160 mA requires nominal R ≤144.167 kΩ.
- feasible nominal interval: **138.604–144.167 kΩ**, width **5.562 kΩ**.

| Branch | Limit band | Feasible Rnom interval (not selection) | Classification |
|---|---:|---:|---|
| U209/R222 | 160–225 mA | 138.604–144.167 kΩ | FEASIBLE WITH REVISED PROTECTION CEILING |
| U212/R223 | 160–225 mA | 138.604–144.167 kΩ | FEASIBLE WITH REVISED PROTECTION CEILING |
| U213/R224 | 160–225 mA | 138.604–144.167 kΩ | FEASIBLE WITH REVISED PROTECTION CEILING |

No nominal-only proof is accepted. ECO-008R must apply the exact order-code temperature bounds, resistor tolerance/tempco, and selected standard value.

## 9. Inrush Reduction Options

| Option | Peak / timing effect | Impact | Verification |
|---|---|---|---|
| Slower rise | Reduces capacitor peak; increases delay | Limiter-dependent schematic behavior | Scope all corners |
| Reduce/relocate capacitance | Reduces charge; may worsen droop | Hardware/accessory change | Capacitance and load step |
| Staged enable | Avoids coincident peaks | Firmware may improve availability; safety cannot depend on it | Brownout/recovery |
| Downstream enable delay | Separates charge and boot | Load-specific | Exact load test |

No inrush change is prescribed. ECO-009 is not authorized unless prototype evidence violates 150 mA.

## 10. Ceiling Revision Options

150 mA is infeasible because it has no separation from the peak. A 200 mA ceiling offers insufficient practical tolerance width with a 160 mA minimum. The adopted 225 mA ceiling is the smallest reviewed round ceiling yielding a usable TPS window while retaining large physical and upstream margins.

At the ceiling, short-circuit power is bounded initially by 0.743 W at 3.3 V and 1.125 W at 5 V before thermal regulation/retry. Exact junction temperature, retry duty, enclosure rise, and copper are implementation gates. The ceiling does not amend ICD load contracts.

## 11. TPS2553-Q1 Suitability

The family is preliminarily suitable because its programmable range contains a nonzero interval for 160–225 mA. Exact suffix review must close full-temperature limit curves, rise time, on-resistance/droop, reverse current, quiescent current, thermal impedance, retry behavior, and persistent-short recovery. QER-02 neither selects nor freezes a device.

## 12. Simultaneous-Load Analysis

USB-only keeps all affected branches off. Their valid simultaneous continuous total is 300 mA. Simultaneous 150 mA peaks total 450 mA for 10 ms: 300 mA on `+5V_MAIN` and 150 mA on `+3V3_CORE`, within QER rail peaks when other state loads obey the total budgets.

Ceilings are not load allocations. A three-branch 675 mA threshold sum remains below aggregate sources, but persistent faults must be isolated. Brownout restoration shall avoid intentionally coincident optional-load startup; safety does not depend on sequencing, and testing includes simultaneous recovery.

## 13. Protection Philosophy

The switches provide load switching, wiring/connector protection, short containment, fault isolation, limited inrush control, rail protection, and gross accessory-contract enforcement. Distinct numbers mean:

- 100 mA: maximum continuous load/interface contract;
- 150 mA/10 ms: maximum expected non-fault transient;
- 160–225 mA: guaranteed worst-case fault-threshold band;
- >225 mA demanded: fault region.

The upper threshold is a safety ceiling, not a nominal target or permission for continuous load above 100 mA.

## 14. QER-01 Amendment Matrix

| Branch | Original/revised peak | Original ceiling | Revised band | Evidence/rationale | QER/ICD impact | Implementation |
|---|---:|---:|---:|---|---|---|
| Expansion | 150 mA/10 ms unchanged; ≤1 Hz/≤1% added | 150 mA | 160–225 mA | D1 ≥1 A, H10 26–28 AWG, 1 A rail | QER §§3.1/4/6 note; ICD-001 unchanged | ECO-008R; J10 test |
| Motor A | Same | 150 mA | 160–225 mA | P2/M1 ≥2 A, H02 24–26 AWG, 1.5 A rail | QER note; ICD-002 unchanged | ECO-008R; driver test |
| Motor B | Same | 150 mA | 160–225 mA | Same, H03 | Same | ECO-008R; driver test |

Original QER-01 values remain visible. QER-02 supersedes only the affected generic ceiling interpretation and completes peak repetition.

## 15. ICD Impact

No ICD amendment is required. J10 remains 100 mA continuous and 150 mA/10 ms. The 225 mA threshold describes fault tolerance upstream, not allowable accessory consumption. J6/J7, UI, relay, and unrelated branches are unaffected. Existing D1/P2 contact classes and wire gauges exceed the ceiling.

## 16. Prototype Evidence Plan

Test ≥3 controllers and ≥3 of each released load at 3.20/3.40 V or 4.75/5.25 V branch sources and −20/25/60 °C. Use a calibrated ≥1 MHz current probe or ≤1 Ω four-terminal shunt, ≥10 MHz analog bandwidth, and ≥1 MS/s capture. Trigger on enable; record ≥100 ms startup and ≥10 s steady behavior.

Record idle, mean, peak, time above 100 mA, output capacitance, rise, droop, fault assertion, retry, and temperature. Pass: ≤100 mA continuous; ≤150 mA for ≤10 ms at ≤1 Hz; rail above minimum; limit onset 160–225 mA at every corner; retry ≥100 ms or latch-off; no upstream collapse/damage. Include controlled-load and hard-short tests. Retain waveforms, calibration, article, firmware, wiring, and ambient records.

## 17. Implementation Handoff

| Branch | Disposition | Package |
|---|---|---|
| U209/R222 | C — retain TPS2553-Q1 after justified ceiling amendment; retain J10 optional/DNP | ECO-008R — TPS2553 RILIM Correction |
| U212/R223 | C — retain TPS2553-Q1 after justified ceiling amendment | ECO-008R |
| U213/R224 | C — retain TPS2553-Q1 after justified ceiling amendment | ECO-008R |

ECO-008R may calculate and implement independent RILIM values. It shall not change interfaces, ownership, load allocations, or connector contracts.

## 18. Remaining Risks

- Peak values are inherited allowances, not measurements.
- Exact loads and their absolute maxima/startup behavior are unselected.
- Exact TPS suffix, full-temperature distribution, thermal/retry and reverse-current behavior remain open.
- PCB copper, connector temperature rise, enclosure thermal behavior, and native ERC remain unverified.
- PPQ-02 and JCS-01 remain separate freeze gates.

## 19. Validation Results

- All six references and three branches are inventoried with waveforms and protected-element ceilings.
- Each has a positive 65 mA threshold and 5.562 kΩ feasibility window.
- Device/resistor tolerance, temperature, load/supply variation, capacitance, aging, measurement uncertainty, and prototype spread are identified.
- J10's 100 mA/150 mA contracts are preserved.
- No schematic, component selection, EBOM MPN, AVL approval, footprint, PCB, GPIO, hierarchy, ADR, or ICD changed.
- Repository validation and `git diff --check` pass at release.

## 20. Final Decision

# QER-02 ACCEPTED

**ECO-008R — TPS2553 RILIM Correction is authorized.** CSR-01A-R4 remains unauthorized until ECO-008R is complete and verified.
