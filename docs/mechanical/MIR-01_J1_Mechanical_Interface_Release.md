# MIR-01 — J1 Mechanical Interface Release

| Field | Released value |
|---|---|
| Platform | IPC-100 Rev A |
| Package | Package 11A-M |
| Interface | J1 controller input / H01 harness |
| Status | Accepted mechanical requirement baseline |
| Electrical contacts | Pin 1 `VIN_RAW`; Pin 2 `GND` |
| Selection stage | Connector family and MPN may be selected in CSR-01A-R2 |
| Explicit exclusions | Footprints, schematic changes, PCB work, enclosure-part selection |

## Executive Summary

J1 is the removable two-contact input-power interface between the product's fused 9–21 VDC supply branch and the IPC-100 controller. MIR-01 releases the physical requirements needed to select an exact connector family during CSR-01A-R2 without changing the electrical architecture or ICD-002.

J1 shall use a shrouded, polarized, keyed, positive-latch, right-angle board header mated to a field-replaceable crimp receptacle on harness H01. The mating axis and cable exit are parallel to the PCB and directed toward the enclosure cable-entry/service side. J1 is not a panel connector and is not intentionally live-mated. The product enclosure or a separate sealed cable gland/feedthrough owns the environmental boundary; J1 remains enclosure-protected with no exposed live metal.

This release freezes performance and geometry constraints, not a manufacturer, series, terminal, housing, footprint, or enclosure part number.

## 1. Functional Role

| Attribute | Requirement |
|---|---|
| System function | Deliver the product's fused controller-only supply to IPC-100 |
| Circuit | Two conductors: `VIN_RAW` and dedicated controller `GND` return |
| Normal voltage | 9.0–21.0 VDC at the board boundary |
| Connector voltage rating | At least 30 VDC |
| Continuous design current | 2.0 A interface capability; released controller allocation remains lower where QER-01 limits it |
| Peak/inrush | 4 A maximum for 10 ms at cold start; connector/harness shall also tolerate 3 A for 1 s without damage or latch disturbance |
| Fault current | Upstream product fuse/current limiter and Sheet 01 protection own fault interruption; H01/J1 shall survive the released 4 A/10 ms inrush and foreseeable protected fault until protection acts |
| Return | Pin 2 is a direct controller power return; it shall not carry product motor, actuator, chassis, or shield current |
| Hot plug | Intentional live mating prohibited; disconnect upstream power before mate/unmate |
| Accidental live mate | Must not create damage or unsafe authorization when tested at the released voltage/current; controlled recovery may be required |
| Service role | Tool-accessible controller disconnect after enclosure opening and source isolation |
| Environment | Inside product enclosure; −20 to +75 °C operating air, −40 to +85 °C storage, 5–95% RH noncondensing |
| Product qualification | IP54 minimum enclosure target; 5–500 Hz, 2 g RMS vibration; 20 g/11 ms shock |

The power source and its fuse remain product-owned. J1 carries controller current only. Motor and other high-current product distribution shall not pass through J1 or the IPC-100 PCB.

## 2. Mechanical Requirements

### 2.1 Released construction

- Board side: shrouded, right-angle, through-hole header with two electrical contacts and positive housing retention. Integral board-lock or mechanical hold-down features are preferred and become mandatory if the chosen contact system cannot pass the harness-pull test without solder-joint loading.
- Harness side: discrete-wire crimp receptacle housing with individually replaceable female contacts and a latch that cannot be defeated by normal cable motion.
- Contact gender: no energized pin or conductive surface may be finger-accessible during normal service handling; the source-side harness shall use recessed female contacts.
- Polarization: asymmetric housing geometry shall make 180° reverse insertion impossible without damage-producing misuse.
- Keying: J1 shall not mate with any other IPC-100 harness connector or commonly adjacent product connector carrying an incompatible voltage or function.
- Latch: positive mechanical latch with deliberate release action; friction-only retention is prohibited.
- Contact sequencing: simultaneous power/return engagement is acceptable because intentional live mating is prohibited. A shell or shield contact is not required.
- Materials: housing shall be UL 94 V-0 or better, resistant to expected enclosure cleaners, and rated for −40 to +105 °C minimum material temperature.

### 2.2 Dimensional envelope

The exact connector must fit all of the following family-neutral constraints:

| Item | Maximum/minimum constraint |
|---|---|
| Board-header body envelope | 22 mm wide × 16 mm deep × 14 mm above PCB maximum, excluding solder tails |
| PCB edge setback | Connector body may approach within 3 mm of the board edge; copper/fastener rules remain PCB-stage work |
| Mating clearance | 35 mm minimum unobstructed from header face along the mating axis |
| Latch access | 12 mm minimum finger/tool clearance above and around the release feature |
| Side clearance | 5 mm minimum from the mated housing to rigid enclosure features |
| Rear wire-bend zone | Straight, unloaded wire run for at least 25 mm after the housing/strain relief |
| Board retention | Mated harness pull shall not transfer more than the connector manufacturer's permitted load to solder joints |

These are future placement/keep-out constraints, not a footprint assignment or PCB placement authorization.

## 3. Cable Requirements

H01 is the controlled two-conductor cable from the product's fused controller supply branch to J1.

| Attribute | Released requirement |
|---|---|
| Conductor | Stranded copper; tinned copper preferred where condensation/corrosion risk exists |
| Gauge | 18 AWG for the full released envelope |
| Strand construction | At least 16 strands per conductor; at least 26 strands preferred for service-flex routing |
| Ampacity | At least 5 A manufacturer rating at the actual bundle and enclosure temperature; released 2 A continuous current shall be no more than 67% of rating |
| Length | 1.0 m maximum end-to-end from protected source branch to J1 |
| Voltage drop | 0.50 V maximum loop drop at 2.0 A and +75 °C, including wire, two crimp terminations, and mated contacts |
| Insulation voltage | At least 60 VDC |
| Insulation temperature | 105 °C minimum |
| Insulation type | Flexible cross-linked polyolefin or abrasion-resistant PVC suitable for the product enclosure; oil/UV resistance required if the product route is exposed before enclosure entry |
| Flexibility | Low-flex/service-flex; not a continuous-flex cable-chain rating unless a product-specific route requires it |
| Minimum bend radius | Six times finished cable outside diameter or the cable manufacturer's larger value |
| Service loop | 50–100 mm inside the enclosure, restrained away from mechanisms, sharp edges, heat sources, airflow paths, and the RF antenna keepout |
| Strain relief | Required at enclosure entry and within 50 mm of J1; no steady load on crimp contacts or board header |
| Shield | None; shield or drain conductor is prohibited as the power return |
| Pairing | `VIN_RAW` and `GND` routed together as a pair; keep separated from motor leads where practical |

At 20 °C, typical 18 AWG copper resistance is approximately 21 mΩ/m per conductor. A 1 m, two-conductor loop is therefore about 42 mΩ and drops about 0.084 V at 2 A. Applying a conservative 1.22 temperature factor at 75 °C gives about 0.103 V. Adding two 10 mΩ mated-contact paths and a conservative 20 mΩ total for four crimps gives approximately 0.163 V, leaving substantial margin to the 0.50 V limit. Production acceptance is based on the measured limit, not this typical calculation.

## 4. Connector Requirements

| Attribute | Frozen selection requirement |
|---|---|
| Contacts | Two |
| Pin assignment | Pin 1 `VIN_RAW`; Pin 2 `GND` |
| Manufacturer current rating | At least 5 A per contact at the applicable contact count and +75 °C condition, or documented derating that leaves 2 A at no more than 67% |
| Voltage rating | At least 30 VDC |
| Initial contact resistance | 10 mΩ maximum per mated contact path |
| End-of-life resistance | 40 mΩ maximum per path after environmental and mating-cycle qualification |
| Temperature rise | 20 °C maximum above local enclosure air at 2 A continuous with the released wire and complete mated pair |
| Locking | Positive latch; deliberate release required |
| Keying/polarization | Mechanically polarized and uniquely keyed against incompatible IPC-100/product harnesses |
| Mating durability | At least 100 complete mate/unmate cycles |
| Retention | At least 20 N axial unmating force without latch release after strain relief; no intermittent contact during the pull |
| Vibration | No discontinuity, unlatching, damage, or resistance outside limits during QER-01 2 g RMS profile |
| Shock | No unlatching, damage, or resistance outside limits after QER-01 20 g profile |
| Sealing | J1 itself may be unsealed only when fully inside the product's IP54-or-better protected volume; otherwise a sealed family and rear-wire seal are mandatory |
| Terminal style | Open-barrel or closed-barrel crimp terminal approved by the connector manufacturer for the selected 18 AWG wire |
| Plating | Corrosion-resistant manufacturer-standard contact finish suitable for low-voltage DC power and 100-cycle life; bare base-metal contacts prohibited |
| Repairability | Housing contacts individually extractable with a released service tool; connector/harness replaceable without PCB removal where enclosure architecture permits |
| Tooling | Manufacturer-approved production applicator or ratcheting hand tool, locator, and extraction tool; generic pliers prohibited |
| Agency/material | UL 94 V-0 housing; RoHS-compliant order codes; 10-year lifecycle evidence required by component selection |

## 5. Panel and Enclosure Requirements

J1 is board-mounted, not panel-mounted. H01 enters the enclosure through a separate product-owned cable gland, bulkhead feedthrough, or sealed harness entry. The entry component shall maintain the product ingress target and provide the first strain-relief point. It shall not reinterpret J1 pin numbering or add an unfused branch.

- Orientation: right-angle board header with mating direction parallel to the PCB, aimed toward the service/cable-entry side.
- Accessibility: latch visible and operable after opening the designated service cover, without removing unrelated assemblies.
- Service replacement: H01 can be disconnected after upstream isolation; PCB-side header replacement remains depot-level solder repair.
- Clearance: honor the dimensional envelope and keep the harness away from fan/air paths, moving mechanisms, hot surfaces, high-current motor wiring, sharp sheet-metal edges, and the ESP32 antenna keepout.
- Labeling: enclosure/service drawing shall identify `J1 POWER INPUT`, voltage range `9–21 VDC`, and power-off servicing. Pin-1 polarity marking must remain visible with the harness removed.
- Cable exit: straight toward the enclosure entry for at least 25 mm, then bend only at or beyond the released bend radius.
- Water management: route entry below sensitive electronics where practical and provide a product-level drip loop. J1 shall not be placed in a foreseeable water collection pocket.

## 6. Harness Requirements

| Field | H01 release |
|---|---|
| Harness identifier | `H01 — IPC-100 CONTROLLER POWER INPUT` |
| Connector designation | `J1` at IPC-100 end |
| Pin 1 | Red, 18 AWG, `VIN_RAW`, label `J1-1 VIN_RAW +` |
| Pin 2 | Black, 18 AWG, `GND`, label `J1-2 GND −` |
| Source end | Product-specific fused controller branch; termination released in product harness documentation |
| Labels | Permanent heat-shrink or equivalent at both ends; harness ID, revision, and polarity required |
| Pair | Conductors bundled together; no shared return with motors or actuators |
| Shield | None |
| Loom | Abrasion sleeve where routed across edges or alongside other harnesses |
| Strain relief | Enclosure-entry restraint plus secondary tie/clip within 50 mm of J1 |
| Service documentation | Assembly drawing, cut list, wire/terminal order codes, strip length, crimp height, tool/die, pull-test limit, pin-view drawing, and continuity table |

Pin numbering shall be defined using a mating-face view of the board header and repeated using a wire-entry view of the receptacle. Drawings must state the view explicitly; mirrored, unlabeled pin diagrams are prohibited.

## 7. Failure Analysis

| Failure mode | Effect | Required prevention/detection/response |
|---|---|---|
| Connector unplugged | `VIN_RAW` absent; controller powers down or remains bounded USB-only | Outputs deauthorize; service procedure isolates source first |
| Reverse insertion | Reversed polarity could stress input | Asymmetric polarization/keying prevents insertion; Sheet 01 reverse protection is secondary defense |
| Partial insertion | Intermittent supply, heating, brownout | Positive latch, visual seating witness, pull check; QER brownout behavior keeps outputs unauthorized |
| Accidental hot plug | Inrush/arcing/contact bounce | Not an operating mode; source-off label/procedure; qualification test verifies no damage/unsafe authorization |
| Overcurrent/short | Harness heating or contact damage | Product fuse/current limiter upstream; Sheet 01 protection downstream; wire/contact derating and fault test |
| Wrong connector | Wrong voltage/polarity/function | Unique key, incompatible housings, color/labels, keyed assembly fixture |
| Broken latch | Fretting/intermittency or unplugging | Reject during inspection; harness restraint prevents cable load; field replacement required |
| Wire pull-out | Open/intermittent conductor | Controlled crimp tooling, conductor/insulation crimp inspection, production pull test, secondary strain relief |
| High resistance | Voltage loss and local heating | Crimp-height control, millivolt-drop/temperature-rise qualification, contact resistance and end-of-life limits |
| Corrosion | Rising resistance/intermittency | Enclosure ingress control, suitable plating/tinned wire, noncondensing placement, environmental qualification |
| Water ingress | Leakage, corrosion, short | IP54-or-better product boundary, sealed entry, drip management; sealed J1 required if boundary cannot protect it |
| Ground conductor open | Loss of power/reference; possible intermittent resets | Dedicated equal-gauge return, continuity test, strain relief; no shield/chassis substitution |
| Pin short during service | Source fault | Upstream isolation and fuse; recessed source contacts; no exposed live metal |

No single listed J1 fault may create actuator authorization. Loss or instability of J1 shall remove valid main-power authorization.

## 8. Manufacturing Notes

### 8.1 Assembly method

1. Cut and strip released 18 AWG wire using controlled equipment and terminal-specific strip length.
2. Crimp with the connector manufacturer's approved applicator or calibrated ratcheting tool and locator.
3. Inspect conductor brush, bellmouth, conductor crimp, insulation support, seal position if used, and terminal locking lance.
4. Insert red `VIN_RAW` terminal into cavity 1 and black `GND` terminal into cavity 2 until primary lock engagement is verified by a light tug.
5. Install any specified secondary lock, labels, loom, and strain-relief hardware.
6. Record harness revision and lot/assembler traceability.

Soldering crimp terminals is prohibited unless the terminal manufacturer explicitly specifies that process. Hand-twisted, spliced, or doubled conductors at J1 are prohibited.

### 8.2 Inspection and test

- 100% visual inspection of housing, polarization, latch, terminal seating, wire color, labels, insulation support, and damage.
- First-article and tool-change crimp-height/width measurement against the terminal application specification.
- Pull testing per the terminal manufacturer's 18 AWG requirement; absent a higher manufacturer limit, each crimp shall withstand 80 N without pull-out or conductor break at the crimp.
- 100% continuity and pin-map test: J1-1 to source positive, J1-2 to source return, no cross-short, and no continuity to shield/chassis unless the product drawing explicitly defines it elsewhere.
- Production loop-resistance screen at a controlled current; engineering qualification demonstrates the 0.50 V maximum at 2 A/+75 °C.
- First-article temperature-rise, vibration, shock, 100-cycle durability, retention, and ingress-system tests.

### 8.3 Field replacement

Field service replaces H01 as an assembly. Individual terminal repair is permitted only for trained service personnel using released extraction/crimp tooling and the controlled pin-view drawing. The board header is not a routine field-replaceable item. Any broken latch, overheated/discolored housing, corroded contact, loose terminal, or damaged polarization feature requires replacement of the affected mating half and inspection of its counterpart.

## 9. Future Footprint Constraints

CSR-01A-R2 may select the exact connector family and order codes. A later footprint package shall:

- implement the selected right-angle through-hole header pin pattern and all manufacturer retention/board-lock holes;
- preserve Pin 1 = `VIN_RAW`, Pin 2 = `GND` and visible polarity/pin-1 markings;
- verify creepage/clearance for the 30 VDC-rated interface and the QER transient environment;
- place J1 near the enclosure/service-side PCB edge while respecting the released keep-out and mating-clearance envelope;
- prevent harness loads from acting on solder joints;
- keep input surge/high-current loops short and away from RF, analog sense, and low-level interfaces;
- provide connector-entry protection placement consistent with Sheet 01 ownership; and
- include 3D/enclosure interference, latch access, cable bend, tool access, and assembly-sequence checks.

No footprint is selected or authorized by MIR-01. If no candidate fits every requirement and envelope, CSR-01A-R2 shall return `J1` as blocked rather than weaken this release silently.

## 10. Selection and Verification Checklist

- [x] Function, voltage, current, return, fault ownership, service, and environment defined.
- [x] H01 gauge, drop, strand, insulation, temperature, flex, bend, service-loop, strain-relief, and length requirements defined.
- [x] Connector electrical, mechanical, retention, durability, vibration, shock, environmental, terminal, repair, and tooling requirements frozen.
- [x] Board/header, enclosure-entry, orientation, accessibility, keep-out, and cable-exit architecture released.
- [x] Harness identity, colors, labels, pin numbering, shield disposition, and service documentation released.
- [x] Foreseeable failure modes and manufacturing controls dispositioned.
- [x] Future footprint constraints recorded without assigning a footprint.
- [x] No schematic, PCB, GPIO, ADR, or ICD change required.
- [ ] Exact manufacturer series, housing, header, contacts, tools, and alternates selected in CSR-01A-R2.
- [ ] Physical qualification evidence completed before production release.

## Final Decision

# MIR-01 ACCEPTED

CSR-01A-R2 Power Component Selection Final Pass is authorized. CSR-01B, footprint assignment, PCB placement, routing, and production release are not authorized by MIR-01.
