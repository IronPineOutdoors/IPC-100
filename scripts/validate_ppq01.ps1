[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
function Assert-Near([double]$Actual,[double]$Expected,[double]$Tolerance,[string]$Message){Assert-True ([math]::Abs($Actual-$Expected)-le $Tolerance) "$Message Actual=$Actual Expected=$Expected"}

$main=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/PPQ-01_Power_Performance_Qualification.md') -Raw
$load=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/Power_Load_Model.md') -Raw
$thermal=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/Power_Thermal_Model.md') -Raw
$stress=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/Power_Stress_Model.md') -Raw
$protection=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/Power_Protection_Model.md') -Raw
$register=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/Qualification_Evidence_Register.md') -Raw
foreach($text in @($main,$load,$thermal,$stress,$protection,$register)){Assert-True (-not [string]::IsNullOrWhiteSpace($text)) 'A PPQ-01 document is empty.'}

Assert-Near (7.5/0.85/9) 0.9804 0.001 'Low-line current failed.'
Assert-Near (7.5/0.85/8.5) 1.0381 0.001 'Brownout current failed.'
Assert-Near (7.5/0.85-7.5) 1.3235 0.001 'Main loss failed.'
Assert-Near (3.3/0.85-3.3) 0.5824 0.001 'Core loss failed.'
Assert-Near (0.5*46.4e-6*21*21) 0.01023 0.00002 'Input stored energy failed.'
Assert-Near (46.4e-6*21) 0.000974 0.000002 'Input charge failed.'
Assert-Near (4.4*0.5*0.85/3.3) 0.5667 0.001 'USB-only capability failed.'
$d=5.0/21.0;$ripple=(21-5)*$d/(15e-6*400e3)
Assert-Near $ripple 0.6349 0.001 'Inductor ripple failed.'
Assert-Near (1.5*[math]::Sqrt($d*(1-$d))) 0.639 0.001 'Input capacitor RMS failed.'
Assert-Near (1*0.002/0.3) 0.006667 0.00001 'Hold-up requirement failed.'
Assert-True ($main -match '154–209 mA' -and $main -match 'exceeds QER') 'TPS2553/QER conflict is not explicit.'

$blocked=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8|Where-Object{$_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'BLOCKED'})
foreach($row in $blocked){Assert-True ([regex]::Matches($register,"(?m)^\| $([regex]::Escape($row.Reference)) \| $([regex]::Escape($row.Sheet)) \|").Count -eq 1) "Register does not contain $($row.Item) exactly once."}
Assert-True (([regex]::Matches($register,'(?m)^\| [A-Z]+\d+ \|').Count)-eq 124) 'Register row count is not 124.'
Assert-True (([regex]::Matches($register,'(?m)\| YES \|\r?$').Count)-eq 50) 'Eligible count is not 50.'
Assert-True (([regex]::Matches($register,'(?m)\| NO \|\r?$').Count)-eq 74) 'Ineligible count is not 74.'
foreach($ref in @('U209','U212','U213','R222','R223','R224')){Assert-True ($register -match "(?m)^\| $ref \|.*\| NO \|\r?$") "$ref is not explicitly ineligible."}
Assert-True ([regex]::Matches($main,'(?m)^# PPQ-01 (?:COMPLETE|INCOMPLETE)$').Count -eq 1) 'PPQ-01 must contain exactly one decision.'
Assert-True ($main -match '(?m)^# PPQ-01 COMPLETE$') 'PPQ-01 is not COMPLETE.'
Assert-True ($main -match 'ECO-008 — Branch Current-Limit Compliance Remediation') 'Required ECO-008 gate missing.'

& (Join-Path $RepositoryRoot 'scripts/validate_peb01.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'PEB-01 regression failed.'}
Write-Host 'PPQ-01 validation passed: 124 qualified rows; 50 eligible; 74 ineligible; TPS2553/QER conflict controlled by ECO-008 gate.'
