[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
function Assert-Near([double]$Actual,[double]$Expected,[double]$Tolerance,[string]$Message){Assert-True ([math]::Abs($Actual-$Expected)-le $Tolerance) "$Message Actual=$Actual Expected=$Expected"}
$s02=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/02_Power_Conversion.kicad_sch') -Raw
$note=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-008R_TPS2553_Current_Limit_Implementation.md') -Raw
foreach($ref in @('R222','R223','R224')){Assert-True ([regex]::Matches($s02,"(?s)Reference`" `"$ref`".*?Value`" `"141 k").Count -eq 1) "$ref is not 141 kOhm."}
foreach($ref in @('U209','U212','U213')){Assert-True ([regex]::Matches($s02,"(?s)Reference`" `"$ref`".*?Value`" `"TPS2553-Q1.*?141 k").Count -eq 1) "$ref annotation mismatch."}
foreach($net in @('EXP_ILIM','U12_ILIM','U13_ILIM')){Assert-True ([regex]::Matches($s02,[regex]::Escape('"'+$net+'"')).Count -eq 2) "$net missing/shared."}
$rNom=141.0;$rLow=$rNom*0.99*(1-45*100e-6);$rHigh=$rNom*1.01*(1+50*100e-6)
$iMin=25230/[math]::Pow($rHigh,1.016);$iNom=23950/[math]::Pow($rNom,0.977);$iMax=22980/[math]::Pow($rLow,0.94)
Assert-Near $rLow 138.961845 0.000001 'R low mismatch.'; Assert-Near $rHigh 143.12205 0.000001 'R high mismatch.'
Assert-Near $iMin 162.8244 0.001 'I minimum mismatch.'; Assert-Near $iNom 190.3349 0.001 'I nominal mismatch.'; Assert-Near $iMax 222.3454 0.001 'I maximum mismatch.'
Assert-True ($iMin -ge 160 -and $iMin -gt 150) 'Minimum does not support QER/startup.'
Assert-True ($iMax -le 225) 'Maximum exceeds QER ceiling.'
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv') -Encoding UTF8)
foreach($ref in @('R222','R223','R224','U209','U212','U213')){
 $erow=$ebom|Where-Object Reference -eq $ref; $arow=$avl|Where-Object Item -eq "02_Power_Conversion/$ref"
 Assert-True ($erow.'Freeze Status' -eq 'BLOCKED' -and $arow.'Freeze Status' -eq 'BLOCKED') "$ref must remain BLOCKED."
 Assert-True ($erow.Value -match '141 k') "$ref EBOM generic value is stale."
 Assert-True ($arow.Risk -match '141 kOhm') "$ref AVL generic risk is stale."
}
Assert-True ([regex]::Matches($note,'(?m)^# ECO-008R (?:COMPLETE.*|INCOMPLETE)$').Count -eq 1) 'ECO-008R must have exactly one decision.'
Assert-True ($note -match '(?m)^# ECO-008R COMPLETE .* CSR-01A-R4 AUTHORIZED$') 'ECO-008R decision mismatch.'
$changed=git -C $RepositoryRoot diff --name-only edd2244
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_pcb$|docs/adr/|docs/icd/') "Prohibited ECO-008R change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1'); if(-not $?){throw 'Hierarchy regression failed.'}
& (Join-Path $RepositoryRoot 'scripts/validate_gpio_allocation.ps1'); if(-not $?){throw 'GPIO regression failed.'}
Write-Host 'ECO-008R validation passed: 141 kOhm; 162.824..222.345 mA; six rows blocked; zero footprints.'
