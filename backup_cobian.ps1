####################################################################################################################################
# Desripción Script: Este script revisa los errores del log de Cobian Backup y emite un error en el Registro de Eventos de Windows #
# dependiendo del catalogo de errores que se establece en el apartado "ErrorPatterns".                                             #
# Autor: Marc Esteve                                                                                                               #
# Organización: Accon Software SL                                                                                                  #
# Versión: v2.4.1                                                                                                                    #
# Fecha: 11/02/2025                                                                                                                #
####################################################################################################################################

# Ruta del archivo de log de Cobian Backup
$date = Get-Date -Format "yyyy-MM-dd"
#$logFile = "C:\Program Files\Cobian Reflector\Logs\Cobian Reflector $date.txt"

# Definir rutas posibles para los logs de Cobian Backup 11 y Cobian Reflector
$logPaths = @(
    "C:\Program Files (x86)\Cobian Backup 11\Logs\log $date.txt",
    "C:\Program Files\Cobian Backup 11\Logs\log $date.txt",
    "C:\Program Files (x86)\Cobian Reflector\Logs\Cobian Reflector $date.txt",
    "C:\Program Files\Cobian Reflector\Logs\Cobian Reflector $date.txt"
)

# Buscar cuál de las rutas existe
$logFile = $null
foreach ($path in $logPaths) {
    if (Test-Path $path) {
        $logFile = $path
        break
    }
}

# Función para registrar eventos en el visor de eventos de Windows
function Register-Event {
    param (
        [string]$message,
        [int]$eventId,
        [string]$source = "Backup Cobian"
    )

    # Asegurar que la fuente de eventos existe
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        New-EventLog -LogName $source -Source $source
    }

    # Registrar el evento
    if($eventId -eq 0){
        Write-EventLog -LogName $source -Source $source -EventId $eventId -Message $message -EntryType Information
    }else{
        if($eventId -eq 9999){
            Write-EventLog -LogName $source -Source $source -EventId $eventId -Message $message -EntryType Error
        }else{
            Write-EventLog -LogName $source -Source $source -EventId $eventId -Message $message -EntryType Error
        }
    }
    
}

# Si no se encontró el log, registrar un evento en Windows y salir
if (-not $logFile) {
    $message = "No se encontró el log de Cobian Backup 11 ni Cobian Reflector. Verifica la instalación."
    Register-Event -message $message -eventId 9001
    exit 1
}

# Función para analizar el log
function Analyze-Log {
    param (
        [string]$logFile
    )

    # Leer el contenido del log en una sola variable
    $logContent = Get-Content -Path $logFile -Raw

    # Definir patrones de error con expresiones regulares
    $errorPatterns = @{
        "No se pudo contactar el solicitador de Volume Shadow Copy"= 1001
        "El proceso no tiene acceso al archivo porque está siendo utilizado por otro proceso" = 1002
        "The process cannot access the file because it is being used by another process" = 1002
        "Espacio en disco insuficiente" = 1003
        "There is not enough space on the disk" = 1003
        "El proceso no tiene acceso al archivo porque otro proceso tiene bloqueada una parte del archivo"= 1004
        "El solicitador de imágenes instantáneas de volumen (VSC) no está disponible" = 1005
        "El nombre de archivo, el nombre de directorio o la sintaxis de la etiqueta del volumen no son correctos" = 1006
        "Uno o más errores han ocurrido mientras se creaba una imagen instantánea de volumen (VSC)."= 1007
        "One or more errors occurred while creating the Volume Shadow Copy image" = 1007
        "Access is denied" = 1008
        "Acceso Denegado" = 1008
        "The filename, directory name, or volume label syntax is incorrect" = 1009
        "Un error ha ocurrido mientras se comprobaba la existencia de nuevas versiones: Connect timed out." = 1010
        "El sistema no puede encontrar la ruta especificada" = 1011
        "The system cannot find the path specified" = 1011
        "El sistema no puede encontrar el archivo especificado" = 1012
        "The user name or password is incorrect" = 1013
        "El nombre de usuario o la contraseña no son correctos" = 1013
        "The specified network name is no longer available" = 1014
    }

    $EventID = 9999  # Valor por defecto si no se encuentra coincidencia exacta

    # Buscar patrones de error en el log completo
    foreach ($pattern in $errorPatterns.Keys) {
        if ($logContent -match [regex]::Escape($pattern)) {
            $EventID = $ErrorPatterns[$Pattern]
            Register-Event -message "Error encontrado: $pattern" -eventId $EventID
            return
        }
    }

    # Si no se detectó ningún error conocido, verificar si aparece "ERR"
    if ($EventID -eq 9999) {
        if ($logContent -cmatch "\bERR\b"){
        Register-Event -message "Error no catalogado" -eventId $EventID
        }else{
            $EventID = 0 # Backup completado correctamente
            Register-Event -message "Backup Completado Correctamente" -eventId $EventID
        }
    }
}

# Ejecutar la función de análisis del log
Analyze-Log -logFile $logFile