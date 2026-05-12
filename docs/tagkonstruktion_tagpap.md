# Tagkonstruktion — Tagpap (OSB + selvbyggerpap) variant

> Implementeret i `src/designs/v3/tagkonstruktion_tagpap.scad`
> Vælges med `roof_cover = "tagpap_osb"` (eller `"tagpap"`) i `src/designs/v3/build.scad`.
> Fælles framing/sofitt-moduler i `tagkonstruktion_faelles.scad`.

Ensidet tagflade dækket med **Phønix Selvbyggerpap (2-lags)** svejset på 18 mm OSB-3 TG4 plader. Tagpap kører på v3's default-hældning (4,6° / 8 % fald) — minimum-hældning for tagpap er 2,5 % = 1,4°, så vi er rigeligt indenfor spec. Sternbræt-toppen afsluttes med **aluinddækning (sternkapsler)** på alle 4 eaves.

## Lag (oppefra og ned)

1. **Aluinddækning / sternkapsler** 35×25 mm — på alle 4 eaves
2. **Phønix Selvbyggerpap overpap** (svejset til underpap)
3. **Phønix Selvbyggerpap underpap** (mekanisk fastgjort til OSB)
4. **OSB-3 TG4** 18 mm — bærer hele coveret, sømmes på spær
5. **Spær** 47×100 C24 c/c 600 mm
6. **Sternbræt** 25×125 + tagrende på bag-eaven

```
        ╔═══════════════════════════════════╗  ← aluinddækning (sternkapsler)
        ║ Phønix overpap (svejset)          ║  ← 4 mm
        ║ Phønix underpap                   ║  ← 3 mm
        ║ OSB-3 TG4 18 mm                   ║  ← 18 mm
        ╠═══════════════════════════════════╣  ← spær-top
        │  spær 47×100 c/c 600 mm           │
        │                                   │
        ├──── V1/V2 toprem ─────────────────┤   ← wall-top
                                                (lag-stak set fra siden)

Tagpap rulles ud parallelt med tagfaldet, overlap 100 mm langs eave, 80 mm
mellem ruller. Sternkapsler glider ned over sternbræt-top + oprullet tagpap-kant.
```

## Mål

| Egenskab            | Værdi                                                          |
| ------------------- | -------------------------------------------------------------- |
| Tagflade            | 6,44 × 2,95 m (~19 m² incl. overhangs)                         |
| Hældning            | 4,6° (`roof_cover = "tagpap_osb"`)                             |
| Spær                | 13 stk 47×100 C24 c/c 600 (11 regulære + 2 vindskede)          |
| Overhæng            | 220 mm front + 180 mm bag + 220 mm i hver side                 |
| OSB-bærelag         | ~7-8 plader 1220×2440 mm (skæres til pasning)                  |
| Tagpap              | 2 lag (underpap + overpap) × ~19 m² ≈ 4 ruller à 10 m²         |
| Aluinddækning       | ~19 m langs perimeteren (alle 4 eaves)                         |
| Lag over spær       | ~25 mm (18 OSB + 3 underpap + 4 overpap)                       |

## Konstruktion

**Spær** 47×100 C24 skæres til ~2910 mm med fugleudskæring ved hver ende (samme som eternit-varianten — se [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md)). 11 spær c/c 600 fra X=0 til X=5955; vindskede-spær ved X=-220 og X=6175 hviler på den forlængede V1+V2 toprem. Hvert regulært spær fastgøres med 2 vinkelbeslag pr. bæreflade; vindskede-spær får 1 på indersiden.

**OSB-3 TG4 18 mm** lægges direkte på spær-toppen med TG4-noter mod nabopladens. Plader skæres til pasning ved barge-spærene (~220 mm overhang på hver side). OSB sømmes på spær med varmforzinkede 3,1×80 søm c/c ~150 mm langs spær-linjen. OSB-pladen fungerer både som bærelag for tagpap OG som diaphragm der overfører kantilever-moment fra side-overhangene tilbage til de bærende spær — derfor er OSB-tykkelsen vigtig.

**Phønix Selvbyggerpap** rulles ud parallelt med tagfaldet (= med længdeaksen langs X). Underpap fastgøres mekanisk til OSB med tagpapsøm c/c ~250 mm. Overpap svejses eller limes med TagSealer til underpap med 100 mm langs-overlap og 80 mm mellem ruller. Yderkant rulles 50 mm op ad sternbrættet og fastgøres med tagpapsøm; sternkapslen glider derefter ned over toppen som beskyttelse.

**Sternbræt** 25×125 langs hele perimeteren skrues fast i spær-enderne. Sternbræt-toppen sidder ~7 mm over tagpap-toppen (= cover_thick + STERN_LIP) så aluinddækningen får et lille kant at gribe om.

**Aluinddækning / sternkapsler** 35×25 mm cap-profil glides ned over sternbræt-top + den oprullede tagpap-kant. Topflange 25 mm dækker sternbræt-top; outer drop 35 mm hænger ned udvendigt forbi sternbræt-front-fladen. Skrues fast med små tag-papskruer c/c ~400 mm i topflangen.

**Tagrende** 110 mm monteres på back-sternbrættets yder-flade med beslag c/c ~550 mm. Tagpap-kanten ved bag-eaven hænger fri ud over tagrende-midtlinjen for korrekt drip. Nedløb Ø75 i højre side leder vandet til faldsten eller faskine.

## Materialeliste

Stykkevis skæreliste: [tagkonstruktion-skaereliste.md](tagkonstruktion-skaereliste.md).

| #   | Vare                                       | Beskrivelse                                          | Antal | Enhed | Pris/enh | I alt    | Note |
| --- | ------------------------------------------ | ---------------------------------------------------- | ----- | ----- | -------- | -------- | ---- |
|     | **Træværk**                                |                                                      |       |       |          |          |      |
| 1   | RAW Spærtræ C24 47×100×3000 mm gran        | Spær — 11 regulære + 2 vindskede                     | 13    | stk   | ~85,00   | ~1.105   | est. (Stark) |
| 2   | Imp. stern 25×125×3600 mm gran             | Sternbræt — hele perimeter (~19 m)                   | 6     | stk   | 82,60    | 495,72   | [xl-byg.dk](https://www.xl-byg.dk/produkt/xl-byg-ru-sternbraet-over-trykimpraegneret-25-x-125-x-3600-mm-1143025122-0360) |
|     | **Cover (OSB + tagpap)**                   |                                                      |       |       |          |          |      |
| 3   | OSB-3 TG4 18 mm 1220×2440 mm               | Bærelag — 19 m² / 2,98 m²/plade + spild ≈ 8 plader  | 8     | stk   | ~225     | ~1.800   | est. |
| 4   | Phønix Selvbyggerpap rulle (~10 m²)        | 2 lag (underpap + overpap) × 19 m² + spild = 4 ruller | 4     | rulle | ~600     | ~2.400   | est. |
| 5   | Phønix TagSealer tube                      | Lim/svejs ved overlap-samlinger                      | 3     | stk   | ~150     | ~450     | est. |
|     | **Aluinddækning / sternkapsler**           |                                                      |       |       |          |          |      |
| 6   | Alu sternkapsel 35×25 mm (2-3 m lgd.)      | Hele perimeteren (~19 m) — alle 4 eaves              | 19    | m     | ~120     | ~2.280   | est. |
| 7   | Tag-papskrue m. EPDM (100-pak)             | Fastgør alu-cap c/c 400 mm                          | 1     | pak   | ~120     | ~120     | est. |
|     | **Vandhåndtering**                         |                                                      |       |       |          |          |      |
| 8   | Tagrende 110 mm stål/plast (sæt 6,5 m)     | Bag-eave inkl. tilbehør                              | 1     | sæt   | ~600     | ~600     | est. |
| 9   | Tagrende-beslag                            | c/c 550 mm langs bag-eave                            | 12    | stk   | ~30      | ~360     | est. |
| 10  | Endebund tagrende 110 mm                   | Lukker tagrendens to ender                           | 2     | stk   | ~50      | ~100     | est. |
| 11  | Bladsamler 75-82 mm                        | Filter ved nedløbsudgang                             | 1     | stk   | ~80      | ~80      | est. |
| 12  | Nedløbsrør Ø75 mm × 3 m                    | Fra tagrende ned til faldsten                        | 1     | stk   | ~200     | ~200     | est. |
| 13  | Nedløbsbøjning Ø75 mm                      | Knæ-stykker (top + bund)                             | 2     | stk   | ~80      | ~160     | est. |
|     | **Beslag og fastgørelse**                  |                                                      |       |       |          |          |      |
| 14  | Paslode vinkelbeslag 90×90×40 mm (20-pak)  | 48 nødvendige → 3 pak (60 stk)                       | 3     | pak   | ~150     | ~450     | est. ([wood-online](https://wood-online.dk/shop/paslode-vinkelbeslag-542p.html) enkelt-pris 8,48 kr) |
| 15  | NKT Basic skrue 5×80 ruspert (250-pak)     | Vinkelbeslag + sternbræt                             | 1     | pak   | ~225     | ~225     | est. ([bygxtra](https://www.bygxtra.dk/produkter/nkt-basic-skrue-outdoor-50x8045-mm-ruspert-1000-250-stk-1673216)) |
| 16  | Tagpapsøm 25 mm varmforzinket (1 kg ≈ 400 stk) | Underpap + 50 mm op ad sternbræt                 | 1     | æske  | ~80      | ~80      | est. |
|     |                                            |                                                      |       |       | **Total** | **~10.905** | (≈12.000 inkl. realistisk spild + sofitt-kryds.) |

## Bygge-rækkefølge

1. Skær 11 regulære + 2 vindskede spær til ~2910 mm; indsav fugleudskæring ved hver ende
2. Læg spær c/c 600 mm: regulære på V1+V2 toprem, vindskede på toprem-forlængelsen ved X=-220 og X=6175
3. Skru fast med vinkelbeslag — 2 pr. bæreflade på regulære, 1 på indersiden af vindskede
4. Læg OSB-3 TG4 plader på spær-toppen med TG4-noter mod hinanden. Søm fast med 3,1×80 varmforzinket c/c ~150 mm langs spær-linjen
5. Skær OSB til pasning ved barge-spærene (~220 mm side-overhang i hver side)
6. Monter sternbrædder 25×125 rundt om hele perimeteren. **Sternbræt-toppen sidder ~7 mm over OSB-tagpap-toppen** (cover_thick + STERN_LIP)
7. Rul Phønix Selvbyggerpap **underpap** ud parallelt med tagfaldet. Fastgør mekanisk med tagpapsøm c/c ~250 mm. Rul kanten 50 mm op ad sternbrættet i alle 4 sider
8. Rul Phønix Selvbyggerpap **overpap** ud. Svejs eller lim med TagSealer til underpap. Overlap 100 mm langs / 80 mm mellem ruller
9. Monter alu-sternkapsler ovenpå sternbræt-top + oprullet tagpap-kant. Skrues fast med tag-papskrue c/c 400 mm
10. Monter tagrende-beslag på bag-sternbrædet c/c 550 mm. Klik tagrende på, sæt endebund i hver ende
11. Monter nedløb: bladsamler ved tagrende-udgang → nedløbsbøjning → 3 m nedløbsrør → bøjning ved bunden → ud til faldsten/faskine

## Vigtigt om tagpap-installation

**Underlag**: OSB-pladerne SKAL være tørre før tagpap lægges på. Fugt-indhold > 18 % → tagpappen bobler op.

**Svejsning vs. lim**: Phønix Selvbyggerpap kan både svejses (med propan-brænder) eller limes (med TagSealer). For hobby-byg er lim simplere og sikrere — der er ingen åben ild, og du kan lægge pappen alene uden hjælper.

**Sternkapsel-orientering**: Topflange skal pege INDAD (mod tagcenter), drop-flange UDAD. Forkert orientering = vand løber under kapslen.

**Garanti**: Phønix yder 10 års garanti på Selvbyggerpap når montagevejledningen følges — herunder mindst 2,5 % fald (vi har 8 %), korrekt overlap, og fastgørelse iht. spec.

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/05_tagkonstruktion.png

# Eller direkte (skift roof_cover i build.scad til "tagpap_osb"):
openscad -o tagpap.png src/main.scad
```
