# Tagkonstruktion

> Implementeret i `src/designs/v3/tagkonstruktion.scad`. Vælg cover-system via `roof_cover` i `src/designs/v3/build.scad`.

V3's tag er en monopitch der hælder 4,6° (drop 200 mm over 2500 mm bygnings-bredde, 8 % fald). Bærelaget er 10 stk 45×95 spær c/c 600 mm der spænder fra front-eave (y=-220) til bag-eave (y=2680) — i alt ca. 2,9 m langs slopen.

Spær-bunden ligger på V1's og V2's toprem (= z = wall_top); spær-toppen er SPAER_H=95 mm højere og er hvor cover-laget begynder. I konstruktionen indskæres bird's-mouth ved hver bæreflade (i SCAD-modellen vises dette som CSG-overlap mellem spær og toprem). Det betyder at v3_roof_oz_for nu ligger SPAER_H højere end wall-plate-toppen — derfor er total bygningshøjde også SPAER_H højere end før.

Spær-til-toprem-samlingen sikres med **2 vinkelbeslag (90×90×2 mm, 50 mm flange)** pr. bæreflade — én på hver side af spæret. I alt 4 vinkelbeslag pr. spær = 40 stk for de 10 spær. Brackets ligger med deres horisontale flange fladt på toprem-toppen og deres vertikale flange opad mod spærets sideflade.

To cover-systemer kan vælges. Begge bruger samme spær-bærelag.

## Sammenligning

| Egenskab                      | `tagpap_osb` (default)                    | `eternit_b7`                                    |
| ----------------------------- | ----------------------------------------- | ----------------------------------------------- |
| Status ved v3's 4,6° hældning | ✓ Inden for spec (min 2,5°)               | ⚠ FOR FLAD — kræver min 10°/14° iht. Cembrit B7 |
| Cover-tykkelse over spær      | 25 mm                                     | 72 mm                                           |
| Vægt pr. m²                   | ~6 kg                                     | ~22 kg                                          |
| Lag                           | OSB → underpap → tagpap → aluinddækning (4 sider) | undertag → afstandsliste → lægter → B7-plader → aluinddækning (4 sider) |
| Forventet levetid             | 20-30 år                                  | 50+ år                                          |
| Pris-niveau (estimat)         | billigere                                 | dyrere                                          |

For v3 anbefales `tagpap_osb`. `eternit_b7` er implementeret til layout-sammenligning men kræver i realiteten større hældning end vores wall-konfiguration tillader.

```
ASCII lag-stak — tagpap_osb (default, set fra siden):

         ─── 4 mm overpap ─────────────────────────  z = roof_oz + 25 (svejset til underpap)
         ─── 3 mm underpap ────────────────────────  z = roof_oz + 21 (mekanisk fastgjort)
         ─── 18 mm OSB plader ─────────────────────  z = roof_oz + 18 (sømmes på spær)
         ════ spær 45×95 c/c 600 ══════════════════  z = roof_oz (= tagets underside)
                                                     spær spænder y = -220..2680
         + 2 mm aluinddækning ved alle 4 tagskæg (front, bag, venstre, højre — dryp-kant 60 mm)
```

```
ASCII lag-stak — eternit_b7 (alternativ):

         ──── 8 mm Cembrit B7 bølgeplade ──────────  z = roof_oz + 72
         ──── 38×73 lægter c/c 500 mm langs X ─────  z = roof_oz + 26..64
         ──── 25×50 afstandsliste på hver spær ────  z = roof_oz + 1..26
         ──── 1 mm undertag-membran ───────────────  z = roof_oz..1
         ════ spær 45×95 c/c 600 ══════════════════  z = roof_oz
```

## Konstruktion

Spær (10 stk 45×95) sættes i spaersko-beslag på V1's og V2's toprem med ende-spær flugtende med V3/V4. Bird's-mouth indskæres ved hver bæreflade (i SCAD vises dette som CSG-overlap mellem spær og toprem). Spær-toppen flugter med tagets underside; alle cover-lag stables over.

På tagpap_osb sømmes 18 mm OSB-plader på spæret med samlinger ved spær-centerlinier. Underpap rulles ud og sømmes mekanisk; tagpap svejses derover med to-punkts overlap. Aluinddækning monteres til sidst ved tagskæg-fronten og -bagen (dryp-kant ~60 mm).

På eternit_b7 lægges undertag-membranen først hen over spæret. Afstandsliste 25×50 sømmes på langs hver spær (skaber ventilations-spalte). Lægter 38×73 monteres perpendikulært c/c 500 mm. Cembrit B7-plader skrues fast med distance-skiver gennem bølgekam.

Sternbræt 22×150 og tagrende 110×65 monteres på begge systemer (front HØJ + bag LAV med nedløb).

## Materialeliste — tagpap_osb

| #   | Vare                              | Beskrivelse                                            | Antal | Enhed       | Pris/enh | I alt |
| --- | --------------------------------- | ------------------------------------------------------ | ----- | ----------- | -------- | ----- |
| 1   | Spær 45×95×3000 mm gran C24       | 10 spær c/c 600, ~2,91 m langs slope                   | 10    | stk         |          |       |
| 2   | OSB plader 18 mm 244×125 cm       | Tagdæk (~18,7 m² roof area + spild)                    | 7     | stk         |          |       |
| 3   | Underpap 1-lag (rulle ~15 m²)     | Mekanisk fastgjort til OSB                             | 2     | rulle       |          |       |
| 4   | Tagpap 1-lag (rulle ~10 m²)       | Svejses til underpap                                   | 2     | rulle       |          |       |
| 5   | Aluinddækning L-profil 80×60 mm   | Alle 4 sider: front 6,4 m + bag 6,4 m + 2 × side 2,9 m | 19    | m           |          |       |
| 6   | Sternbræt 22×150 mm gran          | Front 6,4 m + bag 6,4 m + sider 2 × 2,9 m              | 18    | m           |          |       |
| 7   | Tagrende 110 mm m. nedløb 65 mm   | Bag-eave (LAV side, hvor vandet løber)                 | 6,5   | m           |          |       |
| 8   | Vinkelbeslag 90×90×2 mm (50 mm flange) | 2 pr. bæreflade × 2 bæreflader × 10 spær          | 40    | stk         |          |       |
| 9   | Tagpap-søm + underpap-søm + skruer | Forbrugsstof                                           | 1     | sæt         |          |       |
|     |                                   |                                                        |       |             | **Total** | **kr.** |

## Materialeliste — eternit_b7

| #   | Vare                              | Beskrivelse                                                       | Antal | Enhed | Pris/enh | I alt |
| --- | --------------------------------- | ----------------------------------------------------------------- | ----- | ----- | -------- | ----- |
| 1   | Spær 45×95×3000 mm gran C24       | Som tagpap                                                        | 10    | stk   |          |       |
| 2   | Undertag-membran rulle 1,5×50 m   | 75 m² dækker hele tagfladen                                       | 1     | rulle |          |       |
| 3   | Afstandsliste 25×50×3000 mm       | 1 pr. spær × 10                                                   | 10    | stk   |          |       |
| 4   | Lægter 38×73×3600 mm gran C24     | 6 lægter langs X (à ~6,4 m), splejset af 2 stykker hver           | 12    | stk   |          |       |
| 5   | Cembrit B7 1090×625 mm bølgeplade | ~40-50 plader afhængigt af overlap                                | 45    | stk   |          |       |
| 6   | B7-skruer m. distancering         | ~3 pr. plade                                                      | 150   | stk   |          |       |
| 7   | Sternbræt 22×150 mm gran          | Som tagpap                                                        | 18    | m     |          |       |
| 8   | Tagrende 110 mm m. nedløb 65 mm   | Som tagpap                                                        | 6,5   | m     |          |       |
| 9   | Aluinddækning L-profil 80×60 mm   | Alle 4 sider: front 6,4 m + bag 6,4 m + 2 × side 2,9 m            | 19    | m     |          |       |
| 10  | Vinkelbeslag 90×90×2 mm (50 mm flange) | 2 pr. bæreflade × 2 bæreflader × 10 spær                     | 40    | stk   |          |       |
|     |                                   |                                                                   |       |       | **Total** | **kr.** |

## Bygge-rækkefølge

1. Skær 10 spær 45×95 til længde (~2910 mm), indsav bird's-mouth ved hver ende
2. Læg spærene op c/c 600 mm med bird's-mouth-sæde hvilende på V1's og V2's toprem-top; ende-spær flugter med V3/V4
3. Skru hver spær fast med 2 vinkelbeslag pr. bæreflade (én på hver side af spæret) — horisontal flange skrues i toprem, vertikal flange skrues i spær-siden
4. **Hvis tagpap_osb:** Søm OSB-plader på spær med samlinger over spær-centerlinier → udrul underpap → svejs tagpap
5. **Hvis eternit_b7:** Læg undertag-membran → søm afstandsliste på hver spær → søm lægter perpendikulært c/c 500 mm → skru B7-plader fast med min 200 mm overlap mod hældning
6. Monter sternbrædder rundt om hele tagets perimeter (4 sider)
7. Monter aluinddækning ovenpå cover-kanten ved alle 4 tagskæg (front, bag, venstre, højre — dryp-kant 60 mm hænger ned forbi sternbrædet)
8. Monter tagrende på bag-eave (LAV side) med nedløb i højre side til faldsten / regnvandsfaskine

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# Render begge cover-systemer:
openscad -D 'roof_cover="tagpap_osb"' -o _renders/v3_tag_pap.png src/main.scad
openscad -D 'roof_cover="eternit_b7"' -o _renders/v3_tag_eternit.png src/main.scad
```
