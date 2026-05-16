// HOUSE roof-plate dispatcher — renders the cover (tagpap or eternit) over
// the house's roof segment.
//   standalone = false (combined build): plates cover X = -OH_SIDE..hl;
//                                        no right-side fascia cap (yard
//                                        provides that).
//   standalone = true  (house alone)   : plates cover X = -OH_SIDE..hl+OH_SIDE;
//                                        full overhang + right-side fascia cap.

include <../../lib/defaults.scad>
include <../config.scad>
use <../roof_plates_tagpap.scad>
use <../roof_plates_eternit.scad>

module RenderHouseRoofPlates(cover = "tagpap_osb", standalone = false,
                              palette = DEFAULT_PALETTE) {
    hl    = RH_HOUSE_LEN;
    x_lo  = -RH_OH_SIDE;
    x_hi  = standalone ? hl + RH_OH_SIDE : hl;

    if (cover == "tagpap_osb" || cover == "tagpap")
        render_roof_plates_tagpap_segment(x_lo, x_hi,
                                           has_left_side  = true,
                                           has_right_side = standalone,
                                           palette = palette);
    else if (cover == "eternit_b7" || cover == "eternit_10" || cover == "eternit_14")
        render_roof_plates_eternit_segment(cover, x_lo, x_hi, palette);
    else
        assert(false, str("Unknown cover: ", cover));
}
