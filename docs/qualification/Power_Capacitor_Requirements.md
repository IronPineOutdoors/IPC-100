# PPQ-02 Appendix — Power Capacitor Requirements

| Function / affected groups | Nominal and minimum effective requirement | Voltage / technology | ESR, ripple, aging, inrush and stability |
|---|---|---|---|
| Protected-input ceramics C101–C104/C109 | captured nominal network; exact minimum set by PPC/U201 transient model | rating class per ECO-006; ceramic steady utilization ≤50%; pulse below rating | network ripple ≥0.959 A hot where carrying converter ripple; DC-bias curve mandatory |
| Main output C201/C203/C204 | ≥30 µF effective total at 5 V, hot and aged; maximum from candidate stability tool | ≥10 V X7R/X7S or qualified polymer combination | combined ESR ≤68 mΩ screen; ripple and loop pass required |
| Core input/output C206–C210 | vendor-tool minimum plus 20% effective margin; core output sized for ≤40 mVpp | ≥2× steady voltage for ceramics where practicable | exact bias/aging and load-step proof; captured 47 µF not credited for 2 ms/1 A hold-up |
| Branch local C211–C221 | 4.7 µF nominal; ≥2.2 µF effective unless candidate requires more | ≥2× rail preferred; X7R | branch rise 0.2–10 ms; include limiter and inrush calculation |
| ESP32/UI/expansion C305/C306/C702–C705/C802 | captured decoupling/bulk; ≥50% nominal effective screen | X7R/X7S, voltage rating per rail | local impedance and module startup test; no unqualified backfeed |
| Timing/soft-start capacitors | value from worst-case timing equation; ±10% or tighter | C0G where small/linear; X7R only with bias proof | tolerance, leakage, aging and ramp-rate stack must meet timing window |
| TVS/transient bulk | energy storage not credited as protection without pulse calculation | electrolytic/polymer/film as candidate demands | ripple life ≥5,000 h at 105 °C or demonstrated 10-year mission life |

Maximum useful capacitance is the smaller of regulator stability maximum and the amount that still meets QER inrush/startup. Exact manufacturer bias, ESR, ripple, aging and life curves are PAS-01 evidence. Capacitor short/open effects are controlled in the single-fault appendix.
