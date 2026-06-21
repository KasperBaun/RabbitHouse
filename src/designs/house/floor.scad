// HOUSE floor — split into two render modules so each layer can be inspected
// on its own:
//   RenderHouseFloorJoists() — bearing frame of 45×95 reglar laid hard against
//        the inside of the fundablok ring: ONE reglar all the way along V3 and
//        ONE along V5 (run in Y), ONE along V1 and ONE along V2 (run in X,
//        between the long ones), plus ONE transverse reglar across the middle
//        (V3→V5 at Y≈1500). Screwed directly into the ring — nothing stacked.
//   RenderHouseFloorDeck()   — ~25 mm sawn-board deck running the SHORT way (X)
//   RenderHouseFloor()       — convenience wrapper (both)
//
// Levels (z, mm above grade): deck TOP flush with the ring top (RH_BASE_H=120);
// reglar 0..95 against the ring inner faces, deck 95..120 on top.

include <../../lib/defaults.scad>
include <../config.scad>
include <../../lib/primitives/fundablok.scad>   // FUNDABLOK_W

FLOOR_PLANK_W   = 145;   // visible board width
FLOOR_PLANK_GAP = 4;     // expansion gap between boards

// ring inner opening — the floor sits inside it, flush with the ring top
function _flr_rx0() = FUNDABLOK_W;                    // 150
function _flr_rx1() = RH_HOUSE_LEN   - FUNDABLOK_W;   // 1850
function _flr_ry0() = FUNDABLOK_W;                    // 150
function _flr_ry1() = RH_HOUSE_DEPTH - FUNDABLOK_W;   // 2850

// Bearing frame (ONE layer of 45×95 reglar). The board deck runs in X, so the
// load-bearing reglar run in Y at c/c <=600: V3 + V5 at the ring inner faces +
// two intermediate bearers (≈724, 1276) → 4 bearers, c/c ~552. V1 + V2 close the
// front/back in X. Each floor hatch is boxed by a full reglar frame (two trimmer
// reglar in Y + two veksler in X) that carries the bearers cut at the opening.
module RenderHouseFloorJoists(palette = DEFAULT_PALETTE) {
    rx0 = _flr_rx0(); rx1 = _flr_rx1();
    ry0 = _flr_ry0(); ry1 = _flr_ry1();
    rw  = RH_FLOOR_REGLAR_W;         // 45
    rh  = RH_FLOOR_REGLAR_H;         // 95
    z0  = RH_FLOOR_REGLAR_Z;         // 0  (top at z0 + rh = 95)

    bxs     = [rx0 + rw/2, 724, 1276, rx1 - rw/2];   // bearer X centrelines (run Y)
    hatches = [RH_HATCH_FRONT, RH_HATCH_HUMAN];

    color(pal_post(palette)) {
        // Y-bearers, cut where they cross a hatch (the lem frame carries them).
        difference() {
            union()
                for (xc = bxs)
                    translate([xc - rw/2, ry0, z0]) cube([rw, ry1 - ry0, rh]);
            for (h = hatches)
                translate([h[0], h[1], z0 - 1]) cube([h[2]-h[0], h[3]-h[1], rh + 2]);
        }
        // Perimeter reglar along V1 (front) + V2 (back), run in X.
        translate([rx0 + rw, ry0,      z0]) cube([rx1 - rx0 - 2*rw, rw, rh]);
        translate([rx0 + rw, ry1 - rw, z0]) cube([rx1 - rx0 - 2*rw, rw, rh]);
        // Full reglar frame around each hatch — holds the lem.
        for (h = hatches) {
            translate([h[0] - rw, h[1] - rw, z0]) cube([rw, (h[3]-h[1]) + 2*rw, rh]); // trimmer L
            translate([h[2],      h[1] - rw, z0]) cube([rw, (h[3]-h[1]) + 2*rw, rh]); // trimmer R
            translate([h[0],      h[1] - rw, z0]) cube([h[2]-h[0], rw, rh]);          // veksel (Y0)
            translate([h[0],      h[3],      z0]) cube([h[2]-h[0], rw, rh]);          // veksel (Y1)
        }
    }
}

// Board deck: ~25 mm boards running the SHORT way (X), top flush with ring top.
// Two hatch openings ("lem") are cut for the basement staircases — both sit
// clear of the reglar frame, so no reglar is notched (see RH_HATCH_* in config).
module RenderHouseFloorDeck(palette = DEFAULT_PALETTE) {
    rx0 = _flr_rx0(); rx1 = _flr_rx1();
    ry0 = _flr_ry0(); ry1 = _flr_ry1();

    span = ry1 - ry0;
    n    = floor(span / FLOOR_PLANK_W);
    w    = span / n;                              // exact-fill plank pitch
    color(pal_floor(palette))
    difference() {
        for (i = [0 : n - 1])
            translate([rx0, ry0 + i * w, RH_FLOOR_DECK_Z])
                cube([rx1 - rx0, w - FLOOR_PLANK_GAP, RH_FLOOR_DECK_T]);
        for (h = [RH_HATCH_FRONT, RH_HATCH_HUMAN])
            translate([h[0], h[1], RH_FLOOR_DECK_Z - 5])
                cube([h[2] - h[0], h[3] - h[1], RH_FLOOR_DECK_T + 10]);
    }
}

module RenderHouseFloor(palette = DEFAULT_PALETTE) {
    RenderHouseFloorJoists(palette);
    RenderHouseFloorDeck(palette);
}
