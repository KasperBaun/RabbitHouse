// Cladding primitives — horizontal overlapping ("klink") boards.
// All modules are parametric and read no globals.

include <../defaults.scad>

// Single overlapping board: lower edge thick, upper edge thin.
// `len` runs along the wall; the board lies in the X-axis local frame.
module klink_board(len, board_h, thick, col) {
    color(col)
    hull() {
        cube([len, thick, 0.1]);
        translate([0, 0, board_h - 0.1])
            cube([len, 5, 0.1]);
    }
}

// Internal: render N alternating-color boards stacked vertically from z=0.
// Boards extend in +X for `len`, sit at y=0..thick, alternating color1/color2.
module _clad_strip(len, n_boards, clad, col1, col2) {
    bh   = cs_board_h(clad);
    th   = cs_thick(clad);
    step = cs_step(clad);
    for (i = [0 : n_boards - 1]) {
        translate([0, 0, i * step])
            klink_board(len, bh, th, (i % 2 == 0) ? col1 : col2);
    }
}

// Rectangular cladded wall, run along an axis.
// `origin` = [x, y, z_base] of the lower-front corner of the cladding face.
// `axis` = "X" (boards run along +X, wall faces -Y) or
//          "Y" (boards run along +Y, wall faces +X)
//   For "X": boards translated to [ox, oy, oz + i*step], extend in +X.
//   For "Y": boards extend in +Y by rotating -90 about Z then placing.
// `len` = wall length, `wall_h` = wall height (above z_base).
// Wall-axis convention:
//   axis="X": origin = lower-near corner; boards run +X from origin, with
//             cladding thickness extending in +Y (outward).
//   axis="Y": origin = lower-near corner (small Y); boards run +Y from origin,
//             with cladding thickness extending in +X (outward).
// To clad an outward face, use the OUTER X (or Y) of the structural wall as
// the origin's X (or Y) — thickness adds outside it.
module clad_wall_rect(origin, len, wall_h, axis="X",
                      palette=DEFAULT_PALETTE, clad=DEFAULT_CLAD) {
    n = max(1, ceil(wall_h / cs_step(clad)) - 1);
    c1 = pal_panel1(palette);
    c2 = pal_panel2(palette);
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    if (axis == "X") {
        translate([ox, oy, oz])
            _clad_strip(len, n + 1, clad, c1, c2);
    } else {
        translate([ox, oy + len, oz])
            rotate([0, 0, -90])
                _clad_strip(len, n + 1, clad, c1, c2);
    }
}

// Mono-pitched cladded wall (sloped top edge).
// Use when the wall sits below a sloping roof. The wall is rendered as a
// full-height rect of cladding then `difference()`d against a wedge that
// removes everything above the roof underside.
//
// `origin` = [x, y, z_base], `len` = wall length, `axis` = "X" or "Y".
// `h_high` = wall height at the high (origin) end; `h_low` = at the far end.
// The slope cut runs from (origin) at h_high down to (origin + len*axis_vec)
// at h_low.
module clad_wall_mono_pitch(origin, len, h_high, h_low, axis="X",
                            palette=DEFAULT_PALETTE, clad=DEFAULT_CLAD) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    full_h = max(h_high, h_low) + cs_board_h(clad);
    th = cs_thick(clad);

    difference() {
        clad_wall_rect(origin, len, full_h, axis, palette, clad);

        // Wedge to subtract above the roof line.
        if (axis == "X") {
            hull() {
                translate([ox - 10, oy - 10, oz + h_high])
                    cube([10, th + 20, 1500]);
                translate([ox + len, oy - 10, oz + h_low])
                    cube([10, th + 20, 1500]);
            }
        } else {
            hull() {
                translate([ox - 10, oy - 10, oz + h_high])
                    cube([th + 20, 10, 1500]);
                translate([ox - 10, oy + len, oz + h_low])
                    cube([th + 20, 10, 1500]);
            }
        }
    }
}

// Cladded wall with a rectangular cutout (e.g. window).
// `cutout` = [start_along, end_along, z_lo, z_hi] — extents in the wall plane.
module clad_wall_with_cutout(origin, len, wall_h, axis="X",
                             palette=DEFAULT_PALETTE, clad=DEFAULT_CLAD,
                             cutout=undef) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    th = cs_thick(clad);
    if (is_undef(cutout)) {
        clad_wall_rect(origin, len, wall_h, axis, palette, clad);
    } else {
        difference() {
            clad_wall_rect(origin, len, wall_h, axis, palette, clad);
            if (axis == "X") {
                translate([ox + cutout[0], oy - 10, oz + cutout[2]])
                    cube([cutout[1] - cutout[0], th + 20, cutout[3] - cutout[2]]);
            } else {
                translate([ox - 10, oy + cutout[0], oz + cutout[2]])
                    cube([th + 20, cutout[1] - cutout[0], cutout[3] - cutout[2]]);
            }
        }
    }
}

// Cladded wall with a sloped top AND a cutout (v1's right-side wall pattern).
module clad_wall_mono_pitch_with_cutout(origin, len, h_high, h_low, axis="X",
                                        palette=DEFAULT_PALETTE,
                                        clad=DEFAULT_CLAD,
                                        cutout=undef) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    full_h = max(h_high, h_low) + cs_board_h(clad);
    th = cs_thick(clad);
    difference() {
        clad_wall_with_cutout(origin, len, full_h, axis, palette, clad, cutout);
        if (axis == "X") {
            hull() {
                translate([ox - 10, oy - 10, oz + h_high])
                    cube([10, th + 20, 1500]);
                translate([ox + len, oy - 10, oz + h_low])
                    cube([10, th + 20, 1500]);
            }
        } else {
            hull() {
                translate([ox - 10, oy - 10, oz + h_high])
                    cube([th + 20, 10, 1500]);
                translate([ox - 10, oy + len, oz + h_low])
                    cube([th + 20, 10, 1500]);
            }
        }
    }
}

// Gable end wall: a rectangle of cladding clipped to a gable triangle.
// The gable peak sits at `len/2` along the wall axis. `eave_h` is the wall
// height at the eaves; `ridge_h` is the height at the peak.
module clad_wall_gable(origin, len, eave_h, ridge_h, axis="X",
                       palette=DEFAULT_PALETTE, clad=DEFAULT_CLAD) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    full_h = ridge_h + cs_board_h(clad);
    th = cs_thick(clad);
    difference() {
        clad_wall_rect(origin, len, full_h, axis, palette, clad);
        // Two wedges, one each side of the ridge.
        if (axis == "X") {
            // Left wedge: at X=ox the cut starts at eave_h; at X=ox+len/2 it
            // reaches ridge_h.
            hull() {
                translate([ox - 10, oy - 10, oz + eave_h])
                    cube([10, th + 20, 2000]);
                translate([ox + len/2, oy - 10, oz + ridge_h])
                    cube([10, th + 20, 2000]);
            }
            // Right wedge: from ridge at center down to eave at X=ox+len.
            hull() {
                translate([ox + len/2, oy - 10, oz + ridge_h])
                    cube([10, th + 20, 2000]);
                translate([ox + len, oy - 10, oz + eave_h])
                    cube([10, th + 20, 2000]);
            }
        } else {
            hull() {
                translate([ox - 10, oy - 10, oz + eave_h])
                    cube([th + 20, 10, 2000]);
                translate([ox - 10, oy + len/2, oz + ridge_h])
                    cube([th + 20, 10, 2000]);
            }
            hull() {
                translate([ox - 10, oy + len/2, oz + ridge_h])
                    cube([th + 20, 10, 2000]);
                translate([ox - 10, oy + len, oz + eave_h])
                    cube([th + 20, 10, 2000]);
            }
        }
    }
}

// L-shaped corner trim post — used at v1's back-right exterior corner.
module corner_trim_post(pos, height, trim_w=50, trim_t=22,
                        palette=DEFAULT_PALETTE) {
    color(pal_trim(palette)) {
        translate([pos[0] - trim_t, pos[1] - trim_t, pos[2]])
            cube([trim_t, trim_t, height]);
        translate([pos[0] - trim_w, pos[1] - trim_t, pos[2]])
            cube([trim_w, trim_t, height]);
        translate([pos[0] - trim_t, pos[1] - trim_w, pos[2]])
            cube([trim_t, trim_w, height]);
    }
}
