module klink_board(len, col) {
    color(col)
        cube([len, clad_thick, clad_board_h]);
}

module back_cladding() {
    for (i = [0 : floor((shed_height - roof_drop_back - 1) / clad_step)]) {
        z = i * clad_step;
        c = (i % 2 == 0) ? col_panel1 : col_panel2;
        translate([0, shed_width - clad_thick, base_height + z])
            klink_board(shed_length, c);
    }

    color(col_trim) {
        translate([0, shed_width - clad_thick, base_height + shed_height - roof_drop_back - 60])
cube([shed_length, clad_thick, 60]);

        translate([0, shed_width - clad_thick - clad_lip, base_height])
            cube([40, clad_thick + clad_lip, shed_height]);

        translate([shed_length - 40, shed_width - clad_thick - clad_lip, base_height])
            cube([40, clad_thick + clad_lip, shed_height]);
    }
}

module right_side_lower_cladding() {
    side_len = shed_width;
    max_z = right_side_clad_h;

    for (i = [0 : floor((max_z - 1) / clad_step)]) {
        z = i * clad_step;
        c = (i % 2 == 0) ? col_panel1 : col_panel2;
        translate([shed_length - clad_thick, 0, base_height + z])
            rotate([0,0,90])
                klink_board(side_len, c);
    }

    color(col_trim) {
        translate([shed_length - clad_thick - clad_lip, 0, base_height])
            cube([clad_thick + clad_lip, 40, max_z]);

        translate([shed_length - clad_thick - clad_lip, shed_width - 40, base_height])
            cube([clad_thick + clad_lip, 40, max_z]);

        translate([shed_length - clad_thick - clad_lip, 0, base_height + max_z - 40])
            cube([clad_thick + clad_lip, shed_width, 40]);
    }
}
