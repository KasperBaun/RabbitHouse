# Multi-Design Refactor + House-Yard v2 — Design

**Date:** 2026-04-29
**Status:** approved, in implementation

## Goal

1. Refactor the OpenSCAD model so multiple distinct rabbit-house designs can coexist and be selected with a single switch in `main.scad`.
2. Add a new design `house_yard_v2` — a 6×3 m structure with a 2×3 m gabled "house" on the left and a 4×3 m mesh-walled run with polycarbonate roof on the right.
3. Keep the existing v1 design (lean-to with rabbit zone + human seating) fully renderable via the new dispatcher.

## Refactor architecture (option C — full parameterization)

No module reads file-global variables. Things that travel together get bundled into small **ctx vectors** with accessor functions. Library modules use named parameters with defaults. `main.scad` dispatches between designs.

### Layout

```
main.scad                              # dispatcher
lib/
  ctx.scad                             # accessor functions
  defaults.scad                        # DEFAULT_PALETTE / CLAD / MESH / STUD
  presets.scad                         # preset_dims lookups (used by v1)
  primitives/
    cladding.scad                      # klink_board, clad_wall_rect/mono/gable
    mesh.scad                          # mesh_panel_x/y, mesh_door_yz
    roof.scad                          # mono_pitch, gable, polycarb_mono, gutter, rafters
    framing.scad                       # stud_wall, post, sloped beam helpers
    openings.scad                      # window_with_trim, door, rabbit_pet_door
    foundation.scad                    # slab, interior_floor, apron_skirt
  decor/
    rabbit.scad                        # rabbit, rabbit_loaf, accessories
    landscape.scad                     # landscaping, paths
    lighting.scad                      # pendant, string_lights, outlets
    furniture.scad                     # v1 bench/table/shelves/coffee
designs/
  lean_to_v1/
    config.scad                        # preset lookups
    build.scad                         # build_lean_to_v1(preset)
  house_yard_v2/
    config.scad                        # v2 constants
    build.scad                         # build_house_yard_v2()
```

### Conventions

- Library files: `use <...>` so they don't leak top-level variables. Each library file `include`s `defaults.scad` so its modules can use `DEFAULT_*` as default arg values.
- Designs: each design owns its own `config.scad` (constants) and `build.scad` (composition). The build module assembles the design from `lib/` primitives plus design-specific helper modules in the same file.
- Coordinate system: same as v1 — front Y=0, back Y=`width`, left X=0, right X=`length`. Z up. All units mm.

## v2 design — `house_yard_v2`

### Footprint (6000 × 3000 mm)

- **House zone:** X 0–2000, Y 0–3000. Solid cladded shell with gable roof, ridge along Y at X=1000, eave 2200, ridge 2700.
- **Run zone:** X 2000–6000, Y 0–3000. Mesh on three exterior sides, solid cladded back, mono-pitch polycarbonate roof.

### House interior

- **Airlock + storage cell:** X 0–1000, Y 0–1000 (1 m²). Outer human door on Y=0 face (≥800×1900 mm, two-stage latch). Inner door swings into the rest of the house.
- **Nest box:** insulated panel cell against the back wall, ≈800×1200×600 mm, low profile so rabbits jump on top for vertical enrichment.
- **Rabbit pet door** in the partition wall at X=2000 — 250×300 mm cutout, low at Y≈1500, permanently passable.
- **Ventilation:** louvre slot high in the X=0 gable triangle; low slot in the back (Y=3000) eave wall (opposite-wall pairing per REQ-023).

### Run interior

- Mesh walls: front (Y=0), right (X=6000), partial above-clad on back (Y=3000).
- Back wall solid cladded for prevailing wind (REQ-016) up to a high vent strip.
- Polycarb roof slopes Y=0 high (2400) to Y=3000 low (2150). Twin-wall PC modeled as translucent slab on visible aluminium purlins.
- Perimeter buried apron: 500 mm horizontal mesh skirt at ground level around all three exterior run walls.
- Rabbit furniture: lookout platform (REQ-006), sand dig tray (REQ-007), hay rack, water bowl, hide, ramps.

### New requirements (added to `requirements.md`)

- **REQ-049** — Airlock vestibule must double as bedding/hay storage with ≥0.5 m³ usable volume.
- **REQ-050** — Transparent run roof must be ≥10 mm twin-wall polycarbonate, UV-stable, fixed with chew/pry-resistant fasteners.
- **REQ-051** — House↔run pet door must remain permanently passable (it is not a sluice).
- **REQ-052** — House gable ridge runs along Y; the X=2000 gable wall braces against wind and is the wall the run roof leans against.
- **REQ-053** — Run roof must drain to the back gutter; no discharge against the partition at X=2000.

## Migration order

1. Create `lib/` (purified primitives + new gable/polycarb additions).
2. Port v1 into `designs/lean_to_v1/build.scad`, calling `lib/`. Verify renders.
3. Build v2 in `designs/house_yard_v2/build.scad`. Verify renders.
4. Replace `main.scad` with dispatcher.
5. Delete `helpers/`, `modules/`, root `config.scad`, root `presets.scad`.
6. Update `CLAUDE.md` (new conventions), `docs/requirements.md` (REQ-049+), `docs/prd.md` (right-zone v2 defined).

## Verification

`openscad -o out.png` for both designs. Pass = no errors emitted, renders match expectations on visual review.
