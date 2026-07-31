# ECO-007 — Power Programming and Supervisor Implementation Correction

## 1. Scope

ECO-007 corrects only the three datasheet-level defects reported by CSR-01A-R2: U201/R201 frequency programming, the three TPS2553-Q1 RILIM networks, and the U801 expansion-rail supervisor. Rail ownership, load budgets, hierarchy, GPIO, connector contracts, safety/watchdog ownership, and footprints remain unchanged. Primary sources are TI datasheets SNVSBS6B (LMR38020-Q1), SLVSBD0B (TPS2553-Q1), and SLVSFO5E (TLV841).

## 2. CSR-01A-R2 Findings Addressed

| Finding | Defect | Correction |
|---|---|---|
| F01 | R201 40.2 kΩ contradicted 400 kHz operation | Adjustable LMR38020F-Q1 family; R201 64.9 kΩ RT/SYNC-to-GND |
| F02 | R222/R223/R224 287 kΩ exceeded the legal 232 kΩ maximum | Three independent 150 kΩ ILIM-to-GND networks |
| F03 | Composite U801 could not realize both accepted thresholds | Physical fixed 2.7 V TLV841S supervisor with external hysteresis and bypass |

## 3. Affected Reference Inventory

| Sheet | References | Corrected function | CSR-01A-R3 disposition |
|---|---|---|---|
| 02 | U201/R201 | 400 kHz adjustable LMR38020F-Q1 family; 64.9 kΩ ±1%, ≤100 ppm/°C | BLOCKED pending exact suffix/full freeze |
| 02 | U209/R222 | Active-high expansion switch; 150 kΩ ±1% independent RILIM | BLOCKED; optional/DNP |
| 02 | U212/R223, U213/R224 | Active-high motor-logic switches; 150 kΩ ±1% independent RILIM | BLOCKED |
| 08 | U801/R801 | Physical fixed 2.7 V, 10 ms, push-pull valid-high supervisor; unchanged 100 kΩ fail-low bias | U801 BLOCKED; R801 freeze preserved |
| 08 | R806/R808/C804 | 150 kΩ series feed, 4.47 MΩ feedback, 100 nF bypass | New rows BLOCKED — CSR-01A-R3 |

No U201-dependent passive other than R201 changes because the correction restores the already-released 400 kHz basis.

## 4. U201 Variant and Frequency Method

U201 requires the adjustable-frequency LMR38020F-Q1 ordering family. RT/SYNC accepts either the local resistor or an external synchronization clock. External synchronization is unused; the pin is not open, shorted, or shared. Final purchasable suffix remains CSR-01A-R3 work.

## 5. U201/R201 Calculation

QER-01/ECO-006 require 400 kHz. TI's programming table specifies `RRT = 64.9 kΩ`. With ±1% tolerance R201 spans 64.251–65.549 kΩ. Total frequency limits must also include exact-suffix oscillator accuracy during CSR-01A-R3. A conservative 1 V RT bias dissipates only 15.6 µW at minimum resistance. The resistor establishes the intended startup frequency without firmware.

## 6. U201 Dependent Calculations

Because 400 kHz is restored, ECO-006's 15 µH requirement, minimum two 22 µF output capacitors, ripple/peak-current basis, input-capacitor RMS basis, compensation target, switching loss, current-limit margin, and thermal target remain valid. At 21 V to 5 V, duty is approximately 0.238, giving about 0.595 µs on-time and 1.905 µs off-time at 400 kHz. Exact biased-capacitance, inductor saturation/loss, loop, loss, current-limit, and copper-area evidence remain CSR-01A-R3 blockers.

## 7. TPS2553-Q1 Channel Inventory

| Device | Branch/input | Continuous / peak | Capacitance | Enable/default | Fault |
|---|---|---:|---|---|---|
| U209 | Expansion / 3.3 V | 100 mA / 150 mA for 10 ms | C217 4.7 µF plus ICD-001 load | Active high; upstream request fail-low; DNP | Unused/no-connect |
| U212 | Motor logic A / 5 V | 100 mA / 150 mA for 10 ms | 4.7 µF local | Active high; MAIN_POWER_GOOD fail-low | Unused/no-connect |
| U213 | Motor logic B / 5 V | 100 mA / 150 mA for 10 ms | 4.7 µF local | Active high; MAIN_POWER_GOOD fail-low | Unused/no-connect |

## 8. RILIM Calculations

TI permits 15–232 kΩ and specifies `IOS(max equation)=22980/R^0.94`, `IOS(nom)=23950/R^0.977`, and `IOS(min equation)=25230/R^1.016`, with R in kΩ and result in mA. At 150 kΩ, nominal is about 179 mA. Applying ±1% resistor tolerance to the bounding equations gives approximately 154–209 mA. This supports the 150 mA/10 ms peak and preserves 54% minimum margin over 100 mA continuous load. The upper bound remains coordinated below the upstream rail capacity. Each IC has one unshared resistor.

Worst initial short-circuit input power is approximately 0.69 W at 3.3 V or 1.05 W at 5 V before current/thermal regulation and retry. Exact package transient thermal performance remains CSR-01A-R3 work. ILIM resistor power is micro-watt class.

## 9. TPS2553-Q1 Support Review

Active-high polarity, deterministic enable defaults, local input/output bypassing, independent ground-returned ILIM networks, reverse-injection provisions, and unused fault-pin no-connect treatment are preserved. U209 remains DNP, so USB-only operation does not create an actuator path. Exact package, reverse-current, capacitance derating, and protection parts remain blocked; no broader topology defect was found.

## 10. U801 Functional Requirement

U801 qualifies `EXPANSION_VCC_FILT` for U802. It is powered from `+3V3_CORE`, asserts valid only after the expansion rail is at least 2.9 V for 5–10 ms, deasserts by 2.7 V, uses a core-domain push-pull valid-high output, and remains low if either domain is absent. R801 independently biases U802 enable low.

## 11. U801 Architecture Selection

A bare fixed-threshold TLV841S cannot independently provide the accepted 200 mV threshold separation. U801 is a physical separate-SENSE TLV841S with 2.7 V falling threshold, internal 5% hysteresis, 10 ms delay, and two external resistors that add positive feedback. It is no longer a composite symbol. No manual reset or separate enable is needed.

## 12. U801 Threshold and Hysteresis Calculations

R806 = 150 kΩ from expansion rail to SENSE and R808 = 4.47 MΩ from valid-high output to SENSE. With the nominal 2.7 V falling threshold, 5% internal hysteresis, and `VOH=3.3 V`:

- `Vrise = (2.7 V × 1.05) × (1 + R806/R808) = 2.930 V`;
- `Vfall = 2.7 V × (1 + R806/R808) − VOH × R806/R808 = 2.680 V`;
- nominal external-domain hysteresis is 250 mV.

Network current is sub-microamp while the output and monitored rail are close in voltage. ±0.1%, ≤25 ppm/°C resistors deliberately center the thresholds inside the accepted boundaries. With ±0.5% threshold tolerance, the nominal design retains useful margin; exact order-code threshold accuracy, input leakage across the approximately 145 kΩ Thevenin resistance, output-high tolerance, and temperature extrema shall be closed in CSR-01A-R3. The 10 ms internal delay qualifies rising ramps; falling brownout deassertion is asynchronous apart from propagation delay.

## 13. U801 Output and Enable Behavior

The valid-high output asserts only after a valid rail persists for 10 ms. Invalid expansion voltage drives it low; absent core power leaves R801 pulling it low. With core absent and expansion present, R808 limits possible injection to sub-microamp order. With expansion absent, R806/R807 hold SENSE low. U802 enable never floats and no startup enable pulse is expected. C804 bypasses U801 locally.

## 14. Schematic Changes

Only Sheets 02 and 08 changed. Net/hierarchy names, polarity, GPIO, connectors, safety/watchdog logic, and downstream topology are unchanged. All footprints remain empty and no PCB file changed.

## 15. Reference Register Changes

Added unused Sheet 08 references C804, R806, and R808. R807 remains unused; existing references were not renumbered.

## 16. EBOM/AVL Reconciliation

The generated EBOM/AVL include the four added physical parts and corrected generic values/classes, preserve all nine frozen resistors, and mark new/corrected unfrozen rows `BLOCKED — CSR-01A-R3`. No guessed MPN, footprint, source, or price was added.

## 17. Validation Results

`validate_eco007.ps1` checks the three corrected networks, deterministic defaults, physical U801 implementation, reference/UUID uniqueness, balanced schematics, hierarchy/GPIO/connector preservation, and zero footprints. Repository validators and `git diff --check` are release requirements.

## 18. Native ERC Status

`kicad-cli` was unavailable in the release environment on 2026-07-31. Native ERC therefore remains **PENDING** and is not represented as passed.

## 19. Remaining Power-Selection Blockers

CSR-01A-R3 must freeze exact suffixes/order codes, packages, full tolerances, thermal/stability evidence, biased passives, lifecycle, sourcing, cost, and alternates. ECO-007 does not accept CSR-01A-R2, run CSR-01A-R3, or authorize CSR-01B.

## 20. Manual Review Checklist

- [x] Valid 64.9 kΩ RT/SYNC-to-GND
- [x] Three independent legal 150 kΩ ILIM-to-GND networks
- [x] Physical fixed-threshold supervisor and represented external hysteresis network
- [x] Deterministic fail-low output and local bypass
- [x] No architecture, hierarchy, GPIO, connector, safety, watchdog, footprint, or PCB change
- [ ] Native ERC when KiCad CLI is unavailable
