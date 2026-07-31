[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
function Assert-Near([double]$Actual,[double]$Expected,[double]$Tolerance,[string]$Message){Assert-True ([math]::Abs($Actual-$Expected)-le $Tolerance) "$Message Actual=$Actual Expected=$Expected"}

$s02=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/02_Power_Conversion.kicad_sch') -Raw
$note=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-008_TPS2553_Branch_Limit_Compliance.md') -Raw
foreach($ref in @('U209','U212','U213')){Assert-True ([regex]::Matches($s02,"Reference`" `"$ref`"").Count -eq 1) "$ref missing or duplicated."}
foreach($ref in @('R222','R223','R224')){
  Assert-True ([regex]::Matches($s02,"(?s)Reference`" `"$ref`".*?Value`" `"(?:150|141) k").Count -eq 1) "$ref historical/implemented network missing."
}
foreach($net in @('EXP_ILIM','U12_ILIM','U13_ILIM')){Assert-True ([regex]::Matches($s02,[regex]::Escape('"'+$net+'"')).Count -eq 2) "$net is missing or shared unexpectedly."}

$rActualMin=[math]::Pow(22980/150,1/0.94)
$rActualMax=[math]::Pow(25230/150,1/1.016)
$rNomMin=$rActualMin/0.99
$rNomMax=$rActualMax/1.01
Assert-Near $rNomMin 213.3576 0.001 'Ceiling-derived nominal R minimum failed.'
Assert-Near $rNomMax 153.6216 0.001 'Peak-derived nominal R maximum failed.'
Assert-True ($rNomMin -gt $rNomMax) 'Legal RILIM window unexpectedly overlaps.'
$iMax150=22980/[math]::Pow(150*0.99,0.94)
$iMin150=25230/[math]::Pow(150*1.01,1.016)
Assert-Near $iMax150 208.9 0.2 'Released worst maximum failed.'
Assert-Near $iMin150 153.7 0.2 'Released worst minimum failed.'

$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
foreach($ref in @('U209','U212','U213','R222','R223','R224')){Assert-True (($ebom|Where-Object Reference -eq $ref).'Freeze Status' -eq 'BLOCKED') "$ref is not BLOCKED."}
Assert-True ([regex]::Matches($note,'(?m)^# ECO-008 (?:COMPLETE.*|INCOMPLETE)$').Count -eq 1) 'ECO-008 must contain exactly one decision.'
Assert-True ($note -match '(?m)^# ECO-008 INCOMPLETE$') 'ECO-008 must be INCOMPLETE.'
Assert-True ($note -match 'QER-02 — Branch Peak and Protection Ceiling Reconciliation') 'QER-02 gate missing.'
Assert-True ($note -match 'No schematic change') 'No-change disposition missing.'

& (Join-Path $RepositoryRoot 'scripts/validate_ppq01.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'PPQ-01 regression failed.'}
Write-Host 'ECO-008 historical validation passed: original empty window remains documented; QER-02/ECO-008R supersession permitted.'
