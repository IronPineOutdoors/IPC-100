# ECO-009 — C305 Supervisor Timing Correction

## 1. Scope

ECO-009 changes only C305 and its controlled records. It preserves U302, the TPS3890-Q1 topology, `+3V3_CORE`, `CORE_POWER_GOOD`, `RESET_VALID`, GPIO, hierarchy, connectors, ownership, architecture and all footprints.

## 2. PAS-01R Finding

PAS-01R demonstrated that the captured 10 nF value produces approximately 10.725 ms nominal rather than the released 100 ms target. ECO-009 corrects the nominal implementation but cannot close the absent accepted minimum/maximum timing window.

## 3. Current Circuit Audit

| Item | Result |
|---|---|
| Supervisor | U302, captured as TPS389030-Q1, 2.89 V typical threshold |
| Timing element | C305 alone, from U302 CT pin to ground; no external timing resistor |
| Previous value | 10 nF, generic and unqualified |
| Corrected class | 93.1 nF ±1%, C0G/NP0, ≥10 V, ≤10 nA leakage, -40..125 °C |
| Previous nominal delay | 10.725 ms |
| Corrected nominal delay | 99.642 ms |
| Function | Delays reset deassertion after SENSE rises above its positive threshold |
| Output consumers | ESP32 EN/CHIP_PU and exported active-high `RESET_VALID`; Sheet 06 authorization consumes `RESET_VALID` |

Assertion on a falling SENSE event is not intentionally delayed by C305. `RESET_VALID` remains fail-low through its existing pull-down and authorization remains inhibited until reset, main-power and watchdog qualifications all pass. USB-only operation can release the processor reset because `MAIN_POWER_GOOD` intentionally does not gate Sheet 03; actuators remain inhibited by Sheet 06. Brownout reasserts reset promptly and a qualified recovery restarts the CT delay.

## 4. Timing Requirement

The repository consistently states a **100 ms nominal reset-release target**. Timing starts after the monitored rail crosses the supervisor's positive SENSE threshold and includes the CT charge interval plus the specified open-CT propagation term. No controlling QER, ADR, SSR or implementation record defines an accepted minimum and maximum reset-release window. The 40–100 ms interval elsewhere applies to watchdog service transitions, not C305, and is not reused.

Because the min/max requirement is absent, ECO-009 does not reinterpret or invent one. This prevents a complete final decision even though the nominal value is corrected.

## 5. TPS3890-Q1 Timing Model

TI SBVS303B defines:

`tPD(r) = CCT × VCT / ICT + tPD(r)(open)`

and gives the nominal convenience form `tPD(r)(s) = CCT(µF) × 1.07 + 25 µs`. CT current is 0.90–1.35 µA, CT comparator threshold is 1.17–1.29 V, and the programmable range is 25 µs to 30 s (up to 26 µF). TI recommends a low-leakage ceramic capacitor and minimizing CT-node parasitic capacitance. On assertion, the device discharges C305 through its internal nominal 200 Ω CT pull-down. CT is not a generic external RC timer.

The datasheet does not specify a separate bounded CT-pin leakage suitable for cancellation. ECO-009 therefore limits selected capacitor leakage to 10 nA and applies it in the adverse direction; board leakage remains a layout/prototype concern. CT voltage remains below the 1.29 V maximum threshold and is well inside a ≥10 V capacitor rating.

Primary source: https://www.ti.com/lit/ds/symlink/tps3890-q1.pdf

## 6. C305 Value Calculation

For 100 ms nominal:

`Cideal = (0.100 s - 0.000025 s) / 1.07 = 0.093435 µF = 93.435 nF`

| Candidate | Nominal result | Error |
|---:|---:|---:|
| 91 nF | 97.395 ms | -2.605% |
| **93.1 nF** | **99.642 ms** | **-0.358%** |
| 100 nF | 107.025 ms | +7.025% |

The selected generic value is 93.1 nF ±1% C0G/NP0. C0G minimizes temperature drift, aging and voltage coefficient; DC bias is negligible at approximately 1.29 V. No exact MPN or footprint is selected.

## 7. Worst-Case Timing Stack

The package-independent capacitor budget is ±1% initial tolerance plus ±0.1% temperature and ±0.1% aging/process allowance, combined arithmetically as ±1.2%. Capacitor leakage is bounded at 10 nA. Using TI's full current and threshold endpoints:

- minimum: `93.1 nF × 0.988 × 1.17 V / (1.35 µA + 0.01 µA) + 25 µs = 79.1 ms`;
- nominal: `93.1 nF × 1.23 V / 1.15 µA + 25 µs = 99.62 ms` (99.642 ms by TI's nominal convenience equation);
- maximum: `93.1 nF × 1.012 × 1.29 V / (0.90 µA - 0.01 µA) + 25 µs = 136.6 ms`.

Supply and temperature effects are represented by TI's guaranteed current/threshold endpoints. Rail ramp time precedes threshold crossing and is not part of the CT interval. The published open-CT 25 µs term is nominal; no production min/max is specified, but it is negligible against the approximately 20–37 ms endpoint spread.

QER minimum: **not specified**. QER maximum: **not specified**. Boundary margin therefore cannot be calculated or declared passing.

## 8. Failure-Mode Review

| Failure | Result and safety effect |
|---|---|
| C305 open / CT open | Approximately 25 µs release; processor may start prematurely, but Sheet 06 still requires all independent qualifications; unsafe authorization is not created by reset validity alone |
| C305 short / CT short | Reset remains asserted; processor and `RESET_VALID` remain low; actuators inhibited |
| Capacitance low / leakage aiding charge | Earlier release within or below the calculated minimum; requirement window needed |
| Capacitance high / leakage opposing charge | Later release; system unavailable longer but remains inhibited |
| Supervisor unpowered | RESET/EN and `RESET_VALID` remain fail-low through existing bias |
| Slow or fast rail ramp | Timer begins only after positive threshold crossing; falling threshold promptly reasserts reset |
| Repeated brownout | Each valid recovery restarts timing; no accumulated authorization credit |
| USB-only startup | Core may start after qualified delay; `MAIN_POWER_GOOD` remains false, preventing actuator permit |
| Main-power startup | Same reset qualification plus independent main-power/watchdog gates |
| Watchdog reset or held processor | Watchdog validity is lost or never established; actuator permit remains low |

Open-C detection is not provided. Residual risk is a premature processor release, not direct actuator authorization.

## 9. Schematic Change

C305 retains its reference, UUID, two-pin topology and CT-to-ground connection. Its value changes from 10 nF to `93.1 nF ±1% C0G/NP0 ≥10 V; CT; 99.642 ms nominal; leakage ≤10 nA; -40..125 C`. No DFT node or topology is added.

## 10. EBOM/AVL Reconciliation

The C305 EBOM and AVL rows carry the corrected generic class, timing-critical status, TI evidence reference and remaining U302/window blocker. No exact MPN, alternate or footprint is guessed. All other rows are byte-logically preserved by a narrow overlay; CSV sources regenerate their XLSX counterparts.

## 11. Validation Results

Targeted validation checks the value, formula, connection, UUID/reference preservation, reference register, BOM/AVL agreement and prohibited-file scope. Repository hierarchy/GPIO/reference/UUID checks and `git diff --check` are run at close.

## 12. Native ERC Status

`kicad-cli` was not available on PATH on 2026-07-31. Native ERC therefore remains pending. Repository structural validation passed but is not represented as native ERC.

## 13. Remaining PACS-01 Dependency

U302 still requires exact order-code selection in PACS-01. More importantly, an accepted reset-release min/max requirement must be released before the 79.1–136.6 ms device/capacitor envelope can be judged. PACS-01 is not authorized by an incomplete ECO.

## 14. Manual Review Checklist

- [x] C305 nominal target corrected without changing reference or topology.
- [x] Full TI timing-current/threshold endpoints calculated.
- [x] Failure modes preserve independent actuator inhibition.
- [x] EBOM/AVL generic class updated without MPN or footprint.
- [ ] Release an accepted minimum and maximum reset-release window.
- [ ] Select exact U302 order code in a later authorized package.
- [ ] Run native ERC when KiCad CLI is available (not available on PATH during ECO-009).

## Final Decision

# ECO-009 INCOMPLETE

The nominal implementation is corrected, but completion is prohibited because no accepted minimum/maximum reset-release window exists against which to qualify the calculated 79.1–136.6 ms worst-case range. PACS-01 and CSR-01A-R5 are not authorized.
