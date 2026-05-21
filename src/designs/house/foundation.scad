// HOUSE foundation — fundablok perimeter ring under the 4 house walls.
// Outer dimensions 2000 × 3000 mm (X=0..hl, Y=0..ww).
//
// Halvstensforbandt with alternating corner ownership per course (the way a
// real bricklayer lays it):
//   even courses (0, 2): long walls V3, V5 own the corners — V3 strip runs
//                        full Y=0..ww, V5 strip runs full Y=0..ww, V1+V2
//                        strips sit between at X=bw..hl-bw.
//   odd courses (1, 3) : short walls V1, V2 own the corners — V1 strip runs
//                        full X=0..hl, V2 strip runs full X=0..hl, V3+V5
//                        strips sit between at Y=bw..ww-bw.
// This interlocks the corners and offsets every vertical joint by bw=150 mm
// between adjacent courses.
//
// V5 acts as the right exterior wall here (the partition becomes the right
// perimeter when the house is built standalone). In combined builds the
// yard foundation tiles up against V5 from the right without a duplicate.

include <../../lib/defaults.scad>
include <../config.scad>
include <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/beslag.scad>

COURSES = 4;

module RenderHouseFoundation(palette = DEFAULT_PALETTE) {
    ww = RH_WIDTH; bh = RH_BASE_H; hl = RH_HOUSE_LEN;
    bw = FUNDABLOK_W;       // 150
    h_per = FUNDABLOK_H;    // 200

    color(FUNDABLOK_COLOR)
    for (c = [0 : COURSES - 1]) {
        z = bh - (COURSES - c) * h_per;
        if (c % 2 == 0) {
            // Long walls own corners.
            _fb_strip_y([0,       0],       ww,        z, 0);   // V3 left, full
            _fb_strip_y([hl - bw, 0],       ww,        z, 0);   // V5 right, full
            _fb_strip_x([bw,      0],       hl - 2*bw, z, 0);   // V1 between
            _fb_strip_x([bw,      ww - bw], hl - 2*bw, z, 0);   // V2 between
        } else {
            // Short walls own corners.
            _fb_strip_x([0,       0],       hl,        z, 0);   // V1 front, full
            _fb_strip_x([0,       ww - bw], hl,        z, 0);   // V2 back, full
            _fb_strip_y([0,       bw],      ww - 2*bw, z, 0);   // V3 between
            _fb_strip_y([hl - bw, bw],      ww - 2*bw, z, 0);   // V5 between
        }
    }

    // M10 anchors c/c 1000 mm along all 4 wall centrelines.
    cl = bw / 2;
    for (x = [500 : 1000 : hl - 500])
        ankerskrue_m10([x, cl],       top_z = bh);
    for (x = [500 : 1000 : hl - 500])
        ankerskrue_m10([x, ww - cl],  top_z = bh);
    for (y = [500 : 1000 : ww - 500])
        ankerskrue_m10([cl, y],       top_z = bh);
    for (y = [500 : 1000 : ww - 500])
        ankerskrue_m10([hl - cl, y],  top_z = bh);
}
