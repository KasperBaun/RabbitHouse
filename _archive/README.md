# `_archive/` — frozen earlier designs

Earlier iterations of the rabbit house. Preserved so they CAN be restored if needed, but they are not actively maintained and not part of the current build.

| Folder | Description |
|---|---|
| `v1/` | Original mono-pitch shed — rabbit zone + human seating zone. |
| `v2/` | Gabled solid house + mesh run with polycarb roof. |

## Restoring one of these designs

These files use relative `include`/`use` paths that pointed to `src/lib/` when they lived under `src/designs/v1/` (= `../../lib/...`). From their current location they no longer resolve.

To restore:

1. Move the folder back: `git mv _archive/v1 src/designs/v1` (or `v2`).
2. Add a dispatcher to `src/main.scad` (which currently includes only the active design directly).
3. Run OpenSCAD with the chosen design.

Lib code (`src/lib/**`) has continued to evolve since these designs were active — restoring may require also restoring or adapting library primitives the design depended on. Check the commit history of `src/lib/` if a restored design fails to render.
