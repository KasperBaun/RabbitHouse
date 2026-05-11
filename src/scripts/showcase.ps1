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
# ses i frame med margin. Detalje-shots har egne $vp* og bruger close-up
# afstande.
$vpr_iso  = "[55,0,35]"     # 3/4 fra front-højre
$vpr_back = "[55,0,215]"    # 3/4 fra bag-venstre (modsat)
$vpr_left = "[55,0,-35]"    # 3/4 fra front-venstre
$vpd_iso  = "16000"
$vpt_iso  = "[3000,1250,1500]"

$renders = @(
    # --- Hero shots (bird's-eye 3/4) ---
    @{ name="01_hero_tagpap";              clad="true";  cover="tagpap_osb"; vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="02_hero_eternit";             clad="true";  cover="eternit_b7"; vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="03_hero_uden_klink";          clad="false"; cover="tagpap_osb"; vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="04_hero_kun_spaer";           clad="false"; cover="tagpap_osb"; cover_off="true";
                                                                             vpr=$vpr_iso;  vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="05_hero_bag_vinkel";          clad="true";  cover="tagpap_osb"; vpr=$vpr_back; vpd=$vpd_iso; vpt=$vpt_iso },
    @{ name="06_hero_front_venstre";       clad="true";  cover="tagpap_osb"; vpr=$vpr_left; vpd=$vpd_iso; vpt=$vpt_iso },
    # --- Elevations & lave vinkler (variation fra bird's-eye) ---
    @{ name="07_elevation_front";          clad="true";  cover="tagpap_osb"; vpr="[90,0,0]";   vpd="10000"; vpt="[3000,1250,1400]" },
    @{ name="08_elevation_side_V4";        clad="true";  cover="tagpap_osb"; vpr="[90,0,90]";  vpd="12000"; vpt="[3000,1250,1400]" },
    @{ name="09_low_iso";                  clad="true";  cover="tagpap_osb"; vpr="[95,0,35]";  vpd="13000"; vpt="[3000,1250,1500]" },
    @{ name="10_low_front";                clad="true";  cover="tagpap_osb"; vpr="[98,0,20]";  vpd="10000"; vpt="[3000,1250,1500]" },
    # --- Detalje-shots (close-ups) ---
    @{ name="11_detail_sternkapsel_front"; clad="true";  cover="tagpap_osb"; vpr="[55,0,35]";  vpd="3000";  vpt="[300,-50,2400]" },
    @{ name="12_detail_tagrende_bag";      clad="true";  cover="tagpap_osb"; vpr="[55,0,215]"; vpd="3000";  vpt="[3000,2600,2300]" },
    @{ name="13_detail_spaer_brackets";    clad="false"; cover="tagpap_osb"; vpr="[55,0,30]";  vpd="3500";  vpt="[600,200,2600]" }
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
        "-D", "show_cladding=$($r.clad)",
        "-D", "roof_cover=`"$($r.cover)`"",
        "-D", "`$vpr=$($r.vpr)",
        "-D", "`$vpd=$($r.vpd)",
        "-D", "`$vpt=$($r.vpt)"
    )
    if ($r.cover_off) {
        $args += "-D"
        $args += "show_cover=false"
    }
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
