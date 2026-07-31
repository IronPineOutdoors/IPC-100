[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$pas=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/PAS-01_Passive_Selection_Register.csv') -Encoding UTF8 | Where-Object Status -eq 'BLOCKED' | Sort-Object Sheet,Reference)
$active=@{
 C102='U101 / input-protection solution';C103='U101 / input-protection solution';C104='U101 / input-protection solution';C109='U101 / input-protection solution';L101='U101 / input-protection solution'
 C201='U201 LMR38020-Q1 suffix';C202='U201 LMR38020-Q1 suffix';C203='U201 LMR38020-Q1 suffix';C204='U201 LMR38020-Q1 suffix';C205='U201 LMR38020-Q1 suffix';L201='U201 LMR38020-Q1 suffix'
 C206='U202 TPS2121 suffix and U203 core regulator';C208='U203 core regulator';C209='U203 core regulator';C210='U203 core regulator';L202='U203 core regulator';R808='U801 TLV841S suffix'
}
$evidence=@{
 C102='Exact DC-bias curve at 55 V after U101/PPC clamp selection';C103='Ripple/ESR/lifetime at protected-input waveform';C104='Ripple/ESR/lifetime at protected-input waveform';C109='Exact DC-bias curve at 55 V after U101/PPC clamp selection';L101='Impedance/inductance, hot DCR, saturation and loss at protected-input waveform'
 C201='U201 WEBENCH input-capacitance and ripple solution';C202='TI requires 100 nF BOOT-to-SW; exact suffix and dielectric check';C203='U201 integrated-compensation output-capacitance/ESR solution';C204='U201 integrated-compensation output-capacitance/ESR solution';C205='Pin/function reconciliation: selected U201 has internal 4 ms soft start';L201='U201 ripple/current/loss solution at selected PFM/FPWM suffix'
 C206='U202 switchover plus U203 input transient model and exact DC-bias curve';C208='U203 LC stability and effective-capacitance solution';C209='U203 LC stability and effective-capacitance solution';C210='U203 exact soft-start equation and tolerance';L202='U203 exact switching mode, ripple, saturation and loss solution';C305='TPS3890-Q1 full CT tolerance stack and schematic value correction';R808='U801 threshold/hysteresis/leakage full tolerance stack'
}
$rows=foreach($r in $pas){
 $disp=if($r.Reference -eq 'C305'){'BLOCKED — SCHEMATIC ECO REQUIRED'}else{'BLOCKED — ACTIVE DEVICE SELECTION REQUIRED'}
 [pscustomobject][ordered]@{
  Sheet=$r.Sheet;Reference=$r.Reference;Function=$r.Value;'Passive Type'=if($r.Reference -like 'C*'){'Capacitor'}elseif($r.Reference -like 'L*'){'Inductor'}else{'Precision resistor'}
  'Required Electrical Class'=$r.Value;'PAS-01 Candidate'=$r.MPN;'Existing Blocker'=$r.Disposition;'Dependent Active Device'=if($active.ContainsKey($r.Reference)){$active[$r.Reference]}else{'U302 TPS389030-Q1'}
  'QER / PPQ Evidence'='QER-01; PPQ-01; PPQ-02 capacitor/magnetic/threshold models';'PAS-01R Evidence Required'=$evidence[$r.Reference]
  'Evidence Confidence'=if($r.Reference -eq 'C305'){'HIGH — official equation exposes mismatch'}else{'BLOCKED — exact active/tool input absent'};'Final Disposition'=$disp
  'Closure Route'=if($r.Reference -eq 'C305'){'ECO — correct CT value/target before selection'}else{'PACS-01 — freeze named active, then execute official tool/curve check'}
 }
}
$outDir=Join-Path $RepositoryRoot 'docs/analysis/passives'
New-Item -ItemType Directory -Path $outDir -Force|Out-Null
$rows|Export-Csv (Join-Path $outDir 'PAS-01R_Disposition_Register.csv') -NoTypeInformation -Encoding UTF8
Write-Host "PAS-01R register generated: $($rows.Count) rows; $(@($rows|Where-Object 'Final Disposition' -like '*ACTIVE*').Count) PACS dependencies; $(@($rows|Where-Object 'Final Disposition' -like '*ECO*').Count) ECO required."
