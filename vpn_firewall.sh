#!/usr/bin/bash
# iptables setup on a local pc
# dropping all traffic not going trough vpn
# allowes traffic in local area network
# special rules for UPNP and Multicast discovery
# From: https://airvpn.org/topic/4390-drop-all-traffic-if-vpn-disconnects-with-iptables/


FW="/sbin/iptables"
LCL1="192.168.0.0/24"
LCL2="192.168.2.0/24"
VPN="172.20.24.0/22"
local_interface1="wlp4s0"
local_interface2="enp0s25"
virtual_interface="tun0"

servers=(
37.0.123.60  # RU Moscow c01
81.171.107.3 # FR Paris a02
)

#---------------------------------------------------------------
# Remove old rules and tables
#---------------------------------------------------------------

echo "Deleting old iptables rules..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
ip6tables -F

if [ "$1" = "clear" ]
then
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    chattr -i /etc/resolv.conf
    exit
fi

echo "Setting up new rules..."

# Keep your finger from DNS. I will handel this for you :-P
chattr -i /etc/resolv.conf
echo nameserver 8.8.8.8 > /etc/resolv.conf
echo nameserver 8.8.4.4 >> /etc/resolv.conf
chattr +i /etc/resolv.conf

#---------------------------------------------------------------
# Default Policy - Drop anything!
#---------------------------------------------------------------
$FW -P INPUT DROP
$FW -P FORWARD DROP
$FW -P OUTPUT DROP
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

#---------------------------------------------------------------
# Allow all local connections via loopback.
#---------------------------------------------------------------

$FW -A INPUT  -i lo  -j ACCEPT
$FW -A OUTPUT -o lo  -j ACCEPT


#---------------------------------------------------------------
# Allow Multicast for local network.
#---------------------------------------------------------------

$FW -A INPUT  -j ACCEPT -p igmp --source $LCL1 --destination 224.0.0.0/4 -i $local_interface1
$FW -A OUTPUT -j ACCEPT -p igmp --source $LCL1 --destination 224.0.0.0/4 -o $local_interface1

#---------------------------------------------------------------
# UPnP uses IGMP multicast to find media servers.
# Accept IGMP broadcast packets.
# Send SSDP Packets.
#---------------------------------------------------------------

$FW -A INPUT  -j ACCEPT -p igmp --source $LCL1 --destination 239.0.0.0/8  -i $local_interface1
$FW -A OUTPUT -j ACCEPT -p udp  --source $LCL1 --destination 239.255.255.250 --dport 1900  -o $local_interface1


#---------------------------------------------------------------
# Allow all bidirectional traffic from your firewall to the
# local area network
#---------------------------------------------------------------

$FW -A INPUT  -j ACCEPT -s $LCL1 
$FW -A OUTPUT -j ACCEPT -d $LCL1 
$FW -A INPUT  -j ACCEPT -s $LCL2 
$FW -A OUTPUT -j ACCEPT -d $LCL2 


#---------------------------------------------------------------
# Allow all bidirectional traffic from your firewall to the
# virtual privat network
#---------------------------------------------------------------

$FW -A INPUT  -j ACCEPT -i $virtual_interface
$FW -A OUTPUT -j ACCEPT -o $virtual_interface



#---------------------------------------------------------------
# Connection to AirVPN servers (UDP 443)
#---------------------------------------------------------------

server_count=${#servers[@]}
for (( c = 0; c < $server_count; c++ ))
do
    $FW -A INPUT  -j ACCEPT -p tcp -s ${servers[c]} --sport 443 -i "$local_interface1"
    $FW -A OUTPUT -j ACCEPT -p tcp -d ${servers[c]} --dport 443 -o "$local_interface1"
done

#---------------------------------------------------------------
# Log all dropped packages, debug only.
# View in /var/log/syslog or /var/log/messages
#---------------------------------------------------------------

#iptables -N logging
#iptables -A INPUT -j logging
#iptables -A OUTPUT -j logging
#iptables -A logging -m limit --limit 2/min -j LOG --log-prefix "IPTables general: " --log-level 7
#iptables -A logging -j DROP
