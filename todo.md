# Todo

1. ~~fundament.scad og fundament.md~~
2. konstruktions-skelet.scad og konstruktions-skelet.md (murpap, bundrem, reglar, toprem)
3. aabninger.scad og aabninger.md (døre og vinduer)
4. beklaedning.scad og beklaedning.md (vindpap, klemmelister, klink beklædning i huset, voliernet i løbegården)
5. tagkonstruktion.scad og tagkonstruktion.md

## Senere

- Slet `src/designs/v3/vaegge.scad` når #3 (aabninger) og #4 (beklaedning) er færdige —
  først der har vi trukket alt vi har brug for ud (framed_opening_y, mesh-paneler, bats, etc.).
  Indtil da ligger filen urørt på disk men kaldes ikke fra build.scad.
- Gavlfyld (trekant over sidemæg, mellem vandret toprem og skrå tag) — beslut hvor det hører:
  i konstruktions-skelet.scad, i tagkonstruktion.scad, eller i egen `gavl.scad`.
- Strøer-gulv (floor joists inde i huset) — egen fil eller del af konstruktions-skelet?
- "yard" → "løbegård" rename på tværs af kodebasen.



Vi har beregnet at der skal købes ca. én rulle 10 meter og én rulle af 25 meter voliernet i målene ½ tomme x 1 tomme med 1,2mm trådtykkelse.
Det koster hhv. 400 og 950 kr. så ca. 1350 kr. i alt for det net der skal bruges i løbegården.