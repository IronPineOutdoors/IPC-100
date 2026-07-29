# Package 03 — Sheet 02 Implementation Entry-Gate Review

## Status

**Entry-gate conflict resolved by Architecture Resolution Package AR-01 and ADR-039. Package 03R is authorized.**

Preliminary KiCad Capture Package 03 initially stopped before circuitry was added. AR-01 subsequently approved and synchronized the missing interfaces. Sheet 02 remains a circuitry-free placeholder pending Package 03R.

## Blocking conflict

The approved architecture requires Sheet 02 to own main-only, default-off controlled branches including `OLED_VCC`, `SENSOR_VCC`, `UI_VCC`, and `EXPANSION_VCC`. Those branches may turn on only after safe initialization and an approved request. USB-only operation must keep them off.

The approved Sheet 00 symbol and Sheet 02 hierarchical interface provide only these inputs:

- `VIN_PROTECTED`
- `USB_5V_PROTECTED`

No branch-enable request enters Sheet 02. The existing outputs carry power away from Sheet 02 and cannot also serve as control requests.

Consequently:

- tying branch enables high would violate default-off startup and USB-only requirements;
- tying branch enables low would make the released outputs permanently unavailable;
- deriving every enable solely from `MAIN_POWER_GOOD` would bypass the required post-initialization control;
- adding local or hierarchical enable nets would change the frozen platform interface without approval.

This is an interface-definition conflict, not a component-selection detail. It must be resolved before real Sheet 02 objects are placed.

## Additional release dependencies

Even after the enable interface is resolved, detailed capture must retain the existing open decisions:

- `OLED_VCC` and `SENSOR_VCC` voltage domains are not approved.
- `UI_VCC` and `FIELD_SENSE_VCC` branch topologies and released load envelopes are not quantified.
- J2/J3 protected-branch components and backfeed behavior are not selected.
- `MAIN_POWER_GOOD` qualification must combine main-regulator validity with the approved upstream main-source qualification, but Sheet 02 receives no upstream power-good signal.
- Brownout thresholds, hysteresis, discharge behavior, source-transition acceptance criteria, and exact regulator passive networks remain release items.

## Decision required

Architecture review must approve one coherent interface contract before Package 03 resumes. At minimum, that review must define:

1. which main-only branches are hardware-on with valid main power and which are request-controlled;
2. the owner and polarity of every request-controlled branch enable;
3. how those requests cross Sheet 00 into Sheet 02;
4. how `MAIN_POWER_GOOD` incorporates upstream input validity without an unapproved inference;
5. the released supply domain for every voltage-neutral branch name.

Because this decision changes platform cross-sheet interfaces and power-state behavior, it requires an ADR or an accepted revision to the existing power/hierarchy ADRs. This note does not propose or approve that change.

## AR-01 resolution

ADR-039 approves `MAIN_INPUT_VALID`, four active-high Sheet 03 peripheral requests with Sheet 02 pull-down defaults, fixed branch voltage domains, main-only hardware branches, exact power-good semantics, and the USB-only state. See [Power Control Interface Resolution](../../../docs/hardware/Power_Control_Interface_Resolution.md).

## ERC and review disposition

No ERC run is claimed because AR-01 adds hierarchy only. Repository structural validation must confirm the synchronized Sheet 00/01/02/03 ports. Package 03R must run the applicable capture checks after circuitry is added.

## Manual review checklist before resumption

- [x] Enable-request ownership and polarity approved by ADR-039.
- [x] Sheet 00 and Sheet 02 ports approved and synchronized by AR-01.
- [x] USB-only state defined to prevent main-only outputs.
- [x] Peripheral supply voltage domains approved.
- [ ] External branch limits and protection components approved.
- [x] Main-valid qualification source and semantics approved.
- [ ] Brownout numeric thresholds and rail-collapse component values approved during detailed capture.
- [ ] LMR38020-Q1, TPS2121, and TPS62130 detailed design calculations reviewed.
- [x] Package 03R authorization issued against ADR-039.
