# Configurar el modo estricto para evitar errores comunes
Set-StrictMode -Version Latest

# Configurar codificación UTF-8 para la consola
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Ruta donde se encuentran los módulos
$modulePath = ".\modulos"

# Importar los módulos
try {
    Import-Module -Name "$modulePath\Generar-hashes.psm1" -ErrorAction Stop
    Import-Module -Name "$modulePath\Comparar-hashes.psm1" -ErrorAction Stop
    Import-Module -Name "$modulePath\Procesos-sospechosos.psm1" -ErrorAction Stop
} catch {
    Write-Host "`n`tError al importar modulos: $_ `n" -ForegroundColor Red
    Write-Host "`tAsegurese de que los archivos Generar-hashes.psm1, Comparar-hashes.psm1 y Procesos_maliciosos.psm1 estén en $modulePath.`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    exit
}

# Función para validar la opción del menú
function Get-ValidMenuOption {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        Write-Host "`n`t$prompt" -ForegroundColor Cyan
        $response = Read-Host "`t"
        if ($response -match '^[1-5]$') {
            Write-Host "`n`tOpcion valida seleccionada." -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $response
        } else {
            Write-Host "`n`tError: Ingrese solo un numero del 1 al 5." -ForegroundColor Red
            Write-Host "`tIntento $attempts de $maxAttempts.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`n`tHas excedido el numero maximo de intentos ($maxAttempts)." -ForegroundColor Red
            Write-Host "`tEl programa se cerrara.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            Write-Host "`n`tGracias por usar el Sistema de Seguridad." -ForegroundColor Green
            Write-Host "`tHasta pronto.`n" -ForegroundColor Green
            Start-Sleep -Seconds 3
            exit
        }
    } while ($true)
}

# Función para validar la respuesta de continuar
function Get-ValidContinueOption {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        Write-Host "`n`t$prompt" -ForegroundColor Cyan
        $response = Read-Host "`t"
        if ($response -match '^[sn]$') {
            Write-Host "`n`tOpcion valida seleccionada." -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $response
        } else {
            Write-Host "`n`tError: Ingrese solo 's' (si) o 'n' (no)." -ForegroundColor Red
            Write-Host "`tIntento $attempts de $maxAttempts.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`n`tHas excedido el numero maximo de intentos ($maxAttempts)." -ForegroundColor Red
            Write-Host "`tEl programa se cerrara.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            Write-Host "`n`tGracias por usar el Sistema de Seguridad." -ForegroundColor Green
            Write-Host "`tHasta pronto.`n" -ForegroundColor Green
            Start-Sleep -Seconds 3
            exit
        }
    } while ($true)
}

# Función para mostrar la ayuda
function Show-Help {
    Write-Host "`n`n=============================================================" -ForegroundColor Cyan
    Write-Host "`tAyuda del Sistema" -ForegroundColor Green
    Write-Host "=============================================================`n" -ForegroundColor Cyan
    Write-Host "`tEste programa ofrece las siguientes opciones:`n" -ForegroundColor White
    Write-Host "`t1. Obtener hashes de un tipo de extension" -ForegroundColor Yellow
    Write-Host "`t   - Calcula los hashes SHA256 de archivos con una extension especifica."
    Write-Host "`t2. Comparar hashes" -ForegroundColor Yellow
    Write-Host "`t   - Compara los hashes actuales con los almacenados previamente."
    Write-Host "`t3. Analizar procesos maliciosos" -ForegroundColor Yellow
    Write-Host "`t   - Analiza procesos en ejecucion buscando anomalias."
    Write-Host "`t4. Ayuda" -ForegroundColor Yellow
    Write-Host "`t   - Muestra esta informacion."
    Write-Host "`t5. Cerrar Programa" -ForegroundColor Yellow
    Write-Host "`t   - Finaliza el programa.`n"
    Start-Sleep -Seconds 5
}

# Función principal del menú
function Main-Menu {
    # Bienvenida inicial
    Write-Host "`n`n=============================================================`n" -ForegroundColor Cyan
    Write-Host "`tBienvenido al Sistema de Seguridad" -ForegroundColor Green
    Write-Host "`n=============================================================`n" -ForegroundColor Cyan
    Start-Sleep -Seconds 2

    do {
        # Mostrar las opciones
        Write-Host "`n`t¿Que desea hacer?`n" -ForegroundColor White
        Write-Host "`t1. Obtener hashes de un tipo de extension" -ForegroundColor Yellow
        Write-Host "`t2. Comparar hashes" -ForegroundColor Yellow
        Write-Host "`t3. Analizar procesos maliciosos" -ForegroundColor Yellow
        Write-Host "`t4. Ayuda" -ForegroundColor Yellow
        Write-Host "`t5. Cerrar programa`n" -ForegroundColor Yellow

        $option = Get-ValidMenuOption -prompt "Ingrese una opcion (1-5)"

        switch ($option) {
            "1" {
                Write-Host "`n`tIniciando Generacion de Hashes..." -ForegroundColor Green
                Start-Sleep -Seconds 2
                try {
                    Main
                } catch {
                    Write-Host "`n`tError al generar hashes: $_" -ForegroundColor Red
                    Start-Sleep -Seconds 2
                }
            }
            "2" {
                Write-Host "`n`tIniciando Comparacion de Hashes..." -ForegroundColor Green
                Start-Sleep -Seconds 2
                try {
                    Compare-Hashes
                } catch {
                    Write-Host "`n`tError al comparar hashes: $_" -ForegroundColor Red
                    Start-Sleep -Seconds 2
                }
            }
            "3" {
                Write-Host "`n`tIniciando Analisis de Procesos Maliciosos..." -ForegroundColor Green
                Start-Sleep -Seconds 2
                try {
                    Detect-SuspiciousProcesses
                } catch {
                    Write-Host "`n`tError al analizar procesos: $_" -ForegroundColor Red
                    Start-Sleep -Seconds 2
                }
            }
            "4" {
                Show-Help
            }
            "5" {
                Write-Host "`n`tGracias por usar el Sistema de Seguridad." -ForegroundColor Green
                Write-Host "`tHasta pronto.`n" -ForegroundColor Green
                Start-Sleep -Seconds 3
                exit
            }
        }

        # Preguntar si desea continuar
        if ($option -ne "5") {
            $continue = Get-ValidContinueOption -prompt "¿Desea elegir otra opcion? (s/n):"
            if ($continue -eq 'n') {
                Write-Host "`n`tGracias por usar el Sistema de Seguridad." -ForegroundColor Green
                Write-Host "`tHasta pronto.`n" -ForegroundColor Green
                Start-Sleep -Seconds 3
                exit
            }
        }
    } while ($true)
}

# Ejecutar el menú principal
Main-Menu