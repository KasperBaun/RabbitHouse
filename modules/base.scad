module floor_slab() {
    color(col_base)
        cube([shed_length, shed_width, base_height]);
}

module interior_floor() {
    color(col_floor)
    translate([wall_thickness, wall_thickness, base_height])
        cube([shed_length - 2*wall_thickness, shed_width - 2*wall_thickness, 20]);
}

// Interior lining panels to hide studs on back and right walls
module interior_panels() {
    panel_t = 12;  // 12mm plywood
    panel_h = shed_height - roof_drop_back - 40;  // back wall height minus margin

    // back wall interior panel
    color(col_wall)
    translate([wall_thickness, shed_width - wall_thickness, base_height + 20])
        cube([shed_length - 2*wall_thickness, panel_t, panel_h]);

    // right wall interior panel (with window cutout)
    win_margin = 400;
    win_y = win_margin;
    win_w = shed_width - 2*win_margin;
    win_z = right_side_mesh_z;
    win_h = right_side_mesh_h - roof_drop_back - 80;

    color(col_wall)
    difference() {
        translate([shed_length - wall_thickness - panel_t, wall_thickness, base_height + 20])
            cube([panel_t, shed_width - 2*wall_thickness, panel_h]);
        translate([shed_length - wall_thickness - panel_t - 1, win_y, win_z])
            cube([panel_t + 2, win_w, win_h]);
    }
}
