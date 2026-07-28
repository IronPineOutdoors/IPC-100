# IPC-100 Architecture

## Mission

IPC-100 provides a robust, reusable control core for Iron Pine Outdoors products. It is intended to reduce duplicated engineering effort while improving safety, serviceability, testability, and product consistency.

## Universal controller philosophy

The controller supplies a stable set of common capabilities—power conversion, processing, wireless communications, operator controls, sensing, and protected outputs. Product behavior should be configured or extended around this core instead of creating a new controller for each machine.

Common interfaces must be explicit and versioned. Product-specific features should not compromise the baseline safety behavior or force incompatible changes on other products.

## Modular hardware approach

IPC-100 separates the reusable controller from product-specific actuators, wiring, power distribution, battery mounts, mechanics, and optional modules. Platform connectors form controlled boundaries to those external systems. Each boundary defines pinout, voltage, current, direction, protection, mating requirements, and expected fault behavior.

The platform is organized into:

- Input power and protection
- Regulated logic power
- ESP32 processing and wireless communications
- Operator display and controls
- Environmental and battery sensing
- Protected digital inputs
- Isolated dry-contact relay, low-current motor-driver control, indicator, and buzzer interfaces
- Expansion interfaces

## External loads and logic separation

Motor drivers, motors, and all other high-current loads are external to the IPC-100 PCB. Product repositories own their selection, mounting, wiring, protection, and power distribution. The IPC-100 motor interfaces provide only low-current control signals.

The relay interface is an isolated dry contact; contact load power remains external. IPC-100 logic must remain within component limits when exposed to disturbances permitted by its documented power and connector interfaces. External high-current return paths must not flow through the controller.

## Expansion philosophy

I²C and spare GPIO provide near-term expansion. Expansion connectors must reserve power and signal capacity conservatively and must not expose unprotected processor pins to field wiring. CAN and RS485 are future capabilities; Rev A should avoid choices that prevent their addition in later revisions.

New modules should be discoverable or configurable, electrically documented, mechanically keyed where practical, and safe when absent or incorrectly connected.

## Future compatibility

Compatibility is maintained through revision-controlled connectors, documented electrical limits, firmware capability detection, and stable controller mechanical envelopes. Later controllers should preserve released interfaces where safe and practical. Any breaking change must be identified in revision history and manufacturing documentation.

Product-specific repositories consume these interfaces and own their application behavior. CrossWind is the first planned external implementation and is maintained separately; future consumers may include RangeHub, Deadfall, Timberline, and other Iron Pine products.
