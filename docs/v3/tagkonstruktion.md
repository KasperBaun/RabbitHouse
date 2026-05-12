# Tagkonstruktion (v3) — variant-sammenligning

To varianter af tag-dækningen er tilgængelige. Vælg via `roof_cover` i `src/designs/v3/build.scad`.

| Aspekt              | Eternit B7                                              | Tagpap (OSB + selvbyggerpap)                            |
| ------------------- | ------------------------------------------------------- | ------------------------------------------------------- |
| **Cover**           | Cembrit/Swisspearl B7 sortblå bølgeplade, 1100×570 mm   | Phønix Selvbyggerpap 2-lags på OSB-3 TG4 18 mm          |
| **Hældning**        | 14° (`roof_cover = "eternit_14"`)                       | 4,6° / 8 % (`roof_cover = "tagpap_osb"`)                |
| **Bærelag**         | C18 lægter 38×73 c/c 460 mm                             | OSB-3 TG4 18 mm (også diaphragm)                        |
| **Trim**            | Stern uden vinkelrygning (åben top-eave)                | Sternbræt + alu sternkapsler på alle 4 eaves            |
| **Holdbarhed**      | ~70 år, vedligeholdelsesfri                             | ~10-15 år, omlægning forventes                          |
| **Vægt**            | ~14 kg/m² (tungere — kræver støttende lægter)           | ~5 kg/m² (lettere, men OSB bærer hele last)             |
| **Sværhedsgrad**    | Højere — eksakt c/c 460 mm lægtning, plade-håndtering   | Lavere — OSB lægges som almindelige plader, tagpap simpelt |
| **Pris-overslag**   | ~9.760 kr (~11.000 kr inkl. spild)                      | ~10.905 kr (~12.000 kr inkl. spild)                     |
| **Doc**             | [tagkonstruktion_eternit.md](tagkonstruktion_eternit.md) | [tagkonstruktion_tagpap.md](tagkonstruktion_tagpap.md)  |

## Fælles træværk

Følgende elementer er identiske i begge varianter og dokumenteres i hver enkelt fil:

- **Spær** 47×100 C24, 13 stk c/c 600 (11 regulære + 2 vindskede), m. fugleudskæring
- **Sternbræt** 25×125 imprægneret gran, ~19 m langs perimeteren (6 stk × 3,6 m)
- **Vinkelbeslag** 90×90×40 — ~48 stk på spær-bæreflader
- **Sofitt** 18 mm krydsfiner på alle 4 tagskæg-undersider
- **Tagrende** 110 mm + nedløb Ø75 ved bag-eave

## Hvilken skal jeg vælge?

| Hvis du... | Vælg |
|---|---|
| Vil have lang holdbarhed (~70 år) og minimal vedligeholdelse | Eternit B7 |
| Vil have lavest pris og hurtigst byggetid | Tagpap |
| Vil have rent visuelt udtryk uden synlige overlap | Tagpap (eller B7 med stort plade-format 1100×1525) |
| Vil have karakteristisk industri-look med synlige bølger | Eternit B7 |
| Er nervøs for korrekt c/c 460 mm lægtning og plade-skæring | Tagpap |

## Stykkeliste på tværs

Detaljeret skæreliste (spær-positioner, fugleudskæring-mål, vinkelbeslag-fordeling) er fælles og findes i [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md).
