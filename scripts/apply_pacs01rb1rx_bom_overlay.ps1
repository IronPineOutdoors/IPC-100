[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$ep=Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv';$ap=Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$ebom=@(Import-Csv $ep -Encoding UTF8);$avl=@(Import-Csv $ap -Encoding UTF8)
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
$suffix=' PACS-01R-B1R-X: external tool, authoritative thermal and authenticated commercial artifacts remain open; see docs/evidence/External_Evidence_Acquisition_Inventory.csv.'
foreach($ref in $refs){$e=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1;if($null-eq$e){throw "Missing $ref"};$base=$e.Risk;while($base.EndsWith($suffix)){$base=$base.Substring(0,$base.Length-$suffix.Length)};$e.Risk="$base$suffix";$e.Notes=$e.Risk;$e.'Requirement Trace Reference'='PACS-01R-B1R-X; External_Evidence_Acquisition_Inventory';$e.'Freeze Status'='BLOCKED';$e.'Sourcing Risk'='BLOCKED - EXTERNAL EVIDENCE ACQUISITION';$a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1;if($null-eq$a){throw "AVL missing $($e.Item)"};$a.Risk=$e.Risk;$a.'Freeze Status'='BLOCKED';$a.'Sourcing Risk'=$e.'Sourcing Risk';$a.'Review Date'='2026-08-01'}
$ebom|Export-Csv $ep -NoTypeInformation -Encoding UTF8;$avl|Export-Csv $ap -NoTypeInformation -Encoding UTF8
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $ep (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.xlsx');& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $ap (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.xlsx');if($LASTEXITCODE-ne 0){throw 'XLSX regeneration failed'}
Write-Host 'PACS-01R-B1R-X BOM/AVL evidence routing applied.'
