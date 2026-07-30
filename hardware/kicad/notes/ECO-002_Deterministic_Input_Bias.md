# ECO-002 — Deterministic Authorization Input Bias

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Change order | ECO-002 |
| Date | 2026-07-30 |
| Affected sheet | 05 — Motor-Driver Logic Interfaces |
| Finding | DFR-01R-F11 |
| Status | Major finding corrected; pending native ERC and follow-up verification |

## Root cause

ECO-001 electrically attached `ACTUATOR_PERMIT` and `MASTER_INHIBIT` to U3, but both U3 CMOS inputs depended entirely on the future Sheet 06 driver. R1 and R2 biased U3’s `AXIS1_XLAT_EN` and `AXIS2_XLAT_EN` outputs; they did not bias the inputs.

With `+3V3_CORE` present and Sheet 06 absent, unpowered, disconnected, or open-circuit, either U3 input could float. An actively powered U3 output could then oppose the downstream output pulldown, so those output pulldowns alone did not prove a safe state.

## Correction

Sheet 05 now includes:

| Reference | Net | Connection | Default |
| --- | --- | --- | --- |
| R27 | `ACTUATOR_PERMIT` | 100 kΩ to GND | Logic low; authorization absent |
| R28 | `MASTER_INHIBIT` | 100 kΩ to `+3V3_CORE` | Logic high; forced safe |

The U3 function remains:

`AXISn_XLAT_EN = ACTUATOR_PERMIT AND NOT MASTER_INHIBIT`

No signal, polarity, hierarchy port, owner, GPIO, translator, suppression function, connector, footprint, or Sheet 06 object changed.

## Resistor calculations

At `+3V3_CORE = 3.3 V`, either active Sheet 06 output overrides one 100 kΩ bias with:

`I = 3.3 V / 100 kΩ = 33 µA`

Maximum resistor dissipation is:

`P = 3.3² / 100 kΩ = 0.109 mW`

This load is negligible for a normal push-pull or reviewed open-drain/qualified logic driver.

Using a preliminary worst-case input leakage magnitude of 5 µA:

- PERMIT pulldown worst-case highward shift: `5 µA × 100 kΩ = 0.50 V`;
- INHIBIT pullup worst-case lowward shift: `3.3 V - 0.50 V = 2.80 V`.

Those nominal worst-case levels provide useful margin against typical 3.3 V LVC thresholds. Final acceptance still requires the exact U3 orderable device’s input leakage and threshold limits across voltage and temperature. The 100 kΩ value also follows the existing controlled capture rule for active-high permit inputs and downstream enables.

## Expected logic state

| Condition | PERMIT | INHIBIT | U3 enable outputs |
| --- | --- | --- | --- |
| Sheet 06 validly permits | Driven high | Driven low | May assert |
| Sheet 06 denies | Driven low | Driven high | Low |
| Sheet 06 absent/unpowered | R27 low | R28 high | Low |
| Both authorization nets open | R27 low | R28 high | Low |
| PERMIT open only | R27 low | Driven state irrelevant | Low |
| INHIBIT open only | Driven permit; R28 high | High | Low |
| `+3V3_CORE` absent | U3 unpowered; R27 grounds permit; R28 unpowered | No active U3 drive | Output pulldowns low |
| USB-only core power | R27/R28 provide safe input state; motor B-side rails absent | Low |
| Main brownout | Sheet 06 removes permit; R27/R28 retain safe defaults if producer collapses first | Low |
| Processor reset | MCU commands have independent pulldowns; authorization defaults remain safe | Low |

## Startup, reset, and partial-power behavior

- On `+3V3_CORE` rise, R27 requests no permit and R28 asserts inhibit before Sheet 06 actively drives either net.
- If Sheet 06 becomes valid, its outputs override only 33 µA of bias current.
- On Sheet 06 or main-domain collapse, the local biases restore the safe combination.
- USB-only operation can power U3, but its inputs now resolve low/high while both translator B-side supplies remain absent.
- Loss of a translator branch does not affect the bias state or the other branch.
- An external driver is still prohibited from driving IPC-100 signals while IPC-100 is off; exact translator Ioff/backfeed validation remains open.

## Validation

- Confirmed R27 is the only `U3 PERMIT fail-low input bias` and connects `ACTUATOR_PERMIT` to GND.
- Confirmed R28 is the only `U3 INHIBIT fail-high input bias` and connects `MASTER_INHIBIT` to `+3V3_CORE`.
- Confirmed ECO-001 label-to-U3 pin attachments remain unchanged.
- Confirmed U3 output pulldowns R1/R2 remain present.
- Confirmed Sheet 06 producer and Sheet 05 consumer directions remain unchanged.
- Confirmed opposing-PWM suppression, translator topology, signal names, hierarchy, and GPIO allocation remain unchanged.
- Ran repository hierarchy, GPIO, balance, UUID, reference, rejected-interface, and zero-footprint checks.

Native KiCad ERC is unavailable in the execution environment. ERC remains pending and no ERC closure is claimed.

## Remaining blockers

- Native ERC and exact U3 vendor-symbol/pin audit.
- Exact U3 leakage and VIH/VIL verification over supply and temperature.
- Sheet 04 threshold, hysteresis, partial-power, and passive STOP fail-high proof.
- Sheet 05 translator/logic Ioff, timing, ESD, and external-driver validation.
- Power-path source-transition, backfeed, and qualification timing tests.
- Follow-up DFR-01R disposition before Package 07 authorization.

## Readiness

DFR-01R-F11 is corrected at preliminary capture level. ECO-002 is pending verification and does not independently authorize Sheet 06.
