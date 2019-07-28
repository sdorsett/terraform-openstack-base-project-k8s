#!/bin/bash

cat << EOF > /etc/netplan/01-ens4-netcfg.yaml
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
 version: 2
 renderer: networkd
 ethernets:
   ens4:
     dhcp4: no
     dhcp6: no
     addresses: [${private_ip}/24]
     nameservers:
       addresses: [8.8.8.8,8.8.4.4]
EOF

netplan apply

apt-get install python -y

