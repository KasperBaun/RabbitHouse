// HOUSE roof — rafters X<=1200 + left-side lookouts + front+back fascia/
// soffit [x_left..hl] + left-side fascia/soffit. Self-contained: helpers
// live in this file. Cover layers (OSB/eternit) are shared and live in
// designs/roof_plates*.scad.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/beslag.scad>
use <roof_gable.scad>

SOFFIT_T = 18;

// fascia_top_offset_for() lives in config.scad — covers tagpap, eternit, polycarb.

// Rafters owned by HOUSE — left barge + V3 gable + first two inner rafters.
_HOUSE_RAFTER_XS = [
    -RH_OH_SIDE,    // left barge
    0,              // V3 gable
    600,
    1200
];

module _render_rafters_house(eh_back, palette) {
    ww = RH_HOUSE_DEPTH; sd = 95;
    y_start = -RH_OH_FRONT;
    y_end   = ww + RH_OH_BACK;
    z_start = roof_underside_for(eh_back, y_start) - RH_RAFTER_H;
    z_end   = roof_underside_for(eh_back, y_end)   - RH_RAFTER_H;
    z_v1_top = RH_BASE_H + RH_EH_FRONT;
    z_v2_top = RH_BASE_H + RH_EH_BACK;
    y_brk_f = sd / 2;
    y_brk_b = ww - sd / 2;
    BRK_W = 50; BRK_LEG = 90; BRK_T = 2;

    for (i = [0 : len(_HOUSE_RAFTER_XS) - 1]) {
        x = _HOUSE_RAFTER_XS[i];
        is_left_barge = (i == 0);

        color(pal_post(palette))
        hull() {
            translate([x, y_start, z_start])
                cube([RH_RAFTER_W, 0.01, RH_RAFTER_H]);
            translate([x, y_end - 0.01, z_end])
                cube([RH_RAFTER_W, 0.01, RH_RAFTER_H]);
        }

        if (!is_left_barge) {
            vinkelbeslag([x, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                         orientation="-x+z");
            vinkelbeslag([x, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                         orientation="-x+z");
        }
        // Right side bracket — all 4 house rafters get one (the next rafter
        // on the right is yard's, but its left-side bracket attaches there).
        vinkelbeslag([x + RH_RAFTER_W, y_brk_f - BRK_W/2, z_v1_top],
                     leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                     orientation="+x+z");
        vinkelbeslag([x + RH_RAFTER_W, y_brk_b - BRK_W/2, z_v2_top],
                     leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                     orientation="+x+z");
    }
}

// Left-side lookouts — 3 stk, between barge and V3 gable rafter.
module _render_lookouts_house(eh_back, palette) {
    LOOKOUT_LEN = RH_OH_SIDE - RH_RAFTER_W;
    LOOKOUT_YS  = [47.5, RH_HOUSE_DEPTH/2, RH_HOUSE_DEPTH - 47.5];
    color(pal_post(palette))
    for (yc = LOOKOUT_YS) {
        z_top = roof_underside_for(eh_back, yc);
        z_bot = z_top - RH_RAFTER_H;
        y_min = yc - RH_RAFTER_W/2;
        translate([-RH_OH_SIDE + RH_RAFTER_W, y_min, z_bot])
            cube([LOOKOUT_LEN, RH_RAFTER_W, RH_RAFTER_H]);
    }
}

module _soffit_panel(x0, x1, y0, y1, eh_back, palette) {
    z_top_y0 = roof_underside_for(eh_back, y0) - RH_RAFTER_H;
    z_top_y1 = roof_underside_for(eh_back, y1) - RH_RAFTER_H;
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x0, y0, z_top_y0 - SOFFIT_T],
            [x1, y0, z_top_y0 - SOFFIT_T],
            [x1, y1, z_top_y1 - SOFFIT_T],
            [x0, y1, z_top_y1 - SOFFIT_T],
            [x0, y0, z_top_y0],
            [x1, y0, z_top_y0],
            [x1, y1, z_top_y1],
            [x0, y1, z_top_y1]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

module _render_soffit_house(eh_back, palette) {
    hl = RH_HOUSE_LEN; ww = RH_HOUSE_DEPTH;
    x_left  = -RH_OH_SIDE - RH_FASCIA_T;
    // Soffit extends to V5's yard-side face (=hl) so the partition is fully
    // tucked under the house roof eave.
    x_right = hl;
    _soffit_panel(x_left, x_right, -RH_OH_FRONT, 0, eh_back, palette);
    _soffit_panel(x_left, x_right, ww, ww + RH_OH_BACK, eh_back, palette);
    _soffit_panel(x_left, 0, 0, ww, eh_back, palette);
}

// Fascia only — no gutter / downspout. Front+back [x_left..hl] + left side.
module _render_fascia_house(eh_back, fascia_top_offset, palette) {
    hl = RH_HOUSE_LEN; ww = RH_HOUSE_DEPTH;
    drop_full = total_drop_for(eh_back);
    roof_oz   = roof_oz_for(eh_back);
    z_front_top = roof_oz + fascia_top_offset;
    z_back_top  = roof_oz - drop_full + fascia_top_offset;
    fascia_h = 140;
    fascia_t = RH_FASCIA_T;

    fx_lo = -RH_OH_SIDE - fascia_t;
    fx_hi = hl;
    y0 = -RH_OH_FRONT;
    y1 = ww + RH_OH_BACK;

    color(pal_trim(palette)) {
        translate([fx_lo, y0, z_front_top - fascia_h])
            cube([fx_hi - fx_lo, fascia_t, fascia_h]);
        translate([fx_lo, y1 - fascia_t, z_back_top - fascia_h])
            cube([fx_hi - fx_lo, fascia_t, fascia_h]);
        hull() {
            translate([fx_lo, y0, z_front_top - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
            translate([fx_lo, y1, z_back_top - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
        }
    }
}

module RenderHouseRoof(roof_cover, truss = "haneband", palette = DEFAULT_PALETTE) {
    if (is_gable_roof(roof_cover)) {
        RenderHouseGableRoof(truss, palette);
    } else {
        eh_back           = back_eave_height_for(roof_cover);
        fascia_top_offset = fascia_top_offset_for(roof_cover);
        _render_rafters_house(eh_back, palette);
        _render_lookouts_house(eh_back, palette);
        _render_soffit_house(eh_back, palette);
        _render_fascia_house(eh_back, fascia_top_offset, palette);
    }
}
