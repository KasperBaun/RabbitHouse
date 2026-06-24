# Skæreliste — Tagkonstruktion

> Implementeret i `src/designs/roof_structure.scad` (`RenderHouseRoof()` + `RenderYardRoof()`) + `roof_plates_tagpap.scad` / `roof_plates_eternit.scad`. Materialelister i [tagkonstruktion_eternit.md](tagkonstruktion_eternit.md) og [tagkonstruktion_tagpap.md](tagkonstruktion_tagpap.md). Variant-sammenligning: [tagkonstruktion.md](tagkonstruktion.md).

Skæreliste pr. element. Mål er millimeter; positioner er i bygningens koordinatsystem (X = længde-akse, Y = front→bag).

## Zone-opdeling

Tag-spær og lookouts opdeles ved X=1500 (partition-linjen). Cover-lagene (OSB-dæk, tagpap, eternit) er én sammenhængende dæk — de straddler hl og holdes "fælles" i materialelisten.

| Zone | Tag-elementer der hører til                                                                  | Render-modul         |
| ---- | --------------------------------------------------------------------------------------------- | -------------------- |
| Hus  | Spær X ≤ 1200 (4 stk) + venstre vindskede + venstre lookouts (3) + venstre side-fascia/soffit + front+bag fascia/soffit [0..hl] | `RenderHouseRoof()`  |
| Yard | Spær X ≥ 1800 (9 stk) + højre vindskede + højre lookouts (3) + højre side-fascia/soffit + front+bag fascia/soffit [hl..ll] | `RenderYardRoof()`   |
| Fælles | OSB-dæk (15 plader straddler hl); tagpap baner; alu-inddækning; eternit B7 plader + skruer (bølger straddler hl); C18 lægter | `RenderRoofPlates(cover)` |

## Konventioner

- **Fugleudskæring** (= bird's mouth): trekantet kile saves ud af spær-bunden ved bæreflader, så spæret får et fladt sæde på V1's og V2's *flade* toprem.
- På V3 og V5's *skrå* toprem (kun gable-spæret rører dem) er der ingen udskæring — toprem er allerede skåret til samme hældning som spær-bunden, så de matcher fladt mod fladt.
- "Bæreflade" = de 95 mm hvor spæret krydser en toprem.
- Sæde-snit = vandret savsnit, hæl-snit = lodret savsnit. Ved vores lave hældning (4,6°) er hæl-snittet 0 mm — det er reelt bare en lille kile.

## Sammendrag

| Vare                                            | Antal | Hus | Yard | Fælles | Brug                                                  |
| ----------------------------------------------- | ----- | --- | ---- | ------ | ----------------------------------------------------- |
| **Træværk**                                     |       |     |      |        |                                                       |
| Reglar 47×100×3000 mm gran C24                  | 13    | 4   | 9    |        | Spær (11 regulære + 2 vindskede)                      |
| OSB-3 plade TG4 18 mm 2397×600 mm               | 15    |     |      | 15     | Tagdæk ~19 m² — plader straddler hl                   |
| Imp. stern 25×125×3600 mm gran                  | 6     | 1   | 3    | 2      | Sternbræt hele perimeter — front+bag straddler hl     |
| **Tagdækning**                                  |       |     |      |        |                                                       |
| Phønix Selvbyggerpap 1×5 m                      | 5     |     |      | 5      | Selvklæbende, ~5 m²/rulle                             |
| TagSealer 300 ml Phønix                         | 3     |     |      | 3      | Bitumen-fugemasse                                     |
| **Sternkapsler (cap over sternbræt-top)**       |       |     |      |        |                                                       |
| Sternkapsel lige alu 35×25×1000 mm              | 13    |     |      | 13     | Front + bag eaves — sektioner straddler hl            |
| Sternkapsel skrå kant alu 35×25×1000 mm         | 6     | 3   | 3    |        | Venstre side (hus) + højre side (yard)                |
| **Beslag og fastgørelse**                       |       |     |      |        |                                                       |
| Vinkelbeslag 90×90×40 mm 20-pak                 | 3     | 1   | 2    |        | ~14 brackets på hus-spær, ~34 på yard-spær            |
| OSB/spær-skruer 5×80 mm                         | 250   |     |      | 250    | OSB på spær + vinkelbeslag-fastgørelse                |
| Rustfri tagskruer m. EPDM-pakning               | 1 pk  |     |      | 1 pk   | Alu-profiler på OSB (~50 stk)                         |
| Galvaniseret tagpapsøm                          | 1 æsk |     |      | 1 æsk  | Selvbyggerpap på OSB (~150 stk)                       |

---

## Spær (13 stk — ALLE skæres identisk)

**Råstof:** 45×95×3000 mm gran C24, skæres til **2910 mm** langs slopen.

**Markering på hvert spær (mål fra front-ende):**

| Position på spær | Hvad det er                            |
| ---------------- | -------------------------------------- |
| 0..220 mm        | Front-overhang (stikker ud over V1)    |
| 220..315 mm      | V1 bæreflade — **fugleudskæring her**  |
| 315..2625 mm     | Fri span over bygnings-indre           |
| 2625..2720 mm    | V2 bæreflade — **fugleudskæring her**  |
| 2720..2910 mm    | Bag-overhang (stikker ud over V2)      |

**Fugleudskæring (samme ved begge bæreflader, spejlvendt):**

| Mål              | Værdi                                              |
| ---------------- | -------------------------------------------------- |
| Længde langs spær | 95 mm (= toprem-dybde)                            |
| Største dybde    | 7,6 mm ved bæringens indre kant                    |
| Mindste dybde    | 0 mm ved bæringens ydre kant                       |
| Form             | Trekantet kile — sav vandret ind så dybden vokser jævnt |

Ved V1-bæringen er det den indre kant (mod bygningen, position 315 mm) der er 7,6 mm dyb; ved V2-bæringen er det den indre kant (position 2625 mm) der er 7,6 mm dyb. Med andre ord: kilen bliver dybere INDAD mod bygningens midte.

**X-positioner for de 13 spær (på tværs af bygningen):**

| Type        | Antal | Zone | X-positioner                                                  |
| ----------- | ----- | ---- | ------------------------------------------------------------- |
| Vindskede V | 1     | Hus  | X = -220                                                      |
| Gable V3    | 1     | Hus  | X = 0 (hviler også fladt på V3's skrå toprem hele vejen)      |
| Indre (hus) | 2     | Hus  | X = 600, 1200                                                 |
| Indre (yard)| 7     | Yard | X = 1800, 2400, 3000, 3600, 4200, 4800, 5400                  |
| Gable V5    | 1     | Yard | X = 5955 (hviler også fladt på V5's skrå toprem)              |
| Vindskede H | 1     | Yard | X = 6175                                                      |

**Vinkelbeslag pr. spær:**

- **Regulære spær (11 stk):** 2 vinkelbeslag pr. bæreflade — én på hver side af spæret. Total 4 pr. spær = 44 stk.
- **Vindskede-spær (2 stk):** 1 vinkelbeslag pr. bæreflade på indersiden af spæret (ydersiden er i luften past toprem-forlængelsens ende). Total 2 pr. spær = 4 stk.

Horisontal flange skrues i toprem-toppen; vertikal flange skrues i spær-siden.

---

## OSB-tagdæk (15 plader TG4 18 mm 2397 × 600 mm)

Plader lægges med deres **lange side (2397 mm) PÅ TVÆRS af spær** (= langs X-aksen). Pladens **600 mm bredde matcher spær c/c 600 EXACT** — plade-kanter lander automatisk på spær-centerlinier uden trimning. TG4 har tand-og-not på alle 4 sider, så samlinger glider sammen og er selv-tætnende.

**Layout — 3 plader pr. række × 5 rækker:**

```
        ┌──────┬──────┬──┐  Y=2900 (bag-overhang slut)
        │  R5 (cut 500) │  ← cut sidste række til 500 mm
        ├──────┼──────┼──┤  Y=2400
        │  R4 (3 plader)│
        ├──────┼──────┼──┤  Y=1800
        │  R3           │
        ├──────┼──────┼──┤  Y=1200
        │  R2           │
        ├──────┼──────┼──┤  Y=600
        │  R1           │
        └──────┴──────┴──┘  Y=0 (front-overhang slut)
        X=0   X=2397 X=4794 X=6440
```

**Cuts pr. række (langs X = 6440 mm):**
- Plade 1: 2397 mm fuld (X=0..2397)
- Plade 2: 2397 mm fuld (X=2397..4794)
- Plade 3: skæres til 1646 mm fra fuld 2397 (X=4794..6440, spild 751 mm)

**Cuts langs Y (5 rækker à 600 mm = 3000 mm; tagflade er 2900 mm):**
- Rækker 1-4: 600 mm fulde
- Række 5: skæres til 500 mm bredde fra fuld 600 (spild 100 mm pr. plade i sidste række)

**Skruer:** 5×80 skruer c/c 150 mm langs alle plade-kanter (= langs samlingerne, gennem TG ind i spær) + c/c 300 mm i pladens midte. ~10 skruer pr. plade × 15 plader ≈ 150 skruer i alt.

- Tagflade total: 6440 × 2900 mm ≈ 18,7 m²
- Plade-areal: 2397 × 600 = 1,44 m² pr. plade
- 15 plader × 1,44 m² = 21,6 m² → dækker med ~2,9 m² spild (~14 %)

---

## Sternbræt 25×125 mm imprægneret gran (~19 m)

Sternbræt monteres så **toppen sidder 7 mm over tagpap-toppen** (sternbræt-top = wall_top + 125, tagpap-top = wall_top + 118). Det danner en lille opadgående kant der forhindrer vand i at løbe ud over tagets sider og giver et beskyttet sted til sternkapslen.

| Position     | Længde     | Note                                       |
| ------------ | ---------- | ------------------------------------------ |
| Front-eave   | 6440 mm    | Horisontalt langs hele front-overhang      |
| Bag-eave     | 6440 mm    | Horisontalt langs hele bag-overhang        |
| Venstre-eave | 2910 mm    | Følger tagets hældning (skrå)              |
| Højre-eave   | 2910 mm    | Samme                                      |
| **Total**    | **18,7 m** | 6 stk × 3600 mm dækker med spild           |

Skrues fast i spær-ender (front + bag) og vindskede-spær (sider) med 5×80 skruer c/c ~300 mm. Selvbyggerpap rulles op og over sternbræt-toppen og foldes ned over outer-face så vandet drypper af kanten.

---

## Sternkapsler — 2 forskellige typer

Cap'er der glider ned over sternbræt-toppen + den oprullede tagpap-kant. Beskytter sternbræt-træet mod vejret og giver et rent finish.

**Sternkapsel lige alu 35×25×1000 mm** på front + bag eaves (vandret):

| Position    | Længde  | Stk |
| ----------- | ------- | --- |
| Front-eave  | 6440 mm | 7   |
| Bag-eave    | 6440 mm | 7   |

(7 stk pr. eave: 6 fulde × 1 m = 6 m + 7. stk overlapper 50 mm for at nå de 6,44 m.)

**Sternkapsel skrå kant alu 35×25×1000 mm** på venstre + højre sider (skrå med taget):

| Position     | Længde  | Stk |
| ------------ | ------- | --- |
| Venstre-eave | 2910 mm | 3   |
| Højre-eave   | 2910 mm | 3   |

Glides ned over sternbræt-toppen (25 mm kapsel-bredde matcher 25 mm sternbræt-tykkelse). Skrues fast gennem topfladen ind i sternbræt-toppen med rustfri tagskruer c/c ~500 mm. **VIGTIGT:** Læg en stribe TagSealer (bitumen-fugemasse, IKKE silikone) UNDER sternkapselen før montering — tætningslag mellem den oprullede tagpap og alu-cap'en. Overlap mellem to sternkapsler: 50 mm, topstykket OVENPÅ bundstykket i vand-strømmens retning.

---

## Tjek

- **Spær:** 13 × 2910 mm = 37,8 m brugt af 13 × 3000 mm = 39 m stock → ~1,2 m spild
- **OSB:** 15 plader TG4 × 1,44 m² = 21,6 m² brugt af 18,7 m² tagflade → ~2,9 m² spild (~14 %). TG4's 600 mm bredde matcher spær c/c 600 så plade-samlinger lander automatisk på spær-centerlinier
- **Selvbyggerpap:** 5 ruller × 5 m² = 25 m² brugt af 19 m² tagflade → ~6 m² spild til overlap mellem baner
- **Sternbræt 25×125:** ~19 m fra 6 × 3600 mm = 21,6 m stock → ~2,6 m spild. Top 7 mm over tagpap
- **Sternkapsler:** lige 13 stk dækker 13 m (front+bag = 12,9 m); skrå 6 stk dækker 6 m (sider = 5,8 m). ~700 kr billigere end tagfod+vindskede
- **Vinkelbeslag:** 11 regulære × 4 + 2 vindskede × 2 = 48 stk, dækket af 3 × 20-pak = 60 stk
- **TagSealer:** 3 × 300 ml = 900 ml. ~19 m fugelinje under alu-flange + overlap-fuger ≈ 25 m bead → 1 tube pr. ~8 m, så 3 tuber er rigeligt
