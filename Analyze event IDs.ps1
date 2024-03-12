# Nom du compte à surveiller
$AccountName = "xxx"

# ID des événements à filtrer : Connexion réussie (4624), Déconnexion (4634) et Échec de connexion (4625)
$EventIDs = 4624,4634,4625,4720,4728

# Chemin du fichier CSV où enregistrer les résultats
$CsvFilePath = "C:\tmp\AccountLogAnalysis.csv"

# Date limite (par exemple, les événements des dernières 24 heures)
$StartTime = (Get-Date).AddDays(-1)
# Initialisation d'une liste pour stocker les informations des logs
$LogEntries = @()

# Collecte et analyse des logs de sécurité pour les ID d'événements spécifiés et dans la période de temps spécifiée
try {
    $Logs = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        ID        = $EventIDs
        StartTime = $StartTime
    }

    foreach ($Log in $Logs) {
        # Vérifiez si le nom d'utilisateur est dans l'événement spécifique
        if ($Log.Properties[5].Value -eq $AccountName) {
            # Préparation des informations de base
            $EventID = $Log.Id
            $TimeCreated = $Log.TimeCreated
            $Message = $Log.Message -replace "`r`n", "; "  # Remplace les sauts de ligne par des ';'

            # Extraction des informations supplémentaires
            $SecurityID = $Log.Properties[0].Value
            $LogonType = $Log.Properties[8].Value
            $SourceNetworkAddress = $Log.Properties[18].Value
            $AccountDomain = $Log.Properties[6].Value

            # Création d'un objet personnalisé pour chaque log
            $LogEntries += [PSCustomObject]@{
                AccountName           = $AccountName  # Nom du compte
                EventID               = $EventID
                AccountDomain         = $AccountDomain
                TimeCreated           = $TimeCreated
                Details               = $Message
                SecurityID            = $SecurityID  # ID de sécurité
                LogonType             = $LogonType  # Type de connexion
                SourceNetworkAddress  = $SourceNetworkAddress  # Adresse réseau source
            }
        }
    }
} catch {
    Write-Host "Erreur lors de la récupération des événements: $_"
}

# Exportation des entrées de log dans un fichier CSV
if ($LogEntries) {
    $LogEntries | Export-Csv -Path $CsvFilePath -NoTypeInformation -Encoding UTF8
    Write-Host "Analyse terminée pour $AccountName avec $($LogEntries.Count) événements trouvés. Les résultats ont été enregistrés dans $CsvFilePath"
} else {
    Write-Host "Aucun événement trouvé pour $AccountName dans la période spécifiée."
}