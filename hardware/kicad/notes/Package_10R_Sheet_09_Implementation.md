# Package 10R — Sheet 09 External Connectors and Harness Interface

## 1. Scope

Implements the ICD-002 Rev A physical boundaries on Sheet 09 only. No final connector family, MPN, footprint, PCB work, GPIO, bus, rail, safety role, or signal ownership is added.

## 2. Authoritative Documents

ICD-001, ICD-002, ECO-003, ADR-039 through ADR-044, MFG-01, the safety/motion interface documents, and the frozen hierarchy control this capture.

## 3. Connector Inventory

| Boundary | Class | Harness | Status |
| --- | --- | --- | --- |
| J1 | P1 | H01 | 2-pin controller input |
| J2/J3 | M1 | H02/H03 | 6-pin external-driver logic |
| J4/J5 | S1 | H04/H05 | 4-pin independent supervised loops |
| J6/J7 | D1 | H06/H07 | 5-pin OLED / 4-pin sensor |
| J8A/J8B | S1/L1 | H08A/H08B | 2-pin STOP / 12-pin ordinary UI |
| J9 | R1 | H09 | 3-pin isolated SELV dry contact |
| J10 | D1 | H10 | 4-pin optional/DNP expansion |
| J11/J12 | None | None | Documentation-only; no symbol/pads |
| J13 | U1 | H13 | USB 2.0 device/UFP grouped contacts |
| DFT1 | T1 | Fixture | Factory pogo logical boundary; not populated |

## 4. Master Port-to-Pin Mapping

Physical: J1=`VIN_RAW`; J2=`MOTOR_LOGIC_5V_A` plus four Axis1 `_SAFE`; J3=equivalent Axis2; J4/J5=eight limit raw/return nets; J6=`OLED_VCC`, `J6_I2C_SDA/SCL`, `OLED_RESET`; J7=`SENSOR_VCC`, `J7_I2C_SDA/SCL`; J8A=`STOP_IN_RAW/STOP_RETURN`; J8B=`+3V3_CORE`, `UI_VCC`, ARM/FIRE, encoder A/B/SW, RGB R/G/B, buzzer; J9=relay NC/COM/NO; J10=`EXPANSION_VCC`, `J10_I2C_SDA/SCL`; J13=`USB_VBUS_RAW`, USB D+/D-; DFT1=UART TX/RX, EN, BOOT, ground, and sense-only 3V3. Ground contacts use local `GND`.

Documentation/test-only observations retain explicit non-connector disposition: `+5V_MAIN`, `VIN_PROTECTED`, `USB_5V_PROTECTED`, `CORE_SOURCE`, `BATTERY_SENSE`, and `MAIN_POWER_GOOD`. This accounts for all 54 frozen ports plus four ECO-003 ports.

## 5. Connector Pin Tables

Pin order is encoded on Sheet 09 and follows ICD-002. USB-C duplicated VBUS and USB2 data contacts are grouped; unused logical group 12 is intentionally no-connect. J11/J12 have no electrical pin table.

## 6. Connector Performance Classes

P1, M1, S1, D1, L1, R1, U1, and T1 retain the quantitative minimums in ICD-002 Section 10. Generic symbols are not procurement releases.

## 7. Harness Inventory

H01–H10 and H13 retain ICD-002 Section 8 conductor counts, lengths, gauges, voltage/current/peak classes, routing, strain relief, bend radius, abrasion, shielding, and mating restrictions. All are **PRELIMINARY — SUBJECT TO BOM, CONNECTOR, THERMAL, VOLTAGE-DROP, AND PROTOTYPE VALIDATION**.

## 8. J6/J7 I2C Implementation

Only the four ECO-003 names are used. No Sheet 09 pull-up, buffer, isolator, or termination is added. Sheet 07 ownership, 100 kHz, addresses 0x3C/0x76, 0.20 m/50 pF branch limits, no clock stretching, and no live mating remain frozen.

## 9. J8 STOP/UI Partition

J8A contains only the supervised STOP pair. J8B contains ordinary UI. Unique incompatible keying, distinct harnesses/labels, and separate routing are mandatory; returns are never recombined.

## 10. J9 Load Interface

J9 is 0–30 VDC SELV, 1 A continuous resistive, 2 A/100 ms, 20 AWG full-envelope, 3 m maximum. Unsuppressed inductive loads and opening them under load are prohibited. External source/suppression owns the load.

## 11. J10 Expansion Interface

Optional/DNP, 3.3 V/100 mA, segmented 100 kHz I2C, one accessory, 0.30 m, addresses 0x30–0x37, no stretching/live mate. Sheet 08 protection and external pull-ups are not duplicated.

## 12. J13 USB-C Service Interface

USB 2.0 device/UFP only; no PD, host, source, charging, alternate mode, or VCONN. CC1/CC2 each receive 5.1 kΩ ±1% Rd. VBUS is input-only and hardware-capped upstream at 500 mA. Connector-entry low-capacitance USB ESD and shield bond/capacitive options are mandatory PCB/BOM release provisions; exact devices remain open and no duplicate processor-side array is permitted.

## 13. Manufacturing Fixture Boundary

DFT1 is a nonpopulated T1 pogo boundary for UART0 TX/RX, EN, BOOT, GND, and sense-only 3V3. Ground first/last; fixture drive is current-limited, EN/BOOT open-drain-low only, and the fixture never sources 3V3.

## 14. J11/J12 Documentation-Only Disposition

J11 spare GPIO and J12 CAN/RS485 remain Rev A documentation-only concepts with no symbol, pads, harness, footprint, or connectivity. GPIO37 remains reserved.

## 15. Ground, Shield, and Shell Treatment

Logic/power `GND`, supervised returns, isolated J9 contacts, and `USB_SHIELD` stay distinct. Shield never carries load current. USB direct chassis, DNP 0 Ω, and DNP 1 nF/1 MΩ options remain exact enclosure/EMC release choices; no speculative chassis net is added.

## 16. Protection Ownership

Sheets 01–08 retain current limit, reverse protection, filtering, pull-ups, isolation, default bias, flyback, and functional ESD ownership. Sheet 09 owns connector-local USB ESD placement, CC Rd, physical keying, and harness notes. Cable/accessory/product owns environmental sealing and external suppression where ICD-002 assigns it.

## 17. DFM/DFT Provisions

All field interfaces require released keying/locking/sealing; J8A/J8B must be incompatible. Power-off mating applies except J13. Inspection controls pin 1/orientation; harness continuity tests every conductor and isolation boundary. No footprint is assigned.

## 18. Failure-Mode Review

Unplug/open defaults inactive; supervised-loop opens fault safe. Partial/wrong/reverse mating is controlled by keying and labels. Adjacent shorts rely on owning-sheet limits/protection and cannot create authorization. Ground/shield opens, ingress, corrosion, strain failure, excess length/gauge, address collision, externally powered J10/J6/J7, J9 opening under load, USB dual-source insertion, and fixture misalignment remain explicit prototype/manufacturing tests. No connector fault directly creates actuator authorization.

## 19. Validation Results

Repository hierarchy, GPIO, ICD-002 54+4 accounting, S-expression, UUID/reference uniqueness, zero-footprint, and diff checks pass. Twelve J-symbols plus DFT1 and two CC resistors are captured. No PCB or ADR changed.

## 20. Remaining Release Gates

Exact connector/ESD/shield parts, BOM/AVL, footprints, enclosure/sealing, thermal/voltage drop, USB SI/EMC, contact/relay life, harness procurement, mechanical keying, and prototype fault testing remain open.

## 21. Native ERC Status

Native ERC remains pending because `kicad-cli` is unavailable. Structural validation is not represented as ERC completion.

## 22. Manual Review Checklist

- [x] 54 frozen plus four ECO-003 ports accounted
- [x] 11 designation groups retain ICD-002 disposition
- [x] J8 split; J10 DNP; J11/J12 documentation-only
- [x] GPIO37 reserved; GPIO42 unchanged
- [x] No raw GPIO, new bus/rail/safety signal, footprint, or PCB work
- [ ] Native ERC and exact-part release review

## Final Decision

**PACKAGE 10R COMPLETE — READY FOR SSR-01**
