# PEB-01 Appendix — Power Protection Coordination

## Stress ladder

| Event | Source model | Required coordination | Evidence class |
|---|---|---|---|
| Connection | 21 V, ≥0.10 Ω, 1 m harness/bounce | ≤4 A for ≤10 ms; no unsafe pulse | QER requirement; Prototype Required |
| Positive surge | +40 V/100 ms, 2 Ω, five pulses | TVS/eFuse/MOSFET/U201 stress within derating; clamp ≤55 V | Calculated envelope + Prototype Required |
| Sustained OV | +30 V/60 s, 5 A-limited | reject or survive; recover after valid power | Prototype Required |
| Reverse | −24 V/60 s, 2 A-limited | no energization; leakage ≤1 mA | Calculated screen + Prototype Required |
| Short | each protected output, min/max input/temp | coordinated limit/retry; core and authorization safe | Manufacturer Datasheet + Prototype Required |
| Local inductive opening | worst coil/node current | clamp <80% semiconductor abs max | Calculated after exact clamp selection |

## Selection equations

- TVS current: `ITVS=max(0,(VSOURCE−VCLAMP)/RSOURCE)` using tolerance and dynamic resistance, not nominal standoff.
- TVS energy: integrate `∫VCLAMP·ITVS dt`; rated single-pulse energy must be ≥2× and repetition thermally allowed.
- Fuse: normal 1.25 A must be ≤70% hot carry capability; 4 A/10 ms must not open; 10 A must clear ≤5 s before trace/harness damage.
- Reverse MOSFET: hot `RDS(on)≤0.1/1.25=80 mΩ`; VDS utilization ≤80% steady and SOA ≥2× every connection/fault pulse.
- Input current limit: total tolerance 1.5–2.5 A; must not mask short protection during startup blanking.
- Branch current limit: maximum ≤150% continuous allocation; the TPS2553 150 kΩ network calculates approximately 154–209 mA and therefore suits the 150 mA peak but needs branch-specific QER reconciliation during exact selection.

The +40 V open-circuit source is below the 55 V maximum clamp, so a selected TVS may conduct little or no current in that test. The protection proof must therefore include the eFuse/OV stage's 40 V/100 ms capability rather than inventing TVS energy. Exact curves and source tolerances remain selection evidence.
