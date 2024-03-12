# Emplacement du registre pour IPv6
$ipv6RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"

# Emplacement du registre pour IPv4
$ipv4RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

# Définir le chemin du dossier de logs
$logFolderPath = "C:\Temp"

# Obtenir le nom NetBIOS de la machine
$computerName = $env:COMPUTERNAME

# Créer le chemin complet du fichier journal
$logFilePath = Join-Path -Path $logFolderPath -ChildPath "$computerName.IPv4_IPv6_Prioritization_Log.txt"

# Récupérer l'état actuel du registre IPv4 et IPv6
$currentIPv4Value = (Get-ItemProperty -Path $ipv4RegistryPath -Name "DisabledComponents").DisabledComponents
$currentIPv6Value = (Get-ItemProperty -Path $ipv6RegistryPath -Name "DisabledComponents").DisabledComponents

# Vérifier les résultats complets du ping localhost avant modification
$pingResultBefore = ping localhost
$pingResultBeforeString = $pingResultAfter | Out-String

# Récupérer la table des préfixes IPv6 actuelle
$currentPrefixPolicies = netsh interface ipv6 show prefixpolicies
$currentPrefixPoliciesString = $currentPrefixPolicies | Out-String

# Créer le contenu de la configuration actuelle
$currentConfig = @"
Date et heure de l'exécution : $(Get-Date)
Machine : $computerName
État actuel de la configuration du poste :
IPv4 : $currentIPv4Value
IPv6 : $currentIPv6Value
$pingResultBeforeString
Table des préfixes IPv6 actuelle :
$currentPrefixPoliciesString
"@

# Ajouter le contenu de la configuration actuelle au journal
$currentConfig | Out-File -FilePath $logFilePath -Append

# Ajout des commandes de modification de la table des préfixes IPv6
$prefixCommands = @(
    "netsh interface ipv6 set prefixpolicy ::ffff:0:0/96 50 0",
    "netsh interface ipv6 set prefixpolicy ::1/128 40 1",
    "netsh interface ipv6 set prefixpolicy ::/0 30 2",
    "netsh interface ipv6 set prefixpolicy 2002::/16 20 3",
    "netsh interface ipv6 set prefixpolicy 2001::/32 5 5",
    "netsh interface ipv6 set prefixpolicy fc00::/7 3 13",
    "netsh interface ipv6 set prefixpolicy fec0::/10 1 11",
    "netsh interface ipv6 set prefixpolicy 3ffe::/16 1 12",
    "netsh interface ipv6 set prefixpolicy ::/96 1 4"
)

# Exécuter chaque commande de modification de préfixe IPv6
foreach ($command in $prefixCommands) {
    Invoke-Expression $command
}

# Continuation du script...

# Définir la priorité de l'IPv4 sur 0 et IPv6 sur 0x20
Set-ItemProperty -Path $ipv4RegistryPath -Name "DisabledComponents" -Value 0
Set-ItemProperty -Path $ipv6RegistryPath -Name "DisabledComponents" -Value 0x20

# Vérifier que les valeurs ont été correctement définies
$ipv4Value = (Get-ItemProperty -Path $ipv4RegistryPath -Name "DisabledComponents").DisabledComponents
$ipv6Value = (Get-ItemProperty -Path $ipv6RegistryPath -Name "DisabledComponents").DisabledComponents

# Vérifier les résultats complets du ping localhost après modification
$pingResultAfter = ping localhost
$pingResultAfterString = $pingResultAfter | Out-String

# Vérifier les préfixes IPv6 après modification
$prefixPolicies = netsh interface ipv6 show prefixpolicies
$prefixPoliciesString = $prefixPolicies | Out-String

# Créer le contenu du fichier journal après modification
$logContent = @"
Date et heure de l'exécution : $(Get-Date)
Machine : $computerName
Valeurs du Registre :
IPv4 : $ipv4Value
IPv6 : $ipv6Value
Résultat complet du ping localhost après modification :
$pingResultAfterString
Préfixes IPv6 après modification :
$prefixPoliciesString
"@

# Ajouter le contenu au journal
$logContent | Out-File -FilePath $logFilePath -Append

# Afficher le contenu dans la console
Write-Host $logContent
Write-Host "Les résultats ont été enregistrés dans : $logFilePath"
