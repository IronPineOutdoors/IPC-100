# IPC-100 Reference Designator Register

| Field | Value |
| --- | --- |
| Platform | IPC-100 |
| Hardware revision | Rev A |
| Change authority | ECO-006 |
| Normalization date | 2026-07-31 |
| Physical/logical component rows | 307 |
| Final duplicate references | 0 |

Connector functional designations J1â€“J10 and J13, plus factory boundary DFT1, are intentionally preserved. `#PWR` symbols are included for traceability but are not physical BOM items. All other references use sheet-based numeric ranges.

| Old Reference | New Reference | Sheet | Component Type | Function |
| --- | --- | --- | --- | --- |
| `C1` | `C101` | 01 | `IPC100:C` | 100 nF |
| `C2` | `C102` | 01 | `IPC100:C` | 100 nF nominal; ≥70 nF effective at 55 V; ≥100 V X7R |
| `C3` | `C103` | 01 | `IPC100:C` | 22 µF nominal; ≥20 µF effective; ≥63 V low-ESR bulk; ≥0.6 A RMS |
| `C4` | `C104` | 01 | `IPC100:C` | 22 µF nominal; ≥20 µF effective; ≥63 V low-ESR bulk; ≥0.6 A RMS |
| `C5` | `C105` | 01 | `IPC100:C` | 100 nF |
| `C6` | `C106` | 01 | `IPC100:C` | 1 µF 10 V |
| `C7` | `C107` | 01 | `IPC100:C` | 10 µF 10 V |
| `C8` | `C108` | 01 | `IPC100:C` | 10 nF |
| `C9` | `C109` | 01 | `IPC100:C` | 100 nF nominal; ≥70 nF effective at 55 V; ≥100 V X7R |
| `D1` | `D101` | 01 | `IPC100:D` | SMBJ33A-class TVS (provisional) |
| `D2` | `D102` | 01 | `IPC100:D` | 4.7 V Zener |
| `D3` | `D103` | 01 | `IPC100:D` | Low-leakage ADC clamp (TBD exact) |
| `D4` | `D104` | 01 | `IPC100:D` | 5 V VBUS TVS/ESD (TBD exact) |
| `F1` | `F101` | 01 | `IPC100:FUSE` | 2 A time-delay (provisional) |
| `#PWR0101` | `#PWR0101` | 01 | `IPC100:GND` | GND |
| `#PWR0102` | `#PWR0102` | 01 | `IPC100:GND` | GND |
| `L1` | `L101` | 01 | `IPC100:L` | 10 µH, ≥3 A, ≤100 mΩ (TBD exact) |
| `Q1` | `Q101` | 01 | `IPC100:NMOS` | ≥80 V N-FET; ≤25 mΩ at actual gate drive; hot-current/SOA constrained |
| `Q2` | `Q102` | 01 | `IPC100:NMOS` | 2N7002, 60 V |
| `R1` | `R101` | 01 | `IPC100:R` | 634 kΩ 1% |
| `R10` | `R110` | 01 | `IPC100:R` | 1.00 kΩ 1% |
| `R11` | `R111` | 01 | `IPC100:R` | 100 kΩ |
| `R12` | `R112` | 01 | `IPC100:R` | 402 kΩ 1% |
| `R13` | `R113` | 01 | `IPC100:R` | 100 kΩ 1% |
| `R14` | `R114` | 01 | `IPC100:R` | 6.65 kΩ 1% |
| `R15` | `R115` | 01 | `IPC100:R` | 604 kΩ 1% |
| `R16` | `R116` | 01 | `IPC100:R` | 100 kΩ 1% |
| `R2` | `R102` | 01 | `IPC100:R` | 100 kΩ 1% |
| `R3` | `R103` | 01 | `IPC100:R` | 1.91 MΩ 1% |
| `R4` | `R104` | 01 | `IPC100:R` | 100 kΩ 1% |
| `R5` | `R105` | 01 | `IPC100:R` | 100 kΩ |
| `R6` | `R106` | 01 | `IPC100:R` | 9.09 kΩ 1% |
| `R7` | `R107` | 01 | `IPC100:R` | 49.9 kΩ 0.1% 25 ppm |
| `R8` | `R108` | 01 | `IPC100:R` | 49.9 kΩ 0.1% 25 ppm |
| `R9` | `R109` | 01 | `IPC100:R` | 10.0 kΩ 0.1% 25 ppm |
| `U2` | `U102` | 01 | `IPC100:TPS259470L` | TPS259470LRPW (provisional) |
| `U1` | `U101` | 01 | `IPC100:TPS26631_PWP` | TPS26631PWPR; verified 20-pin PWP map; PACS-01R pending |
| `C1` | `C201` | 02 | `IPC100:C` | 2.2 µF 100 V |
| `C10` | `C210` | 02 | `IPC100:C` | 10 nF soft start |
| `C11` | `C211` | 02 | `IPC100:C` | 1 nF slew control |
| `C12` | `C212` | 02 | `IPC100:C` | 4.7 µF branch local |
| `C13` | `C213` | 02 | `IPC100:C` | 1 nF slew control |
| `C14` | `C214` | 02 | `IPC100:C` | 4.7 µF branch local |
| `C15` | `C215` | 02 | `IPC100:C` | 1 nF slew control |
| `C16` | `C216` | 02 | `IPC100:C` | 4.7 µF branch local |
| `C17` | `C217` | 02 | `IPC100:C` | 4.7 µF branch local |
| `C18` | `C218` | 02 | `IPC100:C` | 1 nF slew control |
| `C19` | `C219` | 02 | `IPC100:C` | 4.7 µF branch local |
| `C2` | `C202` | 02 | `IPC100:C` | 100 nF bootstrap |
| `C20` | `C220` | 02 | `IPC100:C` | 1 nF slew control |
| `C21` | `C221` | 02 | `IPC100:C` | 4.7 µF branch local |
| `C3` | `C203` | 02 | `IPC100:C` | 22 µF 10 V |
| `C4` | `C204` | 02 | `IPC100:C` | 22 µF 10 V |
| `C5` | `C205` | 02 | `IPC100:C` | 100 nF soft start |
| `C6` | `C206` | 02 | `IPC100:C` | 47 µF 10 V mux hold-up |
| `C7` | `C207` | 02 | `IPC100:C` | 10 µF 10 V |
| `C8` | `C208` | 02 | `IPC100:C` | 22 µF 10 V |
| `C9` | `C209` | 02 | `IPC100:C` | 22 µF 10 V |
| `D1` | `D201` | 02 | `IPC100:D` | 4.7 V EN clamp |
| `D10` | `D210` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D2` | `D202` | 02 | `IPC100:D` | 3.3 V bias clamp |
| `D3` | `D203` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D4` | `D204` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D5` | `D205` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D6` | `D206` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D7` | `D207` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D8` | `D208` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `D9` | `D209` | 02 | `IPC100:D` | Schottky reverse-injection block (TBD exact) |
| `#PWR0201` | `#PWR0201` | 02 | `IPC100:GND` | GND |
| `#PWR0202` | `#PWR0202` | 02 | `IPC100:GND` | GND |
| `#PWR0203` | `#PWR0203` | 02 | `IPC100:GND` | GND |
| `#PWR0204` | `#PWR0204` | 02 | `IPC100:GND` | GND |
| `U1` | `U201` | 02 | `IPC100:IC10` | LMR38020S-Q1 — 400 kHz, spread-spectrum (provisional suffix) |
| `U10` | `U210` | 02 | `IPC100:IC10` | TPS22918-Q1 RELAY logic branch |
| `U11` | `U211` | 02 | `IPC100:IC10` | TPS22918-Q1 FIELD-SENSE branch |
| `U12` | `U212` | 02 | `IPC100:IC10` | TPS2553-Q1 100 mA motor-logic protected switch (provisional) |
| `U13` | `U213` | 02 | `IPC100:IC10` | TPS2553-Q1 100 mA motor-logic protected switch (provisional) |
| `U2` | `U202` | 02 | `IPC100:IC10` | TPS2121RUXR priority power mux |
| `U3` | `U203` | 02 | `IPC100:IC10` | TPS62130RGTR adjustable 3 A buck |
| `U4` | `U204` | 02 | `IPC100:IC10` | SN74LVC1G08-Q1 — MAIN_INPUT_VALID AND MAIN_5V_PGOOD |
| `U6` | `U206` | 02 | `IPC100:IC10` | TPS22918-Q1 OLED load switch |
| `U7` | `U207` | 02 | `IPC100:IC10` | TPS22918-Q1 SENSOR load switch |
| `U8` | `U208` | 02 | `IPC100:IC10` | TPS22918-Q1 UI load switch |
| `U9` | `U209` | 02 | `IPC100:IC10` | TPS2553-Q1 EXPANSION 100 mA protected switch — OPTIONAL/DNP |
| `L1` | `L201` | 02 | `IPC100:L` | 15 µH, ≥3.2 A Isat, ≤100 mΩ (TBD exact) |
| `L2` | `L202` | 02 | `IPC100:L` | 2.2 µH, ≥4.0 A Isat, ≤60 mΩ (TBD exact) |
| `U5` | `U205` | 02 | `IPC100:QUAL4` | SN74LVC08A-Q1 quad AND — request × MAIN_POWER_GOOD |
| `R1` | `R201` | 02 | `IPC100:R` | 40.2 kΩ 1% — 400 kHz |
| `R10` | `R210` | 02 | `IPC100:R` | 316 kΩ 0.1% |
| `R11` | `R211` | 02 | `IPC100:R` | 100 kΩ 0.1% |
| `R12` | `R212` | 02 | `IPC100:R` | 100 kΩ enable |
| `R13` | `R213` | 02 | `IPC100:R` | 10 kΩ PGOOD pull-up |
| `R14` | `R214` | 02 | `IPC100:R` | 100 kΩ fail-low |
| `R15` | `R215` | 02 | `IPC100:R` | 10 kΩ main-bias pull-up |
| `R16` | `R216` | 02 | `IPC100:R` | 100 kΩ bias feed |
| `R17` | `R217` | 02 | `IPC100:R` | 10 kΩ PGOOD pull-up |
| `R18` | `R218` | 02 | `IPC100:R` | 100 kΩ fail-low |
| `R19` | `R219` | 02 | `IPC100:R` | 100 kΩ fail-low |
| `R2` | `R202` | 02 | `IPC100:R` | 100 kΩ 0.1% |
| `R20` | `R220` | 02 | `IPC100:R` | 100 kΩ fail-low |
| `R21` | `R221` | 02 | `IPC100:R` | 100 kΩ fail-low |
| `R22` | `R222` | 02 | `IPC100:R` | 287 kΩ 1% — 100 mA target (verify) |
| `R23` | `R223` | 02 | `IPC100:R` | 287 kΩ 1% — 100 mA target (verify) |
| `R24` | `R224` | 02 | `IPC100:R` | 287 kΩ 1% — 100 mA target (verify) |
| `R25` | `R225` | 02 | `IPC100:R` | 1 kΩ QOD limit |
| `R26` | `R226` | 02 | `IPC100:R` | 1 kΩ QOD limit |
| `R27` | `R227` | 02 | `IPC100:R` | 1 kΩ QOD limit |
| `R28` | `R228` | 02 | `IPC100:R` | 1 kΩ QOD limit |
| `R29` | `R229` | 02 | `IPC100:R` | 1 kΩ QOD limit |
| `R3` | `R203` | 02 | `IPC100:R` | 24.9 kΩ 0.1% |
| `R30` | `R230` | 02 | `IPC100:R` | 23.7 kΩ 1% — USB OV2 |
| `R31` | `R231` | 02 | `IPC100:R` | 5.00 kΩ 1% |
| `R4` | `R204` | 02 | `IPC100:R` | 100 kΩ |
| `R5` | `R205` | 02 | `IPC100:R` | 10.2 kΩ 1% |
| `R6` | `R206` | 02 | `IPC100:R` | 5.00 kΩ 1% |
| `R7` | `R207` | 02 | `IPC100:R` | 23.7 kΩ 1% |
| `R8` | `R208` | 02 | `IPC100:R` | 5.00 kΩ 1% |
| `R9` | `R209` | 02 | `IPC100:R` | 60.4 kΩ 1% — ≈2 A limit (verify) |
| `C1` | `C301` | 03 | `IPC100:C` | 22 µF effective bulk |
| `C2` | `C302` | 03 | `IPC100:C` | 1 µF X7R |
| `C3` | `C303` | 03 | `IPC100:C` | 100 nF X7R |
| `C4` | `C304` | 03 | `IPC100:C` | 1 µF EN RC starting value |
| `C5` | `C305` | 03 | `IPC100:C` | 93.1 nF ±1% C0G/NP0 ≥10 V; CT; 99.642 ms nominal; leakage ≤10 nA; -40..125 C |
| `C6` | `C306` | 03 | `IPC100:C` | 100 nF supervisor bypass |
| `U1` | `U301` | 03 | `IPC100:ESP32S3WROOM1` | ESP32-S3-WROOM-1-N8 |
| `R1` | `R301` | 03 | `IPC100:R` | 10 kΩ EN/reset pull-up |
| `R2` | `R302` | 03 | `IPC100:R` | 10 kΩ GPIO0 boot pull-up |
| `R3` | `R303` | 03 | `IPC100:R` | 22 Ω USB D- tuning |
| `R4` | `R304` | 03 | `IPC100:R` | 22 Ω USB D+ tuning |
| `R5` | `R305` | 03 | `IPC100:R` | 499 Ω UART0 TX EMC series |
| `SW1` | `SW301` | 03 | `IPC100:SW` | RESET — momentary NO |
| `SW2` | `SW302` | 03 | `IPC100:SW` | BOOT — momentary NO |
| `U3` | `U303` | 03 | `IPC100:TPD2EUSB30` | TPD2EUSB30 low-capacitance ESD boundary |
| `U2` | `U302` | 03 | `IPC100:TPS3890` | TPS389030-Q1 2.89 V typ / 100 ms target |
| `C1` | `C401` | 04 | `IPC100:C` | 100 nF X7R 10 V |
| `C10` | `C410` | 04 | `IPC100:C` | 100 nF X7R LM339B-Q1 local bypass |
| `C11` | `C411` | 04 | `IPC100:C` | 100 nF X7R LM339B-Q1 local bypass |
| `C12` | `C412` | 04 | `IPC100:C` | 100 nF X7R LM339B-Q1 local bypass |
| `C13` | `C413` | 04 | `IPC100:C` | 1 µF X7R local logic bulk |
| `C2` | `C402` | 04 | `IPC100:C` | 100 nF X7R 10 V |
| `C3` | `C403` | 04 | `IPC100:C` | 100 nF X7R/C0G, τ=100 µs |
| `C4` | `C404` | 04 | `IPC100:C` | 100 nF X7R/C0G, τ=100 µs |
| `C5` | `C405` | 04 | `IPC100:C` | 100 nF X7R/C0G, τ=100 µs |
| `C6` | `C406` | 04 | `IPC100:C` | 100 nF X7R/C0G, τ=100 µs |
| `C7` | `C407` | 04 | `IPC100:C` | 100 nF X7R/C0G, τ=100 µs |
| `C8` | `C408` | 04 | `IPC100:C` | 100 nF X7R, τ=100 µs |
| `C9` | `C409` | 04 | `IPC100:C` | 100 nF X7R, τ=100 µs |
| `U3C` | `U403C` | 04 | `IPC100:CMDREC` | LM339B-Q1 low-active receiver + FIELD_OK gate |
| `U3D` | `U403D` | 04 | `IPC100:CMDREC` | LM339B-Q1 low-active receiver + FIELD_OK gate |
| `D1` | `D401` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `D2` | `D402` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `D3` | `D403` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `D4` | `D404` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `D5` | `D405` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `D6` | `D406` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `D7` | `D407` | 04 | `IPC100:D` | TPD4E05U06 channel / low-cap ESD clamp |
| `U4` | `U404` | 04 | `IPC100:FIELDDET` | SN74LVC1G17-Q1 FIELD_SENSE detector, fail low |
| `R1` | `R401` | 04 | `IPC100:R` | 10.0 kΩ ±0.1% threshold ladder |
| `R10` | `R410` | 04 | `IPC100:R` | 2.20 kΩ ±1% loop excitation |
| `R11` | `R411` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `R12` | `R412` | 04 | `IPC100:R` | 2.20 kΩ ±1% loop excitation |
| `R13` | `R413` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `R14` | `R414` | 04 | `IPC100:R` | 2.20 kΩ ±1% loop excitation |
| `R15` | `R415` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `R16` | `R416` | 04 | `IPC100:R` | 2.20 kΩ ±1% loop excitation |
| `R17` | `R417` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `R18` | `R418` | 04 | `IPC100:R` | 100 kΩ fail-high bias |
| `R19` | `R419` | 04 | `IPC100:R` | 10.0 kΩ ±1% main-only wetting/bias |
| `R2` | `R402` | 04 | `IPC100:R` | 10.0 kΩ ±0.1% |
| `R20` | `R420` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `R21` | `R421` | 04 | `IPC100:R` | 100 kΩ deterministic field-off pull-down |
| `R22` | `R422` | 04 | `IPC100:R` | 10.0 kΩ ±1% main-only wetting/bias |
| `R23` | `R423` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `R24` | `R424` | 04 | `IPC100:R` | 100 kΩ deterministic field-off pull-down |
| `R3` | `R403` | 04 | `IPC100:R` | 10.0 kΩ ±0.1% |
| `R4` | `R404` | 04 | `IPC100:R` | 10.0 kΩ ±0.1% |
| `R5` | `R405` | 04 | `IPC100:R` | 10.0 kΩ ±0.1% |
| `R6` | `R406` | 04 | `IPC100:R` | 10.0 kΩ ±1% field detector top |
| `R7` | `R407` | 04 | `IPC100:R` | 20.0 kΩ ±1% field detector bottom |
| `R8` | `R408` | 04 | `IPC100:R` | 2.20 kΩ ±1% loop excitation |
| `R9` | `R409` | 04 | `IPC100:R` | 1.00 kΩ ±1% protected series |
| `U5` | `U405` | 04 | `IPC100:SAFEBUF` | SN74LVC1G17-Q1 STOP hardware export; passive fail-high bias |
| `U1AB` | `U401AB` | 04 | `IPC100:WINDOW` | LM339B-Q1 dual threshold + SN74LVC14A-Q1 combine |
| `U1CD` | `U401CD` | 04 | `IPC100:WINDOW` | LM339B-Q1 dual threshold + SN74LVC14A-Q1 combine |
| `U2AB` | `U402AB` | 04 | `IPC100:WINDOW` | LM339B-Q1 dual threshold + SN74LVC14A-Q1 combine |
| `U2CD` | `U402CD` | 04 | `IPC100:WINDOW` | LM339B-Q1 dual threshold + SN74LVC14A-Q1 combine |
| `U3AB` | `U403AB` | 04 | `IPC100:WINDOW` | LM339B-Q1 dual threshold + SN74LVC14A-Q1 combine |
| `U3` | `U503` | 05 | `IPC100:AUTH2` | SN74LVC-Q1: EN = PERMIT AND NOT INHIBIT; disagreement disables |
| `C1` | `C501` | 05 | `IPC100:C` | 100 nF X7R VCCA bypass |
| `C2` | `C502` | 05 | `IPC100:C` | 100 nF X7R VCCB bypass |
| `C3` | `C503` | 05 | `IPC100:C` | 1 µF X7R local interface bulk |
| `C4` | `C504` | 05 | `IPC100:C` | 100 nF X7R VCCA bypass |
| `C5` | `C505` | 05 | `IPC100:C` | 100 nF X7R VCCB bypass |
| `C6` | `C506` | 05 | `IPC100:C` | 1 µF X7R local interface bulk |
| `D1` | `D501` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D2` | `D502` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D3` | `D503` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D4` | `D504` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D5` | `D505` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D6` | `D506` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D7` | `D507` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `D8` | `D508` | 05 | `IPC100:D` | TPD4E05U06 channel / connector-entry ESD provision |
| `U1` | `U501` | 05 | `IPC100:INTERLOCK4` | SN74LVC-Q1: R_OK = RPWM AND NOT LPWM; L_OK = LPWM AND NOT RPWM; enables pass |
| `U2` | `U502` | 05 | `IPC100:INTERLOCK4` | SN74LVC-Q1: R_OK = RPWM AND NOT LPWM; L_OK = LPWM AND NOT RPWM; enables pass |
| `R1` | `R501` | 05 | `IPC100:R` | 100 kΩ authorization default off |
| `R10` | `R510` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R11` | `R511` | 05 | `IPC100:R` | 33 Ω series damping |
| `R12` | `R512` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R13` | `R513` | 05 | `IPC100:R` | 33 Ω series damping |
| `R14` | `R514` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R15` | `R515` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R16` | `R516` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R17` | `R517` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R18` | `R518` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R19` | `R519` | 05 | `IPC100:R` | 33 Ω series damping |
| `R2` | `R502` | 05 | `IPC100:R` | 100 kΩ authorization default off |
| `R20` | `R520` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R21` | `R521` | 05 | `IPC100:R` | 33 Ω series damping |
| `R22` | `R522` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R23` | `R523` | 05 | `IPC100:R` | 33 Ω series damping |
| `R24` | `R524` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R25` | `R525` | 05 | `IPC100:R` | 33 Ω series damping |
| `R26` | `R526` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R27` | `R527` | 05 | `IPC100:R` | 100 kΩ U503 PERMIT fail-low input bias |
| `R28` | `R528` | 05 | `IPC100:R` | 100 kΩ U503 INHIBIT fail-high input bias |
| `R3` | `R503` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R4` | `R504` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R5` | `R505` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R6` | `R506` | 05 | `IPC100:R` | 47 kΩ MCU-side inactive default |
| `R7` | `R507` | 05 | `IPC100:R` | 33 Ω series damping |
| `R8` | `R508` | 05 | `IPC100:R` | 10 kΩ safe-side inactive default |
| `R9` | `R509` | 05 | `IPC100:R` | 33 Ω series damping |
| `U4` | `U504` | 05 | `IPC100:XLAT4` | SN74LXC4T245-class Axis 1; A→B, Ioff |
| `U5` | `U505` | 05 | `IPC100:XLAT4` | SN74LXC4T245-class Axis 2; A→B, Ioff |
| `U3` | `U603` | 06 | `IPC100:AND2` | RELAY_CMD_MCU AND ACTUATOR_PERMIT |
| `U2` | `U602` | 06 | `IPC100:AUTH4` | Fail-safe four-condition authorization logic |
| `C1` | `C601` | 06 | `IPC100:C` | Timing capacitor — value set from selected watchdog equation |
| `D1` | `D601` | 06 | `IPC100:FLYBACK_CLAMP` | Schottky + 12 V / 500 mW zener series flyback clamp |
| `Q1` | `Q601` | 06 | `IPC100:NMOS` | 2N7002P-class, 60 V logic N-MOSFET |
| `R1` | `R601` | 06 | `IPC100:R` | 100 kΩ WDI fail-low / open-route bias |
| `R10` | `R610` | 06 | `IPC100:R` | 100 kΩ MASTER_INHIBIT fail-high |
| `R2` | `R602` | 06 | `IPC100:R` | 100 Ω gate resistor |
| `R3` | `R603` | 06 | `IPC100:R` | 100 kΩ MOSFET gate default-OFF bias |
| `R4` | `R604` | 06 | `IPC100:R` | 100 kΩ MAIN_POWER_GOOD fail-low |
| `R5` | `R605` | 06 | `IPC100:R` | 100 kΩ RESET_VALID fail-low |
| `R6` | `R606` | 06 | `IPC100:R` | 100 kΩ STOP_HW_INHIBIT fail-high |
| `R7` | `R607` | 06 | `IPC100:R` | 100 kΩ RELAY_CMD_MCU fail-low |
| `R8` | `R608` | 06 | `IPC100:R` | 100 kΩ WATCHDOG_VALID fail-low |
| `R9` | `R609` | 06 | `IPC100:R` | 100 kΩ ACTUATOR_PERMIT fail-low |
| `K1` | `K601` | 06 | `IPC100:RELAY_SPDT` | Omron G5Q-1 DC5-class, 5 V / 80 mA provisional |
| `U1` | `U601` | 06 | `IPC100:WINDOW_WATCHDOG` | Independent window watchdog + 2-edge qualifier/latch, 250 ms max |
| `C1` | `C701` | 07 | `IPC100:C` | 100 nF X7R ±10% expander reset delay |
| `U1` | `U701` | 07 | `IPC100:ENCODER_CONDITIONER3` | 3ch active-low panel encoder conditioner; 10k/1k/10nF; UI-valid gated |
| `U2` | `U702` | 07 | `IPC100:I2C_EXPANDER` | TCA9535-class, +3V3_CORE, address 0x20, power-up inputs/high-Z |
| `U4` | `U704` | 07 | `IPC100:I2C_PERIPHERAL_BOUNDARY` | 2.42-inch SSD1309 OLED reference; exact module/J6 deferred |
| `U5` | `U705` | 07 | `IPC100:I2C_PERIPHERAL_BOUNDARY` | BME280 environmental sensor reference; exact module/J7 deferred |
| `U6` | `U706` | 07 | `IPC100:I2C_DUAL_SUPPLY_BUFFER_EN` | One physical dual-supply J6 I2C buffer; branch-powered EN; fail-isolated |
| `U7` | `U707` | 07 | `IPC100:I2C_DUAL_SUPPLY_BUFFER_EN` | One physical dual-supply J7 I2C buffer; branch-powered EN; fail-isolated |
| `Q1` | `Q701` | 07 | `IPC100:OLED_RESET_OD` | 2N7002-class open-drain reset; 100k core pull-up asserts reset by default |
| `R1` | `R701` | 07 | `IPC100:R` | 100 kΩ ±1% expander reset pull-up |
| `R2` | `R702` | 07 | `IPC100:R` | 4.70 kΩ ±1% I2C SDA pull-up; Sheet 07 base-bus owner |
| `R3` | `R703` | 07 | `IPC100:R` | 4.70 kΩ ±1% I2C SCL pull-up; Sheet 07 base-bus owner |
| `ECO-006 added` | `C702` | 07 | `IPC100:C` | 100 nF U706 core-side bypass |
| `ECO-006 added` | `C703` | 07 | `IPC100:C` | 100 nF U706 branch-side bypass |
| `ECO-006 added` | `C704` | 07 | `IPC100:C` | 100 nF U707 core-side bypass |
| `ECO-006 added` | `C705` | 07 | `IPC100:C` | 100 nF U707 branch-side bypass |
| `ECO-006 added` | `R704` | 07 | `IPC100:R` | 100 kΩ OLED buffer enable fail-low bias |
| `ECO-006 added` | `R705` | 07 | `IPC100:R` | 100 kΩ sensor buffer enable fail-low bias |
| `U3` | `U703` | 07 | `IPC100:STATUS_DRIVER4` | 4x 60 V logic NMOS; 100Ω gates; 100kΩ gate pull-downs; buzzer clamp provision |
| `TP1` | `TP701` | 07 | `IPC100:TEST_NODE` | UI_VCC DFT node |
| `TP2` | `TP702` | 07 | `IPC100:TEST_NODE` | OLED_VCC DFT node |
| `TP3` | `TP703` | 07 | `IPC100:TEST_NODE` | I2C_SDA DFT node |
| `TP4` | `TP704` | 07 | `IPC100:TEST_NODE` | I2C_SCL DFT node |
| `TP5` | `TP705` | 07 | `IPC100:TEST_NODE` | ENCODER_A_COND DFT node |
| `C1` | `C801` | 08 | `IPC100:C` | 100 nF X7R ±10% local buffer decoupling |
| `C2` | `C802` | 08 | `IPC100:C` | 10 µF X7R accessory-bias reservoir; within ICD-001 22 µF load cap limit |
| `C3` | `C803` | 08 | `IPC100:C` | 100 nF X7R ±10% core-side buffer decoupling |
| `ECO-007 added` | `C804` | 08 | `IPC100:C` | 100 nF X7R ±10% U801 VDD bypass |
| `ECO-007 added` | `R806` | 08 | `IPC100:R` | 150 kΩ ±0.1% expansion-to-SENSE series resistor |
| `ECO-007 added; ECO-010 revised` | `R808` | 08 | `IPC100:R` | 1.30 MΩ ±0.1% TPS3899 valid-output hysteresis feedback |
| `ECO-010 added` | `R807` | 08 | `IPC100:R` | 31.6 kΩ ±0.1% TPS3899 SENSE lower divider |
| `ECO-010 added` | `R809` | 08 | `IPC100:R` | 4.70 kΩ open-drain valid-output pull-up |
| `ECO-010 added` | `C805` | 08 | `IPC100:C` | 10 nF TPS3899 CTR; 6.2 ms nominal release delay |
| `D1` | `D801` | 08 | `IPC100:ESD_PROVISION` | J10 SDA low-capacitance TVS provision; IEC 61000-4-2 target |
| `D2` | `D802` | 08 | `IPC100:ESD_PROVISION` | J10 SCL low-capacitance TVS provision; IEC 61000-4-2 target |
| `D3` | `D803` | 08 | `IPC100:ESD_PROVISION` | EXPANSION_VCC local ESD/reverse-injection provision; final part coordinated with Sheet 09 |
| `U1` | `U801` | 08 | `IPC100:TPS3899DL01` | TPS3899DL01 adjustable supervisor; open-drain active-low reset used as valid-high enable |
| `FB1` | `FB801` | 08 | `IPC100:FERRITE` | Accessory-bias filter bead — impedance/current rating pending protection part selection |
| `U2` | `U802` | 08 | `IPC100:I2C_SEGMENT_BUFFER` | Dual-supply I2C hot-swap buffer; 100 kHz; fail-disabled; no clock stretching |
| `R1` | `R801` | 08 | `IPC100:R` | 100 kΩ ±1% segment-enable fail-low bias |
| `R2` | `R802` | 08 | `IPC100:R` | 4.70 kΩ ±1% J10 SDA pull-up; Sheet 08 external-segment owner |
| `R3` | `R803` | 08 | `IPC100:R` | 4.70 kΩ ±1% J10 SCL pull-up; Sheet 08 external-segment owner |
| `R4` | `R804` | 08 | `IPC100:R` | 47 Ω J10 SDA series damping; final 33–100 Ω by SI verification |
| `R5` | `R805` | 08 | `IPC100:R` | 47 Ω J10 SCL series damping; final 33–100 Ω by SI verification |
| `TP1` | `TP801` | 08 | `IPC100:TEST_NODE` | EXPANSION_VCC DFT |
| `TP2` | `TP802` | 08 | `IPC100:TEST_NODE` | SEGMENT_ENABLE DFT |
| `TP3` | `TP803` | 08 | `IPC100:TEST_NODE` | INTERNAL SDA DFT |
| `TP4` | `TP804` | 08 | `IPC100:TEST_NODE` | INTERNAL SCL DFT |
| `TP5` | `TP805` | 08 | `IPC100:TEST_NODE` | J10 SDA DFT |
| `TP6` | `TP806` | 08 | `IPC100:TEST_NODE` | J10 SCL DFT |
| `C1` | `C901` | 09 | `IPC100:C` | DNP 1 nF >=1 kV shield coupling option |
| `J8B` | `J8B` | 09 | `IPC100:CONN12` | L1/H08B ordinary UI; incompatible with J8A |
| `J1` | `J1` | 09 | `IPC100:CONN2` | P1/H01 controller input |
| `J8A` | `J8A` | 09 | `IPC100:CONN2` | S1/H08A dedicated STOP; unique key |
| `J9` | `J9` | 09 | `IPC100:CONN3` | R1/H09 SELV dry contact; 0-30VDC 1A |
| `J10` | `J10` | 09 | `IPC100:CONN4` | D1/H10 ICD-001 optional DNP; no live mate |
| `J4` | `J4` | 09 | `IPC100:CONN4` | S1/H04 LEFT-RIGHT limits |
| `J5` | `J5` | 09 | `IPC100:CONN4` | S1/H05 UP-DOWN limits |
| `J7` | `J7` | 09 | `IPC100:CONN4` | D1/H07 BME280; 0.20m; no live mate |
| `J6` | `J6` | 09 | `IPC100:CONN5` | D1/H06 OLED; 0.20m; no live mate |
| `DFT1` | `DFT1` | 09 | `IPC100:CONN6` | T1 factory pogo logical boundary; not populated |
| `J2` | `J2` | 09 | `IPC100:CONN6` | M1/H02 Axis 1 logic |
| `J3` | `J3` | 09 | `IPC100:CONN6` | M1/H03 Axis 2 logic |
| `R1` | `R901` | 09 | `IPC100:R` | 5.1 kΩ ±1% CC1 Rd |
| `R2` | `R902` | 09 | `IPC100:R` | 5.1 kΩ ±1% CC2 Rd |
| `R3` | `R903` | 09 | `IPC100:R` | DNP 1 MOhm shield bleed option |
| `J13` | `J13` | 09 | `IPC100:USB_C_UFP_FULL` | U1/H13 USB2 device-UFP; full 24 contacts + shell |
| `D1` | `D901` | 09 | `IPC100:USB_ESD2` | USB2 ESD: >=5.5V, IEC 61000-4-2, <=1pF/ch, <=100nA |
| `D2` | `D902` | 09 | `IPC100:VBUS_ESD` | VBUS ESD: 5V working, IEC 61000-4-2; no PD voltage assumed |
