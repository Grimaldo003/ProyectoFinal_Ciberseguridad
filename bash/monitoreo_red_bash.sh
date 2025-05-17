#!/bin/bash

function monitoreo_red() {
    read -p "Ingrese la interfaz de red a monitorear (ej: eth0, wlan0): " INTERFAZ

    if [[ -z "$INTERFAZ" ]]; then
        echo -e "\nError: Debe ingresar una interfaz válida.\n"
        sleep 2
        return
    fi

    while true; do
        echo -e "\nMonitoreo de Red en $INTERFAZ"
        echo "1) Ver tráfico en tiempo real"
        echo "2) Ver conexiones activas"
        echo "3) Capturar paquetes a archivo"
        echo "4) Volver"
        read -p "Seleccione una opción: " opcion

        case $opcion in
            1)
                echo -e "\nMostrando tráfico en tiempo real en la interfaz $INTERFAZ...\n"
                sleep 2
                sudo tcpdump -i "$INTERFAZ"
                sleep 3
                ;;
            2)
                echo -e "\nMostrando conexiones activas...\n"
                sleep 2
                netstat -tunapl
                sleep 3
                ;;
            3)
                read -p "Ingrese nombre de archivo para guardar la captura (ej: captura.pcap): " archivo
                echo -e "\nIniciando captura de paquetes...\n"
                sleep 2
                sudo tcpdump -i "$INTERFAZ" -w "$archivo"
                echo -e "\nCaptura finalizada y guardada como $archivo.\n"
                sleep 3
                ;;
            4)
                echo -e "\nVolviendo al menú anterior...\n"
                sleep 2
                return
                ;;
            *)
                echo -e "\nOpción inválida. Intente de nuevo.\n"
                sleep 2
                ;;
        esac
    done
}

