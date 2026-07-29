[CmdletBinding()]
param(
    [string]$ProjectDirectory = (Join-Path $PSScriptRoot '..\hardware\kicad')
)

$ErrorActionPreference = 'Stop'
$projectDirectoryPath = (Resolve-Path -LiteralPath $ProjectDirectory).Path
$projectFile = Join-Path $projectDirectoryPath 'IPC-100.kicad_pro'
$rootFile = Join-Path $projectDirectoryPath 'IPC-100.kicad_sch'
$sheetDirectory = Join-Path $projectDirectoryPath 'sheets'
$errors = [System.Collections.Generic.List[string]]::new()

function Test-BalancedSExpression {
    param([Parameter(Mandatory)][string]$Path)

    $content = Get-Content -LiteralPath $Path -Raw
    $depth = 0
    $insideQuote = $false
    $escaped = $false

    foreach ($character in $content.ToCharArray()) {
        if ($insideQuote) {
            if ($escaped) {
                $escaped = $false
            }
            elseif ($character -eq '\') {
                $escaped = $true
            }
            elseif ($character -eq '"') {
                $insideQuote = $false
            }
        }
        else {
            if ($character -eq '"') {
                $insideQuote = $true
            }
            elseif ($character -eq '(') {
                $depth++
            }
            elseif ($character -eq ')') {
                $depth--
                if ($depth -lt 0) {
                    return $false
                }
            }
        }
    }

    return (-not $insideQuote -and $depth -eq 0)
}

try {
    $null = Get-Content -LiteralPath $projectFile -Raw | ConvertFrom-Json
}
catch {
    $errors.Add("Project JSON is invalid: $($_.Exception.Message)")
}

$schematicFiles = @($rootFile) + @(Get-ChildItem -LiteralPath $sheetDirectory -Filter '*.kicad_sch' | Select-Object -ExpandProperty FullName)
foreach ($schematicFile in $schematicFiles) {
    if (-not (Test-BalancedSExpression -Path $schematicFile)) {
        $errors.Add("Unbalanced KiCad S-expression: $schematicFile")
    }
}

$rootContent = Get-Content -LiteralPath $rootFile -Raw
$sheetBlocks = [regex]::Matches(
    $rootContent,
    '(?s)\(sheet \(at .*?\n  \)\n(?=  \(wire|  \(sheet_instances)'
)

if ($sheetBlocks.Count -ne 9) {
    $errors.Add("Expected 9 root hierarchical sheets; found $($sheetBlocks.Count).")
}

$sheetNames = [System.Collections.Generic.List[string]]::new()
$sheetFiles = [System.Collections.Generic.List[string]]::new()

foreach ($sheetBlock in $sheetBlocks) {
    $sheetName = [regex]::Match($sheetBlock.Value, '\(property "Sheetname" "([^"]+)"').Groups[1].Value
    $sheetFile = [regex]::Match($sheetBlock.Value, '\(property "Sheetfile" "([^"]+)"').Groups[1].Value
    $sheetNames.Add($sheetName)
    $sheetFiles.Add($sheetFile)

    $childPath = Join-Path $projectDirectoryPath $sheetFile
    if (-not (Test-Path -LiteralPath $childPath)) {
        $errors.Add("Missing child sheet: $sheetFile")
        continue
    }

    $rootPins = @(
        [regex]::Matches($sheetBlock.Value, '\(pin "([^"]+)"') |
            ForEach-Object { $_.Groups[1].Value }
    )
    $childContent = Get-Content -LiteralPath $childPath -Raw
    $childPins = @(
        [regex]::Matches($childContent, '\(hierarchical_label "([^"]+)"') |
            ForEach-Object { $_.Groups[1].Value }
    )

    $missingInChild = @($rootPins | Where-Object { $_ -notin $childPins })
    $missingAtRoot = @($childPins | Where-Object { $_ -notin $rootPins })
    $duplicateChildPins = @($childPins | Group-Object | Where-Object Count -gt 1)

    if ($missingInChild.Count -gt 0) {
        $errors.Add("$sheetName missing child labels: $($missingInChild -join ', ')")
    }
    if ($missingAtRoot.Count -gt 0) {
        $errors.Add("$sheetName missing root pins: $($missingAtRoot -join ', ')")
    }
    if ($duplicateChildPins.Count -gt 0) {
        $errors.Add("$sheetName contains duplicate child labels: $($duplicateChildPins.Name -join ', ')")
    }

    $isImplementedPowerEntry = $sheetFile -eq 'sheets/01_Power_Entry.kicad_sch'
    $requiredNote = 'Detailed implementation intentionally deferred to subsequent engineering package.'
    if (-not $isImplementedPowerEntry -and -not $childContent.Contains($requiredNote)) {
        $errors.Add("$sheetName is missing the required implementation-deferral note.")
    }
    if ($isImplementedPowerEntry) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -eq 0) {
            $errors.Add("$sheetName contains no implemented component symbols.")
        }
        foreach ($requiredNet in @('VIN_RAW', 'VIN_PROTECTED', 'USB_VBUS_RAW', 'USB_5V_PROTECTED', 'BATTERY_SENSE', 'POWER_FAULT_SUMMARY', 'GND')) {
            if (-not $childContent.Contains('"' + $requiredNet + '"')) {
                $errors.Add("$sheetName is missing required net $requiredNet.")
            }
        }
    }
}

if (($sheetNames | Sort-Object -Unique).Count -ne $sheetNames.Count) {
    $errors.Add('Duplicate hierarchical sheet names exist.')
}
if (($sheetFiles | Sort-Object -Unique).Count -ne $sheetFiles.Count) {
    $errors.Add('Duplicate hierarchical sheet file references exist.')
}

$interfaceContracts = @(
    @{ Signal = 'MAIN_INPUT_VALID'; Producer = '01 Power Entry & Protection'; Consumer = '02 Power Conversion' },
    @{ Signal = 'OLED_POWER_REQ'; Producer = '03 ESP32 Core'; Consumer = '02 Power Conversion' },
    @{ Signal = 'SENSOR_POWER_REQ'; Producer = '03 ESP32 Core'; Consumer = '02 Power Conversion' },
    @{ Signal = 'UI_POWER_REQ'; Producer = '03 ESP32 Core'; Consumer = '02 Power Conversion' },
    @{ Signal = 'EXPANSION_POWER_REQ'; Producer = '03 ESP32 Core'; Consumer = '02 Power Conversion' }
)

foreach ($contract in $interfaceContracts) {
    $producerBlock = $sheetBlocks | Where-Object {
        $_.Value.Contains('(property "Sheetname" "' + $contract.Producer + '"')
    }
    $consumerBlock = $sheetBlocks | Where-Object {
        $_.Value.Contains('(property "Sheetname" "' + $contract.Consumer + '"')
    }
    $escapedSignal = [regex]::Escape($contract.Signal)

    if (-not $producerBlock -or $producerBlock.Value -notmatch '\(pin "' + $escapedSignal + '" output') {
        $errors.Add("$($contract.Signal) has no unambiguous output on $($contract.Producer).")
    }
    if (-not $consumerBlock -or $consumerBlock.Value -notmatch '\(pin "' + $escapedSignal + '" input') {
        $errors.Add("$($contract.Signal) has no unambiguous input on $($contract.Consumer).")
    }

    $rootPinCount = [regex]::Matches($rootContent, '\(pin "' + $escapedSignal + '"').Count
    $rootLabelCount = [regex]::Matches($rootContent, '\(label "' + $escapedSignal + '"').Count
    if ($rootPinCount -ne 2 -or $rootLabelCount -ne 2) {
        $errors.Add("$($contract.Signal) must have exactly one producer and one consumer; found $rootPinCount pins and $rootLabelCount labels.")
    }
}

$placeholderFiles = @($rootFile) + @(
    Get-ChildItem -LiteralPath $sheetDirectory -Filter '*.kicad_sch' |
        Where-Object Name -ne '01_Power_Entry.kicad_sch' |
        Select-Object -ExpandProperty FullName
)
$placeholderSymbols = Select-String -Path $placeholderFiles -Pattern '^  \(symbol \(lib_id' -ErrorAction SilentlyContinue
if ($placeholderSymbols) {
    $errors.Add('Component symbols exist outside the authorized Sheet 01 scope.')
}

$footprints = Select-String -Path $schematicFiles -Pattern '\(footprint ' -ErrorAction SilentlyContinue
if ($footprints) {
    $errors.Add('Package 01 contains footprint assignments.')
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'IPC-100 KiCad hierarchy validation passed.'
Write-Host "Root sheet: $rootFile"
Write-Host "Child sheets: $($sheetBlocks.Count)"
Write-Host 'Project JSON: valid'
Write-Host 'S-expressions: balanced'
Write-Host 'Root/child ports: matched and unique'
Write-Host 'AR-01 interfaces: one producer and one consumer each'
Write-Host 'Component symbols: confined to implemented Sheet 01'
Write-Host 'Footprint assignments: 0'
