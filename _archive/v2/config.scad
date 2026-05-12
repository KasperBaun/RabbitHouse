// House-yard v2 — constants.
//
// Layout (mm):
//   X 0..2000  = solid gabled house (rabbit shelter + airlock + nest)
//   X 2000..6000 = mesh-walled run with translucent polycarbonate roof
//   Y 0        = front (open garden face / human entry)
//   Y 3000     = back (prevailing-wind side, solid cladded)
//
// Heights:
//   eave_h   = 2200  (top of house side walls, top of partition gable line eaves)
//   ridge_h  = 2700  (gable peak, ridge runs along Y at X = 1000)
//   run_h_hi = 2400  (run polycarb roof front edge)
//   run_h_lo = 2150  (run polycarb roof back edge)

V2_LENGTH       = 6000;
V2_WIDTH        = 3000;
V2_BASE_H       = 120;
V2_WALL_T       = 100;
V2_HOUSE_LEN    = 2000;
V2_RUN_LEN      = 4000;
V2_EAVE_H       = 2200;
V2_RIDGE_H      = 2700;
// Polycarb roof tucks just under the gable eave (eave_h=2200) so the gable
// drip edge sits above the run roof flashing at the partition.
V2_RUN_H_HI     = 2080;
V2_RUN_H_LO     = 1830;

// Airlock vestibule (front-left corner of house)
V2_AIRLOCK_W    = 1000;
V2_AIRLOCK_D    = 1000;

// Human outer door (in airlock front face, at Y=0)
V2_DOOR_W       = 850;
V2_DOOR_H       = 2100;
V2_DOOR_X       = 75;        // X position inside airlock

// Inner airlock-to-house door (in interior wall at Y=1000)
V2_INNER_DOOR_W = 800;
V2_INNER_DOOR_H = 2000;
V2_INNER_DOOR_X = 100;

// Rabbit pet door (in partition at X=2000)
V2_PET_DOOR_W   = 250;
V2_PET_DOOR_H   = 300;
V2_PET_DOOR_Y   = 1500;      // bottom-near Y of the opening

// Insulated nest box (against back wall, in main house space)
V2_NEST_X       = 1100;      // measured in X within house
V2_NEST_Y       = 1900;
V2_NEST_W       = 800;
V2_NEST_D       = 900;
V2_NEST_H       = 600;

// House high gable louver vent (left gable end wall, exterior X=0).
// Sits in the gable triangle ABOVE eave_h=2200 and BELOW the gable line.
// At the louver's outer Y (centred ± W/2 from ww/2), gable line z is:
//   gable_top_z(Y) = eave_h + (ridge_h - eave_h) * (1 - |Y - ww/2|/(ww/2))
// With W=400, |Y-ww/2| = 200 → gable_top_z = 2200 + 500*(1 - 200/1500) = 2633.
// Louver top must stay below 2633.
V2_VENT_HIGH_W  = 400;
V2_VENT_HIGH_H  = 160;
V2_VENT_HIGH_Z_OFFSET = -240;   // vent_z = bh + (eh+rh)/2 + offset = 2330

// Gable-end window (X=0 face, in the gable triangle below the louver vent)
V2_GABLE_WIN_W  = 600;
V2_GABLE_WIN_H  = 500;
V2_GABLE_WIN_Y  = 1200;       // measured from house front
V2_GABLE_WIN_Z  = 1500;       // above slab

// Run roof purlins
V2_RUN_PURLIN_SP = 900;

// Apron skirt width around run perimeter
V2_APRON_W      = 500;
