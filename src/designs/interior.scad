// Interior dressing: nest box, hay rack, bowls, rabbits, outdoor landscape.

include <../lib/defaults.scad>
include <config.scad>
use <../lib/decor/rabbit.scad>
use <../lib/decor/lighting.scad>
use <../lib/decor/landscape.scad>

// Yard floor — stabilgrus filled to top of fundablok ring (Z=RH_BASE_H)
// per Phase 1 spec §3.3, with grass on top.
module render_yard_grass(yard_x0, yard_len, ww) {
    color([0.32, 0.58, 0.22])
    translate([yard_x0, 0, RH_BASE_H])
        cube([yard_len, ww, 8]);
}

module RenderInterior(show_cladding = true, show_ground = true,
                      palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H;
    hl = RH_HOUSE_LEN; rl = RH_RUN_LEN; wt = RH_WALL_T;
    ct = RH_COUNTER_BATTEN_T;

    if (show_ground) render_yard_grass(hl + ct, rl - ct, ww);

    if (show_cladding) {
        nest_box_insulated([RH_NEST_X, RH_NEST_Y, bh + 20],
                           RH_NEST_W, RH_NEST_D, RH_NEST_H, palette);
        color([0.78, 0.72, 0.40])
        translate([wt + 50, wt + 30, bh + 20])
            cube([400, 600, 700]);
        color(pal_panel1(palette))
        translate([wt + 500, wt + 30, bh + 20])
            cube([400, 600, 900]);
        hay_rack(400, ww - wt, bh + 250, 500, 400, palette);
    }

    water_bowl(hl + 600, 1500, bh + 8);
    food_bowl(hl + 850, 1500, bh + 8);
    translate([hl + rl/2 - 100, ww/2 - 350, bh + 18])  rabbit(angle = 30);
    translate([hl + 700, RH_PET_DOOR_Y - 450, bh + 18]) rabbit_loaf(angle = -10);
}
