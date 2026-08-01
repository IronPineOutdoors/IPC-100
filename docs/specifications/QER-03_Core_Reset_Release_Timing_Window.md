# QER-03 — Core Reset-Release Timing Window

Date: 2026-07-31
Platform: IPC-100 Rev A
Status: Released

## 1. Executive Summary

QER-03 releases one common **75–150 ms** reset-release delay window, with **100 ms as the exact nominal design target**. Timing begins when `+3V3_CORE` rises through U302's guaranteed positive SENSE threshold while MR is inactive. It ends when U302 releases its reset output, thereby permitting ESP32-S3 `CHIP_PU` and the hardware `RESET_VALID` node to rise.

The 75 ms minimum is a system stabilization requirement, not the ESP32-S3 silicon minimum. Espressif requires at least 50 µs between stabilized 3.3 V power and `CHIP_PU` rising; IPC-100 applies a much larger bounded interval after supervisor threshold crossing to cover final rail settling, source-selection residue, strap stability and measurement uncertainty. The 150 ms maximum bounds USB/UART recovery, factory test and brownout restart latency. It does not weaken safety because actuator authorization remains independently gated.

ECO-009's calculated 79.1–136.6 ms range is inside the released window. QER-03 therefore authorizes **ECO-009R — C305 Timing Closure** and does not authorize PACS-01.

## 2. Background

Package 04R recorded an informal 100 ms target while capturing C305 as 10 nF. PAS-01R and ECO-009 applied TI's TPS3890-Q1 equation: 10 nF produces about 10.725 ms, while the corrected generic 93.1 nF class produces 99.642 ms nominal and an estimated 79.1–136.6 ms endpoint range. ECO-009 could not close because no accepted min/max window existed. QER-03 supplies that missing contract without modifying hardware or selecting parts.

## 3. Reset and Readiness Chain

| State/event | Owner | Meaning |
|---|---|---|
| `+3V3_CORE` electrically valid | Sheet 02 regulator plus distribution | Rail is within 3.20–3.40 V; not processor readiness |
| U302 positive threshold crossed | Sheet 03 supervisor | Starts the reset-release timer if MR is inactive |
| U302 reset released | U302/C305 | Open-drain reset stops asserting low after the qualified delay |
| ESP32-S3 `CHIP_PU` released | Sheet 03 | Processor may begin internal boot; straps are sampled afterward |
| `CORE_POWER_GOOD` | Sheet 03 local semantic | Supervisor-qualified core condition; not hierarchical |
| `RESET_VALID` | Sheet 03 → Sheet 06 | Active-high hardware reset release/readiness to begin execution; not firmware initialization |
| Firmware initialized | Firmware | Software-controlled state occurring after boot; not implied by `RESET_VALID` |
| Watchdog service begins | Firmware/Sheet 06 | Alternating service transitions begin only from healthy control flow |
| `WATCHDOG_VALID` | Sheet 06 | Requires `RESET_VALID`, `MAIN_POWER_GOOD`, and two valid transitions |
| `ACTUATOR_PERMIT` | Sheet 06 hardware | Requires main power, STOP health, reset validity and watchdog validity |

U302 monitors `+3V3_CORE`. C305 programs only reset deassertion delay. U302's output drives ESP32 EN/`CHIP_PU` and exports `RESET_VALID`. Sheet 06 consumes `RESET_VALID`, but it cannot authorize actuators from that signal alone.

## 4. Timing Reference Event

The authoritative start event is: **the instant the monitored `+3V3_CORE` waveform rises through U302's guaranteed positive SENSE threshold, with MR high/inactive and U302 powered within its operating range**.

- Monotonic rise: start once at the positive crossing.
- Slow rise or pause below the positive threshold: timer has not started.
- Fall below the negative threshold during timing: reset asserts and CT is discharged; the interval is invalidated.
- Oscillation across thresholds: every qualifying fall cancels accumulated timing; a later positive crossing starts a new complete interval.
- Brief dip that does not cross the guaranteed negative threshold: no mandatory restart, but prototype testing must verify no false output transition.
- Brownout crossing the negative threshold: reset asserts within the U302 falling propagation bound; recovery requires a complete new delay.
- USB/main source transfer: no restart if `+3V3_CORE` stays above the negative threshold; otherwise use the brownout rule.

The timer does not start at source availability, source-selector completion, firmware activity, or an inferred `CORE_POWER_GOOD` event.

## 5. Minimum Delay Analysis

Espressif's current ESP32-S3 hardware guidance requires `tSTBL ≥ 50 µs` after power rails stabilize before `CHIP_PU` rises and `tRST ≥ 50 µs` with `CHIP_PU` low for reset. It also recommends a supervisor near 3.0 V for slow, unstable, or frequently cycled supplies. IPC-100 already uses that supervisor architecture.

The QER-01 core regulator contract permits startup up to 20 ms from source availability. U302 timing begins later, at its positive threshold crossing. A **75 ms minimum after threshold crossing** provides:

- over 1,500 times the ESP32-S3 50 µs stabilization minimum;
- at least 55 ms beyond the complete 20 ms rail-startup allowance when conservatively compared from a common source event;
- time for residual rail ringing, source-selector settling, decoupling charge and strap stabilization;
- 25 ms early-side allowance around the 100 ms target for supervisor/capacitor tolerance.

The requirement is derived from the released power-startup bound and processor guidance; it is not set equal to the current 79.1 ms estimate.

## 6. Maximum Delay Analysis

Longer reset assertion is fail-safe for actuator control but degrades USB Serial/JTAG and UART recovery, factory-test throughput, brownout recovery and diagnostic clarity. IPC-100 releases **150 ms maximum** from qualified threshold crossing to reset release. This bounds the hardware-only restart penalty while leaving firmware boot and watchdog qualification as separate subsequent intervals.

The maximum is asymmetric around 100 ms because lateness primarily affects availability, while premature release can violate power/strap stabilization. A delay over 150 ms is a qualification failure even if the processor eventually boots.

## 7. Nominal Target Interpretation

The phrase “100 ms target” is classified as **exact nominal design target**. It is neither a minimum nor a maximum and is not merely an order-of-magnitude goal.

| Record | Earlier interpretation | QER-03 reconciliation |
|---|---|---|
| Package 04R / U302 text | Approximately 100 ms, equation pending | Exact 100 ms nominal target |
| Original C305 = 10 nF | Incorrect implementation, about 10.725 ms | Superseded by ECO-009 generic 93.1 nF class |
| ECO-009 | 99.642 ms nominal; window absent | Nominal passes; endpoint range assessed against 75–150 ms |

The original 100 ms intent is preserved; only its quantitative interpretation is completed.

## 8. Operating Conditions

One common 75–150 ms window applies across:

- -40 °C, 25 °C and +125 °C supervisor/component qualification points;
- `+3V3_CORE` at 3.20 V, nominal 3.30 V and 3.40 V after threshold crossing;
- battery/main startup, USB-only startup and dual-source operation;
- monotonic fast ramps and controlled slow ramps from 0.1 V/ms to 10 V/ms;
- brownout recovery and source transfer that crosses the negative threshold;
- component tolerance, temperature drift, aging and leakage through the released service life;
- enclosure conditions up to the QER-01 +75 °C internal-air design point.

Ramp time before threshold crossing is excluded from the delay measurement but must be recorded. A nonmonotonic waveform that re-crosses the negative threshold restarts the measurement.

## 9. Tolerance Budget

The 75–150 ms limits include device tolerance, passive tolerance, temperature, aging, leakage, supply effects, propagation delay and measurement uncertainty. No RSS combination is allowed for release; bounded endpoints control.

| Contribution | ECO-009 basis |
|---|---|
| TPS3890-Q1 CT current | 0.90–1.35 µA |
| CT comparator threshold | 1.17–1.29 V |
| C305 initial tolerance | ±1% |
| C305 temperature/aging allowance | ±0.2% combined arithmetic allowance |
| Capacitor leakage | ≤10 nA, adverse direction |
| Open-CT propagation term | 25 µs nominal; negligible relative to window but measured |
| Rail ramp | Excluded before reference crossing; restart behavior included |
| Measurement uncertainty | Acceptance guard band below |

ECO-009's 79.1–136.6 ms analytical range passes with 4.1 ms minimum-side and 13.4 ms maximum-side design margin. For prototype acceptance, measured values must be **76–149 ms**, reserving 1 ms on each side for fixture/measurement uncertainty. A corrected uncertainty analysis may use the full 75–150 ms design limits if total expanded uncertainty is demonstrably ≤ the remaining margin.

## 10. Startup Sequence Coordination

| Order | Event | Timing/qualification |
|---:|---|---|
| 1 | USB, main, or both sources become available | No readiness implied |
| 2 | Source selection completes and `+3V3_CORE` rises | Core regulator startup ≤20 ms from applicable source event |
| 3 | Rail crosses U302 positive threshold | Reset timer starts |
| 4 | C305 timing interval | 75–150 ms; reset and `RESET_VALID` remain low |
| 5 | U302 releases reset / `CHIP_PU` rises | Processor boot begins; straps remain governed by Espressif timing |
| 6 | Firmware initializes | Separate software state; peripheral requests remain safe by default |
| 7 | Healthy watchdog service begins | Nominal 75 ms alternating transitions |
| 8 | `WATCHDOG_VALID` asserts | Only after `RESET_VALID`, `MAIN_POWER_GOOD`, and two valid transitions |
| 9 | `ACTUATOR_PERMIT` may assert | Only with STOP healthy and every hardware qualifier true |

The reset maximum does not consume a watchdog grace period because watchdog qualification is gated by `RESET_VALID`. USB-only operation can boot and recover normally, but `MAIN_POWER_GOOD` remains false so actuator permission cannot assert.

## 11. Brownout and Interruption Behavior

- When SENSE falls below U302's guaranteed negative threshold, reset and `RESET_VALID` shall assert low without intentional C305 delay.
- `CHIP_PU` shall remain below its valid-low level for at least Espressif's 50 µs reset minimum.
- U302's internal CT pull-down shall discharge C305 while reset is asserted. After any qualifying recovery, the full 75–150 ms release interval is required.
- An interruption that does not cross the negative threshold need not restart timing, but shall not create an output glitch.
- Repeated crossings shall never accumulate partial intervals.
- Retained charge shall not cause release earlier than 75 ms after a new positive crossing. If prototype testing cannot prove this, ECO-009R must add a controlled discharge requirement or identify a topology dependency.
- A USB/main transfer that keeps the rail above the negative threshold is seamless; one that crosses it follows full brownout recovery.

## 12. Failure-Mode Requirements

| Failure | Processor / readiness | Watchdog / actuator state | Required disposition |
|---|---|---|---|
| C305 open / CT open | Premature release possible | `RESET_VALID` may rise, but watchdog and other gates still required | Safe regarding single-fault authorization; diagnostic/test coverage required |
| C305 short / CT short | Processor held reset; `RESET_VALID` low | Watchdog invalid; actuators inhibited | Safe unavailable state |
| Leakage high / capacitance high | Late or absent boot | Watchdog invalid until release; actuators inhibited | Detect by startup timeout/service diagnostic |
| Capacitance low | Early release | Independent gates retained | Must still meet 75 ms; otherwise reject part/build |
| U302 output stuck active | Processor may escape supervision | Hardware independence reduced | Not claimed safe alone; downstream watchdog/STOP/main gates remain |
| U302 output stuck inactive/unpowered | Processor held reset | `RESET_VALID`/watchdog invalid; actuators inhibited | Safe unavailable state |
| Rail unstable / repeated oscillation | Repeated reset | Watchdog cannot qualify; actuators inhibited | No accumulated timing credit |

These are deterministic system requirements, not a formal functional-safety coverage claim.

## 13. Prototype Validation Contract

Test at least three controller assemblies, with at least three cold starts and three recovery events per condition. Observe `+3V3_CORE` at U302 SENSE, U302 reset/ESP32 `CHIP_PU`, `RESET_VALID`, `WATCHDOG_SERVICE_MCU`, `WATCHDOG_VALID`, `MAIN_POWER_GOOD` and `ACTUATOR_PERMIT`.

- Sources: 9 V and 21 V main input, USB-only, and dual-source transfer.
- Temperatures: -40 °C, 25 °C and +75 °C enclosure-air qualification; component analysis separately covers +125 °C limits.
- Ramps: 0.1, 1 and 10 V/ms at the monitored rail where laboratory injection is safe.
- Brownout: dips above and below the guaranteed negative threshold; interruptions of 1, 10 and 100 ms; repeated cycling at least 100 times per article.
- Instrumentation: ≥100 MHz oscilloscope, ≥1 GS/s, ≤10× probes with timing-channel skew characterized to ≤100 µs.
- Trigger: rising positive-threshold crossing for release; falling negative-threshold crossing for assertion.
- Release measurement: crossing to reset/`CHIP_PU` valid-high edge.
- Acceptance: every release measurement 76–149 ms; every qualifying fall asserts reset within U302's guaranteed propagation behavior; `CHIP_PU` low ≥50 µs; no `ACTUATOR_PERMIT` pulse before all qualifiers.

This test is required before final C305 freeze, U302 freeze, PCB release and energized actuator testing. It is qualification confirmation; failure outside the analytical model reopens ECO-009R/PACS selection.

## 14. Released Timing Requirements

| ID | Requirement | Start / target / limits | Conditions | Verification | References / owner |
|---|---|---|---|---|---|
| QER-RST-01 | Reset-release start event | Positive U302 SENSE crossing with MR inactive | All released sources/ramps | Oscilloscope | U302/C305; Sheet 03 |
| QER-RST-02 | Nominal design delay | 100 ms exact nominal target | 25 °C, nominal values | Equation | U302/C305; Sheet 03 |
| QER-RST-03 | Minimum release delay | ≥75 ms design limit | All tolerance/environment/source cases | Endpoint analysis + DV | U302/C305; hardware |
| QER-RST-04 | Maximum release delay | ≤150 ms design limit | Same | Endpoint analysis + DV | U302/C305; hardware |
| QER-RST-05 | Prototype guarded window | 76–149 ms measured | Defined DV matrix | ≥3 assemblies | U302/C305; validation |
| QER-RST-06 | Brownout restart | Full new interval after guaranteed negative crossing | Brownout/source transfer | DV waveform | U302/C305 |
| QER-RST-07 | Reset assertion | No intentional C305 delay; `CHIP_PU` low ≥50 µs | Any qualifying fall | Datasheet + DV | U302/ESP32-S3 |
| QER-RST-08 | Authorization invariant | No actuator permit solely from reset release | All startup/fault cases | Logic regression + DV | Sheets 03/06 |

## 15. ECO-009 Disposition

QER-03 resolves ECO-009's sole requirements blocker. Its 99.642 ms nominal and 79.1–136.6 ms endpoint estimate are compliant with QER-RST-02 through QER-RST-04. ECO-009 remains historically incomplete until ECO-009R verifies the calculation, updates its decision, and completes targeted validation; this document does not modify the schematic.

## 16. PACS-01 Handoff

ECO-009R shall close C305 against QER-RST-01 through QER-RST-08. PACS-01 later selects the exact U302 order code and exact C305 candidate against the same limits. QER-03 does not select either component and does not authorize PACS-01.

## 17. Remaining Risks

- U302 exact suffix and guaranteed falling propagation behavior remain PACS evidence.
- C305 exact MPN, leakage and package remain selection evidence.
- CT-node board leakage and retained-charge behavior require prototype correlation.
- The +75 °C enclosure test does not replace component endpoint analysis to +125 °C.
- Open-C305 failure is not directly diagnosed before processor release; independent authorization gates remain required.

## 18. Validation Results

The QER-03 validator checks one start event, one nominal interpretation, released 75/150 ms limits, acceptance of the 79.1–136.6 ms envelope, measurable prototype criteria, brownout restart, ADR-041 semantics, hardware authorization invariants and documentation-only scope. Repository validators and `git diff --check` are run at package close.

Primary sources:

- Texas Instruments TPS3890-Q1 datasheet and active product record: https://www.ti.com/lit/ds/symlink/tps3890-q1.pdf
- Espressif ESP32-S3 Hardware Design Guidelines, Chip Power-up and Reset Timing: https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32s3/schematic-checklist.html

## 19. Final Decision

# QER-03 ACCEPTED

Authorized next package: **ECO-009R — C305 Timing Closure**. PACS-01, PPC-01, JCS-01, CSR-01A-R5, footprint assignment and PCB work remain unauthorized.
