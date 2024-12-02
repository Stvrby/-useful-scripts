###########################################################################################
# [Security](GPO,Computer) WIFI-Protection - AirStrike
###########################################################################################
New-GPO -Name "[Security](GPO,Computer) WIFI-Protection - AirStrike" | %{
	$_ | Set-GPRegistryValue -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" -ValueName "DontDisplayNetworkSelectionUI" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -ValueName "value" -Value 0 -Type DWord >$null
	$_
} | New-GPLink -target "$(([ADSI]'LDAP://RootDSE').defaultNamingContext.Value)" -LinkEnabled Yes