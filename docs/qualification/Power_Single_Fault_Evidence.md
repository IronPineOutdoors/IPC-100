# PPQ-02 Appendix — Power Single-Fault Evidence

| Fault | Effect | Detection / containment | Required evidence |
|---|---|---|---|
| Capacitor open | ripple/start degradation | PG/reset or functional loss | load-step/start at minimum C |
| Capacitor short | rail short | fuse/eFuse/branch limit | short energy; no propagation |
| Divider open/short | threshold shifts | fail-state supervision | injected fault never authorizes unsafe output |
| MOSFET gate open | off/uncontrolled | bias and PG | documented safe bias |
| MOSFET D-S short | protection bypass | downstream OV/PG | second boundary and surge test |
| Supervisor stuck | false valid/invalid | independent authorization | no single stuck-valid actuation |
| Load switch stuck on/off | unintended power/loss | upstream qualification/diagnostic | backfeed and load-contract test |
| TVS short/open | input short/no clamp | fuse or eFuse/OV | clearing or +40 V survival |
| Fuse open | no main power | PG invalid | safe shutdown |
| Regulator high/low | overstress/reset | OV/PG/inhibit | abs-max/timing coordination |
| Selector stuck | source loss/cross-power | reverse block/source limits | all connection orders; ≤10 µA USB backfeed |
| Branch short | local limiting/retry | fault output; core valid | QER ceiling, retry ≥100 ms/latch, thermal test |

Residual risks are exact-part common-cause behavior, PCB current paths and unmeasured timing. Test ≥3 articles at voltage/temperature corners and capture rail current/voltage, PG, authorization and temperature. This is a design-FMEA input, not a formal functional-safety claim.
