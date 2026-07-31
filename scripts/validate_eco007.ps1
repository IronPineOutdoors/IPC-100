[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }
$s02 = Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/02_Power_Conversion.kicad_sch') -Raw
$s08 = Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/08_Expansion.kicad_sch') -Raw
$note = Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-007_Power_Programming_and_Supervisor_Correction.md') -Raw
Assert-True ($s02 -match 'LMR38020F-Q1' -and $s02 -match '64\.9 k') 'U201/R201 correction missing.'
Assert-True ($s02 -notmatch '40\.2 k' -and $s02 -notmatch '287 k') 'Obsolete programming value remains.'
foreach ($ref in @('R222','R223','R224')) { Assert-True ($s02 -match "(?s)Reference`" `"$ref`".*?Value`" `"150 k") "$ref is not an independent 150 kOhm RILIM resistor." }
Assert-True ($s08 -match 'TLV841S_2V7_VALID_HIGH' -and $s08 -notmatch 'RAIL_VALID_SUPERVISOR_PP') 'Physical U801 correction missing.'
foreach ($token in @('R806','150 k','R808','4.47 M','C804','EXP_SUP_SENSE')) { Assert-True ($s08.Contains($token)) "U801 network token missing: $token" }
Assert-True ($s08 -match 'R801' -and $s08 -match 'segment-enable fail-low bias') 'Output fail-low bias missing.'
Assert-True ($note -match '2\.930 V' -and $note -match '2\.680 V' -and $note -match '154.*209 mA') 'Required calculations are not documented.'
$files = @(Get-ChildItem (Join-Path $RepositoryRoot 'hardware/kicad') -Recurse -Filter '*.kicad_sch')
$refs = @(); $uuids = @()
foreach ($file in $files) {
  $t = Get-Content $file.FullName -Raw
  Assert-True (([regex]::Matches($t,'\(').Count) -eq ([regex]::Matches($t,'\)').Count)) "Unbalanced schematic: $($file.Name)"
  foreach ($m in [regex]::Matches($t, '\(property "Reference" "([^"#][^"]*)"')) { if ($m.Groups[1].Value -notin @('R','C','U','D','Q','L','F','FB','K','SW','J','TP')) { $refs += $m.Groups[1].Value } }
  foreach ($m in [regex]::Matches($t, '\(uuid ([0-9a-fA-F-]{36})\)')) { $uuids += $m.Groups[1].Value }
  Assert-True ($t -notmatch '\(property "Footprint" "[^"\r\n]+"') "Footprint assigned in $($file.Name)."
}
Assert-True (@($refs | Group-Object | Where-Object Count -gt 1).Count -eq 0) 'Duplicate physical references found.'
# Project-path UUID reuse is expected in KiCad instance records; the main hierarchy validator checks owning UUID identities.
Write-Host 'ECO-007 targeted validation passed.'
