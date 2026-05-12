// Klink (lap-board) cladding variant.
//
// Layer stack stepping outward from the stud face:
//   1. housewrap         (RH_HOUSEWRAP_T = 1 mm)
//   2. counter-batten    (RH_COUNTER_BATTEN_T = 22 mm) — 22x45 VERTICAL, c/c 600
//   3. klink             (cs_thick(clad) — typically 25 mm)
// Total stickout = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + cs_thick(clad).

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/cladding.scad>
use <cladding_common.scad>

// ---------------------------------------------------------------------------
// Klink cladding on the 4 house walls. The partition is clad on its YARD
// side only.
// ---------------------------------------------------------------------------
module render_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad) {
    s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    part_outer_x = hl + RH_POST_W/2;

    // Front (Y=0). axis="X", thickness +Y. Klink occupies Y = -(s+ct)..-s.
    clad_wall_rect([0, -(s + ct), bh], hl, ehf, "X", pal, clad);

    // Back (Y=ww). axis="X", thickness +Y. Klink occupies Y = ww+s..ww+s+ct.
    clad_wall_rect([0, ww + s, bh], hl, ehb, "X", pal, clad);

    // Left exterior (X=0, side-window cutout). axis="Y", thickness +X.
    clad_wall_mono_pitch_with_cutout([-(s + ct), 0, bh], ww, ehf, ehb, "Y",
        pal, clad,
        [RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W,
         RH_SIDE_WIN_Z, RH_SIDE_WIN_Z + RH_SIDE_WIN_H]);

    // Partition yard-side. V5 butts between V1+V2 inner faces so klink stays
    // inside the butted range; heights matched to wall_top_z at butted ends.
    klink_in    = part_outer_x + s;
    butt_y0     = RH_POST_W;
    butt_len    = ww - 2 * RH_POST_W;
    v5_h_high   = wall_height_at(butt_y0);
    v5_h_low    = wall_height_at(butt_y0 + butt_len);
    difference() {
        clad_wall_mono_pitch([klink_in, butt_y0, bh], butt_len,
                             v5_h_high, v5_h_low, "Y", pal, clad);
        translate([klink_in - 10, RH_PET_DOOR_Y, RH_FLOOR_TOP + 15])
            cube([ct + 20, RH_PET_DOOR_W, RH_PET_DOOR_H]);
        translate([klink_in - 10, RH_HOUSE_DOOR_Y, RH_FLOOR_TOP])
            cube([ct + 20, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
    }
}

// External 45x45 corner trim posts at the four house cladding corners,
// covering the raw klink board end-grain.
module render_corner_trims(hl, ww, ehf, ehb, bh, ct, pal) {
    tw = 45;
    s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    o = s + ct;
    color(pal_trim(pal)) {
        translate([-o,           -o,           bh]) cube([tw, tw, ehf]);
        translate([hl + o - tw,  -o,           bh]) cube([tw, tw, ehf]);
        translate([-o,           ww + o - tw,  bh]) cube([tw, tw, ehb]);
        translate([hl + o - tw,  ww + o - tw,  bh]) cube([tw, tw, ehb]);
    }
}

// ---------------------------------------------------------------------------
// Vertical counter-battens — 22x45 set between housewrap and klink.
// c/c (centre-to-centre) along the wall axis (default 600 mm).
// h_far = height of the last batten; intermediates interpolate linearly.
// skip_ranges = absolute coords along the wall axis; battens whose centre
//         falls in any range are omitted (used for openings).
// ---------------------------------------------------------------------------
module render_counter_battens(origin, length, height, axis, c2c=600,
                              h_far=undef, skip_ranges=[]) {
    n = floor(length / c2c) + 1;
    h_end = is_undef(h_far) ? height : h_far;
    color([0.78, 0.65, 0.45])
    for (i = [0 : n-1]) {
        center = (axis == "X" ? origin[0] : origin[1]) + i*c2c + 22.5;
        if (!in_any_skip(center, skip_ranges)) {
            far_edge = i * c2c + 45;
            h_i = (length > 0)
                ? height + (h_end - height) * far_edge / length
                : height;
            if (axis == "X")
                translate([origin[0] + i*c2c, origin[1], origin[2]])
                    cube([45, RH_COUNTER_BATTEN_T, h_i]);
            else
                translate([origin[0], origin[1] + i*c2c, origin[2]])
                    cube([RH_COUNTER_BATTEN_T, 45, h_i]);
        }
    }
}

// ---------------------------------------------------------------------------
// Entry point — housewrap + klink + corner trim + counter-battens.
// ---------------------------------------------------------------------------
module render_cladding_klink(clad = RH_CLAD, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H;
    hl = RH_HOUSE_LEN;
    ehf = RH_EH_FRONT; ehb = RH_EH_BACK;
    ct = cs_thick(clad);
    s  = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;

    PLATE_H = RH_SILL_H;
    cap_h_front = ehf - PLATE_H;
    cap_h_back  = ehb - PLATE_H;

    z_sill = RH_BASE_H;
    part_outer_x = hl + RH_POST_W/2;

    // V5 partition butts between V1+V2 inner faces so all layers stay inside
    // the butted Y range.
    butt_y0  = RH_POST_W;
    butt_len = RH_WIDTH - 2 * RH_POST_W;
    v5_h_high_battens = wall_height_at(butt_y0);
    v5_h_low_battens  = wall_height_at(butt_y0 + butt_len);

    // Housewrap on each wall. Sloped walls use cap_h_back (LOW) so the
    // membrane never pokes above the top plate at the LOW end.
    render_housewrap([0, -RH_HOUSEWRAP_T, z_sill], hl, cap_h_front, "X");
    render_housewrap([0, ww,              z_sill], hl, cap_h_back,  "X");

    // V3 left wall: sloped top + side-window cutout.
    difference() {
        render_housewrap_sloped([-RH_HOUSEWRAP_T, 0, z_sill], ww,
                                cap_h_front, cap_h_back, "Y");
        translate([-RH_HOUSEWRAP_T - 1, RH_SIDE_WIN_Y, RH_FLOOR_TOP + RH_SIDE_WIN_Z])
            cube([RH_HOUSEWRAP_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }

    // V5 partition: butted Y-extent + sloped top + door cutouts.
    v5_cap_h_high = wall_height_at(butt_y0) - PLATE_H;
    v5_cap_h_low  = wall_height_at(butt_y0 + butt_len) - PLATE_H;
    difference() {
        render_housewrap_sloped([part_outer_x, butt_y0, z_sill], butt_len,
                                v5_cap_h_high, v5_cap_h_low, "Y");
        translate([part_outer_x - 1, RH_HOUSE_DOOR_Y, RH_FLOOR_TOP])
            cube([RH_HOUSEWRAP_T + 2, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_outer_x - 1, RH_PET_DOOR_Y, RH_FLOOR_TOP + 15])
            cube([RH_HOUSEWRAP_T + 2, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    render_house_cladding(hl, ww, ehf, ehb, bh, ct, palette, clad);
    render_corner_trims(hl, ww, ehf, ehb, bh, ct, palette);

    render_counter_battens([0, -s, bh], hl, ehf, "X");
    render_counter_battens([0, ww + RH_HOUSEWRAP_T, bh], hl, ehb, "X");
    render_counter_battens([-s, 0, bh], ww, ehf, "Y", 600, ehb,
                           skip_ranges = [[RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W]]);
    render_counter_battens([part_outer_x + RH_HOUSEWRAP_T, butt_y0, bh],
                           butt_len, v5_h_high_battens, "Y", 600,
                           v5_h_low_battens,
                           skip_ranges = [
                               [RH_HOUSE_DOOR_Y, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W],
                               [RH_PET_DOOR_Y,   RH_PET_DOOR_Y   + RH_PET_DOOR_W]
                           ]);
}
