// YARD framing — DPC + sill + studs + yard-door framed opening + top plate
// for the yard segment (X = hl..ll, Y = yo..yo+yd where yo=RH_YARD_Y_OFFSET
// and yd=RH_YARD_DEPTH). Self-contained: all helpers are local to this file
// so the yard folder is independent of house. The junction stud at X=hl
// belongs to HOUSE; yard's V1/V2 segments start clean at X=hl.

include <../../lib/defaults.scad>
include <../config.scad>

DPC_COLOR    = [0.10, 0.10, 0.12];
DPC_T        = 2;
DPC_W        = 100;

PLATE_DEPTH  = RH_POST_W;
PLATE_HEIGHT = RH_SILL_H;

STUD_DEPTH   = 95;
STUD_THICK   = 45;
STUD_C2C     = 600;

// Yard walls are shorter than house (RH_YARD_EH_* in config.scad) so the
// yard roof reads as a separate, lower structure.
WALL_TOP_HIGH = RH_BASE_H + RH_YARD_EH_FRONT;
WALL_TOP_LOW  = RH_BASE_H + RH_YARD_EH_BACK;
STUD_BOTTOM_Z = RH_BASE_H + DPC_T + PLATE_HEIGHT;

JAMB_BUFFER = 300;
function _jamb_bx() = STUD_THICK + JAMB_BUFFER;

// y is absolute world Y. Yard front eave at y=RH_YARD_Y_OFFSET (high),
// back eave at y=RH_YARD_Y_OFFSET+RH_YARD_DEPTH (low).
function wall_top_z(y) =
    WALL_TOP_HIGH - (WALL_TOP_HIGH - WALL_TOP_LOW)
                    * (y - RH_YARD_Y_OFFSET) / RH_YARD_DEPTH;
function stud_top_z(y) = wall_top_z(y) - PLATE_HEIGHT;

function _in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

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
                       skip_ranges=[], palette=DEFAULT_PALETTE) {
    z = STUD_BOTTOM_Z;
    end_stud_x = length - STUD_THICK;
    last_loop_x     = floor(end_stud_x / STUD_C2C) * STUD_C2C;
    last_loop_right = last_loop_x + STUD_THICK;
    emit_end_stud   = (end_stud_x - last_loop_right) >= 100;

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

// Framed yard door (axis X, flat HIGH top, no sill). Sits on V1 front wall
// at world Y=yo (= RH_YARD_Y_OFFSET). When the rough opening reaches the
// top plate (RH_YARD_DOOR_H == stud height), the top plate is the header
// — no separate header + cripple stack is rendered.
module _render_yard_door_framing(palette = DEFAULT_PALETTE) {
    yo = RH_YARD_Y_OFFSET;
    opening_pos = RH_YARD_DOOR_X;
    opening_w   = RH_YARD_DOOR_W;
    opening_z   = STUD_BOTTOM_Z;
    opening_h   = RH_YARD_DOOR_H;
    z_header_bot = opening_z + opening_h;
    z_header_top = z_header_bot + PLATE_HEIGHT;
    z_plate_bot  = WALL_TOP_HIGH - PLATE_HEIGHT;
    crip_above_h = z_plate_bot - z_header_top;

    color(pal_post(palette))
    if (z_header_bot < z_plate_bot) {
        translate([opening_pos, yo, z_header_bot])
            cube([opening_w, STUD_DEPTH, PLATE_HEIGHT]);
        if (crip_above_h > 50)
            for (cx = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                translate([opening_pos + cx - STUD_THICK/2, yo, z_header_top])
                    cube([STUD_THICK, STUD_DEPTH, crip_above_h]);
    }
}

// ============================================================================
// YARD entry — X=hl..ll segment of V1/V2 + V5. No junction stud (house owns it).
// Y range: yo..yo+yd (= 500..3000 i nuværende config).
// ============================================================================
module RenderYardFraming(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; yd = RH_YARD_DEPTH; hl = RH_HOUSE_LEN;
    yo = RH_YARD_Y_OFFSET;
    y_back = yo + yd;             // V2 outer edge in world Y
    h_high = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;
    h_low  = WALL_TOP_LOW  - STUD_BOTTOM_Z - PLATE_HEIGHT;
    bx     = _jamb_bx();
    butt_y0  = yo + STUD_DEPTH;
    butt_len = yd - 2 * STUD_DEPTH;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;

    // DPC — V1 + V2 segments [hl..ll] + V5 cross at X=ll.
    color(DPC_COLOR) {
        translate([hl, yo,            RH_BASE_H])  cube([ll - hl, DPC_W, DPC_T]);
        translate([hl, y_back - DPC_W, RH_BASE_H]) cube([ll - hl, DPC_W, DPC_T]);
        translate([ll - DPC_W, yo + DPC_W, RH_BASE_H])
            cube([DPC_W, yd - 2*DPC_W, DPC_T]);
    }

    // Sill plate.
    color(pal_post(palette)) {
        translate([hl, yo,            RH_BASE_H + DPC_T]) cube([ll - hl, sd, sw]);
        translate([hl, y_back - sd,   RH_BASE_H + DPC_T]) cube([ll - hl, sd, sw]);
        translate([ll - sd, yo + sd,  RH_BASE_H + DPC_T])
            cube([sd, yd - 2*sd, sw]);
    }

    // Top plate — V1/V2 flat segments + sloped V5 + interior cross-ribs.
    // Cross-ribs at c/c 1000 (hl, hl+1000, hl+2000, hl+3000) plus V5 give
    // the mesh lid support across the 4 m span and close the cage on the
    // partition side. Each rib sits in the wall-top plane (top flush with
    // mesh lid bottom), butted between V1 and V2 like V5.
    color(pal_post(palette)) {
        translate([hl, yo,            WALL_TOP_HIGH - sw]) cube([ll - hl, sd, sw]);
        translate([hl, y_back - sd,   WALL_TOP_LOW  - sw]) cube([ll - hl, sd, sw]);
        _sloped_top_plate(ll - sd, butt_y0, y_back - sd);
        for (xx = [hl, hl + 1000, hl + 2000, hl + 3000])
            _sloped_top_plate(xx, butt_y0, y_back - sd);
    }

    // V1[hl..ll] studs — flat HIGH. Yard door at RH_YARD_DOOR_X.
    front_skip = [[RH_YARD_DOOR_X - bx, RH_YARD_DOOR_X + RH_YARD_DOOR_W + bx]];
    _studs_one_wall([hl, yo, 0], ll - hl, "X", h_high,
                    skip_ranges=front_skip, palette=palette);

    // V2[hl..ll] studs — flat LOW.
    _studs_one_wall([hl, y_back - STUD_DEPTH, 0], ll - hl, "X", h_low,
                    palette=palette);

    // V5 — sloped Y wall, no openings.
    _studs_one_wall([ll - STUD_DEPTH, butt_y0, 0], butt_len, "Y", h_low,
                    palette=palette);

    // Yard-door jamb studs.
    color(pal_post(palette)) {
        translate([RH_YARD_DOOR_X - STUD_THICK, yo, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([RH_YARD_DOOR_X + RH_YARD_DOOR_W, yo, STUD_BOTTOM_Z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
    }

    // Horizontal mid-rail through all three mesh walls. Z aligns with the
    // yard door's internal mid-rail (leaf_z0 + RH_MID_RAIL_Z_OFFSET = 1197)
    // so the line stays continuous across V1 through the door.
    door_x0 = RH_YARD_DOOR_X;
    door_x1 = RH_YARD_DOOR_X + RH_YARD_DOOR_W;
    mid_z_center = RH_FLOOR_TOP + 30 + RH_MID_RAIL_Z_OFFSET;
    mid_h        = RH_MID_RAIL_H;
    color(pal_post(palette)) {
        translate([hl, yo, mid_z_center - mid_h/2])
            cube([door_x0 - hl, STUD_DEPTH, mid_h]);
        translate([door_x1, yo, mid_z_center - mid_h/2])
            cube([ll - door_x1, STUD_DEPTH, mid_h]);
        translate([hl, y_back - STUD_DEPTH, mid_z_center - mid_h/2])
            cube([ll - hl, STUD_DEPTH, mid_h]);
        translate([ll - STUD_DEPTH, butt_y0, mid_z_center - mid_h/2])
            cube([STUD_DEPTH, butt_len, mid_h]);
    }

    _render_yard_door_framing(palette);
}
