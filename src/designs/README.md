# `designs/` — Active design source layout

Build a 6 × 2,5 m rabbit house + run with a continuous mono-pitch roof. Each file below covers ONE building system so it can be reviewed alone.

## Build order

```
config.scad                    # constants — read first
build.scad                     # composes the systems below

fundament.scad                 # ↓ what the tømrer builds first
konstruktions-skelet.scad      # ↓ then this (træ-skelet over fundamentet)
tagkonstruktion_faelles.scad   # ↓ spær + lookouts + sofitt (cover-uafhængigt)
tagkonstruktion_tagpap.scad    # ↓ cover A: OSB + tagpap + alu-sternkapsler
tagkonstruktion_eternit.scad   # ↓ cover B: undertag + C18 lægter + B7 eternit
beklaedning.scad               # ↓ then this (visual layer)
aabninger.scad                 # ↓ then this (doors / window)
inventar.scad                  # last — nest box, bowls, decor
```

## Files

| File | Building system | Key materials |
|---|---|---|
| `config.scad` | Constants (`RH_*`) & geometry helpers | — |
| `build.scad` | Top dispatcher (~30 lines) | — |
| `fundament.scad` | Fundablok ring + ankerskruer | Fundablok 50×20×15, beton, ankerskrue M10 |
| `konstruktions-skelet.scad` | DPC + bundrem + reglar + framed openings + toprem | Murpap, 45×95 reglar (PT/gran C24) |
| `tagkonstruktion_faelles.scad` | Spær + lookouts + sofitt + cover-layer helper (delt mellem cover-varianter) | 45×95 spær, 18 mm krydsfiner sofitt |
| `tagkonstruktion_tagpap.scad` | Cover A: OSB-dæk + underpap + tagpap + alu-sternkapsler | 18 mm OSB, 4 mm tagpap, 35×25 alu cap |
| `tagkonstruktion_eternit.scad` | Cover B: C18 lægter + Cembrit B7 sortblå | 38×73 C18 lægter c/c 460, 1100×570 B7 |
| `beklaedning.scad` | Klink cladding + afstandsliste + hjørnetrim | 22 mm klinkbrædder + 22×45 lægter |
| `aabninger.scad` | 4 openings: human dør (partition), pet dør, yard dør, sidevindue | Trä karm, hængsler, beslag |
| `inventar.scad` | Nest box, hay rack, bowls, rabbits, outdoor dressing | — |

## Toggles in `build.scad`

- `show_cladding=false` — hide klink, doors, window so framing is visible
- `show_ground=false` — hide grass / path / yard fill so foundation is visible
- `show_cover=false` — hide cover-lag (vis kun spær + lookouts)
- `roof_cover` — switch tag-dækning mellem `"tagpap_osb"` (alias `"tagpap"`), `"eternit_b7"` (flad — kun layout), `"eternit_10"` (10°) eller `"eternit_14"` (14°). Dispatcher i `build.scad` vælger den rigtige `tagkonstruktion_*.scad` per cover.

## Phase 1 spec

`docs/superpowers/specs/2026-05-09-v3-buildable-phase1-design.md` (historical — work is implemented).
