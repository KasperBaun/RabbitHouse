// HOUSE openings — front entry door + 2 windows on V1, human door in the
// partition (V4). Self-contained: zone-specific geometry only.

include <../../lib/defaults.scad>
include <../config.scad>

FRAME_T       = 50;
LEAF_T        = 40;
GLASS_T       = 4;

WALL_DEPTH    = RH_POST_W;
FLOOR_Z       = RH_FLOOR_TOP;

PARTITION_X   = RH_HOUSE_LEN;
// V4 wall sits inside the foundation (X=hl-WALL_DEPTH..hl), so the door
// frame's inner X face = wall inner face = hl - WALL_DEPTH.
PART_INNER_X  = PARTITION_X - WALL_DEPTH;

// Klink cladding outer-face offset past the stud face (housewrap 1 + batten
// 22 + klink 25). Door leaves sit flush with this plane so the casing
// (indfatning) doesn't leave a deep empty reveal.
CLAD_FACE     = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + 25;

HINGE_C       = [0.18, 0.18, 0.20];
HANDLE_C      = [0.18, 0.18, 0.20];
GLASS_C       = [0.55, 0.75, 0.85, 0.45];

// Internal human door in V4, faces +X (into yard), opens into yard.
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

    // Leaf fills the whole opening and sits just proud of the klink face
    // (like the V1 front door), so the casing laps straight onto it — no
    // recessed reveal. `w` = opening width. Faces +X, opens into the yard.
    w       = RH_HOUSE_DOOR_W;
    leaf_xf = PARTITION_X + CLAD_FACE + 2;   // outer (+X) face, just proud

    color(pal_door(palette))
    translate([leaf_xf - LEAF_T, y0, z0])
        cube([LEAF_T, w, RH_HOUSE_DOOR_H]);

    // Horizontal batten strips on the outer face — same look as V1 door.
    color(pal_trim(palette))
    for (i = [0 : 4])
        translate([leaf_xf - 1, y0 + 80, z0 + 200 + i * 400])
            cube([2, w - 160, 30]);

    // Handle — vertical bar near the latch (y1) edge, mid-height.
    color(HANDLE_C) {
        translate([leaf_xf - 5, y1 - 110, z0 + 950])  cube([30, 25, 150]);
        translate([leaf_xf,     y1 - 115, z0 + 990])  cube([12, 35, 70]);
    }
    // Hinges — 2 straps on the y0 (hinge) edge.
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 300])
        translate([leaf_xf - 3, y0 + 20, zh])
            cube([8, 110, 40]);
}

// Front entry door on V1, faces -Y (out into garden). Single solid leaf,
// styled like the V4 human door (plain slab + horizontal batten strips +
// handle). The leaf's outer face sits flush with the klink face so the
// casing frames it with no deep empty reveal. Opens outward on 2 hinges.
module _render_front_door(palette) {
    x0 = RH_FRONT_DOOR_X;
    x1 = x0 + RH_FRONT_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + RH_FRONT_DOOR_H;

    // Frame — header + two jambs filling the wall depth.
    color(pal_post(palette)) {
        translate([x0, 0, z1 - FRAME_T])
            cube([RH_FRONT_DOOR_W, WALL_DEPTH, FRAME_T]);
        side_h = RH_FRONT_DOOR_H - FRAME_T;
        translate([x0, 0, z0])
            cube([FRAME_T, WALL_DEPTH, side_h]);
        translate([x1 - FRAME_T, 0, z0])
            cube([FRAME_T, WALL_DEPTH, side_h]);
    }

    // Leaf fills the whole opening and sits just proud of the klink face, so
    // the casing laps straight onto it — no recessed frame reveal to show the
    // cut cladding layers. `w`/`h` = opening width/height.
    w       = RH_FRONT_DOOR_W;
    leaf_yf = -CLAD_FACE - 2;  // outer face just proud of the klink face

    color(pal_door(palette))
    translate([x0, leaf_yf, z0])
        cube([w, LEAF_T, RH_FRONT_DOOR_H]);

    // Horizontal batten strips on the outer face — same look as V4 door.
    color(pal_trim(palette))
    for (i = [0 : 4])
        translate([x0 + 80, leaf_yf - 1, z0 + 200 + i * 400])
            cube([w - 160, 2, 30]);

    // Handle — vertical bar near the right (latch) edge, mid-height.
    color(HANDLE_C) {
        translate([x1 - 110, leaf_yf - 25, z0 + 950])  cube([25, 25, 150]);
        translate([x1 - 115, leaf_yf - 12, z0 + 990])  cube([35, 12, 70]);
    }
    // Hinges — 2 straps on the left (hinge) edge.
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 300])
        translate([x0 + 20, leaf_yf - 3, zh])
            cube([110, 8, 40]);
}

// Generic V1 window — frame inside wall depth + glass pane.
module _render_front_window(x_opening, palette) {
    x0 = x_opening;
    x1 = x0 + RH_FRONT_WIN_W;
    z0 = FLOOR_Z + RH_FRONT_WIN_Z;
    z1 = z0 + RH_FRONT_WIN_H;

    color(pal_post(palette)) {
        // Top + bottom of frame
        translate([x0, 0, z1 - FRAME_T])
            cube([RH_FRONT_WIN_W, WALL_DEPTH, FRAME_T]);
        translate([x0, 0, z0])
            cube([RH_FRONT_WIN_W, WALL_DEPTH, FRAME_T]);
        // Sides
        side_h = RH_FRONT_WIN_H - 2 * FRAME_T;
        translate([x0, 0, z0 + FRAME_T])
            cube([FRAME_T, WALL_DEPTH, side_h]);
        translate([x1 - FRAME_T, 0, z0 + FRAME_T])
            cube([FRAME_T, WALL_DEPTH, side_h]);
    }

    // Glass pane — flush with outer wall face.
    glass_w = RH_FRONT_WIN_W - 2 * FRAME_T;
    glass_h = RH_FRONT_WIN_H - 2 * FRAME_T;
    color(GLASS_C)
    translate([x0 + FRAME_T, -GLASS_T, z0 + FRAME_T])
        cube([glass_w, GLASS_T, glass_h]);
}

// Side window on V3 (left wall, X=0, faces -X). Frame fills the wall depth
// in +X; glass sits flush with the outer face at X=0.
module _render_side_window(palette) {
    y0 = RH_SIDE_WIN_Y;
    y1 = y0 + RH_SIDE_WIN_W;
    z0 = FLOOR_Z + RH_SIDE_WIN_Z;
    z1 = z0 + RH_SIDE_WIN_H;

    color(pal_post(palette)) {
        // Top + bottom of frame
        translate([0, y0, z1 - FRAME_T])
            cube([WALL_DEPTH, RH_SIDE_WIN_W, FRAME_T]);
        translate([0, y0, z0])
            cube([WALL_DEPTH, RH_SIDE_WIN_W, FRAME_T]);
        // Sides
        side_h = RH_SIDE_WIN_H - 2 * FRAME_T;
        translate([0, y0, z0 + FRAME_T])
            cube([WALL_DEPTH, FRAME_T, side_h]);
        translate([0, y1 - FRAME_T, z0 + FRAME_T])
            cube([WALL_DEPTH, FRAME_T, side_h]);
    }

    // Glass pane — flush with outer wall face (X=0).
    glass_w = RH_SIDE_WIN_W - 2 * FRAME_T;
    glass_h = RH_SIDE_WIN_H - 2 * FRAME_T;
    color(GLASS_C)
    translate([-GLASS_T, y0 + FRAME_T, z0 + FRAME_T])
        cube([GLASS_T, glass_w, glass_h]);
}

module RenderHouseOpenings(palette = DEFAULT_PALETTE) {
    _render_human_door(palette);
    _render_front_door(palette);
    _render_front_window(RH_FRONT_WIN_X_LEFT,  palette);
    _render_front_window(RH_FRONT_WIN_X_RIGHT, palette);
    _render_side_window(palette);
}
