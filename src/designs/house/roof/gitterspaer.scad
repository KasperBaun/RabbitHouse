// Gitterspær — engineered king-post truss with W-pattern webs.
//
//        /\
//       /  \
//      /    \
//     /      \
//    /  /|\   \      king post (kongepost) — vertical at centre
//   /  / | \   \     W-struts (skråtræer) — from king-post foot to mid-top-chord
//  /  /  |  \   \
// /__/___|___\___\   bottom chord (spændtræ) — horizontal tie between eaves
//
// All members are 45×95 reglar. Suitable for spans where the bottom
// chord can do duty as a ceiling joist; for small spans (< 3 m) the
// haneband.scad pattern gives more loft space and is structurally
// adequate. Top chords butt against a separate ridge board — see
// gitterspaer_ridge_board.

include <../../../lib/defaults.scad>
include <../../config.scad>

GS_MEMBER_T      = 45;
GS_MEMBER_H      = 95;
GS_RIDGE_BOARD_T = 25;

// Bottom chord (spændtræ) sits on the V3 / V4 top plates with top edge
// flush with the rafter top at the wall. Top-chord and bottom-chord
// meet at a clean wedge at the eave node.
GS_BOT_CHORD_TOP = G_EAVE_Z + GS_MEMBER_H;        // 2412 + 95 = 2507

// W-strut top attachments — midway between V3 inner face (X=0) and
// the ridge, on the rafter bottom edge.
GS_STRUT_TOP_X_L = G_RIDGE_X / 2;
GS_STRUT_TOP_X_R = G_RIDGE_X + (RH_HOUSE_LEN - G_RIDGE_X)/2;

// ============================================================================
// One sloped top chord (rafter) from x_outer (outer eave) to x_inner
// (ridge-board face).
// ============================================================================
module _gs_top_chord(x_outer, x_inner, y0, palette) {
    z_outer = g_rafter_bottom_z(x_outer);
    z_inner = g_rafter_bottom_z(x_inner);
    color(pal_post(palette))
    hull() {
        translate([x_outer, y0, z_outer])
            cube([0.01, GS_MEMBER_T, GS_MEMBER_H]);
        translate([x_inner - 0.01, y0, z_inner])
            cube([0.01, GS_MEMBER_T, GS_MEMBER_H]);
    }
}

// ============================================================================
// Bottom chord (spændtræ) — horizontal tie from V3 to V4 inner face.
// ============================================================================
module _gs_bot_chord(y0, palette) {
    color(pal_post(palette))
    translate([0, y0, G_EAVE_Z])
        cube([RH_HOUSE_LEN, GS_MEMBER_T, GS_MEMBER_H]);
}

// ============================================================================
// King post (kongepost) — vertical centre member from bottom-chord top
// to ridge bottom. 95 wide along X (in truss plane), 45 along Y.
// ============================================================================
module _gs_king_post(y0, palette) {
    color(pal_post(palette))
    translate([G_RIDGE_X - GS_MEMBER_H/2, y0, GS_BOT_CHORD_TOP])
        cube([GS_MEMBER_H, GS_MEMBER_T, g_ridge_bottom_z() - GS_BOT_CHORD_TOP]);
}

// ============================================================================
// W-strut (skråtræ) — diagonal from king-post foot up to mid-top-chord.
// The TOP END is angle-cut at the rafter pitch so the entire end face
// sits flush on the rafter underside — both corners of the end face land
// on the rafter underside plane (top corner at x_top, bot corner offset
// toward the eave by H / tan(pitch)). The foot end is a vertical face
// inside the king-post column (X = G_RIDGE_X), where the two members
// merge cleanly.
// ============================================================================
module _gs_strut(x_top, y0, palette) {
    is_left  = (x_top < G_RIDGE_X);
    delta_x  = GS_MEMBER_H / tan(G_PITCH_DEG);
    x_bot    = is_left ? x_top - delta_x : x_top + delta_x;
    z_top_z  = g_rafter_bottom_z(x_top);
    z_bot_z  = z_top_z - GS_MEMBER_H;
    x_foot   = G_RIDGE_X;
    z_foot_b = GS_BOT_CHORD_TOP;
    z_foot_t = GS_BOT_CHORD_TOP + GS_MEMBER_H;

    // Polygon CCW in (X, Z); reversed for the right-side strut so the
    // extruded polyhedron has outward-facing normals.
    pts = is_left
        ? [[x_top, z_top_z], [x_bot, z_bot_z], [x_foot, z_foot_b], [x_foot, z_foot_t]]
        : [[x_top, z_top_z], [x_foot, z_foot_t], [x_foot, z_foot_b], [x_bot, z_bot_z]];

    color(pal_post(palette))
    translate([0, y0 + GS_MEMBER_T, 0])
    rotate([-90, 0, 0])
    linear_extrude(height = GS_MEMBER_T)
        polygon(points = pts);
}

// ============================================================================
// Entry — one full gitterspær at Y position y0.
// ============================================================================
module gitterspaer(y0, palette = DEFAULT_PALETTE) {
    x_left    = -G_OH_EAVE;
    x_right   = RH_HOUSE_LEN + G_OH_EAVE;
    x_inner_l = G_RIDGE_X - GS_RIDGE_BOARD_T / 2;
    x_inner_r = G_RIDGE_X + GS_RIDGE_BOARD_T / 2;
    _gs_top_chord(x_left,    x_inner_l, y0, palette);
    _gs_top_chord(x_inner_r, x_right,   y0, palette);
    _gs_bot_chord(y0, palette);
    _gs_king_post(y0, palette);
    _gs_strut(GS_STRUT_TOP_X_L, y0, palette);
    _gs_strut(GS_STRUT_TOP_X_R, y0, palette);
}

// ============================================================================
// Continuous ridge board (rygbræt) between the truss top-chord inner
// ends. Top edge is set to the rafter top AT THE JOINT FACE (not at the
// apex centerline) so the rafter end face and ridge-board side face are
// flush — no protrusion above the rafter at the joint. The slate cover
// sits on top of everything; the sliver between board top and slate-
// plane peak at X=G_RIDGE_X is hidden under the ridge cap.
// ============================================================================
module gitterspaer_ridge_board(y_span, palette = DEFAULT_PALETTE) {
    z_top = g_rafter_top_z(G_RIDGE_X - GS_RIDGE_BOARD_T / 2);
    z_bot = z_top - GS_MEMBER_H;
    color(pal_post(palette))
    translate([G_RIDGE_X - GS_RIDGE_BOARD_T / 2, 0, z_bot])
        cube([GS_RIDGE_BOARD_T, y_span, GS_MEMBER_H]);
}
