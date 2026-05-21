# Konstruktions-skelet

> Implementeret i `src/designs/house/framing.scad` (`RenderHouseFraming()`)
> + `src/designs/yard/framing.scad` (`RenderYardFraming()`).

Træ-skelettet sidder oven på fundamentet (`src/designs/{house,yard}/foundation.scad`)
og består af 4 lag pr. væg:

1. DPC (murpap)
2. Bundrem (45 × 95 mm trykimprægneret)
3. Reglar / studs (45 × 95 mm gran C24)
4. Toprem (45 × 95 mm gran C24)

## L-formet grundplan

Huset stikker 1000 mm længere ud mod -Y end yarden gør:

```
                                V2 (bag) — Y=3000
        ┌───────────────────┬───────────────────────────────────────┐
        │                   │                                       │
        │                   │                                       │
        │   hus-zone        │              yard-zone                │   
        │   X=0..2000       │ V5              X=2000..6000          │  V4
        │                   │                                       │
   V3   │                   │                                       │
        │                   │                                       │
        │  V1 (hus, Y=0)    ┌────────────[ yard-dør ]───────────────┘
        │                   │
        │ hus-only zone     │ V1 (yard, Y=1000)
        └───────────────────┘
        ←────── 2000 ───────→ ←───────────── 4000 ──────────────────→
                          (set ovenfra)
```

V1 (front) og V2 (bag) er logisk én væg pr. side men splittes ved X=hl=2000 fordi
yard-front sidder i Y=1000 (ikke Y=0 som hus-front). Det giver en L-form med
1000 mm "knæk" ved partitionen.

## Stak gennem en hus-væg

```
        ┌─── toprem 45×95 ───┐    z=2,412 m (alle hus-vægge)
        │                    │
        │  stud 45×95 C24    │    h = 2200 mm præcis
        │  c/c 600 mm        │
        │                    │
        ├─── bundrem 45×95 ──┤    z=0,167 m (= gulv-top)
        ├═══ murpap (DPC) ═══┤    z=0,122 m
        ▒▒▒▒▒ sokkel-ring ▒▒▒▒    z=0,120 m
```

Tilsvarende stak i yarden, men med kortere studs (2008 mm) → toprem-top i
z = 2,220 m. Yarden er 192 mm lavere end huset.

## Mål

| Egenskab          | Hus              | Yard             |
| ----------------- | ---------------- | ---------------- |
| Vægge             | V1, V2, V3, V5   | V1, V2, V4       |
| Eave over sokkel  | 2292 mm          | 2100 mm          |
| Toprem-top over grade | 2412 mm      | 2220 mm          |
| Stud-længde       | 2200 mm præcis   | 2008 mm præcis   |
| Stud c/c          | 600 mm           | 600 mm           |
| Top-plade form    | Flad (vandret)   | Flad (vandret)   |
| Tag der sidder ovenpå | Gable / skifer | Mesh-rist      |

Yardens lavere væg betyder at V5-partition stikker 192 mm op over yardens
toprem — den 192 mm "knæg" lukkes af gable-tagets sternplade (eller forbliver
synlig hvis man vil have lys ind ovenfra).

## Konstruktion — hus

V1 (front) og V2 (bag) løber X=0..hl=2000 i Y=0..95 / Y=2905..3000.  
V3 (venstre) og V5 (partition/højre) BUTTER mellem V1 og V2's inderfladser
i Y=95..2905, og deres ydersige flugter med fundamentet på X=0 / X=hl.

V5 deler en 95 × 95 hjørne-stud med V1 og V2 (én pr. ende) — kaldes
**junction-studs** i koden og sidder ved X=1955..2000 (=hl-STUD_THICK..hl).
V1 og V2 har derfor `emit_end=false` — de stopper kort før hl, og junction-studen
fylder hjørnet.

Åbninger i hus-skelettet:
- **Hus-dør** (rough 870 × 2000 mm) i V5 ved Y=1500..2370
- **Pet-dør** (rough 250 × 300 mm) i V5 ved Y=2700..2950, sokkel 60 mm over gulv
- Ingen vinduer (V3 er solid; sidevindue fjernet)

Header over begge V5-døre falder sammen med topremmen — der er ingen separat
header/cripple-stak (`RH_HOUSE_DOOR_H = 2000` = stud-længde, så toprem ER
overliggeren).

## Konstruktion — yard

V1[hl..ll] og V2[hl..ll] løber 4000 mm i Y=yo..yo+95 / Y=yo+yd-95..yo+yd
(yo=1000, yd=2000). V4 (højre) butter mellem dem ved X=ll-95..ll=5905..6000.

Yard-skelettet butter direkte mod V5 fra +X-siden ved X=hl. Yarden har INGEN
junction-stud — den fælles stud sidder i hus-skelettet (V5's junction-studs).

Åbninger i yard:
- **Yard-dør** (rough 1070 × 2008 mm) i V1 ved X=3465..4535 — centreret på
  yardens 4 m front. Header = toprem (samme princip som V5-døren).

## Bygge-rækkefølge

1. Læg DPC (bitumen-tape 100 mm) ovenpå hele sokkel-ringen — hus perimeter +
   V5-cross + yard 3-side perimeter
2. Bor gennemgangshuller i bundrem-stykkerne til ankerskruerne; læg på plads
   og spænd møtrikkerne (M10 c/c 1000 mm)
3. Sæt hus-skelettet først:
   - V3 (venstre) først — fuld 2200 mm studs + flad toprem
   - V1 og V2 (front + bag) hus-segmenter — 2200 mm studs c/c 600, junction-studs
     ved X=1955..2000
   - V5 (partition) — 2200 mm studs med åbninger til hus-dør og pet-dør
4. Sæt yard-skelettet:
   - V4 (højre) — 2008 mm studs
   - V1 og V2 (front + bag) yard-segmenter — 2008 mm studs c/c 600
   - Yard-dør jamb-studs ved X=3420 og X=4535
5. Headers: yard-dør header (2008 sidder direkte under topremmen så topremmen
   ER overligger — bare et ekstra 45×95 stykke der overlapper); V5 hus-dør og
   pet-dør på samme måde

## Materialeliste

Se [skaereliste-skelet.md](skaereliste-skelet.md) for stykkevis skæreliste
pr. væg og samlet count pr. stok-længde.

| #   | Vare                       | Beskrivelse                                      |
| --- | -------------------------- | ------------------------------------------------ |
| 1   | Reglar 45 × 95 mm gran C24 | Studs hus (2200 mm) + studs yard (2008 mm) + topremme |
| 2   | Reglar 45 × 95 mm gran C24 PT NTR-AB | Bundremme (hus + yard, hele perimeter)  |
| 3   | Bitumen-tape 100 mm bred   | Murpap mellem sokkel og bundrem                  |
| 4   | Ankerskruer M10 × 120      | Bundrem-til-fundament c/c 1000 mm                |

## Rendering / verificering

`src/main.scad` rendrer hele skelettet når `RenderHouseFraming()` og
`RenderYardFraming()` er enabled. Inspicer:

- V3, V5 har VANDRETTE topremme (ikke skrå)
- Hus-toprem og yard-toprem ligger i forskellige højder (192 mm step ved V5)
- Junction-studs ved X=1955..2000 i V5/V1 og V5/V2 hjørnerne
- V3 er solid (ingen vinduescutout)
- V5 har 2 cutouts (hus-dør + pet-dør)
- Yard V1 har 1 cutout (yard-dør)
