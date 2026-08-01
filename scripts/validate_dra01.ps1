[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }

$rows = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') | Where-Object { $_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'BLOCKED' -and $_.Reference -notin @('C805','R807','R809') })
$assignments = [System.Collections.Generic.List[object]]::new()
foreach ($row in $rows) {
  $causes = [System.Collections.Generic.List[string]]::new()
  if ($row.Risk -match '^PAS-01R: BLOCKED' -and $row.Reference -in @('C102','C103','C104','C109','L101','C202','C205','C210','L201','L202','R808')) { $causes.Add('RC-B') }
  if ($row.Risk -match '^PAS-01R: BLOCKED' -and $row.Reference -in @('C201','C203','C204','C206','C208','C209','C305')) { $causes.Add('RC-C') }
  if ($row.Risk -match '^ECO-009' -and $row.Reference -eq 'C305') { $causes.Add('RC-C') }
  if ($row.Risk -notmatch '^PAS-01R: BLOCKED|^ECO-009' -and $row.Risk -match '^TRANSIENT COORDINATION') { $causes.Add('RC-A') }
  if ($row.Risk -notmatch '^PAS-01R: BLOCKED|^ECO-009' -and $row.Risk -match 'THERMAL/STABILITY|ECO-006|ECO-010|exact suffix|ECO-007|ECO-008R|saturation|TCA9517A') { $causes.Add('RC-B') }
  if ($row.Risk -notmatch '^PAS-01R: BLOCKED|^ECO-009' -and $row.Risk -match 'exact dielectric|device equation') { $causes.Add('RC-C') }
  if ($row.Reference -eq 'J1') { $causes.Add('RC-D') }
  Assert-True ($causes.Count -eq 1) "$($row.Item) maps to $($causes.Count) root causes."
  $assignments.Add([pscustomobject]@{ Item=$row.Item; Reference=$row.Reference; Cause=$causes[0] })
}
Assert-True ($rows.Count -eq 124) "Expected 124 blocked power rows; found $($rows.Count)."
$expected = @{ 'RC-A'=19; 'RC-B'=37; 'RC-C'=67; 'RC-D'=1 }
foreach ($cause in $expected.Keys) {
  $count = @($assignments | Where-Object Cause -eq $cause).Count
  Assert-True ($count -eq $expected[$cause]) "$cause expected $($expected[$cause]); found $count."
}
Assert-True (@($assignments | Group-Object Item | Where-Object Count -ne 1).Count -eq 0) 'A blocked item is duplicated or omitted.'

$review = Get-Content (Join-Path $RepositoryRoot 'docs/reviews/DRA-01_Design_Readiness_Assessment.md') -Raw
Assert-True ([regex]::Matches($review, '(?m)^# DRA-01 (?:COMPLETE|INCOMPLETE)$').Count -eq 1) 'DRA-01 must contain exactly one final decision.'
Assert-True ($review -match '(?m)^# DRA-01 COMPLETE$') 'DRA-01 final decision is not COMPLETE.'
foreach ($token in @('RC-A','RC-B','RC-C','RC-D','19 + 37 + 67 + 1 = 124','PEB-01','PPQ-01','JCS-01','Engineering Maturity Matrix','Dependency Graph')) { Assert-True ($review.Contains($token)) "DRA-01 missing $token." }
Assert-True ($review -match 'Recommended next corrective package: \*\*PEB-01') 'Next corrective package is not explicit.'
Write-Host 'DRA-01 validation passed: 124 blocked rows map exactly once to 19/37/67/1 root-cause groups.'
