# Fundament

> Implementeret i `src/designs/v3/fundament.scad`.

Kontinuert fundablok-strimmel under hele bygningens perimeter (6 × 2,5 m, ~17 m omkreds) plus en cross-wall under partition-væggen ved X = 1,5 m. Fundamentet er kun det betonbaserede underlag — bundrem, murpap og resten af træ-skelettet ligger i `konstruktions-skelet.md`.

## Mål

| Egenskab | Værdi |
|---|---|
| Footprint | 6,0 × 2,5 m |
| Sokkel-højde over jord | 12 cm (1 skifte) |
| Total ringhøjde | 60 cm (3 skifter à 20 cm) |
| Frostfri grøftdybde | ~80 cm |
| Stabilgrus i bunden | 10 cm |

## Konstruktion

Tre skifter fundablok 50 × 20 × 15 cm lagt i halvstensforbandt rundt om hele perimeteren samt på tværs ved X = 1500 mm (hus/yard-skel). Hulrum udstøbes med selvblandet beton (cement + støbemix + vand). Lodret armeringsjern Ø8 mm sættes gennem hver ~1 m + alle hjørner og T-samlinger; vandret bane i øverste skifte. Topskiftet ligger flush med sokkel-niveau (z = 120 mm over jord).

M10 ankerskruer drives ned i topskiftet c/c 1000 mm langs hele perimeteren + cross-wall — disse fastgør den efterfølgende bundrem (se `konstruktions-skelet.md`).

## Materialeliste

Priser tilføjes senere. Forslag til leverandører: Bauhaus, Stark, XL-BYG.

| # | Vare | Beskrivelse | Antal | Enhed | Pris/enh | I alt |
|---|---|---|---|---|---|---|
| 1 | Stabilgrus 0–32 mm | Bundlag 10 cm i frostfri grøft (~30 cm bred × 19,35 m) | ~0,6 | m³ | | |
| 2 | Fundablok 50 × 20 × 15 cm | Ring + partition cross-wall, 3 skifter forbandt | 124 | stk (117 + buffer) | | |
| 3 | Armeringsjern Ø8 mm | 6 m længder, lodret + vandret | 7 | stk | | |
| 4 | Cement (Aalborg Portland CEM I/II, 25 kg-sæk) | Til hulrumsudstøbning, ~900 L beton | 12 | sæk | | |
| 5 | Støbemix 0–16 mm | Sand+grus til selvblanding, big-bag 1 m³ | 1 | stk | | |
| 6 | Ankerskruer M10 × 120 | Bundrem-til-ring c/c 1000 | 18 | stk | | |
| | | | | | **Total** | **kr.** |

## Bygge-rækkefølge

1. Mark op, udgrav rendegrøft 30 cm bred × ~80 cm dyb langs perimeter + cross-wall
2. 10 cm stabilgrus i bunden, komprimer
3. Læg 3 skifter fundablok i halvstensforbandt
4. Sæt lodret armering i hulrum hver ~1 m + alle hjørner og T-samlinger; vandret armering i topskiftet
5. Bland selv beton (cement + støbemix + vand i ~1:4 forhold), udstøb alle hulrum, lad hærde ~7 dage
6. Bor og sæt M10 ankerskruer c/c 1000 mm i topskiftet (klar til bundrem fra `konstruktions-skelet`)

## Hvad er IKKE i denne fil

- Bundrem + murpap → `konstruktions-skelet.md`
- Stolper, toprem, losholter, vindkryds → `vaegge.md` (vil flytte til konstruktions-skelet senere)
- Strøer-gulv, krydsfiner, mus-net → kommer i egen fil (gulv eller del af konstruktions-skelet)
- Mesh apron (predator dig defence) → kommer i egen fil
- Tag og spær → `tagkonstruktion.md`
- Døre og vindue → `aabninger.md`
- Beklædning → `beklaedning.md`
- Inventar → `inventar.md`

## Audit / verificering

```powershell
# Render fundamentet alene (uden græs så ringen er synlig)
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/01_fundament.png
```
