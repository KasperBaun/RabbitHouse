# Render high-resolution showcase images into _renders/showcase/
# Til at vise venner / dokumentere projektet.
#
# Standard: 1920×1080 (16:9 hero-format) med generøs margin omkring bygningen.
#
# Usage: pwsh -File src/scripts/showcase.ps1
#        pwsh -File src/scripts/showcase.ps1 -Width 2560 -Height 1440   # 2K
#        pwsh -File src/scripts/showcase.ps1 -Only "01","07"            # kun valgte
#        pwsh -File src/scripts/showcase.ps1 -Width 960 -Height 540     # quick preview

param(
    [int]$Width = 1920,
    [int]$Height = 1080,
    [string[]]$Only = @()
)

$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/showcase"
New-Item -ItemType Directory -Force -Path $out | Out-Null

# Hero-vinkel: slight birds-eye 3/4 view med $vpd=16000 så hele bygningen
# ses i frame med margin.
$vpr_iso  = "[55,0,35]"     # 3/4 fra front-højre
$vpr_back = "[55,0,215]"    # 3/4 fra bag-venstre (modsat)
$vpr_left = "[55,0,-35]"    # 3/4 fra front-venstre
$vpd_iso  = "16000"
$vpt_iso  = "[3000,1500,1500]"

$renders = @(
    # --- Hero shots — one per house-cover variant ---
    @{ name="01_hero_skifer";    cover="skifer";  vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="02_hero_tagpap";    cover="tagpap";  vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="03_hero_eternit";   cover="eternit"; vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="04_back_vinkel";    cover="skifer";  vpr=$vpr_back; vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="05_front_venstre";  cover="skifer";  vpr=$vpr_left; vpd=$vpd_iso; vpt=$vpt_iso },
    # --- Elevations ---
    @{ name="06_elevation_front";  cover="skifer"; vpr="[90,0,0]";  vpd="10000"; vpt="[3000,1500,1400]" },
    @{ name="07_elevation_side";   cover="skifer"; vpr="[90,0,90]"; vpd="12000"; vpt="[3000,1500,1400]" }
)

Write-Host "Render showcase ($($renders.Count) billeder, $($Width)x$($Height))..."

foreach ($r in $renders) {
    if ($Only.Count -gt 0) {
        $hit = $false
        foreach ($filter in $Only) {
            if ($r.name -like "$filter*") { $hit = $true; break }
        }
        if (-not $hit) { continue }
    }

    $args = @(
        "--imgsize=$Width,$Height",
        "-D", "house_roof_cover=`"$($r.cover)`"",
        "-D", "`$vpr=$($r.vpr)",
        "-D", "`$vpd=$($r.vpd)",
        "-D", "`$vpt=$($r.vpt)"
    )
    $args += "-o"
    $args += "$out/$($r.name).png"
    $args += "src/main.scad"

    & openscad $args 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK  $($r.name).png"
    } else {
        Write-Host "  FAIL $($r.name).png" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done. Billeder i $out/"
