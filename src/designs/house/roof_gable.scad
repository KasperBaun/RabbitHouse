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

// Truss Y positions — gable trusses at the wall faces + intermediates
// at c/c 600.
_GR_TRUSS_YS = [0, 600, 1200, 1800, 2400, 3000];

// Ridge-board Y span (gitterspær only) covers the gable rafter at
// Y=3000..3045.
_GR_Y_SPAN = RH_HOUSE_DEPTH + 45;

module RenderHouseGableRoof(truss = "haneband", palette = DEFAULT_PALETTE) {
    if (truss == "haneband") {
        for (y0 = _GR_TRUSS_YS) spaer_med_haneband(y0, palette);
    } else if (truss == "gitterspaer") {
        for (y0 = _GR_TRUSS_YS) gitterspaer(y0, palette);
        gitterspaer_ridge_board(_GR_Y_SPAN, palette);
    }
}
