# Beklædning

> Implementeret i `src/designs/v3/beklaedning.scad`.

Beklædningen dækker både hus-væggene (klink-brædder + vindpapir +
afstandsliste + hjørnetrim) og yard-perimeteret (voliernet på reglar-
ydersiden). Klink-laget bygges UDEN PÅ stud-fladen i en lag-stack der
giver luft bag brædderne — typisk dansk præstebrik-ventileret klink.

| Nr | Område | Materiale | Funktion |
|---|---|---|---|
| B1 | Hus front (V1, X=0..hl, Y=0) | klink + vindpapir + afstandsliste | vejrbeklædning |
| B2 | Hus bag (V2, X=0..hl, Y=ww) | klink + vindpapir + afstandsliste | vejrbeklædning |
| B3 | Hus venstre (V3, X=0) | klink m. side-vindue-cutout + lag-stack | vejrbeklædning |
| B4 | Hus partition yard-side (V4, X=hl+47.5) | klink m. dør-cutouts + lag-stack | vejrbeklædning yard-side |
| B5 | 4 hjørnetrims | 45×45 lodret tømmer | dækker klink-end-grain ved hjørner |
| B6 | Yard front (X=hl..ll, Y=0) | voliernet i 2 bånd om døren | rovdyrsikring |
| B7 | Yard bag (X=hl..ll, Y=ww) | voliernet, 1 bane | rovdyrsikring + ventilation |
| B8 | Yard højre (X=ll, Y=0..ww) | voliernet, skrå top | rovdyrsikring |

## Lag-stack (snit gennem hus-væg)

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

Total cladding-stack udadgående fra stud-flade =  
`V3_VP_T (1) + V3_AL_T (22) + cs_thick(V3_CLAD) (25)` = **48 mm**.

## Mål

| Egenskab | Værdi |
|---|---|
| Vindpapir tykkelse | 1 mm (membran) |
| Afstandsliste | 22 × 45 mm, lodret c/c 600 mm |
| Klink (V3_CLAD) | board_h=125 mm, overlap=25 mm, thick=25 mm, lip=20 mm |
| Klink-step (synlig højde pr. række) | 125 − 25 = **100 mm** |
| Hjørnetrim | 45 × 45 mm lodret |
| Voliernet | ½″ × 1″ ≈ 13 × 25 mm aperture, 1,2 mm tråd (V3_MESH_*) |

## Konstruktion

### Hus-vægge (B1–B5)

Vindpapir (eks. Tyvek HouseWrap eller Pro Clima Solitex) spændes på
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
går til front-eave (V3_EH_FRONT = 2400 mm), bag-trim til bag-eave
(V3_EH_BACK = 2200 mm).

Partition-væggen klædes kun på YARD-siden (X = hl + V3_POST_W/2 = hl+47.5).
Hus-siden af partition-væggen står ubeklædt — kaninerne kan ikke gnave
isolering når der ingen adgang er til væg-cavity'et.

### Voliernet (B6–B8)

Voliernet ½″ × 1″ med 1,2 mm tråd spændes direkte på reglar-ydersiden
i yard-perimeteret. Der er INGEN træramme bag nettet — reglar (45×95
c/c 600) er rammen. Stiftes med 25 mm krampler c/c 100 langs alle reglar.

Yard-front (B6) bygges i to bånd, ét på hver side af yard-døren —
døren har sit eget mesh-i-træramme leaf (Å1) der dækker den 1070 mm
brede åbning.

Yard-bag (B7) er én sammenhængende bane fra X=hl til X=ll, flad LOW-
højde — V3_EH_BACK - PLATE_H = 2155 mm.

Yard-højre (B8) har skrå top der følger toprem fra HIGH (Y=0,
z=2475) til LOW (Y=ww, z=2275) — modelleres med
`voliere_y_sloped(...)` der intersector et rektangulært net mod en
sloped wedge.

Voliernet stopper ved underkanten af toprem. Trekantede åbninger over
toprem (mellem spær) lukkes af tagkonstruktion-systemet (sternbrædder
og evt. vindbrædter på spær-undersiden — se `tagkonstruktion.md`).

### Køb af voliernet

½″ × 1″ × 1,2 mm tråd, ca. 1350 kr i alt:
- 1 rulle 25 m × 1 m højde (~950 kr) — front + bag-banen
- 1 rulle 10 m × 1 m højde (~400 kr) — højre væg + buffer

Højde 1 m er for lavt til den fulde væg-højde (~2,3 m), så nettet
overlappes 50 mm horisontalt med en ekstra bane på toppen — eller en
højere rulle (1,2 m / 1,5 m) købes hvis der er rabat.

## Skæreliste — klink

Vægareal og rækker pr. væg:

| Væg | L × H | Areal | Rækker (H÷100) | Lin.m bræt |
|---|---|---|---|---|
| Front V1 (flad HIGH) | 1500 × 2400 | 3,60 m² | 24 | 36 m |
| Bag V2 (flad LOW) | 1500 × 2200 | 3,30 m² | 22 | 33 m |
| Venstre V3 (skrå, max) | 2500 × 2400 | 5,33 m² (− vindue) | 24 | 60 m |
| Partition V4 (skrå, max) | 2500 × 2400 | 3,89 m² (− døre) | 24 | 60 m |
| **Total** | | **16,1 m²** | | **189 m** |

**Smart-cut strategi for 4200 mm brædder:**

Hvert 4200 mm bræt skæres optimalt til **1× 2500 + 1× 1500 + 200 mm scrap** = 1 række på V3 eller V4 (2500 mm) + 1 række på front eller bag (1500 mm) per bræt.

| Behov | Antal rækker | Skæres fra | Brædder |
|---|---|---|---|
| 2500 mm rækker (V3 + V4) | 48 | 48 brædder × 2500 mm | 48 |
| 1500 mm rækker (front + bag) | 46 | samme 48 brædder × 1500 mm | (gratis) |

→ **48 brædder min.** + 5 % safety for snit ved åbninger og skrå-cut = **50 stk** anbefalet.

## Materialeliste

| # | Vare | Beskrivelse | Antal | Enhed | Pris/enh | I alt |
|---|---|---|---|---|---|---|
| 1 | Vindpapir Tyvek HouseWrap | 1,5 m × 50 m rulle, hus-vægge ~17,5 m² | 1 | rulle | | |
| 2 | Afstandsliste 22 × 45 × 2400 mm | Lodret klemmeliste c/c 600 — 3+3+5+5 stk på de 4 hus-vægge | 16 | stk | | |
| 3 | Klink-brædder 25 × 125 × 4200 mm (gran/lærk) | Hus-vægge 16,1 m². Smart cut: 2500+1500+200 scrap pr. bræt → 48 stk + 5 % safety | 50 | stk | | |
| 4 | Hjørnetrim 45 × 45 × 2400 mm | 4 hjørner, klink-end-grain dækning | 4 | stk | | |
| 5 | Voliernet ½″ × 1″ × 1,2 mm 25 m × 1 m | Yard-front+bag perimeter | 1 | rulle | ~950 | ~950 |
| 6 | Voliernet ½″ × 1″ × 1,2 mm 10 m × 1 m | Yard-højre + buffer | 1 | rulle | ~400 | ~400 |
| 7 | Klamper 25 mm | Stifter til vindpapir + voliernet | 1 | pak | | |
| 8 | Klink-søm 50 mm rustfri | Søm til klink-brædder, ~4 pr. bræt | 1 | pak | | |
| 9 | Skruer 4 × 60 til afstandsliste | I hver liste-stud-overlap | 1 | pak | | |
| | | | | | **Total** | **~kr.** |

## Bygge-rækkefølge

1. Spænd vindpapir på stud-ydersiden af hus-vægge (front, bag, venstre, partition yard-side); stift c/c 200, overlap 100 mm i samlinger
2. Sæt afstandsliste 22 × 45 lodret c/c 600 — ovenpå hver stud, gennem vindpapir, skruet ind i stud
3. Skær klink-brædder pr. skærelisten ovenfor (smart cut: 2500 + 1500 + 200 scrap pr. bræt)
4. Søm klink-brædder vandret på afstandslisten, nederst først, hver overlapper det underliggende med 25 mm
5. Sæt 4 hjørnetrim-stykker (45×45) ved hus-hjørnerne — overlapper begge klink-flader
6. Spænd voliernet på yard-perimeteret (front 2 bånd om døren, bag 1 bane, højre m. skrå top); stift c/c 100 langs alle reglar
7. Skær klink rundt om dør-karme på Å1 og Å2 — klink butter direkte mod karm-yder

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/06_beklaedning.png
```

Inspect:
- Klink-stack ligger UDEN PÅ studsene (ikke embedded i)
- Voliernet sidder på yard-perimeteret, ikke på hus-væggene
- Hjørnetrims dækker klink-end-grain ved alle 4 hus-hjørner
- Klink butter direkte mod dør-karm på Å1 og Å2 (ingen arkitrav-liste)
- 24 klink-rækker på front (2400 mm), 22 på bag (2200 mm), skrå på venstre + partition
