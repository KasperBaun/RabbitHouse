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

module RenderHouseGableRoof(truss = "haneband", palette = DEFAULT_PALETTE) {
    if (truss == "haneband") {
        for (y0 = _GR_TRUSS_YS) spaer_med_haneband(y0, palette);
    } else if (truss == "gitterspaer") {
        for (y0 = _GR_TRUSS_YS) gitterspaer(y0, palette);
        gitterspaer_ridge_board(_GR_Y_SPAN, palette);
    }
}
