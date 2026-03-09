module floor_slab() {
    color(col_base)
        cube([shed_length, shed_width, base_height]);
}

module interior_floor() {
    color(col_floor)
    translate([wall_thickness, wall_thickness, base_height])
        cube([shed_length - 2*wall_thickness, shed_width - 2*wall_thickness, 20]);
}
