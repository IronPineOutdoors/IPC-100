[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$main=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/PPQ-02_Remaining_Power_Performance_Qualification.md') -Raw
$reg=Get-Content (Join-Path $RepositoryRoot 'docs/qualification/Power_Component_Evidence_Register.md') -Raw
$files=@('Power_Operating_State_Matrix.md','Power_Regulator_Corner_Analysis.md','Power_Thermal_Model.md','Power_Magnetics_Requirements.md','Power_Capacitor_Requirements.md','Power_MOSFET_Stress_Model.md','Power_Protection_Energy_Model.md','Power_Threshold_and_Timing_Model.md','Power_Shared_Rail_Analysis.md','Power_PCB_Constraint_Register.md','Power_Single_Fault_Evidence.md')
$all=$main+$reg
foreach($file in $files){$text=Get-Content (Join-Path $RepositoryRoot "docs/qualification/$file") -Raw;Assert-True (-not [string]::IsNullOrWhiteSpace($text)) "$file missing/empty.";$all+=$text}
$refs=[regex]::Matches($reg,'(?m)^\| ([A-Z]+[0-9]+) \|')|ForEach-Object {$_.Groups[1].Value}
Assert-True ($refs.Count -eq 124) "Expected 124 mapped references; found $($refs.Count)."
Assert-True (@($refs|Group-Object|Where-Object Count -ne 1).Count -eq 0) 'Duplicate evidence reference.'
Assert-True ([regex]::Matches($reg,'READY FOR PPC-01 \|').Count -eq 19) 'PPC route mismatch.'
Assert-True ([regex]::Matches($reg,'READY FOR PAS-01 \|').Count -eq 104) 'PAS route mismatch.'
Assert-True ([regex]::Matches($reg,'READY FOR JCS-01 \|').Count -eq 1) 'JCS route mismatch.'
foreach($token in @('0.980','1.246','26.4','60.1','0.635','0.959','11.55 J','500 A²s','162.82–222.35 mA','19 + 104 + 1 = 124')){Assert-True $all.Contains($token) "Missing calculation token $token."}
Assert-True ([regex]::Matches($main,'(?m)^# PPQ-02 (?:COMPLETE|INCOMPLETE)$').Count -eq 1) 'PPQ-02 must have one decision.'
Assert-True ($main -match '(?m)^# PPQ-02 COMPLETE$') 'PPQ-02 is not complete.'
$s02=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/02_Power_Conversion.kicad_sch') -Raw
foreach($ref in @('R222','R223','R224')){Assert-True ($s02 -match "(?s)Reference`" `"$ref`".*?Value`" `"141 k") "$ref regression."}
$changed=git -C $RepositoryRoot diff --name-only 3e79495
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/bom/|docs/adr/|docs/icd/') "Prohibited PPQ-02 change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_csr01ar4.ps1') -RepositoryRoot $RepositoryRoot;if(-not $?){throw 'CSR-01A-R4 regression failed.'}
Write-Host 'PPQ-02 validation passed: 124 unique rows; 19 PPC; 104 PAS; 1 JCS; evidence-only scope.'
