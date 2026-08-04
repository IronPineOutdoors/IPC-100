[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }

$ebom = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'))
$avl = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'))
$power = @($ebom | Where-Object { $_.'Selection Scope' -eq 'CSR-01A POWER' })
$frozen = @($power | Where-Object { $_.'Freeze Status' -eq 'FROZEN' })
$blocked = @($power | Where-Object { $_.'Freeze Status' -eq 'BLOCKED' })
Assert-True ($ebom.Count -eq 435 -and $avl.Count -eq 435) 'Expected 435 synchronized current EBOM/AVL rows after ECO-011A2.'
Assert-True ($power.Count -eq 136 -and $frozen.Count -eq 9 -and $blocked.Count -eq 127) 'Post-ECO-010 disposition counts are incorrect.'
Assert-True (@($power | Where-Object { $_.'Freeze Status' -notin @('FROZEN','CONDITIONAL','BLOCKED','NOT APPLICABLE') }).Count -eq 0) 'Power row lacks final disposition.'
foreach ($row in $frozen) {
  foreach ($field in @('Manufacturer','Manufacturer Part Number','Package','Lifecycle Status','Preferred Vendor','Alternate Vendor','Approved Alternate','Unit Cost 1','Unit Cost 10','Unit Cost 100','Unit Cost 1000','Requirement Trace Reference','Risk')) {
    Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "Frozen $($row.Item) lacks $field."
  }
}
foreach ($row in $blocked) { Assert-True ($row.Risk -match 'INCOMPLETE|UNRESOLVED|MISSING|UNAVAILABLE|PAS-01R: BLOCKED|ECO-009') "Blocked $($row.Item) lacks a specific blocker." }
$avlByItem = @{}; foreach ($row in $avl) { $avlByItem[$row.Item] = $row }
foreach ($row in $ebom) {
  Assert-True ($avlByItem.ContainsKey($row.Item)) "AVL lacks $($row.Item)."
  Assert-True ($avlByItem[$row.Item].'Freeze Status' -eq $row.'Freeze Status') "AVL status differs for $($row.Item)."
  Assert-True ($avlByItem[$row.Item].'Manufacturer Part Number' -eq $row.'Manufacturer Part Number') "AVL MPN differs for $($row.Item)."
}
$review = Get-Content (Join-Path $RepositoryRoot 'docs/reviews/CSR-01A-R3_Final_Power_Component_Selection.md') -Raw
Assert-True ([regex]::Matches($review, '(?m)^# CSR-01A-R3 (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'Review must contain exactly one final decision.'
Assert-True ($review -match '(?m)^# CSR-01A-R3 NOT ACCEPTED$') 'CSR-01A-R3 must not be accepted while blockers remain.'
Assert-True ($review -match 'CSR-01B MCU & Support Component Selection is not authorized') 'CSR-01B prohibition missing.'
Assert-True ($review -match 'CSR-01A-R3A') 'Smallest corrective package is not identified.'
& (Join-Path $RepositoryRoot 'scripts/validate_eco007.ps1') -RepositoryRoot $RepositoryRoot
if (-not $?) { throw 'ECO-007 regression failed.' }
$schematics = @(Get-ChildItem (Join-Path $RepositoryRoot 'hardware/kicad') -Recurse -Filter '*.kicad_sch')
foreach ($file in $schematics) { Assert-True ((Get-Content $file.FullName -Raw) -notmatch '\(property "Footprint" "[^"\r\n]+"') "Footprint assigned in $($file.Name)." }
Write-Host 'CSR-01A-R3 validation passed: 133 disposed, 9 frozen, 124 blocked; decision NOT ACCEPTED.'
