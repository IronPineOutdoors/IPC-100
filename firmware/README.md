# Firmware

Reserved for future IPC-100 base firmware, board support, reusable drivers, platform services, and tests. No firmware source is included in the current repository baseline.

## Platform requirements

- Hardware abstraction shall use the stable logical signal names defined by IPC-100 documentation.
- Output services shall use `RELAY_CTRL`, `AXIS1_RPWM`, `AXIS1_LPWM`, `AXIS1_REN`, `AXIS1_LEN`, `AXIS2_RPWM`, `AXIS2_LPWM`, `AXIS2_REN`, `AXIS2_LEN`, `RGB_R`, `RGB_G`, `RGB_B`, and `BUZZER_OUT`; product code shall not assume GPIO numbers or active polarity.
- Input drivers shall expose `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, `LIMIT_DOWN`, `ENCODER_A`, `ENCODER_B`, `ENCODER_SW`, `ARM_IN`, `FIRE_IN`, and `STOP_IN` without exposing GPIO numbers to product code.
- Input polarity and pull configuration shall be controlled by the hardware revision rather than assumed by product code.
- Base firmware shall remain product-neutral; pairing flows, message semantics, user workflows, and application behavior belong in product repositories.
- Platform communication services shall support Wi-Fi, Bluetooth, and ESP-NOW.
- Hardware-safe output initialization shall complete before nonessential services start, and `STOP_IN` and motion-limit processing shall receive deterministic priority.
- Relay and motor-enable commands shall require validated platform state. `STOP_IN` takes priority over motor commands, and applicable limit inputs shall inhibit commands toward asserted limits.
- Conflicting motor directions shall be rejected or handled only by an approved reusable motor-control service.
- Relay commands shall not bypass hardware-safe state and applicable arming checks.
- Communication loss, delay, interference, or absence shall not defeat the hardware-safe output state.
- Communication failure shall not leave motion or relay commands active indefinitely. Command validity, timeout, stale-command handling, and arbitration remain `TBD`.
- Base firmware shall support hardware-revision compatibility and report its own controlled version.
- Reset, normal boot, programming boot, brownout recovery, and watchdog recovery shall be supported.
- Processor memory allocation, reserve targets, watchdog strategy, persistent storage, update behavior, and recovery thresholds remain `TBD`.
- Future CAN and RS485 are proposed expansion provisions, not required baseline firmware functions.
- Required onboard devices, optional onboard devices, external optional devices, and future unpopulated provisions shall be represented as distinct hardware populations.
- Base firmware shall not assume optional expansion is present. Expansion initialization shall occur only after hardware-safe outputs and safety-relevant inputs are established.
- I2C transactions shall use bounded timeout behavior; bus isolation, segmentation, and recovery remain `TBD`.
- Missing, faulted, unsupported, or hardware-revision-incompatible optional peripherals shall produce diagnostics and remain nonfatal to hardware-safe operation.
- Product code shall not assume a particular sensor, OLED, transceiver, spare-GPIO capability, or daughterboard unless declared compatible by the controlled hardware revision.
- CAN and RS485 shall not be reported as supported features unless validated hardware and firmware are present.
- Externally powered module behavior, power sequencing, and backfeed fault handling shall be included in the approved interface contract.
- Reusable base-firmware drivers shall own display and environmental-sensor device access.
- Product-specific screens, menus, alerts, environmental interpretation, and battery policies belong in product repositories.
- Display and environmental-sensor initialization failures shall be reportable and nonfatal to core diagnostics and hardware-safe operation.
- Hardware-safe output initialization shall not wait on I2C peripheral or optional expansion communication.
- I2C timeout, bus-recovery, and optional-expansion fault-containment strategies remain `TBD`.
- Display refresh, contrast, burn-in mitigation, startup timing, and low-power behavior remain `TBD`.
- Environmental sampling, filtering, calibration, allowable-error, and validity rules remain `TBD`.
- Input events should include raw state, conditioned state, fault state, and a timestamp where practical.
- Base firmware shall report detectable input faults; product-specific motion, firing, recovery, and user-interface actions remain outside the base platform.
- Base firmware shall report detectable output faults where hardware supports detection and shall provide reusable RGB and buzzer services.
- Product-specific motion logic, trigger sequences, light meanings and patterns, tones, volume policies, and audible workflows remain outside base firmware.
- `FIRE_IN` handling shall not bypass hardware-safe output checks, and `ARM_IN` shall not directly control outputs.
- Input conditioning and debounce parameters, plus encoder direction, acceleration, long-press, and multi-click behavior, remain `TBD`.

See [Functional Requirements](../docs/requirements/Functional_Requirements.md), [System Architecture](../docs/architecture/System_Architecture.md), [GPIO Map](../docs/connectors/GPIO_Map.md), and [GPIO and Peripheral Allocation Review](../docs/connectors/GPIO_and_Peripheral_Allocation_Review.md). Physical GPIO values remain board-support configuration and shall not leak into product application interfaces.
