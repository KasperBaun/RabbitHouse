// Generic cladding primitives shared by klink and board-on-board. No klink-
// or bob-specific board geometry lives here — only housewrap, corner posts,
// and the two counter-batten orientations.

include <../../../lib/defaults.scad>
include <../../config.scad>

HOUSEWRAP_COLOR = [0.50, 0.50, 0.52];
BATTEN_COLOR    = [0.78, 0.65, 0.45];

// Top-plate Z at any Y on a roof-sloped wall (V3, V4, V5).
function wall_height_at(y) =
    RH_EH_FRONT - (RH_EH_FRONT - RH_EH_BACK) * y / RH_HOUSE_DEPTH;

function in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// Housewrap on one wall. Pass h_far for a sloped wall — top edge tilts from
// `height` at origin to `h_far` at the far end. axis: "X" for V1/V2, "Y"
// for V3/V4/V5.
module render_housewrap(origin, length, height, axis, h_far = undef) {
    h_end = is_undef(h_far) ? height : h_far;
    color(HOUSEWRAP_COLOR)
    if (axis == "X") {
        if (height == h_end)
            translate(origin) cube([length, RH_HOUSEWRAP_T, height]);
        else hull() {
            translate(origin)
                cube([0.01, RH_HOUSEWRAP_T, height]);
            translate([origin[0] + length - 0.01, origin[1], origin[2]])
                cube([0.01, RH_HOUSEWRAP_T, h_end]);
        }
    } else {
        if (height == h_end)
            translate(origin) cube([RH_HOUSEWRAP_T, length, height]);
        else hull() {
            translate(origin)
                cube([RH_HOUSEWRAP_T, 0.01, height]);
            translate([origin[0], origin[1] + length - 0.01, origin[2]])
                cube([RH_HOUSEWRAP_T, 0.01, h_end]);
        }
    }
}

// One corner trim post at the outside cladding corner.
module render_corner_post(pos, trim_w, height, palette = DEFAULT_PALETTE) {
    color(pal_trim(palette))
    translate(pos)
        cube([trim_w, trim_w, height]);
}

// Vertical 22×45 counter-battens — battens stand up, distributed along
// the wall axis. Used when boards run horizontal (klink).
module render_vertical_battens(origin, length, height, axis,
                                c2c = 600, h_far = undef,
                                skip_ranges = []) {
    n     = floor(length / c2c) + 1;
    h_end = is_undef(h_far) ? height : h_far;
    color(BATTEN_COLOR)
    for (i = [0 : n - 1]) {
        center = (axis == "X" ? origin[0] : origin[1]) + i * c2c + 22.5;
        if (!in_any_skip(center, skip_ranges)) {
            far_edge = i * c2c + 45;
            h_i = (length > 0)
                ? height + (h_end - height) * far_edge / length
                : height;
            if (axis == "X")
                translate([origin[0] + i*c2c, origin[1], origin[2]])
                    cube([45, RH_COUNTER_BATTEN_T, h_i]);
            else
                translate([origin[0], origin[1] + i*c2c, origin[2]])
                    cube([RH_COUNTER_BATTEN_T, 45, h_i]);
        }
    }
}

// Horizontal 22×45 counter-battens — battens lie flat along the wall axis,
// stacked vertically at c/c. Used when boards run vertical (bob).
module render_horizontal_battens(origin, length, height, axis,
                                  c2c = 600, h_far = undef,
                                  skip_zs = []) {
    h_end  = is_undef(h_far) ? height : h_far;
    h_safe = min(height, h_end);
    n      = max(1, floor((h_safe - 45) / c2c) + 1);
    color(BATTEN_COLOR)
    for (i = [0 : n - 1]) {
        z0 = origin[2] + i * c2c;
        zc = z0 + 22.5;
        if (!in_any_skip(zc, skip_zs)) {
            if (axis == "X")
                translate([origin[0], origin[1], z0])
                    cube([length, RH_COUNTER_BATTEN_T, 45]);
            else
                translate([origin[0], origin[1], z0])
                    cube([RH_COUNTER_BATTEN_T, length, 45]);
        }
    }
}
