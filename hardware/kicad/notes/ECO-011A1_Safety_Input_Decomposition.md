# ECO-011A1 — Safety Input Composite Device Decomposition

| Field | Value |
| --- | --- |
| Platform | IPC-100 Rev A Engineering Prototype Path |
| Review date | 2026-08-03 |
| Scope | Sheet 04 `IPC100:WINDOW` and `IPC100:CMDREC` physical decomposition |
| Result | Stopped before schematic modification |
| Footprints / PCB | None |

## 1. Scope

ECO-011A1 evaluated replacement of U401AB, U401CD, U402AB, U402CD and U403AB (`IPC100:WINDOW`) plus U403C/U403D (`IPC100:CMDREC`) with explicit comparator, logic, pull-up, bypass, power and unused-unit representations. Hierarchy, GPIO, external nets, thresholds, polarity, ADR-042 and the five-loop contract were treated as immutable.

## 2. Composite Symbols Removed

None. The package stopped before CAD modification because exact-device analysis exposed a contradiction between the mandated LM339B-Q1 implementation, the captured supply rail and the released input thresholds. Removing the symbols without an approved replacement would degrade the released design record.

## 3. Physical Devices Added

None. The intended physical inventory would require ten comparator channels for the five supervised windows, two further receiver channels for ARM/FIRE, output pull-ups, combine/qualification logic, local bypass components, package power units and deterministic unused-unit handling. Exact package count and reference allocation depend on resolving the electrical incompatibility below.

## 4. Reference Mapping

| Existing reference | Function | Present status | Replacement references |
| --- | --- | --- | --- |
| U401AB | STOP window | Retained; physically blocked | Not allocated |
| U401CD | LEFT limit window | Retained; physically blocked | Not allocated |
| U402AB | RIGHT limit window | Retained; physically blocked | Not allocated |
| U402CD | UP limit window | Retained; physically blocked | Not allocated |
| U403AB | DOWN limit window | Retained; physically blocked | Not allocated |
| U403C | ARM receiver + `FIELD_OK` gate | Retained; physically blocked | Not allocated |
| U403D | FIRE receiver + `FIELD_OK` gate | Retained; physically blocked | Not allocated |

No reference is retired or reused. The Reference Designator Register therefore remains structurally unchanged.

## 5. Pin Mapping

The current `IPC100:WINDOW` pins are functional abstractions: `SENSE`, `VLOW`, `VHIGH`, `FIELD_OK`, `+3V3`, `GND`, `ASSERTED` and `FAULT`. They are not LM339B-Q1 package pins. `IPC100:CMDREC` similarly exposes `SENSE`, `FIELD_OK`, `+3V3`, `GND` and `ACTIVE`, not a comparator-plus-gate package mapping.

The embedded symbol and each instance explicitly associate the window function with `LM339B-Q1 dual threshold + SN74LVC14A-Q1 combine` while connecting the active block to `+3V3_CORE`. TI specifies LM339B common-mode input range from the negative rail through `(V+) − 1.5 V` at 25 °C and only through `(V+) − 2.0 V` over −40 °C to +125 °C. Source: TI LM339B/LM2901B datasheet, `https://www.ti.com/lit/ds/symlink/lm239.pdf`.

Consequences:

- at 3.3 V supply, guaranteed full-temperature common-mode maximum is 1.3 V;
- the released healthy value is nominally 2.5 V and is outside that range;
- the released upper threshold/input is 4.0 V and is also above the comparator supply;
- moving LM339B to the existing 5 V field rail would still guarantee only 3.0 V full-temperature common-mode and therefore would not validate the 4.0 V comparison;
- the SN74LVC14A-Q1 logic itself can operate from 2–3.6 V and tolerate inputs through 5.5 V, but it cannot correct an invalid comparator input stage.

No manufacturer-valid LM339B pin mapping can preserve the current `+3V3_CORE` supply and directly compare the released 2.5 V/4.0 V nodes. Assigning LM339 pins would knowingly create an electrically invalid schematic.

## 6. Truth-Table Preservation

The released external behavior is clear and remains unchanged:

| State | Sense condition | Conditioned STOP/limit output | Local fault | `STOP_HW_INHIBIT` consequence |
| --- | --- | --- | --- | --- |
| Healthy | 1.00 V < sense < 4.00 V | Low/inactive | Low | Inactive for STOP |
| Low/short/asserted | sense < 1.00 V | High/asserted | High | High for STOP |
| High/open/asserted | sense > 4.00 V | High/asserted | High-window observation | High for STOP |
| Field/main loss or startup | `FIELD_OK` low/unknown | Conservative high for STOP/limits | Conservative | High |

ARM/FIRE remain active high only for the requested contact state while `FIELD_OK` is valid; field/main loss forces both inactive. A future circuit must implement this table without relying on out-of-range comparator behavior.

## 7. Failure-Mode Review

Proceeding with LM339B on 3.3 V would make healthy, high-window, slow-ramp and partial-power behavior unspecified. An unspecified comparator output could falsely assert, fail to assert, oscillate or depend on device/temperature. For STOP this may destroy confidence in the independent inhibit; for limits it may invalidate the directional observation; for ARM/FIRE it may permit or suppress a request unpredictably.

This is not a production-margin concern. It is a Category A prototype-validity issue. No safe failure-mode regression can be claimed until the comparator input range is valid at all released thresholds and supplies.

## 8. Validation Results

- Sheet 04 remains byte-for-byte unmodified by ECO-011A1.
- No references, UUIDs, hierarchy ports, GPIO assignments, nets, thresholds, polarities, ADRs or ICDs changed.
- Zero footprints remain assigned and no PCB file exists.
- The 313-row prototype population register and current EBOM/AVL remain unchanged because no physical replacements exist.
- Native ERC is not required for this no-CAD package; it cannot resolve the analog common-mode incompatibility.
- Targeted and repository validation are required at package close.

## 9. Remaining ECO-011 Work

All seven Sheet 04 composites remain. The smallest required follow-up is **QER-04 — Safety Comparator Input-Range and Threshold Implementation Resolution**. It shall select one of the following without changing the external five-loop contract:

1. an exact comparator whose supply, common-mode range, input absolute maximum, output type and partial-power behavior cover 0–5 V field sensing while interfacing safely to 3.3 V logic;
2. a released input-scaling/reference network that keeps the comparator inside guaranteed range while preserving the external 1.00 V and 4.00 V thresholds; or
3. another pin-level implementation with equivalent thresholds, polarity and fail-safe behavior.

QER-04 must release worst-case thresholds, hysteresis, tolerance, startup/field-loss behavior, comparator/logic order codes and the physical unit/pin allocation needed to resume ECO-011A1. It is a narrow electrical implementation resolution, not an architecture or connector change.

## Final Decision

# ECO-011A1 INCOMPLETE

QER-04 — Safety Comparator Input-Range and Threshold Implementation Resolution is required before Sheet 04 physical decomposition. ECO-011A2, EPP-01A-R and EPP-02 are not authorized. No PCB activity is authorized.
