[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $RepositoryRoot 'docs\bom'
}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

function Get-Category {
    param([string]$Lib, [string]$Reference, [string]$Value)
    if ($Reference -like 'J*') { return 'Connectors' }
    if ($Reference -like 'TP*' -or $Reference -like 'DFT*') { return 'Test' }
    if ($Reference -like 'R*' -or $Reference -like 'C*' -or $Reference -like 'L*' -or $Reference -like 'FB*') { return 'Passives' }
    if ($Reference -like 'K*') { return 'Relays' }
    if ($Reference -like 'Q*') { return 'MOSFETs' }
    if ($Reference -like 'D*' -or $Reference -like 'F*') { return 'Protection' }
    if ($Reference -like 'SW*') { return 'User Interface' }
    if ($Value -match 'ESP32') { return 'ESP32' }
    if ($Value -match 'USB|CC1|CC2') { return 'USB' }
    if ($Value -match 'watchdog') { return 'Watchdog' }
    if ($Value -match 'OLED|SSD1309') { return 'Displays' }
    if ($Value -match 'BME280|sensor') { return 'Sensors' }
    if ($Value -match 'I2C|TCA9535|branch|segment') { return 'I2C' }
    if ($Value -match 'LMR|TPS2|buck|mux|load switch|rail') { return 'Power' }
    if ($Value -match 'LM339|STOP|safety|FIELD') { return 'Safety' }
    if ($Reference -like 'U*') { return 'Logic' }
    return 'Other'
}

function Test-PowerScope {
    param([string]$Sheet, [string]$Reference)
    switch ($Sheet) {
        '01_Power_Entry' { return $true }
        '02_Power_Conversion' { return $true }
        '03_ESP32_Core' { return $Reference -in @('C305', 'C306', 'U302') }
        '07_UI_Peripherals' { return $Reference -in @('U706', 'U707') }
        '08_Expansion' { return $Reference -in @('C802', 'D803', 'FB801', 'R801', 'U801') }
        '09_Connectors_Test' { return $Reference -in @('D902', 'J1') }
        default { return $false }
    }
}

$schematicFiles = @(
    (Join-Path $RepositoryRoot 'hardware\kicad\IPC-100.kicad_sch')
) + @(
    Get-ChildItem (Join-Path $RepositoryRoot 'hardware\kicad\sheets') -Filter '*.kicad_sch' |
        Sort-Object Name |
        ForEach-Object FullName
)

$rows = [System.Collections.Generic.List[object]]::new()
foreach ($file in $schematicFiles) {
    $content = [IO.File]::ReadAllText($file, [Text.Encoding]::UTF8)
    $matches = [regex]::Matches(
        $content,
        '(?s)\(symbol \(lib_id "([^"]+)"\).*?\(property "Reference" "([^"]+)".*?\(property "Value" "([^"]+)".*?\(instances '
    )
    foreach ($match in $matches) {
        $reference = $match.Groups[2].Value
        if ($reference -like '#PWR*') { continue }
        $sheet = [IO.Path]::GetFileNameWithoutExtension($file)
        $value = $match.Groups[3].Value
        $lib = $match.Groups[1].Value
        $category = Get-Category -Lib $lib -Reference $reference -Value $value
        $isPowerScope = Test-PowerScope -Sheet $sheet -Reference $reference
        $pendingLabel = if ($isPowerScope) { 'UNRESOLVED - CSR-01A BLOCKED' } else { 'NOT YET FROZEN' }
        $freezeStatus = if ($isPowerScope) { 'BLOCKED - CSR-01A' } else { 'NOT YET FROZEN' }
        $rows.Add([pscustomobject][ordered]@{
            'Item' = "$sheet/$reference"
            'Sheet' = $sheet
            'Reference' = $reference
            'Category' = $category
            'Selection Scope' = if ($isPowerScope) { 'CSR-01A POWER' } else { 'OUTSIDE CSR-01A' }
            'Function' = $value
            'Electrical Role' = $lib
            'Quantity' = 1
            'Manufacturer' = $pendingLabel
            'Manufacturer Part Number' = $pendingLabel
            'Description' = $value
            'Value' = $value
            'Package' = $pendingLabel
            'Mounting Style' = $pendingLabel
            'Operating Voltage' = 'Requires exact-part review'
            'Maximum Current' = 'Requires exact-part review'
            'Rating or Tolerance' = 'As captured where stated; package/derating unresolved'
            'Temperature Range' = $pendingLabel
            'Lifecycle Status' = if ($isPowerScope) { 'NOT REVIEWED - BLOCKED' } else { 'NOT YET FROZEN' }
            'RoHS Status' = if ($isPowerScope) { 'NOT REVIEWED - BLOCKED' } else { 'NOT YET FROZEN' }
            'Availability' = if ($isPowerScope) { 'NOT REVIEWED - BLOCKED' } else { 'NOT YET FROZEN' }
            'Preferred Vendor' = $pendingLabel
            'Alternate Vendor' = $pendingLabel
            'Second Source' = $pendingLabel
            'Selection Rationale' = if ($isPowerScope) { 'CSR-01A power selection blocked by unresolved quantitative electrical, thermal, transient, connector, or composite-device prerequisites.' } else { 'Outside CSR-01A; explicitly not yet frozen.' }
            'Criticality' = if ($category -in @('Power','Protection','ESP32','Relays','Logic','Watchdog','Safety','Connectors')) { 'Major' } else { 'Normal' }
            'Unit Cost 1' = ''
            'Unit Cost 100' = ''
            'Unit Cost 1000' = ''
            'Currency' = ''
            'Freeze Status' = $freezeStatus
            'Risk' = if ($isPowerScope) { 'Do not source or assign a footprint; CSR-01A did not freeze this power item.' } else { 'Outside current package; do not source or assign a footprint.' }
            'Approved Alternate' = ''
            'Do Not Substitute' = 'YES'
            'Datasheet URL' = ''
            'Hardware Revision' = 'Rev A'
            'Notes' = if ($isPowerScope) { 'Power-scope inventory only. CSR-01A did not freeze this item.' } else { 'NOT YET FROZEN; excluded from CSR-01A.' }
        })
    }
}

$ebomPath = Join-Path $OutputDirectory 'IPC100_RevA_EBOM.csv'
$rows |
    Sort-Object Sheet, Reference |
    Export-Csv -LiteralPath $ebomPath -NoTypeInformation -Encoding UTF8

$duplicateReferences = $rows |
    Group-Object Reference |
    Where-Object Count -gt 1 |
    Sort-Object Name
$powerRows = @($rows | Where-Object { $_.'Selection Scope' -eq 'CSR-01A POWER' })
$frozenPowerRows = @($powerRows | Where-Object { $_.'Freeze Status' -eq 'FROZEN' })

$summaryPath = Join-Path $OutputDirectory 'CSR-01_Inventory_Summary.csv'
@(
    [pscustomobject]@{ Metric = 'Schematic BOM rows'; Value = $rows.Count; Status = 'INVENTORIED' }
    [pscustomobject]@{ Metric = 'Rows with frozen MPN'; Value = 0; Status = 'BLOCKED' }
    [pscustomobject]@{ Metric = 'Rows without frozen MPN'; Value = $rows.Count; Status = 'BLOCKED' }
    [pscustomobject]@{ Metric = 'Repeated local reference names'; Value = $duplicateReferences.Count; Status = if ($duplicateReferences.Count -eq 0) { 'NORMALIZED BY ECO-005' } else { 'REQUIRES PROJECT-WIDE ANNOTATION AUDIT' } }
    [pscustomobject]@{ Metric = 'CSR-01A power-scope rows'; Value = $powerRows.Count; Status = 'INVENTORIED' }
    [pscustomobject]@{ Metric = 'CSR-01A frozen power rows'; Value = $frozenPowerRows.Count; Status = if ($frozenPowerRows.Count -eq $powerRows.Count) { 'COMPLETE' } else { 'BLOCKED' } }
    [pscustomobject]@{ Metric = 'Rows outside CSR-01A'; Value = $rows.Count - $powerRows.Count; Status = 'NOT YET FROZEN' }
) | Export-Csv -LiteralPath $summaryPath -NoTypeInformation -Encoding UTF8

$avlRows = foreach ($row in $rows | Sort-Object Category, Sheet, Reference) {
    [pscustomobject][ordered]@{
        'Item' = $row.Item
        'Category' = $row.Category
        'Selection Scope' = $row.'Selection Scope'
        'Manufacturer' = $row.Manufacturer
        'Manufacturer Part Number' = $row.'Manufacturer Part Number'
        'Preferred Distributor' = $row.'Preferred Vendor'
        'Alternate Distributor' = $row.'Alternate Vendor'
        'Lifecycle' = $row.'Lifecycle Status'
        'Stock Status' = $row.Availability
        'RoHS' = $row.'RoHS Status'
        'Second Source' = $row.'Second Source'
        'Risk' = $row.Risk
        'Review Date' = '2026-07-31'
    }
}
$avlRows | Export-Csv -LiteralPath (Join-Path $OutputDirectory 'Approved_Vendor_List.csv') -NoTypeInformation -Encoding UTF8

Write-Host "CSR-01 inventory generated: $($rows.Count) physical/logical schematic items."
Write-Host "Repeated local reference names: $($duplicateReferences.Count)"
