[CmdletBinding()]
param([string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
$ErrorActionPreference = 'Stop'

$out = Join-Path $RepositoryRoot 'hardware/kicad/sheets/04_Safety_Inputs.kicad_sch'
$lines = [System.Collections.Generic.List[string]]::new()
$id = 1
function Uuid { $script:id++; return ('711a1a1a-0000-4000-8000-{0:d12}' -f $script:id) }
function Add([string]$s) { $script:lines.Add($s) }
function Q([string]$s) { return $s.Replace('"','\"') }

Add '(kicad_sch (version 20231120) (generator eeschema)'
Add '  (uuid 10000000-0000-4000-8000-000000000679)'
Add '  (paper "A2")'
Add '  (title_block (title "IPC-100 Rev A — 04 Safety Inputs") (date "2026-08-04") (rev "Rev A") (company "Iron Pine Outdoors")'
Add '    (comment 1 "ECO-011A1R physical safety-input decomposition") (comment 2 "QER-04 direct TLV7044-Q1 comparison; no footprints") (comment 3 "Sheet 5 of 10"))'
Add '  (lib_symbols'
Add '    (symbol "IPC100:R" (pin_numbers hide) (pin_names (offset 0)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "R" (at 0 2.54 0) (effects (font (size 1.27 1.27)))) (property "Value" "R" (at 0 0 0) (effects (font (size 1.05 1.05))))'
Add '      (property "Footprint" "" (at 0 -2.54 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "R_0_1" (rectangle (start -2.54 1.27) (end 2.54 -1.27) (stroke (width 0) (type default)) (fill (type none))))'
Add '      (symbol "R_1_1" (pin passive line (at -5.08 0 0) (length 2.54) (name "~" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1))))) (pin passive line (at 5.08 0 180) (length 2.54) (name "~" (effects (font (size 1 1)))) (number "2" (effects (font (size 1 1)))))))'
Add '    (symbol "IPC100:C" (pin_numbers hide) (pin_names (offset 0)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "C" (at 0 2.54 0) (effects (font (size 1.27 1.27)))) (property "Value" "C" (at 0 0 0) (effects (font (size 1.05 1.05))))'
Add '      (property "Footprint" "" (at 0 -2.54 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "C_0_1" (polyline (pts (xy -0.75 1.9) (xy -0.75 -1.9)) (stroke (width 0.5) (type default)) (fill (type none))) (polyline (pts (xy 0.75 1.9) (xy 0.75 -1.9)) (stroke (width 0.5) (type default)) (fill (type none))))'
Add '      (symbol "C_1_1" (pin passive line (at -5.08 0 0) (length 2.54) (name "~" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1))))) (pin passive line (at 5.08 0 180) (length 2.54) (name "~" (effects (font (size 1 1)))) (number "2" (effects (font (size 1 1)))))))'
Add '    (symbol "IPC100:D" (pin_numbers hide) (pin_names (offset 0)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "D" (at 0 2.54 0) (effects (font (size 1.27 1.27)))) (property "Value" "D" (at 0 0 0) (effects (font (size 1.05 1.05))))'
Add '      (property "Footprint" "" (at 0 -2.54 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "D_0_1" (polyline (pts (xy -1.27 -1.9) (xy -1.27 1.9) (xy 1.27 0) (xy -1.27 -1.9)) (stroke (width 0.4) (type default)) (fill (type none))) (polyline (pts (xy 1.27 -1.9) (xy 1.27 1.9)) (stroke (width 0.4) (type default)) (fill (type none))))'
Add '      (symbol "D_1_1" (pin passive line (at -5.08 0 0) (length 2.54) (name "~" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1))))) (pin passive line (at 5.08 0 180) (length 2.54) (name "~" (effects (font (size 1 1)))) (number "2" (effects (font (size 1 1)))))))'
Add '    (symbol "IPC100:TP" (pin_numbers hide) (pin_names (offset 0)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "TP" (at 0 2.54 0) (effects (font (size 1.27 1.27)))) (property "Value" "Test node" (at 0 -2.54 0) (effects (font (size 1 1))))'
Add '      (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "TP_0_1" (circle (center 0 0) (radius 1.27) (stroke (width 0.4) (type default)) (fill (type none))))'
Add '      (symbol "TP_1_1" (pin passive line (at -5.08 0 0) (length 3.81) (name "TP" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1)))))))'

Add '    (symbol "IPC100:TLV7044QPWRQ1" (pin_names (offset 0.6)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "U" (at 0 5.08 0) (effects (font (size 1.27 1.27)))) (property "Value" "TLV7044QPWRQ1" (at 0 -5.08 0) (effects (font (size 1 1))))'
Add '      (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "https://www.ti.com/lit/ds/symlink/tlv7044-q1.pdf" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "TLV7044QPWRQ1_0_1" (polyline (pts (xy -3.81 -3.81) (xy 3.81 0) (xy -3.81 3.81) (xy -3.81 -3.81)) (stroke (width 0) (type default)) (fill (type background))))'
$cmpPins = @(@('1','2','3'),@('7','6','5'),@('8','9','10'),@('14','13','12'))
for($u=1;$u -le 4;$u++) { $p=$cmpPins[$u-1]; Add ('      (symbol "TLV7044QPWRQ1_{0}_1" (pin input line (at -6.35 -1.27 0) (length 2.54) (name "IN-" (effects (font (size 1 1)))) (number "{1}" (effects (font (size 1 1))))) (pin input line (at -6.35 1.27 0) (length 2.54) (name "IN+" (effects (font (size 1 1)))) (number "{2}" (effects (font (size 1 1))))) (pin open_collector line (at 6.35 0 180) (length 2.54) (name "OUT" (effects (font (size 1 1)))) (number "{3}" (effects (font (size 1 1))))))' -f $u,$p[1],$p[2],$p[0]) }
Add '      (symbol "TLV7044QPWRQ1_5_1" (rectangle (start -3.81 -2.54) (end 3.81 2.54) (stroke (width 0) (type default)) (fill (type background))) (pin power_in line (at -6.35 -1.27 0) (length 2.54) (name "VCC" (effects (font (size 1 1)))) (number "4" (effects (font (size 1 1))))) (pin power_in line (at -6.35 1.27 0) (length 2.54) (name "VEE" (effects (font (size 1 1)))) (number "11" (effects (font (size 1 1))))))'
Add '    )'

Add '    (symbol "IPC100:SN74LVC08AQPWRQ1" (pin_names (offset 0.6)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "U" (at 0 5.08 0) (effects (font (size 1.27 1.27)))) (property "Value" "SN74LVC08AQPWRQ1" (at 0 -5.08 0) (effects (font (size 1 1)))) (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "https://www.ti.com/lit/ds/symlink/sn74lvc08a-q1.pdf" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "SN74LVC08AQPWRQ1_0_1" (rectangle (start -3.81 -3.81) (end 3.81 3.81) (stroke (width 0) (type default)) (fill (type background))))'
$andPins=@(@('1','2','3'),@('4','5','6'),@('9','10','8'),@('12','13','11'))
for($u=1;$u -le 4;$u++){ $p=$andPins[$u-1]; Add ('      (symbol "SN74LVC08AQPWRQ1_{0}_1" (pin input line (at -6.35 -1.27 0) (length 2.54) (name "A" (effects (font (size 1 1)))) (number "{1}" (effects (font (size 1 1))))) (pin input line (at -6.35 1.27 0) (length 2.54) (name "B" (effects (font (size 1 1)))) (number "{2}" (effects (font (size 1 1))))) (pin output line (at 6.35 0 180) (length 2.54) (name "Y" (effects (font (size 1 1)))) (number "{3}" (effects (font (size 1 1))))))' -f $u,$p[0],$p[1],$p[2]) }
Add '      (symbol "SN74LVC08AQPWRQ1_5_1" (rectangle (start -3.81 -2.54) (end 3.81 2.54) (stroke (width 0) (type default)) (fill (type background))) (pin power_in line (at -6.35 -1.27 0) (length 2.54) (name "VCC" (effects (font (size 1 1)))) (number "14" (effects (font (size 1 1))))) (pin power_in line (at -6.35 1.27 0) (length 2.54) (name "GND" (effects (font (size 1 1)))) (number "7" (effects (font (size 1 1))))))'
Add '    )'

Add '    (symbol "IPC100:SN74LVC14AQPWRQ1" (pin_names (offset 0.6)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "U" (at 0 3.81 0) (effects (font (size 1.27 1.27)))) (property "Value" "SN74LVC14AQPWRQ1" (at 0 -3.81 0) (effects (font (size 1 1)))) (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "https://www.ti.com/lit/ds/symlink/sn74lvc14a-q1.pdf" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "SN74LVC14AQPWRQ1_0_1" (polyline (pts (xy -2.54 -2.54) (xy 2.54 0) (xy -2.54 2.54) (xy -2.54 -2.54)) (stroke (width 0) (type default)) (fill (type background))) (circle (center 3.175 0) (radius 0.635) (stroke (width 0) (type default)) (fill (type none))))'
$invPins=@(@('1','2'),@('3','4'),@('5','6'),@('9','8'),@('11','10'),@('13','12'))
for($u=1;$u -le 6;$u++){ $p=$invPins[$u-1]; Add ('      (symbol "SN74LVC14AQPWRQ1_{0}_1" (pin input line (at -5.08 0 0) (length 2.54) (name "A" (effects (font (size 1 1)))) (number "{1}" (effects (font (size 1 1))))) (pin output inverted (at 5.08 0 180) (length 1.27) (name "Y" (effects (font (size 1 1)))) (number "{2}" (effects (font (size 1 1))))))' -f $u,$p[0],$p[1]) }
Add '      (symbol "SN74LVC14AQPWRQ1_7_1" (rectangle (start -3.81 -2.54) (end 3.81 2.54) (stroke (width 0) (type default)) (fill (type background))) (pin power_in line (at -6.35 -1.27 0) (length 2.54) (name "VCC" (effects (font (size 1 1)))) (number "14" (effects (font (size 1 1))))) (pin power_in line (at -6.35 1.27 0) (length 2.54) (name "GND" (effects (font (size 1 1)))) (number "7" (effects (font (size 1 1))))))'
Add '    )'

Add '    (symbol "IPC100:SN74LVC1G17QDBVRQ1" (pin_names (offset 0.6)) (exclude_from_sim no) (in_bom yes) (on_board yes)'
Add '      (property "Reference" "U" (at 0 5.08 0) (effects (font (size 1.27 1.27)))) (property "Value" "SN74LVC1G17QDBVRQ1" (at 0 -5.08 0) (effects (font (size 1 1)))) (property "Footprint" "" (at 0 0 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "https://www.ti.com/lit/ds/symlink/sn74lvc1g17-q1.pdf" (at 0 0 0) (effects (font (size 1 1)) hide))'
Add '      (symbol "SN74LVC1G17QDBVRQ1_0_1" (polyline (pts (xy -3.81 -3.81) (xy 3.81 0) (xy -3.81 3.81) (xy -3.81 -3.81)) (stroke (width 0) (type default)) (fill (type background))))'
Add '      (symbol "SN74LVC1G17QDBVRQ1_1_1" (pin input line (at -6.35 0 0) (length 2.54) (name "A" (effects (font (size 1 1)))) (number "2" (effects (font (size 1 1))))) (pin output line (at 6.35 0 180) (length 2.54) (name "Y" (effects (font (size 1 1)))) (number "4" (effects (font (size 1 1))))) (pin power_in line (at -6.35 -2.54 0) (length 2.54) (name "VCC" (effects (font (size 1 1)))) (number "5" (effects (font (size 1 1))))) (pin power_in line (at -6.35 2.54 0) (length 2.54) (name "GND" (effects (font (size 1 1)))) (number "3" (effects (font (size 1 1))))) (pin no_connect line (at 0 6.35 270) (length 2.54) (name "NC" (effects (font (size 1 1)))) (number "1" (effects (font (size 1 1))))))'
Add '    )'
Add '  )'

function Label([string]$net,[double]$x,[double]$y){ Add ('  (label "{0}" (at {1} {2} 0) (effects (font (size 0.8 0.8)) (justify left bottom)) (uuid {3}))' -f (Q $net),$x,$y,(Uuid)) }
function HLabel([string]$net,[string]$shape,[double]$x,[double]$y,[int]$rot=0){ $just=if($shape -eq 'output'){'right'}else{'left'}; Add ('  (hierarchical_label "{0}" (shape {1}) (at {2} {3} {4}) (effects (font (size 1 1)) (justify {5})) (uuid {6}))' -f $net,$shape,$x,$y,$rot,$just,(Uuid)) }
function Text([string]$t,[double]$x,[double]$y){ Add ('  (text "{0}" (at {1} {2} 0) (effects (font (size 1 1) (bold yes)) (justify left bottom)) (uuid {3}))' -f (Q $t),$x,$y,(Uuid)) }
function Sym([string]$lib,[string]$ref,[string]$val,[int]$unit,[double]$x,[double]$y,[string[]]$pins){
  $uuid=Uuid; Add ('  (symbol (lib_id "{0}") (at {1} {2} 0) (unit {3}) (exclude_from_sim no) (in_bom yes) (on_board yes) (dnp no)' -f $lib,$x,$y,$unit)
  Add ('    (uuid {0}) (property "Reference" "{1}" (at {2} {3} 0) (effects (font (size 1 1))))' -f $uuid,$ref,$x,($y-5.5))
  Add ('    (property "Value" "{0}" (at {1} {2} 0) (effects (font (size 0.75 0.75)))) (property "Footprint" "" (at {1} {3} 0) (effects (font (size 1 1)) hide)) (property "Datasheet" "" (at {1} {3} 0) (effects (font (size 1 1)) hide))' -f (Q $val),$x,($y+5.5),$y)
  foreach($p in $pins){ Add ('    (pin "{0}" (uuid {1}))' -f $p,(Uuid)) }
  Add ('    (instances (project "IPC-100" (path "/10000000-0000-4000-8000-000000000001/10000000-0000-4000-8000-000000000176" (reference "{0}") (unit {1}))))' -f $ref,$unit); Add '  )'
}
function Passive([string]$kind,[string]$ref,[string]$val,[string]$a,[string]$b,[double]$x,[double]$y){ Sym "IPC100:$kind" $ref $val 1 $x $y @('1','2'); Label $a ($x-5.08) $y; Label $b ($x+5.08) $y }
function TP([string]$ref,[string]$net,[double]$x,[double]$y){ Sym 'IPC100:TP' $ref $net 1 $x $y @('1'); Label $net ($x-5.08) $y }
function Comp([string]$ref,[int]$unit,[string]$minus,[string]$plus,[string]$out,[double]$x,[double]$y){ $p=$cmpPins[$unit-1]; Sym 'IPC100:TLV7044QPWRQ1' $ref 'TLV7044QPWRQ1' $unit $x $y @($p[1],$p[2],$p[0]); Label $minus ($x-6.35) ($y-1.27); Label $plus ($x-6.35) ($y+1.27); Label $out ($x+6.35) $y }
function And([string]$ref,[int]$unit,[string]$a,[string]$b,[string]$o,[double]$x,[double]$y){ $p=$andPins[$unit-1]; Sym 'IPC100:SN74LVC08AQPWRQ1' $ref 'SN74LVC08AQPWRQ1' $unit $x $y $p; Label $a ($x-6.35) ($y-1.27); Label $b ($x-6.35) ($y+1.27); Label $o ($x+6.35) $y }
function Inv([int]$unit,[string]$a,[string]$o,[double]$x,[double]$y){ $p=$invPins[$unit-1]; Sym 'IPC100:SN74LVC14AQPWRQ1' 'U411' 'SN74LVC14AQPWRQ1' $unit $x $y $p; Label $a ($x-5.08) $y; Label $o ($x+5.08) $y }

Text '1 — FIELD-TRACKING REFERENCES AND FIELD VALIDITY' 18 14
HLabel 'FIELD_SENSE_VCC' 'input' 18 20; HLabel '+3V3_CORE' 'input' 18 25
$ladder=@(@('R401','FIELD_SENSE_VCC','VREF_4V'),@('R402','VREF_4V','VREF_3V'),@('R403','VREF_3V','VREF_2V'),@('R404','VREF_2V','VREF_1V'),@('R405','VREF_1V','GND'))
for($i=0;$i -lt 5;$i++){ Passive 'R' $ladder[$i][0] '10.0 kΩ ±0.1%, ≤25 ppm/°C ladder' $ladder[$i][1] $ladder[$i][2] (45+$i*20) 20 }
Passive 'C' 'C401' '100 nF X7R reference filter' 'VREF_4V' 'GND' 45 31; Passive 'C' 'C402' '100 nF X7R reference filter' 'VREF_1V' 'GND' 65 31
Passive 'R' 'R425' '10.0 kΩ ±0.1%, ≤25 ppm/°C midpoint top' 'FIELD_SENSE_VCC' 'VREF_2V5' 90 31; Passive 'R' 'R426' '10.0 kΩ ±0.1%, ≤25 ppm/°C midpoint bottom' 'VREF_2V5' 'GND' 110 31; Passive 'C' 'C414' '100 nF X7R midpoint filter' 'VREF_2V5' 'GND' 130 31
Passive 'R' 'R406' '10.0 kΩ ±1% FIELD_OK top' 'FIELD_SENSE_VCC' 'FIELD_DIV' 155 20; Passive 'R' 'R407' '10.0 kΩ ±1% FIELD_OK bottom; POR ordering' 'FIELD_DIV' 'GND' 175 20
Sym 'IPC100:SN74LVC1G17QDBVRQ1' 'U404' 'SN74LVC1G17QDBVRQ1 FIELD_OK' 1 205 23 @('1','2','3','4','5'); Label 'FIELD_DIV' 198.65 23; Label '+3V3_CORE' 198.65 20.46; Label 'GND' 198.65 25.54; Label 'FIELD_OK' 211.35 23

$loops=@(
  [pscustomobject]@{N='STOP';Raw='STOP_IN_RAW';Ret='STOP_RETURN';Cond='STOP_IN_COND';Fault='STOP_FAULT';Sense='STOP_IN_SENSE';Exc='R408';Ser='R409';Cap='C403';D='D401';Y=52; LowRef='U406';LowU=1;HighRef='U407';HighU=1;AndRef='U409';AndU=1;InvU=1},
  [pscustomobject]@{N='LEFT';Raw='LIMIT_LEFT_RAW';Ret='LIMIT_LEFT_RETURN';Cond='LIMIT_LEFT_COND';Fault='LIMIT_LEFT_FAULT';Sense='LIMIT_LEFT_SENSE';Exc='R410';Ser='R411';Cap='C404';D='D402';Y=92; LowRef='U406';LowU=2;HighRef='U408';HighU=1;AndRef='U409';AndU=2;InvU=2},
  [pscustomobject]@{N='RIGHT';Raw='LIMIT_RIGHT_RAW';Ret='LIMIT_RIGHT_RETURN';Cond='LIMIT_RIGHT_COND';Fault='LIMIT_RIGHT_FAULT';Sense='LIMIT_RIGHT_SENSE';Exc='R412';Ser='R413';Cap='C405';D='D403';Y=132; LowRef='U407';LowU=2;HighRef='U408';HighU=2;AndRef='U409';AndU=3;InvU=3},
  [pscustomobject]@{N='UP';Raw='LIMIT_UP_RAW';Ret='LIMIT_UP_RETURN';Cond='LIMIT_UP_COND';Fault='LIMIT_UP_FAULT';Sense='LIMIT_UP_SENSE';Exc='R414';Ser='R415';Cap='C406';D='D404';Y=172; LowRef='U406';LowU=3;HighRef='U407';HighU=3;AndRef='U409';AndU=4;InvU=4},
  [pscustomobject]@{N='DOWN';Raw='LIMIT_DOWN_RAW';Ret='LIMIT_DOWN_RETURN';Cond='LIMIT_DOWN_COND';Fault='LIMIT_DOWN_FAULT';Sense='LIMIT_DOWN_SENSE';Exc='R416';Ser='R417';Cap='C407';D='D405';Y=212; LowRef='U408';LowU=3;HighRef='U406';HighU=4;AndRef='U410';AndU=1;InvU=5}
)
$isoR=427; $isoC=415; $fbR=439; $pullR=451; $pdR=458; $tp=401
foreach($l in $loops){
 Text ("{0} — supervised NC window" -f $l.N) 18 ($l.Y-12); HLabel $l.Raw 'input' 18 $l.Y; HLabel $l.Ret 'input' 18 ($l.Y+5)
 Passive 'R' $l.Exc '2.20 kΩ ±1% loop excitation' 'FIELD_SENSE_VCC' $l.Raw 40 $l.Y; Passive 'D' $l.D 'TPD4E05U06 channel / low-cap ESD clamp' $l.Raw 'GND' 60 $l.Y; Passive 'R' $l.Ser '1.00 kΩ ±1% protected series' $l.Raw $l.Sense 80 $l.Y; Passive 'C' $l.Cap '100 nF X7R/C0G, τ=100 µs' $l.Sense 'GND' 100 $l.Y
 $loLocal="$($l.N)_VLOW"; $hiLocal="$($l.N)_VHIGH"; $win="$($l.N)_WINDOW_OK"; $qual="$($l.N)_QUAL_OK"; $assert="$($l.N)_ASSERTED"
 Passive 'R' ("R$isoR") '10.0 kΩ ±0.1% reference isolation' 'VREF_1V' $loLocal 125 ($l.Y-5); Passive 'C' ("C$isoC") '10 nF X7R local threshold filter' $loLocal 'GND' 145 ($l.Y-5); Passive 'R' ("R$fbR") '499 kΩ ±1% external hysteresis' $win $loLocal 165 ($l.Y-5); $isoR++;$isoC++;$fbR++
 Passive 'R' ("R$isoR") '10.0 kΩ ±0.1% reference isolation' 'VREF_4V' $hiLocal 125 ($l.Y+5); Passive 'C' ("C$isoC") '10 nF X7R local threshold filter' $hiLocal 'GND' 145 ($l.Y+5); Passive 'R' ("R$fbR") '499 kΩ ±1% external hysteresis' $win $hiLocal 165 ($l.Y+5); $isoR++;$isoC++;$fbR++
 Comp $l.LowRef $l.LowU $loLocal $l.Sense $win 195 ($l.Y-4); Comp $l.HighRef $l.HighU $l.Sense $hiLocal $win 195 ($l.Y+4); Passive 'R' ("R$pullR") '10.0 kΩ ±1% open-drain pull-up' '+3V3_CORE' $win 218 $l.Y; $pullR++
 And $l.AndRef $l.AndU $win 'FIELD_OK' $qual 245 $l.Y; Passive 'R' ("R$pdR") '100 kΩ fail-low qualifier bias' $qual 'GND' 265 ($l.Y+5); $pdR++; Inv $l.InvU $qual $assert 280 $l.Y
 Label $assert 292 $l.Y; Label $l.Cond 292 $l.Y; Label $l.Fault 292 $l.Y; if($l.N -eq 'STOP'){Label 'STOP_IN_FAULT' 292 $l.Y}; HLabel $l.Cond 'output' 315 $l.Y 180
 TP ("TP$tp") $l.Raw 335 ($l.Y-6);$tp++; TP ("TP$tp") $l.Sense 350 ($l.Y-6);$tp++; TP ("TP$tp") $win 365 ($l.Y-6);$tp++; TP ("TP$tp") $assert 380 ($l.Y-6);$tp++; TP ("TP$tp") $l.Fault 395 ($l.Y-6);$tp++
}

Text 'STOP — independent hardware inhibit export' 220 242
Sym 'IPC100:SN74LVC1G17QDBVRQ1' 'U405' 'SN74LVC1G17QDBVRQ1 STOP export' 1 255 250 @('1','2','3','4','5'); Label 'STOP_ASSERTED' 248.65 250; Label '+3V3_CORE' 248.65 247.46; Label 'GND' 248.65 252.54; Label 'STOP_HW_INHIBIT' 261.35 250
Passive 'R' 'R418' '100 kΩ fail-high bias' '+3V3_CORE' 'STOP_HW_INHIBIT' 280 250; HLabel 'STOP_HW_INHIBIT' 'output' 315 250 180; TP ("TP$tp") 'STOP_HW_INHIBIT' 335 250;$tp++

$cmds=@(
 [pscustomobject]@{N='ARM';Raw='ARM_IN_RAW';Sense='ARM_IN_SENSE';Cond='ARM_IN_COND';Wet='R419';Ser='R420';Pd='R421';Cap='C408';D='D406';Y=275;Ref='U407';Unit=4;AndU=2},
 [pscustomobject]@{N='FIRE';Raw='FIRE_IN_RAW';Sense='FIRE_IN_SENSE';Cond='FIRE_IN_COND';Wet='R422';Ser='R423';Pd='R424';Cap='C409';D='D407';Y=310;Ref='U408';Unit=4;AndU=3}
)
foreach($c in $cmds){ Text ("$($c.N) — NO command receiver") 18 ($c.Y-12); HLabel $c.Raw 'input' 18 $c.Y; Passive 'R' $c.Wet '10.0 kΩ ±1% main-only wetting' 'FIELD_SENSE_VCC' $c.Raw 40 $c.Y; Passive 'D' $c.D 'TPD4E05U06 channel / low-cap ESD clamp' $c.Raw 'GND' 60 $c.Y; Passive 'R' $c.Ser '1.00 kΩ ±1% protected series' $c.Raw $c.Sense 80 $c.Y; Passive 'C' $c.Cap '100 nF X7R input filter' $c.Sense 'GND' 100 $c.Y; Passive 'R' $c.Pd '100 kΩ deterministic field-off pull-down' $c.Sense 'GND' 120 $c.Y
 $local="$($c.N)_VMID";$req="$($c.N)_REQUEST_OK";$active="$($c.N)_ACTIVE"; Passive 'R' ("R$isoR") '10.0 kΩ ±0.1% reference isolation' 'VREF_2V5' $local 145 ($c.Y-5); Passive 'C' ("C$isoC") '10 nF X7R local threshold filter' $local 'GND' 165 ($c.Y-5); Passive 'R' ("R$fbR") '499 kΩ ±1% external hysteresis' $req $local 185 ($c.Y-5);$isoR++;$isoC++;$fbR++
 Comp $c.Ref $c.Unit $local $c.Sense $req 215 $c.Y; Passive 'R' ("R$pullR") '10.0 kΩ ±1% open-drain pull-up' '+3V3_CORE' $req 238 $c.Y;$pullR++; And 'U410' $c.AndU $req 'FIELD_OK' $active 265 $c.Y; Passive 'R' ("R$pdR") '100 kΩ fail-low ACTIVE bias' $active 'GND' 285 ($c.Y+5);$pdR++; Label $active 295 $c.Y; Label $c.Cond 295 $c.Y; HLabel $c.Cond 'output' 315 $c.Y 180
 TP ("TP$tp") $c.Raw 335 ($c.Y-6);$tp++;TP ("TP$tp") $c.Sense 350 ($c.Y-6);$tp++;TP ("TP$tp") $req 365 ($c.Y-6);$tp++;TP ("TP$tp") $active 380 ($c.Y-6);$tp++
}

Text 'PACKAGE POWER, DECOUPLING, UNUSED UNITS, AND SHARED DFT' 18 338
$powers=@(@('U406','TLV',5,'C410','FIELD_SENSE_VCC'),@('U407','TLV',5,'C411','FIELD_SENSE_VCC'),@('U408','TLV',5,'C412','FIELD_SENSE_VCC'),@('U409','AND',5,'C427','+3V3_CORE'),@('U410','AND',5,'C428','+3V3_CORE'),@('U411','INV',7,'C429','+3V3_CORE'))
$px=35
foreach($p in $powers){ if($p[1]-eq 'TLV'){Sym 'IPC100:TLV7044QPWRQ1' $p[0] 'TLV7044QPWRQ1 power' 5 $px 350 @('4','11');Label $p[4] ($px-6.35) 348.73;Label 'GND' ($px-6.35) 351.27} elseif($p[1]-eq 'AND'){Sym 'IPC100:SN74LVC08AQPWRQ1' $p[0] 'SN74LVC08AQPWRQ1 power' 5 $px 350 @('14','7');Label $p[4] ($px-6.35) 348.73;Label 'GND' ($px-6.35) 351.27}else{Sym 'IPC100:SN74LVC14AQPWRQ1' $p[0] 'SN74LVC14AQPWRQ1 power' 7 $px 350 @('14','7');Label $p[4] ($px-6.35) 348.73;Label 'GND' ($px-6.35) 351.27}; Passive 'C' $p[3] '100 nF X7R package-local bypass' $p[4] 'GND' $px 362;$px+=55 }
Passive 'C' 'C430' '100 nF X7R U404 local bypass' '+3V3_CORE' 'GND' 35 375; Passive 'C' 'C431' '100 nF X7R U405 local bypass' '+3V3_CORE' 'GND' 55 375; Passive 'C' 'C413' '1 µF X7R local logic bulk' '+3V3_CORE' 'GND' 75 375
And 'U410' 4 'GND' 'GND' 'U410_UNUSED_Y' 125 375; Add ('  (no_connect (at 131.35 375) (uuid {0}))' -f (Uuid)); Inv 6 'GND' 'U411_UNUSED_Y' 165 375; Add ('  (no_connect (at 170.08 375) (uuid {0}))' -f (Uuid))
TP ("TP$tp") 'VREF_1V' 205 350;$tp++;TP ("TP$tp") 'VREF_4V' 225 350;$tp++;TP ("TP$tp") 'VREF_2V5' 245 350;$tp++;TP ("TP$tp") 'FIELD_OK' 265 350;$tp++
Add '  (sheet_instances (path "/" (page "5")))'
Add ')'

[IO.File]::WriteAllLines($out, $lines, [Text.UTF8Encoding]::new($false))
Write-Output "ECO-011A1R Sheet 04 generated: $($lines.Count) lines; final test reference TP$($tp-1)."
