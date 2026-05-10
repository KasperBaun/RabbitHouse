// tagkonstruktion.scad — Spær + cover layers + sternbrædder + tagrende
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/roof.scad>
use <../../lib/bom.scad>
use <../../lib/primitives/beslag.scad>

SPAER_W       = 45;
SPAER_H       = 95;
SPAER_C2C     = 600;

// Real mono-pitch spær (rafters) replacing the polyhedron slab. 45×95
// c/c 600 mm, sloping from front toprem (high) to back toprem (low).
// Bears on the wall top plates with spaersko at each end (added in F8).
module v3_spaer(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; wt = V3_WALL_T;
    z_front = v3_roof_under_for(eh_back, wt) - SPAER_H;
    z_back  = v3_roof_under_for(eh_back, ww - wt) - SPAER_H;
    span_xy = ww - 2 * wt;
    span_3d = sqrt(span_xy * span_xy + (z_front - z_back) * (z_front - z_back));

    n = floor((ll - 2 * 100) / SPAER_C2C) + 1;
    for (i = [0 : n-1]) {
        x = 100 + i * SPAER_C2C;
        bom_member("spær", "spruce", SPAER_W, SPAER_H, span_3d,
                   "monopitch_rafter", system="tagkonstruktion");
        color(pal_post(palette))
        hull() {
            translate([x, wt, z_front])
                cube([SPAER_W, 0.01, SPAER_H]);
            translate([x, ww - wt - 0.01, z_back])
                cube([SPAER_W, 0.01, SPAER_H]);
        }
    }
}

module v3_tagkonstruktion(roof_cover = "tagpap", palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; wt = V3_WALL_T;
    roof_oz = v3_roof_oz();
    drop_full = v3_total_drop();
    rafter_eave_h = v3_roof_under(wt);
    rafter_drop = v3_roof_under(wt) - v3_roof_under(ww - wt);

    roof_mono_pitch([0, 0, roof_oz], ll, ww, drop_full, V3_ROOF_THICK,
                    V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE, palette);
    fascia_and_gutter_mono([0, 0, roof_oz], ll, ww, drop_full,
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, 0, palette);
    ceiling_rafters_mono([0, 0, 0], ll, ww, rafter_drop, rafter_eave_h,
                         900, 45, 140, wt, palette,
                         x_inset = wt + 55);
}
