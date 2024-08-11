Copy and paste the Snippet below each script name into your RouterOS Terminal to run the listed script on your MikroTik:

(I will make this look pretty later)


WAN_DHCP_To_Static.rsc:
Applied the current DHCP IP as a static IP and turns off the DHCP Server (Great for DMZ)

{/file remove [find type="script"];:local fileCount [/file find type="script"];/tool fetch mode=https url="https://raw.githubusercontent.com/Fax-God/MiktoTik/main/WAN_DHCP_To_Static.rsc" keep-result=yes dst-path="flash/WAN_DHCP_To_Static.rsc";:while (:[/file find type="script"] = $fileCount) do={:delay 5s};/import file-name="flash/WAN_DHCP_To_Static.rsc";/file remove [/file find name="flash/WAN_DHCP_To_Static.rsc"]}

QOS_Print.rsc:
Print QOS Variables

{/file remove [find type="script"];:local fileCount [/file find type="script"];/tool fetch mode=https url="https://raw.githubusercontent.com/Fax-God/MiktoTik/main/QOS_Print.rsc" keep-result=yes dst-path="flash/QOS_Print.rsc";:while (:[/file find type="script"] = $fileCount) do={:delay 5s};/import file-name="flash/QOS_Print.rsc";/file remove [/file find name="flash/QOS_Print.rsc"]}

Que-Tree-Rebuilder.rsc:
Rebuild QOS Tree

{/file remove [find type="script"];:local fileCount [/file find type="script"];/tool fetch mode=https url="https://raw.githubusercontent.com/Fax-God/MiktoTik/main/Que-Tree-Rebuilder.rsc" keep-result=yes dst-path="flash/Que-Tree-Rebuilder.rsc";:while (:[/file find type="script"] = $fileCount) do={:delay 5s};/import file-name="flash/Que-Tree-Rebuilder.rsc";/file remove [/file find name="flash/Que-Tree-Rebuilder.rsc"]}

Soss_Manage.rsc:
Enables 2.4ghz wifi if not enabled already, hides the 2.4ghz SSID and setups a virtual AP for local management connection.
Variables configured: Hidden SSID, Security Profile, and add VAP interface to bridge-LAN.
After the script runs it will print out your DDNS, DHCP IP, MAC Address, and Hostname.

Will do a writeup later, just tossing scripts in for now
I use this when installing a MikroTik on a company site with managed IT. 
I have the MikroTik setup with my basic bootstrap and then run this script to setup the VAP and print variables I need to provide to whoever manages the network I am installing on. 
Then I can use IP Scan, find my devices, and port fwd them or run speed tests against my home network for remote management

{/file remove [find type="script"];:local fileCount [/file find type="script"];/tool fetch mode=https url="https://raw.githubusercontent.com/Fax-God/MiktoTik/main/Soss-Manage.rsc" keep-result=yes dst-path="flash/Soss-Manage.rsc";:while (:[/file find type="script"] = $fileCount) do={:delay 5s};/import file-name="flash/Soss-Manage.rsc";/file remove [/file find name="flash/Soss-Manage.rsc"]}

DHCP_Server_ATT-Reconfig.rsc:
Reconfigures a base config MT (192.168.75.0/24) for ATT Edgewater networks. 192.168.4.0/22 (Pool: 192.168.4.10-192.168.7.250)

{/file remove [find type="script"];:local fileCount [/file find type="script"];/tool fetch mode=https url="https://raw.githubusercontent.com/Fax-God/MiktoTik/main/DHCP_Server_ATT-Reconfig.rsc" keep-result=yes dst-path="flash/DHCP_Server_ATT-Reconfig.rsc";:while (:[/file find type="script"] = $fileCount) do={:delay 5s};/import file-name="flash/DHCP_Server_ATT-Reconfig.rsc";/file remove [/file find name="flash/DHCP_Server_ATT-Reconfig.rsc"]}

Ether1_Toggle_Interactive.rsc:
Turns off Ether1 for X seconds. 
Script will ask how long you want Ether1 disabled before it turns the port back on

{/file remove [find type="script"];:local fileCount [/file find type="script"];/tool fetch mode=https url="https://raw.githubusercontent.com/Fax-God/MiktoTik/main/Ether1_Toggle_Interactive.rsc" keep-result=yes dst-path="flash/Ether1_Toggle_Interactive.rsc";:while (:[/file find type="script"] = $fileCount) do={:delay 5s};/import file-name="flash/Ether1_Toggle_Interactive.rsc";/file remove [/file find name="flash/Ether1_Toggle_Interactive.rsc"]}



*All of this has been made in my free time for my convenience, figured I would share*
