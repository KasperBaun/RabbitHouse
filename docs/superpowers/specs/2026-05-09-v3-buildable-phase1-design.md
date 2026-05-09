# v3 Buildable — Phase 1 Design Spec

**Status:** Awaiting user review
**Date:** 2026-05-09
**Scope:** v3 only (v1, v2 untouched)
**Goal:** Make the v3 SCAD model into something a Danish tømrer could actually build from, with a BOM detailed enough to buy materials.

This is **Phase 1 of 3**. Phase 2 = 2D plan/elevation/section drawings with dimensions. Phase 3 = connection details + consolidated cut list + beslagskema. Specs for Phase 2 and 3 will be written after Phase 1 ships.

---

## 1. Geometry baseline

| Constant | Value | Notes |
|---|---|---|
| `V3_LENGTH` | 6000 mm | unchanged |
| `V3_WIDTH` | **2500 mm** | from earlier 3000; uncommitted in working tree, will be committed as part of Phase 1 |
| `V3_HOUSE_LEN` | **1500 mm** | house portion X=0..1500 (was 2000) |
| `V3_RUN_LEN` | **4500 mm** | yard portion X=1500..6000 (was 4000) |
| `V3_NEST_X` | **200 mm** | nest box re-anchored (was 1100; would have overflowed shorter house) |
| `V3_EH_FRONT` | 2600 mm | front wall-face eave |
| `V3_EH_BACK` | 2200 mm | back wall-face eave (for `tagpap` and `stål` covers) |

**Slope:** drop 400 / width 2500 = atan(0.16) = **9.09°**. Adequate for tagpap (≥2°) and stålplade (≥3°). Eternit B6 needs `V3_EH_BACK` lowered (see §5).

---

## 2. File reorganisation (`designs/v3/`)

Replace current monolithic `build.scad` with **role-based files** the user can review one system at a time.

```
designs/v3/
├── README.md             # Forklarer rolle af hver fil + bygge-rækkefølge
├── config.scad           # Konstanter (eksisterer; opdateres med taghældnings-presets)
├── build.scad            # Top dispatcher: kalder build_<system>() i orden
├── fundament.scad        # Fundablok ring + grus + ankerskruer + strøer + krydsfiner
├── vaegge.scad           # Stolpevægge (hus + yard frame): stolper, losholter, vindkryds, beslag
├── tagkonstruktion.scad  # Pluggable spær + lag pr. dækning + spærsko + sternbrædder
├── beklaedning.scad      # Klink, vindpapir, afstandsliste, hjørnetrim
├── aabninger.scad        # 4 åbninger: human dør, pet dør, yard dør, sidevindue
└── inventar.scad         # Rede-kasse, høhæk, foderskåle, kaniner, dressing
```

**Note:** Filnavne ASCII-only (`vaegge` ikke `vægge`) for at undgå OpenSCAD `use <...>` encoding-issues på Windows. Modulnavne indenfor må gerne være æ/å (`module build_vægge()`).

**Library primitives** (`lib/primitives/*.scad`) stay shared across designs. New file: `lib/primitives/beslag.scad`.

`build_v3()` becomes:
```scad
module build_v3(show_cladding=true, roof_cover="tagpap") {
    bom_header();
    build_fundament();
    build_vægge();
    build_tagkonstruktion(roof_cover);
    if (show_cladding) build_beklædning();
    if (show_cladding) build_åbninger();
    build_inventar();
}
```

**v1 and v2 are not touched.** They keep their single-`build.scad` structure.

---

## 3. Fundament (`fundament.scad`)

### 3.1 Fundablok ring

- 50 × 20 × 15 cm fundablok, 3 skifter i forbandt, ~60 cm høj
- 17 m perimeter (102 blokke per BOM in `docs/version 3/materialeliste.csv`)
- Sat på 200 mm stabilgrus i ~80 cm frostfri grøft
- Hulrum udstøbes med ~790 L beton, lodret armering Ø10 mellem skifter
- Top af ring = sokkel-niveau (= "base h"), bundrem af alle vægge sidder her
- **Replaces** current `slab(...)` and `v3_yard_plugs_and_posts(...)` calls

### 3.2 Husgulv (X=0..1500, indenfor ringen)

- **Ledger-bjælke 45×95** (PT) skrue-fastgjort indvendigt langs ringens inderside (8×80 betonskruer c/c 400)
- 45×95 strøer (PT) c/c 600 hviler ende-til-ende på ledger-bjælken og forankres med strøsko `45x95`
- 18 mm krydsfiner gulv ovenpå (sikret med 4×50 mm søm i hver strø)
- Hulrum under (~50 cm afhængigt af endelig sokkel-højde) → god ventilation
- Mus-net 6 mm spændt under strøer hele vejen, inkl. ringen→græs interface udvendigt

### 3.3 Yard "gulv" (X=1500..6000, indenfor ringen)

- Stabilgrus opfyldt til top af ring
- Græs/jord ovenpå
- Buried mesh apron skirts (eksisterer som `apron_skirt`) bibeholdes som dig-defence på ydersiden af ringen

### 3.4 Ankerskruer

- M10 expansion-anker eller kemisk anker, c/c 1000 mm langs hele ringens topskifte
- Trænger gennem bundremmens 45 mm + 100 mm ned i ringens beton-fyldte hulrum
- Modelleres med `ankerskrue_m10()` fra `lib/primitives/beslag.scad`; BOM-tælles

### 3.5 BOM-poster i `fundament`

| Post | Materialer |
|---|---|
| Fundablok 50×20×15 cm | 102 stk + buffer (allerede i materialeliste.csv) |
| Beton tør-sæk (790 L) | ~64 sække à 25 kg |
| Stabilgrus 0/32 | ~3 m³ |
| Armeringsjern Ø10 | ~30 m |
| Strøer 45×95 PT | ca. 5 stk × 1,4 m (spænder X-retning, c/c 600 langs Y) |
| Krydsfiner gulv 18 mm | ~3,7 m² (1500×2500 minus væg-tykkelser) |
| Mus-net 6 mm | ~3,7 m² (samme areal som gulv) |
| Ankerskruer M10×120 | ~17 stk |

---

## 4. Vægge (`vaegge.scad`)

Én fil dækker **alle 5 væggrupper**: 4 hus-vægge + yard-perimeter (front/bag/højre).

### 4.1 Hus-vægge (X=0..1500)

| Lag (inde→ude) | Element | Dimension |
|---|---|---|
| 1 | Stolpe | **45×95 reglar** c/c 600 |
| 2 | Losholt midt på væggen | **45×95** vandret pr. stolpefag, ~1100 mm over bundrem |
| 3 | Vindkryds | **22×95** X-mønster, indfældet i stolpe-yderside |
| 4 | Bats-isolering | **95 mm rockwool** i hver stolpefag (vises som muteret gul flade i frame view) |
| 5 | Vindpapir / dampbremse | tynd grå membran på stolpe-yderside |
| 6 | Afstandsliste | **22×45** lodret c/c stolpespacing |
| (klink kommer på i `beklaedning.scad`) | | |

**INGEN dampspærre** indvendigt (pr. brugerens valg — pragmatisk for ikke-permanent opvarmet udebygning, lader væggen tørre indad).

**INGEN indvendig beklædning** — rå stolper synlige indefra (kaninerne kan ikke gnave isoleringen, da der formentlig ingen adgang er til væg-cavityet hvis vi kører klink-skirt fast indvendigt i bunden — kontroller under implementering).

### 4.2 Vinkelbeslag

- 2 vinkelbeslag pr. stolpe pr. ende (top + bund) — dvs. stolpe→bundrem og stolpe→toprem
- Type: standard 90×90 perforeret vinkel (BMF/Simpson)
- Fastgørelse: 5×40 ankerskrue, 4 stk pr. ben
- BOM: `bom_member("vinkelbeslag", "stål-galv", 90, 90, 2, "stud_to_plate")` (tæller stk)

### 4.3 Yard-vægge (X=1500..6000) — uden plugs/posts

- Hjørner og åbninger får 45×95 reglar (ikke 95×95 stolper) — sparer materiale, gør væggen til samme system som hus-vægge
- Top: dobbelt 45×95 toprem (stærkere på 4 m yard-spænd) skrå pr. tag-hældning
- Stiver hver 1000 mm (45×95 i stedet for 70×70 som nu)
- Mesh-infill mellem reglar (uændret `mesh_panel_x/y` primitives)
- **Yard back wall:** lav clad-skirt fra bundrem → mesh ventilation-band derover (per CLAUDE.md). Skirt-stolper, beklædning på outer face. **Default skirt-højde: 600 mm** (justerbart via ny `V3_BACK_SKIRT_H` konstant)
- Bjælkesko ved top-bjælke→partition-væg samling

### 4.4 Verifikation per system

`_renders/v3/audit/vægge_frame.png` skal vise:
- Bundrem på ringens top-niveau, hele perimeteret
- 45×95 stolper c/c 600
- Losholter midtvejs
- Vindkryds X-mønster pr. væg (5 vægge → 5 kryds)
- Toprem (skrå hvor relevant)
- Hverken klink, bats, vindpapir, eller åbninger (dem viser andre auditer)

---

## 5. Tagkonstruktion (`tagkonstruktion.scad`)

**Pluggable: `roof_cover = "tagpap" | "stål" | "eternit_10°" | "eternit_14°"`**

### 5.1 Spær (samme uanset cover)

- 45×95 spær c/c 600, skrå fra `V3_EH_FRONT` til `V3_EH_BACK`
- Bærer på hus-toprem (front og bag) og yard-toprem (front og bag)
- Udhæng: 220 front, 180 bag, 220 sider (uændret)
- Spærsko begge ender (BMF/Simpson sidemonteret, type 100×95)

### 5.2 Lag pr. cover-type

| Lag | tagpap | stål | eternit_10° | eternit_14° |
|---|---|---|---|---|
| Spær 45×95 c/c 600 | ✓ | ✓ | ✓ | ✓ |
| Forskalling 22 mm rå | ✓ | — | — | — |
| Undertag (Tyvek o.l.) | — | ✓ | ✓ | ✓ |
| Afstandsliste 25×50 langs spær | — | ✓ | ✓ | ✓ |
| Lægter 38×73 c/c — | — | 600 | 1085 | 1085 |
| Tagdækning | 2-lag pap | trapezstål 0,5 mm | Cembrit B6 8 mm | Cembrit B6 8 mm |
| `V3_EH_BACK` justeres til | 2200 (uændret) | 2200 (uændret) | **2160** (drop 440) | **1976** (drop 624) |

Note: ved valg af `eternit_*` justerer modulet automatisk `V3_EH_BACK` så hældningen overholder profilens norm. Sammenhængende effekter: yard-back-toprem, husets bag-væg-højde, mesh-vindue-højde i back-skirt — alle interpoleres pr. den nye back-højde.

### 5.3 Sternbrædder + tagrende

- Eksisterende `fascia_and_gutter_mono` bibeholdes (uændret)

### 5.4 BOM pr. cover

Alt nedenstående tilføjes til `bom.csv` med `system="tagkonstruktion"` og `cover_type=<valgt>`:

| Post | tagpap | stål | eternit_10° | eternit_14° |
|---|---|---|---|---|
| Spær 45×95 (stk × længde) | 11×~2,4 m | 11×~2,4 m | 11×~2,4 m | 11×~2,4 m |
| Forskalling 22 mm rå (m²) | ~16,5 | — | — | — |
| Undertag (m²) | — | ~16,5 | ~16,8 | ~17,2 |
| Afstandsliste 25×50 (lin.m) | — | ~26 | ~27 | ~27 |
| Lægter 38×73 (lin.m) | — | ~33 | ~17 | ~17 |
| Tagpap underpap+svejsepap (m²) | ~17,5 | — | — | — |
| Trapezstål 0,5 mm (m²) | — | ~17,5 | — | — |
| Cembrit B6 8 mm (m²) | — | — | ~18 | ~18 |
| Spærsko 100×95 (stk) | 22 | 22 | 22 | 22 |
| Tagskruer (stk) | — | ~120 | ~150 | ~150 |
| Pap-søm 25 mm (kg) | ~1 | — | — | — |

(Tal er foreløbige — beregnes præcist af modul fra geometri ved render-tid.)

### 5.5 Verifikation

- `_renders/v3/audit/tagkonstruktion_pap.png` — spær + forskalling + pap (sortskinnende)
- `_renders/v3/audit/tagkonstruktion_stål.png` — spær + lægter + trapez (sølv)
- `_renders/v3/audit/tagkonstruktion_eternit10.png` — spær + lægter + bølgeplade (grå)
- Sammenligningstabel udskrevet via nyt script `scripts/compare_roof_options.ps1`

---

## 6. Beklædning (`beklaedning.scad`)

- Klink-brædder (uændret `klink_board` primitive)
- Hjørnetrim 45×45 (uændret v3_house_corner_trims)
- (Vindpapir og afstandsliste håndteres i `vaegge.scad` da de er en del af væg-stak'en)

Ingen funktionel ændring fra nu — bare flyttet til egen fil.

---

## 7. Åbninger (`aabninger.scad`)

4 åbninger:
1. Human dør i partition (X=hl, faces +X)
2. Pet dør i partition (X=hl)
3. Yard mesh-dør (front Y=0)
4. Sidevindue (X=0, faces -X)

Per åbning: karm, beslag, hængsler, håndtag, evt. trin/plade. Indrammet med jambs/header/cripples (eksisterende `framed_opening_y`).

Ingen funktionel ændring — bare flyttet til egen fil.

---

## 8. Inventar (`inventar.scad`)

- **Rede-kasse repositioneret** til X=200..1000 (W=800, uændret) — nødvendigt fordi det 1500 mm korte hus ikke kan rumme den oprindelige X=1100..1900 placering. Ny `V3_NEST_X = 200`.
- Høhæk (uændret position på bag-væg)
- Foderskåle i yard (uændret)
- Kaniner + landskabs-dressing (uændret)

Ellers bare flyttet til egen fil. Hø/strøelse-opbevaringskasser i front-venstre hjørne af huset (ved X=145 og X=595) fitter stadig i 1500 mm husets bredde.

---

## 9. Beslag-bibliotek (nyt: `lib/primitives/beslag.scad`)

| Modul | Bruges til | BOM-navn |
|---|---|---|
| `ankerskrue_m10(p)` | bundrem→ring | `ankerskrue_m10` |
| `vinkelbeslag(p, type)` | stolpe→rem | `vinkelbeslag_90x90` |
| `spaersko(p, beam_size)` | spær→toprem | `spaersko_100x95` |
| `bjaelkesko(p, beam_size)` | top-bjælke→stolpe | `bjaelkesko` |
| `strøsko(p, joist_size)` | strø→ring inderside | `strøsko_45x95` |

Hvert modul rendrer en simpel galvaniseret-grå geometri (cube/L/U-form) + kalder `bom_member` for at tælle stk.

---

## 10. BOM-udvidelser

Tilføj `system` kolonne til `bom.csv` outputtet:

```
system, name, material, w, d, l, count, role, cover_type
fundament, fundablok, beton, 500, 200, 150, 102, foundation_ring,
vægge, stud, spruce, 95, 45, 2400, 1, house_front_wall,
tagkonstruktion, spær, spruce, 95, 45, 2940, 11, mono_pitch_rafter, tagpap
...
```

Ny kolonne lader brugeren filtere CSV'en pr. system når de bestiller.

---

## 11. Verifikation før Phase 1 lukkes

1. **Per-system audit-renders** (10 stk i `_renders/v3/audit/`) — alle 5 systemer + 4 cover-varianter + fuld iso
2. **Eksisterende `audit_v3_iso.png` (med klink) skal stadig se næsten identisk ud** — ingen visuelle regressioner i den brugervendte iso
3. **`bom.csv` indeholder alle nye linjer** med `system`-kolonnen udfyldt
4. **`scripts/compare_roof_options.ps1` printer sammenligningstabel** for de 4 cover-typer
5. **CLAUDE.md opdateres** med:
   - Ny v3-fil-arkitektur (file split listet under "Layout")
   - Sektionen om v3 opdateres: fundablok-ring i geometri (ikke kun BOM), ingen plugs/posts, pluggable `roof_cover` parameter, ny `V3_BACK_SKIRT_H`
   - Fjern note om "geometry not yet updated" (den er da gennemført)
6. **TIMBER-FRAMING.md opdateres** med: stolper 45×95 hele vejen igennem (ingen 95×95 eller 70×70), losholter+vindkryds som standard, beslag-skema
7. **v1 og v2 renderer identisk** med før (regression-tjek mod `_renders/before_v1.png` og `before_v2.png`)

---

## 12. Out of scope for Phase 1

- 2D plan/facade/snit tegninger med målk æder (= **Phase 2**)
- Detail-tegninger af samlinger (sokkel, hjørne, spær-til-toprem) (= **Phase 3**)
- Konsolideret skæreliste pr. tømmertype (= **Phase 3**)
- Beslagskema PDF (= **Phase 3**)
- Pris-estimater pr. tagdækning baseret på rigtige Stark/Bauhaus priser (= **Phase 3**)
- Statiske beregninger / ingeniør-attest (uden for projektets scope)

---

## 13. Open questions

Ingen — alle afgørende valg er truffet under brainstorming 2026-05-09.

Videre afklaringer kan komme op under implementering; flag dem da som spørgsmål inden de impacter design.
