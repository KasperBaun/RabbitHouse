# Tagkonstruktion — Eternit B7 variant

> Implementeret i `src/designs/v3/tagkonstruktion_eternit.scad`
> Vælges med `roof_cover = "eternit_14"` i `src/designs/v3/build.scad` (14° hældning, spec-korrekt geometri).
> Fælles framing/sofitt-moduler i `tagkonstruktion_faelles.scad`.

Ensidet tagflade dækket med **Cembrit/Swisspearl B7 eternit-bølgeplader (sortblå)** på C18 taglægter. Pladen er ~70 år holdbar og vedligeholdelsesfri.

Per Swisspearl montagevejledning (rev. 02.2025) kræver B7 minimum **14° hældning** (standard overlæg). Default-værdien `"eternit_b7"` (4,6°) bruges kun til layout-sammenligning og er **ikke buildbar**.

## Lag (oppefra og ned)

1. **Swisspearl 100 Tagskruer** 6×100 mm m. EPDM-pakning — 2 stk pr. plade i bølgetop
2. **Cembrit B7 bølgeplade** 1100×570 mm, 6,5 mm tyk, montagehøjde 65 mm, sortblå
3. **C18 taglægter** 38×73 mm, c/c præcis **460 mm** (= 570 plade − 110 overlap)
4. **Spær** 47×100 C24 c/c 600 mm
5. **Sternbræt** 25×125 + tagrende på bag-eaven

```
                                    ┌─ Swisspearl 100 tagskrue (2 pr. plade)
                                    │
        B7 ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮  ▼   ← sortblå corrugated, 65 mm bølgehøjde
       ───┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴────  ← lægte-top (B7 trough hviler her)
       │ C18 lægte 38×73 c/c 460 mm  │
       ├─────────────────────────────┤   ← spær-top
       │  spær 47×100 c/c 600 mm     │
       │                             │
       ├──── V1/V2 toprem ───────────┤   ← wall-top
                                          (lag-stak set fra siden)

Bund-pladen hænger 60 mm ud over back-sternbræt-yderkant (drip i tagrende).
Første lægte sidder a-mål = 510 mm inde fra back-sternbræt-yderkant.
```

## Mål

| Egenskab            | Værdi                                                          |
| ------------------- | -------------------------------------------------------------- |
| Tagflade            | 6,44 × 2,95 m (~19 m² incl. overhangs)                         |
| Hældning            | 14° (`roof_cover = "eternit_14"`)                              |
| Spær                | 13 stk 47×100 C24 c/c 600 (11 regulære + 2 vindskede)          |
| Overhæng            | 220 mm front + 180 mm bag + 220 mm i hver side                 |
| Lægter              | 6 stk 38×73 C18 (~6,44 m hver), c/c 460 mm                     |
| Tagdække            | 49 hele B7 plader (7 rækker × 7 plader bredt) + ~5 % spild     |
| Lag over spær       | 110 mm (38 lægte + 6,5 plade-trough + 65 bølge-amplitude)      |

## Konstruktion

**Spær** 47×100 C24 skæres til ~2910 mm med fugleudskæring ved hver ende (95 mm langs × 7,6 mm dyb trekantet kile — se [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md)). 11 spær c/c 600 fra X=0 til X=5955; vindskede-spær ved X=-220 og X=6175 hviler på den forlængede V1+V2 toprem. Hvert regulært spær fastgøres med 2 vinkelbeslag pr. bæreflade; vindskede-spær får 1 på indersiden.

**C18 taglægter** 38×73 lægges PERPENDIKULÆRT på spær og sømmes med varmforzinkede sømstifter i hvert spær-krydsningspunkt. Layout er bestemt af B7 plade-geometrien:

- **Første lægte (a-mål)** sidder 510 mm inde fra back-sternbræt-yderkant — det er top-kanten af nederste B7 plade-række. Bund-pladens nederste kant hænger 60 mm ud over sternbrættet ned i tagrenden.
- **Subsequent lægter** c/c **præcis 460 mm** opad mod front (= 570 plade − 110 mm minimum overlæg).
- **Top-pladen** ved front-eaven skæres til pasning (~250 mm høj cut-stykke) og bæres af næst-øverste lægte; kort overhang < 460 mm = ingen separat top-lægte nødvendig.

Resultat: **6 lægter** ved Y = 2195 / 1735 / 1275 / 815 / 355 / −105 (V3-koordinatsystem).

**B7 bølgeplader** lægges fra venstre mod højre, startende med nederste række ved bag-eaven. Hver plade overlapper plade-rækken nedenfor med 110 mm og naboplade med 78 mm (= 1100 − 1022 montagebredde). Plader skrues fast med **Swisspearl 100 Tagskruer 6×100** — 2 pr. plade i bølgetop ved øverste kant. Plade-tælling pr. tagflade: **7 rækker langs slope × 7 plader bredt = 49 plader**.

**Sternbræt** 25×125 langs hele perimeteren skrues fast i spær-enderne. Sternbræt-toppen placeres LIGE UNDER eternit-trough-niveau (lægte-top), så B7 pladen kan dryppe frit forbi sternbræt og ned i tagrenden uden kollision.

**Top-eave (front, høj):** Bemærk — denne variant bruger **ikke vinkelrygning**. Top-cut-pladen ved front-eaven har en åben corrugated kant. Hvis vind-drevet regn er en bekymring, kan kanten lukkes med profil-skumstrimmel eller en hjemmebøjet zink-flange (~60 mm bred), men ikke som fabriksleveret Swisspearl-vinkelrygning.

**Tagrende** 110 mm monteres på back-sternbrættets yder-flade med beslag c/c ~550 mm. Nedløb Ø75 i højre side leder vandet til faldsten eller faskine.

## Materialeliste

Stykkevis skæreliste: [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md).

| #   | Vare                                       | Beskrivelse                                          | Antal | Enhed | Pris/enh | I alt    | Note |
| --- | ------------------------------------------ | ---------------------------------------------------- | ----- | ----- | -------- | -------- | ---- |
|     | **Træværk**                                |                                                      |       |       |          |          |      |
| 1   | RAW Spærtræ C24 47×100×3000 mm gran        | Spær — 11 regulære + 2 vindskede                     | 13    | stk   | ~85,00   | ~1.105   | est. (Stark) |
| 2   | RAW C18 taglægte 38×73×4200 mm             | 6 rækker à ~6,44 m + spild → 11 stk × 4,2 m          | 11    | stk   | 52,50    | 577,50   | [10-4.dk](https://www.10-4.dk/varer/byggematerialer/trae/laegter/38x73mm-taglaegte-c18-1731038073) |
| 3   | Imp. stern 25×125×3600 mm gran             | Sternbræt — hele perimeter (~19 m)                   | 6     | stk   | 82,60    | 495,72   | [xl-byg.dk](https://www.xl-byg.dk/produkt/xl-byg-ru-sternbraet-over-trykimpraegneret-25-x-125-x-3600-mm-1143025122-0360) |
|     | **Tagdækning (Cembrit B7 sortblå)**        |                                                      |       |       |          |          |      |
| 4   | Swisspearl B7 bølgeplade FK 1100×570 sortblå | 49 hele + ~5 % spild ved hjørne-skæringer            | 52    | stk   | 95,00    | 4.940    | [bygxtra.dk](https://www.bygxtra.dk/produkter/swisspearl-boelgeplade-b7-fk-i-sortblaa-1100x570-mm-1617012) |
| 5   | Swisspearl 100 Tagskrue 6×100 sortblå (100-pak) | 2 pr. plade × 49 + spild = ~108                  | 2     | pak   | 425,00   | 850,00   | [davidsen.dk](https://www.davidsen.dk/swisspearl-100-tagskrue-m-taetningsskive-6x100-mm-graa-100-stk-c-id525046-p-51601506116) |
| 6   | Swisspearl PVC Skumstrimmel 4,5 mm         | Tværgående tætning ved overlap-samlinger (rulle)     | 1     | rulle | ~150     | ~150     | est. |
|     | **Vandhåndtering**                         |                                                      |       |       |          |          |      |
| 7   | Tagrende 110 mm stål/plast (sæt 6,5 m)     | Bag-eave inkl. tilbehør                              | 1     | sæt   | ~600     | ~600     | est. |
| 8   | Tagrende-beslag                            | c/c 550 mm langs bag-eave                            | 12    | stk   | ~30      | ~360     | est. |
| 9   | Endebund tagrende 110 mm                   | Lukker tagrendens to ender                           | 2     | stk   | ~50      | ~100     | est. |
| 10  | Bladsamler 75-82 mm                        | Filter ved nedløbsudgang                             | 1     | stk   | ~80      | ~80      | est. |
| 11  | Nedløbsrør Ø75 mm × 3 m                    | Fra tagrende ned til faldsten                        | 1     | stk   | ~200     | ~200     | est. |
| 12  | Nedløbsbøjning Ø75 mm                      | Knæ-stykker (top + bund)                             | 2     | stk   | ~80      | ~160     | est. |
|     | **Beslag og fastgørelse**                  |                                                      |       |       |          |          |      |
| 13  | Paslode vinkelbeslag 90×90×40 mm (20-pak)  | 48 nødvendige → 3 pak (60 stk)                       | 3     | pak   | ~150     | ~450     | est. ([wood-online](https://wood-online.dk/shop/paslode-vinkelbeslag-542p.html) enkelt-pris 8,48 kr) |
| 14  | NKT Basic skrue 5×80 ruspert (250-pak)     | Vinkelbeslag + sternbræt + lægter på spær            | 1     | pak   | ~225     | ~225     | est. ([bygxtra](https://www.bygxtra.dk/produkter/nkt-basic-skrue-outdoor-50x8045-mm-ruspert-1000-250-stk-1673216)) |
| 15  | NKT lægtesøm 3,4×80 varmf. (≈210 stk)      | 2 søm pr. krydsningspunkt × 6 × 13 ≈ 156             | 1     | pak   | ~70      | ~70      | est. |
|     |                                            |                                                      |       |       | **Total** | **~9.760** | (≈11.000 inkl. realistisk spild + sofitt-kryds.) |

### Note: plade-format

Cembrit B7 fås også i **1100×1525 mm**. Med større plader bliver der færre rækker langs slope (3 i stedet for 7) og dermed kun ~21 plader i stedet for 49. Pris-pr-m² er lavere, men hver plade er tungere og sværere at håndtere solo. SCAD-modellen viser **1100×570 mm** format — skift både SCAD og BOM hvis du foretrækker det store format.

## Bygge-rækkefølge

1. Skær 11 regulære + 2 vindskede spær til ~2910 mm; indsav fugleudskæring ved hver ende
2. Læg spær c/c 600 mm: regulære på V1+V2 toprem, vindskede på toprem-forlængelsen ved X=-220 og X=6175
3. Skru fast med vinkelbeslag — 2 pr. bæreflade på regulære, 1 på indersiden af vindskede
4. **Mål første lægte-position**: 510 mm inde fra back-sternbræt-yderkant. Søm lægte 38×73 (~6,44 m) på alle spær med varmforzinkede søm 3,4×80 — 2 pr. krydsningspunkt
5. **Læg subsequent lægter** c/c præcis 460 mm opad mod front. Brug en målestok eller kort lægte som "klods" mellem hver lægte. Total 6 lægter
6. Monter sternbrædder 25×125 rundt om hele perimeteren. **Sternbræt-toppen placeres LIGE UNDER lægte-top-niveau** (~7 mm under), så B7 pladen kan dryppe frit forbi
7. **Læg B7 pladerne** fra venstre mod højre, startende med nederste række ved bag-eaven:
   - Hver plade overlapper nedenfor med 110 mm og naboplade med 78 mm (= 1022 mm effektiv montagebredde)
   - Skru hver plade med **2 Swisspearl 100 Tagskruer** i bølgetop ved øverste kant (skruer gennem overlap-zonen fastgør også pladen ovenfor)
   - Per spec: brug HJ/HU plader (pre-borede huller). Hvis FK plader, bor ø10 mm hul i bølgetop først, derefter skru fast vinkelret på tagfladen
   - Top-eave: top-cut-pladen efterlades med åben corrugated kant (eller bøj en zink-flange som top-cap hvis ønsket)
8. Monter tagrende-beslag på bag-sternbrædet c/c 550 mm. Klik tagrende på, sæt endebund i hver ende
9. Monter nedløb: bladsamler ved tagrende-udgang → nedløbsbøjning → 3 m nedløbsrør → bøjning ved bunden → ud til faldsten/faskine

## Vigtigt om B7 installation

**Boring og skæring**: Bor- og skærestøv SKAL fjernes straks med en blød børste — hvis det ligger ude på pladen kan det "brænde" sig fast på overfladen. Brug vinkelsliber med diamant-skive ved skæring; bor med ø10 mm bor altid i bølgetop, aldrig i bølgedal.

**Trædesikkerhed**: B7 plader er IKKE trædesikre færdig-installeret. For vores rabbit-house gælder det IKKE — taget er ikke beregnet til at gå på efter installation.

**Skrue-pakning**: Swisspearl 100 Tagskruer har EPDM-pakning under hovedet — sørg for at den ikke deformeres ved overtilspænding. Skru kun til pakningen er let komprimeret (10-20 %).

**Garanti**: Swisspearl yder 20 års garanti på B7 plader når montagevejledning følges. Skæringer i sider/kanter skal være rene; ingen revner.

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/05_tagkonstruktion.png

# Eller direkte (skift roof_cover i build.scad til "eternit_14" først):
openscad -o b7.png src/main.scad
```
