# PEB-01 Appendix — Power Load Budget

All non-maximum values are **Engineering Estimates** from QER-01 and require QER-V01 prototype measurement.

| Load | Rail | Idle | Typical | Maximum / peak | QER trace |
|---|---|---:|---:|---:|---|
| ESP32/radio | +3V3_CORE | 35 mA | 120 mA | 700 mA/500 ms | §4 |
| Core logic | +3V3_CORE | 15 mA | 30 mA | 50 mA continuous | §4 |
| OLED | OLED_VCC | 0 | 50 mA | 150 mA | §4 |
| Sensor | SENSOR_VCC | 0 | 2 mA | 50 mA; 75 mA/10 ms | §§3–4 |
| Expansion | EXPANSION_VCC | 0 | 75 mA | 100 mA; 150 mA/10 ms | §§3–4 |
| Relay | RELAY_VCC | 0 | 80 mA active | 100 mA; 150 mA/20 ms | §§3–4 |
| Motor logic A/B | 5 V branches | 0 | 50 mA each | 100 mA each; 150 mA/10 ms | §§3–4 |
| Field sensing | FIELD_SENSE_VCC | 6 mA | 15 mA | 50 mA; 75 mA/10 ms | §§3–4 |
| UI | UI_VCC | 0 | 60 mA | 120 mA; 180 mA/10 ms | §§3–4 |

Calculated aggregate states:

| State | 3.3 V total | Direct 5 V | +5V_MAIN including 85%-efficient core | Input at 9 V/85% main |
|---|---:|---:|---:|---:|
| Idle | 50 mA | 6 mA | 44.8 mA | 29.3 mA |
| Typical with relay active | 277 mA | 255 mA | 470 mA | 307 mA |
| Released simultaneous continuous | 1.00 A | 470 mA | 1.246 A | 814 mA calculated from branch total; 980 mA conservative 7.5 W allocation |

Startup/surge limits are 4 A/10 ms input inrush, 2 A/100 ms input peak, 2 A/100 ms +5 V peak, and 1.5 A/100 ms +3.3 V peak. Firmware load shedding may enforce the 1.00 A 3.3 V simultaneous limit but is not credited for safety.

Measurement plan: instrument every rail at 9/18/21 V, −20/25/60°C ambient; log idle, radio burst, branch startup, relay pull-in, simultaneous maximum, duration, and source-transition waveforms at ≥1 MS/s. Pass if measured maxima remain within allocation without increasing any limit.
