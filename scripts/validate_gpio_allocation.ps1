[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$allocationFile = Join-Path $repositoryRoot 'docs/connectors/ESP32_GPIO_Allocation_Table.md'
$content = Get-Content -LiteralPath $allocationFile
$errors = [System.Collections.Generic.List[string]]::new()

$rows = foreach ($line in $content) {
    if ($line -match '^\| \d+ \|') {
        $columns = $line.Split('|')
        $gpio = [int]$columns[1].Trim()
        $assignmentCell = $columns[2].Trim()
        $functionalName = if ($assignmentCell -match '^`(?<name>[^`]+)`') {
            $Matches.name
        } else {
            $assignmentCell
        }
        [pscustomobject]@{
            GPIO = $gpio
            Assignment = $functionalName
        }
    }
}

$expected = @(0..21) + @(35..48)
$actual = @($rows.GPIO)

foreach ($group in $rows | Group-Object GPIO | Where-Object Count -ne 1) {
    $errors.Add("GPIO$($group.Name) appears $($group.Count) times.")
}
foreach ($gpio in $expected) {
    if ($gpio -notin $actual) {
        $errors.Add("GPIO$gpio is missing.")
    }
}
foreach ($gpio in $actual) {
    if ($gpio -notin $expected) {
        $errors.Add("GPIO$gpio is not brought out by the selected module family.")
    }
}

$required = @{
    35 = 'OLED_POWER_REQ'
    36 = 'SENSOR_POWER_REQ'
    40 = 'UI_POWER_REQ'
    41 = 'EXPANSION_POWER_REQ'
    19 = 'USB_D-'
    20 = 'USB_D+'
    43 = 'UART0_TX'
    44 = 'UART0_RX'
    42 = 'WATCHDOG_SERVICE_MCU'
}
foreach ($entry in $required.GetEnumerator()) {
    $row = $rows | Where-Object GPIO -eq $entry.Key
    if ($row.Assignment -ne $entry.Value) {
        $errors.Add("GPIO$($entry.Key) must be $($entry.Value), found '$($row.Assignment)'.")
    }
}

foreach ($gpio in 3, 45, 46) {
    $row = $rows | Where-Object GPIO -eq $gpio
    if ($row.Assignment -notmatch '^Unused') {
        $errors.Add("Strapping GPIO$gpio must remain unused.")
    }
}

$reserved = @{ 37 = 'FUTURE_COMM_GPIO_A' }
foreach ($entry in $reserved.GetEnumerator()) {
    $row = $rows | Where-Object GPIO -eq $entry.Key
    if ($row.Assignment -ne $entry.Value) {
        $errors.Add("Reserved GPIO$($entry.Key) must remain $($entry.Value), found '$($row.Assignment)'.")
    }
}
if ($rows.Assignment -contains 'MAIN_POWER_GOOD') {
    $errors.Add('ADR-041 prohibits an ESP32 GPIO assignment for MAIN_POWER_GOOD.')
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'IPC-100 ESP32 GPIO allocation validation passed.'
Write-Host "Inventory rows: $($rows.Count)"
Write-Host 'Duplicate GPIOs: 0'
Write-Host 'Missing GPIOs: 0'
Write-Host 'ADR-039 requests: assigned'
Write-Host 'Native USB and UART0 recovery: preserved'
Write-Host 'Application straps GPIO3/45/46: unused'
Write-Host 'ADR-044 watchdog service GPIO42: assigned'
Write-Host 'Future reserve GPIO37: preserved'
Write-Host 'MAIN_POWER_GOOD GPIO assignment: none (ADR-041)'
