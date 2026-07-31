# PPQ-01 Appendix — Power Load Model

## State model

| State | 3.3 V load | Direct 5 V load | 5 V including core at 85% | Main input current at 9/18/21 V | Confidence |
|---|---:|---:|---:|---:|---|
| Idle | 50 mA | 6 mA | 44.8 mA | 29/15/13 mA | Medium; measurement pending |
| Typical, relay active | 277 mA | 255 mA | 470 mA | 307/154/132 mA | Medium |
| Simultaneous continuous | 1.00 A | 470 mA | 1.246 A | 814/407/349 mA from branch sum | High envelope |
| Conservative rail allocation | included in 7.5 W | included | 1.50 A allocation | 980/490/420 mA | High requirement |

Equations: `Icore_in=3.3·Icore/(5·ηcore)` and `Iboard=5·I5/(VIN·ηmain)`. At η=85%, the continuous branch sum leaves 254 mA on +5V_MAIN. J10 is DNP or another nonessential branch is limited whenever individual 3.3 V maxima exceed 1.00 A.

## Startup and peak model

| Node/event | Limit | Qualification acquisition |
|---|---:|---|
| Board connection | 4 A/10 ms | ≥1 MS/s current probe, 21 V/0.10 Ω source, bounce fixture |
| Board peak | 2 A/100 ms | pulse load and source logging |
| +5V_MAIN | 2 A/100 ms | electronic load pulse, rail droop/ripple |
| +3V3_CORE | 1.5 A/100 ms | radio/load pulse, rail droop |
| Relay | 150 mA/20 ms | cold/hot coil pull-in |
| Motor logic/expansion | 150 mA/10 ms each | branch load-step and limiter response |

## USB-only and dual-source model

At 4.40 V/0.50 A, available USB input power is 2.20 W. At 85% core efficiency, output power is 1.87 W or 567 mA at 3.3 V. Reserve for selector/regulator quiescent and tolerance sets a **550 mA maximum USB-only core load screening limit**. OLED, sensor, UI, relay, motor-logic and expansion branches remain off unless their controlling contract explicitly permits otherwise; Rev A requires them off.

Dual-source validation uses main-preferred selection, ≤10 µA host backfeed, no source cross-current, and `+3V3_CORE≥3.0 V`. The captured 47 µF is not hold-up evidence; selector overlap/transition must carry the load.

## Measurement record template

Record article/firmware, source voltage/impedance, ambient/internal air, rail, state, idle/mean/peak current, peak duration, ripple bandwidth, startup time, overshoot, pass/fail, instrument ID/calibration and raw waveform path. Until populated, planning values remain estimates while maximum values remain binding requirements.
