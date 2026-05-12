# OpenSCAD rabbit house

Parametric model of an outdoor rabbit house + run, sized for a bonded pair of pet rabbits in a Nordic / temperate-maritime climate. All units are millimetres.

## How to use

Open `src/main.scad` in OpenSCAD. The model renders directly. Toggle `show_cladding` and `show_ground` near the top of `src/designs/build.scad` to inspect framing or buried foundation; switch `roof_cover` between `"tagpap_osb"`, `"eternit_b7"`, `"eternit_10"`, `"eternit_14"`.

## File overview

- `src/main.scad` — entry point (viewport + include of `designs/build.scad`).
- `src/designs/` — the active design (build, config, fundament, konstruktions-skelet, tagkonstruktion variants, beklaedning, aabninger, inventar).
- `src/lib/ctx.scad` — context-vector accessors (dims, palette, clad/mesh/stud specs).
- `src/lib/defaults.scad` — `DEFAULT_PALETTE`, `DEFAULT_CLAD`, `DEFAULT_MESH`, `DEFAULT_STUD`.
- `src/lib/primitives/` — cladding, mesh, roof shapes, framing, openings, foundation, beslag, fundablok.
- `src/lib/decor/` — rabbits, accessories, landscape, lighting.
- `docs/` — per-system build documentation + cut lists + material lists.
- `_archive/` — earlier designs (v1, v2). Not part of the current build; see `_archive/README.md` to restore.
