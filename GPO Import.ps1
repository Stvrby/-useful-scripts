# Importer les modules nécessaires
Import-Module ActiveDirectory            
Import-Module GroupPolicy  

# Définir le chemin des sauvegardes des GPOs
$GPOFolderName = "C:\Temp\Project_GPOs"

# Vérifier si le dossier existe
if (!(Test-Path $GPOFolderName)) {
    Write-Output "Le chemin spécifié ($GPOFolderName) n'existe pas. Veuillez vérifier."
    exit
}

# Parcourir les dossiers contenant les sauvegardes des GPOs
$import_array = Get-ChildItem $GPOFolderName | Where-Object { $_.PSIsContainer }

foreach ($ID in $import_array) {
    # Chemin vers le fichier XML contenant les informations de la GPO
    $XMLFile = "$($ID.FullName)\gpreport.xml"

    # Vérifier si le fichier XML existe
    if (!(Test-Path $XMLFile)) {
        Write-Output "Fichier XML introuvable dans $($ID.FullName). Passage à la GPO suivante."
        continue
    }

    # Charger les données XML
    $XMLData = [XML](Get-Content $XMLFile)

    # Extraire le nom de la GPO depuis le fichier XML
    $GPOName = $XMLData.GPO.Name

    # Restaurer la GPO en spécifiant le TargetName
    try {
        Import-GPO -BackupId $ID.Name -Path $GPOFolderName -TargetName $GPOName -CreateIfNeeded
        Write-Output "GPO restaurée : $GPOName depuis $($ID.FullName)"
    } catch {
        Write-Output "Erreur lors de la restauration de la GPO : $GPOName. Erreur : $_"
    }
}

Write-Output "Importation des GPOs terminée."
