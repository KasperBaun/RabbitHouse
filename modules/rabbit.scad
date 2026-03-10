// Detailed rabbit in sitting-upright pose.
module rabbit(angle = 0) {
    col_fur   = [0.95, 0.93, 0.90];
    col_brown = [0.55, 0.35, 0.20];
    col_pink  = [0.90, 0.65, 0.65];
    col_eye   = [0.15, 0.08, 0.05];
    col_inner_ear = [0.92, 0.72, 0.72];

    rotate([0, 0, angle]) {
        // === BODY (rounded, plump) ===
        // Main body
        color(col_fur)
        hull() {
            translate([0, 0, 60])
                scale([1, 0.85, 1.2])
                    sphere(r = 85);
            translate([0, 60, 120])
                scale([0.8, 0.75, 0.9])
                    sphere(r = 65);
        }

        // Chest (white, fluffy)
        color(col_fur)
        translate([0, 80, 80])
            scale([0.75, 0.6, 0.9])
                sphere(r = 60);

        // Brown back patch
        color(col_brown)
        translate([0, -20, 110])
            scale([0.6, 0.5, 0.5])
                sphere(r = 55);

        // Brown side spot
        color(col_brown)
        translate([50, 30, 80])
            scale([0.3, 0.5, 0.5])
                sphere(r = 40);

        // === HEAD ===
        color(col_fur)
        translate([0, 120, 155])
            scale([0.9, 1, 0.88])
                sphere(r = 55);

        // Cheeks (puffy)
        color(col_fur)
        for (dx = [-28, 28])
            translate([dx, 155, 130])
                sphere(r = 30);

        // Muzzle/nose area
        color(col_fur)
        translate([0, 185, 125])
            scale([0.7, 1, 0.6])
                sphere(r = 22);

        // Nose (pink)
        color(col_pink)
        translate([0, 195, 130])
            sphere(r = 8);

        // Brown nose marking
        color(col_brown)
        translate([0, 188, 138])
            scale([1.2, 0.8, 0.6])
                sphere(r = 15);

        // Eyes
        for (dx = [-28, 28]) {
            // Eye socket (slight indent look)
            color(col_eye)
            translate([dx, 170, 148])
                sphere(r = 9);
            // Eye highlight
            color([1, 1, 1])
            translate([dx + (dx > 0 ? -2 : 2), 175, 151])
                sphere(r = 3);
        }

        // === EARS (tall, upright, slightly outward) ===
        for (dx = [-22, 22]) {
            tilt = dx > 0 ? 8 : -8;

            // Outer ear
            color(col_fur)
            translate([dx, 130, 185])
                rotate([15, tilt, 0])
                    hull() {
                        sphere(r = 16);
                        translate([0, 0, 100])
                            scale([0.6, 0.4, 1])
                                sphere(r = 14);
                    }

            // Inner ear (pink)
            color(col_inner_ear)
            translate([dx, 128, 190])
                rotate([15, tilt, 0])
                    hull() {
                        scale([0.6, 0.3, 1]) sphere(r = 12);
                        translate([0, 0, 85])
                            scale([0.4, 0.2, 1])
                                sphere(r = 10);
                    }

            // Brown ear tips
            color(col_brown)
            translate([dx, 130, 185])
                rotate([15, tilt, 0])
                    translate([0, 0, 90])
                        scale([0.5, 0.35, 0.4])
                            sphere(r = 14);
        }

        // === FRONT LEGS (tucked under chest) ===
        for (dx = [-25, 25]) {
            color(col_fur)
            translate([dx, 135, 15])
                hull() {
                    sphere(r = 18);
                    translate([0, 20, 50])
                        sphere(r = 15);
                }
            // Paw
            color(col_fur)
            translate([dx, 145, 5])
                scale([0.8, 1.3, 0.5])
                    sphere(r = 16);
        }

        // === BACK LEGS (large haunches, folded) ===
        for (dx = [-40, 40]) {
            // Thigh
            color(col_fur)
            translate([dx, -15, 60])
                scale([1, 1.1, 1.2])
                    sphere(r = 45);

            // Foot (big, long — rabbits have big back feet)
            color(col_fur)
            translate([dx, 30, 8])
                hull() {
                    scale([0.7, 1, 0.4]) sphere(r = 20);
                    translate([0, 60, 0])
                        scale([0.5, 0.8, 0.3]) sphere(r = 15);
                }

            // Brown marking on haunch
            color(col_brown)
            translate([dx * 0.8, -10, 80])
                scale([0.5, 0.5, 0.5])
                    sphere(r = 30);
        }

        // === TAIL (cotton ball) ===
        color(col_fur)
        translate([0, -40, 120])
            sphere(r = 22);
        // Slight brown tinge on tail
        color([0.90, 0.85, 0.80])
        translate([0, -45, 125])
            sphere(r = 15);
    }
}

// A rabbit in a relaxed loaf pose (lying down, legs tucked).
module rabbit_loaf(angle = 0) {
    col_fur   = [0.95, 0.93, 0.90];
    col_brown = [0.55, 0.35, 0.20];
    col_pink  = [0.90, 0.65, 0.65];
    col_eye   = [0.15, 0.08, 0.05];
    col_inner_ear = [0.92, 0.72, 0.72];

    rotate([0, 0, angle]) {
        // === BODY (flatter, loaf shape) ===
        color(col_fur)
        hull() {
            translate([0, 0, 55])
                scale([1, 0.8, 0.65])
                    sphere(r = 95);
            translate([0, 100, 50])
                scale([0.85, 0.85, 0.6])
                    sphere(r = 75);
        }

        // Brown patch on side
        color(col_brown)
        translate([45, 40, 75])
            scale([0.3, 0.7, 0.4])
                sphere(r = 50);

        // === HEAD (resting forward, slightly up) ===
        color(col_fur)
        translate([0, 140, 95])
            scale([0.85, 0.95, 0.82])
                sphere(r = 52);

        // Cheeks
        color(col_fur)
        for (dx = [-24, 24])
            translate([dx, 150, 85])
                sphere(r = 28);

        // Muzzle
        color(col_fur)
        translate([0, 178, 82])
            scale([0.7, 1, 0.55])
                sphere(r = 20);

        // Nose
        color(col_pink)
        translate([0, 188, 86])
            sphere(r = 7);

        // Brown nose marking
        color(col_brown)
        translate([0, 180, 94])
            scale([1.1, 0.7, 0.5])
                sphere(r = 14);

        // Eyes (half-closed / relaxed)
        for (dx = [-26, 26]) {
            color(col_eye)
            translate([dx, 164, 103])
                scale([1, 1, 0.6])
                    sphere(r = 8);
            color([1,1,1])
            translate([dx + (dx > 0 ? -2 : 2), 168, 105])
                sphere(r = 2.5);
        }

        // === EARS (relaxed, slightly back) ===
        for (dx = [-20, 20]) {
            tilt = dx > 0 ? 12 : -12;

            color(col_fur)
            translate([dx, 115, 135])
                rotate([30, tilt, 0])
                    hull() {
                        sphere(r = 15);
                        translate([0, 0, 90])
                            scale([0.55, 0.35, 1])
                                sphere(r = 12);
                    }

            color(col_inner_ear)
            translate([dx, 113, 139])
                rotate([30, tilt, 0])
                    hull() {
                        scale([0.55, 0.25, 1]) sphere(r = 11);
                        translate([0, 0, 78])
                            scale([0.35, 0.18, 1])
                                sphere(r = 9);
                    }

            // Brown ear tips
            color(col_brown)
            translate([dx, 115, 135])
                rotate([30, tilt, 0])
                    translate([0, 0, 82])
                        scale([0.45, 0.3, 0.35])
                            sphere(r = 12);
        }

        // === TUCKED PAWS (barely visible) ===
        for (dx = [-22, 22]) {
            color(col_fur)
            translate([dx, 130, 10])
                scale([0.7, 1.2, 0.4])
                    sphere(r = 16);
        }

        // === BACK LEGS (tucked under, hidden by body) ===
        for (dx = [-38, 38]) {
            color(col_fur)
            translate([dx, -5, 35])
                scale([0.9, 0.9, 0.7])
                    sphere(r = 40);
        }

        // === TAIL ===
        color(col_fur)
        translate([0, -35, 70])
            sphere(r = 20);
    }
}

// Grass floor covering the rabbit area.
module rabbit_floor() {
    floor_z = base_height + 20;
    color([0.35, 0.55, 0.25])
    translate([wall_thickness, wall_thickness, floor_z])
        cube([rabbit_len - wall_thickness - 10, shed_width - 2*wall_thickness, 5]);
}

// Rabbit accessories: shelter, water bowl, food bowl, hay rack, tunnel.
module rabbit_accessories() {
    floor_z = base_height + 25;  // on top of grass

    // === RABBIT SHELTER (small wooden house) ===
    hx = 600;
    hy = shed_width / 2 - 300;
    hw = 700;
    hd = 500;
    hh = 350;
    roof_h = 120;

    // Walls (open front)
    color([0.60, 0.45, 0.25]) {
        // Back
        translate([hx, hy + hd - 15, floor_z])
            cube([hw, 15, hh]);
        // Left side
        translate([hx, hy, floor_z])
            cube([15, hd, hh]);
        // Right side
        translate([hx + hw - 15, hy, floor_z])
            cube([15, hd, hh]);
        // Floor
        translate([hx, hy, floor_z])
            cube([hw, hd, 12]);
    }

    // Roof (pitched, overhangs slightly)
    color([0.50, 0.38, 0.20])
    hull() {
        translate([hx - 30, hy - 30, floor_z + hh])
            cube([hw + 60, hd + 60, 5]);
        translate([hx + hw/2 - 20, hy - 20, floor_z + hh + roof_h])
            cube([40, hd + 40, 5]);
    }

    // Hay inside the shelter
    color([0.78, 0.72, 0.40])
    translate([hx + 20, hy + 20, floor_z + 12])
        cube([hw - 40, hd - 40, 60]);

    // === WATER BOWL (ceramic, near center) ===
    wx = 2200;
    wy = 1200;

    color([0.45, 0.55, 0.70])
    translate([wx, wy, floor_z])
        difference() {
            cylinder(h = 60, r1 = 80, r2 = 90);
            translate([0, 0, 8])
                cylinder(h = 60, r1 = 65, r2 = 80);
        }
    // Water
    color([0.55, 0.70, 0.82, 0.5])
    translate([wx, wy, floor_z + 45])
        cylinder(h = 5, r = 75);

    // === FOOD BOWL (smaller, next to water) ===
    color([0.70, 0.50, 0.30])
    translate([wx + 250, wy + 50, floor_z])
        difference() {
            cylinder(h = 50, r1 = 60, r2 = 70);
            translate([0, 0, 8])
                cylinder(h = 50, r1 = 48, r2 = 60);
        }
    // Pellets
    color([0.55, 0.42, 0.25])
    translate([wx + 250, wy + 50, floor_z + 35])
        cylinder(h = 8, r = 55);

    // === HAY RACK (wall-mounted on back wall) ===
    hrx = 1800;
    hry = shed_width - wall_thickness;
    hrz = floor_z + 200;

    // Rack frame
    color(col_trim) {
        translate([hrx, hry - 5, hrz])
            cube([400, 8, 300]);
        // Bottom angled bars forming a V-shape holder
        for (i = [0 : 5]) {
            bx = hrx + 30 + i * 65;
            translate([bx, hry - 120, hrz])
                cube([8, 120, 8]);
            translate([bx, hry - 80, hrz + 290])
                cube([8, 80, 8]);
        }
        // Bottom rail
        translate([hrx + 20, hry - 125, hrz])
            cube([370, 8, 8]);
    }

    // Hay sticking out
    color([0.78, 0.72, 0.40])
    translate([hrx + 30, hry - 110, hrz + 10])
        cube([350, 80, 250]);

    // === PLAY TUNNEL (woven willow, on its side) ===
    ttx = 3200;
    tty = 2500;

    color([0.50, 0.40, 0.22])
    translate([ttx, tty, floor_z + 120])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = 500, r = 120);
                cylinder(h = 500, r = 100);
            }

    // === SMALL WOODEN PLATFORM / STEP ===
    color([0.58, 0.44, 0.24])
    translate([3500, 800, floor_z])
        cube([500, 350, 80]);
    color([0.55, 0.42, 0.22])
    translate([3500, 800, floor_z + 80])
        cube([500, 350, 15]);

    // === WILLOW BALL (woven chew toy) ===
    color([0.60, 0.48, 0.28])
    translate([2800, 800, floor_z + 50])
        sphere(r = 50);
    // Texture rings to suggest weave
    color([0.55, 0.42, 0.22])
    for (a = [0, 45, 90, 135]) {
        translate([2800, 800, floor_z + 50])
            rotate([a, 0, 0])
                rotate_extrude($fn = 24)
                    translate([45, 0, 0])
                        circle(r = 5);
    }

    // === WOODEN CHEW LOG ===
    color([0.52, 0.38, 0.20])
    translate([1600, 600, floor_z + 30])
        rotate([0, 90, 20])
            cylinder(h = 250, r = 30);
    // Bark texture rings
    color([0.45, 0.32, 0.16])
    for (i = [0 : 3])
        translate([1600 + 50 + i * 55, 600 + (50 + i * 55) * sin(20) * 0.01, floor_z + 30])
            rotate([0, 90, 20])
                cylinder(h = 8, r = 32);

    // === TOSS TOY (small wooden dumbbell) ===
    color([0.65, 0.55, 0.35])
    translate([3000, 1800, floor_z + 20]) {
        sphere(r = 20);
        translate([0, 80, 0]) sphere(r = 20);
        rotate([-90, 0, 0])
            cylinder(h = 80, r = 8);
    }

    // === DIGGING BOX (shallow wooden box with shredded paper) ===
    dbx = 300;
    dby = 800;
    color([0.55, 0.42, 0.22]) {
        // Box walls
        translate([dbx, dby, floor_z])
            cube([400, 350, 12]);  // bottom
        translate([dbx, dby, floor_z])
            cube([12, 350, 120]);
        translate([dbx + 388, dby, floor_z])
            cube([12, 350, 120]);
        translate([dbx, dby, floor_z])
            cube([400, 12, 120]);
        translate([dbx, dby + 338, floor_z])
            cube([400, 12, 120]);
    }
    // Shredded paper/substrate inside
    color([0.88, 0.85, 0.75])
    translate([dbx + 15, dby + 15, floor_z + 12])
        cube([370, 320, 70]);

    // === THE RABBITS ===

    // Rabbit 1: sitting upright near the food bowls, looking toward the front
    translate([wx - 300, wy - 100, floor_z])
        rabbit(angle = -30);

    // Rabbit 2: loafing near the tunnel, relaxed
    translate([ttx - 300, tty + 200, floor_z])
        rabbit_loaf(angle = 160);
}
