// Render scene: house foundation top course + M10 anchor markers.
// Used to generate the plan-view image in fundament-m10-ankerskruer.md.
use <../../../src/designs/house/foundation.scad>
$fn = 48;

RenderHouseFoundation();

// Bright red markers on each of the 10 anchor positions (top of ring z=120).
hl = 2000; ww = 3000; cl = 75;
module mark(x, y) color([0.85, 0.10, 0.10])
    translate([x, y, 120]) cylinder(h = 60, r = 16);

for (x = [500 : 1000 : hl - 500]) { mark(x, cl); mark(x, ww - cl); }
for (y = [500 : 1000 : ww - 500]) { mark(cl, y); mark(hl - cl, y); }

// --- Labels (drawn flat in XY, readable from top) ---
module lbl(x, y, s, size = 150, a = "center")
    color([0.12, 0.12, 0.12])
    translate([x, y, 120]) linear_extrude(height = 30)
        text(s, size = size, halign = a, valign = "center");

// Wall identifiers
lbl(1000,  -360, "V1 — FRONT");
lbl(1000,  3360, "V2 — BAG");
lbl(-520,  1500, "V3");
lbl(2520,  1500, "V5");

// Running scale along front (V1), cm from left corner, every 50 cm
lbl(500,  -140, "50",  100);
lbl(1000, -140, "100", 100);
lbl(1500, -140, "150", 100);

// Running scale along left (V3), cm from front corner, every 50 cm
lbl(-200, 500,  "50",  100);
lbl(-200, 1000, "100", 100);
lbl(-200, 1500, "150", 100);
lbl(-200, 2000, "200", 100);
lbl(-200, 2500, "250", 100);

// Edge inset note
lbl(1000, 800, "10 × M10  ·  bor midt i bundremmen", 90);
