// Foundation: fundablok ring + anchor screws.

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/fundablok.scad>
use <../lib/primitives/beslag.scad>

module RenderFoundation(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H;
    hl = RH_HOUSE_LEN;

    // Ring top at Z=bh (sokkel-top); ring extends 480 mm down into the
    // frost trench (600 mm total). Cross-wall under partition at X=hl
    // splits the ring into house and yard cells.
    fundablok_ring(ll, ww, 3, [hl], top_z = bh);

    // M10 anchor screws c/c 1000 mm in the ring centreline — driven into
    // the fundablok cores (not the concrete edge). Head at Z=bh; shaft
    // sinks 120 mm into the ring.
    ring_w = 150;
    cl = ring_w/2;
    for (x = [500 : 1000 : ll - 500]) {
        ankerskrue_m10([x, cl],      top_z=bh);  // front centreline
        ankerskrue_m10([x, ww - cl], top_z=bh);  // back centreline
    }
    for (y = [500 : 1000 : ww - 500]) {
        ankerskrue_m10([cl,      y], top_z=bh);  // left centreline
        ankerskrue_m10([ll - cl, y], top_z=bh);  // right centreline
        ankerskrue_m10([hl,      y], top_z=bh);  // partition cross-wall
    }
}
