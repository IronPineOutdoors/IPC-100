# ECO-010 — Power Active Device Compatibility Remediation

## 1. Scope

ECO-010 corrects only U101 on Sheet 01 and U801 plus directly required support parts on Sheet 08. Rail ownership, hierarchy, GPIO, connector contracts, safety/watchdog logic, ICDs, ADRs, footprints and PCB data are unchanged.

## 2. PACS-01 Findings

PACS-01 found that `TPS26630PWPR` does not exist as an orderable TPS26630 configuration and that the captured TLV841 combination was not an active orderable OPN. Eighteen other active candidates are preserved as blocked candidates pending PACS-01R.

## 3. U101 Current-State Audit

The former Sheet 01 symbol displayed `TPS26630PWPR`, exposed 15 logical pins using VQFN-oriented numbering, assumed a 20-pin PWP body, an integrated series switch, and external Q101 reverse blocking. It accepted `VIN_SYS`, produced `VIN_PROTECTED_PRE_FILTER`, drove Q101 through BGATE/DRV, implemented UVLO/OVP, ILIM, dVdt, SHDN, MODE, FLT, PGOOD/PGTH and IMON, and fed the post-eFuse input filter and U102. The conflict was ordering code, package and pin mapping—not voltage rating or protection ownership.

## 4. U101 Functional Requirements

| Requirement | Released value |
|---|---|
| Operating input | 9–21 V; device operating range must include 4.5–60 V |
| Transient | +40 V/100 ms/2 Ω; coordinated protected-node ceiling ≤55 V |
| Load | 1.25 A continuous; 2 A path; 4 A/10 ms inrush |
| Current limit | 1.5–2.5 A total bound |
| Reverse event | −24 V/60 s; ≤1 mA reverse leakage |
| Series path | Integrated eFuse FET plus external N-FET for reverse blocking |
| Fault action | Short/thermal protection; MODE-selected retry or latch; ≥100 ms controlled recovery |
| Indication | Open-drain FLT and PGOOD retained |
| Temperature | −40 to +125 °C ambient class |
| External network | Q101, fast pull-down device, UVLO/OVP, ILIM, dVdt, SHDN bias, PGTH and decoupling |

## 5. U101 Options Assessment

| Option | Result |
|---|---|
| Correct TPS26630 | Rejected: TPS26630 is current only in 24-pin RGE. |
| Same-family active device | Selected: TPS26631PWPR is active, 20-pin PWP, retains adjustable OVP and adds 2× overload-pulse support. |
| Other manufacturer | Feasible only with larger topology/passive revalidation; unnecessary. |
| Decomposed controller/FETs | Feasible but adds references and protection-coordination risk; unnecessary. |

## 6. Selected U101 Architecture

`TPS26631PWPR` preserves the integrated 60 V/31 mΩ eFuse and external reverse N-FET architecture. Its verified PWP map is IN 1–3, BGATE 4, DRV 5, IN_SYS 6, UVLO 7, OVP 8, GND 9, dVdt 10, ILIM 11, MODE 12, PGOOD 13, IMON 14, PGTH 15, SHDN 16, FLT 17 and OUT 18–20. Parallel power pins are explicitly represented.

## 7. U101 Calculations

The selected device is rated 60 V operating/67 V absolute (75 V for 10 ms), so the 55 V coordinated clamp uses 82.1% of absolute rating. At 1.25 A the integrated 31 mΩ typical path dissipates about 48 mW; at 2 A about 124 mW before hot resistance. With Q101 at the released 25 mΩ maximum, combined nominal-path loss is bounded near 87.5 mW at 1.25 A and 224 mW at 2 A before temperature multipliers. The 4 A/10 ms startup event is supported by the TPS26631 pulse-current behavior but remains a prototype waveform requirement. Existing UVLO, OVP, ILIM and dVdt values remain generic and require exact tolerance/tool confirmation in PACS-01R/PPC-01; this ECO does not select the TVS, fuse or Q101 footprint.

## 8. U801 Current-State Audit

The former U801 was a four-pin TLV841 abstraction: +3V3_CORE VDD, EXP_SUP_SENSE, GND and valid-high output. It claimed a fixed 2.7 V threshold, 10 ms delay and external 150 kΩ/4.47 MΩ feedback, but omitted a SENSE lower leg and relied on a non-demonstrated ordering combination. It controls only U802 enable; R801 independently pulls that node low. The option remains DNP by default.

## 9. U801 Released Requirements

| Requirement | Limit |
|---|---|
| Monitored rail | EXPANSION_VCC_FILT |
| Valid assertion | No lower than 2.9 V; must assert on a valid 3.3 V rail |
| Invalid deassertion | No higher than 2.7 V |
| Release delay | 5–10 ms nominal class |
| Fault response | Prompt asynchronous invalid assertion; no startup enable pulse |
| Logic | EXPANSION_SEGMENT_ENABLE high only when valid; deterministic low otherwise |
| Partial power | +3V3_CORE absent or expansion absent must not enable or back-power U802 |

## 10. U801 Options Assessment

Fixed supervisors cannot provide the required wide tolerance-controlled hysteresis. Comparator/reference decomposition works but adds an IC and a startup-state proof. A TPS3899 adjustable supervisor provides separate VDD/SENSE, programmable release delay, qualified startup reset, an active order code and an open-drain active-low RESET that directly implements a valid-high node with a pull-up. This is the smallest valid change.

## 11. Selected U801 Architecture

U801 becomes active `TPS3899DL01DSER` in six-pin DSE: CTR 1, CTS 2, GND 3, VDD 4, SENSE 5, RESET_N 6. C805=10 nF programs a 6.2 ms nominal release delay; CTS is open for fast brownout response. R806=150 kΩ feeds SENSE, R807=31.6 kΩ returns SENSE to ground, R808=1.30 MΩ feeds valid output back to SENSE, and R809=4.70 kΩ pulls the open-drain output to +3V3_CORE. R801 remains a 100 kΩ fail-low bias.

## 12. U801 Threshold and Hysteresis Proof

For each output state, `VIN = VS + RT[VS/RB + (VS−VO)/RF]`, where RT=150 kΩ, RB=31.6 kΩ and RF=1.30 MΩ. Nominal TPS3899 adjustable threshold is 0.505 V with 5% internal hysteresis. The divider gives approximately 3.11 V rising and 2.60 V falling (using the loaded valid-output level).

A bounding enumeration includes ±0.1% threshold resistors, ±2.5% TPS3899 threshold accuracy, 3–8% internal hysteresis, 0–0.3 V output-low and 3.0–3.3 V output-high. Results are 2.934–3.283 V assertion and 2.501–2.693 V deassertion. Thus invalid deassertion is always below 2.7 V and assertion never occurs below 2.9 V. A nominal 3.3 V expansion rail clears the worst analytical assertion point by 17 mV; prototype ramp testing is mandatory because that is narrow. With C805=10 nF, TI specifies 6.2 ms typical release; capacitor tolerance yields about 5.55–6.86 ms by the nominal equation. Fast invalid assertion uses CTS open (30 µs typical, 50 µs maximum). SENSE leakage up to 50 nA shifts the input threshold by less than 8 mV using a ≤150 kΩ conservative impedance bound.

## 13. Dependent Passive Handoff

PAS-01R contains 18 residual rows; C305 was independently closed by ECO-009R, leaving the requested 17 active-dependent rows. U101 closes the active identity/waveform route for C102, C103, C104, C109 and L101 but exact manufacturer curves remain PAS-01R/PPC-01 work. U801 changes R808 to 1.30 MΩ and adds R807, R809 and C805; their exact passive MPNs remain blocked. C201–C206, C208–C210, L201 and L202 remain blocked by U201/U202/U203 candidate revalidation, not by this ECO.

## 14. PACS Candidate Preservation

All 18 unaffected PACS-01 candidates retain manufacturer and MPN evidence and remain `BLOCKED — PACS-01R SYSTEM REVALIDATION`. U101 and U801 are implementation candidates, not frozen procurement releases.

## 15. Schematic Changes

Sheet 01: corrected U101 family/value, symbol identity and all PWP pin numbers. Sheet 08: replaced the unavailable TLV841 abstraction, added the complete TPS3899 threshold/output/timing network, and retained all existing net and hierarchy names.

## 16. Reference Register Changes

Added C805, R807 and R809 from unused Sheet 08 ranges. No reference was reused or retired. U101 and U801 retain ownership and reference identity.

## 17. EBOM/AVL Reconciliation

CSV and XLSX artifacts record the two current orderable implementation candidates and three new generic support parts. All affected and preserved active rows remain blocked for PACS-01R. No footprint is assigned.

## 18. Failure-Mode Review

| Failure | Containment and residual test |
|---|---|
| U101/Q101 open | Main rail absent; actuator authorization cannot arise; diagnose power fault. |
| U101/Q101 short | Fuse/TVS/U102 remain; surge, reverse and short tests mandatory before release. |
| UVLO/OVP/ILIM open or short | May force off or alter threshold; component fault injection and clamp overlay required. |
| Timer/MODE/fault output fault | Output may latch/retry incorrectly, but downstream hardware authorization remains independent. |
| Surge/reverse/repeated overload/thermal | Safe shutdown expected; PPC-01 and prototype energy/SOA tests remain mandatory. |
| U801 output stuck low | Expansion isolated; safe loss of optional function. |
| U801 output stuck high or downstream EN short | Single-fault isolation can be defeated; DNP default and prototype fault injection required; no actuator authorization path exists. |
| Divider/reference fault | Open/short can force disabled or false valid; U802 contains only optional I²C and cannot authorize actuators. |
| Slow ramp/oscillation/brownout | 6.2 ms release and immediate invalid path suppress startup pulses; ramp/chatter test required. |
| Either supply absent/back-powered accessory | R801 fail-low plus open-drain topology contains enable; partial-power leakage test required. |

## 19. Validation Results

Targeted validation checks obsolete strings, exact pin maps, threshold components/calculations, unique references/UUIDs, balanced S-expressions, unchanged hierarchy/GPIO/connectors/ADR/ICD, synchronized BOM/AVL, preserved candidates, zero footprints and no PCB changes. The complete repository suite and `git diff --check` are release gates.

## 20. Native ERC Status

Pending when `kicad-cli` is unavailable. Structural validation is not a substitute for native ERC.

## 21. Remaining PACS-01R Blockers

PACS-01R must revalidate all 20 active functions, confirm U101/U801 orderability and exact electrical corners, close the narrow U801 high-corner assertion margin, and confirm distributor/lifecycle evidence. PPC-01 and CSR-01A-R5 remain unauthorized.

## 22. Manual Review Checklist

- [x] Invalid TPS26630/PWP and unavailable TLV841 implementation removed.
- [x] U101 PWP pin mapping and U801 physical support network represented.
- [x] Threshold, delay, fail-low and partial-power behavior bounded.
- [x] No hierarchy, GPIO, connector, ADR, ICD, footprint or PCB change.
- [ ] Native ERC when KiCad CLI is available.
- [ ] PACS-01R system revalidation and prototype corner testing.

# ECO-010 COMPLETE — PACS-01R AUTHORIZED

PPC-01 and CSR-01A-R5 are not authorized.
