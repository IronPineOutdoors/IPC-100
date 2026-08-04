$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$qer = Get-Content -Raw (Join-Path $root 'docs/specifications/QER-04_Safety_Comparator_Input_Range_and_Threshold_Implementation.md')
$sheetPath = Join-Path $root 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'
$sheet = Get-Content -Raw $sheetPath

if ([regex]::Matches($qer, '(?m)^# QER-04 ACCEPTED — ECO-011A1R AUTHORIZED\r?$').Count -ne 1) { throw 'QER-04 requires exactly one accepted decision.' }
if ($qer -match '(?m)^# QER-04 NOT ACCEPTED') { throw 'Conflicting QER-04 decision.' }

foreach ($reference in @('U401AB','U401CD','U402AB','U402CD','U403AB','U403C','U403D')) {
    if ($qer -notmatch [regex]::Escape($reference)) { throw "QER-04 omits $reference." }
    if ($sheet -notmatch ('property "Reference" "' + [regex]::Escape($reference) + '"')) { throw "Sheet 04 lost $reference." }
}
foreach ($token in @('STOP','Left','Right','Up','Down','ARM','FIRE','2.324','2.679','4.743','0.90–1.10','3.80–4.20','TLV7044-Q1','VCC + 0.1 V','typical-only','Safety-Window Truth Table','ARM/FIRE Receiver Truth Table','Fail-Safe Analysis','Package-Allocation Strategy','Prototype Validation Contract')) {
    if ($qer -notmatch [regex]::Escape($token)) { throw "QER-04 evidence missing: $token" }
}
if ($qer -notmatch '1.3 V' -or $qer -notmatch '3.0 V' -or $qer -notmatch 'SUITABLE ONLY WITH INPUT SCALING') { throw 'LM339B supply-option disposition is incomplete.' }
if ($qer -notmatch 'ADR-042.*remain unchanged' -or $qer -notmatch 'GPIO.*hierarchy.*references.*EBOM/AVL.*footprints.*PCB') { throw 'Prohibited-scope declaration is incomplete.' }

$footprints = Get-ChildItem (Join-Path $root 'hardware/kicad') -Recurse -Filter '*.kicad_sch' | Select-String -Pattern '\(footprint\s+"[^"]+'
if ($footprints) { throw 'Footprints were assigned.' }
if (Get-ChildItem $root -Recurse -Filter '*.kicad_pcb') { throw 'PCB files are prohibited.' }

& (Join-Path $PSScriptRoot 'validate_qer02.ps1') -RepositoryRoot $root

Write-Output 'QER-04 validation passed: seven composites, five windows, two commands, bounded direct-input architecture, fail-safe logic, no CAD/physical/interface changes.'
