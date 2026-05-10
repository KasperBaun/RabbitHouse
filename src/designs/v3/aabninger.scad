// aabninger.scad — Yard-udhusdør, indvendig dør og side-vindue:
// karm, leaf/plexi, beslag.
// Part of the v3 build pipeline; called from build.scad when show_cladding=true.
//
// Renderer KUN selve åbnings-enhederne: karm (3-4 stykker indeni rough opening),
// leaf eller plexi-rude, hardware (hængsler, lås, håndtag) samt bundkarm/
// dørtrin hvor relevant. Selve det strukturelle (jamb-reglar, header, cripples,
// rough sill) ligger i konstruktions-skelet.scad.
//
// Pet-åbningen i partition-væggen er BEVIDST tom her — det er bare en
// rough opening i skelettet, klar til at en standard kattelem (eller
// lignende kommercielt produkt) kan installeres direkte. Ingen geometri
// rendres for det.
//
// Z-base = V3_FLOOR_TOP (= 167, top af bundrem) som matches af skelettets
// STUD_BOTTOM_Z og alle dets framed_opening-positioner.

include <../../lib/defaults.scad>
include <config.scad>

// ============================================================================
// Materialeskonstanter
// ============================================================================
KARM_T          = 50;            // karm tømmer-tykkelse (yard-dør + indvendig dør)
LEAF_T          = 40;            // dørblad-tykkelse
THRESHOLD_H     = 30;            // bundkarm/dørtrin-højde (kun yard-dør)

WALL_DEPTH      = V3_POST_W;     // = 95, stud-dybde
FLOOR_Z         = V3_FLOOR_TOP;  // = 167, top af bundrem

PARTITION_X     = V3_HOUSE_LEN;  // partition-væg's midte (X = hl)
PART_OUTER_X    = PARTITION_X + WALL_DEPTH/2;   // yard-side outer face
PART_INNER_X    = PARTITION_X - WALL_DEPTH/2;   // hus-side outer face

// Side-vindue: bare et stykke plexi udenpå rough opening, der overlapper
// jamb-reglar + header + rough sill med PLEXI_OVERLAP hele vejen rundt så
// der er træværk at skrue igennem.
PLEXI_T         = 6;
PLEXI_OVERLAP   = 30;

PLEXI_C         = [0.88, 0.94, 0.96, 0.50];
HINGE_C         = [0.30, 0.30, 0.32];
HANDLE_C        = [0.85, 0.85, 0.88];

// ============================================================================
// 1. Yard-udhusdør — front-væg V1, vender -Y, åbner udad mod haven.
//    Mesh-i-træramme leaf med midt-rigel.
// ============================================================================
module v3_yard_door(mesh, palette) {
    x0 = V3_YARD_DOOR_X;
    x1 = x0 + V3_YARD_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + V3_YARD_DOOR_H;

    // --- Karm (4 stykker indeni rough opening) ---
    color(pal_post(palette)) {
        // Bundkarm/dørtrin
        translate([x0, 0, z0])
            cube([V3_YARD_DOOR_W, WALL_DEPTH, THRESHOLD_H]);
        // Topkarm
        translate([x0, 0, z1 - KARM_T])
            cube([V3_YARD_DOOR_W, WALL_DEPTH, KARM_T]);
        // Sidekarme
        karm_h = V3_YARD_DOOR_H - THRESHOLD_H - KARM_T;
        translate([x0, 0, z0 + THRESHOLD_H])
            cube([KARM_T, WALL_DEPTH, karm_h]);
        translate([x1 - KARM_T, 0, z0 + THRESHOLD_H])
            cube([KARM_T, WALL_DEPTH, karm_h]);
    }

    // --- Mesh-i-træramme leaf (åbner -Y; her vist lukket flush med ydre væg) ---
    leaf_x0 = x0 + KARM_T;
    leaf_x1 = x1 - KARM_T;
    leaf_w  = leaf_x1 - leaf_x0;
    leaf_z0 = z0 + THRESHOLD_H;
    leaf_z1 = z1 - KARM_T;
    leaf_h  = leaf_z1 - leaf_z0;
    leaf_y  = 5;                                 // 5 mm inset fra ydre væg
    fr      = 50;                                // ramme-bredde i leaf
    mid_z   = leaf_z0 + V3_MID_RAIL_Z_OFFSET;

    color(pal_post(palette)) {
        translate([leaf_x0, leaf_y, leaf_z0])         cube([leaf_w, LEAF_T, fr]);          // bund
        translate([leaf_x0, leaf_y, leaf_z1 - fr])    cube([leaf_w, LEAF_T, fr]);          // top
        translate([leaf_x0, leaf_y, leaf_z0])         cube([fr, LEAF_T, leaf_h]);          // venstre
        translate([leaf_x1 - fr, leaf_y, leaf_z0])    cube([fr, LEAF_T, leaf_h]);          // højre
        translate([leaf_x0, leaf_y, mid_z - fr/2])    cube([leaf_w, LEAF_T, fr]);          // midt-rigel
    }

    // Mesh i to bånd (over og under midt-rigel)
    mb = ms_bar(mesh); sp = ms_spacing(mesh);
    color(pal_mesh(palette))
    for (band = [[leaf_z0 + fr,  mid_z - fr/2],
                 [mid_z + fr/2,  leaf_z1 - fr]]) {
        zlo = band[0]; zhi = band[1];
        for (xx = [leaf_x0 + fr + sp/2 : sp : leaf_x1 - fr - sp/2])
            translate([xx - mb/2, leaf_y + LEAF_T/2 - mb/2, zlo])
                cube([mb, mb, zhi - zlo]);
        for (zz = [zlo + sp/2 : sp : zhi - sp/2])
            translate([leaf_x0 + fr, leaf_y + LEAF_T/2 - mb/2, zz - mb/2])
                cube([leaf_w - 2*fr, mb, mb]);
    }

    // --- Hardware (greb + hængsler på -Y-siden) ---
    color(HANDLE_C) {
        translate([leaf_x1 - 90, leaf_y - 25, z0 + 1050])    cube([60, 25, 25]);
        translate([leaf_x1 - 100, leaf_y - 6,  z0 + 1000])   cube([80,  8, 110]);
    }
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 350])
        translate([leaf_x0 - 8, leaf_y - 8, zh])
            cube([15, 8, 100]);
}

// ============================================================================
// 2. Indvendig dør i partition — V5, vender +X (mod yard), åbner ind i yard.
//    Massiv leaf med 4 panel-noter.
// ============================================================================
module v3_human_door(palette) {
    y0 = V3_HOUSE_DOOR_Y;
    y1 = y0 + V3_HOUSE_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + V3_HOUSE_DOOR_H;

    // --- Karm (3 stykker — top + 2 sider, ingen bundkarm i indvendig dør) ---
    color(pal_post(palette)) {
        // Topkarm (spænder over hele åbningen i Y, fyldt i X)
        translate([PART_INNER_X, y0, z1 - KARM_T])
            cube([WALL_DEPTH, V3_HOUSE_DOOR_W, KARM_T]);
        // Sidekarme (fra gulv til topkarm)
        karm_h = V3_HOUSE_DOOR_H - KARM_T;
        translate([PART_INNER_X, y0, z0])
            cube([WALL_DEPTH, KARM_T, karm_h]);
        translate([PART_INNER_X, y1 - KARM_T, z0])
            cube([WALL_DEPTH, KARM_T, karm_h]);
    }

    // --- Leaf (massivt dørblad i karmens midte, åbner +X) ---
    leaf_y0 = y0 + KARM_T;
    leaf_y1 = y1 - KARM_T;
    leaf_w  = leaf_y1 - leaf_y0;
    leaf_h  = V3_HOUSE_DOOR_H - KARM_T;
    leaf_x  = PARTITION_X - LEAF_T/2;            // centreret i væg

    color(pal_door(palette))
    translate([leaf_x, leaf_y0, z0])
        cube([LEAF_T, leaf_w, leaf_h]);

    // 4 vandrette panel-noter på +X-fladen af leafen
    color(pal_trim(palette))
    for (i = [0 : 3])
        translate([leaf_x + LEAF_T - 1, leaf_y0 + 50, z0 + 200 + i * 400])
            cube([2, leaf_w - 100, 30]);

    // --- Hardware (på +X-siden, greb højre side af døren) ---
    color(HANDLE_C) {
        translate([leaf_x + LEAF_T,     leaf_y1 - 100, z0 + 1050])  cube([25, 60, 25]);
        translate([leaf_x + LEAF_T + 3, leaf_y1 - 110, z0 + 1000])  cube([ 8, 80, 110]);
    }
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 350])
        translate([leaf_x - 5, leaf_y0 + 5, zh])
            cube([15, 8, 100]);
}

// ============================================================================
// 3. Side-vindue — V3 venstre væg, vender -X. Bare et stykke 6 mm plexi-
//    glas skruet udenpå rough opening; overlapper jamb-reglar + header +
//    rough sill med PLEXI_OVERLAP hele vejen rundt så der er træværk at
//    skrue igennem. Ingen karm, sprosser eller drypnæse — det er en
//    kanin-stald, ikke et danskvinduesnørden.
// ============================================================================
module v3_side_window() {
    y0 = V3_SIDE_WIN_Y - PLEXI_OVERLAP;
    y1 = V3_SIDE_WIN_Y + V3_SIDE_WIN_W + PLEXI_OVERLAP;
    z0 = FLOOR_Z + V3_SIDE_WIN_Z - PLEXI_OVERLAP;
    z1 = FLOOR_Z + V3_SIDE_WIN_Z + V3_SIDE_WIN_H + PLEXI_OVERLAP;

    color(PLEXI_C)
    translate([-PLEXI_T, y0, z0])
        cube([PLEXI_T, y1 - y0, z1 - z0]);
}

// ============================================================================
// Wrapper — komponerer de 3 åbnings-enheder.
// Pet-åbningen i partition-væggen står tom (rough opening i skelettet,
// kommerciel kattelem installeres direkte deri).
// ============================================================================
module v3_aabninger(mesh = DEFAULT_MESH, palette = DEFAULT_PALETTE) {
    v3_yard_door(mesh, palette);
    v3_human_door(palette);
    v3_side_window();
}
