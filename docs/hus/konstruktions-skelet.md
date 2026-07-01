# Konstruktions-skelet — Hus

> Implementeret i `src/designs/house/framing.scad` (`RenderHouseFraming()`).  
> Yard-segmentets pendant ligger i [løbegård/konstruktions-skelet.md](../løbegård/konstruktions-skelet.md).

Hus-skelettet sidder oven på fundamentet (se [fundament.md](fundament.md))
og består af 4 lag pr. væg. Alle mål i mm.

## Stak gennem en hus-væg

```
z=2212 ┌────── toprem 45×95 ──────┐    toprem-top (= bund af tag-spær)
       │                          │
z=2167 │                          │    toprem-bund (= stud-top)
       │                          │
       │   stud 45×95 C24         │    stud-længde 2000 mm præcis
       │   c/c 600 mm             │
       │                          │
z=212  │                          │    stud-bund (= bundrem-top)
       ├────── bundrem 45×95 ─────┤    PT NTR-AB (trykimprægneret)
z=167  ├────── DPC 100×2 ─────────┤    bitumen-murpap
z=122  ╞══════════════════════════╡
z=120  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    sokkel-top (fundablok-ring)
```

`RH_BASE_H = 120` (sokkel-top over grade), `RH_DPC_T = 2`, `RH_SILL_H = 45`,
`RH_EH_FRONT = RH_EH_BACK = 2092` → flad eave på alle 4 hus-vægge, gable-spær
hviler oven på topremmen.

## Mål-oversigt

| Egenskab                | Værdi                                      |
| ----------------------- | ------------------------------------------ |
| Hus-fodaftryk           | 2000 × 3000 mm (X = 0..2000, Y = 0..3000)  |
| Sokkel-top              | z = 120 mm                                 |
| Gulv-top                | z = 167 mm (= bundrem-top, DPC + sill)     |
| Stud-bund               | z = 167 mm                                 |
| Stud-top                | z = 2167 mm                                |
| Toprem-top              | z = 2212 mm                                |
| Stud-længde             | 2000 mm — samme på alle 4 hus-vægge        |
| Stud-sektion            | 45 × 95 mm gran C24                        |
| Stud c/c                | 600 mm                                     |
| Bundrem-/toprem-sektion | 95 × 45 mm (95 mm bred langs væggens dybde)|

Vægge: **V1** front (Y=0), **V2** bag (Y=2905..3000), **V3** venstre (X=0..95),
**V4** partition (X=1905..2000). V3 og V4 butter mellem V1 og V2's
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
z=2212 ─────────────────────────── tag-spær hviler ovenpå ────────────────────────────
       ┌──────────────────────────────────────────────────────────────────────────────┐
z=2167 │                          TOPREM 45×95 — 2000 mm                                │
       ├──┬───┬───────┬────┬────┬─────────────────────────────────┬────┬────┬───────┬───┬──┤
       │  │░░░│═══════│    │    │░░░░░ cripple over dør ░░░░░░░░░░│    │    │═══════│░░░│  │  } over hdr
       │  │░░░│ hdr   │    │    │             X=828..873          │    │    │ hdr   │░░░│  │   (cripple = 505)
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
  ░░░ = outer-cripple (vindue): under sål 955 mm + over header 505 mm
  ═══ = sål / header (45 mm tykt 95×45-stykke på fladsiden)
```

> **Bemærk (2000 mm vægge):** dørene (2000) = væghøjde, så 'dør-header'- og
> 'cripple over dør'-rækkerne i elevations-ASCII'et falder nu sammen med
> topremmen — topremmen spænder dør-åbningen som header, og der er ingen
> cripple over dørene. Elevationen er skematisk; se skæreliste-tabellen
> nedenfor og [skaereliste/](../skaereliste/00-oversigt.md) for præcise mål.

### Skæreliste — V1

| #  | Element                          | Sektion  | Længde (mm) | Antal | Position                                                    |
| -- | -------------------------------- | -------- | ----------- | ----- | ----------------------------------------------------------- |
| 1  | DPC murpap                       | 100×2    | 2000        | 1     | Y=0..100, z=120                                             |
| 2  | Bundrem PT                       | 95×45    | 2000        | 1     | Y=0..95, z=122..167                                         |
| 3  | Toprem (gran, = dør-header)      | 95×45    | 2000        | 1     | Y=0..95, z=2167..2212 — spænder dør-åbningen som header     |
| 4  | Stud — hjørne (mod V3)           | 45×95    | 2000        | 1     | X=0..45                                                     |
| 5  | Stud — junction (mod V4)         | 45×95    | 2000        | 1     | X=1955..2000                                                |
| 6  | Stud — dør-jamb                  | 45×95    | 2000        | 2     | X=505..550 og X=1450..1495                                  |
| 7  | Stud — vindue-jamb (separat)     | 45×95    | 2000        | 2     | X=460..505 og X=1495..1540                                  |
| 8  | Cripple — vindue under sål       | 45×95    | 955         | 2     | X=45..90 og X=1910..1955, z=167..1122                       |
| 9  | Cripple — vindue over header     | 45×95    | 505         | 2     | X=45..90 og X=1910..1955, z=1662..2167                      |
| 10 | Vindue-header                    | 95×45    | 415         | 2     | X=45..460 og X=1540..1955, z=1617..1662                     |
| 11 | Vindue-sål (rough)               | 95×45    | 415         | 2     | X=45..460 og X=1540..1955, z=1122..1167                     |

**V1 i alt:** 6 full-height studs (2000) + 4 vindue-cripples + 4 vindue-headers/såle (dør-header = toprem, ingen cripple over dør)  
**Løbende meter 45×95 i V1:** 6·2,0 + 2·0,955 + 2·0,505 + 2·2·0,415 ≈ **16,6 m** (ekskl. DPC og bundrem-PT).

---

## V2 — Bag (intet)

**Position:** Y=2905..3000, X=0..2000 (2000 mm lang).  
**Åbninger:** ingen.

Solid væg c/c 600 mm.

### Elevation (set udefra, +Y mod kameraet)

```
z=2212 ─────────────────────── tag-spær hviler ovenpå ────────────────────────
       ┌──────────────────────────────────────────────────────────────────┐
z=2167 │                     TOPREM 45×95 — 2000 mm                         │
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
| 3 | Toprem (gran)            | 95×45   | 2000        | 1     | Y=2905..3000, z=2167..2212            |
| 4 | Stud — grid              | 45×95   | 2000        | 4     | X=0, 600, 1200, 1800                  |
| 5 | Stud — junction (mod V4) | 45×95   | 2000        | 1     | X=1955..2000                          |

**V2 i alt:** 5 full-height studs. **Løbende meter 45×95:** 5·2,0 = **11,0 m**.

---

## V3 — Venstre (med sidevindue)

**Position:** X=0..95, Y=95..2905 (2810 mm lang, butter mellem V1 og V2).  
**Åbninger:** Sidevindue 700 × 600 mm, centreret (åbning Y=1150..1850, sål-top z=1267, header-bund z=1867).

Y-væg med ét sidevindue. Eave er flad (gable-tag oven på), så alle V3-studs er
lige lange. Grid-studsene ved Y=1295 og 1895 udgår i vindues-åbningen og
erstattes af 2 dedikerede vindue-jambs; header + sål spænder åbningen med én
cripple under sålen og én over headeren. 6 full-height studs i alt (4 grid + 2
jamb).

### Elevation (set udefra, –X mod kameraet)

```
z=2212 ─────────────────── tag-spær hviler ovenpå ───────────────────
       ┌────────────────────────────────────────────────────────────┐
z=2167 │                  TOPREM 45×95 — 2810 mm                      │
       ├──┬──────┬─────┬───────────┬─────┬──────┬──────┬─────────────┤
       │  │      │     │░ crip 255 ░│     │      │      │             │  } over hdr
z=1912 │  │      │     ├───────────┤     │      │      │             │  ← vindue-header
       │  │      │ WJ  │           │ WJ  │      │      │             │
z=1867 │  │      │     │  VINDUE   │     │      │      │             │
       │ S│  S   │     │  700×600  │     │  S   │  S   │  E          │
z=1267 │  │      │     ├───────────┤     │      │      │             │  ← vindue-sål
z=1222 │  │      │     │░ crip     │     │      │      │             │  } under sål
       │  │      │     │░ 1055     │     │      │      │             │
z=212  ╞══╧══════╧═════╧═══════════╧═════╧══════╧══════╧═════════════╡
       │                 BUNDREM 95×45 — 2810 mm                      │
z=167  ├────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░ DPC 100×2 — 2800 mm ░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └────────────────────────────────────────────────────────────┘
       Y=95  695  1105 1150      1850 1895 2495   2860

  S  = grid-stud c/c 600 (full-h, Y=95/695/2495)   E = end-emit (Y=2860)
  WJ = vindue-jamb (full-h, Y=1105..1150 og Y=1850..1895)
  ░░░ = cripple (vindue): under sål 1055 + over header 255 (Y=1427..1472)
  ═══ = sål / header (45 mm 95×45 på fladsiden)
```

### Skæreliste — V3

| # | Element                      | Sektion | Længde (mm) | Antal | Position                               |
| - | ---------------------------- | ------- | ----------- | ----- | -------------------------------------- |
| 1 | DPC murpap                   | 100×2   | 2800        | 1     | X=0..100, Y=100..2900                  |
| 2 | Bundrem PT                   | 95×45   | 2810        | 1     | X=0..95, Y=95..2905                    |
| 3 | Toprem (gran)                | 95×45   | 2810        | 1     | X=0..95, Y=95..2905, z=2167..2212      |
| 4 | Stud — grid                  | 45×95   | 2000        | 4     | Y=95, 695, 2495, 2860                  |
| 5 | Stud — vindue-jamb           | 45×95   | 2000        | 2     | Y=1105..1150 og Y=1850..1895           |
| 6 | Cripple — vindue under sål   | 45×95   | 1055        | 1     | Y=1427..1472, z=167..1222              |
| 7 | Cripple — vindue over header | 45×95   | 255         | 1     | Y=1427..1472, z=1912..2167             |
| 8 | Vindue-header                | 95×45   | 700         | 1     | Y=1150..1850, z=1867..1912             |
| 9 | Vindue-sål (rough)           | 95×45   | 700         | 1     | Y=1150..1850, z=1222..1267             |

**V3 i alt:** 6 full-height studs (4 grid + 2 vindue-jamb) + 2 cripples + 2 header/sål.  
**Løbende meter 45×95 i V3:** 6·2,0 + 1,055 + 0,255 + 2·0,7 ≈ **14,7 m** (ekskl. DPC og bundrem-PT).

> V3 og V1 deler en hjørnesamling: V1's hjørnestud (X=0..45, Y=0..95) sidder
> vinkelret på V3's første stud (X=0..95, Y=95..140). De rører hinanden langs
> kanten Y=95 og slås sammen med vinkelbeslag eller skruer gennem hjørnet.

---

## V4 — Partition (med hus-dør + pet-dør)

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
z=2212 ─────────────────────── tag-spær hviler ovenpå ───────────────────────
       ┌──────────────────────────────────────────────────────────────────┐
z=2167 │                  TOPREM 45×95 — 2810 mm                            │
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
       Y=95   695   1255      1500..2370    2655 2700        2950 2860 2905
                    (Dj-V)                   (Pj)            (Pj)  (E)

  S  = grid-stud c/c 600 (full-h, Y=95 og Y=695)
  Dj = dør-jamb (full-h, Y=1255 og Y=2370)
  Pj = pet-dør jamb (full-h, Y=2655 og Y=2950)
  E  = end-emit stud (Y=2860..2905) — falder inde i pet-dør-åbningen, se ⚠ note
  ░░░ = cripple over hus-dør header (Y=1778..1823, h=155)
```

### Skæreliste — V4

| # | Element                       | Sektion | Længde (mm) | Antal | Position                                              |
| - | ----------------------------- | ------- | ----------- | ----- | ----------------------------------------------------- |
| 1 | DPC murpap                    | 100×2   | 2800        | 1     | X=1900..2000, Y=100..2900                             |
| 2 | Bundrem PT                    | 95×45   | 2810        | 1     | X=1905..2000, Y=95..2905, z=122..167                  |
| 3 | Toprem (gran, = hus-dør header)| 95×45  | 2810        | 1     | X=1905..2000, Y=95..2905, z=2167..2212 — spænder hus-dør som header |
| 4 | Stud — grid                   | 45×95   | 2000        | 3     | Y=95, 695, 2860                                       |
| 5 | Stud — hus-dør jamb           | 45×95   | 2000        | 2     | Y=1255 og Y=2370                                      |
| 6 | Stud — pet-dør jamb           | 45×95   | 2000        | 2     | Y=2655 og Y=2950                                      |
| 7 | Pet-dør header                | 95×45   | 250         | 1     | Y=2700..2950, z=527..572                              |

**V4 i alt:** 7 full-height studs + 1 pet-dør header (hus-dør-header = toprem, ingen cripple over hus-dør).  
**Løbende meter 45×95:** 7·2,0 + 0,25 ≈ **14,3 m**.

> ⚠ **End-emit stud (Y=2860)**: koden emitterer en grid-stud ved
> Y=2860..2905 (= `end_stud_x` i `_studs_one_wall`) som skip-range-tjekket
> ikke fanger. Den falder fysisk inde i pet-dørens åbning (Y=2700..2950).
> Hvis du bygger 1:1, kan studen udelades — pet-døren er kun 250 mm bred og
> har sine egne jamber ved Y=2655 og Y=2950.

---

## Junction-studs (V4/V1 og V4/V2 hjørner)

Junction-studene fylder hjørnerne ved (X=1955..2000, Y=0..95) og
(X=1955..2000, Y=2905..3000). De er allerede medregnet i V1 og V2's
skærelister (#5 i hver) — listes her kun for klarhed.

| Element                  | Sektion | Længde (mm) | Antal | Hører til    |
| ------------------------ | ------- | ----------- | ----- | ------------ |
| Stud — junction V1/V4    | 45×95   | 2000        | 1     | V1's række 5 |
| Stud — junction V2/V4    | 45×95   | 2000        | 1     | V2's række 5 |

V4's studs ved Y=95 og Y=2860 (grid) ligger lige inde for junction-studene —
de slås sammen med L-vinkelbeslag eller skruer gennem hjørnet for at låse
V4 mod V1 og V2.

---

## Samlet skæreliste — Hus

| Element                             | Sektion | Længde (mm) | Antal | Total løbende meter |
| ----------------------------------- | ------- | ----------- | ----- | ------------------- |
| DPC murpap (V1+V2 perimeter)        | 100×2   | 2000        | 2     | 4,0 m               |
| DPC murpap (V3 + V4 cross)          | 100×2   | 2800        | 2     | 5,6 m               |
| Bundrem PT (V1+V2)                  | 95×45   | 2000        | 2     | 4,0 m               |
| Bundrem PT (V3 + V4)                | 95×45   | 2810        | 2     | 5,62 m              |
| Toprem gran (V1+V2)                 | 95×45   | 2000        | 2     | 4,0 m               |
| Toprem gran (V3 + V4)               | 95×45   | 2810        | 2     | 5,62 m              |
| Full-height stud (V1 6 + V2 5 + V3 6 + V4 7) | 45×95 | 2000    | 24    | 48,0 m              |
| Cripple — vindue under sål          | 45×95   | 955         | 2     | 1,91 m              |
| Cripple — vindue over header        | 45×95   | 505         | 2     | 1,01 m              |
| V4 pet-dør header                   | 95×45   | 250         | 1     | 0,25 m              |
| V1 vindue-header                    | 95×45   | 415         | 2     | 0,83 m              |
| V1 vindue-sål                       | 95×45   | 415         | 2     | 0,83 m              |
| Cripple — V3 vindue under sål       | 45×95   | 1055        | 1     | 1,055 m             |
| Cripple — V3 vindue over header     | 45×95   | 255         | 1     | 0,255 m             |
| V3 vindue-header                    | 95×45   | 700         | 1     | 0,7 m               |
| V3 vindue-sål                       | 95×45   | 700         | 1     | 0,7 m               |

**Total løbende meter 45×95 gran C24:** 48,0 + 5,41 = **53,4 m** (studs + headers + cripples + sål; dørene bruger toprem som header).  
**Total løbende meter 95×45 PT NTR-AB:** 4,0 + 5,62 = **9,62 m** (bundrem).  
**Total løbende meter 95×45 gran:** 4,0 + 5,62 = **9,62 m** (toprem).  
**Total DPC bånd 100 mm:** **9,6 m**.

### Hus-segment materialeliste (samlet 45×95)

| Vare                                | Antal | Brug                                                                |
| ----------------------------------- | ----- | ------------------------------------------------------------------- |
| Reglar 45 × 95 × 2400 mm gran C24   | 25    | 24 studs à 2000 mm + headers/cripples/sål (~5,4 m, inkl. V3-vindue) |
| Reglar 45 × 95 × 3000 mm gran C24   | 4     | 2 stk topremme V3 + V4 (2810 mm) + 2 stk topremme V1 + V2 (2000 mm) |
| Reglar 45 × 95 × 3000 mm PT NTR-AB  | 4     | 2 stk bundremme V3 + V4 (2810 mm) + 2 stk bundremme V1 + V2 (2000 mm) |
| Bitumen-tape 100 mm × 10 m rulle    | 1     | Murpap — én rulle dækker hele hus + V4-cross (9,6 m)               |
| Ankerskruer M10 × 120               | 10    | Bundrem-til-sokkel c/c 1000 mm (2 V1 + 2 V2 + 3 V3 + 3 V4)         |
| Vinkelbeslag 90×90 + skruer         | 16    | 4 hjørner × 4 stk (2 oppe + 2 nede V3-corner, V4/V1 + V4/V2)        |
| Vinkelbeslag jamb-til-toprem        | 16    | 8 jamber (V1 dør+vindue, V4 dør, V3 vindue) × 2 (top + bund)       |

Headers og sål skæres af spild fra 2400 mm-stokken (~200 mm spild pr. stud × 24 = 4,8 m).

---

## Bygge-rækkefølge

1. **DPC** — læg bitumen-tape 100 mm bred ovenpå hele sokkel-ringen
   (perimeter + V4-cross). Lap 100 mm ved samlinger.

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
     hjørne/jamb-studs og vindue-jamberne. Døren går helt op til
     topremmen — ingen separat dør-header (toprem = header).
   - Sæt outer-cripples under sål (955 mm) og over header (505 mm) lige
     ved hjørne/junction-studens side af vindues-åbningen.
   - Læg topremmen ovenpå (spænder også dør-åbningen som header).

5. **V2 (bag)** — rejs alle 5 studs c/c 600 mm + junction-stud. Læg toprem.

6. **V4 (partition)**:
   - Sæt grid-studs Y=95 og Y=695.
   - Sæt hus-dør jamber Y=1255 og Y=2370 — hus-døren går op til
     topremmen, som fungerer som header (ingen separat header/cripple).
   - Sæt pet-dør jamber Y=2655 og Y=2950 + headerstykket (250 mm) ved
     z=527 (60 mm over gulv-top + 300 mm dyrebredde).
   - Udelad end-emit-studen Y=2860 (den falder inde i pet-dør-åbningen).
   - Læg topremmen ovenpå.

7. **Vinkelbeslag** — fastgør V3 mod V1+V2-hjørner og V4 mod V1+V2-hjørner
   med 90×90 vinkelbeslag (2 stk pr. hjørne, top og bund).

---

## Verifikation i OpenSCAD

`src/main.scad` rendrer hele skelettet når `RenderHouseFraming()` er enabled
(under `// house`-sektionen). Tjek inden materialebestilling:

- Toprem skal være flat på alle 4 hus-vægge (gable-spær oven på)
- Stud-længde 2000 mm ens på V1, V2, V3, V4
- V3 har 1 cutout (side-vindue Y=1150..1850, sål-top z=1267)
- V4 har 2 cutouts (hus-dør Y=1500..2370 + pet-dør Y=2700..2950)
- V1 har 3 cutouts (dør X=550..1450 + 2 vinduer på hver side)
- Junction-studs synlige som "dobbelt-stud" ved V4/V1- og V4/V2-hjørner
- Vindue-jamb og dør-jamb på V1 står som to adskilte reglar (≈90 mm
  samlet bredde) mod hinanden ved dør-vindue-overgangen
