###########################################################################################
# [Security](GPO,Computer) IPv6
###########################################################################################
New-GPO -Name "[Security](GPO,Computer) IPv6" -Comment "##################################`r`n`r`nProtection against Man-In-The-Middle.`r`nSide effect: None" | %{
    $_ | Set-GPRegistryValue -Key "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -ValueName "DisabledComponents" -Value 32 -Type DWord >$null
    $GpoSessionName = Open-NetGPO -PolicyStore ("{0}\{1}" -f $env:USERDNSDOMAIN,$_.DisplayName)
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] IPv6" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol IPv6 >$null
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] IPv6-Frag" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol IPv6-Frag >$null
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] IPv6-Route" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol IPv6-Route >$null
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] ICMPv6" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol ICMPv6 >$null
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] IPv6-NoNxt" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol IPv6-NoNxt >$null
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] IPv6-Opts" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol IPv6-Opts >$null
    New-NetFirewallRule -Enabled True -Profile Any -ErrorAction Continue -GPOSession $GpoSessionName -DisplayName "[GPO] DHCPv6" -Group "[GPO][Security](GPO,Computer) IPv6" -Action Block -Direction Outbound -Protocol UDP -RemotePort 547 >$null
    Save-NetGPO -GPOSession $GpoSessionName >$null
    $_
} | New-GPLink -target "$(([ADSI]'LDAP://RootDSE').defaultNamingContext.Value)" -LinkEnabled Yes