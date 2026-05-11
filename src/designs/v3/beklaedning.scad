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

// Sloped vindpapir til skrå vægge (V3, V5). Top z lapper toprem-bunden
// linært fra h_high (ved origin-enden) til h_low (ved den fjerne ende).
// Bottom er flad ved origin.z. Bruges hvor wall-toppen skråner med taget
// så vindpapiren ikke har et flat-top gap ved HØJ-enden.
module v3_wind_paper_sloped(origin, length, h_high, h_low, axis) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color(WIND_PAPER_COLOR)
    if (axis == "X") {
        hull() {
            translate([ox, oy, oz])
                cube([0.01, V3_VP_T, h_high]);
            translate([ox + length - 0.01, oy, oz])
                cube([0.01, V3_VP_T, h_low]);
        }
    } else {
        hull() {
            translate([ox, oy, oz])
                cube([V3_VP_T, 0.01, h_high]);
            translate([ox, oy + length - 0.01, oz])
                cube([V3_VP_T, 0.01, h_low]);
        }
    }
}

// Hjælpefunktion: wall-højde fra sokkel-top (bh=V3_BASE_H) til toprem-TOP
// ved enhver y. Linear mellem V3_EH_FRONT (y=0) og V3_EH_BACK (y=V3_WIDTH).
function v3_wall_h(y) =
    V3_EH_FRONT - (V3_EH_FRONT - V3_EH_BACK) * y / V3_WIDTH;

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
    // V5 BUTTER mellem V1+V2's inderfladser (Y = V3_POST_W..ww-V3_POST_W),
    // så klink må ikke stikke ud i V1/V2's footprint. Heights matcher
    // wall_top_z ved butted-positionerne (ehf - 7.6 / ehb + 7.6 for default
    // geometri) så klink-top præcist møder den skrå toprem-top.
    klink_in    = part_outer_x + s;     // klink inner face X
    butt_y0     = V3_POST_W;            // 95
    butt_len    = ww - 2 * V3_POST_W;   // 2310
    v5_h_high   = v3_wall_h(butt_y0);            // = 2392.4
    v5_h_low    = v3_wall_h(butt_y0 + butt_len); // = 2207.6
    difference() {
        clad_wall_mono_pitch([klink_in, butt_y0, bh], butt_len,
                             v5_h_high, v5_h_low, "Y", pal, clad);
        // Pet door cutout — z=V3_FLOOR_TOP+15 (= 180, 15 mm over gulv)
        translate([klink_in - 10, V3_PET_DOOR_Y, V3_FLOOR_TOP + 15])
            cube([ct + 20, V3_PET_DOOR_W, V3_PET_DOOR_H]);
        // Human door cutout — z=V3_FLOOR_TOP (167, gulv-niveau), IKKE bh (120, sokkel)
        translate([klink_in - 10, V3_HOUSE_DOOR_Y, V3_FLOOR_TOP])
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

// Skip-check helper — true hvis center-koordinaten c falder inden for
// nogen af de angivne [lo, hi] intervaller. Bruges af afstandsliste og
// kunne genbruges af andre dør/vindue-aware moduler.
function _in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// ---------------------------------------------------------------------------
// Afstandsliste — 22×45 vertical counter-battens. Sits BETWEEN vindpapir
// and klink: at outer offset V3_VP_T, extending outward by V3_AL_T.
// c2c = centre-to-centre spacing along the wall (default 600 mm).
// h_far = height af den sidste liste; alle mellemliggende interpoleres
//         lineært fra `height` (i=0) til `h_far` (i=n-1). Standard h_far
//         = height (= flad top på V1/V2). Skrå vægge V3/V5 sætter
//         h_far = ehb så listerne følger toprem'ens fald front→bag.
// skip_ranges = liste af [lo, hi] i ABSOLUTE wall-akse koordinater. Lister
//         hvis centerlinie falder inden for et range droppes (åbninger).
// ---------------------------------------------------------------------------
module v3_afstandsliste(origin, length, height, axis, c2c=600, h_far=undef,
                        skip_ranges=[]) {
    n = floor(length / c2c) + 1;
    h_end = is_undef(h_far) ? height : h_far;
    color([0.78, 0.65, 0.45])
    for (i = [0 : n-1]) {
        // Lister centerlinie i absolute wall-akse coords (45/2 = 22.5)
        center = (axis == "X" ? origin[0] : origin[1]) + i*c2c + 22.5;
        if (!_in_any_skip(center, skip_ranges)) {
            // Position-baseret interpolation ved lister-FAR-edge (i*c2c + 45)
            // så listen aldrig stikker UP over toprem på en skrå væg. Lokalt y
            // ved far-edge / wall-length giver præcis matching mod sloped toprem.
            far_edge = i * c2c + 45;
            h_i = (length > 0)
                ? height + (h_end - height) * far_edge / length
                : height;
            if (axis == "X")
                translate([origin[0] + i*c2c, origin[1], origin[2]])
                    cube([45, V3_AL_T, h_i]);
            else
                translate([origin[0], origin[1] + i*c2c, origin[2]])
                    cube([V3_AL_T, 45, h_i]);
        }
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

    // Vindpapir starter ved sokkel-top (V3_BASE_H = 120) hvor wood-strukturen
    // begynder. Stale legacy-værdi var 10 mm hvilket fik vindpapir til at
    // strække sig 110 mm ned over fundamentet. Bottom z=120 betyder vindpapir
    // dækker bundrem-yderfladen (122..167) og laps mod DPC ved sokkel-top.
    z_sill = V3_BASE_H;                     // = 120
    part_outer_x = hl + V3_POST_W/2;        // = hl + 47.5

    // V5 partition er INTERIOR og BUTTER mellem V1+V2's inderfladser.
    // Vindpapir, klink og afstandsliste skal alle holde sig inden for det
    // butted range så de ikke stikker ud i V1/V2's footprint.
    butt_y0  = V3_POST_W;                   // 95
    butt_len = V3_WIDTH - 2 * V3_POST_W;    // 2310

    // V5 wall-højder ved butted-positionerne (matcher præcist wall_top_z der).
    // Bruges af både klink, vindpapir og afstandsliste så de møder den skrå
    // toprem-top uden den tidligere 7.6 mm gap.
    v5_h_high_listere = v3_wall_h(butt_y0);             // = 2392.4 (toprem-TOP ved Y=95)
    v5_h_low_listere  = v3_wall_h(butt_y0 + butt_len);  // = 2207.6 (toprem-TOP ved Y=2405)

    // --- Vindpapir på OUTER stud-face af hver væg. Skrå vægge bruger
    //     cap_h_back (LOW) som flad højde så membranen aldrig stikker
    //     op over toprem ved den lave ende. Det øverste hjørne (det
    //     skrå triangel) dækkes alligevel af klink + roof-overhang. ---
    v3_wind_paper([0, -V3_VP_T,   z_sill],   hl, cap_h_front, "X");  // front (HIGH)
    v3_wind_paper([0, ww,         z_sill],   hl, cap_h_back,  "X");  // back  (LOW)

    // V3 left wall vindpapir: SLOPED top (matcher den skrå toprem) +
    // side-vindue cutout. V3 er EXTERIOR og spænder Y=0..ww (wraps om
    // hjørnet til V1/V2), så ingen Y-butting; kun cutout og slope.
    difference() {
        v3_wind_paper_sloped([-V3_VP_T, 0, z_sill], ww,
                             cap_h_front, cap_h_back, "Y");
        // Side-vindue cutout (700×600 ved Z=V3_FLOOR_TOP+V3_SIDE_WIN_Z=1267)
        translate([-V3_VP_T - 1, V3_SIDE_WIN_Y, V3_FLOOR_TOP + V3_SIDE_WIN_Z])
            cube([V3_VP_T + 2, V3_SIDE_WIN_W, V3_SIDE_WIN_H]);
    }

    // V5 partition vindpapir: butted Y-extent + SLOPED top + dør-cutouts.
    // h_high/h_low matcher wall_top ved butted-positionerne (præcis møde med
    // den skrå toprem; ingen flat-top gap ved HØJ-enden). Hus-dør på
    // gulv-niveau (V3_FLOOR_TOP=167); pet-dør 15 mm over gulv.
    v5_cap_h_high = v3_wall_h(butt_y0) - PLATE_H;            // = 2347.4
    v5_cap_h_low  = v3_wall_h(butt_y0 + butt_len) - PLATE_H; // = 2162.6
    difference() {
        v3_wind_paper_sloped([part_outer_x, butt_y0, z_sill], butt_len,
                             v5_cap_h_high, v5_cap_h_low, "Y");
        // Hus-dør cutout (870×2050 fra gulv-niveau)
        translate([part_outer_x - 1, V3_HOUSE_DOOR_Y, V3_FLOOR_TOP])
            cube([V3_VP_T + 2, V3_HOUSE_DOOR_W, V3_HOUSE_DOOR_H]);
        // Dyre-dør cutout (250×300, 15 mm over gulv)
        translate([part_outer_x - 1, V3_PET_DOOR_Y, V3_FLOOR_TOP + 15])
            cube([V3_VP_T + 2, V3_PET_DOOR_W, V3_PET_DOOR_H]);
    }

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
    // Skip lister hvis centerlinie falder i side-vinduet (Y=900..1600).
    v3_afstandsliste([-(V3_VP_T + V3_AL_T), 0, bh], ww, ehf, "Y", 600, ehb,
                     skip_ranges = [[V3_SIDE_WIN_Y, V3_SIDE_WIN_Y + V3_SIDE_WIN_W]]);
    // V5 partition yard-side: butted Y-extent + heights ved butted-positionerne
    // (i stedet for ehf/ehb der er for fuld Y=0..ww) + skip lister hvor dørene er.
    v3_afstandsliste([part_outer_x + V3_VP_T, butt_y0, bh], butt_len,
                     v5_h_high_listere, "Y", 600, v5_h_low_listere,
                     skip_ranges = [
                         [V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_Y + V3_HOUSE_DOOR_W],
                         [V3_PET_DOOR_Y,   V3_PET_DOOR_Y   + V3_PET_DOOR_W]
                     ]);

    // --- Voliernet — yard mesh perimeter (front, back, right) ---
    v3_voliere(palette);
}
