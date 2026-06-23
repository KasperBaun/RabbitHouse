// Doc image — TRAPPE-SNIT (side-elevation). Tegnet fladt med run vandret (X) og
// højde lodret (Y), Z-stablet, renderet top-ned ortho. Trin-mål kommer fra
// config (RH_STAIR_*, RH_BASEMENT_FLOOR_Z). Begge trapper er ens. Render:
//   openscad -o trappe-snit.png --projection=ortho \
//     --camera=0,0,0,0,0,0,2000 --viewall --autocenter \
//     --imgsize=1500,1500 --colorscheme=Tomorrow _trappe_snit.scad
include <../../../src/designs/config.scad>
$fn = 24;

DECK   = RH_FLOOR_DECK_TOP;                     // 120   dæk-overkant
SLAB   = RH_BASEMENT_FLOOR_Z;                   // -680  kælderdæk-overkant
DROP   = DECK - SLAB;                           // 800   fald
RISERS = RH_STAIR_RISERS;                       // 6
RISE   = DROP / RISERS;                         // 133.3 stødhøjde
GO     = RH_STAIR_GOING;                        // 100   grund
TT     = 40;                                    // trintykkelse
RUN    = RISERS * GO;                           // 600   vandret udløb

WOOD   = [0.78, 0.60, 0.36];
GREY   = [0.62, 0.63, 0.64];
DECKC  = [0.86, 0.86, 0.84];
INK    = [0.12, 0.12, 0.13];

module flat(z) translate([0, 0, z]) linear_extrude(1) children();
module lbl(x, y, s, sz = 46, rot = 0)
    color(INK) flat(6) translate([x, y]) rotate([0, 0, rot])
        text(s, size = sz, halign = "center", valign = "center");
module dimh(x0, x1, yy, txt, sz = 46) {
    color(INK) flat(5) {
        translate([x0, yy - 3]) square([x1 - x0, 6]);
        translate([x0 - 2, yy - 22]) square([4, 44]);
        translate([x1 - 2, yy - 22]) square([4, 44]);
    }
    lbl((x0 + x1) / 2, yy + 45, txt, sz);
}
module dimv(y0, y1, xx, txt, sz = 46) {
    color(INK) flat(5) {
        translate([xx - 3, y0]) square([6, y1 - y0]);
        translate([xx - 22, y0 - 2]) square([44, 4]);
        translate([xx - 22, y1 - 2]) square([44, 4]);
    }
    lbl(xx - 60, (y0 + y1) / 2, txt, sz, 90);
}

// --- gulvdæk-kant ved lemmen (run < 0) ---
color(DECKC) flat(1) translate([-360, DECK - TT]) square([360, TT]);
lbl(-180, DECK + 70, "gulv / lem-kant", 44);

// --- kælderdæk (beton) ---
color(GREY) flat(1) translate([-100, SLAB - 100]) square([RUN + 360, 100]);
lbl(RUN / 2, SLAB - 55, "kælderdæk (beton)", 44);

// --- 5 trin + pitch-linje (6. trin = kælderdækket) ---
for (i = [1 : RISERS - 1]) {
    ztop = DECK - i * RISE;
    color(WOOD) flat(2) translate([(i - 1) * GO, ztop - TT]) square([GO, TT]);
}
// stejlhedslinje (forkant af trinnene) — top-nosing til bund
color(INK) flat(3)
    hull() { translate([-4, DECK]) square([8, 8]); translate([RUN - 4, SLAB]) square([8, 8]); }

// --- mål ---
dimv(DECK - 2 * RISE, DECK - 1 * RISE, -200, "13,3");   // stødhøjde
dimh(2 * GO, 3 * GO, DECK - 2.4 * RISE, "10");          // grund
dimv(SLAB, DECK, RUN + 270, "80 = fald");               // samlet fald
dimh(0, RUN, SLAB - 230, "60 = udløb");                 // samlet run
lbl(150, DECK - 4.4 * RISE, "~53°", 50);

// --- tekstboks ---
lbl(RUN / 2, DECK + 240, "TRAPPE-SNIT  ·  6 stødtrin à 13,3 cm  ·  grund 10 cm  ·  bredde 55 cm", 44);
lbl(RUN / 2, DECK + 160, "5 trin (40 mm) + kælderdæk som 6. trin  ·  2 vanger 45 mm", 42);
