# Configurar codificacion UTF-8 para la consola
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Funcion para validar la respuesta de si/no
function Get-ValidYesNo {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        Write-Host "`n`t$prompt" -ForegroundColor Cyan
        $response = Read-Host "`t"
        if ($response -eq 's' -or $response -eq 'n') {
            Write-Host "`n`tEntrada valida aceptada." -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $response
        } else {
            Write-Host "`n`tError: Ingrese solo 's' (si) o 'n' (no). No se permiten otros caracteres, espacios o numeros." -ForegroundColor Red
            Write-Host "`tIntento $attempts de $maxAttempts.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`n`tHas excedido el numero maximo de intentos ($maxAttempts)." -ForegroundColor Red
            Write-Host "`tRetornando al menu principal.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            return 'n'  # Retorna 'n' para indicar que no se desea continuar
        }
    } while ($true)
}

# Funcion para validar la accion a tomar
function Get-ValidAction {
    param (
        [string]$prompt,
        [int]$maxAttempts = 3
    )
    $attempts = 0
    do {
        $attempts++
        Write-Host "`n`t$prompt" -ForegroundColor Cyan
        $response = Read-Host "`t"
        if ($response -in @('1', '2', '3', '4')) {
            Write-Host "`n`tOpcion valida seleccionada." -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $response
        } else {
            Write-Host "`n`tError: Ingrese solo 1, 2, 3 o 4. No se permiten otros caracteres, espacios o numeros." -ForegroundColor Red
            Write-Host "`tIntento $attempts de $maxAttempts.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
        if ($attempts -ge $maxAttempts) {
            Write-Host "`n`tHas excedido el numero maximo de intentos ($maxAttempts)." -ForegroundColor Red
            Write-Host "`tIgnorando la accion y continuando.`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            return '4'  # Retorna '4' para indicar que se ignora la accion
        }
    } while ($true)
}

# Funcion principal para detectar procesos sospechosos
function Detect-SuspiciousProcesses {
    Write-Host "`n`n=============================================================" -ForegroundColor Cyan
    Write-Host "`tDetector de Procesos Sospechosos" -ForegroundColor Green
    Write-Host "=============================================================`n" -ForegroundColor Cyan
    Start-Sleep -Seconds 2

    # Preguntar si desea iniciar el analisis
    $startAnalysis = Get-ValidYesNo -prompt "¿Desea iniciar la deteccion de procesos sospechosos? (s/n)"
    if ($startAnalysis -eq 'n') {
        Write-Host "`n`tAnalisis cancelado por el usuario." -ForegroundColor Yellow
        Write-Host "`tRetornando al menu principal...`n" -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        return  # Retorna al menu principal
    }

    # Crear directorios de logs y cuarentena si no existen
    $logDir = "C:\Logs"
    $quarantineDir = "C:\Quarantine"
    foreach ($dir in @($logDir, $quarantineDir)) {
        if (-not (Test-Path -Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
            Write-Host "`n`tDirectorio creado en: $dir" -ForegroundColor Green
            Start-Sleep -Seconds 1
        }
    }

    # Inicializar lista de procesos sospechosos
    $suspiciousProcesses = @()
    $processes = Get-Process | Where-Object { $_.Path }

    Write-Host "`n`tAnalizando procesos en ejecucion..." -ForegroundColor Cyan
    Start-Sleep -Seconds 1

    # Lista de procesos comunes y sus ubicaciones esperadas
    $knownProcesses = @{
        "svchost" = "C:\Windows\System32\svchost.exe"
        "explorer" = "C:\Windows\explorer.exe"
    }

    # Analizar cada proceso
    foreach ($proc in $processes) {
        $filePath = $proc.Path
        $isSuspicious = $false
        $reason = ""

        # Verificar firma digital
        $signature = Get-AuthenticodeSignature -FilePath $filePath -ErrorAction SilentlyContinue
        if ($signature.Status -ne "Valid") {
            $isSuspicious = $true
            $reason += "Firma digital no valida o ausente. "
        }

        # Verificar ubicacion esperada
        $procName = $proc.Name.ToLower()
        if ($knownProcesses.ContainsKey($procName)) {
            $expectedPath = $knownProcesses[$procName]
            if ($filePath -ne $expectedPath) {
                $isSuspicious = $true
                $reason += "Ubicacion no esperada (esperado: $expectedPath). "
            }
        }

        if ($isSuspicious) {
            $suspiciousProcesses += [PSCustomObject]@{
                Name = $proc.Name
                Path = $filePath
                PID = $proc.Id
                CPU = $proc.CPU
                Reason = $reason.Trim()
                TimeDetected = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            }
        }
    }

    # Mostrar resultados
    Write-Host "`n`t=============================================================" -ForegroundColor Cyan
    Write-Host "`tResultados del Analisis" -ForegroundColor Green
    Write-Host "`t=============================================================`n" -ForegroundColor Cyan
    Start-Sleep -Seconds 1

    if ($suspiciousProcesses.Count -eq 0) {
        Write-Host "`tNo se detectaron procesos sospechosos." -ForegroundColor Green
        Start-Sleep -Seconds 2
    } else {
        Write-Host "`tSe detectaron $($suspiciousProcesses.Count) procesos sospechosos:`n" -ForegroundColor Yellow
        $suspiciousProcesses | Format-Table -Property Name, PID, Path, Reason -AutoSize
        Start-Sleep -Seconds 3

        # Permitir al usuario tomar acciones por cada proceso
        foreach ($proc in $suspiciousProcesses) {
            Write-Host "`n`t-------------------------------------------------------------" -ForegroundColor Cyan
            Write-Host "`tProceso: $($proc.Name) (PID: $($proc.PID))" -ForegroundColor Yellow
            Write-Host "`tRuta: $($proc.Path)" -ForegroundColor Yellow
            Write-Host "`tRazon: $($proc.Reason)" -ForegroundColor Yellow
            Write-Host "`t-------------------------------------------------------------`n" -ForegroundColor Cyan
            Start-Sleep -Seconds 1

            $action = Get-ValidAction -prompt "Seleccione una accion:`n`t1. Terminar proceso`n`t2. Mover a cuarentena`n`t3. Escanear con Windows Defender`n`t4. Ignorar`n`tOpcion (1-4):"
            switch ($action) {
                "1" {
                    try {
                        Stop-Process -Id $proc.PID -Force -ErrorAction Stop
                        Write-Host "`n`tProceso terminado exitosamente." -ForegroundColor Green
                        $logEntry = [PSCustomObject]@{
                            Time = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                            Action = "Terminated process"
                            PID = $proc.PID
                            Path = $proc.Path
                        }
                        $logEntry | Export-Csv -Path "$logDir\action_log.csv" -Append -NoTypeInformation -Encoding UTF8
                    } catch {
                        Write-Host "`n`tError al terminar el proceso: $_" -ForegroundColor Red
                    }
                    Start-Sleep -Seconds 2
                }
                "2" {
                    try {
                        $quarantinePath = "$quarantineDir\$($proc.Name)_$(Get-Date -Format 'yyyyMMdd_HHmmss').exe"
                        Move-Item -Path $proc.Path -Destination $quarantinePath -Force -ErrorAction Stop
                        Write-Host "`n`tArchivo movido a cuarentena: $quarantinePath" -ForegroundColor Green
                        $logEntry = [PSCustomObject]@{
                            Time = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                            Action = "Moved to quarantine"
                            PID = $proc.PID
                            Path = $proc.Path
                            QuarantinePath = $quarantinePath
                        }
                        $logEntry | Export-Csv -Path "$logDir\action_log.csv" -Append -NoTypeInformation -Encoding UTF8
                    } catch {
                        Write-Host "`n`tError al mover a cuarentena: $_" -ForegroundColor Red
                    }
                    Start-Sleep -Seconds 2
                }
                "3" {
                    try {
                        Start-MpScan -ScanPath $proc.Path -ErrorAction Stop
                        Write-Host "`n`tEscaneo con Windows Defender iniciado." -ForegroundColor Green
                        $logEntry = [PSCustomObject]@{
                            Time = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                            Action = "Scanned with Windows Defender"
                            PID = $proc.PID
                            Path = $proc.Path
                        }
                        $logEntry | Export-Csv -Path "$logDir\action_log.csv" -Append -NoTypeInformation -Encoding UTF8
                    } catch {
                        Write-Host "`n`tError al iniciar el escaneo: $_" -ForegroundColor Red
                    }
                    Start-Sleep -Seconds 2
                }
                "4" {
                    Write-Host "`n`tProceso ignorado." -ForegroundColor Yellow
                    Start-Sleep -Seconds 2
                }
            }
        }
    }

    # Guardar resultados en CSV
    $logFile = "$logDir\suspicious_processes.csv"
    $suspiciousProcesses | Export-Csv -Path $logFile -NoTypeInformation -Encoding UTF8
    Write-Host "`n`tResultados guardados en: $logFile" -ForegroundColor Green
    Start-Sleep -Seconds 2

    # Preguntar si desea repetir el analisis
    $repeat = Get-ValidYesNo -prompt "¿Desea repetir el analisis? (s/n)"
    if ($repeat -eq 's') {
        Detect-SuspiciousProcesses
    } else {
        # Preguntar si desea regresar al menu principal o cerrar el programa
        $continue = Get-ValidYesNo -prompt "¿Desea regresar al menu principal? (s/n)"
        if ($continue -eq 's') {
            Write-Host "`n`tRetornando al menu principal...`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            return  # Retorna al menu principal
        } else {
            Write-Host "`n`tCerrando el programa...`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            exit  # Cierra el programa
        }
    }
}

# Ejecutar la funcion principal
Detect-SuspiciousProcesses