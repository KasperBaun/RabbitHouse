# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD model of a rabbit house — an outdoor structure for a bonded pair of pet rabbits in a Nordic / temperate-maritime climate. All units are millimetres.

Earlier iterations (v1: mono-pitch shed; v2: gabled house + polycarb run) are frozen in `_archive/` and not part of the active build. The current design is the only one rendered.

## Opening / Previewing

Open `src/main.scad` in OpenSCAD — it includes `designs/build.scad` directly. Toggle `show_cladding`, `show_ground`, `show_cover` and pick `roof_cover` near the top of `src/designs/build.scad`.

## Architecture

**Layout:**
```
src/
  main.scad                          # viewport + single include
  lib/
    ctx.scad                         # context-vector accessor functions
    defaults.scad                    # DEFAULT_PALETTE / CLAD / MESH / STUD
    primitives/                      # cladding, mesh, roof, framing, foundation, openings, beslag, fundablok
    decor/                           # rabbit, landscape, lighting
  designs/
    config.scad                      # constants (RH_LENGTH, RH_WIDTH, ...)
    build.scad                       # top-level dispatcher (~30 lines)
    fundament.scad                   # fundablok ring + ankerskruer
    konstruktions-skelet.scad        # DPC + bundrem + reglar + framed openings + toprem
    tagkonstruktion_faelles.scad     # spær + lookouts + sofitt (cover-uafhængigt)
    tagkonstruktion_tagpap.scad      # cover A: OSB + tagpap + alu-sternkapsler
    tagkonstruktion_eternit.scad     # cover B: C18 lægter + B7 eternit
    beklaedning.scad                 # klink + afstandsliste + hjørnetrim
    aabninger.scad                   # doors + window
    inventar.scad                    # nest box, hay rack, bowls
docs/
  *.md                               # per-system build documentation
  materialeliste.xlsx                # consolidated BOM
  superpowers/specs/                 # historical design specs (one-shot)
_archive/                            # frozen earlier designs (v1, v2)
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

`designs/build.scad` constructs ctx vectors near the top of its build module and threads them into library calls. No library module reads file-global variables.

### Spatial layout

- **Front** = Y=0 (open garden face / mesh side / human entry).
- **Back** = Y=`width` (solid cladded wall; carries prevailing-wind / driving-rain duty per REQ-016).
- **Left** = X=0, **Right** = X=`length`.
- Z up; base height = 120 mm above grade.

### Structural notes

ONE continuous mono-pitch roof over the entire 6 m × 2,5 m footprint, sloping front-to-back (eh_front=2400, eh_back=2200, drop=200 over 2500 mm = 4,6° / 8 % fald for tagpap default; eh_back lowers further for eternit_10/14). The house occupies X=0..1500 (1.5 m); the yard occupies X=1500..6000 (4.5 m). Roof cover selected via the `roof_cover` parameter in `designs/build.scad` (`"tagpap_osb"` | `"eternit_b7"` | `"eternit_10"` | `"eternit_14"`).

Foundation is a continuous fundablok strip (50×20×15 cm blocks, 3 courses in halvstensforbandt = ~60 cm tall) under ALL walls — perimeter ring + cross-wall under the partition at X=hl — sitting on stabilgrus in a frostfri trench (~80 cm dig). Drawn by `fundablok_ring(ll, ww, 3, [hl])` in `lib/primitives/fundablok.scad`; top of foundation at Z=`RH_BASE_H` (120 mm above grade — sokkel-niveau where bundrem of all walls sits), ring extends 600 mm down into the trench. Use `show_ground=false` in `build.scad` to inspect the buried foundation.

House floor is `rh_stroer_floor`: 45×95 mm strøer laid flat at c/c 600 mm across the house footprint, with 18 mm krydsfiner nailed on top. The yard sits on grass at grade. The two right-end corner posts (yard NE and SE) sit on a steel post-base bracket (18 mm) directly on the fundablok ring. Yard sill plates run at Z=18..63.

House side and partition walls are mono-pitch cladded with a sloped top beam below the roof; `konstruktions-skelet.scad` also adds mineral-wool bats, vindpapir (wind barrier), losholter, vindkryds (diagonal wind bracing), and vinkelbeslag. Yard back wall has a low solid-clad strip (driving-rain skirt) topped by a mesh ventilation band.

## Conventions

- Colors: bundled into a `palette` ctx vector. Structural wood = `pal_post(palette)`; panels = `pal_panel1`/`pal_panel2`; trim = `pal_trim`; transparent run roof = `pal_polycarb`.
- Cladding: `klink_board` primitive + higher-level `clad_wall_*` modules in `lib/primitives/cladding.scad`. For `axis="Y"`, cladding thickness extends in +X — set origin X to the wall's outer face when cladding the +X side, or to `outer_x - cs_thick(clad)` when cladding the -X side.
- Mesh panels: `mesh_panel_x` / `mesh_panel_y` in `lib/primitives/mesh.scad`.
- Roofs: `roof_mono_pitch` / `roof_gable_y` / `roof_polycarb_mono` in `lib/primitives/roof.scad`.
- Angled geometry: `hull()` between two thin cubes at different Z heights.

## Constants prefix

Design-level constants use the `RH_` prefix (Rabbit House) to avoid collision with library `DEFAULT_*` globals — e.g., `RH_LENGTH`, `RH_BASE_H`, `RH_OH_FRONT`. Module names use `rh_` lowercase prefix (e.g., `rh_spaer`, `rh_beklaedning`).

Wall identifiers V1/V2/V3/V4/V5 in `konstruktions-skelet.scad` refer to **physical walls** (front/back/sides/partition), not version numbers — preserve these labels.
