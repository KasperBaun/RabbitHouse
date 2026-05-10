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

module v3_beklaedning(clad = DEFAULT_CLAD, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H;
    hl = V3_HOUSE_LEN;
    ehf = V3_EH_FRONT; ehb = V3_EH_BACK;
    ct = cs_thick(clad);

    v3_house_cladding(hl, ww, ehf, ehb, bh, ct, palette, clad);
    v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, palette);
}
