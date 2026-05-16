// Polycarbonate cover — single translucent slab mounted DIRECTLY on the
// rafters (no battens, no OSB deck). Plate sits at z = rafter top with
// 12 mm thickness; secured with self-drilling screws + neoprene washers
// through every other rafter crest.
//
// Pitch: works at the default 4,6° per Plastmo / Acryltec specs (min
// recommended 5°; we're close enough for a rabbit shed, and the corrugation
// profile would normally accept lower pitches than smooth polycarb).
//
// Two entry forms:
//   render_roof_plates_polycarb()                              — full footprint
//   render_roof_plates_polycarb_segment(x_lo, x_hi)            — zone segment

include <../lib/defaults.scad>
include <config.scad>

POLYCARB_T = 12;

module _polycarb_slab(x_lo, x_hi, eh_front, eh_back, palette) {
    ww        = RH_WIDTH;
    drop_full = _roof_drop(eh_front, eh_back);
    roof_oz   = _roof_oz(eh_front, eh_back);
    color(pal_polycarb(palette))
    polyhedron(
        points = [
            [x_lo, -RH_OH_FRONT,        roof_oz],
            [x_hi, -RH_OH_FRONT,        roof_oz],
            [x_hi, ww + RH_OH_BACK,     roof_oz - drop_full],
            [x_lo, ww + RH_OH_BACK,     roof_oz - drop_full],
            [x_lo, -RH_OH_FRONT,        roof_oz + POLYCARB_T],
            [x_hi, -RH_OH_FRONT,        roof_oz + POLYCARB_T],
            [x_hi, ww + RH_OH_BACK,     roof_oz - drop_full + POLYCARB_T],
            [x_lo, ww + RH_OH_BACK,     roof_oz - drop_full + POLYCARB_T]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

// Segment renderer — caller passes (eh_front, eh_back) so house and yard
// can render at different elevations.
module render_roof_plates_polycarb_segment(x_lo, x_hi,
                                            eh_front = RH_EH_FRONT,
                                            eh_back  = RH_EH_BACK,
                                            palette  = DEFAULT_PALETTE) {
    _polycarb_slab(x_lo, x_hi, eh_front, eh_back, palette);
}

module render_roof_plates_polycarb(palette = DEFAULT_PALETTE) {
    render_roof_plates_polycarb_segment(-RH_OH_SIDE,
                                         RH_LENGTH + RH_OH_SIDE,
                                         palette = palette);
}
