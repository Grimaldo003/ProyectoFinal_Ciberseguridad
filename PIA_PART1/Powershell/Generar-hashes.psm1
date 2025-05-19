
# Función para validar la ruta del directorio
function Get-ValidDirectory {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        $directory = Read-Host $prompt
        if ($directory -match '^[a-zA-Z]:\\[\w\s\\.-]+$') {
            if (Test-Path -Path $directory -PathType Container) {
                return $directory
            } else {
                Write-Host "`nLa ruta ingresada no existe o no es un directorio. Por favor, ingrese una ruta correcta."
                Write-Host "Intento $attempts de $maxAttempts.`n"
            }
        } else {
            Write-Host "`nLa ruta ingresada no es válida. Ejemplo: C:\Users\Documentos"
            Write-Host "Intento $attempts de $maxAttempts.`n"
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`nHas excedido el número máximo de intentos ($maxAttempts)."
            Write-Host "El programa se cerrará.`n"
            Start-Sleep -Seconds 2
            exit
        }
    } while ($true)
}

# Función para validar la extensión del archivo
function Get-ValidExtension {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        $extension = Read-Host $prompt
        if ($extension -match '^[a-zA-Z0-9]+$') {
            return $extension
        } else {
            Write-Host "`nLa extensión debe contener solo letras y/o números (sin espacios ni caracteres especiales). Ejemplo: txt, jpg, mp3, docx, 7zip"
            Write-Host "Intento $attempts de $maxAttempts.`n"
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`nHas excedido el número máximo de intentos ($maxAttempts)."
            Write-Host "El programa se cerrará.`n"
            Start-Sleep -Seconds 2
            exit
        }
    } while ($true)
}

# Función para validar la respuesta de sí/no
function Get-ValidYesNo {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        $response = Read-Host $prompt
        if ($response -eq 's' -or $response -eq 'n') {
            return $response
        } else {
            Write-Host "`nPor favor, ingrese solo 's' (sí) o 'n' (no).`n"
            Write-Host "Intento $attempts de $maxAttempts.`n"
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`nHas excedido el número máximo de intentos ($maxAttempts)."
            Write-Host "El programa se cerrará.`n"
            Start-Sleep -Seconds 2
            exit
        }
    } while ($true)
}

# Función principal del script
function Main {
    do {
        Write-Host "`n*****Programa iniciado******`n"
        # Preguntar si los archivos están en el directorio actual
        $response = Get-ValidYesNo -prompt "¿Los archivos se encuentran en el directorio actual? (s/n)"
        if ($response -eq 's') {
            $directory = (Get-Location).Path  # Convertir a string
        } else {
            $directory = Get-ValidDirectory -prompt "Ingrese la ruta del directorio donde se encuentran los archivos (ejemplo: C:\Users\Documentos):"
        }

        # Preguntar la extensión de los archivos
        $extension = Get-ValidExtension -prompt "Ingrese la extensión de los archivos (ejemplo: txt, jpg, mp3):"
        $extensionWithDot = "." + $extension

        # Obtener la lista de archivos con la extensión especificada
        $files = Get-ChildItem -Path $directory -Filter "*$extensionWithDot" -File

        # Verificar si se encontraron archivos
        if ($files.Count -eq 0) {
            Write-Host "`nNo se encontraron archivos con la extensión $extensionWithDot en el directorio $directory.`n"
        } else {
            # Crear una lista para almacenar los hashes
            $hashList = @()

            # Calcular y mostrar los hashes de los archivos
            foreach ($file in $files) {
                $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
                Write-Host "`n`nArchivo: $($file.Name)"
                Write-Host "Directorio: $($file.DirectoryName)"
                Write-Host "Hash (SHA256): $($hash.Hash)`n"
                Write-Host "--------------------------------------`n`n"

                # Agregar el hash a la lista
                $hashList += [PSCustomObject]@{
                    Path = $file.FullName
                    Hash = $hash.Hash
                    Date = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                }
            }

            # Preguntar si el usuario desea guardar los hashes
            $saveHashes = Get-ValidYesNo -prompt "¿Desea guardar los hashes en un archivo de referencia? (s/n)"
            if ($saveHashes -eq 's') {
                $outputFile = Join-Path -Path $directory -ChildPath "hashes_referencia.csv"
                $hashList | Export-Csv -Path $outputFile -NoTypeInformation
                Write-Host "`nLos hashes han sido guardados en: $outputFile`n"

                # Guardar la configuración en config.csv
                $configFile = Join-Path -Path $directory -ChildPath "config.csv"
                [PSCustomObject]@{
                    Directory = $directory
                    Extension = $extension
                } | Export-Csv -Path $configFile -NoTypeInformation
                Write-Host "Configuración guardada en: $configFile`n"
            }
        }

        # Preguntar si el usuario desea repetir la acción
        $repeat = Get-ValidYesNo -prompt "¿Desea repetir la acción? (s/n)"
    } while ($repeat -eq 's')
}

# Ejecutar la función principal
Main
