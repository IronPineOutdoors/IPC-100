# ADR-042 — External Safety Interface Contract

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Date | 2026-07-30 |
| Status | Accepted |
| Decision owner | Iron Pine Outdoors Engineering |
| Resolution package | AR-04 |

## Context

Package 05 stopped before Sheet 04 because authoritative documents disagreed about field voltage, cable limits, timing, ARM/FIRE power, diagnostic exports, fault consumers, and polarity. Implementing any one interpretation would have created unapproved safety behavior.

## Decision

The [External Safety Interface Control Document](../interfaces/External_Safety_Interface_Control_Document.md) is the controlling Rev A interface reference for Sheets 04–06.

Rev A uses five individually returned, 5 V, NC supervised loops: STOP plus four directional limits. A 2.20 kΩ controller source and 2.20 kΩ remote EOL produce a nominal 2.50 V healthy state; below 1.00 V is fault and above 4.00 V is open/asserted. The cable contract is 10 m maximum, 2 nF maximum, and 18–24 AWG. ARM and FIRE are NO operational contacts biased from main-only `FIELD_SENSE_VCC` and translated on Sheet 04.

All processor-conditioned inputs are active high when asserted. `STOP_HW_INHIBIT` and `MASTER_INHIBIT` are active high; `ACTUATOR_PERMIT`, `MAIN_POWER_GOOD`, `RESET_VALID`, and `WATCHDOG_VALID` are affirmative active-high qualifiers. The permit equation and its complement are frozen in the ICD.

Individual electrical fault nets remain local/test-only. No fault summary or permit feedback GPIO is added. Firmware receives conservative conditioned states, logs generic events, and does not claim electrical fault-subtype visibility. `INPUT_FAULT_SUMMARY` and `MASTER_INHIBIT_STATUS` are not adopted for Rev A.

ENABLE, Thrower Ready, External Ready, Remote Inhibit, guard/lid, home/reference, and other permission inputs are absent from Rev A. Adding one requires a new ADR and resource review.

## Consequences

- Sheet 04 may be implemented without inventing input, polarity, timing, or diagnostic behavior.
- USB-only service cannot energize field wiring or authorize actuators.
- Hardware removes actuator authorization without firmware.
- Directional limits remain independently visible; product firmware applies direction-aware policy.
- The fixed GPIO map is unchanged.
- Detailed electrical fault subtype is available at test access, not remotely through firmware.
- IPC-100 remains a non-certified controller requiring product-level hazard controls.

## Supersession and synchronization

On controlled subjects, ADR-042 and its ICD supersede stale `TBD`, optional, or polarity-open statements in the Safety Input Architecture Review, Hardware Requirements, Connector Specification, Output Electrical Architecture Review, and hierarchy definition. Those documents shall point to the ICD rather than restating divergent contracts.

## Authorization

AR-04 closes ODI-SCH-011 and authorizes **IPC-100 Rev A Preliminary KiCad Capture Package 05R — Sheet 04 Safety Inputs, Interlocks & External Sense Interfaces**. No schematic modification, GPIO reassignment, footprint selection, Sheet 05 work, or Sheet 06 work is authorized by AR-04 itself.
