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
// corrected origin Z and total drop (see RH_ROOF_*) so the wall tops align
// with the roof underside at the wall faces, not just at the overhang tips.

RH_LENGTH       = 6000;
RH_WIDTH        = 2500;
RH_BASE_H       = 120;
RH_WALL_T       = 100;
RH_HOUSE_LEN    = 1500;
RH_RUN_LEN      = 4500;

// Wall heights, measured from sokkel-top (Z=RH_BASE_H) to roof underside
// at the wall face. EH_FRONT > EH_BACK gives a mono-pitch slope front→back.
// Drop 200 over 2500 = 4,6° (8 % fald). Tagpap kræver minimum 2,5 cm/m
// = 2,5 % = 1,4° — vores 8 % er rigeligt. Stål og eternit kræver mere
// hældning og virker IKKE med disse højder.
//
// Højder valgt så STANDARD-DØRE passer:
//   V1 (front, EH_FRONT=2400) rummer 95×205 udhusdør (rough opening 1070×2120)
//   V5 (partition, EH_BACK=2200) rummer 80×200 indvendig dør (870×2050)
RH_EH_FRONT     = 2400;
RH_EH_BACK      = 2200;

// Roof overhangs
RH_OH_FRONT     = 220;
RH_OH_BACK      = 180;
RH_OH_SIDE      = 220;
RH_ROOF_THICK   = 80;

// Human door in the partition (X=RH_HOUSE_LEN, faces +X into the yard).
// Rough opening for STANDARD 80×200 cm indvendig dør (= blade 800×2000 +
// karm 50mm hver side + 15mm tolerance på top).
RH_HOUSE_DOOR_W = 870;
RH_HOUSE_DOOR_H = 2050;
RH_HOUSE_DOOR_Y = 200;       // along Y on the partition

// Rabbit pet door (partition at X=RH_HOUSE_LEN, faces +X into yard).
RH_PET_DOOR_W   = 250;
RH_PET_DOOR_H   = 300;
RH_PET_DOOR_Y   = 1500;

// Yard udhusdør (front face Y=0, opens outward to garden).
// Rough opening for STANDARD 95×205 cm udhusdør (= blade 948×2050 +
// karm 60mm hver side + 15mm tolerance på top).
RH_YARD_DOOR_W  = 1070;
RH_YARD_DOOR_H  = 2120;
RH_YARD_DOOR_X  = 3000;      // X along front (left edge of the door)

// Insulated nest box (against back wall, in main house space). With house
// shortened to 1500 mm, X anchor moved from 1100 → 200 so the 800-wide box
// (X=200..1000) fits comfortably inside the partition wall at X=1500.
RH_NEST_X       = 200;
RH_NEST_Y       = 1500;
RH_NEST_W       = 800;
RH_NEST_D       = 900;
RH_NEST_H       = 600;

// Side window on left exterior wall (X=0, faces -X).
// Centreret horizontalt (RH_SIDE_WIN_Y=900 → opening Y=900..1600 i wall Y=95..2405).
// RH_SIDE_WIN_Z=1100 sætter vinduet ved adult-øjenhøjde (vinduebund ~1,1m over gulv).
RH_SIDE_WIN_W   = 700;
RH_SIDE_WIN_H   = 600;
RH_SIDE_WIN_Y   = 900;
RH_SIDE_WIN_Z   = 1100;

// Standard Danish timber sizes used by the yard structure.
//   95×180 limtræ      — yard top beams, sloping under roof (RH_BEAM_H)
//   45×195 reglar      — interior collar tie (RH_COLLAR_TIE_H)
//   70×70 KOMPAKT      — mesh-wall stiles (RH_STILE_W)
//   45×95 reglar       — right-end corner reglar (cross-section 45×95,
//                        outer face flush at X=ll); replaced 95×95 stolper
//                        once the fundablok ring carried the load line
//   45×95 reglar flat  — yard sill plate, 95 wide × 45 tall (RH_SILL_H)
// RH_POST_W is the SHARED 95 mm "wide" dimension used by sills, beams,
// and the corner reglar's wide axis — kept as a single constant so wall
// envelope dimensions stay consistent.
RH_POST_W       = 95;
RH_BEAM_H       = 180;
RH_COLLAR_TIE_W = 45;        // 45×195 reglar laid on edge
RH_COLLAR_TIE_H = 195;
RH_SILL_H       = 45;

// Mesh spec for the yard — fine welded wire (predator-proof per REQ-008).
//   13 mm aperture × 1 mm wire (≈ gauge 19 GAW)
RH_MESH_SPACING = 13;
RH_MESH_BAR     = 1;
RH_MESH_FRAME   = 40;
RH_MESH_DEPTH   = 20;

// Vertical wood stiles every ~1 m along yard mesh walls.
RH_STILE_W      = 70;
RH_STILE_SPACING = 1000;

// Horizontal mid-rail across yard mesh panels — divides each panel into
// stacked ~1 m × 1 m mesh sections for a fence-panel look. The yard door's
// internal mid-rail uses the same Z so the rail line is continuous across
// the whole front wall.
RH_MID_RAIL_Z_OFFSET = 1000;       // above sill top
RH_MID_RAIL_H        = 40;         // matches mesh frame thickness

// Spær (rafter) constants. Shared globally so config can shift the roof
// z-frame up by SPAER_H and place the cover correctly above.
RH_SPAER_W   = 45;
RH_SPAER_H   = 95;
RH_SPAER_C2C = 600;

// Sternbræt-tykkelse (25×125 imprægneret gran). Bruges af alle tag-varianter
// (tagpap-, eternit-) til at placere stern + sternkapsel/vindskede UDVENDIGT
// på spær-endefladerne. Lever i config så både tagkonstruktion_faelles.scad,
// tagkonstruktion_tagpap.scad og tagkonstruktion_eternit.scad ser samme værdi.
RH_STERN_T   = 25;

// Roof geometry helpers. rh_roof_oz / rh_roof_oz_for now return the z of
// the SPÆR TOP (= cover bottom) at the front-eave corner — i.e., they sit
// SPAER_H above the wall-plate top. This means:
//   • spær bottom @ y = wall-plate top         (spær sits on toprem)
//   • spær top    @ y = rh_roof_under_for(y)   (cover sits on spær top)
// Wall-plate top heights are still RH_BASE_H + RH_EH_FRONT (front, HØJ)
// and RH_BASE_H + RH_EH_BACK (back, LOW) — set in konstruktions-skelet.
function rh_span_total() = RH_OH_FRONT + RH_WIDTH + RH_OH_BACK;
function rh_total_drop() =
    (RH_EH_FRONT - RH_EH_BACK) * rh_span_total() / RH_WIDTH;
function rh_roof_oz() =
    RH_BASE_H + RH_EH_FRONT + RH_SPAER_H +
    RH_OH_FRONT * rh_total_drop() / rh_span_total();
// Roof underside z (= spær top z) at any Y. Y=0 is front wall face.
function rh_roof_under(y) =
    rh_roof_oz() - (RH_OH_FRONT + y) * rh_total_drop() / rh_span_total();

// Roof slope per cover type. Eternit B7 normally needs ≥10° (extended
// overlap) or ≥14° (standard). v3's 4,6° is OK for tagpap_osb but for
// eternit_b7 we'd need to lower eh_back further (which also requires
// konstruktions-skelet to re-fit the doors — see todo "Senere").
function rh_eh_back_for(cover) =
      cover == "eternit_10" ? 2160
    : cover == "eternit_14" ? 1976
    : RH_EH_BACK;

// Cover-aware versions. Same SPAER_H lift as the default helpers above.
function rh_total_drop_for(eh_back) =
    (RH_EH_FRONT - eh_back) * rh_span_total() / RH_WIDTH;
function rh_roof_oz_for(eh_back) =
    RH_BASE_H + RH_EH_FRONT + RH_SPAER_H +
    RH_OH_FRONT * rh_total_drop_for(eh_back) / rh_span_total();
function rh_roof_under_for(eh_back, y) =
    rh_roof_oz_for(eh_back) - (RH_OH_FRONT + y) * rh_total_drop_for(eh_back) / rh_span_total();

// DPC tape (murpap) tykkelse mellem sokkel-ring og bundrem. Bundrem bærer
// alt træ-skelettet og sidder PÅ TOP af DPC-båndet, ikke direkte på sokkel
// — derfor lægger gulv-niveau 2 mm højere end ring-toppen.
RH_DPC_T = 2;

// Floor finish (krydsfiner top) — flush med bundrem-toppen så døre lander
// ved gulv-niveau. Bundrem sidder ovenpå DPC-båndet på sokkel-ringen, så
// floor_top = ring_top + DPC + bundrem-tykkelse.
RH_FLOOR_TOP = RH_BASE_H + RH_DPC_T + RH_SILL_H;   // = 120 + 2 + 45 = 167

// Top of the yard sill plate — yard-bundremmen sidder også på DPC-båndet,
// så toppen er identisk med RH_FLOOR_TOP.
RH_YARD_SILL_TOP = RH_FLOOR_TOP;  // = 167

// Beklædning lag-stack tykkelser. Bruges af beklaedning.scad til at lægge
// hver lag udadgående fra stud-fladen. Klink-tykkelse kommer fra RH_CLAD
// (defineret i build.scad) via cs_thick(clad).
RH_VP_T         = 1;     // vindpapir (membran)
RH_AL_T         = 22;    // afstandsliste (22×45 lodret klemmeliste)

// House floor (strøer + krydsfiner inside the fundablok ring).
RH_FLOOR_LEDGER_W   = 95;
RH_FLOOR_LEDGER_H   = 45;
RH_FLOOR_DECK_T     = 18;
RH_FLOOR_JOIST_W    = 45;
RH_FLOOR_JOIST_H    = 95;
RH_FLOOR_JOIST_C2C  = 600;
// Top of krydsfiner = floor finish = bundrem top (RH_FLOOR_TOP=167).
RH_FLOOR_DECK_Z     = RH_FLOOR_TOP - RH_FLOOR_DECK_T;  // = 149 (top of strøer)
// Ledger top = bottom of strøer.
RH_FLOOR_LEDGER_Z   = RH_FLOOR_DECK_Z - RH_FLOOR_JOIST_H;  // = 54
