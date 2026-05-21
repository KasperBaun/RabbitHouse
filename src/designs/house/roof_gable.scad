// HOUSE gable roof — saddeltag with ridge running along Y (parallel to
// V3 / V5). Water sheds onto V3 (left) and V5 (partition / yard side).
// Self-contained; the slate cover lives in designs/roof_plates_skifer.scad.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/cladding.scad>

GR_SOFFIT_T  = 18;
GR_FASCIA_H  = 160;
GR_FASCIA_T  = RH_FASCIA_T;       // 25
GR_RIDGE_W   = 45;
GR_RIDGE_H   = 120;
// Cover-stack thickness on top of rafter top (underlay 3 + lægter 25 +
// skifer 8 = 36). Mirrors SK_STACK_T in designs/roof_plates_skifer.scad —
// used to align the fascia top with the slate top so no batten edges show.
GR_COVER_T   = 36;
// Dark slate-cladded gable color (Cembrit-style fiber-cement panel) so the
// gable end reads as roof material, not wood.
GR_GABLE_COLOR = [0.18, 0.20, 0.23];

// Rafter Y positions: gable rafters at the wall faces + intermediate ones
// at c/c 625 + barge rafters on the rake overhangs.
_GR_INNER_YS = [0, 600, 1200, 1800, 2400, 3000];
_GR_BARGE_YS = [-G_OH_RAKE, RH_HOUSE_DEPTH + G_OH_RAKE - RH_RAFTER_W];

// Cladding-stack stickout — needed to align gable-triangle outer face with
// the existing klink cladding outer face on V1 / V2.
function _gr_clad_stickout() =
    RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + cs_thick(RH_CLAD);

// ============================================================================
// Flat top plates (rem) on V3 and V5 — these replace the sloped plates in
// gable mode by sitting above them. 45x95 lying flat.
// ============================================================================
module _gr_top_plates(palette) {
    sd = RH_POST_W;     // 95
    sw = RH_SILL_H;     // 45
    color(pal_post(palette)) {
        translate([0, 0, G_EAVE_Z - sw])
            cube([sd, RH_HOUSE_DEPTH, sw]);
        translate([RH_HOUSE_LEN - sd, 0, G_EAVE_Z - sw])
            cube([sd, RH_HOUSE_DEPTH, sw]);
    }
}

// ============================================================================
// One full rafter pair (left half + right half) at Y position y0.
// ============================================================================
module _gr_rafter_pair(y0, palette) {
    x_left   = -G_OH_EAVE;
    x_right  = RH_HOUSE_LEN + G_OH_EAVE;
    z_outer_l = g_rafter_bottom_z(x_left);
    z_outer_r = g_rafter_bottom_z(x_right);
    z_ridge   = g_rafter_bottom_z(G_RIDGE_X);

    color(pal_post(palette)) {
        // Left half: outer eave -> ridge
        hull() {
            translate([x_left, y0, z_outer_l])
                cube([0.01, RH_RAFTER_W, RH_RAFTER_H]);
            translate([G_RIDGE_X, y0, z_ridge])
                cube([0.01, RH_RAFTER_W, RH_RAFTER_H]);
        }
        // Right half: ridge -> outer eave
        hull() {
            translate([G_RIDGE_X, y0, z_ridge])
                cube([0.01, RH_RAFTER_W, RH_RAFTER_H]);
            translate([x_right, y0, z_outer_r])
                cube([0.01, RH_RAFTER_W, RH_RAFTER_H]);
        }
    }
}

module _gr_rafters(palette) {
    for (y0 = _GR_INNER_YS) _gr_rafter_pair(y0, palette);
    for (y0 = _GR_BARGE_YS) _gr_rafter_pair(y0, palette);
}

// ============================================================================
// Ridge beam — 45x120 running along Y at the peak, sitting just under
// the rafter tops at the ridge so the slate cap covers the seam.
// ============================================================================
module _gr_ridge_beam(palette) {
    z_top = g_rafter_top_z(G_RIDGE_X);
    color(pal_post(palette))
    translate([G_RIDGE_X - GR_RIDGE_W/2, -G_OH_RAKE,
               z_top - GR_RIDGE_H])
        cube([GR_RIDGE_W,
              RH_HOUSE_DEPTH + 2 * G_OH_RAKE,
              GR_RIDGE_H]);
}

// ============================================================================
// Side fascia — vertical board hanging at the outer eave end of the rafters
// (one along V3 side, one along V5 side). Top aligned with slate top so
// no battens are visible at the drip edge.
// ============================================================================
module _gr_side_fascia(palette) {
    x_l       = -G_OH_EAVE;
    x_r       = RH_HOUSE_LEN + G_OH_EAVE;
    z_top_l   = g_rafter_top_z(x_l) + GR_COVER_T;
    z_top_r   = g_rafter_top_z(x_r) + GR_COVER_T;
    y_lo      = -G_OH_RAKE - GR_FASCIA_T;
    y_hi      = RH_HOUSE_DEPTH + G_OH_RAKE + GR_FASCIA_T;
    color(pal_trim(palette)) {
        translate([x_l - GR_FASCIA_T, y_lo, z_top_l - GR_FASCIA_H])
            cube([GR_FASCIA_T, y_hi - y_lo, GR_FASCIA_H]);
        translate([x_r,             y_lo, z_top_r - GR_FASCIA_H])
            cube([GR_FASCIA_T, y_hi - y_lo, GR_FASCIA_H]);
    }
}

// ============================================================================
// Raked fascia / vindskede — one continuous pentagonal board per gable
// running along the rake of both halves with the apex at the ridge top.
// Top edge follows the slate-top plane; bottom edge is horizontal at the
// eave-fascia bottom, so the two fascias meet flush at the eave corners.
// ============================================================================
module _gr_rake_fascia_one(y_translate, palette) {
    // Match the side-fascia outer-eave footprint so the two fascias meet
    // flush at the corners (same x range, same top z).
    x_l       = -G_OH_EAVE;
    x_r       = RH_HOUSE_LEN + G_OH_EAVE;
    z_top_l   = g_rafter_top_z(x_l) + GR_COVER_T;
    z_top_r   = g_rafter_top_z(x_r) + GR_COVER_T;
    z_apex    = g_ridge_top_z()     + GR_COVER_T;
    z_bot     = z_top_l - GR_FASCIA_H;
    color(pal_trim(palette))
    translate([0, y_translate, 0])
    rotate([90, 0, 0])
    linear_extrude(height = GR_FASCIA_T)
        polygon(points = [
            [x_l, z_bot],
            [x_r, z_bot],
            [x_r, z_top_r],
            [G_RIDGE_X, z_apex],
            [x_l, z_top_l]
        ]);
}

module _gr_rake_fascia(palette) {
    _gr_rake_fascia_one(-G_OH_RAKE, palette);                       // V1
    _gr_rake_fascia_one(RH_HOUSE_DEPTH + G_OH_RAKE + GR_FASCIA_T, palette);  // V2
}

// ============================================================================
// Soffit — sloped panel hugging the rafter underside, under each side
// eave. Polyhedron because the eave drops from the wall to the outer end.
// ============================================================================
module _gr_eave_soffit_one(x_lo, x_hi, palette) {
    y_lo = -G_OH_RAKE;
    y_hi = RH_HOUSE_DEPTH + G_OH_RAKE;
    z_top_lo = g_rafter_bottom_z(x_lo);
    z_top_hi = g_rafter_bottom_z(x_hi);
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x_lo, y_lo, z_top_lo - GR_SOFFIT_T],
            [x_hi, y_lo, z_top_hi - GR_SOFFIT_T],
            [x_hi, y_hi, z_top_hi - GR_SOFFIT_T],
            [x_lo, y_hi, z_top_lo - GR_SOFFIT_T],
            [x_lo, y_lo, z_top_lo],
            [x_hi, y_lo, z_top_hi],
            [x_hi, y_hi, z_top_hi],
            [x_lo, y_hi, z_top_lo]
        ],
        faces = [[0,1,2,3],[4,7,6,5],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0]]
    );
}

module _gr_eave_soffit(palette) {
    _gr_eave_soffit_one(-G_OH_EAVE, 0, palette);
    _gr_eave_soffit_one(RH_HOUSE_LEN, RH_HOUSE_LEN + G_OH_EAVE, palette);
}

// ============================================================================
// Raked soffit — sloped panel under the rake overhang on V1 and V2, hiding
// the barge rafters + batten ends from underneath. Two halves per gable
// (left + right slopes meet at the ridge centerline).
// ============================================================================
module _gr_rake_soffit_quad(x_lo, x_hi, y_lo, y_hi, palette) {
    z_top_xl = g_rafter_bottom_z(x_lo);
    z_top_xh = g_rafter_bottom_z(x_hi);
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x_lo, y_lo, z_top_xl - GR_SOFFIT_T],
            [x_hi, y_lo, z_top_xh - GR_SOFFIT_T],
            [x_hi, y_hi, z_top_xh - GR_SOFFIT_T],
            [x_lo, y_hi, z_top_xl - GR_SOFFIT_T],
            [x_lo, y_lo, z_top_xl],
            [x_hi, y_lo, z_top_xh],
            [x_hi, y_hi, z_top_xh],
            [x_lo, y_hi, z_top_xl]
        ],
        faces = [[0,1,2,3],[4,7,6,5],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0]]
    );
}

module _gr_rake_soffit(palette) {
    so = _gr_clad_stickout();
    // V1 rake (front): y from outer barge to cladding outer face.
    _gr_rake_soffit_quad(0,             G_RIDGE_X,          -G_OH_RAKE, -so, palette);
    _gr_rake_soffit_quad(G_RIDGE_X,     RH_HOUSE_LEN,       -G_OH_RAKE, -so, palette);
    // V2 rake (back): mirror Y.
    _gr_rake_soffit_quad(0,             G_RIDGE_X,          RH_HOUSE_DEPTH + so, RH_HOUSE_DEPTH + G_OH_RAKE, palette);
    _gr_rake_soffit_quad(G_RIDGE_X,     RH_HOUSE_LEN,       RH_HOUSE_DEPTH + so, RH_HOUSE_DEPTH + G_OH_RAKE, palette);
}

// ============================================================================
// Gable end cladding — closes V1 and V2 above the eave up to the ridge.
// Rendered in dark slate (fiber-cement gable cladding), matching the roof
// so the gable reads as one continuous slate face rather than wood.
// ============================================================================
module _gr_gable_triangle(y_outer, y_inner, palette) {
    z_eave = G_EAVE_Z;
    z_apex = g_rafter_bottom_z(G_RIDGE_X);
    color(GR_GABLE_COLOR)
    polyhedron(
        points = [
            [0, y_outer, z_eave],
            [RH_HOUSE_LEN, y_outer, z_eave],
            [G_RIDGE_X, y_outer, z_apex],
            [0, y_inner, z_eave],
            [RH_HOUSE_LEN, y_inner, z_eave],
            [G_RIDGE_X, y_inner, z_apex]
        ],
        faces = [
            [0, 1, 2],
            [5, 4, 3],
            [0, 3, 4, 1],
            [1, 4, 5, 2],
            [2, 5, 3, 0]
        ]
    );
}

// V2 has its existing klink cladding 200 mm below the new flat eave. Render
// additional klink boards from the existing cladding top up to the eave so
// the wall reads as one continuous lap-board face — no smooth brown patch.
module _gr_gable_knevaeg_v2(palette) {
    s        = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;   // 23
    z_clad   = RH_BASE_H + RH_EH_BACK;                 // 2320
    z_eave   = G_EAVE_Z;                               // 2520
    // Cladding origin Y matches the existing V2 klink (clad_wall_rect adds
    // thickness in +Y, so origin Y is the back of the boards).
    clad_wall_rect([0, RH_HOUSE_DEPTH + s, z_clad],
                    RH_HOUSE_LEN, z_eave - z_clad, "X",
                    palette, RH_CLAD);
}

module _gr_gable_v1(palette) {
    so = _gr_clad_stickout();
    _gr_gable_triangle(-so, 0, palette);
}

module _gr_gable_v2(palette) {
    so = _gr_clad_stickout();
    _gr_gable_knevaeg_v2(palette);
    _gr_gable_triangle(RH_HOUSE_DEPTH + so, RH_HOUSE_DEPTH, palette);
}

// ============================================================================
// Knevæg gap-fill on V3 and V5 — the existing sloped wall top is up to
// 200 mm below the new flat eave at the back. Render thin triangular
// trim panels at the outer cladding face filling the gap so the eave reads
// as a clean flat horizontal line.
// ============================================================================
module _gr_knevaeg_v3(palette) {
    so      = _gr_clad_stickout();
    x_outer = -so;
    x_inner = -so + 10;
    z_lo    = RH_BASE_H + RH_EH_BACK;   // 2320
    z_hi    = G_EAVE_Z;                 // 2520
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x_outer, 0,        z_hi],
            [x_outer, RH_HOUSE_DEPTH, z_hi],
            [x_outer, RH_HOUSE_DEPTH, z_lo],
            [x_inner, 0,        z_hi],
            [x_inner, RH_HOUSE_DEPTH, z_hi],
            [x_inner, RH_HOUSE_DEPTH, z_lo]
        ],
        faces = [
            [0, 1, 2],
            [5, 4, 3],
            [0, 3, 4, 1],
            [1, 4, 5, 2],
            [2, 5, 3, 0]
        ]
    );
}

module _gr_knevaeg_v5(palette) {
    so      = _gr_clad_stickout();
    x_outer = RH_HOUSE_LEN + so;
    x_inner = x_outer - 10;
    z_lo    = RH_BASE_H + RH_EH_BACK;
    z_hi    = G_EAVE_Z;
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x_outer, 0,        z_hi],
            [x_outer, RH_HOUSE_DEPTH, z_hi],
            [x_outer, RH_HOUSE_DEPTH, z_lo],
            [x_inner, 0,        z_hi],
            [x_inner, RH_HOUSE_DEPTH, z_hi],
            [x_inner, RH_HOUSE_DEPTH, z_lo]
        ],
        faces = [
            [2, 1, 0],
            [3, 4, 5],
            [1, 4, 3, 0],
            [2, 5, 4, 1],
            [0, 3, 5, 2]
        ]
    );
}

// ============================================================================
// Top-level entry.
// ============================================================================
module RenderHouseGableRoof(palette = DEFAULT_PALETTE) {
    _gr_top_plates(palette);
    _gr_rafters(palette);
    _gr_ridge_beam(palette);
    _gr_eave_soffit(palette);
    _gr_rake_soffit(palette);
    _gr_side_fascia(palette);
    _gr_rake_fascia(palette);
    _gr_gable_v1(palette);
    _gr_gable_v2(palette);
    _gr_knevaeg_v3(palette);
    _gr_knevaeg_v5(palette);
}
