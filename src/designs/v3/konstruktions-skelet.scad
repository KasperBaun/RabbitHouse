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
    color(pal_post(palette))
    if (axis == "X") {
        for (x = [0 : STUD_C2C : length - STUD_THICK])
            if (!_in_any_skip(x + STUD_THICK/2, skip_ranges))
                translate([origin[0] + x, origin[1], z])
                    cube([STUD_THICK, STUD_DEPTH, stud_height]);
        // End stud (always emit; may overlap last loop stud — harmless)
        translate([origin[0] + length - STUD_THICK, origin[1], z])
            cube([STUD_THICK, STUD_DEPTH, stud_height]);
    } else {
        for (y = [0 : STUD_C2C : length - STUD_THICK])
            if (!_in_any_skip(y + STUD_THICK/2, skip_ranges))
                translate([origin[0], origin[1] + y, z])
                    cube([STUD_DEPTH, STUD_THICK, stud_height]);
        translate([origin[0], origin[1] + length - STUD_THICK, z])
            cube([STUD_DEPTH, STUD_THICK, stud_height]);
    }
}

module v3_studs(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;

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
