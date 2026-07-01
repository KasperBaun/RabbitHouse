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
    part_x  = hl;                                 // V4 outer face = hl

    house_dz = RH_FLOOR_TOP;
    pet_dz   = RH_FLOOR_TOP + 15;

    // V1 front-wall openings (barn door + 2 flanking windows). Cut through
    // housewrap + klink so they aren't buried behind boards; battens skip the
    // same X-ranges. Each entry: [x0, width, z0, height].
    v1_openings = [
        [RH_FRONT_DOOR_X,      RH_FRONT_DOOR_W, RH_FLOOR_TOP,                  RH_FRONT_DOOR_H],
        [RH_FRONT_WIN_X_LEFT,  RH_FRONT_WIN_W,  RH_FLOOR_TOP + RH_FRONT_WIN_Z, RH_FRONT_WIN_H],
        [RH_FRONT_WIN_X_RIGHT, RH_FRONT_WIN_W,  RH_FLOOR_TOP + RH_FRONT_WIN_Z, RH_FRONT_WIN_H]
    ];
    v1_skip = [for (op = v1_openings) [op[0], op[0] + op[1]]];

    // V3 left-wall side window — cut through housewrap + klink on the -X face.
    v3_win_z = RH_FLOOR_TOP + RH_SIDE_WIN_Z;
    v3_skip  = [[RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W]];

    // -- Housewrap (vindpap on the outside face of the studs).
    difference() {
        render_housewrap([0, -RH_HOUSEWRAP_T, bh], hl, eh - pl, "X");
        for (op = v1_openings)
            translate([op[0], -RH_HOUSEWRAP_T - 1, op[2]])
                cube([op[1], RH_HOUSEWRAP_T + 2, op[3]]);
    }
    render_housewrap([0, ww,              bh], hl, eh - pl, "X");
    difference() {
        render_housewrap([-RH_HOUSEWRAP_T, 0, bh], ww, eh - pl, "Y");
        translate([-RH_HOUSEWRAP_T - 1, RH_SIDE_WIN_Y, v3_win_z])
            cube([RH_HOUSEWRAP_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }
    difference() {
        render_housewrap([part_x, 0, bh], ww, eh - pl, "Y");
        translate([part_x - 1, RH_HOUSE_DOOR_Y, house_dz])
            cube([RH_HOUSEWRAP_T + 2, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_x - 1, RH_PET_DOOR_Y, pet_dz])
            cube([RH_HOUSEWRAP_T + 2, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    // -- Counter-battens (vertical — klink boards run horizontal).
    render_vertical_battens([0, -s, bh], hl, eh, "X", skip_ranges = v1_skip);
    render_vertical_battens([0, ww + RH_HOUSEWRAP_T, bh], hl, eh, "X");
    render_vertical_battens([-s, 0, bh], ww, eh, "Y", skip_ranges = v3_skip);
    render_vertical_battens(
        [part_x + RH_HOUSEWRAP_T, 0, bh], ww, eh, "Y",
        skip_ranges = [
            [RH_HOUSE_DOOR_Y, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W],
            [RH_PET_DOOR_Y,   RH_PET_DOOR_Y   + RH_PET_DOOR_W]]);

    // -- Klink boards. Cutouts run `km` mm wider than the opening on the
    // lateral (jamb) axis so the cut board-ends retreat behind the casing lap
    // — keeps the klink edge off the opening plane (no edge-on z-fighting).
    km = 8;
    difference() {
        clad_wall_rect([0, -(s + ct), bh], hl, eh, "X", palette, clad);
        for (op = v1_openings)
            translate([op[0] - km, -(s + ct) - 10, op[2]])
                cube([op[1] + 2*km, ct + 20, op[3]]);
    }
    clad_wall_rect([0, ww + s,    bh], hl, eh, "X", palette, clad);
    difference() {
        clad_wall_rect([-(s + ct), 0, bh], ww, eh, "Y", palette, clad);
        translate([-(s + ct) - 10, RH_SIDE_WIN_Y - km, v3_win_z])
            cube([ct + 20, RH_SIDE_WIN_W + 2*km, RH_SIDE_WIN_H]);
    }
    difference() {
        clad_wall_rect([part_x + s, 0, bh], ww, eh, "Y",
                       palette, clad);
        translate([part_x + s - 10, RH_HOUSE_DOOR_Y - km, house_dz])
            cube([ct + 20, RH_HOUSE_DOOR_W + 2*km, RH_HOUSE_DOOR_H]);
        translate([part_x + s - 10, RH_PET_DOOR_Y - km, pet_dz])
            cube([ct + 20, RH_PET_DOOR_W + 2*km, RH_PET_DOOR_H]);
    }

    // -- Corner trim posts.
    render_corner_post([-o,              -o,              bh], trim_w, eh, palette);
    render_corner_post([hl + o - trim_w, -o,              bh], trim_w, eh, palette);
    render_corner_post([-o,              ww + o - trim_w, bh], trim_w, eh, palette);
    render_corner_post([hl + o - trim_w, ww + o - trim_w, bh], trim_w, eh, palette);

    // -- Indfatning (casing) around every opening. Doors get a 3-sided frame
    // (no sill), windows a full 4-sided frame. `o` (= s + ct) is the cladding
    // outer-face offset the casing caps.
    win_dz = RH_FLOOR_TOP + RH_FRONT_WIN_Z;
    // V1 front wall — outward normal -Y, cladding outer face at Y = -o.
    render_opening_trim("X", -o, -1, RH_FRONT_DOOR_X,      RH_FRONT_DOOR_W, RH_FLOOR_TOP, RH_FRONT_DOOR_H, o, sill=false, palette=palette);
    render_opening_trim("X", -o, -1, RH_FRONT_WIN_X_LEFT,  RH_FRONT_WIN_W,  win_dz,       RH_FRONT_WIN_H,  o, palette=palette);
    render_opening_trim("X", -o, -1, RH_FRONT_WIN_X_RIGHT, RH_FRONT_WIN_W,  win_dz,       RH_FRONT_WIN_H,  o, palette=palette);
    // V3 left wall — outward normal -X, cladding outer face at X = -o.
    render_opening_trim("Y", -o, -1, RH_SIDE_WIN_Y, RH_SIDE_WIN_W, v3_win_z, RH_SIDE_WIN_H, o, palette=palette);
    // V4 partition — outward normal +X, cladding outer face at X = hl + o.
    render_opening_trim("Y", hl + o, +1, RH_HOUSE_DOOR_Y, RH_HOUSE_DOOR_W, house_dz, RH_HOUSE_DOOR_H, o, sill=false, palette=palette);
    render_opening_trim("Y", hl + o, +1, RH_PET_DOOR_Y,   RH_PET_DOOR_W,   pet_dz,   RH_PET_DOOR_H,   o, sill=false, palette=palette);
}
