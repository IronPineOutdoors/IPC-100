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
- PWR-011 applies to main-only, bounded USB-only service, simultaneous main/USB, all connection/removal orders, and externally powered interface conditions.
- USB-only power supports the ESP32-S3 core programming, console, JTAG, and recovery domain. It shall not energize relay, motor-driver logic power, OLED, sensor, UI-accessory, or expansion-power domains. IPC-100 does not charge the product battery or source USB VBUS.

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

- ESP32-S3-WROOM-1 is the preferred Rev A module family. The exact flash/PSRAM ordering variant, pin allocation, and final module approval remain gated before schematic release.
- USB-C defines the external service connector. Native ESP32-S3 USB Serial/JTAG is the preferred service architecture; recovery/test UART access, USB-C circuitry, VBUS behavior, and boot/reset implementation remain `TBD` pending schematic approval.
- CPU-005 implementation details and acceptance thresholds remain `TBD`.
- Bluetooth mode selection remains `TBD`; Bluetooth Classic and Bluetooth Low Energy are not locked by COM-002.

## 5. Display and sensor requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| DSP-001 | IPC-100 Rev A shall provide a local monochrome graphical display interface supporting a nominal 128x64-pixel I2C OLED module. The 2.42-inch SSD1309 OLED is the current reference implementation, not a permanent platform dependency. | Locks the required local display capability while avoiding unnecessary dependence on one physical module size or controller before electrical and mechanical compatibility are verified. | Inspection and demonstration | Proposed |
| DSP-002 | The Rev A display interface shall use the shared I2C bus unless a documented engineering review approves another interface before schematic release. | Reduces GPIO demand and supports the current display architecture while preserving a controlled exception process if compatibility issues are discovered. | Inspection and test | Locked |
| DSP-003 | The display interface shall provide a dedicated `OLED_RESET` signal. | Supports deterministic display initialization and recovery independent of shared bus state. | Inspection and test | Locked |
| DSP-004 | The approved `OLED_VCC` supply domain and allowable display-interface voltage levels shall be verified before schematic release. | Candidate OLED modules may use different supply and logic-voltage arrangements, and module markings alone are not sufficient evidence of compatibility. | Analysis and test | TBD |
| DSP-005 | The display interface shall support detection, reporting, or graceful handling of an absent or nonresponsive display without preventing core IPC-100 diagnostics or hardware-safe operation. | A failed or disconnected display shall not disable controller safety functions or basic service diagnostics. | Demonstration and test | Locked |
| DSP-006 | Display update behavior, refresh rate, contrast control, burn-in mitigation, startup timing, and low-power behavior shall be defined before base-firmware release. | OLED reliability and user-interface performance depend on controlled firmware behavior as well as electrical compatibility. | Analysis and test | TBD |
| SNS-001 | IPC-100 Rev A shall provide an I2C environmental-sensor interface supporting measurement of ambient temperature, relative humidity, and barometric pressure. The BME280 is the current reference implementation, not a permanent platform dependency. | Locks the intended environmental-measurement capability while allowing later approval of a compatible sensor if availability, lifecycle, accuracy, or environmental requirements justify a change. | Inspection and demonstration | Proposed |
| SNS-002 | The platform shall provide battery-voltage monitoring through the approved `BATTERY_SENSE` interface. | Supports controller power diagnostics and product-level battery-status decisions. | Test | Locked |
| SNS-003 | The OLED, environmental sensor, and I2C expansion interface may share `I2C_SDA` and `I2C_SCL`, subject to verified address compatibility, bus capacitance, pull-up design, supply-domain compatibility, cable length, fault behavior, and startup operation. | A shared bus reduces GPIO use but requires verification of all attached devices and external expansion conditions. | Analysis and test | Proposed |
| SNS-004 | Environmental-sensor readings shall be identified as controller-enclosure measurements unless product-specific validation establishes that they represent external ambient conditions. | Sensor readings inside an enclosure may be affected by regulator heat, processor heat, sunlight, restricted airflow, and condensation. | Inspection and analysis | Locked |
| SNS-005 | The environmental-sensor interface shall support detection, reporting, or graceful handling of a missing, failed, or nonresponsive sensor without preventing core IPC-100 diagnostics or hardware-safe operation. | A sensor fault shall not prevent controller startup, safe-state behavior, or service access. | Demonstration and test | Locked |
| SNS-006 | Environmental-sensor accuracy, resolution, sampling interval, filtering, calibration method, allowable error, and valid operating range shall be defined before design release. | Providing an electrical interface does not by itself guarantee useful or repeatable environmental measurements. | Analysis and test | TBD |
| SNS-007 | A fault on an optional external I2C expansion device shall not prevent IPC-100 from establishing hardware-safe outputs during reset or startup. | External expansion wiring or a failed peripheral shall not defeat the controller safe state. | Analysis and test | Locked |
| SNS-008 | The final I2C bus architecture shall define pull-up ownership, allowed supply domains, maximum supported bus loading, external cable assumptions, address-conflict handling, and bus-recovery behavior before schematic release. | A reusable expansion bus requires a documented electrical and firmware contract. | Inspection, analysis, and test | TBD |

**Engineering notes:**

- The current reference display is a 2.42-inch, 128x64 OLED using the SSD1309 controller. Final production-display approval requires verification of supply voltage, logic compatibility, initialization behavior, connector pinout, mounting, viewing requirements, environmental suitability, availability, and lifecycle.
- Do not assume that every SSD1309 module accepts the same supply voltage or logic levels. Final approval shall use exact module documentation or verified bench testing.
- BME280 is the current reference sensor. Final sensor approval requires verification of supply voltage, logic compatibility, I2C address behavior, accuracy, operating range, calibration needs, placement, self-heating, airflow exposure, condensation risk, availability, and lifecycle.
- `OLED_VCC` and `SENSOR_VCC` are stable logical connector-supply names; their voltage domains remain `TBD`. Final display and sensor modules must be compatible with the approved supply and logic architecture.
- SNS-002 is supported by the ADC-safety and measurement-performance requirements in PWR-012 and PWR-013.
- The exact bus-isolation, timeout, recovery, or switching implementation for SNS-007 remains `TBD`.

## 6. Input requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| INP-001 | IPC-100 Rev A shall provide four product-neutral motion-limit input interfaces identified as `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, and `LIMIT_DOWN`. | Provides reusable directional limit inputs for products with one or two controlled motion axes without embedding product-specific mechanics or motion logic in the platform. | Inspection and test | Locked |
| INP-002 | IPC-100 Rev A shall provide rotary-encoder phase inputs identified as `ENCODER_A` and `ENCODER_B`. | Provides a reusable local incremental input for navigation and parameter adjustment. | Inspection and test | Locked |
| INP-003 | IPC-100 Rev A shall provide a rotary-encoder pushbutton input identified as `ENCODER_SW`. | Provides a reusable local selection or confirmation input. | Inspection and test | Locked |
| INP-004 | IPC-100 Rev A shall provide dedicated physical input interfaces identified as `ARM_IN`, `FIRE_IN`, and `STOP_IN`. | Provides stable product-neutral local command and intervention inputs without relying on wireless or shared user-interface devices. | Inspection and test | Locked |
| INP-005 | External digital-input interfaces shall include protection appropriate for the approved field-wiring environment, including expected electrostatic discharge, electrical transients, induced noise, miswiring risk, and cable exposure. | IPC-100 inputs may connect to external controls and sensors through wiring exposed to outdoor handling, switching noise, and product-level installation faults. | Analysis and test | Locked |
| INP-006 | External switch and control inputs shall provide an approved combination of hardware conditioning and firmware filtering sufficient to reject expected contact bounce and field-wiring noise without masking valid state changes. | Reliable input detection requires both noise immunity and acceptable response behavior. | Inspection, analysis, and test | Proposed |
| INP-007 | The inactive and asserted electrical states of each limit input shall be explicitly defined before schematic release and shall support detection of a disconnected wire or open circuit where practical. | Undefined active polarity and wiring-fault behavior can create unsafe or ambiguous motion-limit conditions. | Inspection, analysis, and test | TBD |
| INP-008 | An asserted limit input shall remain available to base firmware independently of wireless communications, display operation, environmental-sensor operation, or optional expansion devices. | Motion-limit detection is a core local hardware function and shall not depend on nonessential platform services. | Analysis and test | Locked |
| INP-009 | Limit-input faults, including conflicting opposite limits, permanently asserted inputs, implausible transitions, and wiring faults detectable by the approved circuit, shall be reportable to base diagnostics. | Detectable limit faults should not remain silent and may require product-level motion inhibition. | Demonstration and test | Locked |
| INP-010 | Encoder decoding, direction convention, acceleration behavior, debounce strategy, and long-press or multi-click interpretation shall remain base-firmware or product-level behavior and shall be defined before firmware release where applicable. | The electrical interface should remain reusable without prematurely locking product interaction behavior. | Inspection and demonstration | TBD |
| INP-011 | Failure, disconnection, or erratic operation of the rotary encoder shall not prevent hardware-safe output initialization or operation of dedicated safety inputs. | The local navigation device is nonessential to establishing a safe controller state. | Analysis and test | Locked |
| INP-012 | `STOP_IN` shall be electrically and logically independent from `ARM_IN`, `FIRE_IN`, the rotary encoder, wireless communications, display functions, and optional expansion devices. | The stop function must remain directly available when nonessential interfaces fail. | Inspection, analysis, and test | Locked |
| INP-013 | The approved `STOP_IN` circuit shall default to the hardware-safe interpretation during controller reset, processor boot, firmware failure, loss of input power, or detectable field-wiring fault. | A stop input that becomes permissive during faults would undermine the platform safety architecture. | Analysis and test | Locked |
| INP-014 | `FIRE_IN` shall require an intentional valid transition or asserted state according to the approved input contract and shall not create an output trigger solely because of controller reset, boot, brownout, disconnected wiring, or electrical noise. | Prevents unintended triggering from input ambiguity or startup transients. | Analysis and test | Locked |
| INP-015 | `ARM_IN` shall indicate local permission or readiness only and shall not by itself directly energize motor-driver outputs or the isolated relay. | Separates an authorization input from actual actuator or trigger commands. | Analysis and test | Locked |
| INP-016 | Simultaneous, conflicting, repeated, or implausible states among `ARM_IN`, `FIRE_IN`, and `STOP_IN` shall be available to base diagnostics and handled without defeating the hardware-safe output state. | Abnormal control states should remain visible and must not produce unsafe output behavior. | Demonstration and test | Locked |
| INP-017 | No approved external input condition shall drive a processor GPIO beyond its approved absolute-maximum or recommended operating limits. | Field inputs require controlled interface circuitry rather than direct assumption of processor-compatible voltage levels. | Inspection, analysis, and test | Locked |
| INP-018 | Input-interface failures shall not create unsafe backfeed into the processor rail, USB interface, external field wiring, or other input channels. | A fault on one external input shall not propagate through shared protection or supply paths. | Analysis and test | Locked |
| INP-019 | The final input architecture shall define supported field-contact types, input voltage domains, wet-contact versus dry-contact assumptions, grounding expectations, cable shielding or routing assumptions, and allowed common-mode conditions before schematic release. | A reusable field-input interface requires a documented electrical contract. | Inspection and analysis | TBD |
| INP-020 | The approved pull-resistor and biasing architecture shall establish a defined state for every input during processor reset, boot, unpowered field wiring, and disconnected-input conditions. | Floating inputs can create false commands, false limits, or inconsistent startup behavior. | Inspection and test | Locked |
| INP-021 | Filtering and debounce behavior for `STOP_IN` and motion-limit inputs shall not introduce an unapproved delay in recognizing a valid stop or limit condition. | Noise filtering must not compromise timely response to safety-relevant inputs. | Analysis and test | Locked |
| INP-022 | Input state changes required for hardware-safe behavior shall be evaluated and latched or processed before nonessential display, sensor, network, or product-application tasks where applicable. | Safety-relevant local inputs require deterministic priority over nonessential services. | Analysis and test | Locked |

**Engineering notes:**

- The `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, and `LIMIT_DOWN` logical names define the reusable interface only. Product repositories determine which physical axis, direction, mechanism, or travel endpoint each input represents.
- Normally-closed field wiring is the current safety-preferred concept because an open circuit can be interpreted as a fault or asserted limit, but the final topology is not yet approved.
- The platform exposes `ARM_IN`, `FIRE_IN`, and `STOP_IN` as logical inputs. Product repositories define final control type, labels, ergonomics, sequencing, and permitted application behavior.
- INP-012 and INP-013 refine the dedicated physical STOP requirement in SAF-001. The exact `STOP_IN` circuit topology, polarity, and fault-detection method remain `TBD`.
- The exact ESD standard, surge profile, clamping topology, series impedance, filtering, and connector-level protection for INP-005 remain `TBD` until the field-wiring environment is approved.
- Final pull direction, pull resistance, series impedance, capacitance, hysteresis, debounce interval, and response-time limits remain `TBD`.

## 7. Output requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| OUT-001 | IPC-100 Rev A shall provide one electrically isolated dry-contact relay output interface. | Provides a reusable product-neutral switching interface for external trigger or control circuits without supplying the external load power. | Inspection and test | Locked |
| OUT-002 | Relay contacts shall be exposed using the stable logical names `RELAY_NC`, `RELAY_COM`, and `RELAY_NO`. | Supports both normally-open and normally-closed product integrations using a documented isolated contact set. | Inspection | Locked |
| OUT-003 | IPC-100 shall not provide operating power to the external circuit switched by the isolated relay contacts. | Keeps external load power, fusing, and wiring within the product-level electrical architecture. | Inspection and analysis | Locked |
| OUT-004 | IPC-100 Rev A shall provide two independent low-current external motor-driver logic interfaces identified as Axis 1 and Axis 2. | Supports two product-neutral controlled-motion channels while keeping motor power and high-current switching outside the IPC-100 PCB. | Inspection and test | Locked |
| OUT-005 | Each external motor-driver interface shall provide the stable logical signals `AXISn_RPWM`, `AXISn_LPWM`, `AXISn_REN`, `AXISn_LEN`, `+5V`, and `GND`, where `n` is Axis 1 or Axis 2. | Defines the current reference command contract for external bidirectional motor-driver modules without placing motor current on the IPC-100 PCB. | Inspection | Locked |
| OUT-006 | The exact enable-control architecture may be revised during schematic design provided that both motor-driver channels retain deterministic hardware fail-disabled behavior. | Allows GPIO conservation, hardware gating, shared-enable concepts, or future interface refinement without weakening the required safe state. | Analysis and test | Proposed |
| OUT-007 | IPC-100 Rev A shall provide three logical status-output channels identified as `RGB_R`, `RGB_G`, and `RGB_B`. | Provides a reusable multicolor visual-status interface without locking the platform to one LED package or mechanical arrangement. | Inspection and test | Locked |
| OUT-008 | IPC-100 Rev A shall provide a reusable audible-status output identified as `BUZZER_OUT`. | Supports local audible feedback, alerts, and diagnostics without locking the platform to a specific buzzer technology. | Inspection and test | Locked |
| OUT-009 | The isolated relay shall default to its de-energized state during processor reset, boot, firmware failure, brownout, loss of controller power, and uninitialized operation. | Prevents unintended external triggering or switching during controller faults and startup transitions. | Inspection, analysis, and test | Locked |
| OUT-010 | The relay-control circuit shall prevent controller reset, boot transitions, floating GPIO, communication startup, or electrical noise from unintentionally energizing the relay. | The relay output may initiate an external product action and therefore requires deterministic hardware disable behavior. | Inspection, analysis, and test | Locked |
| OUT-011 | Relay activation shall require a valid base-firmware command after hardware-safe output initialization and all applicable platform safety interlocks have been evaluated. | Prevents direct or premature relay activation before the controller has established a valid operating state. | Analysis and test | Locked |
| OUT-012 | The final relay interface shall define approved contact voltage, current, load type, minimum load behavior, switching frequency, isolation rating, creepage and clearance requirements, fuse assumptions, and environmental derating before schematic release. | A dry-contact label alone does not define a safe or reliable switching contract. | Inspection and analysis | TBD |
| OUT-013 | All motor-driver command and enable signals shall default to the disabled or inactive state during processor reset, boot, firmware failure, brownout, loss of controller power, and uninitialized operation. | External motor drivers shall not receive commands that could create unintended motion during controller faults. | Inspection, analysis, and test | Locked |
| OUT-014 | The motor-driver interface shall prevent simultaneous opposing drive commands from being presented to the same axis except during an explicitly approved driver mode. | Conflicting direction commands may cause braking, shoot-through risk, driver stress, or undefined motion depending on the external driver. | Analysis and test | Locked |
| OUT-015 | Motor-driver enable signals shall remain inactive until base firmware has established hardware-safe outputs, read applicable stop and limit inputs, and completed the approved startup checks. | Motion shall not become possible before local safety-relevant inputs and controller state are known. | Analysis and test | Locked |
| OUT-016 | An asserted `STOP_IN` shall cause the IPC-100 motor-driver command interface to transition toward the approved hardware-safe disabled state independently of wireless communications, display operation, environmental sensing, or product user-interface state. | The dedicated stop input must remain effective when nonessential services fail. | Analysis and test | Locked |
| OUT-017 | The base platform shall make applicable motion-limit input states available to the motor-control service before issuing or continuing a command toward the asserted limit direction. | The reusable motor-control interface must support local directional inhibition without embedding product-specific mechanics. | Analysis and test | Locked |
| OUT-018 | Loss, disconnection, or fault of an external motor-driver module shall not backfeed unsafe voltage or current into IPC-100 logic, USB, input, or power rails under the approved interface conditions. | External drivers operate near high-current motor wiring and may fail independently of the controller. | Analysis and test | Locked |
| OUT-019 | The final motor-driver interface shall define logic voltage levels, current sourcing and sinking limits, output impedance, signal polarity, PWM capability, enable behavior, cable assumptions, grounding, fault handling, and external-driver compatibility before schematic release. | A logical signal list does not by itself define a robust electrical interface. | Inspection, analysis, and test | TBD |
| OUT-020 | IPC-100 shall not supply motor operating current through the motor-driver interface connector. | Motor power remains in the product-level high-current distribution system. | Inspection | Locked |
| OUT-021 | RGB output channels shall default to the approved inactive or safe indication state during reset, boot, firmware failure, brownout, and loss of controller power. | Prevents misleading status indication or unintended rail loading during startup faults. | Inspection and test | Locked |
| OUT-022 | The RGB interface shall not require processor GPIO to directly source or sink current beyond the approved processor limits. | The final visual-indicator load may require current-limiting and driver circuitry. | Inspection and analysis | Locked |
| OUT-023 | Base firmware may provide reusable platform-status indications, while product-specific colors, patterns, meanings, and user workflows remain product responsibilities. | Preserves a reusable status capability without embedding CrossWind or other product semantics into the platform. | Inspection and demonstration | Locked |
| OUT-024 | The final RGB output architecture shall define LED topology, drive polarity, current limits, brightness-control capability, PWM requirements, electrical protection, and connector assumptions before schematic release. | Three logical channels do not establish a complete electrical or optical interface. | Inspection and analysis | TBD |
| OUT-025 | The buzzer output shall default to inactive during reset, boot, firmware failure, brownout, and loss of controller power. | Prevents unintended continuous sound or power draw during controller faults. | Inspection and test | Locked |
| OUT-026 | The buzzer interface shall not require processor GPIO to directly drive a load beyond approved processor current and voltage limits. | Audible devices may require more current or a different voltage domain than a processor GPIO can safely provide. | Inspection and analysis | Locked |
| OUT-027 | Base firmware may provide reusable diagnostic and platform-alert sound services, while product-specific tones, patterns, meanings, volume policies, and workflows remain product responsibilities. | Keeps the audible interface reusable and prevents product semantics from entering the base platform. | Inspection and demonstration | Locked |
| OUT-028 | The final buzzer architecture shall define device type, drive voltage, current, frequency-control needs, acoustic requirements, protection, and connector or onboard-population strategy before schematic release. | The stable logical signal does not determine the electrical or acoustic design. | Inspection and analysis | TBD |
| OUT-029 | Every output capable of causing motion, external triggering, or significant external action shall have an approved hardware-defined inactive state independent of firmware configuration. | Firmware alone shall not be the only mechanism preventing unintended action during reset or failure. | Inspection, analysis, and test | Locked |
| OUT-030 | Hardware-safe output states shall be established before wireless, display, sensor, USB service, optional expansion, or product application services are initialized. | Nonessential services shall not delay or prevent deterministic output safety. | Analysis and test | Locked |
| OUT-031 | Communication loss, malformed commands, repeated commands, stale commands, or command-source conflicts shall not defeat approved hardware-safe output behavior. | Remote and product-level command paths must remain subordinate to local safety and output-state rules. | Analysis and test | Locked |
| OUT-032 | Detectable output faults, command conflicts, invalid states, and unavailable external devices shall be reportable through base diagnostics where supported by the approved hardware. | Fault visibility supports serviceability and product-level recovery. | Demonstration and test | Locked |
| OUT-033 | The final output architecture shall document output behavior for reset, boot, normal operation, shutdown, brownout, watchdog recovery, processor failure, USB-only power, main-power loss, and simultaneous USB and main power. | Output safety depends on behavior across all supported controller power states. | Inspection, analysis, and test | TBD |
| OUT-034 | No output interface shall create unsafe backfeed between controller power domains, USB power, external logic supplies, relay contacts, motor-driver modules, or product wiring under approved normal and single-fault conditions. | IPC-100 interfaces connect to independently powered external systems. | Analysis and test | Locked |

**Engineering notes:**

- The relay interface is intended for low-energy external control circuits. Final contact ratings, isolation ratings, load type, switching life, environmental derating, and relay component selection remain `TBD`.
- Relay-contact wiring is electrically separate from controller logic power except for the approved isolation boundary. Product repositories own external source voltage, load current, fuse selection, wiring, and compatibility validation.
- The intended hardware-safe contact state is `RELAY_NO` open and `RELAY_NC` connected to `RELAY_COM` while the relay coil is de-energized, subject to final component verification. No product-level meaning is assigned to the NC state.
- The exact relay pull resistor, transistor, isolation, and coil-driver topology remain `TBD`.
- Axis 1 and Axis 2 are reusable platform channel names. Product repositories map them to physical mechanisms, directions, motors, and motion functions.
- The motor-driver signal set is based on the current BTS7960-style reference interface. Final electrical compatibility, logic polarity, signal count, connector pinout, enable strategy, and power sourcing remain subject to schematic review; BTS7960 is not a permanent platform dependency.
- No shared-enable, logic-gate, buffer, expander, or hardware interlock implementation is approved by OUT-006. Braking, coast, active braking, and direction-reversal handling remain `TBD`.
- Any motor-driver `+5V` pin is a limited logic/interface supply only and is subject to the approved power budget. It is not motor power.
- The platform defines three RGB logical channels only. LED package, common-anode versus common-cathode topology, current, brightness, optical diffuser, placement, and product color meanings remain unresolved or product-level decisions. The exact inactive state and any passive power-loss indication remain `TBD`.
- `BUZZER_OUT` may use an active buzzer, passive transducer, external sounder, or another approved device. Final topology is not selected.
- OUT-009, OUT-013, OUT-016, OUT-029, and OUT-030 refine the established safety behavior in SAF-001 through SAF-005 without making IPC-100 the sole product-level emergency-stop device.
- OUT-011 coordinates with INP-014 and INP-015: neither `FIRE_IN` nor `ARM_IN` may directly bypass validated relay-command and hardware-safe-state checks.
- OUT-033 and OUT-034 shall be resolved with PWR-011 and CPU-005. Product-level physical safety devices and accessible controls remain product responsibilities under SAF-006.

## 8. Expansion requirements

| ID | Requirement | Rationale | Verification method | Status |
| --- | --- | --- | --- | --- |
| EXP-001 | IPC-100 Rev A shall provide a documented optional shared I2C expansion interface. | Allows approved low-speed digital peripherals to be connected without assigning additional dedicated processor interfaces. | Inspection and test | Locked |
| EXP-002 | IPC-100 Rev A shall provide documented spare GPIO expansion capability using stable logical expansion signals rather than direct processor pin assumptions. | Preserves limited future platform flexibility while allowing processor assignments and interface circuitry to remain hardware-revision controlled. | Inspection | Proposed |
| EXP-003 | IPC-100 shall preserve a documented future CAN-interface provision where practical. | CAN may support future distributed-control products requiring robust wired communication. | Inspection and analysis | Proposed |
| EXP-004 | IPC-100 shall preserve a documented future RS485-interface provision where practical. | RS485 may support future wired devices, remote panels, sensors, or product-to-product communications. | Inspection and analysis | Proposed |
| EXP-005 | Optional expansion devices shall not be required to establish hardware-safe output states, evaluate `STOP_IN`, evaluate motion-limit inputs, or complete core controller diagnostics. | The failure or absence of an optional device must not compromise essential local controller behavior. | Analysis and test | Locked |
| EXP-006 | A fault on an optional expansion interface shall not create unintended motion, relay activation, loss of stop-input effectiveness, unsafe power-domain backfeed, or failure to establish hardware-safe startup states. | Expansion hardware is less controlled than onboard circuitry and may be disconnected, miswired, externally powered, or independently faulty. | Analysis and test | Locked |
| EXP-007 | The final expansion-interface architecture shall define supported voltage domains, current limits, logic thresholds, grounding, protection, cable assumptions, hot-plug assumptions, externally powered device behavior, and fault containment before schematic release. | A connector and logical signal list do not constitute a complete electrical contract. | Inspection and analysis | TBD |
| EXP-008 | Expansion power outputs shall be limited, protected, documented, and included in the approved IPC-100 power budget. | Optional peripherals shall not overload controller rails or compromise base-platform operation. | Inspection, analysis, and test | Locked |
| EXP-009 | An externally powered expansion device shall not backfeed IPC-100 power rails, USB power, processor GPIO, or other external interfaces under approved normal and single-fault conditions. | Expansion devices may remain powered while the controller is off or powered from another source. | Analysis and test | Locked |
| EXP-010 | The platform shall distinguish between onboard required devices, onboard optional devices, external optional devices, and future unpopulated interface provisions. | Firmware, diagnostics, testing, and product integration require a clear definition of which peripherals are required for a given hardware revision. | Inspection | Locked |
| EXP-011 | The shared I2C architecture shall define pull-up ownership and shall prevent uncontrolled parallel pull-up combinations from violating the approved bus electrical limits. | Many modules and breakout boards include onboard pull-ups that may combine to create excessive bus loading. | Inspection, analysis, and test | TBD |
| EXP-012 | The final I2C architecture shall verify address compatibility among all approved onboard and external devices for every supported hardware population option. | Devices with fixed or limited address choices may conflict on a shared bus. | Inspection and test | Locked |
| EXP-013 | An external I2C device holding `I2C_SDA` or `I2C_SCL` in an invalid state shall not indefinitely block hardware-safe initialization or core diagnostics. | An external cable or peripheral fault can otherwise prevent normal processor initialization or bus transactions. | Analysis and test | Locked |
| EXP-014 | The approved I2C expansion contract shall define maximum supported bus loading and wiring assumptions before release. | I2C is primarily intended for short local interconnects and cannot be treated as an unrestricted external field bus. | Inspection and analysis | TBD |
| EXP-015 | The I2C expansion interface shall not advertise hot-plug capability unless the final electrical architecture and validation plan explicitly support it. | Uncontrolled connection and disconnection can cause rail disturbances, bus faults, device latch-up, or unsafe assumptions. | Inspection and test | Locked |
| EXP-016 | The final design shall determine whether external I2C expansion shares the same physical bus segment as onboard devices or is isolated, switched, buffered, translated, or otherwise segmented. | Directly exposing an onboard control bus may reduce reliability and fault containment. | Architecture review and analysis | TBD |
| EXP-017 | Spare GPIO expansion shall be considered non-safety-critical and shall not be required for the base platform's safe-state functions. | Uncontrolled external hardware shall not become part of the essential safety path. | Inspection and analysis | Locked |
| EXP-018 | Spare GPIO expansion signals shall default to a defined non-driving or approved inactive state during reset, boot, unsupported hardware revisions, and uninitialized operation. | Unknown expansion hardware shall not receive unintended commands during processor startup. | Inspection and test | Locked |
| EXP-019 | The final spare-GPIO contract shall specify which signals support input, output, analog input, PWM, interrupt, open-drain, or other approved capabilities. | A generic GPIO label may imply capabilities that the selected processor pin or interface circuit does not support. | Inspection and test | TBD |
| EXP-020 | Spare GPIO interfaces shall include protection and conditioning appropriate to their approved external-wiring assumptions. | Processor pins shall not be directly exposed to uncontrolled external wiring without an approved interface design. | Inspection, analysis, and test | Locked |
| EXP-021 | The final spare-GPIO architecture shall determine whether external GPIOs are direct logic interfaces, protected digital inputs, protected outputs, open-drain signals, analog inputs, or configurable interface channels. | The electrical function must be defined before connector and schematic release. | Architecture review | TBD |
| EXP-022 | The future CAN provision shall reserve only the processor resources, documentation space, and PCB-design consideration that can be supported without compromising Rev A required functions. | A future option shall not consume critical resources needed by the released platform. | Inspection and analysis | Proposed |
| EXP-023 | The future CAN architecture shall define transceiver supply, bus protection, termination, common reference, isolation needs, connector interface, cable assumptions, and protocol ownership before implementation. | CAN controller signals alone do not create a valid external CAN interface. | Architecture review and analysis | TBD |
| EXP-024 | No product shall claim CAN support based solely on reserved processor pins, schematic notes, or an unpopulated footprint. | A provision is not the same as a validated feature. | Inspection | Locked |
| EXP-025 | The future RS485 provision shall reserve only the processor resources, documentation space, and PCB-design consideration that can be supported without compromising Rev A required functions. | A future option shall not consume critical resources needed by the released platform. | Inspection and analysis | Proposed |
| EXP-026 | The future RS485 architecture shall define transceiver supply, direction control, biasing, termination, common reference, isolation needs, protection, connector interface, cable assumptions, and protocol ownership before implementation. | UART signals or reserved GPIO alone do not form a validated RS485 interface. | Architecture review and analysis | TBD |
| EXP-027 | No product shall claim RS485 support based solely on reserved processor pins, schematic notes, or an unpopulated footprint. | A provision is not the same as a validated feature. | Inspection | Locked |
| EXP-028 | IPC-100 may support future daughterboards or approved interface modules provided that the base-board electrical, mechanical, firmware, power, and safety contracts are documented. | Controlled modular expansion may support future products without requiring a complete controller redesign. | Architecture review | Proposed |
| EXP-029 | A daughterboard or expansion module shall not obstruct access to programming, reset, required connectors, service points, mounting hardware, or required diagnostic features unless explicitly approved. | Expansion shall not compromise serviceability or manufacturing access. | Inspection | Locked |
| EXP-030 | The final daughterboard architecture shall define mechanical retention, stack height, mounting support, connector keying, insertion orientation, power sequencing, revision identification, and unsupported-installation behavior. | Electrical pin compatibility alone is insufficient for a reliable modular interface. | Inspection and test | TBD |
| EXP-031 | Base firmware shall be able to determine, through configuration, hardware revision data, module identification, or another approved mechanism, which optional platform devices are supported and populated where necessary. | Firmware shall not blindly initialize hardware that may be absent or electrically incompatible. | Inspection and demonstration | Proposed |

**Engineering notes:**

- J10 does not guarantee compatibility with arbitrary I2C devices, breakout boards, cable assemblies, voltage domains, or wiring lengths.
- `SPARE_GPIO1` and `SPARE_GPIO2` are stable logical expansion concepts. Their count, direction, analog, PWM, interrupt, open-drain, protection, voltage-domain, and current capabilities remain `TBD`; J11 pin count is not finalized.
- Rev A does not require a populated CAN transceiver, approved connector, termination, protection circuit, protocol, bitrate, or product implementation.
- Rev A does not require a populated RS485 transceiver, approved connector, termination, biasing, protection circuit, protocol, baud rate, or product implementation.
- Exact expansion-supply current remains `TBD`. No hot-plug capability is approved.
- I2C timeout, isolation, switching, segmentation, and recovery methods remain `TBD`; no buffer, switch, isolator, or level translator is selected.
- CAN and RS485 provisions are contingent on proven processor-resource availability and are not released Rev A features.
- No daughterboard identification technology or discovery protocol is selected.

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
| SAF-003 | The relay coil shall default de-energized during reset or loss of IPC-100 power, with `RELAY_NO` open and the passive `RELAY_NC` state carrying no platform-assigned product meaning. | Prevents unintended triggering while accurately describing the isolated changeover contact set. | Analysis and test | Locked |
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
