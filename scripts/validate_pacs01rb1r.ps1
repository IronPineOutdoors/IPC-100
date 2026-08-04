[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R-B1R_Controlled_Evidence_Completion.md') -Raw
$thermal=Get-Content (Join-Path $RepositoryRoot 'docs/evidence/thermal/IPC100_RevA_Provisional_Thermal_Board_Baseline.md') -Raw
$soa=@(Import-Csv (Join-Path $RepositoryRoot 'docs/evidence/soa/PACS-01R-B1R_SOA_Register.csv'))
$commercial=@(Import-Csv (Join-Path $RepositoryRoot 'docs/evidence/commercial/PACS-01R-B1R_Commercial_Quote_Register.csv'))
foreach($section in 1..24){Assert-True ($doc -match "(?m)^## $section\. ") "PACS-01R-B1R section missing: $section"}
foreach($case in @('A — Minimum copper','B — Expected Rev A','C — Enhanced copper')){Assert-True ($thermal.Contains($case)) "Thermal case missing: $case"}
Assert-True ($thermal -match 'four-layer FR-4' -and $thermal -match '900 mm²' -and $thermal -match '\| 9 \|' -and $thermal -match 'junction target ≤110') 'Thermal baseline is incomplete.'
foreach($ref in @('U201','U203')){$manifest=Get-Content (Join-Path $RepositoryRoot "docs/evidence/manufacturer-tools/$ref/Tool_Evidence_Manifest.md") -Raw;Assert-True ($manifest -match 'BLOCKED.*tool unavailable' -and $manifest -match 'Hash: not applicable') "$ref tool limitation not controlled."}
Assert-True ($soa.Count -eq 5 -and @($soa|Where-Object{[string]::IsNullOrWhiteSpace($_.Disposition)}).Count -eq 0) 'SOA register disposition mismatch.'
Assert-True ($commercial.Count -eq 13 -and @($commercial.MPN|Sort-Object -Unique).Count -eq 13) 'Commercial register must contain 13 unique MPNs.'
foreach($row in $commercial){foreach($field in @('Preferred Distributor','Alternate Distributor','MOQ','Lead Time','Alternate Disposition','Access Date','Confidence','Refresh')){Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "Commercial field missing: $($row.MPN)/$field"}}
Assert-True ([regex]::Matches($doc,'(?m)^# PACS-01R-B1R (?:ACCEPTED.*|NOT ACCEPTED)$').Count -eq 1) 'PACS-01R-B1R must issue exactly one decision.'
Assert-True ($doc -match '(?m)^# PACS-01R-B1R NOT ACCEPTED$' -and $doc -match 'PACS-01R-C and PPC-01 are not authorized') 'PACS-01R-B1R gate mismatch.'
$changed=@(git -C $RepositoryRoot diff --name-only 0b4b201)
$changed=@($changed|Where-Object{$_ -ne 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'})
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/decisions/|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01R-B1R change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_pacs01rb1.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'PACS-01R-B1 regression failed'}
Write-Host 'PACS-01R-B1R validation passed: controlled evidence dossier complete; external inputs blocked; zero CAD changes.'
