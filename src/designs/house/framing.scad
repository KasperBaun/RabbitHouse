// HOUSE framing — DPC + sill + studs + framed openings + top plate for
// the house segment (X = 0..hl). Self-contained: all helpers are local to
// this file so the house folder is independent of yard.

include <../../lib/defaults.scad>
include <../config.scad>

DPC_COLOR    = [0.10, 0.10, 0.12];
DPC_T        = 2;
DPC_W        = 100;

PLATE_DEPTH  = RH_POST_W;      // 95
PLATE_HEIGHT = RH_SILL_H;      // 45

STUD_DEPTH   = 95;
STUD_THICK   = 45;
STUD_C2C     = 600;

WALL_TOP_HIGH = RH_BASE_H + RH_EH_FRONT;
WALL_TOP_LOW  = RH_BASE_H + RH_EH_BACK;
STUD_BOTTOM_Z = RH_BASE_H + DPC_T + PLATE_HEIGHT;

JAMB_BUFFER = 300;
function _jamb_bx() = STUD_THICK + JAMB_BUFFER;

function wall_top_z(y) =
    WALL_TOP_HIGH - (WALL_TOP_HIGH - WALL_TOP_LOW) * y / RH_HOUSE_DEPTH;
function stud_top_z(y) = wall_top_z(y) - PLATE_HEIGHT;

function _in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// Sloped Y-axis stud (V3 and V4 have sloped tops).
module _sloped_stud_y(x, y) {
    z_top_front = stud_top_z(y);
    z_top_back  = stud_top_z(y + STUD_THICK);
    hull() {
        translate([x, y, STUD_BOTTOM_Z])
            cube([STUD_DEPTH, STUD_THICK, 0.1]);
        translate([x, y, z_top_front - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
        translate([x, y + STUD_THICK - 0.1, z_top_back - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
    }
}

module _sloped_cripple_y(x, y, z_bot) {
    z_top_front = stud_top_z(y);
    z_top_back  = stud_top_z(y + STUD_THICK);
    hull() {
        translate([x, y, z_bot])
            cube([STUD_DEPTH, STUD_THICK, 0.1]);
        translate([x, y, z_top_front - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
        translate([x, y + STUD_THICK - 0.1, z_top_back - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
    }
}

module _sloped_top_plate(x, y0, y1) {
    sw = PLATE_HEIGHT;
    z0 = wall_top_z(y0) - sw;
    z1 = wall_top_z(y1) - sw;
    hull() {
        translate([x, y0, z0])        cube([STUD_DEPTH, 0.01, sw]);
        translate([x, y1 - 0.01, z1]) cube([STUD_DEPTH, 0.01, sw]);
    }
}

module _studs_one_wall(origin, length, axis, stud_height,
                       skip_ranges=[], palette=DEFAULT_PALETTE,
                       emit_end=true) {
    z = STUD_BOTTOM_Z;
    end_stud_x = length - STUD_THICK;

    last_loop_x     = floor(end_stud_x / STUD_C2C) * STUD_C2C;
    last_loop_right = last_loop_x + STUD_THICK;
    emit_end_stud   = emit_end && (end_stud_x - last_loop_right) >= 100;

    color(pal_post(palette))
    if (axis == "X") {
        for (x = [0 : STUD_C2C : end_stud_x])
            if (!_in_any_skip(origin[0] + x + STUD_THICK/2, skip_ranges))
                translate([origin[0] + x, origin[1], z])
                    cube([STUD_THICK, STUD_DEPTH, stud_height]);
        if (emit_end_stud)
            translate([origin[0] + end_stud_x, origin[1], z])
                cube([STUD_THICK, STUD_DEPTH, stud_height]);
    } else {
        for (y = [0 : STUD_C2C : end_stud_x])
            if (!_in_any_skip(origin[1] + y + STUD_THICK/2, skip_ranges))
                _sloped_stud_y(origin[0], origin[1] + y);
        if (emit_end_stud)
            _sloped_stud_y(origin[0], origin[1] + end_stud_x);
    }
}

// V1 window framing — header + sill across the opening, an outer cripple
// below the sill and above the header at the corner/junction-stud side,
// and a dedicated FULL-HEIGHT inner jamb stud on the door side (so the
// window is structurally independent of the door jamb). `inner_side` is
// "right" when the door-facing edge is the right face of the opening
// (i.e., left window) and "left" for the right window.
module _frame_v1_window(x0, inner_side, palette = DEFAULT_PALETTE) {
    w           = RH_FRONT_WIN_W;
    z_floor     = RH_FLOOR_TOP;
    z_sill_top  = z_floor + RH_FRONT_WIN_Z;
    z_sill_bot  = z_sill_top - PLATE_HEIGHT;
    z_head_bot  = z_sill_top + RH_FRONT_WIN_H;
    z_head_top  = z_head_bot + PLATE_HEIGHT;
    z_plate_bot = WALL_TOP_HIGH - PLATE_HEIGHT;
    h_below     = z_sill_bot - STUD_BOTTOM_Z;
    h_above     = z_plate_bot - z_head_top;
    h_full      = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;

    inner_jamb_x   = inner_side == "right" ? x0 + w           : x0 - STUD_THICK;
    outer_cripple_x = inner_side == "right" ? x0               : x0 + w - STUD_THICK;

    color(pal_post(palette)) {
        translate([x0, 0, z_head_bot])
            cube([w, STUD_DEPTH, PLATE_HEIGHT]);
        translate([x0, 0, z_sill_bot])
            cube([w, STUD_DEPTH, PLATE_HEIGHT]);
        if (h_below > 50)
            translate([outer_cripple_x, 0, STUD_BOTTOM_Z])
                cube([STUD_THICK, STUD_DEPTH, h_below]);
        if (h_above > 50)
            translate([outer_cripple_x, 0, z_head_top])
                cube([STUD_THICK, STUD_DEPTH, h_above]);
        translate([inner_jamb_x, 0, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_full]);
    }
}

module _render_framed_opening(wall_origin, axis,
                              opening_pos, opening_w,
                              opening_z, opening_h,
                              has_sill, wall_top,
                              sloped = false,
                              palette = DEFAULT_PALETTE) {
    z_header_bot     = opening_z + opening_h;
    z_header_top     = z_header_bot + PLATE_HEIGHT;
    z_top_plate_bot  = wall_top - PLATE_HEIGHT;
    crip_above_h     = z_top_plate_bot - z_header_top;
    z_sill_top       = opening_z;
    z_sill_bot       = z_sill_top - PLATE_HEIGHT;
    crip_below_h     = z_sill_bot - STUD_BOTTOM_Z;

    color(pal_post(palette))
    if (axis == "X") {
        translate([wall_origin[0] + opening_pos, wall_origin[1], z_header_bot])
            cube([opening_w, STUD_DEPTH, PLATE_HEIGHT]);
        if (crip_above_h > 50)
            for (cx = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                translate([wall_origin[0] + opening_pos + cx - STUD_THICK/2,
                           wall_origin[1], z_header_top])
                    cube([STUD_THICK, STUD_DEPTH, crip_above_h]);
        if (has_sill) {
            translate([wall_origin[0] + opening_pos, wall_origin[1], z_sill_bot])
                cube([opening_w, STUD_DEPTH, PLATE_HEIGHT]);
            if (crip_below_h > 50)
                for (cx = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                    translate([wall_origin[0] + opening_pos + cx - STUD_THICK/2,
                               wall_origin[1], STUD_BOTTOM_Z])
                        cube([STUD_THICK, STUD_DEPTH, crip_below_h]);
        }
    } else {
        translate([wall_origin[0], wall_origin[1] + opening_pos, z_header_bot])
            cube([STUD_DEPTH, opening_w, PLATE_HEIGHT]);
        if (sloped) {
            for (cy = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2]) {
                cy_abs = wall_origin[1] + opening_pos + cy - STUD_THICK/2;
                if (stud_top_z(cy_abs + STUD_THICK/2) - z_header_top > 50)
                    _sloped_cripple_y(wall_origin[0], cy_abs, z_header_top);
            }
        } else if (crip_above_h > 50) {
            for (cy = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                translate([wall_origin[0],
                           wall_origin[1] + opening_pos + cy - STUD_THICK/2,
                           z_header_top])
                    cube([STUD_DEPTH, STUD_THICK, crip_above_h]);
        }
        if (has_sill) {
            translate([wall_origin[0], wall_origin[1] + opening_pos, z_sill_bot])
                cube([STUD_DEPTH, opening_w, PLATE_HEIGHT]);
            if (crip_below_h > 50)
                for (cy = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                    translate([wall_origin[0],
                               wall_origin[1] + opening_pos + cy - STUD_THICK/2,
                               STUD_BOTTOM_Z])
                        cube([STUD_DEPTH, STUD_THICK, crip_below_h]);
        }
    }
}

// ============================================================================
// HOUSE entry — X=0..hl segment of V1/V2 + V3 + V4 + junction stud at X=hl.
// ============================================================================
module RenderHouseFraming(palette = DEFAULT_PALETTE) {
    ww = RH_HOUSE_DEPTH; hl = RH_HOUSE_LEN;
    h_high = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;
    h_low  = WALL_TOP_LOW  - STUD_BOTTOM_Z - PLATE_HEIGHT;
    bx     = _jamb_bx();
    butt_y0  = STUD_DEPTH;
    butt_len = ww - 2 * STUD_DEPTH;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;

    // DPC — V1 + V2 segments [0..hl] + V3 cross + V4 cross.
    color(DPC_COLOR) {
        translate([0, 0, RH_BASE_H])         cube([hl, DPC_W, DPC_T]);
        translate([0, ww - DPC_W, RH_BASE_H]) cube([hl, DPC_W, DPC_T]);
        // V3 at X=0
        translate([0, DPC_W, RH_BASE_H])
            cube([DPC_W, ww - 2*DPC_W, DPC_T]);
        // V4 — sits inside the foundation strip (X=hl-bw..hl), outer face
        // flush with hl so it matches the foundation outer edge.
        translate([hl - DPC_W, DPC_W, RH_BASE_H])
            cube([DPC_W, ww - 2*DPC_W, DPC_T]);
    }

    // Sill plate — same layout one DPC layer up.
    color(pal_post(palette)) {
        translate([0, 0, RH_BASE_H + DPC_T])         cube([hl, sd, sw]);
        translate([0, ww - sd, RH_BASE_H + DPC_T])   cube([hl, sd, sw]);
        translate([0, sd, RH_BASE_H + DPC_T])
            cube([sd, ww - 2*sd, sw]);
        translate([hl - sd, sd, RH_BASE_H + DPC_T])
            cube([sd, ww - 2*sd, sw]);
    }

    // Top plate — V1/V2 flat segments + sloped on V3, V4.
    color(pal_post(palette)) {
        translate([0, 0, WALL_TOP_HIGH - sw])      cube([hl, sd, sw]);
        translate([0, ww - sd, WALL_TOP_LOW - sw]) cube([hl, sd, sw]);
        _sloped_top_plate(0,           butt_y0, ww - sd);
        _sloped_top_plate(hl - sd,     butt_y0, ww - sd);
    }

    // V1[0..hl] studs — flat HIGH. Skip end stud (junction stud handles it).
    // Skip-ranges use raw opening bounds (no JAMB_BUFFER pad) so the corner
    // stud at X=0 survives next to the close-set left window jamb.
    v1_skip = [
        [RH_FRONT_DOOR_X,       RH_FRONT_DOOR_X       + RH_FRONT_DOOR_W],
        [RH_FRONT_WIN_X_LEFT,   RH_FRONT_WIN_X_LEFT   + RH_FRONT_WIN_W],
        [RH_FRONT_WIN_X_RIGHT,  RH_FRONT_WIN_X_RIGHT  + RH_FRONT_WIN_W]
    ];
    _studs_one_wall([0, 0, 0], hl, "X", h_high,
                    skip_ranges=v1_skip,
                    palette=palette, emit_end=false);

    // V2[0..hl] studs — flat LOW.
    _studs_one_wall([0, ww - STUD_DEPTH, 0], hl, "X", h_low,
                    palette=palette, emit_end=false);

    // Jamb studs for V1 door — windows reuse the adjacent corner / door
    // jamb / junction stud as their jamb (side panel = 460, window = 450,
    // so 5 mm clearance leaves no room for separate window jambs).
    color(pal_post(palette)) {
        translate([RH_FRONT_DOOR_X - STUD_THICK, 0, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([RH_FRONT_DOOR_X + RH_FRONT_DOOR_W, 0, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
    }

    // Framed openings — V1 door uses the shared helper (no sill); V1
    // windows use a custom helper with explicit jamb cripples at each
    // opening edge (no off-center center cripple).
    _render_framed_opening(wall_origin = [0, 0, 0], axis = "X",
                           opening_pos = RH_FRONT_DOOR_X, opening_w = RH_FRONT_DOOR_W,
                           opening_z = STUD_BOTTOM_Z, opening_h = RH_FRONT_DOOR_H,
                           has_sill = false, wall_top = WALL_TOP_HIGH,
                           palette = palette);
    _frame_v1_window(RH_FRONT_WIN_X_LEFT,  inner_side = "right", palette = palette);
    _frame_v1_window(RH_FRONT_WIN_X_RIGHT, inner_side = "left",  palette = palette);

    // V3 — solid Y wall, no openings (window removed; gable rafters above).
    _studs_one_wall([0, butt_y0, 0], butt_len, "Y", h_high,
                    palette=palette);

    // V4 partition — Y wall with human-door + pet-door cutouts.
    partition_skip = [
        [RH_HOUSE_DOOR_Y - bx, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W + bx],
        [RH_PET_DOOR_Y   - bx, RH_PET_DOOR_Y   + RH_PET_DOOR_W   + bx]
    ];
    _studs_one_wall([hl - STUD_DEPTH, butt_y0, 0], butt_len, "Y", h_high,
                    skip_ranges=partition_skip, palette=palette);

    // Jamb studs for V4 openings.
    color(pal_post(palette)) {
        _sloped_stud_y(hl - STUD_DEPTH, RH_HOUSE_DOOR_Y - STUD_THICK);
        _sloped_stud_y(hl - STUD_DEPTH, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W);

        _sloped_stud_y(hl - STUD_DEPTH, RH_PET_DOOR_Y - STUD_THICK);
        _sloped_stud_y(hl - STUD_DEPTH, RH_PET_DOOR_Y + RH_PET_DOOR_W);
    }

    // Junction studs at the V4/V1 and V4/V2 corners — V4's outer face is
    // at X=hl, so the corner stud is flush with hl on the right.
    color(pal_post(palette)) {
        translate([hl - STUD_THICK, 0, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([hl - STUD_THICK, ww - STUD_DEPTH, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
    }

    // Framed openings — V4 doors only. With h_high == 2000 the top plate
    // doubles as the door header; the _render_framed_opening helper emits
    // a header beam that coincides with the top plate (visually one beam).
    _render_framed_opening(wall_origin = [hl - STUD_DEPTH, 0, 0], axis = "Y",
                           opening_pos = RH_HOUSE_DOOR_Y, opening_w = RH_HOUSE_DOOR_W,
                           opening_z = STUD_BOTTOM_Z, opening_h = RH_HOUSE_DOOR_H,
                           has_sill = false, wall_top = WALL_TOP_HIGH,
                           sloped = true, palette = palette);
    _render_framed_opening(wall_origin = [hl - STUD_DEPTH, 0, 0], axis = "Y",
                           opening_pos = RH_PET_DOOR_Y, opening_w = RH_PET_DOOR_W,
                           opening_z = RH_FLOOR_TOP + 60, opening_h = RH_PET_DOOR_H,
                           has_sill = false, wall_top = WALL_TOP_HIGH,
                           sloped = true, palette = palette);
}
