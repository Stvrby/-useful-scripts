' Définir le chemin du dossier de logs
logFolderPath = "XXX"

' Obtenir le nom NetBIOS de la machine
Set objNetwork = CreateObject("WScript.Network")
computerName = objNetwork.ComputerName

' Créer le chemin complet du fichier journal
logFilePath = logFolderPath & computerName & ".IPv6_PrefixPolicies_Log.txt"

' Fonction pour exécuter une commande et récupérer la sortie
Function ExecuteCommand(command)
    Set objShell = CreateObject("WScript.Shell")
    Set objExec = objShell.Exec(command)
    ExecuteCommand = objExec.StdOut.ReadAll()
End Function

' Récupérer la table des préfixes IPv6 actuelle
currentPrefixPolicies = ExecuteCommand("netsh interface ipv6 show prefixpolicies")

' Ajout des commandes de modification de la table des préfixes IPv6
prefixCommands = Array( _
    "netsh interface ipv6 set prefixpolicy ::ffff:0:0/96 50 0", _
    "netsh interface ipv6 set prefixpolicy ::1/128 40 1", _
    "netsh interface ipv6 set prefixpolicy ::/0 30 2", _
    "netsh interface ipv6 set prefixpolicy 2002::/16 20 3", _
    "netsh interface ipv6 set prefixpolicy 2001::/32 5 5", _
    "netsh interface ipv6 set prefixpolicy fc00::/7 3 13", _
    "netsh interface ipv6 set prefixpolicy fec0::/10 1 11", _
    "netsh interface ipv6 set prefixpolicy 3ffe::/16 1 12", _
    "netsh interface ipv6 set prefixpolicy ::/96 1 4" _
)

' Exécuter chaque commande de modification de préfixe IPv6
For Each command In prefixCommands
    ExecuteCommand command
Next

' Vérifier les préfixes IPv6 après modification
newPrefixPolicies = ExecuteCommand("netsh interface ipv6 show prefixpolicies")

' Créer le contenu du fichier journal avant et après modification
logContent = "Date et heure de l'exécution : " & Now & vbCrLf & _
             "Machine : " & computerName & vbCrLf & _
             "Table des préfixes IPv6 avant modification :" & vbCrLf & _
             currentPrefixPolicies & vbCrLf & _
             "Commandes de modification exécutées :" & vbCrLf & _
             Join(prefixCommands, vbCrLf) & vbCrLf & _
             "Préfixes IPv6 après modification :" & vbCrLf & _
             newPrefixPolicies

' Ajouter le contenu au journal
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile(logFilePath, 2, True)
objLogFile.WriteLine logContent
objLogFile.Close

' Afficher le contenu dans la console
WScript.Echo logContent
WScript.Echo "Les résultats ont été enregistrés dans : " & logFilePath
