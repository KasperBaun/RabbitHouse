// Lighting fixtures and electrical outlets.

include <../defaults.scad>

// Pendant lamp hanging from a sloped ceiling.
//   center = [x, y] of the lamp axis
//   roof_z = Z of the roof underside at that (x, y) position
//   drop   = vertical distance from roof to shade
module pendant_lamp(center, roof_z, drop=600, palette=DEFAULT_PALETTE) {
    lx = center[0]; ly = center[1];
    shade_z = roof_z - drop;

    color(pal_lamp(palette))
    translate([lx - 3, ly - 3, shade_z + 150])
        cube([6, 6, roof_z - shade_z - 150]);
    color(pal_lamp(palette))
    translate([lx - 30, ly - 30, roof_z - 15])
        cube([60, 60, 15]);
    color(pal_lamp(palette))
    hull() {
        translate([lx - 60, ly - 60, shade_z + 150]) cube([120, 120, 3]);
        translate([lx - 150, ly - 150, shade_z]) cube([300, 300, 3]);
    }
    color(pal_glow(palette))
    translate([lx - 140, ly - 140, shade_z + 1])
        cube([280, 280, 2]);
}

// String / fairy lights along a sloped path.
// Pass two endpoint vectors and the wire is hung between them with bulbs.
module string_lights_run(p_high, p_low, spacing=200, bulb_r=12, wire_r=2) {
    color([0.15, 0.15, 0.12])
    hull() {
        translate(p_high) sphere(r = wire_r);
        translate(p_low) sphere(r = wire_r);
    }
    dy = p_low[1] - p_high[1];
    n_bulbs = max(1, floor(abs(dy) / spacing));
    for (i = [0 : n_bulbs]) {
        t = i / n_bulbs;
        bp = [p_high[0] + t * (p_low[0] - p_high[0]),
              p_high[1] + t * (p_low[1] - p_high[1]),
              p_high[2] + t * (p_low[2] - p_high[2])];
        color([1.0, 0.88, 0.55, 0.7])
        translate([bp[0], bp[1], bp[2] - 20]) sphere(r = bulb_r);
        color([0.20, 0.20, 0.18])
        translate([bp[0], bp[1], bp[2] - 8])
            cylinder(h = 12, r = 5);
    }
}

// Wall outlet (face plate + 2 socket holes), facing -Y or -X.
module wall_outlet(pos, face_axis="Y", palette=DEFAULT_PALETTE) {
    px = pos[0]; py = pos[1]; pz = pos[2];
    if (face_axis == "Y") {
        color(pal_elec(palette))
        translate([px - 40, py - 3, pz - 55])
            cube([80, 6, 110]);
        color(pal_lamp(palette))
        for (dz = [-22, 22])
            translate([px - 15, py + 2, pz + dz - 15])
                cube([30, 3, 30]);
    } else {
        color(pal_elec(palette))
        translate([px - 3, py - 40, pz - 55])
            cube([6, 80, 110]);
        color(pal_lamp(palette))
        for (dz = [-22, 22])
            translate([px + 2, py - 15, pz + dz - 15])
                cube([3, 30, 30]);
    }
}
