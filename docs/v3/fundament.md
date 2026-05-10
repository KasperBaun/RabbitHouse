# Fundament

> Implementeret i `src/designs/v3/fundament.scad`. Mængder bygger på `docs/v3/materialeliste.csv`.

Kontinuert fundablok-strimmel under hele bygningens perimeter (6 × 2,5 m, ~17 m omkreds) plus en cross-wall under partition-væggen ved X = 1,5 m. Indenfor husdelen sidder et træ-strøer-gulv på ledger-bjælker; yard-arealet bliver græs på sokkel-niveau med dig-defence-mesh i jorden langs ydersiden.

## Mål

| Egenskab | Værdi |
|---|---|
| Footprint | 6,0 × 2,5 m |
| Sokkel-højde over jord | 12 cm (1 skifte) |
| Total ringhøjde | 60 cm (3 skifter à 20 cm) |
| Frostfri grøftdybde | ~80 cm |
| Stabilgrus i bunden | 20 cm |
| Husgulv finishhøjde | 16,5 cm over jord (sokkel + bundrem) |

## Konstruktion

**Ring + cross-wall.** Tre skifter fundablok 50 × 20 × 15 cm lagt i halvstensforbandt rundt om hele perimeteren samt på tværs ved X = 1500 mm (hus/yard-skel). Hulrum udstøbes med beton. Lodret armering Ø8 mm køres gennem hver ~1 m + alle hjørner og T-samlinger; vandret bane i øverste skifte. Topskiftet ligger flush med sokkel-niveau (z = 120 mm over jord).

**Bundrem.** Kontinuert 45 × 95 PT-bundrem (NTR-AB) skrue-fastgjort til topskiftet med M10 ankerskruer c/c 1000 mm. Bitumen-tape fugtspærre mellem beton og træ. Bundrem går hele vejen rundt — også under yard-mesh og over yard-dør (tærskel) samt på tværs af partition.

**Husgulv (X = 0..1500 mm).** Ledger-bjælke 45 × 95 PT skrue-fastgjort til ringens inderside med betonskruer 8 × 80 c/c 400. 4 stk 45 × 95 strøer (PT) hænger i strøsko c/c 600 mm og spænder mellem ledgerene. 18 mm krydsfiner gulvplade ovenpå sikret med 4 × 50 mm søm. 6 mm galv. mus-net spændt under strøer hele vejen, foldet op til ringens udvendige flade.

**Yard-areal (X = 1500..6000 mm).** Stabilgrus opfyldt indvendigt til sokkel-niveau, dækket med græs/jord. Mesh apron 500 mm bred i jorden langs ydersiden af yard på 3 sider (front, bag, højre) som dig-defence mod ræv/grævling.

## Materialeliste

Priser tilføjes senere. Forslag til leverandører: Bauhaus, Stark, XL-BYG.

| # | Vare | Beskrivelse | Antal | Enhed | Pris/enh | I alt |
|---|---|---|---|---|---|---|
| 1 | Stabilgrus 0–32 mm | Bundlag 20 cm i frostfri grøft | 2,0 | m³ | | |
| 2 | Fundablok 50 × 20 × 15 cm | Ring + partition cross-wall, 3 skifter forbandt | 124 | stk (117 + buffer) | | |
| 3 | Armeringsjern Ø8 mm | 6 m længder, lodret + vandret | 7 | stk | | |
| 4 | Bindetråd Ø1,2 mm | 1 kg rulle ~250 m | 1 | rulle | | |
| 5 | Færdigblandet beton (tør-sæk) | Hulrumsudstøbning, 25 kg-sæk | 72 | sæk (~900 L) | | |
| 6 | Bundrem 45 × 95 PT (NTR-AB) | Kontinuert ~19,5 m | 5 | stk à 4,8 m | | |
| 7 | Bitumen-tape fugtspærre | 100 mm bred | 1 | rulle 25 m | | |
| 8 | Ledger-bjælke 45 × 95 PT | I hus, 2 stk à 2,35 m | 1 | stk 4,8 m | | |
| 9 | Strø 45 × 95 PT | I hus, 4 stk à 1,35 m | 2 | stk 3,6 m | | |
| 10 | Krydsfiner 18 mm | 1,22 × 2,44 m plade | 1 | stk | | |
| 11 | Mus-net 6 mm galv. | Under hele husgulvet + opfoldning | ~5 | m² | | |
| 12 | Strøsko 45 × 95 (galv.) | Strø-til-ledger | 8 | stk | | |
| 13 | Ankerskruer M10 × 120 | Bundrem-til-ring | 18 | stk | | |
| 14 | Betonskruer 8 × 80 | Ledger-til-ring | 12 | stk | | |
| 15 | Mesh apron 500 mm bred | Yard 3 sider, ~11,5 m langs | ~6 | m² | | |
| | | | | **Total** | | **kr.** |

## Bygge-rækkefølge (kort)

1. Mark op, udgrav rendegrøft 30 cm bred × ~80 cm dyb langs perimeter + cross-wall
2. Stabilgrus 20 cm i bunden, komprimer
3. Læg 3 skifter fundablok i forbandt, sæt lodret armering i hulrum, læg vandret armering i topskiftet
4. Udstøb alle hulrum med beton, lad hærde ~7 dage
5. Fugtspærre + 45 × 95 PT-bundrem hele vejen rundt med M10 ankerskruer c/c 1000
6. Mus-net foldes op rundt om ringen, sømmes til bundrem
7. Skru ledger-bjælker i hus (X = 0..1,5 m), hæng strøer i strøsko, læg krydsfiner-deck
8. Yard-arealet: opfyld med stabilgrus til sokkel-top, læg græs/jord, læg apron-mesh i jord langs 3 yder-sider

## Hvad er IKKE i denne fil

- Selve væggene (stolper, losholter, vindkryds) — se `vaegge.md`
- Tag og spær — se `tagkonstruktion.md`
- Døre og vindue — se `aabninger.md`
- Beklædning (klink + vindpapir) — se `beklaedning.md`
- Inventar (rede-kasse, hø-hæk, foderskåle) — se `inventar.md`

## Audit / verificering

```powershell
# Render fundamentet alene (uden græs så ringen er synlig)
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/01_fundament.png
```
