# PPQ-02 Appendix — Power Regulator Corner Analysis

## U201 main converter envelope

| Parameter | Selection requirement / calculation |
|---|---|
| Input | 9–21 V continuous; coordinate 40 V/100 ms; downstream class ≥80 V where QER requires |
| Output | 5.0 V, 4.75–5.25 V; 1.50 A continuous; 2.00 A/100 ms |
| Frequency | 400 kHz from ECO-007 |
| Duty / timing | ideal D=0.556 at 9 V, 0.238 at 21 V; ton=1.389/0.595 µs and toff=1.111/1.905 µs. Candidate min on/off shall be ≤80% of the smallest applicable interval |
| Input current | 0.980/0.490/0.420 A at 9/18/21 V for 7.5 W and 85% |
| Efficiency | ≥85% at 25–100%; ≥75% at 10% |
| Loss / thermal | ≤1.324 W model; effective θJA ≤26.4 °C/W to TJ target 110 °C at 75 °C air |
| Ripple | ≤50 mVpp at 20 MHz; inductor ripple screen 0.635 A at high line |
| Startup | monotonic ≤50 ms, <5% overshoot |
| Current limit | guarantee 2 A/100 ms rail peak without violating device/inductor/thermal limits |

## Core converter envelope

Input is 4.40–5.25 V; output 3.20–3.40 V, 1.00 A continuous and 1.50 A/100 ms. At 3.3 W/85%, input is 0.882 A at 4.40 V and modeled loss 0.582 W. Effective θJA shall be ≤60.1 °C/W. Ripple is ≤40 mVpp. Startup is monotonic ≤20 ms with <5% overshoot. Exact frequency/minimum timing/stability are PAS-01 candidate checks.

## Source selector and branch stages

The selector must carry ≥1 A core input at 4.4 V, limit USB to 500 mA, prevent >10 µA host backfeed, and maintain core ≥3.0 V during a valid-source transition. TPS2553 branches use 141 kΩ and 162.82/190.33/222.35 mA minimum/nominal/maximum. Other branch switches must pass their QER continuous/peak loads with ≥10% operating margin and contain faults without core collapse.

Vendor-tool loop, exact efficiency, dropout, current-limit, soft-start, brownout and package/copper results remain PAS-01; prototype load-step/ramp correlation is LOW until measured.
