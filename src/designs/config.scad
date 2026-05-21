// Rabbit-house constants. All dimensions in mm.
//
// Layout (L-shape — house front sticks out 500 mm past yard front):
//   X 0..2000    = house  (gable roof, skifer)            Y 0..3000
//   X 2000..6000 = yard   (monopitch roof, polycarb)      Y 500..3000
//   Y 3000       = shared back wall (continuous X=0..6000)
//   Y 0..500     = house-only zone (yard does not extend here)
//
// House and yard have DIFFERENT Y-depths:
//   RH_HOUSE_DEPTH = 3000 (Y=0..3000)
//   RH_YARD_DEPTH  = 2500 (Y=500..3000) — offset by RH_YARD_Y_OFFSET=500

RH_LENGTH        = 6000;
RH_HOUSE_DEPTH   = 3000;             // hus Y-dybde
RH_YARD_DEPTH    = 2500;             // yard Y-dybde
RH_YARD_Y_OFFSET = 500;              // yard front-væg's Y-koordinat
RH_BASE_H        = 120;
RH_WALL_T        = 100;
RH_HOUSE_LEN     = 2000;
RH_RUN_LEN       = RH_LENGTH - RH_HOUSE_LEN;  // 4000

// Wall heights from sokkel-top (Z=RH_BASE_H) to roof underside at the wall
// face. Drop 200 over 2500 = 4.6 deg, 8 % fall — adequate for tagpap_osb
// (min 2.5 % per spec). Eternit and steel covers lower RH_EH_BACK further.
//
// Heights chosen so standard Danish doors fit:
//   front (RH_EH_FRONT=2400) takes a 95x205 outdoor door (rough 1070x2120)
//   partition (RH_EH_BACK=2200) takes a 80x200 internal door (rough 870x2050)
RH_EH_FRONT     = 2400;
RH_EH_BACK      = 2200;

// Yard walls are shorter than the house so the two roofs read as separate
// structures (yard reads as a "lean-to" against V5). Front 2100 keeps room
// for a 1950 rough opening yard door (~187 cm leaf height after threshold
// and top frame); back 1800 gives a 6,9° slope.
RH_YARD_EH_FRONT = 2100;
RH_YARD_EH_BACK  = 1800;

RH_OH_FRONT     = 220;
RH_OH_BACK      = 180;
RH_OH_SIDE      = 220;
RH_ROOF_THICK   = 80;

// Internal door in the partition wall (X=RH_HOUSE_LEN, faces +X into yard).
// Rough opening for a standard 80x200 cm internal door.
// Y=1500 centres door in partition zone (yard only meets V5 at Y=500..3000).
// Door spans Y=1500..2370.
RH_HOUSE_DOOR_W = 870;
RH_HOUSE_DOOR_H = 2050;
RH_HOUSE_DOOR_Y = 1500;

// Rabbit pet door in the partition (faces +X into yard).
// Y=2700 clears the human door (Y=1500..2370) by 330 mm; pet door spans
// Y=2700..2950, ending 50 mm before the back wall at Y=3000.
RH_PET_DOOR_W   = 250;
RH_PET_DOOR_H   = 300;
RH_PET_DOOR_Y   = 2700;

// Yard outdoor door on the front (Y=0, opens outward).
// Rough opening sized to fit under the lower yard front eave (RH_YARD_EH_FRONT
// = 2100): 1950 leaves 45 mm header + 105 mm cripple space.
RH_YARD_DOOR_W  = 1070;
RH_YARD_DOOR_H  = 1950;
RH_YARD_DOOR_X  = 3000;

// Insulated nest box (against the back wall, inside the house).
RH_NEST_X       = 200;
RH_NEST_Y       = 1500;
RH_NEST_W       = 800;
RH_NEST_D       = 900;
RH_NEST_H       = 600;

// Side window on the left exterior wall (X=0, faces -X). Centred in Y;
// sill at adult eye level (~1.1 m above floor).
RH_SIDE_WIN_W   = 700;
RH_SIDE_WIN_H   = 600;
RH_SIDE_WIN_Y   = 900;
RH_SIDE_WIN_Z   = 1100;

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

// Cover-aware slope: eternit B7 needs steeper pitch. Lowering eh_back
// without re-fitting the doors is fine because the front-wall door (high
// eave) is the constrained one. Polycarbonate works at the default 4,6°.
function back_eave_height_for(cover) =
      cover == "eternit_10" ? 2160
    : cover == "eternit_14" ? 1976
    : RH_EH_BACK;

// Fascia top z-offset above rafter top, per cover.
//   tagpap   : OSB 18 + underlay 3 + felt 4 + STERN_LIP 7 = 32
//   eternit  : BATTEN_T 38 - clearance 8 = 30
//   polycarb : plate 12 + STERN_LIP 7 = 19
//   shingles : OSB 18 + underlay 3 + shingle 5 + STERN_LIP 7 = 33
function fascia_top_offset_for(cover) =
      cover == "tagpap_osb" || cover == "tagpap" ? (18 + 3 + 4) + 7
    : cover == "eternit_b7" || cover == "eternit_10" || cover == "eternit_14" ? (38 - 8)
    : cover == "polycarb" ? (12 + 7)
    : cover == "shingles" ? (18 + 3 + 5) + 7
    : 0;

// ----- Gable roof geometry (used when cover is "skifer" — and future
// "tagsten"). Ridge runs along Y (parallel to V3 / V5, the 2,5 m walls);
// water sheds onto V3 (left) and V5 (partition / yard side). Eave Z is
// flat at the high wall-top so the front door clearance is unchanged.
G_PITCH_DEG   = 35;
G_OH_EAVE     = 220;                      // overhang over V3 / V5 — tilpasset 133 stk skifer 30×60 (var 350)
G_OH_RAKE     = 150;                      // overhang past V1 / V2 gables
G_RIDGE_X     = RH_HOUSE_LEN / 2;         // = 1000
G_EAVE_Z      = RH_BASE_H + RH_EH_FRONT;  // = 2520, flat eave on V3 + V5

function is_gable_roof(cover) = cover == "skifer" || cover == "tagsten";

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

// Floor finish (plywood top) flush with sill plate top so doors land at
// floor level. Floor_top = ring_top + DPC + sill plate thickness.
RH_FLOOR_TOP = RH_BASE_H + RH_DPC_T + RH_SILL_H;

// Yard sill plate top — same level as house floor (also sits on DPC).
RH_YARD_SILL_TOP = RH_FLOOR_TOP;

// Cladding stack thicknesses — used by cladding.scad to step each layer
// outward from the stud face. Klink thickness comes from RH_CLAD via
// cs_thick(clad).
RH_HOUSEWRAP_T      = 1;     // wind barrier / housewrap membrane
RH_COUNTER_BATTEN_T = 22;    // 22x45 vertical battens

// House floor (joists + plywood inside the fundablok ring).
RH_FLOOR_LEDGER_W   = 95;
RH_FLOOR_LEDGER_H   = 45;
RH_FLOOR_DECK_T     = 18;
RH_FLOOR_JOIST_W    = 45;
RH_FLOOR_JOIST_H    = 95;
RH_FLOOR_JOIST_C2C  = 600;
RH_FLOOR_DECK_Z     = RH_FLOOR_TOP - RH_FLOOR_DECK_T;
RH_FLOOR_LEDGER_Z   = RH_FLOOR_DECK_Z - RH_FLOOR_JOIST_H;
