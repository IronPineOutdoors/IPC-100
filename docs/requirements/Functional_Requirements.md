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
| FUNC-CPU-001 | IPC-100 shall use an ESP32-family module that provides the required Wi-Fi, Bluetooth, and ESP-NOW capabilities. ESP32-S3-WROOM-1 is the preferred Rev A module family; its exact ordering variant and pin allocation are not released. | Preserves the approved processor family while recording the comparative recommendation without prematurely fixing the orderable variant. | Inspection and analysis | Proposed |
| FUNC-CPU-002 | IPC-100 shall support reliable reset, normal boot, programming boot, brownout recovery, and watchdog recovery under approved power and interface conditions. | Enables manufacturing, predictable startup, and fault recovery. | Analysis and test | Locked |
| FUNC-CPU-003 | IPC-100 shall provide a USB-C service interface for programming and diagnostics; native USB versus an external USB-to-UART implementation remains `TBD`. | Provides a standard physical service connection while preserving implementation flexibility. | Demonstration | Locked |
| FUNC-CPU-004 | IPC-100 shall establish hardware-safe outputs before application initialization. | Prevents unintended external activation. | Analysis and test | Locked |
| FUNC-CPU-005 | The final GPIO allocation shall avoid unavailable module pins and unresolved boot conflicts. | Ensures reliable boot and operation. | Inspection and test | TBD |
| FUNC-CPU-006 | The selected processor module shall provide sufficient program memory, runtime memory, nonvolatile storage, and approved expansion margin for base-platform functions. | Prevents module selection before firmware resource needs are understood. | Analysis and test | TBD |

## 5. Input and output functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-IO-001 | IPC-100 shall read the product-neutral motion-limit interfaces `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, and `LIMIT_DOWN`; product repositories shall map those names to physical axes, mechanisms, directions, and travel endpoints. | Preserves four stable platform inputs without embedding product mechanics. | Inspection and test | Locked |
| FUNC-IO-002 | IPC-100 shall read `ENCODER_A`, `ENCODER_B`, and `ENCODER_SW`. | Supports a stable reusable local input interface. | Inspection and test | Locked |
| FUNC-IO-003 | IPC-100 shall read dedicated physical `ARM_IN`, `FIRE_IN`, and `STOP_IN` signals, with `STOP_IN` independent of the other controls and nonessential platform services. | Preserves direct local command and intervention inputs. | Inspection, analysis, and test | Locked |
| FUNC-IO-004 | External digital inputs shall tolerate approved field-wiring ESD, transient, induced-noise, miswiring, and cable-exposure conditions without violating processor limits or causing unsafe backfeed. | Provides controlled field interfaces without assuming direct GPIO compatibility. | Analysis and test | Locked |
| FUNC-IO-005 | IPC-100 shall control Axis 1 through `AXIS1_RPWM`, `AXIS1_LPWM`, `AXIS1_REN`, and `AXIS1_LEN` as a low-current product-neutral external-driver interface. | Supports one reusable motion channel without carrying motor current. | Inspection and test | Locked |
| FUNC-IO-006 | IPC-100 shall control Axis 2 through `AXIS2_RPWM`, `AXIS2_LPWM`, `AXIS2_REN`, and `AXIS2_LEN` as a low-current product-neutral external-driver interface. | Supports a second reusable motion channel without carrying motor current. | Inspection and test | Locked |
| FUNC-IO-007 | IPC-100 shall provide limited 5 V logic/interface-supply provisions for both external motor-driver interfaces subject to the approved power budget; motor operating current shall never pass through IPC-100. | Supports external driver logic while preserving the high-current boundary. | Analysis and test | Proposed |
| FUNC-IO-008 | IPC-100 shall expose electrically isolated `RELAY_NC`, `RELAY_COM`, and `RELAY_NO` dry contacts. | Provides a product-neutral externally powered switching interface. | Inspection and test | Locked |
| FUNC-IO-009 | IPC-100 shall control the relay coil without sourcing operating power to the switched external circuit. | Maintains isolation and product ownership of external load power, fusing, and wiring. | Inspection and test | Locked |
| FUNC-IO-010 | IPC-100 shall expose at least two documented spare GPIO provisions. | Supports controlled expansion. | Inspection | Proposed |
| FUNC-IO-011 | Base firmware shall receive the approved inactive, asserted, and detectable disconnected-wire states for each limit input and shall report stuck, implausible, wiring, and conflicting-opposite-limit faults to diagnostics. | Makes the approved electrical contract and detectable motion-limit faults observable without defining product recovery. | Demonstration and test | TBD |
| FUNC-IO-012 | Encoder failure, disconnection, or erratic operation shall not prevent hardware-safe output initialization or dedicated safety-input operation. | Keeps the navigation input nonessential to safe-state operation. | Analysis and test | Locked |
| FUNC-IO-013 | `STOP_IN` shall default to the hardware-safe interpretation during reset, boot, firmware failure, loss of input power, and detectable field-wiring faults. | Prevents fault conditions from making STOP permissive. | Analysis and test | Locked |
| FUNC-IO-014 | `FIRE_IN` shall not cause an output trigger solely because of reset, boot, brownout, disconnected wiring, or electrical noise, and its handling shall remain subject to hardware-safe output checks. | Prevents unintended triggering from ambiguous or transient inputs. | Analysis and test | Locked |
| FUNC-IO-015 | `ARM_IN` shall represent permission or readiness only and shall not directly energize a motor-driver output or the isolated relay. | Separates authorization from actuator commands. | Analysis and test | Locked |
| FUNC-IO-016 | Conflicting, simultaneous, repeated, stuck, or implausible control-input states shall be reportable to diagnostics without defeating the hardware-safe output state. | Keeps abnormal local-control states visible and safe. | Demonstration and test | Locked |
| FUNC-IO-017 | Every input shall have an approved defined state during reset, boot, unpowered field wiring, and disconnection; field-contact type, voltage domain, active polarity, pull/bias arrangement, grounding, and common-mode contract remain `TBD`. | Prevents floating or electrically ambiguous external inputs. | Inspection, analysis, and test | TBD |
| FUNC-IO-018 | Hardware conditioning and firmware filtering shall reject approved bounce and noise while recognizing valid `STOP_IN` and motion-limit changes without an unapproved delay. | Balances field reliability with timely safety-relevant response. | Analysis and test | Proposed |
| FUNC-IO-019 | Safety-relevant stop and motion-limit states shall be processed before nonessential display, sensor, network, encoder-interface, or product-application work where applicable. | Gives local hardware-safe behavior deterministic priority. | Analysis and test | Locked |
| FUNC-IO-020 | Encoder decoding direction, acceleration, debounce, long-press, and multi-click behavior shall be defined before firmware release where applicable. | Keeps interaction behavior configurable without weakening the locked electrical interface. | Inspection and demonstration | TBD |
| FUNC-IO-021 | The relay shall remain de-energized with `RELAY_NO` open during reset, boot, firmware failure, brownout, loss of controller power, and uninitialized operation. | Prevents unintended external switching. | Inspection, analysis, and test | Locked |
| FUNC-IO-022 | Relay activation shall require a validated base-firmware command after hardware-safe initialization and applicable platform safety checks. | Prevents premature or uncontrolled relay operation. | Analysis and test | Locked |
| FUNC-IO-023 | Both motor-driver interfaces shall default fail-disabled during reset, boot, firmware failure, brownout, loss of controller power, and uninitialized operation. | Prevents unintended external motion commands. | Inspection, analysis, and test | Locked |
| FUNC-IO-024 | The reusable motor-control service shall prevent unapproved simultaneous opposing commands, apply `STOP_IN` ahead of motion commands, and inhibit commands toward an applicable asserted limit. | Coordinates product-neutral local safety inputs with external-driver commands. | Analysis and test | Locked |
| FUNC-IO-025 | The BTS7960-style six-signal interface shall remain a reference contract rather than a permanent module dependency; final logic levels, polarity, enable behavior, PWM capability, cable, grounding, fault, and compatibility rules remain `TBD`. | Preserves the stable signal contract while requiring electrical approval. | Inspection, analysis, and test | TBD |
| FUNC-IO-026 | External-driver disconnection, loss of power, independent power, or fault shall not cause unsafe backfeed into IPC-100 logic, USB, input, or power rails under approved conditions. | Contains faults at the product/platform boundary. | Analysis and test | Locked |
| FUNC-IO-027 | Hardware-safe output states shall be established before wireless, display, sensor, USB service, optional expansion, or product-application services initialize. | Keeps nonessential services from delaying output safety. | Analysis and test | Locked |
| FUNC-IO-028 | Communication loss and malformed, repeated, stale, or conflicting commands shall not leave motion or relay outputs active contrary to the approved safe-state rules. | Makes remote commands subordinate to local output safety. | Analysis and test | Locked |
| FUNC-IO-029 | Detectable output faults, invalid command states, conflicts, and unavailable external devices shall be reportable through base diagnostics where approved hardware supports detection. | Supports serviceability without requiring unapproved feedback sensing. | Demonstration and test | Locked |
| FUNC-IO-030 | No output interface shall create unsafe backfeed among controller rails, USB, external logic supplies, relay contacts, motor-driver modules, or product wiring under approved normal and single-fault conditions. | Protects independently powered interface domains. | Analysis and test | Locked |

## 6. User-interface functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-UI-001 | IPC-100 shall provide a nominal 128x64-pixel I2C monochrome graphical OLED interface. The 2.42-inch SSD1309 OLED is the current reference implementation, not a permanent platform dependency. | Provides the required local display capability while preserving module flexibility. | Inspection and demonstration | Proposed |
| FUNC-UI-002 | IPC-100 shall provide dedicated `OLED_RESET`. | Supports deterministic display recovery. | Test | Locked |
| FUNC-UI-003 | The final `OLED_VCC` domain and allowable display-interface voltage levels shall be approved after exact module compatibility is verified. | Avoids unsupported supply and logic-level assumptions. | Analysis and test | TBD |
| FUNC-UI-004 | IPC-100 shall control `RGB_R`, `RGB_G`, and `RGB_B` status channels. | Supports visible status indication. | Test | Locked |
| FUNC-UI-005 | IPC-100 shall control `BUZZER_OUT`. | Supports audible feedback and alerts. | Test | Locked |
| FUNC-UI-006 | An absent or nonresponsive display shall be reportable or handled gracefully without preventing core diagnostics or hardware-safe operation. | Keeps a display fault nonfatal to controller safety and service. | Demonstration and test | Locked |
| FUNC-UI-007 | Display refresh, contrast, burn-in mitigation, startup timing, and low-power behavior shall be defined before base-firmware release. | Controls OLED reliability and user-interface performance without inventing values. | Analysis and test | TBD |
| FUNC-UI-008 | `RGB_R`, `RGB_G`, `RGB_B`, and `BUZZER_OUT` shall default to approved inactive states during reset, boot, firmware failure, brownout, and loss of controller power. | Prevents misleading indication, unintended sound, and uncontrolled rail loading. | Inspection and test | Locked |
| FUNC-UI-009 | RGB and buzzer interfaces shall use approved drive circuitry where required to remain within processor current and voltage limits. | Avoids assuming that GPIO can directly drive final indicator loads. | Inspection and analysis | Locked |
| FUNC-UI-010 | Base firmware may provide reusable RGB status and audible alert services, while product colors, patterns, tones, meanings, volume policies, and workflows remain product responsibilities. | Keeps indicator services reusable and product-neutral. | Inspection and demonstration | Locked |
| FUNC-UI-011 | RGB topology, polarity, current, brightness and PWM needs, plus buzzer type, voltage, current, frequency-control, acoustic, protection, and population strategy shall be approved before schematic release. | Defines unresolved electrical and indicator contracts without inventing implementation values. | Inspection and analysis | TBD |

## 7. Sensor functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-SNS-001 | IPC-100 shall provide shared-I2C environmental measurement of temperature, relative humidity, and barometric pressure. BME280 is the current reference sensor, not a permanent platform dependency. | Preserves the required measurements while allowing controlled sensor approval. | Inspection and demonstration | Proposed |
| FUNC-SNS-002 | IPC-100 shall convert `BATTERY_SENSE` measurements into a calibrated input-voltage value under the approved PWR-012 and PWR-013 criteria. | Provides useful and repeatable power diagnostics without duplicating ADC-performance requirements. | Analysis and test | TBD |
| FUNC-SNS-003 | The OLED, environmental sensor, and I2C expansion interface may share `I2C_SDA` and `I2C_SCL` only after address, loading, pull-up, supply-domain, cable, fault, and startup behavior are verified. | A shared bus saves GPIO but requires a controlled electrical and firmware contract. | Analysis and test | Proposed |
| FUNC-SNS-004 | Environmental readings shall be identified as controller-enclosure measurements unless product-level validation establishes external ambient equivalence. | Prevents enclosure-biased readings from being misrepresented. | Inspection and analysis | Locked |
| FUNC-SNS-005 | A missing, failed, or nonresponsive environmental sensor shall be reportable or handled gracefully without preventing core diagnostics or hardware-safe operation. | Keeps sensor faults nonfatal to startup, safety, and service. | Demonstration and test | Locked |
| FUNC-SNS-006 | Environmental measurement accuracy, resolution, sampling, filtering, calibration, allowable error, and valid operating range shall be approved before design release. | Defines useful and repeatable measurements without inventing performance values. | Analysis and test | TBD |
| FUNC-SNS-007 | An optional external I2C expansion fault shall not prevent hardware-safe output initialization during reset or startup. | Prevents expansion wiring or peripherals from becoming a safety dependency. | Analysis and test | Locked |
| FUNC-SNS-008 | I2C pull-up ownership, allowed supply domains, supported loading, cable assumptions, address-conflict handling, timeout, and recovery behavior shall be defined before schematic release. | Establishes a reusable bus contract. | Inspection, analysis, and test | TBD |

## 8. Communications functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-COM-001 | IPC-100 shall support Wi-Fi. | Required platform communication capability. | Test | Locked |
| FUNC-COM-002 | IPC-100 shall support Bluetooth. | Required local communication capability. | Test | Locked |
| FUNC-COM-003 | IPC-100 shall support ESP-NOW. | Required peer communication capability. | Test | Locked |
| FUNC-COM-004 | Base firmware shall present reusable communication services without embedding product workflows. | Preserves application separation. | Inspection and demonstration | Locked |
| FUNC-COM-005 | Rev A should preserve documented future CAN and RS485 expansion provisions where practical without requiring populated transceivers or active baseline firmware. | Preserves future wired options without adding unapproved Rev A complexity. | Inspection and analysis | Proposed |
| FUNC-COM-006 | CAN and RS485 transceivers, connectors, termination, biasing, isolation, voltage standards, protocols, and firmware behavior shall remain `TBD` until approved. | Avoids inventing an implementation. | Inspection | TBD |

## 9. Expansion functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-EXP-001 | IPC-100 shall support an optional controlled J10 I2C expansion interface without assuming that an external device is present or compatible. | Provides limited approved expansion while preserving safe operation with no attachment. | Inspection and test | Locked |
| FUNC-EXP-002 | IPC-100 shall expose spare expansion through stable logical signals whose physical GPIO assignments and electrical capabilities remain hardware-revision controlled. | Prevents product code from depending on processor pins or unverified capabilities. | Inspection | Proposed |
| FUNC-EXP-003 | CAN and RS485 shall be represented as future provisions only and shall not be advertised as supported unless validated hardware and firmware are present. | Distinguishes reserved concepts from released features. | Inspection and demonstration | Locked |
| FUNC-EXP-004 | Base firmware shall distinguish required onboard, optional onboard, external optional, and future unpopulated devices using approved hardware-revision or configuration information where necessary. | Supports controlled initialization and compatibility diagnostics. | Inspection and demonstration | Proposed |
| FUNC-EXP-005 | IPC-100 shall establish hardware-safe outputs, evaluate safety-relevant local inputs, and provide core diagnostics with no optional expansion attached. | Keeps expansion subordinate to essential controller operation. | Analysis and test | Locked |
| FUNC-EXP-006 | A missing, faulted, unsupported, or hardware-revision-incompatible expansion device shall be diagnostic and nonfatal to hardware-safe startup. | Prevents optional hardware from becoming a safety dependency. | Demonstration and test | Locked |
| FUNC-EXP-007 | Shared-I2C initialization shall detect approved address conflicts and use bounded transaction behavior so a stuck or failed external device cannot indefinitely block safe startup or core diagnostics. | Contains common shared-bus faults. | Analysis and test | Locked |
| FUNC-EXP-008 | Pull-up ownership, supported loading, wiring assumptions, segmentation, timeout, and recovery behavior for shared I2C shall be approved before release. | Defines the unresolved controlled-bus contract. | Inspection, analysis, and test | TBD |
| FUNC-EXP-009 | Expansion power use shall remain within approved, protected rail allocations and shall not imply that unused budget reserve is guaranteed to a product. | Protects required platform loads and rail stability. | Analysis and test | Locked |
| FUNC-EXP-010 | Externally powered expansion hardware shall not backfeed IPC-100 rails, USB, processor interfaces, or other external interfaces under approved normal and single-fault conditions. | Contains independently powered module faults. | Analysis and test | Locked |
| FUNC-EXP-011 | Spare GPIO shall start non-driving or approved inactive and shall reject unsupported function requests rather than assuming analog, PWM, interrupt, voltage, or drive capabilities. | Prevents unsafe or undefined use of unresolved expansion channels. | Inspection and test | Locked |
| FUNC-EXP-012 | Future daughterboards shall remain unsupported until their electrical, mechanical, firmware, power, identification, serviceability, and safety contracts are approved. | Prevents electrical pin similarity from being treated as module compatibility. | Architecture review and test | Proposed |

## 10. Safety-related functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-SAFE-001 | Motor-driver controls shall remain disabled during reset, boot, brownout, firmware failure, loss of controller power, and uninitialized states. | Prevents unintended motion commands. | Analysis and test | Locked |
| FUNC-SAFE-002 | The normally-open relay contact path shall remain open while the relay is de-energized during reset, boot, brownout, firmware failure, or loss of IPC-100 power. | Prevents unintended external triggering. | Analysis and test | Locked |
| FUNC-SAFE-003 | `STOP_IN` shall be processed as a dedicated physical input. | Avoids sole dependence on wireless control. | Inspection and test | Locked |
| FUNC-SAFE-004 | IPC-100 shall not require a wireless link to establish its hardware-safe output state. | Wireless communication may fail. | Test | Locked |
| FUNC-SAFE-005 | Faults detected by platform diagnostics shall be available to the product application. | Supports product-level fault response. | Demonstration | Proposed |

## 11. Base-firmware functions

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| FUNC-FW-001 | Base firmware shall initialize board resources in a defined boot-safe sequence. | Supports deterministic startup. | Inspection and test | Locked |
| FUNC-FW-002 | Base firmware shall abstract physical GPIO assignments behind stable logical signal names. | Supports revision portability. | Inspection and test | Locked |
| FUNC-FW-003 | Base firmware shall provide reusable drivers for populated IPC-100 peripherals. | Avoids product-level driver duplication. | Inspection and test | Proposed |
| FUNC-FW-004 | Base firmware shall expose controller diagnostics, including rail/battery status and interface fault information where hardware permits. | Supports service and integration. | Demonstration | Proposed |
| FUNC-FW-005 | Base firmware shall report a version compatible with the controlled hardware revision. | Supports configuration management. | Demonstration | Proposed |
| FUNC-FW-006 | Watchdog strategy, persistent configuration, update mechanism, and diagnostic protocol shall be defined before base-firmware release. | These behaviors are unresolved. | Inspection and test | TBD |

## 12. Related documents

- [System Architecture](../architecture/System_Architecture.md)
- [Product Boundaries](../architecture/Product_Boundaries.md)
- [Hardware Requirements](Hardware_Requirements.md)
- [Non-Functional Requirements](Non_Functional_Requirements.md)
- [Connector Specification](../connectors/Connector_Specification.md)
- [Test Plan](../testing/Test_Plan.md)
