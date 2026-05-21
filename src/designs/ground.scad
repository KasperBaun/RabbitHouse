// Ground: outdoor grass surface around and under the building.
// Bounding-box center: hus + yard L-shape spans X=0..RH_LENGTH and
// Y=0..max(RH_HOUSE_DEPTH, RH_YARD_Y_OFFSET+RH_YARD_DEPTH) = 3000.

include <config.scad>
use <../lib/decor/landscape.scad>

module RenderGround() {
    yd_back = max(RH_HOUSE_DEPTH, RH_YARD_Y_OFFSET + RH_YARD_DEPTH);
    ground_grass([RH_LENGTH/2, yd_back/2]);
}
