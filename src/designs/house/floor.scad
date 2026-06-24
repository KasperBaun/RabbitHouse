// HOUSE floor — split into two render modules so each layer can be inspected
// on its own:
//   RenderHouseFloorJoists() — bearing frame of 45×95 reglar laid hard against
//        the inside of the fundablok ring: ONE reglar along V3 and ONE along V4
//        (run in Y) + THREE intermediate bearers (also run in Y), with V1/V2
//        closing the front/back in X. The intermediate bearers are snapped to
//        the lem trimmer lines so each one DOUBLES as a hatch trimmer — no
//        parallel sliver beside the lem frame. Screwed to the ring / hung in
//        strøsko; nothing stacked.
//   RenderHouseFloorHangers()— strøsko at every hung junction (bearers/veksler)
//   RenderHouseFloorDeck()   — ~25 mm sawn-board deck running the SHORT way (X)
//   RenderHouseFloor()       — convenience wrapper (all three)
//
// Levels (z, mm above grade): deck TOP flush with the ring top (RH_BASE_H=120);
// reglar 0..95 against the ring inner faces, deck 95..120 on top.

include <../../lib/defaults.scad>
include <../config.scad>
include <../../lib/primitives/fundablok.scad>   // FUNDABLOK_W
use <../../lib/primitives/beslag.scad>          // stroesko

FLOOR_PLANK_W   = 145;   // visible board width
FLOOR_PLANK_GAP = 4;     // expansion gap between boards

// ring inner opening — the floor sits inside it, flush with the ring top
function _flr_rx0() = FUNDABLOK_W;                    // 150
function _flr_rx1() = RH_HOUSE_LEN   - FUNDABLOK_W;   // 1850
function _flr_ry0() = FUNDABLOK_W;                    // 150
function _flr_ry1() = RH_HOUSE_DEPTH - FUNDABLOK_W;   // 2850

// Bearing frame (ONE layer of 45×95 reglar). The board deck runs in X, so the
// load-bearing reglar run in Y at c/c <=600. The intermediate bearers are
// SNAPPED to the lem trimmer lines so each bearer also forms a hatch side —
// no near-parallel sliver beside the lem frame:
//   172.5  V3 edge          |  627.5  LEM1 left  (= hf[0]-rw/2)
//   882.5  LEM2 left        | 1372.5  LEM1 right (= hf[2]+rw/2)
//   1827.5 V4 edge          (= LEM2 right trimmer)
// → 5 bearers, deck spans 455/255/490/455 mm (all <=600 for the current hatch
// coords). Bearers run full Y and are cut where they cross a hatch opening; the
// veksler (X end pieces) box the remaining two sides. V1 + V2 close front/back.
module RenderHouseFloorJoists(palette = DEFAULT_PALETTE) {
    rx0 = _flr_rx0(); rx1 = _flr_rx1();
    ry0 = _flr_ry0(); ry1 = _flr_ry1();
    rw  = RH_FLOOR_REGLAR_W;         // 45
    rh  = RH_FLOOR_REGLAR_H;         // 95
    z0  = RH_FLOOR_REGLAR_Z;         // 0  (top at z0 + rh = 95)

    hf = RH_HATCH_FRONT; hh = RH_HATCH_HUMAN;
    // bearer X centrelines (run Y) — intermediate ones aligned to lem trimmers
    bxs     = [rx0 + rw/2, hf[0] - rw/2, hh[0] - rw/2, hf[2] + rw/2, rx1 - rw/2];
    hatches = [hf, hh];

    color(pal_post(palette)) {
        // Y-bearers, cut where they cross a hatch (the trimmer bearers run past
        // the opening and form its left/right sides).
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
        // Each hatch end gets a veksel (X header) that carries the cut bearers —
        // unless that end is already a perimeter reglar (V1/V2 serves as the
        // header there, e.g. LEM1's front edge). The two long sides are the
        // trimmer bearers above. This is the SOLE hatch frame; basement.scad
        // keys off RH_HATCH_* only for the fals, stairs and lid.
        for (h = hatches) {
            if (h[1] - rw > ry0)                                          // front end
                translate([h[0], h[1] - rw, z0]) cube([h[2]-h[0], rw, rh]);
            if (h[3] + rw < ry1)                                          // back end
                translate([h[0], h[3], z0]) cube([h[2]-h[0], rw, rh]);
        }
    }
}

// Board deck: ~25 mm boards running the SHORT way (X), top flush with ring top.
// Two hatch openings ("lem") are cut for the basement staircases; their edges
// land on the trimmer bearers below (see RH_HATCH_* in config).
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

// Joist hanger (strøsko) at a junction where a bearer/veksel frames INTO a
// transverse member. Canonical stroesko: joist runs +Y from the support face
// at Y=0. Here `dir` along `axis` sets the run direction, `run_at` is the
// support face on the run axis, `cross_c` the joist centre on the cross axis.
module _strosko(axis, dir, run_at, cross_c) {
    rot = (axis == "Y") ? (dir > 0 ? 0 : 180) : (dir > 0 ? -90 : 90);
    pos = (axis == "Y") ? [cross_c, run_at, RH_FLOOR_REGLAR_Z]
                        : [run_at, cross_c, RH_FLOOR_REGLAR_Z];
    translate(pos) rotate([0, 0, rot]) stroesko(RH_FLOOR_REGLAR_W, RH_FLOOR_REGLAR_H);
}

// Strøsko at every junction where a member is HUNG off a transverse one. The
// kant-bearers (V3/V4) and V1/V2 rest on the ring, so they need none. All
// coords derive from the hatch rectangles so they track RenderHouseFloorJoists.
module RenderHouseFloorHangers() {
    hf = RH_HATCH_FRONT; hh = RH_HATCH_HUMAN;
    rw = RH_FLOOR_REGLAR_W;
    ry0 = _flr_ry0(); ry1 = _flr_ry1();
    b_l1 = hf[0] - rw/2; b_r1 = hf[2] + rw/2;   // LEM1 side bearers (627.5, 1372.5)
    b_l2 = hh[0] - rw/2;                         // LEM2 left bearer (882.5)
    v1f  = ry0 + rw;     v2f  = ry1 - rw;        // V1/V2 solid faces (195, 2805)

    // 3 intermediate bearers → perimeter, or the veksel catching a cut end
    _strosko("Y", +1, v1f,        b_l1);   // 627.5  → V1
    _strosko("Y", -1, v2f,        b_l1);   // 627.5  → V2
    _strosko("Y", +1, hf[3] + rw, b_l2);   // 882.5  → LEM1 back veksel
    _strosko("Y", -1, v2f,        b_l2);   // 882.5  → V2
    _strosko("Y", +1, v1f,        b_r1);   // 1372.5 seg1 → V1
    _strosko("Y", -1, hh[1] - rw, b_r1);   // 1372.5 seg1 → LEM2 front veksel
    _strosko("Y", +1, hh[3] + rw, b_r1);   // 1372.5 seg2 → LEM2 back veksel
    _strosko("Y", -1, v2f,        b_r1);   // 1372.5 seg2 → V2
    // 3 veksler → their two side bearers
    _strosko("X", +1, hf[0], hf[3] + rw/2);   // LEM1 back veksel → 627.5
    _strosko("X", -1, hf[2], hf[3] + rw/2);   // LEM1 back veksel → 1372.5
    _strosko("X", +1, hh[0], hh[1] - rw/2);   // LEM2 front veksel → 882.5
    _strosko("X", -1, hh[2], hh[1] - rw/2);   // LEM2 front veksel → V4
    _strosko("X", +1, hh[0], hh[3] + rw/2);   // LEM2 back veksel → 882.5
    _strosko("X", -1, hh[2], hh[3] + rw/2);   // LEM2 back veksel → V4
}

module RenderHouseFloor(palette = DEFAULT_PALETTE) {
    RenderHouseFloorJoists(palette);
    RenderHouseFloorHangers();
    RenderHouseFloorDeck(palette);
}
