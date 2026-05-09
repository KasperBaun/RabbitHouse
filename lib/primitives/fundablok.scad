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
// cross-walls at the X positions in `partitions_x`. The ring is centred
// on the building outer line; cross-walls are centred on their X line
// and span between the perimeter ring's inner faces.
//
// Top of foundation is Z=0 (grade); total depth = courses × FUNDABLOK_H.
//
//   ll, ww        — footprint length (X), width (Y)
//   courses       — number of vertical courses (default 3 for halvstensforbandt)
//   partitions_x  — list of X coordinates for interior cross-walls
module fundablok_ring(ll, ww, courses = 3, partitions_x = []) {
    bw      = FUNDABLOK_W;
    h_per   = FUNDABLOK_H;
    total_h = courses * h_per;
    z_bot   = -total_h;

    color(FUNDABLOK_COLOR) {
        // Outer perimeter ring: solid rectangle minus inner cavity
        difference() {
            translate([-bw/2, -bw/2, z_bot])
                cube([ll + bw, ww + bw, total_h]);
            translate([bw/2, bw/2, z_bot - 1])
                cube([ll - bw, ww - bw, total_h + 2]);
        }
        // Interior cross-walls under load-bearing partitions
        for (px = partitions_x)
            translate([px - bw/2, bw/2, z_bot])
                cube([bw, ww - bw, total_h]);
    }
}
