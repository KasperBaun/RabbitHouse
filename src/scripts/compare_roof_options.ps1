# Render each roof_cover option and save comparison images.
$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/roof_compare"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$covers = "tagpap","stål","eternit_10","eternit_14"

foreach ($c in $covers) {
    $output = & openscad -o "$out/$c.png" --imgsize=1200,800 --colorscheme=Tomorrow `
        --camera=3000,1250,1300,55,0,25,16000 `
        -D show_cladding=false -D show_ground=true `
        -D "roof_cover=`"$c`"" main.scad 2>&1
    $errs = $output | Select-String 'ERROR|Assertion' | Where-Object { $_ -notmatch 'viewport' }
    if ($errs) {
        Write-Host "WARNING: roof_cover='$c' produced errors:" -ForegroundColor Yellow
        $errs | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    }
}

Write-Host "Done. Renders in $out/"
