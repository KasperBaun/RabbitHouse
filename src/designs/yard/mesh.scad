// Yard mesh — frameless welded wire stretched on the OUTER face of the
// 45x95 yard reglar. 1/2" x 1" ~ 13 mm x 1 mm wire (RH_MESH_*). Three walls:
//   front (Y=yo)    — two bands, one on each side of the yard door
//   back  (Y=yo+yd) — single band, flat LOW
//   right (X=ll)    — sloped top, HIGH (Y=yo) to LOW (Y=yo+yd)
// Mesh stops at top-plate underside; anything above (between rafters) is
// the roof's territory. yo=RH_YARD_Y_OFFSET, yd=RH_YARD_DEPTH.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/mesh.scad>

module RenderYardMesh(mesh = RH_MESH, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; yd = RH_YARD_DEPTH; hl = RH_HOUSE_LEN;
    yo = RH_YARD_Y_OFFSET;
    bh = RH_BASE_H;

    OUT = 1;   // mesh plane 1 mm outside the stud face
    z_base = RH_YARD_SILL_TOP;

    // Yard mesh tops to the underside of YARD's (lower) top plate.
    PLATE_H = RH_SILL_H;
    z_top_front = bh + RH_YARD_EH_FRONT - PLATE_H;
    z_top_back  = bh + RH_YARD_EH_BACK  - PLATE_H;
    h_front = z_top_front - z_base;
    h_back  = z_top_back  - z_base;

    // Front (faces -Y) — two bands around the yard door
    door_x0 = RH_YARD_DOOR_X;
    door_x1 = RH_YARD_DOOR_X + RH_YARD_DOOR_W;
    voliere_x(hl,      door_x0 - hl, z_base, h_front, yo - OUT,
              palette=palette, mesh=mesh);
    voliere_x(door_x1, ll - door_x1, z_base, h_front, yo - OUT,
              palette=palette, mesh=mesh);

    // Back (faces +Y) — single band, flat LOW
    voliere_x(hl, ll - hl, z_base, h_back, yo + yd + OUT,
              palette=palette, mesh=mesh);

    // Right (faces +X) — sloped top HIGH -> LOW. Mesh stretches the full
    // yard Y-range yo..yo+yd along the outside; voliere_y_sloped takes
    // (y_start, length).
    voliere_y_sloped(yo, yd, z_base, z_top_front, z_top_back, ll + OUT,
                     palette=palette, mesh=mesh);
}
