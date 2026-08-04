[CmdletBinding()]
param([string]$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference='Stop'
$bom=Join-Path $RepositoryRoot 'docs/bom'

function Read-GitCsv([string]$path){
    $text=(git -C $RepositoryRoot show ("ba35b9e:"+$path)) -join "`n"
    if($LASTEXITCODE -ne 0){throw "Cannot read ECO-011A1R baseline $path"}
    return @($text | ConvertFrom-Csv)
}

$generatedEbom=@(Import-Csv (Join-Path $bom 'IPC100_RevA_EBOM.csv'))
$generatedAvl=@(Import-Csv (Join-Path $bom 'Approved_Vendor_List.csv'))
$baseEbom=Read-GitCsv 'docs/bom/IPC100_RevA_EBOM.csv'
$baseAvl=Read-GitCsv 'docs/bom/Approved_Vendor_List.csv'
$sheet='04_Safety_Inputs'

$newEbom=@($generatedEbom|Where-Object Sheet -eq $sheet)
$newAvl=@($generatedAvl|Where-Object {$_.Item -like "$sheet/*"})
if($newEbom.Count -ne 148 -or $newAvl.Count -ne 148){throw "Expected 148 physical Sheet 04 rows; got EBOM $($newEbom.Count), AVL $($newAvl.Count)."}

$mergedEbom=@($baseEbom|Where-Object Sheet -ne $sheet)+$newEbom
$mergedAvl=@($baseAvl|Where-Object {$_.Item -notlike "$sheet/*"})+$newAvl
$mergedEbom|Sort-Object Sheet,Reference|Export-Csv (Join-Path $bom 'IPC100_RevA_EBOM.csv') -NoTypeInformation -Encoding UTF8
$mergedAvl|Sort-Object Category,Item|Export-Csv (Join-Path $bom 'Approved_Vendor_List.csv') -NoTypeInformation -Encoding UTF8
Write-Output "ECO-011A1R BOM overlay applied: 53 baseline Sheet 04 rows replaced by 148 physical rows; total $($mergedEbom.Count)."
