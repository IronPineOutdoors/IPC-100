[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/specifications/QER-03_Core_Reset_Release_Timing_Window.md') -Raw
foreach($token in @('U302','C305','100 ms exact nominal target','75–150 ms','76–149 ms','positive threshold crossing','79.1–136.6 ms','QER-RST-01','QER-RST-08','ECO-009R — C305 Timing Closure','RESET_VALID','WATCHDOG_VALID','ACTUATOR_PERMIT','50 µs')){Assert-True $doc.Contains($token) "QER-03 missing $token."}
Assert-True ([regex]::Matches($doc,'(?m)^# QER-03 (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'QER-03 must issue exactly one decision.'
Assert-True ($doc -match '(?m)^# QER-03 ACCEPTED$') 'QER-03 not accepted.'
Assert-True ($doc -match '100 ms.*exact nominal design target') '100 ms interpretation is ambiguous.'
Assert-True ($doc -match 'every release measurement 76–149 ms') 'Prototype pass/fail window absent.'
Assert-True ($doc -match 'full 75–150 ms release interval') 'Brownout restart contract absent.'
Assert-True ($doc -match 'PACS-01.*not authorize|does not authorize PACS-01') 'PACS-01 gate missing.'
$changed=git -C $RepositoryRoot diff --name-only 7a9243c
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/adr/|docs/icd/|docs/connectors/') "Prohibited QER-03/follow-on change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Host 'QER-03 validation passed: 100 ms nominal; 75..150 ms design; 76..149 ms prototype; ECO-009R authorized; requirements-only scope.'
