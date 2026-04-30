// Context vectors and accessors. Things that travel together get bundled,
// so library modules don't grow 15-arg signatures.
//
// Conventions:
//  - dims:      basic geometric envelope (length, width, eave height, ...)
//  - palette:   colors used by every module
//  - clad_spec: cladding board geometry
//  - mesh_spec: mesh aperture / bar / frame
//  - stud_spec: stud framing

// --- dims --------------------------------------------------------------------

function dims(length, width, eave_h=2500, base_h=120, wall_t=100) =
    [length, width, eave_h, base_h, wall_t];

function dims_length(d) = d[0];
function dims_width(d)  = d[1];
function dims_eave_h(d) = d[2];
function dims_base_h(d) = d[3];
function dims_wall_t(d) = d[4];

// --- palette -----------------------------------------------------------------

function palette(
    post   = [0.72, 0.56, 0.30],
    wall   = [0.78, 0.65, 0.45],
    panel1 = [0.62, 0.45, 0.22],
    panel2 = [0.56, 0.40, 0.18],
    trim   = [0.58, 0.42, 0.20],
    mesh   = [0.25, 0.25, 0.25],
    roof   = [0.15, 0.15, 0.15],
    glass  = [0.70, 0.82, 0.88, 0.35],
    base   = [0.78, 0.78, 0.74],
    floor  = [0.80, 0.72, 0.52],
    table  = [0.72, 0.56, 0.34],
    bench  = [0.80, 0.70, 0.48],
    door   = [0.66, 0.48, 0.24],
    lamp   = [0.20, 0.20, 0.18],
    glow   = [1.00, 0.92, 0.60, 0.50],
    elec   = [0.85, 0.85, 0.82],
    laptop = [0.22, 0.22, 0.24],
    screen = [0.30, 0.55, 0.75, 0.60],
    shelf  = [0.65, 0.50, 0.28],
    polycarb = [0.78, 0.85, 0.92, 0.30],
    insulation = [0.95, 0.90, 0.65]
) = [post, wall, panel1, panel2, trim, mesh, roof, glass, base, floor,
     table, bench, door, lamp, glow, elec, laptop, screen, shelf,
     polycarb, insulation];

function pal_post(p)       = p[0];
function pal_wall(p)       = p[1];
function pal_panel1(p)     = p[2];
function pal_panel2(p)     = p[3];
function pal_trim(p)       = p[4];
function pal_mesh(p)       = p[5];
function pal_roof(p)       = p[6];
function pal_glass(p)      = p[7];
function pal_base(p)       = p[8];
function pal_floor(p)      = p[9];
function pal_table(p)      = p[10];
function pal_bench(p)      = p[11];
function pal_door(p)       = p[12];
function pal_lamp(p)       = p[13];
function pal_glow(p)       = p[14];
function pal_elec(p)       = p[15];
function pal_laptop(p)     = p[16];
function pal_screen(p)     = p[17];
function pal_shelf(p)      = p[18];
function pal_polycarb(p)   = p[19];
function pal_insulation(p) = p[20];

// --- clad_spec ---------------------------------------------------------------

function clad_spec(board_h=150, overlap=40, thick=24, lip=18) =
    [board_h, overlap, thick, lip];

function cs_board_h(c) = c[0];
function cs_overlap(c) = c[1];
function cs_thick(c)   = c[2];
function cs_lip(c)     = c[3];
function cs_step(c)    = c[0] - c[1];

// --- mesh_spec ---------------------------------------------------------------

function mesh_spec(spacing=150, bar=8, frame=40, depth=20) =
    [spacing, bar, frame, depth];

function ms_spacing(m) = m[0];
function ms_bar(m)     = m[1];
function ms_frame(m)   = m[2];
function ms_depth(m)   = m[3];

// --- stud_spec ---------------------------------------------------------------

function stud_spec(stud_w=45, stud_d=95, spacing=600) =
    [stud_w, stud_d, spacing];

function ss_w(s)       = s[0];
function ss_d(s)       = s[1];
function ss_spacing(s) = s[2];
