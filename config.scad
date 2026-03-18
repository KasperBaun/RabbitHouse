$fn = 48;

// Change this to: "4x3", "5x3", or "6x4"
preset = "5x3";

dims = preset_dims(preset);
shed_length = dims[0];
shed_width  = dims[1];
shed_height = dims[2];

wall_thickness = 100;
base_height = 120;
roof_thickness = 80;

roof_overhang_front = 180;
roof_overhang_back  = 100;
roof_overhang_side  = 120;
roof_drop_back      = shed_width >= 4000 ? 220 : 180;

front_post_w = 120;
front_top_beam_h = 180;

// Access gate on front wall
gate_w = 900;

mesh_bottom_z = base_height + wall_thickness;
mesh_top_z    = base_height + shed_height - front_top_beam_h;
mesh_h        = mesh_top_z - mesh_bottom_z;

mesh_spacing = 150;
mesh_bar = 8;
mesh_frame = 40;
mesh_depth = 20;
