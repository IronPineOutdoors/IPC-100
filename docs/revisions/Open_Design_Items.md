# IPC-100 Open Design Items

| Document control | Value |
| --- | --- |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Purpose | Consolidate unresolved engineering decisions and release gates |
| Status | Active register |
| Owner | Iron Pine Outdoors Engineering |

`TBD` identifies an unresolved decision, not permission to select an implementation without the required review. Closing an item requires updates to every dependent controlled document.

## Processor

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-CPU-001 | Final ESP32 module | Approve exact module variant | Controls pinout, memory, radio, lifecycle, and USB options | Requirements, GPIO, power, PCB | Before schematic release | TBD |
| ODI-CPU-002 | GPIO sufficiency | Prove required functions fit before optional provisions | Prevents resource overcommitment | GPIO map, connectors, expansion | Before schematic release | TBD |
| ODI-CPU-003 | Memory sufficiency | Define program, runtime, storage, and reserve needs | Controls module suitability | Firmware architecture, processor approval | Before firmware architecture release | TBD |
| ODI-CPU-004 | USB architecture | Select native USB or USB-to-UART approach | Affects processor, GPIO, power, service behavior | J13, GPIO, power | Before schematic release | TBD |
| ODI-CPU-005 | Boot-straps and allocation | Approve reset, boot, programming, and strap-safe allocation | Prevents boot and safe-state conflicts | GPIO map, all interfaces | Before schematic release | TBD |
| ODI-CPU-006 | Watchdog strategy | Define supervision, timeout, and recovery behavior | Affects output safety and diagnostics | Firmware, testing, outputs | Before firmware release | TBD |

## Power

| ID | Topic | Decision needed | Why it matters | Dependencies | Required review stage | Status |
| --- | --- | --- | --- | --- | --- | --- |
| ODI-PWR-001 | Regulator architecture | Approve 5 V and 3.3 V sources and components | Defines rail capability and thermal behavior | Power architecture, budget, schematic | Before schematic release | TBD |
| ODI-PWR-002 | Controller current budget | Close all typical, peak, startup, and simultaneous cases | Prevents undersized input and rails | Power budget, component selection | Before schematic release | TBD |
| ODI-PWR-003 | Expansion reserves | Allocate J10, J11, communications, and daughterboard reserves | Prevents optional loads from displacing required loads | Power budget, connectors | Before connector release | TBD |
| ODI-PWR-004 | USB power behavior | Define USB-only scope and source interaction | Controls service, startup, shutdown, and backfeed | J13, output states, testing | Before schematic release | TBD |
| ODI-PWR-005 | Backfeed protection | Approve protection among USB, rails, and external modules | Independently powered interfaces may inject power | Power, expansion, outputs | Before schematic release | TBD |

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

