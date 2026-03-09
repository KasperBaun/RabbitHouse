// Built-in L-shaped corner bench along back + right walls.
// Slatted seat, open leg frame, horizontal backrest planks.
module built_in_corner_bench() {
    seat_h = 450;
    bench_d = 500;
    plank_t = 30;
    plank_w = 110;
    plank_gap = 8;
    leg_w = 50;
    rail_h = 50;
    rail_t = 22;
    floor_z = base_height + 20;
    inset = 90;

    // Back bench: along back wall
    bk_x0 = seat_x0 + inset;
    bk_len = seat_len - inset - wall_thickness - 10;
    bk_y = shed_width - wall_thickness - bench_d;

    // Right bench: along right wall, stops where back bench starts
    rt_y0 = shed_width >= 4000 ? 2000 : 1600;
    rt_x = shed_length - wall_thickness - bench_d;
    rt_len = bk_y - rt_y0;

    n_planks = floor(bench_d / (plank_w + plank_gap));

    // === SEAT PLANKS ===

    // Back bench planks (run along X)
    color(col_bench)
    for (p = [0 : n_planks - 1])
        translate([bk_x0, bk_y + plank_gap + p * (plank_w + plank_gap),
                   floor_z + seat_h - plank_t])
            cube([bk_len, plank_w, plank_t]);

    // Right bench planks (run along Y)
    color(col_bench)
    for (p = [0 : n_planks - 1])
        translate([rt_x + plank_gap + p * (plank_w + plank_gap), rt_y0,
                   floor_z + seat_h - plank_t])
            cube([plank_w, rt_len, plank_t]);

    // Corner seat (fills the L-join)
    color(col_bench)
    for (p = [0 : n_planks - 1])
        translate([rt_x + plank_gap + p * (plank_w + plank_gap),
                   bk_y, floor_z + seat_h - plank_t])
            cube([plank_w, bench_d - 5, plank_t]);

    // === LEGS ===
    color(col_trim) {
        // Back bench legs (pairs along length)
        bk_leg_n = max(2, floor(bk_len / 650));
        for (i = [0 : bk_leg_n]) {
            lx = bk_x0 + 10 + i * (bk_len - leg_w - 20) / bk_leg_n;
            translate([lx, bk_y + 15, floor_z])
                cube([leg_w, leg_w, seat_h - plank_t]);
            translate([lx, shed_width - wall_thickness - leg_w - 15, floor_z])
                cube([leg_w, leg_w, seat_h - plank_t]);
        }

        // Right bench legs (pairs along depth)
        rt_leg_n = max(2, floor(rt_len / 650));
        for (i = [0 : rt_leg_n]) {
            ly = rt_y0 + 10 + i * (rt_len - leg_w - 20) / rt_leg_n;
            translate([rt_x + 15, ly, floor_z])
                cube([leg_w, leg_w, seat_h - plank_t]);
            translate([shed_length - wall_thickness - leg_w - 15, ly, floor_z])
                cube([leg_w, leg_w, seat_h - plank_t]);
        }
    }

    // === APRON RAILS (front edges) ===
    color(col_trim) {
        // Back bench front apron
        translate([bk_x0, bk_y + 8, floor_z + seat_h - plank_t - rail_h - 5])
            cube([bk_len, rail_t, rail_h]);
        // Right bench front apron
        translate([rt_x + 8, rt_y0, floor_z + seat_h - plank_t - rail_h - 5])
            cube([rail_t, rt_len, rail_h]);
    }

    // === BACKRESTS (3 horizontal planks against each wall) ===
    br_w = 90;
    br_t = 22;
    br_gap = 20;

    // Back wall backrest
    color(col_bench)
    for (b = [0 : 2])
        translate([bk_x0, shed_width - wall_thickness - br_t - 5,
                   floor_z + seat_h + 40 + b * (br_w + br_gap)])
            cube([bk_len, br_t, br_w]);

    // Right wall backrest (extends through corner)
    color(col_bench)
    for (b = [0 : 2])
        translate([shed_length - wall_thickness - br_t - 5, rt_y0,
                   floor_z + seat_h + 40 + b * (br_w + br_gap)])
            cube([br_t, rt_len + bench_d, br_w]);

    // === SEAT CUSHIONS (soft puffy pillows) ===
    cushion_h = 80;
    cushion_margin = 30;
    pillow_col = [0.75, 0.42, 0.38];    // warm terracotta
    pillow_col2 = [0.40, 0.52, 0.58];   // muted teal

    // Back bench seat cushion (full length)
    color(pillow_col)
    translate([bk_x0 + cushion_margin, bk_y + cushion_margin,
               floor_z + seat_h])
        hull() {
            cube([bk_len - 2*cushion_margin, bench_d - 2*cushion_margin, 0.1]);
            translate([10, 10, cushion_h])
                cube([bk_len - 2*cushion_margin - 20, bench_d - 2*cushion_margin - 20, 0.1]);
        }

    // Right bench seat cushion
    color(pillow_col)
    translate([rt_x + cushion_margin, rt_y0 + cushion_margin,
               floor_z + seat_h])
        hull() {
            cube([bench_d - 2*cushion_margin, rt_len - 2*cushion_margin, 0.1]);
            translate([10, 10, cushion_h])
                cube([bench_d - 2*cushion_margin - 20, rt_len - 2*cushion_margin - 20, 0.1]);
        }

    // Corner seat cushion
    color(pillow_col)
    translate([rt_x + cushion_margin, bk_y + cushion_margin,
               floor_z + seat_h])
        hull() {
            cube([bench_d - 2*cushion_margin, bench_d - 2*cushion_margin, 0.1]);
            translate([10, 10, cushion_h])
                cube([bench_d - 2*cushion_margin - 20, bench_d - 2*cushion_margin - 20, 0.1]);
        }

    // === BACK PILLOWS (scattered along backrests) ===
    pw = 400;  // pillow width
    ph = 350;  // pillow height
    pd = 120;  // pillow depth (puffy)
    cushion_z = floor_z + seat_h + cushion_h;

    // Back wall — 3 pillows, alternating colors
    for (i = [0 : 2]) {
        pc = (i % 2 == 0) ? pillow_col2 : pillow_col;
        px = bk_x0 + 150 + i * (bk_len - 300 - pw) / 2;
        color(pc)
        translate([px, shed_width - wall_thickness - pd + 10, cushion_z])
            hull() {
                cube([pw, 0.1, ph]);
                translate([20, pd - 20, 20])
                    cube([pw - 40, 0.1, ph - 40]);
            }
    }

    // Right wall — 2 pillows
    for (i = [0 : 1]) {
        pc = (i % 2 == 0) ? pillow_col : pillow_col2;
        py = rt_y0 + 150 + i * (rt_len - 300 - pw) / 1;
        color(pc)
        translate([shed_length - wall_thickness - pd + 10, py, cushion_z])
            hull() {
                cube([0.1, pw, ph]);
                translate([pd - 20, 20, 20])
                    cube([0.1, pw - 40, ph - 40]);
            }
    }

    // Corner — one accent pillow
    color(pillow_col2)
    translate([shed_length - wall_thickness - pd + 5,
               shed_width - wall_thickness - pd + 5, cushion_z])
        rotate([0, 0, -10])
        hull() {
            cube([pd, pd, 300]);
            translate([15, 15, 15])
                cube([pd - 30, pd - 30, 270]);
        }
}

// Trestle-style dining table with solid end panels, stretcher bar, and thick top.
module seating_table() {
    table_w = shed_length >= 8000 ? 2200 : 1800;
    table_d = shed_width >= 4000 ? 900 : 800;
    table_h = 680;
    top_t = 45;
    floor_z = base_height + 20;

    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;

    // --- Table top (thick solid plank) ---
    color(col_table)
    translate([tx - 30, ty - 30, floor_z + table_h])
        cube([table_w + 60, table_d + 60, top_t]);

    // --- Trestle end panels ---
    trestle_inset = 130;
    panel_w = 60;
    panel_d = table_d - 120;
    foot_extra = 50;
    foot_h = 35;

    color(col_trim)
    for (xi = [tx + trestle_inset, tx + table_w - trestle_inset - panel_w]) {
        // Upright panel
        translate([xi, ty + (table_d - panel_d) / 2, floor_z + foot_h])
            cube([panel_w, panel_d, table_h - foot_h]);

        // Wide foot
        translate([xi - foot_extra / 2, ty + (table_d - panel_d) / 2 - foot_extra / 2, floor_z])
            cube([panel_w + foot_extra, panel_d + foot_extra, foot_h]);
    }

    // --- Stretcher bar (connects trestles low down) ---
    str_h = 50;
    str_d = 60;
    str_z = floor_z + table_h * 0.3;
    str_x0 = tx + trestle_inset + panel_w;
    str_x1 = tx + table_w - trestle_inset - panel_w;

    color(col_trim)
    translate([str_x0, ty + table_d / 2 - str_d / 2, str_z])
        cube([str_x1 - str_x0, str_d, str_h]);
}

// Floating wall shelves above the backrests — for books, plants, supplies.
module wall_shelves() {
    shelf_t = 28;
    shelf_d = 220;
    bracket_w = 30;
    bracket_t = 8;
    floor_z = base_height + 20;
    inset = 90;

    // Shelf height: well above head when seated (~1.3m seat + head clearance)
    // Seated eye height ≈ floor_z + 450 + 600 = floor_z + 1050
    // Add clearance so nobody bumps their head
    shelf_z1 = floor_z + 1300;   // lower shelf — above seated head
    shelf_z2 = floor_z + 1650;   // upper shelf

    bk_x0 = seat_x0 + inset;
    bk_len = seat_len - inset - wall_thickness - 200;  // 200mm padding from right wall/window

    // --- Back wall shelves (2 levels) ---
    for (sz = [shelf_z1, shelf_z2]) {
        color(col_shelf)
        translate([bk_x0, shed_width - wall_thickness - shelf_d, sz])
            cube([bk_len, shelf_d, shelf_t]);
    }

    wy = shed_width - wall_thickness - shelf_d + 20;  // Y for items on shelf

    // === LOWER SHELF ITEMS ===

    // Group of books (leaning, different heights)
    bx0 = bk_x0 + 60;
    for (i = [0 : 5]) {
        bk_h = 180 + i * 15;
        bk_w = 25 + (i % 2) * 8;
        bc = (i % 3 == 0) ? [0.65, 0.25, 0.22] :
             (i % 3 == 1) ? [0.22, 0.38, 0.52] :
                            [0.35, 0.50, 0.30];
        color(bc)
        translate([bx0 + i * 35, wy, shelf_z1 + shelf_t])
            cube([bk_w, 140, bk_h]);
    }

    // Bookend (small L-bracket)
    color(col_trim)
    translate([bx0 + 6 * 35 + 5, wy + 20, shelf_z1 + shelf_t])
        cube([8, 100, 120]);

    // Two candles in holders (mid-shelf)
    cx0 = bk_x0 + bk_len * 0.4;
    for (ci = [0, 120]) {
        // Holder
        color(col_trim)
        translate([cx0 + ci, wy + 70, shelf_z1 + shelf_t])
            cylinder(h = 15, r = 30);
        // Candle
        color([0.95, 0.92, 0.85])
        translate([cx0 + ci, wy + 70, shelf_z1 + shelf_t + 15])
            cylinder(h = 100 - ci/3, r = 18);
        // Tiny flame
        color([1.0, 0.85, 0.3, 0.7])
        translate([cx0 + ci, wy + 70, shelf_z1 + shelf_t + 115 - ci/3])
            cylinder(h = 15, r1 = 6, r2 = 0);
    }

    // Small succulent in pot
    sx = bk_x0 + bk_len * 0.65;
    color([0.55, 0.35, 0.20])
    translate([sx, wy + 80, shelf_z1 + shelf_t])
        cylinder(h = 70, r1 = 35, r2 = 40);
    color([0.35, 0.58, 0.32])
    translate([sx, wy + 80, shelf_z1 + shelf_t + 70])
        sphere(r = 45);

    // A mug
    mx = bk_x0 + bk_len * 0.85;
    color([0.85, 0.82, 0.78])
    translate([mx, wy + 80, shelf_z1 + shelf_t])
        difference() {
            cylinder(h = 90, r = 35);
            translate([0, 0, 8])
                cylinder(h = 90, r = 28);
        }
    // Mug handle
    color([0.85, 0.82, 0.78])
    translate([mx + 35, wy + 80, shelf_z1 + shelf_t + 25])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = 15, r = 25);
                cylinder(h = 15, r = 15);
            }

    // === UPPER SHELF ITEMS ===

    // Lantern
    lnx = bk_x0 + 80;
    color(col_lamp) {
        // Base
        translate([lnx, wy + 70, shelf_z2 + shelf_t])
            cylinder(h = 8, r = 45);
        // Frame posts (4 corners)
        for (a = [45, 135, 225, 315])
            translate([lnx + 30 * cos(a), wy + 70 + 30 * sin(a), shelf_z2 + shelf_t + 8])
                cylinder(h = 140, r = 4);
        // Top cap
        translate([lnx, wy + 70, shelf_z2 + shelf_t + 148])
            cylinder(h = 20, r1 = 45, r2 = 15);
    }
    // Lantern glass
    color([1.0, 0.92, 0.6, 0.3])
    translate([lnx, wy + 70, shelf_z2 + shelf_t + 15])
        cylinder(h = 120, r = 35);

    // Three glass jars (tea, sugar, etc.)
    for (ji = [0 : 2]) {
        jx = bk_x0 + bk_len * 0.35 + ji * 100;
        jh = 110 + ji * 10;
        // Jar
        color([0.8, 0.85, 0.82, 0.4])
        translate([jx, wy + 75, shelf_z2 + shelf_t])
            cylinder(h = jh, r = 32);
        // Lid
        color(col_trim)
        translate([jx, wy + 75, shelf_z2 + shelf_t + jh])
            cylinder(h = 12, r = 34);
        // Contents (different fill levels and colors)
        jc = (ji == 0) ? [0.45, 0.30, 0.15] :   // coffee
             (ji == 1) ? [0.70, 0.62, 0.35] :   // sugar
                         [0.55, 0.70, 0.40];     // tea
        color(jc)
        translate([jx, wy + 75, shelf_z2 + shelf_t + 5])
            cylinder(h = jh * 0.6, r = 30);
    }

    // Trailing plant in pot
    px = bk_x0 + bk_len * 0.75;
    color([0.50, 0.35, 0.22])
    translate([px, wy + 75, shelf_z2 + shelf_t])
        cylinder(h = 80, r1 = 40, r2 = 35);
    color([0.30, 0.55, 0.28]) {
        translate([px, wy + 75, shelf_z2 + shelf_t + 80])
            sphere(r = 50);
        // Trailing vine bits hanging over shelf edge
        translate([px - 20, wy - 10, shelf_z2 + shelf_t])
            sphere(r = 25);
        translate([px + 15, wy + 5, shelf_z2 + shelf_t - 15])
            sphere(r = 20);
    }

    // Small framed photo
    fx = bk_x0 + bk_len - 100;
    color(col_trim)
    translate([fx, wy + 160, shelf_z2 + shelf_t])
        cube([80, 12, 100]);
    color([0.9, 0.88, 0.82])
    translate([fx + 8, wy + 159, shelf_z2 + shelf_t + 8])
        cube([64, 2, 84]);
}

// Coffee station — small counter with gas burner, mokka pot, and mini fridge.
// Placed along the right wall, in front of where the bench starts.
module coffee_station() {
    floor_z = base_height + 20;
    rt_y0 = shed_width >= 4000 ? 2000 : 1600;

    // Counter position: against right wall, before the bench
    counter_x = shed_length - wall_thickness - 500;
    counter_y = 250;  // near the front of the right wall
    counter_w = 450;           // depth from wall
    counter_l = 900;           // length along wall
    counter_h = 850;           // standard counter height
    top_t = 30;

    // === COUNTER UNIT ===
    // Legs
    leg = 45;
    color(col_trim)
    for (dx = [20, counter_w - leg - 20])
        for (dy = [20, counter_l - leg - 20])
            translate([counter_x + dx, counter_y + dy, floor_z])
                cube([leg, leg, counter_h - top_t]);

    // Side rails
    color(col_trim) {
        translate([counter_x + 20, counter_y + 20, floor_z + 200])
            cube([leg, counter_l - 40 - leg, 22]);
        translate([counter_x + counter_w - leg - 20, counter_y + 20, floor_z + 200])
            cube([leg, counter_l - 40 - leg, 22]);
    }

    // Counter top
    color(col_shelf)
    translate([counter_x - 15, counter_y - 15, floor_z + counter_h - top_t])
        cube([counter_w + 30, counter_l + 30, top_t]);

    // Back splash (offset from interior panel to avoid z-fighting)
    color(col_shelf)
    translate([shed_length - wall_thickness - 25, counter_y - 15,
               floor_z + counter_h])
        cube([14, counter_l + 30, 200]);

    ctz = floor_z + counter_h;  // counter top Z

    // === GAS BURNER (camping style, 2 rings) ===
    bx = counter_x + counter_w / 2 - 20;
    by = counter_y + 120;

    // Burner body
    color([0.30, 0.30, 0.32])
    translate([bx - 100, by - 60, ctz])
        cube([200, 120, 25]);

    // Grate rings (two burners)
    for (dx = [-50, 50]) {
        color([0.20, 0.20, 0.20])
        translate([bx + dx, by, ctz + 25])
            cylinder(h = 8, r = 45);
        // Grate bars
        color([0.25, 0.25, 0.25])
        for (a = [0, 45, 90, 135])
            translate([bx + dx + 40 * cos(a), by + 40 * sin(a), ctz + 33])
                rotate([0, 0, a])
                    cube([3, 80, 5], center = true);
    }

    // Gas knobs
    color([0.15, 0.15, 0.15])
    for (dx = [-50, 50])
        translate([bx + dx, by - 65, ctz + 10])
            rotate([90, 0, 0])
                cylinder(h = 15, r = 10);

    // === MOKKA POT (classic octagonal Bialetti shape) ===
    mx = counter_x + counter_w / 2 + 130;
    my = counter_y + 130;

    // Bottom chamber
    color([0.60, 0.60, 0.62])
    translate([mx, my, ctz])
        cylinder(h = 60, r1 = 35, r2 = 30, $fn = 8);
    // Waist
    color([0.55, 0.55, 0.58])
    translate([mx, my, ctz + 60])
        cylinder(h = 10, r = 25, $fn = 8);
    // Top chamber
    color([0.60, 0.60, 0.62])
    translate([mx, my, ctz + 70])
        cylinder(h = 55, r1 = 25, r2 = 32, $fn = 8);
    // Lid knob
    color([0.20, 0.20, 0.20])
    translate([mx, my, ctz + 125])
        sphere(r = 10);
    // Handle
    color([0.20, 0.20, 0.20])
    translate([mx + 30, my, ctz + 40])
        cube([8, 8, 70]);
    translate([mx + 30, my, ctz + 110])
        cube([20, 8, 8]);

    // === SMALL CAR COOLER (on counter) ===
    fx = counter_x + 40;
    fy = counter_y + counter_l - 350;
    fw = 280;
    fd = 200;
    fh = 220;

    // Body
    color([0.12, 0.12, 0.14])
    translate([fx, fy, ctz])
        cube([fw, fd, fh]);

    // Lid (slightly lighter)
    color([0.18, 0.18, 0.20])
    translate([fx - 3, fy - 3, ctz + fh])
        cube([fw + 6, fd + 6, 20]);

    // Handle on lid
    color([0.15, 0.15, 0.15])
    translate([fx + fw/2 - 50, fy + fd/2 - 8, ctz + fh + 20])
        hull() {
            cube([100, 16, 5]);
            translate([10, 3, 20])
                cube([80, 10, 5]);
        }

    // Small logo
    color([0.30, 0.55, 0.75])
    translate([fx + fw/2 - 20, fy - 1, ctz + fh/2 - 10])
        cube([40, 2, 20]);

}

// A lifelike rabbit — white with brown markings.
// Posed sitting upright. Place with translate + rotate.
module rabbit(angle = 0) {
    col_fur   = [0.95, 0.93, 0.90];
    col_brown = [0.55, 0.35, 0.20];
    col_pink  = [0.90, 0.65, 0.65];
    col_eye   = [0.15, 0.08, 0.05];
    col_inner_ear = [0.92, 0.72, 0.72];

    rotate([0, 0, angle]) {
        // === BODY (egg shape: big haunches, narrower chest) ===
        // Rear/haunches
        color(col_fur)
        translate([0, 0, 95])
            scale([1, 0.85, 1])
                sphere(r = 95);

        // Chest (smaller, forward)
        color(col_fur)
        translate([0, 100, 80])
            scale([0.8, 0.9, 0.85])
                sphere(r = 75);

        // Smooth body bridge
        color(col_fur)
        hull() {
            translate([0, 30, 100])
                sphere(r = 80);
            translate([0, 90, 85])
                sphere(r = 65);
        }

        // Brown saddle patch on back
        color(col_brown)
        translate([0, 20, 160])
            scale([0.7, 0.8, 0.3])
                sphere(r = 70);

        // === HEAD ===
        color(col_fur)
        translate([0, 145, 140])
            scale([0.85, 0.95, 0.9])
                sphere(r = 55);

        // Cheeks (puffier)
        color(col_fur)
        for (dx = [-25, 25])
            translate([dx, 155, 130])
                sphere(r = 30);

        // Muzzle/nose area
        color(col_fur)
        translate([0, 185, 125])
            scale([0.7, 1, 0.6])
                sphere(r = 22);

        // Nose (pink)
        color(col_pink)
        translate([0, 195, 130])
            sphere(r = 8);

        // Brown nose marking
        color(col_brown)
        translate([0, 188, 138])
            scale([1.2, 0.8, 0.6])
                sphere(r = 15);

        // Eyes
        for (dx = [-28, 28]) {
            // Eye socket (slight indent look)
            color(col_eye)
            translate([dx, 170, 148])
                sphere(r = 9);
            // Eye highlight
            color([1, 1, 1])
            translate([dx + (dx > 0 ? -2 : 2), 175, 151])
                sphere(r = 3);
        }

        // === EARS (tall, upright, slightly outward) ===
        for (dx = [-22, 22]) {
            tilt = dx > 0 ? 8 : -8;

            // Outer ear
            color(col_fur)
            translate([dx, 130, 185])
                rotate([15, tilt, 0])
                    hull() {
                        sphere(r = 16);
                        translate([0, 0, 100])
                            scale([0.6, 0.4, 1])
                                sphere(r = 14);
                    }

            // Inner ear (pink)
            color(col_inner_ear)
            translate([dx, 128, 190])
                rotate([15, tilt, 0])
                    hull() {
                        scale([0.6, 0.3, 1]) sphere(r = 12);
                        translate([0, 0, 85])
                            scale([0.4, 0.2, 1])
                                sphere(r = 10);
                    }

            // Brown ear tips
            color(col_brown)
            translate([dx, 130, 185])
                rotate([15, tilt, 0])
                    translate([0, 0, 90])
                        scale([0.5, 0.35, 0.4])
                            sphere(r = 14);
        }

        // === FRONT LEGS (tucked under chest) ===
        for (dx = [-25, 25]) {
            color(col_fur)
            translate([dx, 135, 15])
                hull() {
                    sphere(r = 18);
                    translate([0, 20, 50])
                        sphere(r = 15);
                }
            // Paw
            color(col_fur)
            translate([dx, 145, 5])
                scale([0.8, 1.3, 0.5])
                    sphere(r = 16);
        }

        // === BACK LEGS (large haunches, folded) ===
        for (dx = [-40, 40]) {
            // Thigh
            color(col_fur)
            translate([dx, -15, 60])
                scale([1, 1.1, 1.2])
                    sphere(r = 45);

            // Foot (big, long — rabbits have big back feet)
            color(col_fur)
            translate([dx, 30, 8])
                hull() {
                    scale([0.7, 1, 0.4]) sphere(r = 20);
                    translate([0, 60, 0])
                        scale([0.5, 0.8, 0.3]) sphere(r = 15);
                }

            // Brown marking on haunch
            color(col_brown)
            translate([dx * 0.8, -10, 80])
                scale([0.5, 0.5, 0.5])
                    sphere(r = 30);
        }

        // === TAIL (cotton ball) ===
        color(col_fur)
        translate([0, -40, 120])
            sphere(r = 22);
        // Slight brown tinge on tail
        color([0.90, 0.85, 0.80])
        translate([0, -45, 125])
            sphere(r = 15);
    }
}

// A rabbit in a relaxed loaf pose (lying down, legs tucked).
module rabbit_loaf(angle = 0) {
    col_fur   = [0.95, 0.93, 0.90];
    col_brown = [0.55, 0.35, 0.20];
    col_pink  = [0.90, 0.65, 0.65];
    col_eye   = [0.15, 0.08, 0.05];
    col_inner_ear = [0.92, 0.72, 0.72];

    rotate([0, 0, angle]) {
        // === BODY (flatter, loaf shape) ===
        color(col_fur)
        hull() {
            translate([0, 0, 55])
                scale([1, 0.8, 0.65])
                    sphere(r = 95);
            translate([0, 100, 50])
                scale([0.85, 0.85, 0.6])
                    sphere(r = 75);
        }

        // Brown patch on side
        color(col_brown)
        translate([45, 40, 75])
            scale([0.3, 0.7, 0.4])
                sphere(r = 50);

        // === HEAD (resting forward, slightly up) ===
        color(col_fur)
        translate([0, 140, 95])
            scale([0.85, 0.95, 0.82])
                sphere(r = 52);

        // Cheeks
        color(col_fur)
        for (dx = [-24, 24])
            translate([dx, 150, 85])
                sphere(r = 28);

        // Muzzle
        color(col_fur)
        translate([0, 178, 82])
            scale([0.7, 1, 0.55])
                sphere(r = 20);

        // Nose
        color(col_pink)
        translate([0, 188, 86])
            sphere(r = 7);

        // Brown nose marking
        color(col_brown)
        translate([0, 180, 94])
            scale([1.1, 0.7, 0.5])
                sphere(r = 14);

        // Eyes (half-closed / relaxed)
        for (dx = [-26, 26]) {
            color(col_eye)
            translate([dx, 164, 103])
                scale([1, 1, 0.6])
                    sphere(r = 8);
            color([1,1,1])
            translate([dx + (dx > 0 ? -2 : 2), 168, 105])
                sphere(r = 2.5);
        }

        // === EARS (relaxed, slightly back) ===
        for (dx = [-20, 20]) {
            tilt = dx > 0 ? 12 : -12;

            color(col_fur)
            translate([dx, 115, 135])
                rotate([30, tilt, 0])
                    hull() {
                        sphere(r = 15);
                        translate([0, 0, 90])
                            scale([0.55, 0.35, 1])
                                sphere(r = 12);
                    }

            color(col_inner_ear)
            translate([dx, 113, 139])
                rotate([30, tilt, 0])
                    hull() {
                        scale([0.55, 0.25, 1]) sphere(r = 11);
                        translate([0, 0, 78])
                            scale([0.35, 0.18, 1])
                                sphere(r = 9);
                    }

            // Brown ear tips
            color(col_brown)
            translate([dx, 115, 135])
                rotate([30, tilt, 0])
                    translate([0, 0, 82])
                        scale([0.45, 0.3, 0.35])
                            sphere(r = 12);
        }

        // === TUCKED PAWS (barely visible) ===
        for (dx = [-22, 22]) {
            color(col_fur)
            translate([dx, 130, 10])
                scale([0.7, 1.2, 0.4])
                    sphere(r = 16);
        }

        // === BACK LEGS (tucked under, hidden by body) ===
        for (dx = [-38, 38]) {
            color(col_fur)
            translate([dx, -5, 35])
                scale([0.9, 0.9, 0.7])
                    sphere(r = 40);
        }

        // === TAIL ===
        color(col_fur)
        translate([0, -35, 70])
            sphere(r = 20);
    }
}

// Grass floor covering the rabbit area.
module rabbit_floor() {
    floor_z = base_height + 20;
    color([0.35, 0.55, 0.25])
    translate([wall_thickness, wall_thickness, floor_z])
        cube([rabbit_len - wall_thickness - 10, shed_width - 2*wall_thickness, 5]);
}

// Rabbit accessories: shelter, water bowl, food bowl, hay rack, tunnel.
module rabbit_accessories() {
    floor_z = base_height + 25;  // on top of grass

    // === RABBIT SHELTER (small wooden house) ===
    hx = 600;
    hy = shed_width / 2 - 300;
    hw = 700;
    hd = 500;
    hh = 350;
    roof_h = 120;

    // Walls (open front)
    color([0.60, 0.45, 0.25]) {
        // Back
        translate([hx, hy + hd - 15, floor_z])
            cube([hw, 15, hh]);
        // Left side
        translate([hx, hy, floor_z])
            cube([15, hd, hh]);
        // Right side
        translate([hx + hw - 15, hy, floor_z])
            cube([15, hd, hh]);
        // Floor
        translate([hx, hy, floor_z])
            cube([hw, hd, 12]);
    }

    // Roof (pitched, overhangs slightly)
    color([0.50, 0.38, 0.20])
    hull() {
        translate([hx - 30, hy - 30, floor_z + hh])
            cube([hw + 60, hd + 60, 5]);
        translate([hx + hw/2 - 20, hy - 20, floor_z + hh + roof_h])
            cube([40, hd + 40, 5]);
    }

    // Hay inside the shelter
    color([0.78, 0.72, 0.40])
    translate([hx + 20, hy + 20, floor_z + 12])
        cube([hw - 40, hd - 40, 60]);

    // === WATER BOWL (ceramic, near center) ===
    wx = 2200;
    wy = 1200;

    color([0.45, 0.55, 0.70])
    translate([wx, wy, floor_z])
        difference() {
            cylinder(h = 60, r1 = 80, r2 = 90);
            translate([0, 0, 8])
                cylinder(h = 60, r1 = 65, r2 = 80);
        }
    // Water
    color([0.55, 0.70, 0.82, 0.5])
    translate([wx, wy, floor_z + 45])
        cylinder(h = 5, r = 75);

    // === FOOD BOWL (smaller, next to water) ===
    color([0.70, 0.50, 0.30])
    translate([wx + 250, wy + 50, floor_z])
        difference() {
            cylinder(h = 50, r1 = 60, r2 = 70);
            translate([0, 0, 8])
                cylinder(h = 50, r1 = 48, r2 = 60);
        }
    // Pellets
    color([0.55, 0.42, 0.25])
    translate([wx + 250, wy + 50, floor_z + 35])
        cylinder(h = 8, r = 55);

    // === HAY RACK (wall-mounted on back wall) ===
    hrx = 1800;
    hry = shed_width - wall_thickness;
    hrz = floor_z + 200;

    // Rack frame
    color(col_trim) {
        translate([hrx, hry - 5, hrz])
            cube([400, 8, 300]);
        // Bottom angled bars forming a V-shape holder
        for (i = [0 : 5]) {
            bx = hrx + 30 + i * 65;
            translate([bx, hry - 120, hrz])
                cube([8, 120, 8]);
            translate([bx, hry - 80, hrz + 290])
                cube([8, 80, 8]);
        }
        // Bottom rail
        translate([hrx + 20, hry - 125, hrz])
            cube([370, 8, 8]);
    }

    // Hay sticking out
    color([0.78, 0.72, 0.40])
    translate([hrx + 30, hry - 110, hrz + 10])
        cube([350, 80, 250]);

    // === PLAY TUNNEL (woven willow, on its side) ===
    ttx = 3200;
    tty = 2500;

    color([0.50, 0.40, 0.22])
    translate([ttx, tty, floor_z + 120])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = 500, r = 120);
                cylinder(h = 500, r = 100);
            }

    // === SMALL WOODEN PLATFORM / STEP ===
    color([0.58, 0.44, 0.24])
    translate([3500, 800, floor_z])
        cube([500, 350, 80]);
    color([0.55, 0.42, 0.22])
    translate([3500, 800, floor_z + 80])
        cube([500, 350, 15]);

    // === WILLOW BALL (woven chew toy) ===
    color([0.60, 0.48, 0.28])
    translate([2800, 800, floor_z + 50])
        sphere(r = 50);
    // Texture rings to suggest weave
    color([0.55, 0.42, 0.22])
    for (a = [0, 45, 90, 135]) {
        translate([2800, 800, floor_z + 50])
            rotate([a, 0, 0])
                rotate_extrude($fn = 24)
                    translate([45, 0, 0])
                        circle(r = 5);
    }

    // === WOODEN CHEW LOG ===
    color([0.52, 0.38, 0.20])
    translate([1600, 600, floor_z + 30])
        rotate([0, 90, 20])
            cylinder(h = 250, r = 30);
    // Bark texture rings
    color([0.45, 0.32, 0.16])
    for (i = [0 : 3])
        translate([1600 + 50 + i * 55, 600 + (50 + i * 55) * sin(20) * 0.01, floor_z + 30])
            rotate([0, 90, 20])
                cylinder(h = 8, r = 32);

    // === TOSS TOY (small wooden dumbbell) ===
    color([0.65, 0.55, 0.35])
    translate([3000, 1800, floor_z + 20]) {
        sphere(r = 20);
        translate([0, 80, 0]) sphere(r = 20);
        rotate([-90, 0, 0])
            cylinder(h = 80, r = 8);
    }

    // === DIGGING BOX (shallow wooden box with shredded paper) ===
    dbx = 300;
    dby = 800;
    color([0.55, 0.42, 0.22]) {
        // Box walls
        translate([dbx, dby, floor_z])
            cube([400, 350, 12]);  // bottom
        translate([dbx, dby, floor_z])
            cube([12, 350, 120]);
        translate([dbx + 388, dby, floor_z])
            cube([12, 350, 120]);
        translate([dbx, dby, floor_z])
            cube([400, 12, 120]);
        translate([dbx, dby + 338, floor_z])
            cube([400, 12, 120]);
    }
    // Shredded paper/substrate inside
    color([0.88, 0.85, 0.75])
    translate([dbx + 15, dby + 15, floor_z + 12])
        cube([370, 320, 70]);

    // === THE RABBITS ===

    // Rabbit 1: sitting upright near the food bowls, looking toward the front
    translate([wx - 300, wy - 100, floor_z])
        rabbit(angle = -30);

    // Rabbit 2: loafing near the tunnel, relaxed
    translate([ttx - 300, tty + 200, floor_z])
        rabbit_loaf(angle = 160);
}

// Pendant lamp hanging over the table.
module pendant_lamp() {
    table_w = shed_length >= 8000 ? 1600 : 1400;
    table_d = shed_width >= 4000 ? 800 : 700;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;

    // Lamp center over table
    lx = tx + table_w / 2;
    ly = ty + table_d / 2;

    // Roof underside Z at this Y position
    roof_z = base_height + shed_height - (ly / shed_width) * roof_drop_back;
    shade_z = roof_z - 600;  // hang 600mm below roof

    // Cord
    color(col_lamp)
    translate([lx - 3, ly - 3, shade_z + 150])
        cube([6, 6, roof_z - shade_z - 150]);

    // Ceiling rose (mounting plate)
    color(col_lamp)
    translate([lx - 30, ly - 30, roof_z - 15])
        cube([60, 60, 15]);

    // Shade — conical using hull()
    color(col_lamp) {
        hull() {
            translate([lx - 60, ly - 60, shade_z + 150])
                cube([120, 120, 3]);
            translate([lx - 150, ly - 150, shade_z])
                cube([300, 300, 3]);
        }
    }

    // Warm glow disk (represents light)
    color(col_glow)
    translate([lx - 140, ly - 140, shade_z + 1])
        cube([280, 280, 2]);
}


// Electrical outlet boxes on the back wall.
module electrical_outlets() {
    floor_z = base_height + 20;
    wall_y = shed_width - wall_thickness;
    outlet_z = floor_z + 450 + 300;  // above seat height, reachable

    // Double outlet near the middle of the back bench
    ox1 = seat_x0 + seat_len * 0.35;
    ox2 = seat_x0 + seat_len * 0.7;

    for (ox = [ox1, ox2]) {
        // Outlet face plate
        color(col_elec)
        translate([ox - 40, wall_y - 3, outlet_z - 55])
            cube([80, 6, 110]);

        // Socket holes (two per plate)
        color(col_lamp)
        for (dz = [-22, 22])
            translate([ox - 15, wall_y + 2, outlet_z + dz - 15])
                cube([30, 3, 30]);
    }

    // One outlet on the right wall (near window, for lamp/charger)
    rx = shed_length - wall_thickness;
    ry = shed_width >= 4000 ? 2000 : 1600;
    color(col_elec)
    translate([rx - 3, ry - 40, outlet_z - 55])
        cube([6, 80, 110]);
    color(col_lamp)
    for (dz = [-22, 22])
        translate([rx + 2, ry - 15, outlet_z + dz - 15])
            cube([3, 30, 30]);
}

// Laptop on the table — open, screen angled back.
module table_laptop() {
    table_w = shed_length >= 8000 ? 2200 : 1800;
    table_d = shed_width >= 4000 ? 900 : 800;
    table_h = 680;
    top_t = 45;
    floor_z = base_height + 20;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;

    // Laptop position on table (offset from center toward the front bench side)
    lx = tx + table_w / 2 - 170;
    ly = ty + 100;
    lz = floor_z + table_h + top_t;

    lap_w = 340;
    lap_d = 230;
    lap_t = 8;
    screen_h = 220;

    // Base (keyboard half)
    color(col_laptop)
    translate([lx, ly, lz])
        cube([lap_w, lap_d, lap_t]);

    // Screen (angled back ~70 degrees from horizontal)
    color(col_laptop)
    translate([lx, ly + lap_d, lz + lap_t])
        rotate([25, 0, 0])
            cube([lap_w, lap_t, screen_h]);

    // Screen face (bright panel)
    color(col_screen)
    translate([lx + 10, ly + lap_d + 1, lz + lap_t])
        rotate([25, 0, 0])
            translate([0, lap_t, 10])
                cube([lap_w - 20, 1, screen_h - 20]);

    // Mugs on the table
    for (mi = [0 : 2]) {
        mmx = tx + 150 + mi * 550;
        mmy = ty + table_d - 200;
        mc = (mi == 0) ? [0.82, 0.78, 0.72] :
             (mi == 1) ? [0.65, 0.30, 0.28] :
                         [0.35, 0.50, 0.58];
        color(mc)
        translate([mmx, mmy, lz])
            difference() {
                cylinder(h = 85, r = 32);
                translate([0, 0, 6])
                    cylinder(h = 85, r = 25);
            }
    }
}

