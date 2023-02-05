#!/bin/bash 

source redconfig.txt


echo -e "Configurador de red automático\n"

echo "Las interfaces detectadas son las siguientes"
ip a | grep "^[0-9]:" | awk -F: '{ print $2 }'

read -p "Escriba una interfaz de red " interfaz


echo -e "\nLos datos introducidos son los siguientes:"
echo " - Interfaz: $interfaz"
echo " - Dirección de red: $red"
echo " - Puerta de enlace: $puerta"
echo " - Máscara: $netmask"
echo " - Servdores DNS: $dns"
echo



echo "Hacemos copia de seguirdad (el fichero será interfaces2)"
cp /etc/network/interfaces /etc/network/interfaces2

ficheroInterfaces="/etc/network/interfaces"

interfichero=$(ip a | grep $interfaz | awk -F: '{ print $2 }')

# Comprobamos si la interfaz introducida ya existe en el fichero, para no duplicarla

if ! [[ "$interfichero" =~ $interfaz ]]; then
    echo "auto $interfaz" >> $ficheroInterfaces
    echo "iface $interfaz inet static" >> $ficheroInterfaces
    echo "address $red" >> $ficheroInterfaces
    echo "gateway $puerta" >> $ficheroInterfaces
    echo "dns-nameservers $dns" >> $ficheroInterfaces
else
    sed -i 's/dhcp/static/g' $ficheroInterfaces
    echo -e "\t address $red" >> $ficheroInterfaces
    echo -e "\t gateway $puerta" >> $ficheroInterfaces
    echo -e "\t dns-nameservers $dns" >> $ficheroInterfaces
fi

echo "Configuración acabada"

#init 6

/etc/init.d/networking restart

	echo "se ha reiniciado la tarjeta de red"


