# IPC-100 Rev A External Safety Interface Control Document

| Document control | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Authority | ADR-042 / AR-04 |
| Status | Accepted architecture contract for preliminary capture |
| Controlled sheets | 04, 05, and 06 |
| Date | 2026-07-30 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose and precedence

This interface control document (ICD) is the controlling Rev A reference for external safety contacts, command contacts, actuator permission, and the boundaries between Sheets 04–06. It resolves conflicting or stale `TBD` language in earlier architecture-stage documents. If an earlier document conflicts with this ICD on a subject controlled here, this ICD and ADR-042 take precedence.

IPC-100 is a product-neutral controller with deterministic protective behavior. It is not represented as a certified safety PLC, dual-channel emergency-stop device, or complete machine-safety system. Product hazard analysis, stopping distance, guards, redundant energy isolation, and regulatory compliance remain product responsibilities.

## 2. Rev A field-input standard

| Attribute | Frozen Rev A contract |
| --- | --- |
| Field source | `FIELD_SENSE_VCC`, 5.0 V nominal, main-only and hardware-qualified by Sheet 02 |
| USB-only state | `FIELD_SENSE_VCC` off; every Sheet 04 output assumes its conservative state without backfeeding `+3V3_CORE` |
| Grounding | Common IPC-100 logic ground per ADR-035; every supervised loop has a dedicated routed return and is not aliased to a connector ground |
| Supervised source resistance | 2.20 kΩ ±1% per STOP/limit loop |
| Remote termination | 2.20 kΩ ±1% EOL at the NC field contact |
| Loop current | 1.136 mA nominal healthy; 2.273 mA maximum nominal short current per loop; 11.4 mA for five simultaneous shorts |
| Command wetting | ARM/FIRE use `FIELD_SENSE_VCC` through 10.0 kΩ ±1%; 0.5 mA nominal closed-contact current |
| Cable | 10 m maximum per input loop; 2 nF maximum total loop capacitance; 18–24 AWG stranded copper |
| Routing | Dedicated pair for every supervised loop; route separately from motor, relay-contact, and converter-switch nodes |
| Shield | No shield required in the baseline 10 m environment. If product EMC testing requires one, terminate the shield to chassis/enclosure at cable entry; never use it as the signal return |
| Board connector | Micro-Fit 3.0 class is the preliminary internal-board family for J4/J5 and a separately partitioned STOP connection; exact order codes remain a Sheet 09/PCB release item |
| Exposed harness | Product-owned sealed and keyed connector, Deutsch DTM/DT class or qualified equivalent |
| Environment | Low-voltage wiring inside or attached to outdoor equipment, routed away from ignition and motor conductors; –40 to +85 °C component design range |
| ESD objective | ±8 kV IEC 61000-4-2 contact-discharge design objective at accessible product connectors; compliance requires final enclosure/PCB testing |
| Surge/miswire | Survive shorts to field return and `FIELD_SENSE_VCC` indefinitely within branch limits. External voltage injection, automotive pulse compliance, and shorts to battery/VIN are outside the Rev A interface contract and shall be prevented by the product harness |
| EMC objective | Correct operation with the released cable/routing limits; final conducted/radiated immunity and emissions levels are product-test requirements |
| Isolation | No galvanic isolation baseline; field protection and translation prevent direct field-to-ESP32 connection |

Every future external discrete input shall use this standard unless an accepted ADR explicitly overrides it.

## 3. Contact and state standard

### 3.1 Supervised NC protective loops

STOP and all four limits use individually returned, de-energize-to-safe, normally-closed dry contacts.

| Electrical state | Sense voltage | Interpretation | Required result |
| --- | ---: | --- | --- |
| Short to dedicated return | `<1.00 V` | Electrical fault | Conservative asserted/inhibit state; local fault indication |
| Healthy NC contact plus EOL | `1.00–4.00 V`, 2.50 V nominal | Healthy/inactive | May participate in authorization |
| Open contact or open wire | `>4.00 V`, 5.00 V nominal | Asserted/open | Conservative inhibit; open cannot be distinguished from intentional actuation by the MCU |
| Invalid rail/window/startup | Indeterminate | Unknown/fault | Conservative inhibit |
| Short to `FIELD_SENSE_VCC` | `>4.00 V` | Asserted/open-equivalent | Conservative inhibit; local fault determination only where electrically distinguishable |

Comparator tolerances and at least 50 mV target hysteresis shall preserve the 1.00 V and 4.00 V boundaries. Hysteresis resistors are preliminary DNP/tuning provisions until worst-case analysis and SPICE approve population.

### 3.2 NO command contacts

ARM and FIRE are momentary normally-open dry contacts. Their field side is biased from main-only `FIELD_SENSE_VCC`; Sheet 04 protects and translates each signal to `+3V3_CORE`. Open, disconnected, unpowered, unknown, or invalid means inactive. Contact closure means asserted only after firmware qualification. A held or shorted contact is an illegal held state, never a continuing authorization.

## 4. Controlled signal inventory and ownership

Polarity is stated at the named functional net. `_RAW` nets are analog field nodes and have no Boolean polarity.

| Signal | Purpose / source | Producer | Consumer | Owner | Domain | Asserted polarity | FW | HW | Class | Diagnostic / timing |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `STOP_IN_RAW`, `STOP_RETURN` | External NC STOP loop | Sheet 09/harness | Sheet 04 | 04 electrical; product contact | 5 V field | Analog window | No | Yes | Safety Critical | Full window; hardware inhibit ≤5 ms |
| `STOP_IN_COND` | Conservative STOP observation | Sheet 04 | Sheet 03 GPIO2 | 04 | 3.3 V | High = STOP/open/fault/unknown | Yes | Yes | Safety Critical | Firmware assertion ≤2 ms; release 20 ms |
| `STOP_HW_INHIBIT` | Independent STOP authorization removal | Sheet 04 | Sheet 06 | 04 | 3.3 V hardware logic | High = inhibit | No | Yes | Safety Critical | Assert ≤5 ms from loop opening; fail high |
| `LIMIT_LEFT_RAW`, `LIMIT_LEFT_RETURN` | Left endpoint NC loop | Sheet 09/harness | Sheet 04 | 04 electrical; product contact | 5 V field | Analog window | No | Yes | Safety Critical | Full window; independent return |
| `LIMIT_RIGHT_RAW`, `LIMIT_RIGHT_RETURN` | Right endpoint NC loop | Sheet 09/harness | Sheet 04 | Same | 5 V field | Analog window | No | Yes | Safety Critical | Full window; independent return |
| `LIMIT_UP_RAW`, `LIMIT_UP_RETURN` | Upper endpoint NC loop | Sheet 09/harness | Sheet 04 | Same | 5 V field | Analog window | No | Yes | Safety Critical | Full window; independent return |
| `LIMIT_DOWN_RAW`, `LIMIT_DOWN_RETURN` | Lower endpoint NC loop | Sheet 09/harness | Sheet 04 | Same | 5 V field | Analog window | No | Yes | Safety Critical | Full window; independent return |
| `LIMIT_LEFT_COND` | Left limit observation | Sheet 04 | Sheet 03 GPIO4 | 04 | 3.3 V | High = asserted/fault/unknown | Yes | Yes | Safety Critical | Firmware assertion ≤5 ms; release 20 ms |
| `LIMIT_RIGHT_COND` | Right limit observation | Sheet 04 | Sheet 03 GPIO5 | 04 | 3.3 V | High = asserted/fault/unknown | Yes | Yes | Safety Critical | Same |
| `LIMIT_UP_COND` | Upper limit observation | Sheet 04 | Sheet 03 GPIO6 | 04 | 3.3 V | High = asserted/fault/unknown | Yes | Yes | Safety Critical | Same |
| `LIMIT_DOWN_COND` | Lower limit observation | Sheet 04 | Sheet 03 GPIO7 | 04 | 3.3 V | High = asserted/fault/unknown | Yes | Yes | Safety Critical | Same |
| `ARM_IN_RAW` | External NO ARM command | Sheet 09/harness | Sheet 04 | 04 electrical; firmware sequence | 5 V field | Contact closure | No | Yes | Operational | Protected; held-state diagnostic |
| `ARM_IN_COND` | Qualified ARM input source | Sheet 04 | Sheet 03 GPIO8 | 04 | 3.3 V | High = contact closed | Yes | Yes | Operational | 10 ms stable; release required |
| `FIRE_IN_RAW` | External NO FIRE command | Sheet 09/harness | Sheet 04 | 04 electrical; firmware sequence | 5 V field | Contact closure | No | Yes | Operational | Protected; held-state diagnostic |
| `FIRE_IN_COND` | Qualified FIRE input source | Sheet 04 | Sheet 03 GPIO9 | 04 | 3.3 V | High = contact closed | Yes | Yes | Operational | 10 ms stable; new edge required |
| `MAIN_POWER_GOOD` | Qualified main source | Sheet 02 | Sheet 06 | 02 | 3.3 V logic | High = valid | No | Yes | Safety Critical | Fail low |
| `RESET_VALID` | Processor reset released | Sheet 03 | Sheet 06 | 03 | 3.3 V logic | High = released/valid | No | Yes | Safety Critical | Fail low |
| `WATCHDOG_VALID` | Independent control-flow qualification | Sheet 06 watchdog | Sheet 06 permit logic; test point | 06 | 3.3 V logic | High = valid | Service only | Yes | Safety Critical | 250 ms nominal timeout; fail low |
| `ACTUATOR_PERMIT` | Sole positive actuator authorization | Sheet 06 | Sheet 05 and Sheet 06 relay gate | 06 | 3.3 V logic | High = permitted | No | Yes | Safety Critical | Fail low; prototype/production test |
| `MASTER_INHIBIT` | Complementary inhibit status/control | Sheet 06 | Sheet 05 | 06 | 3.3 V logic | High = force safe | No | Yes | Safety Critical | `NOT ACTUATOR_PERMIT`; fail high |
| `RELAY_CMD_MCU` | Firmware relay request | Sheet 03 GPIO39 | Sheet 06 | 03 intent; 06 enforcement | 3.3 V | High = request | Yes | Yes | Operational | Cannot bypass permit |
| `AXIS1/2_*_MCU` | Eight firmware motion requests | Sheet 03 | Sheet 05 | 03 intent; 05 enforcement | 3.3 V | High/PWM = request | Yes | Yes | Operational | Cannot bypass permit/inhibit |
| `AXIS1/2_*_SAFE` | Eight post-inhibit motor commands | Sheet 05 | Sheet 09/external drivers | 05 | 5 V main-only | High/PWM = command | No | Yes | Safety Critical | Inactive without permit |

`ENABLE`, `THROWER_READY`, `EXTERNAL_READY`, `REMOTE_INHIBIT`, guard/lid, home/reference, and external-permission signals are **not implemented or reserved in IPC-100 Rev A**. Axis `REN`/`LEN` are motor-driver commands, not a general external ENABLE. Adding any omitted signal requires a new ADR, GPIO/resource review, hierarchy update, and connector contract.

## 5. ARM, FIRE, and authorization behavior

ARM and FIRE are firmware-observed requests only. Neither enters `ACTUATOR_PERMIT`, directly drives an actuator, latches in hardware, or survives reset. Firmware shall reject ARM/FIRE held at startup, FIRE before ARM, simultaneous startup assertion, stale commands, and FIRE retrigger without release.

The sole Rev A authorization equation is:

`ACTUATOR_PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`MASTER_INHIBIT = NOT ACTUATOR_PERMIT`

USB-only power, loss of main, reset, watchdog invalidity, STOP open/fault/unknown, or absent Sheet 04/06 forces permit low and inhibit high. Restoration never replays a command. Firmware must reinitialize, observe stable inputs, clear stale authorization, and require a new valid sequence.

There is no Thrower Ready, External Ready, or Remote Inhibit input in Rev A. Product readiness is a firmware state derived from approved existing observations and must not be presented as independent hardware proof.

## 6. Fault architecture

| Fault | Hardware action | Processor visibility | Latch / reset |
| --- | --- | --- | --- |
| STOP low-window short | Assert `STOP_HW_INHIBIT` and `STOP_IN_COND`; expose `STOP_FAULT` at a labeled Sheet 04 test node | Generic asserted STOP only | Firmware latches generic STOP event; electrical subtype service-latched until healthy and deliberate reset |
| STOP open/high window | Same conservative action | Generic asserted STOP | Event logged; deliberate re-arm after stable 20 ms release |
| Limit low-window short | Assert affected conditioned limit; expose corresponding local fault test node | Generic affected limit only | Firmware latches affected input event; deliberate fault clear |
| Limit open/high window | Assert affected conditioned limit | Generic affected limit | Direction remains inhibited until stable 20 ms release and new command |
| Opposing limits asserted | No new analog summary | Both conditioned inputs visible | Firmware latches axis conflict and inhibits both directions |
| ARM/FIRE held/shorted | Defined asserted input; no direct output | Individual conditioned input | Firmware rejects and logs; release required |
| Field-source loss | Passive conservative STOP/limits and inactive commands | Conservative inputs; no separate rail GPIO | Hardware inhibit persists; reinitialize after main recovery |
| Permit qualifier loss | `ACTUATOR_PERMIT` low, `MASTER_INHIBIT` high | No GPIO feedback in Rev A | Hardware recovers only after all qualifiers; firmware issues new command |

`STOP_FAULT` and four `LIMIT_*_FAULT` names are local Sheet 04 diagnostic/test nets, active high. They have no hierarchical consumer and no direct processor GPIO. `INPUT_FAULT_SUMMARY` and `MASTER_INHIBIT_STATUS` are not adopted in Rev A and shall be removed from preliminary hierarchy placeholders when their owning sheet is implemented. `WATCHDOG_VALID` is a Sheet 06 internal/test signal, not processor feedback.

This deliberate allocation limitation means firmware cannot distinguish intentional contact opening from open wire, or every short-to-supply case. It logs the conservative functional event and available context. Production/service fixtures observe individual analog windows and fault test nodes. No documentation may claim remote electrical-subtype diagnostics.

## 7. Hardware and firmware responsibility

| Decision | Responsibility | Rationale |
| --- | --- | --- |
| Field protection, windows, deterministic defaults | Hardware | Must exist before and without firmware |
| STOP authorization removal | Hardware + firmware | Hardware removes permit; firmware logs, cancels state, and controls guarded recovery |
| Directional limit enforcement | Hardware conditioning + firmware policy | Hardware guarantees a conservative input; firmware knows commanded direction. Rev A is not a safety-rated motion controller |
| ARM/FIRE sequencing | Firmware | Operational workflow; hardware only protects, biases, and conditions |
| Main/reset/watchdog qualification | Hardware | Processor intent cannot validate itself |
| Motor/relay safe-state gating | Hardware | MCU output or crash cannot bypass authorization |
| Fault logging and deliberate recovery | Firmware | Persistence and user workflow require state; hardware remains conservative while firmware is unavailable |

## 8. Timing contract

| Event / function | Maximum or required timing |
| --- | --- |
| Field input RC | 1 kΩ / 100 nF nominal, `τ = 100 µs`; final tolerance analysis required |
| STOP hardware path | `ACTUATOR_PERMIT` low within 5 ms of loop opening, invalid window, or conditioning loss |
| STOP firmware assertion | Qualified within 2 ms; firmware never delays hardware inhibit |
| STOP release | 20 ms stable healthy plus deliberate software recovery |
| Limit assertion | Firmware-qualified within 5 ms of conditioned assertion |
| Limit release | 20 ms stable before accepting motion away/new motion policy |
| ARM/FIRE | 10 ms stable assertion and release; release-before-retrigger |
| Fault-window detection | Local comparator/fault logic settled within 2 ms |
| Processor servicing | Interrupt preferred; if polled, STOP/limits ≤1 ms period and ARM/FIRE ≤5 ms period |
| Watchdog | 250 ms nominal window/timeout; supervised task services at 50–100 ms |
| Sheet 05 electronic inhibit | Safe outputs inactive within 1 ms of permit loss; included in the 5 ms STOP-to-command-removal budget |
| Relay coil drive | De-energized within 5 ms of permit loss |
| Relay contact release | 20 ms maximum system design target from permit loss; verify with selected relay over voltage/temperature before release |
| Direction reversal | Both enables and PWM inactive for at least 20 ms before opposite command; product validation may increase this |

## 9. Sheet and power-domain ownership

| Sheet | Exclusive responsibility |
| --- | --- |
| 02 | Generate main-only `FIELD_SENSE_VCC`; generate `MAIN_POWER_GOOD`; prevent USB-only field energization |
| 03 | Terminate only ADR-040 GPIO functional nets; produce firmware intent and `RESET_VALID`; no raw field input or permit decision |
| 04 | Protect/excite/supervise/translate STOP, four limits, ARM, and FIRE; create conservative outputs and independent STOP hardware inhibit |
| 05 | Translate and gate eight motor commands; enforce permit/inhibit; never generate authorization |
| 06 | Generate watchdog qualification, `ACTUATOR_PERMIT`, and `MASTER_INHIBIT`; gate relay command and drive coil |
| 09 | Own physical connectors, shield/chassis entry, ESD placement coordination, and test-point implementation |
| Product/harness | Contact selection, remote EOL placement, sealed external connector, cable routing, guards/stops, and hazard controls |

## 10. Package 05R authorization

The architecture entry gate for Sheet 04 is closed by ADR-042. Package 05R is authorized to implement only the seven listed field inputs, local diagnostic nodes, and `STOP_HW_INHIBIT` using this ICD. No additional architecture package is expected before Sheet 04 capture. Exact orderable parts, worst-case threshold/SPICE evidence, ERC disposition, and prototype validation remain implementation/release work, not ownership ambiguity.

