[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$icdPath = Join-Path $repoRoot "docs/icd/ICD-002_External_Connector_Harness_Service_Interface.md"
$sheetPath = Join-Path $repoRoot "hardware/kicad/sheets/09_Connectors_Test.kicad_sch"

if (-not (Test-Path -LiteralPath $icdPath)) { throw "Missing ICD-002: $icdPath" }
if (-not (Test-Path -LiteralPath $sheetPath)) { throw "Missing Sheet 09: $sheetPath" }

$icd = Get-Content -LiteralPath $icdPath -Raw -Encoding UTF8
$sheet = Get-Content -LiteralPath $sheetPath -Raw -Encoding UTF8
$ports = [regex]::Matches($sheet, '\(hierarchical_label\s+"([^"]+)"') |
    ForEach-Object { $_.Groups[1].Value } |
    Sort-Object -Unique

if ($ports.Count -ne 58) {
    throw "Expected 58 unique Sheet 09 hierarchical labels (54 frozen plus four ECO-003 exposures); found $($ports.Count)."
}
$missingPorts = @($ports | Where-Object { $icd -notmatch [regex]::Escape($_) })
if ($missingPorts.Count -gt 0) {
    throw "ICD-002 omits Sheet 09 ports: $($missingPorts -join ', ')"
}

$requiredPatterns = @(
    "SPLIT SAFETY AND UI CONNECTORS REQUIRED",
    "J13 ROLE . USB 2\.0 DEVICE/UFP, SERVICE POWER AND DATA",
    "ICD-002 ACCEPTED . PACKAGE 10R AUTHORIZED",
    "GPIO37 remains reserved and unconsumed",
    'GPIO42 remains assigned only to `WATCHDOG_SERVICE_MCU`',
    "ECO-003",
    "J6_I2C_SDA",
    "J6_I2C_SCL",
    "J7_I2C_SDA",
    "J7_I2C_SCL",
    "ICD-001"
)
foreach ($pattern in $requiredPatterns) {
    if ($icd -notmatch $pattern) { throw "ICD-002 is missing required pattern: $pattern" }
}

foreach ($designation in 1..10) {
    $inventoryPattern = if ($designation -eq 8) {
        '(?m)^\| J8A(?:\s|\|).*(?:\r?\n)^\| J8B(?:\s|\|)'
    } else {
        "(?m)^\| J$designation(?:\s|\|)"
    }
    if ($icd -notmatch $inventoryPattern) {
        throw "ICD-002 connector inventory omits J$designation."
    }
}
if ($icd -notmatch '(?m)^\| J13(?:\s|\|)') {
    throw "ICD-002 connector inventory omits J13."
}
foreach ($designation in @("J11", "J12")) {
    if ($icd -notmatch "(?m)^\| $designation .*\| Documentation-only; no Rev A symbol/pads \|") {
        throw "$designation is not explicitly documentation-only with no Rev A symbol/pads."
    }
}

$decisionPattern = "ICD-002 ACCEPTED . PACKAGE 10R AUTHORIZED"
$decisionCount = ([regex]::Matches($icd, $decisionPattern)).Count
if ($decisionCount -ne 1) {
    throw "Expected exactly one ICD-002 final decision; found $decisionCount."
}
if ($icd -match 'ICD-002 (?:PARTIALLY ACCEPTED|NOT ACCEPTED)') {
    throw "ICD-002 contains a conflicting final decision."
}

Write-Host "ICD-002 validation passed: 54 frozen Sheet 09 ports plus four ECO-003 exposures, 11 connector designations, frozen GPIO constraints, and one final decision."
