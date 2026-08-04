# QER-04 — Safety Comparator Input-Range and Threshold Implementation

| Field | Value |
| --- | --- |
| Platform | IPC-100 Rev A engineering prototype path |
| Date | 2026-08-03 |
| Scope | Sheet 04 requirements and implementation architecture only |
| CAD / footprint / PCB change | None |
| Controlling interface | ADR-042 and External Safety Interface Control Document |

> **Implementation status (2026-08-04):** ECO-011A1R implements this architecture with exact TLV7044QPWRQ1, SN74LVC08AQPWRQ1, SN74LVC14AQPWRQ1 and SN74LVC1G17QDBVRQ1 devices, explicit passives and package units. The accepted QER decision and external contract are unchanged.

## 1. Executive Summary

QER-04 replaces the invalid LM339B-Q1 direct-input assumption with a guaranteed-range architecture. ECO-011A1R shall use three quad **TLV7044-Q1-class** automotive, rail-to-rail-input, open-drain comparators powered by the existing main-only `FIELD_SENSE_VCC`; no input divider is used. The comparator's guaranteed common-mode range is ground through `VCC + 0.1 V`, so a sense input produced by the same field rail remains valid from short (ground) through open (field rail). Its 1.6–6.5 V supply range, –40 to +125 °C rating, power-on reset, internal hysteresis and open-drain outputs are compatible with the released environment and 3.3 V logic interface.

The five window channels use ten comparators. Each pair is wired to a common active-low `WINDOW_OK_N` node: either low or high fault sinks the node. `FIELD_OK` is combined in 3.3 V logic, and an inverting Schmitt stage produces active-high `ASSERTED`/`FAULT`; STOP also drives `STOP_HW_INHIBIT`. Two remaining comparators receive ARM/FIRE; their active-high requests are AND-qualified by `FIELD_OK`. Three comparator packages, two quad AND packages and one hex Schmitt inverter package provide all channels. This is a preliminary physical allocation, not reference, suffix, or footprint assignment.

ADR-042 and the ICD remain unchanged. ECO-011A1R alone is authorized to implement and pin-map this architecture; ECO-011A2, EPP-01A-R, footprints and PCB work remain unauthorized.

## 2. Background

The retained composites are all on `04_Safety_Inputs.kicad_sch`: U401AB (STOP), U401CD (left), U402AB (right), U402CD (up), U403AB (down), U403C (ARM) and U403D (FIRE). They are functional symbols, not physical packages. ECO-011A1 correctly stopped because LM339B-Q1 guarantees common mode only to `VCC − 2.0 V` over temperature: 1.3 V on 3.3 V and 3.0 V on 5 V, below the 2.5 V healthy and 4.0 V upper comparison levels. Downstream logic cannot repair an invalid analog input.

Manufacturer evidence used here is TI's [LM339B/LM2901B data sheet](https://www.ti.com/lit/ds/symlink/lm239.pdf), [TLV7044-Q1 data sheet](https://www.ti.com/lit/ds/symlink/tlv7044-q1.pdf), [TLV1704-Q1 data sheet](https://www.ti.com/lit/ds/symlink/tlv1704-q1.pdf), [TLV9024-Q1/TLV9034-Q1 data sheet](https://www.ti.com/lit/ds/symlink/tlv9034-q1.pdf), [SN74LVC08A-Q1 data sheet](https://www.ti.com/lit/ds/symlink/sn74lvc08a-q1.pdf), and [SN74LVC14A-Q1 data sheet](https://www.ti.com/lit/ds/symlink/sn74lvc14a-q1.pdf). Guaranteed limits, not typical curves, control this decision.

## 3. Safety Input Inventory

| Function / composite | Source and field circuit | Sense states / filtering | Output and significance |
| --- | --- | --- | --- |
| STOP / U401AB | 5 V nominal; 2.20 kΩ ±1% source; 2.20 kΩ ±1% remote EOL; dedicated 10 m max, 18–24 AWG pair | short ≈0 V; healthy ≈2.5 V; open ≈field rail; 1 kΩ/100 nF after entry clamp | `STOP_IN_COND`, local `STOP_FAULT`, and independent active-high `STOP_HW_INHIBIT`; startup/field-off asserted |
| Left / U401CD | Same supervised NC topology | Same window and filter | `LIMIT_LEFT_COND`, local fault; directional protective observation |
| Right / U402AB | Same supervised NC topology | Same window and filter | `LIMIT_RIGHT_COND`, local fault |
| Up / U402CD | Same supervised NC topology | Same window and filter | `LIMIT_UP_COND`, local fault |
| Down / U403AB | Same supervised NC topology | Same window and filter | `LIMIT_DOWN_COND`, local fault |
| ARM / U403C | NO dry contact; 10.0 kΩ ±1% main-only wetting source; 100 kΩ field-off pull-down | open/off ≈0 V; closed ≈4.50 V nominal from 10 kΩ/100 kΩ division; 1 kΩ/100 nF | `ARM_IN_COND` active high only when closed and `FIELD_OK`; startup/field-off inactive |
| FIRE / U403D | Same command topology | Same | `FIRE_IN_COND`; operational request, not independent authorization |

All seven inputs share the released ±8 kV contact-ESD design objective and exclude battery/VIN injection and automotive pulses. The five supervised loops are electrically identical by ADR-042; their only differences are names and consumers. ARM/FIRE are not supervised windows and do not claim open-wire diagnosis.

## 4. Sense-Voltage Reconstruction

The QER design envelope is `VFIELD = 4.75–5.25 V`. For analysis, each 2.20 kΩ resistor is bounded to ±2.0% total (±1% initial plus 0.65% worst temperature shift for ≤100 ppm/°C and 0.35% aging allowance), the 10 m 24-AWG loop plus contacts/connectors is bounded at 2.5 Ω, and total post-entry leakage is bounded at ±2 µA. Exact protection selection must meet that leakage bound. The 1 kΩ filter has no ideal DC drop; its worst leakage error is 2 mV.

For a closed supervised loop,

`VSENSE = VFIELD × REOL / (RSOURCE + REOL + RWIRE) ± ILEAK × 1 kΩ`.

Using 2.156–2.244 kΩ resistor endpoints gives **2.324 V minimum, 2.500 V nominal, and 2.679 V maximum** healthy sense. A hard return short is 0 V nominal and remains below 0.010 V with the 2.5 Ω harness bound and leakage. An open is `VFIELD` less leakage/loading: **4.743–5.250 V**. The 100 nF input and maximum 2 nF cable do not alter DC classification. Contamination or partial shorts are deliberately classified by the resistance crossing points, not treated as healthy uncertainty.

At nominal 5 V and 2.20 kΩ source, 1.0 V corresponds to about 550 Ω return resistance; 4.0 V corresponds to about 8.80 kΩ. Resistance between the released switching bands is an analog transition/ambiguous region and must settle conservatively after filtering; firmware must not infer a fault subtype.

| Quantity | Supervised loops | ARM/FIRE |
| --- | ---: | ---: |
| Valid low/deasserted extreme | ≤0.010 V short | ≤0.055 V open/field-off including 100 kΩ bias uncertainty and leakage |
| Nominal healthy/asserted | 2.500 V | 4.50 V closed |
| Healthy/asserted envelope | 2.324–2.679 V | 4.24–4.75 V closed |
| Open/high envelope | 4.743–5.250 V | Not a fault; open is inactive |

The ARM/FIRE closed bounds conservatively include field rail, 10 kΩ/100 kΩ initial/temperature/aging ratio, 1 kΩ series loading and 2 µA leakage. Exact ECO analysis shall recompute from selected protection leakage.

## 5. Threshold Reconciliation

The documented 1.0 V and 4.0 V numbers are **nominal prototype switching targets and diagnostic classification boundaries**, not zero-tolerance switching points. The released implementable bands are:

| Threshold | Nominal target | Guaranteed rising/falling switching band including rail ratio, divider, ±8 mV offset and 50–100 mV hysteresis | Separation |
| --- | ---: | ---: | ---: |
| Supervised low | `0.20 × VFIELD` (1.00 V at 5 V) | 0.90–1.10 V | ≥1.224 V to healthy minimum |
| Supervised high | `0.80 × VFIELD` (4.00 V at 5 V) | 3.80–4.20 V | ≥1.121 V from healthy maximum; ≥0.543 V to open minimum |
| ARM/FIRE | `0.50 × VFIELD` (2.50 V at 5 V) | 2.35–2.65 V | ≥2.295 V from inactive maximum; ≥1.59 V to asserted minimum |

Guaranteed always-healthy proof therefore exists only above the maximum low trip and below the minimum high trip: **1.10–3.80 V**, width 2.70 V. Values within 0.90–1.10 V or 3.80–4.20 V are transition bands. The short, EOL and open envelopes remain disjoint with positive margins. Threshold references must track `FIELD_SENSE_VCC`; the ratios retain the same resistance fault boundaries as field voltage changes.

## 6. LM339B-Q1 Disposition

LM339B-Q1 supports 3–36 V, open-collector output, wide differential input, low bias, suitable delay and Q1 temperature grade. Its decisive limit is guaranteed common mode: ground to `VCC − 2.0 V` over –40 to +125 °C. On 3.3 V, 2.324–5.25 V inputs are outside range; on 5 V, the 3.8–4.2 V high comparison and open state are outside range. No higher accepted always-available safe rail exists; `MAIN_PROTECTED` is not an appropriate direct logic-domain comparator supply. Input absolute maximum does not imply functional comparison, and no phase behavior outside common mode may be assumed.

**Disposition: SUITABLE ONLY WITH INPUT SCALING.** Direct use at 3.3 V or 5 V is rejected. Its open collector and delay are otherwise useful, but scaling adds failure modes and loses the simplicity of rail-tracking direct comparison.

## 7. Implementation Options

| Option | Assessment | Disposition |
| --- | --- | --- |
| A — divider into LM339B | A 0.25 ratio keeps 5.25 V at 1.313 V, which has only 13 mV margin to the 3.3 V full-temperature ceiling before tolerances; 0.20 is practical but adds two resistors per sensed node, loading, clamp interaction and open/short failure modes. Thresholds also scale to 0.2/0.8 V. | Feasible at ≤0.20 ratio; not selected |
| B — wide-input comparator | Direct same-rail comparison preserves impedance, filter and diagnostics. Rail-to-rail input plus open drain provides simple 3.3 V interfacing. | **Selected** |
| C — higher rail plus scaling | No new rail is allowed; using an unrelated higher rail worsens sequencing and partial-power behavior. | Rejected |
| D — integrated window/supervisor | No reviewed automotive five-window part matches two thresholds, individual diagnostics, open-drain polarity and command channels with less complexity. | Not selected |
| E — external precision reference | Absolute 1/4 V references require more devices and lose beneficial field-ratio tracking. A passive field-referenced ladder is more accurate than required. | Passive ladder selected; active reference rejected |
| F — ADC plus hardware inhibit | ADC diagnosis may be added only as test instrumentation. It cannot replace STOP hardware classification and adds firmware dependency. | Rejected as primary path |

## 8. Input-Scaling Analysis

The credible fallback divider is 4:1 attenuation (`RTOP:RLOW = 4:1`, gain 0.20), using ≤0.1%, ≤25 ppm/°C ratio-matched resistors, each ≥10 kΩ, rated ≥10 V and ≥0.063 W. It maps short/healthy/open to 0/0.465–0.536/0.949–1.050 V and maps nominal low/high thresholds to 0.20/0.80 V. At 3.3 V LM339B supply, worst input is 1.05 V, leaving 0.25 V guaranteed common-mode margin. A 50 kΩ total network loads an open loop by about 100 µA and lowers the raw open voltage to about 4.57 V, still above the 4.20 V boundary but with materially less margin.

With ≤0.1% ratio tolerance, divider gain error is about ±0.16%; LM339B bias-current error is negligible relative to 10 kΩ Thevenin impedance, while offset and clamp leakage dominate. The existing 1 kΩ/100 nF pole would interact with divider Thevenin resistance and must be re-derived. Top-resistor open forces low/fault; bottom-resistor open may drive the comparator high and can mask an open fault. A shorted top or bottom resistor can overrange or misclassify. One common divider cannot serve multiple independently returned loops. These added single-point ambiguities make scaling inferior, although electrically possible.

## 9. Candidate Device Assessment

| Candidate | Guaranteed evidence | Output / package / status | Assessment |
| --- | --- | --- | --- |
| **TLV7044-Q1** | 1.6–6.5 V supply; common mode `VEE` to `VCC + 0.1 V`; inputs absolute max –0.3 to 7 V; ±8 mV max offset; 2 pA max bias; 3 µs typical delay; internal 3–25 mV hysteresis; POR/startup 400 µs quad | Open drain; quad TSSOP-14; –40 to +125 °C; automotive; TI Active; exact family pin map published | **Selected device class and candidate family**. ECO-011A1R must select the exact orderable suffix and verify pin map. |
| TLV1704-Q1 | 2.2–36 V; common mode includes both rails; 36 V open collector; 560 ns typical; low offset; no phase reversal stated | Quad TSSOP-14; automotive; Active | Valid direct-input alternate; weaker explicit POR/partial-power behavior than selected family |
| TLV9024-Q1 | 1.65–5.5 V; rail-to-rail input beyond rails; precision low offset, fast; Q1 | Quad open drain; automotive; Active | Valid performance alternate; higher speed/power is unnecessary and exact partial-power behavior still needs ECO review |
| LM339B-Q1 | 3–36 V; common mode only to `VCC−2 V` full temperature | Quad open collector; Q1 | Scaling only; rejected for direct input |

The selected family tolerates an input at its own supply rail and provides open-drain translation to 3.3 V. It does not authorize an exact purchasing suffix, package footprint or AVL entry. Inputs beyond the released 0–field-rail contract remain protected by the entry network and final clamp selection.

## 10. Safety-Window Truth Table

Define `LOW_OK_N` as open-drain released/high when `SENSE` is above the low threshold, `HIGH_OK_N` as released/high when below the high threshold, and wire both collectors to one 3.3 V pull-up `WINDOW_OK`. Define `QUAL_OK = WINDOW_OK AND FIELD_OK`. A Schmitt inverter produces `ASSERTED = NOT QUAL_OK`; `FAULT` is the same physical logic result (separate named fanout/test net, not a second interpretation). For STOP, `STOP_IN_COND = STOP_HW_INHIBIT = ASSERTED`.

| State | LOW_OK_N | HIGH_OK_N | FIELD_OK / supplies | WINDOW_OK | ASSERTED / FAULT | STOP result |
| --- | ---: | ---: | --- | ---: | ---: | --- |
| Below low | 0 | 1 | 1 / valid | 0 | 1 | inhibit |
| Healthy window | 1 | 1 | 1 / valid | 1 | 0 | may qualify |
| Above high | 1 | 0 | 1 / valid | 0 | 1 | inhibit |
| Field invalid or comparator POR | X/0 | X/0 | 0 | X/0 | 1 by qualification | inhibit |
| Comparator rail absent | open/low not trusted | open/low not trusted | `FIELD_OK=0` | don't care | 1 | inhibit |
| One comparator output open | may mask that one threshold | other channel valid | 1 | potentially 1 | potentially 0 | detectable only by boundary test; residual single-component fault |
| One output stuck low | X | X | 1 | 0 | 1 | conservative inhibit |
| Logic startup/brownout | X | X | invalid until rail valid | pull/default plus Sheet 06 fail-high | 1 system-safe | permit remains removed |

The AND inputs require deterministic pull-down qualification if `FIELD_OK` is absent; output pull-ups are to 3.3 V only. A comparator open/stuck-high cannot be made intrinsically fail-safe without duplicated self-checking hardware; it is a documented prototype residual and is covered by startup/boundary test. Power loss is separately fail-safe and is not conflated with arbitrary semiconductor failure.

## 11. ARM/FIRE Receiver Truth Table

Each command comparator releases its open-drain `REQUEST_OK` when `SENSE` exceeds the 0.50×field threshold. `ACTIVE = REQUEST_OK AND FIELD_OK`; no inversion is required.

| SENSE / wiring | FIELD_OK and supply valid | ACTIVE |
| --- | ---: | ---: |
| <2.35 V; NO open, open wire or return short | 1 | 0 |
| 2.35–2.65 V transition | 1 | indeterminate during transition; RC/firmware qualification applies |
| >2.65 V; closed contact or field short | 1 | 1; held/shorted state remains illegal in firmware |
| Any | 0, startup, brownout or comparator unpowered | 0 |

Internal 3–25 mV hysteresis plus required external feedback yields 50–100 mV total. The commands share comparator family, field supply, passive reference approach and logic family with the windows, but they use one threshold each and never share the supervised window's wired collector node.

## 12. Threshold Reference Strategy

Retain the captured five-section, 10.0 kΩ ±0.1% ladder from `FIELD_SENSE_VCC`, producing 0.20, 0.50 and 0.80 ratios. Require ratio tracking ≤25 ppm/°C, total ladder impedance 50 kΩ nominal, local 100 nF filtering at each used tap, and comparator/reference routing isolated from output edges. Loading from TLV7044-Q1's 2 pA maximum bias is negligible; exact clamp/filter leakage must keep each reference error within 10 mV.

A single ladder is a common cause. Ladder open/short can move multiple thresholds. Mitigation for ECO-011A1R is separate low/high tap series isolation, test points, boundary self-test during manufacturing, and distributing STOP low/high comparators across different packages. A precision IC reference, DAC or buffered reference is not justified and would introduce startup and power-domain failure modes. Reference loss makes at least one comparator sink or is caught by `FIELD_OK`; prototype fault insertion must verify this claim for every ladder segment before release.

## 13. Hysteresis and Noise Margin

Require **50–100 mV total input-referred hysteresis** independently at the low, high, ARM and FIRE thresholds. The lower bound matches ADR-042; the upper bound preserves the released switching bands. TLV7044-Q1 contributes 3–25 mV internally, so external positive feedback shall supply the balance at worst case. No exact feedback resistor is selected here.

Healthy-to-threshold margins exceed 1.12 V and open-to-high margin exceeds 0.543 V after all DC bounds. Therefore 100 mV hysteresis plus 10 mV reference leakage budget, 8 mV comparator offset and a 100 mV peak noise test still leaves positive margin. The 1 kΩ/100 nF pole is nominally 100 µs; with 2 nF cable its added input time constant is only 2 µs. ECO-011A1R shall SPICE slow ramps, contact bounce, motor/PWM injection and feedback interaction and must settle fault outputs within 2 ms and STOP inhibit within 5 ms.

## 14. Input Protection Coordination

The existing entry clamp, 1 kΩ series resistor and 100 nF filter remain architectural requirements. Direct comparison avoids divider stress and preserves the pole. The final clamp must be low capacitance, leak ≤2 µA over –40 to +85 °C, survive the connector ESD objective with layout, and clamp comparator pins within –0.3 to 7 V absolute maximum. The 1 kΩ must limit positive/negative residual clamp current; at the 7 V comparator limit and 5.25 V field maximum, no normal-state clamp conduction is allowed.

Because TLV7044-Q1 inputs have a 7 V absolute maximum independent of VCC and the family is described as fail-safe, normal 0–5.25 V inputs do not backfeed an unpowered comparator supply. ECO-011A1R must nevertheless verify exact suffix input/output leakage under field-off/core-on and field-on/core-off sequencing, choose the clamp, calculate ESD current and energy, and retain no-battery/VIN-injection as a harness constraint.

## 15. Fail-Safe Analysis

| Failure | Windows / STOP | ARM/FIRE | Required ECO control |
| --- | --- | --- | --- |
| Comparator or 5 V field supply absent | `FIELD_OK=0`; asserted/fault; STOP inhibit high | inactive | AND qualification and Sheet 06 100 kΩ fail-high STOP bias |
| 3.3 V logic absent | Processor observations invalid; Sheet 06 loses reset/watchdog/main qualification, so permit is low | inactive/unavailable | no backfeed; LVC Ioff verification |
| Reference absent/open/short | At least one boundary becomes fault or indeterminate; never credit healthy | inactive or indeterminate | ladder fault-injection proof; no authorization until tested |
| Comparator output stuck low | conservative fault | inactive if command output low | accepted safe failure |
| Comparator output open/stuck high | one boundary can be masked | false active possible if command input also high | manufacturing boundary test; residual non-certified single fault |
| AND/inverter unpowered | passive defaults plus downstream authorization remove permit | inactive | output pulls and Sheet 06 fail-high path |
| Output pull-up open | window node low/undefined, must resolve asserted | request inactive | Schmitt input bias and fault injection |
| Feedback/divider resistor open/short | threshold moves; may mask one boundary | threshold moves | resistor failure analysis and boundary test in ECO |

No **single loss-of-power** state indicates a valid healthy system. Arbitrary stuck-high component faults are not claimed safe; IPC-100 remains non-certified and product-level redundant energy isolation remains required.

## 16. Package-Allocation Strategy

- Comparator demand: 12 channels exactly — ten window thresholds plus ARM and FIRE — in three quad packages; no spare comparator. Put STOP low and high channels in different packages and distribute opposing thresholds so one package does not own both thresholds for more than one high-significance loop.
- Logic demand: seven 2-input AND gates (five `WINDOW_OK AND FIELD_OK`, ARM and FIRE) in two quad SN74LVC08A-Q1-class packages; one unused gate. Five inverter channels in one hex SN74LVC14A-Q1-class package; one unused inverter.
- Unused logic inputs receive deterministic non-switching ties; unused outputs are no-connect. Each IC receives one local 100 nF bypass plus package-level bulk decoupling already required by the rail design.
- One passive 50 kΩ five-section ratio ladder supplies low/mid/high references; no reference IC. Each open-drain comparator node has a 3.3 V pull-up sized for guaranteed VOL, leakage and ≤2 ms timing.
- Exact reference designators, unit letters, pins, orderable suffixes and footprints are deferred to ECO-011A1R.

## 17. Prototype Validation Contract

Test at least three assemblies at `VFIELD` 4.75, 5.00 and 5.25 V and at practical cold/room/hot points spanning at least –20/25/+60 °C; analytical evidence must still cover –40 to +85 °C. For each supervised loop apply 0 Ω, 550 Ω nominal boundary, 2.20 kΩ EOL, 8.80 kΩ nominal boundary, open, 2.5 Ω cable/connector addition and adjustable partial resistance. Sweep slowly in both directions and inject 100 mV peak noise plus the released 2 nF cable capacitance. Repeat startup, field removal, 3.3 V removal and brownout.

Measure raw and filtered sense, all three reference taps, both comparator collectors, `WINDOW_OK`, `FIELD_OK`, `ASSERTED`, `FAULT`, processor status and STOP inhibit. Pass limits: healthy EOL remains inactive from 2.324–2.679 V; ≤0.010 V and ≥4.743 V always assert; low switching lies 0.90–1.10 V; high switching lies 3.80–4.20 V; hysteresis is 50–100 mV; outputs settle ≤2 ms; STOP hardware inhibit asserts ≤5 ms; no chatter under injected noise; field loss/startup/brownout never produces a healthy window.

For ARM/FIRE, verify inactive ≤0.055 V, active ≥4.24 V, switching 2.35–2.65 V, hysteresis 50–100 mV, field-invalid inactive, 10 ms firmware qualification and release-before-retrigger. Fault-inject every comparator output, pull-up, ladder segment and supply listed in Section 15 and retain waveforms, ambient, serial number and instrument calibration.

## 18. Selected Architecture

Use a TLV7044-Q1-class quad automotive comparator on existing `FIELD_SENSE_VCC`, direct 0–field-rail inputs, 0.20/0.50/0.80 field-tracking passive references, 50–100 mV input hysteresis, open-drain collectors pulled to 3.3 V, wired active-low window proof, SN74LVC08A-Q1-class `FIELD_OK` qualification, and SN74LVC14A-Q1-class inversion for active-high safety outputs. Power-off defaults are windows asserted/fault and commands inactive. The preliminary allocation is three quad comparators, two quad AND gates and one hex inverter.

ADR-042 and the External Safety ICD remain unchanged. No new rail, GPIO, hierarchy port, reference, footprint or PCB artifact is required by this decision.

## 19. ECO-011A1R Handoff

ECO-011A1R shall replace all seven composites; select exact orderable suffixes; allocate package units/pins and new references; implement the truth tables; calculate the ratio ladder and feedback networks at tolerance; select pull-ups, clamp and bypass parts; verify Ioff/POR/brownout; distribute STOP comparators; run SPICE and structural/native ERC; update EBOM/AVL and the reference register; and preserve every external net and polarity. It may not begin other ECO-011 categories or assign footprints.

## 20. Remaining Risks

Exact clamp leakage/energy, comparator suffix availability, reference-ladder fault response, external hysteresis values, LVC partial-power behavior, native ERC, SPICE and prototype measurements remain ECO/release evidence. A stuck-open comparator can mask one threshold and is not a certified single-fault-safe architecture. Final product hazard controls, redundant energy isolation, EMC, enclosure and harness qualification remain outside IPC-100 prototype scope.

## 21. Validation Results

The seven composites and all five supervised loops plus both commands are inventoried. Full sense envelopes, explicit threshold bands, LM339B checks at 3.3 V and 5 V, rejection of typical-only behavior, guaranteed selected-device input range, both truth tables, power-loss behavior, package allocation and measurable prototype limits are present. QER-04 changes requirements/documentation only: Sheet 04, GPIO, hierarchy, references, EBOM/AVL physical rows, footprints, PCB, ADR-042 and the ICD are unchanged. Repository validators and `git diff --check` are required at package close.

## 22. Final Decision

# QER-04 ACCEPTED — ECO-011A1R AUTHORIZED

Only ECO-011A1R is authorized. ECO-011A2, EPP-01A-R, footprint assignment and PCB work remain unauthorized.
