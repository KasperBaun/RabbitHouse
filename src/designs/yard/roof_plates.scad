// YARD roof-plate dispatcher — renders the cover over the yard's roof
// segment. Four options: "tagpap", "eternit", "polycarb", "mesh".
// Passes yard depth + Y-offset + yard eave heights to the shared segment
// renderers.
//   standalone = false (combined build): plates cover X = hl..ll+OH_SIDE;
//                                        no left-side fascia cap (house
//                                        provides that).
//   standalone = true  (yard alone)    : plates cover X = hl-OH_SIDE..ll+OH_SIDE;
//                                        full left + right overhang.
//
// "mesh" is an open-top aviary lid — wire stops inside the enclosure
// (X=hl..ll), no overhang. Predator-proof, no weather barrier.

include <../../lib/defaults.scad>
include <../config.scad>
use <../roof_plates_tagpap.scad>
use <../roof_plates_eternit.scad>
use <../roof_plates_polycarb.scad>
use <../roof_plates_mesh.scad>

module RenderYardRoofPlates(cover = "polycarb", standalone = false,
                             palette = DEFAULT_PALETTE) {
    hl   = RH_HOUSE_LEN;
    ll   = RH_LENGTH;
    // Yard plates start at V5's yard-side outer face (= hl) so they butt
    // against the partition wall without piercing it.
    x_lo = standalone ? hl - RH_OH_SIDE : hl;
    x_hi = ll + RH_OH_SIDE;

    // Yard plates use yard wall heights AND yard Y-range — the yard roof
    // is independent of the (typically taller) house roof and sits on
    // Y=yo..yo+yd in world coords.
    yard_depth    = RH_YARD_DEPTH;
    yard_y_offset = RH_YARD_Y_OFFSET;

    if (cover == "tagpap")
        render_roof_plates_tagpap_segment(x_lo, x_hi,
                                           has_left_side  = standalone,
                                           has_right_side = true,
                                           eh_front = RH_YARD_EH_FRONT,
                                           eh_back  = RH_YARD_EH_BACK,
                                           depth    = yard_depth,
                                           y_offset = yard_y_offset,
                                           palette  = palette);
    else if (cover == "eternit")
        render_roof_plates_eternit_segment(x_lo, x_hi,
                                            eh_front = RH_YARD_EH_FRONT,
                                            eh_back  = RH_YARD_EH_BACK,
                                            depth    = yard_depth,
                                            y_offset = yard_y_offset,
                                            palette  = palette);
    else if (cover == "polycarb")
        render_roof_plates_polycarb_segment(x_lo, x_hi,
                                             eh_front = RH_YARD_EH_FRONT,
                                             eh_back  = RH_YARD_EH_BACK,
                                             depth    = yard_depth,
                                             y_offset = yard_y_offset,
                                             palette  = palette);
    else if (cover == "mesh")
        // Wire lid only covers enclosed area (X=hl..ll); overhangs stay open.
        render_roof_plates_mesh_segment(hl, ll,
                                         eh_front = RH_YARD_EH_FRONT,
                                         eh_back  = RH_YARD_EH_BACK,
                                         depth    = yard_depth,
                                         y_offset = yard_y_offset,
                                         mesh     = RH_MESH,
                                         palette  = palette);
    else
        assert(false, str("Unknown cover: ", cover));
}
