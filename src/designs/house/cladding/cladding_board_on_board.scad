// Board-on-board cladding on the 4 house walls.
// Stickout: housewrap 1 + batten 22 + boards 2 × 25 = 73 mm; trim 70×70.

include <../../../lib/defaults.scad>
include <../../config.scad>
use <../../../lib/primitives/cladding.scad>
use <cladding_common.scad>

module render_cladding_board_on_board(bob = RH_CLAD_BOB,
                                       palette = DEFAULT_PALETTE) {
    hl  = RH_HOUSE_LEN; ww = RH_HOUSE_DEPTH; bh = RH_BASE_H;
    ehf = RH_EH_FRONT;  ehb = RH_EH_BACK;
    sd  = RH_POST_W;    pl  = RH_SILL_H;

    ct      = bs_stickout(bob);                  // 2 × board_t = 50
    s       = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    trim_w  = 70;
    o       = s + ct;                             // outer-corner offset
    part_x  = hl;                                 // V5 yard-side outer face

    butt_y0  = sd;
    butt_len = ww - 2 * sd;
    v5_high  = wall_height_at(butt_y0);
    v5_low   = wall_height_at(butt_y0 + butt_len);

    win_z      = RH_FLOOR_TOP + RH_SIDE_WIN_Z;
    house_dz   = RH_FLOOR_TOP;
    pet_dz     = RH_FLOOR_TOP + 15;

    // -- Housewrap (vindpap on the outside face of the studs).
    render_housewrap([0, -RH_HOUSEWRAP_T, bh], hl, ehf - pl, "X");
    render_housewrap([0, ww,              bh], hl, ehb - pl, "X");
    difference() {
        render_housewrap([-RH_HOUSEWRAP_T, 0, bh], ww,
                          ehf - pl, "Y", ehb - pl);
        translate([-RH_HOUSEWRAP_T - 1, RH_SIDE_WIN_Y, win_z])
            cube([RH_HOUSEWRAP_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }
    difference() {
        render_housewrap([part_x, butt_y0, bh], butt_len,
                          v5_high - pl, "Y", v5_low - pl);
        translate([part_x - 1, RH_HOUSE_DOOR_Y, house_dz])
            cube([RH_HOUSEWRAP_T + 2, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_x - 1, RH_PET_DOOR_Y, pet_dz])
            cube([RH_HOUSEWRAP_T + 2, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    // -- Counter-battens (horizontal — bob boards run vertical).
    render_horizontal_battens([0, -s, bh],                hl, ehf, "X");
    render_horizontal_battens([0, ww + RH_HOUSEWRAP_T, bh], hl, ehb, "X");
    render_horizontal_battens([-s, 0, bh], ww, ehf, "Y", 600, ehb,
        skip_zs = [[win_z, win_z + RH_SIDE_WIN_H]]);
    render_horizontal_battens(
        [part_x + RH_HOUSEWRAP_T, butt_y0, bh], butt_len,
        v5_high, "Y", 600, v5_low,
        skip_zs = [[house_dz, house_dz + RH_HOUSE_DOOR_H],
                   [pet_dz,   pet_dz   + RH_PET_DOOR_H]]);

    // -- Bob boards.
    clad_wall_bob_rect([0, -(s + ct), bh], hl, ehf, "X", palette, bob);
    clad_wall_bob_rect([0, ww + s,    bh], hl, ehb, "X", palette, bob);
    clad_wall_bob_mono_pitch_with_cutout(
        [-(s + ct), 0, bh], ww, ehf, ehb, "Y", palette, bob,
        [RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W,
         RH_SIDE_WIN_Z, RH_SIDE_WIN_Z + RH_SIDE_WIN_H]);
    difference() {
        clad_wall_bob_mono_pitch([part_x + s, butt_y0, bh], butt_len,
                                  v5_high, v5_low, "Y", palette, bob);
        translate([part_x + s - 10, RH_HOUSE_DOOR_Y, house_dz])
            cube([ct + 20, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_x + s - 10, RH_PET_DOOR_Y, pet_dz])
            cube([ct + 20, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    // -- Corner trim posts.
    render_corner_post([-o,              -o,              bh], trim_w, ehf, palette);
    render_corner_post([hl + o - trim_w, -o,              bh], trim_w, ehf, palette);
    render_corner_post([-o,              ww + o - trim_w, bh], trim_w, ehb, palette);
    render_corner_post([hl + o - trim_w, ww + o - trim_w, bh], trim_w, ehb, palette);
}
