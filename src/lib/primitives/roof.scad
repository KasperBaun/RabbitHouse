// Roof primitives — fascia and gutter for the mono-pitch slab.

include <../defaults.scad>

// Roof fascia (boards around the roof edge) and rain gutter on the back.
module fascia_and_gutter_mono(origin, length, width, drop,
                              fascia_h=140, fascia_t=22,
                              overhang_front=180, overhang_back=100,
                              overhang_side=120, gutter_w=100, gutter_h=60,
                              base_h=0, palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    x0 = ox - overhang_side;
    x1 = ox + length + overhang_side;
    y0 = oy - overhang_front;
    y1 = oy + width + overhang_back;
    z_front = oz;
    z_back  = oz - drop;
    gt = 4;

    color(pal_trim(palette)) {
        translate([x0, y0, z_front - fascia_h])
            cube([x1 - x0, fascia_t, fascia_h]);
        translate([x0, y1 - fascia_t, z_back - fascia_h])
            cube([x1 - x0, fascia_t, fascia_h]);
        hull() {
            translate([x0, y0, z_front - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
            translate([x0, y1, z_back - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
        }
        hull() {
            translate([x1 - fascia_t, y0, z_front - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
            translate([x1 - fascia_t, y1, z_back - fascia_h])
                cube([fascia_t, 0.01, fascia_h]);
        }
    }

    gutter_z = z_back - fascia_h - 10;
    color([0.40, 0.40, 0.38]) {
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gutter_w, gt]);
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gt, gutter_h]);
        translate([x0 + 20, y1 + gutter_w - gt, gutter_z])
            cube([x1 - x0 - 40, gt, gutter_h * 0.7]);
        // Downspout on the right — runs from gutter outflow down to grade
        translate([x1 - 80, y1 + gutter_w / 2 - 25, base_h])
            cube([50, 50, gutter_z - base_h]);
        translate([x1 - 80, y1 + gutter_w / 2 - 25, gutter_z - 5])
            cube([50, 50, 15]);
    }
}
