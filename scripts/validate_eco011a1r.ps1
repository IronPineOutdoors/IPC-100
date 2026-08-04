[CmdletBinding()]
param([string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference = 'Stop'
function Assert([bool]$ok,[string]$message){if(-not $ok){throw $message}}

$sheetPath=Join-Path $RepositoryRoot 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'
$sheet=Get-Content -Raw -Encoding UTF8 $sheetPath
$report=Get-Content -Raw -Encoding UTF8 (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-011A1R_Safety_Input_Physical_Decomposition.md')

Assert ([regex]::Matches($report,'(?m)^# ECO-011A1R COMPLETE . ECO-011A2 AUTHORIZED\r?$').Count -eq 1) 'ECO-011A1R requires exactly one COMPLETE decision.'
foreach($obsolete in @('IPC100:WINDOW','IPC100:CMDREC','U401AB','U401CD','U402AB','U402CD','U403AB','U403C','U403D','LM339')){Assert (-not $sheet.Contains($obsolete)) "Obsolete Sheet 04 composite remains: $obsolete"}
foreach($ref in @('U404','U405','U406','U407','U408','U409','U410','U411')){Assert ($sheet -match ('property "Reference" "'+$ref+'"')) "Missing active reference $ref"}
foreach($mpn in @('TLV7044QPWRQ1','SN74LVC08AQPWRQ1','SN74LVC14AQPWRQ1','SN74LVC1G17QDBVRQ1')){Assert ($sheet.Contains($mpn)) "Missing exact MPN $mpn"}

foreach($ref in @('U406','U407','U408','U409','U410')){
    $units=@([regex]::Matches($sheet,'\(reference "'+$ref+'"\) \(unit (\d+)\)')|ForEach-Object{$_.Groups[1].Value})
    Assert ($units.Count -eq 5 -and ($units|Sort-Object -Unique).Count -eq 5) "$ref does not contain four unique functional units and one power unit."
}
$u411=@([regex]::Matches($sheet,'\(reference "U411"\) \(unit (\d+)\)')|ForEach-Object{$_.Groups[1].Value})
Assert ($u411.Count -eq 7 -and ($u411|Sort-Object -Unique).Count -eq 7) 'U411 does not contain six unique gates and one power unit.'
Assert ([regex]::Matches($sheet,'2\.20 kΩ ±1% loop excitation').Count -eq 5) 'Five loop excitations not preserved.'
Assert ([regex]::Matches($sheet,'100 nF X7R/C0G, τ=100 µs').Count -eq 5) 'Five supervised filters not preserved.'
Assert ([regex]::Matches($sheet,'499 kΩ ±1% external hysteresis').Count -eq 12) 'Twelve comparator hysteresis networks required.'
Assert ([regex]::Matches($sheet,'10\.0 kΩ ±1% open-drain pull-up').Count -eq 7) 'Seven open-drain pull-ups required.'
Assert ([regex]::Matches($sheet,'100 kΩ fail-low').Count -eq 7) 'Seven qualification defaults required.'
Assert ([regex]::Matches($sheet,'100 nF X7R package-local bypass').Count -eq 6) 'Six multi-unit package bypass capacitors required.'
foreach($c in @('C430','C431')){Assert ($sheet.Contains($c)) "Missing single-gate bypass $c"}
Assert ([regex]::Matches($sheet,'property "Reference" "TP4\d\d"').Count -eq 38) 'TP401-TP438 DFT allocation incomplete.'
Assert ($sheet.Contains('10.0 kΩ ±1% FIELD_OK bottom; POR ordering')) 'FIELD_OK POR ordering network absent.'
Assert (-not [regex]::IsMatch($sheet,'\(property "Footprint" "[^\"]+"')) 'Footprint assigned in Sheet 04.'

$currentPorts=@([regex]::Matches($sheet,'hierarchical_label "([^"]+)"')|ForEach-Object{$_.Groups[1].Value}|Sort-Object)
$baseline=git -C $RepositoryRoot show 'ba35b9e:hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'
$baselinePorts=@([regex]::Matches(($baseline -join "`n"),'hierarchical_label "([^"]+)"')|ForEach-Object{$_.Groups[1].Value}|Sort-Object)
Assert (($currentPorts -join '|') -eq ($baselinePorts -join '|')) 'Sheet 04 hierarchy ports changed.'

$ebom=Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv')
$population=Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_Prototype_Population.csv')
$avl=Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv')
Assert ($ebom.Count -eq 408 -and $population.Count -eq 408 -and $avl.Count -eq 408) 'EBOM/AVL/population row count must be 408.'
foreach($ref in @('U406','U407','U408','U409','U410','U411')){Assert (@($ebom|Where-Object Reference -eq $ref).Count -eq 1) "EBOM physical identity error for $ref"}
Assert (@($ebom|Where-Object {$_.Reference -match '^U40[1-3]' -or $_.Reference -in @('U401AB','U401CD','U402AB','U402CD','U403AB','U403C','U403D')}).Count -eq 0) 'Retired composite exists in EBOM.'
Assert ((($population.Reference|Sort-Object) -join '|') -eq (($ebom.Reference|Sort-Object) -join '|')) 'Population references differ from EBOM.'
Assert ((($avl.Item|Sort-Object) -join '|') -eq (($ebom.Item|Sort-Object) -join '|')) 'AVL items differ from EBOM.'

$pcb=Get-ChildItem $RepositoryRoot -Recurse -Filter '*.kicad_pcb'
Assert ($pcb.Count -eq 0) 'PCB file created.'
$changed=@(git -C $RepositoryRoot diff --name-only ba35b9e)
foreach($path in $changed){
    Assert ($path -notmatch '^hardware/kicad/sheets/(?!04_Safety_Inputs\.kicad_sch$).*\.kicad_sch$') "Unauthorized schematic changed: $path"
    Assert ($path -notmatch '^docs/(decisions|interfaces)/') "ADR/ICD changed: $path"
}
& (Join-Path $PSScriptRoot 'validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Output 'ECO-011A1R validation passed: seven composites retired; physical comparator/logic/passive implementation complete; 408 synchronized rows; zero footprints/PCB/interface changes.'
