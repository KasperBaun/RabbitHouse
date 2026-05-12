// inventar.scad — Nest box, hay rack, bowls, rabbits, outdoor dressing
// Part of the v3 build pipeline; included from build.scad.

include <../lib/defaults.scad>
include <config.scad>
use <../lib/decor/rabbit.scad>
use <../lib/decor/lighting.scad>
use <../lib/decor/landscape.scad>

// Yard floor — stabilgrus filled to top of fundablok ring (Z=RH_BASE_H)
// per Phase 1 spec §3.3, with grass/jord on top. Inside the yard, the
// 8 mm grass surface therefore sits at Z=RH_BASE_H..RH_BASE_H+8.
module rh_yard_grass(yard_x0, yard_len, ww) {
    z0 = RH_BASE_H;
    color([0.32, 0.58, 0.22])
    translate([yard_x0, 0, z0])
        cube([yard_len, ww, 8]);
    color([0.40, 0.62, 0.28])
    for (cx = [yard_x0 + 350, yard_x0 + 1100, yard_x0 + 1900,
               yard_x0 + 2700, yard_x0 + 3400])
        for (cy = [350, 950, 1500, 2050])
            translate([cx, cy, z0 + 8])
                cube([280 + (cx % 90), 220 + (cy % 70), 4]);
    color([0.30, 0.50, 0.20])
    for (cx = [yard_x0 + 200, yard_x0 + 600])
        translate([cx, 1500 + cx % 200, z0 + 8])
            cube([180, 160, 3]);
}

// External landscape dressing.
module rh_outdoor_dressing(ll, ww, bh) {
    color([0.55, 0.55, 0.52])
    for (i = [0 : 3])
        translate([RH_YARD_DOOR_X + RH_YARD_DOOR_W/2 + 200*sin(i*60),
                   -2200 - i*420, -3])
            cylinder(h = 14, r = 230, $fn = 8);
}

module rh_inventar(show_cladding = true, show_ground = true,
                   palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H;
    hl = RH_HOUSE_LEN; rl = RH_RUN_LEN; wt = RH_WALL_T;
    ct = 22;

    if (show_ground) {
        rh_yard_grass(hl + ct, rl - ct, ww);
        rh_outdoor_dressing(ll, ww, bh);
    }

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
