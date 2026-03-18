include <presets.scad>
include <config.scad>

include <helpers/colors.scad>
include <helpers/mesh.scad>
include <helpers/roof.scad>

include <modules/base.scad>
include <modules/walls.scad>
include <modules/rabbit.scad>
include <modules/decor.scad>

$vpt = [shed_length/2, shed_width/2, shed_height/2];
$vpr = [55, 0, 25];
$vpd = 18000;

// --- Landscaping & ground ---
landscaping();

// --- Foundation ---
floor_slab();
rabbit_floor();

// --- Back wall frame ---
back_wall_core();

// --- Right side wall (mesh) ---
rabbit_right_mesh_frame();
rabbit_right_mesh();

// --- Front wall ---
front_posts_and_beam();
front_rabbit_mesh();
front_gate();

// --- Left side wall (mesh) ---
rabbit_left_mesh_frame();
rabbit_left_mesh();

// --- Back wall mesh ---
rabbit_back_mesh();

// --- Roof ---
roof();
roof_fascia_and_gutter();
ceiling_rafters();

// --- Rabbit area ---
rabbit_accessories();
