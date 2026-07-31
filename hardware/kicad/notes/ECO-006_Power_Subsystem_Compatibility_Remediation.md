# ECO-006 — Power-Subsystem Electrical Compatibility Remediation

## 1. Scope

ECO-006 corrects schematic-level electrical incompatibilities identified by CSR-01A-R. It changes requirement fields on Sheets 01 and 02 and replaces the U706/U707/U801 behavioral abstractions with one-device, selectable logical symbols on Sheets 07 and 08. It adds only R704/R705 and C702–C705. Rail voltages, hierarchy, GPIO, connectors, safety ownership, watchdog behavior, footprints, PCB data, and J1 mechanics are unchanged.

## 2. CSR-01A-R findings addressed

| Finding | References | Correction |
|---|---|---|
| 50 V parts exposed to a permitted 55 V clamp | C102, C103, C104, C109 | 100 V ceramic and 63 V bulk requirement classes with effective-C, ripple, and temperature limits |
| 60 V FET at 91.7% transient utilization | Q101 | Minimum 80 V class plus gate, loss, hot-current, pulse, and SOA requirements |
| Composite functions | U706, U707, U801 | Physical dual-supply buffers and a physical voltage-supervisor class |
| Incomplete regulator/passive definition | U201/U203 and dependent passives | Operating, ripple, current, capacitance, ESR, thermal, and tuning requirements recorded |
| Open transient coordination | F101/D101/Q101/U101/U102/input capacitors | Coordinated 55 V ceiling, current/energy envelope, and later-selection evidence defined |

J1 remains outside this ECO.

## 3. Affected reference inventory

| Reference(s) | Sheet | Prior role/value | QER incompatibility or dependency | ECO-006 correction class | Topology/architecture changed | Future MPN selectable |
|---|---:|---|---|---|---|---|
| C102, C109 | 01 | 100 nF, 50 V | Rating below 55 V clamp | 100 nF nominal, at least 70 nF effective at 55 V, at least 100 V X7R, ±10%, −40 to 125 °C | No/No | Yes |
| C103, C104 | 01 | 22 µF, 50 V | Rating below clamp; ripple undefined | 22 µF nominal, at least 20 µF effective, at least 63 V low-ESR bulk, at least 0.6 A RMS each, −40 to 125 °C | No/No | Yes |
| Q101 | 01 | 60 V reverse FET | 55/60 = 91.7% exceeds 90% | At least 80 V, at most 25 mΩ at actual drive, ±20 V VGS, 2 A hot, verified pulse/SOA | No/No | Yes after SOA/thermal evidence |
| U201, L201, C201–C205, R201–R203 | 02 | 5 V buck network | Device-dependent selection | Narrow 80 V, 2 A, 400 kHz class and calculated passives | No/No | Yes, as a set |
| U203, L202, C207–C210, R210–R213 | 02 | 3.3 V buck network | Device-dependent selection | Narrow 3 A-class, approximately 2.5 MHz class and calculated passives | No/No | Yes, as a set |
| C206 | 02 | “mux hold-up” | 47 µF cannot meet system hold-up alone | Explicit transition reservoir, not system hold-up | No/No | Yes |
| U706/U707 | 07 | Composite qualified branch | No orderable one-to-one implementation | One dual-supply enabled I²C buffer each | Physical decomposition only/No | Yes |
| R704/R705 | 07 | New | Enable could float as rail collapses | 100 kΩ ±1%, at least 0.063 W fail-low bias | Required passive/No | Yes |
| C702–C705 | 07 | New | Physical buffers require local supply bypass | 100 nF ±10% X7R, at least 10 V, one per supply pin/domain | Required passive/No | Yes |
| U801 | 08 | Composite rail qualifier | No orderable one-to-one implementation | One push-pull supervisor with fixed threshold and delay | Symbol narrowing only/No | Yes |

## 4. Capacitor rating corrections

The 55 V clamp is a pulse ceiling, not a normal operating point. C102/C109 use a 100 V ceramic class, keeping pulse utilization at 55%. Their minimum effective value is specified at 55 V so DC-bias loss cannot silently erase the high-frequency bypass. C103/C104 use 63 V or higher low-ESR bulk technology; 55/63 = 87.3% during the defined pulse and normal 21 V operation is 33.3% of rating. Two parts in parallel provide at least 40 µF effective and at least 1.2 A RMS aggregate ripple capability. Exact selections must show surge life, ESR from −40 to 85 °C or higher, ripple derating, and 125 °C-rated construction.

## 5. Reverse-protection MOSFET requirement

QER's strict mathematical minimum is 55 V / 0.90 = 61.1 V. ECO-006 chooses an 80 V minimum class, limiting utilization to 68.75% and leaving 25 V for clamp tolerance and local ringing without moving the 55 V system clamp ceiling. At 2 A and 25 mΩ, conduction loss is 0.10 W before temperature multiplication. The final device must meet the resistance at U101's actual gate voltage, tolerate ±20 V VGS, carry at least 2 A at the hot design point and 4 A for 10 ms, and show manufacturer SOA at or above 2 A for 100 ms at the applicable VDS. Reverse-current blocking and U101 gate-drive compatibility remain mandatory selection evidence.

## 6. U706 physical implementation

U706 is now exactly one dual-supply, bidirectional SDA/unidirectional-compatible SCL I²C buffer. VCCA is +3V3_CORE, VCCB is OLED_VCC, and its active-high EN is tied to OLED_VCC with R704 providing deterministic discharge/fail-low behavior. Required class: 2.7–3.6 V on both domains, 100 kHz support, propagation delay at most 1 µs, partial-power-off isolation, disabled high impedance, off-domain leakage at most 10 µA, and no propagation of a branch stuck-low while disabled. The branch owns no added pull-ups.

## 7. U707 physical implementation

U707 duplicates the U706 physical architecture for SENSOR_VCC and J7. R705 provides the deterministic fail-low EN bias. Supply, direction, timing, leakage, default, power-off, backfeed, and fault requirements are identical. Each symbol represents one IC; no hidden supervisor, switch, or passive exists.

## 8. U801 physical implementation

Sheet 08 already assigns dual-supply buffering and stuck-bus containment to separate physical U802. U801 therefore represents only one physical push-pull voltage supervisor: +3V3_CORE supply, EXPANSION_VCC_FILT sense, ground, and EXPANSION_SEGMENT_ENABLE output. It asserts at or above 2.9 V only after 5–10 ms, deasserts at or below 2.7 V, and drives low when invalid. R801 remains the independent 100 kΩ fail-low bias. U801/U802 are DNP by default; this preserves ICD-001, fixed SCL direction, expansion-side pull-up ownership, 100 kHz operation, and no-backfeed requirements.

## 9. Regulator calculations

### 5 V main buck

The selectable U201 class accepts 9–21 V continuous, survives the coordinated 55 V input envelope with margin through an 80 V rating, produces 5.0 V at 2.0 A, switches at 400 kHz, provides PGOOD and spread spectrum, and must remain at or below 110 °C junction at the QER ambient/copper condition.

For L201 = 15 µH, `ΔIL = VOUT(1 − VOUT/VIN)/(L fSW)`. Ripple is 0.37 A at 9 V and 0.64 A at 21 V. At 2 A load, worst peak is 2.32 A; the QER 1.25 multiplier requires 2.90 A hot saturation, so the schematic requires at least 3.2 A. Worst input-capacitor RMS current is approximately `IOUT sqrt(D(1-D)) = 0.85 A` at 21 V. C103/C104 collectively exceed 1.2 A RMS, while C201 supplies the local high-frequency loop with at least 1.0 µF effective at 55 V.

R202/R203 = 100 kΩ/24.9 kΩ produces 5.016 V for a 1.000 V reference. The 0.1% ratio pair contributes approximately ±0.10% setpoint error; the exact regulator reference, line/load regulation, and temperature error must fit the QER 4.75–5.25 V window. C203/C204 each require at least 15 µF effective at 5.25 V and a regulator-approved ESR range. R201, C202, C205, compensation if applicable, exact soft-start time, exposed-pad copper, and loop stability are selected with the exact regulator; they are not portable frozen values.

At 90% efficiency, approximate full-load loss is `10 W(1/0.90 − 1) = 1.11 W`. A final thermal model must demonstrate a total junction-to-ambient rise no greater than the QER junction limit permits; this defines rather than assigns the later copper area.

### 3.3 V core buck

U203 accepts CORE_SOURCE 4.4–5.25 V, supplies 3.3 V at 1.5 A continuous with at least 2.5 A current limit, and targets approximately 2.5 MHz. With L202 = 2.2 µH, ripple at 5 V is approximately 0.20 A, peak is 1.60 A, and the 1.25 hot-saturation requirement is 2.00 A; the captured 4 A requirement has ample margin. R210/R211 = 316 kΩ/100 kΩ gives 3.328 V for a 0.800 V reference. The 0.1% pair contributes approximately ±0.10%; total vendor tolerance must stay within 3.20–3.40 V. C208/C209 each provide at least 15 µF effective at 3.4 V in the exact regulator's stable ESR range.

At 92% efficiency and 4.95 W output, estimated loss is 0.43 W. Exact switching/conduction losses, compensation, soft start, transient droop, brownout behavior, and minimum copper are selected and checked with the final regulator. C206 is only a source-mux transition reservoir: 47 µF at 1 A and 0.3 V supports about 14 µs, not the 2 ms system requirement; continuous source overlap/mux behavior must provide the QER ride-through.

## 10. Transient coordination

The +40 V, 100 ms, 2 Ω source case is bounded by the 55 V maximum permitted clamp. Because the source is below the clamp ceiling, it primarily stresses the pass path rather than forcing a 55 V TVS clamp. At a 9–21 V downstream condition, the theoretical source-limited current is no more than `(40 − 21)/2 = 9.5 A` before F101/eFuse limiting; U101/U102 must limit the downstream current to the QER 2 A operating/fault policy. The source energy available over 100 ms is bounded by `40²/2 × 0.1 = 80 J`; no single downstream part may be assumed to absorb it. F101 provides wiring/fire protection and is not expected to clear a 100 ms qualified pulse unless its selected time-current curve says so. D101 controls fast overshoot; its tolerance/dynamic resistance must keep the protected node at or below 55 V. Q101, U101, U102, C102–C104/C109, and U201 all have ratings above that ceiling.

Final selection must overlay the source waveform, TVS dynamic clamp, eFuse current limit/SOA, fuse time-current curve, 2 A connector/conductor capability, and capacitor surge/ripple ratings. A TVS MPN is intentionally not frozen until its pulse-current clamp tolerance and thermal equivalence are demonstrated. The schematic no longer contains a rating below the allowed envelope.

## 11. Dependent passive requirements

| References | Requirement | Placement/status | Source |
|---|---|---|---|
| C102/C109 | 100 nF nominal; ≥70 nF effective at 55 V; ≥100 V X7R; ±10%; −40…125 °C | Close to protected-node switching/protection loop; populated | QER clamp/ceramic derating |
| C103/C104 | 22 µF nominal each; ≥20 µF effective; ≥63 V; ≥0.6 A RMS each; low ESR; −40…125 °C | Adjacent to post-eFuse filter; populated | 0.85 A input RMS calculation |
| L201 | 15 µH ±20%; ≥3.2 A hot Isat; ≥2.1 A Irms; ≤100 mΩ; −40…125 °C | Critical switch loop; populated | 400 kHz ripple calculation |
| C201 | 2.2 µF nominal; ≥1.0 µF effective at 55 V; ≥100 V X7R; ≥0.2 A ripple | At U201 VIN/GND; populated | High-frequency input loop |
| C203/C204 | 22 µF nominal each; ≥15 µF effective at 5.25 V; ≥16 V X7R | At U201 output; exact ESR with regulator | QER effective-C/stability |
| L202 | 2.2 µH ±20%; ≥4 A hot Isat; ≥1.6 A Irms; ≤60 mΩ | Critical switch loop; populated | 2.5 MHz ripple calculation |
| C208/C209 | 22 µF nominal each; ≥15 µF effective at 3.4 V; ≥10 V X7R | At U203 output; exact ESR with regulator | QER effective-C/stability |
| R704/R705 | 100 kΩ ±1%; ≥0.063 W; 100 ppm/°C or better | At buffer EN; populated | deterministic fail-low |
| C702–C705 | 100 nF ±10%; X7R; ≥10 V | At the corresponding U706/U707 VCCA/VCCB pins; populated | buffer supply transient/partial-power integrity |
| Frequency/feedback/SS/compensation parts | Values shown where topology permits; voltage ≥2× steady stress and resistor power ≤50% rating | Exact values selected with exact regulator; compensation may remain configurable for prototype | Vendor model/bench loop test |

## 12. Schematic changes

- Sheet 01: requirement fields only; references and topology preserved.
- Sheet 02: regulator and dependent-passive requirement fields only; topology preserved.
- Sheet 07: U706/U707 renamed to one-device buffer symbols with explicit EN pins; R704/R705 and C702–C705 added. Existing nets and ports preserved.
- Sheet 08: U801 narrowed to one physical supervisor; U802 remains the separate buffer. No interface changed.

## 13. Reference register changes

R704/R705 and C702–C705 were allocated from unused Sheet 07 ranges. U706, U707, and U801 retain their references. The controlled register now contains 307 physical/logical rows with no duplicate references.

## 14. Validation results

Repository validators check S-expression balance, UUID/reference uniqueness, hierarchy, GPIO, zero footprints, register synchronization, corrected voltage classes, removed composite symbol IDs, added EN bias/bypass, and prohibited-file scope. Generated EBOM/AVL artifacts are regenerated for 307 rows and 130 power-scope rows. `git diff --check` is also required before release.

## 15. Native ERC status

Native KiCad ERC remains pending because `kicad-cli` is not installed in the engineering environment. Structural repository validation is not a substitute for native ERC.

## 16. Remaining power-selection blockers

- Exact order codes, pin maps, vendor models, lifecycle, sourcing, pricing, and footprints remain CSR-01A-R2/CSR-01B work.
- The final TVS/eFuse/fuse overlay and Q101 manufacturer SOA curve require exact candidate data.
- Regulator loop stability, thermal copper, startup, brownout, and load-transient results require exact candidates and vendor models.
- J1 mechanical interface remains a separate unreleased package.
- Native ERC and prototype/DVT evidence remain open.

These are selection/verification items; none requires another schematic topology decomposition.

## 17. Manual review checklist

- [x] Four 50 V conflicts removed.
- [x] Q101 transient utilization corrected with an 80 V minimum class.
- [x] U706/U707 each represent one physical enabled dual-supply buffer.
- [x] U801 represents one physical supervisor; U802 remains the separate buffer.
- [x] Fail-disabled behavior and pull-up ownership preserved.
- [x] Regulator/passive calculations define selectable classes.
- [x] Transient coordination is internally consistent at schematic level.
- [x] No rail, GPIO, hierarchy, connector, safety, watchdog, footprint, or PCB change.
- [ ] Native ERC when KiCad CLI becomes available.
- [ ] Exact candidate and prototype evidence in later authorized packages.

# ECO-006 COMPLETE — POWER SCHEMATIC READY FOR CSR-01A-R2

CSR-01A-R remains not accepted. CSR-01B is not authorized.
