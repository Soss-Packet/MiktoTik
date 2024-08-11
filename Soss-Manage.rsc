/interface wireless add name=Soss-Management-AP ssid=SOSS-Management wps-mode=disabled disabled=no master-interface=wlan2G band=2ghz-onlyn frequency=auto channel-width=20/40mhz-Ce hide-ssid=yes
/interface wireless security-profiles add name=SOSS-Management mode=dynamic-keys authentication-types=wpa2-psk,wpa-psk,wpa2-eap,wpa-eap wpa-pre-shared-key=U&5SossM@nAg3 wpa2-pre-shared-key=U&5SossM@nAg3
/interface wireless set Soss-Management-AP security-profile=SOSS-Management
/interface wireless set wlan2G ssid=SneakyBeaky
/interface bridge port add bridge=bridge-LAN interface=Soss-Management-AP
:local ddnsAddress [/ip cloud get dns-name]
:local dhcpIP [/ip dhcp-client get [find interface="ether1-gateway"] address]
:local mikrotikMAC [/interface ethernet get ether1-gateway mac-address]
:local hostname [/system identity get name]

:put ("==============================================================================
This is a SOSS Edition Management MT
     _______
   .'       `.
 .'           `.
 | SOSS-MANAGE |
 |     UGS     |
 |             |
 |             |
 |   Alrefdo   |
 |   Marinara  |
 |             |
 |             |
 |             |
 |_____________|
Here is your DDNS Address: " . $ddnsAddress)
:put "
Copy this info to send to site IT for setup if needed:"
:put ("MikroTik DHCP IP: " . $dhcpIP)
:put ("MikroTik MAC: " . $mikrotikMAC)
:put ("Hostname: " . $hostname)
:local wlanStatus [/interface wireless get wlan2G disabled]
:if ($wlanStatus = "false") do={
    :put "wlan2G was already enabled, SSID not hidden, hide if not in use. DO NOT DISABLE"
} else={
    /interface wireless set wlan2G disabled=no hide-ssid=yes
    :put "
wlan2G SSID now changed to SSID=SneakyBeaky and is Hidden! Unhide and change ssid if you decide to use it for site. 
DO NOT DISABLE wlan2G 
=============================================================================="
/file remove [/file find name="flash/Soss-Manage.rsc"]
}

