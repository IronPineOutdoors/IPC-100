# PACS-01R-B1R-X Manual External Acquisition Queue

## Priority 1 — U201 WEBENCH export

- Reference/MPN: U201 / `LMR38020FSQDDARQ1`
- Website/tool: TI WEBENCH Power Designer from the LMR38020-Q1 product page.
- Account: TI account if prompted; never store credentials in the repository.
- Steps: enter 9 V minimum, nominal operating point selected by the reviewer, 21 V maximum normal, 5.0 V output, 1.5 A continuous, 2 A/100 ms transient, 400 kHz, +75 °C internal air and ≥85% efficiency; select the FS variant; preserve every user adjustment; export PDF, BOM, operating values, efficiency/loss/thermal plots, schematic, magnetics/capacitors, warnings and stability data.
- Destination: `docs/evidence/manufacturer-tools/U201/acquired/`.
- Control: record tool version, generated timestamp, URL, account context without identity secrets, file size and SHA-256.
- Acceptance: exact MPN and inputs; numerical exports reproduce; recommendations compared to schematic/PPQ/PAS.
- Automation failure: interactive session/export unavailable to this execution environment.

## Priority 1 — U203 WEBENCH export

- Reference/MPN: U203 / `TPS62135RGXR`.
- Website/tool: current TI WEBENCH or official TPS62135 design utility.
- Steps: enter 4.4/5.0/5.25 V input corners, 3.3 V output, 1.0 A continuous, 1.5 A/100 ms transient, +75 °C internal air, forced-PWM/AEE cases and released ripple targets; export all artifacts listed for U201, including effective capacitance, 2.2 µH-class magnetics, soft-start and stability results.
- Destination/control/acceptance: `docs/evidence/manufacturer-tools/U203/acquired/`, with the same metadata and checksum requirements.
- Automation failure: interactive manufacturer tool unavailable.

## Priority 1 — Hot SOA manufacturer support

- Q101: open an Infineon support case for `IAUC100N08S5N034ATMA1`; request 2 A/100 ms linear SOA from a +75 °C board/case start and the correct Zth/copper translation. Store permitted response in `docs/evidence/soa/source/Q101/`.
- U101: open a TI support case for `TPS26631PWPR`; provide 4 A/10 ms, 2 A/100 ms, 55 V coordination, exact ILIM/PLIM/dVdt/timer settings and Thermal Case B; request hot repeated-event limits. Store under `docs/evidence/soa/source/U101/`.
- TPS2553: request transient/retry thermal guidance for 0.734 W at U209 and 1.112 W at U212/U213 from +75 °C, 141 kΩ programming and released capacitance. Store under `docs/evidence/soa/source/TPS2553/`.
- Acceptance: attributable manufacturer response or official document, date, applicability statement and SHA-256; no generic forum inference.

## Priority 2 — Authorized distributor capture

For each of the 13 MPNs in `PACS-01R-B1R_Commercial_Quote_Register.csv`, open DigiKey and Mouser regional product pages. Confirm manufacturer authorization, exact MPN/SKU, timestamp/time zone, stock, factory versus distributor stock, packaging, MOQ/package quantity, prices at 1/10/100/1000, standard/quoted lead time, backorder/ship date, region and currency. Export CSV/PDF where offered; otherwise capture a dated full-page screenshot and transcribe it. Store by MPN under `docs/evidence/commercial/distributor-records/<MPN>/`. Record SHA-256 and refresh deadline.

If a second distributor has no listing, capture the no-listing result and check Arrow, Avnet, Newark and manufacturer direct. Acceptance requires two authorized records or a documented search demonstrating the limitation.

## Priority 2 — Formal planning RFQ

Using an Iron Pine supplier account, request no-substitution quotes at quantities 1/10/100/1000 for all MPNs whose public record lacks a tier. Specify tape/reel and cut-tape needs, United States delivery region, requested delivery, quote validity, freight basis and tax exclusion. Store nonconfidential PDFs under `docs/evidence/commercial/quotes/`; for confidential quotes store a redacted summary and secured-location reference plus checksum. Acceptance requires quote number, supplier, date/expiry, exact MPN, quantity, price, MOQ, lead, packaging and conditions.

## Priority 3 — Alternate evidence

For each MPN, reproduce the current alternate classification from official datasheets and manufacturer comparison tools. Document pin/package/pad compatibility, electrical/threshold/timing/fault/thermal differences, external-component changes and ECO/footprint impact. If no alternate is found, list searched manufacturers/families, date, PCN monitoring cadence, safety-stock/last-time-buy mitigation and annual refresh. Store under `docs/evidence/commercial/alternates/`.
