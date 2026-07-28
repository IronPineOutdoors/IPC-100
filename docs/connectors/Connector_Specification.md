# IPC-100 Connector Specification

Status: Placeholder — connector selections and pin assignments are not yet approved.

## Connector summary

| Ref | Function | Board part number | Mating part | Pin count | Keying | Status |
| --- | --- | --- | --- | ---: | --- | --- |
| J1 | Power input | TBD | TBD | TBD | TBD | Open |
| J2 | Thrower relay | TBD | TBD | TBD | TBD | Open |
| J3 | Motor interface 1 | TBD | TBD | TBD | TBD | Open |
| J4 | Motor interface 2 | TBD | TBD | TBD | TBD | Open |
| J5 | Limit switches | TBD | TBD | TBD | TBD | Open |
| J6 | Operator controls | TBD | TBD | TBD | TBD | Open |
| J7 | OLED display | TBD | TBD | TBD | TBD | Open |
| J8 | I²C expansion | TBD | TBD | TBD | TBD | Open |
| J9 | Spare GPIO / expansion | TBD | TBD | TBD | TBD | Open |
| J10 | Programming / debug | TBD | TBD | TBD | TBD | Open |

## Per-connector pinout template

Duplicate this table for each connector when assignments are approved.

| Pin | Signal | Direction | Nominal voltage | Maximum current | Protection | Wire color/gauge | Notes |
| ---: | --- | --- | --- | --- | --- | --- | --- |
| 1 | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## J1 — Power input

| Attribute | Requirement |
| --- | --- |
| Input range | 9–21 V DC |
| Polarity/keying | TBD |
| Current rating | TBD |
| Protection | Reverse polarity, overcurrent, and transient strategy TBD |

## J2 — Thrower relay

Pinout, contact ratings, coil/interface behavior, and safe state: TBD.

## J3/J4 — Motor interfaces

Pinout, motor voltage/current, feedback, braking, transient protection, and safe state: TBD.

## J5 — Limit switches

Four-channel pinout, common/reference arrangement, wetting current, filtering, and fault detection: TBD.

## J6 — Operator controls

Rotary encoder, encoder push button, ARM, FIRE, STOP, illumination, and common/reference pinout: TBD.

## J7 — OLED display

SSD1309 power and signal pinout, logic levels, cable length, and connector orientation: TBD.

## J8 — I²C expansion

Power, ground, SDA, SCL, voltage, pull-ups, cable limits, and current budget: TBD.

## J9 — Spare GPIO / expansion

Reserved signals, power budget, logic levels, and protection: TBD.

## J10 — Programming / debug

Programming, UART, reset, boot-mode, ground, and access requirements: TBD.

