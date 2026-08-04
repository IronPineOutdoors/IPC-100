# ECO-011A2 — Motion Control Physical Decomposition

## 1. Scope

ECO-011A2 replaces only Sheet 05 composites U501, U502 and U503 with physical logic. It does not change hierarchy, GPIO, ADR-043, Sheet 06 ownership, translators U504/U505, footprints, PCB content or external interfaces.

## 2. Current Sheet Audit

Baseline `3590bec` contained U501/U502 `IPC100:INTERLOCK4` and U503 `IPC100:AUTH2`; eight `_MCU` inputs, U504/U505 independent translator branches, R503–R526 command/output defaults and damping, D501–D508 protection, and R527/R528 authorization biases were intact. No partial physical decomposition, PAN/TILT/shared-speed net, limit/home/ready/fault input or output-fault summary existed.

Affected nets are the eight `AXIS1/2_*_MCU` inputs; `AXIS1/2_RPWM_QUAL`, `AXIS1/2_LPWM_QUAL`, `AXIS1/2_REN_QUAL`, `AXIS1/2_LEN_QUAL`; `ACTUATOR_PERMIT`, `MASTER_INHIBIT`, `AXIS1/2_XLAT_EN`; and the unchanged translator/safe output nets.

## 3. Released Motion Truth Tables

For each axis:

| RPWM | LPWM | R_OK = RPWM·¬LPWM | L_OK = LPWM·¬RPWM |
|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 |

REN and LEN pass unchanged to translator inputs. Translation is enabled independently per axis only when `ACTUATOR_PERMIT=1` and `MASTER_INHIBIT=0`. Permit absent, inhibit asserted, disagreement, startup, logic power absent, or translator supply absent yields inactive external outputs.

## 4. Selected Physical Logic Architecture

- U506 `SN74LVC14AQPWRQ1`: four opposing-command inversions, one inhibit inversion, one safely terminated spare.
- U507 `SN74LVC08AQPWRQ1`: four suppression AND gates, two per axis.
- U508 `SN74LVC08AQPWRQ1`: two independent authorization AND gates and two safely terminated spares.

This is combinational, fail-low, 3.3 V compatible and state-free. TI lists both devices ACTIVE, automotive, −40 °C to 125 °C, 2.0–3.6 V, push-pull, overvoltage-tolerant and partial-power-down/Ioff capable. The PW order codes are TSSOP-14. U506 maximum 3.3 V propagation is 6.4 ns; U507 is below 5 ns class, leaving substantial margin to the 500 ns contract.

## 5. Axis 1 Decomposition

U506A pin 1→2 inverts `AXIS1_LPWM_MCU`; U506B pin 3→4 inverts `AXIS1_RPWM_MCU`. U507A pins 1,2→3 produces `AXIS1_RPWM_QUAL`; U507B pins 4,5→6 produces `AXIS1_LPWM_QUAL`. REN/LEN are explicit pass-through aliases at U504 inputs.

## 6. Axis 2 Decomposition

U506C pin 5→6 and U506D pin 9→8 create the Axis 2 complements. U507C pins 9,10→8 and U507D pins 12,13→11 create `AXIS2_RPWM_QUAL` and `AXIS2_LPWM_QUAL`. REN/LEN remain explicit pass-through paths.

## 7. Authorization Decomposition

R527 holds permit low and R528 holds inhibit high. U506E pin 11→10 produces `MASTER_INHIBIT_N`. U508A pins 1,2→3 produces `AXIS1_XLAT_EN`; U508B pins 4,5→6 independently produces `AXIS2_XLAT_EN`. R501/R502 retain output fail-low defaults.

## 8. Authorization Connectivity Regression

Physical pin labels attach `MASTER_INHIBIT` to U506 pin 11, `ACTUATOR_PERMIT` to U508 pins 1 and 4, `MASTER_INHIBIT_N` to U508 pins 2 and 5, and U508 pins 3/6 to U504/U505 enable nets. R527/R528 remain attached to the same named input nets. Targeted validation checks these pin-level endpoints and prevents recurrence of ECO-001’s adjacent-label defect.

## 9. Translator Boundary Regression

U504/U505 and their separate `MOTOR_LOGIC_5V_A/B` domains are unchanged. Their A-side inputs remain 3.3 V LVC-compatible, fixed A→B direction and authorization-controlled enable. Safe outputs retain 33 Ω series damping, 10 kΩ pulldowns and D501–D508 protection. No bypass or reverse-current path was added.

## 10. Fail-Low Analysis

With +3V3 absent, U506–U508 cannot actively assert; Ioff limits injection and R501/R502 hold OE low. With either translator B supply absent, that axis is unpowered and its safe pulldowns hold low. MCU reset/unpowered is handled by 47 kΩ command pulldowns. Permit low, inhibit high, input opens, brownout and rail ramp all disable OE. Authorization assertion requires both independent levels, so no single floating input creates enable.

## 11. Opposing-PWM Suppression Proof

U506 creates ¬LPWM and ¬RPWM. U507 directly applies `R_OK=RPWM·¬LPWM` and `L_OK=LPWM·¬RPWM`; substitution for all four input combinations yields the table in §3. Authorization absent or translator disabled makes safe outputs low regardless of this table. A stuck-high logic output remains a residual active fault and requires prototype fault testing; this design does not claim formal functional-safety compliance.

## 12. Failure-Mode Review

| Fault | A1 R/L | A2 R/L | Authorization | Residual risk / prototype test |
|---|---|---|---|---|
| Any logic supply or power pin open | low by disabled/unpowered path | low | disabled | Verify rail ramp and Ioff |
| Gate input open | biased command/authorization input goes safe; internal interconnect open is indeterminate | same | normally disabled | Inject opens |
| Suppression output stuck high | one affected PWM may assert when authorized | other channels nominal | unchanged | Single-gate active fault; verify translator/OE shutdown |
| Suppression output stuck low | affected direction disabled | nominal | unchanged | Loss of function only |
| Inverter output stuck | conflict suppression or inhibit qualification may be defeated/disabled | as allocated | inhibit inverter high is hazardous only with permit high | Fault injection required |
| Authorization input open/short | biases force safe for opens; shorts may create disagreement | same | disabled unless both qualifying levels corrupted | Test open/short matrix |
| Decoupler open | functional state nominal, reduced transient margin | same | nominal | EMC/rail transient test |
| R501/R502 open | OE relies on U508 during powered operation | affected axis | logic controlled | Power-sequence test |
| R501/R502 short | affected axis low | unaffected | affected disabled | Safe loss of function |
| One command stuck active | mutually opposing command suppresses both; otherwise commanded direction can pass when authorized | nominal | unchanged | Firmware/watchdog containment test |
| Both PWM active | both low | both low | unchanged | Truth-table test |
| Translator input/output short | affected channel indeterminate or stuck | other axis isolated | unchanged | External driver containment remains product-owned |

## 13. Exact Device and Pin Mapping

U506: inputs 1,3,5,9,11,13; outputs 2,4,6,8,10,12; VCC 14; GND 7. U507/U508: gates 1,2→3; 4,5→6; 9,10→8; 12,13→11; VCC 14; GND 7. Electrical pin types, visible power units and TSSOP-14 manufacturer numbering are embedded. No footprint is assigned.

## 14. Reference Allocation

Retired U501/U502 map jointly to U506 direction-inverter units and U507 suppression units. Retired U503 maps to U506E and U508A/B. New package references are U506–U508; local bypasses C507–C509; DFT access TP501–TP524. Retired references are not reused.

## 15. Decoupling and Unused Units

C507, C508 and C509 are explicit 100 nF X7R package-local bypasses. Each package has a visible power unit. U506F input is tied low and output is no-connect. U508C/U508D inputs are tied low and outputs are no-connect. PW has no exposed pad.

## 16. DFT Nodes

TP501–TP524 cover both raw PWM pairs, both qualified PWM pairs, both authorization outputs, permit/inhibit, representative translator inputs/outputs, all eight safe outputs, and both axes. Test points have no footprints and are prototype debug/DNP items.

## 17. Population Register Changes

Prior count: 408. New count: 435. Retired composites: three. New physical rows: 30 (three IC packages, three bypass capacitors and 24 test points). Remaining Sheet 05 blocked references: 50 non-test physical rows; exact logic identities are selected but mechanical/footprint release remains blocked.

## 18. EBOM/AVL Reconciliation

CSV/XLSX EBOM, AVL and population artifacts contain 435 physical rows. U506–U508 exact TI MPNs and ECO-011A2 trace are recorded; all Sheet 04 and unrelated rows are preserved. No footprint is assigned.

## 19. Validation Results

Targeted validation covers composite retirement, package units/pins, Boolean nets, authorization endpoints, translator preservation, DFT, BOM synchronization, hierarchy/GPIO invariance, UUIDs, balanced S-expressions, zero footprints and zero PCB changes. Repository-wide validators and `git diff --check` are required before acceptance.

## 20. Native ERC Status

Pending: `kicad-cli` is unavailable on the validation host. Structural validation is not a substitute for native ERC.

## 21. Remaining ECO-011 Work

ECO-011A3 may address Sheet 06 watchdog/master authorization physical decomposition. EPP-01A-R and footprint assignment remain unauthorized.

## 22. Manual Review Checklist

- [x] Truth tables and pin allocations reviewed.
- [x] ECO-001 and translator boundaries preserved.
- [x] Power, bypasses and unused units explicit.
- [x] No hierarchy, GPIO, ADR/ICD, footprint or PCB change.
- [ ] Native ERC when KiCad CLI becomes available.

# ECO-011A2 COMPLETE — ECO-011A3 AUTHORIZED
