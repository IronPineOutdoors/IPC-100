# ECO-008R — TPS2553 Current-Limit Implementation

## Background

ECO-008 proved the original 150 mA peak / 150 mA ceiling requirement infeasible. QER-02, accepted at commit `edd2244`, preserved the 100 mA continuous and 150 mA/10 ms startup contracts while defining a 160–225 mA worst-case fault-threshold band. ECO-008R implements that requirement on Sheet 02 only.

## QER-02 Reconciliation

Affected channels are U209/R222 (`EXPANSION_VCC`), U212/R223 (`MOTOR_LOGIC_5V_A`), and U213/R224 (`MOTOR_LOGIC_5V_B`). Each keeps its topology, enable, source rail, output, hierarchy, connector contract, and population state. Only the three independent RILIM generic values and associated switch annotations change.

The selected generic value is **141 kΩ ±1%, ≤100 ppm/°C**, an E96 standard value. It lies inside QER-02's 138.604–144.167 kΩ feasibility interval before the separately conservative temperature-drift screen. No manufacturer part number or footprint is selected.

## Per-Channel Calculations

The TPS2553-Q1 datasheet equations use resistance in kΩ and current in mA:

- `I_LIMIT_MAX = 22980 / R^0.94`
- `I_LIMIT_NOM = 23950 / R^0.977`
- `I_LIMIT_MIN = 25230 / R^1.016`

The resistor is specified at 25 °C. The Rev A operating range is −20 to +75 °C. Conservatively applying initial tolerance and full signed tempco gives:

- low resistance at −20 °C: `141 × 0.99 × (1 − 45×100 ppm) = 138.961845 kΩ`;
- nominal resistance: `141.000000 kΩ`;
- high resistance at +75 °C: `141 × 1.01 × (1 + 50×100 ppm) = 143.122050 kΩ`.

| Channel | RILIM | R low / nominal / high | I minimum | I nominal | I maximum | ≥160 mA | ≤225 mA |
|---|---:|---:|---:|---:|---:|---|---|
| U209/R222 | 141 kΩ | 138.962 / 141.000 / 143.122 kΩ | 162.82 mA | 190.33 mA | 222.35 mA | PASS, +2.82 mA | PASS, 2.65 mA margin |
| U212/R223 | 141 kΩ | Same | 162.82 mA | 190.33 mA | 222.35 mA | PASS | PASS |
| U213/R224 | 141 kΩ | Same | 162.82 mA | 190.33 mA | 222.35 mA | PASS | PASS |

The manufacturer minimum/nominal/maximum equations carry device manufacturing and characterized temperature variation. The additional resistor calculation includes ±1% initial tolerance and worst-direction 100 ppm/°C drift. This is not a nominal-only proof.

## Startup and Fault Behavior

Worst-case minimum limit is 162.82 mA, 12.82 mA (8.5%) above the 150 mA startup allocation and 2.82 mA above QER-02's required 160 mA minimum threshold. A 150 mA/10 ms load therefore remains below the calculated limiting threshold at the screened corners.

At a simultaneous 100 mA load, at least 62.82 mA remains for capacitance. Ideal charging time is about 0.247 ms for 4.7 µF at 3.3 V, 0.374 ms for 4.7 µF at 5 V, and 1.16 ms for a 22 µF 3.3 V expansion load. These remain inside the 0.2–10 ms rise envelope but require prototype confirmation.

Worst-case maximum is 222.35 mA, 2.65 mA below the 225 mA safety ceiling. Initial hard-short power is bounded approximately by 0.734 W at 3.3 V and 1.112 W at 5 V before thermal limiting/retry. Exact suffix, PCB copper, enclosure temperature, and retry duty remain release evidence.

## Schematic and Controlled-Data Changes

- R222, R223, and R224: 150 kΩ annotations replaced by 141 kΩ ±1%, ≤100 ppm/°C.
- U209, U212, and U213: annotations synchronized to 141 kΩ and 162.8–222.4 mA.
- Canonical EBOM and AVL generic descriptions/risks regenerated from the schematic; all six rows remain `BLOCKED` and contain no MPN.
- No net, symbol, UUID, reference, hierarchy, GPIO, connector, ADR, ICD, footprint, or PCB change.

## Validation

- Three independent ILIM nets and exactly six affected references verified.
- Independent script reproduces resistor and current extrema and checks both QER-02 limits.
- EBOM/AVL CSV and XLSX artifacts are synchronized; affected rows remain unfrozen.
- Hierarchy, GPIO, connector, reference, UUID, zero-footprint, and prior-package regressions pass.
- `git diff --check` passes.

### Native ERC Status

`kicad-cli` is unavailable in the implementation environment. Native KiCad ERC remains **PENDING**. Repository structural validation confirms hierarchy, syntax, identity, and zero-footprint invariants but is not represented as ERC.

## Remaining Risks

- Exact TPS2553-Q1 suffix/package and RILIM MPN remain for CSR-01A-R4.
- Prototype peak, rise, droop, short, thermal, retry, reverse-current, and brownout tests remain required by QER-02.
- The 2.65 mA upper margin is valid for the stated equations and resistor envelope; an exact-part datasheet revision with wider limits requires requalification.

## Final Decision

# ECO-008R COMPLETE — CSR-01A-R4 AUTHORIZED

CSR-01A-R4 may begin as a separate package. Footprints and PCB work remain unauthorized.
