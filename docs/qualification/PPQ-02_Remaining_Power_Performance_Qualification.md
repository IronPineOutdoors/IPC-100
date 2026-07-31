# PPQ-02 — Remaining Power Performance Qualification

| Field | Value |
|---|---|
| Platform | IPC-100 Rev A |
| Baseline | CSR-01A-R4 commit `3e79495` |
| Date | 2026-07-31 |
| Type | Package-independent analytical evidence |
| Component / footprint / CAD changes | None |

## 1. Executive Summary

PPQ-02 closes the shared calculations needed to select the remaining 124 blocked power references. It does not claim exact-part, manufacturer-curve, commercial, PCB, or prototype evidence. The package produces bounded operating, regulator, thermal, magnetics, capacitor, switch, protection, timing, shared-rail, PCB-constraint and single-fault envelopes.

All 124 rows are mapped once: 19 protection/transient rows route to PPC-01, 104 active/dependent rows route to PAS-01, and J1 routes to JCS-01. Zero rows are directly ready for CSR-01A-R5 because exact order-code, lifecycle, sourcing, alternate and price evidence remain downstream work. CSR-01A-R5 is not authorized.

## 2. Controlled Inputs and Non-Duplication

QER-01/QER-02 control requirements. PEB-01 supplies load and package-independent models; PPQ-01 supplies the first corner/stress qualification; ECO-006/007/008R control implementation. PPQ-02 extends those records only where CSR-01A-R4 identified missing shared envelopes. It preserves the 141 kΩ TPS2553 implementation and 162.82–222.35 mA range.

## 3. Blocked-Row Evidence Map

[Power Component Evidence Register](Power_Component_Evidence_Register.md) is the normative 124-row mapping. Shared dependency groups are:

| Group | Count | PPQ-02 evidence | Next package |
|---|---:|---|---|
| RC-A protection/transient | 19 | Energy, clamp, SOA, fault-time and coordination envelopes | PPC-01 |
| RC-B active stages | 37 | Operating corners, loss/thermal, threshold, switch and PCB constraints | PAS-01 |
| RC-C dependent passives | 67 | Effective-capacitance, ripple, magnetics, tolerance/pulse and timing envelopes | PAS-01 |
| RC-D J1 | 1 | Current/transient/environment envelope retained | JCS-01 |

## 4. Operating-State Closure

[Power Operating State Matrix](Power_Operating_State_Matrix.md) evaluates no-power, battery, USB, dual-source, brownout, recovery, reset/watchdog, maximum load, actuation and fault states. The controlling continuous point is 1.00 A on 3.3 V and 1.246 A equivalent on 5 V. The conservative converter allocation remains 7.5 W/1.50 A. USB-only is screened at 550 mA core output with every main-only branch off.

## 5. Regulator and Source-Selection Closure

[Power Regulator Corner Analysis](Power_Regulator_Corner_Analysis.md) establishes exact selection envelopes. U201 must support 9–21 V normal, 40 V/100 ms survival strategy, 5 V/1.5 A continuous and 2 A/100 ms, 400 kHz, ≥85% efficiency at 25–100% load, ≤1.324 W modeled loss, effective θJA ≤26.4 °C/W, and the released startup/ripple limits. Core conversion must support 4.4–5.25 V input, 3.3 V/1 A, 1.5 A/100 ms, ≤0.582 W modeled loss and θJA ≤60.1 °C/W.

## 6. Thermal Closure

[Power Thermal Model](Power_Thermal_Model.md) now includes PPQ-02 component-class constraints. +60 °C ambient, +75 °C enclosure air, natural convection and no neighboring-heat credit control. Design TJ is ≤110 °C even when a candidate absolute maximum is higher. Exact package/copper correlation remains PAS-01 and prototype evidence.

## 7. Magnetics and Capacitors

[Power Magnetics Requirements](Power_Magnetics_Requirements.md) defines ripple, RMS/peak, saturation, DCR/loss and temperature envelopes. [Power Capacitor Requirements](Power_Capacitor_Requirements.md) distinguishes stability-critical, bulk, transient, decoupling and timing functions and defines minimum effective value, voltage, ESR/ripple, aging/life and inrush limits. Exact manufacturer curves remain PAS-01 selection evidence.

## 8. MOSFET, Switch and Protection Closure

[Power MOSFET Stress Model](Power_MOSFET_Stress_Model.md) provides voltage/current/RDS(on)/SOA/leakage/thermal requirements. [Power Protection Energy Model](Power_Protection_Energy_Model.md) gives parametric fuse/TVS/eFuse/reverse-stage coordination. It explicitly forbids crediting a 55 V TVS clamp against a 40 V open-circuit pulse without proving actual conduction.

## 9. Threshold, Timing and Shared Rails

[Power Threshold and Timing Model](Power_Threshold_and_Timing_Model.md) freezes calculation methods and acceptance windows without selecting supervisors. [Power Shared Rail Analysis](Power_Shared_Rail_Analysis.md) confirms accepted concurrency and identifies no new firmware restriction. Request-controlled branches remain off during reset, bootloader, USB-only and invalid main power.

## 10. PCB and Reliability Constraints

[Power PCB Constraint Register](Power_PCB_Constraint_Register.md) converts electrical/thermal dependencies into future layout rules without assigning footprints. [Power Single-Fault Evidence](Power_Single_Fault_Evidence.md) records immediate effect, containment, detection and test needs for the required single faults. No formal functional-safety certification is claimed.

## 11. Evidence Confidence

| Confidence | Use |
|---|---|
| HIGH | QER boundary or manufacturer equation evaluated without an exact-part assumption |
| MEDIUM | Conservative package-independent model with controlled PCB/environment assumptions |
| LOW | Estimate requiring prototype waveform/thermal correlation |
| BLOCKED | Exact order-code, manufacturer curve, package, commercial or mechanical input absent |

Low evidence uses ≥3 controller articles and ≥3 load/component samples at relevant low/nominal/high voltage and −20/25/60 °C ambient. Instruments must have calibration records; transient captures use ≥1 MS/s and ≥10 MHz analog bandwidth unless the event requires more. Exact pass/fail limits are in the appendices.

## 12. Requirement Traceability

Every appendix cites QER-01 or QER-02 limits and the evidence register assigns a next package. No numeric requirement is broadened. No new analysis conflicts with accepted architecture or interface contracts.

## 13. Eligibility After PPQ-02

| Route | References | Status after PPQ-02 |
|---|---:|---|
| READY FOR PPC-01 | 19 | Protection selection envelope complete |
| READY FOR PAS-01 | 104 | Active/passive selection envelope complete |
| READY FOR JCS-01 | 1 | MIR/QER envelope complete; exact system required |
| READY FOR CSR-01A-R5 directly | 0 | Exact/commercial evidence absent |
| REQUIRES PROTOTYPE EVIDENCE | 56 | Cross-cutting subset; does not prevent candidate selection but prevents final release |
| REMAINS BLOCKED analytically | 0 | All shared analytical dependencies have a disposition |

Routing counts are mutually exclusive for 19/104/1. Prototype count is cross-cutting and must not be added to 124.

## 14. Remaining Dependencies and Handoff

- **PAS-01** has the highest unblock value: 104 rows. It shall select exact active stages and their dependent passives against these envelopes, including manufacturer curves, packages, lifecycle, sourcing, alternates and prices.
- **PPC-01** shall select and coordinate 19 protection rows.
- **JCS-01** shall select the complete J1 system.
- Prototype DV shall close the 56 cross-cutting waveform/thermal/fault observations before release.

## 15. Validation

- All 124 blocked references appear exactly once in the generated register.
- Route totals are 19 + 104 + 1 = 124.
- QER-02 branches remain 141 kΩ and 162.82–222.35 mA.
- No MPN, AVL approval, schematic, footprint, PCB, GPIO, hierarchy, ADR, ICD or connector contract changed.
- Repository regressions and `git diff --check` pass.
- Native ERC is not required because no schematic changes occur.

## Final Decision

# PPQ-02 COMPLETE

Newly ready for PPC-01: **19**. Newly ready for PAS-01: **104**. Newly ready for JCS-01: **1**. Directly ready for CSR-01A-R5: **0**. Cross-cutting references still requiring prototype evidence: **56**. Remaining analytically blocked: **0**.

Recommended next package: **PAS-01 — Power Active and Dependent-Passive Exact Selection**. CSR-01A-R5 remains unauthorized until PAS-01, PPC-01 and JCS-01 are complete and verified.
