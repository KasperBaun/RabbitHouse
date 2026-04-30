// Roof primitives — mono-pitch, gable, and translucent polycarbonate variants.
// Plus fascia, gutter, and visible ceiling rafters.

include <../defaults.scad>

// Mono-pitched roof slab. High edge at Y=y0, drops to (h - drop) at Y=y1.
//   origin = [x0, y0, eave_h]  (lower-front-high corner of the structure)
//   length = X span, width = Y span (Y is the slope direction)
//   drop   = vertical drop from y0 (high) to y1 (low)
//   thick  = roof slab thickness
//   overhang_front/back/side = projection beyond x0/y0/y1
module roof_mono_pitch(origin, length, width, drop, thick=80,
                      overhang_front=180, overhang_back=100,
                      overhang_side=120, palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color(pal_roof(palette))
    polyhedron(
        points = [
            [ox - overhang_side, oy - overhang_front, oz + thick],
            [ox + length + overhang_side, oy - overhang_front, oz + thick],
            [ox + length + overhang_side, oy + width + overhang_back, oz - drop + thick],
            [ox - overhang_side, oy + width + overhang_back, oz - drop + thick],
            [ox - overhang_side, oy - overhang_front, oz],
            [ox + length + overhang_side, oy - overhang_front, oz],
            [ox + length + overhang_side, oy + width + overhang_back, oz - drop],
            [ox - overhang_side, oy + width + overhang_back, oz - drop]
        ],
        faces = [
            [0,1,2,3], [4,7,6,5],
            [0,4,5,1], [1,5,6,2],
            [2,6,7,3], [3,7,4,0]
        ]
    );
}

// Gable roof slab with ridge running along the Y axis at X = x0 + length/2.
// Two roof planes meet at the ridge. Eaves at X=x0 and X=x0+length, both
// at height eave_h; ridge at the centerline at height ridge_h.
module roof_gable_y(origin, length, width, eave_h, ridge_h, thick=80,
                    overhang_eave=120, overhang_gable=180,
                    palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz_eave = eave_h; oz_ridge = ridge_h;
    // Left plane: from X=ox-oh_eave (eave) up to X=ox+length/2 (ridge).
    color(pal_roof(palette))
    polyhedron(
        points = [
            [ox - overhang_eave, oy - overhang_gable, oz_eave + thick],
            [ox + length/2,      oy - overhang_gable, oz_ridge + thick],
            [ox + length/2,      oy + width + overhang_gable, oz_ridge + thick],
            [ox - overhang_eave, oy + width + overhang_gable, oz_eave + thick],
            [ox - overhang_eave, oy - overhang_gable, oz_eave],
            [ox + length/2,      oy - overhang_gable, oz_ridge],
            [ox + length/2,      oy + width + overhang_gable, oz_ridge],
            [ox - overhang_eave, oy + width + overhang_gable, oz_eave]
        ],
        faces = [
            [0,1,2,3], [4,7,6,5],
            [0,4,5,1], [1,5,6,2],
            [2,6,7,3], [3,7,4,0]
        ]
    );
    // Right plane: from X=ox+length/2 (ridge) down to X=ox+length+oh_eave (eave).
    color(pal_roof(palette))
    polyhedron(
        points = [
            [ox + length/2,                  oy - overhang_gable, oz_ridge + thick],
            [ox + length + overhang_eave,    oy - overhang_gable, oz_eave + thick],
            [ox + length + overhang_eave,    oy + width + overhang_gable, oz_eave + thick],
            [ox + length/2,                  oy + width + overhang_gable, oz_ridge + thick],
            [ox + length/2,                  oy - overhang_gable, oz_ridge],
            [ox + length + overhang_eave,    oy - overhang_gable, oz_eave],
            [ox + length + overhang_eave,    oy + width + overhang_gable, oz_eave],
            [ox + length/2,                  oy + width + overhang_gable, oz_ridge]
        ],
        faces = [
            [0,1,2,3], [4,7,6,5],
            [0,4,5,1], [1,5,6,2],
            [2,6,7,3], [3,7,4,0]
        ]
    );
}

// Gable roof with the ridge running ALONG THE X AXIS at Y = oy + width/2.
// The slope is in the Y direction. Eaves are at Y=oy and Y=oy+width;
// gable end walls are at X=ox and X=ox+length.
module roof_gable_x(origin, length, width, eave_h, ridge_h, thick=80,
                    overhang_eave=120, overhang_gable=180,
                    palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1];
    // Front plane (Y < width/2): from front eave up to ridge
    color(pal_roof(palette))
    polyhedron(
        points = [
            [ox - overhang_gable,            oy - overhang_eave,  eave_h + thick],   // 0
            [ox + length + overhang_gable,   oy - overhang_eave,  eave_h + thick],   // 1
            [ox + length + overhang_gable,   oy + width/2,        ridge_h + thick],  // 2
            [ox - overhang_gable,            oy + width/2,        ridge_h + thick],  // 3
            [ox - overhang_gable,            oy - overhang_eave,  eave_h],           // 4
            [ox + length + overhang_gable,   oy - overhang_eave,  eave_h],           // 5
            [ox + length + overhang_gable,   oy + width/2,        ridge_h],          // 6
            [ox - overhang_gable,            oy + width/2,        ridge_h]           // 7
        ],
        faces = [
            [0,1,2,3], [4,7,6,5],
            [0,4,5,1], [1,5,6,2],
            [2,6,7,3], [3,7,4,0]
        ]
    );
    // Back plane (Y > width/2): from ridge down to back eave
    color(pal_roof(palette))
    polyhedron(
        points = [
            [ox - overhang_gable,            oy + width/2,                ridge_h + thick],
            [ox + length + overhang_gable,   oy + width/2,                ridge_h + thick],
            [ox + length + overhang_gable,   oy + width + overhang_eave,  eave_h + thick],
            [ox - overhang_gable,            oy + width + overhang_eave,  eave_h + thick],
            [ox - overhang_gable,            oy + width/2,                ridge_h],
            [ox + length + overhang_gable,   oy + width/2,                ridge_h],
            [ox + length + overhang_gable,   oy + width + overhang_eave,  eave_h],
            [ox - overhang_gable,            oy + width + overhang_eave,  eave_h]
        ],
        faces = [
            [0,1,2,3], [4,7,6,5],
            [0,4,5,1], [1,5,6,2],
            [2,6,7,3], [3,7,4,0]
        ]
    );
}

// Translucent polycarbonate mono-pitch roof, on visible aluminium-look purlins.
//   origin = [x0, y0, eave_h_high]  (Y=y0 is the high edge)
//   length = X span, width = Y span, drop = vertical fall from y0 to y1
//   purlin_spacing = X spacing between visible support purlins
//   purlin_w, purlin_h = purlin section
module roof_polycarb_mono(origin, length, width, drop, thick=12,
                          overhang_front=120, overhang_back=80,
                          overhang_side=80,
                          purlin_spacing=900, purlin_w=60, purlin_h=70,
                          palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];

    // Purlins (sloped, visible from below)
    color([0.65, 0.66, 0.68])  // anodised aluminium
    for (px = [ox + 200 : purlin_spacing : ox + length - 200]) {
        hull() {
            translate([px, oy - overhang_front, oz - purlin_h])
                cube([purlin_w, 0.01, purlin_h]);
            translate([px, oy + width + overhang_back, oz - drop - purlin_h])
                cube([purlin_w, 0.01, purlin_h]);
        }
    }

    // Translucent polycarbonate slab
    color(pal_polycarb(palette))
    polyhedron(
        points = [
            [ox - overhang_side, oy - overhang_front, oz + thick],
            [ox + length + overhang_side, oy - overhang_front, oz + thick],
            [ox + length + overhang_side, oy + width + overhang_back, oz - drop + thick],
            [ox - overhang_side, oy + width + overhang_back, oz - drop + thick],
            [ox - overhang_side, oy - overhang_front, oz],
            [ox + length + overhang_side, oy - overhang_front, oz],
            [ox + length + overhang_side, oy + width + overhang_back, oz - drop],
            [ox - overhang_side, oy + width + overhang_back, oz - drop]
        ],
        faces = [
            [0,1,2,3], [4,7,6,5],
            [0,4,5,1], [1,5,6,2],
            [2,6,7,3], [3,7,4,0]
        ]
    );
}

// Roof fascia (boards around the roof edge) and rain gutter on the back.
// Models v1's fascia/gutter for a mono-pitch roof.
module fascia_and_gutter_mono(origin, length, width, drop,
                              fascia_h=140, fascia_t=22,
                              overhang_front=180, overhang_back=100,
                              overhang_side=120, gutter_w=100, gutter_h=60,
                              palette=DEFAULT_PALETTE) {
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
        // Downspout on the right
        translate([x1 - 80, y1 + gutter_w / 2 - 25, oz - drop - fascia_h - 1500])
            cube([50, 50, 1500]);
        translate([x1 - 80, y1 + gutter_w / 2 - 25, gutter_z - 5])
            cube([50, 50, 15]);
    }
}

// Fascia along both eave edges of a gable-Y roof, plus a gutter on the
// X=ox-overhang_eave (left) eave with a downspout running to ground.
module fascia_and_gutter_gable_y(origin, length, width, eave_h, ridge_h,
                                 fascia_h=120, fascia_t=22,
                                 overhang_eave=120, overhang_gable=180,
                                 gutter_w=90, gutter_h=55, base_h=120,
                                 palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1];
    x0 = ox - overhang_eave;
    x1 = ox + length + overhang_eave;
    y0 = oy - overhang_gable;
    y1 = oy + width + overhang_gable;
    z = eave_h;
    gt = 4;

    // Eave fascias on both X edges
    color(pal_trim(palette)) {
        translate([x0, y0, z - fascia_h])
            cube([fascia_t, y1 - y0, fascia_h]);
        translate([x1 - fascia_t, y0, z - fascia_h])
            cube([fascia_t, y1 - y0, fascia_h]);
    }

    // Verge boards along both gable ends — sloped from eave at outside
    // to ridge at center.
    color(pal_trim(palette)) {
        // Front gable verge (Y=y0): two sloped pieces meeting at ridge
        for (yp = [y0, y1 - fascia_t]) {
            hull() {
                translate([x0, yp, z - fascia_h])
                    cube([0.01, fascia_t, fascia_h]);
                translate([ox + length/2, yp, ridge_h - fascia_h])
                    cube([0.01, fascia_t, fascia_h]);
            }
            hull() {
                translate([ox + length/2, yp, ridge_h - fascia_h])
                    cube([0.01, fascia_t, fascia_h]);
                translate([x1, yp, z - fascia_h])
                    cube([0.01, fascia_t, fascia_h]);
            }
        }
    }

    // Gutter on the X=x0 (outside) eave, running the full Y span
    gutter_z = z - fascia_h - 8;
    color([0.40, 0.40, 0.38]) {
        translate([x0 - gutter_w + fascia_t, y0 + 20, gutter_z])
            cube([gutter_w - fascia_t, y1 - y0 - 40, gt]);
        translate([x0 - gutter_w + fascia_t, y0 + 20, gutter_z])
            cube([gt, y1 - y0 - 40, gutter_h]);
        translate([x0 - gt + fascia_t, y0 + 20, gutter_z])
            cube([gt, y1 - y0 - 40, gutter_h * 0.7]);
        // Downspout at front-left running to ground
        translate([x0 - gutter_w/2 + 10, y0 + 30, base_h])
            cube([50, 50, gutter_z - base_h]);
        translate([x0 - gutter_w/2 + 10, y0 + 30, gutter_z - 5])
            cube([50, 50, 15]);
    }
}

// Wooden trim around the perimeter of a polycarbonate roof slab + gutter on
// the back (low) edge with a downspout.
module polycarb_trim_and_gutter(origin, length, width, drop, thick=12,
                                overhang_front=120, overhang_back=80,
                                overhang_side=80,
                                trim_h=70, trim_t=22, gutter_w=90,
                                gutter_h=55, base_h=120,
                                palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    x0 = ox - overhang_side;
    x1 = ox + length + overhang_side;
    y0 = oy - overhang_front;
    y1 = oy + width + overhang_back;
    gt = 4;

    color(pal_trim(palette)) {
        // Front trim (high edge, runs along Y=y0)
        translate([x0, y0, oz - trim_h])
            cube([x1 - x0, trim_t, trim_h]);
        // Back trim (low edge, runs along Y=y1)
        translate([x0, y1 - trim_t, oz - drop - trim_h])
            cube([x1 - x0, trim_t, trim_h]);
        // Right trim (sloped, runs along X=x1)
        hull() {
            translate([x1 - trim_t, y0, oz - trim_h])
                cube([trim_t, 0.01, trim_h]);
            translate([x1 - trim_t, y1, oz - drop - trim_h])
                cube([trim_t, 0.01, trim_h]);
        }
    }

    // Gutter on the back (low) edge
    gutter_z = oz - drop - trim_h - 5;
    color([0.40, 0.40, 0.38]) {
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gutter_w, gt]);
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gt, gutter_h]);
        translate([x0 + 20, y1 + gutter_w - gt, gutter_z])
            cube([x1 - x0 - 40, gt, gutter_h * 0.7]);
        // Downspout at the right-back corner
        translate([x1 - 80, y1 + gutter_w/2 - 25, base_h])
            cube([50, 50, gutter_z - base_h]);
        translate([x1 - 80, y1 + gutter_w/2 - 25, gutter_z - 5])
            cube([50, 50, 15]);
    }
}

// Ridge cap board running along the peak of a gable-Y roof.
module ridge_cap_y(origin, length, width, ridge_h,
                   cap_w=120, cap_t=18, overhang_gable=180,
                   palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1];
    color(pal_trim(palette))
    translate([ox + length/2 - cap_w/2,
               oy - overhang_gable,
               ridge_h])
        cube([cap_w, width + 2*overhang_gable, cap_t]);
}

// Fascia + verge boards + gutter for a gable-X roof (ridge along X at Y=ww/2).
// Eave fascias on the Y=y0 (front) and Y=y1 (back) edges; verge boards on the
// gable rakes at X=x0 and X=x1; gutter on the back eave with downspout.
module fascia_and_gutter_gable_x(origin, length, width, eave_h, ridge_h,
                                 fascia_h=120, fascia_t=22,
                                 overhang_eave=120, overhang_gable=180,
                                 gutter_w=90, gutter_h=55, base_h=120,
                                 palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1];
    x0 = ox - overhang_gable;
    x1 = ox + length + overhang_gable;
    y0 = oy - overhang_eave;
    y1 = oy + width + overhang_eave;
    z = eave_h;
    gt = 4;

    // Eave fascias on both Y edges
    color(pal_trim(palette)) {
        translate([x0, y0, z - fascia_h])
            cube([x1 - x0, fascia_t, fascia_h]);
        translate([x0, y1 - fascia_t, z - fascia_h])
            cube([x1 - x0, fascia_t, fascia_h]);
    }

    // Verge boards along both gable ends — sloped from eave at outside to
    // ridge at center.
    color(pal_trim(palette)) {
        for (xp = [x0, x1 - fascia_t]) {
            hull() {
                translate([xp, y0, z - fascia_h])
                    cube([fascia_t, 0.01, fascia_h]);
                translate([xp, oy + width/2, ridge_h - fascia_h])
                    cube([fascia_t, 0.01, fascia_h]);
            }
            hull() {
                translate([xp, oy + width/2, ridge_h - fascia_h])
                    cube([fascia_t, 0.01, fascia_h]);
                translate([xp, y1, z - fascia_h])
                    cube([fascia_t, 0.01, fascia_h]);
            }
        }
    }

    // Gutter on the back (Y=y1) eave + downspout at the right end
    gutter_z = z - fascia_h - 8;
    color([0.40, 0.40, 0.38]) {
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gutter_w, gt]);
        translate([x0 + 20, y1, gutter_z])
            cube([x1 - x0 - 40, gt, gutter_h]);
        translate([x0 + 20, y1 + gutter_w - gt, gutter_z])
            cube([x1 - x0 - 40, gt, gutter_h * 0.7]);
        translate([x1 - 80, y1 + gutter_w/2 - 25, base_h])
            cube([50, 50, gutter_z - base_h]);
        translate([x1 - 80, y1 + gutter_w/2 - 25, gutter_z - 5])
            cube([50, 50, 15]);
    }
}

// Ridge cap board running along the peak of a gable-X roof (ridge along X
// at Y = oy + width/2).
module ridge_cap_x(origin, length, width, ridge_h,
                   cap_w=120, cap_t=18, overhang_gable=180,
                   palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1];
    color(pal_trim(palette))
    translate([ox - overhang_gable,
               oy + width/2 - cap_w/2,
               ridge_h])
        cube([length + 2*overhang_gable, cap_w, cap_t]);
}

// Visible ceiling rafters under a mono-pitch roof.
module ceiling_rafters_mono(origin, length, width, drop, eave_h,
                            spacing=800, rafter_w=45, rafter_h=140,
                            wall_t=100, palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1];
    z_front = eave_h;
    z_back  = eave_h - drop;
    color(pal_post(palette))
    for (x = [ox + wall_t : spacing : ox + length - wall_t]) {
        hull() {
            translate([x, oy + wall_t, z_front - rafter_h])
                cube([rafter_w, 0.01, rafter_h]);
            translate([x, oy + width - wall_t, z_back - rafter_h])
                cube([rafter_w, 0.01, rafter_h]);
        }
    }
}
