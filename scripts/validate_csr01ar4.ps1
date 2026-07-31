[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$review=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/CSR-01A-R4_Power_Component_Selection.md') -Raw
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv') -Encoding UTF8)
$power=@($ebom|Where-Object {$_.'Selection Scope' -eq 'CSR-01A POWER'})
$frozen=@($power|Where-Object {$_.'Freeze Status' -eq 'FROZEN'});$blocked=@($power|Where-Object {$_.'Freeze Status' -eq 'BLOCKED'})
Assert-True ($ebom.Count -eq 310 -and $power.Count -eq 133) 'Inventory population mismatch.'
Assert-True ($frozen.Count -eq 9 -and $blocked.Count -eq 124) 'R4 disposition count mismatch.'
Assert-True (@($power|Where-Object {$_.'Freeze Status' -notin @('FROZEN','CONDITIONAL','BLOCKED','NOT APPLICABLE')}).Count -eq 0) 'Unsupported power disposition.'
$required=@('Manufacturer Part Number','Requirement Trace Reference','Selection Rationale','Lifecycle Status','Preferred Vendor','Second Source','Unit Cost 1','Unit Cost 10','Unit Cost 100','Unit Cost 1000')
foreach($row in $frozen){foreach($field in $required){Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "$($row.Reference) frozen evidence missing $field."};Assert-True ($row.'Manufacturer Part Number' -notmatch 'BLOCKED|UNRESOLVED') "$($row.Reference) lacks exact MPN."}
foreach($row in $blocked){Assert-True ($row.Risk -match 'INCOMPLETE|UNRESOLVED|MISSING|INCONSISTENT|UNAVAILABLE') "$($row.Reference) lacks blocker."}
$avlMap=@{};foreach($row in $avl){$avlMap[$row.Item]=$row};foreach($row in $ebom){Assert-True $avlMap.ContainsKey($row.Item) "AVL missing $($row.Item).";Assert-True ($avlMap[$row.Item].'Freeze Status' -eq $row.'Freeze Status') "AVL status mismatch $($row.Item)."}
$s02=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/02_Power_Conversion.kicad_sch') -Raw
foreach($ref in @('R222','R223','R224')){Assert-True ($s02 -match "(?s)Reference`" `"$ref`".*?Value`" `"141 k") "$ref is not 141 kOhm."}
Assert-True ($s02 -notmatch 'TPS2553-Q1.*150 k') 'Obsolete TPS2553 150 kOhm annotation remains.'
foreach($token in @('64.9 kΩ','TLV841S','162.82–222.35 mA','PPQ-02','JCS-01','PPC-01','PAS-01')){Assert-True (($review+$s02).Contains($token)) "R4 evidence token missing: $token"}
Assert-True ([regex]::Matches($review,'(?m)^# CSR-01A-R4 (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'R4 must have exactly one decision.'
Assert-True ($review -match '(?m)^# CSR-01A-R4 NOT ACCEPTED$') 'R4 decision mismatch.'
Assert-True ($review -match 'CSR-01B.*not authorized') 'CSR-01B gate missing.'
$changed=git -C $RepositoryRoot diff --name-only f0d6c47
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/adr/|docs/icd/') "Prohibited R4 change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_eco008r.ps1') -RepositoryRoot $RepositoryRoot;if(-not $?){throw 'ECO-008R regression failed.'}
Write-Host 'CSR-01A-R4 validation passed: 133 power rows; 9 frozen; 124 blocked; decision NOT ACCEPTED.'
