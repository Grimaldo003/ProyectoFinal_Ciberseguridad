import socket

def escanear_puertos():
    host = input("Ingresa la IP o dominio a escanear: ").strip()
    puertos = [21, 22, 23, 25, 53, 80, 110, 139, 443, 445, 3389]

    print(f"\nEscaneando {host} en puertos comunes...\n")

    for puerto in puertos:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(0.5)
        resultado = sock.connect_ex((host, puerto))
        if resultado == 0:
            print(f"Puerto {puerto} [ABIERTO]")
        sock.close()

    print("\nEscaneo finalizado.")
