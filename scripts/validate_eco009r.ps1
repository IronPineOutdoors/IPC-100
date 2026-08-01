[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }

$sheetPath = Join-Path $RepositoryRoot 'hardware/kicad/sheets/03_ESP32_Core.kicad_sch'
$s03 = Get-Content $sheetPath -Raw
$doc = Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-009R_C305_Timing_Closure.md') -Raw
$qer = Get-Content (Join-Path $RepositoryRoot 'docs/specifications/QER-03_Core_Reset_Release_Timing_Window.md') -Raw

Assert-True ($s03 -match '(?s)Reference" "C305".*?Value" "93\.1 nF.*?±1%.*?C0G/NP0.*?99\.642 ms') 'C305 generic requirement is incorrect.'
Assert-True ($s03 -notmatch '(?s)Reference" "C305".*?Value" "10 nF') 'Stale C305 10 nF implementation remains.'
Assert-True ([regex]::Matches($s03, 'Reference" "C305"').Count -eq 1) 'C305 reference is missing or duplicated.'
Assert-True ($s03.Contains('60000000-0000-4000-8000-000000000136')) 'C305 UUID changed.'
Assert-True ([regex]::Matches($s03, 'label "CORE_RESET_CT"').Count -eq 2) 'U302/C305 CT topology changed.'
Assert-True ($s03 -match 'Reference" "U302".*?TPS389030-Q1' -and $s03 -match 'Reference" "R301".*?10 k') 'Supervisor or reset pull-up ownership changed.'
Assert-True ($s03 -match 'RESET_VALID is the active-high, pulled-up supervisor release/EN node') 'RESET_VALID semantics changed.'

foreach ($token in @('99.642 ms','79.1 ms','136.6 ms','75 ms ≤ 79.1 ms','136.6 ms ≤ 150 ms','76 ms ≤ 79.1 ms','136.6 ms ≤ 149 ms','4.1 ms','13.4 ms','3.1 ms','12.4 ms','200 Ω','USB-only','WATCHDOG_VALID','ACTUATOR_PERMIT','No C305 failure directly energizes')) {
    Assert-True $doc.Contains($token) "ECO-009R evidence missing: $token"
}
Assert-True ($qer.Contains('QER-RST-01') -and $qer.Contains('QER-RST-08')) 'QER-03 requirement trace missing.'
Assert-True ([regex]::Matches($doc, '(?m)^# ECO-009R (?:COMPLETE — PACS-01 AUTHORIZED|INCOMPLETE)$').Count -eq 1) 'ECO-009R must issue exactly one final decision.'
Assert-True ($doc -match '(?m)^# ECO-009R COMPLETE — PACS-01 AUTHORIZED$') 'ECO-009R decision mismatch.'

$ebom = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
$avl = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv') -Encoding UTF8)
$e = $ebom | Where-Object Item -eq '03_ESP32_Core/C305' | Select-Object -First 1
$a = $avl | Where-Object Item -eq '03_ESP32_Core/C305' | Select-Object -First 1
Assert-True ($e.Value -match '^93\.1 nF' -and $e.'Rating or Tolerance' -match '±1%.*C0G/NP0.*≤10 nA' -and $e.'Operating Voltage' -match '≥10 V') 'C305 EBOM electrical requirement mismatch.'
Assert-True ($e.'Freeze Status' -eq 'BLOCKED' -and $e.'Requirement Trace Reference' -match 'QER-03.*ECO-009R' -and $e.Risk -match 'PACS-01') 'C305 EBOM disposition mismatch.'
Assert-True ($a.'Freeze Status' -eq $e.'Freeze Status' -and $a.Risk -eq $e.Risk -and $a.'Requirement Trace Reference' -eq $e.'Requirement Trace Reference') 'C305 AVL/EBOM mismatch.'
Assert-True ($e.'Manufacturer Part Number' -match '^UNRESOLVED' -and [string]::IsNullOrWhiteSpace($e.Footprint)) 'Unexpected MPN or footprint selected.'

Add-Type -AssemblyName System.IO.Compression.FileSystem
foreach ($xlsx in @('IPC100_RevA_EBOM.xlsx','Approved_Vendor_List.xlsx')) {
    $path = Join-Path $RepositoryRoot "docs/bom/$xlsx"
    $zip = [IO.Compression.ZipFile]::OpenRead($path)
    try {
        $entry = $zip.GetEntry('xl/worksheets/sheet1.xml')
        if ($null -eq $entry) { $entry = $zip.GetEntry('xl\worksheets\sheet1.xml') }
        Assert-True ($null -ne $entry) "$xlsx worksheet XML missing."
        $reader = New-Object IO.StreamReader($entry.Open())
        try { $sheetXml = $reader.ReadToEnd() } finally { $reader.Dispose() }
        Assert-True ($sheetXml.Contains('03_ESP32_Core/C305') -and $sheetXml.Contains('ECO-009R timing implementation verified') -and $sheetXml.Contains('BLOCKED')) "$xlsx C305 row not synchronized."
    } finally { $zip.Dispose() }
}

$rdr = Get-Content (Join-Path $RepositoryRoot 'docs/reference/Reference_Designator_Register.md') -Raw
Assert-True ($rdr -match 'C305.*93\.1 nF') 'Reference Designator Register is not synchronized.'

$changed = @(git -C $RepositoryRoot diff --name-only a1ed127)
foreach ($path in $changed) {
    Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/adr/|docs/icd/|docs/connectors/') "Prohibited ECO-009R change: $path"
}
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Host 'ECO-009R validation passed: 99.642 ms nominal; 79.1..136.6 ms endpoints; QER-03 windows satisfied; records synchronized; zero CAD changes.'
