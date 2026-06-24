# Fundament — Hus

> Implementeret i `src/designs/house/foundation.scad`.

Hus-fundamentet er en ring af fundablokke, lagt i
halvstensforbandt med vekslende hjørne-ejerskab.  
Ringen er 2000 × 3000 mm udvendigt og 80 cm høj (4 skifter à 20 cm).

```
        Y
        ↑
   Y=3000 ┌──────────────────────┐   ← V2 bag
          │ █ ░ █ ░ █ ░ █ ░ █ ░  │
        V3│ ░                  ░ │V4  ←   3000 mm
          │ █                  █ │       (lange vægge)
   Y=0    └──────────────────────┘   ← V1 front
          X=0                  X=2000
                 2000 mm
              (korte vægge)
              (set ovenfra)
```

## Mål

| Egenskab | Værdi |
|---|---|
| Størrelse | 2000 × 3000 mm (X = 0..2000, Y = 0..3000) |
| Antal skifter | 4 |
| Højde | 800 mm (4 × 200) |
| Fundablok dim. | 500 × 150 × 200 mm (L × B × H) |
| Stabilgrus i bunden | 100 mm |

## Halvstensforbandt — hjørner skifter ejer per skifte

Hvert skifte alternerer hvilken væg der "ejer" hjørneblokken, så lodrette samlinger forskydes 150 mm mellem skifter
og hjørnerne låser perpendikulært.

| Skifte | Lange vægge (V3, V4 — 3000 mm) | Korte vægge (V1, V2 — 2000 mm) |
|--------|--------------------------------|--------------------------------|
| Lige (0, 2)  | Fuld: Y = 0..3000 (6 × 500) | Mellem: X = 150..1850 (4 blokke: 3×500 + 200 cut) |
| Ulige (1, 3) | Mellem: Y = 150..2850 (6 blokke: 5×500 + 200 cut) | Fuld: X = 0..2000 (4 × 500) |

**Blok-tælling pr. skifte** = 6 + 6 + 4 + 4 = 20 blokke (uanset paritet).
4 skifter × 20 = **80 blokke** netto.

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
                       (snit gennem hus-væg)
```

Hulrum udstøbes med selvblandet beton (cement + støbemix + vand, ~1:4).

**Armering (Ø10 mm kamstål):**

| Placering | Antal stænger | Bemærk |
|---|---|---|
| 1. skifte (bund) | **2 stænger** vandret hele perimeteren rundt | Lægges i hulrummet før udstøbning |
| 4. skifte (top) | **2 stænger** vandret hele perimeteren rundt | Lægges før topudstøbning, før ankerskruerne bores |
| Lodret | **4–6 stk** korte stænger (~600 mm) | I hvert hjørne + et par midt på lange vægge — bindes til top og bund banderne |

Kamstålet bindes med bindetråd ved hjørner og overlap (overlap min. 40 × Ø = 400 mm).
Perimeter = 2×(2000+3000) = 10 m. Per band kræves ceil(10/3) = 4 stk 3 m-stænger med
overlap ~400 mm placeret på lange strækninger, ALDRIG over et hjørne.

M10 ankerskruer drives ned i topskiftet c/c 1000 mm langs alle 4 vægge —
fastgør hus-bundremmen til ringen.

## Materialeliste — hus

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Stabilgrus 0–32 mm | Bundlag 100 mm i frostfri grøft (~10 m perimeter × 30 cm × 10 cm) | ~0,30 | m³ (~510 kg) |
| 2 | Fundablok 50 × 20 × 15 cm | 4 skifter halvstensforbandt på 2000 × 3000 ring. 20 blokke pr. skifte | 86 | stk (80 + 6 buffer) |
| 3 | Kamstål Ø10 mm × 3 m | 2 bund (8 stk) + 2 top (8 stk). Lodrette stykker = genbrug af egne metalstænger | 16 | stk |
| 4 | Cement (Aalborg Portland CEM I/II, 25 kg-sæk) | Hulrumsudstøbning ~300 L beton ved 1:4 | 10 | sæk |
| 5 | Støbemix 0–16 mm | Sand+grus til selvblanding | ~625 | kg |
| 6 | Ankerskruer M10 × 120 | Bundrem-til-ring: 2 på V1, 2 på V2, 3 på V3, 3 på V4 | 10 | stk |

## Bygge-rækkefølge

1. Mark op udvendige hjørner ved (0,0), (2000,0), (2000,3000), (0,3000).
2. Udgrav rendegrøft ~30 cm bred × ~80 cm dyb langs alle 4 vægge.
3. Læg 100 mm stabilgrus i bunden, komprimer.
4. Læg **1. skifte** (ulige — V1, V2 ejer hjørner): V1 og V2 fuld X = 0..2000,
   V3 og V4 mellem Y = 150..2850.
5. **Læg 2 stk Ø10 mm kamstål vandret** i hulrummet i 1. skifte hele
   perimeteren rundt (overlap 400 mm på lange strækninger, aldrig over et
   hjørne). Bind med bindetråd ved hjørner.
6. Læg **2. skifte** (lige — V3, V4 ejer hjørner): V3 og V4 fuld Y = 0..3000,
   V1 og V2 mellem X = 150..1850.
7. Læg **3. skifte** (samme som 1.).
8. **Sæt 4–6 lodrette Ø10 mm-stykker (~600 mm)** ned gennem hulrum i
   hjørnerne + midt på de lange vægge — bindes til bund-banerne nede.
9. Læg **4. skifte** (samme som 2.).
10. **Læg 2 stk Ø10 mm kamstål vandret** i hulrummet i 4. skifte hele
    perimeteren rundt; bindes til de lodrette.
11. Bland beton (cement + støbemix + vand ~1:4), udstøb alle hulrum.
    Lad hærde ~7 dage.
12. Bor og sæt M10 ankerskruer c/c 1000 mm i topskiftet:
    - V1 (front): x = 500, 1500
    - V2 (bag): x = 500, 1500
    - V3 (venstre): y = 500, 1500, 2500
    - V4 (højre): y = 500, 1500, 2500
