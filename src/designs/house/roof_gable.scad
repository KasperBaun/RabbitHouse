// HOUSE gable roof — saddeltag with ridge running along Y (parallel to
// V3 / V5). Water sheds onto V3 (left) and V5 (partition / yard side).
//
// Real spær construction (construction view, no cladding/soffit/fascia):
//   - Rafter pairs at c/c 600, each butting against a thin ridge board
//     (rygbræt) at the apex — not overlapping at a point.
//   - Hanebånd (collar tie) per pair at 2/3 of rafter rise.
//   - No rake overhang — gables sit flush with V1 / V2.
//
// The slate cover (designs/roof_plates_skifer.scad) sits on the rafter
// tops; ridge-board top is flush with the rafter top so the slate plane
// closes cleanly at the apex.

include <../../lib/defaults.scad>
include <../config.scad>

// Ridge board (rygbræt) — thin board between opposing rafter halves.
// 25 mm board, vertical cross-section matching the rafter (95 mm).
GR_RIDGE_BOARD_T = 25;

// Hanebånd (collar tie) — 45x95 reglar tying each rafter pair together
// before they spread under load. Top set at 2/3 of the bottom-edge rise
// from eave to ridge, so the lower 1/3 of the gable is clear headroom
// and the hanebånd's end face lands flush on the rafter bottom edge.
GR_COLLAR_W      = 45;
GR_COLLAR_H      = 95;
GR_COLLAR_Z_TOP  = G_EAVE_Z + 2 * (g_ridge_bottom_z() - G_EAVE_Z) / 3;

// Rafter Y positions — gable rafters at the wall faces + intermediate
// ones at c/c 600. No barge rafters (no rake overhang).
_GR_INNER_YS = [0, 600, 1200, 1800, 2400, 3000];

// Ridge-board / collar-tie Y span covers all rafter positions including
// the gable rafter at Y=3000 (which extends to Y=3045).
_GR_Y_SPAN = RH_HOUSE_DEPTH + RH_RAFTER_W;

// ============================================================================
// One sloped rafter half from x_outer (outer eave) to x_inner (ridge-board
// face). Hull between two thin vertical cubes — 45×95 axis-aligned cross-
// section sloped at G_PITCH_DEG.
// ============================================================================
module _gr_rafter_half(x_outer, x_inner, y0, palette) {
    z_outer = g_rafter_bottom_z(x_outer);
    z_inner = g_rafter_bottom_z(x_inner);
    color(pal_post(palette))
    hull() {
        translate([x_outer, y0, z_outer])
            cube([0.01, RH_RAFTER_W, RH_RAFTER_H]);
        translate([x_inner - 0.01, y0, z_inner])
            cube([0.01, RH_RAFTER_W, RH_RAFTER_H]);
    }
}

// One spærfag (rafter bay): left rafter + right rafter, each butting
// against the ridge board at its inner end.
module _gr_rafter_pair(y0, palette) {
    x_left    = -G_OH_EAVE;
    x_right   = RH_HOUSE_LEN + G_OH_EAVE;
    x_inner_l = G_RIDGE_X - GR_RIDGE_BOARD_T / 2;
    x_inner_r = G_RIDGE_X + GR_RIDGE_BOARD_T / 2;
    _gr_rafter_half(x_left,    x_inner_l, y0, palette);
    _gr_rafter_half(x_inner_r, x_right,   y0, palette);
}

module _gr_rafters(palette) {
    for (y0 = _GR_INNER_YS) _gr_rafter_pair(y0, palette);
}

// ============================================================================
// Ridge board (rygbræt) — 25 mm thick board centered on the ridge,
// running the full rafter-Y span. Top edge flush with rafter top at the
// apex; bottom edge flush with rafter bottom at the apex.
// ============================================================================
module _gr_ridge_board(palette) {
    z_top = g_rafter_top_z(G_RIDGE_X);
    z_bot = z_top - RH_RAFTER_H;
    color(pal_post(palette))
    translate([G_RIDGE_X - GR_RIDGE_BOARD_T / 2, 0, z_bot])
        cube([GR_RIDGE_BOARD_T, _GR_Y_SPAN, RH_RAFTER_H]);
}

// ============================================================================
// Hanebånd (collar tie) — horizontal beam per rafter pair. Top of beam
// sits at GR_COLLAR_Z_TOP; the X attachment points are where each
// rafter's bottom edge crosses that Z.
//
//   Left rafter bottom edge:  z = G_EAVE_Z + x * tan(pitch)
//   z = GR_COLLAR_Z_TOP  =>  x = (GR_COLLAR_Z_TOP - G_EAVE_Z) / tan(pitch)
// ============================================================================
function _gr_collar_x_attach() =
    (GR_COLLAR_Z_TOP - G_EAVE_Z) / tan(G_PITCH_DEG);

module _gr_collar_tie(y0, palette) {
    x_l = _gr_collar_x_attach();
    x_r = RH_HOUSE_LEN - x_l;
    z_b = GR_COLLAR_Z_TOP - GR_COLLAR_H;
    color(pal_post(palette))
    translate([x_l, y0, z_b])
        cube([x_r - x_l, GR_COLLAR_W, GR_COLLAR_H]);
}

module _gr_collar_ties(palette) {
    for (y0 = _GR_INNER_YS) _gr_collar_tie(y0, palette);
}

// ============================================================================
// Top-level entry.
// ============================================================================
module RenderHouseGableRoof(palette = DEFAULT_PALETTE) {
    _gr_rafters(palette);
    _gr_ridge_board(palette);
    _gr_collar_ties(palette);
}
