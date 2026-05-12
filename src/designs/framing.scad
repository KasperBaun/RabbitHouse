// Wall framing: DPC + sill plate + studs + framed openings + top plate.

include <../lib/defaults.scad>
include <config.scad>

DPC_COLOR    = [0.10, 0.10, 0.12];
DPC_T        = 2;
DPC_W        = 100;            // slightly wider than the sill plate (95)

PLATE_DEPTH  = RH_POST_W;      // 95 — wall thickness
PLATE_HEIGHT = RH_SILL_H;      // 45 — sill / top plate cross-section height

STUD_DEPTH   = 95;             // perpendicular to wall face
STUD_THICK   = 45;             // along wall length
STUD_C2C     = 600;

// V1 (front) is flat at HIGH. V2 (back) is flat at LOW. V3, V4, V5 run
// along Y parallel to the roof slope — their top plate slopes linearly from
// HIGH (y=0) to LOW (y=RH_WIDTH), and each stud is cut to a varying height
// with a sloped top so the plate rests flat on every stud (no separate
// gable infill — the wall framing IS the gable end).
WALL_TOP_HIGH = RH_BASE_H + RH_EH_FRONT;   // 2520
WALL_TOP_LOW  = RH_BASE_H + RH_EH_BACK;    // 2320
STUD_BOTTOM_Z = RH_BASE_H + DPC_T + PLATE_HEIGHT;   // 167

function wall_top_z(y) =
    WALL_TOP_HIGH - (WALL_TOP_HIGH - WALL_TOP_LOW) * y / RH_WIDTH;
function stud_top_z(y) = wall_top_z(y) - PLATE_HEIGHT;

// ----------------------------------------------------------------------------
// Sloped-top helpers for V3/V4/V5 (walls running along Y).
// Each stud is cut with a wedge top so the top plate rests flat on it.
// hull() of three thin slabs — bottom + two top edges at different Z.
// ----------------------------------------------------------------------------

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

// Sloped top-plate segment along Y from y0 to y1 at x. Bottom and top
// faces both slope at the same angle (uniform 45 mm thickness).
module _sloped_top_plate(x, y0, y1) {
    sw = PLATE_HEIGHT;
    z0 = wall_top_z(y0) - sw;
    z1 = wall_top_z(y1) - sw;
    hull() {
        translate([x, y0, z0])        cube([STUD_DEPTH, 0.01, sw]);
        translate([x, y1 - 0.01, z1]) cube([STUD_DEPTH, 0.01, sw]);
    }
}

// ----------------------------------------------------------------------------
// 1. DPC — bitumen tape on top of the sokkel ring.
// Front + back run full length. Left/right/partition BUTT against the inner
// face of front+back (no overlap — like real carpentry).
// ----------------------------------------------------------------------------

module render_dpc() {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    z = RH_BASE_H;
    butt_y0  = DPC_W;
    butt_len = ww - 2 * DPC_W;
    color(DPC_COLOR) {
        translate([0, 0, z])                  cube([ll, DPC_W, DPC_T]);
        translate([0, ww - DPC_W, z])         cube([ll, DPC_W, DPC_T]);
        translate([0, butt_y0, z])            cube([DPC_W, butt_len, DPC_T]);
        translate([ll - DPC_W, butt_y0, z])   cube([DPC_W, butt_len, DPC_T]);
        translate([hl - DPC_W/2, butt_y0, z]) cube([DPC_W, butt_len, DPC_T]);
    }
}

// ----------------------------------------------------------------------------
// 2. Sill plate — continuous 45x95 PT bottom plate around the perimeter
// plus cross-wall under the partition.
// ----------------------------------------------------------------------------

module render_sill_plate(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;
    z = RH_BASE_H + DPC_T;
    butt_y0  = sd;
    butt_len = ww - 2 * sd;
    color(pal_post(palette)) {
        translate([0, 0, z])               cube([ll, sd, sw]);
        translate([0, ww - sd, z])         cube([ll, sd, sw]);
        translate([0, butt_y0, z])         cube([sd, butt_len, sw]);
        translate([ll - sd, butt_y0, z])   cube([sd, butt_len, sw]);
        translate([hl - sd/2, butt_y0, z]) cube([sd, butt_len, sw]);
    }
}

// ----------------------------------------------------------------------------
// 3. Studs — vertical 45x95 reglar at 600 mm c/c. skip_ranges lets the grid
// skip positions where doors/windows land; jamb/header framing is handled
// separately in render_framed_openings.
// ----------------------------------------------------------------------------

function _in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// Emit studs along one wall.
//   origin       = wall's outside-bottom corner
//   length       = wall length along its axis
//   axis         = "X" (V1, V2 — flat-top, uniform stud_height) or
//                  "Y" (V3, V4, V5 — sloped top, each stud cut to fit)
//   stud_height  = uniform stud height (only for axis="X")
//   skip_ranges  = list of [lo, hi]; studs whose centre falls inside any
//                  range are omitted
module _studs_one_wall(origin, length, axis, stud_height,
                       skip_ranges=[], palette=DEFAULT_PALETTE) {
    z = STUD_BOTTOM_Z;
    end_stud_x = length - STUD_THICK;

    // Skip the end stud if it would land within ~100 mm of the last grid
    // stud's right face — otherwise we get an ugly 10 mm gap between two
    // parallel studs at the wall end (no carpenter would build that; the
    // perpendicular wall provides the corner support).
    last_loop_x     = floor(end_stud_x / STUD_C2C) * STUD_C2C;
    last_loop_right = last_loop_x + STUD_THICK;
    emit_end_stud   = (end_stud_x - last_loop_right) >= 100;

    // skip_ranges are ABSOLUTE coordinates (e.g. RH_HOUSE_DOOR_Y = 200);
    // add origin's axis-coordinate so the check works for walls whose
    // origin isn't at 0 (butted partition starting at Y=95).
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

module render_studs(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    z = STUD_BOTTOM_Z;

    h_high = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;
    h_low  = WALL_TOP_LOW  - STUD_BOTTOM_Z - PLATE_HEIGHT;

    // Extend each skip range by STUD_THICK (jamb width) + JAMB_BUFFER on
    // each side. Grid studs that would land closer than JAMB_BUFFER to a
    // jamb's outer face are dropped — pro-carpenter practice, since the
    // jamb is already structural and a grid stud 100-300 mm away would be
    // redundant.
    JAMB_BUFFER = 300;
    bx          = STUD_THICK + JAMB_BUFFER;

    front_skip     = [[RH_YARD_DOOR_X - bx, RH_YARD_DOOR_X + RH_YARD_DOOR_W + bx]];
    left_skip      = [[RH_SIDE_WIN_Y  - bx, RH_SIDE_WIN_Y  + RH_SIDE_WIN_W  + bx]];
    partition_skip = [
        [RH_HOUSE_DOOR_Y - bx, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W + bx],
        [RH_PET_DOOR_Y   - bx, RH_PET_DOOR_Y   + RH_PET_DOOR_W   + bx]
    ];

    // Front + back run full length. Left/right/partition butt against the
    // inner faces of front+back at Y=STUD_DEPTH and Y=ww-STUD_DEPTH.
    butt_y0  = STUD_DEPTH;
    butt_len = ww - 2 * STUD_DEPTH;

    _studs_one_wall([0, 0, 0],                       ll,       "X", h_high,
                    skip_ranges=front_skip,           palette=palette);
    _studs_one_wall([0, ww - STUD_DEPTH, 0],         ll,       "X", h_low,
                    palette=palette);
    _studs_one_wall([0, butt_y0, 0],                 butt_len, "Y", h_low,
                    skip_ranges=left_skip,            palette=palette);
    _studs_one_wall([ll - STUD_DEPTH, butt_y0, 0],   butt_len, "Y", h_low,
                    palette=palette);
    _studs_one_wall([hl - STUD_DEPTH/2, butt_y0, 0], butt_len, "Y", h_low,
                    skip_ranges=partition_skip,       palette=palette);

    // Jamb studs — the reglar that bind each opening's edges. The inner
    // face of the jamb is flush with the opening edge. V1 (front) is flat
    // HIGH; V3 (window wall) and V5 (partition) have sloped tops so
    // _sloped_stud_y cuts each jamb to the varying top-plate height.
    color(pal_post(palette)) {
        translate([RH_YARD_DOOR_X - STUD_THICK, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([RH_YARD_DOOR_X + RH_YARD_DOOR_W, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);

        _sloped_stud_y(0, RH_SIDE_WIN_Y - STUD_THICK);
        _sloped_stud_y(0, RH_SIDE_WIN_Y + RH_SIDE_WIN_W);

        _sloped_stud_y(hl - STUD_DEPTH/2, RH_HOUSE_DOOR_Y - STUD_THICK);
        _sloped_stud_y(hl - STUD_DEPTH/2, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W);

        _sloped_stud_y(hl - STUD_DEPTH/2, RH_PET_DOOR_Y - STUD_THICK);
        _sloped_stud_y(hl - STUD_DEPTH/2, RH_PET_DOOR_Y + RH_PET_DOOR_W);
    }

    // Junction studs — T-joint reglar where the partition meets front and
    // back walls. Without these the partition's end stud has nothing to
    // fasten to in the longitudinal wall.
    color(pal_post(palette)) {
        translate([hl - STUD_THICK/2, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([hl - STUD_THICK/2, ww - STUD_DEPTH, z])
            cube([STUD_THICK, STUD_DEPTH, h_low]);
    }
}

// ----------------------------------------------------------------------------
// 3b. Framed openings — header + cripples above + (windows only) rough sill
// + cripples below. Header is a 45x95 reglar laid flat above the opening
// (carrying the load from above). Cripples are short studs filling the
// vertical gap. Rough sill is the horizontal 45x95 the window frame sits on.
// ----------------------------------------------------------------------------

module _cripple(p, axis, height, palette) {
    color(pal_post(palette))
    translate(p)
    if (axis == "X")
        cube([STUD_THICK, STUD_DEPTH, height]);
    else
        cube([STUD_DEPTH, STUD_THICK, height]);
}

// One opening's framing.
//   wall_top   = fixed top z (only used for axis="X" — V1 flat HIGH)
//   sloped     = true for axis="Y" walls V3/V4/V5 (cripples above use
//                stud_top_z per-cripple; wall_top is then ignored)
module render_framed_opening(wall_origin, axis,
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

module render_framed_openings(palette = DEFAULT_PALETTE) {
    hl = RH_HOUSE_LEN; ww = RH_WIDTH; ll = RH_LENGTH;

    // Yard door — front wall (axis X), no sill, flat HIGH
    render_framed_opening(wall_origin = [0, 0, 0], axis = "X",
                          opening_pos = RH_YARD_DOOR_X, opening_w = RH_YARD_DOOR_W,
                          opening_z = STUD_BOTTOM_Z, opening_h = RH_YARD_DOOR_H,
                          has_sill = false, wall_top = WALL_TOP_HIGH,
                          palette = palette);

    // Side window — left wall V3 (axis Y, sloped top), has sill
    render_framed_opening(wall_origin = [0, 0, 0], axis = "Y",
                          opening_pos = RH_SIDE_WIN_Y, opening_w = RH_SIDE_WIN_W,
                          opening_z = STUD_BOTTOM_Z + RH_SIDE_WIN_Z,
                          opening_h = RH_SIDE_WIN_H,
                          has_sill = true, wall_top = WALL_TOP_LOW,
                          sloped = true, palette = palette);

    // Human door — partition V5 (axis Y, sloped top), no sill
    render_framed_opening(wall_origin = [hl - STUD_DEPTH/2, 0, 0], axis = "Y",
                          opening_pos = RH_HOUSE_DOOR_Y, opening_w = RH_HOUSE_DOOR_W,
                          opening_z = STUD_BOTTOM_Z, opening_h = RH_HOUSE_DOOR_H,
                          has_sill = false, wall_top = WALL_TOP_LOW,
                          sloped = true, palette = palette);

    // Pet door — partition V5 (axis Y, sloped top), no sill. Opening
    // starts 60 mm above floor so the rabbit doesn't step down into the
    // threshold during transit; the sill plate covers the floor-to-opening
    // gap.
    render_framed_opening(wall_origin = [hl - STUD_DEPTH/2, 0, 0], axis = "Y",
                          opening_pos = RH_PET_DOOR_Y, opening_w = RH_PET_DOOR_W,
                          opening_z = RH_FLOOR_TOP + 60, opening_h = RH_PET_DOOR_H,
                          has_sill = false, wall_top = WALL_TOP_LOW,
                          sloped = true, palette = palette);
}

// ----------------------------------------------------------------------------
// 4. Top plate — 45x95 on top of studs. V1 (front) flat HIGH, V2 (back)
// flat LOW. V3, V4, V5 slope along Y from HIGH (y=0) to LOW (y=ww),
// matching the roof underside above (no separate gable infill).
//
// V1 and V2 top plates stop at the building line (X=0..ll). The side-
// overhang's barge rafters are carried by lookouts (45x95 cantilevers) in
// roof_structure.scad:render_lookouts — these reach from V3/V4 gable
// rafters out to the barge rafter.
// ----------------------------------------------------------------------------

module render_top_plate(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;
    z_high_bot = WALL_TOP_HIGH - sw;
    z_low_bot  = WALL_TOP_LOW  - sw;
    butt_y0 = sd;
    butt_y1 = ww - sd;
    color(pal_post(palette)) {
        translate([0, 0, z_high_bot])      cube([ll, sd, sw]);
        translate([0, ww - sd, z_low_bot]) cube([ll, sd, sw]);
        _sloped_top_plate(0,         butt_y0, butt_y1);
        _sloped_top_plate(ll - sd,   butt_y0, butt_y1);
        _sloped_top_plate(hl - sd/2, butt_y0, butt_y1);
    }
}

// ----------------------------------------------------------------------------
// Entry point — composes the framing elements.
// ----------------------------------------------------------------------------

module RenderFraming(palette = DEFAULT_PALETTE) {
    render_dpc();
    render_sill_plate(palette);
    render_studs(palette);
    render_framed_openings(palette);
    render_top_plate(palette);
}
