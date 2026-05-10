// Beslag (steel connectors) primitives.
//
// Each module renders a simplified galvanised-grey shape and emits a BOM
// row tagged with the appropriate system. The geometry is approximate —
// the primary purpose is to make the connector visible at audit time so
// the user can see WHERE every bracket goes and HOW MANY are needed for
// the shopping list.

include <../defaults.scad>
use <../bom.scad>

BESLAG_COLOR = [0.62, 0.62, 0.66];

// M10 anchor screw, ~120 mm long, head at z=0 (top of fundablok ring),
// shaft sinking into the ring. p = [x, y] on the ring's centerline.
module ankerskrue_m10(p, system="fundament") {
    bom_member("ankerskrue_m10", "steel-galv", 10, 10, 120, "anchor_M10x120", system=system);
    color(BESLAG_COLOR) {
        translate([p[0], p[1], -120]) cylinder(h=120, r=5, $fn=12);
        translate([p[0], p[1], 0])    cylinder(h=8,  r1=10, r2=8, $fn=12);
    }
}

// 90×90 mm perforated angle bracket. Two perpendicular legs, 2 mm steel.
// orientation = "+x+z" means leg-1 along +X face, leg-2 along +Z face.
// Origin = inside corner.
module vinkelbeslag(p, leg=90, thick=2, orientation="+x+z", system="vaegge") {
    bom_member("vinkelbeslag", "steel-galv", leg, leg, thick, "BMF90", system=system);
    color(BESLAG_COLOR)
    translate(p)
    if (orientation == "+x+z") {
        cube([leg, thick, thick]);
        cube([thick, thick, leg]);
    } else if (orientation == "-x+z") {
        translate([-leg, 0, 0]) cube([leg, thick, thick]);
        translate([-thick, 0, 0]) cube([thick, thick, leg]);
    } else if (orientation == "+y+z") {
        cube([thick, leg, thick]);
        cube([thick, thick, leg]);
    } else if (orientation == "-y+z") {
        translate([0, -leg, 0]) cube([thick, leg, thick]);
        translate([0, -thick, 0]) cube([thick, thick, leg]);
    }
}
