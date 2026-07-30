# Package 09R — Sheet 08 Restricted Expansion Interface Implementation

## 1. Scope

Package 09R implements only the optional J10 internal expansion circuitry authorized by ICD-001:

- a fail-disabled, rail-qualified I²C segment;
- dual-supply bus isolation between the Sheet 07 base bus and J10-side nets;
- local filtering and decoupling of the Sheet 08 external-side bias supply;
- two expansion-side pull-ups;
- connector-side series damping;
- generic ESD/reverse-injection protection provisions;
- stuck-bus fault containment; and
- six schematic DFT nodes.

The complete Sheet 08 option is DNP by default. No connector, footprint, PCB layout, accessory, CAN, RS-485, UART, SPI, USB, wired RangeHub function, GPIO37 use, new GPIO, new rail, or safety/actuator interface is present.

Sheet 02 remains the only owner of `EXPANSION_VCC` switching, its 100 mA current envelope, request pull-down, and `MAIN_POWER_GOOD` qualification. Sheet 07 remains the only owner of internal `I2C_SDA` and `I2C_SCL` pull-ups. Sheet 09 remains the only owner of J10 and physical test pads.

## 2. Expansion Architecture

The functional path is:

`Sheet 07 base I²C` → `U2 disabled-by-default segment buffer` → `R4/R5 series damping` → `D1/D2 protection provisions` → `J10-side functional nets`

The local power/enable path is:

`EXPANSION_VCC` → `FB1/C1/C2 local filter` → `U1 2.9 V/2.7 V qualifier` → `EXPANSION_SEGMENT_ENABLE`

U2 uses `+3V3_CORE` on its internal side and filtered `EXPANSION_VCC` on its external side. U2 must be high impedance between both segments when disabled or when either applicable supply is absent. R1 provides a 100 kΩ fail-low default on its enable. No firmware-only signal can directly enable U2; the optional branch must first be requested and qualified on Sheet 02, then pass the local voltage/time check.

`J10_I2C_SCL` remains output-only at the hierarchy boundary. ICD-001 prohibits accessory clock stretching. `J10_I2C_SDA` remains bidirectional.

## 3. Implemented Circuit Inventory

| Reference | Function | Preliminary value/class | Population |
| --- | --- | --- | --- |
| U1 | Expansion rail-valid qualifier | 2.9 V minimum assert, 2.7 V maximum deassert, at least 5 ms valid delay, fail-low output | DNP by default |
| U2 | Dual-supply I²C hot-swap segment buffer | 100 kHz, high-Z disabled/unpowered, no false-low startup pulse, ≤10 µA powered-off leakage per line | DNP by default |
| R1 | Segment-enable default | 100 kΩ ±1% to ground | DNP by default |
| R2/R3 | External SDA/SCL pull-ups | 4.70 kΩ ±1% to filtered `EXPANSION_VCC` | DNP by default |
| R4/R5 | Connector-side damping | 47 Ω preliminary; allowed final range 33–100 Ω after SI review | DNP by default |
| FB1 | Local expansion-bias filter | Impedance/current rating pending protection-part selection | DNP by default |
| C1 | External-side local decoupling | 100 nF X7R ±10% | DNP by default |
| C2 | External-side reservoir | 10 µF X7R; total accessory capacitance remains within 22 µF ICD limit | DNP by default |
| C3 | Core-side U2 decoupling | 100 nF X7R ±10% | DNP by default |
| D1/D2 | SDA/SCL ESD provisions | Low-capacitance TVS class; final part pending | DNP by default |
| D3 | Expansion-power protection provision | ESD/reverse-injection class coordinated with Sheet 02/09 | DNP by default |
| TP1–TP6 | Schematic DFT nodes | Power, enable, internal SDA/SCL, external SDA/SCL | No footprints |

## 4. Power Calculations

### 4.1 Released load envelope

ICD-001 releases:

- `VEXP = 3.0–3.45 V` at the board boundary;
- 100 mA maximum continuous branch current;
- 75 mA maximum normal accessory load;
- 150 mA maximum startup current for 10 ms;
- 22 µF maximum accessory input capacitance; and
- 3.0 V minimum accessory operating voltage.

Sheet 08 does not increase those limits. U2, its qualifier, pull-ups, and leakage consume part of the reserved 25 mA margin.

At 75 mA, maintaining at least 3.0 V from a 3.3 V nominal rail permits a total source/cable/contact resistance of:

`RMAX = 0.3 V / 0.075 A = 4.0 Ω`

The released 0.30 m harness should be far below this value, but the selected connector and wire gauge must be verified by Sheet 09.

### 4.2 Local capacitance and inrush

C1 + C2 nominal local capacitance is 10.1 µF. Ignoring regulator current used by other loads, charging 10.1 µF to 3.3 V at the 150 mA startup ceiling requires:

`t = C × V / I = 10.1 µF × 3.3 V / 0.150 A ≈ 0.22 ms`

Stored energy at the 3.45 V maximum is:

`E = 0.5 × C × V² ≈ 0.5 × 10.1 µF × (3.45 V)² ≈ 60 µJ`

This local capacitance leaves approximately 11.9 µF of the ICD-001 22 µF limit for an approved accessory and connector-side parasitics. Effective X7R capacitance under DC bias must be used for timing, while maximum tolerance and assembly population must be used for inrush.

### 4.3 Enable default

R1 draws approximately:

`I = 3.3 V / 100 kΩ = 33 µA`

when U1 asserts. That load is negligible, but the selected U1 output leakage and U2 enable input leakage must be bounded so the disabled voltage remains below U2 VIL at 3.45 V and temperature extremes.

## 5. I²C Calculations

Sheet 07 owns 4.70 kΩ internal pull-ups. R2/R3 are the only Sheet 08 external-segment pull-ups.

Worst-case static low current per external line at maximum rail and minimum 1% resistor is:

`ILOW = 3.45 V / (4.70 kΩ × 0.99) ≈ 0.741 mA`

Both lines low draw approximately 1.48 mA, excluding buffer current. The selected buffer and accessory must meet VOL requirements at this sink current.

The first-order standard-mode rise-time estimate at the 100 pF maximum segment capacitance is:

`tr ≈ 0.8473 × RP × CBUS`

At 4.70 kΩ nominal:

`tr ≈ 0.8473 × 4.70 kΩ × 100 pF ≈ 398 ns`

At the ICD-001 maximum accepted equivalent pull-up of 5.6 kΩ:

`tr ≈ 474 ns`

Both are below the 1.0 µs standard-mode I²C maximum, leaving margin for buffer behavior. Exact rise/fall timing must include TVS capacitance, connector/cable capacitance, buffer offset and rise-time accelerator behavior, voltage, and temperature.

The 47 Ω series resistors add only 4.7 ns with a 100 pF lumped load and create approximately 35 mV drop at 0.741 mA. Their final 33–100 Ω value is a signal-integrity decision, not an extra pull-up or termination.

Only one accessory using one address in `0x30–0x37` is allowed. Addresses `0x20`, `0x3C–0x3D`, and `0x76–0x77` remain reserved for Sheet 07 devices. Clock stretching is prohibited.

## 6. Protection Rationale

- U2 prevents a disconnected, unpowered, or stuck external segment from continuously loading the core I²C bus after disable.
- U1 prevents buffer connection before the expansion rail reaches 2.9 V and forces disconnection by 2.7 V.
- R1 makes missing, unpowered, or open qualifier output fail disabled.
- R4/R5 limit edge current and damp the short in-enclosure cable without acting as I²C termination.
- D1/D2 reserve low-capacitance clamps for the ICD-001 IEC 61000-4-2 assembly target.
- D3 reserves coordinated expansion-power clamping/reverse-injection containment without duplicating Sheet 02 current limiting.
- FB1/C1/C2 filter only Sheet 08 local external-side bias/logic power. They do not create another rail or reroute the Sheet 02-to-09 power ownership.

Final TVS, ferrite, qualifier, and buffer parts remain deliberately unselected. Release selection must verify absolute maximum voltage, I/O offset, powered-off leakage, fail-safe behavior, capacitance, pulse current path, temperature, and availability.

## 7. Startup and Shutdown

### Startup

1. U2 enable is held low by R1.
2. USB-only may establish `+3V3_CORE`, but `EXPANSION_VCC` remains off and U2 remains isolated.
3. Valid main power and a deliberate firmware request allow Sheet 02 to establish `EXPANSION_VCC`.
4. FB1/C1/C2 establish the filtered local rail.
5. U1 waits for at least 2.9 V for at least 5 ms.
6. U1 releases U2 enable.
7. Firmware waits at least 10 ms after segment enable before communication.

### Shutdown

Firmware stops transactions and requests power removal. U1 forces U2 disabled no later than the filtered rail crossing 2.7 V. This prevents an external-side collapse from driving the internal bus through an undefined buffer state. Brownout and main-power loss follow the same hardware path without relying on firmware.

## 8. Failure-Mode Review

| Condition | Sheet 08 response | IPC-100 / safety effect |
| --- | --- | --- |
| Option DNP or connector absent | U2 and pull-ups absent; internal bus unchanged | No effect |
| Reset or bootloader | Sheet 02 request defaults low; U2 fail-disabled | No expansion power; no actuator effect |
| USB-only | Core side may be powered; external rail absent; U2 high-Z | No backfeed or authorization |
| Brownout | U1 disables U2 by 2.7 V | External collapse cannot directly hold internal bus |
| External SDA/SCL open | No accessory response | Internal bus remains operational |
| External SDA/SCL stuck low | Transaction timeout; firmware disables segment | Internal bus recovers after isolation |
| External line short to power | U2 isolation and protection provision contain fault | Exact stress pending part selection |
| `EXPANSION_VCC` short | Sheet 02 current limit owns containment | Must not collapse core or authorize outputs |
| Accessory unpowered | External pull-ups are off; U2 disabled with rail invalid | No core-to-accessory injection above limit |
| Accessory independently powered | Prohibited by ICD-001 | Final parts must still meet ≤10 µA per-line leakage target |
| Accidental partial insertion | Rail qualification delays segment connection | Damage containment only; live mating remains prohibited |
| ESD | D1–D3 route event locally after final selection/layout | No unsafe authorization claim; prototype test required |
| Buffer failed connected | External stuck fault may propagate | Prototype single-fault review and exact-part analysis remain open |
| Qualifier output open/low | R1 holds segment disabled | Safe loss of expansion |
| Qualifier output stuck high | U2 may connect during invalid rail | Exact-device/single-fault review required before release |
| Noise or invalid address traffic | Firmware rejects unsupported device/protocol | Expansion remains non-safety |

Sheet 08 has no access to STOP, watchdog, actuator permit, master inhibit, relay, or motor nets.

## 9. Validation

Repository validation confirms:

- root/child hierarchy and directions match;
- GPIO allocation is unchanged;
- GPIO37 remains reserved and GPIO42 remains `WATCHDOG_SERVICE_MCU`;
- the only hierarchical signals are the six frozen Sheet 08 ports;
- exactly two external pull-ups are present and Sheet 07 internal pull-ups are unchanged;
- address `0x30–0x37`, 100 kHz, and no-clock-stretch restrictions are recorded;
- six schematic DFT nodes are present;
- references and UUIDs are unique;
- component symbols remain confined to implemented Sheets 01–08;
- Sheet 09 remains a component-free placeholder; and
- zero footprint assignments exist.

Native KiCad ERC remains pending because `kicad-cli` is unavailable in the implementation environment. Custom preliminary symbols require exact vendor symbol/pin replacement before schematic release.

## 10. Remaining ODIs

- Select the exact U1 rail qualifier and prove threshold/delay/leakage tolerances.
- Select the exact U2 dual-supply hot-swap buffer and verify powered-off leakage, I²C offset, false-pulse behavior, stuck-bus isolation, and no-clock-stretch operation.
- Select FB1 and D1–D3 from the released EMC and layout environment.
- Verify C2 effective/minimum and maximum capacitance over bias/tolerance/temperature.
- Close Sheet 02 optional switch current-limit, retry/latch, inrush, discharge, and reverse-injection behavior.
- Release a single accessory identity/protocol/address.
- Complete Sheet 09 connector family, physical pin numbering, keying, harness, protection placement, and test-pad implementation.
- Run native ERC, worst-case analysis, SI review, ESD testing, partial-power testing, and stuck-bus fault injection.

## 11. Manual Review Checklist

- [x] Only ICD-001 functions captured.
- [x] Root/child ports and SCL output direction preserved.
- [x] GPIO37 unused and GPIO42 unchanged.
- [x] No new GPIO, bus, rail, safety, actuator, relay, or motor interface.
- [x] Sheet 02 remains expansion-power owner.
- [x] Sheet 07 remains internal pull-up owner.
- [x] Exactly two Sheet 08 external pull-ups.
- [x] U2 defaults disconnected.
- [x] Rail-invalid, reset, USB-only, and open-enable cases fail disabled.
- [x] External stuck-low isolation represented.
- [x] 100 kHz, 100 pF, 0.30 m, one-accessory, and `0x30–0x37` limits recorded.
- [x] Clock stretching prohibited.
- [x] Protection and series damping provisions present.
- [x] Six DFT nodes defined without footprints.
- [x] No connector symbols.
- [x] Sheet 09 untouched.
- [x] No footprint or PCB work.
- [ ] Exact parts and pin mappings selected.
- [ ] Native KiCad ERC complete.
- [ ] Worst-case electrical and prototype fault tests complete.
