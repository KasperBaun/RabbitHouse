// Built-in seating furniture. Currently consumed only by the lean_to_v1
// design — kept here so future designs with a human zone can reuse them.

include <../defaults.scad>

// L-shaped corner bench along back + right walls.
//   seat_x0  = X where the bench section starts (e.g. seating-zone start)
//   seat_len = length of the seating zone in X
//   shed_length, shed_width, base_h, wall_t = host structure
//   right_y0 = Y where the right-wall bench segment begins
module corner_bench(seat_x0, seat_len, shed_length, shed_width,
                    base_h=120, wall_t=100, right_y0=undef,
                    palette=DEFAULT_PALETTE) {
    seat_h = 450;
    bench_d = 500;
    plank_t = 30;
    plank_w = 110;
    plank_gap = 8;
    leg_w = 50;
    rail_h = 50;
    rail_t = 22;
    floor_z = base_h + 20;
    inset = 90;

    bk_x0 = seat_x0 + inset;
    bk_len = seat_len - inset - wall_t - 10;
    bk_y = shed_width - wall_t - bench_d;

    rt_y0 = is_undef(right_y0) ? (shed_width >= 4000 ? 2000 : 1600) : right_y0;
    rt_x = shed_length - wall_t - bench_d;
    rt_len = bk_y - rt_y0;

    n_planks = floor(bench_d / (plank_w + plank_gap));

    // Seat planks
    color(pal_bench(palette)) {
        for (p = [0 : n_planks - 1])
            translate([bk_x0, bk_y + plank_gap + p * (plank_w + plank_gap),
                       floor_z + seat_h - plank_t])
                cube([bk_len, plank_w, plank_t]);
        for (p = [0 : n_planks - 1])
            translate([rt_x + plank_gap + p * (plank_w + plank_gap), rt_y0,
                       floor_z + seat_h - plank_t])
                cube([plank_w, rt_len, plank_t]);
        for (p = [0 : n_planks - 1])
            translate([rt_x + plank_gap + p * (plank_w + plank_gap),
                       bk_y, floor_z + seat_h - plank_t])
                cube([plank_w, bench_d - 5, plank_t]);
    }

    // Legs
    color(pal_trim(palette)) {
        bk_leg_n = max(2, floor(bk_len / 650));
        for (i = [0 : bk_leg_n]) {
            lx = bk_x0 + 10 + i * (bk_len - leg_w - 20) / bk_leg_n;
            translate([lx, bk_y + 15, floor_z]) cube([leg_w, leg_w, seat_h - plank_t]);
            translate([lx, shed_width - wall_t - leg_w - 15, floor_z])
                cube([leg_w, leg_w, seat_h - plank_t]);
        }
        rt_leg_n = max(2, floor(rt_len / 650));
        for (i = [0 : rt_leg_n]) {
            ly = rt_y0 + 10 + i * (rt_len - leg_w - 20) / rt_leg_n;
            translate([rt_x + 15, ly, floor_z]) cube([leg_w, leg_w, seat_h - plank_t]);
            translate([shed_length - wall_t - leg_w - 15, ly, floor_z])
                cube([leg_w, leg_w, seat_h - plank_t]);
        }
    }

    // Apron rails
    color(pal_trim(palette)) {
        translate([bk_x0, bk_y + 8, floor_z + seat_h - plank_t - rail_h - 5])
            cube([bk_len, rail_t, rail_h]);
        translate([rt_x + 8, rt_y0, floor_z + seat_h - plank_t - rail_h - 5])
            cube([rail_t, rt_len, rail_h]);
    }

    // Backrests
    br_w = 90; br_t = 22; br_gap = 20;
    color(pal_bench(palette)) {
        for (b = [0 : 2])
            translate([bk_x0, shed_width - wall_t - br_t - 5,
                       floor_z + seat_h + 40 + b * (br_w + br_gap)])
                cube([bk_len, br_t, br_w]);
        for (b = [0 : 2])
            translate([shed_length - wall_t - br_t - 5, rt_y0,
                       floor_z + seat_h + 40 + b * (br_w + br_gap)])
                cube([br_t, rt_len + bench_d, br_w]);
    }

    // Cushions
    cushion_h = 80; cushion_margin = 30;
    pillow_col = [0.75, 0.42, 0.38];
    pillow_col2 = [0.40, 0.52, 0.58];
    color(pillow_col)
    translate([bk_x0 + cushion_margin, bk_y + cushion_margin, floor_z + seat_h])
        hull() {
            cube([bk_len - 2*cushion_margin, bench_d - 2*cushion_margin, 0.1]);
            translate([10, 10, cushion_h])
                cube([bk_len - 2*cushion_margin - 20, bench_d - 2*cushion_margin - 20, 0.1]);
        }
    color(pillow_col)
    translate([rt_x + cushion_margin, rt_y0 + cushion_margin, floor_z + seat_h])
        hull() {
            cube([bench_d - 2*cushion_margin, rt_len - 2*cushion_margin, 0.1]);
            translate([10, 10, cushion_h])
                cube([bench_d - 2*cushion_margin - 20, rt_len - 2*cushion_margin - 20, 0.1]);
        }
    color(pillow_col)
    translate([rt_x + cushion_margin, bk_y + cushion_margin, floor_z + seat_h])
        hull() {
            cube([bench_d - 2*cushion_margin, bench_d - 2*cushion_margin, 0.1]);
            translate([10, 10, cushion_h])
                cube([bench_d - 2*cushion_margin - 20, bench_d - 2*cushion_margin - 20, 0.1]);
        }

    // Pillows
    pw = 400; ph = 350; pd = 120;
    cushion_z = floor_z + seat_h + cushion_h;
    for (i = [0 : 2]) {
        pc = (i % 2 == 0) ? pillow_col2 : pillow_col;
        px = bk_x0 + 150 + i * (bk_len - 300 - pw) / 2;
        color(pc)
        translate([px, shed_width - wall_t - pd + 10, cushion_z])
            hull() {
                cube([pw, 0.1, ph]);
                translate([20, pd - 20, 20]) cube([pw - 40, 0.1, ph - 40]);
            }
    }
    for (i = [0 : 1]) {
        pc = (i % 2 == 0) ? pillow_col : pillow_col2;
        py = rt_y0 + 150 + i * (rt_len - 300 - pw) / 1;
        color(pc)
        translate([shed_length - wall_t - pd + 10, py, cushion_z])
            hull() {
                cube([0.1, pw, ph]);
                translate([pd - 20, 20, 20]) cube([0.1, pw - 40, ph - 40]);
            }
    }
    color(pillow_col2)
    translate([shed_length - wall_t - pd + 5, shed_width - wall_t - pd + 5, cushion_z])
        rotate([0, 0, -10])
        hull() {
            cube([pd, pd, 300]);
            translate([15, 15, 15]) cube([pd - 30, pd - 30, 270]);
        }
}

// Trestle dining table.
module trestle_table(seat_x0, seat_len, shed_length, shed_width,
                     base_h=120, palette=DEFAULT_PALETTE) {
    table_w = shed_length >= 8000 ? 2200 : 1800;
    table_d = shed_width >= 4000 ? 900 : 800;
    table_h = 680;
    top_t = 45;
    floor_z = base_h + 20;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;

    color(pal_table(palette))
    translate([tx - 30, ty - 30, floor_z + table_h])
        cube([table_w + 60, table_d + 60, top_t]);

    trestle_inset = 130;
    panel_w = 60;
    panel_d = table_d - 120;
    foot_extra = 50;
    foot_h = 35;
    color(pal_trim(palette))
    for (xi = [tx + trestle_inset, tx + table_w - trestle_inset - panel_w]) {
        translate([xi, ty + (table_d - panel_d) / 2, floor_z + foot_h])
            cube([panel_w, panel_d, table_h - foot_h]);
        translate([xi - foot_extra/2, ty + (table_d - panel_d)/2 - foot_extra/2, floor_z])
            cube([panel_w + foot_extra, panel_d + foot_extra, foot_h]);
    }
    str_h = 50; str_d = 60;
    str_z = floor_z + table_h * 0.3;
    str_x0 = tx + trestle_inset + panel_w;
    str_x1 = tx + table_w - trestle_inset - panel_w;
    color(pal_trim(palette))
    translate([str_x0, ty + table_d/2 - str_d/2, str_z])
        cube([str_x1 - str_x0, str_d, str_h]);
}

// Floating wall shelves with assorted decorative items.
module wall_shelves(seat_x0, seat_len, shed_length, shed_width,
                    base_h=120, wall_t=100, palette=DEFAULT_PALETTE) {
    shelf_t = 28; shelf_d = 220;
    floor_z = base_h + 20; inset = 90;
    shelf_z1 = floor_z + 1300;
    shelf_z2 = floor_z + 1650;

    bk_x0 = seat_x0 + inset;
    bk_len = seat_len - inset - wall_t - 200;

    for (sz = [shelf_z1, shelf_z2]) {
        color(pal_shelf(palette))
        translate([bk_x0, shed_width - wall_t - shelf_d, sz])
            cube([bk_len, shelf_d, shelf_t]);
    }

    wy = shed_width - wall_t - shelf_d + 20;

    // Books
    bx0 = bk_x0 + 60;
    for (i = [0 : 5]) {
        bk_h = 180 + i * 15; bk_w = 25 + (i % 2) * 8;
        bc = (i % 3 == 0) ? [0.65, 0.25, 0.22]
           : (i % 3 == 1) ? [0.22, 0.38, 0.52]
           :                [0.35, 0.50, 0.30];
        color(bc)
        translate([bx0 + i * 35, wy, shelf_z1 + shelf_t]) cube([bk_w, 140, bk_h]);
    }
    color(pal_trim(palette))
    translate([bx0 + 6 * 35 + 5, wy + 20, shelf_z1 + shelf_t]) cube([8, 100, 120]);

    // Candles
    cx0 = bk_x0 + bk_len * 0.4;
    for (ci = [0, 120]) {
        color(pal_trim(palette))
        translate([cx0 + ci, wy + 70, shelf_z1 + shelf_t]) cylinder(h = 15, r = 30);
        color([0.95, 0.92, 0.85])
        translate([cx0 + ci, wy + 70, shelf_z1 + shelf_t + 15]) cylinder(h = 100 - ci/3, r = 18);
        color([1.0, 0.85, 0.3, 0.7])
        translate([cx0 + ci, wy + 70, shelf_z1 + shelf_t + 115 - ci/3])
            cylinder(h = 15, r1 = 6, r2 = 0);
    }

    // Plant
    sx = bk_x0 + bk_len * 0.65;
    color([0.55, 0.35, 0.20])
    translate([sx, wy + 80, shelf_z1 + shelf_t]) cylinder(h = 70, r1 = 35, r2 = 40);
    color([0.35, 0.58, 0.32])
    translate([sx, wy + 80, shelf_z1 + shelf_t + 70]) sphere(r = 45);

    // Mug
    mx = bk_x0 + bk_len * 0.85;
    color([0.85, 0.82, 0.78])
    translate([mx, wy + 80, shelf_z1 + shelf_t])
        difference() {
            cylinder(h = 90, r = 35);
            translate([0, 0, 8]) cylinder(h = 90, r = 28);
        }
    color([0.85, 0.82, 0.78])
    translate([mx + 35, wy + 80, shelf_z1 + shelf_t + 25])
        rotate([0, 90, 0])
            difference() { cylinder(h = 15, r = 25); cylinder(h = 15, r = 15); }

    // Lantern
    lnx = bk_x0 + 80;
    color(pal_lamp(palette)) {
        translate([lnx, wy + 70, shelf_z2 + shelf_t]) cylinder(h = 8, r = 45);
        for (a = [45, 135, 225, 315])
            translate([lnx + 30 * cos(a), wy + 70 + 30 * sin(a), shelf_z2 + shelf_t + 8])
                cylinder(h = 140, r = 4);
        translate([lnx, wy + 70, shelf_z2 + shelf_t + 148])
            cylinder(h = 20, r1 = 45, r2 = 15);
    }
    color([1.0, 0.92, 0.6, 0.3])
    translate([lnx, wy + 70, shelf_z2 + shelf_t + 15]) cylinder(h = 120, r = 35);

    // Jars
    for (ji = [0 : 2]) {
        jx = bk_x0 + bk_len * 0.35 + ji * 100;
        jh = 110 + ji * 10;
        color([0.8, 0.85, 0.82, 0.4])
        translate([jx, wy + 75, shelf_z2 + shelf_t]) cylinder(h = jh, r = 32);
        color(pal_trim(palette))
        translate([jx, wy + 75, shelf_z2 + shelf_t + jh]) cylinder(h = 12, r = 34);
        jc = (ji == 0) ? [0.45, 0.30, 0.15]
           : (ji == 1) ? [0.70, 0.62, 0.35]
           :             [0.55, 0.70, 0.40];
        color(jc)
        translate([jx, wy + 75, shelf_z2 + shelf_t + 5])
            cylinder(h = jh * 0.6, r = 30);
    }

    // Trailing plant
    px = bk_x0 + bk_len * 0.75;
    color([0.50, 0.35, 0.22])
    translate([px, wy + 75, shelf_z2 + shelf_t]) cylinder(h = 80, r1 = 40, r2 = 35);
    color([0.30, 0.55, 0.28]) {
        translate([px, wy + 75, shelf_z2 + shelf_t + 80]) sphere(r = 50);
        translate([px - 20, wy - 10, shelf_z2 + shelf_t]) sphere(r = 25);
        translate([px + 15, wy + 5, shelf_z2 + shelf_t - 15]) sphere(r = 20);
    }

    // Frame
    fx = bk_x0 + bk_len - 100;
    color(pal_trim(palette))
    translate([fx, wy + 160, shelf_z2 + shelf_t]) cube([80, 12, 100]);
    color([0.9, 0.88, 0.82])
    translate([fx + 8, wy + 159, shelf_z2 + shelf_t + 8]) cube([64, 2, 84]);
}

// Coffee station — counter, gas burner, mokka pot, cooler.
module coffee_station(shed_length, shed_width, base_h=120, wall_t=100,
                      palette=DEFAULT_PALETTE) {
    floor_z = base_h + 20;
    counter_x = shed_length - wall_t - 500;
    counter_y = 250;
    counter_w = 450; counter_l = 900; counter_h = 850;
    top_t = 30; leg = 45;

    color(pal_trim(palette))
    for (dx = [20, counter_w - leg - 20])
        for (dy = [20, counter_l - leg - 20])
            translate([counter_x + dx, counter_y + dy, floor_z])
                cube([leg, leg, counter_h - top_t]);
    color(pal_trim(palette)) {
        translate([counter_x + 20, counter_y + 20, floor_z + 200])
            cube([leg, counter_l - 40 - leg, 22]);
        translate([counter_x + counter_w - leg - 20, counter_y + 20, floor_z + 200])
            cube([leg, counter_l - 40 - leg, 22]);
    }
    color(pal_shelf(palette))
    translate([counter_x - 15, counter_y - 15, floor_z + counter_h - top_t])
        cube([counter_w + 30, counter_l + 30, top_t]);
    color(pal_shelf(palette))
    translate([shed_length - wall_t - 25, counter_y - 15, floor_z + counter_h])
        cube([14, counter_l + 30, 200]);

    ctz = floor_z + counter_h;
    bx = counter_x + counter_w / 2 - 20;
    by = counter_y + 120;
    color([0.30, 0.30, 0.32])
    translate([bx - 100, by - 60, ctz]) cube([200, 120, 25]);
    for (dx = [-50, 50]) {
        color([0.20, 0.20, 0.20])
        translate([bx + dx, by, ctz + 25]) cylinder(h = 8, r = 45);
        color([0.25, 0.25, 0.25])
        for (a = [0, 45, 90, 135])
            translate([bx + dx + 40 * cos(a), by + 40 * sin(a), ctz + 33])
                rotate([0, 0, a]) cube([3, 80, 5], center = true);
    }
    color([0.15, 0.15, 0.15])
    for (dx = [-50, 50])
        translate([bx + dx, by - 65, ctz + 10])
            rotate([90, 0, 0]) cylinder(h = 15, r = 10);

    mx = counter_x + counter_w / 2 + 130;
    my = counter_y + 130;
    color([0.60, 0.60, 0.62])
    translate([mx, my, ctz]) cylinder(h = 60, r1 = 35, r2 = 30, $fn = 8);
    color([0.55, 0.55, 0.58])
    translate([mx, my, ctz + 60]) cylinder(h = 10, r = 25, $fn = 8);
    color([0.60, 0.60, 0.62])
    translate([mx, my, ctz + 70]) cylinder(h = 55, r1 = 25, r2 = 32, $fn = 8);
    color([0.20, 0.20, 0.20])
    translate([mx, my, ctz + 125]) sphere(r = 10);
    color([0.20, 0.20, 0.20]) {
        translate([mx + 30, my, ctz + 40]) cube([8, 8, 70]);
        translate([mx + 30, my, ctz + 110]) cube([20, 8, 8]);
    }

    fx = counter_x + 40; fy = counter_y + counter_l - 350;
    fw = 280; fd = 200; fh = 220;
    color([0.12, 0.12, 0.14])
    translate([fx, fy, ctz]) cube([fw, fd, fh]);
    color([0.18, 0.18, 0.20])
    translate([fx - 3, fy - 3, ctz + fh]) cube([fw + 6, fd + 6, 20]);
    color([0.15, 0.15, 0.15])
    translate([fx + fw/2 - 50, fy + fd/2 - 8, ctz + fh + 20])
        hull() {
            cube([100, 16, 5]);
            translate([10, 3, 20]) cube([80, 10, 5]);
        }
    color([0.30, 0.55, 0.75])
    translate([fx + fw/2 - 20, fy - 1, ctz + fh/2 - 10]) cube([40, 2, 20]);
}

// Woven rug under the table area.
module table_rug(seat_x0, seat_len, shed_length, shed_width, base_h=120) {
    table_w = shed_length >= 8000 ? 2200 : 1800;
    table_d = shed_width >= 4000 ? 900 : 800;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;
    floor_z = base_h + 20;

    rug_w = table_w + 500; rug_d = table_d + 400;
    rx = tx - 250; ry = ty - 200;

    color([0.60, 0.35, 0.30])
    translate([rx, ry, floor_z + 1]) cube([rug_w, rug_d, 6]);

    color([0.45, 0.28, 0.22])
    translate([rx, ry, floor_z + 7]) {
        cube([rug_w, 40, 2]);
        cube([40, rug_d, 2]);
        translate([0, rug_d - 40, 0]) cube([rug_w, 40, 2]);
        translate([rug_w - 40, 0, 0]) cube([40, rug_d, 2]);
    }
    color([0.75, 0.55, 0.35])
    translate([rx + 60, ry + 60, floor_z + 7]) {
        cube([rug_w - 120, 15, 2]);
        cube([15, rug_d - 120, 2]);
        translate([0, rug_d - 120 - 15, 0]) cube([rug_w - 120, 15, 2]);
        translate([rug_w - 120 - 15, 0, 0]) cube([15, rug_d - 120, 2]);
    }
    color([0.55, 0.32, 0.25])
    for (i = [0 : 15]) {
        fx = rx + 30 + i * (rug_w - 60) / 15;
        translate([fx, ry - 50, floor_z + 1]) cube([8, 55, 3]);
        translate([fx, ry + rug_d, floor_z + 1]) cube([8, 55, 3]);
    }
}

// Open laptop on the table (decorative).
module table_laptop(seat_x0, seat_len, shed_length, shed_width,
                    base_h=120, palette=DEFAULT_PALETTE) {
    table_w = shed_length >= 8000 ? 2200 : 1800;
    table_d = shed_width >= 4000 ? 900 : 800;
    table_h = 680; top_t = 45;
    floor_z = base_h + 20;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;
    lx = tx + table_w / 2 - 170;
    ly = ty + 100;
    lz = floor_z + table_h + top_t;
    lap_w = 340; lap_d = 230; lap_t = 8; screen_h = 220;

    color(pal_laptop(palette))
    translate([lx, ly, lz]) cube([lap_w, lap_d, lap_t]);
    color(pal_laptop(palette))
    translate([lx, ly + lap_d, lz + lap_t])
        rotate([25, 0, 0]) cube([lap_w, lap_t, screen_h]);
    color(pal_screen(palette))
    translate([lx + 10, ly + lap_d + 1, lz + lap_t])
        rotate([25, 0, 0])
            translate([0, lap_t, 10]) cube([lap_w - 20, 1, screen_h - 20]);

    // Mugs
    for (mi = [0 : 2]) {
        mmx = tx + 150 + mi * 550;
        mmy = ty + table_d - 200;
        mc = (mi == 0) ? [0.82, 0.78, 0.72]
           : (mi == 1) ? [0.65, 0.30, 0.28]
           :             [0.35, 0.50, 0.58];
        color(mc)
        translate([mmx, mmy, lz])
            difference() {
                cylinder(h = 85, r = 32);
                translate([0, 0, 6]) cylinder(h = 85, r = 25);
            }
    }
}

// Hanging wooden sign with chains, mounted in a wall.
module entrance_sign(x_center, y_face, sign_z, palette=DEFAULT_PALETTE) {
    sign_w = 800; sign_h = 160; sign_t = 25;
    sign_x = x_center - sign_w / 2;

    color([0.50, 0.36, 0.18])
    translate([sign_x, y_face - sign_t + 5, sign_z])
        cube([sign_w, sign_t, sign_h]);
    color([0.65, 0.50, 0.28])
    translate([sign_x + 40, y_face - sign_t + 2, sign_z + 30])
        cube([sign_w - 80, 3, sign_h - 60]);
    color([0.30, 0.30, 0.28])
    for (dx = [80, sign_w - 80]) {
        translate([sign_x + dx, y_face - 5, sign_z + sign_h])
            cylinder(h = 50, r = 4);
        translate([sign_x + dx - 8, y_face - 10, sign_z + sign_h + 45])
            cube([16, 8, 8]);
    }
}
