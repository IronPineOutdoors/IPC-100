# Package 03R — Sheet 02 Implementation Record

## Status

Sheet 02 Power Conversion and Rail Control is implemented for preliminary capture under [ADR-039](../../../docs/decisions/ADR-039_Regulated_Rail_Enable_Ownership_and_Main_Source_Qualification.md). This is a peer-review baseline, not a released schematic or PCB-layout authorization.

## Implemented topology

| Block | Preliminary implementation | Result |
| --- | --- | --- |
| Main regulator | LMR38020S-Q1 synchronous buck, 400 kHz target | `VIN_PROTECTED` to `+5V_MAIN` |
| Core source selector | TPS2121 priority power mux | Main-priority `+5V_MAIN` or `USB_5V_PROTECTED` to `CORE_SOURCE` |
| Core regulator | TPS62130 adjustable synchronous buck | `CORE_SOURCE` to `+3V3_CORE` |
| Main qualification | SN74LVC1G08-Q1 AND function | `MAIN_INPUT_VALID` AND main-buck PGOOD to `MAIN_POWER_GOOD` |
| Request qualification | SN74LVC08A-Q1 quad AND | Each request AND `MAIN_POWER_GOOD` |
| OLED, sensor, UI, relay, field branches | TPS22918-Q1 controlled-rise load switches | Default-off or main-qualified branch switching |
| Motor branches | TPS2553-Q1 current-limited switches, provisional | Separate main-only 100 mA target branches |
| Expansion branch | TPS2553-Q1, provisional and DNP | Optional protected 3.3 V branch |
| Reverse injection | Series Schottky blocking, exact devices TBD | Preliminary backfeed barrier on exposed branch outputs |

No relay driver, motor driver, ESP32, USB data circuit, connector, footprint, or PCB object is included.

## Main 5 V rail

- U1 is represented as LMR38020S-Q1, using internal compensation and fixed soft start.
- L1 starts at 15 µH with at least 3.2 A saturation current and no more than 100 mΩ DCR.
- The preliminary 100 kΩ / 24.9 kΩ feedback network gives approximately 5.02 V for a 1.0 V feedback reference.
- The 40.2 kΩ RT value targets approximately 400 kHz and must be checked against the exact orderable suffix.
- Input capacitance starts at 2.2 µF, 100 V local ceramic in addition to Sheet 01 bulk storage.
- Output capacitance starts at two 22 µF, 10 V ceramics.
- U1 PGOOD is pulled up in the 3.3 V core domain and combined with qualified `MAIN_INPUT_VALID`.
- The buck may start from valid `VIN_PROTECTED`; `MAIN_POWER_GOOD` remains false until the upstream and downstream qualifiers are both valid.

The exact LMR38020 suffix, RT transfer, minimum effective capacitance, loop stability, ripple, inductor loss, and thermal result remain release blockers.

## Core source selection

TPS2121 receives `+5V_MAIN` on IN1 and `USB_5V_PROTECTED` on IN2.

- PR1 uses 10.2 kΩ / 5.00 kΩ, corresponding to a preliminary main-valid priority threshold near 3.22 V.
- CP2 is held low, selecting fixed IN1 priority when main is valid.
- OV1 and OV2 use provisional 23.7 kΩ / 5.00 kΩ dividers, approximately 6.08 V at a 1.06 V reference.
- RILM starts at 60.4 kΩ for an approximately 2 A target; the datasheet equation and tolerance must be rechecked.
- 100 nF soft-start and 47 µF core-source hold-up are preliminary.
- TPS2121 internal switches provide source isolation and reverse-current blocking.

Main has priority. USB can maintain `CORE_SOURCE` and `+3V3_CORE` when main is absent. Switchover is not claimed glitchless; processor reset remains acceptable if every main-only output stays safe.

## Core 3.3 V rail

- U3 is TPS62130RGTR.
- L2 starts at 2.2 µH, at least 4.0 A saturation current, and no more than 60 mΩ DCR.
- The preliminary 316 kΩ / 100 kΩ divider gives approximately 3.33 V for a 0.8 V reference.
- Input capacitance starts at 10 µF, 10 V.
- Output capacitance starts at two 22 µF, 10 V ceramics.
- A 10 nF soft-start capacitor and always-enabled 100 kΩ feed are shown.
- The regulator PGOOD node has a 10 kΩ pull-up to `+3V3_CORE`.

`CORE_POWER_GOOD_LOCAL` is a regulator diagnostic only. In accordance with ADR-039, Sheet 03 retains ownership of the TPS3890-qualified core-good/reset semantic and exports `RESET_VALID`; no new hierarchical core-good port is created.

## Branch matrix

| Output | Source | Enable | Allocation | Default | Population |
| --- | --- | --- | ---: | --- | --- |
| `OLED_VCC` | `+3V3_CORE` | `OLED_POWER_REQ` AND `MAIN_POWER_GOOD` | 150 mA | Off | Optional |
| `SENSOR_VCC` | `+3V3_CORE` | `SENSOR_POWER_REQ` AND `MAIN_POWER_GOOD` | 50 mA | Off | Optional |
| `UI_VCC` | `+5V_MAIN` | `UI_POWER_REQ` AND `MAIN_POWER_GOOD` | 120 mA shared envelope | Off | Base interface |
| `EXPANSION_VCC` | `+3V3_CORE` | `EXPANSION_POWER_REQ` AND `MAIN_POWER_GOOD` | 100 mA maximum | Off | Optional/DNP |
| `RELAY_VCC` | `+5V_MAIN` | `MAIN_POWER_GOOD` | 100 mA | Off until main qualified | Base if relay populated |
| `FIELD_SENSE_VCC` | `+5V_MAIN` | `MAIN_POWER_GOOD` | Five supervised loops | Off until main qualified | Base |
| `MOTOR_LOGIC_5V_A` | `+5V_MAIN` | `MAIN_POWER_GOOD` | 100 mA target | Off until main qualified | Base protected branch |
| `MOTOR_LOGIC_5V_B` | `+5V_MAIN` | `MAIN_POWER_GOOD` | 100 mA target | Off until main qualified | Base protected branch |

Each request has a 100 kΩ pull-down. A missing Sheet 03, high-impedance GPIO, open trace, reset state, or unpowered processor therefore requests off. The quad AND stage prevents a request from bypassing main qualification.

TPS22918-Q1 branch CT begins at 1 nF. QOD is returned through 1 kΩ to limit discharge current. Local 4.7 µF output capacitors are preliminary. Exact rise and discharge times depend on effective capacitance and the released load.

## Power-good semantics

- `MAIN_INPUT_VALID` is released-valid open-drain from Sheet 01. Sheet 02 provides a preliminary main-derived 3.3 V shunt bias and a fail-low resistor.
- `MAIN_POWER_GOOD` is active-high 3.3 V logic produced only when `MAIN_INPUT_VALID` and LMR38020 PGOOD are both true. It cannot assert from USB alone.
- `CORE_POWER_GOOD_LOCAL` follows TPS62130 PGOOD and may be valid during USB-only service. It is not the Sheet 03 supervisor result.
- `POWER_VALID` is absent.
- `POWER_FAULT_SUMMARY` remains upstream-owned and is not redefined on Sheet 02.

## USB-only and fault behavior

USB-only can energize TPS2121, `CORE_SOURCE`, TPS62130, and `+3V3_CORE`. It cannot create the main-derived bias or LMR38020 PGOOD needed for `MAIN_POWER_GOOD`; every main-only or request-controlled branch therefore remains off.

Loss of `MAIN_INPUT_VALID`, main-buck PGOOD, or the main rail removes `MAIN_POWER_GOOD`. Request signals that remain high cannot hold a branch on. On restoration, hardware-on branches return after qualification; request-controlled branches return only if their request remains intentionally asserted. Firmware must clear and revalidate requests during reset recovery as specified by Package 04.

## Calculations and budgets

| Item | Preliminary result |
| --- | --- |
| 5 V feedback | `1.0 × (1 + 100k/24.9k) ≈ 5.02 V` |
| 3.3 V feedback | `0.8 × (1 + 316k/100k) ≈ 3.33 V` |
| TPS2121 PR1 threshold | `1.06 × (1 + 10.2k/5k) ≈ 3.22 V` |
| TPS2121 OV thresholds | `1.06 × (1 + 23.7k/5k) ≈ 6.08 V` |
| Core peak load | 790 mA design peak |
| 5 V core-converter input at peak | Approximately 0.579 A at 90% |
| Direct 5 V worst-case allocation | Approximately 0.67 A |
| 5 V continuous envelope | 1.5 A, with 2 A converter capability |
| Main-buck estimated loss | Approximately 0.83 W at 21 V input, 7.5 W output, 90% |
| Main-buck estimated junction rise | Approximately 37 °C at effective 45 °C/W |
| 3.3 V buck estimated loss | Approximately 0.29 W at 0.8 A and 90% |
| TPS22918 loss at 150 mA | Approximately 1.2 mW at 52 mΩ, excluding blocking diode |
| USB input limit | 500 mA upstream; measured startup/radio budget remains mandatory |

Capacitors use at least 100 V on the local protected-input ceramic and 10 V on 5 V and 3.3 V rails. Effective MLCC capacitance after DC bias, temperature, aging, and tolerance must satisfy each regulator datasheet. Inductor saturation ratings include preliminary margin above regulated load but require ripple-current calculation with final frequency and input range.

## Thermal and placement assumptions

- U1 PowerPAD requires a low-impedance exposed-pad connection, copper spreading, and thermal vias.
- TPS2121 and TPS62130 exposed-pad implementations require package-specific land-pattern and via review.
- Keep every input bypass, bootstrap loop, switch node, inductor, output capacitor, and feedback return within the regulator vendor’s recommended placement.
- Keep switching nodes away from battery sense, RF, I2C, supervised inputs, and connector-exposed logic.
- The previous 37 °C main-regulator rise estimate is a target, not evidence. Enclosure testing at maximum ambient and simultaneous load is required.
- Series blocking-diode loss and minimum delivered branch voltage must be included in the final thermal and compatibility review.

## Remaining release blockers

- Exact LMR38020-Q1 suffix, TPS2121 and TPS62130 orderable parts and pin mapping.
- Vendor-tool verification of feedback, RT, soft-start, current-limit, and stability networks.
- TPS2121 transition waveforms for every source connection/removal order.
- Exact inductors, capacitor series, DC-bias derating, ripple, and thermal margins.
- Exact motor/expansion protected-switch selection. TPS2553-Q1 and 287 kΩ are provisional.
- Exact reverse-injection devices and proof that their forward drop preserves the released branch voltage.
- Load-switch rise/discharge timing, QOD energy, short-circuit behavior, and backfeed testing.
- Exact exposed-pad land patterns and thermal-via design, intentionally deferred with all footprints.
- GPIO allocation and reset-low behavior for the four request outputs in Package 04.

## Expected ERC disposition

Repository structural checks pass, but native KiCad ERC was not run because KiCad is unavailable in this environment. Custom preliminary symbols use functional pin groupings and require exact vendor-symbol/pin-number replacement before schematic release. Open-drain PGOOD nodes, intentional unused diagnostic pins, DNP expansion components, and locally named branch-fault nodes may require explicit ERC markers when the released symbols are installed.

## Manual review checklist

- [ ] Verify TPS2121 IN1 priority, OV1/OV2 thresholds, current limit, source drop, and reverse blocking.
- [ ] Verify `+3V3_CORE` setpoint and TPS62130 stability with effective capacitance.
- [ ] Verify `+5V_MAIN` setpoint and LMR38020 operating frequency across 9–21 V.
- [ ] Verify `MAIN_INPUT_VALID` bias cannot phantom-power Sheet 01 or assert without main.
- [ ] Verify `MAIN_POWER_GOOD` assertion/deassertion timing against actuator inhibit requirements.
- [ ] Verify local core PGOOD and Sheet 03 supervisor semantics remain distinct.
- [ ] Verify all four request pull-downs and reset/high-impedance cases.
- [ ] Verify USB-only cannot energize any main-only branch.
- [ ] Verify every output uses the ADR-039 source domain.
- [ ] Verify controlled rise, QOD discharge energy, and collapse order.
- [ ] Verify expansion switch and all associated parts remain DNP by default.
- [ ] Verify branch reverse-injection leakage and blocking-diode voltage loss.
- [ ] Verify U1/U2/U3 and branch-switch thermal margins.
- [ ] Verify capacitor effective capacitance and voltage derating.
- [ ] Verify L1/L2 saturation, ripple, DCR loss, and temperature rise.
- [ ] Verify startup order: source protection, main/core rails, reset, requests, branches.
- [ ] Verify collapse order removes `MAIN_POWER_GOOD` and branches before unsafe logic levels.

## Package handoff

Sheet 02 is ready for formal peer review. After review disposition, the next capture package is **IPC-100 Rev A Preliminary KiCad Capture Package 04 — Sheet 03 ESP32-S3 Core, Programming, Recovery, and Power Requests**.
