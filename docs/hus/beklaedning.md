# Beklædning — Hus

Beklædningen dækker hus-zonen (X = 0..1500).

| Nr | Område | Materiale | Funktion |
|---|---|---|---|
| B1 | Hus front (V1, X=0..1500, Y=0) | klink + vindpapir + afstandsliste | vejrbeklædning HIGH |
| B2 | Hus bag (V2, X=0..1500, Y=2500) | klink + vindpapir + afstandsliste | vejrbeklædning LOW |
| B3 | Hus venstre (V3, X=0) | klink m. side-vindue-cutout + lag-stack | vejrbeklædning skrå |
| B4 | Hus partition yard-side (V4, X=1547.5) | klink m. dør-cutouts + lag-stack | vejrbeklædning skrå yard-side |
| B5 | 4 hjørnetrims | 45×45 lodret tømmer (klink) / 70×70 (bob) | dækker klink-end-grain |

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
| Hus-footprint | 1500 × 2500 mm |
| Eave-højde front (V1) | RH_EH_FRONT = 2400 mm |
| Eave-højde bag (V2) | RH_EH_BACK = 2200 mm |
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
— overlapper begge klink-flader så raw end-grain er dækket. Foran-trim
går til front-eave (2400 mm), bag-trim til bag-eave (2200 mm).

Partition-væggen klædes kun på YARD-siden (X = 1500 + 95/2 = 1547.5).
Hus-siden af partition-væggen står ubeklædt — kaninerne kan ikke gnave
isolering når der ingen adgang er til væg-cavity'et.

## Skæreliste — klink

Vægareal og rækker pr. væg (alle 4 hus-vægge):

| Væg | L × H | Areal | Rækker (H÷100) | Lin.m bræt |
|---|---|---|---|---|
| Front V1 (flad HIGH) | 1500 × 2400 | 3,60 m² | 24 | 36 m |
| Bag V2 (flad LOW) | 1500 × 2200 | 3,30 m² | 22 | 33 m |
| Venstre V3 (skrå, max) | 2500 × 2400 | 5,33 m² (− vindue 700×600) | 24 | 60 m |
| Partition V4 (skrå, max) | 2500 × 2400 | 3,89 m² (− dør 870×2050 − petdør 250×300) | 24 | 60 m |
| **Total** | | **16,12 m²** | | **189 m** |

**Smart-cut strategi for 4200 mm brædder:**

Hvert 4200 mm bræt skæres optimalt til **1× 2500 + 1× 1500 + 200 mm scrap**
= 1 række på V3 eller V4 (2500 mm) + 1 række på V1 eller V2 (1500 mm) pr. bræt.

| Behov | Antal rækker | Skæres fra | Brædder |
|---|---|---|---|
| 2500 mm rækker (V3 + V4) | 48 | 48 brædder × 2500 mm | 48 |
| 1500 mm rækker (V1 + V2) | 46 | samme 48 brædder × 1500 mm | (gratis) |

→ **48 brædder min.** + 5 % safety for snit ved åbninger og skrå-cut
= **50 stk** anbefalet.

## Materialeliste (klink-variant)

Vindpapir-areal (uden fradrag for åbninger; cuttes efter): V1+V2+V3+V4 =
3,6 + 3,3 + 5,75 + 5,75 = **18,4 m²** → en 1,5 × 50 m rulle (75 m²) er
voldsom overdaekning, men er standardlager. Alternativ: 1,5 × 25 m rulle
(37,5 m²) hvis den fås.

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Vindpapir Tyvek HouseWrap | 1,5 m × 50 m rulle, hus-vægge ~18,4 m² (1 rulle giver overlap-buffer) | 1 | rulle |
| 2 | Afstandsliste 22 × 45 × 2400 mm | Lodret klemmeliste c/c 600. V1+V2: 3+3 = 6 stk; V3+V4: 5+5 = 10 stk (skrå, kortes ned) | 16 | stk |
| 3 | Klink-brædder 25 × 125 × 4200 mm (gran/lærk) | Hus-vægge 16,12 m². Smart cut: 2500+1500+200 scrap pr. bræt → 48 stk + 5 % safety | 50 | stk |
| 4 | Hjørnetrim 45 × 45 × 2400 mm | 4 hjørner, klink-end-grain dækning (front-trim 2400, bag-trim kortes til 2200) | 4 | stk |
| 5 | Klamper 25 mm | Stifter til vindpapir, c/c 200 | 1 | pak |
| 6 | Klink-søm 50 mm rustfri | ~4 søm pr. bræt × 189 lin.m / 1,5 m bræt-snit ≈ 500 stk | 1 | pak |
| 7 | Skruer 4 × 60 mm | Afstandsliste i hver stud-overlap | 1 | pak |

## Materialeliste — board-on-board alternativ (1-på-2)

Hvis `cladding_type = "board_on_board"` i `src/main.scad`:

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Vindpapir Tyvek HouseWrap | Som klink-variant | 1 | rulle |
| 2 | Afstandsliste 22 × 45 × 4200 mm | **Vandret** klemmeliste c/c 600 (brædder står lodret) | ~16 | stk |
| 3 | Savskåret gran 25 × 150 × 4200 mm | Bagbrædder + forbrædder, c/c 250 → ca. 14 m vægbredde × 2 stk/c2c | ~70 | stk |
| 4 | Hjørnetrim 70 × 70 × 2400 mm | 4 hjørner (større trim pga. 50 mm udstik) | 4 | stk |
| 5+ | Klamper, søm, skruer | Som klink-variant | | |

## Bygge-rækkefølge

1. Spænd vindpapir på stud-ydersiden af alle 4 hus-vægge (V1, V2, V3, V4-yard-side); stift c/c 200, overlap 100 mm i samlinger
2. Cut åbninger ud i vindpapir ved side-vindue (V3) + hus-dør (V4) + petdør (V4)
3. Sæt afstandsliste 22 × 45 lodret c/c 600 — ovenpå hver stud, gennem vindpapir, skruet ind i stud
4. Skær klink-brædder pr. skærelisten ovenfor (smart cut: 2500 + 1500 + 200 scrap pr. bræt)
5. Søm klink-brædder vandret på afstandslisten, nederst først, hver overlapper det underliggende med 25 mm. Skrå-cut overkanten på V3 + V4 så top følger toprem-skrå
6. Skær klink rundt om karme på Å1 (hus-dør), Å2 (petdør) og Å3 (side-vindue) — klink butter direkte mod karm-yder
7. Sæt 4 hjørnetrim-stykker (45×45) ved hus-hjørnerne — overlapper begge klink-flader

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
```

Inspect:
- Klink-stack ligger UDEN PÅ studsene (ikke embedded i)
- Hjørnetrims dækker klink-end-grain ved alle 4 hus-hjørner
- Klink butter direkte mod dør-karm på Å1 og petdør Å2 (ingen arkitrav-liste)
- 24 klink-rækker på front (2400 mm), 22 på bag (2200 mm), skrå på V3 + V4
- Partition-væggen klædt kun på YARD-siden (X = 1547.5)
