[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$ebomPath=Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'
$avlPath=Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$pasPath=Join-Path $RepositoryRoot 'docs/analysis/passives/PAS-01R_Disposition_Register.csv'
$ebom=@(Import-Csv $ebomPath -Encoding UTF8);$avl=@(Import-Csv $avlPath -Encoding UTF8)
$pas=@(Import-Csv $pasPath -Encoding UTF8)
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
foreach($ref in $refs){
  $row=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1
  if($null-eq$row){throw "Missing active reference $ref"}
  $row.'Freeze Status'='BLOCKED';$row.'Sourcing Risk'='BLOCKED - PACS-01R-A EVIDENCE CLOSURE'
  $row.'Requirement Trace Reference'='PACS-01R; PACS-01R-A; PPQ-02; applicable QER/ECO'
  $suffix=' PACS-01R: BLOCKED - exact active candidate retained; thermal/tool, dependent-passive, prototype, alternate, and current commercial evidence closure required.'
  $baseRisk=$row.Risk
  while($baseRisk.EndsWith($suffix)){$baseRisk=$baseRisk.Substring(0,$baseRisk.Length-$suffix.Length)}
  $row.Risk="$baseRisk$suffix"
  if($row.PSObject.Properties.Name -contains 'Notes'){$row.Notes=$row.Risk}
  $a=$avl|Where-Object Item -eq $row.Item|Select-Object -First 1
  if($null-eq$a){throw "AVL missing $($row.Item)"}
  $a.'Freeze Status'='BLOCKED';$a.'Sourcing Risk'=$row.'Sourcing Risk';$a.Risk=$row.Risk;$a.'Review Date'='2026-08-01'
}
$dependencies=@{
  C102='U101 TPS26631PWPR';C103='U101 TPS26631PWPR';C104='U101 TPS26631PWPR';C109='U101 TPS26631PWPR';L101='U101 TPS26631PWPR'
  C201='U201 LMR38020FSQDDARQ1';C202='U201 LMR38020FSQDDARQ1';C203='U201 LMR38020FSQDDARQ1';C204='U201 LMR38020FSQDDARQ1';C205='U201 LMR38020FSQDDARQ1';L201='U201 LMR38020FSQDDARQ1'
  C206='U202 TPS2121RUXR / U203 TPS62135RGXR';C208='U203 TPS62135RGXR';C209='U203 TPS62135RGXR';C210='U203 TPS62135RGXR';L202='U203 TPS62135RGXR'
  R808='U801 TPS3899DL01DSER';C805='U801 TPS3899DL01DSER';R807='U801 TPS3899DL01DSER';R809='U801 TPS3899DL01DSER'
}
foreach($ref in $dependencies.Keys){
  $p=$pas|Where-Object Reference -eq $ref|Select-Object -First 1;if($null-eq$p){throw "PAS-01R missing $ref"}
  $p.'Dependent Active Device'=$dependencies[$ref]
  $p.'Evidence Confidence'='MEDIUM - exact active MPN selected; manufacturer tool/curve or prototype evidence remains'
  $p.'Final Disposition'='BLOCKED - EXACT TOOL/CURVE EVIDENCE REQUIRED'
  $p.'Closure Route'='PACS-01R-A - close named manufacturer tool/curve, thermal or threshold evidence'
  $e=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1;if($null-eq$e){throw "EBOM missing dependent passive $ref"}
  $e.Risk="PAS-01R: BLOCKED - exact active MPN selected; named manufacturer tool/curve, thermal, magnetic or threshold evidence remains under PACS-01R-A."
  if($e.PSObject.Properties.Name -contains 'Notes'){$e.Notes=$e.Risk}
  $a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1;if($null-eq$a){throw "AVL missing $($e.Item)"};$a.Risk=$e.Risk
}
$ebom|Export-Csv $ebomPath -NoTypeInformation -Encoding UTF8
$avl|Export-Csv $avlPath -NoTypeInformation -Encoding UTF8
$pas|Export-Csv $pasPath -NoTypeInformation -Encoding UTF8
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $ebomPath (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.xlsx')
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $avlPath (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.xlsx')
if($LASTEXITCODE-ne 0){throw 'XLSX regeneration failed'}
Write-Host 'PACS-01R blocked BOM/AVL overlay applied to 20 active references.'
