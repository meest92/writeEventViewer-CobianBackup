# writeEventViewer-CobianBackup
Script básico para escribir en el visor de eventos de Windows
Script básico para escribir en el visor de eventos de Windows.

Este script nos permitirá:
* Comprobar estado de la copia de seguridad de Cobian Backup.
* Crear un nuevo Log en el Registro de eventos de Windows.
* Discriminar errores en el log, marcando patrones como ID's de error.
* Dejar constancia en el visor de eventos del estado de la tarea de backup.

¿Cómo funciona?
======
Este script realiza la comprobación de los logs de Cobian Backup 11 y Cobian Reflector, guardados en la ruta por defecto que establece el programa. Luego comprueba si existe en el visor de eventos el contenedor Backup Cobian. Si no existe lo crea, si existe entoces escribe en el visor el estado del ultimo log, discriminando segun el error que marca Cobian con diferentes ID's. Si es backup ha sido correcto, el ID que marcará en el Visor de Eventos serà un 0, si no sabe interpretar el error porque no esta dentro de los patrones, nos marcará con un ID 9999.

Posibles utilidades
======
* Personalmente, lo uso para que una app pueda leer el visor de eventos y pueda establecer mediante avisos si el backup es correcto o incorrecto

Implementación en Cobian Backup
======
Es importante que Cobian ejecute el script después de terminar la tarea. Dentro de todas las tareas de Cobian hay un apartado para poder ejecutar scripts personalizados.
Cobian NO puede ejecutar por si solo scripts *.ps1, solamente ejecuta .bat o .cmd. Seguidamente adjunto un ejemplo de .bat de llamada al script escrito en PowerShell:
*** powershell -ExecutionPolicy ByPass -File "Ruta_del_script_ps1" ***
