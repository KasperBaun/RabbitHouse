# Konstruktions-skelet

> Implementeret i `src/designs/v3/konstruktions-skelet.scad`.

Træ-skelettet der sidder ovenpå fundamentet. Indeholder kun de fire grundlæggende elementer: DPC (murpap), sill plate (bundrem), studs (reglar — inkl. jamb-reglar ved hver åbning), top plate (toprem). Trekant-gavlfyld over sidemæg, losholter, vindkryds, taghane, bjælker, gulvstrøer m.m. kommer i andre filer eller senere iterationer.

## Vægge — ID oversigt

Vægge har faste ID'er så vi nemt kan referere til dem i samtaler.

| ID | Navn | Position | Højde | Åbninger |
|---|---|---|---|---|
| **V1** | Front-væg | Y=0..95 (kontinuert X=0..6000) | HØJ (2,2 m / z_top=2,32 m) | Yard-dør (X=3000..3850) |
| **V2** | Bag-væg | Y=2405..2500 (kontinuert X=0..6000) | LAV (2,0 m / z_top=2,12 m) | — |
| **V3** | Venstre side-væg | X=0..95 (Y=95..2405) | LAV | Side-vindue (Y=900..1600) |
| **V4** | Højre side-væg | X=5905..6000 (Y=95..2405) | LAV | — |
| **V5** | Partition (cross-wall) | X=1452,5..1547,5 (Y=95..2405) | LAV | Human-dør (Y=200..1050) + Pet-dør (Y=1500..1750) |

V1 og V2 løber kontinuert hele bygningens længde. V3, V4, V5 BUTTER mod V1/V2's inderfladen — de overlapper IKKE i den fysiske verden.

## Mål

| Egenskab | Værdi |
|---|---|
| V1 front-væg højde (fra sokkel-top) | 2,2 m (HØJ — den høje side i mono-pitch) |
| V2 bag-væg højde | 2,0 m (LAV) |
| V3, V4, V5 sidemæg + partition højde | 2,0 m (LAV — flugter med V2) |
| Top af V1 top plate | z = 2,32 m over jord |
| Top af V2/V3/V4/V5 top plate | z = 2,12 m over jord |
| Tag-hældning (drop 200 over 2500) | 4,6° (8 % fald) — OK for tagpap, ikke nok for stål/eternit |
| Stud-spacing | 600 mm c/c |

## Konstruktion

```
1. DPC (murpap)         2 mm bitumen-tape oven på sokkel-ring
                         V1+V2 kontinuert; V3, V4, V5 butted ved Y=100/2400
2. Sill plate (bundrem) 45×95 PT, samme butting-mønster som DPC
3. Studs (reglar)       45×95 lodrette c/c 600, alle 5 vægge
                         skip-ranges holder åbninger fri
                         + jamb-reglar ved hver åbnings kanter
                         + junction-reglar i V1+V2 hvor V5 (partition) møder dem
4. Header + cripples    45×95 over hver åbning + cripples op til toprem
   + (vindue) rough sill og cripples ned til bundrem
5. Top plate (toprem)   45×95 vandret oven på studs
                         V1: HØJ (z=2320) — flugter med tagets underside
                         V2, V3, V4, V5: LAV (z=2120)
```

Trekanten mellem den vandrette top plate på sidemæg og det skrå tag (over front-end) er **ikke** modelleret her — det er gavlfyld der kommer senere.

## Modul-struktur

| Modul | Funktion |
|---|---|
| `v3_dpc()` | Bitumen-tape — V1+V2 kontinuert, V3/V4/V5 butted |
| `v3_sill_plate(palette)` | 45×95 PT bundrem — samme butting-mønster |
| `v3_studs(palette)` | Stud-grid på alle 5 vægge: grid c/c 600 + 8 jamb-reglar + 2 junction-reglar (V1+V2 møde med V5) |
| `v3_framed_openings(palette)` | Header + cripples over hver åbning + rough sill + cripples under V3-vinduet |
| `v3_top_plate(palette)` | Vandret toprem — V1 HØJ, V2/V3/V4/V5 LAV |
| `v3_konstruktions_skelet(palette)` | Wrapper — kalder alle ovenstående |

## Materialeliste

Hvad du **køber** hos byggemarkedet (Bauhaus, Stark, XL-BYG). Priser tilføjes senere.

| # | Vare | Antal | Specifikation | Note |
|---|---|---|---|---|
| 1 | Reglar 45 × 95 × 2400 mm | 37 stk | Gran C24 | Til alle studs (1 stud pr. stik, skæres til 2308 eller 2108 mm) |
| 2 | Reglar 45 × 95 × 4800 mm | 5 stk | Trykimprægneret NTR-AB | Til bundrem (~19,5 m hele vejen rundt + partition) |
| 3 | Reglar 45 × 95 × 4800 mm | 5 stk | Gran C24 | Til toprem (~19,5 m) |
| 4 | Bitumen-tape (murpap) 100 mm bred | 1 rulle | 25 m rulle | DPC mellem sokkel og bundrem |

Total stik-antal: **47 reglar** (37 á 2,4 m gran + 5 á 4,8 m PT + 5 á 4,8 m gran) + **1 rulle murpap**.

**Hvorfor blandet længde?** 2,4 m er det mest typiske at købe og passer perfekt til én stud (uden at skulle splejse). Bundrem og toprem løber over 6 m langs front+bag, så 4,8 m sticks gør det muligt at lave front/bag i to stik (én lang + et 1200 mm endestykke) i stedet for 3 stik á 2,4 m. Færre samlinger = stærkere væg.

## Skæreliste

Hvad du **skærer** ud af det du har købt.

### Reglar 45×95×2400 mm (37 stk)

| Cut længde | Antal | Hvor | Spild pr. stik |
|---|---|---|---|
| 2308 mm | 11 stk | V1 (7 grid + 1 end + 2 jambs ved yard-dør + 1 junction til V5) | 92 mm |
| 2108 mm | 26 stk | V2 (12: 10 grid + 1 end + 1 junction) + V3 (4: 1 grid + 1 end + 2 jambs til vindue) + V4 (5: 4 grid + 1 end) + V5 (5: 0 grid + 1 end + 4 jambs) | 292 mm |

Total spild: ~16 m off-cuts (kan bruges som klodser, mellemstykker, evt. losholter når de kommer). 1 stud pr. stik — enkel skæring.

V2's tælling (12) inkluderer 1 junction-reglar ved V5-mødet (X=1500). V3/V4/V5 har stadig en separat end-stud (efter butting blev wall-length 2310 — gap til sidste grid er stor nok til separat end-stud).

**Bemærk:** Header, cripples og rough sill er IKKE talt med i 31-tallet ovenfor. De cuttes fra spild-off-cuts (~16 m off-cuts er nok til de 4 headers + ~8 cripples + 1 rough sill, da hver er 250-850 mm lang).

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
- Gavlfyld (trekant over V3 og V4 op til skrå tag) → kommer senere
- Beslag (vinkelbeslag, søm, skruer) → kommer i egen "fasteners"-fil
- Losholter, vindkryds, taghane, yard-bjælker → kommer senere
- Strøer-gulv (floor joists inde i huset) → kommer senere
- Klink, vindpapir, voliernet → `beklaedning.md` (todo.md #4)
- Selve dør-blade og vinduesrammer (kun struktur-frame her) → `aabninger.md` (todo.md #3)
- Tag, spær, dækning → `tagkonstruktion.md` (todo.md #5)
