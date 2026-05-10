// fundament.scad — Foundation: ring + floor + apron + ground/path
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/foundation.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/decor/rabbit.scad>
use <../../lib/bom.scad>

// `show_ground=false` hides the ground / gravel path so the buried fundablok
// ring foundation (Z<0) is visible from above.
module v3_fundament(show_ground = true, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H; wt = V3_WALL_T;
    hl = V3_HOUSE_LEN; rl = V3_RUN_LEN;
    ct = 22;  // klink thickness — Sub-phase D may rebase this when slab is replaced

    if (show_ground) {
        ground_grass([ll/2, ww/2]);
        gravel_path_y([V3_YARD_DOOR_X + V3_YARD_DOOR_W/2, 0]);
    }

    fundablok_ring(ll, ww, 3, [hl]);

    // Floor slab (Sub-phase D will replace this with strøer floor)
    slab([-ct, -ct], [hl + 2*ct, ww + 2*ct], bh, palette,
         edge_thicken_h = 200, edge_thicken_w = 250);
    interior_floor([wt, wt], [hl - 2*wt, ww - 2*wt], bh, 20, palette);
    rabbit_floor_grass([wt, wt], [hl - 2*wt, ww - 2*wt], bh);

    apron_skirt([hl, 0, ll, ww], V3_APRON_W,
                ["front", "back", "right"], palette);
}
