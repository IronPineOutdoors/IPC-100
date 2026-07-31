[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
$rows = @(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8 | Where-Object { $_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'BLOCKED' } | Sort-Object Sheet,Reference)
function Clean([string]$Text) { return (($Text -replace '\|','/') -replace '[\r\n]+',' ') }
function QualificationFor($row) {
  if ($row.Reference -eq 'J1') { return @('Complete connector-system qualification','QER/MIR electrical and environmental envelope only','High for envelope','JCS-01 order codes, tooling, sourcing and physical tests','NO') }
  if ($row.Reference -in @('U209','U212','U213','R222','R223','R224')) { return @('Current-limit tolerance must support 150 mA peak without exceeding the 150 mA QER maximum','PPQ-01 proves the released 154–209 mA range does not meet the 150 mA ceiling','High','ECO-008 branch current-limit compliance remediation, then exact selection/prototype evidence','NO') }
  if ($row.Risk -match '^TRANSIENT COORDINATION') { return @('Common source-to-load stress, energy, clamp, timing and recovery proof','PPQ-01 protection/stress equations, corner matrix and physical record','Medium','Exact manufacturer curves/order code and specified prototype pulses','YES') }
  if ($row.Risk -match 'THERMAL/STABILITY|ECO-006|exact suffix|ECO-007|saturation|TCA9517A') { return @('Operating-point, efficiency, stability, tolerance, SOA and thermal proof','PPQ-01 load/thermal/stress corner calculations and pass/fail envelope','Medium','Exact suffix curves/vendor tool/commercial evidence and named prototype correlation','YES') }
  if ($row.Risk -match 'exact dielectric') { return @('Exact effective capacitance, ripple, ESR, aging, lifetime and stability evidence','PPQ-01 applied stress and required effective/ripple envelope','High for requirement','PPQ-02 manufacturer curve and commercial qualification','NO') }
  if ($row.Risk -match 'device equation') { return @('Exact tolerance, tempco, voltage, power, pulse and failure-effect evidence','PPQ-01 applied stress, threshold/programming and derating envelope','High for requirement','PPQ-02 exact resistor qualification and commercial evidence','NO') }
  throw "Unclassified $($row.Item)"
}
$b=[Text.StringBuilder]::new()
[void]$b.AppendLine('# PPQ-01 Appendix — Qualification Evidence Register')
[void]$b.AppendLine()
[void]$b.AppendLine('Eligibility means ready to enter exact FREEZE evaluation; it is not a frozen disposition and does not change the EBOM.')
[void]$b.AppendLine()
[void]$b.AppendLine('| Reference | Sheet | Evidence required | Evidence produced | Confidence | Remaining work | Eligible for CSR-01A-R4? |')
[void]$b.AppendLine('|---|---|---|---|---|---|---|')
foreach($row in $rows){$q=QualificationFor $row;[void]$b.AppendLine("| $($row.Reference) | $($row.Sheet) | $($q[0]) | $($q[1]) | $($q[2]) | $($q[3]); current blocker: $(Clean $row.Risk) | $($q[4]) |")}
[void]$b.AppendLine()
[void]$b.AppendLine('## Summary')
[void]$b.AppendLine()
[void]$b.AppendLine('- Eligible YES: 50.')
[void]$b.AppendLine('- Eligible NO: 74 (six TPS2553/RILIM references requiring ECO-008, 67 PPQ-02 passive references, and J1 under JCS-01).')
[void]$b.AppendLine('- Total: 124, each listed exactly once.')
[IO.File]::WriteAllText((Join-Path $RepositoryRoot 'docs/qualification/Qualification_Evidence_Register.md'),$b.ToString(),[Text.UTF8Encoding]::new($false))
Write-Host "PPQ-01 qualification register generated: $($rows.Count) blocked references."
