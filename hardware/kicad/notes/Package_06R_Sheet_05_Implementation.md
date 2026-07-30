# Package 06R — Sheet 05 Implementation Record

## Scope

Package 06R implements the IPC-100 Rev A Axis Command Conditioning and External Driver Logic Interface on Sheet 05. It follows ADR-043 and the Motion Control Interface Control Document (ICD). This is preliminary functional capture only: no connectors, external motor drivers, footprints, PCB layout, limit inputs, position feedback, or output-fault summary are included.

## Implemented inventory

| Function | Axis 1 | Axis 2 |
| --- | --- | --- |
| MCU commands | `AXIS1_RPWM_MCU`, `AXIS1_LPWM_MCU`, `AXIS1_REN_MCU`, `AXIS1_LEN_MCU` | `AXIS2_RPWM_MCU`, `AXIS2_LPWM_MCU`, `AXIS2_REN_MCU`, `AXIS2_LEN_MCU` |
| MCU-side defaults | Four 47 kΩ pulldowns | Four 47 kΩ pulldowns |
| Conflict suppression | `R_OK = RPWM AND NOT LPWM`; `L_OK = LPWM AND NOT RPWM` | Same |
| Translation | One independent SN74LXC4T245-class four-channel A-to-B translator | One independent SN74LXC4T245-class four-channel A-to-B translator |
| A-side supply | `+3V3_CORE` | `+3V3_CORE` |
| B-side supply | `MOTOR_LOGIC_5V_A` | `MOTOR_LOGIC_5V_B` |
| Output conditioning | Four 33 Ω series resistors, four 10 kΩ pulldowns, four connector-boundary ESD provisions | Same |
| Safe exports | `AXIS1_RPWM_SAFE`, `AXIS1_LPWM_SAFE`, `AXIS1_REN_SAFE`, `AXIS1_LEN_SAFE` | `AXIS2_RPWM_SAFE`, `AXIS2_LPWM_SAFE`, `AXIS2_REN_SAFE`, `AXIS2_LEN_SAFE` |

Sheet 09 owns the physical external-driver connectors and production test access. Sheet 05 supplies only conditioned logic nets.

## Authorization implementation

Sheet 05 consumes `ACTUATOR_PERMIT` and `MASTER_INHIBIT`. A core-powered, fail-low logic function creates each translator enable:

`AXISn_XLAT_EN = ACTUATOR_PERMIT AND NOT MASTER_INHIBIT`

Each enable has a 100 kΩ pulldown so an unpowered, floating, reset, or disconnected authorization path leaves the translator disabled. Authorization is common in policy but separately delivered to the two translator branches. STOP is not routed directly into Sheet 05; Sheet 06 owns its contribution to authorization.

The preliminary translator class is partial-power-down-capable and fixed in the 3.3 V A-side to 5 V B-side direction. “Independent” means separately powered Axis 1 and Axis 2 B-side branches; it does not claim galvanic isolation.

## Opposing-command suppression

Combinational core-domain logic suppresses simultaneous opposing PWM requests before translation:

- `R_OK = RPWM AND NOT LPWM`
- `L_OK = LPWM AND NOT RPWM`
- `REN` and `LEN` pass through the same authorization boundary.

When both PWM requests are high, both qualified PWM outputs are low. This hardware function complements, but does not replace, the firmware requirement for at least 20 ms with all direction commands off before reversal.

## Default-state matrix

| Condition | Translator enable | Safe-side result |
| --- | --- | --- |
| Core unpowered | Low/unpowered | Low by 10 kΩ safe-side pulldowns |
| B-side branch unpowered | Disabled or unpowered | Low at the interface boundary; powered-off backfeed remains a release test |
| MCU reset or pins high-impedance | Command inputs low by 47 kΩ pulldowns | All commands low |
| `ACTUATOR_PERMIT` low/absent | Low by logic and 100 kΩ pulldown | All commands low |
| `MASTER_INHIBIT` high | Low | All commands low |
| Both opposing PWM inputs high | Translator may remain enabled | Both PWM outputs low |
| Authorized valid command | High | Selected conditioned commands may pass |

## Timing contract

- PWM operating range: 10–25 kHz.
- Nominal PWM frequency: 20 kHz.
- Minimum pulse that must pass: 1 µs.
- Target propagation through the authorized Sheet 05 path: no more than 500 ns.
- Authorization-loss to safe output disable: no more than 1 ms.
- Firmware direction-reversal all-off interval: at least 20 ms.

These are interface requirements and verification targets, not validated performance claims for the preliminary parts-class capture.

## Assumptions

- External motor modules accept 5 V single-ended RPWM/LPWM/REN/LEN logic with common ground.
- Safe/disabled command state is logic low for every channel.
- Sheet 02 provides separately controlled `MOTOR_LOGIC_5V_A` and `MOTOR_LOGIC_5V_B`.
- Sheet 09 places final ESD devices at the connector boundary and preserves the shown series/default network.
- External motor current does not flow through Sheet 05 logic circuitry.

## Release blockers

- Select exact orderable, lifecycle-acceptable, preferably automotive-qualified four-channel translator devices.
- Select and fault-analyze the exact combinational conflict-suppression and permit/inhibit logic devices.
- Prove partial-power-down, power-sequencing, and no-backfeed behavior for both translator branches.
- Complete worst-case propagation-delay and minimum-pulse analysis over voltage, temperature, tolerance, and load.
- Validate voltage thresholds, input load, grounding, cable length, EMC behavior, and disabled/coast interpretation against each intended external driver.
- Select exact ESD devices and confirm connector-side placement, capacitance, surge capability, and return path.
- Run native KiCad ERC and resolve or formally waive every finding.

## Manual review checklist

- [ ] Eight `_MCU` inputs and eight `_SAFE` outputs match ADR-043 exactly.
- [ ] Axis 1 and Axis 2 use independent B-side supplies and translators.
- [ ] Both opposing-PWM truth tables force both directions low on conflict.
- [ ] Authorization loss forces all safe outputs low without firmware action.
- [ ] Every MCU input and safe output has its specified inactive-state pulldown.
- [ ] Every safe output has 33 Ω series damping and connector-boundary ESD provision.
- [ ] No raw GPIO, limit, position, driver-feedback, connector, driver, or footprint content is present.
- [ ] Sheet 09 integration preserves signal names, protection, defaults, and test access.
