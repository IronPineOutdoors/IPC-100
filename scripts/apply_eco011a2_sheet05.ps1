[CmdletBinding()]
param([string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference = 'Stop'
$source = @(git -C $RepositoryRoot show '3590bec:hardware/kicad/sheets/05_Motor_Interfaces.kicad_sch')
if ($LASTEXITCODE -ne 0 -or $source.Count -eq 0) { throw 'Unable to load the ECO-011A2 baseline Sheet 05.' }
$lines = [Collections.Generic.List[string]]::new(); $source | ForEach-Object { $lines.Add($_) }

function Remove-Block([string]$needle) {
  $start = -1
  for ($i=0; $i -lt $lines.Count; $i++) { if ($lines[$i].Contains($needle)) { $start=$i; break } }
  if ($start -lt 0) { throw "Block not found: $needle" }
  $depth=0; $end=$start
  for ($i=$start; $i -lt $lines.Count; $i++) {
    $depth += ([regex]::Matches($lines[$i],'\(').Count - [regex]::Matches($lines[$i],'\)').Count)
    if ($depth -eq 0) { $end=$i; break }
  }
  $lines.RemoveRange($start,$end-$start+1)
}
foreach($needle in @('(symbol "IPC100:INTERLOCK4"','(symbol "IPC100:AUTH2"','(symbol (lib_id "IPC100:AUTH2")','(symbol (lib_id "IPC100:INTERLOCK4")')) {
  while (@($lines | Where-Object { $_.Contains($needle) }).Count -gt 0) { Remove-Block $needle }
}

$libEnd=-1; $depth=0; $inside=$false
for($i=0;$i -lt $lines.Count;$i++){
  if(-not $inside -and $lines[$i].Contains('(lib_symbols')){$inside=$true}
  if($inside){$depth += ([regex]::Matches($lines[$i],'\(').Count-[regex]::Matches($lines[$i],'\)').Count); if($depth -eq 0){$libEnd=$i;break}}
}
if($libEnd -lt 0){throw 'lib_symbols close not found'}
$lib=@'
    (symbol "IPC100:TP" (pin_numbers hide) (pin_names (offset 0)) (exclude_from_sim no) (in_bom yes) (on_board yes)
      (property "Reference" "TP" (at 0 2.54 0) (effects (font (size 1.27 1.27)))) (property "Value" "Test node" (at 0 -2.54 0) (effects (font (size 1 1))))
      (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at 0 0 0) (effects (font (size 1 1)) hide))
      (symbol "TP_0_1" (circle (center 0 0) (radius 1.27) (stroke (width 0.4) (type default)) (fill (type none))))
      (symbol "TP_1_1" (pin passive line (at -5.08 0 0) (length 3.81) (name "TP" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1)))))))
    (symbol "IPC100:SN74LVC08AQPWRQ1" (pin_names (offset 0.6)) (exclude_from_sim no) (in_bom yes) (on_board yes)
      (property "Reference" "U" (at 0 5.08 0) (effects (font (size 1.27 1.27)))) (property "Value" "SN74LVC08AQPWRQ1" (at 0 -5.08 0) (effects (font (size 1 1))))
      (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "https://www.ti.com/lit/ds/symlink/sn74lvc08a-q1.pdf" (at 0 0 0) (effects (font (size 1 1)) hide))
      (symbol "SN74LVC08AQPWRQ1_0_1" (rectangle (start -3.81 -3.81) (end 3.81 3.81) (stroke (width 0) (type default)) (fill (type background))))
      (symbol "SN74LVC08AQPWRQ1_1_1" (pin input line (at -6.35 -1.27 0) (length 2.54) (name "1A" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1))))) (pin input line (at -6.35 1.27 0) (length 2.54) (name "1B" (effects (font (size 1 1)))) (number "2" (effects (font (size 1 1))))) (pin output line (at 6.35 0 180) (length 2.54) (name "1Y" (effects (font (size 1 1)))) (number "3" (effects (font (size 1 1))))))
      (symbol "SN74LVC08AQPWRQ1_2_1" (pin input line (at -6.35 -1.27 0) (length 2.54) (name "2A" (effects (font (size 1 1)))) (number "4" (effects (font (size 1 1))))) (pin input line (at -6.35 1.27 0) (length 2.54) (name "2B" (effects (font (size 1 1)))) (number "5" (effects (font (size 1 1))))) (pin output line (at 6.35 0 180) (length 2.54) (name "2Y" (effects (font (size 1 1)))) (number "6" (effects (font (size 1 1))))))
      (symbol "SN74LVC08AQPWRQ1_3_1" (pin input line (at -6.35 -1.27 0) (length 2.54) (name "3A" (effects (font (size 1 1)))) (number "9" (effects (font (size 1 1))))) (pin input line (at -6.35 1.27 0) (length 2.54) (name "3B" (effects (font (size 1 1)))) (number "10" (effects (font (size 1 1))))) (pin output line (at 6.35 0 180) (length 2.54) (name "3Y" (effects (font (size 1 1)))) (number "8" (effects (font (size 1 1))))))
      (symbol "SN74LVC08AQPWRQ1_4_1" (pin input line (at -6.35 -1.27 0) (length 2.54) (name "4A" (effects (font (size 1 1)))) (number "12" (effects (font (size 1 1))))) (pin input line (at -6.35 1.27 0) (length 2.54) (name "4B" (effects (font (size 1 1)))) (number "13" (effects (font (size 1 1))))) (pin output line (at 6.35 0 180) (length 2.54) (name "4Y" (effects (font (size 1 1)))) (number "11" (effects (font (size 1 1))))))
      (symbol "SN74LVC08AQPWRQ1_5_1" (rectangle (start -3.81 -2.54) (end 3.81 2.54) (stroke (width 0) (type default)) (fill (type background))) (pin power_in line (at -6.35 -1.27 0) (length 2.54) (name "VCC" (effects (font (size 1 1)))) (number "14" (effects (font (size 1 1))))) (pin power_in line (at -6.35 1.27 0) (length 2.54) (name "GND" (effects (font (size 1 1)))) (number "7" (effects (font (size 1 1)))))))
    (symbol "IPC100:SN74LVC14AQPWRQ1" (pin_names (offset 0.6)) (exclude_from_sim no) (in_bom yes) (on_board yes)
      (property "Reference" "U" (at 0 3.81 0) (effects (font (size 1.27 1.27)))) (property "Value" "SN74LVC14AQPWRQ1" (at 0 -3.81 0) (effects (font (size 1 1))))
      (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "https://www.ti.com/lit/ds/symlink/sn74lvc14a-q1.pdf" (at 0 0 0) (effects (font (size 1 1)) hide))
      (symbol "SN74LVC14AQPWRQ1_0_1" (polyline (pts (xy -2.54 -2.54) (xy 2.54 0) (xy -2.54 2.54) (xy -2.54 -2.54)) (stroke (width 0) (type default)) (fill (type background))) (circle (center 3.175 0) (radius 0.635) (stroke (width 0) (type default)) (fill (type none))))
      (symbol "SN74LVC14AQPWRQ1_1_1" (pin input line (at -5.08 0 0) (length 2.54) (name "1A" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "1Y" (effects (font (size 1 1)))) (number "2" (effects (font (size 1 1))))))
      (symbol "SN74LVC14AQPWRQ1_2_1" (pin input line (at -5.08 0 0) (length 2.54) (name "2A" (effects (font (size 1 1)))) (number "3" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "2Y" (effects (font (size 1 1)))) (number "4" (effects (font (size 1 1))))))
      (symbol "SN74LVC14AQPWRQ1_3_1" (pin input line (at -5.08 0 0) (length 2.54) (name "3A" (effects (font (size 1 1)))) (number "5" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "3Y" (effects (font (size 1 1)))) (number "6" (effects (font (size 1 1))))))
      (symbol "SN74LVC14AQPWRQ1_4_1" (pin input line (at -5.08 0 0) (length 2.54) (name "4A" (effects (font (size 1 1)))) (number "9" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "4Y" (effects (font (size 1 1)))) (number "8" (effects (font (size 1 1))))))
      (symbol "SN74LVC14AQPWRQ1_5_1" (pin input line (at -5.08 0 0) (length 2.54) (name "5A" (effects (font (size 1 1)))) (number "11" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "5Y" (effects (font (size 1 1)))) (number "10" (effects (font (size 1 1))))))
      (symbol "SN74LVC14AQPWRQ1_6_1" (pin input line (at -5.08 0 0) (length 2.54) (name "6A" (effects (font (size 1 1)))) (number "13" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "6Y" (effects (font (size 1 1)))) (number "12" (effects (font (size 1 1))))))
      (symbol "SN74LVC14AQPWRQ1_7_1" (rectangle (start -3.81 -2.54) (end 3.81 2.54) (stroke (width 0) (type default)) (fill (type background))) (pin power_in line (at -6.35 -1.27 0) (length 2.54) (name "VCC" (effects (font (size 1 1)))) (number "14" (effects (font (size 1 1))))) (pin power_in line (at -6.35 1.27 0) (length 2.54) (name "GND" (effects (font (size 1 1)))) (number "7" (effects (font (size 1 1)))))))
'@ -split "`r?`n"
$lines.InsertRange($libEnd,[string[]]$lib)

$id=1
function Id { $script:id++; '711a2a2a-0000-4000-8000-{0:d12}' -f $script:id }
function Add([string]$s){$script:add.Add($s)}
function Label($n,$x,$y){Add ('  (label "{0}" (at {1} {2} 0) (effects (font (size 0.8 0.8)) (justify left bottom)) (uuid {3}))' -f $n,$x,$y,(Id))}
function Sym($lib,$ref,$val,$unit,$x,$y,$pins){Add ('  (symbol (lib_id "{0}") (at {1} {2} 0) (unit {3}) (exclude_from_sim no) (in_bom yes) (on_board yes) (dnp no)' -f $lib,$x,$y,$unit);Add ('    (uuid {0}) (property "Reference" "{1}" (at {2} {3} 0) (effects (font (size 1 1)))) (property "Value" "{4}" (at {2} {5} 0) (effects (font (size 0.75 0.75))))' -f (Id),$ref,$x,($y-4.5),$val,($y+4.5));Add ('    (property "Footprint" "" (at {0} {1} 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at {0} {1} 0) (effects (font (size 1 1)) hide))' -f $x,$y);foreach($p in $pins){Add ('    (pin "{0}" (uuid {1}))' -f $p,(Id))};Add ('    (instances (project "IPC-100" (path "/10000000-0000-4000-8000-000000000001/10000000-0000-4000-8000-000000000261" (reference "{0}") (unit {1}))))' -f $ref,$unit);Add '  )'}
$andPins=@(@('1','2','3'),@('4','5','6'),@('9','10','8'),@('12','13','11'));$invPins=@(@('1','2'),@('3','4'),@('5','6'),@('9','8'),@('11','10'),@('13','12'))
function Inv($u,$a,$o,$x,$y){Sym 'IPC100:SN74LVC14AQPWRQ1' 'U506' 'SN74LVC14AQPWRQ1' $u $x $y $invPins[$u-1];Label $a ($x-5.08) $y;Label $o ($x+5.08) $y}
function And($ref,$u,$a,$b,$o,$x,$y){Sym 'IPC100:SN74LVC08AQPWRQ1' $ref 'SN74LVC08AQPWRQ1' $u $x $y $andPins[$u-1];Label $a ($x-6.35) ($y-1.27);Label $b ($x-6.35) ($y+1.27);Label $o ($x+6.35) $y}
function Pass($kind,$ref,$val,$a,$b,$x,$y){Sym "IPC100:$kind" $ref $val 1 $x $y @('1','2');Label $a ($x-5.08) $y;Label $b ($x+5.08) $y}
function Tp($ref,$net,$x,$y){Sym 'IPC100:TP' $ref $net 1 $x $y @('1');Label $net ($x-5.08) $y}
$script:add=[Collections.Generic.List[string]]::new()
Add '  (text "ECO-011A2 — PHYSICAL SUPPRESSION AND AUTHORIZATION LOGIC" (at 18 225 0) (effects (font (size 1.2 1.2) (bold yes)) (justify left bottom)) (uuid 711a2a2a-0000-4000-8000-000000000001))'
Add ('  (text "R_OK = RPWM AND NOT LPWM; L_OK = LPWM AND NOT RPWM; EN = PERMIT AND NOT INHIBIT; AXISn_XLAT_EN = ACTUATOR_PERMIT AND NOT MASTER_INHIBIT" (at 18 230 0) (effects (font (size 0.8 0.8)) (justify left bottom)) (uuid {0}))' -f (Id))
Inv 1 'AXIS1_LPWM_MCU' 'AXIS1_NOT_LPWM' 45 235;Inv 2 'AXIS1_RPWM_MCU' 'AXIS1_NOT_RPWM' 70 235;And 'U507' 1 'AXIS1_RPWM_MCU' 'AXIS1_NOT_LPWM' 'AXIS1_RPWM_QUAL' 100 235;And 'U507' 2 'AXIS1_LPWM_MCU' 'AXIS1_NOT_RPWM' 'AXIS1_LPWM_QUAL' 130 235
Inv 3 'AXIS2_LPWM_MCU' 'AXIS2_NOT_LPWM' 45 250;Inv 4 'AXIS2_RPWM_MCU' 'AXIS2_NOT_RPWM' 70 250;And 'U507' 3 'AXIS2_RPWM_MCU' 'AXIS2_NOT_LPWM' 'AXIS2_RPWM_QUAL' 100 250;And 'U507' 4 'AXIS2_LPWM_MCU' 'AXIS2_NOT_RPWM' 'AXIS2_LPWM_QUAL' 130 250
Inv 5 'MASTER_INHIBIT' 'MASTER_INHIBIT_N' 45 267;And 'U508' 1 'ACTUATOR_PERMIT' 'MASTER_INHIBIT_N' 'AXIS1_XLAT_EN' 80 267;And 'U508' 2 'ACTUATOR_PERMIT' 'MASTER_INHIBIT_N' 'AXIS2_XLAT_EN' 115 267
Inv 6 'GND' 'U506_UNUSED_Y' 150 267;Add ('  (no_connect (at 155.08 267) (uuid {0}))' -f (Id));And 'U508' 3 'GND' 'GND' 'U508_UNUSED3_Y' 180 262;Add ('  (no_connect (at 186.35 262) (uuid {0}))' -f (Id));And 'U508' 4 'GND' 'GND' 'U508_UNUSED4_Y' 180 272;Add ('  (no_connect (at 186.35 272) (uuid {0}))' -f (Id))
Sym 'IPC100:SN74LVC14AQPWRQ1' 'U506' 'SN74LVC14AQPWRQ1 power' 7 220 235 @('14','7');Label '+3V3_CORE' 213.65 233.73;Label 'GND' 213.65 236.27
foreach($r in @('U507','U508')){$yy=if($r -eq 'U507'){250}else{267};Sym 'IPC100:SN74LVC08AQPWRQ1' $r 'SN74LVC08AQPWRQ1 power' 5 220 $yy @('14','7');Label '+3V3_CORE' 213.65 ($yy-1.27);Label 'GND' 213.65 ($yy+1.27)}
Pass 'C' 'C507' '100 nF X7R U506 package-local bypass' '+3V3_CORE' 'GND' 255 235;Pass 'C' 'C508' '100 nF X7R U507 package-local bypass' '+3V3_CORE' 'GND' 255 250;Pass 'C' 'C509' '100 nF X7R U508 package-local bypass' '+3V3_CORE' 'GND' 255 267
$nets=@('AXIS1_RPWM_MCU','AXIS1_LPWM_MCU','AXIS1_RPWM_QUAL','AXIS1_LPWM_QUAL','AXIS1_XLAT_EN','AXIS1_RPWM_5V','AXIS1_LPWM_5V','AXIS1_RPWM_SAFE','AXIS1_LPWM_SAFE','AXIS1_REN_SAFE','AXIS1_LEN_SAFE','AXIS2_RPWM_MCU','AXIS2_LPWM_MCU','AXIS2_RPWM_QUAL','AXIS2_LPWM_QUAL','AXIS2_XLAT_EN','AXIS2_RPWM_5V','AXIS2_LPWM_5V','AXIS2_RPWM_SAFE','AXIS2_LPWM_SAFE','AXIS2_REN_SAFE','AXIS2_LEN_SAFE','ACTUATOR_PERMIT','MASTER_INHIBIT')
for($i=0;$i -lt $nets.Count;$i++){Tp ('TP{0}' -f (501+$i)) $nets[$i] (25+($i%8)*38) (290+[math]::Floor($i/8)*14)}

# REN/LEN are unchanged pass-through paths into the translator A inputs; make both names explicit on those pins.
Label 'AXIS1_REN_MCU' 139.76 86.92;Label 'AXIS1_LEN_MCU' 139.76 92;Label 'AXIS2_REN_MCU' 139.76 184.92;Label 'AXIS2_LEN_MCU' 139.76 190
$sheetIndex=$lines.FindIndex([Predicate[string]]{param($s) $s.Contains('(sheet_instances')})
if($sheetIndex -lt 0){throw 'sheet_instances not found'}
$lines.InsertRange($sheetIndex,[string[]]$add)
$lines[3]='  (title_block (title "IPC-100 Rev A — 05 Axis Command Interface") (date "2026-08-04") (rev "Rev A") (company "Iron Pine Outdoors")'
$lines[4]='    (comment 1 "ECO-011A2 physical motion-control decomposition") (comment 2 "ADR-043 dual-axis logic; no footprints") (comment 3 "Sheet 6 of 10"))'
$out=Join-Path $RepositoryRoot 'hardware/kicad/sheets/05_Motor_Interfaces.kicad_sch'
[IO.File]::WriteAllLines($out,$lines,[Text.UTF8Encoding]::new($false))
Write-Output "ECO-011A2 Sheet 05 generated: $($lines.Count) lines."
