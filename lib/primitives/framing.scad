// Stud-wall framing primitives: stud walls, posts, sill/top plates.

include <../defaults.scad>

// Stud wall — bottom plate, top plate, and vertical studs at `spacing`.
// `axis` = "X" (wall runs along +X) or "Y" (wall runs along +Y).
// `origin` = [x, y, z] of the lower outside corner of the wall.
// `face_in` = how far the wall projects into the structure interior (the
//             stud_d direction). For axis="X" the wall sits at y=oy..oy+stud_d;
//             for axis="Y" at x=ox..ox+stud_d.
module stud_wall(origin, length, height, axis="X",
                 stud=DEFAULT_STUD, palette=DEFAULT_PALETTE) {
    sw = ss_w(stud);
    sd = ss_d(stud);
    sp = ss_spacing(stud);
    ox = origin[0]; oy = origin[1]; oz = origin[2];

    color(pal_post(palette)) {
        if (axis == "X") {
            // Bottom plate
            translate([ox, oy, oz])
                cube([length, sd, sw]);
            // Top plate
            translate([ox, oy, oz + height - sw])
                cube([length, sd, sw]);
            // Studs
            stud_h = height - 2 * sw;
            for (x = [0 : sp : length])
                translate([ox + x, oy, oz + sw])
                    cube([sw, sd, stud_h]);
            // End stud
            translate([ox + length - sw, oy, oz + sw])
                cube([sw, sd, stud_h]);
        } else {
            translate([ox, oy, oz])
                cube([sd, length, sw]);
            translate([ox, oy, oz + height - sw])
                cube([sd, length, sw]);
            stud_h = height - 2 * sw;
            for (y = [0 : sp : length])
                translate([ox, oy + y, oz + sw])
                    cube([sd, sw, stud_h]);
            translate([ox, oy + length - sw, oz + sw])
                cube([sd, sw, stud_h]);
        }
    }
}

// A single solid wood post.
module post(origin, size, height, palette=DEFAULT_PALETTE) {
    color(pal_post(palette))
    translate([origin[0], origin[1], origin[2]])
        cube([size[0], size[1], height]);
}

// A horizontal beam between two endpoints (uses hull for sloped beams).
module beam_hull(p1, p2, section, palette=DEFAULT_PALETTE) {
    color(pal_post(palette))
    hull() {
        translate(p1)
            cube([section[0], section[1], section[2]]);
        translate(p2)
            cube([section[0], section[1], section[2]]);
    }
}

// A sloping top beam running along Y, used under a mono-pitch roof.
// The beam lives at x..x+thick (X), spans Y from y0 to y0+len, and slopes from
// h_start at y0 to h_end at y0+len. Section [thick, 0.01, beam_h].
module top_beam_sloped_y(x, y0, len, h_start, h_end, thick=100, beam_h=180,
                         palette=DEFAULT_PALETTE) {
    color(pal_post(palette))
    hull() {
        translate([x, y0, h_start - beam_h])
            cube([thick, 0.01, beam_h]);
        translate([x, y0 + len - 0.01, h_end - beam_h])
            cube([thick, 0.01, beam_h]);
    }
}

// A sloping top beam running along X. Used at v1 left/right side walls and v1
// front-top beam configurations where appropriate.
module top_beam_sloped_x(y, x0, len, h_start, h_end, thick=100, beam_h=180,
                         palette=DEFAULT_PALETTE) {
    color(pal_post(palette))
    hull() {
        translate([x0, y, h_start - beam_h])
            cube([0.01, thick, beam_h]);
        translate([x0 + len - 0.01, y, h_end - beam_h])
            cube([0.01, thick, beam_h]);
    }
}
