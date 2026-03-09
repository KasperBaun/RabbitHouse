include <presets.scad>
include <config.scad>

include <helpers/colors.scad>
include <helpers/mesh.scad>
include <helpers/cladding.scad>
include <helpers/roof.scad>

include <modules/base.scad>
include <modules/walls.scad>
include <modules/seating.scad>
include <modules/build.scad>

$vpt = [shed_length/2, shed_width/2, shed_height/2];
$vpr = [55, 0, 25];
$vpd = 18000;

build_rabbit_house();
