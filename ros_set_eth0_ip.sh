#!/bin/sh
IP="$1"
if [[ "$IP" -gt 0 && "IP" -lt 255 ]] 2>/dev/null; then
	echo "Set eth0 address to 10.0.1.$IP ..."
	sudo ros c set rancher.network.interfaces.eth0.dhcp false
	sudo ros c set rancher.network.interfaces.eth0.address 10.0.1.$IP/24
else
	echo "Enabling eth0 DHCP ..."
	sudo ros c set rancher.network.interfaces.eth0.dhcp true
	sudo ros c set rancher.network.interfaces.eth0.address ""
fi
sudo ros c get rancher.network.interfaces
