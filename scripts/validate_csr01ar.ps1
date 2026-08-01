[CmdletBinding()]
param([string]$RepositoryRoot)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

$bomDirectory = Join-Path $RepositoryRoot 'docs\bom'
$ebomPath = Join-Path $bomDirectory 'IPC100_RevA_EBOM.csv'
$avlPath = Join-Path $bomDirectory 'Approved_Vendor_List.csv'
$ebom = @(Import-Csv -LiteralPath $ebomPath)
$avl = @(Import-Csv -LiteralPath $avlPath)

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

Assert-True ($ebom.Count -eq 313) "Expected 313 EBOM rows after ECO-010; found $($ebom.Count)."
Assert-True ($avl.Count -eq 313) "Expected 313 AVL rows after ECO-010; found $($avl.Count)."

$power = @($ebom | Where-Object { $_.'Selection Scope' -eq 'CSR-01A POWER' })
$outside = @($ebom | Where-Object { $_.'Selection Scope' -eq 'OUTSIDE CSR-01A' })
$frozen = @($power | Where-Object { $_.'Freeze Status' -eq 'FROZEN' })
$blocked = @($power | Where-Object { $_.'Freeze Status' -eq 'BLOCKED' })

Assert-True ($power.Count -eq 136) "Expected 136 power-scope rows after ECO-010; found $($power.Count)."
Assert-True ($outside.Count -eq 177) "Expected 177 out-of-scope rows; found $($outside.Count)."
Assert-True ($frozen.Count -eq 9) "Expected nine CSR-01A-R frozen rows; found $($frozen.Count)."
Assert-True ($blocked.Count -eq 127) "Expected 127 blocked power rows after ECO-010; found $($blocked.Count)."
Assert-True (@($outside | Where-Object { $_.'Freeze Status' -ne 'NOT YET FROZEN' }).Count -eq 0) 'Every out-of-scope row must be NOT YET FROZEN.'
Assert-True (@($ebom | Group-Object Reference | Where-Object Count -gt 1).Count -eq 0) 'EBOM references are not globally unique.'

$allowed = @('FROZEN', 'CONDITIONAL', 'BLOCKED', 'NOT YET FROZEN')
Assert-True (@($ebom | Where-Object { $_.'Freeze Status' -notin $allowed }).Count -eq 0) 'An EBOM row has an unsupported freeze status.'

$requiredFrozenFields = @(
    'Manufacturer', 'Manufacturer Part Number', 'Package', 'Operating Voltage',
    'Temperature Range', 'Lifecycle Status', 'RoHS Status', 'Availability',
    'Preferred Vendor', 'Preferred Vendor Ordering Code', 'Second Source',
    'Selection Rationale', 'Unit Cost 1', 'Unit Cost 10', 'Unit Cost 100',
    'Unit Cost 1000', 'Currency', 'Price Date', 'Requirement Trace Reference',
    'Sourcing Risk', 'Approved Alternate', 'Approved Alternate Vendor Code',
    'Datasheet URL', 'Datasheet Revision or Date'
)
foreach ($row in $frozen) {
    foreach ($field in $requiredFrozenFields) {
        Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "Frozen row $($row.Item) is missing $field."
    }
    Assert-True ($row.'Manufacturer Part Number' -notmatch 'BLOCKED|UNRESOLVED|TBD') "Frozen row $($row.Item) has a placeholder MPN."
}

foreach ($row in $blocked) {
    Assert-True ($row.Risk -match 'INCOMPLETE|INCONSISTENT|UNRESOLVED|MISSING|UNAVAILABLE|PAS-01R: BLOCKED|ECO-009') "Blocked row $($row.Item) lacks a specific blocker category."
}

$avlByItem = @{}
foreach ($row in $avl) { $avlByItem[$row.Item] = $row }
foreach ($row in $ebom) {
    Assert-True ($avlByItem.ContainsKey($row.Item)) "AVL is missing $($row.Item)."
    Assert-True ($avlByItem[$row.Item].'Manufacturer Part Number' -eq $row.'Manufacturer Part Number') "AVL MPN mismatch for $($row.Item)."
    Assert-True ($avlByItem[$row.Item].'Freeze Status' -eq $row.'Freeze Status') "AVL status mismatch for $($row.Item)."
}

Write-Host 'CSR-01A-R BOM/AVL validation passed.'
Write-Host "EBOM/AVL rows: $($ebom.Count)"
Write-Host "Power scope: $($power.Count); frozen: $($frozen.Count); blocked: $($blocked.Count)"
Write-Host "Outside scope: $($outside.Count) NOT YET FROZEN"
