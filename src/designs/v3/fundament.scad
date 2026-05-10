// fundament.scad — Foundation: kun beton-baseret underlag.
// Part of the v3 build pipeline; included from build.scad.
//
// Fundamentet er udelukkende fundablok-ringen + cross-wall + ankerskruer.
// Træ-skelet (bundrem, murpap, strøer-gulv) ligger i konstruktions-skelet.scad.
// Mesh apron, beklædning, etc. ligger i deres egne filer.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/beslag.scad>
use <../../lib/decor/landscape.scad>

// `show_ground=false` skjuler græs/grus så fundamentringen er synlig
// hele vejen rundt (12 cm sokkel over jord, 48 cm under jord).
module v3_fundament(show_ground = true, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H;
    hl = V3_HOUSE_LEN;

    if (show_ground) {
        ground_grass([ll/2, ww/2]);
    }

    // Top af ring ligger ved Z=bh (sokkel-niveau), ringen extends 480 mm
    // nedad i frostfri grøft (600 mm total). Cross-wall under partition
    // ved X=hl deler ringen i hus-rum og yard-rum.
    fundablok_ring(ll, ww, 3, [hl], top_z = bh);

    // Ankerskruer M10 c/c 1000 mm i RINGENS MIDTERLINJE — drives ned i
    // fundablokkernes hulrum (kerner) og sidder ikke i kanten af betonen.
    // Head sidder ved Z=bh (sokkel-top); skaft synker 120 mm ned i ringen.
    ring_w = 150;          // FUNDABLOK_W
    cl = ring_w/2;         // 75 — afstand fra ydre flade til ringens midterlinje
    for (x = [500 : 1000 : ll - 500]) {
        ankerskrue_m10([x, cl],        top_z=bh);  // front midterlinje (Y=75)
        ankerskrue_m10([x, ww - cl],   top_z=bh);  // back midterlinje (Y=ww-75)
    }
    for (y = [500 : 1000 : ww - 500]) {
        ankerskrue_m10([cl,      y],   top_z=bh);  // venstre midterlinje (X=75)
        ankerskrue_m10([ll - cl, y],   top_z=bh);  // højre midterlinje (X=ll-75)
        ankerskrue_m10([hl,      y],   top_z=bh);  // partition cross-wall (X=hl)
    }
}
