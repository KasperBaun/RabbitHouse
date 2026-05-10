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

// M10 anchor screw, ~120 mm long. Head sits at Z=top_z (top of fundablok
// ring / sokkel), shaft sinks 120 mm down into the ring.
//   p     = [x, y] on the ring centerline
//   top_z = Z of the ring top (default 0 for legacy callers)
module ankerskrue_m10(p, top_z=0, system="fundament") {
    bom_member("ankerskrue_m10", "steel-galv", 10, 10, 120, "anchor_M10x120", system=system);
    color(BESLAG_COLOR) {
        translate([p[0], p[1], top_z - 120]) cylinder(h=120, r=5, $fn=12);
        translate([p[0], p[1], top_z])       cylinder(h=8,  r1=10, r2=8, $fn=12);
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

// Sloping rafter shoe (Simpson-type) for 45×W spær on a top plate.
// Origin = bottom-front-left of the rafter at the bearing point.
//   rafter_w   = rafter cross-section thin dimension (typ 45)
//   rafter_h   = rafter cross-section deep dimension (typ 95-145)
//   slope      = rafter slope angle in degrees (negative for falling)
module spaersko(p, rafter_w=45, rafter_h=95, slope=0, system="tagkonstruktion") {
    bom_member("spaersko", "steel-galv", rafter_w + 4, rafter_h, 2,
               "rafter_shoe", system=system);
    cradle_h = rafter_h * 0.6;
    color(BESLAG_COLOR)
    translate(p)
    rotate([slope, 0, 0]) {
        // U-cradle extends DOWN from bearing point (bracket bolted to top
        // plate beneath rafter — rafter sits IN the cradle, not above it).
        translate([-1, 0, -cradle_h])           cube([2, rafter_h, cradle_h]);   // left cheek
        translate([rafter_w-1, 0, -cradle_h])   cube([2, rafter_h, cradle_h]);   // right cheek
        translate([-1, 0, -2])                  cube([rafter_w + 2, rafter_h, 2]); // bottom strap
    }
}

// Joist hanger for a beam bearing on a post / partition top plate.
module bjaelkesko(p, beam_w=95, beam_h=180, system="vaegge") {
    bom_member("bjaelkesko", "steel-galv", beam_w + 4, beam_h, 2,
               "beam_hanger", system=system);
    color(BESLAG_COLOR)
    translate(p) {
        translate([-1, 0, 0])         cube([2, beam_h, beam_h]);
        translate([beam_w-1, 0, 0])   cube([2, beam_h, beam_h]);
        translate([-1, 0, 0])         cube([beam_w + 2, beam_h, 2]);
        translate([-1, 0, beam_h])    cube([beam_w + 2, 60, 2]);
    }
}

// Joist hanger for a 45×95 strø bearing on a ledger or ring face.
module stroesko(p, joist_w=45, joist_h=95, system="fundament") {
    bom_member("stroesko", "steel-galv", joist_w + 4, joist_h, 2,
               "joist_hanger", system=system);
    color(BESLAG_COLOR)
    translate(p) {
        translate([-1, 0, 0])         cube([2, joist_h, joist_h]);
        translate([joist_w-1, 0, 0])  cube([2, joist_h, joist_h]);
        translate([-1, 0, 0])         cube([joist_w + 2, joist_h, 2]);
    }
}
