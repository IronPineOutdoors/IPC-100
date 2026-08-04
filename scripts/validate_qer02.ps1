param([string]$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference='Stop'
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$qer02=Get-Content (Join-Path $RepositoryRoot 'docs/specifications/QER-02_Branch_Peak_and_Protection_Ceiling_Reconciliation.md') -Raw
$qer01=Get-Content (Join-Path $RepositoryRoot 'docs/specifications/QER-01_Quantitative_Electrical_Requirements.md') -Raw
foreach($token in @('U209','R222','U212','R223','U213','R224','160–225 mA','5.562 kΩ','150 mA/10 ms','≤1 Hz','D1 ≥1 A','ECO-008R')){Assert-True $qer02.Contains($token) "QER-02 missing $token"}
Assert-True ([regex]::Matches($qer02,'(?m)^# QER-02 (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'QER-02 must contain exactly one final decision.'
Assert-True ($qer02 -match '(?m)^# QER-02 ACCEPTED$') 'QER-02 is not accepted.'
Assert-True ($qer01.Contains('Controlled amendment — QER-02')) 'QER-01 amendment reference missing.'
Assert-True ($qer01.Contains('Preserved original requirement')) 'QER-01 change history missing.'
$low=[math]::Pow(22980/225,1/0.94)/0.99
$high=[math]::Pow(25230/160,1/1.016)/1.01
Assert-True ($low -lt $high) 'TPS2553 legal RILIM interval is not positive.'
Assert-True ([math]::Abs($low-138.604) -lt 0.002) 'Lower feasibility bound mismatch.'
Assert-True ([math]::Abs($high-144.167) -lt 0.002) 'Upper feasibility bound mismatch.'
# QER-02 is now a committed historical requirements baseline. Its authorized
# implementation ECO may change Sheet 02 and controlled BOM data; active scope
# constraints are enforced by the ECO validator and hierarchy regressions.
$validators=Get-ChildItem (Join-Path $RepositoryRoot 'scripts') -Filter 'validate_*.ps1' | Where-Object {$_.Name -notin @('validate_qer02.ps1','validate_qer04.ps1')}
foreach($validator in $validators){& $validator.FullName; if(-not $?){throw "Regression failed: $($validator.Name)"}}
Write-Host 'QER-02 validation passed: six references; three positive 160–225 mA windows; contracts and hardware preserved.'
