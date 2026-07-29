# Firmware

Reserved for future IPC-100 base firmware, board support, reusable drivers, platform services, and tests. No firmware source is included in the current repository baseline.

## Platform requirements

- Hardware abstraction shall use the stable logical signal names defined by IPC-100 documentation.
- Input drivers shall expose `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, `LIMIT_DOWN`, `ENCODER_A`, `ENCODER_B`, `ENCODER_SW`, `ARM_IN`, `FIRE_IN`, and `STOP_IN` without exposing GPIO numbers to product code.
- Input polarity and pull configuration shall be controlled by the hardware revision rather than assumed by product code.
- Base firmware shall remain product-neutral; pairing flows, message semantics, user workflows, and application behavior belong in product repositories.
- Platform communication services shall support Wi-Fi, Bluetooth, and ESP-NOW.
- Hardware-safe output initialization shall complete before nonessential services start, and `STOP_IN` and motion-limit processing shall receive deterministic priority.
- Communication loss, delay, interference, or absence shall not defeat the hardware-safe output state.
- Base firmware shall support hardware-revision compatibility and report its own controlled version.
- Reset, normal boot, programming boot, brownout recovery, and watchdog recovery shall be supported.
- Processor memory allocation, reserve targets, watchdog strategy, persistent storage, update behavior, and recovery thresholds remain `TBD`.
- Future CAN and RS485 are proposed expansion provisions, not required baseline firmware functions.
- Reusable base-firmware drivers shall own display and environmental-sensor device access.
- Product-specific screens, menus, alerts, environmental interpretation, and battery policies belong in product repositories.
- Display and environmental-sensor initialization failures shall be reportable and nonfatal to core diagnostics and hardware-safe operation.
- Hardware-safe output initialization shall not wait on I2C peripheral or optional expansion communication.
- I2C timeout, bus-recovery, and optional-expansion fault-containment strategies remain `TBD`.
- Display refresh, contrast, burn-in mitigation, startup timing, and low-power behavior remain `TBD`.
- Environmental sampling, filtering, calibration, allowable-error, and validity rules remain `TBD`.
- Input events should include raw state, conditioned state, fault state, and a timestamp where practical.
- Base firmware shall report detectable input faults; product-specific motion, firing, recovery, and user-interface actions remain outside the base platform.
- `FIRE_IN` handling shall not bypass hardware-safe output checks, and `ARM_IN` shall not directly control outputs.
- Input conditioning and debounce parameters, plus encoder direction, acceleration, long-press, and multi-click behavior, remain `TBD`.

See [Functional Requirements](../docs/requirements/Functional_Requirements.md), [System Architecture](../docs/architecture/System_Architecture.md), and [GPIO Map](../docs/connectors/GPIO_Map.md).
