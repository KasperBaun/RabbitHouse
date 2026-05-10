// Outdoor landscaping: ground plane and gravel paths.

include <../defaults.scad>

// Grass ground plane covering a square centered on the structure.
module ground_grass(center, size=14000) {
    cx = center[0]; cy = center[1];
    color([0.40, 0.58, 0.30])
    translate([cx - size/2, cy - size/2, -5])
        cube([size, size, 5]);
}

// Gravel path running from a face of the structure outward in -Y.
//   start = [x_center, y_face]
//   length = how far the path extends in -Y
//   path_w = width
module gravel_path_y(start, length=3500, path_w=1200) {
    sx = start[0]; sy = start[1];
    color([0.72, 0.68, 0.60])
    translate([sx - path_w/2, sy - length, -3])
        cube([path_w, length, 8]);
    // Widening at the threshold
    color([0.72, 0.68, 0.60])
    hull() {
        translate([sx - path_w/2, sy - 500, -3])
            cube([path_w, 10, 8]);
        translate([sx - path_w/2 - 200, sy - 100, -3])
            cube([path_w + 400, 10, 8]);
    }
}
