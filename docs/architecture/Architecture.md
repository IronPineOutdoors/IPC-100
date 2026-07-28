# IPC-100 Architecture

## Mission

IPC-100 provides a robust, reusable control core for Iron Pine Outdoors products. It is intended to reduce duplicated engineering effort while improving safety, serviceability, testability, and product consistency.

## Universal controller philosophy

The controller supplies a stable set of common capabilities—power conversion, processing, wireless communications, operator controls, sensing, and protected outputs. Product behavior should be configured or extended around this core instead of creating a new controller for each machine.

Common interfaces must be explicit and versioned. Product-specific features should not compromise the baseline safety behavior or force incompatible changes on other products.

## Modular hardware approach

IPC-100 separates the reusable controller from product-specific actuators, harnesses, mounting, and optional modules. Connectors form controlled boundaries between these modules. Each boundary should define pinout, voltage, current, direction, protection, mating part, and expected fault behavior.

The platform is organized into:

- Input power and protection
- Regulated logic power
- ESP32 processing and wireless communications
- Operator display and controls
- Environmental and battery sensing
- Protected digital inputs
- Relay, motor, indicator, and buzzer outputs
- Expansion interfaces

## High-current and logic separation

Motor and relay power paths must be physically and electrically separated from logic electronics wherever practical. Rev A design work should address return-current paths, transient suppression, conducted and radiated noise, connector current ratings, thermal limits, and fault containment.

Logic power must remain within component limits during motor start, relay switching, battery insertion, load dump, reverse polarity, and other expected field transients. Grounds may share a defined reference, but high-current return paths must not flow through sensitive logic paths.

## Expansion philosophy

I²C and spare GPIO provide near-term expansion. Expansion connectors must reserve power and signal capacity conservatively and must not expose unprotected processor pins to field wiring. CAN and RS485 are future capabilities; Rev A should avoid choices that prevent their addition in later revisions.

New modules should be discoverable or configurable, electrically documented, mechanically keyed where practical, and safe when absent or incorrectly connected.

## Future compatibility

Compatibility is maintained through revision-controlled connectors, documented electrical limits, firmware capability detection, and stable mechanical envelopes. Later controllers should preserve existing field interfaces where safe and practical. Any breaking change must be identified in revision history, product compatibility records, and manufacturing documentation.

The architecture is intended to scale from the CrossWind automated trap thrower to target systems, motion platforms, remote actuators, and other outdoor automation products.

