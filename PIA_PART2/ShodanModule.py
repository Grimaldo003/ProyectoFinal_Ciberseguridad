#Importar Shodan
from shodan import Shodan 

#Función para buscar dispositivos
def BuscarDispositivo():
    #Usar la clave API de Shodan
    api_key = input("Introduce tu clave API de Shodan: ")
    #Inicio de la API
    api = Shodan(api_key)
    #Realizar la búsqueda
    busquedas = api.search('apache')
    for busquedas in busquedas['matches']:
        #Imprime la IP y el puerto
        print(f"IP: {busquedas['ip_str']}\nPuerto: {busquedas['port']}")

def IPInfo():
    #Usar la clave API de Shodan
    api_key = input("Introduce tu clave API de Shodan: ")
    #Inicio de la API
    api = Shodan(api_key)
    IP = api.host(input("Introduce la IP a comprobar: "))
    #Imprime información de la IP
    print(f"IP: {IP['ip_str']}")
    print(f"Organización: {IP.get('org', 'n/a')}")
    print(f"Sistema Operativo: {IP.get('os', 'n/a')}")

def Alerts():
    #Usar la clave API de Shodan
    api_key = input("Introduce tu clave API de Shodan: ")
    #Inicio de la API
    api = Shodan(api_key)
    #Crear una alerta
    alertas = api.alerts()
    for alerta in alertas:
        #Imprime la alerta
        print(f"ID: {alerta['id']}")
        print(f"Nombre: {alerta['name']}")
        print(f"Descripción: {alerta['description']}")
        print(f"Fecha de creación: {alerta['created_at']}")
        print(f"Fecha de actualización: {alerta['updated_at']}")
        print(f"Estado: {alerta['status']}")

def Exploits():
    #Usar la clave API de Shodan
    api_key = input("Introduce tu clave API de Shodan: ")
    #Inicio de la API
    api = Shodan(api_key)
    #Buscar exploits
    exploits = api.exploits()
    for exploit in exploits:
        #Imprime el exploit
        print(f"ID: {exploit['id']}")
        print(f"Descripción: {exploit['description']}")
      