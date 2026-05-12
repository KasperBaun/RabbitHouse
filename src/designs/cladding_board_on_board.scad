// Board-on-board (1-på-2) cladding variant.
//
// Layer stack stepping outward from the stud face:
//   1. housewrap          (RH_HOUSEWRAP_T = 1 mm)
//   2. counter-batten     (RH_COUNTER_BATTEN_T = 22 mm) — 22x45 HORIZONTAL,
//                          c/c 600 vertically (lægterne kører vandret fordi
//                          boards are vertical)
//   3. board-on-board     (2 * bs_board_t(bob) — 50 mm with 25 mm boards)
// Total stickout = 1 + 22 + 50 = 73 mm. Corner trims sized at 70x70 to
// cover the cladding end-grain (klink uses 45x45 because stickout is only
// ~48 mm; bob needs more).

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/cladding.scad>
use <cladding_common.scad>

// ---------------------------------------------------------------------------
// Bob cladding on the 4 house walls. Same wall layout as klink but the
// primitive is clad_wall_bob_*; thickness = 2 * board_t.
// ---------------------------------------------------------------------------
module render_house_cladding_bob(hl, ww, ehf, ehb, bh, ct2, pal, bob) {
    s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    part_outer_x = hl + RH_POST_W/2;

    // Front (Y=0)
    clad_wall_bob_rect([0, -(s + ct2), bh], hl, ehf, "X", pal, bob);

    // Back (Y=ww)
    clad_wall_bob_rect([0, ww + s, bh], hl, ehb, "X", pal, bob);

    // Left exterior (X=0) with side-window cutout
    clad_wall_bob_mono_pitch_with_cutout(
        [-(s + ct2), 0, bh], ww, ehf, ehb, "Y", pal, bob,
        [RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W,
         RH_SIDE_WIN_Z, RH_SIDE_WIN_Z + RH_SIDE_WIN_H]);

    // Partition yard-side. Butted Y-extent, sloped top, door cutouts.
    bob_in   = part_outer_x + s;
    butt_y0  = RH_POST_W;
    butt_len = ww - 2 * RH_POST_W;
    v5_h_high = wall_height_at(butt_y0);
    v5_h_low  = wall_height_at(butt_y0 + butt_len);
    difference() {
        clad_wall_bob_mono_pitch([bob_in, butt_y0, bh], butt_len,
                                 v5_h_high, v5_h_low, "Y", pal, bob);
        translate([bob_in - 10, RH_PET_DOOR_Y, RH_FLOOR_TOP + 15])
            cube([ct2 + 20, RH_PET_DOOR_W, RH_PET_DOOR_H]);
        translate([bob_in - 10, RH_HOUSE_DOOR_Y, RH_FLOOR_TOP])
            cube([ct2 + 20, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
    }
}

// External 70x70 corner trim posts at the four house cladding corners. Bigger
// than klink's 45x45 because bob's total stickout is roughly 2x.
module render_corner_trims_bob(hl, ww, ehf, ehb, bh, ct2, pal) {
    tw = 70;
    s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    o = s + ct2;
    color(pal_trim(pal)) {
        translate([-o,           -o,           bh]) cube([tw, tw, ehf]);
        translate([hl + o - tw,  -o,           bh]) cube([tw, tw, ehf]);
        translate([-o,           ww + o - tw,  bh]) cube([tw, tw, ehb]);
        translate([hl + o - tw,  ww + o - tw,  bh]) cube([tw, tw, ehb]);
    }
}

// ---------------------------------------------------------------------------
// Horizontal counter-battens — 22x45 run ALONG the wall axis, stacked
// vertically at c/c 600. For sloped walls we stop at h_low to keep all
// battens below the slope (above that, boards are nailed straight into
// studs through housewrap, which is acceptable for ~200 mm of triangle).
// skip_zs = absolute Z-ranges that cut a batten out entirely (e.g. doors
//           and windows).
// ---------------------------------------------------------------------------
module render_counter_battens_horizontal(origin, length, height, axis,
                                         c2c=600, h_far=undef,
                                         skip_zs=[]) {
    h_end = is_undef(h_far) ? height : h_far;
    h_safe = min(height, h_end);
    n = max(1, floor((h_safe - 45) / c2c) + 1);
    color([0.78, 0.65, 0.45])
    for (i = [0 : n - 1]) {
        z0 = origin[2] + i * c2c;
        zc = z0 + 22.5;
        if (!in_any_skip(zc, skip_zs)) {
            if (axis == "X")
                translate([origin[0], origin[1], z0])
                    cube([length, RH_COUNTER_BATTEN_T, 45]);
            else
                translate([origin[0], origin[1], z0])
                    cube([RH_COUNTER_BATTEN_T, length, 45]);
        }
    }
}

// ---------------------------------------------------------------------------
// Entry point — housewrap + bob boards + corner trim + horizontal battens.
// ---------------------------------------------------------------------------
module render_cladding_board_on_board(bob = RH_CLAD_BOB,
                                       palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H;
    hl = RH_HOUSE_LEN;
    ehf = RH_EH_FRONT; ehb = RH_EH_BACK;
    ct2 = bs_stickout(bob);              // 2 * board_t
    s   = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;

    PLATE_H = RH_SILL_H;
    cap_h_front = ehf - PLATE_H;
    cap_h_back  = ehb - PLATE_H;

    z_sill = RH_BASE_H;
    part_outer_x = hl + RH_POST_W/2;

    butt_y0  = RH_POST_W;
    butt_len = RH_WIDTH - 2 * RH_POST_W;
    v5_h_high_battens = wall_height_at(butt_y0);
    v5_h_low_battens  = wall_height_at(butt_y0 + butt_len);

    // Housewrap — identical to klink (membrane doesn't care about cladding
    // type).
    render_housewrap([0, -RH_HOUSEWRAP_T, z_sill], hl, cap_h_front, "X");
    render_housewrap([0, ww,              z_sill], hl, cap_h_back,  "X");

    difference() {
        render_housewrap_sloped([-RH_HOUSEWRAP_T, 0, z_sill], ww,
                                cap_h_front, cap_h_back, "Y");
        translate([-RH_HOUSEWRAP_T - 1, RH_SIDE_WIN_Y, RH_FLOOR_TOP + RH_SIDE_WIN_Z])
            cube([RH_HOUSEWRAP_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }

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

    render_house_cladding_bob(hl, ww, ehf, ehb, bh, ct2, palette, bob);
    render_corner_trims_bob(hl, ww, ehf, ehb, bh, ct2, palette);

    // Horizontal counter-battens behind the bob boards. Skip-Z-ranges
    // remove battens that fall inside a door or window.
    win_zlo = RH_FLOOR_TOP + RH_SIDE_WIN_Z;
    win_zhi = win_zlo + RH_SIDE_WIN_H;
    house_zhi = RH_FLOOR_TOP + RH_HOUSE_DOOR_H;
    pet_zlo = RH_FLOOR_TOP + 15;
    pet_zhi = pet_zlo + RH_PET_DOOR_H;

    // Front (Y=0)
    render_counter_battens_horizontal([0, -s, bh], hl, ehf, "X");
    // Back (Y=ww)
    render_counter_battens_horizontal([0, ww + RH_HOUSEWRAP_T, bh],
                                       hl, ehb, "X");
    // Left (X=0) — skip the side-window Z band
    render_counter_battens_horizontal([-s, 0, bh], ww, ehf, "Y", 600, ehb,
                                       skip_zs = [[win_zlo, win_zhi]]);
    // Partition (X=part_outer_x + housewrap) — skip both door Z bands
    render_counter_battens_horizontal(
        [part_outer_x + RH_HOUSEWRAP_T, butt_y0, bh],
        butt_len, v5_h_high_battens, "Y", 600, v5_h_low_battens,
        skip_zs = [[RH_FLOOR_TOP, house_zhi],
                   [pet_zlo, pet_zhi]]);
}
