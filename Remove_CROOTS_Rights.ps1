# Script de retrait des droits sur C:\
# Version simplifiée
# ⚠ Side effect: Aucun

$commands = @(
    'C:\ /remove:g "NT AUTHORITY\Utilisateurs authentifiés"',
    'C:\ /remove:g "Utilisateurs authentifiés"',
    'C:\ /remove:g "NT AUTHORITY\Authenticated Users"',
    'C:\ /remove:g "Authenticated Users"'
)

foreach ($cmd in $commands) {
    Start-Process "icacls" -ArgumentList $cmd -NoNewWindow -Wait
}
