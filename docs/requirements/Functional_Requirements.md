# IPC-100 Functional Requirements

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Functional Requirements |
| Purpose | Define observable platform capabilities and behavior |
| Revision | Blueprint v1.0 |
| Status | Draft |
| Last updated | TBD |
| Author | TBD |

## 1. Scope and conventions

These requirements complement the component and interface constraints in [Hardware Requirements](Hardware_Requirements.md). IDs use the globally distinct `FUNC-<category>-<number>` format.

Status values:

- `Locked` — current Rev A design constraint
- `Proposed` — requires approval
- `TBD` — unresolved requirement or acceptance criterion

Verification methods are inspection, analysis, demonstration, or test.

## 2. System requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-SYS-001 | IPC-100 shall provide a reusable controller platform independent of any single product. | Enables controlled reuse. | Inspection | Locked |
| FUNC-SYS-002 | IPC-100 shall expose versioned hardware and base-firmware interfaces to product repositories. | Supports integration and compatibility. | Inspection and demonstration | Locked |
| FUNC-SYS-003 | IPC-100 shall operate without CrossWind-specific hardware or application logic. | Preserves the platform boundary. | Demonstration | Locked |
| FUNC-SYS-004 | IPC-100 shall identify or otherwise support determination of its hardware revision. | Enables firmware compatibility and service. | Inspection and demonstration | Proposed |
| FUNC-SYS-005 | Product-specific application behavior shall remain outside the IPC-100 base-firmware layer. | Prevents scope creep. | Inspection | Locked |

## 3. Power functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-PWR-001 | IPC-100 shall accept 9–21 V DC during normal operation; transient survival is specified separately. | Supports intended source systems without conflating normal operation and transient survival. | Test | Locked |
| FUNC-PWR-002 | IPC-100 shall protect downstream logic from the approved reverse-polarity condition. | Prevents damage from wiring error. | Analysis and test | Proposed |
| FUNC-PWR-003 | IPC-100 shall protect downstream logic from the approved input-transient profile. | Supports electrically noisy outdoor equipment. | Analysis and test | TBD |
| FUNC-PWR-004 | IPC-100 shall generate regulated 5 V and 3.3 V logic rails. | Supplies platform electronics and approved interface loads. | Test | Locked |
| FUNC-PWR-005 | IPC-100 shall measure input battery voltage through `BATTERY_SENSE`. | Supports diagnostics and product power awareness. | Test | Locked |
| FUNC-PWR-006 | IPC-100 shall prevent unsafe backfeed between USB power and main controller power under all approved operating and service conditions. | Protects the host computer, USB interface, and controller power paths. | Analysis and test | Locked |
| FUNC-PWR-007 | IPC-100 shall maintain motor-power isolation by carrying no motor current. | Limits heat, noise, and fault energy. | Inspection | Locked |
| FUNC-PWR-008 | IPC-100 shall expose test access for principal input and logic rails. | Supports bring-up and service. | Inspection | Locked |

## 4. Processor functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-CPU-001 | IPC-100 shall use an ESP32-family module that provides the required Wi-Fi, Bluetooth, and ESP-NOW capabilities. ESP32-WROOM-32E is the current reference candidate, not the locked production module. | Preserves the approved processor family without prematurely fixing the module variant. | Inspection and analysis | Proposed |
| FUNC-CPU-002 | IPC-100 shall support reliable reset, normal boot, programming boot, brownout recovery, and watchdog recovery under approved power and interface conditions. | Enables manufacturing, predictable startup, and fault recovery. | Analysis and test | Locked |
| FUNC-CPU-003 | IPC-100 shall provide a USB-C service interface for programming and diagnostics; native USB versus an external USB-to-UART implementation remains `TBD`. | Provides a standard physical service connection while preserving implementation flexibility. | Demonstration | Locked |
| FUNC-CPU-004 | IPC-100 shall establish hardware-safe outputs before application initialization. | Prevents unintended external activation. | Analysis and test | Locked |
| FUNC-CPU-005 | The final GPIO allocation shall avoid unavailable module pins and unresolved boot conflicts. | Ensures reliable boot and operation. | Inspection and test | TBD |
| FUNC-CPU-006 | The selected processor module shall provide sufficient program memory, runtime memory, nonvolatile storage, and approved expansion margin for base-platform functions. | Prevents module selection before firmware resource needs are understood. | Analysis and test | TBD |

## 5. Input and output functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-IO-001 | IPC-100 shall read `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, and `LIMIT_DOWN`. | Provides four universal limit inputs. | Test | Locked |
| FUNC-IO-002 | IPC-100 shall read `ENCODER_A`, `ENCODER_B`, and `ENCODER_SW`. | Supports local navigation input. | Test | Locked |
| FUNC-IO-003 | IPC-100 shall read dedicated `ARM_IN`, `FIRE_IN`, and `STOP_IN` signals. | Supports accessible physical control. | Test | Locked |
| FUNC-IO-004 | External digital inputs shall tolerate the approved wiring-noise and ESD test levels. | Supports field wiring. | Test | TBD |
| FUNC-IO-005 | IPC-100 shall control `AXIS1_RPWM`, `AXIS1_LPWM`, `AXIS1_REN`, and `AXIS1_LEN`. | Supports one external motor-driver logic interface. | Test | Locked |
| FUNC-IO-006 | IPC-100 shall control `AXIS2_RPWM`, `AXIS2_LPWM`, `AXIS2_REN`, and `AXIS2_LEN`. | Supports a second external motor-driver logic interface. | Test | Locked |
| FUNC-IO-007 | IPC-100 shall provide limited 5 V logic-power provisions for external motor-driver interfaces subject to the approved power budget. | Supports external logic without carrying motor power. | Analysis and test | Proposed |
| FUNC-IO-008 | IPC-100 shall expose isolated `RELAY_NC`, `RELAY_COM`, and `RELAY_NO` contacts. | Provides a product-neutral trigger interface. | Inspection and test | Locked |
| FUNC-IO-009 | IPC-100 shall control the relay coil without sourcing power to the switched load. | Maintains isolation and product ownership. | Inspection and test | Locked |
| FUNC-IO-010 | IPC-100 shall expose at least two documented spare GPIO provisions. | Supports controlled expansion. | Inspection | Proposed |

## 6. User-interface functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-UI-001 | IPC-100 shall interface with a 2.42-inch, 128x64, SSD1309 OLED over I2C. | Provides the planned display interface. | Demonstration | Locked |
| FUNC-UI-002 | IPC-100 shall provide dedicated `OLED_RESET`. | Supports deterministic display recovery. | Test | Locked |
| FUNC-UI-003 | The final `OLED_VCC` domain shall be selected after module compatibility verification. | Avoids an unsupported supply assumption. | Analysis and test | TBD |
| FUNC-UI-004 | IPC-100 shall control `RGB_R`, `RGB_G`, and `RGB_B` status channels. | Supports visible status indication. | Test | Locked |
| FUNC-UI-005 | IPC-100 shall control `BUZZER_OUT`. | Supports audible feedback and alerts. | Test | Locked |

## 7. Sensor functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-SNS-001 | IPC-100 shall communicate with a BME280 through the shared I2C interface. | Supports environmental measurement. | Demonstration | Locked |
| FUNC-SNS-002 | IPC-100 shall convert `BATTERY_SENSE` measurements into a calibrated input-voltage value using approved accuracy, resolution, filtering, calibration, and allowable-error definitions. | Provides useful and repeatable diagnostics; performance values remain TBD. | Analysis and test | TBD |
| FUNC-SNS-003 | Sensor faults or absence shall be reportable without preventing core controller diagnostics. | Improves fault isolation. | Test | Proposed |

## 8. Communications functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-COM-001 | IPC-100 shall support Wi-Fi. | Required platform communication capability. | Test | Locked |
| FUNC-COM-002 | IPC-100 shall support Bluetooth. | Required local communication capability. | Test | Locked |
| FUNC-COM-003 | IPC-100 shall support ESP-NOW. | Required peer communication capability. | Test | Locked |
| FUNC-COM-004 | Base firmware shall present reusable communication services without embedding product workflows. | Preserves application separation. | Inspection and demonstration | Locked |
| FUNC-COM-005 | Rev A should preserve documented future CAN and RS485 expansion provisions where practical without requiring populated transceivers or active baseline firmware. | Preserves future wired options without adding unapproved Rev A complexity. | Inspection and analysis | Proposed |
| FUNC-COM-006 | CAN and RS485 transceivers, connectors, termination, biasing, isolation, voltage standards, protocols, and firmware behavior shall remain `TBD` until approved. | Avoids inventing an implementation. | Inspection | TBD |

## 9. Safety-related functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-SAFE-001 | Motor-driver controls shall remain disabled during reset, boot, brownout, and uninitialized firmware states. | Prevents unintended motion commands. | Analysis and test | Locked |
| FUNC-SAFE-002 | The normally open relay trigger path shall remain open during reset or loss of IPC-100 power. | Prevents unintended triggering. | Analysis and test | Locked |
| FUNC-SAFE-003 | `STOP_IN` shall be processed as a dedicated physical input. | Avoids sole dependence on wireless control. | Inspection and test | Locked |
| FUNC-SAFE-004 | IPC-100 shall not require a wireless link to establish its hardware-safe output state. | Wireless communication may fail. | Test | Locked |
| FUNC-SAFE-005 | Faults detected by platform diagnostics shall be available to the product application. | Supports product-level fault response. | Demonstration | Proposed |

## 10. Base-firmware functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-FW-001 | Base firmware shall initialize board resources in a defined boot-safe sequence. | Supports deterministic startup. | Inspection and test | Locked |
| FUNC-FW-002 | Base firmware shall abstract physical GPIO assignments behind stable logical signal names. | Supports revision portability. | Inspection and test | Locked |
| FUNC-FW-003 | Base firmware shall provide reusable drivers for populated IPC-100 peripherals. | Avoids product-level driver duplication. | Inspection and test | Proposed |
| FUNC-FW-004 | Base firmware shall expose controller diagnostics, including rail/battery status and interface fault information where hardware permits. | Supports service and integration. | Demonstration | Proposed |
| FUNC-FW-005 | Base firmware shall report a version compatible with the controlled hardware revision. | Supports configuration management. | Demonstration | Proposed |
| FUNC-FW-006 | Watchdog strategy, persistent configuration, update mechanism, and diagnostic protocol shall be defined before base-firmware release. | These behaviors are unresolved. | Inspection and test | TBD |

## 11. Related documents

- [System Architecture](../architecture/System_Architecture.md)
- [Product Boundaries](../architecture/Product_Boundaries.md)
- [Hardware Requirements](Hardware_Requirements.md)
- [Non-Functional Requirements](Non_Functional_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
- [Test Plan](../testing/Test_Plan.md)
