clad_out = 4;

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

module right_side_lower_cladding() {
}
