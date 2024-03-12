# Obtenir le nom de la machine
$computerName = $env:COMPUTERNAME

# Obtenir la liste des adaptateurs réseau actifs
$networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

$results = @()

foreach ($adapter in $networkAdapters) {
    $adapterName = $adapter.Name
    $ipv6Enabled = $adapter | Get-NetAdapterBinding -ComponentID 'ms_tcpip6' | Select-Object -ExpandProperty Enabled

    $result = [PSCustomObject]@{
        "Nom de la Machine" = $computerName
        "Nom de l'Adaptateur" = $adapterName
        "IPv6 Activée" = $ipv6Enabled
    }

    $results += $result
}

# Spécifier le chemin de destination pour l'exportation CSV
$exportPath = "C:\tmp\IPv6_Status.csv"

# Exporter les résultats au format CSV
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Les résultats ont été exportés dans le fichier '$exportPath'."
