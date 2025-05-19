#!/usr/bin/env python3

# Standard library imports
import logging
import time
from datetime import datetime
import sys

# Configure logging with a file handler and console handler
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('menu.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

def display_main_menu():
    """
    Muestra el menú principal con las opciones disponibles.
    
    Documentación:
    - Imprime un encabezado con la fecha y hora actual.
    - Muestra las seis opciones del menú (cinco tareas + salir).
    - Utiliza formato centrado y separadores para mejorar la legibilidad.
    """
    print("\n" + "=" * 50)
    print(f"🔒 CYBERSECURITY TOOLS MENU - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} 🔒".center(50))
    print("=" * 50)
    print("1️⃣  Shodan Search")
    print("2️⃣  IPDBAbuse Check")
    print("3️⃣  Port Scanner")
    print("4️⃣  Caesar Cipher")
    print("5️⃣  Log Generator & Analyzer (Module 5)")
    print("6️⃣  Exit")
    print("=" * 50 + "\n")

def display_shodan_submenu():
    """
    Muestra el submenú para las funciones de Shodan.
    
    Documentación:
    - Muestra las cuatro funciones disponibles en ShodanModule.py más la opción de salir.
    - Utiliza formato similar al menú principal para consistencia.
    """
    print("\n" + "=" * 50)
    print("🔍 SHODAN SUBMENU 🔍".center(50))
    print("=" * 50)
    print("1️⃣  Search Devices (BuscarDispositivo)")
    print("2️⃣  IP Information (IPInfo)")
    print("3️⃣  Alerts")
    print("4️⃣  Exploits")
    print("5️⃣  Exit")
    print("=" * 50 + "\n")

def validate_option(option: str, max_option: int) -> bool:
    """
    Valida la entrada del usuario para la selección de opciones.
    
    Args:
        option (str): La opción ingresada por el usuario.
        max_option (int): El número máximo de opciones permitidas (6 para menú principal, 5 para Shodan).
    
    Returns:
        bool: True si la opción es válida, False en caso contrario.
    
    Documentación:
    - Verifica que la entrada no esté vacía, no contenga solo espacios en blanco,
      sea un número y esté en el rango de 1 a max_option.
    - Registra errores en el log si la entrada es inválida.
    """
    if not option:
        logger.error("Empty input detected.")
        return False
    if option.isspace():
        logger.error("Input contains only whitespace.")
        return False
    if not option.isdigit():
        logger.error(f"Invalid input: '{option}' is not a number.")
        return False
    option_num = int(option)
    if option_num < 1 or option_num > max_option:
        logger.error(f"Option {option_num} is out of range (1-{max_option}).")
        return False
    return True

def ask_to_continue() -> bool:
    """
    Pregunta al usuario si desea continuar o salir del programa.
    
    Returns:
        bool: True si el usuario desea continuar, False si desea salir.
    
    Documentación:
    - Solicita una entrada 'y' o 'n' (insensible a mayúsculas/minúsculas).
    - Valida que la entrada sea válida; permite hasta 3 intentos.
    - Registra la decisión del usuario en el log.
    """
    max_attempts = 3
    attempts = 0

    while attempts < max_attempts:
        choice = input("\n🔄 Do you want to continue? (y/n): ").strip().lower()
        if choice in ['y', 'n']:
            logger.info(f"User chose to {'continue' if choice == 'y' else 'exit'}.")
            return choice == 'y'
        else:
            attempts += 1
            logger.error(f"Invalid choice: '{choice}'. Attempt {attempts} of {max_attempts}.")
            print(f"❌ Please enter 'y' or 'n'. {max_attempts - attempts} attempts left.")
    
    logger.critical("Max attempts reached for continue prompt. Exiting.")
    print("🚫 Too many invalid attempts. Exiting program.")
    return False

def run_shodan():
    """
    Ejecuta la funcionalidad de Shodan, mostrando un submenú para elegir una función.
    
    Documentación:
    - Importa ShodanModule.py y permite al usuario seleccionar una de las cuatro funciones
      (BuscarDispositivo, IPInfo, Alerts, Exploits) o salir.
    - Valida la entrada del submenú con un máximo de 3 intentos.
    - Registra el inicio y fin del proceso con pausas de 1 segundo.
    """
    logger.info("Starting Shodan task.")
    print("\n⏳ Starting Shodan task...")
    time.sleep(1)
    
    max_attempts = 3
    attempts = 0
    
    while attempts < max_attempts:
        display_shodan_submenu()
        sub_option = input("🔸 Select a Shodan function (1-5): ").strip()
        
        if not validate_option(sub_option, 5):
            attempts += 1
            logger.error(f"Invalid Shodan submenu option: '{sub_option}'. Attempt {attempts} of {max_attempts}.")
            print(f"❌ Invalid option. Attempt {attempts} of {max_attempts}.")
            if attempts >= max_attempts:
                logger.critical("Max attempts reached in Shodan submenu. Returning to main menu.")
                print("🚫 Too many invalid attempts. Returning to main menu.")
                return
            continue
        
        sub_option_num = int(sub_option)
        if sub_option_num == 5:
            logger.info("User chose to exit Shodan submenu.")
            print("🔙 Returning to main menu...")
            time.sleep(1)
            return
        
        try:
            import ShodanModule
            if sub_option_num == 1:
                logger.info("Executing Shodan BuscarDispositivo.")
                ShodanModule.BuscarDispositivo()
            elif sub_option_num == 2:
                logger.info("Executing Shodan IPInfo.")
                ShodanModule.IPInfo()
            elif sub_option_num == 3:
                logger.info("Executing Shodan Alerts.")
                ShodanModule.Alerts()
            elif sub_option_num == 4:
                logger.info("Executing Shodan Exploits.")
                ShodanModule.Exploits()
            logger.info("Shodan task completed successfully.")
            print("✅ Shodan function executed successfully.")
        except Exception as e:
            logger.error(f"Error in Shodan task: {e}")
            print(f"❌ Error: {e}")
        
        time.sleep(1)
        return  # Exit after executing one function
    
    logger.info("Shodan task finished.")
    print("✅ Shodan task finished.")
    time.sleep(1)

def run_ipdbabuse():
    """
    Ejecuta la funcionalidad de IPDBAbuse.
    
    Documentación:
    - Importa IPDBAbuse.py y ejecuta la función check_ip().
    - Registra el inicio y fin del proceso con pausas de 1 segundo.
    """
    logger.info("Starting IPDBAbuse task.")
    print("\n⏳ Starting IPDBAbuse task...")
    time.sleep(1)
    try:
        import IPDBAbuse
        IPDBAbuse.check_ip()
        logger.info("IPDBAbuse task completed successfully.")
        print("✅ IPDBAbuse task finished.")
    except Exception as e:
        logger.error(f"Error in IPDBAbuse task: {e}")
        print(f"❌ Error: {e}")
    time.sleep(1)

def run_port_scanner():
    """
    Ejecuta la funcionalidad de Escaneo de Puertos.
    
    Documentación:
    - Importa Escaner_Puertos.py y ejecuta la función run().
    - Registra el inicio y fin del proceso con pausas de 1 segundo.
    """
    logger.info("Starting Port Scanner task.")
    print("\n⏳ Starting Port Scanner task...")
    time.sleep(1)
    try:
        import Escaner_Puertos
        Escaner_Puertos.run()
        logger.info("Port Scanner task completed successfully.")
        print("✅ Port Scanner task finished.")
    except Exception as e:
        logger.error(f"Error in Port Scanner task: {e}")
        print(f"❌ Error: {e}")
    time.sleep(1)

def run_caesar_cipher():
    """
    Ejecuta la funcionalidad de Cifrado César.
    
    Documentación:
    - Importa Cifrado_Cesar.py y ejecuta la función main().
    - Registra el inicio y fin del proceso con pausas de 1 segundo.
    """
    logger.info("Starting Caesar Cipher task.")
    print("\n⏳ Starting Caesar Cipher task...")
    time.sleep(1)
    try:
        import Cifrado_Cesar
        Cifrado_Cesar.main()
        logger.info("Caesar Cipher task completed successfully.")
        print("✅ Caesar Cipher task finished.")
    except Exception as e:
        logger.error(f"Error in Caesar Cipher task: {e}")
        print(f"❌ Error: {e}")
    time.sleep(1)

def run_module_5():
    """
    Ejecuta la funcionalidad de Generador y Analizador de Logs (Module 5).
    
    Documentación:
    - Importa Menu_Modulo_cinco.py y ejecuta la función main().
    - Registra el inicio y fin del proceso con pausas de 1 segundo.
    """
    logger.info("Starting Module 5 (Log Generator & Analyzer) task.")
    print("\n⏳ Starting Module 5 task...")
    time.sleep(1)
    try:
        import Menu_Modulo_cinco
        Menu_Modulo_cinco.main()
        logger.info("Module 5 task completed successfully.")
        print("✅ Module 5 task finished.")
    except Exception as e:
        logger.error(f"Error in Module 5 task: {e}")
        print(f"❌ Error: {e}")
    time.sleep(1)

def main():
    """
    Función principal que controla el flujo del programa.
    
    Documentación:
    - Inicializa el programa con un mensaje de bienvenida y la fecha actual.
    - Muestra el menú principal y solicita una opción al usuario.
    - Valida la entrada con un máximo de 3 intentos.
    - Ejecuta la tarea correspondiente según la opción seleccionada.
    - Para Shodan, muestra un submenú para elegir una función.
    - Pregunta si el usuario desea continuar después de cada tarea.
    - Registra todos los eventos en el log.
    """
    logger.info("Program started.")
    print("\n" + "=" * 50)
    print(f"🚀 Cybersecurity Tools Menu Started - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} 🚀".center(50))
    print("=" * 50 + "\n")
    time.sleep(1)

    max_attempts = 3
    attempts = 0

    while True:
        display_main_menu()
        option = input("🔸 Select an option (1-6): ").strip()

        if not validate_option(option, 6):
            attempts += 1
            print(f"❌ Invalid option. Attempt {attempts} of {max_attempts}. Please select a number between 1 and 6.")
            logger.error(f"Invalid main menu option: '{option}'. Attempt {attempts} of {max_attempts}.")
            if attempts >= max_attempts:
                logger.critical("Maximum attempts reached in main menu. Exiting program.")
                print("🚫 Too many invalid attempts. Exiting program.")
                sys.exit(1)
            continue

        attempts = 0  # Reset attempts on valid input
        option_num = int(option)

        if option_num == 6:
            logger.info("User selected exit.")
            print("\n👋 Exiting program... Goodbye!\n")
            time.sleep(1)
            sys.exit(0)

        # Execute the selected task
        if option_num == 1:
            run_shodan()
        elif option_num == 2:
            run_ipdbabuse()
        elif option_num == 3:
            run_port_scanner()
        elif option_num == 4:
            run_caesar_cipher()
        elif option_num == 5:
            run_module_5()

        # Ask if the user wants to continue
        if not ask_to_continue():
            logger.info("User chose to exit after task.")
            print("\n👋 Exiting program... Goodbye!\n")
            time.sleep(1)
            sys.exit(0)

if __name__ == "__main__":
    main()