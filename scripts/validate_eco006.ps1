[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$errors = [System.Collections.Generic.List[string]]::new()
function Require([bool]$Condition, [string]$Message) { if (-not $Condition) { $errors.Add($Message) } }

$s01 = Get-Content (Join-Path $repo 'hardware/kicad/sheets/01_Power_Entry.kicad_sch') -Raw
$s07 = Get-Content (Join-Path $repo 'hardware/kicad/sheets/07_UI_Peripherals.kicad_sch') -Raw
$s08 = Get-Content (Join-Path $repo 'hardware/kicad/sheets/08_Expansion.kicad_sch') -Raw
$register = Get-Content (Join-Path $repo 'docs/reference/Reference_Designator_Register.md') -Raw

Require (-not ($s01 -match '100 nF 50 V|22 µF 50 V|60 V N-FET')) 'Legacy incompatible power ratings remain on Sheet 01.'
Require (([regex]::Matches($s01, '>=100 V X7R')).Count -eq 2) 'Expected two corrected 100 V ceramic requirements.'
Require (([regex]::Matches($s01, '>=63 V low-ESR bulk')).Count -eq 2) 'Expected two corrected >=63 V bulk requirements.'
Require ($s01 -match '>=80 V N-FET') 'Q101 does not require the >=80 V class.'
Require (-not ($s07 -match 'I2C_POWER_QUALIFIED_BRANCH')) 'U706/U707 composite symbol remains.'
Require (([regex]::Matches($s07, 'IPC100:I2C_DUAL_SUPPLY_BUFFER_EN')).Count -ge 3) 'Physical Sheet 07 buffer definition/instances missing.'
Require ($s07 -match '"R704"' -and $s07 -match '"R705"') 'Sheet 07 EN fail-low biases missing.'
Require ($s07 -match '"C702"' -and $s07 -match '"C703"' -and $s07 -match '"C704"' -and $s07 -match '"C705"') 'Sheet 07 physical buffer bypass capacitors missing.'
Require (-not ($s08 -match 'EXPANSION_RAIL_QUALIFIER')) 'U801 composite symbol remains.'
Require ($s08 -match 'IPC100:RAIL_VALID_SUPERVISOR_PP') 'Physical U801 supervisor missing.'
Require ($register -match '`R704`' -and $register -match '`R705`') 'Reference register lacks ECO-006 additions.'

$schematics = Get-ChildItem (Join-Path $repo 'hardware/kicad') -Recurse -Filter '*.kicad_sch'
foreach ($file in $schematics) {
    $content = Get-Content $file.FullName -Raw
    Require (-not ($content -match '\(property "Footprint" "[^"\r\n]+"')) "Footprint assigned in $($file.Name)."
}

if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'ECO-006 targeted validation passed.'
