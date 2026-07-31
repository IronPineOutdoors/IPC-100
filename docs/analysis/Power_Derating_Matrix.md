# PEB-01 Appendix — Power Derating Matrix

This matrix defines candidate acceptance envelopes; it does not approve MPNs.

| Class / affected references | Applied stress | Minimum candidate capability | Margin rule | Evidence remaining |
|---|---|---|---|---|
| Raw-input semiconductors | 21 V steady; ≤55 V coordinated transient | abs max ≥68.75 V for 80% steady-policy interpretation; pulse rating above actual clamp | ≤80% steady, ≤90% specified transient | exact abs max/SOA/leakage/temp curves |
| Q101 | 1.25 A cont, 2 A peak, −24 V reverse case | ≥80 V class; hot RDS≤80 mΩ; ±20 V VGS | ≥2× SOA pulse margin | exact curves and thermal model |
| U201 | 9–21 V, 5 V/1.5 A cont, 2 A peak | 80 V/2 A family; 400 kHz | TJ≤110°C; θ envelope≤26.4°C/W | exact suffix/tool/loop/thermal |
| Main inductor | 1.818 A peak, 1.511 A RMS | Isat hot≥2.273 A; Irms≥1.813 A | peak≤80% Isat; RMS 1.2× | DCR/core-loss/rise curves |
| Main input capacitors | 21 V steady, clamp exposure; 0.639 A ideal RMS | ceramic ≥2× steady and above clamp; ripple ≥0.959 A network | ceramic ≤50% DC; ripple≤67% | DC-bias/ripple/ESR curves |
| Main output capacitors | 5.25 V; ≥30 µF effective total | ≥16 V X7R; ESR≤68 mΩ combined screen | ≥70% required C; ≤50% voltage | exact bias/aging/stability |
| Core regulator | 4.4–5.25 V in, 3.3 V/1 A | current ≥1.43 A thermally derated screen | current≤70%; θ≤60.1°C/W | exact suffix/dropout/thermal |
| TPS2553 branches | 3.3/5 V, 100 mA cont, 150 mA/10 ms | 154–209 mA programmed envelope | protection coordinated to branch/conductor | exact suffix/retry/reverse/thermal |
| Low-voltage ceramics | rail maximum | rating≥2× steady; effective C≥70% minimum | ripple rise≤10°C | exact curves |
| Precision/program resistors | calculated node voltage/pulse | ±1% or tighter; ≤100 ppm/°C | voltage≤70%; power≤50%; pulse≥2× | exact function stack |
| Frozen 100 kΩ resistors | 5.25 V, 0.276 mW | 75 V, 100 mW | 7.0% V, 0.28% P | already frozen |
| J1 | 1.25 A cont, 2 A peak, 9–21 V | ≥30 V, ≥3 A/contact at75°C | current≤67%; rise≤20°C | JCS-01 order codes/test |

MTBF remains uncalculated until exact BOM freeze. Reliability closure requires BOM-based prediction ≥50,000 h at 40°C and prototype thermal/environmental correlation; neither is represented as analytical fact here.
