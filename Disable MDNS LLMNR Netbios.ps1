###########################################################################################
# [Security](GPO,Computer) Disable-MDNS-NetBIOS-LLMNR
###########################################################################################
New-GPO -Name "[Security](GPO,Computer) Disable-MDNS-NetBIOS-LLMNR" -Comment "##################################`r`n`r`nDisable NetBIOS, MDNS and LLMNR.`r`nSide effect: None" | %{
    # Disable NetBIOS
    $_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -ValueName "EnableNetbios" -Value 0 -Type DWord >$null
    
    # Disable MDNS
    $_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -ValueName "EnableMDNS" -Value 0 -Type DWord >$null
    
    # Disable LLMNR
    $_ | Set-GPRegistryValue -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Value 0 -Type DWord >$null
    
    $_
} | New-GPLink -target "$(([ADSI]'LDAP://RootDSE').defaultNamingContext.Value)" -LinkEnabled Yes