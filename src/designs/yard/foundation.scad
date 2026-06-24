// YARD foundation — fundablok perimeter under the yard walls.
//
// Combined mode (default): 3-sidet ring (V1 front, V2 back, V5 right). The
// left side is open — house's V4 partition foundation closes that line.
// Standalone (standalone=true): adds a V4 left strip at X=hl so yard has
// its own complete 4-side ring.
//
// Yard spans world Y=yo..yo+yd hvor yo=RH_YARD_Y_OFFSET, yd=RH_YARD_DEPTH.
//
// Halvstensforbandt med vekslende hjørne-ejerskab per skifte (samme mønster
// som hus-fundamentet):
//   lige skifter (0, 2): KORTE vægge (V5 + evt. V4) ejer hjørner — fulde
//                        Y=yo..yo+yd. De lange V1, V2 sidder mellem.
//   ulige skifter (1, 3): LANGE vægge (V1, V2) ejer hjørner — fulde
//                         X=hl..ll. V5 (og evt. V4) sidder mellem
//                         Y=yo+bw..yo+yd-bw.

include <../../lib/defaults.scad>
include <../config.scad>
include <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/beslag.scad>

COURSES = 4;

module RenderYardFoundation(standalone = false, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; yd = RH_YARD_DEPTH; bh = RH_BASE_H; hl = RH_HOUSE_LEN;
    yo = RH_YARD_Y_OFFSET;
    bw = FUNDABLOK_W;
    h_per = FUNDABLOK_H;

    yard_len = ll - hl;

    color(FUNDABLOK_COLOR)
    for (c = [0 : COURSES - 1]) {
        z = bh - (COURSES - c) * h_per;
        if (c % 2 == 0) {
            // Lige skifte — korte vægge ejer hjørner. V5 fuld Y=yo..yo+yd.
            // V1, V2 mellem V5 (på højre) og venstre væg/V4/åben kant.
            _fb_strip_y([ll - bw, yo],          yd, z, 0);
            v12_start = standalone ? hl + bw : hl;
            v12_end   = ll - bw;
            _fb_strip_x([v12_start, yo],            v12_end - v12_start, z, 0);
            _fb_strip_x([v12_start, yo + yd - bw],  v12_end - v12_start, z, 0);
            if (standalone)
                _fb_strip_y([hl, yo],           yd, z, 0);
        } else {
            // Ulige skifte — lange vægge ejer hjørner. V1, V2 fuld X=hl..ll.
            // V5 (og evt. V4) mellem Y=yo+bw..yo+yd-bw.
            _fb_strip_x([hl, yo],              yard_len, z, 0);
            _fb_strip_x([hl, yo + yd - bw],    yard_len, z, 0);
            _fb_strip_y([ll - bw, yo + bw],    yd - 2*bw, z, 0);
            if (standalone)
                _fb_strip_y([hl, yo + bw],     yd - 2*bw, z, 0);
        }
    }

    // M10 anchors c/c 1000 mm. Skip x=hl since house owns that anchor.
    cl = bw / 2;
    for (x = [2500 : 1000 : ll - 500])
        ankerskrue_m10([x, yo + cl],          top_z = bh);
    for (x = [2500 : 1000 : ll - 500])
        ankerskrue_m10([x, yo + yd - cl],     top_z = bh);
    for (y = [yo + 500 : 1000 : yo + yd - 500])
        ankerskrue_m10([ll - cl, y],          top_z = bh);
    if (standalone)
        for (y = [yo + 500 : 1000 : yo + yd - 500])
            ankerskrue_m10([hl, y],           top_z = bh);
}
