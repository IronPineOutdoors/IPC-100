# PEB-01 — Power Evidence Baseline & Analytical Closure

| Field | Value |
|---|---|
| Platform | IPC-100 Rev A |
| Baseline | DRA-01 commit `b173b9b` |
| Date | 2026-07-31 |
| Purpose | Package-independent evidence for later component selection |
| Design changes | None |

## 1. Scope and method

PEB-01 converts QER-01 limits and released schematic values into a controlled calculation baseline. It does not select MPNs or packages. Each result is tagged:

- **Measured** — laboratory evidence; none is claimed in PEB-01.
- **Calculated** — equation evaluated from released limits.
- **Manufacturer Datasheet** — parameter/equation from the named device family documentation.
- **Engineering Estimate** — bounded planning value pending exact-part data.
- **Prototype Required** — physical evidence cannot exist before hardware.

The appendices are normative PEB-01 evidence:

- [Power Load Budget](Power_Load_Budget.md)
- [Power Thermal Analysis](Power_Thermal_Analysis.md)
- [Power Protection Coordination](Power_Protection_Coordination.md)
- [Power Derating Matrix](Power_Derating_Matrix.md)
- [Power Component Evidence Register](Power_Component_Evidence_Register.md)

## 2. Controlled assumptions

| ID | Assumption / limit | Classification | Source | Confidence |
|---|---|---|---|---|
| A-01 | 9–21 V normal input; 18 V nominal | Manufacturer-independent requirement | QER-01 §2 | High |
| A-02 | −20…+60°C external ambient; +75°C maximum enclosure air | Manufacturer-independent requirement | QER-01 §2 | High |
| A-03 | Natural convection; no credited forced airflow | Engineering Estimate | Conservative product assumption | Medium |
| A-04 | Four-layer PCB is the analytical basis for exposed-pad regulators; copper/vias must meet the selected-device thermal envelope | Engineering Estimate | LMR38020-Q1 layout guidance; QER derating | Medium |
| A-05 | Converter efficiency is 85% at 25–100% released load and 75% at 10% load until exact curves are selected | Engineering Estimate / requirement floor | QER-01 §§3,11 | High for sizing, low for prediction |
| A-06 | Optional J10 is DNP, or another nonessential branch is limited, whenever individual 3.3 V maxima would exceed 1.00 A simultaneous | Calculated requirement | QER-01 §4 | High |
| A-07 | Harness cases are 1 m/0.10 Ω minimum for connection and 2 Ω for +40 V surge | Manufacturer-independent requirement | QER-01 §5 | High |
| A-08 | No main-only hold-up; core 2 ms/1 A/3.3→3.0 V must be met by source transition, not the captured 47 µF reservoir | Calculated | QER-01 §3; `C=It/ΔV` | High |
| A-09 | Exact semiconductor θ values, passive bias curves, efficiency curves, MTBF and stock data are intentionally unavailable before selection | Prototype Required / selection required | DRA-01 | High |

No result below substitutes an estimate for measured evidence.

## 3. Load analytical closure

The released branch allocations produce:

| State | 3.3 V loads | Direct 5 V loads | Core input at 85% | Total +5V_MAIN demand |
|---|---:|---:|---:|---:|
| Idle allocation | 50 mA | 6 mA | 38.8 mA | 44.8 mA |
| Typical planning | 277 mA | 255 mA | 215 mA | 470 mA |
| Simultaneous continuous limit | 1.00 A | 470 mA | 776 mA | 1.246 A |

The maximum is below the 1.50 A `+5V_MAIN` allocation by 254 mA (16.9%). At 7.5 W output and 85% efficiency, 9 V input current is 0.980 A, below the 1.25 A controller limit by 0.270 A (21.6% of the limit; 27.5% relative to calculated draw). All typical and idle values remain **Engineering Estimates** until QER-V01 measurement.

## 4. Main regulator operating envelope

Affected references: U201, R201, L201/L202, C201–C205 and the upstream input network. Rail: `VIN_PROTECTED → +5V_MAIN`. QER trace: §§2–7, 10–11.

- `fSW = 400 kHz` and `R201 = 64.9 kΩ` are Manufacturer Datasheet/ECO-007 values.
- Duty estimate `D=VOUT/VIN`: 0.556 at 9 V and 0.238 at 21 V.
- At 7.5 W output and 85% efficiency, loss is `7.5/0.85−7.5 = 1.324 W`.
- At 10% output and the 75% efficiency floor, loss is `0.75/0.75−0.75 = 0.250 W`.
- With +75°C air and QER `TJ≤110°C`, the package/board combination must provide effective `θJA≤(110−75)/1.324 = 26.4°C/W` at maximum continuous load.
- Startup must be monotonic within 50 ms; overshoot <5%; current-limit and soft-start tolerance remain exact-suffix selection inputs.

Confidence is High for the required envelope and Medium for dissipation because 85% is a compliance floor, not a selected-device curve. Exact efficiency and loop results remain Manufacturer Datasheet/vendor-tool evidence during selection; prototype load-step/startup/brownout correlation remains required.

## 5. Core regulator operating envelope

Affected references: U202/U203 and C206–C210. Rail: `CORE_SOURCE → +3V3_CORE`. QER trace: §§3–4, 10–11.

- Maximum output is 3.30 W at 1.00 A.
- At 85% efficiency, input power is 3.882 W, input current is 0.882 A at the minimum 4.40 V source, and loss is 0.582 W.
- Required effective thermal resistance at +75°C air is `θJA≤35/0.582 = 60.1°C/W`.
- The 47 µF reservoir stores only approximately `½C(3.3²−3.0²)=44 µJ`; the 2 ms/1 A ride-through needs about 6.3 mJ. Therefore source-selector transition performance, not this capacitor, must close QER hold-up.

Exact regulator/source-selector efficiency, dropout, reverse current, loop stability and transition waveform remain selection/prototype evidence.

## 6. Inductor evidence

For a 15 µH main inductor at 400 kHz, `ΔIL=(VIN−VOUT)D/(Lf)`:

- 9 V: 0.370 A peak-to-peak;
- 21 V: 0.635 A peak-to-peak (worst ripple);
- at 1.50 A continuous, worst peak is 1.818 A and RMS is `sqrt(I²+Δ²/12)=1.511 A`;
- QER requires minimum hot saturation current ≥2.273 A and RMS rating ≥1.813 A;
- a conservative 100 mΩ hot-DCR ceiling would dissipate 0.228 W and must still meet ≤30°C rise.

The 100 mΩ ceiling is an Engineering Estimate for candidate screening, not an approved value. Exact DCR/core-loss curves and temperature rise are selection evidence; hot load correlation is Prototype Required.

## 7. Capacitor evidence

Critical capacitor rules are released in the derating appendix. For the main buck at 21 V/1.5 A, ideal switch-input RMS current is `IOUT·sqrt(D(1−D)) = 0.639 A`; the selected input capacitor network must have at least 0.959 A hot ripple rating under QER's 1.5× rule. With two output capacitors each providing ≥15 µF effective (30 µF total), capacitive ripple is approximately `ΔIL/(8fC)=6.6 mV`; to keep total below 50 mV, combined effective ESR must be ≤68 mΩ before allocation for control ripple and measurement uncertainty.

Ceramic steady voltage utilization is ≤50%; low-voltage effective capacitance is ≥70% of regulator minimum; raw-input ceramics must remain above the coordinated clamp. Exact manufacturer DC-bias, ripple/ESR and aging curves remain PPQ-01 evidence. Bulk lifetime uses `L2=L1·2^((T1−T2)/10)` only where the manufacturer permits the 10°C rule.

## 8. MOSFET evidence

Q101 reverse-path targets derive from QER-01:

- forward loss ≤100 mV at 1.25 A implies total hot `RDS(on)≤80 mΩ`;
- the captured ≤25 mΩ class gives 31.3 mV/39 mW at 1.25 A and 100 mW at 2 A;
- ≥80 V VDS gives 68.8% utilization at the 55 V maximum coordinated clamp, within the 80% steady policy;
- ±20 V VGS and the actual gate clamp must be checked together;
- every startup/fault pulse requires ≥2× SOA energy/current-time margin.

Switching loss is negligible for static reverse protection except during connection/transient edges, which are evaluated as SOA rather than periodic switching. Exact hot RDS(on), SOA, avalanche and leakage curves remain selection evidence; reverse and surge testing is Prototype Required.

## 9. Protection coordination closure

The controlled stress ladder is:

`source/harness → F101 → D101/Q101/U101/U102 → VIN_PROTECTED → U201 (80 V class) → downstream rails`.

The +40 V/100 ms source has 2 Ω impedance and is below the required ≤55 V clamp ceiling. The input TVS must have ≥24 V standoff, survive any tolerance-defined conduction with ≥2× energy margin, and never allow >55 V downstream. The eFuse/OV stage must tolerate 30 V for 60 s and bound current to 1.5–2.5 A. Q101 must block −24 V/60 s with ≤1 mA reverse leakage. F101 must carry 1.25 A at 75°C, pass 4 A/10 ms inrush, and clear 10 A within 5 s before conductor damage.

These equations close the common selection envelope, not individual MPNs. Exact TVS dynamic resistance, fuse curves, eFuse SOA/retry, PCB trace clearing limit and bench pulses remain selection/prototype evidence.

## 10. Thermal boundary and reliability

Natural convection and +75°C internal air are the uncredited worst case. Combined main/core conversion loss at maximum allocation is approximately 1.906 W before protection, branch-switch, magnetics and passive loss. Local board rise must remain ≤35°C, critical calculated junction ≤110°C, and measured junction target ≤100°C. Candidate screening shall reject any device whose datasheet layout cannot meet the calculated θ envelope with a practical four-layer board and no airflow.

Mission life is 10 years/5,000 powered hours. Exact BOM-based MTBF cannot be calculated before component freeze and is explicitly Prototype/selection Required. Single-point review remains architectural: open/short protection faults must not energize an actuator; power loss must deauthorize outputs; failed optional branches must not collapse the core.

## 11. Evidence coverage and disposition forecast

PEB-01 supplies common quantitative evidence for DRA root causes RC-A (19 rows) and RC-B (37 rows): **56 of 124 blocked rows, or 45.2%, should become eligible for exact freeze evaluation in a future CSR**, subject to manufacturer/order-code evidence and identified prototype gates. It also supplies the requirements needed to start RC-C, but does not itself qualify 67 exact passives. J1 remains outside PEB-01.

Because 45.2% is below 80%, do **not** proceed directly to CSR-01A-R4. The next smallest package is **PPQ-01 — Power Passive Qualification**; **JCS-01 — J1 Connector System Definition** may proceed in parallel. After both close, all 124 rows should be eligible for final selection review unless an exact-part incompatibility triggers a narrow ECO.

## 12. Validation and limitations

- Every calculation identifies rail/references, QER source, equation, assumption class, margin and confidence in this document or an appendix.
- Every blocked power reference appears exactly once in the evidence register.
- No measurement, efficiency curve, θ value, DC-bias curve, MTBF or commercial fact is fabricated.
- No schematic, PCB, footprint, GPIO, hierarchy, ADR or ICD change is made.
- Repository validators and `git diff --check` are required at release.

## Final Decision

# PEB-01 COMPLETE

Estimated currently blocked rows eligible for freeze evaluation after PEB-01: **56 of 124 (45.2%)**.

Required before CSR-01A-R4: **PPQ-01 — Power Passive Qualification**, with **JCS-01 — J1 Connector System Definition** in parallel.
