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

Assert-True ($power.Count -eq 130) "Expected 130 power rows; found $($power.Count)."
Assert-True ($frozen.Count -eq 9) "Expected nine frozen rows; found $($frozen.Count)."
Assert-True ($blocked.Count -eq 121) "Expected 121 blocked rows; found $($blocked.Count)."
Assert-True (@($power | Where-Object { $_.'Freeze Status' -notin @('FROZEN','BLOCKED','NOT APPLICABLE') }).Count -eq 0) 'A power row lacks an allowed final disposition.'
Assert-True (@($power | Where-Object { $_.'Freeze Status' -eq 'NOT YET FROZEN' }).Count -eq 0) 'A power row remains NOT YET FROZEN.'

foreach ($row in $frozen) {
    foreach ($field in @('Manufacturer','Manufacturer Part Number','Lifecycle Status','Preferred Vendor','Alternate Vendor','Unit Cost 1','Risk','Datasheet URL','Requirement Trace Reference')) {
        Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "Frozen $($row.Item) lacks $field."
    }
}
foreach ($row in $blocked) { Assert-True ($row.Risk -match 'INCOMPLETE|INCONSISTENT|UNRESOLVED|MISSING|UNAVAILABLE') "Blocked $($row.Item) lacks a specific blocker." }

$byItem = @{}; foreach ($row in $avl) { $byItem[$row.Item] = $row }
foreach ($row in $power) { Assert-True ($byItem.ContainsKey($row.Item)) "AVL lacks $($row.Item)." }

$u201 = $power | Where-Object Reference -eq 'U201'
$r201 = $power | Where-Object Reference -eq 'R201'
$ilim = @($power | Where-Object Reference -in @('U209','U212','U213','R222','R223','R224'))
$u801 = $power | Where-Object Reference -eq 'U801'
Assert-True ($u201.Risk -match '64\.9' -and $r201.Risk -match '40\.2') 'U201/R201 frequency blocker is not captured.'
Assert-True (@($ilim | Where-Object { $_.Risk -match '15\.\.232' }).Count -eq 6) 'TPS2553 RILIM blocker is not captured on all six rows.'
Assert-True ($u801.Risk -match '2\.9 V' -and $u801.Risk -match '2\.7 V') 'U801 threshold blocker is not captured.'

$review = Get-Content (Join-Path $RepositoryRoot 'docs/reviews/CSR-01A-R2_Final_Power_Component_Freeze.md') -Raw
Assert-True ([regex]::Matches($review, '(?m)^# CSR-01A-R2 (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'Review must contain exactly one final decision.'
Assert-True ($review -match '(?m)^# CSR-01A-R2 NOT ACCEPTED$') 'Review decision must be NOT ACCEPTED while critical blockers remain.'
Assert-True ($review -match 'CSR-01B MCU & Support Component Selection is not authorized') 'CSR-01B prohibition missing.'

Write-Host 'CSR-01A-R2 final power-freeze validation passed: 130 disposed, 9 frozen, 121 blocked.'
