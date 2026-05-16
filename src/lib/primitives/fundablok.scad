// Fundablok strip foundation primitive.
//
// DK fundablok = 50 × 15 × 20 cm concrete foundation block (length × width
// × height when laid), dry-stacked in 3 courses in halvstensforbandt with
// cores filled with armed concrete after laying. The continuous ring
// carries all wall lines (perimeter + interior load-bearing walls) and
// sits in a frostfri trench (~80 cm dig, 20 cm stabilgrus bottom layer,
// top of blocks at grade Z=0).
//
// fundablok_ring() renders each block individually with halvstensforbandt
// offsets — odd courses are shifted ½ block (250 mm) along the wall axis
// so vertical seams stagger between courses. Strips whose clear span
// isn't a multiple of 500 mm get a clipped end block (same as real
// practice — cut block on site).

FUNDABLOK_L         = 500;
FUNDABLOK_W         = 150;
FUNDABLOK_H         = 200;
FUNDABLOK_COLOR     = [0.78, 0.76, 0.72];
FUNDABLOK_JOINT     = 3;     // visible seam between blocks in a course
FUNDABLOK_JOINT_Z   = 2;     // visible seam between courses

// One row of fundabloks along +X within a strip of given length.
//   origin       = [x, y] of strip's outer-bottom corner
//   length       = strip length along X
//   z            = block bottom Z
//   start_offset = X position of first joint (0 for even courses, -L/2
//                  for odd courses to stagger seams)
module _fb_strip_x(origin, length, z, start_offset) {
    bl = FUNDABLOK_L; bw = FUNDABLOK_W; bh = FUNDABLOK_H;
    j  = FUNDABLOK_JOINT;
    for (raw_x = [start_offset - bl : bl : length]) {
        x0 = max(raw_x, 0);
        x1 = min(raw_x + bl, length);
        if (x1 - x0 > 1)
            translate([origin[0] + x0 + j/2, origin[1] + j/2, z])
                cube([x1 - x0 - j, bw - j, bh - FUNDABLOK_JOINT_Z]);
    }
}

// One row of fundabloks along +Y within a strip of given length.
module _fb_strip_y(origin, length, z, start_offset) {
    bl = FUNDABLOK_L; bw = FUNDABLOK_W; bh = FUNDABLOK_H;
    j  = FUNDABLOK_JOINT;
    for (raw_y = [start_offset - bl : bl : length]) {
        y0 = max(raw_y, 0);
        y1 = min(raw_y + bl, length);
        if (y1 - y0 > 1)
            translate([origin[0] + j/2, origin[1] + y0 + j/2, z])
                cube([bw - j, y1 - y0 - j, bh - FUNDABLOK_JOINT_Z]);
    }
}

// Multi-course fundablok strip — one segment of a ring, oriented along X
// or Y. Halvstensforbandt offsets are applied automatically across courses.
//   orientation = "X" or "Y"
//   origin      = [x, y] outer-bottom corner of the strip
//   length      = strip length along the chosen axis
//   courses     = number of vertical courses (default 3)
//   top_z       = Z of the top course's top face
module fundablok_strip(orientation, origin, length, courses = 3, top_z = 0) {
    h_per   = FUNDABLOK_H;
    total_h = courses * h_per;
    z_bot   = top_z - total_h;
    color(FUNDABLOK_COLOR)
    for (c = [0 : courses - 1]) {
        z   = z_bot + c * h_per;
        off = (c % 2 == 0) ? 0 : -FUNDABLOK_L / 2;
        if (orientation == "X")
            _fb_strip_x(origin, length, z, off);
        else
            _fb_strip_y(origin, length, z, off);
    }
}

// Continuous fundablok ring around a [ll × ww] rectangle with optional
// cross-walls at the X positions in `partitions_x`. The ring outer face
// is flush with [0,0]..[ll,ww] (the building outer line); the ring extends
// inward only by FUNDABLOK_W (150 mm) on each face.
//
// `top_z` sets the top-of-ring Z (= sokkel-niveau per the Phase 1 spec —
// "Top af ring = sokkel-niveau (= base h), bundrem af alle vægge sidder
// her"). Default 0 keeps the legacy "top at grade" behaviour. Total
// depth = courses × FUNDABLOK_H, so the ring extends `total_h` below
// `top_z` (most of which is buried in the frostfri grøft).
//
//   ll, ww        — footprint length (X), width (Y)
//   courses       — number of vertical courses (default 3 for halvstensforbandt)
//   partitions_x  — list of X coordinates for interior cross-walls
//   top_z         — Z of the top course's top face (sokkel level)
module fundablok_ring(ll, ww, courses = 3, partitions_x = [], top_z = 0) {
    bw      = FUNDABLOK_W;
    bl      = FUNDABLOK_L;
    h_per   = FUNDABLOK_H;
    total_h = courses * h_per;
    z_bot   = top_z - total_h;

    color(FUNDABLOK_COLOR)
    for (c = [0 : courses - 1]) {
        z   = z_bot + c * h_per;
        off = (c % 2 == 0) ? 0 : -bl/2;

        // Front + back strips run the full ring length along X.
        _fb_strip_x([0, 0],         ll, z, off);
        _fb_strip_x([0, ww - bw],   ll, z, off);

        // Left + right strips fill the clear span between front and back.
        _fb_strip_y([0, bw],         ww - 2*bw, z, off);
        _fb_strip_y([ll - bw, bw],   ww - 2*bw, z, off);

        // Interior cross-walls under load-bearing partitions.
        for (px = partitions_x)
            _fb_strip_y([px - bw/2, bw], ww - 2*bw, z, off);
    }
}
