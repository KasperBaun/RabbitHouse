// Rabbits and rabbit-zone accessories.

include <../defaults.scad>

// --- The rabbits themselves -------------------------------------------------

module rabbit(angle = 0) {
    col_fur   = [0.95, 0.93, 0.90];
    col_brown = [0.55, 0.35, 0.20];
    col_pink  = [0.90, 0.65, 0.65];
    col_eye   = [0.15, 0.08, 0.05];
    col_inner_ear = [0.92, 0.72, 0.72];

    rotate([0, 0, angle]) {
        color(col_fur)
        hull() {
            translate([0, 0, 60]) scale([1, 0.85, 1.2]) sphere(r = 85);
            translate([0, 60, 120]) scale([0.8, 0.75, 0.9]) sphere(r = 65);
        }
        color(col_fur)
        translate([0, 80, 80]) scale([0.75, 0.6, 0.9]) sphere(r = 60);
        color(col_brown)
        translate([0, -20, 110]) scale([0.6, 0.5, 0.5]) sphere(r = 55);
        color(col_brown)
        translate([50, 30, 80]) scale([0.3, 0.5, 0.5]) sphere(r = 40);

        color(col_fur)
        translate([0, 120, 155]) scale([0.9, 1, 0.88]) sphere(r = 55);
        color(col_fur)
        for (dx = [-28, 28])
            translate([dx, 155, 130]) sphere(r = 30);
        color(col_fur)
        translate([0, 185, 125]) scale([0.7, 1, 0.6]) sphere(r = 22);
        color(col_pink)
        translate([0, 195, 130]) sphere(r = 8);
        color(col_brown)
        translate([0, 188, 138]) scale([1.2, 0.8, 0.6]) sphere(r = 15);

        for (dx = [-28, 28]) {
            color(col_eye) translate([dx, 170, 148]) sphere(r = 9);
            color([1,1,1]) translate([dx + (dx > 0 ? -2 : 2), 175, 151]) sphere(r = 3);
        }

        for (dx = [-22, 22]) {
            tilt = dx > 0 ? 8 : -8;
            color(col_fur) translate([dx, 130, 185]) rotate([15, tilt, 0])
                hull() {
                    sphere(r = 16);
                    translate([0, 0, 100]) scale([0.6, 0.4, 1]) sphere(r = 14);
                }
            color(col_inner_ear) translate([dx, 128, 190]) rotate([15, tilt, 0])
                hull() {
                    scale([0.6, 0.3, 1]) sphere(r = 12);
                    translate([0, 0, 85]) scale([0.4, 0.2, 1]) sphere(r = 10);
                }
            color(col_brown) translate([dx, 130, 185]) rotate([15, tilt, 0])
                translate([0, 0, 90]) scale([0.5, 0.35, 0.4]) sphere(r = 14);
        }

        for (dx = [-25, 25]) {
            color(col_fur) translate([dx, 135, 15])
                hull() {
                    sphere(r = 18);
                    translate([0, 20, 50]) sphere(r = 15);
                }
            color(col_fur) translate([dx, 145, 5])
                scale([0.8, 1.3, 0.5]) sphere(r = 16);
        }
        for (dx = [-40, 40]) {
            color(col_fur) translate([dx, -15, 60])
                scale([1, 1.1, 1.2]) sphere(r = 45);
            color(col_fur) translate([dx, 30, 8])
                hull() {
                    scale([0.7, 1, 0.4]) sphere(r = 20);
                    translate([0, 60, 0]) scale([0.5, 0.8, 0.3]) sphere(r = 15);
                }
            color(col_brown) translate([dx * 0.8, -10, 80])
                scale([0.5, 0.5, 0.5]) sphere(r = 30);
        }
        color(col_fur) translate([0, -40, 120]) sphere(r = 22);
        color([0.90, 0.85, 0.80]) translate([0, -45, 125]) sphere(r = 15);
    }
}

module rabbit_loaf(angle = 0) {
    col_fur   = [0.95, 0.93, 0.90];
    col_brown = [0.55, 0.35, 0.20];
    col_pink  = [0.90, 0.65, 0.65];
    col_eye   = [0.15, 0.08, 0.05];
    col_inner_ear = [0.92, 0.72, 0.72];

    rotate([0, 0, angle]) {
        color(col_fur)
        hull() {
            translate([0, 0, 55]) scale([1, 0.8, 0.65]) sphere(r = 95);
            translate([0, 100, 50]) scale([0.85, 0.85, 0.6]) sphere(r = 75);
        }
        color(col_brown) translate([45, 40, 75]) scale([0.3, 0.7, 0.4]) sphere(r = 50);

        color(col_fur) translate([0, 140, 95]) scale([0.85, 0.95, 0.82]) sphere(r = 52);
        color(col_fur) for (dx = [-24, 24]) translate([dx, 150, 85]) sphere(r = 28);
        color(col_fur) translate([0, 178, 82]) scale([0.7, 1, 0.55]) sphere(r = 20);
        color(col_pink) translate([0, 188, 86]) sphere(r = 7);
        color(col_brown) translate([0, 180, 94]) scale([1.1, 0.7, 0.5]) sphere(r = 14);

        for (dx = [-26, 26]) {
            color(col_eye) translate([dx, 164, 103]) scale([1, 1, 0.6]) sphere(r = 8);
            color([1,1,1]) translate([dx + (dx > 0 ? -2 : 2), 168, 105]) sphere(r = 2.5);
        }
        for (dx = [-20, 20]) {
            tilt = dx > 0 ? 12 : -12;
            color(col_fur) translate([dx, 115, 135]) rotate([30, tilt, 0])
                hull() {
                    sphere(r = 15);
                    translate([0, 0, 90]) scale([0.55, 0.35, 1]) sphere(r = 12);
                }
            color(col_inner_ear) translate([dx, 113, 139]) rotate([30, tilt, 0])
                hull() {
                    scale([0.55, 0.25, 1]) sphere(r = 11);
                    translate([0, 0, 78]) scale([0.35, 0.18, 1]) sphere(r = 9);
                }
            color(col_brown) translate([dx, 115, 135]) rotate([30, tilt, 0])
                translate([0, 0, 82]) scale([0.45, 0.3, 0.35]) sphere(r = 12);
        }
        for (dx = [-22, 22])
            color(col_fur) translate([dx, 130, 10]) scale([0.7, 1.2, 0.4]) sphere(r = 16);
        for (dx = [-38, 38])
            color(col_fur) translate([dx, -5, 35]) scale([0.9, 0.9, 0.7]) sphere(r = 40);
        color(col_fur) translate([0, -35, 70]) sphere(r = 20);
    }
}

// --- Accessories (parametric, place anywhere) -------------------------------

// Small wooden shelter / hide. `origin` = lower-corner; size is fixed.
module rabbit_shelter(origin, w=700, d=500, h=350, roof_h=120) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color([0.60, 0.45, 0.25]) {
        translate([ox, oy + d - 15, oz]) cube([w, 15, h]);
        translate([ox, oy, oz]) cube([15, d, h]);
        translate([ox + w - 15, oy, oz]) cube([15, d, h]);
        translate([ox, oy, oz]) cube([w, d, 12]);
    }
    color([0.50, 0.38, 0.20])
    hull() {
        translate([ox - 30, oy - 30, oz + h]) cube([w + 60, d + 60, 5]);
        translate([ox + w/2 - 20, oy - 20, oz + h + roof_h]) cube([40, d + 40, 5]);
    }
    color([0.78, 0.72, 0.40])
    translate([ox + 20, oy + 20, oz + 12]) cube([w - 40, d - 40, 60]);
}

// Insulated nest box — chew-proof inner skin visible, draught baffle entrance.
module nest_box_insulated(origin, w=1200, d=800, h=600,
                          palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    wall_t = 18;
    insul_t = 35;

    // Outer ply skin
    color(pal_panel1(palette)) {
        translate([ox, oy, oz]) cube([w, wall_t, h]);                       // front
        translate([ox, oy + d - wall_t, oz]) cube([w, wall_t, h]);          // back
        translate([ox, oy, oz]) cube([wall_t, d, h]);                       // left
        translate([ox + w - wall_t, oy, oz]) cube([wall_t, d, h]);          // right
        translate([ox, oy, oz + h - wall_t]) cube([w, d, wall_t]);          // lid
    }
    // Insulation core (visible at front cutaway — render thin band on inside)
    color(pal_insulation(palette))
    translate([ox + wall_t, oy + wall_t, oz + wall_t])
        cube([w - 2*wall_t, insul_t, h - 2*wall_t]);

    // Entrance hole on +X face with a draught baffle just inside
    entrance_w = 200; entrance_h = 250;
    color(pal_panel1(palette))
    translate([ox + w - wall_t, oy + d/2 - entrance_w/2 - 100, oz + 50])
        cube([wall_t, 60, h - 100]);  // baffle wall
}

// Wall-mounted hay rack on a wall facing -Y (back of structure).
// `wall_y` = inside face Y of the back wall.
module hay_rack(x, wall_y, z, w=400, h=300, palette=DEFAULT_PALETTE) {
    color(pal_trim(palette)) {
        translate([x, wall_y - 5, z]) cube([w, 8, h]);
        for (i = [0 : 5]) {
            bx = x + 30 + i * 65;
            translate([bx, wall_y - 120, z]) cube([8, 120, 8]);
            translate([bx, wall_y - 80, z + h - 10]) cube([8, 80, 8]);
        }
        translate([x + 20, wall_y - 125, z]) cube([w - 30, 8, 8]);
    }
    color([0.78, 0.72, 0.40])
    translate([x + 30, wall_y - 110, z + 10]) cube([w - 50, 80, h - 50]);
}

// Ceramic water bowl.
module water_bowl(x, y, z) {
    color([0.45, 0.55, 0.70])
    translate([x, y, z])
        difference() {
            cylinder(h = 60, r1 = 80, r2 = 90);
            translate([0, 0, 8]) cylinder(h = 60, r1 = 65, r2 = 80);
        }
    color([0.55, 0.70, 0.82, 0.5])
    translate([x, y, z + 45]) cylinder(h = 5, r = 75);
}

// Food bowl with pellets.
module food_bowl(x, y, z) {
    color([0.70, 0.50, 0.30])
    translate([x, y, z])
        difference() {
            cylinder(h = 50, r1 = 60, r2 = 70);
            translate([0, 0, 8]) cylinder(h = 50, r1 = 48, r2 = 60);
        }
    color([0.55, 0.42, 0.25])
    translate([x, y, z + 35]) cylinder(h = 8, r = 55);
}

// Wicker play tunnel (half-open cylinder lying on its side).
module play_tunnel(x, y, z, len=500) {
    color([0.50, 0.40, 0.22])
    translate([x, y, z + 120])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = len, r = 120);
                cylinder(h = len, r = 100);
            }
}

// Elevated wooden platform / lookout (rabbits can hop onto it).
module lookout_platform(origin, size=[500, 350, 80], palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color([0.58, 0.44, 0.24])
    translate([ox, oy, oz]) cube(size);
    color([0.55, 0.42, 0.22])
    translate([ox, oy, oz + size[2]]) cube([size[0], size[1], 15]);
}

// Woven willow chew ball.
module willow_ball(x, y, z, r=50) {
    color([0.60, 0.48, 0.28])
    translate([x, y, z]) sphere(r = r);
    color([0.55, 0.42, 0.22])
    for (a = [0, 45, 90, 135])
        translate([x, y, z])
            rotate([a, 0, 0])
                rotate_extrude($fn = 24)
                    translate([r - 5, 0, 0]) circle(r = 5);
}

// Wooden chew log.
module chew_log(x, y, z, len=250, r=30) {
    color([0.52, 0.38, 0.20])
    translate([x, y, z])
        rotate([0, 90, 20]) cylinder(h = len, r = r);
    color([0.45, 0.32, 0.16])
    for (i = [0 : 3])
        translate([x + 50 + i * 55, y + (50 + i * 55) * sin(20) * 0.01, z])
            rotate([0, 90, 20]) cylinder(h = 8, r = r + 2);
}

// Wooden toss dumbbell toy.
module toss_toy(x, y, z) {
    color([0.65, 0.55, 0.35])
    translate([x, y, z]) {
        sphere(r = 20);
        translate([0, 80, 0]) sphere(r = 20);
        rotate([-90, 0, 0]) cylinder(h = 80, r = 8);
    }
}

// Digging box (shallow wooden box with shredded substrate).
module digging_box(origin, w=400, d=350, h=120) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color([0.55, 0.42, 0.22]) {
        translate([ox, oy, oz]) cube([w, d, 12]);
        translate([ox, oy, oz]) cube([12, d, h]);
        translate([ox + w - 12, oy, oz]) cube([12, d, h]);
        translate([ox, oy, oz]) cube([w, 12, h]);
        translate([ox, oy + d - 12, oz]) cube([w, 12, h]);
    }
    color([0.88, 0.85, 0.75])
    translate([ox + 15, oy + 15, oz + 12]) cube([w - 30, d - 30, h - 50]);
}

// Sand / dig pit (open shallow tray with sand).
module dig_tray(origin, w=800, d=800, h=120) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color([0.50, 0.38, 0.20]) {
        translate([ox, oy, oz]) cube([w, d, 15]);
        translate([ox, oy, oz]) cube([15, d, h]);
        translate([ox + w - 15, oy, oz]) cube([15, d, h]);
        translate([ox, oy, oz]) cube([w, 15, h]);
        translate([ox, oy + d - 15, oz]) cube([w, 15, h]);
    }
    color([0.85, 0.78, 0.60])
    translate([ox + 20, oy + 20, oz + 15]) cube([w - 40, d - 40, h - 50]);
}

// Sloped ramp (e.g. up to a lookout).
module ramp(start, end, w=300, t=30) {
    hull() {
        color([0.58, 0.44, 0.24])
        translate(start) cube([w, 0.01, t]);
        color([0.58, 0.44, 0.24])
        translate(end) cube([w, 0.01, t]);
    }
}

// Grass-covered floor patch for the rabbit zone.
module rabbit_floor_grass(origin, size, base_h=120) {
    color([0.35, 0.55, 0.25])
    translate([origin[0], origin[1], base_h + 20])
        cube([size[0], size[1], 5]);
}
