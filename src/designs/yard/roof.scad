// YARD roof — rafters X>=1800 + right-side lookouts + front+back fascia/
// soffit [hl..x_right] + right-side fascia/soffit + downspout. Self-contained.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/beslag.scad>

SOFFIT_T = 18;

function fascia_top_offset_for(cover) =
      cover == "tagpap_osb" || cover == "tagpap" ?
        (18 + 3 + 4) + 7
    : cover == "eternit_b7" || cover == "eternit_10" || cover == "eternit_14" ?
        (38 - 8)
    : 0;

// Rafters owned by YARD — 7 inner + V4 gable + right barge.
function _yard_rafter_xs() = [
    1800, 2400, 3000, 3600, 4200, 4800, 5400,
    RH_LENGTH - RH_RAFTER_W,           // V4 gable, 5955
    RH_LENGTH + RH_OH_SIDE - RH_RAFTER_W  // right barge, 6175
];

module _render_rafters_yard(eh_back, palette) {
    ww = RH_WIDTH; sd = 95;
    y_start = -RH_OH_FRONT;
    y_end   = ww + RH_OH_BACK;
    z_start = roof_underside_for(eh_back, y_start) - RH_RAFTER_H;
    z_end   = roof_underside_for(eh_back, y_end)   - RH_RAFTER_H;
    z_v1_top = RH_BASE_H + RH_EH_FRONT;
    z_v2_top = RH_BASE_H + RH_EH_BACK;
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

        // Left-side bracket (always — connects to neighbouring yard rafter or
        // to the house's right edge).
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

module _render_lookouts_yard(eh_back, palette) {
    LOOKOUT_LEN = RH_OH_SIDE - RH_RAFTER_W;
    LOOKOUT_YS  = [47.5, RH_WIDTH/2, RH_WIDTH - 47.5];
    color(pal_post(palette))
    for (yc = LOOKOUT_YS) {
        z_top = roof_underside_for(eh_back, yc);
        z_bot = z_top - RH_RAFTER_H;
        y_min = yc - RH_RAFTER_W/2;
        translate([RH_LENGTH, y_min, z_bot])
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

module _render_soffit_yard(eh_back, palette) {
    hl = RH_HOUSE_LEN; ll = RH_LENGTH; ww = RH_WIDTH;
    x_right = ll + RH_OH_SIDE + RH_FASCIA_T;
    _soffit_panel(hl, x_right, -RH_OH_FRONT, 0, eh_back, palette);
    _soffit_panel(hl, x_right, ww, ww + RH_OH_BACK, eh_back, palette);
    _soffit_panel(ll, x_right, 0, ww, eh_back, palette);
}

// Fascia only — no gutter / downspout. Front+back [hl..x_right] + right side.
module _render_fascia_yard(eh_back, fascia_top_offset, palette) {
    hl = RH_HOUSE_LEN; ll = RH_LENGTH; ww = RH_WIDTH;
    drop_full = total_drop_for(eh_back);
    roof_oz   = roof_oz_for(eh_back);
    z_front_top = roof_oz + fascia_top_offset;
    z_back_top  = roof_oz - drop_full + fascia_top_offset;
    fascia_h = 140;
    fascia_t = RH_FASCIA_T;

    fx_lo = hl;
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
    eh_back           = back_eave_height_for(roof_cover);
    fascia_top_offset = fascia_top_offset_for(roof_cover);
    _render_rafters_yard(eh_back, palette);
    _render_lookouts_yard(eh_back, palette);
    _render_soffit_yard(eh_back, palette);
    _render_fascia_yard(eh_back, fascia_top_offset, palette);
}
