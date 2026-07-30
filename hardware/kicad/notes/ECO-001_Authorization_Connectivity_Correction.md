# ECO-001 — Authorization Connectivity Correction

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Change order | ECO-001 |
| Date | 2026-07-30 |
| Affected sheet | 05 — Motor-Driver Logic Interfaces |
| Defect source | DFR-01-F01 |
| Status | Corrected; pending native ERC confirmation |

## Root cause

Package 06R revised the custom U3 authorization symbol to separate its `+3V3` and GND pins. That change moved U3 input pin 1 `PERMIT` and pin 2 `INHIBIT`, but the existing local net labels were not moved with the pins. Repository validation checked hierarchy names and symbol presence but did not check label-to-pin coordinate attachment.

The resulting locations were:

| Net | U3 pin endpoint | Defective label location | Offset |
| --- | --- | --- | --- |
| `ACTUATOR_PERMIT` | `(59.76, 38.38)` | `(59.76, 40.92)` | 2.54 mm |
| `MASTER_INHIBIT` | `(59.76, 43.46)` | `(59.76, 46.00)` | 2.54 mm |

## Corrective action

Only the two displaced Sheet 05 labels were moved:

- `ACTUATOR_PERMIT` now attaches to U3 pin 1 `PERMIT` at `(59.76, 38.38)`.
- `MASTER_INHIBIT` now attaches to U3 pin 2 `INHIBIT` at `(59.76, 43.46)`.

No wire, component, logic function, polarity, signal name, sheet port, GPIO, hierarchy owner, translator, suppression function, or power domain changed.

## Connectivity audit

The corrected authorization path is:

1. Sheet 06 owns output ports `ACTUATOR_PERMIT` and `MASTER_INHIBIT`.
2. Sheet 00 connects each Sheet 06 output by identical functional net name to the corresponding Sheet 05 input.
3. Sheet 05 has exactly one hierarchical input label for each net.
4. Same-name Sheet 05 local labels attach directly to U3 pins 1 and 2.
5. U3 implements `EN = ACTUATOR_PERMIT AND NOT MASTER_INHIBIT`.
6. U3 outputs attach to `AXIS1_XLAT_EN` and `AXIS2_XLAT_EN`.
7. Each enable has a 100 kΩ default-off pulldown and reaches the corresponding translator enable pin.

Polarity remains:

- `ACTUATOR_PERMIT`: active high; absent/low means disabled.
- `MASTER_INHIBIT`: active high; asserted/high means disabled.
- Permit/inhibit disagreement disables both translator branches.

## Schematic changes

Modified:

- `hardware/kicad/sheets/05_Motor_Interfaces.kicad_sch`
  - moved two local labels to their existing U3 input pin endpoints.

Not modified:

- Sheet 00;
- Sheet 06;
- any ADR or ICD;
- any GPIO allocation;
- any footprint or PCB file.

## Validation performed

- Root/child hierarchy names, directions, and uniqueness checked.
- Sheet 06 producer and Sheet 05 consumer ownership checked for both authorization nets.
- U3 controlled placement and input-pin definitions checked.
- Exact local-label attachment at both U3 input pin endpoints checked.
- Both U3 authorization output nets and translator enable destinations audited.
- Schematic S-expression balance, UUID uniqueness, reference uniqueness, GPIO allocation, rejected-interface rules, and zero-footprint scope checked.
- Repository diff reviewed to confirm no architecture, Sheet 06, footprint, or PCB change.

Native KiCad ERC was not available in the execution environment. ECO-001 therefore remains **pending native ERC confirmation** and follow-up DFR review.

## Remaining release blockers

ECO-001 corrects DFR-01-F01 only. It does not close:

- native KiCad ERC and released-symbol pin audit;
- Sheet 04 threshold, hysteresis, partial-power, and passive STOP fail-high proof;
- Sheet 05 exact translator/logic selection, Ioff, propagation, minimum-pulse, ESD, and external-driver validation;
- power-path source-transition, backfeed, thermal, and qualification timing verification;
- Sheet 06 watchdog, permit, inhibit, relay gating, timing, and single-fault implementation review.

## Readiness

The Critical pin-level connectivity defect is corrected. IPC-100 is suitable for a DFR-01 reissue or formal follow-up disposition. ECO-001 does not itself authorize Sheet 06 implementation.
