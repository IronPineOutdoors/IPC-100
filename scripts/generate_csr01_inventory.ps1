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
        '07_UI_Peripherals' { return $Reference -in @('C702', 'C703', 'C704', 'C705', 'R704', 'R705', 'U706', 'U707') }
        '08_Expansion' { return $Reference -in @('C802', 'C804', 'D803', 'FB801', 'R801', 'R806', 'R808', 'U801') }
        '09_Connectors_Test' { return $Reference -in @('D902', 'J1') }
        default { return $false }
    }
}

function Test-Csr01ArFrozen100kResistor {
    param([string]$Sheet, [string]$Reference)
    return "$Sheet/$Reference" -in @(
        '02_Power_Conversion/R204',
        '02_Power_Conversion/R212',
        '02_Power_Conversion/R214',
        '02_Power_Conversion/R216',
        '02_Power_Conversion/R218',
        '02_Power_Conversion/R219',
        '02_Power_Conversion/R220',
        '02_Power_Conversion/R221',
        '08_Expansion/R801'
    )
}

function Get-Csr01ArBlocker {
    param([string]$Sheet, [string]$Reference, [string]$Category, [string]$Value)
    if ($Reference -eq 'C305') { return 'ECO-009: nominal corrected to 93.1 nF / 99.642 ms. BLOCKED - exact U302 suffix and accepted minimum/maximum reset-release window are required before worst-case freeze; calculated component/device envelope is approximately 79.1..136.6 ms.' }
    if ($Reference -in @('C102','C103','C104','C109','L101')) { return 'PAS-01R: BLOCKED - ACTIVE DEVICE SELECTION REQUIRED. Exact U101/PPC input-protection operating waveform and active order code must precede capacitor or input-filter magnetic curve qualification.' }
    if ($Reference -in @('C201','C202','C203','C204','C205','L201')) { return 'PAS-01R: BLOCKED - ACTIVE DEVICE SELECTION REQUIRED. Exact U201 LMR38020-Q1 suffix and WEBENCH/stability solution must precede output, bootstrap, timing, and magnetic selection.' }
    if ($Reference -in @('C206')) { return 'PAS-01R: BLOCKED - ACTIVE DEVICE SELECTION REQUIRED. Exact U202 power-mux and U203 core-regulator selections must precede transition-capacitance and source-change qualification.' }
    if ($Reference -in @('C208','C209','C210','L202')) { return 'PAS-01R: BLOCKED - ACTIVE DEVICE SELECTION REQUIRED. U203 remains a regulator class rather than a frozen MPN; its LC stability, soft-start equation, and inductor-current limits control these passives.' }
    if ($Reference -eq 'R808') { return 'PAS-01R: BLOCKED - ACTIVE DEVICE SELECTION REQUIRED. Exact U801 supervisor suffix, threshold, hysteresis, SENSE leakage, and delay tolerance control the 4.47 MOhm feedback resistor.' }
    if ($Reference -in @('R201', 'U201')) { return 'ANALYSIS INCOMPLETE - ECO-007 corrected the 400 kHz LMR38020F-Q1 RT/SYNC network to 64.9 kOhm; exact suffix, oscillator, loop, loss, thermal, lifecycle, sourcing, and cost evidence remain CSR-01A-R3 work.' }
    if ($Reference -in @('R222', 'R223', 'R224', 'U209', 'U212', 'U213')) { return 'ANALYSIS INCOMPLETE - ECO-008R implements a generic 141 kOhm +/-1%, <=100 ppm/degC RILIM with calculated 162.8..222.4 mA bounds under QER-02; exact MPN/suffix/package, thermal, reverse-current, lifecycle, sourcing, cost, and prototype evidence remain CSR-01A-R4 work.' }
    if ($Reference -in @('U801','C804','R806','R808')) { return 'ANALYSIS INCOMPLETE - ECO-007 physically implemented the fixed 2.7 V, 10 ms supervisor and external 2.930/2.680 V threshold network; exact suffix tolerance, leakage, package, lifecycle, sourcing, and cost evidence remain CSR-01A-R3 work.' }
    if ($Reference -in @('R201', 'U201')) { return 'SCHEMATIC VALUE INCONSISTENT — LMR38020-Q1 requires 64.9 kOhm nominal for 400 kHz; captured R201 is 40.2 kOhm, so the released frequency and exact regulator network cannot both be true.' }
    if ($Reference -in @('R222', 'R223', 'R224', 'U209', 'U212', 'U213')) { return 'SCHEMATIC VALUE INCONSISTENT — TPS2553-Q1 specifies a 15..232 kOhm RILIM range; captured 287 kOhm is outside the stable programming range and cannot freeze a 100 mA limit.' }
    if ($Reference -eq 'U801') { return 'PHYSICAL REQUIREMENT UNRESOLVED — no reviewed four-pin supervisor simultaneously satisfies separate core VDD/sense, valid assert >=2.9 V, invalid deassert <=2.7 V, 5..10 ms delay, and push-pull fail-low behavior without added threshold/timing circuitry.' }
    if ($Reference -in @('C102', 'C103', 'C104', 'C109', 'Q101')) { return 'ANALYSIS INCOMPLETE — ECO-006 corrected the electrical class; exact manufacturer curve, tolerance, thermal/SOA, lifecycle, sourcing, and cost evidence remain pending after CSR-01A-R2 stopped on released-network conflicts.' }
    if ($Reference -in @('U706', 'U707')) { return 'ANALYSIS INCOMPLETE — ECO-006 physical class is defined and TCA9517A is a candidate; exact pin equivalence, offset-low compatibility, partial-power behavior, lifecycle, sourcing, and cost evidence remain pending.' }
    if ($Reference -eq 'J1') { return 'ANALYSIS INCOMPLETE — MIR-01 released the physical interface, but housing/header/contact/tool order codes and qualification evidence were not frozen because CSR-01A-R2 stopped on electrical-network conflicts.' }
    if ($Reference -in @('U201', 'U203', 'L201', 'L202') -or $Value -match 'bootstrap|soft start|mux hold-up') { return 'THERMAL/STABILITY EVIDENCE MISSING — vendor-tool, effective-capacitance, loop/stability, loss, and minimum-copper analysis are incomplete.' }
    if ($Category -eq 'Power' -or $Reference -in @('U101','U102','U202','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302')) { return 'ANALYSIS INCOMPLETE — exact suffix equations, pin mapping, thresholds, timing, partial-power, thermal, and fault behavior are not all closed.' }
    if ($Category -in @('Protection','MOSFETs') -or $Reference -like 'D*' -or $Reference -like 'F*') { return 'TRANSIENT COORDINATION UNRESOLVED — clamp/current/energy/leakage/fault coordination and exact manufacturer evidence are incomplete.' }
    if ($Reference -like 'L*' -or $Reference -like 'FB*') { return 'ANALYSIS INCOMPLETE — saturation, RMS current, DCR, hot loss, impedance/core loss, and surge evidence are incomplete.' }
    if ($Reference -like 'C*') { return 'ANALYSIS INCOMPLETE — exact dielectric, DC-bias effective capacitance, ripple/ESR, aging, and stability evidence are incomplete.' }
    if ($Reference -like 'R*') { return 'ANALYSIS INCOMPLETE — device equation or divider tolerance, temperature drift, pulse/working voltage, and failure-effect evidence are incomplete.' }
    return 'VENDOR DATA UNAVAILABLE OR ANALYSIS INCOMPLETE — no exact part passed every mandatory CSR-01A-R criterion.'
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
        $freezeStatus = if ($isPowerScope) { 'BLOCKED' } else { 'NOT YET FROZEN' }
        $blocker = if ($isPowerScope) { Get-Csr01ArBlocker -Sheet $sheet -Reference $reference -Category $category -Value $value } else { 'Outside CSR-01A-R.' }
        $row = [pscustomobject][ordered]@{
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
            'Preferred Vendor Ordering Code' = $pendingLabel
            'Alternate Vendor' = $pendingLabel
            'Alternate Vendor Ordering Code' = $pendingLabel
            'Second Source' = $pendingLabel
            'Selection Rationale' = if ($isPowerScope) { $blocker } else { 'Outside CSR-01A-R; explicitly not yet frozen.' }
            'Criticality' = if ($category -in @('Power','Protection','ESP32','Relays','Logic','Watchdog','Safety','Connectors')) { 'Major' } else { 'Normal' }
            'Unit Cost 1' = ''
            'Unit Cost 10' = ''
            'Unit Cost 100' = ''
            'Unit Cost 1000' = ''
            'Currency' = ''
            'Price Date' = ''
            'Freeze Status' = $freezeStatus
            'Requirement Trace Reference' = if ($isPowerScope) { 'QER-01; ECO-006; MIR-01 where applicable; CSR-01A-R2 disposition' } else { 'NOT YET FROZEN' }
            'Sourcing Risk' = if ($isPowerScope) { 'BLOCKED' } else { 'NOT YET FROZEN' }
            'Risk' = if ($isPowerScope) { $blocker } else { 'Outside current package; do not source or assign a footprint.' }
            'Approved Alternate' = ''
            'Approved Alternate Vendor Code' = ''
            'Do Not Substitute' = 'YES'
            'Datasheet URL' = ''
            'Datasheet Revision or Date' = if ($isPowerScope) { 'BLOCKED' } else { 'NOT YET FROZEN' }
            'Hardware Revision' = 'Rev A'
            'Notes' = if ($isPowerScope) { "CSR-01A-R2 disposition: BLOCKED. $blocker" } else { 'NOT YET FROZEN; excluded from CSR-01A-R2.' }
        }
        if (Test-Csr01ArFrozen100kResistor -Sheet $sheet -Reference $reference) {
            $row.Manufacturer = 'Panasonic Industry'
            $row.'Manufacturer Part Number' = 'ERJ-3EKF1003V'
            $row.Description = '100 kΩ ±1% 0.1 W AEC-Q200 thick-film chip resistor'
            $row.Package = '0603 (1608 metric)'
            $row.'Mounting Style' = 'Surface mount'
            $row.'Operating Voltage' = '75 V maximum working; 5.25 V maximum applied in reviewed circuits'
            $row.'Maximum Current' = '52.5 µA at 5.25 V'
            $row.'Rating or Tolerance' = '100 kΩ ±1%; ±100 ppm/°C; 0.1 W'
            $row.'Temperature Range' = '-55 °C to +155 °C'
            $row.'Lifecycle Status' = 'ACTIVE — checked 2026-07-31'
            $row.'RoHS Status' = 'COMPLIANT — manufacturer certificate available'
            $row.Availability = 'DigiKey 943,271 in stock; Mouser regional listing over 357,000 in stock; checked 2026-07-31, not guaranteed'
            $row.'Preferred Vendor' = 'DigiKey'
            $row.'Preferred Vendor Ordering Code' = 'P100KHTR-ND / P100KHCT-ND'
            $row.'Alternate Vendor' = 'Mouser'
            $row.'Alternate Vendor Ordering Code' = '667-ERJ-3EKF1003V'
            $row.'Second Source' = 'Vishay Dale RCG0603100KFKEA — ELECTRICALLY APPROVED; footprint confirmation deferred'
            $row.'Selection Rationale' = 'QER-R-01/02/03/04: 5.25 V / 75 V = 7.0% voltage utilization; 0.276 mW / 100 mW = 0.28% power utilization; ±1% and ±100 ppm/°C meet general power-bias requirements; -55 to +155 °C exceeds environment.'
            $row.'Unit Cost 1' = '0.100'
            $row.'Unit Cost 10' = '0.039'
            $row.'Unit Cost 100' = '0.0195'
            $row.'Unit Cost 1000' = '0.01131'
            $row.Currency = 'USD'
            $row.'Price Date' = '2026-07-31; DigiKey cut tape'
            $row.'Freeze Status' = 'FROZEN'
            $row.'Requirement Trace Reference' = 'CSR-01A-R:QER-R-01,QER-R-02,QER-R-03,QER-R-04,QER-ENV-01'
            $row.'Sourcing Risk' = 'LOW'
            $row.Risk = 'Low electrical and sourcing risk; do not assign footprint until the footprint package.'
            $row.'Approved Alternate' = 'RCG0603100KFKEA — ELECTRICALLY APPROVED; FOOTPRINT MAY DIFFER'
            $row.'Approved Alternate Vendor Code' = 'DigiKey 541-1788-1-ND (cut tape)'
            $row.'Datasheet URL' = 'https://industrial.panasonic.com/ww/products/pt/general-purpose-chip-resistors/models/ERJ3EKF1003V'
            $row.'Datasheet Revision or Date' = 'AOA0000C304; 29-May-2025'
            $row.Notes = 'CSR-01A-R frozen exact electrical selection. Preferred and alternate sourcing checked 2026-07-31; stock and pricing are planning snapshots.'
        }
        $rows.Add($row)
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
    [pscustomobject]@{ Metric = 'Rows with frozen MPN'; Value = $frozenPowerRows.Count; Status = if ($frozenPowerRows.Count -gt 0) { 'PARTIAL' } else { 'BLOCKED' } }
    [pscustomobject]@{ Metric = 'Rows without frozen MPN'; Value = $rows.Count - $frozenPowerRows.Count; Status = 'BLOCKED OR NOT YET FROZEN' }
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
        'Preferred Distributor Ordering Code' = $row.'Preferred Vendor Ordering Code'
        'Alternate Distributor' = $row.'Alternate Vendor'
        'Alternate Distributor Ordering Code' = $row.'Alternate Vendor Ordering Code'
        'Lifecycle' = $row.'Lifecycle Status'
        'Stock Status' = $row.Availability
        'RoHS' = $row.'RoHS Status'
        'Second Source' = $row.'Second Source'
        'Approved Alternate' = $row.'Approved Alternate'
        'Approved Alternate Vendor Code' = $row.'Approved Alternate Vendor Code'
        'Freeze Status' = $row.'Freeze Status'
        'Sourcing Risk' = $row.'Sourcing Risk'
        'Requirement Trace Reference' = $row.'Requirement Trace Reference'
        'Risk' = $row.Risk
        'Review Date' = '2026-07-31'
    }
}
$avlRows | Export-Csv -LiteralPath (Join-Path $OutputDirectory 'Approved_Vendor_List.csv') -NoTypeInformation -Encoding UTF8

Write-Host "CSR-01 inventory generated: $($rows.Count) physical/logical schematic items."
Write-Host "Repeated local reference names: $($duplicateReferences.Count)"
