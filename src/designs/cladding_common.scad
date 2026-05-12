// Shared cladding helpers used by both klink and board_on_board variants.
// Housewrap membranes, sloped-wall height helper, opening-skip predicate.

include <../lib/defaults.scad>
include <config.scad>

module render_housewrap(origin, length, height, axis) {
    color([0.50, 0.50, 0.52])
    if (axis == "X")
        translate(origin) cube([length, RH_HOUSEWRAP_T, height]);
    else
        translate(origin) cube([RH_HOUSEWRAP_T, length, height]);
}

// Sloped housewrap for walls following the roof pitch (V3, V5). Top z
// interpolates linearly from h_high (at origin) to h_low (at the far end).
module render_housewrap_sloped(origin, length, h_high, h_low, axis) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color([0.50, 0.50, 0.52])
    if (axis == "X") {
        hull() {
            translate([ox, oy, oz])
                cube([0.01, RH_HOUSEWRAP_T, h_high]);
            translate([ox + length - 0.01, oy, oz])
                cube([0.01, RH_HOUSEWRAP_T, h_low]);
        }
    } else {
        hull() {
            translate([ox, oy, oz])
                cube([RH_HOUSEWRAP_T, 0.01, h_high]);
            translate([ox, oy + length - 0.01, oz])
                cube([RH_HOUSEWRAP_T, 0.01, h_low]);
        }
    }
}

// Wall height from sokkel-top to top-plate TOP at any y. Linear between
// RH_EH_FRONT (y=0) and RH_EH_BACK (y=RH_WIDTH).
function wall_height_at(y) =
    RH_EH_FRONT - (RH_EH_FRONT - RH_EH_BACK) * y / RH_WIDTH;

// True if centre coordinate c falls within any [lo, hi] range.
function in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;
