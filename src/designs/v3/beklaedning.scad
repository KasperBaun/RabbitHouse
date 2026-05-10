// beklaedning.scad — Klink + hjørnetrim + afstandsliste + vindpapir + voliernet
// Part of the v3 build pipeline; included from build.scad.
//
// Lag-stack udadgående fra stud-fladen:
//   1. vindpapir       (V3_VP_T = 1 mm)
//   2. afstandsliste   (V3_AL_T = 22 mm) — 22×45 lodret c/c 600
//   3. klink           (cs_thick(clad) — typisk 24 mm)
// Total = V3_VP_T + V3_AL_T + cs_thick(clad). Klink butter direkte mod
// dør-karm i åbninger (ingen separat arkitrav-liste).

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/cladding.scad>
use <../../lib/primitives/mesh.scad>

WIND_PAPER_COLOR = [0.50, 0.50, 0.52];

module v3_wind_paper(origin, length, height, axis) {
    color(WIND_PAPER_COLOR)
    if (axis == "X")
        translate(origin) cube([length, V3_VP_T, height]);
    else
        translate(origin) cube([V3_VP_T, length, height]);
}

// ---------------------------------------------------------------------------
// Klink-beklædning på de 4 hus-vægge.
// Klink-origin sidder s = V3_VP_T + V3_AL_T mm udad fra stud-fladen, så
// klink-laget kommer UDEN PÅ vindpapir + afstandsliste.
// Partition-væggen klædes på YARD-siden (X = hl + V3_POST_W/2 = hl+47.5).
// ---------------------------------------------------------------------------
module v3_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad) {
    s = V3_VP_T + V3_AL_T;                 // 23 — vindpapir + afstandsliste
    part_outer_x = hl + V3_POST_W/2;       // = hl + 47.5 — yard-side stud face

    // Front wall (Y=0). axis="X", thickness extends +Y. Origin Y is klink
    // INNER face = -(s+ct) so klink occupies Y = -(s+ct)..-s.
    clad_wall_rect([0, -(s + ct), bh], hl, ehf, "X", pal, clad);

    // Back wall (Y=ww). axis="X", thickness extends +Y. Klink occupies
    // Y = ww+s..ww+s+ct.
    clad_wall_rect([0, ww + s, bh], hl, ehb, "X", pal, clad);

    // Left exterior wall (X=0, side window cutout). axis="Y", thickness
    // extends +X. Klink occupies X = -(s+ct)..-s.
    clad_wall_mono_pitch_with_cutout([-(s + ct), 0, bh], ww, ehf, ehb, "Y",
        pal, clad,
        [V3_SIDE_WIN_Y, V3_SIDE_WIN_Y + V3_SIDE_WIN_W,
         V3_SIDE_WIN_Z, V3_SIDE_WIN_Z + V3_SIDE_WIN_H]);

    // Partition wall, yard side (X = part_outer_x). axis="Y", thickness
    // extends +X. Klink occupies X = part_outer_x+s..part_outer_x+s+ct.
    klink_in = part_outer_x + s;     // klink inner face X
    difference() {
        clad_wall_mono_pitch([klink_in, 0, bh], ww, ehf, ehb, "Y", pal, clad);
        // Pet door cutout (rabbit hatch).
        translate([klink_in - 10, V3_PET_DOOR_Y, bh + 60])
            cube([ct + 20, V3_PET_DOOR_W, V3_PET_DOOR_H]);
        // Human door cutout.
        translate([klink_in - 10, V3_HOUSE_DOOR_Y, bh])
            cube([ct + 20, V3_HOUSE_DOOR_W, V3_HOUSE_DOOR_H]);
    }
}

// External corner trim posts (45×45 vertical) at the four house cladding
// corners. Each post overlaps both cladding faces at the corner so the raw
// klink board end-grain is covered. Heights follow the wall: back corners
// use ehb, front corners use ehf.
module v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, pal) {
    tw = 45;
    s = V3_VP_T + V3_AL_T;
    o = s + ct;                     // klink outer-face offset from stud face
    color(pal_trim(pal)) {
        translate([-o,           -o,           bh]) cube([tw, tw, ehf]);
        translate([hl + o - tw,  -o,           bh]) cube([tw, tw, ehf]);
        translate([-o,           ww + o - tw,  bh]) cube([tw, tw, ehb]);
        translate([hl + o - tw,  ww + o - tw,  bh]) cube([tw, tw, ehb]);
    }
}

// ---------------------------------------------------------------------------
// Afstandsliste — 22×45 vertical counter-battens. Sits BETWEEN vindpapir
// and klink: at outer offset V3_VP_T, extending outward by V3_AL_T.
// c2c = centre-to-centre spacing along the wall (default 600 mm).
// h_far = height af den sidste liste; alle mellemliggende interpoleres
//         lineært fra `height` (i=0) til `h_far` (i=n-1). Standard h_far
//         = height (= flad top på V1/V2). Skrå vægge V3/V5 sætter
//         h_far = ehb så listerne følger toprem'ens fald front→bag.
// ---------------------------------------------------------------------------
module v3_afstandsliste(origin, length, height, axis, c2c=600, h_far=undef) {
    n = floor(length / c2c) + 1;
    h_end = is_undef(h_far) ? height : h_far;
    color([0.78, 0.65, 0.45])
    for (i = [0 : n-1]) {
        h_i = (n > 1) ? height + (h_end - height) * i / (n - 1) : height;
        if (axis == "X")
            translate([origin[0] + i*c2c, origin[1], origin[2]])
                cube([45, V3_AL_T, h_i]);
        else
            translate([origin[0], origin[1] + i*c2c, origin[2]])
                cube([V3_AL_T, 45, h_i]);
    }
}

// ---------------------------------------------------------------------------
// Voliernet — frameless welded-wire net stretched on OUTER face of yard
// 45×95 reglar. ½″×1″ ≈ 13 mm × 1 mm tråd (V3_MESH_*). Tre vægge:
//   • yard-front (Y=0)  — to bånd, ét på hver side af yard-døren
//   • yard-back  (Y=ww) — fladt LOW
//   • yard-right (X=ll) — skrå top, følger toprem fra HIGH (Y=0) til LOW (Y=ww)
// Net stopper ved underkanten af toprem; alt over (mellem spær) er
// tagkonstruktion's territorium.
// ---------------------------------------------------------------------------
module v3_voliere(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    bh = V3_BASE_H;

    // Yard mesh-spec (13 mm aperture × 1 mm wire — fineste rovdyrsikring).
    yard_mesh = mesh_spec(spacing = V3_MESH_SPACING,
                          bar     = V3_MESH_BAR,
                          frame   = V3_MESH_FRAME,
                          depth   = V3_MESH_DEPTH);

    // Net plane sits 1 mm uden for stud-fladen (på ydersiden af reglar).
    OUT = 1;

    // Sill top (= net z_base). Bundrem topflade ligger ved V3_YARD_SILL_TOP.
    z_base = V3_YARD_SILL_TOP;

    // Net topper — lige under toprem (toprem-bund = wall_top - PLATE_HEIGHT).
    // Front-væg er flad HIGH, bag-væg flad LOW, højre-væg skrå.
    PLATE_H = V3_SILL_H;                                  // = 45 (toprem-tykkelse)
    z_top_front = bh + V3_EH_FRONT - PLATE_H;             // = 2475
    z_top_back  = bh + V3_EH_BACK  - PLATE_H;             // = 2275
    h_front = z_top_front - z_base;
    h_back  = z_top_back  - z_base;

    // ---- 1. Yard-front (Y=0, faces -Y) — to bånd, om døren ----
    //   venstre bånd: X=hl..V3_YARD_DOOR_X
    //   højre bånd:   X=V3_YARD_DOOR_X+V3_YARD_DOOR_W..ll
    door_x0 = V3_YARD_DOOR_X;
    door_x1 = V3_YARD_DOOR_X + V3_YARD_DOOR_W;
    voliere_x(hl,      door_x0 - hl, z_base, h_front, -OUT,
              palette=palette, mesh=yard_mesh);
    voliere_x(door_x1, ll - door_x1, z_base, h_front, -OUT,
              palette=palette, mesh=yard_mesh);

    // ---- 2. Yard-back (Y=ww, faces +Y) — én bane, flad LOW ----
    voliere_x(hl, ll - hl, z_base, h_back, ww + OUT,
              palette=palette, mesh=yard_mesh);

    // ---- 3. Yard-right (X=ll, faces +X) — skrå top fra HIGH→LOW ----
    // Studs på højre væg butter mellem Y=95..ww-95, men net spændes på
    // ydersiden langs hele yard-bag-til-yard-front. Vi bruger net-koordinater
    // 0..ww langs Y for at dække fuldt mesh-areal.
    voliere_y_sloped(0, ww, z_base, z_top_front, z_top_back, ll + OUT,
                     palette=palette, mesh=yard_mesh);
}

// ---------------------------------------------------------------------------
// Wrapper — vindpapir + klink + hjørnetrim + afstandsliste + voliernet.
// ---------------------------------------------------------------------------
module v3_beklaedning(clad = DEFAULT_CLAD, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H;
    hl = V3_HOUSE_LEN;
    ehf = V3_EH_FRONT; ehb = V3_EH_BACK;
    ct = cs_thick(clad);
    s  = V3_VP_T + V3_AL_T;                 // 23 — outer-side stack offset

    // Wall-cap heights (klink toppes på toprem-bund — wall_top - PLATE_H).
    // Vindpapir og afstandsliste følger samme top-grænse.
    PLATE_H = V3_SILL_H;
    cap_h_front = ehf - PLATE_H;            // = 2355
    cap_h_back  = ehb - PLATE_H;            // = 2155

    z_sill = 10;  // wall sill air-gap (matches v3_house_framing z_sill)
    part_outer_x = hl + V3_POST_W/2;        // = hl + 47.5

    // --- Vindpapir på OUTER stud-face af hver væg. Skrå vægge bruger
    //     cap_h_back (LOW) som flad højde så membranen aldrig stikker
    //     op over toprem ved den lave ende. Det øverste hjørne (det
    //     skrå triangel) dækkes alligevel af klink + roof-overhang. ---
    v3_wind_paper([0, -V3_VP_T,   z_sill],   hl, cap_h_front, "X");  // front (HIGH)
    v3_wind_paper([0, ww,         z_sill],   hl, cap_h_back,  "X");  // back  (LOW)
    v3_wind_paper([-V3_VP_T,   0, z_sill],   ww, cap_h_back,  "Y");  // left  (skrå)
    v3_wind_paper([part_outer_x, 0, z_sill], ww, cap_h_back,  "Y");  // partition (skrå)

    // --- Klink + hjørnetrim ---
    v3_house_cladding(hl, ww, ehf, ehb, bh, ct, palette, clad);
    v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, palette);

    // --- Afstandsliste, mellem vindpapir og klink. Skrå vægge passer
    //     listerne lineært fra ehf (Y=0) til ehb (Y=ww) så de hver
    //     stopper præcis under toprem'en og ikke stikker op gennem taget. ---
    // Front (Y=0, flad HIGH): listerne har alle samme højde ehf.
    v3_afstandsliste([0, -(V3_VP_T + V3_AL_T), bh],  hl, ehf, "X");
    // Back (Y=ww, flad LOW): listerne har alle samme højde ehb.
    v3_afstandsliste([0, ww + V3_VP_T, bh],          hl, ehb, "X");
    // Left exterior wall (skrå): liste i=0 har ehf, liste i=n-1 har ehb.
    v3_afstandsliste([-(V3_VP_T + V3_AL_T), 0, bh],  ww, ehf, "Y", 600, ehb);
    // Partition wall yard-side (samme slope som left).
    v3_afstandsliste([part_outer_x + V3_VP_T, 0, bh], ww, ehf, "Y", 600, ehb);

    // --- Voliernet — yard mesh perimeter (front, back, right) ---
    v3_voliere(palette);
}
