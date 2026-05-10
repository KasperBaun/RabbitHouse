// Fundablok strip foundation primitive.
//
// DK fundablok = 50 × 15 × 20 cm concrete foundation block (length × width
// × height when laid), dry-stacked in 3 courses in halvstensforbandt with
// cores filled with armed concrete after laying. The continuous ring
// carries all wall lines (perimeter + interior load-bearing walls) and
// sits in a frostfri trench (~80 cm dig, 20 cm stabilgrus bottom layer,
// top of blocks at grade Z=0).
//
// fundablok_ring() renders a simplified solid extrusion in concrete
// colour; individual blocks and forbandt joints are not visualised.
// Block counts are tracked in docs/version 3/materialeliste.csv.

FUNDABLOK_L      = 500;
FUNDABLOK_W      = 150;
FUNDABLOK_H      = 200;
FUNDABLOK_COLOR  = [0.78, 0.76, 0.72];

// Continuous fundablok ring around a [ll × ww] rectangle with optional
// cross-walls at the X positions in `partitions_x`. The ring outer face
// is flush with [0,0]..[ll,ww] (the building outer line); the ring extends
// inward only by FUNDABLOK_W (150 mm) on each face.
//
// `top_z` sets the top-of-ring Z (= sokkel-niveau per the Phase 1 spec —
// "Top af ring = sokkel-niveau (= base h), bundrem af alle vægge sidder
// her"). Default 0 keeps the legacy "top at grade" behaviour. Total
// depth = courses × FUNDABLOK_H, so the ring extends `total_h` below
// `top_z` (most of which is buried in the frostfri grøft).
//
//   ll, ww        — footprint length (X), width (Y)
//   courses       — number of vertical courses (default 3 for halvstensforbandt)
//   partitions_x  — list of X coordinates for interior cross-walls
//   top_z         — Z of the top course's top face (sokkel level)
module fundablok_ring(ll, ww, courses = 3, partitions_x = [], top_z = 0) {
    bw      = FUNDABLOK_W;
    h_per   = FUNDABLOK_H;
    total_h = courses * h_per;
    z_bot   = top_z - total_h;

    color(FUNDABLOK_COLOR) {
        // Outer perimeter ring: solid rectangle minus inner cavity.
        // Outer face flush at [0,0]..[ll,ww]; ring extends inward by bw.
        difference() {
            translate([0, 0, z_bot])
                cube([ll, ww, total_h]);
            translate([bw, bw, z_bot - 1])
                cube([ll - 2*bw, ww - 2*bw, total_h + 2]);
        }
        // Interior cross-walls under load-bearing partitions
        for (px = partitions_x)
            translate([px - bw/2, bw, z_bot])
                cube([bw, ww - 2*bw, total_h]);
    }
}
