// Beslag (steel connectors) primitives.
//
// Each module renders a simplified galvanised-grey shape. The geometry is
// approximate — the primary purpose is to make the connector visible at
// audit time so the user can see WHERE every bracket goes.

include <../defaults.scad>

BESLAG_COLOR = [0.62, 0.62, 0.66];

// M10 anchor screw, ~120 mm long. Head sits at Z=top_z (top of fundablok
// ring / sokkel), shaft sinks 120 mm down into the ring.
//   p     = [x, y] on the ring centerline
//   top_z = Z of the ring top (default 0 for legacy callers)
module ankerskrue_m10(p, top_z=0, system="fundament") {
    color(BESLAG_COLOR) {
        translate([p[0], p[1], top_z - 120]) cylinder(h=120, r=5, $fn=12);
        translate([p[0], p[1], top_z])       cylinder(h=8,  r1=10, r2=8, $fn=12);
    }
}

// 90×90 mm perforated angle bracket (vinkelbeslag), e.g. Simpson L70/L90.
//   leg          = leg length (mm)
//   thick        = steel thickness (mm)
//   width        = perpendicular flange width — the bracket's "depth" along
//                  the axis NOT in its bend plane. Default = thick (legacy
//                  thin-rod look). Pass ~50 mm for a realistic flat strap.
//   orientation  = "+x+z" / "-x+z" / "+y+z" / "-y+z" — bend plane.
//                  "+x+z" → leg-1 along +X face, leg-2 along +Z face.
//                  Width then extends along Y (the plane-perpendicular axis).
// Origin = inside corner of the L.
module vinkelbeslag(p, leg=90, thick=2, width=undef,
                    orientation="+x+z", system="vaegge") {
    w = is_undef(width) ? thick : width;
    color(BESLAG_COLOR)
    translate(p)
    if (orientation == "+x+z") {
        cube([leg, w, thick]);             // horizontal leg, +X
        cube([thick, w, leg]);             // vertical leg, +Z
    } else if (orientation == "-x+z") {
        translate([-leg, 0, 0])   cube([leg, w, thick]);
        translate([-thick, 0, 0]) cube([thick, w, leg]);
    } else if (orientation == "+y+z") {
        cube([w, leg, thick]);
        cube([w, thick, leg]);
    } else if (orientation == "-y+z") {
        translate([0, -leg, 0])   cube([w, leg, thick]);
        translate([0, -thick, 0]) cube([w, thick, leg]);
    }
}

// Sloping rafter shoe (Simpson-type) for 45×W spær on a top plate.
// Origin = bottom-front-left of the rafter at the bearing point.
//   rafter_w   = rafter cross-section thin dimension (typ 45)
//   rafter_h   = rafter cross-section deep dimension (typ 95-145)
//   slope      = rafter slope angle in degrees (negative for falling)
module spaersko(p, rafter_w=45, rafter_h=95, slope=0, system="tagkonstruktion") {
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
    color(BESLAG_COLOR)
    translate(p) {
        translate([-1, 0, 0])         cube([2, joist_h, joist_h]);
        translate([joist_w-1, 0, 0])  cube([2, joist_h, joist_h]);
        translate([-1, 0, 0])         cube([joist_w + 2, joist_h, 2]);
    }
}
