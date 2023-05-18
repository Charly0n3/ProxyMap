#!/bin/bash
#Author --> Charly0n3
#Descripción --> Este script ofrece una serie de opciones con nmap para una mayor versatilidad, además hace una configuración básica de proxychains con dynamic chain y socks5

# Colorines


green="\e[0;32m\033[1m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
end="\033[0m\e[0m"

# function clean

function clean() {
	echo -e "${red}[*]${end} Desinstalando Proxychains.."
	sudo apt remove proxychains4 -y &> /dev/null
	echo -e "${red}[*]${end} Deteniendo el servicio tor.."
	sudo service tor stop &> /dev/null
	clear
}


# Function ctrl_c

function ctrl_c() {

	echo -e "\n\n${red}[!]${end} Saliendo..."
	clean
	exit 0
}

trap ctrl_c INT

# Function Dependencias

function dep() {

	programs=(nmap proxychains4 tor toilet)
	for i in "${programs[@]}"; do
		test -f /usr/bin/$i

		if [ $(echo $?) -eq 0 ]; then
			echo -e "${green}[!]${end} El programa: ${purple}$i${end} Está instalado\n"
		else
			echo -e "${red}[X]${end} El programa: ${purple}$i${end} No está instalado\n"

			ping -c1 www.google.es &> /dev/null
				if [ $(echo $?) -eq 0 ]; then

					echo -e "${red}[!]${end} Procediendo a instalar dependencia: ${green}$i${end}\n"
					sleep 1
					sudo apt install $i -y &> /dev/null
				else

					echo -e "${red}[ERROR]${end} No tienes internet!"
					exit 1
				fi
		fi

	done
	sleep 4
	clear


}

function scan() {

	ip=$(ip a | grep global | awk '{print $2}')
	tor_status=$(sudo service tor status | grep active | awk '{print $2}')

	for i in $(seq 1 45); do echo -n "--"; done
	toilet --font=mono12 --termwidth --metal ProxyMap
	echo -e "By: ${turquesa}Charly0n3${end}"
	for i in $(seq 1 45); do echo -n "--"; done
	echo -e "\n"
	echo -e "${red}[*]${end} Tu IPv4 Privada --> ${turquesa}[$ip]${end}"
	echo -e "${red}[*]${end} Estado de tor --> ${turquesa}$tor_status${end}\n"
	for i in $(seq 1 45); do echo -n "--"; done
	echo
	echo -e "${green}[1]${end} Escaneo de host ${turquesa}[PROXYCHAINS]${end} \n"
	echo -e "${green}[2]${end} Escaneo de servicios activos en un host o una red ${turquesa}[PROXYCHAINS]${end} \n"
	echo -e "${green}[3]${end} Escaneo de vulnerabilidades de un host ${turquesa}[PROXYCHAINS]${end} \n"
	echo -e "${green}[4]${end} Escaneo de host completo y silencioso ${turquesa}[PROXYCHAINS]${end} \n"
	echo -e "${green}[5]${end} Fuzzing web \n"
	echo -e "${green}[6]${end} Salir \n"
	echo -e "${green}[clear]${end} \n"
	echo

	while true; do

	echo -e "ELije una opción: "
	read -p "--> " opt

		case $opt in

		1) #Escaneo de host

		echo -e "${turquesa}[!]${end} ¿Hacia que red quieres realizar el escaneo? ${turquesa}[IP/MASK]${end} ${turquesa}[Ej. 192.168.1.0/24]${end}: "
		read -p "--> " ip
		sudo proxychains nmap -sP $ip 2> /dev/null
		;;

		2)
		echo -e "${turquesa}[!]${end} ¿En qué red o host quieres descubrir servicios?"
		read -p "-->" ip
		sudo proxychains nmap -sV $ip -vvv 2> /dev/null
		;;

		3)
		echo -e "${turquesa}[!]${end} ¿En qué red o host quieres descubrir vulnerabilidades?"
		read -p "--> " ip
		echo -e "${turquesa}[!]${end} ¿En que puerto corre este servicio?"
		read -p "--> " port

		sudo proxychains nmap --script vuln -p $port $ip 2> /dev/null
		;;

		4)
		echo -e "${turquesa}[!]${end} ¿Sobre qué IP quieres hacer el escaneo?"
		read -p "--> " ip
		sudo proxychains nmap -p- --open -sS -sC -sV --min-rate 5000 -vvv -n -Pn $ip 2> /dev/null
		;;

		clear)
		clear
		ip=$(ip a | grep global | awk '{print $2}')
		tor_status=$(sudo service tor status | grep active | awk '{print $2}')
		for i in $(seq 1 45); do echo -n "--"; done
		toilet --font=mono12 --termwidth --metal ProxyMap
		echo -e "By: ${turquesa}Charly0n3${end}"
		for i in $(seq 1 45); do echo -n "--"; done

		echo -e "\n"
		echo -e "${red}[*]${end} Tu IPv4 es --> ${turquesa}$ip${end}"
		echo -e "${red}[*]${end} Estado de tor --> ${turquesa}$tor_status${end}\n"
		for i in $(seq 1 45); do echo -n "--"; done
		echo -e "\n${green}[1]${end} Escaneo de host ${turquesa}[PROXYCHAINS]${end} \n"
		echo -e "${green}[2]${end} Escaneo de servicios activos en un host o una red ${turquesa}[PROXYCHAINS]${end} \n"
		echo -e "${green}[3]${end} Escaneo de vulnerabilidades de un host ${turquesa}[PROXYCHAINS]${end} \n"
		echo -e "${green}[4]${end} Escaneo de host completo y silencioso ${turquesa}[PROXYCHAINS]${end} \n"
		echo -e "${green}[5]${end} Fuzzing web \n"
		echo -e "${green}[6]${end} Salir \n"
		echo -e "${green}[clear]${end}\n"
		echo
		;;
		5)
		echo -e "${turquesa}[!]${end} ¿En qué ip quieres descubrir posibles directorios?"
		read -p "--> " ip
		echo -e "${turquesa}[!]${end} ¿Sobre que puerto? [80,443]"
		read -p "--> " port
		sudo nmap --script http-enum -p $port $ip -vvv 2> /dev/null
		;;

		6)
			echo -e "${red}[!]${end} Saliendo.."
			clean
			exit 0
		;;

		esac


	done

}


function proxychains() {

	service tor restart &> /dev/null
	sed -i 's/strict_chain/#strict_chain/g' /etc/proxychains4.conf
	sed -i 's/#dynamic_chain/dynamic_chain/g' /etc/proxychains4.conf
	sed -i 's/socks4/socks5/g' /etc/proxychains4.conf
}


# Main Conditional

if [ $(id -u) -eq 0 ]; then
clear
dep
proxychains
scan

else

	echo -e "\n\n ${red}[!]${end} Debes ejecutar el script como root"

fi



