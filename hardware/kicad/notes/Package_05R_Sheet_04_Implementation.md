# Package 05R — Sheet 04 Implementation Record

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Package | 05R |
| Sheet | 04 — Safety Inputs, Interlocks & External Sense Interfaces |
| Authority | ADR-039 through ADR-042 |
| Date | 2026-07-30 |
| Status | Preliminary capture complete; schematic release blocked by analysis and part selection |

## Implemented channels

Sheet 04 implements the complete ADR-042 inventory:

- five individually returned supervised NC loops: STOP, left, right, up, and down;
- two main-only NO command inputs: ARM and FIRE;
- one independent active-high `STOP_HW_INHIBIT` export;
- seven active-high conditioned processor observations; and
- five active-high local electrical-fault/test nodes.

No guard, lid, home, ready, external-enable, remote-inhibit, or permission input was added.

## Supervised-loop topology

Each safety loop uses:

1. `FIELD_SENSE_VCC` through 2.20 kΩ ±1% to the raw loop conductor;
2. a remote 2.20 kΩ ±1% EOL resistor at the NC field contact;
3. an individually routed return tied to controlled common ground on Sheet 04;
4. low-capacitance connector-entry ESD/clamp provision;
5. 1.00 kΩ ±1% protected series resistance and 100 nF filtering;
6. two LM339B-Q1 comparator channels against 1.00 V and 4.00 V references;
7. SN74LVC14A-Q1-class hysteretic/fault combining into an active-high conservative output; and
8. a local active-high fault node that is not exported to firmware.

Three LM339B-Q1 packages provide the twelve comparator channels: ten for the five windows and two for ARM/FIRE. The capture shows logical multi-unit slices; package/unit mapping requires native KiCad review before release.

## Threshold and current calculations

The five-section 10.0 kΩ ±0.1% ladder draws:

`5.0 V / 50.0 kΩ = 100 µA`

It produces nominal 1.00 V and 4.00 V comparison references. Comparator loading, rail tolerance, resistor tolerance, clamp leakage, temperature, and hysteresis must be included in the release analysis.

For every supervised loop:

- healthy current: `5.0 V / (2.20 kΩ + 2.20 kΩ) = 1.136 mA`;
- healthy sense voltage: `1.136 mA × 2.20 kΩ = 2.50 V`;
- short current: `5.0 V / 2.20 kΩ = 2.273 mA`;
- remote EOL dissipation: `2.50² / 2.20 kΩ = 2.84 mW`; and
- five simultaneous nominal shorts: `5 × 2.273 mA = 11.36 mA`.

The 1 kΩ/100 nF filter has nominal:

`τ = R × C = 1,000 × 100 nF = 100 µs`

The 10–90% first-order transition is approximately 220 µs. Comparator and logic propagation are negligible against the 5 ms STOP hardware budget, but the complete tolerance and slow-ramp behavior remain subject to analysis.

## Protection and command topology

Each field node has current limiting, a low-capacitance ESD/clamp provision, protected series impedance, and RC filtering. Protection is referenced to the common logic ground established by ADR-035. External battery/VIN injection remains outside the released field contract.

ARM and FIRE use 10.0 kΩ main-only field bias, 1 kΩ/100 nF filtering, a deterministic 100 kΩ field-off pull-down, LM339B-Q1 receiver channels, and `FIELD_OK` gating. The gate forces both outputs inactive when `FIELD_SENSE_VCC` is absent, including USB-only operation. No raw field node connects directly to an ESP32 input.

## Fault-state matrix

| Condition | Supervised sense | Conditioned output | Local fault | STOP hardware result |
| --- | ---: | --- | --- | --- |
| Healthy NC + EOL | 2.50 V nominal | Low/inactive | Low | Permit may qualify |
| Intentional opening | >4.00 V | High/asserted | Context-dependent local high-window state | Inhibit high |
| Wire open | >4.00 V | High/asserted | High-window service observation | Inhibit high |
| Short to return | <1.00 V | High/asserted | High | Inhibit high |
| Short to field source | >4.00 V | High/asserted | High-window observation | Inhibit high |
| Invalid window or startup | Outside healthy proof | High/asserted | High | Inhibit high |
| Main/field-source loss | FIELD_OK low / conservative default | STOP/limits high; commands low | Conservative | Inhibit high |
| USB-only core power | Field source off | STOP/limits high; ARM/FIRE low | Conservative | Inhibit high |

Open actuation and broken wire share the approved conservative processor observation. Electrical subtype remains available only through local analog/fault test access.

## Exports

Sheet 03 receives only:

- `STOP_IN_COND`
- `LIMIT_LEFT_COND`
- `LIMIT_RIGHT_COND`
- `LIMIT_UP_COND`
- `LIMIT_DOWN_COND`
- `ARM_IN_COND`
- `FIRE_IN_COND`

Sheet 06 receives only `STOP_HW_INHIBIT`.

`STOP_FAULT`, four `LIMIT_*_FAULT` nodes, and `FIELD_OK` remain local. `INPUT_FAULT_SUMMARY` is not adopted. The rejected orphan fault and summary hierarchy ports were removed from Sheet 00 and Sheet 04. No GPIO number appears on Sheet 04.

`ACTUATOR_PERMIT` and `MASTER_INHIBIT` remain exclusively owned by Sheet 06 and were not modified.

## Timing and debounce

- Hardware RC: 100 µs nominal per channel.
- Local window detection target: settled within 2 ms.
- STOP hardware path: `STOP_HW_INHIBIT` asserted and actuator permit removed within 5 ms.
- Firmware STOP assertion qualification: ≤2 ms; release: 20 ms stable.
- Firmware limit assertion qualification: ≤5 ms; release: 20 ms stable.
- ARM/FIRE: 10 ms stable with release-before-retrigger.

Firmware qualification does not delay the independent STOP hardware path.

## Remaining implementation and release blockers

- Complete worst-case 1 V/4 V threshold and hysteresis analysis over rail, resistor, comparator, leakage, cable, and temperature tolerance.
- Run SPICE on healthy/open/short transitions, slow ramps, bounce, brownout, and field/core power sequencing.
- Confirm the logical multi-unit LM339 mapping and the exact orderable Q1 suffix.
- Select the exact low-capacitance clamp array and verify ESD/clamp current with final layout.
- Verify the SN74LVC14A-Q1 combining and SN74LVC1G17-Q1 field/STOP stages for partial-power/Ioff behavior.
- Prove passive fail-high STOP behavior for loss of every Sheet 04 supply and single open connection.
- Complete native KiCad ERC and resolve expected power-input/open-collector warnings.
- Validate the released 10 m/2 nF harness and ≤5 ms STOP response on prototype hardware.

No footprint or PCB-layout release is implied.

## ERC status

Native `kicad-cli` was unavailable, so ERC was not run. Repository S-expression, hierarchy, GPIO, reference, UUID, footprint, and scope checks were run instead. ERC remains mandatory before schematic release.

## Manual review checklist

- [x] Five 2.20 kΩ supervised NC loop excitations present.
- [x] Five independent loop returns preserved.
- [x] Five 1 kΩ/100 nF protected filters present.
- [x] Five dual-threshold window slices present.
- [x] ARM/FIRE are main-only and field-valid gated.
- [x] Seven ADR-040 functional processor exports only.
- [x] One independent STOP hardware export only.
- [x] Local diagnostic nodes have no processor GPIO.
- [x] USB-only field excitation is impossible.
- [x] No connector, footprint, motor, relay, or PCB object added.
- [ ] Worst-case threshold/SPICE review approved.
- [ ] Native KiCad ERC approved.

## Handoff

Sheet 04 is complete for preliminary capture and ready for peer review. Subject to review disposition, the recommended next package is **IPC-100 Rev A Preliminary KiCad Capture Package 06 — Sheet 05 Motor Driver Interfaces, Position Feedback & Motion-Control Signals**.

