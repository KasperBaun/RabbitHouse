// Openings: yard door, internal door, side window — frames, leaves/plexi,
// hardware. Renders the opening units themselves; the structural framing
// (jamb studs, header, cripples, rough sill) lives in framing.scad.
//
// The pet opening in the partition is intentionally empty here — it is
// just a rough opening in the skeleton, ready for a standard cat-door to
// drop in. No geometry rendered for it.

include <../lib/defaults.scad>
include <config.scad>

FRAME_T         = 50;            // door frame timber thickness
LEAF_T          = 40;            // door leaf thickness
THRESHOLD_H     = 30;            // yard door threshold height

WALL_DEPTH      = RH_POST_W;     // 95 — stud depth
FLOOR_Z         = RH_FLOOR_TOP;  // 167 — top of sill plate

PARTITION_X     = RH_HOUSE_LEN;
PART_OUTER_X    = PARTITION_X + WALL_DEPTH/2;   // yard-side outer face
PART_INNER_X    = PARTITION_X - WALL_DEPTH/2;   // house-side outer face

// Side window: a 6 mm plexi sheet screwed outside the rough opening,
// overlapping jamb + header + rough sill by PLEXI_OVERLAP on every side
// so there's wood to screw through. No frame, muntins, or drip cap — it's
// a rabbit shed, not a Danish window-nerd showpiece.
PLEXI_T         = 6;
PLEXI_OVERLAP   = 30;

PLEXI_C         = [0.88, 0.94, 0.96, 0.50];
HINGE_C         = [0.30, 0.30, 0.32];
HANDLE_C        = [0.85, 0.85, 0.88];

// ----------------------------------------------------------------------------
// 1. Yard door — front wall V1, faces -Y, opens outward.
// Mesh-in-frame leaf with a mid-rail.
// ----------------------------------------------------------------------------
module render_yard_door(mesh, palette) {
    x0 = RH_YARD_DOOR_X;
    x1 = x0 + RH_YARD_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + RH_YARD_DOOR_H;

    // Frame (4 pieces inside the rough opening)
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

    // Leaf (mesh-in-frame, opens -Y; here shown closed flush with outer wall)
    leaf_x0 = x0 + FRAME_T;
    leaf_x1 = x1 - FRAME_T;
    leaf_w  = leaf_x1 - leaf_x0;
    leaf_z0 = z0 + THRESHOLD_H;
    leaf_z1 = z1 - FRAME_T;
    leaf_h  = leaf_z1 - leaf_z0;
    leaf_y  = 5;                                 // 5 mm inset from outer wall
    fr      = 50;                                // leaf frame width
    mid_z   = leaf_z0 + RH_MID_RAIL_Z_OFFSET;

    color(pal_post(palette)) {
        translate([leaf_x0, leaf_y, leaf_z0])         cube([leaf_w, LEAF_T, fr]);
        translate([leaf_x0, leaf_y, leaf_z1 - fr])    cube([leaf_w, LEAF_T, fr]);
        translate([leaf_x0, leaf_y, leaf_z0])         cube([fr, LEAF_T, leaf_h]);
        translate([leaf_x1 - fr, leaf_y, leaf_z0])    cube([fr, LEAF_T, leaf_h]);
        translate([leaf_x0, leaf_y, mid_z - fr/2])    cube([leaf_w, LEAF_T, fr]);
    }

    // Mesh in two bands (above and below the mid-rail)
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

    // Hardware (handle + hinges on -Y face)
    color(HANDLE_C) {
        translate([leaf_x1 - 90, leaf_y - 25, z0 + 1050])    cube([60, 25, 25]);
        translate([leaf_x1 - 100, leaf_y - 6,  z0 + 1000])   cube([80,  8, 110]);
    }
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 350])
        translate([leaf_x0 - 8, leaf_y - 8, zh])
            cube([15, 8, 100]);
}

// ----------------------------------------------------------------------------
// 2. Internal door in the partition — V5, faces +X (into yard), opens
// into yard. Solid leaf with 4 panel grooves.
// ----------------------------------------------------------------------------
module render_human_door(palette) {
    y0 = RH_HOUSE_DOOR_Y;
    y1 = y0 + RH_HOUSE_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + RH_HOUSE_DOOR_H;

    // Frame (3 pieces — top + 2 sides, no threshold for internal door)
    color(pal_post(palette)) {
        translate([PART_INNER_X, y0, z1 - FRAME_T])
            cube([WALL_DEPTH, RH_HOUSE_DOOR_W, FRAME_T]);
        side_h = RH_HOUSE_DOOR_H - FRAME_T;
        translate([PART_INNER_X, y0, z0])
            cube([WALL_DEPTH, FRAME_T, side_h]);
        translate([PART_INNER_X, y1 - FRAME_T, z0])
            cube([WALL_DEPTH, FRAME_T, side_h]);
    }

    // Leaf (centred in wall, opens +X)
    leaf_y0 = y0 + FRAME_T;
    leaf_y1 = y1 - FRAME_T;
    leaf_w  = leaf_y1 - leaf_y0;
    leaf_h  = RH_HOUSE_DOOR_H - FRAME_T;
    leaf_x  = PARTITION_X - LEAF_T/2;

    color(pal_door(palette))
    translate([leaf_x, leaf_y0, z0])
        cube([LEAF_T, leaf_w, leaf_h]);

    // 4 horizontal panel grooves on +X face of the leaf
    color(pal_trim(palette))
    for (i = [0 : 3])
        translate([leaf_x + LEAF_T - 1, leaf_y0 + 50, z0 + 200 + i * 400])
            cube([2, leaf_w - 100, 30]);

    // Hardware (+X side, handle on right side of door)
    color(HANDLE_C) {
        translate([leaf_x + LEAF_T,     leaf_y1 - 100, z0 + 1050])  cube([25, 60, 25]);
        translate([leaf_x + LEAF_T + 3, leaf_y1 - 110, z0 + 1000])  cube([ 8, 80, 110]);
    }
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 350])
        translate([leaf_x - 5, leaf_y0 + 5, zh])
            cube([15, 8, 100]);
}

// ----------------------------------------------------------------------------
// 3. Side window — left wall V3, faces -X. Just a 6 mm plexi sheet screwed
// outside the rough opening; overlaps jamb + header + rough sill by
// PLEXI_OVERLAP on every side.
// ----------------------------------------------------------------------------
module render_side_window() {
    y0 = RH_SIDE_WIN_Y - PLEXI_OVERLAP;
    y1 = RH_SIDE_WIN_Y + RH_SIDE_WIN_W + PLEXI_OVERLAP;
    z0 = FLOOR_Z + RH_SIDE_WIN_Z - PLEXI_OVERLAP;
    z1 = FLOOR_Z + RH_SIDE_WIN_Z + RH_SIDE_WIN_H + PLEXI_OVERLAP;

    color(PLEXI_C)
    translate([-PLEXI_T, y0, z0])
        cube([PLEXI_T, y1 - y0, z1 - z0]);
}

// ----------------------------------------------------------------------------
// Entry point — composes the 3 opening units.
// The pet opening in the partition stays empty (rough opening in the
// skeleton, a commercial cat-door slots straight in).
// ----------------------------------------------------------------------------
module RenderOpenings(mesh = RH_MESH, palette = DEFAULT_PALETTE) {
    render_yard_door(mesh, palette);
    render_human_door(palette);
    render_side_window();
}
