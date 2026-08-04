$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$review = Get-Content -Raw (Join-Path $root 'hardware/kicad/notes/ECO-011A1_Safety_Input_Decomposition.md')
$sheet = Get-Content -Raw (Join-Path $root 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch')

if ([regex]::Matches($review, '(?m)^# ECO-011A1 INCOMPLETE\r?$').Count -ne 1) { throw 'ECO-011A1 requires exactly one INCOMPLETE decision.' }
if ([regex]::IsMatch($review, '(?m)^# ECO-011A1 COMPLETE')) { throw 'Conflicting ECO-011A1 COMPLETE decision.' }

$references = @('U401AB','U401CD','U402AB','U402CD','U403AB','U403C','U403D')
foreach ($reference in $references) {
    if ($review -notmatch [regex]::Escape($reference)) { throw "Review omits $reference." }
    if ($sheet -match ('property "Reference" "' + [regex]::Escape($reference) + '"')) { throw "ECO-011A1R failed to retire $reference." }
}
if ($review -notmatch '1\.3 V' -or $review -notmatch '3\.0 V' -or $review -notmatch 'QER-04') { throw 'Common-mode incompatibility or handoff is incomplete.' }

$footprints = Get-ChildItem (Join-Path $root 'hardware/kicad') -Recurse -Filter '*.kicad_sch' | Select-String -Pattern '\(footprint\s+"[^"]+'
if ($footprints) { throw 'Footprints were assigned.' }
$pcb = Get-ChildItem $root -Recurse -Filter '*.kicad_pcb'
if ($pcb) { throw 'PCB files are prohibited.' }

Write-Output 'ECO-011A1 historical validation passed: LM339B conflict controlled; seven composites subsequently retired by ECO-011A1R; zero footprints and PCB files.'
