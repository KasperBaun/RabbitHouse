$fn = 48;

// Change this to: "6x3", "7x3", or "8x4"
preset = "8x4";

dims = preset_dims(preset);
shed_length = dims[0];
shed_width  = dims[1];
shed_height = dims[2];
rabbit_len  = dims[3];
seat_len    = shed_length - rabbit_len;

wall_thickness = 100;
base_height = 120;
roof_thickness = 80;

roof_overhang_front = 180;
roof_overhang_back  = 100;
roof_overhang_side  = 120;
roof_drop_back      = shed_width >= 4000 ? 220 : 180;

front_post_w = 120;
front_top_beam_h = 180;

door_w = 850;
door_h = 2100;

mesh_bottom_z = base_height + wall_thickness;
mesh_top_z    = base_height + shed_height - front_top_beam_h;
mesh_h        = mesh_top_z - mesh_bottom_z;

right_side_clad_h = shed_width >= 4000 ? 1300 : 1200;
right_side_mesh_z = base_height + right_side_clad_h;
right_side_mesh_h = shed_height - front_top_beam_h - right_side_clad_h;

mesh_spacing = 150;
mesh_bar = 8;
mesh_frame = 40;
mesh_depth = 20;

sluice_size = 1000;
sluice_opening_w = 800;
sluice_opening_h = 2100;

rabbit_x0 = 0;
rabbit_x1 = rabbit_len;
seat_x0   = rabbit_x1;
seat_x1   = shed_length;

sluice_x0 = rabbit_x1 - sluice_size - 120;
sluice_x1 = sluice_x0 + sluice_size;
sluice_y0 = 220;
sluice_y1 = sluice_y0 + sluice_size;

clad_board_h = 150;
clad_overlap = 40;
clad_step    = clad_board_h - clad_overlap;
clad_thick   = 24;
clad_lip     = 18;
