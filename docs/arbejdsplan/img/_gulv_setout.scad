// Doc image — gulv-OPMÅLING: lem-åbningerne afsat i cm fra dækkets
// forreste venstre indvendige hjørne (0,0). Tegnet fladt (run=X, dybde=Y) i
// Z-stablede lag (dæk -> lemme -> mål/tekst) og renderet top-ned ortho, så de
// coplanære flader ikke kæmper. Tal kommer fra config (RH_HATCH_*). Render:
//   openscad -o gulv-opmaaling.png --projection=ortho \
//     --camera=0,0,0,0,0,0,2000 --viewall --autocenter \
//     --imgsize=1400,1700 --colorscheme=Tomorrow _gulv_setout.scad
include <../../../src/designs/config.scad>
include <../../../src/lib/primitives/fundablok.scad>   // FUNDABLOK_W
$fn = 24;

OX = FUNDABLOK_W; OY = FUNDABLOK_W;
DW = RH_HOUSE_LEN   - 2 * FUNDABLOK_W;   // 1700  (X, langs forkanten)
DD = RH_HOUSE_DEPTH - 2 * FUNDABLOK_W;   // 2700  (Y, ud i dybden)
L1 = RH_HATCH_FRONT;   // [650,195,1350,1095]  -> lokal [500,45,1200,945]
L2 = RH_HATCH_HUMAN;   // [905,1585,1805,2285] -> lokal [755,1435,1655,2135]
function lx(x) = x - OX;
function ly(y) = y - OY;

GREY   = [0.86, 0.86, 0.84];
ORANGE = [0.95, 0.78, 0.55];
INK    = [0.12, 0.12, 0.13];

// flat 2D child lifted to layer z (so coplanar shapes don't z-fight top-down)
module flat(z) translate([0, 0, z]) linear_extrude(1) children();

module lbl(x, y, s, sz = 64, rot = 0)
    color(INK) flat(5) translate([x, y]) rotate([0, 0, rot])
        text(s, size = sz, halign = "center", valign = "center");

module frame(x, y, w, h, t) translate([x, y])
    difference() { square([w, h]); translate([t, t]) square([w - 2*t, h - 2*t]); }

module dimh(x0, x1, yy, txt, sz = 60) {
    color(INK) flat(4) {
        translate([x0, yy - 4]) square([x1 - x0, 8]);
        translate([x0 - 3, yy - 35]) square([6, 70]);
        translate([x1 - 3, yy - 35]) square([6, 70]);
    }
    lbl((x0 + x1) / 2, yy + 70, txt, sz);
}
module dimv(y0, y1, xx, txt, sz = 60) {
    color(INK) flat(4) {
        translate([xx - 4, y0]) square([8, y1 - y0]);
        translate([xx - 35, y0 - 3]) square([70, 6]);
        translate([xx - 35, y1 - 3]) square([70, 6]);
    }
    lbl(xx - 85, (y0 + y1) / 2, txt, sz, 90);
}

// --- deck ---
color(GREY) flat(0) square([DW, DD]);
color(INK)  flat(1) frame(0, 0, DW, DD, 12);

// --- lemme ---
module lem(L, name, sizetxt) {
    x = lx(L[0]); y = ly(L[1]); w = L[2] - L[0]; h = L[3] - L[1];
    color(ORANGE) flat(2) translate([x, y]) square([w, h]);
    color(INK)    flat(3) frame(x, y, w, h, 10);
    lbl(x + w/2, y + h/2 + 55, name, 92);
    lbl(x + w/2, y + h/2 - 60, sizetxt, 64);
}
lem(L1, "LEM 1", "70 × 90 cm");
lem(L2, "LEM 2", "90 × 70 cm");

// --- mål langs forkant (X), nederst, to rækker ---
dimh(0,         lx(L1[0]), -180, "50,0");   // venstre -> LEM1
dimh(lx(L1[0]), lx(L1[2]), -180, "70,0");   // LEM1 bredde
dimh(0,         lx(L2[0]), -380, "75,5");   // venstre -> LEM2
dimh(lx(L2[0]), lx(L2[2]), -380, "90,0");   // LEM2 bredde

// --- mål ud i dybden (Y), venstre, to søjler ---
dimv(0,         ly(L1[1]), -180, "4,5");    // forkant -> LEM1
dimv(ly(L1[1]), ly(L1[3]), -180, "90,0");   // LEM1 dybde
dimv(0,         ly(L2[1]), -380, "143,5");  // forkant -> LEM2
dimv(ly(L2[1]), ly(L2[3]), -380, "70,0");   // LEM2 dybde

// --- datum-hjørne + akser ---
color(INK) flat(3) translate([-40, -40]) square([80, 80]);
lbl(330, -560, "0,0  — mål altid herfra", 70);
lbl(DW / 2, DD + 130, "X = langs forkanten  (170 cm)  →", 72);
lbl(-560, DD / 2, "Y = ud i dybden  (270 cm)  →", 72, 90);
