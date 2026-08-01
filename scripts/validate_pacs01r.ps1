[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
function Assert-True([bool]$Condition,[string]$Message){if(-not $Condition){throw $Message}}
$review=Get-Content (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R_Power_Active_Component_Selection_Revalidation.md') -Raw
$register=@(Import-Csv (Join-Path $RepositoryRoot 'docs/reviews/PACS-01R_Active_Device_Register.csv'))
$ebom=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'))
$avl=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'))
$pas=@(Import-Csv (Join-Path $RepositoryRoot 'docs/analysis/passives/PAS-01R_Disposition_Register.csv'))
$refs=@('Q101','U101','U102','U201','U202','U203','U204','U205','U206','U207','U208','U209','U210','U211','U212','U213','U302','U706','U707','U801')
Assert-True ($register.Count -eq 20 -and @($register.Reference|Sort-Object -Unique).Count -eq 20) 'PACS-01R register must contain 20 unique active references.'
Assert-True (@($refs|Where-Object{$_ -notin $register.Reference}).Count -eq 0) 'PACS-01R inventory reference missing.'
Assert-True (@($register|Where-Object{$_.'Final Disposition' -ne 'BLOCKED'}).Count -eq 0) 'PACS-01R must retain all active rows blocked.'
foreach($field in @('Sheet','Function / Current Schematic Value','Preferred MPN','Package','Original PACS-01 Disposition','ECO-010 Effect','Final Disposition','Blocking Evidence')){Assert-True (@($register|Where-Object{[string]::IsNullOrWhiteSpace($_.$field)}).Count -eq 0) "PACS-01R register field missing: $field"}
foreach($ref in $refs){$e=$ebom|Where-Object Reference -eq $ref|Select-Object -First 1;Assert-True ($null-ne$e) "EBOM missing $ref";Assert-True ($e.'Freeze Status' -eq 'BLOCKED' -and $e.Risk -match 'PACS-01R: BLOCKED') "$ref BOM disposition mismatch";$a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1;Assert-True ($null-ne$a -and $a.'Freeze Status' -eq 'BLOCKED' -and $a.'Manufacturer Part Number' -eq $e.'Manufacturer Part Number') "$ref AVL mismatch"}
$s01=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/01_Power_Entry.kicad_sch') -Raw
$s08=Get-Content (Join-Path $RepositoryRoot 'hardware/kicad/sheets/08_Expansion.kicad_sch') -Raw
Assert-True ($s01 -match 'TPS26631PWPR' -and $s01 -notmatch 'TPS26630PWPR') 'U101 corrected implementation mismatch.'
Assert-True ($s08 -match 'TPS3899DL01DSER' -and $s08 -notmatch 'TLV841') 'U801 corrected implementation mismatch.'
Assert-True (@($ebom|Where-Object{$_.'Manufacturer Part Number' -match 'TPS26630PWPR|TLV841'}).Count -eq 0) 'Obsolete active implementation remains in EBOM.'
Assert-True (@($pas|Where-Object{$_.'Final Disposition' -match 'ACTIVE DEVICE SELECTION REQUIRED|active selection pending'}).Count -eq 0) 'A dependent passive remains generically blocked by active selection.'
foreach($ref in @('C805','R807','R808','R809')){$p=$pas|Where-Object Reference -eq $ref|Select-Object -First 1;Assert-True ($p.'Dependent Active Device' -eq 'U801 TPS3899DL01DSER') "$ref retains a stale supervisor dependency"}
Assert-True ($review -match '17 original PACS dependencies' -and $review -match 'C102/C103/C104/C109/L101' -and $review -match 'C201–C205/L201') 'Dependent-passive disposition is incomplete.'
foreach($token in @('93.1 nF','99.642 ms','79.1–136.6 ms','75–150 ms','76–149 ms','## 21. Retired Components')){Assert-True ($review.Contains($token)) "PACS-01R evidence token missing: $token"}
Assert-True ([regex]::Matches($review,'(?m)^## (?:[1-9]|1[0-9]|2[0-7])\. ').Count -eq 27) 'PACS-01R must contain 27 numbered sections.'
Assert-True ([regex]::Matches($review,'(?m)^# PACS-01R (?:ACCEPTED|NOT ACCEPTED)$').Count -eq 1) 'PACS-01R must contain exactly one final decision.'
Assert-True ($review -match '(?m)^# PACS-01R NOT ACCEPTED$') 'PACS-01R decision mismatch.'
Assert-True ($review -match 'PPC-01 and CSR-01A-R5 are not authorized') 'Downstream gate missing.'
$changed=@(git -C $RepositoryRoot diff --name-only 10d7e78)
foreach($path in $changed){Assert-True ($path -notmatch '\.kicad_sch$|\.kicad_pcb$|docs/decisions/|docs/adr/|docs/icd/|docs/connectors/') "Prohibited PACS-01R change: $path"}
& (Join-Path $RepositoryRoot 'scripts/validate_eco010.ps1') -RepositoryRoot $RepositoryRoot
if(-not $?){throw 'ECO-010 regression failed'}
Write-Host 'PACS-01R validation passed: 20 active references; 20 blocked; decision NOT ACCEPTED; no CAD changes.'
