#!/bin/bash
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
        dhcp4: no
        addresses: [{{ lan_ip }}/24, ]
        gateway4: {{ gateway }}
        nameservers:
          addresses: [{{ name_server }}]
EOF
sudo netplan apply
reboot
