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

## V1 — Front (kun hoveddør)

**Position:** Y=0..95, X=0..2000 (2000 mm lang).
**Åbning:** hoveddør — lysning **968 × 2047** mm, X=516..1484, z=120..2167.
Indkøbt dør med udvendige karmmål **948 × 2050**, monteret med 10 mm
montagefuge i hver side.

**Ingen vinduer i facaden.** Det eneste glas/lys i gavlen er den
rombeformede udskæring i selve dørbladet (240 × 280 mm hul med ~45 mm
foring, center 1530 mm over karmbunden) — den står åben som bygget.

To ting adskiller V1 fra de øvrige vægge:

- **Bundremmen er skåret væk under døren.** Karmen står direkte på
  sokkel-/gulvniveau (z=120), ikke oven på bundremmen. Derfor er V1's
  bundrem to stykker à 516 mm i stedet for ét på 2000.
- **Topremmen er dør-overligger.** Lysningen når op til toprem-underkanten
  (z=2167), så der er hverken separat header eller cripples over døren.

Karmen er 2050 høj mod en lysning på 2047 — de 3 mm høvles af topremmens
underside ved montage (eller opmål den byggede væg).

### Elevation (set udefra)

```
z=2212 ────────────────────── tag-spær hviler ovenpå ──────────────────────
       ┌───────────────────────────────────────────────────────────────────┐
z=2167 │        TOPREM 45×95 — 2000 mm   (spænder døren som overligger)     │
       ├──┬──────────┬────┬──────────────────────────┬────┬─────┬────┬─────┤
       │  │          │    │                          │    │     │    │     │
       │K │          │ DJ │      D Ø R  lysning      │ DJ │  S  │    │  J  │
       │  │          │    │        968 × 2047        │    │     │    │     │
       │  │          │    │     (karm 948 × 2050)    │    │     │    │     │
z=167  ╞══╧══════════╧════╡                          ╞════╧═════╧════╧═════╡
       │ BUNDREM 95×45     │   bundrem udskåret       │  BUNDREM 95×45      │
z=122  │      516 mm       │                          │      516 mm         │
z=120  └───────────────────┴──────────────────────────┴─────────────────────┘
        X=0 45          471 516                    1484 1529 1800 1845 1955 2000

  K  = hjørnestud (X=0..45, full-h)          J = junction-stud (X=1955..2000)
  DJ = dør-jamb (full-h, X=471..516 og X=1484..1529)
  S  = grid-stud (X=1800..1845)
  Ingen header, sål eller cripples på V1.
```

### Skæreliste — V1

| # | Element                     | Sektion | Længde (mm) | Antal | Position                                                 |
| - | --------------------------- | ------- | ----------- | ----- | -------------------------------------------------------- |
| 1 | DPC murpap                  | 100×2   | 2000        | 1     | Y=0..100, z=120 (gennemgående, også under dørtærsklen)   |
| 2 | Bundrem PT                  | 95×45   | 516         | 2     | X=0..516 og X=1484..2000, z=122..167                     |
| 3 | Toprem (gran, = overligger) | 95×45   | 2000        | 1     | Y=0..95, z=2167..2212 — spænder dør-åbningen             |
| 4 | Stud — hjørne (mod V3)      | 45×95   | 2000        | 1     | X=0..45                                                  |
| 5 | Stud — dør-jamb             | 45×95   | 2000        | 2     | X=471..516 og X=1484..1529                               |
| 6 | Stud — grid                 | 45×95   | 2000        | 1     | X=1800..1845                                             |
| 7 | Stud — junction (mod V4)    | 45×95   | 2000        | 1     | X=1955..2000                                             |

**V1 i alt:** 5 full-height studs (2000). Ingen cripples, headers eller såle.
**Løbende meter 45×95 i V1:** 5·2,0 = **10,0 m** (ekskl. DPC og bundrem-PT).

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
**Åbning:** sidevindue — lysning **860 × 1000** mm, centreret
(Y=1070..1930), sål-top z=1122, header-bund z=2122.

V3 er husets frie langside; løbegården ligger mod V4. Vinduet er to-rammet
(to lige høje rammer over hinanden, hvid karm) og sidder højt: sålen ligger
1000 mm over sokkeltop, og headerens overside flugter toprem-underkanten
(z=2167) — derfor er der **ingen cripple over vinduet**, kun én under sålen.

Grid-studsene ved Y=1295 og 1895 udgår i åbningen og erstattes af 2
dedikerede vindue-jambs. 6 full-height studs i alt (4 grid + 2 jamb).

> **Mål skaleret af byggefoto, ikke opmålt.** Lysningen er aflæst på
> klink-skifterne (100 mm pr. skifte) på det byggede hus. Ret målene her og
> i `RH_SIDE_WIN_*` når vinduets karmmål og præcise placering er opmålt.

### Elevation (set udefra, –X mod kameraet)

```
z=2212 ─────────────────── tag-spær hviler ovenpå ───────────────────
       ┌────────────────────────────────────────────────────────────┐
z=2167 │              TOPREM 45×95 — 2810 mm                          │
       ├──┬──────┬─────┬───────────┬─────┬──────┬──────┬─────────────┤
z=2122 │  │      │     ├═══════════┤     │      │      │             │  ← header (flugter toprem)
       │  │      │ WJ  │           │ WJ  │      │      │             │
       │  │      │     │  VINDUE   │     │      │      │             │
       │ S│  S   │     │  860×1000 │     │  S   │  S   │  E          │
z=1122 │  │      │     ├═══════════┤     │      │      │             │  ← vindue-sål
z=1077 │  │      │     │░ crip     │     │      │      │             │  } under sål
       │  │      │     │░ 910      │     │      │      │             │
z=212  ╞══╧══════╧═════╧═══════════╧═════╧══════╧══════╧═════════════╡
       │                 BUNDREM 95×45 — 2810 mm                      │
z=167  ├────────────────────────────────────────────────────────────┤
z=122  │░░░░░░░░░░░░░░░░ DPC 100×2 — 2800 mm ░░░░░░░░░░░░░░░░░░░░░░░░│
z=120  └────────────────────────────────────────────────────────────┘
       Y=95  695  1025 1070      1930 1975 2495   2860

  S  = grid-stud c/c 600 (full-h, Y=95/695/2495)   E = end-emit (Y=2860)
  WJ = vindue-jamb (full-h, Y=1025..1070 og Y=1930..1975)
  ░░░ = cripple under sål, 910 mm (Y=1347,5..1392,5)
  ═══ = sål / header (45 mm 95×45 på fladsiden)
```

### Skæreliste — V3

| # | Element                    | Sektion | Længde (mm) | Antal | Position                               |
| - | -------------------------- | ------- | ----------- | ----- | -------------------------------------- |
| 1 | DPC murpap                 | 100×2   | 2800        | 1     | X=0..100, Y=100..2900                  |
| 2 | Bundrem PT                 | 95×45   | 2810        | 1     | X=0..95, Y=95..2905                    |
| 3 | Toprem (gran)              | 95×45   | 2810        | 1     | X=0..95, Y=95..2905, z=2167..2212      |
| 4 | Stud — grid                | 45×95   | 2000        | 4     | Y=95, 695, 2495, 2860                  |
| 5 | Stud — vindue-jamb         | 45×95   | 2000        | 2     | Y=1025..1070 og Y=1930..1975           |
| 6 | Cripple — vindue under sål | 45×95   | 910         | 1     | Y=1347,5..1392,5, z=167..1077          |
| 7 | Vindue-header              | 95×45   | 860         | 1     | Y=1070..1930, z=2122..2167             |
| 8 | Vindue-sål (rough)         | 95×45   | 860         | 1     | Y=1070..1930, z=1077..1122             |

**V3 i alt:** 6 full-height studs (4 grid + 2 vindue-jamb) + 1 cripple + header/sål.
**Løbende meter 45×95 i V3:** 6·2,0 + 0,91 + 2·0,86 ≈ **14,6 m** (ekskl. DPC og bundrem-PT).

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
| Bundrem PT (V1 2×516 + V2 2000)     | 95×45   | 2000/516    | 3     | 3,03 m              |
| Bundrem PT (V3 + V4)                | 95×45   | 2810        | 2     | 5,62 m              |
| Toprem gran (V1+V2)                 | 95×45   | 2000        | 2     | 4,0 m               |
| Toprem gran (V3 + V4)               | 95×45   | 2810        | 2     | 5,62 m              |
| Full-height stud (V1 5 + V2 5 + V3 6 + V4 7) | 45×95 | 2000    | 23    | 46,0 m              |
| V4 pet-dør header                   | 95×45   | 250         | 1     | 0,25 m              |
| Cripple — V3 vindue under sål       | 45×95   | 910         | 1     | 0,91 m              |
| V3 vindue-header                    | 95×45   | 860         | 1     | 0,86 m              |
| V3 vindue-sål                       | 95×45   | 860         | 1     | 0,86 m              |

V1 har hverken header, sål eller cripples: hoveddøren går fra sokkeltop til
toprem-underkant, så topremmen er overligger. V3-vinduets header flugter
ligeledes topremmen, så der kun er én cripple (under sålen) i hele huset.

**Total løbende meter 45×95 gran C24:** 46,0 + 2,88 = **48,9 m** (studs + header + cripple + sål; dørene bruger toprem som header).  
**Total løbende meter 95×45 PT NTR-AB:** 4,0 + 5,62 = **9,62 m** (bundrem).  
**Total løbende meter 95×45 gran:** 4,0 + 5,62 = **9,62 m** (toprem).  
**Total DPC bånd 100 mm:** **9,6 m**.

### Hus-segment materialeliste (samlet 45×95)

| Vare                                | Antal | Brug                                                                |
| ----------------------------------- | ----- | ------------------------------------------------------------------- |
| Reglar 45 × 95 × 2400 mm gran C24   | 24    | 23 studs à 2000 mm + header/cripple/sål (~2,9 m, V3-vindue + pet-dør) |
| Reglar 45 × 95 × 3000 mm gran C24   | 4     | 2 stk topremme V3 + V4 (2810 mm) + 2 stk topremme V1 + V2 (2000 mm) |
| Reglar 45 × 95 × 3000 mm PT NTR-AB  | 4     | 2 stk bundremme V3 + V4 (2810 mm) + 2 stk bundremme V1 + V2 (2000 mm) |
| Bitumen-tape 100 mm × 10 m rulle    | 1     | Murpap — én rulle dækker hele hus + V4-cross (9,6 m)               |
| Ankerskruer M10 × 120               | 10    | Bundrem-til-sokkel c/c 1000 mm (2 V1 + 2 V2 + 3 V3 + 3 V4)         |
| Vinkelbeslag 90×90 + skruer         | 16    | 4 hjørner × 4 stk (2 oppe + 2 nede V3-corner, V4/V1 + V4/V2)        |
| Vinkelbeslag jamb-til-toprem        | 12    | 6 jamber (V1 dør, V4 dør, V3 vindue) × 2 (top + bund)              |

Header, sål og cripple skæres af spild fra 2400 mm-stokken (~400 mm spild pr. stud × 23 = 9,2 m).

---

## Bygge-rækkefølge

1. **DPC** — læg bitumen-tape 100 mm bred ovenpå hele sokkel-ringen
   (perimeter + V4-cross). Lap 100 mm ved samlinger.

2. **Bundrem** — bor gennemgangshuller for M10 ankerskruer (c/c 1000 mm)
   i de fire bundrem-stykker. Læg på plads og spænd møtrikkerne.

3. **V3 (venstre)** først — rejs alle 6 studs c/c 600 mm (4 grid + 2
   vindue-jamb). Sæt vindue-sål (860 mm) ved z=1077..1122 med cripplen
   (910 mm) under, og vindue-headeren (860 mm) ved z=2122..2167 — den
   flugter toprem-underkanten, så der er ingen cripple over. Læg topremmen
   ovenpå og fastgør med 2 skruer pr. stud.

4. **V1 (front)**:
   - Læg bundremmen som **to stykker à 516 mm** (X=0..516 og X=1484..2000) —
     udsparingen imellem er dør-åbningen, hvor karmen står på sokkel/gulv.
   - Stil hjørnestuden (X=0..45) op mod V3's første stud — vinkelbeslag.
   - Stil junction-studen (X=1955..2000) og grid-studen (X=1800..1845).
   - Sæt dør-jamberne (X=471..516 og X=1484..1529). De står på bundremmens
     ender, ikke i udsparingen.
   - Ingen header, sål eller cripples: læg topremmen ovenpå, den spænder
     dør-åbningen som overligger.

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
- V3 har 1 cutout (side-vindue Y=1070..1930, sål-top z=1122)
- V4 har 2 cutouts (hus-dør Y=1500..2370 + pet-dør Y=2700..2950)
- V1 har 1 cutout (dør X=516..1484, z=120..2167) — ingen vinduer
- Junction-studs synlige som "dobbelt-stud" ved V4/V1- og V4/V2-hjørner
- V1's bundrem er delt i to stykker med udsparing under døren
