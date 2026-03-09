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
}

