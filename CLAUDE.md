# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD model of a rabbit house — an outdoor structure for a bonded pair of pet rabbits in a Nordic / temperate-maritime climate. All units are millimetres.

Earlier iterations (v1: mono-pitch shed; v2: gabled house + polycarb run) are frozen in `_archive/` and not part of the active build. The current design is the only one rendered.

## Opening / Previewing

Open `src/main.scad` in OpenSCAD — it is the top-level dispatcher, organised into `// shared`, `// house`, and `// yard` sections. Toggle individual `Render*()` calls and pick `roof_cover` / `cladding_type` near the top of the file.

## House / yard split

Code AND the BOM/skæreliste are split into two zones at **X = RH_HOUSE_LEN (1500 mm)**:

| Zone   | Footprint        | What it owns                                                                 |
| ------ | ---------------- | ---------------------------------------------------------------------------- |
| House  | X = 0..1500      | V3 (left), V4 (partition) — entire walls; V1+V2 segments [0..hl]; junction stud at X=hl; left-side roof overhang + lookouts + side fascia + soffit; human door + side window; cladding (all 4 house walls); foundation under house walls + V4 cross; cover plates over house segment. |
| Yard   | X = 1500..6000   | V5 (right) — entire wall; V1+V2 segments [hl..ll]; right-side roof overhang + lookouts + side fascia + soffit; yard door; mesh on front/back/right; foundation under yard 3 sides (left side = V4 = house in combined); cover plates over yard segment. |
| Shared | —                | Ground; murpap til tagfod; small fastener packages (skruer, søm). Foundation V4 cross-wall is owned by house (when standalone yard is built, set `RenderYardFoundation(standalone=true)` to add its own left strip). Cover plates split at X=hl with wave phase alignment for eternit (1720 mm = 10 × B7_PITCH). |

Each zone folder (`designs/house/`, `designs/yard/`) exposes its own `RenderHouse*()` / `RenderYard*()` entry point per building system. Folders are independent — helpers are duplicated rather than shared. `RenderRoofPlates(cover)` stays at the root of `designs/` because the cover layers can't be cleanly split at the partition line.

## Architecture

**Layout:**
```
src/
  main.scad                          # viewport + top-level dispatcher (Render*() calls)
  lib/
    ctx.scad                         # context-vector accessor functions
    defaults.scad                    # DEFAULT_PALETTE / CLAD / MESH / STUD
    primitives/                      # cladding, mesh, roof, framing, foundation, openings, beslag, fundablok
    decor/                           # rabbit, landscape, lighting, furniture
  designs/
    config.scad                      # constants (RH_LENGTH, RH_WIDTH, ...)
    ground.scad                      # SHARED — grass / terrain
    roof_plates.scad                 # SHARED — combined-cover dispatcher (back-compat)
    roof_plates_tagpap.scad          # variant — OSB + tagpap + alu-sternkapsler (parameterised x_lo/x_hi)
    roof_plates_eternit.scad         # variant — C18 lægter + eternit (parameterised x_lo/x_hi)
    interior.scad                    # SHARED — nest box, hay rack, bowls
    house/                           # HUS-zone (X = 0..1500) — buildable standalone
      foundation.scad                # RenderHouseFoundation — perimeter + V4 cross
      framing.scad                   # RenderHouseFraming — V1[0..hl] + V2[0..hl] + V3 + V4 + junction-stud
      openings.scad                  # RenderHouseOpenings — human-dør + side-vindue
      roof.scad                      # RenderHouseRoof — spær X<=1200 + venstre lookouts + venstre fascia/soffit
      roof_plates.scad               # RenderHouseRoofPlates(cover, standalone) — house cover segment
      cladding/
        cladding.scad                # RenderHouseCladding — dispatcher (klink | board_on_board)
        cladding_common.scad         # housewrap + corner-trim + counter-batten primitives (generic)
        cladding_klink.scad          # klink renderer + entry
        cladding_board_on_board.scad # board-on-board renderer + entry
    yard/                            # YARD-zone (X = 1500..6000) — standalone needs `standalone=true` flags
      foundation.scad                # RenderYardFoundation(standalone)
      framing.scad                   # RenderYardFraming — V1[hl..ll] + V2[hl..ll] + V5
      openings.scad                  # RenderYardOpenings — yard-dør
      roof.scad                      # RenderYardRoof — spær X>=1800 + højre lookouts + højre fascia/soffit
      roof_plates.scad               # RenderYardRoofPlates(cover, standalone) — yard cover segment
      mesh.scad                      # RenderYardMesh — voliere på front + bag + højre
docs/
  *.md                               # per-system build documentation
  materialeliste.xlsx                # consolidated BOM (Zone-kolonne: Hus | Yard | Fælles)
  superpowers/specs/                 # historical design specs (one-shot)
_archive/                            # frozen earlier designs (v1, v2)
```

**Each zone folder is self-contained** — `house/framing.scad`, `house/roof.scad`, `house/foundation.scad` and the yard equivalents each carry their own DPC/sill/stud/top-plate/rafter/lookout/soffit/fascia/strip helpers. Cover plates use shared variant files at `designs/roof_plates_*.scad` parameterised with `x_lo/x_hi`, and zone-specific `house/roof_plates.scad` / `yard/roof_plates.scad` dispatchers pass the right X range. Cladding is house-only and bundled in `house/cladding/`. `RenderHouseRoofPlates` and `RenderYardRoofPlates` each accept a `standalone=true` flag to render the missing-half overhang + side fascia when building one zone alone.

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

`src/main.scad` constructs ctx vectors near the top and threads them into library calls. No library module reads file-global variables.

### Spatial layout

- **Front** = Y=0 (open garden face / mesh side / human entry).
- **Back** = Y=`width` (solid cladded wall; carries prevailing-wind / driving-rain duty per REQ-016).
- **Left** = X=0, **Right** = X=`length`.
- Z up; base height = 120 mm above grade.

### Structural notes

ONE continuous mono-pitch roof over the entire 6 m × 2,5 m footprint, sloping front-to-back (eh_front=2400, eh_back=2200, drop=200 over 2500 mm = 4,6° / 8 % fald for tagpap default; eh_back lowers further for eternit_10/14). The house occupies X=0..1500 (1.5 m); the yard occupies X=1500..6000 (4.5 m). Roof cover selected via the `roof_cover` parameter in `src/main.scad` (`"tagpap_osb"` | `"eternit_b7"` | `"eternit_10"` | `"eternit_14"`).

Foundation is a continuous fundablok strip (50×20×15 cm blocks, 3 courses in halvstensforbandt = ~60 cm tall) under ALL walls — house perimeter + V4 partition cross + yard 3-side perimeter — sitting on stabilgrus in a frostfri trench (~80 cm dig). Drawn zone-by-zone via `RenderHouseFoundation()` + `RenderYardFoundation()` (each using the shared `fundablok_strip` primitive in `lib/primitives/fundablok.scad`); top of foundation at Z=`RH_BASE_H` (120 mm above grade — sokkel-niveau where bundrem of all walls sits), ring extends 600 mm down into the trench. Comment out `RenderGround()` in `main.scad` (under `// shared`) to inspect the buried foundation.

House floor is `rh_stroer_floor`: 45×95 mm strøer laid flat at c/c 600 mm across the house footprint, with ~25 mm sawn boards nailed on top. The yard sits on grass at grade. The two right-end corner posts (yard NE and SE) sit on a steel post-base bracket (18 mm) directly on the fundablok ring. Yard sill plates run at Z=18..63.

House side and partition walls are mono-pitch cladded with a sloped top beam below the roof. `house/framing.scad` renders only the structural skeleton — DPC, sill plate, studs (incl. junction studs at X=hl), top plate, jamb studs and framed openings. Mineral-wool insulation, dampspærre, losholter and vindkryds are intentionally not rendered (the wool is on the BOM under cladding). Vindpapir (housewrap) belongs to the cladding stack and lives in `house/cladding/cladding_common.scad`.

## Conventions

- Colors: bundled into a `palette` ctx vector. Structural wood = `pal_post(palette)`; panels = `pal_panel1`/`pal_panel2`; trim = `pal_trim`; transparent run roof = `pal_polycarb`.
- Cladding: `klink_board` primitive + higher-level `clad_wall_*` modules in `lib/primitives/cladding.scad`. For `axis="Y"`, cladding thickness extends in +X — set origin X to the wall's outer face when cladding the +X side, or to `outer_x - cs_thick(clad)` when cladding the -X side.
- Mesh panels: `mesh_panel_x` / `mesh_panel_y` in `lib/primitives/mesh.scad`.
- Roofs: `roof_mono_pitch` / `roof_gable_y` / `roof_polycarb_mono` in `lib/primitives/roof.scad`.
- Angled geometry: `hull()` between two thin cubes at different Z heights.

## Constants prefix

Design-level constants use the `RH_` prefix (Rabbit House) to avoid collision with library `DEFAULT_*` globals — e.g., `RH_LENGTH`, `RH_BASE_H`, `RH_OH_FRONT`. Module names use `rh_` lowercase prefix (e.g., `rh_spaer`, `rh_beklaedning`).

Wall identifiers V1–V5 refer to **physical walls**, numbered geometrically along X: **V1**=front, **V2**=back, **V3**=left gable (X=0), **V4**=partition (X=hl), **V5**=right gable (X=ll). House owns V1, V2, V3, V4; yard owns V1, V2, V5. These are physical-wall labels, not version numbers — preserve them.
