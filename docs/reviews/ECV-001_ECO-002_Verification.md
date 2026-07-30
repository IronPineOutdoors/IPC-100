# ECV-001 — ECO-002 Verification

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Verification | ECV-001 |
| Change verified | ECO-002 — Deterministic Authorization Input Bias |
| Date | 2026-07-30 |
| Scope | Sheet 05 ECO-002 correction only |
| Final decision | **VERIFIED** |
| Owner | Iron Pine Outdoors Engineering |

## Summary

ECO-002 is verified at preliminary schematic-capture level. Sheet 05 now gives both U3 authorization inputs deterministic local defaults:

- R27, 100 kΩ, forces `ACTUATOR_PERMIT` low when undriven.
- R28, 100 kΩ, forces `MASTER_INHIBIT` high from `+3V3_CORE` when undriven.

The default combination makes U3’s unchanged function:

`ENABLE = PERMIT AND NOT INHIBIT`

evaluate false through missing-producer, open-net, startup, reset, brownout, and USB-only conditions. ECO-002 does not change the frozen Rev A architecture.

## Correction Reviewed

| Item | Evidence | Result |
| --- | --- | --- |
| U3 `PERMIT` attachment | ECO-001 endpoint `(59.76,38.38)` remains attached to `ACTUATOR_PERMIT` | Pass |
| U3 `INHIBIT` attachment | ECO-001 endpoint `(59.76,43.46)` remains attached to `MASTER_INHIBIT` | Pass |
| PERMIT bias | R27 is uniquely valued `100 kΩ U3 PERMIT fail-low input bias`; its net labels connect `ACTUATOR_PERMIT` to GND | Pass |
| INHIBIT bias | R28 is uniquely valued `100 kΩ U3 INHIBIT fail-high input bias`; its net labels connect `MASTER_INHIBIT` to `+3V3_CORE` | Pass |
| Bias loading | Each bias draws `3.3 V / 100 kΩ = 33 µA` when overridden; maximum resistor dissipation is 0.109 mW | Pass for preliminary capture |
| Leakage margin | At the documented preliminary 5 µA leakage bound, PERMIT is no higher than 0.50 V and INHIBIT no lower than 2.80 V | Pass for preliminary capture; exact-device limits remain a release check |
| Output defaults | R1/R2 remain 100 kΩ output-enable pulldowns; eight 10 kΩ safe-side pulldowns remain present | Pass |

No powered CMOS authorization input remains without an intentional local bias in the ECO-002 scope.

## Verification Results

| Requirement | Objective result |
| --- | --- |
| PERMIT always deterministic when not driven | R27 forces low |
| INHIBIT always deterministic when not driven | R28 forces high while U3 is powered by `+3V3_CORE` |
| No floating authorization input remains | Both U3 inputs have direct named-net attachments and local safe-state bias |
| Fail-safe defaults preserved | Undriven state is PERMIT=0, INHIBIT=1, U3 enables=0 |
| Polarity unchanged | Permit remains active high; inhibit remains active high |
| Ownership unchanged | Sheet 06 remains producer; Sheet 05 remains consumer |
| Hierarchy unchanged | Root and child ports match; no port was added, removed, or renamed |
| GPIO unchanged | GPIO validator passes all 36 inventory rows |
| Translator topology unchanged | Two independent SN74LXC4T245-class branches remain |
| Suppression unchanged | `R_OK = RPWM AND NOT LPWM` and `L_OK = LPWM AND NOT RPWM` remain |

## Failure-Mode Results

| Failure mode | PERMIT result | INHIBIT result | Downstream result | Disposition |
| --- | --- | --- | --- | --- |
| Missing Sheet 06 | R27 low | R28 high | U3 enables low | Safe |
| Processor reset | Sheet 06 cannot validly permit; R27 is fallback; MCU commands separately pulled low | R28 high unless deliberately overridden | No motion request propagates | Safe |
| Broken authorization interconnect or harness | Open PERMIT resolves low; open INHIBIT resolves high | Complementary safe state | U3 enables low | Safe |
| Open hierarchy/net driver | R27 low | R28 high | U3 enables low | Safe |
| USB-only | U3 may have `+3V3_CORE`; R27 low | R28 is powered high | U3 disabled; motor B-side rails absent; safe outputs low/unpowered | Safe |
| Main brownout | Producer authorization becomes invalid; R27 restores low | R28 restores high as producer releases/collapses | U3 disabled; motor logic rails collapse | Safe at topology level; timing remains prototype validation |
| Unpowered Sheet 06 | R27 low | R28 high | U3 enables low | Safe |
| Floating external-driver inputs | Eight 10 kΩ safe-side pulldowns hold the controller-provided command nodes low | N/A | Both PWM and enable pairs inactive | Safe within the released passive-driver interface contract |
| `+3V3_CORE` absent | U3 unpowered; R27 grounds PERMIT | R28 is unpowered with U3 | R1/R2 and safe-side pulldowns retain inactive outputs | Safe |

An externally powered driver that actively drives voltage back into IPC-100 is outside the released interface contract and remains subject to exact translator Ioff/backfeed validation. That retained risk does not invalidate the ECO-002 passive-default correction.

## Regression Results

Available repository checks passed:

- hierarchy and root/child port synchronization;
- Sheet 06 producer / Sheet 05 consumer authorization contract;
- ECO-001 exact U3 endpoint attachment;
- ECO-002 exact bias count and safe-rail attachment;
- GPIO allocation;
- opposing-PWM and translator architecture checks;
- rejected raw-GPIO, limit/position, and output-fault interfaces;
- S-expression balance;
- project UUID uniqueness;
- Sheet 05 reference uniqueness;
- zero-footprint scope.

Measured repository inventory during ECV-001:

| Item | Count |
| --- | ---: |
| Sheet 05 placed references | 47 |
| Duplicate Sheet 05 references | 0 |
| PERMIT input biases | 1 |
| INHIBIT input biases | 1 |
| Authorization output pulldowns | 2 |
| Safe-side pulldowns | 8 |
| Independent four-channel translators | 2 |
| Footprints | 0 |

No schematic, ADR, interface, hierarchy, GPIO, translator, suppression, connector, footprint, PCB, or Sheet 06 regression was introduced by this verification package.

## Remaining Risks

ECV-001 verifies only ECO-002. It does not close:

- exact U3 orderable-device leakage, VIH/VIL, pin mapping, and temperature limits;
- native KiCad ERC;
- translator Ioff, propagation, minimum-pulse, ESD, and external-driver compatibility;
- Sheet 04 worst-case thresholds and passive STOP proof;
- power-transition and authorization-removal timing;
- any PCB or prototype-validation item.

These were already assigned to later release stages and do not prevent Package 07 preliminary schematic capture.

## Native ERC Status

`kicad-cli` is unavailable in the execution environment. Native ERC was not run and remains pending. ECV-001 does not claim ERC completion.

ERC remains mandatory before schematic release. Its absence does not invalidate the focused passive-bias evidence or block Package 07 preliminary capture.

## Final Decision

# VERIFIED

## PACKAGE 07

## SHEET 06

# AUTHORIZED

Authorization is limited to preliminary Sheet 06 schematic capture under the frozen Rev A contracts. It does not authorize PCB layout, manufacturing, energized prototype testing, footprint assignment, native ERC bypass, or closure of deferred component and prototype-validation items.
