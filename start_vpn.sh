#!/bin/bash
# Arg 1 = openvpn config file

if [ -a "openvpn.pid" ]
then
    echo "[!] openvpn seems to run already."
    kill $(cat openvpn.pid)
    rm openvpn.pid
fi

echo "[+] Invoke firewall clear script"
/home/user/bin/hacks/vpn_firewall.sh clear

vpn_dns_name="$(cat "$1" | awk '/^remote/ {print $2;}')"
vpn_ip="$(dig  "$vpn_dns_name" +short)"
echo "[+] IP-Address VPN server is $vpn_ip"


echo "[+] Invoke openvpn with $1"
openvpn  --config "$1" --auth-user-pass login.conf --writepid openvpn.pid > /dev/zero&
sleep 20

ip_tun="$(ip addr show dev tun0 | awk '/inet/ {print $2}' | sed 's/\/..//')"
echo "[+] IP-Address tun0 is $ip_tun"

echo "[+] Invoke firewall script. Allow only $vpn_ip"
/home/user/bin/hacks/vpn_firewall.sh "$vpn_ip" 

old_gw="$(route -n | awk '/^0\.0\.0\.0/ {print $2;}')"
echo "[+] Delete old default gw $old_gw"
route del default gw "$old_gw"

echo "[+] Create new default gw $ip_tun"
route add default gw "$ip_tun"
