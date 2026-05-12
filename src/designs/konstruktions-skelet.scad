// konstruktions-skelet.scad — Wall skeleton: dpc + sill plate + studs + top plate.
// Part of the v3 build pipeline; included from build.scad.

include <../lib/defaults.scad>
include <config.scad>

// === Material constants ===
DPC_COLOR    = [0.10, 0.10, 0.12];
DPC_T        = 2;          // mm — bitumen tape thickness
DPC_W        = 100;        // mm — slightly wider than the sill plate (95)

PLATE_DEPTH  = RH_POST_W;  // 95 — wall thickness (depth of sill + top plate)
PLATE_HEIGHT = RH_SILL_H;  // 45 — sill / top plate cross-section height

STUD_DEPTH   = 95;         // perpendicular to wall face
STUD_THICK   = 45;         // along wall length
STUD_C2C     = 600;        // standard centre-to-centre spacing

// === Wall top heights ===
// V1 (front) is flat at HIGH. V2 (back) is flat at LOW. V3, V4, V5 run
// along Y parallel to the roof slope — their toprem slopes linearly from
// HIGH (y=0) to LOW (y=RH_WIDTH), and each stud is cut to a varying
// height with a sloped top so the toprem rests flat on every stud (no
// separate gable infill — the wall framing IS the gable end).
WALL_TOP_HIGH = RH_BASE_H + RH_EH_FRONT;   // 120 + 2400 = 2520
WALL_TOP_LOW  = RH_BASE_H + RH_EH_BACK;    // 120 + 2200 = 2320

// Z of the bottom of the studs (= top of sill plate, which sits on top of DPC).
STUD_BOTTOM_Z = RH_BASE_H + DPC_T + PLATE_HEIGHT;   // 167

// Top of the (sloped) toprem at any y on V3/V4/V5 walls — linear between
// HIGH (y=0) and LOW (y=RH_WIDTH).
function rh_wall_top_z(y) =
    WALL_TOP_HIGH - (WALL_TOP_HIGH - WALL_TOP_LOW) * y / RH_WIDTH;

// Top of stud (= bottom of toprem) at y.
function rh_stud_top_z(y) = rh_wall_top_z(y) - PLATE_HEIGHT;

// === Sloped-top helpers for V3/V4/V5 (walls running along Y) ===
// Each stud is cut with a 4.6° wedge top so the toprem rests flat on it.
// hull() of three thin slabs — bottom slab + two top edges at different Z —
// follows the existing convention (see lib/primitives/framing.scad).

module _rh_sloped_stud_y(x, y) {
    z_top_front = rh_stud_top_z(y);
    z_top_back  = rh_stud_top_z(y + STUD_THICK);
    hull() {
        translate([x, y, STUD_BOTTOM_Z])
            cube([STUD_DEPTH, STUD_THICK, 0.1]);
        translate([x, y, z_top_front - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
        translate([x, y + STUD_THICK - 0.1, z_top_back - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
    }
}

// One sloped cripple (above a header) along Y. Starts at z_bot, top
// follows the toprem just like a regular stud.
module _rh_sloped_cripple_y(x, y, z_bot) {
    z_top_front = rh_stud_top_z(y);
    z_top_back  = rh_stud_top_z(y + STUD_THICK);
    hull() {
        translate([x, y, z_bot])
            cube([STUD_DEPTH, STUD_THICK, 0.1]);
        translate([x, y, z_top_front - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
        translate([x, y + STUD_THICK - 0.1, z_top_back - 0.1])
            cube([STUD_DEPTH, 0.1, 0.1]);
    }
}

// Sloped toprem segment running along Y from y0 to y1 at x. Bottom and
// top faces both slope at the same angle (uniform 45 mm thickness).
module _rh_sloped_toprem(x, y0, y1) {
    sw = PLATE_HEIGHT;
    z0 = rh_wall_top_z(y0) - sw;
    z1 = rh_wall_top_z(y1) - sw;
    hull() {
        translate([x, y0, z0])           cube([STUD_DEPTH, 0.01, sw]);
        translate([x, y1 - 0.01, z1])    cube([STUD_DEPTH, 0.01, sw]);
    }
}

// ----------------------------------------------------------------------------
// 1. DPC — bitumen tape on top of the sokkel ring.
// Front + back run full length. Left/right/partition BUTT against the inner
// face of front+back (no overlap — like real carpentry).
// ----------------------------------------------------------------------------

module rh_dpc() {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    z = RH_BASE_H;
    butt_y0 = DPC_W;            // = 100, inner face of front DPC
    butt_len = ww - 2 * DPC_W;  // = 2300
    color(DPC_COLOR) {
        translate([0, 0, z])              cube([ll, DPC_W, DPC_T]);  // front (full)
        translate([0, ww - DPC_W, z])     cube([ll, DPC_W, DPC_T]);  // back (full)
        translate([0, butt_y0, z])        cube([DPC_W, butt_len, DPC_T]);  // left (butted)
        translate([ll - DPC_W, butt_y0, z]) cube([DPC_W, butt_len, DPC_T]);  // right (butted)
        translate([hl - DPC_W/2, butt_y0, z]) cube([DPC_W, butt_len, DPC_T]);  // partition (butted)
    }
}

// ----------------------------------------------------------------------------
// 2. Sill plate — continuous 45×95 PT bottom plate, all the way around
//    the perimeter + cross-wall under the partition.
// ----------------------------------------------------------------------------

module rh_sill_plate(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;
    z = RH_BASE_H + DPC_T;   // 122 — sits on top of DPC
    butt_y0 = sd;            // = 95, inner face of front sill plate
    butt_len = ww - 2 * sd;  // = 2310
    color(pal_post(palette)) {
        translate([0, 0, z])              cube([ll, sd, sw]);          // front (full)
        translate([0, ww - sd, z])        cube([ll, sd, sw]);          // back (full)
        translate([0, butt_y0, z])        cube([sd, butt_len, sw]);    // left (butted)
        translate([ll - sd, butt_y0, z])  cube([sd, butt_len, sw]);    // right (butted)
        translate([hl - sd/2, butt_y0, z]) cube([sd, butt_len, sw]);   // partition (butted)
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
//   origin       = wall's outside-bottom corner
//   length       = wall length along its axis
//   axis         = "X" (V1, V2 — flat-top, uniform stud_height) or
//                  "Y" (V3, V4, V5 — sloped top, each stud cut to fit)
//   stud_height  = uniform stud height (only used for axis="X")
//   skip_ranges  = list of [lo, hi] along the wall — studs whose centre
//                  falls inside any range are omitted
module _rh_studs_one_wall(origin, length, axis, stud_height,
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

    // Skip ranges are in ABSOLUTE coordinates (e.g., RH_HOUSE_DOOR_Y = 200);
    // we add origin's axis-coordinate so the check works for walls whose
    // origin isn't at 0 (e.g., butted partition starting at Y=95).
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
        // axis "Y" — sloped-top studs cut to varying heights along Y.
        for (y = [0 : STUD_C2C : end_stud_x])
            if (!_in_any_skip(origin[1] + y + STUD_THICK/2, skip_ranges))
                _rh_sloped_stud_y(origin[0], origin[1] + y);
        if (emit_end_stud)
            _rh_sloped_stud_y(origin[0], origin[1] + end_stud_x);
    }
}

module rh_studs(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    z = STUD_BOTTOM_Z;

    // Stud heights — top plate sits ABOVE the stud, so subtract PLATE_HEIGHT.
    h_high = WALL_TOP_HIGH - STUD_BOTTOM_Z - PLATE_HEIGHT;
    h_low  = WALL_TOP_LOW  - STUD_BOTTOM_Z - PLATE_HEIGHT;

    // Skip ranges udvides med STUD_THICK (= jamb-bredde) + JAMB_BUFFER på hver
    // side af åbningen. Det betyder at grid-stolper der ville lande tættere
    // end JAMB_BUFFER på en jamb's yderkant droppes — pro-tømrer-praksis,
    // da jamb'en allerede er strukturel og en grid-stolpe 100-300mm fra den
    // bare ville være redundant tømmer.
    JAMB_BUFFER = 300;
    bx          = STUD_THICK + JAMB_BUFFER;   // = 345

    front_skip     = [[RH_YARD_DOOR_X - bx, RH_YARD_DOOR_X + RH_YARD_DOOR_W + bx]];
    left_skip      = [[RH_SIDE_WIN_Y  - bx, RH_SIDE_WIN_Y  + RH_SIDE_WIN_W  + bx]];
    partition_skip = [
        [RH_HOUSE_DOOR_Y - bx, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W + bx],
        [RH_PET_DOOR_Y   - bx, RH_PET_DOOR_Y   + RH_PET_DOOR_W   + bx]
    ];

    // --- Regular grid studs (c/c 600) ---
    // Front + back run full length. Left/right/partition BUTT against the
    // inner faces of front+back at Y=STUD_DEPTH (= 95) and Y=ww-STUD_DEPTH.
    butt_y0  = STUD_DEPTH;            // 95
    butt_len = ww - 2 * STUD_DEPTH;   // 2310

    _rh_studs_one_wall([0, 0, 0],                       ll, "X", h_high,
                       skip_ranges=front_skip,           palette=palette);  // front
    _rh_studs_one_wall([0, ww - STUD_DEPTH, 0],         ll, "X", h_low,
                       palette=palette);                                     // back
    _rh_studs_one_wall([0, butt_y0, 0],                 butt_len, "Y", h_low,
                       skip_ranges=left_skip,            palette=palette);  // left (butted)
    _rh_studs_one_wall([ll - STUD_DEPTH, butt_y0, 0],   butt_len, "Y", h_low,
                       palette=palette);                                     // right (butted)
    _rh_studs_one_wall([hl - STUD_DEPTH/2, butt_y0, 0], butt_len, "Y", h_low,
                       skip_ranges=partition_skip,       palette=palette);  // partition (butted)

    // --- Jamb studs (= reglar der binder hver opnings kanter) ---
    // Indersiden af jamb-stud flugter med åbningens kant. V1 (front) er flat
    // HIGH; V3 (window-væg) og V5 (partition) har skrå topper og kalder
    // _rh_sloped_stud_y der skærer hver jamb til den varierende toprem-højde.
    color(pal_post(palette)) {
        // Front wall (V1) — yard door (flat HIGH)
        translate([RH_YARD_DOOR_X - STUD_THICK, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);
        translate([RH_YARD_DOOR_X + RH_YARD_DOOR_W, 0, z])
            cube([STUD_THICK, STUD_DEPTH, h_high]);

        // Left wall (V3) — side window (sloped top)
        _rh_sloped_stud_y(0, RH_SIDE_WIN_Y - STUD_THICK);
        _rh_sloped_stud_y(0, RH_SIDE_WIN_Y + RH_SIDE_WIN_W);

        // Partition wall (V5) — human door (sloped top)
        _rh_sloped_stud_y(hl - STUD_DEPTH/2, RH_HOUSE_DOOR_Y - STUD_THICK);
        _rh_sloped_stud_y(hl - STUD_DEPTH/2, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W);

        // Partition wall (V5) — pet door (sloped top)
        _rh_sloped_stud_y(hl - STUD_DEPTH/2, RH_PET_DOOR_Y - STUD_THICK);
        _rh_sloped_stud_y(hl - STUD_DEPTH/2, RH_PET_DOOR_Y + RH_PET_DOOR_W);
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
// 3b. Framed openings — header + cripples above + (windows only) rough sill
//     + cripples below. Header is a 45×95 reglar laid flat above the opening
//     (carrying the load from above). Cripples are short studs filling the
//     vertical gap. Rough sill is the horizontal 45×95 the window frame sits on.
// ----------------------------------------------------------------------------

module _rh_cripple(p, axis, height, palette) {
    color(pal_post(palette))
    translate(p)
    if (axis == "X")
        cube([STUD_THICK, STUD_DEPTH, height]);
    else
        cube([STUD_DEPTH, STUD_THICK, height]);
}

// One opening's framing: header above + cripples above + (optional) rough
// sill below + cripples below.
//   wall_top   = fixed top z (used for axis="X" — V1 flat HIGH)
//   sloped     = true for axis="Y" walls V3/V4/V5 (cripples above use
//                rh_stud_top_z per-cripple; wall_top is then ignored)
module rh_framed_opening(wall_origin, axis,
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
        // Header — 45×95 flat (95 wide along Y wall depth, 45 tall, opening_w along X)
        translate([wall_origin[0] + opening_pos, wall_origin[1], z_header_bot])
            cube([opening_w, STUD_DEPTH, PLATE_HEIGHT]);
        // Cripples above header at ~600 mm c/c
        if (crip_above_h > 50)
            for (cx = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                translate([wall_origin[0] + opening_pos + cx - STUD_THICK/2,
                           wall_origin[1], z_header_top])
                    cube([STUD_THICK, STUD_DEPTH, crip_above_h]);
        if (has_sill) {
            // Rough sill below opening
            translate([wall_origin[0] + opening_pos, wall_origin[1], z_sill_bot])
                cube([opening_w, STUD_DEPTH, PLATE_HEIGHT]);
            // Cripples below sill
            if (crip_below_h > 50)
                for (cx = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2])
                    translate([wall_origin[0] + opening_pos + cx - STUD_THICK/2,
                               wall_origin[1], STUD_BOTTOM_Z])
                        cube([STUD_THICK, STUD_DEPTH, crip_below_h]);
        }
    } else {
        // axis "Y" — header stays flat at door height; cripples above
        // follow the sloped toprem (sloped=true) or are uniform (sloped=false).
        translate([wall_origin[0], wall_origin[1] + opening_pos, z_header_bot])
            cube([STUD_DEPTH, opening_w, PLATE_HEIGHT]);
        if (sloped) {
            for (cy = [STUD_C2C/2 : STUD_C2C : opening_w - STUD_THICK/2]) {
                cy_abs = wall_origin[1] + opening_pos + cy - STUD_THICK/2;
                if (rh_stud_top_z(cy_abs + STUD_THICK/2) - z_header_top > 50)
                    _rh_sloped_cripple_y(wall_origin[0], cy_abs, z_header_top);
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

module rh_framed_openings(palette = DEFAULT_PALETTE) {
    hl = RH_HOUSE_LEN; ww = RH_WIDTH; ll = RH_LENGTH;

    // Yard door — front wall (axis X), no sill, full HIGH wall
    rh_framed_opening(wall_origin = [0, 0, 0], axis = "X",
                      opening_pos = RH_YARD_DOOR_X, opening_w = RH_YARD_DOOR_W,
                      opening_z = STUD_BOTTOM_Z, opening_h = RH_YARD_DOOR_H,
                      has_sill = false, wall_top = WALL_TOP_HIGH,
                      palette = palette);

    // Side window — left wall V3 (axis Y, sloped top), HAS sill
    rh_framed_opening(wall_origin = [0, 0, 0], axis = "Y",
                      opening_pos = RH_SIDE_WIN_Y, opening_w = RH_SIDE_WIN_W,
                      opening_z = STUD_BOTTOM_Z + RH_SIDE_WIN_Z,
                      opening_h = RH_SIDE_WIN_H,
                      has_sill = true, wall_top = WALL_TOP_LOW,
                      sloped = true, palette = palette);

    // Human door — partition V5 (axis Y, sloped top), no sill
    rh_framed_opening(wall_origin = [hl - STUD_DEPTH/2, 0, 0], axis = "Y",
                      opening_pos = RH_HOUSE_DOOR_Y, opening_w = RH_HOUSE_DOOR_W,
                      opening_z = STUD_BOTTOM_Z, opening_h = RH_HOUSE_DOOR_H,
                      has_sill = false, wall_top = WALL_TOP_LOW,
                      sloped = true, palette = palette);

    // Pet door — partition V5 (axis Y, sloped top), no sill. Opening starts
    // 60 mm above floor so kaninen ikke træder ned i bundkarmen ved
    // gennemgangen; bundrem dækker selve gulv-til-opening-bund-spalten.
    rh_framed_opening(wall_origin = [hl - STUD_DEPTH/2, 0, 0], axis = "Y",
                      opening_pos = RH_PET_DOOR_Y, opening_w = RH_PET_DOOR_W,
                      opening_z = RH_FLOOR_TOP + 60, opening_h = RH_PET_DOOR_H,
                      has_sill = false, wall_top = WALL_TOP_LOW,
                      sloped = true, palette = palette);
}

// ----------------------------------------------------------------------------
// 4. Top plate — 45×95 on top of studs. V1 (front) flat HIGH, V2 (back)
//    flat LOW. V3, V4, V5 slope along Y from HIGH (y=0) to LOW (y=ww),
//    matching the roof underside above (no separate gable infill).
// ----------------------------------------------------------------------------

module rh_top_plate(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    sd = PLATE_DEPTH; sw = PLATE_HEIGHT;
    z_high_bot = WALL_TOP_HIGH - sw;
    z_low_bot  = WALL_TOP_LOW  - sw;
    butt_y0 = sd;
    butt_y1 = ww - sd;
    // V1 og V2 toprem stopper ved byggelinjen (X=0..ll). Side-overhangets
    // barge-raftre bæres af lookouts (45×95 udlobere) defineret i
    // tagkonstruktion_faelles.scad:rh_lookouts — kantilevrer fra V3/V4-gable-spær
    // og bagvedliggende andenrad-spær ud til barge-spæret.
    color(pal_post(palette)) {
        // V1 — front, flat HIGH
        translate([0, 0, z_high_bot])      cube([ll, sd, sw]);
        // V2 — back, flat LOW
        translate([0, ww - sd, z_low_bot]) cube([ll, sd, sw]);
        // V3 — left, sloped, butted (urørt — sidder mellem V1+V2 indersider)
        _rh_sloped_toprem(0,                butt_y0, butt_y1);
        // V4 — right, sloped, butted (urørt)
        _rh_sloped_toprem(ll - sd,          butt_y0, butt_y1);
        // V5 — partition, sloped, butted
        _rh_sloped_toprem(hl - sd/2,        butt_y0, butt_y1);
    }
}

// ----------------------------------------------------------------------------
// Wrapper — composes the 4 skeleton elements.
// ----------------------------------------------------------------------------

module rh_konstruktions_skelet(palette = DEFAULT_PALETTE) {
    rh_dpc();
    rh_sill_plate(palette);
    rh_studs(palette);
    rh_framed_openings(palette);
    rh_top_plate(palette);
}
