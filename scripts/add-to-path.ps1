Write-Host "=== Agregando herramientas al PATH permanentemente ==="

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($userPath -notlike "*$env:USERPROFILE*") {
    Write-Host "Agregando $env:USERPROFILE al PATH del usuario..."
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$env:USERPROFILE", "User")
    Write-Host "PATH actualizado. Reinicia PowerShell para que los cambios surtan efecto."
} else {
    Write-Host "$env:USERPROFILE ya está en el PATH"
}

Write-Host ""
Write-Host "Herramientas disponibles en $env:USERPROFILE:"
Get-ChildItem "$env:USERPROFILE\*.exe" | Select-Object Name

Write-Host ""
Write-Host "Para usar las herramientas en esta sesión, ejecuta:"
Write-Host '$env:Path += ";$env:USERPROFILE"'
