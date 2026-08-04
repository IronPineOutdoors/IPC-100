[CmdletBinding()]
param([string]$RepositoryRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference='Stop';function Need($ok,$m){if(-not$ok){throw$m}}
$note=Get-Content -Raw (Join-Path $RepositoryRoot 'hardware/kicad/notes/ECO-011A3_Watchdog_Master_Authorization_Physical_Decomposition.md')
foreach($x in @('zero-width tolerance','1:8','1:2','3:4','falling WDI edges','Smallest prerequisite','≤250 ms')){Need $note.Contains($x) "Missing blocker evidence: $x"}
Need ([regex]::Matches($note,'(?m)^# ECO-011A3 (?:COMPLETE — ECO-011A4 AUTHORIZED|INCOMPLETE)$').Count-eq 1) 'ECO-011A3 must issue exactly one decision.'
Need ($note-match'(?m)^# ECO-011A3 INCOMPLETE$') 'ECO-011A3 decision must remain incomplete.'
$changed=@(git -C $RepositoryRoot diff --name-only e382ff0)
foreach($path in $changed){Need ($path-notmatch'\.kicad_sch$|\.kicad_pcb$|^docs/(decisions|architecture|interfaces|icd|connectors)/|^docs/bom/') "Prohibited ECO-011A3 entry-gate change: $path"}
$sheet=Get-Content -Raw (Join-Path $RepositoryRoot 'hardware/kicad/sheets/06_Relay_MasterInhibit.kicad_sch')
foreach($x in @('IPC100:WINDOW_WATCHDOG','IPC100:AUTH4','IPC100:AND2','Reference" "U601"','Reference" "U602"','Reference" "U603"')){Need $sheet.Contains($x) "Baseline Sheet 06 abstraction changed: $x"}
Need ([regex]::Matches($sheet,'\(property "Footprint" "[^"]+').Count-eq 0) 'Footprint assigned.'
Need (@(Get-ChildItem $RepositoryRoot-Recurse-Filter'*.kicad_pcb').Count-eq 0) 'PCB file created.'
$e=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv'));$a=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/Approved_Vendor_List.csv'));$p=@(Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_Prototype_Population.csv'))
Need ($e.Count-eq435-and$a.Count-eq435-and$p.Count-eq435) 'Accepted 435-row inventory changed.'
& (Join-Path $RepositoryRoot 'scripts/validate_kicad_hierarchy.ps1') -ProjectDirectory (Join-Path $RepositoryRoot 'hardware/kicad')
Write-Host 'ECO-011A3 validation passed: timing contract physically unresolved; zero schematic/BOM/interface/footprint/PCB changes.'
