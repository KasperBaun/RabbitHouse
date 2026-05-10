# Tagkonstruktion

> Implementeret i `src/designs/v3/tagkonstruktion.scad`

Taget er en ensidet tagflade der hælder 4,6° (8 % fald) fra HØJ front til LAV bag. Den består af 4 lag.

1. Spær
2. OSB-tagdæk
3. Selvbyggerpap (selvklæbende, DIY-venlig)
4. Aluinddækning + sternbræt + tagrende

Spær spænder hele bygningens bredde og hviler på V1's og V2's toprem. Toprem er forlænget 220 mm forbi V3 og V4 i hver ende, så vindskede-spær ved overhang-kanten hviler på den forlængede toprem akkurat som de øvrige spær.

```
        ┌─────────────────── bag-overhang 180 ─────────────────┐
        │   ┌──────────────────────────────────────────┐       │
        │   │                                          │       │
   side │   │                                          │       │ side
   220  │   │   13 spær 45×95 c/c 600 langs Y          │       │ 220
        │   │   (11 regulære + 2 vindskede ved kant)   │       │
        │   │                                          │       │
        │   └──────────────────────────────────────────┘       │
        └─────────────────── front-overhang 220 ───────────────┘
        ←─────────────────────── 6440 mm ─────────────────────→
                              (set ovenfra)
```

```
        ▓▓▓ selvbyggerpap 5 mm ▓▓▓▓  z = wall-top + 118 mm
        ═══ OSB-dæk 18 mm ═════════
        │                          │
        │  spær 45×95 c/c 600 mm   │  z = wall-top + 95 mm (= cover-bund)
        │                          │
        ├──── V1/V2 toprem ────────┤  z = 2,52 m (V1) / 2,32 m (V2)
                                    (lag-stak set fra siden)

        + aluinddækning ved alle 4 tagskæg:
            • Tagfod 55×80 på front + bag
            • Vindskede 70×23×80 på venstre + højre (skrå)
```

## Mål

| Egenskab              | Værdi                                                   |
| --------------------- | ------------------------------------------------------- |
| Tagflade              | 6,44 × 2,9 m (~19 m² incl. overhangs)                    |
| Hældning              | 4,6° / 8 % fald (drop 200 mm over 2500 mm)              |
| Spær                  | 13 stk 47×100 c/c 600 (11 regulære + 2 vindskede)       |
| Overhæng              | 220 mm front + 180 mm bag + 220 mm i hver side          |
| Lag over spær         | 23 mm (OSB 18 + selvbyggerpap 5)                        |
| Total højde over jord | 2,66 m ved højeste punkt (front-overhang)               |

## Konstruktion

Spær 47×100 skæres til ~2910 mm med fugleudskæring ved hver ende (95 mm langs × 7,6 mm dyb trekantet kile i spær-bunden — se [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md)). Læg 11 spær c/c 600 mm fra X=0 til X=5955; vindskede-spær ved X=-220 og X=6175 hviler på den forlængede V1+V2 toprem. Hvert regulært spær fastgøres med 2 vinkelbeslag pr. bæreflade (én på hver side); vindskede-spær får 1 på indersiden.

OSB-plader 18 mm TG4 (tand-og-not på alle 4 sider) lægges med deres lange side (2397 mm) PÅ TVÆRS af spær. Pladens 600 mm bredde matcher spær c/c 600 EXACT — kanterne lander automatisk på spær-centerlinier. 3 plader pr. række (2×fulde + 1×cut til 1646 mm) × 5 rækker = 15 plader. Skrues fast med 5×80 skruer c/c 150 mm langs alle kanter og c/c 300 mm i pladens midte. Selvbyggerpap rulles ud fra LAV (bag) mod HØJ (front) så den øverste bane laps OVER den underste i vand-strømmens retning. Sømmes mekanisk c/c 150 mm langs alle kanter; selvklæbende strenge danner overlap (~100 mm) mellem baner. Ingen flamme eller varmluft nødvendig.

Aluinddækning monteres rundt om alle 4 tagskæg: **tagfod-profil** på front + bag (vandret afslutning), **vindskede-profil** på venstre + højre (skrå med taget). Skrues fast med rustfri tagskruer m. EPDM-pakning gennem topflangen ind i OSB c/c ~300 mm. Læg en stribe **TagSealer** (bitumen-fugemasse) UNDER topflangen som tætningslag mellem selvbyggerpap og alu — **ikke silikone-fuge** (silikone holder ikke til alus temperatur-udvidelse).

Sternbræt 21×120 langs hele perimeteren skrues fast i spær-ender og vindskede-spæret. Tagrende 110 mm med nedløb Ø75 mm i højre side på bag-eaven; nedløbet føres via bøjninger til faldsten eller regnvandsfaskine for at lede vandet væk fra fundamentet.

## Materialeliste

Stykkevis skæreliste (positioner, fugleudskæring-mål, vinkelbeslag-fordeling): [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md).

| #   | Vare                                            | Beskrivelse                                                       | Antal | Enhed     | Pris/enh  | I alt   |
| --- | ----------------------------------------------- | ----------------------------------------------------------------- | ----- | --------- | --------- | ------- |
|     | **Træværk**                                     |                                                                   |       |           |           |         |
| 1   | Reglar 47×100×3000 mm gran C24                  | Spær — 11 regulære c/c 600 + 2 vindskede                          | 13    | stk       |           |         |
| 2   | OSB-3 plade TG4 18 mm 2397×600 mm               | Tagdæk ~19 m². 600 mm bredde matcher spær c/c — samlinger lander på spær-centerlinier automatisk | 15    | stk       |           |         |
| 3   | Imp. stern 21×120×3600 mm gran                  | Sternbræt — hele perimeter (19 m fordelt over 4 sider)            | 6     | stk       |           |         |
|     | **Tagdækning**                                  |                                                                   |       |           |           |         |
| 4   | Phønix Selvbyggerpap 1×5 m                      | Selvklæbende, dækker ~5 m² pr. rulle (~19 m² + overlap)           | 5     | rulle     |           |         |
| 5   | TagSealer 300 ml Phønix                         | Bitumen-fugemasse til alu/pap-overgang (IKKE silikone)            | 3     | tube      |           |         |
|     | **Aluinddækning**                               |                                                                   |       |           |           |         |
| 6   | Tagfod aluminium 55×80×1000 mm                  | Front + bag eaves (13 m i alt, 1 m pr. stk)                       | 13    | stk       |           |         |
| 7   | Vindskede aluminium 70×23×80×1000 mm            | Venstre + højre sider (skrå, 6 m i alt)                           | 6     | stk       |           |         |
|     | **Vandhåndtering**                              |                                                                   |       |           |           |         |
| 8   | Tagrende 110 mm stål eller plast (sæt)          | Bag-eave, 6,5 m incl. tilbehør                                    | 1     | sæt       |           |         |
| 9   | Tagrende-beslag                                 | c/c 550 mm langs bag-eave                                         | 12    | stk       |           |         |
| 10  | Endebund tagrende 110 mm                        | Lukker tagrendens to ender                                        | 2     | stk       |           |         |
| 11  | Bladsamler 75-82 mm                             | Filter ved nedløbsudgang                                          | 1     | stk       |           |         |
| 12  | Nedløbsrør Ø75 mm × 3 m                         | Fra tagrende ned til faldsten                                     | 1     | stk       |           |         |
| 13  | Nedløbsbøjning Ø75 mm                           | Knæ-stykker (top + bund)                                          | 2     | stk       |           |         |
|     | **Beslag og fastgørelse**                       |                                                                   |       |           |           |         |
| 14  | Vinkelbeslag 90×90×40 mm 20-pak                 | 48 nødvendige → 3 pak (60 stk)                                    | 3     | pak       |           |         |
| 15  | OSB/spær-skruer 5×80 mm                         | OSB på spær (~80 stk) + vinkelbeslag-skruer (~150 stk)            | 250   | stk       |           |         |
| 16  | Rustfri tagskruer m. EPDM-pakning               | Alu-profiler på OSB (~50 stk)                                     | 1     | pakke     |           |         |
| 17  | Galvaniseret tagpapsøm                          | Selvbyggerpap på OSB (~150 stk)                                   | 1     | æske      |           |         |
|     |                                                 |                                                                   |       |           | **Total** | **kr.** |

Eksterne (ikke fra jemogfix): faldsten eller regnvandsfaskine til at lede tagvandet væk fra fundamentet.

## Bygge-rækkefølge

1. Skær 11 regulære + 2 vindskede spær til ~2910 mm; indsav fugleudskæring ved hver ende
2. Læg spær c/c 600 mm: regulære på V1+V2 toprem, vindskede på toprem-forlængelsen ved X=-220 og X=6175
3. Skru fast med vinkelbeslag — 2 pr. bæreflade på regulære, 1 på indersiden af vindskede
4. Skru OSB-plader på spær med 5×80 skruer — plade-samlinger over spær-centerlinier (~80 skruer i alt)
5. Rul selvbyggerpap fra LAV mod HØJ side, så øverste bane laps OVER nederste i vand-retningen. Søm fast med tagpapsøm c/c 150 mm langs alle kanter. Selvklæbende strenge danner overlap mellem baner
6. Monter sternbrædder rundt om hele perimeteren (front + bag + 2 sider) — side-fascian skrues fast i vindskede-spæret
7. Læg en stribe TagSealer langs hver tagskæg-kant ovenpå selvbyggerpap. Monter aluinddækning: tagfod på front + bag eaver, vindskede på venstre + højre sider. Skrues fast med rustfri tagskruer m. EPDM gennem topflangen ind i OSB c/c ~300 mm. Overlap mellem to alu-stykker: ~50-100 mm med øvre-stykke OVENPÅ nedre i vand-retningen
8. Monter tagrende-beslag på bag-sternbrædet c/c 550 mm. Klik tagrende på, sæt endebund i hver ende
9. Monter nedløb: bladsamler ved tagrende-udgang (højre ende) → nedløbsbøjning → 3 m nedløbsrør → bøjning ved bunden → ud til faldsten/faskine

## Vigtigt om alu-fastgørelse

**Aluminium fastgøres ALDRIG med silikone-fuge.** Alu udvider/sammentrækker betydeligt med temperatur (2-3 mm pr. meter ved 40°C ΔT), og silikone holder ikke til den bevægelse — den brydes inden for 1-2 år og lukker derefter vand ind.

Den rigtige fremgangsmåde er **mekanisk fastgørelse + bitumen-tætning**:

1. Rustfri tagskruer m. EPDM-pakning gennem alu-topflangen ind i OSB c/c ~300 mm. EPDM-pakningen lukker skrue-hullet vandtæt.
2. **TagSealer** (Phønix tag-fugemasse, bitumen-baseret) lægges UNDER topflangen som elastisk tætning mellem selvbyggerpap og alu. Bitumenmassen følger med alus bevægelse og forbliver elastisk i 15-20 år.
3. Overlap mellem to alu-stykker: 50-100 mm. Top-stykket lægges OVENPÅ bund-stykket i vand-strømmens retning (mod LAV side). Skrues fast gennem overlappet. Evt. en stribe TagSealer i overlappet.

Silikone bruges i køkken/bad — IKKE i tagpap-systemer. Bitumenmasse er det korrekte materiale.

## Alternativ tagdækning

Tagets bærelag kan i stedet dækkes med Cembrit B7 eternit-bølgeplader (vælg via `roof_cover = "eternit_b7"` i build.scad). Lag-stakken bliver da undertag-membran → afstandsliste 25×50 langs hver spær → lægter 38×73 c/c 500 → B7-plader 8 mm. Eternit kræver dog ≥10° hældning (extended overlap) eller ≥14° (standard) iht. Cembrit's spec — vores 4,6° opfylder ikke kravet, så denne variant er kun implementeret til layout-sammenligning.

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/05_tagkonstruktion.png
```
