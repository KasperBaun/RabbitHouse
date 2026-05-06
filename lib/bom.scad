// Bill-of-materials accumulator.
//
// Run with $bom_mode=true to emit one CSV line per timber/concrete piece
// via echo(). Each line:
//   BOM,<category>,<species>,<w_mm>,<h_mm>,<length_mm>,<count>,<name>
//
// Categories: stud, bundrem, toprem, jamb, header, cripple, sill, beam,
//             post, plug, rafter, dpc, edge_beam, slab, bracket, stile,
//             collar_tie, mesh_frame, mesh
// Species:    pt-pine, spruce, limtree, concrete, bitumen, steel-galv,
//             mesh-galv
//
// Extract & aggregate (PowerShell):
//
//   $exe = "C:\Program Files\OpenSCAD\openscad.exe"
//   & $exe -o _renders/bom.png -D 'design="v3"' -D '$bom_mode=true' main.scad 2>&1 |
//     Select-String '"BOM,' |
//     ForEach-Object { ($_.Line -replace 'ECHO: "', '' -replace '"$', '') } |
//     Out-File -Encoding utf8 _renders/v3_bom.csv
//
//   $bom = Import-Csv _renders/v3_bom.csv | Where-Object category -ne 'category'
//   $bom | Group-Object category,species,width_mm,height_mm,length_mm |
//     ForEach-Object {
//       [PSCustomObject]@{
//         Category = $_.Group[0].category; Species = $_.Group[0].species
//         Section = "$($_.Group[0].width_mm)x$($_.Group[0].height_mm)"
//         Length_mm = $_.Group[0].length_mm; Count = $_.Count }} |
//     Sort-Object Category, Species, Section, Length_mm | Format-Table -AutoSize
//
// Bash equivalent:
//   openscad -o /dev/null -D 'design="v3"' -D '$bom_mode=true' main.scad 2>&1 |
//     grep '^ECHO: "BOM' | sed 's/^ECHO: "//; s/"$//' > v3_bom.csv
//   awk -F, 'NR>1 { key=$1","$2","$3","$4","$5; cnt[key]++ }
//            END { for (k in cnt) print k","cnt[k] }' v3_bom.csv | sort

module bom_header() {
    if ($bom_mode == true)
        echo("BOM,category,species,width_mm,height_mm,length_mm,count,name");
}

module bom_member(category, species, w, h, length, name="", count=1) {
    if ($bom_mode == true)
        echo(str("BOM,", category, ",", species, ",",
                 w, ",", h, ",", length, ",", count, ",", name));
}
