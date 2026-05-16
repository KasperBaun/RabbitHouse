// YARD openings — yard door in V1 (front, X=3000+, faces -Y, opens outward).
// Self-contained: zone-specific geometry only.

include <../../lib/defaults.scad>
include <../config.scad>

FRAME_T       = 50;
LEAF_T        = 40;
THRESHOLD_H   = 30;

WALL_DEPTH    = RH_POST_W;
FLOOR_Z       = RH_FLOOR_TOP;

HINGE_C       = [0.30, 0.30, 0.32];
HANDLE_C      = [0.85, 0.85, 0.88];

// Yard door — mesh-in-frame leaf with a mid-rail.
module _render_yard_door(mesh, palette) {
    x0 = RH_YARD_DOOR_X;
    x1 = x0 + RH_YARD_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + RH_YARD_DOOR_H;

    color(pal_post(palette)) {
        translate([x0, 0, z0])
            cube([RH_YARD_DOOR_W, WALL_DEPTH, THRESHOLD_H]);
        translate([x0, 0, z1 - FRAME_T])
            cube([RH_YARD_DOOR_W, WALL_DEPTH, FRAME_T]);
        side_h = RH_YARD_DOOR_H - THRESHOLD_H - FRAME_T;
        translate([x0, 0, z0 + THRESHOLD_H])
            cube([FRAME_T, WALL_DEPTH, side_h]);
        translate([x1 - FRAME_T, 0, z0 + THRESHOLD_H])
            cube([FRAME_T, WALL_DEPTH, side_h]);
    }

    leaf_x0 = x0 + FRAME_T;
    leaf_x1 = x1 - FRAME_T;
    leaf_w  = leaf_x1 - leaf_x0;
    leaf_z0 = z0 + THRESHOLD_H;
    leaf_z1 = z1 - FRAME_T;
    leaf_h  = leaf_z1 - leaf_z0;
    leaf_y  = 5;
    fr      = 50;
    mid_z   = leaf_z0 + RH_MID_RAIL_Z_OFFSET;

    color(pal_post(palette)) {
        translate([leaf_x0, leaf_y, leaf_z0])         cube([leaf_w, LEAF_T, fr]);
        translate([leaf_x0, leaf_y, leaf_z1 - fr])    cube([leaf_w, LEAF_T, fr]);
        translate([leaf_x0, leaf_y, leaf_z0])         cube([fr, LEAF_T, leaf_h]);
        translate([leaf_x1 - fr, leaf_y, leaf_z0])    cube([fr, LEAF_T, leaf_h]);
        translate([leaf_x0, leaf_y, mid_z - fr/2])    cube([leaf_w, LEAF_T, fr]);
    }

    mb = ms_bar(mesh); sp = ms_spacing(mesh);
    color(pal_mesh(palette))
    for (band = [[leaf_z0 + fr,  mid_z - fr/2],
                 [mid_z + fr/2,  leaf_z1 - fr]]) {
        zlo = band[0]; zhi = band[1];
        for (xx = [leaf_x0 + fr + sp/2 : sp : leaf_x1 - fr - sp/2])
            translate([xx - mb/2, leaf_y + LEAF_T/2 - mb/2, zlo])
                cube([mb, mb, zhi - zlo]);
        for (zz = [zlo + sp/2 : sp : zhi - sp/2])
            translate([leaf_x0 + fr, leaf_y + LEAF_T/2 - mb/2, zz - mb/2])
                cube([leaf_w - 2*fr, mb, mb]);
    }

    color(HANDLE_C) {
        translate([leaf_x1 - 90, leaf_y - 25, z0 + 1050])    cube([60, 25, 25]);
        translate([leaf_x1 - 100, leaf_y - 6,  z0 + 1000])   cube([80,  8, 110]);
    }
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 350])
        translate([leaf_x0 - 8, leaf_y - 8, zh])
            cube([15, 8, 100]);
}

module RenderYardOpenings(mesh = RH_MESH, palette = DEFAULT_PALETTE) {
    _render_yard_door(mesh, palette);
}
