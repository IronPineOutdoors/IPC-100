# PPQ-01/PPQ-02 Appendix — Power Thermal Model

PPQ-02 makes this model the controlling package-independent thermal envelope for PPC-01/PAS-01. U201 requires effective θJA ≤26.4 °C/W at 1.324 W; the core regulator ≤60.1 °C/W at 0.582 W. TPS2553 short onset is screened at 0.734 W on 3.3 V and 1.112 W on 5 V. Exact candidates must provide transient thermal impedance, manufacturer land/copper/via rules, neighboring-source superposition and ≥15 °C junction margin to rated maximum. Prototype correlation uses ≥3 closed-enclosure articles at 9/21 V and maximum load after stabilization.

Boundary conditions are +60°C external ambient, ≤+75°C internal air, natural convection, no credited airflow, local board rise ≤35°C, calculated critical junction ≤110°C, and measured target ≤100°C.

| Device/function | Maximum analytical loss | θJA screening ceiling | Copper/layout constraint | Remaining evidence |
|---|---:|---:|---|---|
| U201 main converter | 1.324 W | 26.4°C/W | Four layers; exposed-pad copper and manufacturer thermal-via pattern | exact suffix loss model and physical correlation |
| Core regulator | 0.582 W | 60.1°C/W | continuous ground/copper path; no forced air | exact part θ/loss and correlation |
| Q101 reverse FET | 39 mW at 1.25 A; 100 mW at 2 A using 25 mΩ | SOA dominates | gate clamp and heat path compatible with pulse | hot RDS/SOA curve |
| L201 | 228 mW at 1.511 A and 100 mΩ screening DCR | ≤30°C component rise | spacing/copper do not trap heat | exact hot DCR/core loss |
| TPS2553 5 V short | up to ~1.05 W before thermal limiting | transient | manufacturer recommended copper | exact retry/transient thermal |
| TPS2553 3.3 V short | up to ~0.69 W | transient | same | same |

`TJ=TA+PLOSS·θJA` is used only with a θ value whose board definition matches the eventual design. The selected part must remain compliant without unreasonable copper or airflow. A candidate failing the screening ceiling is not eligible for freeze.

Physical qualification: closed representative enclosure; 9 and 21 V; 25/50/100% load; +60°C chamber; stabilized temperatures; calibrated thermocouples and emissivity-corrected IR; record internal air, board hot spots and junction-correlated parameter. Pass at ≤100°C measured junction target and ≤15°C enclosure-air rise.
