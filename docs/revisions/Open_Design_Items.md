# IPC-100 Open Design Items

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Purpose | Consolidate unresolved engineering decisions and release gates |
| Status | Active register |
| Owner | Iron Pine Outdoors Engineering |

`TBD` identifies an unresolved decision, not permission to select an implementation without the required review. Closing an item requires updates to every dependent controlled document.

Category is inherited from each section heading. Iron Pine Outdoors Engineering is the default review owner. The decision-needed and dependency fields define the current decision space, dependent requirements, and dependent documents. Stage labels in this register map to the controlled gates as follows: “Before schematic release” means **Before schematic**; “Before firmware release/architecture” means **Before firmware implementation**; “Before connector release” means **Before PCB layout**; “Before verification release” means **Before validation**; “Before product integration” means **Before production** for the platform and a separate product gate for the consuming product.

## Processor

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-CPU-001 | Final ESP32 module | Preferred family is ESP32-S3-WROOM-1; approve exact flash/PSRAM ordering variant after pin, memory, mechanical, lifecycle, and procurement review | Controls pinout, memory, radio, lifecycle, and USB options | Processor Selection Study, requirements, GPIO, power, PCB | Before schematic release | Preferred family selected; exact variant TBD |
| ODI-CPU-002 | GPIO sufficiency | Prove required functions fit before optional provisions | Prevents resource overcommitment | GPIO map, connectors, expansion | Before schematic release | TBD |
| ODI-CPU-003 | Memory sufficiency | Define program, runtime, storage, and reserve needs; PSRAM is not currently demonstrated as required | Controls exact ESP32-S3-WROOM-1 ordering variant | Firmware architecture, Processor Selection Study | Before firmware architecture release | Budget TBD; baseline PSRAM need not established |
| ODI-CPU-004 | USB architecture | Preferred architecture is native ESP32-S3 USB Serial/JTAG; approve recovery/test UART access, USB-C circuitry, VBUS behavior, and boot/reset implementation | Affects processor, GPIO, power, service behavior | J13, GPIO, power, Processor Selection Study | Before schematic release | Preferred architecture selected; implementation TBD |
| ODI-CPU-005 | Boot-straps and allocation | Approve reset, boot, programming, and strap-safe allocation | Prevents boot and safe-state conflicts | GPIO map, all interfaces | Before schematic release | TBD |
| ODI-CPU-006 | Watchdog strategy | Define supervision, timeout, and recovery behavior | Affects output safety and diagnostics | Firmware, testing, outputs | Before firmware release | TBD |
| ODI-CPU-007 | ADC path | Select processor ADC capability or another approved ADC path | Battery monitoring must coexist with active Wi-Fi and approved accuracy | PWR-012, PWR-013, SNS-002; GPIO and power docs | Before schematic | TBD |

## Power

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-PWR-001 | Regulator implementation | Implement `VIN_PROTECTED` to `+5V_MAIN`, non-backfeeding `CORE_SOURCE`, and `+3V3_CORE`; select topologies/components after load and abnormal-input closure | Defines rail capability and thermal behavior | Power Architecture Engineering Review, budget, schematic | Before schematic release | Block architecture selected; implementation TBD |
| ODI-PWR-002 | Controller current budget | Close all typical, peak, startup, and simultaneous cases | Prevents undersized input and rails | Power budget, component selection | Before schematic release | TBD |
| ODI-PWR-003 | Expansion reserves | Allocate J10, J11, communications, and daughterboard reserves | Prevents optional loads from displacing required loads | Power budget, connectors | Before connector release | TBD |
| ODI-PWR-004 | USB power implementation | Implement bounded USB-only core service and simultaneous-source behavior without energizing main-only loads | Controls service, startup, shutdown, and backfeed | J13, output states, testing, Power Architecture Engineering Review | Before schematic release | Behavior selected; implementation TBD |
| ODI-PWR-005 | Backfeed protection | Implement approved blocking boundaries among USB, source selector, rails, and external modules | Independently powered interfaces may inject power | Power, expansion, outputs | Before schematic release | Boundaries selected; circuits/ratings TBD |
| ODI-PWR-006 | External interface supply limits | Allocate protected J2/J3/J8/J10/J11 supply envelopes | Interface loads may overload required rails | EXP-008, OUT-020; Power Budget, connectors | Before schematic | TBD |
| ODI-PWR-007 | Brownout implementation | Select thresholds, hysteresis, supervision, discharge, and recovery implementation under the approved safe-state sequence | Safe relay and motor states depend on controlled power behavior | CPU-005, OUT-013, OUT-033; Power Architecture Engineering Review | Before schematic | Behavior selected; numeric implementation TBD |
| ODI-PWR-008 | Abnormal-input profile | Approve reverse-polarity, surge/transient, undervoltage, and overvoltage conditions and upstream source/fuse assumptions | Protection parts and ratings cannot be selected without an energy/voltage profile | Requirements, product integrations, test plan | Before schematic | TBD |
| ODI-PWR-009 | Source-transition criteria | Define allowed core-rail interruption, switchover behavior, inrush, and acceptance criteria for main/USB connection order | Controls service continuity, reset behavior, and source-selector design | USB, processor, testing | Before schematic | Architecture objective defined; numeric criteria TBD |

## Display and sensors

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-DS-001 | `OLED_VCC` | Approve supply and logic compatibility | Stable name does not define voltage | J6, power, display selection | Before schematic release | TBD |
| ODI-DS-002 | `SENSOR_VCC` | Approve supply and logic compatibility | Stable name does not define voltage | J7, power, sensor selection | Before schematic release | TBD |
| ODI-DS-003 | Final OLED | Approve exact module and interface | Controls pinout, initialization, mechanics, lifecycle | J6, firmware, enclosure | Before schematic release | TBD |
| ODI-DS-004 | Environmental sensor | Approve exact sensor/module | Controls accuracy, address, placement, lifecycle | J7, firmware, calibration | Before schematic release | TBD |
| ODI-DS-005 | I2C pull-ups | Define ownership for every population | Parallel pulls may violate the bus contract | J6, J7, J10, expansion | Before schematic release | TBD |
| ODI-DS-006 | I2C segmentation | Choose direct, isolated, switched, buffered, or translated architecture | External faults may block onboard devices | I2C architecture, diagnostics | Before schematic release | TBD |
| ODI-DS-007 | Sensor interpretation | Define placement, calibration, and ambient-equivalence rules | Enclosure readings may not equal external ambient | Product integration, testing | Before product integration | TBD |

## Inputs

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-INP-001 | Active polarity | Define inactive and asserted states | Required for deterministic diagnostics and startup | Connectors, GPIO, firmware | Before schematic release | TBD |
| ODI-INP-002 | NO versus NC | Approve contact and fault strategy | Open-circuit interpretation affects safety | Limits, STOP, harnesses | Before schematic release | TBD |
| ODI-INP-003 | Wet versus dry contact | Define supported field-contact model | Controls interface voltage and protection | J4, J5, J8 | Before schematic release | TBD |
| ODI-INP-004 | Protection | Approve field transient and miswiring contract | Prevents processor and rail damage | Inputs, connectors, testing | Before schematic release | TBD |
| ODI-INP-005 | Filtering and debounce | Approve conditioning, response, and timing | Noise rejection must not mask STOP or limits | Hardware, firmware, testing | Before firmware release | TBD |
| ODI-INP-006 | STOP fault detection | Define topology and safe interpretation | STOP must remain effective during faults | SAF, J8, firmware | Before schematic release | TBD |
| ODI-INP-007 | J4/J5 suitability | Decide whether shared-return three-pin allocations remain viable | Field contract may require more conductors or partitioning | Connector review, harnesses | Before schematic release | TBD |

## Outputs

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-OUT-001 | Relay selection | Approve relay, ratings, isolation, and derating | Dry-contact naming is not a switching contract | J9, power, testing | Before schematic release | TBD |
| ODI-OUT-002 | Motor-driver compatibility | Approve levels, polarity, drive, grounding, and protection | Reference signaling is not universal compatibility | J2, J3, external drivers | Before schematic release | TBD |
| ODI-OUT-003 | Enable architecture | Approve independent, shared, or gated implementation | Controls GPIO use and fail-disabled behavior | GPIO map, safety | Before schematic release | TBD |
| ODI-OUT-004 | PWM behavior | Define capability and interface requirements | Affects allocation and driver compatibility | GPIO, firmware, motor interface | Before schematic release | TBD |
| ODI-OUT-005 | Brake/coast behavior | Approve conflicting-command and reversal modes | External drivers interpret commands differently | Firmware service, product integration | Before firmware release | TBD |
| ODI-OUT-006 | RGB topology | Define package, polarity, drive, current, and brightness control | Logical channels do not define hardware | J8, power, firmware | Before schematic release | TBD |
| ODI-OUT-007 | Buzzer topology | Define device, drive, power, and acoustic contract | Active and passive devices differ | J8, power, firmware | Before schematic release | TBD |
| ODI-OUT-008 | Safe-state timing | Approve transition and recovery criteria | Required for verification across faults | Outputs, power, testing | Before verification release | TBD |
| ODI-OUT-009 | Relay contact ratings | Define voltage, current, load, life, isolation, and derating contract | Relay selection cannot begin without it | OUT-012; J9, power, testing | Before schematic | TBD |
| ODI-OUT-010 | Relay driver | Define coil supply, hardware disable, drive, and protection architecture | Firmware cannot be the sole safeguard | OUT-009–OUT-011, OUT-029; GPIO and power | Before schematic | TBD |
| ODI-OUT-011 | Output protection | Define external-driver, RGB, buzzer, and relay-control fault protection | External faults must not backfeed or damage logic | OUT-018, OUT-022, OUT-026, OUT-034; connectors | During schematic | TBD |

## Expansion

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-EXP-001 | J10 contract | Define domains, power, loading, wiring, protection, hot-plug, timeout, and recovery | Connector presence does not guarantee compatibility | I2C, power, firmware | Before schematic release | TBD |
| ODI-EXP-002 | J11 function | Define signal count, functions, voltage, protection, power, and pin count | Current concepts imply no guaranteed capability | GPIO, power, connector review | Before schematic release | TBD |
| ODI-EXP-003 | CAN provision | Define resources and future external contract | Provision is not a released feature | GPIO, J12, PCB planning | Before PCB layout | TBD |
| ODI-EXP-004 | RS485 provision | Define resources and future external contract | Provision is not a released feature | GPIO, J12, PCB planning | Before PCB layout | TBD |
| ODI-EXP-005 | Daughterboards | Define electrical, mechanical, power, service, and safety architecture | Pin compatibility alone is insufficient | Connectors, mechanics, firmware | Before daughterboard design | TBD |
| ODI-EXP-006 | Expansion detection | Select configuration, revision, or identification mechanism | Firmware must avoid incompatible initialization | Firmware, hardware revisioning | Before firmware implementation | TBD |
| ODI-EXP-007 | Hot-plug policy | Approve or explicitly prohibit per interface | Connection transients may disturb rails and buses | J10, J11, testing | Before connector release | TBD |

## Connectors

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-CONN-001 | J8 partitioning | Keep combined J8 or split safety, navigation, and indicators | Mixed locations, voltages, criticality, and harness routes | `CONN-TBD-001`, product families | Before schematic release | TBD |
| ODI-CONN-002 | J4/J5 partitioning | Retain shared returns or revise conductor grouping | Fault isolation and field contract remain unresolved | Input architecture, harnesses | Before schematic release | TBD |
| ODI-CONN-003 | J11 pin count | Approve only after capability and GPIO review | Avoids a false four-pin commitment | `CONN-TBD-002`, GPIO | Before schematic release | TBD |
| ODI-CONN-004 | J12 architecture | Choose shared, separate, footprint, or daughterboard provisions | CAN and RS485 are electrically different | `CONN-TBD-003`, expansion | Before schematic release | TBD |
| ODI-CONN-005 | Connector families | Select compatible families for each interface | Controls ratings, lifecycle, assembly, and mating | All connector contracts | Before PCB layout | TBD |
| ODI-CONN-006 | Keying and cross-connection | Define polarization, coding, and labels | Prevents foreseeable incorrect mating | Harness and safety review | Before PCB layout | TBD |
| ODI-CONN-007 | Retention | Define vibration and service retention | Outdoor equipment requires reliable mating | Mechanical and product environment | Before PCB layout | TBD |
| ODI-CONN-008 | Environmental sealing | Define connector-versus-enclosure sealing ownership | Board connectors alone do not establish ingress rating | Product enclosure, harnesses | Before product integration | TBD |
| ODI-CONN-009 | Harness grouping | Approve safety, noisy, isolated, bus, and UI partitioning | Grouping affects faults, service, and product flexibility | Connector architecture review | Before schematic release | TBD |
| ODI-CONN-010 | Pin-count approval | Approve provisional counts after electrical and harness contracts | Logical reservations are not released pinouts | Connector Specification and Review | Before schematic | TBD |

## Mechanical

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-MEC-001 | PCB envelope | Define preliminary maximum envelope and edge constraints | Schematic connector and RF planning need physical bounds | MEC-TBD-001; Mechanical Interface | Before schematic | TBD |
| ODI-MEC-002 | Mounting holes | Define preliminary mounting concept and supported regions | Controls board outline and placement constraints | MEC-TBD-002, MEC-TBD-003 | Before PCB layout | TBD |
| ODI-MEC-003 | Enclosure constraints | Define controller-level clearance and environmental boundary assumptions | Affects connectors, thermal design, and service | ENV requirements; Mechanical Interface | Before PCB layout | TBD |
| ODI-MEC-004 | Connector-edge access | Define mating, latch, tool, and harness approach envelopes | Connector placement cannot be validated without access | MEC-TBD-004; Connector Review | Before PCB layout | TBD |
| ODI-MEC-005 | Antenna keepout | Define candidate-module antenna clearance and enclosure assumptions | Wireless performance depends on physical implementation | CPU-006; processor feasibility | Before schematic | TBD |
| ODI-MEC-006 | Service access | Define USB, reset, programming, diagnostics, and replacement access | Serviceability affects connector and placement architecture | MEC-001; Mechanical Interface | Before PCB layout | TBD |
| ODI-MEC-007 | Environmental assumptions | Approve board temperature, vibration, coating, and enclosure interfaces | Parts and mechanics require defined qualification targets | ENV-001–ENV-006; testing | Before prototype build | TBD |
