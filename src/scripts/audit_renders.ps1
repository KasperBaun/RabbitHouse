# Render all per-system audit views into _renders/audit/
# Usage: pwsh src/scripts/audit_renders.ps1

$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/audit"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$renders = @(
    @{name="01_fundament";              cover="skifer";  cam="3000,1500,400,75,0,25,12000"},
    @{name="02_framing";                cover="skifer";  cam="3000,1500,1300,55,0,25,16000"},
    @{name="03_tagkonstruktion_skifer"; cover="skifer";  cam="3000,1500,1500,235,0,25,16000"},
    @{name="04_tagkonstruktion_tagpap"; cover="tagpap";  cam="3000,1500,1500,235,0,25,16000"},
    @{name="05_tagkonstruktion_eternit";cover="eternit"; cam="3000,1500,1500,235,0,25,16000"},
    @{name="06_fuld_iso";               cover="skifer";  cam="3000,1500,1300,55,0,25,16000"}
)

foreach ($r in $renders) {
    $args = @(
        "-o", "$out/$($r.name).png",
        "--imgsize=1600,1100",
        "--colorscheme=Tomorrow",
        "--camera=$($r.cam)",
        "-D", "house_roof_cover=`"$($r.cover)`""
    )
    $args += "src/main.scad"
    & openscad $args 2>&1 | Out-Null
    Write-Host "  $($r.name)"
}

Write-Host "Done. $($renders.Count) audit renders in $out/"
