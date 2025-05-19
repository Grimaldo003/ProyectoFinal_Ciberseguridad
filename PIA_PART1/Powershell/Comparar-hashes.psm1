
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
            Start-Sleep -Seconds 1
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`nHas excedido el número máximo de intentos ($maxAttempts)."
            Write-Host "El programa se cerrará.`n"
            Start-Sleep -Seconds 1
            exit
        }
    } while ($true)
}

# Función principal del script
function Compare-Hashes {
    Write-Host "`n*****Programa de comparación de hashes iniciado******`n"
    Start-Sleep -Seconds 1

    # Preguntar si el usuario desea iniciar la comparación
    $startComparison = Get-ValidYesNo -prompt "¿Desea iniciar la comparación de hashes? (s/n)"
    if ($startComparison -eq 'n') {
        Write-Host "`nPrograma terminado por el usuario.`n"
        Start-Sleep -Seconds 1
        exit
    }

    # Obtener el directorio actual para buscar config.csv
    $directory = (Get-Location).Path

    # Verificar si existe el archivo de configuración
    $configFile = Join-Path -Path $directory -ChildPath "config.csv"
    if (-not (Test-Path -Path $configFile)) {
        Write-Host "`nNo se encontró el archivo de configuración ($configFile). Por favor, ejecute primero el script para generar hashes y la configuración.`n"
        Start-Sleep -Seconds 1
        exit
    }

    # Leer el directorio y la extensión desde config.csv
    $config = Import-Csv -Path $configFile
    if (-not $config.Directory -or -not $config.Extension) {
        Write-Host "`nEl archivo de configuración ($configFile) está incompleto o corrupto.`n"
        Start-Sleep -Seconds 1
        exit
    }

    $directory = $config.Directory
    $extension = "." + $config.Extension
    Write-Host "Directorio leído: $directory"
    Write-Host "Extensión leída: $extension"

    # Validar la extensión
    if (-not ($config.Extension -match '^[a-zA-Z0-9]+$')) {
        Write-Host "`nLa extensión en el archivo de configuración ($configFile) no es válida.`n"
        Start-Sleep -Seconds 1
        exit
    }

    # Verificar si el directorio existe
    if (-not (Test-Path -Path $directory -PathType Container)) {
        Write-Host "`nEl directorio especificado en la configuración ($directory) no existe.`n"
        Start-Sleep -Seconds 1
        exit
    }

    # Verificar si existe el archivo de referencia
    $referenceFile = Join-Path -Path $directory -ChildPath "hashes_referencia.csv"
    if (-not (Test-Path -Path $referenceFile)) {
        Write-Host "`nNo se encontró el archivo de referencia ($referenceFile). Por favor, ejecute primero el script para generar hashes.`n"
        Start-Sleep -Seconds 1
        exit
    }

    # Cargar los hashes de referencia
    $hashesViejos = Import-Csv -Path $referenceFile
    Write-Host "`nCargado el archivo de referencia: $referenceFile`n"
    Start-Sleep -Seconds 1

    # Obtener la lista de archivos actuales con la extensión especificada
    $files = Get-ChildItem -Path $directory -Filter "*$extension" -File

    # Verificar si se encontraron archivos
    if ($files.Count -eq 0) {
        Write-Host "`nNo se encontraron archivos con la extensión $extension en el directorio $directory.`n"
        Start-Sleep -Seconds 1
        return
    }

    # Calcular los hashes actuales
    $hashesNuevos = @()
    foreach ($file in $files) {
        $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
        $hashesNuevos += [PSCustomObject]@{
            Path = $file.FullName
            Hash = $hash.Hash
        }
    }

    # Comparar hashes
    Write-Host "`n*****Resultados de la comparación*****`n"
    Start-Sleep -Seconds 1
    $cambiosDetectados = $false

    # Verificar archivos en el directorio actual contra los de referencia
    foreach ($nuevo in $hashesNuevos) {
        $viejo = $hashesViejos | Where-Object { $_.Path -eq $nuevo.Path }
        if ($viejo) {
            if ($nuevo.Hash -eq $viejo.Hash) {
                Write-Host "Archivo: $($nuevo.Path)"
                Write-Host "Estado: Sin cambios (Hash: $($nuevo.Hash))."
                Write-Host "--------------------------------------"
                Start-Sleep -Seconds 1
            } else {
                Write-Host "Archivo: $($nuevo.Path)"
                Write-Host "Estado: MODIFICADO"
                Write-Host "Hash antiguo: $($viejo.Hash)"
                Write-Host "Hash nuevo: $($nuevo.Hash)"
                Write-Host "--------------------------------------"
                Start-Sleep -Seconds 1
                $cambiosDetectados = $true
            }
        } else {
            Write-Host "Archivo: $($nuevo.Path)"
            Write-Host "Estado: NUEVO (No estaba en la referencia)"
            Write-Host "Hash nuevo: $($nuevo.Hash)"
            Write-Host "--------------------------------------"
            Start-Sleep -Seconds 1
            $cambiosDetectados = $true
        }
    }

    # Verificar si hay archivos en la referencia que ya no existen
    foreach ($viejo in $hashesViejos) {
        $existe = $hashesNuevos | Where-Object { $_.Path -eq $viejo.Path }
        if (-not $existe) {
            Write-Host "Archivo: $($viejo.Path)"
            Write-Host "Estado: ELIMINADO (Ya no está en el directorio)"
            Write-Host "Hash antiguo: $($viejo.Hash)"
            Write-Host "--------------------------------------"
            Start-Sleep -Seconds 1
            $cambiosDetectados = $true
        }
    }

    if (-not $cambiosDetectados) {
        Write-Host "`nNo se detectaron cambios en los archivos.`n"
        Start-Sleep -Seconds 1
    }

    # Preguntar si el usuario desea repetir la acción
    $repeat = Get-ValidYesNo -prompt "¿Desea repetir la acción? (s/n)"
    if ($repeat -eq 's') {
        Compare-Hashes
    }
}

# Ejecutar la función principal
Compare-Hashes
