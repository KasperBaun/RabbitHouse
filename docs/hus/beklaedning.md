# Beklædning — Hus

Beklædningen dækker hus-zonen (X = 0..2000). Eave er flad på alle 4 vægge
(RH_EH_FRONT = RH_EH_BACK = 2292 mm; gable-tag oven på giver fald).

| Nr | Område | Materiale | Funktion |
|---|---|---|---|
| B1 | Hus front (V1, X=0..2000, Y=0) | klink m. dør- + 2 vindue-cutouts + lag-stack | vejrbeklædning |
| B2 | Hus bag (V2, X=0..2000, Y=3000) | klink + vindpapir + afstandsliste | vejrbeklædning |
| B3 | Hus venstre (V3, X=0) | klink m. side-vindue-cutout + lag-stack | vejrbeklædning |
| B4 | Hus partition yard-side (V4, X=1548, hele Y=0..3000) | klink m. dør-cutouts + lag-stack | vejrbeklædning yard-side |
| B5 | 4 hjørnetrims | 45×45 lodret tømmer (klink) / 70×70 (bob) | dækker klink-end-grain |
| B6 | Indfatning om alle åbninger | 25×70 foring, står ~12 mm proud af klink | dækker klink-snit ved dør/vinduer |

## Lag-stack (snit gennem hus-væg, klink-variant)

```
        inde                                        ude
         │                                           │
         │    STUD 45×95           VINDPAPIR         │
         │    ┌────────────┐       │ AFSTANDSLISTE   │
         │    │            │       │ │  KLINK        │
         │    │            │██     │ │  ┌──┐         │
         │    │            │█      │ │  │  │░░░      │  ← klink-bræt
         │    │            │█      │ │  │  │░░       │    25 mm tykt
         │    │            │█      │ │  │  │░        │    125 mm højt
         │    │            │█      │ │  │  │░        │    25 mm overlap
         │    │            │█      │ │  └──┘         │    → step 100 mm
         │    └────────────┘       │ │     ░         │
         │                         │ └─    ░         │
         │   stud-yderside    1 mm 22 mm   25 mm     │
                              │     │       │
                              vindp. afstand klink
                              (membran) (klemmeliste 22×45 c/c 600)
```

## Mål

| Egenskab | Værdi |
|---|---|
| Hus-footprint | 2000 × 3000 mm |
| Eave-højde (flad, alle 4 vægge) | RH_EH_FRONT = RH_EH_BACK = 2292 mm |
| Sokkel-top (cladding bund) | Z = RH_BASE_H = 120 mm |
| Vindpapir tykkelse | 1 mm (membran) |
| Afstandsliste | 22 × 45 mm, lodret c/c 600 mm |
| Klink (RH_CLAD) | board_h=125, overlap=25, thick=25, lip=20 mm |
| Klink-step (synlig højde pr. række) | 125 − 25 = **100 mm** |
| Hjørnetrim klink | 45 × 45 mm lodret |
| Hjørnetrim bob | 70 × 70 mm lodret |

## Konstruktion

Vindpapir spændes på
stud-ydersiden over hele væggen, fra bundrem-top op til toprem-bund.
Stiftes med klamper c/c 200.

Afstandsliste (klemmeliste) 22 × 45 mm sættes lodret c/c 600 mm —
matcher stud-c2c så hver liste sidder direkte oven over en stud. Den
klemmer vindpapiret fast og skaber et 22 mm ventileret hulrum bag klink.

Klink-brædder 25 × 125 mm sømmes på afstandslisten. Hvert bræt overlapper
det forrige med 25 mm, så regnvand løber ned forbi samlingen uden at
trænge ind. Synlig højde pr. række = 125 − 25 = 100 mm.

Hjørnetrim 45 × 45 mm lodret tømmer sættes ved hver af de 4 hus-hjørner
— overlapper begge klink-flader så raw end-grain er dækket. Alle 4 trims
går til den flade eave (2292 mm).

Indfatning (foring) 25 × 70 mm sættes rundt om hver åbning — dør + 2
vinduer på V1, side-vindue på V3, hus-dør + pet-dør på V4. Klinken skæres
ud ~8 mm bredere end selve åbningen, og indfatningen dækker det snit: den
står ~12 mm proud af klink-fladen og lapper ~10 mm ind over åbningen, så
der ikke ses rå klink-snit i lysningen. Dør-blade (V1 + V4) flugter med
klink-fladen, så indfatningen sidder direkte an mod bladet uden dyb lysning.

Partition-væggen (V4) klædes i fuld bredde (Y = 0..3000) kun på YARD-siden
(X ≈ 1548). Hus-siden af partition-væggen står ubeklædt — kaninerne kan
ikke gnave isolering når der ingen adgang er til væg-cavity'et.

## Skæreliste — klink

Vægareal og rækker pr. væg (alle 4 hus-vægge):

| Væg | L × H (flad) | Areal brutto | Åbnings-fradrag | Rækker (H÷100) | Lin.m bræt |
|---|---|---|---|---|---|
| Front V1 | 2000 × 2292 | 4,58 m² | − dør 0,9×2,0 − 2 vind. 2×0,19 | 23 | 46 m |
| Bag V2 | 2000 × 2292 | 4,58 m² | — | 23 | 46 m |
| Venstre V3 | 3000 × 2292 | 6,88 m² | − vindue 0,7×0,6 | 23 | 69 m |
| Partition V4 | 3000 × 2292 | 6,88 m² | − hus-dør 0,87×2,0 − petdør 0,25×0,3 | 23 | 69 m |
| **Total** | | **22,9 m² brutto (~20,7 netto)** | | | **230 m** |

**Smart-cut strategi for 4200 mm brædder:**

Hvert 4200 mm bræt skæres til **én 3000 mm række** (V3/V4, 1200 mm scrap)
ELLER **to 2000 mm rækker** (V1/V2, 200 mm scrap).

| Behov | Antal rækker | Brædder |
|---|---|---|
| 3000 mm rækker (V3 + V4) | 46 | 46 (1 række pr. bræt) |
| 2000 mm rækker (V1 + V2) | 46 | 23 (2 rækker pr. bræt) |

→ **69 brædder** + 5 % safety for snit ved åbninger = **73 stk** anbefalet.

## Materialeliste (klink-variant)

Vindpapir-areal (uden fradrag for åbninger; cuttes efter): V1+V2+V3+V4 =
4,58 + 4,58 + 6,88 + 6,88 = **22,9 m²** → en 1,5 × 25 m rulle (37,5 m²)
rækker; 1,5 × 50 m er standardlager med god buffer.

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Vindpapir Tyvek HouseWrap | 1,5 m × 25/50 m rulle, hus-vægge ~22,9 m² | 1 | rulle |
| 2 | Afstandsliste 22 × 45 × 2400 mm | Lodret klemmeliste c/c 600. V1+V2: 4+4 = 8 stk; V3+V4: 6+6 = 12 stk | 20 | stk |
| 3 | Klink-brædder 25 × 125 × 4200 mm (gran/lærk) | Hus-vægge 230 lin.m. Smart cut 3000 \| 2×2000 → 69 stk + 5 % safety | 73 | stk |
| 4 | Hjørnetrim 45 × 45 × 2400 mm | 4 hjørner, klink-end-grain dækning (flad eave 2292) | 4 | stk |
| 5 | Indfatning/foring 25 × 70 × 2400 mm | Om åbninger: V1 dør + 2 vinduer, V3 vindue, V4 hus-dør + pet-dør (~17,5 lin.m) | 8 | stk |
| 6 | Klamper 25 mm | Stifter til vindpapir, c/c 200 | 1 | pak |
| 7 | Klink-søm 50 mm rustfri | ~4 søm pr. bræt × 230 lin.m / 1,5 m bræt-snit ≈ 600 stk | 1 | pak |
| 8 | Skruer 4 × 60 mm | Afstandsliste + indfatning | 1 | pak |

## Materialeliste — board-on-board alternativ (1-på-2)

Hvis `cladding_type = "board_on_board"` i `src/main.scad`:

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Vindpapir Tyvek HouseWrap | Som klink-variant | 1 | rulle |
| 2 | Afstandsliste 22 × 45 × 4200 mm | **Vandret** klemmeliste c/c 600 (brædder står lodret) | ~20 | stk |
| 3 | Savskåret gran 25 × 150 × 4200 mm | Bagbrædder + forbrædder, c/c 250 → ca. 10 m vægbredde × 2 stk/c2c | ~80 | stk |
| 4 | Hjørnetrim 70 × 70 × 2400 mm | 4 hjørner (større trim pga. 50 mm udstik) | 4 | stk |
| 5+ | Klamper, søm, skruer | Som klink-variant | | |

## Bygge-rækkefølge

1. Spænd vindpapir på stud-ydersiden af alle 4 hus-vægge (V1, V2, V3, V4-yard-side); stift c/c 200, overlap 100 mm i samlinger
2. Cut åbninger ud i vindpapir ved dør + 2 vinduer (V1), side-vindue (V3), hus-dør + petdør (V4)
3. Sæt afstandsliste 22 × 45 lodret c/c 600 — ovenpå hver stud, gennem vindpapir, skruet ind i stud
4. Skær klink-brædder pr. skærelisten ovenfor (smart cut: én 3000 mm række eller to 2000 mm rækker pr. bræt)
5. Søm klink-brædder vandret på afstandslisten, nederst først, hver overlapper det underliggende med 25 mm. Flad overkant på alle 4 vægge (2292 mm) — gable-spær sидder ovenpå
6. Skær klinken ~8 mm bredere end hver åbning (rå snit skjules af indfatningen)
7. Sæt indfatning 25 × 70 rundt om hver åbning — dækker klink-snittet, står ~12 mm proud, lapper ~10 mm ind over åbningen
8. Sæt 4 hjørnetrim-stykker (45×45) ved hus-hjørnerne — overlapper begge klink-flader

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
```

Inspect:
- Klink-stack ligger UDEN PÅ studsene (ikke embedded i)
- Hjørnetrims dækker klink-end-grain ved alle 4 hus-hjørner
- Indfatning dækker klink-snittet rundt om alle åbninger; dør-blade flugter med klink-fladen (ingen dyb lysning)
- 23 klink-rækker på alle 4 vægge (flad eave 2292 mm)
- Partition-væggen klædt kun på YARD-siden (X = 1547.5)
