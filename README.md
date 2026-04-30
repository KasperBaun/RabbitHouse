# Modular OpenSCAD rabbit house

Two designs share one parametric library and a common `main.scad` dispatcher.

## How to use

1. Open `main.scad` in OpenSCAD.
2. Set the `design` variable near the top:
   - `"house_yard_v2"` — current default. Gabled solid rabbit shelter (2 m × 3 m) on the left, mesh-walled run with twin-wall polycarbonate roof (4 m × 3 m) on the right. Total footprint 6 m × 3 m.
   - `"lean_to_v1"` — original mono-pitch shed with rabbit zone + human seating area. For this design also pick `v1_preset` from `"6x3"`, `"7x3"`, `"8x4"`.

## File overview

- `main.scad` — top-level dispatcher.
- `lib/ctx.scad` — context-vector accessors (dims, palette, clad/mesh/stud specs).
- `lib/defaults.scad` — `DEFAULT_PALETTE`, `DEFAULT_CLAD`, `DEFAULT_MESH`, `DEFAULT_STUD`.
- `lib/presets.scad` — legacy v1 size-preset lookup.
- `lib/primitives/` — cladding, mesh, roof shapes, framing, openings, foundation.
- `lib/decor/` — rabbits, accessories, landscape, lighting, v1 furniture.
- `designs/lean_to_v1/` — v1 build composition.
- `designs/house_yard_v2/` — v2 build composition.
- `docs/prd.md` — product requirements doc.
- `docs/requirements.md` — atomic REQ-NNN list.
- `docs/superpowers/specs/` — per-feature design specs.

## Adding a design

See `CLAUDE.md` → "Adding a new design".
