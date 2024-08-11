# Define variables
:local wanInterface "ether1-gateway"

# Retrieve WAN IP address and gateway
:local wanAddress [/ip dhcp-client get [find interface=$wanInterface] address]
:local gateway [/ip dhcp-client get [find interface=$wanInterface] gateway]

# Turn off DHCP client
/ip dhcp-client disable [find interface=$wanInterface]

# Wait for 5 seconds
:delay 5s

# Add static IP address and default gateway
/ip address add address=$wanAddress interface=$wanInterface
/ip route add distance=1 gateway=$gateway

# Set DNS servers
/ip dns set servers=1.1.1.1,8.8.8.8

/file remove [/file find name="flash/WAN_DHCP_To_Static.rsc"]