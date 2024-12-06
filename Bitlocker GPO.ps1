###########################################################################################
#[Hardening](GPO,Computer) Bitlocker
###########################################################################################
New-GPO -Name "[Hardening](GPO,Computer) Bitlocker" | %{
	$gpoId="{{{0}}}" -f $_.Id.ToString();
	$gpoName=$_.DisplayName
	$gpoDomainName=$_.DomainName
	$gpoLdapPath=$_.Path
	$gpoBasePath="C:\Windows\SYSVOL\domain\Policies\$gpoId"
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "ActiveDirectoryBackup" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "OSActiveDirectoryBackup" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "FDVActiveDirectoryBackup" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "RDVActiveDirectoryBackup" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "OSRecovery" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "RequireActiveDirectoryBackup" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "ActiveDirectoryInfoToStore" -Value 1 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "EncryptionMethodWithXtsOs" -Value 7 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "EncryptionMethodWithXtsFdv" -Value 7 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "EncryptionMethodWithXtsRdv" -Value 7 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "EncryptionMethodNoDiffuser" -Value 4 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\Software\Policies\Microsoft\FVE" -ValueName "EncryptionMethod" -Value 2 -Type DWord >$null
	$_
}