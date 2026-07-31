# CSR-01A — Power Component Selection

**Package:** 11A  
**Scope:** Power subsystem only  
**Date:** 2026-07-31  
**Baseline:** IPC-100 Rev A after ECO-005  

## Executive Summary

CSR-01A reviewed the power-related content of Sheets 01, 02, 03, 07, 08, and 09. The review identifies 124 power-scope EBOM rows and 177 unrelated rows. The unrelated rows are explicitly marked `NOT YET FROZEN`.

No power component is frozen. The released design does not yet define the quantitative source, load, transient, thermal, timing, and physical-interface limits needed to select and derate every power part. Assigning exact order codes now would convert provisional assumptions into procurement data without proving that the parts preserve the frozen architecture.

CSR-01A therefore updates the EBOM and AVL as controlled blocked inventories. It does not assign footprints, change schematic logic, or authorize PCB work.

## Reviewed Scope

| Sheet | Power-scope rows | Reviewed content |
|---|---:|---|
| 01 — Power Entry | 35 | J1 input path, fuse, transient protection, reverse-polarity stage, battery measurement, USB power protection |
| 02 — Power Conversion | 77 | 5 V and 3.3 V conversion, source mux, branch switches, current limiting, qualification and support passives |
| 03 — ESP32 Core | 3 | Reset supervisor supply/timing/bypass components |
| 07 — UI & Peripherals | 2 | OLED and sensor supply qualification functions |
| 08 — Expansion | 5 | Expansion rail qualification, filtering, reservoir and protection |
| 09 — Connectors & Test | 2 | J1 power-entry connector and J13 VBUS protection |
| **Total** | **124** | **CSR-01A power scope** |

All 301 schematic inventory rows remain present. No reference, quantity, schematic value, UUID, net, interface, GPIO, or hierarchy assignment is changed.

## Power Tree Reviewed

The frozen functional path remains:

1. `VIN_RAW` enters at J1 and passes through Sheet 01 input protection, reverse-polarity control, current control, filtering, and measurement to `VIN_PROTECTED`.
2. Sheet 02 converts `VIN_PROTECTED` to `+5V_MAIN`.
3. Protected USB 5 V and `+5V_MAIN` feed the controlled source-selection path.
4. The selected core source feeds the 3.3 V regulator and `+3V3_CORE`.
5. Sheet 02 controlled switches distribute OLED, sensor, UI, expansion, relay, field, and motor-interface rails under the frozen request/qualification scheme.
6. Sheets 03, 07, 08, and 09 contain power supervision, rail qualification, filtering, protection, or the physical power boundary.

This review does not alter that tree.

## Candidate Family Review

Candidate families captured in the preliminary schematic were checked against current manufacturer product information. Family-level suitability is not an orderable-part freeze.

| Function | Captured family | Manufacturer evidence | CSR-01A disposition |
|---|---|---|---|
| Wide-input protection/eFuse | TPS2663 | Active; 4.5–60 V operating range, adjustable 0.6–6 A limit, external N-channel FET used for reverse protection | Not frozen: input surge waveform, source impedance, current limit, external-FET SOA and thermal design are unresolved |
| USB/input eFuse | TPS25947 | Active; 2.7–23 V operating range, 28 V absolute maximum, adjustable current limit | Not frozen: protected-source maximum, surge coordination, current target and thermal rise are unresolved |
| Main buck | LMR38020-Q1 | Active; 4.2–80 V, 2 A automotive synchronous buck | Not frozen: exact load, switching frequency, magnetics, compensation/stability, effective capacitance and enclosure thermal limits are unresolved |
| Power mux | TPS2121 | Active; 2.7–22 V, 4 A per input and 4.5 A current limit | Not frozen: simultaneous load, switchover behavior, inrush, backfeed and brownout timing are unresolved |
| Core buck | TPS62130 | Active, with a newer manufacturer-recommended family available; 3–17 V, 3 A | Not frozen: lifecycle choice, exact load/transient requirement, passives, stability and thermal margins are unresolved |
| Branch switch | TPS22918-Q1 | Active; 1–5.5 V, 2 A, controlled rise time and quick-output-discharge option | Not frozen: each branch load, discharge behavior, rise time and fault-current contract are unresolved |
| Current-limited switch | TPS2553-Q1 | Active; 2.5–6.5 V and resistor-programmable current limiting | Not frozen: branch current limits, tolerance stack, short-circuit duration and thermal response are unresolved |
| Reset supervisor | TPS3890-Q1 | Active; multiple threshold/delay variants | Not frozen: reset threshold, delay, hysteresis and exact suffix are unresolved |

Manufacturer references: [TPS2663](https://www.ti.com/product/TPS2663), [TPS25947](https://www.ti.com/product/TPS25947), [LMR38020-Q1](https://www.ti.com/product/LMR38020-Q1), [TPS2121](https://www.ti.com/product/TPS2121), [TPS62130](https://www.ti.com/product/TPS62130), [TPS22918-Q1](https://www.ti.com/product/TPS22918-Q1), [TPS2553-Q1](https://www.ti.com/product/TPS2553-Q1), and [TPS3890-Q1](https://www.ti.com/product/TPS3890-Q1).

## Quantitative and Derating Review

The normal input requirement of 9–21 V is defined, but it is not a complete component stress envelope. The following calculations cannot be closed from released inputs:

| Calculation | Required inputs still missing | Affected selection |
|---|---|---|
| TVS pulse energy and clamp | Surge waveform, repetition, source impedance, cable inductance, maximum downstream withstand voltage | D101 and coordinated input path |
| Fuse clearing and nuisance margin | Continuous current, cold-start/inrush profile, fault current, source impedance, ambient derating, interrupt requirement | F101 |
| Reverse-FET conduction and SOA | Peak/continuous input current, transient duration, gate clamp behavior, copper thermal impedance | Q101 and gate network |
| Buck current and temperature | Per-rail maximum/typical loads, simultaneous-load state, efficiency curve, switching frequency, ambient/enclosure/copper thermal model | U201, U203, L201, L202 and associated passives |
| Inductor saturation/ripple | Switching operating point, worst-case duty cycle, peak current, allowed ripple, temperature rise | L101, L201, L202 |
| Capacitor effective value | Bias voltage, ripple current, temperature, tolerance, aging, stability minimum/maximum and transient target | Power capacitors on Sheets 01/02/03/08 |
| Mux/eFuse loss | Load and inrush current, switchover overlap, brownout profile, RDS(on) tolerance and board thermal resistance | U101, U102, U202 |
| Branch-switch limits | Exact OLED, BME280, UI, relay, field, motor-interface and expansion loads; cable capacitance; short duration | U206–U213, U706, U707, U801 |
| Supervisor threshold/timing | Approved reset assert/release thresholds, rail ramp, brownout and hold timing | U302, C305 |
| Connector temperature rise | Contact current, pin allocation, mating cycle, sealing/environment and allowable rise | J1 |

Consequently, voltage, current, power, junction-temperature, pulse-energy, saturation, tolerance, and lifetime derating cannot be demonstrated for every in-scope row. Existing schematic values remain preliminary engineering intent, not approved procurement specifications.

## Passive Component Review

Resistor and capacitor values captured in the schematic were inventoried, but value alone is insufficient for release. Exact packages, voltage coefficients, power/pulse ratings, temperature coefficients, dielectric classes, tolerances, aging, ripple ratings, and automotive/environmental grades remain unresolved where applicable. Magnetics likewise require saturation-current, RMS-current, DCR, core-loss, temperature-rise and availability evidence.

No passive family or manufacturer part number is approved by this review.

## Sourcing, AVL, Lifecycle, and Cost

The AVL contains no approved vendor row because no exact orderable MPN passed electrical and derating review. Distributor stock, alternates, lifecycle, RoHS status, packaging quantity, lead time and pricing cannot be validly compared at family level. A Rev A unit-cost total is therefore not released.

The EBOM and AVL use two explicit dispositions:

- `BLOCKED - CSR-01A` for the 124 power-scope rows.
- `NOT YET FROZEN` for the 177 unrelated rows outside this package.

Neither disposition authorizes procurement or footprint assignment.

## Findings and Closure Actions

| Finding | Severity | Required closure |
|---|---|---|
| CSR-01A-F01: The source transient and fault envelope is incomplete | Critical | Release surge, source-impedance, fault-current, repetition and downstream clamp limits; coordinate J1, fuse, TVS, eFuse and reverse-FET ratings |
| CSR-01A-F02: Rail and branch loads are incomplete | Critical | Release typical, peak, inrush and simultaneous-load budgets for every controlled rail |
| CSR-01A-F03: Thermal design limits are incomplete | Critical | Release ambient/enclosure limits, allowed temperature rise and preliminary copper thermal assumptions |
| CSR-01A-F04: Stability and energy-storage calculations are incomplete | Critical | Calculate exact regulator frequency/inductors, capacitor effective values, ripple and transient response against vendor requirements |
| CSR-01A-F05: Source transitions and brownout timing are incomplete | Major | Quantify USB/main switchover, backfeed, startup, shutdown, reset and brownout behavior |
| CSR-01A-F06: J1 orderable interface is unresolved | Major | Release contact current, pinout, retention, environmental and mating requirements before connector selection |
| CSR-01A-F07: Exact order codes and sourcing evidence are absent | Major | After F01–F06, select exact suffixes and verify pin map, ratings, lifecycle, compliance, stock, alternates and pricing |
| CSR-01A-F08: Native ERC remains pending | Major | Run native KiCad ERC after exact manufacturer symbols are introduced and disposition every result |

## Validation

- Schematic inventory: 301 rows retained.
- CSR-01A power scope: 124 rows.
- Outside scope: 177 rows marked `NOT YET FROZEN`.
- Frozen power MPNs: 0.
- Reference uniqueness and Sheet 01–09 ranges: checked by repository validation.
- Hierarchy, GPIO and frozen interfaces: unchanged.
- Footprints and PCB: unchanged; zero-footprint scope retained.
- Native KiCad ERC: pending; repository structural checks are not a substitute for ERC.

## Authorization

CSR-01B is not authorized. Power-component selection must be reissued after the findings above are closed with calculations and exact-order-code evidence.

# CSR-01A NOT ACCEPTED
