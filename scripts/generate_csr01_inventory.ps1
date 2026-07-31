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
        $rows.Add([pscustomobject][ordered]@{
            'Item' = "$sheet/$reference"
            'Sheet' = $sheet
            'Reference' = $reference
            'Category' = $category
            'Function' = $value
            'Electrical Role' = $lib
            'Quantity' = 1
            'Manufacturer' = 'UNRESOLVED'
            'Manufacturer Part Number' = 'UNRESOLVED - CSR-01 BLOCKED'
            'Description' = $value
            'Value' = $value
            'Package' = 'UNRESOLVED'
            'Mounting Style' = 'UNRESOLVED'
            'Operating Voltage' = 'Requires exact-part review'
            'Maximum Current' = 'Requires exact-part review'
            'Rating or Tolerance' = 'As captured where stated; package/derating unresolved'
            'Temperature Range' = 'UNRESOLVED'
            'Lifecycle Status' = 'NOT REVIEWED'
            'RoHS Status' = 'NOT REVIEWED'
            'Availability' = 'NOT REVIEWED'
            'Preferred Vendor' = 'UNRESOLVED'
            'Alternate Vendor' = 'UNRESOLVED'
            'Second Source' = 'UNRESOLVED'
            'Selection Rationale' = 'No frozen MPN; prerequisite electrical/mechanical contract or exact-device audit remains open.'
            'Criticality' = if ($category -in @('Power','Protection','ESP32','Relays','Logic','Watchdog','Safety','Connectors')) { 'Major' } else { 'Normal' }
            'Unit Cost 1' = ''
            'Unit Cost 100' = ''
            'Unit Cost 1000' = ''
            'Currency' = ''
            'Freeze Status' = 'BLOCKED'
            'Risk' = 'Do not source or assign a footprint from this row.'
            'Approved Alternate' = ''
            'Do Not Substitute' = 'YES'
            'Datasheet URL' = ''
            'Hardware Revision' = 'Rev A'
            'Notes' = 'As-captured inventory only. CSR-01 did not freeze this item.'
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

$summaryPath = Join-Path $OutputDirectory 'CSR-01_Inventory_Summary.csv'
@(
    [pscustomobject]@{ Metric = 'Schematic BOM rows'; Value = $rows.Count; Status = 'INVENTORIED' }
    [pscustomobject]@{ Metric = 'Rows with frozen MPN'; Value = 0; Status = 'BLOCKED' }
    [pscustomobject]@{ Metric = 'Rows without frozen MPN'; Value = $rows.Count; Status = 'BLOCKED' }
    [pscustomobject]@{ Metric = 'Repeated local reference names'; Value = $duplicateReferences.Count; Status = if ($duplicateReferences.Count -eq 0) { 'NORMALIZED BY ECO-005' } else { 'REQUIRES PROJECT-WIDE ANNOTATION AUDIT' } }
) | Export-Csv -LiteralPath $summaryPath -NoTypeInformation -Encoding UTF8

$avlRows = foreach ($row in $rows | Sort-Object Category, Sheet, Reference) {
    [pscustomobject][ordered]@{
        'Item' = $row.Item
        'Category' = $row.Category
        'Manufacturer' = 'UNRESOLVED'
        'Manufacturer Part Number' = 'UNRESOLVED - CSR-01 BLOCKED'
        'Preferred Distributor' = 'UNRESOLVED'
        'Alternate Distributor' = 'UNRESOLVED'
        'Lifecycle' = 'NOT REVIEWED'
        'Stock Status' = 'NOT REVIEWED'
        'RoHS' = 'NOT REVIEWED'
        'Second Source' = 'UNRESOLVED'
        'Risk' = 'BLOCKED - no approved vendor item'
        'Review Date' = '2026-07-30'
    }
}
$avlRows | Export-Csv -LiteralPath (Join-Path $OutputDirectory 'Approved_Vendor_List.csv') -NoTypeInformation -Encoding UTF8

Write-Host "CSR-01 inventory generated: $($rows.Count) physical/logical schematic items."
Write-Host "Repeated local reference names: $($duplicateReferences.Count)"
