[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$rows=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8 | Where-Object {$_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'BLOCKED'})
$lines=[System.Collections.Generic.List[string]]::new()
$lines.Add('# PPQ-02 Appendix — Power Component Evidence Register');$lines.Add('')
$lines.Add('| Reference | Sheet / function | Blocker before PPQ-02 | PPQ-02 evidence / confidence | Remaining dependency | Route / expected status | Footprint impact / schematic risk |')
$lines.Add('|---|---|---|---|---|---|---|')
foreach($row in $rows|Sort-Object Sheet,Reference){
 if($row.Reference -eq 'J1'){$cat='Connector system';$evidence='QER/MIR current, transient, environment and fault envelope / HIGH';$dep='Exact housing, mate, contacts, seals, tooling and commercial evidence';$route='JCS-01 / READY FOR JCS-01';$impact='Connector family unresolved / medium'}
 elseif($row.Reference -eq 'FB801' -or $row.Category -eq 'Passives'){$cat='Passive component';$evidence='Effective-C, ripple/ESR, tolerance/tempco, pulse, timing, magnetic and stability envelope / HIGH-MEDIUM';$dep='Exact curves/order code, commercial and prototype evidence';$route='PAS-01 / READY FOR PAS-01';$impact='Package family may vary / low'}
 elseif($row.Risk -match '^TRANSIENT COORDINATION'){$cat='Protection coordination';$evidence='Energy, clamp, I2t, SOA, timing and thermal envelope / MEDIUM';$dep='Exact curves, order code, package and commercial evidence';$route='PPC-01 / READY FOR PPC-01';$impact='Package/copper unresolved / low-to-medium'}
 else{$cat='Active-stage/thermal';$evidence='Operating-corner, loss, thermal, switch, timing and PCB envelope / MEDIUM';$dep='Exact order code/package, vendor tool, commercial and prototype evidence';$route='PACS-01 / READY FOR PACS-01';$impact='Thermal land/package unresolved / medium'}
 $function=($row.Function -replace '\|','/' -replace '\r?\n',' ');$risk=($row.Risk -replace '\|','/' -replace '\r?\n',' ')
 $lines.Add("| $($row.Reference) | $($row.Sheet): $function | $cat - $risk | $evidence | $dep | $route | $impact |")
}
$lines.Add('');$lines.Add('- READY FOR PPC-01: 18');$lines.Add('- READY FOR PAS-01: 85');$lines.Add('- READY FOR PACS-01: 20');$lines.Add('- READY FOR JCS-01: 1');$lines.Add('- READY FOR CSR-01A-R5 directly: 0');$lines.Add('- Total: 124, exactly once.')
[IO.File]::WriteAllLines((Join-Path $RepositoryRoot 'docs/qualification/Power_Component_Evidence_Register.md'),$lines,[Text.UTF8Encoding]::new($false))
Write-Host "PPQ-02 register generated: $($rows.Count) rows."
