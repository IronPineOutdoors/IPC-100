# IPC-100 Product Boundaries

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Product Boundaries |
| Purpose | Define ownership between the reusable platform and consuming products |
| Revision | Blueprint v1.0 |
| Status | Draft |
| Last updated | TBD |
| Author | TBD |

## 1. Purpose

This document prevents product-specific functionality from entering IPC-100 without an explicit platform decision. It applies to hardware, firmware, mechanics, wiring, manufacturing, testing, and documentation.

## 2. IPC-100 responsibilities

- Controller power entry, protection, and logic regulation
- ESP32 processing, boot support, and programming interface
- Base firmware, hardware abstraction, reusable drivers, and diagnostics
- Stable signal names, PCB connector definitions, and GPIO allocation
- Protected universal inputs and low-current outputs
- OLED, BME280, battery-monitoring, I2C, and expansion interfaces
- Low-current external motor-driver control interfaces
- Isolated relay contacts
- Controller enclosure and PCB-mounting requirements
- Controller assembly, inspection, and verification
- Hardware revision and interface compatibility records

## 3. Product responsibilities

- Battery mount, battery adapter, main fuse, and power distribution
- High-current converters, motor drivers, motors, and actuators
- Product wiring harnesses, feedthroughs, junctions, and cable routing
- Product enclosure, controls enclosure, mechanics, and ergonomics
- Motion sequencing and product-specific firmware behavior
- Product release artifacts
- Product-specific safety analysis and interlocks
- Product assembly, installation, labeling, and service procedures
- Product environmental, ingress, endurance, and compliance validation

## 4. Shared responsibilities

| Area | IPC-100 contribution | Product contribution |
| --- | --- | --- |
| Power | Defines allowable controller input and logic-interface limits | Supplies compatible protected source and high-current branches |
| Motor control | Provides boot-safe low-current control signals | Selects drivers/motors and validates motion safety |
| Physical controls | Provides protected electrical inputs | Defines placement, labels, ergonomics, and application behavior |
| Communications | Provides platform communication capabilities | Defines network topology, pairing, and product workflows |
| Environment | Defines controller-level assumptions and tests | Provides enclosure, condensation control, and product validation |
| Service | Provides diagnostics and replaceable controller interfaces | Defines access, replacement procedure, and field support |
| Compatibility | Versions platform interfaces | Records the platform revision and firmware baseline consumed |

Shared responsibilities require traceable interface requirements in both repositories.

IPC-100 may contain generic integration examples, compatibility notes, product-neutral test fixtures, and interface-validation assets. These materials must remain reusable and must not make IPC-100 dependent on a specific product.

## 5. Examples of proper separation

- IPC-100 defines `AXIS1_RPWM`; a product defines which motor and mechanism it commands.
- IPC-100 exposes `RELAY_NC`, `RELAY_COM`, and `RELAY_NO`; a product supplies and protects the switched circuit.
- IPC-100 measures `VIN_RAW`; a product defines its battery mount and low-battery operating policy.
- IPC-100 provides `STOP_IN`; a product defines control placement and the complete product-level safe-state response.
- IPC-100 provides Wi-Fi, Bluetooth, and ESP-NOW services; a product defines user workflows and peer topology.

## 6. Responsibilities intentionally excluded from IPC-100

- CrossWind-specific motion or throw sequences
- Product names, modes, menus, and user instructions
- Motor, gearbox, linkage, and thrower selection
- Product enclosure dimensions or battery retention
- Product harness lengths and routing
- High-current switching and motor-fault containment
- Product-level risk controls and certification claims
- Product installation and assembly instructions

## 7. Boundary-change process

A proposed responsibility transfer requires:

1. A documented cross-product need
2. An architecture decision record
3. Updated functional and non-functional requirements
4. Interface, power, GPIO, mechanical, and test impact analysis
5. Compatibility and revision review
6. Approval before implementation

## 8. Related documents

- [Platform Vision](Platform_Vision.md)
- [System Architecture](System_Architecture.md)
- [Non-Goals](Non_Goals.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
