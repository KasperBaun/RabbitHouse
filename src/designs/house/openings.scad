// HOUSE openings — front entry door + 2 windows on V1, human door in the
// partition (V5). Self-contained: zone-specific geometry only.

include <../../lib/defaults.scad>
include <../config.scad>

FRAME_T       = 50;
LEAF_T        = 40;
GLASS_T       = 4;

WALL_DEPTH    = RH_POST_W;
FLOOR_Z       = RH_FLOOR_TOP;

PARTITION_X   = RH_HOUSE_LEN;
// V5 wall sits inside the foundation (X=hl-WALL_DEPTH..hl), so the door
// frame's inner X face = wall inner face = hl - WALL_DEPTH.
PART_INNER_X  = PARTITION_X - WALL_DEPTH;

// Front door barn-leaf styling — each leaf is built from vertical planks
// with a Z-brace (top + bottom horizontal battens + one diagonal) on
// the outer face. Diagonal runs bottom-hinge to top-handle so leaf
// weight loads down toward the hinges.
PLANK_W       = 100;     // visible width of one vertical plank
PLANK_GAP     = 3;       // v-groove between planks
BATTEN_H      = 140;     // Z-brace batten width (perpendicular to length)
BATTEN_T      = 20;      // batten stickout from leaf outer face
BATTEN_INSET  = 80;      // top/bottom batten distance from leaf top/bottom

HINGE_C       = [0.18, 0.18, 0.20];
HANDLE_C      = [0.18, 0.18, 0.20];
GLASS_C       = [0.55, 0.75, 0.85, 0.45];

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

// Front entry DOUBLE BARN DOOR on V1, faces -Y (out into garden).
// Two equal-width leaves split at the centre of the opening; both swing
// outward. Hinges sit on the outer corners (flush with the jambs);
// latches meet at the centre seam. Each leaf carries vertical planks
// with a Z-brace on the outer face.
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

    // Each leaf occupies half the inner opening.
    inner_x0 = x0 + FRAME_T;
    inner_x1 = x1 - FRAME_T;
    leaf_w   = (inner_x1 - inner_x0) / 2;
    leaf_h   = RH_FRONT_DOOR_H - FRAME_T;
    leaf_y   = -LEAF_T;     // outer face flush with V1's outer face (Y=0)

    _barn_leaf(inner_x0,          leaf_y, z0, leaf_w, leaf_h, "L", palette);
    _barn_leaf(inner_x0 + leaf_w, leaf_y, z0, leaf_w, leaf_h, "R", palette);
}

// One leaf of the double barn door. `(lx, ly, lz)` = SW outer corner.
// hinge="L" → hinges at lx (small-X); hinge="R" → hinges at lx+w.
// The Z-brace diagonal runs from the bottom-hinge corner to the
// top-handle corner.
module _barn_leaf(lx, ly, lz, w, h, hinge, palette) {
    // Vertical planks — small visible gap between adjacent boards reads
    // as a v-groove.
    n        = max(1, round(w / PLANK_W));
    plank_w  = (w - (n - 1) * PLANK_GAP) / n;
    color(pal_door(palette))
    for (i = [0 : n - 1])
        translate([lx + i * (plank_w + PLANK_GAP), ly, lz])
            cube([plank_w, LEAF_T, h]);

    // Z-brace on the outer (-Y) face.
    by     = ly - BATTEN_T;
    z_bb_b = lz + BATTEN_INSET;              // bottom-batten bottom
    z_bb_t = z_bb_b + BATTEN_H;              // bottom-batten top
    z_tb_t = lz + h - BATTEN_INSET;          // top-batten top
    z_tb_b = z_tb_t - BATTEN_H;              // top-batten bottom
    color(pal_panel2(palette)) {
        translate([lx, by, z_bb_b]) cube([w, BATTEN_T, BATTEN_H]);
        translate([lx, by, z_tb_b]) cube([w, BATTEN_T, BATTEN_H]);
        _diag_batten(lx, lx + w, z_bb_t, z_tb_b, by, hinge);
    }

    // Hinges — 3 strap hinges on the hinge-side outer face.
    hinge_x = (hinge == "L") ? lx : lx + w - 240;
    color(HINGE_C)
    for (zh = [lz + 220, lz + h/2 - 30, lz + h - 320])
        translate([hinge_x, by - 3, zh])
            cube([240, 3, 55]);

    // Latch handle at the centre seam, ~mid-height (~1.05 m above floor).
    handle_x = (hinge == "L") ? lx + w - 60 : lx + 25;
    color(HANDLE_C) {
        translate([handle_x, by - 25, lz + 950])  cube([35, 25, 200]);
        translate([handle_x - 15, by - 50, lz + 1030]) cube([65, 30, 40]);
    }
}

// Diagonal Z-brace batten. Connects the inner edges of the two horizontal
// battens — (x_lo, z_lo) at bottom and (x_hi, z_hi) at top — via the
// corner appropriate for the hinge side. Batten cross-section is
// BATTEN_T (-Y stickout) × BATTEN_H (perpendicular to the diagonal in
// the leaf plane). The cube is centred on the connecting line, so the
// rendered batten slightly overlaps the horizontal battens at the
// corners — that overlap reads as the joint where they meet.
module _diag_batten(x_lo, x_hi, z_lo, z_hi, by, hinge) {
    x_start = (hinge == "L") ? x_lo : x_hi;
    x_end   = (hinge == "L") ? x_hi : x_lo;
    dx = x_end - x_start;
    dz = z_hi  - z_lo;
    L  = sqrt(dx * dx + dz * dz);
    ang = atan2(dz, dx);    // OpenSCAD atan2 returns degrees
    translate([x_start, by, z_lo])
        rotate([0, -ang, 0])
            translate([0, 0, -BATTEN_H / 2])
                cube([L, BATTEN_T, BATTEN_H]);
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

module RenderHouseOpenings(palette = DEFAULT_PALETTE) {
    _render_human_door(palette);
    _render_front_door(palette);
    _render_front_window(RH_FRONT_WIN_X_LEFT,  palette);
    _render_front_window(RH_FRONT_WIN_X_RIGHT, palette);
}
