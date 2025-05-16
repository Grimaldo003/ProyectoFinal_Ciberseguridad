import socket
import logging
import sys

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

common_ports = {
    21: "FTP",
    22: "SSH",
    23: "Telnet",
    25: "SMTP",
    53: "DNS",
    80: "HTTP",
    110: "POP3",
    143: "IMAP",
    443: "HTTPS",
    3306: "MySQL",
    3389: "RDP",
    8080: "HTTP alternativo"
}

def escanear_puertos(ip_objetivo):
    print("\n" + "="*50)
    print(f"🔍 Escaneando puertos en: {ip_objetivo}".center(50))
    print("="*50 + "\n")
    
    for puerto, servicio in common_ports.items():
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)
            resultado = sock.connect_ex((ip_objetivo, puerto))
            if resultado == 0:
                print(f"✅ Puerto {puerto:<5} ({servicio}) está ABIERTO")
            else:
                print(f"❌ Puerto {puerto:<5} ({servicio}) está cerrado o filtrado")
            sock.close()
        except Exception as e:
            logging.error(f"Error al escanear el puerto {puerto}: {e}")
    print("\n" + "="*50 + "\n")

def validar_ip(ip):
    try:
        socket.gethostbyname(ip)
        return True
    except socket.error:
        return False

def run():
    max_intentos = 3
    intentos = 0
    print("="*50)
    print("🛡️  ESCÁNER DE PUERTOS  🛡️".center(50))
    print("="*50 + "\n")

    while intentos < max_intentos:
        ip = input("🔹 Ingresa la dirección IP o nombre de host a escanear: ").strip()
        if not ip:
            intentos += 1
            print(f"❌ La dirección no puede estar vacía. Intento {intentos} de {max_intentos}.\n")
            continue
        if not validar_ip(ip):
            intentos += 1
            print(f"❌ Dirección IP o host no válido. Intento {intentos} de {max_intentos}.\n")
            continue
        
        escanear_puertos(ip)
        return

    print(f"🚫 Demasiados intentos fallidos. El programa se cerrará.")
    print("="*50)
    sys.exit()

if __name__ == "__main__":
    run()