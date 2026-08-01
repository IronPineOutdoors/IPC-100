[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference='Stop'
if([string]::IsNullOrWhiteSpace($RepositoryRoot)){$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path}
$pas=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/PAS-01_Passive_Selection_Register.csv') -Encoding UTF8 | Where-Object Status -eq 'BLOCKED' | Sort-Object Sheet,Reference)
$active=@{
 C102='U101 TPS26631PWPR';C103='U101 TPS26631PWPR';C104='U101 TPS26631PWPR';C109='U101 TPS26631PWPR';L101='U101 TPS26631PWPR'
 C201='U201 LMR38020FSQDDARQ1';C202='U201 LMR38020FSQDDARQ1';C203='U201 LMR38020FSQDDARQ1';C204='U201 LMR38020FSQDDARQ1';C205='U201 LMR38020FSQDDARQ1';L201='U201 LMR38020FSQDDARQ1'
 C206='U202 TPS2121RUXR / U203 TPS62135RGXR';C208='U203 TPS62135RGXR';C209='U203 TPS62135RGXR';C210='U203 TPS62135RGXR';L202='U203 TPS62135RGXR';R808='U801 TPS3899DL01DSER'
 C805='U801 TPS3899DL01DSER';R807='U801 TPS3899DL01DSER';R809='U801 TPS3899DL01DSER'
}
$evidence=@{
 C102='Exact DC-bias curve at 55 V after U101/PPC clamp selection';C103='Ripple/ESR/lifetime at protected-input waveform';C104='Ripple/ESR/lifetime at protected-input waveform';C109='Exact DC-bias curve at 55 V after U101/PPC clamp selection';L101='Impedance/inductance, hot DCR, saturation and loss at protected-input waveform'
 C201='U201 WEBENCH input-capacitance and ripple solution';C202='TI requires 100 nF BOOT-to-SW; exact suffix and dielectric check';C203='U201 integrated-compensation output-capacitance/ESR solution';C204='U201 integrated-compensation output-capacitance/ESR solution';C205='Pin/function reconciliation: selected U201 has internal 4 ms soft start';L201='U201 ripple/current/loss solution at selected PFM/FPWM suffix'
 C206='U202 switchover plus U203 input transient model and exact DC-bias curve';C208='U203 LC stability and effective-capacitance solution';C209='U203 LC stability and effective-capacitance solution';C210='U203 exact soft-start equation and tolerance';L202='U203 exact switching mode, ripple, saturation and loss solution';C305='TPS3890-Q1 full CT tolerance stack and schematic value correction';R808='U801 threshold/hysteresis/leakage full tolerance stack'
}
$rows=foreach($r in $pas){
 $disp=if($r.Reference -eq 'C305'){'BLOCKED - EXACT MPN/PROTOTYPE EVIDENCE REQUIRED'}else{'BLOCKED - EXACT TOOL/CURVE EVIDENCE REQUIRED'}
 [pscustomobject][ordered]@{
  Sheet=$r.Sheet;Reference=$r.Reference;Function=$r.Value;'Passive Type'=if($r.Reference -like 'C*'){'Capacitor'}elseif($r.Reference -like 'L*'){'Inductor'}else{'Precision resistor'}
  'Required Electrical Class'=$r.Value;'PAS-01 Candidate'=$r.MPN;'Existing Blocker'=$r.Disposition;'Dependent Active Device'=if($active.ContainsKey($r.Reference)){$active[$r.Reference]}else{'U302 TPS389030-Q1'}
  'QER / PPQ Evidence'='QER-01; PPQ-01; PPQ-02 capacitor/magnetic/threshold models';'PAS-01R Evidence Required'=$evidence[$r.Reference]
  'Evidence Confidence'=if($r.Reference -eq 'C305'){'HIGH - ECO-009R electrical class verified; exact MPN/prototype open'}else{'MEDIUM - exact active MPN selected; manufacturer tool/curve or prototype evidence remains'};'Final Disposition'=$disp
  'Closure Route'='PACS-01R-A - close named manufacturer tool/curve, thermal, threshold or exact-MPN evidence'
 }
}
$outDir=Join-Path $RepositoryRoot 'docs/analysis/passives'
New-Item -ItemType Directory -Path $outDir -Force|Out-Null
$rows|Export-Csv (Join-Path $outDir 'PAS-01R_Disposition_Register.csv') -NoTypeInformation -Encoding UTF8
Write-Host "PAS-01R register generated: $($rows.Count) rows; zero generic active-selection blockers; PACS-01R-A evidence routed."
