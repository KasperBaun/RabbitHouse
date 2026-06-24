# Beklædning — Løbegård

> Implementeret i `src/designs/yard/mesh.scad`.

Løbegården (X = 1500..6000) klædes med voliernet på 3 sider.  
Nettet sidder direkte på reglar-ydersiden. reglar (45×95 c/c 600) er rammen.

| Nr | Område | Materiale | Funktion |
|---|---|---|---|
| B6 | Yard front (V1[hl..ll], Y=0) | voliernet i 2 bånd om døren | rovdyrsikring HIGH |
| B7 | Yard bag (V2[hl..ll], Y=2500) | voliernet, 1 bane | rovdyrsikring + ventilation LOW |
| B8 | Yard højre (V5, X=6000) | voliernet, skrå top (HIGH → LOW) | rovdyrsikring skrå |

## Mål

Yard-vægge har sin EGEN (lavere) eave-højde — adskilt fra hus-væggene:

| Egenskab | Værdi |
|---|---|
| Yard-footprint | 4500 × 2500 mm (X = 1500..6000) |
| Eave-højde front | RH_YARD_EH_FRONT = **2100 mm** |
| Eave-højde bag | RH_YARD_EH_BACK = **1800 mm** |
| Sokkel-top (Z_BASE_H) | 120 mm |
| Sill-plate top (RH_YARD_SILL_TOP) | 167 mm (= 120 + 2 DPC + 45 sill) |
| Toprem bund front | 120 + 2100 − 45 = **2175 mm** |
| Toprem bund bag | 120 + 1800 − 45 = **1875 mm** |
| Mesh-højde front (h_front) | 2175 − 167 = **2008 mm** |
| Mesh-højde bag (h_back) | 1875 − 167 = **1708 mm** |
| Voliernet (RH_MESH) | ½″ × 1″ ≈ 13 × 25 mm aperture, 1 mm tråd (gauge 19 GAW) |
| Yard-dør (Å4) | RH_YARD_DOOR_W = 1070, RH_YARD_DOOR_H = 1950, RH_YARD_DOOR_X = 3000 |

Mesh-planet ligger 1 mm uden for stud-fladen (OUT-offset i `mesh.scad`).

## Konstruktion

Voliernet ½″ × 1″ med 1 mm tråd spændes direkte på reglar-ydersiden i
yard-perimeteret. Der er INGEN træramme bag nettet — yard-reglar (45×95
c/c 600) er rammen. Stiftes med 25 mm krampler c/c 100 langs alle reglar.

Voliernet stopper ved underkanten af toprem. Trekantede åbninger over
toprem (mellem yard-spær) lukkes af tagkonstruktion-systemet — se
[tagkonstruktion.md](../tagkonstruktion.md).

### B6 — Yard front

To bånd, ét på hver side af yard-døren — døren har sit eget mesh-i-træramme
leaf (Å4) der dækker den 1070 mm brede åbning.

- Venstre bånd: X = 1500..3000 (1500 mm bredt), H = 2008 mm
- Højre bånd: X = 4070..6000 (1930 mm bredt), H = 2008 mm

### B7 — Yard bag

Én sammenhængende bane fra X=1500 til X=6000 (4500 mm), flad LOW-højde.
Bag toprem ligger på 1875 (LOW), så mesh-højde = 1875 − 167 = **1708 mm**.
Hele bag-væggen er net — ingen åbninger.

### B8 — Yard højre (skrå)

Skrå top der følger V5-toprem fra HIGH (Y=0, z=2175) til LOW (Y=2500,
z=1875) — modelleres i kode med `voliere_y_sloped(...)` der intersector
et rektangulært net mod en sloped wedge.

- Y = 0..2500 (2500 mm langs Y-aksen)
- z_base = 167 (overalt)
- z_top: 2175 ved Y=0 (HIGH), 1875 ved Y=2500 (LOW)
- Mesh-højde varierer fra 2008 (front-enden) til 1708 (bag-enden)

## Skæreliste — voliernet

| Område | Mål | Areal | Lin.m (med 1 m mesh-rulle, 2 bånd) |
|---|---|---|---|
| B6 front venstre | 1500 × 2008 | 3,01 m² | 1,5 m × 2 = 3,0 m |
| B6 front højre | 1930 × 2008 | 3,88 m² | 1,93 m × 2 = 3,86 m |
| B7 bag (1 bane) | 4500 × 1708 | 7,69 m² | 4,5 m × 2 = 9,0 m |
| B8 højre (skrå) | 2500 × (2008..1708) | 4,65 m² | 2,5 m × 2 = 5,0 m |
| **Total** | | **19,22 m²** | **~20,9 m** |

Top-bånd på B7 og B8 kan trimmes ned (kun 0,7 m mesh på top vs. 1 m
fuldt bånd) hvis du vil spare. Praktisk regn med ~22 m mesh-strip
inkl. overlap (50 mm horisontalt mellem bånd).

## Materialeliste

| # | Vare | Beskrivelse | Antal | Enhed | Pris/enh | I alt |
|---|---|---|---|---|---|---|
| 1 | Voliernet ½″ × 1″ × 1 mm tråd, 25 m × 1 m højde | Hele perimeteret (~22 m mesh-strip i 2 bånd pr. væg) | 1 | rulle | ~950 | ~950 |
| 2 | Krampler 25 mm rustfri | Stifter til voliernet, c/c 100 langs alle reglar | 1 | pak | | |
| 3 | Klingespænder / draht-spændetang | Holder mesh stramt under stiftning (lejes / lånes) | 0 | — | — | — |
| | | | | | **Total** | **~950 kr** |

**Note om mesh-højde:** En 1 m × 25 m rulle kræver 2 bånd stablet for
yard-front (2 m højde). For yard-bag og yard-højre kan top-båndet trimmes
da højderne er 1,7 m. Alternativt:

- 1,2 m × 25 m rulle (~1100 kr): færre samlinger, men stadig 2 bånd front
- 1,5 m × 25 m rulle (~1400 kr): 1 bånd for B7 (1,71m, lille extra strip på top), B8 dækkes på lignende måde
- 2 m × 25 m rulle (sjælden): kun bånd nødvendigt for front-HIGH

For en bondet kanin-yard er ½″ × 1″ × 1 mm tråd absolut minimum (REQ-008
rovdyrsikring) — gå ikke under denne specifikation.

## Bygge-rækkefølge

1. Verificer at yard-skelet er fuldt rejst (V1/V2 hl..ll segmenter, V5
   højre, alle reglar c/c 600, toprem på plads, yard-dør Å4 indsat med
   karm)
2. Rul mesh ud langs første væg, marker midten, klip i passende længder
3. Stift første bånd nede ved sill-plate (Z = 167) med krampler c/c 100
   langs hver reglar
4. Stræk mesh op til ca. 1 m højde, stift langs næste reglar
5. Lap andet bånd 50 mm over første bånds top — stift gennem begge lag
   langs samme reglar
6. Gentag for B6 (front 2 bånd om dør), B7 (bag), B8 (højre, skrå
   trimning langs top)
7. Stop alle bånd ved underkanten af toprem — top-trekanter (mellem
   spær) lukkes af tagkonstruktionen

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
```

Inspect:
- Voliernet sidder på yard-perimeteret, ikke på hus-væggene (intet net
  på partition V4)
- Mesh-top ligger ved toprem-underside (Z = 2175 front, 1875 bag)
- Skrå top på B8 følger V5-toprem fra HIGH til LOW
- B6 splittet i 2 bånd om yard-døren ved X = 3000..4070
