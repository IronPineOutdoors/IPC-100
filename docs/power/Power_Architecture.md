# IPC-100 Power Architecture

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Power Architecture |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. Purpose

This document defines the Rev A control-power boundary and the design requirements that must be resolved before the power schematic is released. It does not define product battery mounting or high-current motor distribution.

## 2. Product-level source architecture

The primary Rev A integration case is an external nominal 18 V lithium-ion tool-battery system with a maximum normal voltage no greater than 21 V DC. DeWalt 20V MAX is the initial reference implementation, not a platform dependency. A standalone nominal 12 V battery system is the secondary intended source.

The product supplies the battery mount, main fuse, high-current distribution, branch fuses, high-current converter, motor drivers, motor power wiring, and external power for circuits switched by the relay contacts.

Normal IPC-100 operation is 9–21 V DC. Normal operation and transient survival are separate requirements; the transient-survival profile is `TBD`. Direct connection to a vehicle charging system and automotive load-dump qualification are outside the approved Rev A baseline unless separately added as requirements.

## 3. Power tree

```mermaid
flowchart TD
    BAT["External nominal 18V tool battery<br/>or standalone nominal 12V battery"]
    MF["Product-level main fuse"]
    DIST["Product-level distribution"]
    CF["IPC-100 control fuse"]
    J1["J1 IPC-100 input<br/>VIN_RAW / GND"]
    PROT["Reverse-polarity,<br/>transient, and input protection"]
    BUCK["Wide-input 5V regulator<br/>TBD"]
    L5["5V loads"]
    REG3["3.3V regulator and source<br/>TBD"]
    L3["ESP32 and 3.3V loads"]
    HF["Separate high-current fuse"]
    CONV["High-current converter"]
    DRV["External motor drivers"]
    MOT["Motors"]
    CTRL["IPC-100 low-current<br/>control signals"]

    BAT --> MF --> DIST
    DIST --> CF --> J1 --> PROT --> BUCK
    BUCK --> L5
    BUCK -. "candidate source" .-> REG3
    PROT -. "alternative approved source" .-> REG3
    REG3 --> L3
    DIST --> HF --> CONV --> DRV --> MOT
    CTRL -.-> DRV
```

## 4. Voltage domains

| Domain | Nominal range | Source | Loads | Status |
| --- | --- | --- | --- | --- |
| `VIN_RAW` | 9–21 V DC normal operation | J1 after product control fuse | Input protection, regulator input, battery divider | Locked normal range; transient survival TBD |
| Protected input | TBD | Input protection stage | 5 V buck | TBD |
| `+5V` | 5 V | Wide-input buck | Relay coil, optional interface loads, 3.3 V regulator input, other verified 5 V loads | Regulator TBD |
| `+3V3` | 3.3 V | 3.3 V regulator from an approved source TBD | ESP32, logic, approved 3.3 V peripherals, I2C, verified expansion loads | Regulator and rail architecture TBD |
| USB VBUS | 5 V nominal | USB host | Programming/diagnostics path | Interaction TBD |
| External high-current | Product-defined | Separately fused product branch | Converter, motor drivers, motors | Off-board |
| Relay-contact load | Product-defined | Product-level external source | External circuit switched through isolated contacts | Off-board; not supplied by IPC-100 |

## 5. IPC-100 power entry

J1 carries only `VIN_RAW` and `GND` for controller power. The product control fuse should be placed upstream, near the distribution point. IPC-100 shall include local protection appropriate to board conductors and components. The exact connector, current rating, local fuse, and inrush limits are `TBD`.

## 6. Grounding philosophy

- IPC-100 uses a controlled `GND` reference for logic and low-current external interfaces.
- Motor current and high-current converter return current must not flow through the PCB or IPC-100 harness return.
- External motor drivers may require a logic reference to IPC-100; that conductor is not a motor-power return.
- USB shield, chassis coupling, and cable-shield terminations are `TBD`.
- Analog battery measurement return should be routed to minimize switching and relay-coil error.

## 7. Protection requirements

### 7.1 Reverse polarity

The final reverse-polarity topology is `TBD`. A P-channel MOSFET or alternative implementation may be evaluated, but no device is selected. The circuit must tolerate the approved reverse-input condition without unsafe heating or downstream reverse voltage.

### 7.2 Fuse philosophy

- The product provides a main fuse near the battery source.
- The product provides an IPC-100 control-branch fuse.
- Each product high-current branch is independently fused.
- On-board supplemental protection may be used for PCB traces or limited interface-power outputs.
- Fuse types, ratings, interrupt capacity, and coordination are `TBD`.

### 7.3 TVS protection

The final TVS part, standoff voltage, clamp voltage, pulse rating, and placement are `TBD`. Selection requires the approved transient profile and downstream absolute maximum ratings.

### 7.4 Input filtering

Input capacitance, differential filtering, common-mode filtering, damping, and inrush control are `TBD`. The network must be analyzed with the product wiring impedance and regulator stability requirements.

## 8. 5 V rail

The 5 V regulator shall be selected from the approved power budget and verified 5 V rail loading. Separately, the IPC-100 input power path has a preliminary design target of at least 2.0 A continuous controller-side current at 9 V, pending thermal and power-budget approval.

The final 5 V regulator is `TBD`. MP1584 is not selected for Rev A and must not be treated as an approved design choice. Exact input/output capacitance, inductance, compensation, switching frequency, and protection features are `TBD`.

## 9. 3.3 V rail

The 3.3 V regulator supplies ESP32 and logic loads. Selection must account for wireless transmit peaks, peripheral loading, transient response, dropout margin, thermal dissipation, and expansion reserve. Whether 3.3 V is generated from the 5 V rail or another approved source remains `TBD`; the regulator and capacitor values are also `TBD`.

## 10. USB power interaction

J13 provides USB programming and diagnostics. Prevention of unsafe backfeed is a locked requirement; the implementation and source-selection method remain `TBD`. The design shall cover:

- Main power only
- USB only, if USB-only controller operation is supported
- Main power and USB connected simultaneously
- USB connected to a host while product power is active

Whether USB powers the entire controller or only the programming and diagnostics interface remains `TBD`.

Output interfaces shall remain hardware-safe with main power only; USB only if supported; USB and main power simultaneously; loss of either source; and externally powered motor-driver modules while IPC-100 is unpowered. Backfeed prevention is required among external drivers, USB, IPC-100 rails, isolated relay contacts, and product wiring. External modules may be independently powered, but no power-switch, isolation, or source-selection implementation is approved.

## 11. Battery-voltage measurement

`BATTERY_SENSE` is derived from `VIN_RAW` through a protected divider and filter into an ADC1-capable processor input or another approved ADC path. ADC2 availability shall not be assumed during active Wi-Fi operation unless verified for the selected processor. Divider values, ADC full-scale margin, input protection, measurement accuracy, resolution, filter bandwidth, calibration method, allowable error, leakage error, and acceptable source impedance are `TBD`.

## 12. Power-status indicators

Power-present and rail-status indicators may be provided where their current and light leakage are acceptable. Which rails receive indicators, LED current, colors, and interaction with enclosure visibility are `TBD`. Indicators do not replace electrical test points or power-good supervision.

## 13. Test points

Provide labeled test access for at least:

- `VIN_RAW`
- Protected input after reverse/transient protection
- `+5V`
- `+3V3`
- `GND`
- `BATTERY_SENSE`
- Regulator enable and power-good signals when used
- USB VBUS after protection

Exact reference designators and probe geometry are `TBD`.

## 14. Noise segregation

Keep input switching loops, regulator switch nodes, relay-coil current, digital edges, analog battery sensing, ESP32 antenna clearance, and external cable entries separated according to their noise risk. Do not route sensitive analog signals beneath inductors or switch nodes. Final placement and return-path rules require schematic and PCB review.

## 15. Motor-noise isolation

Motor power is on a separately fused external branch, and motor current must not pass through IPC-100. IPC-100 sends only low-current controls to external drivers. Any motor-driver connector `+5V` provision is a limited logic/interface supply subject to the approved power budget, not motor power. Product wiring must separate motor leads from logic wiring and provide suppression at the source appropriate to the selected drivers and motors.

## 16. Brownout behavior

Motor enables shall remain disabled and the relay coil shall remain de-energized, with `RELAY_NO` open, during undervoltage, reset, and uncontrolled rail decay. ESP32 brownout supervision, regulator undervoltage behavior, external enable gating, and brownout shutdown thresholds are `TBD`.

## 17. Startup and shutdown

Hardware pulls shall establish safe outputs before firmware initialization. Startup sequencing among protected input, 5 V, 3.3 V, ESP32 enable, and external interface power is `TBD`. Shutdown shall not create motor-enable pulses, relay actuation, USB backfeed, or out-of-range input injection through unpowered interfaces.

Optional expansion shall initialize only after hardware-safe outputs and safety-relevant local inputs are established. Expansion power outputs require current limiting, protection, budget allocation, and fault containment; exact limits and implementation remain `TBD`. Externally powered expansion or communications modules shall not backfeed controller rails, USB, GPIO, or other interfaces. External field-bus power may require a product-level supply.

## 18. Thermal considerations

Regulator, protection, relay-coil, indicator, and interface losses shall be evaluated at minimum and maximum input, verified peak load, and the approved ambient/enclosure conditions. Copper spreading, airflow assumptions, component derating, and maximum permitted temperature rise are `TBD`.

## 19. Open component selections

| Item | Status |
| --- | --- |
| Final reverse-polarity topology | TBD |
| Final P-channel MOSFET or alternative device | TBD |
| Final TVS part | TBD |
| Final 5 V buck regulator | TBD |
| Final 3.3 V regulator and rail source | TBD |
| USB backfeed-prevention method | TBD |
| Exact input and output capacitor values | TBD |
| Battery-divider resistor values | TBD |
| Power-good supervision | TBD |
| Brownout shutdown thresholds | TBD |

## 20. Related documents

- [Power Budget](Power_Budget.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
- [System Architecture](../architecture/System_Architecture.md)
- [Connector Specification](../connectors/Connector_Specification.md)
