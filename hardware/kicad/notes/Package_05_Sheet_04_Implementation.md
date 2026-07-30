# Package 05 — Sheet 04 Entry-Gate Review

**Status: blocked before schematic modification.**

Package 05 reviewed the frozen IPC-100 Rev A input architecture before placing any Sheet 04 circuitry. The authoritative documents do not yet present one synchronized implementation contract. In accordance with the package entry-gate rule, `sheets/04_Safety_Inputs.kicad_sch` remains the Package 01 circuitry-free placeholder.

## Intended input inventory

No undocumented guard, lid, home, reference, ready, permission, or device-present input is approved for Rev A.

| Input | Class | Field contact | Domain | Processor net | Sheet 06 consumer |
| --- | --- | --- | --- | --- | --- |
| `STOP_IN_RAW` | Safety critical | NC supervised dry contact, dedicated return | `FIELD_SENSE_VCC` | `STOP_IN_COND` | `STOP_HW_INHIBIT` |
| `LIMIT_LEFT_RAW` | Directional safety input | NC supervised dry contact, dedicated return | `FIELD_SENSE_VCC` | `LIMIT_LEFT_COND` | None; firmware directional policy |
| `LIMIT_RIGHT_RAW` | Directional safety input | NC supervised dry contact, dedicated return | `FIELD_SENSE_VCC` | `LIMIT_RIGHT_COND` | None; firmware directional policy |
| `LIMIT_UP_RAW` | Directional safety input | NC supervised dry contact, dedicated return | `FIELD_SENSE_VCC` | `LIMIT_UP_COND` | None; firmware directional policy |
| `LIMIT_DOWN_RAW` | Directional safety input | NC supervised dry contact, dedicated return | `FIELD_SENSE_VCC` | `LIMIT_DOWN_COND` | None; firmware directional policy |
| `ARM_IN_RAW` | Operational command | NO momentary dry contact | Conflicting: field-sense in interface documents, 3.3 V in quantitative document | `ARM_IN_COND` | None |
| `FIRE_IN_RAW` | Operational command | NO momentary dry contact | Conflicting: field-sense in interface documents, 3.3 V in quantitative document | `FIRE_IN_COND` | None |

ADR-040 assigns processor GPIOs to the seven conditioned nets above. It does not assign GPIOs to `STOP_FAULT`, the four limit-fault nets, or `INPUT_FAULT_SUMMARY`.

## Entry-gate conflicts

1. The quantitative component document specifies a 5.0 V field source, 2.20 kΩ controller/EOL resistors, 1.00 V and 4.00 V windows, 10 m maximum loops, 100 µs filtering, and bounded timing. The authoritative Safety Input Review, Connector Specification, and Hardware Requirements still call those items `TBD`, partially satisfied, or unresolved.
2. ARM/FIRE power is not synchronized. Interface documents describe the main-powered field-sense domain; the quantitative document specifies 3.3 V pull-ups. The latter could remain powered during USB-only service unless an approved main-valid gate prevents it.
3. The hierarchy exports five individual fault nets plus `INPUT_FAULT_SUMMARY`, but calls summary adoption and detection optional/open. ADR-040 provides no processor GPIO for those diagnostics. Their consumer, aggregation, polarity, and disposition are unresolved.
4. The quantitative document requests 100 kΩ comparator hysteresis only where simulation supports it, while worst-case threshold analysis and SPICE remain a release blocker. Capture authority must define whether these are populated, DNP tuning provisions, or omitted.

Choosing among these contracts during capture would create new safety behavior and violate Package 05 authority.

## Quantitative basis awaiting synchronization

- Healthy: nominal 2.50 V and `1.00 V < VSENSE < 4.00 V`.
- Short to return: nominal 0 V, fault.
- Open contact or broken wire: nominal 5.00 V, asserted/open and conservative inhibit.
- Controller and remote EOL resistance: 2.20 kΩ ±1% each.
- Healthy current: `5 V / 4.40 kΩ = 1.136 mA`.
- Short current: `5 V / 2.20 kΩ = 2.273 mA`.
- Candidate input filter: 1 kΩ and 100 nF, nominal `τ = 100 µs`.
- Candidate harness: 10 m maximum, ≤2 nF, routed away from motor leads.
- Hardware STOP path: actuator permit removed within 5 ms.
- Candidate firmware qualification: STOP assertion ≤2 ms, limit assertion ≤5 ms, 20 ms releases, ARM/FIRE 10 ms.

These values are recorded for resolution traceability and are not claimed as implemented.

## Default-state intent

| Condition | STOP | Limit | ARM/FIRE |
| --- | --- | --- | --- |
| Healthy/inactive contact | Healthy | Direction clear | Inactive |
| Intentional opening/activation | Inhibit | Inhibit motion farther into endpoint | Qualified request only |
| Cable open | Inhibit and diagnose | Conservative directional inhibit | Inactive/disconnected |
| Short to return | Fault and inhibit | Fault and directional inhibit | Held/illegal state |
| Loss of field sense or main power | Inhibit | Motion unavailable | No command |
| USB-only, reset, or brownout | Inhibit | Motion unavailable | No authorization |

## Schematic and validation result

- Sheet 04 components, nets, and ports changed: **0**
- Footprints added: **0**
- GPIO allocation changed: **0**
- KiCad ERC: not run; no schematic implementation was authorized
- Expected ERC warnings: unchanged placeholder-sheet warnings only

## Smallest resolution package

Create **Architecture Resolution Package AR-04 — Safety-Input Implementation Contract Synchronization**. It should:

1. accept or amend the quantitative input contract;
2. synchronize the Safety Input Review, Hardware Requirements, Connector Specification, hierarchy tables, and open-item register;
3. select the ARM/FIRE power domain and prove USB-only/non-backfeed behavior;
4. freeze conditioned/fault polarities, aggregation, consumers, and GPIO visibility;
5. state the preliminary hysteresis/DNP policy and analysis required before release; and
6. issue an accepted ADR authorizing Package 05R without changing ADR-040 unless explicitly approved.

After AR-04 acceptance, proceed with **Package 05R — Sheet 04 Safety Inputs, Interlocks & External Sense Interfaces**. Package 06 is not ready because Sheet 04 has not been implemented.

## Manual review checklist

- [x] Approved inventory, classifications, contact types, GPIOs, and Sheet 06 consumer compared.
- [x] Cable, voltage, thresholds, filtering, and timing compared.
- [x] Sheet 04 confirmed unchanged.
- [ ] AR-04 accepted and authoritative documents synchronized.
- [ ] Package 05R authorized.
