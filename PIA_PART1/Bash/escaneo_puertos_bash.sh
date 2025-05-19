#!/bin/bash

function escaneo_puertos() {
    read -p "Ingrese la IP a escanear (formato: 0.0.0.0): " TARGET

    # Validar formato IP
    if [[ ! $TARGET =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "\nError: IP inválida. Debe ser en formato 0.0.0.0\n"
        sleep 2
        return
    fi

    # Validar que cada número esté entre 0 y 255
    IFS='.' read -r -a octetos <<< "$TARGET"
    for octeto in "${octetos[@]}"; do
        if (( octeto < 0 || octeto > 255 )); then
            echo -e "\nError: Cada octeto debe ser un número entre 0 y 255.\n"
            sleep 2
            return
        fi
    done

    while true; do
        echo -e "\nEscaneo de Puertos para $TARGET"
        echo "1) Escaneo rápido"
        echo "2) Escaneo completo"
        echo "3) Escaneo de puertos específicos"
        echo "4) Volver"
        read -p "Seleccione una opción: " opcion

        case $opcion in
            1)
                echo -e "\nIniciando escaneo rápido...\n"
                sleep 2
                nmap -F "$TARGET"
                sleep 3
                ;;
            2)
                echo -e "\nIniciando escaneo completo...\n"
                sleep 2
                nmap -p- "$TARGET"
                sleep 3
                ;;
            3)
                read -p "Ingrese los puertos separados por comas (ej: 22,80,443): " puertos
                echo -e "\nIniciando escaneo de puertos específicos...\n"
                sleep 2
                nmap -p "$puertos" "$TARGET"
                sleep 3
                ;;
            4)
                echo "Volviendo al menú anterior..."
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

