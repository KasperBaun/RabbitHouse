module roof() {
    color(col_roof)
    polyhedron(
        points = [
            [-roof_overhang_side, -roof_overhang_front, base_height + shed_height + roof_thickness],
            [shed_length + roof_overhang_side, -roof_overhang_front, base_height + shed_height + roof_thickness],
            [shed_length + roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back + roof_thickness],
            [-roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back + roof_thickness],

            [-roof_overhang_side, -roof_overhang_front, base_height + shed_height],
            [shed_length + roof_overhang_side, -roof_overhang_front, base_height + shed_height],
            [shed_length + roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back],
            [-roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back]
        ],
        faces = [
            [0,1,2,3],
            [4,7,6,5],
            [0,4,5,1],
            [1,5,6,2],
            [2,6,7,3],
            [3,7,4,0]
        ]
    );
}

// Fascia boards around the roof edge and rain gutter on the front (low) side.
module roof_fascia_and_gutter() {
    fascia_h = 140;
    fascia_t = 22;
    x0 = -roof_overhang_side;
    x1 = shed_length + roof_overhang_side;
    y0 = -roof_overhang_front;
    y1 = shed_width + roof_overhang_back;
    z_front = base_height + shed_height;
    z_back = base_height + shed_height - roof_drop_back;

    color(col_trim) {
        // Front fascia (high side)
        translate([x0, y0, z_front - fascia_h])
            cube([x1 - x0, fascia_t, fascia_h]);

        // Back fascia (low side — gutter side)
        translate([x0, y1 - fascia_t, z_back - fascia_h])
            cube([x1 - x0, fascia_t, fascia_h]);

        // Left fascia (sloped)
        hull() {
            translate([x0, y0, z_front - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
            translate([x0, y1, z_back - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
        }

        // Right fascia (sloped)
        hull() {
            translate([x1 - fascia_t, y0, z_front - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
            translate([x1 - fascia_t, y1, z_back - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
        }
    }

    // Rain gutter on the back (low) side
    gutter_w = 100;
    gutter_h = 60;
    gutter_t = 4;
    gutter_z = z_back - fascia_h - 10;

    color([0.40, 0.40, 0.38]) {
        // Gutter trough (U-shape)
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gutter_w, gutter_t]);  // bottom
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gutter_t, gutter_h]);   // inner wall
        translate([x0 + 20, y1 + gutter_w - gutter_t, gutter_z])
            cube([x1 - x0 - 40, gutter_t, gutter_h * 0.7]); // outer wall (lower)

        // Downspout on the right side
        translate([x1 - 80, y1 + gutter_w / 2 - 25, base_height])
            cube([50, 50, gutter_z - base_height]);

        // Downspout elbow at top
        translate([x1 - 80, y1 + gutter_w / 2 - 25, gutter_z - 5])
            cube([50, 50, 15]);
    }
}

// Ceiling rafters visible from inside — structural detail.
module ceiling_rafters() {
    rafter_w = 45;
    rafter_h = 140;
    rafter_spacing = 800;
    z_front = base_height + shed_height;
    z_back = base_height + shed_height - roof_drop_back;

    color(col_post)
    for (x = [wall_thickness : rafter_spacing : shed_length - wall_thickness]) {
        hull() {
            translate([x, wall_thickness, z_front - rafter_h])
                cube([rafter_w, 0.01, rafter_h]);
            translate([x, shed_width - wall_thickness, z_back - rafter_h])
                cube([rafter_w, 0.01, rafter_h]);
        }
    }
}
