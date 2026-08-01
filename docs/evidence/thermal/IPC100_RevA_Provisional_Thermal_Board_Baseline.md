# IPC-100 Rev A Provisional Thermal-Board Baseline

This qualification assumption is not a PCB design, footprint assignment, placement authorization or routing authorization.

Common boundary: four-layer FR-4, 1.6 mm finished thickness, 1 oz external copper, 1 oz internal copper, continuous L2 ground, substantially continuous L3 power/ground return, +60 °C external ambient, +75 °C enclosure air, natural convection, vertical-board screening, no airflow credit, no neighboring heat-spreading credit, board hot-spot target ≤90 °C, calculated junction target ≤110 °C and absolute-limit margin ≥15 °C.

| Case | Top copper per exposed-pad power device | Internal coupling | Thermal vias | Via construction | Mask treatment | Use |
| --- | ---: | --- | --- | --- | --- | --- |
| A — Minimum copper | 400 mm² connected top copper | L2 ground only | 4 | 0.20–0.30 mm finished, 0.30–0.45 mm drill, ≤1.2 mm pitch | Tented opposite side; pad-side treatment per assembly review | Failure-screen boundary; not preferred |
| B — Expected Rev A | 900 mm² combined top/bottom spreading with solid L2 coupling | L2 ground plus L3 compatible power/ground copper | 9 | 0.20–0.30 mm finished, 0.30–0.45 mm drill, 0.8–1.0 mm pitch | Filled/capped only if assembly requires; otherwise tented bottom | Qualification planning baseline |
| C — Enhanced copper | 1600 mm² combined spreading, no neck-down within 10 mm | Solid L2 and L3 coupling | 16 | 0.20–0.30 mm finished, 0.30–0.45 mm drill, 0.7–0.9 mm pitch | Assembly-controlled | Thermal contingency |

Exposed pads require solid copper connection without thermal relief. Power devices require ≥10 mm separation from another ≥0.5 W source unless superposition is analyzed. These areas are provisional bounding assumptions; exact package land geometry remains manufacturer-controlled and must be released later.
