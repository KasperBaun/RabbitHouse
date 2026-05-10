# Konstruktions-skelet

> Implementeret i `src/designs/v3/konstruktions-skelet.scad`.

Træ-skelettet der sidder ovenpå fundamentet. Indeholder kun de fire grundlæggende elementer: DPC (murpap), sill plate (bundrem), studs (reglar), top plate (toprem). Trekant-gavlfyld over sidemæg, losholter, vindkryds, taghane, bjælker, gulvstrøer m.m. kommer i andre filer eller senere iterationer.

## Mål

| Egenskab | Værdi |
|---|---|
| Front-væg højde (fra sokkel-top) | 2,5 m (HØJ — den høje side i mono-pitch) |
| Bag-væg højde | 2,0 m (LAV) |
| Sidemæg + partition højde | 2,0 m (LAV — flugter med bag-væg) |
| Top af front top plate | z = 2,62 m over jord |
| Top af bag/side/partition top plate | z = 2,12 m over jord |
| Stud-spacing | 600 mm c/c |

## Konstruktion

```
1. DPC (murpap)         2 mm bitumen-tape oven på sokkel-ring
2. Sill plate (bundrem) 45×95 PT, kontinuert hele perimeteren + cross-wall
3. Studs (reglar)       45×95 lodrette c/c 600, alle vægge
                         skip-ranges: dør- og vindues-åbninger holdes fri
4. Top plate (toprem)   45×95 vandret oven på studs
                         Front: HØJ (z=2620) — flugter med tagets underside
                         Bag/side/partition: LAV (z=2120) — flugter med bagsiden
```

Trekanten mellem den vandrette top plate på sidemæg og det skrå tag (over front-end) er **ikke** modelleret her — det er gavlfyld der kommer senere.

## Modul-struktur

| Modul | Funktion |
|---|---|
| `v3_dpc()` | Bitumen-tape oven på sokkel-ring, hele vejen rundt + cross-wall |
| `v3_sill_plate(palette)` | 45×95 PT bundrem, kontinuert |
| `v3_studs(palette)` | Stud-grid på alle 5 vægge med skip_ranges fra config |
| `v3_top_plate(palette)` | Vandret toprem, front HØJ, andre LAV |
| `v3_konstruktions_skelet(palette)` | Wrapper — kalder de 4 ovenstående |

## Materialeliste

Priser tilføjes senere.

| # | Vare | Beskrivelse | Antal | Enhed | Pris/enh | I alt |
|---|---|---|---|---|---|---|
| 1 | Bitumen-tape (murpap) 100 mm | DPC mellem sokkel og bundrem, ~19,5 m + cross-wall 2,35 m | 1 | rulle 25 m | | |
| 2 | Bundrem 45 × 95 PT NTR-AB | Kontinuert ~21,9 m | 5 | stk à 4,8 m | | |
| 3 | Reglar 45 × 95 (gran C24) | Stud, ca. 35 stk samlet (front 9 + bag 9 + venstre 4 + højre 4 + partition 4 + ende-studs) | 35 | stk à varierende længde | | |
| 4 | Toprem 45 × 95 (gran C24) | Vandret toprem, ~21,9 m total | 5 | stk à 4,8 m | | |
| | | | | | **Total** | **kr.** |

Reglar-længder afhænger af vægposition:
- Front-væg studs: 2,41 m hver
- Bag-, side- og partition-væg studs: 1,91 m hver

## Hvad er IKKE i denne fil

- Sokkel og ankerskruer → `fundament.md`
- Gavlfyld (trekant over sidemæg) → kommer senere (eget modul eller del af tagkonstruktion)
- Losholter, vindkryds, taghane, yard-bjælker → kommer senere
- Strøer-gulv (floor joists inde i huset) → kommer senere (egen fil eller del af nyt gulv-system)
- Klink, vindpapir, voliernet → `beklaedning.md` (todo.md #4)
- Døre, vinduer, jamb/header/cripple-indramning → `aabninger.md` (todo.md #3)
- Tag, spær, dækning → `tagkonstruktion.md` (todo.md #5)
