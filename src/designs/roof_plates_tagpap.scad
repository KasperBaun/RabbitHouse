// Tagpap cover stack — OSB deck + underlayment + roofing felt + aluminium
// fascia caps. Cover layers stack on top of the rafter framing.
//
// Layer stack from rafter top upward:
//   0..18 mm  OSB deck       (carries the whole cover, nailed to rafters)
//   18..21    underlayment   (mechanically fixed to OSB)
//   21..25    roofing felt   (welded or glued to underlayment)
// + 2 mm aluminium fascia caps on all four eaves.
//
// Entry: render_roof_plates_tagpap_segment(x_lo, x_hi, ...). The segment
// accepts (eh_front, eh_back, depth, y_offset) so callers in either zone
// can render at the right elevation and Y range. Defaults are HOUSE values;
// the YARD dispatcher overrides them.

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
module _roof_layer(eh_front, eh_back, depth, y_offset,
                   offset_z, thick, color_rgb, x_lo, x_hi) {
    drop_full = _roof_drop(eh_front, eh_back, depth);
    roof_oz   = _roof_oz(eh_front, eh_back, depth);
    y_lo = y_offset - RH_OH_FRONT;
    y_hi = y_offset + depth + RH_OH_BACK;
    color(color_rgb)
    polyhedron(
        points = [
            [x_lo, y_lo, roof_oz + offset_z],
            [x_hi, y_lo, roof_oz + offset_z],
            [x_hi, y_hi, roof_oz - drop_full + offset_z],
            [x_lo, y_hi, roof_oz - drop_full + offset_z],
            [x_lo, y_lo, roof_oz + offset_z + thick],
            [x_hi, y_lo, roof_oz + offset_z + thick],
            [x_hi, y_hi, roof_oz - drop_full + offset_z + thick],
            [x_lo, y_hi, roof_oz - drop_full + offset_z + thick]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

// Fascia caps for an X segment. Front + back caps span [x_lo..x_hi]; left
// and right side caps render only when the corresponding flag is set.
module _render_fascia_caps_segment(eh_front, eh_back, depth, y_offset,
                                   fascia_top_offset,
                                   x_lo, x_hi,
                                   has_left_side, has_right_side) {
    drop_full = _roof_drop(eh_front, eh_back, depth);
    roof_oz   = _roof_oz(eh_front, eh_back, depth);
    z_front = roof_oz + fascia_top_offset;
    z_back  = roof_oz - drop_full + fascia_top_offset;

    CAP_DROP = 35;
    CAP_T    = 2;

    y_front_inner = y_offset - RH_OH_FRONT;
    y_back_inner  = y_offset + depth + RH_OH_BACK;
    y_front_outer = y_front_inner - RH_FASCIA_T;
    y_back_outer  = y_back_inner  + RH_FASCIA_T;
    fx_lo = has_left_side  ? x_lo - RH_FASCIA_T : x_lo;
    fx_hi = has_right_side ? x_hi + RH_FASCIA_T : x_hi;

    color(ALU_COLOR) {
        // Front-eave horizontal cap.
        translate([fx_lo, y_front_outer, z_front])
            cube([fx_hi - fx_lo, RH_FASCIA_T, CAP_T]);
        translate([fx_lo, y_front_outer - CAP_T, z_front - CAP_DROP])
            cube([fx_hi - fx_lo, CAP_T, CAP_DROP + CAP_T]);
        // Back-eave horizontal cap.
        translate([fx_lo, y_back_inner, z_back])
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
                                          eh_front = RH_EH_FRONT,
                                          eh_back  = RH_EH_BACK,
                                          depth    = RH_HOUSE_DEPTH,
                                          y_offset = 0,
                                          palette  = DEFAULT_PALETTE) {
    fascia_top_offset = fascia_top_offset_for("tagpap");
    _roof_layer(eh_front, eh_back, depth, y_offset,
                0,                              OSB_T,          OSB_COLOR,          x_lo, x_hi);
    _roof_layer(eh_front, eh_back, depth, y_offset,
                OSB_T,                          UNDERLAYMENT_T, UNDERLAYMENT_COLOR, x_lo, x_hi);
    _roof_layer(eh_front, eh_back, depth, y_offset,
                OSB_T + UNDERLAYMENT_T,         FELT_T,         FELT_COLOR,         x_lo, x_hi);
    _render_fascia_caps_segment(eh_front, eh_back, depth, y_offset,
                                fascia_top_offset,
                                x_lo, x_hi, has_left_side, has_right_side);
}

