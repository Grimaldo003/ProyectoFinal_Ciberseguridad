import os
import subprocess
import Analizador_Logs as analyzer

def generar_logs():
    print("\n" + "="*50)
    print("📝 Generando registros falsos con log_generator.py...")
    print("="*50 + "\n")
    subprocess.run(["python", "Generador_Logs.py"])

def analizar_logs():
    print("\n" + "="*50)
    print("🔍 Analizando los registros generados...")
    print("="*50)
    ruta_log = input("📄 Ingresa la ruta del archivo de logs a analizar (añadir .txt): ").strip()
    
    analyzer.ejecutar_analisis(ruta_log)

def mostrar_menu():
    print("\n" + "="*50)
    print("📊 MENÚ - MODULO 5 📊".center(50))
    print("="*50)
    print("1️⃣  Generador de Registros")
    print("2️⃣  Analizador de Registros (Módulo 5)")
    print("3️⃣  Salir")
    print("="*50)

def main():
    while True:
        mostrar_menu()
        opcion = input("🔸 Selecciona una opción (1-3): ").strip()

        if opcion == "1":
            generar_logs()
        elif opcion == "2":
            analizar_logs()
        elif opcion == "3":
            print("\n👋 Saliendo del programa... ¡Hasta luego!\n")
            break
        else:
            print("❌ Opción no válida. Por favor, intenta de nuevo.\n")

if __name__ == "__main__":
    main()