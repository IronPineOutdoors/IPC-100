# IPC-100 Processor Resource Feasibility

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Purpose | Evaluate processor-resource demand and summarize the proposed allocation |
| Status | Pin-level feasibility demonstrated conditionally; release blocked |
| Owner | Iron Pine Outdoors Engineering |

## 1. Conclusion

Feasibility status: **Pin-level feasibility demonstrated conditionally; allocation release blocked**.

ESP32 remains the processor family. The [Processor Selection Study](Processor_Selection_Study.md) recommends ESP32-S3-WROOM-1 as the preferred module family and native USB Serial/JTAG as the preferred service architecture. The [GPIO and Peripheral Allocation Review](../connectors/GPIO_and_Peripheral_Allocation_Review.md) assigns all 27 required non-USB application signals, preserves fixed USB on GPIO19/20, and reserves GPIO43/44 for UART0 recovery. The proposal is feasible only with an exact module variant that leaves GPIO35/36 available and provides compatible GPIO47/48 voltage behavior. No map is released until that variant, J11, inhibit feedback, and framework-level validation are closed.

### 1.1 Allocation outcome

| Item | Result |
| --- | --- |
| Required non-USB application signals | 27 |
| Proposed required assignments | 27 |
| Unassigned required application signals | 0 |
| Fixed USB signals | GPIO19/20 |
| Motor PWM | Four MCPWM0 generators |
| Battery ADC | GPIO1 / ADC1_CH0 |
| Shared I2C | GPIO47/48 / I2C0 |
| Recovery | GPIO0, EN, and reserved UART0 GPIO43/44 |
| Physical expansion margin | GPIO37 conditional only |
| Primary blockers | Exact module variant, J11, inhibit diagnostics, validation |

## 2. Required resource inventory

| Logical function | Direction | Peripheral need | PWM | ADC | Interrupt preference | Boot safety priority | Allocation priority | Shareable? | External implementation possible? | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `AXIS1_RPWM`, `AXIS1_LPWM` | Output | PWM-capable GPIO | Required | No | No | High | 1 | No under reference contract | Gating/control logic possible | Locked signals |
| `AXIS1_REN`, `AXIS1_LEN` | Output | GPIO | No | No | No | Highest | 1 | Architecture TBD | Gating/shared control possible | Locked signals |
| `AXIS2_RPWM`, `AXIS2_LPWM` | Output | PWM-capable GPIO | Required | No | No | High | 1 | No under reference contract | Gating/control logic possible | Locked signals |
| `AXIS2_REN`, `AXIS2_LEN` | Output | GPIO | No | No | No | Highest | 1 | Architecture TBD | Gating/shared control possible | Locked signals |
| `RELAY_CTRL` | Output | GPIO | No | No | No | Highest | 1 | No | Dedicated gating/driver required | Logical control required |
| `LIMIT_LEFT`, `LIMIT_RIGHT`, `LIMIT_UP`, `LIMIT_DOWN` | Input | Interrupt-capable input preferred | No | No | Preferred | Highest | 1 | No | Safety-suitable external conditioning possible | Locked signals |
| `ENCODER_A`, `ENCODER_B` | Input | Interrupt-capable input preferred | No | No | Preferred | Low | 5 | No | Non-safety I/O expansion possible | Locked signals |
| `ENCODER_SW` | Input | GPIO | No | No | Preferred | Low | 5 | No | Non-safety I/O expansion possible | Locked signal |
| `ARM_IN`, `FIRE_IN` | Input | GPIO | No | No | Preferred | High | 1 | No | Protected input circuitry required | Locked signals |
| `STOP_IN` | Input | Interrupt-capable input preferred | No | No | Preferred | Highest | 1 | No | Dedicated safety-suitable logic possible | Locked signal |
| `RGB_R`, `RGB_G`, `RGB_B` | Output | GPIO; PWM preferred | Preferred | No | No | Low | 5 | Driver architecture TBD | LED driver possible | Locked signals |
| `BUZZER_OUT` | Output | GPIO; PWM depends on device | Preferred/TBD | No | No | Low | 5 | No | Driver or peripheral control possible | Locked signal |
| `I2C_SDA`, `I2C_SCL` | Bidirectional / output | I2C | No | No | No | Medium | 4 | Shared controlled bus | Switch/segmentation possible | Locked signals |
| `OLED_RESET` | Output | GPIO | No | No | No | Low | 4 | No | Non-safety I/O expansion possible | Locked signal |
| `BATTERY_SENSE` | Input | ADC-capable input or approved ADC path | No | Required | No | Medium | 2 | No | External ADC possible | Locked signal |
| USB data or UART service | Bidirectional | Native USB or UART | No | No | No | High | 3 | Architecture dependent | USB bridge possible | TBD |
| Boot, reset, programming, debug | Mixed | Module-management resources | No | No | No | Highest | 2/3 | Module dependent | Support circuitry required | TBD |
| Flash-connected/module-internal resources | Reserved | Module restriction | N/A | N/A | N/A | Highest | Excluded | No | No | TBD by module |
| `SPARE_GPIO1`, `SPARE_GPIO2` | TBD | TBD | TBD | TBD | TBD | Non-safety | 6 | TBD | Expander possible | Proposed/TBD |
| Future CAN | Mixed | CAN controller plus transceiver | No | No | Preferred RX | Future | 7 | Peripheral dependent | External controller possible | Future provision |
| Future RS485 | Mixed | UART plus direction control and transceiver | No | No | Preferred RX | Future | 7 | Peripheral dependent | External controller possible | Future provision |
| Hardware identification | Input/bus | GPIO, ADC, or bus device TBD | No | Possible | No | Medium | 4/6 | Yes | External identification possible | Proposed |
| I2C segmentation control | Output | GPIO or bus-controlled switch TBD | No | No | No | Medium | 4/6 | Possible | External control possible | TBD |
| Optional expansion control | Mixed | TBD | TBD | TBD | TBD | Low | 6 | Possible | External interface logic possible | TBD |

## 3. Derived direct-resource demand

| Resource | Direct implementation count | Basis |
| --- | ---: | --- |
| Independent digital inputs | 10 | Four limits, three encoder signals, ARM, FIRE, STOP |
| Independent digital outputs | 14 | Eight motor signals, relay control, three RGB, buzzer, OLED reset |
| Preferred/required PWM outputs | 8 preferred; 4 required by current motor contract | Four motor PWM, three RGB preferred, buzzer device-dependent |
| ADC inputs | 1 | `BATTERY_SENSE` |
| Interrupt-preferred inputs | 10 preferred | Limits, encoder, ARM/FIRE/STOP; exact requirement varies |
| Shared I2C signals | 2 | `I2C_SDA`, `I2C_SCL` |
| Service data signals | 2 in USB-to-UART scenario; native USB TBD | Service architecture unresolved |
| Required boot-safe outputs | 14 | All output signals require defined startup behavior |
| Highest-priority safety inputs | 5 | `STOP_IN` plus four limits |
| Proposed spare signals | 2 concepts | Capability and pin count unresolved |

The direct scenario is approximately **29 MCU signal resources**: 10 digital inputs + 14 digital outputs + 2 I2C + 1 ADC + 2 service signals. Boot/reset/module-management resources and any optional identification or segmentation controls are additional or module-specific and are not included in that total.

## 4. Illustrative reduced-resource scenario

An illustrative, non-approved scenario could reduce direct MCU demand to approximately **19 signals** by retaining safety-relevant inputs and motor PWM directly while using external logic for motor enables, RGB, buzzer, OLED reset, and encoder functions. This is an estimate for feasibility discussion only. It depends on unapproved circuitry and does not prove timing, startup, diagnostics, or safety suitability.

## 5. Architectural techniques

| Technique | Pressure relieved | New risks/dependencies | Safety suitability | Resolution gate |
| --- | --- | --- | --- | --- |
| Shared enable control | Motor-enable GPIO | Reduced independence and fault containment | Only with approved hardware fail-disable analysis | Before schematic |
| External logic gating | Output GPIO and safe states | Added logic, power sequencing, fault paths | Potentially suitable for safety-related outputs after analysis | Before schematic |
| GPIO expander | Noncritical inputs/outputs | Bus dependency, latency, startup, fault propagation | Not for STOP or essential limits without separate justification | Before schematic if required |
| I/O shift register | Indicator/output GPIO | No direct readback, startup behavior, serial dependency | Generally non-safety only | Before schematic if required |
| LED driver | Three RGB GPIO/PWM resources | Driver dependency and bus fault behavior | Non-safety indication only | During schematic |
| Buzzer driver/service | Drive capability; possibly control resource | Device and timing dependency | Non-safety indication only | During schematic |
| Analog multiplexer | ADC/input resources | Settling, fault ambiguity, sequencing | Not preferred for safety inputs | Future or before schematic if required |
| External ADC | ADC availability | Bus dependency, reference, calibration, startup | Battery monitoring only; not a safe-start dependency | Before schematic if needed |
| I2C switch/segment | Bus fault containment | Control resource, sequencing, recovery | Helps protect core startup; method TBD | Before schematic |
| Hardware identification device | Population/revision detection | New component and discovery dependency | Diagnostic/configuration role only | Before firmware implementation; schematic impact |
| External watchdog | Supervision | Reset interaction, fault policy, added component | Potential safety support, not selected | Before schematic if required |
| Dedicated safety logic | STOP/limit/output independence | Complexity, verification, architecture boundary | Potentially suitable | Before schematic |

## 6. Processor-selection gate

Selection requires demonstrated usable GPIO, PWM, ADC path, communications, memory, boot-safe behavior, wireless support, service compatibility, lifecycle and availability review, approved footprint, antenna/enclosure compatibility, programming/recovery method, and applicable regulatory module status. Final CAN/RS485 resource availability remains future and contingent.

The module-family comparison, preferred service direction, and proposed pin-level allocation are complete. Selection of the exact ESP32-S3-WROOM-1 ordering variant and release of the allocation remain gated by the dependencies above.
