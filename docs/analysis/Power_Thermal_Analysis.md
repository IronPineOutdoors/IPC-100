# PEB-01 Appendix — Power Thermal Analysis

Boundary: +75°C enclosure air, natural convection, no credited airflow; critical calculated junction ≤110°C and local board rise ≤35°C (QER-01 §§2,10–11).

| Element | Operating point | Loss basis | Calculated loss | Maximum effective θJA / temperature condition | Confidence |
|---|---|---|---:|---|---|
| U201 main buck | 7.5 W out, 85% | `Pout(1/η−1)` | 1.324 W | ≤26.4°C/W to hold 110°C at 75°C air | Medium |
| Core regulator | 3.3 W out, 85% | same | 0.582 W | ≤60.1°C/W | Medium |
| Q101 | 1.25 A, 25 mΩ hot class | `I²R` | 39 mW | negligible versus SOA; exact curve required | Medium |
| Q101 peak | 2 A, 25 mΩ | `I²R` | 100 mW | pulse/SOA controls | Medium |
| L201 | 1.511 A RMS, 100 mΩ screening ceiling | `I²DCR` | 228 mW | ≤30°C component rise | Low/estimate |
| TPS2553 branch | hard short | `VIN·ILIM` upper bound | 0.69 W at 3.3 V; 1.05 W at 5 V | transient until thermal regulation/retry | Medium |

The selected U201 package/board must meet TI's exposed-pad copper/via guidance and the 26.4°C/W system envelope without unreasonable copper. Exact θ metrics cannot be summed as simple resistors; selection shall use the manufacturer's board definition and thermal model. Required prototype correlation uses thermocouples or calibrated IR at 9 V and 21 V, maximum continuous loads, +60°C ambient, closed representative enclosure, steady state, with junction inferred by a manufacturer-supported parameter where available.

No frozen footprint is implied. Failure to meet the envelope requires a part/package/layout constraint review and may require a narrow ECO if no compatible candidate exists.
