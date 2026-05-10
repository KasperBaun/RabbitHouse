// beklaedning.scad — Klink + hjørnetrim + (later: afstandsliste/vindpapir)
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/cladding.scad>
use <../../lib/bom.scad>

// House cladding: front (no door), back, left (with side window cutout),
// partition (with house door + pet door cutouts via inline difference()).
module v3_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad) {
    clad_wall_rect([0, -ct, bh], hl, ehf, "X", pal, clad);
    clad_wall_rect([0, ww, bh], hl, ehb, "X", pal, clad);
    clad_wall_mono_pitch_with_cutout([-ct, 0, bh], ww, ehf, ehb, "Y",
        pal, clad,
        [V3_SIDE_WIN_Y, V3_SIDE_WIN_Y + V3_SIDE_WIN_W,
         V3_SIDE_WIN_Z, V3_SIDE_WIN_Z + V3_SIDE_WIN_H]);
    fpw = V3_POST_W;
    difference() {
        clad_wall_mono_pitch([hl, 0, bh], ww, ehf, ehb, "Y", pal, clad);
        translate([hl - 10, V3_PET_DOOR_Y, bh + 60])
            cube([ct + 20, V3_PET_DOOR_W, V3_PET_DOOR_H]);
        translate([hl - 10, V3_HOUSE_DOOR_Y, bh])
            cube([ct + 20, V3_HOUSE_DOOR_W, V3_HOUSE_DOOR_H]);
        // Yard front beam pass-through (sloped notch matching the beam).
        hull() {
            translate([hl - 10, 0, v3_roof_under(0) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
            translate([hl - 10, fpw - 0.01,
                       v3_roof_under(fpw) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
        }
        // Yard back beam pass-through.
        hull() {
            translate([hl - 10, ww - fpw,
                       v3_roof_under(ww - fpw) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
            translate([hl - 10, ww - 0.01,
                       v3_roof_under(ww) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
        }
    }
}

// External corner trim posts (45×45 vertical) at the four house cladding
// corners. Each post overlaps both cladding faces at the corner so the raw
// klink board end-grain is covered, matching standard Danish carpentry.
// Heights follow the wall: back corners use ehb, front corners use ehf.
module v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, pal) {
    tw = 45;
    color(pal_trim(pal)) {
        translate([-ct,           -ct,            bh]) cube([tw, tw, ehf]);
        translate([hl + ct - tw,  -ct,            bh]) cube([tw, tw, ehf]);
        translate([-ct,           ww + ct - tw,   bh]) cube([tw, tw, ehb]);
        translate([hl + ct - tw,  ww + ct - tw,   bh]) cube([tw, tw, ehb]);
    }
}

// ---------------------------------------------------------------------------
// Afstandsliste (E3) — 22×45 vertical counter-battens behind klink boards.
// Sits just outside the vindpapir so the klink boards nail to it.
// c2c = centre-to-centre spacing of battens along the wall (default 600 mm).
// ---------------------------------------------------------------------------
module v3_afstandsliste(origin, length, height, axis, c2c=600) {
    n = floor(length / c2c) + 1;
    bom_member("afstandsliste", "spruce", 22, 45, height,
               "vert_lagte", system="beklaedning", count=n);
    color([0.78, 0.65, 0.45])
    if (axis == "X") {
        for (i = [0 : n-1])
            translate([origin[0] + i*c2c, origin[1], origin[2]])
                cube([45, 22, height]);
    } else {
        for (i = [0 : n-1])
            translate([origin[0], origin[1] + i*c2c, origin[2]])
                cube([22, 45, height]);
    }
}

module v3_beklaedning(clad = DEFAULT_CLAD, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H;
    hl = V3_HOUSE_LEN;
    ehf = V3_EH_FRONT; ehb = V3_EH_BACK;
    ct = cs_thick(clad);
    // Afstandsliste thickness (22 mm) sits between vindpapir (1 mm) and klink.
    // vindpapir at outer stud face; afstandsliste just outside; klink nails to it.
    al_t = 22;   // afstandsliste thickness (depth into wall)
    vp_t = 1;    // vindpapir thickness

    v3_house_cladding(hl, ww, ehf, ehb, bh, ct, palette, clad);
    v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, palette);

    // Front wall (Y=0, klink faces -Y): stud outer face Y=0,
    //   vindpapir Y=-vp_t, afstandsliste just outside vindpapir.
    v3_afstandsliste([0, -(vp_t + al_t), bh], hl, ehf, "X");
    // Back wall (Y=ww, klink faces +Y): afstandsliste just outside vindpapir.
    v3_afstandsliste([0, ww + vp_t, bh], hl, ehb, "X");
    // Left exterior wall (X=0, klink faces -X).
    v3_afstandsliste([-(vp_t + al_t), 0, bh], ww, ehf, "Y");
    // Partition wall (X=hl, klink faces +X).
    v3_afstandsliste([hl + vp_t, 0, bh], ww, ehf, "Y");
}
