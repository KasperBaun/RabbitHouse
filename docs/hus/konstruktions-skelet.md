# Konstruktions-skelet — Hus

> Implementeret i `src/designs/house/framing.scad` (`RenderHouseFraming()`).  
> Yard-segmentets pendant ligger i [løbegård/konstruktions-skelet.md](../løbegård/konstruktions-skelet.md).

Hus-skelettet sidder oven på fundamentet (se [fundament.md](fundament.md))
og består af 4 lag pr. væg. Alle mål i mm.

## Stak gennem en hus-væg

```
z=2412 ┌────── toprem 45×95 ──────┐    toprem-top (= bund af tag-spær)
       │                          │
z=2367 │                          │    toprem-bund (= stud-top)
       │                          │
       │   stud 45×95 C24         │    stud-længde 2200 mm præcis
       │   c/c 600 mm             │
       │                          │
z=212  │                          │    stud-bund (= bundrem-top)
       ├────── bundrem 45×95 ─────┤    PT NTR-AB (trykimprægneret)
z=167  ├────── DPC 100×2 ─────────┤    bitumen-murpap
z=122  ╞══════════════════════════╡
z=120  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    sokkel-top (fundablok-ring)
```

`RH_BASE_H = 120` (sokkel-top over grade), `RH_DPC_T = 2`, `RH_SILL_H = 45`,
`RH_EH_FRONT = RH_EH_BACK = 2292` → flad eave på alle 4 hus-vægge, gable-spær
hviler oven på topremmen.

## Mål-oversigt

| Egenskab                | Værdi                                      |
| ----------------------- | ------------------------------------------ |
| Hus-fodaftryk           | 2000 × 3000 mm (X = 0..2000, Y = 0..3000)  |
| Sokkel-top              | z = 120 mm                                 |
| Gulv-top                | z = 167 mm (= bundrem-top, DPC + sill)     |
| Stud-bund               | z = 167 mm                                 |
| Stud-top                | z = 2367 mm                                |
| Toprem-top              | z = 2412 mm                                |
| Stud-længde             | 2200 mm — samme på alle 4 hus-vægge        |
| Stud-sektion            | 45 × 95 mm gran C24                        |
| Stud c/c                | 600 mm                                     |
| Bundrem-/toprem-sektion | 95 × 45 mm (95 mm bred langs væggens dybde)|

Vægge: **V1** front (Y=0), **V2** bag (Y=2905..3000), **V3** venstre (X=0..95),
**V5** partition (X=1905..2000). V3 og V5 butter mellem V1 og V2's
inderfladser i Y=95..2905 og er begge 2810 mm lange.

---

## V1 — Front (med dør + 2 vinduer)

**Position:** Y=0..95, X=0..2000 (2000 mm lang).  
**Åbninger:**
- Dobbelt-lade-dør 900 × 2000 mm centreret om X=1000 (åbning X=550..1450)
- Venstre vindue 415 × 450 mm (åbning X=45..460, z=1167..1617)
- Højre vindue 415 × 450 mm (åbning X=1540..1955, z=1167..1617)

Vinduernes sål ligger i z=1167 (= halv dørhøjde over gulv). Hver vindue har
**én dedikeret full-height vindue-jamb** mod dør-jamben (separat træ, ikke
fastgjort til dør-karmen) plus outer-cripples under sål og over header på
hjørnesiden.

### Elevation (set udefra)

```
z=2412 ─────────────────────────── tag-spær hviler ovenpå ────────────────────────────
       ┌──────────────────────────────────────────────────────────────────────────────┐
z=2367 │                          TOPREM 45×95 — 2000 mm                                │
       ├──┬───┬───────┬────┬────┬─────────────────────────────────┬────┬────┬───────┬───┬──┤
       │  │░░░│═══════│    │    │░░░░░ cripple over dør ░░░░░░░░░░│    │    │═══════│░░░│  │  } over hdr
       │  │░░░│ hdr   │    │    │             X=828..873          │    │    │ hdr   │░░░│  │   (cripple = 705)
z=2212 │  │░░░├═══════┤    │    ├─────────────────────────────────┤    │    ├═══════┤░░░│  │  ← dør-header
z=2167 │  │░░░│       │    │    │                                 │    │    │       │░░░│  │
       │  │   │       │    │    │                                 │    │    │       │   │  │
z=1712 │K │   │═══════│ WJ │ DJ │                                 │ DJ │ WJ │═══════│   │ J│  ← vindue-header
z=1662 │  │   │ hdr   │    │    │                                 │    │    │ hdr   │   │  │
       │  │   │       │    │    │       D Ø R   åbning            │    │    │       │   │  │
       │  │   │ VINDUE│    │    │         900 × 2000              │    │    │ VINDUE│   │  │
       │  │   │ åbning│    │    │                                 │    │    │ åbning│   │  │
       │  │   │415×450│    │    │                                 │    │    │415×450│   │  │
z=1167 │  │   ├═══════┤    │    │                                 │    │    ├═══════┤   │  │  ← vindue-sål
z=1122 │  │   │ sål   │    │    │                                 │    │    │ sål   │   │  │
       │  │░░░│       │    │    │                                 │    │    │       │░░░│  │  } under sål
       │  │░░░│       │    │    │                                 │    │    │       │░░░│  │   (cripple = 955)
       │  │░░░│       │    │    │                                 │    │    │       │░░░│  │
z=212  ╞══╧═══╧═══════╧════╧════╧═════════════════════════════════╧════╧════╧═══════╧═══╧══╡
       │                          BUNDREM 95×45 — 2000 mm                                  │
z=167  ├──────────────────────────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░░░░░░░░░░░ DPC 100×2 — 2000 mm ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └──────────────────────────────────────────────────────────────────────────────────┘
        X=0  45  90    460 505    550                          1450 1495  1540   1910 1955  2000

  K  = hjørnestud (X=0..45, full-h)                  J  = junction-stud (X=1955..2000, full-h)
  DJ = dør-jamb (full-h, X=505..550 og X=1450..1495)
  WJ = vindue-jamb (full-h, X=460..505 og X=1495..1540) — separat træ, ikke fastgjort til DJ
  ░░░ = outer-cripple (vindue): under sål 955 mm + over header 705 mm
  ═══ = sål / header (45 mm tykt 95×45-stykke på fladsiden)
```

### Skæreliste — V1

| #  | Element                          | Sektion  | Længde (mm) | Antal | Position                                                    |
| -- | -------------------------------- | -------- | ----------- | ----- | ----------------------------------------------------------- |
| 1  | DPC murpap                       | 100×2    | 2000        | 1     | Y=0..100, z=120                                             |
| 2  | Bundrem PT                       | 95×45    | 2000        | 1     | Y=0..95, z=122..167                                         |
| 3  | Toprem (gran)                    | 95×45    | 2000        | 1     | Y=0..95, z=2367..2412                                       |
| 4  | Stud — hjørne (mod V3)           | 45×95    | 2200        | 1     | X=0..45                                                     |
| 5  | Stud — junction (mod V5)         | 45×95    | 2200        | 1     | X=1955..2000                                                |
| 6  | Stud — dør-jamb                  | 45×95    | 2200        | 2     | X=505..550 og X=1450..1495                                  |
| 7  | Stud — vindue-jamb (separat)     | 45×95    | 2200        | 2     | X=460..505 og X=1495..1540                                  |
| 8  | Cripple — vindue under sål       | 45×95    | 955         | 2     | X=45..90 og X=1910..1955, z=167..1122                       |
| 9  | Cripple — vindue over header     | 45×95    | 705         | 2     | X=45..90 og X=1910..1955, z=1662..2367                      |
| 10 | Cripple — over dør-header        | 45×95    | 155         | 1     | X=828..873, z=2212..2367                                    |
| 11 | Dør-header                       | 95×45    | 900         | 1     | X=550..1450, z=2167..2212                                   |
| 12 | Vindue-header                    | 95×45    | 415         | 2     | X=45..460 og X=1540..1955, z=1617..1662                     |
| 13 | Vindue-sål (rough)               | 95×45    | 415         | 2     | X=45..460 og X=1540..1955, z=1122..1167                     |

**V1 i alt:** 6 full-height studs (2200) + 5 cripples + 5 plader/headers/såle  
**Løbende meter 45×95 i V1:** 6·2,2 + 2·0,955 + 2·0,705 + 0,155 + 2·0,9 + 2·2·0,415 ≈ **20,8 m** (ekskl. DPC og bundrem-PT).

---

## V2 — Bag (intet)

**Position:** Y=2905..3000, X=0..2000 (2000 mm lang).  
**Åbninger:** ingen.

Solid væg c/c 600 mm.

### Elevation (set udefra, +Y mod kameraet)

```
z=2412 ─────────────────────── tag-spær hviler ovenpå ────────────────────────
       ┌──────────────────────────────────────────────────────────────────┐
z=2367 │                     TOPREM 45×95 — 2000 mm                         │
       ├──┬──────┬──────┬──────┬───────────────────────────┬──┬───────────┤
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
       │ S│  S   │  S   │  S   │      (intet — solid)      │ S│   J       │
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
       │  │      │      │      │                           │  │           │
z=212  ╞══╧══════╧══════╧══════╧═══════════════════════════╧══╧═══════════╡
       │                     BUNDREM 95×45 — 2000 mm                       │
z=167  ├──────────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░░░ DPC 100×2 — 2000 mm ░░░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └──────────────────────────────────────────────────────────────────┘
        X=0     600    1200   1800                                   1955  2000

  S = grid-stud c/c 600 (full-h)            J = junction-stud (X=1955..2000)
```

### Skæreliste — V2

| # | Element                  | Sektion | Længde (mm) | Antal | Position                              |
| - | ------------------------ | ------- | ----------- | ----- | ------------------------------------- |
| 1 | DPC murpap               | 100×2   | 2000        | 1     | Y=2900..3000, z=120                   |
| 2 | Bundrem PT               | 95×45   | 2000        | 1     | Y=2905..3000, z=122..167              |
| 3 | Toprem (gran)            | 95×45   | 2000        | 1     | Y=2905..3000, z=2367..2412            |
| 4 | Stud — grid              | 45×95   | 2200        | 4     | X=0, 600, 1200, 1800                  |
| 5 | Stud — junction (mod V5) | 45×95   | 2200        | 1     | X=1955..2000                          |

**V2 i alt:** 5 full-height studs. **Løbende meter 45×95:** 5·2,2 = **11,0 m**.

---

## V3 — Venstre (solid)

**Position:** X=0..95, Y=95..2905 (2810 mm lang, butter mellem V1 og V2).  
**Åbninger:** ingen.

Solid Y-væg. Eave er flad (gable-tag oven på), så alle V3-studs er lige
lange. 6 studs i alt — 5 c/c 600 plus én "end-emit" stud tæt på V3/V2-hjørnet.

### Elevation (set udefra, –X mod kameraet)

```
z=2412 ─────────────────── tag-spær hviler ovenpå ───────────────────
       ┌────────────────────────────────────────────────────────────┐
z=2367 │                  TOPREM 45×95 — 2810 mm                      │
       ├──┬──────┬──────┬──────┬──────┬──────┬───┬───────────────────┤
       │  │      │      │      │      │      │   │                   │
       │ S│  S   │  S   │  S   │  S   │  S   │ E │  ← end-emit       │
       │  │      │      │      │      │      │   │  (gridstudben     │
       │  │      │      │      │      │      │   │   ved Y=2860)      │
       │  │      │      │      │      │      │   │                   │
       │  │      │      │      │      │      │   │                   │
z=212  ╞══╧══════╧══════╧══════╧══════╧══════╧═══╧═══════════════════╡
       │                 BUNDREM 95×45 — 2810 mm                       │
z=167  ├────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░ DPC 100×2 — 2800 mm ░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └────────────────────────────────────────────────────────────┘
       Y=95   695    1295   1895   2495   2860..2905

  S = grid-stud c/c 600 (full-h)         E = end-emit stud (Y=2860..2905)
```

### Skæreliste — V3

| # | Element       | Sektion | Længde (mm) | Antal | Position                                |
| - | ------------- | ------- | ----------- | ----- | --------------------------------------- |
| 1 | DPC murpap    | 100×2   | 2800        | 1     | X=0..100, Y=100..2900                   |
| 2 | Bundrem PT    | 95×45   | 2810        | 1     | X=0..95, Y=95..2905                     |
| 3 | Toprem (gran) | 95×45   | 2810        | 1     | X=0..95, Y=95..2905, z=2367..2412       |
| 4 | Stud — grid   | 45×95   | 2200        | 6     | Y=95, 695, 1295, 1895, 2495, 2860       |

**V3 i alt:** 6 full-height studs. **Løbende meter 45×95:** 6·2,2 = **13,2 m**.

> V3 og V1 deler en hjørnesamling: V1's hjørnestud (X=0..45, Y=0..95) sidder
> vinkelret på V3's første stud (X=0..95, Y=95..140). De rører hinanden langs
> kanten Y=95 og slås sammen med vinkelbeslag eller skruer gennem hjørnet.

---

## V5 — Partition (med hus-dør + pet-dør)

**Position:** X=1905..2000, Y=95..2905 (2810 mm lang, butter mellem V1 og V2).  
**Åbninger:**
- **Hus-dør** 870 × 2000 mm (rough opening Y=1500..2370, z=167..2167) — åbner mod yard (+X)
- **Pet-dør** 250 × 300 mm (rough opening Y=2700..2950, z=227..527) — kanin-passage mellem hus og yard

Hus-dørens header-overkant er præcis 200 mm under topremmen → 1 cripple over.
Pet-dørens åbning er for smal (250 mm < c/c-bredden 600 mm) til at koden
genererer cripples over, så der står 1795 mm tom væg mellem pet-dør-header
og toprem.

### Elevation (set fra yard, +X mod kameraet)

```
z=2412 ─────────────────────── tag-spær hviler ovenpå ───────────────────────
       ┌──────────────────────────────────────────────────────────────────┐
z=2367 │                  TOPREM 45×95 — 2810 mm                            │
       ├──┬──────┬─────────┬──────────────────┬──────┬─────────────┬───┬──┤
       │  │      │░░░░░░░░░│                  │      │             │   │  │
       │  │      │░░░ cri ░│ (intet over pet- │      │             │   │  │
       │  │      │░░░░░░░░░│  dør — for smal  │      │             │   │  │
z=2212 │  │      ├═════════┤  åbning)         │      │             │   │  │  ← hus-dør header
z=2167 │  │      │         │                  │      │             │   │  │
       │  │      │         │                  │      │             │   │  │
       │ S│  S   │         │                  │  Pj  │             │ Pj│E │
       │  │      │  HUS-   │                  │      │  PET-       │   │  │
       │  │      │  DØR    │                  │      │  DØR        │   │  │
       │  │      │  åbning │      [SOLID]     │      │  åbning     │   │  │
       │  │      │ 870×2000│                  │      │   250×300   │   │  │
       │  │      │         │                  │      │             │   │  │
z=572  │  │      │         │                  │      ├═════════════┤   │  │  ← pet-dør header
z=527  │  │      │         │                  │      │             │   │  │
       │  │      │         │                  │      │             │   │  │
       │  │      │         │                  │      │  (sokkel    │   │  │
       │  │      │         │                  │      │   under)    │   │  │
z=227  │  │      │         │                  │      ├═════════════┤   │  │  ← pet-dør sål-trin
z=212  ╞══╧══════╧═════════╧══════════════════╧══════╧═════════════╧═══╧══╡
       │                  BUNDREM 95×45 — 2810 mm                          │
z=167  ├──────────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░ DPC 100×2 — 2800 mm ░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └──────────────────────────────────────────────────────────────────┘
       Y=95   695   1455      1500..2370    2655 2700        2950 2860 2905
                    (Dj-V)                   (Pj)            (Pj)  (E)

  S  = grid-stud c/c 600 (full-h, Y=95 og Y=695)
  Dj = dør-jamb (full-h, Y=1455 og Y=2370)
  Pj = pet-dør jamb (full-h, Y=2655 og Y=2950)
  E  = end-emit stud (Y=2860..2905) — falder inde i pet-dør-åbningen, se ⚠ note
  ░░░ = cripple over hus-dør header (Y=1778..1823, h=155)
```

### Skæreliste — V5

| # | Element                       | Sektion | Længde (mm) | Antal | Position                                              |
| - | ----------------------------- | ------- | ----------- | ----- | ----------------------------------------------------- |
| 1 | DPC murpap                    | 100×2   | 2800        | 1     | X=1900..2000, Y=100..2900                             |
| 2 | Bundrem PT                    | 95×45   | 2810        | 1     | X=1905..2000, Y=95..2905, z=122..167                  |
| 3 | Toprem (gran)                 | 95×45   | 2810        | 1     | X=1905..2000, Y=95..2905, z=2367..2412                |
| 4 | Stud — grid                   | 45×95   | 2200        | 3     | Y=95, 695, 2860                                       |
| 5 | Stud — hus-dør jamb           | 45×95   | 2200        | 2     | Y=1455 og Y=2370                                      |
| 6 | Stud — pet-dør jamb           | 45×95   | 2200        | 2     | Y=2655 og Y=2950                                      |
| 7 | Hus-dør header                | 95×45   | 870         | 1     | Y=1500..2370, z=2167..2212                            |
| 8 | Cripple over hus-dør header   | 45×95   | 155         | 1     | Y=1778..1823, z=2212..2367                            |
| 9 | Pet-dør header                | 95×45   | 250         | 1     | Y=2700..2950, z=527..572                              |

**V5 i alt:** 7 full-height studs + 2 headers + 1 cripple.  
**Løbende meter 45×95:** 7·2,2 + 0,155 + 0,87 + 0,25 ≈ **16,7 m**.

> ⚠ **End-emit stud (Y=2860)**: koden emitterer en grid-stud ved
> Y=2860..2905 (= `end_stud_x` i `_studs_one_wall`) som skip-range-tjekket
> ikke fanger. Den falder fysisk inde i pet-dørens åbning (Y=2700..2950).
> Hvis du bygger 1:1, kan studen udelades — pet-døren er kun 250 mm bred og
> har sine egne jamber ved Y=2655 og Y=2950.

---

## Junction-studs (V5/V1 og V5/V2 hjørner)

Junction-studene fylder hjørnerne ved (X=1955..2000, Y=0..95) og
(X=1955..2000, Y=2905..3000). De er allerede medregnet i V1 og V2's
skærelister (#5 i hver) — listes her kun for klarhed.

| Element                  | Sektion | Længde (mm) | Antal | Hører til    |
| ------------------------ | ------- | ----------- | ----- | ------------ |
| Stud — junction V1/V5    | 45×95   | 2200        | 1     | V1's række 5 |
| Stud — junction V2/V5    | 45×95   | 2200        | 1     | V2's række 5 |

V5's studs ved Y=95 og Y=2860 (grid) ligger lige inde for junction-studene —
de slås sammen med L-vinkelbeslag eller skruer gennem hjørnet for at låse
V5 mod V1 og V2.

---

## Samlet skæreliste — Hus

| Element                             | Sektion | Længde (mm) | Antal | Total løbende meter |
| ----------------------------------- | ------- | ----------- | ----- | ------------------- |
| DPC murpap (V1+V2 perimeter)        | 100×2   | 2000        | 2     | 4,0 m               |
| DPC murpap (V3 + V5 cross)          | 100×2   | 2800        | 2     | 5,6 m               |
| Bundrem PT (V1+V2)                  | 95×45   | 2000        | 2     | 4,0 m               |
| Bundrem PT (V3 + V5)                | 95×45   | 2810        | 2     | 5,62 m              |
| Toprem gran (V1+V2)                 | 95×45   | 2000        | 2     | 4,0 m               |
| Toprem gran (V3 + V5)               | 95×45   | 2810        | 2     | 5,62 m              |
| Full-height stud (V1 6 + V2 5 + V3 6 + V5 7) | 45×95 | 2200    | 24    | 52,8 m              |
| Cripple — vindue under sål          | 45×95   | 955         | 2     | 1,91 m              |
| Cripple — vindue over header        | 45×95   | 705         | 2     | 1,41 m              |
| Cripple — V1 dør header             | 45×95   | 155         | 1     | 0,155 m             |
| Cripple — V5 hus-dør header         | 45×95   | 155         | 1     | 0,155 m             |
| V1 dør-header                       | 95×45   | 900         | 1     | 0,9 m               |
| V5 hus-dør header                   | 95×45   | 870         | 1     | 0,87 m              |
| V5 pet-dør header                   | 95×45   | 250         | 1     | 0,25 m              |
| Vindue-header                       | 95×45   | 415         | 2     | 0,83 m              |
| Vindue-sål                          | 95×45   | 415         | 2     | 0,83 m              |

**Total løbende meter 45×95 gran C24:** 52,8 + 5,18 = **57,98 m** (studs + headers + cripples + sål).  
**Total løbende meter 95×45 PT NTR-AB:** 4,0 + 5,62 = **9,62 m** (bundrem).  
**Total løbende meter 95×45 gran:** 4,0 + 5,62 = **9,62 m** (toprem).  
**Total DPC bånd 100 mm:** **9,6 m**.

### Hus-segment materialeliste (samlet 45×95)

| Vare                                | Antal | Brug                                                                |
| ----------------------------------- | ----- | ------------------------------------------------------------------- |
| Reglar 45 × 95 × 2400 mm gran C24   | 25    | 24 studs à 2200 mm + spild dækker headers/cripples/sål (~5,2 m)    |
| Reglar 45 × 95 × 3000 mm gran C24   | 4     | 2 stk topremme V3 + V5 (2810 mm) + 2 stk topremme V1 + V2 (2000 mm) |
| Reglar 45 × 95 × 3000 mm PT NTR-AB  | 4     | 2 stk bundremme V3 + V5 (2810 mm) + 2 stk bundremme V1 + V2 (2000 mm) |
| Bitumen-tape 100 mm × 10 m rulle    | 1     | Murpap — én rulle dækker hele hus + V5-cross (9,6 m)               |
| Ankerskruer M10 × 120               | 10    | Bundrem-til-sokkel c/c 1000 mm (2 V1 + 2 V2 + 3 V3 + 3 V5)         |
| Vinkelbeslag 90×90 + skruer         | 16    | 4 hjørner × 4 stk (2 oppe + 2 nede V3-corner, V5/V1 + V5/V2)        |
| Vinkelbeslag jamb-til-toprem        | 12    | 6 hus-dør + pet-dør + vindue jamber × 2 (top + bund)               |

Headers og sål skæres af spild fra 2400 mm-stokken (~200 mm spild pr. stud × 24 = 4,8 m).

---

## Bygge-rækkefølge

1. **DPC** — læg bitumen-tape 100 mm bred ovenpå hele sokkel-ringen
   (perimeter + V5-cross). Lap 100 mm ved samlinger.

2. **Bundrem** — bor gennemgangshuller for M10 ankerskruer (c/c 1000 mm)
   i de fire bundrem-stykker. Læg på plads og spænd møtrikkerne.

3. **V3 (venstre)** først — rejs alle 6 studs c/c 600 mm. Læg topremmen
   ovenpå og fastgør med 2 skruer pr. stud.

4. **V1 (front)**:
   - Stil hjørnestuden (X=0..45) op mod V3's første stud — vinkelbeslag.
   - Stil junction-studen (X=1955..2000).
   - Sæt vindue-jamberne (X=460..505 og X=1495..1540).
   - Sæt dør-jamberne (X=505..550 og X=1450..1495) — vindue-jamb og dør-jamb
     står flush mod hinanden men er to selvstændige reglar.
   - Sæt vindue-headers (415 mm) og vindue-såle (415 mm) mellem
     hjørne/jamb-studs og vindue-jamberne. Sæt dør-headeren (900 mm)
     mellem dør-jamberne.
   - Sæt outer-cripples under sål (955 mm) og over header (705 mm) lige
     ved hjørne/junction-studens side af åbningen.
   - Sæt cripple over dør-header (155 mm) i midten.
   - Læg topremmen ovenpå.

5. **V2 (bag)** — rejs alle 5 studs c/c 600 mm + junction-stud. Læg toprem.

6. **V5 (partition)**:
   - Sæt grid-studs Y=95 og Y=695.
   - Sæt hus-dør jamber Y=1455 og Y=2370 + headerstykket (870 mm) +
     cripple (155 mm) i midten over headeren.
   - Sæt pet-dør jamber Y=2655 og Y=2950 + headerstykket (250 mm) ved
     z=527 (60 mm over gulv-top + 300 mm dyrebredde).
   - Udelad end-emit-studen Y=2860 (den falder inde i pet-dør-åbningen).
   - Læg topremmen ovenpå.

7. **Vinkelbeslag** — fastgør V3 mod V1+V2-hjørner og V5 mod V1+V2-hjørner
   med 90×90 vinkelbeslag (2 stk pr. hjørne, top og bund).

---

## Verifikation i OpenSCAD

`src/main.scad` rendrer hele skelettet når `RenderHouseFraming()` er enabled
(under `// house`-sektionen). Tjek inden materialebestilling:

- Toprem skal være flat på alle 4 hus-vægge (gable-spær oven på)
- Stud-længde 2200 mm ens på V1, V2, V3, V5
- V3 har ingen åbninger (cutout-vinduet er fjernet i nuværende design)
- V5 har 2 cutouts (hus-dør Y=1500..2370 + pet-dør Y=2700..2950)
- V1 har 3 cutouts (dør X=550..1450 + 2 vinduer på hver side)
- Junction-studs synlige som "dobbelt-stud" ved V5/V1- og V5/V2-hjørner
- Vindue-jamb og dør-jamb på V1 står som to adskilte reglar (≈90 mm
  samlet bredde) mod hinanden ved dør-vindue-overgangen
