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

// Wall heights, measured from sokkel-top (Z=V3_BASE_H) to roof underside
// at the wall face. EH_FRONT > EH_BACK gives a mono-pitch slope front→back.
// Drop 200 over 2500 = 4,6° (8 % fald). Tagpap kræver minimum 2,5 cm/m
// = 2,5 % = 1,4° — vores 8 % er rigeligt. Stål og eternit kræver mere
// hældning og virker IKKE med disse højder.
//
// Højder valgt så STANDARD-DØRE passer:
//   V1 (front, EH_FRONT=2400) rummer 95×205 udhusdør (rough opening 1070×2120)
//   V5 (partition, EH_BACK=2200) rummer 80×200 indvendig dør (870×2050)
V3_EH_FRONT     = 2400;
V3_EH_BACK      = 2200;

// Roof overhangs
V3_OH_FRONT     = 220;
V3_OH_BACK      = 180;
V3_OH_SIDE      = 220;
V3_ROOF_THICK   = 80;

// Human door in the partition (X=V3_HOUSE_LEN, faces +X into the yard).
// Rough opening for STANDARD 80×200 cm indvendig dør (= blade 800×2000 +
// karm 50mm hver side + 15mm tolerance på top).
V3_HOUSE_DOOR_W = 870;
V3_HOUSE_DOOR_H = 2050;
V3_HOUSE_DOOR_Y = 200;       // along Y on the partition

// Rabbit pet door (partition at X=V3_HOUSE_LEN, faces +X into yard).
V3_PET_DOOR_W   = 250;
V3_PET_DOOR_H   = 300;
V3_PET_DOOR_Y   = 1500;

// Yard udhusdør (front face Y=0, opens outward to garden).
// Rough opening for STANDARD 95×205 cm udhusdør (= blade 948×2050 +
// karm 60mm hver side + 15mm tolerance på top).
V3_YARD_DOOR_W  = 1070;
V3_YARD_DOOR_H  = 2120;
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
// Centreret horizontalt (V3_SIDE_WIN_Y=900 → opening Y=900..1600 i wall Y=95..2405).
// V3_SIDE_WIN_Z=1100 sætter vinduet ved adult-øjenhøjde (vinduebund ~1,1m over gulv).
V3_SIDE_WIN_W   = 700;
V3_SIDE_WIN_H   = 600;
V3_SIDE_WIN_Y   = 900;
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

// Roof slope per cover type. Eternit B6 needs steeper hældning than v3's
// configured 9° (drop 400 / width 2500). Eternit_10 lowers eh_back to
// 2160 (drop 440, ~10°); eternit_14 lowers it to 1976 (drop 624, 14°).
function v3_eh_back_for(cover) =
      cover == "eternit_10" ? 2160
    : cover == "eternit_14" ? 1976
    : V3_EH_BACK;

// Cover-aware versions of the roof geometry helpers (defined further up
// in this file). These accept eh_back as a parameter so the roof can be
// re-positioned when a steeper cover is selected.
function v3_total_drop_for(eh_back) =
    (V3_EH_FRONT - eh_back) * v3_span_total() / V3_WIDTH;
function v3_roof_oz_for(eh_back) =
    V3_BASE_H + V3_EH_FRONT + V3_OH_FRONT * v3_total_drop_for(eh_back) / v3_span_total();
function v3_roof_under_for(eh_back, y) =
    v3_roof_oz_for(eh_back) - (V3_OH_FRONT + y) * v3_total_drop_for(eh_back) / v3_span_total();

// Floor finish (krydsfiner top) — flush with bundrem top so doors land
// at floor level, not at slab top. Bundrem sits directly on ring (DPC
// implicit; no air gap), so floor top = ring top + bundrem height.
V3_FLOOR_TOP = V3_BASE_H + V3_SILL_H;   // = 120 + 45 = 165

// Top of the yard sill plate (sill sits directly on ring at Z=V3_BASE_H).
V3_YARD_SILL_TOP = V3_BASE_H + V3_SILL_H;  // = 165 (unchanged numeric, but consistent)

// Yard back wall: low solid-clad skirt at the bottom (driving-rain
// defence), mesh ventilation band above.
V3_BACK_SKIRT_H = 600;   // mm above sill_top

// House floor (strøer + krydsfiner inside the fundablok ring).
V3_FLOOR_LEDGER_W   = 95;
V3_FLOOR_LEDGER_H   = 45;
V3_FLOOR_DECK_T     = 18;
V3_FLOOR_JOIST_W    = 45;
V3_FLOOR_JOIST_H    = 95;
V3_FLOOR_JOIST_C2C  = 600;
// Top of krydsfiner = floor finish = bundrem top (V3_FLOOR_TOP=165).
V3_FLOOR_DECK_Z     = V3_FLOOR_TOP - V3_FLOOR_DECK_T;  // = 147 (top of strøer)
// Ledger top = bottom of strøer.
V3_FLOOR_LEDGER_Z   = V3_FLOOR_DECK_Z - V3_FLOOR_JOIST_H;  // = 52
