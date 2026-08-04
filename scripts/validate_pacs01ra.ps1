[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R-A_Power_Active_Evidence_Closure.md') -Raw
$matrix=@(Import-Csv (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R-A_Evidence_Matrix.csv'))
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'))
$expected=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
$expanded=@();foreach($row in $matrix){$expanded+=@($row.'Reference(s)' -split '/')}
Assert-True ($expanded.Count -eq 20 -and @($expanded|Sort-Object -Unique).Count -eq 20) 'Evidence matrix must cover 20 unique active references.'
Assert-True (@($expected|Where-Object{$_ -notin $expanded}).Count -eq 0) 'Evidence matrix active reference missing.'
foreach($row in $matrix){foreach($field in @('MPN','Current Status','Primary Blocker','Evidence Needed','Blocker Classes','No-Change Closure Initially','Estimated Closure Package','Expected Disposition')){Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "Evidence matrix missing $field for $($row.'Reference(s'))"};Assert-True ($row.'Current Status' -eq 'BLOCKED') 'A PACS-01R-A row is not blocked.';Assert-True ($row.'No-Change Closure Initially' -eq 'Yes') 'A current blocker already requires design change.'}
foreach($ref in $expected){$e=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1;Assert-True ($null-ne$e -and -not [string]::IsNullOrWhiteSpace($e.'Manufacturer Part Number')) "EBOM exact MPN missing for $ref"}
foreach($class in @('Documentation','Analytical','Prototype','Sourcing','Lifecycle','Thermal','Qualification')){Assert-True ($doc -match $class) "Blocker class missing: $class"}
Assert-True ([regex]::Matches($doc,'(?m)^# PACS-01R-A (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'PACS-01R-A must issue exactly one decision.'
Assert-True ($doc -match '(?m)^# PACS-01R-A ACCEPTED$') 'PACS-01R-A decision mismatch.'
Assert-True ($doc -match 'PACS-01R-B.*is authorized' -and $doc -match 'PPC-01.*remain unauthorized') 'Package authorization boundary mismatch.'
$changed=@(git -C $RepositoryRoot diff --name-only 7a07596)
$changed=@($changed|Where-Object{$_ -ne 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'})
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/decisions/|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01R-A change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_pacs01r.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'PACS-01R regression failed'}
Write-Host 'PACS-01R-A validation passed: 20 active references mapped; PACS-01R-B authorized; PPC-01 unauthorized; zero CAD changes.'
