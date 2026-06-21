// HOUSE basement ("kælder") — the hollow fundablok ring is a usable pit.
//   RenderHouseBasementFloor() — concrete slab at the ring bottom (z=-680)
//   RenderHouseStairs()        — two steep staircases (front + human door) down
//        to the slab; each hatch is trimmed ("vekslet") into the floor frame and
//        carries a hinged lid.
//
// The hatch openings are cut in the deck in floor.scad using RH_HATCH_*. Per
// docs/TIMBER-FRAMING.md each opening is framed with 45×95 trimmers + headers
// (overligger) that bear back into the existing floor frame (V1, V5, mid-reglar
// → V3/V5), so the lid rebate is carried by structure — it does not float.
//
// Levels (z, mm): house floor deck top 120 → basement slab top -680 (drop 800).
// The floor frame (reglar + trimmers + headers) sits at z 0..95; the lid rests
// on their tops (z=95), flush with the deck (120) when closed.

include <../../lib/defaults.scad>
include <../config.scad>
include <../../lib/primitives/fundablok.scad>   // FUNDABLOK_W
use <../../lib/primitives/beslag.scad>           // stroesko (bjælkesko)

CONCRETE_COLOR = [0.62, 0.63, 0.64];   // cool grey, distinct from the warm ring
STAIR_TREAD_T  = 40;                   // tread thickness
STAIR_STRINGER = 45;                   // stringer thickness
LID_OPEN_DEG   = 78;                   // hatch lid open angle

// ---- concrete basement floor ---------------------------------------------
module RenderHouseBasementFloor(palette = DEFAULT_PALETTE) {
    rx0 = FUNDABLOK_W;                  // 150
    rx1 = RH_HOUSE_LEN   - FUNDABLOK_W; // 1850
    ry0 = FUNDABLOK_W;                  // 150
    ry1 = RH_HOUSE_DEPTH - FUNDABLOK_W; // 2850
    color(CONCRETE_COLOR)
        translate([rx0, ry0, RH_BASEMENT_FLOOR_Z - RH_BASEMENT_SLAB_T])
            cube([rx1 - rx0, ry1 - ry0, RH_BASEMENT_SLAB_T]);
}

// ---- helpers --------------------------------------------------------------
// Emit a world cube from run/cross coordinates: axis="Y" → run is Y, cross is X;
// axis="X" → run is X, cross is Y.
module _sbox(axis, r0, rlen, c0, clen, z0, zlen) {
    if (axis == "Y")
        translate([c0, r0, z0]) cube([clen, rlen, zlen]);
    else
        translate([r0, c0, z0]) cube([rlen, clen, zlen]);
}

// 45×95 floor reglar (trimmer / header / overligger) at the floor-frame level.
module _floor_reglar(axis, run0, run_len, cross0, palette) {
    color(pal_post(palette))
        _sbox(axis, run0, run_len, cross0,
              RH_FLOOR_REGLAR_W, RH_FLOOR_REGLAR_Z, RH_FLOOR_REGLAR_H);
}

// Joist hanger at a veksel/header junction. `axis`/`dir` = the joist's run
// direction toward the support; run_at = support face coord; cross_c = the
// joist centre on the cross axis.
module _bjaelkesko(axis, dir, run_at, cross_c) {
    rot = (axis == "Y") ? (dir > 0 ? 0 : 180) : (dir > 0 ? -90 : 90);
    pos = (axis == "Y") ? [cross_c, run_at, RH_FLOOR_REGLAR_Z]
                        : [run_at, cross_c, RH_FLOOR_REGLAR_Z];
    translate(pos) rotate([0, 0, rot])
        stroesko(RH_FLOOR_REGLAR_W, RH_FLOOR_REGLAR_H);
}

// ---- hatch framing ("veksling") ------------------------------------------
// Front-door hatch: front edge sits on V1 reglar; a full-width back header bears
// on V3/V5; two side trimmers span V1 → back header and catch the cut boards.
module _framing_front(palette) {
    h = RH_HATCH_FRONT; fw = RH_FLOOR_REGLAR_W;
    _floor_reglar("X", 195, 1610, h[3] - fw, palette);            // back header → V3/V5
    _floor_reglar("X", h[0], h[2] - h[0], h[1], palette);         // front header (on V1)
    _floor_reglar("Y", h[1], h[3] - fw - h[1], h[0], palette);    // left trimmer
    _floor_reglar("Y", h[1], h[3] - fw - h[1], h[2] - fw, palette); // right trimmer
    // bjælkesko at the veksel junctions
    _bjaelkesko("Y", +1, h[1],      h[0] + fw/2);   // left trimmer → V1
    _bjaelkesko("Y", -1, h[3] - fw, h[0] + fw/2);   // left trimmer → back header
    _bjaelkesko("Y", +1, h[1],      h[2] - fw/2);   // right trimmer → V1
    _bjaelkesko("Y", -1, h[3] - fw, h[2] - fw/2);   // right trimmer → back header
    _bjaelkesko("X", +1, 195,  h[3] - fw/2);        // back header → V3
    _bjaelkesko("X", -1, 1805, h[3] - fw/2);        // back header → V5
}

// Human-door hatch: right edge sits on V5 reglar; full-width back header bears on
// V3/V5; the front header sits against the mid-reglar; left trimmer spans
// mid-reglar → back header; a short cleat carries the lid rebate at the V5 side.
module _framing_human(palette) {
    h = RH_HATCH_HUMAN; fw = RH_FLOOR_REGLAR_W;
    // Long axis runs X (into the room from V5). Two full-width headers bear on
    // V3/V5; a left trimmer spans between them; the V5 reglar carries the right.
    _floor_reglar("X", 195, 1610, h[1], palette);                // front header → V3/V5
    _floor_reglar("X", 195, 1610, h[3] - fw, palette);           // back header → V3/V5
    _floor_reglar("Y", h[1], h[3] - h[1], h[0], palette);        // left trimmer
    _floor_reglar("Y", h[1], h[3] - h[1], h[2] - fw, palette);   // V5-side rebate cleat
    // bjælkesko at the veksel junctions
    _bjaelkesko("Y", +1, h[1] + fw, h[0] + fw/2);   // left trimmer → front header
    _bjaelkesko("Y", -1, h[3] - fw, h[0] + fw/2);   // left trimmer → back header
    _bjaelkesko("X", +1, 195,  h[1] + fw/2);        // front header → V3
    _bjaelkesko("X", -1, 1805, h[1] + fw/2);        // front header → V5
    _bjaelkesko("X", +1, 195,  h[3] - fw/2);        // back header → V3
    _bjaelkesko("X", -1, 1805, h[3] - fw/2);        // back header → V5
}

// ---- staircase ------------------------------------------------------------
// Sloped stringer beam between two run positions (top edge follows the slope).
// Both end slices sit INSIDE the run so the beam never pokes past the hatch edge.
module _stringer(axis, r_start, r_end, c_center, thick, ztop, zbot) {
    bh = 160;
    sgn = (r_end > r_start) ? 1 : -1;
    rA  = (sgn > 0) ? r_start   : r_start - 2;   // top slice, inward
    rB  = (sgn > 0) ? r_end - 2 : r_end;         // bottom slice, inward
    hull() {
        _sbox(axis, rA, 2, c_center - thick/2, thick, ztop - bh, bh);
        _sbox(axis, rB, 2, c_center - thick/2, thick, zbot - bh, bh);
    }
}

// One straight staircase. start = run coord of the top step (hatch door edge);
// dir = +1/-1 descent direction along the run axis; cross_c = cross-axis centre.
module _stair(axis, start, dir, cross_c, palette) {
    drop  = RH_FLOOR_DECK_TOP - RH_BASEMENT_FLOOR_Z;   // 800
    riser = drop / RH_STAIR_RISERS;                    // ≈133
    go    = RH_STAIR_GOING;                            // 100 (steep)
    w     = RH_STAIR_W;                                // 550

    color(pal_post(palette)) {
        for (i = [1 : RH_STAIR_RISERS - 1]) {          // last landing = the slab
            ztop   = RH_FLOOR_DECK_TOP - i * riser;
            r_lead = start + dir * (i - 1) * go;
            r_min  = min(r_lead, r_lead + dir * go);
            _sbox(axis, r_min, go, cross_c - w/2, w, ztop - STAIR_TREAD_T, STAIR_TREAD_T);
        }
        run_end = start + dir * RH_STAIR_RISERS * go;
        for (s = [-1, 1])
            _stringer(axis, start, run_end,
                      cross_c + s * (w/2 + STAIR_STRINGER/2), STAIR_STRINGER,
                      RH_FLOOR_DECK_Z, RH_BASEMENT_FLOOR_Z);   // top tucks under the deck
    }
}

// Hinged hatch lid, shown open, resting on the framing rebate (z=95).
module _lid(hatch, hinge, palette) {
    x0 = hatch[0]; y0 = hatch[1]; x1 = hatch[2]; y1 = hatch[3];
    lw = x1 - x0; ld = y1 - y0; t = RH_FLOOR_DECK_T; zt = RH_FLOOR_DECK_TOP;
    color(pal_floor(palette))
    if (hinge == "y1")
        translate([x0, y1, zt]) rotate([-LID_OPEN_DEG, 0, 0])
            translate([0, -ld, -t]) cube([lw, ld, t]);
    else // "x0"
        translate([x0, y0, zt]) rotate([0, -LID_OPEN_DEG, 0])
            translate([0, 0, -t]) cube([lw, ld, t]);
    // hinge knuckles on the deck at the pivot edge
    color(pal_mesh(palette))
    if (hinge == "y1")
        for (fx = [0.25, 0.75])
            translate([x0 + lw*fx - 40, y1 - 15, zt - 13]) cube([80, 30, 14]);
    else
        for (fy = [0.25, 0.75])
            translate([x0 - 15, y0 + ld*fy - 40, zt - 13]) cube([30, 80, 14]);
}

module RenderHouseStairs(palette = DEFAULT_PALETTE) {
    // front barn door — hatch near edge at Y=195, descend +Y, centred X≈1000
    _framing_front(palette);
    _stair("Y", RH_HATCH_FRONT[1], +1,
           (RH_HATCH_FRONT[0] + RH_HATCH_FRONT[2]) / 2, palette);
    _lid(RH_HATCH_FRONT, "y1", palette);

    // human door (V5) — hatch V5 edge at X=1805, descend -X, centred Y≈1947
    _framing_human(palette);
    _stair("X", RH_HATCH_HUMAN[2], -1,
           (RH_HATCH_HUMAN[1] + RH_HATCH_HUMAN[3]) / 2, palette);
    _lid(RH_HATCH_HUMAN, "x0", palette);
}
