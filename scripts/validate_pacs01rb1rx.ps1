[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$doc=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R-B1R-X_External_Evidence_Acquisition.md') -Raw
$inventory=@(Import-Csv (Join-Path $RepositoryRoot 'docs/evidence/External_Evidence_Acquisition_Inventory.csv'))
$queue=Get-Content (Join-Path $RepositoryRoot 'docs/evidence/Manual_External_Acquisition_Queue.md') -Raw
$commercial=@(Import-Csv (Join-Path $RepositoryRoot 'docs/evidence/commercial/PACS-01R-B1R_Commercial_Quote_Register.csv'))
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'));$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'))
Assert-True ($inventory.Count -eq 11 -and @($inventory.'Evidence ID'|Sort-Object -Unique).Count -eq 11) 'External evidence inventory mismatch.'
foreach($row in $inventory){foreach($field in @('References','MPN(s)','Category','Exact Source','Required Artifact','Format','Access Method','Acceptance Criteria','Status')){Assert-True (-not [string]::IsNullOrWhiteSpace($row.$field)) "Inventory missing $field/$($row.'Evidence ID')"}}
foreach($token in @('LMR38020FSQDDARQ1','TPS62135RGXR','2 A/100 ms','0.734 W','1.112 W','DigiKey and Mouser','SHA-256','no-substitution')){Assert-True ($queue.Contains($token)) "Manual queue token missing: $token"}
Assert-True ($commercial.Count -eq 13) 'Commercial register unique-MPN scope mismatch.'
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
foreach($ref in $refs){$e=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1;Assert-True ($e.Risk -match 'PACS-01R-B1R-X' -and $e.'Freeze Status' -eq 'BLOCKED') "$ref evidence routing mismatch";$a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1;Assert-True ($a.Risk -eq $e.Risk -and $a.'Freeze Status' -eq 'BLOCKED') "$ref AVL mismatch"}
foreach($section in 1..20){Assert-True ($doc -match "(?m)^## $section\. ") "Review section missing: $section"}
Assert-True ($doc -match '(?m)^# PACS-01R-B1R-X NOT ACCEPTED$' -and $doc -match 'PACS-01R-C and PPC-01 are not authorized') 'PACS-01R-B1R-X gate mismatch.'
$allText=(Get-ChildItem (Join-Path $RepositoryRoot 'docs/evidence') -Recurse -File|ForEach-Object{Get-Content $_.FullName -Raw}) -join "`n"
Assert-True ($allText -notmatch '(?i)(api[_-]?key|access[_-]?token|session[_-]?cookie|password)\s*[:=]\s*[^\s`"]{8,}') 'Potential credential material detected.'
$changed=@(git -C $RepositoryRoot diff --name-only 33973ba|Where-Object{$_ -ne 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'});foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/decisions/|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01R-B1R-X change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_pacs01rb1r.ps1') -RepositoryRoot $RepositoryRoot;if(-not $?){throw 'PACS-01R-B1R regression failed'}
Write-Host 'PACS-01R-B1R-X validation passed: external artifacts controlled; access limitations open; zero CAD changes.'
