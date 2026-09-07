// HOUSE openings — front entry door on V1 (no flanking windows), side
// window on V3, human door + pet door in the partition (V4).
// Self-contained: zone-specific geometry only.

include <../../lib/defaults.scad>
include <../config.scad>

FRAME_T       = 50;
LEAF_T        = 40;
GLASS_T       = 4;

WALL_DEPTH    = RH_POST_W;
FLOOR_Z       = RH_FLOOR_TOP;

PARTITION_X   = RH_HOUSE_LEN;
// V4 wall sits inside the foundation (X=hl-WALL_DEPTH..hl), so the door
// frame's inner X face = wall inner face = hl - WALL_DEPTH.
PART_INNER_X  = PARTITION_X - WALL_DEPTH;

// Klink cladding outer-face offset past the stud face (housewrap 1 + batten
// 22 + klink 25). Door leaves sit flush with this plane so the casing
// (indfatning) doesn't leave a deep empty reveal.
CLAD_FACE     = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + 25;

// Beslag som monteret: lyse galvaniserede hængsler og et sølvfarvet
// greb med messing-cylinder over. (Aflæst på nærbillede af hoveddøren.)
HINGE_C       = [0.72, 0.73, 0.75];
HANDLE_C      = [0.76, 0.77, 0.78];
CYLINDER_C    = [0.72, 0.58, 0.24];
GLASS_C       = [0.55, 0.75, 0.85, 0.45];
WIN_FRAME_C   = [0.93, 0.93, 0.89];   // hvidmalet vindueskarm

// Internal human door in V4, faces +X (into yard), opens into yard.
module _render_human_door(palette) {
    y0 = RH_HOUSE_DOOR_Y;
    y1 = y0 + RH_HOUSE_DOOR_W;
    z0 = FLOOR_Z;
    z1 = z0 + RH_HOUSE_DOOR_H;

    color(pal_post(palette)) {
        translate([PART_INNER_X, y0, z1 - FRAME_T])
            cube([WALL_DEPTH, RH_HOUSE_DOOR_W, FRAME_T]);
        side_h = RH_HOUSE_DOOR_H - FRAME_T;
        translate([PART_INNER_X, y0, z0])
            cube([WALL_DEPTH, FRAME_T, side_h]);
        translate([PART_INNER_X, y1 - FRAME_T, z0])
            cube([WALL_DEPTH, FRAME_T, side_h]);
    }

    // Leaf fills the whole opening and sits just proud of the klink face
    // (like the V1 front door), so the casing laps straight onto it — no
    // recessed reveal. `w` = opening width. Faces +X, opens into the yard.
    w       = RH_HOUSE_DOOR_W;
    leaf_xf = PARTITION_X + CLAD_FACE + 2;   // outer (+X) face, just proud

    color(pal_door(palette))
    translate([leaf_xf - LEAF_T, y0, z0])
        cube([LEAF_T, w, RH_HOUSE_DOOR_H]);

    // Horizontal batten strips on the outer face — same look as V1 door.
    color(pal_trim(palette))
    for (i = [0 : 4])
        translate([leaf_xf - 1, y0 + 80, z0 + 200 + i * 400])
            cube([2, w - 160, 30]);

    // Handle — vertical bar near the latch (y1) edge, mid-height.
    color(HANDLE_C) {
        translate([leaf_xf - 5, y1 - 110, z0 + 950])  cube([30, 25, 150]);
        translate([leaf_xf,     y1 - 115, z0 + 990])  cube([12, 35, 70]);
    }
    // Hinges — 2 straps on the y0 (hinge) edge.
    color(HINGE_C)
    for (zh = [z0 + 200, z1 - 300])
        translate([leaf_xf - 3, y0 + 20, zh])
            cube([8, 110, 40]);
}

// Rombe-prisme ("harlekin") i XZ-planet, ekstruderet langs Y. Bruges både
// til udskæringen i dørbladet og til ruden der sidder i den.
//   cx, cz  : rombens centrum, w/h : diagonalernes længde
//   y0      : prismets bagkant, depth : tykkelse i +Y
module _diamond_prism(cx, cz, w, h, y0, depth) {
    translate([cx, y0 + depth, cz])
        rotate([90, 0, 0])
            linear_extrude(height = depth)
                polygon([[0, -h/2], [w/2, 0], [0, h/2], [-w/2, 0]]);
}

// Front entry door on V1, faces -Y (out into garden). Indkøbt dør med
// udvendige karmmål 948 × 2050; karmen står på sokkel-/gulvniveau
// (RH_FRONT_DOOR_Z) med RH_FRONT_DOOR_FUGE montagefuge i hver side.
// Bladet er en glat plade (krydsfiner) med en rombeformet rude i øverste
// tredjedel — ingen vandrette bræddelister. Åbner udad på 3 hængsler.
module _render_front_door(palette) {
    // Lysning (rough opening) — karmen sidder centreret i den.
    x0 = RH_FRONT_DOOR_X;
    z0 = RH_FRONT_DOOR_Z;

    // Karm — udvendige mål, midt i lysningen.
    kx0 = x0 + RH_FRONT_DOOR_FUGE;
    kw  = RH_FRONT_DOOR_KARM_W;
    // Tegnes i lysningens højde (2047). Den rigtige karm er 2050 — de 3 mm
    // høvles af topremmen ved montage, se config.scad.
    kh  = RH_FRONT_DOOR_H;
    kx1 = kx0 + kw;
    kz1 = z0 + kh;

    // Karm — overligger + to sidestykker i fuld vægdybde. Males sort som
    // resten af den udvendige snedkerdel (pal_trim), ikke bart konstruktionstræ.
    color(pal_trim(palette)) {
        translate([kx0, 0, kz1 - FRAME_T])
            cube([kw, WALL_DEPTH, FRAME_T]);
        side_h = kh - FRAME_T;
        translate([kx0, 0, z0])
            cube([FRAME_T, WALL_DEPTH, side_h]);
        translate([kx1 - FRAME_T, 0, z0])
            cube([FRAME_T, WALL_DEPTH, side_h]);
    }

    // Dørblad — udfylder karmlysningen og sidder lige uden for klinkens
    // yderside, så indfatningen lapper direkte på det.
    lx0     = kx0 + FRAME_T;
    lw      = kw - 2 * FRAME_T;
    lh      = kh - FRAME_T;
    // Bladets YDERSIDE. Udad er −Y, så bladet fylder Y = leaf_yf ..
    // leaf_yf + LEAF_T (indad). Klinkens yderside ligger i Y = −CLAD_FACE
    // (= −48), så bladet står 2 mm proud af klinken — indfatningen (25 mm,
    // ~12 mm proud) lapper på det udefra. Tegnes bladet i stedet fra
    // leaf_yf − LEAF_T stikker det 42 mm ud foran beklædningen.
    leaf_yf = -CLAD_FACE - 2;                 // = −50
    cx      = lx0 + lw / 2;                   // rudens center i X
    cz      = z0 + RH_FRONT_DOOR_LIGHT_Z;     // rudens center i Z

    color(pal_door(palette))
    difference() {
        translate([lx0, leaf_yf, z0])
            cube([lw, LEAF_T, lh]);
        _diamond_prism(cx, cz, RH_FRONT_DOOR_LIGHT_W, RH_FRONT_DOOR_LIGHT_H,
                       leaf_yf - 1, LEAF_T + 2);
    }

    // Foring — geringsskåret rombe-ramme af lyst træ uden om hullet, i
    // bladets fulde tykkelse.
    lin = RH_FRONT_DOOR_LIGHT_LINING;
    color(pal_floor(palette))
    difference() {
        _diamond_prism(cx, cz, RH_FRONT_DOOR_LIGHT_W + 2 * lin,
                       RH_FRONT_DOOR_LIGHT_H + 2 * lin, leaf_yf, LEAF_T);
        _diamond_prism(cx, cz, RH_FRONT_DOOR_LIGHT_W, RH_FRONT_DOOR_LIGHT_H,
                       leaf_yf - 1, LEAF_T + 2);
    }

    // Rude — kun hvis hullet er glaseret; som bygget står det åbent.
    if (RH_FRONT_DOOR_LIGHT_GLAZED)
        color(GLASS_C)
        _diamond_prism(cx, cz, RH_FRONT_DOOR_LIGHT_W, RH_FRONT_DOOR_LIGHT_H,
                       leaf_yf + LEAF_T/2 - GLASS_T/2, GLASS_T);

    // Beslag sidder UDEN PÅ bladet, dvs. på den negative side af bladets
    // yderside (leaf_yf).
    face = leaf_yf;

    // Greb — sølvfarvet vippegreb der peger ind mod hængselssiden, med
    // messing-låsecylinder ca. 75 mm over. Ingen stor bagplade.
    hz = z0 + 0.42 * lh;
    hx = lx0 + lw - 55;                       // grebets rosetcenter
    color(HANDLE_C) {
        translate([hx - 8, face - 20, hz - 8]) cube([16, 20, 16]);   // hals
        translate([hx - 165, face - 22, hz - 9]) cube([165, 14, 18]); // vippe
    }
    // rotate([90,0,0]) vender cylinderen fra +Z til −Y, så den vokser udad
    // fra bladets forside: y = face .. face − 18 (18 mm proud, ikke 28).
    color(CYLINDER_C)
        translate([hx, face, hz + 75])
            rotate([90, 0, 0]) cylinder(h = 18, d = 26);

    // Hængsler — 2 lyse galvaniserede hængsler på venstre kant. De sidder
    // hen over samlingen blad/karm, ca. 200 mm fra top og 250 mm fra bund.
    color(HINGE_C)
    for (zh = [z0 + lh - 260, z0 + 190])
        translate([lx0 - 18, face - 5, zh])
            cube([40, 5, 115]);
}

// Side window on V3 (left wall, X=0, faces -X). Frame fills the wall depth
// in +X; glass sits flush with the outer face at X=0.
module _render_side_window(palette) {
    y0 = RH_SIDE_WIN_Y;
    y1 = y0 + RH_SIDE_WIN_W;
    z0 = FLOOR_Z + RH_SIDE_WIN_Z;
    z1 = z0 + RH_SIDE_WIN_H;

    // Hvid karm — to lige høje rammer over hinanden, delt af en vandret
    // midterpost (samme dimension som karmen).
    z_mid = (z0 + z1) / 2;
    color(WIN_FRAME_C) {
        // Over- + underkarm
        translate([0, y0, z1 - FRAME_T])
            cube([WALL_DEPTH, RH_SIDE_WIN_W, FRAME_T]);
        translate([0, y0, z0])
            cube([WALL_DEPTH, RH_SIDE_WIN_W, FRAME_T]);
        // Sidekarme
        side_h = RH_SIDE_WIN_H - 2 * FRAME_T;
        translate([0, y0, z0 + FRAME_T])
            cube([WALL_DEPTH, FRAME_T, side_h]);
        translate([0, y1 - FRAME_T, z0 + FRAME_T])
            cube([WALL_DEPTH, FRAME_T, side_h]);
        // Vandret midterpost
        translate([0, y0 + FRAME_T, z_mid - FRAME_T/2])
            cube([WALL_DEPTH, RH_SIDE_WIN_W - 2 * FRAME_T, FRAME_T]);
    }

    // Glas — én rude i hver ramme, flugter med ydersiden (X=0).
    glass_w = RH_SIDE_WIN_W - 2 * FRAME_T;
    glass_h = (RH_SIDE_WIN_H - 3 * FRAME_T) / 2;
    color(GLASS_C)
    for (gz = [z0 + FRAME_T, z_mid + FRAME_T/2])
        translate([-GLASS_T, y0 + FRAME_T, gz])
            cube([GLASS_T, glass_w, glass_h]);
}

module RenderHouseOpenings(palette = DEFAULT_PALETTE) {
    _render_front_door(palette);
    _render_side_window(palette);
}

// V4's hus-dør — projekteret, men ikke bygget: åbningen er rejst, der sidder
// bare intet dørblad i endnu. Eget kald, så den kan kommenteres ind når den
// kommer op.
module RenderHouseV4Doors(palette = DEFAULT_PALETTE) {
    _render_human_door(palette);
}
