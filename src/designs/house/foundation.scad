// HOUSE foundation — fundablok strip foundation under the 4 house walls
// (V1[0..hl] front, V2[0..hl] back, V3 left, V5 partition). When the house
// is built standalone, V5 acts as its right wall; when built together with
// yard, V5 is the partition and yard's foundation tiles up against it
// without a duplicate strip.
//
// Self-contained: anchors and fundablok primitives come from the shared lib.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/beslag.scad>

FUNDABLOK_W_LOCAL = 150;   // matches FUNDABLOK_W in lib/primitives/fundablok.scad

module RenderHouseFoundation(palette = DEFAULT_PALETTE) {
    ww = RH_WIDTH; bh = RH_BASE_H; hl = RH_HOUSE_LEN;
    bw = FUNDABLOK_W_LOCAL;

    // Perimeter strips for [0..hl] segment.
    fundablok_strip("X", [0, 0],         hl,           courses = 3, top_z = bh);
    fundablok_strip("X", [0, ww - bw],   hl,           courses = 3, top_z = bh);
    fundablok_strip("Y", [0, bw],        ww - 2*bw,    courses = 3, top_z = bh);
    // V5 partition cross-strip — centred at X=hl, runs between V1+V2.
    fundablok_strip("Y", [hl - bw/2, bw], ww - 2*bw,   courses = 3, top_z = bh);

    // M10 anchors along house centrelines (c/c 1000 mm).
    cl = bw / 2;
    // V1 front centreline (within X=0..hl).
    for (x = [500 : 1000 : hl])
        ankerskrue_m10([x, cl], top_z = bh);
    // V2 back centreline.
    for (x = [500 : 1000 : hl])
        ankerskrue_m10([x, ww - cl], top_z = bh);
    // V3 left side (X=cl).
    for (y = [500 : 1000 : ww - 500])
        ankerskrue_m10([cl, y], top_z = bh);
    // V5 partition (X=hl).
    for (y = [500 : 1000 : ww - 500])
        ankerskrue_m10([hl, y], top_z = bh);
}
