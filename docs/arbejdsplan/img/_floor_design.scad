// Doc plan image — rendered FROM the model code (floor.scad), so it always
// matches the build. Grey ring drawn locally; reglar come from RenderHouseFloorJoists.
include <../../../src/designs/config.scad>
use <../../../src/designs/house/floor.scad>
$fn = 24;

hl = RH_HOUSE_LEN; ww = RH_HOUSE_DEPTH; bw = 150;
ix0 = bw; ix1 = hl - bw; iy0 = bw; iy1 = ww - bw;

// --- ring ---
color([0.80, 0.78, 0.74])
difference() {
    translate([0, 0, 100]) cube([hl, ww, 20]);
    translate([ix0, iy0, 90]) cube([ix1 - ix0, iy1 - iy0, 40]);
}

// --- REAL reglar from the code ---
RenderHouseFloorJoists();

// --- red opening outlines (hatch rects from config) ---
color([0.85, 0.12, 0.12])
for (h = [RH_HATCH_FRONT, RH_HATCH_HUMAN])
    translate([h[0], h[1], 180]) difference() {
        cube([h[2]-h[0], h[3]-h[1], 14]);
        translate([20, 20, -1]) cube([h[2]-h[0]-40, h[3]-h[1]-40, 16]);
    }

// --- labels ---
module lbl(x, y, s, size = 130, a = "center")
    color([0.12, 0.12, 0.12])
    translate([x, y, 220]) linear_extrude(20)
        text(s, size = size, halign = a, valign = "center");

lbl(hl/2,  ww + 360, "V2 - BAG");
lbl(hl/2,  -380,     "V1 - FRONT  (frontdor)");
lbl(-470,  ww/2,     "V3");
lbl(hl+490, ww/2,    "V5  (hus-dor)");

// LEM labels + størrelse
lbl((RH_HATCH_FRONT[0]+RH_HATCH_FRONT[2])/2, (RH_HATCH_FRONT[1]+RH_HATCH_FRONT[3])/2 + 60, "LEM 1", 95);
lbl((RH_HATCH_FRONT[0]+RH_HATCH_FRONT[2])/2, (RH_HATCH_FRONT[1]+RH_HATCH_FRONT[3])/2 - 60, "70x90", 76);
lbl((RH_HATCH_HUMAN[0]+RH_HATCH_HUMAN[2])/2, (RH_HATCH_HUMAN[1]+RH_HATCH_HUMAN[3])/2 + 60, "LEM 2", 95);
lbl((RH_HATCH_HUMAN[0]+RH_HATCH_HUMAN[2])/2, (RH_HATCH_HUMAN[1]+RH_HATCH_HUMAN[3])/2 - 60, "90x70", 76);

// --- cm-målestok fra hjørne (0,0) ---
lbl(500, -160, "50", 74); lbl(1000, -160, "100", 74); lbl(1500, -160, "150", 74);
lbl(-200, 500, "50", 74); lbl(-200, 1000, "100", 74); lbl(-200, 1500, "150", 74);
lbl(-200, 2000, "200", 74); lbl(-200, 2500, "250", 74);

// --- bærereglar c/c (cm) ---
lbl(448, 2560, "55", 68); lbl(1000, 2560, "55", 68); lbl(1552, 2560, "55", 68);

lbl(hl/2, -560, "maal i cm fra hjorne (0,0)  ·  baerereglar c/c 55", 64);
