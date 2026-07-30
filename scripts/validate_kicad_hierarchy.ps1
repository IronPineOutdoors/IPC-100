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
    $isImplementedPowerConversion = $sheetFile -eq 'sheets/02_Power_Conversion.kicad_sch'
    $isImplementedProcessor = $sheetFile -eq 'sheets/03_ESP32_Core.kicad_sch'
    $isImplementedSafetyInputs = $sheetFile -eq 'sheets/04_Safety_Inputs.kicad_sch'
    $isImplementedMotion = $sheetFile -eq 'sheets/05_Motor_Interfaces.kicad_sch'
    $requiredNote = 'Detailed implementation intentionally deferred to subsequent engineering package.'
    if (-not $isImplementedPowerEntry -and -not $isImplementedPowerConversion -and -not $isImplementedProcessor -and -not $isImplementedSafetyInputs -and -not $isImplementedMotion -and -not $childContent.Contains($requiredNote)) {
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
    if ($isImplementedPowerConversion) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -eq 0) {
            $errors.Add("$sheetName contains no implemented component symbols.")
        }
        if ($childContent.Contains('"POWER_VALID"')) {
            $errors.Add("$sheetName contains rejected net POWER_VALID.")
        }
    }
    if ($isImplementedProcessor) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -eq 0) {
            $errors.Add("$sheetName contains no implemented component symbols.")
        }
        foreach ($requiredNet in @('+3V3_CORE', 'RESET_VALID', 'WATCHDOG_SERVICE_MCU', 'OLED_POWER_REQ', 'SENSOR_POWER_REQ', 'UI_POWER_REQ', 'EXPANSION_POWER_REQ', 'USB_D+', 'USB_D-', 'UART0_TX', 'UART0_RX')) {
            if (-not $childContent.Contains('"' + $requiredNet + '"')) {
                $errors.Add("$sheetName is missing required net $requiredNet.")
            }
        }
        if ($childContent -match '\(hierarchical_label "MAIN_POWER_GOOD"') {
            $errors.Add("$sheetName contains the ADR-041-rejected MAIN_POWER_GOOD port.")
        }
        if ($childContent -match '\(hierarchical_label "[^"]*GPIO\d+') {
            $errors.Add("$sheetName exports a raw GPIO identifier.")
        }
        foreach ($reservedPin in @('GPIO37_RESERVED')) {
            if (-not $childContent.Contains('"' + $reservedPin + '"')) {
                $errors.Add("$sheetName is missing reserved module pin $reservedPin.")
            }
        }
        if ($childContent.Contains('"GPIO42_RESERVED"')) {
            $errors.Add("$sheetName retains superseded GPIO42_RESERVED instead of WATCHDOG_SERVICE_MCU.")
        }
    }
    if ($isImplementedSafetyInputs) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -eq 0) {
            $errors.Add("$sheetName contains no implemented component symbols.")
        }
    }
    if ($isImplementedMotion) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -eq 0) {
            $errors.Add("$sheetName contains no implemented component symbols.")
        }
        foreach ($requiredNet in @(
            '+3V3_CORE', 'MOTOR_LOGIC_5V_A', 'MOTOR_LOGIC_5V_B',
            'ACTUATOR_PERMIT', 'MASTER_INHIBIT',
            'AXIS1_RPWM_MCU', 'AXIS1_LPWM_MCU', 'AXIS1_REN_MCU', 'AXIS1_LEN_MCU',
            'AXIS2_RPWM_MCU', 'AXIS2_LPWM_MCU', 'AXIS2_REN_MCU', 'AXIS2_LEN_MCU',
            'AXIS1_RPWM_SAFE', 'AXIS1_LPWM_SAFE', 'AXIS1_REN_SAFE', 'AXIS1_LEN_SAFE',
            'AXIS2_RPWM_SAFE', 'AXIS2_LPWM_SAFE', 'AXIS2_REN_SAFE', 'AXIS2_LEN_SAFE'
        )) {
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
    @{ Signal = 'EXPANSION_POWER_REQ'; Producer = '03 ESP32 Core'; Consumer = '02 Power Conversion' },
    @{ Signal = 'WATCHDOG_SERVICE_MCU'; Producer = '03 ESP32 Core'; Consumer = '06 Relay + Master Inhibit' },
    @{ Signal = 'ACTUATOR_PERMIT'; Producer = '06 Relay + Master Inhibit'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'MASTER_INHIBIT'; Producer = '06 Relay + Master Inhibit'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS1_RPWM_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS1_LPWM_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS1_REN_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS1_LEN_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS2_RPWM_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS2_LPWM_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS2_REN_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS2_LEN_MCU'; Producer = '03 ESP32 Core'; Consumer = '05 Motor Interfaces' },
    @{ Signal = 'AXIS1_RPWM_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS1_LPWM_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS1_REN_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS1_LEN_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS2_RPWM_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS2_LPWM_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS2_REN_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' },
    @{ Signal = 'AXIS2_LEN_SAFE'; Producer = '05 Motor Interfaces'; Consumer = '09 Connectors + Test Access' }
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

$sheet03Block = $sheetBlocks | Where-Object {
    $_.Value.Contains('(property "Sheetname" "03 ESP32 Core"')
}
$sheet06Block = $sheetBlocks | Where-Object {
    $_.Value.Contains('(property "Sheetname" "06 Relay + Master Inhibit"')
}
if ($sheet03Block.Value -match '\(pin "WATCHDOG_VALID"' -or
    $sheet06Block.Value -notmatch '\(pin "WATCHDOG_VALID" output') {
    $errors.Add('WATCHDOG_VALID must be generated by Sheet 06 and must not be processor-owned.')
}
if ($sheet03Block.Value -notmatch '\(pin "RELAY_CMD_MCU" output' -or
    $sheet03Block.Value -notmatch '\(pin "RESET_VALID" output' -or
    $sheet03Block.Value -notmatch '\(pin "WATCHDOG_SERVICE_MCU" output') {
    $errors.Add('RELAY_CMD_MCU, RESET_VALID, and WATCHDOG_SERVICE_MCU must remain distinct Sheet 03 outputs.')
}

$mainGoodProducer = $sheetBlocks | Where-Object {
    $_.Value.Contains('(property "Sheetname" "02 Power Conversion"')
}
$mainGoodSafetyConsumer = $sheetBlocks | Where-Object {
    $_.Value.Contains('(property "Sheetname" "06 Relay + Master Inhibit"')
}
$mainGoodProcessor = $sheetBlocks | Where-Object {
    $_.Value.Contains('(property "Sheetname" "03 ESP32 Core"')
}
if (-not $mainGoodProducer -or $mainGoodProducer.Value -notmatch '\(pin "MAIN_POWER_GOOD" output') {
    $errors.Add('MAIN_POWER_GOOD is missing its Sheet 02 producer.')
}
if (-not $mainGoodSafetyConsumer -or $mainGoodSafetyConsumer.Value -notmatch '\(pin "MAIN_POWER_GOOD" input') {
    $errors.Add('MAIN_POWER_GOOD is missing its Sheet 06 safety consumer.')
}
if ($mainGoodProcessor -and $mainGoodProcessor.Value -match '\(pin "MAIN_POWER_GOOD"') {
    $errors.Add('ADR-041 prohibits MAIN_POWER_GOOD on Sheet 03.')
}

if ($rootContent -match '"OUTPUT_FAULT_SUMMARY"' -or
    (Get-Content -LiteralPath (Join-Path $sheetDirectory '05_Motor_Interfaces.kicad_sch') -Raw) -match '"OUTPUT_FAULT_SUMMARY"') {
    $errors.Add('ADR-043 removes OUTPUT_FAULT_SUMMARY from the Rev A hierarchy.')
}

foreach ($rejectedSignal in @('THROWER_TRIGGER', 'DRIVER_ENABLE', 'MOTOR_LOGIC_ENABLE')) {
    $escapedRejectedSignal = [regex]::Escape($rejectedSignal)
    if ($rootContent -match '"' + $escapedRejectedSignal + '"' -or
        ($schematicFiles | Select-String -Pattern ('"' + $escapedRejectedSignal + '"'))) {
        $errors.Add("ADR-044 does not authorize $rejectedSignal.")
    }
}

$placeholderFiles = @($rootFile) + @(
    Get-ChildItem -LiteralPath $sheetDirectory -Filter '*.kicad_sch' |
        Where-Object Name -notin @('01_Power_Entry.kicad_sch', '02_Power_Conversion.kicad_sch', '03_ESP32_Core.kicad_sch', '04_Safety_Inputs.kicad_sch', '05_Motor_Interfaces.kicad_sch') |
        Select-Object -ExpandProperty FullName
)
$placeholderSymbols = Select-String -Path $placeholderFiles -Pattern '^  \(symbol \(lib_id' -ErrorAction SilentlyContinue
if ($placeholderSymbols) {
    $errors.Add('Component symbols exist outside the authorized Sheets 01 through 05 scope.')
}

$motionFile = Join-Path $sheetDirectory '05_Motor_Interfaces.kicad_sch'
$motionContent = Get-Content -LiteralPath $motionFile -Raw
$authorizationConnectivity = @(
    @{
        Signal = 'ACTUATOR_PERMIT'
        PinDefinition = '\(pin input line \(at -15\.24 -7\.62 0\).*?\(name "PERMIT"'
        LocalAttachment = '\(label "ACTUATOR_PERMIT" \(at 59\.76 38\.38 0\)'
    },
    @{
        Signal = 'MASTER_INHIBIT'
        PinDefinition = '\(pin input line \(at -15\.24 -2\.54 0\).*?\(name "INHIBIT"'
        LocalAttachment = '\(label "MASTER_INHIBIT" \(at 59\.76 43\.46 0\)'
    }
)
if ($motionContent -notmatch '\(symbol \(lib_id "IPC100:AUTH2"\) \(at 75 46 0\)') {
    $errors.Add('Sheet 05 authorization qualifier U3 is not at its ECO-001 controlled placement.')
}
foreach ($authorizationNet in $authorizationConnectivity) {
    if ($motionContent -notmatch $authorizationNet.PinDefinition) {
        $errors.Add("Sheet 05 U3 is missing the controlled $($authorizationNet.Signal) input pin definition.")
    }
    if ([regex]::Matches($motionContent, $authorizationNet.LocalAttachment).Count -ne 1) {
        $errors.Add("Sheet 05 $($authorizationNet.Signal) is not attached exactly once at the controlled U3 pin endpoint.")
    }
}
$authorizationBiases = @(
    @{
        Signal = 'ACTUATOR_PERMIT'
        Value = '100 kΩ U3 PERMIT fail-low input bias'
        NetAttachment = '\(label "ACTUATOR_PERMIT" \(at 145 38\.38 90\)'
        SafeAttachment = '\(label "GND" \(at 145 48\.54 90\)'
    },
    @{
        Signal = 'MASTER_INHIBIT'
        Value = '100 kΩ U3 INHIBIT fail-high input bias'
        NetAttachment = '\(label "MASTER_INHIBIT" \(at 160 53\.62 90\)'
        SafeAttachment = '\(label "\+3V3_CORE" \(at 160 43\.46 90\)'
    }
)
foreach ($authorizationBias in $authorizationBiases) {
    if ([regex]::Matches($motionContent, [regex]::Escape($authorizationBias.Value)).Count -ne 1) {
        $errors.Add("Sheet 05 $($authorizationBias.Signal) must have exactly one ECO-002 100 kΩ input bias.")
    }
    if ([regex]::Matches($motionContent, $authorizationBias.NetAttachment).Count -ne 1 -or
        [regex]::Matches($motionContent, $authorizationBias.SafeAttachment).Count -ne 1) {
        $errors.Add("Sheet 05 $($authorizationBias.Signal) ECO-002 bias is not attached to its controlled safe-state nets.")
    }
}
if ([regex]::Matches($motionContent, '47 kΩ MCU-side inactive default').Count -ne 8) {
    $errors.Add('Sheet 05 must contain exactly eight 47 kΩ MCU-side inactive-default pulldowns.')
}
if ([regex]::Matches($motionContent, '33 Ω series damping').Count -ne 8) {
    $errors.Add('Sheet 05 must contain exactly eight 33 Ω output damping resistors.')
}
if ([regex]::Matches($motionContent, '10 kΩ safe-side inactive default').Count -ne 8) {
    $errors.Add('Sheet 05 must contain exactly eight 10 kΩ safe-side inactive-default pulldowns.')
}
if ([regex]::Matches($motionContent, 'SN74LXC4T245-class').Count -ne 2) {
    $errors.Add('Sheet 05 must contain exactly two independent four-channel translator branches.')
}
foreach ($requiredExpression in @('R_OK = RPWM AND NOT LPWM', 'L_OK = LPWM AND NOT RPWM', 'EN = PERMIT AND NOT INHIBIT')) {
    if (-not $motionContent.Contains($requiredExpression)) {
        $errors.Add("Sheet 05 is missing required safety expression: $requiredExpression.")
    }
}
if ($motionContent -match '\(hierarchical_label "[^"]*GPIO\d+' -or
    $motionContent -match '"(LIMIT_LEFT|LIMIT_RIGHT|LIMIT_UP|LIMIT_DOWN|POSITION_[^"]*)"' -or
    $motionContent -match '"OUTPUT_FAULT_SUMMARY"') {
    $errors.Add('Sheet 05 contains an ADR-043-rejected raw GPIO, limit/position, or fault-summary interface.')
}

$safetyFile = Join-Path $sheetDirectory '04_Safety_Inputs.kicad_sch'
$safetyContent = Get-Content -LiteralPath $safetyFile -Raw
$supervisedInputs = @('STOP_IN', 'LIMIT_LEFT', 'LIMIT_RIGHT', 'LIMIT_UP', 'LIMIT_DOWN')
foreach ($inputName in $supervisedInputs) {
    if ($safetyContent -notmatch [regex]::Escape($inputName + '_RAW') -or
        $safetyContent -notmatch [regex]::Escape($inputName + '_COND') -or
        $safetyContent -notmatch [regex]::Escape($inputName + '_SENSE') -or
        $safetyContent -notmatch [regex]::Escape($inputName + '_FAULT')) {
        $errors.Add("Sheet 04 supervised channel $inputName is incomplete.")
    }
}

if ([regex]::Matches($safetyContent, '2\.20 kΩ ±1% loop excitation').Count -ne 5) {
    $errors.Add('Sheet 04 must contain exactly five 2.20 kΩ supervised-loop excitation resistors.')
}
if ([regex]::Matches($safetyContent, '100 nF X7R/C0G, τ=100 µs').Count -ne 5) {
    $errors.Add('Sheet 04 must contain exactly five 100 µs supervised-loop filters.')
}
foreach ($rejectedExport in @('INPUT_FAULT_SUMMARY')) {
    if ($rootContent -match '\(pin "' + [regex]::Escape($rejectedExport) + '"' -or
        $safetyContent -match '\(hierarchical_label "' + [regex]::Escape($rejectedExport) + '"') {
        $errors.Add("ADR-042 rejects hierarchical export $rejectedExport.")
    }
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
Write-Host 'ADR-041 MAIN_POWER_GOOD: Sheet 02 to Sheet 06; absent from Sheet 03'
Write-Host 'ADR-042 safety inputs: five supervised NC loops; local-only fault diagnostics'
Write-Host 'ADR-043 motion interfaces: eight MCU commands and eight safe outputs; no fault summary'
Write-Host 'ADR-044 watchdog service: GPIO42 / Sheet 03 to Sheet 06; GPIO37 reserve preserved'
Write-Host 'ECO-001 authorization connectivity: ACTUATOR_PERMIT and MASTER_INHIBIT attached to U3'
Write-Host 'ECO-002 authorization defaults: PERMIT fail-low and INHIBIT fail-high with local 100 kΩ bias'
Write-Host 'Package 06R motion conditioning: dual independent translators, opposing-PWM suppression, safe-side defaults'
Write-Host 'Component symbols: confined to implemented Sheets 01 through 05'
Write-Host 'Footprint assignments: 0'
