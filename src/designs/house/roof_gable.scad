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
// The gable trusses sit flush with V1 / V2; the slate cover
// (designs/roof_plates_skifer.scad) overhangs the gables by G_OH_RAKE,
// carried by taglægter cantilevering out past the trusses. The vindskede
// is nailed to the lægte ends at the rake edge.

include <../../lib/defaults.scad>
include <../config.scad>
use <roof/haneband.scad>
use <roof/gitterspaer.scad>

// Gable-truss thickness along Y (both variants are 45 mm reglar).
_GR_MEMBER_T = 45;

// Truss Y positions come from config (G_TRUSS_YS) — shared with the skifer
// cover, whose afstandslister must sit directly over the spær. Each truss
// extends +Y by _GR_MEMBER_T, so the two gable trusses sit flush INSIDE
// their wall faces: V1 at Y=0..45 and V2 at (ww-45)..ww.
_GR_TRUSS_YS = G_TRUSS_YS;

// Ridge-board Y span (gitterspær only) runs gable-to-gable.
_GR_Y_SPAN = RH_HOUSE_DEPTH;

// Roof stack above the rafter top (undertag 3 + afstandsliste 25 + taglægte
// 38 = G_ROOF_STACK_T). The vindskede top reaches to just under the slate
// (−1 mm so no faces coincide), capping the lægte ends at the rake.
_GR_ROOF_STACK = G_ROOF_STACK_T - 1;
// Vindskede vertical depth. The underbræt is 150 like the stern, measured
// from the same top line (stack top), so their lower edges land flush where
// they meet at the eave corners — no step/notch.
_GR_VS_H = 150;
// The vindskede runs RH_FASCIA_T past the eave line to cover the stern's
// end grain; the end is cut plumb at the stern front face and level along
// its own bottom line (classic corner detail). The stern itself stops
// at the underbræt's inner face.
_GR_VS_TIP = RH_FASCIA_T;
// Overligger top edge: roof stack + slate (8, = SK_SLATE_T) + the rise above
// the slate surface. The overligger closes the rake — the slate butts
// against it instead of overhanging.
_GR_VS_OVER_TOP = G_ROOF_STACK_T + 8 + G_VS_OVER_RISE;

// One vindskede board along both rake slopes of a gable — used twice per
// gable: underbræt (z_top = _GR_ROOF_STACK, just under the slate) and
// overligger (z_top = _GR_VS_OVER_TOP, rising above the slate surface).
// `y_hi` = the board's inner Y face (it extrudes G_VS_T outward, toward -Y).
// `z_top` = the top edge's vertical offset above the rafter-top plane.
module _gable_vindskede(y_hi, z_top, palette) {
    x_el = -G_OH_EAVE;                  // eave line, left
    x_er = RH_HOUSE_LEN + G_OH_EAVE;    // eave line, right
    x_tl = x_el - _GR_VS_TIP;           // tip = stern front face, left
    x_tr = x_er + _GR_VS_TIP;           // tip = stern front face, right
    color(pal_trim(palette))
    translate([0, y_hi, 0])
        rotate([90, 0, 0])
            linear_extrude(height = G_VS_T)
                polygon(points = [
                    // top edge follows the roof plane tip-to-tip
                    [x_tl,      g_rafter_top_z(x_tl)      + z_top],
                    [G_RIDGE_X, g_rafter_top_z(G_RIDGE_X) + z_top],
                    [x_tr,      g_rafter_top_z(x_tr)      + z_top],
                    // plumb end cut at the stern front face...
                    [x_tr,      g_rafter_top_z(x_er) + z_top - _GR_VS_H],
                    // ...level back to the eave line along the bottom line
                    [x_er,      g_rafter_top_z(x_er) + z_top - _GR_VS_H],
                    // bottom edge parallel to the roof plane
                    [G_RIDGE_X, g_rafter_top_z(G_RIDGE_X) + z_top - _GR_VS_H],
                    [x_el,      g_rafter_top_z(x_el) + z_top - _GR_VS_H],
                    // level out to the tip + plumb cut closes the loop
                    [x_tl,      g_rafter_top_z(x_el) + z_top - _GR_VS_H]
                ]);
}

// Spær only — arbejdsplan trin 4 ("Rejs spær m. hanebånd").
module RenderHouseGableSpaer(truss = "haneband", palette = DEFAULT_PALETTE) {
    if (truss == "haneband") {
        for (y0 = _GR_TRUSS_YS) spaer_med_haneband(y0, palette);
    } else if (truss == "gitterspaer") {
        for (y0 = _GR_TRUSS_YS) gitterspaer(y0, palette);
        gitterspaer_ridge_board(_GR_Y_SPAN, palette);
    }
}

// Dobbelt vindskede on both gable ends, mounted AFTER lægtning (arbejdsplan
// trin 5): underbræt nailed to the lægte ends (front Y=-170..-145, back
// Y=3145..3170) with its top just under the slate, then overligger on the
// underbræt's outer face (front Y=-195..-170, back Y=3170..3195) rising
// G_VS_OVER_RISE above the slate surface. The slate stops against the
// overligger's inner face.
module RenderHouseGableVindskeder(palette = DEFAULT_PALETTE) {
    // underbræt
    _gable_vindskede(-(G_VS_OUTER - G_VS_T),                _GR_ROOF_STACK,   palette);  // V1 front
    _gable_vindskede(RH_HOUSE_DEPTH + G_VS_OUTER,           _GR_ROOF_STACK,   palette);  // V2 back
    // overligger
    _gable_vindskede(-G_VS_OUTER,                           _GR_VS_OVER_TOP,  palette);  // V1 front
    _gable_vindskede(RH_HOUSE_DEPTH + G_VS_OUTER + G_VS_T,  _GR_VS_OVER_TOP,  palette);  // V2 back
}

// Composite (back-compat) — spær + vindskeder.
module RenderHouseGableRoof(truss = "haneband", palette = DEFAULT_PALETTE) {
    RenderHouseGableSpaer(truss, palette);
    RenderHouseGableVindskeder(palette);
}
