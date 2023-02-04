# writeEventViewer-CobianBackup
Script básico para escribir en el visor de eventos de Windows
Script básico para escribir en el visor de eventos de Windows.

Este script nos permitirá:
* Comprobar estado de la copia de seguridad de Cobian Backup.
* Crear un nuevo Log en el Registro de eventos de Windows.
* Marcar un 0 o un 1 la salida del script dependiendo del estado del backup (0 - Correcto | 1 - Incorrecto).
* Dejar constancia en el visor de eventos del estado de la tarea de backup.

¿Cómo funciona?
======
Este script realiza la comprobación de los logs de Cobian Backup 11, guardados en la ruta por defecto que establece el programa. Luego comprueba si existe en el visor de eventos el contenedor Backup Cobian. Si no existe lo crea, si existe entoces escribe si la finalizacion del backup ha sido exitosa o incorrecta, mediante los estados 0 para tarea correcta y 1 para tarea incorrecta.

Posibles utilidades
======
* Personalmente, lo uso para que una app pueda leer el visor de eventos y pueda establecer mediante avisos si el backup es correcto o incorrecto

Implementación en Cobian Backup
======
Es importante que Cobian ejecute el script después de terminar la tarea. Dentro de todas las tareas de Cobian hay un apartado para poder ejecutar scripts personalizados.
Cobian NO puede ejecutar por si solo scripts *.ps1, solamente ejecuta .bat o .cmd. Seguidamente adjunto un ejemplo de .bat de llamada al script escrito en PowerShell:
*** powershell -ExecutionPolicy ByPass -File "Ruta_del_script_ps1" ***
