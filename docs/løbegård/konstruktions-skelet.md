# Konstruktions-skelet — Løbegård

> Implementeret i `src/designs/yard/framing.scad` (`RenderYardFraming()`).  
> Hus-segmentets pendant ligger i [hus/konstruktions-skelet.md](../hus/konstruktions-skelet.md).

Løbegårdens skelet sidder oven på fundamentet (se [fundament.md](fundament.md))
og består af 4 lag pr. væg. Alle mål i mm.

## Stak gennem en yard-væg

```
z=2220 ┌────── toprem 45×95 ──────┐    toprem-top (= bund af mesh-låg)
       │                          │
z=2175 │                          │    toprem-bund (= stud-top)
       │                          │
       │   stud 45×95 C24         │    stud-længde 2008 mm præcis
       │   c/c 600 mm             │    (192 mm kortere end hus-studs)
       │                          │
z=212  │                          │    stud-bund (= bundrem-top)
       ├────── bundrem 45×95 ─────┤    PT NTR-AB
z=167  ├────── DPC 100×2 ─────────┤    bitumen-murpap
z=122  ╞══════════════════════════╡
z=120  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    sokkel-top
```

`RH_YARD_EH_FRONT = RH_YARD_EH_BACK = 2100` → flad eave på alle 3 yard-vægge,
mesh-låget hviler oven på topremmen. Yardens toprem-top ligger 192 mm under
husets (2220 mod 2412) — dette niveau-skifte er synligt ved V5-partitionen.

## Mål-oversigt

| Egenskab                | Værdi                                     |
| ----------------------- | ----------------------------------------- |
| Yard-fodaftryk          | 4000 × 2000 mm (X=2000..6000, Y=1000..3000) |
| Sokkel-top              | z = 120 mm                                |
| Stud-bund               | z = 167 mm                                |
| Stud-top                | z = 2175 mm                               |
| Toprem-top              | z = 2220 mm                               |
| Stud-længde             | 2008 mm — samme på alle 3 yard-vægge      |
| Stud-sektion            | 45 × 95 mm gran C24                       |
| Stud c/c                | 600 mm                                    |
| Mid-rail                | 95 × 40 mm i z = 1197 (= 1030 over gulv)  |

Vægge: **V1[yard]** front-segment (Y=1000..1095, X=2000..6000),
**V2[yard]** bag-segment (Y=2905..3000, X=2000..6000),
**V4** højre (X=5905..6000, Y=1095..2905, 1810 mm langt).

Yarden har INGEN junction-stud mod V5 — V5's V1/V2-hjørnesidder hører til
hus-segmentet og fylder hjørnerne ved X=1955..2000.

---

## V1 — Front-segment (med yard-dør)

**Position:** Y=1000..1095, X=2000..6000 (4000 mm lang).  
**Åbning:** Yard-dør 1070 × 2008 mm centreret om X=4000 (rough opening X=3465..4535).

Yard-dørens rough opening når helt op til topremmen (H = 2008 = stud-længde),
så **topremmen er headeren** — ingen separat header-bjælke eller cripples
over åbningen.

### Elevation (set udefra, –Y mod kameraet)

```
z=2220 ──────────────────────────── mesh-låg hviler ovenpå ────────────────────────────
       ┌──────────────────────────────────────────────────────────────────────────────────┐
z=2175 │                              TOPREM 45×95 — 4000 mm                                │
       │                                       (= header over yard-dør)                    │
       ├──┬──────┬──────┬──────────┬─────────────────────────────────────┬──────┬──┬──┬──┤
       │  │      │      │          │                                     │      │  │  │  │
       │  │      │      │          │                                     │      │  │  │  │
       │ S│  S   │  S   │  YDj     │           Y A R D - D Ø R           │  YDj │ S│ S│ E│
       │  │      │      │          │             åbning                  │      │  │  │  │
       │  │      │      │          │            1070 × 2008              │      │  │  │  │
       │  │      │      │          │                                     │      │  │  │  │
z=1217 ├──────────────────────────┤─────────────────────────────────────┤─────────────────┤  ← mid-rail
z=1177 │  │      │      │          │            (mid-rail springer       │      │  │  │  │  ← (40 mm høj)
       │  │      │      │          │             igennem dør-åbningen)   │      │  │  │  │
       │  │      │      │          │                                     │      │  │  │  │
       │  │      │      │          │                                     │      │  │  │  │
z=212  ╞══╧══════╧══════╧══════════╧═════════════════════════════════════╧══════╧══╧══╧══╡
       │                              BUNDREM 95×45 — 4000 mm                              │
z=167  ├──────────────────────────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░░░░░░░░░░░ DPC 100×2 — 4000 mm ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └──────────────────────────────────────────────────────────────────────────────────┘
        X=2000  2600  3200    3420    3465..4535   4535     5000 5600 5955  6000
                                       (Y-DØR)

  S    = grid-stud c/c 600 (full-h, 2008 mm)
  YDj  = yard-dør jamb (full-h, X=3420..3465 og X=4535..4580)
  E    = end-emit grid-stud (X=5955..6000 — ved V4-hjørnet)
  Mid-rail løber CONTINUOUS gennem dør-åbningen som synlig vandret stiver
```

### Skæreliste — V1[yard]

| # | Element                    | Sektion | Længde (mm) | Antal | Position                                 |
| - | -------------------------- | ------- | ----------- | ----- | ---------------------------------------- |
| 1 | DPC murpap                 | 100×2   | 4000        | 1     | Y=1000..1100, X=2000..6000, z=120        |
| 2 | Bundrem PT                 | 95×45   | 4000        | 1     | Y=1000..1095, X=2000..6000, z=122..167   |
| 3 | Toprem (gran)              | 95×45   | 4000        | 1     | Y=1000..1095, X=2000..6000, z=2175..2220 |
| 4 | Stud — grid                | 45×95   | 2008        | 5     | X=2000, 2600, 5000, 5600, 5955           |
| 5 | Stud — yard-dør jamb       | 45×95   | 2008        | 2     | X=3420..3465 og X=4535..4580             |
| 6 | Mid-rail (venstre for dør) | 95×40   | 1465        | 1     | X=2000..3465, z=1177..1217               |
| 7 | Mid-rail (højre for dør)   | 95×40   | 1465        | 1     | X=4535..6000, z=1177..1217               |

**V1[yard] i alt:** 7 full-height studs + 2 mid-rails.  
**Løbende meter 45×95:** 7·2,008 = **14,06 m**.  
**Løbende meter 95×40:** 2·1,465 = **2,93 m**.

> Topremmen er header. Hvis du vil bygge med separat dør-header, skal du
> sænke `RH_YARD_DOOR_H` (nu = stud-længden) — så genererer koden header
> + cripples som de andre døre.

---

## V2 — Bag-segment (intet)

**Position:** Y=2905..3000, X=2000..6000 (4000 mm lang).  
**Åbninger:** ingen.

Solid bag-væg c/c 600 mm med mid-rail på indersiden.

### Elevation (set udefra, +Y mod kameraet)

```
z=2220 ──────────────────────── mesh-låg hviler ovenpå ─────────────────────────
       ┌───────────────────────────────────────────────────────────────────────┐
z=2175 │                       TOPREM 45×95 — 4000 mm                            │
       ├──┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──┬──┬─────────────┤
       │  │      │      │      │      │      │      │      │  │  │             │
       │ S│  S   │  S   │  S   │  S   │  S   │  S   │  S   │ S│ E│             │
       │  │      │      │      │      │      │      │      │  │  │             │
z=1217 ├──────────────────────────────────────────────────────────────────────┤  ← mid-rail
z=1177 │  │      │      │      │      │      │      │      │  │  │             │
       │  │      │      │      │      │      │      │      │  │  │             │
z=212  ╞══╧══════╧══════╧══════╧══════╧══════╧══════╧══════╧══╧══╧═════════════╡
       │                       BUNDREM 95×45 — 4000 mm                          │
z=167  ├───────────────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░░░░░ DPC 100×2 — 4000 mm ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └───────────────────────────────────────────────────────────────────────┘
        X=2000 2600 3200 3800 4400 5000 5600                        5955 6000

  S = grid-stud c/c 600 (full-h)     E = end-emit grid-stud (X=5955..6000)
```

### Skæreliste — V2[yard]

| # | Element        | Sektion | Længde (mm) | Antal | Position                                  |
| - | -------------- | ------- | ----------- | ----- | ----------------------------------------- |
| 1 | DPC murpap     | 100×2   | 4000        | 1     | Y=2900..3000, X=2000..6000, z=120         |
| 2 | Bundrem PT     | 95×45   | 4000        | 1     | Y=2905..3000, X=2000..6000, z=122..167    |
| 3 | Toprem (gran)  | 95×45   | 4000        | 1     | Y=2905..3000, X=2000..6000, z=2175..2220  |
| 4 | Stud — grid    | 45×95   | 2008        | 8     | X=2000, 2600, 3200, 3800, 4400, 5000, 5600, 5955 |
| 5 | Mid-rail       | 95×40   | 4000        | 1     | X=2000..6000, z=1177..1217                |

**V2[yard] i alt:** 8 full-height studs + 1 mid-rail.  
**Løbende meter 45×95:** 8·2,008 = **16,06 m**.  
**Løbende meter 95×40:** **4,0 m**.

---

## V4 — Højre (intet)

**Position:** X=5905..6000, Y=1095..2905 (1810 mm lang).  
**Åbninger:** ingen.

Solid Y-væg som butter mellem V1 og V2 inderfladser.

### Elevation (set udefra, +X mod kameraet)

```
z=2220 ─────────────────── mesh-låg hviler ovenpå ────────────────────
       ┌─────────────────────────────────────────────────────────────┐
z=2175 │                  TOPREM 45×95 — 1810 mm                       │
       ├──┬──────┬──────┬─────┬───────────────────────────────────────┤
       │  │      │      │     │                                       │
       │ S│  S   │  S   │  E  │                                       │
       │  │      │      │     │                                       │
z=1217 ├─────────────────────┤────────────────────────────────────────┤  ← mid-rail
z=1177 │  │      │      │     │                                       │
       │  │      │      │     │                                       │
z=212  ╞══╧══════╧══════╧═════╧═══════════════════════════════════════╡
       │                  BUNDREM 95×45 — 1810 mm                       │
z=167  ├─────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░ DPC 100×2 — 1800 mm ░░░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └─────────────────────────────────────────────────────────────┘
        Y=1095   1695    2295    2860..2905

  S = grid-stud c/c 600 (full-h)     E = end-emit stud (Y=2860..2905)
```

### Skæreliste — V4

| # | Element        | Sektion | Længde (mm) | Antal | Position                                  |
| - | -------------- | ------- | ----------- | ----- | ----------------------------------------- |
| 1 | DPC murpap     | 100×2   | 1800        | 1     | X=5900..6000, Y=1100..2900, z=120         |
| 2 | Bundrem PT     | 95×45   | 1810        | 1     | X=5905..6000, Y=1095..2905, z=122..167    |
| 3 | Toprem (gran)  | 95×45   | 1810        | 1     | X=5905..6000, Y=1095..2905, z=2175..2220  |
| 4 | Stud — grid    | 45×95   | 2008        | 4     | Y=1095, 1695, 2295, 2860                  |
| 5 | Mid-rail       | 95×40   | 1810        | 1     | Y=1095..2905, z=1177..1217                |

**V4 i alt:** 4 full-height studs + 1 mid-rail.  
**Løbende meter 45×95:** 4·2,008 = **8,03 m**.  
**Løbende meter 95×40:** **1,81 m**.

---

## Cross-rib topremme (mesh-låg understøtning)

Mesh-låget spænder 4 m over yarden (X=2000..6000), så der lægges
4 ekstra topremme tværs over yarden c/c 1000 mm fra V1-side til V2-side
ved X=2000, 3000, 4000 og 5000. Hver rib butter mellem V1 og V2's
inderfladser (Y=1095..2905 = 1810 mm) og sidder i samme højde som V1+V2
topremmen så meshen ligger fladt på toppen.

Rib ved X=2000 sidder lige op ad V5's yard-side og forstærker hus/yard-
overgangen.

```
            X=2000   X=3000   X=4000   X=5000
              │        │        │        │
   Y=2905 ────┴────────┴────────┴────────┴────────  ← V2 toprem
              │        │        │        │
              │ rib    │ rib    │ rib    │ rib       (set ovenfra på yard-loft)
              │ 1810   │ 1810   │ 1810   │ 1810
              │        │        │        │
   Y=1095 ────┴────────┴────────┴────────┴────────  ← V1 toprem
              X=2000   X=3000   X=4000   X=5000
```

### Skæreliste — cross-rib topremme

| # | Element             | Sektion | Længde (mm) | Antal | Position                     |
| - | ------------------- | ------- | ----------- | ----- | ---------------------------- |
| 1 | Toprem-rib (gran)   | 95×45   | 1810        | 4     | X=2000, 3000, 4000, 5000, Y=1095..2905, z=2175..2220 |

**Cross-ribs i alt:** 4 stk. **Løbende meter 95×45:** 4·1,81 = **7,24 m**.

---

## Samlet skæreliste — Løbegård

| Element                          | Sektion | Længde (mm) | Antal | Total løbende meter |
| -------------------------------- | ------- | ----------- | ----- | ------------------- |
| DPC murpap (V1+V2 yard)          | 100×2   | 4000        | 2     | 8,0 m               |
| DPC murpap (V4)                  | 100×2   | 1800        | 1     | 1,8 m               |
| Bundrem PT (V1+V2 yard)          | 95×45   | 4000        | 2     | 8,0 m               |
| Bundrem PT (V4)                  | 95×45   | 1810        | 1     | 1,81 m              |
| Toprem perimeter (V1+V2 yard)    | 95×45   | 4000        | 2     | 8,0 m               |
| Toprem (V4)                      | 95×45   | 1810        | 1     | 1,81 m              |
| Toprem cross-rib                 | 95×45   | 1810        | 4     | 7,24 m              |
| Full-height stud (V1 7 + V2 8 + V4 4) | 45×95 | 2008      | 19    | 38,15 m             |
| Mid-rail (V1[L+R] + V2 + V4)     | 95×40   | (1465/4000/1810) | 4 | 8,74 m              |

**Total løbende meter 45×95 gran C24 (studs):** **38,15 m**.  
**Total løbende meter 95×45 PT NTR-AB (bundrem):** **9,81 m**.  
**Total løbende meter 95×45 gran (toprem + cross-ribs):** 8,0 + 1,81 + 7,24 = **17,05 m**.  
**Total løbende meter 95×40 gran (mid-rails):** **8,74 m**.  
**Total DPC bånd 100 mm:** **9,8 m**.

### Yard-segment materialeliste (samlet)

| Vare                               | Antal | Brug                                                  |
| ---------------------------------- | ----- | ----------------------------------------------------- |
| Reglar 45 × 95 × 2400 mm gran C24  | 19    | Studs à 2008 mm (200 mm spild pr. stk)                |
| Reglar 45 × 95 × 4200 mm gran C24  | 4     | Topremme V1 + V2 (4000 mm) + 1 rib (1810 mm + spild)  |
| Reglar 45 × 95 × 2400 mm gran C24  | 4     | Cross-ribs + V4 toprem (1810 mm hver)                 |
| Reglar 45 × 95 × 4200 mm PT NTR-AB | 2     | Bundrem V1 + V2 yard (4000 mm)                        |
| Reglar 45 × 95 × 2400 mm PT NTR-AB | 1     | Bundrem V4 (1810 mm)                                  |
| Reglar 95 × 40 × 4200 mm gran      | 3     | Mid-rails — splejses op til 8,7 m total               |
| Bitumen-tape 100 mm × 10 m rulle   | 1     | Murpap — én rulle (9,8 m)                             |
| Ankerskruer M10 × 120              | 11    | Bundrem-til-sokkel c/c 1000 mm (4 V1 + 4 V2 + 3 V4)   |
| Vinkelbeslag 90×90 + skruer        | 8     | 2 hjørner (V1/V4 + V2/V4) × 4 stk                     |
| Vinkelbeslag jamb-til-toprem       | 4     | Yard-dør jamber (top + bund × 2 jamber)               |

---

## Bygge-rækkefølge

1. **DPC** — læg bitumen-tape 100 mm bred ovenpå sokkel-ringen på alle
   yard-vægge (V1+V2 yard-segment + V4).

2. **Bundrem** — bor M10-huller c/c 1000 mm, læg bundrem på plads og
   spænd ankerskruerne. Bundremmen butter mod V5's bundrem ved X=2000.

3. **V4 (højre)** først — 4 studs c/c 600 + end-emit. Top-plade ovenpå.

4. **V1[yard] (front-segment)**:
   - Stil grid-studs X=2000, 2600, 5000, 5600, 5955.
   - Stil yard-dør jamber X=3420 og X=4535.
   - Læg topremmen ovenpå — den BLIVER yard-dør-headeren.
   - Fastgør mid-rails (X=2000..3465 og X=4535..6000) ved z=1177..1217.

5. **V2[yard] (bag-segment)**:
   - Stil 8 grid-studs c/c 600.
   - Top-plade ovenpå.
   - Mid-rail full-length (X=2000..6000).

6. **Cross-rib topremme** — sæt de 4 ribs ved X=2000, 3000, 4000, 5000
   ovenpå V1's og V2's topremme. Hver rib er 1810 mm lang og lukker
   span'et fra V1 til V2.

7. **Mid-rail på V4** — fastgør 1810 mm mid-rail i z=1177..1217 indvendigt
   mellem V1 og V2.

8. **Vinkelbeslag** — fastgør V4 mod V1+V2 og spænd alle samlinger.

---

## Verifikation i OpenSCAD

`src/main.scad` rendrer hele yard-skelettet når `RenderYardFraming()` er
enabled. Tjek inden materialebestilling:

- Toprem flat på alle 3 yard-vægge (mesh-låg oven på)
- Stud-længde 2008 mm ens på V1[yard], V2[yard], V4
- Toprem-top ved z = 2220 mm (= 192 mm under hus-toprem)
- 4 cross-rib topremme synlige tværs over yarden c/c 1000 mm
- Mid-rail springer continuous gennem yard-dør-åbningen som vandret stiver
- Yard-dørens åbning når op til topremmen → ingen separat dør-header
