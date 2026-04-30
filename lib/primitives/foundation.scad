// Foundation primitives: concrete slab, interior floor, predator dig-defeat.

include <../defaults.scad>

// Concrete slab covering the full footprint.
module slab(origin, size, base_h=120, palette=DEFAULT_PALETTE) {
    color(pal_base(palette))
    translate([origin[0], origin[1], 0])
        cube([size[0], size[1], base_h]);
}

// Interior floor plank surface, sitting on top of the slab.
module interior_floor(origin, size, base_h=120, thickness=20,
                      palette=DEFAULT_PALETTE) {
    color(pal_floor(palette))
    translate([origin[0], origin[1], base_h])
        cube([size[0], size[1], thickness]);
}

// Plain colored floor patch (e.g. grass surface in the rabbit zone).
module floor_patch(origin, size, base_h=120, thickness=5,
                   col=[0.35, 0.55, 0.25]) {
    color(col)
    translate([origin[0], origin[1], base_h + 20])
        cube([size[0], size[1], thickness]);
}

// Buried wire-mesh apron pinned at ground level around a perimeter rect.
// Visualised as a flat grey skirt extending `width` outside the footprint.
//   rect = [x0, y0, x1, y1] of the structure footprint
//   sides = list of "front", "back", "left", "right" — apron only on those
//           edges (e.g. omit a side that sits against a wall).
function _has_side(s, sides) = len([for (x = sides) if (x == s) 1]) > 0;

module apron_skirt(rect, width=500, sides=["front","back","left","right"],
                   palette=DEFAULT_PALETTE) {
    x0 = rect[0]; y0 = rect[1]; x1 = rect[2]; y1 = rect[3];
    skirt_t = 6;
    skirt_z = -1;
    color(pal_mesh(palette)) {
        if (_has_side("front", sides))
            translate([x0, y0 - width, skirt_z])
                cube([x1 - x0, width, skirt_t]);
        if (_has_side("back", sides))
            translate([x0, y1, skirt_z])
                cube([x1 - x0, width, skirt_t]);
        if (_has_side("left", sides))
            translate([x0 - width, y0 - width, skirt_z])
                cube([width, (y1 - y0) + 2*width, skirt_t]);
        if (_has_side("right", sides))
            translate([x1, y0 - width, skirt_z])
                cube([width, (y1 - y0) + 2*width, skirt_t]);
    }
}
