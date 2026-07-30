# IPC-100 Rev A

Initial project creation.

- Refactored repository boundaries to separate the reusable IPC-100 platform from CrossWind product-specific development.
- Completed the initial IPC-100 Rev A Engineering Blueprint for architecture and requirements review.
- Expanded the Engineering Blueprint with platform vision, scope boundaries, design principles, and functional and non-functional requirements.
- Incorporated the approved Platform and Power requirements review, including normal-input scope, source neutrality, preliminary input-path capability, USB backfeed, and battery-measurement requirements.
- Incorporated the approved Processor and Communications review, retaining the ESP32 family while deferring module, GPIO, memory, USB, CAN, and RS485 implementation choices.
- Incorporated the approved Display and Sensors review, defining product-neutral capabilities, nonfatal peripheral faults, and controlled shared-I2C requirements.
- Created the Rev A critical-component selection and electrical-quantification package and conditionally authorized preliminary KiCad capture while retaining schematic-release and PCB-layout blockers.
- Created the IPC-100 KiCad project, Sheet 00 top-level architecture, and empty port-complete Sheets 01–09 for Preliminary KiCad Capture Package 01.
- Implemented Preliminary KiCad Capture Package 02, Sheet 01 Power Entry and Protection, without footprints or downstream power conversion.
- Paused Package 03 before schematic modification after identifying the missing Sheet 02 enable-request and upstream main-valid interfaces; documented the architecture entry-gate blocker.
- Completed Power-Control Interface Resolution AR-01, accepted ADR-039, synchronized Sheets 00–03, closed ODI-SCH-007, and authorized Package 03R.
- Implemented Package 03R Sheet 02 preliminary power conversion, source selection, power-good qualification, and protected branch control without footprints.
- Paused Package 04 before Sheet 03 modification because ADR-039's four power-request outputs lack approved GPIO assignments and the requested status/USB boundaries conflict with the frozen hierarchy.
