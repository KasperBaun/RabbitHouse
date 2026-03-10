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

// Entrance step and threshold at the seating area opening.
module entrance_step() {
    floor_z = base_height;
    step_w = shed_length - rabbit_x1 - front_post_w * 1.5;
    step_x = rabbit_x1 + front_post_w / 2;

    // Stone step
    color([0.70, 0.68, 0.64])
    translate([step_x, -350, floor_z - 80])
        cube([step_w, 400, 80]);

    // Threshold board (wooden, at the doorway)
    color(col_trim)
    translate([step_x, -50, floor_z])
        cube([step_w, 55, 25]);

    // Welcome mat
    color([0.45, 0.40, 0.30])
    translate([step_x + step_w/2 - 300, -300, floor_z - 2])
        cube([600, 400, 10]);
    // Mat text area (lighter stripe)
    color([0.55, 0.50, 0.40])
    translate([step_x + step_w/2 - 200, -250, floor_z + 8])
        cube([400, 300, 2]);
}

// Corner trim where back and right cladded walls meet.
module corner_trim() {
    trim_w = 50;
    trim_t = 22;
    back_h = shed_height - roof_drop_back;

    color(col_trim) {
        // Back-right corner L-trim
        translate([shed_length + clad_thick - trim_t, shed_width + clad_thick - trim_t, base_height])
            cube([trim_t, trim_t, back_h]);
        translate([shed_length + clad_thick - trim_w, shed_width + clad_thick - trim_t, base_height])
            cube([trim_w, trim_t, back_h]);
        translate([shed_length + clad_thick - trim_t, shed_width + clad_thick - trim_w, base_height])
            cube([trim_t, trim_w, back_h]);
    }
}

// Wooden sign above the seating entrance.
module entrance_sign() {
    sign_w = 800;
    sign_h = 160;
    sign_t = 25;
    sign_x = rabbit_x1 + (shed_length - rabbit_x1) / 2 - sign_w / 2;
    sign_z = base_height + shed_height - front_top_beam_h - sign_h - 30;

    // Sign board
    color([0.50, 0.36, 0.18])
    translate([sign_x, -sign_t + 5, sign_z])
        cube([sign_w, sign_t, sign_h]);

    // Routed/recessed text area
    color([0.65, 0.50, 0.28])
    translate([sign_x + 40, -sign_t + 2, sign_z + 30])
        cube([sign_w - 80, 3, sign_h - 60]);

    // Hanging chains/hooks
    color([0.30, 0.30, 0.28])
    for (dx = [80, sign_w - 80]) {
        translate([sign_x + dx, -5, sign_z + sign_h])
            cylinder(h = 50, r = 4);
        translate([sign_x + dx - 8, -10, sign_z + sign_h + 45])
            cube([16, 8, 8]);
    }
}

// Ground plane, gravel path, and garden plants around the building.
module landscaping() {
    ground_size = 14000;
    gx = shed_length / 2 - ground_size / 2;
    gy = shed_width / 2 - ground_size / 2;

    // Grass ground plane
    color([0.40, 0.58, 0.30])
    translate([gx, gy, -5])
        cube([ground_size, ground_size, 5]);

    // Gravel path to entrance
    path_w = 1200;
    seat_cx = rabbit_x1 + (shed_length - rabbit_x1) / 2;
    color([0.72, 0.68, 0.60])
    translate([seat_cx - path_w/2, -3500, -3])
        cube([path_w, 3500, 8]);

    // Path widens at the step
    color([0.72, 0.68, 0.60])
    hull() {
        translate([seat_cx - path_w/2, -500, -3])
            cube([path_w, 10, 8]);
        translate([seat_cx - path_w/2 - 200, -100, -3])
            cube([path_w + 400, 10, 8]);
    }

}
