# PACS-01R-B1 — Manufacturer, Thermal and Commercial Evidence

Date: 2026-08-01

Platform: IPC-100 Rev A

Baseline: PACS-01R-B commit `cd444be`

## 1. Executive Summary

PACS-01R-B1 reviewed the exact manufacturer thermal data that is currently available, regulator manufacturer guidance, transient SOA information and dated commercial observations. The work confirms no new schematic, architecture, interface or device-selection defect.

The package is not accepted. Complete package-to-IPC-100 PCB correlation cannot be produced before the PCB stackup, copper areas and thermal-via geometry exist; U201/U203 manufacturer design-tool output files are not present; Q101's published SOA is characterized at 25 °C case rather than the required hot enclosure corner; TPS2553 fault heating exceeds the 110 °C design target under the published JEDEC θJA if treated as steady state; and the commercial record is incomplete at the required distributors and quantity breaks. These are evidence gaps, not proof that any selected MPN is unsuitable.

## 2. Scope

All 20 PACS active references were retained. No replacement search was performed. This review changes no schematic, requirement, architecture, GPIO, hierarchy, interface, footprint or PCB artifact and does not begin prototype validation.

## 3. Thermal Correlation

Released boundary: 75 °C internal air, natural convection, no airflow credit, calculated junction target ≤110 °C. Manufacturer θ values apply only to their stated JEDEC/reference boards; TI explicitly cautions that θJA is board-layout dependent. “Open” means the future IPC-100 copper correlation is unavailable.

| Reference(s) | Package | Manufacturer thermal evidence | Released loss | JEDEC/reference-board estimate | Margin to 110 °C | PCB requirement / realism | Result |
| --- | --- | --- | ---: | ---: | ---: | --- | --- |
| Q101 | PG-TDSON-8 5×6 | Infineon Rev. 1.1 publishes SOA and ZθJC curves; exact hot-board θJA/θJB not controlled | 0.10 W at 2 A screening | Open | Open | Manufacturer land and drain copper are realistic, but hot SOA correlation is absent | OPEN |
| U101 | PWP-20 PowerPAD | TI TPS2663 thermal table/layout guidance; exact IPC board correlation absent | 0.124 W typical at 2 A | Open | Open | Four-layer exposed-pad copper/vias realistic | OPEN |
| U102 | RPW-10 | TI TPS25947 package metrics/layout guidance; exact board correlation absent | ≈0.014 W at 0.5 A screening | Open | Open | Exposed-pad copper realistic | OPEN |
| U201 | DDA-8 PowerPAD | Manufacturer thermal/layout guidance exists; no archived WEBENCH board/loss result | ≤1.324 W | Requires effective θJA ≤26.4 °C/W | 0 °C at screening ceiling | Four-layer pad/via solution is plausible but unproved | OPEN |
| U202 | RUX-12 | TI datasheet provides package metrics, including θJB 15.4 °C/W and θJC(top) 38.5 °C/W for the documented family; exact RUX/board use must be confirmed | 0.126 W hot-path screening | Open | Open | Exposed-pad copper realistic | OPEN |
| U203 | RGX-11 | TI thermal/layout guidance exists; no archived tool/copper result | ≤0.582 W | Requires effective θJA ≤60.1 °C/W | 0 °C at screening ceiling | Continuous ground copper realistic but unproved | OPEN |
| U204 | DCK-5 | TI JEDEC metrics available; low-loss logic | <0.010 W | Low rise expected | Positive but unquantified on IPC board | Standard land realistic | OPEN |
| U205 | PW-14 | TI JEDEC metrics available; low-loss logic | <0.020 W | Low rise expected | Positive but unquantified | Standard land realistic | OPEN |
| U206/U207/U208/U210/U211 | DBV-6 | TPS22918-Q1 thermal table and Equation 14; TI states θJA is highly layout dependent | <0.002 W each | Low rise expected | Positive but unquantified | Recommended DBV copper realistic | OPEN |
| U209/U212/U213 | DBV-6 | TPS2553-Q1 Rev. B: θJA 182.6, θJC(top) 122.2, θJB 29.4 °C/W | 0.734 W (3.3 V) / 1.112 W (5 V) fault screening | 209 °C / 278 °C if steady-state θJA were misapplied | Negative | Fault must be transient/thermally limited; recommended copper alone does not prove compliance | OPEN — transient required |
| U302 | DSE-6 | TI TPS3890-Q1 package metrics available; low Iq | <0.010 W | Low rise expected | Positive but unquantified | DSE exposed-pad/ground treatment realistic | OPEN |
| U706/U707 | DGK-8 | TI package metrics available; device maximum ambient +85 °C | <0.020 W each | Low self-rise | Only 10 °C ambient headroom | Separation from hot stages is realistic; enclosure correlation required | OPEN |
| U801 | DSE-6 | TI TPS3899 package metrics available; low Iq | <0.005 W | Low rise expected | Positive but unquantified | DSE grounding realistic | OPEN |

θJC and θJB are not interchangeable with θJA, and ψJT is a characterization parameter rather than junction-to-case resistance. Without the eventual copper geometry, claiming exact junction temperatures would be false precision. Package recommendations are retained as layout constraints, not footprint assignments.

## 4. Regulator Tool Evidence

### U201 — LMR38020FSQDDARQ1

Manufacturer evidence supports 4.2–80 V operation, 2 A, forced PWM/spread spectrum, adjustable frequency and the corrected 64.9 kΩ/400 kHz programming. PPQ requires 9–21 V normal operation, 55 V stress coordination, 5 V/1.5 A continuous, 2 A/100 ms, ≥85% efficiency, ≤1.324 W loss and effective θJA ≤26.4 °C/W. TI guidance requires the recommended DDA exposed-pad layout, input bypass at VIN/GND, a short switch loop, and manufacturer-qualified inductor/output-capacitor choices.

No controlled WEBENCH/export file exists for the exact input/load/capacitor/inductor corners. Therefore efficiency, hot switch loss, loop behavior, minimum-time operation and the selected passive set are not manufacturer-tool closed.

### U203 — TPS62135RGXR

Manufacturer evidence supports 3–17 V, 4 A, 2.5 MHz DCS-Control, adjustable soft start, forced-PWM/AEE operation, PGOOD and active discharge. PPQ requires 4.4–5.25 V input, 3.3 V/1 A continuous, 1.5 A/100 ms, ≤0.582 W loss and effective θJA ≤60.1 °C/W. TI guidance supports the short high-current loop, continuous ground plane, recommended 2.2 µH class and qualified ceramic input/output capacitance.

No controlled manufacturer-tool or reference-design calculation proves the exact C208/C209/L202 effective values, hot ripple/loss and thermal result at every released corner. Equivalent narrative datasheet guidance is insufficient because both regulators sit at the PPQ thermal screening boundary.

## 5. Transient SOA Review

| Device | Event | Manufacturer evidence | Coordination result |
| --- | --- | --- | --- |
| Q101 | reverse path, 2 A/100 ms, surge/inrush | Infineon Rev. 1.1 publishes 25 °C-case SOA and single-pulse ZθJC curves | Cannot extrapolate to +75 °C board/case without the thermal path; OPEN |
| U101 | startup 4 A/10 ms, overload, surge stop, reverse polarity | TPS26631 pulse support, current limit, thermal shutdown and external reverse-FET control are documented | Exact PLIM/ILIM/dVdt, hot pulse and Q101 coordination remain OPEN |
| U209 | 3.3 V short/overload | TPS2553 current limiting, 2 µs short response, reverse-voltage shutdown and thermal protection documented | 0.734 W fault screen requires transient Zθ/retry waveform; OPEN |
| U212/U213 | 5 V short/overload | Same; QER-02 162.824–222.345 mA window passes | 1.112 W fault screen requires transient Zθ/retry waveform; OPEN |

Normal TPS2553 conduction at 100 mA and 85 mΩ is approximately 0.85 mW. The fault case, not normal load, controls. Protection is expected to limit duration, but no manufacturer transient thermal curve/retry capture tied to the released branch capacitance proves the 110 °C target. Reverse-current behavior remains compatible with the intended topology but awaits bench confirmation.

## 6. Commercial Evidence

All selected devices remain manufacturer `ACTIVE`; Q101 is active/preferred with availability planned through at least 2037. DigiKey is the preferred planning distributor and Mouser the alternate. Existing records identify tape/reel or cut-tape packaging and quantity-one prices for 18 preserved candidates. U101 was observed on 2026-08-01 at DigiKey with 2,882 units, nine-week standard lead time, MOQ 1 cut tape, and USD 4.52/3.431/2.8573 at quantities 1/10/100; no 1000-unit price was listed. TPS2553 observations have varied between zero and several thousand units, so PO-date revalidation is mandatory.

The requested complete commercial matrix cannot be closed from the controlled evidence:

- U101 and U801 lack all four requested price breaks.
- Most rows lack quantity 10/100/1000 prices, current lead time and MOQ.
- Mouser SKU/stock evidence is not recorded for every MPN.
- No cross-manufacturer drop-in alternate is approved.
- Distributor data is volatile and cannot establish future availability.

All active devices remain single-source design selections. Authorized-channel purchasing controls counterfeit risk. Commercial status is `OPEN`, not a reason to substitute a device without an ECO.

## 7. Risk Matrix

| Evidence gap | References | Severity | Consequence |
| --- | --- | --- | --- |
| Exact IPC-board thermal correlation unavailable | All | Major | Junction margin cannot be released |
| Regulator tool archives absent | U201/U203 and dependent passives | Critical | Stability, loss and thermal assumptions remain coupled |
| Hot transient SOA not demonstrated | Q101/U101/U209/U212/U213 | Critical | Fault temperature/protection timing not released |
| Commercial matrix incomplete | All | Major | Sourcing, price and alternate gates remain open |
| Prototype-only behavior | Source transition, thresholds, fault waveforms, enclosure thermals | Major | Reserved for PACS-01R-C after analytical closure |

## 8. Remaining Prototype Evidence

The previously released PACS-01R-C test matrix remains necessary: closed-enclosure thermal correlation; Q101/U101 pulse waveforms; regulator startup/load-step/ripple/efficiency; source-transition ordering; branch inrush/fault tests; U302 timing; I²C partial-power/stuck-bus tests; and U801 threshold/delay sweeps. PACS-01R-B1 does not execute these tests.

## 9. Validation Results

The targeted validator confirms all 20 active references, thermal groups, both regulators, Q101/U101/TPS2553 SOA coverage, lifecycle/commercial evidence, the explicit incomplete decision and zero-CAD scope. All repository validators and `git diff --check` are required. Native ERC remains pending because `kicad-cli` is unavailable; no schematic changed.

## 10. Final Decision

# PACS-01R-B1 NOT ACCEPTED

PACS-01R-C and PPC-01 are not authorized. The smallest corrective package remains **PACS-01R-B1R — Controlled Tool Exports, Thermal-Board Definition and Commercial Quote Capture**. It requires external manufacturer-tool runs, a released preliminary thermal PCB geometry (without footprint assignment), and dated distributor/manufacturer quote capture. Those external inputs do not presently exist in the repository and cannot be replaced by generic assumptions.
