include <presets.scad>
include <config.scad>

include <helpers/colors.scad>
include <helpers/mesh.scad>
include <helpers/cladding.scad>
include <helpers/roof.scad>

include <modules/base.scad>
include <modules/walls.scad>
include <modules/seating.scad>

$vpt = [shed_length/2, shed_width/2, shed_height/2];
$vpr = [55, 0, 25];
$vpd = 18000;

// --- Foundation ---
floor_slab();
interior_floor();

// --- Back wall ---
back_wall_core();

// --- Right side wall ---
seat_right_lower_wall();
seat_right_side_frame();

// --- Front wall ---
front_posts_and_beam();
front_rabbit_mesh();

// --- Left side wall (rabbit mesh) ---
rabbit_left_mesh_frame();
rabbit_left_mesh();

// --- Divider wall ---
rabbit_seating_mesh_divider();

// --- Roof ---
roof();

// --- Interior panels (hide studs) ---
interior_panels();

// --- Cladding ---
back_cladding();
right_side_cladding();

// --- Right side window ---
right_side_window();

// --- Furniture ---
built_in_corner_bench();
seating_table();
