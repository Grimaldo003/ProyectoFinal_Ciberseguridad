import subprocess

def mostrar_menu():
    print("\n" + "="*50)
    print("📌 MENÚ GENERAL 📌".center(50))
    print("="*50)
    print("1️⃣  Cifrado César (Modulo 3)")
    print("2️⃣  Escáner de Puertos (Modulo 4)")
    print("3️⃣  Análisador de Logs (Modulo 5)")
    print("4️⃣  Salir")
    print("="*50)

def main():
    while True:
        mostrar_menu()
        opcion = input("🔸 Selecciona una opción (1-4): ").strip()

        if opcion == "1":
            subprocess.run(["python", "Cifrado_Cesar.py"])
        elif opcion == "2":
            subprocess.run(["python", "Escaner_Puertos.py"])
        elif opcion == "3":
            subprocess.run(["python", "Menu_Modulo5.py"])
        elif opcion == "4":
            print("\n👋 Saliendo del menú general... ¡Hasta luego!\n")
            break
        else:
            print("❌ Opción no válida. Por favor, intenta de nuevo.\n")

if __name__ == "__main__":
    main()