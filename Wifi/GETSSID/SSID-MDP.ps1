# Force console en UTF-8 (affichage)
chcp 65001 > $null

$path = "C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces"
$xmlFiles = Get-ChildItem $path -Recurse -Filter *.xml -ErrorAction SilentlyContinue

foreach ($file in $xmlFiles) {

    [xml]$xml = Get-Content $file.FullName -Encoding UTF8
    $ssid = $xml.WLANProfile.SSIDConfig.SSID.name

    if ($ssid) {

        Write-Host "SSID : $ssid"

        $out = netsh wlan show profile name="$ssid" key=clear 2>$null

        $line = $out | Where-Object { $_ -match ':' } | Where-Object { $_ -match 'clé|Key|Content|Contenu' } #for english and french

        if ($line -and $line -match ':\s*(.+)$') {
            $key = $matches[1].Trim()
            Write-Host "key: $key"
        }
        else {
            Write-Host "key: no key (public wifi)"
        }

    }
}

Read-Host "finito"

