[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [switch]$VerifyOnly
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

$sheetDirectory = Join-Path $RepositoryRoot 'hardware\kicad\sheets'
$sheetFiles = Get-ChildItem $sheetDirectory -Filter '*.kicad_sch' | Sort-Object Name
$mapping = [System.Collections.Generic.List[object]]::new()

foreach ($file in $sheetFiles) {
    if ($file.BaseName -notmatch '^(\d{2})_') { continue }
    $sheetNumber = [int]$Matches[1]
    if ($sheetNumber -eq 0) { continue }

    $content = [IO.File]::ReadAllText($file.FullName, [Text.Encoding]::UTF8)
    $matches = [regex]::Matches(
        $content,
        '(?s)\(symbol \(lib_id "([^"]+)"\).*?\(property "Reference" "([^"]+)".*?\(property "Value" "([^"]+)".*?\(instances '
    )
    $sheetMappings = [System.Collections.Generic.List[object]]::new()
    foreach ($match in $matches) {
        $capturedReference = $match.Groups[2].Value
        $value = $match.Groups[3].Value
        $libId = $match.Groups[1].Value

        if ($capturedReference -like '#PWR*' -or $capturedReference -like 'J*' -or $capturedReference -like 'DFT*') {
            $oldReference = $capturedReference
            $newReference = $capturedReference
            $preserved = $true
            $needsChange = $false
        }
        elseif ($capturedReference -match '^([A-Za-z]+)(\d+)([A-Za-z]*)$') {
            $prefix = $Matches[1]
            $capturedNumber = [int]$Matches[2]
            $unitSuffix = $Matches[3]
            $sheetBase = $sheetNumber * 100
            if ($capturedNumber -gt $sheetBase -and $capturedNumber -lt ($sheetBase + 100)) {
                $localNumber = $capturedNumber - $sheetBase
                $oldReference = '{0}{1}{2}' -f $prefix, $localNumber, $unitSuffix
                $newReference = $capturedReference
                $needsChange = $false
            }
            else {
                $localNumber = $capturedNumber
                $oldReference = $capturedReference
                $newReference = '{0}{1}{2}' -f $prefix, ($sheetBase + $localNumber), $unitSuffix
                $needsChange = $true
            }
            $preserved = $false
        }
        else {
            throw "Unsupported reference format '$capturedReference' in $($file.Name)."
        }

        $entry = [pscustomobject][ordered]@{
            Sheet = ('{0:D2}' -f $sheetNumber)
            SheetFile = $file.Name
            OldReference = $oldReference
            NewReference = $newReference
            ComponentType = $libId
            Function = $value
            Preserved = $preserved
            NeedsChange = $needsChange
        }
        $sheetMappings.Add($entry)
        $mapping.Add($entry)
    }

    if (-not $VerifyOnly) {
        foreach ($entry in $sheetMappings | Where-Object NeedsChange) {
            $oldProperty = '(property "Reference" "' + $entry.OldReference + '"'
            $newProperty = '(property "Reference" "' + $entry.NewReference + '"'
            $oldInstance = '(reference "' + $entry.OldReference + '")'
            $newInstance = '(reference "' + $entry.NewReference + '")'
            if ([regex]::Matches($content, [regex]::Escape($oldProperty)).Count -ne 1) {
                throw "Expected one reference property for $($entry.OldReference) in $($file.Name)."
            }
            if ([regex]::Matches($content, [regex]::Escape($oldInstance)).Count -ne 1) {
                throw "Expected one instance reference for $($entry.OldReference) in $($file.Name)."
            }
            $content = $content.Replace($oldProperty, $newProperty).Replace($oldInstance, $newInstance)
        }
        [IO.File]::WriteAllText($file.FullName, $content, [Text.UTF8Encoding]::new($false))
    }
}

$physicalReferences = $mapping | Where-Object { $_.OldReference -notlike '#PWR*' }
$duplicates = $physicalReferences | Group-Object NewReference | Where-Object Count -gt 1
if ($duplicates) {
    $duplicates | ForEach-Object { Write-Error "Duplicate normalized reference: $($_.Name) ($($_.Count))" }
    exit 1
}

if (-not $VerifyOnly) {
    $registerPath = Join-Path $RepositoryRoot 'docs\reference\Reference_Designator_Register.md'
    New-Item -ItemType Directory -Path (Split-Path $registerPath) -Force | Out-Null
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# IPC-100 Reference Designator Register')
    $lines.Add('')
    $lines.Add('| Field | Value |')
    $lines.Add('| --- | --- |')
    $lines.Add('| Platform | IPC-100 |')
    $lines.Add('| Hardware revision | Rev A |')
    $lines.Add('| Change authority | ECO-005 |')
    $lines.Add('| Normalization date | 2026-07-31 |')
    $lines.Add('| Physical/logical component rows | ' + $physicalReferences.Count + ' |')
    $lines.Add('| Final duplicate references | 0 |')
    $lines.Add('')
    $lines.Add('Connector functional designations J1–J10 and J13, plus factory boundary DFT1, are intentionally preserved. `#PWR` symbols are included for traceability but are not physical BOM items. All other references use sheet-based numeric ranges.')
    $lines.Add('')
    $lines.Add('| Old Reference | New Reference | Sheet | Component Type | Function |')
    $lines.Add('| --- | --- | --- | --- | --- |')
    foreach ($entry in $mapping | Sort-Object Sheet, ComponentType, OldReference) {
        $safeFunction = $entry.Function.Replace('|', '\|').Replace("`r", ' ').Replace("`n", ' ')
        $lines.Add('| `' + $entry.OldReference + '` | `' + $entry.NewReference + '` | ' + $entry.Sheet + ' | `' + $entry.ComponentType + '` | ' + $safeFunction + ' |')
    }
    [IO.File]::WriteAllLines($registerPath, $lines, [Text.UTF8Encoding]::new($false))
}

Write-Host "ECO-005 reference map rows: $($mapping.Count)"
Write-Host "Physical/logical references: $($physicalReferences.Count)"
Write-Host 'Final duplicate physical/logical references: 0'
