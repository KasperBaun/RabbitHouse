// YARD roof-plate dispatcher — renders the cover (tagpap or eternit) over
// the yard's roof segment.
//   standalone = false (combined build): plates cover X = hl..ll+OH_SIDE;
//                                        no left-side fascia cap (house
//                                        provides that).
//   standalone = true  (yard alone)    : plates cover X = hl-OH_SIDE..ll+OH_SIDE;
//                                        full left + right overhang.

include <../../lib/defaults.scad>
include <../config.scad>
use <../roof_plates_tagpap.scad>
use <../roof_plates_eternit.scad>

module RenderYardRoofPlates(cover = "tagpap_osb", standalone = false,
                             palette = DEFAULT_PALETTE) {
    hl   = RH_HOUSE_LEN;
    ll   = RH_LENGTH;
    x_lo = standalone ? hl - RH_OH_SIDE : hl;
    x_hi = ll + RH_OH_SIDE;

    if (cover == "tagpap_osb" || cover == "tagpap")
        render_roof_plates_tagpap_segment(x_lo, x_hi,
                                           has_left_side  = standalone,
                                           has_right_side = true,
                                           palette = palette);
    else if (cover == "eternit_b7" || cover == "eternit_10" || cover == "eternit_14")
        render_roof_plates_eternit_segment(cover, x_lo, x_hi, palette);
    else
        assert(false, str("Unknown cover: ", cover));
}
