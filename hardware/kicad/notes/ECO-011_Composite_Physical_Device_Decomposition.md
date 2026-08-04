# ECO-011 — Composite Physical Device Decomposition and Annotation

| Field | Value |
| --- | --- |
| Platform | IPC-100 Rev A Engineering Prototype Path |
| Review date | 2026-08-03 |
| Trigger | EPP-01A one-physical-device/one-reference finding |
| Scope attempted | Sheets 04–07 composite physical decomposition |
| CAD changes | None; decomposition stopped before schematic edit |

## 1. Scope

ECO-011 audited every project-local functional block and every EPP-01A composite candidate against the rule that one physical component equals one schematic reference, one EBOM row and one future footprint. It also reviewed nearby support passives, physical-device candidates, hierarchy, GPIO, safety, motion and watchdog contracts.

## 2. EPP-01A Finding

EPP-01A correctly identified a physical-representation defect. Several symbols are functional specifications rather than selectable components. Their pins describe external behavior, but their internal gates, device boundaries, supply pins, unit allocation, unused-unit disposition and package-local decoupling are absent. Footprint assignment would therefore invent circuitry.

ECO-011 is permitted to implement a released physical solution; it is not permitted to choose an unreviewed safety or authorization topology implicitly. Current records do not release the gate-level implementation needed to make the transformation deterministic.

## 3. Composite Inventory

| Current reference(s) | Sheet | Classification | Hidden physical content | Minimum known physical count | Support-passive implication | Safety relevance | Why decomposition is blocked |
| --- | --- | --- | --- | ---: | --- | --- | --- |
| U401AB, U401CD, U402AB, U402CD | 04 | `MULTI-COMPARATOR OR MULTI-LOGIC FUNCTION` | Two threshold comparators plus combine/Schmitt logic per row | ≥2 device families per row; package sharing unresolved | Per-package bypass; unused comparator/gate handling | High—four limit loops | Comparator/gate allocation and exact Boolean/polarity netlist absent |
| U403AB | 04 | `MULTI-COMPARATOR OR MULTI-LOGIC FUNCTION` | STOP window comparators plus combine/Schmitt logic | ≥2 device families | Bypass and unused units | Critical—STOP path | Exact physical combine path and package sharing absent |
| U403C, U403D | 04 | `MULTIPLE ACTIVE DEVICES` | Low-active receiver plus `FIELD_OK` authorization gate | ≥2 functions each | Bias/bypass and unused units | High—ARM/FIRE | Gate truth table and physical unit sharing absent |
| U501, U502 | 05 | `MULTI-COMPARATOR OR MULTI-LOGIC FUNCTION` | Inversion, opposing-PWM suppression and enable pass-through | Multiple logic units per axis | Per-package bypass; unused gates | Critical—motion suppression | Exact gate realization, propagation assumptions and package allocation absent |
| U503 | 05 | `MULTI-COMPARATOR OR MULTI-LOGIC FUNCTION` | Permit/inhibit authorization, inversion and disagreement-safe behavior | Multiple logic units unless one exact function is selected | Existing R527/R528 plus package bypass | Critical—motion authorization | Exact Boolean circuit and package/pin map absent |
| U601 | 06 | `WATCHDOG COMPOSITE` | Window watchdog, two-edge startup qualifier, validity storage/latch and reset behavior | At least watchdog plus qualifier/storage implementation | Timing, reset, bias and per-package bypass | Critical—independent authorization | No exact watchdog/order code or released qualifier/latch circuit |
| U602 | 06 | `MULTI-COMPARATOR OR MULTI-LOGIC FUNCTION` | Four-condition fail-safe authorization | Multiple gates or one unselected programmable/fixed function | Bias and bypass | Critical—master authorization | Gate-level equation, hazard analysis and package allocation absent |
| U603 | 06 | `VALID MULTI-UNIT SINGLE PACKAGE` candidate | Two-input relay command AND | One single gate is feasible | One package bypass | High—relay authorization | Exact part/package/pin map not selected; not intrinsically composite |
| U701 | 07 | `SENSOR OR ENCODER CONDITIONING COMPOSITE` | Three Schmitt/debounce channels and UI-valid gating | Multiple logic units; existing RC rows may cover only part | Verify R/C allocation and package bypass | Low for safety; functional UI | Channel-level netlist, gate allocation and bounce target absent |
| U703 | 07 | `STATUS DRIVER COMPOSITE` | Four discrete 60 V MOSFET channels plus gate networks and buzzer clamp provision | Four transistors, not one IC row | Gate resistors/pull-downs and clamp mapping | Non-safety but startup-state relevant | Required Q references and channel mapping do not exist |
| U704, U705 | 07 | `DOCUMENTATION-ONLY BLOCK` | External OLED and sensor module boundaries | Zero board components | None on board | Non-safety | Correctly documentation-only; must not receive footprints |

Other reviewed functional symbols have exact non-composite routes but remain selection-blocked: U404/U405 single Schmitt buffers; U504/U505 four-bit translators; U702 I²C expander; U706/U707 dual-supply buffers; U802 I²C segment buffer; U204/U205 power qualification logic. They do not justify new references until exact order codes and symbols are released.

## 4. Decomposition Policy

The physical implementation shall be selected in this order: a single exact IC where it implements the complete required truth table; a standard multi-unit exact package with all units and power unit shown; multiple exact packages; then discrete devices. Package sharing across logical channels is permitted only after common-cause, partial-power, unused-unit and failure-effect review. A composite symbol may not survive as a populated row.

## 5. Reference Allocation

No new reference is allocated in this incomplete ECO because the required package count is unknown. Allocating references before device/unit selection would create another false physical baseline. Existing composite numbers shall be retired—not reused—when replacements are implemented. New references must use unused Sheet 04–07 ranges and be added to the Reference Designator Register with predecessor and ECO trace.

## 6. Safety-Window Decomposition

The five-loop ADR-042 contract is preserved: excitation, protection/filtering, low/high threshold detection, valid-window combination, fail-safe polarity and local diagnostics. Current external pins alone do not specify whether LM339 outputs are combined by inversion, NAND/NOR logic, wired open-collector behavior or additional gating, nor how three quad packages and one or more logic packages should be shared. These choices affect startup, stuck-output, partial-power and common-cause failure behavior.

Required before edit: release a per-loop Boolean/polarity table; exact comparator and logic order codes; comparator/gate unit allocation; supply/power units; unused-input biases; output pull-ups; hysteresis ownership; and pin-numbered interconnect.

## 7. Motion-Interlock Decomposition

ADR-043’s eight MCU inputs/outputs, fail-low authorization and opposing-PWM rejection remain frozen. The text equation does not select the inverter/AND topology or establish whether enable paths are buffered, gated or simply passed. Exact propagation behavior matters during reversal and authorization loss.

Required before edit: a pin-level truth table for each axis, exact device families/order codes, gate count/unit allocation, propagation/interlock acceptance, power-off behavior and pin-numbered connection schedule. U504/U505 translator ownership remains unchanged.

## 8. Watchdog Decomposition

ADR-044 remains frozen: GPIO42 service, GPIO37 reserved, 40–100 ms valid service window, ≤250 ms timeout, two qualifying edges and fail-safe loss of `WATCHDOG_VALID`. U601 does not identify an exact IC that provides all of these functions, and the repository contains no released discrete qualifier/latch state diagram or reset network.

Required before edit: exact watchdog MPN and mode, timing calculation, qualifier/latch state table, startup/reset/brownout behavior, deterministic bias, output type, supply/partial-power behavior, unit allocation and pin-numbered netlist.

## 9. Authorization Decomposition

`STOP_HW_INHIBIT`, `MAIN_POWER_GOOD`, `WATCHDOG_VALID`, `ACTUATOR_PERMIT` and `MASTER_INHIBIT` ownership and polarity remain unchanged. U602 and U503 lack exact gate-level realizations. ECO-001/ECO-002 attachment and fail-low/fail-high defaults must be preserved.

Required before edit: Boolean equations including every invalid/unknown input state, exact gates/buffers/inverters, power-off truth behavior, unit allocation, unused-unit treatment, relay gate interaction and a stuck-high/stuck-low failure table.

## 10. Encoder Conditioning

U701 hides three conditioning channels. Existing descriptions mention 10 kΩ/1 kΩ/10 nF and UI-valid gating but do not bind each passive to a pin-level circuit or specify whether debounce is analog, Schmitt-only or firmware-assisted. Required before edit: channel schematics, exact logic device, thresholds, pull direction, filter topology, ESD ownership, bounce target and I²C-expander pin mapping.

## 11. Status Drivers

U703 explicitly describes four physical MOSFETs behind one U reference. It must be retired and replaced by four Q references unless one exact qualified quad-MOSFET package is deliberately selected. RGB/buzzer channel current, gate resistor/pull-down mapping, buzzer clamp and startup state must be released first. Q701 OLED-reset remains a separate existing transistor and is unaffected.

## 12. Other Composite Functions

The audit found no basis to decompose exact one-package power devices, USB protection arrays, I²C buffers or translators merely because their symbols are project-local. DFT1 and U704/U705 are intentional documentation-only boundaries. DNP shell and expansion provisions remain separate rows. Exact selection is still required later, but it is a physical-selection blocker rather than hidden circuitry.

## 13. Support Passive Mapping

Existing passives cannot be assumed complete for new packages. Every added IC requires package-local bypass; every unused input needs deterministic treatment; and every threshold, hysteresis, timing, gate, pull, filter and clamp element needs its own reference. The selected topology must first produce a component schedule so unused Sheet 04–07 R/C/D/Q ranges can be allocated without collisions.

## 14. Symbol and Pin Mapping

No physically accurate symbol can be created until the exact device or at least a pin-compatible physical class is approved. The follow-up must record pin name, number, electrical type, supply, enable/reset, unused pin and no-connect status for every unit. No hidden power pins are permitted. Footprints remain blank.

## 15. Population Register Changes

The 313-row EPP-01A register remains current. Composite rows remain `BLOCKED - PHYSICAL DEFINITION REQUIRED`; documentation-only rows remain non-board. No row is retired because no replacement references exist. Prior total: 313; new total: 313; added physical rows: 0; retired composite rows: 0; remaining blocked rows: 286.

## 16. EBOM/AVL Reconciliation

No EBOM/AVL row is changed. Retiring a composite without simultaneously adding its physical replacements would make the BOM less accurate. Candidate MPNs and all existing block statuses are preserved. Footprints remain empty and CSV/XLSX remain under their existing deterministic generators.

## 17. Failure-Mode Regression

No circuit was changed, so hierarchy and functional behavior regressions remain unchanged. A future implementation must explicitly review unpowered, stuck-high, stuck-low, open/short input, passive open/short, supply loss, partial power, startup, reset and brownout cases. Acceptance requires no new actuator authorization, no floating safety input, no firmware dependency and no backfeed path.

## 18. Validation Results

Targeted validation confirms the complete composite inventory, required follow-up inputs, unchanged 313-row population, zero schematic changes, zero footprints and no PCB files. Existing hierarchy/GPIO/interface and repository validators remain required at close.

## 19. Native ERC Status

Native ERC is not required for this no-CAD incomplete package. It remains required after physical symbols and connectivity are implemented. Structural validation is not a substitute.

## 20. Remaining Physical-Definition Blockers

All composite references in Section 3 remain. The smallest follow-up is **ECO-011A — Composite Device Selection, Truth-Table, and Pin-Mapping Release**. ECO-011A shall choose exact devices, publish Boolean/state tables, allocate package units and pins, specify unused-unit/power/bypass handling, and produce the replacement reference schedule. It is a narrow design-input package, not a footprint package or broad release review.

## 21. Manual Review Checklist

- [ ] Five safety loops have released comparator/gate unit and pin allocation.
- [ ] Motion interlocks have released Boolean equations and propagation behavior.
- [ ] Watchdog has exact MPN, timing and qualifier/latch state table.
- [ ] Authorization gates cover invalid/unknown and partial-power states.
- [ ] Encoder channels have explicit R/C/protection/gate circuits.
- [ ] Four status outputs have individual physical transistor mappings.
- [ ] Every package has power unit, bypass and unused-unit treatment.
- [ ] Replacement references use unused ranges and preserve retired history.
- [ ] EBOM/AVL and population register reconcile one physical part per row.
- [ ] Hierarchy, GPIO, ADR/ICD contracts and zero-footprint state pass regression.

## Final Decision

# ECO-011 INCOMPLETE

ECO-011A — Composite Device Selection, Truth-Table, and Pin-Mapping Release is required before schematic decomposition can proceed. EPP-01A-R and EPP-02 are not authorized. Placement, routing and fabrication remain unauthorized.

> **ECO-011A1 disposition (2026-08-03):** Sheet 04 decomposition stopped before CAD modification. LM339B-Q1 on the captured 3.3 V supply guarantees common-mode only through 1.3 V over temperature, which cannot cover the nominal 2.5 V healthy state or 4.0 V upper threshold. QER-04 is required before decomposition resumes.

> **QER-04 disposition (2026-08-03):** QER-04 resolved the Sheet 04 input-range blocker with a direct-input TLV7044-Q1-class architecture on the existing field rail and authorizes ECO-011A1R only. Other composite categories and ECO-011A2 remain blocked.
