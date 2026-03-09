# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD model of a rabbit house — a dual-purpose outdoor structure with a mesh-enclosed rabbit area (left/front) and a human seating area with built-in furniture (right). All units are millimeters.

## Opening / Previewing

Open `main.scad` in OpenSCAD. It includes all files and calls `build_rabbit_house()`. To switch size presets, change `preset` in `config.scad` to `"6x3"`, `"7x3"`, or `"8x4"`.

## Architecture

**Include chain:** `main.scad` → `presets.scad` → `config.scad` → helpers → modules → `build_rabbit_house()`

**No parameter passing.** All modules read global variables from `config.scad` directly. This is intentional — it keeps module signatures clean given OpenSCAD's limitations.

### Key directories

- `helpers/` — Reusable building blocks: colors, mesh panels, cladding boards, roof geometry
- `modules/` — Structural components: base/floor, walls/framing, seating furniture, final assembly (`build.scad`)

### Spatial layout

- **Front** = Y=0, **Back** = Y=shed_width (solid cladded wall, lower roof line)
- **Left** = X=0 (rabbit mesh side), **Right** = X=shed_length (seating side with lower cladding + upper mesh)
- Rabbit area: X from 0 to `rabbit_len`. Seating area: X from `rabbit_len` to `shed_length`.

### Roof slope

The roof is a mono-pitch (lean-to) sloping from front to back by `roof_drop_back`. Any element spanning front-to-back must account for this — back posts are shorter, top beams use `hull()` to slope, and mesh panels are sized to fit under the back (lowest) beam height with wedge-shaped wood spandrels filling the triangular gap above.

## Conventions

- Colors: `col_` prefix, defined in `helpers/colors.scad`. Structural wood = `col_post`, panels = `col_wall`, trim = `col_trim`.
- Mesh panels: `mesh_panel_x()` and `mesh_panel_y()` in `helpers/mesh.scad` — parametric panels with frame + grid bars in two orientations.
- Cladding: horizontal overlapping boards with alternating `col_panel1`/`col_panel2`.
- Angled geometry uses `hull()` between two thin cubes at different Z heights.
- Width-dependent values (bench depth, cladding height, roof drop) use ternary on `shed_width >= 4000`.
