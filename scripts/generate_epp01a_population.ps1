$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root 'docs/bom/IPC100_RevA_EBOM.csv'
$output = Join-Path $root 'docs/bom/IPC100_RevA_Prototype_Population.csv'
$rows = Import-Csv $source

function Get-Stage([string]$sheet, [string]$reference, [string]$function) {
    if ($sheet -like '01_*') { return 'Stage B - power-entry population' }
    if ($sheet -like '02_*') { return 'Stage C - core 3.3 V and MCU population' }
    if ($sheet -like '03_*') {
        if ($reference -in @('U303') -or $function -match 'USB') { return 'Stage D - USB and programming' }
        return 'Stage C - core 3.3 V and MCU population'
    }
    if ($sheet -like '04_*') { return 'Stage F - safety and watchdog' }
    if ($sheet -like '05_*') { return 'Stage G - relay and motion outputs' }
    if ($sheet -like '06_*') { return 'Stage G - relay and motion outputs' }
    if ($sheet -like '07_*') { return 'Stage E - UI and sensor branches' }
    if ($sheet -like '08_*') { return 'Stage H - optional expansion' }
    if ($reference -eq 'J13' -or $function -match 'USB') { return 'Stage D - USB and programming' }
    if ($reference -in @('J2','J3','J9')) { return 'Stage G - relay and motion outputs' }
    if ($reference -in @('J4','J5','J8A')) { return 'Stage F - safety and watchdog' }
    if ($reference -in @('J6','J7','J8B')) { return 'Stage E - UI and sensor branches' }
    if ($reference -eq 'J10') { return 'Stage H - optional expansion' }
    return 'Stage A - bare-board inspection'
}

$population = foreach ($row in $rows) {
    $isDnp = $row.Function -match '(?i)\bDNP\b' -or $row.Value -match '(?i)\bDNP\b'
    $isLogical = $row.Reference -in @('DFT1','U704','U705')
    $isTestPad = $row.Reference -match '^TP'
    $status = if ($isLogical) {
        'DOCUMENTATION ONLY'
    } elseif ($isDnp) {
        'DNP - DEFAULT'
    } elseif ($isTestPad) {
        'DNP - DEBUG OPTION'
    } elseif ($row.'Freeze Status' -eq 'FROZEN') {
        'POPULATE - REQUIRED'
    } else {
        'BLOCKED - PHYSICAL DEFINITION REQUIRED'
    }

    $reason = switch ($status) {
        'DOCUMENTATION ONLY' { 'Logical or external-module boundary; no board component may be inferred.' }
        'DNP - DEFAULT' { 'Released optional/DNP function; retain unpopulated unless a controlled prototype test requires it.' }
        'DNP - DEBUG OPTION' { 'Prototype test-access provision; physical pad definition remains part of the test-access ECO/footprint package.' }
        'POPULATE - REQUIRED' { 'Current EBOM row is FROZEN and required by the released electrical implementation.' }
        default { 'Exact one-to-one device, package, pin map, or prototype-rated physical definition is not released.' }
    }

    $requiredPower = if ($row.Sheet -like '01_*' -or $row.Sheet -like '02_*' -or $row.Reference -in @('U301','U302')) { 'YES' } else { 'NO' }
    $requiredFunctional = if ($status -eq 'DOCUMENTATION ONLY' -or $status -like 'DNP*') { 'NO' } else { 'YES' }
    $requiredSafety = if ($row.Sheet -like '04_*' -or $row.Sheet -like '05_*' -or $row.Sheet -like '06_*' -or $row.Reference -in @('J4','J5','J8A')) { 'YES' } else { 'NO' }
    $requiredUsb = if ($row.Reference -in @('J13','U301','U303','R901','R902','D901','D902') -or $row.Function -match 'USB') { 'YES' } else { 'NO' }
    $requiredMotion = if ($row.Sheet -like '05_*' -or $row.Reference -in @('J2','J3')) { 'YES' } else { 'NO' }
    $requiredExpansion = if ($row.Sheet -like '08_*' -or $row.Reference -eq 'J10') { 'YES' } else { 'NO' }

    [pscustomobject][ordered]@{
        Reference = $row.Reference
        Sheet = $row.Sheet
        Function = $row.Function
        'Current EBOM Status' = $row.'Freeze Status'
        'Prototype Population Status' = $status
        Reason = $reason
        'Required For First Power-Up' = $requiredPower
        'Required For Functional Testing' = $requiredFunctional
        'Required For Safety Testing' = $requiredSafety
        'Required For USB Programming' = $requiredUsb
        'Required For Motion Testing' = $requiredMotion
        'Required For Expansion Testing' = $requiredExpansion
        'Installation Phase' = Get-Stage $row.Sheet $row.Reference $row.Function
    }
}

$population | Export-Csv -Path $output -NoTypeInformation -Encoding utf8
Write-Output "EPP-01A population generated: $($population.Count) rows."
$population | Group-Object 'Prototype Population Status' | Sort-Object Name | ForEach-Object {
    Write-Output "$($_.Name): $($_.Count)"
}
