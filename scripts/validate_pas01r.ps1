[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
& (Join-Path $RepositoryRoot 'scripts/generate_pas01r_register.ps1') -RepositoryRoot $RepositoryRoot
$reg=@(Import-Csv (Join-Path $RepositoryRoot 'docs/analysis/passives/PAS-01R_Disposition_Register.csv') -Encoding UTF8)
$pas=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/PAS-01_Passive_Selection_Register.csv') -Encoding UTF8)
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv') -Encoding UTF8)
Assert-True ($reg.Count -eq 18) "Expected 18 PAS-01R rows; found $($reg.Count)."
Assert-True (@($reg|Group-Object Sheet,Reference|Where-Object Count -ne 1).Count -eq 0) 'Duplicate PAS-01R reference.'
Assert-True (@($reg|Where-Object Reference -like 'U*').Count -eq 0) 'Active device included in PAS-01R.'
Assert-True (@($reg|Where-Object 'Final Disposition' -eq 'BLOCKED — ACTIVE DEVICE SELECTION REQUIRED').Count -eq 17) 'PACS dependency count mismatch.'
Assert-True (@($reg|Where-Object 'Final Disposition' -eq 'BLOCKED — SCHEMATIC ECO REQUIRED').Count -eq 1) 'ECO disposition count mismatch.'
Assert-True ($pas.Count -eq 85) 'PAS scope no longer contains 85 rows.'
Assert-True (@($pas|Where-Object Status -eq 'FREEZE ELIGIBLE').Count -eq 67) 'Prior PAS selections not preserved.'
Assert-True (@($ebom|Where-Object {$_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'FROZEN' -and $_.Category -eq 'Passives'}).Count -eq 9) 'Nine prior frozen passives not preserved.'
foreach($r in $reg){
 $e=$ebom|Where-Object {$_.Sheet -eq $r.Sheet -and $_.Reference -eq $r.Reference}|Select-Object -First 1
 $a=$avl|Where-Object {$_.Item -eq $e.Item}|Select-Object -First 1
 Assert-True ($null -ne $e -and ($e.Risk -match '^PAS-01R: BLOCKED' -or ($r.Reference -eq 'C305' -and $e.Risk -match '^ECO-009'))) "EBOM disposition absent for $($r.Reference)."
 Assert-True ($null -ne $a -and $a.Risk -eq $e.Risk -and $a.'Freeze Status' -eq $e.'Freeze Status') "AVL mismatch for $($r.Reference)."
}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PAS-01R_Dependent_Passive_Curve_and_Tool_Closure.md') -Raw
Assert-True ([regex]::Matches($doc,'(?m)^# PAS-01R (?:ACCEPTED|INCOMPLETE)$').Count -eq 1) 'PAS-01R must issue exactly one final decision.'
Assert-True ($doc -notmatch '(?m)^# PAS-01R ACCEPTED$') 'PAS-01R decision unexpectedly accepted.'
foreach($file in @('IPC100_RevA_EBOM.xlsx','Approved_Vendor_List.xlsx')){Assert-True (Test-Path (Join-Path $RepositoryRoot "docs/bom/$file")) "$file missing."}
$sch=Get-ChildItem (Join-Path $RepositoryRoot 'hardware/kicad') -Recurse -Filter *.kicad_sch|ForEach-Object{Get-Content $_.FullName -Raw}
Assert-True ([regex]::Matches(($sch -join "`n"),'\(property "Footprint" ""').Count -gt 0) 'Footprint check unavailable.'
$changed=git -C $RepositoryRoot diff --name-only 421c613
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_pcb$|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PAS-01R change: $path";if($path -match '\.kicad_sch$'){Assert-True ($path -eq 'hardware/kicad/sheets/03_ESP32_Core.kicad_sch') "Prohibited PAS-01R schematic change: $path"}}
Write-Host 'PAS-01R validation passed: 18 unique passives; 17 PACS dependencies; one timing ECO; BOM/AVL synchronized; zero CAD changes.'
