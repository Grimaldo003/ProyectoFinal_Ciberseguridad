#Importar las librerías necesarias
import IPDBAbuse
import ShodanModule

#Número de intentos
Tries = 0

while True:
    #Crear un menú para las funciones de los módulos
    print("Buen día, elija una de las siguientes herramientas:")
    print("1. IP DataBase Abuse")
    print("2. Shodan")
    tool = input()
    if tool == "1":
        IPDBAbuse.check_ip()
    elif tool == "2":
        print("¿Qué deseas hacer?")
        print("1. Buscar Dispositivo")
        print("2. Información de IP")
        print("3. Alertas")
        print("4. Exploits")
        tool2 = input()
        if tool2 == "1":
            ShodanModule.BuscarDispositivo()
        elif tool2 == "2":
            ShodanModule.IPInfo()
        elif tool2 == "3":
            ShodanModule.Alerts()
        elif tool2 == "4":
            ShodanModule.Exploits()
        else:
            print("Opción no válida. Por favor, elige una opción válida.")
            Tries += 1
            if Tries == 3:
                print("Número máximo de intentos alcanzado. Saliendo del programa.")
                exit()
    else:
        print("Opción no válida. Por favor, elige una opción válida.")
        Tries += 1
        if Tries == 3:
            print("Número máximo de intentos alcanzado. Saliendo del programa.")
            exit()
