# PAS-01R — Dependent Passive Curve and Tool Closure

> **ECO-009 disposition:** C305 was corrected to 93.1 nF / 99.642 ms nominal. ECO-009 remains incomplete because the repository has no accepted minimum/maximum reset-release window; C305 remains blocked pending that requirement and exact U302 selection.

Date: 2026-07-31  
Platform: IPC-100 Rev A  
Package: 11A-P-R

## 1. Executive Summary

Decision preview: PAS-01R is incomplete; the controlling decision appears in Section 19.

All 18 residual passive references have a specific final disposition. Seventeen are `BLOCKED — ACTIVE DEVICE SELECTION REQUIRED`; C305 is `BLOCKED — SCHEMATIC ECO REQUIRED`. No reference remains blocked by an unnamed curve, tool, calculation, or generic research request. PAS-01R cannot be accepted because C305 fails the released timing target and requires a schematic change.

Newly freeze eligible: **0**. Conditional: **0**. Routed to PACS-01 dependency: **17**. Previously frozen or PAS-01 freeze-eligible passive rows remain **76** (nine frozen plus 67 preferred selections). Remaining passive blockers: **18**.

## 2. Corrected Scope

The controlled scope is the 18 `BLOCKED` rows in the PAS-01 register. The 67 PAS-01 preferred selections and nine earlier frozen passives are preserved. Corrected routing remains 18 PPC-01 / 85 PAS-01/PAS-01R / 20 PACS-01 / one JCS-01. No active device is reclassified into this package.

## 3. Blocked Passive Inventory

The definitive inventory is [PAS-01R_Disposition_Register.csv](../analysis/passives/PAS-01R_Disposition_Register.csv). It contains each reference exactly once with sheet, function, type, current class, candidate, blocker, active dependency, evidence and final disposition.

| Evidence class | References |
|---|---|
| DC-bias/input energy | C102, C103, C104, C109, C201, C206 |
| Regulator stability/bootstrap/soft start | C202, C203, C204, C205, C208, C209, C210 |
| Timing | C305 |
| Magnetics | L101, L201, L202 |
| Precision threshold | R808 |

## 4. Evidence Dependency Matrix

| Circuit | Dependent passives | Controlling decision |
|---|---|---|
| Protected input | C102/C103/C104/C109/L101 | U101 exact suffix and PPC-01 clamp/fault waveform |
| 5 V converter | C201–C205/L201 | U201 exact PFM/FPWM suffix and TI WEBENCH/integrated-compensation solution |
| Source transition/core input | C206 | U202 exact behavior plus U203 selection |
| 3.3 V converter | C208–C210/L202 | U203 exact order code, frequency/mode and LC/soft-start solution |
| Core reset | C305 | TPS389030-Q1 timing equation; schematic value conflict |
| Expansion qualification | R808 | U801 exact TLV841S order code and leakage/threshold limits |

## 5. DC-Bias Capacitor Analysis

No exact capacitor may be selected before its maximum applied waveform is frozen. C102/C109 require ≥70 nF effective at 55 V and C201 requires ≥1.0 µF effective at 55 V; official part-specific bias curves must be evaluated after U101/U201 selection. C103/C104 ripple and lifetime depend on the protected-input waveform. C206 requires ≥30 µF effective at 5.25 V but also participates in U202/U203 source transition. Manufacturer nominal capacitance or same-case-family data is not substituted for exact MPN curves.

## 6. Regulator Stability Analysis

TI identifies LMR38020-Q1 variants `LMR38020SQDDARQ1` and `LMR38020FSQDDARQ1`; the latter forces PWM. The schematic specifies only a family. TI requires a 100 nF BOOT-to-SW capacitor and uses integrated compensation, but the exact LC/output-capacitance solution still depends on suffix and operating mode. TI directs designs to WEBENCH Power Designer. Therefore C201–C205 and L201 are not independently selectable.

U203 remains a functional class even though its datasheet link points to TPS62130. TI's TPS62130 guidance recommends 2.2 µH for the stated mode, evaluates LC combinations with effective capacitance from +20% to -50%, and requires individual combinations to be checked. It also derives soft-start capacitance from a 2.5 µA charge source. C208/C209/C210/L202 therefore depend on PACS-01 selecting U203 and its exact mode/order code.

## 7. Timing Component Analysis

For TPS3890-Q1, TI gives `tPD(r) = CCT(µF) × 1.07 + 25 µs` nominal and specifies CT current of 0.90–1.35 µA and threshold of 1.17–1.29 V. With captured C305 = 10 nF:

- nominal: `0.010 × 1.07 s + 0.000025 s = 10.725 ms`;
- conservative IC-only range using `C × VCT / ICT + 25 µs`: 8.692–14.358 ms before capacitor tolerance, bias, leakage, aging, or board leakage;
- released target: 100 ms.

The nominal miss is about -89.3%. A roughly 93.4 nF nominal capacitor would be required by the nominal equation, but PAS-01R is not authorized to change C305. Final disposition: `BLOCKED — SCHEMATIC ECO REQUIRED`.

## 8. Magnetic Component Analysis

L101 cannot receive a meaningful impedance/core-loss qualification until U101 and the PPC-01 source/clamp spectrum are frozen. For U201, suffix-dependent operation and the WEBENCH solution control L201. For TPS62130-class U203, TI requires maximum current from actual VIN/VOUT/frequency/minimum inductance and recommends about 20% saturation margin. These official equations are available, but their mandatory active inputs are not frozen. All three magnetics route to PACS-01 dependency; no curve output is fabricated.

## 9. Precision Resistor Analysis

R808 is 4.47 MΩ, ±0.1%, ≤25 ppm/°C. Its self-heating is negligible, but the resulting thresholds depend materially on the exact U801 SENSE threshold, hysteresis, leakage and delay suffix. TLV841S allows SENSE from 0 to 5.5 V and uses internal hysteresis; the February 2026 datasheet confirms order-code-specific behavior. Until PACS-01 freezes U801, a complete divider/leakage tolerance stack is impossible. R808 remains a named PACS dependency.

## 10. Manufacturer Tool Results

| Manufacturer tool/source | Access date | Inputs available | Result |
|---|---|---|---|
| TI WEBENCH Power Designer — LMR38020-Q1 | 2026-07-31 | 9–21 V, 5 V, 2 A peak, 400 kHz; exact PFM/FPWM suffix absent | Not executed as qualification evidence; suffix is a mandatory unresolved input |
| TI TPS62130 datasheet LC tables/equations | 2026-07-31 | 4.4–5.25 V, 3.3 V, load envelope; exact U203 not selected | Official range confirms dependency; no candidate tool output claimed |
| TI TPS3890-Q1 equation | 2026-07-31 | C305 = 10 nF | Executed analytically; 10.725 ms nominal, inconsistent with 100 ms target |
| Murata/other capacitor bias tools | 2026-07-31 | Exact capacitor candidate absent for blocked rows | Not executable without inventing a candidate; retained behind named active dependency |

## 11. SPICE and Equation Verification

No official SPICE run improves the controlling decisions. The TPS3890 equation is qualification evidence because it is the manufacturer's specified timing relationship. Regulator simulation before exact active and passive selection would only restate assumptions and is not used as an operating-limit substitute.

## 12. Exact MPN Selections

No new MPN is released. PAS-01's 67 preferred selections remain unchanged. The 18-row register intentionally leaves candidate MPN blank because selecting a passive before the controlling active/tool inputs would reverse the required dependency order.

## 13. Lifecycle and Sourcing

Lifecycle, RoHS/REACH, authorized-source SKUs, lead time, alternates and quantity pricing remain inapplicable to these blocked rows until an exact MPN exists. No stock is represented as guaranteed and no alternate is approved by family resemblance.

Primary manufacturer sources:

- TI LMR38020-Q1 datasheet, SNVSBS6B: https://www.ti.com/lit/ds/symlink/lmr38020-q1.pdf
- TI TPS62130 datasheet, SLVSAG7F: https://www.ti.com/lit/ds/symlink/tps62130.pdf
- TI TPS3890-Q1 datasheet, SBVS303B: https://www.ti.com/lit/ds/symlink/tps3890-q1.pdf
- TI TLV841 datasheet, SLVSFO5E: https://www.ti.com/lit/ds/symlink/tlv841.pdf

## 14. EBOM/AVL Reconciliation

The EBOM and AVL blockers for all 18 rows are updated with the exact PAS-01R disposition and dependency. CSV and XLSX are regenerated from the same controlled sources. The 67 PAS-01 selections remain in their controlled PAS register; the nine earlier canonical frozen passives remain unchanged.

## 15. Prototype Validation Handoff

No reference qualifies for prototype-only conditional status: failure of any present candidate could require a value, package family, or schematic change. Prototype tests remain downstream DV evidence after active selection and exact passive qualification.

## 16. Remaining Blockers

- C305: narrow timing ECO reconciling 10 nF with the 100 ms requirement.
- Seventeen references: PACS-01 freezes U101/U201/U202/U203/U801 as applicable, after which the named official tool or curve evaluation can run.

## 17. Routing Confirmation

PAS-01R retains all 18 passives in the PAS scope while routing their closure dependency to PACS-01. It does not start PACS-01. FB801 retains the PAS-01 freeze-eligible disposition. No active device is present in the PAS-01R inventory.

## 18. Validation Results

The PAS-01R validator checks 18 unique dispositions, 85 PAS references, preservation of 67 prior selections and nine prior frozen passives, EBOM/AVL agreement, zero footprints and prohibited-file scope. Repository validators and `git diff --check` are run at package close. Native ERC is not required because no schematic changed.

## 19. Final Decision

# PAS-01R INCOMPLETE

Next highest-unblock package: **PACS-01 — Power Active Component Selection**, after a narrow C305 timing ECO. PPC-01, PACS-01, JCS-01 and CSR-01A-R5 are not begun or authorized by this package.
