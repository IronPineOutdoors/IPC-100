[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R-B_Active_Evidence_Closure.md') -Raw
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'))
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
foreach($ref in $refs){$e=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1;Assert-True ($null-ne$e -and -not [string]::IsNullOrWhiteSpace($e.'Manufacturer Part Number')) "Active MPN missing: $ref";Assert-True ($doc.Contains($ref)) "Device evidence missing: $ref"}
foreach($section in @('Manufacturer Evidence','Thermal Analysis','Derating Analysis','Lifecycle Review','Sourcing Review','Alternates','Risk Matrix','Remaining Prototype Evidence','Validation Results')){Assert-True ($doc -match "## $section") "PACS-01R-B section missing: $section"}
foreach($token in @('ACTIVE','θJA','Estimated TJ','Voltage utilization','Current utilization','DigiKey','Mouser','PACS-01R-B1','PACS-01R-C and PPC-01 are not authorized')){Assert-True ($doc.Contains($token)) "PACS-01R-B evidence token missing: $token"}
Assert-True ([regex]::Matches($doc,'(?m)^# PACS-01R-B (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'PACS-01R-B must issue exactly one decision.'
Assert-True ($doc -match '(?m)^# PACS-01R-B NOT ACCEPTED$') 'PACS-01R-B decision mismatch.'
$changed=@(git -C $RepositoryRoot diff --name-only eb01ca7)
$changed=@($changed|Where-Object{$_ -ne 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'})
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/decisions/|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01R-B change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_pacs01ra.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'PACS-01R-A regression failed'}
Write-Host 'PACS-01R-B validation passed: 20 devices reviewed; decision NOT ACCEPTED; PACS-01R-B1 required; zero CAD changes.'
