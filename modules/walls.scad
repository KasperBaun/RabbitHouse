module back_wall_core() {
    color(col_wall)
    translate([0, shed_width - wall_thickness, base_height])
        cube([shed_length, wall_thickness, shed_height]);
}

module seat_right_lower_wall() {
    color(col_wall)
    translate([shed_length - wall_thickness, 0, base_height])
        cube([wall_thickness, shed_width, right_side_clad_h]);
}

module seat_right_side_frame() {
    color(col_post) {
        translate([shed_length - wall_thickness, 0, base_height])
            cube([wall_thickness, front_post_w, shed_height]);

        translate([shed_length - wall_thickness, shed_width - front_post_w, base_height])
            cube([wall_thickness, front_post_w, shed_height]);

        translate([shed_length - wall_thickness, front_post_w, right_side_mesh_z - 40])
            cube([wall_thickness, shed_width - 2*front_post_w, 40]);

        translate([shed_length - wall_thickness, front_post_w, base_height + shed_height - front_top_beam_h])
            cube([wall_thickness, shed_width - 2*front_post_w, front_top_beam_h]);
    }
}

module rabbit_left_mesh_frame() {
    color(col_post) {
        translate([0, 0, base_height]) cube([wall_thickness, wall_thickness, shed_height]);
        translate([0, shed_width - wall_thickness, base_height]) cube([wall_thickness, wall_thickness, shed_height]);
        translate([0, wall_thickness, base_height + shed_height - front_top_beam_h])
            cube([wall_thickness, shed_width - 2*wall_thickness, front_top_beam_h]);
    }
}

module rabbit_left_mesh() {
    x = -mesh_depth;
    y = wall_thickness;
    w = shed_width - 2*wall_thickness;
    z = mesh_bottom_z;
    h = shed_height - front_top_beam_h - wall_thickness;

    mesh_panel_y(y, w, z, h, x);
}

module front_posts_and_beam() {
    color(col_post) {
        translate([0, 0, base_height]) cube([front_post_w, wall_thickness, shed_height]);
        translate([rabbit_x1 - front_post_w/2, 0, base_height]) cube([front_post_w, wall_thickness, shed_height]);
        translate([shed_length - front_post_w, 0, base_height]) cube([front_post_w, wall_thickness, shed_height]);

        translate([front_post_w, 0, base_height + shed_height - front_top_beam_h])
            cube([shed_length - 2*front_post_w, wall_thickness, front_top_beam_h]);
    }
}

module front_rabbit_mesh() {
    panel_x = front_post_w;
    panel_w = rabbit_len - front_post_w - 20;
    y = -mesh_depth;
    z = mesh_bottom_z;
    h = mesh_h;

    mesh_panel_x(panel_x, panel_w, z, h, y);
}

module rabbit_seating_mesh_divider() {
    x = rabbit_x1;
    y = wall_thickness;
    w = shed_width - 2 * wall_thickness;
    z = mesh_bottom_z;
    h = shed_height - front_top_beam_h - wall_thickness;

    mesh_panel_y(y, w, z, h, x);
}

module right_side_upper_mesh() {
    panel_y = front_post_w;
    panel_w = shed_width - 2*front_post_w;
    panel_z = right_side_mesh_z;
    panel_h = right_side_mesh_h;
    x = shed_length;

    mesh_panel_y(panel_y, panel_w, panel_z, panel_h, x);
}
