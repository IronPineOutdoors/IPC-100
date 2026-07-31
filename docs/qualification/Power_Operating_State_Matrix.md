# PPQ-02 Appendix — Power Operating State Matrix

| State | Source / rail currents | Qualification / sequencing | Dissipation and safe state | Confidence |
|---|---|---|---|---|
| No power | 0 | Rails discharge <0.3 V/100 ms | Outputs deauthorized | HIGH |
| Battery startup | 9–21 V; ≤4 A/10 ms connection | Branches off; 5 V ≤50 ms, core ≤20 ms | No authorization pulse | MEDIUM |
| Normal battery | Typical 470 mA equivalent 5 V | Main/core valid; requested branches only | Modeled conversion loss depends on load | MEDIUM |
| 9 V maximum continuous | 0.980 A input at 7.5 W/85% | 1.25 A board limit retained | U201 loss ≤1.324 W model | HIGH/MEDIUM |
| 21 V maximum continuous | 0.420 A input at 7.5 W/85% | duty 0.238 at 5 V | switching stress controls | HIGH/MEDIUM |
| +40 V/100 ms transient | parametric protection current | Safe shutdown permitted | PPC-01 energy/SOA envelope | MEDIUM |
| USB-only | ≤0.50 A USB; ≤550 mA 3.3 V screen | Main-only branches off | no host backfeed >10 µA | MEDIUM |
| Dual source transition | load-dependent; 5 µs-class candidate not credited | core ≥3.0 V; no cross-current | selector loss/transition test | LOW |
| Brownout falling | authorization removed by 8.5 V | PG deassert ≤1 ms | branches off | HIGH requirement |
| Recovery | restart ≥9.0 V after ≥0.5 V hysteresis | no branch surge coincidence credited | default-off | MEDIUM |
| Processor reset/watchdog | core only plus base loads | requested branches/outputs off | hardware inhibit independent | HIGH |
| All optional off | base logic only | valid service baseline | lowest main load | MEDIUM |
| Maximum simultaneous | 1.00 A 3.3 V; 1.246 A equivalent 5 V | within 1.50 A main | 254 mA main margin | HIGH |
| Relay active | +100 mA continuous, 150 mA/20 ms | hardware authorization required | coil/driver thermal PAS-01 | MEDIUM |
| Expansion active | 100 mA, 150 mA/10 ms | optional/DNP; main valid | limiter 162.82–222.35 mA | HIGH |
| UI/sensors active | allocations per QER-01 | permitted only with valid rail/request | shared budget enforced | HIGH |
| Faulted/short branch | ≤branch ceiling/retry | must not collapse core or authorize | retry ≥100 ms or latch | MEDIUM |
| Reverse polarity | −24 V/60 s, 2 A source limit | no rail assertion | leakage ≤1 mA | HIGH requirement |

For each hardware test record source impedance, voltage/current on every rail, power-good, branch enables, authorization, temperatures and recovery. Pass/fail is the corresponding QER limit; ≥3 articles are required for low-confidence transitions.
