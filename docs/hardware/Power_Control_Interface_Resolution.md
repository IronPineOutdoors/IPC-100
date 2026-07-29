# IPC-100 Rev A Power-Control Interface Resolution

Architecture Resolution Package AR-01 closes the interface-definition conflict recorded by Preliminary KiCad Capture Package 03.

The controlled decision is [ADR-039](../decisions/ADR-039_Regulated_Rail_Enable_Ownership_and_Main_Source_Qualification.md). Its interface, rail-state, power-good, USB-only, startup, failure, migration, and verification tables are normative.

## Resolution summary

- Sheet 01 exports released-valid open-drain `MAIN_INPUT_VALID` from the input eFuse PGOOD/PGTH node. It qualifies protected-output voltage and is not a replacement for the separate fault summary.
- Sheet 02 combines that qualifier with the 5 V regulator PGOOD result to generate active-high `MAIN_POWER_GOOD`.
- Sheet 03 owns four active-high requests: `OLED_POWER_REQ`, `SENSOR_POWER_REQ`, `UI_POWER_REQ`, and `EXPANSION_POWER_REQ`.
- Sheet 02 owns physical switching, 100 kΩ pull-down defaults, and main-power qualification of every request.
- `RELAY_VCC`, `MOTOR_LOGIC_5V_A/B`, and `FIELD_SENSE_VCC` are hardware-enabled main-only branches. Their presence is not actuator authorization.
- `OLED_VCC` and `SENSOR_VCC` are switched 3.3 V, `UI_VCC` is switched 5 V, `FIELD_SENSE_VCC` is hardware-enabled 5 V, and `EXPANSION_VCC` is protected switched 3.3 V with optional/DNP population.
- USB-only powers only the core/service domain. All main-only branches remain off.
- `CORE_POWER_GOOD` remains a local Sheet 03 supervisor semantic, `RESET_VALID` remains its exported timed readiness signal, and `POWER_VALID` is not added.

## Package authorization

ODI-SCH-007 is closed by ADR-039. Package 03 may resume only as **IPC-100 Rev A Preliminary KiCad Capture Package 03R — Sheet 02 Power Conversion and Rail Control Implementation Resumption**. Package 03R must implement this contract without changing the approved ports or reopening power-state policy.
