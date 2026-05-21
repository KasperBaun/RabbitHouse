// Bitumen shingles cover stack — OSB deck + underlay + asphalt shingles.
// Product: Tagshingels sort, 3 m² pakke (jemogfix.dk/9053758/).
//
// Layer stack from rafter top upward:
//   0..18 mm  OSB-3 deck (carries the shingles, nailed to rafters)
//   18..21    self-adhesive underlay
//   21..26    shingles (~5 mm visible thickness incl. overlap doubling)
//
// Pitch: standard shingles want ≥ 15° (1:3.7); the default 4,6° in this
// model is BELOW spec — visualisation only. For a real build pick the
// eternit_14 slope (back eave ≈ 1976 mm) or steeper.

include <../lib/defaults.scad>
include <config.scad>

SHINGLES_OSB_T       = 18;
SHINGLES_UNDERLAY_T  = 3;
SHINGLES_T           = 5;

SHINGLES_OSB_COLOR   = [0.78, 0.66, 0.42];
SHINGLES_UND_COLOR   = [0.18, 0.16, 0.14];
SHINGLES_COLOR       = [0.08, 0.08, 0.08];

// Sloped slab parallel to the rafter top, restricted to [x_lo..x_hi].
module _shingles_layer(x_lo, x_hi, eh_front, eh_back, depth, y_offset,
                       offset_z, thick, color_rgb) {
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

// Visible shingle-row lines — thin gaps every 333 mm along Y to suggest
// the staggered bond. Pure cosmetic; the actual `_shingles_layer` slab
// gives the bulk and color.
module _shingle_row_lines(x_lo, x_hi, eh_front, eh_back, depth, y_offset) {
    n         = floor((depth + RH_OH_BACK + RH_OH_FRONT) / 333);
    color([0.04, 0.04, 0.04])
    for (i = [1 : n]) {
        y = y_offset - RH_OH_FRONT + i * 333;
        z = _roof_underside(eh_front, eh_back, depth, y_offset, y)
            + SHINGLES_OSB_T + SHINGLES_UNDERLAY_T + SHINGLES_T - 0.5;
        translate([x_lo, y, z])
            cube([x_hi - x_lo, 1, 1]);
    }
}

module render_roof_plates_shingles_segment(x_lo, x_hi,
                                            eh_front = RH_EH_FRONT,
                                            eh_back  = RH_EH_BACK,
                                            depth    = RH_HOUSE_DEPTH,
                                            y_offset = 0,
                                            palette  = DEFAULT_PALETTE) {
    _shingles_layer(x_lo, x_hi, eh_front, eh_back, depth, y_offset, 0,
                    SHINGLES_OSB_T, SHINGLES_OSB_COLOR);
    _shingles_layer(x_lo, x_hi, eh_front, eh_back, depth, y_offset, SHINGLES_OSB_T,
                    SHINGLES_UNDERLAY_T, SHINGLES_UND_COLOR);
    _shingles_layer(x_lo, x_hi, eh_front, eh_back, depth, y_offset,
                    SHINGLES_OSB_T + SHINGLES_UNDERLAY_T,
                    SHINGLES_T, SHINGLES_COLOR);
    _shingle_row_lines(x_lo, x_hi, eh_front, eh_back, depth, y_offset);
}

module render_roof_plates_shingles(palette = DEFAULT_PALETTE) {
    render_roof_plates_shingles_segment(-RH_OH_SIDE,
                                         RH_LENGTH + RH_OH_SIDE,
                                         palette = palette);
}
