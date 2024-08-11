{
:log warning "RECONFIG: Reconfiguring Network for Soss ATT 192.168.4.0/22"
:put "Reconfiguring Network for ATT 192.168.4.0/22"
# Remove 192.168.75.0/24 configuration
/ip address remove [/ip address find interface=bridge-LAN]
/ip pool remove [/ip pool find name=DefaultDHCP]
/ip dhcp-server network remove [/ip dhcp-server network find comment="Default LAN"]
/ip dhcp-server remove default

# Apply new configuration
/ip address add address="192.168.4.1/22" interface=bridge-LAN network=192.168.4.0
/ip pool add name=DefaultDHCP ranges="192.168.4.10-192.168.7.250"
/ip dhcp-server network add address="192.168.4.0/22" comment="Default LAN" dns-server=192.168.4.1,1.1.1.1,8.8.8.8 gateway=192.168.4.1
/ip dhcp-server add address-pool=DefaultDHCP disabled=no interface=bridge-LAN name=default
/ip dns set servers=1.1.1.1,8.8.8.8
:put "Reconfiguration Complete"
:log warning "RECONFIG: Reconfiguration Complete"
:log warning "RECONFIG: Resetting Interfaces"

:log warning "RECONFIG: Removing Scripts"
/system script remove [find name=DHCP_Server_ATT-Reconfig]
{
    :local ifaces [/interface find type="ether"]
    :foreach iface in=$ifaces do={
        :local ifaceName [/interface get $iface name]
        :log warning "RECONFIG: Resetting $ifaceName"
        /interface set $iface disabled=yes
        /interface set $iface disabled=no
    }
}
}
            
}