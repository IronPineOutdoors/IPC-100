[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$reg=@(Import-Csv (Join-Path $RepositoryRoot 'docs/analysis/passives/PAS-01R_Disposition_Register.csv') -Encoding UTF8)
$ebomPath=Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'
$avlPath=Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$ebom=@(Import-Csv $ebomPath -Encoding UTF8)
$avl=@(Import-Csv $avlPath -Encoding UTF8)
foreach($r in $reg){
 $reason="PAS-01R: $($r.'Final Disposition'). $($r.'Closure Route'); required evidence: $($r.'PAS-01R Evidence Required')."
 $e=$ebom|Where-Object {$_.Sheet -eq $r.Sheet -and $_.Reference -eq $r.Reference}|Select-Object -First 1
 if($null -eq $e){throw "EBOM row missing: $($r.Sheet)/$($r.Reference)"}
 $e.'Freeze Status'='BLOCKED';$e.'Sourcing Risk'='BLOCKED';$e.Risk=$reason;$e.'Selection Rationale'=$reason
 $e.'Requirement Trace Reference'='PAS-01R; QER-01; PPQ-01; PPQ-02';$e.Notes=$reason;$e.'Datasheet Revision or Date'='PAS-01R evidence review 2026-07-31'
 $a=$avl|Where-Object {$_.Item -eq $e.Item}|Select-Object -First 1
 if($null -eq $a){throw "AVL row missing: $($e.Item)"}
 $a.'Freeze Status'='BLOCKED';$a.'Sourcing Risk'='BLOCKED';$a.Risk=$reason;$a.'Requirement Trace Reference'='PAS-01R; QER-01; PPQ-01; PPQ-02';$a.'Review Date'='2026-07-31'
}
$ebom|Export-Csv $ebomPath -NoTypeInformation -Encoding UTF8
$avl|Export-Csv $avlPath -NoTypeInformation -Encoding UTF8
Write-Host 'PAS-01R BOM overlay applied to 18 EBOM/AVL rows.'
