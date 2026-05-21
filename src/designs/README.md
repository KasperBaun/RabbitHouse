# `designs/` — Active design source

L-shaped rabbit house + run. House gets a gable roof; yard gets a mono-pitch.
See `CLAUDE.md` (repo root) for full architecture, conventions, and zone split rules.

## Layout

```
designs/
  config.scad                # constants (RH_*) + roof-geometry helpers — read first
  ground.scad                # SHARED — grass / terrain
  roof_plates_skifer.scad    # cover: gable slate (house only)
  roof_plates_tagpap.scad    # cover: OSB + tagpap (house + yard)
  roof_plates_eternit.scad   # cover: C18 + Cembrit B7 (house + yard)
  roof_plates_polycarb.scad  # cover: polycarb slab (yard only)
  house/                     # HUS-zone (X=0..2000, Y=0..3000) — gable roof
    foundation.scad framing.scad openings.scad
    roof.scad roof_gable.scad roof_plates.scad
    cladding/cladding.scad + 4 variants
  yard/                      # YARD-zone (X=2000..6000, Y=500..3000) — mono-pitch
    foundation.scad framing.scad openings.scad
    roof.scad roof_plates.scad mesh.scad
```

## House cover options (`house_roof_cover` in `main.scad`)

| Cover     | Roof shape          | Slope    | Materials |
|-----------|---------------------|----------|-----------|
| `skifer`  | Gable (35°)         | n/a      | 30×60 cm fiber-cement slates on 25×38 lægter |
| `tagpap`  | Mono-pitch (4,6°)   | 8 % fald | 18 mm OSB + 4 mm tagpap + alu sternkapsler |
| `eternit` | Mono-pitch (~14°)   | 25 % fald (steeper eh_back) | 38×73 C18 lægter + Cembrit B7 |

## Yard cover options (`yard_roof_cover` in `main.scad`)

`polycarb` (default — transparent slab), `tagpap`, or `eternit`.

## Toggles

Top of `main.scad`: set `house_roof_cover`, `yard_roof_cover`, `cladding_type`.
Comment/uncomment individual `Render*()` calls below to isolate a building system.
