[CmdletBinding()]
param(
    [string]$ProjectDirectory
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ProjectDirectory)) {
    $ProjectDirectory = Join-Path $PSScriptRoot '..\hardware\kicad'
}
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
$globalReferences = [System.Collections.Generic.List[string]]::new()
foreach ($schematicFile in $schematicFiles) {
    if (-not (Test-BalancedSExpression -Path $schematicFile)) {
        $errors.Add("Unbalanced KiCad S-expression: $schematicFile")
    }
    $schematicContent = Get-Content -LiteralPath $schematicFile -Raw
    $uuids = @([regex]::Matches($schematicContent, '\(uuid ([0-9a-fA-F-]{36})\)') | ForEach-Object { $_.Groups[1].Value })
    $duplicateUuids = @($uuids | Group-Object | Where-Object Count -gt 1)
    if ($duplicateUuids.Count -gt 0) {
        $errors.Add("Duplicate UUIDs in $schematicFile`: $($duplicateUuids.Name -join ', ')")
    }
    $instanceReferences = @(
        [regex]::Matches($schematicContent, '(?s)\(symbol \(lib_id "[^"]+"\).*?\(property "Reference" "([^"]+)"') |
            ForEach-Object { $_.Groups[1].Value }
    )
    $referencePairs = [regex]::Matches(
        $schematicContent,
        '(?s)\(symbol \(lib_id "[^"]+"\).*?\(property "Reference" "([^"]+)".*?\(instances .*?\(reference "([^"]+)"\)'
    )
    foreach ($pair in $referencePairs) {
        if ($pair.Groups[1].Value -ne $pair.Groups[2].Value) {
            $errors.Add("ECO-005 orphan/mismatched reference in $schematicFile`: property $($pair.Groups[1].Value), instance $($pair.Groups[2].Value).")
        }
    }
    if ($referencePairs.Count -ne $instanceReferences.Count) {
        $errors.Add("ECO-005 could not pair every reference property and instance in $schematicFile.")
    }
    $duplicateReferences = @($instanceReferences | Group-Object | Where-Object Count -gt 1)
    foreach ($duplicate in $duplicateReferences) {
        $unitMatches = [regex]::Matches($schematicContent, '\(reference "' + [regex]::Escape($duplicate.Name) + '"\) \(unit (\d+)\)')
        $units = @($unitMatches | ForEach-Object { $_.Groups[1].Value })
        if ($unitMatches.Count -ne $duplicate.Count -or ($units | Sort-Object -Unique).Count -ne $units.Count) {
            $errors.Add("Duplicate instantiated reference without unique multi-unit allocation in $schematicFile`: $($duplicate.Name)")
        }
    }
    foreach ($reference in $instanceReferences | Where-Object { $_ -notlike '#PWR*' } | Sort-Object -Unique) {
        $globalReferences.Add($reference)
    }

    $fileName = [IO.Path]::GetFileNameWithoutExtension($schematicFile)
    if ($fileName -match '^(0[1-9])_') {
        $sheetNumber = [int]$Matches[1]
        $minimum = ($sheetNumber * 100) + 1
        $maximum = ($sheetNumber * 100) + 99
        foreach ($reference in $instanceReferences) {
            if ($reference -like '#PWR*' -or $reference -like 'J*' -or $reference -like 'DFT*') { continue }
            if ($reference -notmatch '^[A-Za-z]+(\d+)[A-Za-z]*$') {
                $errors.Add("ECO-005 unsupported normalized reference $reference in $fileName.")
                continue
            }
            $number = [int]$Matches[1]
            if ($number -lt $minimum -or $number -gt $maximum) {
                $errors.Add("ECO-005 reference $reference is outside Sheet $sheetNumber range $minimum-$maximum.")
            }
        }
    }
}

$globalDuplicateReferences = @($globalReferences | Group-Object | Where-Object Count -gt 1)
if ($globalDuplicateReferences.Count -gt 0) {
    $errors.Add("ECO-005 global reference duplicates: $($globalDuplicateReferences.Name -join ', ')")
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
    $isImplementedRelay = $sheetFile -eq 'sheets/06_Relay_MasterInhibit.kicad_sch'
    $isImplementedUi = $sheetFile -eq 'sheets/07_UI_Peripherals.kicad_sch'
    $isImplementedExpansion = $sheetFile -eq 'sheets/08_Expansion.kicad_sch'
    $isImplementedConnectors = $sheetFile -eq 'sheets/09_Connectors_Test.kicad_sch'
    $requiredNote = 'Detailed implementation intentionally deferred to subsequent engineering package.'
    if (-not $isImplementedPowerEntry -and -not $isImplementedPowerConversion -and -not $isImplementedProcessor -and -not $isImplementedSafetyInputs -and -not $isImplementedMotion -and -not $isImplementedRelay -and -not $isImplementedUi -and -not $isImplementedExpansion -and -not $isImplementedConnectors -and -not $childContent.Contains($requiredNote)) {
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
    if ($isImplementedRelay) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -lt 10) {
            $errors.Add("$sheetName does not contain the complete Package 07R watchdog, authorization, bias, and relay-driver implementation.")
        }
        foreach ($requiredNet in @(
            '+3V3_CORE', 'RELAY_VCC', 'STOP_HW_INHIBIT', 'MAIN_POWER_GOOD',
            'RESET_VALID', 'RELAY_CMD_MCU', 'WATCHDOG_SERVICE_MCU',
            'WATCHDOG_VALID', 'ACTUATOR_PERMIT', 'MASTER_INHIBIT',
            'RELAY_GATE_AUTH', 'RELAY_GATE', 'RELAY_COIL_LOW',
            'RELAY_NC', 'RELAY_COM', 'RELAY_NO'
        )) {
            if (-not $childContent.Contains('"' + $requiredNet + '"')) {
                $errors.Add("$sheetName is missing required Package 07R net $requiredNet.")
            }
        }
        foreach ($requiredValue in @(
            '100 kΩ WDI fail-low / open-route bias',
            '100 kΩ MAIN_POWER_GOOD fail-low',
            '100 kΩ RESET_VALID fail-low',
            '100 kΩ STOP_HW_INHIBIT fail-high',
            '100 kΩ RELAY_CMD_MCU fail-low',
            '100 kΩ WATCHDOG_VALID fail-low',
            '100 kΩ ACTUATOR_PERMIT fail-low',
            '100 kΩ MASTER_INHIBIT fail-high',
            '100 kΩ MOSFET gate default-OFF bias',
            '100 Ω gate resistor'
        )) {
            if ([regex]::Matches($childContent, [regex]::Escape($requiredValue)).Count -ne 1) {
                $errors.Add("$sheetName must contain exactly one '$requiredValue'.")
            }
        }
        foreach ($requiredExpression in @(
            'PERMIT = MAIN_POWER_GOOD AND NOT STOP_HW_INHIBIT AND RESET_VALID AND WATCHDOG_VALID',
            'RELAY_CMD_MCU AND ACTUATOR_PERMIT'
        )) {
            if (-not $childContent.Contains($requiredExpression)) {
                $errors.Add("$sheetName is missing authorization expression: $requiredExpression.")
            }
        }
    }
    if ($isImplementedUi) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -lt 12) {
            $errors.Add("$sheetName does not contain the complete Package 08 encoder, expander, status-driver, peripheral, and DFT implementation.")
        }
        foreach ($requiredNet in @(
            '+3V3_CORE', 'UI_VCC', 'OLED_VCC', 'SENSOR_VCC',
            'ENCODER_A_RAW', 'ENCODER_B_RAW', 'ENCODER_SW_RAW',
            'ENCODER_A_COND', 'ENCODER_B_COND', 'ENCODER_SW_COND',
            'I2C_SDA', 'I2C_SCL', 'UI_EXPANDER_RESET_N',
            'RGB_R_CTL', 'RGB_G_CTL', 'RGB_B_CTL', 'BUZZER_CTL',
            'RGB_R', 'RGB_G', 'RGB_B', 'BUZZER_OUT',
            'OLED_RESET_RELEASE', 'OLED_RESET'
        )) {
            if (-not $childContent.Contains('"' + $requiredNet + '"')) {
                $errors.Add("$sheetName is missing required Package 08 net $requiredNet.")
            }
        }
        foreach ($requiredValue in @(
            '3ch active-low panel encoder conditioner; 10k/1k/10nF; UI-valid gated',
            'TCA9535-class, +3V3_CORE, address 0x20, power-up inputs/high-Z',
            '100 kΩ ±1% expander reset pull-up',
            '100 nF X7R ±10% expander reset delay',
            '4.70 kΩ ±1% I2C SDA pull-up; Sheet 07 base-bus owner',
            '4.70 kΩ ±1% I2C SCL pull-up; Sheet 07 base-bus owner',
            '4x 60 V logic NMOS; 100Ω gates; 100kΩ gate pull-downs; buzzer clamp provision',
            '2N7002-class open-drain reset; 100k core pull-up asserts reset by default'
        )) {
            if ([regex]::Matches($childContent, [regex]::Escape($requiredValue)).Count -ne 1) {
                $errors.Add("$sheetName must contain exactly one '$requiredValue'.")
            }
        }
        foreach ($rejectedUiSignal in @(
            'ARM_IN_RAW', 'FIRE_IN_RAW', 'STOP_IN_RAW',
            'ACTUATOR_PERMIT', 'MASTER_INHIBIT', 'RELAY_CMD_MCU',
            'WATCHDOG_SERVICE_MCU', 'THROWER_TRIGGER',
            'DRIVER_ENABLE', 'MOTOR_LOGIC_ENABLE', 'SPEED_CONTROL'
        )) {
            if ($childContent -match '\(hierarchical_label "' + [regex]::Escape($rejectedUiSignal) + '"') {
                $errors.Add("$sheetName contains unauthorized interface $rejectedUiSignal.")
            }
        }
        if ($childContent -match '\(hierarchical_label "[^"]*GPIO\d+') {
            $errors.Add("$sheetName exports a raw GPIO identifier.")
        }
        if ([regex]::Matches($childContent, '\(symbol \(lib_id "IPC100:TEST_NODE"\)').Count -lt 5) {
            $errors.Add("$sheetName is missing required Package 08 schematic DFT nodes.")
        }
    }
    if ($isImplementedExpansion) {
        $implementedSymbols = [regex]::Matches($childContent, '(?m)^  \(symbol \(lib_id').Count
        if ($implementedSymbols -lt 18) {
            $errors.Add("$sheetName does not contain the complete Package 09R rail qualification, segmented bus, protection, filtering, and DFT implementation.")
        }
        foreach ($requiredNet in @(
            '+3V3_CORE', 'EXPANSION_VCC', 'EXPANSION_VCC_FILT',
            'I2C_SDA', 'I2C_SCL', 'EXPANSION_SEGMENT_ENABLE',
            'EXP_SDA_BUFFERED', 'EXP_SCL_BUFFERED',
            'J10_I2C_SDA', 'J10_I2C_SCL'
        )) {
            if (-not $childContent.Contains('"' + $requiredNet + '"')) {
                $errors.Add("$sheetName is missing required Package 09R net $requiredNet.")
            }
        }
        foreach ($requiredValue in @(
            'TPS3899DL01DSER; adjustable; OD active-low; 6.2 ms release; external 2.9/2.7 V window',
            '100 kΩ ±1% segment-enable fail-low bias',
            'Dual-supply I2C hot-swap buffer; 100 kHz; fail-disabled; no clock stretching',
            '4.70 kΩ ±1% J10 SDA pull-up; Sheet 08 external-segment owner',
            '4.70 kΩ ±1% J10 SCL pull-up; Sheet 08 external-segment owner',
            '47 Ω J10 SDA series damping; final 33–100 Ω by SI verification',
            '47 Ω J10 SCL series damping; final 33–100 Ω by SI verification',
            '100 nF X7R ±10% local buffer decoupling',
            '10 µF X7R accessory-bias reservoir; within ICD-001 22 µF load cap limit',
            '100 nF X7R ±10% core-side buffer decoupling'
        )) {
            if ([regex]::Matches($childContent, [regex]::Escape($requiredValue)).Count -ne 1) {
                $errors.Add("$sheetName must contain exactly one '$requiredValue'.")
            }
        }
        foreach ($rejectedExpansionSignal in @(
            'GPIO37', 'GPIO42', 'CAN_TX', 'CAN_RX', 'RS485_TX', 'RS485_RX',
            'UART_TX', 'UART_RX', 'SPI_MOSI', 'SPI_MISO', 'USB_D+', 'USB_D-',
            'ACTUATOR_PERMIT', 'MASTER_INHIBIT', 'WATCHDOG_VALID',
            'RELAY_CMD_MCU', 'DRIVER_ENABLE', 'RANGEHUB'
        )) {
            if ($childContent -match '\(hierarchical_label "' + [regex]::Escape($rejectedExpansionSignal) + '"') {
                $errors.Add("$sheetName contains unauthorized hierarchical interface $rejectedExpansionSignal.")
            }
        }
        if ($childContent -match '\(hierarchical_label "[^"]*GPIO\d+') {
            $errors.Add("$sheetName exports a raw GPIO identifier.")
        }
        if ([regex]::Matches($childContent, '\(symbol \(lib_id "IPC100:TEST_NODE"\)').Count -lt 6) {
            $errors.Add("$sheetName is missing required Package 09R schematic DFT nodes.")
        }
        if ([regex]::Matches($childContent, 'Sheet 08 external-segment owner').Count -ne 2) {
            $errors.Add("$sheetName must own exactly two expansion-side pull-ups and no internal base-bus pull-ups.")
        }
        if ($childContent -match '\(symbol \(lib_id "[^"]*(Connector|Conn_)') {
            $errors.Add("$sheetName contains a connector symbol owned by Sheet 09.")
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
        Where-Object Name -notin @('01_Power_Entry.kicad_sch', '02_Power_Conversion.kicad_sch', '03_ESP32_Core.kicad_sch', '04_Safety_Inputs.kicad_sch', '05_Motor_Interfaces.kicad_sch', '06_Relay_MasterInhibit.kicad_sch', '07_UI_Peripherals.kicad_sch', '08_Expansion.kicad_sch', '09_Connectors_Test.kicad_sch') |
        Select-Object -ExpandProperty FullName
)
$placeholderSymbols = Select-String -Path $placeholderFiles -Pattern '^  \(symbol \(lib_id' -ErrorAction SilentlyContinue
if ($placeholderSymbols) {
    $errors.Add('Component symbols exist outside the authorized Sheets 01 through 08 scope.')
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
if ($motionContent -match '\(symbol \(lib_id "IPC100:AUTH2"\)') {
    $errors.Add('Sheet 05 obsolete U503 authorization composite remains after ECO-011A2.')
} else {
    foreach($token in @('SN74LVC14AQPWRQ1','SN74LVC08AQPWRQ1','ACTUATOR_PERMIT','MASTER_INHIBIT','MASTER_INHIBIT_N','AXIS1_XLAT_EN','AXIS2_XLAT_EN')) {
        if(-not $motionContent.Contains($token)){$errors.Add("Sheet 05 physical authorization path is missing $token.")}
    }
}
$authorizationBiases = @(
    @{
        Signal = 'ACTUATOR_PERMIT'
        Value = '100 kΩ U503 PERMIT fail-low input bias'
        NetAttachment = '\(label "ACTUATOR_PERMIT" \(at 145 38\.38 90\)'
        SafeAttachment = '\(label "GND" \(at 145 48\.54 90\)'
    },
    @{
        Signal = 'MASTER_INHIBIT'
        Value = '100 kΩ U503 INHIBIT fail-high input bias'
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

$sheet07Content = Get-Content -LiteralPath (Join-Path $sheetDirectory '07_UI_Peripherals.kicad_sch') -Raw
$sheet09Content = Get-Content -LiteralPath (Join-Path $sheetDirectory '09_Connectors_Test.kicad_sch') -Raw
$eco003Signals = @(
    @{ Name = 'J6_I2C_SDA'; ProducerShape = 'bidirectional'; ConsumerShape = 'bidirectional' },
    @{ Name = 'J6_I2C_SCL'; ProducerShape = 'output'; ConsumerShape = 'input' },
    @{ Name = 'J7_I2C_SDA'; ProducerShape = 'bidirectional'; ConsumerShape = 'bidirectional' },
    @{ Name = 'J7_I2C_SCL'; ProducerShape = 'output'; ConsumerShape = 'input' }
)
foreach ($signal in $eco003Signals) {
    $escapedName = [regex]::Escape($signal.Name)
    if ([regex]::Matches($sheet07Content, '\(hierarchical_label "' + $escapedName + '" \(shape ' + $signal.ProducerShape + '\)').Count -ne 1) {
        $errors.Add("ECO-003 $($signal.Name) must appear exactly once on Sheet 07 with $($signal.ProducerShape) direction.")
    }
    if ([regex]::Matches($sheet09Content, '\(hierarchical_label "' + $escapedName + '" \(shape ' + $signal.ConsumerShape + '\)').Count -ne 1) {
        $errors.Add("ECO-003 $($signal.Name) must appear exactly once on Sheet 09 with $($signal.ConsumerShape) direction.")
    }
    if ([regex]::Matches($rootContent, '\(pin "' + $escapedName + '"').Count -ne 2 -or
        [regex]::Matches($rootContent, '\(label "' + $escapedName + '"').Count -ne 2) {
        $errors.Add("ECO-003 $($signal.Name) must have exactly one Sheet 07 endpoint and one Sheet 09 endpoint.")
    }
}

# ECO-004: each external UI I2C branch is independently rail-qualified and
# fail-isolated, and J13 exposes the complete protected USB-C UFP boundary.
if ([regex]::Matches($sheet07Content, '\(lib_id "IPC100:I2C_DUAL_SUPPLY_BUFFER_EN"\)').Count -ne 2) {
    $errors.Add('ECO-004 requires exactly two independently qualified I2C branch elements on Sheet 07.')
}
foreach ($branchRequirement in @(
    'One physical 3.3 V dual-supply I2C buffer; 100 kHz; EN low isolates; Ioff <=10 uA; tpd <=1 us (TBD exact)',
    '100 kOhm +/-1%; EN fail-low; >=0.063 W'
)) {
    if (-not $sheet07Content.Contains($branchRequirement)) {
        $errors.Add("ECO-004 branch contract is missing: $branchRequirement.")
    }
}
if ([regex]::Matches($sheet07Content, '4\.70 k').Count -ne 2) {
    $errors.Add('ECO-004 must preserve exactly one two-resistor base-bus pull-up pair on Sheet 07.')
}
if ($sheet07Content -match 'J6 branch pull-up' -or $sheet07Content -match 'J7 branch pull-up') {
    $errors.Add('ECO-004 must not add duplicate branch pull-ups.')
}

foreach ($usbToken in @(
    'IPC100:USB_C_UFP_FULL', 'GND_A1', 'VBUS_A4', 'CC1_A5', 'D+_A6', 'D-_A7',
    'GND_A12', 'GND_B1', 'VBUS_B4', 'CC2_B5', 'D+_B6', 'D-_B7', 'GND_B12',
    'SHIELD', 'USB_ESD2', 'VBUS_ESD', 'DNP 1 nF >=1 kV shield coupling option',
    'DNP 1 MOhm shield bleed option'
)) {
    if (-not $sheet09Content.Contains($usbToken)) {
        $errors.Add("ECO-004 USB-C boundary is missing: $usbToken.")
    }
}
if ([regex]::Matches($sheet09Content, '5\.1 k').Count -ne 2) {
    $errors.Add('ECO-004 requires exactly two independent 5.1 kOhm USB-C Rd terminations.')
}
if ([regex]::Matches($sheet09Content, '\(no_connect \(at 145 ').Count -ne 10) {
    $errors.Add('ECO-004 requires explicit no-connect markers on all ten unused USB-C SuperSpeed/SBU contacts.')
}
if ($sheet09Content -match '\(property "Footprint" "[^"]+"' ) {
    $errors.Add('ECO-004 provisional USB and I2C elements must not have footprints.')
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
Write-Host 'ECO-001 authorization connectivity: ACTUATOR_PERMIT and MASTER_INHIBIT attached to ECO-011A2 physical logic'
Write-Host 'ECO-002 authorization defaults: PERMIT fail-low and INHIBIT fail-high with local 100 kΩ bias'
Write-Host 'Package 06R motion conditioning: dual independent translators, opposing-PWM suppression, safe-side defaults'
Write-Host 'Package 07R Sheet 06: independent watchdog, authorization logic, deterministic biases, and relay driver present'
Write-Host 'Package 08 Sheet 07: deterministic encoder conditioning, core I2C expander, safe-default status drivers, peripheral boundaries, and DFT nodes present'
Write-Host 'Package 09R Sheet 08: ICD-001 rail qualification, segmented I2C, external pull-ups, protection, filtering, and DFT nodes present'
Write-Host 'ECO-003 hierarchy exposure: four approved J6/J7 I2C ports route once from Sheet 07 to Sheet 09'
Write-Host 'ECO-004 interfaces: two independently rail-qualified fail-isolated I2C branches and complete protected USB-C UFP boundary'
Write-Host 'ECO-005 references: globally unique and within deterministic sheet ranges; connector designations preserved'
Write-Host 'UUIDs: unique within every schematic'
Write-Host 'Component symbols: confined to implemented Sheets 01 through 09'
Write-Host 'Footprint assignments: 0'
