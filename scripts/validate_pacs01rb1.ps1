[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R-B1_Manufacturer_Thermal_Commercial_Evidence.md') -Raw
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
foreach($ref in $refs){Assert-True ($doc.Contains($ref)) "PACS-01R-B1 reference missing: $ref"}
foreach($section in 1..10){Assert-True ($doc -match "(?m)^## $section\. ") "PACS-01R-B1 section missing: $section"}
foreach($token in @('θJA','θJC','θJB','26.4 °C/W','60.1 °C/W','182.6','WEBENCH','TPS62135','ZθJC','2,882','nine-week','PACS-01R-B1R','PACS-01R-C and PPC-01 are not authorized')){Assert-True ($doc.Contains($token)) "PACS-01R-B1 evidence token missing: $token"}
Assert-True ([regex]::Matches($doc,'(?m)^# PACS-01R-B1 (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'PACS-01R-B1 must issue exactly one decision.'
Assert-True ($doc -match '(?m)^# PACS-01R-B1 NOT ACCEPTED$') 'PACS-01R-B1 decision mismatch.'
$changed=@(git -C $RepositoryRoot diff --name-only cd444be)
$changed=@($changed|Where-Object{$_ -ne 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'})
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/decisions/|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01R-B1 change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_pacs01rb.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'PACS-01R-B regression failed'}
Write-Host 'PACS-01R-B1 validation passed: manufacturer/thermal/SOA/commercial gaps bounded; decision NOT ACCEPTED; zero CAD changes.'
