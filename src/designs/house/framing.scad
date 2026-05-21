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

// Sloped Y-axis stud (V3 and V5 have sloped tops).
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
// HOUSE entry — X=0..hl segment of V1/V2 + V3 + V5 + junction stud at X=hl.
// ============================================================================
module RenderHouseFraming(palette = DEFAULT_PALETTE) {
    ww = RH_HOUSE_DEPTH; hl = RH_HOUSE_LEN;
    h_high = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;
    h_low  = WALL_TOP_LOW  - STUD_BOTTOM_Z - PLATE_HEIGHT;
    bx     = _jamb_bx();
    butt_y0  = STUD_DEPTH;
    butt_len = ww - 2 * STUD_DEPTH;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;

    // DPC — V1 + V2 segments [0..hl] + V3 cross + V5 cross.
    color(DPC_COLOR) {
        translate([0, 0, RH_BASE_H])         cube([hl, DPC_W, DPC_T]);
        translate([0, ww - DPC_W, RH_BASE_H]) cube([hl, DPC_W, DPC_T]);
        // V3 at X=0
        translate([0, DPC_W, RH_BASE_H])
            cube([DPC_W, ww - 2*DPC_W, DPC_T]);
        // V5 — sits inside the foundation strip (X=hl-bw..hl), outer face
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

    // Top plate — V1/V2 flat segments + sloped on V3, V5.
    color(pal_post(palette)) {
        translate([0, 0, WALL_TOP_HIGH - sw])      cube([hl, sd, sw]);
        translate([0, ww - sd, WALL_TOP_LOW - sw]) cube([hl, sd, sw]);
        _sloped_top_plate(0,           butt_y0, ww - sd);
        _sloped_top_plate(hl - sd,     butt_y0, ww - sd);
    }

    // V1[0..hl] studs — flat HIGH. Skip end stud (junction stud handles it).
    _studs_one_wall([0, 0, 0], hl, "X", h_high,
                    palette=palette, emit_end=false);

    // V2[0..hl] studs — flat LOW.
    _studs_one_wall([0, ww - STUD_DEPTH, 0], hl, "X", h_low,
                    palette=palette, emit_end=false);

    // V3 — sloped Y wall with side-window cutout.
    left_skip = [[RH_SIDE_WIN_Y - bx, RH_SIDE_WIN_Y + RH_SIDE_WIN_W + bx]];
    _studs_one_wall([0, butt_y0, 0], butt_len, "Y", h_low,
                    skip_ranges=left_skip, palette=palette);

    // V5 partition — sloped Y wall with human-door + pet-door cutouts.
    partition_skip = [
        [RH_HOUSE_DOOR_Y - bx, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W + bx],
        [RH_PET_DOOR_Y   - bx, RH_PET_DOOR_Y   + RH_PET_DOOR_W   + bx]
    ];
    _studs_one_wall([hl - STUD_DEPTH, butt_y0, 0], butt_len, "Y", h_low,
                    skip_ranges=partition_skip, palette=palette);

    // Jamb studs for house openings.
    color(pal_post(palette)) {
        _sloped_stud_y(0, RH_SIDE_WIN_Y - STUD_THICK);
        _sloped_stud_y(0, RH_SIDE_WIN_Y + RH_SIDE_WIN_W);

        _sloped_stud_y(hl - STUD_DEPTH, RH_HOUSE_DOOR_Y - STUD_THICK);
        _sloped_stud_y(hl - STUD_DEPTH, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W);

        _sloped_stud_y(hl - STUD_DEPTH, RH_PET_DOOR_Y - STUD_THICK);
        _sloped_stud_y(hl - STUD_DEPTH, RH_PET_DOOR_Y + RH_PET_DOOR_W);
    }

    // Junction studs at the V5/V1 and V5/V2 corners — V5's outer face is
    // at X=hl, so the corner stud is flush with hl on the right.
    color(pal_post(palette)) {
        translate([hl - STUD_THICK, 0, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([hl - STUD_THICK, ww - STUD_DEPTH, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_low]);
    }

    // Framed openings.
    _render_framed_opening(wall_origin = [0, 0, 0], axis = "Y",
                           opening_pos = RH_SIDE_WIN_Y, opening_w = RH_SIDE_WIN_W,
                           opening_z = STUD_BOTTOM_Z + RH_SIDE_WIN_Z,
                           opening_h = RH_SIDE_WIN_H,
                           has_sill = true, wall_top = WALL_TOP_LOW,
                           sloped = true, palette = palette);
    _render_framed_opening(wall_origin = [hl - STUD_DEPTH, 0, 0], axis = "Y",
                           opening_pos = RH_HOUSE_DOOR_Y, opening_w = RH_HOUSE_DOOR_W,
                           opening_z = STUD_BOTTOM_Z, opening_h = RH_HOUSE_DOOR_H,
                           has_sill = false, wall_top = WALL_TOP_LOW,
                           sloped = true, palette = palette);
    _render_framed_opening(wall_origin = [hl - STUD_DEPTH, 0, 0], axis = "Y",
                           opening_pos = RH_PET_DOOR_Y, opening_w = RH_PET_DOOR_W,
                           opening_z = RH_FLOOR_TOP + 60, opening_h = RH_PET_DOOR_H,
                           has_sill = false, wall_top = WALL_TOP_LOW,
                           sloped = true, palette = palette);
}
