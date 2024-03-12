# Nom du compte à surveiller
$AccountName = "SYSTEM" 

# Obtenir le nom du serveur/computer
$ComputerName = $env:COMPUTERNAME

# Définir le chemin du fichier CSV où enregistrer les résultats, intégrant le nom du serveur et le compte utilisateur
$CsvFilePath = "C:\tmp\" + $ComputerName + "_AllActivities_" + $AccountName + ".csv"

# Assurez-vous que le dossier de sortie existe
$LogFolderPath = Split-Path -Path $CsvFilePath -Parent
if (-not (Test-Path $LogFolderPath)) {
    New-Item -Path $LogFolderPath -ItemType Directory
}

# Créer une liste vide pour stocker tous les objets
$AllActivities = @()

# Ajouter les informations des services à la liste
$Services = Get-WmiObject Win32_Service | Where-Object { $_.StartName -like "*$AccountName*" }
foreach ($service in $Services) {
    $AllActivities += [PSCustomObject]@{
        Type          = 'Service'
        ComputerName  = $ComputerName
        Name          = $service.Name
        DisplayName   = $service.DisplayName
        State         = $service.State
        StartName     = $service.StartName
        ProcessId     = $service.ProcessId 
        LastRunTime   = $null
        NextRunTime   = $null
    }
}

# Ajouter les informations des processus à la liste
$Processes = Get-WmiObject Win32_Process | ForEach-Object {
    $owner = $null
    try {
        $owner = $_.GetOwner().User
    } catch {
        # Exception lors de la récupération du propriétaire
    }

    if ($owner -match $AccountName) {
        $AllActivities += [PSCustomObject]@{
            Type         = 'Process'
            ComputerName = $ComputerName
            Name         = $_.Name
            DisplayName  = $null
            State        = $null
            StartName    = $owner
            ProcessId    = $_.ProcessId 
            LastRunTime  = $null
            NextRunTime  = $null
        }
    }
}

# Ajouter les informations des tâches planifiées à la liste
try {
    $ScheduledTasks = Get-ScheduledTask | where { $_.Principal.UserId -match $AccountName }
    foreach ($task in $ScheduledTasks) {
        $info = $task | Get-ScheduledTaskInfo
        $AllActivities += [PSCustomObject]@{
            Type         = 'ScheduledTask'
            ComputerName = $ComputerName
            Name         = $task.TaskName
            DisplayName  = $null
            State        = $null
            StartName    = $task.Principal.UserId
            ProcessId    = $null  # Les tâches planifiées n'ont pas de ProcessId pertinent ici
            LastRunTime  = $info.LastRunTime
            NextRunTime  = $info.NextRunTime
        }
    }
} catch {
    Write-Host "Erreur lors de la récupération des tâches planifiées: $_"
}

# Exporter toutes les activités dans un fichier CSV
$AllActivities | Export-Csv -Path $CsvFilePath -NoTypeInformation -Encoding UTF8

# Message de confirmation dans la console
Write-Host "Les informations sur toutes les activités associées à $AccountName ont été enregistrées dans $CsvFilePath"