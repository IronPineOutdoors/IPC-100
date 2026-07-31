# PPQ-01 Appendix — Power Protection Model

## Coordination chain

`source/harness → F101 → D101/Q101/U101/U102 → VIN_PROTECTED → U201 → branch switches → loads`

| Protection function | Qualification equation / limit | Timing | Acceptance evidence |
|---|---|---|---|
| Fuse carry | 1.25 A ≤70% hot carry capability | continuous at 75°C | manufacturer derating curve |
| Fuse inrush | integrate `I²t`; 4 A/10 ms must not open | connection | time-current/I²t curve + test |
| Fuse fault | clear 10 A before trace/harness damage | ≤5 s | curve and conductor thermal proof |
| TVS | `I=max(0,(VS−VC)/RS)`; `E=∫VC·I dt` | 40 V/100 ms ×5 | tolerance/dynamic resistance; ≥2× energy |
| Reverse FET | RDS≤80 mΩ hot; leakage≤1 mA | −24 V/60 s | SOA/leakage and test |
| eFuse/OV | current-limit total 1.5–2.5 A | 30 V/60 s; surge | exact SOA, cutoff/retry waveform |
| Branch switch | limit cannot collapse core or authorize output | short until retry/latch | min/max temp short test |
| Flyback/clamp | clamp below 80% affected abs max | coil opening | scope voltage/current/energy |
| USB VBUS | ≤500 mA and ≤10 µA host backfeed | steady/hot plug | source/sink current logging |

Because the +40 V open-circuit pulse is below the 55 V clamp ceiling, the TVS may conduct little or no current. The eFuse/OV and downstream 80 V class must therefore survive the pulse without relying on imaginary TVS absorption. Conversely, any selected low-clamp TVS must prove actual pulse energy with tolerance and 2 Ω source resistance.

## Protection timing record

For connection, surge, overvoltage, reverse, short and recovery, record source waveform, protected voltage/current, device temperature, power-good, authorization state, retry interval and final recovery. Pass requires no unauthorized pulse, no core collapse outside released behavior, retry ≥100 ms or controlled latch recovery, and no damage.
