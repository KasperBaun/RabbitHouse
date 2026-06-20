// Ground: outdoor grass surface around and under the building.
// Bounding-box center: hus + yard L-shape spans X=0..RH_LENGTH and
// Y=0..max(RH_HOUSE_DEPTH, RH_YARD_Y_OFFSET+RH_YARD_DEPTH) = 3000.

include <config.scad>
use <../lib/decor/landscape.scad>

module RenderGround() {
    yd_back = max(RH_HOUSE_DEPTH, RH_YARD_Y_OFFSET + RH_YARD_DEPTH);
    difference() {
        ground_grass([RH_LENGTH/2, yd_back/2]);
        // No grass under / inside the house foundation ring (the floor + crawl
        // space sit there). Yard keeps its grass at grade (X > RH_HOUSE_LEN).
        translate([0, 0, -6])
            cube([RH_HOUSE_LEN, RH_HOUSE_DEPTH, 7]);
    }
}
