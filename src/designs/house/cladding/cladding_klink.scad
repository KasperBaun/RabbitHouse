// Klink (lap-board) cladding on the 4 house walls.
// Stickout: housewrap 1 + batten 22 + klink 25 = 48 mm; trim 45×45.
// All 4 walls share one flat eave (RH_EH_FRONT == RH_EH_BACK) — gable
// rafters above create the pitch.

include <../../../lib/defaults.scad>
include <../../config.scad>
use <../../../lib/primitives/cladding.scad>
use <cladding_common.scad>

module render_cladding_klink(clad = RH_CLAD, palette = DEFAULT_PALETTE) {
    hl  = RH_HOUSE_LEN; ww = RH_HOUSE_DEPTH; bh = RH_BASE_H;
    eh  = RH_EH_FRONT;
    sd  = RH_POST_W;    pl  = RH_SILL_H;

    ct      = cs_thick(clad);                     // 25
    s       = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    trim_w  = 45;
    o       = s + ct;
    part_x  = hl;                                 // V5 outer face = hl

    butt_y0  = sd;
    butt_len = ww - 2 * sd;

    house_dz = RH_FLOOR_TOP;
    pet_dz   = RH_FLOOR_TOP + 15;

    // -- Housewrap (vindpap on the outside face of the studs).
    render_housewrap([0, -RH_HOUSEWRAP_T, bh], hl, eh - pl, "X");
    render_housewrap([0, ww,              bh], hl, eh - pl, "X");
    render_housewrap([-RH_HOUSEWRAP_T, 0, bh], ww, eh - pl, "Y");
    difference() {
        render_housewrap([part_x, butt_y0, bh], butt_len, eh - pl, "Y");
        translate([part_x - 1, RH_HOUSE_DOOR_Y, house_dz])
            cube([RH_HOUSEWRAP_T + 2, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_x - 1, RH_PET_DOOR_Y, pet_dz])
            cube([RH_HOUSEWRAP_T + 2, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    // -- Counter-battens (vertical — klink boards run horizontal).
    render_vertical_battens([0, -s, bh],                  hl, eh, "X");
    render_vertical_battens([0, ww + RH_HOUSEWRAP_T, bh], hl, eh, "X");
    render_vertical_battens([-s, 0, bh], ww, eh, "Y");
    render_vertical_battens(
        [part_x + RH_HOUSEWRAP_T, butt_y0, bh], butt_len, eh, "Y",
        skip_ranges = [
            [RH_HOUSE_DOOR_Y, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W],
            [RH_PET_DOOR_Y,   RH_PET_DOOR_Y   + RH_PET_DOOR_W]]);

    // -- Klink boards.
    clad_wall_rect([0, -(s + ct), bh], hl, eh, "X", palette, clad);
    clad_wall_rect([0, ww + s,    bh], hl, eh, "X", palette, clad);
    clad_wall_rect([-(s + ct), 0, bh], ww, eh, "Y", palette, clad);
    difference() {
        clad_wall_rect([part_x + s, butt_y0, bh], butt_len, eh, "Y",
                       palette, clad);
        translate([part_x + s - 10, RH_HOUSE_DOOR_Y, house_dz])
            cube([ct + 20, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_x + s - 10, RH_PET_DOOR_Y, pet_dz])
            cube([ct + 20, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    // -- Corner trim posts.
    render_corner_post([-o,              -o,              bh], trim_w, eh, palette);
    render_corner_post([hl + o - trim_w, -o,              bh], trim_w, eh, palette);
    render_corner_post([-o,              ww + o - trim_w, bh], trim_w, eh, palette);
    render_corner_post([hl + o - trim_w, ww + o - trim_w, bh], trim_w, eh, palette);
}
