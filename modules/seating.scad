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
    rt_y0 = shed_width >= 4000 ? 1100 : 900;
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
    table_w = shed_length >= 8000 ? 1600 : 1400;
    table_d = shed_width >= 4000 ? 800 : 700;
    table_h = 730;
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
