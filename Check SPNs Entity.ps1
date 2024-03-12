# Paramètres du script
$EntityName = "XXXXX"  # Remplacez par le nom de l'entité cible
$CsvFilePath = "C:\tmp\SPNList.csv"  # Chemin du fichier CSV de sortie

# Exécuter la commande setspn et capturer la sortie
try {
    $SPNs = setspn -Q "*/$EntityName" 

    # Préparer une liste pour collecter les données SPN
    $SPNEntries = @()

    foreach ($SPN in $SPNs) {
        if ($SPN.Trim() -ne "") {  # Vérifier que la ligne n'est pas vide
            # Ajouter chaque ligne non vide à la liste des entrées SPN
            $SPNEntries += [PSCustomObject]@{
                Entity = $EntityName
                SPN    = $SPN.Trim()
            }
        }
    }

    # Exporter les entrées SPN dans un fichier CSV
    $SPNEntries | Export-Csv -Path $CsvFilePath -NoTypeInformation -Encoding UTF8

    # Message de confirmation dans la console
    if ($SPNEntries.Count -eq 0) {
        Write-Host "Aucun SPN trouvé pour $EntityName."
    } else {
        Write-Host "Analyse terminée pour $EntityName avec $($SPNEntries.Count) SPNs trouvés. Les résultats ont été enregistrés dans $CsvFilePath"
    }
} catch {
    Write-Host "Erreur lors de la récupération des SPNs: $_"
}
