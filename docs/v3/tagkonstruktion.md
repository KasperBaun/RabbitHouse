# Tagkonstruktion

> Implementeret i `src/designs/v3/tagkonstruktion.scad`. Vælg cover-system via `roof_cover` i `src/designs/v3/build.scad`.

V3's tag er en monopitch der hælder 4,6° (drop 200 mm over 2500 mm bygnings-bredde, 8 % fald). Bærelaget består af:

- **11 regulære spær** 45×95 c/c 600 mm langs X = 0, 600, 1200, …, 5400, 5955. Gable-spæret ved X=0 hviler på V3's skrå toprem langs hele dens længde, gable-spæret ved X=5955 tilsvarende på V4. Alle hviler dels på V3/V4 dels på V1+V2 ved enderne. Spændviden y=-220..2680 (~2,9 m).
- **2 barge rafters (vindskede-spær)** ved X=-220 og X=6175 — hviler direkte på V1+V2's *forlængede toprem*, der kantilevrer V3_OH_SIDE=220 mm forbi V3 og V4 i hver ende. Barge raftren bærer side-fascian.

V1 og V2 toprem er forlænget i konstruktions-skelet til at spænde fra X=-V3_OH_SIDE til X=ll+V3_OH_SIDE (i alt 6440 mm). Forlængelsen kantilevrer fra wall-strukturen (studs ved X=0 og X=ll giver det nærmeste støttepunkt) og gør at barge raftren bærer på toprem akkurat som de regulære spær — ingen separat lookouts behøves.

Spær-bunden ligger på toprem-toppen (= z = wall_top); spær-toppen er SPAER_H=95 mm højere. I konstruktionen indskæres bird's-mouth ved hver bæreflade (CSG-overlap i modellen).

Spær-til-toprem-samlingen sikres med **vinkelbeslag (90×90×2 mm, 50 mm flange)**:

- De 11 regulære spær får 2 brackets pr. bæreflade (én på hver side af spæret) × 2 bæreflader = 4 brackets/spær = **44 stk**.
- De 2 barge rafters får 1 bracket pr. bæreflade på indersiden (ydersiden ville være i luften past forlængelsens ende) × 2 bæreflader = 2 brackets/spær = **4 stk**.
- I alt **48 vinkelbeslag**.

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
| 1   | Spær 45×95×3000 mm gran C24       | 11 regulære c/c 600 + 2 barge rafters i overhang-kant  | 13    | stk         |          |       |
| 2   | OSB plader 18 mm 244×125 cm       | Tagdæk (~18,7 m² roof area + spild)                    | 7     | stk         |          |       |
| 3   | Underpap 1-lag (rulle ~15 m²)     | Mekanisk fastgjort til OSB                             | 2     | rulle       |          |       |
| 4   | Tagpap 1-lag (rulle ~10 m²)       | Svejses til underpap                                   | 2     | rulle       |          |       |
| 5   | Aluinddækning L-profil 80×60 mm   | Alle 4 sider: front 6,4 m + bag 6,4 m + 2 × side 2,9 m | 19    | m           |          |       |
| 6   | Sternbræt 22×150 mm gran          | Front 6,4 m + bag 6,4 m + sider 2 × 2,9 m              | 18    | m           |          |       |
| 7   | Tagrende 110 mm m. nedløb 65 mm   | Bag-eave (LAV side, hvor vandet løber)                 | 6,5   | m           |          |       |
| 8   | Vinkelbeslag 90×90×2 mm (50 mm flange) | 44 på regulære + 4 på barge = 48 stk             | 48    | stk         |          |       |
| 9   | Tagpap-søm + underpap-søm + skruer | Forbrugsstof                                           | 1     | sæt         |          |       |
|     |                                   |                                                        |       |             | **Total** | **kr.** |

## Materialeliste — eternit_b7

| #   | Vare                              | Beskrivelse                                                       | Antal | Enhed | Pris/enh | I alt |
| --- | --------------------------------- | ----------------------------------------------------------------- | ----- | ----- | -------- | ----- |
| 1   | Spær 45×95×3000 mm gran C24       | 11 regulære + 2 barge rafters (som tagpap)                        | 13    | stk   |          |       |
| 2   | Undertag-membran rulle 1,5×50 m   | 75 m² dækker hele tagfladen                                       | 1     | rulle |          |       |
| 3   | Afstandsliste 25×50×3000 mm       | 1 pr. spær × 10                                                   | 10    | stk   |          |       |
| 4   | Lægter 38×73×3600 mm gran C24     | 6 lægter langs X (à ~6,4 m), splejset af 2 stykker hver           | 12    | stk   |          |       |
| 5   | Cembrit B7 1090×625 mm bølgeplade | ~40-50 plader afhængigt af overlap                                | 45    | stk   |          |       |
| 6   | B7-skruer m. distancering         | ~3 pr. plade                                                      | 150   | stk   |          |       |
| 7   | Sternbræt 22×150 mm gran          | Som tagpap                                                        | 18    | m     |          |       |
| 8   | Tagrende 110 mm m. nedløb 65 mm   | Som tagpap                                                        | 6,5   | m     |          |       |
| 9   | Aluinddækning L-profil 80×60 mm   | Alle 4 sider: front 6,4 m + bag 6,4 m + 2 × side 2,9 m            | 19    | m     |          |       |
| 10  | Vinkelbeslag 90×90×2 mm (50 mm flange) | 44 på regulære + 4 på barge = 48 stk                         | 48    | stk   |          |       |
|     |                                   |                                                                   |       |       | **Total** | **kr.** |

## Bygge-rækkefølge

1. Skær 11 regulære spær + 2 barge rafters 45×95 til længde (~2910 mm), indsav bird's-mouth ved hver ende
2. Læg de 11 regulære spær op c/c 600 mm: gable-spær ved X=0 og X=5955 hviler både på V1+V2 (ender) og på V3/V4 toprem (langs hele længden); 9 indre spær hviler kun på V1+V2
3. Sæt barge rafters direkte på V1+V2's forlængede toprem ved X=-220 og X=ll+OH_SIDE-45=6175 — toprem-forlængelsen kantilevrer 220 mm forbi V3/V4 og bærer barge raftren
4. Skru regulære spær fast med 2 vinkelbeslag pr. bæreflade (én på hver side af spæret) og barge raftren med 1 vinkelbeslag pr. bæreflade på indersiden — horisontal flange skrues i toprem, vertikal flange skrues i spær-siden
5. **Hvis tagpap_osb:** Søm OSB-plader på spær (incl. barge rafters) med samlinger over spær-centerlinier → udrul underpap → svejs tagpap
6. **Hvis eternit_b7:** Læg undertag-membran → søm afstandsliste på hver spær → søm lægter perpendikulært c/c 500 mm → skru B7-plader fast med min 200 mm overlap mod hældning
7. Monter sternbrædder rundt om hele tagets perimeter (4 sider) — side-fascian sømmes fast i barge raftren
8. Monter aluinddækning ovenpå cover-kanten ved alle 4 tagskæg (front, bag, venstre, højre — dryp-kant 60 mm hænger ned forbi sternbrædet)
9. Monter tagrende på bag-eave (LAV side) med nedløb i højre side til faldsten / regnvandsfaskine

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# Render begge cover-systemer:
openscad -D 'roof_cover="tagpap_osb"' -o _renders/v3_tag_pap.png src/main.scad
openscad -D 'roof_cover="eternit_b7"' -o _renders/v3_tag_eternit.png src/main.scad
```
