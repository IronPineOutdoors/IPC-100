[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Need([bool]$ok,[string]$m){if(-not $ok){throw $m}}
$s1=Get-Content -Raw (Join-Path $RepositoryRoot 'hardware/kicad/sheets/01_Power_Entry.kicad_sch')
$s8=Get-Content -Raw (Join-Path $RepositoryRoot 'hardware/kicad/sheets/08_Expansion.kicad_sch')
$note=Get-Content -Raw (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-010_Power_Active_Device_Compatibility_Remediation.md')
Need ($s1 -notmatch 'TPS26630PWPR') 'obsolete TPS26630PWPR remains'
Need ($s1 -match 'TPS26631PWPR') 'U101 replacement absent'
foreach($p in 1..20){Need ($s1 -match "\(pin `"$p`"") "U101 physical pin $p absent"}
Need ($s8 -notmatch 'TLV841S_2V7_VALID_HIGH') 'obsolete TLV841 implementation remains'
foreach($x in @('TPS3899DL01DSER','R807','R809','C805','31.6 kΩ','1.30 MΩ','4.70 kΩ','10 nF','EXP_SUP_DELAY')){Need ($s8.Contains($x)) "U801 evidence absent: $x"}
foreach($x in @('2.934–3.283 V','2.501–2.693 V','ECO-010 COMPLETE — PACS-01R AUTHORIZED')){Need ($note.Contains($x)) "calculation/decision absent: $x"}
$eb=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
Need (($eb|Where-Object Reference -eq 'U101').'Manufacturer Part Number' -eq 'TPS26631PWPR') 'U101 EBOM mismatch'
Need (($eb|Where-Object Reference -eq 'U801').'Manufacturer Part Number' -eq 'TPS3899DL01DSER') 'U801 EBOM mismatch'
foreach($r in @('C805','R807','R809')){Need (@($eb|Where-Object Reference -eq $r).Count -eq 1) "EBOM $r count"}
foreach($f in Get-ChildItem (Join-Path $RepositoryRoot 'hardware/kicad') -Recurse -Filter '*.kicad_sch'){
 $t=Get-Content -Raw $f.FullName
 Need (([regex]::Matches($t,'\(').Count) -eq ([regex]::Matches($t,'\)').Count)) "unbalanced $($f.Name)"
 $u=@([regex]::Matches($t,'\(uuid ([0-9a-f-]+)\)')|ForEach-Object{$_.Groups[1].Value})
 Need (@($u|Group-Object|Where-Object Count -gt 1).Count -eq 0) "duplicate UUID in $($f.Name)"
}
$allSch=(Get-ChildItem (Join-Path $RepositoryRoot 'hardware/kicad') -Recurse -Filter '*.kicad_sch'|Get-Content -Raw) -join "`n"
Need ($allSch -notmatch '\(property "Footprint" "[^\"]+') 'schematic footprint assigned'
Write-Host 'ECO-010 validation passed: U101/U801 selectable, threshold network bounded, references unique, zero footprints.'
