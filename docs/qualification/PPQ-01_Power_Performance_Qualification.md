# PPQ-01 — Power Performance Qualification

| Field | Value |
|---|---|
| Platform | IPC-100 Rev A |
| Baseline | PEB-01 commit `b1e2ab9` |
| Date | 2026-07-31 |
| Qualification type | Analytical, package-independent |
| Component selection | None |
| Design changes | None |

> **QER-02 disposition (2026-07-31):** The six-row TPS2553 finding is requirements-reconciled. Loads retain 100 mA continuous and 150 mA/10 ms transient contracts; their limiter now has a 160–225 mA worst-case fault-threshold band. ECO-008R is required before these rows become freeze-eligible or CSR-01A-R4 is authorized.

## 1. Executive summary

PPQ-01 independently evaluates the PEB-01 envelopes across the released electrical corners and converts them into reproducible qualification calculations, pass/fail limits, and physical-test records. It does not claim that unbuilt hardware has been measured. Analytical results are **VERIFIED** where two independently evaluated equations reproduce the released limit; exact-part curves and hardware behavior are explicitly **OPEN — selection** or **OPEN — prototype**.

The qualification supports 50 currently blocked RC-A/RC-B references entering exact component evaluation in CSR-01A-R4. Six TPS2553 device/RILIM rows fail the branch-limit screen and require narrow remediation. The other 68 references remain outside this package: 67 dependent passives require PPQ-02 and J1 requires JCS-01.

## 2. Controlled evidence set

- [Power Load Model](Power_Load_Model.md)
- [Power Thermal Model](Power_Thermal_Model.md)
- [Power Stress Model](Power_Stress_Model.md)
- [Power Protection Model](Power_Protection_Model.md)
- [Qualification Evidence Register](Qualification_Evidence_Register.md)
- PEB-01 and QER-01 remain controlling inputs.

Evidence confidence:

| Level | Meaning |
|---|---|
| High | Direct QER limit or algebraic result with no part-specific parameter |
| Medium | Conservative parameter envelope suitable for candidate screening |
| Low | Engineering estimate retained only to define a future measurement |

## 3. Complete operating-corner matrix

| Corner | Input/source | Load | Temperature | Governing risk | Qualification result |
|---|---|---|---|---|---|
| Low-line continuous | 9.0 V | 7.5 W 5 V allocation | +75°C internal air | input current, dropout, heating | 0.980 A calculated at 85%; 21.6% below 1.25 A limit — PASS envelope |
| High-line continuous | 21.0 V | 7.5 W | +75°C | switch loss, ripple, voltage stress | 0.635 A inductor ripple; ≤55 V protection envelope — PASS candidate screen |
| Nominal typical | 18 V | 2.35 W approximate 5 V demand | +25°C | efficiency/idle targets | 0.154 A input at 85%; exact efficiency remains selection evidence |
| Cold start | 9.0 V | branches off, core start | −20°C | UVLO/startup/inrush | ≤4 A/10 ms and monotonic timing are defined; waveform OPEN — prototype |
| Hot maximum | 9/21 V | simultaneous released maximum | +60°C ambient/+75°C air | junction/copper | main θJA≤26.4°C/W; core≤60.1°C/W — PASS screening constraint |
| Brownout falling | 8.5 V threshold | any released state | temperature extremes | deterministic shutdown | authorization removal required; threshold/timing OPEN — exact device/prototype |
| Restart | ≥9.0 V rising | branches default off | temperature extremes | chatter/start pulse | ≥0.5 V input hysteresis required — PASS requirement, waveform OPEN |
| USB-only | 4.40 V, 0.50 A | core only | +75°C air | host current/backfeed | ≤0.55 A recommended 3.3 V load cap; main-only branches must remain off |
| Dual source | valid main + USB | core transition | all | cross-current/droop | reverse current prohibited; 47 µF cannot provide 2 ms hold-up; selector waveform must prove ≥3.0 V |
| Surge | +40 V/100 ms/2 Ω | safe shutdown permitted | hot/cold | TVS/eFuse/SOA | common stress equations complete; exact curves and bench pulse OPEN |
| Reverse | −24 V/60 s, 2 A limit | off | hot/cold | Q101 leakage/SOA | ≤1 mA and no rail energy required; exact device/prototype OPEN |

## 4. Input power, battery tolerance and brownout

At the maximum 7.5 W 5 V allocation and 85% efficiency, input power is 8.824 W. Input current is 0.980 A at 9 V, 0.490 A at 18 V and 0.420 A at 21 V. The low-line case controls conductor and fuse continuous current. The 1.25 A board limit has 0.270 A margin.

At 8.5 V falling, the same hypothetical load would require 1.038 A, but outputs must be deauthorized rather than guaranteed through the invalid range. Restart at 9.0 V produces 0.5 V/5.7% hysteresis. U204/U205 exact tolerance must keep falling ≤8.5 V and rising ≥9.0 V; bench ramps at 0.1, 1 and 10 V/s are required.

Confidence: High for power/current algebra; Medium for threshold screening; physical thresholds remain prototype evidence.

## 5. Startup and inrush

The captured raw/input bulk nominal capacitance is approximately 46.4 µF (`C101/C102/C103/C104/C109/C201` nominal classes). At 21 V it stores about 10.2 mJ and requires 0.974 mC charge. QER permits 4 A for 10 ms, or 40 mC, so stored charge alone uses 2.4% of the allowed charge impulse. A 0.10 Ω source cannot passively enforce the current limit; U101/U102/gate dynamics must control it.

For a 50 ms 5 V rise into 30 µF effective output capacitance, capacitor charging current is only 3 mA; load startup and control-loop behavior dominate. For a 20 ms core rise into 30 µF effective, capacitor charging is approximately 5 mA. Qualification requires monotonic rise, <5% overshoot, all controlled branches initially off, and no authorization pulse.

## 6. Continuous and peak current

> **ECO-008 disposition:** The TPS2553/QER observation below is confirmed as an infeasible zero-width legal window. No compliant RILIM exists. ECO-008 made no schematic change and requires QER-02 before CSR-01A-R4.

The simultaneous continuous model yields 1.00 A at 3.3 V, 470 mA direct at 5 V and 1.246 A total at +5V_MAIN. Margins are 0% to the deliberately enforced 3.3 V allocation and 254 mA/16.9% to the 1.50 A 5 V allocation. Peak limits remain 1.5 A/100 ms on 3.3 V, 2 A/100 ms on 5 V, and 2 A/100 ms at the board input.

Branch TPS2553-Q1 networks calculate 154–209 mA. This passes a 150 mA/10 ms peak screen but the 209 mA upper bound is 209% of a 100 mA continuous branch and exceeds QER §6's generic 150% maximum. This is a **qualification observation**: exact-device tolerance or branch-specific interpretation must be resolved during CSR-01A-R4; PPQ-01 does not alter the schematic.

## 7. Regulator efficiency and dissipation

The qualification floor matrix is:

| Load fraction | Output power | Efficiency floor | Main loss | Input at 9 V |
|---:|---:|---:|---:|---:|
| 10% | 0.75 W | 75% | 0.250 W | 0.111 A |
| 25% | 1.875 W | 85% | 0.331 W | 0.245 A |
| 50% | 3.750 W | 85% | 0.662 W | 0.490 A |
| 100% | 7.500 W | 85% | 1.324 W | 0.980 A |

For the core converter at 3.3 W/85%, loss is 0.582 W and minimum-source input current is 0.882 A at 4.40 V. Exact curves at 9/18/21 V and 10/25/50/75/100% load remain CSR exact-part evidence; the selected part must meet or exceed this floor.

## 8. Thermal and copper qualification

With +75°C internal air and `TJ≤110°C`, U201 requires effective θJA≤26.4°C/W at 1.324 W, and the core regulator requires ≤60.1°C/W at 0.582 W. No airflow is credited. The selected U201 implementation must use a four-layer board, exposed-pad copper, and thermal vias consistent with manufacturer guidance. A candidate that requires forced air or an undefined external heat sink is ineligible.

The combined conversion loss is 1.906 W before protection, magnetics and branch losses. Enclosure rise must remain ≤15°C over +60°C external ambient. Required physical record: closed representative enclosure, 9 and 21 V, maximum load, stabilized temperature, thermocouple/IR correlation, measured critical junction target ≤100°C.

## 9. Capacitor effective value and ripple

The main output requires ≥30 µF effective total. At 21 V with 0.635 A inductor ripple, ideal capacitive ripple is 6.6 mV. Combined ESR must be ≤68 mΩ to leave the 50 mV total limit before control/noise allocation. Main input ideal RMS current is 0.639 A, requiring ≥0.959 A hot network ripple rating under the 1.5× QER rule.

The captured 47 µF transition reservoir stores only about 44 µJ between 3.3 and 3.0 V; 2 ms at 1 A needs about 6.3 mJ. It cannot be credited for hold-up. Exact DC-bias, aging, ripple and ESR curves remain PPQ-02.

## 10. MOSFET SOA and switching stress

Q101's ≤100 mV drop at 1.25 A requires ≤80 mΩ hot total RDS(on). The captured ≤25 mΩ class predicts 39 mW continuous and 100 mW at 2 A. An 80 V device at the 55 V clamp has 68.8% utilization. Static reverse protection has negligible periodic switching loss; connection, surge and reverse events are evaluated on manufacturer SOA with ≥2× current-time or energy margin. Exact SOA/avalanche/leakage curves remain selection evidence.

## 11. Protection coordination and timing

F101 must carry 1.25 A at 75°C, pass 4 A/10 ms, and clear 10 A within 5 s. D101 must have ≥24 V standoff, ≤55 V worst clamp, and ≥2× integrated energy margin. U101/U102 current-limit total tolerance must be 1.5–2.5 A and must not disable short protection during startup blanking. Reverse polarity is −24 V/60 s with ≤1 mA leakage. All short/retry behavior must keep the core safe and require ≥100 ms retry or controlled latch recovery.

Exact curves cannot be qualified without exact parts; PPQ-01 supplies the calculation sheet and physical pulse matrix that CSR candidates must pass.

## 12. Supervisor thresholds and sequencing

U801 nominal external thresholds are 2.930 V rising and 2.680 V falling, giving 250 mV nominal hysteresis and a 10 ms validation delay. The expansion segment is therefore below its 3.0 V released minimum while disabled and cannot enable on an unqualified ramp. Exact threshold/hysteresis/delay tolerances and VOH/leakage must be applied in CSR-01A-R4.

Sequence invariants:

1. main-only branches remain off during USB-only operation;
2. source selection cannot cross-power either source;
3. `+3V3_CORE` remains ≥3.0 V during valid-source transition;
4. power-good asserts only after ≥5 ms valid and deasserts within 1 ms invalid;
5. authorization falls before actuator logic becomes undefined.

## 13. Evidence disposition

PPQ-01 produces reproducible qualification evidence for the 19 RC-A protection references and 37 RC-B active/dependent references. Fifty are expected to become **eligible for exact FREEZE evaluation**, not automatically frozen. U209/U212/U213 and R222/R223/R224 remain ineligible because their 209 mA worst-case limit exceeds the 150 mA QER ceiling. The evidence register marks confidence and remaining work individually.

PPQ-02 is required for 67 exact passive references, and JCS-01 remains required for J1. **ECO-008 — Branch Current-Limit Compliance Remediation** is required before CSR-01A-R4 to reconcile the TPS2553 tolerance window with QER-01 without silently changing either requirement or schematic.

## 14. Validation

- Independent scripts reproduce the load, loss, thermal, ripple, inrush, hold-up, SOA-screen and USB-only calculations.
- Every blocked reference appears exactly once in the qualification evidence register.
- Exactly 50 references are marked eligible for CSR-01A-R4 evaluation; the six TPS2553/RILIM rows are explicitly ineligible.
- No measured result, manufacturer curve, MPN, lifecycle, source or price is invented.
- No schematic, architecture, GPIO, hierarchy, connector contract, footprint, PCB, ADR or ICD changes are made.
- Repository validators and `git diff --check` pass.

## Final Decision

# PPQ-01 COMPLETE

Expected to become FREEZE eligible for CSR-01A-R4 evaluation: **50 currently blocked references**.

Required before CSR-01A-R4: **ECO-008 — Branch Current-Limit Compliance Remediation**. PPQ-02 and JCS-01 remain subsequent/parallel closure packages.
