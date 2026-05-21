// HOUSE roof-plate dispatcher — renders the cover over the house's roof
// segment. Three options: "skifer" (gable, gable roof in roof_gable.scad),
// "tagpap" (mono-pitch OSB + felt), "eternit" (mono-pitch C18 + Cembrit B7).
//   standalone = false (combined build): plates cover X = -OH_SIDE..hl;
//                                        no right-side fascia cap (yard
//                                        provides that).
//   standalone = true  (house alone)   : plates cover X = -OH_SIDE..hl+OH_SIDE;
//                                        full overhang + right-side fascia cap.

include <../../lib/defaults.scad>
include <../config.scad>
use <../roof_plates_tagpap.scad>
use <../roof_plates_eternit.scad>
use <../roof_plates_skifer.scad>

module RenderHouseRoofPlates(cover = "tagpap", standalone = false,
                              palette = DEFAULT_PALETTE) {
    hl    = RH_HOUSE_LEN;
    x_lo  = -RH_OH_SIDE;
    // Boundary at V5's yard-side outer face (= hl, since V5 sits inside the
    // house footprint). V5 is owned by house, so the cover fully shields it.
    x_hi  = standalone ? hl + RH_OH_SIDE : hl;

    if (cover == "skifer")
        render_roof_plates_skifer_gable(palette);
    else if (cover == "tagpap")
        render_roof_plates_tagpap_segment(x_lo, x_hi,
                                           has_left_side  = true,
                                           has_right_side = standalone,
                                           palette = palette);
    else if (cover == "eternit")
        render_roof_plates_eternit_segment(x_lo, x_hi,
                                            eh_back = back_eave_height_for("eternit"),
                                            palette = palette);
    else
        assert(false, str("Unknown cover: ", cover));
}
