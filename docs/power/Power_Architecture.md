# IPC-100 Power Architecture

Status: Placeholder for Rev A design analysis.

## Design inputs

- Input operating range: 9–21 V DC
- Integration target: product power systems using DeWalt 20V MAX batteries
- Automotive compatibility: protection profile TBD
- Controller peak and continuous load profiles: TBD

Battery mounting, battery adapters, product fusing, actuator power, and product-level power distribution are defined by consuming product repositories.

## Power tree

Insert the approved power-tree diagram here.

| Rail/domain | Source | Nominal voltage | Continuous current | Peak current | Loads | Notes |
| --- | --- | ---: | ---: | ---: | --- | --- |
| Controller input | J1 | 9–21 V | TBD | TBD | IPC-100 regulators and interfaces | Protected input |
| Logic rail | TBD | TBD | TBD | TBD | ESP32 and logic | Topology TBD |
| Peripheral rail | TBD | TBD | TBD | TBD | OLED, sensors, expansion | Budget TBD |

## Input protection

Define controller reverse-polarity protection, local overcurrent protection, surge suppression, undervoltage behavior, overvoltage behavior, inrush limiting, and connector hot-plug assumptions. The product repository must provide compatible upstream power distribution and protection.

## Regulation

Define regulator topology, efficiency targets, switching frequency, component derating, dropout behavior, quiescent current, ripple, and startup/shutdown sequencing.

## External high-current boundary

IPC-100 does not distribute motor or other high-current load power. Motor drivers and motors are external. The relay exposes isolated dry contacts and does not source load power. Product repositories must define external conductors, fusing, switching, flyback/transient suppression, stall-current behavior, thermal limits, and fault isolation.

## Grounding and noise control

Define controller ground, external logic references, filtering, cable shields where applicable, and immunity to noise at the platform boundary. Product designs must keep high-current returns out of the IPC-100 logic return path.

## Battery monitoring

Define measurement range, divider and protection, ADC calibration, filtering, and controller reporting behavior. Product repositories own load compensation, battery disconnect behavior, and chemistry-specific operating thresholds.

## Thermal design

Document worst-case ambient temperature, enclosure conditions, dissipation estimates, copper spreading, component temperature ratings, and validation points.

## Automotive transient compatibility

Define the applicable transient profile and pass/fail criteria before schematic freeze. Address reverse battery, jump-start/overvoltage, cranking/brownout, load dump, inductive switching, ESD, and conducted immunity as applicable.

## Safety and fault states

Document behavior for brownout, regulator fault, processor reset, shorted controller interfaces, disconnected sensors, external-driver faults, and STOP activation.

## Verification

Link each power requirement to analysis, inspection, or test evidence in the test plan.
