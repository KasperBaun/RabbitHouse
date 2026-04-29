# Rabbit House — Requirements

One-line, ID-traceable requirements for the rabbit-house build modelled in this repo.
Each `REQ-NNN` is atomic so it can be cited from the PRD, code comments, or build notes.
Where a number is grounded in an external welfare standard, the source is cited inline.

Conventions:
- IDs are stable; never renumber. Add new ones at the end of their section.
- "Rabbit zone" = the meshed enclosure on the left/front (`rabbit_x0`..`rabbit_x1`).
- "Sleeping zone" = the insulated nest box / shelter inside the rabbit zone.

## A. Animal welfare & space

- **REQ-001** — The rabbit zone must give the rabbits continuous 24/7 access to a connected enclosure of at least 3.0 m × 2.0 m × 1.0 m. (src: RWAF minimum)
- **REQ-002** — The rabbit zone must allow each rabbit to take three full hops in a straight line and to stand fully upright on its hind legs without head contact. (src: RWAF)
- **REQ-003** — The structure must house at least one bonded pair; rabbits must never be kept singly in this build.
- **REQ-004** — The rabbit zone must provide separated functional areas for sleeping, eating, drinking, and toileting.
- **REQ-005** — At least one hiding shelter must be available per rabbit, plus one spare (the "n+1" rule), permanently accessible.
- **REQ-006** — The rabbit zone must include at least one elevated platform or lookout the rabbits can jump onto, for vertical enrichment.
- **REQ-007** — A safe digging substrate (sand pit or soil tray) must be available so the rabbits can dig without compromising the perimeter.

## B. Predator protection

- **REQ-008** — All boundaries between the rabbit zone and the outside world must be covered with welded wire mesh of aperture ≤ 25 mm × 13 mm and gauge ≥ 19 (≈ 1.0 mm wire). (src: The Rabbit House, RWAF)
- **REQ-009** — The rabbit-zone perimeter must defeat burrowing predators, either by a buried wire skirt ≥ 300 mm deep or a horizontal apron ≥ 500 mm wide pinned at ground level.
- **REQ-010** — Every gate, hatch, and door into the rabbit zone must use a two-stage lockable latch that resists raccoon, fox, and child opening.
- **REQ-011** — The sluice must operate as an airlock: the inner door and outer door must never be open simultaneously.
- **REQ-012** — The roof above the rabbit zone must fully enclose against aerial predators (hawks, owls) and climbing predators (cats, martens, rats).
- **REQ-013** — No mesh aperture, edge gap, or trim seam in the rabbit zone may exceed 12 mm at any point.
- **REQ-014** — Mesh must be fastened with screwed staples or wire, not stapled with a tacker, on faces a fox can pull at.

## C. Weather & climate (Nordic / temperate-maritime)

- **REQ-015** — The structure must shelter the rabbits from wind, driving rain, direct sun, and snow at all hours of the year.
- **REQ-016** — The sleeping zone must remain dry and draught-free during sustained west-/south-westerly wind and rain.
- **REQ-017** — The roof and overhangs must shed water away from every wall and away from the sleeping zone.
- **REQ-018** — The roof must support a snow load of at least 1.0 kN/m² without deflection, consistent with Nordic minimums.
- **REQ-019** — At least one shaded sub-zone with internal air temperature ≤ 25 °C must exist in the rabbit area at all summer hours; rabbits suffer heat stress above 25 °C.
- **REQ-020** — The build must include an insulated, draught-free nest box usable down to −10 °C ambient.
- **REQ-021** — The foundation must lift the floor ≥ 100 mm above finished grade to keep the floor dry in heavy rain. (existing: `base_height = 120 mm` — meets this.)

## D. Ventilation & air quality

- **REQ-022** — The rabbit zone must support continuous cross-ventilation without exposing the sleeping zone to direct draught. (src: RSPCA)
- **REQ-023** — High and low ventilation openings must exist on opposite walls so warm, ammonia-laden air can rise out and fresh air can replace it.
- **REQ-024** — No part of the rabbit zone may depend on a single closable opening as its only air exchange.

## E. Floor, drainage & substrate

- **REQ-025** — Surface water inside the rabbit zone must drain so no puddle persists more than 30 minutes after heavy rain.
- **REQ-026** — The site must slope (or be regraded to slope) away from the structure at ≥ 1:50 on all sides.
- **REQ-027** — The rabbit floor must be dig-proof: a solid slab, a buried mesh layer, or a wire base under any loose substrate.
- **REQ-028** — Every substrate in rabbit contact must be non-toxic, low-dust, and chew-safe.

## F. Materials & toxicity

- **REQ-029** — No pressure-treated, CCA-treated, or creosoted wood may be used anywhere a rabbit can chew, lick, or rub against it.
- **REQ-030** — All paints, stains, and sealants in the rabbit zone must be fully cured, food-safe, and free of lead, solvent VOCs, and zinc-rich primers in chew range.
- **REQ-031** — All mesh in the rabbit zone must be galvanised-after-welding (GAW) or vinyl-coated, with cut edges deburred or capped to remove zinc flakes and burrs.
- **REQ-032** — Any insulation reachable by rabbits must sit behind a chew-proof inner skin.
- **REQ-033** — No plant from the rabbit-toxic list (yew, oleander, foxglove, lily, ivy, rhododendron, laburnum) may grow within the rabbit zone or overhang it.

## G. Maintenance & human access

- **REQ-034** — A human must be able to walk fully upright into the rabbit zone through a door ≥ 800 mm wide and ≥ 1900 mm high. (existing sluice: 800 × 2100 mm — meets this.)
- **REQ-035** — Every surface inside the rabbit zone must tolerate hosing and standard pet-safe disinfectant for daily cleaning.
- **REQ-036** — Daily droppings clean-up and food/water refill must be achievable by one adult in ≤ 15 minutes.
- **REQ-037** — A removable or hinged-access tray, panel, or floor section must exist beneath any zone where droppings concentrate.
- **REQ-038** — All lighting fixtures and electrical cabling inside the rabbit zone must be either out of rabbit reach or shielded behind chew-proof conduit.

## H. Reserved (former human seating area)

The original Section H covered a human seating area included in the v1
design. That scope was removed in the v2 redesign. IDs `REQ-039` through
`REQ-042` remain reserved and will not be reused.

## I. Safety

- **REQ-043** — No element reachable by rabbits or humans may have a sharp edge, exposed nail, splinter, or pinch point.
- **REQ-044** — All hinges, latches, and fasteners exposed to weather must be rated for outdoor use and remain free-moving for at least 5 years.
- **REQ-045** — No swallowable loose parts (screws, staples, wire offcuts) may be left in the rabbit zone after construction.

## J. Site, regulation & longevity

- **REQ-046** — Footprint and height must comply with the local jurisdiction's rules for unattached outbuildings before construction begins (in DK, sheds > 10 m² generally need a permit).
- **REQ-047** — The structure must respect the locally required setback distance from neighbouring property lines.
- **REQ-048** — The build must remain serviceable for ≥ 10 years with annual maintenance; every wear part (mesh, latches, lighting) must be replaceable without dismantling structural framing.

## References

- RWAF — Space Recommendations: https://rabbitwelfare.co.uk/space-recommendations/
- RWAF — Outdoor Housing: https://rabbitwelfare.co.uk/outdoor-housing/
- RSPCA — Rabbits' Housing Needs (2018): https://www.rspca.org.uk/documents/1494939/7712578/RSPCA+Rabbit+housing+advice+-+updated+May+2018+(on+website).pdf
- The Rabbit House — Wire Mesh Guide: https://www.therabbithouse.com/outdoor/rabbit-mesh.asp
- RSPCA Australia — Where should I keep my rabbits?: https://kb.rspca.org.au/knowledge-base/where-should-i-keep-my-rabbits/
