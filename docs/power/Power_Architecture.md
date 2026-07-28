# IPC-100 Power Architecture

Status: Placeholder for Rev A design analysis.

## Design inputs

- Input operating range: 9–21 V DC
- Primary battery target: DeWalt 20V MAX
- Automotive compatibility: protection profile TBD
- Peak and continuous load profiles: TBD

## Power tree

Insert the approved power-tree diagram here.

| Rail/domain | Source | Nominal voltage | Continuous current | Peak current | Loads | Notes |
| --- | --- | ---: | ---: | ---: | --- | --- |
| Raw battery | J1 | 9–21 V | TBD | TBD | Motors, relay, regulators | Protected input |
| Logic rail | TBD | TBD | TBD | TBD | ESP32 and logic | Topology TBD |
| Peripheral rail | TBD | TBD | TBD | TBD | OLED, sensors, expansion | Budget TBD |

## Input protection

Define reverse-polarity protection, fuse/overcurrent protection, surge suppression, undervoltage behavior, overvoltage behavior, inrush limiting, and connector hot-plug assumptions.

## Regulation

Define regulator topology, efficiency targets, switching frequency, component derating, dropout behavior, quiescent current, ripple, and startup/shutdown sequencing.

## High-current distribution

Define motor and relay current paths, copper and connector ratings, switching devices, flyback/transient suppression, stall-current behavior, and fault isolation.

## Grounding and noise control

Define chassis/earth assumptions, logic ground, power returns, star points or planes, cable shields, filtering, and separation of noisy loads from sensing and radio circuits.

## Battery monitoring

Define measurement range, divider and protection, ADC calibration, filtering, load compensation, low-battery thresholds, and battery disconnect behavior.

## Thermal design

Document worst-case ambient temperature, enclosure conditions, dissipation estimates, copper spreading, component temperature ratings, and validation points.

## Automotive transient compatibility

Define the applicable transient profile and pass/fail criteria before schematic freeze. Address reverse battery, jump-start/overvoltage, cranking/brownout, load dump, inductive switching, ESD, and conducted immunity as applicable.

## Safety and fault states

Document behavior for brownout, regulator fault, processor reset, shorted outputs, disconnected sensors, stalled motors, and STOP activation.

## Verification

Link each power requirement to analysis, inspection, or test evidence in the test plan.

