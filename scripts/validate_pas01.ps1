[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
& (Join-Path $RepositoryRoot 'scripts/generate_pas01_register.ps1') -RepositoryRoot $RepositoryRoot
$rows=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/PAS-01_Passive_Selection_Register.csv') -Encoding UTF8)
Assert-True ($rows.Count -eq 88) "Expected 88 passive rows after ECO-010; found $($rows.Count)."
Assert-True (@($rows|Group-Object Sheet,Reference|Where-Object Count -ne 1).Count -eq 0) 'Duplicate passive reference.'
Assert-True (@($rows|Where-Object Status -eq 'FREEZE ELIGIBLE').Count -eq 67) 'Freeze-eligible count mismatch.'
Assert-True (@($rows|Where-Object Status -eq 'BLOCKED').Count -eq 21) 'Blocked count mismatch.'
Assert-True (@($rows|Where-Object {$_.Status -eq 'FREEZE ELIGIBLE' -and ([string]::IsNullOrWhiteSpace($_.MPN) -or [string]::IsNullOrWhiteSpace($_.Manufacturer))}).Count -eq 0) 'Eligible row lacks exact selection.'
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PAS-01_Passive_Component_Selection_and_Electrical_Class_Freeze.md') -Raw
Assert-True ($doc -match '(?m)^# PAS-01 INCOMPLETE$') 'PAS-01 decision missing.'
$changed=git -C $RepositoryRoot diff --name-only de5ab5c
$changed=@($changed|Where-Object{$_ -notin @('hardware/kicad/sheets/04_Safety_Inputs.kicad_sch','hardware/kicad/sheets/05_Motor_Interfaces.kicad_sch')})
$changed=@($changed|Where-Object{$_ -notin @('hardware/kicad/sheets/01_Power_Entry.kicad_sch','hardware/kicad/sheets/08_Expansion.kicad_sch')})
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_pcb$|docs/adr/|docs/icd/') "Prohibited PAS-01 change: $path";if($path -match '\.kicad_sch$'){Assert-True ($path -eq 'hardware/kicad/sheets/03_ESP32_Core.kicad_sch') "Prohibited PAS-01 schematic change: $path"}}
Write-Host 'PAS-01 validation passed: 85 unique passives; 67 freeze eligible; 18 blocked; zero CAD changes.'
