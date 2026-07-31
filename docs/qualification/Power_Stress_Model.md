# PPQ-01 Appendix — Power Stress Model

| Stress | Worst analytical corner | Result / screen | Confidence | Remaining work |
|---|---|---|---|---|
| Input continuous current | 9 V, 7.5 W, 85% | 0.980 A; 21.6% below 1.25 A | High | measure |
| Brownout hypothetical current | 8.5 V, same power | 1.038 A; shutdown required | High | threshold ramp |
| Main converter loss | 7.5 W, 85% | 1.324 W | High floor | exact curve |
| Core loss | 3.3 W, 85% | 0.582 W | High floor | exact curve |
| Main inductor ripple | 21→5 V, 400 kHz, 15 µH | 0.635 App | High | exact L/tolerance |
| Main inductor peak/RMS | 1.5 A output | 1.818 A / 1.511 A | High | hot curves |
| Main input-cap RMS | D=5/21, 1.5 A | 0.639 A; network rating ≥0.959 A | High | exact capacitor curves |
| Main output ripple | 30 µF effective | 6.6 mV capacitive; ESR screen ≤68 mΩ | High | loop/noise/ESR curves |
| Input stored energy | 46.4 µF nominal, 21 V | 10.2 mJ | Medium | actual effective C/waveform |
| Q101 conduction | 1.25 A/25 mΩ | 39 mW, 31 mV | Medium | hot RDS |
| Q101 voltage | 55 V clamp/80 V class | 68.8% | High class screen | exact transient/SOA |
| Core hold-up | 1 A, 2 ms, 3.3→3.0 V | 6.67 mF required; 47 µF inadequate | High | selector waveform |
| USB-only | 4.4 V/0.5 A/85% | 567 mA theoretical; 550 mA screen | Medium | exact efficiency/IQ |
| U801 thresholds | released nominal | 2.930 V rise, 2.680 V fall, 250 mV hysteresis | Medium | exact tolerance/leakage/VOH |
| TPS2553 current limit | 150 kΩ ±1% | 154–209 mA | Medium | exact suffix and QER reconciliation |

Worst-case operating corner is not a single point: low line controls current/dropout, high line controls ripple and switching/voltage stress, hot maximum controls junction, cold high line controls inrush, and minimum USB voltage controls USB-only output capability. Candidate evaluation shall test all controlling corners rather than applying one nominal case.
