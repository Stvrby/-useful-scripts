New-GPO -Name "[Security](GPO,Computer) LSASS Protection (Mimikatz)" -Comment "##################################`r`n`r`nProtect the process lsass.exe to avoid an attacker to hijack credentials by dumping lsass.exe`r`n`r`nRequire: Do not deploy on computers that require Smartcard/2FA with DLL not signed by Microsoft            `r`nSide effect: Block all DLL not signed by Microsoft.`r`nIf disabled: An attacker can abuse of dumping lsass.exe to grab AD credentials of past connections.`r`nDoc: https://itm4n.github.io/lsass-runasppl/`r`n`r`nRunAsPPL=1 => Enforce with UEFI + SecureBoot`r`nRunAsPPL=2 => Enforce without UEFI + SecureBoot" | %{
	$_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -ValueName "UseLogonCredential" -Value 0 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -ValueName "Negotiate" -Value 0 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Control\LSA" -ValueName "RunAsPPL" -Value 2 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Control\LSA" -ValueName "DisableRestrictedAdmin" -Value 0 -Type DWord >$null
	$_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Control\LSA" -ValueName "DisableRestrictedAdminOutboundCreds" -Value 1 -Type DWord >$null
	$_
}