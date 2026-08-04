[CmdletBinding()]
param([string]$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference='Stop';$bom=Join-Path $RepositoryRoot 'docs/bom'
function BaseCsv($path){$text=(git -C $RepositoryRoot show ("3590bec:"+$path))-join "`n";if($LASTEXITCODE-ne 0){throw "Cannot read ECO-011A2 baseline $path"};@($text|ConvertFrom-Csv)}
$genE=@(Import-Csv (Join-Path $bom 'IPC100_RevA_EBOM.csv'));$genA=@(Import-Csv (Join-Path $bom 'Approved_Vendor_List.csv'))
$baseE=BaseCsv 'docs/bom/IPC100_RevA_EBOM.csv';$baseA=BaseCsv 'docs/bom/Approved_Vendor_List.csv';$sheet='05_Motor_Interfaces'
$newE=@($genE|Where-Object Sheet -eq $sheet);$newA=@($genA|Where-Object{$_.Item-like "$sheet/*"})
if($newE.Count-ne 74-or$newA.Count-ne 74){throw "Expected 74 physical Sheet 05 rows; got EBOM $($newE.Count), AVL $($newA.Count)."}
$mergedE=@($baseE|Where-Object Sheet -ne $sheet)+$newE;$mergedA=@($baseA|Where-Object{$_.Item-notlike "$sheet/*"})+$newA
$mergedE|Sort-Object Sheet,Reference|Export-Csv (Join-Path $bom 'IPC100_RevA_EBOM.csv') -NoTypeInformation -Encoding UTF8
$mergedA|Sort-Object Category,Item|Export-Csv (Join-Path $bom 'Approved_Vendor_List.csv') -NoTypeInformation -Encoding UTF8
Write-Output "ECO-011A2 BOM overlay applied: 47 baseline Sheet 05 rows replaced by 74 physical rows; total $($mergedE.Count)."
