# v3 — Source Layout

Build a 6 × 2.5 m rabbit house + run with a continuous mono-pitch roof.
Each file below covers ONE building system so it can be reviewed alone.

## Build order

```
config.scad                 # constants — read first
build.scad                  # composes the systems below

fundament.scad              # ↓ what the tømrer builds first
konstruktions-skelet.scad   # ↓ then this (træ-skelet over fundamentet)
tagkonstruktion.scad        # ↓ then this
beklaedning.scad            # ↓ then this (visual layer)
aabninger.scad              # ↓ then this (doors / window)
inventar.scad               # last — nest box, bowls, decor
```

## Files

| File | Building system | Key materials |
|---|---|---|
| `config.scad` | Constants & geometry helpers | — |
| `build.scad` | Top dispatcher (~30 lines) | — |
| `fundament.scad` | Fundablok ring + ankerskruer | Fundablok 50×20×15, beton, ankerskrue M10 |
| `konstruktions-skelet.scad` | DPC + bundrem + reglar + framed openings + toprem | Murpap, 45×95 reglar (PT/gran C24) |
| `tagkonstruktion.scad` | Spær + cover layers + sternbrædder + tagrende | 45×95 spær, varies by `roof_cover` |
| `beklaedning.scad` | Klink cladding + afstandsliste + hjørnetrim | 22 mm klinkbrædder + 22×45 lægter |
| `aabninger.scad` | 4 openings: human dør (partition), pet dør, yard dør, sidevindue | Trä karm, hængsler, beslag |
| `inventar.scad` | Nest box, hay rack, bowls, rabbits, outdoor dressing | — |

## Toggles in `main.scad`

- `show_cladding=false` — hide klink, doors, window so the framing is visible
- `show_ground=false` — hide grass / path / yard fill so the foundation is visible
- `roof_cover="tagpap"` — switch tag-dækning between `tagpap`, `stål`, `eternit_10`, `eternit_14` (pluggable in Sub-phase F)

## Phase 1 spec

`docs/superpowers/specs/2026-05-09-v3-buildable-phase1-design.md`
