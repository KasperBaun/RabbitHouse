// YARD roof — rafters X>=1800 + right-side lookouts + front+back fascia/
// soffit [hl..x_right] + right-side fascia. Self-contained. Uses yard's
// own (lower) eave heights — RH_YARD_EH_FRONT / RH_YARD_EH_BACK — so the
// yard reads as a separate structure from the (taller) house.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/beslag.scad>

SOFFIT_T = 18;

// Rafters owned by YARD — 7 inner + V4 gable + right barge.
function _yard_rafter_xs() = [
    1800, 2400, 3000, 3600, 4200, 4800, 5400,
    RH_LENGTH - RH_RAFTER_W,           // V4 gable, 5955
    RH_LENGTH + RH_OH_SIDE - RH_RAFTER_W  // right barge, 6175
];

module _render_rafters_yard(palette) {
    ww = RH_WIDTH; sd = 95;
    y_start = -RH_OH_FRONT;
    y_end   = ww + RH_OH_BACK;
    z_start = yard_roof_underside(y_start) - RH_RAFTER_H;
    z_end   = yard_roof_underside(y_end)   - RH_RAFTER_H;
    z_v1_top = RH_BASE_H + RH_YARD_EH_FRONT;
    z_v2_top = RH_BASE_H + RH_YARD_EH_BACK;
    y_brk_f = sd / 2;
    y_brk_b = ww - sd / 2;
    BRK_W = 50; BRK_LEG = 90; BRK_T = 2;

    xs = _yard_rafter_xs();
    n  = len(xs);
    for (i = [0 : n - 1]) {
        x = xs[i];
        is_right_barge = (i == n - 1);

        color(pal_post(palette))
        hull() {
            translate([x, y_start, z_start])
                cube([RH_RAFTER_W, 0.01, RH_RAFTER_H]);
            translate([x, y_end - 0.01, z_end])
                cube([RH_RAFTER_W, 0.01, RH_RAFTER_H]);
        }

        vinkelbeslag([x, y_brk_f - BRK_W/2, z_v1_top],
                     leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                     orientation="-x+z");
        vinkelbeslag([x, y_brk_b - BRK_W/2, z_v2_top],
                     leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                     orientation="-x+z");
        if (!is_right_barge) {
            vinkelbeslag([x + RH_RAFTER_W, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                         orientation="+x+z");
            vinkelbeslag([x + RH_RAFTER_W, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W,
                         orientation="+x+z");
        }
    }
}

module _render_lookouts_yard(palette) {
    LOOKOUT_LEN = RH_OH_SIDE - RH_RAFTER_W;
    LOOKOUT_YS  = [47.5, RH_WIDTH/2, RH_WIDTH - 47.5];
    color(pal_post(palette))
    for (yc = LOOKOUT_YS) {
        z_top = yard_roof_underside(yc);
        z_bot = z_top - RH_RAFTER_H;
        y_min = yc - RH_RAFTER_W/2;
        translate([RH_LENGTH, y_min, z_bot])
            cube([LOOKOUT_LEN, RH_RAFTER_W, RH_RAFTER_H]);
    }
}

module _soffit_panel(x0, x1, y0, y1, palette) {
    z_top_y0 = yard_roof_underside(y0) - RH_RAFTER_H;
    z_top_y1 = yard_roof_underside(y1) - RH_RAFTER_H;
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

module _render_soffit_yard(palette) {
    hl = RH_HOUSE_LEN; ll = RH_LENGTH; ww = RH_WIDTH;
    x_left  = hl + RH_POST_W/2;     // starts past V5 yard-side face
    x_right = ll + RH_OH_SIDE + RH_FASCIA_T;
    _soffit_panel(x_left, x_right, -RH_OH_FRONT, 0, palette);
    _soffit_panel(x_left, x_right, ww, ww + RH_OH_BACK, palette);
    _soffit_panel(ll, x_right, 0, ww, palette);
}

module _render_fascia_yard(fascia_top_offset, palette) {
    hl = RH_HOUSE_LEN; ll = RH_LENGTH; ww = RH_WIDTH;
    drop_full = yard_total_drop();
    roof_oz   = yard_roof_oz();
    z_front_top = roof_oz + fascia_top_offset;
    z_back_top  = roof_oz - drop_full + fascia_top_offset;
    fascia_h = 140;
    fascia_t = RH_FASCIA_T;

    fx_lo = hl + RH_POST_W/2;
    fx_hi = ll + RH_OH_SIDE + fascia_t;
    y0 = -RH_OH_FRONT;
    y1 = ww + RH_OH_BACK;

    color(pal_trim(palette)) {
        translate([fx_lo, y0, z_front_top - fascia_h])
            cube([fx_hi - fx_lo, fascia_t, fascia_h]);
        translate([fx_lo, y1 - fascia_t, z_back_top - fascia_h])
            cube([fx_hi - fx_lo, fascia_t, fascia_h]);
        hull() {
            translate([fx_hi - fascia_t, y0, z_front_top - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
            translate([fx_hi - fascia_t, y1, z_back_top - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
        }
    }
}

module RenderYardRoof(roof_cover, palette = DEFAULT_PALETTE) {
    fascia_top_offset = fascia_top_offset_for(roof_cover);
    _render_rafters_yard(palette);
    _render_lookouts_yard(palette);
    _render_soffit_yard(palette);
    _render_fascia_yard(fascia_top_offset, palette);
}
