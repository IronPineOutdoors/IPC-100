# PAS-01 — Passive Component Selection and Electrical Class Freeze

Date: 2026-07-31  
Platform: IPC-100 Rev A  
Package: 11A-P

## Decision

# PAS-01 INCOMPLETE

PAS-01 audited every blocked true passive in the power scope. The controlling population is **85**, not approximately 104. The prior PPQ-02 route combined passive and active-stage work: after correction, 85 rows route to PAS-01, 20 active devices route to PACS-01, 18 protection parts route to PPC-01, and J1 routes to JCS-01. The generated register accounts for all 85 passive rows exactly once.

Sixty-seven references have an exact preferred MPN and are **FREEZE ELIGIBLE**. Eighteen remain **BLOCKED** because the evidence requested by the package cannot be honestly closed from generic class requirements. No row is promoted to canonical `FROZEN` until approved alternates and order-quantity pricing are captured and the 18 dependent networks are resolved.

## Inputs and scope

The review used PPQ-02, QER-01, QER-02, PEB-01, ECO-006, ECO-007 and ECO-008R. It covers resistors, capacitors, inductors, ferrite FB801, timing and programming networks in the blocked power inventory. No crystal is present in this scope. Active devices, protection semiconductors, J1, schematics, architecture, ICDs, GPIO, hierarchy, footprints and PCB data are excluded.

## Preferred families

| Class | Preferred family | Qualification basis | Package recommendation |
|---|---|---|---|
| General resistors | Panasonic ERJ-3EK / ERJ-6EN | ±1%, ±100 ppm/°C, AEC-Q200 family; working-voltage and power screens recorded per row | 0603 normally; 0805 for high-value divider parts |
| Precision resistors | Vishay TNPW e3 | ±0.1%, ±25 ppm/K, automotive-grade thin film, -55 to +175 °C family | 0603 where resistance range permits |
| Low-stress MLCCs | Murata GRM X7R/C0G | Exact voltage, dielectric and temperature class; DC bias is small in the released low-voltage use | 0603, 0805 or 1206 by capacitance |
| Expansion ferrite | Murata BLM21PG221SN1D | 220 Ω at 100 MHz, 2 A, 45 mΩ maximum, -55 to +125 °C | 0805 |

These are electrical/package recommendations only. They do not assign KiCad footprints.

## Derating and validation

The resistor selections meet the released tolerance/tempco class and retain wide power and working-voltage margin. Low-stress decoupling, local branch and slew capacitors use X7R or C0G parts with rated voltage above their applied rail. FB801 supports almost six times the 338 mA selection screen; its 45 mΩ maximum DCR causes about 10.1 mV drop at the 225 mA branch ceiling, or 0.31% of 3.3 V.

The 47 µF Murata family was reviewed as a sourcing/price benchmark only and was not released for C206: manufacturer nominal data alone does not prove the required 30 µF effective value at 5.25 V. That distinction is applied consistently to all stability-, bias-, ripple- or timing-critical rows.

## Commercial evidence

Manufacturer product data supports the selected electrical families. Distributor snapshots confirm active listings and ordinary availability for representative parts. Examples checked on 2026-07-31 include Vishay TNPW060349K9BEEN at Mouser, Murata GRM32ER71A476KE15L at DigiKey, and Murata BLM21PG221SN1D through authorized distribution. Stock and price are volatile procurement data; PAS-01 therefore records the basis but does not invent missing 1/10/100/1000 quantity prices or call an unverified alternate approved.

Primary references:

- Panasonic ERJ-3EK family/product data: https://industrial.panasonic.com/ww/products/pt/general-purpose-chip-resistors/models/ERJ3EKF2000V
- Vishay TNPW e3 datasheet: https://www.vishay.com/docs/28758/tnpw_e3.pdf
- Murata GRM32ER71A476KE15L product data: https://www.murata.com/en-eu/products/productdetail?partno=GRM32ER71A476KE15L
- Murata BLM21PG221SN1D product data: https://www.murata.com/en-us/products/productdetail?partno=BLM21PG221SN1D

## Blocked references

| Group | References | Smallest remaining evidence |
|---|---|---|
| High-voltage/effective-capacitance input network | C102, C103, C104, C109, C201 | Manufacturer DC-bias, ESR/ripple and temperature curves at the released operating point |
| Regulator stability and timing | C202, C203, C204, C205, C208, C209, C210 | Exact active suffix plus vendor stability/timing tool report |
| Transition reservoir | C206 | Effective capacitance at 5.25 V including tolerance and aging |
| Magnetics | L101, L201, L202 | Exact active/protection topology, hot DCR, saturation, loss and temperature-rise model |
| Supervisor timing | C305 | Exact supervisor suffix and timing equation/tolerance |
| High-value precision feedback | R808 | Qualified ≥4.47 MΩ, ±0.1%, ≤25 ppm/°C exact order code with voltage/leakage validation |

The smallest follow-on package is **PAS-01R — Dependent Passive Curve and Tool Closure**, limited to these 18 references plus commercial alternate/price completion for the 67 candidates.

## Controlled outputs

- `docs/bom/PAS-01_Passive_Selection_Register.csv` — 85-row selection/evidence register.
- `scripts/generate_pas01_register.ps1` — deterministic register generator.
- Corrected PPQ-02 class routing — 18 PPC / 85 PAS / 20 PACS / 1 JCS.

## Configuration control

No schematic, footprint, PCB, architecture, GPIO, hierarchy, connector contract, ADR or ICD was changed. Exact candidates in this package are not permission to assign footprints or begin layout.
