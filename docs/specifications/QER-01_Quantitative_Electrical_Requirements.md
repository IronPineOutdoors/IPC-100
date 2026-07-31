# QER-01 — Quantitative Electrical Requirements

| Field | Value |
|---|---|
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Document type | Controlling electrical requirements envelope |
| Date | 2026-07-31 |
| Owner | Iron Pine Outdoors Engineering |

> **Controlled amendment — QER-02 (2026-07-31):** For `EXPANSION_VCC` and `MOTOR_LOGIC_5V_A/B`, the original 100 mA continuous and 150 mA/10 ms peak allocations remain in force. QER-02 completes the peak waveform as no more than 1 Hz and 1% duty and supersedes the generic Section 6 limit only for these branches with a 160–225 mA worst-case fault-threshold band. Original values are preserved below and in change history.

## 1. Executive Summary

QER-01 converts the frozen Rev A architecture and interface contracts into measurable limits for component selection. It does not select manufacturer parts, assign footprints, or change schematic behavior.

These requirements are design limits, not claims of certification. Compliance requires analysis against worst-case component tolerances followed by prototype verification. External motor power, motor current, product battery protection, and relay-contact load energy remain outside the IPC-100 control-power boundary.

Where an existing ADR or ICD is narrower, the narrower requirement controls. Any product that exceeds this envelope requires a controlled interface or hardware revision.

## 2. Operating Environment

| Parameter | Rev A requirement |
|---|---|
| Nominal battery basis | 18 V nominal lithium tool-battery class; no battery-brand electrical dependency |
| Normal J1 operating range | 9.0–21.0 V DC at the IPC-100 board boundary |
| Guaranteed startup range | 9.0–21.0 V after input settles within the transient envelope |
| Controlled shutdown threshold | Main-power authorization shall be removed by 8.5 V falling input; restart shall not occur below 9.0 V; at least 0.5 V effective hysteresis |
| Cold start | Startup at 9.0 V and −20 °C with all request-controlled branches off; input inrush limited to 4 A peak for no more than 10 ms |
| Power interruption | Outputs shall deauthorize for any invalid-main interval; no actuator hold-up is required. Core ride-through target is 2 ms for a source discontinuity when another valid source is not present |
| Controller input current | 1.25 A maximum continuous at 9 V in any released operating state; 2.0 A peak for no more than 100 ms; input path rated for 2.0 A continuous capability |
| Operating ambient | −20 to +60 °C around the enclosed controller assembly |
| Internal enclosure air | −20 to +75 °C maximum |
| Storage | −40 to +85 °C, unpowered |
| Humidity | 5–95% RH, noncondensing at the PCB; condensation and conductive contamination excluded by the product enclosure |
| Outdoor exposure | Product enclosure minimum target IP54; PCB is not directly weather-exposed. UV, rain, snow, mud, salt spray, and pressure washing shall not reach the PCB |
| Vibration | Powered functional sweep, 5–500 Hz, 2 g RMS, 30 min/axis on three orthogonal axes; no intermittent connection, reset, damage, or unsafe output |
| Mechanical shock | Unpowered and powered-safe-state checks after 20 g, 11 ms half-sine, three shocks in each direction on three axes |
| Design life | 10 calendar years or 5,000 powered hours, whichever occurs first |
| Operating duty | Up to 8 h/day and 100 power cycles/year; relay and actuator duty remain bounded by their interface contracts |

## 3. Power Requirements

### 3.1 Rail limits

| Rail | Nominal | Allowed steady range at source | Continuous allocation | Peak allocation | Required behavior |
|---|---:|---:|---:|---:|---|
| `VIN_RAW` | 18 V basis | 9.0–21.0 V normal | 1.25 A board draw at 9 V | 2.0 A/100 ms | Protected locally; not a motor-power path |
| `VIN_PROTECTED` | Tracks input | Input less protection loss | 2.0 A path capability | 4 A/10 ms inrush | Reverse, surge, short, and thermal faults contained |
| `+5V_MAIN` | 5.0 V | 4.75–5.25 V | 1.50 A | 2.00 A/100 ms | Main-only; ripple ≤50 mV peak-to-peak, 20 MHz bandwidth |
| `USB_5V_PROTECTED` | USB VBUS | 4.40–5.25 V after protection | 0.50 A maximum | No allocation above 0.50 A | Reverse current to host ≤10 µA steady |
| `CORE_SOURCE` | 5 V class | 4.40–5.25 V | 0.50 A from USB; main source sized for core converter maximum | Source-transition transient below core regulator UVLO | Main preferred; no cross-current |
| `+3V3_CORE` | 3.3 V | 3.20–3.40 V | 1.00 A | 1.50 A/100 ms | Ripple ≤40 mV peak-to-peak, 20 MHz bandwidth |
| `RELAY_VCC` | 5.0 V | 4.75–5.25 V | 100 mA | 150 mA/20 ms | Main-qualified, hardware-safe actuation |
| `MOTOR_LOGIC_5V_A/B` | 5.0 V | 4.75–5.25 V | 100 mA each | 150 mA each/10 ms | Individually current limited; no motor current |
| `FIELD_SENSE_VCC` | 5.0 V | 4.75–5.25 V | 50 mA | 75 mA/10 ms | Hardware enabled only with valid main power |
| `OLED_VCC` | 3.3 V | 3.15–3.40 V | 150 mA | 200 mA/10 ms | Request-controlled; off in USB-only/reset |
| `SENSOR_VCC` | 3.3 V | 3.15–3.40 V | 50 mA | 75 mA/10 ms | Request-controlled; off in USB-only/reset |
| `UI_VCC` | 5.0 V | 4.75–5.25 V | 120 mA | 180 mA/10 ms | Request-controlled; off in USB-only/reset |
| `EXPANSION_VCC` | 3.3 V | 3.0–3.45 V at J10 | 100 mA | 150 mA/10 ms | Optional/DNP; ICD-001 controls |

Steady load combinations shall remain within both the individual branch allocation and the 1.0 A `+3V3_CORE` / 1.5 A `+5V_MAIN` totals. Firmware may load-shed optional branches but safety shall not depend on load shedding.

### 3.2 Conversion and sequencing

| Requirement | Limit |
|---|---|
| Main converter efficiency | ≥85% at 9–21 V and 25–100% of the released load; ≥75% at 10% load |
| Core converter efficiency | ≥85% at 4.4–5.25 V and 25–100% load |
| Main rail startup | Monotonic to regulation within 50 ms after valid protected input; overshoot <5% |
| Core rail startup | Monotonic to regulation within 20 ms after valid `CORE_SOURCE`; overshoot <5% |
| Power-good assertion | Only after the monitored rail has remained within its allowed range for ≥5 ms |
| Power-good deassertion | Within 1 ms of leaving the valid range; `MAIN_POWER_GOOD` shall fall before actuator logic becomes undefined |
| Branch rise time | 0.2–10 ms unless an ICD is narrower; no overshoot above 5% |
| Branch discharge | Below 0.3 V within 100 ms after disable |
| Source switchover | No reverse current; `+3V3_CORE` shall remain ≥3.0 V for a transition between two valid sources |
| Hold-up | No main-only-load hold-up requirement; core energy storage shall cover 2 ms at 1.0 A from 3.3 V to 3.0 V or the source selector shall meet the same droop requirement |
| Switching frequency | 200 kHz–2.2 MHz; avoid intentional operation within ±10% of 100 kHz I²C harmonics only where measured coupling violates noise limits |
| Dropout/headroom | `+5V_MAIN` shall remain in tolerance at 9.0 V input and maximum continuous load; `+3V3_CORE` shall remain in tolerance at 4.40 V `CORE_SOURCE` and maximum continuous load |
| EMI target | Power converters and their input harness shall meet CISPR 25 Class 3 conducted-emission limits in prototype pre-compliance; final product radio/regulatory compliance remains product-owned |

## 4. Load Budget

Values below are allocation targets for selection. “Peak” is a hard electrical allocation. Typical values are energy and thermal planning estimates to be replaced by prototype measurements without increasing the maximum allocation.

| Subsystem | Rail | Idle | Typical | Maximum | Peak duration | Maximum power | Margin basis |
|---|---|---:|---:|---:|---:|---:|---|
| ESP32 core and radio | `+3V3_CORE` | 35 mA | 120 mA | 700 mA | 500 ms | 2.31 W | Includes wireless burst envelope |
| Core logic, reset, watchdog, translators | `+3V3_CORE` | 15 mA | 30 mA | 50 mA | Continuous | 0.17 W | 67% above typical |
| OLED branch | `OLED_VCC` | 0 | 50 mA | 150 mA | Continuous | 0.50 W | 3× typical allocation |
| Environmental sensor branch | `SENSOR_VCC` | 0 | 2 mA | 50 mA | 10 ms | 0.17 W | Startup and alternate sensor allowance |
| J10 expansion | `EXPANSION_VCC` | 0 | 75 mA | 100 mA | 150 mA/10 ms | 0.33 W continuous | ICD-001 reserves 25 mA overhead |
| Relay coil/driver | `RELAY_VCC` | 0 | 0 or 80 mA | 100 mA | 150 mA/20 ms | 0.50 W | Coil tolerance/startup allowance |
| Motor logic A | `MOTOR_LOGIC_5V_A` | 0 | 50 mA | 100 mA | 150 mA/10 ms | 0.50 W | External logic only |
| Motor logic B | `MOTOR_LOGIC_5V_B` | 0 | 50 mA | 100 mA | 150 mA/10 ms | 0.50 W | External logic only |
| Field sensing | `FIELD_SENSE_VCC` | 6 mA | 15 mA | 50 mA | 75 mA/10 ms | 0.25 W | Five loops plus conditioning |
| UI panel | `UI_VCC` | 0 | 60 mA | 120 mA | 180 mA/10 ms | 0.60 W | RGB and buzzer duty managed |

Worst-case continuous allocation is 1.05 A on the 3.3 V branch set if every optional load is simultaneously at its individual maximum. Therefore the released simultaneous limit is 1.00 A: J10 shall be DNP or one nonessential branch shall be load-limited when the other four consume more than 900 mA. At 85% core-converter efficiency, 1.00 A at 3.3 V requires 0.78 A from 5 V. Adding all direct 5 V allocations gives 1.25 A from `+5V_MAIN`, leaving 0.25 A (17%) below its 1.50 A rating.

At 85% main-converter efficiency, the 7.5 W maximum continuous 5 V rail requires approximately 0.98 A at 9 V. The 1.25 A controller-input limit provides at least 27% current margin over that calculated case, while the 2.0 A path capability supports controlled startup and fault coordination.

## 5. Transient Requirements

| Event | Required test envelope | Acceptance criterion |
|---|---|---|
| Battery connection | 21 V source, 0.10 Ω minimum source impedance, 1 m harness, arbitrary contact bounce | No damage, unsafe output pulse, or >4 A/10 ms input inrush |
| Positive input surge | +40 V rectangular pulse, 100 ms, 2 Ω source, five pulses at 60 s spacing | No damage; regulated rails remain within absolute limits; safe shutdown allowed |
| Sustained input overvoltage | +30 V for 60 s, current-limited to 5 A upstream | No fire or unsafe output; input may reject/latch off; normal function returns after valid power/reset |
| Reverse polarity | −24 V for 60 s with 2 A upstream limit | No damage, rail energization, or reverse current above 1 mA |
| Input interruption | 0 V for 1 ms, 2 ms, 10 ms, and 100 ms from nominal input | Deterministic state; no output pulse; behavior follows hold-up limits |
| Local inductive switching | Relay coil and all onboard inductive nodes opened at worst-case current | Clamp below 80% of affected semiconductor absolute maximum; no reset or false authorization |
| External motor/thrower disturbance | IEC 61000-4-4 ±1 kV burst coupled to external control/harness cables and a 10 V/m, 80 MHz–1 GHz radiated-immunity pre-compliance sweep; motor energy never routed through IPC-100 | No unsafe output; temporary recoverable non-safety communication upset permitted |
| Connector ESD | IEC 61000-4-2, ±8 kV contact and ±15 kV air on user-accessible connectors; ±4 kV contact on internal service points | No damage or unsafe authorization; temporary recoverable communication upset permitted |
| USB insertion/removal | USB-compliant 4.75–5.25 V source, 2 m cable, 100 mating cycles test basis | ≤500 mA draw, no host backfeed, no unsafe main-only rail |
| Connector hot plug | Only J13 is intentionally live-mate; accidental hot plug elsewhere tested at released voltage/current | No damage or unsafe authorization; functionality may require controlled recovery |
| Output short | Each protected power output shorted to return at min/max input and temperature | Core remains safe; device limits current and survives until latch/retry/fuse action |
| Signal open/short | Open, ground short, supply short, and adjacent-pin short at every external signal | Defaults follow ADR/ICD; no unauthorized actuator state |

Direct automotive alternator load dump, jump-start above 30 V, and ISO 7637 compliance are not Rev A claims. An automotive installation shall provide an external conditioned 9–21 V branch meeting this QER.

## 6. Protection Requirements

| Protection | Quantitative requirement |
|---|---|
| Input fuse | 2.0 A nominal time-delay basis; ≥32 VDC rating; interrupt rating ≥100 A DC; carry 1.25 A at 75 °C without nuisance opening; clear a 10 A fault within 5 s and coordinate below PCB conductor damage |
| Input TVS | Standoff ≥24 V; withstand the +40 V/100 ms/2 Ω envelope with ≥2× pulse-energy margin; worst-case clamp ≤55 V at end-of-life/tolerance |
| Reverse polarity | −24 V/60 s survival; forward loss ≤100 mV at 1.25 A; reverse leakage ≤1 mA |
| Input current limit | 2.0 A nominal with total tolerance remaining between 1.5 and 2.5 A; startup blanking shall not defeat short protection |
| USB VBUS | 500 mA hardware maximum, reverse leakage ≤10 µA, VBUS TVS clamp below downstream absolute maximum, IEC ESD at connector |
| USB data ESD | Low-capacitance protection; total added capacitance ≤2 pF per line and channel mismatch ≤0.5 pF |
| I²C connector protection | IEC ESD as specified; powered-off injection ≤10 µA per signal; protection plus wiring must stay within bus capacitance budget |
| 3.3 V/5 V branch limit | Current-limit maximum no greater than 150% of continuous allocation; short shall not collapse core or assert authorization. **QER-02 supersession:** `EXPANSION_VCC` and `MOTOR_LOGIC_5V_A/B` instead require a 160–225 mA worst-case fault-threshold band while retaining their 100 mA continuous and 150 mA/10 ms load contracts. |
| Power qualification | Assertion only above the lower valid rail limit for ≥5 ms; deassertion before the rail falls below the consumer’s guaranteed operating minimum |
| Recovery | No uncontrolled rapid retry; retry period ≥100 ms or latch-off until commanded recovery for an external persistent short |

## 7. Passive Requirements

| Component class | Minimum requirement |
|---|---|
| Raw-input ceramic capacitor | X7R or better, −40 to +125 °C; rated voltage ≥2× 21 V and greater than worst-case TVS clamp where directly exposed; effective capacitance after DC bias/tolerance/aging ≥70% of design minimum |
| 5 V/3.3 V ceramic capacitor | X7R, rated voltage ≥2× steady rail; effective value ≥70% of regulator-required minimum; ripple-current temperature rise ≤10 °C |
| Timing/compensation capacitor | C0G/NP0 where value permits; otherwise X7R with tolerance stack included; no Y5V/Z5U |
| Bulk capacitor | Rated voltage ≥1.4× maximum steady rail and above expected clamp; ripple rating ≥1.5× calculated RMS ripple; life ≥5,000 h at 105 °C or demonstrated 10-year mission life by temperature law |
| Precision divider | ±1% maximum unless tolerance analysis requires tighter; ≤100 ppm/°C; working voltage and pulse rating ≥1.5× applied stress |
| Current-setting/sense resistor | ±1% maximum, ≤100 ppm/°C; continuous dissipation ≤50% rated power at 75 °C; pulse energy ≥2× calculated event |
| General resistor | Continuous dissipation ≤50% rated at 75 °C; voltage ≤70% working-voltage rating |
| Inductor | Saturation current ≥1.25× worst-case peak; RMS rating ≥1.20× worst-case RMS; hot DCR included; predicted rise ≤30 °C at 75 °C ambient |
| Ferrite bead | Impedance specified at 100 MHz with DC bias; rated current ≥1.5× branch maximum; DC resistance drop ≤1% of nominal rail |
| Crystal/oscillator | Total initial, temperature, aging, and load error ≤±40 ppm over life where used; USB timing shall satisfy the controlling USB specification |

## 8. Connector Requirements

Requirements below select capability, not connector family or pin numbering.

| Attribute | J1 power input | Low-power internal connectors | External/service connectors |
|---|---|---|---|
| Voltage rating | ≥30 VDC | ≥12 VDC | ≥30 VDC or 2× exposed voltage, whichever is greater |
| Current rating | ≥3 A per used power contact at 75 °C | ≥1.5× branch limit | ≥1.5× released contact current |
| Contact resistance | ≤20 mΩ initial, ≤40 mΩ after life test | ≤30 mΩ initial | ≤30 mΩ initial |
| Temperature rise | ≤20 °C at released continuous current in enclosure | ≤20 °C | ≤20 °C |
| Durability | ≥100 mating cycles | ≥50 cycles | ≥100 cycles; J13 per USB connector requirement |
| Retention | Positive polarization and latch; ≥20 N axial unmating force without latch release | Friction/latch adequate to ≥10 N harness pull after strain relief | Positive latch or enclosure retention; ≥20 N after strain relief |
| Conductors | 18–22 AWG | 22–28 AWG as current permits | ICD-002 controls; 18–24 AWG safety loops |
| Environment | Enclosure-protected; no exposed live metal | Internal to enclosure | Enclosure/feedthrough owns IP54 minimum system target |

Connectors shall be keyed against reversal and foreseeable cross-mating with incompatible voltage classes. Protective ground or shield contacts shall not carry normal logic return current. Harness voltage drop shall consume no more than 2% of nominal rail at continuous load, except ICD-001’s explicit 3.0 V accessory boundary.

## 9. Signal Requirements

| Interface | Quantitative requirement |
|---|---|
| USB | USB 2.0 full-speed device/UFP, 12 Mbit/s; 90 Ω differential ±10% routed impedance target; ≤2 m compliant cable; VBUS draw ≤500 mA; no PD or source role |
| Base I²C | 3.3 V, 100 kHz maximum, 200 pF total internal bus; 4.7 kΩ nominal pull-ups; rise ≤1,000 ns, fall ≤300 ns |
| J10 I²C | ICD-001: 100 kHz, 100 pF external segment, 0.30 m cable, one accessory, 4.70 kΩ ±1%, no clock stretching |
| Digital 3.3 V logic | Receiver guaranteed low at ≤0.3 VDD and high at ≥0.7 VDD; design output under rated load ≤0.1 VDD low and ≥0.9 VDD high, providing ≥0.2 VDD static noise margin |
| 5 V translated logic | Same 0.3/0.7 normalized thresholds unless ICD is narrower; powered-off leakage ≤10 µA; default bias must establish a valid safe level |
| GPIO edge rate | No faster than required; external discrete outputs target 10–200 ns rise/fall after damping; no ringing beyond −0.3 V or VDD+0.3 V |
| Relay command | Hardware authorization controls; command pulse accepted only when authorization valid; coil deenergizes within 20 ms of authorization loss |
| Relay contacts | ICD-002: 0–30 VDC SELV, 1 A continuous resistive, 2 A/100 ms; external suppression required for inductive loads |
| Safety loops | ADR-042: 5 V, 2.20 kΩ source and EOL, nominal healthy 2.50 V, fault <1.00 V, open/asserted >4.00 V, 10 m/2 nF maximum |
| Watchdog service | ADR-044: nominal 75 ms transitions, accepted 40–100 ms, invalid output within 250 ms, two transitions before qualification |

## 10. Engineering Derating Policy

| Stress | Required margin at worst-case tolerance and 75 °C internal air |
|---|---|
| Semiconductor steady voltage | ≤80% of absolute maximum |
| Semiconductor specified transient | ≤90% of absolute maximum and within repetitive/nonrepetitive pulse rating as applicable |
| Continuous current | ≤70% of rated current after thermal derating; protection devices may use up to 80% when manufacturer curves explicitly support it |
| Continuous power | ≤50% package power rating unless a board-level thermal model demonstrates junction margin |
| Junction temperature | Predicted ≤110 °C in worst continuous state and ≥15 °C below the lower of rated or absolute maximum; measured prototype target ≤100 °C |
| PCB/enclosure temperature rise | Local board rise ≤35 °C above ambient; internal enclosure air rise ≤15 °C above external ambient under representative operation |
| Connector current | Released continuous current ≤67% of manufacturer rating at the applicable contact count and temperature |
| Capacitor voltage | Ceramic ≤50% rated for steady DC; bulk ≤70%; pulse/clamp never exceeds rating |
| Capacitor ripple | ≤67% rated RMS ripple at calculated hot condition |
| Resistor power | ≤50% rated at hot condition |
| Inductor saturation | Peak ≤80% minimum hot saturation current |
| Fuse | Maximum continuous normal current ≤70% of hot carry capability; time-current curve must pass inrush and clear faults before conductor damage |
| MOSFET SOA | ≥2× margin in current-time or energy for every startup/fault pulse; repetitive events evaluated thermally, not treated as isolated pulses |

## 11. Design Targets

| Metric | Rev A target |
|---|---|
| Controller idle input power | ≤1.0 W at 18 V, main powered, peripherals and actuators off |
| Typical operating input power | ≤4.0 W at 18 V without relay, J10, or external motor-logic loads |
| Maximum continuous input power | ≤11.25 W at 9 V; ≤9 W target at nominal 18 V under released loads |
| Conversion efficiency | ≥85% for each regulator over 25–100% released load |
| Enclosure air rise | ≤15 °C over ambient |
| Critical-device junction | ≤110 °C calculated; ≤100 °C measured in qualification |
| Mission life | 10 years / 5,000 powered hours |
| Reliability objective | Predicted controller MTBF ≥50,000 h at 40 °C representative operation after BOM freeze; no single power or interface fault shall energize an actuator |
| Repairability | Board-level replacement in field; component-level depot repair with controlled BOM/rework/test records |
| Manufacturing yield | ≥95% first-pass functional yield for pilot lots; ≥98% after process stabilization |

## 12. Open Engineering Decisions and Verification Items

No open electrical-requirement decision prevents power-component selection against this envelope. The following items remain implementation or evidence tasks and shall not be silently converted into relaxed requirements:

| Item | Affected subsystem | Impact | Required action | Priority |
|---|---|---|---|---|
| QER-V01 exact load confirmation | All rails | Typical estimates may differ from hardware | Measure idle, typical, peak, duration, and simultaneous states; remain below allocations | High, before design verification closure |
| QER-V02 transient validation | J1/protection | Analysis alone does not establish assembly survival | Bench-test the specified reverse, surge, interruption, hot-plug, and short profiles | Critical, before release |
| QER-V03 thermal correlation | Regulators/protection/connectors | PCB/enclosure geometry controls temperature | Correlate worst-case model at 9 V, 21 V, −20 °C, +60 °C ambient and maximum loads | Critical, before release |
| QER-V04 regulator stability | Power conversion | Exact passives/layout affect loop response | Vendor-tool analysis plus load-step/startup/brownout test using effective capacitance | Critical, before footprint acceptance |
| QER-V05 connector family | J1 and other interfaces | Orderable mechanics remain unselected | Select against Section 8 and ICD-002; verify mating, temperature rise, keying and pull | High, during component selection |
| QER-V06 native ERC | All sheets | Structural validation is not electrical-rule validation | Run and disposition native KiCad ERC after exact symbols are introduced | High, before PCB entry |
| QER-V07 environmental qualification | Assembly | Requirements need physical evidence | Run the specified temperature, humidity, vibration and shock profiles on the released enclosure/board assembly | High, before product release |
| QER-V08 reliability calculation | Complete BOM | MTBF cannot be calculated without exact parts | Perform BOM-based prediction against the 50,000 h target after component freeze; safety remains fault-behavior based | Medium, before production release |

Changes to any numeric limit in Sections 2–10 require controlled requirements review and impact analysis. Prototype measurements may close evidence tasks but shall not broaden the envelope without an approved revision.

### Change history

| Date | Amendment | Preserved original requirement | Controlled disposition |
|---|---|---|---|
| 2026-07-31 | QER-02 | Affected branches: 100 mA continuous, 150 mA/10 ms peak; generic limit maximum 150% of continuous | Peak unchanged and completed with no more than 1 Hz/1% duty; affected fault threshold superseded by 160–225 mA. Unrelated requirements unchanged. |

## 13. Component-Selection Entry Criteria

CSR-01A-R may select power components only when each candidate demonstrates:

- every applicable operating and absolute stress limit in this QER;
- worst-case tolerance and temperature calculations;
- compliance with the controlling ADR/ICD where it is narrower;
- lifecycle, compliance, sourcing, alternate, and order-code evidence;
- no dependency on PCB geometry that cannot be stated as a footprint/layout constraint; and
- an explicit validation method for each unverified model assumption.

QER-01 does not authorize schematic edits, MPN selection, footprint assignment, or PCB layout.

## 14. Final Decision

# QER-01 ACCEPTED

CSR-01A-R — Power Component Selection (Reattempt) is authorized within the unchanged Rev A architecture and the quantitative limits of this document.
