// HOUSE gable roof — dispatches to a truss variant. Both variants live
// in the roof/ subfolder so they can be reused in other designs:
//
//   roof/haneband.scad     — spær med hanebånd (traditional, more loft
//                            space, no ridge board, rafters meet at apex)
//   roof/gitterspaer.scad  — engineered king-post truss (bottom chord +
//                            king post + W-struts + ridge board)
//
// Default: hanebånd — appropriate for the 2 m span at 35° and gives
// clear loft space.
//
// No rake overhang — gables sit flush with V1 / V2. The slate cover
// (designs/roof_plates_skifer.scad) sits on the rafter tops regardless
// of variant.

include <../../lib/defaults.scad>
include <../config.scad>
use <roof/haneband.scad>
use <roof/gitterspaer.scad>

// Gable-truss thickness along Y (both variants are 45 mm reglar).
_GR_MEMBER_T = 45;

// Truss Y positions. Each truss extends +Y by _GR_MEMBER_T, so the two gable
// trusses must sit flush INSIDE their wall faces: V1 at Y=0..45 and V2 at
// (ww-45)..ww. Otherwise the V2 gable would poke 45 mm past the back wall
// and the slate (Y=0..ww) would cover V1's barge but only reach V2's inner
// face — the "one end flush, other end off" asymmetry.
_GR_TRUSS_YS = [0, 600, 1200, 1800, 2400, RH_HOUSE_DEPTH - _GR_MEMBER_T];

// Ridge-board Y span (gitterspær only) runs gable-to-gable.
_GR_Y_SPAN = RH_HOUSE_DEPTH;

// Gable-cladding outer-face offset (housewrap 1 + batten 22 + klink 25).
_GR_VS_CLAD = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + 25;   // 48
_GR_VS_T    = 25;                                          // vindskede thickness (Y)
// Roof stack above the rafter top (undertag 3 + taglægte 25). The vindskede
// top must reach past it (up under the slate) or the lægte ends poke out
// over the barge at the rake.
_GR_ROOF_STACK = 30;

// Vindskede (barge board) — a board along both rake slopes on one gable,
// capping the angle-cut klink board-ends AND the taglægte ends where the
// horizontal cladding meets the sloped roof. Sits on the gable outer face;
// top edge tucks up under the slate, bottom laps ~50 mm over the cladding.
// `y_hi` = the board's inner Y face (it extrudes _GR_VS_T outward).
module _gable_vindskede(y_hi, palette) {
    color(pal_trim(palette))
    translate([0, y_hi, 0])
        rotate([90, 0, 0])
            linear_extrude(height = _GR_VS_T)
                polygon(points = [
                    [0,            g_rafter_top_z(0)            + _GR_ROOF_STACK],
                    [G_RIDGE_X,    g_rafter_top_z(G_RIDGE_X)    + _GR_ROOF_STACK],
                    [RH_HOUSE_LEN, g_rafter_top_z(RH_HOUSE_LEN) + _GR_ROOF_STACK],
                    [RH_HOUSE_LEN, g_rafter_bottom_z(RH_HOUSE_LEN) - 50],
                    [G_RIDGE_X,    g_rafter_bottom_z(G_RIDGE_X) - 50],
                    [0,            g_rafter_bottom_z(0) - 50]
                ]);
}

module RenderHouseGableRoof(truss = "haneband", palette = DEFAULT_PALETTE) {
    if (truss == "haneband") {
        for (y0 = _GR_TRUSS_YS) spaer_med_haneband(y0, palette);
    } else if (truss == "gitterspaer") {
        for (y0 = _GR_TRUSS_YS) gitterspaer(y0, palette);
        gitterspaer_ridge_board(_GR_Y_SPAN, palette);
    }
    // Barge boards on both gable ends, on the cladding outer face (proud).
    _gable_vindskede(-_GR_VS_CLAD + 5,                    palette);  // V1 front
    _gable_vindskede(RH_HOUSE_DEPTH + _GR_VS_CLAD + _GR_VS_T - 5, palette);  // V2 back
}
