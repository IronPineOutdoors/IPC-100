[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$ebomPath=Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv';$avlPath=Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$ebom=@(Import-Csv $ebomPath -Encoding UTF8);$avl=@(Import-Csv $avlPath -Encoding UTF8)
$e=$ebom|Where-Object {$_.Sheet -eq '03_ESP32_Core' -and $_.Reference -eq 'C305'}|Select-Object -First 1
if($null -eq $e){throw 'C305 EBOM row missing.'}
$value='93.1 nF ±1% C0G/NP0 ≥10 V; CT; 99.642 ms nominal; leakage ≤10 nA; -40..125 C'
$reason='ECO-009 nominal correction complete. BLOCKED pending exact U302 suffix and an accepted minimum/maximum reset-release window; manufacturer/device plus capacitor envelope is approximately 79.1..136.6 ms.'
$e.Function=$value;$e.Description=$value;$e.Value=$value;$e.Package='UNRESOLVED - NO FOOTPRINT ASSIGNED';$e.'Operating Voltage'='≥10 V rated; approximately 1.29 V maximum CT threshold'
$e.'Maximum Current'='1.35 µA CT charge current maximum plus leakage';$e.'Rating or Tolerance'='93.1 nF ±1%; C0G/NP0; timing critical; leakage ≤10 nA'
$e.'Temperature Range'='-40 °C to +125 °C minimum';$e.'Freeze Status'='BLOCKED';$e.'Selection Rationale'=$reason;$e.Risk=$reason;$e.'Sourcing Risk'='BLOCKED'
$e.'Requirement Trace Reference'='ECO-009; PAS-01R; TPS3890-Q1 SBVS303B';$e.'Datasheet URL'='https://www.ti.com/lit/ds/symlink/tps3890-q1.pdf';$e.'Datasheet Revision or Date'='SBVS303B; reviewed 2026-07-31';$e.Notes=$reason
$a=$avl|Where-Object {$_.Item -eq $e.Item}|Select-Object -First 1
if($null -eq $a){throw 'C305 AVL row missing.'}
$a.'Freeze Status'='BLOCKED';$a.'Sourcing Risk'='BLOCKED';$a.'Requirement Trace Reference'=$e.'Requirement Trace Reference';$a.Risk=$reason;$a.'Review Date'='2026-07-31'
$ebom|Export-Csv $ebomPath -NoTypeInformation -Encoding UTF8;$avl|Export-Csv $avlPath -NoTypeInformation -Encoding UTF8
Write-Host 'ECO-009 C305 BOM/AVL overlay applied.'
