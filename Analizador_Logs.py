import re
import logging
from collections import defaultdict

# Configuración del log
logging.basicConfig(
    filename='analizador_logs.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def detectar_fuerza_bruta(lineas_log):
    """Detecta intentos de fuerza bruta por múltiples fallos de login desde la misma IP."""
    fallos_por_ip = defaultdict(int)
    ips_sospechosas = []

    for linea in lineas_log:
        match = re.search(r'Fallo de contraseña.*desde (\d+\.\d+\.\d+\.\d+)', linea)
        if match:
            ip = match.group(1)
            fallos_por_ip[ip] += 1
            if fallos_por_ip[ip] > 5 and ip not in ips_sospechosas:
                ips_sospechosas.append(ip)

    return ips_sospechosas

def detectar_errores_404(lineas_log):
    """Detecta IPs que generan muchos errores 404 (posible escaneo de directorios)."""
    errores_404_por_ip = defaultdict(int)
    ips_escaneo = []

    for linea in lineas_log:
        match = re.search(r'(\d+\.\d+\.\d+\.\d+).+"GET .+HTTP.*" 404', linea)
        if match:
            ip = match.group(1)
            errores_404_por_ip[ip] += 1
            if errores_404_por_ip[ip] > 10 and ip not in ips_escaneo:
                ips_escaneo.append(ip)

    return ips_escaneo

def ejecutar_analisis(ruta_log=None):
    try:
        print("\n" + "="*60)
        print("🛡️  ANALIZADOR DE REGISTROS DE SEGURIDAD  🛡️".center(60))
        print("="*60)

        if not ruta_log:
            ruta_log = input("📂 Ingresa la ruta del archivo de registros a analizar: ").strip()

        with open(ruta_log, 'r', encoding='utf-8', errors='ignore') as archivo:
            lineas = archivo.readlines()

        print(f"\n🔍 Analizando archivo con {len(lineas)} líneas...\n")
        logging.info(f"Archivo cargado: {ruta_log} con {len(lineas)} líneas.")

        fuerza_bruta = detectar_fuerza_bruta(lineas)
        escaneos = detectar_errores_404(lineas)

        print("📌 RESULTADOS DEL ANÁLISIS\n")

        if fuerza_bruta:
            print("🚨 INTENTOS DE FUERZA BRUTA DETECTADOS:")
            for ip in sorted(fuerza_bruta):
                print(f"   ➤ {ip} — múltiples intentos fallidos de inicio de sesión")
                logging.warning(f"IP sospechosa por fuerza bruta: {ip}")
        else:
            print("✅ No se detectaron intentos de fuerza bruta.")

        print()

        if escaneos:
            print("🕵️ POSIBLES ESCANEOS DE DIRECTORIOS DETECTADOS:")
            for ip in sorted(escaneos):
                print(f"   ➤ {ip} — múltiples errores 404")
                logging.warning(f"IP sospechosa por escaneo: {ip}")
        else:
            print("✅ No se detectaron escaneos de directorios.")

        print("\n✔️ Análisis finalizado.\n")

    except FileNotFoundError:
        print("❌ Archivo no encontrado. Verifica la ruta e intenta nuevamente.")
        logging.error("Archivo de log no encontrado.")
    except Exception as e:
        print("⚠️ Ocurrió un error durante el análisis.")
        logging.exception("Error inesperado en el análisis.")

def analizar_logs(ruta_archivo):
    """Función auxiliar para análisis desde otro módulo."""
    try:
        with open(ruta_archivo, 'r', encoding='utf-8') as f:
            lineas = f.readlines()

        print(f"\n📥 Cargadas {len(lineas)} líneas del archivo: {ruta_archivo}")

        for linea in lineas:
            if "Fallo de contraseña" in linea:
                print(f"🔐 Fallo de inicio de sesión: {linea.strip()}")
            elif '404' in linea:
                print(f"❗ Error 404 detectado: {linea.strip()}")

    except FileNotFoundError:
        print(f"❌ El archivo '{ruta_archivo}' no fue encontrado.")

# Ejecutar como script principal
if __name__ == "__main__":
    ejecutar_analisis()