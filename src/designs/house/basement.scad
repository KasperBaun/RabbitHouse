// HOUSE basement ("kælder") — the hollow fundablok ring is a usable pit.
//   RenderHouseBasementFloor() — concrete slab at the ring bottom (z=-680)
//   RenderHouseStairs()        — two steep staircases (front + human door) down
//        to the slab; each hatch gets a rebate ledge (fals) + a hinged lid.
//
// The hatch openings and their veksling (bearers + veksler that box each
// opening) live entirely in floor.scad — this file owns only the slab, stairs,
// lid rebate and lid, so the hatch frame is drawn once. RH_HATCH_* (config)
// is the shared opening rectangle both files key off.
//
// Levels (z, mm): house floor deck top 120 → basement slab top -680 (drop 800).
// The floor frame sits at z 0..95; the lid rests on the fals (z=95), flush with
// the deck (120) when closed.

include <../../lib/defaults.scad>
include <../config.scad>
include <../../lib/primitives/fundablok.scad>   // FUNDABLOK_W

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

// Rebate ledge ("anslagsliste" 45×45) on the inside of the opening, top flush
// with the deck underside (z=95) — drawn 1 mm proud + 5 mm into the clear hole
// so it reads distinctly from the framing reglar that carry it. The lid drops
// into the 25 mm recess and rests on this ledge, flush with the deck, so it
// cannot fall through.
module _lem_fals(hatch, palette) {
    x0 = hatch[0]; y0 = hatch[1]; x1 = hatch[2]; y1 = hatch[3];
    proj = RH_FLOOR_REGLAR_W + 5;            // 50 — projection into the opening
    lz   = 46;                               // height; top sits 1 mm proud of z95
    z0   = RH_FLOOR_DECK_Z - 45;             // 50  (top at 96)
    color(pal_trim(palette)) {
        translate([x0,      y0,        z0]) cube([x1 - x0, proj,    lz]);  // front
        translate([x0,      y1 - proj, z0]) cube([x1 - x0, proj,    lz]);  // back
        translate([x0,      y0,        z0]) cube([proj,    y1 - y0, lz]);  // left
        translate([x1-proj, y0,        z0]) cube([proj,    y1 - y0, lz]);  // right
    }
}

// Flush folding ring pull ("planforsænket klapgreb"). Local origin on the lid
// top face, +z out of the lid; the ring lies flush in a shallow recess.
module _greb(palette) {
    color([0.20, 0.20, 0.22])                                  // recessed pocket
        translate([0, 0, -5]) cube([120, 72, 6], center = true);
    color(pal_mesh(palette))                                   // metal ring, flush
        translate([0, 0, -6]) difference() {
            cylinder(h = 6, r = 34, $fn = 44);
            translate([0, 0, -1]) cylinder(h = 8, r = 24, $fn = 44);
        }
}

// Hinged hatch lid, shown open, resting on the framing rebate (z=95), with a
// flush ring pull near the free edge.
module _lid(hatch, hinge, palette) {
    x0 = hatch[0]; y0 = hatch[1]; x1 = hatch[2]; y1 = hatch[3];
    lw = x1 - x0; ld = y1 - y0; t = RH_FLOOR_DECK_T; zt = RH_FLOOR_DECK_TOP;
    if (hinge == "y1")
        translate([x0, y1, zt]) rotate([-LID_OPEN_DEG, 0, 0]) translate([0, -ld, -t]) {
            color(pal_floor(palette)) cube([lw, ld, t]);
            translate([lw/2, 130, t]) _greb(palette);          // near free edge (local y≈0)
        }
    else // "x0"
        translate([x0, y0, zt]) rotate([0, -LID_OPEN_DEG, 0]) translate([0, 0, -t]) {
            color(pal_floor(palette)) cube([lw, ld, t]);
            translate([lw - 130, ld/2, t]) _greb(palette);     // near free edge (local x≈lw)
        }
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
    // (the hatch frame itself is drawn by RenderHouseFloorJoists in floor.scad)
    _lem_fals(RH_HATCH_FRONT, palette);
    _stair("Y", RH_HATCH_FRONT[1], +1,
           (RH_HATCH_FRONT[0] + RH_HATCH_FRONT[2]) / 2, palette);
    _lid(RH_HATCH_FRONT, "y1", palette);

    // human door (V5) — hatch V5 edge at X=1805, descend -X, centred Y≈1947
    _lem_fals(RH_HATCH_HUMAN, palette);
    _stair("X", RH_HATCH_HUMAN[2], -1,
           (RH_HATCH_HUMAN[1] + RH_HATCH_HUMAN[3]) / 2, palette);
    _lid(RH_HATCH_HUMAN, "x0", palette);
}
