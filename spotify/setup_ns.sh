#!/usr/bin/env bash

ns=blue
vetha=vetha
vethb=vethb
br=br0
subnetmask=24

ip_vetha="10.0.1.3/$subnetmask"
ip_vethb="10.0.1.2/$subnetmask"
ip_br="192.168.2.200/$subnetmask"

ip netns delete $ns
ip link set dev $br down
brctl delbr $br

# new network namespace
ip netns add $ns

# add link to the network namespace
ip link add $vetha type veth peer name $vethb
ip link set $vethb netns $ns

# setup veth
ip addr add $ip_vetha dev $vetha
ip link set dev $vetha up

ip netns exec $ns ip link set dev lo up
ip netns exec $ns ip addr add $ip_vethb dev $vethb
ip netns exec $ns ip link set dev $vethb up 

# setup bridge
brctl addbr $br
ip addr add $ip_br dev $br
ip link set dev $br up
brctl addif $br $vetha



