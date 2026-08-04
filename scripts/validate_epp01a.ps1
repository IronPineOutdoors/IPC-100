$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$ebom = Import-Csv (Join-Path $root 'docs/bom/IPC100_RevA_EBOM.csv')
$population = Import-Csv (Join-Path $root 'docs/bom/IPC100_RevA_Prototype_Population.csv')
$review = Get-Content -Raw (Join-Path $root 'docs/releases/EPP-01A_Engineering_Prototype_Population_Package_Mechanical_Freeze.md')

if ($ebom.Count -ne 408 -or $population.Count -ne 408) { throw 'Post-ECO-011A1R EPP-01A must disposition exactly 408 EBOM rows.' }
if (($population.Reference | Sort-Object -Unique).Count -ne 408) { throw 'Prototype population references are not unique.' }
$allowed = @(
    'POPULATE - REQUIRED','POPULATE - OPTIONAL','DNP - DEFAULT','DNP - DEBUG OPTION',
    'DOCUMENTATION ONLY','RETIRED','NOT APPLICABLE TO PROTOTYPE','BLOCKED - PHYSICAL DEFINITION REQUIRED'
)
if ($population.Where({ $_.'Prototype Population Status' -notin $allowed }).Count) { throw 'Invalid prototype population status.' }
$requiredColumns = @('Reference','Sheet','Function','Current EBOM Status','Prototype Population Status','Reason','Required For First Power-Up','Required For Functional Testing','Required For Safety Testing','Required For USB Programming','Required For Motion Testing','Required For Expansion Testing','Installation Phase')
foreach ($column in $requiredColumns) {
    if ($population[0].PSObject.Properties.Name -notcontains $column) { throw "Missing population column: $column" }
    if ($population.Where({ [string]::IsNullOrWhiteSpace($_.$column) }).Count) { throw "Blank population field: $column" }
}
$retiredSafety = @('U401AB','U401CD','U402AB','U402CD','U403AB','U403C','U403D')
foreach ($reference in $retiredSafety) {
    if ($population.Reference -contains $reference) { throw "$reference must be retired after ECO-011A1R." }
    if ($review -notmatch [regex]::Escape($reference)) { throw "$reference historical trace is absent from EPP-01A." }
}
$composites = @('U501','U502','U503','U601','U602','U701','U703')
foreach ($reference in $composites) {
    $row = $population | Where-Object Reference -eq $reference
    if ($row.'Prototype Population Status' -ne 'BLOCKED - PHYSICAL DEFINITION REQUIRED') { throw "$reference must remain blocked for ECO decomposition." }
    if ($review -notmatch [regex]::Escape($reference)) { throw "$reference is absent from the EPP-01A review." }
}
if ([regex]::Matches($review, '(?m)^# EPP-01A INCOMPLETE\r?$').Count -ne 1) { throw 'EPP-01A must contain exactly one INCOMPLETE decision.' }
if ([regex]::IsMatch($review, '(?m)^# EPP-01A COMPLETE')) { throw 'EPP-01A contains a conflicting COMPLETE decision.' }

$footprints = Get-ChildItem (Join-Path $root 'hardware/kicad') -Recurse -Filter '*.kicad_sch' | Select-String -Pattern '\(footprint\s+"[^"]+'
if ($footprints) { throw 'Footprints were assigned.' }
$pcb = Get-ChildItem $root -Recurse -Filter '*.kicad_pcb'
if ($pcb) { throw 'PCB files are prohibited in EPP-01A.' }

Write-Output 'EPP-01A validation passed: 408 dispositions; Sheet 04 physicalized; remaining composite mapping ECO required; zero footprints and PCB files.'
