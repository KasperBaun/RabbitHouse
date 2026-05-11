# v3 side-overhang lookouts + sofitt — Design

> Status: approved 2026-05-11. Implementation pending.

## Motivation

Side-overhang (220 mm) blev oprindeligt løst ved at forlænge V1 (front) og V2 (bag) toprem 220 mm forbi V3/V4 i hver ende, så barge-raftrene hviler direkte på den kantilevrede toprem (`konstruktions-skelet.scad:392-401`, kommentar: "erstatter behovet for lookouts").

Visuelt problem: kantileveren ser ud som om topremmen flyver i luften, fordi der ikke er nogen horisontale led mellem V3-gable-spæret og barge-spæret. I virkelig konstruktion er kantilevret toprem kun standard for overhangs ≤ 150 mm; 220 mm hører i lookout-kategorien.

Sekundært problem: tagskægget er åbent nedefra — spær-bunde, toprem-kantilever og hulrum mellem spær er synlige fra jorden. Mangler sofitt.

## Decisions

- Side-overhang: **lookouts i spær-planet** (textbook). Toprem klippes tilbage til byggelinjen.
- Sofitt: **18 mm krydsfiner, sloped, dækker hele eaven**, farve = klink-beklædning.
- Modellering: lookouts og notches i V3/V4-spær laves som CSG-overlap (ikke `difference()`-notches), simplere og visuelt ækvivalent efter union.

## Geometri

### Lookouts

| Parameter | Værdi |
|---|---|
| Antal | 3 pr. side × 2 sider = 6 |
| Tværsnit | 45×95 (samme som spær) |
| Materiale | Imprægneret gran C24 |
| Y-positioner | 47,5 (V1-linje) · 1250 (mid) · 2452,5 (V2-linje) |
| X-span venstre | `[-V3_OH_SIDE, 645]` = 865 mm |
| X-span højre | `[ll - 645, ll + V3_OH_SIDE]` = 865 mm |
| Z-top | `v3_roof_under_for(eh_back, y)` (= spær-top) |
| Z-bund | Z-top − 95 |

Lookoutens X-span dækker fra barge-spæret (yder-bærepunkt) gennem V3/V4-gable-spæret (notch, modelleret som CSG-overlap) forbi tomgangen og slutter ved andenrad-spæret (X=600 / X=ll-600 — visuelt anker, CSG-overlap). Hvor lookout krydser V1/V2-toprem (Y=47,5 og Y=2452,5) bærer den på topremmen via bird's-mouth (samme CSG-overlap-princip som regulære spær).

### Toprem cut-back

`konstruktions-skelet.scad:395-396`:
- Før: `extended_x0 = -V3_OH_SIDE; extended_len = ll + 2 * V3_OH_SIDE;`
- Efter: `extended_x0 = 0; extended_len = ll;`

V3/V4/V5 toprem er uændrede (sloped, butted mellem V1+V2 indersider).

### Sofitt

| Parameter | Værdi |
|---|---|
| Materiale | 18 mm krydsfiner. Farve `pal_panel1(palette)` (= primær klink-farve) for match med beklædning |
| Z-top | `v3_roof_under_for(eh_back, y) − V3_SPAER_H` (= spær-bund) |
| Sloped | Ja, følger spær-undersiden |
| Front-panel | X=[−V3_OH_SIDE−25, ll+V3_OH_SIDE+25], Y=[−V3_OH_FRONT, 0] |
| Bag-panel | X=[−V3_OH_SIDE−25, ll+V3_OH_SIDE+25], Y=[ww, ww+V3_OH_BACK] |
| Venstre-panel | X=[−V3_OH_SIDE−25, 0], Y=[0, ww] |
| Højre-panel | X=[ll, ll+V3_OH_SIDE+25], Y=[0, ww] |

Front + bag sofitter dækker hjørnerne (deres X-span løber under side-sternbrædernes ydre kanter). Side-sofitterne slutter ved væglinjerne — undgår dobbelt-dækning og mitered hjørner.

Sofitten fastgøres i virkelig konstruktion til: spær-bund (front/bag), lookout-bund (sider), sternbræt-inderside (alle 4 yderkanter), og en ledger-strip nailed på vægtoppen (alle 4 innerkanter). Ledger-strippen modelleres ikke.

## Moduler

### Nye moduler i `tagkonstruktion.scad`

```scad
module v3_lookouts(eh_back, palette = DEFAULT_PALETTE) { ... }
module v3_sofitt(eh_back, palette = DEFAULT_PALETTE) { ... }
```

Begge kaldes fra `v3_tagkonstruktion` mellem `v3_spaer` og cover-kaldene.

### Ændringer i `konstruktions-skelet.scad`

- `v3_top_plate` modulet: `extended_x0 = 0`, `extended_len = ll`. Kommentaren opdateres til at reflektere at lookouts nu bærer barge-raftrene.

### Ændringer i `tagkonstruktion.scad:v3_spaer` kommentar

Den eksisterende kommentar "V1+V2 toprem er forlænget V3_OH_SIDE i hver ende … Ingen lookouts behøves" ændres til at sige at lookouts er tilføjet og bærer barge-raftrene.

## Verifikation

Render fra 4 vinkler efter ændringen:
1. Front-eave underside (sofitten dækker)
2. Venstre side-eave fra under (sofitt + barge-rafter)
3. Cutaway med `show_cover=false` (lookouts synlige, ingen toprem-kantilever)
4. Hele bygningen perspektiv

Sammenlign med `out/v3_*_after.png` (commited som baseline efter sternbræt-fix).

## Out of scope

- Frieze-blokeringer mellem spær (fravalgt af bruger i denne iteration)
- Vandbræt på sternbræt (allerede dækket af sternkapsel-alu)
- Ventilation-slidser i sofitt (ikke nødvendigt da v3 ikke har isolerings-hulrum mellem cover og loft)
