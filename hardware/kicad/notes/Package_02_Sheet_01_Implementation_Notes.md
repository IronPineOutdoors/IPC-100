# Package 02 — Sheet 01 Implementation Notes

## Scope

This note records implementation assumptions for IPC-100 Rev A Preliminary KiCad Capture Package 02. It does not change the approved platform architecture. Only Sheet 01, Power Entry and Protection, is implemented.

## Preliminary selections

- U1 is represented as the adjustable-overvoltage TPS26630 member of the approved TPS2663 family. Its adjustable cutoff and one-times active current-limit behavior match the quantified architecture. The exact orderable suffix remains a release item.
- U1 programming uses 634 kΩ / 100 kΩ for approximately 8.81 V rising UVLO, 1.91 MΩ / 100 kΩ for approximately 24.12 V OVLO, 9.09 kΩ for approximately 2.0 A current limit, and 100 nF for an approximately 19–44 ms output rise over the 9–21 V operating range.
- U1 MODE is intentionally open for latch-off behavior. IMON is intentionally unused. SHDN uses a preliminary 100 kΩ feed and 4.7 V shunt clamp to provide bounded always-on enable bias.
- U1 PGTH uses 604 kΩ / 100 kΩ to monitor the pre-filter protected output at approximately 8 V.
- U2 is represented as TPS259470LRPW, the adjustable-overvoltage, latch-off member of the approved TPS25947 family. A 6.65 kΩ ILM resistor sets 500 mA nominal current limiting; 402 kΩ / 100 kΩ sets approximately 6.0 V OVLO.
- `POWER_FAULT_SUMMARY` is U1 `FLT`, open-drain and active low. Its pull-up and logic qualification remain owned by Sheet 06. USB eFuse fault and main-input power-good signals remain local open-drain diagnostic nets in this package.
- The battery divider implements two series 49.9 kΩ, 0.1%, 25 ppm upper resistors and a 10.0 kΩ, 0.1%, 25 ppm lower resistor, with 100 nF filtering and 1.00 kΩ ADC isolation. The shown low-leakage clamp is provisional and may only be populated after its leakage error is included in the measurement budget.

## Release blockers retained

The preliminary schematic intentionally leaves footprints unassigned. Exact TVS pulse energy, reverse MOSFET orderable part and SOA, eFuse thermal margins, filter magnetics, capacitor bias/derating, protection-device leakage, tolerance analysis, and transient simulation must close before schematic release or PCB-layout entry.

## Expected ERC disposition

Hierarchical ports are synchronized with Sheet 00. Intentional no-connect markers are used for U1 MODE and IMON and U2 AUXOFF. Open-drain diagnostic nets deliberately have no local pull-up. KiCad ERC could not be executed because KiCad is not installed in the current environment; repository structural validation is the available check.
