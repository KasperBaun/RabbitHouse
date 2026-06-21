// Render scene: house floor plan — strøer (one layer, run short way V3<->V5)
// + the two basement hatch openings (lem). Plan view for
// docs/arbejdsplan/gulv-stroer-lem.md. Self-contained (new z=167 floor system,
// not the legacy floor.scad geometry).
$fn = 24;

hl = 2000; ww = 3000; bw = 150;
ix0 = bw; ix1 = hl - bw;   // 150..1850
iy0 = bw; iy1 = ww - bw;   // 150..2850
stro_w = 45;

// Hatch rects [x0,y0,x1,y1] from config.scad
HF = [650, 195, 1350, 1095];     // LEM 1 — front door
HH = [1105, 1500, 1805, 2400];   // LEM 2 — human door (V5)

// --- foundation ring (grey band) ---
color([0.80, 0.78, 0.74])
difference() {
    translate([0, 0, 100]) cube([hl, ww, 20]);
    translate([ix0, iy0, 90]) cube([ix1 - ix0, iy1 - iy0, 40]);
}

// --- strøer 45x95, run X (short way), c/c <=600, cut at the hatches ---
ys = [200, 720, 1240, 1760, 2280, 2800];   // c/c 520 (<=600)
color([0.74, 0.55, 0.32])
difference() {
    for (y = ys) translate([ix0, y - stro_w/2, 130]) cube([ix1 - ix0, stro_w, 18]);
    for (h = [HF, HH]) translate([h[0], h[1], 120]) cube([h[2]-h[0], h[3]-h[1], 40]);
}

// --- hatch openings as bold red outlines ---
color([0.85, 0.12, 0.12])
for (h = [HF, HH])
    translate([h[0], h[1], 180]) difference() {
        cube([h[2]-h[0], h[3]-h[1], 14]);
        translate([22, 22, -1]) cube([h[2]-h[0]-44, h[3]-h[1]-44, 16]);
    }

// --- labels ---
module lbl(x, y, s, size = 130, a = "center")
    color([0.12, 0.12, 0.12])
    translate([x, y, 200]) linear_extrude(20)
        text(s, size = size, halign = a, valign = "center");

lbl(1000,  ww + 230, "V2 — BAG");
lbl(1000,  -300,     "V1 — FRONT  (frontdor)");
lbl(-340,  1500,     "V3");
lbl(hl+360, 1500,    "V5  (hus-dor)");

lbl((HF[0]+HF[2])/2, (HF[1]+HF[3])/2 + 80, "LEM 1",       115);
lbl((HF[0]+HF[2])/2, (HF[1]+HF[3])/2 - 80, "70 x 90 cm",  95);
lbl((HH[0]+HH[2])/2, (HH[1]+HH[3])/2 + 80, "LEM 2",       115);
lbl((HH[0]+HH[2])/2, (HH[1]+HH[3])/2 - 80, "70 x 90 cm",  95);

lbl(425, 1500, "stroer", 95);
