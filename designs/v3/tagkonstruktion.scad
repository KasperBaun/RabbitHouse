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
        spaersko([x, wt - 2, z_front], SPAER_W, SPAER_H, slope=0);
        spaersko([x, ww - wt - SPAER_H + 2, z_back], SPAER_W, SPAER_H, slope=0);
    }
}

// Tagpap cover: 22 mm forskalling (raw planks) + 2-lag tagpap on top of
// the spær. Min slope 2°. Standard for v3's 9° pitch.
module v3_cover_tagpap(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz = v3_roof_oz_for(eh_back);
    span_y = ww + V3_OH_FRONT + V3_OH_BACK;
    span_x = ll + V3_OH_SIDE * 2;
    area = span_x * sqrt(span_y * span_y + drop_full * drop_full) / 1e6;

    // 22 mm forskalling deck (sloped polyhedron — replaces the old solid roof)
    bom_member("forskalling", "spruce", 22, span_x, span_y,
               str("tagpap_deck_", area, "_m2"), system="tagkonstruktion");
    color([0.74, 0.62, 0.40])
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 22],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 22],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 22],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 22],
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );

    // Tagpap (2-lag) — represented as the existing roof_mono_pitch black slab.
    bom_member("tagpap", "bitumen", 0, 0, 0,
               str("2lag_underpap_svejsepap_", area, "_m2"),
               system="tagkonstruktion");
    roof_mono_pitch([0, 0, roof_oz], ll, ww, drop_full, V3_ROOF_THICK,
                    V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE, palette);
}

// Stålplade cover: undertag membrane + 25×50 afstandsliste along spær +
// 38×73 lægter c/c 600 perpendicular + 0.5 mm trapezstål. Min slope 3°.
module v3_cover_staal(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz = v3_roof_oz_for(eh_back);
    span_y = ww + V3_OH_FRONT + V3_OH_BACK;
    span_x = ll + V3_OH_SIDE * 2;
    area = span_x * sqrt(span_y * span_y + drop_full * drop_full) / 1e6;

    // Undertag: thin grey membrane on top of spær
    bom_member("undertag", "polyolefin", 1, span_x, span_y,
               str("undertag_", area, "_m2"), system="tagkonstruktion");
    color([0.40, 0.40, 0.42])
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 1],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 1],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 1],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 1],
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );

    // Lægter 38×73 c/c 600 perpendicular to spær (running in X direction)
    n_laegter = floor(span_y / 600) + 1;
    bom_member("lægte", "spruce", 38, 73, span_x,
               "trapezstal_lægte", system="tagkonstruktion", count=n_laegter);

    // Trapezstål 0.5 mm — represented as a single sloped slab in metallic colour.
    bom_member("trapezstål", "steel-galv", 0.5, span_x, span_y,
               str("trapez_", area, "_m2"), system="tagkonstruktion");
    color([0.72, 0.72, 0.74])
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 100],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 100],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 100],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 100],
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 80],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 80],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 80],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 80]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

// Eternit B6 cover: undertag + 25×50 afstandsliste + 38×73 lægter c/c 1085
// + Cembrit B6 8 mm bølgeplader. Min slope 10° (with extended overlap)
// or 14° standard. Used for both eternit_10 and eternit_14 (eh_back
// already lowered by v3_eh_back_for).
module v3_cover_eternit(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz = v3_roof_oz_for(eh_back);
    span_y = ww + V3_OH_FRONT + V3_OH_BACK;
    span_x = ll + V3_OH_SIDE * 2;
    area = span_x * sqrt(span_y * span_y + drop_full * drop_full) / 1e6;

    // Undertag membrane (same as stål)
    bom_member("undertag", "polyolefin", 1, span_x, span_y,
               str("undertag_", area, "_m2"), system="tagkonstruktion");
    color([0.40, 0.40, 0.42])
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 1],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 1],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 1],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 1],
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );

    // Lægter c/c 1085 mm (Cembrit B6 standard)
    n_laegter = floor(span_y / 1085) + 1;
    bom_member("lægte", "spruce", 38, 73, span_x,
               "eternit_b6_lægte", system="tagkonstruktion", count=n_laegter);

    // Cembrit B6 8 mm bølgeplade — represented as grey sloped slab.
    bom_member("cembrit_b6", "fiber-cement", 8, span_x, span_y,
               str("b6_", area, "_m2"), system="tagkonstruktion");
    color([0.55, 0.55, 0.57])
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 130],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 130],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 130],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 130],
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 122],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz + 122],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 122],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full + 122]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

module v3_tagkonstruktion(roof_cover = "tagpap", palette = DEFAULT_PALETTE) {
    eh_back = v3_eh_back_for(roof_cover);

    // Spær — same regardless of cover.
    v3_spaer(eh_back, palette);

    // Cover layers.
    if (roof_cover == "tagpap")           v3_cover_tagpap(eh_back, palette);
    else if (roof_cover == "stål" || roof_cover == "staal")
                                          v3_cover_staal(eh_back, palette);
    else if (roof_cover == "eternit_10")  v3_cover_eternit(eh_back, palette);
    else if (roof_cover == "eternit_14")  v3_cover_eternit(eh_back, palette);
    else assert(false, str("unknown roof_cover: ", roof_cover));

    // Sternbrædder + tagrende.
    fascia_and_gutter_mono([0, 0, v3_roof_oz_for(eh_back)],
                           V3_LENGTH, V3_WIDTH, v3_total_drop_for(eh_back),
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, 0, palette);

}
