[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}

$rows=@(
@{Ref='Q101';Mfr='Infineon';MPN='IAUC100N08S5N034ATMA1';Pkg='PG-TDSON-8 / SSO8 5x6';Alt='BUK7J2R4-80M';Cost='2.50';Status='CANDIDATE'},
@{Ref='U101';Mfr='UNRESOLVED - PACS-01 BLOCKED';MPN='UNRESOLVED - CAPTURED TPS26630PWPR IS NOT ORDERABLE';Pkg='Captured 20-pin PWP conflicts with TPS26630 24-pin RGE';Alt='TPS26633PWPR requires controlled variant review';Cost='';Status='BLOCKED'},
@{Ref='U102';Mfr='Texas Instruments';MPN='TPS259470LRPWR';Pkg='VQFN-HR-10 RPW';Alt='TPS259470ARPWR (functional, auto-retry)';Cost='1.53';Status='CANDIDATE'},
@{Ref='U201';Mfr='Texas Instruments';MPN='LMR38020FSQDDARQ1';Pkg='HSOIC-8 PowerPAD DDA';Alt='LMR38020SQDDARQ1 (functional, PFM)';Cost='4.56';Status='CANDIDATE'},
@{Ref='U202';Mfr='Texas Instruments';MPN='TPS2121RUXR';Pkg='VQFN-HR-12 RUX';Alt='TPS2121RUXT (same die, small reel)';Cost='2.44';Status='CANDIDATE'},
@{Ref='U203';Mfr='Texas Instruments';MPN='TPS62135RGXR';Pkg='VQFN-HR-11 RGX';Alt='TPS621351RGXR (functional, no output discharge)';Cost='2.32';Status='CANDIDATE'},
@{Ref='U204';Mfr='Texas Instruments';MPN='SN74LVC1G08QDCKRQ1';Pkg='SC70-5 DCK';Alt='SN74LVC1G08QDRYRQ1 (functional, different package)';Cost='0.45';Status='CANDIDATE'},
@{Ref='U205';Mfr='Texas Instruments';MPN='SN74LVC08AQPWRQ1';Pkg='TSSOP-14 PW';Alt='SN74LVC08AQBQARQ1 (functional, different package)';Cost='0.65';Status='CANDIDATE'},
@{Ref='U206';Mfr='Texas Instruments';MPN='TPS22918TDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS22995H-Q1 (functional, different pinout)';Cost='0.75';Status='CANDIDATE'},
@{Ref='U207';Mfr='Texas Instruments';MPN='TPS22918TDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS22995H-Q1 (functional, different pinout)';Cost='0.75';Status='CANDIDATE'},
@{Ref='U208';Mfr='Texas Instruments';MPN='TPS22918TDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS22995H-Q1 (functional, different pinout)';Cost='0.75';Status='CANDIDATE'},
@{Ref='U209';Mfr='Texas Instruments';MPN='TPS2553QDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS2551QDBVRQ1 (functional review required)';Cost='1.60';Status='CANDIDATE'},
@{Ref='U210';Mfr='Texas Instruments';MPN='TPS22918TDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS22995H-Q1 (functional, different pinout)';Cost='0.75';Status='CANDIDATE'},
@{Ref='U211';Mfr='Texas Instruments';MPN='TPS22918TDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS22995H-Q1 (functional, different pinout)';Cost='0.75';Status='CANDIDATE'},
@{Ref='U212';Mfr='Texas Instruments';MPN='TPS2553QDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS2551QDBVRQ1 (functional review required)';Cost='1.60';Status='CANDIDATE'},
@{Ref='U213';Mfr='Texas Instruments';MPN='TPS2553QDBVRQ1';Pkg='SOT-23-6 DBV';Alt='TPS2551QDBVRQ1 (functional review required)';Cost='1.60';Status='CANDIDATE'},
@{Ref='U302';Mfr='Texas Instruments';MPN='TPS389030QDSERQ1';Pkg='WSON-6 DSE';Alt='NONE - threshold/timing/pin exactness required';Cost='1.50';Status='CANDIDATE'},
@{Ref='U706';Mfr='Texas Instruments';MPN='TCA9517ADGKR';Pkg='VSSOP-8 DGK';Alt='PCA9517ADGKR (functional review required)';Cost='1.80';Status='CANDIDATE'},
@{Ref='U707';Mfr='Texas Instruments';MPN='TCA9517ADGKR';Pkg='VSSOP-8 DGK';Alt='PCA9517ADGKR (functional review required)';Cost='1.80';Status='CANDIDATE'},
@{Ref='U801';Mfr='UNRESOLVED - PACS-01 BLOCKED';MPN='NO ACTIVE ORDERABLE TLV841SCPH27YBHR FOUND';Pkg='Required DSBGA-4 YBH combination not listed as production OPN';Alt='Architecture-compatible alternate not demonstrated';Cost='';Status='BLOCKED'}
)

$ebomPath=Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv';$avlPath=Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'
$ebom=@(Import-Csv $ebomPath -Encoding UTF8);$avl=@(Import-Csv $avlPath -Encoding UTF8)
$baselineText=(& git -C $RepositoryRoot show '1a6c11c:docs/bom/IPC100_RevA_EBOM.csv') -join "`n"
if($LASTEXITCODE-ne 0){throw 'Unable to load the pre-PACS-01 EBOM baseline.'}
$baseline=@($baselineText|ConvertFrom-Csv)
foreach($r in $rows){
 $e=$ebom|Where-Object Reference -eq $r.Ref|Select-Object -First 1;if($null-eq $e){throw "EBOM reference missing: $($r.Ref)"}
 $a=$avl|Where-Object Item -eq $e.Item|Select-Object -First 1;if($null-eq $a){throw "AVL item missing: $($e.Item)"}
 $b=$baseline|Where-Object Reference -eq $r.Ref|Select-Object -First 1;if($null-eq $b){throw "Baseline EBOM reference missing: $($r.Ref)"}
 $pacsRisk=if($r.Status-eq'BLOCKED'){"PACS-01 BLOCKED - $($r.MPN). No active-device freeze."}else{"PACS-01 reviewed candidate $($r.MPN); package rejected as a whole because U101 and U801 remain blocked. Do not procure or assign footprint."}
 $risk="$($b.Risk) $pacsRisk"
 $e.Manufacturer=$r.Mfr;$e.'Manufacturer Part Number'=$r.MPN;$e.Package=$r.Pkg;$e.'Mounting Style'='Surface mount; footprint not assigned'
 $e.'Lifecycle Status'=if($r.Status-eq'BLOCKED'){'NOT ORDERABLE / UNRESOLVED'}else{'ACTIVE / PRODUCTION - manufacturer review 2026-07-31'}
 $e.Availability=if($r.Status-eq'BLOCKED'){'UNAVAILABLE / UNRESOLVED'}else{'Manufacturer orderable; distributor snapshot requires PO revalidation'}
 $e.'Preferred Vendor'=if($r.Status-eq'BLOCKED'){'UNRESOLVED'}else{$r.Mfr};$e.'Preferred Vendor Ordering Code'=$r.MPN
 $e.'Alternate Vendor'='Functional alternate only';$e.'Alternate Vendor Ordering Code'=$r.Alt;$e.'Approved Alternate'=$r.Alt;$e.'Second Source'='No approved drop-in second source'
 $e.'Unit Cost 1'=$r.Cost;$e.Currency=if($r.Cost){'USD'}else{''};$e.'Price Date'=if($r.Cost){'2026-07-31 budgetary web snapshot'}else{''}
 $e.'Freeze Status'='BLOCKED';$e.'Requirement Trace Reference'='PACS-01; QER-01/02/03; PPQ-01/02; applicable ECO';$e.'Sourcing Risk'='BLOCKED - PACS-01 NOT ACCEPTED';$e.Risk=$risk;$e.Notes=$risk
 $a.Manufacturer=$e.Manufacturer;$a.'Manufacturer Part Number'=$e.'Manufacturer Part Number';$a.'Preferred Distributor'=$e.'Preferred Vendor';$a.'Preferred Distributor Ordering Code'=$e.'Preferred Vendor Ordering Code'
 $a.'Alternate Distributor'=$e.'Alternate Vendor';$a.'Alternate Distributor Ordering Code'=$e.'Alternate Vendor Ordering Code';$a.Lifecycle=$e.'Lifecycle Status';$a.'Stock Status'=$e.Availability;$a.'Second Source'=$e.'Second Source';$a.'Approved Alternate'=$e.'Approved Alternate'
 $a.'Freeze Status'='BLOCKED';$a.'Sourcing Risk'=$e.'Sourcing Risk';$a.'Requirement Trace Reference'=$e.'Requirement Trace Reference';$a.Risk=$risk;$a.'Review Date'='2026-07-31'
}
$ebom|Export-Csv $ebomPath -NoTypeInformation -Encoding UTF8;$avl|Export-Csv $avlPath -NoTypeInformation -Encoding UTF8

$register=$rows|ForEach-Object{[pscustomobject]@{Reference=$_.Ref;Manufacturer=$_.Mfr;'Preferred MPN'=$_.MPN;'Package family'=$_.Pkg;'Functional alternate'=$_.Alt;'Budgetary unit cost USD'=$_.Cost;'Review status'=$_.Status}}
$register|Export-Csv (Join-Path $RepositoryRoot 'docs/reviews/PACS-01_Active_Device_Register.csv') -NoTypeInformation -Encoding UTF8

# CSV remains canonical. Reuse the repository's standard-library converter for review workbooks.
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $ebomPath (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.xlsx')
& python (Join-Path $RepositoryRoot 'scripts/csv_to_xlsx.py') $avlPath (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.xlsx')
if($LASTEXITCODE-ne 0){throw 'XLSX regeneration failed.'}
Write-Host 'PACS-01 20-reference candidate audit applied; all rows remain BLOCKED.'
