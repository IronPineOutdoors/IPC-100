# ADR-039 — Regulated Rail Enable Ownership and Main-Source Qualification

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Date | 2026-07-29 |
| Status | Accepted |
| Decision owner | Iron Pine Outdoors Engineering |
| Supersedes | Unresolved portions of ADR-022, ADR-023, and ODI-SCH-007 |

> ADR-036 was already assigned to the ESP32-S3-WROOM-1-N8 preliminary-capture decision. This resolution therefore uses the next available identifier, ADR-039.
>
> **ADR-041 amendment:** `MAIN_POWER_GOOD` remains owned by Sheet 02 and consumed by Sheet 06, but is no longer routed to Sheet 03 or firmware.

## Context and blocking conflict

Sheet 02 owns regulated rails and main-only branch switching. Its frozen interface originally accepted only `VIN_PROTECTED` and `USB_5V_PROTECTED`, although the architecture required several branches to remain off until firmware completed safe initialization. It also lacked an upstream qualifier needed to distinguish a valid main source from downstream regulator status. Package 03 correctly stopped before inventing either interface.

## Considered options

1. Turn every branch on with `+5V_MAIN`. Rejected because optional peripherals and expansion would energize before initialization.
2. Leave request-controlled branches permanently off. Rejected because released outputs would be nonfunctional.
3. Put all branch policy in Sheet 02. Rejected because the power sheet must implement switching, not operational policy.
4. Route all requests through Sheet 06. Rejected because this creates unnecessary coupling between non-actuator peripherals and master-inhibit logic.
5. Let Sheet 03 request non-actuator peripheral branches, while Sheet 02 hardware-qualifies every request with valid main power. Selected.

## Selected architecture

- Sheet 01 exports `MAIN_INPUT_VALID`, sourced from the TPS2663-family input eFuse `PGOOD` function.
- `MAIN_INPUT_VALID` is released-valid open-drain. Sheet 02 owns its pull-up and qualification in the main-powered domain. It follows the eFuse PGOOD/PGTH result: the protected output must be above its approved threshold and the device must be enabled. UVLO, OVLO, reverse input, thermal shutdown, latch-off, or current limiting deassert it when those conditions disable or pull the protected output below PGTH. It is not a comprehensive fault-code signal.
- Sheet 02 creates `MAIN_POWER_GOOD` only when `MAIN_INPUT_VALID` is qualified and the 5 V regulator reports an in-tolerance output.
- Sheet 03 produces active-high `OLED_POWER_REQ`, `SENSOR_POWER_REQ`, `UI_POWER_REQ`, and `EXPANSION_POWER_REQ`.
- Sheet 02 provides a hardware pull-down on every request and gates every request with `MAIN_POWER_GOOD`. Open, unpowered, reset, or undefined requests are off.
- `RELAY_VCC`, both motor-logic rails, and `FIELD_SENSE_VCC` are hardware-enabled main-only branches. Their loads remain harmless until Sheet 06 and the consuming sheets apply their existing safe-state controls.
- Sheet 06 remains the sole owner of actuator authorization and does not become a peripheral-power policy router.

## Interface contract

| Signal | Producer | Consumer | Direction | Polarity | Default | Domain | Purpose |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `MAIN_INPUT_VALID` | Sheet 01 | Sheet 02 | 01 output / 02 input | Released-valid open-drain; qualified active high | Invalid | Pull-up owned by 02 from main domain | Confirms protected main path is operating |
| `OLED_POWER_REQ` | Sheet 03 | Sheet 02 | 03 output / 02 input | Active high | 100 kΩ pull-down on 02 | 3.3 V logic | Requests OLED branch |
| `SENSOR_POWER_REQ` | Sheet 03 | Sheet 02 | 03 output / 02 input | Active high | 100 kΩ pull-down on 02 | 3.3 V logic | Requests sensor branch |
| `UI_POWER_REQ` | Sheet 03 | Sheet 02 | 03 output / 02 input | Active high | 100 kΩ pull-down on 02 | 3.3 V logic | Requests UI branch |
| `EXPANSION_POWER_REQ` | Sheet 03 | Sheet 02 | 03 output / 02 input | Active high | 100 kΩ pull-down on 02 | 3.3 V logic | Requests optional expansion power |
| `MAIN_POWER_GOOD` | Sheet 02 | Sheet 06 | 02 output / 06 input | Active high, fail low | Low | 3.3 V qualified logic | Safety-relevant main-rail qualifier |

Request nets do not enter Sheet 06. Actuator commands remain subject to `ACTUATOR_PERMIT` on Sheet 06 irrespective of branch power.

## Rail and branch classification and ownership

| Rail | Class | Nominal | Source | Default and owner | Load envelope / population |
| --- | --- | ---: | --- | --- | --- |
| `+5V_MAIN` | C — main-only, hardware-enabled | 5.0 V | `VIN_PROTECTED` | Starts automatically from valid main input; Sheet 02 | 1.5 A continuous design envelope, 2 A peak converter; base |
| `CORE_SOURCE` | A/B — valid main or USB source | 5 V nominal | Priority mux: main first, protected USB alternate | Automatic non-backfeeding mux; Sheet 02 | Core converter input; base |
| `+3V3_CORE` | A/B — valid main or USB source | 3.3 V | `CORE_SOURCE` | Automatic after valid source; Sheet 02 | 1.0 A continuous, at least 1.5 A transient; base |
| `RELAY_VCC` | C | 5.0 V | `+5V_MAIN` | Hardware-on only with qualified main; Sheet 02 | 100 mA allocation; base if relay populated |
| `MOTOR_LOGIC_5V_A` | C | 5.0 V | `+5V_MAIN` | Hardware-on only with qualified main; Sheet 02 | 100 mA preliminary limit; base protected branch |
| `MOTOR_LOGIC_5V_B` | C | 5.0 V | `+5V_MAIN` | Hardware-on only with qualified main; Sheet 02 | 100 mA preliminary limit; base protected branch |
| `FIELD_SENSE_VCC` | C | 5.0 V | `+5V_MAIN` | Hardware-on only with qualified main; Sheet 02 | Five supervised loops; base |
| `OLED_VCC` | D | 3.3 V | switched `+3V3_CORE`, main-qualified | Off until `OLED_POWER_REQ`; Sheet 03 policy / Sheet 02 switch | 150 mA allocation; optional |
| `SENSOR_VCC` | D | 3.3 V | switched `+3V3_CORE`, main-qualified | Off until `SENSOR_POWER_REQ`; Sheet 03 policy / Sheet 02 switch | 50 mA allocation; optional |
| `UI_VCC` | D | 5.0 V | switched `+5V_MAIN` | Off until `UI_POWER_REQ`; Sheet 03 policy / Sheet 02 switch | 120 mA shared UI allocation pending load closure; base interface |
| `EXPANSION_VCC` | D/E | 3.3 V | protected switched `+3V3_CORE`, main-qualified | Off until request; omit population until J10 release | 100 mA released maximum; optional/DNP |

All externally exposed power branches require reverse-injection containment appropriate to their released connector contracts. OLED, sensor, and UI switches require controlled rise and discharge. Expansion and motor-logic branches require current limiting; a plain load switch alone is insufficient.

## Rail-state matrix

`On*` means enabled only when the applicable request is intentionally high.

| Rail | No power | USB only | Main before init | Main after init | Reset | Brownout | Upstream fault | Request active | Request inactive |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `+5V_MAIN` | Off | Off | On | On | On if main valid | Off/invalid | Off | N/A | N/A |
| `CORE_SOURCE` | Off | USB | Main | Main | Available | Remaining valid source | USB only if present | N/A | N/A |
| `+3V3_CORE` | Off | On | On | On | On while reset asserted | Supervisor invalid below threshold | USB may retain core | N/A | N/A |
| `RELAY_VCC` | Off | Off | On when main good | On | On, but actuation inhibited | Off | Off | N/A | N/A |
| `MOTOR_LOGIC_5V_A/B` | Off | Off | On when main good | On | On, commands inhibited | Off | Off | N/A | N/A |
| `FIELD_SENSE_VCC` | Off | Off | On when main good | On | On for conservative hardware sensing | Off | Off | N/A | N/A |
| `OLED_VCC` | Off | Off | Off | On* | Off | Off | Off | On only with main good | Off |
| `SENSOR_VCC` | Off | Off | Off | On* | Off | Off | Off | On only with main good | Off |
| `UI_VCC` | Off | Off | Off | On* | Off | Off | Off | On only with main good | Off |
| `EXPANSION_VCC` | Off | Off | Off | On* if populated | Off | Off | Off | On only with main good | Off |

During reset, hardware-on actuator-related supplies may remain electrically present, but Sheet 06 and consuming interface logic must keep all actuator commands inactive. This distinction prevents power presence from becoming authorization.

## Power-good semantics

| Signal | Assertion | Deassertion | Owner | Consumers |
| --- | --- | --- | --- | --- |
| `MAIN_INPUT_VALID` | U1 PGOOD releases after `VIN_PROTECTED` exceeds the approved PGTH threshold while U1 is enabled | PGOOD pulls low when the protected output falls below PGTH; UVLO, OVLO, reverse input, thermal shutdown, latch-off, and severe current limit are reflected when they disable or collapse the output | Sheet 01 | Sheet 02 only |
| `MAIN_POWER_GOOD` | Qualified `MAIN_INPUT_VALID` AND LMR38020-Q1 PGOOD with `+5V_MAIN` within the approved tolerance/time window | Either qualifier invalid; must fail low before actuator logic becomes unreliable | Sheet 02 | Sheet 02 branch gating, Sheet 06, and prototype test |
| `CORE_POWER_GOOD` | TPS3890-Q1 supervisor confirms `+3V3_CORE` above its released threshold for its release delay | Core falls below threshold | Sheet 03, local semantic feeding reset validity | ESP32 reset/recovery and Sheet 06 through `RESET_VALID`; no new top-level net |
| `POWER_VALID` | Not used in Rev A | N/A | None | None |
| `POWER_FAULT_SUMMARY` | Active-low diagnostic assertion for Sheet 01 input-path faults | Releases when the input eFuse fault clears per its mode | Sheet 01 | Diagnostic/test consumers; not a substitute for main validity |

`CORE_POWER_GOOD` is a defined local condition, not a new hierarchical signal. `RESET_VALID` remains the exported, timed core-readiness condition. `POWER_VALID` is rejected because it would overlap the two qualified conditions without a distinct consumer.

`MAIN_INPUT_VALID` does not independently encode every fault. U1 `FLT`, exported separately as `POWER_FAULT_SUMMARY`, covers the diagnostic fault set. A current-limit event that leaves the protected output above PGTH may retain `MAIN_INPUT_VALID`; detailed Package 03R qualification must ensure `MAIN_POWER_GOOD` deassertion and actuator timing meet the released load-fault requirements.

## USB-only behavior

USB-only powers `CORE_SOURCE`, `+3V3_CORE`, the ESP32 core, native USB programming/recovery support, and only core-domain diagnostic indication implemented without a main-only branch. It does not power OLED, sensor, external UI, field sensing, expansion, relay logic/coil, motor-interface logic, or actuator authorization. All four request-controlled outputs are forced off by Sheet 02 main qualification even if firmware drives a request high.

## Startup and reset behavior

1. Sheet 01 validates the main input and releases `MAIN_INPUT_VALID`.
2. Sheet 02 starts `+5V_MAIN`; USB may independently supply the priority mux.
3. The mux establishes `CORE_SOURCE`, then Sheet 02 establishes `+3V3_CORE`.
4. Sheet 03 supervisor establishes local `CORE_POWER_GOOD`, holds reset for the approved delay, then exports `RESET_VALID`.
5. Request outputs are held low by reset-safe GPIO configuration and Sheet 02 pull-downs.
6. Firmware initializes safe GPIOs, watchdog service, source state, and required input interpretation.
7. Firmware may intentionally assert a non-actuator peripheral request.
8. Sheet 02 gates that request with `MAIN_POWER_GOOD` and enables the branch with controlled rise.

Main-source brownout or loss removes `MAIN_POWER_GOOD`, which disables all request-controlled branches regardless of firmware state. Hardware-on main branches collapse with `+5V_MAIN`; master inhibit remains fail-low. A request wire open, shorted low, undefined, or driven by an unpowered processor is off. A short to 3.3 V can request a peripheral but cannot bypass `MAIN_POWER_GOOD` or authorize an actuator.

## Sheet effects and migration

- Sheet 00: add the five named interconnects.
- Sheet 01: export `MAIN_INPUT_VALID` from the existing eFuse PGOOD node.
- Sheet 02: accept `MAIN_INPUT_VALID` and four power requests.
- Sheet 03: export the four requests; implement reset-low GPIO behavior in Package 04.
- Sheet 06: no new port; continue consuming `MAIN_POWER_GOOD` and owning `ACTUATOR_PERMIT`.

## Consequences

The interface adds four MCU outputs to the existing processor allocation. The GPIO allocation must reserve four suitable non-strapping outputs before Sheet 03 release; this does not authorize pin assignment in AR-01. Optional branches cannot be used during USB-only service. Main-powered safety sensing starts without firmware, while actuator authorization remains independent.

## Verification requirements

- Exercise no-power, USB-only, main-only, both-source, USB-first, main-first, reset, watchdog, brownout, source-fault, and request-wire fault cases.
- Prove no main-only rail energizes from USB.
- Measure `MAIN_INPUT_VALID` and `MAIN_POWER_GOOD` assertion/deassertion order.
- Prove every request has a hardware low default and is overridden by loss of main qualification.
- Verify branch rise, discharge, current limit, reverse injection, short-circuit containment, and recovery.
- Confirm no GPIO-resource or strapping conflict before Sheet 03 capture.
