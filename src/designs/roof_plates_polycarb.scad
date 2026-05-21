// Polycarbonate cover — single translucent slab mounted DIRECTLY on the
// rafters (no battens, no OSB deck). Plate sits at z = rafter top with
// 12 mm thickness; secured with self-drilling screws + neoprene washers
// through every other rafter crest. Yard-only cover.
//
// Pitch: works at the default 4,6° per Plastmo / Acryltec specs (min
// recommended 5°; we're close enough for a rabbit shed, and the corrugation
// profile would normally accept lower pitches than smooth polycarb).
//
// Entry: render_roof_plates_polycarb_segment(x_lo, x_hi, ...). Accepts
// (eh_front, eh_back, depth, y_offset). Defaults are HOUSE values; the YARD
// dispatcher overrides all four.

include <../lib/defaults.scad>
include <config.scad>

POLYCARB_T = 12;

module _polycarb_slab(x_lo, x_hi, eh_front, eh_back, depth, y_offset, palette) {
    drop_full = _roof_drop(eh_front, eh_back, depth);
    roof_oz   = _roof_oz(eh_front, eh_back, depth);
    y_lo = y_offset - RH_OH_FRONT;
    y_hi = y_offset + depth + RH_OH_BACK;
    color(pal_polycarb(palette))
    polyhedron(
        points = [
            [x_lo, y_lo, roof_oz],
            [x_hi, y_lo, roof_oz],
            [x_hi, y_hi, roof_oz - drop_full],
            [x_lo, y_hi, roof_oz - drop_full],
            [x_lo, y_lo, roof_oz + POLYCARB_T],
            [x_hi, y_lo, roof_oz + POLYCARB_T],
            [x_hi, y_hi, roof_oz - drop_full + POLYCARB_T],
            [x_lo, y_hi, roof_oz - drop_full + POLYCARB_T]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

module render_roof_plates_polycarb_segment(x_lo, x_hi,
                                            eh_front = RH_EH_FRONT,
                                            eh_back  = RH_EH_BACK,
                                            depth    = RH_HOUSE_DEPTH,
                                            y_offset = 0,
                                            palette  = DEFAULT_PALETTE) {
    _polycarb_slab(x_lo, x_hi, eh_front, eh_back, depth, y_offset, palette);
}

