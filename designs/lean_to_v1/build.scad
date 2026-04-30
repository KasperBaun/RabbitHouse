// Lean-to v1 build — composes the original mono-pitch shed with rabbit zone
// (left/front mesh) and human seating zone (right, lower clad + upper mesh).
//
// Entry point: build_lean_to_v1(preset)

include <../../lib/defaults.scad>
include <config.scad>

use <../../lib/primitives/cladding.scad>
use <../../lib/primitives/mesh.scad>
use <../../lib/primitives/roof.scad>
use <../../lib/primitives/framing.scad>
use <../../lib/primitives/foundation.scad>
use <../../lib/primitives/openings.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/decor/lighting.scad>
use <../../lib/decor/furniture.scad>
use <../../lib/decor/rabbit.scad>

// ---------------------------------------------------------------------------
// Top-level build
// ---------------------------------------------------------------------------

module build_lean_to_v1(preset="7x3") {
    d          = v1_dims_for(preset);
    rabbit_len = v1_rabbit_len_for(preset);
    pal        = DEFAULT_PALETTE;
    clad       = DEFAULT_CLAD;
    mesh       = DEFAULT_MESH;
    stud       = DEFAULT_STUD;

    ll = d[0]; ww = d[1]; eh = d[2];
    bh = 120; wt = 100;
    drop = v1_roof_drop_back(ww);
    front_top_beam = V1_FRONT_TOP_BEAM_H;
    front_post_w   = V1_FRONT_POST_W;
    rscl = v1_right_side_clad_h(ww);

    seat_x0 = rabbit_len;
    seat_len = ll - rabbit_len;
    mesh_bottom_z = bh + wt;
    mesh_top_z    = bh + eh - front_top_beam;
    mesh_h        = mesh_top_z - mesh_bottom_z;
    right_side_mesh_z = bh + rscl;
    right_side_mesh_h = eh - front_top_beam - rscl;

    // --- Landscaping -------------------------------------------------------
    ground_grass([ll/2, ww/2]);
    seat_cx = rabbit_len + (ll - rabbit_len) / 2;
    gravel_path_y([seat_cx, 0]);

    // --- Foundation --------------------------------------------------------
    slab([0, 0], [ll, ww], bh, pal);
    interior_floor([wt, wt], [ll - 2*wt, ww - 2*wt], bh, 20, pal);
    rabbit_floor_grass([wt, wt], [rabbit_len - wt - 10, ww - 2*wt], bh);

    // --- Walls -------------------------------------------------------------
    v1_back_wall_core(ll, ww, eh, bh, drop, stud, pal);
    v1_seat_right_lower_wall(ll, ww, bh, wt, rscl, pal);
    v1_seat_right_side_frame(ll, ww, eh, bh, wt, drop, front_post_w,
                             front_top_beam, right_side_mesh_z, pal);
    v1_front_posts_and_beam(ll, ww, eh, bh, wt, drop, front_post_w,
                            front_top_beam, rabbit_len, pal);
    v1_front_rabbit_mesh(rabbit_len, mesh_bottom_z, mesh_h, front_post_w, pal, mesh);
    v1_left_mesh_frame(ww, eh, bh, wt, drop, front_top_beam, pal);
    v1_left_mesh(ww, eh, bh, wt, drop, mesh_bottom_z, mesh_h, front_top_beam,
                 pal, mesh);
    v1_divider(rabbit_len, ww, eh, bh, wt, drop, mesh_bottom_z,
               front_top_beam, pal, mesh);

    // --- Roof --------------------------------------------------------------
    roof_mono_pitch([0, 0, bh + eh], ll, ww, drop, 80, 180, 100, 120, pal);
    fascia_and_gutter_mono([0, 0, bh + eh], ll, ww, drop,
                           140, 22, 180, 100, 120, 100, 60, pal);
    ceiling_rafters_mono([0, 0, 0], ll, ww, drop, bh + eh, 800, 45, 140, wt, pal);

    // --- Cladding & trim ---------------------------------------------------
    v1_back_cladding(ll, ww, eh, bh, drop, pal, clad);
    v1_right_side_cladding(ll, ww, eh, bh, drop, front_top_beam,
                           right_side_mesh_z, right_side_mesh_h, pal, clad);
    v1_corner_trim(ll, ww, eh, bh, drop, clad, pal);
    v1_interior_panels(ll, ww, eh, bh, wt, drop, right_side_mesh_z,
                       right_side_mesh_h, front_top_beam, pal);
    v1_right_side_window(ll, ww, bh, wt, right_side_mesh_z, right_side_mesh_h,
                         drop, pal, clad);

    // --- Furniture --------------------------------------------------------
    corner_bench(seat_x0, seat_len, ll, ww, bh, wt, undef, pal);
    trestle_table(seat_x0, seat_len, ll, ww, bh, pal);
    wall_shelves(seat_x0, seat_len, ll, ww, bh, wt, pal);
    coffee_station(ll, ww, bh, wt, pal);
    table_rug(seat_x0, seat_len, ll, ww, bh);

    // --- Lighting & electrical --------------------------------------------
    v1_pendant(seat_x0, seat_len, ll, ww, eh, bh, drop, pal);
    v1_string_lights(seat_x0, ll, ww, eh, bh, wt, drop);
    v1_outlets(seat_x0, seat_len, ll, ww, bh, wt, pal);

    // --- Rabbit zone accessories ------------------------------------------
    v1_rabbit_accessories(ww, bh, wt);

    // --- Decor ------------------------------------------------------------
    table_laptop(seat_x0, seat_len, ll, ww, bh, pal);
}

// ---------------------------------------------------------------------------
// V1-specific helper modules
// ---------------------------------------------------------------------------

module v1_back_wall_core(ll, ww, eh, bh, drop, stud, pal) {
    sd = ss_d(stud);
    h  = eh - drop;
    stud_wall([0, ww - sd, bh], ll, h, "X", stud, pal);
}

module v1_seat_right_lower_wall(ll, ww, bh, wt, rscl, pal) {
    color(pal_wall(pal))
    translate([ll - wt, 0, bh])
        cube([wt, ww, rscl]);
}

module v1_seat_right_side_frame(ll, ww, eh, bh, wt, drop, fpw, ftb,
                                rsmz, pal) {
    color(pal_post(pal)) {
        translate([ll - wt, 0, bh])
            cube([wt, fpw, eh]);
        translate([ll - wt, ww - fpw, bh])
            cube([wt, fpw, eh - drop]);
        translate([ll - wt, fpw, rsmz - 40])
            cube([wt, ww - 2*fpw, 40]);
        hull() {
            translate([ll - wt, fpw, bh + eh - ftb])
                cube([wt, 0.01, ftb]);
            translate([ll - wt, ww - fpw - 0.01, bh + eh - drop - ftb])
                cube([wt, 0.01, ftb]);
        }
    }
}

module v1_front_posts_and_beam(ll, ww, eh, bh, wt, drop, fpw, ftb,
                               rabbit_len, pal) {
    color(pal_post(pal)) {
        translate([0, 0, bh]) cube([fpw, wt, eh]);
        translate([rabbit_len - fpw/2, 0, bh]) cube([fpw, wt, eh]);
        translate([ll - fpw, 0, bh]) cube([fpw, wt, eh]);
        translate([fpw, 0, bh + eh - ftb])
            cube([ll - 2*fpw, wt, ftb]);
        translate([fpw, 0, bh])
            cube([rabbit_len - fpw * 1.5, wt, wt]);
        translate([rabbit_len + fpw/2, 0, bh])
            cube([ll - rabbit_len - fpw * 1.5, wt, wt]);
    }
}

module v1_front_rabbit_mesh(rabbit_len, mesh_bz, mesh_h, fpw, pal, mesh) {
    panel_x = fpw;
    panel_w = rabbit_len - fpw - 20;
    md = ms_depth(mesh);
    mesh_panel_x(panel_x, panel_w, mesh_bz, mesh_h, -md, pal, mesh);
}

module v1_left_mesh_frame(ww, eh, bh, wt, drop, ftb, pal) {
    color(pal_post(pal)) {
        translate([0, 0, bh]) cube([wt, wt, eh]);
        translate([0, ww - wt, bh]) cube([wt, wt, eh - drop]);
        hull() {
            translate([0, wt, bh + eh - ftb])
                cube([wt, 0.01, ftb]);
            translate([0, ww - wt - 0.01, bh + eh - drop - ftb])
                cube([wt, 0.01, ftb]);
        }
        translate([0, wt, bh])
            cube([wt, ww - 2*wt, wt]);
    }
}

module v1_left_mesh(ww, eh, bh, wt, drop, mesh_bz, mesh_h, ftb, pal, mesh) {
    md = ms_depth(mesh);
    x = -md;
    y = wt;
    w = ww - 2*wt;
    z = mesh_bz;
    h = eh - ftb - wt - drop;
    mesh_panel_y(y, w, z, h, x, pal, mesh);
    color(pal_post(pal))
    hull() {
        translate([x, y, z + h])
            cube([md, 0.01, drop]);
        translate([x, y + w - 0.01, z + h])
            cube([md, 0.01, 0.01]);
    }
}

// Mesh+glass divider between rabbit zone and seating zone.
module v1_divider(rabbit_len, ww, eh, bh, wt, drop, mesh_bz, ftb, pal, mesh) {
    md = ms_depth(mesh);
    x = rabbit_len;
    y = wt;
    w = ww - 2*wt;
    z = mesh_bz;
    glass_split_z = bh + 1200;
    mh = glass_split_z - z;

    mesh_panel_y(y, w, z, mh, x, pal, mesh);

    color(pal_post(pal))
    translate([x, y, glass_split_z - 20])
        cube([md, w, 40]);

    glass_z0 = glass_split_z + 20;
    front_top = bh + eh - ftb;
    back_top  = front_top - drop;

    color(pal_glass(pal))
    hull() {
        translate([x + 2, y, glass_z0])
            cube([6, 0.01, front_top - glass_z0]);
        translate([x + 2, y + w, glass_z0])
            cube([6, 0.01, back_top - glass_z0]);
    }

    color(pal_post(pal)) {
        translate([x, y, glass_z0])
            cube([md, wt, front_top - glass_z0]);
        translate([x, y + w - wt, glass_z0])
            cube([md, wt, back_top - glass_z0]);
        hull() {
            translate([x, y, front_top - 40])
                cube([md, 0.01, 40]);
            translate([x, y + w, back_top - 40])
                cube([md, 0.01, 40]);
        }
    }
}

module v1_back_cladding(ll, ww, eh, bh, drop, pal, clad) {
    ct = cs_thick(clad);
    wall_h = eh - drop;
    clad_wall_rect([0, ww + ct - ct, bh], ll, wall_h, "X", pal, clad);
    // The original cladding sat just outside the back wall plane; offset by 0
    // (back wall outer face is already at Y = ww in v1) — translate is [0, ww, bh].
}

module v1_right_side_cladding(ll, ww, eh, bh, drop, ftb, rsmz, rsmh,
                              pal, clad) {
    ct = cs_thick(clad);
    win_margin = 400;
    win_y0 = win_margin;
    win_y1 = ww - win_margin;
    win_z0 = rsmz;
    win_z1 = win_z0 + rsmh - drop - 80;
    h_high = eh - ftb;
    h_low  = h_high - drop;
    cutout = [win_y0, win_y1, win_z0, win_z1];
    clad_wall_mono_pitch_with_cutout(
        [ll, 0, bh], ww, h_high, h_low, "Y", pal, clad, cutout);
}

module v1_corner_trim(ll, ww, eh, bh, drop, clad, pal) {
    ct = cs_thick(clad);
    h = eh - drop;
    corner_trim_post([ll + ct, ww + ct, bh], h, 50, 22, pal);
}

module v1_interior_panels(ll, ww, eh, bh, wt, drop, rsmz, rsmh, ftb, pal) {
    panel_t = 12;
    panel_h = eh - drop - 40;

    color(pal_wall(pal))
    translate([wt, ww - wt, bh + 20])
        cube([ll - 2*wt, panel_t, panel_h]);

    win_margin = 400;
    win_y = win_margin;
    win_w = ww - 2*win_margin;
    win_z = rsmz;
    win_h = rsmh - drop - 80;

    color(pal_wall(pal))
    difference() {
        translate([ll - wt - panel_t, wt, bh + 20])
            cube([panel_t, ww - 2*wt, panel_h]);
        translate([ll - wt - panel_t - 1, win_y, win_z])
            cube([panel_t + 2, win_w, win_h]);
    }
}

module v1_right_side_window(ll, ww, bh, wt, rsmz, rsmh, drop, pal, clad) {
    ct = cs_thick(clad);
    win_margin = 400;
    win_y = win_margin;
    win_w = ww - 2*win_margin;
    win_z = rsmz;
    win_h = rsmh - drop - 80;
    window_with_trim(ll, win_y, win_z, win_w, win_h, ct, pal, true);
}

module v1_pendant(seat_x0, seat_len, ll, ww, eh, bh, drop, pal) {
    table_w = ll >= 8000 ? 1600 : 1400;
    table_d = ww >= 4000 ? 800 : 700;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = ww >= 4000 ? 1500 : 1250;
    lx = tx + table_w / 2;
    ly = ty + table_d / 2;
    roof_z = bh + eh - (ly / ww) * drop;
    pendant_lamp([lx, ly], roof_z, 600, pal);
}

module v1_string_lights(seat_x0, ll, ww, eh, bh, wt, drop) {
    z_front = bh + eh - 160;
    z_back  = bh + eh - drop - 160;
    spacing = 200;
    for (offset_x = [seat_x0 + 300, ll - 300]) {
        string_lights_run([offset_x, wt, z_front],
                          [offset_x, ww - wt, z_back],
                          spacing);
    }
    cross_z = z_front - 5;
    string_lights_run([seat_x0 + 300, wt + 200, cross_z],
                      [ll - 300, wt + 200, cross_z],
                      spacing);
}

module v1_outlets(seat_x0, seat_len, ll, ww, bh, wt, pal) {
    floor_z = bh + 20;
    outlet_z = floor_z + 450 + 300;
    wall_y = ww - wt;
    ox1 = seat_x0 + seat_len * 0.35;
    ox2 = seat_x0 + seat_len * 0.7;
    for (ox = [ox1, ox2])
        wall_outlet([ox, wall_y, outlet_z], "Y", pal);
    rx = ll - wt;
    ry = ww >= 4000 ? 2000 : 1600;
    wall_outlet([rx, ry, outlet_z], "X", pal);
}

// V1's specific rabbit accessory placement.
module v1_rabbit_accessories(ww, bh, wt) {
    floor_z = bh + 25;
    rabbit_shelter([600, ww/2 - 300, floor_z]);
    water_bowl(2200, 1200, floor_z);
    food_bowl(2450, 1250, floor_z);
    hay_rack(1800, ww - wt, floor_z + 200, 400, 300);
    play_tunnel(3200, 2500, floor_z);
    lookout_platform([3500, 800, floor_z], [500, 350, 80]);
    willow_ball(2800, 800, floor_z + 50);
    chew_log(1600, 600, floor_z + 30);
    toss_toy(3000, 1800, floor_z + 20);
    digging_box([300, 800, floor_z]);
    translate([2200 - 300, 1200 - 100, floor_z]) rabbit(angle = -30);
    translate([3200 - 300, 2500 + 200, floor_z]) rabbit_loaf(angle = 160);
}
