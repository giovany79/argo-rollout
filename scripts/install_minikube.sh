#!/bin/bash

set -e  # Exit on error

# Instalar Podman si no está instalado
if ! command -v podman &> /dev/null; then
    echo "Instalando Podman..."
    brew install podman
fi

# Verificar si la máquina de Podman existe
MACHINE_EXISTS=$(podman machine list --format "{{.Name}}" 2>/dev/null | grep -c "podman-machine-default" || true)

if [ "$MACHINE_EXISTS" -eq 0 ]; then
    echo "Inicializando Podman machine..."
    podman machine init --cpus 4 --memory 8192 --disk-size 50
fi

# Verificar si la máquina está corriendo
MACHINE_RUNNING=$(podman machine list --format "{{.Running}}" 2>/dev/null | grep -c "true" || true)

if [ "$MACHINE_RUNNING" -eq 0 ]; then
    echo "Iniciando Podman machine..."
    podman machine start
    # Esperar a que Podman esté listo
    sleep 5
fi

# Verificar que Podman funciona
echo "Verificando Podman..."
podman ps || {
    echo "Error: Podman no está funcionando correctamente"
    exit 1
}

# Verificar si Minikube ya está instalado
if ! command -v minikube &> /dev/null; then
    echo "Descargando Minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-arm64
    
    # Instalar sin sudo - mover a un directorio local
    echo "Instalando Minikube en ~/.local/bin..."
    mkdir -p ~/.local/bin
    sudo install minikube-darwin-arm64 ~/.local/bin/minikube
    
    # Agregar al PATH si no está
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    echo "Minikube instalado en ~/.local/bin/minikube"
fi

# Eliminar cluster existente si hay problemas
echo "Limpiando configuración anterior..."
minikube delete 2>/dev/null || true

# Obtener la ruta del socket de Podman
PODMAN_SOCKET=$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null || echo "$HOME/.local/share/containers/podman/machine/podman-machine-default/podman.sock")

# Configurar el socket de Podman para Minikube
export CONTAINER_HOST="unix://${PODMAN_SOCKET}"

echo "Usando Podman socket: $CONTAINER_HOST"

# Iniciar Minikube con Podman como driver
echo "Iniciando Minikube con Podman..."
minikube start --driver=podman --container-runtime=containerd


echo "✅ Minikube instalado y corriendo con Podman!"
echo "Verifica el estado con: minikube status"

minikube status