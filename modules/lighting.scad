// Pendant lamp hanging over the table.
module pendant_lamp() {
    table_w = shed_length >= 8000 ? 1600 : 1400;
    table_d = shed_width >= 4000 ? 800 : 700;
    tx = seat_x0 + max(200, (seat_len - table_w) / 2);
    ty = shed_width >= 4000 ? 1500 : 1250;

    // Lamp center over table
    lx = tx + table_w / 2;
    ly = ty + table_d / 2;

    // Roof underside Z at this Y position
    roof_z = base_height + shed_height - (ly / shed_width) * roof_drop_back;
    shade_z = roof_z - 600;  // hang 600mm below roof

    // Cord
    color(col_lamp)
    translate([lx - 3, ly - 3, shade_z + 150])
        cube([6, 6, roof_z - shade_z - 150]);

    // Ceiling rose (mounting plate)
    color(col_lamp)
    translate([lx - 30, ly - 30, roof_z - 15])
        cube([60, 60, 15]);

    // Shade — conical using hull()
    color(col_lamp) {
        hull() {
            translate([lx - 60, ly - 60, shade_z + 150])
                cube([120, 120, 3]);
            translate([lx - 150, ly - 150, shade_z])
                cube([300, 300, 3]);
        }
    }

    // Warm glow disk (represents light)
    color(col_glow)
    translate([lx - 140, ly - 140, shade_z + 1])
        cube([280, 280, 2]);
}

// String / fairy lights along the ceiling rafters — warm cozy glow.
module string_lights() {
    bulb_r = 12;
    wire_r = 2;
    spacing = 200;
    z_front = base_height + shed_height - 160;
    z_back = base_height + shed_height - roof_drop_back - 160;

    // Two runs of lights: one along each side of the seating area
    for (offset_x = [seat_x0 + 300, shed_length - 300]) {
        // Wire
        color([0.15, 0.15, 0.12])
        hull() {
            translate([offset_x, wall_thickness, z_front])
                sphere(r = wire_r);
            translate([offset_x, shed_width - wall_thickness, z_back])
                sphere(r = wire_r);
        }

        // Bulbs along the wire
        n_bulbs = floor((shed_width - 2*wall_thickness) / spacing);
        for (i = [0 : n_bulbs]) {
            t = i / n_bulbs;
            by = wall_thickness + t * (shed_width - 2*wall_thickness);
            bz = z_front + t * (z_back - z_front);
            // Warm bulb
            color([1.0, 0.88, 0.55, 0.7])
            translate([offset_x, by, bz - 20])
                sphere(r = bulb_r);
            // Bulb socket
            color([0.20, 0.20, 0.18])
            translate([offset_x, by, bz - 8])
                cylinder(h = 12, r = 5);
        }
    }

    // One run across the front (between the two side runs)
    cross_z = z_front - 5;
    color([0.15, 0.15, 0.12])
    hull() {
        translate([seat_x0 + 300, wall_thickness + 200, cross_z])
            sphere(r = wire_r);
        translate([shed_length - 300, wall_thickness + 200, cross_z])
            sphere(r = wire_r);
    }
    n_cross = floor((shed_length - seat_x0 - 600) / spacing);
    for (i = [0 : n_cross]) {
        t = i / max(1, n_cross);
        bx = seat_x0 + 300 + t * (shed_length - seat_x0 - 600);
        color([1.0, 0.88, 0.55, 0.7])
        translate([bx, wall_thickness + 200, cross_z - 20])
            sphere(r = bulb_r);
        color([0.20, 0.20, 0.18])
        translate([bx, wall_thickness + 200, cross_z - 8])
            cylinder(h = 12, r = 5);
    }
}

// Electrical outlet boxes on the back and right walls.
module electrical_outlets() {
    floor_z = base_height + 20;
    wall_y = shed_width - wall_thickness;
    outlet_z = floor_z + 450 + 300;  // above seat height, reachable

    // Double outlet near the middle of the back bench
    ox1 = seat_x0 + seat_len * 0.35;
    ox2 = seat_x0 + seat_len * 0.7;

    for (ox = [ox1, ox2]) {
        // Outlet face plate
        color(col_elec)
        translate([ox - 40, wall_y - 3, outlet_z - 55])
            cube([80, 6, 110]);

        // Socket holes (two per plate)
        color(col_lamp)
        for (dz = [-22, 22])
            translate([ox - 15, wall_y + 2, outlet_z + dz - 15])
                cube([30, 3, 30]);
    }

    // One outlet on the right wall (near window, for lamp/charger)
    rx = shed_length - wall_thickness;
    ry = shed_width >= 4000 ? 2000 : 1600;
    color(col_elec)
    translate([rx - 3, ry - 40, outlet_z - 55])
        cube([6, 80, 110]);
    color(col_lamp)
    for (dz = [-22, 22])
        translate([rx + 2, ry - 15, outlet_z + dz - 15])
            cube([3, 30, 30]);
}
