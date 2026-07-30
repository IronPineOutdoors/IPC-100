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
- Completed Architecture Resolution Package AR-02 and accepted ADR-040, assigning all ESP32-S3 GPIOs, resolving status and USB ownership, reserving a future two-pin communications pool, and authorizing Package 04R.
- Paused Package 04R before Sheet 03 modification because retained input `MAIN_POWER_GOOD` has no assigned GPIO or other approved Sheet 03 consumer under the fully allocated ADR-040 map.
- Completed Architecture Resolution Package AR-03 and accepted ADR-041, removing firmware visibility of `MAIN_POWER_GOOD` while preserving Sheet 02 branch gating, Sheet 06 actuator authorization, all GPIO assignments, and USB-only recovery.
- Implemented Package 04R Sheet 03 ESP32-S3 core, supervision/reset, boot recovery, MCU-side USB, UART0 recovery, and ADR-040 GPIO fanout without connectors, footprints, or application circuitry.
- Paused Package 05 before Sheet 04 modification because authoritative safety-input contracts remain unsynchronized and the diagnostic fault-net consumer/GPIO contract is unresolved; recorded the required AR-04 scope.
- Completed AR-04 and accepted ADR-042, freezing the Rev A external field-input, contact, polarity, fault, timing, power-domain, and actuator-permission contract and authorizing Package 05R without schematic or GPIO changes.
- Implemented Package 05R Sheet 04 with five 5 V supervised NC safety loops, protected and field-gated ARM/FIRE conditioning, active-high conservative processor outputs, local-only electrical diagnostics, and an independent STOP hardware-inhibit export.
- Paused Package 06 before Sheet 05 modification because its PAN/TILT, position-feedback, direct-STOP, diagnostic, and Sheet 06 consumer requests conflict with the frozen Rev A eight-channel external motor-driver interface; recorded AR-05 alignment scope.
- Completed AR-05 and accepted ADR-043, freezing the eight-command two-axis motion interface, hardware opposing-PWM suppression, Sheet 06 authorization and Sheet 09 destination boundaries, removing `OUTPUT_FAULT_SUMMARY`, and authorizing Package 06R.
- Implemented Package 06R Sheet 05 with dual-axis opposing-PWM suppression, fail-low hardware authorization, independent 3.3 V-to-5 V translator branches, defined inactive defaults, output damping, and ESD provisions without connectors, external drivers, or footprints.
- Completed DFR-01 integrated functional electrical review; issued a NOT APPROVED decision and documented the Critical Sheet 05 authorization-input connectivity defect before Sheet 06 entry.
- Completed ECO-001 by repairing Sheet 05 `ACTUATOR_PERMIT` and `MASTER_INHIBIT` attachment to U3 and adding authorization-connectivity regression checks; native ERC and DFR-01 reissue remain pending.
- Completed DFR-01R: verified ECO-001 and closed DFR-01-F01 pending native ERC, synchronized the translator compatibility open item, and kept Package 07 blocked by the newly identified missing U3 authorization-input defaults.
