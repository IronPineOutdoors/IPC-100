# IPC-100 Hardware Requirements

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Hardware Requirements |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose and status model

This document is the authoritative Rev A hardware-requirements baseline. `Locked` requirements are current design constraints, `Proposed` requirements require approval, and `TBD` requirements require an engineering decision or verified value.

Verification methods are: inspection, analysis, demonstration, or test.

## 2. Platform requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| PLT-001 | IPC-100 shall be a reusable controller platform. | Supports multiple Iron Pine products from one controlled design. | Inspection | Locked |
| PLT-002 | IPC-100 Rev A shall not be specific to CrossWind. | Preserves platform reuse. | Inspection | Locked |
| PLT-003 | Product-specific mechanical designs, application behavior, wiring harnesses, and release artifacts shall remain in their respective product repositories. IPC-100 may include generic integration examples, compatibility notes, and test fixtures that do not make the platform dependent on a specific product. | Maintains the platform boundary while allowing useful product-neutral integration documentation and validation assets. | Inspection | Locked |

## 3. Power requirements

Normal operating input range and transient-survival range are separate requirements. The transient-survival profile remains `TBD`.

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| PWR-001 | The normal operating input range shall be 9–21 V DC. | Supports the intended battery systems while separating normal operation from transient-survival requirements. | Test | Locked |
| PWR-002 | The primary Rev A integration case shall be an external nominal 18 V lithium-ion tool-battery system with a maximum normal voltage not exceeding 21 V DC. DeWalt 20V MAX batteries are the initial reference implementation. | Defines the initial development source without making the reusable platform dependent on one battery brand. | Inspection | Locked |
| PWR-003 | The secondary intended source shall be a nominal 12 V battery system. | Supports additional products and bench use. | Test | Locked |
| PWR-004 | Motor current shall not pass through the IPC-100 PCB. | Limits noise, heat, and fault energy. | Inspection | Locked |
| PWR-005 | Battery mounting and high-current distribution shall be external product hardware. | These functions depend on product loads and mechanics. | Inspection | Locked |
| PWR-006 | The IPC-100 input power path shall be designed for at least 2.0 A continuous controller-side current at the minimum normal input voltage, subject to final thermal analysis and power-budget approval. | Defines a preliminary controller input-path capability without treating input current alone as the complete power budget. | Analysis and test | Proposed |
| PWR-007 | Components exposed to `VIN_RAW` shall have voltage ratings and derating appropriate for the approved normal-input range and transient-survival profile. | Prevents operation at component limits and ties component selection to the approved electrical environment. | Analysis | Proposed |
| PWR-008 | The final transient-protection topology shall be selected before schematic release. | Protection depends on the verified transient environment. | Inspection and analysis | TBD |
| PWR-009 | The final wide-input 5 V buck regulator shall be selected before schematic release. | Rail sizing and thermal behavior require verified loads. | Analysis and test | TBD |
| PWR-010 | The final 3.3 V regulator and rail architecture shall be selected after verification of ESP32 peak demand, peripheral loading, transient response, dropout margin, and thermal performance. | The final architecture depends on verified loads and may generate 3.3 V from either the 5 V rail or another approved source. | Analysis and test | TBD |
| PWR-011 | USB and main-power interaction shall prevent unsafe backfeed under all approved operating and service conditions. | Protects the host computer, USB interface, and controller power paths when USB, main power, or both are connected. | Inspection and test | Locked |
| PWR-012 | Battery voltage shall be measurable over the normal input range without exceeding the selected ADC limits. | Enables safe battery-status reporting. | Analysis and test | Locked |
| PWR-013 | Battery-voltage measurement accuracy, resolution, filtering, calibration method, and allowable error shall be defined before design release. | A safe ADC input does not by itself guarantee useful or repeatable battery-voltage reporting. | Analysis and test | TBD |

**Engineering notes:**

- Rev A currently assumes a standalone nominal 12 V battery system. Direct connection to a vehicle charging system and automotive load-dump qualification remain outside the approved baseline unless separately added as requirements.
- PWR-011 applies to main power only; USB only if USB-only controller operation is supported; main power and USB connected simultaneously; and USB connected to a host while product power is active.
- Whether USB powers the entire controller or only the programming and diagnostics interface remains `TBD`.

## 4. Processor and communications requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| CPU-001 | IPC-100 Rev A shall use an ESP32-family module that provides Wi-Fi, Bluetooth, and ESP-NOW support and is compatible with the approved Rev A GPIO, memory, programming, power, availability, and lifecycle requirements. | Defines the required processor platform capabilities without prematurely locking Rev A to one specific ESP32 module variant before GPIO allocation, memory needs, USB implementation, procurement availability, and lifecycle suitability are verified. | Inspection and analysis | Proposed |
| CPU-002 | The design shall provide a USB-C service interface for programming and diagnostics. | Provides a standard physical service connection while leaving the internal USB implementation architecture unresolved. | Demonstration | Locked |
| CPU-003 | The selected processor module shall provide sufficient usable GPIO for all locked Rev A functions, approved expansion provisions, boot-safe output behavior, and programming requirements without relying on unavailable pins or unresolved boot-strapping conflicts. | Processor-family compatibility alone does not ensure that the complete Rev A interface set can be implemented safely. | Inspection and analysis | TBD |
| CPU-004 | The selected processor module shall provide sufficient program memory, runtime memory, and nonvolatile storage for the IPC-100 base firmware, diagnostics, communication services, configuration storage, and approved expansion margin. | Avoids locking the production module before firmware memory needs and reserve requirements are understood. | Analysis and test | TBD |
| CPU-005 | The selected processor module shall support reliable reset, normal boot, programming boot, brownout recovery, and watchdog recovery under the approved IPC-100 power and interface conditions. | Reliable startup and recovery are required for an outdoor embedded controller. | Analysis and test | Locked |
| CPU-006 | The selected processor module and associated design shall preserve the approved antenna keepout, grounding, enclosure-clearance, and radio-performance requirements. | Wireless capability depends on both module selection and physical implementation. | Inspection and test | TBD |
| COM-001 | The platform shall support Wi-Fi. | Provides reusable local-network and configuration capability. | Test | Locked |
| COM-002 | The platform shall support Bluetooth. | Provides reusable local-device communication capability. | Test | Locked |
| COM-003 | The platform shall support ESP-NOW. | Provides a low-latency peer-to-peer communication option for compatible Iron Pine devices and controllers. | Test | Locked |
| COM-004 | Wireless communications shall not be required to establish or maintain the IPC-100 hardware-safe output state. | Loss, delay, interference, or absence of a wireless link shall not create unintended motion or triggering. | Analysis and test | Locked |
| COM-005 | The base platform shall expose reusable communication services while product-specific pairing flows, user workflows, message semantics, and application behavior remain product-level responsibilities. | Preserves platform reuse and prevents product workflows from becoming embedded in the controller platform. | Inspection and demonstration | Locked |

**Engineering notes:**

- ESP32-WROOM-32E is the current reference candidate, but it is not the locked production module. Final module selection requires approval before schematic release.
- USB-C defines the external service connector. Native USB versus an external USB-to-UART implementation remains `TBD` and depends on processor selection and schematic approval.
- CPU-005 implementation details and acceptance thresholds remain `TBD`.
- Bluetooth mode selection remains `TBD`; Bluetooth Classic and Bluetooth Low Energy are not locked by COM-002.

## 5. Display and sensor requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| DSP-001 | The display interface shall support a 2.42-inch OLED with SSD1309 controller and 128x64 resolution. | Defines the planned display class. | Inspection and demonstration | Locked |
| DSP-002 | The OLED interface shall use I2C. | Aligns with the shared low-speed bus. | Inspection | Locked |
| DSP-003 | The OLED interface shall provide dedicated `OLED_RESET`. | Supports deterministic display reset. | Inspection and test | Locked |
| DSP-004 | `OLED_VCC` shall remain TBD until module compatibility is verified. | Candidate modules may require different supply voltages. | Analysis and test | TBD |
| SNS-001 | The platform shall provide a BME280 I2C interface. | Supports environmental sensing. | Demonstration | Locked |
| SNS-002 | The platform shall provide battery-voltage monitoring. | Supports power diagnostics. | Test | Locked |
| SNS-003 | OLED, BME280, and I2C expansion may share `I2C_SDA` and `I2C_SCL`, subject to bus verification. | Reduces GPIO use while preserving expansion. | Analysis and test | Proposed |

## 6. Input requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| INP-001 | Four limit-switch inputs shall be provided as `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, and `LIMIT_DOWN`. | Provides stable universal motion-limit interfaces. | Inspection and test | Locked |
| INP-002 | Rotary-encoder inputs `ENCODER_A` and `ENCODER_B` shall be provided. | Supports local navigation. | Test | Locked |
| INP-003 | Rotary-encoder push input `ENCODER_SW` shall be provided. | Supports local selection. | Test | Locked |
| INP-004 | Dedicated `ARM_IN`, `FIRE_IN`, and `STOP_IN` inputs shall be provided. | Supports accessible physical control. | Inspection and test | Locked |
| INP-005 | External digital inputs shall be protected against expected wiring noise and ESD. | Outdoor wiring is exposed to interference and handling. | Analysis and test | Locked |
| INP-006 | Limit inputs shall provide filtering and provisions for external pull resistors. | Supports stable state detection and interface flexibility. | Inspection and test | Proposed |

## 7. Output requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| OUT-001 | One isolated dry-contact relay shall be provided. | Provides a product-neutral isolated trigger interface. | Inspection and test | Locked |
| OUT-002 | Relay contacts shall be exposed as `RELAY_NC`, `RELAY_COM`, and `RELAY_NO`. | Supports normally open and normally closed integration. | Inspection | Locked |
| OUT-003 | The relay shall not provide thrower power. | External load power remains product-level. | Inspection | Locked |
| OUT-004 | Two external motor-driver logic interfaces shall be provided. | Supports two axes without board-level motor power. | Inspection and test | Locked |
| OUT-005 | Each motor-driver interface shall provide provisions for 5 V, GND, RPWM, LPWM, R_EN, and L_EN. | Matches the preliminary external-driver control contract. | Inspection | Locked |
| OUT-006 | The exact motor-driver enable-control implementation may be revised during schematic design while preserving fail-disabled behavior. | GPIO and hardware gating are not yet allocated. | Analysis | Proposed |
| OUT-007 | RGB status outputs `RGB_R`, `RGB_G`, and `RGB_B` shall be provided. | Supports local status indication. | Test | Locked |
| OUT-008 | A `BUZZER_OUT` interface shall be provided. | Supports audible feedback and alerts. | Test | Locked |

## 8. Expansion requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| EXP-001 | Spare GPIO shall be exposed through a documented expansion interface. | Preserves controlled extensibility. | Inspection | Locked |
| EXP-002 | An additional I2C connector shall be provided. | Supports low-speed peripherals. | Inspection and test | Locked |
| EXP-003 | Rev A shall preserve a documented future CAN expansion provision where practical, without requiring a populated CAN transceiver or active CAN firmware in the baseline design. | Avoids blocking a future wired-networking option without adding unapproved Rev A complexity. | Inspection and analysis | Proposed |
| EXP-004 | Rev A shall preserve a documented future RS485 expansion provision where practical, without requiring a populated RS485 transceiver or active RS485 firmware in the baseline design. | Avoids blocking a future robust wired communication option without adding unapproved Rev A complexity. | Inspection and analysis | Proposed |
| EXP-005 | Future daughterboard compatibility should be preserved where practical. | Supports platform evolution. | Inspection and analysis | Proposed |

## 9. Environmental and mechanical requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| ENV-001 | IPC-100 shall be designed for use in outdoor equipment. | Defines the intended environment. | Analysis and test | Locked |
| ENV-002 | The consuming product enclosure should target IP65. | Establishes product integration intent without claiming board ingress protection. | Inspection and test | Proposed |
| ENV-003 | Locking external connectors are preferred where practical. | Improves vibration and service reliability. | Inspection | Proposed |
| ENV-004 | Production assemblies are anticipated to use conformal coating. | Improves moisture resilience. | Inspection and test | Proposed |
| ENV-005 | The PCB operating-temperature target shall be established before design release. | Component and validation limits are not yet approved. | Analysis | TBD |
| ENV-006 | Condensation mitigation shall be a product-level responsibility. | It depends on the final enclosure and installation. | Inspection | Locked |
| MEC-001 | The PCB shall provide documented mounting holes, connector access, and service clearances. | Enables repeatable product integration. | Inspection | Locked |
| MEC-002 | Maximum PCB dimensions shall be approved before layout. | The board envelope is unresolved. | Inspection | TBD |

## 10. Safety requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| SAF-001 | `STOP_IN` shall be a dedicated physical input. | Avoids dependence on shared or wireless commands. | Inspection and test | Locked |
| SAF-002 | Motor-driver outputs shall fail to a disabled state during reset and boot. | Prevents unintended motion. | Analysis and test | Locked |
| SAF-003 | The relay output shall fail open during reset or loss of IPC-100 power. | Prevents unintended triggering. | Analysis and test | Locked |
| SAF-004 | External high-current branches shall be independently fused. | Limits external fault energy. | Inspection | Locked |
| SAF-005 | Safe operation shall not rely only on wireless control. | Wireless links may fail or be unavailable. | Analysis and test | Locked |
| SAF-006 | Product designs shall retain accessible physical controls. | Supports direct intervention. | Inspection | Locked |

## 11. Documentation and verification requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| DOC-001 | Stable signal names shall be consistent across requirements, connectors, GPIO maps, schematics, firmware, and tests. | Prevents interface ambiguity. | Inspection | Locked |
| DOC-002 | Unresolved selections shall be identified as `TBD` and shall not be represented as final. | Preserves engineering integrity. | Inspection | Locked |
| TEST-001 | Every locked hardware requirement shall have traceable verification evidence before release. | Provides objective release evidence. | Inspection | Locked |
| TEST-002 | Prototype testing shall measure actual rail peaks, regulator temperatures, brownout behavior, and interface safe states. | Validates assumptions used in Rev A. | Test | Locked |

## 12. Related documents

- [System Architecture](../architecture/System_Architecture.md)
- [Functional Requirements](Functional_Requirements.md)
- [Non-Functional Requirements](Non_Functional_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
- [Power Architecture](../power/Power_Architecture.md)
- [Wiring Standard](Wiring_Standard.md)
- [Mechanical Interface](Mechanical_Interface.md)
