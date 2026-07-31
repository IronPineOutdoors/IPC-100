# PPQ-02 Appendix — Power Threshold and Timing Model

| Function | Required window / method | Selection evidence |
|---|---|---|
| Main brownout | authorization removed by 8.5 V falling; restart ≥9.0 V; hysteresis ≥0.5 V | divider/device tolerance, leakage/tempco; 0.1/1/10 V/s ramps |
| Main/core power good | assert only after valid ≥5 ms; deassert ≤1 ms invalid | threshold/timing extremes and ramp-rate behavior |
| U801 expansion qualification | nominal 2.930 V rising / 2.680 V falling; 10 ms validation | exact threshold-code tolerance, R806/R808 tolerance/tempco, SENSE leakage, output type, delay tolerance |
| Core reset release | only after core in guaranteed range and stable | supervisor tolerance, reset delay, processor minimum reset pulse |
| Branch enables | default off in reset/bootloader/USB-only/invalid main | VIH/VIL, bias, Ioff, partial-power and ramp test |
| Watchdog supply assumption | independent watchdog invalid until its supply and timing are valid | watchdog UV behavior and reset/start sequence |
| TPS2553 branch | 141 kΩ; 162.82–222.35 mA; rise 0.2–10 ms | exact suffix equations plus ≥3-article waveform test |

Worst cases sum threshold/device tolerance, resistor endpoint and temperature drift, worst-direction leakage voltage, capacitor tolerance/aging and timing tolerance. RSS is not permitted for safety boundaries. PAS-01 shall tabulate rising/falling/delay extremes for each exact candidate and prove the fail state at every ramp.
