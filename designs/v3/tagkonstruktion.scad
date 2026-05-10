// tagkonstruktion.scad — Spær + cover layers + sternbrædder + tagrende
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/roof.scad>
use <../../lib/bom.scad>

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
