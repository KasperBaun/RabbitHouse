# Fundament — Løbegård

> Implementeret i `src/designs/yard/foundation.scad`.

Løbegård-fundamentet er en fundablok-ring under løbegårdens 3 ydervægge
(V1 front, V2 bag, V4 højre), lagt i **halvstensforbandt med vekslende
hjørne-ejerskab** — samme mønster som [hus-fundamentet](../hus/fundament.md).

I **kombineret build** med hus'et danner hus'ets V5-væg (ved X = 2000)
løbegårdens venstre side — så løbegårdens egen ring har KUN 3 sider. I
**standalone-build** (`standalone = true`) renderes også en venstre strip
ved X = hl så løbegården står alene.

Ringen er 4000 × 3000 mm udvendigt og 80 cm høj (4 skifter à 20 cm). 12 cm
sokkel over jord, 68 cm under jord — samme dybde som hus-fundamentet.

```
        Y
        ↑
   Y=3000 ┌─────────────────────────────────────────┐  ← V2 bag (yard-segment)
          │                                         │
          │                                         │V4
          │       Løbegård X = 2000..6000           │  ← 3000 mm
          │       Y = 0..3000                       │    (V4 højre)
          │                                         │
          │       (V5 = husets højre væg → fælles)  │
   Y=0    └─────────────────────────────────────────┘  ← V1 front (yard-segment)
          X=2000                                X=6000
                       4000 mm
                  (V1, V2 yard-segment)
                  (set ovenfra)
```

## Mål

| Egenskab | Værdi |
|---|---|
| Løbegård-footprint udvendigt | 4000 × 3000 mm (X = 2000..6000, Y = 0..3000) |
| Antal skifter | 4 |
| Total ringhøjde | 800 mm (4 × 200) |
| Sokkel-højde over jord | 120 mm (Z = +120 mm = RH_BASE_H) |
| Buried dybde | 680 mm |
| Fundablok dim. | 500 × 150 × 200 mm |
| Stabilgrus i bunden | 100 mm |
| Total grøftedybde | ~80 cm (680 ring + 100 grus) |
| Venstre væg (V5) | I COMBINED: ejet af hus. I STANDALONE: render egen strip |

## Halvstensforbandt — hjørner skifter ejer per skifte

Hjørnerne ved V4 (front-right og back-right) interlocker perpendikulært
mellem skifter — samme princip som hus'ets fundament, men her er det de
**lange vægge** (V1 og V2, 4000 mm) der ejer hjørnerne på ulige skifter, og
den **korte væg** (V4 — 3000 mm) der ejer hjørnerne på lige skifter.

| Skifte | Lange vægge (V1, V2 — 4000 mm) | Kort væg (V4 — 3000 mm) |
|--------|--------------------------------|--------------------------|
| Lige (0, 2)  | Mellem: X = 2000..5850 (8 blokke: 7×500 + 350 cut) | Fuld: Y = 0..3000 (6 × 500) |
| Ulige (1, 3) | Fuld: X = 2000..6000 (8 × 500)               | Mellem: Y = 150..2850 (6 blokke: 5×500 + 200 cut) |

**Combined pr. skifte** = 8 + 8 + 6 = **22 blokke**.
4 skifter × 22 = **88 blokke** netto.

I STANDALONE-mode tilføjes V5 venstre væg (samme dimensioner som V4 — kort,
3000 mm): den ejer hjørner sammen med V4 på lige skifter, og sidder mellem
på ulige. Det giver 28 blokke pr. skifte × 4 = **112 blokke** standalone.

## Konstruktion — tværsnit

```
                            ↓ M10 ankerskrue c/c 1000 mm i topskiftet
        ┌────────────────────────────────────┐    ← sokkel z = +120 mm
        │            4. skifte               │
        │ - - - - - - - - - - - - - - - - -  │    ← grade z = 0 (jord/græs)
        ├────────────────────────────────────┤    ← z = −80 mm
        │            3. skifte               │
        ├────────────────────────────────────┤    ← z = −280 mm
        │            2. skifte               │
        ├────────────────────────────────────┤    ← z = −480 mm
        │            1. skifte               │
        └────────────────────────────────────┘    ← z = −680 mm
        ░░░░░░░░░ stabilgrus 100 mm ░░░░░░░░░░
        ─────────────────────────────────────    ← z = −780 mm (bund af grøft)
                       (snit gennem yard-væg)
```

Hulrum udstøbes med selvblandet beton (cement + støbemix + vand, ~1:4).
Topskiftet ligger flush med sokkel-niveau (z = +120 mm).

**Armering (Ø10 mm kamstål):**

| Placering | Antal stænger | Bemærk |
|---|---|---|
| 1. skifte (bund) | **2 stænger** vandret hele 3-sidet perimeter rundt | Lægges i hulrum før udstøbning |
| 4. skifte (top) | **2 stænger** vandret hele 3-sidet perimeter rundt | Lægges før topudstøbning, før ankerskruerne bores |
| Lodret | **4–6 stk** korte stænger (~600 mm) | I V4-hjørner + et par midt på V1/V2 — bindes til top og bund banderne |

Perimeter (3-sidet) = 4000 + 3000 + 4000 = 11 m. Per band kræves ceil(11/3) = 4
stk 3 m-stænger med overlap ~400 mm i midten af V1/V2. ALDRIG overlap i et hjørne.

M10 ankerskruer drives ned i topskiftet c/c 1000 mm. Ankeren ved X = 2000
(grænse mod hus) ejes af [hus-fundamentet](../hus/fundament.md) — yard
starter sine egne ankre ved X = 3000.

## Materialeliste — løbegård (combined mode)

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Stabilgrus 0–32 mm | Bundlag 100 mm i frostfri grøft (~11 m perimeter × 30 cm × 10 cm) | ~0,33 | m³ (~560 kg) |
| 2 | Fundablok 50 × 20 × 15 cm | 4 skifter halvstensforbandt på 3-sidet ring (V5 er hus'ets) | 94 | stk (88 + 6 buffer) |
| 3 | Kamstål Ø10 mm × 3 m | 2 bund (8 stk for 22 m bane) + 2 top (8 stk) + lodrette (2 stk klippes) | 18 | stk |
| 4 | Cement (Aalborg Portland CEM I/II, 25 kg-sæk) | Hulrumsudstøbning ~330 L beton ved 1:4 | 11 | sæk |
| 5 | Støbemix 0–16 mm | Sand+grus til selvblanding | ~705 | kg |
| 6 | Ankerskruer M10 × 120 | Bundrem-til-ring: 4 på V1, 4 på V2, 3 på V4 | 11 | stk |

> Priser pr. enhed slås op i [materialeliste.xlsx](../materialeliste.xlsx),
> Zone-kolonne = "Yard".

### Standalone-tillæg

Hvis løbegården bygges helt for sig selv (ingen hus), tilføj:

| Tilføjelse | Antal | Note |
|---|---|---|
| Fundablok extra | +24 stk | Venstre strip ved X = 2000 (4 skifter × 6 blokke) |
| Kamstål Ø10 mm × 3 m extra | +5 stk | V5-bane (1 bund + 1 top à ~3 m, hver tager 2 stk pga overlap) + 1 lodret |
| Cement extra | +3 sæk | Ekstra hulrum |
| Stabilgrus extra | ~75 kg | Ekstra V5-grøft 3 m |
| Ankerskruer M10 extra | +3 stk | V5 venstre væg (Y = 500, 1500, 2500) |

## Bygge-rækkefølge

1. Mark op yard-hjørner ved (2000, 0), (6000, 0), (6000, 3000), (2000, 3000).
   (Standalone: marker også ny væg-linje ved X = 2000.)
2. Udgrav rendegrøft ~30 cm bred × ~80 cm dyb langs V1 (front), V2 (bag) og
   V4 (højre). Standalone: også langs V5 (venstre).
3. Læg 100 mm stabilgrus i bunden, komprimer.
4. Læg **1. skifte** (ulige — V1, V2 ejer hjørner): V1 og V2 fuld X = 2000..6000,
   V4 mellem Y = 150..2850. Standalone: V5 også mellem Y = 150..2850.
5. **Læg 2 stk Ø10 mm kamstål vandret** i hulrummet i 1. skifte hele
   3-sidet perimeter rundt. Overlap ~400 mm midt på V1/V2; aldrig over hjørne.
6. Læg **2. skifte** (lige — V4 ejer hjørner): V4 fuld Y = 0..3000. V1 og V2
   mellem X = 2000..5850. Standalone: V5 også fuld Y = 0..3000.
7. **Sæt 4–6 lodrette Ø10 mm-stykker (~600 mm)** ned gennem hulrum i V4-
   hjørner + midt på V1, V2 — bindes til bund-banerne.
8. Læg **3. skifte** (ulige — samme som 1.).
9. Læg **4. skifte** (lige — samme som 2.).
10. **Læg 2 stk Ø10 mm kamstål vandret** i hulrummet i 4. skifte; bindes
    til de lodrette.
11. Bland beton (cement + støbemix + vand ~1:4), udstøb alle hulrum.
    Lad hærde ~7 dage.
12. Bor og sæt M10 ankerskruer c/c 1000 mm i topskiftet:
    - V1 (front): x = 3000, 4000, 5000, 5500 (4 stk; c/c 1000 fra x=3000)
    - V2 (bag): x = 3000, 4000, 5000, 5500
    - V4 (højre): y = 500, 1500, 2500
    - Standalone V5 (venstre): y = 500, 1500, 2500

## Rendering / verificering

```powershell
# Render combined build (hus + yard) for at se hvordan yard's fundament
# slutter op mod hus'ets V5 ved X = 2000.
& "C:\Program Files\OpenSCAD\openscad.exe" `
    -o _renders/yard_fundament.png --imgsize=1000,600 `
    --camera=3000,1500,-200,75,0,30,16000 `
    src/main.scad
```

Inspect:
- Yard's V1 og V2 starter ved X = 2000 (mod hus) og går til X = 6000
- V4 højre fundament løber fra Y = 0 til Y = 3000 i lige skifter,
  fra Y = 150 til Y = 2850 i ulige skifter (interlocker med V1/V2)
- I COMBINED ingen venstre væg (V5 er hus'ets); i STANDALONE er der egen V5-strip
  med samme alternation som V4
- Topskifte flush med sokkel-niveau (Z = +120 mm), 4 skifter (80 cm) dybt
- M10 ankerskruer (11 stk i combined; 14 i standalone) i topskiftet
