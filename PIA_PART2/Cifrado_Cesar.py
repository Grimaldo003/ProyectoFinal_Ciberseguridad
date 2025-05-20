def cifrar_cesar(texto, desplazamiento):
    resultado = ""
    for letra in texto:
        if letra.isupper():
            resultado += chr((ord(letra) + desplazamiento - 65) % 26 + 65)
        elif letra.islower():
            resultado += chr((ord(letra) + desplazamiento - 97) % 26 + 97)
        else:
            resultado += letra
    return resultado

def cifrar_archivo(input_file, output_file, desplazamiento=3):
    with open(input_file, 'r', encoding='utf-8') as archivo_entrada:
        texto = archivo_entrada.read()
    
    texto_cifrado = cifrar_cesar(texto, desplazamiento)
    
    with open(output_file, 'w', encoding='utf-8') as archivo_salida:
        archivo_salida.write(texto_cifrado)
    
    print("\n✅ Archivo Cifrado Correctamente. :)")
    print(f"📂 Archivo Original: {input_file}")
    print(f"📝 Nombre Archivo Cifrado: {output_file}")
    #print(f"🔒 Desplazamiento usado: {desplazamiento}")
    print("\n" + "="*50)

def main():
    print("="*50)
    print("🔐 CIFRADOR CÉSAR AUTOMÁTICO 🔐".center(50))
    print("="*50)
    print("Este programa reliza el CIFRADO de un archivo de texto mediante el Cifrado César.\n")
    
    intentos = 0
    max_intentos = 3
    archivo_encontrado = False

    while intentos < max_intentos:
        input_file = input("🗂️  Introduce el nombre del archivo (añadir .txt): ").strip()
        try:
            output_file = f"{input_file.split('.')[0]}_cifrado.txt"
            cifrar_archivo(input_file, output_file)
            archivo_encontrado = True
            break
        except FileNotFoundError:
            intentos += 1
            print(f"❌ Archivo no encontrado. Intento {intentos} de {max_intentos}.\n")

    if not archivo_encontrado:
        print("🚫 Demasiados intentos fallidos. El programa se cerrará.")
        print("="*50)

if __name__ == "__main__":
    main()