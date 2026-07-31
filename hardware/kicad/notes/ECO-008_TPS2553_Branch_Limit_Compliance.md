# ECO-008 — TPS2553 Branch-Limit Compliance Correction

## 1. Scope

ECO-008 evaluated only U209/R222, U212/R223, and U213/R224 against the TPS2553-Q1 programming equations and QER-01 branch limits. The mandated legal-window test failed before schematic editing. No resistor, capacitor, topology, reference, footprint, PCB, hierarchy, GPIO, rail, connector, ADR, or ICD change was made.

Primary source: Texas Instruments TPS2553-Q1 datasheet SLVSBD0B, especially the 15–232 kΩ recommended RILIM range and current-limit programming equations. QER-01 and PPQ-01 control system requirements.

> **Post-ECO disposition — QER-02 (2026-07-31):** QER-02 accepted a 160–225 mA worst-case fault-threshold band while preserving the 100 mA continuous and 150 mA/10 ms load contracts. This closes the requirements conflict only. ECO-008 remains historically INCOMPLETE and unchanged; ECO-008R is authorized to implement and verify the correction. CSR-01A-R4 remains unauthorized.

## 2. PPQ-01 Finding

PPQ-01 found that the released 150 kΩ ±1% networks program approximately 154–209 mA. Each affected branch has a 100 mA continuous allocation, a 150 mA/10 ms peak allocation, and a QER-01 maximum current-limit ceiling of 150% continuous = 150 mA. The released networks support the peak but exceed the ceiling.

## 3. Affected Channel Inventory

| Device / RILIM | Sheet | Branch | Source / nominal | Continuous | Startup/peak | QER ceiling | Released min/nom/max | Excess over ceiling | Coordination |
|---|---|---|---:|---:|---:|---:|---:|---:|---|
| U209 / R222 | 02 | EXPANSION_VCC, optional/DNP | +3V3_CORE / 3.3 V | 100 mA | 150 mA/10 ms | 150 mA | 154/179/209 mA | 59 mA / 39.3% | 1 A core rail; ICD-001 100 mA continuous; branch off in USB-only/default DNP |
| U212 / R223 | 02 | MOTOR_LOGIC_5V_A | +5V_MAIN / 5 V | 100 mA | 150 mA/10 ms | 150 mA | 154/179/209 mA | 59 mA / 39.3% | 1.5 A main rail; external logic only; no motor current |
| U213 / R224 | 02 | MOTOR_LOGIC_5V_B | +5V_MAIN / 5 V | 100 mA | 150 mA/10 ms | 150 mA | 154/179/209 mA | 59 mA / 39.3% | Same as channel A |

The “six rows” are three IC rows plus their three independent RILIM resistor rows. TPS2553-Q1 is active-high, limits current, reports fault through its active-low open-drain output where used, and thermally protects/retries according to the selected device behavior. No RILIM is shared.

## 4. QER Limit Reconciliation

For every channel:

- minimum functional load limit: at least 100 mA continuous;
- required peak/startup support: 150 mA for 10 ms;
- therefore required programmed worst-case minimum: at least 150 mA if the peak must pass without limiting;
- maximum permitted programmed worst-case maximum: 150 mA.

The legal condition is `150 mA ≤ Imin ≤ Inom ≤ Imax ≤ 150 mA`. This has zero width and demands an ideal tolerance-free 150 mA limiter. TPS2553-Q1 has device and resistor variation, so the condition is impossible. This is a **load-budget/protection-ceiling inconsistency**, not merely a poor resistor choice.

## 5. Legal Current-Limit Windows

TI equations, R in kΩ and current in mA:

- high-bound equation: `Imax = 22980 / R^0.94`;
- nominal: `Inom = 23950 / R^0.977`;
- low-bound equation: `Imin = 25230 / R^1.016`.

To guarantee `Imax ≤150 mA`, actual R must be at least 211.224 kΩ. With ±1% resistor tolerance, nominal R must be at least **213.358 kΩ**.

To guarantee `Imin ≥150 mA`, actual R must be at most 155.158 kΩ. With ±1% tolerance, nominal R must be at most **153.622 kΩ**.

The required nominal intervals do not overlap: `Rnom ≥213.358 kΩ` and `Rnom ≤153.622 kΩ`. The gap is 59.736 kΩ. No legal RILIM exists, even though both endpoints lie within TI's 15–232 kΩ programming range.

## 6. RILIM Calculations

| RILIM nominal, ±1% | Worst minimum | Nominal | Worst maximum | Peak support | QER ceiling |
|---:|---:|---:|---:|---|---|
| 150 kΩ (released) | 153.7 mA | 179.2 mA | 208.9 mA | Pass | Fail |
| 175 kΩ | 131.4 mA | 154.1 mA | 180.7 mA | Fail worst case | Fail |
| 200 kΩ | 114.7 mA | 135.3 mA | 159.4 mA | Fail | Fail |
| 220 kΩ | 104.1 mA | 123.2 mA | 145.7 mA | Fail | Pass |
| 232 kΩ | 98.7 mA | 117.0 mA | 138.6 mA | Fail continuous at worst case | Pass |

Resistor voltage and power are microvolt/microwatt-class programming stresses and do not control feasibility. A preliminary electrical class would remain ±1%, ≤100 ppm/°C and one resistor per IC, but selecting a value is prohibited because the system window is infeasible.

## 7. Startup and Inrush Analysis

Branch-local output capacitance is approximately 4.7 µF per affected channel before downstream capacitance. Ideal charging time is `t=C·V/Iavailable` only after subtracting load current.

- At a 150 mA limit with a simultaneous 100 mA load, only 50 mA charges capacitance: about 0.31 ms at 3.3 V and 0.47 ms at 5 V for 4.7 µF.
- At a 145.7 mA maximum-compliant upper bound and 100 mA load, charge time is approximately 0.34 ms at 3.3 V and 0.51 ms at 5 V.
- These capacitor-only times are below the 0.2–10 ms branch-rise window, but they do not prove peripheral boot current below 150 mA.

The QER peak is an allocated load demand, not only capacitor inrush. Reducing capacitance or adding slew control cannot reconcile a 150 mA load peak with a hard 150 mA worst-case protection ceiling unless the qualified peak demand is reduced below the ceiling with explicit margin. Brownout/retry oscillation also requires exact device and load waveforms.

## 8. Thermal and Fault Analysis

Released normal switch loss cannot be finalized without exact RON, but at 100 mA it is low compared with short-circuit loss. At the released worst maximum 209 mA, a hard short initially exposes approximately 0.69 W from 3.3 V or 1.05 W from 5 V before thermal regulation/retry. A maximum-compliant 150 mA limit would reduce those upper bounds to 0.50 W and 0.75 W.

Lowering the limit near normal/peak demand increases the risk of prolonged constant-current startup and repeated thermal cycling. No exact junction rise is claimed without package/copper and retry timing. Maximum upstream energy remains bounded by the upstream rail and protection, but branch survival requires exact-part transient thermal/prototype evidence.

## 9. Upstream/Downstream Coordination

All candidate current limits are below the 1.0 A core and 1.5 A main rail allocations and far below the 2 A input protection basis. The controlling conflict is downstream QER branch allocation, not upstream capacity. The expansion branch remains optional/DNP and disabled in USB-only operation; motor-logic branches remain main-only. Connector contracts, conductor classes, rail ownership and branch ownership are unchanged.

## 10. Schematic Changes

None. The ECO stop condition was triggered by the empty legal window. R222/R223/R224 remain at the released 150 kΩ value solely to preserve the controlled baseline; this is not a compliance endorsement. U209/U212/U213 and their resistors remain blocked.

## 11. EBOM/AVL Reconciliation

No physical or generic value changed, so the canonical EBOM/AVL require no content change. The six affected rows remain `BLOCKED` for CSR-01A-R4. Existing frozen rows are preserved. CSV/XLSX artifacts remain synchronized at the PPQ-01 baseline.

## 12. Validation Results

- Exactly three TPS2553-Q1 devices and three independent RILIM resistors identified.
- Each resistor is independent, connected to its own ILIM net, and within TI's legal 15–232 kΩ range.
- Worst-case min/nom/max calculations independently reproduced.
- Mathematical infeasibility proven: 213.358 kΩ minimum nominal for ceiling versus 153.622 kΩ maximum nominal for peak support.
- No RILIM value forced; no schematic, hierarchy, GPIO, connector, ADR, ICD, footprint or PCB change.
- Repository validators and `git diff --check` pass at release.

## 13. Native ERC Status

`kicad-cli` is unavailable in the ECO environment. Native ERC remains **PENDING**. Since no schematic changed, ECO-008 introduces no new ERC delta.

## 14. Remaining Power Evidence Gaps

The smallest required follow-up is **QER-02 — Branch Peak and Protection Ceiling Reconciliation**. It must choose one controlled resolution:

1. qualify a lower branch peak/inrush requirement with adequate margin;
2. revise the protection ceiling while preserving downstream conductor/connector and upstream coordination; or
3. require a different current-limiter architecture and define a nonzero legal tolerance window.

After QER-02, a narrow implementation ECO may select revised RILIM values or another limiter. PPQ-02 and JCS-01 remain open. CSR-01A-R4 and CSR-01B remain unauthorized.

## 15. Manual Review Checklist

- [x] Six rows and three branches inventoried
- [x] Official TPS2553-Q1 equations and legal range applied
- [x] Resistor and device tolerance included
- [x] Startup, capacitor charging, fault and thermal consequences reviewed
- [x] Upstream/downstream and USB-only behavior preserved
- [x] Empty legal window proven
- [x] No invalid resistor selected
- [x] No prohibited design change
- [ ] QER-02 requirement reconciliation
- [ ] Native ERC when tooling is available

## Final Decision

# ECO-008 INCOMPLETE

CSR-01A-R4 is not authorized. Required next package: **QER-02 — Branch Peak and Protection Ceiling Reconciliation**.
