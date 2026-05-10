// House-yard v3 — constants.
//
// Layout (mm):
//   X 0..1500    = solid mono-pitch house (rabbit shelter + insulated nest
//                  box). Human entry is from inside the yard.
//   X 1500..6000 = mesh-walled yard. Human entry via a mesh door on the
//                  front. (Foundation: continuous fundablok ring around
//                  whole 6×2.5 m perimeter; see Phase 1 spec.)
//   Y 0          = front (open garden face / human entry / high eave)
//   Y 2500       = back (prevailing-wind side / low eave / gutter)
//
// Roof: ONE continuous mono-pitch slab spans the entire 6 m × 2.5 m footprint,
// sloping front-to-back. Wall-face heights are eh_front=2600, eh_back=2200
// (drop 400 over 2500 = 9.09°, 16 % fald). The roof primitive interprets
// `eave_h` and `drop` across the FULL OVERHANG SPAN, so v3 derives a
// corrected origin Z and total drop (see V3_ROOF_*) so the wall tops align
// with the roof underside at the wall faces, not just at the overhang tips.

V3_LENGTH       = 6000;
V3_WIDTH        = 2500;
V3_BASE_H       = 120;
V3_WALL_T       = 100;
V3_HOUSE_LEN    = 1500;
V3_RUN_LEN      = 4500;

V3_EH_FRONT     = 2600;
V3_EH_BACK      = 2200;

// Roof overhangs
V3_OH_FRONT     = 220;
V3_OH_BACK      = 180;
V3_OH_SIDE      = 220;
V3_ROOF_THICK   = 80;

// Human door in the partition (X=V3_HOUSE_LEN, faces +X into the yard).
V3_HOUSE_DOOR_W = 850;
V3_HOUSE_DOOR_H = 2100;
V3_HOUSE_DOOR_Y = 200;       // along Y on the partition

// Rabbit pet door (partition at X=V3_HOUSE_LEN, faces +X into yard).
V3_PET_DOOR_W   = 250;
V3_PET_DOOR_H   = 300;
V3_PET_DOOR_Y   = 1500;

// Yard mesh door (front face Y=0, opens outward to garden).
V3_YARD_DOOR_W  = 850;
V3_YARD_DOOR_H  = 1900;
V3_YARD_DOOR_X  = 3000;      // X along front (left edge of the door)

// Insulated nest box (against back wall, in main house space). With house
// shortened to 1500 mm, X anchor moved from 1100 → 200 so the 800-wide box
// (X=200..1000) fits comfortably inside the partition wall at X=1500.
V3_NEST_X       = 200;
V3_NEST_Y       = 1500;
V3_NEST_W       = 800;
V3_NEST_D       = 900;
V3_NEST_H       = 600;

// Side window on left exterior wall (X=0, faces -X).
V3_SIDE_WIN_W   = 700;
V3_SIDE_WIN_H   = 600;
V3_SIDE_WIN_Y   = 1300;
V3_SIDE_WIN_Z   = 1100;

// Buried mesh apron around yard exterior (predator dig defence).
V3_APRON_W      = 500;

// Standard Danish timber sizes used by the yard structure.
//   95×180 limtræ      — yard top beams, sloping under roof (V3_BEAM_H)
//   45×195 reglar      — interior collar tie (V3_COLLAR_TIE_H)
//   70×70 KOMPAKT      — mesh-wall stiles (V3_STILE_W)
//   45×95 reglar       — right-end corner reglar (cross-section 45×95,
//                        outer face flush at X=ll); replaced 95×95 stolper
//                        once the fundablok ring carried the load line
//   45×95 reglar flat  — yard sill plate, 95 wide × 45 tall (V3_SILL_H)
// V3_POST_W is the SHARED 95 mm "wide" dimension used by sills, beams,
// and the corner reglar's wide axis — kept as a single constant so wall
// envelope dimensions stay consistent.
V3_POST_W       = 95;
V3_BEAM_H       = 180;
V3_COLLAR_TIE_W = 45;        // 45×195 reglar laid on edge
V3_COLLAR_TIE_H = 195;
V3_SILL_H       = 45;

// Mesh spec for the yard — fine welded wire (predator-proof per REQ-008).
//   13 mm aperture × 1 mm wire (≈ gauge 19 GAW)
V3_MESH_SPACING = 13;
V3_MESH_BAR     = 1;
V3_MESH_FRAME   = 40;
V3_MESH_DEPTH   = 20;

// Vertical wood stiles every ~1 m along yard mesh walls.
V3_STILE_W      = 70;
V3_STILE_SPACING = 1000;

// Horizontal mid-rail across yard mesh panels — divides each panel into
// stacked ~1 m × 1 m mesh sections for a fence-panel look. The yard door's
// internal mid-rail uses the same Z so the rail line is continuous across
// the whole front wall.
V3_MID_RAIL_Z_OFFSET = 1000;       // above sill top
V3_MID_RAIL_H        = 40;         // matches mesh frame thickness

// Roof geometry helpers — kept here (rather than build.scad) so that the
// per-system files (vaegge.scad, fundament.scad, ...) can see them via
// `include <config.scad>`. `roof_mono_pitch` interprets eave_h/drop across
// the FULL overhang span, so we derive a corrected origin Z and total drop
// (V3_OH_FRONT and V3_OH_BACK overhangs) so wall tops align with the roof
// underside at the wall faces, not just at the overhang tips.
function v3_span_total() = V3_OH_FRONT + V3_WIDTH + V3_OH_BACK;
function v3_total_drop() =
    (V3_EH_FRONT - V3_EH_BACK) * v3_span_total() / V3_WIDTH;
function v3_roof_oz() =
    V3_BASE_H + V3_EH_FRONT + V3_OH_FRONT * v3_total_drop() / v3_span_total();
// Roof underside z at any Y (in structure coords, where Y=0 is front face).
function v3_roof_under(y) =
    v3_roof_oz() - (V3_OH_FRONT + y) * v3_total_drop() / v3_span_total();

// House floor (strøer + krydsfiner inside the fundablok ring).
V3_FLOOR_LEDGER_W   = 95;     // ledger bjælke wide along Y/X (face of ring)
V3_FLOOR_LEDGER_H   = 45;     // ledger bjælke height (Z)
V3_FLOOR_LEDGER_Z   = -45;    // top of ledger (= bottom of strøer)
V3_FLOOR_JOIST_W    = 45;
V3_FLOOR_JOIST_H    = 95;
V3_FLOOR_JOIST_C2C  = 600;
V3_FLOOR_DECK_T     = 18;     // krydsfiner thickness
V3_FLOOR_DECK_Z     = V3_FLOOR_LEDGER_Z + V3_FLOOR_JOIST_H;  // top of krydsfiner = +50
