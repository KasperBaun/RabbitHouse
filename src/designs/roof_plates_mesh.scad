// Mesh "lid" cover — welded wire stretched directly across the rafter
// tops as a predator-proof aviary top, no weather barrier. Yard-only use.
// Mesh follows the rafter top plane (sloped along Y); no batten, deck or
// overhang fascia under it.
//
// Entry: render_roof_plates_mesh_segment(x_lo, x_hi, ...). Accepts
// (eh_front, eh_back, depth, y_offset, mesh). x_lo/x_hi describe the
// enclosed-area X extent the lid must cover (the wire stops where the
// fascia begins — overhangs stay open).

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/mesh.scad>

module render_roof_plates_mesh_segment(x_lo, x_hi,
                                        eh_front = RH_YARD_EH_FRONT,
                                        eh_back  = RH_YARD_EH_BACK,
                                        depth    = RH_YARD_DEPTH,
                                        y_offset = RH_YARD_Y_OFFSET,
                                        mesh     = RH_MESH,
                                        palette  = DEFAULT_PALETTE) {
    roof_oz   = _roof_oz(eh_front, eh_back, depth);
    drop_full = _roof_drop(eh_front, eh_back, depth);
    span_tot  = RH_OH_FRONT + depth + RH_OH_BACK;

    y0 = y_offset;
    y1 = y_offset + depth;
    z_at_y0 = roof_oz - (RH_OH_FRONT + (y0 - y_offset)) * drop_full / span_tot;
    z_at_y1 = roof_oz - (RH_OH_FRONT + (y1 - y_offset)) * drop_full / span_tot;

    voliere_top_sloped(x_lo, x_hi - x_lo, y0, y1 - y0,
                        z_at_y0, z_at_y1,
                        palette = palette, mesh = mesh);
}
