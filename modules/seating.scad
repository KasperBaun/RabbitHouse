module built_in_corner_bench() {
    seat_h = 450;
    seat_t = 40;
    bench_depth = shed_width >= 4000 ? 600 : 520;
    backrest_t = 60;
    backrest_h = 420;

    rear_len = seat_len - 180;
    side_len = shed_width >= 4000 ? 2200 : 1700;
    side_y0 = shed_width >= 4000 ? 1050 : 850;

    color(col_bench)
    translate([seat_x0 + 90, shed_width - wall_thickness - bench_depth, base_height + 20])
        cube([rear_len, bench_depth, seat_h]);

    color(col_table)
    translate([seat_x0 + 70, shed_width - wall_thickness - bench_depth - 10, base_height + 20 + seat_h])
        cube([rear_len + 40, bench_depth + 10, seat_t]);

    color(col_bench)
    translate([seat_x0 + 90, shed_width - wall_thickness - backrest_t, base_height + 20 + seat_h])
        cube([rear_len, backrest_t, backrest_h]);

    color(col_bench)
    translate([seat_x1 - wall_thickness - bench_depth, side_y0, base_height + 20])
        cube([bench_depth, side_len, seat_h]);

    color(col_table)
    translate([seat_x1 - wall_thickness - bench_depth - 10, side_y0 - 20, base_height + 20 + seat_h])
        cube([bench_depth + 10, side_len + 40, seat_t]);

    color(col_bench)
    translate([seat_x1 - wall_thickness - backrest_t, side_y0, base_height + 20 + seat_h])
        cube([backrest_t, side_len, backrest_h]);
}

module seating_table() {
    table_w = shed_length >= 8000 ? 1800 : 1500;
    table_d = shed_width  >= 4000 ? 900  : 850;
    table_h = 730;
    leg = 70;

    tx = seat_x0 + max(120, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1700 : 1350;

    color(col_table)
    translate([tx, ty, base_height + 20 + table_h])
        cube([table_w, table_d, 50]);

    color(col_trim) {
        translate([tx + 80, ty + 80, base_height + 20])
            cube([leg, leg, table_h]);

        translate([tx + table_w - 80 - leg, ty + 80, base_height + 20])
            cube([leg, leg, table_h]);

        translate([tx + 80, ty + table_d - 80 - leg, base_height + 20])
            cube([leg, leg, table_h]);

        translate([tx + table_w - 80 - leg, ty + table_d - 80 - leg, base_height + 20])
            cube([leg, leg, table_h]);
    }
}
