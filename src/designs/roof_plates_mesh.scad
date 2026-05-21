// Mesh "lid" cover — welded wire stapled straight onto the top plate as a
// predator-proof aviary top. No spær, sternbrædder, beslag or udhæng — the
// wall framing IS the support. Lid plane slopes from eh_front (front wall)
// to eh_back (back wall); X extent stops at the enclosed footprint so the
// roof reads as a clean cage from outside.

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
    // Lid sits on the top-plate top: z = base_h + eave_height at that Y.
    z_at_y0 = RH_BASE_H + eh_front;
    z_at_y1 = RH_BASE_H + eh_back;

    voliere_top_sloped(x_lo, x_hi - x_lo,
                        y_offset, depth,
                        z_at_y0, z_at_y1,
                        palette = palette, mesh = mesh);
}
