module klink_board(len, col) {
    color(col)
    hull() {
        cube([len, clad_thick, 0.1]);
        translate([0, 0, clad_board_h - 0.1])
            cube([len, 5, 0.1]);
    }
}

module back_cladding() {
    wall_h = shed_height - roof_drop_back;
    n = ceil(wall_h / clad_step) - 1;

    for (i = [0 : n]) {
        z = i * clad_step;
        c = (i % 2 == 0) ? col_panel1 : col_panel2;
        translate([0, shed_width, base_height + z])
            klink_board(shed_length, c);
    }
}

// Right side — full boards clipped to roof slope using difference().
module right_side_cladding() {
    win_margin = 400;
    win_y0 = win_margin;
    win_y1 = shed_width - win_margin;
    win_z0 = right_side_mesh_z;
    win_z1 = win_z0 + right_side_mesh_h - roof_drop_back - 80;

    wall_h = shed_height - front_top_beam_h;
    n = ceil(wall_h / clad_step) - 1;

    difference() {
        // All boards at full width
        for (i = [0 : n]) {
            z = i * clad_step;
            abs_z = base_height + z;
            c = (i % 2 == 0) ? col_panel1 : col_panel2;

            board_top = abs_z + clad_board_h;
            in_window = (board_top > win_z0 && abs_z < win_z1);

            if (in_window) {
                if (win_y0 > 10)
                    translate([shed_length, win_y0, abs_z])
                        rotate([0, 0, -90])
                            klink_board(win_y0, c);
                if (shed_width - win_y1 > 10)
                    translate([shed_length, shed_width, abs_z])
                        rotate([0, 0, -90])
                            klink_board(shed_width - win_y1, c);
            } else {
                translate([shed_length, shed_width, abs_z])
                    rotate([0, 0, -90])
                        klink_board(shed_width, c);
            }
        }

        // Cut away everything above the roof underside
        hull() {
            translate([shed_length - 50, -10, base_height + shed_height])
                cube([100, 1, 1000]);
            translate([shed_length - 50, shed_width + 10, base_height + shed_height - roof_drop_back])
                cube([100, 1, 1000]);
        }
    }
}
