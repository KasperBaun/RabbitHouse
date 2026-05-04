# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD model of a rabbit house — an outdoor structure for a bonded pair of pet rabbits in a Nordic / temperate-maritime climate. The repo holds **multiple designs** that share a parametric library; pick one by name in `main.scad`. All units are millimetres.

## Opening / Previewing

Open `main.scad` in OpenSCAD. Change the `design` string near the top to switch between designs. For `lean_to_v1` you can also change `v1_preset` to `"6x3"`, `"7x3"`, or `"8x4"`.

## Architecture

**Layout:**
```
main.scad                              # 3-line dispatcher
lib/
  ctx.scad                             # context-vector accessor functions
  defaults.scad                        # DEFAULT_PALETTE / CLAD / MESH / STUD
  presets.scad                         # legacy v1 size presets
  primitives/                          # cladding, mesh, roof, framing, foundation, openings
  decor/                               # rabbit, landscape, lighting, furniture
designs/
  lean_to_v1/{config,build}.scad       # original mono-pitch shed (v1)
  house_yard_v2/{config,build}.scad    # gabled house + mesh run with polycarb roof
  house_yard_v3/{config,build}.scad    # unified mono-pitch over slab-house + grass-yard on plugs
docs/
  prd.md                               # product requirements
  requirements.md                      # atomic REQ-NNN list
  superpowers/specs/                   # design specs (per-feature)
```

**Library files use `use <...>`**, designs `include <config.scad>` for their own constants.

### Convention: parameters, not globals

Every library module takes **named arguments with sensible defaults**. Things that travel together are bundled into small **ctx vectors** with accessor functions, declared in `lib/ctx.scad`:

| Vector | Slots | Accessors |
|--------|-------|-----------|
| `dims` | length, width, eave_h, base_h, wall_t | `dims_length`, `dims_width`, ... |
| `palette` | 21 named colors | `pal_post`, `pal_wall`, `pal_polycarb`, ... |
| `clad_spec` | board_h, overlap, thick, lip | `cs_board_h`, `cs_thick`, `cs_step`, ... |
| `mesh_spec` | spacing, bar, frame, depth | `ms_spacing`, `ms_bar`, ... |
| `stud_spec` | stud_w, stud_d, spacing | `ss_w`, `ss_d`, `ss_spacing` |

A design build file (e.g. `designs/house_yard_v2/build.scad`) constructs ctx vectors near the top of its build module and threads them into library calls. No library module reads file-global variables.

### Spatial layout (shared across designs)

- **Front** = Y=0 (open garden face / mesh side / human entry).
- **Back** = Y=`width` (solid cladded wall; carries prevailing-wind / driving-rain duty per REQ-016).
- **Left** = X=0, **Right** = X=`length`.
- Z up; base height = 120 mm above grade.

### Design-specific structural notes

- **lean_to_v1** — mono-pitch roof, rabbit zone X=0..rabbit_len, human seating zone after that. Roof drops `v1_roof_drop_back(width)` mm front-to-back. Back posts shorter; top beams use `hull()` between two thin cubes at the front and back heights. Mesh panels span up to the back (lowest) beam, with a wedge-shaped wood spandrel filling the triangle above.
- **house_yard_v2** — gabled solid house (X=0..2000) + polycarb-roofed mesh run (X=2000..6000). Gable ridge runs along Y at X=1000. Polycarb tucks just under the gable eave at the partition wall (X=2000) for clean flashing. Run perimeter has a 500 mm horizontal mesh apron on the three exterior sides for predator dig defence.
- **house_yard_v3** — ONE continuous mono-pitch roof over the entire 6 m × 3 m footprint, sloping front-to-back (eh_front=2600, eh_back=2200, drop=400). Foundation is a slab UNDER THE HOUSE ONLY (X=0..2000); the yard (X=2000..6000) sits on grass at grade with concrete ground plugs supporting four corner/intermediate posts. House side and partition walls are mono-pitch cladded with a sloped top beam below the roof. Yard back wall has a low solid-clad strip (driving-rain skirt) topped by a mesh ventilation band. No play-things in the yard — minimalist grass + bowls + 2 rabbits.

## Conventions

- Colors: bundled into a `palette` ctx vector. Structural wood = `pal_post(palette)`; panels = `pal_panel1`/`pal_panel2`; trim = `pal_trim`; transparent run roof = `pal_polycarb`.
- Cladding: `klink_board` primitive (horizontal overlapping board with tapered top); higher-level `clad_wall_rect`, `clad_wall_mono_pitch`, `clad_wall_gable`, `clad_wall_*_with_cutout` modules in `lib/primitives/cladding.scad`. For `axis="Y"`, cladding thickness extends in +X from the origin's X — set origin X to the wall's outer face when cladding the +X side, or to `outer_x - cs_thick(clad)` when cladding the -X side.
- Mesh panels: `mesh_panel_x` / `mesh_panel_y` in `lib/primitives/mesh.scad`.
- Roofs: `roof_mono_pitch` / `roof_gable_y` / `roof_polycarb_mono` in `lib/primitives/roof.scad`.
- Angled geometry: `hull()` between two thin cubes at different Z heights (used for sloped beams, wedge spandrels, etc.).

## Adding a new design

1. Create `designs/<name>/config.scad` with the constants for that design.
2. Create `designs/<name>/build.scad` with `module build_<name>(...)` that composes from `lib/`.
3. Add `use <designs/<name>/build.scad>` and a dispatch `if` line to `main.scad`.
4. Update this file under "Design-specific structural notes" with anything non-obvious.

## When changing v1 (`lean_to_v1`)

Test renders before and after via `openscad --viewall --autocenter -o out.png main.scad` (with `design = "lean_to_v1"`). v1 is a working historical design — keep it rendering identically unless explicitly fixing a bug.
