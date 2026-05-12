# Render all per-system audit views into _renders/audit/
# Usage: pwsh scripts/audit_renders.ps1

$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/audit"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$renders = @(
    @{name="01_fundament";              clad="false"; gnd="false"; cam="3000,1250,400,75,0,25,12000"},
    @{name="02_vaegge_frame";           clad="false"; gnd="true";  cam="3000,1250,1300,55,0,25,16000"},
    @{name="03_vaegge_isolering";       clad="false"; gnd="false"; cam="3000,1250,1300,55,0,25,16000"},
    @{name="04_tagkonstruktion_pap";    cover="tagpap";     clad="false"; gnd="true";  cam="3000,1250,1500,235,0,25,16000"},
    @{name="05_tagkonstruktion_staal";  cover="stål";       clad="false"; gnd="true";  cam="3000,1250,1500,235,0,25,16000"},
    @{name="06_tagkonstruktion_eternit10"; cover="eternit_10"; clad="false"; gnd="true";  cam="3000,1250,1500,235,0,25,16000"},
    @{name="07_beklaedning";            clad="true";  gnd="true";  cam="3000,1250,1300,55,0,25,16000"},
    @{name="08_aabninger";              clad="true";  gnd="true";  cam="3000,1250,1300,55,0,160,8000"},
    @{name="09_inventar";               clad="true";  gnd="true";  cam="800,1250,1000,75,0,90,4000"},
    @{name="10_fuld_iso";               clad="true";  gnd="true";  cam="3000,1250,1300,55,0,25,16000"}
)

foreach ($r in $renders) {
    $args = @(
        "-o", "$out/$($r.name).png",
        "--imgsize=1600,1100",
        "--colorscheme=Tomorrow",
        "--camera=$($r.cam)",
        "-D", "show_cladding=$($r.clad)",
        "-D", "show_ground=$($r.gnd)"
    )
    if ($r.cover) { $args += "-D"; $args += "roof_cover=`"$($r.cover)`"" }
    $args += "main.scad"
    & openscad $args 2>&1 | Out-Null
    Write-Host "  $($r.name)"
}

Write-Host "Done. 10 audit renders in $out/"
