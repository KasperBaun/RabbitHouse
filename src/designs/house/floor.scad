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

// Bearing frame: one reglar along each ring inner face + a transverse mid reglar.
module RenderHouseFloorJoists(palette = DEFAULT_PALETTE) {
    rx0 = _flr_rx0(); rx1 = _flr_rx1();
    ry0 = _flr_ry0(); ry1 = _flr_ry1();
    rw  = RH_FLOOR_REGLAR_W;         // 45
    rh  = RH_FLOOR_REGLAR_H;         // 95
    z0  = RH_FLOOR_REGLAR_Z;         // 0  (top at z0 + rh = 95)
    mx0 = rx0 + rw;                  // 195  — X-run reglar sit between the long ones
    mx1 = rx1 - rw;                  // 1805
    ycross = RH_HOUSE_DEPTH / 2;     // 1500

    color(pal_post(palette)) {
        // long reglar — full length along V3 and V5 inner faces (run in Y, 2700)
        translate([rx0,      ry0, z0]) cube([rw, ry1 - ry0, rh]);   // V3
        translate([rx1 - rw, ry0, z0]) cube([rw, ry1 - ry0, rh]);   // V5
        // short reglar — along V1 and V2, between the long reglar (run in X, 1610)
        translate([mx0, ry0,      z0]) cube([mx1 - mx0, rw, rh]);   // V1
        translate([mx0, ry1 - rw, z0]) cube([mx1 - mx0, rw, rh]);   // V2
        // transverse mid reglar — V3→V5 at Y≈1500
        translate([mx0, ycross - rw/2, z0]) cube([mx1 - mx0, rw, rh]);
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
