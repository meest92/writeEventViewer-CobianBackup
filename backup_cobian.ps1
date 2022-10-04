$date = Get-Date -Format "yyyy-MM-dd"
$file = "C:\Program Files (x86)\Cobian Backup 11\Logs\log $date.txt"
$logFileExists = Get-EventLog -list | Where-Object {$_.logdisplayname -eq "Backup Cobian"}

if (! $logFileExists) {
    New-EventLog -LogName "Backup Cobian" -Source "Backup Cobian"
    }
if(Select-String -Path $file -Pattern "ERR" -CaseSensitive){
	Write-EventLog -log "Backup Cobian" -source "Backup Cobian" -EntryType Error -eventID 1 -Message "Se ha producido un error en la copia de seguridad de Cobian. Revise los logs."
        }else {
        	Write-EventLog -log "Backup Cobian" -source "Backup Cobian" -EntryType Information -eventID 0 -Message "Backup de Cobian realizado sin errores"
        }    