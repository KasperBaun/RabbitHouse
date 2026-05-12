// Ground: outdoor grass surface around and under the building.

include <config.scad>
use <../lib/decor/landscape.scad>

module RenderGround() {
    ground_grass([RH_LENGTH/2, RH_WIDTH/2]);
}
