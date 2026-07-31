# SSR-01 — IPC-100 Rev A System Schematic Release Review

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Review date | 2026-07-30 |
| Scope | Complete Sheet 00–09 integrated electrical design |
| Review type | Formal pre-layout schematic release |
| Owner | Iron Pine Outdoors Engineering |

## Executive Summary

The IPC-100 Rev A preliminary schematic is structurally coherent and preserves the frozen architecture. Repository validation confirms synchronized hierarchy, unique references and UUIDs, a conflict-free GPIO allocation, deterministic authorization defaults, one watchdog-service route, and zero footprints.

The design is not ready for footprint assignment. SSR-01 identified four Major blocking implementation groups:

1. ICD-002 requires independently power-qualified, fail-isolated J6 and J7 I²C branches. Sheet 07 instead places `J6_I2C_*` and `J7_I2C_*` hierarchical labels directly on the common `I2C_SDA/SCL` base nets. No branch switch/buffer, independent enable, power-off isolation, or 10 µA/0.2 V backfeed implementation exists.
2. Sheet 09 does not implement the connector-entry USB ESD and configurable shield network assigned to it. J13 is represented by a generic 12-contact connector abstraction, not a USB-C receptacle boundary with the complete released contact grouping and unused-pin treatment.
3. Exact orderable devices, vendor pin mappings, ratings, tolerances, and quantitative proofs remain open across power, supervised safety inputs, motion translators, watchdog/authorization logic, relay, UI, expansion, and connectors.
4. Native KiCad ERC has never been run, and known findings therefore cannot be classified.

No Critical finding was identified: the frozen safety architecture and deterministic defaults are directionally sound. The Major findings block schematic release and Package 11.

## Architecture Assessment

ADR-039 through ADR-044 remain internally consistent. Sheet ownership is clear: power entry/conversion on Sheets 01/02, MCU/GPIO on Sheet 03, supervised inputs on Sheet 04, motion conditioning on Sheet 05, authorization/watchdog/relay on Sheet 06, UI/base I²C on Sheet 07, restricted expansion on Sheet 08, and physical interfaces on Sheet 09.

GPIO37 remains reserved. GPIO42 remains solely `WATCHDOG_SERVICE_MCU`. No raw GPIO name appears outside Sheet 03. No architecture change is recommended; the blockers are implementation and release-evidence defects.

## Power Assessment

The intended 9–21 V entry, protected main path, USB-only core service, main-priority source selection, branch gating, and fail-low `MAIN_POWER_GOOD` topology are coherent. USB-only does not intentionally energize actuator, UI, sensor, OLED, or expansion rails.

Release evidence is incomplete: total and simultaneous current budgets, abnormal-input pulse energy, exact regulator/eFuse suffixes and passives, source-transition interruption/inrush, reverse leakage, thermal margins, and brownout timing remain open. These affect component and footprint selection and therefore block Package 11.

## Safety Assessment

The intended chain is:

`STOP supervision + MAIN_POWER_GOOD + RESET_VALID + WATCHDOG_VALID → ACTUATOR_PERMIT / MASTER_INHIBIT → motion OE and relay gate`.

ECO-001/ECO-002 restored authorization connectivity and local deterministic bias. Sheet 06 owns independent watchdog qualification and hardware authorization. Commands cannot intentionally bypass the authorization chain, opposing PWM suppression remains hardware-based, relay de-energized is the safe state, and loss of relevant power defaults outputs inactive.

The safety topology is acceptable for preliminary capture, but exact comparator/logic/watchdog parts, worst-case thresholds and timing, partial-power behavior, relay stress/contact life, and single-fault/prototype evidence remain mandatory before release.

## Signal Ownership Audit

| Audit | Result |
| --- | --- |
| Root/child port parity | Pass |
| GPIO uniqueness and ownership | Pass |
| Raw GPIO confinement | Pass |
| Watchdog-service producer/consumer | Pass |
| Authorization producer/consumer and bias | Pass |
| Motion command ownership/suppression | Pass |
| J10 segmented interface ownership | Pass |
| J6/J7 hierarchy names | Structurally present, electrically noncompliant with ICD-002 isolation |
| Sheet 09 54+4 port inventory | Documented and structurally present |
| Duplicate references/UUIDs | None reported |
| Orphan electrical intent | USB connector-entry protection and shield options missing from capture |

Structural name matching does not prove the analog, partial-power, isolation, or pin-level electrical behavior.

## Connector Assessment

J1–J10 and J13 designation groups are represented, with J8 split into J8A STOP and J8B ordinary UI. J11/J12 remain documentation-only. J10 is DNP by default. J9 retains its restricted 0–30 VDC SELV/1 A resistive envelope. DFT1 is factory-only and nonpopulated.

Blocking connector defects:

- J6/J7 do not have the independently power-qualified fail-isolated branches required by ICD-002.
- J13 is not a complete USB-C receptacle representation.
- Connector-entry D+/D− ESD, VBUS ESD/handoff, and released shield-coupling options are absent.
- Exact connector families, pin/contact ratings, keying, retention, sealing, and mechanical access remain unresolved.

## Manufacturing Assessment

MFG-01’s major observations remain applicable. Generic symbols and blank footprints appropriately prevent premature procurement, but exact part/AVL/footprint qualification, preferred passive sizes, assembly process, creepage/clearance, RF keepout, relay separation, connector access, and environmental sealing must precede layout.

## DFM

Positive provisions include product-neutral interfaces, isolated relay contacts, modular harnesses, J8 safety/UI partitioning, DNP expansion, and no speculative J11/J12 population. DFM is blocked by the missing exact-part/footprint library release, connector mechanical definition, enclosure interface, thermal evidence, and board-zone/keepout plan.

## DFT

Native USB and UART0 recovery are preserved. DFT1 exposes UART TX/RX, EN, BOOT, GND, and sense-only 3V3 with a ground-first fixture contract. Existing schematic DFT nodes support rail and functional observation.

Before layout, issue a controlled test-access matrix covering power rails, safety thresholds, watchdog, permit/inhibit, pre/post-gate motion nodes, relay drive, and connector continuity. Define target geometry, fixture current limits, test limits, and production sequencing.

## Serviceability

The J8 split, USB service access, replaceable harness philosophy, and documentation-only future interfaces improve service fault containment. Remaining work includes enclosure access, labels, moisture restrictions, connector mating-cycle/retention decisions, fuse access, relay replacement policy, and field diagnostic procedures.

## Findings

| ID | Class | Description | Affected sheets | Risk | Recommended action | Blocking |
| --- | --- | --- | --- | --- | --- | --- |
| SSR-01-F01 | Major | J6/J7 connector aliases directly share the base I²C nets; ICD-002 branch isolation is absent | 07, 09, 00 | Unpowered module backfeed or connector fault can disturb the core bus/UI expander | ECO implementing two independent power-qualified fail-isolated branches and their quantitative limits | Yes |
| SSR-01-F02 | Major | J13 lacks a complete USB-C receptacle/contact boundary and Sheet 09 USB ESD/shield circuitry | 09, 01, 03 | ESD susceptibility, ambiguous pin mapping, noncompliant shield/current path, footprint-selection error | Replace abstraction with reviewed USB-C UFP symbol; capture assigned ESD and DNP shield network; audit VBUS handoff | Yes |
| SSR-01-F03 | Major | Numerous component classes/provisional devices lack exact orderable suffix, vendor pin audit, rating/tolerance closure, and footprints | 01–09 | Wrong pinout/rating or unachievable layout; safety/power behavior not proven | Exact-part/BOM/AVL and worst-case review by sheet before footprint release | Yes |
| SSR-01-F04 | Major | Native ERC unavailable and never classified | 00–09 | Hidden electrical-type, power-pin, or no-connect errors | Run native ERC with released symbols; classify every finding | Yes |
| SSR-01-F05 | Major | Power/current/transition/thermal and safety timing/single-fault analyses remain open | 01, 02, 04–08 | Brownout, backfeed, overload, timing, or partial-power unsafe behavior | Close quantitative ODIs with calculation, simulation, and bench plans | Yes |
| SSR-01-F06 | Minor | Sheet 09 retains Package 01 placeholder text alongside Package 10R content | 09 | Document-control ambiguity | Remove obsolete placeholder text in the corrective package | No |
| SSR-01-F07 | Minor | DFT1 uses a generic connector-shaped logical symbol rather than discrete pogo targets | 09 | Fixture intent may be mistaken for a populated connector | Use explicit non-BOM/non-board test-target convention and mapping | No |
| SSR-01-F08 | Observation | Frozen hierarchy, GPIO allocation, watchdog route, and authorization defaults pass repository regression | 00–09 | Positive control baseline | Preserve and extend validators | No |

## Remaining Release Gates

- Correct SSR-01-F01 and F02 in schematics.
- Select exact orderable parts and approve vendor pin mappings.
- Complete BOM/AVL and footprint-library review.
- Run and classify native ERC.
- Close power budget, source transition, thermal, abnormal-input, and brownout evidence.
- Close safety thresholds, timing, single-fault, partial-power, relay, and external-driver evidence.
- Select connector families and validate keying, ratings, sealing, retention, and harnesses.
- Complete USB SI/ESD/EMC and shield strategy.
- Define enclosure/mechanical interfaces and PCB constraints.
- Approve DFM/DFT and prototype/production test plans.

## Risk Register

| Risk | Likelihood | Severity | Control |
| --- | --- | --- | --- |
| Base I²C disabled/backpowered by J6/J7 | Medium | Major | Independent branch isolation and fault injection |
| USB ESD or contact-map failure | Medium | Major | Complete UFP capture, ESD selection, SI/EMC review |
| Provisional custom-symbol pin mismatch | Medium | Major | Vendor-symbol audit plus ERC |
| Power transition/brownout anomaly | Medium | Major | Worst-case analysis and instrumented prototype tests |
| Safety threshold/timing miss | Low–Medium | Major | Tolerance analysis, simulation, single-fault tests |
| Connector mis-mating/environmental failure | Medium | Major | Keying, sealing, labeling, harness qualification |

## Recommendations

1. Issue one bounded schematic-correction package for F01/F02/F06/F07.
2. Establish an exact-part release checklist per sheet before any footprint is assigned.
3. Install an approved KiCad CLI environment and treat clean classified ERC as a hard gate.
4. Create calculation records for power, safety, watchdog, relay, motion, USB, and I²C worst cases.
5. Reissue SSR-01 after corrections; do not combine reissue with footprint assignment.

## Readiness Assessment

The Rev A architecture is stable and worth preserving. Preliminary capture is complete enough to identify the physical implementation work, but it is not a released schematic. Package 11 would force footprint decisions while required circuitry and exact parts remain unresolved.

## Final Decision

# SCHEMATIC RELEASE NOT APPROVED

PACKAGE 11 and Footprint Assignment are not authorized.
