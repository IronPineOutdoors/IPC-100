[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}

$expected=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
$reg=@(Import-Csv (Join-Path $RepositoryRoot 'docs/reviews/PACS-01_Active_Device_Register.csv') -Encoding UTF8)
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8)
$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv') -Encoding UTF8)
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01_Power_Active_Component_Selection.md') -Raw
Assert-True ($reg.Count-eq 20) "PACS-01 register must contain 20 rows; found $($reg.Count)."
Assert-True (@($reg|Group-Object Reference|Where-Object Count -ne 1).Count-eq 0) 'Duplicate active reference in PACS-01 register.'
Assert-True (@($expected|Where-Object {$_-notin $reg.Reference}).Count-eq 0) 'PACS-01 active scope mismatch.'
Assert-True (@($reg|Where-Object 'Review status' -eq 'CANDIDATE').Count-eq 18) 'Expected 18 reviewed candidates.'
Assert-True (@($reg|Where-Object 'Review status' -eq 'BLOCKED').Count-eq 2) 'Expected two hard blockers.'
Assert-True (($reg|Where-Object Reference -eq U101).'Preferred MPN' -match 'NOT ORDERABLE') 'U101 order-code blocker absent.'
Assert-True (($reg|Where-Object Reference -eq U801).'Preferred MPN' -match 'NO ACTIVE ORDERABLE') 'U801 availability blocker absent.'

foreach($r in $reg){
 $e=$ebom|Where-Object Reference -eq $r.Reference|Select-Object -First 1;$a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1
 Assert-True ($null-ne $e-and$null-ne $a) "Missing EBOM/AVL row: $($r.Reference)"
 Assert-True ($e.'Manufacturer Part Number'-eq$r.'Preferred MPN' -or $r.Reference -in @('U101','U801')) "EBOM MPN mismatch: $($r.Reference)"
 Assert-True ($a.'Manufacturer Part Number'-eq$e.'Manufacturer Part Number'-and$a.'Freeze Status'-eq'BLOCKED'-and$e.'Freeze Status'-eq'BLOCKED') "AVL/status mismatch: $($r.Reference)"
 Assert-True ($e.Package -notmatch 'Footprint:') "Footprint encoded in EBOM: $($r.Reference)"
}
Assert-True (@($reg|Where-Object {$_.'Preferred MPN'-eq'TPS2553QDBVRQ1'}).Count-eq 3) 'TPS2553 selected-reference count mismatch.'
foreach($token in @('active-high','141 kΩ','162.824–222.345 mA','TPS389030QDSERQ1','93.1 nF','99.642 ms','79.1–136.6 ms','TPS26630 is the 24-pin RGE','TLV841SCPH27YBHR','PPC-01, CSR-01A-R5')){Assert-True $doc.Contains($token) "PACS-01 evidence missing: $token"}
Assert-True ([regex]::Matches($doc,'(?m)^# PACS-01 (?:ACCEPTED|NOT ACCEPTED)$').Count-eq 1) 'PACS-01 must issue exactly one decision.'
Assert-True ($doc-match'(?m)^# PACS-01 NOT ACCEPTED$') 'PACS-01 decision mismatch.'

$rdr=Get-Content (Join-Path $RepositoryRoot 'docs/reference/Reference_Designator_Register.md') -Raw
foreach($ref in $expected){Assert-True ($rdr-match"\| ``$ref`` \|") "Reference register missing $ref."}
$changed=@(git -C $RepositoryRoot diff --name-only 1a6c11c)
$changed=@($changed|Where-Object{$_ -notin @('hardware/kicad/sheets/01_Power_Entry.kicad_sch','hardware/kicad/sheets/08_Expansion.kicad_sch')})
foreach($path in $changed){Assert-True ($path-notmatch'\.kicad_sch$|\.kicad_pcb$|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01 change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Host 'PACS-01 validation passed: 20 reviewed; 18 candidates; U101/U801 blocked; no CAD or footprint changes; decision NOT ACCEPTED.'
