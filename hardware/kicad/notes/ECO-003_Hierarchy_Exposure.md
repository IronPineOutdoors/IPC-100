# ECO-003 — Sheet 09 Hierarchy Exposure

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Date | 2026-07-30 |
| Status | Complete |
| Change class | Minimal hierarchy/interface correction |

## Scope

ECO-003 exposes the four ICD-002-approved J6/J7 I²C interface names from their existing Sheet 07 peripheral boundary points through Sheet 00 to Sheet 09. It does not implement Sheet 09, add a connector, or introduce a new electrical function.

## Hierarchy changes

Sheet 07 now exports the existing OLED and sensor bus boundary points under their connector-facing staged names. Sheet 00 provides one Sheet 07 endpoint and one Sheet 09 endpoint for each name. Sheet 09 terminates the four routes as hierarchy ports only.

No alternate signal path, duplicate producer, or orphan port was created.

## Signals exposed

| Signal | Sheet 07 direction | Sheet 09 direction | Existing electrical source |
| --- | --- | --- | --- |
| `J6_I2C_SDA` | Bidirectional | Bidirectional | Sheet 07 OLED/base-bus boundary |
| `J6_I2C_SCL` | Output | Input | Sheet 07 OLED/base-bus boundary |
| `J7_I2C_SDA` | Bidirectional | Bidirectional | Sheet 07 sensor/base-bus boundary |
| `J7_I2C_SCL` | Output | Input | Sheet 07 sensor/base-bus boundary |

## Affected sheets

- Sheet 00, top-level hierarchy
- Sheet 07, UI/OLED/sensor functional boundary
- Sheet 09, connectors/test-access hierarchy placeholder

No other schematic sheet changed.

## Validation

- Root/child hierarchy names and directions match.
- Each new net has exactly two top-level endpoints: Sheet 07 and Sheet 09.
- No duplicate producer or orphan hierarchy port exists.
- GPIO allocation validation passes; GPIO37 remains reserved and GPIO42 remains `WATCHDOG_SERVICE_MCU`.
- S-expression balance, UUID uniqueness, reference uniqueness, and zero-footprint checks pass.
- All 54 frozen Sheet 09 ports remain present; the four ECO-003 ports bring the controlled total to 58.
- `git diff --check` passes.
- Native KiCad ERC is pending because `kicad-cli` is unavailable in the current environment.

## Risk assessment

The change is limited to hierarchy exposure and therefore does not alter voltage, polarity, timing, ownership, startup behavior, or fault behavior. The principal regression risk is a misspelled, duplicated, or directionally inconsistent port; repository validation now checks the four routes explicitly.

The independent power-qualified/fail-isolated branch circuitry required by ICD-002 remains a Package 10R implementation constraint. ECO-003 does not select or add that circuitry because this order authorizes hierarchy exposure only.

## No-change declarations

ECO-003 does not:

- change GPIO allocation or consume GPIO37;
- change GPIO42 or watchdog behavior;
- alter safety, motion, relay authorization, power architecture, or Sheet 08 segmentation;
- add connectors, components, footprints, or PCB content;
- modify an accepted ADR; or
- begin Sheet 09 implementation.

## Final decision

**ECO-003 COMPLETE — PACKAGE 10R AUTHORIZED**
