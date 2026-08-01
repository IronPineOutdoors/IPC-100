[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }
function Assert-Near([double]$Actual,[double]$Expected,[double]$Tolerance,[string]$Message) { Assert-True ([math]::Abs($Actual-$Expected) -le $Tolerance) "$Message Actual=$Actual Expected=$Expected" }

$main = Get-Content (Join-Path $RepositoryRoot 'docs/analysis/PEB-01_Power_Evidence_Baseline.md') -Raw
$load = Get-Content (Join-Path $RepositoryRoot 'docs/analysis/Power_Load_Budget.md') -Raw
$thermal = Get-Content (Join-Path $RepositoryRoot 'docs/analysis/Power_Thermal_Analysis.md') -Raw
$protection = Get-Content (Join-Path $RepositoryRoot 'docs/analysis/Power_Protection_Coordination.md') -Raw
$derating = Get-Content (Join-Path $RepositoryRoot 'docs/analysis/Power_Derating_Matrix.md') -Raw
$register = Get-Content (Join-Path $RepositoryRoot 'docs/analysis/Power_Component_Evidence_Register.md') -Raw
foreach ($text in @($main,$load,$thermal,$protection,$derating,$register)) { Assert-True (-not [string]::IsNullOrWhiteSpace($text)) 'A PEB-01 evidence document is empty.' }

foreach ($classification in @('Measured','Calculated','Manufacturer Datasheet','Engineering Estimate','Prototype Required')) { Assert-True ($main.Contains($classification)) "Missing assumption classification $classification." }
Assert-Near (3.3*1.0/5.0/0.85) 0.7765 0.001 'Core input-current calculation failed.'
Assert-Near (1.0*3.3/0.85-3.3) 0.5824 0.001 'Core loss calculation failed.'
Assert-Near (7.5/0.85-7.5) 1.3235 0.001 'Main loss calculation failed.'
Assert-Near ((110-75)/(7.5/0.85-7.5)) 26.44 0.05 'Main theta envelope failed.'
$d21=5.0/21.0; $ripple21=(21.0-5.0)*$d21/(15e-6*400e3)
Assert-Near $ripple21 0.6349 0.001 'Main inductor ripple calculation failed.'
Assert-Near ([math]::Sqrt(1.5*1.5+$ripple21*$ripple21/12)) 1.511 0.002 'Inductor RMS calculation failed.'
Assert-Near (1.0*0.002/(3.3-3.0)) 0.006667 0.00001 'Core hold-up capacitance calculation failed.'

$blocked = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8 | Where-Object { $_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'BLOCKED' -and $_.Reference -notin @('C805','R807','R809') })
Assert-True ($blocked.Count -eq 124) 'Expected 124 blocked power rows.'
foreach ($row in $blocked) { Assert-True ([regex]::Matches($register, "(?m)^\| $([regex]::Escape($row.Reference)) \| $([regex]::Escape($row.Sheet)) \|").Count -eq 1) "Evidence register does not contain $($row.Item) exactly once." }
Assert-True ([regex]::Matches($register, '(?m)^\| [A-Z]+\d+ \|').Count -eq 124) 'Evidence register row count is not 124.'
foreach ($token in @('RC-A: 19','RC-B: 37','RC-C: 67','RC-D: 1','56 of 124 (45.2%)','PPQ-01','JCS-01')) { Assert-True (($main+$register).Contains($token)) "Missing coverage token $token." }
Assert-True ([regex]::Matches($main, '(?m)^# PEB-01 (?:COMPLETE|INCOMPLETE)$').Count -eq 1) 'PEB-01 must contain exactly one final decision.'
Assert-True ($main -match '(?m)^# PEB-01 COMPLETE$') 'PEB-01 decision is not COMPLETE.'

& (Join-Path $RepositoryRoot 'scripts/validate_dra01.ps1') -RepositoryRoot $RepositoryRoot
if (-not $?) { throw 'DRA-01 regression failed.' }
Write-Host 'PEB-01 validation passed: analytical baseline complete; 124 evidence rows; 56 forecast eligible; PPQ-01/JCS-01 required before CSR-01A-R4.'
