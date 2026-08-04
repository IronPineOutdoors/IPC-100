# ECO-011A3 — Watchdog, Master Authorization, and Relay-Gate Physical Decomposition

## 1. Scope

This entry-gate review evaluates whether Sheet 06 can be physically decomposed without changing ADR-044. It makes no schematic, BOM, AVL, population, hierarchy, GPIO, ADR, ICD, footprint, or PCB change because the frozen watchdog timing contract is not physically selectable as written.

## 2. Current Sheet Audit

Baseline `e382ff0` contains U601 `IPC100:WINDOW_WATCHDOG`, U602 `IPC100:AUTH4`, and U603 `IPC100:AND2`. `WATCHDOG_SERVICE_MCU`, `RESET_VALID`, `MAIN_POWER_GOOD`, and `STOP_HW_INHIBIT` reach Sheet 06. `WATCHDOG_VALID`, `ACTUATOR_PERMIT`, and `MASTER_INHIBIT` remain present. The relay request gate, R602 MOSFET gate resistor, R603 gate pulldown, Q601, D601/D602 clamp, K601 relay, `RELAY_VCC`, and relay-contact exports remain represented. No extra motor enable, stale watchdog interface, or partial physical decomposition exists.

Affected references would be U601/U602 and potentially U603 plus their timing, qualification, storage, bypass, and DFT support. Affected internal nets would include `WATCHDOG_TIMING`, startup evidence, fault latch, `WATCHDOG_VALID`, authorization intermediates, and `RELAY_GATE_AUTH`. No changes are authorized while the entry gate is open.

## 3. Watchdog Contract

ADR-044 requires alternating `WATCHDOG_SERVICE_MCU` transitions at 75 ms nominal, accepted at 40–100 ms, at least two valid transitions before startup qualification, invalidation no later than 250 ms, rejection of static/early/late service, and reset-or-power-cycle recovery after a timing fault. `RESET_VALID` and `MAIN_POWER_GOOD` must qualify startup and clear validity on loss.

Required state disposition remains:

| State | WATCHDOG_VALID |
|---|---:|
| Power absent, reset asserted, brownout, or main power invalid | 0 |
| Reset released but no evidence | 0 |
| First valid transition | 0 |
| Second and later valid transitions | 1 |
| Static, too early, too late, or stopped service | 0, fault latched |
| Recovery without reset/power cycle | 0 |
| Fresh sequence after reset/power cycle | Eligible after two valid transitions |

## 4. Selected Watchdog Architecture

No architecture is selected. The leading exact candidate was TI TPS3850-Q1, an ACTIVE automotive 1.6–6.5 V, −40 °C to 125 °C, 10-pin VSON supervisor/window-watchdog with open-drain WDO and external CWD timing. Official datasheet: <https://www.ti.com/lit/ds/symlink/tps3850-q1.pdf>.

TPS3850-Q1 supports only lower:upper ratios 1:8, 1:2, and 3:4. It detects falling WDI edges, not every alternating edge, so ADR-044 would additionally require an explicit both-edge pulse converter. WDO alone also does not implement the required two-transition startup counter or reset-latched fault memory; explicit state packages would still be required.

## 5. U601 Decomposition

Not performed. A plausible later topology is a real window watchdog, both-edge pulse converter, two-event startup counter, reset-latched fault storage, and combinational `RESET_VALID`/`MAIN_POWER_GOOD` qualification. Pin mapping and references cannot be released until the timing window is physically consistent.

## 6. Timing Proof

The acceptance conditions are mutually incompatible for any nonzero-tolerance physical threshold:

- To guarantee every interval `t < 40 ms` is rejected, the minimum possible early boundary must be at least 40 ms.
- To guarantee `t = 40 ms` is accepted, the maximum possible early boundary must be no greater than 40 ms.
- Therefore the early boundary must equal exactly 40.000 ms for every device, voltage, temperature, oscillator state, and timing-component tolerance.

That is a zero-width tolerance requirement and cannot be met by a physical timing device.

TPS3850-Q1 independently fails the requested window shape. Its adjustable upper boundary has ±9.5% device tolerance before capacitor tolerance. To guarantee a 100 ms valid upper endpoint requires nominal `tWDU ≥ 100/0.905 = 110.50 ms`. At the available 1:2 ratio, the lower boundary is approximately 50.0–60.5 ms, so 40–50 ms cannot be guaranteed valid. The 1:8 ratio gives approximately 12.5–15.1 ms and admits prohibited early service. The 3:4 ratio gives approximately 75.0–90.7 ms. No setting guarantees both the requested early rejection and the complete 40–100 ms valid region.

The 250 ms absolute deauthorization limit is independently achievable; it does not resolve the lower/upper window contradiction.

## 7. Startup Qualifier and Latch

No physical state circuit is released. Later implementation must count both alternating transitions, remain invalid through the first event, asynchronously clear on reset/main/supply loss, latch any watchdog fault until reset or power cycle, and prevent a transient set during asynchronous clear. Metastability and edge-converter pulse width require exact-device analysis after the timing prerequisite closes.

## 8. Master Authorization Truth Table

The frozen equations remain valid and unchanged:

`P = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID`

`ACTUATOR_PERMIT = P`; `MASTER_INHIBIT = NOT P`.

All 16 combinations reduce to one permitting row `(1,0,1,1) → (1,0)`; the other 15 combinations produce `(0,1)`. Supply absent, any open input, startup, brownout, reset loss, watchdog loss, STOP assertion, or main-power loss must map to the inhibited result through existing safe biases.

## 9. U602 Decomposition

Not performed because its WATCHDOG_VALID input cannot yet be generated by a released physical implementation. Cascaded Q1 AND gates plus an inverter are feasible after the watchdog prerequisite; selecting them now would create an incomplete safety path.

## 10. Authorization Connectivity Regression

No connectivity was changed. Existing Sheet 06 outputs still route to Sheet 05 and the relay gate. ECO-001/DFR-01R pin-level lessons remain acceptance requirements for the later physical capture.

## 11. U603 Relay Gate

The equation remains `RELAY_GATE_AUTH = RELAY_CMD_MCU AND ACTUATOR_PERMIT`. A single SN74LVC1G08-Q1-class gate is functionally plausible, but no exact U603 release is made in isolation from the blocked authorization chain. U603 remains the existing unresolved abstraction.

## 12. Relay Driver Regression

The downstream MOSFET, gate resistor/pulldown, clamp, relay coil, supply, and contact exports are unchanged. Existing defaults keep the relay off during startup or logic loss. Exact relay, MOSFET, clamp, and gate selection remain later component-release work and were not altered.

## 13. Failure-Mode Review

No new device exists to review. The unresolved contract prevents defensible evaluation of early/late timing-component tolerance, edge-converter faults, startup-counter faults, and fault-latch recovery. Existing documented residuals—watchdog output stuck active, relay gate stuck active, MOSFET short, and welded contact—remain; no formal functional-safety compliance is claimed.

## 14. Exact Device and Pin Mapping

None released. TPS3850-Q1 feasibility evidence is candidate analysis only, not a selection. Consequently no manufacturer pin map, package power unit, no-connect, or footprint may be added.

## 15. Reference Allocation

No references are allocated or retired. U601/U602/U603 remain active unresolved historical abstractions. The Reference Designator Register is unchanged.

## 16. Decoupling and Unused Units

No packages were added. Decoupling and unused-unit allocation remain blocked with exact topology.

## 17. DFT Nodes

No test nodes were added. The later physical design must expose all nodes requested by the mission without footprints.

## 18. Population Register Changes

Previous and current count remain 435. Physical rows added: 0. Composite rows retired: 0. All existing Sheet 06 blocked references remain blocked.

## 19. EBOM/AVL Reconciliation

No reconciliation is required because the schematic inventory did not change. EBOM, AVL, XLSX, and population artifacts remain byte-for-byte at the accepted ECO-011A2 checkpoint.

## 20. Validation Results

The targeted incomplete validator proves Sheet 06, BOM/AVL/population, hierarchy, GPIO, ADRs, ICDs, footprints, and PCB inventory are unchanged from `e382ff0`; it also checks exactly one incomplete decision and the documented mathematical prerequisite. Repository-wide validators must remain passing.

## 21. Native ERC Status

Not applicable to a no-schematic-change entry-gate decision. `kicad-cli` remains unavailable; native ERC stays pending.

## 22. Remaining ECO-011 Work

ECO-011A3 remains open. ECO-011A4, EPP-01A-R, footprint assignment, placement, routing, and fabrication are not authorized.

## 23. Manual Review Checklist

- [x] Frozen state/timing requirements reconstructed.
- [x] Official exact-candidate timing ratios and tolerances reviewed.
- [x] Fundamental boundary contradiction proven.
- [x] No prohibited change made.
- [ ] Approve a narrow ADR-044/QER timing guard-band amendment.
- [ ] Re-run exact architecture selection after amendment.

## Smallest prerequisite

Issue a narrow timing-resolution package that separates guaranteed reject and guaranteed accept regions with nonzero guard bands. It must state, independently:

1. a guaranteed-too-early interval;
2. a guaranteed-valid interval containing the 75 ms nominal service;
3. an indeterminate guard band at each boundary, if permitted;
4. a guaranteed-too-late interval;
5. the absolute ≤250 ms invalidation deadline; and
6. whether every alternating edge or only one polarity is the watchdog evidence event.

One physically plausible requirement shape would reject `≤35 ms`, guarantee acceptance over `45–95 ms`, treat 35–45 ms and 95–105 ms as guard bands, reject `≥105 ms`, and retain the ≤250 ms absolute invalidation limit. This example is not authorized and requires the design authority’s decision.

# ECO-011A3 INCOMPLETE
