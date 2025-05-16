import random
import time

def generar_logs():
    print("\n" + "="*55)
    print("📝 GENERADOR DE REGISTROS".center(55))
    print("="*55)

    with open("logs.txt", "w", encoding="utf-8") as f:
        ips = ["192.168.1.100", "192.168.1.101", "10.0.0.5", "172.16.0.2"]
        usuarios = ["admin", "root", "user", "guest", "oracle"]

        print("🔐 Intentos FALLIDOS de inicio de sesión...")
        for _ in range(20):
            ip = random.choice(ips)
            user = random.choice(usuarios)
            linea = f"16 May 13:45:0{random.randint(0,9)} servidor sshd[1234]: Fallo de contraseña para el usuario inválido {user} desde {ip} puerto 22 ssh2\n"
            f.write(linea)
            time.sleep(0.01)

        print("🌐 Errores HTTP 404...")
        for _ in range(30):
            ip = random.choice(ips)
            recurso = f"/no_existe{random.randint(1,50)}"
            linea = f'{ip} - - [16/May/2025:13:45:{random.randint(10,59)} +0000] "GET {recurso} HTTP/1.1" 404 498\n'
            f.write(linea)
            time.sleep(0.01)

        print("📄 Accesos NORMALES a recursos...")
        for _ in range(10):
            ip = random.choice(ips)
            linea = f'{ip} - - [16/May/2025:13:46:{random.randint(10,59)} +0000] "GET /index.html HTTP/1.1" 200 1024\n'
            f.write(linea)

    print("\n✅ Registros generados correctamente y guardados como 'logs.txt'\n")

if __name__ == "__main__":
    generar_logs()