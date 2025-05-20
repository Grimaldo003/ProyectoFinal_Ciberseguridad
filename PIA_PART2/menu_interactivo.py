#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import platform
import hashlib
import datetime
import csv
import sys

from Generador_Logs import generar_logs
from Analizador_Logs import analizar_logs
from IPDBAbuse import check_ip
from ShodanModule import (
    BuscarDispositivo,
    IPInfo,
    Alerts,
    Exploits
)
from Escaner_Puertos import escanear_puertos
from Cifrado_Cesar import cifrar_cesar

LOGFILE = "logs.txt"

def pausar():
    input("\nPresiona ENTER para continuar...")

def generar_hash(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()

def guardar_reporte_csv(data, filename="reporte.csv"):
    with open(filename, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["Resultado"])
        for row in data:
            writer.writerow([row])
    return filename

def mostrar_info_reporte(path):
    print(f"\nUbicación: {os.path.abspath(path)}")
    print(f"Hash SHA256: {generar_hash(path)}")
    print(f"Fecha: {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

def ejecutar_script_bash(nombre_script):
    ruta = os.path.join(os.getcwd(), nombre_script)
    if os.path.isfile(ruta):
        subprocess.call(["bash", ruta])
    else:
        print(f"[!] El script {nombre_script} no se encontró.")

def menu_logs():
    while True:
        os.system("clear" if os.name == "posix" else "cls")
        print("─ LOGS ─")
        print("1) Generar logs de prueba")
        print("2) Analizar logs")
        print("0) Volver")
        opcion = input("> ").strip()
        if opcion == "1":
            generar_logs()
            pausar()
        elif opcion == "2":
            if not os.path.exists(LOGFILE):
                print("[!] No existe logs.txt")
            else:
                resultados = analizar_logs(LOGFILE)
                reporte = guardar_reporte_csv(resultados)
                mostrar_info_reporte(reporte)
            pausar()
        elif opcion == "0":
            break

def menu_red():
    while True:
        os.system("clear" if os.name == "posix" else "cls")
        print("─ HERRAMIENTAS DE RED ─")
        print("1) Escáner de puertos (Python)")
        print("2) Escáner de puertos (Bash)")
        print("3) Monitoreo de red (Bash)")
        print("4) Consulta AbuseIPDB")
        print("5) Shodan")
        print("0) Volver")
        opcion = input("> ").strip()

        if opcion == "1":
            escanear_puertos()
            pausar()
        elif opcion == "2":
            ejecutar_script_bash("escaneo_puertos_bash.sh")
            pausar()
        elif opcion == "3":
            ejecutar_script_bash("monitoreo_red_bash.sh")
            pausar()
        elif opcion == "4":
            check_ip()
            pausar()
        elif opcion == "5":
            menu_shodan()
        elif opcion == "0":
            break

def menu_shodan():
    while True:
        os.system("clear" if os.name == "posix" else "cls")
        print("─ SHODAN ─")
        print("1) Buscar dispositivos")
        print("2) Información de una IP")
        print("3) Ver alertas")
        print("4) Buscar exploits")
        print("0) Volver")
        op = input("> ").strip()
        if op == "1":
            BuscarDispositivo()
            pausar()
        elif op == "2":
            IPInfo()
            pausar()
        elif op == "3":
            Alerts()
            pausar()
        elif op == "4":
            Exploits()
            pausar()
        elif op == "0":
            break

def menu_utilidades():
    while True:
        os.system("clear" if os.name == "posix" else "cls")
        print("─ UTILIDADES ─")
        print("1) Cifrado César")
        print("2) Ver sistema operativo")
        print("0) Volver")
        opcion = input("> ").strip()
        if opcion == "1":
            texto = input("Texto: ")
            while True:
                try:
                    clave = int(input("Clave (número): "))
                    break
                except ValueError:
                    print("Debe ser un número.")
            print("Cifrado:", cifrar_cesar(texto, clave))
            pausar()
        elif opcion == "2":
            print("Sistema:", platform.system())
            pausar()
        elif opcion == "0":
            break

def menu_principal():
    while True:
        os.system("clear" if os.name == "posix" else "cls")
        print("=" * 40)
        print("  HERRAMIENTA DE CIBERSEGURIDAD")
        print("=" * 40)
        print("1) Logs")
        print("2) Herramientas de red")
        print("3) Utilidades")
        print("0) Salir")
        opcion = input("> ").strip()
        if opcion == "1":
            menu_logs()
        elif opcion == "2":
            menu_red()
        elif opcion == "3":
            menu_utilidades()
        elif opcion == "0":
            print("Saliendo...")
            sys.exit(0)
        else:
            print("Opción inválida.")
            pausar()

if __name__ == "__main__":
    menu_principal()
