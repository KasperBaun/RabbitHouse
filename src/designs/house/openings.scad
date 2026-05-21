// HOUSE openings — human door in the partition (V5) and the side window
// in V3. Self-contained: zone-specific geometry only.

include <../../lib/defaults.scad>
include <../config.scad>

FRAME_T       = 50;
LEAF_T        = 40;

WALL_DEPTH    = RH_POST_W;
FLOOR_Z       = RH_FLOOR_TOP;

PARTITION_X   = RH_HOUSE_LEN;
// V5 wall sits inside the foundation (X=hl-WALL_DEPTH..hl), so the door
// frame's inner X face = wall inner face = hl - WALL_DEPTH.
PART_INNER_X  = PARTITION_X - WALL_DEPTH;

PLEXI_T       = 6;
PLEXI_OVERLAP = 30;
PLEXI_C       = [0.88, 0.94, 0.96, 0.50];
HINGE_C       = [0.30, 0.30, 0.32];
HANDLE_C      = [0.85, 0.85, 0.88];

// Internal human door in V5, faces +X (into yard), opens into yard.
module _render_human_door(palette) {
    y0 = RH_HOUSE_DOOR_Y;
    y1 = y0 + RH_HOUSE_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + RH_HOUSE_DOOR_H;

    color(pal_post(palette)) {
        translate([PART_INNER_X, y0, z1 - FRAME_T])
            cube([WALL_DEPTH, RH_HOUSE_DOOR_W, FRAME_T]);
        side_h = RH_HOUSE_DOOR_H - FRAME_T;
        translate([PART_INNER_X, y0, z0])
            cube([WALL_DEPTH, FRAME_T, side_h]);
        translate([PART_INNER_X, y1 - FRAME_T, z0])
            cube([WALL_DEPTH, FRAME_T, side_h]);
    }

    leaf_y0 = y0 + FRAME_T;
    leaf_y1 = y1 - FRAME_T;
    leaf_w  = leaf_y1 - leaf_y0;
    leaf_h  = RH_HOUSE_DOOR_H - FRAME_T;
    // Leaf hung flush with V5's yard-facing face (X=PARTITION_X), opening
    // outward into the yard.
    leaf_x  = PARTITION_X - LEAF_T;

    color(pal_door(palette))
    translate([leaf_x, leaf_y0, z0])
        cube([LEAF_T, leaf_w, leaf_h]);

    color(pal_trim(palette))
    for (i = [0 : 3])
        translate([leaf_x + LEAF_T - 1, leaf_y0 + 50, z0 + 200 + i * 400])
            cube([2, leaf_w - 100, 30]);

    color(HANDLE_C) {
        translate([leaf_x + LEAF_T,     leaf_y1 - 100, z0 + 1050])  cube([25, 60, 25]);
        translate([leaf_x + LEAF_T + 3, leaf_y1 - 110, z0 + 1000])  cube([ 8, 80, 110]);
    }
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 350])
        translate([leaf_x - 5, leaf_y0 + 5, zh])
            cube([15, 8, 100]);
}

// Side window — 6 mm plexi screwed outside V3's rough opening.
module _render_side_window() {
    y0 = RH_SIDE_WIN_Y - PLEXI_OVERLAP;
    y1 = RH_SIDE_WIN_Y + RH_SIDE_WIN_W + PLEXI_OVERLAP;
    z0 = FLOOR_Z + RH_SIDE_WIN_Z - PLEXI_OVERLAP;
    z1 = FLOOR_Z + RH_SIDE_WIN_Z + RH_SIDE_WIN_H + PLEXI_OVERLAP;
    color(PLEXI_C)
    translate([-PLEXI_T, y0, z0])
        cube([PLEXI_T, y1 - y0, z1 - z0]);
}

module RenderHouseOpenings(palette = DEFAULT_PALETTE) {
    _render_human_door(palette);
    _render_side_window();
}
