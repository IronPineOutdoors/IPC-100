[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$path = Join-Path $repo 'docs/mechanical/MIR-01_J1_Mechanical_Interface_Release.md'
if (-not (Test-Path -LiteralPath $path)) { throw 'MIR-01 release document is missing.' }
$content = Get-Content -LiteralPath $path -Raw

foreach ($token in @(
    'MIR-01 ACCEPTED', 'CSR-01A-R2 Power Component Selection Final Pass is authorized',
    'Pin 1 `VIN_RAW`; Pin 2 `GND`', '9.0–21.0 VDC', 'At least 30 VDC',
    '18 AWG', '1.0 m maximum', '0.50 V maximum', 'At least 100 complete mate/unmate cycles',
    'At least 20 N', 'right-angle', 'positive-latch', 'Intentional live mating prohibited',
    'No footprint is selected or authorized by MIR-01'
)) {
    if (-not $content.Contains($token)) { throw "MIR-01 required release token missing: $token" }
}

$decisions = [regex]::Matches($content, '(?m)^# MIR-01 (?:ACCEPTED|NOT ACCEPTED)$')
if ($decisions.Count -ne 1) { throw "MIR-01 must contain exactly one final decision; found $($decisions.Count)." }

Write-Host 'MIR-01 J1 mechanical-interface validation passed.'
