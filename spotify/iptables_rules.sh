#!/usr/bin/env bash


iptables -A OUTPUT -m owner --gid-owner 1003 -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -m owner --gid-owner 1003 -p tcp  --dport 4070 -j ACCEPT
iptables -A OUTPUT -m owner --gid-owner 1003 -j DROP


sg blockify -c spotify 
