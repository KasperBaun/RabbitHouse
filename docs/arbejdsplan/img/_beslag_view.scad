// Doc image — floor bearing frame + strøsko (joist hangers), no deck, so the
// beslag at every hung junction are visible. Rendered from floor.scad.
include <../../../src/designs/config.scad>
use <../../../src/designs/house/floor.scad>
$fn = 32;

RenderHouseFloorJoists();
RenderHouseFloorHangers();
