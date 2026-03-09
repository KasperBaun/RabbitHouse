stud_w = 45;
stud_d = 95;
stud_spacing = 600;

module back_wall_core() {
    back_wall_h = shed_height - roof_drop_back;

    color(col_post) {
        // bundrem (bottom plate)
        translate([0, shed_width - stud_d, base_height])
            cube([shed_length, stud_d, stud_w]);

        // toprem (top plate)
        translate([0, shed_width - stud_d, base_height + back_wall_h - stud_w])
            cube([shed_length, stud_d, stud_w]);

        // stolper (vertical studs)
        stud_h = back_wall_h - 2 * stud_w;
        for (x = [0 : stud_spacing : shed_length]) {
            translate([x, shed_width - stud_d, base_height + stud_w])
                cube([stud_w, stud_d, stud_h]);
        }
        // ensure a stud at the far end
        translate([shed_length - stud_w, shed_width - stud_d, base_height + stud_w])
            cube([stud_w, stud_d, stud_h]);
    }
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
            cube([wall_thickness, front_post_w, shed_height - roof_drop_back]);

        translate([shed_length - wall_thickness, front_post_w, right_side_mesh_z - 40])
            cube([wall_thickness, shed_width - 2*front_post_w, 40]);

        hull() {
            translate([shed_length - wall_thickness, front_post_w, base_height + shed_height - front_top_beam_h])
                cube([wall_thickness, 0.01, front_top_beam_h]);
            translate([shed_length - wall_thickness, shed_width - front_post_w - 0.01, base_height + shed_height - roof_drop_back - front_top_beam_h])
                cube([wall_thickness, 0.01, front_top_beam_h]);
        }
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
    glass_split_z = base_height + 1200;  // mesh below, glass above

    // Mesh height: from floor to split point
    mesh_h = glass_split_z - z;
    mesh_panel_y(y, w, z, mesh_h, x);

    // Horizontal divider beam at split
    color(col_post)
    translate([x, y, glass_split_z - 20])
        cube([mesh_depth, w, 40]);

    // Glass panel above the beam, up to the sloped roof line
    // Front height (Y=0 side): shed_height - front_top_beam_h
    // Back height (Y=shed_width side): shed_height - front_top_beam_h - roof_drop_back
    glass_z0 = glass_split_z + 20;
    front_top = base_height + shed_height - front_top_beam_h;
    back_top = front_top - roof_drop_back;

    color(col_glass)
    hull() {
        translate([x + 2, y, glass_z0])
            cube([6, 0.01, front_top - glass_z0]);
        translate([x + 2, y + w, glass_z0])
            cube([6, 0.01, back_top - glass_z0]);
    }

    // Wooden frame around the glass
    color(col_post) {
        // Bottom rail (already the divider beam above)
        // Left post (front side)
        translate([x, y, glass_z0])
            cube([mesh_depth, wall_thickness, front_top - glass_z0]);
        // Right post (back side)
        translate([x, y + w - wall_thickness, glass_z0])
            cube([mesh_depth, wall_thickness, back_top - glass_z0]);
        // Sloped top rail
        hull() {
            translate([x, y, front_top - 40])
                cube([mesh_depth, 0.01, 40]);
            translate([x, y + w, back_top - 40])
                cube([mesh_depth, 0.01, 40]);
        }
    }
}

module right_side_window() {
    // window opening matches cladding cutout
    win_margin = 400;
    win_y = win_margin;
    win_w = shed_width - 2*win_margin;
    win_z = right_side_mesh_z;
    win_h = right_side_mesh_h - roof_drop_back - 80;
    x = shed_length;

    // trim dimensions (like a real carpenter would do)
    architrave_w = 70;    // width of side/head trim
    architrave_t = 20;    // thickness
    sill_depth = 45;      // how far sill projects from cladding face
    sill_t = 55;          // sill thickness — extends down to cover gap with cladding
    sill_drip = 8;        // drip edge overhang
    muntin_w = 25;        // muntin bar width
    muntin_t = 18;        // muntin depth

    // glass pane (set behind the trim)
    color(col_glass)
    translate([x + architrave_t/2, win_y, win_z])
        cube([6, win_w, win_h]);

    // --- Window frame (karm) — the actual frame sitting in the opening ---
    color(col_post) {
        frame_t = 45;  // frame depth
        frame_w = 30;  // frame face width
        // bottom
        translate([x - frame_t/2, win_y, win_z])
            cube([frame_t, win_w, frame_w]);
        // top
        translate([x - frame_t/2, win_y, win_z + win_h - frame_w])
            cube([frame_t, win_w, frame_w]);
        // left
        translate([x - frame_t/2, win_y, win_z])
            cube([frame_t, frame_w, win_h]);
        // right
        translate([x - frame_t/2, win_y + win_w - frame_w, win_z])
            cube([frame_t, frame_w, win_h]);
    }

    // --- Muntins (sprosser) — cross bars dividing into 4 panes ---
    color(col_post) {
        // horizontal muntin
        translate([x - muntin_t/2, win_y + 30, win_z + win_h/2 - muntin_w/2])
            cube([muntin_t, win_w - 60, muntin_w]);
        // vertical muntin
        translate([x - muntin_t/2, win_y + win_w/2 - muntin_w/2, win_z + 30])
            cube([muntin_t, muntin_w, win_h - 60]);
    }

    // --- Sill (bundstykke) — projects outward, angled for drainage ---
    color(col_trim)
    hull() {
        // back edge (flush with wall)
        translate([x, win_y - sill_drip, win_z - sill_t])
            cube([0.1, win_w + 2*sill_drip, sill_t]);
        // front edge (projects out, slightly lower for drainage)
        translate([x + sill_depth, win_y - sill_drip, win_z - sill_t - 5])
            cube([0.1, win_w + 2*sill_drip, sill_t - 5]);
    }

    // --- Architrave / indfatning (trim around the outside) ---
    color(col_trim) {
        // head trim (overstykke) — slightly wider than sides
        translate([x + clad_thick - 2, win_y - architrave_w + 10, win_z + win_h])
            cube([architrave_t, win_w + 2*architrave_w - 20, architrave_w]);

        // left side trim
        translate([x + clad_thick - 2, win_y - architrave_w + 10, win_z])
            cube([architrave_t, architrave_w, win_h]);

        // right side trim
        translate([x + clad_thick - 2, win_y + win_w - 10, win_z])
            cube([architrave_t, architrave_w, win_h]);
    }

    // --- Drip cap (vandnæse) above head trim ---
    color(col_trim)
    hull() {
        translate([x + clad_thick - 2, win_y - architrave_w, win_z + win_h + architrave_w])
            cube([architrave_t + 8, win_w + 2*architrave_w, 3]);
        translate([x + clad_thick + architrave_t + 5, win_y - architrave_w, win_z + win_h + architrave_w - 8])
            cube([0.1, win_w + 2*architrave_w, 3]);
    }
}
