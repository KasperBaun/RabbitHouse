# `designs/` — Active design source

L-shaped rabbit house + run. House gets a gable roof; yard gets a mesh lid
(or a mono-pitch for solid covers).
See `CLAUDE.md` (repo root) for full architecture, conventions, and zone split rules.

## Layout

```
designs/
  config.scad                # constants (RH_*, G_*) + roof-geometry helpers — read first
  ground.scad                # SHARED — grass / terrain
  roof_plates_skifer.scad    # cover: gable naturskifer (house only; per-layer entries)
  roof_plates_tagpap.scad    # cover: OSB + tagpap (house + yard)
  roof_plates_eternit.scad   # cover: C18 + Cembrit B7 (house + yard)
  roof_plates_polycarb.scad  # cover: polycarb slab (yard only)
  roof_plates_mesh.scad      # cover: welded-wire lid (yard default)
  house/                     # HUS-zone (X=0..2000, Y=0..3000) — gable roof + kælder
    foundation.scad basement.scad floor.scad framing.scad openings.scad
    roof.scad roof_gable.scad roof/haneband.scad roof/gitterspaer.scad
    roof_plates.scad cladding/cladding.scad + variants
  yard/                      # YARD-zone (X=2000..6000, Y=1000..3000) — mesh-top run
    foundation.scad framing.scad openings.scad
    roof.scad roof_plates.scad mesh.scad
```

## House cover options (`house_roof_cover` in `main.scad`)

| Cover     | Roof shape          | Slope    | Materials |
|-----------|---------------------|----------|-----------|
| `skifer`  | Gable (35°)         | n/a      | genbrugs-naturskifer 30×60 i dobbelt dækning på 38×73 lægter + 25×50 afstandslister |
| `tagpap`  | Mono-pitch (4,6°)   | 8 % fald | 18 mm OSB + 4 mm tagpap + alu sternkapsler |
| `eternit` | Mono-pitch (~14°)   | 25 % fald (steeper eh_back) | 38×73 C18 lægter + Cembrit B7 |

## Yard cover options (`yard_roof_cover` in `main.scad`)

`mesh` (default — wire lid straight on the top plates), `polycarb`, `tagpap`, or `eternit`.

## Toggles

Top of `main.scad`: set `house_roof_cover`, `house_truss`, `yard_roof_cover`, `cladding_type`.
Comment/uncomment individual `Render*()` calls below to isolate a building system.

With `house_roof_cover == "skifer"` the roof is rendered **step by step** — one
call per arbejdsplan work step (`RenderHouseRoofSpaer` → `-Undertag`
→ `-Afstandslister` → `-Laegter` → `-Stern` → `-Fodblik` → `-Skifer` →
`-Vindskeder` → `-Rygning`).
Comment calls in/out to preview each build stage.
