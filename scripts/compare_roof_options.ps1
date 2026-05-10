# Render & BOM-extract for each roof_cover; print a comparison table.
$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/v3/roof_compare"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$covers = "tagpap","stål","eternit_10","eternit_14"

foreach ($c in $covers) {
    & openscad -o "$out/$c.png" --imgsize=1200,800 --colorscheme=Tomorrow `
        --camera=3000,1250,1300,55,0,25,16000 `
        -D 'design="v3"' -D show_cladding=false -D show_ground=true `
        -D "roof_cover=`"$c`"" main.scad 2>&1 | Out-Null

    & openscad -o "$out/$c.bom.png" -D 'design="v3"' -D '$bom_mode=true' `
        -D "roof_cover=`"$c`"" main.scad 2>&1 |
        Select-String '"BOM,' |
        ForEach-Object { ($_.Line -replace 'ECHO: "', '' -replace '"$', '') } |
        Out-File -Encoding utf8 "$out/$c.csv"
}

Write-Host "`nRoof cover comparison"
Write-Host ("=" * 60)
foreach ($c in $covers) {
    $bom = Import-Csv "$out/$c.csv" | Where-Object system -eq 'tagkonstruktion'
    Write-Host ("{0,-15} {1,3} BOM rows" -f $c, $bom.Count)
}
