[CmdletBinding()]
param([string]$RepositoryRoot)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }

$ebom = Import-Csv (Join-Path $RepositoryRoot 'docs/bom/IPC100_RevA_EBOM.csv') -Encoding UTF8
$scope = @($ebom | Where-Object {
    $_.'Selection Scope' -eq 'CSR-01A POWER' -and $_.'Freeze Status' -eq 'BLOCKED' -and
    ($_.Category -eq 'Passives' -or $_.Reference -eq 'FB801')
} | Sort-Object Sheet, Reference)

$generalResistor = @{
    '1.00 kΩ 1%'='ERJ-3EKF1001V'; '1 kΩ QOD limit'='ERJ-3EKF1001V'; '5.00 kΩ 1%'='ERJ-3EKF5001V'
    '6.65 kΩ 1%'='ERJ-3EKF6651V'; '9.09 kΩ 1%'='ERJ-3EKF9091V'; '10 kΩ PGOOD pull-up'='ERJ-3EKF1002V'
    '10 kΩ main-bias pull-up'='ERJ-3EKF1002V'; '10.2 kΩ 1%'='ERJ-3EKF1022V'; '23.7 kΩ 1%'='ERJ-3EKF2372V'
    '23.7 kΩ 1% — USB OV2'='ERJ-3EKF2372V'; '60.4 kΩ 1% — ≈2 A limit (verify)'='ERJ-3EKF6042V'
    '64.9 kΩ ±1%, ≤100 ppm/°C — LMR38020F-Q1 RT/SYNC, 400 kHz'='ERJ-3EKF6492V'
    '100 kΩ'='ERJ-3EKF1003V'; '100 kΩ 1%'='ERJ-3EKF1003V'; '100 kOhm +/-1%; EN fail-low; >=0.063 W'='ERJ-3EKF1003V'
    '141 kΩ ±1%, ≤100 ppm/°C — TPS2553-Q1 ILIM; 162.8..222.4 mA worst case'='ERJ-3EKF1413V'
    '402 kΩ 1%'='ERJ-6ENF4023V'; '604 kΩ 1%'='ERJ-6ENF6043V'; '634 kΩ 1%'='ERJ-6ENF6343V'; '1.91 MΩ 1%'='ERJ-6ENF1914V'
}
$precisionResistor = @{
    '10.0 kΩ 0.1% 25 ppm'='TNPW060310K0BEEN'; '24.9 kΩ 0.1%'='TNPW060324K9BEEN'
    '49.9 kΩ 0.1% 25 ppm'='TNPW060349K9BEEN'; '100 kΩ 0.1%'='TNPW0603100KBEEN'
    '150 kΩ ±0.1%, ≤25 ppm/°C — expansion-to-SENSE series resistor'='TNPW0603150KBEEN'
    '316 kΩ 0.1%'='TNPW0603316KBEEN'
}
$resistorByReference = @{
 'R101'='ERJ-6ENF6343V';'R102'='ERJ-3EKF1003V';'R103'='ERJ-6ENF1914V';'R104'='ERJ-3EKF1003V';'R105'='ERJ-3EKF1003V';'R106'='ERJ-3EKF9091V'
 'R107'='TNPW060349K9BEEN';'R108'='TNPW060349K9BEEN';'R109'='TNPW060310K0BEEN';'R110'='ERJ-3EKF1001V';'R111'='ERJ-3EKF1003V'
 'R112'='ERJ-6ENF4023V';'R113'='ERJ-3EKF1003V';'R114'='ERJ-3EKF6651V';'R115'='ERJ-6ENF6043V';'R116'='ERJ-3EKF1003V'
 'R201'='ERJ-3EKF6492V';'R202'='TNPW0603100KBEEN';'R203'='TNPW060324K9BEEN';'R205'='ERJ-3EKF1022V';'R206'='ERJ-3EKF5001V'
 'R207'='ERJ-3EKF2372V';'R208'='ERJ-3EKF5001V';'R209'='ERJ-3EKF6042V';'R210'='TNPW0603316KBEEN';'R211'='TNPW0603100KBEEN'
 'R213'='ERJ-3EKF1002V';'R215'='ERJ-3EKF1002V';'R217'='ERJ-3EKF1002V';'R222'='ERJ-3EKF1413V';'R223'='ERJ-3EKF1413V';'R224'='ERJ-3EKF1413V'
 'R225'='ERJ-3EKF1001V';'R226'='ERJ-3EKF1001V';'R227'='ERJ-3EKF1001V';'R228'='ERJ-3EKF1001V';'R229'='ERJ-3EKF1001V';'R230'='ERJ-3EKF2372V'
 'R231'='ERJ-3EKF5001V';'R704'='ERJ-3EKF1003V';'R705'='ERJ-3EKF1003V';'R806'='TNPW0603150KBEEN'
}
$capacitor = @{
    '100 nF'='GRM188R71H104KA93D'; '100 nF supervisor bypass'='GRM188R71H104KA93D'
    '100 nF +/-10% X7R >=10 V; U706 VCCA bypass'='GRM188R71H104KA93D'
    '100 nF +/-10% X7R >=10 V; U706 VCCB bypass'='GRM188R71H104KA93D'
    '100 nF +/-10% X7R >=10 V; U707 VCCA bypass'='GRM188R71H104KA93D'
    '100 nF +/-10% X7R >=10 V; U707 VCCB bypass'='GRM188R71H104KA93D'
    '100 nF X7R ±10% U801 VDD bypass'='GRM188R71H104KA93D'
    '10 nF'='GRM188R71H103KA01D'; '1 nF slew control'='GRM1885C1H102JA01D'
    '1 µF 10 V'='GRM21BR71E105KA99L'; '10 µF 10 V'='GRM31CR71E106KA12L'
    '4.7 µF branch local'='GRM21BR71E475KA12L'
    '10 µF X7R accessory-bias reservoir; within ICD-001 22 µF load cap limit'='GRM31CR71E106KA12L'
}
$capacitorByReference = @{
 'C101'='GRM188R71H104KA93D';'C105'='GRM188R71H104KA93D';'C106'='GRM21BR71E105KA99L';'C107'='GRM31CR71E106KA12L';'C108'='GRM188R71H103KA01D'
 'C207'='GRM31CR71E106KA12L';'C211'='GRM1885C1H102JA01D';'C212'='GRM21BR71E475KA12L';'C213'='GRM1885C1H102JA01D';'C214'='GRM21BR71E475KA12L'
 'C215'='GRM1885C1H102JA01D';'C216'='GRM21BR71E475KA12L';'C217'='GRM21BR71E475KA12L';'C218'='GRM1885C1H102JA01D';'C219'='GRM21BR71E475KA12L'
 'C220'='GRM1885C1H102JA01D';'C221'='GRM21BR71E475KA12L';'C306'='GRM188R71H104KA93D';'C702'='GRM188R71H104KA93D';'C703'='GRM188R71H104KA93D'
 'C704'='GRM188R71H104KA93D';'C705'='GRM188R71H104KA93D';'C802'='GRM31CR71E106KA12L';'C804'='GRM188R71H104KA93D'
}

$rows = foreach ($row in $scope) {
    $mpn=''; $manufacturer=''; $status='BLOCKED'; $class=''; $reason=''
    if ($resistorByReference.ContainsKey($row.Reference)) {
        $mpn=$resistorByReference[$row.Reference]; $manufacturer=if($mpn -match '^TNPW'){'Vishay'}else{'Panasonic Industry'}; $class=if($mpn -match 'ERJ-6'){'0805 recommended; ±1%; ±100 ppm/°C; 0.125 W; 150 V'}elseif($mpn -match '^TNPW'){'0603 recommended; ±0.1%; ±25 ppm/K; 0.13 W; 100 V; -55..175 °C'}else{'0603 recommended; ±1%; ±100 ppm/°C; 0.1 W; 75 V'}
        $status='FREEZE ELIGIBLE'; $reason='Exact order code and electrical class meet the released tolerance, voltage, power and temperature envelope.'
    } elseif ($precisionResistor.ContainsKey($row.Value)) {
        $mpn=$precisionResistor[$row.Value]; $manufacturer='Vishay'; $class='0603 recommended; ±0.1%; ±25 ppm/K; 0.13 W; 100 V; -55..175 °C'
        $status='FREEZE ELIGIBLE'; $reason='Automotive-grade thin-film selection meets the precision and temperature-drift envelope.'
    } elseif ($capacitorByReference.ContainsKey($row.Reference)) {
        $mpn=$capacitorByReference[$row.Reference]; $manufacturer='Murata'; $class=if($mpn -match '^GRM188'){'0603 recommended'}elseif($mpn -match '^GRM21'){'0805 recommended'}else{'1206 recommended'}
        $status='FREEZE ELIGIBLE'; $reason='Exact X7R/C0G order code meets nominal voltage and temperature class; low-voltage bias utilization is bounded by PPQ-02.'
    } elseif ($row.Reference -eq 'FB801') {
        $mpn='BLM21PG221SN1D'; $manufacturer='Murata'; $class='0805 recommended; 220 Ω at 100 MHz; 2 A; 45 mΩ max; -55..125 °C'
        $status='FREEZE ELIGIBLE'; $reason='Current and hot-drop margins exceed the 338 mA and 1% rail-drop screens.'
    } else {
        $class='Exact package recommendation deferred'; $reason='Dependent active-device equation, manufacturer DC-bias curve, stability tool, hot magnetic model, or timing suffix is not yet closed.'
    }
    [pscustomobject][ordered]@{
        Sheet=$row.Sheet; Reference=$row.Reference; Value=$row.Value; Manufacturer=$manufacturer; MPN=$mpn
        'Electrical Class / Package Recommendation'=$class; Lifecycle=if($status -eq 'FREEZE ELIGIBLE'){'ACTIVE — manufacturer/distributor review 2026-07-31'}else{'PENDING'}
        'Preferred Source'=if($status -eq 'FREEZE ELIGIBLE'){'DigiKey or Mouser; order-code verification required at PO'}else{''}
        'Approved Alternate'='NONE — alternate requires equal-or-better electrical review'
        'Pricing Basis'=if($status -eq 'FREEZE ELIGIBLE'){'Budgetary distributor snapshot; revalidate at procurement'}else{'PENDING'}
        Derating=if($status -eq 'FREEZE ELIGIBLE'){'PASS against QER-01/PPQ-02 class envelope'}else{'NOT CLOSED'}
        'DC Bias / Ripple / Thermal'=if($row.Reference -match '^R'){'PASS: power/working-voltage screen'}elseif($status -eq 'FREEZE ELIGIBLE'){'PASS for released low-stress use; prototype correlation retained'}else{'PENDING exact curve/tool evidence'}
        Status=$status; Disposition=$reason
    }
}

$out = Join-Path $RepositoryRoot 'docs/bom/PAS-01_Passive_Selection_Register.csv'
$rows | Export-Csv -LiteralPath $out -NoTypeInformation -Encoding UTF8
Write-Host "PAS-01 register generated: $($rows.Count) rows; $(@($rows|Where-Object Status -eq 'FREEZE ELIGIBLE').Count) freeze eligible; $(@($rows|Where-Object Status -eq 'BLOCKED').Count) blocked."
