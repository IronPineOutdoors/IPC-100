# Engineering Defect Review

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Source review | DFR-01 |
| Date identified | 2026-07-30 |
| Status | **Corrected by ECO-001; pending native ERC confirmation** |
| Severity | **Critical** |
| Affected sheet | 05 — Motor-Driver Logic Interfaces |

## Problem

The Sheet 05 U3 permit/inhibit qualifier is not electrically connected to the local `ACTUATOR_PERMIT` and `MASTER_INHIBIT` labels.

U3 is placed at `(75, 46)`. Its current library definition places:

- pin 1, `PERMIT`, at relative `(-15.24, -7.62)`, producing absolute endpoint `(59.76, 38.38)`;
- pin 2, `INHIBIT`, at relative `(-15.24, -2.54)`, producing absolute endpoint `(59.76, 43.46)`.

The placed labels remain at:

- `ACTUATOR_PERMIT`: `(59.76, 40.92)`;
- `MASTER_INHIBIT`: `(59.76, 46.00)`.

Neither label coincides with its corresponding pin endpoint, and no wire bridges either gap. The hierarchical labels exist elsewhere on the sheet, but their same-name local labels do not attach to U3.

## Severity

**Critical**

The accepted safety architecture depends on Sheet 06 being the sole producer of positive actuator authorization and Sheet 05 asynchronously disabling all motion outputs when authorization is absent or contradictory. With both U3 authorization inputs electrically open, its outputs are not governed by those nets. The downstream 100 kΩ enable pulldowns reduce the chance of assertion but do not establish deterministic behavior for a powered logic device with floating inputs and cannot substitute for the specified Boolean qualification.

This is a functional safety-path defect, not a cosmetic or documentation issue.

## Affected Sheets and Interfaces

- Sheet 05 U3 authorization qualifier.
- Sheet 05 `AXIS1_XLAT_EN` and `AXIS2_XLAT_EN`.
- Sheet 05 safe motion outputs for both axes.
- Future Sheet 06 `ACTUATOR_PERMIT` and `MASTER_INHIBIT` exports.
- Sheet 00 integrated authorization path.
- Future Sheet 09 J2/J3 driver interfaces.

Sheets 00 and 06 have the intended names and ownership; the defect is the pin-level attachment inside Sheet 05.

## Recommended Correction

Create a narrow, controlled schematic repair package after DFR-01:

1. Move the `ACTUATOR_PERMIT` label to U3 pin 1 at `(59.76, 38.38)` or wire that pin to the named net.
2. Move the `MASTER_INHIBIT` label to U3 pin 2 at `(59.76, 43.46)` or wire that pin to the named net.
3. Confirm `+3V3_CORE`, GND, `AXIS1_XLAT_EN`, and `AXIS2_XLAT_EN` remain attached to the intended U3 pins.
4. Visually inspect the rendered sheet.
5. Run native KiCad ERC.
6. Add a repository validation that resolves placed symbol pins and rejects unconnected safety-relevant labels/pins.
7. Verify the U3 truth table, including floating/open input, permit/inhibit disagreement, power-up, power-down, and partial-power states.

Do not redesign the authorization architecture or change ADR-043 to correct this defect.

## Implementation Impact

The correction is localized to Sheet 05 net attachment and validation. It should not require:

- a GPIO change;
- a hierarchy-port change;
- an ADR change;
- a translator architecture change;
- a connector change;
- a Sheet 06 interface change.

Sheet 06 implementation remains blocked until the corrected Sheet 05 has passed peer review and native ERC. No PCB or footprint work has begun, so there is no physical rework impact.

## Closure Evidence Required

- Before/after pin-coordinate or rendered-connectivity evidence. **Coordinate evidence recorded by ECO-001.**
- Native KiCad ERC report with every relevant result dispositioned.
- Automated pin-connectivity validation result. **Repository check added by ECO-001.**
- Confirmed U3 truth table and fail-low/fail-high behavior.
- Follow-up DFR disposition authorizing or continuing to block Sheet 06 entry.

## ECO-001 Disposition

ECO-001 moved `ACTUATOR_PERMIT` to U3 pin 1 at `(59.76, 38.38)` and `MASTER_INHIBIT` to U3 pin 2 at `(59.76, 43.46)`. It added regression checks for exact pin attachment and Sheet 06-to-Sheet 05 producer/consumer ownership without changing logic, polarity, hierarchy, GPIO allocation, or architecture.

DFR-01R independently reviewed the corrected coordinates, label counts, pin functions, root ownership, and regression checks. The original DFR-01-F01 defect is dispositioned **CLOSED PENDING NATIVE ERC**.

DFR-01R identified a separate deterministic-input-default defect, DFR-01R-F11. That finding does not regress ECO-001 and is controlled independently.
