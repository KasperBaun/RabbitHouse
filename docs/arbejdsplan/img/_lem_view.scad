// Throwaway view — floor frame + basement + open lids w/ fals + greb.
include <../../../src/designs/config.scad>
use <../../../src/designs/house/floor.scad>
use <../../../src/designs/house/basement.scad>
$fn = 32;

RenderHouseBasementFloor();
RenderHouseFloorJoists();
RenderHouseFloorHangers();
RenderHouseFloorDeck();
RenderHouseStairs();
