# PPQ-02 Appendix — Power Protection Energy Model

## Controlled source envelopes

- Normal: 9–21 V, 1.25 A board current at 9 V.
- Connection: 4 A maximum for 10 ms; charge impulse 40 mC; `I²t=0.16 A²s`.
- Surge: +40 V open circuit, 100 ms, 2 Ω, five events with cool-down.
- Reverse: −24 V/60 s, source limited to 2 A.
- Short coordination: 10 A fault cleared within 5 s, subject to conductor thermal proof.

## TVS/eFuse parametric envelope

For a 40 V Thevenin source and 2 Ω, `ITVS=max(0,(40−VC)/2)` and rectangular upper-bound energy `E=VC·ITVS·0.1`. Examples: at 33 V, 3.5 A and 11.55 J; at 36 V, 2.0 A and 7.2 J; at 40 V or above, no conduction can be credited. PPC-01 shall use tolerance, dynamic resistance and waveform integration, keep downstream voltage ≤55 V, and provide ≥2× energy margin.

The fuse shall carry 1.25 A at 75 °C, survive 0.16 A²s connection inrush, and clear the 10 A case before trace/harness damage and no later than 5 s. `10²·5=500 A²s` is only the source-envelope upper bound, not an acceptable fuse let-through; PPC-01 must coordinate the exact curve with conductor fusing energy.

Input capacitors see the coordinated clamp, not merely 21 V. Reverse MOSFET/eFuse SOA is evaluated at actual VDS, current and time with ≥2× margin. Repeated pulses use manufacturer derating and five-event thermal recovery. A persistent downstream short must not defeat authorization or collapse core; branch retry is ≥100 ms or latch-controlled.

PPC-01 output: exact fuse, TVS, eFuse/surge control, reverse MOSFET and protection-passive candidates with clamp, energy, I²t, SOA, temperature, lifecycle, source, alternate and price evidence.
