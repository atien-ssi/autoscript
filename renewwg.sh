#!/bin/bash
source /etc/wireguard/params
	NUMBER_OF_CLIENTS=$(grep -c -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo "No tienes clientes existentes!"
		exit 1
	fi

	clear
	echo ""
	echo "Seleccione el cliente existente que desea renovar"
	echo " Presione CTRL + C para regresar"
	echo -e "==============================="
	echo "     Ningún usuario caducado"
	grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (days): " masaaktif
user=$(grep -E "^### Client" "/etc/wireguard/wg0.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### Client" "/etc/wireguard/wg0.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### Client $user $exp/### Client $user $exp4/g" /etc/wireguard/wg0.conf
clear
echo ""
echo " Cuenta Wireguard renovado con éxito"
echo " =========================="
echo " Client Name : $user"
echo " Expired  On: $exp4"
echo " =========================="
echo " By Karlos Geek"
