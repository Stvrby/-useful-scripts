# Importer le module ActiveDirectory si nécessaire
Import-Module ActiveDirectory

# Définir le compte cible
$compteCible = "YXXXXX"

# Chemin du fichier CSV de sortie
$cheminCSV = "C:\Output.csv"

# Rechercher tous les objets AD et extraire les ACL
$resultats = Get-ADObject -Filter * -Properties * | ForEach-Object {
    $obj = $_
    Get-Acl -Path ("AD:\" + $obj.DistinguishedName) | ForEach-Object {
        $_.Access | Where-Object { $_.IdentityReference -like "*$compteCible*" } | ForEach-Object {
            [PSCustomObject]@{
                Path = $obj.DistinguishedName
                AccessType = $_.ActiveDirectoryRights
                Identity = $_.IdentityReference
                AccessControlType = $_.AccessControlType
                ObjectType = $_.ObjectType
                InheritedObjectType = $_.InheritedObjectType
                IsInherited = $_.IsInherited
            }
        }
    }
}

# Exporter les résultats dans un fichier CSV
$resultats | Export-Csv -Path $cheminCSV -NoTypeInformation

# Afficher le chemin du fichier CSV
Write-Host "Les résultats ont été exportés vers $cheminCSV"
