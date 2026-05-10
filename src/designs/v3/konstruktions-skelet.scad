// konstruktions-skelet.scad — Wall skeleton: dpc + sill plate + studs + top plate.
// Part of the v3 build pipeline; included from build.scad.
//
// Scope: ONLY the four basic skeleton elements — nothing else.
// Losholter, vindkryds, gable infill, collar tie, beams, floor joists,
// framed openings — all live in other files (or come later).

include <../../lib/defaults.scad>
include <config.scad>

// === Material constants ===
DPC_COLOR    = [0.10, 0.10, 0.12];
DPC_T        = 2;          // mm — bitumen tape thickness
DPC_W        = 100;        // mm — slightly wider than the sill plate (95)

PLATE_DEPTH  = V3_POST_W;  // 95 — wall thickness (depth of sill + top plate)
PLATE_HEIGHT = V3_SILL_H;  // 45 — sill / top plate cross-section height

STUD_DEPTH   = 95;         // perpendicular to wall face
STUD_THICK   = 45;         // along wall length
STUD_C2C     = 600;        // standard centre-to-centre spacing

// === Wall top heights ===
// Front wall is HIGH (eh_front); back, sides and partition are LOW (eh_back).
// The triangular gap above side walls (between low top plate and sloping
// roof) is NOT part of this file — it'll be a separate "gable infill"
// element added later.
WALL_TOP_HIGH = V3_BASE_H + V3_EH_FRONT;   // 120 + 2500 = 2620
WALL_TOP_LOW  = V3_BASE_H + V3_EH_BACK;    // 120 + 2000 = 2120

// Z of the bottom of the studs (= top of sill plate, which sits on top of DPC).
STUD_BOTTOM_Z = V3_BASE_H + DPC_T + PLATE_HEIGHT;   // 167

// ----------------------------------------------------------------------------
// 1. DPC — continuous bitumen tape on top of the sokkel ring.
// ----------------------------------------------------------------------------

module v3_dpc() {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    z = V3_BASE_H;
    color(DPC_COLOR) {
        translate([0, 0, z])             cube([ll, DPC_W, DPC_T]);  // front
        translate([0, ww - DPC_W, z])    cube([ll, DPC_W, DPC_T]);  // back
        translate([0, 0, z])             cube([DPC_W, ww, DPC_T]);  // left
        translate([ll - DPC_W, 0, z])    cube([DPC_W, ww, DPC_T]);  // right
        translate([hl - DPC_W/2, 0, z])  cube([DPC_W, ww, DPC_T]);  // partition
    }
}

// ----------------------------------------------------------------------------
// 2. Sill plate — continuous 45×95 PT bottom plate, all the way around
//    the perimeter + cross-wall under the partition.
// ----------------------------------------------------------------------------

module v3_sill_plate(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;
    z = V3_BASE_H + DPC_T;   // 122 — sits on top of DPC
    color(pal_post(palette)) {
        translate([0, 0, z])           cube([ll, sd, sw]);   // front
        translate([0, ww - sd, z])     cube([ll, sd, sw]);   // back
        translate([0, 0, z])           cube([sd, ww, sw]);   // left
        translate([ll - sd, 0, z])     cube([sd, ww, sw]);   // right
        translate([hl - sd/2, 0, z])   cube([sd, ww, sw]);   // partition
    }
}

// ----------------------------------------------------------------------------
// 3. Studs — vertical 45×95 reglar at 600 mm c/c on every wall.
//    skip_ranges (from config) lets the grid skip positions where doors
//    or windows will land — actual jamb/header framing is in aabninger.
// ----------------------------------------------------------------------------

function _in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// Helper — emit studs along one wall.
//   origin       = wall's outside-bottom corner (wall starts at Z=STUD_BOTTOM_Z)
//   length       = wall length along its axis
//   axis         = "X" (wall runs +X) or "Y" (wall runs +Y)
//   stud_height  = top plate bottom Z minus stud bottom Z
//   skip_ranges  = list of [lo, hi] along the wall — studs whose centre
//                  falls inside any range are omitted
module _v3_studs_one_wall(origin, length, axis, stud_height,
                          skip_ranges=[], palette=DEFAULT_PALETTE) {
    z = STUD_BOTTOM_Z;
    end_stud_x = length - STUD_THICK;

    // Skip end stud if it would land within ~100 mm of last grid stud's right
    // face. Otherwise we get an ugly 10 mm "air gap" between two parallel
    // studs at the wall end (no carpenter would build it that way — the
    // corner connection from the perpendicular wall provides support).
    last_loop_x     = floor(end_stud_x / STUD_C2C) * STUD_C2C;
    last_loop_right = last_loop_x + STUD_THICK;
    emit_end_stud   = (end_stud_x - last_loop_right) >= 100;

    color(pal_post(palette))
    if (axis == "X") {
        for (x = [0 : STUD_C2C : end_stud_x])
            if (!_in_any_skip(x + STUD_THICK/2, skip_ranges))
                translate([origin[0] + x, origin[1], z])
                    cube([STUD_THICK, STUD_DEPTH, stud_height]);
        if (emit_end_stud)
            translate([origin[0] + end_stud_x, origin[1], z])
                cube([STUD_THICK, STUD_DEPTH, stud_height]);
    } else {
        for (y = [0 : STUD_C2C : end_stud_x])
            if (!_in_any_skip(y + STUD_THICK/2, skip_ranges))
                translate([origin[0], origin[1] + y, z])
                    cube([STUD_DEPTH, STUD_THICK, stud_height]);
        if (emit_end_stud)
            translate([origin[0], origin[1] + end_stud_x, z])
                cube([STUD_DEPTH, STUD_THICK, stud_height]);
    }
}

module v3_studs(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    z = STUD_BOTTOM_Z;

    // Stud heights — top plate sits ABOVE the stud, so subtract PLATE_HEIGHT.
    h_high = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;
    h_low  = WALL_TOP_LOW  - STUD_BOTTOM_Z - PLATE_HEIGHT;

    // Skip ranges driven by opening positions in config.
    front_skip     = [[V3_YARD_DOOR_X, V3_YARD_DOOR_X + V3_YARD_DOOR_W]];
    left_skip      = [[V3_SIDE_WIN_Y,  V3_SIDE_WIN_Y  + V3_SIDE_WIN_W]];
    partition_skip = [
        [V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_Y + V3_HOUSE_DOOR_W],
        [V3_PET_DOOR_Y,   V3_PET_DOOR_Y   + V3_PET_DOOR_W]
    ];

    // --- Regular grid studs (c/c 600) ---
    _v3_studs_one_wall([0, 0, 0],                 ll, "X", h_high,
                       skip_ranges=front_skip,     palette=palette);  // front
    _v3_studs_one_wall([0, ww - STUD_DEPTH, 0],   ll, "X", h_low,
                       palette=palette);                                // back
    _v3_studs_one_wall([0, 0, 0],                 ww, "Y", h_low,
                       skip_ranges=left_skip,      palette=palette);   // left
    _v3_studs_one_wall([ll - STUD_DEPTH, 0, 0],   ww, "Y", h_low,
                       palette=palette);                                // right
    _v3_studs_one_wall([hl - STUD_DEPTH/2, 0, 0], ww, "Y", h_low,
                       skip_ranges=partition_skip, palette=palette);   // partition

    // --- Jamb studs (= reglar der binder hver opnings kanter) ---
    // Indersiden af jamb-stud flugter med åbningens kant; selve åbningen er
    // mellem jamb-studs' inderfladser. Header, cripples og rough sill ligger
    // i aabninger.scad (todo.md #3).
    color(pal_post(palette)) {
        // Front wall — yard door
        translate([V3_YARD_DOOR_X - STUD_THICK, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([V3_YARD_DOOR_X + V3_YARD_DOOR_W, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);

        // Left wall — side window
        translate([0, V3_SIDE_WIN_Y - STUD_THICK, z])
            cube([STUD_DEPTH, STUD_THICK, h_low]);
        translate([0, V3_SIDE_WIN_Y + V3_SIDE_WIN_W, z])
            cube([STUD_DEPTH, STUD_THICK, h_low]);

        // Partition wall — human door
        translate([hl - STUD_DEPTH/2, V3_HOUSE_DOOR_Y - STUD_THICK, z])
            cube([STUD_DEPTH, STUD_THICK, h_low]);
        translate([hl - STUD_DEPTH/2, V3_HOUSE_DOOR_Y + V3_HOUSE_DOOR_W, z])
            cube([STUD_DEPTH, STUD_THICK, h_low]);

        // Partition wall — pet door
        translate([hl - STUD_DEPTH/2, V3_PET_DOOR_Y - STUD_THICK, z])
            cube([STUD_DEPTH, STUD_THICK, h_low]);
        translate([hl - STUD_DEPTH/2, V3_PET_DOOR_Y + V3_PET_DOOR_W, z])
            cube([STUD_DEPTH, STUD_THICK, h_low]);
    }

    // --- Junction studs (T-samlings-reglar hvor partition møder front/bag) ---
    // Partition-væggen er en cross-wall der binder hus og yard sammen. Hvor
    // den møder front- og bag-væggen, skal der være en perpendikulær reglar
    // i den længdegående væg som partition-væggens endestud kan fastgøres til.
    // Uden disse reglar står partition-væggen "i luften" ved sine endepunkter.
    color(pal_post(palette)) {
        // Front-væg: junction-reglar ved X=hl, full HIGH height
        translate([hl - STUD_THICK/2, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        // Bag-væg: junction-reglar ved X=hl, full LOW height
        translate([hl - STUD_THICK/2, ww - STUD_DEPTH, z])
            cube([STUD_THICK, STUD_DEPTH, h_low]);
    }
}

// ----------------------------------------------------------------------------
// 4. Top plate — horizontal 45×95 on top of studs. Front wall HIGH,
//    back/sides/partition LOW. Sloped tops are not used — the gap above
//    side walls is closed later by a separate gable infill element.
// ----------------------------------------------------------------------------

module v3_top_plate(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;
    z_high_bot = WALL_TOP_HIGH - sw;   // top plate's bottom Z
    z_low_bot  = WALL_TOP_LOW  - sw;
    color(pal_post(palette)) {
        // Front (HIGH)
        translate([0, 0, z_high_bot])         cube([ll, sd, sw]);
        // Back (LOW)
        translate([0, ww - sd, z_low_bot])    cube([ll, sd, sw]);
        // Left (LOW)
        translate([0, 0, z_low_bot])          cube([sd, ww, sw]);
        // Right (LOW)
        translate([ll - sd, 0, z_low_bot])    cube([sd, ww, sw]);
        // Partition (LOW)
        translate([hl - sd/2, 0, z_low_bot])  cube([sd, ww, sw]);
    }
}

// ----------------------------------------------------------------------------
// Wrapper — composes the 4 skeleton elements.
// ----------------------------------------------------------------------------

module v3_konstruktions_skelet(palette = DEFAULT_PALETTE) {
    v3_dpc();
    v3_sill_plate(palette);
    v3_studs(palette);
    v3_top_plate(palette);
}
