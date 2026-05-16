// Tagpap cover stack — OSB deck + underlayment + roofing felt + aluminium
// fascia caps. Cover layers stack on top of the rafter framing.
//
// Layer stack from rafter top upward:
//   0..18 mm  OSB deck       (carries the whole cover, nailed to rafters)
//   18..21    underlayment   (mechanically fixed to OSB)
//   21..25    roofing felt   (welded or glued to underlayment)
// + 2 mm aluminium fascia caps on all four eaves.
//
// Two entry forms:
//   render_roof_plates_tagpap()                              — full footprint
//   render_roof_plates_tagpap_segment(x_lo, x_hi,
//                                     has_left_side,
//                                     has_right_side, ...)   — zone segment

include <../lib/defaults.scad>
include <config.scad>

OSB_T          = 18;
UNDERLAYMENT_T = 3;
FELT_T         = 4;

// fascia_top_offset_for() lives in config.scad — covers tagpap, eternit, polycarb.

OSB_COLOR          = [0.78, 0.66, 0.42];
UNDERLAYMENT_COLOR = [0.18, 0.16, 0.14];
FELT_COLOR         = [0.08, 0.08, 0.08];
ALU_COLOR          = [0.78, 0.78, 0.80];

// Sloped slab parallel to roof underside, restricted to [x_lo..x_hi].
module _roof_layer(eh_back, offset_z, thick, color_rgb, x_lo, x_hi) {
    ww = RH_WIDTH;
    drop_full = total_drop_for(eh_back);
    roof_oz   = roof_oz_for(eh_back);
    color(color_rgb)
    polyhedron(
        points = [
            [x_lo, -RH_OH_FRONT,        roof_oz + offset_z],
            [x_hi, -RH_OH_FRONT,        roof_oz + offset_z],
            [x_hi, ww + RH_OH_BACK,     roof_oz - drop_full + offset_z],
            [x_lo, ww + RH_OH_BACK,     roof_oz - drop_full + offset_z],
            [x_lo, -RH_OH_FRONT,        roof_oz + offset_z + thick],
            [x_hi, -RH_OH_FRONT,        roof_oz + offset_z + thick],
            [x_hi, ww + RH_OH_BACK,     roof_oz - drop_full + offset_z + thick],
            [x_lo, ww + RH_OH_BACK,     roof_oz - drop_full + offset_z + thick]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

// Fascia caps for an X segment. Front + back caps span [x_lo..x_hi]; left
// and right side caps render only when the corresponding flag is set.
module _render_fascia_caps_segment(eh_back, fascia_top_offset,
                                   x_lo, x_hi,
                                   has_left_side, has_right_side) {
    ww = RH_WIDTH;
    drop_full = total_drop_for(eh_back);
    roof_oz   = roof_oz_for(eh_back);
    z_front = roof_oz + fascia_top_offset;
    z_back  = roof_oz - drop_full + fascia_top_offset;

    CAP_DROP = 35;
    CAP_T    = 2;

    y_front_outer = -RH_OH_FRONT - RH_FASCIA_T;
    y_back_outer  = ww + RH_OH_BACK + RH_FASCIA_T;
    fx_lo = has_left_side  ? x_lo - RH_FASCIA_T : x_lo;
    fx_hi = has_right_side ? x_hi + RH_FASCIA_T : x_hi;

    color(ALU_COLOR) {
        // Front-eave horizontal cap.
        translate([fx_lo, y_front_outer, z_front])
            cube([fx_hi - fx_lo, RH_FASCIA_T, CAP_T]);
        translate([fx_lo, y_front_outer - CAP_T, z_front - CAP_DROP])
            cube([fx_hi - fx_lo, CAP_T, CAP_DROP + CAP_T]);
        // Back-eave horizontal cap.
        translate([fx_lo, ww + RH_OH_BACK, z_back])
            cube([fx_hi - fx_lo, RH_FASCIA_T, CAP_T]);
        translate([fx_lo, y_back_outer, z_back - CAP_DROP])
            cube([fx_hi - fx_lo, CAP_T, CAP_DROP + CAP_T]);

        if (has_left_side) {
            hull() {
                translate([fx_lo, y_front_outer, z_front])
                    cube([RH_FASCIA_T, 0.01, CAP_T]);
                translate([fx_lo, y_back_outer - 0.01, z_back])
                    cube([RH_FASCIA_T, 0.01, CAP_T]);
            }
            hull() {
                translate([fx_lo - CAP_T, y_front_outer, z_front - CAP_DROP])
                    cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
                translate([fx_lo - CAP_T, y_back_outer - 0.01, z_back - CAP_DROP])
                    cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            }
        }
        if (has_right_side) {
            hull() {
                translate([fx_hi - RH_FASCIA_T, y_front_outer, z_front])
                    cube([RH_FASCIA_T, 0.01, CAP_T]);
                translate([fx_hi - RH_FASCIA_T, y_back_outer - 0.01, z_back])
                    cube([RH_FASCIA_T, 0.01, CAP_T]);
            }
            hull() {
                translate([fx_hi, y_front_outer, z_front - CAP_DROP])
                    cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
                translate([fx_hi, y_back_outer - 0.01, z_back - CAP_DROP])
                    cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            }
        }
    }
}

// Segment renderer — used by zone dispatchers.
module render_roof_plates_tagpap_segment(x_lo, x_hi,
                                          has_left_side, has_right_side,
                                          palette = DEFAULT_PALETTE) {
    eh_back           = back_eave_height_for("tagpap_osb");
    fascia_top_offset = fascia_top_offset_for("tagpap_osb");
    _roof_layer(eh_back, 0,                              OSB_T,          OSB_COLOR,          x_lo, x_hi);
    _roof_layer(eh_back, OSB_T,                          UNDERLAYMENT_T, UNDERLAYMENT_COLOR, x_lo, x_hi);
    _roof_layer(eh_back, OSB_T + UNDERLAYMENT_T,         FELT_T,         FELT_COLOR,         x_lo, x_hi);
    _render_fascia_caps_segment(eh_back, fascia_top_offset,
                                x_lo, x_hi, has_left_side, has_right_side);
}

// Full-footprint renderer — backward-compat for the combined `RenderRoofPlates`.
module render_roof_plates_tagpap(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH;
    render_roof_plates_tagpap_segment(-RH_OH_SIDE, ll + RH_OH_SIDE,
                                       true, true, palette);
}
