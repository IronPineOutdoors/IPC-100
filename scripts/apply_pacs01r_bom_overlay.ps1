[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$ebomPath=Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'
$avlPath=Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$ebom=@(Import-Csv $ebomPath -Encoding UTF8);$avl=@(Import-Csv $avlPath -Encoding UTF8)
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
foreach($ref in $refs){
  $row=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1
  if($null-eq$row){throw "Missing active reference $ref"}
  $row.'Freeze Status'='BLOCKED';$row.'Sourcing Risk'='BLOCKED - PACS-01R-A EVIDENCE CLOSURE'
  $row.'Requirement Trace Reference'='PACS-01R; PACS-01R-A; PPQ-02; applicable QER/ECO'
  $row.Risk="$($row.Risk) PACS-01R: BLOCKED - exact active candidate retained; thermal/tool, dependent-passive, prototype, alternate, and current commercial evidence closure required."
  if($row.PSObject.Properties.Name -contains 'Notes'){$row.Notes=$row.Risk}
  $a=$avl|Where-Object Item -eq $row.Item|Select-Object -First 1
  if($null-eq$a){throw "AVL missing $($row.Item)"}
  $a.'Freeze Status'='BLOCKED';$a.'Sourcing Risk'=$row.'Sourcing Risk';$a.Risk=$row.Risk;$a.'Review Date'='2026-08-01'
}
$ebom|Export-Csv $ebomPath -NoTypeInformation -Encoding UTF8
$avl|Export-Csv $avlPath -NoTypeInformation -Encoding UTF8
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $ebomPath (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.xlsx')
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $avlPath (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.xlsx')
if($LASTEXITCODE-ne 0){throw 'XLSX regeneration failed'}
Write-Host 'PACS-01R blocked BOM/AVL overlay applied to 20 active references.'
