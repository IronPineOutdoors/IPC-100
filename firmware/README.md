# Firmware

Reserved for future IPC-100 base firmware, board support, reusable drivers, platform services, and tests. No firmware source is included in the current repository baseline.

## Platform requirements

- Hardware abstraction shall use the stable logical signal names defined by IPC-100 documentation.
- Base firmware shall remain product-neutral; pairing flows, message semantics, user workflows, and application behavior belong in product repositories.
- Platform communication services shall support Wi-Fi, Bluetooth, and ESP-NOW.
- Hardware-safe output initialization shall complete before communication services start.
- Communication loss, delay, interference, or absence shall not defeat the hardware-safe output state.
- Base firmware shall support hardware-revision compatibility and report its own controlled version.
- Reset, normal boot, programming boot, brownout recovery, and watchdog recovery shall be supported.
- Processor memory allocation, reserve targets, watchdog strategy, persistent storage, update behavior, and recovery thresholds remain `TBD`.
- Future CAN and RS485 are proposed expansion provisions, not required baseline firmware functions.

See [Functional Requirements](../docs/requirements/Functional_Requirements.md), [System Architecture](../docs/architecture/System_Architecture.md), and [GPIO Map](../docs/connectors/GPIO_Map.md).
