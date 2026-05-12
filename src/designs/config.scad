// Rabbit-house constants. All dimensions in mm.
//
// Layout:
//   X 0..1500    = solid mono-pitch house (rabbit shelter + insulated nest box)
//   X 1500..6000 = mesh-walled yard (human entry via door on front)
//   Y 0          = front (open garden face / human entry / high eave)
//   Y 2500       = back (prevailing-wind side / low eave / gutter)
//
// Roof: ONE continuous mono-pitch slab over the entire footprint, sloping
// front-to-back. Slope depends on the chosen cover (see RH_EH_BACK and
// back_eave_height_for(cover) below).

RH_LENGTH       = 6000;
RH_WIDTH        = 2500;
RH_BASE_H       = 120;
RH_WALL_T       = 100;
RH_HOUSE_LEN    = 1500;
RH_RUN_LEN      = 4500;

// Wall heights from sokkel-top (Z=RH_BASE_H) to roof underside at the wall
// face. Drop 200 over 2500 = 4.6 deg, 8 % fall — adequate for tagpap_osb
// (min 2.5 % per spec). Eternit and steel covers lower RH_EH_BACK further.
//
// Heights chosen so standard Danish doors fit:
//   front (RH_EH_FRONT=2400) takes a 95x205 outdoor door (rough 1070x2120)
//   partition (RH_EH_BACK=2200) takes a 80x200 internal door (rough 870x2050)
RH_EH_FRONT     = 2400;
RH_EH_BACK      = 2200;

RH_OH_FRONT     = 220;
RH_OH_BACK      = 180;
RH_OH_SIDE      = 220;
RH_ROOF_THICK   = 80;

// Internal door in the partition wall (X=RH_HOUSE_LEN, faces +X into yard).
// Rough opening for a standard 80x200 cm internal door.
RH_HOUSE_DOOR_W = 870;
RH_HOUSE_DOOR_H = 2050;
RH_HOUSE_DOOR_Y = 200;

// Rabbit pet door in the partition (faces +X into yard).
RH_PET_DOOR_W   = 250;
RH_PET_DOOR_H   = 300;
RH_PET_DOOR_Y   = 1500;

// Yard outdoor door on the front (Y=0, opens outward).
// Rough opening for a standard 95x205 cm outdoor door.
RH_YARD_DOOR_W  = 1070;
RH_YARD_DOOR_H  = 2120;
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
function span_total() = RH_OH_FRONT + RH_WIDTH + RH_OH_BACK;
function total_drop() =
    (RH_EH_FRONT - RH_EH_BACK) * span_total() / RH_WIDTH;
function roof_oz() =
    RH_BASE_H + RH_EH_FRONT + RH_RAFTER_H +
    RH_OH_FRONT * total_drop() / span_total();
function roof_underside_at(y) =
    roof_oz() - (RH_OH_FRONT + y) * total_drop() / span_total();

// Cover-aware slope: eternit B7 needs steeper pitch. Lowering eh_back
// without re-fitting the doors is fine because the front-wall door (high
// eave) is the constrained one.
function back_eave_height_for(cover) =
      cover == "eternit_10" ? 2160
    : cover == "eternit_14" ? 1976
    : RH_EH_BACK;

function total_drop_for(eh_back) =
    (RH_EH_FRONT - eh_back) * span_total() / RH_WIDTH;
function roof_oz_for(eh_back) =
    RH_BASE_H + RH_EH_FRONT + RH_RAFTER_H +
    RH_OH_FRONT * total_drop_for(eh_back) / span_total();
function roof_underside_for(eh_back, y) =
    roof_oz_for(eh_back) - (RH_OH_FRONT + y) * total_drop_for(eh_back) / span_total();

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
