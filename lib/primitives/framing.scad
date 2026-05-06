// Stud-wall framing primitives: stud walls, posts, sill/top plates.

include <../defaults.scad>
use <../bom.scad>

// True if the stud centred at `c` falls inside any [lo, hi] range.
function _in_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// Stud wall — bottom plate, top plate, and vertical studs at `spacing`.
// `axis` = "X" (wall runs along +X) or "Y" (wall runs along +Y).
// `origin` = [x, y, z] of the lower outside corner of the wall.
// `height` = wall height at the OUTER face (y=oy for axis="X", x=ox for "Y").
// `h_inner` (optional) = wall height at the INNER face. When set, the top
//             plate slopes across the wall thickness to follow a sloped roof
//             above — common detail when a flat-top wall sits perpendicular
//             to a mono-pitch slope. Default `undef` keeps the flat top.
//             Studs run flat to the lower of (height, h_inner) - 2*sw, so a
//             real wood stud (flat-topped) fits cleanly under the sloped
//             top plate with a small wedge of air at the high edge.
// `skip_ranges` = list of [lo, hi] along the wall's run-axis (relative to
//             the wall start). Studs whose centre falls inside any range
//             are omitted — used so jamb studs added separately don't
//             duplicate the regular grid. End stud is always emitted.
module stud_wall(origin, length, height, axis="X",
                 stud=DEFAULT_STUD, palette=DEFAULT_PALETTE,
                 skip_ranges=[], h_inner=undef) {
    sw = ss_w(stud);
    sd = ss_d(stud);
    sp = ss_spacing(stud);
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    h_in    = is_undef(h_inner) ? height : h_inner;
    flat    = (h_in == height);
    stud_h  = min(height, h_in) - 2 * sw;

    // BOM (no-op when $bom_mode != true)
    bom_member("bundrem", "pt-pine", sd, sw, length, "stud_wall");
    bom_member("toprem", "spruce", sd, sw, length, "stud_wall");
    for (p = [0 : sp : length - sw])
        if (!_in_skip(p + sw/2, skip_ranges))
            bom_member("stud", "spruce", sw, sd, stud_h, "stud_wall");
    bom_member("stud", "spruce", sw, sd, stud_h, "stud_wall_end");

    color(pal_post(palette)) {
        if (axis == "X") {
            // Bottom plate (flat)
            translate([ox, oy, oz])
                cube([length, sd, sw]);
            // Top plate — flat (height == h_in) or sloped across thickness
            if (flat) {
                translate([ox, oy, oz + height - sw])
                    cube([length, sd, sw]);
            } else {
                hull() {
                    translate([ox, oy, oz + height - sw])
                        cube([length, 0.01, sw]);
                    translate([ox, oy + sd - 0.01, oz + h_in - sw])
                        cube([length, 0.01, sw]);
                }
            }
            // Studs (loop bound `length - sw` so a length divisible by sp
            // doesn't spawn an extra stud past the wall end).
            for (x = [0 : sp : length - sw])
                if (!_in_skip(x + sw/2, skip_ranges))
                    translate([ox + x, oy, oz + sw])
                        cube([sw, sd, stud_h]);
            // End stud
            translate([ox + length - sw, oy, oz + sw])
                cube([sw, sd, stud_h]);
        } else {
            translate([ox, oy, oz])
                cube([sd, length, sw]);
            if (flat) {
                translate([ox, oy, oz + height - sw])
                    cube([sd, length, sw]);
            } else {
                hull() {
                    translate([ox, oy, oz + height - sw])
                        cube([0.01, length, sw]);
                    translate([ox + sd - 0.01, oy, oz + h_in - sw])
                        cube([0.01, length, sw]);
                }
            }
            for (y = [0 : sp : length - sw])
                if (!_in_skip(y + sw/2, skip_ranges))
                    translate([ox, oy + y, oz + sw])
                        cube([sd, sw, stud_h]);
            translate([ox, oy + length - sw, oz + sw])
                cube([sd, sw, stud_h]);
        }
    }
}

// Linear-interpolated wall height at run-axis position `p`.
function _slope_h(h_start, h_end, length, p) =
    h_start + (h_end - h_start) * p / length;

// Stud wall with a sloped top plate — bottom plate flat, top plate hulled
// between two thin cubes at h_start and h_end, studs at spacing whose tops
// touch the top plate underside.
//   axis        = "X" (slope along +X) or "Y" (slope along +Y).
//   h_start     = wall height at run-axis 0 (bottom plate bottom → top plate top)
//   h_end       = wall height at run-axis length
//   skip_ranges = same semantics as stud_wall — used so jamb studs added
//                 by framed_opening_y don't duplicate the regular grid.
module stud_wall_sloped(origin, length, h_start, h_end, axis="Y",
                        stud=DEFAULT_STUD, palette=DEFAULT_PALETTE,
                        skip_ranges=[]) {
    sw = ss_w(stud);
    sd = ss_d(stud);
    sp = ss_spacing(stud);
    ox = origin[0]; oy = origin[1]; oz = origin[2];

    // BOM
    bom_member("bundrem", "pt-pine", sd, sw, length, "stud_wall_sloped");
    bom_member("toprem", "spruce", sd, sw, length, "stud_wall_sloped");
    for (p = [0 : sp : length - sw])
        if (!_in_skip(p + sw/2, skip_ranges)) {
            sh_p = _slope_h(h_start, h_end, length, p + sw/2) - 2*sw;
            bom_member("stud", "spruce", sw, sd, sh_p, "stud_wall_sloped");
        }
    end_h = _slope_h(h_start, h_end, length, length - sw/2) - 2*sw;
    bom_member("stud", "spruce", sw, sd, end_h, "stud_wall_sloped_end");

    color(pal_post(palette)) {
        if (axis == "Y") {
            // Bottom plate (flat)
            translate([ox, oy, oz])
                cube([sd, length, sw]);
            // Top plate — hull between two thin cubes at h_start and h_end
            hull() {
                translate([ox, oy, oz + h_start - sw])
                    cube([sd, 0.01, sw]);
                translate([ox, oy + length - 0.01, oz + h_end - sw])
                    cube([sd, 0.01, sw]);
            }
            // Studs — variable length so tops touch sloped top plate underside
            for (y = [0 : sp : length - sw])
                if (!_in_skip(y + sw/2, skip_ranges)) {
                    h_here = _slope_h(h_start, h_end, length, y + sw/2);
                    translate([ox, oy + y, oz + sw])
                        cube([sd, sw, h_here - 2*sw]);
                }
            // End stud
            h_end_stud = _slope_h(h_start, h_end, length, length - sw/2);
            translate([ox, oy + length - sw, oz + sw])
                cube([sd, sw, h_end_stud - 2*sw]);
        } else {
            translate([ox, oy, oz])
                cube([length, sd, sw]);
            hull() {
                translate([ox, oy, oz + h_start - sw])
                    cube([0.01, sd, sw]);
                translate([ox + length - 0.01, oy, oz + h_end - sw])
                    cube([0.01, sd, sw]);
            }
            for (x = [0 : sp : length - sw])
                if (!_in_skip(x + sw/2, skip_ranges)) {
                    h_here = _slope_h(h_start, h_end, length, x + sw/2);
                    translate([ox + x, oy, oz + sw])
                        cube([sw, sd, h_here - 2*sw]);
                }
            h_end_stud = _slope_h(h_start, h_end, length, length - sw/2);
            translate([ox + length - sw, oy, oz + sw])
                cube([sw, sd, h_end_stud - 2*sw]);
        }
    }
}

// Framed rectangular opening in a Y-axis wall (wall runs along +Y, lives at
// x=ox..ox+sd). Emits jamb studs flanking the opening, a header above, and
// cripples between header top and the wall's sloped top-plate underside.
// For windows (`has_sill=true`) also emits a rough sill below the opening
// and cripples between bottom plate top and sill bottom.
//   wall_origin     = same lower-outside corner as the parent stud_wall_sloped
//   length, h_start, h_end = same as stud_wall_sloped (so the top plate
//                            interpolation matches)
//   opening_y       = opening's near edge along the wall's Y run
//   opening_w       = opening width along Y
//   opening_z       = opening bottom Z (absolute)
//   opening_h       = opening height
module framed_opening_y(wall_origin, length, h_start, h_end,
                        opening_y, opening_w, opening_z, opening_h,
                        has_sill=false, header_h=95, sill_h=95,
                        stud=DEFAULT_STUD, palette=DEFAULT_PALETTE) {
    sw = ss_w(stud);
    sd = ss_d(stud);
    sp = ss_spacing(stud);
    ox = wall_origin[0]; oy = wall_origin[1]; oz = wall_origin[2];

    j1 = opening_y;
    j2 = opening_y + opening_w - sw;
    tp_j1 = oz + _slope_h(h_start, h_end, length, j1 + sw/2) - sw;
    tp_j2 = oz + _slope_h(h_start, h_end, length, j2 + sw/2) - sw;

    crp_z0 = opening_z + opening_h + header_h;

    // BOM
    bom_member("jamb", "spruce", sd, sw, tp_j1 - (oz + sw),
               "framed_opening_y_jamb1");
    bom_member("jamb", "spruce", sd, sw, tp_j2 - (oz + sw),
               "framed_opening_y_jamb2");
    bom_member("header", "spruce", sd, header_h, j2 + sw - j1,
               "framed_opening_y_header");
    for (y = [j1 + sp/2 : sp : j2 - sp/2]) {
        crp_top_y = oz + _slope_h(h_start, h_end, length, y + sw/2) - sw;
        if (crp_top_y - crp_z0 > 20)
            bom_member("cripple", "spruce", sd, sw, crp_top_y - crp_z0,
                       "framed_opening_y_cripple_above");
    }
    if (has_sill) {
        bom_member("sill", "spruce", sd, sill_h, j2 + sw - j1,
                   "framed_opening_y_sill");
        for (y = [j1 + sp/2 : sp : j2 - sp/2])
            if ((opening_z - sill_h) - (oz + sw) > 20)
                bom_member("cripple", "spruce", sd, sw,
                           (opening_z - sill_h) - (oz + sw),
                           "framed_opening_y_cripple_below");
    }

    color(pal_post(palette)) {
        // Jamb studs (full bottom-plate-top to top-plate-underside)
        translate([ox, oy + j1, oz + sw])
            cube([sd, sw, tp_j1 - (oz + sw)]);
        translate([ox, oy + j2, oz + sw])
            cube([sd, sw, tp_j2 - (oz + sw)]);

        // Header — flat across the opening, sw thick top-down × header_h tall
        translate([ox, oy + j1, opening_z + opening_h])
            cube([sd, j2 + sw - j1, header_h]);

        // Cripples above header up to sloped top plate
        for (y = [j1 + sp/2 : sp : j2 - sp/2]) {
            crp_top = oz + _slope_h(h_start, h_end, length, y + sw/2) - sw;
            if (crp_top - crp_z0 > 20)
                translate([ox, oy + y, crp_z0])
                    cube([sd, sw, crp_top - crp_z0]);
        }

        if (has_sill) {
            // Rough sill across the opening
            translate([ox, oy + j1, opening_z - sill_h])
                cube([sd, j2 + sw - j1, sill_h]);
            // Cripples below sill down to bottom plate
            crp_b_top = opening_z - sill_h;
            for (y = [j1 + sp/2 : sp : j2 - sp/2])
                if (crp_b_top - (oz + sw) > 20)
                    translate([ox, oy + y, oz + sw])
                        cube([sd, sw, crp_b_top - (oz + sw)]);
        }
    }
}

// A single solid wood post.
module post(origin, size, height, palette=DEFAULT_PALETTE, name="post") {
    bom_member("post", "pt-pine", size[0], size[1], height, name);
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
                         palette=DEFAULT_PALETTE, name="top_beam_sloped_y") {
    bom_member("beam", "limtree", thick, beam_h, len, name);
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
