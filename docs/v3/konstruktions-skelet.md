# Konstruktions-skelet

> Implementeret i `src/designs/v3/konstruktions-skelet.scad`.

Træ-skelettet der sidder ovenpå fundamentet. Indeholder kun de fire grundlæggende elementer: DPC (murpap), sill plate (bundrem), studs (reglar — inkl. jamb-reglar ved hver åbning), top plate (toprem). Trekant-gavlfyld over sidemæg, losholter, vindkryds, taghane, bjælker, gulvstrøer m.m. kommer i andre filer eller senere iterationer.

## Mål

| Egenskab | Værdi |
|---|---|
| Front-væg højde (fra sokkel-top) | 2,2 m (HØJ — den høje side i mono-pitch) |
| Bag-væg højde | 2,0 m (LAV) |
| Sidemæg + partition højde | 2,0 m (LAV — flugter med bag-væg) |
| Top af front top plate | z = 2,32 m over jord |
| Top af bag/side/partition top plate | z = 2,12 m over jord |
| Tag-hældning (drop 200 over 2500) | 4,6° (8 % fald) — OK for tagpap, ikke nok for stål/eternit |
| Stud-spacing | 600 mm c/c |

## Konstruktion

```
1. DPC (murpap)         2 mm bitumen-tape oven på sokkel-ring
2. Sill plate (bundrem) 45×95 PT, kontinuert hele perimeteren + cross-wall
3. Studs (reglar)       45×95 lodrette c/c 600, alle vægge
                         skip-ranges: dør- og vindues-åbninger holdes fri
                         + jamb-reglar ved hver åbnings kanter
4. Top plate (toprem)   45×95 vandret oven på studs
                         Front: HØJ (z=2320) — flugter med tagets underside
                         Bag/side/partition: LAV (z=2120) — flugter med bagsiden
```

Trekanten mellem den vandrette top plate på sidemæg og det skrå tag (over front-end) er **ikke** modelleret her — det er gavlfyld der kommer senere.

## Modul-struktur

| Modul | Funktion |
|---|---|
| `v3_dpc()` | Bitumen-tape oven på sokkel-ring, hele vejen rundt + cross-wall |
| `v3_sill_plate(palette)` | 45×95 PT bundrem, kontinuert |
| `v3_studs(palette)` | Stud-grid på alle 5 vægge med skip_ranges + 8 jamb-reglar |
| `v3_top_plate(palette)` | Vandret toprem, front HØJ, andre LAV |
| `v3_konstruktions_skelet(palette)` | Wrapper — kalder de 4 ovenstående |

## Materialeliste

Hvad du **køber** hos byggemarkedet (Bauhaus, Stark, XL-BYG). Priser tilføjes senere.

| # | Vare | Antal | Specifikation | Note |
|---|---|---|---|---|
| 1 | Reglar 45 × 95 × 2400 mm | 43 stk | Gran C24 | Til alle studs (1 stud pr. stik, skæres til 2108 eller 1908 mm) |
| 2 | Reglar 45 × 95 × 4800 mm | 5 stk | Trykimprægneret NTR-AB | Til bundrem (~19,5 m hele vejen rundt + partition) |
| 3 | Reglar 45 × 95 × 4800 mm | 5 stk | Gran C24 | Til toprem (~19,5 m) |
| 4 | Bitumen-tape (murpap) 100 mm bred | 1 rulle | 25 m rulle | DPC mellem sokkel og bundrem |

Total stik-antal: **53 reglar** (43 á 2,4 m gran + 5 á 4,8 m PT + 5 á 4,8 m gran) + **1 rulle murpap**.

**Hvorfor blandet længde?** 2,4 m er det mest typiske at købe og passer perfekt til én stud (uden at skulle splejse). Bundrem og toprem løber over 6 m langs front+bag, så 4,8 m sticks gør det muligt at lave front/bag i to stik (én lang + et 1200 mm endestykke) i stedet for 3 stik á 2,4 m. Færre samlinger = stærkere væg.

## Skæreliste

Hvad du **skærer** ud af det du har købt.

### Reglar 45×95×2400 mm (43 stk)

| Cut længde | Antal | Hvor | Spild pr. stik |
|---|---|---|---|
| 2108 mm | 12 stk | Front-væg studs (8 grid + 1 end + 2 jambs ved yard-dør + 1 junction ved partition) | 292 mm |
| 1908 mm | 31 stk | Bag-væg (12) + venstre (6) + højre (5) + partition (8) | 492 mm |

Total spild: ~16 m off-cuts (kan bruges som klodser, mellemstykker, evt. losholter når de kommer). 1 stud pr. stik — enkel skæring.

Bag-væg-tællingen (12) inkluderer 1 junction-reglar ved partition-mødet (X=1500). Venstre/højre/partition har ingen separat end-stud — sidste grid-reglar sidder tæt på væg-enden og corner-samlingen tager belastningen.

### Reglar 45×95×4800 mm PT — bundrem (5 stk)

Total bundrem: 19,5 m (= ~17 m perimeter + 2,5 m partition; samlinger ved hjørner).

| Stik | Cut |
|---|---|
| Stik 1 | 1× 4800 (bruges som front, samles med 1200 fra stik 3 til samlede 6000 mm front-bundrem) |
| Stik 2 | 1× 4800 (bruges som bag, samles med 1200 fra stik 4) |
| Stik 3 | 2310 (venstre væg-bundrem) + 1200 (front-samling) + 1290 spild |
| Stik 4 | 2310 (højre væg-bundrem) + 1200 (bag-samling) + 1290 spild |
| Stik 5 | 2310 (partition væg-bundrem) + 2490 spild |

(Alternativ: hvis byggemarkedet har 6,0 m PT-reglar i sortiment, kan front og bag støbes i én stykke uden samling. Spørg.)

### Reglar 45×95×4800 mm gran — toprem (5 stk)

Samme cut-mønster som bundrem (19,5 m total, 5 stik), bare gran C24 i stedet for PT. Front-væggen ligger HØJT og toprem flugter med tagunderside; de andre 4 vægge ligger LAVT.

### Murpap (1 rulle 25 m)

Skæres i strimler matchende bundrem-cut'ene: 6000 + 6000 + 3× 2310 = 18,93 m. Resterende ~6 m brugbart spild.

## Bygge-rækkefølge

1. Sørg for fundamentet er på plads incl. ankerskruer i topskiftet (se `fundament.md`)
2. Læg murpap-tape ovenpå sokkel hele vejen rundt + på cross-wall (i bundrem-tracéet)
3. Bor 11 mm gennemgangs-huller i bundrem-plankerne der matcher ankerskruerne
4. Læg bundrem på murpappet, spænd møtrikkerne, kontroller niveau med snor
5. Sæt corner-studs (de yderste reglar i hver væg) først, lodret, fastgjort med vinkelbeslag (kommer i andet modul)
6. Sæt jamb-reglar ved hver åbning
7. Sæt regular grid-studs c/c 600 mm
8. Læg toprem ovenpå alle studs — vandret (front HØJ, andre LAV)

## Hvad er IKKE i denne fil

- Sokkel og ankerskruer → `fundament.md`
- Gavlfyld (trekant over sidemæg) → kommer senere
- Header + cripples + rough sill (under vinduet) → `aabninger.md` (todo.md #3)
- Beslag (vinkelbeslag, søm, skruer) → kommer i egen "fasteners"-fil
- Losholter, vindkryds, taghane, yard-bjælker → kommer senere
- Strøer-gulv (floor joists inde i huset) → kommer senere
- Klink, vindpapir, voliernet → `beklaedning.md` (todo.md #4)
- Døre, vinduer, dør-blade → `aabninger.md` (todo.md #3)
- Tag, spær, dækning → `tagkonstruktion.md` (todo.md #5)
