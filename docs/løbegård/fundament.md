# Fundament — Løbegård

> Implementeret i `src/designs/yard/foundation.scad`.

Løbegård-fundamentet er en fundablok-ring under løbegårdens 3 ydervægge
(V1 front, V2 bag, V4 højre), lagt i **halvstensforbandt med vekslende
hjørne-ejerskab** — samme mønster som [hus-fundamentet](../hus/fundament.md).

I **kombineret build** med hus'et danner hus'ets V5-væg (ved X = 1500)
løbegårdens venstre side — så løbegårdens egen ring har KUN 3 sider. I
**standalone-build** (`standalone = true`) renderes også en venstre strip
ved X = hl så løbegården står alene.

Ringen er 4500 × 2500 mm udvendigt og 60 cm høj (3 skifter à 20 cm). 12 cm
sokkel over jord, 48 cm under jord.

```
        Y
        ↑
   Y=2500 ┌─────────────────────────────────────────┐  ← V2 bag (yard-segment)
          │                                         │
          │                                         │V4
          │       Løbegård X = 1500..6000           │  ← 2500 mm
          │       Y = 0..2500                       │    (V4 højre)
          │                                         │
          │       (V5 = husets højre væg → fælles)  │
   Y=0    └─────────────────────────────────────────┘  ← V1 front (yard-segment)
          X=1500                                X=6000
                       4500 mm
                  (V1, V2 yard-segment)
                  (set ovenfra)
```

## Mål

| Egenskab | Værdi |
|---|---|
| Løbegård-footprint udvendigt | 4500 × 2500 mm (X = 1500..6000, Y = 0..2500) |
| Antal skifter | 3 |
| Total ringhøjde | 600 mm (3 × 200) |
| Sokkel-højde over jord | 120 mm (Z = +120 mm = RH_BASE_H) |
| Buried dybde | 480 mm |
| Fundablok dim. | 500 × 150 × 200 mm |
| Stabilgrus i bunden | 100 mm |
| Total grøftedybde | ~60 cm (480 ring + 100 grus) |
| Venstre væg (V5) | I COMBINED: ejet af hus. I STANDALONE: render egen strip |

## Halvstensforbandt — hjørner skifter ejer per skifte

Hjørnerne ved V4 (front-right og back-right) interlocker perpendikulært
mellem skifter — samme princip som hus'ets fundament, men her er det de
**lange vægge** (V1 og V2, 4500 mm) der ejer hjørnerne på ulige skifter, og
den **korte væg** (V4, 2500 mm) der ejer hjørnerne på lige skifter.

| Skifte | Lange vægge (V1, V2 — 4500 mm) | Kort væg (V4 — 2500 mm) |
|--------|--------------------------------|--------------------------|
| Lige (0, 2)  | Mellem: X = 1500..5850 (9 blokke: 8×500 + 350 cut) | Fuld: Y = 0..2500 (5 × 500) |
| Ulige (1)    | Fuld: X = 1500..6000 (9 × 500)               | Mellem: Y = 150..2350 (5 blokke: 4×500 + 200 cut) |

**Combined pr. skifte** = 9 + 9 + 5 = **23 blokke**.
3 skifter × 23 = **69 blokke** netto.

I STANDALONE-mode tilføjes V5 venstre væg (samme dimensioner som V4 — kort,
2500 mm): den ejer hjørner sammen med V4 på lige skifter, og sidder mellem
på ulige. Det giver 28 blokke pr. skifte × 3 = **84 blokke** standalone.

## Konstruktion — tværsnit

```
                            ↓ M10 ankerskrue c/c 1000 mm i topskiftet
        ┌────────────────────────────────────┐    ← sokkel z = +120 mm
        │            3. skifte               │
        │ - - - - - - - - - - - - - - - - -  │    ← grade z = 0 (jord/græs)
        ├────────────────────────────────────┤    ← z = −80 mm
        │            2. skifte               │
        ├────────────────────────────────────┤    ← z = −280 mm
        │            1. skifte               │
        └────────────────────────────────────┘    ← z = −480 mm
        ░░░░░░░░░ stabilgrus 100 mm ░░░░░░░░░░
        ─────────────────────────────────────    ← z = −580 mm (bund af grøft)
                       (snit gennem yard-væg)
```

Hulrum udstøbes med selvblandet beton (cement + støbemix + vand, ~1:4).
Topskiftet ligger flush med sokkel-niveau (z = +120 mm).

**Armering (Ø10 mm kamstål):**

| Placering | Antal stænger | Bemærk |
|---|---|---|
| 1. skifte (bund) | **2 stænger** vandret hele 3-sidet perimeter rundt | Lægges i hulrum før udstøbning |
| 3. skifte (top) | **2 stænger** vandret hele 3-sidet perimeter rundt | Lægges før topudstøbning, før ankerskruerne bores |
| Lodret | **4–6 stk** korte stænger (~400 mm) | I V4-hjørner + et par midt på V1/V2 — bindes til top og bund banderne |

Overlap mellem 3 m-stænger placeres på lange strækninger (V1 og V2 er
4,5 m, så hver bane kræver 2 stænger med overlap ~400 mm i midten).
ALDRIG overlap i et hjørne.

M10 ankerskruer drives ned i topskiftet c/c 1000 mm. Ankeren ved X = 1500
(grænse mod hus) ejes af [hus-fundamentet](../hus/fundament.md) — yard
starter sine egne ankre ved X = 2500.

## Materialeliste — løbegård (combined mode)

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Stabilgrus 0–32 mm | Bundlag 100 mm i frostfri grøft (~11,5 m perimeter × 30 cm × 10 cm) | ~0,35 | m³ (~605 kg) |
| 2 | Fundablok 50 × 20 × 15 cm | 3 skifter halvstensforbandt på 3-sidet ring (V5 er hus'ets) | 75 | stk (69 + 6 buffer) |
| 3 | Kamstål Ø10 mm × 3 m | 2 bund (8 stk for 23 m bane) + 2 top (8 stk) + lodrette (2 stk klippes) | 18 | stk |
| 4 | Cement (Aalborg Portland CEM I/II, 25 kg-sæk) | Hulrumsudstøbning ~260 L beton ved 1:4 | 9 | sæk |
| 5 | Støbemix 0–16 mm | Sand+grus til selvblanding | ~700 | kg |
| 6 | Ankerskruer M10 × 120 | Bundrem-til-ring: 4 på V1, 4 på V2, 2 på V4 | 10 | stk |

> Priser pr. enhed slås op i [materialeliste.xlsx](../materialeliste.xlsx),
> Zone-kolonne = "Yard".

### Standalone-tillæg

Hvis løbegården bygges helt for sig selv (ingen hus), tilføj:

| Tilføjelse | Antal | Note |
|---|---|---|
| Fundablok extra | +15 stk | Venstre strip ved X = 1500 (3 skifter × 5 blokke) |
| Kamstål Ø10 mm × 3 m extra | +4 stk | V5-bane (1 bund + 1 top à ~2,5 m) + 1-2 lodrette |
| Cement extra | +2 sæk | Ekstra hulrum |
| Stabilgrus extra | ~60 kg | Ekstra V5-grøft 2,5 m |
| Ankerskruer M10 extra | +2 stk | V5 venstre væg (Y = 500, 1500) |

## Bygge-rækkefølge

1. Mark op yard-hjørner ved (1500, 0), (6000, 0), (6000, 2500), (1500, 2500).
   (Standalone: marker også ny væg-linje ved X = 1500.)
2. Udgrav rendegrøft ~30 cm bred × ~60 cm dyb langs V1 (front), V2 (bag) og
   V4 (højre). Standalone: også langs V5 (venstre).
3. Læg 100 mm stabilgrus i bunden, komprimer.
4. Læg **1. skifte** (ulige — V1, V2 ejer hjørner): V1 og V2 fuld X = 1500..6000,
   V4 mellem Y = 150..2350. Standalone: V5 også mellem Y = 150..2350.
5. **Læg 2 stk Ø10 mm kamstål vandret** i hulrummet i 1. skifte hele
   3-sidet perimeter rundt. Overlap ~400 mm midt på V1/V2; aldrig over hjørne.
6. Læg **2. skifte** (lige — V4 ejer hjørner): V4 fuld Y = 0..2500. V1 og V2
   mellem X = 1500..5850. Standalone: V5 også fuld Y = 0..2500.
7. **Sæt 4–6 lodrette Ø10 mm-stykker (~400 mm)** ned gennem hulrum i V4-
   hjørner + midt på V1, V2 — bindes til bund-banerne.
8. Læg **3. skifte** (ulige — samme som 1.).
9. **Læg 2 stk Ø10 mm kamstål vandret** i hulrummet i 3. skifte; bindes
   til de lodrette.
10. Bland beton (cement + støbemix + vand ~1:4), udstøb alle hulrum.
    Lad hærde ~7 dage.
11. Bor og sæt M10 ankerskruer c/c 1000 mm i topskiftet:
    - V1 (front): x = 2500, 3500, 4500, 5500
    - V2 (bag): x = 2500, 3500, 4500, 5500
    - V4 (højre): y = 500, 1500
    - Standalone V5 (venstre): y = 500, 1500

## Rendering / verificering

```powershell
# Render combined build (hus + yard) for at se hvordan yard's fundament
# slutter op mod hus'ets V5 ved X = 1500.
& "C:\Program Files\OpenSCAD\openscad.exe" `
    -o _renders/yard_fundament.png --imgsize=1000,600 `
    --camera=3000,1250,-200,75,0,30,16000 `
    src/main.scad
```

Inspect:
- Yard's V1 og V2 starter ved X = 1500 (mod hus) og går til X = 6000
- V4 højre fundament løber fra Y = 0 til Y = 2500 i lige skifter,
  fra Y = 150 til Y = 2350 i ulige skifter (interlocker med V1/V2)
- I COMBINED ingen venstre væg (V5 er hus'ets); i STANDALONE er der egen V5-strip
  med samme alternation som V4
- Topskifte flush med sokkel-niveau (Z = +120 mm), 3 skifter (60 cm) dybt
- M10 ankerskruer (10 stk i combined; 12 i standalone) i topskiftet
