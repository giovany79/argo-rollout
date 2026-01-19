$ErrorActionPreference = "Stop"

Write-Host "Verificando Docker Desktop..."
$dockerRunning = docker ps 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker Desktop no está corriendo. Por favor inicia Docker Desktop y vuelve a intentar."
    exit 1
}

Write-Host "Docker Desktop está corriendo correctamente"

if (!(Get-Command minikube -ErrorAction SilentlyContinue)) {
    Write-Host "Minikube no está instalado. Instalando..."
    
    $minikubeUrl = "https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe"
    $minikubePath = "$env:USERPROFILE\minikube.exe"
    
    Write-Host "Descargando Minikube..."
    Invoke-WebRequest -Uri $minikubeUrl -OutFile $minikubePath
    
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$env:USERPROFILE*") {
        Write-Host "Agregando $env:USERPROFILE al PATH del usuario..."
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$env:USERPROFILE", "User")
        $env:Path = "$env:Path;$env:USERPROFILE"
    }
    
    Write-Host "Minikube instalado en $minikubePath"
    Write-Host "Reinicia PowerShell si 'minikube' no es reconocido después de este script"
}

Write-Host "Limpiando configuración anterior..."
minikube delete 2>$null

Write-Host "Iniciando Minikube con Docker..."
minikube start --driver=docker

Write-Host "Minikube instalado y corriendo con Docker!"
Write-Host "Verifica el estado con: minikube status"

minikube status
