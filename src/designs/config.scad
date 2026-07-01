// Rabbit-house constants. All dimensions in mm.
//
// Layout (L-shape — house front sticks out 1000 mm past yard front):
//   X 0..2000    = house  (gable roof, skifer)            Y 0..3000
//   X 2000..6000 = yard   (mesh-top run)                  Y 1000..3000
//   Y 3000       = shared back wall (continuous X=0..6000)
//   Y 0..1000    = house-only zone (yard does not extend here)
//
// House and yard have DIFFERENT Y-depths:
//   RH_HOUSE_DEPTH = 3000 (Y=0..3000)
//   RH_YARD_DEPTH  = 2000 (Y=1000..3000) — offset by RH_YARD_Y_OFFSET=1000

RH_LENGTH        = 6000;
RH_HOUSE_DEPTH   = 3000;             // hus Y-dybde
RH_YARD_DEPTH    = 2000;             // yard Y-dybde
RH_YARD_Y_OFFSET = 1000;             // yard front-væg's Y-koordinat
RH_BASE_H        = 120;
RH_WALL_T        = 100;
RH_HOUSE_LEN     = 2000;
RH_RUN_LEN       = RH_LENGTH - RH_HOUSE_LEN;  // 4000

// House wall height from sokkel-top to top-plate top. All 4 walls share
// this single eave — the gable rafters in roof_gable.scad sit on top and
// create the pitch. Stack: DPC 2 + bundrem 45 + 2,2m C24 stud + toprem 45
// = 2292 mm, so a stud is exactly 2200 mm. RH_EH_BACK kept equal to
// RH_EH_FRONT so the legacy mono-pitch helpers (yard still uses them via
// its own RH_YARD_EH_*) degenerate to flat for the house.
//
// V4 partition door (RH_HOUSE_DOOR_H=2000) has ~200 mm of header + cripple
// space above the rough opening.
RH_EH_FRONT     = 2292;
RH_EH_BACK      = 2292;

// Yard walls are shorter than the house so the run reads as a separate
// (lower) cage against V4. With the mesh-top cover the yard no longer
// sheds water — front and back share a single 2100 eave so V2 and V5
// walls run flat instead of sloping. Front 2100 keeps room for a 1950
// rough opening yard door (~187 cm leaf height after threshold and top
// frame).
RH_YARD_EH_FRONT = 2100;
RH_YARD_EH_BACK  = 2100;

RH_OH_FRONT     = 220;
RH_OH_BACK      = 180;
RH_OH_SIDE      = 220;
RH_ROOF_THICK   = 80;

// Internal door in the partition wall (X=RH_HOUSE_LEN, faces +X into yard).
// Rough opening for a standard 80x200 cm internal door.
// Y=1500 centres door in partition zone (yard only meets V4 at Y=500..3000).
// Door spans Y=1500..2370.
// Rough opening for a 80x200 internal door (leaf 2000, opening +50).
RH_HOUSE_DOOR_W = 870;
RH_HOUSE_DOOR_H = 2000;
RH_HOUSE_DOOR_Y = 1500;

// Rabbit pet door in the partition (faces +X into yard).
// Y=2700 clears the human door (Y=1500..2370) by 330 mm; pet door spans
// Y=2700..2950, ending 50 mm before the back wall at Y=3000.
RH_PET_DOOR_W   = 250;
RH_PET_DOOR_H   = 300;
RH_PET_DOOR_Y   = 2700;

// Yard outdoor door on the front (Y=0, opens outward).
// Rough opening = full stud height (WALL_TOP_HIGH - PLATE_HEIGHT - STUD_BOTTOM_Z
// = 2008). Top plate doubles as the header — no separate header + cripple
// stack above the opening, same pattern as the V4 partition door. Leaf is
// 2008 − 30 threshold − 50 top frame = 1928 mm.
// X centred on the 4 m front wall: (hl + ll - W) / 2 = 3465.
RH_YARD_DOOR_W  = 1070;
RH_YARD_DOOR_H  = 2008;
RH_YARD_DOOR_X  = 3465;

// Insulated nest box (against the back wall, inside the house).
RH_NEST_X       = 200;
RH_NEST_Y       = 1500;
RH_NEST_W       = 800;
RH_NEST_D       = 900;
RH_NEST_H       = 600;

// Side window on the left exterior wall V3 (X=0, faces -X). Centred in the
// 3 m house depth; sill at adult eye level (~1.1 m above floor).
RH_SIDE_WIN_W   = 700;
RH_SIDE_WIN_H   = 600;
RH_SIDE_WIN_Y   = (RH_HOUSE_DEPTH - RH_SIDE_WIN_W) / 2;   // = 1150, centred
RH_SIDE_WIN_Z   = 1100;

// Front entry door on V1 (Y=0, faces -Y). Centred on the 2 m front wall:
// X=550..1450 = 900 mm leaf opening. Header doubles as top plate (same
// pattern as V4 partition door, since RH_FRONT_DOOR_H=2000 leaves exactly
// PLATE_HEIGHT=45 + cripple stack to wall_top).
RH_FRONT_DOOR_W = 900;
RH_FRONT_DOOR_H = 2000;
RH_FRONT_DOOR_X = (RH_HOUSE_LEN - RH_FRONT_DOOR_W) / 2;  // = 550

// Front windows on V1 — square lights flanking the front door. Each window
// has its own dedicated full-height jamb stud on the door side (not fused
// with the door jamb). Outer side reuses the corner / junction stud as the
// king, with cripples below the sill and above the header at the opening's
// outer edge. Header + sill span the 415 mm opening; visible glass area
// between outer cripple and inner jamb is 370 mm.
// Sill at door-midpoint (RH_FRONT_DOOR_H / 2) above floor.
RH_FRONT_WIN_W       = 415;
RH_FRONT_WIN_H       = 450;
RH_FRONT_WIN_Z       = RH_FRONT_DOOR_H / 2;   // 1000 mm above floor
RH_FRONT_WIN_X_LEFT  = 45;     // opening starts here (right face of corner stud)
RH_FRONT_WIN_X_RIGHT = 1540;   // opening starts here (right face of right-window inner jamb)

// Standard Danish timber sizes.
//   95x180 glulam   — yard top beams sloping under roof
//   45x195 reglar   — interior collar tie
//   70x70 KOMPAKT   — mesh-wall stiles
//   45x95 reglar    — yard corner posts (flush at X=ll), sill plates flat
// RH_POST_W is the shared 95 mm "wide" dimension used by sills, beams, and
// the corner reglar's wide axis — single constant keeps wall envelope sizes
// consistent.
RH_POST_W       = 95;
RH_BEAM_H       = 180;
RH_COLLAR_TIE_W = 45;
RH_COLLAR_TIE_H = 195;
RH_SILL_H       = 45;

// Yard mesh — fine welded wire (predator-proof per REQ-008).
// 13 mm aperture x 1 mm wire (gauge 19 GAW).
RH_MESH_SPACING = 13;
RH_MESH_BAR     = 1;
RH_MESH_FRAME   = 40;
RH_MESH_DEPTH   = 20;
RH_MESH = mesh_spec(spacing = RH_MESH_SPACING, bar   = RH_MESH_BAR,
                    frame   = RH_MESH_FRAME,   depth = RH_MESH_DEPTH);

// Klink cladding profile: 25x125 mm spruce/larch boards, 25 mm overlap,
// step 100 mm. Standard Stark/Bauhaus stock in 4200 mm lengths. Overrides
// the library's DEFAULT_CLAD (24x150 with 40 mm overlap).
RH_CLAD = clad_spec(board_h=125, overlap=25, thick=25, lip=20);

// Board-on-board (1-på-2) profile: 25x150 mm savskåret gran, 25 mm overlap
// per side, 100 mm back-board gap → 250 mm c/c pitch, 50 mm total stickout.
// Standard Aros Savværk / Frøslev / Silvan stock (sold as raw boards).
RH_CLAD_BOB = bob_spec(board_w=150, board_t=25, overlap=25, back_gap=100);

// Vertical wood stiles along yard mesh walls (~1 m c/c).
RH_STILE_W       = 70;
RH_STILE_SPACING = 1000;

// Horizontal mid-rail across yard mesh panels, dividing each into stacked
// ~1 m sections. The yard door's internal mid-rail uses the same Z so the
// line is continuous across the whole front wall.
RH_MID_RAIL_Z_OFFSET = 1000;
RH_MID_RAIL_H        = 40;

// Rafter constants.
RH_RAFTER_W   = 45;
RH_RAFTER_H   = 95;
RH_RAFTER_C2C = 600;

// Fascia board thickness (25x125 pressure-treated spruce, all four eaves).
RH_FASCIA_T   = 25;

// Roof geometry helpers. roof_oz / roof_oz_for return the z of the RAFTER
// TOP (= cover bottom) at the front-eave corner — i.e., RAFTER_H above the
// wall-plate top. So:
//   rafter bottom @ y = wall-plate top      (rafter sits on top plate)
//   rafter top    @ y = roof_underside_at(y) (cover sits on rafter top)
//
// All helpers below are parameterised by zone DEPTH (RH_HOUSE_DEPTH or
// RH_YARD_DEPTH) and Y_OFFSET (0 for hus, RH_YARD_Y_OFFSET for yard).
// `y` arguments are absolute world-Y in all wrappers.
function _span_total(depth) = RH_OH_FRONT + depth + RH_OH_BACK;
function span_total() = _span_total(RH_HOUSE_DEPTH);
function total_drop() =
    (RH_EH_FRONT - RH_EH_BACK) * _span_total(RH_HOUSE_DEPTH) / RH_HOUSE_DEPTH;
function roof_oz() =
    RH_BASE_H + RH_EH_FRONT + RH_RAFTER_H +
    RH_OH_FRONT * total_drop() / _span_total(RH_HOUSE_DEPTH);
function roof_underside_at(y) =
    roof_oz() - (RH_OH_FRONT + y) * total_drop() / _span_total(RH_HOUSE_DEPTH);

// Cover-aware slope: eternit needs a steeper pitch (14° to be spec-correct
// per Cembrit B7 installation guide). Lowering eh_back without re-fitting
// the doors is fine because the front-wall door (high eave) is the
// constrained one.
function back_eave_height_for(cover) =
      cover == "eternit" ? 1976 : RH_EH_BACK;

// Fascia top z-offset above rafter top, per cover.
//   tagpap   : OSB 18 + underlay 3 + felt 4 + STERN_LIP 7 = 32
//   eternit  : BATTEN_T 38 - clearance 8 = 30
//   polycarb : plate 12 + STERN_LIP 7 = 19   (yard only)
function fascia_top_offset_for(cover) =
      cover == "tagpap"   ? (18 + 3 + 4) + 7
    : cover == "eternit"  ? (38 - 8)
    : cover == "polycarb" ? (12 + 7)
    : 0;

// ----- Gable roof geometry (used when cover is "skifer"). Ridge runs along
// Y (parallel to V3 / V4); water sheds onto V3 (left) and V4 (partition /
// yard side). Eave Z is flat at the high wall-top so the front door
// clearance is unchanged.
G_PITCH_DEG   = 35;
// Eave overhang tuned so each half-slope is exactly 5 courses of 30×60 cm
// skifer in halv-forbandt: slope = (G_RIDGE_X + G_OH_EAVE) / cos(35°) =
// 1500 mm = 4 × gauge(225 slope) + 600. Lap = 150 mm (well over the
// 70 mm min for 35° pitch). 229 mm also clears the yard wall top (Z=2220)
// — rafter bottom at X=2229 sits at Z=2252, 32 mm clear.
G_OH_EAVE     = 229;
// No rake overhang — gables sit flush with V1 / V2. Slate slab and rafter
// barge are aligned to the wall faces.
G_OH_RAKE     = 0;
G_RIDGE_X     = RH_HOUSE_LEN / 2;         // = 1000
G_EAVE_Z      = RH_BASE_H + RH_EH_FRONT;  // = 2412, flat eave on all 4 walls

function is_gable_roof(cover) = cover == "skifer";

// Rafter geometry as a function of X. The plane mirrors at G_RIDGE_X.
// Rafter bottom sits at G_EAVE_Z at the wall edges (x=0, x=RH_HOUSE_LEN).
function g_rafter_top_z(x) =
    G_EAVE_Z + RH_RAFTER_H +
    (G_RIDGE_X - abs(x - G_RIDGE_X)) * tan(G_PITCH_DEG);
function g_rafter_bottom_z(x)  = g_rafter_top_z(x) - RH_RAFTER_H;
function g_ridge_top_z()       = g_rafter_top_z(G_RIDGE_X);
function g_ridge_bottom_z()    = g_rafter_bottom_z(G_RIDGE_X);

// ----- Generic roof-geometry helpers parameterised by (eh_front, eh_back,
// depth). `y_offset` shifts the entire roof along Y so the yard (whose
// front eave is at world Y=RH_YARD_Y_OFFSET) gets correct Z back from
// absolute-world Y inputs.
function _roof_drop(eh_front, eh_back, depth) =
    (eh_front - eh_back) * _span_total(depth) / depth;
function _roof_oz(eh_front, eh_back, depth) =
    RH_BASE_H + eh_front + RH_RAFTER_H +
    RH_OH_FRONT * _roof_drop(eh_front, eh_back, depth) / _span_total(depth);
function _roof_underside(eh_front, eh_back, depth, y_offset, y) =
    _roof_oz(eh_front, eh_back, depth) -
    (RH_OH_FRONT + (y - y_offset)) * _roof_drop(eh_front, eh_back, depth)
                                   / _span_total(depth);

// House-friendly wrappers — pin eh_front, depth, y_offset.
function total_drop_for(eh_back)       =
    _roof_drop(RH_EH_FRONT, eh_back, RH_HOUSE_DEPTH);
function roof_oz_for(eh_back)          =
    _roof_oz(RH_EH_FRONT, eh_back, RH_HOUSE_DEPTH);
function roof_underside_for(eh_back, y)=
    _roof_underside(RH_EH_FRONT, eh_back, RH_HOUSE_DEPTH, 0, y);

// Yard helpers — pin eh_front, eh_back, depth, y_offset.
function yard_total_drop()       =
    _roof_drop(RH_YARD_EH_FRONT, RH_YARD_EH_BACK, RH_YARD_DEPTH);
function yard_roof_oz()          =
    _roof_oz(RH_YARD_EH_FRONT, RH_YARD_EH_BACK, RH_YARD_DEPTH);
function yard_roof_underside(y)  =
    _roof_underside(RH_YARD_EH_FRONT, RH_YARD_EH_BACK, RH_YARD_DEPTH,
                    RH_YARD_Y_OFFSET, y);

// DPC tape thickness between sokkel ring and sill plate. The sill plate sits
// ON the DPC band, not directly on the ring — so floor level is 2 mm higher
// than the ring top.
RH_DPC_T = 2;

// Sill-plate top — the datum that doors and cladding key off (= bundrem top).
// NOTE: the board floor itself is recessed lower (its top sits at the ring top,
// see RH_FLOOR_DECK_TOP) so this level is ~47 mm above the floorboards — the
// bundrem/walls form a lip around the floor.
RH_FLOOR_TOP = RH_BASE_H + RH_DPC_T + RH_SILL_H;

// Yard sill plate top — same level as house floor (also sits on DPC).
RH_YARD_SILL_TOP = RH_FLOOR_TOP;

// Cladding stack thicknesses — used by cladding.scad to step each layer
// outward from the stud face. Klink thickness comes from RH_CLAD via
// cs_thick(clad).
RH_HOUSEWRAP_T      = 1;     // wind barrier / housewrap membrane
RH_COUNTER_BATTEN_T = 22;    // 22x45 vertical battens

// House floor: 45×95 reglar laid as a frame hard against the inside of the
// fundablok ring — one along each wall (V3, V4, V1, V2) screwed directly into
// the ring — plus one transverse reglar across the middle (V3→V4 at Y≈1500).
// Nothing is stacked. A ~25 mm sawn-board deck runs the short way (X) on top,
// its TOP flush with the ring top (sokkel, RH_BASE_H=120).
RH_FLOOR_DECK_T    = 25;
RH_FLOOR_REGLAR_W  = 45;    // reglar width in plan
RH_FLOOR_REGLAR_H  = 95;    // reglar height (on edge)
RH_FLOOR_DECK_TOP  = RH_BASE_H;                           // 120 — flush with ring top
RH_FLOOR_DECK_Z    = RH_FLOOR_DECK_TOP - RH_FLOOR_DECK_T; // 95  — deck underside = reglar top
RH_FLOOR_REGLAR_Z  = RH_FLOOR_DECK_Z - RH_FLOOR_REGLAR_H; // 0   — reglar bottom (≈grade)

// Basement ("kælder"): the hollow fundablok ring is a usable pit. A concrete
// floor slab sits at the ring bottom; floor hatches ("lem") with hinged lids +
// staircases ("trappe") at the front + human doors give access down to it.
RH_FOUNDATION_DEPTH = 800;                     // ring = 4 fundablok courses × 200 mm
RH_BASEMENT_FLOOR_Z = RH_BASE_H - RH_FOUNDATION_DEPTH;   // -680 — concrete top = ring bottom
RH_BASEMENT_SLAB_T  = 100;                     // slab thickness (on stabilgrus)

// Floor hatch rects [x0, y0, x1, y1] — placed inside the reglar frame and clear
// of the transverse mid-reglar (Y 1477.5..1522.5) so no reglar is cut.
// Both hatches 700 (along their wall) × 900 (long axis INTO the room):
RH_HATCH_FRONT = [650, 195, 1350, 1095];       // V1: 700 along X (wall) × 900 into +Y
RH_HATCH_HUMAN = [905, 1585, 1805, 2285];      // V4: 900 into -X × 700 along Y, centred on hus-dør (Y1935)

// Staircase (steep utility/ladder access). Drop = RH_FLOOR_DECK_TOP - RH_BASEMENT_FLOOR_Z.
RH_STAIR_W      = 550;   // tread width
RH_STAIR_RISERS = 6;     // number of risers (≈133 mm each over the 800 mm drop)
RH_STAIR_GOING  = 100;   // tread depth — steep (~53°), run ≈ 600 mm so it doesn't fill the basement
