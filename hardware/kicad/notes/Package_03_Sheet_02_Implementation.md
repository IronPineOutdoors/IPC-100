# Package 03 — Sheet 02 Implementation Entry-Gate Review

## Status

**Blocked before schematic modification.**

Preliminary KiCad Capture Package 03 cannot be implemented without changing or contradicting frozen cross-sheet interfaces. Sheet 02 remains the Package 01 placeholder. Sheet 01 and Sheet 00 are unchanged.

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

## ERC and review disposition

No ERC run is claimed for Package 03 because no Sheet 02 circuit was captured. The repository hierarchy remains in its last validated Package 02 state.

## Manual review checklist before resumption

- [ ] Enable-request ownership and polarity approved.
- [ ] Sheet 00 and Sheet 02 ports approved and synchronized.
- [ ] USB-only state proven unable to energize main-only outputs.
- [ ] Peripheral supply voltage domains approved.
- [ ] External branch limits and protection components approved.
- [ ] Main-valid qualification source approved.
- [ ] Brownout and rail-collapse thresholds approved.
- [ ] LMR38020-Q1, TPS2121, and TPS62130 detailed design calculations reviewed.
- [ ] Package 03 authorization reissued against the revised frozen interface.
