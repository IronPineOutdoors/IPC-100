[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$s03=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/03_ESP32_Core.kicad_sch') -Raw
Assert-True ($s03 -match '(?s)Reference" "C305".*?Value" "93\.1 nF.*?99\.642 ms') 'C305 corrected value absent.'
Assert-True ($s03 -notmatch '(?s)Reference" "C305".*?Value" "10 nF') 'C305 remains 10 nF.'
Assert-True ([regex]::Matches($s03,'Reference" "C305"').Count -eq 1) 'C305 reference changed or duplicated.'
Assert-True ($s03.Contains('60000000-0000-4000-8000-000000000136')) 'C305 UUID changed.'
Assert-True ([regex]::Matches($s03,'label "CORE_RESET_CT"').Count -ge 2) 'C305/U302 CT named connection changed.'
$doc=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-009_C305_Supervisor_Timing_Correction.md') -Raw
foreach($token in @('99.642 ms','79.1 ms','136.6 ms','QER minimum: **not specified**','TPS3890-Q1')){Assert-True $doc.Contains($token) "ECO-009 evidence missing $token."}
Assert-True ([regex]::Matches($doc,'(?m)^# ECO-009 (?:COMPLETE — PACS-01 AUTHORIZED|INCOMPLETE)$').Count -eq 1) 'ECO-009 must issue one decision.'
Assert-True ($doc -match '(?m)^# ECO-009 INCOMPLETE$') 'ECO-009 decision mismatch.'
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8);$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv') -Encoding UTF8)
$e=$ebom|Where-Object {$_.Sheet -eq '03_ESP32_Core' -and $_.Reference -eq 'C305'}|Select-Object -First 1;$a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1
Assert-True ($e.Value -match '^93\.1 nF' -and $e.Risk -match '^ECO-009(?:R)?') 'C305 EBOM reconciliation failed.'
Assert-True ($a.Risk -eq $e.Risk -and $a.'Freeze Status' -eq $e.'Freeze Status') 'C305 AVL reconciliation failed.'
$rdr=Get-Content (Join-Path $RepositoryRoot 'docs/reference/Reference_Designator_Register.md') -Raw;Assert-True ($rdr -match 'C305.*93\.1 nF') 'Reference register not synchronized.'
$changed=git -C $RepositoryRoot diff --name-only b17222a
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_pcb$|docs/adr/|docs/icd/|docs/connectors/') "Prohibited ECO-009 change: $path";if($path -match '\.kicad_sch$'){Assert-True ($path -eq 'hardware/kicad/sheets/03_ESP32_Core.kicad_sch') "Unrelated schematic changed: $path"}}
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Host 'ECO-009 validation passed: nominal corrected to 99.642 ms; 79.1..136.6 ms bounded; requirement window remains open; zero footprints.'
