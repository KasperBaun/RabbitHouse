// YARD foundation — fundablok strip foundation under the yard walls.
// In the COMBINED build (default): renders front[hl..ll], back[hl..ll], and
// V4 right. The left side is handled by house's V5 partition strip — no
// duplicate.
// In STANDALONE mode (standalone=true): also renders a left strip at X=hl
// so yard has a complete foundation ring without depending on house/V5.

include <../../lib/defaults.scad>
include <../config.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/beslag.scad>

FUNDABLOK_W_LOCAL = 150;

module RenderYardFoundation(standalone = false, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H; hl = RH_HOUSE_LEN;
    bw = FUNDABLOK_W_LOCAL;

    // Perimeter strips for [hl..ll] segment.
    fundablok_strip("X", [hl, 0],         ll - hl,    courses = 3, top_z = bh);
    fundablok_strip("X", [hl, ww - bw],   ll - hl,    courses = 3, top_z = bh);
    fundablok_strip("Y", [ll - bw, bw],   ww - 2*bw,  courses = 3, top_z = bh);

    // Standalone yard adds its own left wall foundation (replacing V5).
    if (standalone)
        fundablok_strip("Y", [hl - bw/2, bw], ww - 2*bw, courses = 3, top_z = bh);

    cl = bw / 2;
    // V1 front centreline (within X=hl..ll). First anchor at next 1000 step
    // past hl so we don't duplicate house's anchor at X=1500.
    for (x = [2500 : 1000 : ll - 500])
        ankerskrue_m10([x, cl], top_z = bh);
    // V2 back centreline.
    for (x = [2500 : 1000 : ll - 500])
        ankerskrue_m10([x, ww - cl], top_z = bh);
    // V4 right side (X=ll-cl).
    for (y = [500 : 1000 : ww - 500])
        ankerskrue_m10([ll - cl, y], top_z = bh);
    if (standalone)
        for (y = [500 : 1000 : ww - 500])
            ankerskrue_m10([hl, y], top_z = bh);
}
