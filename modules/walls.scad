stud_w = 45;
stud_d = 95;

module back_wall_core() {
    back_wall_h = shed_height - roof_drop_back;
    post_spacing = 2000;

    color(col_post) {
        // bundrem (bottom plate)
        translate([0, shed_width - stud_d, base_height])
            cube([shed_length, stud_d, stud_w]);

        // toprem (top plate)
        translate([0, shed_width - stud_d, base_height + back_wall_h - stud_w])
            cube([shed_length, stud_d, stud_w]);

        // stolper (vertical posts at 2m intervals for roof support)
        stud_h = back_wall_h - 2 * stud_w;
        for (x = [0 : post_spacing : shed_length]) {
            translate([x, shed_width - stud_d, base_height + stud_w])
                cube([stud_w, stud_d, stud_h]);
        }
        // ensure a post at the far end
        translate([shed_length - stud_w, shed_width - stud_d, base_height + stud_w])
            cube([stud_w, stud_d, stud_h]);
    }
}

module rabbit_left_mesh_frame() {
    color(col_post) {
        translate([0, 0, base_height]) cube([wall_thickness, wall_thickness, shed_height]);
        translate([0, shed_width - wall_thickness, base_height]) cube([wall_thickness, wall_thickness, shed_height - roof_drop_back]);
        hull() {
            translate([0, wall_thickness, base_height + shed_height - front_top_beam_h])
                cube([wall_thickness, 0.01, front_top_beam_h]);
            translate([0, shed_width - wall_thickness - 0.01, base_height + shed_height - roof_drop_back - front_top_beam_h])
                cube([wall_thickness, 0.01, front_top_beam_h]);
        }

        // Bottom sill plate under left side mesh
        translate([0, wall_thickness, base_height])
            cube([wall_thickness, shed_width - 2*wall_thickness, wall_thickness]);
    }
}

module rabbit_left_mesh() {
    x = -mesh_depth;
    y = wall_thickness;
    w = shed_width - 2*wall_thickness;
    z = mesh_bottom_z;
    h = shed_height - front_top_beam_h - wall_thickness - roof_drop_back;

    mesh_panel_y(y, w, z, h, x);

    color(col_post)
    hull() {
        translate([x, y, z + h])
            cube([mesh_depth, 0.01, roof_drop_back]);
        translate([x, y + w - 0.01, z + h])
            cube([mesh_depth, 0.01, 0.01]);
    }
}

// Right side frame (mirror of left side)
module rabbit_right_mesh_frame() {
    color(col_post) {
        translate([shed_length - wall_thickness, 0, base_height])
            cube([wall_thickness, wall_thickness, shed_height]);
        translate([shed_length - wall_thickness, shed_width - wall_thickness, base_height])
            cube([wall_thickness, wall_thickness, shed_height - roof_drop_back]);
        hull() {
            translate([shed_length - wall_thickness, wall_thickness, base_height + shed_height - front_top_beam_h])
                cube([wall_thickness, 0.01, front_top_beam_h]);
            translate([shed_length - wall_thickness, shed_width - wall_thickness - 0.01, base_height + shed_height - roof_drop_back - front_top_beam_h])
                cube([wall_thickness, 0.01, front_top_beam_h]);
        }

        // Bottom sill plate under right side mesh
        translate([shed_length - wall_thickness, wall_thickness, base_height])
            cube([wall_thickness, shed_width - 2*wall_thickness, wall_thickness]);
    }
}

// Right side mesh (on outside of right wall)
module rabbit_right_mesh() {
    x = shed_length;
    y = wall_thickness;
    w = shed_width - 2*wall_thickness;
    z = mesh_bottom_z;
    h = shed_height - front_top_beam_h - wall_thickness - roof_drop_back;

    mesh_panel_y(y, w, z, h, x);

    color(col_post)
    hull() {
        translate([x, y, z + h])
            cube([mesh_depth, 0.01, roof_drop_back]);
        translate([x, y + w - 0.01, z + h])
            cube([mesh_depth, 0.01, 0.01]);
    }
}

// Back wall mesh (on outside of back wall)
module rabbit_back_mesh() {
    back_mesh_h = shed_height - roof_drop_back - front_top_beam_h - wall_thickness;
    x0 = wall_thickness;
    panel_w = shed_length - 2*wall_thickness;
    y_pos = shed_width;
    z = mesh_bottom_z;

    mesh_panel_x(x0, panel_w, z, back_mesh_h, y_pos);
}

// Front posts and beam with centered gate opening
module front_posts_and_beam() {
    gx = shed_length / 2 - gate_w / 2;

    color(col_post) {
        // Left corner post
        translate([0, 0, base_height])
            cube([front_post_w, wall_thickness, shed_height]);
        // Right corner post
        translate([shed_length - front_post_w, 0, base_height])
            cube([front_post_w, wall_thickness, shed_height]);

        // Gate left post
        translate([gx - front_post_w, 0, base_height])
            cube([front_post_w, wall_thickness, shed_height]);
        // Gate right post
        translate([gx + gate_w, 0, base_height])
            cube([front_post_w, wall_thickness, shed_height]);

        // Top beam (full length)
        translate([front_post_w, 0, base_height + shed_height - front_top_beam_h])
            cube([shed_length - 2*front_post_w, wall_thickness, front_top_beam_h]);

        // Bottom sill plate — left of gate
        translate([front_post_w, 0, base_height])
            cube([gx - front_post_w - front_post_w, wall_thickness, wall_thickness]);

        // Bottom sill plate — right of gate
        translate([gx + gate_w + front_post_w, 0, base_height])
            cube([shed_length - front_post_w - gx - gate_w - front_post_w, wall_thickness, wall_thickness]);
    }
}

// Front mesh panels (left and right of gate)
module front_rabbit_mesh() {
    gx = shed_length / 2 - gate_w / 2;
    y = -mesh_depth;
    z = mesh_bottom_z;
    h = mesh_h;

    // Left panel
    left_x = front_post_w;
    left_w = gx - front_post_w - left_x;
    if (left_w > 20)
        mesh_panel_x(left_x, left_w, z, h, y);

    // Right panel
    right_x = gx + gate_w + front_post_w;
    right_w = shed_length - front_post_w - right_x;
    if (right_w > 20)
        mesh_panel_x(right_x, right_w, z, h, y);
}

// Mesh gate (shown closed)
module front_gate() {
    gx = shed_length / 2 - gate_w / 2;
    z = mesh_bottom_z;
    h = mesh_h;

    mesh_panel_x(gx, gate_w, z, h, -mesh_depth);

    // Gate handle
    color(col_trim)
    translate([gx + gate_w - 80, -mesh_depth - 15, z + 900])
        cube([30, 15, 60]);
}
