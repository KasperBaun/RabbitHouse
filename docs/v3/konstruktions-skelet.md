# Konstruktions-skelet

> Implementeret i `src/designs/v3/konstruktions-skelet.scad`.

Træ-skelettet der sidder OVENPÅ fundamentet — alt det struktur-træ der binder bygningen sammen. Aktuelt indeholder filen bundrem + murpap (DPC) som ligger på sokkel-toppen. Over tid flytter vi resten herover (stolper, toprem, losholter, vindkryds, bjælker) så `konstruktions-skelet.md` bliver det samlede billede af bygningens træ-skelet.

## Mål (aktuelt indhold)

| Egenskab | Værdi |
|---|---|
| Bundrem-niveau (top) | 16,7 cm over jord (sokkel + 2 mm murpap + 4,5 cm bundrem) |
| Bundrem omkreds | ~17 m perimeter + 2,35 m partition cross-wall = ~19,35 m |
| Murpap | 100 mm bred bitumen-tape under hele bundrem-strækningen |

## Konstruktion

**Murpap (fugtspærre).** 2 mm bitumen-tape, 100 mm bred, lægges ovenpå sokkel-toppen i hele bundrem-tracéet (perimeter + partition cross-wall). Holder fugt fra betonen ude af træet. Skåret 5 mm over på hver side for at vand løber af i stedet for op i træ-fibre.

**Bundrem.** Kontinuert 45 × 95 PT-bundrem (NTR-AB klasse for udendørs jord-kontakt) skrue-fastgjort til topskiftet i sokkelringen via M10 ankerskruerne (selve ankerskruerne er listet under `fundament.md`). Bundremmen går hele vejen rundt — også under yard-mesh og over yard-dør (door-tærskel) samt på tværs af partition. Standard 4,8 m planker samles ende-til-ende med 30 mm overlap; samlinger ligger ALDRIG på et hjørne.

## Materialeliste

| # | Vare | Beskrivelse | Antal | Enhed | Pris/enh | I alt |
|---|---|---|---|---|---|---|
| 1 | Bundrem 45 × 95 PT (NTR-AB) | Kontinuert ~19,5 m | 5 | stk à 4,8 m | | |
| 2 | Murpap (bitumen-tape 100 mm) | DPC mellem sokkel og bundrem | 1 | rulle 25 m | | |
| | | | | | **Total** | **kr.** |

## Bygge-rækkefølge

1. Sørg for fundamentets ankerskruer er på plads i topskiftet (se `fundament.md`)
2. Læg murpap-tape ovenpå sokkel hele vejen rundt + på cross-wall
3. Bor 11 mm gennemføringshuller i bundrem-plankerne der matcher ankerskruerne
4. Læg bundremmen på murpappet, spænd møtrikkerne, kontroller niveau

## Kommer senere (når vi flytter stolper/toprem/etc. herover)

- 45 × 95 stolper c/c 600 (i dag i `vaegge.scad`)
- Toprem (skrå mod tag-hældning)
- Losholter (45 × 95 vandret midt på væggen)
- Vindkryds 22 × 95 (X-bracing)
- Yard top-bjælker (95 × 180 limtræ) og collar tie
- Spær og lægter (i dag i `tagkonstruktion.scad` — overvej om de hører hjemme her)

## Hvad er IKKE i denne fil

- Beton, ringen, ankerskruer → `fundament.md`
- Klink-beklædning + vindpapir + afstandsliste → `beklaedning.md`
- Døre, vindue → `aabninger.md`
- Tag-dækning og lægter → `tagkonstruktion.md`
- Inventar → `inventar.md`
