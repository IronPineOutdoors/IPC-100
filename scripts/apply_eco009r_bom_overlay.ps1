[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }

$value = '93.1 nF ±1% C0G/NP0 ≥10 V; CT; 99.642 ms nominal; leakage ≤10 nA; -40..125 °C'
$requirement = '93.1 nF ±1% maximum; C0G/NP0; ≥10 V; -40..125 °C minimum; ≤10 nA leakage; timing critical'
$trace = 'QER-03 QER-RST-01..08; ECO-009R; PAS-01R; TPS3890-Q1 SBVS303B'
$risk = 'ECO-009R timing implementation verified: 79.1..136.6 ms satisfies QER-03. BLOCKED only for exact U302/C305 MPN, lifecycle, sourcing, and prototype confirmation in PACS-01.'

$ebomPath = Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'
$avlPath = Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$ebom = @(Import-Csv $ebomPath -Encoding UTF8)
$avl = @(Import-Csv $avlPath -Encoding UTF8)
$e = $ebom | Where-Object { $_.Item -eq '03_ESP32_Core/C305' } | Select-Object -First 1
$a = $avl | Where-Object { $_.Item -eq '03_ESP32_Core/C305' } | Select-Object -First 1
if ($null -eq $e -or $null -eq $a) { throw 'C305 EBOM or AVL row missing.' }

$e.Function = $value
$e.Description = $value
$e.Value = $value
$e.Package = 'UNRESOLVED - NO FOOTPRINT ASSIGNED'
$e.'Operating Voltage' = '≥10 V rated; CT node ≤1.29 V'
$e.'Maximum Current' = '1.35 µA CT charge current maximum plus leakage'
$e.'Rating or Tolerance' = $requirement
$e.'Temperature Range' = '-40 °C to +125 °C minimum'
$e.'Selection Rationale' = $risk
$e.'Freeze Status' = 'BLOCKED'
$e.'Requirement Trace Reference' = $trace
$e.'Sourcing Risk' = 'BLOCKED'
$e.Risk = $risk
$e.'Datasheet URL' = 'https://www.ti.com/lit/ds/symlink/tps3890-q1.pdf'
$e.'Datasheet Revision or Date' = 'SBVS303B; reviewed 2026-07-31'
$e.Notes = $risk

$a.'Freeze Status' = $e.'Freeze Status'
$a.'Sourcing Risk' = $e.'Sourcing Risk'
$a.'Requirement Trace Reference' = $trace
$a.Risk = $risk
$a.'Review Date' = '2026-07-31'

$ebom | Export-Csv $ebomPath -NoTypeInformation -Encoding UTF8
$avl | Export-Csv $avlPath -NoTypeInformation -Encoding UTF8

function Sync-XlsxRowFromCsv {
    param([string]$WorkbookPath, [psobject]$CsvRow)
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('ipc100-eco009r-' + [guid]::NewGuid().ToString('N'))
    [IO.Directory]::CreateDirectory($tempRoot) | Out-Null
    try {
        [IO.Compression.ZipFile]::ExtractToDirectory($WorkbookPath, $tempRoot)
        $sheetPath = Join-Path $tempRoot 'xl/worksheets/sheet1.xml'
        [xml]$xml = Get-Content $sheetPath -Raw -Encoding UTF8
        $ns = New-Object Xml.XmlNamespaceManager($xml.NameTable)
        $ns.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')
        $rows = $xml.SelectNodes('//x:sheetData/x:row', $ns)
        $headers = @{}
        foreach ($cell in $rows[0].SelectNodes('x:c', $ns)) {
            $column = ([regex]::Match($cell.r, '^[A-Z]+')).Value
            $headers[$column] = $cell.SelectSingleNode('x:is/x:t', $ns).'#text'
        }
        $target = $null
        foreach ($row in $rows) {
            $first = $row.SelectSingleNode('x:c[1]/x:is/x:t', $ns)
            if ($null -ne $first -and $first.'#text' -eq $CsvRow.Item) { $target = $row; break }
        }
        if ($null -eq $target) { throw "Workbook row missing for $($CsvRow.Item): $WorkbookPath" }
        foreach ($cell in $target.SelectNodes('x:c', $ns)) {
            $column = ([regex]::Match($cell.r, '^[A-Z]+')).Value
            $header = $headers[$column]
            if ($CsvRow.PSObject.Properties.Name -contains $header) {
                $text = $cell.SelectSingleNode('x:is/x:t', $ns)
                $text.InnerText = [string]$CsvRow.$header
            }
        }
        $settings = New-Object Xml.XmlWriterSettings
        $settings.Encoding = New-Object Text.UTF8Encoding($false)
        $settings.Indent = $false
        $writer = [Xml.XmlWriter]::Create($sheetPath, $settings)
        $xml.Save($writer)
        $writer.Dispose()
        $replacement = "$WorkbookPath.eco009r"
        if (Test-Path $replacement) { Remove-Item -LiteralPath $replacement -Force }
        $archive = [IO.Compression.ZipFile]::Open($replacement, [IO.Compression.ZipArchiveMode]::Create)
        try {
            foreach ($file in Get-ChildItem -LiteralPath $tempRoot -Recurse -File) {
                $relative = $file.FullName.Substring($tempRoot.Length + 1).Replace('\', '/')
                [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $relative) | Out-Null
            }
        } finally { $archive.Dispose() }
        Move-Item -LiteralPath $replacement -Destination $WorkbookPath -Force
    }
    finally {
        if (Test-Path $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
    }
}

Sync-XlsxRowFromCsv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.xlsx') $e
Sync-XlsxRowFromCsv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.xlsx') $a
Write-Host 'ECO-009R C305 EBOM/AVL CSV and XLSX rows synchronized.'
