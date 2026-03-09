# Timber Framing Guidelines — Rabbit House

## Wood Species

- **Trykimprægneret fyr (pressure-treated pine)** for all structural timber in contact with or near the ground: bundrem, stolper, base frame
- **Gran (spruce)** acceptable for upper framing (toprem, losholter, spær) if kept dry under roof
- **NTR class AB** minimum for outdoor use (green-treated)
- All timber should be **construction graded C18 or C24** (ST or T1 marking in Denmark)

## Standard Dimensions (Danish market)

| Element | Dimension | Notes |
|---|---|---|
| Reglar / studs | 45×95 mm | Standard wall stud, sufficient for non-insulated outbuilding |
| Stolper / corner posts | 95×95 mm or 120×120 mm | Use 120×120 at corners carrying roof load |
| Bundrem / bottom plate | 45×95 mm | Flat (lying on wide face), bolted to foundation |
| Toprem / top plate | 45×95 mm | Can double up (2×45×95) on long spans >4m |
| Front beam (remme) | 45×180 mm | Main front beam carrying roof, sized for span |
| Losholte / nogging | 45×95 mm | Horizontal bracing between studs |
| Spær / rafters | 45×120 mm | Only if separate rafter system; mono-pitch can use toprem as bearer |

## Stud Spacing — Rules of Thumb for Small Outbuildings

This is **not** a dwelling. BR18 dimensional requirements for dwellings do not apply. For a small outbuilding (<50 m²):

### Where studs ARE needed
- **Every corner** of the building
- **Both sides of every opening** (doors, pass-throughs, windows)
- **At wall junctions** (where divider wall meets outer wall)
- **One mid-stud** on any wall span longer than ~2000 mm (stiffness, not code)

### Where studs are NOT needed
- **Mesh walls**: The mesh panel + frame provides lateral bracing. Corner posts and plates are sufficient.
- **Cladded walls with short spans** (<2m between supports): The cladding itself provides racking resistance.
- **Above openings**: A header beam (overligger) carries the load; no stud needed in the opening.

### Cladding support
- Klink cladding (22 mm boards) needs support at max **600 mm c/c** — but this can be horizontal battens (lægter) nailed to a few studs, not studs themselves
- For this project: studs at corners + openings + one mid-stud, then horizontal battens at 600 mm for cladding attachment

## Opening Framing

```
        ┌──── toprem ────────────────┐
        │                            │
   stud │    ┌── header ──┐         │ stud
        │    │             │         │
        │  jamb           jamb       │
        │  stud           stud       │
        │    │   opening   │         │
        │    │             │         │
        └──── bundrem ───────────────┘
```

- **Jamb studs**: Full height 45×95 on each side of opening
- **Header (overligger)**: 45×95 flat above opening, carries load from above
- **Sill (under windows)**: 45×95 flat, not structural

## Fastening

| Connection | Fastener |
|---|---|
| Bundrem to foundation | M10 anchor bolts or concrete screws, 600–1000 mm c/c |
| Stud to bundrem/toprem | Skrånagning (toe-nailing) 2× 3.1×90 mm galv. nails each side, or angle brackets |
| Toprem to stolper | 2× 5.0×100 mm screws + angle bracket |
| Cladding to studs/battens | 2.5×50 mm galv. ring-shank nails, 2 per board per support |
| Mesh to frame | 25 mm galv. staples or U-clips, 150 mm c/c |

## Roof Load Path

```
  Roof → Toprem (front beam 45×180) → Corner posts (120×120)
                                     → Divider post (120×120)
       → Toprem (back, 45×95)       → Corner posts / mid stud
```

- Mono-pitch (ensidet taghældning): front is high side, back is low side
- Roof drop over 4m width: ~220 mm (≈3° slope, minimum for tagpap/roofing felt)
- All top beams slope from front to back — use `hull()` in OpenSCAD to model this

## This Project's Framing Summary

| Wall | Posts/Studs | Plates | Notes |
|---|---|---|---|
| **Back** | 2 corner + 1 mid | Bundrem + toprem (flat) | Cladded, no openings |
| **Front** | 3 posts (corners + divider) + 1 mid | Bundrem + beam (45×180) | Mesh attached to outside |
| **Left (rabbit)** | 2 corner + 1 mid (if >3m) | Bundrem + sloped toprem | Mesh wall, minimal framing |
| **Right (seating)** | 2 corner + 1 mid + window jambs | Bundrem + sloped toprem | Full cladding + window openings |
| **Divider** | 2 jamb studs at pass-through | Header above opening | Mesh + framed pass-through |

## General Notes

- All dimensions in millimeters
- Timber from standard Danish builders' merchants (Bauhaus, Stark, XL-BYG) comes in these sizes
- Pressure-treated timber must be dried before painting/staining — wait 2–3 months or use wet-on-wet primer
- Leave 5–10 mm air gap between bundrem and any concrete/slab for drainage
- Stainless steel or hot-dip galvanised fasteners only — electro-galv will corrode with treated timber
