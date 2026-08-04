$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$reviewPath = Join-Path $root 'hardware/kicad/notes/ECO-011_Composite_Physical_Device_Decomposition.md'
$review = Get-Content -Raw $reviewPath
$population = Import-Csv (Join-Path $root 'docs/bom/IPC100_RevA_Prototype_Population.csv')

if ([regex]::Matches($review, '(?m)^# ECO-011 INCOMPLETE\r?$').Count -ne 1) { throw 'ECO-011 requires exactly one INCOMPLETE decision.' }
if ([regex]::IsMatch($review, '(?m)^# ECO-011 COMPLETE')) { throw 'Conflicting ECO-011 COMPLETE decision.' }

$required = @('U401AB','U401CD','U402AB','U402CD','U403AB','U403C','U403D','U501','U502','U503','U601','U602','U603','U701','U703','U704','U705')
foreach ($reference in $required) {
    if ($review -notmatch [regex]::Escape($reference)) { throw "Composite inventory omits $reference." }
}

if ($population.Count -ne 408) { throw 'Population register must contain 408 rows after Sheet 04 replacements.' }
$blocked = $population | Where-Object 'Prototype Population Status' -eq 'BLOCKED - PHYSICAL DEFINITION REQUIRED'
if ($blocked.Count -ne 343) { throw 'Post-ECO-011A1R population must contain 343 physically blocked rows.' }

$footprints = Get-ChildItem (Join-Path $root 'hardware/kicad') -Recurse -Filter '*.kicad_sch' | Select-String -Pattern '\(footprint\s+"[^"]+'
if ($footprints) { throw 'Footprints were assigned.' }
$pcb = Get-ChildItem $root -Recurse -Filter '*.kicad_pcb'
if ($pcb) { throw 'PCB files are prohibited.' }

Write-Output 'ECO-011 validation passed: Sheet 04 decomposition recorded; remaining composite inventory controlled; 408 population rows; zero footprints and PCB files.'
