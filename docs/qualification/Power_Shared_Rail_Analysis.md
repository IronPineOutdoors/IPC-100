# PPQ-02 Appendix — Power Shared-Rail Analysis

| Combination | 3.3 V | Direct 5 V | Equivalent 5 V including core at 85% | Result |
|---|---:|---:|---:|---|
| Base idle | 50 mA | 6 mA | 44.8 mA | PASS estimate |
| Typical with relay | 277 mA | 255 mA | 470 mA | PASS estimate |
| Maximum simultaneous continuous | 1.00 A | 470 mA | 1.246 A | 254 mA below 1.50 A main |
| Three affected branch continuous | expansion 100 mA | motor A+B 200 mA | included above | contracts preserved |
| Three affected branch peak | expansion 150 mA/10 ms | motor A+B 300 mA/10 ms | state-dependent | within rail peaks when QER totals obeyed |
| USB-only | ≤550 mA core screen | 0 main-only | ≤500 mA USB input | main-only branches off |

At 7.5 W, board input is 0.980/0.490/0.420 A at 9/18/21 V and 85%. J10 is DNP or another nonessential 3.3 V load is constrained when maxima exceed the 1.00 A simultaneous limit. No new concurrency restriction is introduced. Avoiding coincident optional-branch recovery improves availability, but safety must pass the conservative simultaneous test. Dual-source tests prove core ≥3.0 V, no cross-current and USB backfeed ≤10 µA.
