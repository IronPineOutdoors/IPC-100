# PPQ-02 Appendix — Power MOSFET and Switch Stress Model

| Element | Voltage / current requirement | Loss / thermal requirement | Fault and reverse requirement |
|---|---|---|---|
| Q101 reverse FET | VDS ≥80 V class; VGS clamp below gate abs max; 1.25 A continuous, 2 A/100 ms, 4 A/10 ms connection | hot total RDS(on) ≤80 mΩ for ≤100 mV drop; ≤0.125 W at 1.25 A for 80 mΩ; TJ target ≤110 °C | −24 V/60 s, leakage ≤1 mA; SOA ≥2× pulse-current/time or energy margin; avalanche not credited without proof |
| Q102 / entry control MOSFET | voltage ≥coordinated clamp with derating; current as input path | conduction plus transition loss at hot gate drive; package/copper model | eFuse/OV startup, surge and short SOA; body-diode path documented |
| TPS2553 U209/U212/U213 | 2.5–6.5 V family range; 100 mA continuous; 150 mA/10 ms; 222.35 mA max limit | use max RON at actual VIN/T; hard-short initial power ≤0.734 W (3.3 V) or 1.112 W (5 V); TJ target ≤110 °C | reverse comparator/leakage, active-low fault, thermal retry ≥100 ms or controlled recovery |
| Other integrated load switches | rail max plus transient; QER branch continuous/peak | voltage drop ≤rail tolerance; junction calculation at max RON | default off, Ioff/backfeed, short containment and retry |
| Relay/output MOSFETs in power scope | rail/clamp plus 20% voltage margin; coil/load current with tolerance | RDS(on) at actual gate; conduction and switching/flyback energy | SOA and repetitive clamp; body diode and stuck-on effect |

Switching loss is `0.5·V·I·(tr+tf)·f` where periodic switching exists; event-only stages use integrated pulse energy. PPC-01 selects protection FETs; PAS-01 selects regulated/branch devices. Exact SOA graphs, transient thermal impedance, package copper and leakage curves are mandatory.
