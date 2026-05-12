// Tagpap cover stack — OSB deck + underlayment + roofing felt + aluminium
// fascia caps. Cover layers stack on top of the rafter framing (rendered
// by roof_structure.scad).
//
// Layer stack from rafter top upward:
//   0..18 mm  OSB deck       (carries the whole cover, nailed to rafters)
//   18..21    underlayment   (mechanically fixed to OSB)
//   21..25    roofing felt   (welded or glued to underlayment)
// + 2 mm aluminium fascia caps on all four eaves.
//
// Minimum pitch 2.5 deg per Phoenix Selvbygger spec; the 4.6 deg default
// is well within range.

include <../lib/defaults.scad>
include <config.scad>
use <roof_structure.scad>

OSB_T          = 18;
UNDERLAYMENT_T = 3;
FELT_T         = 4;

OSB_COLOR          = [0.78, 0.66, 0.42];
UNDERLAYMENT_COLOR = [0.18, 0.16, 0.14];
FELT_COLOR         = [0.08, 0.08, 0.08];
ALU_COLOR          = [0.78, 0.78, 0.80];

module render_osb_deck(eh_back, palette = DEFAULT_PALETTE) {
    _roof_layer(eh_back, 0, OSB_T, OSB_COLOR);
}

module render_underlayment(eh_back, palette = DEFAULT_PALETTE) {
    _roof_layer(eh_back, OSB_T, UNDERLAYMENT_T, UNDERLAYMENT_COLOR);
}

module render_roofing_felt(eh_back, palette = DEFAULT_PALETTE) {
    _roof_layer(eh_back, OSB_T + UNDERLAYMENT_T, FELT_T, FELT_COLOR);
}

// 35x25 mm aluminium cap profile that slides over the fascia top plus
// the rolled-up felt edge. 25 mm top flange covers the fascia top;
// 35 mm outer drop hangs down past the fascia face. Applied on all four
// eaves — straight on horizontal front/back, sloped on left/right.
//   fascia_top_offset = z-offset from roof_oz_for(eh_back) to fascia top
//                       (= cover_thick + STERN_LIP).
module render_fascia_caps(eh_back, fascia_top_offset, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    drop_full = total_drop_for(eh_back);
    roof_oz   = roof_oz_for(eh_back);
    z_front = roof_oz + fascia_top_offset;
    z_back  = roof_oz - drop_full + fascia_top_offset;

    CAP_W    = RH_FASCIA_T;
    CAP_DROP = 35;
    CAP_T    = 2;

    y_front_outer = -RH_OH_FRONT - RH_FASCIA_T;
    y_back_outer  = ww + RH_OH_BACK + RH_FASCIA_T;
    x_left_outer  = -RH_OH_SIDE - RH_FASCIA_T;
    x_right_outer = ll + RH_OH_SIDE + RH_FASCIA_T;

    color(ALU_COLOR) {
        translate([x_left_outer, y_front_outer, z_front])
            cube([x_right_outer - x_left_outer, RH_FASCIA_T, CAP_T]);
        translate([x_left_outer, y_front_outer - CAP_T, z_front - CAP_DROP])
            cube([x_right_outer - x_left_outer, CAP_T, CAP_DROP + CAP_T]);

        translate([x_left_outer, ww + RH_OH_BACK, z_back])
            cube([x_right_outer - x_left_outer, RH_FASCIA_T, CAP_T]);
        translate([x_left_outer, y_back_outer, z_back - CAP_DROP])
            cube([x_right_outer - x_left_outer, CAP_T, CAP_DROP + CAP_T]);

        hull() {
            translate([x_left_outer, y_front_outer, z_front])
                cube([RH_FASCIA_T, 0.01, CAP_T]);
            translate([x_left_outer, y_back_outer - 0.01, z_back])
                cube([RH_FASCIA_T, 0.01, CAP_T]);
        }
        hull() {
            translate([x_left_outer - CAP_T, y_front_outer, z_front - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            translate([x_left_outer - CAP_T, y_back_outer - 0.01, z_back - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
        }

        hull() {
            translate([ll + RH_OH_SIDE, y_front_outer, z_front])
                cube([RH_FASCIA_T, 0.01, CAP_T]);
            translate([ll + RH_OH_SIDE, y_back_outer - 0.01, z_back])
                cube([RH_FASCIA_T, 0.01, CAP_T]);
        }
        hull() {
            translate([x_right_outer, y_front_outer, z_front - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            translate([x_right_outer, y_back_outer - 0.01, z_back - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
        }
    }
}

// Entry point — cover layers + fascia caps. Fascia top z must match the
// fascia rendered in roof_structure (same formula).
module render_roof_plates_tagpap(palette = DEFAULT_PALETTE) {
    eh_back           = back_eave_height_for("tagpap_osb");
    fascia_top_offset = fascia_top_offset_for("tagpap_osb");
    render_osb_deck(eh_back, palette);
    render_underlayment(eh_back, palette);
    render_roofing_felt(eh_back, palette);
    render_fascia_caps(eh_back, fascia_top_offset, palette);
}
