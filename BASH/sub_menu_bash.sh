#!/bin/bash

source ./T5_reto1.sh
source ./trabajo_rodolfo_equipo4.sh

Fecha=$(date)

echo -e "\nHola $LOGNAME\n"
echo -e "Submenú				Fecha: $Fecha\n\n"

function submenu() {
    local intentos=0
    local max_intentos=3

    while true; do
        echo -e "\nESCANEO DE PUERTOS(1)\nMONITOREO DE RED(2)"
        echo -e "CERRAR PROGRAMA(3)\n"
        read -p "Ingrese la opción deseada: " opc
        sleep 2
        echo -e "\n°°°la opción elegida es: $opc °°°\n"

        # Validación: Verificar si $opc es un número entero y si es 1, 2 o 3
        if [[ ! $opc =~ ^[0-9]+$ ]]; then
            ((intentos++))
            echo -e "\nError: Por favor ingrese un número entero válido (1, 2 o 3)."
            echo -e "Intento $intentos de $max_intentos.\n"
            sleep 2
            echo -e "No se permiten caracteres, espacios vacíos, flotantes ni otros valores.\n"
            echo -e "Intente de nuevo\n~~~~~~~~~~~\n"
            sleep 3

            # Verificar si se excedieron los intentos
            if [[ $intentos -ge $max_intentos ]]; then
                echo -e "\nHas excedido el número máximo de intentos ($max_intentos).\n"
                echo -e "El programa se cerrará.\n"
                sleep 2
                echo -e "Adiós $LOGNAME\n"
                sleep 2
                exit 0
            fi
            continue
        elif [[ $opc != 1 && $opc != 2 && $opc != 3 ]]; then
            ((intentos++))
            echo -e "\nError: Solo se permiten los valores 1, 2 y 3."
            echo -e "Intento $intentos de $max_intentos.\n"
            sleep 3
            echo -e "Intente de nuevo\n~~~~~~~~~~~\n"

            # Verificar si se excedieron los intentos
            if [[ $intentos -ge $max_intentos ]]; then
                echo -e "\nHas excedido el número máximo de intentos ($max_intentos).\n"
                echo -e "El programa se cerrará.\n"
                sleep 2
                echo -e "Adiós $LOGNAME\n"
                sleep 2
                exit 0
            fi
            continue
        else
            # Reiniciar intentos si la entrada es válida
            intentos=0
            break
        fi
    done

    if [[ $opc -eq 1 ]]; then
        echo -e "\nSe activó el programa para la opción 1\n.................................\n"
        sleep 2
        escaneo_puertos
        sleep 4
        repetir
    elif [[ $opc -eq 2 ]]; then
        echo -e "Se activó el programa para la opción 2\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
        sleep 2
        monitoreo_red
        sleep 4
        repetir
    elif [[ $opc -eq 3 ]]; then
        echo -e "\tSe cerrará el programa\n"
        sleep 1
        echo -e "Adiós $LOGNAME"
        sleep 2
        exit 0
    fi
}

function repetir() {
    # Bucle para validar la opción de salir
    while true; do
        echo -e "\n------------------------------------- \n"
        read -p "¿Desea salir del programa? (s/n): " salir
        if [[ $salir == "s" || $salir == "S" ]]; then
            echo -e "\nSaliendo del programa..."
            sleep 6
            echo -e "\nAdiós $LOGNAME\n"
            sleep 5
            exit 0
        elif [[ $salir == "n" || $salir == "N" ]]; then
            echo -e "\n>**************\n"
            submenu
            break
        else
            echo -e "Opción no válida. Por favor ingrese 's' para salir o 'n' para continuar.\n"
        fi
    done
}

submenu
