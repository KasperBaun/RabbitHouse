# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD model of a rabbit house — an outdoor structure for a bonded pair of pet rabbits in a Nordic / temperate-maritime climate. All units are millimetres.

Earlier iterations (v1: mono-pitch shed; v2: gabled house + polycarb run) are frozen in `_archive/` and not part of the active build. The current design is an **L-shape**: a tall gable-roofed house and a lower, separate mesh-top run (løbegård) sharing the back wall line.

## Opening / Previewing

Open `src/main.scad` in OpenSCAD — it is the top-level dispatcher, organised into `// shared`, `// house`, and `// yard` sections. Toggles near the top:

- `house_roof_cover` — `"skifer"` (default; gable roof) | `"tagpap"` | `"eternit"` (legacy mono-pitch)
- `yard_roof_cover` — `"mesh"` (default) | `"polycarb"` | `"tagpap"` | `"eternit"`
- `cladding_type` — `"klink"` | `"board_on_board"`

With `"skifer"` the house roof is rendered **step by step** — one `RenderHouseRoof*()` call per arbejdsplan work step, in real build order (spær → undertag → afstandslister → lægter → stern → fodblik → skifer → vindskeder → rygning). Comment calls in/out to inspect each build stage. Other covers render via the two composite calls in the `else` branch (scripts in `src/scripts/` override `house_roof_cover` with `-D` and rely on this).

The `// yard` render block is currently commented out — uncomment to see the run.

## House / yard split

The two zones are **separate structures** with different footprints and wall heights. Code and BOM split at **X = RH_HOUSE_LEN (2000 mm)**:

| Zone  | Footprint                     | What it owns |
| ----- | ----------------------------- | ------------ |
| House | X = 0..2000, Y = 0..3000      | Walls V1–V4 (own full perimeter); gable roof + skifer cover; kælder (basement pit + slab + lemme/trapper); strøer-gulv; front door (no front windows) + V3 side window + hus-dør in V4 (`RenderHouseV4Doors`, not built — commented out in main.scad); cladding all 4 walls; foundation ring. |
| Yard  | X = 2000..6000, Y = 1000..3000 | Own V1/V2 wall segments + V5; mesh walls front/back/right; mesh lid (or mono-pitch roof for solid covers); yard door; 3-sided foundation (`standalone=true` adds the 4th side). |
| Shared | —                            | Ground; back wall line Y = 3000 is common to both zones. |

Note the yard front wall sits at Y = `RH_YARD_Y_OFFSET` (1000) — the house sticks 1000 mm further forward. `RenderYardFoundation(standalone)` / `RenderYardRoofPlates(cover, standalone)` control the geometry when the yard is built alone.

## Architecture

**Layout:**
```
src/
  main.scad                          # viewport + top-level dispatcher (Render*() calls)
  lib/
    ctx.scad                         # context-vector accessor functions
    defaults.scad                    # DEFAULT_PALETTE / CLAD / MESH / STUD
    presets.scad
    primitives/                      # beslag, cladding, fundablok, mesh, roof (fascia/gutter)
    decor/                           # rabbit, landscape, lighting, furniture
  designs/
    config.scad                      # constants (RH_*, G_*) + roof-geometry helper functions
    README.md                        # per-folder overview + toggle documentation
    ground.scad                      # SHARED — grass / terrain
    roof_plates_tagpap.scad          # cover variant — OSB + tagpap (parameterised x_lo/x_hi)
    roof_plates_eternit.scad         # cover variant — C18 lægter + eternit (x_lo/x_hi)
    roof_plates_polycarb.scad        # cover variant — 12 mm polycarb slab (x_lo/x_hi)
    roof_plates_mesh.scad            # cover variant — welded-wire lid (x_lo/x_hi)
    roof_plates_skifer.scad          # cover variant — gable-only naturskifer (no x-range;
                                     #   per-layer render_skifer_*() + composite entry)
    house/                           # HUS-zone (X = 0..2000)
      foundation.scad                # RenderHouseFoundation — fundablok perimeter ring
      basement.scad                  # RenderHouseBasementFloor + RenderHouseStairs (kælder)
      floor.scad                     # RenderHouseFloorJoists/-Hangers/-Deck (strøer-gulv)
      framing.scad                   # RenderHouseFraming — DPC + bundrem + studs + toprem, V1–V4
      openings.scad                  # RenderHouseOpenings — doors + windows
      roof.scad                      # RenderHouseRoof dispatcher + stern; step entries
                                     #   RenderHouseRoofSpaer/-Stern/-Vindskeder
      roof_gable.scad                # gavlspær + vindskede geometry
      roof/haneband.scad             # spær med hanebånd (som bygget; intet kipbræt)
      roof_plates.scad               # RenderHouseRoofPlates dispatcher; step entries
                                     #   RenderHouseRoofUndertag/-Afstandslister/-Laegter/
                                     #   -Skifer/-Rygning
      cladding/                      # klink | board_on_board renderers + common stack
    yard/                            # YARD-zone (X = 2000..6000, Y = 1000..3000)
      foundation.scad                # RenderYardFoundation(standalone)
      framing.scad                   # RenderYardFraming — V1/V2 segments + V5
      openings.scad                  # RenderYardOpenings — yard door (mesh leaf)
      roof.scad                      # RenderYardRoof — mono-pitch skeleton (solid covers only)
      roof_plates.scad               # RenderYardRoofPlates(cover, standalone)
      mesh.scad                      # RenderYardMesh — voliere front + bag + højre
docs/
  arbejdsplan/                       # printable per-step build instructions (+ img/)
  hus/, løbegård/                    # per-zone construction docs + skærelister pr. væg
  *.md                               # requirements, PRD, timber framing, roof guides
  materialeliste.xlsx                # consolidated BOM
_archive/                            # frozen earlier designs (v1, v2)
arbejdsplan.md                       # top-level build checklist (links into docs/arbejdsplan/)
guide-naturskifertag.md              # naturskifer reference guide (the slate-roof authority)
```

**Library files use `use <...>`**, design files `include <config.scad>` for their own constants.

### Convention: parameters, not globals

Every library module takes **named arguments with sensible defaults**. Things that travel together are bundled into small **ctx vectors** with accessor functions, declared in `lib/ctx.scad`:

| Vector | Slots | Accessors |
|--------|-------|-----------|
| `dims` | length, width, eave_h, base_h, wall_t | `dims_length`, `dims_width`, ... |
| `palette` | 21 named colors | `pal_post`, `pal_wall`, `pal_polycarb`, ... |
| `clad_spec` | board_h, overlap, thick, lip | `cs_board_h`, `cs_thick`, `cs_step`, ... |
| `mesh_spec` | spacing, bar, frame, depth | `ms_spacing`, `ms_bar`, ... |
| `stud_spec` | stud_w, stud_d, spacing | `ss_w`, `ss_d`, `ss_spacing` |

`src/main.scad` constructs ctx vectors near the top (`PALETTE` — the house is
painted black; structural timber stays natural) and threads them into the
`Render*()` calls. No library module reads file-global variables.

### Spatial layout

- **Front** = Y=0 (open garden face / human entry; yard front is at Y=1000).
- **Back** = Y=3000 (solid cladded wall; carries prevailing-wind / driving-rain duty per REQ-016).
- **Left** = X=0, **Right** = X=6000 (`RH_LENGTH`).
- Z up; base height = 120 mm above grade (`RH_BASE_H` = sokkel top).

### Structural notes

**House roof** is a gable (saddeltag): pitch 35° (`G_PITCH_DEG`), ridge along Y at X = 1000 (`G_RIDGE_X`), flat eave Z = 2412 on all four walls (`G_EAVE_Z`). Geometry via `g_rafter_top_z(x)` & friends in `designs/config.scad`. Each half-slope is exactly 1500 mm = 4 × gauge(225) + 600, sized for 30×60 cm slate in double coverage. Skifer build-up on the rafters (per `guide-naturskifertag.md`): undertag 3 mm → afstandslister 25×50 over each spær → taglægter 38×73 (gauge 225 on the slope) → genbrugs-naturskifer. The rake overhang (`G_OH_RAKE` ≈ 195) is carried by lægter cantilevering past the gable trusses; each gable gets a **dobbelt vindskede** (`G_VS_*` constants) — underbræt on the lægte ends plus an overligger rising `G_VS_OVER_RISE` above the slate surface, which the slate stops against. Sternbrædder (25×150, same depth as the underbræt so the corners meet flush) cap the rafter tails at both eaves with a zinc fodblik folded over them, and a zinc ridge cap covers the kip. Build details that are in the arbejdsplan but intentionally NOT modelled: begynderrække, opklodsnings-/kip-lister, cut top course. The mono-pitch helpers (`roof_oz*`, `RH_EH_*`) remain for the legacy tagpap/eternit house covers and the yard.

**House walls**: 2000 mm studs → wall top 2092 (`RH_EH_FRONT`); DPC 2 + bundrem 45 + stud + toprem 45. The 2000 mm door rough openings reuse the top plate as header.

**Foundation / kælder**: fundablok ring (50×20×15 blocks), 4 courses ≈ 800 mm deep (`RH_FOUNDATION_DEPTH`), on stabilgrus in a frostfri trench. The hollow ring is a usable basement pit: concrete slab at Z = −680 (`RH_BASEMENT_FLOOR_Z`), floor hatches (lemme) + steep stairs give access. House floor = 45×95 reglar frame + ~25 mm board deck, deck top flush with ring top (Z = 120). Comment out `RenderGround()` to inspect buried parts.

**Yard**: separate lower cage — flat 2100 walls front and back (`RH_YARD_EH_*`), welded-wire mesh walls (13 mm aperture, predator-proof per REQ-008) and a mesh lid straight on the top plates (no roof skeleton when `yard_roof_cover == "mesh"`). `RenderYardRoof()` (spær/lookouts/soffit/stern) is only needed for solid covers.

## Conventions

- Colors: bundled into a `palette` ctx vector. Structural wood = `pal_post(palette)`; panels = `pal_panel1`/`pal_panel2`; trim = `pal_trim`; transparent roof = `pal_polycarb`.
- Cladding: `klink_board` primitive + higher-level `clad_wall_*` modules in `lib/primitives/cladding.scad`. For `axis="Y"`, cladding thickness extends in +X — set origin X to the wall's outer face when cladding the +X side, or to `outer_x - cs_thick(clad)` when cladding the -X side.
- Mesh panels: `mesh_panel_x` / `mesh_panel_y` in `lib/primitives/mesh.scad`.
- Slope-following geometry on the gable roof: thin `polyhedron` slabs via `_sk_half_slab` (an axis-aligned cube diverges from the 35° plane). Elsewhere: `hull()` between two thin cubes at different Z heights.

## Constants prefix

Design-level constants use the `RH_` prefix (Rabbit House); gable-roof constants use `G_` — both live in `designs/config.scad`. Module names use `rh_` / `render_` lowercase prefixes; top-level entry points are `RenderHouse*` / `RenderYard*`.

Wall identifiers V1–V5 refer to **physical walls**, numbered geometrically along X: **V1**=front (house at Y=0, yard segment at Y=1000), **V2**=back (Y=3000, shared line), **V3**=left gable (X=0), **V4**=partition (X=2000), **V5**=right (X=6000). House owns V1–V4; yard owns its V1/V2 segments + V5. These are physical-wall labels, not version numbers — preserve them.
