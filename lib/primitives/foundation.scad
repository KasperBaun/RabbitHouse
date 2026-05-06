// Foundation primitives: concrete slab, interior floor, predator dig-defeat.

include <../defaults.scad>
use <../bom.scad>

function _has_side(s, sides) = len([for (x = sides) if (x == s) 1]) > 0;


// Concrete slab covering the full footprint.
//   edge_thicken_h   = how much the perimeter edge beam drops below z=0.
//                      0 (default) means flat slab — v1/v2 unaffected.
//   edge_thicken_w   = inboard width of the edge beam, measured from the
//                      outer face of the slab.
//   edge_sides       = which sides of the slab get the edge beam.
module slab(origin, size, base_h=120, palette=DEFAULT_PALETTE,
            edge_thicken_h=0, edge_thicken_w=200,
            edge_sides=["front","back","left","right"]) {
    ox = origin[0]; oy = origin[1];
    sx = size[0];   sy = size[1];

    // BOM
    bom_member("slab", "concrete", sx, sy, base_h, "slab_main");
    if (edge_thicken_h > 0) {
        ew = edge_thicken_w;
        if (_has_side("front", edge_sides))
            bom_member("edge_beam", "concrete", sx, ew, edge_thicken_h,
                       "slab_edge_front");
        if (_has_side("back", edge_sides))
            bom_member("edge_beam", "concrete", sx, ew, edge_thicken_h,
                       "slab_edge_back");
        if (_has_side("left", edge_sides))
            bom_member("edge_beam", "concrete", ew, sy, edge_thicken_h,
                       "slab_edge_left");
        if (_has_side("right", edge_sides))
            bom_member("edge_beam", "concrete", ew, sy, edge_thicken_h,
                       "slab_edge_right");
    }

    color(pal_base(palette)) {
        translate([ox, oy, 0])
            cube([sx, sy, base_h]);
        if (edge_thicken_h > 0) {
            ew = edge_thicken_w;
            ez = -edge_thicken_h;
            if (_has_side("front", edge_sides))
                translate([ox, oy, ez])
                    cube([sx, ew, edge_thicken_h]);
            if (_has_side("back", edge_sides))
                translate([ox, oy + sy - ew, ez])
                    cube([sx, ew, edge_thicken_h]);
            if (_has_side("left", edge_sides))
                translate([ox, oy, ez])
                    cube([ew, sy, edge_thicken_h]);
            if (_has_side("right", edge_sides))
                translate([ox + sx - ew, oy, ez])
                    cube([ew, sy, edge_thicken_h]);
        }
    }
}

// Damp-proof course (fugtspærre) strip — thin dark membrane between the
// concrete slab top and the timber bundrem. Visualised as a flat strip;
// in real construction this is bitumen tape or EPDM, ~1–2 mm.
//   origin = [x, y, z] — bottom-front corner of the strip
//   axis   = "X" (strip runs along +X, width into +Y) or "Y"
module dpc_strip(origin, length, axis="X", width=120, thickness=2,
                 col=[0.15, 0.15, 0.18]) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    bom_member("dpc", "bitumen", width, thickness, length, "dpc_strip");
    color(col)
    translate([ox, oy, oz])
        cube(axis == "X" ? [length, width, thickness]
                         : [width, length, thickness]);
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
