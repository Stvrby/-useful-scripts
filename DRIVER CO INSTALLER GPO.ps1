###########################################################################################
# [Security](GPO,Computer) Driver-Installation-Protection
###########################################################################################
New-GPO -Name "[Security](GPO,Computer) Driver-Installation-Protection" | %{
    $_ | Set-GPRegistryValue -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer" -ValueName "DisableCoInstallers" -Value 1 -Type DWord >$null
    $_
} | New-GPLink -target "$(([ADSI]'LDAP://RootDSE').defaultNamingContext.Value)" -LinkEnabled Yes