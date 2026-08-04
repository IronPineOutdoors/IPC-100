[CmdletBinding()]
param([string]$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference='Stop';function Need($ok,$m){if(-not $ok){throw $m}}
$s=Get-Content -Raw (Join-Path $RepositoryRoot 'hardware/kicad/sheets/05_Motor_Interfaces.kicad_sch')
foreach($x in @('IPC100:INTERLOCK4','IPC100:AUTH2','Reference" "U501"','Reference" "U502"','Reference" "U503"')){Need (-not $s.Contains($x)) "Obsolete composite remains: $x"}
foreach($x in @('SN74LVC14AQPWRQ1','SN74LVC08AQPWRQ1','U506','U507','U508','AXIS1_NOT_LPWM','AXIS1_NOT_RPWM','AXIS2_NOT_LPWM','AXIS2_NOT_RPWM','MASTER_INHIBIT_N','AXIS1_XLAT_EN','AXIS2_XLAT_EN')){Need $s.Contains($x) "Physical implementation missing: $x"}
Need ([regex]::Matches($s,'Reference" "U506"').Count-eq 7) 'U506 must expose six gates plus power unit.'
foreach($r in @('U507','U508')){Need ([regex]::Matches($s,('Reference" "{0}"'-f$r)).Count-eq 5) "$r must expose four gates plus power unit."}
foreach($r in @('C507','C508','C509')){Need ([regex]::Matches($s,('Reference" "{0}"'-f$r)).Count-eq 1) "$r missing or duplicated."}
foreach($r in 501..524){Need ([regex]::Matches($s,('Reference" "TP{0}"'-f$r)).Count-eq 1) "TP$r missing or duplicated."}
foreach($x in @('AXIS1_RPWM_QUAL','AXIS1_LPWM_QUAL','AXIS2_RPWM_QUAL','AXIS2_LPWM_QUAL','ACTUATOR_PERMIT','MASTER_INHIBIT','AXIS1_REN_MCU','AXIS1_LEN_MCU','AXIS2_REN_MCU','AXIS2_LEN_MCU','MOTOR_LOGIC_5V_A','MOTOR_LOGIC_5V_B')){Need $s.Contains($x) "Required net missing: $x"}
Need ($s.Contains('lib_id "IPC100:XLAT4"')-and$s.Contains('Reference" "U504"')-and$s.Contains('Reference" "U505"')) 'Translator boundary changed.'
Need ([regex]::Matches($s,'\(no_connect').Count-ge 3) 'Unused outputs are not explicitly no-connect.'
Need (([regex]::Matches($s,'\(').Count)-eq([regex]::Matches($s,'\)').Count)) 'Sheet 05 S-expression unbalanced.'
Need ([regex]::Matches($s,'\(property "Footprint" "[^"]+').Count-eq 0) 'Footprint assigned.'
$e=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'));$a=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'));$p=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_Prototype_Population.csv'))
Need ($e.Count-eq 435-and$a.Count-eq 435-and$p.Count-eq 435) 'BOM/AVL/population row count mismatch.'
foreach($r in @('U506','U507','U508')){$er=@($e|Where-Object { $_.Reference -eq $r });Need ($er.Count-eq 1-and$er[0].'Manufacturer Part Number'-match 'SN74LVC') "EBOM $r physical identity mismatch."}
$changed=@(git -C $RepositoryRoot diff --name-only 3590bec);Need (@($changed|Where-Object{$_-match '\.kicad_pcb$|^docs/(adr|icd|connectors)/'}).Count-eq 0) 'PCB/ADR/ICD/connector change detected.'
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Host 'ECO-011A2 validation passed: physical suppression/authorization logic, 435 synchronized rows, zero footprints/PCB/interface changes.'
