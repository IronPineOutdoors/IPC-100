# IPC-100 Design Decisions

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Design Decisions |
| Platform | Iron Pine IPC-100 |
| Hardware revision | Rev A |
| Document status | Architecture and requirements definition |
| Last updated | 2026-07-28 |
| Owner | Iron Pine Outdoors Engineering |

## 1. ADR conventions

Statuses are `Accepted`, `Proposed`, `Superseded`, or `Rejected`. Accepted decisions govern Rev A until superseded through review.

## 2. Decision records

### ADR-001: IPC-100 is a reusable platform

- **Decision ID:** ADR-001
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Multiple Iron Pine products need common controller capabilities.
- **Decision:** IPC-100 is a reusable controller platform, not the CrossWind product.
- **Consequences:** Platform documents and base firmware remain product-neutral.
- **Alternatives considered:** A CrossWind-specific motherboard; separate controllers for every product.
- **Follow-up actions:** Maintain explicit platform/product boundaries in reviews.

### ADR-002: Revision numbering starts at Rev A

- **Decision ID:** ADR-002
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Predecessor controller concepts used unrelated revision histories.
- **Decision:** IPC-100 hardware revision numbering begins at Rev A.
- **Consequences:** Predecessor work is reference history and does not make IPC-100 Rev D.
- **Alternatives considered:** Continue a predecessor revision sequence.
- **Follow-up actions:** Apply the revision policy in [Revision History](../revisions/Revision_History.md).

### ADR-003: Motor drivers remain external

- **Decision ID:** ADR-003
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Products may require different motors and driver ratings.
- **Decision:** Motor-driver modules remain external to the IPC-100 motherboard.
- **Consequences:** IPC-100 provides low-current logic interfaces only.
- **Alternatives considered:** Integrated H-bridges; product-specific motherboard variants.
- **Follow-up actions:** Verify interface voltage, protection, and boot-safe behavior.

### ADR-004: Motor power bypasses IPC-100

- **Decision ID:** ADR-004
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Motor current creates thermal, fault-energy, and noise risks.
- **Decision:** High-current motor power must not pass through IPC-100.
- **Consequences:** Products require separately fused high-current distribution.
- **Alternatives considered:** Board-level motor-power buses.
- **Follow-up actions:** Enforce the boundary in schematics, connectors, and tests.

### ADR-005: Battery hardware is product-level

- **Decision ID:** ADR-005
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Battery mounting and distribution depend on product mechanics and loads.
- **Decision:** Battery mounts and main power distribution are product-level hardware.
- **Consequences:** IPC-100 defines only its allowable electrical input.
- **Alternatives considered:** A universal on-board battery adapter.
- **Follow-up actions:** Define J1 limits and upstream protection assumptions.

### ADR-006: Normal input range is 9–21 V DC

- **Decision ID:** ADR-006
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** The primary Rev A integration case is an external nominal 18 V lithium-ion tool-battery system, with DeWalt 20V MAX as the initial reference implementation; standalone nominal 12 V systems are also intended.
- **Decision:** IPC-100 accepts 9–21 V DC during normal operation without depending on a specific battery brand.
- **Consequences:** The transient-survival profile and associated protection and derating remain TBD. Direct vehicle charging-system and automotive load-dump qualification are outside the approved baseline.
- **Alternatives considered:** 12 V-only input; product-specific regulators.
- **Follow-up actions:** Select and verify the input power components.

### ADR-007: Physical controls remain available

- **Decision ID:** ADR-007
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Wireless control alone is insufficient for safe field equipment operation.
- **Decision:** Product designs retain accessible physical controls; IPC-100 provides ARM, FIRE, and STOP inputs.
- **Consequences:** The system is not app-only.
- **Alternatives considered:** Wireless-only user control.
- **Follow-up actions:** Define input protection and product-level control behavior.

### ADR-008: Thrower interface uses dry contacts

- **Decision ID:** ADR-008
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** External trigger circuits require electrical separation and product flexibility.
- **Decision:** The universal thrower interface uses isolated `RELAY_NC`, `RELAY_COM`, and `RELAY_NO` contacts.
- **Consequences:** IPC-100 does not source thrower power; contact ratings remain TBD.
- **Alternatives considered:** Powered output; open-drain output.
- **Follow-up actions:** Select a relay and verify isolation, ratings, and fail-open behavior.

### ADR-009: Separate dirty and clean power

- **Decision ID:** ADR-009
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** External motors create conducted and radiated noise.
- **Decision:** Product high-current power and IPC-100 clean logic power use separate branches and controlled grounding.
- **Consequences:** Wiring, filtering, and return paths must preserve segregation.
- **Alternatives considered:** A shared daisy-chained motor/logic branch.
- **Follow-up actions:** Validate noise immunity during product integration.

### ADR-010: Blueprint precedes schematic work

- **Decision ID:** ADR-010
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Uncontrolled schematic work risks contradictory interfaces.
- **Decision:** The Engineering Blueprint must be reviewed before additional schematic blocks are added.
- **Consequences:** Requirements and interfaces act as schematic-entry gates.
- **Alternatives considered:** Document after schematic capture.
- **Follow-up actions:** Resolve critical TBD items and approve the blueprint.

### ADR-011: CrossWind remains separate

- **Decision ID:** ADR-011
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** CrossWind contains product-specific mechanics, wiring, behavior, and verification.
- **Decision:** CrossWind remains a separate external repository that consumes IPC-100.
- **Consequences:** CrossWind-specific artifacts are excluded here.
- **Alternatives considered:** A monorepository.
- **Follow-up actions:** Version the interface consumed by CrossWind.

### ADR-012: IPC numbering is for controller platforms

- **Decision ID:** ADR-012
- **Date:** 2026-07-28
- **Status:** Accepted
- **Context:** Product and controller identifiers require an unambiguous namespace.
- **Decision:** IPC numbering is reserved for Iron Pine controller platforms.
- **Consequences:** Product identifiers use their own naming systems.
- **Alternatives considered:** Use IPC numbers for products and boards interchangeably.
- **Follow-up actions:** Apply this convention to future platform planning.
