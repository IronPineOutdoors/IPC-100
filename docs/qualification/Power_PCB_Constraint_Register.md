# PPQ-02 Appendix — Power PCB Constraint Register

These are selection/layout inputs, not layout or footprint assignments.

| Area | Quantitative constraint |
|---|---|
| Stack/copper | Four layers; ≥1 oz finished outer copper baseline; thinner copper requires recalculation |
| J1/input | size by released current calculator for 2 A continuous capability and ≤20 °C rise; minimize J1–protection–return loop |
| U201 | demonstrate effective θJA ≤26.4 °C/W; manufacturer exposed-pad land and ≥6 thermal vias of 0.20–0.30 mm finished drill unless more are required |
| Core regulator | demonstrate effective θJA ≤60.1 °C/W; no forced airflow credit |
| TPS2553 | keep TJ ≤110 °C at 1.112 W initial short; RILIM adjacent with quiet-ground return |
| Decoupling | first high-frequency capacitors same layer and manufacturer-minimum distance; minimize power loop |
| Feedback/sense | Kelvin route; exclude from switch-node/inductor field; quiet-ground return |
| TVS | connector-side shortest surge loop; pulse return shall not share logic return |
| Magnetics/hot parts | compact switching node; ≥5 mm initial clearance from high-impedance supervisor/RF/temperature-sensitive parts |
| Branch outputs | size for ≥1.5× protection ceiling; expansion basis ≥338 mA; PCB drop ≤1% rail |

Final trace widths depend on copper thickness, length and allowed rise. PAS-01/PPC-01 replace conditional via/copper values with exact manufacturer-package constraints.
