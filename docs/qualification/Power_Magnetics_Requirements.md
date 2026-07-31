# PPQ-02 Appendix — Power Magnetics Requirements

| Function | L / tolerance | Ripple / peak / RMS | Saturation and loss envelope | Status |
|---|---|---|---|---|
| U201 main inductor | Candidate value shall produce 20–40% of 1.5 A rated-load ripple at 400 kHz; preliminary 0.635 A high-line screen | Ipk ≥2.0 A load + ΔI/2; Irms ≥sqrt(Iout²+ΔI²/12) | Isat ≥1.25× calculated peak at hot; hot DCR loss ≤0.15 W target; temperature rise ≤20 °C | READY PAS-01 after candidate loop check |
| U201 input/filter magnetic | impedance/inductance set by conducted-noise and stability study | ≥1.25 A continuous, 2 A/100 ms | no saturation during 4 A/10 ms connection unless upstream-limited; hot DCR drop ≤1% rail | READY PAS-01/PPC-01 coordination |
| Core regulator inductor | candidate datasheet/vendor-tool value, ±20% maximum | Ipk ≥1.5 A + ΔI/2; Irms equation above | Isat ≥1.25× peak hot; DCR loss included in 0.582 W stage model; rise ≤20 °C | READY PAS-01 |
| FB801 expansion ferrite | impedance specified at 100 MHz under DC bias | ≥1.5× 225 mA ceiling = 338 mA | DCR drop ≤1% of 3.3 V; no saturation/damage at branch ceiling/retry | READY PAS-01 |

Core loss shall be evaluated from the candidate manufacturer's frequency, flux-swing and temperature model, not an ungapped generic estimate. PAS-01 records exact DCR at hot, core/copper loss, tolerance, lifecycle, sources, alternate and price. Prototype verification uses current probe plus thermocouple/IR correlation at low/high line and maximum load.
