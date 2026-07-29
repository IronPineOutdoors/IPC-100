# IPC-100 Engineering Blueprint Executive Summary

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Engineering Blueprint Executive Summary |
| Purpose | Summarize the IPC-100 platform and its Engineering Blueprint |
| Revision | Blueprint v1.0 |
| Status | Draft |
| Last updated | TBD |
| Author | TBD |

## 1. Purpose

IPC-100 is a reusable embedded controller platform developed by Iron Pine Outdoors to provide a common hardware and base-firmware foundation for current and future outdoor automation products.

Rather than creating a unique controller for each product, IPC-100 establishes controlled electrical interfaces, reusable services, and a common engineering baseline.

## 2. Scope

IPC-100 defines:

- Controller electronics
- Base firmware and hardware abstraction
- Stable electrical interfaces and signal names
- Connector and GPIO definitions
- Controller power architecture
- Controller-level mechanical interfaces
- Diagnostics, manufacturing definition, and verification

Product repositories define:

- Product mechanics and enclosures
- Battery mounting and high-current distribution
- Motors, motor drivers, and other high-current loads
- Product wiring harnesses
- Product-specific user-interface implementation
- Application behavior and product-level verification

## 3. Supported products

CrossWind is the first planned external product implementation. RangeHub, Deadfall, Timberline, and other future Iron Pine products are potential platform consumers. Each product is maintained separately and integrates through released IPC-100 interfaces.

## 4. Platform philosophy

The controller remains product-neutral while exposing documented capabilities that products can configure and extend. Reuse is achieved through stable boundaries, not by placing product-specific logic in the platform.

## 5. Design objectives

- Reduce duplicated engineering effort across products.
- Standardize electrical and firmware interfaces.
- Improve long-term maintainability and field serviceability.
- Support controlled hardware and firmware evolution.
- Provide boot-safe, electrically robust behavior.
- Preserve practical expansion without unnecessary complexity.
- Keep high-current product hardware outside the controller.

## 6. High-level overview

Rev A combines a protected 9–21 V DC controller input, 5 V and 3.3 V logic rails, an ESP32-family module, wireless communications, local controls and a monochrome graphical OLED interface, environmental temperature/humidity/pressure sensing, battery monitoring, two external motor-driver logic interfaces, isolated relay contacts, and documented expansion provisions. ESP32-WROOM-32E, the 2.42-inch SSD1309 OLED, and BME280 are current reference implementations only.

## 7. Intended audience

- Hardware and firmware engineers
- Mechanical and product-integration engineers
- Manufacturing and test engineers
- Technical documentation owners
- Engineering reviewers and future maintainers

## 8. Current baseline

| Item | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Current hardware revision | Rev A |
| Current blueprint version | Blueprint v1.0 |
| Engineering status | Architecture and requirements definition |

## 9. Related documents

- [Platform Vision](Platform_Vision.md)
- [System Architecture](System_Architecture.md)
- [Product Boundaries](Product_Boundaries.md)
- [Design Philosophy](Design_Philosophy.md)
- [Non-Goals](Non_Goals.md)
- [Functional Requirements](../requirements/Functional_Requirements.md)
- [Non-Functional Requirements](../requirements/Non_Functional_Requirements.md)
