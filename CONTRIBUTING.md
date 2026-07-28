# Contributing to IPC-100

IPC-100 changes must remain reviewable, traceable, and safe for long-term hardware support.

## Branch naming

Use lowercase, hyphenated names in the form `<type>/<short-description>`.

- `feature/add-battery-monitor`
- `fix/correct-relay-pinout`
- `docs/update-test-plan`
- `hardware/rev-a-power-input`
- `chore/update-tooling`

## Commit message conventions

Write imperative, focused commit subjects, preferably no longer than 72 characters.

- `Add Rev A connector definitions`
- `Correct motor supply requirement`
- `Document enclosure inspection criteria`

Keep unrelated changes in separate commits. Explain safety implications, design rationale, and generated-file updates in the commit body when relevant.

## Pull request expectations

Every pull request must:

- State the problem, solution, and affected product or subsystem.
- Identify hardware revision impact and compatibility impact.
- Link relevant requirements, issues, tests, and design reviews.
- Include validation evidence appropriate to the change.
- List known risks, limitations, and follow-up work.
- Avoid mixing generated artifacts with unrelated source changes.
- Receive review from an appropriate hardware, firmware, mechanical, or manufacturing owner.

## Documentation requirements

- Update requirements before or alongside implementation changes.
- Keep connector specifications, GPIO maps, schematics, BOMs, and test plans consistent.
- Add or update diagrams when interfaces or power flow change.
- Record significant changes in `CHANGELOG.md` and revision history.
- Use units, tolerances, connector pin numbers, and signal direction explicitly.
- Cite component datasheets and preserve their manufacturer revision or access date.

## Hardware revision policy

- Use lettered prototype revisions: Rev A, Rev B, and so on.
- Do not silently modify released fabrication data under an existing revision.
- A change affecting form, fit, function, safety, connector pinout, PCB fabrication, or field compatibility requires review for a new hardware revision.
- Documentation-only corrections may remain within a revision when they do not alter the manufactured design; record them in revision history.
- Tag released design packages and retain the exact schematic, PCB, BOM, fabrication, assembly, firmware compatibility, and test records.
- Clearly mark unapproved and work-in-progress outputs; only reviewed packages may be used for manufacturing.

